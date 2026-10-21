Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72E9606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bGJxuEti
Received: by kanga.kvack.org (Postfix)
	id 960C76B05C0; Tue, 20 Oct 2026 22:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B566B05C1; Tue, 20 Oct 2026 22:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BFC6B05C2; Tue, 20 Oct 2026 22:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C48A6B05C0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:42:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3128C045E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:52 +0000 (UTC)
X-FDA: 85345085784.25.B266C0B
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id D36CDC0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bGJxuEti;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdNakqdic+EhTnNZGwTPeLsVaa0lc3BNOTpG5XYOw+g=;
	b=ORrNh9gTTKVq1rw5nHQsDCBtTdKUvqnCZInSzb2S28o76pwcy+kqzdFJeuA88KbTKOUksj
	syT8HtSV1kqvtwmz6OtiOyZPpTEMQHx6QE7gg7j4tupDhrxdnz3fhhH3bMLKUZLIrohcpq
	99PTPYymQhOt8pKRR6iNQE9uglWkYtY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bGJxuEti;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550570;
	b=UkRBTgllfLLpMrAPQV/YoEuII0Tc3RKjyTjtDzsCbnKLMGKWKqDSuc5TB36sdt34T+1CKw
	rZ0p4KHTnhco8uneGTzM6VmfmkjyhrkDPdax9jqm+Hcgfk2zo+t/f34DSZ2WTAdZ3puscI
	2cy2001nT+iiy94TWssaDhjPqdyjmE4=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-36661f953e4so471119eec.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550570; x=1793155370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GdNakqdic+EhTnNZGwTPeLsVaa0lc3BNOTpG5XYOw+g=;
        b=bGJxuEtitpJQaF9+3R7tvjCYjDugezg7v0NwxiW1aJJt5zpQhkaN/uAiDfWxqsFAXv
         2ne3VELqXEbK0SO1edip3SEvHKqw5YJ0LT2yIKBc2V7jJHAGrxrXO/4yqGI58ZBwOli0
         /Irx8Dkzxtw+5/4/jxF9mdeC8J2XloJBYdmZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550570; x=1793155370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GdNakqdic+EhTnNZGwTPeLsVaa0lc3BNOTpG5XYOw+g=;
        b=Epoxrs4buOYKG2gYfmt20DFkiWgWYj5Ja9+1oqCuv9IlSWRNYRrIQm9YMBRti4aDhs
         Ph2ysex6QgTdGPD6Jmp+Jvs6bqbqnhuiHLZNOwj/16iygKUc8js6/uwAyBpPpyTkDa3w
         8hOqtw94k5gfZRbsarncknRXmWIGgTsj4CYzr92uz5VpCeBlRIsv9izZaS555YogZnmW
         70slIPjHn/EKnITXUnsA85kDbDIS8IRe996JyVinwOJ34WHWmXAaS5tah0mVZrWOJdv9
         VUCOGE3ErKY9fBrTv4OgGadR2547QXpcAbAUCrL3krk9ClpKpP3i/B3pMofW8gEa1Aza
         guqg==
X-Forwarded-Encrypted: i=1; AKwUvBw+KYrOZTlJWBl4wm2jKu4Om5wS100CxXYHME40GR4gnYJPx2weX0cDxPsSKztkg7U2CurTNZ38xg==@kvack.org
X-Gm-Message-State: AFq9FYLi45X4wMNghzoRkK8NHe2TBBZVtEjfYrQMBMnFD46Rva1Znjah
	fEf22fWiDlWXkHy1rkhy+cY6TjMsm4P3DR5/IZNOUAZIpfI9VtLb9eJsKHBeoWcHuw==
X-Gm-Gg: AYBFou3KSrxvUPYxRqQHnGzqxU8MVIPYYMX5RN5YYDbVCbRWGYpN7VMuNCsfo0np6OT
	SS0kJTALm/NOmUTfWEjywnfjKRy/FD0tuh6fPJfJDAwKObx/Tyx3kXVt7VGyHwLT6rLPXeos90E
	bj3DwEG0/BgWz2r1ue7T4Fu3jt479LrqAG0wxbW5Ct9an8AJ5zLNETAaDlghOqjjjQh9yohuhJy
	1tdrQTfhXLks+7K4zprSkS5eW7adW80RqLNiMr24Ak64rkgdX7+/xqh2lLf4yl/nF02dy/Fp/XD
	AKHb0+hJN4vrPnG1iJ0kxc3JF9ikQDnKq+TgTb3Y11IU8++uJs6jiS32FSGmTdzXWV/fDngdbWE
	XIDuPl/FC3+g/WfynLYF14HMQyTFKZBxcLB7wktqNqfR72q6GGdbRYWgj1GpoZlXaPS0EYdkC2t
	HGhAF966Uvu0H0BRCyTejqajENQg2IgpZB+aJ+XRiYMPHirDzqf9zuNhI9RuhPt9GZc/jkpdbXd
	o9JmSS2UIJv2BWldwL+/7Sd761+gmzvAhzxg/WbSFp2Qbc6ADBhmDeLlqVFMdXw8CDKwrJWFgxl
	zqTpraQb5MhPjELMt+kfrssay3PtHeJ+nTJ8qyjkh74Q
X-Received: by 2002:a05:7022:f512:b0:187:efba:9ba2 with SMTP id a92af1059eb24-190a84c55a9mr745932c88.44.1792550569542;
        Tue, 20 Oct 2026 19:42:49 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:49 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v6 02/13] zram: remove debugfs entry on init failure
Date: Wed, 21 Oct 2026 11:42:12 +0900
Message-ID: <20261021024236.1787884-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D36CDC0007
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7ap483xx96gtztohhfmqsyxnpsowd5aw
X-HE-Tag: 1792550570-83650
X-HE-Meta: U2FsdGVkX1/QWk9RynfeFjf8YPvTpKtRgIi3ZEDp7yKNqtfD3i3C4s2KPKqIdWziFDqDSTAHAEamPGJj/J3wbN9bEv0PaWGrKoGMZv1ssYB+U9DKthHp0C2Pl323cyZq6mlwOEtMvEokz3e25ekpwdJvo3oca/ebHYEnOdkt56p6Py45ijxBZnAaPZAbj2D9LAlwnnP1KaFvOD+XsrC/foF8J6DZ36SUEP863jJ17N5xBVXq5FovyL4F1YHlFLXML4Zk/+HhjANBlTTMZabTRdzqUpfK0Ovl+PysMxSyFpv0rzGKvWJN9+cnVs1l5D99WtC3siUlk/whdoW31N9V+cJIsyQlaQJomUgYvkKiT7KB86jZZ6oeHg7OP9jFN4R+PfGhCXD/mCZ37zaDiBAv7uwF+qOJWlb/OaEAWDL0wRLJtV5Na+rrjrInsXNsM/43vVZ4/73HNIMsMmhjN1wOFgbGRXTF60aTZ17UqQxU1mzFo8F5/7PHd8ibTjHKs+c+igMTnYvJqPcsuJ2CWFAscvZPG+oK3zSTZcdJZr5SY07JrWBDRjL//1+2Fs4TWtGHBwdFY1LtRkWmq3DrpaNkGc0HS5xSBJN9749KApXtAlarPzlYdjC6IHHNojxuT4ukW+dOl58NPv8Nnjk3FwPQ7ctCjBowlfO97STyugCfbc0S5PcHu0pGU5gn59p4IwmqVW0LWo9oD5TSDt8a5ACGA9eD+qVrwvNcvLt6RyYPkH0kioGmC7Tsf2gz4j0uAcwE1yZq3KZC+mgdmsTIKE7KWx2RlKP7WA6/7FeiKSDR8HYJMYPKjb0t/QyEB9i5qndTilKrwrV6mjUJNdJgLyw8plrYooBWzeJMOf3ZRb/qYB/CI1jY2v1OE53/WTNwb1g0K+DHKZG96LNV8+Pt2XDetVuFtyprkqDfrXcbWg4+KqLSHISdpAoyHM5jBsAi4QQkXeOOGcRTSoSgDLCijMv
 lbrrsIxi
 rVc9ZEjzlHWWrv+DSoaqE28ZyWDnpx4T8/2UxKW67ViYOLc4Kahe1cpEhQQuq5mKj+jE2pjlr4DkaHloLt47HAfu6tO19jYcDUeVRkvIkrsWOQIuNPATzmZ/+C4qoAY6CmUfnme/neaeKgPSK3ImRu9ne1LCLBHxJpUwvxL76ceqhER8etMjdyNrETZLnA3Jz8CgS0piUhr/c4EKCRN4PnQi8qRxpz8ixyjEQnCp4Cs8ljxPJ1r1im1y1OgDITxaiXMjjbO+aufNlThVpEV6si93Y14gYXBHpPWDUn62iwHdH3pkViR4W/YigGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.212.g129ede20d9-goog


