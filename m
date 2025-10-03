Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D71ACCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5668E0005; Fri,  3 Oct 2025 11:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B688E000A; Fri,  3 Oct 2025 11:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE4D8E0005; Fri,  3 Oct 2025 11:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF968E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:10:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CE4D451BC
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:10:06 +0000 (UTC)
X-FDA: 83957138412.07.040C796
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F0A82000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:10:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A9bEjIpW;
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759504204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
	b=odJ/nQ8ChZnXbKIAoi9OnqSzSqrtm5USixygeupCCn0gS05wtvFK7vluZOHoPHMRZXy1pB
	7xIWXPkZDGZeVPteWrV5fuRGJYUamB9jHZwJ+QU8kmCErVrXnU7IF3mBnfLmP3R+0gRp7P
	7SLajpW0KVF5utK6GdxwmKBQ4pz0FaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759504204; a=rsa-sha256;
	cv=none;
	b=VHvPbGk/7D41fwcvB7kLruJA7HfPx+HC42c99PHYRcC8rXUt0ZbETvVu5A0pSBtdhymLEE
	bybZM4D/nSFpDrUTthE/moyNMR7AXCI1FezHMbgM8iUPxsBN5OrAIcZsltqqdqO1dVu1Km
	PQYjLL89pvQ5eLFL15tehV7Bve3cVUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A9bEjIpW;
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b608df6d2a0so1847348a12.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 08:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759504203; x=1760109003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
        b=A9bEjIpWxAH4QcTPuMjgUbL0frREQ08F+Rfzl5UV2pc9O9VjMv/Jm7iY29XnHFN+XM
         UyLYQKs+gCQlsYITF0gfPzqAU8LiMO2BJ1Ghes9lBtTPTBfye2V4W1N0VALavk6vFpqi
         HJFdmCF/yW7GR0cUFlZ7HNU5rc25NclhcLYpy/OxvCMSusj0SDeggUvgfr7kQjoAdmLF
         rbWakKV2UEi3ae69T7R03CTV0YBeJq/WUQPXMsK7Ow7ZOm18Lr7ewioo9rlZx3y5A/AL
         KZGis8LHovjxj13ooY6fcpq/IH+1hFHhWWnpPuMgngZg6rYzUoUmX2yTNEHAwUw90RYX
         4kMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759504203; x=1760109003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
        b=u/A4FtT63ZbCnPQJLeY5tY3SKAc7oz6cqNFXBSHpjjEN53PpAzl0r4jHDVTv1nJFFE
         PKadjN3Gj4AWj0ux55yBKa0KfAfc51mO5l+9EdrcRnzIX+3SMqBl12v+LCUzxM+GTOfs
         h8d+BX+uQJPMuDjC3iJL+vtWG3Y7Y+Ct2kmSub7zEdITlzJPNzikBVMOvBAEPl+A9vd1
         1B9b7/Dd7/eLY1xEZgj4woLamX9F/N6NeUEpckuisWe/kqyIrRFswrOCcd8JvTp5IHlE
         Pdqp+fe5y/0ITqEUMNbeYNUzlcb3720gdEd00Dq/pGvUXVskr0slp5M7rAjOHFNQtfNN
         hvxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqtVC7QxvBT7iWgb3QYCDpvBKiu/dAcvFh/lyvvPT4tHvNkHRJCcF8D4ZF0zV7m6QhOHlG+kjqZQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7Pi0ruo21nntvzAv7jVaTcdvDKIOvWUklue52eaOERVdglECm
	KveSLnfY9kKa/zjhggjp3zAPMJRgvynFO6huHgeyXBAdHx7bUyi1Wu3D
X-Gm-Gg: ASbGncs6meCyP/aPzOPg67Z3Y7F+B+bapIjzLZCwJ5wvUEzpZiupRJVKItiMz6OOyQf
	LgFSb/y4o1WHt+lmURPGy4KWhIPFkHD8Gl9SlbJlU1ElSygb2S07LixZ7RCwt/PBjrgt/rXS6nY
	v3ETn8yLdVtG+aj3rnTl65gDBIAfJsatRfPJBztc6eBg9gKE5XXNaAPhcWkmIV5mTqSxfm5h4tO
	eIrMz+JSKwRgGOHa28G4n2n0MokU4XIxIoVli30E/n2n+urpPSBGvTZxpi7jKqea2od1zmQ0yI6
	Faj17ADPM9RI0PXxaHpNRB6AEE959uVN8dg5clloGr9ln+9IBZpbhimkK+aA8Ne/NR5m1/QIXwI
	+7WOk9qIXOPdjUpSaRvheLP6Dbw6BEr/xCHLkG6zkdd1xx2Ht43kqBYQfG0z8o2E2PYXq6lIIs2
	wZ21s375do7iJLC6mtno+Qz+9W4H2oL/wKAxQYMXaL9yJeURc=
X-Google-Smtp-Source: AGHT+IGv+cplVeHusb5afcK4OnFwSnTpvX7kooNClTNAm9OZjgX2hRlebJcAFwQUa4C5tMeybPYp/A==
X-Received: by 2002:a17:902:f792:b0:28d:1939:f9c8 with SMTP id d9443c01a7336-28e9a5bf4c4mr47109095ad.26.1759504203274;
        Fri, 03 Oct 2025 08:10:03 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:38c3:a5e9:d69a:7a4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1b8444sm53363805ad.86.2025.10.03.08.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 08:10:02 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	broonie@kernel.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Fri,  3 Oct 2025 20:39:56 +0530
Message-ID: <20251003150956.2870745-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F0A82000A
X-Stat-Signature: 58wt4o6kz7ga3w3e94en7r97m5n5q4cn
X-Rspam-User: 
X-HE-Tag: 1759504204-721338
X-HE-Meta: U2FsdGVkX1/CY4KWarmj5qxEqR/l82o76T45j6Qs7//E5+ZaSc18nS2Qbfzc0WfVMa7rtzRR9yzPFwC5kdjNzUnboyS7ThN1gZIEiKLntVydK9snBiIS6thusTHpBsKWnCkaJHmpS/I5sC5aF09c79WxhnF9UV7L9HtFOrZ/AwL1a/GFjnEzx1c/IfT9ulzmfyDVd0pAOwm4n5Vidg7AvCcpsWvzhdbp8uYs69GShNyxmI8TTLD+Y/AGv6mK1iyEyYoM0VijnfNX2c4TPzWBUX4hujebnYqW0I9Pz/QolrzRog5cDDXE5UlTtDaTH6PvJXyWUh8MYJHxdw2ejYD2ONKZkb3Rg74mfVACylElAnIc0n8pblMkgO5u3ryBhEXDke93wmglT7rSlztOUFQlt+E01d6o92Gfbxs66gq0WIUKimR7fXAznml/kNL7HMxeixSrLo5Jk5V4rkz1hDoBoiDNzQzq/mJShcsNdMSsIAEDMBSO7Cn6LFFnAXPBJkTfXic+9ZTADxf5/0CzMc72R+kR5JMhHKY5h/C+UETWjYFRsvXAQDdfbiB1v6qQVDiFyDE+dHYzznaSQ/1DlHMvWhq2czz3FBJKKSce/XjacdZUy78zUCE6dMZrFzFZ0BVhHn4p6qDzf0+lSqiemJNeVCseIe8VSQg1Kz6ilbF9wb6MDLzYLvL6KLS4UND1yU5GLjK5YGuX1E9Ko3psxpPF34BZxBX10MCrtSN3waHY2SZYM1AbzhtmAKt9sk2QDAaNdRrO2CbeceKD+Eseb9GBl3zhEITAajqcKc/dAxVG94M9XEI6UlNy0ciVb2QzMqiDhVlroLlMmwYjkIvmm6JEpXA9zCcf1UR+mPjtd22K4mtVXrROFg3C9DCRE6KXODDXh/PgKurFt5mjpjCvaaLbyN/Ha4A6/57oHuWUrJakPZPIvGSas0kOGMbhKADW9sps1h1fCJizO+9LbtTAiwJ
 g+Xiu41T
 IakKXC5RrgwLaRapnbosXKG7oglkCqhoYEMsSo7O+EVXXxliR4JKktB9A0zRR/l64U3bQHIHP7m1KoUQCqYffQQWVudUjCMQFVnaa+hyJiLKDkeufrsEnN7Qpa930MTYzZhbGpmHgNZuXWHpbifqFzQYDInul3cvLbbPWTXGOADZtZQdLcbdFlcBI88HzOB/TEMzGyeCciJ1xKul6kWeQeh0jycS5DzRDg7JqBaWfvPNGmgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

My previous patch dd83609b8898 ("hugetlbfs: skip VMAs without shareable 
locks in hugetlb_vmdelete_list") fixed a WARNING but introduced a 
regression where pages aren't freed during punch hole operations, as 
reported by Mark Brown.

The issue is that skipping the entire VMA means pages don't get unmapped, 
so they can't be freed.

I'm considering the following fix approach:

1. Add a new ZAP_FLAG_NO_UNSHARE flag
2. In hugetlb_vmdelete_list(), try to get the shareable lock
3. If we can't get it, set ZAP_FLAG_NO_UNSHARE and proceed anyway
4. In __unmap_hugepage_range(), skip huge_pmd_unshare() if flag is set
5. But still clear page table entries so pages get freed

This way:
- For truncate: same behavior as before (might skip unsharing)
- For punch hole: pages get freed immediately (fixes regression)
- No WARNING (we don't call huge_pmd_unshare without lock)

The trade-off is that PMD metadata may not be cleaned up immediately 
when we can't get the shareable lock, but it will be freed when the 
VMA is destroyed.

Does this approach seem reasonable? Or is there a better way to handle 
this?

Thanks,
Deepanshu

