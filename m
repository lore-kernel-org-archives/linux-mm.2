Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6825FCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 10:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880728E0145; Sat, 25 Oct 2025 06:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8583B8E0135; Sat, 25 Oct 2025 06:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DAB8E0145; Sat, 25 Oct 2025 06:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5DC8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:50:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBAF11610FE
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:50:55 +0000 (UTC)
X-FDA: 84036318870.24.593C76B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A83FC100006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:50:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P+A+0tVq;
	spf=pass (imf05.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761389454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
	b=bUfoCvMA+sZSHmyC9Y/83iuhhAtD2B9rCxkLjzB9X+0/mdQVxCIUIiNV4JZwiVDQld2+ha
	woSRKeGnVZoOzTh3cqFybxyFuRNr79YCsnoWf3PJT8Y3eAp+IPhCjA5HtWJKYu8DeGl29i
	6QWpDHGdM/UHWi4yMRCIeXQUVQxV1+0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P+A+0tVq;
	spf=pass (imf05.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761389454; a=rsa-sha256;
	cv=none;
	b=Gk/fZJV5za0H/g4GQ/gJzEG8eGKkH/RbcZGus94DyRdLBGrQiDU3dSMsooh84aST8SZ5wL
	Yar3pcJMGcYK+xoLMcej1g+8Usr3ozv7Di9OaR4odjUp+XeDbI5EbmmYMPMi3NuvjvMF/0
	MLZeI+MasWm4VBnFcf3CjfV38i4YNL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761389453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
	b=P+A+0tVqsQ3NGrIbn3+ve7AX1Amncb4Tfn9DHKGWIoEzDpJmN8sVEcG8WsSe876ykcHokt
	eQGkvCkZm698GQMrEeAubhaOQkPHM8ji5qSSvGYzI0zs95B3hevQ552gBcnAiSsrvYWUW2
	iMe21Ki20FLUoKMDYbcnvuOZTU8lzo4=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-MOMceMpnPxex_7c0Gl4a5g-1; Sat, 25 Oct 2025 06:50:50 -0400
X-MC-Unique: MOMceMpnPxex_7c0Gl4a5g-1
X-Mimecast-MFC-AGG-ID: MOMceMpnPxex_7c0Gl4a5g_1761389450
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5d40dd41aa1so7174165137.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761389450; x=1761994250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
        b=mGd1S4F62VTi6uxiC7gIHTOTrjAFxH5mGkvTUQKade6KjaamfV7cH2E4Aq27CcdCDx
         na3ZQdU42qZl+AmpnutPe5HQ/+2+YwXcBG50B12LJovxSl0HjvJ28rvymEHuAh/zXFC2
         ZAJ83TrBT/zjKKex/HsW2PnSJyG/vLyRSHaZxc0/bc+mLKKF6rkQl09KGaojiJsfdrvX
         v3ctJugSKiC30t9eUjSgnrhnbk2uM3nel+gEMXH2QHVycKIJosj7AWrBK4NeVcntxcOu
         pF3QkMF+jIFecRsYwtfZ9CONlDtJGhYU8k3HLV8RAmohsyVAnaYX3RlYdZ5GjXU30Zot
         U5wQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIh0KzePDndf4ZcXzLIBh+aYTLFjjVaMM4A2n6Elqscz9kMNuQJtid8ieN7vhsgRYl4ENr79rWdA==@kvack.org
X-Gm-Message-State: AOJu0YzFUEf4jKie8v6WuA/41Kx+ck1R4mcfDj0DztD6bM4PY9ks8VMO
	q2z5n2kH3lF26+MuW6ex1yIsDZ/HZcnfxLyn/jlTDA7SMQ+exrdZlzJOy40+ETJrT3S4Xi6F7PP
	M5gdEPUe93Nk3LwiOe3w8W+95Z0fjf0MXUJSP/+dj/uCiwwEIAZfpO2cJqq2o3/R/aYRdXakG/n
	1AkcReIdPtHRU9utEtLCVYsW0ASMo=
X-Gm-Gg: ASbGncs2S9vVBhvZvqxG1xLIO9ZX86/an9Dcm2QNpw1vIkmmZcycO1ThZNQPCmtgXgK
	cY4lbbSQ32j6+vBSKT8YahTVsap+9Bxn9EY5v5eKDOgS4uJXE2cHbouLJsFXxzwuweK4RHElVYm
	8/SQUpM+70idpgyqxTVMquQc2+ykswtEXRM7zLDTmOH4qsPEriqKkkLIitC7zorsH/CGWzPhA=
X-Received: by 2002:a05:6102:32cb:b0:5d5:f6ae:3913 with SMTP id ada2fe7eead31-5db3e1ed199mr1939910137.21.1761389450360;
        Sat, 25 Oct 2025 03:50:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwsyffeJ+eI1nKhYc20dry/5VXueJq+gvTP2aaGjDy37dbuMYWFrmN6kkfCaw0QToy5vgyRxRXy6SQbOpVh7I=
X-Received: by 2002:a05:6102:32cb:b0:5d5:f6ae:3913 with SMTP id
 ada2fe7eead31-5db3e1ed199mr1939895137.21.1761389450000; Sat, 25 Oct 2025
 03:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251024084259.2359693-1-amarkuze@redhat.com> <20251024135301.0ed4b57d@gandalf.local.home>
In-Reply-To: <20251024135301.0ed4b57d@gandalf.local.home>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sat, 25 Oct 2025 13:50:39 +0300
X-Gm-Features: AWmQ_bmwcw8JGGEkkE3wWPKO0fCAY3lGT5ZQ4OURnSkGm9gSZBzLJvO3Udtlllo
Message-ID: <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph consumer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, 
	idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com, kees@kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, rppt@kernel.org, 
	peterz@infradead.org, surenb@google.com, vschneid@redhat.com, 
	vincent.guittot@linaro.org, vbabka@suse.cz, xiubli@redhat.com, 
	Slava.Dubeyko@ibm.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HRWLk2uocl51rn08wQTKT02RbqH_q6DbmI_v8C4aooY_1761389450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A83FC100006
X-Stat-Signature: cgjbnpr5uup391q9h9u1edkd7eyt3njb
X-Rspam-User: 
X-HE-Tag: 1761389453-498167
X-HE-Meta: U2FsdGVkX19jq2nMgph/36Cd/HLlOROS4i+lqU5f6ypDESB+F3nWV7G3LEvN1w3+QDUDpuPABQsGX81fyRR58UQPoJ6ywU34fJ6AiNKMRl5NEPymvnICT42gOQcUoBH1B90OrCdOaOy7UhzGqYahvrzwRuM5UYUWqs70rUpeuMFHUo6SdQhnn4ZwDFBz2ATUCCMuqcu5As1Z/XJJlcWil8iCHEvwdKybM2phRieJKrxboW6WGYL/MBlbtjCTnfjbqfocx5KSGlDq889zqF40xTXLs0xLod30lAwB0rHS9H7Wt0EUQ1/f66NqGSNcBHjEqyMBMNoF63IDmbVxbY/5DPemzIM/h9S8A40iFFl1O6Ec3i6ffXe/T2eM4WBWxKSviQ8wYITT6oQ7aQ4GSWQBSPHIokZYIOABwgkQ74ZDB8KIfqaEkGyl1TBl+TSPSaUsjjywMT3/p3WzpN93bKgJmSuheH7xYPlgdHYeIIceDdY7lr6jGoKg2txwy4oPPxgzOfuKfHdLmxtki5Fdw3P4hJkOgwwz5XaoqbsMfRGvnMkVCLf4v0VFXLtpSfmk4jYLT7gHnPCGD3DjiGLy76hLnYD4gq8FUwDG8QlDmZRmmgtbml/UAYXVK1zkmh25+Ud3KPswDhCHaeZS6ksAZxR3Y4l8JjGrYOOHyQj4dQknQN4ScgN37oJG2o5fyY9lsR9Zihjs4mNXsznGf5lMPJvLMRj8oUBUSqGOZ9fjF0CFPaEJNYlOskoo+VRFB4aYju9vKbfm29yRVK2vKUZoV9xnhplnIE27QXByxIyuFbecK2zT04yQzeet8P6SKoEOIHIAnEkM/m6BjlykU2GV5tspalYSfCqlBb3cAWNVHliDqhnM08wKvDRJepkauXVzVNQjZWBjc9Ndz6TKePm1gZtweKg6OSYCbTKehD/oRhlXELdx9hLWHqfUwIg/2mCYkd5xs1j6X+4g15lk/RA0ZFs
 ufkMh9QI
 AVy0isN7egQr8sERdzsjMyP+dKZ62wfnkmszdOR1o50n1wps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First of all, Ftrace is for debugging and development; you won't see
components or kernel modules run in production with ftrace enabled.
The main motivation is to have verbose logging that is usable for
production systems.
The second improvement is that the logs have a struct task hook which
facilitates better logging association between the kernel log and the
user process.
It's especially handy when debugging FS systems.

Specifically we had several bugs reported from the field that we could
not make progress on without additional logs.

Re: MM folks, apologies for including unrelated people, the only
change is the addition of a field in struct task.

On Fri, Oct 24, 2025 at 8:52=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Fri, 24 Oct 2025 08:42:54 +0000
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > Motivation: improve observability in production by providing subsystems=
awith
> > a logger that keeps up with their verbouse unstructured logs and aggreg=
ating
> > logs at the process context level, akin to userspace TLS.
> >
>
> I still don't understand the motivation behind this.
>
> What exactly is this doing that the current tracing infrastructure can't =
do?
>
> -- Steve
>


