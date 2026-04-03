Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F62DD730B1
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 07:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A046B008A; Fri,  3 Apr 2026 03:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11126B008C; Fri,  3 Apr 2026 03:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B292D6B0092; Fri,  3 Apr 2026 03:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A05606B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:52:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A56C59700
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:52:27 +0000 (UTC)
X-FDA: 84616477134.24.89F8DD4
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBC34140007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:52:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=aT1oaND+;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf23.hostedemail.com: domain of chenyichong@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775202745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua6TXToexFuNdMYzgJkRu95qFBaQ1rvNnGJAFP7WrwY=;
	b=303Nsmvo1vQj0P/ke+BqCIA9vo1LbII0ADiKvXUSuN5bWcruT0M+T2iKrmrOYVqTCPkBYV
	m9egZZCIPAAwlCV18OlVxaI/lU5XiQedLz+RjVa/BVt2/PxNdAHFytLyETREsxLdA9QUTK
	PbeF2WKhXzO/3IzoU8GiV4xjsX3jmho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775202745; a=rsa-sha256;
	cv=none;
	b=8P7up0vhutwGmOPZMx7a84v4T2/ZlDU+VmDcjbxWEJScygzGiSOs1sQZzr2uBQI+CixZdP
	ZdwtiJut1V+mnS6m3KsUE2zOKFJVUaGxNU6guS1+skNppEDIc72r25tGkUtSd+uDmJ63vU
	47xTELta2r3GnkORzrgq1ExQCCbq8zs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=aT1oaND+;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf23.hostedemail.com: domain of chenyichong@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1775202731;
	bh=Ua6TXToexFuNdMYzgJkRu95qFBaQ1rvNnGJAFP7WrwY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=aT1oaND+t1sU/b6MpLaW+ox8G+686JwvEL7FlWeuyTAUdghqhavkuxm62tgOSI3W7
	 EnMc/uYvIq9RHZvnCpemhJaBoLXC4P4V787FEWBvi4qG5LaZaktHryh8Dy2AD8Pd3o
	 V58HrUEAFLWklUDRaZwj2KLOUPG+OoU1ASpjq5sM=
X-QQ-mid: zesmtpip4t1775202727te98f80b9
X-QQ-Originating-IP: u28J8+j+Xf+Aatf+I4a6ZT8GoQYhyaSmCdRTLXJYTmI=
Received: from Shurima ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Apr 2026 15:52:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9212431654302830342
EX-QQ-RecipientCnt: 7
From: chenyichong <chenyichong@uniontech.com>
To: wangqing7171@gmail.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com,
	urezki@gmail.com,
	chenyichong <chenyichong@uniontech.com>
Subject: [PATCH] mm/vmalloc: fix KMSAN uninit in decay_va_pool_node list handling
Date: Fri,  3 Apr 2026 15:52:03 +0800
Message-ID: <B7281353F876D424+20260403075204.894243-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260402081413.1896640-1-wangqing7171@gmail.com>
References: <20260402081413.1896640-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MdDSduxpyAb9ILKvWW/jHHNz2KR4Qtin86AyAqu0KrjW0sUvgxyFFv3D
	rw/M3/DxIg0DbxRqdFlj8MtzPVobEzudHbFmAtxHj1wQy5DmBMRGAodut3AZH5rLqUZ6bbr
	6BUfuOLA+s539J7LppWcYreC0BQ4Bhw2Rh0k9j4uRwoF+bYprM4vW+XVkiet5sXgOKqrjfr
	cjuJPcgOIV05Yffbag9nX2b0PdEsbZaFgUBYW1AUDjzjzN3XPq9RuZtn4NLiaW2lnC9yjNN
	XZE+uvft+fBxlRA9SLBaxWIVPJfJL03nmf2LB5j8qm96PfMZQUR1H7ed2ZcNMKbzRFxzz8l
	Y8SoLl/Ya50nyMvaumIWDLVEP54/zqxJuuvxALDtpLGW756bbO7LOOLfHnvLxSDTGvB1xf4
	UaEBinGx/kjDhpoFqBFSb2ikKx/FmTsER0a9+e+p4yoL4Gyy3IgktmIjXxUoW+RFtbqIkZc
	yLcppRoLNLoX+11Jlv9iqt2sMluIhQLWQX1br1DOunYlbZ0AQg7ewtq6NkkTX9cpeW/ojgf
	3pY4CeTEGfycRW4ebIY99l75GxdmX5kUJfWJOWixCcdmDAaw1Kw4espHsTJYukI4dY3zPcv
	+tDjG8ZCesJSBysW54wL0vAdzabdyusCqobDyMnLO/ljW3qN/uJ+rjUV61oBfETfgyZSL8t
	WmUpZd+nZDPiVZ8vJeOF1MUhBZZKb5/S73/Juj1pX47dysl4JFGjCZimDSMvmElSGMUXsXl
	nZ8E2Z8XE5JctBzsho6Y7CH0IZfrgsHdFN+ldb+b6XLsznQM3bvn/CCmkIkBNgYbEAsNWJh
	OXPAiaMfnKrML7PCeXxvDEEy1QhNWB8B9cDAKN8nLrukZxYnCy+5EBoDGWx99+0NVaiRbrf
	rMccMRxvc5EuBjzIsnIzviYxK00oipSTW7f4CrYviK2UOV0oJYL40PwIKAentDJYm7wd5mX
	5hDcJ/Eac6FvoLhGRyaL89jUMDgirzJWOvkpqXWvNeHvwFe5e7sK2955wxZae/5KjMWcBxf
	U8+9bpJnq/Ef1Z560s
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: CBC34140007
X-Stat-Signature: 4sjbmx3t9ki5mk8k4q1itjscatmm5u8p
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775202743-321452
X-HE-Meta: U2FsdGVkX18I/AXcHyukSouJ/yNeDDB1C143749GOW/dJotDnvGIMHgy6Q3MbwAI9paOwe/B7CF7M+KFqkHqHmCxgidz29FjJ4W8kHbgfrIZyphHmKSlkvT0ZENbb5Jm8WB7GFQxbBfUeim5z+C9iJ24rlHq+KKOd475ZviWFfQRsxyySk9Hmy/aKoLmR0WE6hoJpdfpn1PAdLgQ9oyZwjSOQ+x7Y3IIbNvEL8D2t+WEhLqjWW/xtAWFzdgRhNFVjRmgnyiQ6MGBexM1Sz5GSJ9n0whAAh54PBemcCnhZ/nintySEFrCQ3uvslckn0RFHsOUGZzTJoR2q4kyPnZ2QpbCHNLGAudUwvBhqmyV5KSP5QkZKasWyOgxSnwOST24JDv/zh5BD3+V9r5n4rB3IJ0XvLCF5ULlvqGNZc2G0x8Px2NlKtvZ1BNZBK2PGbp22Nuf1fbxTYZtetM6KTW3tyw3AhZbd7sGOCcSMMlmHZselAW8Fk4LpBoPXabeI5su7FM3NWA6bNbBLJfVU4wKqWkfuVqRGDiNOc0LImKba/pa6WPka+Sb5SjIltWDXhXzrxNURCS+kpncrBZWN3tS3FSZuB93ImRreVUEij+LM1LcVFbaMY+iT0Oh2mkwLbASR7JUrD8bl63fRglI6qi+hUXLXFc/vgP3+J2MZehPlTTzPpkHzZFX6sdU88mGXPGek0yupgLbaR2ewpPf1LVjDLYLTjvO7GE4eok9H/YX/yUaZz07htq+VBbtdaJo42Ltw1Yqf/2c6pHtAl6Lyl+SJQrwpvY8M7+e7/8NoZaWmSBPdWaTrhm4Eq7PHbEyAJ7gXfLFcv8c+BME5CDyiNDe/OL8qLkcr6ulHudRfWEpFWh9Pgn+XMTDXdTH5w27PvFXhdLRMcTj1fs4AYidyurFBR0YQkJyj0Aqh/Su/7bxUI4MoKuWcPl7SGd9Ra85xIO9GsgFkD9i8/1mpUWYFQD
 RHJzid/a
 p3g2JOhTVfrM/nBt/yCBlZBd66opO+4c/+xGmtWtDGp+HH6vIPlpc2hQ/tLhsGqpMReCdIruj4Q2XzafTZgMRXC1gXhQ71vqi5wizhnPg7rcP2jWnPuKcqyxg/zGakORKWMZTdUqA46UEDmeD6RcfKKeBQ6KT7xiWGSxhCPh1LkkdYf1q1nY+s9M+NXeSEcb+jMkixbHuXwPt1uEJSKo4fz85QUZ/aQ2ZEKMoQmFPnMnkrDuRLhJ1ZDrEdv1FZRD3ut+5s7/7GxxI2f9CmA1yASUkzR1Bk53Zb1BoTVCLOTxBalYQzVOYUUGfDybP7pFoy8MB64wCX6T/gsOdiI/q385Yf8xGszgjGdGj+tB7JFHNpSbaQQgeDR9VX6gQz8S0J42/ZMrWLNkcH/u06aZZziaV1JgMlUmwH3hiQdt6Ef4oM5px8UpFoynqHGDKdVz0kLCM1ZLUIuNjOvvr1kkRXFsKLtP24G6megRV83iWsLP1CnP2JIQu5Cht7qxzZgcPEgUQqP8MaCSo90jtd1+FL/1oEdWl5BtZfTJwn9P5l42FpvllPBLyo1KUgwNDMplOpUgF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prevent decay_va_pool_node from overwriting concurrent repopulation of
vmap_node pool[i].head while purging. Read/reset pool[i].len under
pool_lock and splice leftover vmap_area nodes back into the pool
instead of replacing the list.

Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: chenyichong <chenyichong@uniontech.com>
---
 mm/vmalloc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..72fb60553a71 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2233,10 +2233,9 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 		/* Detach the pool, so no-one can access it. */
 		spin_lock(&vn->pool_lock);
 		list_replace_init(&vn->pool[i].head, &tmp_list);
-		spin_unlock(&vn->pool_lock);
-
 		pool_len = n_decay = vn->pool[i].len;
 		WRITE_ONCE(vn->pool[i].len, 0);
+		spin_unlock(&vn->pool_lock);
 
 		/* Decay a pool by ~25% out of left objects. */
 		if (!full_decay)
@@ -2259,8 +2258,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 		 */
 		if (!list_empty(&tmp_list)) {
 			spin_lock(&vn->pool_lock);
-			list_replace_init(&tmp_list, &vn->pool[i].head);
-			WRITE_ONCE(vn->pool[i].len, pool_len);
+			/*
+			 * Merge leftover areas back into the pool rather than
+			 * replacing the whole list. A concurrent allocator can
+			 * repopulate vn->pool[i].head while we are decaying
+			 * tmp_list, and replacing would drop those nodes.
+			 */
+			list_splice_tail_init(&tmp_list, &vn->pool[i].head);
+			WRITE_ONCE(vn->pool[i].len, vn->pool[i].len + pool_len);
 			spin_unlock(&vn->pool_lock);
 		}
 	}
-- 
2.50.1


