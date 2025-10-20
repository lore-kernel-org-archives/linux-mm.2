Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147E1CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9E88E0008; Mon, 20 Oct 2025 15:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432968E0002; Mon, 20 Oct 2025 15:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3EC8E0008; Mon, 20 Oct 2025 15:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17E448E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:58:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1660C02B3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:58:35 +0000 (UTC)
X-FDA: 84019554990.18.88CDC7B
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01AB540008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:58:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n7j7mPe9;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760990314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpSw95obqMwiMZRj2XKUmKgB+9nrGEn9Iqfz2fDFxTI=;
	b=fhVFCV6cKG2pi+bpl/jHU04Xu8ZKTZUT3OQkI4CxrOL4Aj1JarMyZJWkKjMHM3TAyQN1YL
	uriTz4A0L+je4w6X/rU9ybdPVQBlyEqgmYmu3doaAHDWqSTSZ7FO5nzXAKX51WGRe2t/Uy
	din09W8VgS1779Q6vpEW2Ll3h5atV3M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n7j7mPe9;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760990314; a=rsa-sha256;
	cv=none;
	b=xXs/fuzX/NemYf1llR7BCUisq8hyp1Qqdy9g6j/TQ/trU81P1iq7zI5ENl9kVNLHGNfJ6C
	e/7OmFyUG90tZKNwyxMA4d6+xB2H6rtScH/4R7JACj8V0nGKG7jQ5h6MNkgITMcDD+IlmZ
	TSnO+e69e4WAIiI0HvBN5qZ/HO2vt4s=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8608f72582eso333552785a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760990313; x=1761595113; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KpSw95obqMwiMZRj2XKUmKgB+9nrGEn9Iqfz2fDFxTI=;
        b=n7j7mPe9id8XK2qrJHzZROChz+luPt39uzvShtwcu81JSGAJzXNchhvA3aq0/C5N8b
         u37mjrOOk7RECiz5SbHdeg0RESNtY6buex/tSAUY7ssxz/aFv6GUEQCZgIaDMcEk/TSe
         CnkPvp+P+b9ncWNP1sDmIJgalcqsmsqUP/G7aNd0gP4LNtrkF+jXhgGlMRmyekgU2c3P
         C+9AM6ylnqOlRNTQbJ/Cwlc3mlfE3cn1JjQndrVlQCWzY98KPVJbnfQBeNjfIstzmlUn
         BYE+GuzOQ0lEilEZSYfe1cvJ3akf9ByOt17oEVNTl1Lsjf1VoL6ri9CQ7BJK9Dg6S4hh
         Y6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760990313; x=1761595113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpSw95obqMwiMZRj2XKUmKgB+9nrGEn9Iqfz2fDFxTI=;
        b=XvXknW2MQkBsyuuzHWZJlkHz9SXF+Gyn8fm6lV8GChKQwibEgAzdZvSJvM6U3Tus+5
         uLZNrcczQtn5vLK4XhT75RPQinKi2fwq1CK05ztcPYyEXGRlR/a/kPnZplkQBW5E87gB
         zTTsnp+NFRzGp+UerBWkIEKv/xttRD8xhno6xuxv7N7I1jOPMhewbyo6i23AdteePBrI
         +JaenHRQMQ0gTR2wsNA2p/8Y9gtOF5crA7qDipHycL40RKYkU3ecu1HAPHku0c4zYc9y
         /+p8HmtiTcUAzwlra1VAy0xIEnVpIdyLfo/GukWJzViBXFcLS3S3Oza1J/bSKyhC7gnF
         MEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv+ZTdAWEvDoUo3WM2W3gf74XFHFGzoFhZ5w2SbdN43sZMIB+9MLZndqybcYOGs5LNi1bd8nAmUw==@kvack.org
X-Gm-Message-State: AOJu0YzKLzE8YmlsvOg2BGawfsu0DK/6T1plp5Fh0uypcLxQe51OMsar
	wlySScKmRwESFOiDirjoQfCcV3QpDQSPQ+iP97Z9cjspTAIrXgnz4fC5QYf/fLRxSFY=
X-Gm-Gg: ASbGncv8ZoIJltq637Gp+jQ55f7w7Ki7xSaHOi4Qg2M4bq9ijw5XjL1vgtVO1f2Oi+6
	5F+pXOtwr5SAonVdT94tLnKVBRa0J4GHpESPUNoTZqX3Nf9hO5JApn3U44eqsmaY/EuU2PhTUX2
	Voa3zXK+wD8aGJG+axUxJ1FmcrJr4TUhi2e3nslflOX8no/uDpVvxnJ2jy1r6/hc8gRAhqYDdMg
	A+hCblrTqgm674mpikwKn10pnnK0znN7nUPEFb+NRUV1/lFLxUueVvtSGVXqT7Sv0l5492ntc0k
	YbHTiEWWhMv0nYDYcWgGSGls8ggVzrtNR+k6AoKCOqTv9dnUG2D1qE2aIxfjcqym4L3WJFTIUmg
	OgIm+DwjRMeAg29PBJOgxTbbvaa0uCkWs08z1CjULRCzZzcVT905SDvDIyZ97drZR9IADZqVlRA
	yi5fxl0xQ1ujLtkIWBDCDp1A4wYlvPqpJZa40PKo8cRa0f3l3K4b6ECa3heX8=
X-Google-Smtp-Source: AGHT+IEH4inZHsGMB2ZYEjkr5WDEu3rWhYipUwUtCdoFFkQwAFe+FMZe38IwTo5y0Tp/IMfM5gz4aw==
X-Received: by 2002:a05:622a:14f:b0:4e8:9984:a139 with SMTP id d75a77b69052e-4e89d292b33mr195411141cf.25.1760990312985;
        Mon, 20 Oct 2025 12:58:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8ab10bfeasm59829831cf.37.2025.10.20.12.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 12:58:32 -0700 (PDT)
Date: Mon, 20 Oct 2025 15:58:30 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPaUZm0ZfIEW3gUr@gourry-fedora-PF4VCD3F>
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
 <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
 <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01AB540008
X-Stat-Signature: 3bfc3tmh78s16yrjp4h8nczuwiwtwk9u
X-Rspam-User: 
X-HE-Tag: 1760990313-146684
X-HE-Meta: U2FsdGVkX18rqdSOK074H9eSeGWVYhbhFEYScPBOjR03L3nyZau9SG+HV952er86Dm7siUynRNyu9DmbpjoMH+xADl/k3BOm2tRratxgxAi23ZCX2obRaO4572liSTe2GlSjKHlKP9vOtvR7TdZc9L6+m0ZTq+TvRg8X42jX0Z4XPZWJbFcHf/kECVCRQKlhQbN9btVhgwt3OvRr/GuCr2MOlyj0rWwJmoQRSZv0wXBuA5BEDliC2ONsqSl6RybpwIui0mMD1V+Z4DlcYDM7ohxpL6/JG8SSR05H1zAmvJJQcVMDzM+1vLgg1lzzZeQXNu5vamO2WEjrHoBzrbyUoiFJc8BeOP26r7+uigQdmLCxhazpS6RWmpqa2qZvwBr9BGoNQbG1gg9PFliSZqTtmwaEcdsbT8SyXuiRCJKqxI8egxy9Gp305d4FCrNphdn+b0d5pG9deJH0llbsG6gSvundaGCP6vGEkbo/YPjyzW5FPLzjXSPl4xWvNVrzhkn+1aS46VQYVYsPhWkvaVNBPGUwW8FR5u+eR10HnibEzDeMNvNv8uFBUVYM751CVwqITyBcqLhP9c1rJ6Xs1ePUCIq1+AzFTlowqg2g9Nd7jc1ChZZ+hDS+vY6lYdeGoWjf0irIi+zHLskwKzx0B8F+D5gkQMTCELgbQgbUTf5xcerLw9B/FzCb+Y1zUkeInntVvqmxYgRlPKGExiAeFGGSfXvqJE8mvWZpRvDenZpHXIycB5gCFA6o4+pHguzxeiEO3LOKGU+0noVMvhVZkFmuxaai0CiJ5uAD0r8kO665C6JXg6ZAa8cJnFKP46r3kFQRSYSMk4pMyLit7BB1Q9fAObRyQw9fgH++zbV5P2ncrNYENJEY8v5qDVrdxJqImd/Nx6jcPCVH8jSjb74b3bI36fpY4IiTtkCcVg1s9RZRpgtH6ElPcIKxlaAnTV2fZ+37H40UcchIUTaSElJGFWe
 9tMAtAI4
 mYXlcqyAGauYAWzVdddpfMvPNzbk5sb7D3sIoB+PbtO+PreEsRC0ku5z6aGVR0cRLAi7C94buZUUfC3/gbHe9jTFmtwjTjwB/SvdLB7OLoceJ4Fuk81vAiEHwSdsIXYKBKY+LdT0vjGhUNf+M7S4ebhu17GIrCoEvi86vH1RBU5GNQQBgFGE2F2XLtxfU/NI1NsrWWy0y8lJHtzjXQWcfZy6UnBaRop+TVYE+dLJasWtA1t1SU0jc+cF9xwv3adIk0YgCNTBaU1OizEeKBiUJmq6lYMSMuirFLJE4oHCho7EYLUD5AqljM5GeEStJvbE6OeGs7LzqY+unnRzRyRhumEJI7gLa2bGfzStwHxZLr2VdeXw/h4syCQFT4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:46:21PM +0200, David Hildenbrand wrote:
> On 20.10.25 21:40, Gregory Price wrote:
> > On Mon, Oct 20, 2025 at 09:18:36PM +0200, David Hildenbrand wrote:
> > > > 
> > > > Basically, what is the right way of checking a folio order without lock?
> > > > Should we have a standardized helper function for that?
> > > 
> > > As raised, snapshot_page() tries to stabilize the folio best it can.
> > 
> > is snapshot_page() even worth it if we're already racing on flag checks?
> 
> I think it tries to handle what compound_order() cannot easily handle, as it
> will retry in case it detects an obvious race.
> 
> > 
> > i.e. there's already a race condition between
> > 
> > 	pfn_range_valid_contig(range) -> compaction(range)
> 
> Can you elaborate how compaction comes into play here? I'm missing the
> interaction.
> 
> pfn_range_valid_contig() should be only called by alloc_contig_pages() and
> not out of compaction context?
> 

I've been digging through the code a bit, so a quick shot from my notes

alloc_contig_pages_noprof
  if (pfn_range_valid_contig(range))        <- check validity
    __alloc_contig_pages(range)
      alloc_contig_range_noprof(range)
        start_isolate_page_range(range)     <- isolate
        __alloc_contig_migrate_range(range)
          isolate_migratepages_range(range) <- compact

Seems like all the checks done in pfn_range_valid_contig() already race
with everything after it anyway since references aren't held?  Any of
those pages could be freed (get bogus values), but i suppose not
allocated (given the zone lock is held)?

> > Seems like the correct interface given the scenario. I'll poke around.
> 
> Yes, avoiding folios altogether is even better. As documented, it can result
> in crazy values due to races that must be handled (like compaction, yes).
> 

i'll make this swap then.

~Gregory

