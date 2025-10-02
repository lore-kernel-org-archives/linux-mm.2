Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CCDCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B318E0008; Thu,  2 Oct 2025 07:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB9C8E0002; Thu,  2 Oct 2025 07:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA978E0008; Thu,  2 Oct 2025 07:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 956B28E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:29:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C3F813B0F4
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:29:37 +0000 (UTC)
X-FDA: 83952953994.17.92D958B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id D558FA0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:29:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759404575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2EV1rnXWfWTtwYqp+lyv35rV+m9/NB0XXcKL1NcXtQ=;
	b=qd3fzzR1xTPwJ6prWBKGyVPkJUAbRvSaSpGlERTB1vJnGLd0kxPXX1UjMKtLvuQUsIjsQ9
	YxujTvwA8j8hy28qr0Wc2jvs4ymTO0EKGZaoBKgn4JmM/q12Sk7yGs4mZmIUnLpj5QmFb5
	dXoKH/NhuMhME99+vJXs5UZFTBV5RiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759404575; a=rsa-sha256;
	cv=none;
	b=Qx2+C9NVr8YSenDEQg/NNgw7JRz8X2fT1c5QPqN8FYNdYp9pGDMg7W/CNOeUaAESTGvEMA
	kfnNTv2f4JEOg6wGtQmyDH/UGNKKF5wy/hhIaTl6dbNyAZrzQgaahu/muy/4eMUW6fBcGM
	N7GE7aXxm9sJRyqQkorzdifAdP6sWgQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccqHc6cckz67FbS;
	Thu,  2 Oct 2025 19:26:20 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id ABDE7140144;
	Thu,  2 Oct 2025 19:29:30 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 12:29:28 +0100
Date: Thu, 2 Oct 2025 12:29:27 +0100
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
Subject: Re: [RFC V3 6/9] mtcopy: introduce multi-threaded page copy routine
Message-ID: <20251002122927.000039e5@huawei.com>
In-Reply-To: <20250923174752.35701-7-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
	<20250923174752.35701-7-shivankg@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: D558FA0004
X-Stat-Signature: 9ryahnutorc8bbr88bxat4otzqqat1wg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759404574-771131
X-HE-Meta: U2FsdGVkX1/X6stU1/lJJ7y+2nQZXmbMB8KMq6SooWZ3t1PFp5c+UZ1QmEBccyZX5zcsQfTs2YYe/jzBg7pu/D7kAHlHGbFh9tz4XSJpC7oKk+gsmSzjBXqJlYhEpON5bdqAF97Tl5WVX+39hXza5C5MSsVUix2qNFIVC+tCJPdAG/FksivT9WvuFmpTmEZ7Zumd06zvDytqK4um2dOst+ILnhjVblfzck/JGQb7Q753XIv7880uOzZH1EcVM+Zn1ONAH4LhknFTbMX2mcItRKGNXOMJmFcd1q8+DZtnqaEAShAbRE/FXyW44BNMHN97/MvYB/33X9/ZZ8UgYmlH+K5zNBph34yalS06ZcKzqASYt9G0MgrC4/hJVmZ9THxRO2M9f4vZE+ly6s+zl1T1iydJVy7Bjj/60UhWHxQqBMq90hz/QDLKyMBRRLzi1DZy3OcCQ2PqjOxscL2lOohginl/d6A8G9nnq55tHNfJFYIpTufRswz097e0VU8pxEysrkroamC/4jJ4sP2L9+wlXtfi1jYhyBRBudD2x92DyweheUGoXnymtCazJLy/zeLFkbVxeQU6LDb4+Dcb92/OizcpMNj2h2nju7CD8L/gGw7BQTRuljtBMG5W/r+N/Z7bJm/uSjXccW9Xkdf21CRIblHxVEI4/4kelSukqr/Q1THVD6VM8JZYGJ46axuNcOWjPoIpvrORQ4//UWsjZwASv88w8isp/V2XEYOVbhyS4lxl/kbOEEr8YfqTQ7zYFgJMsDUr3NPkNb57sUNd7g0WZGP4fGcCokxODq+3RSFg0yWtcXR3fIG/lzb1aOw62APcp5t6Kz6KZk2SQaVq5cyNCVLXiG/i0b0MN9UiQ8+PbCTbHkKJK9wLGH9DBOqBSGqRI8r//dZhYa7B2/RFp1HS+wVmzmnE5tmNs9VCXfes9KLsdvxMvY9Ri768IiRZfXmD+1RFtWp/6qq//AaEJKT
 FiVpuerB
 St1ZDCocK3vONwReDwY4hvQ09bCg0pXg2SnaeCJA8XKLBVDza9Q1Nx0TgOYvAcl6KOr+fwgb7j6tbjsKQMto88JqrnYh3+8CWkVEeuzVZlDN6sqHUZzW2WXrpt7Ykzc5SD8spZqKTLAGNy4Sd2xest8AbvO0x2vj2/OPORdUbd9oxi0c5a0zWLRa/AlQCFPpcLA0+wr1K8PPu7hYntc9hoKKrmRxscVHC2nkx8yb+zol0WBR2HyRQwr2xpeUVGsccdAAFw7+3jkb57H5OoII/zuDPlWdYNH3hPQiO1tXBWeYQSV2WdiZig+939g1Aex8Xu47dGHhzThDhYp6QEcqd/JWeRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 17:47:41 +0000
Shivank Garg <shivankg@amd.com> wrote:

> From: Zi Yan <ziy@nvidia.com>
> 
> Now page copies are batched, multi-threaded page copy can be used to
> increase page copy throughput.
> 
> Enable using:
> echo 1 >  /sys/kernel/cpu_mt/offloading
> echo NR_THREADS >  /sys/kernel/cpu_mt/threads

I guess this order is to show that you can update threads with it on
as system load changes.

Maybe call this out explicitly?

> 
> Disable:
> echo 0 >  /sys/kernel/cpu_mt/offloading
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Co-developed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Various other things inline.

Thanks,

Jonathan

> diff --git a/drivers/migoffcopy/Kconfig b/drivers/migoffcopy/Kconfig
> new file mode 100644
> index 000000000000..e73698af3e72
> --- /dev/null
> +++ b/drivers/migoffcopy/Kconfig
> @@ -0,0 +1,9 @@
> +config MTCOPY_CPU
> +       bool "Multi-Threaded Copy with CPU"
> +       depends on OFFC_MIGRATION
> +       default n
> +       help
> +         Interface MT COPY CPU driver for batch page migration
> +         offloading. Say Y if you want to try offloading with
> +         MultiThreaded CPU copy APIs.
Try?  I'd be more positive in the help text :)

> +

> diff --git a/drivers/migoffcopy/mtcopy/copy_pages.c b/drivers/migoffcopy/mtcopy/copy_pages.c
> new file mode 100644
> index 000000000000..68e50de602d6
> --- /dev/null
> +++ b/drivers/migoffcopy/mtcopy/copy_pages.c
> @@ -0,0 +1,327 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Parallel page copy routine.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
Generally we are trying to get away from anything including kernel.h
directly.  There is relatively little still in there, so maybe check
you actually need it here.

> +#include <linux/printk.h>
> +#include <linux/init.h>
> +#include <linux/sysctl.h>
> +#include <linux/sysfs.h>
> +#include <linux/highmem.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +#include <linux/migrate.h>
> +#include <linux/migrate_offc.h>
> +
> +#define MAX_NUM_COPY_THREADS 64
Add a comment on why this number.

> +
> +struct copy_page_info {
> +	struct work_struct copy_page_work;
> +	int ret;
> +	unsigned long num_items;
> +	struct copy_item item_list[];
__counted_by

> +};
> +
> +static unsigned long copy_page_routine(char *vto, char *vfrom,
> +	unsigned long chunk_size)
> +{
> +	return copy_mc_to_kernel(vto, vfrom, chunk_size);
> +}
> +
> +static void copy_page_work_queue_thread(struct work_struct *work)
> +{
> +	struct copy_page_info *my_work = (struct copy_page_info *)work;

container_of()

> +	int i;
> +
> +	my_work->ret = 0;
> +	for (i = 0; i < my_work->num_items; ++i)
> +		my_work->ret |= !!copy_page_routine(my_work->item_list[i].to,
> +					my_work->item_list[i].from,
> +					my_work->item_list[i].chunk_size);
> +}
> +
> +static ssize_t mt_offloading_set(struct kobject *kobj, struct kobj_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	int ccode;
> +	int action;
> +
> +	ccode = kstrtoint(buf, 0, &action);
> +	if (ccode) {
> +		pr_debug("(%s:) error parsing input %s\n", __func__, buf);
> +		return ccode;
> +	}
> +
> +	/*
> +	 * action is 0: User wants to disable MT offloading.
> +	 * action is 1: User wants to enable MT offloading.
> +	 */
> +	switch (action) {
> +	case 0:
> +		mutex_lock(&migratecfg_mutex);
> +		if (is_dispatching == 1) {
> +			stop_offloading();
> +			is_dispatching = 0;
> +		} else
> +			pr_debug("MT migration offloading is already OFF\n");
> +		mutex_unlock(&migratecfg_mutex);
> +		break;
> +	case 1:
> +		mutex_lock(&migratecfg_mutex);
> +		if (is_dispatching == 0) {
> +			start_offloading(&cpu_migrator);
> +			is_dispatching = 1;
> +		} else
> +			pr_debug("MT migration offloading is already ON\n");
> +		mutex_unlock(&migratecfg_mutex);
> +		break;
> +	default:
> +		pr_debug("input should be zero or one, parsed as %d\n", action);
> +	}
> +	return sizeof(action);
> +}
> +
> +static ssize_t mt_offloading_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%d\n", is_dispatching);
> +}
> +
> +static ssize_t mt_threads_set(struct kobject *kobj, struct kobj_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	int ccode;
> +	unsigned int threads;
> +
> +	ccode = kstrtouint(buf, 0, &threads);
> +	if (ccode) {
> +		pr_debug("(%s:) error parsing input %s\n", __func__, buf);

I'm fairly sure you can use dynamic debug here to add the __func__ so no need
to do it by hand.

> +		return ccode;
> +	}
> +
> +	if (threads > 0 && threads <= MAX_NUM_COPY_THREADS) {
> +		mutex_lock(&migratecfg_mutex);
> +		limit_mt_num = threads;
> +		mutex_unlock(&migratecfg_mutex);
> +		pr_debug("MT threads set to %u\n", limit_mt_num);
> +	} else {

I'd flip the logic to test first for in range and exit if not. Then
no indent on the good path.

> +		pr_debug("Invalid thread count. Must be between 1 and %d\n", MAX_NUM_COPY_THREADS);
> +		return -EINVAL;
> +	}
> +
> +	return count;
> +}

> +int copy_page_lists_mt(struct list_head *dst_folios,
> +		struct list_head *src_folios, unsigned int nr_items)
> +{
> +	struct copy_page_info *work_items[MAX_NUM_COPY_THREADS] = {0};

{} or { NULL } perhaps given it's an array of pointers.

> +	unsigned int total_mt_num = limit_mt_num;
> +	struct folio *src, *src2, *dst, *dst2;
> +	int max_items_per_thread;
> +	int item_idx;
> +	int err = 0;
> +	int cpu;
> +	int i;
> +
> +	if (IS_ENABLED(CONFIG_HIGHMEM))
> +		return -EOPNOTSUPP;
> +
> +	/* Each threads get part of each page, if nr_items < totla_mt_num */
Each thread gets part of each page

total_mt_num  Though isn't the comment talking about when it's greater than or equal?


> +	if (nr_items < total_mt_num)
> +		max_items_per_thread = nr_items;
> +	else
> +		max_items_per_thread = (nr_items / total_mt_num) +
> +				((nr_items % total_mt_num) ? 1 : 0);
> +
> +
> +	for (cpu = 0; cpu < total_mt_num; ++cpu) {
> +		work_items[cpu] = kzalloc(sizeof(struct copy_page_info) +
> +						sizeof(struct copy_item) *
> +							max_items_per_thread,

struct_size() looks appropriate here.

> +					  GFP_NOWAIT);
> +		if (!work_items[cpu]) {
> +			err = -ENOMEM;
> +			goto free_work_items;
> +		}
> +	}
> +
> +	if (nr_items < total_mt_num) {
> +		for (cpu = 0; cpu < total_mt_num; ++cpu) {
> +			INIT_WORK((struct work_struct *)work_items[cpu],
Why not avoid having to know it is at start of structure by using
work_items[cpu]->copy_page_work instead.

> +					  copy_page_work_queue_thread);
> +			work_items[cpu]->num_items = max_items_per_thread;
> +		}
> +
> +		item_idx = 0;
> +		dst = list_first_entry(dst_folios, struct folio, lru);
> +		dst2 = list_next_entry(dst, lru);
> +		list_for_each_entry_safe(src, src2, src_folios, lru) {
> +			unsigned long chunk_size = PAGE_SIZE * folio_nr_pages(src) / total_mt_num;
> +			char *vfrom = page_address(&src->page);
> +			char *vto = page_address(&dst->page);
> +
> +			VM_WARN_ON(PAGE_SIZE * folio_nr_pages(src) % total_mt_num);
> +			VM_WARN_ON(folio_nr_pages(dst) != folio_nr_pages(src));
> +
> +			for (cpu = 0; cpu < total_mt_num; ++cpu) {
> +				work_items[cpu]->item_list[item_idx].to =
> +					vto + chunk_size * cpu;
> +				work_items[cpu]->item_list[item_idx].from =
> +					vfrom + chunk_size * cpu;
> +				work_items[cpu]->item_list[item_idx].chunk_size =
> +					chunk_size;
> +			}
> +
> +			item_idx++;
> +			dst = dst2;
> +			dst2 = list_next_entry(dst, lru);
> +		}
> +
> +		for (cpu = 0; cpu < total_mt_num; ++cpu)
> +			queue_work(system_unbound_wq,
> +				   (struct work_struct *)work_items[cpu]);

As above. If you want the work struct, using the member that is the right type.

> +	} else {
> +		int num_xfer_per_thread = nr_items / total_mt_num;
> +		int per_cpu_item_idx;
> +
> +
> +		for (cpu = 0; cpu < total_mt_num; ++cpu) {
> +			INIT_WORK((struct work_struct *)work_items[cpu],

Same again.

> +					  copy_page_work_queue_thread);
> +
> +			work_items[cpu]->num_items = num_xfer_per_thread +
> +					(cpu < (nr_items % total_mt_num));
> +		}
> +
> +		cpu = 0;
> +		per_cpu_item_idx = 0;
> +		item_idx = 0;
> +		dst = list_first_entry(dst_folios, struct folio, lru);
> +		dst2 = list_next_entry(dst, lru);
> +		list_for_each_entry_safe(src, src2, src_folios, lru) {
> +			work_items[cpu]->item_list[per_cpu_item_idx].to =
> +				page_address(&dst->page);
> +			work_items[cpu]->item_list[per_cpu_item_idx].from =
> +				page_address(&src->page);
> +			work_items[cpu]->item_list[per_cpu_item_idx].chunk_size =
> +				PAGE_SIZE * folio_nr_pages(src);
> +
> +			VM_WARN_ON(folio_nr_pages(dst) !=
> +				   folio_nr_pages(src));
> +
> +			per_cpu_item_idx++;
> +			item_idx++;
> +			dst = dst2;
> +			dst2 = list_next_entry(dst, lru);
> +
> +			if (per_cpu_item_idx == work_items[cpu]->num_items) {
> +				queue_work(system_unbound_wq,
> +					(struct work_struct *)work_items[cpu]);
and one more.
> +				per_cpu_item_idx = 0;
> +				cpu++;
> +			}
> +		}
> +		if (item_idx != nr_items)
> +			pr_warn("%s: only %d out of %d pages are transferred\n",
> +				__func__, item_idx - 1, nr_items);
> +	}
> +
> +	/* Wait until it finishes  */
> +	for (i = 0; i < total_mt_num; ++i) {
> +		flush_work((struct work_struct *)work_items[i]);
> +		/* retry if any copy fails */
> +		if (work_items[i]->ret)
> +			err = -EAGAIN;
> +	}
> +
> +free_work_items:
> +	for (cpu = 0; cpu < total_mt_num; ++cpu)
> +		kfree(work_items[cpu]);
> +
> +	return err;
> +}
> +
> +static struct kobject *mt_kobj_ref;
> +static struct kobj_attribute mt_offloading_attribute = __ATTR(offloading, 0664,
> +		mt_offloading_show, mt_offloading_set);
> +static struct kobj_attribute mt_threads_attribute = __ATTR(threads, 0664,
> +		mt_threads_show, mt_threads_set);
> +
> +static int __init cpu_mt_module_init(void)
> +{
> +	int ret = 0;

Always set before use so don't init here.

> +
> +	mt_kobj_ref = kobject_create_and_add("cpu_mt", kernel_kobj);
> +	if (!mt_kobj_ref)
> +		return -ENOMEM;
> +
> +	ret = sysfs_create_file(mt_kobj_ref, &mt_offloading_attribute.attr);
> +	if (ret)
> +		goto out_offloading;
> +
> +	ret = sysfs_create_file(mt_kobj_ref, &mt_threads_attribute.attr);
> +	if (ret)
> +		goto out_threads;
> +
> +	is_dispatching = 0;
> +
> +	return 0;
> +
> +out_threads:
> +	sysfs_remove_file(mt_kobj_ref, &mt_offloading_attribute.attr);
> +out_offloading:
> +	kobject_put(mt_kobj_ref);
> +	return ret;
> +}

> +module_init(cpu_mt_module_init);
> +module_exit(cpu_mt_module_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Zi Yan");
> +MODULE_DESCRIPTION("CPU_MT_COPY"); /* CPU Multithreaded Batch Migrator */

If a module description needs a comment after it I'd rewrite that description!



