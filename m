Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF9FC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A996B0098; Sun, 30 Aug 2026 07:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA276B0099; Sun, 30 Aug 2026 07:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5636B009B; Sun, 30 Aug 2026 07:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0579C6B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 816DA1202D1
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:48:54 +0000 (UTC)
X-FDA: 85157764188.27.4D74C3D
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id CA0D920007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:48:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XRkBHb6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788090532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F6dWzVftJmVxxbOmYyIM0bVDs+vsg5QWyjKFPq8DPDo=;
	b=OCFemyLKfOSTELMwNA4QHGd8d/de3o7gJd3sfjwismzVqQGZLI+mUDj3DI9h8fd3Qu80Se
	4gp/HEXfQkadp0kN1/w5uHryR2gy0rS5JhpiJlmtkQfnEYNXV9PBwg+2C9N63RZXR1kDNn
	Yo7GmY88L6tr1x/U4dm0RPjh+9pKTn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788090532;
	b=DjGFhAQBAPH2O5ZfTezhViGOXNsVaHUTt4ZCQunNimdqSQsT66H0LK+H3ICp6XVyVrWRyS
	NYD70iljxmdhzSFh2ZD8+01p0vU7W0dl+jq+EgWU/r+P+FhEW5uMP5Fjs47z6MdQTtxkww
	90fVY7NW2PwwH8C9+KcgpuTgxUQYMoY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XRkBHb6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2850464a12.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090531; x=1788695331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F6dWzVftJmVxxbOmYyIM0bVDs+vsg5QWyjKFPq8DPDo=;
        b=XRkBHb6DlhS03imQcUjtVBCaYEmP9uPjQWeKa5XRaxQu3ThMuBNMoB9WwhtzuzfC5q
         mRPAfPZnDib4KHciULq5PBRlHnGjWThlZjuS8a6b60398cVkQFU0mwzIDU5S7rOjXdfB
         g00/oWlMImrhxI+6Uu+DQvOK4feu+kcOVIo3vgWl2TsLyub7D2kzejFVCgmH6UPi4a7H
         PjN4wqjTr9Bv/dG/LAaDpLRtt+QqV+5HjfM0c05yDshIAZCbWV4yh7QeGLN2c0vpiwvd
         +eAjn1hWMXtYCtye81Ux4jEgP2bT18cU5fldUNIkjrFulmTHh5H5heDShXkatdIC5I9f
         sbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090531; x=1788695331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F6dWzVftJmVxxbOmYyIM0bVDs+vsg5QWyjKFPq8DPDo=;
        b=MklbhEXz4OeexN93QjaB1jR0a+wiiObgFgIm+W/cupsoGTNHOCf3+r+k5fbbBVclfY
         yDUM6IDWl2/dzAtTQnnP5pufS2PoB/3CVaszAbow7B/azd+CwNkoMQwUeTu5xFzlkWWe
         ZR/hQiM7POm6JOjw4Nb/LEovx8mdVcUmu7KR6B7o/PDC9GwRc8sA6uw7Z3IBeLcJiYht
         aYRp+YnlW85/4/lCLKATucGTqrraT4Idx1aa+D9QJY3NMt2RbqtowVYw0FPscjVqtFyZ
         bdX894KHxkGjtPRhLYglEApBDKvpR5i18mHgbDt/MVSzhcemdp2LiMKUqonAK6M8tG6o
         QMfw==
X-Forwarded-Encrypted: i=1; AKwUvByHwtHUINNdPRrVu83djdAJ0gNc68ilnMeKBFRMdmHdrBij1Q1z8egpOFiYNe/UFuWX3APqgKKg0w==@kvack.org
X-Gm-Message-State: AFuF++l+9duhBd7daW5OLUxgbwuAOvUOH7Ju91F5clVN0V/yGdEw7IaB
	vY6eRdj3nnGQucb/Uxr6IAXl7L1tMEtm+/81iiw8xYmBpGU4wCbg9JQE
X-Gm-Gg: AYBFou1h4NK3JftAlq3UHv0tyo07TDBlmOodS9Ilb200f7VwAYNMu0ds/Q4OrvdwLTt
	LA/z0zcv6QgjTiD54UMPNSfEm0EQ6AJ37RISFj2lQHWklk54WzBDKEIrE2PA3kK2M6Yz1BN1NNn
	9UruaG+HN+bOgb3mtdvDjTi1FiuFTug5E6bFtfdRnxx1waml82msPtxYGvnBN02PArCPm/TRIhc
	PBDzkMT4B3g0qqXXyV6Z5VgRY7Yt7lOPBblV4QfB/drEkHL7wn6rmWGb0H/BSbyGx+bHDwhdZtS
	Db/4NymPLlr8HMnqJAYnPxUKjdo50+QVS3Yns2ZiQliG0REFPIu9ecVL7E1Vza6V60YXN0jtg0J
	fZbZ3ua7OPDs+b5LG3tqyAaAAWNdIxBomxnK40Zz+w5jA0fbLg5Lj7HYKWcKr9R85H32/U8pITL
	e36vS3NJ7lekq3LS4zCXokmh5QdUjQWexxcMVjcXywrSeDnZ5GBoX7H/xms/UQBd9F/6wvahB4z
	bJAX+jQ1OvBuNbokZArAQ==
X-Received: by 2002:a17:90b:48cf:b0:38f:de94:bf34 with SMTP id 98e67ed59e1d1-398da6f3e41mr1421458a91.10.1788090531274;
        Sun, 30 Aug 2026 04:48:51 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea7fa9sm16269311a91.4.2026.08.30.04.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:48:50 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baohua@kernel.org,
	axboe@kernel.dk,
	trond.myklebust@hammerspace.com,
	tz2294@columbia.edu,
	chao@kernel.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH] mm: filemap: skip dropbehind folios during fault-around
Date: Sun, 30 Aug 2026 19:48:45 +0800
Message-ID: <4a4ac0b4accb50641f504f205663435047c4b26e.1788086386.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA0D920007
X-Stat-Signature: qpci7zh8m8oq1fotsbzu5fddd4a7zgs3
X-Rspam-User: 
X-HE-Tag: 1788090532-568311
X-HE-Meta: U2FsdGVkX193gK5uashK02mF++JATTwMzRXeWcpNHmruCZ88ak9ZIiaE1JllN2pQp8BQznq8WEBLP9vYuupa22Wcv3lXgdUGj5XXIdKe9qyc1RmCv0k2i423cKCXtmpktAhn9kM+g/qdtCbSeAZUujy5jBML4eCdExpigBqc59xEU95LXSWfxtMF7a52oDqchAu4Uc34UisJSQkBJYfHYvogWKSxrg7IM4y3vnh5bUx/TSdl6uDOvfk9DFaDAE1wpEsEtbsE0qjMdae6GlCpRg4K2sO+rBpMpJ89YVKjHicOoPxOUkpg/FabGt/LBBuDR2NeQ3kQBIsNYi1b/qcv2/gPeLfvP7nwnflDThHfnj7E1jM5a4kz/d9Q+dwGAkALu0UWtcGyPLziGhG+siSUMq+ORwD8SvgKBqAUh6egyb56qiniM71PslK7fSAXvnFqweVudLrWBC/Z9286ZWG0LkqeXk5zrXAFvyZZBF8r1DcV5I5UqjZm/H9UVPAPqErLcs43YMolEY7pcxCVMidVgm9kIDAxHUgjc6ts7WPhGmOjju4S1goxwooIkmSwY7iiCbaYi8Zh5TUU4Z/T65cePrhNWzblHYkVzomcwNqKbTn+CIpQPoFxbklkgPvO6kVIQMLO5sj7q2Keh/3HBtpNlEDodogRLoHf0k+hm1s1YVYYTYxYvFF8jVBsLh5fd9ZL2bktEj0q/UdyHo9LxM5e3h33WVCIa2mPkgxwhI3SX9xyLhIBhylxMBPW5wvBE/Ts8L49AqfcvFX7P5CdRUgX1YBD4sNEot8gc9Z0ooVaoEz+YsiZ/Vq0NNRuzrYwiesdmE/iGdudKYcDFWZ6NL9DKEqYwymdQDy29yoyvOK2f/tiX/S5Z64YmhR2cHbmkEUEji19JgISlk8f0ER8MZOyXMdEnwr0GUsJCMyt8ol4HjG1EHYMnl6MUms1N/Pw8GNiPS9jfkZOgH2lT7VBEeE
 HP62LjUM
 atmelyngVz8l9rsZmPG4Je9JVQRKEJnC5pyPTDSVG9mlSfCJeVabnq3mHDsndgGP/yjFmARWIxEKXpJ28Db9WoqVfatV4kPRoZjquEFobc+yQlgmdnNGX0tS9YMueCC+OsaOLzBRSGq/8aO9/MpWws6nrvYPzhogsjsYRjmqJDU8DIfN+lMLAcoYl288KaWBiD1FP+V0oPB2IRbmkZLp+qokDV5wH4FG1nnfdkxj0K847xtq07v6f65ydL6MZfwyuNXJw94jl3yBdspjwKWjvrCEi/7ceOZO9spRW2eu71L8ABETnPmNVfJSGdpMULF8z01t1Z21aOus2CAX+hr7fEkOcoouF2JRZIbfM+F2OHfqcyA3cLzZ2YJxPGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenjie Qi <qiwenjie@xiaomi.com>

filemap_map_pages() maps uptodate folios speculatively without going
through the normal filemap lookup that clears dropbehind. As a result,
a neighboring dropbehind folio can acquire a PTE and the mapped-folio
completion guard will retain it even if that PTE is never accessed.

Skip still-dropbehind folios in next_uptodate_folio(). If the skipped
folio covers the fault address, do_read_fault() falls back to
filemap_fault(), where the normal lookup clears dropbehind and updates
WB_DONTCACHE_DIRTY accounting before mapping it. Speculative neighbors
remain unmapped and can be discarded when I/O completes. Normal folios
continue to use fault-around.

Dropbehind is folio-wide, so a fault into any subpage retains the whole
large folio through the normal fault path.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
Tested on XFS over a 5-second dm-delay target in QEMU:
- neighbor-dontcache: the target remained unmapped and was evicted.
- target-dontcache: the directly faulted target was mapped and retained.
- neighbor-normal: the target was fault-around mapped and retained.
- unmapped-dontcache: the target remained unmapped and was evicted.
All cases completed writeback, validated data, and kept dmesg clean.

 mm/filemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..c123de583b3e1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3769,6 +3769,8 @@ static struct folio *next_uptodate_folio(struct xa_state *xas,
 			goto unlock;
 		if (!folio_test_uptodate(folio))
 			goto unlock;
+		if (folio_test_dropbehind(folio))
+			goto unlock;
 		max_idx = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
 		if (xas->xa_index >= max_idx)
 			goto unlock;
-- 
2.43.0

