Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784C3CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853B48E0003; Thu,  2 Oct 2025 07:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8047F8E0002; Thu,  2 Oct 2025 07:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3498E0003; Thu,  2 Oct 2025 07:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9248E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:38:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEA1BC047E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:38:40 +0000 (UTC)
X-FDA: 83952976800.30.69E34D8
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id A670F1C000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:38:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759405118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DuqHbS6Db0nHwWK5UQqnbjffXMe2wM0oW9lkfDD1neI=;
	b=xo37+QeHF62/sZD/9+41plyz8jGMti6iam7mnmiiRh5Ee67V9KSPS6lQUPRv5xEaa/HVA1
	9CQ9HHVA7njaTabH4cIDZD0+wCvAHTaRaH7qTavKN8h22HkEFBobVTsnYPshJ1sfmKNkYa
	y+0eTB7dg3FMlU0M38AxC26IbrT2qRc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759405119; a=rsa-sha256;
	cv=none;
	b=1xpKHlu1O6aFa+/xMDSLZzqWzGHpLQXxSmUBaASxxtXEQff1F5SEnjg2nnvWvD+qvpKOVy
	CIvgOrBZVedcY/bqkBOQRvQ/k0980mZxewT6UxpSivf3dZU8QIWEty1N2iIvcdPFLf/djr
	Sar36DIbUMCH1EFW3Bgj3kMh15DA4So=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccqYL6mBGz6K5kg;
	Thu,  2 Oct 2025 19:38:14 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3030914038F;
	Thu,  2 Oct 2025 19:38:35 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 12:38:33 +0100
Date: Thu, 2 Oct 2025 12:38:31 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Shivank Garg <shivankg@amd.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<willy@infradead.org>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <dan.j.williams@intel.com>,
	<rientjes@google.com>, <Raghavendra.KodsaraThimmappa@amd.com>,
	<bharata@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC V3 7/9] dcbm: add dma core batch migrator for batch page
 offloading
Message-ID: <20251002123831.000000f9@huawei.com>
In-Reply-To: <20250923174752.35701-8-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
	<20250923174752.35701-8-shivankg@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: A670F1C000C
X-Stat-Signature: q6hwrn4h1cfxtjsuh48xeyf6tjch9bac
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759405118-614409
X-HE-Meta: U2FsdGVkX19OLPsXvj+vJRSRSR6o+zpIYQGHTVoSzkcLHSLVG8OmEfcSMkaD3l3KFj+eBIb5SP71klCGzxEvk81S3vU+7khwMRTjOLfhqgoWVayttDtyUSnBxSs3apJfCL3QT9JyLb3LDLu4QnUdG194UdiCz9uRuvI1p0nvPRqnwg4qL4DDA3oO2HxA3YsLhIhMWmjFq5FAi1p/obPlrAUplz6LZXGskC3kuxw+Ix9vzUB2p7Bi771E7fiLasnBGtFBJ2WivdETmo1hK3l/O96YhpHrjGApgcbVglLQblp0KW+Qn52cdurj2/VvOCgvNLVElbL/5fVVQ4ZBgHu7fx2oF5ebNTiKGqKNlPyCID5snrD0RnNGf4If+TM2IpN87B31k4TSfltPG9AvtIGzAfsWrKGxZTh7CqRVa/otw24GWQrGGdwmKz3YoM18pvDK+vTJxWhsgUq5VsR9R4N/yIW87dwm5uNgCkUAU2LJlnZ1joaXE27/h/g+0EZnTS1GRlcczbmUJtzG1udvxdpxv6Os9vhhUwYyPsQk0beyG7qgOLld3g7mKKR0G0sDcFM9gxjBn0ipOzKqiFwpNRK/n4U4rKVRuGVtrwhsEIKQzKzqhlzATLGBMe631JSTxhd3lxAwx/69X++huFkRBINqr4kJ3htzJHwW/pheUWPzwM4Y8DUloouyB6p532/bQMKhDZPuwD4nBsAB4vPf4l+eiaCvfjszRaTJVbHujIX/JAQGQQHh9TX6bY7Y8ADtBDWQQsGYRnYqe8wBqMMoonKO0pBhCCbYJz4O4V/pmOv/uAtuzxetfKmt+a9sLNsil0KsQLwGwvWqPo44QMNmGiNih6DAE52t+lLTDjupHwcRYoh7DsQVLEDMClaB2T5TpXD2iqdzNH77G+XfIO7WpjQqo4XTJIJLP6O5QJ/AqgcyGi47M/A/L6gPaNhosfnWNMfnvK3qkpGMfq7J7jEA5cP
 QRSMWeTs
 jfndEcNUoOm+9Pfr1HyvAGVNhYAA1Ts98T1fvBSVv1i+HCpZ7dAL0i6CSe/igmkxoBvS8HlAfdnV/fxq2TtlAOVojKT7sIXfwqVYRldsCtsDAJzyJGbtbICzPZ8u3iPctB3/tQQTXXJa6gRvwBtKzDzAyLvCylvUUMxar795EFfU+Q5WuFVvK8l96xmSRE4HJ9Sla8Ab0iOq0g4lHL51kle0tHwoZJGIGgdbF91bg4KichieJoum58TBrxi3WU3B21ooc/T1vSWgxP/hvwUrOGYcOgjAHCBfznF+6QaGtkU3WlGUxnzFsN8zZ2LSUayjuX53lvv2YOZrh3zamt1xDzsKCVFOT7B0EeseN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 17:47:42 +0000
Shivank Garg <shivankg@amd.com> wrote:

> The dcbm (DMA core batch migrator) provides a generic interface using
> DMAEngine for end-to-end testing of the batch page migration offload
> feature.
> 
> Enable DCBM offload:
> echo 1 > /sys/kernel/dcbm/offloading
> echo NR_DMA_CHAN_TO_USE > /sys/kernel/dcbm/nr_dma_chan
> 
> Disable DCBM offload:
> echo 0 > /sys/kernel/dcbm/offloading
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
Hi Shivank,

Some minor comments inline.

J
> ---
>  drivers/migoffcopy/Kconfig       |   8 +
>  drivers/migoffcopy/Makefile      |   1 +
>  drivers/migoffcopy/dcbm/Makefile |   1 +
>  drivers/migoffcopy/dcbm/dcbm.c   | 415 +++++++++++++++++++++++++++++++
>  4 files changed, 425 insertions(+)
>  create mode 100644 drivers/migoffcopy/dcbm/Makefile
>  create mode 100644 drivers/migoffcopy/dcbm/dcbm.c
> 
> diff --git a/drivers/migoffcopy/Kconfig b/drivers/migoffcopy/Kconfig
> index e73698af3e72..c1b2eff7650d 100644
> --- a/drivers/migoffcopy/Kconfig
> +++ b/drivers/migoffcopy/Kconfig
> @@ -6,4 +6,12 @@ config MTCOPY_CPU
>           Interface MT COPY CPU driver for batch page migration
>           offloading. Say Y if you want to try offloading with
>           MultiThreaded CPU copy APIs.

I'd put a blank line here.

> +config DCBM_DMA
> +       bool "DMA Core Batch Migrator"
> +       depends on OFFC_MIGRATION && DMA_ENGINE
> +       default n

no need to say this. Everything is default n.

> +       help
> +         Interface DMA driver for batch page migration offloading.
> +         Say Y if you want to try offloading with DMAEngine APIs
> +         based driver.

Similar comment on the 'try'

>  
> diff --git a/drivers/migoffcopy/Makefile b/drivers/migoffcopy/Makefile
> index 0a3c356d67e6..dedc86ff54c1 100644
> --- a/drivers/migoffcopy/Makefile
> +++ b/drivers/migoffcopy/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_MTCOPY_CPU) += mtcopy/
> +obj-$(CONFIG_DCBM_DMA)		+= dcbm/
> diff --git a/drivers/migoffcopy/dcbm/Makefile b/drivers/migoffcopy/dcbm/Makefile
> new file mode 100644
> index 000000000000..56ba47cce0f1
> --- /dev/null
> +++ b/drivers/migoffcopy/dcbm/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_DCBM_DMA) += dcbm.o
> diff --git a/drivers/migoffcopy/dcbm/dcbm.c b/drivers/migoffcopy/dcbm/dcbm.c
> new file mode 100644
> index 000000000000..87a58c0c3b9b
> --- /dev/null
> +++ b/drivers/migoffcopy/dcbm/dcbm.c


> +/**
> + * folios_copy_dma - Copy folios using DMA engine
> + * @dst_list: Destination folio list
> + * @src_list: Source folio list
> + * @nr_folios: Number of folios to copy
> + *
> + * Return: 0. Fallback to CPU copy on any error.
> + */
> +static int folios_copy_dma(struct list_head *dst_list,
> +			   struct list_head *src_list,
> +			   unsigned int nr_folios)
> +{
> +	struct dma_work *works;
> +	struct list_head *src_pos = src_list->next;
> +	struct list_head *dst_pos = dst_list->next;
> +	int i, folios_per_chan, ret = 0;
> +	dma_cap_mask_t mask;
> +	int actual_channels = 0;
> +	int max_channels;
> +
> +	max_channels = min3(nr_dma_channels, nr_folios, MAX_DMA_CHANNELS);
> +
> +	works = kcalloc(max_channels, sizeof(*works), GFP_KERNEL);
> +	if (!works)
> +		goto fallback;
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_MEMCPY, mask);
> +
> +	for (i = 0; i < max_channels; i++) {
> +		works[actual_channels].chan = dma_request_chan_by_mask(&mask);
> +		if (IS_ERR(works[actual_channels].chan))
> +			break;
> +		init_completion(&works[actual_channels].done);
> +		actual_channels++;
> +	}
> +
> +	if (actual_channels == 0) {
> +		kfree(works);
> +		goto fallback;
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		folios_per_chan = nr_folios * (i + 1) / actual_channels -
> +					(nr_folios * i) / actual_channels;
> +		if (folios_per_chan == 0)
> +			continue;
> +
> +		ret = setup_sg_tables(&works[i], &src_pos, &dst_pos, folios_per_chan);
> +	if (ret)
> +		goto cleanup;
> +	}

Indent issues here.

> +
> +	for (i = 0; i < actual_channels; i++) {
> +		ret = submit_dma_transfers(&works[i]);
> +		if (ret) {
> +			dev_err(dmaengine_get_dma_device(works[i].chan),
> +				"Failed to submit transfers for channel %d\n", i);
> +			goto cleanup;
> +		}
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		if (atomic_read(&works[i].pending) > 0)
> +			dma_async_issue_pending(works[i].chan);
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		if (atomic_read(&works[i].pending) > 0) {
I'd flip logic to something like.
		if (!atomic_read(&works[i].pending)
			continue;

		if (!wait_for_...

Just to reduce the deep indent.

> +			if (!wait_for_completion_timeout(&works[i].done, msecs_to_jiffies(10000))) {
> +				dev_err(dmaengine_get_dma_device(works[i].chan),
> +					"DMA timeout on channel %d\n", i);
> +				ret = -ETIMEDOUT;
> +				goto cleanup;
> +			}
> +		}
> +	}
> +
> +cleanup:
> +	cleanup_dma_work(works, actual_channels);
> +	if (ret)
> +		goto fallback;

This goto goto dance is probably not worth it.  I'd just duplicate the
cleanup_dma_work() call to have a copy in the error path and one in the non error
path.  Then you just end up with a conventional error block of labels + stuff to do.

> +	return 0;
> +fallback:
> +	/* Fall back to CPU copy */
> +	pr_err("DCBM: Falling back to CPU copy\n");
> +	folios_mc_copy(dst_list, src_list, nr_folios);
> +	return 0;
> +}

> +static ssize_t offloading_store(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	bool enable;
> +	int ret;
> +
> +	ret = kstrtobool(buf, &enable);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&dcbm_mutex);
> +
> +	if (enable == offloading_enabled) {
> +		pr_err("migration offloading is already %s\n",
> +			 enable ? "ON" : "OFF");

To me that's not an error. Pointless, but not worth moaning about.
Just exit saying nothing.

> +		goto out;
> +	}
> +
> +	if (enable) {
> +		start_offloading(&dma_migrator);
> +		offloading_enabled = true;
> +		pr_info("migration offloading is now ON\n");
> +	} else {
> +		stop_offloading();
> +		offloading_enabled = false;
> +		pr_info("migration offloading is now OFF\n");
> +	}
> +out:
> +	mutex_unlock(&dcbm_mutex);

Perhaps guard and direct return above


> +	return count;
> +}

> +static struct kobj_attribute offloading_attr = __ATTR_RW(offloading);
> +static struct kobj_attribute nr_dma_chan_attr = __ATTR_RW(nr_dma_chan);
> +
> +static struct attribute *dcbm_attrs[] = {
> +	&offloading_attr.attr,
> +	&nr_dma_chan_attr.attr,
> +	NULL,
Trivial but doesn't need a trailing comma given this is a terminating entry
and nothing should ever come after it.

> +};
> +ATTRIBUTE_GROUPS(dcbm);
> +
> +static struct kobject *dcbm_kobj;
> +
> +static int __init dcbm_init(void)
> +{
> +	int ret;
> +
> +	dcbm_kobj = kobject_create_and_add("dcbm", kernel_kobj);
> +	if (!dcbm_kobj)
> +		return -ENOMEM;
> +
> +	ret = sysfs_create_groups(dcbm_kobj, dcbm_groups);
Why use a group here and separate files in the CPU thread one?

I'd prefer a group there as well given slightly simpler error
handling as seen here.


> +	if (ret) {
> +		kobject_put(dcbm_kobj);
> +		return ret;
> +	}
> +
> +	pr_info("DMA Core Batch Migrator initialized\n");
> +	return 0;
> +}
> +


