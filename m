Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B89CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3626B00A2; Sat, 13 Jun 2026 01:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A706B00A3; Sat, 13 Jun 2026 01:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7AA6B00A4; Sat, 13 Jun 2026 01:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAD76B00A2
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:21:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D6BEA02F1
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:21:42 +0000 (UTC)
X-FDA: 84873742044.01.82612F7
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A69EC0006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:21:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=KF9BbB51;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf28.hostedemail.com: domain of chenyichong@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781328100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4QVOxbNyVER4Y8xAB1a0ABr+3fy6sUUGD91r/VPWq8=;
	b=z4dqLAfL0/hawB9MijqMMVY/LIEx9wyLC9epqjdiaspKZwHzAbQlMqyQuQ8HRyspMRKnls
	BAslftbnUNcpDI2g5k7huopZkmWFnUFXd57uJ19SeABUTA8C0sfiVp6KjMLfsjLP3wy+wm
	BYL70ijBeO+U8m3no9WDIVKXUr/FAeo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=KF9BbB51;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf28.hostedemail.com: domain of chenyichong@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781328100;
	b=aM3Qbpl9Dt5p8/h49emNI+aU6iDpWgHjGJ0Rjy7YlKvmlGssgGA2mTJn4tDojVsqCm7Ok4
	6HqMOknc8dqYnswcrrhK7huOsE0Ya3r4nzPyj1pOKi02mfwnypQs1lQ9i7MNOcXVyvcamj
	osND8iSpbLc/jcW8JuGBrgx+uY7OAFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781328071;
	bh=x4QVOxbNyVER4Y8xAB1a0ABr+3fy6sUUGD91r/VPWq8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=KF9BbB51Tq44YbmH9ToBpfc+afbFs4QZWv93qyiZhcfqGAeFAUhbIwBFT5iyJeYim
	 7zC/kriz5uWVX3jvsU4dAr/4DIKOz4kEyu6gaLW/fOWnDbS0eK+1D8rPrY1Iz/grQN
	 zxwE7Ci8uc9kC4Ubsp8aF2kASirnlDGtqciHQ8Rw=
X-QQ-mid: zesmtpsz2t1781328055tb504b0a1
X-QQ-Originating-IP: lNTXQBkqkQa6mWiToZ7BbiFgO8B9cp8f1toHpQ1ngV8=
Received: from Shurima ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 13 Jun 2026 13:20:53 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6196117950154666207
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	chenyichong@uniontech.com,
	clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	penberg@cs.helsinki.fi
Subject: Re: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
Date: Sat, 13 Jun 2026 13:20:52 +0800
Message-ID: <DE8C9DC863EFD0B6+20260613052052.859238-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260613002913.1509-1-sj@kernel.org>
References: <20260613002913.1509-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MNbA5mkmBXEJ8NP/ttQVlXK8mER20gFRRCy5TWLWxXDG4IZiV7cYsGFO
	+1EtIsSB07rJxjHlyleHssvT+rCNKcPokWksSf/dj8d71f/G9XyAoaVBe3wksTPjk170oij
	KKU07JCFFi4TxbRogUvde4edklAiB2uyk7eN6qZIX7QlT/wAwcF3Dk+PSEWey5AjZ2Yx2uE
	h8/rSX2McCAvj1P9ztOvyPHcf72OOIE1Nl2n2aJG4Ji81uhDmOsnm0sKO4j09yoYv9jhSok
	sxf4dYE/Nv4ihFovJNBUWqWcRbgn7MM8+e0svOCilio7vZM1phDZoLHqMEw7o6JVwVDdtsy
	IEr2DAG02bemQa1URePXYYoYC+j0pYB86N81fqSmnKo+DH2xDtVw5+CiipAiEYuPxJcVna7
	jZjxqBotWaXtGs86IXaTSaFFJtiHrq4/181ZAGplEF82rYZNhCapzO4r4AoGN8QF+o8QqvO
	MmZcI+1mOwgJdjqYR80saJPclrquD02LQoO3CjP6AINwJNsNkIa3/hFJXMIShX6s8uFFWJq
	M316MEX1nXHVk5YDa5BMX2Ah8Rum6cB8T1RI/XHzW8ZMEQvHj6WE7clpAQKF1YWUlR4vuTG
	0/qrCR7UagG4w3Egnbji7jy+aXXiqDvPg1DxShQjvK2Xw1Sfj0+NCTEsU2Guy/P5kc/rOEO
	DcSztpBraX2HAwpmZxmv6Ljh7PPJZEKL27pQg2HDYVqwJqj9poPj1OnGh5pp2LWP+OgK6ai
	MA94wzS47a08TPIzsQUxJnwoEdY29KiVU9WhkXuwsNo5e/prvIh30ULEyrqgWi/1JXolwQf
	SYizVl2KIfFUAI1NsivJOMRgKp+5Oa/gSeIIH+YPRT+fO+pxP/yJQlNAbeQYkj5YzOrkN3Y
	ELTEy8MQ+r3oeXRvlXCzpBc26ZhWSKumL+AiTkhq+/9Hu3N9oxKiTC/HtmJAPQgy+VH/dBv
	OsXcWCXqatjdj3Ao6c3DMsmTu+bo4+1pdht5cPS/CYZAyAcSyp64kytnB9aGd6mktyVD73q
	XecGm+3Q==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3z44beokpmu5o6qi6err9betsojp6zxu
X-Rspamd-Queue-Id: 3A69EC0006
X-HE-Tag: 1781328097-294913
X-HE-Meta: U2FsdGVkX1/dYru1lLZjyPlO95CRxb9VGTyd/5I/6zPVbsa0XzKLnt9/l7HnMmuguyxUie5emfTS84sDt8DfFDZ0kCxnSyplf1C8eF/6e+sAHEeJN03pqb11HV5v34r2LLe76l4nsCNdYsWug8qlFsdeV8HWqR9urGFSBlHlbebpZyL7mY0k0vI5fORiXak/1OCFfmrCzYHvSRxfcr3BRwLZmqJ8WDg6Eg/faL8/Ize7Vc+69LUTZnLBgzO1lxAFByuLACg1zhZIBbxcQu0u4xTLQDMeF/UH0sPQP3fcmPn9Uk99/NcrS7YeaWwyiJKJyN0tAXjUqHJjsBOXJDmuRIbD2ZpDn/micrIFBEHE2FgKD1J+feoilv+bqN4gfc9Dghf4UwwmbsH/urD+9bp5BbCBGSBP/3Z+qiMuoL46v899SwgRUm0BiMvg+9wPyZLBD/2XVLkztc1KRkVTQqzljKG2VJrcZ4eefWCSTlE4CcbWoZU8DZxoPWkA2aTPC6IwPlV6xA7Hbse6zu28IdymP+mGlWaBaDK1DBBz06nr513wa78+MakseY60owcpNh2jwkzEgkRPRDVCLWGHKPEnqY0LLLGldFoya/Og/xTkpNxm3YZwnebqwskNF4gzxc/MZ3gDyb6REcxjgGimJW4Y3xbF1qzWJ2uR0hGxbZO43pV+L0/k4vjLaJaPZlxjbUpHfqkhmW+d4tr9JXNHHLfpDyDb75FJo88CjF4vZB/sYGZ83fjfmgrdSKJzAhK3x4RGQkYHVdM0ME5VcgtZmsMe9s7oUTYCAlHmQmB5hCdBbCDUlfrR7l+ykdzYigg3gKzJDpjnQxWTWEP39/b000T93FNuJebJOrhZopzsuWdXCy83oXu4t4WCDKB1/Um8kZqmfNjxr0vhe/JH+MMJiZO0E38un+mWWi2oETYEfAWPXcFouCrf7Lzs69OYWd8vXueA/Koold2zYEkVIz0Gqu0
 1g6IDnJ3
 ZhRItPutVuBwi0N8R1M0yAoj2p9ZQsHkZUabl7sNJy2bsvY7hSJ9JvckfpsD5/EgqT7AmBgV7qo87dlL/l8nowlRuv5J43xvZ7toVlzfybMltOGYNPHmA/zngT9SA8katwbBlkNm7TMl+bK2Q7r+nwLhfoUifRolde9GC+bKTBMGuljMGRT6b70cmeCtmPrtOCOLvEl7hOEYwf3vUcBEwQrX10H1ml9rrfagfrMrzkqzF4LEvGZS9BcGAX0O2hbnjAto+BIUHGAFcnXpbVlmu4tK+8SatNToHcF7OoofHoUCcnkn50ax/ruuOkg8lL9P62YY1ltB/fD4mTOD7DDpIDvPNxN1XK3d15Pe+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yes, please add Cc: stable@vger.kernel.org.

Thanks for the review.

