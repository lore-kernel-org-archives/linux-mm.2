Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223A2EEF32A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6751C6B0088; Thu,  5 Mar 2026 03:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622376B008A; Thu,  5 Mar 2026 03:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E2B6B008C; Thu,  5 Mar 2026 03:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3D56B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:50:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA37813BD47
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:50:23 +0000 (UTC)
X-FDA: 84511387926.23.BF6E875
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3246740003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:50:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McJ1vp32;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772700622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2sfL61PigWjNd1zRUK+QURC4mSSZhdQOR9vQkKhcXs=;
	b=Qq5/3N+hyoep5MIMGUHELy8LnK1RFxj/I92HQC1DaQFTsSsBB74Fvg3rLazwA5fK5JNKC/
	UDz3fKxXE+StbhhjpthNb9k/8PLEahqSOWvBS9JeoCfbAJ09ocxi8SrYbE6FBO6PwJvOK9
	nRzaXhl1VM8rFkj3K+5b3QSpGb1ICGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772700622; a=rsa-sha256;
	cv=none;
	b=wEJtHDrAc9aIQUzNp3rriX7mQ9f4Uq9qflsT7hl2kRXTBz6i50wxIVuJao6IQcstYRaaSD
	ug07CscjaYLBKDZ8tvRsnlgOeZ/kMWynubBLb4/nmcgdPwuCdULDoyCbaIX46LSaENtgbQ
	ggNs977mDgF3KVdK4pzANkMjktW6hVw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McJ1vp32;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44ADE401AD;
	Thu,  5 Mar 2026 08:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B79C116C6;
	Thu,  5 Mar 2026 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772700621;
	bh=zevslGUjKCVfBPbqMd+wo0pOgUpRHhdePe8oIhAfglM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=McJ1vp32QXe9xyBY23YUYPFogGoBVy/82ac1XL5PM6v0WtDEP6fZJMyj4G+3m1dcM
	 M8Mg9aWMQgjvNShH83Jl/da4+akt8v10TLkbKooVpo9iajU9jeWER2ZLHWiIHetOqo
	 QjhhOfTxaZLcl9fqfOnPFJh0nKU3+Dx4yQWVyVNKnC+6S4nIQuLJlIFZ8MxdVos3qJ
	 4uYlGQWvP6+GJzvWi2WkAWg9ktm0BFb4f777Mdcuv+mCLOfS493+WGsoGZS0lJU0kb
	 iXvkOPqUdmb84Ed30xiPSXpuxCRB2zbHKavO4hkrCWaYCFccZYnp5sN5hMlGs0Go26
	 Cr3cq/BOefBIw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memfd_luo: always make all folios uptodate
In-Reply-To: <aZ64ikDtz8tF_rFU@kernel.org> (Mike Rapoport's message of "Wed,
	25 Feb 2026 10:53:30 +0200")
References: <20260223173931.2221759-1-pratyush@kernel.org>
	<20260223173931.2221759-2-pratyush@kernel.org>
	<aZ64ikDtz8tF_rFU@kernel.org>
Date: Thu, 05 Mar 2026 09:50:18 +0100
Message-ID: <2vxzqzpybqyd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3246740003
X-Stat-Signature: ryfnohc33ekh1z9i58jn9m1grgmrxxjo
X-HE-Tag: 1772700622-357836
X-HE-Meta: U2FsdGVkX1+4i0OPSaqwjL0Engqma42TkzOGysHwKV9XLp+SesbzInRHKVqPwTuY7itq6SO2r/UHkBRLCpIXrAczSF55KywFGkqNhplGpcK1VztlQOyUWXyI5jpuSpy0FKHFQs52q5oIXFIF1h1g9/IlVexegMvEpR/dMnTry9w3JWEyGRYfnOPWUr4SKK4qbdxJV3jdZDJlIhu+FzCA3BKWNxUKNFb8A4HJwNktj2e+ELCbQQt+jCydQgRctzLVbnq+ZBWt7OvyvwEZlSI4arOGFiMgNSYRmBwoY78ODv2JIEuJt4m9YV+UOP6sVzzIR3/qUNWvHaDB2yvcPpnjUagXJCsZcJAyvzD7u9itUjRO0cAM7gYpB+XWGICsoCKYCzLjIEnoeXliVC5yQaiZYMgD3RzVt3qZA9hYNg9awkfGHAcNeL1+DDFir1BrRku0xPvY8To0L8xoNqdRRptXIsUYfrYJ8ZlejdiX8HHBsuWzRpOROisAz/HjaPN7PIbQj6YP6zhtNnAOQUWOg0QI8cQBI+cJoGQF8dw0leN3oDMKUyWuIp9eEaE82/YTpDc8SIVI0YB/sEwaHJwi6ut1zUWmkSXiR6XQ7jc9QTUO8jZBLEGXavRgnyx1jtMrFlUJi8VF5FsZpZaatLpNF3vTpCZeJoL2Q2yBiUj/yjY+qnYb91lP/1HCYhMyAto61HvDmVGk09tZ6+wN5dHZhqiMPXR6cfZaw5vemFwPdT1LFa535LWLqi2MIbeW/S0MbiwzDE6QyEBoyXoNx/DTYrYgXjFXAArZQ4q1iUMbxKVmzbR7UjF9E6bQ7lSti81CAfrpvy6vM8DDY2nm2Cn3aipRE/NSxfIqHZ6r0dXW2SbPzsU9B4HnRcW+9C91BlB9hVKXz0DuDXcl/aA50qtq4lxvac6Tob+YeUCDUYlOaRmpC4UrLzBCIWyXdGv9XiX/75aZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25 2026, Mike Rapoport wrote:

> On Mon, Feb 23, 2026 at 06:39:28PM +0100, Pratyush Yadav wrote:
[...]
>> +
>> +		/*
>> +		 * If the folio is not uptodate, it was fallocated but never
>> +		 * used. Saving this flag at prepare() doesn't work since it
>> +		 * might change later when someone uses the folio.
>> +		 *
>> +		 * Since we have taken the performance penalty of allocating,
>> +		 * zeroing, and pinning all the folios in the holes, take a bit
>> +		 * more and zero all non-uptodate folios too.
>> +		 *
>> +		 * NOTE: For someone looking to improve preserve performance,
>> +		 * this is a good place to look.
>
> I'd add a larger comment above memfd_luo_preserve_folios() that says that
> it allocates, pins etc and fold the last two paragraphs of this comment
> there.

How about this:

	/*
	 * If the folio is not uptodate, it was fallocated but never
	 * used. Saving this flag at prepare() doesn't work since it
	 * might change later when the folio is used. Make it uptodate
	 * now to avoid this problem.
	 */
	if (!folio_test_uptodate(folio)) {

And the comment above memfd_pin_folios() gets this:

	 * NOTE: For someone looking to improve preserve performance, this is a
	 * good place to look. Also look at the folio zeroing below.

[...]

-- 
Regards,
Pratyush Yadav

