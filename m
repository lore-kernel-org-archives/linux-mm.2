Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33ED6C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CEF6B0092; Thu, 10 Sep 2026 06:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433526B0093; Thu, 10 Sep 2026 06:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A436B0099; Thu, 10 Sep 2026 06:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130926B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:15:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52388A4610
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:15:49 +0000 (UTC)
X-FDA: 85197446418.06.EE60798
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 862AD16000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:15:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gv5fyVsy;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035347;
	b=EgAL8Q4nPFQ+PZIpum9zcD/llru+KLZhISAmseU2KJpBYjF6oohSAZB/PmhFkBmw04p6dY
	mPW7YKU8BRnR1rYs57DJ4jG1O0sEn8w7KFNVSA8rZCtjaIw8EZ9EovTGAD7z7+2gsA3xK9
	ajmH0FAgOA6D8yla5jELmjeuezEFdhc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gv5fyVsy;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+RbngQimsasuZ1zEF2fUuFweIotw1Um8Y1N5tAyMhQ=;
	b=ssTaYjP0RSTBs0dTFS2yNUVx+qbqEDJZSEm2xbKh+LgsaZ5/O/oRfgokSblO1miULbEE6c
	ZFchuiwdggrlpTLCgNOSsPf4GHDqTKO3LcdPcz5JowELPGOarrPzGIdwUwlrUKVNdMh2du
	OHnh1U2GlzyuxE73eGtvyWcl8RcgldQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C45924185C;
	Thu, 10 Sep 2026 10:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6321C1F00893;
	Thu, 10 Sep 2026 10:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035346;
	bh=J+RbngQimsasuZ1zEF2fUuFweIotw1Um8Y1N5tAyMhQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gv5fyVsydlN77cN504+9qhijPZ/xYE+efFyMRBFVYdQzq+W4Z5flqI+tMbBqCOxpq
	 S1MlDoi9sQG0kBV5rkBA7DAQaCXanGvukpUv1Qlu4T3uvn5P/GY7JGGLB0GtfGpNJ5
	 JkCZAHoooDHyFogj6DKFuf+Y8e/uGsdLi7+piowUr+0QM7mk00cmQeJQbbgRY5j7j9
	 UcS6XKRKPIpp8HdHV83aiLSkOU08bcXfTkrgJHcgSIe1On1t4piwXp6zrAm3PQZ+2j
	 GS5+8e6gbHzKh5qfhrp31hiN1+V6ISpDBrKZ08Se2x9VxAS+RzXfkt2ZyTIW9+4TfI
	 ASJvnWg25XKvw==
Message-ID: <d5131f23-075f-4e00-941e-aa0d34e2e89c@kernel.org>
Date: Thu, 10 Sep 2026 12:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] kselftest: mm: prevent random failure of huge page
 split for khugepaged
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-1-822b810458bc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-fix_split-v5-1-822b810458bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 862AD16000D
X-Stat-Signature: aoz7uawnw5ob5hdidqoeoj5ps6qthhai
X-HE-Tag: 1789035347-993002
X-HE-Meta: U2FsdGVkX1/USYp8L+t1NsAErocauDTmqtiNa7B7I1nVzczTGRGOLz9ZRDh9OM7U3biqOXPz/C143EogdQeUyy57kUPzXaD2WiS4Q9onHg3D6zJHx/kEiUWuMbmrN+heSvcXf7STZ1mK1RTn9oKDh6G8dyQ8f7lTHISg1otYH4lFXNMVDmuLutokKEEybggm57+w9wJP+OMxCm+/Y/l/qNbIBmKs2GTJOiopA0ePGoFt6oc7ot3Fa7OYwqmiGvQtxEmszz/Dd8a3s5L5biYJb4AyLH23RwbNVeok4s1p8pg2mpTkCYAuRzfcNpadYo9mpB2pPezrpKikVSWxO6k+SeVZc9K+jJlJiBHUjqgc2atFMg2lj76zY0z7nbOFv85dRfwMwoL2eRqk3J9XwqOa6L3mxRHufOfKRmhYnw/34rM88nlZ3FhkT2KW7x0KZ6PetBRlMFsiEL2UlKUbsVOjxTLgYg2eaI54J5tVRtIFl6sWj2urse2ZKO5P0WgI/WnSfCyj112mFly1K+gjS+0Pw4RmcLD3BMklkFQujfmlkzREOxzU1J5cvdi+cwUZHhyUvwSMZ8j3LxrmRsJ9dSg/bdNOjdVaREbx/zjI1FJEjdh89z5/eTZBkTA/iwi72UPTMxu1qJNpAZzZ9iFYXUSxPIGIaxx/Sv+4L9+4eO3+frZSVHEnGFI/NY3J9LyNZeJ0vHuno3mYCXT+a6a8AtIZgInYxmTWkqvJ8SquKcjNdP8E2b9aiRPV08qYSeseLPpV4oAZwncjOQSRc1Tmjj86vNtz9NyASA4irkAOA0wXlItHf1y32VmmMvGG/O+UU2GOzAUpeRelY9DwopvRgZqyif7ceHH83u8LB55ggyjljdAdbn6FOBHtVm0Vxpv4QyzjLj8wx0eqAnOPNpqk6RH+XZ/OTaN1oZZ4SyDibbY7xWaY7gTs/aH1iogTH4eqCBBJW7K0zJryRThHt+jYVR+
 gEyEBYVq
 YjtVTz/yp+MURjUXNImTFHbvUPC5zL4xSnDJslsKXqWJp2x22WiF11Dlv9UTdRj4sJWKpBCoDKzmz0pPEmwYRlpPxixEhsKclmJUt70beRbu50nv4oSBSzmtpjfSm++NOPic9LxzWXEozrl1gcx4Bt2LS3apYc1nLA0Srz5PwhP+KIR3sJg17iU8zH/JKboIaJTStYq+ejfVMcKr0d3XpymRQcPjzu+2AJ1Npogor2nfgANgYz7iHge44NsvS7nOY+flXmUTkBurbfcWO80Tol1PApgkTBw6AoTTYnjA2lJ3vJJJK6w3hETi8ZA8jF4WiRaKVm7lob2JArt2ZXMV4cPCNgv/EabQWIZQtSQ1AwB2Xtms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 10:19, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
> 
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> 
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

