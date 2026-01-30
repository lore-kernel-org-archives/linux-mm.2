Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07CE6E6BF0D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 13:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731AF6B0089; Fri, 30 Jan 2026 08:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4E16B008A; Fri, 30 Jan 2026 08:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4046B008C; Fri, 30 Jan 2026 08:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C83D6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:49:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0594B1A05EA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:49:17 +0000 (UTC)
X-FDA: 84388761954.30.6A23DBB
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36F5518000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:49:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EyJwFwR0;
	spf=pass (imf06.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769780955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xt8oCbrH9okAjKUrPiZSoeA6LFAs2r1CjMNwP+aJ+Pw=;
	b=NiLHBtshSe+6x5/Q9G+LZc7twk9tkoIXd3S7Yqr35WNoA0Vg/83Dlw/pPHR+7+1HX/JGrK
	K8ysw0pgsSuWpxwjF3r2hdfPYni8/1/AoPqLFDuFojc4dUYuISWF8mszOMyYi0EbZmMxDE
	pD2tj49sdw440XdQ07hvbpAKAjwV2fQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EyJwFwR0;
	spf=pass (imf06.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769780955; a=rsa-sha256;
	cv=pass;
	b=CTvBrhe337S9Go0aGHturcE0VvpWZ+uqr+RZmuDsu/9aW67PYGL8fknlE8Vr9L7JJvEE+G
	GwR9B1jApqajp4qO4pV8crjATb/B1fOP8+tw+oajHI2qEXrG6jUx8MqL1n2qAS2yH5a6yR
	k4tw8rVtOYY/mrgDbJDSlQ65fQwiqYw=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d19bfe1190so1474534a34.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:49:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769780954; cv=none;
        d=google.com; s=arc-20240605;
        b=WsCptjsIpz/4pi3OilsZ+5MTuNQsD3uGAv2wjN5QSQK+wsWAVfVdDRsjZ+BIiudC7Y
         U+xa0WQeQwZEQvXQVamE6grzz1F+RV1H/7UA5NDtxa+8gDRQBUuazZeBzyZjBFHY6Ur0
         ehWf2zzky8vZMu7BpeOSWKknsRVr4IjPz0E4k7A1xYkw2P/K1izorvo3mAXfOpgJIE0l
         /VmhUX9oqdygzXEWmOuheC2mkDtEZbLFe4ovZqyLvlT0DaL1SfMITKNCZwZ7bEBbfKcN
         Sm0JWTkWU8VGOjL1/IWWvmmwjXztte9hTg+8fIl3TtZ14eh7hdGfOpY9vrxvg4sJFlLe
         A/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Xt8oCbrH9okAjKUrPiZSoeA6LFAs2r1CjMNwP+aJ+Pw=;
        fh=R8+6KFnlv+hF/akVPWSEXQ2dhScGJxB/0qdwtF1xFZw=;
        b=e8vPaaS3lsN32uEybXH3DVQmSBMdpUp1mdif4kePvy4b5F4+M6/x+9s7VmQszRM/pV
         WXEliVE0HjmIkmmRRaBbxpna3olzRWKyRU5mGahRjGuq5XwyHcfVvTBPpNaOFhwOuO7S
         nXe3gq7BeVXH+gMe07zwbZAWyFqUd0/3QJde5VmEhOoKNl67gUuga0ntLBW67474qJiQ
         UJ1MrQBqBRjY6aK6b+qCs1IYIAGPJvbF932HMZZ9ysLfKRmlsX7LCbGoNEmqx9a6BTKm
         wiBCcmz7NNiM1hjD+CO4y44JMRlO3nGoD4O1K4CxPfRJX+r5BdHI+vT5rV29tcchb61S
         Pyfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769780954; x=1770385754; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xt8oCbrH9okAjKUrPiZSoeA6LFAs2r1CjMNwP+aJ+Pw=;
        b=EyJwFwR0d9yNIGxQjre4+z9ilUl5aVa1TTsQoNTylwSB9Ds4469QtgzZ397eZM9Qay
         hqApgSLuxg7R96hJu7eZph64s2ibfifMdhFFtKLo6zpJc+DbkVU/nwuEFPv4BdNr8s44
         NvcOsW/GVGt2y+ayXwXOXqYNMquG2xsS5dYnanAQ/7YCwBY2S/JAc8mPA3XbuQvJF46r
         a8cozf7sqGBQey+LUIEYjcSKtRRZVg8YHbW/YnlY2NdpWzZ6eSUo1InU39x0KL1agfzT
         TbfEqUiXC5XuKQf+BzKB6s/NyWKyiLv6Ywq1w62HGgI7eleqQej1NnYCE7PPYnpoW8fp
         487A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769780954; x=1770385754;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xt8oCbrH9okAjKUrPiZSoeA6LFAs2r1CjMNwP+aJ+Pw=;
        b=P4pemMhiiE0yKQekfMxC+e6kwc0ScS+1AwOBUKjnpxFApMycLfnA9IXXDkfBQgbqKt
         ojoPHwZHvSgqY858OaldOcOrVA47wFm47tvqb60Y0TVSkRdiv1ZE5+jm0K+Yk8vQfHK6
         SzTEOIa7YsaHwva41MqlnohtAZ4gBArrMKbFYpYD/EHTm1Xk86lPIH47q1XDFby9qXPr
         FHZyamx6y9GuCr3xPeHGNjtdYBL8U03kO+5x+PZj73UI/uoXHuZlDHOwDdERuW92+g2b
         vVrWjW+Vietk4U8rxOAuhZeHVmaipdTAZKry3D05I75hCykpVTrBAd4e2Se1ey8sr4y4
         w+kw==
X-Gm-Message-State: AOJu0YxYx2KWCPHVK7sp0HGiTYDORKgF7Ohbz6CATFFBm0HQ/BuiawEQ
	r46ZtsTabIFi7+cPntvMgLjeN2TezYk7dc/uAXzZQalPAVhJ3BQ/mYbvQv9gpSn54qouEL239OH
	wMFqf//z+qnrQPPNNuA83+xrDrjS210S28GkE+wuRQBzm
X-Gm-Gg: AZuq6aI3/MAHMMsW+oDbTcze5pVZLvwrx6iaajl3HWEdCCrYNrNwJ0eOfWd/t50Dbza
	DJZwJ0MIpsVu0e7Wztb32oqvfwmlJcUWIeAL8mU1A8rfdzy1wh49MjvCYL3CbMPJQ1NyPCHMp6q
	5eslH8Ix3lhW+yfYTZar6EeeOifHbt02poogM786R5jWv6iOvS+SSMurVagQQg0PFf6eGyXFAY3
	GGg2TthoJLhC1Kcy84rn+DHy1Dv8m8uVqlP/i+mMeeY4iR7YL09ZISChjPI+86GU+bQh6Fu5w==
X-Received: by 2002:a05:6830:6517:b0:7c7:471:55ff with SMTP id
 46e09a7af769-7d1a52ccbc5mr2041628a34.10.1769780953663; Fri, 30 Jan 2026
 05:49:13 -0800 (PST)
MIME-Version: 1.0
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 30 Jan 2026 18:49:00 +0500
X-Gm-Features: AZwV_QiAk9It0ObCVuiEkeuO_Q6itWeKLvxgAKgEWxUFdAWF4LnAoAqeZfwVzVg
Message-ID: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
Subject: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to stale
 page data after split_page()
To: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, 
	kasong@tencent.com, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 36F5518000E
X-Rspamd-Server: rspam07
X-Stat-Signature: gfykypsypndftf8z5cghudriafi8mc3d
X-HE-Tag: 1769780955-232301
X-HE-Meta: U2FsdGVkX18oUrqiP9bWCBDbYd8UeJDlZTqDkuvaSfmgavSm+DGC3m5p/Hnz1c+axuEThJ8IBJ8xJ0In66CdMA27pu5V3YpU02hdk4MEhzl/M2Jl8yvbxpk6f99vnWylTTR02c//JOTRpq8/1e2c8i226MFe2zf4f5mh98LYuhRWFLsZoVMKfSUXbKYBN6xNUfZdKx7xB+E7qEQuOgt+l76GX88wjXynNgmNcjddh7FithzezbN6tVsGhTHzAX+EoH4k95zLakVt6IRR4iwCVQ8NhyF3bt/OlnBk+QEIH4wgrfuZRczNCljStYYPGlUuQ4zViXqZGtyjUogsa1jxW0OZ+AH2DMF4KsDFjW8PdqAYqYWbtABa2Kx1danJyR3JHPeLvzgSOc703Om4oTGDAcoUfOhDzGI3oQFcHEYoJtmz79vSfEUMq6CBcLHQqCF90LDNEB4LfFcjHuzul/RvafTLUUyXKVgYLZQh/xDh2Hwf88Wrj4h1I6kkHLYLrj37uWOiGN7Bh8xfZKdI3tW+xzXRy8zJJ4FoaHGy+JGHu26Jz+uG9yAUKqrLzPHOI9doFQ8En00v/wIXntdHEk7+kpJzccz6Hupa3fEzOPLNz9aLzbS+okhreaMxZE+VFYkyAgA7bkJikMIeR0unTMLNhLwrMPKPNBSLQh8Ntzl6mtPAUMnrzASup5OTNisb1d3rHWyY9x57IeuicxB2bGNugv9pUTl7pA6hwv6g1FhwJ4u2ZfdJ6BWhUBzyoO7lJtKLT2KLhgkjo+X33clpmFJ2Yj4z0G9XJjLErUTUgxaFm4BbM594bzpjoAtUqxAC4/Rl1xW2gB/RdD0J9Ph/QjmA9atCCGWI94WOJng8cQDB5+5DHiq0VpPqYSgAX9US8cPgstTUR3MJiS4W/xGGkUxloSXPkxmwp5hVX/yiXy3SyTwoUEWpCZtJUkfnwhRd8MzETD025CjQjAXHhFeNqAT
 qGdcHvNt
 W6MADhD6KUmmMoFa0E0TrLRGHyV2KljarE0vQwuaq+l1ewUZXR4ZFJscE0amAjpeNaD/RDML2jF2Q0ZGnt7ZYiORzpes5HhRCM9HVPVR4BtLulS2mljxfmxGkhSAgZyFd60LTW38mUlMgrrOdwut4L3sbi1/gvCZTjEHDFkJwaDTGWHxdoeoi19/W8CyU3xGwOKlcP8M8UDq/PIx4puftWxRiYWgppE5iFWzNoMS30VHLhA+OTelA+TGdDO7wj7XHZAlq4LzhMPRFynJFEeGdD+2mRwCEKTlpdS0ZleSB7RUfmDiCa/x/LLwMQSSpxkrsAe0ZnC5+tdG/8vW14uLKowxJutKpiCUvU1O+5cAlcKCWaAYajxNh74zq7HFUiH+fspJYgs1boGYu753wGvqfqX5Qkvqh9SH89qPo5G4PsUtKVMCmTUD90DWW9tpdHyaM2eal2kmoGAZGTR5VBRnJNZF0cNfVXQuU2px3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I've been debugging a use-after-free bug in the swap subsystem that manifests
as a crash in free_swap_count_continuations() during swapoff on zram devices.

== Problem ==

KASAN reports wild-memory-access at address 0xdead000000000100 (LIST_POISON1):

  Oops: general protection fault, probably for non-canonical address
0xfbd59c0000000020
  KASAN: maybe wild-memory-access in range
[0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

  RBP: dead0000000000f8
  R13: dead000000000100

The crash occurs when free_swap_count_continuations() iterates over a
list_head containing LIST_POISON values from a previous list_del().

== Root Cause ==

The swap subsystem uses vmalloc_to_page() to get struct page pointers for
the swap_map array, then uses page->private and page->lru for swap count
continuation lists.

When vmalloc allocates high-order pages without __GFP_COMP and splits them
via split_page(), the resulting pages may contain stale data:

1. post_alloc_hook() only clears page->private for the head page (page[0])
2. split_page() only calls set_page_refcounted() for tail pages
3. Tail pages retain whatever was in page->private and page->lru from
   previous use - including LIST_POISON values from prior list_del() calls

In add_swap_count_continuation() (mm/swapfile.c):

    if (!page_private(head)) {
        INIT_LIST_HEAD(&head->lru);
        set_page_private(head, SWP_CONTINUED);
    }

If head is a vmalloc tail page with stale non-zero page->private, the
INIT_LIST_HEAD is skipped, leaving page->lru with poison values. When
free_swap_count_continuations() later iterates this list, it crashes.

The comment at line 3862 says "Page allocation does not initialize the
page's lru field, but it does always reset its private field" - this
assumption is incorrect for vmalloc pages obtained via split_page().

== Proposed Fix ==

Initialize page->private and page->lru for all pages in split_page().
This matches the documented expectation in mm/vmalloc.c:

  "High-order allocations must be able to be treated as independent
   small pages by callers... Some drivers do their own refcounting
   on vmalloc_to_page() pages, some use page->mapping, page->lru, etc."

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3122,6 +3122,16 @@ void split_page(struct page *page, unsigned int order)
        VM_BUG_ON_PAGE(PageCompound(page), page);
        VM_BUG_ON_PAGE(!page_count(page), page);

+       /*
+        * Split pages may contain stale data from previous use. Initialize
+        * page->private and page->lru which may have LIST_POISON values.
+        */
+       INIT_LIST_HEAD(&page->lru);
+       for (i = 1; i < (1 << order); i++) {
+               set_page_private(page + i, 0);
+               INIT_LIST_HEAD(&page[i].lru);
+       }
+
        for (i = 1; i < (1 << order); i++)
                set_page_refcounted(page + i);
        split_page_owner(page, order, 0);

== Testing ==

Reproduced with a stress test cycling swapon/swapoff on 8GB zram under
memory pressure:
  - Without patch: crash within ~50 iterations
  - With patch: 1154+ iterations, no crash

The bug was originally discovered on Fedora 44 with kernel 6.19.0-rc7
during normal system shutdown after extended use.

== Questions ==

1. Is split_page() the right place for this fix, or should the swap code
   be more defensive about uninitialized vmalloc pages?

2. Should prep_new_page()/post_alloc_hook() initialize all pages in
   high-order allocations, not just the head?

3. Are there other fields besides page->private and page->lru that
   callers of split_page() might expect to be initialized?

Thoughts?

-- 
Best Regards,
Mike Gavrilov.

