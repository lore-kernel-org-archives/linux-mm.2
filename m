Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC097CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FE8801B1; Tue, 28 Oct 2025 14:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA23A80199; Tue, 28 Oct 2025 14:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF68801B1; Tue, 28 Oct 2025 14:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A273F80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:42:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C221B9E9B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:42:38 +0000 (UTC)
X-FDA: 84048393996.02.EE55520
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79C3CC000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:42:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QEm//4JB";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761676956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UViaiKs97AW130sd1Pv1jMx77Woc0mLfVhtIKZNEsXs=;
	b=fnoL3XLo8VMMvJI8ILrI6BiHGhEDdEM7W99ijZdF0hE4X72kGT6naQAH6U02/El+Wjc0fG
	iNE1t+DYgIfy2mokD8sPWClcAPOKSjqet5PSYpMrCmNbve4V1t+Zua/h+fTslyFvxUGJju
	H1tdyX2AhwEGiYQGLqAC+1Tkqr/9BHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761676956; a=rsa-sha256;
	cv=none;
	b=pYbOLqfRAOJS/08CkGsPzF9ELhRR/3Nl7n/8RIwdeYgVh56r6ESYAOZ87Oew07n8bUwH2C
	r3J3nhWzK6/MAxt9Mhorm7Jv8BhzGiWKCz8gbZAIIYGl8k88ZEoPcMQZb0bUhHRb9RN71n
	8qE10h+xIkSH8kCVmgVa4qeS1nLCwtY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QEm//4JB";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761676954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UViaiKs97AW130sd1Pv1jMx77Woc0mLfVhtIKZNEsXs=;
	b=QEm//4JBVdHkp2n7eP7X+898pDWsbWkilRRDP2Ko/YBBo6UKw+UvVX3Asjh0e0UdJCN+6S
	XOW0V2qu7Tgb+4tEk+vQISKdEdrf+L5RoaD4BtgsZDvTLR8ELwpryoEoajOe5DLGs14lF5
	fTvPlRyjeTam2lyXWMYKq7qIpjO4VBY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  LKML
 <linux-kernel@vger.kernel.org>,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm <linux-mm@kvack.org>,  "open
 list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,  bpf
 <bpf@vger.kernel.org>,  Martin KaFai Lau <martin.lau@kernel.org>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun
 Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <CAADnVQKWskY1ijJtSX=N0QczW_-gtg-X_SpK_GuiYBYQodn5wQ@mail.gmail.com>
	(Alexei Starovoitov's message of "Tue, 28 Oct 2025 10:45:47 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<CAADnVQKWskY1ijJtSX=N0QczW_-gtg-X_SpK_GuiYBYQodn5wQ@mail.gmail.com>
Date: Tue, 28 Oct 2025 11:42:27 -0700
Message-ID: <87qzumq358.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 79C3CC000B
X-Rspamd-Server: rspam02
X-Stat-Signature: kkzi9jezasq3jk1wg8dq4thpospduq4j
X-HE-Tag: 1761676956-493431
X-HE-Meta: U2FsdGVkX1+BWlxgwowD2502q2Tjr5/KTJJNpmgS89VnFbFGEhbRTjg+NORyO16VTdCvw4bF1jOx63ZQfVNP8M7K2RTIu3XFN1WjrnPKQfOyj+Mv1JsygP2kPktbcWxqb+D1Rd0x1LcnIDof1RwOHRxaq1DVGyQwx7pQL/86Ft5COrbNUsUtW+JcsPsCanAo57MJ3DKK+Asw299UiRL6GFeHxZgkmIBy9HXw00ZSpwcFzXxyeWHu+xd9dtNtX4sGqwOzuRnB2B8paarFlqaCyJkfQ2SYhBcUYq82hqcNtS/rqY2LvoJfJ0Q2QDsCzm1UhGhXY0Lw0EVsd6xkQsKHD43laitTjqhKImnTUUQZRcqf3ZcOPU0wJeuC3kBt7UZS11xygYVXkjnAWpCIDG+GIZWDbqNvFhZo+Pf3DJf1sPyqN6tzmmUDKyShr5+kFukC9esR4FooCpv9iOAQ0KbmVMivgSV51x/kqPgaQtq6fvVtIGQMAHNHoTMJMsTBWUQ6uQDCMTTsAGOSK13FzYJZkpdhCWy8isAa9XfkNyRqtfS8kMeVXRLlGtGr8g9ac8mLAZDhLJjym/2FLTldbgSPVpXjGzSuGLA/zUjq33MgA+2+AzJEemSPJPlDwERvQXICSlg7QykfTEstfQ5OmBkio6UtZCfKp8SO6Tc7eEAIfa42lEgYyZoNTpRiFHUm2MTHJkXo24aGR3iBcaYbtBftAM4s/GbSmweXAMoZ/BSEhZygLd7T3ahpkSjpNLxCD4hiy/hJq0NnObcQcAHPMgRRnxuTVIYYVzwO14pw0uRliYaedwZpkNKTJrDzTl4yaJ55Tl/KoFLIhhYqljYZ1JhkElIeoN5RGp4mAH8aZjrHinY8oKsVC8byhYcnnhED6RImAaHlWEToXlxjMPqiO2UiGBRYwP6JFUbpmUChvew9NFlQMf/ZU4LWMGdrf0pH8IZaZ5qm4o49H4tnWljdFWs
 rCLgpH1W
 y0ZvYOhly9Sry9VvqJuvy1yOyKIh/KtDhzz1PYcZuaWXfFpdOV/M+B8J3+xjKeas91+jSPgyZ8CewXqZQWoAdYr6T+LkPkzKEAkYbecFxwt7C9qeJYLv1j4gBmiFfAaB7v7kEhdti2qjRUJ6pgP0Wrk4ew14UHL6wzbgyUvT+8Wc+aPXurYzXuP1oNAJQYCL55emsdO+XTFlCzjzcOkT88emi11LhKPfAoovwX3cJ3JZIKnnGA35w9Ne8i0Faahq+5dJFfwSG35NdzAydsyATzze3n2CfnJqOkKdoxKD0aFyKB2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>
>> +bool bpf_handle_oom(struct oom_control *oc)
>> +{
>> +       struct bpf_oom_ops *bpf_oom_ops =3D NULL;
>> +       struct mem_cgroup __maybe_unused *memcg;
>> +       int idx, ret =3D 0;
>> +
>> +       /* All bpf_oom_ops structures are protected using bpf_oom_srcu */
>> +       idx =3D srcu_read_lock(&bpf_oom_srcu);
>> +
>> +#ifdef CONFIG_MEMCG
>> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree upwar=
ds */
>> +       for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(mem=
cg)) {
>> +               bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
>> +               if (!bpf_oom_ops)
>> +                       continue;
>> +
>> +               /* Call BPF OOM handler */
>> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
>> +               if (ret && oc->bpf_memory_freed)
>> +                       goto exit;
>> +       }
>> +#endif /* CONFIG_MEMCG */
>> +
>> +       /*
>> +        * System-wide OOM or per-memcg BPF OOM handler wasn't successfu=
l?
>> +        * Try system_bpf_oom.
>> +        */
>> +       bpf_oom_ops =3D READ_ONCE(system_bpf_oom);
>> +       if (!bpf_oom_ops)
>> +               goto exit;
>> +
>> +       /* Call BPF OOM handler */
>> +       ret =3D bpf_ops_handle_oom(bpf_oom_ops, NULL, oc);
>> +exit:
>> +       srcu_read_unlock(&bpf_oom_srcu, idx);
>> +       return ret && oc->bpf_memory_freed;
>> +}
>
> ...
>
>> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
>> +{
>> +       struct bpf_struct_ops_link *ops_link =3D container_of(link, stru=
ct bpf_struct_ops_link, link);
>> +       struct bpf_oom_ops **bpf_oom_ops_ptr =3D NULL;
>> +       struct bpf_oom_ops *bpf_oom_ops =3D kdata;
>> +       struct mem_cgroup *memcg =3D NULL;
>> +       int err =3D 0;
>> +
>> +       if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
>> +               /* Attach to a memory cgroup? */
>> +               memcg =3D mem_cgroup_get_from_ino(ops_link->cgroup_id);
>> +               if (IS_ERR_OR_NULL(memcg))
>> +                       return PTR_ERR(memcg);
>> +               bpf_oom_ops_ptr =3D bpf_oom_memcg_ops_ptr(memcg);
>> +       } else {
>> +               /* System-wide OOM handler */
>> +               bpf_oom_ops_ptr =3D &system_bpf_oom;
>> +       }
>
> I don't like the fallback and special case of cgroup_id =3D=3D 0.
> imo it would be cleaner to require CONFIG_MEMCG for this feature
> and only allow attach to a cgroup.
> There is always a root cgroup that can be attached to and that
> handler will be acting as "system wide" oom handler.

I thought about it, but then it can't be used on !CONFIG_MEMCG
configurations and also before cgroupfs is mounted, root cgroup
is created etc. This is why system-wide things are often handled in a
special way, e.g. in by PSI (grep system_group_pcpu).

I think supporting !CONFIG_MEMCG configurations might be useful for
some very stripped down VM's, for example.

