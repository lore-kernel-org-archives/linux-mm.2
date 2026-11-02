Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A7F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzxEgD2y
Received: by kanga.kvack.org (Postfix)
	id 3E9886B05BF; Mon,  2 Nov 2026 05:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A4D6B05C0; Mon,  2 Nov 2026 05:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288B66B05C1; Mon,  2 Nov 2026 05:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 074BC6B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:19:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 956161A0C7F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:01 +0000 (UTC)
X-FDA: 85389780882.09.2EC6741
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2DC6C0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NzxEgD2y;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614740;
	b=gCKrw+FpLPs1qrmfglDjLm0gVYeCU7rSq8xsEmUIbvMgmYsUTFmdwihylLe3R1cko5z3X6
	TQr9sqMLbLiaFS+41irfNIQYwB2t38SJGLlu3x99fhRQElkAId9cG/gGwM+Fcm9NVa2s6s
	bXHfxJxDRDlKfdd7wgS+6VJnjNkeP20=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NzxEgD2y;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj9lF3Wd4061fuv6JiYbvsg11hF4xy75NweMbSIOwdY=;
	b=wSYJfNQEPOpVPkd6bss/eoij4EX7clgf7pzA9VENUtrXkZba8AdIUIEobbfYXbu4I++k2N
	xi1XAOTiqyvi3pIe/81JeuO9xfFUN/3iLntKJlGMaT/IeEQnfBpAJbZfIBk52hmRePutv/
	o5XkGfFJbNZ2uLYIdNhI2datSUuOUpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 401EC440B2;
	Mon,  2 Nov 2026 10:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44141F00A17;
	Mon,  2 Nov 2026 10:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614739;
	bh=Cj9lF3Wd4061fuv6JiYbvsg11hF4xy75NweMbSIOwdY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=NzxEgD2yTHi9uikTgeQOwHwTV1Zgl58Qd6LzkGWevW8+X9X96cuCn1szfeyFTTkjk
	 koQfVbOCKNK+419WNPDlYyg759bwaa2g3oGzTTLybhKjdXq++DDirIe4KmmKYgPdqt
	 cTKgIt2Keis9vavblKoKtUn2MNa6X9IqU8k3HGWLfI4QMwAitiK338tPwnswtr/KI5
	 pQsCNionkjwelpbd1WZmUihirMZ/BqE4l4AGLDkyqAQ9+DcxPadwHr0Ahr/FeflmGm
	 3ujlw3P6olmbJOWTFVxhwB1W4MaY3AxHIGXwjuZ11vO/w7dZWRuCayWeAgcdOr929Y
	 2mYBzciBijylQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 08/12] mm: hugetlb_vmemmap: move
 alloc_vmemmap_page_list() next to its free helper
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-9-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-9-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.17802347708774525919.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: qu9xbppbep5inf4g4594ieisa8okqn46
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F2DC6C0008
X-Rspam-User: 
X-HE-Tag: 1793614739-97920
X-HE-Meta: U2FsdGVkX18z7swQbReRQAtFszPBrPv/j8es65APqqKV2oKGJXntX5JoF/p8qNRbX3LhKbuk45mDYRvQFOFeeCjUe+6CFYLglrDm4f72/BKw0T6S9aFVfYUjakm9BFOdK+PPg11kFTr6cJFKZRFZSTXk5ulPv0B8SeSCzX+CLqEoyuWNtPg6lgmORAEWkZ6AzKjfTRqyD6m9SxijlSuAJC4SRBmJwT249zV1lkoR57gTPCTR46P1jUJO3UYu+7dNUy5CT9VfNg0vGcvBX7c3GMafYcPBs0TNYjbEZCiT8YlmK9IVfdYhF2z1Imkt5Gl468CScb6U8BzKKqxRSxeUnFtWtEpQisnaJk7ETNX8e1auHUPPP7TNtDHMbP1EdoYhB1I3r/YMRmZAM16F71g+UX2UaDWJQXr54DvuiIO7A7ow5GMakWK/iMEuy7uKFEJ9s+WDj9uqv3mIbMoBMVX9TYODsAZQD5f/zraORA45aP+w2rXeCYz2UnWTBN84sIGy9VUnFLMcvaXO+x567eF7Sgw9rEl1LxFAM4uoskIqrN5TEcNDrJ/EYDt3o1jdXw87SILLob5ohjKgI7Jeof4QGlpt5aVsXjW7h2bm73/bgxD6HpDGf0q9BoiG1RL4oY1px4khcQUmyiKPYzyyIDRwyIbYoeWi6SYPvyVaRcGXyavrq9zBCBlnx21rnUULC+E9DrLkhkq5VuKaOu8kMWLTSCKNuW4RuAFfwkraneM2YhzD+ig78Em0elxAKzFCzVxa5D/fngbSzf5uhwM+MpK7MKh+EBnSp+Kk4+0r/z6Phy5cfjXvaYdgcf6HVND1OdMHJOThbQIVR4J68URsVR70+YUqss0rYFizT30NM+epEBzabWb8w1v8ge6eBOxCNYCIluhTKZBTttp8JYamP+Ad9WzrtgiXNCJJwYDNN/y+jsOosRfj74F1mL8yDKGIUwG+R3bkeSSf1nYWPbV16Xw
 HBLCuhiI
 5bObLl50+0BJkMTWOoQgHbGG5mdZtmMa+VkhsVbNis2LwGsdLf9cgvEOTeWf8oNDE6KgwdppPn9woYV4Ye4HV9YlpUl2084QcN08/zQPcvHeOH9KQxasZKA9pr08i9J3jA0MUHwLtkhmNA7XB6RLLKLQwAML7HloWsmnsZSMm7Azba3MU5t6j6E6BvA8NEe/3tjqUt+MadcQ1kzrj2G82YXt58YWt+NZTtQMMOrviHqPgClW9VSeywOCCJwmTnr4+yhEYPJIC2hVCDrrbWYmuMtVxMG8usonL/KwGA9qAD56Y5VGhywfFatrqYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Keep alloc_vmemmap_page_list() together with
> free_vmemmap_page_list(). This also allows the folio-oriented
> optimization helper introduced in a subsequent change to reuse the
> allocator without a forward declaration.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

With the comments for patch 4 addressed

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


