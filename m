Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70645CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 00:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED9D6B0088; Tue,  2 Jun 2026 20:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E736B008A; Tue,  2 Jun 2026 20:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4766B008C; Tue,  2 Jun 2026 20:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 377F56B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:51:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C634C083E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 00:51:11 +0000 (UTC)
X-FDA: 84836772342.28.6996733
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD4651A0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 00:51:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0CGVXk7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780447869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpWej4lHI3Jzfw+An+vLn1ofBTEB35ebLfh2RvR4+T4=;
	b=a6GIwYAGdNyEmx08W2KbczSHcNPp1DJPt2kHgusxqqOqmNrAUmoFizrvfhTC8YWCGHvcLx
	0h6MPxiISqt4L5pCZRGBhYU6MvkH5V4pyTimVvNU/3eMliUvhjPBx6VObLyP3+KJtZbLfs
	hCHKS9Sn05KNyEwm+Nfj6BoduPvQRtw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0CGVXk7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780447869;
	b=6h10OPtMsLApqZRtUlWoqmvBTHqhwBIbfVrM1OAllKdG7wlp2ncrnOuiWSxPa2amIGulDf
	c2vVdGuk6kSK040l2T7ZgzDcYkajrH6LlIvkAc7SHV3OsEHpp9iN2V7Vrx177La9c11imB
	UZpHlW77gphpBwlAw3+leieTUiaLAuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADDDE415F7;
	Wed,  3 Jun 2026 00:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1BC1F00893;
	Wed,  3 Jun 2026 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780447868;
	bh=vpWej4lHI3Jzfw+An+vLn1ofBTEB35ebLfh2RvR4+T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0CGVXk71mgV4sgYlfGTQozo/k3BVaiPah6GH42duukBz9SaIScfVFebBJGqDlaxL
	 dReP5BgZtSZojHesOkuGTePCbuQUu0BB78ZAlV/5IoVKP1O/DSbHegF2j/Wy5tXmJe
	 9HM3l4vMv61cWhCYGI71diAHgL9tya1STOKNth1s4t+nElpXNFW+2s4EFsKf4Wku4Z
	 nltgyfk9V3VNGuS61boY9imhKc0FM8qqfQr/+o7e2rLWjDtYr4UgsF/0xVnMpx9iRN
	 Na4eapBXoDtNC+EDU5nkuC1sNxbLuOVEkrx6Z9Gr00D76jkcJ37Zh/7bVezzQcLt/t
	 KirOD6dBms8xw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests/damon: test kdamond refresh_ms
Date: Tue,  2 Jun 2026 17:50:44 -0700
Message-ID: <20260603005045.90000-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602100308.749f8ae894efc3bb73fa02e8@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD4651A0005
X-Stat-Signature: 85hbkr7yc3ft3eyae4jw5bta7bgcjbqw
X-HE-Tag: 1780447869-888748
X-HE-Meta: U2FsdGVkX19kyIrOYh/nL2dyC1G6Hsr4kGSFJTjdGjU6bxgJ1PHeOolLhvD8YTH93LBwOmkjt7/2pdRA8SMzXo6AwuEWkhd0Yydm9XnXOuWcrgoeESVn5sZ1SHbdYF/7w55F8T10e1kSVzgtZPJfs1SpkhMpF5LQwO4gaIIppmv4Jc/pHFBunLWv+YI5SyAbDZ2yH6KalUoFm7Zyg22xRUNzUcoGDt2pR0O9YIyvVPZUiPYH7dOg9eKQXzy9TVGNq2ptocEQl9z4VKXzuF+CR2rwAfmJNwRXCUKEYp0dJ5n8yka6ye40+EDavtd03gXTMhwuEbgiSe/PmLV62J1trpi+xtKPuAGrG9rKByZ/Zr6Cs1aO+IqTakxUfxtn6Pa3I2oEyOiFpX74AHpDNdCM4nlTAtX8W85jWof7XEdzOIBMFFKbzNALZxTZBn9ZcyaFmDCdKfTyrKphIPoSFtC5uAU5e8s02T4TmQcLbcS/IE5ixbeMbCSzdx8eEUMTabdkjqrpnF98lxTiZihMOyqnppmUAWr4/mianpeb4GcmlAQaRtH4cSX0X3S0JKJ1up9AnjAkzFDjMlr/M+fyhkuqndggHldQ2nA6VEROR5QnCt/Wb/Fo8UN9Ur9c2eLDKMqqtaQQDO0wN7Esuk/oaWb/+i8WItx2B+nXuNQzt2PFT/TFrHWJX784okY/OS6JsLpJKX2gB+ucERr2+t+gqyTnbLOi574Kz9Nc2j8Oc1gkiKrFR4nzwW7ZWJRra/Q4GqHc4kHjsd/i1oMD4c1uxHsGzX3Q0pMLrp8BL/syMyJOyLHEzCvkcNdaq+RVpAKO8bBLCoIoVDwc2Hyu5Tf7W+bhdeNa13dusk4eTqrmXHat9dtY8xDxUtHp2z+IC+bnaGNl+AdWlgGTfSebKtC/cnelJSmjEnvf8f+NRRuv7rABRGtuMaw20rPLEcKlGlf1TnRdenQlGVP+BSlw64RXDpS
 DJQqLuC3
 zb03QegxHqKOd62pSQbQmTTiqMr2qFnRWQ84pcI48MgWpqKsTHN9x2HME58XpLFBuBoCX/Pa8w6gqvGK4BkSgyncAc/5u2wxuGrVi6J3xJD8l8TreAvv5hJzdnLW4s47rTrO0X8oWS8H+ejY1asYMRtYzhPA5KMRscpBG0MaBTwdcIWZAQ4LeSp2Lo27TLOphqZsK58z0pUGzt4NxLiccC0UwR28G/Zn7luWrucIi9xxze3hpi4PI1VYZwhbpMCQBoMKE5e0qaBSYA4ytOR5Cydnb4an7axsvipS9X55qrWX5oQVBrVsnaPGe7Bv6EBFjlHz6naHv23JuTuP1HhFP/4xti/tLfStrcMBmSOINiCBifDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 10:03:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue,  2 Jun 2026 07:28:03 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Andrew might want us to wait until next rc1 release, though, as
> > apparently now we want to keep more time on stabilizing mm.git for the next
> > merge window.  Andrew, please let me know if so.
> 
> Yes, awaiting -rc1 would be preferred please.

Thank you for letting me know.  I will hold reposting of this until the -rc1.

Ruslan, please let us know if you think this series cannot wait.


Thanks,
SJ

