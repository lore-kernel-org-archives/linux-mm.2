Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889C4CA5FA5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8400B6B0088; Tue, 29 Sep 2026 22:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8170D6B008A; Tue, 29 Sep 2026 22:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706416B008C; Tue, 29 Sep 2026 22:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C12C6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:23:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84AEAA05DB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:23:25 +0000 (UTC)
X-FDA: 85268831970.22.A512B9C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70B5740004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:23:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="c/FfzsI3";
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790735003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vLlhqAX656UZF2DVlvNl7Xv9KAC8IQur7PXVrqRRyc=;
	b=vPLnddH/j+Nr94XrV/rgHyHk6mWliJNckB9WEbtDUaIAdHr83exuNi8IhhHMdySrrm92eJ
	TEjTC8caCyej/jDahlGwuEMMMbckS2aoriQJxy9dQO4Gmm9BGowP3r9HIDnBcmo1WBqvC8
	k2PA2PQ+fSzBxehjLChOLaKawi+lW7Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790735003;
	b=l3UumfDPF8qU+jB1Egr7EhYfKphIBzYTeISAMiFKrEg8QmGqTAidEWCYWVSpufTp7+yM03
	OuJ9aYa4TdAORRogzYaUBgPMbcbWgApZw28dRO0zIEQ8LS1xo2dAIdzoY5Yomm9Q3iOiXW
	hqMBzwoR13/j1idVP4Vlv8hjYLSFPFg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="c/FfzsI3";
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5333401e359so76561cf.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:23:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790735002; cv=none;
        d=google.com; s=arc-20260327;
        b=EbVwP7FEUdfgEa5gdqkUbfiMfeboTv/AUBKj9lT3Suy+5SfGgb5/r/tBahLL5WzPKM
         Jkr1TC4pJ9KI+SRf067k2LN+LI0MlT2wXt0T1KCqciX+j4uEbkdPFdbNq+sv9S/WYf1n
         8ugXNHtpdxPQDqqtbe3mkkZZw7ygLqKS3iKkkVCQvKiqSZ+xd1lm4dhQV66NUFa+rfpc
         5stlAK4SaDMWGDJSSvpLMsi0zcyuRPFzFSGmH0DJgR1QmugJGQBVNx2ZBLGVZIzqkk50
         uvwBoN8PpMGFt9liq1wxcNh7H7iHeaJ6duXDQ77jcLVTnsxvLx9mF43I/Wz6p0xwO4eB
         nnlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+vLlhqAX656UZF2DVlvNl7Xv9KAC8IQur7PXVrqRRyc=;
        fh=g20xO7qd25NGIIHv1g1aqolmIvMGpLvsyEZjycJMJLA=;
        b=kg5hDxe2+gx/6H6zym7uY6Ksfbx/A6nXlvPbQ3HU6zuab4O0/wgePRyLv/wdVeTsWB
         I2qlTDqkPRvOnjtxY/Ytbhc/sym5d2NvpciDVcThhoj2cFtMWTcvO80z/wnCEL69EWtH
         2fecMHtGhoEDKhtT4E787xAa4KfnxRjR1UMTEOhw7PNPE8JfAETNPc3mqBNMHSAUEmxg
         I4C5RwM0SpUVFBt3UzHkxU5/NWY6w3BPNgKKYaqLoK4l8mpg2JW23mYclAsHHBrF94TW
         YLHqnkor0twCSWLHf54HmZ0ReMzM7h05VmdiD/Mo+4iYIp4NuVa/4YW/kDzuao1zoiob
         DZmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790735002; x=1791339802; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+vLlhqAX656UZF2DVlvNl7Xv9KAC8IQur7PXVrqRRyc=;
        b=c/FfzsI3s2nU9Ayt1bnpth60aMEBBn1ktQThJ6ENBRSWMljT5KglnKe+KxttosSxj9
         pwOlQg2pz5sqozuPvFKbrYrzw02Y9TWdyM/lGi9PlXFt660ips+kts18DSMwmUHIgDEX
         pjnCE+fco1qsRr95YLdevgO/H2ShkD539/hzXKdF5/T0Bt4py8JDuqyP4KP+2RHBwN5O
         Xc/iS1T7mgxyJChZVuhVJx9977luKVjisppkoyxhnAh1HJjrARD265uasjMV7H7gln/G
         3GHU2gucPiUtlAZo1hoRh7SUpA8pU2ZO4Z/7dGToKt/bpyTkMY2igMoSPDdIWGOqijYg
         IYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790735002; x=1791339802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+vLlhqAX656UZF2DVlvNl7Xv9KAC8IQur7PXVrqRRyc=;
        b=t/Ui4gmzm67q6KcN5DOUj5ujB/hW7YyhP+Cyfbzrjk6o/K/+Ui72vvvwEuAralFHCd
         mrw6YTPO5DBW268Jbh4XgVX+FOJWXd3kCxdryAk1l2QgUB4Uee7zhB9hyMLyLY0aahRm
         uvwpeR7HGkaIZNF8AHd7qjxJm6NAGCL7yd7534bi3PafIBhJB4DX5bQPCn/o118gXwjs
         F6o2oJOdaUxQVxl+W14r1Knez5YxezHKebcfrnKZE2UMEpErOOyMaH2yLcxkdDturyoo
         oevmiq5CiDRQXxh5t8d+Cc1H5VBENDj+mH/uj/JomFB+tfbAhtl3ZbAgxWZrnmCJbWjs
         4rhA==
X-Forwarded-Encrypted: i=1; AKwUvBxVHOyMHd/MetNR9skGMAUSJ3cDXciYiiU/AndSF8o/xHLkZy4v11N96M3S2zjKT2lvkMALI0UV3w==@kvack.org
X-Gm-Message-State: AFuF++m3phtTiHjE+FIhLQbI0IWZ2whlx8BAilK3BaR/l35eTIUyjl2M
	6CNJM8bJtJoXvF6tj0qe1FlV1uXnPtc4TH0RzvK8TFZQBl9P3a5r4CEN7ix61HoSRvz9gk3Cv2o
	WbeGZNMjJqiIaysjE/XxCfZ9hwOl+wdz3ySV05lFz
X-Gm-Gg: AYBFou1tUi2M+A8FVJ36nrGGUoJq87oL1qgmimhw6P5/8wtw6HoGdGXEDUPX7GmJHR3
	t4U7xJc7ywxRmuyB/uVhrN9n7MgSIwsUj9QFCrn+ZesXP8PyH9cYxX0KJIcRWkMwnWPJDGmx2rH
	Ar0Y8QIJ0BVoHXCgjjhLK2HRZXjg8b86KFucWwjtRPw1TiU85uTqpuYXxTBgZG9Wr4ObDBmhQe6
	YpBgRXfIk51IclP1u2UE4IqfaFsPoAAW3poDB1a+yWR1tj5eyqCVpw/lTPaHQDAk0m03VNEFrQS
	0bHbIFePDpzgkh2/NJOnd99FqSZgmHF6iAqzIXt8J8ENfGLAkpOpP0qJyp08f2t/+XXajOSsRW/
	nY86E1Ojr33B20wwpcQ==
X-Received: by 2002:a05:622a:4c08:b0:532:a17b:9581 with SMTP id
 d75a77b69052e-53373ea61eamr1028981cf.3.1790735001796; Tue, 29 Sep 2026
 19:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
 <cb229e38-3e52-4309-9594-0d3947c1a81c@linux.dev> <CAJuCfpGZf+HDj8B2vV2WB68P2JMyqctF5CPvV0R6x=WU7+nwvQ@mail.gmail.com>
 <cf6ff2bf-1b3c-4575-b981-fc3c65625d5d@linux.dev> <CAL41Mv4nqEWkFZajL-Z3ny_gx-9zyBY041AXvYL4K+FUUQ5gzA@mail.gmail.com>
In-Reply-To: <CAL41Mv4nqEWkFZajL-Z3ny_gx-9zyBY041AXvYL4K+FUUQ5gzA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 30 Sep 2026 02:23:09 +0000
X-Gm-Features: AclHuK959LWtb1m_P2LehkKgue8YG78_Wups34zqyQysIiDzelee7Jt6Cpd8fgY
Message-ID: <CAJuCfpGEBZce3_QzA_Zbqs-YtT5zG2tQdkrufo-qDyRc4fuG9w@mail.gmail.com>
Subject: Re: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: f95k1sefqr5zn96e81hotrgfu45r4z8j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70B5740004
X-HE-Tag: 1790735003-591902
X-HE-Meta: U2FsdGVkX1+deMIik/p47PEEGmbTQtiQztbem3CkkqSIpghPth7YnJ5QS03spyNd0N9LhMmmRD37b0m/5sAA/VJSIgoHghol5WhTAPQqBYCVnLMg9Z2vmBmkcUC1ZzNSHYBmCJGFKh6X/+yuN+x0G8J53CLNxeklUDuvpXBhKCHoQNp4WAsoeoVVmeJWFewgRG+2PTK4y2TzRuOr9KH9xAUuzAk75dkXcinGihmNMEJXkxUTZeqLUz+6OUKMrvhrm84xGuJiGkZvqCE2SmrxfI4VSgOwgdTMiMZeoGq2mS8g0A4FIZySGnOcY5ET3KgMfV/AwQhINnnuculQ3Jv265JwY05BkwxbhBS9zwzttARVEbWtMlIIOYrIwz1NDfWVCcBq1BL62R/OmyCVyf5LwhmVUQi94+fMwl5fOSyIBrLU2/2FRvM/szaQ9W3+XXmDOluw6TdZJu6KPuwilElckYgm6fniPX0BHdGxRGhHyyIpgl175B9KwzaPMlLWEFY6apVOpdotEw7tL9c0sEKnlJescV7lwhz2q+AgN42gyKIAEIshzQpEuZ2Fxo2Vw1WfjC+2g4I0lctv4rFkNocqFBiGRJ0Bjb1FF14uu6cdBSTNjOAwOKYxdwEMn7wvDwofh8kjaigRNMp2wHsoQTbcTbFTA7xgTLkaiR8rIxq0XQB0jIiIn4k9/Txym9rfnAa1gvVete4mnp0OiFo2zzgy9BjjSSnWc5eGDyB+VcMjm33MOmkyXhttrE4W92r9661xPY1A1UFWra1YxFh7URwOEmcnANu4ivjSFm2BP2aYaYdSUQgRwss/NlH5k7jNDQ7fExa47N+zRmsTbZsaDCAGQ6y6FWIlORi81GlGviiyo5zz/UU81xDF0eY8rTThMA7cGTpYnNJC/YyjTahVbVh90boY0GGQow6TSYsKVM0nap403HNy80wc1Jx+CcBdwc4mjc9MqpuAJAcYqpyIPyk
 LhlIIPS0
 Pv52hkDWlKmo06mEf7WZkM5jdq2k9lRobtnL72xY1vOXt/7bmefFn0DrJ0KPNkZqBCYVR1DtDAV3FwgRB8VFfSyaxV5G8LlwSf/Egevyz1D1+PjfzutsEZZNJZBs27PNK62gdmxYU0YhZyERg67AGWmpcCg5qRCtljDx6ljOSusKyhddPBO3IYPv2vrBRVkTNW/8bYZzs3JZYg8Yob9g/DVD3xr2q80SfUfUDJnXCNORQlC+v5riCjHEPHjyPcIzr1ZL8EDdr+rje1NdQsgQAi0TRfy7SSALLcWS/g6NFK3R9C0+oICjO5L3eEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 5:32=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Sun, Sep 27, 2026 at 7:10=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Suren
> >
> > On 2026/9/25 14:14, Suren Baghdasaryan wrote:
> > > On Thu, Sep 24, 2026 at 12:21=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wr=
ote:
> > >>
> > >> Hi Abhishek
> > >>
> > >> Sorry, I merged and tested your patches today and found a few detail=
s,
> > >> so I've started a separate mail thread for this review.
> > >>
> > >> On 2026/9/22 05:26, Abhishek Bapat wrote:
> > >>> The memory allocation profiling framework intercepts allocations ac=
ross
> > >>> the core subsystems, but currently lacks runtime tracing hooks for
> > >>> standard observability tools to dynamically track the context (stac=
k
> > >>> traces and lifecycles of the individual memory chunks) of the
> > >>> allocations made.
> > >>>
> > >>> Introduce three standard trace events to allow this tracking:
> > >>>
> > >>> 1. `alloc_tag_hit`: Fired at the exact call site. This allows users=
pace
> > >>>    tools to trigger and capture a call stack.
> > >>> 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
> > >>>    allocation. It records the allocated size, the tag, and the uniq=
uely
> > >>>    generated codetag_ref metadata pointer.
> > >>> 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memor=
y is
> > >>>    freed, yielding the same codetag_ref to allow tracing tools to f=
ind
> > >>>    the corresponding allocation.
> > >>>
> > >>> Because the introduced trace events occur at different stages in th=
e
> > >>> call stack, userspace tracing tools must stitch them together to fo=
rm a
> > >>> complete picture of a buffer's lifetime. Here's an example of how
> > >>> userspace correlates these three events:
> > >>>
> > >>> 1. On `alloc_tag_hit`: The tool captures the stack trace and caches=
 it,
> > >>>    keyed by the combination of the current thread's PID and the `ta=
g`.
> > >>> 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` =
from
> > >>>    the event and looks up the stack trace cached in step 1. It crea=
tes a
> > >>>    new active allocation record, mapping the new provided `codetag_=
ref`
> > >>>    to this cached stack trace and the newly returned allocation siz=
e.
> > >>> 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yi=
elds
> > >>>    the same `codetag_ref`. The tool uses this reference to look up =
the
> > >>>    original allocation record, correlates the free, and safely reti=
res
> > >>>    the tracking entry.
> > >>>
> > >>> Also, introduce `alloc_tag_trace_key` static key to minimize the
> > >>> overhead when no tags are being traced (the usual case). Once traci=
ng
> > >>> for any tag is requested, the key is set, opening the path to check
> > >>> whether tracing is enabled for the current tag.
> > >>> Nore that the mechanism to enabl tag tracing is implemented in the =
next
> > >>> patch, therefore for now, `alloc_tag_trace_key` stays always unset.
> > >>>
> > >>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > >>> ---
> > >>>  MAINTAINERS                      |   1 +
> > >>>  include/linux/alloc_tag.h        |  57 ++++++++++++---
> > >>>  include/trace/events/alloc_tag.h | 122 +++++++++++++++++++++++++++=
++++
> > >>>  mm/alloc_tag.c                   |  28 +++++++
> > >>>  4 files changed, 196 insertions(+), 12 deletions(-)
> > >>>  create mode 100644 include/trace/events/alloc_tag.h
> > >>>
> > >>> diff --git a/MAINTAINERS b/MAINTAINERS
> > >>> index 24420a8c06d0..29e1f7915cb9 100644
> > >>> --- a/MAINTAINERS
> > >>> +++ b/MAINTAINERS
> > >>> @@ -17096,6 +17096,7 @@ S:    Maintained
> > >>>  F:   Documentation/mm/allocation-profiling.rst
> > >>>  F:   include/linux/alloc_tag.h
> > >>>  F:   include/linux/pgalloc_tag.h
> > >>> +F:   include/trace/events/alloc_tag.h
> > >>>  F:   include/uapi/linux/alloc_tag.h
> > >>>  F:   mm/alloc_tag.c
> > >>>  F:   tools/testing/selftests/alloc_tag/
> > >>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > >>> index 7f2d80a59792..2994934cf44a 100644
> > >>> --- a/include/linux/alloc_tag.h
> > >>> +++ b/include/linux/alloc_tag.h
> > >>> @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _s=
hared_alloc_tag);
> > >>>  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEF=
AULT,
> > >>>                       mem_alloc_profiling_key);
> > >>>
> > >>> +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > >>> +
> > >>>  static inline bool mem_alloc_profiling_enabled(void)
> > >>>  {
> > >>>       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED=
_BY_DEFAULT,
> > >>>                                  &mem_alloc_profiling_key);
> > >>>  }
> > >>>
> > >>> +static inline bool alloc_tag_trace_enabled(const struct alloc_tag =
*tag)
> > >>> +{
> > >>> +     return static_branch_unlikely(&alloc_tag_trace_key);
> > >>> +}
> > >>> +
> > >>> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct allo=
c_tag *tag,
> > >>> +                           size_t bytes);
> > >>> +
> > >>> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc=
_tag *tag,
> > >>> +                          size_t bytes);
> > >>> +
> > >>> +void __alloc_tag_trace_hit(struct alloc_tag *tag);
> > >>> +
> > >>> +static inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> > >>> +{
> > >>> +     if (alloc_tag_trace_enabled(tag))
> > >>> +             __alloc_tag_trace_hit(tag);
> > >>> +}
> > >>> +
> > >>>  bool mem_alloc_profiling_permanently_disabled(void);
> > >>>
> > >>>  static inline struct alloc_tag_counters alloc_tag_read(struct allo=
c_tag *tag)
> > >>> @@ -200,8 +221,13 @@ static inline bool alloc_tag_ref_set(union cod=
etag_ref *ref, struct alloc_tag *t
> > >>>
> > >>>  static inline void alloc_tag_add(union codetag_ref *ref, struct al=
loc_tag *tag, size_t bytes)
> > >>>  {
> > >>> -     if (likely(alloc_tag_ref_set(ref, tag)))
> > >>> +     if (likely(alloc_tag_ref_set(ref, tag))) {
> > >>>               this_cpu_add(tag->counters->bytes, bytes);
> > >>> +
> > >>> +             if (alloc_tag_trace_enabled(tag))
> > >>> +                     /* Trace successful allocs with their unique =
ref */
> > >>> +                     alloc_tag_trace_mem_alloc(ref, tag, bytes);
> > >>> +     }
> > >>>  }
> > >>>
> > >>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t by=
tes)
> > >>> @@ -222,6 +248,10 @@ static inline void alloc_tag_sub(union codetag=
_ref *ref, size_t bytes)
> > >>>       this_cpu_sub(tag->counters->bytes, bytes);
> > >>>       this_cpu_dec(tag->counters->calls);
> > >>>
> > >>> +     if (alloc_tag_trace_enabled(tag))
> > >>> +             /* Trace frees with their unique ref */
> > >>> +             alloc_tag_trace_mem_free(ref, tag, bytes);
> > >>> +
> > >>>       ref->ct =3D NULL;
> > >>>  }
> > >>>
> > >>> @@ -247,21 +277,24 @@ static inline void alloc_tag_add(union codeta=
g_ref *ref, struct alloc_tag *tag,
> > >>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t by=
tes) {}
> > >>>  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)=
 {}
> > >>>  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) =
{ return false; }
> > >>> +#define alloc_tag_trace_hit(_tag)    /* NOOP */
> > >>
> > >> I'd prefer we use `do {} while (0)` here, following the same pattern
> > >> as alloc_tag_record.
> > >>
> > >>>  #define alloc_tag_record(p)  do {} while (0)
> > >>>
> > >>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> > >>>
> > >>> -#define alloc_hooks_tag(_tag, _do_alloc)                          =
   \
> > >>> -({                                                                =
   \
> > >>> -     typeof(_do_alloc) _res;                                      =
   \
> > >>> -     if (mem_alloc_profiling_enabled()) {                         =
   \
> > >>> -             struct alloc_tag * __maybe_unused _old;              =
   \
> > >>> -             _old =3D alloc_tag_save(_tag);                       =
     \
> > >>> -             _res =3D _do_alloc;                                  =
     \
> > >>> -             alloc_tag_restore(_tag, _old);                       =
   \
> > >>> -     } else                                                       =
   \
> > >>> -             _res =3D _do_alloc;                                  =
     \
> > >>> -     _res;                                                        =
   \
> > >>> +#define alloc_hooks_tag(_tag, _do_alloc)                          =
           \
> > >>> +({                                                                =
           \
> > >>> +     typeof(_do_alloc) _res;                                      =
           \
> > >>> +     if (mem_alloc_profiling_enabled()) {                         =
           \
> > >>> +             struct alloc_tag * __maybe_unused _old;              =
           \
> > >>> +             /* Fired here to cleanly capture the caller's stack t=
race */    \
> > >>> +             alloc_tag_trace_hit(_tag);                           =
           \
> > >>> +             _old =3D alloc_tag_save(_tag);                       =
             \
> > >>> +             _res =3D _do_alloc;                                  =
             \
> > >>> +             alloc_tag_restore(_tag, _old);                       =
           \
> > >>> +     } else                                                       =
           \
> > >>> +             _res =3D _do_alloc;                                  =
             \
> > >>> +     _res;                                                        =
           \
> > >>>  })
> > >>>
> > >>>  #define alloc_hooks(_do_alloc)                                    =
           \
> > >>> diff --git a/include/trace/events/alloc_tag.h b/include/trace/event=
s/alloc_tag.h
> > >>> new file mode 100644
> > >>> index 000000000000..af2182501864
> > >>> --- /dev/null
> > >>> +++ b/include/trace/events/alloc_tag.h
> > >>> @@ -0,0 +1,122 @@
> > >>> +/* SPDX-License-Identifier: GPL-2.0 */
> > >>> +#undef TRACE_SYSTEM
> > >>> +#define TRACE_SYSTEM alloc_tag
> > >>> +
> > >>> +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_REA=
D)
> > >>> +#define _TRACE_ALLOC_TAG_H
> > >>> +
> > >>> +#include <linux/tracepoint.h>
> > >>> +
> > >>> +/*
> > >>> + * alloc_tag_hit is generated at the exact allocation call site an=
d can be
> > >>> + * used to capture a clean stack trace.
> > >>> + *
> > >>> + * To link this stack trace to the actual allocated memory chunk, =
tools must
> > >>> + * correlate this event with the resulting alloc_tag_mem_alloced e=
vent. Since
> > >>> + * multiple threads can hit the same tag simultaneously, tools mus=
t match BOTH
> > >>> + * the `tag` field and the implicitly recorded PID provided by the=
 core
> > >>> + * tracing subsystem.
> > >>> + */
> > >>> +TRACE_EVENT(alloc_tag_hit,
> > >>> +
> > >>> +     TP_PROTO(struct alloc_tag *tag),
> > >>> +
> > >>> +     TP_ARGS(tag),
> > >>> +
> > >>> +     TP_STRUCT__entry(
> > >>> +             __field(struct alloc_tag *, tag)
> > >>> +             __string(modname, tag->ct.modname ? tag->ct.modname :=
 "NONE")
> > >>> +             __string(filename, tag->ct.filename)
> > >>> +             __string(function, tag->ct.function)
> > >>> +             __field(unsigned int, lineno)
> > >>> +     ),
> > >>> +
> > >>> +     TP_fast_assign(
> > >>> +             __entry->tag =3D tag;
> > >>> +             __assign_str(modname);
> > >>> +             __assign_str(filename);
> > >>> +             __assign_str(function);
> > >>> +             __entry->lineno =3D tag->ct.lineno;
> > >>> +     ),
> > >>> +
> > >>> +     TP_printk("tag %p, module: %s, filename: %s, function %s, lin=
eno %u",
> > >>> +             __entry->tag,
> > >>> +             __get_str(modname),
> > >>> +             __get_str(filename),
> > >>> +             __get_str(function),
> > >>> +             __entry->lineno
> > >>> +     )
> > >>> +);
> > >>>
> > >>
> > >> When I trace an interface provided by a kernel build-in such as shme=
m,
> > >> this is what I see in the trace:
> > >>
> > >> trig-6838    [004] .....  1309.321906: alloc_tag_hit: tag 0000000078=
74a2c9, module: NONE, filename: mm/shmem.c, function shmem_alloc_folio, lin=
eno 2138
> > >>
> > >> The module field shows NONE, which looks a bit odd.
> > >>
> > >>> +/*
> > >>> + * alloc_tag_mem_alloced is generated after memory is successfully=
 allocated.
> > >>> + * It captures the exact byte size.
> > >>> + *
> > >>> + * The `ref` pointer identifies the memory chunk for tracking its =
lifecycle
> > >>> + * (e.g., matching it with alloc_tag_mem_freed).
> > >>> + *
> > >>> + * Because the kernel isolates active allocations within the task =
struct
> > >>> + * (current->alloc_tag), this even will always share the same impl=
icit PID as
> > >>> + * its corresponding alloc_tag_hit event. Tools should use the com=
bination
> > >>> + * PID + `tag` to correlate them.
> > >>> + */
> > >>> +TRACE_EVENT(alloc_tag_mem_alloced,
> > >>> +
> > >>> +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_=
t bytes),
> > >>> +
> > >>> +     TP_ARGS(ref, tag, bytes),
> > >>> +
> > >>> +     TP_STRUCT__entry(
> > >>> +             __field(union codetag_ref *, ref)
> > >>> +             __field(struct alloc_tag *, tag)
> > >>> +             __field(size_t, bytes)
> > >>> +     ),
> > >>> +
> > >>> +     TP_fast_assign(
> > >>> +             __entry->ref =3D ref;
> > >>> +             __entry->tag =3D tag;
> > >>> +             __entry->bytes =3D bytes;
> > >>> +     ),
> > >>> +
> > >>> +     TP_printk("reference %p, tag %p, bytes %zu",
> > >>> +             __entry->ref,
> > >>> +             __entry->tag,
> > >>> +             __entry->bytes
> > >>> +     )
> > >>> +);
> > >>> +
> > >>> +/*
> > >>> + * alloc_tag_mem_freed event is generated immediately before memor=
y is
> > >>> + * freed. The `ref` pointer matches the one emitted during allocat=
ion,
> > >>> + * allowing tools to match it to it's corresponding allocation and
> > >>> + * call stack.
> > >>> + */
> > >>
> > >> But the thread for allocation and free may not be the same.
> > >> For example, memory allocated in thread A could be freed by kswapd.
> > >> In this case, would the ref fail to match and falsely report a memor=
y leak?
> > >
> > > No, ref is unique within the system, so even if alloc and free happen
> > > in different threads it still can be used to match them. The
> > > thread+tag is used only when matching alloc_tag_hit with
> > > alloc_tag_mem_alloced because at the time of alloc_tag_hit we don't
> > > yet have the ref.
> > >
> >
> > "The ref is unique within the system" is true of the obj_ext/page_ext s=
lot,
> > but for page allocations the event does not carry the slot's address,
> > it carries the address of a stack temporary.
> >
> > /* Should be called only if mem_alloc_profiling_enabled() */
> > static noinline
> > void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> >                        unsigned int nr, unsigned int alloc_flags)
> > {
> >         union pgtag_ref_handle handle;
> >         union codetag_ref ref;  <- stack temporary
> >
> >         if (likely(get_page_tag_ref(page, &ref, &handle))) {
> >                 alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> >                 update_page_tag_ref(handle, &ref);
> >                 put_page_tag_ref(handle);
> >         } else {
> >                 ......
> >         }
> > }
> >
> > /* Should be called only if mem_alloc_profiling_enabled() */
> > static noinline
> > void __pgalloc_tag_sub(struct page *page, unsigned int nr)
> > {
> >         union pgtag_ref_handle handle;
> >         union codetag_ref ref; <- stack temporary
> >
> >         if (get_page_tag_ref(page, &ref, &handle)) {
> >                 alloc_tag_sub(&ref, PAGE_SIZE * nr);
> >                 update_page_tag_ref(handle, &ref);
> >                 put_page_tag_ref(handle);
> >         }
> > }
> >
> > Or am I missing / confusing something here?
> >
>
> This is a legitimate concern, I went through the code again, the
> codetag_ref pointer approach works for percpu and slab allocators but
> don't work for the page allocator.

Ugh! You are absolutely correct. I'm still thinking in terms of
pre-alloctag compression, before we started storing codetag references
in the page flags.

>
> Suren, Hao, I could potentially pass in the struct page * to
> __alloc_tag_add and __alloc_tag_sub from the page allocator and keep
> the codepath for the percpu and slab allocators the same. What do you
> think? I think that should solve this concern.

Yes, that should solve this ambiguity and I think it would be the
simplest approach here.

>
> > Thanks
> > Best Regards
> > Hao
> >
> > >>
> > >> Thanks
> > >> Best Regards
> > >> Hao
> > >>
> > >>> +TRACE_EVENT(alloc_tag_mem_freed,
> > >>> +
> > >>> +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_=
t bytes),
> > >>> +
> > >>> +     TP_ARGS(ref, tag, bytes),
> > >>> +
> > >>> +     TP_STRUCT__entry(
> > >>> +             __field(union codetag_ref *, ref)
> > >>> +             __field(struct alloc_tag *, tag)
> > >>> +             __field(size_t, bytes)
> > >>> +     ),
> > >>> +
> > >>> +     TP_fast_assign(
> > >>> +             __entry->ref =3D ref;
> > >>> +             __entry->tag =3D tag;
> > >>> +             __entry->bytes =3D bytes;
> > >>> +     ),
> > >>> +
> > >>> +     TP_printk("reference %p, tag %p, bytes %zu",
> > >>> +             __entry->ref,
> > >>> +             __entry->tag,
> > >>> +             __entry->bytes
> > >>> +     )
> > >>> +);
> > >>> +
> > >>> +#endif /* _TRACE_ALLOC_TAG_H */
> > >>> +
> > >>> +/* This part must be outside protection */
> > >>> +#include <trace/define_trace.h>
> > >>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > >>> index f30ef8dd24c7..a5339767efd5 100644
> > >>> --- a/mm/alloc_tag.c
> > >>> +++ b/mm/alloc_tag.c
> > >>> @@ -19,6 +19,9 @@
> > >>>  #include <linux/kmemleak.h>
> > >>>  #include <uapi/linux/alloc_tag.h>
> > >>>
> > >>> +#define CREATE_TRACE_POINTS
> > >>> +#include <trace/events/alloc_tag.h>
> > >>> +
> > >>>  #include "internal.h"
> > >>>  #include "page_alloc.h"
> > >>>
> > >>> @@ -55,6 +58,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
> > >>>
> > >>>  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> > >>>
> > >>> +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > >>> +EXPORT_SYMBOL(alloc_tag_trace_key);
> > >>> +
> > >>>  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> > >>>  unsigned long alloc_tag_ref_mask;
> > >>>  int alloc_tag_ref_offs;
> > >>> @@ -485,6 +491,28 @@ static const struct proc_ops allocinfo_proc_op=
s =3D {
> > >>>  #endif
> > >>>  };
> > >>>
> > >>> +void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > >>> +{
> > >>> +     if (unlikely(!tag))
> > >>> +             return;
> > >>> +     trace_alloc_tag_hit(tag);
> > >>> +}
> > >>> +EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > >>> +
> > >>> +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct allo=
c_tag *tag,
> > >>> +                           size_t bytes)
> > >>> +{
> > >>> +     trace_alloc_tag_mem_alloced(ref, tag, bytes);
> > >>> +}
> > >>> +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
> > >>> +
> > >>> +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc=
_tag *tag,
> > >>> +                          size_t bytes)
> > >>> +{
> > >>> +     trace_alloc_tag_mem_freed(ref, tag, bytes);
> > >>> +}
> > >>> +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
> > >>> +
> > >>>  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t coun=
t, bool can_sleep)
> > >>>  {
> > >>>       struct codetag_iterator iter;

