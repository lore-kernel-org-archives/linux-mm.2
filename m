Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19C5FED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582406B00A1; Fri, 24 Apr 2026 16:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558FB6B00A6; Fri, 24 Apr 2026 16:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FAE6B00A8; Fri, 24 Apr 2026 16:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347456B00A1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:00:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED84E8AB0E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:00:11 +0000 (UTC)
X-FDA: 84694515822.13.B9096AD
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id BD961180012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:00:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lATYIi50;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777060810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKqBvQFy0haKdUtjK97pLXW69B86nqbjxH3fSUsXZ54=;
	b=cWIGKJMJyu+SunGhx48K+knMktYaLEm3+uxylz1p00DBX913wuARFiZ7rckBKXiq/MSviU
	i3H2X8jEVs9i6Cr6mLqlDUpUneTtccMkfzL6XPdua9rq84hpJs/ZLzlkbb4c72OwB0OIf8
	iDWLIefQVBwtEn0Uj/fZRwErPNwZsUw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lATYIi50;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777060810; a=rsa-sha256;
	cv=none;
	b=syDy9L8jJ+kg7OuSCSvymSoabb0gu7ZtUQuu8N44zVuFKiq37HVdc8Hg0Qbel5rIJguDVr
	QGUJc4hm4AWG5GulHisp1shOJZGXyWargBNw9+0I9dSv+1qyDopMoyX26WdCeXV+2Koh/3
	6Ho8SoitQ4pkQDpFud7zJ1ThYZBK/4A=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50e63771d91so66428061cf.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1777060809; x=1777665609; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vKqBvQFy0haKdUtjK97pLXW69B86nqbjxH3fSUsXZ54=;
        b=lATYIi50bdjvwVTjvncy1GSOWSkAemHm9AITYrqxgkdMZ8jN/zYnak+Gd7kF01zgj8
         oLn9Ue2E16EEgWXPI75zQ+BerYN3hIuwP2RIzbqOyRkuVfMY9MemFkwgg6to0dR6WY93
         XO0sh9C34W5PmmgqKpPalLcG0At/vy+nJr26KSDXsPN0Ntw6c27ZQPTXqKS5ObiY3xRl
         b1Wpa2Tvs7vNEUS/ODWLhZ04/3UR7VPXD5QRem8i0KtCP+bQAq6egNeU0cmLp7r7/VxH
         5jvdRjo9qAeHGpE2Rv1RtpyUDW+xfaAG4XiKo7p4Y9Tqcz2M2Kf/q6IfYWH9kjnnySZg
         3zhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060809; x=1777665609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKqBvQFy0haKdUtjK97pLXW69B86nqbjxH3fSUsXZ54=;
        b=htULIOL+a5C3Y+MzWPoa4NH59DMsOUoAbHvLdq7Bz6LWTVlkjYjvK+b8blj4jEAXaw
         KN/2zW2Au6lQr8xpU6dZbfyax9H5WPGzY51w8QT/N/3zRlWGw85/A6XM3kMvRpv50dKr
         wMGVg/nr9/WIcXTBnW+LSkFTyvFrnKSmULTByrbzIqOqSGWnYJsh+jbzGmEQhn3474F1
         m4dUxRiwpoIrIRb90bElE6Ij0gEKDvbLEqLzWg3Zu4uysBGl8yGnBmcWti7AL7OIsCAs
         kAaf44tHIge45GJRyvOa4yrl2/tslS9QQ8Sjd8KkuHgQVcWcgzzCyTBdswWSqOjYPV47
         bR/g==
X-Forwarded-Encrypted: i=1; AFNElJ8/Ve+lmdAi88jlNTWbOX3w4sffmtiA1fjWUqoiIUBwh3bWSirFNOx/Atz5RyGAHQYtx8J7Q7HQag==@kvack.org
X-Gm-Message-State: AOJu0YyNJl0sRMrz8RVRwmQQppcmO+2+ztaVMisNn5PvaumL+DNu4th0
	TscZKE2hZiY77CUJe9f960tP+IehyIzCH7e6t/SnYoeND3YC5aOIvHyim2yVk4rOFi8=
X-Gm-Gg: AeBDieukMvI7YSXPqPh1B69edX4r2tRcR4odLnmkE6js9SXuu+1LgXcin2Siu/ob0uX
	6b/2uyIIpUg1UOG1gq1IzP0phUeaBPK2DXZTnuYn9d79E9QyFhoUiX7WQQIw1y5yW0BnP5lGwMg
	gvLA0vLoDdh0xxpfghSb47+g2wvx0p67KwzTratHwrHyB/3w8vUV5z0pv+qpPmFTj6GqZgngZUm
	PgG/iyHsmqTTs4D06wdbqdkL3yQ2g3lEl7rK8ULIh5jf4h0dfXOqIopa037yIrLa3cVC3Fftys2
	Vj90e+errNIP8KvHNhVs0P5GpTbZoUeoiwNz1AKjp+x6gUgD0fCpjrfSdHvuLwyT+x3dvPfB1GP
	ZK8i/r/zB9SBnaNNb66Bg8t/Hfk5DcKWq6YFOTfMeYzqn9a7dDvjmxBxGblH9mtsVUdtkyFWmEy
	Mgbtrawwfvppa8v6cMICDMV49qiaIbJNzq
X-Received: by 2002:a05:622a:848e:b0:50e:5cc3:6f42 with SMTP id d75a77b69052e-50e5cc37bedmr276335431cf.59.1777060808338;
        Fri, 24 Apr 2026 13:00:08 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50f13ba2509sm129707921cf.8.2026.04.24.13.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 13:00:07 -0700 (PDT)
Date: Fri, 24 Apr 2026 16:00:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Page cache tracking with the Maple Tree
Message-ID: <aevLw0DsPOEeRd-J@cmpxchg.org>
References: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
 <aeKO6bKupHa2bgWt@casper.infradead.org>
 <aeaKAxrAUtfwM9ns@cmpxchg.org>
 <oi2kit3a2qulr53c7j3h4g3cjjgbss4kd2djdqota2sriiaaov@7uewnraaq4gk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oi2kit3a2qulr53c7j3h4g3cjjgbss4kd2djdqota2sriiaaov@7uewnraaq4gk>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD961180012
X-Stat-Signature: rza38k9gctno4dqdrhmte7jt7bd7p4cc
X-HE-Tag: 1777060809-95740
X-HE-Meta: U2FsdGVkX19LPPvxeucSNhxUHItMSisk2pHXrdX6ui9KNLPcFLXCKzKK7xp7pAWC14YD5/g4H1V3K0i4bi5nMD0nkb9snu5Qua+UQ/O2xfz3nl0H4Chx7BGa7tCfSNQXjGH8TTKPxQ4lCWJd9GtLjKBmZwBSm6S0gs3bzd1k9OZPLpfyVlcWgXr4fUOxUlwUmViAbHUmuMMf1uKY51OGJPJjCbEmtu7LRclZw0hdMx0DHrc/lD+9fP6x+ZWzKinzhkuODK54s97Rmo2cYagYWliugMSfYY8SPooIdGLkLXJRXAquTpCqs7LjfZJaYGaaVtlj7zfhDjeUev4ZyMlqJFCq9LQ6pEEKzB0dvfltAIhXxdiAwayEhol6L7AzOcMNMnnQoPu3JogPah3DAtVbqDJhWw9r8ADoltM4W7c1fNduez1gfiWmscxWyeg4sEIYrw4nTeODDrNvN/Iahqua9i/mBWVcrFo4FfA+Fsy5G00XP25+lPYEdIObgquB8qH5j37BGf3WLe+oAQ0jjlqEXlJmcNZhC2dCY/2T9ajsAGyhxDr4CBrdCztKAzcX7k0KSTSL8hIakcULb7sadlm7mM5xyMBRwl99J9OHEfFwyxWVjpYit1G6ZoD7zPpA/eRzUPdm8qLcoE23EnYabmjsAhxESpLgt6YAt2tdMcs/hKRZj9UeP60JkMH6c4AdkoaQ5jXxzSlPXjUex89RiF5uiWrayrRdwZsbK3WN1m9q/fDtRE7Fy1ONc1WwVOFOQzycgfM+lJhxV9OQX4ZOali9zQpWJK7VGBC9AokVgNOhUdgqMqGRHTyNYRQDLzCnBMciNlbh74RIdyUl8oDk4FXgGkRxCelguRA/jatQO0y3N/2vZXfCn/oP5kaalmKDsS34TpnSCwHMXbGn/IbrsmgyjCvg1f61v+nujb6beHQZGJQQcJex9BNcGCGPQEz7mQgVz6FfBV89cud2YVcRobK
 4GdupGvS
 qE2OrJHIADx+KH1wt7gmGLUkurF4uhT+GeG3VRt79gzQsCn12MFcLt4SfOx+1cAUvosXnranrH2A5cilaIG4lBIoFwGVS+C0sSpbNO3nVQzqECfKroah79tGuFPe7T72K4G7eHThWvglHI95vZI59Y0SDcYN4wK+JOSHS6tebePeq/GgKKk9hsQdR4VOZFBy4rQK7TklWxhofHB/12gi5QP7PgNqk0bjaGVpKsK1mzD2CUTpSmljkk7Zvn3VolfwjoLX1WmeBTdzUnVCvs05D2qdbxX8lMLNI3Y6ZdZTrGZfmG+Cf6al35RMDXNzxuzVhhUnE37/0Ihv3bmAEEeQVZ36EIfXQusaKpvJNgq+V8m7Dxnb/mt2JnPa69eUizDwEmE+YzoIfswUIM56+suEI+7bHXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:45:32PM -0400, Liam R. Howlett wrote:
> On 26/04/20 04:18PM, Johannes Weiner wrote:
> > On Fri, Apr 17, 2026 at 08:50:01PM +0100, Matthew Wilcox wrote:
> > > On Tue, Feb 24, 2026 at 12:10:26PM -0500, Liam R. Howlett wrote:
> > > > The Maple Tree needs some enhancements:
> > > >  - Support for purging shadow entries from the page cache
> > > 
> > > Liam and I hd some preliminary discussions yesterday around this
> > > and we'd like some feedback if anyone has time before LSFMM.
> > > 
> > > For those who aren't aware, when a folio falls off the end of the
> > > LRU list, we store a shadow entry in the page cache in its place
> > > so that if we access that page again, we know where to put its folio in
> > > the LRU list.
> > > 
> > > But this creates a problem (documented in mm/workingset.c) where
> > > we can fill up memory with shadow entries.  Currently, we embed a
> > > list_head in xa_node and add nodes which contain only shadow entries
> > > to a list which can be walked by a shrinker when we're low on memory.
> > > Ideally we wouldn't do that with the maple tree.  There are a few
> > > options.
> > > 
> > > The first question we have is whether it's best to keep nodes around to
> > > wait for a shrinker to kick in.  Was any experimentation done to
> > > see whether eagerly freeing a node that contains only shadow entries
> > > has a bad effect on performance?
> > 
> > Hm, I'm not sure how that could work.
> > 
> > The LRU order created by readahead makes it highly likely that all the
> > folios in a cache node are reclaimed/made non-resident at once. Going
> > this route would destroy a large part of the non-resident cache the
> > moment it is created.
> 
> Not the moment it is created, but the moment the entire node only has
> NULLs or shadow entries.  Meaning it's removed the moment the last
> entry becomes a shadow entry.

I'm saying they can be often the same event. Readahead means LRU order
matches file index / node range order. So there is a good chance that
reclaim batches will create all shadow entries in a node in one go.

> Still much sooner, but not as extreme as just dropping them immediately.
> 
> > 
> > The goal is to garbage-collect the oldest shadow entries whose
> > distances are too long to be actionable at this point. Specifically,
> > their distance to lruvec->nonresident_age (per-cgroup, per-node).
> > 
> > In the current scheme, we just go in the order in which nodes became
> > all-shadow - oldest first. And we only do so lazily when the
> > non-resident cache is far into that territory (cache set vastly larger
> > than available memory). That gives us confidence that we're mostly
> > dropping very old entries without having to look at them one by one.
> > 
> > We don't have to stick with that design, but whatever replaces it
> > should meet the goal, or approximate it well enough.
> 
> The goal of garbage collecting the oldest shadow entries based on the
> nonresident_age.  That's a broad target, which I think is made more
> specific within the implementation to 'groupings of 64 shadow entries',
> which I bring up later.
> 
> Besides the locking improvements that we can bring, is there anything
> that you have found doesn't work optimal in the current solution that
> may be nice to fix?
> 
> > 
> > > The second idea we talked about is that the maple tree is much more
> > > flexible than the radix tree.  Having even a single folio in a node pins
> > > the entire node, so it's "free" to keep the shadow entries in that node
> > > around.  But with the maple tree, we can be much more granular and
> > > delete shadow entries in arbitrary positions.  So we could (for example)
> > > keep track of inodes which contain shadow entries and purge shadow
> > > entries when they reach, say, 10% of the number of pages.  Or 1000
> > > entries, or some other threshold.
> > 
> > It's not the volume or the concentration of shadows, it's their age
> > that makes them good candidates for garbage collection.
> 
> Maybe I'm reading this wrong but it seems workingset_update_node() adds
> nodes to the list that is composed of all shadow entries (or removes it
> if we have changed one to resident).
> 
> Doesn't that mean there is a concentration of shadow entries since the
> entries in the tree are in order?
> 
> That is, reclaim is at node level granularity, and the nodes are sorted
> sets.  I think, sibling entries aside, it's fair to call that a grouping
> of 64 shadow entries?
> 
> This also means that with today's code we are keeping older entries over
> newer entries because the node has at least one resident entry.  But
> that's fine, because we can't gain anything by removing them today.

Yes that's a great catch.

It's the last eviction, i.e. the very youngest shadow entry at this
point, that suddenly demotes the whole node to the "old" set. And
there could be much older entries in circulation that just happen to
still be next to a resident entry.

But I think this would require a pretty spectacular breakdown in
access locality. More likely you get mixed nodes when individual
entries refault. And yes, not much we can or need to do about it,
since the resident entries pin the whole node anyway.

So the question, I think, is still: in what order do you reclaim a
gazillion all-shadow nodes when the time comes. And the answer to
that, IMO, is still best approximated by going in the order in which
they became all-shadow.

