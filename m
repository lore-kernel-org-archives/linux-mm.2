Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E354C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A306B00D2; Wed, 12 Aug 2026 07:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BA16B00D5; Wed, 12 Aug 2026 07:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B366B00D6; Wed, 12 Aug 2026 07:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBF66B00D2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:10:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2DEF140289
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:10:29 +0000 (UTC)
X-FDA: 85092348978.27.FA89BD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25735C0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:10:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYd2zt8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnwlG71sjI06zsq7yj3kdlhgqiN/yez8QEYIr9vq9zU=;
	b=dymgWnKubKZX3DIaX2tKDVRLviOKayZRI2BZB3uMAq4Qg321U8wOcFzJJfPX/o9CPQsfaM
	eCMJvawJfIqS7klybloQ0hAffhyxoKEdNDFsTlLKJFh4wiAtMB0I7gHRC2pZiN4nxZgeNh
	PtpRL9yLqpj2uPXgimq7LZkNhFVndKM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYd2zt8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533028;
	b=MxCIlkQ1CeVWH1OqNJhe0OxeWmpt9YOXbShNji0VQXinYF+Xlhdw+IgWQmRXETlkNKM02e
	2fLSqXMKtAOXmZw9P/4CBZbiGrQia4MfiQcPJlhKQhTnZZ4sPgAz5HUWqztcDEIhPpsFRg
	fEBuHHcZJWhFmpudFS3zU3ZWCzcq4m0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 389C542A9D;
	Wed, 12 Aug 2026 11:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8941F000E9;
	Wed, 12 Aug 2026 11:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786533027;
	bh=lnwlG71sjI06zsq7yj3kdlhgqiN/yez8QEYIr9vq9zU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=WYd2zt8tfz9f3l7W2MEvjC9PgjvttrZRZQVu40gKcm//Lc2oh3g67LBMStlLwpfhS
	 xMQicXNXtVelpILEAADkxgCYL9BvY84p7BepdW1igypoiA/RTrx9ZoHqQzeH9LzhNX
	 fFGCwLPk5SyGU+QOnoKQ5AJxqETgroS26+gZ9FeDb2c9/tgO0+uDSA3AuIbv0SG8Lr
	 lJESY+GMBNpPY8804d2TiZWZe3JjdQSimESxZtndotoBUjylLoQO3lxy2eco2WxcLF
	 n+yRKhPGPH/SONjna1QhUFRHOduSa5v7P3vbI4WsU1U9gscXN1ALeSmiWs6bN71fcL
	 ssDCkH9AWO2ew==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  David Matlack <dmatlack@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] kho: Introduce preserve/restore APIs for
 high-order pages
In-Reply-To: <20260803113944.3694290-3-praan@google.com> (Pranjal
	Shrivastava's message of "Mon, 3 Aug 2026 11:39:43 +0000")
References: <20260803113944.3694290-1-praan@google.com>
	<20260803113944.3694290-3-praan@google.com>
Date: Wed, 12 Aug 2026 13:10:23 +0200
Message-ID: <2vxzmrur3880.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 5adt8zwxgfbsgkywzny3gds7ykwou3bz
X-Rspamd-Queue-Id: 25735C0008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786533027-96352
X-HE-Meta: U2FsdGVkX1/nPiMkM73fxq6aeie9AMzNdLgrl15Hkfyif1gBMG7Crgq+IjoGdpyNC74MQ2OM1ZlrnnFBxGVQAEbzimuRz17VYDeHrYtF5rGtL+SyegER092+CgJlmqylD/0k54y+holtXIMVADTFHHQlG9v6ME+0aU6mNJSnhBRlM9FrnZ4W8zudlyrvNS+NCQy5cui5CXXtL/IoJ1WoLFQcjZWNiqxKgC3vZMGvUegdZZmPm4IosX+3ADStBEf4eDedjTaRhN/ckqwzab9raiNpKtJBcbRJTrjxmx+0uxdJLEF/Yeps6SGn6fctO+M0AlYKsjTqDvbrfNZDSqm0JR9pJ1q+TakDrz/M199sxKiaG3m9CnYBFQaBptQpoLjbzuLmZbHVJxlMd9ESIOwCJUIAe6ej1JTy+DLQj5BaKx+rjtm/qbEeeh0LGyIzqXnX0t3i0CyQR+B3r/VxZFb5T1LX4pJnGiiTUp0UzK1RFCBlPsBOFhU326qawr7ZSiCvYIGsCUUDK0GB7DprnzR93pL69zRBwlcIayiXMTPGDOhn7yMx6lLTtyj5HcAW5y5fbP0NFHcrMFD5eixnhKfyoa04wBsOgEEdPeXUttVDIVhs7c/7UGagvsz9DMWFOs9OXd4KjRsPL6Mo+p817EuDM5QWr4iyuEoxsJTcNZU6KOL8Y2V1jDQi/jUrPPY5b/Hg43r/xkmYjOlirrU6n07nF4izzoEFzs3mjPP3wUqgHOnTVsSGyzREVbeHkGr5PWcshEv89uNh2DKmiLqwKBynWZbQU29peqdKnABvYcYhzFsuGF/z3omYiiHVu1P/EyQaMq83+RNYN/GVw31REkaJbQ30I/GfwqDmcVI8zVNNkIcTc7SpIwNkgCJk9N4HFuFLL/kG1lIQXSFPITInZdMam0RaYVslIGgKD30KQ8+21Mp/lMTQrSCzUFyFPHSwxSdMhinuEoENt1v78A37F/D
 rHTD8w6q
 SFzpg8ezCKF7VqMsaEvBcTGJOu8KqFD08PgmtkuIDnbvWozWUPnYC2yu6Rlua5xBMq8OqMNo787hA3pJ0YsHay0lm6plNCG2rpgNpZTP+evLnk5IhBDytUsXJBCzPQrze1Kd7u315Emj7IPIgRuuWVHfjJuef6N1H1yTCpDWTMi6JfpFoKJleHpctXl+Ej7e/w7VMUZ9BlJPlU8iSvOiOF58WfTUE7b5qaK49hyRxd5NO9m8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03 2026, Pranjal Shrivastava wrote:

> The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> that multi-page blocks are split into independent 4KB pages during
> restoration. This is incompatible with high-order non-compound pages,
> such as DMA buffers, which must be restored with tail pages having a
> zero reference count.
>
> Introduce explicit preserve and restore APIs for high-order pages,
> which preserve and restore a high-order page block as a single unit,
> applying a refcount of 1 to the head page while leaving tail pages at 0.
> Rename the existing internal helper to __kho_restore_page() and
> consolidate the common restoration code into it.
>
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

The code here looks very convoluted TBH. I think it will be simpler to
make kho_restore_page() only return non-compound pages. That is, it
returns 0 or higher order non-compound page.

Then kho_restore_pages() can call kho_restore_page() and then do
split_page() on the page it got to turn it into 0-order pages.
kho_restore_folio() can call kho_restore_page() and then do
prep_compound_page() on the page it got.

And then you expose kho_restore_page() to be used by DMA APIs to get
non-compound high order pages directly.

How does that sound?

[...]

-- 
Regards,
Pratyush Yadav

