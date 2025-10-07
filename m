Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCD8CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 10:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BB18E000F; Tue,  7 Oct 2025 06:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C2B8E0005; Tue,  7 Oct 2025 06:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168BF8E000F; Tue,  7 Oct 2025 06:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 051638E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:25:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 852C588202
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:25:15 +0000 (UTC)
X-FDA: 83970935790.30.504BC3A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf22.hostedemail.com (Postfix) with ESMTP id B101FC0011
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:25:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759832713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=XiT5mKEsTbc9a5c0jwULNhvr+h0MCYNuZvqwoYE3q+Y=;
	b=k8pluPQkcNO+EcMoMLz/rCp2zQRmoC2tsIFYtxQfKE5Am6hEUjzctC2uiYsoUa92cyzNMX
	udAEORZp0+O6uXPnMJDBskL7It9xu505EDhXz5h2fTrwOMum0i240v4G75F2vYUKMXQ5JZ
	2iWcNCx/zupMqm2Ff7FE8JlwyZtdwvA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759832713; a=rsa-sha256;
	cv=none;
	b=vPMNzhqf6sEdXOidHtwXaWmiW+Dsgs8WKqkfVlrPERpUodxi0MRHLzlsDmFrbtremukXsp
	HUO/245aFNpJ4qW5qFt+FJYXbof12N/cMiJ+V7V34Rd1eHZf2x4Kq1N5u7Z+IEsgYrMYCD
	UWvpgBDyHV+4c9HZPlkI/i+Fukf+UJs=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cgshh70f2z8Xs6v;
	Tue, 07 Oct 2025 18:25:08 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 597AP1N5014420;
	Tue, 7 Oct 2025 18:25:01 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Oct 2025 18:25:04 +0800 (CST)
Date: Tue, 7 Oct 2025 18:25:04 +0800 (CST)
X-Zmail-TransId: 2afb68e4ea80563-5fb0d
X-Mailer: Zmail v1.0
Message-ID: <20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn>
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <tujinjiang@huawei.com>,
        <shr@devkernel.io>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <yang.yang29@zte.com.cn>,
        <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjIgMC8yXSBrc206IGZpeCBleGVjL2ZvcmsgaW5oZXJpdGFuY2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 597AP1N5014420
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Oct 2025 18:25:08 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68E4EA84.000/4cgshh70f2z8Xs6v
X-Rspam-User: 
X-Rspamd-Queue-Id: B101FC0011
X-Rspamd-Server: rspam03
X-Stat-Signature: pmc5ktaudjroe7b19qh99k76jkw1mc1s
X-HE-Tag: 1759832712-672520
X-HE-Meta: U2FsdGVkX1884EZ7nH+6MbMDtvjiqhMsAoUsX677QOYMnv9JMiUxsmafwwrssdnx/9QnoJ/PRLBaW/xis5GVy6f6sJnCZReEL5BxhnMQTZH1sjLs7dSQFamu+SrDNTXgsRbI2Q55P2wfMIqF7eULh2BAJ8GJNvqsWdMJGaeB26KnDcn+HNODwXLN5WoKTAH3ulT0UE1RYSXaHEUVFqE3TzVYC2KTeBULwJTuwnpNiWSVI1jfBCICVKdXJF4uM/LsjK9lta1+buKz2mFkByKKY2pMjcxCdwB4Q46A/N2tebWgeRi6RjEm0V2zREnsY2B0PII7LDrs9IFKB8lUJ7/PXGrzHJoZAQur2pt2PUTHSmE/10QCB1Jv1LeKmFMvGHYHp1ukYoI6M7Dyg3mkkbvW7hyCjxy4jVL7IwXBZ7JC53ysFJgRa/KLAYYqvRoZZnSMhANMywBZW6srBcWWk0BOFRIeYPHoB5Bsvm2mHhc8t6MQRBV/yTnJzvGlMEwhygyGdTjuO5vxo0eXOZ6gdtQAWLJtA/vQGxrkWyo51/crBHqwP8AOwtgYkgS53XF7xpMawc+TuTnvMj7ekY6tLSW/akStrXnOisqsUw7TQ4ml4/EUDBrF2cD1p/zRIW1xBb1Wz57FsWxG/89/gm3TBGqXO2TAuucDEAWSjZz6s4wRwsW2YHIOxv2EwlzaMcTCsNbXSdqNT1mkIUu7RC4lYhv6K/ykRbh624QQm0VdxV+WXy2WtrwFpyJcIyRXWi5XidShZNhUNE4X+OQJfh8EMq9irihNwv03w+aCDOvQKJ9FgcWVktaRUrp6ch+ih3rf3IHg0ttvX0ks58I3lcXvUtq9D5AmgNOFXutQ8v7IlaLoieq67VdFd4WARR6pCesyKPB5I5+F42ELa/YIDpeepbEQLWtV6isQG2GIEhbpDsdOGLZLaBAZ3+R6aT6SS8+NbN2ZlvKwef0jO9FI27P7elu
 EIUueCxE
 GFVLbykmksjzxRsa+lEOgfwPDROmXKq4uYBYglNoRkad2FoZpSPuqMAk2NW43d7CTlpsjtiWSfUpSxpOnYNrp0lGC2U3te5gqZUNKj13aYC+35XuxgmRolYybD820FfFT0KMQAnDnnQ5LKSSi8iLr+FnAg8utABGVmdr1xQEB8OO9j0aLGOtrLrcHxU2yOcAY+raO1M6ed2sxSbOf1Gnqq8TK1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.008666, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This series aim to fix exec/fork inheritance. See the detailed description
of issue at the following patch.

PATCH 1: the patch to fix the issue.
PATCH 2: a reproduce program or testcase.

xu xin (2):
  mm/ksm: fix exec/fork inheritance support for prctl
  selftests: update ksm inheritation tests for prctl fork/exec

 include/linux/ksm.h                           |  4 +-
 mm/ksm.c                                      | 20 ++++++-
 .../selftests/mm/ksm_functional_tests.c       | 57 +++++++++++++++++++
 3 files changed, 76 insertions(+), 5 deletions(-)

-- 
2.25.1

