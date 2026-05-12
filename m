Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6611FCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873596B0099; Tue, 12 May 2026 12:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8236A6B009D; Tue, 12 May 2026 12:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760B46B009E; Tue, 12 May 2026 12:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACD66B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:27:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3124A1C133B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:27:06 +0000 (UTC)
X-FDA: 84759297252.03.C1B417C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 226FB40011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:27:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf11.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778603224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uk4IPCSr11MF3+VFMuCwNzG9pONr1nQHBxTTfK2HGrw=;
	b=zg3WYNxQMX563Wv4PhGGJ70durbs5br3X7fZhuQ1KvjUs4S/THZS01Cl9bAT22Uy1hNfog
	rV4TsBEa4FgfjwCCZ3Vllh1GyX+uuljenkTxRCWq8IfKDzLJcDNb0Ua83VL7lfXY0SH6d9
	xsQEe5DKZHdhrk3FHM2K+EoNH/dDlvc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf11.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778603224; a=rsa-sha256;
	cv=none;
	b=3yKnkcl1ACtbQdUi1J/NC3hUJjH1b9Ae9/kBTIPo9PrWaubePid79Jt4x1U/uEKRq1qP+W
	fDiFTjXfccDsfLMuzhDQkuROR70aZW7cfYOgo1rrhD2GuhmqZQhQ7lu7wA0Mv/wjcdKs5x
	XVOM2Py3hQJMybsJF+6SGK5KwgOXn4E=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gFMRv0zLyzHnGkT;
	Wed, 13 May 2026 00:26:51 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3345E4058E;
	Wed, 13 May 2026 00:26:59 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 19:26:58 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: <1234567weewee457@gmail.com>
CC: <fedorov.nikita@h-partners.com>, <stepanov.anatoly@huawei.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
	<virtualization@lists.linux.dev>
Subject: Re: [RFC PATCH v3 3/7] hq-spinlock: add contention detection 
Date: Wed, 13 May 2026 00:25:02 +0800
Message-ID: <20260512162503.1843025-1-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512144908.610907-1-1234567weewee457@gmail.com>
References: <20260512144908.610907-1-1234567weewee457@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: aybnrxdh5xiy3fqedoyaijmyziyizcfg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 226FB40011
X-Rspam-User: 
X-HE-Tag: 1778603223-439631
X-HE-Meta: U2FsdGVkX1/2KqsmtWYZ5GgFnBs2GD60Lzz3BsIFc9UFngIWgkHJ4GpfKzZZJcxm5nVq6PuXNbvOm1BwtJDY+tyAomVGjtNCtQC+xnAZAW0v8EigvCW5trjyvDpQ+8cdkM2MtLzWCYLraxHBh/uCsUqxjex2ixwWQJSe4rnPpsy4+7ICUdW8QnTh3cvCVAziIqWiZynXINry35rK+8l8ffsN3GGxeBGCigvoypClwTiwkDHF3Ff09Rop43BKnDCrvExxU1HU8XWeSdbqNbGMbCdInJcULmy7zRnQ82x5wyDCsqzcBOxSRo0V52l6eapawyRLL76J1Jy9L7PpypvygK00jIxS/RKS4PEIkoxgot7NFCWDe5Pxq4OGFXO0mQhnwlkaOgsSMlJZSXlPXLL9RFfrySDcfYLE1b3szfMVKT+rwU9CxHcWk91AI89Uq3DmUA1HJ3Thq1vbJD+ExPxy4o1K1I9853xn31rCzhIGMCiiOSj8jLhRHXsrWyfEHiYpLC9LlaX0ITFHgo2l0PJ404P5pTTr9eA+o2vcIn4iwZa6VcVSKVQoQsa0zI6BIbrcD498mZOmjuZPD9euGFg88Ues8Zi7LlcfA5HIbJY26i7/aftVADOIc264gkp7xPEMGWQ6FgcCYAHPrV1LDHcXNMmK8gdyzE4f2FcCaavPh4P8DZwth+2uVojzbAij3Cu5BTEAJGzCMpyxqg3Vk+UqusEGvQYWBsBh2oM/MvqAlrSyslTS774St9EroiULyiXSgXp8JKiSMskRaOFO5W9f4W0YJGaM/oTnOKqkM4/mH2t+IMfE2sdrEttyqGlLNn4X34ZABp6ux1esPUn8xrIpxEscywbGgqCPZXetKfcPdyYrCK+x7QySwm3ZfzCKdoc8Rre5D+4lq7xAnUcbwKFxqaanfLQAYDfhnIhT1igYBJ/9GyC2IXoF5ZdpfTdphKfEZd/QOfagmmjPsGIfFeA
 h4Sn6s6F
 KQuQD9//HIwDQme9jqcxEQS5g9bNynBDntO9oMBQzvHUSEnwaauuoY5cBxWeftJV9y8Jr4NAHUeOxrgZd5FMtBbwZfFrpuptPZNvn2jersbP1ou1rGieP/gk6qTtzYd30dXAWOB0dZGqzba/LnGs0muRAniktf6hv87MAE1G7IpoTGFtoYqF/kl/D5/O8lKoSlmTW1L8nIm/8Yk5vpquIY2VODFi0Xhw6Qt1VXVGLr6i5sHEGZD4ktsvC0uvSiYJdm0Xf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!
You are right - a call was accidentally dropped while I was splitting the series.
Sorry about that. I rechecked the whole patch after fixing it.

This is a small fix.

Thanks,
Nikita



