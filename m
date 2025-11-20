Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8287FCF9C7A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD796B0029; Thu, 20 Nov 2025 13:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94FF6B002A; Thu, 20 Nov 2025 13:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D196B002B; Thu, 20 Nov 2025 13:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A193F6B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:42:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47302139F56
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:49 +0000 (UTC)
X-FDA: 84131856858.04.2B0B631
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68DC940011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkRslEJY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763664167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SdOHNqAWfToMGBCQSO9tHleaQeM6zla4PftQMCtKtA=;
	b=K+zkxkNG8foT+IkBbLhaBiYjQfpCKhiqocf4OTy/bZWXofSEO0/2Ls6Mdc1EFyG4lmF8hT
	ln/BA4lDdXRj8ws5UpzkEdeQIpFoH8UDhsxz88oWAH/m93VYh1fJ97H7W3S4TnpHxwlWva
	Vs+DhrMd9ToYXEBzbJdax0iBMUWWewE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763664167; a=rsa-sha256;
	cv=none;
	b=Wyn6bkFHoMlt8PCmy4EBJqt4iWUhbR8DaEKv9ms2/DIpC6hV8u2aBL5VsqIcAUJ/OZT798
	CAznP+jN3xwKW1Pmd0iTNADJMkeNunXIsOsrCs5uFtm7VuPpDt1r72Mo/aeu6Tb+eBj8oL
	wrfYv06v/YwF1ZTKZpF/GPmd7GQUisQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkRslEJY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29555b384acso14635105ad.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763664166; x=1764268966; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SdOHNqAWfToMGBCQSO9tHleaQeM6zla4PftQMCtKtA=;
        b=DkRslEJYbKLfg2s/lXua6aYBuu66Xru5yh2KgAPy9UW0zGQ9+vIgFlnSfOBM7gKXfN
         8/zhJ322vBDfT2uu2mvczKu0k2I8QwsLwdI5ModOk0pmkvxardWoROGX+gel3DNWYU+h
         xjUDey8xONFrZj0q65Qac1d377XVwRuyIKZrdNGm6ihSNS3TP4U/s7d7sS4mCIfljDIL
         ccnKSgcnKQ3VJolSV7ENbFLrSkNJ+xLSxUIKgU+Y/DI3pYd6mF9kF226gjhFOQpGEJw6
         4wCklsJ5EqwAfDRTZhUKMEyf6cC9VHEUaAjyXqBMpvam6jatqU12xs3iJdcVxBQBItOJ
         SUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763664166; x=1764268966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4SdOHNqAWfToMGBCQSO9tHleaQeM6zla4PftQMCtKtA=;
        b=ZmZ+5QR98nGPUXOvfPizyYTELFYuXp8Q6MCwAMBY6apyI3EpGWp2PwdBD7o3ec9z/J
         Ppozry9JTHF6jI0yijXjE/peZ2hMU/zsyLi3uWUzJxnNsu1Z/PoZ2NNnat2rDiOj7Lvo
         0rIHuydK0+phoBOG1lkSJmapt2diikuuEQPD7AfbanWq2i+F8isUyyihHA/VGCOltgWs
         811H5yOk26FUi8TjECHOrm/3XOJ9jJTFhlX5JJE7UrdgNEkZRMwVuzwRZE4rjHgn/Itz
         gYeFGPtcLVIz6XpbJOs4Mtgw3e5yZQgvrKcZ/f0D9cLCDgOY+QLf6R5XA5J3Ncm5pVJS
         L9XA==
X-Forwarded-Encrypted: i=1; AJvYcCXwHO2nr+h6j1fo5BXWUb+KoYf+g9tdVdSP8roJzFxC/3lb1WIFNkllT4VC5V5n6bGm0g7PzenTDw==@kvack.org
X-Gm-Message-State: AOJu0Yw1udZu53h/C3RZKkiQTjMxbwPDXiy+tHiC/wZg/tlS8Sfb/vap
	MUWptDKJE3hp4iH4vXCy/fKmammdbArLw5JfKasByui42VUC8UQVjrj7
X-Gm-Gg: ASbGncumIBkk7HM3JgqmZQ9yFtma4R/ct6xWg9+vdE3qFNCxR4/jjbPoKxoMCSoZOec
	KApCRPhjbFI4Nt145DW1vYW6ejpKBb78Zjj5tNHxDVa0hOTFvjWx2azOGQiBS9Z5ofxva62FhPr
	smnII/NlZ2yTEn+9JHiTL2EaoJxTVlIxE7katKcJ1frL7ByDXb06a/2TY+9+njNTqykqWkZii+X
	YyTtJRwIEkAfyjM80++B5uVj6Ts4ZbZCqC5x95P39ArUqFjT/Z5Tl5Xs/ay9ynw0pQKtxzQ3bDa
	pQQEKM7kSFjL5sfCSfO9qfPiRYTo9mpPnFiOm+S+KK5KjCuNK4Bkrrbo5WK98iUeVpEPwkChI09
	ASzkR/SVL21zonGOvw6UlNKdEkvMPx1baT6qN49yG2CYqPA+rqoT48SVzUL77wdy3c8qPjA+MwZ
	dDPHmjZMkQmveQ0b+8
X-Google-Smtp-Source: AGHT+IGMQdvAAHN149Yn6LgRqFI4HzPl0k7Zd7jTCi6NSREDlb5zLOE7+bQWEE9AUu/iFrbJVTRTJQ==
X-Received: by 2002:a17:90b:274b:b0:340:d1b5:bfda with SMTP id 98e67ed59e1d1-34727bca9b5mr4408688a91.3.1763664166234;
        Thu, 20 Nov 2025 10:42:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3472693c501sm3229945a91.16.2025.11.20.10.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 10:42:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	linux-mm@kvack.org,
	shakeel.butt@linux.dev,
	athul.krishna.kr@protonmail.com,
	miklos@szeredi.hu,
	stable@vger.kernel.org
Subject: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback hang in wait_sb_inodes()
Date: Thu, 20 Nov 2025 10:42:11 -0800
Message-ID: <20251120184211.2379439-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120184211.2379439-1-joannelkoong@gmail.com>
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zqjprhhp17frycjn6mfjq7yfbnq56f7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 68DC940011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763664167-768364
X-HE-Meta: U2FsdGVkX1/YFGdyrjuKX53p+cIzS1pZHTw+BN+/5hbrh8DXr/duYXcTskFtBvfCslSFlqizsJWiXPCdj4K22GLPYpS/B4NJfh4+Eo1ELWYddoFmwbsgL+1wz7DjLDNSPS8RQt1OeuxuANJg3Gr+RcPgwefA9sQa8DYuAz1Qgo3HXzWlQ49pJxfQ+CUw7+eBj6OfIH1ti1RqP3zEdWIZXNuydpRadY/ub1IdNmyYLA8x6PQW7Y0kxbaGtgc+KYs4qH6YhE8CA+ASsCbq4ywvzEG+oxtWBx1/sUk77hlkytJHQk/QMKZcgsofHaNdoTQzlrKTkiWX9jgv/E96LBYaqla3CCKeZWiuiJ7d3yVpOiK0VkuZr6YNYj8y2h2t3cS+ccKSnsJc/TUIlrxt0iDfrIbfUtGj+5lruBLgyMIpnYKYBdaN3No/zzEKDSdS4XOU1+3eP5gKji6aZm5GZ91Cq3OwwTMytOVN3gOvPxkJUbm+wugwdoAy5p/rjdhDpz1pddbplndbqZKLj12ddR2ccW8v0caBTX3fPIknyAUe436iGLs32TNzVvEBhASSibn4R2754QOmNOek4IOe2NJnfZuwK2la0oyRV2qFytkXyzlqY/NPJsvkt962qKP8iZ1NnzptOqO9Kd0LP9r/6NzMQpF3lg2h1nK+xDSPcT6H2njcg/nFJ0CdQynKNyNw8h9pttfWWvhkJeASdp7zeui22o1lg7wvUWQnuCmHd3KAb6QwfyV84Dm43iAZkGuhPB6YE7tdJCAIT8GKsa7g4w4Q1WfPYf0ppNn1z4xPWMMVG3aCnGF5hZN5Zbf+P3xZy590wm3jd4+NjFK74n5ZVyLW18d/eJ0aF3ZK32TgFn8pVwo8H/Ht+ELbHA9SzIpQ3KbJvYlgS2UuS511LD4cTYvDn/DAk7TgKB0DkXMY+DjOyUw2w1YNinNENYUdD4eDN7II8IxjnO+gtODh8t3MlSU
 in1wrbJY
 Pe46L8ONCoHxB4Ju2ZwrhfA6ZKo7SyY2OQL9IzgIkZu9I/9jyZyxQKdSNpXQdQuNpL/W3MC6kjeXZ1MiZEYR+GG1ot9n4bllTUau86zm+hn59LRLWgmgjgsBcgbBOL74r9hTczRUob8KlUt2+NO1Xc7QngfXXp4mxbt1ocEf9VTaqbZAu/KqaIq0TiSGm0V8ArD0rtsObt5OoEfVOCIG5NIbZZV7F/6pfvnr301I45Vp8dRBu+aY1hIqJCbatwgKKYKUpFSiq9Wjo2Q/x5jfvwTwd5iYzkQMnHuUtDtzZvXCB3c+lVYaj7KoeBa31Djf6C0Akwi5ml79yWOPANKMoQahzWpStcT2IvIKIR/1sbYGYkOWO+chJyBV1d5JWW0ml0/Vl3SrXzMk9lnfphMnRQF2doTsaQdO0pBHvSdJb7xh79inMqa6RrWpSrkurU1eb1Y33kvSrcmtEj8yj3TEgjpbBYw/gHcBi5dRTuqJzNyg0+6QWMOjbOBkVDNIZr2y6i+AfmVxk6tHfmbjMG72qMMFHzqKy9yvg+Re/qbjupgnAWj4CTDIhgkZUJmfHdF3TP/hD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During superblock writeback waiting, skip inodes where writeback may
take an indefinite amount of time or hang, as denoted by the
AS_WRITEBACK_MAY_HANG mapping flag.

Currently, fuse is the only filesystem with this flag set. For a
properly functioning fuse server, writeback requests are completed and
there is no issue. However, if there is a bug in the fuse server and it
hangs on writeback, then without this change, wait_sb_inodes() will wait
forever.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
---
 fs/fs-writeback.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..eb246e9fbf3d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2733,6 +2733,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
 			continue;
 
+		if (mapping_writeback_may_hang(mapping))
+			continue;
+
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
 
 		spin_lock(&inode->i_lock);
-- 
2.47.3


