Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4468E606A897
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/IA795s
Received: by kanga.kvack.org (Postfix)
	id 41E5F6B05C8; Thu, 12 Nov 2026 09:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CECF6B05C9; Thu, 12 Nov 2026 09:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BC36B05CA; Thu, 12 Nov 2026 09:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D27B6B05C8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:28:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 890571205EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:28:06 +0000 (UTC)
X-FDA: 85426696572.06.D26E97B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5874180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:28:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/IA795s";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRCFxxK72YnuYLXCePfEDWC2leUkT+Fr7VmdbYfYzpw=;
	b=gBSPj5OdQSCQiUEzdlGjWGZGo5KQYpPasG6O6aHBvhbt7kCciUJaAwiiMEDSlCqmoKgstR
	sYUlJe6jaD/mR7rAMahhsvRqmueK4UUyZ3PBhTnh9Z6AuZ6Lk/HTZo1NJjvScndySse3cf
	sq1dsomefBNLkGM+Y+10DZafnomMdwo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493685;
	b=wj9U+EWH99HZQkpZ09rlaHANcXoGwiHc/y66ynws4hb6twJCG5BlESZee3dsYumgJ0MeNz
	VEGFRruSJ4FYvImjV3T1F0EMjNMpAjeJK7MaSax5D/dnjPz5uJyT5ZlhHN/Bwrzmt4R9W/
	ZrUog9i9bz8ledCaZWt7wrmb0qbjzsg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/IA795s";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C30C5402E5;
	Thu, 12 Nov 2026 14:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8571F00A05;
	Thu, 12 Nov 2026 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493683;
	bh=LRCFxxK72YnuYLXCePfEDWC2leUkT+Fr7VmdbYfYzpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E/IA795sioaIfUe5qJXcEcdduAIziyMy8hiAZpvRh6fKvAW+9knanXwBHPspQALOg
	 ZeVR6HwnIRrEusAhXaXTCxdYNLE4T3lsb1TvklUJekS+PtEiiJmvFPsNrplx4tzuPZ
	 Y5px27vNcmX5N7MFzZYoae5VbJ/IDYwisbMam9uf1aZ6pV0yBCKk2zEtfNLUV/yaRf
	 /Mefjj9cFsRf9nbJy6sX2ZSD6slH3p49/kYAEQjmTvrF60oAbkHMKmOozpcNjE4Zdt
	 UXFnscDz/wzrVzSOk/WB1oALyaIdIynYt2+A8zHlxvKEq4YIRPE0Tw/retoTNVlnbq
	 YFpOlDq9yndkA==
Date: Thu, 12 Nov 2026 14:27:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
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
Message-ID: <avXMvdu-R_Fjrt7U@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWmfXu39vtp0DM9@tiehlicka>
 <avWsG-zmuniUFio7@gremlin>
 <avW1s2wvz1PB0-Ln@tiehlicka>
 <avXJPw17fWvLtCO8@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avXJPw17fWvLtCO8@tiehlicka>
X-Stat-Signature: nx3injteninzkufmz8aof6uer4xspoy3
X-Rspamd-Queue-Id: D5874180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794493684-66665
X-HE-Meta: U2FsdGVkX1+r3oQtQcG2zsuTlvhOzR4Rqy+LpdHLRRRcEnzwpziB9n564ogVqYV2b6ch8U1MwZXwTyFp7Ik0PmxHsEjnCf1fh0Pr60XX6yAOGUWXjoFKT08RMVBa3BOI4Hik0RqjwrU/Lgk5ohHL95L+66u8yoIqq4nsjQfuyxzLxi3Pm9ZTxaLhlDx/MTbXrEWgccJwIHNmu3tIkIsQ4skAbNEDgCAQY8G0EH4WLnIA7I1mtAKv3TyLjQPX9qYTYso27Qc1kOw9izQJOnpnQLkMUjxeNT8ShcoAVD1ZCQiIPJC/mjlO7qYUWevG824xX4X1ypsNw7WGiSS52fUAvw97ljUJYN8NrCnqSxZHF22Gp/pBz+wvEgAMzkf7zOWI+91HgKGUkkfYjvPe9eacbuQigZAQlBEBbADTuTsCsVbxymeeOLFj2EbmcXyguL6p6U4Yoj/OOnndwMHntGu7DOc2Tt2u0/evCHW8g4dSv/1uvr8eZNyXY4E20ZJ+L4bMXZ+nmdEtAjD2TCZBnQm7ne5s7aJVKhA5v4E7pbPLS4nNJh3lwpeW98OHxD+QzF1JEYw38ksTfrKBkEWSBSdr9AU5tvvTQr3IO3Md4S4xJYuVrEcEbzeqWT3+ORR2CpgvTA8hVn/st9l7f5wu/6rEhZ92uQPAG8VuiFu2FgVgV6buMgIwqmoYmMGPC8FnTpp9x9gk81vsm8Rk16fxZbS/EUy8/bfTgvvmOH0i7qE+OEefiO2hFFYykjAC39Uk7R8D54MWU4ncyXX9zVYOX0qwF3EQIsFJXwsZ7pW6A2FQoTtgN8ouyeCY2wVsIReACedOD8j590Qr/pimotjHU3wAmnn1T14ipqPE5Cj+VP2zZzd/IFX2Bt8Hupn0/3+hVryM4KxaLHIqzLORiQ/HFNDuCnRNY0sW0YfPZfQg8Un4HAPvAHv3TNex/Dqs9Wog9MziSqf2rNMxC1vz6VafKNV
 Cn/M6Rt7
 DvTeceKQkYuQXqdSvmA6qqnM42py5XrvbJiJXBhsxOBdG6toIfpBKNahDwAmW5zBu16zYeSyZ+S3pv4srZpnbmKxGJGpoDYZ5850rPCjJf23ZWVW6xskt7YdqnM+d6pfzB26AxJG6/gLw+pXf1DmyeqGss9nGydE/NHYB2Q/Slfpjm3smCdDfunr9hVgvoasCnEZbD1IceEbJ4iY6oJBH3RWKSQbJmm5Fd+xmnXKUI/7wmB9qB+b4zJv00g3pUP2fmZ8qVHMUNBnpePUfSB810u6RbEyzTPJLYmoFyxhP8zrsMmNuqlm3RZIqsw5uthVj91F2hDD9BJuqkL6WJYtgVEwSX+L6Vl7h7AuNcfplzLqkev9vjBcxuZ3nnzc+vLT8yfOL/0LaXEIDPtOgdQ9XmCp9hG3Zt2o8YjzXbBJgagOhjFVQ1CdrY6LXDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:12:15PM +0100, Michal Hocko wrote:
> On Thu 12-11-26 13:48:53, Michal Hocko wrote:
> > > This only matters for the OOM victim, hence reinstating MMF_OOM_VICTIM, which
> > > made the patch _way_ smaller than the one proposed :)
> >
> > Should we simply do that flushing unconditionally before setting MMF_OOM_VICTIM
> > then?
>
> Sorry, I was caught in calls and didn't get much time to think about
> this.  I have only now found some time to look into that and to do the
> above we would need to make tlb_batch_list_free visible and conditional.
> Which is a bit of undertaking, not anything major but still kind of
> ugly. So your solution seems better in the end.

No worries, and yeah, I went through this one a fair bit to try to find the best
way of doing it but I think this is the least invasive way. Tricky one!

>
> Please clarify the changelog wording to be really about this and with
> that

Will do!

> Acked-by: Michal Hocko <mnhocko@suse.com

Thanks :)

>
> Thanks!
> --
> Michal Hocko
> SUSE Labs

--
Cheers, Lorenzo

