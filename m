Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A95CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312A28E0130; Tue, 14 Oct 2025 10:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C3D8E010A; Tue, 14 Oct 2025 10:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B398E0130; Tue, 14 Oct 2025 10:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034538E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:32:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8620C0341
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:32:48 +0000 (UTC)
X-FDA: 83996961216.13.11E5083
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F1761C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:32:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gANwOdXe
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GqYhA2elC/r2rvCKhRwX+jvXdEIHrho/9mEfMhvs2g=;
	b=4MHL+Yyw3faNrDbeF1azUCaFc2EiUuhBGy8/epTOC4gLgEHoWkkWlJjH53ocBoNRF25JJa
	2KaOn7ILiCjI4FjbqRQoPpMkTDnvNyZvsKWISC8K3raIfSLhtRYiWp69wz0edPIzM/Cyzf
	fglxRRW7iY+CjGmQaH9z0vbLWjTEL6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452367; a=rsa-sha256;
	cv=none;
	b=aT3UJqZ/1XJmAfGUpbJGaG4mJbtKSgTJinMMJGyOFnL0MXTyeqqEyHlykrz4NQFUF8O0Qy
	/LRpULkaCcykcHhXP/JbPKst0rWYkQ9K9ffp9tWegAcry0NHI+kMV7A90N6qRhWQ2VVUfT
	Fz6Tl8cYHyn29T2Ik3tkT3/6bru/VdE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gANwOdXe;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0GqYhA2elC/r2rvCKhRwX+jvXdEIHrho/9mEfMhvs2g=; b=gANwOdXeFS4A8Uk10aaWilWR7d
	ySohtwrkya4BSFA9MNyJwI2SZVkT1JJHEAJ1YXe7UWprbY1XwtET/2V4R4oRn4GF67uKnvqNrQQpm
	yhej7D3Ampn9gV2sdpBOC//k6+7VCRkiUzXc9CAocGziSDmflGDKxlzctCPJMtuj1ame1R/WX62J3
	/q00WWJeO563d2TrDkgqDV3wLGgpDguZTVQJuU95qNOMg6pvwsczOA0E/TTHHdN4VGFQz3RMBH5p7
	s4BBoP6jBFf72/l5Iy/B7dE73hYHCsC/5tBuD4pR9oLkR5r5JzFIJiPt40JHliYisLm0SxqKtLxy/
	LUkZzWEA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8g4v-0000000CSAd-1Vaf;
	Tue, 14 Oct 2025 14:32:41 +0000
Date: Tue, 14 Oct 2025 15:32:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
Message-ID: <aO5fCT62gZZw9-wQ@casper.infradead.org>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
 <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: ghbiu1x41cnuxgex4m8kn3pcdiuh7ur9
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F1761C0006
X-HE-Tag: 1760452366-826863
X-HE-Meta: U2FsdGVkX19ZtIp51JoQicuh1TXpaipTeDBdOHMRiNycAswSp+KjRWOjDqp2JuWP5kYLg42Idm+hlGbl9PZ698v1oo+cF1ATIjQ4YGmfXuhGujWacRQbDFESlHPDMbxrc668JFcUf/Dg8jNuesPTeT8YWQ52FVagsYG78uYtG2pJHtmStjB1y5ICTUcZrzPk1KLU4gLVbEIZlFy3eOuKJNYn9rVGruOZ/ZQ5migoLJmddBrrHFh3vFf29IZEA8UQ7+ML6VZkU+B8wXwbPwx0kZSCCzQw+imxZRQqnhUubCVsondRL1B6oY0BqOh/jaXmJYzWVfIds6ASg0/eg0uMmzpM/oeTAau6cEzAdsoPOYdQlGviM3T/3MqfDuSq3Utizmph+l7nMREVuZFjOOjQoijnUpuAUDAEyTnnYUhtI1Nuf2Da8firnyRO3DigIK177vjEdazaaabjlaURz1J+ICUwmOYq4WPjlSZvqScMleN+a/hjKPfhYfzQvJhPX8pcr5GEdtdGGtkKjmWZN7ZzqbER9AQAiCu35+N7c9Ei8yDwdRCbEzvxtVtUUZq0eroTXMJQM3wILT2Ns/dabei5Zdgl+PqwHier4ggyvLfqhHEPrTInOkFKewZKVIH4W4Ek8t4ez0Cnm+yodbcv0p7gYYby/pTpMql4WRO590e1IplS8BgmtqZcgMEeS+2XkN8xLBrAF+3TayvX1TOx3HYoxzMy/OQ8EnjQ6T+H/LNw20utu8rrL7x2H4+67fjS9nZlZ6srXr6T4h08QzM3TJjVoVWFmMXDnt8yxusJJg84hm4HtLngBfsjhvcltnMFoEoZ58HpToinKUEG4sfxh9GOK2rxSWo5G0n+eYe/k5g/bjZDyeGlqnKTbkI+k0771+0kvk8XAj6hqxDNHRY7Fxiy3gFZRfQTnf/OFDbDsGMLq9cv+7caa2oRa7IZW6FP55S0lmc3wZ2y1n7Sav8xQhG
 jwdXd5JO
 qQ7hk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 02:59:30PM +0200, David Hildenbrand wrote:
> > As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
> > folio yet.
> 
> We do support partially mapped PUD-sized folios I think, but not anonymous
> PUD-sized folios.

I don't think so?  The only mechanism I know of to allocate PUD-sized
chunks of memory is hugetlb, and that doesn't permit partial mappings.

