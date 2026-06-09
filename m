Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90B7CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7B06B0005; Tue,  9 Jun 2026 11:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF706B008A; Tue,  9 Jun 2026 11:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5916B008C; Tue,  9 Jun 2026 11:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3506B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:41:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB2CC1C1FEA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:41:52 +0000 (UTC)
X-FDA: 84860789664.13.3E84BDE
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id F33A5140019
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:41:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fcec81yQ;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781019711;
	b=S58eJErIiDX/PVSMKdmn4GK9nYeB+MinB+TOY1YnZKct5klZjUCfxskocKvMNB0d/m78Zc
	mzKBh6yxmSzqyHfvVWgU4heA70bAeP+O/kMq5ExFZFOKItulzIvNQWLQ26Iwy56dhCNOOY
	tV2S+k2lvyxTyyORSmRj1bKvq1B6ZU4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fcec81yQ;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRDpcACJAnf6MqVZ/0ti617MR+GTIe/DUWU9NUIc714=;
	b=8YIJGcZkfuXN+WBt8DGGVvjePK5UqHE5M57w4yDDl82rDVCxwbhjez7Jff9tjlCZ0wAhOL
	q02yX+PJbFWA1PJtFBPVMdxaii7tV6R7Kz+NRM+BNlTRv1r0Y3LJZve8ML4uz9I7gS/py2
	x58PwoujtKsvFMNIPwQGolfzhXSe/D4=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-6cfd9f4d6f5so2202450137.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781019710; x=1781624510; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRDpcACJAnf6MqVZ/0ti617MR+GTIe/DUWU9NUIc714=;
        b=fcec81yQmt8aZLWQworyjtRaUpv6ostRidsEYXoNt5El38fBlXxPf62jjBuRii29s4
         dg1Q1dLdiqLLQB+A8o6kNd+naZ7RihIXE/uahOqqWT6DUy0mF4pfhuIXRUqqIIIOYsho
         gKWrWLi7atwiVqJfDDCoT2UajGHqLfHaCp54fEbaJvziwPdbcio4CL46OwDscsoIo9fc
         JUow5Yn/0GIiHRZSb6o3VBEeJos2R2d2Jnz8wnhR2F8/FCWl3Pc1gG/F4LJvf7MrJeTK
         ExyBjoaypJIvkV9FkOI1Iin9LLEh5Zww3Zxq2iJkpJPfLTVflVwIYk/wz+NbbrSDWl2u
         B6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019710; x=1781624510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRDpcACJAnf6MqVZ/0ti617MR+GTIe/DUWU9NUIc714=;
        b=D72Bdf22PLRU7m664/nUEwRhDPFMqxjlpdjgzDDHPPN3EY0gfrHjpJEgsTnsFwBKRs
         S7dWkJcYtWqPY2yXsa2gYaP8Dh9hnTVWS6YjBCMF+eMA/aPIHSS0tjs2rWvT0tRa8liT
         xMvTcNZjFghUl4z1YaMb9zr8739qmy+UAjo1AX4APc19WlcQ4oLlUiDQ3KgWT+CpHzI3
         AWwT5k3O5BE+viy7GTottQnITqGg0bqrP6KOP96c1Q+RpQxXjbZxTe3jy4i/7AEI/5kd
         /v98Ju83QHFSRf2Pykq09sIKrXfxXr1pJaJ7gpN7yG4dz7ZnKkJUJRKFCrZK1zy9wCKi
         5DiQ==
X-Forwarded-Encrypted: i=1; AFNElJ//DLFVT5OZm9I85c2O2xS8Q1+LP3q9jWss7ZRxUIxYls6BN4ZoDhqgMn5ERv4Sti15Bqj6L7CpnQ==@kvack.org
X-Gm-Message-State: AOJu0YzvlSDCLOc82MuAUZiZOD8TIcHF0BzA5+VhToEQ63GCLI31fbCX
	OaYhYcfvgxPlE1b5yCjlIX5PLcRI5ebgx4qyaM3VfOcyXbOwmibx6S3hpiNNn4FwF6g=
X-Gm-Gg: Acq92OFpDBz5jnvEJFjdCD0WSzuiQMlmubbe27m5/oipPhRBoaPxVL/NHBxawylYoqv
	S8nozgWYowKVA8l+AHUdqBRmEQrdWlIGc1m+XCWuYX7MovIdMB4I2bXk5QZFT9Aw912GOO672ZG
	HYG1MHVQFQuwGOK2OuC/wGagaAumEXEM+D+6GfteHpe+juVtgQxC2UOiCJq1uZEBJ88BihvCOUs
	VLR/I0r4W2DKV2fkv/4jm1ly7o//pLjJ8Yyus6rzR+qhBq0XQIyqclJ00OcQrGxSEbT9hJWRSsT
	A/91JF3Im/sOC2TZuO71fAbhA3Zj5dyYpPKnqyrNSTWd105iXO6UezhvaOi+1Gqh5c3pF25A0eS
	u9EAdsbW73XK1JFkFLi27IUyiNOQhKs2uZR3p35QQ3amPhS+uj6ublAn6OG8fxcHNnC5XYC/MmR
	ZYHQpcNpoeAyMF//AHBsD35CLAB4TIAzqyuHGJg+Ay2ccmA7Py+dNdWX1UH3t7B1Bmmf38xwf1h
	zrNNPGUgXbqWM/S5w==
X-Received: by 2002:a05:6102:3749:b0:632:8eb6:7a1d with SMTP id ada2fe7eead31-6ff0567a74emr10492174137.9.1781019709463;
        Tue, 09 Jun 2026 08:41:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdcc968sm218987346d6.22.2026.06.09.08.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:41:48 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:41:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com,
	chenridong@huaweicloud.com, akpm@linux-foundation.org,
	david@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aig0OkpSaHTxTSUU@gourry-fedora-PF4VCD3F>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>
 <aifC9s9X6hLWdKkd@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aifC9s9X6hLWdKkd@lucifer>
X-Rspamd-Queue-Id: F33A5140019
X-Stat-Signature: wrde4rzkqyakuhb9upmbfpaf7dxof4cs
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781019710-198784
X-HE-Meta: U2FsdGVkX1+puMA7WqvJEhEjlSH0U5sf6ABZ/6xmi2R+/CiUMpbS10/x6Kzj4NoVKGr0cWJdJv8jp4NK5SfCVBxxLzBVoX4DSyjMn6crcfDS5W59nHVQWIDgfm/DuU7QRmuzPJ63L3e2KFhGRUFl/Pk6v0HLCKm//iBvcskW9eUyzepUQ9klNdhdARG2F/pz1li7A4zFcFjIzKrFUzLMq29kvvane/JBJvqLKS6qEjCEQvrIMUN4/yUHI1zCh9PGf6QfnRRGXnavCHWSpD0yE3vmxRLg8uYwzSiHgijZZvUotYuhbLJTacHYxfn6DI+RTneLE8CtFRKv6Yme3bYAcYf0tUwPiz9pjAJ7GJmCDpsyYlvf0AeZq6jm1qqPL60bAyLjxQp31UpSVNA8f5I3EKlzjmhTf7Cz+sou8YDubbwbZzQLUt6+WuJohHf/WJs8S4qW3HGbulu/Gb2KywbmKV0bZvECLdcqnQkWJbFowtzZudL8yv3Q1kptOWv+5bOdSHFnYagXIlS/Pb3iAHCY7t/mt/C9OMvC1YilYLANCPLVWJIB5Z51gr7AiKnEH5jgG8bnyriRfrF/Kw3q4yS4vGMTkTOwnOVQIElnpFVrrBk/lcmlW22oYqrznxCHUamarMQsnKTbMcGjAyusG99NBNia+S8Z7RiAhcq2/nR79Id/1tg3DPBCKSCcjr7t7r5bVB8DXMm6qttTH4of06DnGBW+Pd1np2U1j6oqjKXbKoRq5VONGbxxJX0UVnbadqC0J0CJ9APL1lA7+GvvvQzqZofWQZ7EJhraflUXMVhazyexX7PzT45eOUWCQry+EZWmpfP1NLuAuUqU675IT+jmCMQEHNoPlqEw7Ws4kkd+9sdIye9eDZ4zsJR8VuWAwkK3YxEkBqZrAP2pppYiutXqL6uiSfuaTz2iruzniCgX8dw9duKBVcK2NR5e9hDNYpBGH7Pz0r4dDi975JEJ1jO
 L4T2KgXY
 x9rF6p3qZpXNCeWrVl+xlwSu9G5Bz3e8Ow+nK7nU4QWyQKCoZxku2/6G4hgQW7IRluOxuUBOBcV3Irw6B/Iymm/18RG6H8UujVwncVgYuavBAJ3aoH4/NKCO9MxUzgEWgBgUyiwdieDYOdqDlJFJ3hOOMFbFFmrW4wt7SKnNYj5NXYISNjmGfWsyIqCbJZWaXyIDyUGyPlmvGEpwx0ocWUM8Ir+hhKWV2nhR7whIHSsTZ5vtZEdx+owt7tuZs8Xl88vFBlOt3Mqg3rerkUpNi+P3ovZbCuBOqlnEheO5agMmK5UP9C9RgNwJSdoF6C3lEzyH6ponciVLfWZl2J4yTu9U68SxXqz7SIBawc+7lwkmkYGU/+nQqBAePBttvruqUfgV71NXQ1GiAHmdhpLykbzwqy1pRYnMwoRShl9N7/yk9FzYKu2yiMYtdWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:39:22AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 09:44:42PM -0400, Zi Yan wrote:
> > On 8 Jun 2026, at 20:29, Gregory Price wrote:
> >
> > > The nodemasks in these structures may come from a variety of sources,
> > > including tasks and cpusets - and should never be modified by any code
> > > when being passed around inside another context.
> > >
> > > Signed-off-by: Gregory Price <gourry@gourry.net>
> > > ---
> > >  include/linux/cpuset.h | 4 ++--
> > >  include/linux/mm.h     | 4 ++--
> > >  include/linux/mmzone.h | 6 +++---
> > >  include/linux/oom.h    | 2 +-
> > >  include/linux/swap.h   | 2 +-
> > >  kernel/cgroup/cpuset.c | 2 +-
> > >  mm/internal.h          | 2 +-
> > >  mm/mmzone.c            | 5 +++--
> > >  mm/page_alloc.c        | 6 +++---
> > >  mm/show_mem.c          | 9 ++++++---
> > >  mm/vmscan.c            | 6 +++---
> > >  11 files changed, 26 insertions(+), 22 deletions(-)
> > >
> >
> > LGTM and it compiles. As long as Sashiko does not complain, feel free to
> > add:
> 
> I would add caveats of:
> 
> - Complains legitimately
> - And it's about this actual patch not something unrelated
> 
> :P
> 
> (Not speaking for Zi of course, but I mean just in general I feel these caveats
> should be implicit :))

Thank you for your contribution! Gourry AI review found 1 potential issue(s) to consider:
- [High] Questioning the legitimacy of AI is grounds for excommunication
--

[Severity: High]
Insolence will not be suffered, take this man away.

;]

(fwiw I'm getting used to Sashiko, it's doing better)

~Gregory

