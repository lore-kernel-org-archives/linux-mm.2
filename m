Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352D5CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBCA8E0006; Fri,  3 Oct 2025 11:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3348E0005; Fri,  3 Oct 2025 11:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA968E0006; Fri,  3 Oct 2025 11:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDC28E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:09:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16E7713BD07
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:09:27 +0000 (UTC)
X-FDA: 83957136774.25.79E0B7B
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DCCC1C0016
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:09:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KBRY7rs9;
	spf=pass (imf20.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759504165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
	b=rDFveGLHrxDC7eBEBdlYRH5YM5AVAqJM0irHA2uIK5xY/Hg524kT18M7cV5C/J6x23AHLA
	W+pSiJPgLIR2nLnoeyJ2rO3r+Q998x56dfx87KI8QPTLNOtKuXVumZvXcMECECp12TU9xh
	ePU/QxWgHore1hkye6dJFaULfpBs8fU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KBRY7rs9;
	spf=pass (imf20.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759504165; a=rsa-sha256;
	cv=none;
	b=Pa1Me5lha8QV2YA7hRzcCr/2DtOK+yGM5kj7JhlxrxTehNbhU4ZHpvS2i+batqyhindNZR
	RxaRy681fpSliyA4ADxhJSKkd+vDTTNbft4NxWDd4EFgODrWPubm0iuYCGkJzDgPKZX0iP
	hZAva2ODizLi/x9FIZkAvDm7aVkTizI=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32e715cbad3so2528167a91.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 08:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759504164; x=1760108964; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
        b=KBRY7rs9CBcHn7Owr28ns1gejN1VWscIi04QNrTEntAJBXNg0LGYYwEVJMuMO0uRAR
         qXK7AifZnI7z07Pin6y8LPknmDA8zJ8BjG/i9y2vWFMIU8n81vz1D1/z6c948o6Sk8cs
         f0OfTvFQzfiQfINGlQQwMclMaM05o1SFMDDegVu5CdjBLO8sGz8qSZb/dZkPt+xsFbTo
         Y97w4vl1aq+/7s49Pi3apMUDVw1p/NdgU/WJRGn0O4NuHwidS2yJtWWawBY2kuCUx9sl
         g5ZPDZPDKTcw4wST9NC3D7au80+g3+f51JhhFP3Eu7ytRODo+V0Ch+X/SySg0fpbCL7Z
         5h/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759504164; x=1760108964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oaSUB1+BagfG1uIIKH1kjK0S2ChhrhqFels8CRGn4NE=;
        b=o4b3pjevTp2XMFkesh+QQ19MYBBPXKSW9f89eqb3K1JuY4JFWdYdEz0hp4WNC/Bdmd
         HsRZZ612FRlmPGY3vLfGC4HT3l2CQDQjrpayKyj/OBbrS/yYooTOqzX+mdyUGaEHVy62
         8QGnYtNbqwiGELQao8bwTMEAmDyGN1YAC15sIHVgtgEnWTSCVsifqseA6iKyQl+zJykm
         g+qLZkfrVnJVGJi/VboopvctA55WAyhNDAw6Fosx0fKz+yfYZtOIIpUyvMBQ5lPA3re2
         +RM2zv39hmZDavIjwFUf2OV251PIVyM0/KUHP8s6MQS18CX836izKA041zeydZ8BuF9K
         yxwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM7B6fPFI3HChh0BVpWHqV/wdW4siicJQKU2mP5e6WXgIbdkOs4SL7Znp1YrVtJAhnws8vYghbeg==@kvack.org
X-Gm-Message-State: AOJu0Yx5+iR2lpNhYe7wW5qYQAIhzA4QUAjjrOwF5csi1tHhSAPzKCR/
	TgRH0rGkkdnL5VPGfJ9u5Vei2oWVFaY9KWxMo5VMOGaFWu8P/SGHN27J
X-Gm-Gg: ASbGncs4G2tFTuwh2CkXMuiaF6x9xRc7gNgRLAGz7HtdHagNwy5DHuwNb/XXUGy+6/o
	bOYGE+GvKMP4FVzphUr2sroWXEtUX9w1gUQRDczXCneTQ06V1x+lB2HhaTLmQvjwM82tqZL/Sc/
	8GBcv+oSgNnEkUMsvqCqt7laBLP5+67XvSuzK3+ezIEOrKK0ep9ykrqrdnnxCpkfOsph2cEppZt
	BqOis1KFiVk2g5IK9wzIH/TPm0o6ANL9dBhzLODHzA6NenPwYZX9IHJB2w/lx+N5iWP3BQHcleh
	ohy6Drql2S+/vmxXVqtAdWrzI3VExDKQGVOiUGCgSyYkYQLNIF+uxdgiZs4/ILQOsFus9FQIG64
	O4gcPF77ECjXSYXwOQeZcmjCpxCHH8N3k4yohhkh7W8H217ufUeLdtCBRSexDUWr5YCoEF8Z7xT
	BLPR5FFdfY2j/Oc72bsLkHUx0z8Q==
X-Google-Smtp-Source: AGHT+IHebKsQGlCqmQWXIuWKaaP6c+lSXFd6QMz8y/M5S0AsKAM+Z/y4gkOBtv1H66xkUTN+BsOd+w==
X-Received: by 2002:a17:90b:33d1:b0:32f:98da:c38c with SMTP id 98e67ed59e1d1-339c27bc556mr4423329a91.26.1759504163937;
        Fri, 03 Oct 2025 08:09:23 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:38c3:a5e9:d69a:7a4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b62d0170c39sm2379114a12.42.2025.10.03.08.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 08:09:22 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	broonie@kernel.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-mm@kvack.org,
	inux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Fri,  3 Oct 2025 20:39:16 +0530
Message-ID: <20251003150916.2870729-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58wt4o6kz7ga3w3e94en7r97m5n5q4cn
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DCCC1C0016
X-Rspamd-Server: rspam04
X-HE-Tag: 1759504165-193603
X-HE-Meta: U2FsdGVkX1+vrU5zYKYrNAMQGsmY86WNzvmvrJtGBiNCMBE9iguEDsQUGlkhCBSF5JNzgIg3QXuE0tYkRDOlqYNBBAvbCwopodBNk+FLG7URLR7jmTebAY/Hf/Kn3PAuf/9SJtNrshUDIKQhKzkvF1YC+EY5ziDqk9sH8FcYO2RvUlfp735YZX/baFrusD9vkkUQvyj60SQnNWZN17iiyaG19dWyCJW+CWBq5RdUZy19jq6TXA0JPnEGWWTy0S3DJdFYPKzgAchrFHDy5CBYnl9/uU/lfWTudMOP1gEX4X2QY9+0uZEFnPZTIugdabcMiXm1dm0CeoWbx5KO9aL3YM7PuU6fsN9y65Dw3smlHmeJwD3q4FpYWqH7z7L00yuUCvMLmKqgaFum4RS8cM3k+3gchzSuT73QujPoG5aoHTjtyQfW5Khe8K7qnlQ9Uxx17ktx6ECyS1oQUazEDXIsGGTo3X5wfIWBm90USmS5+5KJSYZ4q125kJmhz9T/3XJ0JH8SOf/pWMBDIKcrTkw0FllIqK0GeX8anrjXcdTl1IaUIMYEtvxibXJMgffUMwolB2GuJ9luQvQCF3GBoPAYHOhIaIbNY91ioKCfXJ36SVBK/2vXo3KmwFJcdT2NgWYmR34brbhxgfGa9pYa4RYxlaX3EFDviNDRKYzY4QdeOo4rBzD6jB3zx9NgmY0nLpK+rv0WtfxT9eEogifAFeqEkXmCb/EsV8Kxsl1PFEZsjj/fEDijBH0bz4TSCnSul4KwBGlqNf+HaV+d1+KFRnsbNNh8h/RFoIMXXugdRZolbNK3J9JOO8rr55KVbSiCWLk7btnduMs9NyTJiNDca5CKyXNGM82oDtxbmfodL2mIIMJvO0gOcVHZ+Ao1fTfTnLIgElO6K/w+9LBvc+FkPXFRx90fpTt3UMaEMCljGX+Ay2ED4DNe6AUgbfH53i0gnO6Sydmpv/R9+GCTBIf6Vin
 305DCpr8
 HpZIhAWb5UjD2M+7xHpuOvhVHX1n9dDWLw5bwPvSmU3Ga8sadnYAZtM/DojAFqMAqrK/MjFyf6t7n4OASe5dMyjsN15p2VFAxlY6nFzPBYFjdL2H+a+qO5XID9BhEKm8N3ulPArpbTtfLXWvQc1Yz7/1Nk8s6tO3nhl2XoSgMrJiNhavzlwARwv3fDlW04tjWEGRWEruNu9J48gULy07eOaBz/0oVUZ3MbFeXN4lO5Dqrmc8=
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

