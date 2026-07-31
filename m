Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548B3C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734D56B008A; Fri, 31 Jul 2026 11:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BC86B0095; Fri, 31 Jul 2026 11:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6482A6B009E; Fri, 31 Jul 2026 11:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B92F6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:55:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D070A80462
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:55:26 +0000 (UTC)
X-FDA: 85049521452.12.8C134ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 107474000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:55:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQrz+q+j;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785513325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rV8nBJFnfG2GCaRpLts+gSbWqrdQBPDmfooT330Oc+A=;
	b=qkA/+gQjk0j723fRHezR5N6qMznSYaqhCjVvjTXvA0AENK/BGMkbC0lz+MyJZ2ZeZjp+SK
	AXRQieItrcdefDpEl/PjsC/0ibJ5kFFM2bQPAvoLzX/VPmlj0EEHl1dnY4HsK6acY6N+Tw
	nAA9lZE08CY5DEc0m47nFJUjVFJuQnc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQrz+q+j;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785513325;
	b=P5bXcFQ/YZNxpFzklRfFGEWuap7RKFw0PwrmxpVVS7pw58yrFpmQXkoUeqGCOVORdoUvsK
	ZNIDfLsmDp25EqJyI/h5vLcLYnQft2SG+GFel1VwI0S9xZ8ZyJb1KCSu5N2oStvg1ad4AK
	xVdC2snL1VMPfO14XhOLZRtTjSlGJmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DABA66004E;
	Fri, 31 Jul 2026 15:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2740C1F00AC4;
	Fri, 31 Jul 2026 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785513323;
	bh=rV8nBJFnfG2GCaRpLts+gSbWqrdQBPDmfooT330Oc+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aQrz+q+jmtWscHrp9E+JMtT7juGxIgBJ3k9QargV1FyQBz2ttEjM99JD/jGxdWEGw
	 /c5KRx/P0sBey4T/Qy/3YB6loaZcpj+tPfwVDTGjIue0RhaFOU1Gp7IAYSxDt8vntP
	 MJnrnfKJHRSm2RQeLZcuO47Ak1d92ouTrk6J+jywUfIPCc8mLnKQgHG5tsD+pOUh13
	 b0prcn+AFcDCYUGCq+lzyhJLdEBoO9LLM2D+Ib6/Sfncw8dJA8BdUY+Fq7gDh+LoJO
	 mF4ExPOvMNBpc/WnbTG583ancA4tYXxxFUDSZwNsxBiMmBsvCLKRmT+Gt0ylRSi04/
	 IoTfI8rPInNoA==
Date: Fri, 31 Jul 2026 16:55:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
Message-ID: <amzAPXR_rBqj7qr9@lucifer>
References: <20260723074854.1013941-1-jyescas@google.com>
 <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
 <amsCEe5qDn7CPWvF@lucifer>
 <CAJDx_rih=0qWpfsnOQYbEwgG1OgPEK23MacTUsJndjiNLV+CGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDx_rih=0qWpfsnOQYbEwgG1OgPEK23MacTUsJndjiNLV+CGg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 107474000C
X-Rspamd-Server: rspam01
X-Stat-Signature: mgfgnu7hkken9dg7opgubtjzy9dwk4uc
X-HE-Tag: 1785513324-465125
X-HE-Meta: U2FsdGVkX1/fEplwVIvGiKVbPDnP3pqIhU2HVFurQwrvCrC8HsnfvJeFTH8w4O2DrjKUn7uRmZDNSM/euyGWvfDOqRsbzYxr3ENAKwunN6PRl/pQV2PQ2RVPQq0exKRMGSBVaS4VZjoiRnzD5GQ8NPw45EPo4+MccYjrJChR+QC45rf/POGG85cmtzFxCLAChcip+XKi7MXUYN4Y21bWyk4e1X00nFag03pehgsuYFjAhFKxPFi6j2z/KZKBrBN2d2xZ2ddE2uUw3SkuDp3OVEagZMutcvIbAOy+wHJ29boygrxvb2mqQqQA4WGpybkjOZqjSB7Mj221AuT9Cl9OO/W8z1LJvQ4on31kbZSM6Y1Ti7SKGk/phhCRQ0h+D+t+ilqBrjJ/wFeRJNeb25NCWwurwvQ202YtbHUSt85Oun5Xr7I2NkIKodvSs/AkQBCtWvL9HQcYSv9K/pDPKvl2ZYoMEV56ydrrsgv/G6AKmGq/9O/BxoONsxLQwmJ1Gt8lK79lZ/4IItCL67C9h0w03q3RIPoaaD7GFzrJJdNssEWWbGKB8xvtyDvioOUCJC12efhhsWMaXzghOOAnVHPmiEYnHa63u0Ct7XXkPDam9RpQRGXLelWyDPDLm44bT7Zyz7NM01yzldApIFXTTrPDGRa59eeuoL4XozVB2vAXzjtakuw87uZMIvWsw6V11cLKhv7DP9vpZPlFLAoNoQORgJWXKt+VvK8Nl5QTDKGvbLvxkA3kjCyjUQgaBpBRb3a+RJ8pBNm4vNw4OKkqG+nEGewSW5Zzp6MvHQJirJyvV6qWYt1ANRmLCxaWsukorDKxJcsmpLraI+eb+TUx4AnWhE0uwTG0Dc169/JX/CGTyBM3hdar403zfJAReXLsYNXRQvw7qkTidiA58m+rvlt7wQzZ5V7hLy7jYfhQ2nNiMcGzLQSRflqoJ+UUov8mc7yI3lnSiULVZF4zNli6fJ+
 1dh5rytP
 7rTHhSsU5hw0G8vQ65HwJPMuhXyw9JP0LPHjpX0iwCnbWZ/9Mm0CtuGWe3Gj3ABCtkc6/QhXxyHsVCR6VLZI8mfWWwFIOdCgir78x8cH6dGb8U4OtvveHGaMh+05VQ37uLnrGjaO5NhqsF58r2pQTD5kjwh4uI0CITH4HXtq0U01A3GEFs3S1StCkXKJ8foFw25hoEOfTzqQHM3lFJjg9+g2A8eG7tEulaNCGndNLJkWUtJwr1PQMn8bvuuBea19UhpllXxDoM1cdtBR8TkBTObs4RTHstbhgtBaaRuidBAtwGw1Bu4jOQ2Scmi/7AUR+6onTqhR9GRJaQMAcYmTIEj3Obb9VGxl7nLbCI9P+iGixIRyMEGsAdooM/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 08:32:35AM -0700, Juan Yescas wrote:
> On Thu, Jul 30, 2026 at 12:51 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> > > On Tue, Jul 28, 2026 at 12:29 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 7/23/26 09:47, Juan Yescas wrote:
> > > > > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> > > > > allows you to allocate memory pages from specific nodes, zones, migration
> > > > > types, and orders directly via debugfs. This provides key benefits for
> > > > > testing and debugging:
> > > >
> > > > Would it be feasible to carry this as an OOT debugging module? Would a lot of
> > > > symbols be missing to achieve that?
> > > >
> > >
> > > Thanks David for the comment.
> > >
> > > The only symbol that would be needed to have this module as OOT is
> > > "migratetype_names".
> >
> > I mean you could hardcode these and be pretty safe :) I don't we're going
> > to add any time soon and if we did you'd probably need to change the module
> > code anyway?
>
> Thanks Lorenzo, I agree, the names can be hardcoded.

Yeah :) I think not such an issue.

>
> > I feel this debug module should be a noop in core.
>
> What would be the main concern here?
>
> The reason I wrote this module is because my team and system teams who
> work in memory,
> have programs to alloc/free memory to debug memory issues. These
> programs are not shared and
> depending on the memory issue, developers customize their programs. If we want
> to allocate memory that is not MOVABLE, we need to write custom kernel
> drivers for that. This code
> is reinvented constantly by developers.

Exposing internal implementation details via debugfs is problematic as a core
feature.

It's not impossible for this to be upstream however as a separate driver on the
basis of people re-inventing?

>
> With this self contained module, we can allocate any valid memory from
> any node/zone/order/migrate type
> without needing custom programs or drivers.
>
> Greetings
> Juan
>
> > Cheers, Lorenzo

--
Cheers, Lorenzo

