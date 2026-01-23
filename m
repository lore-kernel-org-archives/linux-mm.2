Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56B4D74ED9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FD66B04E2; Fri, 23 Jan 2026 09:53:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA516B04E4; Fri, 23 Jan 2026 09:53:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EB76B04E5; Fri, 23 Jan 2026 09:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE8716B04E2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:53:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79BD68B452
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:53:01 +0000 (UTC)
X-FDA: 84363520962.29.3F7DE0B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id CA7BE1A000F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:52:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VsHFGsVK;
	spf=none (imf19.hostedemail.com: domain of BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769179979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVBzXQDCNtWSpdK/QWdp6QSI2UdQKR8SCDM6cMQe39s=;
	b=awBJEqqvS98OVy33bRAliHrD97Bm5AaxORX0XYGyztNkX/wlrvnkYgu4jaIpmdvxq93hp9
	sWJKnrU8iabfrCPgfv0Vwn54CsBuAviMZztWca430O4aQSUS1PhvAoEec3CC8y6AdiHEig
	+Zbmq/8jVw2cXtFd5PnlYy46pFtwRt0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VsHFGsVK;
	spf=none (imf19.hostedemail.com: domain of BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0e397fbe15f3c30da997+8188+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769179979; a=rsa-sha256;
	cv=none;
	b=j+2d5TBx5xgGjRTyyZO+TluvA4o0oOXKh8fVYurtKTpkU+IzFdmIJUT6JR+NtX2bi+XNGR
	gQR4+b1Bb6wB634f6zn/quObKigQoCjkfCWlzDS8M/If/SOuXrqM9tL6Rvdp1MDoHCgvhf
	HJ1OcQ3RYk3oyuobV3c1te7PE5Fa2KM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TVBzXQDCNtWSpdK/QWdp6QSI2UdQKR8SCDM6cMQe39s=; b=VsHFGsVK6hUiHl50ePEEJNfJwI
	Q9FZzvpVnrQEDS+3XYydQiRg3XZhM/MyiOWb167G24p70Xd7cdEZhJW/KDI1od3ZDTaQ36mBJQ/2m
	lFLqxp83xfWJnN1COIAjXR9A8d4ROwl96zt0vuCJ8SABO1R8EQLUbWnTYX5bCMuwlauRGxL4es1i4
	ujdBsbu9Faabk8HoDout9uhkNMZ1Ud+vWXbV5/Iza2SoYCANmtvG4WzGs/9IJkF4MWR8FcrV/NuS9
	XydARRtea5nppURoXWHEMGxCS1fjUH+9i19SNBKCEV8BRzPEXzYdlyBwrkFeiFhUR77YOmBldLj/y
	2/9ZYpdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vjIWt-000000093tO-1KWh;
	Fri, 23 Jan 2026 14:52:55 +0000
Date: Fri, 23 Jan 2026 06:52:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 3/3] net/smc: optimize MTTE consumption for
 SMC-R buffers
Message-ID: <aXOLR9GxwuNz3Ddc@infradead.org>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-4-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123082349.42663-4-alibuda@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: CA7BE1A000F
X-Rspamd-Server: rspam07
X-Stat-Signature: sg5h8r5i3sea3bxm4xf51g9p6gugbyqr
X-HE-Tag: 1769179979-943162
X-HE-Meta: U2FsdGVkX18iC+H32D5J18URU/4Z6diYJhvX4pmKiQyVjWY3eHaypEMUIP+NLTWHwlpYAU80qzwwaE/IxwRcUGGSmdwR5EU5PvtBXN3/z4TWd70JqFd7drjbW9XohlsQoYv2oBipUzBq30Rg6hMpEDNie35uB79oVn8uw1zr9F4fdmaaJqTKLxPC6VpxC2cPQd7YAMvGxGdRz3CdsP/iNy4xe6hK7tsm2PT8+TivFwTFzI8c4Y7kAXi2fViwvAzm/ZvW45HPcDJfvwY7hbpPzjHoiNMMfipx3UJQDyCxvusDqPaVsyF92KQwLoD1fSj7WbzVppA3BWiK10kYAv6bY6OqPDeaSyFHT71JUwWSCJADQtnF7MzLVwwg/pGcR3rHoWDSSfcsAinwStQSRnWqqgjpKZo71jhbsy+YWptFlvCnare7EgcURF6rk8nqQgMz8zwVQ/U/vP/4JOA5RV3ccXW6Cc+zWFPn+z9aDdiNUhOsCrKiZyCdKNg0MBm6jff4Z/vftgkhJFM2o92Tf4pdqzLd01eCjz8tGAtchyHp+WHzMNU7Eg/bGTGDl6f9VQTTwvPqbTyUCdbYbu+BEzV6G8Wc2sPbjs0X4exqjvNzoMPrwEzym7c2i9R+ORPToK5WzXeO6FBYTW1rD3SfH4gdK2Kgv9eSXA8P2QpCj/Pq50aJ50w62KXXSvw7LJG2Z8j8TlmjXCVxvPcGm+6GxdOGldqTIR9ytT+Qgs1pkenVp/AIRpgY3+DxmVirraHXh/Ppi9FzFNynvrZirquNbU/Gil8SkdwJp5yLX/WdG4Z3DgYkub8N8NwePJ9Atm082QrCz0NsnRCjN2aadmSMKuzjFYiOntQ7XhlK9tnCf8ZJtgMN0KXgUXtxZPRecVQIWz8E/guEI3yvY0R4beL7/mk7E4ALnkiP0uKyz7LwQ7kZXJUDCD8+sxSNvIgCqu9d9soE/Fe4/OkD86DKedYJcSZ
 XazPrnRZ
 f+9PT/CpN74KlwZh/9YAruDec2ezZ2gR678zrko7P56TwJNDo0pWXIkcteeNFzzVEpDXk9QTnb8dbAfIiAMAd2DARTGBe3RitYoyoKSEbI1RnCpkDxzI4DZ78/x/n+JCxzg0BpAelyEksN6nxUF/p+KSyYc2iC0Cp2AtEONm4lVROqeegWcpG6jBYpsiEA7FR/UTqxYV1XEt6BUOF2pKJ4zpqBUa+Uuoj+ufFqa74RBBLAR7Zk7E/kBdBSvSxKIE6B37KHpcUGle7lKPa4qM9gSVqINRf53OtlD2sS+RuWLIwarEdMUwNNpzMcxKEyRt2Muu+Np+QML5cfKPR3Vn1eaGWD/AD4SwqaSkv1bAOzxX0FcYjIDhfOzDTMRIqeYRZ8qIfj06LwHCQWI9TtQB/ARycSLAyETn9qvy6t8hdoPzDKxdUFvhCUuF+UuFUNxOq4/vJIsD7NX6H14lZWu/gOOYunwHxiBxcK7Cx9bRJDXN3LhV/8Cqh3qW8Dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:23:49PM +0800, D. Wythe wrote:
> +static inline int smc_buf_get_vm_page_order(struct smc_buf_desc *buf_slot)
> +{
> +#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
> +	struct vm_struct *vm;
> +
> +	vm = find_vm_area(buf_slot->cpu_addr);
> +	return vm ? vm->page_order : 0;
> +#else
> +	return 0;
> +#endif

You might want to encapsulate this logic in a vmalloc_order or similar
helper in vmalloc.c.


