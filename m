Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE09EA852F
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 23:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D5D6B0005; Sun,  8 Mar 2026 19:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB356B0089; Sun,  8 Mar 2026 19:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DAE6B008A; Sun,  8 Mar 2026 19:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32DFA6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 19:42:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC4DD8CEAC
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:42:07 +0000 (UTC)
X-FDA: 84524521494.21.49D7431
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE9E9120003
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:42:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jdZSKuY4;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773013326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlkFR3V+9+r85GbTD5lGukkDRcDlJZS4UesWjQfxFuo=;
	b=oBElr87HmdxGf+P1Q+iNDu+f3lQ4Yeb9CTuHqVKNmDh6wUnEc+CkQhiCOpCJDHM3CT7Yus
	WI2g6iOwzNEZnbmz3lCOz8RTSS0dCswj/n7PuPlibHp44p8P2yXUVWH+JtUj1e0+zEW0wF
	qwa9HgLS32ouUdj6cLGCckTEJj07QUQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jdZSKuY4;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773013326; a=rsa-sha256;
	cv=none;
	b=2K/KIDWejz49ByAeoUjGerjahUVxN91c6z9LzefervQfyeWAb7fnMGsLNoACmMe4azd4qj
	J/IIna1RSY4RxZcn2XZd7HagevqqKVNttKF+JBydLJIJK4dMezQjAku7HeUYlsLcq3nesO
	pZemsw9Z1eW6dt3O1Q7hG/9d0bLGtlM=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb20bcff5aso1088173085a.3
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773013325; x=1773618125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlkFR3V+9+r85GbTD5lGukkDRcDlJZS4UesWjQfxFuo=;
        b=jdZSKuY4cCr90LxuWfTEP3q7G47uqDmrewabmisaib/qwFyO0mIMg9dUWyswfaIfH3
         9qcrVVkjIw3V3mXkpr0wmirQuUcKhIYbilG89D+RmWYbueS1V06Z5O4Tt3Qqj138HXlV
         uFJH52IUBGJac65j7Nu9eFJ9TrqWvlT+R5Y+Ca6NzUbMmlqWsOYT6qteRfMyyZrKzfFa
         pBmhLjbTTtY09AeA1jClK2s0EUlcz5ZI91O9bqDFvdsBhP88LFHYlfzN4dBUW5mNt2BX
         UpXkwXBk9+6ETQRNe5rpN7eao4hlSk9a2UKFyMdDMuxCxc86zyypFoan7W+b3QfOZVUh
         8Nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773013325; x=1773618125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qlkFR3V+9+r85GbTD5lGukkDRcDlJZS4UesWjQfxFuo=;
        b=pLL1d0sEqNgJTX5cm7TqcJ3TEftTaF8QTHrHuUKlcVSwweLDsfUodhrRwkudk4uQR/
         xxm+rFV28WCwdOpKT7ud1h9aOB4E2uszt/L/C9yHAb1aF6d1Y/ntIALSRyeZ/HgyjUxq
         vvIBB0Vz6Yi6bHfw68ysrJ5vUszDqRZujGZCT83XnWSZGqGZM1MRev1l81uptRsKMfHQ
         WuJddwGYzDvy9dU23rvmC0ra183r64a7nNRljWeBFFCiLhEEvwdqCl4HBnzLn2nP60OU
         /Ny2Spfv2gB8tmjjUfD33PFXzui9cgTfYSmYgBxrZbcZav2e7yJXF6p76KfzK3a+jmCa
         YoCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvNqGbGpAlkewlb8ip4IzKAcpvErrDplRI0hFXJp60Vt9/wNBcJX78Rbx47RGn8IBKCaxtZgPCTQ==@kvack.org
X-Gm-Message-State: AOJu0YwKUv3ZbzI2EeJjSAKzY1onPaTk392bzNRTkXnpOtJMeanCq7Y2
	wdbQ1mk9c0YaLCPuFvoQBl94UrKrAvf/QTZGud9NvP6Sp6Mx4OSxwbA+hZmJ8GxsWpoh8C5Wloa
	7jmXt
X-Gm-Gg: ATEYQzwiIhkzEoenHgJZTeMLSAcRVaGCKPV+j30aGz2J7rCAuMWtDHSGDWM6Fea4Fca
	xn4VH4N+xgNMv/vvneidN0BYXJ6ZDdgiGGkvCVj0XeDbUqoG7skAXlrvq8+XGcuYu7atL0h1tJj
	mp+2/+nc4lYxCtlMZlrDX4y/i5CTDUfb4B8HUAjYqOnjtNVky/jzqCtPsnq94GIVxoKEg8zWnds
	loHSBpyeJspHdHrtPDB0KV5REyIARZmW7MnMGVD54rMeewR3qRTzvr/xfz2+Ill+JZNNST5J9Li
	ZReHHjntG3QZw4eEkvNffKRSaU6yTWIc5Rr8rN2GLX+6OMexRcmjbcLiEMubIJJsUcS91TW0ptt
	ChxIJzZ1f5j72zyLSpsVtYxE+XDAcrcIG9FcY7bhJaf0L/PazUjtgOMIg8VBF3jiE5e00Gb/Nkl
	YiHrwi+7vg6REYg2eoFSlKeaxDIJaRkHGVe9iigEc/coBXM40Bc4rTey4yqgm82nvo51gP4vsOT
	nr9HSjbfwbu3Xo=
X-Received: by 2002:a05:620a:1921:b0:8c7:10a0:167d with SMTP id af79cd13be357-8cd6d4418f5mr1162364485a.39.1773013324993;
        Sun, 08 Mar 2026 16:42:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd81aa2eefsm211312385a.42.2026.03.08.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 16:42:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
	akpm@linux-foundation.org
Subject: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Sun,  8 Mar 2026 19:42:02 -0400
Message-ID: <20260308234202.3118119-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <69adaba8.a00a0220.b130.0005.GAE@google.com>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE9E9120003
X-Stat-Signature: yuo4asxbxqk9iuwfjdy3ewy64zki5wdn
X-Rspam-User: 
X-HE-Tag: 1773013325-954786
X-HE-Meta: U2FsdGVkX1+q8ZpQ4pQ5NhrxR3F1431MxbXI7Gbq4JhJftB0S5Jcts3cI0lbPOvhlzpz+987VI/sVUhkfkXIbt0ZHY8r7vRMKFZ4O7gsosFVd6TQmAMQL0ODb9rTrvaCfwJlQr0B9ZJnZeaz5nI6PC+Z8UykaBttOtE0Dw8nvnW00Qf3zZp5B0q+CFJiv/isr5KdLKeK2WHxFD4gBbUEQJTTKtRJvgLfsl6j0FTBMPgVuFtZLnHrW/iQ9nOe1LqNQQ8aAwwB1rQcJe/wyx8nQh1HnFMKBkYF3DjIWwlQqzYYIIzQ4/HuK5YJrAZwQoDw9YyeBrHYlEfuvx4gtxNrBv4vYn2Gtvhb4Ihpm6S8KP1srAJNY5wOj5eQozNxAo/FXyjqoYTck36houTVSdIKWNwQCaPoGnykOv2FPURIJidtDy9aIIDR29NcKVb3ziaYzyodjFCm3bGOnq7LbT/XWZonxjD23c2tGuzA9KhGZjCOuGW03tqpP+teT3iqUKeP65gsGTH5OKA/XNIay9kYSwdWWJwDfM4c9wR6ohChmvcLhYN1r8XslzUrfW74GWAm2CMrFdxmBD3tg1JinYkpiMRfV7TvtaZAkicJytVc+v8E+RQgt04bdw4JZ1xHlCt928G6wXiz9Yf9e5HxOn/pW3P9iX0+u0QRMKhpOBnyv+V9l+Z2wN9N2wWX/CKRTopjnwoI05Ik9I86UkUwDVuyLnpd6mPYAXvfk/iA5tP0R9mpThIuem2cwWAE7+5rRMnc2RBGOjr2X5DAngcqO+FIdI2jmTMD8H5uxRPcYjv1PmVrTcARS9NpdIS2LUIyRLE007ops0kaT4QoF4vDiEzlESpniTpmMZ4DsJQSRzg8xFKVd9ocVdkfVB9LtixpYY7V4SPuVivp9eMUk0msR6jVHVEgdYEkwywV4UilAs4LZKBe9A9H6kk6kepCPQg7oF5ESMxObsGPHtT9uSGirEO
 5dz+bCYE
 M/4M9R/jnPTBdtKlCL5auzQ9hMBGjuBPD9BwCAy3A2q4IiHY3v8iVjKyd8ceaaXGUBBf0WRu/Tmkgv7HwuxeGfn6l/K97nrHMEnbY5mLyL9FOJnymOmEOuVsdRkmxOl/OA9V8nvK+k1hAmdBfTIwEi2gIT8PIqSnMY633YjrnPkot0mopURIA4Ls04kWDkqcUKA7ae0np8I+iQIoNuFuWMrmWZ+JFVN21q4OAo1dLilaAmUKVMf7OeOVyKczs9Q0YY/kfglwiBXtrdzvWVe2ATBkTuJvDdlg7KMdbb2qAzNXI3yuOByzhqyp6uUNHrPODkbhcnhcMgPtx0dCMxB1pZimfJcibkFvg2pTxpXpdGM8ECu5VibfUzA7D+1uVBY0+hX/r3YmjtPfMsZdbItVvvuj/pxGhkuxwoPDI0Mi9pBa2uz/vRF/eQNNylhNRw9qshNddLEA4s7HkuA+eKSJuEOZngCw6Jzou9IqacNdkHbvN04O/zp6C2PzoEaxDEK4fXWHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
triggered by create_strip_zones() in the RAID0 driver.

When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).

Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
__GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
corresponding kfree calls to kvfree.

Both arrays are pure metadata lookup tables (arrays of pointers and zone
descriptors) accessed only via indexing, so they do not require physically
contiguous memory.

Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/md/raid0.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef0045db409f..5e38a51e349a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -143,13 +143,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
-	conf->strip_zone = kzalloc_objs(struct strip_zone, conf->nr_strip_zones);
+	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
-	conf->devlist = kzalloc(array3_size(sizeof(struct md_rdev *),
-					    conf->nr_strip_zones,
-					    mddev->raid_disks),
-				GFP_KERNEL);
+	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
+					     conf->nr_strip_zones,
+					     mddev->raid_disks),
+				 GFP_KERNEL);
 	if (!conf->devlist)
 		goto abort;
 
@@ -291,8 +291,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 	return 0;
 abort:
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 	*private_conf = ERR_PTR(err);
 	return err;
@@ -373,8 +373,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 }
 
-- 
2.53.0


