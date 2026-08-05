Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01EBBC55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 04:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949356B007B; Wed,  5 Aug 2026 00:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA796B0088; Wed,  5 Aug 2026 00:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1296B008A; Wed,  5 Aug 2026 00:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEA2E6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:18:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74E3814038E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:18:11 +0000 (UTC)
X-FDA: 85065908382.26.468B92A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF0A5180009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:18:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K2is/aMg";
	spf=pass (imf16.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785903489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hadm6xP+PswyD3AihAYzJPsQQhoLmdR6g4whbLAjP20=;
	b=PuiH7eItydLy5gg/98mD3tVB1aWes1TKuCDN3pk+8Tv0lrhlMWqmuxp/BPm/LO2uMjINXN
	HEPXeph7Q36zLH8pwBFRMmIOO7WIupQ2L4oVUo2PhAYmgc78rCvE4vfyuAnP8yM1YT7RS/
	lp0i7K+AY2dGYrO2vurtIdk8iOqVTJw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785903489;
	b=eXkfOZDioBnLEOukrlBzPRHUTW8rYezO8HE9hgAjhTqMctOiSSuhN59007j+puAgNNhWqz
	jHMOvHJdMVY/Dhdz2BqHr/zzn5dwy7698xf1LnGxVVYtP4Zyls9R3E/sXayQNagkbIZOfz
	HecIrqLbR48rVN/GgG5CDi2+Iyb1r0w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K2is/aMg";
	spf=pass (imf16.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0141600B1;
	Wed,  5 Aug 2026 04:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5721F000E9;
	Wed,  5 Aug 2026 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785903488;
	bh=Hadm6xP+PswyD3AihAYzJPsQQhoLmdR6g4whbLAjP20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K2is/aMgoIL59CuN3DzHfIlouW8vHEhx5Fs5A+bV+Hqf222GpKlsjBkviC4n4XkcP
	 b71KdhcuPGtMqnGOl2K4xdf8uQq4vp06sDQeVs2+DLnHRcHhOGmDz2aPcWpmj7FopA
	 a0uufkAXnUyfjLV+buwHjQIyGKLW/QrY7pXFi1I5LDSMwXlyBflKB6S62j4pmGM+Cu
	 Pt1CRdcR2vzTcN9y8vczBcB1zBDei2wYoj08MQWVuyxhG+IuImioTovnVRymkhcnrg
	 OmAJwtL67EcOJJ7vtFasWWRkNsSJIiuQl264jCIPP+FBEgmwQpuQ3PdPokROuViOWt
	 4x/Z7RI4bJbAA==
Date: Wed, 5 Aug 2026 12:17:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Gao Xiang <xiang@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
Message-ID: <anK5dIF25xWmaHzW@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
 <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
 <DKGNW5NWY73G.2E0EH28C37POP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DKGNW5NWY73G.2E0EH28C37POP@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF0A5180009
X-Stat-Signature: tssua8qqk313gxpgrrsec4khmscizzhc
X-HE-Tag: 1785903489-305895
X-HE-Meta: U2FsdGVkX187SFbCK5y53Rg7veki4AT6tvdwC86TzIiuYGM2wACB2ZtB3uH5nXqSeiLCAiyvWgWss25n6pjwJaF3KMqUmMi7VhwcCaPTVvI0tG2jGXKyzyp4DOoMQLKQpslLonIVwqY5rhnsrH4wcddbliz1bNHGJgHMF0z0BSjzK3Et7oD/abm00QQCbc5LqjMeCBNcOzwjUQO8Tp7en6qLVlS0JNcfIR4+T3azemZi+2rjhiQufwlfDNRf3n10xFW7GH7GhPEFVPUvmMqeGgBYYva/z4R6FfwrLkgZm4Dl0e1tZfdgHOJnsoijLzKwQKL29xWTX4bFkk1i+0A+GGFmjuhLSL069PzgK2AlUDzR0rv+0jE9U+7oc5Wnkm7P/Bxpa0KxFnmSxbPVbzk+F3diGFFBgaKQFjrAwD9o8DYapeVV4DQWTsF230vXSnXE+5/IOc0nYq+cuF+Bxe95IhKLIgtOJe38imYwptIC+sF6T+bbluxXEWSz5u8abBEafmSIrN2eeKV4uYrw0HaXa89envEAfupWVuW3eRdgCJIS8xxdmOgeKTCxRxaQb/4+y2lYYzL2Uy8azztsyYinapZ4XF4qTmeHLVJRFH2w7mk8zeXRG1EzWuKo2M1PnxUll6kBXR7MfJhmNq813jKqKsW70mKUxxS9kfy+RZ2y964HrR+6BiNvJIcSO5/Ncgy+MhASzstrBsCcpOu+t5ExWHeays8fL5NUKHWIM3pGN5klukCTFBPYxzXZCRej2Tgj7YnoQuL1+L49sUSeSyCiKIghNGxbUQXP6RoJWdm89OuuGJYQpIOudp2fzMdj6h3l1qi1JFFyB6N5cM6BAVxhZZ/Vm0wkyLWoXx+KAX7d6b0b7Uen/PQGvtM48m3ZP3d8bgaa5C4gXN38mIDayIK+WCVjTHBFDmdmOm2PtG8vYUxNMO8cFHAiZn7rOUb6XRvsQIflJdagfCClS9KV70s
 xcZma0jO
 oe4AG70IT0G+Ivi5Y+a/zP2TdkDR4yZFK2qg4YEMZAyB6Uhr6IEXczpGO8JcLH15DmDSb2Bkl2gdYsBsnO5fdJ12aEGUb4gDvteMczclu8DVV5IKY3yWVR3lXBsbIBPKtkGeHQ/Er0U6vt40u7GqR4jDeRuK+H7YKddtXo27ENaLvhuXA5wk/DND3de7ysiiS/hMY4F0GivJ4lF6wjiOTL9U7Ob/HxOVTb7KQy6QgWCsXtu8eiDOHyi98hgJ7eH10ggeAbtHJBhhEbWZ1aMVJzVne9WjOmCN4M061XeriENAKr1Nz2iXar2fjXXmbwukbO/xWYEYWR74I0YA01vJ3aGzHxTvwmkr9CuxpiC2sf33dHMSsnOpiETcM8Vr50zAoLNZdnulUWUYaCkDt/qZul914jsaJdfuh/jlyYy2XuN6IORYUjpWRNPnouujc8bpmyKkZJVaXl9IaKGthyAQpC2SxiKh7rt+aI6E9vS44WtN+HeFVBk8lfzqBH3GQMmwCfe3FhO5zQVD6SQBAjIZraVrqk6VCd6Mu3mN02VLeruagDlQCyokpT3u7Psy3TYiubuAUYtycs37+vh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On Tue, Aug 04, 2026 at 10:41:23PM -0400, Zi Yan wrote:
> On Mon Aug 3, 2026 at 7:40 PM EDT, Gao Xiang wrote:
> > Hi Zi,
> >
> > On Fri, Jul 31, 2026 at 10:13:31PM -0400, Zi Yan wrote:
> >> erofs_onelinefolio_init/split/end() use folio->private without setting
> >> PG_private or increase folio refcount and it works. But after PG_private is
> >> replaced by checking folio->private in a future commit, it can break
> >> folio_expected_ref_count(), since the folio has private data without
> >> elevated refcount. Change it now.
> >> 
> >> It prepares for a future commit that removes PG_private.
> >> 
> >> No funtional change intended.
> >> 
> >> Assisted-by: Claude:claude-opus-4-8
> >> Assisted-by: Codex:gpt-5
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> To: Gao Xiang <xiang@kernel.org>
> >> To: Chao Yu <chao@kernel.org>
> >> Cc: Yue Hu <zbestahu@gmail.com>
> >> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> Cc: Sandeep Dhavale <dhavale@google.com>
> >> Cc: Hongbo Li <hongbohbli@tencent.com>
> >> Cc: Chunhai Guo <guochunhai@vivo.com>
> >> Cc: linux-erofs@lists.ozlabs.org
> >> Cc: linux-kernel@vger.kernel.org
> >
> > It looks fine as long as PG_private flag will be removed in the
> > follow-up patches:
> >
> 
> Hi Gao,
> 
> Sashiko spot an issue in this patch[1]. Basically, ->private can be 0 if
> I/O completes without any issue or being dirty and it causes
> folio_detach_private() not to folio_put(). My fix is to add a bias, 1,
> to the counter, so that ->private stays non NULL throughout online folio
> process. The revised patch is below. Let me know your thoughts. Thanks.
> 

Yes, that is a valid issue: ->private can be decreased to 0 without
folio_detach_private() for a short period so a +1 bias is indeed
a solution.

The following diff looks good to me, you could use it in your next
version.

Thanks,
Gao Xiang

> [1] https://sashiko.dev/#/patchset/20260731-remove-pg_private-v1-0-142c97ba3562%40nvidia.com?part=8
> 
> >From d8fadd13fee03e72c03a718af65ed41927ccbcca Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Thu, 30 Jul 2026 11:04:00 -0400
> Subject: [PATCH] erofs: use folio_attach/detach_private() instead of direct
>  assignment
> 
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().
> 
> Furthermore, because folio->private is used to store in-flight I/O counter
> and the counter reaches 0 when all I/O completes successfully without error
> or being dirty, ->private=0 causes folio_detach_private() to not drop the
> elevated folio refcount. Solve this issue by using bias=1 for the counter,
> so that ->private stays non NULL throughout every attach-to-detach process.
> Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
> ->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.
> 
> It prepares for a future commit that removes PG_private.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/erofs/data.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 9aa48c8d67d12..81e9dab247e0f 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -251,19 +251,23 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>  /*
>   * bit 30: I/O error occurred on this folio
>   * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
> - * bit 0 - 29: remaining parts to complete this folio
> + * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
> + *	       ->private stays non-NULL while the folio is attached
>   */
>  #define EROFS_ONLINEFOLIO_EIO		30
>  #define EROFS_ONLINEFOLIO_DIRTY		29
> +#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
> +#define EROFS_ONLINEFOLIO_BIAS		1
>  
>  void erofs_onlinefolio_init(struct folio *folio)
>  {
>  	union {
>  		atomic_t o;
>  		void *v;
> -	} u = { .o = ATOMIC_INIT(1) };
> +	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
>  
> -	folio->private = u.v;	/* valid only if file-backed folio is locked */
> +	/* valid only if file-backed folio is locked */
> +	folio_attach_private(folio, u.v);
>  }
>  
>  void erofs_onlinefolio_split(struct folio *folio)
> @@ -277,14 +281,14 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
>  
>  	do {
>  		orig = atomic_read((atomic_t *)&folio->private);
> -		DBG_BUGON(orig <= 0);
> +		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
>  		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
>  		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
>  	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
>  
> -	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
> +	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
>  		return;
> -	folio->private = 0;
> +	folio_detach_private(folio);
>  	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
>  		flush_dcache_folio(folio);
>  	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));
> -- 
> 2.53.0
> 
> 
> 
> 
> -- 
> Best Regards,
> Yan, Zi
> 

