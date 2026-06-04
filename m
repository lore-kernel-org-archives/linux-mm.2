Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280A5CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D50D6B0005; Thu,  4 Jun 2026 00:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EE06B0088; Thu,  4 Jun 2026 00:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFA86B008A; Thu,  4 Jun 2026 00:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8AB6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:20:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5EBDC2079
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:20:27 +0000 (UTC)
X-FDA: 84840928494.24.F6EECAA
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFA9A40008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:20:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CI9Lfnmb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780546825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbQ6vfQrwARgrWDKvWJtpQq4FUoOqa91kgga49dPBA0=;
	b=irGsxZ2VBzbpdglgKibmLt2w8KCgxc98dUK6sBYW2ov4DivT2fyqHNh7YBJ3hIpLqWdtNz
	2/9pYrg53qOgQ/hbGhDmNe3mGc2/H8BSd7UuDD5m6WO6b88DcXEhmmCCQdScYFUQVg+umo
	dI+nSfi8LDZ7C0KgIUDiOpo/UvEaTWA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CI9Lfnmb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780546825;
	b=vV5HcoMSIjGv3Wdz97+gA1pxD8fB128OlpMB9f780dS20AcydAQfEmokAEgdoa89jubXeo
	AeISneg0vJLsjsTFvfJI3uK7cgKaUNJZbZDVlmE6o2sINzBElnG3Kp3sfmDp8v7YMLOBbM
	+unEETc3a5chu6PzkDa3HS/FXeSwU9U=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9153e2708aeso35663785a.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 21:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780546825; cv=none;
        d=google.com; s=arc-20240605;
        b=lkfEdQ/+x3erYjK5+pOcz36k/OxcU77T78123KgtuS6qjzfnglkkzxNmNLjLvt1lUm
         gw2lZTExxcLlaFcTSPK+ywtP8soNex2yBe3uTf8+Ae3tTGmfHcQz5tTnk+QBuJaX1K1C
         muI03gxJxdwruOeT+jXwxhuck00sVavgQvLwJ2l3bVZnynpuHuoq1BR44+xTj06/9xDe
         4fgnxNJRvf/SYFae2MQMDO2ekfhuhZuANgLWMMSAbynKMQZSJouwNbklQMRRDowrQhsZ
         BWluhBHCCRr1To62j4ljzYWCUCrXxmxpHjqDAEBgSepT+PB9EE7K46xlF0lDUL+8zOe3
         EvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fbQ6vfQrwARgrWDKvWJtpQq4FUoOqa91kgga49dPBA0=;
        fh=7/YhjJqr20k05ngfEP01unKJuYZGidEH8m9wb0AAfQ8=;
        b=b9hpwOxw5tcEPeYqSWcgTSEuCravhAHRIN/w1YnH1rGaYy9+WO0ROItiJQaePsXG+J
         q6oOL9+0D2XE8xwSnhDGQB3q6X6De6XhFMcQL/zTObDdxygMVo1UbJB03Uk12mNk30gV
         Q3rJX/u6UXbeckAtbLOQ6QSAysZTlW5D+P6flwfm6rI0Jm6kU3nrAPA44UEh3MRPo+EP
         dVAwFoMJBhpbjyVai/hxJqipkKnwtcD2ZHa0l4rgM160JKvWDyfuw8XCJhoQl5BWrZfi
         DzeRdBHE78nCu2/N6A5QgZL6Y9EKrmHpXQurvFj2qujRWR+npfYHOewCjuZfhFI4bkSt
         MY6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780546825; x=1781151625; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbQ6vfQrwARgrWDKvWJtpQq4FUoOqa91kgga49dPBA0=;
        b=CI9LfnmbbcuF7O/KlFNhCj0/3gi8Ct+OZd1sCP+2AK3Tsc984ukmSkqZBIlmg2aqFH
         a8x9wtvNJymlYgXMx7ih+y9VcbrJ0HTm4WDkrdszzKUp1O46KjC1QJQB3RGevdEOm32o
         y+JK7AZkOz4QLzm0Bd8/SwCZtvhyeErN02Dw5WKkpfz0NiC2am2PSyVFPt354oX3tfJ1
         1MC/onv2gZ1CQ4QsKwUD+zhf36Oipp9Sk86YdXj784syAQC4Cyf5kH82vE/fgL8jqQ73
         etW9uTfSZzHT+sPt8YxGiZMvnSgj/LG7CixaRMPUp2kG9VqkKlbeyo11mvJ7/a9OyMOs
         yMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780546825; x=1781151625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fbQ6vfQrwARgrWDKvWJtpQq4FUoOqa91kgga49dPBA0=;
        b=HOqSJXApzpdDw6Ec8C9lF0D1FzvKbzD9mz2s+xR5FDvrmdkKOvvGtl0dhzw3zF/ocA
         JZi7VjEnIGSfxeGa8f6uNT73tNcdz0oawqrr+HSSzo3ZC44ugH2ayxvYVnyIbFH/6aTY
         xMvsH8+1y2EXkGC2A80qVcB8nsRPMpRe04fPhUA/bqcI19DPb1vlZhphFXO3oT0oncZL
         2fLkxu3p5HvJRSvmllfeKlygiqKeQUPI22bc5fh3Zn2YImMIhcEI8j+kr03RmnAvmTbD
         xttDG5+1CCcZNw44sE7+faEn5ld3q3U3u8nR+/c3laZdyMFO9M+cIl1bpdEh8FyI3u3D
         2ViA==
X-Forwarded-Encrypted: i=1; AFNElJ+zNzTCRLDbpgl1EH0HB4GxTLkU/Zwzeftj/yR2dEqKHRAhnqLwR4Wf+LaSI95tpsnqRS+Det1nWQ==@kvack.org
X-Gm-Message-State: AOJu0YwtcUm14dBpwl8/1ZDo09W9HCdIARB50QMSBU867PBvjkX9aqph
	EeU9NzBRSe8S44TBcCgSuEreCC+lgPCTVydFPQi4IgGscGXxSYc9Eo4qVf1/hk9n9shA2VQLM2a
	PZrMIx8+14FjCkhS7FVQTvYmGRIvg13A=
X-Gm-Gg: Acq92OHDYjyv+LZDt6x70dC79S6uS3LdIn+nmk7V18NjHGg2qASpw4w0+MJtOJ3uIFV
	nC4eB4fENuO3vIhH4HQfcN1sPpcTItRsG01/WJH4qiUTFgxw1S8QEKeqV5CO5hyhExyhvEpEN9S
	tXxNzXAZ7hH10UdoqAlBDvcPIRwDu/32Bm+72FbIkF/WPVLHMBR8B/HLyaOPX+XHF5MFicfrNf1
	KmEqJprcZpzb1x6nbnxBmpBdN2LxNS+2F0osmbG86UN4XBF+Jhd5MyQQUvXuec+XfBv5PfvdP6i
	cH8cTE3zTnYCfnFtS73JGmwjCP+obVpbl8Ykng67zvQ1Ly4d
X-Received: by 2002:a05:620a:470d:b0:911:69a3:1653 with SMTP id
 af79cd13be357-9158a7fd516mr988560085a.46.1780546824101; Wed, 03 Jun 2026
 21:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
 <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com> <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com>
In-Reply-To: <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 4 Jun 2026 12:20:12 +0800
X-Gm-Features: AVHnY4KKmG5AxRaMLljUSifBekek5i7G4Gj54Kx0zUQZahUBQkVCtPOcn71W6Go
Message-ID: <CAGsJ_4xTMsV8fJVfhshDQp4=Ax2f_+b6yR873cEP11bjcEa_5Q@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: wangtao <tao.wangtao@honor.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cmigh8wpktf8ds4hra7xogoh71567eyw
X-Rspamd-Queue-Id: CFA9A40008
X-HE-Tag: 1780546825-460190
X-HE-Meta: U2FsdGVkX18wwzQrt2eYinxnscsRRQtmdKiNyvqmhmG9SkUV1YjE8cCWIfb9wGvGlguzHyXW7lmrazYaWzfvRXTmFBiMau9ej9CyHZFFvfvZkSZPwgfd9lyDaZ94dNLIIIa/QWaE6SYWqwpHBiU3AhZsvspnsMbVTZ6dVuD/P+0ptEzrcdgAz49PY50+czZ3E4D932gBmzVYou624V0xFcnKB1SM2fTiH2bCzsmrwxWp8VMNHPJAluTgE4/8jj+b1zhMGc7jgThB6m2njkgNDS2FyM7+1MDBjwLbq2a36/Rw/4HWJWLsj9Zy3rxEfUT1ycQCAD7bPuzkcDqF8OSgPrMHV/SYVn6NO4q3PgUlhtzHrFWAg8TtOBx28FmqHKzVSvoTiezkqoxyDSPrsciwgN4A3ElCew3ZObgnEvOH4RpAgpGV5SEN7NRGuseW/gkpZM4tdI8QEvGLFUMfE1eW9Fn1o6vg3ZL/6K1NF0ImG+WQ5z30Lcw6fYJdREV6KJ8UDDh7Xh70KudjkiAegAwUKt7ZTicrGqaNYQoaL6hdVmB25bALd7alKt1xKFm5S6lsoF23T8fomCMnQa72Ej9v2DvCUOYFxaFtaYiwdDV+QQB/fLdazJYafiospAkJjImp7DgAMrn8zJ63DYHF0Z/fe/VwluXqtKx5su7+/l26RV+2dfCZ8DDVJNsu3rZO4XRfmUGfaz+04F+dFF308ibYZc/O0PUKTa72TEbZa/rGh+XzLQRy616ylA1TmaYLamkVKgUR0/LHaWNofxXzKgqWpF2mThh2wyGZAGNVsJzcoO1INPFmPqlxuetj19H6Cq6t9X56q/9BmsR3f7drK3ukr8qNzbhU7k2I8SL9v2USYNtfdvxMDuG5RExJvoKlf2uwUHGFepfbif3wuSmck6RCSujOmB2ct8C/tuFYExk8QZJtpqHfUIHYqMD70/hCPN82ErRQtNiow8Wh/dFy9jc
 XnyrnX1D
 N+zI/3uIIDwo5eyyJVJ40GZxUT+Ue1JPKNvYyaOaequmA1CWXIKFRIzrymLqR0j1CTRDNZ54V27/aDVVCwLKLaL1Px9/6EeFjZX+aUVv8DUKpW1YVge6DXQvY2unRy+icuILjsywQ9B/MVqObjH96kaxqZ7vi70lnMj22ASkcz13w21OFXJ1pp5TXYqdXaZoPdiUjlZ6/38HW9eUsGqCm5JmM/8GnQwkCaq+0JIplSuMOt3wh0wiwutfxIEehsXiwmctLoCtB/wL9EmGza2o0zR3nXnXiXDSxrAcYgSEjgZjBCKM+QtU4j+ZIFzMKl9dN0S4GM4P9Qxb3CFReyIioIrnJvljMp3T3/TyVpBLooXal2CGbTsTIXKKYRhDRbw83Rfa8E+4f5OsPl3Oa8qvo5R3NReSS5KRhuGT3lcomh3SFOdxnwdQer2dG90Y3oO39m9hceB5SLlvAkEzO9DmX/uxDb3FARByucytI9akdyfPkV39aEzuNYKsLhe/LXKDIFzUTfir8/Ay6uyrox0D8uZFMLfLJ4UFFZGv/XQ3i7N9fIy3RqosucVikXJvF40Ozkntrg4yvfb57dDCEpaYyEG1+gifufz9kvwyBKhU2IeRJFyKGeoe7GrGE7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 12:03=E2=80=AFPM wangtao <tao.wangtao@honor.com> wro=
te:
[...]
> > > I won't echo what has already been said in this thread (and I didn't
> > > manage to read all, unfortunately), but for such big and invasive wor=
k
> > > it's often best to get in touch with the community earlier. Otherwise=
,
> > > you might end up wasting your time.
> > >
> > > Ok, arguably, someone who writes that code learns a lot on the way.
> > > And if this code really was written by one developer only, I tip my
> > > hat! I'd be curious if that code already ran somewhere on some Androi=
d
> > kernel out there?
> >
> > I heard from Zicheng that they have been running this for months and it
> > seems reasonably stable. Please correct me if I'm wrong, Zicheng :-). T=
his
> > really should have been discussed with the community earlier.
> >
> I initially developed and debugged this based on the Android GKI branch
> and did some preliminary testing on an Android phone.
>
> Since GKI generally only accepts features merged from the upstream
> community, and this memory saving could also benefit the community, I
> ported the patch to the Linux master branch.
>
> Because my English is not very good and I rarely participate in the
> community, I am not familiar with the community workflow. I did not send
> an email for discussion in advance with an RFC tag. I apologize again.
>

No worries. I know someone who has worked on the Linux
kernel for many, many years and has excellent kernel
expertise, yet has never submitted a patch throughout his
career for various reasons.

I heard from Zicheng that you are HONOR's key MM expert
and have been guiding them on memory-management related
work. That's really impressive. Personally, I'd love to
see more ideas and contributions from you in the linux-mm
community.

BTW, regarding my earlier suggestion about using GKI
hooks=E2=80=94limiting the optimization to newly created VMAs and
to applications that never call fork()=E2=80=94do you have any
ideas on what the smallest possible hook change would look
like?

Thanks
Barry

