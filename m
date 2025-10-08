Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C44DCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B810F8E0018; Wed,  8 Oct 2025 10:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58868E0002; Wed,  8 Oct 2025 10:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95A78E0018; Wed,  8 Oct 2025 10:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 984F98E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:13:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20DDF13B4EB
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:13:45 +0000 (UTC)
X-FDA: 83975140410.01.35BFD56
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id C28E918000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759932823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rf1zxpmZxhU8kb2GUm4ig3h0L/GcsL20Cabsuz7TTEY=;
	b=zpbOM90iSSV/aIGdV3JWNUYRgQxLTnhSFijcF5KsDFUZA8lXICkBmGVbfMVoy3D41E3j8b
	zB4Np3pBTnMhufcKvOkHxdzMfLZCWHctzQgzsB1xF4dAOZE6EWY2RhK2dUVtTHQAs1kwgx
	eWRlrHl4LQ/naWXS61Ywx0HUGlZMa8s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759932823; a=rsa-sha256;
	cv=none;
	b=zNn9GRcjQs858sSwJbQ71Tcc0/QbYHBQBq1m1UP1Mxg6yhuz+90H3riPKtfpLwIPmugyVc
	cE6/V2VTu9DLbfDennThavpin0m61YeUAL9k8OBYfgOn3QToWuYZZ3l4Xk9GSK2xFCpycE
	S7jUFvR0LPap/Z3Br0LfZTVhxOKYJIs=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4chZfv4gGzz6L4vx;
	Wed,  8 Oct 2025 22:11:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 964541400DB;
	Wed,  8 Oct 2025 22:13:36 +0800 (CST)
Received: from localhost (10.122.19.247) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 8 Oct
 2025 15:13:35 +0100
Date: Wed, 8 Oct 2025 15:13:33 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <dan.j.williams@intel.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra
	<peterz@infradead.org>, "Yicong Yang" <yangyicong@huawei.com>,
	<linuxarm@huawei.com>, Yushan Wang <wangyushan12@huawei.com>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 6/8] cache: Support cache maintenance for HiSilicon
 SoC Hydra Home Agent
Message-ID: <20251008151333.00001b94@huawei.com>
In-Reply-To: <68bf52fa851d9_75e3100ac@dwillia2-mobl4.notmuch>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
	<20250820102950.175065-7-Jonathan.Cameron@huawei.com>
	<68bf52fa851d9_75e3100ac@dwillia2-mobl4.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C28E918000A
X-Stat-Signature: 7shroaynzo87r8n57en9a3wku8szcf9o
X-Rspam-User: 
X-HE-Tag: 1759932822-924248
X-HE-Meta: U2FsdGVkX1+MCjbugyAHH9hfuIqu7SXjMOK+kMe7MVkNFr1q8wjxKBQboFPPjoJqMMlgQzGGLBKLIFaRZxAS+/crD/ZkWgfrLbEKu1sp/JMYsR4OxbhnqSTF0iqZcB0EvnSA43QuLwO06gi88EvpjIKoNqdourcdTtBvtA5F+4koqZSWhEqi52hiq3ME5RPQx/sJ2azgA3gQxg7ufo1jehSSmsit2mx++sOT3zuo6q9zilCBgx9ERJZ/huK1QSzfGe3AeTNYUv//xP03PMhzHLxOgtHJFGW/hlTBv8gKAN3GnpI2dniSpxvfuyunDqhBLXt2SwNPsBu/e5Q8S96r+AP6J4XnLzlPWCtBlQFYxNFBtLQg1jkLb7tNa8MzVNdr/Cg5LooaicDCQVkwjnp9FdZH9tZO3nllQI2xqqonDRqjJ6E5wMOgPkEkBXJF5lHethYTPvkFznrzDX8SXIAyF+gZXg4y8KbOS5FYbd7GDP/TClJHBV0BSw25SaGPmEHc/F2KdeWYCadxvarGtTtNXE/v3od/FJS6jpiLzmCGHUZsaEYr2GLfbr8m0bvC5T8AsAsy725pQN/G5EfGeAmdRjw8HrDD7pQaoodwAWx4XgnDm3yvuEu6jHARphNjQ24Zk1oXqvYhYVP/jSSSUxTJA7sB/WqetrrU/uWbIljgSpp9Nrka82i8k5oTFOlH92qX8f9cKEwUpNLrt9VOOZ9r8zFRvsFjmVvYBDJtM63aZMF06k7Z/wuKSEENhxVgDv/7JxkAIfALDg4EWk8R26CMKYep2HtvkdQlJXrGY5ApQRlwotdSbM0ekuLNb+XYyNle8CLZK0yXxBTBqR73TvbVtrOq85Ysa5tw+S/PHkVG1psP4ikuVf4HwUU59HhUaUPKrZICGF+Pof8occ0Xsc03d+6NyQtyj2dc9A9LyGMf3e8tKABlKHG9p+1xSwwrbtzzueqJZZPZGCDQ5JLEsXK
 4ssXo/7v
 b7ZuZMdgtlX1PfORHKN+VGDDLvto9tUhA2zG8rvOaQC4zLxFZIv932OLbWlFgp48LP/fbUryZIj2vh9ijgYBJRzBNxoU+MQY3UNNzowTZ7H0sOPyMqe9C6HpuMo6GubUXlf0u1nv+s7eDJIsQDRyGkHqJgG2OAt7NEYXnufY8eBVn3h6WaZFF3y084iSll7j4f2D5AaYxMutjme0VQVNIZVG716hC8OiIBbkzyCrLtXLgYkOONVkSz9dw/xsOcLhrXsF6OpVT05cWVLCXAG8EtOkDT2PJ99WVf2yjdRhSc/IQQatQl1gvEocYQqNb+4Gm5DD4rLJPX+MTArU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 15:04:42 -0700
dan.j.williams@intel.com wrote:

> Jonathan Cameron wrote:
> > From: Yushan Wang <wangyushan12@huawei.com>
> > 
> > Hydra Home Agent is a device used to maintain cache coherency. Add support
> > of explicit cache maintenance operations for it.
> > 
> > Memory resource of HHA conflicts with that of HHA PMU. A workaround is
> > implemented here by replacing devm_ioremap_resource() to devm_ioremap() to
> > workaround the resource conflict check.
> > 
> > Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> > Co-developed-by: Yicong Yang <yangyicong@hisilicon.com>
> > Signed-off-by: Yushan Wang <wangyushan12@huawei.com>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>  
> [..]
> > +static int hisi_soc_hha_probe(struct platform_device *pdev)
> > +{
> > +	struct hisi_soc_hha *soc_hha;
> > +	struct resource *mem;
> > +	int ret;
> > +
> > +	soc_hha = cache_coherency_device_alloc(&hha_ops, struct hisi_soc_hha,
> > +					       ccd);
> > +	if (!soc_hha)
> > +		return -ENOMEM;
> > +
> > +	platform_set_drvdata(pdev, soc_hha);
> > +
> > +	mutex_init(&soc_hha->lock);
> > +
> > +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!mem)
> > +		return -ENODEV;
> > +
> > +	/*
> > +	 * HHA cache driver share the same register region with HHA uncore PMU
> > +	 * driver in hardware's perspective, none of them should reserve the
> > +	 * resource to itself only.  Here exclusive access verification is
> > +	 * avoided by calling devm_ioremap instead of devm_ioremap_resource to
> > +	 * allow both drivers to exist at the same time.
> > +	 */
> > +	soc_hha->base = ioremap(mem->start, resource_size(mem));
> > +	if (IS_ERR_OR_NULL(soc_hha->base)) {
> > +		ret = dev_err_probe(&pdev->dev, PTR_ERR(soc_hha->base),
> > +				"failed to remap io memory");
> > +		goto err_free_ccd;
> > +	}
> > +
> > +	ret = cache_coherency_device_register(&soc_hha->ccd);
> > +	if (ret)
> > +		goto err_iounmap;
> > +
> > +	return 0;
> > +
> > +err_iounmap:
> > +	iounmap(soc_hha->base);
> > +err_free_ccd:
> > +	cache_coherency_device_free(&soc_hha->ccd);  
> 
> I understand that this scheme works because ccd is the first member and
> that is forced at alloc the same way fwctl does it. However, fwctl hides
> confusing code like this behind put_device() in the free path. So I would
> say if you want to borrow the "_alloc(ops, drv_struct, member)" approach do
> also hide the "offsetof(drv_struct, member) == 0" in the object release
> path and not have eye-popping code like:
> 
>     cache_coherency_device_free(&soc_hha->ccd)
> 
> ...that throws away the allocation side cleverness into a cloud of reader
> confusion. Either make this an actual "device" or otherwise have a kref.
> 
The device option is out because Greg KH was not keen on me using that
infrastructure when we don't have any userspace ABI. 

Kref seems fine but because we have to pass an explicit release to kref_put()
we end up either with the odd looking

kfree_put(&soc_hha->cci, cache_coherency_ops_inst_free);

or wrapping it up with a helper along the lines of
cache_coherency_ops_instance_put(&soc_hha->cci);

That seems reasonable but given there is no real reference counting going on
(the reference count == 1 from alloc to this call) using an actual kref is
perhaps overkill because this is really the same as having no kref and
just implementing.

void cache_coherency_ops_instance_put(struct cache_coherency_ops_inst *cci)
{
	kfree(cci);
}

So other than a rename it is the same as current implementation. :(

So for now I'm thinking have the helper and use a kref even if it's rather
silly just because it will then behave how people (hopefully) expect it to.

Jonathan





