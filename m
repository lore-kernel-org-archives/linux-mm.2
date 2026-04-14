Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE2B5F9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4FD6B0089; Tue, 14 Apr 2026 11:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185C46B0092; Tue, 14 Apr 2026 11:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B1C6B0093; Tue, 14 Apr 2026 11:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA0386B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:32:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F37D5051D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:32:26 +0000 (UTC)
X-FDA: 84657553092.24.1C80D7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87A252000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:32:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0LCCC2b;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0LCCC2b;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776180744; a=rsa-sha256;
	cv=none;
	b=ChLyg6y9FECjSUfleSuxOtLKR0xHdCbHdZG941JgztlJGEuz9jK3beSh5Zd85L7QEmGV4w
	rLPwEAHW+PDXmtZEnGn7RDdc/nQhoVXq8vd8bB3hwA5aX+hucKuEwxVdw94457k3uhtTeJ
	6tD4gTI6m1t8m2UziZdVznWmYc/Q64I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776180744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZzLcsf4Z745l7zH7k7oF6BUh084fakPH8xJnHobNKQ=;
	b=e4EcBo+P0US1F1DCZzbNoyKJE7aAsG73JGNXJ++KNeWjHr07l/fdMA7ospkaIzODEwB0rz
	EAQUDzkd2NVWqIjxJnMBewrBZhTDxTa5K6jGCjDOU8Y4YmVqNjR1TQjJ/WPaKEGg6zgaao
	Jrv9zzFDJRKok4ulepv+xpzxYws3xJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB275600AE;
	Tue, 14 Apr 2026 15:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCB4C19425;
	Tue, 14 Apr 2026 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776180743;
	bh=5z6VQMP8pqJUhAd3n/FjOEjU2tDyusm+NQ3F1n9AUr0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U0LCCC2bLK6q9/hP68NR50bspybJ37L27b36ZJ3UYg1P0OvbBWXqKNakH8eJANjmw
	 VXP9Iv8D44h1APTVPihYR7a3ys03cStJGyMIfFXVA94lvLWHZBpibTZxrK9ng8rTlf
	 Ts+qFZmIz75Y09CTeeTrdQ/nKTz2JQ4HuglBx4rtbXn8SfWIG1B8wEsGidMuN3MEp6
	 Ab8tsuyBbnn/qB25GhbknBUEXhgnRi1xwo9lX6xcppZWQumjGQaUoyaCUChL/vvBKj
	 5CZ9yMuEPHIk7eE1R+wi2YtSlpV9/OcH8owHBxNvJo6WL5PFXlOaFmIVnrZZLlqaEq
	 qwCkKtzaLKLTA==
Message-ID: <8900872f-39e1-44ab-8440-e91ce3f0523a@kernel.org>
Date: Tue, 14 Apr 2026 17:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413163233-mutt-send-email-mst@kernel.org>
 <244c9779-b4a5-4d0f-9eb9-ef0ec873e0f6@kernel.org>
 <20260414062015-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414062015-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87A252000F
X-Stat-Signature: yc5afj7snwbtgcq438dz9tky9fq11cgk
X-Rspam-User: 
X-HE-Tag: 1776180744-594211
X-HE-Meta: U2FsdGVkX1/irGol+iWhF94xKCfkaD+BOjkfmpHgmvybuWdROKIzWtlMkjoNZzSWcy1FrG04p8GxVtUzY8wgX5wGorIUsh3czI5PpscJPZCtXSW3u49I79xM2FHAXdo2kV+wBvPey/MxDrGdiU9H3SFldvK+8DJ+YkyQK8pWLBzxmrQ5xQQCBody6imdAkZDY3QwvhHfldDXFTArVNmvIMSakJ6prpAhzwIBl3S/tbleEiYtcnzh51luZ+LOgtXeUf7m9Hsm13+QyhR+xaWY3rnXCrsOzEk9U+6HiwPlOSnIYp0yEKHCIb1uyW0to8HLFOhi47Z/03mVXqVApASKIZrnghEpZL26/5K6sjtRyOnIjRU4iAMDePRgpAFEH7nkPpEPO3F4T+6QUlMi9X0uYFBd6liEl2gasFTsN/ciXdx2FN/SWh60xCqNo1DIxfvc0DZQEzKZJXyg+jVYPSNPb9xqMk2vSsRi+3l/GUIrhGkNTp7kYzRP/jWTY3EhyT6y15JCYDvujWOqIOGVfix2gf75qLo64w06ydMSOS51Y5GU8ZGdYt+GMAdCN0WK829Eikk5qwOeRh9G4JvUR9SLny88kGmigByGAddiuKV36+fl6sLHSVYfGQN+2HZkyp+BTEPhn1f6/o+g1XkEhGPr4Tz8mAeC9r5HRVX/8xodb9AZIt9J6UDK9BSN9daUO+c5XD1RDHD13pSYbfYkSj+5eSkW27alUVAMH3lS04rYaJsQGKekhmkZo+0SXmMTUMf1Yo5I3j80kynAtY5Q/Yq4suye44WRxTD9Mo8mMBn2tIQf2xEvH223imIOwoFE/4u7kbPLLvBGWkq3WujC+vq3HwkyVmHzC6nWG2xmMu9/G0jL3RMQJ3FwJgieeBy5daPbQh9+4E846bsIrEsBpre9jDsA4+6NxQ9e49pdJuKn+4siImTSmORycXM7sbtCagZ5/5/jsuAXDVr64NQa9EV
 lmN6CW5c
 DG7rwJ2pTkZXjkiuH5WfwVxyow/SdcOrDy3gnTdR4Ip6wcIwK4powxVReJgiQtjxVnqjOSyyn+hAUw/ZURnyzSX74w5rHoWwoL0lAQWoNP6uWihyaJb7sZICbbOs8A5BOHhk5DdaB5gZa7squLzyZvBfLzaN8P5uOow40k/j/OIuio6dQq4q0tJkzh3nA0Jr9hcDNXspoEeDSqaD35iWvK0pnUXSVm/4M/eRi+4k2jNF+35RxAyEv0cW+/iTESXVk3WOPLuY3Rym3+7Thmqayc6ny/AZCUyjlx1f9r3/5nxFVji4K0AyR6PjKiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 12:22, Michael S. Tsirkin wrote:
> On Tue, Apr 14, 2026 at 11:18:02AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/13/26 22:35, Michael S. Tsirkin wrote:
>>>
>>>
>>> So here's an only alternative I see: a page flag for when page is in
>>> buddy and a new "prezero" bool that we have to propagate everywhere
>>> else. This is a patch on top. More elegant? Please tell me if you prefer that.
>>> If yes I will squash it into the appropriate patches.
>>
>> I'd be interesting to know how this would look without the GFP flag,
>> when we don't have to leak any of this out of the buddy.
>>
>> -- 
>> Cheers,
>>
>> David
> 
> But the zeroing takes place outside of the buddy now, it's more
> "reporting" than "leaking".

Exposing some buddy internals using questionable GFP flags, however you
want to call that hack ;)

> 
> You mean, moving the zeroing into buddy?

Yes. Such that it doesn't really matter how we maintain this information
internally. A page flag is probably still nicer for that purpose.

-- 
Cheers,

David

