Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73C4EA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289A26B0092; Mon,  2 Mar 2026 10:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B846B0093; Mon,  2 Mar 2026 10:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182166B0095; Mon,  2 Mar 2026 10:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED9456B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A79FFC0A90
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:24 +0000 (UTC)
X-FDA: 84501567528.11.A8EAFDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B90CD80002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eCB+SkR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyfk8Ct0gbq0nakfN24rSGwTY74ocAXMAVYAL3jugUU=;
	b=mC2SOXTvc4vx+AKcwix9tKaQFIYjRp0CGxes2t8mF9WyVjihZAcB++VHlD/C1NMx2evYAu
	3RBSjvH4D3qDPAbb0ci0mLb/VARuNe4iaXlSjJjfmDmaWh08kFTF2x51qewSWUw3/9XlJ3
	Elgb/c7xhiZLpTbse7nIuxC16oSfCNM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eCB+SkR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466802; a=rsa-sha256;
	cv=none;
	b=jl1sLkp4QBXCEWYb8hF1zKxqz5K+F71g+Tgb1P3r6oCcov9zICenoFW8KE5BfaQjqRk2C1
	NCjRV9krJvUgUMTzF3/zxQCvHGsW8LqIMD7IWby57A3vq9cba7rL54aGugngG4kr6VUjBs
	zPVDzWk34UidMvm67zkrnKMvV8Em348=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD62A44501
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FFC2BCB8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772466801;
	bh=Lzcw9bSxmejm0gJDOTach+8XGgnELPRdfMZnwQFuwiY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eCB+SkR+v2AojvuGPK20HGDla7EykNAGMD5qya144xypRtN5GzUmuArNyTTTiJaFs
	 6IIYsGXW6bpBJvgMIwI/dnIrOGTDYgDijE01p81q0RHg6e7tLEuTtW3wI/qAF5DlCW
	 hwER0nCkM02bkQ45v78lSXTUHYd0U3U/YjmRTQOFs/2zSn3+MOoFDt0N8RyXIba0i4
	 GVpEMeLV5gN1v3kNRfJvfhsR/754C06q7sGynIQUOjasUyfRJgLQezitgBTEr+Z1dq
	 xdeVlklYTDmUz4N4SboVuIeuyscuKyaEc3qdtfg6Rnb0kjIR7kdTMU6ifFdnVllAHc
	 G+S+E0noPWL/g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b93698bb57aso99704866b.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:53:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW4VaUdqCSLhmmwWjKuNTH7KLIKCAt72vo+G4EirmyNxRDCjDRhkJ/N0hbKxSCSB4HV3sRah/LBYw==@kvack.org
X-Gm-Message-State: AOJu0YyBRlWHr0DV+yavkRyhSAoy5/rPcCriOqH8aewmTQKj+8kiA+0p
	0wCe7Y9qcD0F5VAKO0h57ALbuR5fFfu5IyUKabu8cGUEabDDbvdRfdMlwKAJs3UjAhw4cXljbQj
	BggbXF2Vba4MZw1IiJU7Ukb3ww51zF5g=
X-Received: by 2002:a17:907:7b8e:b0:b8e:a126:66be with SMTP id
 a640c23a62f3a-b9375932a96mr906965466b.18.1772466800366; Mon, 02 Mar 2026
 07:53:20 -0800 (PST)
MIME-Version: 1.0
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
In-Reply-To: <20260228072556.31793-1-qi.zheng@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 07:53:08 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
X-Gm-Features: AaiRm53G0wvbwkndbhtmVzlFp2bgI26S0fTTYledhanzWTm5GQC0n2lE4RDJ0yo
Message-ID: <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B90CD80002
X-Stat-Signature: 6qxc38megj987uzb3iifpu3zoq7t1zdo
X-Rspam-User: 
X-HE-Tag: 1772466802-953639
X-HE-Meta: U2FsdGVkX1/eOHatGdAEMGByj89fJ3vBdw/xggoxmRIh9Ba+wo/Cy08LIppYxCLhoK/6/ckwCMESboRQgVvfF/upymT3eh6721dVomevyS7khSGt5DPuO4pBS6OFYy71ODj2bcIK4EU1uF6pZDFiocaS4Yt1/ZbpVOwgtNup/ZHQrKB+n18R+J6Xr63gnAPHaDH0uWAx42cNTRs+2qkkux9i0OjoiB+/QNkrvJbTlLl+WPYM7ZsDRb698s6mH5BZRKROuo9YUaH/wTprl192DsJfEjUJCNNDaZvEp3GaemOChn2LeyoRT6wNgNIZIXF/k48eDdECAoD5T/k97SkQcBdv5qA2yycGH2VgrGZJuIEOl16+DgFm5GdfoYQXCHIIpn+Qmix2uhsWR9oGNb/i+2unrkJeCA1dRLfmVUZ5+stW95wDYIP8T8Nua1BY88h27Ncn6bgCfO2g57LvGnDtcRj7d1H9VJBEHkey2Ss5NLMisvCs7Ispqo1V3dwTBCNJc+OAYYrCG9sDYvsWTjrApmB1xCPskgl7Ib0aEq/VdPG2plgBehFMLUDIAKxonDgsos8/G2G1WrVbUW2Z83cgiC+ID0KQWUfmscMMthNELuCl5w+I37MfKP8Z0wpSK4glgg7aEo5zr2owMhQrJ5QX+NgBDvMwSYoPudVJTOiGv4S+kRIzcpKBdR0yko3USus13fO1s2tPtJgkLgnNjg2pr6WXBd5z8A4BaP/62N6IkNgn2eJ5iSizsiJoQjIOYdyjbSKMIdwPxrjccR7lzOy9QsG5GDbqHK7E4y5olrcVZvmCB7WET+ufyGxEOo/FZDHxVmRweputFYwVI5V4rMyMOrt8JTICY4Ni+K9qJW/8y8F8wWpUx6Pd2tpAR8XUl/7M6Cz7lJeOP9VUvTYIbf5D1TUDiPdRWXx0vZ+RDhZAZREb6XJVhAgO2oE1K/Zv6+W8ZSMUjdYdqTqCYAhxGGc
 1VMbqa/s
 2HCcPqIhKUD3iJM5Oi13lt3YYQEC/L0QaagvUZweYbeQ/NTX5fmA3qSkKFXXRFoBekKOUKUfx9Nnvmuxc7Ory3vxne83ANO2T6KkUVNIxt9eIWVJqBrOwSP/jB3YysQR2XLS4SkDwU46hei7IPC0DMxkFbaGAM5B/28bB4srVkXv9tCcWaM0wOflkzX9ADJKK74sIgQ7PGzf70ZYbWKNE7CgT9FWQgi8gtTYXzE9bX9omUMqtTTiGpK0jL8MRY7vnFNIirhDgdht7BWb3Ts+9QljMMV8fk27dGv0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
> @@ -763,6 +851,64 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
>  #endif
>         return x;
>  }
> +
> +static void __mod_memcg_state(struct mem_cgroup *memcg,
> +                             enum memcg_stat_item idx, int val)
> +{
> +       int i = memcg_stats_index(idx);
> +       int cpu;
> +
> +       if (mem_cgroup_disabled())
> +               return;
> +
> +       cpu = get_cpu();
> +
> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +       val = memcg_state_val_in_pages(idx, val);
> +       memcg_rstat_updated(memcg, val, cpu);
> +       trace_mod_memcg_state(memcg, idx, val);
> +
> +       put_cpu();
> +}
> +
> +static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
> +                                    enum node_stat_item idx, int val)
> +{
> +       struct mem_cgroup_per_node *pn;
> +       struct mem_cgroup *memcg;
> +       int i = memcg_stats_index(idx);
> +       int cpu;
> +
> +       pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> +       memcg = pn->memcg;
> +
> +       cpu = get_cpu();
> +
> +       /* Update memcg */
> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +
> +       /* Update lruvec */
> +       this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
> +
> +       val = memcg_state_val_in_pages(idx, val);
> +       memcg_rstat_updated(memcg, val, cpu);
> +       trace_mod_memcg_lruvec_state(memcg, idx, val);
> +
> +       put_cpu();
> +}

I don't think we should end up with two copies of
__mod_memcg_state/mod_memcg_state() and
__mod_memcg_lruvec_state/mod_memcg_lruvec_state(). I meant to refactor
mod_memcg_state() to call __mod_memcg_state(), where the latter does
not call get_non_dying_memcg_{start/end}(). Same for
mod_memcg_lruvec_state().

> +
> +void reparent_memcg_state_local(struct mem_cgroup *memcg,
> +                               struct mem_cgroup *parent, int idx)
> +{
> +       int i = memcg_stats_index(idx);
> +       unsigned long value = memcg_page_state_local(memcg, idx);
> +
> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
> +               return;
> +
> +       __mod_memcg_state(memcg, idx, -value);
> +       __mod_memcg_state(parent, idx, value);
> +}
>  #endif
>
>  static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> --
> 2.20.1
>
>

