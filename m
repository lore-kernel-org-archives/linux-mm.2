Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CAD1CCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 22:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CD68E0198; Tue, 28 Oct 2025 18:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC6D8E0005; Tue, 28 Oct 2025 18:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DAD8E0198; Tue, 28 Oct 2025 18:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 167318E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:08:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD3301605E3
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:08:04 +0000 (UTC)
X-FDA: 84048911688.21.3609A22
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id C467920005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:08:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9iy4V9p;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761689282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7V+762A1daN4J9oNjmmT69+inXV9phu8pPtP3M7FAMM=;
	b=u41RfsZvcZLT6K7ChINmuFYEkuwbWF2hZB+A60BcNrIP4cAKeQFqWsDI3HkxxIvsUcRmsw
	gD3YHZcWsPk2mfTJqxF6Dnr9kly9BQUZBkqr+hGcLPvjmO4A29J+D+xBaKdee2N6OnEADa
	HngxOmdC3Vdgt3qRMeKevBhd/O1+CS8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9iy4V9p;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761689282; a=rsa-sha256;
	cv=none;
	b=rWLiA62Lu3RUR/lp6Voi6f2CVDRc8tViCW4CfTgC8BqqBEk2ntEOE/P9C3+GqVEH0m8tpv
	+iod4/ztI8+OpLyfZDLZUpDvCT21IEZcNm+//iukBzFHwferXH4hTB0ybOkOsSrFQjWGrB
	fG8X974vQUZNRb6JGLQhW+uaguSHQLY=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee12807d97so6120540f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761689281; x=1762294081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7V+762A1daN4J9oNjmmT69+inXV9phu8pPtP3M7FAMM=;
        b=c9iy4V9pnCa8ww21FJJM9xIdcqan41/+RpO1VbXFk49eE+vhAFqnUapIUlSlz64VP+
         lVoTggodHoV23iHhKZ5OjFtZvFatkywVPmf3AvT8PfDGhRdXn8cKEzspHiNJ7y52+4Wu
         4or1MvxOIN4Sf/s2ERMbnIlWCOycU0XsHCGfWQF5gOR1n2vOor/dgKMU+s0At/AHcJSg
         CWYicA/lWLWShzTecsNS8AmZgsqpmKKPfo9L++GLEL70c+IS8JVIKKeusRmg6MUrDZZp
         vdYB96F8QmeLhjBbRAjluyoETO83GU9CCxOSS4ndz28GcwncOwyl0WtNS7Zmd0tLoKDS
         rBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761689281; x=1762294081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7V+762A1daN4J9oNjmmT69+inXV9phu8pPtP3M7FAMM=;
        b=QDmREJj+tc5lLq+v5ZJo5cmsOQtMjoP6WMNIvRHRJJNZNCiQyKu3vdxLFKoDPB9iqg
         7jdTD6KFR/cMGypWa2EC6ZygfdT6fvkYkM8IJajPWAvTkn6YoKOaI7mxUuw+RskvoEMI
         I+iHUM/+7xCWxwPLBtkBPGs44tsahcgdTEyzR6hRu8s1bX4YacE1ETTEhIvNxFwrym+W
         FsVV04HmtWqeP1YulpM+QqWzZQFcweVKRujNNQcUzKe1Y6RsuYieHQ2OYGn7LkTOqqUx
         uA+PiDDQ9ps1DVHdAdUZAZtCb5vB20NvhU4YNUODA8KzBybKkHmUJ4g8DZLV7LhG7Bs8
         TjUg==
X-Forwarded-Encrypted: i=1; AJvYcCXRDAbKvmskhsxvdCyYYYQNTxpP/uRtKpcYf0BgdPuvhZ9F9LIPnNUanoW+HTJs1e7FlUrkuREVRA==@kvack.org
X-Gm-Message-State: AOJu0YzVoE/avvYxMmYHxCoS1i5GUT/BgpDrRvbA+/RLGo1XilOyJGKc
	HuJjhrPr95byWHYDpxujL0E0N0Haf67fpXy52JkPbfPwH8R2QnLQ6FKULM6rdARIkG2UaINdLzJ
	ttCb1KWSKgpqIezVne4h0sTM47hUx+2w=
X-Gm-Gg: ASbGncuiX8shCQ+MdCqBKHVVLvRAoZL4AOxjU0dpHRATRsc9Fkcs5wQHQA/D1Mtwsta
	zcLejb67zrO6nvHgxvoFOxQjzdk0VmJAR1mWDxiJ75cnNA6uiC8jMVn3OR8gyliqkL81K+8GUgk
	E+AVzsOIj/egPVOV6l8OTTrl/Dtv9ChnIF4uFqLO6Au7d78QqAkFrp/D1cHukp2gOUlLVgs4m4g
	GN4tkf8g5Oa1l1Fqb5JvIIsFJLmt73OpikFyeg25pLp6C9X14043kPflXQnHzyf5Rv3oECLWYQs
	sUWLPW/V3r9S6bsL6w==
X-Google-Smtp-Source: AGHT+IGICaO3BvlkXeLb+EbVNUOXQ0U63xZwGPTFrBoahOPE5MZiS6EG5jxPBtr1ZSjP3nUamu+JhVo3r42lsbR/Cqg=
X-Received: by 2002:a5d:5849:0:b0:426:ff7c:86d3 with SMTP id
 ffacd0b85a97d-429aef78c90mr552970f8f.13.1761689280869; Tue, 28 Oct 2025
 15:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev> <CAADnVQKWskY1ijJtSX=N0QczW_-gtg-X_SpK_GuiYBYQodn5wQ@mail.gmail.com>
 <87qzumq358.fsf@linux.dev>
In-Reply-To: <87qzumq358.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Oct 2025 15:07:49 -0700
X-Gm-Features: AWmQ_bn1qYp03A-J3vHinawzwNNuHcAYrjS8vVp0NbrkX9UuC4qoOTSYxLLTXTE
Message-ID: <CAADnVQ+iEcMaJ68LNt2XxOeJtdZkCzJwDk9ueovQbASrX7WMdg@mail.gmail.com>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C467920005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: an6s84gmxxomc4os6kki534ohb3gozxa
X-HE-Tag: 1761689282-284600
X-HE-Meta: U2FsdGVkX19oLFJCasdAPOsU9R5u/SLWzNbd7zrqenHKMKpqhCdntElbQKqQ2cziWD1bXfz9V3eqij1QgQxZSdt8HB2M6Zm0SMKbq05RBAEsF/hyp+zUsi9PNPD7w2LWEYqVBuJFrAN95F9liAVKAWlKrtc/E1frRgWvf7oU+EeArA7eCX+wQjvJn1JRb0Kx+u9BXwMVaNM7JZESAW3CLougUaTLKu9hPkNz54nHvYT3SrP26B3PVMzFtvAWjoy4amSF5SXFol5Ay98vwItozZ2HWp6+dLEhqFDjiCQZlN4gqgSgbb6BUgGF8nz1rrZG5n7c0/ugoROJZ38NL6JyAdrQ54b7npn29AMLPiSBOIvfoY0OkznaMJlsTF1Rubx8DIglgA2hrVc0WPCUR2H2I777qW4S95s6I0QnSBeg8/xZKpwNBZQWQom3MJyxIyM40cI/sQqG9QbFclqjoCbSWR79CgWOxb529/HbwUct2KK3ijlb1++mB5layZPuthdF+g2kmS0sUn71/9knbNF/g+aTbDpBqMAzgQSKDdrpwGtrOuG4nfx+k14eKJXg2TPVIw0nbFqJ49+LbKEbmunDuHHeJuWDcqrg5b+BC/+gkWGDUbJRg8C0F6aeoJBvisZnoJ3I/uMdOa5E+wcIrRHO2slqbSfpoE56ugkwYju4iquY+yA/fGI1vbGXwz6STHjs2Ej5gQY6QJ7KJYAamIPgbgzFMXYvK/n/4vLOplAQWSzcv2pyw/1dtzzAyfdF8IHWPtkQImqhiRfVysrgm9J+3t1MPv7fmelqIEldRIoxfNPFUSNXXVf2CO1SbPLuSAOCfawwuBkCHEX4xnFdhYUhp5yyvtKTFIjliHlUsxxMiY+QNSbI0lW6mtyP0aqVIAQeb/9nZVz3ytYA7pzeH9w+RAJUjN6kdWgoIG+mYcbm0E8abYTfNQeV2uoAGwzhkPF1A4F3ltUASQZ05Np4GUl
 RoQcw/dt
 4HBZflCepysEtNxml10fs4+nHvLTaK9/L1nrbHjyFZHlJZ/XeCqs02dpv/vGG2xtwNGZ7liEnphZ9TuDBi51iZoSdN+oi2ZNOmzBQH4aoItGBycbl2p/Trft1sMXjfjnhpejMMuxRtgWjcmkJymiaYtdx+7mhEES4n1x6q4ErZkQtzrjxZnCXgrfyWS8CUKgKjIgq/rpZ7AeBHFX0PNFX/ysjNRHlA0uOw6xvqGpTX9DGGHk0N+N6ObpIQAJ/kVMw4Qmq/XmUiYK/Pa0+O0Y4QVF+ov5UaJ/0eFl/g2XAt1BbjQnc6aUtD8t4LGG2oPIN/8SAKSSgCtkKQwrOECF/dz2jbXmpqbf79Dw2NNcqeKkEiZ8LNA5MgvQ4D+pwWewUwosstXIQPtNleS+4G7MFeQ/pbYaQYSfqvjK0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 11:42=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin@=
linux.dev> wrote:
> >>
> >> +bool bpf_handle_oom(struct oom_control *oc)
> >> +{
> >> +       struct bpf_oom_ops *bpf_oom_ops =3D NULL;
> >> +       struct mem_cgroup __maybe_unused *memcg;
> >> +       int idx, ret =3D 0;
> >> +
> >> +       /* All bpf_oom_ops structures are protected using bpf_oom_srcu=
 */
> >> +       idx =3D srcu_read_lock(&bpf_oom_srcu);
> >> +
> >> +#ifdef CONFIG_MEMCG
> >> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree upw=
ards */
> >> +       for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(m=
emcg)) {
> >> +               bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
> >> +               if (!bpf_oom_ops)
> >> +                       continue;
> >> +
> >> +               /* Call BPF OOM handler */
> >> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
> >> +               if (ret && oc->bpf_memory_freed)
> >> +                       goto exit;
> >> +       }
> >> +#endif /* CONFIG_MEMCG */
> >> +
> >> +       /*
> >> +        * System-wide OOM or per-memcg BPF OOM handler wasn't success=
ful?
> >> +        * Try system_bpf_oom.
> >> +        */
> >> +       bpf_oom_ops =3D READ_ONCE(system_bpf_oom);
> >> +       if (!bpf_oom_ops)
> >> +               goto exit;
> >> +
> >> +       /* Call BPF OOM handler */
> >> +       ret =3D bpf_ops_handle_oom(bpf_oom_ops, NULL, oc);
> >> +exit:
> >> +       srcu_read_unlock(&bpf_oom_srcu, idx);
> >> +       return ret && oc->bpf_memory_freed;
> >> +}
> >
> > ...
> >
> >> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> >> +{
> >> +       struct bpf_struct_ops_link *ops_link =3D container_of(link, st=
ruct bpf_struct_ops_link, link);
> >> +       struct bpf_oom_ops **bpf_oom_ops_ptr =3D NULL;
> >> +       struct bpf_oom_ops *bpf_oom_ops =3D kdata;
> >> +       struct mem_cgroup *memcg =3D NULL;
> >> +       int err =3D 0;
> >> +
> >> +       if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
> >> +               /* Attach to a memory cgroup? */
> >> +               memcg =3D mem_cgroup_get_from_ino(ops_link->cgroup_id)=
;
> >> +               if (IS_ERR_OR_NULL(memcg))
> >> +                       return PTR_ERR(memcg);
> >> +               bpf_oom_ops_ptr =3D bpf_oom_memcg_ops_ptr(memcg);
> >> +       } else {
> >> +               /* System-wide OOM handler */
> >> +               bpf_oom_ops_ptr =3D &system_bpf_oom;
> >> +       }
> >
> > I don't like the fallback and special case of cgroup_id =3D=3D 0.
> > imo it would be cleaner to require CONFIG_MEMCG for this feature
> > and only allow attach to a cgroup.
> > There is always a root cgroup that can be attached to and that
> > handler will be acting as "system wide" oom handler.
>
> I thought about it, but then it can't be used on !CONFIG_MEMCG
> configurations and also before cgroupfs is mounted, root cgroup
> is created etc.

before that bpf isn't viable either, and oom is certainly not an issue.

> This is why system-wide things are often handled in a
> special way, e.g. in by PSI (grep system_group_pcpu).
>
> I think supporting !CONFIG_MEMCG configurations might be useful for
> some very stripped down VM's, for example.

I thought I wouldn't need to convince the guy who converted bpf maps
to memcg and it made it pretty much mandatory for the bpf subsystem :)
I think the following is long overdue:
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index eb3de35734f0..af60be6d3d41 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -34,6 +34,7 @@ config BPF_SYSCALL
        select NET_SOCK_MSG if NET
        select NET_XGRESS if NET
        select PAGE_POOL if NET
+       depends on MEMCG
        default n

With this we can cleanup a ton of code.
Let's not add more hacks just because some weird thing
still wants !MEMCG. If they do, they will survive without bpf.

