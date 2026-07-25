Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4CCC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF786B00AD; Sat, 25 Jul 2026 17:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A807A6B00AE; Sat, 25 Jul 2026 17:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998E56B00AF; Sat, 25 Jul 2026 17:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74FC66B00AD
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:37:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3873160389
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:37:42 +0000 (UTC)
X-FDA: 85028611164.13.4FC47DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B05BE140005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:37:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aeUZK1Ye;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785015461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VW4Itax4uaoOUozvRTGW+C9GkAjA2igtg5x/nUSArMo=;
	b=UFZdR5RvXCihHLllPIXDpGYElC4Sx8JGW3GvxboZiSC3qOdUAa8YggdZTMBoSLiyD53HTD
	bbaUuQAvG7BucpZZ+1jmah0Q8GnpHXZLsMkBzKoeENi6urUcVe+FyGJ5p2ZOYvjR7HeHXj
	6C4WnVOllLmIDdxdDNUwv5HsNeAKVcA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785015461;
	b=J1gyADfKbkx8vP7KUFncwsUDNxwucu2+FAp93W7d991f2WjEMJvgkOLUPSm7QBXrYCXv5J
	zcod6DUiS7JSV+Cjgy6lxBk7oWUsJYejkTdkkJ68cSVpZCe06NwnYmsj2DwXWewAWtgnmR
	5QjH/JF9gFgFSwYTN15mYAFrIOvtbaM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aeUZK1Ye;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67EB54393C;
	Sat, 25 Jul 2026 21:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAD91F000E9;
	Sat, 25 Jul 2026 21:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785015459;
	bh=VW4Itax4uaoOUozvRTGW+C9GkAjA2igtg5x/nUSArMo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aeUZK1YeDV5CnqM+wNZjzhm24RcMioMzbLfMV/YltypRgeB+j417/pVDmBUIgRG1q
	 +WmUeKXEas44pAsguF1wIvjbr+ffU9aQUbnHE/NfzNKzdpH2C1+0AWjA3eiu2KcPEG
	 pyxSopA9mMB4fC6Ioy0JHbR2Ra8b8s8l32khIajc=
Date: Sat, 25 Jul 2026 14:37:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kwilczynski@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Bjorn Helgaas <helgaas@kernel.org>, Manivannan
 Sadhasivam <mani@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Baoquan He <baoquan.he@linux.dev>,
 Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Simona Vetter
 <simona.vetter@ffwll.ch>, Suren Baghdasaryan <surenb@google.com>, Vlastimil
 Babka <vbabka@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev
Subject: Re: [PATCH v2 0/3] mm,kernfs,proc: Unmap mmaps of removed files via
 file->f_mapping
Message-Id: <20260725143737.daa698b50289257fbaa9c6f1@linux-foundation.org>
In-Reply-To: <20260725210549.3716546-1-kwilczynski@kernel.org>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B05BE140005
X-Stat-Signature: p3mus31trksmqmt3sksgjexdnu56eok1
X-HE-Tag: 1785015460-683326
X-HE-Meta: U2FsdGVkX19a533980w3C6UzFHNmiKfIA7Yx0dSZAW8SVFoxky6oHXXXvXOS8voKnPhQ690eNQGM4JDa9/wUj8cer0Jnb0ryh5p6O64JR3mOMZOuIos4ZnX2+e9qRiNNgBCb3jZ8xi4OsUGnzWqnFu4ozuJ3xYw3lfrIylXmSok6Rq4myhFEe6BXE1y9dJcBMZD9qwawMads8pYZbpLdqL67u54Rc8Rpe77QGgl6P3P2XQJaT59d3BL5wdyEIbwQZ4xzNoPvF0fXqpyJMqetuUBlZ/+nD2lV3Z0pbnAhK22G5vRqRzJVgmn2KNOB7xti8+iFQBf86D1V7thCqMwT2fiaaLl4xBtLfXPq/BXXupXvEzc8EmMYQP45irD/7Kn42iZezGFjUjv6DQilwz4cWDZv7H5DHHzoxrPuKvhvH/bxgoihN8fECSYqcw5M0alZvrdp3nqdrnzgZ+GDffTgF9FO+aujFN4D9r/l81UE1CSjF/tI3H4/v5noNEpJyrW+UHB2tebEu3bUn8FoqvEhT2FnliHfBOPeq0Ike5zLQf7BpRpkERh0b/FYBz3cUPBcq4OkCyaxLA8IqPI6ktYJ7obrfm+V+BEGVLK4FEGxWKR3TAWtTVPSR7t92Wde6vmH79FMtKWdYQLhhA2hOaR7iHeXtnII54QZGaW/WGKpCgqj4hposr4KWqWYEcAZzeq2YBEPxf0B725jbaFxertKzEcLDqQU9vbZZoPT0SqkOYWNcD3MI5hY5p/NVm5lTnwS0Fy9GDh1Hfr2NJJ+jXN1y5MMU/7Dpa83M+Utb4oGhtQ8q0WejZBbjbdHbziGkFJQv/LEDSaD9T0xt6Eh4ngazbNPps5mheUQknHdwTzUXdwG4yKpM4IvhslBC0UiiSN3BRTMNzV5bC57jSuHeeCgf/Nx7BCxwGKS97gjGQIWmgAavsxEdoDJHQSQFkwxaHWoivfM6iCTTQOn/ApYWLE
 KwN7fIZ5
 b/6cTEGDoVnMICHdm/X/GaUe3P5PqIShFoEKE8AOFMVBpa1BttZH71mgNaNmlrNqRlZZJouqeA/bJgLWNfDNN8ug8+sr1VgrPr7bIy/CQo5OX0l5s0WgMwsLwyfZaYY4ntKM0sW9gSPJdj2x99eqfsanzYgttbYzeIMxIP2lJvy/3ZX/N9kSBobBl/4adDxwtiTCG7w159LB6hzsMMCkjzmsKM63HVzhtPsKuG1l2bLzy2yam0FUqmiCT3G06fT1yZ1iILo7cpZ4UIaqfsonWseG/+xBvd6W1FyklthllCYiRko2Sz+j2FofvV8hDzPt2PApmvmkmUcaEpJiv2ozmSOv7S1up7BkY8jUw2NZtLgzcME8ti7xWwogANqEGcSXoZLZNgIG2vBWlViHRO8kQq5fyIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 21:05:46 +0000 Krzysztof Wilczyński <kwilczynski@kernel.org> wrote:

> Hello,
> 
> The PCI resource files in sysfs and the /proc/bus/pci device files swap
> their f_mapping to the shared iomem address space at open time, so that
> revoke_iomem() can unmap userspace mappings when a driver claims a
> region, see commit 636b21b50152 ("PCI: Revoke mappings like devmem").
> 
> Their VMAs are therefore attached to the shared address space, which
> neither removal path reaches: kernfs_drain_open_files() unmaps the
> sysfs inode's own mapping, which contains none of them, and
> proc_entry_rundown() does not unmap anything at all.
> 
> As a result, userspace mappings of PCI BARs survive device removal,
> and also survive a BAR resize on the sysfs side, keeping stale PTEs
> into physical address space that the kernel may have reassigned since.
> A mapping made before the device is removed still returns the previous
> register value after the device has been released, through both
> interfaces.

Thanks.  Can we please have full description of the userspace-visible
effects of this?

AI review might have found a few things:
	https://sashiko.dev/#/patchset/20260725210549.3716546-1-kwilczynski@kernel.org


