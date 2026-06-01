Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C069CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F556B02AB; Mon,  1 Jun 2026 03:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF4E6B02AD; Mon,  1 Jun 2026 03:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C3C6B02AE; Mon,  1 Jun 2026 03:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3E5E6B02AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:49:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 749F21A05A7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:49:49 +0000 (UTC)
X-FDA: 84830569698.21.7CA9318
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id B645E140010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:49:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=S8YTF3Y2;
	spf=pass (imf26.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780300187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKyEwkDOqalQswQ1rmvg6AgbJ6uvYlJ03lXFXs4SB1M=;
	b=FkNUw8MzMahp1NPdodQTV74nOwh3nsxeImgYAqmd7TxPbgfSjqbtNsBiT8TzztBwmts5Vh
	BwMmlKd+cWmsw8BWbwhx2OXaWXYh9WaMsfM3vHDmlh9YqYANO06QzxnEySJOy8hZa0//+G
	DFhrRpJHFzDURe2z1a08iJiXNvRk11c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780300187; a=rsa-sha256;
	cv=none;
	b=ryJRq5iArSWY0oH2VuOr5Y5haXEdwJuoxFqQN3X8i8OE0k04OcAl59AVOkTgpHXOBOptVI
	IRAfSNO543KEgoVRa85W3UVZ5qnIYjn7RCEHQkevMZbzGJIp2RzHs1YVEoZKhdZJXuEsJB
	pm1S9t5XAWmGiXQQbzZrPYkkcYj1PnI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=S8YTF3Y2;
	spf=pass (imf26.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780300172;
	bh=iKyEwkDOqalQswQ1rmvg6AgbJ6uvYlJ03lXFXs4SB1M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=S8YTF3Y2PivDAnKJlAYUN+ipvO7KPsXbLF83dHr9A2Y6jSuVnr89CiAG78TSxiE5r
	 7s0ZtHs9GiV/9MSP+BX6gEbzCzWp2qiKkuOQFPxR/6PdqznXneuS0SLhY8EIqt51Gh
	 EV10apff4ivtgiFEsEp+MS1IORMf7TzWFJ7rZY3k=
X-QQ-mid: zesmtpsz8t1780300166t38979b5a
X-QQ-Originating-IP: JqpDz2mPNA+ZctIp3x7l0Rxyq9TU/u1A+AoOY1r1WpE=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:49:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9316155705307074460
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: niecheng1@uniontech.com
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org,
	sj@kernel.org
Subject: [PATCH v3 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon,  1 Jun 2026 15:49:22 +0800
Message-ID: <9FAF3DC4DEDDA72F+20260601074922.209222-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com>
References: <D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M/5qe47GLMYOBizVx65eWdFouzicF4e+xCRO1KzC2oEf7Lw0p0hXIXkr
	p0uhtN/YY8D4m1g+cHhHTdBJjF0h52DtlovCrFPmrSzMavIoHge4Ik3SWtxJrTQ16DPAl2t
	kth3MK+ZuS/CSrzlTw76awjLUBvujLUWsQ2OGWMkjzSuWRxeOm5HF5jX2Fes2vHcUIpnwPg
	gwm8Qo6lAcbHach7rDWoIcjgrWvkMsPEpbUw0A49JRUAF8RSRS6ujKycgjuYSTG5/xTn7tr
	NNrVo1gJTRrvrSd8aj0Y/91sSEJ//Mer2bqUfBnIA57oGIMiwgUJJpUTyBkhGDFgCDss1AF
	TieRCsbwM3EForRowVGRvLtS6nM/zyWOcIdDXU/eQYnNVp2aJGNsQWfREUk3eoBLmSLzSI/
	a2FygrRXXmUqHATw8cQgXj8BqnC+dx656NMSkblwXXU9sLUHgIWmboNz3NwdgxxBuWNe78y
	VNTijUojZyBimbJXj2ZGPAr8VerBBsBVH9kupTs4Uuc0ooquhGfqhSHUUGk1g8qboZIbcDq
	MbLu7rkRzdoz8vkp0YI7IFfU1EsADRj7pPJrZu1xPP4U01mKGZSdQgdJpIp8Pz6D7X35rTK
	SFsuD+h+aEAnF3t6VVhmQUImE8p9ZtIDlt+JKN2hEPvIUak3jlznaxVsjp4JnrTe6ZciIsk
	oZ+dClC9lPhTmGvfll2BMZToz4TLyNL9dNAxD2pBTQOnGzB50ReCF+9IvfApP8/bmbRi0A5
	RuaVb54KgZrRcRXFvTtOKBx+3AnsaGNdsWJtCMc/JLeL0Uy3gjSq6lPo03X1S6O2iU1lrJM
	wNav9Q641HP84YCvvNpsLgYaRvHcBj5loZNHs12Mhjz7RGhrzfmZTdeaoP00qtUv5Gy6JL4
	2TDuRuhECi1SvQ7HXdvRZmpjFfEG1PfDtZGB4aonj0S3sUhl8WgRZGrYRUBkANiqzgUVOU0
	Gfe2yo7W2zv8hv8iH/rKAoQRfNg4q2yTEGzzpTzvSYSsdszs8osewkw1ViwS0QdUIxTqZBp
	lL5xz+X3O6987R3iW7xoc917x9p1g6oQMyaCQzRG3Gk7o0i6Y8DuZ72+Unr1VHWVz3W0v0G
	+7vz369VwLvq045jp1wvElUCS5sIDQyhYJiF78a/t0MwBSsMoxXv22cch6SbooCEVt2Igk4
	Dlh2rY33GYDnIA5zSVgfe/uB2A==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Stat-Signature: 74x9z5kji9z8imzqyn89mohk4qa6ykjm
X-Rspamd-Queue-Id: B645E140010
X-Rspam-User: 
X-HE-Tag: 1780300186-270421
X-HE-Meta: U2FsdGVkX18vog84qk3ZrtV5GtqiHAASojcXB2amX+4UqpHIiLAms0UdaRU9IE+J4taTy8ozND6XQaX3MsyD5JwHcLn7jU14bq6GSJt4lNrpnbYrX25iZw1YYvCFuvAO6lYrb5EWargj4CUKqUXZ1ep0NvFF5PpAKq/iRMezKfvl7BCxZeohqtsK1WGC/2HB98C/aW1flCxYOiHS9NbYvvDViFKWrbHzKSRLh26qGwFYJNlLnVtFkFi9S9ldBnD2FdEZyec7Uu7Df6h5c0IhdnhAAbJ+ylpc8YZ6XMbywv++2PS/aK5l1hyrgYK+8e8+9gQQoqsRyjxaV5zRgS/hkzIHcgeJ/qanpty9xKWw7Hm3tEkFpzt0K9CVFVsyJHWHj4wqF/ELFOGeCizpGB3uAShJeQ4gEDkJy+68ffURhBmJD8Pu6s8RX5VvtW0D7PxBVzxu3K2QUQjbMnGtKbOqsLCuV0QRpwiLT+U4VvMxHbgEq8RWC6rzSyl0+7wOvvSx3DY59sC7fEtn4QoXc9x5oGGnGheY5DZM3ff8rvFu+PHn0sGR2o/kL3++nmTPycYoWld3D+x9/SbVUbDp/qpfWRAIgpi5KrUnso3kbEKpJmnQhZehpb8YED/kBqQIHW5Fukewniwr3SgBesTkSVzreZazGU88XxiKorY72C2hLVhRXryahhp91b9i2LfYGNvJhynT+R1s/p7ECSebeytkxb6XLicSq1OS0xrX0YfABbE2CBZiqbZ0bKZR5IXhO1vcrJdxe2d5ekuRa58bq+GMhNpHt2Nt11vhKWn4fMipMq+ASf/B7IhEE5DeBWL1nja98jD08RbsHrDiptXV3pqMRjwsMBVaCa0lyVrrg4Enuo9zA3S613X0wD1BXhks62lYH79tkOLwX3OKsorDTt4ZWErqR5Al3buPvJm+zENDkv/sS4mmiPM3aoGeoH+12hwGEd8w/cMsmc3X4VzET7Q
 i++/uzIG
 LvvhF/VDddKho4ljMMq5FT/FkIjLntNQ7BRTPmwldB8EiQXBF1KXz+4K3H0bEkixcz27jHFU7WlRAaGECp61PR/1+WhnN/BwGdeMe4yaQQQMS0l1YTVXBIs+FXCtwXJUfeotM5cWeZnrYKRsWXvTGM7PW9Y8v/C+0QAULzTgBO7h15YpByP8vz9gPNAhdPpCD/x2XMFBcga5CVzgm62FrJfHKCJF16PZKhWd52uh6VtxlzWf+8BFTKmoyDjgWzCt7aCc2wYZ+IAnpxaXlGEmveAvjNrAV5+U2VDZWRK+vlomWeepang3EBqhzMErYro/w/WqMzozU5WqLkrFkMCsaorJOsx2F94OWOtyz3G36fwBOYI076eqmqtTAy/vqKYpPBh7BPRhnp1ekD/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a dedicated test at the end of main() that writes memcg_path to
sysfs and checks the readback path.  Configure the memcg filter before
start(), verify staging readback without commit(), and ignore start()
failures so the test does not depend on CONFIG_MEMCG or cgroup layout.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/sysfs.py | 34 ++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..7a17ab88361b 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,38 @@ def assert_ctxs_committed(kdamonds):
             if ctx in ctxs_paused_for_dump:
                 ctx.pause = False
 
+def test_memcg_filter_memcg_path_staging():
+    global kdamonds
+    memcg_filter = _damon_sysfs.DamosFilter(
+            type_='memcg', matching=True, allow=True, memcg_path='/')
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
+                    schemes=[_damon_sysfs.Damos(
+                        ops_filters=[memcg_filter])],
+                    )])])
+    kdamonds.start()
+
+    shown, rd_err = _damon_sysfs.read_file(
+            os.path.join(memcg_filter.sysfs_dir(), 'memcg_path'))
+    if rd_err is not None:
+        print('memcg_path staging: sysfs read (%s)' % rd_err)
+        kdamonds.stop()
+        exit(1)
+    if shown.rstrip('\n') != memcg_filter.memcg_path:
+        print('memcg_path staging: memcg_path readback '
+              '(shown=%s, expected=%s)' %
+              (shown.rstrip('\n'), memcg_filter.memcg_path))
+        kdamonds.stop()
+        exit(1)
+
+    err = kdamonds.stop()
+    if err is not None:
+        print('memcg_path staging: kdamond stop (%s)' % err)
+        exit(1)
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +388,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
-- 
2.51.0


