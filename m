Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF4DCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 00:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321266B0005; Fri, 19 Jun 2026 20:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1706B008A; Fri, 19 Jun 2026 20:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9976B008C; Fri, 19 Jun 2026 20:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0C1D6B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 512384054B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:36:06 +0000 (UTC)
X-FDA: 84898423932.01.BB13DF5
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72B38C0004
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:36:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QQl6j01h;
	spf=pass (imf22.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781915764;
	b=VT/lENz+Nu9YyIjHymBSDlWNUJFqAlm7pu3k32Rbaek8iGU7iyRHuRbsaERGa1WkMH4Ehe
	PqMtvxXl9OnFoAbbiWJfF7MpMrUDnRXvvuGLllxqVJ7OTj1QfqvyGK1YatxcqEYJMepni3
	kJQiUTqqJ332uJy/wmmIjxuy86aMARI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QQl6j01h;
	spf=pass (imf22.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781915764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZGHTu7ZWt8+LY2ZTmgpTwhyxwOuYUCiNXzS8M6bQ5c=;
	b=2zSkmISbK/GXqMJ0Am8AZClM1WsegvCEMklBQWS6zZPs9MF05tHv66SNWrRVZ/omQZdC8f
	A6Ta3x+l+6YVEjiLNJv1FzQseskH0TtSl9MclmAEwop4pEruU3Kx3fzCwB+dZqOYxJ/jAU
	JIPPl/82H18u+7Lvun5KU9aeiJT/lhQ=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b3637b90so19692465e9.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781915763; x=1782520563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZGHTu7ZWt8+LY2ZTmgpTwhyxwOuYUCiNXzS8M6bQ5c=;
        b=QQl6j01hRbXyvvRP4+nyMcV99IgPcaEGiF7HUnCDssjKpM5Cg+nqBqi8fId05APIBA
         0P+UfqGK1LPxoo4VHAsbNM0dCKOLKF9YHPpKq9XIM7fIIDrue4Pk6pmTSijZBwKqffCP
         bOs9pQfIuCGW3/4Jlj8XYKRzfqojpmGOTRyVIVOXRDWUiVwanAwnScvKu78jBFPqLkhQ
         vXapBFtyHWJhdbIRXzTBT3TgDC6vQvoZE9RXrysFSRQnRwwZRQTg/TKXDzn/3JbZPpJp
         BB139no1Dzm84oYMf4gQH21rXY3xTplLzTkvVR/i1n+y58Cf1rnRbjO/3gWOxYCyl2vG
         ehJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781915763; x=1782520563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lZGHTu7ZWt8+LY2ZTmgpTwhyxwOuYUCiNXzS8M6bQ5c=;
        b=OmlXhNQs7pXJ5Z+gBshLM8tN2QEBI6HDmefAxCBhGk3LjMyiqmkStbZbJ3qbuYhWDE
         tmq5Haxqe95Bc5L+f+E8pk7baz3BXLYJpcrAV/DpZOA4/kLghdlWuAHV7nIu0EeUeiJE
         rej0NQ2dJAI135ZQdG6bCXW0X6qfO+8btSnHjIrSLS4IegfFB83I0PgKcVMA7U45E2lC
         +svzr/1/QWFnc+wkcbxWAJ0cEPFVzqsqws9/9CVQOHJk1AiefDkcT3zeEHxGYd9rGT36
         S5kefEMZ5N9EzlmI3a/IZlzV346wQpnXSOV+vh42rvakTN3riX89ASRtkhRK5BPRCJNL
         O/1g==
X-Forwarded-Encrypted: i=1; AFNElJ8IP8CJxIa1+Ql5O1+MUu0Dj+tmWIJ6LsJ0Cz3/c7A/rSo/2Saphf100VjrBK/oPNkCLjs4lp7jew==@kvack.org
X-Gm-Message-State: AOJu0YzU9oIXSH1w9iHldik4uNDcPDdBANvHdAnWoBmN/WEC3vJCuyMC
	xrqE1mVKk/yn2x8wY2T/pXt/aT/4BGigXDKq89Ptj23/jl+NJocvKvgQg84q5Q71kXE=
X-Gm-Gg: AfdE7clq4RvisEySJ/Ra54eiMMzLTGXa6pd7M/RDAWPyJiky97kPhLfLkjYocYjncCk
	SbdeUEKSR04vHNmlf02JTdP9bwom8BD7DXBgduVYQf1jHOvod+TN00zBWB/aktfpH7tdILvDSLV
	4NjTXVXidgeUflRm4YlyvQ084afsd6Rq5LyYVHWzsyRpSk32gRJKvSawKDfk9/+H+tO/9DlQ0+o
	CLXN19IUVuBrCpbE5jrpsuSCMxY6zR2Vbg3Usuh2e1qqWZtHrPKseFiypCvaB0pQBZA7Hlk7fRo
	TE0Mi1c2e71KbWLa7+PTSaUanR/n+ivfBce9u8/KhUUcsGmajh6/S1B+JpDx5CqxWDS1M6piYDH
	k5ZGbokwGlKecmxvwckRi1WwpL+lb8xGeSQdrYejDvta4hoMTgaG5XCZ8mBtJaekTdxolnTF5zu
	bg8B2qqtrW+xE8SK5SfL4H4g==
X-Received: by 2002:a05:600c:4e11:b0:48e:6db3:ff2e with SMTP id 5b1f17b1804b1-4923f33d921mr101272725e9.15.1781915762907;
        Fri, 19 Jun 2026 17:36:02 -0700 (PDT)
Received: from user ([104.28.163.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492494497ffsm22020185e9.11.2026.06.19.17.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 17:36:02 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH v2 0/1] fix initialization and parameter issues
Date: Sat, 20 Jun 2026 03:35:56 +0300
Message-ID: <20260620003557.243313-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260620002614.83004-1-sj@kernel.org>
References: <20260620002614.83004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72B38C0004
X-Stat-Signature: f3qnemyduu75kkaceqbnanzrw8oh9jp4
X-HE-Tag: 1781915764-808486
X-HE-Meta: U2FsdGVkX1+qG9hPNFHKy4TQjBx5swTK7Dp54VvrRwuMsTm9TzFIz7JG7qKPfQ9h+rRVZjhTDYTVLU2OUIciV7Ta0A5+mPeloZftb+VYWW2V0Hjhv/308f6Z7nkPvKDRyLu/ic3YUoPx8OctMijZfdEre0GgqTqCWjZHyWhDJB3XBFcL6TX8IDPZ+ErkQ5MnyM/ijqzBdxhcmR2FiwpyWbVhd2tTnjLyAZkY5iG5YZli+HIIy4o1bfDFtYxU6YbF54+UQfHIkaEnrcJVIJO2rOz2B9s4aUNgduOkSrbuCIhLg4hpn+tjfkouTk096L4VLwv8vNF7tZVvPiKqYf6OJ3IhoivFcSpJVpYhoqsJOSeK9nTPGUL2Ivm0v0jmy5ZqveD8Mj/oSNbve7eLMziRf3SUtsON3+aO44R8kmJDB1GaWbQzzdQqD7HPVUC52bksF6MqaIMBoe/FwQrAYYQS8WufbpLkljscEYKHjrEYa0rSmV0mrf5jxZH1wQ9NItdyN8RcFYuu04+w+33RJIpGG/m/7VuUHsRRyxjBghXMSLniJG0/c/G4RmPcqXW1JityarE5+u4WKTVNRGNGXUjcFFS/N2yxAlXdbd8sWdV/4N6hJuowGr0OYk2dzImQ2Je3gSjJv912s1x8Pp17jIHeFjC6oQLn1lb8tboAp6coxL0C6qrkzgeO5ssTfLjlB8OZ/or+MzEyutCEnqDGwwesxUzCme0BBgRtmj8Rxq2oITR4sQkRwMT8X1QAiT2jBbFOcwc6vjWQmiVlNH+4qkS2uJWWsAFFoc/fvfKnSggrZT0Ndfy2WfZ3ijhdeE9VOaeoy+X/hV9OjgmoHXI7nKcYiMmzMn9VWgimF6FY/qACGyryakQ1mb0UCMrbg3JD1EbSuZsQuO0QPtqzAIB6ZsEN7N0xB4tQ8EhDGFvNOeeM/qx86GrO7bP6ffypC0x+5XOkEkFLPHz7h32iWlZ085O
 zENXd/vo
 QAxQP5oZpajB9BgMkpHFREiRvqKNu4MJXDXbwvwKS8bIvYUgkH3D1yVIBPxc6bX8S/mfr8BnC+cG585ByT7ilqmK3DnMX9YSEEa4F2hVy3X5cK7d2Gbl3uga+q3I9hOL+EIphwmWXFfPBEPTu1vCpZg+kDX5NDce5quuvGcsvDuwSyYMHtxOidyx5zCaPv4e6LWvRCKNB15aeFfa/RIEoFxlksL9lh4VNgJh9XecucSza/e8Ew5vjeZ/XQ0Pid1BeOFEd29SPuHghyRZiNMJ7V45iarPjBpSpkKCOXmDxYPtrUY0PvO7AbKrdZOxQiy+ZSHpu+9ln8yz7IRVMTiCfHu9Fe34RgDuismAFyftCNRBljJEdPtvLHHFoD0rW3b5g8CkHxtT29MfuufMP2gF0qtNNDcUDHKbLGoTT9dfcqc523z4elsDMcru1rARPayNCg7tLO2/ym0D3seONvFVQ1dWaYa9Zm1eN2PnrisYx9bDtBau3ar9ghOELsq9eX3W03nEuoxPAfm3kZZFD5jdKEiRwDtxmlg1/RxJg4IojJ/44bmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

Fixed a potential memory leak by removing the
early return to let the function continue with
out and set the ctx variable to NULL to prevent
a use after free, In damon_reclaim_init() function
if an error is returned, the ctx variable is never
freed.
~~~
Changes in v2:
- Remove early return
- Set ctx to NULL to avoid a use after free
- Fix typo

yahia (1):
  mm/damon/reclaim: fix potential memory leak

 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.54.0


