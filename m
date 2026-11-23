Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73207606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezxpo+QM
Received: by kanga.kvack.org (Postfix)
	id 54DBB6B05BB; Mon, 23 Nov 2026 04:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BED6B05BC; Mon, 23 Nov 2026 04:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449E46B05BD; Mon, 23 Nov 2026 04:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18EF06B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:36:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83C8414031F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:07 +0000 (UTC)
X-FDA: 85465877574.15.78017A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D565316000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezxpo+QM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426566;
	b=q9kyIobk3tNU30w6Bbmb1640eXFB8FsOq5d2W/xF5byOa8rI21chTk8w6k3aZg+97/VCi8
	C9hkK+zju8CJJuvvElrwbBd8km5XcV4LuwSsYc+aFWD2p4MgNIaTbbziGAyVUZ9Fy6jV8C
	YGfAUL8/eImSSkLOV4iBRGy9JN1WV9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAWGz23rGNqzENElV956FqBAhMjVbGE4KtljtHFRvoQ=;
	b=f8G/mp43TvKoXu3M5RgpYasiCoRqRh75HT8KMFuVM2anQMmszGwEvzBLcWca5i974wPUhM
	wwwN38RR6i6ychtfQt8MAm4CLOfxXuVGjf/CO+LbWUBRHhZFjU40p5LcKrNU/QWu2/eAN3
	hz0LS6pc3F30r2Lx4BEtp1H7wDdQ6NA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezxpo+QM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D1A161F6B;
	Mon, 23 Nov 2026 09:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD811F000ED;
	Mon, 23 Nov 2026 09:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426565;
	bh=CAWGz23rGNqzENElV956FqBAhMjVbGE4KtljtHFRvoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ezxpo+QMyN+xBujUlkhdsWcEqSm1s2NAzsNjFK1q3up6wZtw6TX6Aq1sPidHCXCWP
	 /CiZnkzGdXrJ/UWgvOijYla3FbKR2KiyQSdx6xtCae+eWETscq8usrmZOrp1/5uN16
	 k2eIN3x8Ro+kcI1CfJ6V6onRNGWhHNqKawig996jO4aOND8L0fF4ALW/oxU4BFIRc2
	 kp/Vu9A4IVOi1hiuF8z6GOCNpBm7GSXq8UV1g0nF6d9U3AO/XX2/YAkSpdsdRYpSdd
	 4bRNe0u4G5+GnPthjr3+PpIYMopyE70A/9Flt14KAPPOK6sV7VIxG3p+HoMtsa1+lL
	 mKReSpbpCm3Ng==
Date: Mon, 23 Nov 2026 10:35:56 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/11] mm/hugetlb: use common compound page
 initialization helper
Message-ID: <awQI_KM4SaZoXEtl@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-8-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-8-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D565316000A
X-Stat-Signature: mbjn4wxjec1fhhhnib8ute61pkmp6uhy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426565-424661
X-HE-Meta: U2FsdGVkX18epOCo5evqfl1P8p6rQihtyaBJYw2kOuBa154dQ3c4MX/vo7hfcUkSJsSreEObm8WKRiRCTHap6GTiL64nHWmFZyLE0O5FaC/tTMlZLSSo/ymLvUSfgznoIGz2iRf8x7/KIGJ1G7plmfNpNH8UzoSYE1IBWF3+8E3qmUi/Obybk0mGR1uMD0v9XR5ReNnPRjPMP9witMVJQ5BxHi+xWAzkQHyTDRnNqLtKgKHKuq/PdXdw8ZLuT9CoJpMwwY7bJWzIdgUtQuU4xBKOdvPbNByokFEYck6cr/2LizgNWS8QllV20fEynWkzx1XQFlztZgPEPk7Ute1WE1ylHP+Iel/bpapqA3y84w/fdhricvoE0YyOE895DlzUXCgWi/+qtDTHoZ1LaH+F/IJV9zfOCW0nts7QcWHsBUgUHqr/aUayjyt4DKO7Lz51gZ8VzeaMmoBLJ5pPCLm9QLVi50LQlgzbOXebetq8QDTNjSSkdxIwuKZ9D5XxFAmGlC9HxCWEAYHwSB956bhaw4xtZu7ERnfsUpODpa3PW0vjm3Nk99qCvA3oDBMxQEG2ZNl2Gz01+3oixzfmaS6BtaU7knZAOrlOpx9B1dcO3xnchilv5xgZZ34LFUeha1WXXUUZ0SWOdyeMFZqp7HyQNQZAwO0zE43MOQkitJq4si+Bk0HrO3EnhnrriHPW0o7lRYsVJQfZv4IrjiXxD/26YTG6lN4/MlrfOGAQTPzmaOOD9YYpvsbKCLi5pPl8UkrAgo7gz4fd8oUcbnOV60+B2oGOqPvG/Smn5wzsheIloSunvgyHAirfCb4MyzZf3S8O0U7K3sfu2O6pCMUTqQCdSMrn7SS/N9vqztckMbYS7CVZDPcUDhslscpab7j/RioW0Van9JfL4GJ/Ycdhb6lwAkhEUxYNDhtJhhlJ6KQa8XIKMJOgihKLWAf0zZFc05+OkJHvpNZilDe3ogvs5Uk
 nXsmGjCh
 /5jya1S7uFqm9a5lC5mCXZdPOLQdUPQRifo2T/tvSM0cAt20hHmBeYj3XWy8h6LWWZbEcFymNaYlACgc1sfKkQxUaHMyznwcSacpjcNbV5NsvWMGtX2NntNtJEz4ytRS2MQ364AzLB2FB8C6RuWznu8Lb2waRLlE3tqbSlTJ867hSZbOwEILmCQKV1zjhtXEMZCCnDVifk+gzVLWu341J379oiel1WuF3nj17S1rQxT2n0XFp1yzIv87isCG8vkKw9CZUocDcqnoeXaQBVkX5vXsrcnw8P4pvBHwJ+c3rABRnxsBmlehO9KuUkIs5OCXautQ1DPynXp04Mg1WKKgoaCpXN4DeJst2iB2MyOYX5oZk6bsrspeRaVmQoT6N7S7jRQ8MwROV3rBjcx6pw4miQybW5Mw8C0n+yM2Sfw+fnookYjT9lSkYkCKH6ns3o4lZk0SjlOmos6TEmz9KRtP7WtEFbcW6IwRWMT9sQo6MTDpiWu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:52PM +0800, Muchun Song wrote:
> Boot-time gigantic hugetlb folios currently use a separate path to
> initialize their compound struct pages.
> 
> Use memmap_init_compound_page() for these folios so that HugeTLB and
> ZONE_DEVICE share the common compound page initialization path. This
> removes the HugeTLB-specific implementation and improves initialization
> performance.
> 
> ZONE_DEVICE initializes struct pages by walking one contiguous memory
> range. Boot-time HugeTLB instead initializes multiple disjoint ranges,
> one for each contiguous hugepage. Measurements showed that memcpy()
> performed better than memcpy_nontemporal() for the latter access pattern.
> Therefore, use memcpy() for normal memory while retaining
> memcpy_nontemporal() for ZONE_DEVICE.
> 
> The initialization time for 64 boot-time 1G hugepages with 4K base
> pages was measured as follows:
> 
>   arch    without this patch  with this patch  reduction
>   x86-64          195.60 ms          170.40 ms      12.88%
>   arm64           374.40 ms          237.60 ms      36.54%
> 
> Co-developed-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

