Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920A2C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D39B6B008C; Fri,  4 Sep 2026 14:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D7D6B0092; Fri,  4 Sep 2026 14:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624AC6B0095; Fri,  4 Sep 2026 14:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9F36B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:03:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE9F712019A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:03:12 +0000 (UTC)
X-FDA: 85176851424.04.EBC151A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 28AEF1A0011
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:03:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="P+VWg/n6";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788544991;
	b=Dx9bfNkCcmy7Ay0HmLp6ua8JepcCtfTqg2lxJxxoXmoAbpy4f7KBg0+FDcBgZKuPA6YCJv
	+2q7b6q1XKZljtaO0Mci0n18rLvMURxRrOjDDo1b1y5oflBEM1JPpYM2X83pMNagCc9sjg
	hx8i9Pe6Q/jJcvpVX3r/ED9UCaweQ4Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="P+VWg/n6";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788544991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ev2idwf/cRdO21vilJlKS8uLeOphzrHyKdxcKhFvig=;
	b=GQDnosECC9TU1vXKlPqG72wb/6QhcttGFN2JWleZa2AtpwjQkRTBDtQ7pDM8pPHzSM9Voo
	aRmSRvyBu+pmzUhKF1G+Y+bQN6dagRQttzGyaFON2YgOisZL+1M/bTdCieVFzBP9zJfvYv
	A89BaXiO07VeGQ6uXD2HzTbs2lhHm4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B9F60209;
	Fri,  4 Sep 2026 18:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C191F00A3D;
	Fri,  4 Sep 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788544990;
	bh=/ev2idwf/cRdO21vilJlKS8uLeOphzrHyKdxcKhFvig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=P+VWg/n6qG4nawFvDzIt6ngXMNxN2sAVMzhN1MbsKMMZxRXjHBZujph2TeZrLFo9E
	 oaeR35MQK6J7zTXvfNVdMY7s8jtU06Py4y63d6DUtMtCfKaxtbL5kVMdfcFz7S7c9a
	 TmK2qynE/qKWwuc7OM86fs6M+wk2DvyrBBGZk/Hk=
Date: Fri, 4 Sep 2026 11:03:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn
 <inwardvessel@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Andrii
 Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Ihor
 Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan
 <shuah@kernel.org>, Barry Song <baohua@kernel.org>, Geliang Tang
 <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-Id: <20260904110308.4473cde499e91aab14dbd5fc@linux-foundation.org>
In-Reply-To: <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
References: <cover.1788516769.git.zhuhui@kylinos.cn>
	<7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qw18d6abp38uibi85qjotupzyrytkad8
X-Rspamd-Queue-Id: 28AEF1A0011
X-Rspamd-Server: rspam06
X-HE-Tag: 1788544990-356079
X-HE-Meta: U2FsdGVkX18AQKHfMZwrDCYcngXJl++KeDjgFom/FMNl3mh8EH/XbIxhdE6uXsA5lMWvtsjX1vTh7tpEG1U3i2WR7cvX31TQJFZEESJqWzkF+xHXGgbpN/mCNf/maoPnZJS1sZzv3jmLERdeRL9luRqNlzqeOWU5vTZjaiQR7zKjz9JciyCoU56Igddpn6topbOd2Vui6gu+V/Y4Id2/vi5xkFRZk02zU+7YWRwOQrKBt0R4jYwClHkjO4cEuyt1rIVaCUH4fGt5j5FjaMjrOzEMuHBE+CAXouyTDszBy5ewBt1JO0cqh+y3GAQefQKMlau4ZrWsskw69dhsaEcKVHaibv3HS1l2kM+ztpnYzsGqsfQUTNEyuu3D6eyDPx6ZpPq+h6iu4FCGp8tj34WKCDEYmY2XYPAMny6wTb4o+llXYqEIRcgHqc2n/SYiqSFCXGpQQrbQwvvOGsrCjgl2lwLUUdkNO0Vy0HPFusYAEMVm/YZiyjkFZ1Uq9UuGLrBXzIukj7AGrBWZucuGqxS/bdjX2CeesMSuq2wP3WefBzbir/FfgddFE6QpAQbgVKtyDhe8ldefpz2NvuSZnXSdMq9VCJUF7jq6G+hAC/XTRqfTI9VXvJ6JkRcbHarkDLUn8tYALjS3M8H7ihPHlQkfryAzjpCxRSByG3IZqArlDeeki03NlX7mdjXgmO0V+iMDYlOLdBn+zuFSeq5TQm6t4QiWQz8hJCI8vILE/8sYfSEHwoqfBo0V1kfCq3gfcLu8ZljQdVPg/YZVziaLP8yG3nE1Ule40a7JbxhDbox7jo5vv9x/Qw+Zo14i/1Ny+zFBuzcypgQBl7rMSIH+O8n5L12fNYzsMOAYg/7d3j5svebk/omCrugpU8+rCmkR4p5C5ZwlIc/hVxXpbsn0v0UytH/Ql/mNRXoEi4lpUQZJ6I5a1WScuPqIsc/DABTSj6jOTjy2CV83en4INUzkHc/
 G7Adzg+r
 0DN5KKt+A5mv/2Ou8jMHQZgS0ng54BOIMbjjtTIwbaZggQ4qrU5nXX9ceoepu2Df32WCjMtgJD/zBlBObbUpPFaU8ORPN240tIe9N/fL7CFkzOPh9HYFvacf9hFU7y3ndmsW0RjAafPVCpvmDvvL9K5Pja1hPgHnWMBSNf26FUmMGkodsb0tMCMPvd4O+v0E2zHuoAKFf3aKKr0wGpKDVvECvnkCbdbH24xqN899qIje8hnpOjm0EPJRUA5i9ie9spUXXUcTQ+aHsTbw6gKab33rrr5T99c4zTI7eKHyyAM4LfWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 18:20:19 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> @@ -159,6 +160,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>  
> +/*
> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> + * current->reclaim_state, so a nested call would corrupt the outer
> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
> + * reclaim_state is also checked because it is installed slightly
> + * before PF_MEMALLOC.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> +}
> +

Would life improve if try_to_free_mem_cgroup_pages() didn't do that? 
If try_to_free_mem_cgroup_pages() (or some variant of it) were to
permit nesting?

	rs = new_thing(current, &sc.reclaim_state);
	...
	set_task_reclaim_state(current, rs);

?

