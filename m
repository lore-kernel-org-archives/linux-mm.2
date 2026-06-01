Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E0DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199316B028B; Mon,  1 Jun 2026 02:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170276B028D; Mon,  1 Jun 2026 02:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0868A6B028E; Mon,  1 Jun 2026 02:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBA8F6B028B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:35:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85E57120515
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:35:17 +0000 (UTC)
X-FDA: 84830381874.24.4BD6620
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C9D7A0005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:35:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=GNHNvhoM;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf15.hostedemail.com: domain of hushijia1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=hushijia1@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780295715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa6uM69zAhT8Ksi94xXsM/bpX6DRtWUW4iiySLcqwrQ=;
	b=vVIoynQo6sp+ofrErx36k/6I2X//xTMu1rAXD7/ACvT1wnXMSh7HMKcTk2msoS6nS2lf8I
	zNqA4b7Wgs8g0L7nZMSy1QDEa5jYryJyl3Nvb2pR9KAgz2qGXIwp4j0/ZZfz6mKLA0JLPi
	4J6bWVCg+v8J0fJdgENyqR9WBOwaLqs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=GNHNvhoM;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf15.hostedemail.com: domain of hushijia1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=hushijia1@uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780295715; a=rsa-sha256;
	cv=none;
	b=oZZJs4ZxdRE+N78j2On28z3Y3tSXC3eO+UyaDSlOBUd1ELoUsEcYvnGIAQnVNFJqZZSlJr
	cEekj08jiZTi1OMEiT2Gu4w9rpO1/GqZ40vu2Xak2TAqRF0VxTn4SzEferGGWzFTd51hig
	5vbOR6t4bF3NkHHjfpQSEGpvinc5nHY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780295665;
	bh=Pa6uM69zAhT8Ksi94xXsM/bpX6DRtWUW4iiySLcqwrQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=GNHNvhoMTwyT6OXOphS6g5SVtD3gE4A2AjYgRgvNdZpMaGU9VpnRaNmeu6XMf/nPo
	 L226yPLytceKgTwSEBc6rwFqQLVeZQJto3d41MOhm7df0WKu6ZBcDV4Y//pTqzqzoP
	 y2ZiLhGEm84USQgu8eGz514bavmpRn5gkj5era8k=
X-QQ-mid: esmtpsz17t1780295650tb6ae4d84
X-QQ-Originating-IP: /Er2uKdRF2ClQCcCIflW8DJzaoIWDrcea6D7ndD6tHM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 14:33:49 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5380624521232554661
EX-QQ-RecipientCnt: 17
From: Shijia Hu <hushijia1@uniontech.com>
To: alexei.starovoitov@gmail.com
Cc: 2022090917019@std.uestc.edu.cn,
	M202472210@hust.edu.cn,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	dddddd@hust.edu.cn,
	hushijia1@uniontech.com,
	kees@kernel.org,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	paul@paul-moore.com
Subject: Re: [PATCH] fork: Ensure copy_process() returns a valid error pointer on failure
Date: Mon,  1 Jun 2026 14:33:49 +0800
Message-Id: <20260601063349.2524658-1-hushijia1@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAADnVQ+=-UM-JC4eM=vqvgK2tLt6PwmDjOcrrDG9kz8BV6n49Q@mail.gmail.com>
References: <CAADnVQ+=-UM-JC4eM=vqvgK2tLt6PwmDjOcrrDG9kz8BV6n49Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-1
X-QQ-XMAILINFO: MFE5XDBetPujKvZRqxZlA6dg3H3txvekj7Fubp2pqoncPSfvH6pjRTZ5
	TQTIvwh/kWrbcpeLPVD0mLzICL5QmjWTf81YaL90qCuuDtInJr3ripBwNApkFTqzyCkGsNd
	H+AwbibK4QVPUZ1539ob+xVHPW3EjaBGeYm7QlFhYlO3/MdS0SQvihsQ7V0EvaQLiCkmpWZ
	p8vEzJeY2N46tmyjl0zZLEPfQBayn69+pRBx/RARbNjS+E7r0/m3zFu8StHNzh2jEbaH4DW
	3gsH86I+kRV0i+rEqoGmEg38a+jT68RdSuowe+VRhh6on/iwGT6iw+obsYEq7Qqvv40+elP
	wJI9mdKi8Ps5Q9XrFmh4zeBL2HVkdOSMZEDX9cydMUDzu/fYsO9CF4Uwp/taozptmUHK93V
	4XyRGQyuRU7xMcFHEV5Gx06oMQBuvlukWvNVEYGRqUsYhgP1A/86Ta3IEqdBDlxVjCfaWUQ
	uUfwE7/ROFe0mLdyTL3mNicHZZ0RDxKr5oa+NOevuzxEP7W29GqqdKdSBpIxNDGtL9+fPeI
	22ReihnPOIhHHgovE1CfGaKP4rS6zFP1urT1Hg77DpcgTh1Gtxbkz3GdUUv3SXtL5qORhYS
	vcDgL9405qi0XGzVhw5veaH3OfvbW7aa/Kd8vFyPwQAWQ512+bWJQO0WISFTNv42+WfH3Nx
	RhiZN5fM8eY7NJllnWeX+eMa2cCW4eIWVDggJorfcN/yGSSvsp8NbQ5819A8+W3Lfaj+i2I
	WphJeVW4lmsJS/n/zSbfxvB7K8nNJ0A+Nj6ysEnuuPAmsYCSDS15fzB0r38OYNvz24GVMUk
	40j7dDzSSzMEUdqBc1Ir+m0p1TF5dF96VaDG8NA6hzDrGTHmU1jXxZraA7e1ro0YLXuENwu
	E5OTLmS+cq27GTlDKZlG/4BtcU7w7uspNCpKu51c0c74qyM2hz1jX2iBjCOzuvPZ8l4uyjg
	2CO7d/vGeP16ResLlyTej4JFfZBTBQrogBOqr7YNGZeLColBsw0dlXz/4oJz4N7/1ewqQD9
	CV5dnz7sEkds5K/x+HcIOEJI4BrmwHd1aJy3RvJz8Z0YYwfoD9EOMSK4Rws53ML4CGBX4vt
	ZcTS8wFriwtVKRDiumH/EcCedlVTb+Jkw==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C9D7A0005
X-Stat-Signature: a11ez4zoj1bogpc9n5afbkbpm656bng7
X-Rspam-User: 
X-HE-Tag: 1780295713-427879
X-HE-Meta: U2FsdGVkX19qS2uHHxKsytEOS1t8FgHeGqb4eiOAR/YvkvLK4l982JnWYDYYo0q9CTWkSwrsgkSC9Trb3Gbyv7FC8rasCsS1pBPfsWKbCRN2gO7a8D35BuFfcA04FhkaHAG4N0ciiGczuqAptLBjvufWCaYDrBSPvmPfurSUCpo01bfAg/J+rnBzzcWBIiTC3q/wxcjCmU6xpzAeHf0TmtFi6GwYHC/FI2/tftaheRNw5cRp0nZoTtu8qj70/CgFnZHpOjnlYlrDvzIeCIDSTv+bBEd6uesnrGVMFdIyWAAIHGTPhMyIAgET64TqURAhsMXnR9BI9QxCIyVI98qZ8jXIhJhgDMEZaw8nW+WaBA1IylPLIZntsEokpliD2aY+MaIltr1YZIrQvurjq4/L53PuQ8vNQwgBfnf8Pt137NJxLZioJVgwZVProeCQFp7JyfEU31icYpxYZvqSsyK8SnFFO0JZoCMQC99seiwwD8iuMOcwWdgx26m7xRpyecnY9GUjLwmoMRmygM7ZXZJF3uI6/kgzP7qXJWnw7/PtoMyTCMngM4BEJRwORqQl7o3UVbnoGJlChYf5Mc6XjAPZyqMg3go9PyBYGstEnTaBto+tWeQmK8ERm0R47GK69X9C6WtZQHtD9ydXFWAP+2Wd4zTksBdrz1+D2OZdyIJ16rXygKv1ve+0ipK72zUvcZwcBd+9oGrCrzh39ciqKqt6ShqfGR5JUGlt/yKLMA/pfLYYDBqb0py/D0LZz+8eg6qImAV9AIg9SRSXTKMkAygVEjnL5Dsf+Un3DTSzMiCz/3FRcvcWIfVMLOUI+bi/2a8c5L/H0J7dJH95nGEVl0lOuPw/SXhgv2daJ5ff0JTFmum6Htqq+uWGn/P1FuLvlfiYMNOx/4PMJaCn7SVpO9mB0q8DIFqvD9cG09sTb2HfKkp2JxqRttqd+oq8ktGfAQw+W6MjzhOXUNLlsgVFjaf
 AVFxuHCr
 k6W3HneoHLVzkNiIkJMTHL1FtgZiInpdxI+9Up0k3pxXImd27MREVx0wR0i2qv/TZPcnnQjcFAivrR7JFMNyuePRmkA3AJK4sG83OqeqC3g9NJRvOyitGzT25+n5lAy1AAUgM9GGiAkxYxMH9s/6DJb8RV8LK7AHnvoo49xibB/N/zKh6qiuKW7x/UilGgMot1O9KC0yayZaFsnf/9RC3qpzHDkWO2e0zZ2K2ZG1j9lU7YNHhbrv9H5y/Y9B//FIY47JbHqy5/WwVhDM3X63vg2BFXUC7ZcAYseDk2MAZxKMAz6jJmjQqMvEL5xncuXDMB3FW7DaRHbvcHLqXYhOtizqxf7WAjEXNMmAmNp5lUO4stwdHFVKk7jOf5qMJZAJrbp+bj/AdltCUfPmOMpMK7+WTdOgldidY5UzLyYfK4w+8XW3nW10tkaShOy6nfknX2psQDJickGdUtAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 20:58:49 -0700, Alexei Starovoitov wrote:
> This was reported earlier and there is a fix in the works.
> This approach is incorrect.
> You have to fix the root cause, not the symptom.
>
> pw-bot: cr

Thanks for taking a look.

I'll drop this copy_process() approach for upstream.
 
Is the follow-up fix still being tracked in this thread?

  https://lore.kernel.org/all/20260411163556.8567-1-yangfeng59949@163.com/

If so, I can follow the progress there and help test the fix with the
security_* fmod_ret reproducer once it is available.

Thanks,
Shijia

