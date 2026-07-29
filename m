Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E24C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2079E6B0100; Wed, 29 Jul 2026 10:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEDB6B0105; Wed, 29 Jul 2026 10:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE3A6B0106; Wed, 29 Jul 2026 10:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80156B0100
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:38:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8DD61A064B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:48:21 +0000 (UTC)
X-FDA: 85041338802.08.8994A73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F9F1180003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:48:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1WS81zR;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785318500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3kavLQPrcg1Sh5FW3j2MvQSeDETGM5qCzr0BKWnYHk=;
	b=4ZxBqCqRRakNXFqPfYRdYbWC8iOxIpovJBUjykmn3TOrE4lMHj66K/MuxPsAlvZII5i2Ke
	ASEkADnR7j4Dz+ckrB4taw0NnTIEufLqCYhuXMlNoj1M8XUVaDESqrSctqIiRZT9ualhPe
	4zbIkoXefPULjjRaRZsDDZ4qOWSFQkw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1WS81zR;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785318500;
	b=uoQ+BgP9mVlqPgMDiuD+IAFpKZp4flrK/DuiFSr4xQm55uqNsnPqSUGO2d2RrpUJ59Hu/n
	FnBqzA9yg6iQZFL0HjCm4+QX0s1RG2L1D4eTiIgitA5FpeCWnTpF2EBJeHT4o92yynBREu
	maAFW7fbpXxyXtqJBxp5D7khDS6hhTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 957EA600B1;
	Wed, 29 Jul 2026 09:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A211D1F000E9;
	Wed, 29 Jul 2026 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318499;
	bh=n3kavLQPrcg1Sh5FW3j2MvQSeDETGM5qCzr0BKWnYHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g1WS81zRqxp6ntmkfWCJ/QHGDs2iluZKCkthWT8JGVuxkkNx0zByC9eXcBjtLyO4C
	 JXAzbFFV3d0ScZ86JfUrVV4iJxm/EIYL0VZKdzfDmogr39q7yuuVACqQiacg6b7tze
	 rdWULqvMxCS7yq0ShGwjscSE+WLzmrfdvM+KuPPVPIdpOomJOiPjyB7DlTToHfeHiH
	 UQ8Z6r3CADQDRqRW1UjIpyrTHNXvd5O4uhR+XaxnuKNH8vnTR3J++5aPFlVNKbQ+Pq
	 ETxdaOl9e4eqFE0aMeStkr6BRtNL5bn0l4hg9E6svg89SsACLwEQJDeG0p0US9qi/b
	 GFEXeh5KsjfSw==
Message-ID: <dbe85481-6260-4b17-8930-1f5d54bf6d16@kernel.org>
Date: Wed, 29 Jul 2026 11:48:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] mm/khugepaged: unmap pte before releasing vma
 write lock
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-7-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-7-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F9F1180003
X-Rspam-User: 
X-Stat-Signature: k76x4kw9gqqgr5rx7d745hfcfn547bzq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785318499-854489
X-HE-Meta: U2FsdGVkX1/Ngb2rXpigTSRgXbSWvhDxIbyYriZDqtbnUBkxHjSqf9agYkQ5rYXEoJr+yvll3KWcpdKfqtE8mNFYW/MWDDhAcbnH8LWo/hsR86sjkdo1i9FjaR8qMvVn7C98AF0smOweeHrDaPtki9uPArHjN4jGnlm7XbFjz3SKwO7cc/8L4Jp+Cag5RgrZImyDMPfWPqb3mGbq5yUbV/M8mXQaXWQwOpSfuf5Y2anlc5C8OT7eUAmKiALnvrGGCEJmY0SCaEhFD7D6a8pQDr4kXZel30wEIwDehvbImqiBe+zQU956owuAa1OOrSeS7ROp5DAVqIJfljYceDYl6LNdUn7jQhKuCvM551sgxhQs1EjHrTpyXfbn/LVYDNf51nQy+bGlqaRaGimTkJIhPNZVRMP6V6Ri/+h1R7NnangKd92d1L0e9GXPHrZ+o5S16kEH53g1DbZPI2xnYNizYPP4HkmlkuWz5J63AJ/jKQnVhDNwaFIpCJ2L1K3q7Sb7szRd55OkPYi12Dobw1YZbgO7wGWAaSURVXCWaeQPPsYyGXRxBabt0ukshjObjSaNf01qoS1J032iQ/XdgE+xui+kSaTJrOJ5Vc4W2Dlb1Cw7BMxogHeORH/snswqrN7n6Ztf4J/X5fpCU8MS4NtOlaTJqR2zO6xpjI1+ZGPtKOhXRpDQljhWBzNU0ZAJ8l4EOsbJ6P2tjEzKmqaYewoPT/83CKyPaV6errlkdAlk4609IfHQZI3Olifqv3iN8Rfn517BxYXUyzIUvBtLj76A3HVxwK9yotVFc86/4CECSA/wSxUOpA1rZkfyvaF23Ej/ovwb6QCGUj1DD3ZVOZ3PhrUHCwwnAT3JMKk2xmhT0F2fV3iIDEkkz0v7AdZv+gs3n/CmeqqxYzAy0e6S/j/GqYEmPenQgCAo8LKU+i/rPLX046qjSLaa1UakMQjmsp43k2OZjtd7J2ERQ1/flWS
 jicTOs/j
 BD2HhfibSvMs7hSRMah53q7XEYN1DRfUJgwj17c2eytdodYAG2ZDeMFGSxbYAryO2GkmbQalvATrTLleWjP8v6NN9PyOEyRgWQQfegHToX77MFYqV4804t2BuSu4juL8Bi+D+NMnU8hy+O23MRjoNKTMBG4/KDftA75cTHcj0A/0NTCS701/gLqtAiewrWRCqEDdg+ob4Epgs638+7Ha8foY69Pv7cVZGQT/z85r9sG/yCutnSqa9ab75OQaxD8qgU1brvwTSqsrQZGlJL6ipYDQPLayC0CGQJ/XRQWEviHXjngQpLhdxWenNTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

