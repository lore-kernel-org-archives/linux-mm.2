Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C756D6AAFC
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767716B0005; Fri,  3 Apr 2026 04:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718816B0089; Fri,  3 Apr 2026 04:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F1F6B008A; Fri,  3 Apr 2026 04:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB726B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:29:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1FA1E1275
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:29:13 +0000 (UTC)
X-FDA: 84616569786.09.F5C6900
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id F102210000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:29:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rptwbTJo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775204952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWARIkwYvEXgfZYjG+Wr74suArYFrPWiR7izLuuH3rU=;
	b=QCRaCMBd3iZLaHp4Og+8O4xaqgfKeV+ShhLZok3M4qF5AmUltSuIWXHL3YTH+NeSxhSw91
	/RKzMmQVrYkeFjOH8r9vXrJZetK6LcGVN8y+SGSw1Y2gkJA/GP6x5ePPPi+lYbuzLjGTbS
	0L4CwI7Te09faVdHilt4J3wBdLOchsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775204952; a=rsa-sha256;
	cv=none;
	b=qWWjmAB6jeE0MX1FNxQ4rIpIqAingGK5poZUtOznVLztSIGYqiN+cylRIhjZwRPr4RjcW8
	AsuvyjXQ45OuXIRZkIPXT37y2ywxCrh/rtzxO5CrkJKWOb8AOM2u7t+By8G6wVU7ItjxcC
	F+XJ6saUkDD/rcxM7u/DzQji8y6Xgas=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rptwbTJo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b0afa0210bso7931595ad.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 01:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775204951; x=1775809751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWARIkwYvEXgfZYjG+Wr74suArYFrPWiR7izLuuH3rU=;
        b=rptwbTJoEpOWe1wYtZ1VgH2z5nS7l8BLLPhqOuuFGw9HjQiclqch6SIo6Svws8uaQy
         fHNg+jhhXKJQoNWYhmvco2eDHmYZAncyPwXe4TaLe7GZv7EbnH8qmot5jOHUJJVA0H4u
         qJuEIbR0UwbU9+Y+Z+SGkh1fWW86oU9FNL4KG8uJVHtchOD+/sU9FFvG/UgdpmBMy1/X
         RydUaMORI9JPOlgD5G5tRxBQ9yYtM98OvF5mHjCuSL8IImuQo3Bbk3vZSbNf126iubeN
         26fSBIX9m+0zMVl2DCeHX3vBuW2mY9L01WzwUqXH9iIG3VDHl/q/PxZ6jlSBcjhF/xyA
         EkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775204951; x=1775809751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PWARIkwYvEXgfZYjG+Wr74suArYFrPWiR7izLuuH3rU=;
        b=o8nuGPimLuccF0ZQhFuoOJXdMxC9Q2lt9sYFQDiOY80CHjNVFQNx/xAgpq5l7HkmJJ
         Evi3PuxsjPf+LGnawtFOAOTCUmL6pnuWWu596l+1MyJzrfUZW8J9+dEl0zaiI/WKqTIA
         V+LXOOTR2MPKQLA0Le23W0zzGVF2r4KhjwjdOW16YCyrappsq1Hm8vypB2YgLPwhfdF9
         ebrr3S4rGiLufypXL/jZxyBpGM6wyFqFrYMv0TvW5/EZlracKscLBK+WswhNpsHGSpZW
         RYFIBNGDZGKZ2/OY1payOM4BL5qyTPSd93nMP7OMUvwQN1pg6I4MXHRvAJBennxyJbBf
         5U/w==
X-Forwarded-Encrypted: i=1; AJvYcCVd5eHapMLbLpMElDZNu0n5+wVE52nmCCM3Nwt7ZIrV7J893NeAKFkUSmT8N7B6soRryBI8IMDkDA==@kvack.org
X-Gm-Message-State: AOJu0YyO7JNX2mOq3GvfPmy/g9KIBQN/fDPS3BFkJAsIvNwnGgR6Al4N
	uWs+1Eh1xBouMgwLDEczkv3bn/6DqOJ/2I2x7nX0xp6Cc0IoErSVvHb5
X-Gm-Gg: AeBDieuw3p3Po4FjtQ78qCbDX6c1rCVxccNzc7cKFkSGobBn7340PT/KgaIT00kEvBt
	sxkYTP4Kr5joi2vR6O9E/VLKvHIpQwp12RdEnIELWOYU4Hs6sqI571oI2KXqsnYxSeT8w9AHQWt
	vJOUehd+I+g6xzhOcOuFUHDphdcxkxy0Ne9r1TxiJ9UWxGvpory4x6a0emLPcnrvNu8wWRiHkWA
	QFOxdfCeiROYLrcIwnATEoK9m3yhVOANHjLtRRklyi3eNXpkB8WYJfksFnSUKZC4mGdivd31VZo
	aR+fzb+SeGKviBTIducjHBLyVKlkA+eDj/ZYuu8YhWGxiFmfDPTnTDQ7F0bpMuKeShTvIo1TIcv
	UdFrrNnoKSd1GXzYQenDAAD50OuUywrsf0JSLU6ay0mS2UYxyrkFeIZkvf+Hw2XrY09tJ82S9mS
	DnrN2upn4OrXdLHyA9XPMIU858ZIwVNOv7BoKxMs/D1dHxrgK2YFQ=
X-Received: by 2002:a17:903:22c7:b0:2b2:5203:acd3 with SMTP id d9443c01a7336-2b2818b3dfamr22641545ad.26.1775204950671;
        Fri, 03 Apr 2026 01:29:10 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a3a1asm50469845ad.62.2026.04.03.01.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 01:29:10 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 16:29:10 +0800
Message-ID: <20260403082910.5346-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402140314.74600-1-sj@kernel.org>
References: <20260402140314.74600-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F102210000A
X-Stat-Signature: 9gzzdap6cggi511y6yaftuitemos4aqm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775204951-639315
X-HE-Meta: U2FsdGVkX1/EjfxM/XdBeXAmV5kDygAs2tXya9IigJOwoVD0KYcZL97TjlDDqnHVNQToJy75N82TvWEbDQDnJ0Rspm8iKE63ZHIFs/A+4agnfuAXMCm9+t57jaMnSkd0LZKIa4c8BmvPzML+tyjrGU52cm4RfgZ5Vh/outoDmKKDNcKJB7euCun7xmM2QkrHMRH3mdRPhZ7CnXPNMS4dOPKMZSJFpQkLi5JHViBRbnkg9QG3x3QrVgL8AGBIFkCLPaOlVNaOK/I2WTiLq2YkG5LLkMr0qhmue5DlSJW9Ldb0c/HjIVLuDJXp2zLiCchTW9qSkBTFejAFORPTq2XJeuWBdWZbIkT8PVF3PX/SvZgiZY9CSVQjBLcQ7A9XbC+Z5RcdlqEXojhYPceK0p6q8bgtGM9kOL0ko+RbcJmOku8imxuuUTrupJQv/ozrApPQiBh97e2DXznoaAkZ01kKzehNYIXmypipRPRKyNzQDYv4yHM/0fB+biiZegDbAKDMpvr3/FCtZZkVtV5eo6CsqfvwrHwJnYAGnm/Fj9RUGIOrbviVvJc3bQFJKd2C8XaeOJ/169DucKSzcx9JOWTffd4T1zM6QrahBA70cFyFlw9nzu6B3LMr8mL8cJyndYjwCjtteLui+l1gGKK4rWe30G2J7YpbDdQVwhT0Cvsz9G+ZES7nKEvUl+2HYOIjLxMCaKEvbNKgb03QErurc4Ay8EvaQS2Ip0TwGky8SQXZGPI6oWawM7Ev8FYTzoKvb31yBr3mh6uQZKtqBWP7yon9/+M1i0Qg4JO3iGf2pcdesq7Fiub+n1zdich0uR9p0u5KxOsIPyqqY2lv/HdnvB+DwVTuuKBr1SXeEFm/7bd6+8XrmpDFf0DsAmUfnfUaLFtlqSyZxFqrtCTNbbkHMiOesptNUDFDw7TNUUtvzfN+y2KbSq2+bEyRqRrt8jCy5w48R5+WvSeGncR3/IyHcuA
 zGV8Rc8V
 m2Io575NKa+/HDdrx7XsnOQvWX9VzWQ/L0VPJ8/FnvycLcPI2UtKSIlV7pgIo5hQOaALxm6mA9x6pgZNoJiMTmpQbGRspn5eSlKmQBqthYQIFfSkXFy6hzTSiR/porS5NeF6nUSCC5mSMbx9Y4NYG75+qY9/pjGI20o/qHjpvSrS+ZI8b7K76CvSs+gWMjhEdD5Aw4lYV9QYaYwY7zOjczbzRR65wdDp2VyNjzS7wVdb0/pnY8OrQuH4NtTfmNl85q0goGHJtX/u6GgZ8EeGoSZPy9eVbWiIrARQC5JqacNTm2cJAdZAH9IRNwJQvxEP62eSOcfQxHbN1dBUFDxpvBp/qSudKYm5aT0vM/oFdIDD1VY3WE+IRuaOwmaH9gQsrquEXQFGqYzS8+2CyvPHSM9m7D9Fv1+gRu6gqjWGe7dRCxi4sY95GSIkJztoc80x8EqTxDE6INjgjgYLOEd2ENmbxHVO1+gZnQORKCWBjabk4kjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Sorry for missing the discussion before sending out v3. I was too
focused on the code and missed the context of your questions.

On Thu,  2 Apr 2026 07:03:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu,  2 Apr 2026 13:37:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> [...]
> 
> Could you please further elaborate visible user impact of the problem and
> reproduction steps if available?

Yes, I have provided it in the cover letter of v3 [1].

> [...]
> 
> Should we add Fixes: and Cc: stable@ ?
> 
> If we should Cc: stable@, and if the changes for DAMON_RECLAIM and
> DAMON_LRU_SORT deserve different Fixes:, I think this patch is better to be
> split into two patches, one for DAMON_RECLAIM, and the other for
> DAMON_LRU_SORT.

Yes, I agree. I have split the changes into two separate patches in v3
[1]:
- Patch 1 Fixes: 
  2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
- Patch 2 Fixes:
  7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")

Both patches are now CC-ed to <stable@vger.kernel.org>.

> [...]
> 
> Seems you forgot the patch [1] before renaming of the subject.

Thank you again for reminding me, I have added the missing references
to the changelog in v3 [1].

> 
> [...]
> 
> The code changes look good to me.
> 
> [1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com

Thank you for your review and patience.

[1] https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com

Best regards,
Rui Yan

