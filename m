Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586D9C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200436B00D4; Thu,  3 Sep 2026 06:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1B16B00D5; Thu,  3 Sep 2026 06:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1176B00D6; Thu,  3 Sep 2026 06:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD1FF6B00D4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:45:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D30C1404AA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:45:51 +0000 (UTC)
X-FDA: 85172120502.22.16A890E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE65B1C000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:45:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGh3WhUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJtCxr6SsmG+7oqPAO3/fjLakFwcn/sSc05iILsC2RU=;
	b=DIx2ArHVXzsQE0koFsWp74pz1Mo1DNQm6cRN23hQsgAQ/15IYK2jPTUKViOrbcGyXtJCH1
	2xzaG2cGrsSLOn8yPiSK+w+q2Mkbts12dKpyiry8vI27G6dxpxMHUnZjHZKm2soWXIPe0L
	oozWJ0gOy+rTSmvbe2gk82rOtRaw/xQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGh3WhUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432349;
	b=UmYluRA637OnQk8TocEdPap+1Mg/jr5LFqpUuVRa8ICF4ghQkkh2J3qcIN29EM0T030S5o
	D7EgKHXMPhVorS2oJe2lFLl1T/f0wlWRnZOHiFSnuMjL125p6snMCMqVVrggs7enOR0AP7
	mKqMyHCMo7Ci7EnTNwmY19jzaKCl7tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C422600C8;
	Thu,  3 Sep 2026 10:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DC1F000E9;
	Thu,  3 Sep 2026 10:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788432348;
	bh=KJtCxr6SsmG+7oqPAO3/fjLakFwcn/sSc05iILsC2RU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oGh3WhUToaQ5eeaXV1j2TAW1tA+oR/lSfzzF+1AQPmatJDqSYxP+bvGRp+w+NpWt5
	 78mjd3UYllWUZ/OiCqark7/aQmfpiprMWu61PvYCxedV45JUjvOdl/OD3GOAJFk35K
	 BHLHxoDosBmZ+b8042lQDw2C6ZvwYEgt1gpfrKIxP/zZglsAHR3JoVdPeCSfBvQQwu
	 Te/fNBfGKwOL7PzqhdfYGQHDLJDsRnntRlDJLRDODBTVKA0r1BGfgBoNL5u/v9Umeh
	 BRDFpmTPMobmUQMehL1zRLUWObxFxaCwQ+fklPJxkVSYazAvDG0AqA+XpIVbxxoy3T
	 KcP6xVcG0N0dA==
Date: Thu, 3 Sep 2026 11:45:42 +0100
From: Will Deacon <will@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Message-ID: <aplP1oUjx96O_I69@willie-the-truck>
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jfb99ix7nyq5di86siguagusq3uymcik
X-Rspamd-Queue-Id: CE65B1C000E
X-HE-Tag: 1788432349-193577
X-HE-Meta: U2FsdGVkX1+M8p6N0d1qnnuW8et/vpY24eNT2mgZn9aiheWiQvGejXS9CwxzNDiKZ4qIOmJVQQew2VnU35GvsS9UcU6jkwcuBsC7+y/m4if5ezk7TohmSB9JMDYdaEyYwA83BL5i4O2vCyMtmSFVbU4Wz0/pqAAduXAD96yqDngJ1AKxSXC52vohPlajyneZ0lTifnA1aWSyGfvZfB3ET/wkp/i7s2KAClF1TvdWKQYtYSpvA56bHivAkkNtC+ZGWZmaRbpUw69HicgLcensucyWuaXTTo9ME9kbw7b2N6nG5/uD6FXt0sYvKadzIvFY29lNnAb0o0QegxcrNW/cP/NG9bEsxx9n/YZk1mXVGPfj0hLbpe07HcaCjxM8zC7nkHOi0IjXNVG2Bxp1md1OVTRFZp7OQ8GQeLCzzQqlYByRzo9lG5edm2NnRhczkdR9nPi3nqF0ZyFwY6lbB7hsVXcBRyLu5iTC2oxz53eVs2ioIqG9mDFAWCaIVh9K2NoEANxWIDC0+8+uFuVWA2gh+MjW+5QnP3a7cl44NUbsalD3j9bzeWa2cs0ICbxHyeAgcjxFc3dQcaj7G8+XuykuRgPwe/7hPNcEM0O2ejl7S/TSIMeflHqdEwlXCJkcYPt7y0T00KuHYbkCQx0ev4ga5l5ZB7W+x4AOb6vFOi/X8I2YLURoQqhKbRf2Np+OSOXLMO49PpQie7ACO4AMT7OcgQUYzI+UkFZ77Yl9Ai/BNRDo2Vol6Y5aq4GtVxw+5oyA4/nOPRlZsIpX8jSAdDx7/HR8U1zZZGXqkTZI78xXvoEpsMbeDPYGPyfiGlxrWUe/Sv9fFVQ6hZ1gKPqYVbP/pUqmL9SPGnkqt3HhoVYgV+uaaBsN+msxK9am6x3/RHecxBSbxcpLi3CASN0ANT8eXJ0oZIWhPKOzET3fJYsx0k9iohpqjotdQLBjo+sm0S8130AZseI4ApqtDB7HbQX
 YNEG+k3K
 kzvg4JCQzBUrMb8+vRZOdHPPAf6nODMdZFOXlsZTKFXAFm1lKAPd+QYEWlwa/UAETdzQGS4mGBVUY4Vz0jau9yAnbY20RFux+Y7olWgAdm1ApLjQIeGgKZ2ghgrJZMWwoOnZJdROwj6XL813c05Y6zrrg65yMlXRmFWLbJ0GU9BYJFTzRb2zLz3rTxAY7VaY5bXGQSAK3jR6ou7iJSpuSiH55h1HtjJ/3uzDIDgKdtTXJoodmkZbKG364iVw0fDJGxuCMXYV+GfVRgo+IWkZgKNctIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 08:16:36PM +0530, Dev Jain wrote:
> 
> 
> On 01/09/26 6:48 pm, Karl Mehltretter wrote:
> > huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
> > permissions. For contiguous PTE mappings, break-before-make (BBM)
> > requires a TLB invalidation after clearing the set and before making any
> > entry valid again.
> > 
> > Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
> > get_clear_flush()") removed this invalidation, relying on the deferred
> > flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
> > TLB invalidation for BBM on contiguous ptes") restored it for
> > huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
> > late for the break step. The modify-prot path has the same problem.
> > 
> > Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
> > invalidated during the break step. Leave huge_ptep_get_and_clear()
> > unchanged because it is also used by teardown paths, where the deferred
> > flush is sufficient.
> > 
> > Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")
> > Assisted-by: LLM
> > Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> > ---
> 
> The transition happening here is:
> 
> old_prot+cont -> zero -> new_prot+cont ... (i)
> and then TLB flush.
> 
> Arm Arm rule R_JQQTC says:
> "For a TLB lookup in a contiguous region mapped by translation table entries
> that have consistent values for the Contiguous bit, but have the OA, attributes,
> or permissions misprogrammed, that TLB lookup is permitted to produce an OA,
> access permissions, and memory attributes that are consistent with any one
> of the programmed translation table values."
> 
> This implies that a live update like
> old_prot+cont -> new_prot+cont then TLB flush ... (ii)
> 
> is safe. Which should also imply that the transition (i) is safe,
> since the configurations the PE can observe for (ii) is the same
> for (i), except that in (ii) the PE can fault too, which is fine.

I'm not sure I agree. As written, the text above says that if the
permissions are misprogrammed (which they are in this case) then the TLB
can produce an OA consistent with any of the entries. Hopefully it just
needs some further clarification.

There are probably also cases where we're changing the attributes and the
permissions at the same time, so it's not clear to me that it's safe to
allow those to be inconsistent (e.g. tagged/guarded vs read/write). If
I was going from untagged read/write -> tagged read-only then I presumably
wouldn't expect to see a tag check fault on a write?

Will

