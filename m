Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878E4D72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD9D6B0490; Fri, 23 Jan 2026 04:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AC16B0492; Fri, 23 Jan 2026 04:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94066B0493; Fri, 23 Jan 2026 04:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4D8F6B0490
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:29:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D00C0C06DC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:29:48 +0000 (UTC)
X-FDA: 84362706456.30.30FF83E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55B77A0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:29:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="P+Da/JIQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769160587; a=rsa-sha256;
	cv=none;
	b=RQuQlfJYF69ulU6iHxVRiTTpk+wI5y7RzG9Zv85v1AxoMJWwBSiZE9h3DzSMnDyEZmXfMG
	Ef8GvAfMTuVeAj0eZt7KANRQHBPjRXZlGDHy4KyrzP5+4r0HrOoj2zj6htzC8L6mWnlEup
	jKo6vQ1CZhCiU40ABzrLPJze/XdjmyA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="P+Da/JIQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769160587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbplYpl+Lu304xGTqVB9SoG0eUdglpYqiaj68Ma6s8Y=;
	b=PRqNNoiIYm+rRjoN97R/9LePJ2vgHbP9UKghAVYzc9McpoD0g8SyYkwhIz1ktLwhLTb5BQ
	Roa+OwDoAbykV1FXMefbiFO9bRMCHyOlfE6iofILNOmtuenQmYNZaHukkgXK+g0cVtCd5R
	i9u/t/8pG+Qwo1cp/eA8spOLcj5lmiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD75360145;
	Fri, 23 Jan 2026 09:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FCBC116D0;
	Fri, 23 Jan 2026 09:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769160586;
	bh=66bJXTJk22/mLio1RAI3vsCprk6nUWyXhsTyMDG/6mE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=P+Da/JIQVUBFdjvtmkdMKF6CSdvIICA7ZvyHGDVa0wEg3lX968hjg0HzrYc1dY9cA
	 82tsjt/LJncXYHEM2ytyit/TamThZnQoqQWOkSPiXqwMwEOd95l9wxc7pAMiFHADfW
	 IRvr+kW47fQvxH1kFQYIjm014r0sqN7WBVhN4uZkELWsf/oHqk20Y/N2OvivUjNqFW
	 qLXomYcSYWhPgCanwfxrYY8n+ltGd22kDDkB+GOg3v5314j4lfZ078NboWEMtZi0Z4
	 JIHHi+hqh0o0zsdkduLL6j+/y9vYhEchxkVHpomNftsBShx6bQ+Q4Fp+DHNRriZ28d
	 ruoT8dTtoWs2A==
Content-Type: multipart/mixed; boundary="===============7258097213843698012=="
MIME-Version: 1.0
Message-Id: <f02212613904023c5e4f900ee1efdb15e8266c3c4f7d0572db4f515da3a700e5@mail.kernel.org>
In-Reply-To: <863b91cb85097f137bc741e7cb686ff78d9bb95e.1769157382.git.zhuhui@kylinos.cn>
References: <863b91cb85097f137bc741e7cb686ff78d9bb95e.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 08/12] mm: memcontrol: Add BPF struct_ops for memory controller
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
Date: Fri, 23 Jan 2026 09:29:45 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55B77A0006
X-Stat-Signature: 5rypwycntq7inwkc3sfhwqqs8yrf7xq9
X-HE-Tag: 1769160587-816202
X-HE-Meta: U2FsdGVkX1/GqTROaQ1ws6EM8EJeCWuhzxK1fuG+OPtxIeg70C26qAaYaLNvzs3YMgQu14g/ItfNjr6sGYc1QS5O+JwjGH9/Jr4kdVo4maiYadgfVaMu/ru6gErtOtqRGZyHPL4r2vPjIYdZ+g0KrG4TACpEYxFCvJAM4LydycLBYMAVu7RDupWMIf6ESFcoEurq+tEc63JRWss/9GSl1oOwp/Xli7nE0jddzmPW3UW+bJYthX3geGerU6jResfDLRFkhSZ8QkbaughGKVJX523GmvoXr+uJLpZKkSZw8V154J9TiEttKEyRlDz/E+rqQGJgabRLUJwd9J8y2GlZtTBYutxAdvp+6BzZ6R3j2jF5lnY04W6lLbd49IS9lzTVOQ/1LNqFfu2ny5Bd4/Jme/e5YPqDMzmSoQupESkYnt79vBafCz+O5Pj4UM9U7Zr/nagMrhhLU0RPPxIgn3zaeNA3k3ccK0jipAvCJeepvg2RJCexsrxz4JnKRliHybpd33U42+hzbIr48kf1S9mnnrDuW88dC8lP8ud7GKj1MH6FqvujlU+/jy9oGAVLZpSgiiThGWBb9ZH/BdEPPLW+bOv5oWMJ+4vKJsJz+Vf7nrWXKwr76/5QuYb3PRhS45nlSBotAClimfqB+qawW2GRA1cp62QZsvUzi31FuHQW4CuvULdCX5ab+8ZlzEQU0VEsmoPiSvUk+sVK/dRptWAMfKyvngGcIKRCNp2TGK8pOxVisqLSFiGVjkkOCYqGKmjCi7nB1RheVXH+o0IOW1nIUTuOlhXWJJT4ahtDQSJQwtLerMcQP6k714YM0BM7pFnyh+mHBv5GZEfMbmAm5376RLjtfWYNvsQ/lcmaQoWdT3T1prDaflR7+UrFSNu/2hrhGpu54p5CTvbxbImpNV42SzYJdpqZfDYCh0BbAi/w6t9hI2B813oQxUPaCqlGpYPAjukvz+RW8aAY32kHIo9
 tkWxnOUt
 N9jG2Xdv856dDmxstNgbFA3hfe+PR6FAjTVdmrvBuyR6OApg+/TSjUtQSm2t0KcdfoRH1+bttcKZO9zxNjV3u2ew887Z3+GN3eWEx7ORRQIeBxI56P2Xe5JmF66ei8R5cIg2RGu7miQKbLF/X7KtkvwjWes34bmbmLNc2sEKruDVf5MWuyP1VYpdMMXu5oTXA2YkOJKysnvqM1H5RBso2u9GGYorPxqLtDHWH0Q0H4V65ihZAs5tjQ/eRGfU7S401Cn2OiTpm9/dFRZ9o6vUtkfCvKwn7WP52/O/xMbmpZEaCygtLXpOy2cZoTKxUe6NA4UlalInN9ZDKvzjm0A+4Irw6fPkfLbGsrwQYPJ6kvdbzc0sg01boDEZkU9CQd5THl6/7+3wffmYboI2bvCR4eV8fOXqJnSxAfxfS/tDsW9abpeLIlns7NhnseRp5S0/FPPUWu2I6zDEFGCURYNTpwTLMbhI82NWp0paKnA9k/NjVYhZ5b6AxlKukA58tkZEVecBaVMNxpH+SiNsLY+U1PoKdf2AfIyz2s5HIIOrCho+EnuVRPBctWTL8UDTmuKESkuZjEDuAPN5XUC1qjH4Q6OnQt5wr1H/DSUQ34PoD9uch2Qtoyjxwrsuv4C40lF+eDaXi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7258097213843698012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f3b8c71870d8..d71e86b85ba7 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h

[ ... ]

> +#else /* CONFIG_BPF_SYSCALL */
> +
> +static inline unsigned long
> +bpf_memcg_get_high_delay(struct mem_cgroup *memcg) { return 0 }
> +static inline bpf_memcg_below_low(struct mem_cgroup *memcg) { return false }
> +static inline bpf_memcg_below_min(struct mem_cgroup *memcg) { return false }
                 ^^^^^^^^^^^^^^^^^^^^

These stub functions appear to have syntax issues that would prevent
compilation when CONFIG_BPF_SYSCALL is disabled:

1. bpf_memcg_get_high_delay() is missing a semicolon after "return 0"
2. bpf_memcg_below_low() is missing the "bool" return type
3. bpf_memcg_below_min() is missing the "bool" return type

Should these be:

  static inline unsigned long
  bpf_memcg_get_high_delay(struct mem_cgroup *memcg) { return 0; }
  static inline bool bpf_memcg_below_low(struct mem_cgroup *memcg) { return false; }
  static inline bool bpf_memcg_below_min(struct mem_cgroup *memcg) { return false; }

> +static inline void memcontrol_bpf_online(struct mem_cgroup *memcg) { }
> +static inline void memcontrol_bpf_offline(struct mem_cgroup *memcg) { }
> +
> +#endif /* CONFIG_BPF_SYSCALL */

[ ... ]

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..415e3c59b6a6 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> +static void clean_memcg_bpf_ops(struct mem_cgroup *memcg,
> +				struct memcg_bpf_ops *ops)
> +{
> +	struct mem_cgroup *iter = NULL;
> +
> +	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
> +		if (ops) {
> +			if (!WARN_ON(READ_ONCE(memcg->bpf_ops) != ops))
> +				WRITE_ONCE(memcg->bpf_ops, NULL);
                                         ^^^^^

When ops is non-NULL, this code checks and writes to memcg->bpf_ops, but
should it be using iter->bpf_ops instead? The else branch at the bottom
correctly uses iter. As written, when called from bpf_memcg_ops_unreg()
with a non-NULL ops argument, this only clears the root cgroup's bpf_ops
pointer while leaving all descendant cgroups with stale pointers to the
ops structure that will be freed after synchronize_srcu().

> +		} else
> +			WRITE_ONCE(iter->bpf_ops, NULL);
> +	}
> +}

[ ... ]

> +static int __init bpf_memcontrol_init(void)
> +{
> +	int err, err2;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> +					&bpf_memcontrol_kfunc_set);
> +	if (err)
> +		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
> +
> +	err2 = register_bpf_struct_ops(&bpf_memcg_bpf_ops, memcg_bpf_ops);
> +	if (err)
            ^^^

The condition here checks err but prints err2. Should this be "if (err2)"
to log when the struct_ops registration fails?

> +		pr_warn("error while registering memcontrol bpf ops: %d", err2);
> +
> +	return err ? err : err2;
> +}
> +late_initcall(bpf_memcontrol_init);

Note: The clean_memcg_bpf_ops() issue appears to be addressed in a later
commit in this series (90eaa9cd0346 "mm/bpf: Add BPF_F_ALLOW_OVERRIDE
support for memcg_bpf_ops") which removes and rewrites the function
entirely. However, the syntax errors in the stubs and the error check
typo in bpf_memcontrol_init() do not appear to be fixed in the series.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============7258097213843698012==--

