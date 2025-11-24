Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2589CCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2986B0032; Mon, 24 Nov 2025 10:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA676B0062; Mon, 24 Nov 2025 10:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9CD6B007B; Mon, 24 Nov 2025 10:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3709F6B0032
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:28:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 412531A03C2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:28:31 +0000 (UTC)
X-FDA: 84145882422.07.9C9EC7E
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 41EB120015
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:28:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WlEmDD/2";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763998109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmvwb/YqLsu0y+cxhnZ07KM1iGl9RhSbLvXeq5B7c8s=;
	b=3xL4/QtL65UTGhjUFMwV8eZB0aU0BPdpcTSwVUbuFIFAF64PsMSeRkTDLHetqa7brM7i3G
	ejIpAVBHAlNKtEFnf3U+c7vPpxyJgGy2TVWuLsQv8eb7Rzh33/Se4zQNJxqoRJ9KnOT6mb
	08ga+fSUkcbVReIi8XFldAQ2osGzbl8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WlEmDD/2";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763998109; a=rsa-sha256;
	cv=none;
	b=Fo/GTAfLyc/qYr9p5sthC00o0qWfaoEv2e/qzvyaebnx/Svm+GgxhTVZuRCl0LdfwsYAY5
	MYolAzrOfWpEAsGIgexQvy922RWnW0QaLR7a0M26UTYuLjowjc/4f/yjyS0Nqf7ZGhhW0B
	T3iCv+/dIoUpCGTSafwVcPomBo0rM0s=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-640f2c9ccbdso3598631d50.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763998108; x=1764602908; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rmvwb/YqLsu0y+cxhnZ07KM1iGl9RhSbLvXeq5B7c8s=;
        b=WlEmDD/2kslIHZLbrlTEiuWjV7Zs3hEooQXyJMIavT/dlyfGSNVI+j/27alvl7WIwE
         dGMU8zFJm1ghqy0xlDWmTwmcV54Z4DIIsKoVI0MDaaZzCx3evoi3rxgQMgufrJUrfqZp
         hudimvmzJhW/DMPTH6G2sJyxdyWXeZdofxoyv6/9y6eD8jp918q0WgXwSgl85qnvm9x1
         OF+ud47HjH2VjbC88GjcHAyI04ads10amAH6R3n80GdU33DRb7/ritvYGvU1fBc+ec65
         kKGE/DEJnQTjM7hcW1VRgoy/XamyZOOLFMoOoxZlUTE+UW0SBLwVe7xzOLm7iIrCm2xH
         ddTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763998108; x=1764602908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rmvwb/YqLsu0y+cxhnZ07KM1iGl9RhSbLvXeq5B7c8s=;
        b=Svqhon2gWAANROoH2ctLKaKSDF2vmbF9YStL4DhHpy+HgLuLlwzZ96AjDPyp/o6m9R
         HnuKjgUBQAk8xpgzvtuiCwcdQ8VzT0zQGNhdm4cb9dVnVjDK+4tddL9Lp48izHPmz7+A
         PA67K/ir0JbhPd+uO0/YpqKMGqV/D9AyoKNp0+qJrMVeMiAMU7dsFwWBnJZvwA+6Mzpt
         DI4Yv2a+PyGFe+ioVFv+ME/drkpkTL5K8sstdB4ptoW9MRnUVZgaqjhmpurriNBrz1G+
         j9Bx71PM4C5bYj7YICSrYfjCdp9XCpTaBNFU56eZZ91qaD/c9TKOgTNm1q2/PD8gfx9p
         j+LQ==
X-Gm-Message-State: AOJu0YyKJKsYWKdl8acyeWyUNxNzjWEDQHqznueK27mUwNqlk2IXvsYQ
	mCBlzNVMACzC1MoJ69K8YiHfG3fz/0odQ9gDNRqdmEo0epcgn98K85SwX3AQBdkTPm0=
X-Gm-Gg: ASbGncv670HeHUyVlAQLJ0mzrIcDh9qGvfZ72YQzKZ4UL49/jvH5LOGhSPTvDy/g2Pc
	G6ScO3Zqk0n7uzalUC82OYQGqdddRfLYPcwYR1n4hKGThn8vkw/M01jLwfzxJQ9qsDP07LMo3Uf
	hGcwJ+MgqOZAtabf+KrlmeLMlJkFT5cEAaE0MR2OIUg5MYkiaKZ7MiJPnKG9NNi6dFxLtv1+/Jh
	FWh3CCkXqH5oPWHg9nf2KQv/YVw89g935Q9xJ8IKwNIc94Pk2G0sd3U572BPa8QRHoM5Ak9NiaK
	y1oxM7ZOqqiOZYauklID9PM3vhcggh7k67nrwaWv7ZoXXJ1tQvspdFi2Z0v/2X/G7cVWsnVS8sw
	KoTg426xZ7nhC9BRe0vGKM7srSwlSRep1cXfnNCupXAunAiQO2rj0B1/GsjkauK0+nLixZ4S5Hx
	K8gUZb/cM=
X-Google-Smtp-Source: AGHT+IF2wNBmZkbTfngTULZjgnH8cbmz94buOftiW7SxjvwrErr131yc1azbjD5qkix9lvoC5B3wPQ==
X-Received: by 2002:a05:690e:158d:20b0:641:f5bc:68d0 with SMTP id 956f58d0204a3-64302ad80f8mr6454834d50.77.1763998108057;
        Mon, 24 Nov 2025 07:28:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:400::5:62f9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-642f718bbbesm5022280d50.21.2025.11.24.07.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 07:28:27 -0800 (PST)
Date: Mon, 24 Nov 2025 08:28:23 -0700
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSR5l_fuONlCws8i@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
 <aSDUl7kU73LJR78g@gourry-fedora-PF4VCD3F>
 <c5enwlaui37lm4uxlsjbuhesy6hfwwqbxzzs77zn7kmsceojv3@f6tquznpmizu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5enwlaui37lm4uxlsjbuhesy6hfwwqbxzzs77zn7kmsceojv3@f6tquznpmizu>
X-Rspamd-Queue-Id: 41EB120015
X-Stat-Signature: uerdn8dpf18fo846441ob3a41twazbk5
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763998109-561036
X-HE-Meta: U2FsdGVkX1/42PkUlh/Q3em5cmfA9U6aHr8IJt7FdnwlQxIjJR+uaXxofmlPypDdi8/jkjrBckB4V6aLEtmKs4gTtkwrakaq24SWXAdv3ZLiN6xFOC1am+whIhnX9H0WfJvmNjFcpFicefuLwACFN/Fxg91JlSxFmSndOjKsfzNTFQv6JU6TZVqOKSdHIfAYFwOFCJcT4ZQLdbpX9dfOPFEhysjeu0tJKhcvTs+7UdxFG4StVNFtTVODKb71GoayadDIB1Wg06Jd+5znTvv1FcGa7gRTHPnveezpLHLt0999CYCDB8BR+J01SiL/0CFf9xS8HzGuxrZ0W+XcE0bWq2dmdBAlBMxUkzSuc64H9DNpa12KIGVQ8n9W/RJz1prrxNI4CaGl6ftKxkyXv0rnAcI6U71wtl9yeprqSPFEux3TPLjtUy5Z2Iq2YeoNLzFdFoeaMQk/Z3HKqCEmSFVDKlSgjo/Zv23hnixDE7pX+OEqh+vWm/MWlWCI0HPg90DQRde2vHPNjMw/OuvZ8FUJ/fky93xB+qgEzlK1u95St1QZEX67Jn8T0JvBHrc6Qa6NiseMtzXUaMBNKx1WXAujCl98yWLaLfBvh2fw2lVU7T7fEtnNnzi411J2fg1wdmtOUrVZFfx9xcppbIAdIkV3QWGkUnx0wRvzJbfC8Cg4hGOuaS6yN0A2zO9/Xf62KO41HWkoA/uXTNcCVUEL1OaPzzaPXHRyQ7Tuoz+84XwECu1aD7mZaeUlCovgebz3DLLQ78w90yF834mpn357GtT+JM58KbhbB57PyvfL4VjI5fqjg3fsq9vdLXOqa6ZGhfYmPjrJrS9amBIUzEqrV6tqaldsWB41Ceqqzp1XRnjiCBH+XEBh8SFj/GjRQTgGh1FKrW9LHmF6USHpG/SwaC4fbdvPLn8jizXuXASrIKG+xF1T6v/wC98Uw4aQZeS8NACcwlvjpVUnuAdIKmtdY+0
 oew+PjVL
 Aync0kYbZyTXp7Gj3xKpGyo34bK7gCHsSDzT4Bec7+h4OBkI1xFllYn6Dh3aiJ8XPHwDMDHR/f8nFhSyo+/rq+8uHbsqRcHYhx6s59YVZZsJjACedqf/dPnqp55WZpoQGSiNUzmn+QquhQA1tjnsBNDudSUbtkoOZqtZy4SwH83nLTKZbuDyr9rBfV0jG/GtiIIrKwTubudPuco7L6KqWhjuoYmc+JVFpuILbT6IZveceAarA4QPZtaFkCr4AQ9D3o7Sk9fvDEyUrJSWVEX2yXKSA2wNTGd05I9RNlDlVrrGYn/rSGekXD/l04HUJmFojcUFHKJfpczKtOWDKF0eMmkxvcfw3lZWM9hRi7882yOfh2Y0zruLtA5JC931TlrZYtvRrsj/eUdKzzB6fQwYqRMYmIJDrb2deZFRS+kSPt7oZ1pqIeRpLyXdh/U/ialZnknF8Xx0kNh6wSHhBykBn8ryo1e2MGkMw9RCQI3jkHClg3FHf03zxZK9LsbRawRjdnIiO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 10:09:37AM +1100, Alistair Popple wrote:
> On 2025-11-22 at 08:07 +1100, Gregory Price <gourry@gourry.net> wrote...
> > On Tue, Nov 18, 2025 at 06:02:02PM +1100, Alistair Popple wrote:
> > > 
> 
> There are multiple types here (DEVICE_PRIVATE and DEVICE_COHERENT). The former
> is mostly irrelevant for this discussion but I'm including the descriptions here
> for completeness.
> 

I appreciate you taking the time here.  I'll maybe try to look at
updating the docs as this evolves.

> > But I could imagine an (overly simplistic) pattern with SPM Nodes:
> > 
> > fd = open("/dev/gpu_mem", ...)
> > buf = mmap(fd, ...)
> > buf[0] 
> >    1) driver takes the fault
> >    2) driver calls alloc_page(..., gpu_node, GFP_SPM_NODE)
> >    3) driver manages any special page table masks
> >       Like marking pages RO/RW to manage ownership.
> 
> Of course as an aside this needs to match the CPU PTEs logic (this what
> hmm_range_fault() is primarily used for).
>

This is actually the most interesting part of series for me.  I'm using
a compressed memory device as a stand-in for a memory type that requires
special page table entries (RO) to avoid compression ratios tanking
(resulting, eventually, in a MCE as there's no way to slow things down).

You can somewhat "Get there from here" through device coherent
ZONE_DEVICE, but you still don't have access to basic services like
compaction and reclaim - which you absolutely do want for such a memory
type (for the same reasons we groom zswap and zram).

I wonder if we can even re-use the hmm interfaces for SPM nodes to make
managing special page table policies easier as well.  That seems
promising.

I said this during LSFMM: Without isolation, "memory policy" is really
just a suggestion.  What we're describing here is all predicated on
isolation work, and all of a sudden much clearer examples of managing
memory on NUMA boundaries starts to make a little more sense.

> >    4) driver sends the gpu the (mapping_id, pfn, index) information
> >       so that gpu can map the region in its page tables.
> 
> On coherent systems this often just uses HW address translation services
> (ATS), although I think the specific implementation of how page-tables are
> mirrored/shared is orthogonal to this.
>

Yeah this part is completely foreign to me, I just presume there's some
way to tell the GPU how to recontruct the virtually contiguous setup.

That mechanism would be entirely reusable here (I assume).

> This is roughly how things work with DEVICE_PRIVATE/COHERENT memory today,
> except in the case of DEVICE_PRIVATE in step (5) above. In that case the page is
> mapped as a non-present special swap entry that triggers a driver callback due
> to the lack of cache coherence.
> 

Btw, just an aside, Lorenzo is moving to rename these entries to
softleaf (software-leaf) entries. I think you'll find it welcome.
https://lore.kernel.org/linux-mm/c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com/

> > Driver doesn't have to do much in the way of allocationg management.
> > 
> > This is probably less compelling since you don't want general purposes
> > services like reclaim, migration, compaction, tiering - etc.  
> 
> On at least some of our systems I'm told we do want this, hence my interest
> here. Currently we have systems not using DEVICE_COHERENT and instead just
> onlining everything as normal system managed memory in order to get reclaim
> and tiering. Of course then people complain that it's managed as normal system
> memory and non-GPU related things (ie. page-cache) end up in what's viewed as
> special purpose memory.
> 

Ok, so now this gets interesting then.  I don't understand how this
makes sense (not saying it doesn't, I simply don't understand).

I would presume that under no circumstance do you want device memory to
just suddenly disappear without some coordination from the driver.

Whether it's compaction or reclaim, you have some thread that's going to
migrate a virtual mapping from HPA(A) to HPA(B) and HPA(B) may or may not
even map to the same memory device.

That thread may not even be called in the context of a thread which
accesses GPU memory (although, I think we could enforce that on top
of SPM nodes, but devil is in the details).

Maybe that "all magically works" because of the ATS described above?

I suppose this assumes you have some kind of unified memory view between
host and device memory?  Are there docs here you can point me at that
might explain this wizardry?  (Sincerely, this is fascinating)

> > The value is clearly that you get to manage GPU memory like any other
> > memory, but without worry that other parts of the system will touch it.
> > 
> > I'm much more focused on the "I have memory that is otherwise general
> > purpose, and wants services like reclaim and compaction, but I want
> > strong controls over how things can land there in the first place".
> 
> So maybe there is some overlap here - what I have is memoy that we want managed
> much like normal memory but with strong controls over what it can be used for
> (ie. just for tasks utilising the processing element on the accelerator).
> 

I think it might be great if we could discuss this a bit more in-depth,
as i've already been considering very mild refactors to reclaim to
enable a driver to engage it with an SPM node as the only shrink target.

This all becomes much more complicated due to per-memcg LRUs and such.

All that said, I'm focused on the isolation / allocation pieces first.
If that can't be agreed upon, the rest isn't worth exploring.

I do have a mild extension to mempolicy that allows mbind() to hit an
SPM node as an example as well.  I'll discuss this in the response to
David's thread, as he had some related questions about the GFP flag.

~Gregory


