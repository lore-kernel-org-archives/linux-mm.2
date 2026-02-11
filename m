Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9C6ECD6F7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C076B0005; Wed, 11 Feb 2026 18:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409896B0089; Wed, 11 Feb 2026 18:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339F16B008A; Wed, 11 Feb 2026 18:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 205F16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:29:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8634C1D66
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:29:53 +0000 (UTC)
X-FDA: 84433770666.24.575B3D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A068140006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:29:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFHQAkTL;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770852592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdkAyqOxQzeiR6MxWaLzGE+euNpsbW7kx9JKwmXauEI=;
	b=wwqiioaGWwMLMj9vkmRSG3Lf91cvpy8jqgiNKG23nCb5Oafq5rmtz3PjiXy8SJ7fmChSg+
	eD0LDdddifBOJfMxb/O62Vl4xypi4nDkMKMnxEsoK/nXsgP6avuGHiYCsQe4bL/klc6Qxi
	DONLS6SKL3lHWsYKFfbyqJRoG3UFzVU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFHQAkTL;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770852592; a=rsa-sha256;
	cv=none;
	b=rH2yfgXaJhSZcZvcFiMSx5++jzf9T/LZbSF7czM+02EyL58EyGnCrrUtw42E8/jeFeppKn
	lf4KR7odet12m2228JMwUs7TMw6lkZ7uSMTeeeig3K+RflFTI3NBP3aycl6wwYMI0nxMzz
	0+cZmVEsSKn0N5Y6cS9A7o4AvoMmBD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A06560010;
	Wed, 11 Feb 2026 23:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC73C4CEF7;
	Wed, 11 Feb 2026 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770852591;
	bh=EFGDBChHSWhZIzXFNT6SF4SbDuFM7V8Yj3FQO96fPYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kFHQAkTL6mZ7e1gCkxJJhlIPS3A8+QHxbdi+oq9pi1psvQS2i9K5j17+D8/8R1Cp3
	 05lv83nUterCehqd5tJX//yLKumKuBUzMlBykeco/EQAbGV/9KmoZFPdK9HMsXbyPg
	 mx6fxgjGFQ+ua9ySeEpHoeaJGUuWm8KIzuVeIoEDwQIannCpni9nVDSMh5KvRdALnk
	 AuxjD5ShSEJwAtwbqRzPKswPxyqxlC7KvBjTzCaa33Z+yGcdKwgi02o/dlcwMTkuBc
	 0Akt9VQP0kEsm25IUX4mX/Nv6+Vl86qfxjzonS8oe78z8gy1vI3EMWkcZayCmtIQEL
	 E6FVrOg10ZhdQ==
Date: Wed, 11 Feb 2026 13:29:49 -1000
From: Tejun Heo <tj@kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
	urezki@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: yia1aqpc5do31wcpctpkeytqkbspy7gs
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A068140006
X-HE-Tag: 1770852591-236042
X-HE-Meta: U2FsdGVkX18tvzwJbEs/NPE6jm7JFT1rvoi9jk7FDrEHB6F2szAHH2FgK5qY8J0w9FcgI9BW17oAgHPz+Rr/kIZ1d2QsgcIz6gvTfYyu7NQOA4jb1mb52GQpZlFBeOTHqlgr1X8roQRQ7cGcTYJdS9QLpRsLLyUSmCmK4VafbjzQ4Wm99m7+3cE9yRJSqb0JtagZUuZutjb3++JN41i4UVE2pLEuAjBH+9+kDGCy6FcbTd1/0IwC5ote6LPWagiA1YEcOuRDHeorBlEORYZ75SBL8vz3v+kF+As34UwJGyhvDZZrX5eeOe838gd1rJG42WjogpWP4LQUxjWNPGhfuB3LWKOVGoDos9Jh34akIFBmdStGBx7Lk4eF15MnltoMVNB8VrB3Ds7w8d11AmKGvvl2naxeKp+hcjoGvbPImyO6DqELJRTKLXo3UqxxPzH+Qw4jmrSlmP8+uZjojfZkAbodLKjFf34s2GoHsBZ67ofoTi2ZthrJZQ3GpAs7H4ATdWRtncavaMWeYFGhpdV1AR6Cp8wXC6MfVHm+YvRaQVtuECb4v57oaKHH/aGMkHzmziINE10FMlqGZHFLATcar/23NNF6Bas0D3oArApZd33CNiPiG8xYIpVU51DwS/nxOaa1E94NPI17n59qJug9zKPscRy0CLATOe6gY1tDfYs17G+Oo/SOzV4JHWQTmJqmBhSGzx/Y+a4Yj9ULd5nr0OIwIjuOCFgPJzNZz0M81oEnnY9qYhDgiRe5uVbFPhcenBbHB1j4wlX5eFnhVpj5L+1xQAH25QKbAbecvG9CKzf6DZMxQzRCDGfBgE8nM3oqNBPInABIoPffchCPDPKNlFT+AALJg7RuEk3iYHwu0wmIW/1M+e7ji8rHyzo6fHqMBFwZkPOWkSaEZQJosIEjn3xjJvA0L3ZGPq+fZbVhVMJzzYGCN2Xk2xnDmsCMCgtRQPa5lf4mNE+qCL68YCZ
 +KK98YW/
 P03lZ5S1BwBdNHxXKvt3ZxBDmyRbfacSuxDiYI/wK2x9IpLXAiL2tGNqcZjO79WLTWPTlQVJ1n/fHWeA4BnhzKPh1GqHQgw1B/T/U2oo0Z2z/QMDgGis0uZlTy2dS6z5g0suBTaBQGQqm2RW5ulKODRVH9AHV/XdiD6GxRM2kLdrqQ+MK/tPVAbYRTV48E2y5EkXSU81sPjTcNo4Iz5NEKjrekngzyKxujIctdmPjPK8mnsJQu2b0pIWz5KKVVvdOZ6dA4QN6UOP+7XMJytxi2j3bl7DlfW784epP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
...
> Overhead
> ========
> 1. Some extra virtual memory space. But it shouldn’t be too much. I
> saw 960K with Fedora default kernel config. Given terabytes virtual
> memory space on 64 bit machine, 960K is negligible.
> 2. Some extra physical memory for percpu kernel page table. 4K *
> (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
> mapping area. A couple of megabytes with Fedora default kernel config
> on AmpereOne with 160 cores.
> 3. Percpu allocation and free will be slower due to extra virtual
> memory allocation and page table manipulation. However, percpu is
> allocated by chunk. One chunk typically holds a lot percpu variables.
> So the slowdown should be negligible. The test result below also
> proved it.

It will also add a bit of TLB pressure as a lot of percpu allocations are
currently embedded in the linear address space backed by large page
mappings. Likely immaterial compared to the reduced overhead of
this_cpu_*().

One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
uses that outside preempt disable block (which is a bit odd but allowed),
the end result would be surprising. Hmm... I wonder whether it'd be
worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
access global offset from local mapping and then return the computed global
address. This should still be pretty cheap and gets rid of surprising and
potentially extremely subtle corner cases.

Generally sounds like a great solution for !x86.

Thanks.

-- 
tejun

