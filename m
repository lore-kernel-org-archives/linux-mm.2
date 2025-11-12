Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8617ECD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C789D8E0008; Wed, 12 Nov 2025 13:58:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28F78E0002; Wed, 12 Nov 2025 13:58:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B660A8E0008; Wed, 12 Nov 2025 13:58:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A663D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:58:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EDA45914E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:45 +0000 (UTC)
X-FDA: 84102866610.16.CAD0966
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id DAB05140004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SbffxvOd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/O7yTljWefVJj/yKLEyf8lcxmUjNGkJCaYIrrJsOmVk=;
	b=Xxk0SViDLbuHaSrH6FEItu4UGR+49JF1/a2CWp24BSvXgmVJuZxAIKAtJyBEYocVZ9/WKv
	yibxsKoncIx5MPeXPtkectCi9jI8uP2xJrCD0tkJualzdgMXx9GtVDt51dLQZiNtm6thwQ
	beUGTIDO0vBo+H7kvWP2ZB8jZ76HXBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973923; a=rsa-sha256;
	cv=none;
	b=lJVSeQtGoztQuJ6aQZ65FkhJORD6K13V6qRuyqx5LthHRs8w9KCEFkT4j0yEOvu/hEtTKn
	t0/IWHfJn/Uo6OC0Tw1hyGjYamqMtmLQmy4E4fNK4dI4MvaGu1bhMYbDLjYJQsMvnQHNJY
	6putGPHVumsWeJOcd9Fb6gdwznuPsk8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SbffxvOd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-343ea89896eso208032a91.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762973922; x=1763578722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/O7yTljWefVJj/yKLEyf8lcxmUjNGkJCaYIrrJsOmVk=;
        b=SbffxvOdYQxY3Q1orRyS5PwyLpqny9Oe3Tc7yVJxTlG4OfbPKTkXE6A1UbpWNoPN7c
         me610WzVWkXBlb/B1bNC8K5Zqmvs9b5naj8fhR2bj0/WcIgmKBYCjxKHWZmUoDFfSU2c
         cZ2hzrUADfTjg1WJ2GHMcOcSX6yg3yml/66CRfs+p6Ca7PbWjTFiWQDLkj2cLyqHgYM3
         ejLsaPPKGvaFL+HqkbVRyHBoWrVMW47nomhJLwaC0jObCaJpJbT2I54oCG85Yk92DfTO
         iyfel33qqxfbeLOpa1WHSeoCcjkxcnqcHXHEhfRHgc86k5srSH0Ftxt3RqGmBmHdl3O1
         oBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762973922; x=1763578722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/O7yTljWefVJj/yKLEyf8lcxmUjNGkJCaYIrrJsOmVk=;
        b=KWWjdA/SG7CT7p1N4u2hhAgeYB709DdCcilpBeHhCc0M3snvQBFbnhrozaVkwNv5RM
         3ph/eXC2tHwOIxPikIrabB6fTEQeX+zzthjNxZkZc2yHDp66twYEH9KvlmwqGUQ92rH+
         LwKhzbFyqbRtFmiomF8FICNVYT/rg5qbSOsy/LvNAD2hkC4adK8vz7PmEagO+QfPhQ6z
         lQVIwkCX8ebwwtbZa1TPNSouwExZTZueE1+FQQtrcRhD+KEOCZqUTUiw+dHW3c40gSjt
         alVB5bIrRkFapBdDjCD5VJIWIbgMjvGVAm2PCOLPoG9zjkpAYuHCmERLoWPlZOarBqup
         41uQ==
X-Gm-Message-State: AOJu0YzuFIGS9adFruXqkB3yCjd7qY/Y8auM8aeIOXWPf2perLx/gbax
	UvmRCwxTHKK7ak0lAH8ovTSkM5G/CIWWJU69dBjPDhfOYOUaJeGLVHsqcx6TOoDB
X-Gm-Gg: ASbGnctEQeL792qfz2QtYnwsyx34bIr9T4E60RsgEFtF15J7y1hQ1HcsjuMv1LRRHAr
	88w9VFke7zM3SgnNSb+9/YtWb4dEcnVaeu4AAn2G4nV6gIsZnmsZglxp+FLWXkXuLJBVgRxA/M0
	zIIylpi4EpMn8YN+E+Re/jNwuxTIItTskD0S+G+AtIqaXYOpRkPJxxCDYpq6AYLas/RIAlpr0jd
	k7+MMb3w1zkAKNdW0HH2SQVkzAcsI72WrghtKUlOt3HR4eONEInPwr8w7y2WPNx8eVHWb0mSMxR
	QKcJoRXPZfCzYT/B1sVk8za8P71MugfaVBMplmew9Jv1L0Hfhil4xkWPuEbFm81nHMFU8mDZ5Cx
	TY3uyjZt2iFksS5Aav5fWsE3doKShNTK8sy7e0SiWENwPvgQ5Jwt+ADIB9n5zILD0UX8zzYNUKl
	9aJ7BnQBkxrpWbLULVrdl/AsV9Pu7B/wug
X-Google-Smtp-Source: AGHT+IFuEPZwrG3ybBGzaBAcVZuN7O+EKp4bIF5cDVmcAe1qISW3MyunxL6iIy3B7hwXG80OQE7DWQ==
X-Received: by 2002:a17:90b:2dc6:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-343ddeda060mr5173580a91.26.1762973922286;
        Wed, 12 Nov 2025 10:58:42 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm3491565a91.1.2025.11.12.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:58:41 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 0/4] make vmalloc gfp flags usage more apparent
Date: Wed, 12 Nov 2025 10:58:29 -0800
Message-ID: <20251112185834.32487-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8rfk788i3ffyya9rbispgpy3a3fia7cu
X-Rspam-User: 
X-Rspamd-Queue-Id: DAB05140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762973923-437555
X-HE-Meta: U2FsdGVkX1+j6BeP5NJepHDurvKowjJfxyQ4Rc+TOsFuH+uf59Opb29q//44vr6BoxnJUS6zGFp5hotZattozX2CyxcvTWe0mbOkwLJYvRbTpjr1JZ2KJjzWQD8/FrQeIwwyRjvmjW0S1PzgKHEkmBZOAt/uhXWYVTsLTYx3SfI/B3VoroJQynczyR7fzGov+wL4y1mqG4sHSgilVQV6EG9EoaqJTbYgJvewMedho0OiigX3OCfT0+e3KxdcvOd3GzKfRPCZPt31Y62mEdXy24fN4Rn0zFxLe9eAz6wP0y4gxWRtQELQEFkYYckkmz7ZIrfA1hug1a/k9fv8fNezOrNTdb8VtUP+WRghm728idKFg0QHTPseo1NCw/TIuDkRvrUEuRN9fJPw6z8JzJkXwPSRB/W/aOTsVL3BVurfbbsq++foVQrsj8VTaN5m8R3RnXMWK8gjGU9utwgUpd8MTT+oolxId6wt7kDSAUIakRAyDauyV8s68EwiLo1kgLMByxW8dquKULHMibY65LpZGV6jHdwdHkbYVzkTnrKc4DlbEPWh3nlxzcX6TrWBkULU6EQONZ5ClWHRA2uq6e9juFNnCgm1CG8ZDyZ2nHxgcdVcXIWaTX3yziMUCguLOLs5dI6WHDUdNWItJUg/1LKVdG54VV8jJJzTypVVk0da/+NxEGeQBNoofw0jmUPv+Tbah7DkpCyKfkJS57dX03orBGkt3mEXNI6258qZ3xnLDqA85bXaQKyNeU4i+H3nKCknw9HN1RNdhatvs3WpLx0qlAawnUXE+nkQnzz38movZClSYNfTegFG4u3i2NYjl/8yDeGV01cuRaQCSBlHQZKHqPSAYZDvYuVHhKq5guq+gIBcLNjI3qq7lPXO9fqEI0nh9ejkWbs24hnhpRR6BsybSvY6FhDzxQmZjPdv542E85DtDz3XuByIQSylXw+mZzv9e7Tktyo1mcioVdLNmKp
 lmk8XYOs
 6lzdDPYRulcsbdlc3x9IihQN7K2/epb/XnlgwEXc+Kq/Yv85nnqc5MAwdVyQmq0EzJBB74R0etCF7mMdu1o1tmHQUxkWYcsVgJ6mqV9CHhkodtAGAMwZi0iMa2Bv+43Cf0AXUPzEARArsUaI80y/QmhwnktFEnNqDJHAT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.

---
Linked rfc [1] and rfc v2[2] for convenience.

v2:
  - Add __GFP_HARDWALL[3] for bpf and drm users.
  - cc BPF mailing list

RFC -> PATCH:
  - Collected review tags (Patches 1 & 4)
  - Add unlikely keyword to help the compiler
  - Replace pr_warn() with WARN(1)

RFC v2:
  - Whitelist supported gfp flags instead of blacklisting the unsupported
  - Move the flags check up to the only exported functions that accept
    flags:
	__vmalloc_noprof() and vmalloc_huge_node_prof()

[1] https://lore.kernel.org/linux-mm/20251030164330.44995-1-vishal.moola@gmail.com/
[2] https://lore.kernel.org/linux-mm/20251103190429.104747-1-vishal.moola@gmail.com/
[3] https://lore.kernel.org/linux-mm/20251110160457.61791-1-vishal.moola@gmail.com/T/#me8b548520ce9c81a5099c00abe53dd248c16eae7

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

-- 
2.51.1


