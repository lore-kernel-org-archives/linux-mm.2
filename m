Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CB2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054176B008C; Mon, 28 Sep 2026 21:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B806B0092; Mon, 28 Sep 2026 21:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F216B009B; Mon, 28 Sep 2026 21:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61A46B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:06:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60D54A687D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:06:25 +0000 (UTC)
X-FDA: 85265009130.27.261FE7E
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf12.hostedemail.com (Postfix) with ESMTP id A960640003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:06:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSprvaop;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUJtE1tO6F+vL+F/po6RA6UlyIObXL7Q50q+l+HvqRI=;
	b=SkKRpoIGth9mToGQ/8JudqBp6fyjFawX1jkEBe+SXMRQI3pMJ1lHkA0WIw5K/GOvAbZK3d
	HKJYqpw8z9+LogpNAi8GOmDfq60nPoYT96wyyl4fcZnBZffP0/FVqtc4aywVLH6zB2v2fq
	nbD1YJxqaD4fKP0XLEyrmqd4+vPL+eg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSprvaop;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643983;
	b=KicZtDRT9cBhoD4eEN4Bo+5Ws7h/D+QfU2tCgozdP2zclSUKCQH34QFgsvMuQ57ppN2Ylc
	JLbcOeotrckchSo9nSdX6k0WHgK6Akocqm7WqGqe61zkCYlV6Wyeb49MX3Wb6wLoJU4z0B
	+hXqa6bjqUkToSQTFcYmsknvDXAKyic=
Received: by mail-pj2-f40.google.com with SMTP id d9443c01a7336-2e22e123350so9081865ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790643982; x=1791248782; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WUJtE1tO6F+vL+F/po6RA6UlyIObXL7Q50q+l+HvqRI=;
        b=SSprvaopZcb53FCVT+hYZ+Gz0hcE/bkbxmz1fwx+B7HTBTCyTLP74UCoTzS50MLueP
         +p8C2f4uj/xt4F53OZiOJmAjErYbJwvzHgk9pS1RCOXsuKNULUOh0g2SdztHNJAzrBWc
         ntLl/EuBwW/4zt1vqn8XKRGZaSPJqrufx8V98OgzST1IwaiQI2hHSKF2cNvSrcTqQCp6
         Db2gJu4368PhrSPUqH38BmXHdVhBDKpJJbC+oEy7WYYyCIwQMT7MBbrS3s9urzEBBoSa
         83f4MfdZnCh0c9XvpBPSyeShN5iS88WmqDylaD7fR/SzfYpI0vXkzhCwK7Hj1xbZc1Wi
         61oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643982; x=1791248782;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WUJtE1tO6F+vL+F/po6RA6UlyIObXL7Q50q+l+HvqRI=;
        b=LIYfpTSh1dU0RDMif+dSh3vfmwsRICk0HeWpfIWLBgXKZ19/ImbLDMODnkxyDyboLW
         2I80/hPjYQf+j/5XcwJCm+8QpTp9ya1xSuTbwJWPbC8ThrMRARxmbPjh0ljPyFnEPIDD
         yBMY2m1S6RXmwsrRHvO740qxkV/1XJ6idAJhWTL7v1GetG9uumymY4U7CB463wCI7f8I
         7uxFzy9DteDLDj41NcWFuwNj+cfPDGFZOzRPk0oKgFKeeNwCuTCnAMW4l0CqDprcpf7+
         kW8pC7ye/p+a+Ckux4qhXulG8x6aMtpE/e/eEo+FtqXQZ41DmBmt628ZqB99F0iBv4vz
         F54Q==
X-Gm-Message-State: AFq9FYIcHDnrq6Dj8apYQZZjfvecnDHrilKv3PlDgjk6Hpv2sRHUO67p
	QmV413I2y5GwYBj4JU5bRjMIDDY43B7g71llT/yBsYXr/DeiGkpF+Fh8
X-Gm-Gg: AYBFou26R4GcOg04h76WZl8WgXR0LrA/KTKydGBuwYokLUSP0IS1rzqvTZQcp7j5Abl
	zte1BpZR0/IceYOSrHH2+9WRQMDGdaJS68w3WTv7wrFMFskj6wb/HdJB6PQtsSru4idUwS9zo2F
	KEo34rJfLCX7hOU50tq8F6FE+d/btKYDrLPhWEqNlR8/9tx+PiXJDgj52PIafEWrOUddC4n0nUp
	Xcj7C/+OxJq9e5RSNLFv741FwXk2YvkBRugFo+rieqB7C1tXFs2/CpWy9cQF3WlODY5/mjKfElI
	36DW7+CAP2S2tcF3JCS40ePAwqmc5d0iBil7rByH2sezhQlis/OrxSFCm1Jgs6udxX0Z1b986O6
	8+qhhGjnnnKZ2RTgYcC78wvHE5k+nhhaDo5qKUaAqKEmfRi91eT0OYco0iHucmbIgvLF3eMFUWa
	VX8MlC2C5o+EySAC8LDYfCPJ8RoA1u7b/pQGpfL8N4ysZVajbekuYz7RWylOO4W/qKhiPKBWC3b
	9Is1reL2V2qhY5eQGQPYDBaHXUSkMlMbtiuE2BKIJOqaNA6XN1NcMR/8krgLso4GfIZpbBHgUhI
	OYg0YwkWB3qThNlgZSp7qyryLPZVxRc/69iLo8vUHvaXwlepF7lBrYhWcmPl1Vj4JC2QlQvDz/x
	z
X-Received: by 2002:a17:902:ef44:b0:2df:9f1d:4552 with SMTP id d9443c01a7336-2df9f1d624emr74517675ad.52.1790643982418;
        Mon, 28 Sep 2026 18:06:22 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df90fbbd2asm48234105ad.12.2026.09.28.18.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 18:06:21 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:06:17 +0900
Message-ID: <m2wls43lyu.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: broonie@kernel.org
Cc: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v3 3/3] selftests/nommu: add nommu mmap and mremap behavior tests
In-Reply-To: <1b2fb12b-a342-4ec5-ad24-14fc761e1e61@sirena.org.uk>
References: <20260926010819.604346-1-thehajime@gmail.com>
	<20260926010819.604346-4-thehajime@gmail.com>
	<1b2fb12b-a342-4ec5-ad24-14fc761e1e61@sirena.org.uk>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A960640003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wdnc63bzfn8b7qkfxc3wcxmiem8sz1ks
X-HE-Tag: 1790643983-781678
X-HE-Meta: U2FsdGVkX18cBSi/Eywuk1z2PTwGd14/fCqSW9fIgoOKmyhOxRDTCAQZrjj411VqzY7ISaTq/f8fHFFcadpBgmyiMRIVt/0EUp4LMBWZ6k8/9+PFxRo/gTmfkf7hdC0wDvvU/vMxx6b1+oB8X1RaUVJaOVnrifsZfu5LRh0Ugys0QbhXQ0IFMubGLgLvc1VHSVYWzUMN4y+GRyGLzbjeP5jAM419wN0s21t6CnOQJzkdjEdPP4/6uOjyl0NzGDy4uRJ93bEc3xgZ60J4HUeZ0/+VD2F0SlxDJ0s5URSGQLSayJyckn6SYkFMfe3vOjS7ifrBr2e/4HXuQBiOPIPA0DPpekVYKY0KzderO7d3Y+2FiRkeF395eqEfx4aHUbedAKtGZzsA3/UydOHuFG1JXm9KQOkTZDlG2uzx11pYPFThuIkMlYH6YgCol3A1PECSLqhnhpCHB/bFUUyOVr7qnFNaN/eNfdKKc1lFGGZOcuEg855+STD/bkaOfGiUxV02+eGVDwpbOp1p38JMOPSoW9JP+dE3IiwSFTv2w58w90AnenCmixTOqYfWHt7mJAee0Lqz/h6jx7NM+NdXGkSoKHanZxzwJ4WkMJbObpwpxw3aGmqyf/ekFZsiRVkreleRPh/lqx7WVMUzFOZHcbMQOG5u6goNC2LwxGI128VWOJLJ0Na2wGjSoH7ucmhJwIFQd3XgUMimqyr9egof1UYQ2TKi/XuhXPz+bT0rw7TEkhzyPYCx6FucROms5s0Fu85i0AgX2TEUVgOP5co77Q/xcQqnUzVqthKJs/aD0UM7PHolREmpPzDlY8daXxM5PJvarWtdUJrqja9I0kscPB+8CvZsk4o76Mvt0CdynujSYdLflvlKr5ULoau7qL8WAi7ae6TaIvtqWcxlFnApTvQf8f6fj9X8NYwPGeoSW/kGdwDkxS/D8e8WwGH5a/nfnCsL/IUYZCHJjNHP9iBSqQd
 oVYPfu6h
 OLLDZnro2Og5nkPJV4n8DCskRUPCw8NkPEgCT9AZ1maeklXrFtA0GR30wNEZJwRsgM1t1J3UmDR0EOR7Rsm5QD3+sHH7iM1+NyOfdgyjtXUGxNeoD752phEl4N5D/WBo1MuW71AEj2E367TlIpdkAUUbUSFRTVMgQUO2L5RN6NfFhent6NFdMEc+EbB/WGKmNeivv9wNLtW6wdVi6r8F17cfyqN+Ec3fKqgCRwieVltYcLBr2jQ1540IkiMUsT9GJ9M+KlnRqc0EaJcb/41/DvLbWR4RycsFyFPkbemv08t6pc14y09/YmzyZDIxZ6IO0JW9rMnC5VNqQXG4O0+ZqLE8skn/FXvnAyAG7PUY0pZhaG2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 28 Sep 2026 21:34:15 +0900,
Mark Brown wrote:

> > +	ksft_print_msg("[RUN] Testing: %s\n", tcase->name);
> 
> > +		if (fd < 0) {
> > +			ksft_test_result_skip("Failed to setup temp node: %s\n",
> > +					      tcase->pathname);
> 
> Your test reports should use a consistant string when reporting the
> result for a given test, that way tooling can tie results together
> between different runs.  Report the diagnostic information with a
> separate print.
> 
> > +	if (result == KSFT_PASS)
> > +		ksft_finished();
> > +
> > +	ksft_exit_fail();
> > +}
> 
> Just unconditionally call ksft_finshed(), it will check the counts of
> reported tests and exit with an appropriate error code - you don't need
> to manually collate the results in your test code.

thanks for the comments, and I understand all of them.   I will revise
those in next spin.

-- Hajime


