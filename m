Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF2EC88E7F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DD26B0089; Mon, 26 Jan 2026 04:30:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C0B6B008C; Mon, 26 Jan 2026 04:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FC56B0089; Mon, 26 Jan 2026 04:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C68A56B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:30:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CF58D385D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:30:29 +0000 (UTC)
X-FDA: 84373594578.20.9D83828
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B744140010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:30:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=VvfjaY8A;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769419827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DArn0BEzPa5gTpJkk5L3PmprLaFFZQbaVNBXRG224XA=;
	b=BQ0InbppARaoS1leoJfmSo/g4ldlEWVadDw7NUZxxdem88g8x3ulhDLfw5LYXGi29FbQ5z
	muTCcH8DBQMRij/WVPBGCLxfZMCFCNW3kpxWZiYIgrH2Df2WX6oYK+VMpIxfHizeiWS/9C
	7FZ+IBYNhmt/6GH3REBTOiXFpeJ3ZGg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=VvfjaY8A;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769419827; a=rsa-sha256;
	cv=none;
	b=j1GEdA4TXIbICqoQx0MOxtk25BDEZw4OFbwhSAUTFHqf1OcDS0mXy8z9Iog0B1bDIa74Vx
	0htsT1yzjkcpxKv68ogKGUO2WBxOJJQtlz5uz16kMMQQM6nZd3lhuzKpP2AdyltRKYlMhL
	Koz5kihvIiUCFJYy+RzNfmwd/AQ4izI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96FB9440BE;
	Mon, 26 Jan 2026 09:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B83C116C6;
	Mon, 26 Jan 2026 09:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769419826;
	bh=aQuK0odfYbvA8lTK4uctHrzL1AwniMgbpNZoaBMehIA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=VvfjaY8AH+LnK/kCrvfPPmglYSpdx/2IxA8NwM8wh66Sej+rHEy3fawSM7F7aBmu1
	 6hV/E4PkTZQI6jgqLtKEo+0D8nJk8JLsNZl4rdq3jdu6XxITZy0kr9V8hYkW/ciW8d
	 JSHUoPYn2GY7UuosnQtIzPxrniT/tat3MrDzaM24lt8F/ylil/Q1qwqq9NCxdKSa2B
	 DRpWivblKgE1dC5BAROK2xz62zFqp/rI9bnxM9JR2VJe+PLDOzmx9ioDBboKJfACzh
	 C3wOzqRYONoZMRXHuNovaxLLK08RqIfJ8U2I6O4RbzGNvr090R7tdfaTKULw/kMPXz
	 /vTU/pwIBAyow==
Content-Type: multipart/mixed; boundary="===============2507318955601397522=="
MIME-Version: 1.0
Message-Id: <dae9aa2f4d4de48d86d1e65ab1ce73e01bcff2d003361feb26d06d91eb15b6f7@mail.kernel.org>
In-Reply-To: <e4c02c0f2673ade0b6e0c254605e011385b744df.1769417588.git.zhuhui@kylinos.cn>
References: <e4c02c0f2673ade0b6e0c254605e011385b744df.1769417588.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v4 08/12] mm: memcontrol: Add BPF struct_ops for memory controller
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
Date: Mon, 26 Jan 2026 09:30:25 +0000 (UTC)
X-Stat-Signature: mmdoi3cmg435b4jiqi7b6g7hncuyd433
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B744140010
X-HE-Tag: 1769419827-15024
X-HE-Meta: U2FsdGVkX18RemHcmmQjmtqSImFB3/e6T4QDO5VEYnSw/KbLBr7/yFxin8jdrS2R88OSFWFIJ5h6tjHDIh3X5CSuTJlarqwUfz6bQVoON79rdqW9vJb+b/l9Xg+O9atStcLe1p1S7fj1xqP8vq6jB/26KY7z8nc8dJrReWXnqqMnlQ3YMNqG7KGi6LISwyZbH48nSsSEcwOBYkabkZfRgtONXY53J2bHNkOOUcpATY/uk7M9v9QFJD9xnPO/mwf/EjfwrynfU75le91j6P0NIA8fmw0LFMYqrex8gwUKLM/iYG+ewfVRUd87910EHRtWQTgrApQb4aLv5IanGfInFyALC+IZ0ydyrFMwerC6xiwd85UaVFu2y4ASp3Ry7KmVa8qDBIuAkcmJ4Fs3zEjYjI5KJoRrV0FCqGjnzVUEvTejpKBGPpMJ20FJx7HzLESW3IjCIhitCGa7kiC/j4ZwWi6DIrrKdR5MU8kVTk1aI7fa04rqpcHYXimVuqDPP+5/I/AS4G7wgpmeFouDZ/OUsPtGOqQSTiDARGb2Hym+BispFNDvzvLPYX2ehovpfBaZ/3UTmmQin5S1e07PirpblAeBtX0IjI2vSI80A9XqjUM/BRAX138/pMFGe+fKcAprMEuFylJA145OLUA1YhXodPMJd8bK3VwDIZSveLtKuTDNntAIbjG/EyAPD/RvNTOpaR2nb86+XMTorcoRBXh5HpcJC5V/WueAFsKGm5ASUL8J61wVsSQZDURkN3z3lt9hfKKtJkgvN92tLTRrVnLVi97IQZkhV5COFQgHbxLVoy8PRoYhR2MfFQo3laOeQUrAigVB2JtTHMK2qGQS9VTl/xaHZocoSYI5nPN17Lgjbk/4mOJugevC3/GX+K0viKvMLudhJJY8LqYLbV/KpPS53/5HF2q6kteZqWkv4+50I/VL8lONWAlTMXHOcRQWg9ZEDP6OkUxXAfyMYCEgM7s
 RMKqzOep
 IanqVpPKBLOczfWFtMlLQ7UPCbHuS+kPYdPpUxQ5D+Doh/2hxVrrISxgpU/L6BVIW/xlrJSl9FNPmV116ywf11AvTsrqVA0I1MiI+72MbPoVMz9My6uSPTf3QsERODOQGo8hbBhn+v3A/fzzCiKJR8/CZ39Pp5fX6K0Y7O3wi1wyeXQIbSb5tXuwYFFZU0ShnDgkYEnpPXXArqp8l8LNzTorhQ2bQtndPK5CMoM74QNru3I82QAxabzmsh73VZ7ees+UmQG+8p5HvSelVStS9upspUEM2QrKmTw0ACMuMxdkhWt82Ps422NLdKIY5IeJIC5RBABDXbd5+aSJ8sZfv169x0djopdJwNF9ehwfUck33BLvkPSCY735vuihcFjXoqOcBEng+A7Mqr8PyWpQR+4R0ErEt2bVU6k7c0D4ScqXIWAazLkgl8/limLa7tPTfhLJgybDWeiGmF7Xh9aY43XeTdB3SjU5OkFLLovC3Y8VGtGiAvTO+3F7wpipMfzBUXz6a5oSQJaN+0ipyk3XYTvCIcsHmi/Il8TbBSj0qFqEztw0qhHLHxag/rxPF+RnqYPcYr0UBWnp+JteoQVVtnCTQGim3h3w09cwYGiuSTm3LXBq6+l7wG6HwovnaogmCYi2o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2507318955601397522==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f3b8c71870d8..1083be5d0362 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h

[ ... ]

> +#else /* CONFIG_BPF_SYSCALL */
> +
> +static inline unsigned long
> +bpf_memcg_get_high_delay(struct mem_cgroup *memcg) { return 0; }
> +static inline bpf_memcg_below_low(struct mem_cgroup *memcg) { return false; }
> +static inline bpf_memcg_below_min(struct mem_cgroup *memcg) { return false; }
                ^^^^^^^^^^^^^^^^^^^^

These two stubs are missing the bool return type. This will cause a
compilation error when CONFIG_BPF_SYSCALL is not set. Should these be:

  static inline bool bpf_memcg_below_low(...)
  static inline bool bpf_memcg_below_min(...)

> +static inline void memcontrol_bpf_online(struct mem_cgroup *memcg) { }
> +static inline void memcontrol_bpf_offline(struct mem_cgroup *memcg) { }
> +
> +#endif /* CONFIG_BPF_SYSCALL */

[ ... ]

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..20c5c3552ce3 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> +static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *ops_link
> +		= container_of(link, struct bpf_struct_ops_link, link);
> +	struct memcg_bpf_ops *ops = kdata;
> +	struct mem_cgroup *memcg, *iter = NULL;
> +	int err = 0;
> +
> +	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
> +	if (IS_ERR_OR_NULL(memcg))
> +		return PTR_ERR(memcg);
> +
> +	cgroup_lock();
> +	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
> +		if (READ_ONCE(iter->bpf_ops)) {
> +			mem_cgroup_iter_break(memcg, iter);
> +			err = -EBUSY;
> +			break;
> +		}
> +		WRITE_ONCE(iter->bpf_ops, ops);
> +	}
> +	if (err)
> +		clean_memcg_bpf_ops(memcg, NULL);
                                      ^^^^

When registration fails because a descendant cgroup already has a BPF
program attached, this calls clean_memcg_bpf_ops() with NULL. Looking at
clean_memcg_bpf_ops():

  while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
      if (ops) {
          if (!WARN_ON(READ_ONCE(iter->bpf_ops) != ops))
              WRITE_ONCE(iter->bpf_ops, NULL);
      } else
          WRITE_ONCE(iter->bpf_ops, NULL);   // unconditional clear
  }

With ops=NULL, this will unconditionally clear bpf_ops for all
descendants in the hierarchy, including the cgroup that already had a
different BPF program attached (which caused the -EBUSY error). This
would incorrectly detach that existing program.

Should this be clean_memcg_bpf_ops(memcg, ops) instead, so it only clears
the ops that were written during this failed registration attempt?

Note: This issue appears to be addressed in the subsequent commit
5f3bb9a8c33f ("mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for
memcg_bpf_ops") which completely rewrites the registration logic.

> +	cgroup_unlock();
> +
> +	mem_cgroup_put(memcg);
> +	return err;
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21352241149

--===============2507318955601397522==--

