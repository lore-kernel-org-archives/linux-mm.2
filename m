Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0C0CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9632D8E0022; Mon,  6 Oct 2025 16:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9136C8E0002; Mon,  6 Oct 2025 16:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBA88E0022; Mon,  6 Oct 2025 16:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3878E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:03:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39CE9160531
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:19 +0000 (UTC)
X-FDA: 83968763718.02.2824F64
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0E52A0008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VextjEGcnlm32GGbyDeUjgrLV8IU5CS7mWQhtH32SsI=;
	b=N8WNCpmrC6qGARI72YckSReJQCgxy2xSWtD69jZDjphXcOftuclELi+yUIWI8PGr3JmMCw
	/HjrSVKcIZSx36z9N1VQkCSE0dh1ZKn0u4jF9J55wZ1uZHy9iNG3fziBVxtFuSUf05Kt2b
	xgRu3SuyRUSultHkLMvBkbLpeWX6lg8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759780996; a=rsa-sha256;
	cv=pass;
	b=mwZjL5q+jqi+OEOKtIAoG+WV03egYCghb5VY8MkShkChB6XKavCDpv8p+TfPjpDuc+8vEx
	P5c+PMu+P4LNPOQtu/5MKG7IzpN3xbKC1qGXzxuyylQ1PMPYALVlSP8unBZBWXkVtGH1Ll
	BRW6gOJ0oxWcSevyBvALrPDAuHIvcl4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7886E14071D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:16 +0000 (UTC)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4567C11AB36
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:16 +0000 (UTC)
X-FDA: 83968763592.09.C3976E9
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D2D1100011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:14 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VextjEGcnlm32GGbyDeUjgrLV8IU5CS7mWQhtH32SsI=;
	b=s/6wsNoW3xvaeaYungCnVB454d9hz1x2vd9vKnmXgQ04pR62dT6b+X6ZIne/CrjNJPPk0y
	V2YHf0JriqWSkKy4LaEws4zZyFqi1AiMXk47UjOJDddeZXtSo/xCIWWvPY7PeLNXuNsLKK
	UtPOUP1vwsfJvX3NaOcVQB7VkvbC0Yc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qy+pk1gM;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780994; a=rsa-sha256;
	cv=none;
	b=UWW/vGetHSnQ2ffZxrssJvXmRqcJ4nSqWXVglrj6MO7DQdhMnEMGsBjSRjCCMOftSJRj08
	3qIcLGu8/bj9CFc9RdoQCtQt9tzzuIa3MRqb0qAdM/WNzMQrtDnQBt3ZOzenUR1k0MNU/B
	qVqCh7T4guAZLcVaH4U5zRPSsryRpc4=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-336b9473529so4998543a91.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759780993; x=1760385793; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VextjEGcnlm32GGbyDeUjgrLV8IU5CS7mWQhtH32SsI=;
        b=Qy+pk1gMRPNj3vxVNyNTdURXI30fvlKQ/Eyav0/+uThnWqh6UuNoDWFiL/0xQhp9tC
         K3dmL+/WOP6N9WrhiOE3Oh+9kB+uKWIuXHObI8wT9IieLJ353xcG5oFV53TN62vCFCIV
         SLgQUgDfYxIAY9Io4U9jComrLDYuuaKLHuVtkUYcHzVGnaMX+sBnGiOS0GR6mVM52U7t
         bu1CFQCnHezzYiQ+Z7X2ZLfvumX8F4HwSm+QEUpiNoOyrCiHxsM8QBL3tZpWwjIh4LXb
         84Jj6ruB1AYAqB75Yusu1jFtHXNBnvXcu3shjSBU6IeZWQum35t7xtHn/jXfsCJ6NMm+
         GmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780993; x=1760385793;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VextjEGcnlm32GGbyDeUjgrLV8IU5CS7mWQhtH32SsI=;
        b=Hl5IQ5+vIDTOox7EgvPMzm0qXo0KRVThHansbbMeToGdwrQybDWsYMj5og5MTLRAlj
         uD9BrizZSc2814mriSal5C4Riynri1++NtpuYFA+iqLZVTZWFr0ciWgh61ZwP6kp8hj8
         W5ZtnRdOpmxv4Iblfiag9BAiK0T60jGTQ7o1rhOCgXf6mFfNUNQIEB4aqVAg5fl3vRMf
         QcxB6CXG4sYiQJQDe2LKG8Kxgp6yWXhVaqSgAWGubhGTEPEOjSakumE+QpPa29LKA/Vm
         CQvO/kh2M0f7pvNf5TLJa9+ipartYpsMyWx2l5md9FPRzLinpMaMeCnV/XBrPTD2DMT/
         AeVg==
X-Gm-Message-State: AOJu0YwwuCVRr3OvfCvFPdZdxaGhTeS9kDbmnx8LQ+76mOJO0mCpoRp2
	kQ/Cvi8bfvQrTNyOr2xMj5zEmmTPQ4IafM3Xhs6RreceAySMiW/yllZgL+Hxx1S0
X-Gm-Gg: ASbGncuvMz2l3/6juUJHwoZcGS5j117PCclbgnwFt0U0IB5uKoJBuCqCLSFMjUri1wG
	pVS7YWa19FBYQIZWDeJDfXYmdV/kQPfAJcsh3b3mwuGX9lJXaHZuToRBStaPjUC42qG2uuiSVd6
	S8UlX8LaM48svtdxWYy/2gaF+rK36oRQKNFJTdGlPV4URNvoVNEqhlxLwQDsiBy10cfRhGebHk6
	4R3LvAmX0xKv2OT+nuAQ+NW1ZkJVIC4bIRid/jOg6ZPq3FgvBt7c8yWMjV5Kjj9MZoS4l4ot8vv
	Mi1ckkgd+IvhxFftMZB6ivwUq27V+QSpIJ64swvxomYbzNeJ9kbOmEpA+4tp6Wuq3G1GAfvSOVJ
	UsyO6gkXYH+wrIqNK15fDVwHyxapuiH/yKt4V9/8P3J7TE0Sq2gLeJIqkgvjr12s=
X-Google-Smtp-Source: AGHT+IEEC/OlDJjYylUZwXM70t8C4JnPOT0aE/22j79CrAET4Rb6cfD67kwfl+/Yi6S6WmLn1QYf+g==
X-Received: by 2002:a17:90b:58ec:b0:330:a1ee:e119 with SMTP id 98e67ed59e1d1-339edaae564mr1057063a91.9.1759780992601;
        Mon, 06 Oct 2025 13:03:12 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee0ba20asm163148a91.4.2025.10.06.13.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:03:12 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 07 Oct 2025 04:02:34 +0800
Subject: [PATCH 2/4] mm, swap: rename helper for setup bad slots
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-HE-Meta: U2FsdGVkX19NW5xYght8J79Z/tjVxBNn93J+ptdqsPDeknV0UC+AXewEejW2b2lYCU14vxdEnzaxYUPBpVr3EhPWZQAZ+GQXVq7EnN0wfGo+KJ624Uu5RLHiEKwrqu/bwkjQpKzS9Q7Wb9/1XzEd/bseIa5+qCAl+QqIfurHWse/uBZXCTDdvT4pmRALbgA1rjj1MaE3KkRkR4W2SVe0+AlfZibzeNt3HTkkXr9jV8HbOBIgC5ICCRlntuYvC6wI7fx2L0sUu1ldgqmVioLXM5R3DURA/d08eYiHVjwpP2s33bX6geRd5K7esFZwCw2xtyhSvizPUhLUUX6trEwwY9Zh7WnFkWXH6kY5gtVIlvqLwSNE6GO+UrYkn7PiQn+O9bsDvZvr86qDFMqMusdYXBa6oBjVaPngy/uiRG2xl3lc2XVDqlFCcGpb5z1GTj8yUm4D66i//a0E4zI7kroOjCJQKoqVFuCfKTWavapVnAl2tQOc7POs6EW1bve8ZKnpZTe2fe2p5lz42HBOFCMukVPMkiue/RKOJzZ7Jgh6cnla/MdObdbdGAw8ueire1zv0L0OxccZdgM8lhRFANG94ThItO02EM67GVHSj1aTCULOHS+Oj2c5w5Gguc9hNw3zCokWor744clQ56udDOwLC/Va2iyRg29nHCHShIlMUrH/5/cl+ZOuObr20Y+9VyFrZQe7dN+XADbLicHJGlcd7HkZsrUGJqg+djQ+2hCKPIABaRo4a5ufJTcLllrugK7IjVanGEA3earwE8l4GRCazqXnx8Tr/w6BaoN5s/L1S4zcqbDOkMeaikOo+bNIBMFzcRMk+OzcXQjTvpWRSmxnCHBZfE8u7G7xXUsNEQm532L7+YAUcIjfdkAfzN8PZnATm2cnA9Mf251n7LENl8Syy94t5uK+SnvhZMHuu5hcZ7vDApdS2kPC2FYHE/dlLxXWqW05jylXZBzTRpBe3Bv
 IoFTs0nE
 PjJSyHb/hPClMcpfk2UM/Vmj9+dne4WIuVfTPsipCyEMEZ8d6Eavr5jMADB9jVrRaAoYmAC1TVYIRWSehAQX5k23ZWUo3dZmOtlJemBxLW8ALg8c1jfwDxNIsLrpOCSOmqRAng99wACHdmJNuHp3+XFDrT85+wQliQqNu3CqxWxTpZPm4veouQUxDxVMfkStcAGIRhD5c1p5qwNkDG8pTrqeW9pYOIt06cjggUxJJ7k9URK6bYIncBIsJGQMmIYQO1eMI0BvDAFXWpzaDcj5kwtSwC6RnU+yEcwbRqWrSQEWXxD/qqbXlNDgv3uXxhEaU24iJtONNnZPqOAsJFMOun6Fl0sk3+440gLV5Avbxtj1Y7fLVqQCC3wlutqwDBpamxWrXC/0hEODdENRdPc1xAxjlBgloYi3FBxk/67hn4eXfEuJOiXazG3LaX+0kOkUIeExbtqjWSFgYDLC4AKCEfAOOmA==
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0E52A0008
X-Stat-Signature: srxr3atys8qj4ijme9xz1mfec39nrequ
X-HE-Tag-Orig: 1759780994-15930
X-HE-Tag: 1759780996-348694
X-HE-Meta: U2FsdGVkX19B47maZaZ1S00yQotn9WyeseHLreL87aYD0betOda3XSj+FKIFEfOQCcXaHGEEDC7IG4oiiOev7/ux3rQ0nXn84hdpUPUyd22wGAX30KelBH2pjj7wyRE3b1rzm9/sNHgsV1i2gJc7tF6hm2iRNScXuxJ4CjlhHADZSTVTdEqk/g3kAVSIbaXdsYxnTbmG4BTe0zzsGLRHGwHvWXv6WxUHwBhMT4Mds/MFUnRqr3dEpXSajNyU2W3q2wOONovP8l8gI2WOil1LnjqTDcyz6CUFlB49bk299908BcfEGZse6zCih7gSNVFfSfqa+YRxoPYqJV8EWINuf+ci9PWcxaANNgxCcR1XqfBmJPRyXYgyMSeADIOvilhmNfMsNg7PznRi3VgPa4o7SaeDHCBRqWA7aVT6tZHNb/6rGeQ5EakuSzy8d7yM5RlKSwVmskSsSK5WvfbfiVIAxBGI4qBU1q+/ymdTxUqIiGzBciTdQQwShNZd6IPl2uJRepsotOzBBttsqZuDjjctO0Q1WtIBje+dEq4TTCTSlD365Tv7cpkppg1QpsgCiUhoYpf0p0YDLcx+0Dnf7++v51UEXE8b6O/d5jy6Ti941tZOjjv6yLzIWcyMIYd3kIDtFlBWu+ovseMG7QAxKrVScrSWXqH3TJgFioEklbHW0PsO7DsjdTJDQxCZo1uVQgs/f49jGXxSlSAmenq/jY9HpCqYk/ZznlxJYCHvaBsz+Jzu5eAg/UEHfjHwPZGrR6E/7yXWo1GCuSjY9DToZl33SqBe5YWdO7SCUwKwXslqh0ES9xViyPx6zH5ZlZGC5nrGYIOch0yGdh9kP+kuxf7a8HHemSWYvMInn8zt743A/5MZ9Vx5VPuu1zYeTCVvg6BcSYm6MiC0hYq+kRdlgpeDkSj/JboMkF+9A00HyvqMvRVeqXzU2jnEMwTK62M22rYqJsg931PqmXKgBIX5eiM
 gQ4JZkIh
 wTxT4efLN1BMxyICS11XVDes6Q3kpAzs7u71M6nyDhjsCBMHuqfuoRr6ttLxlRLabmJCSeC594/GuXTDorHIPhDIDsTXEM9j3IJMcZofL61kYeyHtUkqmFtelOrBEPauxFCmsxFQrw0lQqUwOLLCzeHaEntSTB0Z3AMKqB3BIR5zaZf7nxDB53okmbjT0bCp+E6ctgoVmp40+KXQ7gu5kdek6MktkvoGevpjzWcmjcuBi8J84HkiG5cjbzutXtxv1Tnqv3GxZhMWD6nrc+raiiu1vG+gGZeVPvcWjstaqHuHcRUW2nGaw0JbSsx34U1XEr0SsZbj07PDvsQUyzKx5uxuT/tHzIOV91sdB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The name inc_cluster_info_page is very confusing, as this helper is only
used during swapon to mark bad slots. Rename it properly and turn the
VM_BUG_ON in it into WARN_ON to expose more potential issues. Swapon is
a cold path, so adding more checks should be a good idea.

No feature change except new WARN_ON.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0d1924f6f495..732e07c70ce9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -751,14 +751,14 @@ static void relocate_cluster(struct swap_info_struct *si,
 }
 
 /*
- * The cluster corresponding to page_nr will be used. The cluster will not be
- * added to free cluster list and its usage counter will be increased by 1.
- * Only used for initialization.
+ * The cluster corresponding to @offset will be accounted as having one bad
+ * slot. The cluster will not be added to the free cluster list, and its
+ * usage counter will be increased by 1. Only used for initialization.
  */
-static int inc_cluster_info_page(struct swap_info_struct *si,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr)
+static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
+				       unsigned long offset)
 {
-	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
@@ -772,8 +772,8 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci->count++;
 
-	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
-	VM_BUG_ON(ci->flags);
+	WARN_ON(ci->count > SWAPFILE_CLUSTER);
+	WARN_ON(ci->flags);
 
 	return 0;
 }
@@ -3396,7 +3396,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	err = inc_cluster_info_page(si, cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(cluster_info, 0);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3404,12 +3404,12 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 
 		if (page_nr >= maxpages)
 			continue;
-		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = inc_cluster_info_page(si, cluster_info, i);
+		err = swap_cluster_setup_bad_slot(cluster_info, i);
 		if (err)
 			goto err;
 	}

-- 
2.51.0



