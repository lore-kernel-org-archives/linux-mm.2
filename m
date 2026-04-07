Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E6CFF5107
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD226B00B2; Tue,  7 Apr 2026 11:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD996B00B3; Tue,  7 Apr 2026 11:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3F86B00B4; Tue,  7 Apr 2026 11:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A97E6B00B2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:23:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 914C313BB35
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:23:38 +0000 (UTC)
X-FDA: 84632129316.18.A447BCD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6F2040009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:23:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aefdV1zd;
	spf=pass (imf11.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775575416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKBx6bVmWC7VSTX/T2tSGTL9Yi85hovB3fKir/sRBS8=;
	b=K2LLzGPI4wQU6WAMyqypRqwxNShoZD4KSCUbzzIHsMv93yRCXvYOODJoEN/1hEgFi3iC+t
	gWtbXE8Qz1J4plaIjQO/TXfVEm45J9c5j/7EiS9EdYxakLOJb+xRW4w19w4+kf15SSHLSm
	etB+qFnxD80A1yxoA3oxZ37XGYY+uU4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aefdV1zd;
	spf=pass (imf11.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775575416; a=rsa-sha256;
	cv=none;
	b=XzWSgX3sINFW2BJA+Whwk4SXNHl2cXY7HdsZtDlLZrQ/kOTjf6CSPAqogQkfBl5auqfG9a
	4DI1T0pd0HtDprGveAXTOXdM8ee0ai4tygC3bXHo5KMEhnsUwXebrNUKRauRP3G1FQPI1b
	lImDdp13clLBCYLtpbIVAQGpAtbTGpw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C09181BB2;
	Tue,  7 Apr 2026 08:23:29 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3BC63F7D8;
	Tue,  7 Apr 2026 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775575415; bh=S0KhfM4isL6DUfK/OM+IpENXf/XOYoUfgu5TX4otGBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aefdV1zd4eTc7MvgGtSzxJ6u6nyn6CMFJ8DD0XRkLGfrY33iY2FOoNFww6iazNtBn
	 wAhikLlDca2j5pDfe4SJfzH1oEwvG3WfHMJS7FKe4QHJTXCAI4y0AQpcswcWdV1YHG
	 NydN8l/eOnj3UHguIO+FYOOEcR/l3ipZzrQCTm5g=
Date: Tue, 7 Apr 2026 16:23:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrei Vagin <avagin@google.com>
Cc: Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>,
	Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
Message-ID: <adUhbk0sKT0ucWhJ@J2N7QTR9R3>
References: <20260323175340.3361311-1-avagin@google.com>
 <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com>
 <acJnOB-rlyt-3jU4@willie-the-truck>
 <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
 <acarA3sGKY4Acozw@J2N7QTR9R3.cambridge.arm.com>
 <CAEWA0a7AZiuy1F+0LDxtEtJpdu=zA-RKhPb1wcDMpy2tSMFO5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEWA0a7AZiuy1F+0LDxtEtJpdu=zA-RKhPb1wcDMpy2tSMFO5g@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6F2040009
X-Stat-Signature: 95ywcokf8ye9hf348tsq638jmh343tyn
X-Rspam-User: 
X-HE-Tag: 1775575416-142661
X-HE-Meta: U2FsdGVkX1/z763iRsRFPY67BoHO2Qh0GPOOyW1QM5PFk2DHv+BIiNrQQa1Z8sO+Rmwp/jmhwSUJQpLhy1XlUzOkncOnOvGMmsw/xy9DYsTOoZ9aPQbVukxIKcpq2BPOdNy3Iv24DM7E1lz5x/2xzXCiAN5kZfabO4du/aU2qHQIKED5to927Ou5vvS1ECaOxWSk6EU0ThLrn1e7zekzQxg1ASznCnchMqaLqFptNA1OxBFidYqvVqxNl60VK4ryg1DDhVgAfCECgvCofv0rqPNGED/xo02SE0HNVdJNBV240Bd1HfhH1trSZTf6dwcRe0BD67yw5+IbbSL2syFt73qGBbn3XsU9MIoS+s31egf9MSoCA/wbHI57Y72KIQ14jUfDYaj5seTwZyOMZK7tWZ5YrozYEC3pUBVL1gtKMq99VaV+dycmOpE/2omsgwuTA5JXP7NLA80TKV3KsURcKnrd42NOV1Rk+AqPF/HdhQt2jwSZaLJDB2waIzX8ptvrWcGdOseZ7PjNUw+KTsZ670Ab3QJd8U3vMXVggUNG088aSo5UvOPwNHzsuLb2GDekyOCfss1piB96qJWevMVxzjuCJH0WaIYWL9NZ8Aot9vGoC85UmpZXbMMBKXUcJSww5eITzuaW6+c9OtrfhgY0lKHwVdm/9/SwW/UVtX7Iba8w4aeHVbhjTgDlxJ6odjjC6D8SQo3phVt2Q1m0dpWAnb3Kc+bxqTUrK37s6bSh6gA8nJDhGKnZfKoSk16pRhWU/EsrP5k3htcuRimj+L10z5wrqbbHV9zNIe/AIFHI0I7CHq4Gkv0LtYypI3n2LXe7aQWQ6MJz+tOI0zw6TIsL1j+D/8GZBWK3405wzNqG6GiFWuA0KS9jzlw2CLYm7uSovEor25Nf2j5/KzlbFPxH000A0EoIe+6OoUb1RRagO+RBV2jlMSuTtdBhyCyxtuhZ3n2f8Q0aptq9MPKa1rD
 +YKkvaAG
 ihnn+P0hAmE0+syaMo9Qji4WSu5lmlQXgIfFCB8fsNhS+Vro6sPii0YCY5J/kG3UeJ9cZprLx+1T1XfOlbtngLqr6XpVrcAKPd4kp5hGT+CMUlWitK0RNcqZBniL6snM8ZAyYlQF6n5Pqju+FUBBw1lZbfmUCWrKWF0MDi5CgbUmZ9CC1uFNDfvU12jsp/wRGXgay5xt6mXs+hztDqnuMhnaOdo4hNHlJBLnW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 05:21:26PM -0700, Andrei Vagin wrote:
> Hi Mark,
> 
> I understand all these points and they are valid. However, as I
> mentioned, we are not trying to introduce a mechanism that will strictly
> enforce feature sets for every container. While we would like to have
> that functionality, as you and will mentioned, it would require
> substantially more complexity to address, and maintainers would unlikely
> to pick up that complexity. 

The crux of my complaint here is that unless you do that (to some
degree), this is not going to work reliably, even with the constraints
you outline.

Further, I disagree with your proposed solution of pushing more
constraints onto userspace (to also consider HWCAPs as overriding other
mechainsms, etc).

I think that as-is, the approach is flawed.

> Even masking ID registers on a per-container basis would introduce
> extra complexity that could make architecture maintainers unhappy.
> There were a few attempts to introduce container CPUID masking on
> x86_64 in the past.

> In CRIU, we are not aiming to handle every possible workload. Our goal
> is to target workloads where developers are ready to cooperate and
> willing to make adjustments to be C/R compatible. The goal here is to
> provide developers with clear instructions on what they can do to ensure
> their applications are C/R compatible. When I say "workloads", I mean
> this in a broad sense. A container might pack a set of tools with
> different runtimes (Go, Java, libc-based). All these runtimes should
> detect only allowed features.

I do not think that arbitrary applications (and libraries!) should have
to pick up additional constraints that are unnecessary without CRIU,
especially where that goes against deliberate design decisions (e.g.
features in arm64's HINT instruction space, which are designed to be
usable in fast paths WITHOUT needing explicit checks of things like
HWCAPs). Note that those typically *do* have kernel controls.

I think there's a much larger problem space than you anticipate, and
adding an incomplete solution now is just going to introduce a
maintenance burden.

> Returning to the subject of this patchset: this series extends the role
> of hwcaps. With this change, we would establish that hwcaps is the
> "source of truth" for which features an application can safely use. Any
> other features available on the current CPU would not be guaranteed to
> remain available after migration to another machine.
> 
> After this discussion, I found that the current version missed one major
> thing: there should be a signal indicating that hwcaps must be used for
> feature detection. Since we will need to integrate this interface into
> libc, Go, and other runtimes, they definitely should not rely just on
> hwcaps by default, especially in the early stages. This can be solved
> via the prctl command.  Libraries like libc would call
> prctl(PR_USER_HWCAP_ENABLED). If this returns true, the runtime knows
> that only the features explicitly listed in hwcaps should be used.

I do not think we should be pushing that shape of constraint onto
userspace.

> You are right, the controlled feature set will be limited to features
> the kernel knows about. And yes, we would need to report CPU features in
> hwcaps even if the kernel isn't directly involved in handling them.

To be clear, that is not what I am arguing.

As I mentioned before, the way this works on arm64 is that the kernel
only exposes what it is aware of, even in the ID regs accessible to
userspace. We usually *can* hide features, and do that for cases of
mismatched big.LITTLE, virtual machines, etc.

> Honestly, I am not certain if this is the "right" interface for that,
> and I would be happy to consider other ideas. I understand that these
> hwcaps will not work right out of the box, but we need a way to solve
> this problem. Having a centralized API for CPU/kernel feature detection
> seems like the right direction.

I think that for better or worse the approach you are tkaing here simply
does not solve enough of the problem to actually be worthwhile.

> As for signal frame size and extended states like SVE/SME, we aware
> about this problem.  However, it is partly mitigated by the fact that if
> an application does not use some features, those states are not placed
> in the signal frame.

That is not true. The kernel can and will create signal frames for
architectural state that a task might never have touched.

Generally arm64 creates signal frames for features when the feature
*exists*, regardless of whether the task has actively manipulated the
relevant state. For example, on systems with SVE a trivial SVE signal
frame gets created even if a task only uses the FPSIMD registers, and on
systms with SME a TPIDR2 signal frame gets created even if the task has
never read/written TPIDR2.

When restoring, an unrecognised signal frame is treated as invalid, and
we can require that certain signal frames are present.

> In the future, when we construct/reload a signal frame, we could look
> at a process feature set for a process and generate a frame according
> to those features...

When you say 'we' here, are you talking about within the kernel, or
within the userspace C/R mechanism?

Mark.

