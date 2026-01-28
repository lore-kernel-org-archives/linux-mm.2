Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33182D25B45
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EEA6B0088; Wed, 28 Jan 2026 06:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726B86B0089; Wed, 28 Jan 2026 06:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626186B008A; Wed, 28 Jan 2026 06:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3CC6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:25:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F368A1B0EAD
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:25:39 +0000 (UTC)
X-FDA: 84381142398.25.67C33A1
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7708100008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:25:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oLkrQ2N/";
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cB4a/XPi6BJnstGaPUtwWX/2DGaqsFO6UK5snRzHDRQ=;
	b=5FUjUxtUv+ul9rx4C5/CC4N4GL08mo/UFvI9/YiZ664R9AATIAJlmn4k6DdB/aU4ugdPaR
	Lak5nJKon+Y71O/of/jpW7/N0woVcaqpZlGGWQOzXLidnd5/ewKmhfSxZ5JGwy0sI5jweJ
	CpIgUvFcaYfX8j5kLgJKKW4ME9LkoLo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oLkrQ2N/";
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599538; a=rsa-sha256;
	cv=none;
	b=gaIfOXVTihQZDyB5wR/IJ18DWctp9gE9bEu0ewMnNT7dU/hodkBh1wOd+I2h7/oucH0HpD
	b0nHQdYyDD+hQKLdZDAibly1s50h7zZjy41UW94po0ahNw6/16B2eYRWl06qRgS+4UkFRt
	XyBogSMHBr/YjWP75FL6zSTNsNgK6bM=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b885d8f4092so942046766b.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769599536; x=1770204336; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cB4a/XPi6BJnstGaPUtwWX/2DGaqsFO6UK5snRzHDRQ=;
        b=oLkrQ2N/5Be2kel6wgtSuVHEyxfyEMqr3/8FOWt9ACQzc1lHpietAedjdPfztu55CF
         tPetOAp6uv6WFRVt9RshklY7H9Uyy54U0VqKiHScJjAwBmL34F2e+olihAGQHO9YGsw5
         1nUJnOsPF8X6wmP6N71gfoCrH6oQmovDwEyVBhZv1ncWB/gI6TNXK7hPrg44fq5OLvYn
         0uDZzpGrMh3UA7EbX5cVx/eC6oveubTUlEYRmiZn/IF+ua0aaW/os+K+qIY1jIauqjHs
         SUiVvEjqfGwrtYhSvbdj3UiaaHtJU9xc2y8L07FUWsYxg5tw/GQ0O3XmwJj8uumqaf8Y
         aoJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769599536; x=1770204336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cB4a/XPi6BJnstGaPUtwWX/2DGaqsFO6UK5snRzHDRQ=;
        b=xADhysA+nKf29gj7T4aTwmQDDT0bz+jh/NkZXSytfffp4R0WOz0iF2dcI72vuunN2a
         YLTIX7dUNvQun43VTjSLWRSDDTfahHZ1hDK5OPm0kF5adXY8qc1RTSHw/BUbf+CQV/Ue
         /XX4dvVJpawBfY7I/CJaGqxvu8adhwCRgaO03lQwQlz68K4n9e8IAK98iNtqxIXV1GG+
         xDXgJECzTdzBvlHI/hJExxbD2U3cK9AL5Im3Rg0a1NGjti9ivOPIBTuk1Qr6ZsdFyy04
         GdF9B2HxwsK4czw/vfCVSvJolONXyqGljwI7n0ZRfXcq1STiHIACnLdT06nPn5Zi2LWe
         VUJg==
X-Forwarded-Encrypted: i=1; AJvYcCVjH62KfEuh/Why2yScuuvm30KMPOiTu5ypf2X8f5dYhlOHiiqoCJYl9MfRyeQw7X4/e2oBDzu2pw==@kvack.org
X-Gm-Message-State: AOJu0YzLsK3kxUtO8CjlNVuTa78Fpfsk4A2w90S1XPAtOPSkoYD/F6v8
	DnvNJFzszW8Kumsja1gHTDWMwqRIbsr//KwzECcaBzRP/EVo6nco4vs7kkAns1RZ5Q==
X-Gm-Gg: AZuq6aJ5+znM+R6I4xTsJ6NEeokUlKQWfDV6osLc0dt8k4huzgRQrjt2CcpmmKlJ9kW
	ur+BoagEVWENVW/eo5ykqvUKYiv1zUqqS1eU1MEX5hALAqq0JycrLdCC7/QfMt+bZ5PuLtub9Bh
	9cqpitGVXNgDVfnjfFfTE9tNyW/n9J0jyW580GbkdSM8Yk4+xb/QY3cw1fqOAqurD1QDYV5Zs+G
	BQ1xO5xGy3SdkJQNAC9DscrlAAPf5bovZZR8m8M8AVx5HAiz3HHHJnFp7ZNwc6q6UQdHV3DiIgF
	ohaZAwvlRriMrQABuZhnd/8kjisomzUMEiXNWu373dCIKYP3RoJJC48yMyLdWx/fh0mYUXsYlpb
	L85MnIidg3iI2EigM7cWqm3Y6RKjrpAgfRD/VSqSlNxIiTnSfJC2vWdryGbFT/Yoes5CVfseX6H
	QVqRE5cnLXUIiTloU9eP/SgSyDfHam/JABkmobfE/DYF21q1b8z9Y=
X-Received: by 2002:a17:907:1c27:b0:b88:6542:86a0 with SMTP id a640c23a62f3a-b8dab39a855mr385588666b.54.1769599535959;
        Wed, 28 Jan 2026 03:25:35 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbefc667asm116547566b.22.2026.01.28.03.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 03:25:35 -0800 (PST)
Date: Wed, 28 Jan 2026 11:25:31 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to
 cgroups
Message-ID: <aXnyKw5sRt_MB-8A@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-3-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-3-roman.gushchin@linux.dev>
X-Stat-Signature: n1eo6mrs6nrb8mtjt1s7sb4ntscspuqr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7708100008
X-HE-Tag: 1769599537-780770
X-HE-Meta: U2FsdGVkX1+yxjj9D7KHQZKuqfm7SDbVeRZX+pKfFDZ4f0RUb7lMKE97cTyRp6NqxlXyvWp7B2vmgo93iD27juPHLswSLbvki1TAfPup0pES68vvPxLv63wz8nDLwvY0LEBfoTh+radRdlTOc6TL//WNtErR1WNpTfxdcxK2EIgTqBCCY98KJpMoDhFqaGhoar6zicijZEW/W9M3BQBLQ+LaDFKDxsxaOSrytOnxVZbGAnKrpkUoLH3ucT9xSXVk6WPwwzxIbL/T+4iSvw2L1siPn2S6yZuRa8SSp4N/RR2UiIjXWTO5iPlxEErdwAYAv1byFc3NZhU02A+Gy98F6pyK+9RcMdtfc+FiEaL5AtGxn77mvCAJSy+nSasnT+oHV+EeEiGJQQB7uTdom8szWt4nh6lbYLlymbzL3sS7gE/pP+N52SRzxwp9XZyltDKjb592qU4PIQSpOmYZnSBZRH5ZQF1x0CBvAzzxmzfvpuJBUgcNbThCbHqzC0Jxma1yQr5ZDSLr91In2ee0enwvr1qstFdkJPpvEDib2h46NYkAedvfudmqkFTQRFoZFPP9KkYZ4zmMv3CnD1Sz75fPfA6vmV5BgfIQe3deD75UFItRQTLZ3cm6tfFYJAuZcJL4tSFBH+Im5E3P/Bg2yHAhIdxhL6h1oMHiHL+/7HQiM2qElHcosmKDv7jHq/Vm3E8mwo//TVQEmuRqe4EmDLGPbY6dirG1DdCA43mMB+SUGjXUsMUVaMquJGBHb5CMc8HCHdv9yuwaY/6G7M6rxhwq3og63LdF1DqLY1GGlDZYsUDQtKjdBk4TnhNbBZo2tV3owK7T8PQuQGzrs8hBmf+abXodE0Vss+SXierO6IlGsbmssykhzjZmbLAYGn+Xqf7V2QlpUMyBtuyZUWrw0j9Gf0erg6gRd5jDV5NWWyAoYN1V4RCP749VTALl10Jtbt6gccOcf/m+VH6ozz8mEvJ
 LdmiZ+Pd
 I9615Sl0pE7I+OCcbsMAOfHi3TsdfcxTkiqfBJBOToBf7rcU+z0FMQsK/RZHa6MmPaSopNzrVyg1XvlgPKtdHIdWZi0AOZcmNypqp2GZJ3ZPQRThAco7GBoP4+9vIioCy8K+FVSQgOTiilvurDbBKvwZFkq8/ggxNb31CUcqk6MeNiFsV0nyf6vsDpBDCc9MTMlVIh6XTnWuAjT+Zet/XmN1wzTmBhCaviMdkYrmejW5KrFC6+ra6ti1JGaxMyeakWVszY7rM/5P8XB9r9u0JK01w1uJpE4mp0rB6NboZbc/q/5FSeEgY2rS/Fz/ET5RPZ+tXjn9eja77uzQIgM+j3r2qgXswPfdGknL3B+eKhfZEPXLzU53ohjNOBorwV1vRTF7AYn/9IFc3H2wYKk24jsc8OJckc/0JiJ6Y5qkevGEM+pZTUTThjFuBf75CLwSy9VCHbiynYXhifWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:05PM -0800, Roman Gushchin wrote:
> Introduce an ability to attach bpf struct_ops'es to cgroups.
> 
> From user's standpoint it works in the following way:
> a user passes a BPF_F_CGROUP_FD flag and specifies the target cgroup
> fd while creating a struct_ops link. As the result, the bpf struct_ops
> link will be created and attached to a cgroup.
> 
> The cgroup.bpf structure maintains a list of attached struct ops links.
> If the cgroup is getting deleted, attached struct ops'es are getting
> auto-detached and the userspace program gets a notification.
> 
> This change doesn't answer the question how bpf programs belonging
> to these struct ops'es will be executed. It will be done individually
> for every bpf struct ops which supports this.
> 
> Please, note that unlike "normal" bpf programs, struct ops'es
> are not propagated to cgroup sub-trees.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/bpf-cgroup-defs.h |  3 ++
>  include/linux/bpf-cgroup.h      | 16 +++++++++
>  include/linux/bpf.h             |  3 ++
>  include/uapi/linux/bpf.h        |  3 ++
>  kernel/bpf/bpf_struct_ops.c     | 59 ++++++++++++++++++++++++++++++---
>  kernel/bpf/cgroup.c             | 46 +++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h  |  1 +
>  7 files changed, 127 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index c9e6b26abab6..6c5e37190dad 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -71,6 +71,9 @@ struct cgroup_bpf {
>  	/* temp storage for effective prog array used by prog_attach/detach */
>  	struct bpf_prog_array *inactive;
>  
> +	/* list of bpf struct ops links */
> +	struct list_head struct_ops_links;
> +
>  	/* reference counter used to detach bpf programs after cgroup removal */
>  	struct percpu_ref refcnt;
>  
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 2f535331f926..a6c327257006 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -423,6 +423,11 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  int cgroup_bpf_prog_query(const union bpf_attr *attr,
>  			  union bpf_attr __user *uattr);
>  
> +int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
> +				 struct bpf_struct_ops_link *link);
> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +				  struct bpf_struct_ops_link *link);
> +
>  const struct bpf_func_proto *
>  cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
>  #else
> @@ -451,6 +456,17 @@ static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
>  	return -EINVAL;
>  }
>  
> +static inline int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
> +					       struct bpf_struct_ops_link *link)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +						struct bpf_struct_ops_link *link)
> +{
> +}
> +
>  static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
>  					union bpf_attr __user *uattr)
>  {
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 899dd911dc82..391888eb257c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1894,6 +1894,9 @@ struct bpf_raw_tp_link {
>  struct bpf_struct_ops_link {
>  	struct bpf_link link;
>  	struct bpf_map __rcu *map;
> +	struct cgroup *cgroup;
> +	bool cgroup_removed;
> +	struct list_head list;
>  	wait_queue_head_t wait_hup;
>  };
>  
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 44e7dbc278e3..28544e8af1cd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1237,6 +1237,7 @@ enum bpf_perf_event_type {
>  #define BPF_F_AFTER		(1U << 4)
>  #define BPF_F_ID		(1U << 5)
>  #define BPF_F_PREORDER		(1U << 6)
> +#define BPF_F_CGROUP_FD		(1U << 7)
>  #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
>  
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> @@ -6775,6 +6776,8 @@ struct bpf_link_info {
>  		} xdp;
>  		struct {
>  			__u32 map_id;
> +			__u32 :32;
> +			__u64 cgroup_id;
>  		} struct_ops;
>  		struct {
>  			__u32 pf;
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index de01cf3025b3..2e361e22cfa0 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -13,6 +13,8 @@
>  #include <linux/btf_ids.h>
>  #include <linux/rcupdate_wait.h>
>  #include <linux/poll.h>
> +#include <linux/bpf-cgroup.h>
> +#include <linux/cgroup.h>
>  
>  struct bpf_struct_ops_value {
>  	struct bpf_struct_ops_common_value common;
> @@ -1220,6 +1222,10 @@ static void bpf_struct_ops_map_link_dealloc(struct bpf_link *link)
>  		st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data, link);
>  		bpf_map_put(&st_map->map);
>  	}
> +
> +	if (st_link->cgroup)
> +		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
> +
>  	kfree(st_link);
>  }
>  
> @@ -1228,6 +1234,7 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>  {
>  	struct bpf_struct_ops_link *st_link;
>  	struct bpf_map *map;
> +	u64 cgrp_id = 0;

Assigning 0 to cgrp_id would technically be incorrect, right? Like,
cgroup_id() for !CONFIG_CGROUPS default to returning 1, and for
CONFIG_CGROUPS the ID allocation is done via the idr_alloc_cyclic()
API using a range between 1 and INT_MAX. Perhaps here it serves as a
valid sentinel value? Is that the rationale?

In general, shouldn't all the cgroup related logic within this source
file be protected by a CONFIG_CGROUPS ifdef? For example, both
cgroup_get_from_fd() and cgroup_put() lack stubs when building with
!CONFIG_CGROUPS.

>  	st_link = container_of(link, struct bpf_struct_ops_link, link);
>  	rcu_read_lock();
> @@ -1235,6 +1242,14 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>  	if (map)
>  		seq_printf(seq, "map_id:\t%d\n", map->id);
>  	rcu_read_unlock();
> +
> +	cgroup_lock();
> +	if (st_link->cgroup)
> +		cgrp_id = cgroup_id(st_link->cgroup);
> +	cgroup_unlock();
> +
> +	if (cgrp_id)
> +		seq_printf(seq, "cgroup_id:\t%llu\n", cgrp_id);

Probably could introduce a simple inline helper for the
cgroup_lock()/cgroup_id()/cgroup_unlock() dance that's going on in
here and bpf_struct_ops_map_link_fill_link_info() below.

>  }
>  
>  static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
> @@ -1242,6 +1257,7 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
>  {
>  	struct bpf_struct_ops_link *st_link;
>  	struct bpf_map *map;
> +	u64 cgrp_id = 0;
>  
>  	st_link = container_of(link, struct bpf_struct_ops_link, link);
>  	rcu_read_lock();
> @@ -1249,6 +1265,13 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
>  	if (map)
>  		info->struct_ops.map_id = map->id;
>  	rcu_read_unlock();
> +
> +	cgroup_lock();
> +	if (st_link->cgroup)
> +		cgrp_id = cgroup_id(st_link->cgroup);
> +	cgroup_unlock();
> +
> +	info->struct_ops.cgroup_id = cgrp_id;

As mentioned above a simple inline helper could simply yield the
following here:

...
	  info->struct_ops.cgroup_id = bpf_struct_ops_lin_cgroup_id();
...

>  	return 0;
>  }
>  
> @@ -1327,6 +1350,9 @@ static int bpf_struct_ops_map_link_detach(struct bpf_link *link)
>  
>  	mutex_unlock(&update_mutex);
>  
> +	if (st_link->cgroup)
> +		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
> +
>  	wake_up_interruptible_poll(&st_link->wait_hup, EPOLLHUP);
>  
>  	return 0;
> @@ -1339,6 +1365,9 @@ static __poll_t bpf_struct_ops_map_link_poll(struct file *file,
>  
>  	poll_wait(file, &st_link->wait_hup, pts);
>  
> +	if (st_link->cgroup_removed)
> +		return EPOLLHUP;
> +
>  	return rcu_access_pointer(st_link->map) ? 0 : EPOLLHUP;
>  }
>  
> @@ -1357,8 +1386,12 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	struct bpf_link_primer link_primer;
>  	struct bpf_struct_ops_map *st_map;
>  	struct bpf_map *map;
> +	struct cgroup *cgrp;
>  	int err;
>  
> +	if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
> +		return -EINVAL;
> +

BPF_F_CGROUP_FD is dependent on the cgroup subsystem, therefore it
probably makes some sense to only accept BPF_F_CGROUP_FD when
CONFIG_BPF_CGROUP is enabled, otherwise -EOPNOTSUPP?

I'd also probably rewrite this such that we do:

...
	struct cgroup *cgrp = NULL;
	...
	if (attr->link_create.flags & ~BPF_F_CGROUP_FD) {
#if IS_ENABLED(CONFIG_CGROUP_BPF)
	cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
	if (IS_ERR(cgrp))
		return PTR_ERR(cgrp);
#else
	return -EOPNOTSUPP;
#endif
	}
...
	if (cgrp) {
		link->cgroup = cgrp;
		if (cgroup_bpf_attach_struct_ops(cgrp, link)) {
		   cgroup_put(cgrp);
		   goto err_out;
		}
	}

IMO the code is cleaner and reads better too.

>  	map = bpf_map_get(attr->link_create.map_fd);
>  	if (IS_ERR(map))
>  		return PTR_ERR(map);
> @@ -1378,11 +1411,26 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>  		      attr->link_create.attach_type);
>  
> +	init_waitqueue_head(&link->wait_hup);
> +
> +	if (attr->link_create.flags & BPF_F_CGROUP_FD) {
> +		cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
> +		if (IS_ERR(cgrp)) {
> +			err = PTR_ERR(cgrp);
> +			goto err_out;
> +		}
> +		link->cgroup = cgrp;
> +		err = cgroup_bpf_attach_struct_ops(cgrp, link);
> +		if (err) {
> +			cgroup_put(cgrp);
> +			link->cgroup = NULL;
> +			goto err_out;
> +		}
> +	}
> +
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)
> -		goto err_out;
> -
> -	init_waitqueue_head(&link->wait_hup);
> +		goto err_put_cgroup;
>  
>  	/* Hold the update_mutex such that the subsystem cannot
>  	 * do link->ops->detach() before the link is fully initialized.
> @@ -1393,13 +1441,16 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  		mutex_unlock(&update_mutex);
>  		bpf_link_cleanup(&link_primer);
>  		link = NULL;
> -		goto err_out;
> +		goto err_put_cgroup;
>  	}
>  	RCU_INIT_POINTER(link->map, map);
>  	mutex_unlock(&update_mutex);
>  
>  	return bpf_link_settle(&link_primer);
>  
> +err_put_cgroup:
> +	if (link && link->cgroup)
> +		cgroup_bpf_detach_struct_ops(link->cgroup, link);
>  err_out:
>  	bpf_map_put(map);
>  	kfree(link);
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 69988af44b37..7b1903be6f69 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -16,6 +16,7 @@
>  #include <linux/bpf-cgroup.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/bpf_verifier.h>
> +#include <linux/poll.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
>  
> @@ -307,12 +308,23 @@ static void cgroup_bpf_release(struct work_struct *work)
>  					       bpf.release_work);
>  	struct bpf_prog_array *old_array;
>  	struct list_head *storages = &cgrp->bpf.storages;
> +	struct bpf_struct_ops_link *st_link, *st_tmp;
>  	struct bpf_cgroup_storage *storage, *stmp;
> +	LIST_HEAD(st_links);
>  
>  	unsigned int atype;
>  
>  	cgroup_lock();
>  
> +	list_splice_init(&cgrp->bpf.struct_ops_links, &st_links);
> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
> +		st_link->cgroup = NULL;
> +		st_link->cgroup_removed = true;
> +		cgroup_put(cgrp);
> +		if (IS_ERR(bpf_link_inc_not_zero(&st_link->link)))
> +			list_del(&st_link->list);
> +	}
> +
>  	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
>  		struct hlist_head *progs = &cgrp->bpf.progs[atype];
>  		struct bpf_prog_list *pl;
> @@ -346,6 +358,11 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  	cgroup_unlock();
>  
> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
> +		st_link->link.ops->detach(&st_link->link);
> +		bpf_link_put(&st_link->link);
> +	}
> +
>  	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
>  		cgroup_bpf_put(p);
>  
> @@ -525,6 +542,7 @@ static int cgroup_bpf_inherit(struct cgroup *cgrp)
>  		INIT_HLIST_HEAD(&cgrp->bpf.progs[i]);
>  
>  	INIT_LIST_HEAD(&cgrp->bpf.storages);
> +	INIT_LIST_HEAD(&cgrp->bpf.struct_ops_links);
>  
>  	for (i = 0; i < NR; i++)
>  		if (compute_effective_progs(cgrp, i, &arrays[i]))
> @@ -2759,3 +2777,31 @@ cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return NULL;
>  	}
>  }
> +
> +int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
> +				 struct bpf_struct_ops_link *link)
> +{
> +	int ret = 0;
> +
> +	cgroup_lock();
> +	if (percpu_ref_is_zero(&cgrp->bpf.refcnt)) {
> +		ret = -EBUSY;

If the cgroup is dying, then perhaps -EINVAL would be more appropriate
here, no? I'd argue that -EBUSY implies a temporary or transient
state.

> +		goto out;
> +	}
> +	list_add_tail(&link->list, &cgrp->bpf.struct_ops_links);
> +out:
> +	cgroup_unlock();
> +	return ret;
> +}
> +
> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +				  struct bpf_struct_ops_link *link)
> +{
> +	cgroup_lock();
> +	if (link->cgroup == cgrp) {
> +		list_del(&link->list);
> +		link->cgroup = NULL;
> +		cgroup_put(cgrp);
> +	}
> +	cgroup_unlock();
> +}

Within cgroup_bpf_attach_struct_ops() and
cgroup_bpf_detach_struct_ops() the cgrp pointer appears to be
superfluous? Both should probably only operate on link->cgroup
instead? A !link->cgroup when calling either should be considered as
-EINVAL.

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 3ca7d76e05f0..d5492e60744a 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1237,6 +1237,7 @@ enum bpf_perf_event_type {
>  #define BPF_F_AFTER		(1U << 4)
>  #define BPF_F_ID		(1U << 5)
>  #define BPF_F_PREORDER		(1U << 6)
> +#define BPF_F_CGROUP_FD		(1U << 7)
>  #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
>  
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> -- 
> 2.52.0
> 

