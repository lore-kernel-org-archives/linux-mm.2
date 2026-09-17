Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AC6C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676D36B008A; Thu, 17 Sep 2026 02:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626A86B008C; Thu, 17 Sep 2026 02:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515966B0092; Thu, 17 Sep 2026 02:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32A3A6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:56:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84DEB1A026B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:11 +0000 (UTC)
X-FDA: 85222344942.29.DF25C8C
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31BFE180005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QlkL6Xoi;
	spf=pass (imf24.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Gw4qlBm6AwOO9f3v1AjzWTUa+PP0TWvSh7qf0BcJ+o=;
	b=z6oOP1vhV4+ROvrCtns4IavRdIosqtWHtSE7w87MXDfLTYVLgmuIOSxsqnvNKaTVcj+0aM
	aJe+wFcEGMayqqPsP/JDB5u8Kokpb4MjYFHqzV2ipqin/StxMD++anXfD5iywHUF22RwdA
	m0gYyQyECILcirDjOqrAzK8iEiJdj1g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QlkL6Xoi;
	spf=pass (imf24.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628169;
	b=gtOgZV1fzq+TNVUL2TPg0lygPTEJsC4i0dTuiaJ8BOnEf+7XHYCO6o6zTpQ6PQoXkunY0S
	z+FDHZRYMfPg+kGkV0vK81dP+8V0VZG5nFY2MQfjdr8eSncFhdnrpKdbuDzWI76Q1i4obJ
	bjg8Jt5trV738U4/CEzry4gY/CKgt90=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789628163; bh=/Gw4qlBm6AwOO9f3v1AjzWTUa+PP0TWvSh7qf0BcJ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlkL6XoiajoxE1YRt1P4cYPyUq15YiRaPMQlniQCnR7q2KpQabOe0aMHylFY6wW9a
	 hQmG+mnjn/DvxAMKFK63VgzPhOqwylLIXdU7X5HLxyHr5jTBJt8ZBt+uoRNrIrCHOa
	 SbHkwQECoJYZ22RxX4aRTUC67R8r/x0C72rcswlc=
Received: from XJSH01426.meizu.com ([210.13.72.171])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id E0103260; Thu, 17 Sep 2026 14:56:01 +0800
X-QQ-mid: xmsmtpt1789628161t6wm6c29w
Message-ID: <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5IDDSwlR44w363NKaPSXoFFztIYYIE9nq8IFqj6QiMqzVbvj+lM
	 lgaAUcXvi9S+FhsvJ3SfXcHAO7kPtrIdhsDch7GFjJar4SsVIPfKEbrgD2CAIQlfIh23Ck5R9GI3
	 fM4CFGa2shtVXEaG2byNsT+v0mu34w2bo2+oamvoK5n2e4yEV7683dy+btJY3nAPVckx5yJrc19g
	 xdhQ3Ze5UvVM8np4HtDfq4xUrnOCcRuVBVB+p284afZ5qeJ9RsqgBV4nuKW4sqekwYxzkIMVRVSM
	 ZVbLAtFZIpoIRY3lxWMb1bznnZQMR2L+9ioyoWkxLADyLIGmCiEP9PzF5wm0CEBYZtPZQ1BfzTy8
	 SnRWxaOODZQbgzt9uD4MvffoL1TXsxgtdiXdjLnquAv1tLT8o0728OyNbLE5M+Vj5mEIdaWnnp12
	 /UWxJiA8g05eghyytDrEKZmd44HgMj7JfK6gxHrKzxNry9vRtwFydBAl/9WeM+9qYDHj0F0t6Dyq
	 6pDCrb40cqzhLT+ewOvzpybp/sKgaHcrYr8ccQKlI/6C8seEPZsX0RXExNpd2syaKlmgz/0weWd4
	 aGyhUVc7+hJb3VYDlqrGaAI9a5yzFbk9WT8jVfb6EfX8EqLlDIkG1XeFd9tvxd18Y/EXg6FhHRbY
	 vDCOC80grqgDrClXJxQMJZw9D7IMbRpVIVv8wsLTeYMfFkTVYlvwTTTnEAeGzEirYbQ4WZklpXpv
	 YjGg0EPulTx/HLSag1//v4wgk7iyLuw9p+FmWGZ8yVU6V69jcVN1upCvNPiPW1NDHXFMXiszGo5t
	 W1GXurAXC5v4Lwzmi4Pkf7sdjgx8s4cU8bg8eGAsIjFP32iH4QMScnu9Ll1pBd+5acajSnJHypmv
	 Ib2qopG/K/TxGjfG1M4m7hc39Za+lmZDCOpxjJQt6TsbLmzJaeK8fTDplPAcw0CAB5d9us6lZ8uY
	 2BHjSfjwzDlBXdStd4CqVZROo4EjvJMLjbfdXlBjXl6uxa6F1MieMejqwcnI/q6TOGEGh9XGApyo
	 un33hB+mvWLnBRRiRlGi+aIgQbYF0dj2MUlSL1OLKq2FxMLkDPcXEBqqaZKk3Y6797lyX0IYGhAP
	 QTVD+MnTbJLvl6jK7y4W431VEWww==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] init, hugetlb: fix early parameter ordering
Date: Thu, 17 Sep 2026 14:55:55 +0800
X-OQ-MSGID: <20260917065600.564083-1-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917062837.558251-1-zhenghui.hao@qq.com>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31BFE180005
X-Stat-Signature: fud64k7kf7sgzz1p51g5tmq8e1p6akf1
X-Rspam-User: 
X-HE-Tag: 1789628167-186483
X-HE-Meta: U2FsdGVkX1/VWVJHYU782rHQCmxGClJywjM5cqTM2Yz62YdaUwarZWehfB2u+dgTc7+TdO10DbNChceijl24stdH1Zcyyzu0jawph7UKCXdmiTpsiar7Yvqmv740PcrSh3z1Vd5+DcsFTbQECgq/EGuM93a8DxWIDGYzUe+qaPD8Ja1FxnMDJAQkKUSSy/K61uqpY5j3qg3X7SzLTotaxmW0bnOIwjjake0hBG1tOFzmagAYJleakgjrFhWTI/8fSeZ7X+bvQiAVx7X32VuHT97XzFnQxbzG+bm8wOj3GUOLp/nj7esNaLE/JNut7GlDix1hlTlNriqpQvXFVcQttdQmPsHbAsevGDuPxRrGT/aNTJiIEEDt6JnFKFW9uqah5MGOlDS0lXrtMoCGwUhvUVJ7w+8/DPutYazNniBgL7pAddM65/iVlyu7xxF8xdgquooPugHukpP+sP58lXOw0B5NCdsLIegBzT1NtkjGeOG+kZ11FjKr65oB/w7C96AEa+k2mTRNB+QYekQiFrABVDWB0wwY9T2NpsihNEzuxgz6n7ZsJtGMwqM91qsjKrh4SLlTX9ZCV2rohS8PTha7tH+eZftiJy56d5xSUnVWJghKO5FJfFJEjKpwQzaH9SidNZGMBZxCuHuyvNmbhCDba8/n1xqHkb+XzBLFJgMxxBXjMGiPYD0FSOAthCrfQJqxCcCYQq7TTczjL1cUmjJ0EY8eeQ0tGdTWxFGJVeQ8jVSAYgO/xeNP3j8KejcUYM7W4S/j548l1iJ9Rj6BZLx03/9SV2AwbSegOSIMSi+sbCk/pHP+Y5XHfUD90FCH+tl18MxQU1cLh71j0aT5NuJGNeA4IF4y5SvpTbAboF1MujHCLFtPGX5hpEf1PSE7yx2IBm1mSpDC9Kl8iwesYvD0OqQJR4LZmeWDP6L/BzTW+/NqOhaFwHbm2jlFdkLfbU4RnKfLj1rkpbEpqu/Th40
 jZtcLIOW
 i9PJsgP79YsILjteZl/8jlS3mFLk+uRFBFmrQMpBMbEwDU7zpodxnlv4o9gAhXUbGdmlCtKty+M7V+zbrxVEbgLwYqvEYCKHBj/Kmlc/gsnYfut4GFgNf7+kctolKGUUoenypOAaOrw2wsvfwo/IXomxeaoho3TlE34tyISKT+K+e4mfvZ50Cu1Cujb6wvtQuIxgI9rPWV//ax5GI+M+kZyXoiK0aFlScZJlNG9XiBllih0iPYSwQHdUkuagWy9z9ZpxJivB/u/+NUENtEsXENwkNnMCLchAh1MHmsMNaeRPZENg+DsQkXCFSpVJxbpBM/qod1igdepunRnnLPGlCfPig1awcyTcLVHA83bElnHvIw0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb records its command line parameters from early_param()
handlers and consumes them later from hugetlb_bootmem_alloc().

Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
zones and memory map") moved that consumer into mm_core_init_early(),
which runs before the generic parse_early_param() call in
start_kernel().  Architectures that call parse_early_param() from
setup_arch() are not affected, but on parisc the parameters are then
recorded after they have already been consumed and are silently
dropped.

Patch 1/2 moves parse_early_param() before mm_core_init_early(),
together with jump_label_init() and static_call_init() so that the
"parameters may set static keys" guarantee still holds.

Patch 2/2 makes this class of ordering problem non-silent.  It cannot
fire once 1/2 is applied; if you would rather take only the fix,
please drop 2/2.

Not tested on parisc hardware.

Zhenghui Hao (2):
  init: parse early parameters before memory initialization
  hugetlb: report cmdline parameters recorded too late

 init/main.c  |  8 ++++----
 mm/hugetlb.c | 14 ++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)


base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
-- 
2.53.0


