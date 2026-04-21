Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B016F8FA86
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B296B0005; Tue, 21 Apr 2026 10:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB6D6B0088; Tue, 21 Apr 2026 10:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8766B0089; Tue, 21 Apr 2026 10:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A13B86B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:38:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1713613C3FE
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:38:54 +0000 (UTC)
X-FDA: 84682819788.28.73F4FEA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7F76C0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:38:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sYjp/pUC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776782332; a=rsa-sha256;
	cv=none;
	b=kDyRCi0szCc6YakWqwsTOsAYrDWh7m3h10RyjELMQsH3N18VAJJJTTcMqucsj5sFEoI48R
	3MT76v37samrbv1IiaPOgpUAQu6KBd6BdRoQh7RyfPQeKTALJG5Gi+JelP1ZQ9pYFFfHov
	mwV51XunH9BDAqtX7hvdCNm3kUjeiVg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sYjp/pUC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776782332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxcpXEAJe14k8AFRl2ZZUG/a8v1LTQkJz0YRHAz065Q=;
	b=jYZ0Xg5IQTCcZ9B3DmQYqykmcZAlvDqcT7ezz+Jq2oArWZf6laC38rzZ0jqutYbEPZUI9k
	3sTNCGluUdoHsnmC91s9hagbjj6ePhsTnYDisLH7Tt+j7WUt0VjlqLEKwyvsPNZafKoXqX
	LtGwpQiMBwXzbvq/5USc8OvBH4YOqUA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vxcpXEAJe14k8AFRl2ZZUG/a8v1LTQkJz0YRHAz065Q=; b=sYjp/pUCS09SsnpT8AOaExyGMF
	QCmE/suHcQz3RYLWJxkp65JDqIjmpSIl4QJx+Y5kr4hx2EqQ3E3yAPmu50OEkk5a5gQtYFbv4/Twe
	nXS93XBxj5ZhCtnwJF5X37TTA6soNY8nlyIg+docAg+qQBzH7pCqpHG3pM9oh5+kETJAreohIxyWM
	Ke2noX0qW7IjyxO4URPmFgctnH6cYRZHbzymwT1FenmnCG5p3kgcKQgwtWkCnjYNPxHiyRAgpTf5R
	6ZCw7b6xNbbj3N7QlfQO3Z54K2Kwq9HqxPNphX/tagiUDaiLLHQ++slvD6+q0TyiPw+8c38eIK2kS
	SUL3YTrg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFCFR-0000000AGpJ-1NHJ;
	Tue, 21 Apr 2026 14:38:45 +0000
Date: Tue, 21 Apr 2026 15:38:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yibin Liu <liuyibin@hygon.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, mjguzik@gmail.com,
	wujianyong@hygon.cn, huangsj@hygon.cn, zhongyuan@hygon.cn
Subject: Re: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
Message-ID: <aeeL9TVSZJe3sD6u@casper.infradead.org>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421020932.3212532-1-liuyibin@hygon.cn>
X-Rspamd-Server: rspam10
X-Stat-Signature: m87deirynst35okab8yd9jqh81np5ash
X-Rspam-User: 
X-Rspamd-Queue-Id: A7F76C0002
X-HE-Tag: 1776782331-848529
X-HE-Meta: U2FsdGVkX18HAttyMJgNja/LMABkXCfth3Ybthn6wYqQjq6L7GE6gY1Z1JrhfwAMviPURcDFC8Jao1IVOiT3mWA2VyJznVkQ2BNRcddkmVzzbYTbr5Chj6hx4TsdaVaggl4Kexs4oqr9oIGyA+O7DSm4YEro+633ln25n2nlVDpzigvpgQqOmAe+xuQPKi8FFP5WVGzt+W6mMO1Tyrcef7D27VS6g98FGW9/D0QF5+hRTnJ76JBV28L7yl24SHFR7aK1vc87MxZVT537vedOr9GlK3Y0Ggl9BUc3KVpWeYRkA/W/afvhH+BRmUcRF5t9CsM2Ak0/9ZK2MP/vOx8QTROUPVmriCKc11jMuHIZ9RO6WrVBMshb+PUCG4/3ORax6wNiOYndFlM0ZCR4RqJ4B5PeYfSRPNwHMny50wtpK4yV2ppXZ5ejdt3/Oi9UHjVfjImVzA2/+GGMJ+IpqxeRLfyu8KIsIKYOEagYhKNqisV4anFaKV1iLSAK9DTvb2OnJhfVYRJjcoO19pRZh0PyhpuRYrPwcIv9DTAgekE50cVTXDLFfJBAubrLq4z54J4X19rSKSYnMiPHysK57ZLzI+qi8ySEmuG1fpYzAP/DlQGcO0ZK5SFdQq3+lkk9RGmlcHDbQ2aMU6KpL8kCG2vGgc617sacsZKrr89O902PstUg/OTBta+XIzGSfrc/5Sb9GMRCgXyP53BI9qFwYvHlwOTZL07zJwuSO7MrEvUM9nRZgdY4dpc4oTn+HOnrGxmRDnUUnr2QyqN1eP7H+7cBV7LTvqLu9E3xdmO7fyjbc3UhNfYkf4lXRwkn17kwcum0fGWnS/+fTRF3h+k81/hmUxKalbu9zwuwzB5zyh+uzJyGP5ESMQS/2hJlSPs7DV16qN15fU6GQjcXibZ5bvAYF6PYz1CnU8lj2jlfTUa0vusCTlMA3JWFdDQJ3RvSRo2XAqZnd16Uf0kkd4/W/OW
 mhy53jNm
 rI2AbU+cGPvIVO5NBNMoBCkzJFX/w6ZuZeisarUHGXyA1Feuz1/kRLFUueHnptMs8gSe3mdF+8dZnOeTDRmG+oO7IfmvUqt4fOtMOPJzV0Y47eQCVi7xKmXNqFlZ/5c6JaCeQKKxvdu97y2sdH0T71AYuNQvTZM5o5r89cY54fahPSqAZPuDhBEPE7zysbxutgAO2HMXGnHDXv3yTsrNsK52W0iJ9cDFpui7h4M29qW/v2N8ecdK396+gYpEVIugKU7A9hAHX860R09Ffr+cCOKIs2haG2XL7Zhe5jEvbzcdBXuYKUnO1wSo7NqmqNhN3/RNT/tqL+X4BnMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:09:32AM +0800, Yibin Liu wrote:
> +	/* Prevent truncate on files marked as RMAP_EXCLUDE (e.g., libc, ld.so) */
> +	if (filp && (filp->f_mode & FMODE_RMAP_EXCLUDE))
> +		return -EPERM;

You can't do this.  It means I can prevent anybody else from truncating
a file which I can open.

