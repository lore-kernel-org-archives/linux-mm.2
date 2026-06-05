Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A8BCD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFB36B0005; Fri,  5 Jun 2026 08:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370416B0088; Fri,  5 Jun 2026 08:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F676B008A; Fri,  5 Jun 2026 08:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 155436B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADF091A039E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:38 +0000 (UTC)
X-FDA: 84845800116.20.663DEC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87B6F40008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AE1d0i3Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780662816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=19vOK/aljw0dP+/71WiEI9NMzlYECl5zmc4CQK8fGGU=;
	b=wDX0eCGFQs9mjPXj0IwitDlbcVDCu74RKC2Ea5jnjqcAizc/iXQmxhAMYEcI3SEtV8Mxi9
	/JHtorohKLDYp5Fvkfpp7cOyagJWWh1inTuuJXuety/2DHC8xARU7aIewwr8EOj/DRFLXD
	InJNweiePYPTIT7PGYcaH/oWmOdiNrk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AE1d0i3Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780662816;
	b=U7f3hfyLMg2eVEf2Jx2LDjupubTcRvistDeiMIDgLqePH33rkY5PUYhDbYxH6+ISk6XynU
	BUZs3gfKI8H5eBIkKUtDbb+EqhnZweWJ34gKXp9p47xnq1yfA1a1mLi5eTjWBCoaaa9KRL
	kV6illLZP0CgwwRfz3Bo0WwVzAt0STA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780662815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=19vOK/aljw0dP+/71WiEI9NMzlYECl5zmc4CQK8fGGU=;
	b=AE1d0i3Q7kHlvjdS/R9YR79X9xd1LhUWxaZBF1Ezie78osOxcjPsAPUk2KvnG1rR9QeCRT
	PdF2ki85XcC7D4n281TtDkEaKNHttdg1VrofkizAPZYLQCiF144HirqcLny2dUbyNvlY8b
	TYb/0w4CPGJSxEc0rkS9wqCeCT/Bun0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-cOSvpjzJO1eNGhQl04rqfw-1; Fri, 05 Jun 2026 08:33:34 -0400
X-MC-Unique: cOSvpjzJO1eNGhQl04rqfw-1
X-Mimecast-MFC-AGG-ID: cOSvpjzJO1eNGhQl04rqfw_1780662813
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef5e38a18so883438f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780662813; x=1781267613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19vOK/aljw0dP+/71WiEI9NMzlYECl5zmc4CQK8fGGU=;
        b=Uoe7O8OOMSpQfvJWHMEIKqrbGWwJtJlvXyF9R597tRZvN2GowzMnkq1OCNPeNwK/Ks
         Bz2mt5T7b7Nq7SHx81FtTfuXms0xeJRmd4AtYwudpl8b8PslyGfVCvZpDR5D/jcfcB3e
         BN08GFoZY9fHazfflMe7lpkfVgMqUXdhs8bCyd7Wrh87+3TfcNGGHKhTJs7IoJlpKwt1
         8swA933jfOaqz+FP3lBc6fZyczDqrHQp/EGs3W/FlIpzYgykdJZpPxMqHoULEZvVsVZh
         SC6Mxio2LHx9ILK71AMdleqhlKgPJgWUR3M096qBfqeX3e+D5I9LeZLfY/U9ApeHtX0+
         s/ZQ==
X-Gm-Message-State: AOJu0YxS6BS50kG8cC0CluiQ0csSw7rSl07LamqMMwDDd/cjfBqmSIyh
	7tKXnJ6gjw6APX4L5+yPoK26Xdqjf4Es8E/aSCCW7hLqiUomFN+Mgj9297mfKHKZmlf/iX/2EV/
	Id40qVAQMyJuKSG1IKIqCleOzgfft7rUr4EaNVe1mV0LnhoIbPQ3w
X-Gm-Gg: Acq92OHienD45czpS8hzHz9PjdnWN17VU6/kdiC1h51Wz+aK2OIwmFLFOfWRCu0uy+K
	8U6P+Tk2r6yvJLBijvhlA7h1Ap+6vBgIsNknpRsNDTBDDSZr9tpG6eboxQf3eMsRgfhTo/BHbL1
	7WLwogYUBB6f8YnRyP7V4mCitr2ulCrMa353DP/kydeksCdTVWVJ6a4yGq/U+zAFePmdz9pYdPC
	KPac1YTye7d0OukBgdyysSf0tKJv/SDhsgvKu2X2pTI9Wwxs7QmM3rOymKyP4vJUCRXSR9XyrT8
	T5TSWwWwczVM/pH9dmOgFmY+k6LPN/azaThCCzlWKILlxPwsWVUo87Npjwdilbs2IUHS0Ub+zHn
	n+ZMBp9aquwmjy+B43p+TAv0e4YQiXXU1eUukZj57rrDduqGyMnPlAbgk9RQRmIIJSqJjATa/ty
	7nhZC7Bw==
X-Received: by 2002:a05:6000:1e4d:b0:460:1168:6dd4 with SMTP id ffacd0b85a97d-460302e49acmr3984558f8f.14.1780662813448;
        Fri, 05 Jun 2026 05:33:33 -0700 (PDT)
X-Received: by 2002:a05:6000:1e4d:b0:460:1168:6dd4 with SMTP id ffacd0b85a97d-460302e49acmr3984523f8f.14.1780662813031;
        Fri, 05 Jun 2026 05:33:33 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda3651sm12702780f8f.32.2026.06.05.05.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:33:32 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 0/4] simple xattr improvements
Date: Fri,  5 Jun 2026 14:33:25 +0200
Message-ID: <20260605123331.2621677-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LZDns499laRF3JBdzdLNW8zLtdLuXfrF6nOn5RU9jcE_1780662813
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: po5fg5odxi6ngp7nuizeemoey3mefpnt
X-Rspamd-Queue-Id: 87B6F40008
X-HE-Tag: 1780662816-463197
X-HE-Meta: U2FsdGVkX19gieNRmdKYuI++AFOvwctEd2MgoB09ci2pJ/BJAdsiA/z9QtG/oQ1mGGaIMDIw7IJ/EbBfBlV9xsS8E8CbDmItfG5HAx1FsAnGuXY4+LankQwCZoJO+Rmcrmepts4sTEaDT//k/WZlulKZIYUQmGcl8/taX1TdBpCYImQ2r/kDGHTweRXiWKLioXO33197lHuKpW50c3SrmZfkcRYy1nzwFMkc6H9RM76W3/Wq9vno0xpQ+hRuSF18kLH/zpRK948sNBVPd+EtEBfIe5tlr0r74jzZ8p/4cMujnG8piSZ8ILM0DMV/BMRBEfmYthKL+ho33UQA/e0IWBpeOaxKNEpTpOu37pZpjqfoSsvl4FZ3I3UmMup/uVaNFvFCM934ERIE0KbDhT1F8AtTPu/4HmOKPyZf36P8aAPF84xu4lC0JaVT5IMla4cBk5GsfxrYbd/VR/yBHJKIZuNBa7rZbR5n33lasSlb5GKFeoGjbhnRGbYCGlnJVNoPffyYIaBOcKKM6Ic3HOmoCoD/oG+sjZ+ZnpOgeHsqDKiY84ZgOBYvSPs2hV8NBVy9IVJnXAvRXRo9F8/YatOwL3Q5wlStc1rei7NUNViB/byrXmHub7bXpuJmxyhUom4OjQdgWF12mAM7eKxq0UhqFpTPAtvBjGnFCER8To9MX0nsFbAoxcgSf8nTIXQPS2bBNQWj0z5eYtf/JKNQBikH3FJQN38kTbybBRSDxK17H6vd9KhR1S2GQx7MRqcS1NytISmFD1y8J5LAmYlyrlmcP4SfYd/bdOMEbaHTpH0NU4tZIGX19a1Z3dLWU6o7HVo4o2D7EX6UHdbucqF41eLgjo7OTbG+oJKA1/24DGH8mZhv6iettLkpcSBvcl/jI+BVTYhD57o8CyjkJ/lTYnNF0Yh+3M3Byo/EDAQ7+Az3H209Xr1Fql6wq3BrUZD1Mvz+n8NVHGP5A/XGUW+Hiv0
 p219uuBt
 m6LSjx+PzGTnUuawaPPlAhf36sTmnI3rXB50+6nwzuztf54jcDqr6qz/ki30lWO7aPnMlS/Y9w06/ed20Rbb2ch5I3PTenpxzzNeNqhN82mCfM+qAFecqd4oEdHWNEepsnUAnmsf2d4HITlp/h7WVpyv6WxIvXCmf9O1yA1X6pn2vfK3hrKkRQO6UpU5zBD27xlwFzcIEApO1+lFlCGA/ta/R0nuORAYBar0qDHPUqt/ApvrwXMj0S7s23m8OiEWaNhofeVCEZTmEuhD5hyjiynQp5BGiM78gUddYm1o9e8stC4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3:
 - need per kernfs_node locking for simple_xattr_set
 - another accounting fix for shmem_initxattrs

v2:
 - don't use xxhash
 - fix lazy alloc concurrency
 - fix rcu freeing on evict
 - fix rcu walk of per-inode list
 - don't double account freed space

---
Miklos Szeredi (4):
  kernfs: fix xattr race condition with multiple superblocks
  tmpfs: simplify constructing "security.foo" xattr names
  simple_xattr: change interface to pass struct simple_xattrs **
  simpe_xattr: use per-sb cache

 fs/kernfs/dir.c             |  13 +-
 fs/kernfs/file.c            |  13 +-
 fs/kernfs/inode.c           |  36 ++---
 fs/kernfs/kernfs-internal.h |  24 +++-
 fs/kernfs/mount.c           |   2 +-
 fs/pidfs.c                  |  45 ++-----
 fs/xattr.c                  | 261 +++++++++++++++++++-----------------
 include/linux/kernfs.h      |  11 +-
 include/linux/shmem_fs.h    |   3 +-
 include/linux/xattr.h       |  35 +++--
 mm/shmem.c                  |  49 +++----
 net/socket.c                |  30 ++---
 12 files changed, 251 insertions(+), 271 deletions(-)

-- 
2.54.0


