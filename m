Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BEDFF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899406B008C; Tue, 31 Mar 2026 13:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8710D6B0095; Tue, 31 Mar 2026 13:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD386B0096; Tue, 31 Mar 2026 13:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A12F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:55:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 157691A036F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:55:04 +0000 (UTC)
X-FDA: 84607109328.28.E512887
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50399A000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:55:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUu9NuQP;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774979702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BO7Q7fJTvO07jMNB/2HEJHgEeGh8y95froHiw59EioI=;
	b=cm823ooD37yy5oKXdGEg5LYXE83F00pjdjO4hwDOJdSrz3eBbRADJDkkd+U5tBoHC8wI3A
	qXdYltquIVDac7fXsqlcO4Da4hKDzajNcsW36S3QZF0cj4HrfzDEaojusuPYYazheW95q6
	R2G7e7IqJxQsw9JsQF+6zU79vNUyiGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774979702; a=rsa-sha256;
	cv=none;
	b=0XmafqposXvleXCZEayEEI4aUWS7X9H4UnMFDb2KPseqAiXVeIXGYOTopGRzys9Hxyrqcw
	4isua2IgzbYYZY2vOxqxFgcZvY/KpXiJZF8nYpcd0h1Tj/MK2K3Paq/I2O9YzD+dDFcsjD
	b6PHH7E4SxlCQWe5vuXtB0cF/+9cSbM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUu9NuQP;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso55176835e9.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979700; x=1775584500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BO7Q7fJTvO07jMNB/2HEJHgEeGh8y95froHiw59EioI=;
        b=LUu9NuQPyLg/PeCOkWmFJ7T/xCfzvZVqsTvyZEzqM+5Bj4F4quYLZtX1Y7x7mfcagK
         T8/Fxknevwy8ID5jAPJzlLaGlOc1Odlwd1xcRD6BGOf0MtRVTlMBdhCKQ0iLHEvWR43Q
         Irq1EhmmuYQhURAWgoZCiJR/NDTjztGtgswSe6O+0zov/w0H3Qkh6aqUKfdvLj5TPRqH
         U2eQ0f678seyywie1avIqly6eXQyr7rYIGykdGP6UFG8biEQGjwcMZX0MqmxUOM+vlUn
         IQjveXEUWbMLMW1KEb+wV7MiAtXtBj7sANINOvmHLmxuFpNWugCZZoRYDhU0HvKIOeYJ
         yFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979700; x=1775584500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BO7Q7fJTvO07jMNB/2HEJHgEeGh8y95froHiw59EioI=;
        b=DPb2fcNlTXhIIRzBpBjJ8z7AQb0JMBiMfBR6stCKaqOhgMglg7vvRaiHkRpyIyzLUu
         NFzTBRLTGcqrXB/JtF9DCwMa/pyRvbTOzRupe8Hg+ZgjTT1m6WQukMZxU8gipbYXvPdr
         dglM5CRAgCNn4dgIR0tplVv7UfOq1HHBnKiTI41NJS+C7MtpVEmVDbp2PedmYK4yL+w6
         dsx/OECf3IptyW8CntyJGv/qheaJLuzkLsIkYkQQZoPIBT8VxAZW22N6qD5m5WuAVy7d
         iTr2VMw74ykFarSN8NY7FP7BCBCPoEA8L3EzbQVeKAn9Q72UhmKMBmTuQ16NZJ5E46rK
         31ow==
X-Gm-Message-State: AOJu0YwkPg9i0ykudxOlHBRENkcj9D9cH/Fuw4L2e7jLlTyKgRa1r2He
	XlTfzgbTlSzgjmQRyk9NSU9NgtRatrmxIqi6oYRzLBztz9vZ3aQugWmf
X-Gm-Gg: ATEYQzwEPc9TvEqaqEPYhRKsff8CMgR9eetc6smGGLXQnj/kW474FEUzbba+aBECgx6
	mhJgAXgn6IVOF52Rn5TMI5L6LoL4i0701Y8ak0rGQuzf1HCI6uAwfn+EGYasV33zhQ24SRrIdEP
	oZptZV7qBAUrlvc/n94e4RyTBalySAnGunypnwjl/KLoBIzjW5zVmQ+Yz7EpH5VG+9nnqV04Cll
	sW1c6or13xl46yKp2iXP+qXP89+BsnKup8kbDMTp4lAO31Vs67bweyAYFM5y1UeCqOwB22EiC9R
	0Xib8oR4vLt05mN4OiFkwdoWxLstYpbEvbUbe6u5mcKraGGuJrnbcWcigKJXnbe5SyCziRwQ/PI
	4W2nukeo4j81rDq15Mk+CKurkTGT0X1PhwFqqAfD11girvTx3DBNr1H6q4AmES20MesAHs+nw5O
	hppmRM0mjA9cjl2LZNzjeVidMZujdB
X-Received: by 2002:a05:600c:818f:b0:488:7ebd:78 with SMTP id 5b1f17b1804b1-4888359d302mr5083925e9.14.1774979700154;
        Tue, 31 Mar 2026 10:55:00 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:5ed5:ec79:be2b:6da8])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4887eb5aff3sm70585735e9.15.2026.03.31.10.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:54:59 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH] liveupdate: truncate getfile name to NAME_MAX
Date: Tue, 31 Mar 2026 18:54:32 +0100
Message-ID: <20260331175456.4065874-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50399A000E
X-Stat-Signature: ipj1snsqpoqqgqe4faoi9xjakxinhmum
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774979702-311062
X-HE-Meta: U2FsdGVkX1+Zrs/1qb32VK8gb6kebNwinyvnni2mFzhPSysIf2M1ya2PuT4irMqEITCf46xMlA1qFPjHJNHLMjt/OeSST0L1YE3q1U92rjiQ1vt8aONdMLEyuipp71YhNwUPMKBR71ECIb875+TV+FdW/0rPZzkjfRwl8lJCutM16Vz31PcxnXhT55dzmxJcSW0rx8sHr8UUVN0Te3BPdlGUL3ipBt28H8XpOFTUbzPBhAXS/K2C+7alLO0vczmPUioQZs/cLfklsXlijQz8wWx/EyodfgYq7h3TNFcIXWtAakoIaX/Q4jUStRFmhwwClX7JBLNOgnUgjcAHeB1uZHHjh/cy+lVx1W3qmwAGJ7AfTWzxy0gfkggrqtUyrW8Fpps2cCV1GKSj/AKl09TRaELPPXCTrR2bhA/Y38FKiqE+oyXGpuEih17ckyCUBHFAThF6WadSMocJEeCxD9H7uNM0D+P12HQc0+d9seLnS42yQkbt2q4QDrM8NygdmsEmQWBYzw/JwCGxjJ0P2C9JwKQ76LZnVI4nvcM/zejs5xt4gGPgTSJo9lGWfCVurKFLFY0u2u4RtjJMu0jSIj00R/S6Fh930fLO/BysuDPrAkOy/vzcfarujnjYhuWTUwNmvWEernHjzXbAH8dRaHZE21i77MiXZGbWcSyQTd2L1RANiFkZCA9QoUnK+QfkmfVP82E2RfmbElx+wkOdxmVnJ50EpeP/Qr6ECbw6koP3rLOOE6EpiQ2ZEwvPWKYbtcc42Frxz+RKS1V/8l9mrZX89BZ5P8sfMV5A1aLujo69JD0PSahRD2YkKf+KKUKGEOqHsc9nOK2mGQrMcbH7rio9V4oT+g1unLoQF5luknjSxSe76nwpgeW4qMo0fCelgz2jVfBfHo+TmuTNze0z0bg8lqq7xEyP/rv0RktfPFLITVI4wsXQ2JuDG5SrMhVrJT84Rx90y8FWNtbOdTDrhMr
 DURkA+JT
 bFNNLsFTCfP2aZh2RZbsY1crROiXB3N7BS+YVi6RhmPx+RA59jABYYbelzPfN8ztjV/BFAgJbzFXGlcc8YRVL9BNztkGs/40mcuM5oyjWAe8MzbKDBRTKabnhvYS4IAjcimVO6Ru+EE8ywwR4h7nt1C4c34246Tjj4y0I4m1pYfqXKD18/9upD5JRzlQrsPp4O9LBKx1XrWbi5amsvmYhswTQnUxz5KJAqbe54kCA76NhjzE1Y9UEd0DVHAemvR+Q08ohYjVXMc7pAT3IwouslSKmQ1VXdgPpjfBmyG21lYUJfAos034LiTs/17CAEsCcQUfa0RV+KTgGRupEeaVscbSt1u6UmAtIMJV7Ry5fyMlLOmsJyn7a3yGMExulGQ+dYoSdvrI4dgUXOMXvTLjLWI/odnt+AJS36LTBvX3NQA0q0HR0jaaw7Zv/97Av0B1sV9wyFxpv2yENF/IhWjG+veuPKIhi85Du8nE5+PWM8UtFdexgIr8YhL9dOvuIyP6nM+/iSJgOA8ymBd+d8O8BSXqFDw/lGtKhKcfDGkK7GtmBOOklXmflY4jCtSci5/LtYmLkOOVGWTCnRcLeg2JL0hClpv+M2gTqhpxlTOhLBlzb9X32v5UB/Oc8Ms559l913sUByR/7j8bvQpp6dRCbpbGI5gtRp3Y6LIveMOQOXzdz30Utyu3A+BxaHBo6ddTwbY4vx12fcbEKwUvG8oqas+2LXQOhhtD7jA9GxDHD0C3MSKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes a
NUL terminator and a 'anon_inode:' prefix. If the name passed on goes
above the limit it results in userspace getting a ENAMETOOLONG error.

Truncate the name to NAME_MAX - 12 - 1 characters to ensure this never
fails (accounting for prefix and NUL).

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
Builds on top of this just sent by Aleksa:

https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_max-v1-1-8ca20ab2642e@amutable.com/

 kernel/liveupdate/luo_session.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 7836772956406..4a40c7fdfb44f 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -366,11 +366,14 @@ static const struct file_operations luo_session_fops = {
 /* Create a "struct file" for session */
 static int luo_session_getfile(struct luo_session *session, struct file **filep)
 {
-	char name_buf[128];
+	char name_buf[NAME_MAX];
 	struct file *file;
 
 	lockdep_assert_held(&session->mutex);
-	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
+	/* dynamic_dname() rejects names above NAME_MAX bytes, including NUL terminator
+	 * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 - 1 to avoid
+	 * ENAMETOOLONG. */
+	snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s", session->name);
 	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-- 
2.47.3


