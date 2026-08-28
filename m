Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0359FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8E26B0092; Fri, 28 Aug 2026 14:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A99B6B0095; Fri, 28 Aug 2026 14:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF606B0096; Fri, 28 Aug 2026 14:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC51E6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:36:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 552E6140506
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:56 +0000 (UTC)
X-FDA: 85151534832.30.E57D053
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99A4C14000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUKPAGG4;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tj/6UYQts00alOowhGV+RewyQyJrbaYQ35fI8AlyfYY=;
	b=xRFazmKenz9n1I2A9iaSjNR6rspQ9Nuf7eMimYaQDWOeha/SXXXR5z3FJasbounoopGw7r
	i5I04QhBBJ6Ccu6gpptX3uz0T+OSj6It+c4XZRKepCxTCjuN9Y6sqLYzFUVhETx+8H866U
	Cp/MYlOFUD0q6WCGCN04aIKSG/B588k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cUKPAGG4;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942214;
	b=u3btU90NA8BBlP4tCrrf8ZMQ9eik9cOWFXnJ46Idu09n8wAfYZ8O5ncgQEXhF2F/t4vdeM
	arbN67/zhaJ4IXxG5x4Q3UoIx/0ePKWR5M7RUxJ3exXYyi6fmGfkPnI6jPkp4TUkvaQ6oR
	26lVcORW000lsfS+Q+ei7c5Z/HwE6cg=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e27035206so1240299b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942213; x=1788547013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tj/6UYQts00alOowhGV+RewyQyJrbaYQ35fI8AlyfYY=;
        b=cUKPAGG42dwCdTDmatUFQS+yKy8MYnVLinGfx16ocf8fHG5vllgcSB5Lrh0cfypYGx
         F5J+35sqaKUJVhXBwnytONzl7/4tJhoooiu03pT/SciFxxY9RyTi+aoZM5Btty36OaAf
         SzmfSaQ7LMKmIaxGFMFyxDafBSRqxAVnL5goSF/K8vwp8sD+346t/pxXLOo++1e04Q90
         77onDtbqeRJFb8I9dVoTZLi6kqwx3OWUEc5mqp0bARtMb7CqYtxhbabXYMIZ+QqL6YVm
         +plpFbmWSUlcWPSr3rGfUX0ToeJIoFLlPLiWtjIoJak+YZkOOr88lPvKrs5o5GGdjJsE
         OO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942213; x=1788547013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tj/6UYQts00alOowhGV+RewyQyJrbaYQ35fI8AlyfYY=;
        b=G+HeuFOlddM3I3cvqX27emBGeBznIX4hRl6nCAi3H1f0s2YTOuJpEkpNncck1o40DH
         EDs4Er5FqH51YYm3By7Dc/X7alFJR51njtrzLp/d2DM8MRpPvoiMrVZbDzx7UnajUKmh
         n8GVe1FLw3apo335TFYRhtiEyDRRn0FT1bdYRki2w5yyISGouMG/1Ru73S5PkTPYe7iG
         yegUCugJEV0Kf0Y570vAW+UpUo/wXsL2AnFjbtsATJKyw349ZtS0Scl76bVGMy57JSYo
         v6BEkjq6kXmwOxMI7pSBvoJP3vs/g4yPY47d4tTxiln9aiUhymZ2hJ2lsb7sSrv+memc
         4yfA==
X-Forwarded-Encrypted: i=1; AHgh+Romlh8lbnkM5G/7dX412KV0LH2fPw6/fDn7O9ZFPzTefFQJGj2oyytZkd9SEStvXJ4MCyib81HJPg==@kvack.org
X-Gm-Message-State: AFuF++m3UWx6RjYvda4LFlNqlAjqwSsnj5GgUlB1v9vigwvRWsQgY+cS
	yer9a9fBLMYYCz7PVpI8plnMwA9CqDhfKRkW9kjDPN16zaFxCsMS1C6c
X-Gm-Gg: AR+sD11Ah2Mo3hnVb+4GvjzaJkTiLM9/MO7Yj3kLyDnwQWxtm3wRznUhYHbuMuEmwTa
	FUNGPsKycyriKUofU3cLb58XZd+2npBf8W1zcQSDMi218K5yufaLjDBbtwXktYwcxXJd3P2T2CM
	bztd/CN7TIG7tuGb8JOjd8Yc01Hj+MxyodxYLDkMZvcdcwVitUh+BocPqg8VHKCsj+JV/r94itb
	Fxn6W9y2+fyE9n7QpyQBlYWgryp56x7OHHLuXDzTtxkDIN8awWmtIzp28PvMLPudovsS8iB29BS
	/2CrPTaFidEbFuvUs1T6KxXSaDUmOvVxgANqL0bFcZbXdXkAd2Z3XEfJcPwTLQRW5PSyHO7kW3V
	UI4lyFjN+n9fYxT/L2Hkc22iSGpOWMfpoX1FcoRk6EfaR+uOAQN67lFWlW7GAdwdBc7PovUNK4b
	FH84UCMzOBCUa4P/YmS7SzGjepLoc1S4wMngD/VErLgNvrDmlQJ4psCrmRfr1LaHfu3eATAy6tq
	gItaglXZ26BXRoO7Q==
X-Received: by 2002:a05:6a00:2ea3:b0:855:1590:ba2b with SMTP id d2e1a72fcca58-856285920b6mr16244293b3a.5.1787942213289;
        Fri, 28 Aug 2026 11:36:53 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:36:52 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 0/9] mm/huge_memory: refactor __split_huge_pmd_locked()
Date: Sat, 29 Aug 2026 02:33:10 +0800
Message-Id: <cover.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbd3x7a6kqfkiootpp1xztpuk5hnhpjc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99A4C14000C
X-Rspam-User: 
X-HE-Tag: 1787942214-782101
X-HE-Meta: U2FsdGVkX19MkTJvz5dqgvaCbrmauJezsj/XDGGcClWflNZ/r6VjRJObyQF80Jft6OSDf719i3ybMvbzLSGYQjaPLuoFVbWUMjH8A33NL+toCMN/yWfHRykhD/pjVLPkwB1SlWAqWcYiR5gzdSCuY8/+c43vdIRdt7BFfL1cwMT8KhSmtK15ul/QqInDmCxjPjWvmOE4zEtpbcuSCXWuq4AfT9z3pMAvyZtSIw2LN3DE2S7Jz3Q2POmRiItAJXN6iy2bnP+bj5Bos8XLhCVmlXP5iI7G2DvDvuQtoM9mRSDPnZG/5CPUdXCCiXIYN6B7qWkRHBZOfT247YyHGUmbiX8jLbvLMbGMZMm98OBG8rM+jjy3VCgFRy05/ygBjG3hw5M2zcB0Ocqx5M6FKU556dwyKzhN6G5Qey2ICEweyXTT6hQCpCLTmPDTYAPVsrW/x2JFxiwkkSsjrCdGTd9z2g14PFTm1pHTlLkBzUdz41uZ0yS0Hbdk3NmG7hj0pkim2IRK/GREty6/1tWZceNQf4S8dj0rckuoTvDMWgV3I7HYcj0/wzlzk/mUr0EKImlqNUNBq2EbZJrSe2aElg4ena66F8xT6eHNJkIlumlkO0Q1EwybDlJqdxvFW5GuMK2IomMWgLJX6FcTKX8uCREvUmVmWT2nH6WfJAxafB6tyidkP7wAfuSzion1LqKkkajVBYReyCc3goH+qt5hyCBumQ/5ta+bap8RWitd04iKaxN1RBNHKKEUs8RdnXVbb0SBRZpICHtYmGt/TM1u300B/FO8Btb/UNpg8zQHofso01HAgaEUsl0sG4zhOuqOLlaE2wN5yo62+F2QXo7n7eK5f8Xc1TYm9ZbGOuepPd0AeAJ/CFW3GFb9CNrK3OjJ43eJ6ps23Pqo6TYlth31azH/LHGZypcN2GmRH+tOUgYA1EgqQmu2005E106HH4KKMRWAY6Pol8TL+v8PhFCoixw
 qaCWol0i
 tPjiktT4FI4lOUgGrWddZo9oT1SIGOqJceIO6oiJLIe6UrZMAS/HTzitOaRMju5qcTKajB7WwRDvRePglc5sH0CFz5Uvas3xZjkpoDT6rrYvZ8wXRNyIwmsOMbsSXM34kTrGLnRIYDxUb41TONDtEbQTzTH5GDVQJeyy+j+FPMCZYugqr6rbm1YDcVgoYRNJ8RchsoI6s8K3hOmjx2KB+q93f5E5MX+MqIRr19zCYezxO1+oIuikcHYaiwPQAENZBvgoi3u868gzBpeyZt2cYhDsDxXd7EroWxWpdXDFh/Y/MlZT05D0COOEvOtk7QQFbS66f9yvvCAi++SlN3KCaJyVTz9J2M7zbspPXxKerJAy6z3vTRyUfVeTHxuELLESrdQvf8XULoLsXKSX6NrpVXDnhSv+B5PaePkwySikfWOxY4H9iuSnVjseFRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_huge_pmd_locked() currently decides from the VMA --
vma_is_anonymous(), then vma_is_special_huge() -- before inspecting the PMD
entry, so split and zap can classify the same PMD differently. The entry
itself should decide. The function also mixes the present and non-present
cases, resulting in duplicated code.

This series uses the PMD entry and its folio to decide how to handle each
PMD, as zap_huge_pmd() does. It separates the present and non-present paths
and moves their common work into helper functions. After this change,
__split_huge_pmd_locked() only selects the appropriate helper.

Yin Tirui (9):
  mm/huge_memory: read the huge PMD entry once when splitting it
  mm/huge_memory: add and use huge_zero_pmd_can_split()
  mm/huge_memory: add and use unmap_huge_pmd_entry()
  mm/huge_memory: use normal_or_softleaf_folio_pmd() in the PMD split
    path
  mm/huge_memory: dispatch on the folio when splitting a huge PMD
  mm/huge_memory: add and use split_huge_pmd_anon_rmap()
  mm/huge_memory: add struct split_pmd_state
  mm/huge_memory: split present and non-present huge PMDs separately
  mm/huge_memory: unify the migration and device private PTE loops

 mm/huge_memory.c | 525 +++++++++++++++++++++++++++--------------------
 1 file changed, 302 insertions(+), 223 deletions(-)

-- 
2.34.1


