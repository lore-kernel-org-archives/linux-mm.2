Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8C7C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 19:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899DD6B008C; Sat, 19 Sep 2026 15:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823566B0092; Sat, 19 Sep 2026 15:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC786B0093; Sat, 19 Sep 2026 15:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB636B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:09:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34F92140268
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:09:43 +0000 (UTC)
X-FDA: 85231451046.16.4285FFA
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf20.hostedemail.com (Postfix) with ESMTP id 598381C0005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:09:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGgWuG7h;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789844981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+A8NmYL+ONSVcQNv/Xmt66mRPmqZH9O1MKGhSoPUDE=;
	b=C+FWr1vmqCiKOR0vB/pjniCmdViYtyMTp0JW+frXuALJItnF2OsHPDi390nmcnTLFa3dj/
	Ds2T4kSiXYMnpF5BkSuPbJsvHQ0xK9VNNJEEbrRxcsmnkQOMiYqLJWGNhIbq81eno/YbgZ
	pK3wuvkco8lUxfIhAq5QdaLUoAUFdLA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGgWuG7h;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789844981;
	b=8ZT2l9TEh902P+a24VTBpT/YUI71aWInhCUcEb6dii1wr9qcAHdQd4Eg/jLDfOA6vqWIaU
	vGBYNBttHxupXkd5Nrp0ajGg0Dnwi1h6TVCdY3tJ5eQVygygi5MDfGmyySgYoyKW25HKqw
	UVxvPS3dZrQOnjxfa7rBX9ivB/bFFGM=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd77300825so18339805ad.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789844980; x=1790449780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T+A8NmYL+ONSVcQNv/Xmt66mRPmqZH9O1MKGhSoPUDE=;
        b=sGgWuG7hc5BMAUWEulTdMiIXRSsJ834zp3FzsRcpylKfbitfIPKfSSWcy53Jja40Xh
         0zci2FXOy577xVB5JkKNGHE3yvVSEbgufSe9OLYf+P4zCjiebluRo7m7UUMvXszbm+p5
         0ta3zaqA2d4dTFUF/XBZfL7i7CBfPf2THwwgKUBUCxinrZJB3avQrMIEXnbRgVeoc7+v
         01kdFulak3rlvfPNqCIgSEKMNZ628OdAK73uqFyLkXCCOfQOWK9/7P+K90dPauMTghYW
         k7uACdoQsfwtJ10Z7z1BB03ASh0GgMBgIeub8ktDrCtTDyczw20Wm7qC1VrsolA76J2K
         eM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789844980; x=1790449780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T+A8NmYL+ONSVcQNv/Xmt66mRPmqZH9O1MKGhSoPUDE=;
        b=Zr56J4cIizrrCPLdatZKeznj1/dSQlhmD3iP6d08wDOAV2a17xgmZ7fs7GnquFEqDq
         kKnNShLLblAt4plKmTLbRcZr4K1xP6h1ObSiYWIHL/4rPdctNbLP6heg+MKQQKEjwKM9
         OD5JDlF5M8HhbFyWOnYkVX0wc0jaVWdDtSKjfqs5GfQcQdlbGNgVOsRW21S3NygvBUEK
         OBkAFMpRwWu83nAWDhPzMjA9568QHDBdWFE7VHrISDlWRHVToZTHMwFcGBhT5qQuzBTx
         MMfRGUdk5UwcMPTCaBqSepdvIgAHlqrI2DkxKc502cQZtVMyUegZoEqxUoReBpoevhTG
         eRnA==
X-Forwarded-Encrypted: i=1; AKwUvBwki2C2UfKWiUxAYe+KIwawK/CYv+e8OYHrTUA/cCTHrXt9garNPazRQUXtouIBPDvJqdjG4GWPEA==@kvack.org
X-Gm-Message-State: AFuF++mTy563sDCCTYp0aNu3XqmdrpEfJggQ/gslNuE09J4LAeF8p3pC
	Wl84T4PKQV/V7Xf0FTSO7YYRcBmW5x/muSiqnHNTXptcB9fSfanNr9UJ
X-Gm-Gg: AYBFou2pQT0vyiVffL15s/ZOevT7e1JgHQrlYzFuj7OUvudROw6OBug/3++Z0g0/4Se
	E36hZIFMXUgf8Z0dM93D7N1aAOejDvZJT+0q8+9LPeDP+28+XujQI66xCQA2/36lCfV2p9cDsoh
	6QpPnntD/Pqxehk7Kdc3tLEQ71cQ93I6QIlb01nqJs9vzU4DqhmXfJMtwpmTMgvBjLUEgGoahc7
	YXtgnz4JcVJMLkIGBzR2zvkZXe9o4FgCLOz3F2xEu/x04kZXmVzbDYD4gnqU5mJ7IvS0XrKSBgJ
	OqWR8elB89KfJ9jbP6Ww1zVVUHUEQUXpFSCsYe8tvy51gdavBKukOSTJZ48zanbuFx2YuWwC94c
	e2qlEEJqylhUkO2IWSQ3x17ft1ERXHi6In/Uv3tIGCVDEw0wL0GaqZ9qYeukd8Tqptsz4Dz3Oqw
	eCMwHmQU+86eoBugN2DLWbHvqkU07dofNekcX6S5TnEU8NjJLvkQrWoCnZahRKOnkwC4cxRF4W5
	Q==
X-Received: by 2002:a17:902:e80f:b0:2db:39da:90f2 with SMTP id d9443c01a7336-2ddb1adbee7mr109128495ad.8.1789844980074;
        Sat, 19 Sep 2026 12:09:40 -0700 (PDT)
Received: from celestia ([2402:1980:c3f:8e4f:9945:ef6a:453a:80bc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc17888a8sm12378465ad.26.2026.09.19.12.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 12:09:39 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RESEND PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Sun, 20 Sep 2026 03:09:10 +0800
Message-ID: <20260919190953.86705-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919160725.86256-1-sj@kernel.org>
References: <20260919160725.86256-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 598381C0005
X-Stat-Signature: wmgryah6kzok7yp54m13iwxtnui9w5yq
X-Rspam-User: 
X-HE-Tag: 1789844981-874811
X-HE-Meta: U2FsdGVkX1+2ruD8wK50iUPvQXBGudz7wJ2ku3JM5IuUUce5Hm7njM1Hfobia7x5wxNhNhGNh3YdI4A+5TgKpF1pN2eRG82YqE0dgvCb3bv5yQmvLyvO/z5ue37SUyzmg0kBaE0Nx4rxnpb7jQGYwwkzJyIivVRRfrCzkJkJJxDWvLX04tk8NvITqfXSQ9eFWjkj8RvjmKJRqFm4K8w+OlVkWiSM9k23hQkEWwElgl6x/dgD96YteFMsuaD6g1ncRLzh+4aktFjrYPjz5fsHBOHIaK2ghLqSrL7hbCr6pwU489QEwRxghcM+gnzJMXLT7mKrOwfy1prwf7VcjCvf8sSrubYtumR5ZRUSqh2FE+dQ5u/4Jix5rgO9C5qJmlR/0FfrmgUpklv/vDLzfefoydzRyD18s4UYXu8yN3avYVHfJWLFScDY7thHl1YwMsjsEbX8ZAoTdtbhMwcywbj9rQTG1DGuMLz2Q2sF3Vio8Nrhun6wIfeMc5OdvGLPh3eVYNh/xy2h3VQzrx8rNLqfJ/qn8kqimLTTcSHytOVepJSZlizGccc673wZVF83ME4SZVegdP3HayTajEIaNpm1VTKDka863JHbEwzPthO9tS0Oo85y0w+/7bMs38lVWal3kZWIX6+RaGECpMH0D2EDzZnRYwYiTCbSl8LLAogMeENiRIq7JjFhaWeYDncpbr6hNF7I4Q9nGz1PJ38qCJeea7MQxWaPcQxXcH7EG9plakDNhR9hQ16PSUuIDzk4d2NmAz9KXf3mN+48M4e4f3Ug9kTPUOmQuR4ewC5zRvlNMghSk+VA5limKA4r7hyrgZhD57Kfg+b2EH9DBh7YFfj2vfWupL4mg8hr3YhJOhwkCzwPjzHj6d5x0HwV308Wh6z1w1ZvXw7maNtm1PiFBWyIFfKv2EGJDIlO4ePWjY5MQlLfBkiqtg3K+yaN906Pd1w8ooErTCGa8NI5LoDzgAu
 LYie0rc3
 W+o3WQLoZqtNMkYPNlHLEWXu4pP3Eyl60HE8DC5xpjIvThD7U2VfNyYy4sCGwdvSOpiKGo0N6oeD8blppzWdZLKsZgYmALQG1cbcuyXQQTt2CQqBUs6SU7L1QoOaOaIIwYkgBpZgSr3Le7kY/mm4L8aHsYhYBeWT3HWNFGNHecfW8nnsFrqHT1LFagSm4kf0pMoJVXnMeVkB066mRM+RpwCNXbLW1c9OVwbXNxdZpMmb4gw6qFc0OJvBlkt+fzxahA0UBHXGKe7TCMmHdY3u8IhgWlhQ/CkRUhs6j/hkAe3a+r5+QLwY5rSu5puukLLFQUzggIdS8rBnNGkTVvGJyzjp8S03MtCbdbUEbzk3NHwniRRqJVWOx9Lgr4iOnd3LXmqWBqHv0YZEi6yi11gH7sR+XCJ9z+Aqy0n9+e0TBGli7CqgVJaZxthaFwnnwOuokWRTpD/MjFhru/e21JJKYTFNGGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 09:07:25 -0700 SJ Park <sj@kernel.org> wrote:

> On Sat, 19 Sep 2026 16:01:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
> > regions") introduced a minor issue that causes the last region to be
> > skipped before it is processed.
> > 
> > Example:
> > 
> >     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> >     2. Quota is configured to process only 100 bytes per window.
> >     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
> >        addr}_from is saved at (Target, 100).
> >     4. Window 2: The loop reaches R2.  Because R2 is
> >        damon_last_region(t), the old code unconditionally returns true,
> >        skipping R2 entirely and resetting the charge_{target,addr}_from.
> > 
> >     Result: R2 is permanently skipped even though it has never been
> >     processed.
> > 
> > Add a test to prevent this regression in the future.
> > 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> 
> Other than a trivial style that I commented below,
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> [...]
> > +static void damon_test_last_region_quota_reset(struct kunit *test)
> > +{
> [...]
> > +	t = damon_new_target();
> > +	if (!t) {
> > +		kunit_skip(test, "target alloc fail");
> > +	}
> 
> Let's drop braces for single line, as suggested [1] in coding-style.

I will change this in next revision.

By the way, Sashiko reported an issue [1]: min_region_sz is not
power-of-2.  While this do not cause any real issue in this test,
non-power-of-2's min_region_sz is not legal.  Should min_region_sz
initial value set to power-of-2 value (e.g., PAGE_SIZE) in the next
revision?

> 
> [1] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces
> 

[1] https://lore.kernel.org/damon/20260919081239.8A3D91F000FF@smtp.kernel.org

Best regards,
Rui Yan

