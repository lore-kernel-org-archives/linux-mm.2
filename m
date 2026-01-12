Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785B5C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78236B0088; Mon, 12 Jan 2026 09:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59736B0089; Mon, 12 Jan 2026 09:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B5F6B008A; Mon, 12 Jan 2026 09:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A32776B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:30:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39A5113A99E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:30:33 +0000 (UTC)
X-FDA: 84323547546.13.56D3DF0
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F75214000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:30:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ajBPzY2J;
	spf=pass (imf09.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768228231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ufp0SZFe0MebuLzATEI2/9d5yfpShZoQXYWtR9jnTtQ=;
	b=m2fpMlz5ArkxS1lIeFa6WOfqocaX+j9iytgGCxZQR8amotXV47TD2lu9AafGh/Kw4XtAzc
	Mmpq/cQHxN3PjuCBoulMh+5/LniWH7xM09pIqjFM3oWNlN+f1uMTbRvLXHC23t4dBUpyoi
	bInkO6tCUPwFn4Gc/JHU+MT6eZ1TYaU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ajBPzY2J;
	spf=pass (imf09.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768228231; a=rsa-sha256;
	cv=none;
	b=45T9b9yUoj/YPk2JWzdmvMLuTWlbajw3nf5rZ2uaKQZQq8BBCvEqUfPbtEGV4fsQCaRjaN
	MFYHivydSS5/T2cP1mjXzlVeJ+JuLbDhAD4IbSimaM0iSj4OVD567VHR//N8fLeYupgX+0
	Q/rOlVxK+A/j4x4l/wDB22JGzPOFtm0=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so44498545e9.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768228229; x=1768833029; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ufp0SZFe0MebuLzATEI2/9d5yfpShZoQXYWtR9jnTtQ=;
        b=ajBPzY2JtdHxh8ibojqNDn3oEapPbHp2P5n7+EHaK2IuHs7u0jUbci/orvwtigm/fx
         fs2RIMhlyvLlS4dW9viK++K8Dp0m2dHQhxx1ltvki8fycnwKuYrWnbxxjI998JVmfBpi
         bWdCjV5GyneL10eNxm+chuzUuXDNMZfttblj+HIJofyvUc/ZXtAB1DCCQ9/cHSPU6t9d
         50TIUddIdmPBC2f3mgby5OfrSK1UuESVHNt8bAwwgHkYLyeWGR19UCV0WEKPjKW0rXqp
         h+QcYvTOwo8hhwu3+zeASDql2qKKFTj6MQ7o+tpFKP9PQdbLU4yfe5OnJ/7VJytnj94m
         oO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768228229; x=1768833029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ufp0SZFe0MebuLzATEI2/9d5yfpShZoQXYWtR9jnTtQ=;
        b=XCaqq7bDTkpPnWLBOstsMm0xtMo/naTE2XiGVE2i32ypSqWQ51YChlyCJXmJk6eX/B
         LIT/3FtOeobqM02YRr3jBK82v70Xa8Ur9aZO3T/+JLwdpr+91SPPcaMWNsmK9hUr+qfF
         /nV9e6yvsGfg0f02G88x1YQIhiuY4yB2LgmLjDqVP6XD75uZnpmjKtfr4PGH7EGzKnj3
         G3A1QuwznRWjoxYD1dC790WvxO748DWNyNC27h33zyf9zuFTgSZhhgGOrE7b/36Yr+AV
         H24lBoWEvyjx5abZw1C41xyMi2WLmCHCS7IWQO4cbSZIHWwtnOeJm7r2DBs+kMQE8ttE
         SASw==
X-Gm-Message-State: AOJu0YwczpVjRbqZsrJYtZd1nGo8eFqU188NsaaUUHo7TOumXiT7XXY8
	58BhBvqsNjEau/8VzZexLgJzno2artLJEaNF+NIunhmT4DxOnf8mKPaUcORxRTk/Pue1clXK4eJ
	dEoobLZk=
X-Gm-Gg: AY/fxX6e8AlIyUOowYUOJoQX9bDnk2NfPaRUxauYqAwsnuEF1nut7X9he+WOBpIiA3l
	ZIEgnTEHjqowd4P4rDJEmabqnhHniDFRtefGMeU0L9YuObflpFtFDW6DKOOiHjFZCCGPcBk0jX7
	qE/gTlW+cI4HMjT0AyeacKVH8hYFkNSPh1c6NXZiGf7XUQxCrc9p5tuHS7+PKRQ+0c7PwFWs/Vk
	QCP56FFLgvMHzj4Gsn3RIgaI88VEuUp+Jb6KkPYsDS56Mp9hRPIqzLhiGMjAkW6Z5Vi8OKdln4z
	iAx9KgGPJYz+8djUkFCNeK5aatJLDCx62Mj0bTOOXuYucJIdYWIJ9bzmCVFyYOc5l3kG3GyIjOY
	BzwgT4vg/QMcHlv57E2Q9kLU9gGFasOOnup6JTv9qizv9bqD3fNUwdhADjHQi0oJ7AHYwzNhqdV
	dRoZq6xPSnq9ZupSA2WVn9C9tNhKreMW8=
X-Google-Smtp-Source: AGHT+IHDVuFl+T/cu+HZzO3h+yAn0G+FdrWgV6XO6swWljps8VItMR+Lttj4fdxMmzgr/HRFuS5nGg==
X-Received: by 2002:a05:600c:82c3:b0:475:de68:3c30 with SMTP id 5b1f17b1804b1-47d84b21466mr211537245e9.16.1768228229374;
        Mon, 12 Jan 2026 06:30:29 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d865f84besm139369365e9.1.2026.01.12.06.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:30:28 -0800 (PST)
Date: Mon, 12 Jan 2026 15:30:26 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	corbet@lwn.net, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com, 
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com, 
	dan.j.williams@intel.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, rientjes@google.com, shakeel.butt@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, 
	zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 5/8] Documentation/admin-guide/cgroups: update
 docs for mems_allowed
Message-ID: <o6eky3g4jyvtc2cy6lk7rjc6or6tcvwbhdarrlpn4geuibvrul@65fygkf6vg44>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-6-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zsg7ffk6fb5gx5vt"
Content-Disposition: inline
In-Reply-To: <20260108203755.1163107-6-gourry@gourry.net>
X-Rspam-User: 
X-Stat-Signature: kwcua1hsw1jhnfd9b8tjtrh6d3tdqnoe
X-Rspamd-Queue-Id: 1F75214000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768228230-466054
X-HE-Meta: U2FsdGVkX1/5oZSonDM6J8hphYCGZlug6XtcqoguwjJloJ4FKYoBSLCABSG1T8zfVdgCdljaagOmhFhEV8A8EH0Bj4l2m0hwzxxbtIaMKU6GBUGoGWz5ywHqL9L8JA71yfKlvfCo+jLVNIIksJiEedM2Sm4P/jbxVG1wvj7H5HzhCS8+HumXtHr5SNkX2D1nkejceH16WEB5Kcrqd5g4ynBBIJ/OhKNvdfGzc2zIu8xWIVJs0MYTvCTOyMHGzTQzxKChxnnMsvKHasX5SeVqhlbltiDDPE7Jp8eSWo3a8IRruELtdi8ZVg6PwiK0T5xgfDkkVNptEPVirTgVrfD+Gshl1qECk5YQL6JpT8puEui+NLq758CrJjdq3TKMYPiTyNnDQI7/Fv1Oys91qLn7OwBvUk4XoxWDI/gUZLPcdrPpVQrk+uy7aett2zDVgwZqTyENrFQvN2z3QEUDira8dBmf7q+KmtPW9N2TvrfCJ5s1p8uMJO6+kF8rfwF8Wk0nGQ7W4eWVtUZdMGcoj7h3V1qrYdnuXUeDVUEEjoyJ+aNQEm2ctOiRG0s93m9vWwnz6wR/Z4NlxLsgOAG5yeH10mNpDUSZK5wvmJgH+DcvlsS5UStJGt6xu3qrWfRpw8d5XPgN2DAMkcwhsD9MmLotsTnzxBgTJgpn768jXkAJzj2v0UKjjc7ysYboJrW29B2xAbp03+2POD0aiNadm45n2gvKPtYLsMYbothcqCVa63pZA7n6DjVPaMh5NKZ2kAol6u0oMujW3AhynkGJs690wu7y1sp5Vtjcrj5+7yVn3K4+BwJvD3kvCI1XJZe9xm7XJe4NBLjPlOSwsAbbmNdfQihaMnKb9Et/m0PA8sGeUl+8CEIJDhGcsgmlL4fswLJKu0RvwLRq57c6C1iPOnIDoqVAGCk4FdTHfHQehwTbaMYhu6fz754eS9AxHOWl+nqKhfdR5eqefxt1RwYd4Yl
 9SZrXdKn
 jPv41sK4SU5F8i45R71snodlnoGy3Z3eZ/hTdW2ZTDFtTZB0dxkZIxfNWqFjBQNSwJdJgQO42WMsZXjeFPwp7nwX/bW17LMYe9uXbYOvxYsrONNO3zM0yMoj3Ttaf3N2sV9yjRYjKvJGTTzFl0wIjZhNeHWKVAUq3JdN3ryttBEdbe46gxRE6fSIdeD/IrcXQCCSXurVP8poK3zbdc03zGuMd9aV4L3fW87BxBeVjTMThh1/YiGhAZy6uvKqo1Xnqkqg6RBbQfMpaS1QHV1rPjiQllv9G/yACn+UP7eOtBhbrVqF5gdOsjM4J3068G95JEMn8GH3jp43WUAvSqe5wS1qFMxLTfXeC3xJNvrGHApHsXy/3xryc7A7WFQUeuChRKXz2D1kmaqb/kKYkIm4QNMNwKkOCf5W6nB8HpmQgLiOvXzKbczdLGH9uV21/FRaWTM6vS5tf2rX53i/pxxaoZ/9C+1Jt8yLWsdBYVtscoXQKJEharpSD3534punolHn12QtHYxyumVXBcg5KWMAFx/kxuY12KVig8UKFbqmfHFWdln75LO2r/mKryl5pnnEzxuO+izgNwAVkgIJ6pnwpY+BVItv199qkl8Yk/Sz7T1YpUjJPGYZbDXpi2zKZL2FWMbLPiWPmcIBvDYtiRZBauRsCeOyzBKvTACM57PFCNVWCjWszVj2IcLhYiMH5aFsnsNAm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--zsg7ffk6fb5gx5vt
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v3 5/8] Documentation/admin-guide/cgroups: update
 docs for mems_allowed
MIME-Version: 1.0

Hello.

On Thu, Jan 08, 2026 at 03:37:52PM -0500, Gregory Price <gourry@gourry.net>=
 wrote:
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2530,8 +2530,11 @@ Cpuset Interface Files
>  	cpuset-enabled cgroups.
> =20
>  	It lists the onlined memory nodes that are actually granted to
> -	this cgroup by its parent. These memory nodes are allowed to
> -	be used by tasks within the current cgroup.
> +	this cgroup by its parent.  This includes both regular SystemRAM
> +	nodes (N_MEMORY) and Private Nodes (N_PRIVATE) that provide
> +	device-specific memory not intended for general consumption.
> +	Tasks within this cgroup may access Private Nodes using explicit
> +	__GFP_THISNODE allocations if the node is in this mask.

Notice that these files are exposed for userspace. Hence I'm not sure
they'd be able to ask for allocations like this (or even need to know
about this implementation detail).

> =20
>  	If "cpuset.mems" is empty, it shows all the memory nodes from the
>  	parent cgroup that will be available to be used by this cgroup.
> @@ -2541,6 +2544,25 @@ Cpuset Interface Files
> =20
>  	Its value will be affected by memory nodes hotplug events.
> =20
> +  cpuset.mems.sysram
> +	A read-only multiple values file which exists on all
> +	cpuset-enabled cgroups.
> +
> +	It lists the SystemRAM nodes (N_MEMORY) that are available for
> +	general memory allocation by tasks within this cgroup.  This is
> +	a subset of "cpuset.mems.effective" that excludes Private Nodes.
> +
> +	Normal page allocations are restricted to nodes in this mask.
> +	The kernel page allocator, slab allocator, and compaction only
> +	consider SystemRAM nodes when allocating memory for tasks.
> +
> +	Private Nodes are excluded from this mask because their memory
> +	is managed by device drivers for specific purposes (e.g., CXL
> +	compressed memory, accelerator memory) and should not be used
> +	for general allocations.

So I wonder whether the N_PRIVATE nodes should be included in
cpuset.mems[.effective] at all.
(It resembles CPU isolation to me a bit ~ cpuset.cpus.isolated.)
Maybe you only want to expose it on the root cpuset cg and inverted like
cpuset.mems.private?

Thanks,
Michal

--zsg7ffk6fb5gx5vt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWUFgBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AivpwD+JBcYsTGjsYsxubfnEPsa
ZpJvMAA2jVDEmQNiB588agwBAPoLqRDiK7ZtFi8f8bY/cXcHgh+krN2tOGh2v+x0
RlAB
=oogw
-----END PGP SIGNATURE-----

--zsg7ffk6fb5gx5vt--

