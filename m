Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA50CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687566B02B1; Mon,  1 Jun 2026 04:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EE86B02B3; Mon,  1 Jun 2026 04:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574DF6B02B4; Mon,  1 Jun 2026 04:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46AD96B02B1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:01:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 105981405F4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:01:05 +0000 (UTC)
X-FDA: 84830598090.25.DFAECC4
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2ADDA10000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:01:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=TQtEXInh;
	spf=pass (imf14.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780300863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLPi/m3WQdmSBKWIOTMLaV276KDW7VEnDXW4StkpGCQ=;
	b=ddx7nEd//jaxevU29QCJbF2YRELxdut1tX9nL9NlrCNQKsuFTsj2x6CxgESrjtFOHI3rVp
	AASzCxUojE4/3U759Dms4tRuzxf3u3sngLxK75TT+2Kfgp4QQwOrhGaInjD5Tvlhv1I+my
	B/1dcnpXcypwkgENE9DtwxCGVENwWTQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=TQtEXInh;
	spf=pass (imf14.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780300863; a=rsa-sha256;
	cv=none;
	b=As2sFfyRRkFcsqbZPGO6R37lPFkOGNKCZDfiVBdtFdPMjDAgyuBiDEO6OGDJ+vv0yfuXPp
	e/x5wLB0QH88E4QJeBLoM3oQdPkngudTqq2YVQgFLmvnDwfkQL1IwODUbjGjltRirXUvLa
	EARRnEX8AY9bwx45HPkKABlikZWMFfo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780300844;
	bh=GLPi/m3WQdmSBKWIOTMLaV276KDW7VEnDXW4StkpGCQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=TQtEXInhVYsWxjpKM8S4NfnNPKeIhAaYmUZ6XCvmlL/+EVEntz7hZhxfoIWbWLkj7
	 2kGWq1+LyLVp+uS9gsL/siNM/PfBo+2ERej+NhErdVWVKws8xLxt1yVuac0O9aNSb8
	 qBhmaslhRPinPRyaVvqNjRgdefq0otMNBbjN9VVk=
X-QQ-mid: esmtpsz11t1780300832t04d11e47
X-QQ-Originating-IP: 3H4NN0ARhUWAe2T8BF5/hf0ZboV2Pv02TxsvReBukVw=
Received: from PEN1097 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 16:00:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12924311070648685928
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: niecheng1@uniontech.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org
Subject: Re: [PATCH v3 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon,  1 Jun 2026 16:00:28 +0800
Message-ID: <79F7B6B20207E976+20260601080028.217269-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <A374E0020B17741D+20260601074408.204630-1-niecheng1@uniontech.com>
References: <A374E0020B17741D+20260601074408.204630-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M6Wwv1ws7JqNANWwCaBdpNz2/EBKknL+pDZ753tLdW7HAv6qihpgYXmT
	9bwF42I5XLnqWjkPRqZlx/5E9Wky8kMLW2Xyo38LFSzrPwZy3Vl718axHnGpaT2aFrbXOjC
	UulwIKA1hs3Pfp+j0qqaFR+VKv+HpAaFnhJ5xOjwBx7myg9NHtrKRHIZRBw+AZ1vuTL04+N
	8ykAJwyLflb56iNSYED5r3NnsO1AIo0QlsnZHjVm6+bocuULUvvXhS1eeXCsDPJUdYzzg1J
	6m53nERB6Bj0zaqoipX20oLwJ7tyWEUCcxkvofQxm822HvhTpL7aYTXtjuBgC1hT/WlFmda
	xTl2xmE+irA2QBRmWeZv0463eBuTG1fx9hWNk2EOZXdre2E8779d82g7Yf2n4gpG8NB8TYM
	cgOIdYoqSx/qLkdyggICyvNE30ts2XreWq56VzIJbSmre1Y/hG6oHGYWyyEt62kpNPBs7ao
	8xm6hHkEGQZ1y0JmMiqEV8wXFnbtKRikG+yVP4oet9aHCPBrfJF3oU/3seuA/DLFh970Tlq
	X/lmTOKTVTH/GnpUKxKHK2hjDDaRFVk1Sb2Sk1qJ1luiadfo9MiwRREMka6jGvtJP/1vf7k
	E0A7HKi337iNmB9Q49+2j2suwcKq8+pfAEbKEt5tUWUH05i/0KqeOBKIWMlxTJ5dZ7C6umc
	Cqo9SosXOJrEPKpoP5Qz3aKXZXRwbHd9Z8CfciBsrUfvN5GfDp2SURueqR+38yX60+riPq0
	jYjFcZjj6F4xZH1ad2NEzPAzrKKDHmZsgL835SDN8XAq9UTyKbXbdD5WK/VWbOnxFtx61rp
	2l2qeiP2gP4C3QBHLr1mSdf+M2gVjSFtZKXNWp/mekFt0xJtYWYKq3p3sTsPHTexbzn1z2T
	VAP4vwG1hH+gaI/K9DNBiLiTN9UeAQq5yktqvyq+kxsOLeblkKMM6YoPj3bIH36ZntKrXKH
	6a2fm+bg2aOUCqakV/D7t+gyzf5UqRv25D0MPD9CQe7WyfPslliJh7qzeHOqJc78sJfmWg9
	6XzrloCMqjvpJ6KD/DcOR/M0spbGXB1KZm8btR6C+wBNSZBcURfRi4LH2/Y7feoCde6wEy/
	Vhj1Co2jbvLVe2/7otF34LnvX9EVwi4wu5DNTOg5MDG
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam12
X-Stat-Signature: u6gputtx4pw43jcow5qtea8nghykmu79
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ADDA10000F
X-HE-Tag: 1780300860-509504
X-HE-Meta: U2FsdGVkX19WbQJ3FLI1L8+hwIb6OLSjCpJ4YCq3GDmhji/2B/U6x/y9LuEYDszTf+WccBpvFfg1wPkc7mS9dX9ihsUQgNN1djCEWZ6+vS1nBpkD/je3pDrzqT6ztW+rSPV6VFhaMXPWwpaMwIuL0zMLBn2sfzW6G4a+T8anIhnksgStgKNqxJEAOGo+Aw+c6yuWvD49hKZzS90T8JcOaeUIau8jtPVv7ysBgMeUp1p6ymJFAZ1lWRquPfL97+ugc/WZLNsDvzIzWXKoWKJEdxiAmciOs5TTMnoGEaP60Os80Yf9Kxr81v9W7R7MCi6Uz8InbRZcUWvrAm620kCphEmpopmJdNwsQbXkkda5zeJ3KXbQ72cxeg+wn6aQVrLe86sfUQUtZxA/Qew9mfY8EUgmpo8/G8no30c1nH/LCdNH4CUH8mBm2a/fOvLqvKElrWrM7nzRhBg4nyEWsy2MiRX6g9gXEU8SycYrHMGyAVM2bvcQTfOZ/SNotZy/2j9RiJ19RHZfbWMm3uSjqqei4L43FpE62+PXsrfb/q3wi3SEQWf5pY7x3S6gcFzyMb2XCqCEAF2e3lf4yXK/NGDQjN/9boMfB7rQviczwoS/vMD+PTNwfyrsxpqjXlWqiZYxA7bk9QnaUi/aJjhyaRl4LYRiLHuGB73Z0GgTVI0Ci6e8EMVGezxXZag3xY40batckXem3op5pAkmStvg6dcnQXzUzb39SvhnRMDA1B67kpE6fFYOBwwBqtqUCgTQRyj+SVbJTTTiyXy56ASqZTwqFh0QrdQUivE7pRuca8kgNdCnPIddTCqhqiHaTXO6Htw3SMqFAJaSZkV0LC8nLo5W+44XvvjGhPzOzMwI9EUR2vd+rhDxYXW0sDzoOghRX6fkW2uQBdQDKo5ne3BIp0FSVQh+0wzpQSZqpc+Tn647sJHWt9bjHBHQSImw7lI5k0+tDGJmXpKPzRuktoP3yOV
 LJZhTdYN
 f/wlpKW9Wy+ULnxgh4p8dMBQc2q7QvjHGV0VsEw0E4w+jZWv4HM7eug/JPPQjMcNs+WsdLcUYoit09Nq4UAGRGshcbIwsbF0mV5MYM2sLjt+ssQQorXJQjnsCMVPT2XaDOf1KLEk0s74ooC12SufaEFG13K8BEQ5/6By2D8f1xG51K7cVDu2bhi0X+6PNIbFEawHTvy4CAF7Q33pOv5CscIFb3G3btCZEyrtNQHdmkzqHRo1Y/UDo8lv28WjzX1D8RIsmDj12VoWom4vQKTWSlw0w7iw4T2d5kjtemfsUaIYfmkgz3Fal/mPcg5hWF5Z7Blmtu+1Gupjfn9d18KWlvnopYm2VSL2JTRxg5zCpcZje/3aK/MHKPx+rh2oGR2hzKKNbfK+u1b4pYUQRfUUN//kpGR3zpv6VbKOZ9uvI1TAt3y/BANx+HU9dqggKkzSm1Aiqe2JYKUhZopmSatlvPQMfbZJpCr6KWIgd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Sorry for the noise.  This patch email was sent by mistake with incorrect
send-email settings (wrong To and In-Reply-To).  Please ignore this message
and any other duplicate v3 patch emails outside the cover thread below.

The correct v3 series is here:

  https://lore.kernel.org/damon/D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com/T/

Please use the latest [PATCH v3 1/2] and [PATCH v3 2/2] in that thread.

Sorry for the confusion.

Thanks,
Cheng Nie

