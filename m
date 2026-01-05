Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F851CD0413
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCB76B0088; Mon,  5 Jan 2026 16:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AC66B008A; Mon,  5 Jan 2026 16:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8691B6B0093; Mon,  5 Jan 2026 16:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72CCD6B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:57:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F36341A0288
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:57:20 +0000 (UTC)
X-FDA: 84299271840.25.35DD416
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 297F140002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:57:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YEDBnwFL;
	spf=pass (imf27.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767650239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruUH3riTuQHbYhQB8sTumfaclO2ukit4bkjAu1GwEGg=;
	b=x2+6s4heR//7a1VOyA6uJQaT/h3Q51vuYSO5AmBEGm+3DaBEwK3iFXjzaaBMETxtwZgd+X
	lgDpD5QJGomcurlHzvRI9uzBHI+r0l3DulItldtkeLMsRNM4gP9ARlj9qrEZUlIU2KRAVS
	hdSz15rKn74hcuEEL28SRl/89JDUmYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767650239; a=rsa-sha256;
	cv=none;
	b=R1mAWKKvUDusI7efZVDchRjichv/TiAUqsp4bmGS1n34iIKNDa86M0o3zisdI70tMo6/Uy
	Hark8XtWzFs/ijUFJJ83JF8EmfMLoLkYinNfFHdySQvdLgP3V83mAxExmVQCT/zkKF6tH/
	S/VL9FHMxlATryXTpSMyukj+BYAGDK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YEDBnwFL;
	spf=pass (imf27.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f02651fccso63515ad.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767650238; x=1768255038; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ruUH3riTuQHbYhQB8sTumfaclO2ukit4bkjAu1GwEGg=;
        b=YEDBnwFL5k9Hek+IaVo0S3cVZsXXbKEUnNJb7cNvSMQ/0tUyBxpYdJnzoI4gk8oXOD
         CtJFDWlLGrRWOCy0mgoXC6yp0NmHybl+oiLXR/cc6255xQjI+RMA56ee3mHI9x1d8oMF
         3Dl7tiQCF/MBFDr7pMiY3Qt9m2P9b/1lR0zyGvjCFlJxJhTgnxKmn/PZjUkttobSrv5Z
         7RPtGn69cfg2SZAVNpsuhDGrNnfou3Bosvuq6RjYb0uyHAHjLMazIE+EzmlSV6NSUbKy
         OzxuKcPlWYgMhNs/rDZL5XcW1x2rAW8D/A81abtMO47oJHvWYYA/xhMaRFXGUUjyrq8h
         T4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767650238; x=1768255038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruUH3riTuQHbYhQB8sTumfaclO2ukit4bkjAu1GwEGg=;
        b=rLyY2BU2KM4rMGeaNrjIFMXNIeLcf03DSjbteb2ZMJNU0SgzbRWqs0IgHb3vRbh4Sr
         ipnO5+ejp5fr6EpFyEyKIzpaS4eG9fvF5ZFtteuKAd2AlKryA22d/cI4J4DgMejYQ0Tg
         hDCNuzx4VE23GahMBnrhdnibRXiueSqY+iGwx6Rn8IJyVyleVPQ659yspJ+6+je4p/6d
         CruruxjYTHxRQyJzh5YXGk+QqCVlDbQv1WSlPgaWa3/DL1jkG6yaPGzgS+4t6KZAdkL0
         +oxWlptYViDt4L7MCuYpdXcUbMycaMU/U5HgfjXgsnyVRyOwPcxdPkhJOqYXPc2E5AZK
         gvkA==
X-Gm-Message-State: AOJu0YyqW/BZ8A1bpDJ0BjNEXo1LhHQZplNwfscjoBgCmhzYKqwx2F8x
	7j+cy6AGDO6IizYxiRAFWzP+SlzWkakp6zU9NSDSGOrX63pVDGEPrdMlUXcpj2Amsw==
X-Gm-Gg: AY/fxX7dKgKkQmMHaoqSynhmSBxvfkRxxnvCUD/77/dwEdJm5n9egRQI2iMNDqpWIM6
	dsAm5INxDvEZ46kZJDfx7EzaKLNctaIY7cfOmuckiX+5qRm9l9upYM1T4bl8qQciGpnUGd5vK7H
	lLq/WViWuzHnKtK6Mq00SWffrzqxTDii+5Cylm9oIDOkS73OMxoNQv/7lsqv0dCzfHL8z5RA+mJ
	zJxIWCZUKWbYaTI5F43vXF7Z7xqSxMbTd9JF+JdhJoxXWJkAPS+ACJWbTEEabIarIfSqMaGJ7Pm
	Q2kWCuVKzLaaOjDhwQc5/M0dYV+Ducy51Fk4g+ad1JXjiT24udq/VKxQ00RzHxdl5P+jENSW5jF
	PA/gBew0hnDSrFVp1nNuURxx80Ct5RGvR8YjWXRDMd5229wEJ2jQCNtCzd4/9QHejaJwmMZn8FR
	QW/T49HXLeqJTVG5gbOe2/cjNr2UC0L/TNiduiU3w4RVyKWXGXUA/6
X-Google-Smtp-Source: AGHT+IHtbE40ji1Wx3VGfpDxGTUC9DPehcLKlVLsl+ThRkRZLTI4SG2xNYa3tPRCrCOLKGLV8YRl5w==
X-Received: by 2002:a17:902:dac3:b0:29f:2563:7772 with SMTP id d9443c01a7336-2a3e39a3a2amr703455ad.8.1767650237230;
        Mon, 05 Jan 2026 13:57:17 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c52f8e10sm112198b3a.44.2026.01.05.13.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:57:16 -0800 (PST)
Date: Mon, 5 Jan 2026 21:57:11 +0000
From: Bing Jiao <bingjiao@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVwzt9oFHgjSFUi3@google.com>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
 <aUs_pLTcsVK8zf0g@gourry-fedora-PF4VCD3F>
 <aU7YSXnoBTFRy-KF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aU7YSXnoBTFRy-KF@google.com>
X-Stat-Signature: bufiqx74snuwzf1j9p8ek9w5azzpr69a
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 297F140002
X-Rspam-User: 
X-HE-Tag: 1767650238-496386
X-HE-Meta: U2FsdGVkX19SIzBrkPTs3uPc4YQY6tm0kA0dDMxKX7hPq49VKhlOnI3e8jdvKNwmVaKbMiB3PxRI+3pCG/4dTJzyz5N3o8Xpf66qGvqeURqZb0OWsdJYu7gx6DDuQKGCHnFBbnPedHLjB+nUsYCZavayigiNRklLX9jewqT3E7RzEpumVAVzVotWy9ETHITbjCGNjiibRdpj7VftRxpmZ/KDZi3jj49f2eqq5rPDUFlU08J4GQqLPy/gYaDT6mPkftQa6AiK+TqOOPimHQZS+T8wb/WPgD8hSq9uuo85fJDWYt1sEUK3V7ZgxHD4wG4xrQfPY8dPs5/T6brE/7tXjruxXvwwtY/NEVVthDokr0t04/aEtpAABof3rLiLvBjidxrrffc+zrqGYGCnSNGgnIRzirJRw1F5kUp0SyJoUyawzPVA829xjdZ6MaPSwP2LdBFsxwJKwWGMmkvWFp3GrU5sh3owoZxkJYt7wCVtiW7lQDjOUAEMrBRT7+w05pTFmA1Z++AdOO6zYDIR8IE7X8vB2E+DREcDUhafyrd85kLYw4C5Cz9+yRbhykwDr4ytZ65mS8KUnpnREgkb4EMyFWYTt9yca7cT3CXEPJgVDvnKY9rdULQ2eyrCgB4lVw/qKpr/Z8mE43CMjyoICl2CVNrP5iwYyHrdKcZCrBSqZwWOjCRj/rVjWFLHJyKgd/VIGULDEeRDrMf6kMhbHLgxTt31/Yq4A4SKKsbZzjirurlP46WtqlZwXZVZ0w2q3loHQl6tfxhJnMcBCU0+hRQCgerV6zhwZyFWXXkbU0qLKXqO/NVhvqryCxmn894K2JsKG0t5OlLHDtXgAWmMu3jYqhHnK3gYe4RaybTU7TEBSUFxHNmXokD4iid4K7T+0063S0/GAOyUUP1ObzH7j70uobrzS3+YxZFli17PEbRIsGyBmQa65Pvbdss9obVBrmCklyg5wyeZi+XnMyOI3aW
 nLoXlsFb
 hsRDDOu2/PWEMD4lfxC14NUwDp7QM4WGsRmDLD4TfC1fzFk1AHbQMO7TNEZWF4vkfk1WnTw2fiWDoB+aan8/DoCReZCORcJZ9o1hBaU/1fCzztw2M11h7ljBX3VY/a/eOmHJIL/khmajlv6G7jB/mXju3lo485qcKvY7Qf1KeF3NYpD5J0YNEHL4VcWCGN5fJVs1036D8Wh3ggCWmGLVIyPT1aV0k5oWFOeDHryAv7HxGEgWJtfmCtX7Z+/5wSAOa1Akt5iirGr8XA8ACXjiwWJGliNmwBrpmAZ7Y9oSJnS/Gh2M+ymzJWNqMx6LPIK7BlCcjbO5xS/5M0gtk+vjg6smENWz/bB3J0oiCyqFbMXUfoYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 06:48:20PM +0000, Bing Jiao wrote:
> On Tue, Dec 23, 2025 at 08:19:32PM -0500, Gregory Price wrote:
> > Have you run this through klp?
>
> I have not run it through klp. Will do it then.
>
> Thanks,
> Bing

Hi Gregory,

I tried to build a klp against kernel v6.16, but it ran into a
segfault during `create-diff-object` using kpatch-build v0.9.11.

I do not think it was caused by this patch. But I will try it
again at a later time.

Best,
Bing

