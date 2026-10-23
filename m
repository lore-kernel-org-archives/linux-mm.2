Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF236606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnZOfomc
Received: by kanga.kvack.org (Postfix)
	id BB79B6B0BB7; Fri, 23 Oct 2026 13:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68C76B0BB8; Fri, 23 Oct 2026 13:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABE46B0BB9; Fri, 23 Oct 2026 13:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E45B6B0BB7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:38:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4282160170
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:38:35 +0000 (UTC)
X-FDA: 85354600590.19.D362355
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B64B40009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:38:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RnZOfomc;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792777114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xceb5IU8bfgZgDF8uYnzWT+kl4EVCPQJ5Yl/w9i26mQ=;
	b=jzT0gCLqdSIryf32W5iyEhiOCfnkrtxdK3Bhb0mwoYR6oCajm+Bzixz4jKMRDpCJHEAIaX
	Xj64kjFUcJv0jcB/mKuZeV3iiH5ibiBhNf1PFpTGtEbg/cnlUZh6x6O7XvxjpksetyRS0T
	A7KcblnzC4iJsTGM//sIsJvWArUvN8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792777114;
	b=Fvv4VM1tYH+QBoa3qkM6+A+6Fk9nF2RFknpTs9nRfTLnbS6dCNNu+kYF6Az0FWNCjdHKhL
	kt/rAoEBBzqW+PScaS7vZnNn6t/sI48Cz70xGkxasXY2hpMj62qvFVVKq2QxSlByoYZzTa
	KIrQfrpdqUzhQKNWFAf1aly85N/6+UQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RnZOfomc;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBC79601DE;
	Fri, 23 Oct 2026 17:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421841F01825;
	Fri, 23 Oct 2026 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777113;
	bh=xceb5IU8bfgZgDF8uYnzWT+kl4EVCPQJ5Yl/w9i26mQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RnZOfomcQ1bneuisxRQWTV803c0j4Uv0iVf6zwDBE5tJasoFQ0R6o1jPwnuQn81mY
	 Rv0Rzbdwc2dE2ieqiYpaiIFihU7zohAuYBvvb/ikXxQ0s3V9oHcWFJH/AdsMLYcwqH
	 CTH1r5ViQ7gxhzJtxUS46FlsaJlbqXtNL4YWLKlcaQG7gZpgEuifJCO0+RqUj3F0ad
	 QADrP5zSkSaPUuSSzOdYJJLqPWn3SYxgyeCYequKOGTMq309QOwDioASYJrb84sc19
	 k60oRW7SpEHENdTpNdFrxcE8LuxNc7NWcoHJN37f6zZCcNzrtveLWeR2xc1ONz6dtg
	 3sYhDLJ3kRf5Q==
Message-ID: <sashiko-outbox-183008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhishek Bapat" <abhishekbapat@google.com>, "Suren Baghdasaryan" <surenb@google.com>, "Hao
 Ge" <hao.ge@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <f577c773058265f0eb7fe2c10fb6aa4003445a00.1792690544.git.abhishekbapat@google.com>
References: <cover.1792690544.git.abhishekbapat@google.com>
 <f577c773058265f0eb7fe2c10fb6aa4003445a00.1792690544.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 17:38:32 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B64B40009
X-Stat-Signature: e4jdd1447j7gsgutb3bkgjpz6etx9pfe
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792777114-259368
X-HE-Meta: U2FsdGVkX1/gxZ00jkibLZAm+oA89vh6OjtaZofp58grvpbgbcOa8dHViJ9CLrERr1vn/ryv5atU/7sqXBCC/L5BEumFhG/VYsl+UbDmogLwibXonnnG3JhN1eMFabqyk6e56MLjF+9TMh3igXq/3TKK8LvFXDsNTt/We2HFSvRXwYFohJuz+5/ul/LuD9BBvN0Y9nrFMKjbuMzDLMWRafj7pnCrRmWvyeYB8p4wOwWb8NSVREpM6+hKyfGCWV5CpwHLNqQdmM43BEm7puaartYYGjMqZM1R6TA57Fyrdr07vCUPQ/7sp2q+XH8Pb4Thu/62eiUUAW1tYoFUDUA3RowaSjSuPzNMR2e5NRa0HNyRbRlSrhdlZrcVF3Vro6ebd6fStmBehr7HgAd/LsBZgmr362IeX3F3y1HKg0u3SnQUi6ByNEHCTSmi7LZf6yuPENW6l1snSsL9iCLlmwRNS7wHoN9pfQrhoVAtZXf6tXKCpYQaKini5dKfKDJbWnRIAhXoIj/FhfIDNsxR5YfJoE5H/Exm1EGuHRGKa6diP4SQ/ONTapIGlbbE9bqglMl3TIz4do8QNvE87NbI91F5gfwU8c35bvNn7nTbkdjGiBy85ig+eGxBZ2CcL6M6DNCMYr80jVLdmgete6vlAv7YZILS0os4brpkN8eNgUu+OKpil9Rp3JjWHBC6CkGHDWFAwzZV1n0xlfTZkYF2+MopEXqNEj7LqCwOhaa662isYXl0JnxMde1wB3qeTgZjwXmYflPAOLxqM6xGCRdhxQwtERp8Zw1pvS5OYTCTR1M+NPt1ZVE/5fTw3su9UMM28012+BGBCG3f/lRHzKywRw9apMh145AA4Hqy2XyGcH3JihKG7qcRUpiMpZnpZfzzxcy2DHIGX1pc82MsJTp7yayknNbTTyhglOfvNG8k++MUXpWpPZhdfnNOQzX7W44NdFJkED6GsIaBQphZ5VYjTLi
 URUpkplw
 cJWmMhZwaWsZI+Kqx5XfMBBs9rJvQLYBO57hBh6/qt+AQxVj8D08ST6lbsMbKKP/xxt5kCfA/DFpkhzl6dvsc84NwoG4CdKgUfTsI024QLFTJ4ZtLQOmoe725B2hWkYB04svU9DVAMucZqd9SHs7Ko4c1L91/qZKH0y87Io0lddCNWWefura50xY/ep2rGdrk94yPUDGdGj+74OAbmtpccoh/fcdBXRXjZ2papF/gd1pHuU0+DqFrFBTaLEAWjKL7rXbES8hCKB9TSNRwnFci3xe0/E5lECkXPCWSq5Ir5O02mi3VDsJl8S6PGp2TBJ3NdE60dfDkAa/TE3XymL4Gc88aMqgSoWONS8eZQtuc24MXQjgeiySYQTXfGcYgXMlYxfvOxBU3HwtyDH7QN7/kY/7RIDrDu7TOJxd+jQPLPgOo1Qj5KkUJIsP+OzrHXxpsmiSB0O08U29gjNjAa8JWTdOiOx+nw4uENVbVvhRJrWOCp+CAkXdFnkcRyhKKO6lBs2RiaHgwJG5c5N/fIzbppiQMHSoUL6FHas58GLojpDHGBwYbo84guq4lhmoyI3NLEjRyIP7sy0K4WT3EPJma6cuCX02V3vHn4TCs/BAMw0oipCtGNyPd+2VAstA1XBQN2ZJ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] alloc_tag: UAPI breakage in ALLOCINFO_IOC_GET_AT from growing allo=
cinfo_filter
--

commit b1243e6bc8216f5fe9d8786ec8ca3a597c41681f
Author: Abhishek Bapat <abhishekbapat@google.com>

alloc_tag: Extend allocinfo_filter to support tracing queries

This commit extends struct allocinfo_counter and struct allocinfo_filter in
the alloc_tag uapi header to report whether tracing is enabled on a tag and
allow filtering tags by their trace state.

> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index dafcba2f7e2c1..a96054ac22376 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,7 +38,8 @@ struct allocinfo_counter {
>  	__u64 bytes;
>  	__u64 calls;
>  	__u8 accurate;
> -	__u8 pad[7];
> +	__u8 trace_on;
> +	__u8 pad[6];
>  } __attribute__((aligned(8)));
> =20
>  struct allocinfo_tag_data {
> @@ -54,7 +55,8 @@ enum {
>  	ALLOCINFO_FILTER_INACCURATE,
>  	ALLOCINFO_FILTER_MIN_SIZE,
>  	ALLOCINFO_FILTER_MAX_SIZE,
> -	__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> +	ALLOCINFO_FILTER_TRACE_ON,
> +	__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
>  };
> =20
>  #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
> @@ -64,6 +66,7 @@ enum {
>  #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURA=
TE)
>  #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
>  #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
> +#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
> =20
>  #define ALLOCINFO_FILTER_MASKS \
>  	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> @@ -75,6 +78,7 @@ struct allocinfo_filter {
>  	__u64 max_size;
>  	/* filter criteria only; see allocinfo_counter.accurate for actual accu=
racy */
>  	__u64 inaccurate;
> +	__u64 tracing;
>  };

[Severity: High]
Does appending the tracing field to struct allocinfo_filter in
include/uapi/linux/alloc_tag.h break existing userspace binaries calling
ALLOCINFO_IOC_GET_AT?

While struct allocinfo_counter consumes a byte from pad[] to keep its size
unchanged, growing struct allocinfo_filter by 8 bytes shifts the data field
in struct allocinfo_get_at and changes sizeof(struct allocinfo_get_at):

include/uapi/linux/alloc_tag.h:
struct allocinfo_get_at {
	/* inputs */
	__u64 pos;
	struct allocinfo_filter filter;
	/* output */
	struct allocinfo_tag_data data;
};
...
#define ALLOCINFO_IOC_GET_AT		_IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_=
AT,	\
					      struct allocinfo_get_at)

Because ALLOCINFO_IOC_GET_AT encodes sizeof(struct allocinfo_get_at) via
_IOWR(), and allocinfo_ioctl() -> allocinfo_ioctl_get_at() in mm/alloc_tag.c
matches only the new command value and copies sizeof(struct allocinfo_get_a=
t),
won't userspace binaries built against the previous uapi header fail with
-ENOIOCTLCMD (-ENOTTY) when invoking ioctl(fd, ALLOCINFO_IOC_GET_AT, &param=
s)?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792690544.gi=
t.abhishekbapat@google.com?part=3D3

