Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12F4CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2778E0003; Sun, 28 Sep 2025 10:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093948E0001; Sun, 28 Sep 2025 10:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB008E0003; Sun, 28 Sep 2025 10:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA55A8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:09:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77C54140119
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:09:05 +0000 (UTC)
X-FDA: 83938840650.04.680EE0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D01EC14000D
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:09:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pWef6/N6";
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759068544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+pnhhVPwQtp2ob0Ljz0ZqQa+RW/VO+kIfI/fInRQ3g=;
	b=FirQayjiaRyqgTTho9XYLn7+BKqzXTrA8/teIr0hBGkP0S4JwXCpicvFCZSe2lMAzhrLjk
	5VbHMUx7IAygoAA11/dEs+z4dzOBFGIk4EZ0vTC/Y5DqM/2b+S+imgCPkwY7bfK14FR3TW
	jrLGMMNr3qRIKxShRD/oJOEjUZ0B6ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759068544; a=rsa-sha256;
	cv=none;
	b=47SszaB9LCPHT1ze9L28d11Fo0yCH3uJ0tLtMhBoY8aARO/1Lg4MKL/LZrVuSYtr1qBRKx
	KPf+Tu/I7ixDmqS73mHJIXtTd2qtFwFRyrZtXcamcrOFrnndHuwXU8P6akSyflQ2fOlaH3
	TOKDrI9Vyr/iLxRbwePC1D+tgSEC8Fc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pWef6/N6";
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 814F141707;
	Sun, 28 Sep 2025 14:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4016C4CEF0;
	Sun, 28 Sep 2025 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759068542;
	bh=oLopCkmGri793JE1kd5+sWMGisCseqI+NsmBu5y90K8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pWef6/N61eoFufqCle9xI0T0DU1bauI9krI9XxIo4sI9ZseI9gcbbjFFi85JiVBWr
	 Q9j6FIA0BDuoMchOPOT45kc3k+akgS6Sg4iLtLIRzFv7D4eRCKzAmPobCJsOTPNn3m
	 pTcS3BoqIJHTA8qrudy3uv1tjeVATtPSfcZ5htEpV+INz42ZaIhk0vULPa9+OJ69MZ
	 D/bYvDjucs1IZi9Ff7HIRr5UoXOsM0UNBjQdfrFdHNIBnS4GXv+XYPkCJGWuh2xUZA
	 f4lEbio8+Vt1GziYj++Ta3tzjnqYUtkCZ/F78PzZUzi7pOXAtgRcdWbIYrT0JlRFbP
	 l1TlMqccYnL7g==
Date: Sun, 28 Sep 2025 17:08:57 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <aNlBeSpNCvqKXBWm@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <aNZWTB_AbK1qtacy@kernel.org>
 <CAM_iQpWBHWscTbuUm54G3tvqf-EQhSYaFJqEJD4M73doeH=TKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpWBHWscTbuUm54G3tvqf-EQhSYaFJqEJD4M73doeH=TKQ@mail.gmail.com>
X-Stat-Signature: tzmp97d4uwojxmrmpwt7uzuaxn8j55d4
X-Rspamd-Queue-Id: D01EC14000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759068543-929883
X-HE-Meta: U2FsdGVkX1/xZcLQvAWNw8hEfpZA4o/3CYpttTwKyudZ7RInZr7oaSCXwD7PRW2IHyENaK+aJQ0aamMELgIfdzrSH5p+iaZr7yvoXzYroWfuxWmRiKdk5LNhIuMwazJ0Cl93al5aj44SZEpUo6pcheSWvi0YhClZNTq46E0IsXeozBhxkXnXbh7MsKLpiyEbyxoU6NJ8XtNQjwazY6ecpEtl6ycWKfX01OiZwy+QSkHJsX5I8FS7AyXjLOG5fYxJk8Pm8IBD5gyPWCJGVmIj6A+qHWdO6/TSCZxMyVS04NriCaVYTMTdBURty5BNho1TrXiqsvO22N6CzQfhzAkqzjJpUv6mHgZkP6lOtZbf283/FyWFG2GQv4AYhke+ynGaL4O49enp3I9KpGOgANRriabo9w/9WHly/MeA4/MEYWJX0LTSi4us4h4qaOxLf1aiN4wFb6swmp3NQKa75GHirEkmMzgjulsH3ompo09lqkiiWt5oy3NfyR/+sbNOAtDLny1qTetDopZb7L/CFbruY1mpmOxeGBj9tosju4dlPgLSCK0NNYjhM0j73FrBfwiUmu9EHJLJePioWkcCtBWhx7upEr2Pbty7IaMykiv9IjL4Uevnu5ssaxwow6eP8TFQZthkCq7PoiNxApUvN9uJQ0jIWOTy5BSyJ5o0vSJuzME9YNTVZJ7sOD5rI4PKq2jGKYLAt9fTLJj1RIf1rAwnvgJCD5SXiiphhTt56T7WyVSY56qwU8+RRuUKbl381dEbyGZl3Y/IvGrCkhZIyhHBpKagYiLtMedqGP12irbz8LFTr8Kuc6opXCQ+K6jDtmsFX279ud3JnV3B57oZYcJNoG5nM/qMmD4NgeVI0VeQ3kNhk85H476NfAIQttHwZNe/ZnvWEoIWukka0EeFgJVu2Z1i9HDFm0qnL7DDfvjQJfOcw3vLYIxbNnZI9JphXQAN/+0MTkU8xxmiid++iKX
 jeWfyEbR
 4Wi+GT4BRLu/ZcxB1GYD7vsG2PJxhIhsOLny0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 01:27:04PM -0700, Cong Wang wrote:
> On Fri, Sep 26, 2025 at 2:01 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > This patch series introduces multikernel architecture support, enabling
> > > multiple independent kernel instances to coexist and communicate on a
> > > single physical machine. Each kernel instance can run on dedicated CPU
> > > cores while sharing the underlying hardware resources.
> > >
> > > The multikernel architecture provides several key benefits:
> > > - Improved fault isolation between different workloads
> > > - Enhanced security through kernel-level separation
> > > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> >
> > This list is like asking AI to list benefits, or like the whole cover
> > letter has that type of feel.
> 
> Sorry for giving you that feeling. Please let me know how I can
> improve it for you.

There is no evidence of any of these benefits. That's the central
issue. You pretty much must give quantatitve proof of any of these
claims or the benefit is imaginary.

> 
> >
> > I'd probably work on benchmarks and other types of tests that can
> > deliver comparative figures, and show data that addresses workloads
> > with KVM, namespaces/cgroups and this, reflecting these qualities.
> 
> Sure, I think performance comes after usability, not vice versa.
> 
> 
> >
> > E.g. consider "Enhanced security through kernel-level separation".
> > It's a pre-existing feature probably since dawn of time. Any new layer
> > makes obviously more complex version "kernel-level separation". You'd
> > had to prove that this even more complex version is more secure than
> > pre-existing science.
> 
> Apologize for this. Do you mind explaining why this is more complex
> than the KVM/Qemu/vhost/virtio/VDPA stack?

KVM does not complicate kernel level separation or access control per
kernel instance at all. A guest in the end of the day is just a fancy
executable.

This feature on the other hand intervenes various easily breaking code
paths.

> 
> >
> > kexec and its various corner cases and how this patch set addresses
> > them is the part where I'm most lost.
> 
> Sorry for that. I will post Youtube videos to explain kexec in detail,
> please follow our Youtube channel if you are interested. (I don't
> want to post a link here in case people think I am promoting my
> own interest, please email me privately.)

Here I have to say that posting a youtube link to LKML is of your
own interest is not unacceptable as far as I'm concerned :-)

That said, I don't promise that I will watch any of the Youtube
videos posted either here or privately. All the quantitative
proof should be embedded to patches.

> 
> >
> > If I look at one of multikernel distros (I don't know any other
> > tbh) that I know it's really VT-d and that type of hardware
> > enforcement that make Qubes shine:
> >
> > https://www.qubes-os.org/
> >
> > That said, I did not look how/if this is using CPU virtualization
> > features as part of the solution, so correct me if I'm wrong.
> 
> Qubes OS is based on Xen:
> https://en.wikipedia.org/wiki/Qubes_OS


Yes, and it works great, and has much stronger security metrics than
this could ever reach, and that is quantitative fact, thanks to great
technologies such as VT-d :-)

This is why I'm repeating the requirement for quantitative proof. We
have already great solutions to most what this can do so building
evidence of usefulness is the huge stretch this patch set should
make it.

Nothing personal, but with the current basically just claims, I don't
believe in this. That said, by saying this I don't I'd pick my soccer
no. If there is enough evidence, I'm always ready to turn my opinion
180 degrees.

> 
> >
> > I'm not entirely sure whether this is aimed to be alternative to
> > namespaces/cgroups or vms but more in the direction of Solaris Zones
> > would be imho better alternative at least for containers because
> > it saves the overhead of an extra kernel. There's also a patch set
> > for this:
> >
> > https://lwn.net/Articles/780364/?ref=alian.info
> 
> Solaris Zones also share a single kernel. Or maybe I guess
> you meant Kernel Zones? Isn't it a justification for our multikernel
> approach for Linux? :-)
> 
> BTW, it is less flexible since it completely isolates kernels
> without inter-kernel communication. With our design, you can
> still choose not to use inter-kernel IPI's, which turns dynamic
> into static.
> 
> >
> > VM barrier combined with IOMMU is pretty strong and hardware
> > enforced, and with polished configuration it can be fairly
> > performant (e.g. via page cache bypass and stuff like that)
> > so really the overhead that this is fighting against is
> > context switch overhead.
> >
> > In security I don't believe this has any realistic chances to
> > win over VMs and IOMMU...
> 
> I appreciate you sharing your opinions. I hope my information
> helps.

I'd put strong focus on getting the figures aside with the claims :-)

> 
> Regards,
> Cong Wang

BR, Jarkko

