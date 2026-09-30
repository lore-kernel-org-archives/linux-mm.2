Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D11CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0CCA6B0088; Tue, 29 Sep 2026 22:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD726B008A; Tue, 29 Sep 2026 22:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB716B008C; Tue, 29 Sep 2026 22:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 607546B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:39:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFC9940682
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:39:44 +0000 (UTC)
X-FDA: 85268873088.27.EF53240
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id E768B40003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:39:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K+Rg2ErG;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790735982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZcAtDmdj1TXf2oHPw6z6v/buKgWsDNfkRToankrygM=;
	b=m2igqGlU2KUGaNKNf0AochZpcAMP8/mOcVrpLajML4mEzW3o59m8KKZtH3ia1lKDrjTDCn
	XzaxWIcSrt3WlcynBifzPmiJPM7cF7kXOQRe9Kdx9Q+eYJ0o7yCXUpb520Z8cByHg76jYw
	rJAaMLHInd1xSdEX34u5oMDIOO2DUoc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790735982;
	b=MdASSoy1ZHNNg5/GTtgj8iEgxpH7yZeHZKS0wMSm1Ev2VeP++/2AOkwPFC9QyPwKdqCuM1
	87g3FtRfIk7ptza3IDXIelurRPX6mRttFIjJxDAIff39AV+8E0Sg4KDy2+Cb4NPp2ynozL
	pthPT3I2kaMMIjaSg3ockTsCE0JX8ho=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K+Rg2ErG;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-533202fe429so139701cf.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790735982; cv=none;
        d=google.com; s=arc-20260327;
        b=bKCwq/tC/zPklvBWFe/TDI7sc/hoTC0drkUMoPaJHxX1ttVa94IRZwtCWxw2wyOL5M
         T4hxZfm3yV3Xg2oYRJvLakuvKZ1zL/Z8DNbwJ9m4pdJsPtzuw7lS7CpKgkGRMh+9aeOU
         VHQywTWrASTCX3fujHytP3Ts1SNq6+pcx53psiWemS1ilJLrczxt9XLO5Hs1TvJS/nMO
         JNcyawBzJHzQ+7oAYwBpwcJAxm4tyfVEV1+roTRFUXDNPwIbMxJqnIJ+Pnoy20aFnLIE
         qhRq8H4jrb/51dkQOS0dyiGEnXBZ21nqwYij37ZJa7nrFkOy1et510V/g7QD71uqswsq
         1sVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yZcAtDmdj1TXf2oHPw6z6v/buKgWsDNfkRToankrygM=;
        fh=6kyRtjBvXUmTzOZDAxjsiOdb0y+aqFUc2aTky9lmm3s=;
        b=jUFYP8MatLjlCh5iUovTKpMbOB9uIbGacqpbZpjnJxI4CDlet+Ni6Bv97fwq0iAj5j
         7bpQ60d6rLCiB+LuxmETbNb0sQm7rJdFRIRU6uFY3Mjk82WAivRCCslNhksWwUTOEIT3
         HDUKTBptVj0Lddf0YpR/eWXxKsdNo73CZgJpT9yXte0SWy0ISUAHNTpbrRxXlQRfyvZt
         R7yzMoIehq61HLCy5sO8eG/lcz+8pgpLl1lM5DBiDsSsbxvZE/aFUzE7mHij+4HrSggO
         dVFTEc62amPAMpjFDFSK97tBJUUEamBn0lhyjZgFpZG4BWi/tOrsXX+xwkwWU9btOSUh
         4dIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790735982; x=1791340782; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yZcAtDmdj1TXf2oHPw6z6v/buKgWsDNfkRToankrygM=;
        b=K+Rg2ErG6YLjPNysH2YWpIFYJvkOWqLeCQNKz3abr+eyLnFfPOqqD441E1KihWim1U
         Nc4qUqT+BWP+F3VU73saqhCzpYc2lgPuDQIvUGd1DnTC0e5UwUr9jymduNOi+uEhJXhr
         EtX7w60+fu91HYmJBfrMnYwtA53FE914MnHcppn8r7tCTrZJ69f5FzVuQUegTDBfaZ0C
         BUPyyg6BxPLLHqArYQ8DClWzbnjyTRJV9BINaM5mVCgvklvoXwA8ToP4X5l3qNA8sHg6
         JXXK7THSqP1AhOWfL6aOQzn1XZE+7rdXYLWa6KNCeCHFfF47LRj2otSnQUzKwIhK5p1Z
         pG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790735982; x=1791340782;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZcAtDmdj1TXf2oHPw6z6v/buKgWsDNfkRToankrygM=;
        b=aQQCIvguTLIZYVpfCvpdTsO00U8MFdoUQd1g2rVaJ1Vojxvw6OuDLM5U3ZsXyHqDgZ
         AzyrFmT6Nka/l7DDhNf4Dqd3XsT17LuE32dzkP/Sdz/VYBykqyYCUG4OQe7Qypr3fkX8
         TbFYnhGZ/B7CujPOEY0rXOOJ2WQ9wvhEu7sqtKj0SR9hN75ia1LMvhRVj+Q77vb6H8Cu
         /LucKDiuuVI0fYSg9dlTdmLjPPP2AT/FapjS45LEVMWUhZ6Ej31RwK3V31jeIcrKhDzG
         U16JK4MqqvjiqdxXsKZ36ZtzGhrpQjQ3XmbR+fFejdpOfoQGvxosH1JbtpThOJvZwt8a
         vw8w==
X-Forwarded-Encrypted: i=1; AKwUvBxj1WqJNrqIw4b/1rIto91DH/xfdLrO6YZ03MUsjoNNaSNdRPZIa/dRmOQCJ1gPXjo3PjXpL+9rbw==@kvack.org
X-Gm-Message-State: AFuF++k3nj+P3yxCg/T7pr84hmf9TKeWEA0Gm6ZbC3WO1M1ANgK9yCyt
	GeIiS3aIIKzqSot4W5A918GKCJCG8jEqwzEXP69IXcAEaOGwGR07VeypQGzwxlDvG7ZZ+XK9Tpa
	h3PQcQMYd/qwtv1XVFfballFqaFgrx9wlq7Y/WBlC
X-Gm-Gg: AYBFou1ONgtGVt1/6o5K1hKzuBI66Nq/MLGrFt1s/U1y9vf54iSVIzgCcdJtUBxfAFP
	0VMr4Pw/S3kSHUI6n7gfckJ4siXcMOiKML65OefHEhQgZZPQHQFcdFbxFRxORtluNg4Tmm+QN32
	OkJNaPKnC2xmueXUxMCoqHXygAcOvzBMQl1wNziwMlYsjYQMJYkjtbQbZjavfLjfnajPKi/XQB/
	9z7eBcTN7+Jc2py0A/MD14/RmdhbYJC94IfKGI03ofDEVtXBEFtJy2ERcFwuUDKK8DQzCjzJJL8
	ypuC3IgAQP7Bfwxv7BKScTORmwMMSwp0V2jzMC2dfPDNSjAytwDbFU/NXKjPsLyz7H18beVLAwn
	7G/vinEY=
X-Received: by 2002:a05:622a:10b:b0:530:ac23:ff40 with SMTP id
 d75a77b69052e-5337423edf5mr1103181cf.5.1790735981251; Tue, 29 Sep 2026
 19:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
In-Reply-To: <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 30 Sep 2026 02:39:30 +0000
X-Gm-Features: AclHuK_-aUPMeQc44-V_AL2TS77weF01uJnbgBxF4TBRUk7jsKIWk4H7GFwQgdU
Message-ID: <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, "=Kent Overstreet" <kent.overstreet@linux.dev>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E768B40003
X-Stat-Signature: jz3rswh11knxofqthes95aokiuaap7wj
X-HE-Tag: 1790735982-667593
X-HE-Meta: U2FsdGVkX1+JY/8rkAyrd/uxXiOkFyN/gBOCok6giKQz21C1QPqGq4ZqbshdMkSkst8IOTiscYipdBdc1pSk/Q+wZ248ibOVpdpkf4LP0IaOKNS/CxTQw4l/BL5WYwJliPP5i5GKQKjhgdylAqF/Htiqz5kBqDXJeMptelxsaMg8ljTS9jL9eYAjsU1L8VXI+vXJ6k3y6J2cHQlEN++JHukV5AHLuyUUTdlObQPX9XV/GHqod7R5ORbe/xiZ/uYEydYcl7cLTdtT4u+DdYCM2t6R++E4yGeQkZ0BVmJQZ6ye9bV2lvGSAzp4cqfXftvH64n+f/8KG4oIaw+hVJ4k096o0zcahUHZgtxH52FOKoiHvCi7QPMqIVFtqCtNizyz22A/X53gl8YPF/b8bdSuzf2AGEujaIiDToYuJv0sbnEZ5ZkscTPPmSQ0Pu9ay6FqUSg603IYyXS4VHtblX9g+mFgl5OkMu8JDKtWeHYnpyBb98wNq2h8E13SUcV5Is0RHqGs8ISc+m3uzWLJclTw7ua6Lc6Y4NM/dSy+9D59H1ooRF9XOv4Vh1aFWVv6ENsT1rNAT1iiUY3/uzCk82pIYzP2OaEbWuiRXunrSqGL2kv7O0Si/6M37/EGROvgvE8eXh/7AEDpQ6v003WcUDhiYCa0xvowg83VZBN4/4p7mHfU4zqlImrdTfLxC5VdqyZtLFG+f7GmF84MJfHVbeh6kfs5ghW3I+XPXdxllP6KEwBWLZbwFDgIkKmoFtoFg+yWMsvD5T0LtMH/qh/tByD5CLtcZisDYgWcCeO5moliMfBJRrklQq68Q+fE0aBMmqdRLo1zN9c5V0qrnaevGosN3RvRtVndOzKzQKW5+gCVQn3U+dvnB8+Xpbx59Sg7Wj3opCpljKR0PoEHKUMG9vXIE4e0iZymom/U6cejVMfblAWJyS95H99mRzB3rNQSDePu2llqOyiuEfffCUWHO1c
 0nvzTGGF
 4TkYGS3NTimdDhN1bDmGfH5GSJ8ih2NkhvKo1EId/u+pS34MNnhBAsf5N16Cad5of08D++GQxZQUEXv9Hly55HBrS8NzBpVCSqpniciLxe52GBO9tSwJAs2lcWzhfHRCu47cglycgHFjW0VH3wfIOQafH0a1UUnxO8KaYTB7WwpQDOC2fPBma355BftelfBGRqoLa5zBSPwSqk8/pyTEsRvO8BzUIan4S4A6Zeskp8lOyERXHHnyTh3zeGy5/t04zmn69HoJzXtNKk4hMf+cm+KdlQkMxP5En20R9YqgU8PY6/eZTp7H9UNRXE9N3Slp18NjBR0iWRFAVHrn5QYgRLdC4zjebERPnIyvqhjRNRGRGRojJuPGlv3xTYaHYscwVfPokKgOSf5CP7U+59su63NiQkSjjt2y09qhrnND5wlyrXPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 8:44=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
> > With profiling toggled off, the overflow check in
> > reserve_module_tags() did not run, a module could load with more
> > tags than the page flags can address, and re-enabling profiling
> > then silently corrupted /proc/allocinfo. On overflow the fix shuts
> > profiling down, releases the reservation and returns -EAGAIN, and
> > the codetag section lands as regular module data in the same load,
> > so the module loads without profiling.
> >
> > Review of the earlier series by Sashiko turned up more problems.
> >
> > One is a race. layout_sections() and move_module() both asked
> > codetag_needs_module_section() where a codetag section goes, and
> > mem_profiling_support can change between the two calls, for instance
> > when another module load overflows the tag index and shuts profiling
> > down. move_module() then copied the codetag section to offset 0 of
> > its regular destination and clobbered the first section placed in
> > that region.
> >
> > v7 reworks where codetag sections are allocated, on a prototype by
> > Petr Pavlu [1]. The allocation runs before layout_sections() and the
> > placement is decided in one step, so nothing re-asks the question
> > and the race is gone. The retry is gone too, on -EAGAIN the section
> > is laid out as regular module data right in the same load.
>
> Thanks.
>
> Seven patches, all cc:stable.  Why is a backport proposed?
> Documentation/process/stable-kernel-rules.rst gives guidelines - does
> this series meet them?  Does Suren have thoughts?

I think vmalloc fix in patch#2 should be posted separately and clearly
quialifies for backporting as if fixes issues Hao found at [1].

The rest are also bug fixes but their size is concerning. I'll review
them first before advising on which ones should be backported. Some
fixes address issues that happen very rarely and if a fix is too
complex it might make sense to leave it be or fix it some other way
with less churn. Please give me a couple of days to review them. With
the upcoming LPC I'm trying to multiplex between several projects.

[1] https://lore.kernel.org/all/b8005c24-ecac-45c4-840a-fd282f9693b5@linux.=
dev/

>
> Also, Sashiko has been busy again:
>         https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@lin=
ux.dev

