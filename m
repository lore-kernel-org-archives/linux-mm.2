Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2CD2CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C976B0011; Fri, 29 Aug 2025 02:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34866B0012; Fri, 29 Aug 2025 02:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A3B6B0022; Fri, 29 Aug 2025 02:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7726B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:35:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50EFA1194EF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:35:13 +0000 (UTC)
X-FDA: 83828832906.17.E2741B2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BDE014000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:35:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YmoNyErr;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756449311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKJThTEkC/K/3A2oXMbgKnbFIb8hibCNJ9hAKsX7lVQ=;
	b=jWHRlij8ULlFu9k8exbaqNrR/Kr4Gvpcus7A1pGmEz2fesB0oa2LRG4WYNTCNxjks407y9
	n4+a6rlkBjedbCCUK8Z1NBe7Ztd6X/D1RoikYPfcn2yy7ZYiRPxK8SAbrYozpUJJoW77TZ
	sjpjyfVa4hsA2fcyzf2d8CvHTrSugG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YmoNyErr;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756449311; a=rsa-sha256;
	cv=none;
	b=XK8m5icPQt+t6PeH4t8g5oL7NfjgAxhG+2w+raie/7h66qZw5iZuxc7NasltZLudPK++PM
	/ITnSM/CA4x58e3VKEgackSoXEr3/sGavl6atLc2vsSqXRBchzYTVW1yzr9EicGas6sbbZ
	zB311GcUFgNooqTRWTx8Su725UyCk3M=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso10448935e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756449309; x=1757054109; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PKJThTEkC/K/3A2oXMbgKnbFIb8hibCNJ9hAKsX7lVQ=;
        b=YmoNyErr/pV4lNGQ7rVRGRZ+ZGo/KS7a7hcezkvbYqEwQW+Po08v/EcVzFyIlFiGSi
         5d/ZN25okK3LmhJ3NPm3FRlDM6dE16OgCpaseE+7+qxZ6QXhXHbBgquNOBOv9u+lZdcS
         7JWkOmfLxDfFSC6N48IMHoiJ5NKJmEXLIAsnBNWoSsWCGV5pP13v6VLOsZtl/bOjv5y9
         Sg9QvH7TaK7NNXwPjrOE2TxbwCxGXXAcDfBT2RpD7T5ZUpO4Wo+yitPQoVYtSeKjBDP5
         MB8XI8D4VXzqEtjIWKOoyMV+UMU983EzeZDHsJy5Jhvr9KjbuBV4h6pmmXwibQ48S+yA
         r2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756449309; x=1757054109;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PKJThTEkC/K/3A2oXMbgKnbFIb8hibCNJ9hAKsX7lVQ=;
        b=F72F+5/g6fHJtjF5fncUuKUEiHKHBVPWRoUCfCb/KRWkqDNgiPfYtlj2mJh40CuKzJ
         oY/+QpnS815zzgcC0S6BQVDeVspW0r1X09Xlxl1JtHUB9X/XgYIPXTXsfwTYzj70x0Om
         UxvDS78Wxp/GAKljUC51chZ8+3VMPLSlpRtuz2CcMXosI405OlSJXScyysGaKJMJRcsK
         hdJByxmBYn9d+GHJt/wUz8tBHdzPySb841ip+lC0Yfjz7wALyvruJc7DKSLdSRw4ymTl
         ftL66cGJ8yeqHb/GawB107deIgObr3MycF5Zl2wNZJEXUncLlVcQ2HyxYaP6xRcJH5ZF
         c3VA==
X-Forwarded-Encrypted: i=1; AJvYcCXR0dp44kcz3Nm84ljOOKHM+Dg8CWLtWYI4JIhsyeOWh7Jtri9biwb7iX2tIVIyzxApN9RA08XV5w==@kvack.org
X-Gm-Message-State: AOJu0YxCzj4W/mctk6RGLZDwhZ8TMDydQIi+J72ORi3NJVqZnK/7K0ED
	zoup64IbTMHGUJrHzz7cWs32o1/o7V0AqIVDeXMbL+GyOXXNCUfCpN9XE9fAbCSIldk=
X-Gm-Gg: ASbGncuvH9iFF/1kdGwFvsrt7W8ToUBoCm+fysysEii+bJuCnznwB1kOve9vm81bH4/
	Yacvx2Ao57vCwAQ0vyBvROX7ADX7NCM/ncbFyfBPJPzx8AlcZlSnLUVeJNrs2+hDalyIms/0M41
	j3/juFz4WA1IflUV/UCNJjnGRfmR/WEkqlgkl6TAi37I3MBKwxDynxk/95RCcm6p3yIXgH6DK4f
	DYEAZASPzSDBRg1yHp7YwgH7042KzS1E0H9KDYnAOQP3baJkAi032EkIkpKzQyFbOSV6ph/hoW+
	Nt/58keczzuNOkaW8c70BFhJpbylC0wBZAvDC8u9+juiz86RsOlbTHAw5hDVqGWxDR1heLDY6sQ
	npKEghVRPSZwRAd6lijPqkFXV+x3aYCi8+3eduH+wfTgcBQ==
X-Google-Smtp-Source: AGHT+IFX1VMtSwtWd9aPVdIjT6LtMQywn/iQC5nfpzx+Y6PnXBMTKM25EOfu9D+PMFUkDvcb1CqAag==
X-Received: by 2002:a05:600c:a09:b0:459:dde3:1a55 with SMTP id 5b1f17b1804b1-45b517c2f63mr218636115e9.24.1756449309472;
        Thu, 28 Aug 2025 23:35:09 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf34491a5asm2006762f8f.55.2025.08.28.23.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 23:35:09 -0700 (PDT)
Date: Fri, 29 Aug 2025 08:35:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <aLFKHGe2loD657fu@tiehlicka>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
 <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
X-Stat-Signature: cn8f78w5pdxjdg4fbxcjd6tg7b471kki
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BDE014000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756449310-866171
X-HE-Meta: U2FsdGVkX19IydguC8V6jOR4rkSyOdbGXnAetPkUIFvdzxHshQKjCMlV/D9cz4Aw01JRlxs9f+rGcf3nacOUn/iVpxdcNTplo6nH5quAV7VwW3FSICPlMXleXASZcIvjQFaUroSrkYbK6cr3QJ1cGXU+xdd2QMybf15BfTz7vIs5HUtb7jPLdBEvs3CNtYjX7cVPeB+ptVL7CsIayy21pOusRXS1kTQSFhttoTrKrykt78HBphSrvE/PlS7Acncmx/G7TJ/yXhSj7UsDNOAy0YnrjEg968dAK89T6IYlOyCr54KDCvzlX/B6KFGufpY2OueWeOgVjECiu1QByDVcyR61SKZ/tFaaNpHb7km1mMmMWXk+2gRrU8unWpVvodx9XY6raE0/xndmWBwR21a/cGIddEHcCTQI9SUbJYQz+tbVwm6vLgPkGM/koUxyF3kG8GGK0zFdfe91W2g3oPF2aVHkGEl5IF1yurjbYZRUGPKOVlTraW7YZbCFUrz7BM8tN1F6PRlCQCZfYSfRsJ8GFcpWJAfsHJFa1hIp6QVDOGat/Vl0YKcHXjBwg8jv8/ZMdHO6qLkTNTQRBZmUCqTTZwGcEKDsU4LVTmZhIgbPfVEL/VccZOs5Wo5G+410jcNaTJhpo92Exmw3FVzs4LHuX9X1UCqyQXOb3gbc1I4D0l0vVmkaCpIhtUaEG6qmGBuR2KplFLekKJPWAH5mpxHxl1TKaVVmQrtgbxb3g2JNtvyh8SsxUWHWcHEiYMGh4A0z+I3ScV4cFfH2cW41pIyQOkwCnGvsvI9du5x81w3iPfqdi6mLUB89UxVElUjqzjLfF0lYkTCeCM+6B7x8h0vb1uoWKR9hlsMTJIygwKYf36O5ONwJIH5Tj1u3r8bag8+x8HmdWvfaqSRxuApiJZ2OyU4df73nRTXcPCGAVjdf/aZDY4YaTZ+Ds5pr0qMdmhJFi0VY8FTudjgQ2vrGn4j
 KqumYJZs
 rudGQwnYv8hzvjycWxEccExcX/IlUE/CyODa/UGaPrTzXw+t3r8i1Si88YGMKO9qMG+vo3aTJ4d25YMBx1/m2y5jJiD3jKcX5rqIaEXcPtxRS4cxVB0lgkes3vClo1jirFxkQiWu43um0uob+WQBrVRLXAsVwhdQPCJ7F1kGZSzKJexAuwlkI9oookceQ1xAGWsY2vvjeP+gsP7HrHcwX+nNBuW9AcYknEELTSaWdxOtP8vbkL3d0u0S7WW59D48oOpSVOuxUXfrOxcKZkYVHjJr4pz7rAVAnmj0Oj2XXsJAyGLi8kkEwcZ0hqfbZFXqH8+H1kbHf4c7m39rHKJe2bhJnSHV4jiRvnMZyphCoCuCyr4ghDWX/xHOwtt5MHfe0F/Ivsw2FJFGeqcA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 26-08-25 19:38:03, Suren Baghdasaryan wrote:
> On Tue, Aug 26, 2025 at 7:06 AM Yueyang Pan <pyyjason@gmail.com> wrote:
> >
> > On Thu, Aug 21, 2025 at 12:53:03PM -0700, Shakeel Butt wrote:
> > > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > > Right now in the oom_kill_process if the oom is because of the cgroup
> > > > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > > > can have a large cgroup workload running which dominates the machine.
> > > > > > The reason using cgroup is to leave some resource for system. When this
> > > > > > cgroup is killed, we would also like to have some memory allocation
> > > > > > information for the whole server as well. This is reason behind this
> > > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > > information for people? I am happy with any suggestions!
> > > > >
> > > > > For a single patch, it is better to have all the context in the patch
> > > > > and there is no need for cover letter.
> > > >
> > > > Thanks for your suggestion Shakeel! I will change this in the next version.
> > > >
> > > > >
> > > > > What exact information you want on the memcg oom that will be helpful
> > > > > for the users in general? You mentioned memory allocation information,
> > > > > can you please elaborate a bit more.
> > > > >
> > > >
> > > > As in my reply to Suren, I was thinking the system-wide memory usage info
> > > > provided by show_free_pages and memory allocation profiling info can help
> > > > us debug cgoom by comparing them with historical data. What is your take on
> > > > this?
> > > >
> > >
> > > I am not really sure about show_free_areas(). More specifically how the
> > > historical data diff will be useful for a memcg oom. If you have a
> > > concrete example, please give one. For memory allocation profiling, is
> >
> > Sorry for my late reply. I have been trying hard to think about a use case.
> > One specific case I can think about is when there is no workload stacking,
> > when one job is running solely on the machine. For example, memory allocation
> > profiling can tell the memory usage of the network driver, which can make
> > cg allocates memory harder and eventually leads to cgoom. Without this
> > information, it would be hard to reason about what is happening in the kernel
> > given increased oom number.
> >
> > show_free_areas() will give a summary of different types of memory which
> > can possibably lead to increased cgoom in my previous case. Then one looks
> > deeper via the memory allocation profiling as an entrypoint to debug.
> >
> > Does this make sense to you?
> 
> I think if we had per-memcg memory profiling that would make sense.
> Counters would reflect only allocations made by the processes from
> that memcg and you could easily identify the allocation that caused
> memcg to oom. But dumping system-wide profiling information at
> memcg-oom time I think would not help you with this task. It will be
> polluted with allocations from other memcgs, so likely won't help much
> (unless there is some obvious leak or you know that a specific
> allocation is done only by a process from your memcg and no other
> process).

I agree with Suren. It makes very little sense and in many cases it
could be actively misleading to print global memory state on memcg OOMs.
Not to mention that those events, unlike global OOMs, could happen much
more often.
If you are interested in a more information on memcg oom occurance you
can detext OOM events and print whatever information you need.
-- 
Michal Hocko
SUSE Labs

