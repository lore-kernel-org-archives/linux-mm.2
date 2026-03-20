Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69815109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798066B03D6; Fri, 20 Mar 2026 01:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7498A6B03D7; Fri, 20 Mar 2026 01:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685C16B03D9; Fri, 20 Mar 2026 01:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 570E06B03D6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:41:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F67DBB74E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:41:59 +0000 (UTC)
X-FDA: 84565345158.10.2063F0C
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 586FAC0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:41:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmgfa6Ca;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773985317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGYrJ0QxuzHFARnTiEidMOinf4xSTXUjL5SK4rWgNlg=;
	b=sTyQLD0LK8Ye0VdF/6+kAWwYpx+JS2dnD6Ccn4ly0cmSjsN3ULO4CrvJZoasXkrBlohCQ1
	pEi5cknZRx7hNaWr39gYZuCxVRfuXy546zHFRVvnVfmxTn4zxBrKu9134ycfNRw+cOc796
	rLaHqFx3qfNfYaVhjxDigsq1M5Q5E8Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmgfa6Ca;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773985317; a=rsa-sha256;
	cv=none;
	b=sWR/bgbzzWLJQ0HT8WDbt2cMssy5W0glBlqbXYtdmB2iGX4izZ/8pwgv04FGVQmdxniwLS
	bVLwuMlcJs+scBjzeyoymELU3ddo0gXlZH4n+pZvb390MQTPTdzL4hCReGpi+ky5XFo3ee
	OqnJ0BatGAXQRvIYdnwQlUu0MWOaTS8=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-829a27414a3so170105b3a.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773985316; x=1774590116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGYrJ0QxuzHFARnTiEidMOinf4xSTXUjL5SK4rWgNlg=;
        b=Mmgfa6Cab950QLEjItfatr2n8/LZSkOeF/qYB88HAGoztxYBI27ErpvgSvDSgYrPlL
         66jilnM37Ggts4YP4qWQJGMjLdAmtoZiVuVY83pWlGdu/JCdXTDjBkyf5yWDd1LevMuK
         ae/nTKWWZFZtYPLKbe9/O1B8N2lpa1tE3qNVu7boDL3p06BP8Ao0xvIEfsDzJ6n5pn/f
         R7ObyoQub+/hk29m1G2ZAGzix0r4irf3NoY9BLBCzKwOhQMiNwnNaKuSQpzj7JyDE+lY
         DzHDoM6YahjU1uPYw0OS5XI0nWQyBF4Vu4ksvnbnVKMtMG8zc0JEqozQfoxYRmP7J4HP
         Cv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773985316; x=1774590116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BGYrJ0QxuzHFARnTiEidMOinf4xSTXUjL5SK4rWgNlg=;
        b=RCtxsZL7fgEm/bLSYGx4y9xIokIVGP0EpCS/vBt9ma8XhE8/CflWm5V4Z5Vc4RFArP
         cQYFre8cJD/NVYo8cW/pYF4etspH74Dy5cmA2jhO8gWvRViwMwwgh6+a/uKXUTE1xAaT
         9C4N/0aHqASQwAnFv0LK3LP5ZXHD6jJqKyKXiBIiNdq23DAL3zAIp6VJW3Rhia5mXWkJ
         D6v8em9jqdbumlp9TUvJDaRhDRZHsZ+XGqOK56ZIOh3ow2scRJ0KdPHIDNOebKU4WhcO
         kzhHUaj4rDIS4Ho6QXp/0UNb2igbDiF9Ac1JqBmF9hPnRhqzQFlmJ+V6iSiSHNB+5Ra2
         f60w==
X-Forwarded-Encrypted: i=1; AJvYcCVK5ZtL0ZjLYodCwF3DyejnApO7Pr1Vehkb1y2OugX2hYT7t03SYSR2Z79Oxsly6u9++HjAUtYN+A==@kvack.org
X-Gm-Message-State: AOJu0Ywo0nR2F/0zvduXbvtqpSAhOEaotuAUMY0qJm1T8UBxmjSPka2H
	Lk/SHO9CnHP6joDxk9qykCwOux/DU/HiB0cMH01+fIC7nAKFThcX88eb
X-Gm-Gg: ATEYQzyCEWw0FfA6+7uSDnbpec6u0kq+qBoyVHyb5I/GlFsxVUBFOO9/mUSj5L3v48A
	1KG26gntVGIG7OW1aJRFt29fFHgfOKJGnGqH0dgXFlYujCVkqRRnvCK2Nj6HI3kJVZjSVePxc0D
	Rw1dROsqVrO1fZZdppaMI9audQcblOCk3E0ezrtRyllQX0w3HiG7tP3wpWaeGkQC+fxZjCP3YP/
	NXYvPKtBeoYNlZPjmOzLoDHlfeSCukZK514rDWyCU0hlB72YeqypiO48XZNz7F6rRrGpWD5unhU
	QsvR3HzBJAXj3mkxGntmF7tu1J/qckZakneh0/OXAzsrgxu5mi6oIvLlFvDuynE3VL0lPugozPB
	mgiVxvNP0lMyYtqQX9MN16R4KddJR9Zex++xOXsDoNbUxzR8qcsRLej70gAYOvvKLvTSDEhpyvk
	BD/FB8QdztTJXDU56UdgqJ4ngB0OeoqH1AizJlQE25D+4meJZw5JQ=
X-Received: by 2002:a05:6300:8b0f:b0:39b:c0b5:b0eb with SMTP id adf61e73a8af0-39bcec38ef1mr1624946637.67.1773985316235;
        Thu, 19 Mar 2026 22:41:56 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc9edsm852792a12.23.2026.03.19.22.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 22:41:55 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 13:41:45 +0800
Message-ID: <20260320054145.213945-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320052428.213230-1-aethernet65535@gmail.com>
References: <20260320052428.213230-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 586FAC0002
X-Stat-Signature: mn3cji8ot4crocs6177fxefxzzn8dhgj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773985317-552298
X-HE-Meta: U2FsdGVkX1/VGnjku7B+6LK+KNpgqb8kyn9A0tNWXJ1ZiFW03aTj1HvYhLlK5rW6Rpxguw7xkhJbFv5SrOZiq4GCrrd8CIn1k5znV3Eru5z1FS9cx5EvW/MgCbbaoS3mkSM9oeulChQ6+5gAHEOeHamQF9HATYseMLpKdDBU8gTcwgKnhP3XQfqjub655HvSZRAQ6uWHSbHXuEs3rb8JK9SRHEb4fd6IKORAyJt2vQwQANDleb0wE5T6MDhR3HdFu7OSojhgZGOlOYSBicMMfPZnBV9n1kpacJdqQDN2zN5qSSZKaXc00Id/glJYWgULU4B2MHuEYYlH7jT7h8hNlnhsMxDVgZudMc4ZtdoEfpE7S6Ckdh6G6PerRAvavcNYzz6QI/e5bFard+mfPiKsHM77OEcg2xSRyoG9nTcoEYZW065R49wWtp7E7B126fIImEdE1kyBgFF+/p4FUzq1wqOarzZnC+sPBfxovA8QdwKP+Kn5GfpcUcDBglcQVva72EVuM91PF4r+e2prstkZmyUBN7mh+0uU2E3UYiiOgZBZD6u6pn4VMJFVaf61RZ/vnbMXX4pVkQAbMp7WUx1Wse/yAVzyl36J9aHRPq/9V6hB6oZc5yjddASXJEhBhPKv6wRIZVl1U3Dt/HjSVAG4C7+CSugvOO6LQwz/NgjYmI5vetYhKtU7klvqbVfTBj5n8HmecpfzAVjtbB9wbjngJNPz8VKnps/jI0F0pzsazISQWgxX01ezm6hqmRfTbjsSY60m3lYpdEtcyQBUtKTwSAMsDe1IIOVN9GpwyUYY/lNXtxZ6mVNfKBlpd3VT+W+cZubkdpwNKqhEAysgHGqUjhwYLVCnG+AZxtkovXSyL9x12P+sRSIhPXbD3H1Vmyd5K7L8+/u5zlkECFCDNHynYWTXaz5Hn2wN5g2G5d7pqxIEOWtJVmT6Mmt0eRwTL5zuOKZ1ELHPtVugSDZMNTm
 EelRDVu+
 SgVhueeVTA7ovAERBYSuGgOcP45zIjxOQhVyUm9i1Dv9w0mYRC8cPHoNmj7USPn0nI6hq0+KiFgMKLmFT4BVwI2w5SVuWsgFKzTT0va2CwyzEYRQJqM4qharFyzprCxcNrbtoMGBvnJtYjapTPOTvAqALR4/Uhh4hulUlkmbRgH9KDW8VLeAoEhHlu4MicYEke9eSI65TMnZCGpUPumSl8BjQY5f6DskqlvnC4M/kB9UC8cKrIi3mS25M6nRJosiu4OZ+sT9iGXfkOW+KWU+K9y4MVLxhKNKXCy8s5NcFvznErbdtUCe3qIcaRFWjvujC7+ADV8gXQhaECbMlAZj1cKPwgRhi89xOqH4qpEv3E79gteVKuwpzJpffTDGb2CyTm+iooJsykUBVoD/3Mt7Ml+J+/FDcXNt1WKy19+yLr97jR6moDXZX6u1yCGxuFjPJTQGciGvvrFlXzwtBP4ZR7ypQzltGkdD9KoxmKMjk2GFEEeIJ8gDVC4ET1ezcTBLtOnt16czu28/bNww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

I'm sorry for the noise; please ignore my previous reply. I accidentally
sent the commit message instead of my intended message.

What I wanted to ask is regarding tasks 3 and 4 from our earlier plan
[1]: should I wait to start both of them later? Or is it only task 3
that needs to wait until your fix is merged or abandoned?

Also, I'm preparing to post an RFC patch for 'damon_hot_score'
optimization soon. It aims to provide a significant performance
improvement.

[1] https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t

Best regards,
Rui Yan

