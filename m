Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6234EA4FBB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57326B0089; Mon, 23 Feb 2026 08:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04EE6B008A; Mon, 23 Feb 2026 08:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C112E6B008C; Mon, 23 Feb 2026 08:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A971B6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:21:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6281A86125
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:21:56 +0000 (UTC)
X-FDA: 84475784232.22.07B5DF5
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 942EB40002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:21:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOKMwihr;
	spf=pass (imf11.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771852914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FrKEaNkcxR2JmUm2fYbpM1boHjP3AZbiYithOhNPIo=;
	b=Pdn6HKtp385prVMO2pteKn38/hUC2W+sre4oybbbP/ybXYR4pXGLWJpfC4XHUozfuxhu09
	oLFTT0yLl7yzJ5h1L+xd8PSnYTLj+ddPW3EjdD5uf3zrXyp0NUZMrVFRqL7uAE3PBC9/SP
	yFhbuAzQPe42RaQYfH28fOr0rwvSbYQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOKMwihr;
	spf=pass (imf11.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771852914; a=rsa-sha256;
	cv=none;
	b=4Gz8lG/3BHcHteEVW/7ZzWtJ85n7CG7hfWVjo3BfdDBFmcuCNXJSQJmQ5gjkhDRME1hRh1
	xr6fPlGxWQgP/8QlI5TPA/mQLawxNqojV0+5SZwkNmQyuPKygQ1jZO8N7Pk2Z3MIYuryDa
	eRXiovGJjd0BLixAaTtfAZXtUE414q4=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso4274730b3a.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771852913; x=1772457713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7FrKEaNkcxR2JmUm2fYbpM1boHjP3AZbiYithOhNPIo=;
        b=bOKMwihrPC5AQdnKPtISZkbNZTNTFEWpDjIWNSw2yTkX46y3fEGjq5diJ/lFmwVbqq
         B4dMcLOZzOmcVo8x65SqJQVtpD1GAHJlaL7nzEzz8Q9g5eif2kzeCAbj4Z5EF6Kt/ddd
         1Vy1CFL7/USkjQPfAxkRKsvvxiLtqPAhxaRWekJw+PlwTQzHlHdL7BEWIz3xnSiqOrdZ
         LwB/PGOAPg98A3GQ6Xe5220SIUlzVwtkjplKC1awaLAHRmhCPo8CPWiI/RMFOsroAdVH
         +6rxvOiPcPL4Ss4HJTI8ngNlGYjq9pVpuyp7Bxpx1JLf1dB89rdb7t6qNYAFrouVEBMv
         42DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771852913; x=1772457713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7FrKEaNkcxR2JmUm2fYbpM1boHjP3AZbiYithOhNPIo=;
        b=L5EMv5HVulgLSw6Q+R13mjEL9vP809jVyl5iN8U1/Adk1rd5cDMUBQSz/6P55JUG8W
         ccwLWWq/5Y8PMckZEqmi2JM1AotBHOGs0INSz+uBG1Bsq1vbvpFhbMrXa4kTkFtoK4nK
         pyvAqTeh44KRNSXRXrsABIlRnlG+2uW/g5JIwqITnrK3Qp34tjxmqwecpXuV1hhFGYJM
         T/rHanQxdWM/Xve+hW+E177TEPVswL7g64jrDu/FOfOVPNlxYc6idCOepPYJ+pADLyIp
         DPLIh92x1+dmDlU1Wr1v9fUxa/eHopgiqYD9Im5h/mLNy237rig/lXErCQKV/KcSIVud
         hk4w==
X-Forwarded-Encrypted: i=1; AJvYcCWaWdHKxyP28vvXk1qUSOW9lymJWfxvJKjKW3zSxZc/8RRnvQkqce/evLt4At7CSYxYCWQp4rknIQ==@kvack.org
X-Gm-Message-State: AOJu0YxJAt+kDCsCytb55YrxPnB//Tjv9ulGq4bLK6Gxp6qRErxX2u5A
	4hNntZQdDJBPk8io8qss6/62ue7RNCpp82LU4PgCX0amWAcXpS+049PJ
X-Gm-Gg: AZuq6aLAbFZEL+UQSZqXXiyR0W1Nb0pR5YtZFcDS342YeH4eqF0J4nvIX6Mbh3uKk1v
	WL/RD17A3YFXa//1zdMR8ug0ZKm+ZfMbUytuZt3S4iUVLi5z9oEk8HP/c+m7c+D4+745Uwpg8OL
	XVC5Cur+6dnbm8fFbTWWE7fieskgU+w4Lhe2LTTEJsajywgE2os2kG2Po1muuTVHqN8sPnG2Hzq
	5sXU0GpcJygbcGk/YR/6rWhR+u3BP1WWP/PcFgnXpsx0Uy0q9XbbsseM2gdQ1fRjGYPiV1/jYpw
	9BNwjs9arfnOpd/CaWckMEf4SbW1X9HQJ021yfeZF86mbF2NSKuxKhdk2u2QLV8oKkmlC6dWZjn
	gkg+sAKLDrIYd69MzmUqk0DfyzfQJlvJjEJNW1lVYLAV9/42TBUmv10dAD2g/ygX3aTr7/x9FQb
	pZtuvdUaxpmWebm9dp/idL6pHmtfZpLzFkW5Z6Ira/dXKE2x1V
X-Received: by 2002:a05:6a20:7f89:b0:395:1b4d:c67f with SMTP id adf61e73a8af0-39545fc65b0mr8195844637.50.1771852913354;
        Mon, 23 Feb 2026 05:21:53 -0800 (PST)
Received: from hu-ckantibh-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b726b1d1sm7375090a12.31.2026.02.23.05.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:21:52 -0800 (PST)
From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
X-Google-Original-From: Sanjay Chitroda <sanjayembedded@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>
Subject: Re: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
Date: Mon, 23 Feb 2026 18:51:47 +0530
Message-Id: <20260223132147.1582608-1-sanjayembedded@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <00fc801f-6a11-4510-2b77-a683e5e37c77@google.com>
References: <00fc801f-6a11-4510-2b77-a683e5e37c77@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 942EB40002
X-Stat-Signature: 8b7sn1t351w9x5af9wu8guf3f5xukyfb
X-HE-Tag: 1771852914-858971
X-HE-Meta: U2FsdGVkX18vJrK17Y48s0hws7wwkLvdELPjYHnPeK8hhJk3zhdPj6jB5hR96SeBPZ9+c+5XNUK033yX7A763v1qhvJ+NeCYGr/HoSzO6hNiBO16iBi6hdVBmPpH4V8+g+1GvxMHNI0GpcmOKJc2aXTCdzQX2brkUYS6U88UwUHv9vrEQXoQQqxEJsXOeM3uVEuvP3to7R7Ki0ta3mVgWV/zUh+bam5K1nyPM8teWtujU3ZjfFe8gM5Q70bslWHI2WsusKpRXl8zZnAgcahaWGjZdOotgeJz3PZL55T6m7yU7Mn38fJX14o8Tve49AvgHLr8lcGnO2rO863vK4/rT2QLwUQaqVeFRKfMUPLMXf4gr2XT5LK1WtM4QHPZrIP+HtnH2e6KQJn1OxjtA8J0npIHRAx2H0HiIO9I+mVVs19MJQpyCeXKfdiWFWVECVVOsuCvWb7kTD7wkZK4yYXcuxj7XjX1b3FxFFUi+S0CtaiHlDuff6qrHiyfzoECD8Bf2wD0e+wLvcGtjL3XrSR4GDQ7zzjwuILVE+iCYUbB28xTpt9fyHLNp3QOLdom9VccuqXUhTnMdsiWbe50hxJwbGw481ftJ45aPhAYz6j6W9ws0K5T0dgmItxMoqfLFl8Ck3a5+I0MtfCgRHeKceYg9RGgVRXVvaJA9rX0aKTz+fEtwnTSDTEMpZTwPnU5qpzoNntOA5EnO1pTj8firUh2DtwHoD2jPAWK/KSHgbMqqPN3L4BDSXSfQsre0MNyvu27PrWfii//8Boyxwepg0SoiwKrIlJl5NSMZ73Q+ZrP6xmIKlPnjoIUP4Hxgxlbjtfb+mu/uvP3QZSEeSR2xs6gWiZ3+1Ey20hBgVwXnkZyYCT2q5LCPTGNS4xQg/HafdN1uRUCQeMnTKfe36Tkx+lrMQ2NXERQTZorRDQBUCngnDXUo7Nztw10z43N3Cm0rhHSBD2i2wEk68Da/G99stz
 RMxmnJPc
 87sJ/Vw+ILTmic3Sd7BbqL1GbAb7JdAroI9xaEwRcQBQw2M6kqwupnA3uGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The header file kernel-doc looks equivalent without mentioning that it
> returns bytes.  Might be best to make that clear in slab.h?

shall we add dedicated change in slab.h to add return bytes information?
this would keep this change as clean, what do you suggest?


