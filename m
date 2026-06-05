Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC06CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880716B0092; Fri,  5 Jun 2026 09:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DFE66B0093; Fri,  5 Jun 2026 09:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F58C6B0095; Fri,  5 Jun 2026 09:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D816B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12AF7140117
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:32 +0000 (UTC)
X-FDA: 84846001464.20.17205FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id E00C34000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dSJoNmmx;
	spf=pass (imf27.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780667610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iavcFnyVi7+3Trg9epYKO4ba/4sETBjrALB/+SG2R4E=;
	b=l2kxNaPLuFrpEANia4Qr1OCAGFxMelyQsnnswCUEnqEiM8P/fei/TJskfOGWJ++OK3+gPk
	zJCCHU/3N2n2+77/jZ42rY2fENp9nd64VunsBd8+h67Z4nL3O1gDKQhlEhJ1TzCDaa+pIp
	T0bRWs7gciHuM7hvDErrM5Ae4rE+RJA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dSJoNmmx;
	spf=pass (imf27.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780667610;
	b=rt9qJu7Yexn2HkbzShM5L8qxaazPGFMLJyg9VNSdKOvjs7+0eRzLxxgA5s72qOf1tZNjUx
	/aK8tnIPICL6iOLh7ZTEJtWR2HPRvF6e3zPQGPJfhNhMwAS+F5pXV1kSQ1KSx8lthZYaMZ
	8ZwhbiBeJsxYoC8cePtMa+kTGzqspm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780667609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iavcFnyVi7+3Trg9epYKO4ba/4sETBjrALB/+SG2R4E=;
	b=dSJoNmmx4Mj5DE2I5LnIaIUKKb70xxipBBzAHI2PPQUStZYNHljKErX6CNDlRqjU119ZPD
	kRIX5yxlDtZrlQhy/qBRcnP+jZi8FnXADrbuwgReZ++bMU9ABngcuXQWWSHSzXGIHxyzDB
	bwShnnaeQGCl6Gsr2DsuI5ZPBiYcMwQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-uPTVKODxMd2ry4cbShXzkw-1; Fri, 05 Jun 2026 09:53:25 -0400
X-MC-Unique: uPTVKODxMd2ry4cbShXzkw-1
X-Mimecast-MFC-AGG-ID: uPTVKODxMd2ry4cbShXzkw_1780667604
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-46011aa5000so857158f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 06:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780667604; x=1781272404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iavcFnyVi7+3Trg9epYKO4ba/4sETBjrALB/+SG2R4E=;
        b=r+H7NIx5rcxJrMxE8mk2591VIN8sP/04LJSuXebmsRFV8NMGoXZHmro3wl4xsJdLPR
         hxUJcotYpMJzy1ZYG2EOCI43OAdR5ie9Q8cB9Yx40l3/TlqcF9jkjsGvCyhErhNTZNEh
         7R6ah4CTrWWZDJx1aTyw++mkJ7ciqnb2o4WSGfHRTIW4KzK1uUHNrVdrp9SHCJLp6I27
         t7mU2LSRgVDYTP8GRg+9x1WuARUVb5y6MABGPQfsMiiFD0tqZqGv0/r9zBmouqn8x/eb
         zcSVBnTr7XfeQHWxEjsLS2bq6WkHkNVDGqBKeGbLowNQCAqOAxRS6ai3wURyZ2hKCT78
         9D4A==
X-Gm-Message-State: AOJu0Yy0DtnFHybcUKlFEtBN4Epsjv0cqTmIwVKxQgDfqIMk9WI3l8wV
	LeHtwtAGXSuQy83KmUtNRvatowcmzvN5/HUPo1WMfy1BbYn+3SotzfhV7sWMZpPIuTM4JtkylDV
	NU893t3wtC+cV+rgiDSvm8cPlIzRYFf6Xfu2aBpdmQ1I6maAALKtf
X-Gm-Gg: Acq92OFcZu/mrMotwvujxz5utXCv3awYAXZa0muo2gkAj7RZruW48Ah4z3wZmoIen1m
	C9751Iv581KG9/Eix++rdsVkc0A+7W56pG0k0352DLHoQYo3JObt4wN1lzhcchrbnizdAvyLI6N
	emSjzrlqpx1nD4iFK10YzznkJbS+bgX0m7nqLLZr69yXIqhHNbMRFbOl4EBDgKprP+yZxXZSUNY
	Azvak+VuSEHgBY+UFGtckCVxD+IEf8FhBA/CZ+hIekEOKeKCjulhcDivj8Ie0osGoyubcapmZpj
	/XfdfP90uJJPw/5algQ4b0AT6s+yJhzz6MLNA7etJ0EIUMIYaw2VyLO8wKDTn7IoS4tUBmchYxF
	ALsqXRSn0nWxYY4B8vAY7+zSSO8iRaDEQDZLmcpuxedXnXc59EgwM2eoLrPpFtVe6HPtS3x1STy
	6fFctWbw==
X-Received: by 2002:a05:600c:620d:b0:48f:e249:4094 with SMTP id 5b1f17b1804b1-490c25fa907mr53133285e9.18.1780667604488;
        Fri, 05 Jun 2026 06:53:24 -0700 (PDT)
X-Received: by 2002:a05:600c:620d:b0:48f:e249:4094 with SMTP id 5b1f17b1804b1-490c25fa907mr53132865e9.18.1780667604107;
        Fri, 05 Jun 2026 06:53:24 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm157999025e9.7.2026.06.05.06.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 06:53:23 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v4 0/4] simple xattr improvements
Date: Fri,  5 Jun 2026 15:53:15 +0200
Message-ID: <20260605135322.2632068-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IT4oqidz8ngpoevObE03rLeTEI7z5CP7mn2UF_7EU2A_1780667604
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E00C34000D
X-Stat-Signature: 6ffk1coqdu9e65zd6j6f8r4zjrf4bfsf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780667609-649271
X-HE-Meta: U2FsdGVkX19X6oVvLzOswm/RfW8gKsFr96/+uEWWRofappvuydvTcjwgLj6SbKTKvovA/E8NSLkSkfFyKL/S6kgm8qjqfeu7ojDR7Eq5SVc480WZ1mElGG14IyD816JyfsQ2oaLV6ObW3Vv2OmRLi56p1w7MVelMtm4WCVTugW3V675ZMQr5+DTv+ug74v8D1HoKaxCbN1wkboxgJUsP5dsLB4PgRtgtXgqRDg0qw0Sab0rqxI31VpFTqCm+WeImQPKObV2BrAGl0LN7NyhgtrEJUINp/nENDRPcW0/pajCphSMbUjU0VS0OaKjl+08SniXLBE8ckNUNzm+CNUwg7SaCCwC+CDaDKi2xrfPEn19wTN1JFxw7FIOj5JYan+2S71hqxzmGfOUdAYOvRKC7hJo0Np+JMjSR62rJlfqiXvZrlG98WS+hojmwPVXkokYXmhtYVtQDycZ1b0jd90fR7bcYMlblv7MW0/6e4Jb8RLGwWhvSpeU+AG4/x5F65nq1igXsLWZ5kuACkGuBg68a+pYkdoSJO6puSCU8a5ILPu290QBaGjUmfYFWu0h1ZweLJhlivfcj7/mN5bDxlMKNrafGyhFhFxixYZ16ZTSRUP7/S0ctnVTUi0mi2aOwozFRVy9NiXbMX6rWV6kdbuR7DZXRTWSgeUcMNyjLZ/CXWeROrmRu3LlyUZBNxL6lE+Syt/25LjreKVazi2Izcz16OgqinZfk2zRpGWiC3Mn+EQuBhiQMHYrHRDw3PuniVfbZB4e/B3rPX1RokLJgWQho6WzcMWzZ7FVqvhuIcgjE9pIunX/2xiYgNjcv1BL+37P9gUmgJs4WDK4a9CubWfwjh2EcVOM8Zpoq4kjFXb+eDOGFZkY+tDEvpmkzIwhSafK462dBNFEDYVgvHSHb5gxWKN6J+elpnkfhUloByVUErMYuneOWuhXLCGQ5XRMuuJS032W/9HQyg0nLgw9ImZX
 v2Zw7Qrg
 przTKPCU70S3dTTbB3/UTrcpLD4jiIQWUeCa0eMR5Ly2bvLsMALDvTSRfwGYEctjN8CM+PhE+heZLDuG6nleQJEcYRvAJ22o9Zdf+BrFfIE/7VhBNwsdybLUVTt9x04fQErm1kvqcGnJDBsFa/32SVRK/yOLkU2yXv4gRogOjjpKrXJeb9EWkLZ/HAEOGX14pP2GmCQlnJ4UC7DHltq0VVQSY7tAuzjoRdqD6cQuu+zHEHIlq3QmWXoEHy2qOzaKBOR5PcNFm+LWoEcK6jFR0BfhHS5NHS0Ivxv+OKcSUYKHq36s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v4:
 - yet another accounting fix for shmem_initxattrs

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
 mm/shmem.c                  |  50 +++----
 net/socket.c                |  30 ++---
 12 files changed, 252 insertions(+), 271 deletions(-)

-- 
2.54.0


