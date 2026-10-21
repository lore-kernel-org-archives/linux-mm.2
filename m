Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390D0606A335
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EkXBXChn
Received: by kanga.kvack.org (Postfix)
	id 428296B07CE; Wed, 21 Oct 2026 18:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9926B07D0; Wed, 21 Oct 2026 18:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7E66B07D1; Wed, 21 Oct 2026 18:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E97316B07CE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:00:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6259D120653
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:00:32 +0000 (UTC)
X-FDA: 85348003104.20.603FB1E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D6F7180014
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:00:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EkXBXChn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792620030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zovsq29UQ2TeLumV7ABI3SWyvg5qGuaPKJLreulBem8=;
	b=V6oG/oY6Fgl503v4n66paFGSxYJRiqTBpKjeXCgBbCUsFxugbaC42FoH2WyjWy51BpkwpY
	8TnheyQAzDwCvzz8Nu49LIIx3lakAGExDiGFphO6c/sbw9/SdAub/7qxNDTlpq0MqflD9h
	DeG/YVOTbSxwYLFvGUC7yeGodKLbtM4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EkXBXChn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792620030;
	b=wgLs5uv4zt4Z9/B4ZOsEeLXO4OV1n4G6hDeAItWdhyNtpOQm7BDiH4P6RoPK3cq4DVG7K7
	sNUnHDgpnZnGarqKdm68I/CAL2S94ZII6cBbnBxV8GvwykZ3F8Spuk2SaOdjdPAX/XQPic
	ys01D4FWEiHqvC71lSVvE0ji3mIDWmE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c445c95d553so158156566b.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792620029; cv=none;
        d=google.com; s=arc-20260327;
        b=AjDGQmtkE23lUoWwjFkm71M2l3wjnJbjgsDlcY6wPAvYmGShZQJXdSohHMn4O42WtP
         KcJpd+bFUheubQ//ZjgK8I+7+rmK3kwM+9BqQSaFUlOPgM4QHf2VUln+4/Ytlv3JNiRY
         ZSv/acTetqtxJu0rFNH738WI6EawQMkLV79rlg1/hLBF7ujZItyCoQKYvdtTtOvXeFD3
         2PUTBgPVYYp5T5qunV3hNSoA7qIAmRUs1Vq2RJB2wg/6j8cfF9t5jrOpAaUXYjoh5jze
         7aI69Dc+CWQSO3gLocz4mu/IXXXLQUagApdzcVnBjjRcXVQUhVjpd7zCFTgqKUErWHgF
         BDZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zovsq29UQ2TeLumV7ABI3SWyvg5qGuaPKJLreulBem8=;
        fh=M1T4Udxf8Z5HHINa8l31xwU0b1aKCD+u4RkT+47482U=;
        b=qDK2fU776HnI0R1wqCxCWazGhGPJwo3eQwb4fkiIMx2hTbZGPs6XaSzM1jefB/FzvZ
         2jI83UNjN6SSsuytrteuQgyalwx9g5X2TlIrRm3mh4XK7H5Y5hfFNeRdPQFAK3cUQSyL
         yh8+mAiUfQlqTv00QFwvU283fVOR+GZJp2SvuAkbiZZMQkJqlmxL9w/lfbi6CshD28YF
         SpQap7s5jNLXZMVi/m3PO0lNS8JdRLxzqtLGb7V9n7S8/KuRPRlRvEFe38NqEIA1YAZV
         5VnR2o/iRmCUKRd9PFIqCUoN0jFpt8EWc3PiAYbf4bMmZSlHjmz48JS6AQE6M3gKSTwo
         SfLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792620029; x=1793224829; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zovsq29UQ2TeLumV7ABI3SWyvg5qGuaPKJLreulBem8=;
        b=EkXBXChnQCXmt5LBhutplfrGO8bre9qw2mLaLxME2d+VS4BCIW3K4l97AnRz472ri2
         CnhXaykurZ/SzuETksQU/RrQLs19edGf+OiGFdPpbalNnuNYcK5zIAw6m3GYMbtZpGq6
         UIcvTo1n3XX+GRVS7Hm4wAhjDu8z8wSYI+ZKRuxUWWKJr7dyvbl3q2RCqQXXxvaHuk8e
         GvT6hXtWKhWZct5YiiQ8zk38D9P6Jj37FdAEmv9DOHSzj/4sP1vQ5YVKzM1Sec+lWvT8
         izPlWoC3X7+gUWtkwavGEnyFGVF35qGqTHSWsFY1hOhwqrMNumcCZMlS/++0DvVt4hEt
         muyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792620029; x=1793224829;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zovsq29UQ2TeLumV7ABI3SWyvg5qGuaPKJLreulBem8=;
        b=PPn4HGMdhrfQ/prEfexzzxhH5nxrSGKxPJcwKmG8CfdIQ5lMhTvWd5zR1Isifn63jL
         r3IhLBgeEWk6oiZQB6FLFo49nD5LC99c7hDNYAwHUGBSucvxW8nCY22bsKoUbq1ESLkt
         9dcmdxJ+PXMQoAXcVIUGHed0Hi4pHHi8atxrHqbw7pdafFhszoH3FSGjFM8bpMKHJRml
         6Gb8gEh1qNs2Q8Zj0GYXoS7lOTuo5+8qhubqz4AXNyfevx3SLSlcEF2eWgb1uKU42Aj+
         EPbm7kIQ1h3BZ8QpLDWv9u3DBhPxYgrnpN6uyvMZKbad5iAD2UI15u/FX1/d8h3/5D2W
         ElaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwvW4p+CC4X3CY7cb0d2vKp34OWNwPjGE89E+XFVi6qy093VkZlxMQz12K29zv3aqqjmAiQ8TfDcA==@kvack.org
X-Gm-Message-State: AFq9FYJpVrpoLU89AaA/NTAwYokv7f2qPblPsr2jSOJh7zzcAFrSDveo
	kR3Fg6K3yHONVP8RHXqtfRspmHWCjjashMWQzBOyoxwcle02nM2ROFvpBurKJdGVW2vhBgIZhhr
	jHR93J0qTjU9hy8YF2nFo+2kJEICjB2BdjhostLwC
X-Gm-Gg: AYBFou3F4fyWmmr/WDAC2KyI7PAEms1SvOSOgPobIeY6ukPltX+2kHYbw7IF8SKFuy0
	gT4pV8cdD+BqOR2AbSj1+Sp+cgGsDY4ot8ygI1UndZxfdERJ1RKF2i/5pbSlFfA5l/B5CeTkmct
	F0Y5vEh9oS5jPnW6ql2pqMH8HPB7sEqyo2r/v+XI1kIPeJxDuzfPpDpiGLY6jcs/E4gl+gWR0a9
	V1icPB/sgyUyeqIry81tKpoKsKxQZTvmFajEz9q1VsyNB8y4a4N+n6oWClFXyK2+gDAv0IWivjD
	A5kxggFHFs0fV8NgvI7k0BAGDcWaaeF1rv++r2XeWG9+wQK2ucNS3+z++AIudPtNxDPf38qXpJE
	RMwR0Txw9CCmgA/LWfWBH79l20frsjMBqxbjtYEhYC/ymi3+wGd1c0e3eiL3bsEAsqKCobba1Kt
	Xr4iF9bPSU9rOpp2j7Ht/ItGSv/MCtACMsC7YngZMmIC+YRINJ5XKvXG4gdw1sSMN3RfPa7zfDn
	MJNZn6i
X-Received: by 2002:a17:907:7208:b0:c31:7495:e57 with SMTP id
 a640c23a62f3a-c4679a0bcd0mr297358566b.44.1792620028316; Wed, 21 Oct 2026
 15:00:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-4-jthoughton@google.com> <B8A44041-1516-4405-976D-534AA2412A49@linux.dev>
In-Reply-To: <B8A44041-1516-4405-976D-534AA2412A49@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 21 Oct 2026 14:59:49 -0700
X-Gm-Features: AclHuK8yX8_UlxZwp8Wau4tISOxPTXz9_QA6ij9ZqSUUyry48bT72riHBjGZz-Q
Message-ID: <CADrL8HUOJwEgjUzefxSUa=AZHj4JO7koonj2_-WYhcL8QcXPZA@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D6F7180014
X-Stat-Signature: wos7uh44g4d6eiecx1bmip6noruxpckh
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792620030-764458
X-HE-Meta: U2FsdGVkX18tmZPd1qTgc7eZr1EgCliXBWSbRTvUcxDsDe6XmUKAdEVA9kIvQKqSQ96O8k6SyPQtWAv05JnmxWZqlpkKppzg5cMav/kyBoEgwNcyaDhuFyahhzbHZcZ2pmWhlrcC2Fy+X3k8Ck76nwh3doEJO94KX2EgLq9llIMuDcYTKSdXTuqecqgF63o+8/+O6BaaQbJ5vvmvek9Jjmk5K1g/dUFmHoDKZdwm8u3xLvaCTjMF67XNgDGa7yic/Nls5l/RJZ8+OsLM6KvmHSxI8JghNdfuyZFEEfu683EjcqiqMGQV5woyAJQCrc7wegMq/ZCk3fmDZPZp+b2PFFu5bVc+2e8vVZkyM0ehyWx5GWi3Ki328r8Gms5e0vfrLUjHTldma112aHOhRKHw5Y3WxH44JdLLdvVsjO8hxcEQaAHNGsBdjK4cR0MIohZbpohdV5R6/gvpYA8r4VPm6KWDZPbFD7mbz+ngnlf96z06tH2CdNq7tBFYu9Ow33t3N52YL5h0SCAqAXg2GwZ7nlmFSzZ4riL5hxaO957jVOtIE3ak4Usa1vlE0AADHA+ffj9o+pok4lDZNlo1612nsydlIXtxz+T9idKDUSJq7NISOPjPIu849sIzDiwcvzQeHZXJbe2lIUsNx1PrNSlHCfZqZLkn1jLo2kHEbN/EaDE8cCX1EjpVEkOqWCFtbhry3P1ooA8GhrW8gVS6nin+Mxdf64ZJcrTWOjL1W4GFQdf2GA6SNSHpBCemjlFNVJ1MQ8ulS5w+l1IrbioT9drze3XR/WJgoWhQ2hmR4RsItkqupG0Y0jfkjS/9R0ynBUQGQCBshmpsy3/FUHd1An6lDnCkdczBpzEqzh3GyNtNSVEqSIGCyVqvUB915LKTNmJST002I9BnLJ9pCRPksp0RFTSMmtUWhpSj9HPnaC4I/4pvxYjJu8oe9wBZS34aRvGjSAJQpcVxSGUwR+3+4bR
 OHPTDRrE
 simbuFSlUp/wRxqpIBKAOatHBQBhnjEe74nmA480DpdcPCTx8Vx2xTQDIQXy/AuD51ZjgBK68KWJvVqCgz4HHLlp3SvNuC9P5KuU7EQnontGdF/hhF9Ci/4UfVHQKpTbxkM8Vz4PVbi0O3sGu3K2s7baKJurHO430G1Sp8IKda5IIzwWTJMtx1a4bzaVrK/2BW8FageHY9QepwlBJMlALCb2lNEJ+JQL7wz3Vgo8YdmE14ZCQoSMjMLVQjC1NXZGZcAincPUIpMfC2dR0aNT8jSOp5mayI44xFqRnlu0nX/yRXIBn9jFstim9pcKYTawz9fm/Hv7beofM/2akmvyeMWfiSplDzBieZB1Fc7p2DFRu75qMxnfMMBLnSeonbjW/BYOb7N/h6H60TMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 2:54=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> Hi James,
>
> > On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
> >
> > vmemmap_remap_range() can potentially leave the vmemmap in a partially
> > optimized state. In this case, a TLB flush should be done if the walk
> > caller asked for it, even if the optimization was not fully applied.
> >
> > A follow-up patch will more completely deal with partially-optimized
> > folios.
>
> Why are we dealing with partial optimization cases right from
> the start?
>
> I know that in patch 12, you try cmpxchg 16 times, and if it
> fails, it leads to the partial optimization state. What I want
> to ask is, why do we limit the maximum number of attempts? Is
> it because during testing you found that this kind of failure
> is very common? If we did not limit the number of attempts,
> was it because during testing you found that the scheduling
> latency caused here is very large? Or is this just defensive
> programming? In my view, scenarios with such intense
> concurrent access to these struct page structures should be
> very rare.

This was done defensively, yes. With 16 retries, I never hit this
without fault injection. (Perhaps I should try with no retries...)

> If your testing did not find any problems, my suggestion is
> not to set an upper limit on the number of cmpxchg attempts.
> This should be able to simplify the design of the initial
> version of the code to a certain extent. If we want to
> determine whether an upper limit should be added in the
> future, I think we can add timing monitoring in the arm64
> try_update_vmemmap_pte function and trigger a warning when
> the measured time exceeds a certain threshold. If someone
> reports this kind of warning to the community in the future,
> then I think we can improve it at that time.
>
> What do you think?

From userspace, you could use kpageflags or page_idle to continuously
access a single struct page over and over again. I think that's a
pretty good reason to have a bound. Also, the AF can be set even
without an architectural memory access (so a mispredicted branch can
still set AF, for example); that also makes me want to have a bound.

Catalin also said wanted a bound here. See the bottom of this reply at [1].

So I think we should leave it in. The extra complexity is pretty much
entirely in patch #4[2], and I don't think it's too large of a change.
I hope you agree. :)

[1] https://lore.kernel.org/linux-mm/aoRn3Fn1dhTdsk6d@arm.com/
[2] https://lore.kernel.org/linux-mm/20261003002123.505555-5-jthoughton@goo=
gle.com/

