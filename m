Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD2BCD343F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776D86B0093; Wed,  6 May 2026 14:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F806B0096; Wed,  6 May 2026 14:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2D26B0093; Wed,  6 May 2026 14:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42D5F6B0093
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:20:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E497B160316
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:56 +0000 (UTC)
X-FDA: 84737811312.25.7FEF320
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0BAAE16000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SGYCHmDk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeOlLbeySOVjo93lwLL44ciHnn2Ct1CFGUbHwbnHYfA=;
	b=OqRVIXHTk87s4KFoasc5ZMv6UD7MB1rJZ28fU4FxSTJw8NTl8/6VvEk+4cOpI07onHxKa0
	SJaMqvFNLLX7AaobL9cKdxDljwp7NFZf1Y9P98kK8nyUSXELtEhkmhKwDhjTh/5KYQ53IQ
	3T6nI5KOaNsfwGdoRSjzVWwcx0HmD08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091655; a=rsa-sha256;
	cv=none;
	b=Pyuz1kGJl0AI9AwC9Wf+Fx24sU0RsXCMczirKnJnVZfe2vGSwOuVJARZplIaw5roP9EPeC
	Vloo2Dbg48L/NtFaFShDTQNYqqy3w8hIGRBz6EqaXerPXe9+nY5lv9CZGvgVKOQvWIAeR1
	CmP+eGeeCzl3tsLsUQb46Hg1WliR/0E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SGYCHmDk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-65c52bb5dd7so3898592d50.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778091654; x=1778696454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zeOlLbeySOVjo93lwLL44ciHnn2Ct1CFGUbHwbnHYfA=;
        b=SGYCHmDklH5hxMW98Axnm+7SrZxY22ajru9XDQLYZOiWT0JF7X4MFALojBOjDiHH+y
         3AoS0K6YAEs1iFr9xRQ0eeUbkDM+cknkcGRq0n/1dcZ4+f0wLN7aUHgITsPQKP0hHqi2
         bBL0T4eBi0B2ieHvidVCtxvg5Fp8AIC6TvFL+COvQx4UDVreBoYP8cpQx1b2kMVpSyFz
         teS2pBW07slHOq6BfTI0IZG/3TVbM8oxUzbAo3gvfWnB359/Mdda/hPq5lk6FtkvzZz+
         yFj28hM159q1z2UTUkMRV6tCKJYDFeVKx1GKxh7EndXtuUCqjGgikZRF4eOpmOGzRvcW
         c52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091654; x=1778696454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zeOlLbeySOVjo93lwLL44ciHnn2Ct1CFGUbHwbnHYfA=;
        b=mbcHTGPx3CkO08BN9alDjSb9kG41EWGjPUN2uBGmT6he1FKfhXe5nnYoHSXfFi2IkS
         qOt6pjSaXJ4a5O14f/cbY5R7tVvjRhle8qhDwR/KNxVr2nRbdS/eknuvZlLg6iWTHi2j
         WKED7f2rEaNqz8iI8ui/Pd+SRcFxt3jG75Jn6DuZycRyRGuxFXMhwULPtOFA0moAS6eK
         yOvWzB1EByhU+aOkOmNpS70AnVTmeSqjZHWbgnCJMB+yfW4acPRaKf0LJ+OVhq93PjOv
         ChIA46/XqNmEr9V5nlaOVw6YMGrfFPJvs8uhjc3YCLWbGxC+BviuZYGetuvQD2Urbj6H
         CuEg==
X-Forwarded-Encrypted: i=1; AFNElJ+ne/QV9we3VLrRVAwDScuu+kNCz4GbjmpISSQczRZvBKF+bTQs7tx0eXpxTZUmFBoC41ZJVEz21Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0XmwhRCBa9Ra1WE+DDj5GY0hvnRw3PEZFxsQbqpF6qJD2E6bu
	ubXOLnqIFfdWJRsOM9W578UyKnO0U/Z6cbMhb1iQHtcqHAQ1hvOh5p26XJ3pv6uKsk9gt518SUd
	XYxxQ
X-Gm-Gg: AeBDievCqMEaWSzN7IazOjhpZlPajIupNQAAiBmfRu022YmfLa0N76bk9jTKP4OhG2k
	uf46zOT/TFcZ9+11N4+uoDeOL2hPnIDMEJ2d6kRhf9JpAwd4EM2io1mIMMYPlpfnAbrnl4fOdcQ
	4YD8JWuF6hNfBmmyELlEvUkJrPIwPqZ05YwkLlHVPZ/PZTOEgSM8YaZ3BmvAaY5ab7wBCei/yRU
	adRQ49cGS5hM8vkMmZeUXl+CLFZp6lKoMTd754K4NQLjOsOVuVAV0s2KFVVb7q9uzKwu8hozXlR
	uLFL7CNVcvM1EcVkxeKMgZVEqafI/rS0F1Yx5uzUvNRpTWGQKanIdMYBIGMFVUNWwcXSXTRVPlc
	Kz+AkXAfHXjUEybXCXLJWkWUyzJ75UzJvMSgEJl3YX+xUaddLSak0oMmZqHXxF/z0h4Q9nB9vu4
	zJgr9Df3W0kv976Rn0yGAfsYLOqndDmlCTRk5Y05OPRyGP1JTsflZYrpTCyNjq+iZI7esSK80ck
	886Djg6PkmZ6U2HZs+TJD7E+K6/XVom6MZiqamtH3TDRN/aaPvFGxjBq+hgo68MouXU614=
X-Received: by 2002:a05:690e:418d:b0:657:656d:5686 with SMTP id 956f58d0204a3-65c79875ecamr4910797d50.4.1778091654158;
        Wed, 06 May 2026 11:20:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c7af9f8e7sm1389917d50.13.2026.05.06.11.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:20:53 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	sourabhjain@linux.ibm.com,
	jbouron@amazon.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	bhe@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.carpenter@linaro.org,
	pasha.tatashin@soleen.com,
	rafael.j.wysocki@intel.com,
	piliu@redhat.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com,
	changyuanl@google.com,
	mario.limonciello@amd.com
Subject: [PATCH v2 3/3] liveupdate: block outgoing session mutations
Date: Wed,  6 May 2026 14:20:43 -0400
Message-ID: <20260506182039.2623553-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2382; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=9bYai8pKOAnNVwlD2anL3djes0qaooK823m/0bcYUZI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBp+4Z7J1f7PoQHuaJFFbbJWThp8lFFG84B/LMl7
 9tqkK87uKKJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCafuGewAKCRC7dyhM23N6
 3u2JEACMQLgxhXLH2DdKJvtAaMwDkcMXd8y5qY4b6kqGDP9HGt5Ae/rRl+L+GRUL6wFCS+5gOQe
 OnusI0+diMcmjiZz5sFo7vBz/adytPClMKIvK2J1vb8PPy1dBuHrY0Z/Yx9mRrS1Ybztc2mIkwC
 VY4DcVknAahIhcU9pEG+HBT5oKMzP/9qf41PIcu2IR4+7xR7WAdFXO8V/wuVQ37h0BWKPgTqkU1
 MeJff9gJ8v1LT3CEtxKpJzHoQE1uxEGWV6bS0f2rsoKghbd6g5tpM/eIOh+c8NC88tIBAogisFN
 5Z3VUiiNsPJGjXGnKQhekZe+MesIqRlFMeGMV4YVdqVeF2T27QX+cimb1R9zA0TIGEw15TPfSFb
 FOmypPe7gZ/NmuSn/S6mtYqOrMAZx603SX4wAx2sYXug3n+Ts5EUaCOyv2KNCzlwslUbetOZDSd
 rOHMRwejCyGaHNxG2WjKPZ9XgnG7TjLGaj/Fr2Mxd5AUZljPADQnzdE5O9+QhzxuVZy5wdqGbVb
 zRN1VMGOUwTAYrb6t67Mof+TkqLcw8GZNBn5yCDzJroX4MSH7HO6Ura7LbyfUBFK71ijKqY7d/Z
 1P/ucoMBgY9W4+Qvs2edX/vhmMxOF6s0pdCyMxVWq2Slc4+9t41J6mSzP5B/K+7BrtLw1ctQKi7 PnPocLqD+gNpV8Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BAAE16000B
X-Stat-Signature: hdh6wsn34rs7196th8xybmwmwr9g3rro
X-Rspam-User: 
X-HE-Tag: 1778091654-401286
X-HE-Meta: U2FsdGVkX19Tz4Ue8M23mGt0KkcrMutrP4pKdz9HrAtPirNR6mBIowcjla+LGIHI8TFHY3VGrgSMsYdY5xOQMSutDZjQHmjj1uZNUkIMsGLji73knIFLYRAsepMHIiPmqr6ZDPW2jAOVg89BGs3RcMyNOir3iClgwLXqZ28VO9dUCHBnVPPpJWkxBp3Rc+rXOLuRDwVHotshUXskGMzNxzzSWIaQLWZRxbvNFqYrTXxTsgwb60v1xel7I9e2l4UKfiHyczlEfSfpk9vEd6H4FowIYmgN9rwibjcdNMVcVdHgOmw6+WPYhMvkp3Y54PwuvRqHz9p1V8pe7OtKGjeuF9YwECE32QQM0kV12Wc/UoN8tkVZFcRxtjTlQfD5CTOjecA9G535TVtw/hrhuNgLkaV/UgP9MKY0bTcoQaX2IW7afrxQp4+JWkxP2uHA4glRQQ7dAzXMcq3iLT/LT/VZtyZeG3Nn2pu+ahhBCWdfo/EnDdHZqIswKq/Cn2xlgIxkiZj2aMRs2l3ifjGVEoQjP4/w+26dfoPwkU/X8/I19GF9rf7WWhltamxq/qwD5QC8rrxhVNk+0ucQ8ghcKqlJtsHV/C3WU+YW5IsWqNAifs+tNAPObJggw2YUVmQ6oOFTmLsRQoaRv/7D2Cv04MblmF35PejuJQcWOMlBGVc4CNpTmjtqFD/sB84Ld76LUpGfNsQxpG4PpvsiL/do9uYfGiPO50gjOPJL627bWqC56B9Ir8l+SE7GxwD9MIvGHA153Xm5GcWan5PyaryFLYZjM2HJUrPM52kK2a8/O95OSsOOR8/yiYrau3s6oeTtCz8Zblt7xMMx1RYFP846wCFy5oaBzdvyHnB7emF46wIB3PmjBlsvuCnO1egkUpTlY2quM9dIXBq/C/IoAvQmFh+zTFaOxdLQJnMJRq5l5Rgrh/tD+NPIpesWXpO2iZqySuyYvBYiGbRPlMrHwJH9wCa
 IArCmx7A
 oHK4t/1296StWnVFkofArD8gQBmFFSoXFcOPSAWrYlIXclpPt5Flzr1ge+ER8pR96u7+xX2tB0Rl+d2lQcVMfprY/Fg9TeVMYGvZ76G4yd4VUpAKVQXoDSFQV7RGL1rbj+1oBNHmrGhV6PwV42lxvb2dZl4rrBiwRtlqFCtcopySXTLeFw+XhkHjTR/rfRJPZD0naHT7Zen35dl2VNkkTWHbxPZbJYphJc73OguLleNZ5sS0QClAWHi0n3hRPL/skhrIIo17e56tGF2xU0xKTHY0Kq+3yWoGWuQSV1sjtGAruL3SjV5Nhgt0KOhALB17PuQlGjpnZpM5JEbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the reboot() syscall, user processes may still be running
concurrently and attempting to mutate sessions (e.g., adding files or
closing sessions). To prevent this, hold the session header's rwsem and
each session's mutex indefinitely on successful serialization.

If serialization succeeds, these locks will never be released as the
system transitions to the new kernel, effectively blocking any
concurrent task attempting to modify or release a session. If
liveupdate_reboot() fails, the locks are released in the error path,
allowing normal operation to resume.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
Reported-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..12808c696def 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -189,14 +189,14 @@ static int luo_session_finish_one(struct luo_session *session)
 static void luo_session_unfreeze_one(struct luo_session *session,
 				     struct luo_session_ser *ser)
 {
-	guard(mutex)(&session->mutex);
+	lockdep_assert_held(&session->mutex);
 	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
 }
 
 static int luo_session_freeze_one(struct luo_session *session,
 				  struct luo_session_ser *ser)
 {
-	guard(mutex)(&session->mutex);
+	lockdep_assert_held(&session->mutex);
 	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
 }
 
@@ -583,7 +583,10 @@ int luo_session_serialize(void)
 	int i = 0;
 	int err;
 
-	guard(rwsem_write)(&sh->rwsem);
+	down_write(&sh->rwsem);
+	list_for_each_entry(session, &sh->list, list)
+		mutex_lock_nest_lock(&session->mutex, &sh->rwsem);
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -603,6 +606,9 @@ int luo_session_serialize(void)
 		luo_session_unfreeze_one(session, &sh->ser[i]);
 		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
 	}
+	list_for_each_entry(session, &sh->list, list)
+		mutex_unlock(&session->mutex);
+	up_write(&sh->rwsem);
 
 	return err;
 }
-- 
2.54.0.545.g6539524ca2-goog


