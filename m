Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E05ECF45C9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745A86B0005; Mon, 12 Jan 2026 14:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD7B6B0099; Mon, 12 Jan 2026 14:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF146B009E; Mon, 12 Jan 2026 14:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC926B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:32:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5A30BD68C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:32:14 +0000 (UTC)
X-FDA: 84324307788.12.B1A3F30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D2C820004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:32:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/IL0uF9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246333; a=rsa-sha256;
	cv=none;
	b=SuhI5uIQZ8eoOt6MH9qUjKBR2v2sQR6NCToiUWoWm5E7p3GREeJRy1C3nEBHJfa4wmcvsK
	1WIwPb7ukrKtCKdMd9UWQRaddoBHIlFClvqTu89EBoIRHQhoD05NR0GDL48Ofc7NH1s/DC
	bmIEJwGR0Eao15lAIypbcCHcsXBuAC8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/IL0uF9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+KFqra2XACKbkUQYygnufJQTkSDAnPP4+682CsDCj8=;
	b=3mgb6Nfe1itux5BqldCq3IfJIWX75mN4ulFW+HnnjcFl/PfcbUDcOY4B9lHNu4wMZPOFL+
	YbrEAeXLKVvsb8ujN4fBE6q4fLbgpGYiDsQoyEo3zpW/9USY6rVMLG+FkwJSevRfW5I+Q7
	AchjYgyt1A/NNwNjkkWs08RFf4TzFyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B9106001D;
	Mon, 12 Jan 2026 19:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143FEC116D0;
	Mon, 12 Jan 2026 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768246332;
	bh=Cgs0Iid3CB2fSR2T7H1uIjojnsBHit8OyQ9XPBpYu0w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/IL0uF9F0OX/qhxxLaaD7L2ZjRepCGDawc12TuI27HnhSDHscuu9ZBiyLHKhxqEA
	 7OvA7cb7U9tE1hy52naK4hLJLmzTZhFT43QK8T1EBBKEntNr57n03Ej4EQNwAvEDv1
	 vDsL6D0O3PCxZVpgapbEi7hZ43x37cSrLuzSAiaJ2wDxgGJjLZKBZkRPm3W2cU8MaW
	 Kyv8e3rk+lPWCPFTb3bvDOZLi2cgiRO2++lI0h47s4p599s1ODN8uLPDSdYp8FJv34
	 s7oZvT5rZ1+C2794OYA0tuL8MaWcLz3esSCqqear3Gd3zLdWzCfqsj5oQW0ofmVyK2
	 0Nj4eUDzBeioA==
Message-ID: <8657edca-dcff-48d6-84a3-df23521a94a2@kernel.org>
Date: Mon, 12 Jan 2026 20:32:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm_zone: Generalise has_managed_dma()
To: Robin Murphy <robin.murphy@arm.com>, m.szyprowski@samsung.com,
 akpm@linux-foundation.org, vbabka@suse.cz
Cc: bhe@redhat.com, iommu@lists.linux-foundation.org, linux-mm@kvack.org,
 vladimir.kondratiev@mobileye.com, s-adivi@ti.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <cover.1768230104.git.robin.murphy@arm.com>
 <bd002d2351074e57be1ca08f03f333debac658fb.1768230104.git.robin.murphy@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <bd002d2351074e57be1ca08f03f333debac658fb.1768230104.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D2C820004
X-Stat-Signature: 87w14r1eo8e5ep5t6zo7p5isusgbypk7
X-Rspam-User: 
X-HE-Tag: 1768246333-914076
X-HE-Meta: U2FsdGVkX1+mO9Uu5XXWk+qN2h5K8AK1ICXrR00s9ZG8f1npHDQXdR8vRsaEDczw2oN00fjKQfszd4WSORu5AhX5KSeGHwlclErSyi8Okj5/zMbRrXZN/17E/NPGfKglHbOAZWbgY0bsGWSrgr9sFAJUrfPtvRBkhl7niT8VvxgTzZ5suPFrSKE67f62RRuxZO5V1U0vVKr80HHtGiVii86zjrA4Ui7UAKJnJtbPcPn7ZKrXyUtxPRtdlHaGkR1MI3sCNY2kls05rBzAJlAjUKpB11e2HwABXa9oOpD20XrksF/7Szy3idOhwTX8XFyjooE+CE8Zqo2SFs7/GbS9AxzC70bcKEhZ7ykT0I3aEI2iLVXEZkyfN4Dh2ckDpVglqAyiTS5x9ZRlEvjuFO0J6wF/TnEoHaLVVRh1pEy8vUlprU4mwcl6HeCLWQ5D/KTR2UHfff3KD+6ti5/f937xzO9hPwGJlAbGjhh5UXTaH1AWxsbOwmnbTcZ12F3MPo9na3GHpyLKfv07GSgFkZhM8ZDe6G/CXuqkGRbN/f6FwajtS1OgnkwMqPeVWellApwBqUP/GbN1UqP5+UkZSO+doZtZMrKWog56QoGF7/CWoo4U98zrDJE4BzROGoJgVNzyVQIKJJhUFs1j7ZApIVtgjeD34TFVx08X7zK3Ei4Hyj6Bd3jeOr1otAe2vcsxKSR5j9mZ4z281nXexbJs1GA3/Up3ib8SmvDFzsNEbA5E6nk+tySJ82aMKEC1BDLUr8rCvsPzA51tk52uDyIu0wBAdTtOTUKnzo0aM19CHLFuHCfI28mqiUKTUH8CZzD9IuS/HchVox1RpHve2P8Unkj5cUdubWKv0geAsYnsMGKD/Ne/IGEptOtf+1RDsOF9CMFvB1mCkks/eduS5sR5N7EjomPTqUz5V2cczDKEtvBFPdRqpQgSs6hWoSn2+6o/NX3HwzDm08X36T/qUVVS8FT
 NoIaYaoG
 5hzzCzwbpzVjJuQ2wha7qACjviUfJFNKR3NLcWtMJ1UHnNf0mYq2eM3SmbkCe6TrCc2NV9+Z/Zd9UCVj/6IPPDr6CTLMd0WX+3rOIH1rePqKv1HRLrCOFWf3OxSIIV/Qtf7eVg15uIkCJKz0EGjloYo3vnOEyAPLgJxpY4n9OE3geMtwY54uVjjq+DS/UNOesPj87nzp7pmMKFx2237QKacu8WNFZxhSkxQ+6iL+2oR3k4x8IDRo57HrnYl1BS9YlZWIxRKAqPUeCz4KwwjLTdU2B1YV/CpWC75ufK8a0a4EzPk/bXw5bnyIGaFrVm2T//ANui3vnv1pEzrycuDMprMS9rAzG0VVWLxmzrgR8XIILvVtRULjwbY+C8iHfu7nCbX8/IbcsSobodi2yjKUFYf3QSf6ZKVC/LQuV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 16:46, Robin Murphy wrote:
> It would be useful to be able to check for potential DMA pages beyond
> just ZONE_DMA - generalise the existing has_managed_dma() function to
> allow checking other zones too.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

