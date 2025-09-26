Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02215CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593B98E0007; Fri, 26 Sep 2025 05:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B958E0001; Fri, 26 Sep 2025 05:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA158E0007; Fri, 26 Sep 2025 05:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38FAC8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:01:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E95C813B7A8
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:01:06 +0000 (UTC)
X-FDA: 83930806932.10.0542038
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A00240017
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:01:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYXlLIdd;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758877265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gAmHQm9uWAyxumfLUr6FGzFWyjSxL56uS3VHpLy/kU=;
	b=GQHI7Sgz7tqfJE6n1rJBgmtMk7m4c6q9k2J5KqydGTXHsgZx5Zl7cyf+4/x8KY4G1qaP1n
	0CsvEu8DRGoC39AShUkgKNGsD3i82ZRP1Si6qQRCrvcaAPaTmxNlYi0cn+yugeZGMeLoKk
	l3ivCG4Fe+xZr8hdmoS51D2DOpXwCsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758877265; a=rsa-sha256;
	cv=none;
	b=gs8kIWE3IuaPaA653x0dXOhBN0S2mCE6DXUmSCn7v44Oo4sZxHMGC1EDmJa2ozAtDrP4bH
	mSi7ORMClDGQ3F33VUE0AXT6Rv2fp3yQapfhtTh4BgKcyvl18zzf68hVpNPHMq4PN5EcJp
	972wiyv999xcvByND8dNMN/RBZFL5xE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYXlLIdd;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F4A61C5D;
	Fri, 26 Sep 2025 09:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D609C4CEF7;
	Fri, 26 Sep 2025 09:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758877264;
	bh=aoHwYNOokXAGRoK1jVhoOEMXZxjxQdbdW4MEf+flVRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PYXlLIddG5o643w4XSILB/DoVovDl52dYTyTwheDRkfqFKsWIjSGiO1YNg/QQF2DF
	 Yy3+XfHgVG7ufU9kDESkrPZtZ6d/r8e83/Aj5zIqDus2HtsWqRFwB9E0CxVP8MKee2
	 59c7jKvWqAeGCPutnOJk6ZvBchzEXqTLA3H+kihwDIrfq00kEMsqu6qC+xkBL2o175
	 kBmYzKALzV+ZE6VrCqMcG2Lv1rU3A3JU+Yacg3ihF6q+O2+LyoeI2zBr1XyYSxfrQb
	 O5V93ifpDrkxRLTFW/Zx4by2jpfsBs5VFWTN2ctdyNRWtKWc+c7oNeRitDnaHZehYI
	 3YYdR/mFK1Ayw==
Date: Fri, 26 Sep 2025 12:01:00 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <aNZWTB_AbK1qtacy@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
X-Rspamd-Queue-Id: 4A00240017
X-Stat-Signature: 3p593xt16zyjmtzbuzqc7ui7k8ys99j1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758877265-702115
X-HE-Meta: U2FsdGVkX18W/suvd9NkjO75xG8I+qEdGMNuNR/ebRQVx2crUp+Ft1gIlYJ6Pcc2aZXeNZAwIIWkCk0wZYyK+/SMs+HGJh82tMvHCvNq2GVoyl6hu17bbxvP7cziyP/AFnSbOrgd67/Z8+MO+BAYVqcPpu9kmnHLe0fXjWUYwjlQtC3ZHzt3a4Mw0Gs9PrPiNARHPmHFeMcgqAtAhF/LD9SQ7jPd5gG5fkFu5LI7vtejdAGYr+NC5aNxaDMIRkRarlR4hRIr+ytEi7Hj265vU58VQJtWWmumj6W+sJt7DJSXpUTq1yiV1e1TR3qeAsT+lkJ5SNKWGVvGt7RAvM97IRH2kven8yVDCt/vobj552k6g/7fIb5uc0GOCOYrqjktYH2VqajKCyYQJef6WvSbPDgNpWzwDTt1baZmN2f/z3bDKOLPO3g9f+CdAVnHFkPosybnK7JYJO+JuuuXg9w+8PyjcJRL01OzQKQO0wZ/wMTXhMNJBeQfcTSbpAzWzXv9nTU6UMIBjmG4GYjHazMpdKVjkN7sCuATya2EmFtHhj9GPfghIta4HQ3q8dnB0eE8k1Gubl210XHhE7YDLCFWsxgQpwEVffdeEfwEvP1y528cx1xS2UVP9wa+YaNSe2biPP6mUuZkWs/GKuFUFTKNm3KkbkQjhZiSJvh17e8ksVvZDqgZWXk8zbc3nq/Ny3OUElHUAzH9K/vvu9jVGp2dB2gx8MMOJPeaRW78+l7O+iZWiVMJGgUjsI8ibDcM82I400/2KNV8mwESxBgLg7RtAKxsIttt/f9E2Z1HOQXsYXfbgOw7torOV/cR50WncxR3F/ztk6m8Mqun4qAtlpLIZJABHX4AFusNqBrpCNlwJgZlTwMeeCZvmw51DqpYiFb5bR4QogyGSX0VjrnUCfsWoJ1ZGlDrnCjOcpZXOIQG3V5qHWUnfv6ienH2LiuETVraXpiu9OZvU2J/R9LZNfo
 7aT9Rd8D
 k+CYjOcMOnv88z/5N/Nc1YUU78Y89jjdul7aBpVS6rGLq2fRjOzUd/0BEk1rFxrR+2ZJA2YiBtsjAhFSyleO9Iowq/dknKCh9x8QR1bFJg+B44i1OIkQvXO70xv1PFMw+C+DAdK+tmnonlHn7FhyeGzPgDldlE9lAGGMjszI+EUDuxaDvt4SCAxTVZXMQ1282YgcxC7/SZoEyYdidO5AJ3u7b/fPuijDn7ejqCJpACzQ97H2z/sQ3GpXyV5d631/5iijDbY0G4pwv7WEzxWKya217zvNbKhpkt2fbnpcVtxAvX/rCd6CbaFxLuT7p/0JB/3WMIFlFq2tBGJPvIoX106uhSDgnVhfjGYaQsN8Dw6s72iQeAJkvH4C5+6W21J9qgNMUs3q8/uffJrGqwOdGk475G2vouWyQg5bsvezjv5tGzXh1Nf+qKR6XM6Ez6bwPfL8JpiMCrRhCJ10wGdJHcMdITQU1BJnZ6NA5V5M45nNdfxjlpUT/kYTqOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> This patch series introduces multikernel architecture support, enabling
> multiple independent kernel instances to coexist and communicate on a
> single physical machine. Each kernel instance can run on dedicated CPU
> cores while sharing the underlying hardware resources.
> 
> The multikernel architecture provides several key benefits:
> - Improved fault isolation between different workloads
> - Enhanced security through kernel-level separation
> - Better resource utilization than traditional VM (KVM, Xen etc.)
> - Potential zero-down kernel update with KHO (Kernel Hand Over)

This list is like asking AI to list benefits, or like the whole cover
letter has that type of feel.

I'd probably work on benchmarks and other types of tests that can
deliver comparative figures, and show data that addresses workloads
with KVM, namespaces/cgroups and this, reflecting these qualities.

E.g. consider "Enhanced security through kernel-level separation".
It's a pre-existing feature probably since dawn of time. Any new layer
makes obviously more complex version "kernel-level separation". You'd
had to prove that this even more complex version is more secure than
pre-existing science.

kexec and its various corner cases and how this patch set addresses
them is the part where I'm most lost.

If I look at one of multikernel distros (I don't know any other
tbh) that I know it's really VT-d and that type of hardware
enforcement that make Qubes shine:

https://www.qubes-os.org/

That said, I did not look how/if this is using CPU virtualization
features as part of the solution, so correct me if I'm wrong.

I'm not entirely sure whether this is aimed to be alternative to
namespaces/cgroups or vms but more in the direction of Solaris Zones
would be imho better alternative at least for containers because
it saves the overhead of an extra kernel. There's also a patch set
for this:

https://lwn.net/Articles/780364/?ref=alian.info

VM barrier combined with IOMMU is pretty strong and hardware
enforced, and with polished configuration it can be fairly
performant (e.g. via page cache bypass and stuff like that)
so really the overhead that this is fighting against is 
context switch overhead.

In security I don't believe this has any realistic chances to
win over VMs and IOMMU...

BR, Jarkko

