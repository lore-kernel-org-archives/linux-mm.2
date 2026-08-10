Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 491C2C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39C06B0093; Mon, 10 Aug 2026 17:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3716B0095; Mon, 10 Aug 2026 17:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A566B0096; Mon, 10 Aug 2026 17:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A20FD6B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:46:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21483C0292
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:46:44 +0000 (UTC)
X-FDA: 85086694728.26.AA455A3
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id 692F34000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:46:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P0UmuO5N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3wEZ6agYKCJEDzv84x19916z.x97638FI-775Gvx5.9C1@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3wEZ6agYKCJEDzv84x19916z.x97638FI-775Gvx5.9C1@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786398402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9ZVdigTFkkXZy3uWdjVBQv2uG8gYzkftpP7XCg0SS8=;
	b=aOpayI5x+mXRgmSosIpoaFtZ+SdxZpmdO4+0Uo/p1g+EHkNNNn27XMx02oetVn1g0rgerv
	5IHJePKencRTrWADSMPt1k2ZJMlxI21WIRMuH4Af6h1040Sml4xDeqtpdaOlOh22YMtdgJ
	lTr6dUtLg5i8YeUTWPyG6DPUXwtvKog=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P0UmuO5N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3wEZ6agYKCJEDzv84x19916z.x97638FI-775Gvx5.9C1@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3wEZ6agYKCJEDzv84x19916z.x97638FI-775Gvx5.9C1@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786398402;
	b=hW6UvfWxDwnuCXWGHjp3ThLbjfsf6YIyxRrWRaiMOz9TgLmhWMMx5GcZesBTNnU/Zw0E6n
	aauhgOgxKwDk8UGMhHPxtRNdD/5y1ekLWAx+Q7f9TH15oe45vkbtoejQ9c3B//ML1oI6Gt
	0VyfIjaE+byL2ZH5zbQk2S203Emt/jI=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3811279d51aso4692295a91.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786398401; x=1787003201; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9ZVdigTFkkXZy3uWdjVBQv2uG8gYzkftpP7XCg0SS8=;
        b=P0UmuO5NI6nwIOfJjGDDaCRUtfkqVnMRX7YHtDMb0jabX1z0D1dKsCBQNT0sMFbycs
         vA7NSAKsPv5jqq/ajlbeLnRL3AOygkOctV083omNI1p7VkBJxP4Q6ARX84WcB9BaPwN3
         Z0WXZGP0KjXadSgLeu7/RlSoOKkc6hZY6mPP2jt5B4haFhfGWV7lWgLmzU1lCE3Ulh2/
         X1QR0TErlb9OGfWu/k7bCCZ7dWSgqFE4LV50Zpeh9LBnZP0H1zftEUmaHBgS7uzV/jt/
         wrFODsSJ/bNuBdLfJc4mZ0WAXXGy5ICk+BHRzz1wvYTsW8dZ3WSQ6oK86UridxyQpiHT
         h7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786398401; x=1787003201;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q9ZVdigTFkkXZy3uWdjVBQv2uG8gYzkftpP7XCg0SS8=;
        b=Rb+UgyIUJyRNIvi9Kfiz41LdRqxAJKdMXKZQIP7+WV75pNxkYziDz79ggs1soaYLla
         khXmbH0Pt3lxwJrVOqNy8rhRDRMwUHQFcBrejPRZfD/7Gmj4sHI3cL23mWEvr1UUfxaO
         uwwD4SHEydFMLiGpKuOZ4tKpjYYiC+pOjtIJut0q3J2+TroXdmV5+gy3473Y11FaJq6V
         AgDd3/1tQMmd2AaLfbP01/sOGLQfneGLOmbjstvVOL2XGhdJdXXn0u8O7QdR1gi9AdVo
         JGcFmGuTnqcpnrd7PA9gDd5aOleErt4lMUE1taFZ7kXkCbzP+wbasu8VeAOhUlDqf9rF
         Lpwg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/3EkKDXpOvf9JRT/IxascgcAwg2InVnkSziDLh/EA6sgE4R82av1IW5j+sYOnSbOTiBf3uXSPWA==@kvack.org
X-Gm-Message-State: AOJu0YxWr9fJ3aw64u80IsbVSOfoIt7UFc7FlxxUcRWD8z+w3qycIQqV
	UawwT57ytXKK5b45XDoFN6RbNzgrSTpPwDAumfsgutZcGnw0OwZHaHk+0VziZPmqDTblxTTxUX7
	y7rU0ZA==
X-Received: from pjbmm5.prod.google.com ([2002:a17:90b:3585:b0:38e:2f99:ee94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:38d:f096:a1dc
 with SMTP id 98e67ed59e1d1-392620e71c6mr31494631a91.11.1786398400920; Mon, 10
 Aug 2026 14:46:40 -0700 (PDT)
Date: Mon, 10 Aug 2026 14:46:40 -0700
In-Reply-To: <CAO9r8zMMqSV5Bf1+qKXCG4x0X9ZK_RMq=X=2ccjpo4D2mEU-qA@mail.gmail.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <DKJM4XXSPQLA.13XE36MX0650H@linux.dev> <CAO9r8zMMqSV5Bf1+qKXCG4x0X9ZK_RMq=X=2ccjpo4D2mEU-qA@mail.gmail.com>
Message-ID: <anpGwPjdzUZ1J3Be@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 692F34000B
X-Stat-Signature: guzoe8ofq3x3qeiornc9d3tpceti6iia
X-Rspam-User: 
X-HE-Tag: 1786398402-243376
X-HE-Meta: U2FsdGVkX1+5wsbao8U2fnaC5CQYjAsKQ2HDrpDgdUUfBO9LdMR0ya7f6DxbmHSaTV2dLiIHET1KNEs5KFYk1Yxr+sxPAqntZt4dqj2ZTkCugt4YGYqaiRjEMcoEEn5PNuAqvkbl5VUv3o5JFFyYYaRHH6J9NVt8oQlqe/yibsYvX6HyvDa2XKXoFjtkgwFoywFuOHZQ/7c/rWtryIhutxyhyh7+66TROfNDdOrgmH1GUBvOjxhzY0mzOm5IIl9ivmcH5GBKXU5SryHyWzjBELfzHKneRSLZc4HCm0DCZAjpjWSL4VIhXZObE0fkNLoi9T6Y4kslxL2hblZ6kvZrkdt0PwAbmD9PdzxACKvSqzx2Il2VvGq9rgtkIhgMRZQcdCYkM5zBnd94pKsWfNb70+0K1xTo5tMWfdL3yg2RZUfB1IWL/VOV38EsfYH4zpf0OuNCwthSBFlUplUhUBwx/qdwZJoXxUMDOIlYt6U+0QbNw06fe1nIjPqamx+VRmv2E2L7B4bLqSsYuuhIYQcKuLLpd5+tTkaDzgU5g2L7EaStndWanOJPIPOop0d+zXTIlXxkuaaLQqoS1hNheJ0hvyAJIZyycvXiLl/8Y4aVvhe4IiiJ6LbOiaZRLXYqoSlVeXEdb7h8VLOa4VMDeRkJe7d46+5wLKbJsDzeuhmMqZjpMLsxSvhYT8exqm+diqoiLzNTGuI+LZrGf6z89j2qvXY1mHF0eOekwq3ww3EF07IUjxnJN+wM2pH8JN203hM3figgP4eLLcqym9KvWEvC+HRKb0hep0jUvN6Q+34TxmSu/YAasUWxrn9l2AMx/GVXh5d+VWHN5z3lMtgUf65ydyxtWPAi9x09Syby+P7io4LChVHbN8wPn7kO03BXDsqj2u61ffwiFuANZpqvc6asGgMqRWERnTdhP6NcclLSVh9xx/KfHg4N5OliL8+xV4HAFGMEIIgr8kXGrVvcoIv
 aQ5KGQDh
 IARVckPtqqN9BsIcrFFSM4Yj6/69wR48ksdSy+ovnvMBQIzzN0nHuQBJ/nQ3ZOmZ49HR185nbilH0KP31cUsTBL7Wi4IWVNxSvIlrDFpERs2FDjb7nSDPfUH/lZjEaCDDjdYLZcQTAVuaV8U1mNhUvZZdiNKTELua5r4K+5H8Y5c1laAQIQDsp7dc7WmxKIwMJX1n5EXWq50/L2g/YaHpRdY+Cz9T3ZULXKY+CRrpFuwWsrh4GBxVGv8+zUdGLAnSoDrodvzyAL1UMSYjDe6ZVR3bfyswAwxX5CxAJsSH6nc2gbQYuAg2NiIPCWQNc/DBGiw+xfJmYhsA0XROYtlDLHOErR4gPvoU4y9vb8/F9lwjzvlEjlFpzClyUxi6/wkeVsS6gn0+vzK3yeXUQa0AszdMLyawXmHNWLPqdYSDYTlHI15ylQDD7LzAzAurmk2fZzqm4Mnsue5ZHo9eMGq6eOOzi5ZQr4nA/9TiMyqJGP9pu4zX7k6oj1SzoAaeN7FjqQmFwlc2ZdKZQhYFOASFBcYn4eNBqN6vcYvnURrnmu2Wbymcva54krYzmWJdtPnMg5PYgqelRdXsUdyBp0lVIz8EWumpvlFjgd/1romt7kCl+k38Sy5aHwznorfnzVmhopCa1eDov9AOmxd19nXW+A6Dv1AkaykTqP1iWBUzO+ZDjwbToBhUme1QCIddagYn+2FUcGRmZ1n9b/90gXh0q5U2s+V0BtZ+qu3EKPqkfFuS6BNiMOoHFxPyJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026, Yosry Ahmed wrote:
> I don't actually see any inline responses in your email or on lore:
> https://lore.kernel.org/all/DKJM4XXSPQLA.13XE36MX0650H@linux.dev/.

Likewise, I just assumed it was the upstream version of a butt-dial. :-D

