Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA52C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D1E6B008C; Fri,  7 Aug 2026 15:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0AD6B0092; Fri,  7 Aug 2026 15:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF106B0093; Fri,  7 Aug 2026 15:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032306B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:13:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45BB3A0198
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:13:45 +0000 (UTC)
X-FDA: 85075422810.03.D62D55C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D6E440013
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:13:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fKfxsdtF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786130023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJYGVFI+AMYRJ/HMDjzVs+LLOKd26PLu0JdeojtQXvw=;
	b=Nyi7Zk0Bul3UN0iw0bW020f3JOmptN+auFMrDXSfS/OWsg0s1MPgeisVLswyRDzgBaehFW
	Vo4EIJeytuCTuyDWKQbuLYbw3AzgwIwLWin8CMDRlt75lLUPw0g/crwGA0SZRu9kPeRqar
	7/Ylg3kX6HxcW2RFX6IgS/1XTjn7ETc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fKfxsdtF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786130023;
	b=n7T+/wLhe1uPPQtTZcHLsYCNzK2WSHjSd6CkEQYENaIsyVW4B/a0bBzdeRrGRDAPmroYYg
	f9szguU9Zd+T6d6rw0kBHFXGJ0aH3w7/P+6D6g0q25oEFQ3EKDHRlm1Vcqst8rufgtYj9x
	J85TbOsTvJLU3uUbiQqbzrlSYBFW8sY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786130022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJYGVFI+AMYRJ/HMDjzVs+LLOKd26PLu0JdeojtQXvw=;
	b=fKfxsdtFEbmRp6+B6n+UDH/I2PtOdq3/ooBBOxxuukKYo+0AwYNHF9bc64EiqadWwr7Hh8
	nAFmrAQGoL7ujoeFzSa0gxZWfwdCc09G550VXbybuZc12Aw/aYPs5ho/Tw7HzkkRPhgXhl
	W0rnR5oVkzOWsOr6BN63MazCueZp/v8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-FONeiBgkO7i1sT07L_P4-Q-1; Fri,
 07 Aug 2026 15:13:29 -0400
X-MC-Unique: FONeiBgkO7i1sT07L_P4-Q-1
X-Mimecast-MFC-AGG-ID: FONeiBgkO7i1sT07L_P4-Q_1786130007
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F11E195608E;
	Fri,  7 Aug 2026 19:13:27 +0000 (UTC)
Received: from fedora (unknown [10.22.64.85])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58D84422;
	Fri,  7 Aug 2026 19:13:24 +0000 (UTC)
Date: Fri, 7 Aug 2026 15:13:22 -0400
From: Audra Mitchell <audra@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYuUpgvsUGZcGMQ@fedora>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <anYoLs1B0MwUNR2n@tiehlicka>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: jS2_UTqGkh27GdvJXD78aloiyt9zvLk9OKfOOBKnmT0_1786130007
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D6E440013
X-Stat-Signature: 9gnea8aubg5g14b1tmphat7ua3pprgkg
X-Rspam-User: 
X-HE-Tag: 1786130023-397816
X-HE-Meta: U2FsdGVkX1/7er4Ooc1xroLlDRkLkaiy7x//HEQ5HeQtHcZuzcbR69s0S7d3bu9wZ+mN9RZRLAYXnTgMWEXMNx6JZIq77I58EsxLTszE/rWJFcps/Wt4SnSZEsQS2A82Win7y/2G57uWtmIlHKeEppWiZwatJvWwfLAxSXfMIUr570Vgq14YgKVdB9k5pELCXvBAoxcAYN7Z1G4PcrcRn3rnxsBDjg884+Hm10L95RtvRh+aHW10eBCdyLJ28x03POkhFPW/AdmSWrX3T8T1GicHoHa6iprXcj7zSoESir60CJyY2XBpkCIzzea33SMdVuJ/TVnL+MWUl/47Ka8DUHbqBGGFwT3AE2wDKY3TFuLLC+OjJt+6oahYlGPVEpW3Ni0dh5g7IlexFBUx5i8n3+48s3MWjCOCkBoL/WwLgMDqolxq+VC9GRJ5UD23GO4XdobsSpAzLuC6pZ5LymJl/BNaYbcyxMedbvEHKOOChYTa2ndYok+j9b/7zAirn4Pvl0YACwREup+Xly/7Zu/wWIJDAoigcpjNg4P3gbYH0XqWMRlk5/fDNajzg0Wq09l7KfGIVW+4X4UCORczjC92qtF96hXdZRUUG9r6IsXhXl/fN2hfxGyY7JCxlsAPu5n69PSvEj+1v+hLQD1fOh5SsdVvlwjdCYWuLioUIaFxoefgp8pbWyCiDV4xdEDBgyK4YQM7doayFc6zERuv8ju623uijGzM4o+us6id6Uq1JcqgirwKrv4Y59fMG9ra/c34wrBstx2As76tYsRIflDrjRmPvAKyblepMWd9QpDLCgSNhXFDArrgeSFA1lqNq3cGO7+h4cXJKXxyCdfF755V0GHK0Yq6m01VjutgwodBYncgsjN5QgG59wzAGdRQJnctuUIdlm23WUORukw4pENoFUxuV0jOemzOjXFL1B0IftyD4+foknmhB6TweB09TzpGC59hVWTjWP1iAgtStQv
 gZ/JHVar
 DR93MVD9610ZDjb3FHCsJXLGNCAPNWesKftaGnmKfxCML1z9FeuL5WqtV4MpOeMcJ5KeSsT/hTZi0JZAWZDp/DgT7VCPZsgXO6ExI/trlK+aiN6G3gKBr6aBtuiVTwN5OCow1AtZUcqn0bfX/EA7uF/XzHcjMD7ACJbvrYArj17c3nYMP7Og3oDUubwOZgn98/ybLbMvupNg5QBYjarzDGiNpJUTWAWR3x39SIM6+q4Xpryyi31WFz4eqRmcGSpttAgrn0T3GS2vFsjT0yK5wydBKgzugTq6nxGrR9OMn9CcraTPTf6CjmV1LKHq+hPPJXq2Ufy1rNAYRcB2ip/Os/LijjHbdqFaUz605ix7eCyTAuZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> 
> Well, both global and memcg reclaim share the reclaim logic. Both of
> them try to exercise all reclaim priorities (i.e. check whole eligible
> LRU lists) and they fall back to OOM killer only if there is no other
> option left. For the global case should_reclaim_retry is the gate keeper
> around direct reclaim retries while for the memcg we have more or less
> fixed number of retries.

> From what you are describing above those users might be hitting reclaim trashing.
> I.e. last small portion of a reclaimable memory is bounced back and
> forth for the workload to make tiny but steady forward progress. While
> OOM killer might help to stop the suffering and restart the workload
> sooner I would generally recommend revisiting limits set for the
> particular workload. Especially if restarting it might lead to the same
> state sooner or later. Watching PSI metric would be a good start to see
> how the workload behaves wrt memory stalling. User space oom handlers
> might be a proper measure as well but that will always be safeguard
> rather than a solution.

Both of these recommendations were made to the end customer, with a
significant emphasis on reviewing the workload and the limits in place.

However, while reviewing the code, I was truly surprised to find retry
pathways in try_charge_memcg that do not decrement the counter, such as this:

        nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
                                                    gfp_mask, reclaim_options, NULL);
        psi_memstall_leave(&pflags);

        if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
                goto retry;

If the intent is to have a counter of nr_retries, I am genuinely surprised
we are comfortable not adhering to said counter. The patch is not meant to
change any heuristic, but only enforce a counter that is already in place.

I have no real dog in the fight of pushing this change to upstream, so if the
patch is not desired I will let this lie. Thank you for taking a look and
the dialouge. Happy Weekend!


