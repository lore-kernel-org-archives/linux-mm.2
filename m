Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA66606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBWpMU/K
Received: by kanga.kvack.org (Postfix)
	id AAD4D6B05CB; Thu, 29 Oct 2026 11:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84B46B05CD; Thu, 29 Oct 2026 11:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B4B6B05CE; Thu, 29 Oct 2026 11:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70F756B05CB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:43:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0442380441
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:42:59 +0000 (UTC)
X-FDA: 85376082120.13.87C6848
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E028540004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:42:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VBWpMU/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x05fCxndf1hYykwEJ06qD0sbC4EVKTE/sZRMpUPdEQc=;
	b=7zv3pRXj4NMw/pKTf5WAQR8J7iCKOTFZH3h98dnBdbSMumTp0SAJfvAXTXyAKpk+30M4U1
	JNP4qTyyJUUlsU8nq2uNortlJOIRN6cVs8NZFoISxJHx+OjL3aEZVxRwmYKmqkXRy5H8JQ
	1SfBD8oWXiMLbdyvFjFjS3oP+vFRuVk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VBWpMU/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288578;
	b=bKA7LuqJYAWXDHKXR5DwtqXwBKGfV9kGZnL/S0x31QkXSKtfgQexSsAzjck2y/lUNFguOr
	O5Oph236lP2Kb1V619c7XyguS/NGYEIH8dN0BJgtJTprxx290VeMXWfP3yhJzAq1GISHvS
	6XyL5dtv4i3AGPFwcVinC8wMIczrRTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F4E043F25;
	Thu, 29 Oct 2026 15:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F621F01825;
	Thu, 29 Oct 2026 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288576;
	bh=x05fCxndf1hYykwEJ06qD0sbC4EVKTE/sZRMpUPdEQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VBWpMU/KLAu7f/e/8Noc5/ky4m6uYCqrAnbDe7B1Eiyf3YKYYuSJu9S6rMUBwAHRq
	 rxdNuSkxQyc4TOUMzaXdWdtkkmG4SSedqSFbH+UiVGUvDBhSbF5ps5Rj1N4WC5Z+1M
	 nVg6ipTCrheIKd6OSnlqmCHY40aY5JuHQMktjBDTz0bNGDllpKtBpr67h+uTjX/02/
	 BPVwPJ/jrEhMjy1lbZssZEiGQ47CW+eoOvd7LM9X+gXcm1M/wx1zx2VQ/uyO8q67C5
	 n6t0zAffCO2JyYnGumXddDp++ELqcS68IiiH0skAk3Y++ZmqpXAGKI8OP//9xNZw14
	 KXjSab75N39jg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 55D60198003A;
	Thu, 29 Oct 2026 11:42:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 29 Oct 2026 11:42:51 -0400
X-ME-Sender: <xms:cGnjatNYCDeDF49taWGwFnFA6DTBtqFjLkJEWyZ2h7-8tO1hYgeSTw>
    <xme:cGnjalcGilwgpzywEq5-9_Uax-LoiciY26Hr9Dx2NdLZKDVOeYHxJNoKbsqoyc0HV
    fMpRhpRtFCi6EkHPOqVKO7Qgcsf8k8JabM2EeZbLZYt0LPRJSrAX1Uy>
X-ME-Received: <xmr:cGnjam3XDA41P6ZfG4_oZPjd4RhksmXGacPPo4PHNrL9WQIkvxQOdIUOlic>
X-ME-Proxy-Cause: dmFkZTGrojcwHOYNV1R27yGMmE+sn2SpgiwFqzTWix470caHvIOH90SafujrsKt+HTJD90
    SN5SPP69uNBPn1MxWH6/eaMHHTJo/SvRT/z0Ju39Z9YfjzvKYsDYrFhgheSCBdJ9b5YIFp
    cIdIwys365LDAngvB6UcUIm3AGzNccSf4yN/FZLQr8sexIPFzUStpfInmWS9yXmQgvCx5c
    fmpZ7EbFXEWylssnvmmDQCnrMMUW1jHsUhf/jrVErtMG2Lbffr1bqxM2P6gj7ypN5ZdyZj
    TgAYvrVjfWikwB2MTrnw3YjFYjeMV0UDDQUTP/dXoAy/YlzoJiJh64//IR8g0ZuUVQCpel
    PcjjoB9Q6Jx3knI5olrCUi4hirBEGQQT+oSeGTeh25/h09KblyE6Vl7jNLQSnQit4V+35z
    J17GU/oPzC0n+oCMVsG/dfInPKVCtLZBd5z2d7pFm7kIyajC91WW0fXwTIMOKy3y+R1okp
    ekcKGTudIOrHnEZRx1GDJKalnfGvVV/PnxC4Qbu/41RL8DRLjWQuiSHsfiURJwHwuxhasY
    GYMOJsxXNzU8cnNcXtdtzJIfeYba/tJgBPi2qhRcbC1kxMhMglGWVDH8uH+rSsnay/vQnw
    D3Mh5eiVtNV6r+viH4MNCT1TzsAFldnQpQurl7rb5p9gSfzssla1/AAmhpLw
X-ME-Proxy: <xmx:cGnjalwWU8W_LTwkSDS4FwlbRvlMAxVh616uhleGcP8DWlPfaYmGzw>
    <xmx:cGnjaj53Pt7V4Vu7bIXzZKdpvSrEym3BIg-jYhLqD8PxloGEbD1BjA>
    <xmx:cGnjampN953BOAPY-iT_PyL1bwsUDnSFFEZwFhBzoi8zawrViQ6drg>
    <xmx:cGnjaqnZb_SLLcbp0PPUsQOS2wLwEGRm-QsuvZlsn1hfIsEUvsIcMQ>
    <xmx:cGnjaqQ6rvy28ek_52FnLx0f5zjRtsChWHkRCTWZP2DTXANVWLWIhapi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 11:42:39 -0400 (EDT)
Date: Thu, 29 Oct 2026 15:42:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 42/46] mm/huge_memory: split huge PUDs when adjusting VMA
 boundaries
Message-ID: <auNpU-7hPtUZeTGs@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
 <auMxQPze5cOvGbCe@thinkstation>
 <9f4128a4-85fc-4f4b-ac41-b9d348f56e37@kernel.org>
 <auNYPPlCnLdN88t_@thinkstation>
 <d5d077fe-4695-453a-a2cd-40ef30abd61d@kernel.org>
 <e796dace-06c6-43b8-83f0-594e7f1e7380@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e796dace-06c6-43b8-83f0-594e7f1e7380@kernel.org>
X-Rspamd-Queue-Id: E028540004
X-Stat-Signature: o56a99z31yigu9yw394apq1c463oxnsw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793288577-30111
X-HE-Meta: U2FsdGVkX186lTDTkQmyKEtxHikwjscOJmrmWYqncYhESGLetcKrCU+vbklRq5qnoERpaBFOnAByFwIFntxWnjKALfQxs7z9jUA5YDILYUCe5XuCUaUI3a9PpjjervGdUdpucf5wKPG4SyhrUSNJKBbZg2JU6zkuIJxz5Ehq55blPVuhIEvfk6LOkBcxIAUkW0RzyopoUeUvrekqGfYvlTcDtOM5rWQ2S+kaN6eTeP1qtQkdwSQ4WPMYLTi1mVH3aiBqVTYoU4xbR9B7Fe/pMOF8i+GuW3gseLBpZrVfVNihKjTwhQViMUxd/BZnMs50BFkHfQiz3sT+LxzW0KPnl23MgA/TpHr4EzQ3nRqNrEwjQ+evuSOphLPiO7pPs+3InwDf+xJYjqDGQUgbec53SYBMn49UX9l88Yc+SWte8lqi3ijDaMArrsIZzIRnbtzK0GUv7XudvRmQxRJCuZOnRnTFvAYqKYLcyNMb7SSWjsASp7z9pO5ySqmGncVbJe/4IiYdihzkskOyGd/K9niR0tsPZSQJdY//E9Y3+jvOWCFE2qbmp9hNBOATqH1kqrBTUi7w7Y9W49vHzwKTCPeADzZOTC7ewn69ZIFmtznq9fK4KrG46Qr2cy6u8AR51cBbQ2EDCbd4nvEmtMudCA1CBLMHwValbgaS0P1lBRWDaTx7xqY14MhWynxuXynYY6z41xkldZoJyimCGCEMM+bs5oObzf2QHsuQ6vj0u4q8WWdTGPyABaDYJ0dgdCv7///EirDmiKzB6e0kcgfRaGX9yzAmTnBAdBdi8szMJhlU7ap5jE/lthlh7ckYUx2muhTXoE2Y7BFikgC1anPho23L6Hq/7GdWm2gPe6pmICqxWJFIGjh6wmUTF/54sn13iIxyr66x7fkdSch9m4iFGpa9PDwHRRJEuxHPn/PL9AHm/WYGCQRZI3aHwXWT1FHbZP3AB+f93RUTgcp6Ikj7DPY
 ZyjinRdW
 JM2K22A5Voj0ZJ0u7p2bbA5ATE7ZlZ9VLi2bzpIoCpZCkM6Oaup15V4qYnaR5ALMYA5YRqjjAibpPOuB0lFhtjZI87R1GG4uZWyuU0kOyvh4CtBkdPf30sc/nIhDetc60WtoDjWYxBC4+BP4hJ3r2WNMwG9Wd5GwX+lBEEC95AcF5e+3YJ8ic4v3fTRQKanUHhya7IareAvMuEC/mxTZpSKJ8Lw3yewvG1yJCZqCWW3sJhdiFxcwdXJxVTDRFriGpUrKjr9/pLqXvaBB18uF7tLZyIRH57gMEs4z/dq/EkGEAsNzHi+IzXPg0JlM/W4FWAUDgDdeQoVG8Oe+FkA9t+xGCqLrLYCMdG15eGiDpCyUb/evnfaH5VwTMMPhQaSth8SGJZkD+GI1qN+v56w2gsa0ntQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 04:35:46PM +0100, David Hildenbrand (Arm) wrote:
> On 10/29/26 15:40, David Hildenbrand (Arm) wrote:
> > On 10/29/26 15:31, Kiryl Shutsemau wrote:
> >> On Thu, Oct 29, 2026 at 03:24:29PM +0100, David Hildenbrand (Arm) wrote:
> >>>
> >>> __split_huge_pud() must split a leave. Either by zapping it (what we do right
> >>> now) or by populating page tables (as in Usama's PoC).
> >>
> >> No, meant the situation when pud_leaf() is true, but split_pud is false,
> >> so __split_huge_pud() is never hit. pud_present() is true so we proceed
> >> to pmd_offset()
> > 
> > Oh, yeah, I can add a WARN_ON_ONCE() for that, it would be a bug in the software.
> 
> Ah, or I can just drop the split_pud check. Let me do that.

Yeah, looks good.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

