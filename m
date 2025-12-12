Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16CA0D43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9B46B0005; Thu, 11 Dec 2025 22:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A356B0006; Thu, 11 Dec 2025 22:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FEE6B0007; Thu, 11 Dec 2025 22:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 588136B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:38:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A25489B28
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:38:11 +0000 (UTC)
X-FDA: 84209410782.05.ACA73B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5C01716000D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:38:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaDCkIY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765510689; a=rsa-sha256;
	cv=none;
	b=w0SnKl2aNTOUtyF5PCHdLl27HLg4e3NhJLtSaMP91zjZqPjK2JPiViNvBRnLehUiN0/NHI
	Xnj0NjpVKO0/PYk72dUqJkUWBFRbGm3xyanfuT5f9K7ArE4tNyIkLGdANqCiMRHCVjzViH
	vaVz80ZEavgu4RW2mkhdihaj7tKNI2A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaDCkIY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765510689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMXNHmExEkTend6TmDsTf8yrmBn/mw4W9E3v8Jwq93c=;
	b=tt/eMHgxuKCqrT5mAP/bGRFrFFQ1Sn7rZuO+flqGrHbr1aWzUwv+Ibclem0lLxSnHigMVG
	sdaH7vPU5czW2TNooQOuQZqzdGqIAS9p7HJSEGspRZ3J0VpaPXWz/PQa7si8kfkK6SsZ1x
	eGI4fxJp4HrLuPM9kJuxmoKThlZdBeg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5C676011F;
	Fri, 12 Dec 2025 03:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A88C116B1;
	Fri, 12 Dec 2025 03:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765510688;
	bh=Td11YCdlKUJ7FHmE410jVInO0wKwvj4dwWtCXzArXFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaDCkIY36BXWA8Nrkj85IiL5qnS2jVrpd7Qt+t9Wx3T1pO2IDGgY6jszW08m6Wu23
	 ntPSzRo+9LVDxfy47lmlZeHjMnD6bOPHSebCwBwo+vWAvrbbChlug5eCdKhdBdYm25
	 7YUgzi+5+jQ6ZD0nR+AaXG/4nrT6l6OgVoBNLTmIVcUfcMUGTlXlHrqXhlr8KDosEo
	 VEVOe49x/979Sm8zK/zEQU5YIPXrDDCm40kKJ53/SB3zQA60OR8d6sZtY76ODAI/4h
	 2rRQs0Hd8XDFe410YDc29kzkOcvZ/rnzsec4fGbbKakUILWbpzo8RhGArHSYEpGPPO
	 oDHscKOWdQmRA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [RFC PATCH 0/2] mm/damon: Introduce basic auto-tuning framework with priority support
Date: Thu, 11 Dec 2025 19:38:04 -0800
Message-ID: <20251212033804.40832-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251209145026.3263754-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C01716000D
X-Rspamd-Server: rspam10
X-Stat-Signature: w8ru9ofnpfpdkdsryq4nc6sfmqcxi939
X-HE-Tag: 1765510689-104111
X-HE-Meta: U2FsdGVkX1/mhP3rsYaCwEp/YB2xMkTkVGkkZRqoTfpZPcGuX/HN74NERuz4XLvpte44sijor8r/bw5Q8RfCxogxBPXbL0Ua875JTKlHabnL0ljzxEPioIOdOq6q4DquncfNpNdc4v6G5mJs/E0LL3s29zN/KHrXh9L/cFoF1n5PNe8p5dV2hORsASLW5hEQfRQ7hLVAmjAmapZFFvgUZmqo/LabdMbm4m5WZ7K1EXv/AkZNbcpO39wo3SdHOjft+ByQXbNonX1iTTgjg1SqoBVBZeLOxHwX+sPEMRxxZEsObMHluAPhLHQBy4CyT4B31O8mfHshKfOiBooAX/qPBWQavd7mnQRQQo+d3XsQgakEbNtHOTGD0yBVtP4Dg8NqW/hw1lzD86r4j7+/QKXM7Lpb8rJR9FmHWJT0kFS4PYzeJ1YJAwpXOz7WX39qfqL0Eb8h8ECiNfYNhZ2Kj+Us+YiilykYLEvTSoYsc5u9na6GF8pd4VyjSPUUG4u3nN2twL6esk7O4wv2dm+Ty8I/3G2Z8QCGGgT5WE0X6ed+A1iLw+X2hBmT0aE85OTiO2hesc31TZCpWxar5hW4S/7PVJn1xhllo3/rkCX1gEt7iNhZlzQK9NAza7FtXNPJMax3GJAfYIOgPpx8JYNPI1semQV7XM9emlNO8zUej9DTkGdfnBp31/W26Js3AwA5eNyPuOZvllTaEfQQq4wrPpS+F0lHG39aA+u3u+yUMnKryoNy3HKLbxi8BFV9Lw4rrhJqfwi08Ef863qvRJw4Ju680T7ovU9Zzf+HEwCIIh9FzVxykKM8lLDDs4FA49Eeg6GcUSx3Oa9QoxsuJjDVT51i89gBO4XrMt+he+jgWuNPBqy6JYZ8eyV/Ry/M0dXRa+8COYuiSqO4BXBKM+RJHRTBnTyH1QhMpNHd30n9bO/P9lBcXVKts/2xqpxSKayR70LEn0OgMLFivsi1mgAFSmh
 p+BzIdCz
 hw77z1Y32lNze5i/or7ya+0nA29Q+zHRUvAO2pA8dKd93LdKxAan76SsbnoqD3JmcUU210ub8mNDmNlsrlnRKKqEIreE8iot3mhZAMZqC0hnbpq/qHpysRJlcf/d0KS+VVbkzh0CQHzFSFyWdR3bP8LYf/gjEN9AM4AXBWFhwC2Pp0emoD/q/rSBJRZsW0YbpTcvyxpTTiPPDO5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Dec 2025 22:50:24 +0800 Enze Li <lienze@kylinos.cn> wrote:

Sorry for late response!

> Currently, users need to manually tune multiple parameters (e.g.,
> watermarks, quotas) for different workloads when using DAMON.  This
> increases the barrier to entry and complicates adoption.

I cannot agree this more!

> This patchset
> aims to lower this barrier by introducing a basic auto-tuning
> framework for DAMON, which allows the system to automatically adapt
> DAMON's operational parameters based on user-provided hints and system
> state.
> 
> The core idea is to allow users to assign a simple priority level to
> each monitoring target.  Based on these priorities and the current system
> conditions (initially focusing on free memory), the framework
> dynamically adjusts DAMON's parameters.  The initial implementation
> focuses on the automatic management of watermarks.

How difficult watermarks tuning is?  Do you have some real use case or
realistic benchmarks showing it?  Could you please share that?

> 
> While the auto-tuning functionality could be implemented in user space
> as a separate daemon, integrating it directly into the DAMON kernel
> subsystem offers distinct advantages essential for a memory management
> automation feature.  First, it delivers superior performance and
> real-time responsiveness by executing tuning logic within the monitoring
> thread (kdamond) context, eliminating the latency and overhead of
> frequent kernel-user space context switches and system calls.  This
> ensures parameter adjustments can keep pace with DAMON's monitoring
> cycles.  Second, it provides inherent reliability as the tuning logic
> becomes an integral part of the DAMON context, immune to failures of any
> user-space process (e.g., termination by the OOM killer) and requiring
> no additional service management.  Finally, it offers a simplified,
> out-of-the-box experience where users enable auto-tuning through a
> single configuration without needing to install, maintain, or ensure
> version compatibility of an external tool.  This kernel-based approach
> aligns with the goal of creating a robust, low-overhead, and truly
> self-adaptive memory management subsystem.

I agree your points.  In-kernel auto-tuning is much more efficient and simple
to use, compared to user-space based ones.  Nonetheless, the disadvantage of
in-kernel auto-tuning is it increases the maintenace burden.  I'd like to add
lengthy change only if it shows clear benefit.

From this cover letter, I show only "potential" future benefits that might not
land on the real world.  Do you have some real use case or realistic benchmarks
showing the benefit you explained above?  If so, could you please share those?


Thanks,
SJ

[...]

