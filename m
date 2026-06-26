Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D210CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CEE6B00C7; Thu, 25 Jun 2026 23:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C056D6B00C8; Thu, 25 Jun 2026 23:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BA96B00C9; Thu, 25 Jun 2026 23:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C71C6B00C7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:25:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DAF2A025B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:25:18 +0000 (UTC)
X-FDA: 84920623116.21.2DE987C
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCE1EC0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:25:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WLMnuF//";
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782444316;
	b=oPgpLmq4y68LgNSUmUb1qM3nitBXGwVGPxicGeiqOYgP9NTdmM09p1U/Z3I05moYs9w1h9
	5KeOC4hc/3un10uYAVGJDfGvmIWYj07DTjxgEY5tvYtuXeukUgFmUoWUOf3bpzZa5Oua84
	hEn4Vrm6zg2WhR4zLm6BaU2oIw74BCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782444316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAXxVgUjspFRwFL/RkyK5xtXWU1EaEUoL3fXnAC+ilY=;
	b=V4QkUDDELxzjD9t2qlKetyk5rS1DI0Wp7F1m4VfWpZwFiaEqXpyISIy9+7DMUQiUC3jqxu
	wnWAqWW/71rvNpQ02WB4Gb5+2zdsnAUiyn+WzVF/FWq0E/xlp3DyUY4tXH5ms8xDlmz5iC
	Yj2Kyxop8muur+o4019aZO3XER4QraU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WLMnuF//";
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782444309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAXxVgUjspFRwFL/RkyK5xtXWU1EaEUoL3fXnAC+ilY=;
	b=WLMnuF//u9tPPAqJrZxZn4i0N40nEjPTUdUTFBNYBZ7b+NqKnvWWIXEkhC2M94T7rwC5nt
	slSAhdl1ejlz0D1vl4f8SzrXb1zgQXA9z6YzMaCN5NYNf/Q2xuiUPczuiuecOgCXc09z/z
	7EQW8Ec7zgRmcMiA6NYQYQjWZW0fcio=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 2/5] mm/rmap: use huge_ptep_get() in try_to_migrate_one()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260625112955.3254283-3-dev.jain@arm.com>
Date: Fri, 26 Jun 2026 11:24:28 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org,
 riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com,
 apopple@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 mel@csn.ul.ie,
 nao.horiguchi@gmail.com,
 ak@linux.intel.com,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 dave.hansen@intel.com,
 tglx@kernel.org,
 jpoimboe@kernel.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <35399716-4B47-4492-8168-B1F0AEFF6672@linux.dev>
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-3-dev.jain@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5buag7ocdotiuqusqz1zk6hnjrux9syf
X-Rspamd-Queue-Id: BCE1EC0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782444314-307174
X-HE-Meta: U2FsdGVkX1/svgNVbU794ZoJgU8MxDZLqaYn7LDwrpcx5Hu7VZte+ly+WCQ4C2Cdl96FI4gYmL+qHhugqHRYB8vhxtop5o145A9qOMvmwltEjWSvraNPDcBQak9hjDznHRQZqT4uRBehjvdmFe4SAbafnmZ9uD0129meBSGiL8TdRhjh5oczSKJ/PObs0Xx7k1eYYtseNgK8LdbIXYEx+UbaeAN+6z7CWJmYRcY1+rm+oovgLPtkVD06hstraU4wV6zEAhGkRielaxqvfaRwmv2dcXMWcgwo4oyUdJARaKfYCfbpRUhc8JnQNwdXxXsDFiUM0Apl2AEITBOYE2l3lsRXgcwT+yt9f0M1oDvRoBQsraXx3tDo+DFqgs1l7uY8x/YzGJnCfzky9hhcpceKPRB0Lh157C6gg9H8VX/azM5yKVs1s13EbfxaD6krgt9k2JCS1PCvy62IZFLA2dR/RyhHZHixmZjS0hf03eYaZo/I4DtMOurIdiiv8tYUW6+ZcwcY+8i2ONF2hC0+lJ0ZvgWqHoK4EoBc6wGBDqc1MKiQ7xrMx9ieDwtLH01pF3ShiaRlXADFrWF1QmWhTfL7torN76L91S2zpqOedb/bbzc9xNhaN6nTWBSkOvMS9QR9upLjQSkPhn6Y9VsWWm1jutW13cAzejMyC2rB0T653EtcL26Sixj42l2bmOZV6hN6zC2T/iWBAnzKR3ilF8RHkgbIiAoIaDTQ34EOz+ZDwDsIBndbtP7eOnhKQu+kOh+gLhXw8hSuMbuaQSulI1bJ0p/HwEuht0KTv8ppkEQG6r3yHHLA79d3g2zBr9iUYumpbJXrEkQb+DJoNW7IN4QeeaUCcz7yTWSTKBvQDLRN4bw9W3KWNWqsuZak2jIQMiP352QhFiDs1DfdhrjgFZU7RflK8ajSEA+8wHX75wTLpmkkEkyNRU/mAOSo6Ntc2JEFZFufGEmUxcp1eLgBAln
 N9t2jNl4
 e1/i716X3iG9kyHb4v9OkWCGbs1biVkPVG/0L6T+RCbsBSgQjf2Z+OlTvHvPuCAhldw7G1JDbJHWQzurY0pcdetqDpwntr7DaqMF1OaQxg4sfgIBOF9MC3nxve+8s2FBH1XUQ+RNfV4Mid2MZJFTUjf5GPegikfHa0J0xMR4D+9dUMAb547lGGMxc0wMAu6tMy3r2CSyVaRCBdO17Ucf6jFRJZD4lFQvc1ECjEbNW+ol9QgLz/0LOtdm+Lo56NLOszaqgJK4ui1a5bekjlJxYHostFuJ72vfSDwvP57hpGcgtAzYSIU8QNu25SMBhhIUFZ3YKq9/yUz/YRtWx8iUlnw5NiOdYWGYLgftYr7uRNFOC+5Dj8Wp19V2qjjEhxpbG02OGjtyt+vofk9wkLbnopTQ63TqaldqYbqX74RPQppfs6XmZpniFtncHBq+xr7kLRUhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 25, 2026, at 19:29, Dev Jain <dev.jain@arm.com> wrote:
> 
> try_to_migrate_one() is used by folio migration to replace a present
> mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
> returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
> reads the huge pte entry with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Use huge_ptep_get() to dereference a huge pte pointer.
> 
> Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
> try_to_migrate_one.
> 
> Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.	


