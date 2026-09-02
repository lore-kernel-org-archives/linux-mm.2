Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F50C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DDD6B0088; Tue,  1 Sep 2026 21:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB80C6B008A; Tue,  1 Sep 2026 21:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA75B6B008C; Tue,  1 Sep 2026 21:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9216B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:56:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D96E1A0686
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:56:44 +0000 (UTC)
X-FDA: 85167158328.10.F6FA6F7
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74043A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:56:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMWNZidr;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788314202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0iE/WlAJeXqXVC99kZcLf0HoTEM4Su3/szAnydyeKE=;
	b=VN/ih7V4yuQB7qc5UmtyLalmU/IFO2SMUmKPyESUSvH6w/WHUt+o6ZWN65CrpLC34MElqh
	/JDWaj1riBJMUT0cpz0Ml/JnBy9ZnMx88nUMRMjirK0yDnMP11uK8pa1h/7G36N9QJD6Xu
	BPnwCVMX6fUIiZwFtTt+iLmjqsigX/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788314202;
	b=vaJIiTRYRVlmu/DXhU9W1GFYcYPukQuFf2wJST6mq73oryU67JLSWufIcGeLuW1vJ+OQLm
	9XriBt/uwOADoFCyUFG/sDfz7NqpfL5RHbIWqQKwoC+rKSj1YQq3iF6g0cfvox40R/9h/n
	13GFiP4p2n6oBj9lKWl0zHCSfrPYg7Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMWNZidr;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so500548b3a.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 18:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788314201; x=1788919001; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s0iE/WlAJeXqXVC99kZcLf0HoTEM4Su3/szAnydyeKE=;
        b=QMWNZidrU3Ri2GWSehJvMNA7upWss0WbfXTNELiOaE49gSYCm9EniJmkUwv1DqRX2T
         eT2QRqi3JblTaJjpzEcxwEuyizlMNtYgmtwgsDKJTxLSlBcHzaOETSo9fge1AAuJi/Pi
         Ik8P4e/LcTgCIcleNqC8TC1xxhL6VTosmqN1cIhI5INAt4drqsR8dQqPW4rd0flPbVM+
         u+I0aLt8UYEBIt2JcZ1D7pTE8zo/DaQu0HOLAOQnO+gHSObVq3j2K8bjwfRSte/CzxKC
         4mdXCD7pr4lA8/cpcF9Nd/8IAJTuQekpBOw6VeJi050g2th7+7UA4s3eA/j7uaKAzNMZ
         YlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788314201; x=1788919001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s0iE/WlAJeXqXVC99kZcLf0HoTEM4Su3/szAnydyeKE=;
        b=APY6c2O5CpYF6kbrhA4hq8cDE3iCG196hV/QyMaQzGzuMKZLKNcQsjwX+DY28sxFDi
         O1hfKgOc/SX+Qp01WTDGWh3GzYL8sIQV4+mW5D9ne0Ym0nx0jqBIoIO9mSPDpvn9uPqX
         7VuWMH+OHEItTA/F3vQOH1GOF8CCeAaESSM8yISkOVNLsMHoMz8VwV7Uuc0KoID4w8GT
         MzF7alaGPkBX4rn/tYe7ETcMqIayYr2icewZ5Li4Zx/CKYpYPGxixHArJtJHahd4yPS3
         ubKzXr65/UDYzrQZjuc8EpdMXPgydwelriXMO2uCduhQKnb/ohX2juSXWzOKboVGzkNm
         N9zA==
X-Forwarded-Encrypted: i=1; AKwUvByyR0HB3JWcyX3e6HWz1FPpz30lKF/TLnw2LmjqPB5+phhGhXI295M5zH+ZubgCmA/S0JweNk4c8A==@kvack.org
X-Gm-Message-State: AFuF++mb0Q8mLXaI/8kLuwCvFV0nsQvoR9T55MIrlwOBiVTxSyZkKiQC
	f/TK8HDsWvN9Vrtyu1uIzoQuk41XCakbWqXeLskdcVBg62gCRPenC3Dy
X-Gm-Gg: AYBFou1gEIFVuHHESHhfeHwBQsvIT7rviaexJlDQ4MrTbsArAEay78d1NkxhWgGtFHq
	sKqBb7p33q3jkKFnUu3t9S3GXjyBjpaPEfgP3rBTNw9WD766bm664Bekv/deqILPIkXMfooDLD6
	NdrEEVqRp0NN14ka2triZy2C8bb4OGN8X0Sbigl3bOVTehvIphdkK9bWKEu7eFYKzWwO9EwaOy6
	mlgRVrkpECH1Dn//Sc2MJo57xCmxwHtrEOwsV3J1C0j1Moa2VpK6scfVLR/8dhSTTYOA7HkP+JB
	oY3E5rL87HRds8bFbhN3yqrd5R7Q2Bi1FCsii5k1wQDbGTdu5W35O99LbLgudnNUomziIueN567
	oPEEqCDLwqdFBF/B19OtOdpv+gn4vkYL9T6Z3pSDdtRaYJM13zHamh8wVbMWPozjmjdpeblwvYC
	k/v3FEGsuDLlTXHEP4/oxWyodAuKPHkuC306jigrkb1P9gv61kKSxQV+/gOenBwrzuqZn67KyqP
	0k7Hxgfm+bK+C7n5MmVPfGw9Gdk
X-Received: by 2002:a05:6a00:1da5:b0:857:72ba:ff0b with SMTP id d2e1a72fcca58-85ed3f70537mr3178673b3a.19.1788314200492;
        Tue, 01 Sep 2026 18:56:40 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2ad8a45sm590819b3a.18.2026.09.01.18.56.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 18:56:38 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Wed,  2 Sep 2026 09:56:01 +0800
Message-ID: <20260902015616.57702-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901142307.100701-1-sj@kernel.org>
References: <20260901065847.42869-1-lianux.mm@gmail.com> <20260901142307.100701-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74043A0006
X-Stat-Signature: duu64qjx5aixe6koh4arc1udas7873yf
X-HE-Tag: 1788314202-610469
X-HE-Meta: U2FsdGVkX19ZfD+KH/dv3+xEiuvjRAXKnaBD7mtOrwQkgy/O7XsYK7Qw4MV0rv6Vy20cwl6K4M3v4l+gxghFG/WYPI3fLo2/304BgSS0+PTvdU4LSZ4QBNKaDbCIm24jGsSIsoZv0auBvYdqAbc8TOTye6+y23cRUPA8/lAssdz3TNzSrRzMp9BQBrqguIxiFfOa2aDnmiK3+DeMVeABIQ3yymcScPAbjQeutnTCgLlE4qyo20XPwg7JZ5+qOzTurJdywq+EGu6hWfHCnan2B3/N8zP7ALJ2V8TkTdxoAhnFKm4LUPvNJTQXoMAw5BKJGTLV7IvQuGsLFEHNeWboF4KuNLpvI0f5umFS71YM3mACwwB5mhuN2Fh0kIjGuwopr91Wyloixwzoe2vPRXBFpbYJI6pfSn32MVrWILY2Zj+v8/APrzKobGwv0jGQVT3zUtHlLNyqYD4nSxe7XS0pcIRfgXpyJBgv4NA0VyJPvzSW3ihDkdPhCQGDOR0N5YOeCpUjpSfHXw/lCPw1WYRlF8eUSUEgZKXi6BphF1BqwKZYuAhBReoc3dK5ZH3JY0BWF/6ZwrefzJsPk6n+uLCufNR42KrjKPb8csu83N93PgzFuiMmuCILfHxplLUYSbzmbhBCaX7auJz+nesMI2HkwpqQeVBoTUk18UnsRTOmpZUv4ata+eMLPLMiLFuO2nEX3u8GqX7ghH3Et+Clb+lPuVvBD7kPLPCGvPF3mDIt7t9JdCWIRPP5HFxDhnCHv+tsyW6jnm5CHOH26VZkixoU1NJbwZr9+EinL1x96ZT8j4Ch8qjmFB1I/UmX4K3oA9NhenUGN6Is2+C4OpElfrBB1l8Q/N7Z6EkXiKyWJHYJ4u7GOdhFHy4jvLtHQAejbZ61IQGCmJzK4eTUcPX5+vkCQj24G2Zee8Fsjb5HMKBzw9TiEY8UpOHLycZWwP7QrOQhQS6nq1R0fDtMlPV/BVE
 TLErqn7f
 Q7zRmo6tii8OdPuz15Mh2a8Nno7uezVjn07vu4ARz+/LlPSgNe6nt8Il+sshrENE2a63N1xmFpgq84MtJQEb36Mqj+UuhaVUAKTBzlD+uIly4MN2Bya4vuP5tB4Icux+52eR0ccEXDrVbOibnLTClv0FhqqBrTjvKZnX/MjVGzu3uUKPDjKRbBxZeeSl3yYB9S2KmF1MBxYTK53ahukHln6EX70xsnWXL8TO4soxHU2byoaZScl7eZOPF9SDIIaxdSzbX8E1GxP2wAWzx1EZAr86co9BoVmhloS7F7l2MejpSwzZeu5Zq4dvf0SuB8oXxMkTsX6XYP2JJucom01ClfiCXAF7f0m6TLIbJp7sSrPvmnxFES/kKykxCbQYYR5drCwAuHXV+wSGzgNyCEfkKuAbz9lvj5XvzouLtSaXaH1HJb3A5qxFx8+32D4TMkRwPXVfNAr5mX9gW9tEWokkc7W287Ac7vfaEujl5clQ/pDnoJY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

> Seems using MTHP_STAT_NR_ANON that is exposed as 'nr_anon' can be used?

Thank you for the suggestion.  I will study MTHP_STAT_NR_ANON and nr_anon
further, and document what I find.  We can continue discussing it by email,
and I will be happy to review any follow-up or updated patches.

> I'm curious if you and general reviewers need or prefer to directly be Cc-ed.
> I was naively thinking people can search and review DAMON patches by
> subscribing to the mailing list or using the archives via lore.kernel.org like
> tools.

I subscribe to many mailing lists, including linux-mm and DAMON, and I also
follow patches through lore.  Direct Cc is not required, but I appreciate it
for DAMON-related patches.  Because I care deeply about DAMON, directly Cc-ed
messages are filtered into my important mailbox, so I can archive and review
them quickly.

I am very happy to contribute to DAMON, and I look forward to continuing our
discussions and reviews by email.

Thanks,
Lian

