Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80695FCD0DA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7B26B013B; Wed, 18 Mar 2026 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58C66B013D; Wed, 18 Mar 2026 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E706B013E; Wed, 18 Mar 2026 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8747F6B013B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:57:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 361A41404AA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:57:07 +0000 (UTC)
X-FDA: 84558579294.01.72CAAFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A771D4000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:57:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm2RDMUr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773824225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1X/wqt37L6Qig3YxfI4Iu+YBjXUwhpxZj2gcrpjg2Jk=;
	b=qdqrF0ZIRf6V73y5RwsK8HCfbkBaIFQbuhlElzLbg4UQandyVCHoxZBYRmsRvczycypYpQ
	RpYDv8adkU3ZcyPMcIl522HGsBuQKQq2djuX/o17p/R2UZeBoDeJgL2+gvH3T2K/aa3+/K
	lrxOztPI1pJGxqspCipOZHLufmw0kbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773824225; a=rsa-sha256;
	cv=none;
	b=66xnzFxv1ZQDNdH1WQwR3iM9RvCL4vZSnztaqdtAtTK89OItd8bAdJqvEC/jHuaq4yj8Ln
	mvP/usIaE0yegJTg3eVAuH5aPdLm5xqt3opoBCdukYoni8lzbQtzZW/yZcvSuntFDGrHpZ
	6+eN/iInrP1rQXhnJkdT076Ok7vxa0s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm2RDMUr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C5CE600C4;
	Wed, 18 Mar 2026 08:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76320C19421;
	Wed, 18 Mar 2026 08:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773824224;
	bh=4uBSxFqIZq+o111sipBMJ6gRCXHJRWFp6ZRyxieDb3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lm2RDMUrdFpSVAbXyuXSorF+7mJosbpFXknmgF8KIqmP4uuYR1vNbGgq6594/I6ze
	 rhZRB5Ox+B86hABUg7I8OImw2cwaujyQop+xUSOdsvd/PxofMMsGO0bd1afnnyVB8m
	 z8rFlmxumPeDIzszxXN2yRtDu9NO1B7DlCNGup/NYrXUOD5zXMjYUuSylZeYoFgcFV
	 JdXCc6BqyX0QuCa9Iteb9dIfal0mnMDfc0nVJxBPuctCXoOLMkPrw+E6minXd+Pd0W
	 2C2GupBiAzTfGY+TJFsqdzQ8bwP3Z4xQhD0BGY4oIB5KNdj8m9QbCD630j4IaQPOgW
	 7qSbixRdOMSpg==
Date: Wed, 18 Mar 2026 10:56:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 13/14] mm/sparse: move __section_mark_present() to
 internal.h
Message-ID: <abpo2qJq30cytRiB@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-14-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-14-david@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A771D4000B
X-Stat-Signature: i541zbs3gh5c4syuiubws88nuy3i76wg
X-Rspam-User: 
X-HE-Tag: 1773824225-678463
X-HE-Meta: U2FsdGVkX18Vcy/toXbPBmyx27gclVzZavtoTtaAlVVmV88+r469YrQ02SIZkK0tEPoX38xnmkwReK7uvuWU3/6NMhdJ8FCW/IBIQIy3cbMXBKaOoyMYbdCWnCxh8cbqkOIJIKlQ9Hy98HEPnpGZGCsvzO0Xkaetd/iWU0E+3H5m4DcCrK7dRwV0NUPvekWH6ewdVXNxhTM4dxaKhmTXcgH+Zy/d/4p0Bzj+CVcYRMyhLov0pbIfPhIwjDRAvisbDHSaOqS46FIBdSkIsrsZpRCB7VF9oQajR9WccTKI239uIXLmyGTGGgqNIB5BPXhcXSyCmkGVU8Jq/McR9298uVVkAIpEySQMqGUf7ZHAJeTGTxDVKChiUoNWqYVVRHolNZRfsk19RtHPKOwtgkBW9l/wfIaG/EEJN+lKgx/pS3ydgso+Pjnt1c+wfxn9r/gCpiowgpChtRUP2UCx6dj5MbmNq4Cr8ttvF8v9mFWOFSVkz++OR3UAaCE4uLNN5dYZtPwYypAy9MmzlHFOO3f5qE+RR22s3kwR0PObuN7/WcnH63QWZLWYZ+FbL/dTbhTeLrdD/8orUdarWBtUuZOCLQzkoCY/cAhIJGHLPQyff0erBoDJ6R5OyVLNsgXXSSfrrBEVufX4juZF2cZEmfPQcuo+KmSayidGj9fX+HGKzJWxHoNe7mkwxR42n6dLqFXKdMW0gLI4pX8M97QD/wignd9NXcDNAKdzX9Y/G1HFKzknLuZJK/gyAC0x7P4FMhT4BW8emMYmGjeyfvIZi95jBU4yT5xCBq3dTVASiHtGL1ExFwVRMh7ksHNl5WfH5iHSVSg8jAZ8pP9CcRwstZzADLQ/toQEx7TsuDF/68fdTm/0PggZyPQHuRyuSlX7x749McJ1CQwuxRf6fRoYTWGbJm+yMJdpqef/U+mguODVQUjx0WSX6uTYgnruSHpplUkoGvdkLU4Cw6kIxpAIZWc
 +XN1yzBG
 hf/UACYLbcx3k2U9PctInmzJiwBds4rPlFxvrN0WhyKnqCfSBZYnJxInnkWousK54tyvUHNjiZXSaIoSDKiOaMY5xGB3FjLVOGaeL11tFyI6/jDFi/jy5w8iONmBKt9CrYMw4Rf4cVr3km5hulElXB+/h5DrUnUoTrmXiJLLpGRm111tf/tF3fGv2TXaFfNHsr7AiZgF3QTX1lODH+rFXJA3k2+dnOeyT+Koes+S4n+tIBIHhx9ow8jkZ4YzYXB5rvg2QGRWvdpCiOLJoFWUZHAUjtwrFs1V4D53KceXH7Gu3+YKpabTh1x//G8sjffN4yCgjX3cxMqsFjWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:51PM +0100, David Hildenbrand (Arm) wrote:
> Let's prepare for moving memory hotplug handling from sparse.c to
> sparse-vmemmap.c by moving __section_mark_present() to internal.h.

Not strictly related to this patchset, we might want to start splitting
internal.h to sub-headers.
 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/internal.h | 9 +++++++++
>  mm/sparse.c   | 8 --------
>  2 files changed, 9 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

