Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3071C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8805C6B0005; Sat, 27 Jun 2026 20:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858046B0088; Sat, 27 Jun 2026 20:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747426B008A; Sat, 27 Jun 2026 20:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48D016B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:43:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0BEB402B9
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:43:27 +0000 (UTC)
X-FDA: 84927472854.07.85B774F
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B8BC1C0002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:43:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oy+i9gxe;
	spf=pass (imf21.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782607406;
	b=SxzBAKWdfPgVJRIDYyzcsYAgQQntY0Ly7JGSYVavvzSwwzen4Kx3Od8ih3OlaqGGUXILLO
	EPDukxILKo8yCKd+e7Ife/DjFhwnY4/7oSx0vdlfQo7YL6ixH5tlvwlO4fcgwsY9SMaIP2
	aY5iPBtm7/PM2MGzR+tPbxBkXSFmKlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782607406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P/K0oyqX2HpaNhJgmG557ds5Wum+B6nCD3i5NrtHbg4=;
	b=gwqmpNEVRWwakqxzMq1hkvn7LH9qVyV4p+Oc5E4h5iJxD132auTM6Ub8L/t8rQWQje0ZKE
	lDomZB9oJ3ucA/SyBxc8ASQeSAm5cIvs05VjV2bfTKWQd42u1gFF2Zd5QQP8UH0260Jcdq
	X8Hosxe0w/ZJvJMZRLUDpGWtuAdE9v4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oy+i9gxe;
	spf=pass (imf21.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-472a14c9965so146721f8f.1
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782607404; x=1783212204; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P/K0oyqX2HpaNhJgmG557ds5Wum+B6nCD3i5NrtHbg4=;
        b=Oy+i9gxewwwv0XuSakzIpT1za2yKxQ9fZvcpCzjC47/ZynnYNgMJGI+BvxYj7GXINi
         eMqPygboEiIYi0frCC7W6N5OhpJLNXrabicirmDcv0QLpxAeEI529h10j2HdqMPIx8nl
         X0wvlT2FCj2NnM9ptwEK6GOuimTcI2bYPpjXd8o+pvZtwjs39BzUsl/diLMLIPLpvdHs
         xWN7BtPkBHuMrm2tTLKA097mopvtso4q3uLNfaZgKAa/+web/MFKsBy3cV+Bo1EaNbnj
         AztydgKP6oTGNk8QdaW2noeCAJvJc6KtiP7W8hGWwFIxydtdrvGKpki4+RvZQccEsER3
         OA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782607404; x=1783212204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/K0oyqX2HpaNhJgmG557ds5Wum+B6nCD3i5NrtHbg4=;
        b=CuZIl20kdczPtDBoZr4gb4aEGemvKGFt6XZ6JW3J5MeQ0GEjmtvlsLaLJ77Pd1nvzF
         NkjzJipq/KK7M58syDa8ltmToWbmu2ZRAAe+L9vWdaQJOihPrQPaHTv0mscyzmB/8ost
         hE8NcD5SmchaAZFjA7RVMbK70BiAjsQKu/NWae31Xu7KNJl1+8ruC9q+s8J95qn8GdLv
         fp55ZhIfnnBWphnd80QpYsb3kykSJqVQLdKDodGNX1eMA0BBj+c0aabkPJWaAIrenJBr
         GiDdtcQmWdALMQXL8Wsza/9oYeB4aFoSkaUqYQS6MHSP09UdOmy0tb1bzhAps0xgY18Y
         zEyA==
X-Forwarded-Encrypted: i=1; AHgh+RrhqgcZx+ltOVWsTZ/1HBHVyl3hkEGVTXlDSGT5CEtIeT5sw4wT5XmYzAGhtVuMd0/kjac5FXhdDA==@kvack.org
X-Gm-Message-State: AOJu0Yyjz9Og9R+ysTt3tDROQX83GX+O8qk3HSkLgJ6N7NxgfqMeUYeZ
	pGSODpFaLUBR2G2sV4ingFxJxxyjT+Yvinjr+D2iuo0ZD30MTUs3tGTQ
X-Gm-Gg: AfdE7cmQaxkdI6aIa63rruD7g4AYWdHyHMnZ9SCEGlZfWtmu3ZhtbwRocZDO0CrfVU4
	sMeGLC8aDgzkW255xo0ZA7dLRrMS/ZNz2yNv6pyHp83GTcnMRVESjOGcROz4QkfmoFFVHfwb3a1
	v6Jus5AnGB+sODWFUDs3meKJ4iCgJYXnR10FltBEBT7DIxLb/3WX36FG8BAzilezc00SEkUql3l
	DmvhJDgLczksvRGWybEYML6UAaJfKMTfXZIv1xJDFql9QYrs/DgIzeJmlZsyowa3pfW4fZn4GIO
	XnucqH/n3qYkqMKNqWDNJmaVccokv/OJIvojYyI2JF1MKr+y13Fb5JYP+g43XSgn7kCxwYFKczg
	6KtZTbOo6q5NAtl9lTX5YcTX/DGjuE2CCEBPjDSfnrJqnfvDWBut8ZfA3mvROQk55/3Q0JLfR70
	fssIam1zQNIQf9XQpUFP3BneunUQ==
X-Received: by 2002:a05:6000:1841:b0:472:22b4:fd55 with SMTP id ffacd0b85a97d-47222b5015cmr3741851f8f.13.1782607404584;
        Sat, 27 Jun 2026 17:43:24 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-470f55acda0sm8612218f8f.23.2026.06.27.17.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 17:43:24 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] tmpfs: zero unused folio tail for long symlinks
Date: Sun, 28 Jun 2026 02:43:14 +0200
Message-ID: <20260628004314.27370-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B8BC1C0002
X-Stat-Signature: baerxjs7o46mgogt65sp6eo4gqp1hjo6
X-HE-Tag: 1782607405-838007
X-HE-Meta: U2FsdGVkX185xEZvsYSPEKS0JXbt96DA2FQ5O8Vre9/gBeZ21q5P7Za/eArBSqAWVYLCh3fhaR3LkBfoFd3LZioRUixDtCf/ZsdfhAM2qkQPXyqEXFI9J1LDmQPOC+kjYsdwkg9wavTQ0OYycMX6e/Z7jX2s/t2WJDuelFP0vtCfsauwf2/OxOU0xPMY+YZyyo0SCMzDjppdfukNFM1nWGhp8xJJHsjZnqPVv1hDe7CxxmBEmAvQirw/kNIZuQlvKsuScn7B/j/96RI+zV2Q70GQISdeMwqDAnc5GPNkUBb/i50eOHZEIgrAsO+q11GqMMLDqD+mNX4JM4ATh6SyqcA2cYLYFBlwO3DEzVAKvKbulVX8Bg0BH0+cYgiDXPssGYySLpTLIRHtd3ayBWt8tVgGnDbEsZwVuqy2LWt8BgF8rPTSyUXeMocN6+RQ81dd26zReRLXj2wMVAsnHkuKbjbjDtICcxe0zY2bI6AEBrHom3KB1HbzQQJscGAVig6PkOV7UT0E0L8tvzh2VQ9Cb5YyXkdKuSvfCUnzXDVhH6LQhMDKgN8UCR+9dV1dVb3Y6XRumInru8iQ3SIRwTAVhirJHjG7xKSdbgxFlwofAJ7hHGWALNIaphoH978K6OEYPlqzHtIPSC13cqKV6hjjqQDmBiYRT8ZhZJG0MrqM2Wvl7FT/ssIDjSONKkDW9ZXQ4n3Yksh53vTyejIL+UAWIR6YBHYpDc8AGvi9MKHxup9JcUgvsGQQWXthwdIf4922XIJPdKg1vdJm2oBVzu4XG3motaguHLWVGJE7dry6PeSOeDdWHm9Xm6ATcDNsCU0LtG5kh4fqNdRAXPNlTujfd/XNcNVfU0wVbD2qng5Qv5WSKC18ZZLWU1+t3EXEbTwjMRKOJxdK/vPD/Gc3cC8x4YXN00pbe2t+DY1t24UqQ4ll92eLTWWw6t2JBCD6ThaeduyQM7JlN/IXeR12vie
 yrqrR5Xs
 8ZX6D+IsqMQjrnz+Oi6Qu6CzdvHIcs/+9+yoOlQJtetYkuxN80cl19X03qedjQEqlBK81igrWGUV2FA4cghCig+bCq8lMona+03xbVv8isHk9KWApTMlBkXIT7vJGb/5Q4zVMRHhZAV87YL1odw4EZsx9Ec+O5u7xPQbpdjyrhfHs7PXLNSzP6m8UyrqlrV6/ZzsT0jv77mbOV1mniRhis53r9mHu51uz9YAF4sXKODmyzLhZq+/r9T7q6acPU4xKf6fwgegQKiNvMayLQWrgFMRKTzAhGSfv+HCsugc+SVw0P272PK6n3MaNlWrKHvAEGNCq4wk8piBeDbHaY99r57O5HJnQ0+MA92UQuTJRAoTK4N12NHOwMx8Hn6tx3z5ghi3WAZ5une+fdEwMe2Q+8Qki5N5XXolRHS6Oa+XGL4g86FUEbqkwYf9Rwzh28qqR/r3kieU1dAHgRUxke5XdzOynDiOzrWq+hZ610rkzDUL5JQQ/Wq7Y7h3H0VftuPjvkLdm0d1Ny//RZKIiXERgF3MwAWzlgbe8Rz9QM/cyacG/Z514XZCwuKk7iyDm984h3iouf0nQPUmHciF705OLVNi63kThDf9FAZDlyKD1TsuOhUFfbnGoaI0b2X51yzdtbEl988qUPy79EIgI7XdWn2P2D50wdHDhcB/6qII3Ja0VSkxsPplOLbf4hehReiwmADBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_symlink() marks the entire folio uptodate after copying only the
NUL-terminated link target. The remainder of the freshly allocated folio
is left uninitialized.

Reclaim may pass the whole folio to a swap compressor. KMSAN observed
sw842_compress() computing a checksum over the uninitialized tail. If
the folio is written to a swap device, those bytes can also leave the
kernel.

Zero the remainder of the folio before marking it uptodate and dirty.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..b06c1ae2f50c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4057,6 +4057,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		folio_zero_range(folio, len, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
-- 
2.54.0


