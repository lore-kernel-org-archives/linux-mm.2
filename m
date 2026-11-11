Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15182606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfLQmTEy
Received: by kanga.kvack.org (Postfix)
	id 990596B05B4; Wed, 11 Nov 2026 13:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9676F6B05B5; Wed, 11 Nov 2026 13:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A49D6B05B6; Wed, 11 Nov 2026 13:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FABF6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:54:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 073B780188
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:54:22 +0000 (UTC)
X-FDA: 85423738764.21.48E6580
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66E8D40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:54:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfLQmTEy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794423260;
	b=ti0jfTKG4H0PXzpPg33Y1ZRsHyWL9of0fXErO9x1UdXVKfWKzvBIuOCeJDqW86yge6bpq1
	xxdUDHUiXMJlij2Z3V1IG8N0HYm1F/lq6GjW21mkTwQUBqk5qwwFhxDOU6XNicKlbVMCvg
	jErOnvTIwSiRX/khuzhc3uST4ypIFEw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfLQmTEy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794423260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZxY6FRy+iKIYaOcDLkICzfkOfpdlmgKNXCeP3oQIdA=;
	b=7FSs6AlqaADNsEMhvVCEStz+0NRMxyrWD8LwluB6u0ZEl05CmPP5MYJeTO2QbT4tG8Nvlb
	fnolOJmK6KI+OAO4+tV/HOiMCp38Cc0Ryw1riAXqENqIiSGFC8tZ4pR8LDTIciRF52idyM
	8XUGGd1RWWsChijje3TghnM3OKSTSJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B58961CD5;
	Wed, 11 Nov 2026 18:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE5F1F00A05;
	Wed, 11 Nov 2026 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423259;
	bh=7ZxY6FRy+iKIYaOcDLkICzfkOfpdlmgKNXCeP3oQIdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfLQmTEyEkOjYetaEk86ZORqkxLgjToheQz9VDFoVBwVZrB/rJa6h9lEWderuWfiQ
	 ULjZbma3rGqhDciaC502VLOZvkQ2w2xErqM0Hog1YFYSl4Rx45zl/ZAd0ri7hH+qrE
	 QtErvf9h8g+tbl8H2VGCQgGiUxktXrOOCgR6qJgXFpuJwyiDiwlNzq3/4FOBJ7+Gle
	 U+l8BYmRkJ4nk8jnkKBSiuaUjytbADFO4Ek9XJKkuXU9UxzuVsmyH+LaQrP5sPgNIt
	 OIJrWa6AiIZyTHrYGmq6W1he/IXInF4jzwG/wDVRVWDLWU3myEF/9tyx/Jq8wtt+E/
	 ruJB9OrNjbp8g==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 11 Nov 2026 10:54:11 -0800
Message-ID: <20261111185412.145514-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179438255225.3134195.10613668244848761847.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66E8D40006
X-Stat-Signature: xsh73hn6tpkmikd5e4di6h3bgrqz4i4k
X-Rspam-User: 
X-HE-Tag: 1794423260-178872
X-HE-Meta: U2FsdGVkX1/gBFgy4cnmg4TxTTXtatMib/oFH0jaomUZU3OOhGTeJkR6VOgwsPcV4ru3/JY2g9hHKqgz2Vv3l60muBGcYao7Ugpdw025fdGwAkjsgbEasrj6bT9pYfWga7u86ByvUzyQBnidhbUoAtxS3KQ79n+d/bn8nWU8BFLwwuXViCyVPPMQNbm5P0Gsp0LDV0b8ZBMZxAKuCvhPz71TeM+2hxT4VC9is6VfXptCBl2O3z+pf2OMn1cRqe77pVeSsMzvOk4pyLO57fNJw6HU+DNw+5mDcZiO0hGmEoMWKnoFY60ojQJm5zTf/ESKLJ4D/COu/nQtj8X2/oBXI4gdlETVodbKDMN33q0mUnpzscAsR5D6yRt53qrkdF3CRKc85EGNP8L3ccxCZGKmzmYwK+cmhabPZE/o0DuSLo4qIvv0CBkN2CUtAE52XkCTQh2Vzp6dL6WgLUbr+VTyLIzu2fZEBvGbd35mEbZ/PMfg4QjT27Rf2XaRR1A7xGTBamu1R/0WLA0w1K+0KTjCmRHY7pwO4IHClOF2eAJ3d/acJYb28p+3EMFXE2Cnnzh2DqVB53rjAuZDjtAvlP8F6SnDeHbvumEyqoWSg72+QKgPEuHCgwE9+NOOOgYE6Hc+hOz2W57Gew7V40Wy5EfhDiPXNbnkTv1XrhC9puvdbhSLEO2F6s0OZb6sJHTq2rrsMUPddBCAsFCmlRePt+AHNacpakVRlQzYM9cWzVLKwedprWv3L8Dn0ZaAaGb6hWGkQ0jZNLPTrD1CPrdf07H43nq/i91AfPYLXw++mYpUqLWVlDt7RmmFksbbVUKZDOuIu8W/zGg2XjrKJjelgh205ZoJMHmtu5y8uxM+AZNTN0tLO5ZVBlGrw7mDmZUZP++ijZAYj7Tdq2sVRPrIVSq2Z6s3/Ou+4g2gX3s/OyBaZ+SZw6PitwCV07lMlGJaJdoH6ZytQpvTBHByUqr2hvq
 8fsHcY+n
 wcOjQ8axqxi1QDKry+JR/0CmsOvEC9mg1jbrCu0XqY3y+oygzNrLny59spqQjPmxlFknslND5K4cA8l1xWgkkUmRLARVSrXG13b1vpftGhVBiZmueV5KvQFqenMQqas+PqdPaRbJPkb+pzymCK4gYbIsr/6Kedpkk+N8aIzzEHeKHMI9Wn9MCMBurWd5Bnk1a7bqZObZoYcE9Yfbcs3Uvx9iyeHLdk38aNZTxNCSV6WmC71Tp5994bBH/tzydTfNYRlxcAZhsDrZLwd+rEHwEshhV9EnZSWWG9c8wqVnjZKLucJEX4fqSngS9sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On Wed, 11 Nov 2026 18:35:52 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park wrote:
> 
> > +The data attribute probe supports the reports.  The probes can be configured to
> > +hit for a given memory region depending on the existence of specific types of
> > +reports that associated with the memory region in given report buffers.
> 
> I'm wondering how this would interact with the region size.  If each
> page of a region is reported with probability q, a region of s pages
> would hit with probability 1 - (1 - q)^s, so a large region may hit
> more often than a small region of the same access density.

Thank you for sharing this finding.  Seems this theory assumes the probe will
hit for report of any byte of the region exists in the report buffers.  Under
the assumption, that makes sense.

But I'd say the assumed implementation is not realistic.  That's because DAMON
design does probing for only single sampling byte of the region, not the entire
bytes of the region.  In a real implementation that is aligned with the design,
the probe will hit if a report associated with the sampling byte exists.

> The page
> table accessed-bit check samples one page per region, so its hit rate
> doesn't depend on the region size in the same way.

I'd say it is not because it uses accessed-bit, but it respects the address
sampling design.

> 
> A quick replay of the crediting rule of Ravi's RFC v4 [1] on synthetic
> traces showed a similar trend.  The adaptive regions adjustment would
> mitigate this to some extent, but large cold-only regions still kept
> high hit rates after split and merge in the replay.  I'm not sure how
> much it matters on real workloads, though.
> 
> Would crediting the hits relative to the region size, e.g., reported
> bytes / region bytes, make sense to you?  It would need probe_hits
> wider than u8, so it is not free.  If you think it is worth exploring,
> I may run more experiments and share the results.

As long as the real implementation respects the address sampling design, I
think this will not be needed.

Thank you again for raising this question, and please let me know if I missed
something.


Thanks,
SJ

[...]

