Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67045D31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8696B008C; Tue, 13 Jan 2026 21:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C6B6B0092; Tue, 13 Jan 2026 21:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EBA6B0093; Tue, 13 Jan 2026 21:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC63A6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:58:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4949458677
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:58:04 +0000 (UTC)
X-FDA: 84329060088.22.0840557
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74218C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:58:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H45tM0Ei;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768359482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb8rwnsuMbygV2NKFyD/w8kWzaNcBgvAZYAG3Un3Hx8=;
	b=yVH7Gld8WNTHuHupcE6O7ll0XzyF0bW8McgRmdjDj5mJt4Jl+v/WdYn1TwzSCqXlxbho5j
	hYhZx+THCEifTGVJjkK/T7wRi+y6YrK3UiC4la5at1/IP0fm3ThFEvAp5KeCwsQxL7/SNo
	ndHdu3p1o9LAtEIx1MZZskyRlHY6jC4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H45tM0Ei;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768359482; a=rsa-sha256;
	cv=none;
	b=v77OAGeRcRc5jeMTqnWbIKzCLM0zmrp8CBq/PnM0RrvC/To2rOo658jZ5pXvnEmHVagB/N
	m2hKnUEV/9ENJBZtPmwpY5Ja+zlEbK5yBrEJOSKs5xQkujLNM2d/aEHtLDu1IXDO5Wmd+K
	MJouq+HA0rrRi6zIKq4cjleI0NUyizs=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-121b14d0089so9288903c88.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768359481; x=1768964281; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qb8rwnsuMbygV2NKFyD/w8kWzaNcBgvAZYAG3Un3Hx8=;
        b=H45tM0EiNwRdFds2D2WSZ+QtpjNfHEWstBMfCfLWS3OhVrHiQJag+VcDfDE8n4EMkJ
         AP38xGHWUg5XmkviZlOwf/PKml+mKSXmeDgJPhikZTD6ChMkmRdB2zFXMIZde5MuQEK2
         bgd9DuhGp4i3b/3PzVT8q61SoqkXxM71fG3fp1U2A17qqLoNThj9eOFnOuIo6AtfAj2Z
         YvIdCU6h6/ScOETFqnl6LqgzflX+SEFaxDAEHNAoXnlWhp3CubouB424pQaFI+tE5OP7
         USYy+dqJum8xC5qunPGkOV3K1ghk+eUfGZRa9wy03QA1c+XZ331zNxFIYnR4kL6LQoKB
         AAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768359481; x=1768964281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qb8rwnsuMbygV2NKFyD/w8kWzaNcBgvAZYAG3Un3Hx8=;
        b=KffIAPFaHyIAzLnxKJEplRHTpV9TNCmKsX4OFVoPWJp99BmxjlLEbtgU+KGh0ZpDAZ
         RaotD5XM8hP/pQwxtCxu+K10/Jl968mNJ3aMA7N5pHuPzE2pE06dkOSrlGd5KBcimjyT
         Ws/DL9StjYFknfDYu/vvYmWz7vKspEYsj3xHzfalNaL7qzxWWsSp91NfUiehaBVw/3n7
         9E4jOadnQSw4txI0kHjHKTAr2XVom1nzPWXibUrGiEJlMJBSgfsSYcBPaW4Hat7yjWGM
         H8Zl1F4Vjs0WC0V3C6EpsNWWtXMx/U/3coieBQAvCyP+kgNw3bJn3SCC1MfYJ4WkS49u
         Hmbw==
X-Forwarded-Encrypted: i=1; AJvYcCXekDTtkFV1yMcKJeqKodRfMC3wcXclEy67roaXF9tMHnLovzzu8rG/9/P5fMAotHOJMZ+E3M2NzQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6Eo0CVeV+0OTsImu/kMpONIrjeqGZcg5pWGaMfV5CapO/LxHs
	z4RzigGD3RNbsnHlayaB9PCXLipRBKgDRskkdJhdtbt6q5X8QoAESx3G
X-Gm-Gg: AY/fxX7m/81SrrZnw+lrzUkYdKRlnDgyrUJao4aQKGbwgnaElUnK6K8AtgVvIHMq2t7
	7DN6ZYA3a8+akSgvMm12gHnM5QGjOlsrqcnb9N0/mX9wkt4050SVFexWr428X9XlCbNUT98UjOC
	czZvpbmPqtHyrXRUCQyqIPD1aN940nhhMQhW90fK+I63WoR+i5kA79aVExX5iUFidKhHKDOhX5g
	fOG31yaMraVFKJ0F3eQsUNKWXsDRIxZieqZ9964qwZZxz1XE86GgdX1hqUtc/3IFQStCOqNPPP7
	OcJysBFDSGN8jLmU4j0OL2JEL14rRbmBkUgwzxl6N/p/J94WDwVS2Nju+uB0EVDh1FQeCXjb2JE
	NWU6VUCIoHsw8AkdOVLljDgHk9QmD3d0HOkW/4PxrLivzyKn+qsK2WR4IEqanDwelFM7nmPBtr9
	rG
X-Received: by 2002:a05:7022:e803:b0:11b:b3a1:713c with SMTP id a92af1059eb24-12336a0c131mr1161500c88.9.1768359481063;
        Tue, 13 Jan 2026 18:58:01 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243421esm29604541c88.2.2026.01.13.18.57.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 18:58:00 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 02/11] mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Wed, 14 Jan 2026 10:57:52 +0800
Message-ID: <20260114025752.82096-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-3-sj@kernel.org>
References: <20260113152717.70459-3-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3i6dncchihp4xseqmqe77wcndp15rq5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 74218C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768359482-17635
X-HE-Meta: U2FsdGVkX19KNG4aESokH/LVd9L0u/BlrsdGSmhhyMkk4kVxoe0IwiU35Qn53RRbaoOXneuF1KZUqENiE3CqTs6f9IKo3+83uYriSPgvYPjHhw3SVMHF+VOwerNreudVuuw6aeI5Fbe0Ozj2SA759F0cgLFXsZ8Gj01TeI8hE4dbVuACub8MMSqG51vKusbpBBD4czQ+QSGmiAsk47mBwWYPBA2EeuwO8lzwcum6PW/Gr5vgpctEKwkYEfLbt8Fd+iYU8BJL/pYUL2Dev6+OPjiEPaRe70wTmgke5xBmdXjrPRE84e+4T9RQ832YtY32AYudXPq+IQiwD+yfoeDvxPPaTLoNZ6G4WRiMZFKbQEHbCNJsPO1kYq7x2BH4WGvwSqgI2B8otSByYlPGu7Q0j9El3wlyak6ewlUb31Ttf8wJNZresYQdJdPR9pL2RE4JU6MBuuM8g7adD4mCOaYB31rgWBW7CiPSiD9+Az77PTPuksg4XZzMOelbwtv36NS93obABYOBePUtM/2si5uKL1iKqxoUosA3dt0MwwZn9jDiFMyV9gMFdH/jYXWxtmS7dKgO9g4PM03mYihdL4Jb3sOhAg8aRPTGFBSJny5mmhZEFC5I+8JJ2an25pZ1bll9ti0avLf0lqFsPjeYUM0pRMgO2XxsEIIGszM4Km4OxLxpslubnIJ7fKK01cXSAzBny5b+cjekXOKPl3+CaCAEZV7LbtGFxufIXgkNG1nvI658yFzH6H+bp/lhTXuOhDV9FuEmfgNbVGoIGUlnRDiebUf3Yb2bRIN3C1ZAHIzMILYHPKJhuGFtvq93Sc79hDb1LPYbOxORFNU9A7kbKd2/iOlO3NJ6y/HL/zcUbn2A5IGwJE81h0P2L8Zi7kyKuRafwNmgfeh6oO449dnDp0ozdtoKqlTkVSoyf+pEXzKgFghPFQDbXFJy7OLWFtE2aWokrGjb3cGrgXpKxiCKROk
 1IvrlMOD
 867LkWGKb63kJEFmQiTcNcFFYCOOkYZyI8IY28vbw66qQAhUm2hU8RWXNcRWn//AhkV2kEX2uMlrpXkylnLgmxyIdRLdCyFHa/yDBsjk4Txjubkp24CXyrtyYk/JUvSHTq3wh+SS7Dg46IQbZlPvZkyzgkjlIr2+5uQMhwYKevPjUXJ6svGjlTlPSmrjDyO/Lqjhh/ASbnbRwkuAu0/BjJSlZDeFmsR7mt5dlgoOxAk0zjH+wYec6q7XxvHjO4FJvhOV4S/TCISNHzE1qZrjKxXfDlRREeSmnSZ4HOtvLYrhAIssb4OljiE//ij2XnSS4Ns2xvHpB63mZz+UsIyUTGlgnHjmtsDHb6Sxq/Xpkn+yTqiA2G43e7wfkCHqi3edM60rt3sabeaiPctc/ln69RHF/V2IM0SqO2tFLBbvKwHC3jJwIaOqvrWFsUeQ5zHuQxe/lakvbhOvEByauy+hwYJajGly9wf5CvjbqqjgcZnYuRBxshXXbUz+94gGhiHPomR/jl+K7OT5eDSs4JKJRSW/bd5jnZ2sRfpQk/f1Xh4oCg8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000193, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Add support of DAMOS_QUOTA_[IN]ACTIVE_MEM_BP on DAMON sysfs interface.
> Users can use [in]active_mem_bp keyword input to the target_metric sysfs
> file to use the new DAMOS quota auto-tune target metrics.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Hi SeongJae,

The sysfs interface updates look correct.

Acked-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

