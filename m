Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF80F606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mmeJ271N
Received: by kanga.kvack.org (Postfix)
	id EDDE36B00EF; Fri, 20 Nov 2026 10:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E786B05B0; Fri, 20 Nov 2026 10:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56EB6B05B1; Fri, 20 Nov 2026 10:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAFE16B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:44:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B1D21A0F9D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:44:38 +0000 (UTC)
X-FDA: 85455919836.07.205C6B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C79480008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:44:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmeJ271N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795189476;
	b=HNYQXhf3DwFevixdqbXbgzlUnPZZj+885SWkIiZwCNI2NbtRnDg9H9BtsPva2yckE/4878
	/LvkX69PfsOzTyCQCdan2GSEpyAOjiyPe7pg6TDaEIOn0QEpRFpQ9l/WiEhChyJAu/IHZq
	cA+AcJWzFDCODpSc+pFy3m1fJRnEh/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795189476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGj0qVuLIFFATf6LyggXZB3De6ZTU5Fq7s/WOWKevVw=;
	b=5HyJJtOBynQeyq9kgD+mAtVsTbW0sU1Z+V/Rz3NFxVs8srZJ3o23sZGgv/DDbB97JfTA7s
	6KF5qTJz87SLWQR2wR7VhNHa8tsTSl9o0pdwZhP56BbaIP9qZvhAcWnS7Anu3g6R5PW/20
	c7pDRFJmQuWeJIn9FAgTr4SeWtWWiq4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmeJ271N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B989C629CF;
	Fri, 20 Nov 2026 15:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B4D1F000CF;
	Fri, 20 Nov 2026 15:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795189475;
	bh=NGj0qVuLIFFATf6LyggXZB3De6ZTU5Fq7s/WOWKevVw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mmeJ271N5f02C0B1RJgXSd6hkgBzr5xSxlMsyenlDXMd0wCPGTa7FRYam0L+pK+Nd
	 2nDwSnDOv012h1FYqMdYNMO6bs1iHUSB9PaeWSr6tD3E999ON/i1nZJrZlbyopx/zH
	 1WOxAslRKxAb9EIJj4yAqjf8N6R6HgMZS6aqktcvJIpdXVTkB3T81w8/pracVLAw5I
	 wSJIVpaYPJpzClqE6eNqFKYfrkrqP4tYZGjR6OqUAdtKVVC5HgrjgK71tSO2C0h5E2
	 +yEM8XVc3jF9BMQI6AHMNt7a5VhqmQ68piHOjE1DJhS6l88PoRjNwWQFZutTDw4942
	 yHBaa6mbzgwGw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] mm/memfd_luo: keep memfd frozen until finish
In-Reply-To: <20261114220528.f7d9874a014dbb5d@chrisdown.name> (Chris Down's
	message of "Sat, 14 Nov 2026 22:05:28 -0800")
References: <20261110175855.2437084-1-pratyush@kernel.org>
	<20261110175855.2437084-3-pratyush@kernel.org>
	<20261114220528.f7d9874a014dbb5d@chrisdown.name>
Date: Fri, 20 Nov 2026 15:44:31 +0000
Message-ID: <2vxzcxrz1p9c.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: we38kpx9wckozmuetcpzjsf4aiqc7cqz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C79480008
X-HE-Tag: 1795189476-953318
X-HE-Meta: U2FsdGVkX1+KJnUbPRYug+jbP7jSJ8DTDbbGC1H2OV2Q1SWqnA1qkvtEkqOJKMI6+hMwIJNvRfB/kdNuGqnFPRWwt1oYILntvx2hiUm6EOFq3pt0SbWeqJd7Ct7DlS/uhtKIJIFqJpWfxGRw+Hh6WoM+l2vF+tVQU7W6WFmQoJxvVu44bGdxUUf8FO2cRvKs1DK8sm5GTCtCoFJaNl4KHcYDw/ghioTWgC+skpD/EvMoqWawp0h+SYXcRnwHc7r745+N6mcbIo+uzVc8pKFJ02YJqH7mQIH5Umgw1WVyn+N4u+DoD5DojvxMrYpWo/1hrQy0U5sULxOawDZi0mm984+4/OgccS7nQYMYy3CgAM/EEBKvG2yby/wJz9D603eaN5otcY/aQVUVH3SnoKqBsjxw6NUEjM7e77geTU6nZgCwSrCpjNexpqOXQ1LBofUt9rqwOV+mYBWftL6Z3s5HXC8rwH+kC+Ajr3qfe95CwpJfcZBCAikGZ/R5JDpJegKmO0RUzInd/WFrc8zTM0dU/ahsSVjhBTYeuLsTiGeoFR6yszh4ojQJWCUF7DLFOoQgXlczXaDoOJ136KyYybPQ+l3OsvGS3y97uLSuea6GXDs4ISWkRMU/Ur5pMrKXFrPJ7hBlsSPV3IzOk3R7px9qIfMgJYq9J/OBkndlVnYYBVw2aPOduv+PRwKnzrlUHXInRxSlIpJHSfKqj8kgXYqrykPeS6E+74aUHOfwrB0w/efbXtVj5vxHUKNNW5sTUtDM74ReISMv0LaRDC0cSltHRQG1tCwwNZWvw5GBsy1bYjO1IfrNEIsDvdlvUgMMpo8o5Sxz22M7ezsLICrvDsqCGbh8naB6sGRtlxnnrAHjCf3sP5PfSJ9BJCWFT8w9UC+nNDwGhpIT7quT9cFmAQWEIAYIrFHZSARcqLGKju7Q1s75soCbLPP4yR1FPN5OJgWUSH3invNP57GlSwLl4OT
 wtEPil98
 IUPDYsMpKKsnJoaXpojRThCXv0QjjBD1tm9jBpTel85AGGtGWuriLkaeEIwThYnTcMbajCelPPvig99L+2B6uHRM9gDacT8fgWkjlUgdh9ORzj8qiHi/k85hdvXzlF5NTuYRkv2hW2XTlayCkcgEV637bO841NsrNBYdCfHUqIEEWsL8GRo48JWaywYw+6kx2OKp9ti9Yz5eyFIfZD+zdIxj2syH3A7qadqjXX+g6DzvGNdXfH2HeueueDwUn7RjvGac+Gtw936Om5r/C8OT+AMzAxAF7bf3hKy8pK3DySkWULMlyxn1RzZRhNy5DAGDfRJiHAELbhA6uQHuEXOKx7b3OD5wfSXzY1GsSCPCBcZ8gLR0U7or5hdr8Fkag1BNEYeB2Si+tYL6oiL+k6GNkj1m+LJURrVJ9mBCiC/QZD1S1BgZHUy2l84MufqjHB/6L/IITMYQhNSbjYDaLJDBvtkZ1/iyYEJuLG19w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14 2026, Chris Down wrote:

> Hi Pratyush,
>
> Pratyush Yadav writes:
>>+ * Restrictions
>>+ * ============
>>+ *
>>+ * While a memfd is preserved, and after it is retrieved until the session is
>>+ * finished, its size can't be changed and holes can't be punched in it.
>>+ * Operations that would do so (``ftruncate()``, ``fallocate()``, writes past
>>+ * the end of the file) fail.
>
> Not a big deal, but there's one more thing that fails in this window and
> isn't listed here. Adding F_SEAL_WRITE to a retrieved memfd before finish
> now waits about 150ms and then fails with EBUSY. That's because
> memfd_wait_for_pins() sees the reference kept from kho_restore_folio() as
> an extra reference on every folio. Once the session is finished it
> succeeds straight away. The same already happens while the memfd is
> preserved in the old kernel, so maybe it's worth mentioning here for both?
>
> Also, fallocate() fails with EPERM in every mode while the file is frozen.
> That includes FALLOC_FL_KEEP_SIZE inside i_size, which neither changes the
> size nor punches a hole. "Operations that would do so" makes it sound like
> only some fallocate() calls fail.
>
> Otherwise I've tested this across a kexec and it works well.
>
> Once those are fixed, please feel free to add:
>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Thanks! I'll fixup the two documentation things and send out a v3.

-- 
Regards,
Pratyush Yadav

