Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE2AE7314A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E1B6B008A; Mon,  2 Feb 2026 04:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF96E6B008C; Mon,  2 Feb 2026 04:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05976B0092; Mon,  2 Feb 2026 04:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF8436B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:06:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D864C34C4
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:06:25 +0000 (UTC)
X-FDA: 84398935530.07.85C067D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE9664000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:06:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z6Sej69s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770023183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hiw8i5iYt8AiyMW28MWPQXYMSmeX1sWRuuFd/pjsj4=;
	b=x9yoD1NYhYRmJrszJsGW6O4aZYOAdcWM1kDlo0p9YVPiy9fVlGbJpZ1k8Y2jVFtEigoG+D
	uDxUmFmDbueYsd2oD6dTdncI0iGMOj1NCzZcRAYVksamSBCtjjICf685i0scWYpVNwp1rC
	Zs0QntHvJjhIddMA2mUEOZJS4rSE0hc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770023183; a=rsa-sha256;
	cv=none;
	b=fU0iRSt97Kh97yD1swnb7kyhQnDqtaGrYhm1QCZDQiH+4XM50RUzP2bCMofSLbO68GWvw6
	MhrgaJK9jtwYRw5MF9n+lwNGK0lWcKHtISulQbwTFbkOwrfgE2Fe6GMMfxuIahvjpcuEYP
	Cdfi0/KZ+IacYu3kKSZo9rAf4zQ4AjE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z6Sej69s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0294A600C3;
	Mon,  2 Feb 2026 09:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E406EC116D0;
	Mon,  2 Feb 2026 09:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770023182;
	bh=fo6NhVGIQqemKxe9ZZvK/jM3T+1bXA+BAOzWhjoeDDA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z6Sej69s+w0LKQ7FeIhvn14r/S0dGDexKBfNsmeHk3uxLqUHNGoQ6kEIkr0h4oZwc
	 Pyf4oI0ugpOf2JX5nNqZX8924gTOz0R1RuYxvGlOI3V0fqwunYaWtV2Rlw8TxJ5xBg
	 y17ILG1K8GAvIQPs57v5vZcnHibO9/Rw+1y3RLcvseydilQELD0QTxYztH5pK050Pf
	 uY6Msd30koKvgN2IqgDJowVjzlIEVSqxVWYFAtepjM8Eh/au41QpmBbuwHj7EtLKwX
	 A+jAXKPhbbIFfcAxcXuY0wRdFxqlHn9C1bNpr7pFSre12YGPIvJrv1ODSabL4/UtIv
	 5Jdc4GtLF6jug==
Message-ID: <7d6f5fd3-9652-4e9d-89af-e81ce20df8ba@kernel.org>
Date: Mon, 2 Feb 2026 10:06:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <aYAhRjI2xNdtdvWY@casper.infradead.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aYAhRjI2xNdtdvWY@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE9664000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bua5pjbakhopgkfg36a1e8utrok8rgzx
X-HE-Tag: 1770023183-910767
X-HE-Meta: U2FsdGVkX1/ttw0hQid5nQKGGA5tUB/817UjbcGWcAq4WSa68u7BXRq4DPEYLZuvw82sc/bzWHFEQzGayf9M3k3Lv/YXGs7CmnG/rPMbqfiAqcoDNUp1OKo8Fj1K1xVY8ZQHTMtiZL1fJ/AjzU8iEM8jQ7rrR2IdxGMndm5DKheVjUmdasd8FAf/hlLh2N3NZvn2/yjuoKNCYVqjERps9apxImvtfaQPHm+Jwr3Qd2TQaFbfW/hyQ7kPuyuZ37Ld6HtSGql+3/A3Y2mRd9qXvl/y56yTihMHGBMqxW/LFhWK2ddZWqBhrlYiQoEzS9Dv8kWlpGX7rNDGO8+TV7oztmzBUm6oyc8wL2sgbcvcFLuilsOE4wFmKCWasYO2/O0gE+hVxhqvIe8DFbQDOzJcIMvxZoKPWbiCAJvcNin8BP8WOzEQnbb6NwzK/c9YwDYIJChOnkPt76KbwIS6w3Qvt2wGE9ug/Of2M0IH3KOauWru3DF4OV+7HYtTHW4tr/UyCSLeCCaIk+/kSKq5hzGzAPznX0EcDQBLXfhbHwp+g2rtcwUnF4spx4VxLbC1yDaLSL//n1BkuwN5nHq5Ai17pwS7tslv16lRknpP9BbADA1TB3LdkXpFdJ6oyXXH9W27kn/CUZOHsmYg858Y1/+/i0+fhX4SiWxqRGIp6uQ/bqKDsopVfEtGP3yZcSu5DnHcBiVLDKvEO7NDZ/UhrU+JFgOQgfCAGnY8EJpz4SdMhdjCPOiLWxwQLhU/vfYSW37YJCo75wY2iI8EZcS6/tiSx++v45Cumd5ru+XC3QT6BFD6uBEEZ35TPGtBFAqCzBAJ8KyJ8fzou6kU9D64jXj76bjqVnG2mj5wCvxuBrfOYS+DsNRK/Nfd8jfnhH50Sr/9pzcqw3oB5SqFDX2kd7aMHw9Vi3VnGMBZkO/4AzRlPeqDkBCuehCGfwYmO3dW3arePj2MOlDpJINR5zHNMgJ
 LxPSYp54
 OiNpLLr2yMz0CT3/Cg8wbZrM36Hzt1zt29dJorVbRyZyQ3nOCivjANAuP6mLqKvByD8ubtYcFQ5qqFUJXklVBDoC6Lb7Q+h99NUNtbHmh9QlVd6S4gIbk8q3us2VgfVeTBOgvizRgMUFibjgXhSG2k+xAT/yhpUH5En1jIPNVPoh8nWd6PFrscJRMrjVvZpkedSSsC6GkqfilD/hfowGoqJHiwohCHN9mvDO0CCk7lE183RIXQdRR7IkaVbSKfQoUfAoR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 05:00, Matthew Wilcox wrote:
> On Sun, Feb 01, 2026 at 04:50:17PM -0800, Usama Arif wrote:
>> This is an RFC series to implement 1GB PUD-level THPs, allowing
>> applications to benefit from reduced TLB pressure without requiring
>> hugetlbfs. The patches are based on top of
>> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
> 
> I suggest this has not had enough testing.  There are dozens of places
> in the MM which assume that if a folio is at leaast PMD size then it is
> exactly PMD size.  Everywhere that calls folio_test_pmd_mappable() needs
> to be audited to make sure that it will work properly if the folio is
> larger than PMD size.

I think the hack (ehm trick) in this patch set is to do it just like dax 
PUDs: only map through a PUD or through PTEs, not through PMDs.

That also avoids dealing with mapcounts until I sorted that out.

-- 
Cheers

David

