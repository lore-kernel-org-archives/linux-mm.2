Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40152C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057916B0088; Fri, 10 Jul 2026 10:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007676B008A; Fri, 10 Jul 2026 10:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61FE6B008C; Fri, 10 Jul 2026 10:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD1936B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:16:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43EED1C869B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:16:40 +0000 (UTC)
X-FDA: 84973067760.07.0FF5A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 920D980011
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:16:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Mp0sLUNW;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783692998;
	b=5otTS4sRYKtJV7wFtuV+itpyumMOP6D7j//uiE2zLEFfgaaXn/frjxfRI46SNiUu5/H8J7
	c6YbEeqoxI7EPSptzTLgEjAYRI1XDLKrf01eIng1C8XwrKE/o+BgCGj4jpZtrwS67J/nJP
	93ik3U7MjkBo5jQEN5fBR9sapWJ42II=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Mp0sLUNW;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783692998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBlFK0541y0Zc/79OGH2Qmor8SYhSUoS64EeY6OiQnk=;
	b=dHZY71NpwiISTbM8ZgmN1BjAxvwBB730Fw9XvWMdcGCJDqKvahePvIlsUsi7YhPnFeHp+N
	TztImKTKZGs3tZ3BUL2Bqx99/mI9niW8/gSAd3jqLG7zlkY7mHtOXYwa8E3F5mdylVbafs
	/WvjGc+Z1SsPGdC2/UQ7IyykrI/xNJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1124260051;
	Fri, 10 Jul 2026 14:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7B01F000E9;
	Fri, 10 Jul 2026 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783692997;
	bh=wBlFK0541y0Zc/79OGH2Qmor8SYhSUoS64EeY6OiQnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mp0sLUNWJUriS9GasCZYYGX9cDD2E6Htf1I4L5b2Z4r8o9oI+vFCeiwYxQo09so1z
	 mMLhynXQApdClVn5iNc5Kxn1uAwMdzFja3z/Dar0ICAVsOdBNk+tW90D41MVHpQMzy
	 3Pj05EsVxckLT+UrHNlXw7+G5YWMtWCTUC7I+SLo=
Date: Fri, 10 Jul 2026 16:16:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavol Sakac <sakacpav@amazon.de>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, linux-mm@kvack.org,
	kexec@lists.infradead.org, nh-open-source@amazon.com
Subject: Re: [RFC PATCH 00/14] driver core: defer per-VF sysfs creation for
 fast SR-IOV bring-up
Message-ID: <2026071004-strum-perkiness-5d9b@gregkh>
References: <20260702174033.32116-1-sakacpav@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702174033.32116-1-sakacpav@amazon.de>
X-Rspamd-Queue-Id: 920D980011
X-Rspam-User: 
X-Stat-Signature: coyuf5n5hyahyw45d4deygi5syuaiwmw
X-Rspamd-Server: rspam03
X-HE-Tag: 1783692998-899606
X-HE-Meta: U2FsdGVkX1+zBZtZb5atDw3tVixFTtr98zhNVVoSFAuohpEDQU2xV7SJ06mHWOCRlHJN6p71oUNhUrITbo5JtIJVwpDQK5AATFRFbj2jiKZTQgas6fPpOi+a88qXUAey51+fh2nxJbjYUlYg089Vwka4AqKnEJrDfwAjxeLOEmGChu3Bw7j7Sxx5iuAXoa5I2UyGQiZ4y4txhD9aIU198m4ra7COvGtzv8S2EMvKmgwg65YoPLXB9SLCFvGjSsVQtStdf3MJ12eQRYtmCUOsQkLhYIcGblA2N1L/EmGinmT8Tz9oGJy7YfUKAcOlE40EZSyj7tRQM24buQhZKDIJj6F2VUV22xfW/aC2HnVQP5AfKHMzkiDqss5joDnEAxisAIsFTYkK3IzXffcBMVZ8mIqL+LkdV95oWmsMMquuyyhRepOlbGTZ7j1VaD01Wues5n/BXY7FRtBCwikFIUobnqRiXaUCRumJuz7KuU/NxmT47rTE09kAg2PrN7xlmp5ixi/YLdD2LlQuhn2BSICyDNlVgXYH+YjngSaoNkfsIjl0XgSw8TcyuBevoPQVwYn8dbxEmcWUkjUbrDmqzb+3qkrLLHlhiZhACEchLF3qmFHT2C12q1rC/mQ1wUyyLpRNCUhZx6XceDaGDvnbEX1LbDpKqlkXOKzGkfoaPA4enw8qClBk/exD/E8PZflD5HgjWBYLtyg5W51w4fLkv53MbHgwvYFf+l0fAlUqH8bteJV6z6oZ92UpcUgd5cNXmLb+fLxsTHfUx7cfq6CKTkcDP1SH3Y36hCzZn1R56RIpZfAUMrHGKrYxNXqXchOXI+kuR50Yw4ogEle2046rnNw7KgSM9wjUFTORuZUHErJAP1Wt0Rc4epp1lXGocGBIBn8fZaExYmRU45zTILZBvpeUKp5ExgHRKlqQPXLomTPTA9MCreucwYdzPfAy3VuTUgordL7R/X9pHYUa0bE1cc9
 Yqw5DgEh
 aABehg9qV8+58kt5k3HoTypog7U53NdFHhDYHmpb+iQX6jJ6Agffju1q06Jpe7UwHCXuaKkdhr5jgPe75Fcd4gMiPBqmbKFvHl9VFKq7vle8lflg9Ty6d5LnD49qobDTDZ4StYDC1uVuOwSNKJ9rUTkJiXxau6HRQIdi+Wm/K4mCA+mULmYIU0aEVDMXeghuA9M+oOBOimJuJ2/pOajrih0B2a1m1CN5ndyPYygkGwWFWXLnmc8RTThooA3E3qC9YYbWqS8xNv2/rIKhl30ta2NkrWbtkmVgQIQ2mHmn6L1JvnH5mf/Ftutwj14xh+Pmm7FZKwZfYUEEcqdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 07:40:19PM +0200, Pavol Sakac wrote:
> Virtualization hardware keeps increasing in CPU-core and VF density.
> Kernel is trending towards preserving VFs using LUO across a kexec
> which will put SR-IOV in live-update hotpath. VFs must be re-added to
> the sysfs tree, along with its supporting devices (e.g. vfio,
> iommu_groups). On production hardware a single VF can consume ~80 kernfs
> nodes. With thousands of VFs on modern hardware, hundreds of thousands
> of kernfs nodes need to be created, which can add 100ms+ to the boot
> time and to guest downtime.

Hundreds of thousands?  You have a hundred sysfs files per device?

> Proposed here is a PoC of deferred materialization of sysfs files until
> first access to avoid cost of kernfs node creation in hot path. In the
> reproducer below using a synthetic VF to isolate the sysfs overhead,
> the per-device sysfs-creation time is reduced by ~74%. It exploits the
> expected access pattern of hypervisors, where only a subset of device
> files need to be accessed to attach a VF to a VM on the hot path.

Ick, that access pattern could change with other users, this feels very
fragile.

> To allow lazy init scheme, a minimal set of files and directories is
> built per device: a device directory resolves directly to the device's
> kobject and is used to materialize attributes at access time. The
> access is trapped in kernfs at the dir-read or path-walk stage and
> depending on the trigger, either the full directory or a single file is
> materialized.
> 
> The changes are two logically distinct parts:
> 
>   1. Refactor of hardcoded device_add / iommu_group sysfs attribute
>      creation to a table-driven form to allow walkability of all
>      attributes and single point of definition for attributes
>      regardless of lazy opt-in to avoid duplicate definitions and
>      associated maintainability issues with it.

This is probably a good idea anyway.  Want to just send this as a series
to start with, so we can take that?

>   2. Lazy-init infra to front-run access to device files at lookup/
>      readdir time to trigger materialization. Opt-in per device: PCI VFs
>      and VFIO devices opt in via device_set_sysfs_lazy(); iommu_group
>      opts in at the kobject level.

This is going to get complex.  Where exactly is the bottleneck?  I'm
guessing that systems with that many devices also have many hundreds of
CPUs, right?  Are we hitting a single lock somewhere?  There have been
changes in kernfs in the past to split up the locks to be more
fine-grained, perhaps that needs to continue to solve this?

> As a PoC, the code does not yet follow this logical structure in the
> commit sequence and likely does not yet cover all corner cases.
> 
> Synthetic reproducer measurements
> ---------------------------------
>   devices   per-dev time   total time       kernfs nodes (base -> lazy)
>   -------   ------------   --------------   ----------------------------
>      500    31.8->8.3 us    15.9-> 4.1 ms     36,417 ->  3,922  (72.8->7.8/dev)
>     1000    33.2->8.7 us    33.2-> 8.7 ms     73,427 ->  8,432  (73.4->8.4/dev)
>     2500    32.8->9.1 us    82.0->22.7 ms    184,421 -> 21,925  (73.8->8.8/dev)
>     5000    33.0->8.7 us   165.1->43.5 ms    369,401 -> 44,406  (73.9->8.9/dev)
> 
> The reproducer is synthetic: an in-kernel module registers N unbound
> platform devices (60 attributes / 4 groups, ~74 kernfs nodes each; no
> config space, BARs, or probe) in one timed burst that models SR-IOV
> enablement. It runs as a two-kernel A/B from one vanilla 7.1-rc2 tree
> (eager baseline vs patched, plus a patched/opt-in-OFF arm), 20 runs per
> point. Measures only sysfs-creation slice.

I sure hope sr-iov devices are NOT platform devices.  If so, please go
fix that up first :)

> Deferral removes ~74% of the sysfs-creation time and ~88% of the kernfs
> nodes. At 5000 devices that is 121.6 ms removed (165.1 -> 43.5 ms) and
> ~325,000 fewer kernfs nodes (369,401 -> 44,406). The table-driven rework
> adds a +7..+11% eager-path time overhead to non-opted devices.

You're just deferring this work to happen later, so when is that
"later"?  And what about multi-threaded probing of the bus, doesn't that
speed stuff up too?

> Available as a docker image that orchestrates builds in qemu guest and
> prints results as a table (x86_64 Linux host with /dev/kvm assumed):
> 
>    docker run --device /dev/kvm ghcr.io/pavsa/linux-lazy-sysfs-vf-bench:7.1-rc2
> 
> Assumptions / Trade-offs
> ------------------------
> The saving depends on the access pattern of hypervisors, and on no
> component walking the whole device tree on the hot path to avoid full
> materialization. Both are expected to hold on optimized hypervisors.

Hah, as if.  Many userspace tools, once a device is notified, walk the
whole tree of it to read the attributes.  You are going to be fighting
that problem constantly...

> An actual production hypervisor was observed in local testing to
> materialize an additional 5-10% of total nodes on average on the hot
> path.
> 
> Overhead: +7..+11% eager-path time overhead applies to every non-opted
> device going through device_add() as all struct devices traverse the
> walker and can't be gated under a config option.
> The lazy opt-in infra can be gated under config option to have zero
> impact if disabled.

Again, where exactly is the time being spent?  What lock is "hot"?

> Final words
> -----------
> This is an RFC to first get feedback on the decisions taken at driver
> core + kernfs level before engaging maintainers of other subsystems
> if we want to pursue this further or pivot to something else.
> 
> The code is at a proof-of-concept quality written with AI assistance
> with some known limitations with main target to gather potential
> savings and initiate conversation.
> 
> Feedback appreciated for:
> - table-driven attribute refactor targeting common device add path /
>   suggestions for more efficient/less invasive approach

What's wrong with the normal way attributes are defined and allocated?
They should all be tables today, and the driver core creating them when
needed, no individual driver should ever be doing that on its own.

thanks,

greg k-h

