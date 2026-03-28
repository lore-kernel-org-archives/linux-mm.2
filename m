Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F84910BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 07:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2056B008C; Sat, 28 Mar 2026 03:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A196B0095; Sat, 28 Mar 2026 03:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0426B0096; Sat, 28 Mar 2026 03:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94C3A6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:58:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D1221A117C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:32 +0000 (UTC)
X-FDA: 84594719664.12.76ADBCC
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4446F18000C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jk3Wj0q2;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774684710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YDoHwMIsV0D9YCpWbQEiHWcbh9XPii40da11EBjoLuU=;
	b=gfrA0b3hNXUbEHW3mFx7pcTWuU4W5SDpQMMuXtnVZQPBQ+apAQXUf/qP9vD4+1vhHg4vwz
	SdcTd6K8IGPaZ02WRBWokvvolBM5MSr3j+aXKDrr9emmIq435Dx8rhrMB2M/EIkh9u6iOR
	FCErfoV+FFmOJB/Ow6tDCElpJP/4NBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774684710; a=rsa-sha256;
	cv=none;
	b=VkZt5Wy+wZW+mGy71BJrH9lIzGtxxN90GDqhqwfC7JtjLaMLl0Hwlyg/PWGsogR/ZhUsff
	D5ZRVmvAuUbAkgXt84Vx1qAEA2ymZvcPS1RxG/bNcF9oaHAhbPPoSiTre5o/A93PyRKQeG
	3KpoJ5RCoFVUH8KKn+GZi6zqLiZBi9E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jk3Wj0q2;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-823c56765fdso1557184b3a.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774684709; x=1775289509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YDoHwMIsV0D9YCpWbQEiHWcbh9XPii40da11EBjoLuU=;
        b=Jk3Wj0q2wwXukMG0b/i/Zn7hv+wCHTyX3cMFoC/KCvULU0C7pe0eR4tx8QK7NXBSR6
         cyZiatzVFA3az6MrupwJSCugV+TupIE2dnjwpNgfhvOoEtQONq7lDy4ewALsouX2HCPM
         M4WMvizyk9owon5bIPOhT8VuOrV13MjwXmS4CvkJbjzugXAwaKJG6oRibv4AoQtyCjKX
         lD7NCdOjr8KfJgVzCth3ZReP4y5KWUaxwTi+aPoJkRTa/Y9yXuHANa2iTXJw34xkpeaU
         XLo66vAq//vNGyMl3EimigtROGuImukd8l0XrDJYW2uRECB8l98Uga5XKIpb9ZFCJdII
         tRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774684709; x=1775289509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDoHwMIsV0D9YCpWbQEiHWcbh9XPii40da11EBjoLuU=;
        b=dwDzywkxSl7DApuevmoUCL0veOzZFfa1YLkk8Nj3D7EYTXO7oYg/OZw1vN/LFUkVQ9
         BeUpXlIfVqSg/EW1PjUKPkvitL8SoVO5BhaqXcfHV1MrJ204UMKZmhoV2E7NKGhVgAwW
         ztbpENql0pRSehI5SZjm1JyGWmgGFjJG9YTpBFD66Xoul6J9+vkXop54rJ2zjZyD4BvG
         zxvv/5FShSMT4Oiq/fji7DsK3Y2Lo4hdjC9sMZ5LAHbGsLKtowNOwJrujaTWynkbASSm
         W82CH/D21UliRkwF3mgrPcPfmwYBvfydR1FD6d+pZIZeXl4bvqKJAS69y4WNy1qi9U5d
         D6qw==
X-Forwarded-Encrypted: i=1; AJvYcCV6S7rUQPFxCYHARRgI51GYPTBMNSrWpWJ90yMzwySi6P5JFzY7wM/acG8Gmm+tppSYFS8dP2ffRw==@kvack.org
X-Gm-Message-State: AOJu0Yx9oNNTG6gbcub+Yea5HxwMt3vfOy0ccAY+jMcoF1Q0ofcf1qr+
	fZ5PK0Ol2X5fxcIw0edXABdiAi9Onrm+V7G2Tyw2RZD3YGe7So6w1P7S
X-Gm-Gg: ATEYQzwu6tbLxovUXmPwJ2H76bB2X3UnFwH/LgxoVxoy6ju6/1DNNMnp8UEPeZHPDhF
	tWbmHLKmm2PoPBGT7TC0h3zpge1XBqJtDdIg+TDlYcaETtxAaBlJNAMmYeNa5BGw10UbPjg2Qo5
	HiRIwHbSkw1d4RSbJpBVRooX/2MK0Y+2Jm0e+1XejUHu9IRn08487gVcqVaK/6ybtgxgjJwcgmk
	kmyXOP3bO5uLYbPP7Sa1SizPDH3m3T7P97MqALJP1T9C0Srw1cLfi22j6/lTKmDGOvpQhmPp8M4
	hD0kskZEhhrvGkWsDQGWqXPNWoKnTblKS2yzeNA5E2MGEpFOKl/HBDlYAJ5Rd0e4svhchScpo6n
	q/Y2X2Q4XiU+xHRIy9U+rMVpMkdPwxv69OTC4cxj51T/Z1kWypEt7+bgpreewPWxT6hFaA+UE+Z
	CrJIqb+AAAxxkNus5C+0hsedrgBNeF9rrwYJi0+UDfAoB3U9e7l3WpMq3SYE/6bqZCRMys6rL05
	HxmdpMmI/Vk6tZ9
X-Received: by 2002:a05:6a00:140d:b0:827:3378:ba31 with SMTP id d2e1a72fcca58-82c96088542mr4676409b3a.58.1774684708676;
        Sat, 28 Mar 2026 00:58:28 -0700 (PDT)
Received: from Barrys-MBP.bbrouter ([2409:8a1e:2e90:6fa0:903d:bf86:180e:c711])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca84644d9sm1448312b3a.13.2026.03.28.00.58.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Mar 2026 00:58:28 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] mm/swap: use swap_ops to register swap device's methods 
Date: Sat, 28 Mar 2026 15:58:09 +0800
Message-Id: <20260328075812.11060-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4446F18000C
X-Stat-Signature: g3keqr1d4dy3wu7c9mphmdm55sfzjgei
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774684710-108216
X-HE-Meta: U2FsdGVkX1+AyifcCTgbtFFS+E0VNGw90kvLhuWiiXN7b2QykSiF+4eGaOaNIDeVJLPFzghQ2Rl4HXfdtszNLDWwjc6WEKm6YtXStYa2ZrgG/r+UthccxkStdRQ6Nl+Mlc25BCPw9O7u1sNaeleKwscA6tBkGcwF66eFulu01BCX8do4lpshJifghM7xlGYqBY2/mRQ3XgSd+7xJjd0E6z1HlrwlDfVlpGnJkjjT8Wdk9P2qoy6Ll8PfmPzoTX6hiwezAyWkJ35UYRFZkU8LosGi1oRNhKYLe2XnOGZZmSa89D3DBZ6s/ocTEF7oeSXO8hz/5hwauko1QXrja3MJa/BVIvDblJ3TZtd0XlwwBA2x+AT15RZcEgP0Indw1YMhvSEn2X0J2kmHKh5bCIEnm5PbX3JHHPNb9+kAtSQzkvYWCht/QnT2Q4s880zO+sm+9xbQb4gdds8T2+y2amKRFx+yTx8DtqwgbFoid9DpLsKNDFTUSL+i6MM7QFRmUBbhuzQWTGLkJnsPd2KcQLNgKVCmrz5xNaUQ9bvHbgZrmJRWlVD2BxcNKwmjhsvz2zC6kq0ZafAu85X+A13/z/DL5xE+XPAnxguPourzSmAlyuibrPOpMBsAwnxFUwEhIHawt+8O7r8O+W/SA/wcC4DPIVfjKJW2UGS+lpWBbxddDjDlIcjph6JE2y7/ha2g+ZA1vPlNaGwaSK5gzxtcswKvQ65m67id8dktC/Q1s8rT8EoDH/uliQRgBltswJ/K1120cjr4t6BXrbaqv0UZUzrOqznbtUYOXeOnksQ9iyUg691hGpBSlA5Y+77tqmgqnUCYVD+8cv97UmRoQ/ZWu+xwCRPexOw725US959CMtH8Wf3A51wA7fGE+HZG65UXbNAmLyzUYhshu/grwjk2J32w9r4ngDjBd8Kglo6UEYzVe5gfE+9fYhBEKhqF8aXiU4AwcaQ/wv23tsRrCCv1O1n
 iYRV678E
 vQGtpz7/3JDjQzDOuOznF3w+3Qv4DBgXNZhxHrSOHK45UX/GbiK7DDokzSio1XhIKrdMqsohwP3vUW6wm8ZvtKxrgcYabLW6OyuUIcT8DYDI8gOUTvrpfl7Cxmkf8AZqHc7QsOspcB45rPT1c7B5IM3bk+wt1QHFyF0KLHLSbdF9JBUM1yFgCrNAf8Jvn997P5eG2b11vZOywze7LEClYce8vljMQs5SnatqmV9GTFJOP0PrmtiYBTR/8ZsTAoRhsLSub74Ukl/yHBv8v8CYJApk1xLD82KK7B+FoQPFbf+t2U+2A5e8JJQ7niqVNIHuIolvRZ6uiVFVwbrjXsU1B/4LQFmTFt3MH0RHLXlFPzg7aUcta9KyLSHi/b9UCyZ+UFVSvD2+E1WBL/wAX7E9vNGg2pr8wEadZwNWRhC/uw1vYzysF7/jRj+ctPSDAGv0kZzP4yyE9TFQfp6NHBmyQRjxN6KTrhtsYP8/870vLlOCiqypfmdvqt6PVpTQd3fx6H9O9oNRbmlviYBXh9FJy0jzr4pVtf+NjaVF7vAYuTmGJuCLusxe6DNSAnmEUzz5oItbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <baohua@kernel.org>

-v2:
 * lots of cleanup for patch 2/3: renaming, moving data
   structures, and using const properly
 * collected tags from Kairui, Nhat and Barry

-v1:
 https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/

This can simplify the code logic and benefit any new type of swap device
added later.

And also do renaming in this patchset:
-------
   file renaming:
   ---
   mm/page_io.c to mm/swap_io.c

   function renaming:
   ---
   swap_writepage_* to swap_write_folio_* in file mm/swap_io.c

Baoquan He (3):
  mm/swap: rename mm/page_io.c to mm/swap_io.c
  mm/swap: use swap_ops to register swap device's methods
  mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*

 MAINTAINERS                 |   2 +-
 include/linux/swap.h        |   2 +
 mm/Makefile                 |   2 +-
 mm/swap.h                   |  12 ++++-
 mm/{page_io.c => swap_io.c} | 101 ++++++++++++++++++++----------------
 mm/swapfile.c               |   1 +
 mm/zswap.c                  |   3 +-
 7 files changed, 73 insertions(+), 50 deletions(-)
 rename mm/{page_io.c => swap_io.c} (89%)

-- 
2.39.3 (Apple Git-146)


