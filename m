Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CA2C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227306B00D9; Mon, 17 Aug 2026 09:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D95F6B00DB; Mon, 17 Aug 2026 09:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFEE6B00DD; Mon, 17 Aug 2026 09:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3E416B00D9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:49:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8020E1207A8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:49:55 +0000 (UTC)
X-FDA: 85110894750.17.71FDB60
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 03DD014000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:49:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=ad5DWPZN;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974593;
	b=arjyKGJP71k0z4F6uMf+BmrAEX8CkAfjgge9ftVLCqO2+N9T/EIIWb3wwqEtCJsJPHZc3R
	VOfLc/tOkpA8ZlQPPI7Bv/X0oVVDrtWjSgy+k2IaPh9Yrne69Eoe2g+FP/PZgCf+XCBnEp
	+wsRMC3t3RMpqTMnof+EIV11Edsu5v4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=ad5DWPZN;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/Sge/HEaRHrAnq6gNY9Urt58pOU9P34p0y2R0WVaEE=;
	b=sRLHewJxhenfAIGZMIK8Bo/bTCJ1XID24yBXc6GTBxBwswwYZZrGF5sj6+HnA4yGjTQzB0
	YvpLRMqvlBXMBENTWW5n18+IxIlTDhDa/RV0lGea5AfgX97UrYnmlQ7FPPB2x+8X8hAY98
	aNswV4n8+QghMDnHvi0OWpGafubpO7w=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=b/Sge/HEaRHrAnq6gNY9Urt58pOU9P34p0y2R0WVaEE=;
	b=ad5DWPZN3XAbiYxp7mTiS9vw22QA2QbQ/CsFhV52wvnlImJKGoN7CzDhWbtFj0LJJis75hoLt
	H9DvtZ9d4jEsbmjFmeny8iTNN0bZhyFws0odThksdMKabfPRuUnB/xIK4M1eiDJqCNtaTwDrg9T
	mDDLsS5EZaLKv0rv8XalUQg=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hNvMn1ngmzJ46F6;
	Mon, 17 Aug 2026 21:49:41 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 146BB40575;
	Mon, 17 Aug 2026 21:49:46 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 16:49:45 +0300
Message-ID: <dc075f92-2291-49f0-8f89-01b2ffb7fd82@huawei-partners.com>
Date: Mon, 17 Aug 2026 16:49:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/core: introduce damon_set_target_pid()
To: Enze Li <lienze@kylinos.cn>, <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <enze.li@gmx.com>
References: <20260817125319.888994-1-lienze@kylinos.cn>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260817125319.888994-1-lienze@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 03DD014000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f4dwa1csb1exqzrp7o6w6aonegyuhgcm
X-HE-Tag: 1786974591-397041
X-HE-Meta: U2FsdGVkX191xB2SXwbFHp8W8za0pOSbPF9jivu32UTkdK2XW2O5xasMONuGZj7pH+OMJNDpncVZPIkZSi2KkE1uSZCOjoxv52FUj+xEQxEKDBRrKMqiqWTqndfNAuVyvkMG2ILpzKn7xcWtaP9NJALg3hhOjJ3TWP5hTWFSR96c8KMNnJFfBJ4Mja44zYN1zLxi6rQ+YYkx3knEYErnEqNftxhIbBQX1G6s6T5V3oZR9+g8ayPiE0HFYwBGKK0vsQ5ljH7+yhFThAZODNKABrMDl7pQY0WMFKr/OOxFxP54PKyyWFR5523ncityiorv3WCUC4aSXP1vlSPBKi86HeI2lFXuVmJYNihEiZYhgotVtQEoKuIrd+gWZs27+3CdhCCwGQT6TSJqpoRgKtKCBqtxNT8+/2Jjh0e4fKoMv3hlQMrfiet1ph3Doj8UVzU+Qj82uLVTCJb0Bmynv9Rzt4JD7ynuPvmiUEiud55bS3mQE/pSoj9q0hDFIL2fqC63SjpzHWveqClgrIRg1A+k3g2jHIimQRaKxjwldbNGtM/E+Ah2951BaHNR7WxTMpnCYuDYeZ4WwbEWjMbYc2oGT+ZkY7ntTSLy+T4G6xjyMkTiR7rAiyY12Ao3Ecdovf2h70B1l26r6t7N7YKMFT5z+t8X1zbBCQ6AmUk4+oxAbAprBLhcbr/qhGtSmgzw+ppXU6GCtNiV947fMAoDgfr44d+7i/HAg9iF/Y8o3td5XIk3Qzsfv9jowAmUD9pzK5OE/q8B8gZ77QzllFF7HoKrLrzOkY27ZCW8R+6U2VzD5HAwEHrl4617On+uhFu4h3+YqCGe6mmoV0WD5PC0s7gRX5FJlnE1a8QfnnptEZKTRudOduOZOPgxw93PbvQDBqvPVLzog0D6NGuUrHcLKiXDdUPvlDnc01eUxb+6Al4ARjgNNnwvolUnFSyeCNn20d6QSoADCqKpA6g1Qib0uc8
 Pt8LGC4y
 G13ymE8V8ZIbaT2mHWm0KJa9h9PdCKJn+Skq4gQdZVkD3NrOkJbxnrUXUlU+DEYjouBIl3wpn2shUk+Cu4HdUIzAT3pGuMyZ2btfQExCqp/JKKUlGplctLe6FAAb4VFSIl6XKvzsNaEABw+N8eD3LV79wsARHwLznFqKjNEYxHj3xt37+L4fNaVvH1hVnkJCBFsY0fdj26+86/KPIL7IMqNfFfjSk7lOw7oOHL2/YqEowyYbqG9oUgvbEb+sQL3GtM5cwkkiElBcfj5Ab5fNSK5hE2Xvb5K11vdxBI97k9puOfvIOxXt84T5XdguqvnQmZD7fVToAaqlvZj85DvU2sMENqRNG/LKj4D0gZyM+mGNMiH+B/pabi7WW8UaeO4Cw1ZcHLrO5CnyKfv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Enze,

On 8/17/2026 3:53 PM, Enze Li wrote:
> The logic that finds the struct pid for a given pid number and assigns
> it to a damon_target is duplicated in multiple places.  Including
> damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
> of the two sample modules, samples/damon/wsse.c and
> samples/damon/prcl.c.  Add a function that does the work, and replace
> the duplicated code in the places with calls to the function.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  include/linux/damon.h |  1 +
>  mm/damon/core.c       | 12 ++++++++++++
>  mm/damon/sysfs.c      |  6 ++----
>  samples/damon/prcl.c  |  5 +----
>  samples/damon/wsse.c  |  5 +----
>  5 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 0c8b7ddef9ab..a937aa55170b 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -1054,6 +1054,7 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
>  
>  struct damon_target *damon_new_target(void);
>  void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
> +int damon_set_target_pid(struct damon_target *t, int pid);
>  bool damon_targets_empty(struct damon_ctx *ctx);
>  void damon_free_target(struct damon_target *t);
>  void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 644daf5a1656..82b196407ae8 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -10,6 +10,7 @@
>  #include <linux/kthread.h>
>  #include <linux/memcontrol.h>
>  #include <linux/mm.h>
> +#include <linux/pid.h>
>  #include <linux/psi.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -795,6 +796,17 @@ void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
>  	list_add_tail(&t->list, &ctx->adaptive_targets);
>  }
>  
> +/*
> + * Assign the struct pid of the given pid number to the given target.
> + */
This method is simple enough. Do we really need a comment?
> +int damon_set_target_pid(struct damon_target *t, int pid)
> +{
> +	t->pid = find_get_pid(pid);
> +	if (!t->pid)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  bool damon_targets_empty(struct damon_ctx *ctx)
>  {
>  	return list_empty(&ctx->adaptive_targets);
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index e3858ffab4b2..3c81b4c91ac0 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -3,7 +3,6 @@
>   * DAMON sysfs Interface
>   */
>  
> -#include <linux/pid.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  
> @@ -2035,9 +2034,8 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
>  		return -ENOMEM;
>  	damon_add_target(ctx, t);
>  	if (damon_target_has_pid(ctx)) {
> -		t->pid = find_get_pid(sys_target->pid);
> -		if (!t->pid)
> -			/* caller will destroy targets */
> +		/* caller will destroy targets */
> +		if (damon_set_target_pid(t, sys_target->pid))
>  			return -EINVAL;
>  	}
>  	t->obsolete = sys_target->obsolete;
> diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
> index 842099bd6228..83ddf12811d5 100644
> --- a/samples/damon/prcl.c
> +++ b/samples/damon/prcl.c
> @@ -32,7 +32,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
>  MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_PRCL");
>  
>  static struct damon_ctx *ctx;
> -static struct pid *target_pidp;
>  
>  static int damon_sample_prcl_repeat_call_fn(void *data)
>  {
> @@ -79,12 +78,10 @@ static int damon_sample_prcl_start(void)
>  		return -ENOMEM;
>  	}
>  	damon_add_target(ctx, target);
> -	target_pidp = find_get_pid(target_pid);
> -	if (!target_pidp) {
> +	if (damon_set_target_pid(target, target_pid)) {
>  		damon_destroy_ctx(ctx);
>  		return -EINVAL;
>  	}
> -	target->pid = target_pidp;
>  
>  	scheme = damon_new_scheme(
>  			&(struct damos_access_pattern) {
> diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
> index 37fd5da20158..53944aea8428 100644
> --- a/samples/damon/wsse.c
> +++ b/samples/damon/wsse.c
> @@ -33,7 +33,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
>  MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_WSSE");
>  
>  static struct damon_ctx *ctx;
> -static struct pid *target_pidp;
>  
>  static int damon_sample_wsse_repeat_call_fn(void *data)
>  {
> @@ -79,12 +78,10 @@ static int damon_sample_wsse_start(void)
>  		return -ENOMEM;
>  	}
>  	damon_add_target(ctx, target);
> -	target_pidp = find_get_pid(target_pid);
> -	if (!target_pidp) {
> +	if (damon_set_target_pid(target, target_pid)) {
>  		damon_destroy_ctx(ctx);
>  		return -EINVAL;
>  	}
> -	target->pid = target_pidp;
>  
>  	err = damon_start(&ctx, 1, true);
>  	if (err) {

Otherwise, it looks like a nice patch.

-- 
Asier Gutierrez
Huawei


