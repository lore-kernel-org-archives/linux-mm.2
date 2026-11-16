Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F75606A88B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikf9y+eb
Received: by kanga.kvack.org (Postfix)
	id 013BC6B05B4; Mon, 16 Nov 2026 17:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C5C6B05B7; Mon, 16 Nov 2026 17:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B276B05B8; Mon, 16 Nov 2026 17:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2B0C6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:30:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36FC41C266E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:30:14 +0000 (UTC)
X-FDA: 85442426748.17.F11FF95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69D22A0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:30:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikf9y+eb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794868212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6fhJx/sPF2j9L/w2dByxX7AjmdD1i+rW4Z9BzXzRiQ=;
	b=5yVLyeKLtCe251MSyoNT5+OS/81HezmEtqPonAPUP9d9WIL+eMo36GUWS5JmwmK3V6UIpX
	Iu2PgdqvI80ikpaYVkSBDu/ugO02HTdgDhoo8WlrIuDYjkynJuiWbq4ELHo7/6myE0j+xj
	qUUhIbp3g/iJ4drbKWgiGmasQqGKUlQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikf9y+eb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794868212;
	b=duNwS74BfSWDOgTNSoRxkrT0J+OSS5dYLzwasWBwq8nQwP8c+R8s7E/mL7JEbaOjx2DkEX
	A9JehvMgE/iMDF+XLysNEl59f+VqY9G3QH1tzlgkHDZ12bT+IWnu4K7RjgG/Oi0EDYNslR
	0fvQXjmfsnnNjCiV/RIoKJ+ZJl6AOVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0903C60DFE;
	Mon, 16 Nov 2026 22:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118CF1F000C7;
	Mon, 16 Nov 2026 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794868210;
	bh=V6fhJx/sPF2j9L/w2dByxX7AjmdD1i+rW4Z9BzXzRiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ikf9y+ebsZT+HzEkChEiMZDnNutS1gG4lMjgRNrIBdIaGgn1g4KDb52HTnc5/6quW
	 iSN5JEXtfpkyTANgr1Mnot8rOJhIiBwpUfiUX1OTWfoOKDy/ygVEJDHr4hBGSjt42W
	 3JE0mMYhaYtt3TmH78mgkpZFK/QhfJwlvlfbphzXWBTVXUH3exoCFb7EL6epXrPpm3
	 SNIRFlW7bUIZXpXh6Ai9vzzoKQJg7ein+Pivg+SLuSGCZMEjEbFuKbFAKJ9OZL3PwT
	 WgqFIYcepJpY9n0eUM71Mj9tyiNlKZzsMgiZ76Q8zlBvP66vEW9FAAdRwisNcwvix4
	 kk/+FSLEfdW1A==
Message-ID: <175e7fae-2254-4e13-a4ba-0d39fb82018a@kernel.org>
Date: Mon, 16 Nov 2026 23:30:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zt1ywn1fa5xfrkxfm3qq491wepu6aidm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 69D22A0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794868212-176145
X-HE-Meta: U2FsdGVkX1+EU7S7rHV84B65JhAQjAuWgpvH8JA9ndvhdWERn2Sf6D4ps5jjc+LwYPQUfTHexT+YkQqequ54I5pgPhPKqeFCcHg+wL751JIh+BHS6WtKB4BmF6ggUOUFy4dYjmsFRp/k2rOKXyUR42upzH3NyYjvroY55vR5AHwJvYND9Svu10/xYaKTQk4V2YF72lSG9BXwjdI7vVkRUu8lh5LqUHdMIH4wPgEl3P5zhpCRJ4kpJSnks3uMq3dYI7u5XvxDYokUe4b6Vqd8he+INaYYRvPzDXA9eQeK9DGFR/uMzTLkgvwfpA7yeH4fEST3cYk0U62bb56brQVfdOkhOBNiz5mkMWOQExNqvqmhZYm8/4KE87nU4J8GhIaik76/91MTmcm+lVDcWJKfJBq7b9yLNwSdGCroyV59PH9r7KdJHcZsneP8B82+GfCVmbEK0yNIxR+gmlG9WefwBvDAh7jSSnseZUISu/t7mQEbKl9RM68xrS+3iAnHIYqPJGhs1bGAxmIyW3J/eJqltnVZ0p9L+EfQJZ0zEk2Ks66CewE521taN7+xEYgNdS9E8Lghu4AOen1IEeLaZP+444kQjGZGvj+c1OgIIrRt29+JO7vgirNfapv7nTSXuUPYGxX81CbWDzTVix02HHiWC3HXxqxCkcSCit/OBCNRXoIP7vntNB2oIyN2QaGdougYvm2cDq+Dde7LPLQS6a5t2hmDN/gi/kL7r8BHiW2jJKOvxPdYJjvOcRM/XdxIsNGoKXKaBRrGEVIGAKcauLzjjNSRzOrezz/2GEoH1+ktxHGhqQ2d2EwdvAFeowsxITlGTs0jJbKq/F29lXQMw6jn9zj1H0rv4Fy15B2e+4sqhvtZ3LPr/1TVI+gNnFvycw8s7O165SXiZ9oHjiV90GsTMGREAtcUxWRN3A0e/gZ8k44lgIZhyYCUfiUoDI/Pfyl6Dc9KjBlpE4iV9Hb1LD3
 53JwvjO3
 bBO8QmsiF++I4+pWfTOIzu/PHrhxCi4z/8ygPycFlh65gFNBAx08lQLLuIEmtWla1vCIvtpDCAkLCt2T7M0yDQfC+iJWKgq4d7g/Ev6wvtLjx9Y26SSfvgcnPFtJ83JGqIaf8gZyHtHbA6wt5Qm5/HnD05owzm74ZasTGf9KIo3XE2IE1WJT7A6nf/Zw/M6XeawiorqO7zXkDBKmQt5jImASC2D0iolAhTili+Zk3Wmv2uLsdZ3QwoAyNOQQWSpuCn5NMbKb/H1RBtnlXyvLVnBEIymDNZhjQNILRKv+WrGPXFQkucQoe/9qhwTkyuAQhU+8dpvt/RI14uvCu/60sDJaAewPQXGOJbRDyJwytABhwXvGV+vWrcXkGv1mJ4ESmG9jEF7hkoSEeLzz3MhmR/JYcKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
> The zero-page remapping in __folio_split() was added to support the
> underused THP shrinker. When the shrinker is disabled via
> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
> to avoid scanning subpages for zero content unnecessarily.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache <nico.pache@linux.dev>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e8684..2d56d1bff0ea 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  out_no_split:
>  	local_irq_enable();
>  	if (anon_vma) {
> -		if (!ret && !folio_is_device_private(folio))
> +		if (!ret && !folio_is_device_private(folio) &&
> +		    split_underused_thp)
>  			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>  		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>  	}
> 

I guess the change is not that relevant in practice, because I suspect most
people always run with split_underused_thp=true

Th question is whether "split_underused_thp" only determines "that we trigger a
split if underused", or also "what to do when splitting a folio".

Yes, it was added for the deferred shrinker, but the semantics of the toggle are
not quite clear. I don't think there is any documentation for it ...

Disabling the "split to zeropage" entirely with the toggle off (behavior before
the toggle was introduced) makes sense to me.

But the behavior now already like that in the kernel for a while.


I know that I suggested this, but I wonder, is this patch relevant for your use
case and patch #2?

IOW, woudl RHEL customers disable this toggle here when running with KSM on
affected systems?

-- 
Cheers,

David

