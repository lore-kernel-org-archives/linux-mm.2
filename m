Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22100C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 13:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E0C6B0088; Sat,  5 Sep 2026 09:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADEA86B008A; Sat,  5 Sep 2026 09:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEA96B008C; Sat,  5 Sep 2026 09:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3996B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:29:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ADE1A4404
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:29:52 +0000 (UTC)
X-FDA: 85179791424.17.E7016FA
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53F2720008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:29:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GLK3tfNy;
	spf=pass (imf13.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788614990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4u0GWyaTeRSvMtQ0YnsmqSEps2foZyTtNF0hC2tn64=;
	b=LUBNdFc6EDJA51uexSKzlIa3+6OFbhfNnNDJiBlfphOf/TZCKfyVJOUfvDpuYqmK6KpZmo
	FbQ1oZOC6Bw0Cb24dausZbqS5rkUKfnNuRIbTdGl5GgXWeEhdVBIUETALo1P5UwFTfQylN
	Aw9jIEfjszhsPQLm2L03fOgCwwndEfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788614990;
	b=eEt6DMvhzk3qZaIO6SErJazwhO7/3EyW95xibeVLD5HSuwhLi8pcUHKBME7nF7HokLEJGq
	WDUsdZqkmZAGYGAcurIGvSMPydyngglXUuqOraUju7QQEhxUzA59bULey98mSPYcRVn8mf
	01yE2SXmRapMVCNPBFAb6+HzAHpNZyA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GLK3tfNy;
	spf=pass (imf13.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc439bfb2d8so1314214a12.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 06:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788614989; x=1789219789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4u0GWyaTeRSvMtQ0YnsmqSEps2foZyTtNF0hC2tn64=;
        b=GLK3tfNyB4kKPeVRUmlPIB+Dfg7Q7AmpFDFYLFrGYhNV871tQB0oXg6dd96HKllbvR
         dlHLK4e1qhAMtDwgxZErU5VWLpdlnhaj6CSGl1XZMREXal9pdEv62GlXTlnYI3B0JeyD
         0qu/VFoHdgcWCrN+jafTWfCPdN9KxLuzBdDPvhG5SyqwP8ty+nWzjl9fNSK6WZVvVH1I
         RnPmXrh2MPp/JrzoqVr2tMWxPLdObqXPi3AwoYUys7y+XwlEIMzD8NDKi9Jb+AVDllOh
         1gLNAVl362HjGpnzZsV82QxCEKBCfS28GmQI4oVuNLQ/n8aOXaH+LoSFw6nMlO/3xCyQ
         tpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788614989; x=1789219789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4u0GWyaTeRSvMtQ0YnsmqSEps2foZyTtNF0hC2tn64=;
        b=P9a2lw28m4OfCaf6BoGAA27jwj7bRLKso7FZenLUnLvrE/g05pMQZ4sPGE+bHNbyle
         VQ8B0pCYYylQ/FnImqtEdL5O/m3yco77cdoMvLXy86mGH/AfgyJGBJLbzhP+qkSlSGDP
         IkkvW6xGaZp4wXrrQIAV/TtX67gqvrW1D5ANYlniNtALwc6ycbrSd1ssFMpmUDU2tOE6
         j1ysSZo/kIdCOTTKr9lJcN+RHqYSbVzAEpOACJNEGM6RsbXDj7zyN5keC2c8I4ZOop0/
         wMPsxs+pdCE4AIXGqwSEwPWJ8AL5BbYIQyUOJOHwh0JnjUjClwY6rTZ0r68gyL8IwQRl
         dDSA==
X-Forwarded-Encrypted: i=1; AKwUvBz37fVAl6DCEp7sSgoeDCx16QhgIeaTcnKPVBYrDZ8A0W83Unb5USpRWCMtrg5Q37UyW8Y7r0nSXg==@kvack.org
X-Gm-Message-State: AFuF++k9stVpZ9GBSHyB5Rolcb8cOydfPD/hNlPqBFMln/WczyRBoVKg
	+gDaaKJTKzO9XhE+riR52fVFv95zRNmsG3Y+jfkkPM1UeV1zM3lyRzDX
X-Gm-Gg: AYBFou2xbLrFZDfD9vOASGZsmq4sDYcU+fHn/+iQuuEbh6a5yKIt2BkyRbuU57ErfAw
	uaEQUAfUgER28DTMUuQg8l3JxzdzAM10iOyjku0zTQzVOmp7633i4zoOddREH3suOiloGeCs7u5
	pvxIgr6fyBDSSKH/aEF7LeCqz9136OgP4iJYoleRP/CdS3j5lkJWpptWD85jzqp0PYFTIZ5BDiX
	RmHgUUUCa07Z4svA4tQpDSCwz0qFANsgp/ZXoXmIngszbtsJA+UBiKm2jGlu/I9L8ftfcj2OkxM
	mgRRkDYhBP1ZewdpDhWacixVeW9v/EiJE3KzKqpmX2Q0ttqkGh9HtS6Wq0DA3CsoFVxJIva5eez
	ii7m437IW16uM17B6apQ6ehEVxlahc9Ay+vsG10/TO9n26ohJg65stHi5dkvM6sRIBKPWvBHchn
	y6PQbMbdbo9Na8YP7JGIL6LQe7WO1zOdz8SOfoQEFBNViGrIzclRv1QoPZiG814kFfKuC7i70sM
	SVMjCxgUd6y0W+Zd5EFTQ==
X-Received: by 2002:a17:90b:4d06:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-39b2614df74mr17583898a91.1.1788614988974;
        Sat, 05 Sep 2026 06:29:48 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c397b1sm16146499a91.8.2026.09.05.06.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 06:29:47 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH] f2fs: handle NULL kiocb in write_begin
Date: Sat,  5 Sep 2026 21:29:40 +0800
Message-ID: <5fdd4d960a6b47ab7cfa6ef0f44fb575fc45d1ca.1788611415.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a9bbf94.a5e650b3.26d8a.0006.GAE@google.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <6a9bbf94.a5e650b3.26d8a.0006.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53F2720008
X-Stat-Signature: bszzjhtpkxka37gbwbpkrq9tsjxkexf7
X-HE-Tag: 1788614990-509125
X-HE-Meta: U2FsdGVkX186gg4aktmfDDhAYH6ATWGpFugC16NuiP71+lMxqPReSWEs+bncGV79a+L5GSZmHHAkLGcl/qFeoHOP64PXv21WIimAeCCoMwvuDaaJiA+jdIW11JRpdYbaZISXujbqEicGy5zBLH58627F+jriQvWBvZmFgwex5aeiaUk1qpMKMuBtvBrF5JzH+O6xSzdPTa/HpKYupbuPQz9+sqOh7MLgetTCK5VMreiJShCk+HRDcpCm1lCTYM8hlSHU+Ka872JN+3p2j10ufk2+yfjzdnXkLI/ckXhMqLgjjHJY0VNJDUW1S5RuBlz7qQ0KEAbBGyYV1ZMDB1s2Fql4+8BEg1DvQJyKH1EWoyT853uq/FaH/SG1vECClaVp1074+5a3wZawfEXb2Iqi64cZ9203O/P5X6fdjOh6BGMMiwVBEPHSQFnlPS4nN9R+3xqPz3lCvgJcQg5Pewy2kWIXeprIIJsEgq5LgxDfG60vv9sOJHJSWXtIFT+8u3W0WBfa3PmxyOc8qiYoxMB+LvqyzdgO1wT7tRNQ5B5xlyrwvZ73i7SdpmcQflA6E4tIn5WsCf+CJTcdGwJma5glBcYyoQMjgsKZkZV33Cmzk8kmHA9+LzvpBdYPCpZ5KUQt2OluveS2FCDmDZgVTIEZQ+DN3PZczlVQiloPAnvpKDigPUw0v1VaJHW+5h4Ea7dgB6dVUy0/85HbgpSnu8babPsEwhBBOaZgwzLjW42Hh8xyoZWTZRuq+lGdC6EmroSK7vEr1e6oGdVnANxobQVAJfd2BflclsDJstTqpzxB7Q4U5BzyWhsDvJ4eVqCquUBdoh0hsLupiSP7rVtbAqP/xHyYp1HWW7CXsdFkJITZBFJdeW9SzOhxJZMCJQXr6vCgLPJEaIFdi2cRm2AV3FpbQKQWmTIqkVbxy8ZRyTyz5+pGGqJq3mS9XVeRjT+E7+m2ns9a/hVmhRFiSiKiYX2
 3LgSS7iL
 v8ciDA3QmUaYyKqS0W5Pw6FpJ6a9+/zlPqxH9Mgq/pObyEhv1RKSb7U6brO4HRcDtapY0GpFxtjxiCe5SoF6WIelv4xGa8JzUSlEUE59BM0UrePEwWBEX4AVVxkQH2e7sM4vtDkODGhDfICy6fvYuTPhA8iljkaY2psRCNIkhXqdXRLdPITlvm6ymkGoc5KTiqs4DrjCvUv4KhHbCUTXKzFQAxYi7NudCGmcE/dViiHmh5fg8SGiOmZgvjoL8mhEoyExVPI8mpjATyS0nDQ8qLLEUYuzb4TifOoUSTdRXlJKnAIZlYrL0QCXyUN0oRYcwDPuVBJi9x7erslq+dU2Pgqzh8mz2o67pg7aKHVaKeT9RJAzyIZKubjNVycCIU0dCIMxb06tZhtLxR6EMa+wgxZu066Eij2Wg0O6EBzQbDrY1cCJ9sjCWGaED6B29qCsUV57W5hhEc4byeDJQCe3R49hCOsHsuba9mlSs6mAyGNtlPoeCOpVkX8rA8UStwChTMx5xSVhNPhfU/vtSe93Tt13SZHXXyGcPYr2/ZMtKMW0tnFXZGKJX4/3tFFhAZFnbvbsYzxGJ3a4XsdJedH77ooUD0NiQ5XD4/m71ho4uuLr3Fyh4uXEF+S+/3NOfHfjLCEXgZ9fdGpEHebR42fzBrZbbzsXun06VqVQT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenjie Qi <qiwenjie@xiaomi.com>

The address-space write_begin callback is also used by internal callers
that pass a NULL kiocb, including page_symlink().

Check iocb before propagating IOCB_DONTCACHE into the F2FS-specific folio
lookup flags.

Fixes: cd5bc4fbb900 ("f2fs: enable buffered RWF_DONTCACHE")
Reported-by: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Closes: https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
#syz test

 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6e816c9349a..63625ab3f1e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3890,7 +3890,7 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
-	if (iocb->ki_flags & IOCB_DONTCACHE)
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
 		fgp_flags |= FGP_DONTCACHE;
 
 	trace_f2fs_write_begin(inode, pos, len);
-- 
2.43.0

