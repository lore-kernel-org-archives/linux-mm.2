Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A28C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BBB6B00A4; Tue, 30 Jun 2026 01:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803836B00A5; Tue, 30 Jun 2026 01:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741616B00A7; Tue, 30 Jun 2026 01:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 451256B00A4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:50:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A238E140389
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:50:52 +0000 (UTC)
X-FDA: 84935505144.22.DB28177
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB147140005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:50:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=YxAffdo9;
	spf=pass (imf09.hostedemail.com: domain of chenyichong@uniontech.com designates 18.169.211.239 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782798650;
	b=qgrWA95bq7bzYv+dflsesfHKlWXs4z7iZK1z8drxS1cOwG1oVS+nKVh+ZyxJ7PUp5Z0mx0
	SIKNFtMpTX4mDNCmopw2DkNz94nUCOIGn956nxk3TBaFSdJpiZGe6Awt1xqc4dEC1qdPSK
	XRqXrKKariyjIvhQ+cRbG0w7EuquXHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782798650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODY2Fvpkl7y6MFGWZod27aU9b6TrurBqcJbCy4rwMAU=;
	b=bYJJ3huAtnVD0acT7VKq6jk7mBXQl9BHGeY49I+ceT5mThcT72Hfokiyf5SPuaSNgCcMW1
	7k3eW1HNihlxKN5dKa8/CAdoKBeW9AZM9niyFOyMfIE0ftss6j4ee2MaeNC0MYgWwnAbKS
	E6qap3A13XfAxLYct4l1mc+v+wxCZ80=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=YxAffdo9;
	spf=pass (imf09.hostedemail.com: domain of chenyichong@uniontech.com designates 18.169.211.239 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782798630;
	bh=ODY2Fvpkl7y6MFGWZod27aU9b6TrurBqcJbCy4rwMAU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=YxAffdo9q5SCwdNENfsV5CaVI7GhOYNReNevdMujBY4175oTwOCTU41A40S16PHF7
	 sJThs+ZY+7jmec+ZHupt7UaJEc3hrHtY5b0vUNp+9gQdzMIbjDCXHr76GyA3ksw2eO
	 m9kTbWEStD1BAg8DP68drlxJWX/6FcaSSoB4ejyA=
X-QQ-mid: zesmtpsz3t1782798625td08ece1c
X-QQ-Originating-IP: //MyUL6qnOjE0dEz/rw0pFjPXSMsJQ/YJu1N7s1UejM=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 30 Jun 2026 13:50:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2814519228433504085
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	ziy@nvidia.com,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/page_owner_sort: report get_comm failures at source
Date: Tue, 30 Jun 2026 13:50:23 +0800
Message-Id: <20260630055023.197943-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260629203326.fbd5714e7ec8cbf0a22e7148@linux-foundation.org>
References: <20260629203326.fbd5714e7ec8cbf0a22e7148@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NitOQvt5+uyuSU5rvDCGqRmHg9ZIJhifvP6Tr4JkVcA1nPiBVZPPRtmn
	kLkeZQ207FCdFM+IKZx/Hx8WAAib7F6ine6avRoTC/wLLEmf+i+RRTmpjEvjV6FEsn1Oig9
	fDA4n54UsfNKuT0JKebZiQ1KOwwub3V9KX3B470K+9c19sRr8LhjlZyzi0IVGZRN039F6UE
	9W9npjJYfNX4dOwOarHF4HpkciYtI+UxuQ81ZCmZZIR6erh3gjHhcDAqtMLwmMr1rk7gw+W
	WKVc9qEmXl94QWgUK7Z4b3F2PQg51wewsJVCVmmPcT41dN1Gh1GiEIUrRzqrW2JIRGBOZDe
	R29uvqHyANX3Yfy7OaTNWwYb/KfG0kXfhIyhDd/yfyHz+wJgbITUfvWVomYbI1Dq7L97iuc
	0wHlG7xIR9ob/mx+wxoBalt7XNORnODBe+WYLXuiaUk5h3acrj21woEqqIW8aM0KbdcN7AV
	lRHEDlMGdJ7x+lDO4bbmmHi7cfh9W4yfzxzu4+IN59DGHooI+hzXRp4SqWYDO/OBTSMd/2M
	d4CgNmxhfvoNb12HuVF0L14JNAlAeQ/nZCo6PRfnweLpz6TMQ7WZhgKPTdk5pK4Hq7MIxHp
	hba42iWZHsgrEebBLyP2OBwV+0CvUV34JVj7IrOSASW2Xnskx+dp3aay2dX0uhsmm449wRW
	/CELHXygPo7wJe2QjF41GBc5syULtVC/QZijJqhYz4SIc2ZnWZXXqCGqVjiRxFrqFcLZ+u6
	rYGaDGj3KdlAa78Rd9pDOMjzZdKFu3VTLuoavdTHyLv/IgqsbBRs+2fXz7q1cfDc34dI6FR
	O7FPfcZTr4mTjUZ+aUt5+9zORPfdY+RbsFcfygg3zt7yxc7wvkUt1Mv/q6PN+rcKRtQ0JEG
	P3tZHklx2yL5Nk30IpJjcR7iX2lzjr+tPhajS4JPnZsDmiP0Iae1NZIthapS7AxXjPP/9Fr
	3MjeRuY2dn6luScVIjWjLelLnAavtuAsGKa5FDDvgvJKVWjzaRARyoFcG0aXFM5bb0cFAK7
	hNKH80IM2fmkrx/6YAWKcDA51skILDYIxUQFrEeb2xkV3kvzMc
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: pw5gh13ad145zfa18xd5f8o7px373qre
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB147140005
X-HE-Tag: 1782798647-118222
X-HE-Meta: U2FsdGVkX18LC5r0DRv5RcLb2Xzgr69dr5tMiexp3Jrz3hy966WF3b7kFogoQ7NcAtWMCMHhZj88WhwOb1OWHAh0385/DzHSNGSOaqb6ujE/3TIvINclmmQQSs3IA5nF5/jOWry4F35OGdiRZfuV2C5+FwjVVeizRcpECojjFoTjnHKtatHypCltH4A929wAXWxUUDsEnbyBVaNWlsf6aAHONXsvh2OWOPqWD80tqsHb0x8eZ06k/Oh1DAXTINtE7MgTkP4+OeWXpgSmL54Ry3wextnrtn+U1h1E+ufrxi45ND0QyjHKtWkOn/ruSL7gxVnOWuGtkH2LDipUx5c4hMUg/mkWz7nR/Fq3Znym0F7evaQc7UqD94iUdOVSjfHzmGvjpgrLrOnsm5+JsO22eUY4o5TdYYJJm+IAXPx0bds1vKAAOJ+SZ27jL063qTrNxgZr+wc2gITEpWGAstMbPJ/xH8OYTP6p5XJHwBx83bdkGvAkKBjmgcxbMor+QQWbZl/dL8SIhbGF16szBF4r3NK6rrYZ12+Ue7oK5vGiYAITQNXP10r4SwfD3QAdOtlHMAzp6tS1XSbgWBsHtwkecDrwEolGtneYbYVCV32DRyGyZv3YbHfLae1gvs1SwLU2EDBXsSf5uP2uDXhxduR99GM/nAhLr1oeEpkcX4c8vx3MbVpHOOua6LVy6b3Kh+fFlBZtB225F/xjMDLWmv/wVe8PBjS5ldCYxLQ2YiGeOUbFMX6MselmmCVufCN8Ob7x5VkLDVz11ZLdGmueOvEpYmL1P3f/AQviLida9Y5iUFruM7xSLTGoP+tcKAB0hHb/LoNLemi63ph10u/NijH4+AgjkSLGuK5Bpxj6Xfx3oak0N8oPbdjeS+k6u5gCXHwOi7gu1XPK2D7OiPp1jvmf8fksbq1z79FlbiCdhxsx35r86Hdu7++prhHZ/783M/DCbVwW4Oi1TAxHLTlaMLz
 BhGl7AQ0
 3eFpRYqldz+RXRX0Ngsa4XHvk9zHSjnJW1RAVrovxOTyu/+QLef6eRHS48A+8OCrLCMGluOvZdyBnxql3Aa64R26eZsr6E/dOCg6MsJwM4wuqDy2ViggTr8wp/GrJKSnZUoudqMrccnCkSM1ffBlkXmOlygjDUP7+fKt3UDwuL8557HYNhwAOO/IcsFjXcdQzngfuR4ao7sYeIEIYp7nNRbeZxxq+NsJn5iXhjXK3Zbvc3M4BPqhdu1qFeezDDULIxJGOEZ/WJQXjb34zsh6ZJi35L3pvF7IsT0g2Pl1FiCh0rrQwK6/rNQUtthjqQnIjiCo5J9ll1vwMa5qF60nFH/RTWjO7d0B2qE0wfbsBRrbzhmwITF8ejHyRi5yzKVZrpz1GVut3lWMvgFMU0GS177rwNlnbO+PkMTL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Thanks for pointing this out.

I think keeping the parse-failure message under debug_on is acceptable here.
The failure still propagates through the existing NULL return path, and the
malformed-record dump is diagnostic output which matches the current debug
behavior.

If you prefer reporting this in normal mode as well, I think the minimal
change would be to drop the if (debug_on) guard before the existing error
message. Otherwise, I would prefer to keep the patch as-is.

Thanks,
Yichong

