Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C69A606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F3TizHJL
Received: by kanga.kvack.org (Postfix)
	id 2FF366B0749; Fri, 20 Nov 2026 00:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0076B0766; Fri, 20 Nov 2026 00:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EE66B0767; Fri, 20 Nov 2026 00:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5EC96B0749
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:13:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA16AC0D08
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:13:29 +0000 (UTC)
X-FDA: 85454329338.26.77A2650
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2152180005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:13:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F3TizHJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of dingf3ng@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795151607;
	b=dQE/jLMpIhHkhTMKkSPOOGMjXptFdntgDP6+VGq+NxBZBwg+o3rpPDFP1QSB5nuGWK/frX
	QZlPmnb+0vDrFvxpB8gf+6wpZWIQdsv3g404xBeaCAdlhdd1Nf4JxYIjRbKKv6JvXCx+xx
	WNGyZTdkhblJa1/U1FjNkW1LUTDayH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795151607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phVRdMSORW17TE4rtPtiPpRWi/Mw9XId3OY4Qf5snm0=;
	b=PM6ZYJ86WiX/7puTRvwSzs2BBsyGlMLnq1tqkYKezhs5Ju7d5gEK5e0d5r3tPHL5gLQ/Um
	Fyu6ujPmnomp1Qfv5gf2P8rhk86AqovVV2XFKNjuvzVrK9eWdMVxI4R1/ux9KhWa46wjHm
	67pE4ah54QM4W+RLyKBSq5LdYOy//T8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F3TizHJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of dingf3ng@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc147d86bebso289741a12.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795151606; x=1795756406; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=phVRdMSORW17TE4rtPtiPpRWi/Mw9XId3OY4Qf5snm0=;
        b=F3TizHJL8u/yeX/ij7cOyvjlzpp9BdPBgiPbj0AlmbEleFt/fsRp/OEVaL6MVZT/fh
         a5BTCn8UKlsmKy/BtNmV9b1NrqSwJpll588gaTXUt3xjlz2AMb6DU1sEH2BEJPHCn+8B
         8EEN37AczjG9CE7w1+I+36lqwvFCc1Fa3hwBYgMvnoSRlDvPsL+eO2kezCBWQZtyTdyY
         xJVXRVWVNjIW9g0AJpbhlaQsOZBYNkWoMz2t+VtpcztryzK84IT/7gA187UkkD9vcCp1
         afXFvmJA1U6MpYnhKwQfmj0j1Qem5JKNnShgrCG+UV95v+UymDnCobWMAfKkVSC2Rr5P
         wvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795151606; x=1795756406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=phVRdMSORW17TE4rtPtiPpRWi/Mw9XId3OY4Qf5snm0=;
        b=y+sg/W2Dj44kpjYicWEN+14lyowbekVazDyOKxqFYftuPfp/z1HdFkTYH/g/teosrb
         tSaobdx/zgAgUn93a5uxoF9hP9hFMsW5H1vxGHWjRGvlDdQlPimrD1P9p+XGReVN7igA
         hkEmztbW19xP3qDbUrlrUp9v3/WVQaW9vQem8bLMfL52i6vg9S2HE2xHOlkv/7adZW0r
         mR2YbVvcPKKfTGBj7R8s/StoQzQmsN+JT2uDJqNZI8dNwwVZsLDRRElM1gmlneGGOSLi
         ux41X/2TVHw90rCsjzCnTH/DJFrVOzudr3VL9RBfqol8abxyC+3z7HpZjKftqIrsML/T
         0U3A==
X-Forwarded-Encrypted: i=1; AL+hErHbkgsutGLXzBIO75xR47/PbwxKNTzcMegM0AozwWshj2SD10swePBIskvPkYGfKXmSOUTul4EfDg==@kvack.org
X-Gm-Message-State: APuU4Z/Jt9GflGBBDUInNVSyMXgAFLsNMf7bg0dESh7RoHjwzfBVXpGe
	/UlnlZEpISu7DlmbXSPMajSZQMBFNWGNvXdT2W1isKu4peJHa99dTN9N
X-Gm-Gg: AZFdTZe71MhoiS0QuSYAl179qde83geSJ4t3ri9cAHwaVLkzIl6xQKVISs50b4u7cNV
	0VnKhF4pmOdINn3tJ43+ZUTXth4xdgeJcXAAgxnGBOSAoEeKnm1JGDDPfWLeiJi3oadklQ6uGs2
	Zc3LJvQ9rLTPEjqJNAksiWYho+nlWAHyZTINmEiJIyeVrQjyYIuoGd1Js8YuPQD7rnT+AvxwUFS
	DlvUzr04w0yo9MdF132m8dDSVhyxMg0RsFEtAk2MDcmUHgVyQHC9ZcS64nS90SdKiOvp1jDzJBq
	T4ty19kqqgnplYiBao7AfVRpRZkwcG9WJZsEyXq4Gxxw0VwpVlcXFPhZgz8vE5K/5WLEyy7Ae4q
	+oaDK3aoJPnGgBmItC4cBVog+qm7cVBDuypZunoXaVcD82YBzj1kLC5LsqWoqOOdGd6kmbeACP4
	gpV2iAKeqn8DLySAJLY+gW76ynjGU9FDhB1OeP8Uu3uFFQ+kG7TeSD7SR1T0i/iS3dQhpgo5MBn
	m37rYbNz0lU8sm5lTspLBPxbjoNGRdMfBT5P3ZfAqsMvEr6zMLGhqevAQ05rG6/k/W15oQZzkJ1
	H1XQ8+11hlFH7Vzs6QTkdRgLhz0DguytPIehPZLMSZtUW3tE2Q==
X-Received: by 2002:a17:90b:5289:b0:3b0:9bfa:72ac with SMTP id 98e67ed59e1d1-3b41c908147mr1231766a91.21.1795151606447;
        Thu, 19 Nov 2026 21:13:26 -0800 (PST)
Received: from MacBook-Pro-8.lan ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402ac9b12sm3055446a91.4.2026.11.19.21.13.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 21:13:26 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Ding Feng <dingf3ng@gmail.com>
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
Date: Fri, 20 Nov 2026 13:13:19 +0800
Message-ID: <20261120051319.44456-1-dingf3ng@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20251121152246.1023918-1-bfoster@redhat.com>
References: <20251121152246.1023918-1-bfoster@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2152180005
X-Stat-Signature: mrpphj7of9i93zx17fz3weraz46onxp8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795151607-205866
X-HE-Meta: U2FsdGVkX1+GJJ/5DkTSR6f8srr2a0o+QI4dSb5S9hRXkPteHiKHzo3gb2z8shTkD1Ky0bRw6EI+RvPiJtxw69W1fSggFUZnw6imOChtc4TVItkxqk5ZUhXE9VYXiZZEsEcDOZgdiL/sspYN0QpBGCLT2VNDK1w+No+eYThr1za9AVPvMNd9xCjkrsnBiBepgUl2V7STfxXQlwFDb7MUz7jwWXKD9Q+eYd8aPOqX5Pat6SEjKpwSLD3s8nzSpaMGGwvQAU0xWAxbMrCMinza+IimXhb3jrEG7DPi6PCd5aKQym4y65BkCp8Crw9i9pd0D4MjMMZkNMwvRlhRAIevs9nKx+iZFTQBfcxE/YJqqr3JFoH3+FZ9+FHa9G4mgGK+Dt2EE2aH62p5YHo4jYf5IPUMqWsY0Lae70wDsFQUynkPywHiPf/MA0m2RhDijidiMmZB751kgVuXQcfpzoYkIXQC3O2NnvxwMoeDgVyPFkBQNHVJH4+H3qnAof8iW33PvE3AF9ZPSOiPm9kUhZiWLCnsazq+y0AJRIxY7dTRaNvGFFlldVgwvtjntaWkmITuD22s2PxZrZ5o8DLQAMtb2mEV3/xZ6xKcVUYwqXMTPZ5KDWsS7rumjlGJk0FfA+5hc43d3Jh3B9hSUmLOp5jd9CU+GTT5ks8gSnCM3UQEHnZ7b5JghtItWT3XAD0ZYddHKt0WcxeP7J4HcylMl0nE/hhVW/siNJONkaswY7qUhn+JdU2YLYr7mkEvLqgdBDEfZntfRW3oKC/sSV02Y7WNA1ffvYchS5DRhd4nrY21UYz2mAdrupg7pSeXQls0EBY9OYltakT9Id1pBmROlAgTMYdmz8vngdjrMXAYi/umF0xl9j5AJTRe2sYDSQuCGibisxsfOvcMTfrMfwnMnGFLMcgm74dqK89TyoMw1OC7GkCWReDp2i6c/7EZrPshmU3LlvhIzxW0ekaem72kfhW
 cwMEPb+m
 0Kq/9UV7zvcsx3FyO1Qlq1SGSK+hCYfG2lBJBmtNaT/H88dUlsksAsu/AKffRfHeT9MgBJ0/5/JzUBF9clsb6pq32IZv93qR2m3LbzO2xxuhhUrEsfGs5Nm6QtJ8ABkXEIeAujMa5zFfwzbEgyOEri0f6QXMl6OtRgBDMZka2fuWMFli0Z1bQZlIgbBipido9CqZVyarfJg6/NNhqjAbE0XgqmGPfHUhjwZSn5xf4G/iXfkn4WJ+LVyp3B9WB3v/eArwPL5Fgm+jbsBQDohvqf8XuqXw9SS5YgNbm5WVO1XF1XbHDCU+bKtUjlDKssRvU+rQApZZWjTgcCSSLHbBhwn4bDm0z/5QUfPUsD80ZJtNA5p2LgMBSp30xdADD3bvmLlBJKMHJjxaqPh8/ZSJoHa0/ezY+7mGuX0d1M9TYFeLLTS05pEjN+uw71ePd1OsY1cFiJR9T4XEzkvxhqnU6vwaGFz13XWFvFNyhBip4Y9CMoCaZD/2ywk3hq6gtrUMN6hOUxJGTadeQgFNe1Bi+/naElPIXrWTaQ1oz3BywgUN5/P4Y+92QPz/tg4amSCXn5wmkPMyJJBmJ8OE3Vh6dfoT8/5DZFneAUJEusCKqweOSYKFMlMei9ARIznM9M2fUVhkw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Brian,

I ran into this on tmpfs independently, and the series fixes it on
v7.4-rc3 (65e4fd942). Patch 1 needed a one-line context fix (the
i_private test in shmem_writeout() is now READ_ONCE(inode->i_private));
patches 2 and 3 applied with reduced context.

Test: a 100-byte file, 'A' written at offset 50, 'X' stored at offset
200 through a shared mapping, then the file extended, then bytes 200
and 50 read back (arm64, QEMU):

  extension                     unpatched    patched
  fallocate(0, 150, 100)        'X'          0
  fallocate(0, 1000, 100)       'X'          0
  ftruncate(fd, 250)            'X'          0
  pwrite 1 byte at 1099         'X'          0

Byte 50 reads 'A' in every case, and ext4 gives 0 on both kernels. I
did not test the swapout path (patch 2).

Tested-by: Ding Feng <dingf3ng@gmail.com>

Thanks,
Ding Feng

