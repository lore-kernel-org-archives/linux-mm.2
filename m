Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28CACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494A18E0027; Mon, 13 Oct 2025 05:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C658E0026; Mon, 13 Oct 2025 05:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382AB8E0027; Mon, 13 Oct 2025 05:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25C778E0026
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:22:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2A0B13A932
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:22:04 +0000 (UTC)
X-FDA: 83992549368.01.4251235
Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA67720009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:22:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=murena.io header.s=mail3 header.b=KWZmnklH;
	dmarc=pass (policy=reject) header.from=murena.io;
	spf=pass (imf13.hostedemail.com: domain of craftfever@murena.io designates 135.181.139.185 as permitted sender) smtp.mailfrom=craftfever@murena.io;
	arc=pass ("murena.io:s=mail3:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7e4oPSbyT6o1XKtkgDqQchHA30cNRFihW0o+KCSVfM0=;
	b=goaA7y+/OFjVzUqBKIlhiNaaWkAUKtl9T9Fy0GorCBItj5ZgnTGdmCW7dlICyMsF/1Qxte
	Y3tPI+Dh3i73ZqhoezIyTekWoz7JZO7TezftcKFmdCnU8bakaFwTs5CgAkZddNrgjHl6KG
	2Iy/AwdEUmPGJEFEaXOARMj0z0G+5gA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760347323; a=rsa-sha256;
	cv=pass;
	b=25bLPs/mk1HU5BK/I9E5XsYsde1hDndFRrXqGX49Xza+tCnuxgoUhVIADougsMDUb9vYHa
	CZYYtzxTl/pDl8L4sVW13GciknVWZKiWal//yzbsrQRmjQsHkmVF4OhfmIg824/mP6TrkM
	OYQha9c/tpIpPbWy4oZb30pGTXuNYk8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=murena.io header.s=mail3 header.b=KWZmnklH;
	dmarc=pass (policy=reject) header.from=murena.io;
	spf=pass (imf13.hostedemail.com: domain of craftfever@murena.io designates 135.181.139.185 as permitted sender) smtp.mailfrom=craftfever@murena.io;
	arc=pass ("murena.io:s=mail3:i=1")
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id 3988688A3EC;
	Mon, 13 Oct 2025 09:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1760347320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7e4oPSbyT6o1XKtkgDqQchHA30cNRFihW0o+KCSVfM0=;
	b=KWZmnklHrgb53JpNCiU46XtaJg4zhgannNk2NRAkhanaIXcUrRdg9OCwx5WFf20Un+jGUn
	XwOFcrLl1QQF/qN+mwIy58sIwn1dhR8+jFcSVrP6CDRnCtugphqkfaDfNsGXyqJDb8+yKP
	0TNR9KUDxj7vKZ3J6jgAsoE0ffjkPA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1760347320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7e4oPSbyT6o1XKtkgDqQchHA30cNRFihW0o+KCSVfM0=;
	b=BrzcjlUU3iNXAcHY+ElA6LJFefQR08+H1hXRQJRcng3/dP2w6jWjScGktlBbof8nhH5oFC
	0s2lgzMiVKywXlXNrUBwHgHnV1aXr1NlW//J1Z1SskROKnaKQSckQitmms4U3GQhD/vrNa
	vkS+UDF0drWoxNoG8EkZLtWOnWeMgYU=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=craftfever@murena.io
ARC-Seal: i=1; s=mail3; d=murena.io; t=1760347320; a=rsa-sha256; cv=none;
	b=PwxP0AJIGQ/zfae6OZPyxKRCEAvpNf8EfcnkrLjQIBKFO2tS2RnKuNHcH5drsPOS9Z1VhZ
	O7NVGyHPg8bPUnXFEb+uvNtlzDvXRUz/0yXFrSTpP5uJFD83/3kfXOcg9kbSZPUHwKwHjL
	I40Fy8Kl5ivXS/7kQUO8jMXV5qtZAzg=
MIME-Version: 1.0
Date: Mon, 13 Oct 2025 09:22:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: craftfever@murena.io
Message-ID: <020cf8de6e773bb78ba7614ef250129f11a63781@murena.io>
TLS-Required: No
Subject: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
To: akpm@linux-foundation.org, david@redhat.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
X-Rspam-User: 
X-Rspamd-Queue-Id: EA67720009
X-Rspamd-Server: rspam02
X-Stat-Signature: zkabtz3zdook7d4qo3otaqd5uhhcxf3c
X-HE-Tag: 1760347322-361149
X-HE-Meta: U2FsdGVkX18VPtUiCa51gTteq8l0HLdIhLjXTgNUGDcM1jEtskoXhDVG9ufEo/vvD/nuVL0Qqr9Em4bnbAA1NMMpX0ry+lbi7c76PR/Kii3GryBd2nOB+/01ARZnofZeXaRl9vKvpLXY5I0hVDft6snS7dwLDfpVur5l8OqRQukgaqd1MCMJmf14C+D++OkwFUCfRKAwg9CnRE2/jPQ1N2Y3r1n/7B+e8Z/H5iU2Ura/evFzfitcamVcUzs+72UaxuZVsNpY0SJSteOTu2oWesitsN880YqdO+tjJK2gj19/31NY5ahvZBYg5ySp2vNdhBwVs1WR6Own5TQ/HZ79HgE4rUP1VIw16rdc6OGcZd+ibvsTUsNRmife3eXOCzTj+4MvQIzfH8omMzYCxiE+VrbnRS8C0toIyk1jHC58pB43OJfdjiYh0mmumD/EMQe46x33lyXqEvV1ih5yIiy7vlBYNRaBZpdXPCV6xIEbaPEFze90ZCdmfA6hTfJAF3Te//UnrIvCFcr35mDxqO2o5zcDxB2p7A+eGd1H6lxNnxKRA3jo7GIONQju/2hxq1tf5O7aOE2mMOm2f+oAHAMzgGcj6dTqKETgMnZDktvO3yaeITrUEEbGP2RdE1dWLa/B5q159w74pQ+S58W0U1sDkL03C9IMFz4TnRbu86hVv4HVHofCK8xcIsTNXWXW9j2ClVa8AmV1JjWxSkEkB/DUl6S2Njis/xnD32CzAcod6U2K6juS0Aqds68IHgJnHtY9lB0UgmjaQ9ZYfTS6k2nMiiklZcq8EWJPqBKwZ1wbGgNl2X0YGHW3AhHTOA4Z5G+5C1e5XDr1oWYttC4lHYNHWLEKoSyETKqRLw880WLm/mU913ddkWzbo2wqHUGTI89AwDwKtYG32DeE/xDwrJeUxaDk3E5Fa+8TaVmgcy7mmYU7Js0znCs7vUg4AiBlTDNcQcuvQSIkR0rkGx9cU3E
 ktPUkEXP
 ZYmAiT/SMSJ1RlrcIZzNqXpzBnvIKRdtXryA56AOni6sqHBWp63S4L+fwYe+j+70TrIL7BicsKihWyU4ALbfpZFefyujnGBBznOX5rsJraW4JfYHwvY1+dEgab5crA8M5+uNNgeIOQC/vlQKQhNs79E3pHJEPQmD2fFiFPPcottf5PkMdgrMvVgcrpEUJiKmhzm50QpXniFDa6QPwknI1YUNpCsxqjZ1Zk3rnNpNRAOiNVt/wqx5b4v7aJ9GJPWIt9lWK/rf/lgDEYHExJ1rPaDwH0Pp6XSKbyGZlhEyuGdGUQkZnPlfDjUDYRVYD9gfDhEE8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.005989, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've posted about that problem already on bigzilla (#220599), but maintai=
ners asked to post issues on maillist.
The problem with freezes during KSM page scanning with certain processes =
like Chromium with huge virtual memory size amount was fized in 6.17.1 co=
mpared to 6.16.x/6.17, but problem with huge CPU overhead is present ther=
e. Compared to Linux <=3D6.15, where the overhead is much lighter anad th=
ere no much CPU consuming during KSM scanning, there is "folio_walk_start=
" kernel object is present (which I reviewed with "perf top" command) tha=
t is not present in versions <=3D6.15 during KSM work and which is in wor=
k starting from Linux 6.16. This method very resource-consuming compared =
to algorithm used in <=3D6.15 versions. Is there a kernel parameter to di=
sable it or it needs more optimization?

I'm using MemoryKSM setting in systemd in user@.service for KSM process m=
erging and it very light on <=3D6.15 ver., but CPU consuming on 6.16+ (6.=
17.1 without freezes) due to reasons said above.

