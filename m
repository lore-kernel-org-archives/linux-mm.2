Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4F5FDEE55
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527F86B008A; Thu, 23 Apr 2026 19:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFA96B008C; Thu, 23 Apr 2026 19:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C70D6B0092; Thu, 23 Apr 2026 19:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28B9A6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:49:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF246160628
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:00 +0000 (UTC)
X-FDA: 84691463640.29.E6B4A91
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C0F7180002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:48:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KfFsFxoA;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYNhBHB4Fa23TFERZL91AZqtbkE7rN6kiCnLilTbtsU=;
	b=ou+cBiNGx6gXpmHAAcKmNhnZqc9j9kudiZE56kqM9+6/lwmQPGNDllvHh/l4EBo0HZQfK9
	ez0HcTqCFai6ahw8pnNcWwTjw7PwrCOFotZ+1Q+TZ5ayhic28YUrsKnGeP0l9KOuzZXad2
	4n2h43FstrInTs3Sye0Fi/EvfmpZly4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988139; a=rsa-sha256;
	cv=none;
	b=zB+tE7bmUrmzbtCwWgdLFnegalcrdxPf6RJr25FCfC+DrGeLS3xxIc0pDvn8JW7YHvC/c2
	ENn5Ogi/Nyivz5FP4kAAPhw/hknw++GXuCe0c2Shn5z6g6eTMGIEnm7qnotha5Y1YCR8nt
	FibkeZsxmyTGvGVgh9mLjRm2NBSGYa8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KfFsFxoA;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488d2079582so84186545e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776988138; x=1777592938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYNhBHB4Fa23TFERZL91AZqtbkE7rN6kiCnLilTbtsU=;
        b=KfFsFxoASSJTyc67uzNpnm54cQ0fYcAzZlRIaXEIoBq7Jjcpve5YGizeEwvg6hAgg4
         ep1OC+ZatmWK7siQ3TdSQkSTD6+iyo6E+X9UQEiGO67WwSDuNox0Srsq6/rGpvrHK1yl
         k69F6CH1TCCCQRFL4TKkqxnI9iKaWul3Fv30fWDUhcWGPTT4f6UOsoo8Tm09BqlqJ3Dx
         S6chS1ECj3n+tSylwcxcOTolvdjiAtZt8MhMllEYfUNLrpmxwplDaTvY0tYzAGukC727
         Qxk1PpmoamTUXRfSo0h86dK+MX40Gn+2QWSJ52iIpxWlm2msIz6fZJqO8WmwcZXYryDt
         uvyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776988138; x=1777592938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OYNhBHB4Fa23TFERZL91AZqtbkE7rN6kiCnLilTbtsU=;
        b=DK0ke6koEbG89JRA3h6r+FxGvJeolxiQtAhVD65XOo6stSXyF9AiP6Jyo12lQhMsqQ
         1VyJW9QIK02lf+WrxyHojNVOfP9wGyJe9vf+hVA0wzSPrL6TaSV/6GiHCQIy8AKkKdED
         wJmEa1zVghaPSK3FPcPqjXw6RXFSNMIW/1p+JKJJLm7ADG1a/F1EOsVj4MFCMJrD6mkm
         8SOZFAYF93pDYZKVwcV6KzcUKOJ4XgIoHBkguDmvASX40u8hil7cm7kmeLx2g36tn9sL
         4Mnnf5NgcFSdl41H1HdrCgz+7RBXu15HGFcku5J/z5kxqYFZhe6sqH4j3Agn14ltga17
         imTw==
X-Gm-Message-State: AOJu0Ywyup+KT2DquEoZjczJhl0hEB83hLEI+sdsbxmfpAbG8feukwn+
	qCgWAO28BKmUUYxMMD5urGxKrQhlulgd9mutdrTdnNxGAQBERwY9A4EL
X-Gm-Gg: AeBDiesmabgMVGKuStLJSQAGj10HH/T8POk2dylR9M4uYndzvB4kfLV6HiQEcWZmKo4
	PB15fphGFZy892/Q+oFLGZgpu7lJ2I4+s7Y7U4he2lMXJ1W5TS5h9mB8AV5n4d18NrJpGhE89lr
	A2lQFirTxXyyGHnzVPABFLCM6VCJaVZHXtXmWGrl42FB6l5C4ESBUHcYcrO2jRRBVMQjIax+be6
	CsWdl8+5RS2/5a5GciAT6cyHokErC0Wo6f7djNBmEZ2MA+m3bGcGq9OH9X0wMN+mgSPK9brUs+T
	WQ5LMho4Y4n3JruKdpozIchQ9gNu8Q+fpfUoK+uLKoQqI8ZR/vT5G0tFN6+ORUQdLReKJJ0yOJn
	s2b56ZKzO11iEnFGXPIleZdJs8iqxOnJjXRzapF9kueAfP6HI+ZaQAO3mgHWV9zEeP5hI2DplW6
	Xhg+O0FPAJniBj3HG1xJg3RJ4uEgoH80KMeD13zxA=
X-Received: by 2002:a5d:5d0e:0:b0:43d:7883:87c4 with SMTP id ffacd0b85a97d-43fe3e17215mr46363156f8f.41.1776988137621;
        Thu, 23 Apr 2026 16:48:57 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e8d7:434e:1f34:2cb6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cc2cacsm55713327f8f.13.2026.04.23.16.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:48:56 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v10 1/4] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Date: Fri, 24 Apr 2026 00:44:20 +0100
Message-ID: <20260423234753.3873095-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423234753.3873095-1-luca.boccassi@gmail.com>
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C0F7180002
X-Rspamd-Server: rspam07
X-Stat-Signature: hzqxy8jkgpbo1zzechz7znr55sihmgyt
X-Rspam-User: 
X-HE-Tag: 1776988138-722888
X-HE-Meta: U2FsdGVkX18vifDZ0l0MleBMC9jhNNOrpVMdd9vUSuWWooUNOi876K6s92r5lfHIEIGLUZFaWDKOKXu1XEGRnW+a+ZgB7w3Bicciuad9lBs+B0A3h0J7ZIf8a6/zDx6oLxngehS4g0Eherm9FB27/6wziWjXFsCCF0tVY1An6V2Yrx3dHiM2/WlgaKma8/ipoN4YXAvM7TynRcdAPy8PXAzAipthAhTb5Ba6iYGckTGVPbGu7qOxEyuwqOjI/6vegbpvtjzjTQZhrr3W4B+4Uz6V4BDc6Utwv2mmy3axEUPy6PRbwY6vkzLQFXhJu19wjiG750vXlJ0lSsi5jmHtT/e8c3REjxtcb7LkG2YEQfoasTGG1ExXkCvKrJMjjMT23zP+odpu1z8JMOE1QFLAcAmvNsv+MbLJr5Vc3YBl6a5FZaSr/Xox7oyExBRgmmTiq9rdz0dyRHQgNPwFA7/9LwCMfp+nzfAp1GX6GFEJlzYwU7EQFpDf4ckgWzoZdXvdZiCbVLs4S+foHOGW6aXHbDKd7OxUVfRF245YzJna7iADtyMJNhG7gYqL80qE/j8/rpqO7Q7VYMpO/iIvT2meofq4KDBfT4jW2mft/MykACYTKqbKeQRs6FnxnGnPU+dBlTep9K+3fsHfTMm5g1jRMXX7X5VEJ2nj5MW2y/eMDPkB/xZ4XzB2q2FDppjv4gNIDeCwf9Md47dkBR57kD24iEx0sji6nyLWNu44eO1PX4bipYuHuWsd3V4jJXcdjf2C+A7NX6i3ajiX1Gw1ERE2NaveD0RT00os6feCyp5fkmuB8YU7uIOUnmkk8/etjHoJXo/zP64Ab9ZKlcwq0wbzpaDiQwyD6IKpAaFUaiynGpmgAQxazoUw4naZg7nFo09fOBfNxvXhsODqcvQYvr24tv5OWtQW1wjfqQV043Xsv7HBxE68KDoGF9BntlQ8Jhm52gLORHop3ROPTGTLCbm
 nT+NdRKm
 b7eQc+vFXK3E3Jnpwv24/f2lLnNwmlH77qweG/CkY73X+bS6U4nxfrJ09qreaRK3r2PNUqixulztMk6NuhtB1mWaZ1aMUjVFuU+koUQkNJOpWaUWZixXan1WuTLlXSyu9aDE9nFS2/56blKjy8UQr2UlBjJWs6qpXtdcXblUc0OhlqImp+cidjE8oF0+wZvfgNIv3tCO2rZLBwqZqJAnxBeysX1VAJwCxHFWtUtB6kYN6nuHedE2MBvGIRjTR7xb5Lrmkion2/g1IplktGVRvfBF7NwGX/7IrSLzK37ne5lrHDOHDOhGeNsnmiGgE5ljFgh6e80/a730eS0bkbRvE2prorMU/TEZ87J3vwJXPufl33eYkzJ1LX0RKNgLUgYRvMXqXQZCi+4ufTCTmfscL2j01zo1D662DKmNaCt322UEH0PH3z0Rb+g/UjYdb9IJJmuym6MbLzugAKg7U2jbIQ8MegOxxTy9VFPvZtIyA+ndmzN4D/prWc6jhqTrnqS5eDhLYqStwUGqzGjblAtNPupWD+px3mAM2nlm5cj4kYCiMghPjYdxrAxpvpys6gwEiAfIRA3T2ACcOLE9arG5LJbaQlJ1d9/zYo9co687XsmUHMW8QBKFY+kyzsSp5ZuQzplJXpDLvNEAFPMZbHNiq1L/3bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A session name must not be an empty string, and must not exceed the
maximum size define in the uapi header, including null termination.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/luo_session.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d7787..5e316a4c5d71 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -382,9 +382,13 @@ static int luo_session_getfile(struct luo_session *session, struct file **filep)
 
 int luo_session_create(const char *name, struct file **filep)
 {
+	size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
 	struct luo_session *session;
 	int err;
 
+	if (len == 0 || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
+		return -EINVAL;
+
 	session = luo_session_alloc(name);
 	if (IS_ERR(session))
 		return PTR_ERR(session);
-- 
2.47.3


