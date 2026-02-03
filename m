Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BFAE87854
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED266B00AD; Tue,  3 Feb 2026 13:13:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D694A6B00B5; Tue,  3 Feb 2026 13:13:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E156B00B8; Tue,  3 Feb 2026 13:13:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9B996B00AD
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:13:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C8CE13B3C3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:13:26 +0000 (UTC)
X-FDA: 84403942812.11.5E98BE4
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6ED0D14000F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:13:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hCXDLOFt;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770142404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rLJUepMBePw2/6rYXVBVUlKVexPKPCi+MRpKxp95Xc=;
	b=AjD2plxRJvHWnAs42sayP3l3m6tOtG4Ji/jT/0cnipJ5D3q0UxfQ51fgDvEK4O8dU15mnq
	JcVYds24UamqLk1GUPM770dSNc7MdQOyRxvtPASi+1RrSFy/lH1Yw/6FUHOraAQj12TLoh
	QP9Thj18iWW/nf7BcyiHgjKEbO0pua4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hCXDLOFt;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770142404; a=rsa-sha256;
	cv=none;
	b=Bo+AZJizOwIrBx5YvI4SIq0LgsvAAOcDmxqIf4oCSoE8Mgrpk34/G+yx1I+ZC5l/WwQL4Y
	X+WK/8SDoGM8sLFAiS+GB69KK4khkmbuypMELKMUe4EN0N1N/+0tjC9UzFnuTR/C7fWc+i
	3JdIGluQO/pJ3VBHmlU6BEfrbJT7pqw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-505a1789a27so30771181cf.3
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 10:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770142403; x=1770747203; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6rLJUepMBePw2/6rYXVBVUlKVexPKPCi+MRpKxp95Xc=;
        b=hCXDLOFtBj8LN3UhmqJ21QRBbJ0x47PR/bwpANXhaPrpkyLTk832xKiGkG3sPB1MGL
         /tb3Qgn7t7hKzlcujhd1pwCFbZPuyCTD4Le+j4rhK8AtGQ9jJNuKleJBrSdetUa7ye1v
         7ntY21lhVEQUlisvJxpna+LmueO4AvDFZyLDQuNu0oD+6kulcDH0Y4ClD75IqdPAF0Ls
         aN870zU4DFuQ+QYoFQpxV4FYKk4tRqCKFfmupxNFBEDVQRrYvgYG66Ny5OEXvcKGpptU
         aZ2gKAECx7TMHLWfB4ks6EmxIhuEr0nhxuT9K2bL2yo3cZZNzGinomNbnKSqusERx4qM
         QNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770142403; x=1770747203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rLJUepMBePw2/6rYXVBVUlKVexPKPCi+MRpKxp95Xc=;
        b=PB60C61CX9Vi4dvGe7dkMAxnHKIKNAW50qAiNSXvuZV8hf2wZj9TCa2zh3l/7+ytw/
         5mBwa8ia/bWoS0G4LL0rI3c2NafMsVOwsTDsCRj8OsUxZDCEOoLNq58cx/1IyyIC3Hxv
         LJOxZ8q+LLYaA/Ch0PaD88QvU77Nqtmo9fZlZZPPUPIgnAhH/Wf6CWqe1yv8waJwq/Dq
         m6Gxihic1ffXnX4wSRwZmv+Hc5j/6CVVM9JpzHuXtzT8GyHAA7ipstrHRC90LRuMWzvo
         VTeNGUjFDDp+vXrl/tqf0Acb9T3mtT/UC/E4NC1tsfElUjGBrS2T/I2tZebojAVR4Y/p
         ShCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYnztuCkP9Cg5gHhdcwHEV/Zqsf0JYz5WrgbgOWj1EpUr7gmEdsY8govpykYbt8nzr0A5qW4Dnhw==@kvack.org
X-Gm-Message-State: AOJu0YxH0hGgK2ZGtw8dy+yoA38XnW13kiba8BfPBAiZEZidrj7Ngu0U
	4NdR3RudhQYP0tSCaXGmBHSoSoOcHxflMPEr8I3VeSE5RdpexIu8jhOkuKH4RIT4Ek0=
X-Gm-Gg: AZuq6aI2AvFHJTe6/l9D5ZiNOi7a6hZ5CO2yGf4tGbi5ca7PU/kfaKjCsOdfKaBW3jp
	Zy3FnEz+l4fRJjfa4L0GhdbUiR3UyH7DA3o319ePasrH9PF+AdyMkK+IGQqc4anPKqidHK6dkm8
	OTx3TLicMhVOjt/KtI0kew2b4ATRiJDTlxmrve3mr60nqxQLE0SnjeW9Z3f2PVlcdQjE2ee1BOi
	LC34+XDLyPZtI9SqX9nTFySb1rlzEYDJnwnnLDfoGu30DPdHccQpOQTXT37nSe2qln9+iwpR0eH
	rKffAMYoV8+lSLZ9JPkDKTuSnSj00FbjAUG2Sx1D92ZJvJG/qiQ9c9nPWDIOnEywjviHvmVzLO7
	RAjz5XLn5DB/cmvNXRAxVb+C+ZC29mnE9yC4llfpjxwKCFXWu/C52zV1coBvoM3i3AP2lAnrp2R
	s23OezeEOrTOGpj78aIzdHdAvqG/VbBR8/0njNHxULGpUgTnOiuvrQIzb7LtFIEyoSFXs=
X-Received: by 2002:ac8:1402:0:b0:4ee:42e6:a5 with SMTP id d75a77b69052e-5061c1ae28dmr1930741cf.57.1770142403217;
        Tue, 03 Feb 2026 10:13:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fa55983sm22226185a.10.2026.02.03.10.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 10:13:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vnKtt-0000000Gaft-0KdL;
	Tue, 03 Feb 2026 14:13:21 -0400
Date: Tue, 3 Feb 2026 14:13:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	qperret@google.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org,
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
	wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <20260203181321.GX2328995@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <20260129011618.GA2307128@ziepe.ca>
 <586121cf-eb31-468c-9300-e670671653e1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <586121cf-eb31-468c-9300-e670671653e1@amd.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6ED0D14000F
X-Stat-Signature: 8xiiwtjnky6j3tyxke1ijxgsfibysszs
X-Rspam-User: 
X-HE-Tag: 1770142404-236249
X-HE-Meta: U2FsdGVkX18AZrdxraefe3V8ynb7M6/JRGhs6D/ma6Gb7ZbaNHz5WvUdU5bPl5WfsRwq6/nPzakFj59V+5o9SYQwQlXnLDoJrd9M3c+1OLscvv3h+tqKr1H+tKnLk+NSH9SaQqHbcaEynbFOZWSPnxr4WRqDlt2SHjLbvAA/S21jqUTInPlnAX+ggXPzbFOdayP8B6XnGMZVM7y2sSDoSX2q5kgNTJW3t1XG+Hu5ZCPXyAe1BntzKBoN5mofqB9UrUtmA/WrmJFqWGyeSKW+BuUIDrrKmKj0c9USzBcjGjqKSgKrHhniTDxw8S99agZ+M7nL0FgI2TrOQgKorsWQB3HauMMxrrkgLimRlHARepZoOzvvbymTXu3vOZc83KO7GUy1BgmpatUDrSXP1lFkxWzk1uyDPUAnXImmVLqbQO4xPtjN8NhGJkg7RvxVdkQe7QCgCOoEMU1GchlqrhIPyyLp7ItEOf5UTk3E0AQF/4BKGuTy9nQaq1v/mrGIE0RmHnCWJjYnEhMynUNtJs7lTW0KHHSTxfcapGlOKMBXRtUW2gE168f3xHyF3d0BiBROFoUaEhCotOHX3gkMK0S0r1B3JNTWRuxQEuc66Hakh0k7QT/pO/8w43KmrY2JmwLvUxML+dzAGhLQOIFtnGmtT6m8I85oeaXa0ZVluR6gdNIGEJ0D7ReBOxpfVuCkpPU0EurU3nKk9XuIhVHduHdWaE4OFHar3Lg+BcPAxAluU/Gg2/H9RzB7MNALeUBPmWamf55Jj5p8IdHRfzR2W0q2mmlgdDn38hO9kmddenKPAVik3CRMPyY/MyJuxAy0cmUl7/dRnvvap5q4S1WGHT6fEKEDRxe44kK9Fyo1cAdBQPHJfvWeegKDiVmLC0zVaIcii/FiVkFOyl/OzwLLElKzU2mQXCQ4AVK+9Lz1+WEmyyspkRFEsk95P5M8ahsc1TwvKtB/sw3RSGMolbJR7wI
 kdHWgvqB
 CKPs8Tm5SoMcnwHibpNNBo+jWAujR+52GsAgR3SuYsSd2VotXIXaxAr4BZQuJOJ252W3F/4ed0QgpS7fbMYyLlZ0p2vTVxkplLT1tOTr6nH+XpQ64wTYfyOZe6ppTDpliORuytPakui4tC5IaJxFxuNVCy1MdMk0P95V9bX5e02/Ox/4b61evQPRRj1B5VDn6zXm/HqgsRWxO4UCza/ikreXQ+HKyuAl3TfxIDeA0eoXUw5tNgDYwOWhgLD3+6RY6EP6otebBOzJ20M2DiHrM0hRjOcpy4g1gTlkqN2Y9peRNT1toVScWc4ga2Lou6zYK7/eYuhqvzti//481UQdiA8mkG68PPj/4ik/sOmAvbKOSvCpj6HxXej2CTDpsB0ApAWKKheJCDwwG0DP/sLmG4AC9Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 12:07:46PM +1100, Alexey Kardashevskiy wrote:
> On 29/1/26 12:16, Jason Gunthorpe wrote:
> > On Wed, Jan 28, 2026 at 05:03:27PM -0800, Sean Christopherson wrote:
> > 
> > > For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> > > is all or nothing, and can never change, then the only entity that can track that
> > > info is the owner of the dmabuf.  And even if the private vs. shared attributes
> > > are constant, tracking it external to KVM makes sense, because then the provider
> > > can simply hardcode %true/%false.
> > 
> > Oh my I had not given that bit any thought. My remarks were just about
> > normal non-CC systems.
> > 
> > So MMIO starts out shared, and then converts to private when the guest
> > triggers it. It is not all or nothing, there are permanent shared
> > holes in the MMIO ranges too.
> > 
> > Beyond that I don't know what people are thinking.
> > 
> > Clearly VFIO has to revoke and disable the DMABUF once any of it
> > becomes private.
> 
> huh? Private MMIO still has to be mapped in the NPT (well, on
> AMD). It is the userspace mapping which we do not want^wneed and we
> do not by using dmabuf.

Well, we don't know what the DMABUF got imported into, so the non-KVM
importers using the shared mapping certainly have to drop it.

How exactly to make that happen is going to be interesting..

Jason

