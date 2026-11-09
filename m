Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3176606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkYzP4rt
Received: by kanga.kvack.org (Postfix)
	id 99A6E6B05C6; Mon,  9 Nov 2026 07:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A006B05C7; Mon,  9 Nov 2026 07:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE1C6B05C8; Mon,  9 Nov 2026 07:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 597126B05C6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:27:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01C721A0600
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:27:25 +0000 (UTC)
X-FDA: 85415506092.01.F008137
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54DFE100005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:27:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkYzP4rt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227244;
	b=WJFMAA0XbdBsbZ5agl9GBaTqU9hCaBi549nJeQ1rgfmwOK22br9DP30iVXS9xQldJo3k9g
	Zwj1mBN56vm4QexXPAS9beqo5LaJ9XpS95eLcUCjfTvzxjDq/aCTbs/BwKoUIAWyeK2GSL
	Ij8sF59WoUVuhVNhcbLeEAWPCfVQjiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYIcWcYzIUZ35LbYpg6XHYKMwvcMU7zN300uv/7AjsM=;
	b=Ue2cDaujrMig6sKXRzN2J70tHK9VLT2PxoR4h5/qoM/zB73xHeAJc/+YSDYWTfEHwNAP7A
	ZBNpdjmf9KoShz2a5RAaktjvFmuho4DPBXkoxyGTY8MH94PMYck0A0jJjqs7A2w6ImMnOQ
	3TqJI9AS5diTC3yl8FvkwHM6BZw3N6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkYzP4rt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD78F62CCE;
	Mon,  9 Nov 2026 12:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D91F0089F;
	Mon,  9 Nov 2026 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794227243;
	bh=RYIcWcYzIUZ35LbYpg6XHYKMwvcMU7zN300uv/7AjsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WkYzP4rt/AxJflSDY4QvHlo3QQtj+85opjVNNjFvMZqJZn+bBCQKsOR1Vc56wCsWw
	 FHwDkIcJj0dA8rBrIwiablgEvMq9q7ucu+JfX5ZN/0yOM8xaxvKN1o/8G1XCL0eIBJ
	 b0Cv7HUFzyyS7CUgxu7a5sjYbh8AKtzd//4hZ8f+wOi407hdVAolsL1UEeBF+yDk3z
	 Cz0noIGTuP+nGcjHMqce1MVu5INeoK3aRdrWAaXkeN9Rfm7WjlKS4/wg/Th3S/XzAR
	 k2GkQM8y0M0SzQ1l9cxFRP1xd1zIG5cLpSzvpH/O1BlNyrFDSrS7beg0mpHerpJWoL
	 FtSvpRHC0A2SA==
Date: Mon, 9 Nov 2026 12:27:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t
Message-ID: <avG7_rb_PtU1jsbH@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
 <631047fa-8a19-44b8-9fed-6607ec79a1c1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <631047fa-8a19-44b8-9fed-6607ec79a1c1@kernel.org>
X-Rspamd-Queue-Id: 54DFE100005
X-Rspamd-Server: rspam12
X-Stat-Signature: gzkygrartndaxfpwsgzmscxkbds36zfk
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794227244-910162
X-HE-Meta: U2FsdGVkX18kbhojAn0UUtaL2u+YrdImQWEgKhpFMQZdN/QP9y49SvQ2tIkBApH0hLkr8jhyR4Tkv879NFL/KSbrnv2PnvouYNXYLYL0i9B2NfDI7vJUL+V3oqw7C2LseRi3sTwYWS2scNKZQamprL8RADvb8asf8j6T+t1EJSgwVFzdk5FkYusCCZhrE+rdvJ5S08IVBuaZM5TPRCC3SGuHyvy5lm9DLhm3foAzbwNxO+2hJM7KuhZd99gaQsF1FyM3hsNhEmfSBlkwZZS9lHiuZHsYm+wUTaNxtEvJhKA5aO+wx15DjK+HSzQszbVra9CPeQ1YoYohXb+W8aDxgo4fXKgm6K0UYU5eAJjg+GIQTRFD4p0JzfsVJilnslRyVge3m6SyAQCGpAuRoNUiCw19wMCudr3/YC0Pf8xqGnB5XVWtq5vD2wmbHRc0dhHTuQx0mOwJX81mM08AWygzseKsT2jNri/Yfrpas5bA5D6tJQlROqIPoONM2ghBQ49Mml3Vlygaj9aCsEcDcHNQSQSkJJ3gul1461XUVmoZAFXpQyWozaLUipzm6MLwZ1w1I6gD3om8IHR/63MJav5n7CFNEPqh6QxwdQWcixYhy007R/JTAsI5CJtzCuzRXqF5uWXMdseHl1YFJT5eXWv+FxpmjTymHS3Uhen650dKsj21PWVnWll/GaliZQqgSbadkCJsH4pmzUjtTAnskBmpk1oVj3jOIgDJT6dKlbPIjtCDaFfKkzaeLCyAfk5CQCsjtBF6vhFAAwYZ4Wovc13v2PqDqLdkuuKVsXirEtBSUjB5LaRZE+Sj/ww/T2FQ/WvubjaZdRNgXIJFxcSBbsKCDRZ5uZ1hjledW1TT/T84JCYLEXr+B7ecGQU1h6JqegvCG4558sEmucv8F/iyMn+EoivzkVEcjbLO6gD+ZqyYEIdw2VgXZJaqBj1hTLlBwr96D4NmjjFfB9G8IWfw3pb
 kOHR76qk
 N1GoSEYHlIslR1XRc/yxg2CDjB9aIjHcm0SbSq37KsRb/ziLr71meNzg3dMi4ynq2ACwDP5EsWpbpZAYe8kFG/oRHoKfeQWoEbtmwP2r/q/Urjy7CDf1Dd/tyIzF1zPorff+IRFCZVxDbKg19tOumahGoj5Q6vhIqFuqy7PcyA/5ZWxs4fEoZUwrIFYNaBbdzxYkhKhWh8SJZAkonNLAee8oUakwlCda/QyQNk8m0VkC8XG7+8UYlwA2tXpxJXC/soi/AKvcY8pgYhXHiiimnByfN6M7p2sXzf8iy9nAH7tPG+sC4QH1xJYOQwNJXasxYQSDkhFcLm2GkMW+FG7V4JqudFopO2aEbCyIqxeFw9ihwUbNVPKLTkum3W4TqijSx2IcDHsfLOepxbLpAHco51LeV6g/z/0OrRUDT3XUtKLZShx6bLp1cZbdSrfP2XW5cHo5gW3bguEyufC+xtDcVk0Ud88fNrL475DQKqcSaTXp1pTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:36:55PM +0100, David Hildenbrand (Arm) wrote:
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0d3bd9e23613..a2c7c6a0768d 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -640,7 +640,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> >  		 * If the vma has the VM_DROPPABLE flag, the collapse will
> >  		 * preserve the lazyfree property without needing to skip.
> >  		 */
> > -		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
> > +		if (cc->policy.anon_skip_lazyfree &&
> > +		    !vma_test_single_mask(vma, VMA_DROPPABLE) &&
> >  		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> >  			result = SCAN_PAGE_LAZYFREE;
> >  			goto out;
> > @@ -1683,7 +1684,8 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
> >  		 * If the vma has the VM_DROPPABLE flag, the collapse will
> >  		 * preserve the lazyfree property without needing to skip.
> >  		 */
> > -		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
> > +		if (cc->policy.anon_skip_lazyfree &&
> > +		    !vma_test_single_mask(vma, VMA_DROPPABLE) &&
> >  		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> >  			result = SCAN_PAGE_LAZYFREE;
> >  			failed_pfn = folio_pfn(folio);
> > @@ -1948,7 +1950,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
> >  	 * So page lock of folio does not protect from it, so we must not drop
> >  	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
> >  	 */
> > -	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
> > +	if (userfaultfd_armed(vma) && !vma_test(vma, VMA_SHARED_BIT))
> >  		pml = pmd_lock(mm, pmd);
>
> A patch in mm/core.git will remove that entirely.
>
> Right now it results in a conflict between mm-new and mm/core.git.
>
> Beat to drop this here entirely. (I can also drop it when applying)

Sorry I missed this, feel free to apply with this bit removed!

--
Cheers, Lorenzo

