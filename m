Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8136C60A2602
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xq2Up9ge
Received: by kanga.kvack.org (Postfix)
	id 819866B05BC; Mon, 26 Oct 2026 07:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0F16B05BD; Mon, 26 Oct 2026 07:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706F16B05BE; Mon, 26 Oct 2026 07:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4892A6B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:23:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55C7F120770
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:23:14 +0000 (UTC)
X-FDA: 85364541108.07.0899550
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7907F40008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:23:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xq2Up9ge;
	spf=pass (imf11.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013792;
	b=b2tv/yTHUj3mHEE5E36z1R5zsQKoZaMkTIBApk6x6S9bBvMpVeWQo25mAZeTZFNCGc6w60
	PSfE2smVx2AYUTmyQDFowqCi61r+yftIMdkS+mjaZHkEe366YoNrxNPgetgjq5HFR4fF/k
	ulE2MQcLzy5KBO2G/mTGEyxXyXbAG/8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xq2Up9ge;
	spf=pass (imf11.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt4uKwQ2JQMqBpqG35YVL83bINioR+SmPDBUrwkRSWs=;
	b=wYVdBUvYH+OfDyT1p1CcVotSF+KMWqHGPcQFuZaJwkE906xpN8cBXOwlqnNU+UPi0ehz7a
	t3UcCZbynxsCo4LxlMBBsJsz6lQYk8PS3JOalzGUqm94Q1S8IRVi8mCpG3gnOJL0R2uOik
	E+nWLg7m2gjStEjuioWxO0EGKjdDAG0=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-cd63952c9f2so300981a12.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013791; x=1793618591; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pt4uKwQ2JQMqBpqG35YVL83bINioR+SmPDBUrwkRSWs=;
        b=Xq2Up9gewIcQ0/iaFvYzbyld1VDFLVq0kKaJmOky9CrWM7miPEJM2lbGLKDr8Ab7QB
         yMMkriuGbYUzH8a2jHpKBXmK748ApT1mRvDOuj8sK4OXjbaJy8uGPW8BIeYMxEELBIcD
         VHSnI0MFM18GE6rId+YnX3UFFnM8PGhzH4lr4rJZSNahT6gIa2PvAhvUFHfW336CI5SR
         TBG8OBGB5puLTWR7JKXursFSAYmmy3WHzCaGyCpfEa3CQXXmN8u9zaRsej2IBwHA9JXF
         suhE3XU3v0vt4T0jiiZ/NRWT9rXmlYUAOy29MSSWvsn2yYVxIOFtUCo864l4mFgi8oJc
         nFHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013791; x=1793618591;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pt4uKwQ2JQMqBpqG35YVL83bINioR+SmPDBUrwkRSWs=;
        b=2L7bZhVufw1htIeBPC0IhnD4xHOm4Uns5uBBoe9qugnmEYFGPYZr7P5VxkV0V8uJZ3
         IIEU6poRCw1rCOzGQvyixFTz5Vnx/7htLs1kwdjep5c6zn4EQLl1UK/KVMpepGv+G9te
         Qxpf7OHLeGgGMu4kIGcFPfMgFEEjfxeV2FNGpWeDwI/Kf/Rf8TUvSGBu+FzK0Zn4GIQE
         a/kNVHNURbQ2UQLhq0Ib8eoJnUyOTMkdsfVYQ9jE4d/BQ+RS0KGVZkxiqPYqApifKio1
         szQANdnjyfw2956Y/xpyQ7Pl3QNpUwMkKPJsVNT7nIHVHU1vEpxSssR4QFybuOCMggsM
         EEWA==
X-Forwarded-Encrypted: i=1; AKwUvBz3uPx446Mab6o+xs7T07XLTCDyA9VtqcAddNpcaL22r5aJ/4ZqCT153NH1T+4F0bLAQHLWF7MwdA==@kvack.org
X-Gm-Message-State: AFq9FYK/ziKF7iD/RF+y4V2f/zZ5kcJrWWmyCdjGnnW3EohL22ZUn5GZ
	imqdfTSZ3/P+ZuES+b7/CfMaIDHXJbIdeRVA/m6Pvdpw4BJkYCeLoHOK
X-Gm-Gg: AYBFou2GcRbceY0c30LVd9OhbA+aojLvb0yErtTV+kVvfTRVrUJHQMMPEpKT/JForLc
	6S718LowD3IQdTYsx2XBkyiDF8zt6S6Ft3TO4Lv+4iEaZy8C1Mrcs6HoN2FWbkXwifsKA/ZJftG
	o19bWew1raIfzUZ806WGGF6p5PkstnMYF/DpxVW2jiJ2Gc/jajHb/epYS4k9uOkNuGbVV06Iw6p
	tAkX6ZX5Fu8SXanH9sVnKSACRYmOSY2ea0nnuEDEzmCHDDovjKmVMnrb4zw+kNjXnLE68GY0dcl
	ZfrSWysmwcMLtOdzatgmFWNVDAS4PTpoluJ/gqmap8M49n4+xsd4fB0hjHtXz0GnHjJu2kzIzOC
	fGkU+1m2RxnLX80RhRo4ZgZROSYK6z1QTsws1P3EKYUWYO1uiR6m+ByRXjElyRcHszQJwYMepsc
	xxXuWDBzGQGfQ9fTatAVkKxSbB+rjxmFPJfC1u5T6a6Y6MdwSLMw/814yE4g7ju7iek8GYEmxIX
	CXyjaA8p0ultcrtmB5JZyOUjazjwyW5IMls0eDfl2CUU4k3o+L7MxkGNDDOf3Qy8nGT1ShYhVbi
	qFoH8qGFQnNSj9Ode/1bZIEBDcYsekUNfkTVKAq9zz0KHOQiocuX9w==
X-Received: by 2002:aa7:8895:0:b0:89f:43e4:8ac0 with SMTP id d2e1a72fcca58-8a367824c35mr4636851b3a.49.1793013791296;
        Mon, 26 Oct 2026 04:23:11 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36bb2968esm1150041b3a.35.2026.10.26.04.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:23:10 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Docs/mm/damon/api: fix verb form
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:38 +1100
Message-ID: <179301327249.2.1896995843401183120.damon-docs-grammar-6@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7907F40008
X-Stat-Signature: ob9s83fjjpgyx8b813hqexi53zd5t1ju
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793013792-586800
X-HE-Meta: U2FsdGVkX1+dAd0X+zqm4AWyXGr7Ch0IgG47NZG+8JO3prrSiSowiRekG8l7lXX2Lwxvh/4bXPq3s0oEqHA7xtdjIg//8n/V/dE38bGBPohs2xXZrJObjWz/sLMBLj7/Tr3XGxvQhGPxSX9meVyHDW696RFzt9pigfSkJy4WN+Yt9JAQc9vDYumzfgc3WIbPrP0UL82b81sXdJQ/Fd3USqGzy4YV6tATf6xi26hVG2iy74qPUQB+ttTECZFjLof2zjHTohoLOxp3FthSZaUmhZCFvRGOeq2EICezgh1Mn1rz+LJzWKEsZFZQb0502PYeg8DG0EkfaqxEejDocZziWbV8gdHr7WDx8B3s1EgbTa9sp+Nji9HxNzZJ5OawxfTH2pdZkrORI8nQnAjR1qzGSAQYfhA7MM3npXL+emToV1QXve8IXSFti++1UVIOCSI33cN+DEF+gmFYV2hg1R8kWYvv5GqFcBgs+LcZvXZOquKcWTqVdiQJ5zmgVn10YbM1X0pBN17whfzlpvnLevXWKj1fXojJ8HaEw/wRKA1o6J586B6nUyc9w5I9Fd5iIbpDjBgt1IemJP+RQnjt9p/3UgPOQDtWV2mkV3n071HucavzpxMiRMVrDth5izpzIijG4IY8MP2oAYyNfTYW1YTqycMrNZN1vEfZzAKQXemcVR6UpShmAB+1R76lss+ajGd1UPXr75ol/IU0ECgCuX/IsU4Wg/raRB8UQ23MXj/GOwQg/MF9NkX+q27AG2TaLGFmsMo5yswX2ilCTafY9yN3K+x+CdYfyqPM6sUvYY88RxyTDbUFdR5+IFqC02sUM51egWEwr0Ir6avGJRjBbfso7t1mX6RnJAoaWmBcjBnqVGOEhhes58tLIsfaL7mj9GYLj1vjsVf6Jm+vjREdBNu3Nk/N1gWtnjrD679Fld0KlbGCYF4Q27Vqz1m7vePcpGNFdAEkSxUfPOB4EMXNXZO
 b2hRH8oU
 9o6d1QztDHGUpSshPMSiqkH5BpTbVLktRtz7aJzbT6dXJoIhx1Hw/71f71j/3/gkE/kSy5+mD7oYUjHDjg2hEaVyO5Wra5NiOZXmr40t0blxoy1h/VRSHsPs0lWpmi6rgE5RgFk6zsaTzIhP+cd3kWRT5GokZy9KAs/7AlsI5hRY2dzK1ZHROq6+2YI3QoTF3U6KaY7LErG1SFb4LaE1OHz/VANIPxf5vzNnc8YeRwmix55sO+MnJZHSqdKjqk4qMZ36l+gebgtTxhkrnN1aUMxkxDOhuXni9tCpfVwzNQ/k78mYYJQB3YXvVbsviTDlnDT7B93+WeAS75IBPAIwl6gZ+Jxdbk8BsbqlHc40hPlrBEJ0+DelErhC6wrRQ96cetWC4Q58efInuYFIOY6CNVqH/LwpywhsOPIxcy4LnXsriUHn3lvmjQZ8GBOPzrAUypx/xWlY+xCKXggrVD6RbRVggAuSXwDphYhQKB+oazzwNYX8MUjPvnsndhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It should be "All you need to do is include", not "including".

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 Documentation/mm/damon/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/api.rst b/Documentation/mm/damon/api.rst
index 08f34df45523..1f330429b486 100644
--- a/Documentation/mm/damon/api.rst
+++ b/Documentation/mm/damon/api.rst
@@ -5,7 +5,7 @@ API Reference
 =============
 
 Kernel space programs can use every feature of DAMON using below APIs.  All you
-need to do is including ``damon.h``, which is located in ``include/linux/`` of
+need to do is include ``damon.h``, which is located in ``include/linux/`` of
 the source tree.
 
 Structures

