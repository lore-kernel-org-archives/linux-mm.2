Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77522C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4065C6B0088; Mon, 14 Sep 2026 04:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390446B008C; Mon, 14 Sep 2026 04:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258E66B0092; Mon, 14 Sep 2026 04:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1C226B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:40:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5056411D8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:40:37 +0000 (UTC)
X-FDA: 85211721714.09.F9571EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05DF020002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:40:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNtOK2zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789375236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iyik9pk4XQ9fStO+xDvNhhL7n3Rs9lsYxmsRtmeHa2A=;
	b=aW7dYW5QeZVgwFk8FYgirB/jJkFZq5umUJE95JpTDCCCGlTjZU76Z5RA3QV13zTIUXGkC0
	fQBD1c2vhb89JTBNvbfY7dg5TEjNaaLWyfr9BWaKWSCetheHcxfu+ld8Ol4knhxAWLJ6+S
	zf0gPzOeFR1Pj5KMZ3eDLNxFlvxiKSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789375236;
	b=iCMrrwBnGue2438Pj1xs3acbDOjxAEp1v79NJYMIzLtk5+f9wEniiTkXMrCAvIymK1STl+
	myuZLuduv/83K+i4T733ndtb8pCaaKqFaws/hgf8Z3QVU81scvUxeblpvoOLIY+kWW8qrO
	f7ZY5NHOg7JwiaGH37BH6hlJYWEftx0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNtOK2zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E675A60008;
	Mon, 14 Sep 2026 08:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67FF1F000FF;
	Mon, 14 Sep 2026 08:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789375234;
	bh=Iyik9pk4XQ9fStO+xDvNhhL7n3Rs9lsYxmsRtmeHa2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mNtOK2zs39vecG0w1gV1ZnGXxRSeRhGGgqdGu9C+NM5+QMhmLwXfog7KDPTX5FhAN
	 sUqTEKqoc8GCZ2uy/5GPTJRdvj6urd/ewZrwgExOdw6dTYAUwNLYqlgmZGT114Q2mt
	 Z/cEITyN2ePCcRmheffC0W1ysHCgQvMYh/mAovZSiDi5WfPoZ1O8XV8EgamBr02v+S
	 /TCyWIa0QOdVO7NZlzDj5HRxmcNgmKBlhrI3WBcu30iyJyYVlozAW1e4HYhGzqp3LF
	 v/4uqGKQp29b3+pXeda8RNL380V9tRU28bGrztLCwN8h0VdDaRXgJ1afEnd2gxZ+L2
	 i1i6nk5UGcg2Q==
Message-ID: <80686bbf-f174-43c4-99e4-0257d513281a@kernel.org>
Date: Mon, 14 Sep 2026 10:40:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/memory_hotplug: use public nodes for migration
 targets
To: "Zimo.Lu" <louis2665573906@gmail.com>, Gregory Price <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260914074323.3567923-1-louis2665573906@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914074323.3567923-1-louis2665573906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05DF020002
X-Stat-Signature: dmon56nm7p7jfeumgtucbq7j6h39nayj
X-HE-Tag: 1789375235-156427
X-HE-Meta: U2FsdGVkX18psCPhjW8sdHBV8fcpCOYcS5XsIjjtUr3g9I1huW84OV6aeRZZUib92GW48m3Iz5zbAN2t5CsS3wq0P+qK8vQ2cTebl8L7PY8liMlqAcIxgkKwDMAH48H4tfh8JAzxKTOfVO7vjJ89FL+dPCrTUX1N5VEJkHHRB3ym7XsOqjqc5yt2Q+3uXkASKP6VF+nqNfDIMmll7bmWOXF9c1brZosyfI/Rjr96bTAha3/+Mh87yOhH9mNhDuF3OtRQHHYb+NcFmrZwo7dQgOMR/Y0Vrl4gR1kp1iALRjcfSKo3B7+EISWZXhU3tf/iLNljrtjCDo7TQ+QdHNbmug+YJG560nSVHnc3XvT8ShSS8MLvTVDEs9xPxo9rQ0uCIKqK56/D/M7VnTJsLvy0ljqoVZbcU3MgZW/cpLFMQOlE5TYubHhCNT6DRxb/okmSDhiAkjJ0UarMAS39m54Kwx0uU7x22Qd5YmSLO6pyACDLbNQdPnxtLxtANUDDIK3mDVxIkUIjpW/wtOJiUF4xPNFwzJdwpZwk7svfav5RfqMPM6XrL1vMcgJ8UdAXMtH+Xoyiw1emZhYZfBU2AMVoT7Mi4CDL97YkgtMrLNpXDwrtn9/j70LLkpC4kaIXVzJvrhWbsr1IpKcGe6RBGYhzOFUkp+QKyFVChITLdujJYFXMUDKuYAGBRyUzkvBPdR9IaM6oiC/9dY/fS5gjOXNI0/7nPdxGA2TJfPhlPanFa9shthE9WvdMe8uYk7ipZ+3BkS+BI+Ef1L+d6lW4AarDVk5ryAx9xTZPF7Op5mk4BCfDEDCPqDVvsdaOny03ucF6IXitLc5WCRZyJoHMtLZ08focDPdtJmfBQxK8XqCLQ91sjN48eV7a8FtCcJpf1GZs83C7Qo6M95iUgi4P++okgJdJ1VSnPMbOxn/7YudOgdGuy1jrXg8CuNDYgvZ8pI4n5/uMzLCPgelTfx6WlAM
 fClEv2D4
 iPVR7u0KQjSeEJF/n+Ok5goP8GEWa3J/aGxlqlHNEGoKojRe3uSOeMDrzwRyuMD11UTm8j8ruCNAPBH61Vf9j9E06ntcqtWLWJwdNtkZVp+zUqSLjlcBuqQuX94wVCgWl3d6s1fCxbh63gmRFK5Q+pUZcau6NaKGVeFkT89zjfeMQ2mVC4UnUDld9rbK1ZOuLKPjW2Gnnts2//BPtEtLcCiNHts0Kb/WRfkbzp7f0RZBTKlA9cAkvQPEwRbzN41aw2vueTBRiADY+1hSHkh1N9OrCOatslkB1TYD5KDjjc0Dzis4uRsVhUPJ3aNuvSnHYPKC1RniZbCNX1eU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 09:43, Zimo.Lu wrote:
> do_migrate_range() excludes the source node from node_states[N_MEMORY]
> and adds it back only when the nmask is empty. With private nodes in
> N_MEMORY, this can leave a nonempty nmask containing only private nodes,
> when the system has only one public node and others are private nodes.
> Ordinary migration allocations use the public fallback zonelist, so none
> of those nodes can satisfy the allocation.
> 
> Build the nmask from N_MEMORY_PUBLIC so that private nodes do not prevent
> this fallback.
> 
> For HugeTLB migration during memory offlining, this also excludes other
> private nodes from the nmask when the source node is private and public
> nodes are present.
> 
> Signed-off-by: Zimo.Lu <louis2665573906@gmail.com>
> Assisted-by: LLM
> ---

This should be discussed in the relevant patch set.

-- 
Cheers,

David

