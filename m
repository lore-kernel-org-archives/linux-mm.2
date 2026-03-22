Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BA9FC72D4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BE46B0005; Sun, 22 Mar 2026 15:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC58A6B0088; Sun, 22 Mar 2026 15:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CD36B0089; Sun, 22 Mar 2026 15:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A826B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:26:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 235D61E6B4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:26:47 +0000 (UTC)
X-FDA: 84574681254.28.B60A671
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3C7251C0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:26:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gda23Wk3;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774207605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bgdggyq0/oyLyjb2FYH8nUxRMH811f0m3byMmRZLmjk=;
	b=4XY0EuRIY0lpKVB8kFlPrBPGoh4RHuxZc2fJfUwAMmfEcAzS5mmmIIYVbkQL6ZC7BXzPog
	tFAzDRpky1B2uw5UNMrl40woSo2L4sXw/3AdrP1GjixdKNrpZRbOSrPCLTNLADpvSYcyxQ
	CUV6FWHbllbygBiC4984iYHix+hTrCg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774207605; a=rsa-sha256;
	cv=pass;
	b=xgrDsszg4SofDf4PtK9jRHKhvka2YI4Usjua8xEfQinvDTqd60G39Xec5f+d3TUgkhR1Xq
	sdBZWaqn1b4pswdwXRRGtX+ZgmVUBatfeZhfVUbeD03gljhyCufOQ2CqxjPN9uKiSYNM04
	ioJIpRMwwFDDQgmwXoYLWiTMxxYHZuo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gda23Wk3;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-415c8a4d2e6so700617fac.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:26:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774207604; cv=none;
        d=google.com; s=arc-20240605;
        b=kTFJzpRbHRsYFraGoRsZ7eihH7mj2yurjegPJSW0vxp+cpoSxB963M9HIP0XZXQkzL
         gL3n9G38Y4TaxdJztx/9SxAGa/ml+hhL5n4wkDCzKyEHAxcbR7tJbBJ3vdgRkJ51rpbX
         Ei5lvD5snCReu7hEVYIt2+DBtUVHjNBCe63JoYNo4i5GLq+vXwxTQW1b2PyQ2VNPLiBh
         Dl+AOUF7cMlvAbi4KWj6DAGbe1RM6+j9Vw9N9Tg6AERpR7xmdtExR4K6QHDKRyuDzzIF
         fcY9sPwr4MEBTopXwp/2llUATYHWPG6JHA8kVCZmbNAqcVMP6cLnPGZWQKla1mAzpVa1
         R+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Bgdggyq0/oyLyjb2FYH8nUxRMH811f0m3byMmRZLmjk=;
        fh=D0XjnbRz4YWXgPurUegYxMT1OQ9v4lwELPQtJObkoso=;
        b=Go82LLf4pC7hnVUHcrqUDRo+9BI1Ntm3ebb+xyrEy+2Ff0Cxpslh0mIeloK8DxeQCs
         tw7rLKMNYeTTuuNE5Bjz4HPWCRuv7nJpO8WyPD8ScrqK5VRKCQs7JE0YC6PKUTT8b7dB
         rg+UgBHPpegh/tf2/ltYZ7eWfrCIt5rbluac+iJ8Oi0VyZSb/UpNlFjaX2TxP9ROz5Ot
         q6aiDbe3L1pm8xAo28xn9jxggkXZJD+MS6uWfb+wPTfvzCCHpz11GeuXAo8XHqphkYff
         lnHeajaHGDPKpfIq4TJc068eByYn0yPklUSE3tF6+JZ5NR46tS/+bpr2DlCWCXy/zsSI
         3FaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774207604; x=1774812404; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bgdggyq0/oyLyjb2FYH8nUxRMH811f0m3byMmRZLmjk=;
        b=gda23Wk35yP1u5ZUsGgGETem3GMU3ArjSn//bPPFlVwURwQJiejL2lQxjIQFcz9b2O
         L+bUJ2rrew0yPG/7lHDFiIS4ehARQpKoULoGWD00dpVSVqUUNGgzrCDh4WPcQVWJqlD8
         HIMp6GwxML2rqqkM4sh1e3TC38KBKvbinuauIftITeGAFmLStKk57K8ncA7at4qpvCyd
         bO5MNG2zZScBHlKiZ0xoZQDnok/bzGZOfuGSXiduabjaP3HCMHNP3wCTziqaY1FxSs1/
         Kzy0IQK/+/igfsYT2+BB1kr0UMETBZTwA3By8N0CS3E6klEoB+/rZNEOKwhi3HaUNGha
         i5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774207604; x=1774812404;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bgdggyq0/oyLyjb2FYH8nUxRMH811f0m3byMmRZLmjk=;
        b=rZDlrUzMk6nR2ORiP+pNbytb139SeMFA5P/4khRfK9cYMWbYb3sD1KvTgJ6H4wNqfr
         w2W9fn3adH2abpaDnK8zTNnYh9e++2zHN/MLa/atBjNhhbaHpCVX2tk14e2CeqAEk6EK
         6BcZchY6loWFXb7O3OjhArB/Up/N4e2oLxIdEZWwSQQUoDh5um78i4AH8TobDUi+ECaP
         HoqpdVEn49e3klNqajZSGSuiMOOf5EuqXrtb2LK9m3hRGsXJbTfWpHA9AuobXy30nbN7
         RbIx7+WlqdE5JSrTMGxmul63UV1rskojvHzZRQxgIFeQj5RLNQmqXF7GRFHHiSxYvlgu
         2sZw==
X-Forwarded-Encrypted: i=1; AJvYcCX2Ll4jqjaJgXSQCWblYfLQqvwFcg+vaW/8Av7AEh+TG3VbsedVm0dErhSTfJD8GjvVxwYXNWe2nw==@kvack.org
X-Gm-Message-State: AOJu0YzvuPHm3CdTGCg3qAEjy9+UTI3IN5ewuI4MSfroK/ZN9DUQ/3TI
	wKkipmnmKQpw6srkWUWH0w0Sn1+BI8OYjfaq22Vfm8WwU7j0aY20ATBlZL3Wlllz8yT1Jy9uKP0
	tMEgr+UHU7zMxV61Vyvfo1f1N2lH+/7I=
X-Gm-Gg: ATEYQzw1t45phiVYI3kNt6tNtgPFFQLEdtYpgRvZmRXcWo5bVahsU5JPL6oI0VAHQZn
	sipNXqbzuIDDwojpUAK4HN1PC3pRDkTo0PVe0lH6OtGeUQFxhFoct9NhZKfXyhWPoa9uHHId5VR
	b9tMsShPSH6xbwnvOf9ld+i/foh6VYfDF6cik4tz9vFZ2ZGEiWKk2qkOJ/BKJrUqYkzeho+oMC0
	YW5Royzz0vszmZC36c61NWtrZbdRangwt9b47E2UNalMjURDqtlbKxlh/un2Ze8Y/5d9ZPFNltj
	xOMaRVul+67WZpX7LAXYNnEKns54MGz23Uxlkg==
X-Received: by 2002:a05:6870:8988:b0:40e:b6b2:b97a with SMTP id
 586e51a60fabf-41c112c7312mr5973280fac.51.1774207604139; Sun, 22 Mar 2026
 12:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260322080142.5834-1-devnexen@gmail.com> <20260322164943.37460-1-devnexen@gmail.com>
 <20260322115452.29f2ce981610faf2d7b8df32@linux-foundation.org>
In-Reply-To: <20260322115452.29f2ce981610faf2d7b8df32@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Sun, 22 Mar 2026 19:26:33 +0000
X-Gm-Features: AaiRm52rCpQ5CDXjSzyYVhuRvJs0IHy18nzsUG2phl57c5Mq-e1Jp1XNV3VRxnA
Message-ID: <CA+XhMqx+5WSxpvHdjC4iwhVTq5ETYfn56dHMT6TbBY-7H1CtoA@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online()
 error path
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 3q67513knhb515i1azgj633tac9xs71m
X-Rspamd-Queue-Id: 3C7251C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774207605-849570
X-HE-Meta: U2FsdGVkX181Q+WnXhc1ybk6YZZgstqEix3ODItThmLLBdLfLO+W0AXCTPP+ApioVrcTanoDDYtqy8z07f4L3jSvavqVrGvCHB1IaB6QzwjJEgyu/S1MN8p/sMolUAQwT9YpP0st6952bV2BmhlzhQeQoI8/EJ1bUKwiGEWKjQt8PNr396XGVEjEMHe3Hrldtorwwc/4tRyFVfC8RjFjAcEjk9pEGC34l+E8HSfm33tnjDGEhqLNfFxUPUq2wAbPsA0Ws5as3Z6H9jeEqNz9VQBMK/IOlsqlauxsUBantYCbs/TjciDQzsIbjfjeenyVvI4hbYa3OfMGkWz1o8qHf54q+Tz2gcwNssfETOBZZRTQiDA/pMNeMiclxNVb1cf8gv35/tBO6OcAoKlqYNwc4SA2zLpKnFFnVn7/3yeCxwEEiz1J5SX0CoZpYOuANgV263hga2A00r9EwnHgcsf6LLettPUSP2YQI01cy3nKGgdZ10eGiFm0g5kzjzcTC6NCk/T2rZ9WgKO0Zc19tBtMEYe9TBcoRr21SfTwO8cmuG9f6qPpZGlvkxK112UKzWqBCVPBFIacZdOwl6jeb7PPO14mlnp7Qx94cfm62GcThQktOSgPXxVYmmLSmrZ0BGpfgQRvLRaHNluw1GpPF27gmb+QysnAGNFMaLcwHJKwqIgqvxYhBqYRqqA1eKKrvhB1lRlwRUYMkAHFPSUid7kTcH5KSfaUmuch93C6HT++blDAPxpxfl17bbKQzVAR1EXv1D5gL2wvKhLvTppCg7+Re3Un41tF6cAktyFkW8936x4tR8O7QbpSZlP9/+vIHLL/WMUoGzPyMUnaK8tFjYgpu7h4zzhLZWZ03kLTb1trBHf0T6BG6GyU1aiRTCVuXrC6rYoPRTwmsQzfIs14XYZSKp1XRKafrlY8ZMsFwKjrech33EKqpCZN5F9b03oWGDdVH1XA1Ba7O+dbYkBPsqz
 anAHxj/8
 2FPqm/LRnwubt8AkdVlC1cagK7nc/l+tXDSGo2DMmdwQRlBHTHChA/b6GHtHsfdkE1nBG/2vHp3c06Om7rBRgvnfR51qUi8lCfYEA4h2fSegkMy3CW19WONgvvD2EnHlxMxnzyAiB+2b4f9cE/Gk/99/TSL9B+qoNrvNf2J+y20D7w61EeTKPAVH4LObgrmLyVefstmpXnKWKUfZD8Fgam7xbXcllBopKmPXkZMHqbE0iG7SiS4uzFwkJQ2elRWP/FzTWdjaPw5iAHdVMfp6B47hH03klLKYiV/1Quu+SPRr4tFCcrEG/GFfRESViaz7p+9yEbV8zQnXAhAv5LioR3yi3XOUIhpzj5EAHZk4bZTmzN4dH9I7BxmIqoP+XhkWZJRbE/QBldzjMtZfGR4KEs2s3cU4q1lDEKFUdt2Ml86zPvbp38IGqB9J2rIhYRJt6ZLH1+gqtn+0HOw4WwgAciBtgXVXdnoJkcblCpkpkXbl3TpPz5JG30mhKdQc1r3Em2H0E3rG2sEfgYfR5sYnY32CLxV6fDb+GU8Md6hiCdnMl0osEZnFpdf83fXtOI9PZe6OiJ9Je1Q1vxztFQ1JCQ+f4+eQGp2f21Kls7TsHL3sbUvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both good points. I'll address them in a v3:

  - Drop the redundant pn NULL check in the free_objcg error path.
  - Add a NULL check for pn in __mem_cgroup_free() to guard against
    partial alloc_mem_cgroup_per_node_info() failure.

On Sun, 22 Mar 2026 at 18:54, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sun, 22 Mar 2026 16:49:43 +0000 David Carlier <devnexen@gmail.com> wrote:
>
> > When obj_cgroup_alloc() fails partway through the NUMA node loop in
> > mem_cgroup_css_online(), the free_objcg error path drops the extra
> > reference held by pn->orig_objcg but never kills the initial percpu_ref
> > from obj_cgroup_alloc() stored in pn->objcg.
> >
> > Since css_offline is never called when css_online fails,
> > memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> > normally drops this initial reference never executes. The obj_cgroup and
> > its per-cpu ref allocations are leaked.
> >
> > Clear pn->objcg via rcu_replace_pointer() and add the missing
> > percpu_ref_kill() in the error path, matching the normal teardown
> > sequence in memcg_reparent_objcgs().
> >
> > Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>
> Thanks.  Sashiko review of this patch claims to have found another bug
> in 098fad3e1621:
>
>         https://sashiko.dev/#/patchset/20260322164943.37460-1-devnexen@gmail.com
>
> > Cc: stable@vger.kernel.org
>

