Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269E0FF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 01:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601456B0005; Fri, 24 Apr 2026 21:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1D26B008A; Fri, 24 Apr 2026 21:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBC06B008C; Fri, 24 Apr 2026 21:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF9A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:20:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCC8AA022A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:20:05 +0000 (UTC)
X-FDA: 84695321970.13.6AB40F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F3814000A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:20:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mjrkYzfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777080004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeeeICXPp5WTw9SP5DtWYCFti+rWG9jyI8wRn9rbKMw=;
	b=n0+i01ptGJceMUmoQaUZ+GA1kjyj+mMPiEbourc8u8V0nZoAwGQsN0qh5TKEuyoDlh/h8p
	CUsyreAd5EUikOXfI6Hy/9Q0fyp/K0ybihKODEA701o3sOyTtFzAgtx1wH4imMNK+utSm/
	msZcvtH0VXik4TGK9gYSKfSfB8+ow48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777080004; a=rsa-sha256;
	cv=none;
	b=yNuAzKRibp6qn67rjQVN4gO5b9DfCbQo6BSC39EU5Cj4+vp9AxJ/5V/+hpBIw0B+QdaAAC
	VwbA5CR+2SAEDkpUtJBQObSEytwDlC+k3CrH7fbgHoqwB8860Do6CW9cYbDsc8BvBLZwOJ
	4eMb0lbeMTue6qY5oGWjKawffMPIjck=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mjrkYzfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1800544264;
	Sat, 25 Apr 2026 01:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F15C19425;
	Sat, 25 Apr 2026 01:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777080002;
	bh=5hX0NBvb8lQVR9PGOGQDik+LqNBSW1MJsV5E+knu75Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjrkYzfe/ynaLya7MElydTQOfByl2dTFw+dWe5Iu9xb94pN65HFo6oyHZS5vZz1aI
	 uXU1dO74AW7WXgb7Seitov67HoeO4ixUGlXSbfr5sak6kb7AU65tTvPVenCqDklOCc
	 6dC3iUeWvi316WYbgzlGInzSHI4tkJMIUyVhjbT4jgcLW34/L7gf2bMV0KvK8g5taR
	 PhoJ0K6G0bpSMwIUo8vQhUDDcTacTOfcweH4MiHYtZWmxqbGbDRlMZygoSswElkdAL
	 NLckoYJizpsMmXw9Ql3RQNqMwZVdaS+gQRAR2Z9JzTLXkPPqs8IiWJ/pXXItPf2vdd
	 nc/VoCQDYYh6Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>,
	peterz@infradead.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Fri, 24 Apr 2026 18:19:52 -0700
Message-ID: <20260425011953.85997-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F3814000A
X-Stat-Signature: ddqu1poohirq61thp18c8jzd8xz4fcrm
X-Rspam-User: 
X-HE-Tag: 1777080003-996591
X-HE-Meta: U2FsdGVkX1+AHgBLAU3Eyg6lW3IV+CctT0csxSEyyOB3G6qOIaMGcYg1SezliVhspwY0mYzNNE+DzWizxyRtcA++KNI/xO/4d7yo+MUsK8C+zjVLmqMPpJcLYPxMdhfl15eRO/NAGHbX8UNg+BmeUozpbooEgS9128RN/GLoM3u2zsXECHNUksTvdF+dvF/TVI+V1ZfDpTnU1OM3nJLEoH+vs78k7/70IPyPMSv2NpnV1HvFOo3DyeRVJ6EDX9z2Zt14W8zRs9Bju3HSzv3yyl7KIYAT0iYRj0Ym7wdCeJqkSWw1pqJV0uH5e+0zifVKUbO64UBbnrzQ3HLBc5Rz0dHOKjw4LdNCCtwKytMpRpwZm4bSnxewKTA/AnSHIeVvR474udC+9CjNLzsRQBaTHRNt33tXjj+/MFAj/gv0UasOe8SsNnRjTuRvRLnAJXR2I9MrXdSrmxOLM8xjlhqi8nKGQAt15/Im/pxMA6K398jCRvce9pfOTGAsRt5p7B3JQd+NIxskvDz0B/wPTlMQv4QR5f6w/EiPUwUwvosMKQYfVhuT6TWbMD08TP8c61Q1pKDL7HphRYJGdlxsXmxtKk6VByCjnSmwbvjZPoM3Gf2FIgrN6nS+0CY6kKYAyTS3nymeeuP2FVUiUKvW9aPCU8OmvZ++wG1Q1o4V4XxynXN1YEjNNd+o9qzKNgEclzXiwpoA9PXuD4PvsFbZQ8A4W7bjn0NqadVLRO/AzhqW76qFnzBaEY2zpsJ8r4VmCTmUrYcLo54/EOvwZlVmJxtqYaeJUIFneF22wiEb+5HJ6JCQ+nnYe+fx8T1wVneY6fMnzDEDZ/RjJzle9OOLdoeF/XmXbamAczcO03z9DUn1/k/I8LskPd529VxCuzipvoPPLl3FX7FhYwChbCm26HI1Wlqq7GS0QYwg0Gd8hN+Je1ULhZE/r/vid/ro+IhKDXFepmXOKJGOd/7hu/1BByn
 snr7YHW9
 KiC82bKQ1N8zpo0NZcTRxuOZiu/THvUmDSy3jBs9Wj0yXMmUJ343CyJarZEI3tTPJ/yu3VjHNGpsvzGDoMfQTvvvdkNJY9IuG3n4CI5iXzR63Nlgr5/etFDh/cRpaFcR2nOBnGmes7Fxvxuc5RyFdmMHDfLkfTU07Ysc7ZZAOOPC1jNBKKMp2ECkpqxKqZRTtdjt4EWOBQ4jZnDjhy6iLmuMjO3GMF7WPRT0LJswJrUUVWOe3w3X7/KlCIvhTkYmYAdyQgPWVqLCDD1wPz1Jdjc0AIZDQ0hmMbaSUrBCirfq/CbzbXs45TjbjwKqSDU8KA6HZEOSHtPU7XOJ4f7ujOzPA3S/cn+KOyyuEfHlGZ1Y2X1Fm+Q5zHqMhXIKQpnQHSoP00//pRFIU7jdrmTFxqA+u+GcMvlz+iZ14
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 07:31:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 24 Apr 2026 16:20:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > On 4/24/26 16:15, Andrew Morton wrote:
> > > On Fri, 24 Apr 2026 13:37:04 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > 
> > >> On 04-24 06:30, Andrew Morton wrote:
> > >>>
> > >>>
> > >>> Sashiko questions:
> > >>> 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
> > >>>
> > >>> (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
> > >>> said the same stuff about v9 and it's all wrong.  But better safe than
> > >>> sorry!)
> > >>
> > >> These emails are helpful; but, I do not believe you should have to 
> > >> manually follow up with a link to every new patch series.
> > >>
> > >> Perhaps  Sashiko could automatically send a summary email in response to 
> > >> the cover letter, or provide a link once the reviews are complete. For 
> > >> the kexec ML, we opted-in with Roman to receive automated emails from 
> > >> sashiko.
> > > 
> > > Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
> > > that.
> > > 
> > > An alternative I've discussed with Roman is an automated
> > > reply-to-author with a cc to a dedicated list (we could use mm-commits
> > > for now).
> > > 
> > > Preferences?
> > 
> > Reply-to-author would likely be better as a first step.
> 
> Why do you think so?
> 
> Pasha, is it too early to determine how reply-to-all is working out for
> kexec?

DAMON is also opted in to Sashiko's email service.  It is replied to only the
author and damon@lists.linux.dev.  I understand this is the default form of
Sashiko's email service, and can flexibly tuned.

So I cannot say how reply-to-all will work for mm.  But I can say the default
setup email service was a huge improvement for my life.  I made tools for
making my Sashiko handling easier and was quite convinced with that.  But the
Sashiko's email service made my life much better.  Of course, it may differntly
applied to others.  My personality is not necessarily same to others.


Thanks,
SJ

