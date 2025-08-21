Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93455CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96A98E001D; Thu, 21 Aug 2025 14:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47CE8E0001; Thu, 21 Aug 2025 14:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35C08E001D; Thu, 21 Aug 2025 14:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1F738E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:00:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 860C31DBF10
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:00:25 +0000 (UTC)
X-FDA: 83801529210.26.7F8203C
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id E2587C0014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:00:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RVHrmDBx;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0lia9zAzQkMkj0u6l/RsjUG2VG0X8+ajRHGScPdguQ=;
	b=xhfyYR01RKQJciPEociUBeLqj0SmLKKrnCmof9cnPdf7l6BeMPJ/S+QPvoqLnBgpeMIU3S
	nsdwqvQXwPODKHRqS7ZIvT5zmLrsx7j4nELMWqoDsZQAS6cDfs6VDjr3Nu35a4bLy4lirh
	jKk2eDs+bvJj+NoHn+WSjjR9b1JPgiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799223; a=rsa-sha256;
	cv=none;
	b=2uxPhyN9lS4Nn1LV7vt7UlxfX+shdgvLChmxvb7JFSnqpgThLbQ5jwtlYiV69Dk3SIWNVN
	AVBvj8sshTtPxs2Tu4bP7FFbbiXfA3A1fK5sF32LDUULlFX5Akd6e4V1xKRK2Qy9vxonZh
	2U7tURiVZnxYd1dq8LxoP3NnYO4X15Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RVHrmDBx;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e9505d08ca2so1061672276.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755799222; x=1756404022; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0lia9zAzQkMkj0u6l/RsjUG2VG0X8+ajRHGScPdguQ=;
        b=RVHrmDBxED0XdHIOOIhmPJLUE1PuVWFCDOYvlHzOQj5EsUoH++xTzEeAVNTyjAq7SP
         U/gNl4vmtYi0JG2fslhbAeqTs3eNEGGSpdCpyRfo9S2+22O3fLK5X9LVK4BNHIvMWfN6
         BFElZUBwrJ3yPdlRlTpuT9dtQ8R7WasGys8ftY/StYlfrgV+Mh2nFGxlZJFetWBaQ8Mt
         qV5Hk9lYxek+QSKIjqg5CtOX/NeyLl8uDxcv3qXEwYXsi6KM8LKeW58V4qlpaJBYDv7f
         WaLPdFmOygz+03qsPyOE9GDX7Qm6yx6dXvWlLfeAWinWFAkNVqs0CFVrXUda7NxTlPn3
         N4wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755799222; x=1756404022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0lia9zAzQkMkj0u6l/RsjUG2VG0X8+ajRHGScPdguQ=;
        b=UdkJ/AaAkID32I4uRxjmEqRjmrCZGUfOC3kAwGZabC8qytHoE9KwyHvlV2GChFFa6G
         y4tW9MpMf/j2yCNZpT8UZHcC8zfFc9fGGwjuX+Qm6OzwDyv/Xgi9nB6mCxXQ7P+FQO3G
         mvY5S7CD4bIEuAZx0Zxaevko5hcWlXYAdcawRbtBt44CylcQPGemvHqt91qgLQNy+QKN
         kS5lf5M3AiPoQWRqiHgXmU9x1Pf/5pbl2LwaAbopuw/i96Xr/JFvwZ8JQDLgm6LzUmrs
         pDwXQe8d5wRHcrKqmnPTbvZTeUwbo52FdO5sMeSfmCBgD2TrxfaDvmZei/+QwcpYEcY9
         fGTA==
X-Forwarded-Encrypted: i=1; AJvYcCXIzDL0UPggLJVaxzhssQ1DZBDRx2pz4ju0V7ESyu9GT97jP8OwLkLGWpbgbJTHpI6Dmco91yiNSA==@kvack.org
X-Gm-Message-State: AOJu0Yzjyd1dA2eG+hdScr2jWxxnX/g46vP7M0Cbc3AGCr68RwBd7Qfs
	fbxl0otDEhdSjlUiYnCf1bnIuYSVyrkndZFMjjsCSDC9oR48/udzgS/hnGF/kzA0NIyKHJ64R3Y
	mUeEivfafaVDq37NjRQ/705hqN1+FNV3giGEcS4zlJQ==
X-Gm-Gg: ASbGncvWT5We0o1vb5sIVMnjU8/QkDf7QIQ99yu9dSbxkaUh8ayxOnyfwdASkHNEDHi
	EMBLjWeQwWNUM5UvERu1pAZBFjYNWiUELjV0yhN5tdj5OrHFIgRWe8K00w5H4d8fEwYJj3STvH5
	g9/WWFtXbgNWTOSh9XTERES2XDMukapyjSBTlkQt1SEfjfeVC96+ntPdfKeZIsB0y+BYBvJzFBp
	3nM/NtwPfsD
X-Google-Smtp-Source: AGHT+IHZiFSlHaDYSx8oxyHmCj/KbihWFMT9IF+j+/jr/Ilj6ZzdxoI20FyXRZA9RZCJDjjSM6r7mSJmwQpFWryxS5s=
X-Received: by 2002:a05:6902:3411:b0:e90:6c6c:dc3a with SMTP id
 3f1490d57ef6-e951c33207dmr490273276.34.1755799221387; Thu, 21 Aug 2025
 11:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com> <aKdQgIvZcVCJWMXl@slm.duckdns.org>
In-Reply-To: <aKdQgIvZcVCJWMXl@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Fri, 22 Aug 2025 02:00:10 +0800
X-Gm-Features: Ac12FXwQ52FAG0PW2wUzBrp0izeD42MUA03rmCmMwjxx7EXlVIqi8U_EajVPCpg
Message-ID: <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2587C0014
X-Stat-Signature: 3aik9mkx4ta8w39jksw1aqtbqe1oyfon
X-Rspam-User: 
X-HE-Tag: 1755799222-776896
X-HE-Meta: U2FsdGVkX1+Hv+8sSu+s3ZGjT/oTvhDVP04d40C5arkvkpgH+q+W7+AQ2OtzSX8LoslVVfdBwxudmj0raaMMpw354N8vMzLddY9WeDaIM8tV9qjYIBMpOW1gmHOhPurOO4C3pvMahM7jS2cx1kg/lsPGlMvssZHYrAS21Nx515Onx1wRliOSU/LuIkkwoj7kcdY+2wls63YYrlWLyQ9WV+le+UrQnrZDyHDYllNVt6jCGeeDIz0ia20m3D8WQbX+CTyzk9qC7uCxfGfozpM/SP8Q+MgTt7mkaIAmedUj2JS+ksvziImv4+vB2Ufbl49ttwPb5kapPHSe8rjvk91FTZKo4sBDSPSJLR+M+FUUbmlBm7Bb/tY7jsnyNdEOOzeOggqftvsolnUqf0ARc1uRj7y/nridT2lqmXVwYm6ezqVyBFjZ3NTxusl3dQWgrqwXTz3Lf9YPULkDZVp/j5TawjLaY6XsbFyjhzxvQc8gB+5EW2iNIRjTTzufY3D9Bv11gUCGeffdYLjazS5ay8SHwF5/d7EMYNkf4NqpDy2Nuc2M8QC9Kav42o541O244c72FQesQGc6CIU2has2Df+1zgBps1RvsEd/mtBWh8vuean5rA81YZiwWJRmNMbxeuGe3Nnl9VRYqqhItR8GZSp/FmuVybdGq8RmWgSYX8EJOqz7JImF07eAMcb4avywhJpf1hp4sanpTcv6+mjzlLDsB6NHY5wdiZVc3X5QFFDIKA8J8dXh88dNxSs5stNY6QJtIrH2dW1lNSEsVHzMqQZDftSYas4ln25BbANHrvM7g3NhWlnOF00KnaILccF5o98Qf/3WVutDsJNPMNLmNlC6Fy408PBHv9T0BbPzvxV9aOkVV7YyChBcrl4MNNbv+XpBbZw4jCqMTIq6nZHxV1hS9z6oBJbMiY//fcEkQpjbAP4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Aug 22, 2025 at 12:59=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Aug 21, 2025 at 10:30:30AM +0800, Julian Sun wrote:
> > On Thu, Aug 21, 2025 at 4:58=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote=
:
> > >
> > > On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> > > > @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgrou=
p_subsys_state *css)
> > > >       int __maybe_unused i;
> > > >
> > > >  #ifdef CONFIG_CGROUP_WRITEBACK
> > > > -     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > > > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > > > +     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > > > +             struct wb_completion *done =3D memcg->cgwb_frn[i].don=
e;
> > > > +
> > > > +             if (atomic_dec_and_test(&done->cnt))
> > > > +                     kfree(done);
> > > > +     }
> > > >  #endif
> > >
> > > Can't you just remove done? I don't think it's doing anything after y=
our
> > > changes anyway.
> >
> > Thanks for your review.
> >
> > AFAICT done is also used to track free slots in
> > mem_cgroup_track_foreign_dirty_slowpath() and
> > mem_cgroup_flush_foreign(), otherwise we have no method to know which
> > one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.
> >
> > Am I missing something?
>
> No, I missed that. I don't think we need to add extra mechanisms in wb fo=
r
> this tho. How about shifting wb_wait_for_completion() and kfree(memcg) in=
to
> a separate function and punt those to a separate work item? That's going =
to
> be a small self-contained change in memcg.
>

Do you mean logic like this?

    for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
        wb_wait_for_completion(&memcg->cgwb_frn[i].done);
    kfree(memcg);

But there still exist task hang issues as long as
wb_wait_for_completion() exists.
I think the scope of impact of the current changes should be
manageable. I have checked all the other places where wb_queue_work()
is called, and their free_done values are all 0, and I also tested
this patch with the reproducer in [1] with kasan and kmemleak enabled.
The test result looks fine, so this should not have a significant
impact.
What do you think?

[1]: https://lore.kernel.org/all/20190821210235.GN2263813@devbig004.ftw2.fa=
cebook.com/
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

