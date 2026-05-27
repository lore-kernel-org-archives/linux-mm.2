Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19D0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DAA6B011C; Wed, 27 May 2026 11:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6C76B011E; Wed, 27 May 2026 11:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CD06B011F; Wed, 27 May 2026 11:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E24A56B011C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:44:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E28E161B85
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:44:42 +0000 (UTC)
X-FDA: 84813622404.20.2018CED
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8713340009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:44:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYHo+u+R;
	spf=pass (imf12.hostedemail.com: domain of yonghong.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yonghong.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fswUnI9q78WgkM0igmVl4iKvvWN/p7M51WA068cywCs=;
	b=iw05+APt7uS2EyElb0yHM3AXLHSnVQ4yLFpJ1Gerk3R4M2RdnWv/OcIJ22WFkS15MuHUpv
	Ui4vQypBr2JAnCZaFCmII2qRHv37CHIUMu1QcmBPIuX2JNyrVDbu3xV6WItVyVEtfuk3Th
	JJRaPnjIo8A5owqzpBicRg+zBPWIcwo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYHo+u+R;
	spf=pass (imf12.hostedemail.com: domain of yonghong.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yonghong.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896681; a=rsa-sha256;
	cv=none;
	b=Ncqp2FaNUJ56QP1+RME+Z4w3x1GuOIDRiX+X2f6iTk0XcY8fBO2BhMSToYXPG8bc13tfFZ
	ikUs3j0UAJAqCzvBQnmMvLcjLhj4+dAod/9mNJBa7ujqxt/pwGbERGh38hGOuHieSh942U
	0Zd5inh0txsj5XiUBMgZnZtf/EoN29c=
Message-ID: <2fd62ec0-c594-4ac2-a95d-29eafbcb74d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779896678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fswUnI9q78WgkM0igmVl4iKvvWN/p7M51WA068cywCs=;
	b=sYHo+u+R/Ay7Axr7WPIVp6rQyo9OifxAVtBZ97wRRuu2Y/F3gQXObPgpFrLOasaSj2yf1d
	RSBieMqGfnG8lVEpcH0Fu9GasO6+hNDg0g2UUOBvj5tOv5wKk2h2hah7ESxfO2PbmcHWuC
	2K41sPVIUTq+HSP7teOoOuMIe8BS3RA=
Date: Wed, 27 May 2026 08:43:54 -0700
MIME-Version: 1.0
Subject: Re: [RFC PATCH bpf-next v7 04/11] libbpf: introduce
 bpf_map__attach_struct_ops_opts()
Content-Language: en-GB
To: Hui Zhu <hui.zhu@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
 Tao Chen <chen.dylane@linux.dev>, Mykyta Yatsenko <yatsenko@meta.com>,
 Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung
 <ameryhung@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
 Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
 Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com,
 Jan Hendrik Farr <kernel@jfarr.cc>, Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Willem de Bruijn
 <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org, baohua@kernel.org
References: <cover.1779760876.git.zhuhui@kylinos.cn>
 <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8713340009
X-Stat-Signature: xzxpg6y1fcauuyo8xnc9iq66zbsa7uy1
X-HE-Tag: 1779896680-632116
X-HE-Meta: U2FsdGVkX19u06hYAs5tRM+Whw7F7fJHsAmh+Yu2wW9ChmtHelwl/8j+/XoTPEADxO64Tzm+7/FlrAORrSwI4qyyHN77q7k4xHrCTaSBOS8gRxO5cSJoqMnvVaLD7RC0UTKcpIn/NiDNVLaZXdAl44WPZ0W3kJqdARqMc9NxEEqABlffI5gZxfe4piNwAYJnxIs1ahqPsBL+DMUetBCQDvr1kizFTPEbr11dOcbcwuD0c4kiYglWbjqUb+uKXdvyXgjO0ljsusuSqkqr5qtK7dN82bWhRBVwGPsgNq5EwnFsHxJ61KRVJX/3dmupXityZFcYBSDdB733mTYkCuCLD5n7SZogYquRTv47T7W5lboZ/GT6Q/ElIsS/txlXDSgbIvBVShGqBnduWplvAsB7SdVzP5pJagqHis36NLwQs/7g6za2qZga8l4or80X1vYnUwfUn8jCormrY3JnQlrf3jAkuoRX2XEcgPGdy80XFwu6Th9QZOFos8dAWVRuoQKVVa59yCWVllmTH5hmRNL/VVmkZtv8CSZBh+TGDewENmk+8RNEQiNT99jWMf9PsgzjZhSI/DAUmXUomAMPDLaco0cbJcq2f1VdFiz0uCmK/6zn2MwFL1dtyQ0OMZI/0A9i06g2Og+YS72U+A9I3thOwlElmdgXOL38TR+90hpwF/szSMcsw/85NdTcxHNI70TLtSrPzWE1x71mK08kBhZzS95TsLDVzkFq3yjww568q8/4Vx2aglFwMWx+oe1QQUdsgy7Qt57QxIaJauHNGsBNXiEm1vSyXMaVCTifHfmDLTjIQGlx8kbxKV2YRKryy+Plu5cHvCWUCFaOxQOD+V6lWouz3sC+bOhytgZOqBVgmyZvoW92RSiVOMyCSdp6tNtC5eAUeqpzhBRhBTzSDkXolFsMVGHNOjiZA7OO9kXvdx73u8Wk/6qWBKa9I44FmuceBePevC3h6xxumNKnL3G
 eXIibRKF
 34FiudRbjP+Pdiv7kFPT48U/C1MsgiuXG2JveGYajq7Qe2X6BJhnTDH5v9tlpJmN3+87YCb4nC/3eB/NA30IzLIXCvJWUeA1ELBEeQH6scH86C8vzkSqy31z2bYgq8yF84T9dQBwPRk2nQZs/HHOmX672vANc6m8JCK7nY272DI6AhxWYADbqB0x1JmFNnp7wTSB4u+AQm7isa8T8CT4oeOitt0cAK/vAEM/z5xAV3X+cD+KqtFJaG9RwXYSFXSIZblE3JPHIk0q+qOIAlK5eTGl0e/OxMXfVQOwuNJgRtlUmgk7CihmgcNpya+k88wgIDl0RdblqYNOu6uU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/25/26 7:20 PM, Hui Zhu wrote:
> From: Roman Gushchin <roman.gushchin@linux.dev>
>
> Introduce bpf_map__attach_struct_ops_opts(), an extended version of
> bpf_map__attach_struct_ops(), which takes additional struct
> bpf_struct_ops_opts argument.
>
> This allows to pass a target_fd argument and the BPF_F_CGROUP_FD flag
> and attach the struct ops to a cgroup as a result.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>   tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
>   tools/lib/bpf/libbpf.h   | 14 ++++++++++++++
>   tools/lib/bpf/libbpf.map |  1 +
>   3 files changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e8688975d16..a1b54da1ded2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -13683,11 +13683,18 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
>   	return close(link->fd);
>   }
>   
> -struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
> +struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +						 const struct bpf_struct_ops_opts *opts)
>   {
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
>   	struct bpf_link_struct_ops *link;
> +	int err, fd, target_fd;
>   	__u32 zero = 0;
> -	int err, fd;
> +
> +	if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
> +		pr_warn("map '%s': invalid opts\n", map->name);
> +		return libbpf_err_ptr(-EINVAL);
> +	}
>   
>   	if (!bpf_map__is_struct_ops(map)) {
>   		pr_warn("map '%s': can't attach non-struct_ops map\n", map->name);
> @@ -13724,7 +13731,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>   		return &link->link;
>   	}
>   
> -	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> +	link_opts.flags = OPTS_GET(opts, flags, 0);
> +	target_fd = OPTS_GET(opts, target_fd, 0);
> +	fd = bpf_link_create(map->fd, target_fd, BPF_STRUCT_OPS, &link_opts);
>   	if (fd < 0) {
>   		free(link);
>   		return libbpf_err_ptr(fd);
> @@ -13736,6 +13745,11 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>   	return &link->link;
>   }
>   
> +struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
> +{
> +	return bpf_map__attach_struct_ops_opts(map, NULL);
> +}
> +
>   /*
>    * Swap the back struct_ops of a link with a new struct_ops map.
>    */
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bba4e8464396..18af178547ad 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -945,6 +945,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
>   struct bpf_map;
>   
>   LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
> +
> +struct bpf_struct_ops_opts {
> +	/* size of this struct, for forward/backward compatibility */
> +	size_t sz;
> +	__u32 flags;
> +	__u32 target_fd;
> +	__u64 expected_revision;
> +	size_t :0;
> +};
> +#define bpf_struct_ops_opts__last_field expected_revision
> +
> +LIBBPF_API struct bpf_link *
> +bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +				const struct bpf_struct_ops_opts *opts);
>   LIBBPF_API int bpf_link__update_map(struct bpf_link *link, const struct bpf_map *map);
>   
>   struct bpf_iter_attach_opts {
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index dfed8d60af05..6105619b5ecf 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -454,6 +454,7 @@ LIBBPF_1.7.0 {
>   		bpf_prog_assoc_struct_ops;
>   		bpf_program__assoc_struct_ops;
>   		btf__permute;
> +		bpf_map__attach_struct_ops_opts;

Function bpf_map__attach_struct_ops_opts should be in
LIBBPF_1.8.0.

>   } LIBBPF_1.6.0;
>   
>   LIBBPF_1.8.0 {


