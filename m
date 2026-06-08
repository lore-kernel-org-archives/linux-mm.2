Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A604CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BA66B0005; Mon,  8 Jun 2026 11:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603566B0088; Mon,  8 Jun 2026 11:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5197B6B008A; Mon,  8 Jun 2026 11:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43AA56B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:09:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A5E21A0165
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:09:26 +0000 (UTC)
X-FDA: 84857079132.14.3D5EA83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DC8A5120002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:09:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJWn3o92;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780931364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOIfy1XG5lwrPkPTh2QIsZcrGm00zEh/lVO/j58zYdE=;
	b=bt7DCkgFCg+rFP1k9qS5LcT2/QZnR4RMdLeMeolUZPDRN5zwEWYwI8ojb/px/FSDKZ+2rb
	CltRMUacxHWdMGY9SRnEZwbe2VWq8d6Tu1inBwu6xYAYbiifFtP46Mz5p9l82Q9l1KO9oW
	Xp3YxuwPVkKRRronDY4ZMqdrQ0Ywy/w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJWn3o92;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780931364;
	b=iD1zFpxP53Bgqd4KK3zyteczdLraVUpZE3z+3ARMg+rt7zyAUqNZJ7ooHjgfiEjmpdHa4e
	r3C1kbdxKzrrdIXWXuOUugOxOIwveJ/BHPQ5ol8C2GvSB9cpTbr6489Hb2x2KhdioRYJ9s
	WgWHAJb7IfDouqDihaHMwyF9DzXMOhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FA61601E2;
	Mon,  8 Jun 2026 15:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491D41F00893;
	Mon,  8 Jun 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780931364;
	bh=AOIfy1XG5lwrPkPTh2QIsZcrGm00zEh/lVO/j58zYdE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DJWn3o92VikRcjHvJMJkMT9/HdCo7uihuMbp/HaljGUSx3xMS3MvhjuikalIsL3Qe
	 6ENx+CBR4UKeRaRJc1p2qGdXsrl7KvrLZDGNgpZjNcFmb2ruWDp4wIrmEJecJADl8D
	 oYVrElH8JZnO8vacs3CaNJc7yldh9PZcjUGtvHnxVhJ0/Zl3hiprGQNnPSl7v+hH8s
	 FHJQRZVj7W9fdW3nCU9XJ9g1vqCBottI0M9w4Htstg7iqOML2TVXJ9C3RlwB2sqewA
	 rW5egrtH/t2nuSTIjCr+L5+9CnqTQeEji4mB0O78U0jlztDUPiEsjaFkUpQOjvRiLZ
	 lYo/FoE+uzs5Q==
Message-ID: <2833a7d2-aecd-4c9d-af32-3b6f3cd56b7e@kernel.org>
Date: Mon, 8 Jun 2026 17:09:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC8A5120002
X-Stat-Signature: hai8mahx4u7m6nankre7obxa35w9psjw
X-Rspam-User: 
X-HE-Tag: 1780931364-393389
X-HE-Meta: U2FsdGVkX1992RED/Ph7XeQRU7Xtly4K3Yjh3E5z3kBXtZk0vjNWFr0kwxxPb5PYxdVCWOwApQWuNr0bt1g6++7t8lSMmz06bSaeeyMLoVIk8iM5HwRgNgIVxjXmje70+UQxOLv/XkdCaABlO5prn17NwAc5O00/l2iXbEKDPmn5ibHoZDD4VdpYTy9yUdQnca26t/sHtDptfGtrPZ0FTYilaj/WBV+bKXdib/XfHatoEVEgPJQvD6Pv5Yy9ESNhjG5GmSfNfx4ptCXd07e2UuIPg8TZutxyrF+sUQ5R03g3Sf03352ud4xWQwGbVITtwuZl3M1wIcpiEDiiEgFZHjRs0VXnGk6wrzlL+dVoB3e+dxndGy8pHvRi5+a5qlcVHyMal+fyIvg23er/7smR3R2iLTSwDkiK6SJ9+7LUAgSuSP1iRWGddZEeyi1t4UmBwFT9D+e965bYmNdRxLf7cSY5xBZsciHrtwIOqNn4ehGKgZ92G1piAaKHL5BRQwb5WXdt0fHg6LVfX2XprqkQMPZLOjVFfKviVyL3602t0dBV5m9lug5Dwi2GGAqCKsFFuzrDe9P2yjr5ocgVg3BDGxA7+7RPTDmvV01CWRUOoQv6BN4XbY1HvM7C19Km19IPSxqtfy67E0E+eC7185OP/NmiD3rTmrNRj0PIljsVkyYs8RD+mwL/0+e6De3Lwj2CTOF7PdgHLI6ofREvesMEG5HriDINYkE1mUlWAonHkxPOO2VICpKnPdIeWXhU/szvc+14/rxm4riRYV49OeWF5LWrJIKCOyX3yMocTN7qltYHtaufi8ebKsVSaALjYQiaZeQ5oaPlsSVcHrHrYji9YdVVTmCUJPaLW4QzqDr3PYhtUbCTmDHC859EvHPAW4sdzpK6nk+5gPBH+x0O4Pw+z6jt7LdKSL2Y2r5ez4UfKk8C8vTCw7oeY6Ub9F9FVjEHLMkVxEZm1thjtrs9h1u
 iIcKQPk1
 JaG1PgE4bPbWtte/+3z26AsdWSzEL254Of/e25Q+0R3LF8JjFJtORjR2VV6u7mD63WLkM85scbza++3tv2o3ayOo6uHLcAtXR+lpP522t02FZbF7lejCzFZrn4LFF9Cz/PTmoJvF3PdoOF5Ft/Q/Yx1xAbcNSfNQGzaFBH4hc6XhuMs99VW1R/CqMfh21UN0a+ROnHNq/+j927tdk4SwBgRrfScdvHWXKLtfCJTP6VQEQhPD0L4vkXpMuFjiFdpd51PfVBE5cZv/+XEnz7z5NXctyZnW/oUEn50g2dxpzjo7F+IrIAavjs8REnX2h0XBCNuBLVkLctSwAWRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Yes,
> In current code, migrate_info only carry FOLIO_ALREADY_COPIED.
> So, =0 and &=~ are equivalent and similar for |= case. I mirrored the
> how anon_vma/old_folio_state get handled __migrate_folio_extract().
> 
> But with your other suggestion of marking already_copied immediately
> after folio_mc_copy(), then bitwise clear and set will be required.
> I'll do this.
> 
> 
> 
>> But I wonder if this really belongs exactly here.
>>
> 
> I did not understand this.

I was wondering whether this was really the right place to reset/clear it.
Your comment above addresses this.
-- 
Cheers,

David

