Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD283FED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A456B0005; Fri, 24 Apr 2026 13:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB486B008A; Fri, 24 Apr 2026 13:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1106B008C; Fri, 24 Apr 2026 13:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C72C66B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:33:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E9068A956
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:33:58 +0000 (UTC)
X-FDA: 84694147356.01.12F1394
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8DC008000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:33:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VT/LRRqZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777052036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPyGjLt+iGZDFvL2Bll9Dt+u24uS4gQyWucsdGpH7po=;
	b=2DVXZxwK1hyRwR/lyEejedSF3grTHb0lk2rm9d2eXyL43j2fOUBv3U86QZItpdJbdWtS31
	Fiwixk/KkiwQSAmh1si3QdHVwrGrf7BjfRLP98ueusXa57y3V0kYgoeeaAL8Z/NGVdQYBS
	c/mqafR42cDYSf2s6bifmme1grYYrTk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VT/LRRqZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777052036; a=rsa-sha256;
	cv=none;
	b=uCHFktmuqLTxQi0CDwBQXhUhIKP+svm8kFVV/LnOFEK1ca3pIXZTp47CmetW8R7j4yT50k
	9lhP5CxKypCL9Ex24FpZDmrUNSPgaPH3ykaA5wscg5Pl6tllz9ZcRumxFsjkLW9KrUMax0
	I/WvSru/0zXsZeyNmC0WQkSvBPS/TcI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82fb2d0c5d1so3682108b3a.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777052035; x=1777656835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RPyGjLt+iGZDFvL2Bll9Dt+u24uS4gQyWucsdGpH7po=;
        b=VT/LRRqZjjzAv1WPvlhf4QzRrDm0Rksik7mYtyJVtKHBk2oy5b3mNurKgeXwoh05+N
         wxU/+MdkQ6BAyAp32OOrqAqISLFb2reDJ+91J6v241YELW/JSNhgPzyQYRt+xYSyVK7L
         Pl6uqIhb35Crzzca0/W83uQqMBrccJaNEdBX3JGbOjwEoK1XOQ6XdGFO2J8KKClOCotF
         OhbV2142Mt7KbJVu8p1eoGZ/gEXC/d8UZAzQoPgavpT0Tnb8KKHX/wWkOBYRAwiSvVGN
         4L4jmIKfFpdrve/YCgKDrE9uxtEGAZsQFgs9vuOX/CZgsWwrsOmKkS6rC6P8SfClnZ0r
         15tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777052035; x=1777656835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RPyGjLt+iGZDFvL2Bll9Dt+u24uS4gQyWucsdGpH7po=;
        b=BQkeavXT0iWmiH2HynHeBTmsjGUEBY2QvzE0KSuw6tRmYTMBpVGqcTBJfPPcBFOHrx
         /8byD6whby4iq+WFMGuENxAlKPaTHgvgAHTtOEQBZtCApy3lLt5+0d1z2lY1MQkBBSLS
         Hl8glR7qO4JZOa1/qDzn/86wp4CW+6bkWEGyPXgCuung55r4xpasgUNAFoegwhVy3uCj
         Gw4FggTWloA6HZiZsONCQ1+GoSF12MA/rOqlIvtrOHuVOHqgknUxNudfk1/ZfGNpDoyS
         GvXtAVTTntIvbIio/KbE9pVRTQCNINVolE60rK01oWBGHN0O+QK/FPNVLSf9bN959I3T
         ukuA==
X-Forwarded-Encrypted: i=1; AFNElJ/7cQPHPC/DtFzWW7Kh9DGcF6BvnurJxIV4P8Su/eS61k3T+K5YC44mPvUDK4KFeaZHFjzzzAuaIw==@kvack.org
X-Gm-Message-State: AOJu0YwrXJoObQHchwUi7h49tAdz1r+/DR5EhjA5fG3FqOVjFgbY7Ny8
	oV6Qj6BkRow24ce7ZZOyw+KpicLxMfQ8D9ku4dc/WaMLG+t27EpKRFVS
X-Gm-Gg: AeBDietr39rhq15cCXSD9NA6DblmJKPPVpKBVsQf6IiFGfWssiKXX9iQdYAD9Se4GSB
	fYg6Ij6L0d3OKn9AVfcuBVAX4xhdJSw0KIQ/pTeolGnL+s2aqrzu1ad/7muSjfWGU5WknGuOnI8
	wLKJUDgYNaxiN9GHzeva6RPxJrgukNquaVhiYvhDsr/vGihcJcjTq+AMHIjm8h12CLctieelfAD
	FZdwHt9JJk15mcQzszFKytiqYhdprM050If/Ow5QgHyR3/PV4wfcPo2uByhkY4L7vDzoeBdW0JQ
	0PRkBLnRpE6wePPbZXPT9yigCUG7VrckBMm/mGiSQpI8vGvpBpgbmfIuMmsmsOxJvxqenpHxG5X
	lHajhg54MpO57tFTKDAl+2PLS9cTIdOpIOfgpqKNjvAkC8uNqnXRUdBGAXYJlpvEpeWL2BXZzGP
	nv/2Zy6Wxt4lifEemLwW9kUSwYfwlSSU1Xbnse6EBkQga2I5UTXNMGZOA=
X-Received: by 2002:a05:6a00:a83:b0:82f:4bcb:a9d5 with SMTP id d2e1a72fcca58-82f8b387e8cmr29061189b3a.14.1777052035092;
        Fri, 24 Apr 2026 10:33:55 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.19.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e981c12sm29647462b3a.6.2026.04.24.10.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 10:33:54 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: akpm@linux-foundation.org
Cc: apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Fri, 24 Apr 2026 23:03:47 +0530
Message-ID: <20260424173347.44621-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
References: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DC008000C
X-Stat-Signature: cnhm6nms33n8trespxzcbcmhbzojn9zn
X-HE-Tag: 1777052036-308078
X-HE-Meta: U2FsdGVkX1+3CS3UeUCLQ3OlOhOmMeVh9VW3bb1r9/nGzWz3LKpfN3JHszEoEWnj/KO6IU4C3cZpcfCKCgck1+XBfoMYG6WLUSfu5pDuXVdl2pEmaY2z2/rNp6a0b2a/2Ao1B4E8OlbvcRaJlguGs6JzfbC273F+OU1iXdo6c8d2DbWIriAWETmoA7wIUQRYGNi3nRLnXiKw0l8+oxasduLqOBMos5KOdISoAalaHSmmwPrqK+j4xV5LIMYVmBLtOQwcL0533n1XIsXMUSUrRaNcDhN7JtvOMoHwDDUyQeUIAPJBRQS4a5riajRWZ87y6FiVhRVp/b/7F52+WWShwUmGBb2aGWlAzPDlysWevTgE66u2yfkF6lfKExp1slJy1qHYk2VaXKgcxCflJWXhIBUsdzBefy1UIg5B0kU8VhHquSK45sW+B7dVmuInxgOcb/DKBJV4fpsnmkhLP/NVchPYaOuP2Lt/w8wcjkRjbSYtr+lZmarqMsEPUcujaVpbL5C1SfIMyp0nY1/uDlvDs0m91BXtE8TRXq9Q7IhdxfSVSmy2BDSYQ4a7etiF7RZ+XfeWw35HM/q+vzJlUY1T4jL5w43a6JknPswWqlf5r7PEOEsV21Ek4WApLStOC9DdYqv4aHBKRov9abdPVO1dU+O89k/j0yxo62lBGMA550vo/BhwTK8mwJppOMYbdNS+kRTwx0NljiL/pXFtXKgXcTWY411uGCtG8GVRxZG1qazsYQ5ZCgmNU1JdQjXFwEO0EAglzJmO2ibJ3L4rH64ppx4n0+OaCtZoyXlcL8AnJOrEYn+TdcbZeZOrX3kcUi07fQ52WwF8B2f56YD/aV6FHsewR05l5reISYipEq54k1SzxrCprMWECwlmCtTGygFe5ng5c/n0kgNGBgdEn0KvYsSjyZxLap3tk59OJ140OrneC+YiBETMUffZi2tL/W98gEaaWpRoRCmTrJTFLjG
 IZ51Qt0b
 16HxdbS0sjIfs6uJOwp/ORTZSqi4UskbzoA8DYufGnDBV61oMScZ9iMidgjrC/cooyqfeDKFDVMH0HJMP/QkUdoYuiw57uIvnxKbx9pQB+Az6G0/bb+KsfHN45CsjuoDvb8cAuoAUsImxURpjyo5/4jaWKb2sZlbu/ianwUW9LHveWw9P5oSsFBMofXWE0/z+bAnotd4N19NOIeDXrXJTaYviZt/jtPPAIGYNdOSmokVtahZZIEFSZZJ0jKbov4l1dSUHC2JEhOCgbOAlY/D3TyvDrZGndeRNTLr2+Le2ozVuTRoKoHAb/PgxP0GqBXpvASkWDKJDxDlsfGbqIytMZQZiZ6f0qF7ReoT/ggsrbxuwLi4TsPKASxQV17q769PBWzvC6Dz3S6TQs8VuY1ymSVreCjLp5XLMFV9RJoSdOLSy7WIgGHBhh5v4rYPKt/bpGFDo0ekOMYp0pUhPLm+5qM9pC4DTRWTYayyMMN9NAWz5MleB+DviuJ0nhZxL2guj5sZYZNYOOjRbbQMujJfIe0S0me82UArBuEtYrJgOh7XxHeisSbNcaKRQT0gMI3UB/j62ybmhk1XeE5rkR9oWQDhjyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:17:43 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
>
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
>
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.

AI review might have found a bug in the surrounding code:
        https://sashiko.dev/#/patchset/20260419174747.10701-1-nueralspacetech@gmail.com

NOTE: Ignore the previous message was sent on different 
Subject Header by mistake.

After looking into the AI comment found two potential leak.

1. The goto should be unlock_abort instead of abort to ensure 
the spinlock is released.

2. The pgtable allocation at the top of the function
is indeed not freed on the unlock_abort path. Will add a
pte_free(vma->vm_mm, pgtable). 

Since this patch is more of Cleanup on PMD checks and
Warnings Is it ok if I send different patch to address
this potential leak issues or need it in this revision
itself?

Thanks,
Sunny Patel

