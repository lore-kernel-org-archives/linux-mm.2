Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D75DC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738976B00CB; Wed, 21 Jan 2026 12:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5BE6B00CC; Wed, 21 Jan 2026 12:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1586B00CD; Wed, 21 Jan 2026 12:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBE06B00CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:54:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E87C0C30C2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:54:39 +0000 (UTC)
X-FDA: 84356721078.24.55EC905
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id D92FDA0183
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:54:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rd7b0e09;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769018077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xH16wCmi7yX9t7ufNOPGVV4N0WTciDc4F9eI40Y8JvU=;
	b=VVDXh7biMP6VpejZfhwOnfX+NojBMwqfvVu6/bbloAp2NgseCsNbxrE0MJF97u0vUIxoRe
	6zG57zenwFDfI4mPulHXo3XuLJuOFPHraKjXBmdqO/033JD0Fi9OaH/DE9DhAqdCmFdwMg
	7QsZZ2Xv4AiOwDGewqMV0gBhWe/lLkw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rd7b0e09;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769018077; a=rsa-sha256;
	cv=pass;
	b=w6sktqAxXCTeUEM87G7nPtp4lxT9oVbVYrR5w1GMXvZFoQkSB4MoZUz+rBvyX9XDR3eYVE
	1Um4fxg3m7y2bLYUXwPnc/N5XJKmKyX1VxXaqnhsZUWVwxxaaganTtEjpn/5bprMlTBhQg
	Nw46KXddS5/wmvHhlM4UD3VPg7mwccA=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-501511aa012so11821cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:54:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769018077; cv=none;
        d=google.com; s=arc-20240605;
        b=JesKoR+F6icGsXEtq25JR07oqo4oDeOr1Zdm0hX8jG6leprGOdZ2k8amUHGHn6Yy2h
         jUGP5BrP6kMfPIVdAkJ/Otrz0R94/2Mwjh7gSLwC1AeoTgVda4UJEKp/GOuf3izJKTBG
         lv8+hREJgDZwoI/WFqbsDAMau3ZmhUE9Wze1C112ld+LJvNtjoy8e+08uLUBS6NeVYMz
         LTssTgTAzrqizzORXMcqZIvN3C4oCc9gBAF8V/4nD8v47bYhQRgXIN/F9fAewkVBiBLY
         pi5YbeuV3utUIEMqVE15bzBsWVCNuozBOe4yWVDc+plXyTIYnSX87plIa33fTaCEqhEH
         qslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xH16wCmi7yX9t7ufNOPGVV4N0WTciDc4F9eI40Y8JvU=;
        fh=5C2sHk4/G20NqIdG9+9jz++9fo0kijmVzhzkHMV6u+U=;
        b=BLjr/CcmSl2OoDkHQJrClnpcQ25tHzqPzrMVT6JbQ+4y2cVgGS01qyRfLQo5lza2s1
         9JuliUUrdXI3bsi7fw8FjQzSJWxjufl2d1/hOwIrg+wHh1NJ8lyQut7864FrO7bTMbvP
         CKlsGvO8YNEoXrOVOzRyNxMc+7fPOkAlVoiNph8FpSm24zpgeqqASRjuKfiKm4qd/s3O
         5OrfUCKkki0lgG/FEJtttRsehjOL8+48TQiOsLxUPsqHSXKgHcK6ZxX6EoMoiZQOAUrO
         /FQAy8dAtrVy8NtM8uhzAezHLWiyyU/cIfcHVN3il/k2laodfgk+vrV/XoFIk7Shj2Ql
         4L+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769018077; x=1769622877; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xH16wCmi7yX9t7ufNOPGVV4N0WTciDc4F9eI40Y8JvU=;
        b=Rd7b0e09EXuQqoBzz4y6pz3QEq8omn/hw0SuJZ0pNYxx4x+hX5V/DDL6J3ovJdcTUD
         Rg54UcDL1Z+XmPj4sD0K67LoFCwMU9t3nXKy7zlmMp/Won+n8wy/fTRK208tJQFtEEyN
         uDDxP03Bwyk0P/fOzy0OJY6S/NlBcfMNPGaqGVKsB01L0drBivrnXe4m6TVUg+ECUQuh
         LA4M6JyFSxSkZFRiUwAcBtE+/VzUBq7xCVEWaUrC1imNI7woI+ONV1EzYu+ri7T9cD1C
         BfMyb6lL95hSZrwNfJTqFEUPzLFE3b9Z9My6bQQD3Q0bkJ9IvgJ8EhY9RA1wMSqvSGFn
         KlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769018077; x=1769622877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xH16wCmi7yX9t7ufNOPGVV4N0WTciDc4F9eI40Y8JvU=;
        b=gwdV0H1snAq+BiUGXsBjoYEcABdl5Y5BB/0YLl8SCH2kMzipwHHPPBnqD3RW+s3WEY
         8Ock8eL1QEtqIiNWwoLQQD0F5KFfCtyr2zB1ccS9b4+jkCdQuOPpDbp4ohozRFVafY3w
         WwnwV29FSrobowPiELr/ixldkGNMRFALtRVa0DFuJ2IYdMmQI23GYIKYlSYH4oMXw5Pp
         Tkg96SgsRbN4Nr7nxD8HiPV2nEPvxIvxYaRvf1zGE2jz4d6wqYVSZVO6RarvOKa+lX50
         aqNyhOFz+BJJ5Lh/i7ApbS5RpLIv8/+yhcXaG1u00HUjRWj4lDUhmQ6s0mQEWdv8InPS
         es0g==
X-Forwarded-Encrypted: i=1; AJvYcCWXMGHP8c1PbetqchnPC0hZ8GTY0Vrzvbdzm99oCZk18T90YR9mLZ2Xc+eqSmOAXGtWDMDxE4R06g==@kvack.org
X-Gm-Message-State: AOJu0YyShWC6D1zCSYsXYr7UaWSeq4vNf0cIXUkMw++Agqh5i3sXk+Zb
	oSf+sn2Ke/Kj9kdt62cnrjqoy5ovScD4FqTTe4khO3gQ26PlCfIq87XRA8AgUQqGdoHOt9DU39b
	Nt2Bz9ARuZx6fr3JEsGm2K1kUaKpgHo8/cT21olb7
X-Gm-Gg: AZuq6aJAf6W7G0gwecqExrqOSyWWEY32Oh4oZO3tsLXgbCvuTgLebzTOSjq6ex8vVhb
	SmuxdC3FB+TK4jvQIQ2fSPj2sr8ISR2ODX9c6xUsX4l0GdRwGUbbm5+Ez7/SmLEaqjpK3kA7HfR
	+LNFxk6ZpUpgwTkTkJ576xEFncVEhNr2AJh4tL9lFUatESSotCe5c7FP2fbmVRHEV2757xWNJe+
	YLqsQfOqW+HWGLUquGA7J1ivOUiFeWaarRMsTjSBhgyjz+Gdv+QAb9fRewPV7kpxy3Lq8R9/sbC
	/bnd2RXjrhNTASykKhjnhEUBIfYRk+GQUQ==
X-Received: by 2002:a05:622a:1392:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-502e1a8066bmr12579381cf.5.1769018076530; Wed, 21 Jan 2026
 09:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz> <dxrm4m545d4pzxmxjve34qwxwlw4kbmuz3xwdhvjheyeosa6y7@2zezo6xejama>
 <6a814aef-7b81-4b9d-a0a5-39f7dd7daf3d@suse.cz>
In-Reply-To: <6a814aef-7b81-4b9d-a0a5-39f7dd7daf3d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 17:54:24 +0000
X-Gm-Features: AZwV_QgoKQ8T9fdP0Ka4mFnfPpLd-1PHmliqOQBpu_g2EWtZ_-XqW6Axzna0iU8
Message-ID: <CAJuCfpHRrFS3a8=x4shoNXHLtmvkFgV8xASsQL0-hiUBb-O1Kw@mail.gmail.com>
Subject: Re: [PATCH v3 15/21] slab: remove struct kmem_cache_cpu
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxcjujcfok5tkcdyr6achfurt6bt3umf
X-Rspamd-Queue-Id: D92FDA0183
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769018077-484354
X-HE-Meta: U2FsdGVkX1+kAJbc5o16F9FzYc3cQIiVxkLFtU5Rmj0Lnzktm+jpeJZi2T9sas7GGUk8IweVm3FreUkaGCJiKmYK72IwV9R7aOWzcWaeI9ICOhwRxNY7x4YZpA4YkEYAbsTLdwQgf1q8kaKfCiGzydu6Jxpqdyg7oQwcZ+OuCtES74b41Rme/VsyW32IraKxvC/8sm80nvkv+JfUPVnTCt4YHdtnpWpEO8g+QQ54e8fSGJ7ARTC2iJ70qXIEdgFYSfuvlUqX9jIzqbjY8jru5KdT1SjTiEgqxMRbmOGd3/NZfXGtZ2Bxq6N20vL8A0toXQt0t3Blc+xIKL6eeMuNmFzD3pCmvuswATw+x6baM83TWpTRlijJ/Rupmnim3ZgVRxfWAsBfzVnXnlnPb1q67x4AudCau02ditePdOdsBTGRQq6qmUevKCqfZggL/ZUnIVIIwIFmwqVOOsfzh1H9GLDaEtg+QtDPsWfoNqOi6x0kYUiPRrhnlV6XHt5DKJVoJqBS+QpWw4q8CokkiVSiajr93pGDjGKPi1hd/CH1GkDalfahClD4ZG7+Yit68KPKbmHB86mNrvNGMMtr1z4XBWKUR2FoD37gwTBv54J/7SBDH9SAi4hcye8Ys06pNcmvmMwVxyfBOeyPulJY34vpjxeb/z7DSORjqq4u8ftTdQzkTUPBREdw1+O4yoHkssm1xcXPAqcuYkVyK/s4U+0Mmj3UpOmTEVRr00RpWTW9iWuTadrWxaNSCyHcqFcXwfthlMgMl6CqBPzG0Q6+0d/YuV9s1i8xzdHYnhN4zg+LxvzHxtPw0bNHNa1TDW6bKgj4PnkfJqEMdb49NswZejg+Ri/cXbuKr4IdTUUSo5ga6k1SpNGm8kdJP+6ETrDjJaQ4ICjPrM3KRg7FlcR/59GErDTlzeBrb3POMmdIt/YG0Bi4KU7tSb3TXChASHx2wvpYHNidf+Gx3GIGzM6ME46
 FxLG/6LB
 bxCDg6HsLJfPXSjNrOu/JVIsv3/Au0yxM4CYSmgGKzF7K7kwxvPm/VgCDqaKVnhxDIU4HT47e/XFNG8F7kNFC2nA69O2A/COAiEcSml1g6pNc3NCJ6cGl+sp8SWzN88rmnIONepsSKXQHkWhCZD9af6U39eaO+AndFaK1hcChtK7iRK2HJkbJF9L0otCzBQ+nQLQ1b4jlyXWGlvagABFGiC/4LqJS9ePszXjb3DAmjzoVEyo76cI2Wb8+q5JabKMjkCAjuSGOLwdM+O+l9Om3aDKhhVGKWqlKXXf/z6Txh1ido3VYTJPKubq8aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 2:29=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/20/26 13:40, Hao Li wrote:
> > On Fri, Jan 16, 2026 at 03:40:35PM +0100, Vlastimil Babka wrote:
> >> @@ -3853,7 +3632,7 @@ static bool has_pcs_used(int cpu, struct kmem_ca=
che *s)
> >>  }
> >>
> >>  /*
> >> - * Flush cpu slab.
> >> + * Flush percpu sheaves
> >>   *
> >>   * Called from CPU work handler with migration disabled.
> >>   */
> >> @@ -3868,8 +3647,6 @@ static void flush_cpu_slab(struct work_struct *w=
)
> >
> > Nit: Would it make sense to rename flush_cpu_slab to flush_cpu_sheaf fo=
r better
> > clarity?
>
> OK
>
> > Other than that, looks good to me. Thanks.
> >
> > Reviewed-by: Hao Li <hao.li@linux.dev>

I noticed one hit on deactivate_slab in the comments after applying
the entire patchset. Other than that LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks!
>

