Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390C1606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mlejMS7C
Received: by kanga.kvack.org (Postfix)
	id 39CA86B05B0; Fri,  6 Nov 2026 07:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D9F6B05B1; Fri,  6 Nov 2026 07:08:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265D66B05B2; Fri,  6 Nov 2026 07:08:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00D976B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:08:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B20A7160D2E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:08:02 +0000 (UTC)
X-FDA: 85404570804.11.AD95E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13255C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:08:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlejMS7C;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793966881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/46L68pR/Enc7fYZWiScuGH0LLWYaias1sdt7wy84ms=;
	b=OfTyzYxqfXdaMp/bfOrqveiQnn/Lhyb9y0fMYyv11uIPyZ8sF/4yDixS6Mab9ctW46yfW8
	Qj9OuaKIAB/YBMODaDqZJ5UEEaLm/1IzAcesQ3gezR4+x03JTp/+4hErlOupo4MBOZeyCC
	wM9AnClRHBisJ52dAcTrSK29t1h+g34=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlejMS7C;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793966881;
	b=7IP8tqKUUsGWGeAz4F5sDq5Ab/ssWc9tszetdOoOo4QrddpUoXL6fjAa3JFhz7PUhR1BWN
	U138pDZ8Twt3J3zcc33T4LZ7v9vGDFAHbqD5P0FsT/H55MmY7ArSbadxHQxJfNV6g1tWD9
	lK9uuH7mpegfKh2UUaL88foFvrekJ7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FAAC437FC;
	Fri,  6 Nov 2026 12:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745691F0089F;
	Fri,  6 Nov 2026 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793966879;
	bh=/46L68pR/Enc7fYZWiScuGH0LLWYaias1sdt7wy84ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlejMS7CjxEq6jLLSwGu7+ysqSsfyEJ4AJdWyZJ9nSJU4SnRD6iThs3XrN2kJ7IPb
	 oDp25jS3hyilaFDlrWAVkjiV0qaFN0V+Umpx2iKYALD+k4OUd4b0GW9SgaiN1zuulK
	 lEq8ySrhvWAIHlzWeo7Ls9+4B8AZly6D2Zp7WsDxcNutGMRCypKoPPNdQTjtiaY8jE
	 Q4m6eXuOXyFETQwcsSAonYMybHSWF74xujXfx0fa07vNxuHTMIWYjeov1/igY2aOr1
	 azCsgQ8deblzykTCs5kLWGlo/r8FTSvvZ2xiYOx3cTjBZg+HkeRpdMJm+4BJHI3Ts+
	 HbXCANfb5C7Ag==
Date: Fri, 6 Nov 2026 12:07:53 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au3CUJO9zBMHLx-B@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
X-Stat-Signature: of8sxibgkj6ymwuu8k9mezx5eo8egnhg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 13255C0003
X-HE-Tag: 1793966880-911140
X-HE-Meta: U2FsdGVkX1+Il6fCeT6mbcEG4cZlbFoeBiI2kVJXycG/bbillsrVUiPJyBrxVH4Vgfn0d8EPJ13LEdIiKUgJvaKR4jCBsDmKizfp5Rr2ns9t6s+8iHGNPQvKbsXIEvsY90geZLu2E15LTd/Zob8wXzzd2eTwx0JTAVZdx35VHyOzGCiJSpqRrnZ6SStBUAJTX2wvJ8pBdG4PCgfYg8MLlqepa0LnZoQOCOfDdvLiO31uneZO9qZB/dbmeFYl0oSbF5/71MPhf3WtSvh0txVLA2E+Zw5W+hnvwHSfqiBvpmKyKA9Z8YHroDFO98xnWZCm5zB0Io5auExXOETMCSB/3M6zQsDq47lmhdFrsPXkbHp7oMPnk1GXUlqyWf1Z5Qbfxnqe9nNZ4IR+zavJdTTYcp7b+c+ETFPVro3sx/SUJ5Asz3y0z9HeT3OE53RMHYglRPzFtakNMffPVUqmQrhi48CBmyXphzN41L6Yi1R7Wz+b6LbPgQN3Ublt7MKbOKxUDThddu3t/BydzrEjDhb75oXB4g7HyMuJPG7enyPEUlbo/f/Tr/wW0P5gFHXIfZDY30zFxKbhqerLcq5vufxDjVYeQA+9Yv3p3HgmA9TiZEYWEbbIk57Yp7RK+6f6+NabmGF8iToNgjQCLoCFMhukRDyw7GbUSeOsBJ5H8UigFUFb2iswJMEoaO/ZYc1RnskeeT30/FJXT+wY+sdwRO679X7tcmT7G9u7X0Qqm00szf9HdofNVLhudfKIGJP/2wWwj6kHDPb+2WA5pgidWpJ6uS4usXKJa+/lstrY7S55XXPf4WwJC2grcBmiKFfKfg1YjZ2wdradUSKyaRRieO79FBZgSQMXuNII+iPPSFapZImHkiq73IIWJtWaXFbk33jYjn0yxkGqwXFpwYRjfu72GCSXPsS6jDn8L46sY8UhrSrrnqeJO0ptJ6YUjtSXe/Flwzx9rVV3VxM7ffht/Ix
 MNa515lX
 Kuffhr9JU01/7YcS5wjZDnu6xjRQTkKPxnuwYKAhe7VS9rjd6kFUR1UG4x0huxeSrkd37iPSX5F9FbbBc2lKfPqyPrd5NyiZv40YWA/BQkmtunP6uTw0iZGUDK3+UlMGR4H68cDu/GsXHAsrjpH9Wx07RcWexDzRSCtS1AYj6YgrRP7rbzVY03sBHXeodqFBkao/t/kdlo93RbIwssHh8+p0A4vpnAfw7kiGxWRPExF/A3rvkxHsH6j1f/bHpqGBW703phhC1uEKqsUqIbtZthS9GwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On reflection, I think this would be better implemented as something like:

static void collapse_scan_mm_slot(unsigned int progress_max, ...)
{
	unsigned int long lock_start = jiffies;
	...
  	for_each_vma(vmi, vma) {
		...
                if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
                        mmap_read_unlock(mm);
                        cond_resched();
                        mmap_read_lock(mm);
                        lock_start = jiffies;
                        vma_iter_set(&vmi, mm_slot->address);
                        continue;
                }
	}
}

Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
on HZ), which is a long time in the kernel to hold a lock, AND the lock is
contended, we drop/reacquire.

--
Cheers, Lorenzo

