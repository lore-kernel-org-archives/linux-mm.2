Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8231EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E5B6B00D8; Mon,  6 Jul 2026 04:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5B76B00DA; Mon,  6 Jul 2026 04:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4886B00DE; Mon,  6 Jul 2026 04:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106F06B00D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:33:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78336C19CF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:33:57 +0000 (UTC)
X-FDA: 84957688914.17.9F82427
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B06BC40003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:33:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fulj5WKC;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTrFljYyS5OE6S83wALD0aUeKqDQTwui0J9q9JOrQDM=;
	b=y3CqGcOUc0mvwlXFY9SUfOdDBP55G0brQjlBC7cfMYI6ys+/Oj7b8kOx4/0VMlYmkrLzkE
	Sj0TvJCNXSbmy9SaR1ih0Ypn4Q6nAGWE/Duz6S1fRLonm9uK5MH3YDK+FlI32icuYPXkyn
	eew2sAHuRH8H03V9JuelwkQ1uNVPjdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326835;
	b=NFbZvp7eXqP44dSVeCfnLWLJJXTkANldFcL4/wTz7D1I8emvIMYTagBchSkJMBkzGwNEeU
	EX0/GB/FuSPt3Y84Kswge7nBmfTV8kE7VN7mWVd3PPRmNElt09DEhPLgOS1Y7hf2VFkBM/
	ToiiQGammwuTEy46cA91h3jayoEGw3Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fulj5WKC;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D882640F7A;
	Mon,  6 Jul 2026 08:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910931F000E9;
	Mon,  6 Jul 2026 08:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783326834;
	bh=QTrFljYyS5OE6S83wALD0aUeKqDQTwui0J9q9JOrQDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fulj5WKCCN5+UJhzVVhUx00MyNGgf2M/xmcM2TQfcDvez48989rKLwYrMrHF0wZP2
	 RCdSBQdZBcW5Hn8LN7e8CvCx5U742Ugbrz2gguBw1RH6QpH68ATfdV+9bbxgltIcmE
	 sPwXk1CYcmHYCmuIqoSGNlU+D4lh3uF+I28iz3Bst+jh1zIiQOEfkQZo01wVns4Uwl
	 75WrrM+R70LEeyHLXPtXd8kF9xo3xcNfRWr2j9NhRdrK0VXeldO/xB/pFBemQoSb0e
	 MDN63FxNL4JFKjpfok6QkV0Qa/8OS5VCPYrWWyXdU4IvC+SVpxzRYnqnJebfZ+sbZl
	 lEfJQFHVTOf/A==
Message-ID: <50d9464d-3fb0-4812-985e-10090bac5641@kernel.org>
Date: Mon, 6 Jul 2026 10:33:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B06BC40003
X-Stat-Signature: norhw78yz58wttdybmq6pjc66hq1fkkz
X-HE-Tag: 1783326835-338361
X-HE-Meta: U2FsdGVkX1+1Z4SjlPMr8gvf4EuetKGnMlT4+tb4idQ15yONqwqvudvRbvfp33UwT+T1PZS35P8urqGTlCB3DMr8NOioSy1LbdyMzUeZ3PPHHeBIvdQ3FRYOe+qzQaRSNZWJaFOMrsM2L7XCFOpTgfDdvCDYLDM2+BjVi6WOLRqK/2Sk9xu+xxyLQv5YqnRcVlZoPvb83Aj9cUsiDy52Qto4VuXO4MMrs5ljTyegafxTAqbznXFQYH0ga2CPa9Wg7+IagSBDRyntErr5+qZYCxyR23Hxs3X+a9WB6DDY2Pwpq9WT2SdN9+sBzySxEoU9Td3LSbamZJPhGTb9dgbR45gnCEsDF7EdCFoxwXlhZaXXNLk7Ufw+r3byNZjvTSIdMsTgIAGaMDQaAKxrgy59jcVI0va5qdpmnTHZ95xxECK2xDtLYnT78LpS0V9auy2c47WdV0U0IHM+Jz8R0KCtI7QpdnjjUPLj9Y/kp3XRvoGaT60l36QOQGVryU2zOHaRX6uSaOLvu0eS2+34EE1us+FP6Vr23evR5lNURC5r5S2Dq/OmIJx+I725hBVTayOaKxFYhnKR8hbPMT/n+mDUEIn436G+FSRI6Kutj/3Bv7wUgpUceAIszru1sMvSj3tJE5FsZTzJ1o30HbkIW1IaGHkqLuI92UhUVxApWcTsEc/P5Zdgdgm8A5/8WDlYoWXwdYrj6BAk0qB9yRRArLgTQDHZfTwNnb4VoPfG78Z+qyiBvgMoahHWcqErSQKzrXx5nd5LqvWrGmcANERa2aF9795VgFUFF5T5N1fVMjfLP9EOWgrzsr/JoxGxfhaoP4r7Ypi/a1o2DwlH0jgKQdGtNtifhBER0M1VZl2D+ZGAGOAI/Nz8eukzteDpbrnpOQ/+HxPJCVI7aiUdm6d/XJFYlf/Pb1EctDkVwo1XWagq77R+vfRsb5EzYWVaHX9u8YnIjIdBfh4oIKJA1SUTDK9
 DIYEtGdk
 P+1beOK8lw/mn3n506yq5hGqsiiTtvTUhsj6kMpfMT/RBLaRjHre0fDBSvNHqpKop3ixSufpfirPrDglLvHzGN21x+hjuRL9UCDUPmacKWtnWrbVf9iACjZ+S0QeSivSMLmDUsX7/clscZgSsgjCqFPfWb9wpjJlLBBdd8EGdw98S0fWdtiPf5VbFJkcwZbvUFHTieAZzfRoG6jH4yqrKK3v91O0hQ5SKIzqnlmWA/QUHvQlOG5llECbyXaEhB40twB6ieqMsT8frH4DE/+BLpJKlPfPU8N/JyAZtS1rWQlQJsEigjvtWMACp4qdvFwP4v4bqrvJsVX8Coi7QOxIGvGLw7muPKSiOeUDE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> page->private should not be set in tail pages. Commit 4265d67e405a
> ("mm/migrate_device: add THP splitting during migration") removed it
> without a proper reason[1]. Add it back.
> 
> Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

