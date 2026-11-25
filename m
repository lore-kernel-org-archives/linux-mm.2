Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25EA606A689
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SVKXub+d;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1owZleYK;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HnqKLhDZ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vhjMSqEX
Received: by kanga.kvack.org (Postfix)
	id DA82C6B09BA; Wed, 25 Nov 2026 06:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58C36B09BB; Wed, 25 Nov 2026 06:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F656B09BC; Wed, 25 Nov 2026 06:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876156B09BA
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:21:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BF4380E47
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:21:32 +0000 (UTC)
X-FDA: 85473400824.20.4749688
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54534180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:21:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SVKXub+d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1owZleYK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HnqKLhDZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhjMSqEX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795605690;
	b=Am8TKJe1Ph5HXy8y71KXoCU5b7GfWRgHCI643IJD6r1yEidZHgsha0xrTbCO2B5zCrnVtx
	aY2T96Bs1NgtRZpVfycDc2VS0GG05cb8/ePuHGqOTSot54zJatQLu1uSp9VeX6k3ly8lJO
	mkOwIsfaq3LxLDDZCBcVZ+goTXLeug4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795605690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ob+Vq6L4US0Tc+CXMPvwy44ZwB7QIg9X6EZnYEIjp60=;
	b=ytkGpTi9eoTPpF8UBq684CauKmRrmvQMwlfIDRY/cygnV/4SbJw7ZbKXLun2Gz27+6UsRm
	yNVOeMiLSERpwxBsR0KhaRjTY+netp4ZP33Xv5bA/yofZGVPAOMIeNcZoW8ShEV08l5Zwf
	Vs11kwX4C85iqlihBV64ahJAdIwUonw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SVKXub+d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1owZleYK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HnqKLhDZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhjMSqEX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CEF561F7E4;
	Wed, 25 Nov 2026 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795605689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ob+Vq6L4US0Tc+CXMPvwy44ZwB7QIg9X6EZnYEIjp60=;
	b=SVKXub+dVIHf6xbd0DStZYOnuIKDz33gDFQBigyuSfSuY4ciQOy0UXh5VkUjb7uEtQ/itg
	n6ZiKcOVdbM7TCVJgL1pDHCGhxhCZdrZHTz3ibpWTR2m+MaCrUPMsujLR7rY9u+YyNk4Ok
	tfHx2gMqiNwIa4Ke+30SV2Tw7GauaF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795605689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ob+Vq6L4US0Tc+CXMPvwy44ZwB7QIg9X6EZnYEIjp60=;
	b=1owZleYKDD4SGDw3fU3e4wcFD2o42VU8SE/VaPiW6UjnUs9aay7PwWB5iisJC3ATwreN1n
	q0oDmF2NpaB83fCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795605688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ob+Vq6L4US0Tc+CXMPvwy44ZwB7QIg9X6EZnYEIjp60=;
	b=HnqKLhDZivs/f2jjuH6c7tNSEGKa80ZFlBDZfWgC/9RFIFPl3/+vISlD6n+roytFSSwujc
	1FI0XEfN7aqxrnGO8hiKnqIhYTUo3zu+wGURSb/dUyVdtnHOedpykl7FFW222+ppScAr66
	MZ5wEDXser8U3QKglz6hW55tfTjqYQU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795605688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ob+Vq6L4US0Tc+CXMPvwy44ZwB7QIg9X6EZnYEIjp60=;
	b=vhjMSqEX5XU9Ms1yJL6Mh5evELI4VLISLDyWtfuLY4vo5dac2rQ2fLoDc/4TvC9vDrX2ye
	+TN2YXflhJF+e4CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C00F6134E8;
	Wed, 25 Nov 2026 11:21:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lQdhG7XEBmtNHwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Nov 2026 11:21:25 +0000
Date: Wed, 25 Nov 2026 11:21:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awbEPaUkbQA3TviB@pedro-suse.tail5790ac.ts.net>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Stat-Signature: aysigf8gnmcimspwexx1scdu59ppuxjz
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 54534180005
X-Rspamd-Server: rspam03
X-HE-Tag: 1795605690-45287
X-HE-Meta: U2FsdGVkX1/L2r1AGZ/kr+YwKhSdxj/aliArDH0F9rTzmgDRnm7VnOeXfRrpAiOA0hVrkdHMA9jMmIbC89pJIppFIwLqKYMvRyXtH7jNYhJ5I4wzRFIOK+zj4N8bqvI0hdaMs9MIs6YwQbSmiwSUM4x6kMZrUGHDIrbvnSUz3Usjnxk0kPBN4WXiRbnzzk3SYTyZz9a0LlWh+iDNmfjEUisesSwzVG1qKrEFNoJOYYKOu0sB7fmGwWWIJZgpZyd27zUtnpzraI2NcdL6buFMdqCeIQWHmvlh6K45u6sOL0E0FbS2Vb/gpJYeiSC0JfpCWVWwwkOMGirPtXh0yXmpu27tBaC7B3p7PmVvGdVcb4yBRYMbhpvInPaq6uJgCiyY6vnQ1sxlTYwOq2RIm0YCfD4HSUPpJnykKwfoIRe/n1glzJJz1/PUs2RvgyM0LeZs0nRHu0+0LYHtjJkNbCF/todKzocPJo2j/g/wpK7fJWtoX4SIfVpsfCj4XH1lERBEaUDckDZAfAk3mDcq13lnVT0gW7P8icHG7/mzbdBG7SGssBEwhnS1OQn4bFHRNWlqm8TB6Hesu1NLgpTMGY7ME/Xw6KsM1M37azrJh9eCPjEtsmCx7qYG0wEZqtoFbgXlw30VSSTZ7leDmVy7qmD4wquM59IFtC+ktUk42lvxeA0dZs1bAB6bbBwEgoSHbHRLNwd3KdQelcXsxkvp15E0oKw4CLYFE66IJGHqasON1oKT6vPyEujkNI0mtNleju5EWjtiEn1DfclLfJFqPLud480LkxuHQeyitReTPMPB5Oy2G/2uf56DY1niJDb5CiNNMl60wh2EFzpsvi3Bsl5D4KxwlWUNJAZG/Khuja1CxR18bB9G0Assb1O/t4VTXO376J8JOhe22zf1lLG3dAPKSo5oPuo+h/kbd37pw3jId1E5+JLXIB/CNKeFAecEKUesHICfbG2isWW/c9i5KTc
 jpw1Ctoj
 2ngE5U81sUo30oQHlJ1S798Q0qqeF7FPG3hWd3TbojhB+QDgvUNx763Q/Mk75bd7T0YRUDs4dyw1qkxM5zgqt4BWuzM6pW0rzChYkiNVvX/5ARUmwYEn6gb/NcCFRCOS8R+pu2J8MT+uqzd8LHMpvH5EEELuEvf/IEyHRsc7PQuV3fy6ukRV5w2x1PSmdBykhY9OaSr282uSU574DYQL7iHb1hXQ8s9J2oxsNuRsBefB115Z5p6z57lvD/9yTCIRTFKOry8ft6snGYZzYdGlWz3wEm1BVksPxZrlqBEFh9O+hsfmJS52jOIMw70+RmEXKxxJsB5oF7aeHJt+fbCLarXt+oN4MlLbMTomoj2yNZ2EAry08QI74/5hEvs17UzwgHMpG12OClCd9jz7C8Me4+jGl00t229mqIsUKSkMIDAVOhnLd2YFcg/CsHycL7D//HN7Y07rPzUoJ7OAfAX8fgNuGtomJMLrMPIWPoB2oEMSozUWpxRPF5yPNO6Apze0BALIN/OLR2T2ND+B1rQ5gBMc9RNDSl2fXYzuulobs8ggbqT11QaqcZhL2Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:19:18AM +0100, David Hildenbrand (Arm) wrote:
> On 11/25/26 11:05, Christoph Hellwig wrote:
> > On Wed, Nov 25, 2026 at 10:50:42AM +0100, David Hildenbrand (Arm) wrote:
> >> When I looked into this issue, there were some problematic things.
> >>
> >> We have some odd drivers that use FOLL_GET|FOLL_WRITE, but I am not too
> >> concerned about them.
> >>
> >> But are ways where unprivileged users can mess with  FOLL_GET|FOLL_WRITE
> >> references to trigger this.
> >>
> >> I think the two that stand out are:
> >>
> >> 1) /proc/self/mem access using mem_rw() -> access_remote_vm()
> >>
> >> User can write to a writable-mapped page-cache PTE. Then we can race with
> >> removal of folio metadta, to then set the folio dirty afterwards.
> >>
> >> I remember a good reason to not convert these paths in the past (we are not
> >> performing DMA).
> > 
> > I don't think that is a good reason.  For file system backed VMAs we
> > really need the pin to be able to do someting sane, DMA or not.
> > 
> >> 1) We fix all such cases now where unprivileged users can trigger this,
> >>    converting to FOLL_PIN.
> > 
> > We need to, if not for this series then for all the other outstanding
> > issues with GUP writes.
> 
> Cool, and I agree (that's why I placed it at 1).
> 
> But who is "we"? Because I recall that "we" wanted to do that a while ago.
> 
> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
> be the harder nut to crack)

"we"[1] will take a look.

-- 
Pedro

[1] https://en.wikipedia.org/wiki/Royal_we

