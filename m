Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894EE105A583
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70A06B009D; Thu, 12 Mar 2026 07:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E8E6B00A0; Thu, 12 Mar 2026 07:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF376B00A3; Thu, 12 Mar 2026 07:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFDDA6B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:58:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FFAD13980D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:58:36 +0000 (UTC)
X-FDA: 84537263832.14.3793252
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2844080003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:58:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773316714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nnIwCYUJChNcMySFgVyXm0h+G4mEZ4yM0cRAOBZ5zuU=;
	b=74PNoRt7qYsySc/PYTBczxy/YckuYDLwnT9cYvX/Eg4cCrsXSDSiuohv9p/MFtr0Y/j+fJ
	x/sJWRH+F18+l0IATdy1PzU+zNCtmoR6OlSTXtkFfp0zJUxPuhhbQIfNf2f6olbLq/wOzK
	eZlPpPxIgUkCCXsjMnSMnNuPgJhJHNs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773316714; a=rsa-sha256;
	cv=none;
	b=FSPhoz+lk15flBJVVGlCidrE9tRHZB2iDaTUjprGyUHtIdNnbDOgIi7lH6HyRPmIKQOVao
	KEIGu/NZNOPsUY8Mgx66K/8q32fZ5fD2ogd/soWeLddkcpo1fkCsLouNp7cBlOaVfzeDcK
	dzvrAuvuRLyVqDDCZHl3tmtdRBEKFmg=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWmMS0frCzJ46jf;
	Thu, 12 Mar 2026 19:57:40 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id DFB3C4056E;
	Thu, 12 Mar 2026 19:58:27 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 12 Mar
 2026 11:58:27 +0000
Date: Thu, 12 Mar 2026 11:58:25 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: YeeLi <seven.yi.lee@gmail.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<dan.j.williams@intel.com>, <ying.huang@linux.alibaba.com>,
	<linux-mm@kvack.org>, <joshua.hahnjy@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
Message-ID: <20260312115825.000045af@huawei.com>
In-Reply-To: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Stat-Signature: 3jxfgqa5fogg5hwqws7oeiro7otw9pyn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2844080003
X-HE-Tag: 1773316713-531880
X-HE-Meta: U2FsdGVkX18bYYMl2iuzV7237FXNgPEObjjVNEfapq2pf8Xuu4evyI9tRpAq2Fl/eOd+4hpSr9hRC0ToaI/b1xPtlX2FvKhPx+uwRtlOq2kUWCZHVAxiS8LmlJTOUabbl/Y6I527DqtHlUm1p5YUtEySQn14qs1gbYOBqZ6b/6KHa3MvCS4KrtKvNJDPINJSWlH79Fq/5pBqeNk3EfSejcV7WLRAzgAlw0To4d1btKBBUndFC7OgD7gQ4m0nkyG9wIqkBwWGq5wBWq6Jo2l/MLYoMV6oq/2ymu8H8HPRMoE15Yt+BmYtD+tkNiD8UK3Os6u6NKU/sVz/Tsy6JAPRnEGuAY0xOWywPPr/g487I6XHReIbJmZiX6B7aItdQaGuuAH000jJ7qJaKj6HRDZz92rEMs6AWp6i2ffMvcGEOzNVXVVokAdv5j1ND2T1mywSFQmV1ZvAfT0T/SMdzQI7r8HrDrqUHHMe8W6cqXAJmBxDwbuRyWhu/tmO8yPbF5g6eqAdjdKYWbclAzoLFniYxcuCzXfpMAqWldT2JObrNCgAA6v3anKH38FOt1TLw2cV+YNhcvKDHiCH6gVr2H+qiGMCZG5STYyfxKoFRICHU3yXrA+x0LWLknx1HvGW30+NrgNSAK2topYsFZHnmTyjYC0BN4tmK559Q4A0bn0wv5jmVaJoLZZpoHtXah7/P8aIk93MCanq9p96Hwlsba0OXpOi+9qVPnbFbJB+gMdCQwwi6afA0i8BG1TcTlAz9F14lfVWwGJGdNYk/iFQTaRjmpQ0VvNrakaQY78RIfEbClGNqlV5eo2IklZaaUbPpZ8GpjiQUDAQkyC5xqmJW9HEzLmCnYNzngMhXdNmmEcRDrUcLjgVbL2gXBQ7LKLG3Gd2+WoncJtl1X7g1IlfuieqjjVDVm5Cm3DuWZNRK5YKjI9hLdRmj36YtZAjmUbYQQD73vpIXDSsz6e6bkBjrR+
 xmXb9IT2
 FhVznP8kLblcWTWYwNzbTrPpclH2h7PhgOVcN7ZLq9ncTeAjfxwc1INq/2otDsDxP5ud9XCC0LxUIyvDNv8XDsp/FKBLlfnjrSL+O0xyplxqqBlysfiKtSDwwkNM2exK++kGvZzc19v/FDopws8RMpRU2w85KLGC3InS4JnInMZGLdRfMc3jKe/bq+O7nTGoXHj6NDreTFqe2G5bfATCclVpABO7cwaJt4mNl69q2cEbjcIxTcZxRLi7ZlsQw1RMxueTG/LyMxzoSGYSI5+E24AN6L4OVWwssdafrEn7w+8Ez0L8/uPKu0Id9/80U45rpBI5a/9KPLhakT3G0axMyNpq8fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:12:07 +0800
YeeLi <seven.yi.lee@gmail.com> wrote:

> From: yeeli <seven.yi.lee@gmail.com>
>=20
> Automatic tuning for weighted interleaving [1] provides real benefits on
> systems with CXL support. However, platforms that lack HMAT or CDAT
> information cannot make use of this feature.
>=20
> If the bandwidth reported by firmware or the device deviates from the
> actual measured bandwidth, administrators also lack a clear way to adjust
> the per-node weight values.
>=20
> This patch introduces an optional Kconfig option,
> CONFIG_NUMA_BW_MANUAL_OVERRIDE (default n), which exposes node bandwidth
> R/W sysfs attributes under:
>=20
>   /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN
>=20
> The sysfs files are created and removed dynamically on node hotplug
> events, in sync with the existing weighted_interleave/nodeN attributes.
>=20
> Userspace can write a single bandwidth value (in MB/s) to override both
> read_bandwidth and write_bandwidth for the corresponding NUMA node. The
> value is then propagated to the internal node_bw_table via
> mempolicy_set_node_perf().
>=20
> This interface is intended for debugging and experimentation only.
>=20
> [1] Link:
> https://lkml.kernel.org/r/20250505182328.4148265-1-joshua.hahnjy@gmail.com
>=20
> Signed-off-by: yeeli <seven.yi.lee@gmail.com>

As I note below, I'm not convinced this is the best layer to be injecting
data at if we want a debug interface that allows us to reflect real
hardware.  Might be the sort of patch that is useful outside the tree though
so thanks for sharing it!

> ---
>  mm/Kconfig     |  20 +++++++
>  mm/mempolicy.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 168 insertions(+)
>=20
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af8..40554df18edc 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1441,6 +1441,26 @@ config NUMA_EMU
>  	  into virtual nodes when booted with "numa=3Dfake=3DN", where N is the
>  	  number of nodes. This is only useful for debugging.
> =20
> +config NUMA_BW_MANUAL_OVERRIDE
> +	bool "Allow manual override of per-NUMA-node bandwidth for weighted int=
erleave"
> +	depends on NUMA && SYSFS
> +	default n

Drop this. Everything is default n (by default!)

> +	help
> +	  This option exposes writable sysfs attributes under
> +	  /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN, allowing
> +	  userspace to manually set read/write bandwidth values for each NUMA n=
ode.
> +
> +	  These values update the internal node_bw_table and can influence
> +	  weighted interleave auto-tuning (if enabled).
> +
> +	  WARNING: This is intended for debugging, development, or platforms
> +	  with incorrect HMAT/CDAT firmware data. Overriding hardware-reported
> +	  bandwidth can lead to suboptimal performance, instability, or
> +	  incorrect resource allocation decisions.

If it was an SRAT (for GPs) / HMAT issue I'd suggest table injection is
an adequate way to do testing and debug.

CDAT is trickier, but maybe we should be thinking about a debug path to inj=
ect
that as well - similar to what we do for ACPI tables.

=46rom my point of view I'd rather see debug / testing interfaces that test t=
he
whole flow rather than just this top layer control.

However, I can see this is a useful patch for developers. But if you
are developing debugging bandwidth-aware memory policies, I'm going to assu=
me
you don't mind building a kernel and adding this patch to make your life
easier!

So to me, useful tool but I'm not 'yet' convinced it should be upstream.

> +
> +	  Say N unless you are actively developing or debugging bandwidth-aware
> +	  memory policies.
> +
>  config ARCH_HAS_USER_SHADOW_STACK
>  	bool
>  	help
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..0b7f42491748 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -226,6 +226,7 @@ int mempolicy_set_node_perf(unsigned int node, struct=
 access_coordinate *coords)
> =20
>  	bw_val =3D min(coords->read_bandwidth, coords->write_bandwidth);
>  	new_bw =3D kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
> +

Stray change.  Always check for these bnefore posting as they slow down
patch sets for no good reason.

>  	if (!new_bw)
>  		return -ENOMEM;
> =20
> @@ -3614,6 +3615,9 @@ struct iw_node_attr {
>  struct sysfs_wi_group {
>  	struct kobject wi_kobj;
>  	struct mutex kobj_lock;
> +#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
> +	struct iw_node_attr *bw_attrs[MAX_NUMNODES];

Ok. It's debug so I guess this is ok rather than what is
done for nattrs with nr_node_ids.
Alternative would be a pointer and a separate allocation.


> +#endif
>  	struct iw_node_attr *nattrs[];
>  };
> =20
> @@ -3855,6 +3859,128 @@ static int sysfs_wi_node_add(int nid)
>  	return ret;
>  }
> =20
> +#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
> +static ssize_t bw_node_show(struct kobject *kobj,
> +			    struct kobj_attribute *attr,
> +			    char *buf)
Can fit on fewer lines without going past 80 chars.

> +{
> +	struct iw_node_attr *node_attr;
> +
> +	node_attr =3D container_of(attr, struct iw_node_attr, kobj_attr);
> +
> +	/*A Node without CDAT or HMAT*/
	/* A node without either CDAT or HMAT */


> +	if (!node_bw_table)
> +		return sprintf(buf, "N/A\n");
> +
> +	if (!node_bw_table[node_attr->nid])
> +		return sprintf(buf, "0\n");
> +
> +	return sprintf(buf, "%u(MB/s)\n", node_bw_table[node_attr->nid]);
> +}
> +
> +static ssize_t bw_node_store(struct kobject *kobj,
> +			     struct kobj_attribute *attr,
> +			     const char *buf, size_t count)
> +{
> +	struct iw_node_attr *node_attr;
> +	unsigned long val =3D 0;
> +	int ret;
> +	struct access_coordinate coords =3D {
> +		.read_bandwidth =3D 0,
> +		.write_bandwidth =3D 0,
> +	};
> +
> +	node_attr =3D container_of(attr, struct iw_node_attr, kobj_attr);

Can do that at declaration of node_Attr above.

> +
> +	ret =3D kstrtoul(buf, 0, &val);

Check ret before filling in values.

> +
> +	coords.read_bandwidth =3D val;
> +	coords.write_bandwidth =3D val;
> +
> +	if (ret)
> +		return ret;
> +
> +	if (val > UINT_MAX)
> +		return -EINVAL;
> +
> +	ret =3D mempolicy_set_node_perf(node_attr->nid, &coords);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static int sysfs_bw_node_add(int nid)
> +{
> +	int ret;
> +	char *name;
> +	struct iw_node_attr *new_attr;
> +
> +	if (nid < 0 || nid >=3D nr_node_ids) {
> +		pr_err("invalid node id: %d\n", nid);
> +		return -EINVAL;
> +	}
> +
> +	new_attr =3D kzalloc(sizeof(*new_attr), GFP_KERNEL);
> +	if (!new_attr)
> +		return -ENOMEM;
> +
> +	name =3D kasprintf(GFP_KERNEL, "bw_node%d", nid);
> +	if (!name) {
> +		kfree(new_attr);
> +		return -ENOMEM;
> +	}
> +
> +	sysfs_attr_init(&new_attr->kobj_attr.attr);
> +	new_attr->kobj_attr.attr.name =3D name;
> +	new_attr->kobj_attr.attr.mode =3D 0644;
> +	new_attr->kobj_attr.show =3D bw_node_show;
> +	new_attr->kobj_attr.store =3D bw_node_store;
> +	new_attr->nid =3D nid;
> +
> +	mutex_lock(&wi_group->kobj_lock);
> +	if (wi_group->bw_attrs[nid]) {

Add another label and put the mutex unlock in the error path.

> +		mutex_unlock(&wi_group->kobj_lock);
> +		ret =3D -EEXIST;
> +		goto out;
> +	}
> +
> +	ret =3D sysfs_create_file(&wi_group->wi_kobj, &new_attr->kobj_attr.attr=
);
> +
No blank line here.

> +	if (ret) {
> +		mutex_unlock(&wi_group->kobj_lock);
> +		goto out;
> +	}
> +	wi_group->bw_attrs[nid] =3D new_attr;
> +	mutex_unlock(&wi_group->kobj_lock);
> +	return 0;
> +
> +out:
> +	kfree(new_attr->kobj_attr.attr.name);
> +	kfree(new_attr);
> +	return ret;
> +}
> +
> +static void sysfs_bw_node_delete(int nid)
> +{
> +	struct iw_node_attr *attr;
> +
> +	if (nid < 0 || nid >=3D nr_node_ids)
> +		return;
> +
> +	mutex_lock(&wi_group->kobj_lock);
> +	attr =3D wi_group->bw_attrs[nid];
> +
> +	if (attr) {
> +		sysfs_remove_file(&wi_group->wi_kobj, &attr->kobj_attr.attr);
> +		kfree(attr->kobj_attr.attr.name);
> +		kfree(attr);
> +		wi_group->nattrs[nid] =3D NULL;
> +	}
> +	mutex_unlock(&wi_group->kobj_lock);
> +}
> +#endif
> +
>  static int wi_node_notifier(struct notifier_block *nb,
>  			       unsigned long action, void *data)
>  {
> @@ -3868,9 +3994,22 @@ static int wi_node_notifier(struct notifier_block =
*nb,
>  		if (err)
>  			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
>  			       nid, err);
> +
> +#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
> +		err =3D sysfs_bw_node_add(nid);
> +		if (err)
> +			pr_err("failed to add sysfs bw_node%d: %d\n",
> +			       nid, err);
> +#endif
>  		break;
> +
>  	case NODE_REMOVED_LAST_MEMORY:
>  		sysfs_wi_node_delete(nid);
> +
> +#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE

Probably better to stub the function than to scatter ifdefs throughout.

> +		sysfs_bw_node_delete(nid);
> +#endif
> +
>  		break;
>  	}
> =20
> @@ -3906,6 +4045,15 @@ static int __init add_weighted_interleave_group(st=
ruct kobject *mempolicy_kobj)
>  			       nid, err);
>  			goto err_cleanup_kobj;
>  		}
> +
> +#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
> +		err =3D sysfs_bw_node_add(nid);
> +		if (err) {
> +			pr_err("failed to add sysfs bw_node%d during init: %d\n", nid, err);
> +			goto err_cleanup_kobj;
> +		}
> +#endif
> +
>  	}
> =20
>  	hotplug_node_notifier(wi_node_notifier, DEFAULT_CALLBACK_PRI);


