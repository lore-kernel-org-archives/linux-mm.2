Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED376CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B00C8E0007; Wed, 27 Aug 2025 12:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086BB8E0002; Wed, 27 Aug 2025 12:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04FE8E0007; Wed, 27 Aug 2025 12:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE49B8E0002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:25:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 648C9140757
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:25:50 +0000 (UTC)
X-FDA: 83823063660.17.AD12D17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A312040008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:25:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjJ9xvvq;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756311948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSCaJkIP8YQHgNZO6e4AJDEYvSZTGqal04/k8MTfglo=;
	b=z4k8x2DCURVHcl1sW0+4YZ2tjtAblft5m10CDFXW7Ptjnn7HbWsQM4BucoX3S/awxgaH29
	5ZsRChLKm4i43jHt3/nWRoxzUcFyXDKQKRiqEmGX7fF0CpqiNzxvQp5lM/hBUA6McrBYGC
	70D5Tx3LuWTNXQQzqKvsJDSO3nlEBqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjJ9xvvq;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756311948; a=rsa-sha256;
	cv=none;
	b=DLDIG7r2Q2sXJlQrDxGNsjygKcZSRKxVPg1PkA90Vm1llDkquP0B3czoK0Arpm8/52bWfh
	jHeSOe8c42tdskTeSzKZKv26oxz4Odt7VAOqCjvKp4NyRC7tEo/wgr24aw+YRMzMdnN9N5
	LGhltE+YiNL2T/bn95rG9iO0yy6KFBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9390C4391C;
	Wed, 27 Aug 2025 16:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C9C4CEEB;
	Wed, 27 Aug 2025 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311947;
	bh=gUhEN5tEu43m9pD4c2NTudOZiEOt6pOHbaOxrqZLM0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cjJ9xvvqWUAkSFGEZk8Qpb8Z4fK1Qez66zMB16FAR3EZRXnPfFN+/M2VtQB7EJWKd
	 ZBVYQPaWkqpX3gtXw9Bgsu9dhQuBucLWt6n/PIsjvGhd9exmyGw9JMcLpwiuwsTTf5
	 Bu5SdCVAsmndsNVwXIys2J9gOTGHw/+zCtzQHhH7L8SAspXOz73z3ExXCNV410mU0r
	 GMTmGzLJypWrwJKdaohy/mMOjdMrzTX56Ky9OFHzGGwc0BRTyqBE2HSyks7YIUxz/M
	 lZ4wKql2/5whmPBdC5zYVbDo7ytdAUcJoVecvnDsm/kln+NS+b0awHkz4Wy1SSyTDf
	 6XtAohwc0RssA==
Date: Wed, 27 Aug 2025 06:25:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, jack@suse.cz
Subject: Re: [PATCH v2] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aK8xilDSEaRB3mjj@slm.duckdns.org>
References: <20250826121618.3594169-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826121618.3594169-1-sunjunchao@bytedance.com>
X-Rspamd-Queue-Id: A312040008
X-Rspam-User: 
X-Stat-Signature: mb8dtmzk7314rbpwdto7scdkmr778ep8
X-Rspamd-Server: rspam09
X-HE-Tag: 1756311948-435706
X-HE-Meta: U2FsdGVkX1/hj6NCffUEyH8roZuFDisbLTqmA1IAE3L/COWyFTcO8al0tnHc//1kMvj5bkNQGLdyAtCk2AbG5hwKOUqiUNidxtMBL2whh/RBvsNlBa8SoKbeDd9t+8VmASlT5ZnU+YQLB6fT5slBiRzJh503vrVE9b7lnHh1hLG3QP+lmHfmFXz0JFpxGaGnjsefQSi0ykAziVKM0IRmL6x0NrP4ZTPp+p7T4NBpTENYf/vcHIFikt87NbaAiECGdBz2jiu+hZmaZjfgqk4eVEuSZGN5nurgx1iKZIXRO46vpwIcVG0irT/bxLiowp3wERvAGHnRvI+OcRwpnLtFEqewYX5e4Tpaxb8t/YGqEyXPHm8/2Ra6VIfyD1e9wQ1D8l37eSkuaoXoTeXe7zQy1ywriHixg1ZSGntYvZi5b5JhtDw0U7LcNoLQrA6Vz3D5Q42j3CykGI7g97ea5HJm8StFZgcOk+/ELUnNaNVCpHsHFp15nxhc0d3hfhlv7xnPrFNKc7QRiPPRqhG6Hlf5UC7EhbhYZ9kt5eUl1BKGPAwBrT+gkXNAyGfaN0L5jcTnO6+TMmgrZm4fRmmDatsx/TPJK9AasFNLpBZWzb9NTHGFhPhKABIJC+rUOWNveTyjqadOL/dIisuXjuqGAzoxeeQt+Mla2an+zQDcGiYcdmrcsPpS/pW8DK9YXOnfQLZIrU+zD+l5fMJ3YFIH9fz8nxQ36RXR5GiWsg9y5XCjMWJOlt7ZSZ4n5EyYhmrJlTRh3xXatuXXkLOcthIeTBSJVqegbv9RcX6wawepmXRGiqlmltWI9l1RyueEvUYeNHsDP4Mc35zB28HRQg1u1sJF8HK2EzlZ7wm6PBit+yL6TfKBvlUt+KAvnsRWN2S+tIgZBdXpUw+CwI8JUfZbe82kTgJadr5ZPBFVxH/4N8eOu4QLK2u7StDgLtv975eFUbFvLwzCYzm3uteSEu2bHhs
 ojXLkJur
 5M6AmJtqHkxs6zafff5gWZ+xrAFEC0zCYUVWLkpRrg13pqfqaYVUoK49UT0+4gVYu2ev6H2RFC52vRcV0o7W1H1Y6a061MBqxTGYz9F13d57vAo5+NXRO0Pnl8TTBwNaNfQGQ+6pHYUOgc88wmTfymddyN7qmiE8e/6A7fAH17RGxqAPZMN9NlIE0FyL/58U1QSJQxY6dYDTjjm4KDcd4WHBEl3LIdvPqzvahIhNn9uKuKZxWxCOkIw84OQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Aug 26, 2025 at 08:16:18PM +0800, Julian Sun wrote:
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 785173aa0739..f6dd771df369 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
>   */
>  #define MEMCG_CGWB_FRN_CNT	4
>  
> +struct cgwb_frn_wq_entry {
> +	struct wb_completion *done;
> +	struct wait_queue_entry wq_entry;
> +};

Why not embed wb_completion in the sturct? Also, can you name it
cgwb_frn_wait instead?

>  struct memcg_cgwb_frn {
>  	u64 bdi_id;			/* bdi->id of the foreign inode */
>  	int memcg_id;			/* memcg->css.id of foreign inode */
>  	u64 at;				/* jiffies_64 at the time of dirtying */
> -	struct wb_completion done;	/* tracks in-flight foreign writebacks */
> +	struct wb_completion *done;	/* tracks in-flight foreign writebacks */
> +	struct cgwb_frn_wq_entry *frn_wq; /* used to free resources when release memcg */

And the field just "wait". I know wq is used as an abbreviation for waitq
but it conflicts with workqueue and waitq / wait names seem clearer.

> +static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_entry, unsigned int mode,
> +					int flags, void *key)
> +{
> +	struct cgwb_frn_wq_entry *frn_wq_entry = container_of(wq_entry,
> +							struct cgwb_frn_wq_entry, wq_entry);
> +
> +	list_del_init_careful(&wq_entry->entry);

Why list_del_init_careful() instead of just list_del()?

> +	kfree(frn_wq_entry->done);
> +	kfree(frn_wq_entry);

If done is embedded, this will become one free, right?

Thanks.

-- 
tejun

