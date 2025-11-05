Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E07CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C5C8E000D; Wed,  5 Nov 2025 05:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD0A8E0003; Wed,  5 Nov 2025 05:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19F78E000D; Wed,  5 Nov 2025 05:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC808E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:28:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3434DC0126
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:28:08 +0000 (UTC)
X-FDA: 84076178256.24.9F7056D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8065A1C0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:28:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4NOZ3+F;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762338486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ad+V6fAK+j+u8NaKnUH9lw3aG6YKBTvitNb1tCqP7WU=;
	b=techo+fWohUx4xRKTVVjRhyCF0TAtaB4p9DK9FS3rj9XtL5I8hSZBN589pDv5qxLKUDgjQ
	PalyX3wHTmKmbAme+XmGYDuN/LIrHJxELOK4WqTEH8oeMdWHasvif/RwCjF0fvv/M9BrPG
	IbDimw1I7HrZR7Ne0W0MwPZHRzrVh0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762338486; a=rsa-sha256;
	cv=none;
	b=QFsKaN+JzDrr+dqSOmrUYt0iea3yyuuiedimTJmfvvzm3HNY6QUL/vxP/esi4q/tq0a685
	mSpiU8pHejVxOI8CuHSAaYNu7zROMO/VorhJqZmGWo/6CCLM8FHt9ZHFVpi+kNAnrUDd2g
	TPh0TKFFuaQ9iWiIbA6imnBz7TvTybY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4NOZ3+F;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86A1B447DA;
	Wed,  5 Nov 2025 10:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36D3C4CEFB;
	Wed,  5 Nov 2025 10:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762338485;
	bh=iGm3ztCoHBoiX+8pTAlhDOq1wez0F7WKLBUyQq+ZXxo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=J4NOZ3+F/wcCmEWLMyxtMF9GufxOdiPWEJI8FjD81Zi0epu/A0mcp8gt23izr6n4f
	 86B1xrYhjtkwryopz9jIVKj4zX0kBJ0++ccJSdXCtujeMEIYOh3dvGUfB2ntWo3AAb
	 kF/D7CDVvSaaGZpJuCFOkJEDRVWoHv39Vumf2zgRucUeJZVAADKyFzNS7hP23fCrCB
	 HMHVLNFXfG3g0z0Z+9Ozuw6YB354HaP/w5eoPMvA3vJFuURb7VS+JlBokheQDS5HKG
	 1hxJusWy8nEyoTDgDLLFEHYSTikww4QzLbCjZ90tylGShH+rC5VsGgNYutNKeRwAPC
	 5k7ucS2PrYDHQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 6/9] kho: don't unpreserve memory during abort
In-Reply-To: <20251101142325.1326536-7-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 1 Nov 2025 10:23:22 -0400")
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-7-pasha.tatashin@soleen.com>
Date: Wed, 05 Nov 2025 11:28:01 +0100
Message-ID: <mafs0ldkkbwpa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: aaqoejuajcoao7sxm3pkzder153wu5o7
X-Rspam-User: 
X-Rspamd-Queue-Id: 8065A1C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1762338486-638075
X-HE-Meta: U2FsdGVkX19rzcxY8VsHcpLuPGWcwwA6n5kN6DSDNvdSFY75H2VS3mXj5b4dkiLKBuNFP7/YM8wCNG18pZGX48/e0B0cGOUXterXi1mrDLld7EJAmhUp01EowKeiN/UDsf+qf80rNw7fFBIDTJ/pIQuYXnMhnYAeeevpfVDoLnEIwRkl7gk1/08w9CB9h/QRy+2bC+hN3WyJ/h7G9Mo7Z4d6xklMhCsfdbkMQknAXUXyF9reP3/0McCzw8nKsKOGX0wSM+lHoBm4zouGUKhaB2eIIkssBgotwJVewpfDcRmC9GO4HEgGLzg6aqmiQ6Qjbca4wW1tpoUUmkaja2pXqH/DU0w4tLmQ6oxY7CuomOq/wiV2LXwaeXNpI617BSGFSQIJoF06YsGeSc7K5JgSatxsEm/QuRzQGlWZgXEw0jy/+xNdlaniTuQaHtRk4iNjGilMajIWb6NiuRjBi9fDKLZVYfzboMm/nWBRbWygTwvMIU1FwsaDVa5BudoDR830Hv+BjpufUkkagUsRpb8fmx2kY3iyb3iLh8ayGxiY4IyGbhyKivjnf1hIlCcqFdsPLLKuSAuBZTYScm0ytvZN6Yw1UKqQQzpE9OPRZzraDEVJZXXntMe+MNPIb8cF1TNXe7SPEyEzluiZ6sJF8fz2ea0lGJ+dykO+cny/POvrcgDwFdtiXft2A1IXcsDdLyjQ1VBR7+95B/gPCdoctZKYxNz/Ozz6JDmUWnAXsomiXKrzrATDmKnq7Euj1a3Gbq/rck8ttFmmO9ns5A2NWc3FZWVShvLLY+sfePNdAKigS6jN8+GO+P4ODvwLE+bJJw+sa62x/zIl6c0r911ymwuPj1n3UcFs91qfRSEjh2vvwnFVMaL6O8l1x1hw09g587m9K9plBU46N09iagXaIIsh0fr85YCVkRzAUV/WxKnN6PM8bUAxZVMWHV9YwGgEy3FUGHsns88eMZSD1m+TKAZ
 uJqyztQL
 nu/dNbLDnXBd/WR8omOEV4rmyRUX4x6nUiepWyf2F4lW/JSB2Jf6BhEz75SxYI0iNoJj0by6MVU9z8nz9KPuAGKg/7eMLdeIUkbn69Ej8Ufj72R8Ljag6smgMNirtN0T1oeL4Lu399ivfd7Um/ZVrsY1TCfQTP8/l0BdoWiu0jLUNTYOgvFDOJ0DIXDHypisWRyBK2h52rNV0KliZ/z6MpFE7qVnaqYJJF7wvwh9nwkFmXJ0U4KBKbI0oVxxCc7w49Nxt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01 2025, Pasha Tatashin wrote:

> KHO allows clients to preserve memory regions at any point before the
> KHO state is finalized. The finalization process itself involves KHO
> performing its own actions, such as serializing the overall
> preserved memory map.
>
> If this finalization process is aborted, the current implementation
> destroys KHO's internal memory tracking structures
> (`kho_out.ser.track.orders`). This behavior effectively unpreserves
> all memory from KHO's perspective, regardless of whether those
> preservations were made by clients before the finalization attempt
> or by KHO itself during finalization.
>
> This premature unpreservation is incorrect. An abort of the
> finalization process should only undo actions taken by KHO as part of
> that specific finalization attempt. Individual memory regions
> preserved by clients prior to finalization should remain preserved,
> as their lifecycle is managed by the clients themselves. These
> clients might still need to call kho_unpreserve_folio() or
> kho_unpreserve_phys() based on their own logic, even after a KHO
> finalization attempt is aborted.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

