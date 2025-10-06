Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4E5CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA338E0011; Mon,  6 Oct 2025 10:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D13B8E0002; Mon,  6 Oct 2025 10:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E098E0011; Mon,  6 Oct 2025 10:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30B388E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:13:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB2B2140651
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:13:22 +0000 (UTC)
X-FDA: 83967881844.10.3ECC1FA
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id EEEBB4001D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:13:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IjiVrIZ/";
	spf=pass (imf27.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759760001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kYNqncL1pbkX5BlNCe5t6IJsqg4ck4854DVjD7R/zfI=;
	b=3wddx/vp27BASFoP/lXH7VCMk7SQVl09aQhzwz7MwVWcJ6j3VWerTtpsUoQ2XJGZYD+Eef
	FPcn2DkZTU4UdCb+CUcFH73VCBoU8Z5COvd9x7cP/vf5U0PDuZSeplmmhXXI4YBMeGHpAx
	PH4t3b7Mp2OjoitQYGvZxmLG5gzBTFs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IjiVrIZ/";
	spf=pass (imf27.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759760001; a=rsa-sha256;
	cv=none;
	b=JtqqgE0Qekx+jAuoosFZGiS+B7aOLU83LwC38KeAgk3YSxrF8920nieK/7x48XIa99D/y9
	ivYEVSoQK6zX4Fz3Gm4tDttZpVW5CSj6Bw3/PpOtad9CzltgC0MSSG0efHwPKRMrb+z2q6
	R5mYnF37ZCZdxc11DG+EaSXUnoKDX2o=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7811a5ec5b6so4430089b3a.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759760000; x=1760364800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kYNqncL1pbkX5BlNCe5t6IJsqg4ck4854DVjD7R/zfI=;
        b=IjiVrIZ/EfMFVit6vYOx+uln2EblGDF9u1HlsMqlCvBpWgPJ700vmi4utrZiZBDs2j
         z2EqUxMAtIb+ihJGEFW7bIm9wT4WnfKLVkKlbr13nRouendFGKOU4EmCVuJw9XwkOQXE
         9N0CF2YXpWbaqlMWof4FRkAjqH2IRyaJgnzyU0fFfx8QA9T+ivVtq+JUx7miEf8QdT9s
         OJA+mvlWjjuSXCz0s6Sskqqk/qgHBo4Rmp7ZpcJsI7s2ni+pNry4qx3PbITIUIpHEf+p
         SSVvsQ6npAnT3nXPbQU0h5Al4ShXzmovJqZ7+1xRfOOUjuSCR3/vAWBQFUu3iKunQ7Ny
         oenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759760000; x=1760364800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYNqncL1pbkX5BlNCe5t6IJsqg4ck4854DVjD7R/zfI=;
        b=qlgDgGMus4qKtgih40Tv0ZXQSIuCvZCb8SntLniZiMFrA7/ZhJ6qsJc9hMkhTWSymz
         8In3gANAVWm5VCLpHbIoF9cczHvqyRRArFhKIbUzFRVov8vg3BT7NViWTuMyIX7qTyrW
         KXEwkstdjBdVWnYgpdj2jsXMCnLbbxYStTIJdvrES9/4QKUhJ7stUK2jnIQaYx/FEXXB
         hVRN8bkknJsLaz29nQ2KPV3gEWyVd1RNzTzNyTiydHphm/MbNKayxLiSpXyYOD24poZZ
         zZbvJZcL06RHDXp+jnPPxyUUwb4awI81s+JioJPBxWIkSqOscg/mCJQXHzQtnTqK1ZoE
         GQXw==
X-Forwarded-Encrypted: i=1; AJvYcCXRtyl1HuwD6DtQaVXhXuo5J57UUau/yhO9dtumhGXyadeSd0SPMFbTcot/jfPy6O4kfiLoNzzIMQ==@kvack.org
X-Gm-Message-State: AOJu0Yzou8FOOzseOaM1YQ3JJZ19SOOgJnYh6jhRWZYwFEmta0FWrIea
	HMNRn+IYowgaMfNliuJ3zDfl9UrnWTc5aqvETC9EvX8Ud6NqwCSdwQbr
X-Gm-Gg: ASbGncvC0x6RSlK44XDBcJuLX39gfOG6X3QG2F8ZZefz0JDBNfyKOK14aO0ryKr/7Z6
	YXvu8xvEm1hyUbG3h/uLmEGyC62vnXhzWjqtpmLD5jMFodUoF8bQhwrvTyLFquO38DbqtIrprxa
	1o385LVrx2tlUPdLArhE8Y+fBIg0+SQJqgNX9KU8T0HgxvVT1juf7nYarmWzgz3LpP7/3ZiUhe+
	dDlZReGTGjlNZ2g7QSuL9Yh1Rw3kqdn5rBtviFa+ik4jJMU8KyuqpJrD/Kr54uR+bojjSyfDf3b
	WYhg2uwyBVRhC34WWzhzPA3GFH1oBtO4Ow20cooAikFeYvcCRWJ9avI0H+IUOxYhvYT4fZEoeZH
	gTsQ19ZoBCb0JE2nr4i715Y6xguEnw22aEaMQcvizThm81Znsb/60u8km28VVXZnn394m4Bmi4s
	AGF1nduuCB4CkB+yFPVb2MLa2od/A=
X-Google-Smtp-Source: AGHT+IEPRB2b1AD/QZxok64lsH8ByJ1lFhBzYU52eoAFfWqs1FcK8vyfSV6QzsZHrEOmLe58UAsEbQ==
X-Received: by 2002:a05:6a20:1611:b0:263:57a:bb46 with SMTP id adf61e73a8af0-32b61c78378mr16152472637.13.1759759999595;
        Mon, 06 Oct 2025 07:13:19 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:da26:6519:741c:efcd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0206e50esm12666243b3a.62.2025.10.06.07.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 07:13:18 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: osalvador@suse.de,
	broonie@kernel.org
Cc: muchun.song@linux.dev,
	david@redhat.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock unavailable
Date: Mon,  6 Oct 2025 19:43:11 +0530
Message-ID: <20251006141311.23645-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEEBB4001D
X-Stat-Signature: 3wzctykbaztsj7dwsscbhginuiy4on8h
X-Rspam-User: 
X-HE-Tag: 1759760000-519842
X-HE-Meta: U2FsdGVkX1+QXIjaGcQ04+T+My+7jXp+WxKnugOYmbBl2lr6yzI1mPpBrhIn6NSkG05hLoTX0tnbwKJM7E2oKKif6PbrE8GLjPJqijvstYxnvL9Hno6Aj2ewaIRoQaGFQoK3HZBdckOMpGw2Qx4FfGdANwqq5NjE4yqoYemviEP/xz68uB2uH7iBw84a68PF2lV4vvYr1Ci9glVRnzSDOnUh5MSR04JUh3keuC0/U5MYYgpXDTPkbWW4D1i82ONV1QwykyOX+41NhyAzXt6rNlvnVloy8mTtcX+/jdwR1E51LYGlQM4FZmD8kq6R4TC71EG86P8BBeZ8gkOtuLJodPkcZUyZoVzReviKHUEAj0adgk+XWtrCTg75w6QPDaZ4I5Ac1WbVmDCc3NMUwmUeesIeV7tml+UHwh/NMeRzzPp+DUyRe2S1GbMOfC/NgcVazoEOgDvKe+/7mV1gJiJatjP+zWQoDyjSFZajVT1FP2cSWRimiQY6KiP+n1TLRlEr+1uI8iy+WQCzJKxEqnGLCL01rBpmcQRG4zYr3i9bprlX3+ObKniXCfxhtTZpqKZCMprjlDkSHNm0zXrE7A532fHgQYUZhfkG2P6yTg95zbJJ6rDiGu8PMY6sr+PixKr8dDqW1QLtGqqe1pt1WNa5ngGU8kdMbHBLy44Z5PRO8/oLu+/MUDsIfqGEP8j8/OoWuX6DKHmzFKuHFzXVVM1Gittae84iMrkTXseF9THreq0IBqtUWeJfLbK/etFwtnykAwUbCGfTeei2GWaxos7vQo3bD9yK6dAxEE/DeLIZAMl8L9vouHhONvQMeR4G4VGw5aN8ZyfX3K1d4rKf8wxNkq+gPxqvboHCScoAbWPEmJIEsniTOE4ROQMLtKXb5f5/3oRbqkhT5LMKHbyhLuBbP2OcgXFRZxysTWJhioJBexx9RQhAccPy8vsj4lpgUgAFRx0BfhlnL4K7W0Pdt1c
 jPapKjR1
 mXekG2jv4YV5oYR87OvhVLkw8FEXpraapn73BVe7RtlDVDmVeovPezJpSvIakY5Aixmg7gaw1jNiFe0gRBvfXWZvMfUtA9nm24eQe9Dr/W/VfFN3A7a23J4t8pPnEVsrRMZ6MmZYIk94BCNHES9k/wt/1pQRkYEyYVvWyq7fCTbHZmLnfpvilrmkTZyVq48d9/CfCzIfVZC2wT+RZ2P4xtiAaltNimxDQ53ku5G2Hk1BKWnLYoU7vWThWO+D6cxncFuiKBHTmZ3jDHS0h1yrIQWr9eqAvK7mngiCa7exoWmQfFsVQDwuuv0O8vHLstDlspmhoJ0FPGPp+wOlYFSPKR2Jcqx7rG/D7sSLL0D2X/QtUw+F+AtLcRj0nkdiwAlxjd+hPKe4lnqa0+usahYrNxyLWnNiAGpP45wcItgwiaCjWY5QtGvez423yz+7W89ROndVWw5M5w8SHu4XaM7arU550mSFdGyhwYMQJ6q5wlnqxXs1Ylvjr2qxsdKIC0bzOlUCD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oscar,

I agree - checking __vma_shareable_lock() directly in __unmap_hugepage_range() 
is cleaner and simpler. I'll send v4 with that approach shortly.

Thanks for the feedback.

Best regards,
Deepanshu

