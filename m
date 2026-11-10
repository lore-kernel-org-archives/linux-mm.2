Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13BE60A2614
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvBOtpHE
Received: by kanga.kvack.org (Postfix)
	id A5D006B05B0; Tue, 10 Nov 2026 10:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E2C6B05B1; Tue, 10 Nov 2026 10:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC1B6B05B2; Tue, 10 Nov 2026 10:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5886B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA417C08F4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:12 +0000 (UTC)
X-FDA: 85419555144.06.A926D0D
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2200D18000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yvBOtpHE;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323651;
	b=2OWFue8t/ZYJKlP/1/s5TdytODtd9WVFjE2899OQsoW1lszEpOMlXZ2XXEBmPMeDAOZqCv
	5/QHuKHp5UG58tUNStI8SS2574Agk2afTfrHwscF1zkYXoYII1yZ+9dQRb5ewuKxhux1or
	2w0Lkyk8vmZACd7k5YnStrwo3acB9x4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yvBOtpHE;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PTKAikpOW4Bp9RpuUyN+Xdo5TM7yPMjwYf3IanAnUzs=;
	b=SnVaVkGuEYaOoRGK0RNVpk143G8y4TsQgrOB3xsI+AJyH7G7xPlRCn613k7Uh9S8Q8ka8T
	yInILtqs04gYcYW2L88lDWq+dQA7rhIwi3Wpr4aHb7is1wg9ht1yCNiVSk2dHb+9iBTXkv
	8RIjbqj2kFP/PtPNFBqnx5jZkCpUXnQ=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67be7b9abc8so1808023d50.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323650; x=1794928450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PTKAikpOW4Bp9RpuUyN+Xdo5TM7yPMjwYf3IanAnUzs=;
        b=yvBOtpHEYSfavM8pxnB2o1NWghW9NzHzjtlqItB/GFdhrucQvqMkItk9+Up3mO6wf1
         fgSc0/bQQSxgR1Tm/4pSYCWxMaj86ZWIzhzQIZlQRIZ7XwFiddA1ycZZJ9kT49oGMYqB
         9FIk8PXAyfJqs31/KZMkPIQDTr2IakHAO6A8BJZ08OE0+6TqHckPBvPrIRB/YaZQaj7H
         HwGlL927ttoXWhT04NdCghZ4pK7m6X0Hfr/Ce9/11XeijKjyG+l3ptBOSCU4ER9xYZkH
         FUoyo1lEgSUekF4DcrpNJ9eAJS/VhnDn9lqJP1FRVLMbCpt+b48zfs+krrtCjxfkbnLH
         kyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323650; x=1794928450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PTKAikpOW4Bp9RpuUyN+Xdo5TM7yPMjwYf3IanAnUzs=;
        b=pMx1ZZFK39eys0B6qtwe9aBD0SmvHod46TBd+cYUDw9mT1wGWNgoourK++Zu4y6bWf
         1IHONgqS8M5C2vK9KnbA2CgARnTYeMVg9cR6kWckd/inVlnirixMnUKhTlnz11Hpqws6
         oQktRxQiZQkw9zYYOLqFVjxDHpzyT3ppyj5crPMdoiky3XotgY61yCaiIjRVWlcotRTM
         kkKM0OdMZTMo/WBcJBeHeZf4zL2/QRXU3CvE9zZnqdssJuXzwzA5uvXI5NbQLDMVHERl
         4Juu9Si8xnQTc1T9P8n5BZj1/rF1DejoWBapub27S/y5mu3yRByJmOH2JzdB0uDpmEkw
         eZyg==
X-Gm-Message-State: APuU4Z9JdlX5fgco3jhrXHHyaRr2hVGYglb3DyP4YmwGOULSUu/skyb9
	542qnnXbYDLeMBaV5wzD3YK0PwTdfnJknWCtE4cnaK36D189IZPLDkKaBe6rHAIk
X-Gm-Gg: AYBFou1/nN6wkVbcbNzzbniH0W04hyHbsdx/cvj6CPHAXU2iZnKLoZVVhRjcH41agz8
	IEAOsfuSYHMZzL0DCiEcuqtCRpxpqPjLJMGxBeWfpkJiMS1pOKCEgDi9ZGVYdmykNSzGVjWnDon
	BB+kedL/OUKyzloH05D9fXJRf3YhEq4m7q9gB+xn75dwZx2zWitH07xpLp3DCoPsqV5BiiTOF5r
	PZH+/eGmgG1OLW+B8ROpONPjAoYOSGnsSk7M3t5ITn4vJXEHChv3cEBjSmcNao99q0XMaJ5xfT8
	pnuNFxVKiDmF3zv7MFvMr+A+nNOnrzGsmP++WO+yyHeohEm4Mg1WpVQsJ1LuRnSZ+YwTKXC6Nwx
	5y9CplqnAwNmIxHeP5du2p+Y2hfGFE8i0YTkx8/0ldqOHDso1i80ln7RXPqYDM83vGqKt9Bvdzp
	Pj6n7KJdNVfHx6x7E41EEcX2iy8V3KXF1dTVvJSDQu2Umrn0U0EUOsL5dh+5qiqtGJmE0BaL2HP
	czE/cooYqLhdjmEuCYkH4YOS3Arc7j2gfIoqfVfqc0mi9c5g7GkNwwYzaz3F6t2qmymgQf92OuT
	0S5NScLlOrC8GlFZcnqJ9LbAMeY32UUFUvAKtimcgABGk367+h91sV9ZCW3TMqQHlF3QT0SdaXD
	9RqkYGsA4B0umRx37wMiuXd7XRXcr2yxSGgY031U8ruwz/1j1Gxzi+cizBFk=
X-Received: by 2002:a05:690e:488d:20b0:67c:17fb:eca8 with SMTP id 956f58d0204a3-67c56751129mr1182083d50.32.1794323649911;
        Tue, 10 Nov 2026 07:14:09 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c5860c429sm2138674d50.0.2026.11.10.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:14:08 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/3] mm: fix swapcache writeout and cluster table races
Date: Tue, 10 Nov 2026 07:14:04 -0800
Message-ID: <20261110151407.789960-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ggha9dm6my8wz9tiwab8mgpipjuaedqd
X-Rspamd-Queue-Id: 2200D18000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794323650-139854
X-HE-Meta: U2FsdGVkX18S2ZEoRxatrHMOq2h8z8hfiK622jCGoFPfwkBlXGCvOIfjux+e9pAInDPMJOtiil7XtE0ARIxRr+GbLf7nDYpyzsUVJ8SVpsMePJwvtIOBVYS+gxm2zZ4tHPVzqMhux953ewMycWPQR+NLdAFBKOzI+gyPSbEySYm9/f9xM9PZLQhNXrfqFyHmZLTfX61jU/AGxE58ojc055TQ2KTIsfVC4ygCUtBjQO1gDrOYdZ51VPyYjLrc6S3MUP4bZl/vgm6Cw9vsc7nr9uCIbaO6peUdnR4ORN/poObVYtwOjCKMA0rgVxwPEwgUlg6v6dx1Atn4u1rP/dMSP95QWtGExEm8Hz183S0xaonQijQnqXBQS1ovRn4UcyhbFLnmAwvkor0ro4JXtfyapWcjuJ8iu2NW7pI59fLReNJDYbSS2qJRWozjjFbrxhBcgb1S6SoDXkMujs+FY/8vSG0fzpPaN6CqaPcC1ylG13vtjl9xG+lK6SYAC3sUvYmW9onU96ADxwgnN+Us2xYQEDnx7EiRq//vz7uUpAlBE8pTUit8dGcbWsjxJKqvHUPmLrq2svZ+o+BKKRGEjWXU4d9M8IuHGLT0LVka4A8gZvL6tZWlrOo7AuHbKQ6cibm+g9eHq3QIn6zlYoKMvUhxk1sqvhWrIDph+S4H4AVGeeQwbEwEHLyI0PmAPAL7njMGbQv5n32Qy/jmBwcuLBrkGIpHw8ccX34FXlR3AJN34xesOgAJ9HAE35b1eaK5QXnsw+Qg5Yp/YXJs6g8Q1KBw0hh6RMXd5dab6G5sGRyuEioelqCNq26GhZKwCtCnPFjmdOu9j+Waxv5/gvGy9zQZqzYM6XVnU6TfaJtTVILSIAx6bwpZDLM5JI2/J/CPdltC2YBdk+g00G98YfQfa0CO37EFC+eidtiC3zrHnlnGW14NE4bZqIv7x2olzfg4v/7AQQo8oard3f4A/oud+Yg
 SOaOsYRD
 DBriAVd8WAPbAten4OYQthGLlWC79UMFHKXCbH7YRTxWM7PGEcfFYV+LfL/4vVYe9P/pNu9noWUW2UR3ltsLDlXYiqI3q71MQ/LPXmuI3bB1fPiZZrEpdxeMx8eEB8r7e67tNG+jT6qAFiUbZDVEQ+yoUlKIXspZ8E7s3sys5ToBS1zbcm5EfiKlAYzSOw2K6es/Z5yu7uPg3D/CNEtwTNhqGA0lV6VAdHgOSHW6W7iYoILS+KZJNCc89XYa2RPxnSyn38q+F3u444AF0Pk57CG701wlEOsw9n6TJOpghfyrwLZStXVs3XWgSr/1wzozXEGddIMvCRPvJsPe/e4L79xL0/YZHtDbbWyfIyVXu2lKkHfe7ZxKMHI7IFd2zsNTofAH2woss8DuLZwk27qjO+xM2PsIkITiUtEny6OiVPcYPExp8jU4ZZSCBJ12RI3NLduf4ZyGo9ZW+j5tQMRYXQreHOUXf7p+F8oByqWUWajmSv0Lyc1Yjx/t5j2EDcVnesIUlMIoRtcrd8JE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviews of vswap and v1 of this series found bugs in existing swap code.
Allow swapcache writeout without anon mappings, publish cluster tables
with the allocator locks held, and leave tableless clusters to the
allocator.

Changes in v2:
- Rebase onto the current mm-unstable tree.
- Use Suggested-by for Kairui in patch 2, as he requested.
- Add patch 3 to prevent stale tableless-cluster relocation, addressing
  both scenarios in Sashiko's review.

v1: https://lore.kernel.org/all/20261106160432.2552507-1-nphamcs@gmail.com/

Nhat Pham (3):
  mm: vmscan: allow writeout of swapcache folios without anon mappings
  mm/swap: publish cluster tables after reacquiring allocator locks
  mm/swap: skip relocation of tableless clusters

 mm/swapfile.c | 113 ++++++++++++++++++++++++++++++++++++--------------
 mm/vmscan.c   |   3 +-
 2 files changed, 83 insertions(+), 33 deletions(-)


base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307
-- 
2.53.0-Meta


