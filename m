Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079B8CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB386B0005; Mon, 25 May 2026 22:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601F76B0093; Mon, 25 May 2026 22:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCF56B0095; Mon, 25 May 2026 22:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22B8E6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:28:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCF301A0244
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:04 +0000 (UTC)
X-FDA: 84807986088.11.9AD828B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A0E7C0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WsV11twA;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGU83YAf58KGj2CfXChUMVQTLfhhPsfO7RKZqCKQfck=;
	b=KKbJpH7AAeBc1pEcF2MfBnZVhrgP8FiugL2A7H86CN+PqMk8IN6VS7QvD7MxppXeTFXJD2
	QHerFo7uN5OJQGpXuVF0PNhmi5VUr6RFxS9R5WLPbVaLwhYjSFsNDZJyQheDBGxUbTeH51
	KtmyK5AI1oIrl+AKiHfBENOb92l1rbA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WsV11twA;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762483; a=rsa-sha256;
	cv=none;
	b=o1yYV5oTQA/KxF66JZsMvWtjBieNSDyRkj7vzDaT6swW2gzN6iqR9qL2xSxiF6A/P/ZGvd
	UA7Uw2M8seqdGYpPnJGgERNO7LS6Q6vqKa5UDtFS/2aWbzEulEoc+1DewD3FOLKda794bi
	1v/aCw5Y7Ve1Fe7ol29ePlHFSpiFpg8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8353fd1cb5fso4960653b3a.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 19:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779762482; x=1780367282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGU83YAf58KGj2CfXChUMVQTLfhhPsfO7RKZqCKQfck=;
        b=WsV11twAq9wD7JC/ZyC5wdcsdW3Ea6yaqM3NHsBDsHdgCtQ6Vp8/iljezBcWBTT9pA
         4HRNPE4RlWDYCH0yu+l8PGHhPqEHHI7N2WQ0shVxIo5knX2ler2HBgd0DX2TbfDgn0sq
         g0HwTwq4TT7AuooXEzruCGC4K5hL0LoZmMgXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779762482; x=1780367282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GGU83YAf58KGj2CfXChUMVQTLfhhPsfO7RKZqCKQfck=;
        b=FDSSqhDb+g1fM/KKapTEP0nCIXoRgz13xdWT2o7fBpMImEzvPlUsIg8Dm5syE25Tx+
         kMlmv3T6aNRrIUI9Qwb1bOqMlJ53Zi0Ysi0l39O/0YTLpc0eXzvUf2YTTkIaBqj0YkFQ
         DAvVPx83zb9Ano4ej1pWXG5nRnTk7rXsl0RAIpPG/TehaYrfZSUOkqrcfrJWMjzSJsvL
         85jKvP9BQX1Rdknz4sMkCtzshwU+l32kRd1na+ux/0pa9rCbKdQvRc2m4qDfKyXpQ++p
         Utbf/q3poQHa7svpK77vq6s5501lRqLs7Ghtd1WGqhQS09cect42JP5HaQgsHb/isPQs
         FB3w==
X-Forwarded-Encrypted: i=1; AFNElJ8vyORuoI0YimaVRead2Rg3cUPvN68sh1sbLetoqi0pr3Kxga2yaF0YhJVQC9/pVYY4HwtsyAWsZw==@kvack.org
X-Gm-Message-State: AOJu0YyYqSZQ34jQOdinmsf3+CWYode/MmG2vORbH46nOsrkf8584HTx
	u7th5fyAduWs/xHlQTaLTI1KVsnoL+SjLh7IIlOvZYI9nVVGMmuiqf/0byUeK9d8TMK6ivl+p50
	WV9c=
X-Gm-Gg: Acq92OHjXpDfW3bFXL+x/oLWi/Ys+67tuDIS5GHv34S8a9AxEcQEQ7tYF7K8lfoj3VH
	uQNmuX73GtEDZ7h++pQhgPZko27UBMAaha5grL6fNQjUjw9p2aGY/5NgBPkIZz7RDwmoWg/bite
	RcrYfcnvjx8s/7JDluXvRRmYI7fsEDRiE0uJxWISIBWTDr/mJqlMLkSzYpA9jCh9dvnWeCTl4a9
	9rB2W81qho0Fw76wHoeoW31yxsy7zUgdmA/cCtrpFnmTkLcIQKS4W72PiS23eKbprRr2OAYAXUW
	AIKbAUq61GgkMvsXhHsYPcq64E7KoVnrzztsi8pfQidlVaaQXwnSompkqq1zsZ4G5zDR6FVkqT2
	nOZY6qI8LgwYqakMdKgfI+f6/4yPWg5lxbEessP2XJU500frLkSAxFjDLVLiJZYhfqS3dSYSjHI
	BXkSdbE33B0FHsNKbvIN9d0hTksbGNHH1Lk421uK6ZMaOajtD/rB04iIcZgOG0h0MaPthg2GJYO
	Wcoy4DmL1RlMA==
X-Received: by 2002:aa7:914b:0:b0:829:6f7d:3086 with SMTP id d2e1a72fcca58-84160c26e7emr12021636b3a.11.1779762481867;
        Mon, 25 May 2026 19:28:01 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:890b:1e07:dd0a:52d0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164af0506sm10796944b3a.16.2026.05.25.19.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 19:28:01 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 1/2] zram: do not leak blk idx at the end of writeback
Date: Tue, 26 May 2026 11:27:16 +0900
Message-ID: <20260526022754.2377730-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
In-Reply-To: <20260526022754.2377730-1-senozhatsky@chromium.org>
References: <20260526022754.2377730-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ufnoojxkjat75h8w8frpzsxbrrec69yj
X-Rspamd-Queue-Id: 0A0E7C0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779762482-538680
X-HE-Meta: U2FsdGVkX18HGfgpHD1r+JVHEJ+smPk9kBr42eg/X6CplCnhEvGVjEArExPsEGR9U5x1k5dsu/6d7vL3wNpPylaKB12EBEQyZIDA8CLUp4XKrfMErRVvvFTBNprDYflqfDNc3SWXgF6h9XkMyGatshKaux/8MGbFlzOQqIt7YlpnIGK7FwRmHRrFrZFxaVRMqHBLRL3UBJ3KfRbZhPLSSui/+klXDcEAsI/NnKEcci/bYurbfULzrwiSf63/b9bTvtT+/V6Bcf1yz1m3+S/GSexNy4mxd6zJtLJar0TDhjbh3DfBAaxNrHk+ApnBWVbDkTKED3L304oqB9DooOKSG0cdmqUnMmyY8BBxkz06F0zZIHTIzsW6zuzeLK5Dpb4fXwK0JjO+XXA8jRzUxo73ieaYbCAiGBnft4vKi5ycYNAhvGHSB57zU4eOSmV6XBbPdqb9mBmcND4hGjSPBFREsnuMqJ7EVGrG57laEOXvUjNovf+ITjz5LRKMULcTU+iEmbiy9oajPGJduO35NST2vtQOVsYmIBbgm/EyAHw1bHg0z5SnB6RoJ9+P7Dk9qqgdFY+m8zSejirkoi1vmGkTg7b0wKn/k35204DR8/iKWK60xFGp6owKWKMRhoLziWc9fJzTSaFaZRryfVMPpbRzKiqSZQg9+qAjtQe5UKrYk2g0PV60MUR6i3apXxHeJedWggxKa/AVrM3S/ijGFypn12z05pvPZ9MUFjUqCXHmCZKZUuIVfHKrB3yY/FoaQWsLKLy2i4hooCfZUeyz0AhuIKz21n5IBnBsHcfnfN2R4g1DoLeuPJODHsT4mosyScAUyoRMakPIt84b72ezFUMRCJbzJdAo48CuZ9hYDL5Xgxwu1SIr6glKxI9f2Jkm+WK6OdAd01464Ak30Hun1FcKEFyrW/vnRN4wO9s6NthzWhl8bIcFBT/M6eXjNw39/UdEkA1+aTT9+obLbn3kQzy
 dah+Nw4l
 fQhCqNQUwPOI+wrcYRyk7Y/Ifr7gwDKOoKae+oR14HZLxtFjUfET1g/t+sGerENXtRQ5/OkvyxhVuMsa/T7gsnlxpMy/Kfg/F0KDL9XRbNcl/GD7mT/kJCensqAnFIdjGrFaG3yH9lvpWWcd9JQpvEse3bbOTUjD9dk0vyzeDx/EQAkizC75ni63iZ07exRKiGyEnipXT5nmGeEDjCEPwjvu1qExoLCc//cENNeRGC8nY3zEezwcxgNv807pXB0T0wVyqE8XqTasAZNDwGHSro1fHHMYOP+74IzJUvaydOBB7jCHgerLUJKzvoWWsqY0Wnx4mxy8CnmUEvMd1WfMQ9RI9RqCfqdliovQ80YglnLqGapHDzhS0KLwkascMDe0rdAhi/Qsb2gqC3CFG+tAWe6sK+wmdOSCY0oodd/gunMjWNdapWQHsAypAxVIVQR19sK7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram_writeback_slots() loop can terminate with valid
reserved backing device blk_idx.  The problem is that
cleanup code doesn't release that reserved blk_idx
before zram_writeback_slots() returns, which leads to
blk_idx leak (it becomes permanently busy and can not
be used for actual writeback.)  This does not lead to
any system instabilities, it only means that we can
writeback less pages.  The scenario is hard to hit in
practice as it requires writeabck to race with
modification (slot-free or overwrite) of the final
post-processing slot.

Release reserved but unused blk_idx before returning
from zram_writeback_slots().

Fixes: f405066a1f0db ("zram: introduce writeback bio batching")
Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 07111455eecf..602abfe23797 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1127,6 +1127,9 @@ static int zram_writeback_slots(struct zram *zram,
 	if (req)
 		release_wb_req(req);
 
+	if (blk_idx != INVALID_BDEV_BLOCK)
+		zram_release_bdev_block(zram, blk_idx);
+
 	while (atomic_read(&wb_ctl->num_inflight) > 0) {
 		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
 		err = zram_complete_done_reqs(zram, wb_ctl);
-- 
2.54.0.746.g67dd491aae-goog


