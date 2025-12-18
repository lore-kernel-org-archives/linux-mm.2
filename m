Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F273D68BF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585686B0088; Thu, 18 Dec 2025 03:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533656B0089; Thu, 18 Dec 2025 03:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BEE6B008A; Thu, 18 Dec 2025 03:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 301566B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:35:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB7B81A0D79
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:35:15 +0000 (UTC)
X-FDA: 84231932190.11.E001EFE
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3340C0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:35:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6L6UGP0;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766046914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGOD5AKxuXAri7NlUCgiMMy4tdnFDqyp4xUV8NE9qCo=;
	b=R2zeZFdHLOsoenuDAcjFpM8KnapqvrlyjlHMLFphnJzVnUzg8s29XvwqZrUmk4oMrfC6Ga
	x+vrIsE4DDxiDTq3vvAFrq6gIhDAwvWJgkLb0LQAP8eyO0L5e8nAIUcDtkEsyQc5u1M3R8
	O4IPVjIGpdFL/En2biyNw4vgbpu7L5o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6L6UGP0;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766046914; a=rsa-sha256;
	cv=none;
	b=xDNzC8t7z/Kcy7mwB+FcF2KHVCRC51KxX/i25HA3TgFLWFpRxRAoZ+EwzDCDpmv6be8RJD
	3I/K8fRTsxV/wnFYm/u6vPMEmINonoYmPdMGcOvxSfnQn+x8HEoUWKWCZj9Liq86jQymaA
	5CTahufMZlusV8e62/XxreFPq89pjaA=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78c4d112cd8so2877467b3.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046913; x=1766651713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGOD5AKxuXAri7NlUCgiMMy4tdnFDqyp4xUV8NE9qCo=;
        b=I6L6UGP0uaUaSMYvkpKBgh11zjjkJOMFazumAppTn5yYOCSrSoqUSHUz9yrnvrNQAl
         qdUeGw6NwRF8GlX8v64RIlra92LH/1SMDxyYwKfhdstknbZbnFnSN8w18MKJoT7nWDxj
         Zyc3nNHWHBVB7S3WbML/Cb6Nwx9fPiNFiia7z9ZaBtUHCx+7B8wqRfAZWG271ZCpbrFJ
         bvRU4ugFAjVoibndgx7ijDHYWEy7DQlVDu9CpMWLhGtIF8dq/5GyoQ4sdnqrochVgdh5
         h1iBcA37sbh+62as9TQvjv6VNyWlhFit5LxE1BcKCYvaHRd0HAq/g2lVLi+E/5FnOjjX
         ih0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046913; x=1766651713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IGOD5AKxuXAri7NlUCgiMMy4tdnFDqyp4xUV8NE9qCo=;
        b=qEgFW1ymPdRrKU1tXkaCR+BFGLS4M4FYMiegFn2sxLobgwRQZKImC1Xlm2LmswKNXP
         gfdoLmP5TvJ9A/dPc6WTsX94VrMTny39D75RRk+uq9Frg9lzav0fz2DV3h51Y3FDH0uN
         ySe8XPfBIYIwpSh/8O33yKdBVx3r1e7hh+YMzeS8UPlzrZmBv8sY2sNRob5wxzOTjaaB
         T0B+r8o0W2azoSR27HS9hBMkFd7AzR4HOFCVZICAmvplGR0hHm92dAmyxk9gP3Hq7lI7
         M6yHMfWpaF5pcXozPG8EgJ/csyz+6DN65lDg718C9F3R49RP3SJT4i236Yy4Hkup9ed3
         QvvA==
X-Forwarded-Encrypted: i=1; AJvYcCVSiHRMzdIb6X2hiAorFsybezVbGMFEOwYKoKwyz+AinetyKYlXRZrFbIbs+XYV1LDbY/rkRmKnKQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6zgtYBjpJlIzqpoHZpwEnRulXJQRlbwJSOkDoWopXg6UMOAmc
	RERuzPdNpE2YJOykA9FSGsc6QUCpMufIEFlS+0Mai/B93Ntm6trTvt17
X-Gm-Gg: AY/fxX59VyXQaGhANJAG+oZYePFX3EKf6GJAp120bQKPf6JAj/mfLmO04xbNGNGRyAR
	vcZFBSQIjg4+Kkat6QilZFv8XYA8UUEJz0CQyU6w06J8yw2IqgcFKKi4hThig6ckVYkXfZ9n1dr
	ukJ5TibkXt5tvYJgQo3RNzg4mgZ5mWlWbv2DCxo5YeVE5j9WMiQaRBll8RhnrH361xr+NyVoS3H
	FjV+6x9pl2vUWeSU8JM18ixctSwJpGJthGryieTxIuQWAkxR/Ba/tq8VlkARGQuRQd/k7ZUqmdH
	oa4dyAlG7fSA41gLAPXd4Bc78j9IdArUFjY+B5EXoikHcZwdC+6joOs5JWkMRlmSBek1/pJVXzn
	hD9BqiSkNR/p4JtSBsrYK8sQGvx8soKzjJTzKFE5/tYbWmt4LdP+wj2SctDbxPCef4jV+/+NkgG
	0y8gCJq0J29zs5/sLTROknVRUxxPuj17f/
X-Google-Smtp-Source: AGHT+IGSXiTTGUVkqZzEJxFvMPmfIzE+x47nd9kcu5QbUqyM1nRZWHFpaROFvrFRIej72RU9uKwDYA==
X-Received: by 2002:a05:690c:620f:b0:78f:984b:4bb5 with SMTP id 00721157ae682-78f984b50d8mr74915957b3.64.1766046912988;
        Thu, 18 Dec 2025 00:35:12 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:40::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-646637ad87bsm800456d50.22.2025.12.18.00.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:11 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to zone_set_pageset_high_and_batch
Date: Thu, 18 Dec 2025 00:35:09 -0800
Message-ID: <20251218083510.2462817-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <db40ce77-4762-4d99-b03a-439c977ba1b8@roeck-us.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F3340C0003
X-Stat-Signature: 4izg3z7kfrp1yscxaogmmdobgqarpb9p
X-Rspam-User: 
X-HE-Tag: 1766046913-339857
X-HE-Meta: U2FsdGVkX18XCVl2uOYKggJmUYO6k66PEia7flQPazcENR1tOtDsTlne7weip0nVyMm9uYBq6qCai69qewKJ98hDJdgmFHLApkFHhyuaoInaGv0KafRJ6kFe8SyNybbVZVCa0ss375eKX4GoK9yvmo04E+3L1aXGqD5Iu1KZ8SunDBuXk6pmZPkL4KVhr24F+OJPz/9RfQXkj/pYBvsCM5IyR3lTyBIExnis13SHMeAzwGxHp+DJFIG1wCXND284H41Pm0IWPknuMafhKCoPSGyMxoZ3zDUwt/XUIk/O8E29GYQsEaLB6CBc5pPJConG7BTaplkDwykK4BglypOOdIIrtxg9P7YS52NJltHRQWcYs4PC2z5CczobSmH6Tk6ZmWa6x5747VtBTmY9TH317OBVlBhFC5un/5M6P/qkR3ekX9c4OT8QN9nYrQcPl2OU/0qAFP5O7IUvNtKX9FAapCbjwU5qupLq+26LCsMM7uXt+zL78Xwzz9s1ar7pMoz3bzFdd76BuEhg56Z8Pd4qso9DNPU06MiQXMm4JT94CLzz5Oe9lg3KBEBMrq1RsUpH/gBbMELLg8SCoFFuP6gpNtFQDO/kNAnmu6bXE/oIqVbm0Dt4L6d0SpUJD4AmEFdr0YdyQDHj+1MFZTbAueDHVNSftobzOHkRsns+/c1dYMKk9t9e8FVRNIKBICnodAU8kHNkr6T5yLOes5CQUhKfy2XKPhPQ91GGX0cdytSNDO4iZ+0MtR2RxgsKMQ58mVLB9loMsFXS+dlCorOcuHYqS/vo3n5ELdmyxxVm0DvLEh/5numzVooQlv59oxFyFTTg4ZLsL2AaRbJrRtI3z70tL2+XrIS6YIiolCDc9Tjv+ZT5rV6FbnyCMe7OhtjcWQp3d0m6yvD/vNhRm0FoF/10VOewy6Oxeag4vEV6nlVnbYL40c4mVL+8Zd9SdelVRcJAmu1GSXx8HtbhXaFkBMd
 lbDGnd26
 TRALx0IIoml4WH1jK/zbj6wmyGJocnCtMjMOdmAhZNLDdGLyFITUxzbh8ppiORJtFq4RB8+mLl5rOXCMGYDjLF9G3ozET+Aj6+fGn32vu6Yw5R87jYmPBCNLoK2dEiDa/+cR8r9H6I8gOHpR+bwm0wVCc16lHDAdlcFkIFqpuu16OE81zWf/SXNIt1ghI2jyNbeZtc2Wmr05cA2vPJyeUeCw4tvgWQKfJhy1aNNPYGk2eQsuQrWakF7W7idhOkLYpMBQWasxnjL/e0EfuBfOYpLIk/U3QSCWOPwMal3Gf0LyReyHf0sf/xXnb4bqjCLWy0QynFOLDHqnKWZUljGT4pQbemetsnH2ydDsum2TEZ9/At5Qk/HxXlBa4uGZegzdiaJafi3uefbCGXv+dzy4VYuKIw13o2aqXfBPRKsQ5qd7CTJOFs9OGCDhWtbr+JadkBLu4MUIJNNyjFcbGlmN6gXAYrOn2ZMLU4gquLrF/fVQI1hu/aeADKl8lDWQBLnYqvU+2T19UjCty6RaPLCAyzmFqyheXp1eB/gVIwbdcOfPcmSGsOqWxc6iSLGPSrhLhgrSmvqbBYSwwgZlGCxPpy6/fEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 08:47:12 -0800 Guenter Roeck <linux@roeck-us.net> wrote:

> On Tue, Dec 16, 2025 at 10:05:03PM -0800, Joshua Hahn wrote:
> > Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> > moved the error handling (0-handling) of zone_batchsize from its
> > callers to inside the function. However, the commit left out the error
> > handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> > 
> > Since in the NOMMU case the reported-to-user batchsize should still be 0,
> > we would only like the error handling to exist in the callsites that
> > set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
> > 
> > Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
> > on NOMMU systems.
> > 
> > Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> > Reported-by: Daniel Palmer <daniel@thingy.jp>
> > Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> For m68k:mcf5208evb boot tests with qemu:
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter

Hello Guenter, thank you so much for spending the time to test my patch!

I've gone ahead and took Vlastimil's suggestion, which just returns 1
for zone_batchsize for NOMMU systems. Functionally, it should be the same
but I thought it might be best not to carry the tested-by tag over, since
the code changed in its implementation.

Thank you again for testing the code, and sorry for the bug in the first place.
Have a great day!
Joshua

