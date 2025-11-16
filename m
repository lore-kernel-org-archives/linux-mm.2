Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56052CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 19:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A1E8E0035; Sun, 16 Nov 2025 14:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9948E0002; Sun, 16 Nov 2025 14:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C128E0035; Sun, 16 Nov 2025 14:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEB128E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 14:16:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DFFA5C3FB
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 19:16:34 +0000 (UTC)
X-FDA: 84117426708.28.11A0EF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5150160009
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 19:16:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuRRXeF9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763320592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+mIoQ12tJrIQZV5hmncpyJRaJokyeccbRR3FEAdZPg=;
	b=C7LpAln6OXFCdJb/Ls+rVoCZEEGtkmYzvNTGkFi4peMeWuEoY0zabeX0kAIw1P/d2YfH5i
	0uMdHgCwi8V273Fksw9EZNCBzpJ8RlaDtgAW2n6WGKcmArOvUBuPe14zdaxHk3DmEhaaNn
	8YK90jCDl80mB88mMYyNjjwipfgq0EM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763320592; a=rsa-sha256;
	cv=none;
	b=sp1hEoZDAN/yH2a5Hvk/irOgcNt6z27J7VsyuGd852aVrhN98hP6g1SrHQO/apJ6qhDt1t
	7Fiu5mSCPIma5Qp80qQohZ1uvyfsqD53HOLXy5OAFJT9mRWRzkPkkIM/F8ZOuPGI8rY8rO
	dC1WFmocE+EB7D2zeSgwId5te0/4dec=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuRRXeF9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBC304383F;
	Sun, 16 Nov 2025 19:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2A5C4CEF1;
	Sun, 16 Nov 2025 19:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763320591;
	bh=2AWiSTOjjCImKxID+jJqasB/YHLkwC84gjIC/il/6NI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cuRRXeF904tsvw3xJPns3FlZX+NotASwA1V6gZiqZ2bHO+P8u/xsR51KVjXrZJXqP
	 G7bib6qzdztDPLbkPoasGFTg3O4dua/5tQpc4gWVf1wk6p/OmAi9ifT0WNIUUR5bNf
	 2XX7A/8rtYbxfMu/72wq/3g9PIyusYihlSkZntAhXSDyHz1Ee/gC7odyz2qWMLnVE1
	 t9LO5wu9HVY5aqHtvmRSF10unM22VnrNZdbUvRcdH5lcjWI1LtLiXUX+Iu4Owu3jAg
	 kS5h/KkX1VqvtSmX9Xh6KckCByA07I3oqKnB/cewzRMOd1oEtoTfr70o2ZwcsGuYAW
	 QDEvmdptTN+OA==
Date: Sun, 16 Nov 2025 21:16:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <aRoi-Pb8jnjaZp0X@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
 <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
X-Stat-Signature: e4319rbbj6xypwjps6qaiix73ihnwzu9
X-Rspam-User: 
X-Rspamd-Queue-Id: B5150160009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763320592-69311
X-HE-Meta: U2FsdGVkX1/fIyi1h852C2zhj4i94dKlpWH+ipQO93p9e7L1HsFxKymJPTLxUYvi645lHA99VEuS+x4I5mSW3S36DruLWFZJ1NWWan18oJ1ohG4a7Xnz8Hj/6QFIuQjxsqM8ZjY53zDCk8udgcupCrvb0m0u+j7tsxJGzz9Cq1B6jxif8cpuwpStNAzl3pq/CgrwnQ7IzdfvTO8+m7J1RuRMG8DU2KZS3osPld/RXJTRMcU8m8Y4wrbD7OKVZw60lfEAc90ZIGpyjaPheqro5Mh6KAlFJbwejBMAMPtMX7eq9M7jSi35ncafElsnCU4DcgXzrS+LuI1Imry0F0d37BJzDmDV9eyXXJQrjBpmEi7UhUXcEpuRzLRHxe7Nug7yFqr51H4ZM9Za3DLHJF4YEtRtEGShsddgiIsvITs0FBo2hQMIR0NkNTFpv0My/P9RtBBfocGqyx7qg91oRjIaI+5O1JxEFrqo2BsnFhOgpDEi5x5X7yQox+vnMiICoJiUQx0IjQo11uAqwCSIVi4GtlQjK+Du/GSFrgiDm1b5vFuqod4hNrKZRo2BpBrOY2L69wwMT4USYUjgk3w/lSSPvy+S4wYMZzarRCnQSSEv3y6KPv0smTzN3lFqpwTMVqhCgH+qawoW52tGV/p/tkopAYUbQiL9pBrCVrzM4/WtS6IDvJFXc4nmkg15vtV/og/PZsXBqgrfBu7f0CW4LBRoHwiHnCIC8A13Tp2t+sw1t2vdFTIcv/pxjetYcazq0u9DqaqklGHplJ1vhbqToX7uX+QmejXB/y9FXnjw6BNihxnapjUKczlqPlx40s2J7TdZz0k2WvTX7glYzN48+KAoxXIcIYv47dfQDhLLOQ+6jcdWteNavd6A7k4hHlNd+f6cR0D0y0Ix76ZU3mH9nJsqTgrRZ2Nd1xoOnq/q3kuuCHTVS70mwMNWbr2h2EPEnNmyt/FQJLajnHuVmRuCj5z
 RWd6mPs1
 R5vvLJHW/20i8E4QytPJYEJ1s/c6ADp+Zvl6s1zxFsmV27iGIYQy8kbr7WyaNKjfW1Je1/jhA8uZcAS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 09:55:30AM -0500, Pasha Tatashin wrote:
> On Sun, Nov 16, 2025 at 7:43 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > +static int __init liveupdate_early_init(void)
> > > +{
> > > +     int err;
> > > +
> > > +     err = luo_early_startup();
> > > +     if (err) {
> > > +             pr_err("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> > > +                    ERR_PTR(err));
> >
> > How do we report this to the userspace?
> > I think the decision what to do in this case belongs there. Even if it's
> > down to choosing between plain kexec and full reboot, it's still a policy
> > that should be implemented in userspace.
> 
> I agree that policy belongs in userspace, and that is how we designed
> it. In this specific failure case (ABI mismatch or corrupt FDT), the
> preserved state is unrecoverable by the kernel. We cannot parse the
> incoming data, so we cannot offer it to userspace.
> 
> We report this state by not registering the /dev/liveupdate device.
> When the userspace agent attempts to initialize, it receives ENOENT.
> At that point, the agent exercises its policy:
> 
> - Check dmesg for the specific error and report the failure to the
> fleet control plane.

Hmm, this is not nice. I think we still should register /dev/liveupdate and
let userspace discover this error via /dev/liveupdate ABIs.

> - Trigger a fresh (kexec or cold) reboot to reset unreclaimable resources.
> 
> Pasha
> 

-- 
Sincerely yours,
Mike.

