Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01009CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B4E8E0018; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B5D8E0002; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409CC8E0018; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4F78E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA0C916048C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:47 +0000 (UTC)
X-FDA: 83974490334.06.74E2909
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5542EC0008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kkgq7jnQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759917346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=boOa4eLc1Uc4zepJE6C2P7ZkO91YPJqbz8mrgpCK+/I=;
	b=6OanhfhH6XF9DDeumKCQGL9Wj3u4oxJ9FFnOuxxi61NSl7qocSS+NKPLfBiBrVEugPqEV9
	F+h9suEGUUzod/aoLA2YrUd8EFqsZhu6wcClJTPuv4MqqZSMkGuZZVdPy2BMEfR9ZpeieU
	zcj0fRB7+Bv2JSxagDdbojBZfQXVLhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759917346; a=rsa-sha256;
	cv=none;
	b=6NIAXXuFvQnrh3wgzFOhuA3Q6NP4uleOwTdu+p9WM2Wa/W16hELLpUzEBh55Wwi1U+nZj7
	wPLJsI7AdPQn/LSPbK5VF1vtv0PRidfbwcTxdaU/gxfypcd7iCFGWVR5mD/KMl9APTZklH
	i4EUwd47ybjHUi8fJCysy4jxIo3uUGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kkgq7jnQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b50206773adso144470166b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759917345; x=1760522145; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=boOa4eLc1Uc4zepJE6C2P7ZkO91YPJqbz8mrgpCK+/I=;
        b=Kkgq7jnQvJF9q+qFdA0yaLNlN/N4nOU1DlNPWMldy6ckSBQi6+KWetBJofxpLvgZTI
         02h7yErbGtVZm5pOkJ4Yrmm0ZnTT7/FKbYyHhoIEbW1uswJvFYHsCh2lAThbvtpzBTlN
         spb1gW7CQmS1Ifv2ZcGLlZZBovPgKEr+p6+m0++MZCuANdq3V7+ngDfw7snn+bAC1+qB
         unsf9o0shlfhUtSUj/HA8NkDN0xqx2mJi6XcGC07MjYV5LxQYigHhLPwcBMb6Hy9VElt
         h2aGJvVqVeRtxq24bwRtnAPxgrCCprl27Ve1NDTrqwvZsxi+pPueidNOo6XvHRSG5Rv3
         5xDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759917345; x=1760522145;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=boOa4eLc1Uc4zepJE6C2P7ZkO91YPJqbz8mrgpCK+/I=;
        b=v49RRShzv1jb9c6UFTKSLIPFCAsPfmlzsGGS1Mvc+4FT0u8Pm8Hnnk9NblTCJCu+so
         nDM/kUxgcFuAd0fudROIa6oAqglZAanzWZQBLpvujudMJIPBNFDlur34p71Arcf+QdfY
         HS81Fp878VN0Yq7/1xqrhKUiwnqcZkWBvVqwLNh0oY6sW0/HcJbrR0Yz64i0vFEpJX9I
         b67hD32r4/uoafhFFEXEJrrSY7rzLTv8qfjFQd1fk2SnkzMESDTYLiVwMCDH977Gv4wU
         jXGEvYl8wANxlOdjvduIOGsCc0ix58OD6EK20iGh1l5jJ6+eBle5OdEI1nSenNdpPTuc
         fgPg==
X-Gm-Message-State: AOJu0YwX9crpCS55GEI+UeERw+dwM+spmH/wTIseMlgsD7XGfZVtyFCr
	xZ4jGM0YHYVrHdJkxQ4CZvmARE8uZ04F/74WTUW8x4Xw8ZEM9PJ7SGlj
X-Gm-Gg: ASbGncuPaSU830Rmc9If5rsPuqxgfA3s3Caw9MNdPDNEwD2gV3H91Zb7AQq1aS2CJQQ
	ZuFd2qjzD1VGGCyXuismhSsvdEGQA4J+n0N6jR4MVM237mzHCj+b8TN4/knSGxnnVZHQ+vil1Jk
	PiJD6BFqal+I+Lfn3bPNuP/AsLAm4lO1GPuKOTH4FSxiMRT/rgormbOmZRDcLXYz7+0L4jq8J11
	lVtq8E38cuqz7j/YGu9Ftgg5kQMNzGeSd9n11PJcKHsBz/xyqFMKIZ6e9gFf/wgrHoawcE6lAbh
	71f1vsaDZRegYmHubCf8COJUL3sJ/NMeZqvmhl2VmggQo5Dhu39hyKzZl0DAy2kdNFeLr/DYIsi
	KIY8NznhlOQJuyLsqs21rJpTNThAL9GmlAItGSTtz0cYI+gMuFZFULnHZoQua
X-Google-Smtp-Source: AGHT+IEb7V7viY97iDpvMF+qJCiJukE8II0UlSHd8VansM3Pb4+onnHrmdHcTERjFvFAyoYLacsRAg==
X-Received: by 2002:a17:906:f5a1:b0:b04:4579:486e with SMTP id a640c23a62f3a-b50bf3b6a8dmr310520866b.28.1759917344617;
        Wed, 08 Oct 2025 02:55:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869b57f0asm1617088066b.77.2025.10.08.02.55.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 02:55:44 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org,
	usamaarif642@gmail.com,
	willy@infradead.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 0/2] mm/huge_memory: cleanup for pmd folio installation
Date: Wed,  8 Oct 2025 09:54:51 +0000
Message-Id: <20251008095453.18772-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 5542EC0008
X-Rspamd-Server: rspam02
X-Stat-Signature: kad7fgoa55k5p63844ri7sw4cdj8btkq
X-HE-Tag: 1759917346-769452
X-HE-Meta: U2FsdGVkX18CqZW47E6A0W3vE5Vkynxfuyz4HSx4E6joZAn48TtYqGnsEcctteJYJjLIgNVnpn39vqQc5KajJIlfQxfkHy/dfO90pqo56o8s+O8BTO+r5NxhNbHjFEsAGdUP148v+hrJps8JT5969fI7wh8JOkH6Mx1IPaNQfUk7ota0k8oIRmNVidyVdO+2yR1dA9oqu4n2lY2mX4Ds7Jta7vNpL/1orPmldBHW/UoYCQtYXUEaNzb8JCuAE/RjyxqL3cBFzHQsDr0fvzZweYqbFY+UPHQRJAJ6QDe/CwskU1+chhLKT3y5sSX9QZKQ1ueSTG/sTiAaAtnWeGAwnPNLfvnbY4c3D1Eu5sWIvLpg1LWnvU/0hLCYWHbdNIlVAqudW3yTZnZjiV7cH4QEY16pocEkTC/9R9NDOKsCnUAmFHCT+P5tJds6NrVhly31/727d320Dvf7laIhQ2+ucw0N7Sjz8cG9QnF/VOoGibpwPlPveZ2U+54TuAG1oG4YGwfmI+QPOc7iBf6iUgPeKsKGMTukzJ8LoYhZB6WQsgNi/c9VyhePBrg+l/8T4GUviyY7g+3ZbpFEcrEUL3WtkrB2pID6jh5hKQCEiw9jlqV4HRJSpuYSgvysDWqOS6cmr1wNQSIkoGKncqDT16eyToJ8FgoyLEhnFgN4n1mYJF6s56kiOBtnHYPapuYjfELbia0f/MxU1mTQFjUlK+VZ1Ny0RTU2LHpDhwY3+osUzic81KqG/6sa9V5etAoB8KhUNJfJaOVJpRZOlMm4DMPm4LPvAzbo1ITXCe5mPki74Bjh/iJFJkv8Hf3vB17NEIhQzAH9vdKNrYqLK9c1DDBPeYluF7mFi5rbFPcYMflvq7nwbWEAx093y3EuSedtvkuAOz+/TJ8Zk/cLX0V9GFqIAvMaI+fv7HdHG6zuI/Q75+nl5F1Wc6jdDBgS/00g0nFTe8YHXhgT3MUF2dNd0+Y
 DIszzp9p
 pAQCjGbXVSWi725Iay7lTtq/rYV+uDibzvxieAWS/Eg8e5MS7vhfReMRF3BDmD7wFfqUdhJR7nFqCwNJIQ9EGsbPVTIlccjqUZq4qpzaESMd7ngvH+oHWnih63S3IqJ18OGwWajjgKdQxEQthUnc/iFPZBv3WpGbWHeFnRhgmLx77qKpot8pk09Ah6YcxdCixlwuf0ZYLE0dJ3bsnHAtMYP0Dyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is mostly a resend of previous two separate patches [1][2].

Since they both modify the same file, there would be some conflict if just
apply one of it. To make reviewing smoothly, they are resend together as
suggested by Zi Yan.

Patch [1] add pmd folio to ds_queue during do_huge_zero_wp_pmd() which is missed
Patch [2] unify pmd folio installation in collapse_huge_page() like other places

No code change after previous version, so I preserve the RB and Acked-by.

They are rebased on current akpm/mm-new branch with base commit:

    1de81dd7733c 2025-10-07 mm/page_alloc: batch page freeing in free_frozen_page_commit

[1]: https://lkml.kernel.org/r/20251002013825.20448-1-richard.weiyang@gmail.com
[2]: https://lkml.kernel.org/r/20251007005022.24413-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
  mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()

 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 14 ++++++++++----
 mm/khugepaged.c         |  9 +--------
 3 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.34.1


