Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A64CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FDE28E0007; Fri,  3 Oct 2025 06:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE668E0001; Fri,  3 Oct 2025 06:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CE78E0007; Fri,  3 Oct 2025 06:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F65D8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:25:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5F0C8785E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:25:51 +0000 (UTC)
X-FDA: 83956422102.21.6E682D4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id A39F7C0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:25:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759487148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amWrx0tqh+QJ5PKOthKw0iwwlZ3ZY7Ri8UXGRdhLqt4=;
	b=XN9DyD6YhSyM26YATLAyGWRRTSRWe+E9D4Qkmp0mdFvHbUKhx0kSLTxz5EPlDWL68eEFHV
	fShnlfYAxbbvwb2+rB5oEwca2zZBPesmlAFar7CPYYZ9EmZcBrstG0SkNXlbfAc42oRROf
	WaxAkvvf5xpwaUF1YU+His85C/5FbAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759487148; a=rsa-sha256;
	cv=none;
	b=6FT4BJkzrmYpldH1VHswpZvN60pnvEiCiTj3s1xsfi3YaUMp5GFIwV4QuRNjt/2HfX+8s4
	ysE/MLn1TJJBDCi5QMVvw4meagUNlqP05+uR3fJ0rqzTzUtf/aZRtMMoLxBoJFSqawYzZX
	mQlOHsZMsNwVFkXhmq/DAW7fAlo8Cp4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdPtn18BNz6L4wF;
	Fri,  3 Oct 2025 18:25:21 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 635E11402F6;
	Fri,  3 Oct 2025 18:25:44 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 11:25:42 +0100
Date: Fri, 3 Oct 2025 11:25:40 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <yuanchu@google.com>,
	<kinseyho@google.com>, <hdanton@sina.com>, <harry.yoo@oracle.com>
Subject: Re: [RFC PATCH V3 12/17] sysfs: Add sysfs support to tune scanning
Message-ID: <20251003112540.00002cf7@huawei.com>
In-Reply-To: <20250814153307.1553061-13-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-13-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: A39F7C0005
X-Stat-Signature: xxunc9znawfhdagejtodk5suazrbmamw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759487147-190620
X-HE-Meta: U2FsdGVkX1/9zJFZbh1UEoENCCyrf0mvnSqIbuE/gRyOAWD47/YW1SxQAMhySDn6LNrKVC4Ug5M1MpEiu3VQO/Avfi6assIvmdBzzP9HYMuuK9PwG/6zmTqVL15lAAqoh0kZCUHHQQhPgFLWHvi2pyo0NwaG9mLUIgCKv1Bpy8tSkgXLA0O7CYCkitJYjUdgR8KhKNdZDrCqkRiGN8PZK4a6+G3jVIaYl/PZCUfpOv0sMoluEIHoqoDyZJOe7kv0wLAAyuBTmmlV10lko7PtatlvpaLZdrCzCE/FMkjqPSevXzDnGMveX0zD2XLUZRUGYl97ILN6SrpnP0RHHrAXGVxirqUTdmkW54NKlqCPo6mOxnRwd4TwDdc2ZOVMxRSukRV1MzuCZEyXVBr4RJqUL7zrSegi7pC1njoj/mB/l37MX80dKxMdf06V4Xm2TC2qaNkoLUJKLFYc/PhKRB9kab8Y+x58SQfW9yeYeaIb+w1xO3N5NJlqhbLDaAW/xi4hdgPpn/iEU0/YWI/GBMUQ64FX9QAF+6NdFPcNvpTbWJZdZbnFiuPeQJCIlPOSoQ7RBTylWR04pp2PkrwDGJOWC5YoD76kmkn/hbxY18nzGi4pO6fCNZr0SAN+FMUh94V30+g04ueR2v/467pJwOBYMP+JCC+YX297AJuwUpUwTLWtBxV0jUgMMPUAwhOGjTid2mnW6HaKgybuVfFPXn1cX7oqfTyRvKIlXnT+3+My869irqwQd/mLLU9mqYahveXxbK+hEcD10y2joA5jpN+FedV2w9Pbn4f3x5SpqYHUS+d563mMspclPTg/r3y4fVNyyGZamjCo6rPh4T3NPA3Vt/yu1xU057UYyp2AkKvuXcHPmrtcIaLbi9PbdSnXv0W7/jt+RHMJyqEIyCf/s0mY1zluVXraOGKWAPbkXqUojwFe+rv1HS3ViFQbc01eEnOFKtcctqD7J0tIJTpA2a6
 mJ6XsAL5
 lqPnnOmg46hnPikxqiFl5EDIM/YxQC7Cljzd1AoqY/uqSaheXeF8BjLiMFl9h1pcPPD8TmM+a4QE5740h2NIdmihgI29VaC2InS2EIWPIxmBArDOI0Ew45jS92joRm2PUe8lNmTA+1Q9NR6rESPocw//de9fB8c9uAtDv1hpDTgCm99ZC4DhqnlZgyd+dSVJZoRgY2AiZiqE/qv+MUQjh1Ls+1Fb3ku3oCfH75QWsYi4CfLJqvIfeyUt30pVi0awKrOQjbmQ5vumVeDgWyqQ7clIH87TlbFNWpH4eHC6XoG+mZ93HNS/E2xv5b0MIjhjxexo7ABde6Buz26qP6iJHRAk9bLgwL5XfxKbW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:33:02 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Support below tunables:
> scan_enable: turn on or turn off mm_struct scanning
> scan_period: initial scan_period (default: 2sec)
> scan_sleep_ms: sleep time between two successive round of scanning and
> migration.
> mms_to_scan: total mm_struct to scan before taking a pause.
> target_node: default regular node to which migration of accessed pages
> is done (this is only fall back mechnism, otherwise target_node
> heuristic is used).
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

I'd suggest writing
Documentation/ABI/testing/sysfs-...
doc for this as you'll need it in the end and it tends to be easier to review
a doc for this stuff than the code + figuring out where the entrees end up.

Various comments inline.

J
> ---
>  mm/kscand.c | 205 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 205 insertions(+)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index 41321d373be7..a73606f7ca3c 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -21,6 +21,7 @@
>  #include <linux/delay.h>
>  #include <linux/cleanup.h>
>  #include <linux/minmax.h>
> +#include <trace/events/kmem.h>
>  
>  #include <asm/pgalloc.h>
>  #include "internal.h"
> @@ -173,6 +174,171 @@ static bool kscand_eligible_srcnid(int nid)
>  	return  !node_is_toptier(nid);
>  }
>  
> +#ifdef CONFIG_SYSFS

See below. Should not be necessary - the compiler should be able to
see these are unused after it squashes the stubs for sysfs calls
in and hence remove this for us.


> +
> +static struct kobj_attribute scan_sleep_ms_attr =
> +	__ATTR_RW(scan_sleep_ms);

Fits on one line under 80 chars.

> +
> +static ssize_t mm_scan_period_ms_show(struct kobject *kobj,
> +					 struct kobj_attribute *attr,
> +					 char *buf)
> +{
> +	return sysfs_emit(buf, "%u\n", kscand_mm_scan_period_ms);
> +}


> +
> +static struct kobj_attribute mms_to_scan_attr =
> +	__ATTR_RW(mms_to_scan);

Fits on one line.

> +
> +static ssize_t scan_enabled_show(struct kobject *kobj,
> +					 struct kobj_attribute *attr,
> +					 char *buf)

Odd indent.

> +{
> +	return sysfs_emit(buf, "%u\n", kscand_scan_enabled ? 1 : 0);
> +}
> +
> +static ssize_t scan_enabled_store(struct kobject *kobj,
> +					  struct kobj_attribute *attr,
> +					  const char *buf, size_t count)

Another odd looking indent.

> +{
> +	unsigned int val;
> +	int err;
> +
> +	err = kstrtouint(buf, 10, &val);

Maybe use kstrtobool

> +	if (err || val > 1)
> +		return -EINVAL;
> +
> +	if (val) {
> +		kscand_scan_enabled = true;
> +		need_wakeup = true;
> +	} else
> +		kscand_scan_enabled = false;
> +
> +	kscand_sleep_expire = 0;
> +	wake_up_interruptible(&kscand_wait);
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute scan_enabled_attr =
> +	__ATTR_RW(scan_enabled);
One line.

> +

> +}
> +static struct kobj_attribute target_node_attr =
> +	__ATTR_RW(target_node);
One line.
> +
> +static struct attribute *kscand_attr[] = {
> +	&scan_sleep_ms_attr.attr,
> +	&mm_scan_period_ms_attr.attr,
> +	&mms_to_scan_attr.attr,
> +	&scan_enabled_attr.attr,
> +	&target_node_attr.attr,
> +	NULL,

No comma for terminating entries as we don't want to add anything
after this.

> +};
> +
> +struct attribute_group kscand_attr_group = {
> +	.attrs = kscand_attr,
> +	.name = "kscand",
> +};
> +#endif
> +
>  static inline int kscand_has_work(void)
>  {
>  	return !list_empty(&kscand_scan.mm_head);
> @@ -1231,11 +1397,45 @@ static int kscand(void *none)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SYSFS

The functions used have stubs in sysfs.h so no need
to make these conditional on CONFIG_SYSFS.

Let the compilers dead code removal get rid of the structures
above etc as well.

> +extern struct kobject *mm_kobj;
> +static int __init kscand_init_sysfs(struct kobject **kobj)
> +{
> +	int err;
> +
> +	err = sysfs_create_group(*kobj, &kscand_attr_group);
> +	if (err) {
> +		pr_err("failed to register kscand group\n");
> +		goto err_kscand_attr;
> +	}
> +
> +	return 0;
> +
> +err_kscand_attr:
If create group failed, you shouldn't have anything to remove.



> +	sysfs_remove_group(*kobj, &kscand_attr_group);
> +	return err;
> +}
> +
> +static void __init kscand_exit_sysfs(struct kobject *kobj)
> +{
> +		sysfs_remove_group(kobj, &kscand_attr_group);

Odd indent.

> +}
> +#else
> +static inline int __init kscand_init_sysfs(struct kobject **kobj)
> +{
> +	return 0;
> +}
> +static inline void __init kscand_exit_sysfs(struct kobject *kobj)
> +{
> +}
> +#endif
> +
>  static inline void kscand_destroy(void)
>  {
>  	kmem_cache_destroy(kscand_slot_cache);
>  	/* XXX: move below to kmigrated thread */
>  	kmem_cache_destroy(kmigrated_slot_cache);
> +	kscand_exit_sysfs(mm_kobj);

As it's separate setup step, I'd expect to see this called directly
in error paths in kscand_init() rather than via this helper function.
That way it is easy to see it is only called in paths where it is
appropriate.


>  }
>  
>  void __kscand_enter(struct mm_struct *mm)
> @@ -1421,6 +1621,10 @@ static int __init kscand_init(void)
>  		return -ENOMEM;
>  	}
>  
> +	err = kscand_init_sysfs(&mm_kobj);
> +	if (err)
> +		goto err_init_sysfs;
> +
>  	init_list();
>  	err = start_kscand();
>  	if (err)
> @@ -1437,6 +1641,7 @@ static int __init kscand_init(void)
>  
>  err_kscand:
>  	stop_kscand();
> +err_init_sysfs:
>  	kscand_destroy();
>  
>  	return err;


