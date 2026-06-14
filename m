Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E58CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5144E6B0096; Sun, 14 Jun 2026 05:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4766B0098; Sun, 14 Jun 2026 05:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA446B0099; Sun, 14 Jun 2026 05:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFD06B0096
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:08:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC244140657
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:08:47 +0000 (UTC)
X-FDA: 84877943094.04.0E0F651
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 537B31C000B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:08:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmDgkLjt;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781428126;
	b=K4zo+BJuWbbLBe2ENhyKqX/eaQdIU17O8ZgSIMeqmPAPDgccnFTb76rbBaibbEI67gNb6v
	003SJLuycfsqnYlOmegW5F2Zs16whjF0fppCpnxIEYXEVn9EwyuFwMY04HrcmtVfk48hsp
	sCXcc6I8QXRUt2hEezwUzblJrXgQ9u0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmDgkLjt;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781428126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LYN2F22JfxLMFILRwK47fnnXK4CRYMdn70feq0hkAU=;
	b=57txYHgKXjyVfhsM9R41rlrXT6XbU1hEqnTc55SniiB257ifQy6kcYiOOXdWCu+qh59UO6
	MsyObss64ED/xeuJM2EwX2Op+eHG0xjk9EFAXjexHztkwK1xl1aL+YwGhE6FtGql46ibJg
	mBUvj6o1N2EngKjONQajXrHbhKkLsqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 804EB6008A;
	Sun, 14 Jun 2026 09:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CAE1F000E9;
	Sun, 14 Jun 2026 09:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781428125;
	bh=9LYN2F22JfxLMFILRwK47fnnXK4CRYMdn70feq0hkAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JmDgkLjtoZnLFZgAtR+vHMK67JuchCave9VSHr4gLxyba74SghnllzjeHu1vbkQOW
	 XMApUd/vQy4am3/StkR3hL+lROIGeGWOtRo949v3aVeGb9zi8sfmGMdbwQGgC7T5fH
	 i2A7clnIf1ZvlIDh41v0VNmHzZq2u55//0upr281SoxrShLFRXxfcU3mk6AJIyCr5N
	 5YyVO6Fsl3tlEDNaZeeEUxHQTAN0b3oc9b8C6+IfnDtEEgxEseTYT2914AIAMH+r7c
	 dqZeXh3ZbKvgMrRtOx1GuOwyKd7+ZYYMYz5+bgKsStmqg8oZrwzNSzAbLtGPuV6pkV
	 xPkPs0FBsBsuQ==
Date: Sun, 14 Jun 2026 12:08:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com, corbet@lwn.net,
	skhan@linuxfoundation.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com, rafael@kernel.org,
	lenb@kernel.org, gregkh@linuxfoundation.org, dakr@kernel.org,
	akpm@linux-foundation.org, rdunlap@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, kuba@kernel.org, ebiggers@kernel.org,
	lirongqing@baidu.com, paulmck@kernel.org, dave.jiang@intel.com,
	jic23@kernel.org, xueshuai@linux.alibaba.com, kai.huang@intel.com
Subject: Re: [RFC PATCH 1/3] mm/numa: add exclusive node pool and
 numa=standby boot parameter
Message-ID: <ai5vj_RjSxl_FLu-@kernel.org>
References: <20260610014517.253609-1-gourry@gourry.net>
 <20260610014517.253609-2-gourry@gourry.net>
 <aip5IWmxg9CWg8hQ@kernel.org>
 <airAUSrNjbSEwuti@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <airAUSrNjbSEwuti@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 537B31C000B
X-Stat-Signature: p5u8yke1zxgsw4t33jh6dczwsswa6ae7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781428126-93478
X-HE-Meta: U2FsdGVkX1+RiwBgI0efSwuE74Y3f9iZ2fuwEyslMft+momYZqXS4bRDob04/Ezfu2jgTmxjo/lEo3oTginxBfPHn3A3+CcG79V8/yzWn3zxvu+WNl7z81cyiMy3VXMT1bHBeZ6W45aZbEGT0BYzVdWufnXlJMnEQD3KCuVNfVc6Smp7wGsBigGOlEIySqoRlsywBNMpDM3xZBxCNjVvvwUwF4faHdDxnvurwRPWrXa9B6Y+4+GgB18mecpd20DO+k2TwDh45ADIhlM36qz4h9L+VuMZcs+qJlKqYillEvNne8lyMYkAu+pelZw9E/X02NowbgSG+JtJ6BRrA4ZkFjYHTexrI8vPRPtGHNHc8hXtFtyxdrXJdx1dXpueXsdaolD7RVqfHmKYRhx+RN6wMbnBgm+M6ZAx9ZzswkZLworwGkZD8ZfehAF8ENUpmmlK6azEcEAi74Ww+E+GIYIBBw1eJujMS+HB/v3VyhnMp4lFbx4El8I5lB1vKautVLVA8yCoW6OxKg2/Qi6gBnyLYUEF2UGpIRi66ir1anYXhktYnoB2Zlblxz2ZXekl41nIpDq0qwqdIvEIsu3dNsZAZMBe534onRhCQbpfQBnaYtc3zOpvbkWQniRLFvoP5GUyedionPn7hdMQb817NqYkhsunxUfctv8i3YTUGRYZ8UoE4upglS9zDXx4aYu9CikrTHgitUghst6MqDJ/ph2TuOBPMcORz3GBIIpY1xWvgfgzh17vCuavLRdha2KMLyvoeQ5wTDEsI3DJeqUeHkRZJAMhTihTvTqQwcbz2oqx+ykAZRxe6quhNUDZPQYghCq0m24lkpBH26GCXYon2OoQLMI83geU/vqK9KEnjoAw/EPBfPzEoWYgiVEkTLn08N+rQBD819+n96dgkeuoEYwMYi9po4ZuWglPugblY6eFIN9xInWS8T3C6k464FL96hG3656aN5f1zLSyQkVKD9k
 Tn+of55n
 IMuIoV8pL6GZZaUcWag7ELOKwk6ig4MSQjEn8c3xKCn66vcriagun+e++DBwDLIgKNQZO93QPy2cHXv8sTZU+bjTKGlhvE8avTks8ErH8+57HI99VPv0nkSU+lXMDL0R5o0u7LBiionqU8lJ9NdR1NGJ42K/oGUYaLU1bkiUbXi7APJI7x6S5bYXTpg1CES25KvJ0BzMrKgp6ojw10nxkssnvzPAQxIr1WYWgj9fEsrLO+AqBhuF6m/jM9f8CHL2E/SZ5J21VX1UqT7GJubyCP+HgbDaikCCEcwiypU0VQN+EPqe9TFIADjb4ISHZAdOiigrC5w/X9Bb5QvsQoIi4Gk9SZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:04:01AM -0400, Gregory Price wrote:
> On Thu, Jun 11, 2026 at 12:00:17PM +0300, Mike Rapoport wrote:
> > > 1) Can we do dynamic addition of nodes?
> > > 
> > >    Not Trivially
> > > 
> > >    Some services utilize num_possible_nodes() as a static value to
> > >    calculate the amount of resources to use at runtime (bpf, md/raid5).
> > > 
> > >    Example: futex_init uses num_possible_nodes() as part of its
> > >             hashsize calculation during __init.
> > 
> > AFAIU, we don't add the additional nodes for generic hotplug memory but
> > rather for exclusive use of by drivers/applications that are aware of these
> > nodes.
> 
> The intent is to use for "non-generic" hotplug (see the whole private
> node series [1]), which would eventually still use the hotplug mechanism
> just not for generic memory.
> 
> [1] https://lore.kernel.org/linux-mm/20260222084842.1824063-1-gourry@gourry.net/
> 
> > Wouldn't adding them to possible nodes actually skew the calculation of the
> > resources by the services utilizing num_possible_nodes()?
> > 
> > With the futex_init() example, won't be hashsize scaled down two much
> > because we've added these special nodes to the possible mask?
> >
> 
> The result is the same as BIOS reserving nodes with PXM entries that
> don't get used.  The CXL ACPI Tables do this for CXL Fixed Memory
> Windows that may never be hotplugged.

Well, even without CXL there could be nodes that may never be hotplugged, I
suppose that with CXL the difference between available and possible
nodes can get much larger.
 
> So really i think you're pointing out that futex_init() here probably
> shouldn't be using num_possible_nodes?

I'd rather say that num_possible_nodes() with and without CXL (or other
differentiated memory) has different semantics.
Maybe we need to add a new primitive for possible differentiated nodes and
keep num_possible_nodes() to mean "number of possible nodes with normal
memory".
 
> ~Gregory

-- 
Sincerely yours,
Mike.

