Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6445606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K4qBbnj0
Received: by kanga.kvack.org (Postfix)
	id D4E256B0816; Tue, 24 Nov 2026 12:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25C06B0817; Tue, 24 Nov 2026 12:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C056B0818; Tue, 24 Nov 2026 12:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A54196B0816
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:55:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E8FEC0C83
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:55:04 +0000 (UTC)
X-FDA: 85470763728.03.F8CF0AB
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2220840002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:55:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4qBbnj0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795542902;
	b=guABTKxuVJDj4MSq5by5SfoWNK0i0fAv15iG3ynHu/bRZoLlvJrbLDtP/Y6H9hT/kJb8DI
	rPGti79+1TbDjlJ0wC3z8YRISBPJexIybNOBsGcA6BWhc/PRkk7UD5xLc0c7V57FwQ2NlI
	VirmPHw8tn2OUE8BjgYb7nsVXk/Ejac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795542902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2yxDbU7lOpiFweogZtcA4pKGDUYWG7cArF22khEzuE=;
	b=Cms+KvhPA8HRL7Rjfb3rcvKdA7CP+Ou3EHqDU5kEqTdk17Ji1oVgAwotwkbcov0DOLISSa
	tbZpFwCK1JVgo8W0HwLnaUu6viJH/hIdHcf7cOK+dMSXgzhXg0zqut6Otj0LFuPVklnamY
	MFJuoe2ceCUzlgetW51UmbNlhqM1ndY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4qBbnj0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WAB79C+6SpcJcXgk0rqpViA2L6QwhWPx0WDOvroYZdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795542900; v=1; x=1796147700;
 b=K4qBbnj0YFn062jLpuAS6VoHfSwuSIIpz8YBKCjTCKImMV5ZwpQWPt8XDwLSkO7QdQC1UmKl
 hjsrkT1kI5tfcAjvd7Pll7mnLKqpb409L9UiyNFUavsgm7dSknAZaEKtMzfUj47ztHwybjfETir
 cxpqdrHG6XgiDmH0HOjHfb8s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1aed601a24a53ad1;
	Tue, 24 Nov 2026 17:54:59 +0000
X-Mizu-Trace-ID: 1aed601a24a53ad1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 09:54:58 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awXO66mRuz_BRWs9@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <awVSrbJn00wmh1nn@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awVSrbJn00wmh1nn@tiehlicka>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2220840002
X-Stat-Signature: 8qkui49jhkispipzcrc7idqwas3fy4cr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795542901-996154
X-HE-Meta: U2FsdGVkX1/5GP91AcOKHkIAaAYqg/J/zhYjiKLRYOKXUXrIvQ+2D7s8LToe//MEpFT5+wCCIwyx9PIi98x+43+2zBKXg2bWjyzhi80mr2v80Me0UL+lxbnjSvt1sXhARZ7TjFB1tmHEI17bElNjwS+OPgSG/ik4DX+2/+qC3/uqZMXQ38CewyMYWEh3tIZSKH7kPEf4oNHXc3huZPGK+6Z6WHjsEXizMgUH7mTiCAkxUJJdItFDGry/7+agXz+yLpX4EkmYPr6wfqJNbzWwsnHCAiprIBixf07CLNjPrN6VAQXFRfmr8V13Z7nEOt7YkcGlgls5jpJZlJUNoMfSu4xbMxbSS/EDLCx5upruTKJ0HJVz1K1KreNZz38d8UVkzN5H+N1jP1h2YDUcFQ3sdK6r2WQQdEWX9y2f9gj9ZfaXGh88sLGMd1QNkoo+wPQW849zJHcQGcwPAytrS8If56c04lYXEfarPfcneVVXWtzdkOIgBSFSSOV9KHjQhHuPBbOfCTd7SlFF3l48ggmNNVVQ8QMgIv3vDL6STvUTWlF7sSJXQSqfiqKXEMWZWGbgD8QIMaSwl3e/IENxyDPpGkkNJ3Alnqm6MLVCb2iEIDRvyIax7Ze4zWxafd5u6IRteoao2enFZUtMtdNOpGxjxV+vuqiIwqc+7FYa3Iqshd6lB1gGlfXu4DLyCyI8tCuV1o26hjS58j91NUYC9kWZz9npt8Xynu4W0TpIRQQodPDxQDamdINYoBK3X03VP6mXrBTdCA2ipVS9kg6FzCPIbqAqvtQsPF6/yhtjbXvqQ77m7O+ANr8BeOTjCmGuYVv4gYmdUEaDxg4AotGaVkKiu5tvuvNX3bmuWEnAuDSh0ZEMNfioFaxycFzQDh5SIGPONiwCyAdK136+PL25gSkyE2pZtrF2popj4ffNNovPtpWn3yti7SEaRqHVSsTpAEhWQ92AV4jH6wELNfZr9l5
 QIIO0pB5
 zwRi0mrP5J8eEM/jfVuC34NaFzhKPuU3BRuIjgvDdw3URN0Ph8L4JAMUd71iz2RK5ab+iJWVwgCvkaVMFdZsVdeTWjk6b61ZHj8oq+hm3JGFv4EWh9FLfxmOfKFbLQ06EtlkLpQM102LFdvrlcS0sRAt443J165IT5l24GzOCJjm0iWQs/aJqBAg20eOxVntmLIx8HMDOWpciOOsSlcdzLmS+txFUjq42qWsKFkI/D8KXUJCvSPullXrc8At6QEOtvnsfDBJDlPNuQLE38ZMtXDOU3RZ560z1qfea20qH+y+W7fw2MnKu0AO2aFA/Eqcluzi9EvfwS3Qs7hdEhsOUHCEtFBaW+92fox1/sSu84TzQvITyBOtC7hRS7HwZrNz9VVGqtmEqTzpGXQORTSZ6o8gl9VlQQgwl33Fjix7QeI232Qpn4ULPqKDoJP3HEuMysi3ERcLI2HsWZjhskQUAnbCL6ppHPxVswAOCVvOOsNzjdJVNkgBJRQ8pr6ByGcx24E5ZXIlFmHz+K22KTaU/313vx0ha9KJLYuSRHHbqfrEOlvDOvLrkdbB8VU+FYBnvwTMqRLyR20zM8JNAo/W4TveCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:02:37AM +0100, Michal Hocko wrote:
> On Mon 23-11-26 16:04:39, Shakeel Butt wrote:
> > mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> > allocated. The ID is erased when the last reference to it is put, and
> > that reference is first taken in mem_cgroup_css_online(). The failure
> > paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> > themselves.
> > 
> > But css_create() can also fail after css_alloc() and before
> > online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> > css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> > without ever coming online, and nothing erases its ID. The reserved
> > entry stays in mem_cgroup_private_ids for good, and each such failure
> > takes one of the 65,535 IDs away. With failslab failing radix tree node
> > allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
> 
> Considering these error paths they should be pretty impossible in
> practice (and without fault injection), right?
> 

Yes, this one is found by code inspection while I was debugging the memcg ID
leaks happening in the Meta fleet. One of the biggest source I found is the
orphaned swap cache of offlined memcg. I am still working on the fix for that.

> > Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> > which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> > only set when an fully onlined memcg is released.
> > 
> > Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.


