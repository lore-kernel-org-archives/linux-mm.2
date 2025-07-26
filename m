Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E1C87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 03:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3DB6B008A; Fri, 25 Jul 2025 23:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8737B6B008C; Fri, 25 Jul 2025 23:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7895A6B0092; Fri, 25 Jul 2025 23:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68BE36B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:33:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 972CC1409C8
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:33:18 +0000 (UTC)
X-FDA: 83704995276.13.1006C0A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5184316000A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:33:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="T4A2//fp"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753500797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOf/JsoJMrRn21goOdJm4+ac5LJbqkVW+ltM27ZJiRM=;
	b=WnlYAgFo2rLr7oq/E7LSHeg6vwG8L/kO/rvoTVWe7wQi4Jq0lyCl5giM/LkKK6xtjpTAVi
	mwDVSnDpOKbbaqZmQbfJuSrS9EbU6Xo0dp8xWiL69Q2D/W1zbu7yBknt/h1/DOJ2cTeAAu
	+/QMccty7o9+qf4Vb5+RnKTZt67Jst4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="T4A2//fp";
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753500797; a=rsa-sha256;
	cv=none;
	b=iP5mUm5+wjz4yu9ri3+VaSfK6tySNd3M//pB+z8/ms5KGfOVixuK1Z4H0myjXzS6mesGPq
	jxziZngIQxlMVL/Dz32bIK52qiB5q7yBfe0yRXHzP8KsR2BzUnZuruggJ/tcXPhq7O/qKJ
	kN6UdTTT5gOP5tvDgHSsgrkeP6qJDjs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=sOf/JsoJMrRn21goOdJm4+ac5LJbqkVW+ltM27ZJiRM=; b=T4A2//fpP7ng2tgBSTerx+g2CY
	Tw9hKP6h0ejao7H8r3Vx4CVlTBadoL9hwhlPqq3xJCrGPwdL+lPQCBmQ6OHPFHvW7myRAUIV5Zjg/
	/CmL0RnpxfZKlzph6nJFMoOx9iKbfYTyEjBIIsvKQBSSJptrb3hAc14Gzx7RebRFftfmx2BijBL3E
	BCSX48jOUiaKzZ9ENw+kc1/RM2dC4dVjZ/3Y3lIt55M0u3lbwan3zkvdfbY9ammRDVki2DWVETgf3
	lTx/GNO0rVr9wDOC/d9uGHvYXlvg+WgBp3O6gbmVNyEbrx06sOypAQEAAkAutsLyutbAoKUOLB/Qn
	KR648+1A==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufVeq-0000000B5FQ-1bOC;
	Sat, 26 Jul 2025 03:33:12 +0000
Message-ID: <05ee7001-6425-43ab-a929-e1e7924d1d0e@infradead.org>
Date: Fri, 25 Jul 2025 20:33:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 01/29] kmemdump: introduce kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-2-eugen.hristev@linaro.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250724135512.518487-2-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5184316000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 3kt19z8an5idn3ecsx366dd8np8g5jzr
X-HE-Tag: 1753500796-748778
X-HE-Meta: U2FsdGVkX1+Fq1gsE5z5vobHBiq3Jsk+9QunmiaC13mpBheGPrLZ2hrTq/kYCJ6cMbZM1iRKd8GdzKffGd9on+XfTNAzpkYDC+Sd041yicDg5OjYNHffAWopeD+Oh582K6HWvVvfdqi69pjVcoqJs64bYHn0raPLU26Lp9+sIumHOooSiPeyNYMaXh6+Fl+QGaCuSg5+QomsdvMIbc6KVBRvZf9LvQWGRqke0hbKp/xgvCyUy0BKmMeh3bArbnh5+1fLxkJ+YItGtgkItWHBFmQpv1EMR2gqtkzQa5ZuQnHzmVvNyGSjxMEmRFNn4rq8RCG5d67OG1rAY+u9307aICXF56Cg5gcjrEhGI12N8mXHA++ntlgzQeoQZHaKpMXshSe9E2V7NKG33QdM86HvePxua5LMA3/TD726EMtpe6U516nozJeMzSzEsK9e6Bj1Sl9HuHRdUDJa0edO5Rd8QlY75lVF5Mq8y9SFZNNM2ofYO5Cc8/HISHc+2LylsT6uiDQKe0jCsNTlDXqO6+jtK8lI977jWI9dfiVosHs9B1ws89u2dGhxmRbV0KMGwu8H50EsDyX0nYjb6B428mRJFur2b+S0XxF5/CiTMqTWStuDImzI2RV9gPQGWsrUOZbge/Jvcq1R68dHYya7D+9fjXWAnAwyd+GStgrqYCAr6LYNM9MzLQEvpOJKiZxeasSjfLO4bde7EEuWdGZC+hyGYli3q3KHndfrVmkG6E47iaE8et8dTDDKRJP+sFc34YRMQUoRsrknOoYfQpMp6eedOJPz+BrV01uQpbXL2v9Hp2NN/ci57s84Qp5qE2BVgXiza+tDr/wQkvjceuiTalchbh5N97/fp06l/MvKtdGuTqX+Lgi3fsAhy0T+ibtBinUPtp8CtSvcjF1ax/6Ld/u63Stm9yI+KdI/oV/u2yu/MWtuw4Z3SHA3hBfpz89J3GCF1/1vJvnohwsT02m4dQL
 S6v6angL
 r8dy3zOqpMUO47FCpO6mN/Ec8CrYAVmM19jTsJShPQzwWpNVk+w7ARNIHoU3T4BfeLrAdDoenO7TMLSjWTbUlYj6hAIORuKUgJG4f71kVGFBalfb7yf7lQvSsFq51QaXwc6ZBuQiJFHiLgeGFc8lxn1QVknkD7heZvcBILTui4YvSobwnPB2w9asXYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/25 6:54 AM, Eugen Hristev wrote:
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index e0777f5ed543..412ef182d5c2 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -245,4 +245,8 @@ source "drivers/hte/Kconfig"
>  
>  source "drivers/cdx/Kconfig"
>  
> +source "drivers/dpll/Kconfig"

Why adding dpll here? It's already in this Kconfig file.


> +
> +source "drivers/debug/Kconfig"
> +
>  endmenu

-- 
~Randy


