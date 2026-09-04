Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA917C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8ED86B0088; Fri,  4 Sep 2026 15:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18536B008A; Fri,  4 Sep 2026 15:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3526B008C; Fri,  4 Sep 2026 15:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B81E6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:24:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DBBDC0206
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:24:35 +0000 (UTC)
X-FDA: 85177056510.09.D7E66D9
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3898180004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:24:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=BrAir7UC;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf16.hostedemail.com: domain of guanwentao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788549873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPby45mlvgqrjAjrgEFT66rBvxelwbiOcywD+a63yWs=;
	b=JMcJAQ5mswAe2Cp8+IOmjH3s9vi5eXz7S7U6rSPcOGOGdZ4/9hTuoCE8x97PNSIJSEk3Lw
	ljxAZEBVXAKmjEenGvaTZQWIqOJYXhgZbJmOiz7A1C6u65qHyvMb9vbKiJ740i7PN/J1sR
	gamKJci3n7XZKcCDXh7fBBIanA49zno=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=BrAir7UC;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf16.hostedemail.com: domain of guanwentao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788549873;
	b=QzOPb86ZUB7qNfcR+xpzFmJUJ0dOQew3NYnHLXXXWze5FauAEsGwvVTgfYMCgPZrubOWEv
	CKaJyAUfKXonUNgk3OT2x1upJs9AEdfwA46j07AV3LvuBOaJEZV1RJoP1lXCRLsGkallqw
	/G+9HcwGl+2sKVAMAHtP6oZF3NLnnKg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788549854;
	bh=WPby45mlvgqrjAjrgEFT66rBvxelwbiOcywD+a63yWs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=BrAir7UCiu+m0ZYu60BJYfxORKp8z0MRGeS2OCVXYlHbJuor/h/ID3sASF8i5tyh/
	 7aGGpt85bJdsleUkgt0iyj+PWluvYxdwUHZ7xd7Chc33u1OU8WwLQeoW3wxdoj2RQK
	 z1jP1ozZTFBuc+etIS16ECmGqPYaPMX9tX39bi+g=
X-QQ-mid: zesmtpgz5t1788549848te888fa4d
X-QQ-Originating-IP: lq8MqQhSC2/ww+RxZCAVxTrE9W5Lxwzn+N7LRFobiYA=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 05 Sep 2026 03:24:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13231209562070536267
EX-QQ-RecipientCnt: 9
From: Wentao Guan <guanwentao@uniontech.com>
To: guanwentao@uniontech.com
Cc: david@fromorbit.com,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qi.zheng@linux.dev,
	qinyuntan@linux.alibaba.com,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] mm: list_lru: clear shrinker id when disabling memcg awareness
Date: Sat,  5 Sep 2026 03:24:06 +0800
Message-Id: <20260904192406.24306-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260904190028.21542-1-guanwentao@uniontech.com>
References: <20260904190028.21542-1-guanwentao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MNkNUGo4CMaWFTEvoYAHxvhe2j6+OnXhB+7FadoVYJc0kVTfwg1Yhr5F
	Z9cmsY2NBIFrlpSxzVFiL9qjC0AvE79GOEC97SOs3mgtgEr5v99LwKq8inEY4OCM39bsKKW
	3dzZHVukUFKSXucsH7YODTDjCuIietdmEqaEoODgvPSKgZfQOHKjPx9rUdZNdkfn/b+Y0nq
	YUUYZlh7T5YNT2e0hGc5OuUH3A+lyzM+W2awFNI2qToVcUyfHqgqTQ9PImdntH4k0kmdxyf
	vP6VMpifMu780VXsQUoSQ/82Ca33PmtF6AeNOPw8X3eiu9pAdxqyARrzFJuMMtlirkwu8Nk
	Q4ploBwhO85XEBqB3YC1oCDIQBwiPC2wI1loXwyRm66XPTN6lAP/80hzcMchrz2+t+B5adB
	uN+gWVTTLR1z2uzQWgWKli2yu/s2uSES6e1mHq8O4f44d37WRoyA/5NJBTbJX1nGO4+gpt0
	NUcUauAygEwuFakgRls0wOR288SHqMryq6Q6/XFH82zhwWZFnk5Ee0M+B5Pg1Vw+D7ldwin
	9LD97WFWQ68OHKFBOQ58mFffI+10F/6H3COxfkFjvycT1SRW0vkEAEt0zSAdlX0j4QHbcR4
	zozuf2Ms77hyYRZwsyYBURwDZNJ/XUDBudcxvrcl4COUTHMKEdO4YhWsjP66Ob/fQKCkUj4
	IX1LO+2xSq/bFXX0CQEVwOZH1x2XXqvn/XB/BlJPjsR9osqoMSXfH7HeIQAaUvShKG254Gp
	Rx/3mxRfatY4cklPkkSxxRYsMPUQP85VDTxJ15SMmr9KwoK4J2xWmyFH9HwpmKX8WErDKoS
	zejkYbxt5TLUcnM+WeiVoECwbGJLeZNR8MvE0WNxiu3G5RXEmZ5BHRZAwoBJtFN2mat7oPQ
	vcqrvkyS7h275tMgKZNsxNkbJ5JTtHoGjxApirHhoEp4KnDfswqLgreu+bSgTl7HJsxHK/k
	Ao9AV9ii7aVlkzER1bHX0hQjD3yg87LLyErpS+5SZmezsLOT3LiHEvdY4CNYCeNcy7Nas0D
	+4mGGqnQqSAms36Kgzc0ZvmRulxk+uLQJtixjbJgI3z3t9WvnjiLaJsy509BmGzzax+smTb
	Z0PeQGpGgMbCMFeEx066WU=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1qtgc78f7kksaxh9oa9hsztbtyda9s43
X-Rspamd-Queue-Id: E3898180004
X-HE-Tag: 1788549871-345093
X-HE-Meta: U2FsdGVkX1+j/DvhwUWwyicipF7Mkw3L2G1vvFEHI1Vq6fXJPntAVXy7JTPydNqv1WNadvYmOdruK3+AJoLJ1Vcp10PwTv936VowN2xlAcHTacI1PVs2ue6cYoFEuxu2KWBSKb7rgOr1aUwcfiLQjiQ6VBW5NE2BnzgkbeRQVbWoZdsUH8EnYCzM63nlWel7LjiZcJg3SMuxWz7tz/hGLQLsmCPijtUvy1/leCdQd4DhZEJ8ECcgMIrzy4vtg8WNi8lN+15LgM1wgi82/tJ2uGZK7OfUC8nKOyvt/j8+WWAQr/i5bzrfs2zCu7Uktb4rVZeK0WsAaJqR6TXv01YbRv2VvsZa+L1xz8yKg0Fw8oMPOkAXGRFqLwtAQVYu/tVaXC4gS7lJWrkxyqGsBETXu8I8Tm3yKGYRype+AHhFH8utCwTIxiEkorSiH+BfRLImN9lcwlUpbuuLQiAPw7gbbgyBtuhrasfTWLaNJvzP9HsPX86qmlao0J8eolYL0/Jl4amAq5mvXzzu/mm8TroPnfv6VGxEQHzEWXPLUHfpOAeE8JoyQWcNFQtSTfBBwJHPWL4JjnRe6QxH9cD487SLAjMf6Fu9bGk6SvCtpEsxET1S83HLbWNZOjQ1fLR8tp0+Hw6VPujFy5ZiiDDzkxLD96bmxphIlp1Wo36XMw2QjmfKYDXFkgpFnL2ud6mq1hPCWmULc4yCBVuaiYJBy0x8swtJazLmXcQcgclramkkPkog9NrG+B2KN4oYEpYB+NZ/AfcKygp+uTk77WBZpXdT4cwp4+kaqBZFuAHT90A7FuNwThycLGl0SllNCC7lA2mBAXHdHb+pQc/0NZZRXeqsXbji7UXDXJdN8fqoQPqZHEz2Mk5QKTpRn+eKvKS/S41uCzz/HjOjAYdZW8GO4RdsZjGdT5D4wJiM3d9ebd8RLe1RA++RHyb7vzoZ/FcoPjlkICs3D38o7quFLB0uOXD
 k/b5/Yxa
 AI3FAvWijpuhjpJrJ+8DTtYZEYqSRFoMJECTaGW5SIgdX8pzwYYUx0Ryh3ym1IBB6GQbfy1nejD1tD4mJzxtN3n/9GXYAV7HUKcYKU+tXXzB53nmLTybNo/mXKzOe/UT+yNjOSAoDPK+tztilEswQth+6edA/AUGeVMoNs6SvJWUZMl8bxodLKeoQIsLWKyXGscekl0/LVuKUKXG1tPFIRi/jmyBPCYAoxcuAgiwyKXu7inok9FmEdWCi6lRde/tbEN2XLnhySd5k9S19w8wZrUKCtuJC6hMvGeoZ7LiwBoeuJcTG4lbL9Er3PZi98XLplQ9xTm3nK1hmRJ1f/+c5J50BKibVI+UOMTkS5o5Lv0ABWNRHuAxhJbItMuqegzZuA4IW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

I never noticed the patch in maillist
("mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers")
before, the patch is better than me, so just ignore the patch.

Link: https://lore.kernel.org/linux-mm/20260901115104.2944996-1-qinyuntan@linux.alibaba.com/

BRs
Wentao Guan

