Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DA9606A336
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=BJyklodr
Received: by kanga.kvack.org (Postfix)
	id 49F3A6B05B5; Mon,  2 Nov 2026 06:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FA36B05B6; Mon,  2 Nov 2026 06:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E4B6B05B7; Mon,  2 Nov 2026 06:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12F3B6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:14:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BA201C4409
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:14:31 +0000 (UTC)
X-FDA: 85389920742.10.3A1A01F
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E30BA0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:14:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BJyklodr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HjTWIQal4WNqfbdSCQgFb6hxzEStlTsUt7GL9dNGCA=;
	b=HouIhhTS0TIE1iSaXHfpGCOMxSWz15E5W9YQUz4riU5gckvqQ5EqwbQ/OtJxWFjLgGMRRM
	UFb/eqFOp71KJEbjytMcRhblSJtA4626GDlETVEMYqK2y3xwL7uNLH4rtcK96Bo8nE5uQy
	jA2eP3iA16aB1Sx75AeP5yp/VPcjE5k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BJyklodr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618070;
	b=aD8BzAP9z31sOOxYuZhMLha1JvtUKm3eihlnf3vuAfI7d6Ac0xELIUAJDV3r5+fdvctcZQ
	tObwk7ezjNHYQYHUbJqfJh7NbFUoA98t2XPWy9FeeUiUhX0oytDfZnrkCmcpvOJkkLMig8
	8OwQ6uvGdOzSxj6N1kuTT1SQ+Y1idUE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793618064; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=2HjTWIQal4WNqfbdSCQgFb6hxzEStlTsUt7GL9dNGCA=;
 b=BJyklodri7dpOBv0cp8g2K8bmK4MmzM+MB3zUjL2lXxlX4UBjFrBc6rCvVMjn1ibx2sa8e
 +yXWnx1kEYxF+1ITc8WlHrZRDRpo0MlYceK96REM4/bF2rM33wJ04d1i+HcloCWijJ8hnT
 nlhNK4JDVXx4U4HzPV1LRCNK0ZcgbbnZ6bbUTT7wpBaDjjt/vwYK3uvMiTYyAYlKjkRubV
 cpwdCD/PmqCDwm39oXAm21dYE/ZudjeqhIeKmRd8+q9vFygUsjSXEHy3T5ppBsM0WLG2US
 /g3XWlmzcxHUxExs00NByWe4PwudmCn1GBGbAhHZaR7SUXebEvk+HFCvAyq3zQ==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ae8708e+d9a1a5+kvack.org+zhaogongyi@bytedance.com>
User-Agent: Mozilla Thunderbird
References: <20261031182256.40205-1-zhaogongyi@bytedance.com> <20261102101831.218090-1-xu.xin@linux.dev>
To: <xu.xin@linux.dev>
Content-Transfer-Encoding: quoted-printable
Cc: <aarcange@redhat.com>, <akpm@linux-foundation.org>, 
	<chengming.zhou@linux.dev>, <david@kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <riel@redhat.com>
Date: Mon, 2 Nov 2026 19:14:04 +0800
Message-Id: <b208b102-81b6-4e39-9be3-202fc0519e07@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261102101831.218090-1-xu.xin@linux.dev>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
X-Rspamd-Queue-Id: 1E30BA0005
X-Rspam-User: 
X-Stat-Signature: o9osknqqs6wj6sbcfx1behzr9jqnzkur
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793618068-626689
X-HE-Meta: U2FsdGVkX19y3nii3V6fILl7+W6WtsvzwRNrER/wJ38wNoCd/kLWO6YRYCPr+fp0Sq7Y2qKOMo4lvnfj9GbsTjYJWjjM0+961SL1AtsaCVGGymSJ4O+dSY3vufdpBvR+tZHNA/FKVnqofslF0oDWLjYUgjG/eWqiwXUsi6ggvo1KQvu9a+W2nQuPqBbe2LZ6xcxQ4uABjeQgHPs5wkoRyzORfFnYJZsbtneKqwmQ9M0AHVHB7CRYlbkeMG3sr/aiG+LYNzLANnXMgRLIfaTkC06sk9Ktg9EUEqTS5Mug3nbaGqPl45zVlqpCQKmhAjdblyhxjB3lL4AG4jjvD/w2tN05cv9nMEJpP8b4KjURzisxrlIZhyrifNrAkjKJJbotqiY492YkkXlYybovZPxGeRMxrTda673tRP02VLcI/J3O4p1vV7PZg69sgZ/r5WrQMHUNmr09pv5glLAJk64B0Qisg0+8BRm4FfnDOl2k9BE+U4JfzGm/A4WKkzDpegBm2BWNsAdLIMEBDuRppceAeLda8YsDTsq2GlSS3vVKMpRMAU/ZGv5fJY6UE3JKgbYOna/IlpZ4UZoTJjJkKTVBgHGYnqDLVWtS0e1eYaDsdVNyk2d2qVagFYPt2ZGWHhiLGPby21czMiFgJiQOk+MqDKqY1fYK2FTCNbBWcGNT3kgCFOyiV8ToqxBqrwTjHMne4AZoKxwZSTzz3cCHS2CrtwO1mr5brlH2eD7WX6jw5w/ece7KMVmRUMfyKGvapugjj3M2e3uIK4iZcRKorNoOuoeCkKxgsZlvGtv/sQSBXIWAi75ddNMNgCmSUgxDeNLTybu+zJtdC3b1+5lyGNaWDJhSXqnRGv6mgVwfdIvfAlqG9T48eyDiovrhjnNEse5aHZScFP/jBbYIGIHt3ftI9rOqVuvLT32brrWkx5GWNXMFyaFw/EZ6o6dEzwWBLDgSgVRqWm7yXrjhsee2V2c
 kCJR83TP
 cLv6zZ8B4GDAKXNSzXQ5cgVnnsHFHSrI8P16rv5NG7JFASdhtSJxwQDEEfmcrnkpy2HHMdUY6zjZibfgDbiaXEO+reFe/TQXacG8/pBAq3/Y+85znLpNk14wpqt1m6Gm4X8XjyICJC0n0qlKfkwMHg/0MxZ0QhPPx3COTOn45wUbGSb/DZmgLP8u75vP9ZVRZa3t86nSALfMNwUH10O6k7O0xMBTtC2SfVVnzCrxxdtdu1mHAbslYyxd7p8LWNFAepvPw4rIJxbpY1pxDuwBmpOYO7pnYsr20cwuy/xFoz7Da0bOAXOwUKVqhpqQxJ5Ftaedn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Xu,

Thanks for the review.

On 11/2/26 6:18 PM, xu.xin@linux.dev wrote:
>=20
> I=E2=80=99d like to ask whether this issue is easy to reproduce on 6.18 s=
ince
> I suspect the accuracy of the =E2=80=9Cfixes=E2=80=9D tag in the commit d=
escription.
>=20
> Besides, adding an extra folio_test_ksm() check is unneeded, see reasons =
below.
>=20

I reproduced the issue twice on v6.18
(7d0a66e4bb90, CONFIG_KSM=3Dy, CONFIG_KASAN=3Dy and
CONFIG_KASAN_GENERIC=3Dy).

The exact invocation from my previous email:

   /tmp/ksm_fixed_pool_static 4 2048 1 100000 64

reproduced the issue after about 220 seconds:

   BUG: KASAN: slab-use-after-free in page_address_in_vma+0x292/0x2b0
   Read of size 8 by task ksmd

   page_address_in_vma
   write_protect_page
   try_to_merge_one_page
   try_to_merge_with_ksm_page
   ksm_scan_thread

The corresponding free path included:

   __put_anon_vma
   unlink_anon_vmas
   ...
   mremap_to
   do_mremap

A second run with 4096 slots reproduced the same UAF after about
142 seconds. This confirms that the issue is present in v6.18.

I also rechecked the Fixes tag. Before 21d0d443cdc1
("rmap: resurrect page_address_in_vma anon_vma check"), the anonymous
page path in page_address_in_vma() computed the address without
dereferencing the page-side anon_vma. That commit added the comparison
between vma->anon_vma->root and page_anon_vma(page)->root.

At that time, the KSM scan path already retained a page reference,
dropped mmap_sem, and later called page_address_in_vma() from
write_protect_page() or replace_page(). The page reference does not
pin the page-side anon_vma.

Commit 4829b906cc06 ("ksm: fix page_address_in_vma anon_vma oops")
added a NULL check, but the helper still dereferences the anon_vma
when it is non-NULL but stale.

MREMAP_DONTUNMAP, especially commit 1583aa278f5f
("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP
success"), makes this race easy to reproduce and explains the
unlink_anon_vmas() free path. However, it did not introduce the
unpinned anon_vma dereference that this patch removes. Based on that,
I think 21d0d443cdc1 remains the earliest appropriate Fixes commit.
Please let me know if I am missing a lifetime guarantee that made the
dereference safe before the MREMAP_DONTUNMAP changes.

You are also right that the folio_test_ksm() check is unnecessary.
cmp_and_merge_page() already checks folio_stable_node(), and a KSM
fork page that continues through this path is handled by the
page =3D=3D kpage check in try_to_merge_one_page(). I will drop that hunk
and the corresponding commit-message text in v2.

Thanks,
Gongyi

