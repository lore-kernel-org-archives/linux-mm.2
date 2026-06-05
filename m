Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73918CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4D76B0005; Fri,  5 Jun 2026 06:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F066B0088; Fri,  5 Jun 2026 06:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D7C6B008A; Fri,  5 Jun 2026 06:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 834FE6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:07:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13DC5163C41
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:07:35 +0000 (UTC)
X-FDA: 84845432070.27.374D81C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 889AF80004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:07:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gfHC/39l";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780654053;
	b=pQJPf/uuQc2dAwVv1/4sjEr8+MCHzGBENhKcrKPZmUZTCcSUl6x25xaGu2JkWk0y0sfI2M
	weX02NvdIb9R0k1+lx1RUokbPYSv/z7OTX8wRtNjf67cixRKrR7OeHwQ1qg9ZuzNO0jFHI
	6BuE8IzoMxV5rWN3pUdVD9pq+V2PZCU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gfHC/39l";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780654053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDWfEtj/uv2UeI4MSIT6eBgOcKQg5g0Z1Ndc4JZpq2Q=;
	b=aO2TEm/ZO3f6jHpuft/zo4C7vHUkvGyEv5eLpXvMSwftJZHbGWhf3Q6Polzs2c7CIkvn7n
	biwLOWM+RMJAvRXB/tKO0QoSNkEYH48zWZFmoiSvmM+YDjZ0dy7jdCl56RlmbCCI6k5QPQ
	LdziZWF6EiUWQhwxKJ5fjU5ZqGBszE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E40F7601F1;
	Fri,  5 Jun 2026 10:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670F01F00893;
	Fri,  5 Jun 2026 10:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780654052;
	bh=QDWfEtj/uv2UeI4MSIT6eBgOcKQg5g0Z1Ndc4JZpq2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gfHC/39lBZlUSNCckLLDS7HF46/GQxX19IkSby2aUztDE8K7hPG+MuXxXId4/Rz/l
	 9lnIb5AZxQyVxYh/5z/3cMSjEhKE4Guo1tNieJQxhbfkWj52SWhz3J1sg+8o2/QcVj
	 1n8G9Cj6Eyq0NQQtaYaMoHl1iHdWvrRYvUzcjA49Rzm+B4k6P/nsugJHIYzPS2ClQ1
	 dJvTr0Oz7PrylhrISfdyaJzJBirjDYk+uy0yLImiFtuC5BefElHO/7pmhVR1IgU/n3
	 8bJB7UbQQvHgnlDDzA052a4Qb34uEK1uK9ADMffVc3MmR5SqEZh+1upTkzpo+BDhhV
	 QhA0H9SveSkKg==
Date: Fri, 5 Jun 2026 11:07:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <aiKficIP-akvSQAf@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
 <73762983-d48d-486f-ad5f-78015e6f95ee@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73762983-d48d-486f-ad5f-78015e6f95ee@arm.com>
X-Rspamd-Queue-Id: 889AF80004
X-Stat-Signature: jyd585fqe7iyaomo46ri86yfkb9sed5q
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780654053-328236
X-HE-Meta: U2FsdGVkX1+U1b6LBlwi7acp3dspBHNu0B6YhI9+jd/zlOpf/aEbK8us4U0G+SY5i1Xb/NPTttEcjnvoR/e0Ghejd2kyb/OJZCNAMz3esmIEWjXNfXZZvH+RgV0h5E8GI/B8E7hYVEZ/+kjKtGKGuxitCj4gWzk3fKJD2XiO6dr/wNTcmQZXiebIfdf+j6z8xE+y48UTSNflt/7NMyhNKZFkn7qAfzYS3OWAAF8UJvf9AXCfixDPEtnvrm4Uz6jTMSnIIgw2MZ9QUQJAWhBEDWGpsOqX357aK20NSxE1tJyn4gym6xh7vAfDAO9nC1l7xYCxXGKJ5NahD0MABhLdWyyb8Di0PZ7iFyteG3DhR3eB5utynIgN2WJNdGBaDYwQ7uBWAz11X25mPexanzWKfFFg/gNjzkCGCXJQ//jMPy97Sz8pOLITjRboNXC4zVua/x0djHIFgDeqmTAfMWIv9AqvzkMHFLWOOGShF7eFiCn0lbiqwxWiPs7PpOW/jr3Gk2e6TqlLDBswNESWwjp5er/E+jTjKA/8JfwLamr63jfMlghahaeEk5yPtAdCC6yeGOJ0CEU37VE8hJXJxaWmiAjEkZOuELwn8s3YfWlYbJksTSzGsW22yLq6cNClkvdnr+6Wh4LtfPJhVceweCObvvjgDy/skXyQFEkoJcv6208mQnpPRX2iOhIlZ+d1pJ13u3aoXLGIGEb+ruWS4yxxjyLtULOhoev7F1yzmrOzRaud8syeK5hiRge8YWK8TEwAXKrDkG8MqlIq/6hg/yjicCcekA3JTYIu0bbFSuqDpl/iF/OVW3fPX3lX41hGvAsz6lpDeeOvO9yWrT/P0N/Hgcx7f6Wc8L8B4gQEhQoElTY6qPTLgGZKXW+HPzbkku5Yx+EuP1s3arJe/JXR6Tu8ksclFYHXuiF/MWj5fpIbdwNOwJ/4/tZyWnHUZZp5U949LIVI0axCEYvxB63iaTe
 L4wPQ1MU
 I9CfDEn4cxj2KB5K0Coum0EtVkWyphl5Ks+DVtvVwU/v4ELDN2Lt+RMBQHROWuHtCdluEaXWbdOAyqmcitj52VxPKlG8Fk2m0fTWcOZCtRkRPMmpWVK2pe1FmtSOvycU/L3MNuDmoolioYBOhIzw5MHRJdhj9aWzCGsPTITCfTSmRwITKBLjrXGFYHOaAvrdQnQ+dGpQoBs633WysMyVIkPCCui6mwbbdcqTaLkNH3o4KZgksbodkY3m/C3JBsCKxjp5TbFCX9T0ggahGZP0k3Ow5mDhmeyUNFbsGbI7F1D62LXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By the way,

I think maybe the reason you didn't hit this in your work on the spurious
warning stuff for hmm-tests is that I also had to set CONFIG_DEVICE_PRIVATE
(as well as CONFIG_TEST_HMM) to get this to trigger.

I think the reason others maybe didn't see it is because the self tests
will just skip the hmm tests if CONFIG_TEST_HMM is not set.

Cheers, Lorenzo

