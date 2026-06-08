Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D47B5CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4418F6B008A; Mon,  8 Jun 2026 08:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F17B6B008C; Mon,  8 Jun 2026 08:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0266B0092; Mon,  8 Jun 2026 08:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4736B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:46:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA2FB140253
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:46:48 +0000 (UTC)
X-FDA: 84856719696.19.A49C78D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02288160015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:46:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JeHD5VtC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780922807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pC89nERQStWmeKYuCWAC1b9Ikp/Z8/vSsZHxe88ImJc=;
	b=D2yE1Ry9X7AxeHaKCumNYl4kJLANnkmZu66/qAXFv+ykaXyaGWMSavvzLUh5oJh14yf2gE
	jTUPFiKHJSfHwIGJAeWtEVyC7edNGa789so+4ny5bR3CH9OY1o2qDsrGpIW99mOCEvnmYg
	k0Xse79zyRK4ar5dNAhhmUATSsW4sxg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JeHD5VtC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780922807;
	b=i/AJGzuMPno5RHjn+EGANkn7VL4xdfo3C1ESDGvRb/37WEtDXpc0RWTXM4e6EaeeAYo4UG
	hdAvhpKP+D+IChGsK8lg0EdHbNMCe3TVWz6ZeBlna9bG5UTWmA+tgV9NyDYQcha5CpGomA
	njh3JCUE41GeykgF03N7dpvC3hif5y8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C03440D8F;
	Mon,  8 Jun 2026 12:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515F71F00893;
	Mon,  8 Jun 2026 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780922806;
	bh=pC89nERQStWmeKYuCWAC1b9Ikp/Z8/vSsZHxe88ImJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JeHD5VtCQu8/oU1OSlGmBc8VeSDAgg/2WMHzTprzW1NS9u9I0wejqQLJoQafl/0yO
	 yh3bCNNCZI15QGxHdgD49EiD7yLZmMC4vJOxjIZSNUNSSJ3gca4SYr9a8F7S0Q5jmd
	 cn4FTS+1rVkKn0KF4FpRPOG4lVkbvIR5adUgS69u0NGrWJ/lv9XMToTHoBypGxfET1
	 8UDJLAGxcgxHaD74QXh0EdlHB7k4YFdfDHPc4oVr9uhzZaZQk6lQqXEaOcWQ+qaG4Z
	 Fy7OX3KTLnuqQbHJg/XkFg8BMxyQEN+a2GotqSoTo53OYfKKwqVpxJpF0o/lvu6+nB
	 TpC2blC1uSfZQ==
Message-ID: <8ec82477-b497-466c-902b-82e108ae2b7b@kernel.org>
Date: Mon, 8 Jun 2026 14:46:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
To: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
 <aiazXE8pUDeCmP7c@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiazXE8pUDeCmP7c@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02288160015
X-Stat-Signature: x3mmqin153ftw31uk55ddwyjcczjsqdz
X-HE-Tag: 1780922806-428640
X-HE-Meta: U2FsdGVkX1/MwNU8eCYGElmJcNdUBSzqb/PjrlIxcI4oOzsQcEkgPjXNZx5OsndDJKCj5yMQycDM2Vs+ECcEjcsEfQpGpbiNu0Co5io+jNCEPlHCmNP3rBF/nUgWKlC/fU1o3S/Zvhalc8hkpIImEmiVMjcwHplsZ0/3lpv0yz1fn1zRqqwxRkMEhJmQ4A80aLvwJ5OprbYWSyjRPQTmdHJ2588OQ2k0OYkEv6WJkLt4m83LgfroKSFqCLbcqNo+1SiWMasO6bi4KDagP3YUt4sCMZ+s5wnhgLflJux8vd39qvy2t+TNPfdEbuUzaJhQB5d56gLEJDglK9wk6kdSHD6PHHe3RRym/z/EeeufIKoEsBHx5TPEQHScUHdcIbYwUZUrbrgPcWGJYasZdscRnna8S+IM3UpP0Zfsri4lES5SKjU+ZJJs2vXlR8voKjp2AK71aF6mMFAxOxrg5zdV1li7Yk3MmCSSGwj6JE9LeWjvWIUQZEeh71p3L359D6ffWtPQnbxIuW4Hx0lvxNJ4H6NFRR1cusTNRZ37mhXX/vzIfy7/JtkDalZm2jiOaalLTDsDZFIsboWyYeYWUTx6EpbDrqHm9ZdYqQ6n6dc4DurfPsRRdBof6RMV9TAAyybmkumBeNaBNGNk2pbObQA/yHR9FBlLQZj/yFHkeP63g6IAk4v841c1Mo107XTFC1GgAgQEX1rO1tObhpiMetSXbsIheh6k1w9gC4IvNEJ22k/jwSY5j1H5UUR5kkvQXKTFdLD8eCQH+6Nj003Pcv+ZMyeD5X7iDOExucy4JvBWtg1FrGJkZTt5AWqTfbNxZqpc4g/A+Sd5PTKArNJeIJ+uKQ7oJAFGdqFKtPGEmqzSDmIe3RgTKyue5zUWsFGqoNzsIJXcrHUxXyaH7Zxi67jaAEx5ZOw58lXTlaTfl++REnw7DzxxFT1v8ARWtkVSgP98FLvti0n0+iCsaIstKoj
 27THqdxN
 6C1yshW9aultXH4bBLMPBP67+Br5547aUxcxjSSdKtwwB8YTC5x/w9sKX6wyh+A5iZI+JsdafxiucPp1ReaU2GRmwDH45sTNrQmsNAKCi/uf3uey+Ylv7Q7B9odDAL5hsPYX7IMrg4fbQtpiaSiE5Cz60Mfb9NvI0TrkXwaljZ2vy9dE9T+BQ7pL2WvuyV0JLe8m463u260CVhz5KDdGhejJ4cirfuMuXW6uv7v2E4KOc4KKgcMJ8U+LDUpumClQSUAbOUPHIlzpIOQq8e6QZW74ROcR0/2CuQYQB7eYRTrm/gRFC/CYvxKarTy7tpsIwcMen3r4+qG9vC8SPDBmSbqlyPtfDHxIVdYyVog3mK55MwD1uBK5t5EYja3R3IIsUwrU9uR5xshGWSSS/oS5780zd4O1vDjvjWwuqvnNCMhqsJRxGfepL6XBv7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 14:25, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:38:54AM -0400, Michael S. Tsirkin wrote:
>> Add put_page_zeroed() / folio_put_zeroed() for callers that hold
>> a reference to a page known to be zeroed.
>>
>> If this drops the last reference, the zeroed hint is
>> propagated to the buddy allocator.  If someone else still holds a
>> reference, the hint is simply lost - this is best-effort.
>>
>> This is useful for balloon drivers during deflation: the host
>> has already zeroed the pages, and the balloon is typically the
>> sole owner.  But if the page happens to be shared, silently
>> dropping the hint is safe and avoids the need for callers to
>> check the refcount.
>>
>> Note: put_page_zeroed uses folio_put_testzero() which only
>> detects sole ownership at the instant of the atomic decrement.
>> A concurrent reference holder (e.g. migration) means the hint
>> is silently lost. This is by design: the zeroed hint is a
>> performance optimization, not a correctness requirement.
>> Losing it just means the next allocation re-zeroes the page.
> 
> Do not put comments about specific expected races like this in the commit
> message but not in the code. Subtleties need to be called out.
> 
> The commit message also doesn't at all explain why PG_zeroed doesn't
> suffice here.
> 
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Assisted-by: Claude:claude-opus-4-6
> 
> I really don't understand why you have a 'zeroed' folio flag but need to
> also have new API calls to detect that?
> 
> They're also HORRIBLY named. Zeroed as in what? Zero page? Huge zero page?
> Memory zeroed by kernel? Pages that userland happen to have zeroed? Or host
> VM zeroed?
> 
> Each are cases we address individually and relate to folios.
> 
> You absolutely fail to clarify _which one_ you mean, and provide absolutely
> no documentation and add an exported mm API with no description.
> 
> This is just I think not something we want to add? Especially on something
> so fundamental?

I raised previously that providing a folio helper is odd, and that I suggested
that we defer this change.

Maybe we'd want to add such an interface for frozen pages later (to be used by
the balloon), but I don't think we want that for folios.

[1] https://lore.kernel.org/all/5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org/

-- 
Cheers,

David

