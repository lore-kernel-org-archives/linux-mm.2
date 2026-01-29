Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDDDD46BF0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 01:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BD26B0088; Wed, 28 Jan 2026 20:16:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952826B0089; Wed, 28 Jan 2026 20:16:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851EA6B008A; Wed, 28 Jan 2026 20:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72D576B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:16:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15FE613BBE0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:16:23 +0000 (UTC)
X-FDA: 84383235846.19.7D75A9A
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33E2B1C0007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:16:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=bsW5BsMq;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769649381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WReYS7VDfIh+dvxdrk0biwhaBbpxlirvLLAI4b8c7GA=;
	b=SW0h7HQkU/1IVKSXhMTZ6dzh92CMSGVOQG8XA1KL6iVU4KCPKW5Jg0lZXIA4RN1zjXNvD2
	Njvf4i5mpPk+5jxCSixdGP3rMZmiAu279MHfjWsz+oFrC8DPnEh6SnnL+FOgYExHDwMPlL
	5XfBFFwxTX1Lg9AcHnmqcUs1+oxEqXw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=bsW5BsMq;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769649381; a=rsa-sha256;
	cv=none;
	b=zhYBh03MfJUWcNY4XWiGWTWt8RF6PTH4ZniXW5N/x1VSRGJDZeOwWWba8ZQnxCKQXp93Ll
	uYd1sQjLziz0Mz52MK63G5PmKHxysjAq0qksN/oYUoFKZ+S0rwveofzdhDDOwcj6g6JSfC
	mnGwXCOY6KtHDdH0gz6TQcftdVNXXwI=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c717f2b654so71054585a.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769649380; x=1770254180; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WReYS7VDfIh+dvxdrk0biwhaBbpxlirvLLAI4b8c7GA=;
        b=bsW5BsMqriD6Q1Xir1e6NAOZbwaKwhLsvgYFq8a99dc+0sEDASdIa6SiCpE8TUJ+xo
         vvV4LsQT2otrN+K/hBcehGZwgex0T6MRRXn6BzqRUFv6u5Ytb+p2r9Hx+f82wjSsVhfo
         VGzSItUdAzzuVvHzHuA+dhbBRiM37lWNzWS0GczLypMhysxB25MjAyS8XKd0IePlrr/i
         bj6DqNu0mALrrCiRQvM9bzJ4U5jIhXERGREg7m3BXJ+IosKRUwaNRexHZzEPvN1C1Hjk
         jMbfRGJFlzJskovuHgxAY5bNONoWkdqE/ggbARqOfgt+3y0J70/U2cba7LH68UO3fv7X
         vKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649380; x=1770254180;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WReYS7VDfIh+dvxdrk0biwhaBbpxlirvLLAI4b8c7GA=;
        b=G/83K9M3wGjggJXE2yrpMXHWAU/5zjCFqbg505VX5ov770g0tS2BVIaXXwynjCZ9c0
         +Iieya0qg1zZ/MzfvcarDrW5cGKVpgEZHEs1ZhpAWU9x7gCWFg49Az6EKBnXA7d6NJnK
         1JahNqXOCOVuqYmvCEJUsbjPWkLMU+GJrvEUl0xtl+BkwF+lSaVk8n607nlGqVwgRf3H
         kuvzh4Nk5DYLST66rtDPj8RsH+6HYMAW7+uJQplztMd2yBOKjdBj7BOni0iujSF7I/wN
         grLw7tWS0E8sJp06AF7q6wzxRYS2TkDXmOezhi2koDdP47FaEzA5chtkRslwm22ePJyQ
         s0wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyWql+l5Qr9/gfYJvKuof3WfRVwPxmjqdP7DTx+UvTtvjwm0oF9MkE7nfGDFiu0GUM0+zTuuFQfw==@kvack.org
X-Gm-Message-State: AOJu0Yw9t05OP7WWIjiKfUV/WgoNfFAMLiZsLEWL9tYBmdUQMy4R/nK6
	Z4aBJHjb0ZHSu/aortJvKtdYWgOdtsj6Z0Yu2avarOAPD6TGSHP3wypxMWJnQ5wAIyA=
X-Gm-Gg: AZuq6aLcIgEmlh0Wpcy3uWP4ivsOakAiZrAZUfSKI8J21Aja/Sl4xCRt44rLxLIWDfq
	TpNWGtBXN7s+aXjN4sI+5hn3GwD+RSYgtGFn64TSXUWRhjbZj/NuVk32y0ygS0KJh9Kli02yTog
	ui4r07ARPOZtMM+I8XvxujKvsftOuNeot5MDkJgWZXv+8NMiXHcl+r0RKltyxRNWiXCgk1Dtrtb
	kWph6pusGHX3bJt8ITBd44EZpckkMelyV0Fz47x7jkzuSGYACqlGpOJrSfikcDO3C1IBH3AKp84
	dCOPryN0EuHaLtdkafyvZ1x25tYx9XmSvMMTUX8OVYCWHJ47hR7QnZ4SvOp9CwOAzb8VomUq0PI
	m08yf1Vhd3Rw33Vp/pkYd9rgL8fU7y/sqGM+K4hVGmd6bgR9VZRwKl9SlSEKKDiNzsyvgDaO4lm
	ZZh84AGh/ysgz9kCET/sXVeT2kNwlEohOAy2Pc2Eo0eNnh11ZPALpiRoktuUDDD2KWV0s=
X-Received: by 2002:a05:620a:d88:b0:8c5:2ce6:dca with SMTP id af79cd13be357-8c70b841159mr939733985a.6.1769649380018;
        Wed, 28 Jan 2026 17:16:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2ab04sm283038485a.25.2026.01.28.17.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 17:16:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlGdu-00000009gKo-3mMh;
	Wed, 28 Jan 2026 21:16:18 -0400
Date: Wed, 28 Jan 2026 21:16:18 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
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
Message-ID: <20260129011618.GA2307128@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXqx3_eE0rNh6nP0@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33E2B1C0007
X-Stat-Signature: te917akmkuaakqshsy54nq6txeuqbire
X-Rspam-User: 
X-HE-Tag: 1769649380-764562
X-HE-Meta: U2FsdGVkX19kHe8TwMrY8TWkSfxBq2sLSkx2QCvnATvUyhZVGUAQSygOYeZQsOw0Q0dFcW2mVzsWRhD4pfgnThXnJiXhDkutDXQQY7lyOrlZRh9a7FVnXlQDl6qN13zsbNDKYReBVtoEXaECOv/KV1IXR8nCA2O8VVdumFl6oRtSH6bjuiU9sX3UyHOPS6FfRrckDKDG/ucCgBdn9suj9dk/mNqW9ugTZzpZt2AISRLFciT8Fyndw/5UD/tQLC2ielAOaaGX4kwgsc33sdnUq8ffmXiYz6RI63bbXYSt44sbA5+JfY5XHgRu6iYarWuKh+1wNktH+Zp4eACWOIiqNd4dz+NYTT5wovKL2FBIs6SlfHdyp/eY22CazYJ1FJQgaSMIXchDmTwMLN8DHpXNLtN49Zbn/WMLPlIoxXJue4xftHsI10ZU4wayQvcrowuHl0zGDqxoyS6lRZXsBTIsnbT1kKAVUwJyJvJ5THbcu6lDLPkKe6ls3Myip4bhOaAZBniaS8txbC5vcVUhxQaBjN0N8Kbv+jxVXMd4gJMDnY+4GXD5QQaDlIIIi5QvJ7SSR0RoJrpO1ACVtrihXSYpDsX6YNShJXUvkrl2aaDXkdlMe2DoXBD0UF3LoejSH+F21itZUt3mr9N83SGO2NW+VBd94yLHKmcgngiIf///cX88NC/VF8AApPqohCtClXau32xZNdsWF5IfbCcVCb/y0UyxC9EY6wGEcriVyo0gxpQgSFyo5iS/59maXiguiQIafw8MQ3dHPFtxEHuK2d4T0llmXe95Nf1hsjh74YCdRJ7DHTI9bDHSyTMp2WNm5/FP8RDtypOKHDCWisZzfJa+0311iDp6bK6sTpfDpC/Fl5z3+hf+u0vyJ63DPJQs4N+s/8mnH6SszR8WS3BzLe2qc8GPPWNzkkrWzFsOycFO8Hq/JC2OggS73+PoQWxEsxXgygC4O8OTiSO2enFv0Fs
 hLOoMa4H
 gcbIl3ByWQy56ByodNI5+Pd8heoXeD+2vqXCiyFAMOcEaHFP0N4d7dUQhKB3FOKknCLeFfktG7wIGyoObWapb99QQFqC8cuoj82u62bQkqh+2CrigPSO8fOPXl0I/XmmHmNxVDujGb8l+4YC5VwVdjZRsCDufnJkLDsb9iC9xUMLl5g9MW8HT/3bp4Rpjl4FsqJnN1gcBcDVakl/Iqwy5GpioYpJOD7ZjPrE1SR7zRERR64wMNbyxdEzuUG6ajnHYfZdh8wQm94IWRZb7x43ewhm7NFU0gy5u+vePUNFjWTViLG6BlUfJSzYENyqCFP3oeskCXD7EkP+623TcckWZY941K2yZUN+kgtDIC5wdnJW36cD80l/xomZp9eAfv6q7K79CRfsAkslpkOI3Kzt5/wHbEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:03:27PM -0800, Sean Christopherson wrote:

> For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> is all or nothing, and can never change, then the only entity that can track that
> info is the owner of the dmabuf.  And even if the private vs. shared attributes
> are constant, tracking it external to KVM makes sense, because then the provider
> can simply hardcode %true/%false.

Oh my I had not given that bit any thought. My remarks were just about
normal non-CC systems.

So MMIO starts out shared, and then converts to private when the guest
triggers it. It is not all or nothing, there are permanent shared
holes in the MMIO ranges too.

Beyond that I don't know what people are thinking.

Clearly VFIO has to revoke and disable the DMABUF once any of it
becomes private. VFIO will somehow have to know when it changes modes
from the TSM subsystem.

I guess we could have a special channel for KVM to learn the
shared/private page by page from VFIO as some kind of "aware of CC"
importer.

I suppose AMD needs to mangle the RMP when it changes, and KVM has to
do that.

I forget what ARM does, but I seem to recall there is a call to create
a vPCI function and that is what stuffs the S2? So maybe KVM isn't
even involved? (IIRC people were talking that something else would
call the vPCI function but I haven't seen patches)

No idea what x86 does beyond it has to unmap all the MMIO otherwise
the machine crashes :P

Oh man, what a horrible mess to even contemplate. I'm going to bed.

Jason

