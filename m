Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A9A0D58E47
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 03:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1156E6B0098; Sun,  1 Mar 2026 22:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3C26B0099; Sun,  1 Mar 2026 22:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6D16B009B; Sun,  1 Mar 2026 22:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE45A6B0098
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 22:41:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F3FC1A04B3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:41:15 +0000 (UTC)
X-FDA: 84499722510.11.D86140B
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE2EA40006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:41:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lLWDc8sM;
	spf=pass (imf27.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772422873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnRkT2AhttnAXKxBGtLqNZYa9ovtnVLLt5dqgljoP2A=;
	b=v0qqtiCykwZyBfqOGHCq5FCZDifHiM5OAtlAWZ+Gz1fZzpcApEAafZe7X7+t0vd/QFewsv
	Y28Subcc8/J3ouQ3Q5wl5lTCyKVzfbbhiE+LrfdV2L9IiG5sTj72/IHN9ukc7EOs4pVOMu
	mCLhL/QybN9HliWI43F2WZ6e+ZkhkPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772422873; a=rsa-sha256;
	cv=none;
	b=B9d37S23OlGGfKfK7dAlrRt7Z9cqDA/ZYvRgcBYpbtGhqt9VC896T0JUjZRaWZoZ6FNJck
	xVx9Lc+8rW1uc1ikFdNL9cfdFuFZU4mvhbCvtAXLslj+n2y3AnpeOdl1PQk+TxR7eUGQVl
	7km922+NaPDlI7jZU8MBXyYhc5n94zI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lLWDc8sM;
	spf=pass (imf27.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-824c9da9928so2300878b3a.3
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 19:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772422872; x=1773027672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnRkT2AhttnAXKxBGtLqNZYa9ovtnVLLt5dqgljoP2A=;
        b=lLWDc8sMAw4FwPyOvdr/MVy//QDjtZTd0o6V0zILEwtaCc+1NqrWsjjVCDiIzIhKZV
         c+K1fjjtWs5DFNHG8R8wp83Z0BHM9/rnTpkBTkeZQOavWBwkZGUV/0DnZmDb/JzP28IQ
         k/6pfascnsr7vv1L+tjKRt/zuI7Jz9gC+rLuOZMIdaeGT+7+cczmRQ1FbwmygR2N37jX
         UNH2oI7KG30hVdt6cVAq5IEZvRpBkbSIBSihw3Tq0lCAHLwiRc9nV5+1M6K93/dzhnTZ
         BTh4NzvIoZuI3if8RvT8jyJlGqwVqlNOkoN2W0AfkESf9Ce03D1i4aSxroZQXk4ldohf
         5WIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772422872; x=1773027672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VnRkT2AhttnAXKxBGtLqNZYa9ovtnVLLt5dqgljoP2A=;
        b=kO8lxMjPawy36WKQh/t2CRKzTvWPrIdwgcoSiojwRuNla80clffROtiy6PDyblPeeT
         YP3bSwpkUzN89sLtxpQVuFrHwtlO9YfylAvGvzG1KYzA0VXYODkB6AOe332V0cus3iUu
         IV6zscNiUiLSQT/jJD2nQCUsWk+OzOgxpaRazANJeu3kUz0mUa2hhE2kDLFRFnuDACcd
         zQ27t+0NRt5a3evJpGS5owgxmcF4cRLO9Kr+TPTP/LT8pbV5WMfw4WJsWkm3ESv+KSwU
         XQTPfx1UqJAK6w+Sj9ak/3M2APUU1eS3Wq58F1vzGwy2o1ZyuvNdvsbTQ37Q+aFR5mON
         O/sw==
X-Forwarded-Encrypted: i=1; AJvYcCX7pdT6K/HJIw5Lamt3WI0zOoSBwLRUm61F37SpSr8PkVyi9ctZbAHqZaX+HsSN5YE4ZIyi592eeQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8duyXDpN+du+kNmymcNoQMgXZdWJPOyjnZqj9S4ouVOdvQ9z+
	czQfMhw+aBGgE031tuFnkUWKs9aQVzwn5ea7fpw4NU0w4gLJj4vLuO3G
X-Gm-Gg: ATEYQzx+DEn7P22w7oOI8eZOc27i+D+0hBrUFNkN9dh3kv5rhvUMIJwY6mxaVAJFz0F
	A29nqJTEBZc3bz08b3kIxyZEbragOCQn9RjFjkup0O+pwvaLZL+nXAV8tbRxJwYU1+jMXK7eHz3
	hS7vzN0QpqgV0CE67OVmwAPmQ2MAJnUxYNF0CXxk21aj8v9Fz7uJ8rClY3zvrONuDvLfSu8OfJl
	F3r2U13umlXci1gDov/hNdW1y/jGdbscBaSSKQqtcQmRyhe29lGKfUthLkw4Hkpg6i27od9VEQJ
	NUNdXbGZw/5lOxFdeRLGOebTphqttadHwMhIJVKVNgW5pw0ZUqu0wi0ta7objV69zIO+qbF4foT
	/BjbNY+NGFF/ssjAzVUkqo6uKfKSl7kSKbhWINL5MYDSar9ZMaBHWTSHh9eXM2nbBOGf58+Snkx
	g70dyk7n0telwWHYXmbFKkZ86psz2yVN+EEqnWrPoUazWvmfCClw==
X-Received: by 2002:a05:6a00:f85:b0:81f:852b:a936 with SMTP id d2e1a72fcca58-8274d9530b8mr11492201b3a.15.1772422872419;
        Sun, 01 Mar 2026 19:41:12 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff34fesm10838369b3a.42.2026.03.01.19.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 19:41:11 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	chao@kernel.org,
	jaegeuk@kernel.org,
	jannh@google.com,
	linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	pfalcato@suse.de,
	sj1557.seo@samsung.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Date: Mon,  2 Mar 2026 11:41:02 +0800
Message-Id: <20260302034102.3145719-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8xfkdm9xek1x3aeb1x147o4iftjj15ry
X-Rspamd-Queue-Id: AE2EA40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772422873-703380
X-HE-Meta: U2FsdGVkX19mFIS75W5/uZ2V0/MngHH2hsXsLBIu4O1HecFWB5nchhXzKg3YIn0hQRdtg9BVj1iLLO+1sDNzehBY12cgDV9bQSSyULfX7jorHBIZKdy2/hHNfSc7dQa5dXBf+HccfhLWxs80OYswB9GQzGcgTXY4NXW9qD1waq1JZo+yHwluM01NhhW6cg/E09Pt5M4rrexTGxVWxmMIGLR0naKLk2U/tNbNAY6T6KFHpddewiPBMBdgBts+26SmjWJUfeQ5IL5ZondoUZ70DLdmVUPLF9GR1IyfRePj2KH1xywSOjn8Wj5v1gOsM51UlQ2SRLd+/X3iyx6fbNsDo/k6Z+RSTdjeKITPYUsLlTQWSdHwD8js8txy07MgYljkJwm7YGpAxqz7oew74J+hF9dfBOfn6ic5FTuVCYXqx2PdY784aOiWWzJ4B1PB1B3GuZ4cvIYWZtjdm2Jd2HUGiMPiUZd8FM9x2PZCXNH8OtFZhkPMnaAKFMNivTo5nirI96q6aUtLlPDLJj3xw0lQ4Evq0b4E+i058QllkN27smJQFdiHf0Om1UmuzqJ3fHGit5YQp08cpB80do3plWXiKG/0WxTU0+U8SfyIB5UtnThtq3o2nmYs2UdArcd9d24+yEHtEXsFdi5UmSSvY1KS/qWo9yoKoLOR9F/P/ma7DlVg68tXpqASlXSVGlRhohCPZTeSrj+w6WPEgGL6zJf4NXdCBp7g4He8z+nZtyjlXWldK7PMX3LYDXVM86pR5SAg0abn2CFq9wxCeGUQDfYLSQ+uOExaOxy+yXXTovABft5z+d2rhq4/2ZwiGDq1eb+oLRbZsE5VFjzg80lJbLvGcj4+fga3IekaR6BTiUmpa3AsIAuKZq5tUtlbLkv/mJshxHRpCaAys9Dkk/p2y5utWGrnzY1NZZhYtZy6qnew7PoE3uUdfxVbjvZ9+Tjaxq6wUx/P8m9yMzx8jLXYsQb
 9neJ4BDd
 qEM9dqcqtoK7XcPgH/tvJz3OsNmLv9hWaYaa/pYrhmvD/ZBF83RFKqpvHgC4jcPajBvL0mSWeV56oak+RNoBcHfero7/Vn3s0YF1ZsHAuYSJAw9xDFKmK9K0y6xIr48TS3vW0s/+CMpBXhCZFjisCq0jkD1QF5BzF5cDM0JWcDxnwDH4dZBoXH0dqI+SXEv3DbgF2kRvyxY4D7nLNFGPMBrKsBpg0O1eLH2ImtYS2S4KxUmMbtkwGE6KatMTtcxY8glUGeNmQKIx9+7KvjHs/lsKrlKpJuAPtth564FBvZFiyPbcENB6I7QaWwgtw1gDQUtpW/fmzs58RIayZ+uK1X3fsrVsb4WTtEUD3YEcnGWWVXfDO/4LhURX/liWs9XgIO8SYmi8Pyy7aPWsF4eqq31/SGSTzxc5RYaylaZNAN4tkTioTr1cmvq4Bhc+Ges7NKmuTYT9ENZOSPgJJggi8yEUeQi9t+yL587wSrG48I+EeMBWKQD/HmAFa5RySb4d7Car2Q6ozY9qhvbn5fkkDfl2X/m3qQNE2fL8xpJXacEEoetVv7uJNFI9qoALBr9fNId4Vjc7HoDlvwVwcsaYb981tGeyD0leWpqx0YFfzXNImzeb6+xxVriU29k2mM2OK0NvIl0iybfzbJewFhHjw3YiEHW1VWPsZ/Bh3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slub.c b/mm/slub.c
index cdc1e652ec52..387979b89120 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6307,15 +6307,21 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 
 		if (!local_trylock(&s->cpu_sheaves->lock)) {
-			barn_put_empty_sheaf(barn, empty);
+			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
+				barn_put_empty_sheaf(barn, empty);
+			else
+				free_empty_sheaf(s, empty);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
-		if (unlikely(pcs->rcu_free))
-			barn_put_empty_sheaf(barn, empty);
-		else
+		if (unlikely(pcs->rcu_free)) {
+			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
+				barn_put_empty_sheaf(barn, empty);
+			else
+				free_empty_sheaf(s, empty);
+		} else
 			pcs->rcu_free = empty;
 	}
 

