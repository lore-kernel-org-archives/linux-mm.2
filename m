Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CA7CF9C7E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D321F6B0023; Thu, 20 Nov 2025 13:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09E16B0028; Thu, 20 Nov 2025 13:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46F46B0029; Thu, 20 Nov 2025 13:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B25636B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:42:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 423A41A02F0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:44 +0000 (UTC)
X-FDA: 84131856648.24.E2305B6
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5AD074000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QBeem/To";
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763664162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FCsMbyFAXE+sL0BOV2F7/Ne2j4+o3DG6bVR0QALJdcE=;
	b=YMrcwG1OQHA1EM2ZsQ7Gv0Mt41os5+eLBfjCPA0sgEA/TOznZS2nvZHI29wgbC3PtXbLKj
	3AGK635+Ql9uhShgxrZt8KnBmLadLYOrsZjhJlRiO/2FQbT7CD827fqA/GAophuYZ5aF7m
	ZcdRp/CJC38dQE+Adq74Bwt9gPia51M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QBeem/To";
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763664162; a=rsa-sha256;
	cv=none;
	b=jhI88BDyuE6BAMpl6VxpWYKZvvs6AQMkRUerb7AUMjVMD0xm51ec1zJLp9qvFHalXbGjrl
	A50J1hazQ5t2RkC0vgosJjOoSaGy+5wTxHkvyUrW7qhNp56r/G9BpDs5t24roQI2oLNzQZ
	A+Xh7U8+/+eajYDDlxLrCnllQ7YQJL8=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1047754b3a.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763664161; x=1764268961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FCsMbyFAXE+sL0BOV2F7/Ne2j4+o3DG6bVR0QALJdcE=;
        b=QBeem/Top7ZuCw8ZQAAoA8h2uK33OYiY81BE29V6ObDquVgW0tOtuEd/FsvwhWPMvI
         X4eXBSI0J9bwOZ2md2XnGCvZAGqCkH1lUHcYfH8zNaEum+qqjXxbTo7Xqn22tDTV+wAJ
         dra6zzaufSORGN76skWrtthR76PBMsQucEVKqk8D3hZbIlVcC5HZwQO9soPPShVxKZlN
         YTYscImTPP3LBV8FzndHnr1ACP/FEsG7QWbgCQVeU+dB/u6PQyeJ/uDd4VlyPctUeq2O
         cyHwbqKeh/6G32bstyG3vx4MpqIHJS7d0c1rUp8N9aiIZPg0GbfSzQhCVrVZwJz6828D
         8swQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763664161; x=1764268961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FCsMbyFAXE+sL0BOV2F7/Ne2j4+o3DG6bVR0QALJdcE=;
        b=dmDpleklSXoRkNA9lnxpOaG29Ehz/UkJix9NpcK4erxfUtPGkeulxORVkd0KvKzIHI
         97wz/BdyO2GzyQvYRUziK3wK4gaDeh7/tmXxrZrZi5pYLj3+aG8a+ho7UqUguGVI0r2s
         +gbayxTMucRicYscOMIUTE88Hz1JpGaHoZ9PVi7vQlP/lRW0hIPg5r7d+zsEZTt2yB2I
         mSSRXq1xlEhVPQXdoZbKekAGKVUGm68V9aE1X/6YZj/ILQs5C8JSihHYmMboZsVskdTU
         nT1Oc6k2YKoy214HiGHbXTMcyQB6HWfG36hNmsYupcKeOj+s5mltJT7gaQrgcv190JkT
         gZew==
X-Forwarded-Encrypted: i=1; AJvYcCUFG9XmNWbOsXIJ1+xPs23HMenBOAgEiM8wMfxXMmapAEjUHIUo++jJ/Se3NYBAjz7HhkiIZxqhQA==@kvack.org
X-Gm-Message-State: AOJu0YwjDf/RJe3sNzYWgDO4El1Re+iZbtBLlDdmvVsS9TXwPuzHpgpJ
	iXTJWRwI1FzKhxYwGyd3y3y4/pblAkJqhuUwbcbTzBmF2unE5tX70PuO
X-Gm-Gg: ASbGncsDxcPF3HA6yVKN1dqnbw/81CRQPgeUNAp5tBW+AgFyCB6COYsoAtPhc9uc5rx
	JFM5loxKuMZUdmrx1Xflhj+Mek8zdg1yD/WCgwmEBuffErF8U9wqBpID2kdiHjfemWnJv/L3zsL
	9lBy2fL1mMnriy4421XaQifW/dtDFIgTbTam20yWA2EqkIWkGapMwIruNy0Laaeazyy5+us4RkT
	19tZTbSMHArrpveIF80wwPCf658Z4RocBExG+Hd1m4YA0FLUiD7oiAYDJMhSbEFZiYMcFTAqsZ0
	Vga1F8zznRYTvfSbodn6J82lPKCL0JiLskMX8N9t5n46wl75Qje4739bDF3G5uHQfK/N1sK/qMn
	wQ36TAj+Y/MES/Q6y/TXJbNpNPnKjpm+pntEw+zqL4jrwwHiKZg/wynnMe0XY/VL0lPp0Yg1Fs8
	+WziSGQHMUaQ1KFhDzGCdXahB56Ak=
X-Google-Smtp-Source: AGHT+IFC3vQmm4T+O9x1swdQHkPxcdLNX2FjoEzV5FPY9fpi+xrqXDUFQdxI60qbTxTzZWHqID5ZqA==
X-Received: by 2002:a05:6a00:2d87:b0:7ba:13f4:a99a with SMTP id d2e1a72fcca58-7c3f145af7bmr4954362b3a.27.1763664161090;
        Thu, 20 Nov 2025 10:42:41 -0800 (PST)
Received: from localhost ([2a03:2880:ff:a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024b7d2sm3456767b3a.40.2025.11.20.10.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 10:42:40 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	linux-mm@kvack.org,
	shakeel.butt@linux.dev,
	athul.krishna.kr@protonmail.com,
	miklos@szeredi.hu,
	stable@vger.kernel.org
Subject: [PATCH v1 0/2] mm: skip wait in wait_sb_inodes() for hangable-writeback mappings 
Date: Thu, 20 Nov 2025 10:42:09 -0800
Message-ID: <20251120184211.2379439-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5AD074000F
X-Stat-Signature: p9nxfj4p87whi36rtgx1oiqfffm84tsk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763664162-406032
X-HE-Meta: U2FsdGVkX1+kJ1JCtCG/ebh3QEy2vCLFuW7dic0TJGXreJYDh5BcvxEwzXOpbkchSZ6STOhduWdm+R6+biZcroysNAnvXcAMbGDfvicx2xqu4jmKBzEiy/urj4yzo2Q4g0gxb7tj2aD7GmoeCqJtbi6MyOA8BlxqtMxgDZkEQIW01AHzO51pQwLV3NmxhCsMNVSuiY06CnObBTOsneI4+SqEYpfTl6mIT7LVKzeJ/xM5VO3ceAHP17gB73SYYsaLqKfSI4VCBvNxxB4UADxegqlZlhrD8KbZ1FOOyMrTfy2u7p/iDIcoAic5SjUyGznm8bD7XNEQZwDe0Oc0lzWyL6v+2JAQIopFa3kjkoEUSyywnFFqqgTbOhQNV1cjd6SbquUxCynJa2Z+LkuVdC+r+y0mBtlcPrpvfgl9JCdLGI5XpGU5u6H9TTMsZZfQNxwJClERHixDebWROjT3u6tFygXzy3cM1Q/PVP/+5RLjE3CiNYOF6+tKlOYXwB35h786+M+f9paDJtlWe2/fIoLaY6Ezy28BZSNQ5hszu7AbAnF/JlDONObUKHD7Q9m1o47s600fqMRA7TwJkDyoRR4nD/w6FRp60f37vAR0hElUNVuY7bX9e0iXe24atwI/tYm2d5wIIii/rOXHkeXM2XXOozCjctER/KQCir4Ndfg/JytWdIxUBtLwoxrKIK0Bkxz4b05JvuZKB2H3EITsHYIVdPEezyzyvvpJwQakDm3o/jCXAQELFajS90mzGb8dhy9QaC/HvWnN6lCJgPOJH4t67gWU6tm1wKUwhV7ZvT9tgG9BhX2wfw1WuteD5rG7xEbAvdp1Ss3Y+RiPrr/SMcObFKWPeJ+a7fGIF4IzW9zJRnlAfDfIU49gzpVT6dO3HoDdZHt+ShmK4cP+wzHoZPJeeMh3zkfSIj3ZqAvZ2aq+slIT0DnizjPCeZOASToqNXia0/txggobtK/9B/tw4AH
 Mm3sUBn8
 R0iLI/MGND/cWo3YsL0YePhws1wE7zQlzVvEmjG0RbldFfOtpn2UTdSZe5WzDsDbJbj9ORnS7PZImIw6g6d3HhzZr21zoQ4PFdM/cVmyq3Y+88PoWJt9JyCTG9XZsqj4Bt79QM5WJRcfvH9b9B2LuhLOet9qvIuSI4Wo1QcRn7b61XH3B79GuOFEX5XX3K+z3ewUXHfYTG4jyXOV/97U9SleTEwYx23sHsyvOX8M5uAr057LO7tHhlB8PhG6BKdyyQxSvXfKNyTmvJO4N4BHj8rIgkd0jG+sJt2ihbarxI29oDNUOZkidcyvhCHBT3Zr5sYOEnoDYNOrRrntlY6tf7BZwzUPoce/oSGj3eVCemoOCZ58sjutsi9z7g0sieqB+jlg6C9bwPk2EBbLvcWi06mARSrlYjtsJ9ubv9NkVD2eYb7hfGLDW5X8XXPr2ZzzIwlJ56RXcO6QXqdWj9aH8OWUZ/bvJfGJOG0ItMrFnDD8ub3lwzvKP2fFG4Y+RDQRQcUyE9IId9fCfTHDK4jo/z2Rd5Z78VntjH0MxFKQvOTc4X4v5Gg0SyNNKQIVzjlr8+1dpO8qOm4BOwy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As reported by Athul upstream in [1], there is a userspace regression caused
by commit 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb
tree") where if there is a bug in a fuse server that causes the server to
never complete writeback, it will make wait_sb_inodes() wait forever, causing
sync paths to hang.

This is a resubmission of this patch [2] that was dropped from the original
series due to a buggy/malicious server still being able to hold up sync() /
the system in other ways if they wanted to, but the wait_sb_inodes() path is
particularly common and easier to hit for malfunctioning servers.

Thanks,
Joanne

[1] https://lore.kernel.org/regressions/CAJnrk1ZjQ8W8NzojsvJPRXiv9TuYPNdj8Ye7=Cgkj=iV_i8EaA@mail.gmail.com/T/#t
[2] https://lore.kernel.org/linux-fsdevel/20241122232359.429647-4-joannelkoong@gmail.com/

Joanne Koong (2):
  mm: rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to
    AS_WRITEBACK_MAY_HANG
  fs/writeback: skip inodes with potential writeback hang in
    wait_sb_inodes()

 fs/fs-writeback.c       |  3 +++
 fs/fuse/file.c          |  2 +-
 include/linux/pagemap.h | 10 +++++-----
 mm/vmscan.c             |  3 +--
 4 files changed, 10 insertions(+), 8 deletions(-)

-- 
2.47.3


