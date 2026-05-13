Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8255CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CE56B00B0; Wed, 13 May 2026 13:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6E86B00B1; Wed, 13 May 2026 13:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4BF6B00B2; Wed, 13 May 2026 13:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 954A26B00B0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CCEAA0419
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:07:15 +0000 (UTC)
X-FDA: 84763027230.02.2BCE166
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6DA6C18000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:07:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=didtX2jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778692033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikHR/rNhCf9mlRG6XILGUUTeG05ODc4TyqSUlGJ+Oa0=;
	b=ybXLnUigqKl6qZtZy52mauFq4IpdO9tvdcmjdEGVl+wO/cUYh2iflQPwHd+FepH/yh7AnL
	ZX5pWjsY50znHdAGaKE/kFtuwwz0BSMj6QEBtMg2aJEtHPbBYd+bogKG6QSYLE0ISLvitF
	xln0WvThF3nPG8P1zaTSxEPlZ3DdT1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778692033; a=rsa-sha256;
	cv=none;
	b=Jd9YWg0mZOZSu/kIoT53u6YMZeGcnpQhzkovCH71cKsuMkkdGmD/yFdApAnyGOYKAETv5P
	Xg0NJd4rnkW89Nhj/J5oXrBdiJd4fymLgEYEG9PCqgC0cEc4tX4Klk38O3gKZuCV2qLD2M
	2Zaa8PNm8XwtjpgoAzwcnRHEE03h3Po=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=didtX2jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF37A6012A;
	Wed, 13 May 2026 17:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D183DC19425;
	Wed, 13 May 2026 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692032;
	bh=qiSbjD0HsEMFkBlESilc/oehVlYZCkejPoNwyL6NTpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=didtX2jygd/WXuBLpFGPT/RGCaDqpWw+VTGdp5SayNalQM5nwkzB0P4HNfRa7/GyS
	 iHDHvRWgNAJJfW5gMxc/PRZIPyDd90HCY/fUW85UL9Nmv8Zx2OhcFjV3CnfVj2LV9n
	 glDqbPopvlLBrtp1i6JjiOfq2L9OHM50UzRGjlrz8AP68WsVelLvXDKP34PhG451kz
	 +koWUAwY2Q3KfdEPq1dxLa7UqYsaBWRUaDtt3faSTmhzosXHYokiaXneFs1DQ97yVC
	 9V+ZJwgi4p2dntvpwZ6EKbSGdG6J6FfggT1B7pp8WwrxIhmTS3OBDYJPz8Lhet30iv
	 f+6BMZK22LkbA==
Message-ID: <1d1c5f42-2f90-4770-93e4-24b2958c0c4c@kernel.org>
Date: Wed, 13 May 2026 19:07:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: introduce for_each_free_list()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DA6C18000D
X-Rspamd-Server: rspam04
X-Stat-Signature: qnu4ge4hp6otsrk6otk8jo9wogguxfj7
X-HE-Tag: 1778692033-264072
X-HE-Meta: U2FsdGVkX1+iuOtFIzEmIQfu71GMHvy71F1DgRD3RHJ2m3sDdEZDuN/v37g4ntgTq8tUx4Ce8yavRGgigqTRLevLBgT16p5RFINrXFtaxctFrvG04/j3sn7BEw7Rw5N7Eviy5MDyEDIwvhAQALogntx3tZH4Rz94KveEl6UcUekkxDn/FB5stBMsoJq2SNmnU1uQL26/LjakBw67f6kyNdMlv+AKhAR7sSFf7ppenEk4hAaEPPfqOcEEVwiDIzMoH/BvYjKakaREQFSefGyVJe1fVaDRffECc2Wrkp+fgp9xWe3ejpxDDXlVUN0ALqfENFDSos57Y2qOBTtyrd8bdbbDHyEQ9JUG6Ln9g2Rpvz13XnF+xd2PrCvKaAzcsGFRDO5GLIo0fuZNr5mLaw02SfIlGm2PqNSYubO4sXOBPlb4cdLrvwqlwqHRfRqgAy7trUGmYL1LKJDvWrEPUrZMecUqgGpqr5/+qe9xLqPMpDVXE51nYlh2wD5aC9RQdmV2YQNMIJGaBNh6tcS+tUGjAP0lKoJFgIM6ehXb86MbQ0lrzaFQoSUmkx/w09b+AXx9jYfWHNDGOJRa+D7g6ZgDCyTSX2aBohotMPTht63h2emn5A26R/W1TXdQ76GmzNNFbjElKkcU/fFWK+ewv+rh2y3dPR2wgWi2XWHzl0ztDU8rU+QAgcnj5ZzIkwCiK6vjKQYf+DJiRcgLAucfjyWiwNy63Jo4B44FmD/I6t4dgwyL/5WEUmta081zz/xp+c4dGpakTwU7P9G74kcfLIhcWEIBGbP6xUUn6ywNuoLX2aYmyIHaQIrfzA4gBmfWnBxvxG05MjtXNFhnIHjbCLq+dHFXx9ogeZOEYSSdpxO296xKHhhHNl9aMmgS4uiKqsqnDmyRJUss5bHw1m8+11u2XsKirv8iWXih/odlfYadddnxVY3PvsXAtAT2gj6oBLcGf8G1ESaAZ9Nh7bFoEF0
 CerTJ9NI
 h47PubkV03IUtOAhcwByfMtBPFGj/6Rptr04yUZNxQWr1XUk+MRrHA9CsVWFoe8d+MEKAYtHV7cC4vH0bUh/Twk0+tQYtU8/Duyuvfz0kExh+mwBTDSNBnB6LZclq8Jg23EAXmc/X2kFIq1qIcMJpfGzwAzihI/8RmoGeCC/m6iHZqxnd/RergEIKpLx6e8FNlu+11MFige4gr2Ce054S2+7nwNioQEvUCwZE53ycd4NvXHJa10weosckvDfpLV97RIn0CUn9VDeMvfGL+QbtcDSjKjnxu9lOP1rZxnrfQCoVRUUWqNO9guClMQX4Scn0/bUkkg/Ge6FjyyYmSEZ8VZQs/rT72qcy/1VB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 14:35, Brendan Jackman wrote:
> There are a couple of places that iterate over the freelists with
> awareness of the data structures' layout.
> 
> It seems ideally, code outside of mm should not be aware of the page
> allocator's freelists at all. But, this patch just doesn't hide them
> completely, it's just a meek incremental step in that direction: provide
> a macro to iterate over it without needing to be aware of the actual
> struct fields.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


