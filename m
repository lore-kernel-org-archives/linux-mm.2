Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A217C61DD6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31BA6B0095; Fri, 28 Aug 2026 14:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAD76B0096; Fri, 28 Aug 2026 14:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A186B0098; Fri, 28 Aug 2026 14:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77D966B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:36:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFFAB1A0534
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:57 +0000 (UTC)
X-FDA: 85151534874.05.D573FED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D49840006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yQyk69T+;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbn49kAAPUgUC+oEM+rUHWn7hXR94lgTDWdzdwQhvBs=;
	b=c7wyMZ6J3aX8kkkJQ6lVBvvI6XXEnaty1JTmGBJTH2WlVv4VbziM5s7Y5oTlwhba0bQ1tV
	V0MsNuYoI62Ej45KjkJOmI2VU1ixCeSvD7Oe22rru+ihAo52mwfGN/kBJjKUp74MkaCcVS
	4tjoJ3brkF4USdmtnsb59COXWrzZJuU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yQyk69T+;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942216;
	b=gxDmx1FVMz5+Ja5SCONXdyFrrTS2o+clo77GjljqEzmJ7jc56sixJluEKQgj2CDBsWtQ9G
	I3DyQkQKltL8T+HUIosyKnCK+GHBOaNsFWfmAzvcixfQLDuAl1RyZLFcfO3OpYwRHnkIQj
	Rumd3nasLXwpWnveYe+LgbEffDNRRgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C874601FE;
	Fri, 28 Aug 2026 18:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C266B1F000E9;
	Fri, 28 Aug 2026 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787942215;
	bh=gbn49kAAPUgUC+oEM+rUHWn7hXR94lgTDWdzdwQhvBs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yQyk69T+hrkrj6khDh9IxOsJiuyHv14Nj+E52yTtQdaqGJ4G2In+sdgqdeJKUQ0G1
	 uICrkPblJSCQ2wdbbLRv7D93URitNuMpUU+E7AzFMO9LrGXpOnxtpBHm7LkBuld4yn
	 qEplW5wtIrT+4CEGo+YWUYYv4ApomHqA7C0yRZPw=
Date: Fri, 28 Aug 2026 11:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>, David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
Message-Id: <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
In-Reply-To: <apEx0wT_hWs1Q5Wp@gremlin>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
	<apEx0wT_hWs1Q5Wp@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h5sfqdkkdpksfwebpouajszjap135yp4
X-Rspamd-Queue-Id: 2D49840006
X-HE-Tag: 1787942215-496181
X-HE-Meta: U2FsdGVkX1/j0PcldGrZ8Rpt4nHAkrX0Q7nqXW2Hfo5UCeXDQ3t+3/CsBHEGWYYSe8nZ8IfUqeJOVsNFJDhuLvpZVi6RDxm/+3yL2cwydopbksmRF2jgrlWEDFlEQjGoxVYQ0B1EoLjnQV4W6EgHqNUmkZyhg5/8n+1y7KsX2hUV3BDbRvIeqANDS/b5OnsPV3HGVLb1cQePKdbPytHHnjL+0x2SXqrLTqdgKoG8YH578tqKiLYVDhxLqbIdaVbEv5G5kX2XvPAanWxQ+pxIALqWqDwIMQuXKmna4Kj7L9EznyKe2xjs7NY6xtQMINnZlupB8djsriPzZbcn31Zo+4zbcAFXB116GG98pYIRWfRgI0M1Umf8fQlDkehlw6HcFEvKpsYL9s7rDlUdMhCZvSQ1Dc38IhG6FCRINQBrGUs5X7q0Ab/ae1eUY46QKdY+alcdTUndc9iQDz6Lvyo5q5laft2rQH4oXwe4lWDQRyJcRCxi+3p9Uz60WlsvFOAYyrRs3VWhx7nFITPVo2NiGSrtxh7uMlK4P+MabPakZyWrGIhRCRvUfo8dzHuhgqRMSoRn/olZ5QfEo/qLtgoE4Exy+4GZxgHpUTppeieBufmjdPqdVZfjCvNaXkCLTuWDdrbjG01RVSLUNfvjEPd79I/221VRCW06ySXNV89qIFfpnuwoAD6cvLf+es6MT3ZKb+zczfyJoLcgwAjnM/E11QYdqLpSnvp6Gigfsc1Mj38q2eVblaqI6OxsdhMrRdf5yVo7v8EGP9AraLl99IQimw7PlZlGuIf4+jd/9goezEQnyLD6Ky733+PVTV0zD/NcnXHxd6Ly+wJNUX3EipF3jCBnE28rpjyG48uGUJMK1NLytKSZ5wCg6DyZ9ygL+YurUSBLMa1o2YGnjYJUqXl9lEVivID/w7lVrA3w3aXlh0ObIUCQ+vEETf4+AMNVvVEcHH3Uuxd7/kaNlzQSCCN
 MRa3kbE3
 ECdZsHRd8Jfhh8emn3gmk9StcxsXRvpIMoXk56HAAu7muJr4zIRaLH2VDLaxNh4sLnoGgN7dVgcaIeYFTLAhksks9uZ20YzRqzzUDrWfgXlJL+OTFSGyodCIguzt3+bCBCJgqbz1BoZ4cZOFGwDORzbUbcSXAdxxLyqLLZC1XN7OXDaKaeTwcsUmeN0RgwauFGQY/Nf4KEYmMxtYucp7IPmFutXFqRpQdiBgfgchgQLM/mbJiU1mpssa1YE3y2S7kexmDMv7BLrM6EluBEBalEwj0SNlFTVpXf4aqlxdcXbLhvmGPDazNlUEmh9DA8o7x9lY0Bmub4Kl0/jMrpyRZfH0gFsw7oE6JTJiGmsfJoyCOnA6h8pHTE8WuyZsABdJzcwiq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 08:03:38 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
> > This patch series adds process and memory cgroup filtering support to
> > page_owner. Following the previous series that introduced print_mode and
> > NUMA node filters:
> >   https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> >
> > This series adds filtering capabilities to page_owner, allowing users to
> > filter output by specific processes and memory cgroups. Users can now
> > filter page_owner output by PID, TGID, COMM (with wildcard support), and
> > memory cgroup path. This makes page_owner debugging more focused and
> > efficient for tracking memory allocations in specific contexts.
> 
> The majority of this cover letter feels like it should have been
> documentation put somewhere :)

yes please.

The only thing longer than the cover letter is the Sashiko report ;)

	https://sashiko.dev/#/patchset/20260828031339.1270699-1-zhen.ni@easystack.cn

