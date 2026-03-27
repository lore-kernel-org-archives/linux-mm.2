Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B9410BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8761A6B009D; Fri, 27 Mar 2026 02:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8003A6B009E; Fri, 27 Mar 2026 02:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE8A6B00A9; Fri, 27 Mar 2026 02:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589446B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:45:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23B63141013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:45:23 +0000 (UTC)
X-FDA: 84590906526.01.45C9906
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 53007100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:45:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UlL/yvAy";
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UlL/yvAy";
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774593921; a=rsa-sha256;
	cv=none;
	b=VlwI5EnkXxLiOsHYiHzcHPK1oaWBCmJEU3BRo2up3M1XeRm02Oxyk13gbz2K1as/goXWUw
	zLIlwaAVQIN+13xZh+MeZ9l60FQ7l5z8SJ5lmkM8icc5I37R2NzDKKCMTygCxTOIv+YHSm
	RPJ7d9uU1ok7ZYRD8yg8xjEJhL6mLBw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774593921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9CZF18FR/wzFPTRFS//7fB0vxgLV+gO2BJewVZGH+2s=;
	b=ck/jVn+GbB4fUPtp1NUVNiv5yPXCWpuZMT3RD2A/iFixhqpFtGxPB3agzv72MLKwONn5Pq
	tgolPyc31oHAbuH0bqWCJ0qpteBLtEHLI6m9YNS7AfTmuPnqA7wFE0pnzhU7PJo7B5tFTG
	SYM4b7lVPrr+DHDGuNRjDMtu3C8ozO0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso7690675ad.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774593920; x=1775198720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CZF18FR/wzFPTRFS//7fB0vxgLV+gO2BJewVZGH+2s=;
        b=UlL/yvAyKkfNP3lkrWtTw2R4J3rEvJySCumIAeDwMstNbLWqojiI35wVs4xwVl/OGq
         FVFzjIL8i7BA2GerctIH8ux4I67njKgvMOJ7YLya/f/UVoZHJoF1mm5DrbW90w9xbFW+
         +rB0cZhGW+SO1aLo4k2vUMQRBRnegDSJWTygWSYowKzlgyLmpLacMrtSGCv4oj9L4Frm
         ZtiygyBmNGL3uvy0XFrMamF1gDR++lBuqYMwOA6pp0zDl16vXGy3ZGmO+Fzai7Nnko1M
         nArY/jRKbFVaaTGinjryKOhyLtmtd1O1oCMh9ndBssiyZkUQSp2M+zHPLsrDSLO3HoUp
         FG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774593920; x=1775198720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9CZF18FR/wzFPTRFS//7fB0vxgLV+gO2BJewVZGH+2s=;
        b=Is3XGe0V1cqDgH7DJgxFdMwKqxcI4Nx2CxoKBrk7SWADnL7gA91YM8tK1S5hknnITQ
         buP+BP5Q6qXSJeYlvdPkfLy8tKOXSOcfMwMNurMHDObKhbJhtXFWD68SvgZKkhA1tsYZ
         gNlqxka6WQodMGuX8OOzbJbgo7YNMJWK8FlY6cc7HudLuc7CYuOGREfgxXI1qscXoDvm
         20hE8S9ZZtJoUeDC4FyPZCAgSNJtPUuwnVwQzHn55JaRCZKkhp5+FsgtfHIs28yWiSmm
         oQvXR9GrsTjP/Q42OQNzfm0pR9EpzNJZwGZa7gdNh9j/KDJubHkzmZIOgMKxSpL67R7W
         m9xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGk2K+RjULk/U3wq9Oz7xe/zy8EfIa0wtzwOTER76z6QrmCuG1rRw1tPvUMjdyZOQ7xG7ETBuiYw==@kvack.org
X-Gm-Message-State: AOJu0YxfP2WNIEN8bt+MWf/hmJt/if2zA0Ad6H0cYQg8OrtfYhoKNsol
	LkbR4ptt8sNQTd5fDVJaKjSLZNVEtDNt/+054jKhUe+pnsSZlKmEPewQ2IR72w==
X-Gm-Gg: ATEYQzznqPsvQaxUx6tosGTEfVoQGx26SRtebhCXva6tyK1Y0PuU/ebg9OMAsb9sAZy
	tHToj0cVZfcFwHG3arQf84Y4LKJSa7zSuEM+sz7x30CrcuCJ9+WdMMLDewLZgUlf/Uw2P5Iqt4s
	CnKnCLV1xBQwPSC09SaMqL8PdivkYRxEPU9y0UDGYqNrmcwzQqdC+XnzvYIm9isY5CQL2IvAbWO
	Z5srjxztv3vQGnaTh1AKB5CBT0tEpods5EzGWM4GPlw6o8ATsatKB+CJlyghibcEzQp/dsmLdRK
	6LVajrn3fKHN81MCeyZ90ad2/0UZgFYJpoxBPlCdWtTMxbd9JGYQCBYCK+z3BJEt89Wo33CVxdH
	FXv+wBJHSMM3qbx5DO0GenatBWqYPSqL5zruW9K+cJT9LXXYfFn5OIgboo+DjqRIYkQKMjdsQkN
	XbcdMpU/zFYHJ3z9IdL9w/BPj2T5g=
X-Received: by 2002:a17:902:fc47:b0:2b0:6e60:958e with SMTP id d9443c01a7336-2b0cdc1ed78mr15837445ad.7.1774593920106;
        Thu, 26 Mar 2026 23:45:20 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76ba80sm50595435ad.2.2026.03.26.23.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:45:19 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 14:45:17 +0800
Message-ID: <20260327064517.68131-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327062627.66426-1-aethernet65535@gmail.com>
References: <20260327062627.66426-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53007100005
X-Stat-Signature: b8nmfu1ps36fydrfkj4gbske9ffuic3u
X-Rspam-User: 
X-HE-Tag: 1774593921-935645
X-HE-Meta: U2FsdGVkX1/+6YgS8HaVs3ZItbIop+AuAtkTbpuFDOI/b+VyHOtjM4vWTABcQqOZU0wAz69DdJ7GqNmj14BJwzStrSFYSN4HYEZQwu1L6F/hGd7VcDHBP9xtMgBfc/gr27R24clUYSsfRPRT1ZZj6BwESWyL0Bhp37d/ClT9/+1upnaaif+e67yDRMVUPLTn1SDoke5i7nDCBVPQ79ppDy0HbjHXAQqfWD8CdOJ3m4fYAOXDpS0Lza+kIkTWfjqK4bmjw0wC5kfI6k9GaadPyQCRzHqb+LGIILhXnR+k2RTgHf2VzMKWlU1MgdZkCuO9+c04qQEQ094QcIhlPTbTeC73PwijWHz/CQUHxeBIXuuAS82J7gvX+nszpFTCC5U+aCSiNHh38f2Wo/1HEfWTT35KrnS3f2hlf3TXb52ec18z9+KhayiIOl3ZevNiQww/YA9GkVBBT5rwhHGERmuHerrW17qo0W2T+a7kcjcGcS2mcnZ62dydJKdvjZB55Pv8DQ5iO7EOnp/A0QAYFB7acUtzHv5hb6ZpGGa+9nKJGmta3oJZy4SaRrgCq41dEzoZN5Qkj2SsDE3ySTzOpmS5OVpfBnIKg6n0NKP3E7GrjPmN7afUh8YnvbSS++6iJyw8jfXcSEr2OkiNYtn3OUsDcxtTcjQ94pUNAEDuvZ2VQ3sym9VIzsxuOnBpOKvB0KTvfEYGteP1/yYLQweeXhKglnoGAtcLxGMBrMVaYjKHVpyn7+t9hbXobUHvbZBUxHdJmww1IZnwwFgMZ/OLZaHZjnSYyVzpncbc02u8oll8TKX5QdrqslUL8QI55XLvSdSbC8pt9znTDNh7Ls6SKDOncDxLMZ4GHlEfvVAZwmNdbklT2W2LdNny3ecJA0B8eZjlVQvEXPy89Ju4aGn+jC0tjEWqr560MhjAsfvOSNrEtDFG3PobJ3yIt9WDEZ5QpFGRqg0HbaC8EjuOBY17nJJ
 /HTfaY6M
 x/ROeOVPFT3I5R7yGZVsjlddbC+SAMlkejHT4XOKxcelQqRw2s28jYTlI/23cNFOQSbxu3rMphNjpQppus2hE063P0yFtQLkwP68Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

While testing, I noticed that when damon_commit_ctx() returns -EINVAL
due to an invalid 'addr_unit', the kdamond stops running. I recall you
mentioned [1] that the kdamond should only stop for "internal error":

"
I found an issue in the current behavior, and just posted a fix.  Assuming the
fix is merged, the behavior will again be changed.  So, please do this only
after the fix is merged or completely abandoned.

If the fix is merged, the changed behavior will be something like,

"It will continue running with old valid parameters if the parameters are
wrong.  It will stop running if the parameters update was unable to be
completed due to internal error."
"

Is this termination behavior expected for this case?

[1] https://lore.kernel.org/20260319151528.86490-1-sj@kernel.org

Best regards,
Rui Yan

