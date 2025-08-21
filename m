Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8A0CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667A28E001F; Thu, 21 Aug 2025 14:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F608E0001; Thu, 21 Aug 2025 14:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554F28E001F; Thu, 21 Aug 2025 14:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5348E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:16:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A22B0C04E6
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:16:19 +0000 (UTC)
X-FDA: 83801569278.16.AD40315
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id BACF2180004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:16:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V9p40sJP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755800177; a=rsa-sha256;
	cv=none;
	b=IWwn+rDR0Fn63LWKmrMgO7BARMxs/H+uvN1De2PMuCB2j8UGUoAM6pSXplCfDQDD6DzOP+
	YF/QhepwQlr39qPH1z126q4Q8DBXlZCAokDjsYl5ntgs6blOk75kuHd3fQWqKWZXSLvaNP
	GseHoOdFKJ+cEpfcjlKDBeNWOcWy30k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V9p40sJP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755800177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9/oELP0413f2vQDazoVmFhVHsn1S2Y0CDApUKooico=;
	b=VRfw2ZDuPboJun4MbMk5p02PUch7gPu4VL/CRwGXNPFT09A+GMrUmHTjhZsTepiXAESV1R
	JdYk7oJ5MwrLS9A3FQY9AWUidnxK5OkgOYNO6vcu9RID6vLWtu81oqoObRds1y5BeMVFit
	suu/vLTfseVFH/jP42hd4d6jJuutJxw=
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e9503150139so1323497276.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755800174; x=1756404974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9/oELP0413f2vQDazoVmFhVHsn1S2Y0CDApUKooico=;
        b=V9p40sJPkxXFVHi0wWxzmaktnSx6KZhEqSP21SqYqnUb/eQ0PMaM6RhYVUCoHO5sm2
         l5ASlOxQVNEBtnwiZ33JgkFf+bBNpbbasxzEH7b5Q1tEglxn6zeItuH0Ty0ndg5Xn/XY
         JnwrhRK3weNwf6NpW1gZLV6qA3JNbccy4TxiRrihHupRD6Q71TW3+8UjlkmjeZwvKTui
         Zzpj3LJo57JVesy59LZfgCHIjm6wvLIuVQag3dPiaeVP0LMSfymhdrj8bSpqfwb2anit
         WoJ84TJp9vrugnGE7yi501RMjn9eCbqQYqg821VzJxCGamR2S7wLViLSpoHfIfyvk9s+
         +7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755800174; x=1756404974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9/oELP0413f2vQDazoVmFhVHsn1S2Y0CDApUKooico=;
        b=Qgg0lsxHPK7n+d2dh2PT9QJvnqKyJ2ThqtpGBq80uPRcpDp7J8qkxJD8NoWL3i7Asz
         WDiegnorZ0NtYq2QNTZjxlqYLkDFPPTb9UDZ5hMeXflZ5MHJR4qJ9dGflCvTSdvP5mmY
         f+4JkrhgTo/j2cIa7BXMkdg/CQoS7nA/hNXyvfBiO5Boik3VFP2adItvt/LZ1WYEVHSO
         v1Bnlqb/HQo8qDwcxVcItFA/f1YRiy/8ijfq09jBqXkQEnjEIMDlKCAlSOkhU9M6EQZG
         AjTtTrgvW/4lbKIKQ5A5QmI5K6jj8r6zoxRMb/iz3grd/0YXid8NhWU8BeEs+3p9mIHF
         TYEA==
X-Forwarded-Encrypted: i=1; AJvYcCUU/htTYAOYIjZHyeqaqQx3wYwis/k3vGh0jniixYMEn6LCC3E3m5LRbwW2A+ig74GyNiyr0S7VCA==@kvack.org
X-Gm-Message-State: AOJu0YyqZk6U4jfYUVEs14ZWawfQm3Q2QF3YCMhU8LKJw8IoHXysmaaC
	pnJVKhzWazmUfZBjoVIF77XXoHIdkLXZq11+DJNDwPzD20EMPzsaDU470aduupIpcitL+wGE+wi
	ZtEANihKMphVbuF9eQKV+csWtDbbDMZjku2S50liGUw==
X-Gm-Gg: ASbGncuR4hLx+DXaXOv0RvEHswu4MUJiwjHRuRpoQcC+ImXNZFqEjTT7vYgHKr4Yk0s
	DSWagL0cji1BnNW0ks0QCntL5E/kB0bvvMK4/gI8DcnlKbnBx/l0URPI9G0Wbzu5TIQDOGU4wWp
	x0w+cM1R2hHSPXoS2MdDonsjNC5SvcqKwbBJjftGyFvaVdjDtlOk8rxuBTquPuwtCq4hGni+OTD
	B0tajPpoRZsoTIJMbyisys=
X-Google-Smtp-Source: AGHT+IE3bh28/Gt8RcxbTvDGB2ZwCKqcAEFwLVbLaQ1ETaz0DQgFhU7c2HeE+tfwYm/vwZ38OnbEAKkCkSN20XXIc+A=
X-Received: by 2002:a05:6902:2086:b0:e95:16fe:f257 with SMTP id
 3f1490d57ef6-e951c2e8178mr706872276.15.1755800174337; Thu, 21 Aug 2025
 11:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org> <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
In-Reply-To: <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Fri, 22 Aug 2025 02:16:00 +0800
X-Gm-Features: Ac12FXzSKuEp-w5_Lomw3unO-QADLCAsMZrvOlvz_slkZscwz7__XKmzGfNsSag
Message-ID: <CAHSKhtcxL0qN2M_yfA7N3yF1JrzRaMafQ+fnjmFzaxPCLSda0g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BACF2180004
X-Stat-Signature: byzserxhf7pxdfazswztkfztwqgk9goi
X-HE-Tag: 1755800175-655834
X-HE-Meta: U2FsdGVkX1/uNSJZGNCiHBK7azee3ZnNAgnefSscWurLkrr+WRwGqIpJ+60aHSNOamZpZK9yWGpssy9XnU3bA0YVhT3IpGlIgRRYCOc3gL0GMcUbxlv5HEvBPH56wzijUiGfRfupcZaCb0wLnVusbLgZin5Tj28WU1Iar2sIRUhJAWN0Q6VpsC3Jwv3Ae6yPFHKrsNMu2A15SdtycGyZg0NK+QH3PygY7R2GZ3DUl/rMiuR635YLu2itFJKCegK/A8lwC08BEO1ol1bmfwK2RnU08XT/foxVPH1ftdgNWX+NUGIE1UGjOIaVt95UTHhLaKY20rw1jej/zICo/FPtH+yYvOLdFJmcVwtUqInY0NLLO/nVAtI1E9olfPHDgF2Op/SHwcVNJlJaufCutq0MVBXTor5tRgFjnuUhnZjfDc0wlaHnDljjSfFO1YurPAxBIvblOGiGS4lMFw/Y3NzyCvALVlSo3D49Nse0HbkwVlrMbF5K3tQ00UwtucHmGIaPu7ZWBNI6lL+JWUsmEEKY2QZF1ZjQw4dlI091Pf17qWYoW6yF4fSyQe177Og39fbqcnHCH2sutmMJvQOMcxLg0rjM5UtcHNR7e3UeExBu0uqUr131mdbIH7pQzvwKHhPY9Oh0QiCV+O5r4WOsqodsre1J39sinw7A/ji1UkmuaVKMUgPjY4r0JNOVZdiJoQEdTqLLbfVoRZ1d3RBIjyqxoj+FUbDEWDudZRtXSICluvNS9kzWtojowSVDdVN8/EDIuIZ9etVfvW18GZnpQTSXfPRsgE5RC5TmU5eAycbSOaUUXy0o/yhTZ6NDfNaPB1nMatqxRbl/ZKjMAZsiyQ6fmL6ZTf+E1IlFmw0qSAxliugKSbnQSEooV4XPKxbi8Md5y/5ccQ3K6y0+WHVJqW221cTrJw06knJPCQlvsoK9Fx4zugKyONdJRRdHITOpugIglxnv524TPgT63kEzZnJ
 jb88y9kD
 06LM2oVRRZ2WpDMes0mBIPUlPlL2ihm7S3oeFUiYZ+sclaWLVC4Q3el0wKmAHBHlRcl796iWv6oMlQrm3JbShMwWxzs4t3sNyIiS1vV8CPvmD2+OYNjthxrJkHCz4vrB3nhV+0uqlHkQ1nBkNUeZqfQmPDISEYYiTII2LvLwBL0W3ovZT6OF1yPhembq4hAjPAFoWQmT+A6Y0OZ2RdSfW0zNSoDviJhxUlZ3yUMrM7DBnnO3Ihz7FeB4ixecy9z6FHRmQgk9D45OXoNpts2FdaIqNLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 2:00=E2=80=AFAM Julian Sun <sunjunchao@bytedance.co=
m> wrote:
>
> Hi,
>
> On Fri, Aug 22, 2025 at 12:59=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Thu, Aug 21, 2025 at 10:30:30AM +0800, Julian Sun wrote:
> > > On Thu, Aug 21, 2025 at 4:58=E2=80=AFAM Tejun Heo <tj@kernel.org> wro=
te:
> > > >
> > > > On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> > > > > @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgr=
oup_subsys_state *css)
> > > > >       int __maybe_unused i;
> > > > >
> > > > >  #ifdef CONFIG_CGROUP_WRITEBACK
> > > > > -     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > > > > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > > > > +     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > > > > +             struct wb_completion *done =3D memcg->cgwb_frn[i].d=
one;
> > > > > +
> > > > > +             if (atomic_dec_and_test(&done->cnt))
> > > > > +                     kfree(done);
> > > > > +     }
> > > > >  #endif
> > > >
> > > > Can't you just remove done? I don't think it's doing anything after=
 your
> > > > changes anyway.
> > >
> > > Thanks for your review.
> > >
> > > AFAICT done is also used to track free slots in
> > > mem_cgroup_track_foreign_dirty_slowpath() and
> > > mem_cgroup_flush_foreign(), otherwise we have no method to know which
> > > one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.
> > >
> > > Am I missing something?
> >
> > No, I missed that. I don't think we need to add extra mechanisms in wb =
for
> > this tho. How about shifting wb_wait_for_completion() and kfree(memcg) =
into
> > a separate function and punt those to a separate work item? That's goin=
g to
> > be a small self-contained change in memcg.
> >
>
> Do you mean logic like this?
>
>     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
>         wb_wait_for_completion(&memcg->cgwb_frn[i].done);
>     kfree(memcg);
>
> But there still exist task hang issues as long as
> wb_wait_for_completion() exists.
> I think the scope of impact of the current changes should be
> manageable. I have checked all the other places where wb_queue_work()
> is called, and their free_done values are all 0, and I also tested
> this patch with the reproducer in [1] with kasan and kmemleak enabled.
> The test result looks fine, so this should not have a significant
> impact.

BTW, the test case is like this =E2=80=94 it ran for over a night.
    while true; do ./repro.sh && sleep 300 && ./stop.sh; done

sjc@debian:~/linux$ cat stop.sh
#!/bin/bash
#

TEST=3D/sys/fs/cgroup/test
A=3D$TEST/A
B=3D$TEST/B
echo "-memory" > $TEST/cgroup.subtree_control
pkill write-range

sync
sleep 5
sync
sleep 5
echo 3 > /proc/sys/vm/drop_caches

rmdir $A $B

> What do you think?
>
> [1]: https://lore.kernel.org/all/20190821210235.GN2263813@devbig004.ftw2.=
facebook.com/
> > Thanks.
> >
> > --
> > tejun
>
>
> Thanks,
> --
> Julian Sun <sunjunchao@bytedance.com>


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

