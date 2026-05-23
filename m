Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDDDCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 13:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32CE6B0092; Sat, 23 May 2026 09:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3986B0095; Sat, 23 May 2026 09:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D24A6B0096; Sat, 23 May 2026 09:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 751CF6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 09:05:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B193D1A0B1B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:04:59 +0000 (UTC)
X-FDA: 84798704718.10.A1EA188
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A181A0009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:04:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Nt1BkCAr;
	spf=pass (imf15.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779541498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qqdwlNXYZJEyRP9+E0HpJHlS8fNjZ4FkiE4ZdDF/FA8=;
	b=BwOgelfYUYp+a5qiJ8CwVDtPCiveqOMSIHvFi/UFihR1FhXyOrBc3UBK8yHxPn3ckeH4Xh
	TT+szHGOQzE7/jKdd8+pq0AAIYakBuic2bOzdilh3UxsGwmkv7Mr2tFoodsu70lBmMZNd0
	it0zKcxA1g4+YrK+QazQThzkrJCnHBg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Nt1BkCAr;
	spf=pass (imf15.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779541498; a=rsa-sha256;
	cv=none;
	b=ZaxyyWSqPD9O3EZccnG8G+YDARqZsITC3ny5Hi2vwVitbXD2i5LdiQpz1j/iYnIl30+MVw
	QMgekLP95D4KI3i3FxESA/QH6q/0bwKeCLJNdg9EyoswPCdH3gUkglN9qcI5xgsROvuUSA
	HVKZM01kkJ3U9vCzRnRuFApYELnOaIo=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bc85eda6b6so41540645ad.1
        for <linux-mm@kvack.org>; Sat, 23 May 2026 06:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1779541496; x=1780146296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qqdwlNXYZJEyRP9+E0HpJHlS8fNjZ4FkiE4ZdDF/FA8=;
        b=Nt1BkCArmFHQXPP+e5Ua49YDL+Qe88sULqddjVRYZKuPmqfoqoegog2M46+FSAwVpf
         huC1g53kSfAxoJhyPMdYiUyAdFBQtHixUd+RSnvYrMWoszJJ21QmDadiJefglevTY36U
         3Q9iegEsh+XOJ71YcDmp/OpiwD0h1kJD0iRXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779541496; x=1780146296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqdwlNXYZJEyRP9+E0HpJHlS8fNjZ4FkiE4ZdDF/FA8=;
        b=YQzMufNOWzS8jFgwynHP1ZLNtpWvECEg1yDy0ynm03t4NdyH7NKPop3ax0+ZQLQbz8
         5e0EtiV1q0L0Rcq3cUK2vvbhPh9wGoB5Ve5bThJl2QQWs9hFlr3uJsoKft7EgoWOeaPX
         LnxYKJGFjNVx4ftZtgxxo4qWv4mOsrlW8CZauwzd0MtHcwYgMLPEof3Q1PnZTqADIqBU
         kML7QB/J/ZLHg6TcK0LM9U8P1svJ5kN7VO8ESmqMw8stfvyTbK9pFxx4AZiaInlOrAeW
         5ZSshbOd6yH3QBhJBYPT4sw/vXngukZMHuuf7A0ULMh9gKE6hnuGQyfcHP50cOZMPGKj
         i7CQ==
X-Forwarded-Encrypted: i=1; AFNElJ+itxpfYIzDwWTW30n/JkAQcKJVSRIwuo2e7iSoGCZe4bTnPe6mtUDZ+FZAr3IpioFzaBxKLegR5w==@kvack.org
X-Gm-Message-State: AOJu0YwvP9/dFMwvwtVAUUcZrXOdbHBfYscPMK1dDnYyhQ4C6v4RdUwf
	unmmTiM9D9f+3z14zOl8xIOJ9phDI65A5ExbTju9QizwhTOcOMtHkU1KCRGwjzcJnvU=
X-Gm-Gg: Acq92OFhpwApRr2bGcmEzFQtNBH4oGoqHdln5rCamb+muiUUFC/K1OyH7jOZfoJxvTA
	DrBp/m+9OdvtLb6mxlIwupeulCsXN+JwLhi2H9O5dToQG5+YLsb1HMDJDsS/ynfOKChBUy6HM3g
	IZWVkvbto+oRgm3PNrXNXtyaHGrjPrYOFjQgsEujjga5lEAR3P9jE6U/bl3T9JLRlHGtHLYgnMq
	4Bh5zWFZqJIOxWAdsn6NMgO68F00FfrI/vFiACf3OhUK/M3wYDCxQcgigMDxAFXkxGesRXRFwWL
	EarFMu/LxgW4aOSmrIM5ChDiMqyz5kdeXFFW34mkqqWCFDkjleGclVXuZhzyaHm2xyTrr53CYAi
	lyX/BhJsP/BwMYIA1A4lOXnRFgKmCBQ4mMVKjf/YSB9IOPDqYsz4TgOir9/AC4e0tIZEt+mc4dp
	CEiuxty9H2/yYnKmgZ9opLqr3nOiLDDNBBOnMtD6ifz/SpqIxbLiZtmTXLSEElLPYtiy2dRvCjI
	Su85wHte6q2HA==
X-Received: by 2002:a17:903:19e8:b0:2b0:6e4a:32d0 with SMTP id d9443c01a7336-2beb06a6053mr85007925ad.35.1779541495768;
        Sat, 23 May 2026 06:04:55 -0700 (PDT)
Received: from kinako.work.home.arpa (p1620034-ipxg00d01sizuokaden.shizuoka.ocn.ne.jp. [122.29.136.34])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2beb58c3016sm63173795ad.56.2026.05.23.06.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 06:04:53 -0700 (PDT)
From: Daniel Palmer <daniel@thingy.jp>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Daniel Palmer <daniel@thingy.jp>
Subject: [PATCH] tmpfs/ramfs: Let memfd_create() work on nommu
Date: Sat, 23 May 2026 22:04:45 +0900
Message-ID: <20260523130445.1101818-1-daniel@thingy.jp>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A181A0009
X-Stat-Signature: 3awo4oei5nhqyb6opq5we8q1x4xz77rb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779541497-188201
X-HE-Meta: U2FsdGVkX1/d8KuqLVByA8H2p7W33d7+5gxgY21HgYKnZNw+yVb/fTrUDemB3OTS2wNf6wlzxWPu4wXKTZgTDYmlg+NkI/hjmShxWpSVvJIciDMJ/cFzYP1Eh9yxf1f0C93vYkvAUW8VTQFcwgi4z7KbHjJ1o2vsyndgC71qaJRKjUCna/G1QnoCwpwjsw8YrXJE8AP7n+oXfs3IYMN4JqxNVp7UwUZQUm/u9HXXj/gaKfvwmv5JIKf0KZPE8TovA7c3idmKKsuimeeCHE2x3bzBraTPHsDEy2Ut9ia5vq6+qnuXfq+fpV9sqK7Jm7Qx8kZHJWId+VA0PBujs4Aa1OC01OiiKDHSfjeXNaSUORscDq1RRLptlI8MbjRYcJBw7I7J8+Q0KfuGKxz3BfotDpxBq+SLT5mzex1PgTlEwxlbb9ZqUSo7KXSj9KuTiTgizEB/4R2GUq0iB6C+UB0cu5Ihow9S+tfvkMgywCUNx2DGAdXY58GoabWS+fYzBGXly8HiNu3nxoTtXYZtwj5zFmQ5ei/ftUsTRupX3aeg8sUt9+L7uCvU6nkGQvENTBlLpFQCFtqH9Zk/Ls3kCYRAiQGeH3kYe7C7AWwQ9BsVYbAs23yy97WCad+pjvlPPl/sOH67P+yTjgcIOCmNSYmoGOcvASq5qi2o2tT4H/kPbohyGBjsSNMVXUuIjcsbvYY0VfsR+cmeAeslNiqJ6AYsugr7NdMdxj1pum1QlNx3Qz9XMC4hE0VVk0qu1B4330Lvnff1qiPaqD6EDgDoqeQHa+E7emyZMhctCTrbLTvYifKDhW4gBBgtgSEPbRqOXsbP8cV40awwiJnsG/Eb6OT+LvD8Rf8dsWwPnZWRGd3NSLDEwmUUY2a1iKHS9qqjNPsm6u7gZTyFNtklgv8tvOAqE5+zLApLOJtCEk0p/6MPjfty9kxVyDgFeUrIBRV6DA0QxA0tSU7lIz4Z394LDHq
 TU4tLZQx
 0wE3Fe5wK+HQPqmxwGvSftMUCcarLKOfY8WnPArx/WXM+hNtvb6WLXlJ5qDVWPNg4eOWCDkfGbpQG5JkuL8SCdVecQxxmTvNbrOCUpcgUYoUibCDB0kTkjXIN0J96RYosgbTjYyJKppjvNm+wwgQwbASaaEYh0Pz/ZiYiTTLeHONTlzn9e5Blx7w5IQ3oydi5VXKyAY8EkV3dm76bPNJeFJTISwtXfo4hPCj503aJ29rl0bGCwFbfCD30zKoR+0slv93q0zRMWZdW9ebPWB13juY8hNMTZqBX6w9xLUCO3i7phSu8RyAGjwOnq8ekFhxDH1lNg+Luy8ie+HxFmHUGzIdweSOY7SOxFHRueas+N6NznNXAMRZlFP6M8eIIgTNfO0tsS0IZOo5C+OpIvyNX45oMSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently trying to use memfd_create() on nommu returns
an error with errno set to EFBIG. The manpage memfd_create()
doesn't have EFBIG as a possible error value.

Doing some digging this is coming from 0 getting passed as
newsize to ramfs_nommu_expand_for_mapping() and that getting
into get_order() and there "The result is undefined if the size is 0".

Whatever comes out of get_order() is then used in the following
logic and that results in the EFBIG that causes the syscall
to fail and the errno in userspace.

If newsize is 0 there is nothing to do so just return.

Roughly tested on m68k nommu by creating a process, creating
an memfd, forking another process, mmap()ing the memfd in the
child, writing into the mapping, then mmap()ing in the parent
and checking that the right data is there.

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
---

Really not sure if this is correct. It works for me but on
nommu a lot of things just work because there is no MMU to
shout about badness.

Maybe shashiko will say this is a dumb patch and explain
the proper fix. :)

Also I had almost no idea who to send this to from the output
of get_maintainer.pl.

 fs/ramfs/file-nommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 2f79bcb89d2e..fb471bf88ab7 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -69,6 +69,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 
 	/* make various checks */
+	if (!newsize)
+		return 0;
+
 	order = get_order(newsize);
 	if (unlikely(order > MAX_PAGE_ORDER))
 		return -EFBIG;
-- 
2.53.0


