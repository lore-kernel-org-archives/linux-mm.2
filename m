Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72133D72361
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4430F6B048F; Fri, 23 Jan 2026 04:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410AE6B0490; Fri, 23 Jan 2026 04:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DAE6B0491; Fri, 23 Jan 2026 04:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17E546B048F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:29:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C690F13AD4F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:29:46 +0000 (UTC)
X-FDA: 84362706372.28.CEC1AB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40D8CC0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:29:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=F4nwAcHu;
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769160585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPCxZR+SWJ6w1tK6yalK4xkZ6pYh38S8w30i5kSHdnk=;
	b=0pEwX7Yy7+StyIo1JmvjnLLgCVcx4JEbVn72Nao5Q2tBh5DpK0RCCLQGjnZuYLgLCW57Y4
	ui6PkhH+qeb6zUOVdN+8MkJVUkeSB7yfnD8euR+AQdarPZlIqoRVougebOuL9uNsPzDED2
	2/thvVNpcshoH+lUSx4T4Kru8Xqz28Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=F4nwAcHu;
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769160585; a=rsa-sha256;
	cv=none;
	b=oTQg0rRk+3P1W6kg2k1tRq6D0gqgOhvdpLnogrMJwwi/sbtWi6WGcf/30v4TX6VG55TXKE
	5uwY6yUUZqVvlVnsxicX3uyWlvdnz3B4StYqdWnYmnSp58gEmPGo4gLQmA4T9oYrO1veIU
	tj2gveVJ8yvUxObyEZSTeWohtayk9aw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EF9A6013F;
	Fri, 23 Jan 2026 09:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B97AC116D0;
	Fri, 23 Jan 2026 09:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769160584;
	bh=UyNyhPZNlArXXC7DbgAjDuFCRG6qfF3Bxd1E4/+otZQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=F4nwAcHuuogXfFilu9ZLMVOGjf65Q6kn1NjG9xHyDQjxcKw8mechHmV/2UoKNz9eX
	 yJdAhjb8zATwBjMJEYORx1exA7ugxyGbFhiybcChfKths7LymkhEC8uUfdVAqQ+Cnk
	 /o1gx/rRVWYfwSVJFVNyAAXiwr1O1zLo//uJpXLFBwn0PcbFklSM0Rpv0xAMtPn4j2
	 8YndREmYbf+pnDgoHlMqu3Gq3NgBZT0dv6A66E1CQjJOxJ8Zib3HFLfoE1BkDFnBx4
	 NoGBDqusxbltNqeA4KQjr/pVHZpn9vRTit7GBPlVxmcI/2vSzgNvZoaVTOpUcKsHcM
	 nAuh2eNSimJrg==
Content-Type: multipart/mixed; boundary="===============7572374899106477181=="
MIME-Version: 1.0
Message-Id: <d2161f4252546f252dd0a84c461ba5dbb3b63e22d4826771edd8f1f30df050bc@mail.kernel.org>
In-Reply-To: <9f072e53f79ceaea43e3730476494517e453530a.1769157382.git.zhuhui@kylinos.cn>
References: <9f072e53f79ceaea43e3730476494517e453530a.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for  memcg_bpf_ops
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 23 Jan 2026 09:29:42 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Stat-Signature: tn4fkxrwkpgt14txew5c4dbonagy97nd
X-Rspam-User: 
X-Rspamd-Queue-Id: 40D8CC0002
X-HE-Tag: 1769160585-387632
X-HE-Meta: U2FsdGVkX19QfF6YisNhuO8WRORq6cGlM5LM71NZiyDED8xetM06wJuqUT1+ie5RkGRAcDqkdXGE8KHM/YMUVymSWYh9ECNAUrHExKvZawe2tIuK23MnLSw9UaRpaN2VIuyE6qfJfnIsRl2smWIUgr7FxzLvApR0gvzgO+lBqzmbJ37DzIoVDAs1Fxouvy6omNDM+WnDOLo2HlKCtqLQ9RHP8eL8XHxd+SUlwx4xYVUNhHUInac/uKjRrNiEPmUeNKfbR7cHotWXczHJIZZd5bQAPMz2S69QeUnSQ80h+uFYVl9ezJ1+SExzi13vFnLo7G1dORlTN9NzaJaiuvQ2GUZjElBFEkMpg3ilZffknVesGblYVATvr7VZIzKsN2TL8GFngMKX/W50vedyL1rGPL0ooj1gi7lsbfY6hl9Irz0BSQXCZ92sJZlxPkJ86ozjzARYLDQOBH/ShiUo4D7R2Q2o4ftHbCPUfUYbQibsQOxDVI8NPrCGdemFzao7ntnWJFCyF9hvzDjjiPiFZR/cgOX/Yj/ACYQiE41yDTePW1bGnelXB3OTNjT2vCR4Hc2Uglo7Ic0+ovSIcngee7yqVkgR4BONYloflabQ1ZOYgbPUIRNbfGRmf7++N8nnATwnoCaswBfEMENnkmfawpWMebAgOwXoQ0RJ4gUJmsR03gpTbNQEa2LbsfuALFX6fW9QyH8+1rmuWWuf7DOqN1J4HjKCJBYWeNlIL/CpaU7Q+e3vuwtLv9PKr4IaBHnmEqLcuOKRvOyLKlw2O1ux+fbT6J2+Jn8QbNAJlP6sB3B7T2PmTHkKKS1PweZLcoAJHzrwiIrsog9zDUVXU0tFiZIOa9npLfzEJZqLc2VxR3MlZstR2Z0Bpui+L/LDAE0g66iNef5z+JK5U4O4qfIk3D/G10lmU7uUcR1O1x5vMGD04vnBSKzkyFdoZEZP3zsIDW1+85s7EhmMSf56KXuTLJm
 jOlgtPd7
 LL8GevrepQIO/SW+N738ZP2RdblxpgS9NAgOt0DGQo1Pwl6b28lrJ1UC8B0wdfum7C0AF8ivlGqumGyjWoOdlJxpymQIpf1Z1uT72ovtC1IzAcQDMiW8znHAKF9LgapuQBuhHfJ50MTD9+i5swDqT9/KS/yIhSbgmRZasapAchn276wHlkc5bIyeD+HCwcC3SpH3CIAQyEEcnhxOIxOXqkNtHiZx94jQl+KLKUSVoGHh5F2HR5q/e7yB7TrDFkeTT6IMyB7lh/8LveWeEctHxaRJAAetPGzdGXH0qATP9bQU0ga1kuR0c9olPcTpY1KBridtt9NhqqoaNmNx3q4qNhnhhdW3svXHOFPwuftgsRPv9p4m4cgCH4f3BDhqb473EncEewG02Ihoym85efwpTAvDcEMZ+dsk0W5dfFjBkNwVCXNcTGXhwBPsjkZIZ4S79rE5Dpm9Gz9hjPU01BBFQcbGGSaPdxd0eysdl9HGHJcPhjGoHeCaXl5iEDidVsAQ8Cnl1HYaCTIRocLx2K5V2rG5xsIgvbQrfzCPF0EzVdcjFit+UcdMLJHUABm23FO7kEQJVpIyHw6oZlXfyqhKvMOEOEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7572374899106477181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 415e3c59b6a6..0ded1fdd0de8 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
> {
> 	struct bpf_struct_ops_link *ops_link
> 		= container_of(link, struct bpf_struct_ops_link, link);
> 	struct memcg_bpf_ops *ops = kdata;
> 	struct mem_cgroup *memcg, *iter = NULL;
> 	int err = 0;
>
> +	if (ops_link->flags & ~BPF_F_ALLOW_OVERRIDE) {
> +		pr_err("attach only support BPF_F_ALLOW_OVERRIDE\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> 	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
> 	if (IS_ERR_OR_NULL(memcg))
> 		return PTR_ERR(memcg);
>
> 	cgroup_lock();
> +
> +	if (READ_ONCE(memcg->bpf_ops)) {
> +		/* Check if bpf_ops of the parent is BPF_F_ALLOW_OVERRIDE. */
> +		if (memcg->bpf_ops_flags & BPF_F_ALLOW_OVERRIDE) {
> +			iter = parent_mem_cgroup(memcg);
> +
> +			if (!iter)
> +				goto busy_out;
> +			if (READ_ONCE(iter->bpf_ops) !=
> +			    READ_ONCE(memcg->bpf_ops))
> +				goto busy_out;
> +		} else {
> +busy_out:
> +			err = -EBUSY;
> +			goto unlock_out;
> +		}
> +	}
> +
> 	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
                                      ^^^^

When the override check passes (all conditions at lines 363-377 are met),
iter is set to parent_mem_cgroup(memcg) but is never reset to NULL before
this loop. Should iter be reset to NULL here?

The mem_cgroup_iter() function expects prev (iter) to be either NULL or a
previous result from iterating within memcg's descendants. When iter points
to memcg's parent, the iteration will not correctly traverse memcg's
subtree since parent is outside that subtree.

For comparison, bpf_memcg_ops_unreg() correctly resets iter to NULL before
its loop:

> +	iter = NULL;
> +	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {

> 		if (READ_ONCE(iter->bpf_ops)) {
> -			mem_cgroup_iter_break(memcg, iter);
> -			err = -EBUSY;
> -			break;
> +			/* cannot override existing bpf_ops of sub-cgroup. */
> +			continue;
> 		}
> 		WRITE_ONCE(iter->bpf_ops, ops);
> +		iter->bpf_ops_flags = ops_link->flags;
> 	}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============7572374899106477181==--

