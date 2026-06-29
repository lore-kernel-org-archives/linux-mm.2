Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFC8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE81A6B008A; Mon, 29 Jun 2026 14:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98FC6B0092; Mon, 29 Jun 2026 14:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989156B0093; Mon, 29 Jun 2026 14:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E78F6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:14:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E625D1401B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:14:41 +0000 (UTC)
X-FDA: 84933750762.02.E4704B6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 099E1C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:14:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QIMvql5e;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782756880;
	b=BT9DWZ2YjwOTlVasY1MQ1MJmDfhfh3GCYU1y/gkpfMF7AXw4jtggDMbffS+rLjyOTVvdam
	7Qa1WzJ/aXiXIAixCOPASv3oaHjSw01RMqiOv0468IFM3JKq6Tx/PvKc2LMm7oipuRGJEj
	oUhoFUSo7wdpRRavZrsD0KB8suj5xeY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782756880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6kHm/79xhhemc0kFX5LJiBZDJ+K1Gs2+S0vOgP3nJ0=;
	b=OfdtbQAHv7jtvLAaZok7k9xPrHtf+ruiUxvLx1aNyhVExBD035vSXse+NqNxNLSmiIYbhg
	OUZkwMCvWwyfNzZ45uDq0jIqV4Zrs7RYIA/IolNArhzcBGjm88YTAdrfe4ST0YvO4egYKZ
	XQC9WlYbLNpj9l4dmIbH1eXcGqOV1wE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QIMvql5e;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493b77b150aso3277285e9.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:14:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782756878; cv=none;
        d=google.com; s=arc-20260327;
        b=T6IaE7JhglOVzxiOSxQNcpGvsD/9qnNaotIlGJwWoAtzwfgaYON3CDlM2lxdRwStEd
         Npq90qIj0jvzNTkzl255JMLHs5EDYnUfichCXSpdDVMsFeN8qEjCD0Scwyk1d+5Edj82
         rD6iFOit4cA909RV5Y/X8DFcSPILK+6tzXESkyildmYhj9BjBjog4ourMwu322k5bhmi
         EJfFQYmAEjaZxE+SOODM2MTiizWeDqvw6vQoYWxcBZjPcFjZ44atVFzPd6i3+jWuXEPO
         ERJMauAD4tw+hvSjQHASgkfydDbyt3Sz9Ele66y/4uxj/tSlcNUzMBHWyPF4vurK59d/
         Rv1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z6kHm/79xhhemc0kFX5LJiBZDJ+K1Gs2+S0vOgP3nJ0=;
        fh=y4iYWuky34sS4Wvr9gHBGUIL0kF2LVNg+hm9W5iFLrg=;
        b=rlwFhSerSwiBW/yDT2VVFr46r5lK9eepz/6Hgtfcw0tOqiClY60dJFv8k7b9Wwi54o
         2x+ow+H+WjwNynewzUhWIEgqFmEH+VoUqbFd2Jv9bjLpRoQMKeuHODC/9wzgyb7mfVDx
         k/dx7nZAtwj7kI9DRAY/oTooq+ogLv7QI9Hqhz2EuwguTRi5rInFLKTn3sx4A825cWRi
         7xWsHjvuwIxA9vCEQgKyFjEiM38yQWUeybp7XuNHQb8GIhxSZ1muG3DQgVqbiVQIKAPR
         8ABBK2WrDsVmqK6DnLJ/dKeVfvdYAp3uU/wmUzjy8fR3g9IXsnwuL4VniA+Z35G9Y18c
         r38A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782756878; x=1783361678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6kHm/79xhhemc0kFX5LJiBZDJ+K1Gs2+S0vOgP3nJ0=;
        b=QIMvql5emlfvfHHSY4qH/Hq4xEu/MmuVrngF9WhQylE/LY/zFmmirPAeTJpfMGZa3L
         peJ8X3HWOg1nD9YCoDTcROY7W9fozl0fQLPg8Ltzyz86q/BYidhrs5xCjH9nnmMsyK+V
         iNQJDRehW8EZ6T9U7fyOhVDrvC32aSi6Kr5cAEaWXEC07kS4JOpTUNsjljjxgaMr0YKB
         Drzs+62JwEwyuQMNZqRsi2X/w/dMTR7Ah+62FuriTZdawkvxbtPaktjzOX9wsUTSv3YY
         77n8xt+6IAeyyrJgYBvN9DBeEMtVu4niIJjNhC0NsxYYl0IryvbwarHJUcoAtxDXzy1V
         y0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782756878; x=1783361678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z6kHm/79xhhemc0kFX5LJiBZDJ+K1Gs2+S0vOgP3nJ0=;
        b=fot6fFbYahUW23vlFoSeWJREvpJqQYhlRIavEDLBMlvxurTv/QbelJkkL4Hg27ZxRg
         2F8a5ohjf5yUch4b8dnHW+sU/tOaHiiU/lAD5IEmUfWRXLOp+2UG6ogE997LUwkhvNOk
         CC7ZuB/NTvR9BUmZN6XV5+8YA4evOLSvPT0oDWdMwd4Ya3xguOwIpLka+FnQK9gMersC
         fG1Bw59HaoDrJ9dyFyP7awPsuzARweOifVA6VJqNe6MNNrxj86XQvVz+bESs+T8hXcnp
         r6LSGwrothOFkCRFK0mFzE2ecDpgbkMk5y2nbGiZQVT5wh3CW72JTEn3vASKVXFNVM/K
         4FTg==
X-Forwarded-Encrypted: i=1; AFNElJ+Q1bDdpiavgabOshgmMrtcnxQIKBAi/l6vCw6uDjTSMFpIbPh8+6g6ijR48Sx7wpJqtB7VMWdVmA==@kvack.org
X-Gm-Message-State: AOJu0YwkzgLaKqCULbHlMEWwwQ5BELfJWk5sibg+qCV7+l+PR8+u74SS
	Qpnn5nXS/BKRWyNGtEwTOliEwsTRs9SMfod/xDHDeNS9Df5kPjzIxo9/jxiC059nXN1aNM0OM3H
	2AonJu4iDsTue2lD/avdg4oHs+3A8zWM=
X-Gm-Gg: AfdE7clQ4pJp6God8FeeK3lrtbgDc+9Mhk7Gnrctm+9XpZOBzNIfpWgzCs+6SaNvnVe
	MbX2ajJF/Y3wJbPeYOXtX1REuaPmipxV7JAPjERwakpusRsU3cPIbnU7f2I+5svdFxCreRiiqRV
	z0RecQrc5OaTQKuKAUfk1j4wIlPL7sMTe65/M8ywXExoQlSeD8bel1NFzdq4hKcOEbuTCOVqY8W
	T5V5xf6zYKRU8nwPetxDV9UrShXNLhLf0V34d5ks52RYYvxUI0TOku37tXeRSiHr42UvFa8AbFS
	vdVPCrPqUuIamdzIQPe8h+SLQxKs
X-Received: by 2002:a05:600c:3e86:b0:493:b877:fbc with SMTP id
 5b1f17b1804b1-493b8771027mr9738285e9.21.1782756878495; Mon, 29 Jun 2026
 11:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260626143244.3382853-1-usama.arif@linux.dev> <9a8ba4d7-07ea-4ec5-b158-39fff4796f84@ghiti.fr>
In-Reply-To: <9a8ba4d7-07ea-4ec5-b158-39fff4796f84@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 29 Jun 2026 11:14:27 -0700
X-Gm-Features: AVVi8CdxW7dOj6xPHpW8RCxJsaYfTZ6ZpXAfESXVbullYLLBxsnotuCt4ayOILI
Message-ID: <CAKEwX=PWWSF8+LK3_ZDiKiBu79d69uzDL3kUsCaohmVe=v6Wwg@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>, alexandre@ghiti.fr, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Ben Segall <bsegall@google.com>, cgroups@vger.kernel.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Hildenbrand <david@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Kairui Song <kasong@tencent.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Peter Zijlstra <peterz@infradead.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 099E1C0003
X-Stat-Signature: pxxymfbke9fxa4osyy6enbcxx9okudmk
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782756879-264061
X-HE-Meta: U2FsdGVkX188e7Tscn30xmpdJLz8wrWfkW+9YGPsRR+0V+V1mPiO5/yf9VOxVHbaO7DAyS6c4OTf/zo179pXqeXMag7vyhLWmcpcSIFu96x1VGOXxomHpmPore1D2Vg1ckxwRtuTb1iYcZjFjb9aisVDmjNV+3rMUsaQ8FantaoqrsqTi8WeCmS/KshP0Wdty1k6y2oKdypYQDtFnBPL75M6Vn2uURPuoU6eHUnOaQKnoEvk0fSrdV5V8KStkjXNy35yTgNn4mt/mdCOay+P5uKJaQviIavl74yIustYQoYFIxxlq6nzLpjWXBbt4AhJ/XIrdKUMp5nZZJx64WD3yZfPXvS3An7/4y1c0d1sq87oH7jX6Jorck2PhlHt5Un81aXK6DKlyO5ibm80C2qF59bER/Qsq5ZJpCMIMf8Rp6ZSTdGLLQXd3vCP13KszLBbsRA7sDxwtWL032lKXoY+efZyqd44/qwt3ru5e2+rnOkCaS8UKkGVtFfvz2Ee+ZmBW+1sN/BZ1F8O3jAXp1GZ61gFD/xqkx6rO2O/KwLgN8wmmAPT2yFAOuNrjEOcSLyy0ugLuujPajo2SwPn99oZ3NkSfnpQePStY9X4dclllyFgv36E1Em8DZ/CliMkXG7otHoDyTceII2GbIxJnwrkwnqkrGyjH1clLSAXuxNv3SxG8CFpWPHAMGAfUHQS5AqFRE76zyOyPmTgOkSeiw7pDCwbjh5LjoEkOyDSemIVNd8eQi16JNeOYC+QqD4/YHI0SdwpI0AXfsyg2Zs6xzZ31g7TuZ/WhXDA4Uorkqwuw3eJikAKd4NtgPER4Zxzw13BCGlXvDUALsBEh9svvhGBgc/SpK4LajhRkp/DX54h+VNUOZ0qxVxOoTZfqobDmwSkGWmVdtcSKb6+mS04Jg75e+M1cH1B+lstC1sGgcjpjrlPKasgPnB2AOGqRxKAS8wE37eVdBDlt3rOvZwwAtT
 pLYEH3T7
 dLsL4rGRes6WArF17ULzLheSD3+G3yo6HQRWBAN5NFOIvi3LZ1tyUE827mBvc+yi3+Xf8kb8/yfHP34wlDcw6onrPuj+mUpP3hF3kdqCAPKNk+O/gpg2Gfu48RCfm37VtZgbhNEszpRGF3oa9VVIzCNorOPWKD0aGWOlmu0c+nkKCtsTy9LGSP2wwE/HEVxLJh/IM5yUDVf4O9KwjLA1Z8VqabWBTk3fxhqXnqbyjwaG+d1DDjj0q1ryDMDCo5QXDxx+LF5mWOpJazrf2VphigeCu+LHaHs/gaxn4nWzR2pdR6gdw6/RP78Usc+RKzjYaQV8DhfjlxZI7iHKYtCAcnuJHLumdtjEUlpM1AYvUI7XFPIYqHrkG4BK24HN1yBRO1geYCi4HfOKCUqnM9yvWd74YXNPoBIhB0uE173azZh1Q/KV1WwoohisslWa1QLUPwN4RIfSGKM3mA4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 6:14=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Usama,
>
> On 6/26/26 16:32, Usama Arif wrote:
> > On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
> >
> >> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
> >> accounting, attributing compressed page charges to the correct
> >> NUMA node.
> >>
> >> But actually, this is incomplete because it does not correctly account
> >> for entries that straddle pages, those pages being possibly on 2 diffe=
rent
> >> nodes.
> >>
> >> This will be correctly handled by Joshua in a different series [1].
> >>
> >> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua=
.hahnjy@gmail.com/ [1]
> >> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> >> ---
> >>   include/linux/zsmalloc.h |  2 ++
> >>   mm/zsmalloc.c            | 11 +++++++++++
> >>   mm/zswap.c               | 19 ++++++++++++++++++-
> >>   3 files changed, 31 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> >> index 478410c880b1..30427f3fe232 100644
> >> --- a/include/linux/zsmalloc.h
> >> +++ b/include/linux/zsmalloc.h
> >> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsign=
ed long handle);
> >>   void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >>                void *handle_mem, size_t mem_len);
> >>
> >> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
> >> +
> >>   extern const struct movable_operations zsmalloc_mops;
> >>
> >>   #endif
> >> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> >> index 83f5820c45f9..17f7403ebe77 100644
> >> --- a/mm/zsmalloc.c
> >> +++ b/mm/zsmalloc.c
> >> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned l=
ong obj)
> >>      mod_zspage_inuse(zspage, -1);
> >>   }
> >>
> >> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
> >> +{
> >> +    unsigned long obj;
> >> +    struct zpdesc *zpdesc;
> >> +
> >> +    obj =3D handle_to_obj(handle);
> >> +    obj_to_zpdesc(obj, &zpdesc);
> >> +    return page_to_nid(zpdesc_page(zpdesc));
> >> +}
> >> +EXPORT_SYMBOL(zs_handle_to_nid);
> > Does this need the same locking as the other handle-to-zspage paths?
> > zs_free() takes pool->lock before handle_to_obj() because zspage migrat=
ion can
> > update or move the object behind the handle. This helper does the same =
decode
> > without the lock, so zswap's uncharge path can race migration and charg=
e or
> > uncharge the wrong node, or observe transient zspage state.
>
>
> You're totally right, I missed this, thanks!
>
> Thanks,
>
> Alex

If we are to do this, is there a way to extend zsmalloc's interface so
that it returns the initial node placement together with the handle in
zs_malloc()?

That way, we can avoid going through the zsmalloc locks again. It's
quiet expensive, especially with compaction in the picture - the
pool->lock is a global rwlock :)

