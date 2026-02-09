Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E8CE7E0D9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B231E6B0088; Mon,  9 Feb 2026 13:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDDE6B008A; Mon,  9 Feb 2026 13:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0116B008C; Mon,  9 Feb 2026 13:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894B16B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:45:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39F611B2B7B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:45:13 +0000 (UTC)
X-FDA: 84425795706.22.0833D45
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22CA9120002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:45:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czUeHAOW;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770662711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqMmVYyUYpGstje1wz4BDAufr1v680Vkae44YBH6/xk=;
	b=FXamE1EawQO4AL+JMYAc0GW7u2FMwoq7w4thPs2z2h8hiNk/Up4QsMnDLVS+mNDPuT6o9A
	bbjWARKTbol2gr9M/urA9jBUSt3wgjLJqaApt+ZX8SxKlC3q4inkk46lp7hDrXMXfF5u0P
	1vhdf3l5tQtxYZFQSQPcvXaYr4tQiys=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czUeHAOW;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770662711; a=rsa-sha256;
	cv=pass;
	b=vQmBcxB5XVCATEeRXG3sX03jgfrhtzeNEIK4Glpgfnsap1WPGJsqowGxv/b44j69vaNSsn
	QXF/SxFClh1hqMTcsbXgXlkJMyEVxYBuqtPvtbulb/bstyzVFfg23sfEb+RiN9PvPYb/w8
	I6aC0CT5giXfqiPl9125q0gIvw8l7xY=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-435a11957f6so3695389f8f.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 10:45:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770662709; cv=none;
        d=google.com; s=arc-20240605;
        b=Zjf1ZhS2isxms/Ye6Mu5BZQxyQoMzyqDTqe5eexd6Pg0106E+O/KdUd9J1oLNEcIz1
         jGwESjaMT1kBhA0GxvGV75sd/b2qTjz2WT5pgXAWtyL0QYeowGSSyu3Xi2n29AvjO3O6
         o9tFdhb8aeupCb3zk3aspaodfi1aqEFRwpdZRnjb1M7EJp1skpHpcVMI7DyGpfBkkqBV
         7bb2iQ3KHiPItfN1SiztwMMHqgppDz6UbAEnRvzMPoGOPmjE/1uLsCY6RuHq5cDPdOZQ
         Lx7L2W2B3xzKHaO3jaoVYwUwDp8jwGakpHzOmiF0R6OGghiDWlHvjLnv1AfkzBVydpEG
         wlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sqMmVYyUYpGstje1wz4BDAufr1v680Vkae44YBH6/xk=;
        fh=s3hx5jDdZztLfMHtOIntrA9zwIkFVSj/yXruBE3FgF8=;
        b=eknql64F/reT9Y6Gph396eg7hIMBy/dL80e1P4NCKIRGZxFfpws44ITfGKBnXAw85Q
         a4gg8Un5qL864RtlugPSV3LrGdBFuJWlrb6n8aBdeBg02WppqumZK4sg/P4XEiJXpsKx
         3z20AxoUGDFt4r1ibhvGIauwH2CDst9MMFs2lMWd+UXp+QdBHflXi0BKbr3CKjfGnu8g
         RkZ7W/sS7kspcyw6TT58gl2AKP2UR40up3nk0eY6YigFJ0toJn2FfaZxEAauYOmot40c
         WC2SzvuShr9+lQx3Vu2Yvmv3DR7Uw0pkTHIxzdfxsnO0saLI7RSgdajjSyWkh5BpzivF
         Q00w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770662709; x=1771267509; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqMmVYyUYpGstje1wz4BDAufr1v680Vkae44YBH6/xk=;
        b=czUeHAOWvGWFXNawnJT+fxMwHwKSA/plbYWUI5UXe5osBQ2deZAOBquHfx9oDsjm3x
         PUqDy8Cms52TW8bdcvBiqCEb6BFgMFCBHB7wjwkOIGe0dWHUeCezKugymrwWDx+pA88C
         NbXLXFIyYqjTmJPYt29sTp6t5n8bf/1WaahwU9kbwokBuVm6bceDXjac7XOfUA459JwJ
         v+4qom8ZlXj/H/cJy4BuEwgzrJ8zViRt/xBalSMkERjQpjM/P9Py4NPeWt+ZgPRs8eci
         T5zuMfCJVAjFwGrvjXWaCy7z6YcvZo0yLA6c4gUR4Z5mt1hyQCVKCiYIQYQUp+fiPh7p
         gv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770662709; x=1771267509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sqMmVYyUYpGstje1wz4BDAufr1v680Vkae44YBH6/xk=;
        b=YP7ltyIs8bWLPQGd8Ne/BLKxWE0C2VgIiRPJI5MXQKt2ETDr+34ILupNgw8Akrtvp1
         FP1sQhy9uqYPiNIElUa0NAedgryjBoht8kpamVVf4bfHTOTZkhY6FkuNxJiUwcx/w7yp
         6ioVmlyEfYW4cehvMIBhm2mKT0n7/YAalziiZ7jquAnYkyjdwvLwx++9NKEzEvYyBuqd
         hi+xxY8HP8YiyCGuhJ0MTsqiMCFNPOhdcCHBwJNSnMEwed+eAWcbQ8UvDFJRIpxjAgWP
         Kpqk4I3grlgyl4NvLg9Ldn684hp/UFsMH5+UUQSZ6VtfE6qOSl+sPyciafvC4EqKmT/l
         7L7A==
X-Forwarded-Encrypted: i=1; AJvYcCUPxTVLvLud1uWx43rKzmbvMx4QGGQ5fo/7IHEwU5q9A1CnOxnDJy6zMmTOIHpyS7ugjy/vFwtZuw==@kvack.org
X-Gm-Message-State: AOJu0YwawCuZxzFyR/gYtJzcsb7fWtHEiMV8KmBZ/5olPfVWubLA7xjl
	8dOF6XFmD/UWoJrk5VnT9Ct4JUYLDbiZ6GNKNRZSspq7bTKr/hSo7dt4rbegueLr03UgHGZaWJG
	2uKeUjS8oPajKuWoOxxIsxQKDpbvEjbM=
X-Gm-Gg: AZuq6aL55JGigROfftOdHtvnMxMEMVMonclZLyx5uwox/sW9qzxX7w7V9p0NCFkoa5u
	yi4MbOw5vTu/L8IT3HeNS78fOuGpGezQ91LDjpOXR76bEY3Qa2P02fs58IREcv8aFIx27qzJmtQ
	8eNHe2DGeLyML7vyhZjKYyzOKxRfRlxgvsl0TStmMYAwPZJY3i7BJEkH4qtibcEFB4D592ahjv2
	syZdGLXYMZg10LYLl+XKRuBta9UV4gJvd4hJZzJEglx8dyyNBlhaf0MjV9TFEWmG36kcQ55A1Fw
	xdJz4GVUOZVuLIv8wCSwlLQqHqlH/XswBbwVRK5x8mLL1ozlQA4iuiKOIA1PNkutlYbdZEyt55h
	BopZ7OdcN91dauQ==
X-Received: by 2002:a05:6000:2285:b0:435:a0ca:bdce with SMTP id
 ffacd0b85a97d-436293b6d91mr19720428f8f.63.1770662709254; Mon, 09 Feb 2026
 10:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20260206093410.160622-1-harry.yoo@oracle.com> <20260206093410.160622-5-harry.yoo@oracle.com>
 <CAADnVQ+rNYeb5Pu2aHRVc+hYDeAF5t19MVwzXsyn2HkOuLPNLg@mail.gmail.com> <ebc2eb77-722d-4966-8376-f11607de53c2@suse.cz>
In-Reply-To: <ebc2eb77-722d-4966-8376-f11607de53c2@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 9 Feb 2026 10:44:57 -0800
X-Gm-Features: AZwV_QhH5LLE8iIvDB7Twan7nOo9YGILnwQ7hrloMARMGnUSRQtlNRKOCRmQfK8
Message-ID: <CAADnVQ+q3QPqNdV3MuysQJQgxSS4g6CV+VzN2=UqCPHw7xq=SQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] mm/slab: free a bit in enum objexts_flags
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 22CA9120002
X-Rspamd-Server: rspam07
X-Stat-Signature: i878aqzx1pdn93itfuef37ebzfchny4t
X-HE-Tag: 1770662710-829659
X-HE-Meta: U2FsdGVkX1+cBp1LCn+vIeEIYR06IoBBKuJTZ39bnnCp5PhmpbeZctGLCtp+mAoQZq0SJ39TmyuB0a5Dhz/+HIwy5N8ByJepJIfoKaxBFf+wio6JbdunQ3r9DmfyYcn1P92YWTpIPZrbsnS7moNx4qaK26MzXpg+lCW37woTBBO+894+YpUfvw8Y4eF87jKKvHp/RdLROk2E1B0lE6+jPmd5fKcvXORRAcHCKCz7bJvNlgxBV5WZ07p+saMtCX04N7H2HxgKF+Kf3oZwO4/7Aw5Ru1pwLX6X/ydRu5jvKU1s5XjrkzK+ZFuQ4u/BIBvuKndH/XXKWhN3jI4wOR+/S+0QAFGYWw75JU84i3EFM/rrhIBFTohIr+iDW+quyrNvqUrrVhptXDIx60Hm/eLmSEKKWwVPdiiJUnB+E2/+FvB6XyZYFnDR5tCfmoLMOlEUD9+xQmuKwrdjSa6v+6kVhKZ03TsPoYxg3tQsYRZjS3t1PMQ6BYyF98znP1crzV6KWi8rhVqsoPbIQwqqjzGO9uxTVxjFkVmKPmx9fhWdTi3Qciq7Nni5F35dkPiwBWhC5+WPPx/ofQ3XEuLVUWfbirFFQ/PUIqVCAYTKyS3WIKsFK8xIrVBPNk2IZDC4O9/CoqrWvOYbhKTw5+u+bhOC6YNM0UsY5ljdPCBs6knAnRHY4kanzgbU/MAUn120N8h+G68Vglq1EwBcaYdvyFRWDo7HAQDl64V8+yj+h3JjsHO3xoScwFSb7IhqrwQkQYGt2WpDm13vFYZkKwPi/eKDpVKIj4q2j/4Fj+kREUum5A03ChFpD7db9fqYl59U+FaOdl2aSef2YnDZZJh4QkjEGlXeEaqBDrTJcqVC6VEGA2RRnPrSTWgNJliBVtuU8kI8QouhGdOgcX5VoJj9z27HKNde/c3dh//m7Vp7QMsXB0oWcGD+0qefxCF4usmzYKWpBgUFPUzanX3MdS1rCur
 JGGJDkWf
 OfuLN0pT5ERqi2Hr9DuORyCePezY8yx1DMVC2JJvA2E1vb6E+YPuPCu/UT4diPyTe0CsXGQ74kiJ1pzZvXOiuvn6U0XzH+V14eNJDjwyvS+XxGrpCSnjBOJuUdOc7Y6XzIDqWuIcBPdoSLZjCstJJ5ko24A0L+/QhPQH1I1bpaDaUpJRjc4aOPsjoidYDIDXNlmGTkn0z/EiukUIOo/BQT1zLtyWY4YbJ/zrjGC16w59h7Q4dqxfJjvd3GjFEFqrfFASN5ps9HIKakTzgSRT5JvpWBqh2Y9jMh943uXWC4esFRmmkG9b2iD6QzZo7e2raG7041tjTTDqhJvKMJzRASEIRe8xymUOIhWZOqizGkrApNpJ18HAZbz08Vz1ZOz2tqcg4EJsdDuXLYfeb/3BvSiP8hOOO98uVLcvIuCtNCzS0tI1n42+t3BB9V5gtglmXLu9IIrpkPRGPaVGFo02SR9YEiFvrhGwXKHf3vYPsRsKmlCUeotnGRMq4N+O6sURqJxbdwy7pehGOU+WD4UzQj/MDNjlY0UwWX4ezbDwNjwe6VPNRhvjt2SkGMohqSC/h08Cb5XHIEB3gZVOl9VvEGk4Dc7l9OB/wd7UHiDqdOYnL0cE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 1:38=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 2/6/26 21:09, Alexei Starovoitov wrote:
> > On Fri, Feb 6, 2026 at 1:35=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com>=
 wrote:
> >>
> >> Since kfree() now supports freeing objects allocated with
> >> kmalloc_nolock(), free one bit in enum object_flags.
> >>
> >> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> >
> > For patches 3 and 4:
> >
> > Acked-by: Alexei Starovoitov <ast@kernel.org>
> >
> > I think patches 3 and 4 are ready.
> > Would be great to land them for this merge window
> > (if Vlastimil agrees).
>
> We should have an ack from Catalin for kmemleak. Also better take them ou=
t
> of the RFC and send as 2 non-rfc patches first, with cc list reduced
> accordingly etc.
>
> Then I can put them to -next and try sending second merge window PR next
> week. Can you also point to any bug reports that would be fixed? (that yo=
u
> had to work around or delay merging or something) that would help the
> argument to not wait a cycle.

Here is one example:
https://lore.kernel.org/all/20251114201329.3275875-1-ameryhung@gmail.com/

"
RFC v1 tried to switch to kmalloc_nolock() unconditionally. However,
as there is substantial performance loss in socket local storage due to
1) defer_free() in kfree_nolock() and 2) no kfree_rcu() batching,
replacing kzalloc() is postponed until necessary improvements in mm
land.
"

This patch addresses both 1 and 2. The freeing is done in a good context.
The only reason we use kfree_nolock() and suffer from defer_free and
lack of batching is due to kmalloc_nolock()->kfree_nolock() matching
requirement. So this small patch is a big deal.
We will be able to use kmalloc_nolock() -> kfree_rcu().

