Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B98F532EB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F76D6B0088; Tue, 24 Mar 2026 03:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF4A6B0089; Tue, 24 Mar 2026 03:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5DD6B008A; Tue, 24 Mar 2026 03:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F92A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:58:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A634D5F89A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:58:24 +0000 (UTC)
X-FDA: 84580204128.21.1510D73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E43C6140002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:58:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BfYtF0MN;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPhVFv+TwC89kzECYtcnuzxoRCqzsAd/MZtxs/kEWb4=;
	b=WekXSN3dm0fyZ5Oidb/8b2MnbydppojnEsJBbsD0xyF6Rd1WMgxmktrSGQNwGZ5hKOpfvk
	YYbrH0UzR9vBVw2IDIy+r4Kv0SIryQWqkX7pKmmWN8wvi3Qnf4MlPlHxcKtx5I2sXPeTgz
	YNmqs+nHx+V+rqiyU0+0v333JUhtBWk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BfYtF0MN;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339103; a=rsa-sha256;
	cv=none;
	b=cXq0oPrDCihmpGbcGk/VvXz9f6DOHDts8pr0NldVyMRdeznIC6cTsRVhy0gO1La9vbilJ/
	OIImqd1kHZq2iJJWle0XY6Zy6UqzwmHCOyFdy0N4USLShVPVtrjeCrrkqbux5v7xxBFRxM
	G1PAgIQQe3IbR5D6XU7lcyYTFQMKUVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D13934012D;
	Tue, 24 Mar 2026 07:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F238C19424;
	Tue, 24 Mar 2026 07:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774339101;
	bh=hNlIhMrnoaeK7dW/zd8nU5BBV1Mm3cRRYly6T6Yi7ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BfYtF0MNVdjXZ5ZsElUjeXglMH7FXgwoQMkpDxwKn2c5N5x+Hy9C6jOoowjeIUlrN
	 bJx0jExABLbSFr4+4+HmklH4/tRgFc/uH8Lh2EJaHZqVe7BmDKGrsrsB7oyp+cDoqB
	 t31YCOL8U1WW3VkKDgjtkwSTPjM8V/G2j9QXVEXM856Jts3hm/JFg7kOYPBwovk1X8
	 vT+JCTzsLuIBPXg5gBjjSXSdcIkFPO6a4H+5eoVBtDHxUx963SpJYIu9UknYf9ilFB
	 VNvBhS0IUWPpvcUbnUcll3BVN1QtdNIaf2t4IyeXhyIhb1maDtbheV9P8luq+5P/fp
	 RgpC/Cj9FWxdw==
Date: Tue, 24 Mar 2026 09:58:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <acJEFArj6uw2Z_2e@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
 <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
X-Rspamd-Queue-Id: E43C6140002
X-Stat-Signature: 8uktxff74xt3w35z5jijzthckgxy33uu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774339102-703185
X-HE-Meta: U2FsdGVkX1+/LTxPlsm1Q7SukhIwzeP/i7qy8VDDUNaZWC0gzboc8a968qT+4z6mCJxjsaPKjIDPcQmmBFvHhUaPYT21PcvgnfhT7hqQowLL2qqGFVRtO/hxamnx7VOW8wBrygmWP+lm7WAkWobdRdqx83UOfW3x7rYksnhYwQbm5OZBsgXmlL1FAkRqwQ5leXyZXt9M0iAmFFl0l8KBr5+tGK61zMzrfUaBpot6S37ONB2XNqcK/cC9H+5l+6K/8Z7psH9uIC9VDEogLRopuOxVJV0eqJTNY1IBLbXG53nWrGgpdFiDXR8Xo5nw73+/zMrw4CtePIQaVcJJQsYzo17dr34UWCaEe63o4Zx3nNJZiKZ7r+Zy2cttL/Om9lzApdqlYZGk37BWq8un6KS37FR11R7R+EGBHMaadTZPUBySBQzy9cR8kJWkltToZQGZ5+k6v+iFYn5BCw1ip628GFeZwV1UkRJ0DwPZX2aKXWwc0zg//y2BnuVJPszC2scUH2G2EaEYr92ikDiBtMENQRBar7ek2kaG8a0pqZCp7X/JF9FiQ0eO1gpZ1JI3xeSnrvg4wJa5HRKOFsmpd4DtgGjwaJxKvRU27dDzJdnpl876Km2G5zTBShFA9i9MZhqwBHaUW+RbvSVp6V85k28p/moaqbKoKWS47xPqN0st3eq4PG3BN1Y5Ob90V9aWt2Gb94Vp6hxDtIC7brvOOmKzZBo/ZBo8WXpKuEop/21Kmr21VcPWqvDqWH+0W1Z48BRajz+nnxELOfMGRTGLhoIJ8Qhpsbb+z4sB6l+J8ynch9cIe/Nh3urt3TC48txmT2XC0BnKzhDvpaeISKdbOQPZQeduk90piWB/xeyqRBJCqQ/k41yszmnTUP9NP+BUIUhebOuh0l0Isnr0ntb4sqL/esdIzHR+zkiWgS4pacdncKgx16jJ5AQDaMBmx68QYUsULhdA4G20O60L8epjT+a
 yBfLQ8CB
 BIfRRsuo3Mboviculs/53QoHZZvcmi+62n7rhOKldO//Dh93/Y26lyQnYAKqMb611OYzYVjTiwxIY9z40NPrwkZzrXr+gDtz7DAJdHx99zx48+/l0iX04pXZKpkHA1WtQ43zGcDZRxalXTfaja8qbuuOXJnknMZYASbyCB9Sm9JKGEcabwegnRrA9Jkil4liy6Gt9ArEOojavtDgfqBtsKg962WsPS74Sg2HkDYwRZHEaOnVZxobrJLRJLWh94dKdpDklZipv0aUpeKLE9tz+BQpwhBPvgj/ZMMPB4YSjfrDa1PHr880Nzo6GOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:36:04PM -0700, Andrew Morton wrote:
> On Mon, 23 Mar 2026 12:34:31 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> > 
> > FWIW I wholeheartedly agree. I don't understand how we don't require proper
> > M: or R: reviews on patches before merging
> 
> I wish people would stop making this claim, without substantiation. 
> I've looked (deeply) at the data, which is equally available to us all.
> Has anyone else?
>
> After weeding out a few special cases (especially DAMON) (this time
> also maple_tree), the amount of such unreviewed material which enters
> mm-stable and mainline is very very low.

Here's a breakout of MM commit tags (with DAMON excluded) since 6.10:

------------------------------------------------------------------------------
Release        Total   Reviewed-by   Acked-by only   No review   DAMON excl
------------------------------------------------------------------------------
v6.10            318     206 (65%)        36 (11%)    76 (24%)           10
v6.11            270     131 (49%)        72 (27%)    67 (25%)           17
v6.12            333     161 (48%)        65 (20%)   107 (32%)           18
v6.13            180      94 (52%)        29 (16%)    57 (32%)            8
v6.14            217     103 (47%)        40 (18%)    74 (34%)           30
v6.15            289     129 (45%)        45 (16%)   115 (40%)           43
v6.16            198     126 (64%)        44 (22%)    28 (14%)           16
v6.17            245     181 (74%)        41 (17%)     23 (9%)           53
v6.18            205     150 (73%)        28 (14%)    27 (13%)           34
v6.19            228     165 (72%)        33 (14%)    30 (13%)           64
------------------------------------------------------------------------------
 
There's indeed sharp reduction in amount of unreviewed material that gets
merged since v6.15, i.e. after the last LSF/MM when we updated the process
and nominated people as sub-maintainers and reviewers for different parts
of MM. This very much confirms that splitting up the MM entry and letting
people to step up as sub-maintaners pays off.

But we are still at double digits for percentage of commits without
Reviewed-by tags despite the effort people (especially David and Lorenzo)
are putting into review. I wouldn't say that even 9% is "very very low".

> > Like, sure, sashiko can be useful, and is better than nothing. But unless
> > sashiko is better than the maintainers, it should be kept as optional.
> 
> Rule #1 is, surely, "don't add bugs".  This thing finds bugs.  If its
> hit rate is 50% then that's plenty high enough to justify people
> spending time to go through and check its output.
> 
> > Seriously, I can't wrap my head around the difference in treatment in
> > "human maintainers, experts in the code, aren't required to review a patch"
> 
> Speaking of insulting.
> 
> > vs "make the fscking AI happy or it's not going anywhere". It's almost
> > insulting.
> 
> Look, I know people are busy.  If checking these reports slows us down
> and we end up merging less code and less buggy code then that's a good
> tradeoff.

If you think this is a good trade-off, then slowing down to wait for human
review so we merge up less buggy or less maintainable code is a good
trade-off too.

While LLMs can detect potential bugs, they are not capable to identify
potential maintainability issues.
 
> Also, gimme a break.  Like everyone else I'm still trying to wrap my
> head how best to incorporate this new tool into our development
> processes.

It would be nice if we had a more formal description of our development
process in Documentation/process/maintainer-mm.rst and then we can add a
few sentences about how to incorporate this tool into the process when we
figure this out.

Right now our process is a tribal knowledge, having "Rule #1" and a few
others written down would help everyone who participates in MM development.

-- 
Sincerely yours,
Mike.

