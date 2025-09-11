Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22400CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6546B0010; Wed, 10 Sep 2025 22:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE6C6B0011; Wed, 10 Sep 2025 22:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAF66B0012; Wed, 10 Sep 2025 22:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFF46B0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:31:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC95F1602D3
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:31:42 +0000 (UTC)
X-FDA: 83875393644.08.7A54F5A
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9F9A40006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:31:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYJVtiWw;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757557901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nP6wbCxq9x6mQLQiBSlqIUPtCF+SQ7XDDNdAR44nPo4=;
	b=0moqtSaWNgU9GB0pOHSus8RN8tRlskaqDIwoq0rs0wTTF6KO9sr7H8bhZaNxeeXhT0tirh
	oIJdrl9bX/bhPxDRxsRaa3t0h4gzdpDjJKwaiUxG93LPk00X9x28WBFtS+nCMyQAwVtuZL
	Au5+RAPhcHcGlFgfCyKBdvy2lNRECz8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757557901; a=rsa-sha256;
	cv=none;
	b=NjC4clTXo4sYtLoG2qyqxSeXPAWUqBDxVqEkDs1EZB5zG81AiLXcUalT3kYF9svSz2C+Bt
	vKtXXGJ8EKqlPpzzvcYrnpMQGqKZOpdWzXovun5MvXhw5jLjBlXmlWYuKW6mu/novC3/Yh
	BEDQ2XR93QRoIgtsFTwda5NhwcdIp0s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYJVtiWw;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-729c10746edso1993176d6.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757557900; x=1758162700; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nP6wbCxq9x6mQLQiBSlqIUPtCF+SQ7XDDNdAR44nPo4=;
        b=LYJVtiWwOTJp1fUj3pwsBxvCGYmZ8sBcrh2xFs8s8m/IjCyv/R0xsPQr7zBISMy5Bb
         pDxqVS1wVmO0ApUTe3XevPXRmWyoK+Z9qUURSeojbvqHZzyTuNpd4WzEi5fsHBQA/MfX
         NJrRwT+Ae9+CiGwkf4J+zh96JMlDsIATyCwguGp8VJ2UQWWfou6Arw6NHXRkRjWDUVkm
         gESx4g2FrXinpsRArUCXBzjCfCxc3H3EjUXli4P07CxBbvyfA8Kyy+IPWuaZGJunpsGi
         dsUZHYYfHf1jK0HbfQTsqjJxcwvinoBxSmCr8q5Vv57Xl+5tbcwfn/bSHYskS7JKPA0V
         PzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757557900; x=1758162700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nP6wbCxq9x6mQLQiBSlqIUPtCF+SQ7XDDNdAR44nPo4=;
        b=kLGdixVYccrh5byumWtfVl1uG7Nxc9N7m6VAxy5GB+7MRD5lXJRUoI8WZrR0NkRYYy
         b/LIoAbxYQdovkNDJqzT0uyCZ/8kCtWx1A0A9ROnMt5lBvZKEZb/9siIsBgU9L0kOYWu
         g1lNSBsnbDPrFp8gW2FnrJy24//5bPmKmXjHA7tVxI9ZzefT4/HXP082/T3dImQyAguf
         cXnaCouzfpwgxuPQBcA5FdWCv0tNGxyakOz30oyCH5k7orQd71FzlJfLT5JqfGrIr9jj
         cYwfKAwWmE+K6jRhAbo/KCbPXhxk1bWEsy6dEQXVj2lUfpEmjUJ69ZtRx1D3I+Dm6mtD
         oKcg==
X-Forwarded-Encrypted: i=1; AJvYcCVVd6S2Dl8tZb2s4Co6dXHuAWaVgEtjQS8Qf+BNXA59IFxiOrUQNLCPb7QHoGRUCteOoHHXgetnBw==@kvack.org
X-Gm-Message-State: AOJu0Yz6GCfsD5026qAJKNwgKROk8VaH8gqfRukUujvY8KXZjI2ds2d0
	uHCZ9UOoVXbIXyF8mOC8DkcwdjjM/fLMVfR+FUZJXaeng2Mru7t+J9f/5IK1Y4bcR5MyjXt9j+m
	rlVVT86BJTMrj5C1j8EzdT1FSgOJKowY=
X-Gm-Gg: ASbGncuZkdLd7VcqeXu6bFyr6b4zB8mCMJDyzXR/vWIeAjgYPstU4r0TQHIUrMaVVe5
	jQn0tcvKkYITlnCQsHjAe1vwIKkwiaIRdLsamszIGm2a1ryu6PCR4Z1mQF8ompB1/zsPuoH66LB
	+rZr/FfSMgO9/9vwmomk4Mjp13vxAIYC6+GAvB431VPXxs+XMGXpdbiSZd/3gj4SmH7+nAreNjc
	vVAaOwf/YTdidAszTPoqC3x6bnbExwrEHCXBNuD
X-Google-Smtp-Source: AGHT+IFv4549Bjlkb1Z6NZ8k1soS7TwcDklPSqOEtK13et4tNf5IIQCCxGt2xPSm81jmjCgBMMBrH+SVQoPZVCSMjkU=
X-Received: by 2002:ad4:5dcb:0:b0:722:f52a:1bd4 with SMTP id
 6a1803df08f44-7393e0991f3mr201672756d6.63.1757557899833; Wed, 10 Sep 2025
 19:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-8-laoar.shao@gmail.com>
 <CAADnVQJF6YtzOojGV16hmUpFCiZGxuJAi6=Q4TK=VPH=_93eJA@mail.gmail.com>
In-Reply-To: <CAADnVQJF6YtzOojGV16hmUpFCiZGxuJAi6=Q4TK=VPH=_93eJA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 11 Sep 2025 10:31:02 +0800
X-Gm-Features: AS18NWBQamtUOb14Z7OXpCMF7HjTdLWXm-KLhQksJqZVjzlAf4LNyGFT7O4xrGk
Message-ID: <CALOAHbBvwT+6f_4gBHzPc9n_SukhAs_sa5yX=AjHYsWic1MRuw@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 07/10] selftests/bpf: add a simple BPF based THP policy
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9kcedbdt5pii6yxasyg8ou6gse69q6u5
X-Rspamd-Queue-Id: E9F9A40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757557900-151138
X-HE-Meta: U2FsdGVkX18j5YnqDSCCuvF9CTO8I8Anhp0zjC+Gr+iyrpRXVWr3QnlCirzOagM1FBLQTTjJJCgQqsTgcZBoblUUPdohTNoZvLX/7+UksXtOF3ejuMdLtZg/crUmku3a9lLdjxdtdvBa+DB6Ue7Orfs5tY9sLQemOdBOStRd1lPa7o4RcW3F33Wb9PJrs4Toq2BVUJDxOwGvQBGVIMy2Ncl22kZoc6NQh5HTvcu1gFFAV7Nq9cV0HwFJoqEG0TU+tNKIDNltQzAhNNBTLbtmWKJoGEqJ2l+SefmNM5gDiv5AWMYQxRAYQ8cXeccIqqwNLa6SfrleYGDu3VXOZYZqWApmAZW/cRifZ6DHxGw/Z3T6DoxcY0fG7jdZ7rSbovLob0TTNwTEEJtSaivBJ/h/kCypU0MoloIp6ylOYOr28SZCcFXJKHkad/SH4AF7nJrya75VkHPVX+tHVmhPDNp2PCGVNiMZo3UuksdYd3qsZDC9Sd+oU2oZDbayPe2u2EBNutY2nIP9Waqxlvp3pajoS5MhHqmF6BdzAn2ZG8ymSK4TAkr7C9QfrtjNV2Vs9SVgIvb3tfufiJK3aEibVyTW++vrFyeR8tEGQoXpDPPQokVX8SscSSsRr+UsEqGhJgrWpgF7jbxSHoCYAbPwKTwbNdoHjfIxqV7jzPvAbrHF40BvLs6s7lAWBH96Ssix0b2feDjvZ/+tapR8caTQ4yeywzodxci0hD3gXR0cRR1q6n+xoHiInjMmyIgCmcLiFRdGrbhOF0NUqnyDAvdbrvUk83WzrLTvi+YtwGnJ1wmcAg+jiZ2dXI1SAYiQ2zi8uwmcZZRXiP0lVjO1dfDsI/IKPOuyfw2FIE48cupUF3Rj0h4/86juk+i5gIXXB5co8h7Y/miRZhAH5ohNAFT2E+68SXpDXZma8q117TtaRPNNS/+r4/Keg2jrse8asqsvvdO3M/1VKwksBoe5/zkott0
 WLOuKeIk
 vL+IjuNH/FDaHMrC2l4rnf//Vkajuo9VXgbx+m0ks1NnAFc1VWzBOUfL0erCLYATY2tzu+jqPdNMINuf4U55fhjcRaJLKxezYAdIktrV7e5Vvd9E6Uyb+uRVhrHyEFlQsO3Q1ArgNGM56KTtucP8lURSnFo8BVRCsCmvOaOLUKY6H0iFOnZI8JHhqPlduD3e8k1wpxDeKH8XworFzwO7p3RDDznGiEpFioDtwm1Hq8N3oL4v0vZF00s4DtFvDAE8OLTEuj9mh3cN27KVjq8jJ/YOkb4kLLFqr5R/bDZukO+7RIBJdStVQPfS4VXM4esENdAsi6+5ltT8EvnMVXrxuiZLTnwFr72/zG6r2ydJOQawpBGEoeuponzizacUG6vLsMPVjkEakRwK7RG5P8URbBizSkoq7rUTucN4AGuyjRG9st8zli+ImDhp4d8ot05k/ZZ5M2m4qgJN2JrW0NlMteH4JhC1VlGN3XXgIjbn/cAvnNyBgtCIDrHQyChwPtRgMXV5vspMRt8T564DI76jDdh9e3XZbQk8h3d1XY8cfE8hEzkj0je9jq6zphQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 4:44=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 9, 2025 at 7:46=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > +/* Detecting whether a task can successfully allocate THP is unreliabl=
e because
> > + * it may be influenced by system memory pressure. Instead of making t=
he result
> > + * dependent on unpredictable factors, we should simply check
> > + * bpf_hook_thp_get_orders()'s return value, which is deterministic.
> > + */
> > +SEC("fexit/bpf_hook_thp_get_orders")
> > +int BPF_PROG(thp_run, struct vm_area_struct *vma, u64 vma_flags, enum =
tva_type tva_type,
> > +            unsigned long orders, int retval)
> > +{
>
> ...
>
> > +SEC("struct_ops/thp_get_order")
> > +int BPF_PROG(alloc_in_khugepaged, struct vm_area_struct *vma, enum bpf=
_thp_vma_type vma_type,
> > +            enum tva_type tva_type, unsigned long orders)
> > +{
>
> This is a bad idea to mix struct_ops logic with fentry/fexit style.
> struct_ops hook will not be affected by compiler optimizations,
> while fentry depends on a whim of compilers.
> struct_ops can be scoped, while fentry is always global.
> sched-ext already struggles with the later, since some scheds
> need tracing data from other parts of the kernel and they cannot
> be grouped together. All sorts of workarounds were proposed, but
> no good solution in sight. So don't go this route for THP.
> Make everything you need to be struct_ops based and/or pass
> whatever extra data into these ops.

will change it.

>
> Also think of scoping for bpf-thp from the start.
> Currently st_ops/thp_get_order is only one and it's global.
> It's ok for prototypes and experiments, but not ok for landing upstream.
> I think cgroup would a natural scope and different cgroups might
> want their own bpf based THP hints. Once you do that, think through
> how delegation of suggested order will propagate through hierarchy.

+ Tejun

As Johannes Weiner previously explained [[0]], cgroups are designed as
nested hierarchies for partitioning resources. They are a poor fit for
enforcing arbitrary, non-hierarchical policies.

: Cgroups are for nested trees dividing up resources. They're not a good
: fit for arbitrary, non-hierarchical policy settings.

[0] https://lore.kernel.org/linux-mm/20250430175954.GD2020@cmpxchg.org/

The THP  policy is a quintessential example of such an arbitrary
setting. Even within a single cgroup, it is often necessary to enable
THP for performance-critical tasks while disabling it for others to
avoid latency spikes. Implementing this policy through a cgroup
interface that propagates hierarchically would eliminate the crucial
ability to configure it on a per-task basis.

While the bpf-thp mechanism has a global scope, this does not limit
its application to a single system-wide policy. In contrast to a
hierarchical cgroup-based setting, bpf-thp offers the flexibility to
set policies per-task, per-cgroup, or globally. Fundamentally, it is a
more powerful variant of prctl(), not a variant of cgroup interface
file.

>
> bpf-oom seems to be aligning toward the same design principles,
> so don't reinvent the wheel.

Since bpf-oom's role is to select a task to kill from within **a
defined group of tasks**, it is inherently well-suited for
cgroup-based management.

--=20
Regards
Yafang

