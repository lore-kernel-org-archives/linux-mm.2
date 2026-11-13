Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9445606A665
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KM9Zundo
Received: by kanga.kvack.org (Postfix)
	id DD5966B05C1; Fri, 13 Nov 2026 13:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EAD6B05C2; Fri, 13 Nov 2026 13:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DA66B05C3; Fri, 13 Nov 2026 13:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A34A66B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:49:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34B081A023C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:49:01 +0000 (UTC)
X-FDA: 85430982882.23.1248459
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7BC7F140006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KM9Zundo;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595739;
	b=5/lCtwS/BX1QqBBbdv34vuLcyI5YbU2YEmFnrSotMo5tDwenQoHwSSEtSdSaSf8eT60xbt
	VAtK0fm+S2uCnEY1xk6X/hYtG1N5ukG+QVWGnxAk02sgkLt+DQ3RU+F56QjXgKpTILnq+Z
	Ve3b4T2XZoRSCJK8mNKSeskZnHv+OEM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KM9Zundo;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QthcyiX160Q2O1QLVhpEtRESs44jcv/A+FxN1Locc4=;
	b=5Uk3KQs3lMK7fabdhLfnWlIJHI6Cf1zK13wfmAOn+ZOTAlLpZwShLv501WfzGHUEXhsuID
	EDAJenvJO/Dnt+sHvEvYJtrIVvhyXx+AS+WWTVyP7+1NRbTqRXzTRkKHAhSKu+2FpvrMwd
	N6zqSR/SfZ52xnwwND0oa8rCtxM+4+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC11041486;
	Fri, 13 Nov 2026 18:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3141F000C5;
	Fri, 13 Nov 2026 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595738;
	bh=4QthcyiX160Q2O1QLVhpEtRESs44jcv/A+FxN1Locc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KM9ZundoTl/C+YRnnU78L9MVp1BzRd8EE2j13ChbAlxTVzDcNGS4mO3I5tLHPBi2u
	 BYEGgyNd8OumZ4JIQj27B01nx05UhAX7LynlAFmE2SKHQL/ggv/SodmJ6ne+VMwZPy
	 wPorpOp5FN0796vB5MiXuYp/z26K3ioFHVvuaaM89V8tl+xC9m8RxH9ARgR7AYnCiK
	 yYr4cY5ALq5WS4jStkYUz3ibMHWClD2mK1+TVzMD8WX73BIIIkzOMbzhmrBPlgTgKz
	 9RFVK+2fNI+3NMD0KQEbXC4lnIyDhdmggZD4Xnk0Cii4vm/uPUCsEr5yGeOYIyqnZF
	 +7+OMMzS3HLJQ==
Date: Fri, 13 Nov 2026 18:48:56 +0000
From: Harry Yoo <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/6] mm/slab: Support selecting slab hardening
 features at boot
Message-ID: <avdbfEfQHpF9Ez-e@thinkstation>
References: <cover.1794506262.git.chris@chrisdown.name>
 <CANpmjNP0cWB_670hYj7p+Dd=do1qEu4XHeW+c7sTv-MXi0UBTg@mail.gmail.com>
 <avdQEBP70kK8W7d0@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avdQEBP70kK8W7d0@thinkstation>
X-Stat-Signature: rzeeiont74mqthehpmn7qkgck5p7hkoj
X-Rspamd-Queue-Id: 7BC7F140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794595739-36534
X-HE-Meta: U2FsdGVkX1/37noWTJfbAS0pcONZxWlO2ZCgWiUcmkg8dLc8pX5ihU5zpMzg/MjrZvlv9FKHMxOmh/VzzidFiHhxb3A8vZgNeSUFoamfoE0M0s0nnwJzuSOdVDSjJpDd/R7K7gq4MiJpjyTHO2wb11LA5VP+5fTCKJzkT5nNeirg9bKvKIAkgg/ND2d9kHoUGBM9Gqyv06Od6sBwtmp0ZnGR/aS7xMUw+ZgojgyztE0HCCIBGDdznQkxkKxL3nc2cJHgP+jUZF8fP3yIWcPHqEEKU9kt8lczZyfK0Ku437jRF5VsBYlejUHlYbnxO6ppVW8uu/uOHLvk3rYabQ0gM20Tv3edqFaWTHJVrJ8LxfO18WVeGuT2XGgrY/jy8hjZdbj+NuWya1oVRuvp3apmNTJkxnhox/K07iSfQ8BYhcMJbZnYcNn9oJ1H/afxLj6Xhm9HTTH5CfgGFmNOx4/de+usNuBk73ltIvjX2ty7CBvy2QrKf628JfBzeYlXx/qqM8Gh3oF1dNFBGWGGMwY7tXjBt5tZG4M3EV+RYMuZ/ATHZ528iFND4i2fbp0Te04blV/ata1DCyPWIizp06TbYdrATwAZ/iPP5mU8Y0zhCNtDexf5Y3iwWK+9Wkaz0ZvTMU33162WlWUXoOBkZZj3bMX98Kt/11AnUdOYRO7us8BcdK/WyIOpsLbLT25t9/ZNvHxiY5zyBuCX6A0Y8N72n7x0L9++GAWbHL6NzUkmI+5DN9BSE333lEyhPU9287BmjZeyiBTtcIJwfqN45qJ9dBpo9gdABRa5qw7Hn59rN53HMGkUBTHCEqbQOHp5iys0fqXNHrZ8GprxitxzwsIZKKI1+J0rNU41akGOeYnRBdxc7GQuUaT6oVzzfoD7qsBWKHD2ReCSqwvlADfPhHDMAlXJAsmgD+zznz2wMIh+Uym4fADsevKb+HPtSbve2daFBPh5x30JKeTdHk/I+2e
 pZlagSSo
 p32sLqgL/ZiODByVJSocmKPSfd60yujKt5+12PVNPZJmkvgN3wLnR5n9R6k/ko4GNXnnkt9MZHJe0P7SWePH9UVSaqcZtRgtnYkdp4dyN4osEjBknzYxvpRnDLASPRejqJ4ZaR2EdjD8snnxBKWf/RB0YGb65nRoR24v10nWTA6UCIIMKHDnYZUZGfdOrzE4Sv4ckM8R8nsg9C0EwJ8vmgU0wRl5rLHmDhCd7nlrzfl2mzY5tDNhIe3nm77oudSGMyirv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 06:36:49PM +0000, Harry Yoo wrote:
> On Fri, Nov 13, 2026 at 11:56:20AM +0100, Marco Elver wrote:
> > On Fri, 13 Nov 2026 at 09:51, Chris Down <chris@chrisdown.name> wrote:
> > >
> > > Slab hardening settings are currently all build time choices. This means
> > > that, unfortunately, hosts with different requirements end up needing
> > > separate kernel images. At Meta, for example, some hosts are built with
> > > these options and the rest of the fleet isn't, and that's one of the
> > > things that keeps those kernels apart.
> > >
> > > This series does two things:
> > >
> > > - SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
> > >   sheaves that it makes more sense to just enable them by default than
> > >   to make them switchable. With both on, system level benchmarks didn't
> > >   change measurably, only slowpath heavy microbenchmarks did [1].
> > >
> > > - SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
> > >   about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
> > >   they get slab_buckets= and kmalloc_partition= boot parameters, which
> > >   default to on when the option is built in.
> > >
> > > Whether those two should be folded into a single slab_hardening= is
> > > still open [3].
> > 
> > A coarse slab_hardening= option can easily be replaced by
> > documentation. While less knobs is better, an intransparent coarse
> > variant of slab_hardening= just makes the admin wonder "what does that
> > actually to, and do I want it?". They still have to go and look up
> > what it actually does, and at that point it doesn't add much value
> > (alternative suggestion below).
> > 
> > > > > light: "I'm willying to sacrifice _some_ memory and CPU for security"
> > > > > full: "I'm willying to sacrifice more overhead for security
> > 
> > Who will decide what is light and full? I think there just won't be
> > any consensus reached.
> 
> You're probably right.
> 
> > One thing that users may want is an "all off" option, similar to
> > mitigations=off, should they wish to get max performance back with a
> > single option. So you could consider slab_hardening=off.
> 
> slab_hardening=off sounds good to me.
> 
> However this assumes "all on" is the right thing to do by default,
> but not enabling slab hardening is not as nearly critical as not
> enabling mitigations to CPU vulnerabilities, no?
> 
> I'd rather mirror hardened_usercopy= instead of mitigations=off.
> 
> slab_hardening=on (turn on all slab hardening features)
> slab_hardening=off (turn off all slab hardening features)
> (Otherwise it is determined by CONFIG_*.)

Should have been CONFIG_*_DEFAULT_ON.

> > But at that point it may be more consistent to drop slab_buckets= and
> > kmalloc_partition= in favor of arguments to slab_hardening=, such as
> > slab_hardening=nobuckets,partition. This would mirror mitigations=,
> > and should cater to the usecase of slab_hardening=off to get max
> > performance with a single option.
> 
> I hope we don't reach this point, but more fine-grained control should
> be achivable if it is indeed required.
> 
> > But I would not add options such as 'light', 'full'.
> 
> Fair enough.
> 
> > Thanks,
> > -- Marco
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Cheers,
Harry / Hyeonggon

