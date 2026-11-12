Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630BF606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CYRNQDKY
Received: by kanga.kvack.org (Postfix)
	id 8D4036B05C2; Thu, 12 Nov 2026 07:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB576B05C3; Thu, 12 Nov 2026 07:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2016B05C4; Thu, 12 Nov 2026 07:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA366B05C2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:17:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 046D51C3DA8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:17:35 +0000 (UTC)
X-FDA: 85426367712.09.D344494
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58C08A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:17:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYRNQDKY;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485854;
	b=taBhty0un9PY+d0RLQR7Cc1/SNOtEdRvKM7UfNY7giWz1+K6av62SDPRQ5wwKmfC9QaIfB
	9PxyVPTsYJ6P/gVWw5ghkSe+FXRvalYDxsTA0pJqyeeWeehLaQjA7wF9q6p+4o9SvM2qG7
	G9w2XLzGE6wdKMW8lwfqirfNyCHSE4M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYRNQDKY;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egNOu/7Vf2X7W7uluAYTFo+WYTwOy0dGXa9yzgt6ZV4=;
	b=ULMT5b43FCzk3Mg3PB/ztV4E72ded5RKsK6w9Te+S37ynGZFQRFyyomfk65lJx4iiVGp5n
	7lFGGAuANhsE4u4gKUYxH/+DoZZvr4e0KZZRc3vIurhUxMyY/EaJikCXkPg/R+6IuYr264
	ndv+ZoMhEUJeJ75Qp6si7bKH0edafSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6377543D23;
	Thu, 12 Nov 2026 12:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715601F00A05;
	Thu, 12 Nov 2026 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485853;
	bh=egNOu/7Vf2X7W7uluAYTFo+WYTwOy0dGXa9yzgt6ZV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CYRNQDKYwSNE75OEpsjDv9dNjJDH/9wXWcwkCgRl1QqXE62f4uONxtXX5dc0wsQs0
	 WbCx16kboXxBlB/B0vsnb5k03ky8z3i9dC9u0iLcFuSE+DKSeVNQJbZ6jceq38gQM+
	 qClCIRgvLECQGDxobOp51GqtjVLU4bNoIhY+asA/hxdLcGHuJqvg4TnLEhAFmGvmTZ
	 wEtb2rgiHZDLfVRt2osxfliQTOGWmbK41tGCAp+eIHjHnaVIZiFkTdH6xWp5LQtArj
	 FZvbiFaDY52nL/ZO4W05TXfdFxXIfIlMagq48ev+KEKfMAxYYWNy2VJEFaZHE/O2Ki
	 zNMvaBxoDQWaw==
Date: Thu, 12 Nov 2026 12:17:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWtxdIHSJJ_uNwG@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58C08A0005
X-Stat-Signature: h9734a4irrnpswqyya7pqzze5uw6kzmt
X-Rspam-User: 
X-HE-Tag: 1794485854-194184
X-HE-Meta: U2FsdGVkX1/zZr+594QTqV2ZDwrRa7Naujm0lgFOnoCZPM0TTjemvIllfeJOkl0dg7T1YY3ovdOt2t8wOsZQFPZObIARUtEnWeBXrf11mZUgSfMfxniSZJ4ZeGnSBc9Mump12sUW2SZHze1t1/zcFtzAZdOzfJQkJhtw5qWjnxWzQjOUAU9aZXvncoKBs6RGCzHQNipI3LLVvEE4d52XNWW2Kl2s4Sfom2XYU3odblub99PcM35PrX7Eo1eWnsHrlCFDHEbcYAsFanLEFPVCwn59mqEh5rE4+8CXTl6dWZyZ8oqajpcGlcGZKtyDAcZv78nXmGUkRrU8iSu3ltk+iHf2xJBjoyiGYJxcEleSRJkCt+X+bbqLinMvIH28JEbkjgFC61SAvZfb/G6PnHYaW26VibS3BQq92kQP/huz5Fwgio8cQLCV0twos5qQ8PhKq6jGG3M/d7gerxi1F5ei/Zi+Puu/5jz+40OiM/eWOIq35kkgDAVLRx1OFdDbNQSJ1KOe0HX/AnHuJXOoQEdFMcnqey717xATEFNic279GQyoIVSX/F5g4BDyGJovWle91Pzi5gqCqT6p2I4z9Fm4zrLeZBMMDKMxXYcg50w6JxBnZWlzT7UB/Ocb8WaXK+kwAa/WtPxfbF93TjWoBgTpL6GUHRTloxZhTeN4mr4Iu3j8qbgprl/2t6upNXZVenkOfQzpmblUIAZUCgaAhnU3R1zwewcPCi8zyfHXp6Bd9FJopfW8Gfbcg2uaOVLkKaT+Ark1Pl6qdTYf1ILeZxEuOVUWjbkX4xC8VNDyDzST1T5BU/+A+7Flj8WlD0k+xhFr9itq+/HW1a9QvRGYkUU/fnc+5VwcTCWNuZHYeDzckRFNkOlzYLx+K11ekg+909y/NeajlX0fDrER1IhMIUg8NfW1RSQrXJLkcja5HQE/xRBScIxJLwjQUvViXCziW0u6bJJ+OJM9ezldxDMSXu1
 EitL/YR+
 tCALA5vafGa2kLbyaTirfSdrooN7QEXSnvvXpffwsdA6+mRhBwidUuVicXbftsj7rNkoV/NM1OOPHKvGqOaDNThOqiOzKZpWx0A6eFm8MqC7pCtIgmXva6CwgcHBmdNMK86zPFd3kwU7k89LqT7APqzi3iVfxjswqAo75riWy4fV+dLCoQk5KJbESodQjog+wgHe2cyG6x/P0YGc6MdZJ4KnvSrAjDh74Q9jFe+ARkcfQdCAf1dnWmoB6BLt1JsBMDESYa7LBzshuRE6/ekeGpjPejPfHGjLzEQy1+y3OPfhIhofz0Nu2weYxCxpqYFhfM3ZLLRkCguSjlVaeT8IP5Cw1H85G1vtp/xBCMxn3VbHgZyYco3k2K3AvNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:21:38AM +0000, Pedro Falcato wrote:
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7618e72766a5..4cb18b217048 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
[ ... ]
> > +	if (mm_is_oom_victim(mm))
> > +		tlb_flush_mmu(&tlb);
>
> I see there's a different tlb_flush_mmu() call below (in the actual function).
> Is tlb_flush_mmu() idempotent?

No, tlb_flush_mmu() is cromulent.

--
Cheers, Lorenzo

