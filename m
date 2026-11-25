Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1B9606A68B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ot9hk0RB
Received: by kanga.kvack.org (Postfix)
	id AB8796B09C9; Wed, 25 Nov 2026 06:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43406B09CB; Wed, 25 Nov 2026 06:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930C86B09CC; Wed, 25 Nov 2026 06:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72DE76B09C9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:52:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB663160DED
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:09 +0000 (UTC)
X-FDA: 85473477978.15.12DC1B9
Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 59AAE40005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ot9hk0RB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607528;
	b=J/CRVsuUUZVQCOaxrjCXUEDOBFOcOTWWCbjVc+goeaeTbib4vGwt1y4iVm9ZchpF7yDVyi
	pKy9H4PQLZTgLft3Yg/CeqUFiebv6tDSNJ6bjIbJIHFhdU9uKHz8B0gJSATpp6dvpAm4/r
	L3Oz/sHfJRa2L1dLTuUBBWtOH4cQ2/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swZ2OrHGAAmdjGMDFDLdMlqudI2Ll9Z2QVb1W7XWNWo=;
	b=t4wFyFRlL8ZXaTnCxkXzzHsi6g3Pyfoxho09dvHAJThCzGIswR7oBLi8s+OJWt9SQxUPbK
	7souukzqkKTShIticdPZdLt6SAu+/7SYpdvxm2PVNKFbDzeYU2BMXTWWJW/gw8N2CShbvu
	bQPLKR6Yst/oSC2TxGrqddKMpFzL8fE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ot9hk0RB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eh4UV9rsh+mFYHPXJEN1V//9HTkB9IJyjcQyoK8DCDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607525; v=1; x=1796212325;
 b=ot9hk0RBBCKyVkXHa56fM6RHLe+3tIU8056ssw7/o9Fjnsw95Fa6BJVjSlSVuDOOefjq1YAs
 xVJiOXknWLRlhmO5FGQ9KgKTn6zZWZHpSbWzilByNUBUqTTChB4jfmTu+lTcdN0TEnLLGgfDnMs
 n7jA54GSnc/UneC0C5ZZZ5bo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2c3d09998e88645b;
	Wed, 25 Nov 2026 11:52:04 +0000
X-Mizu-Trace-ID: 2c3d09998e88645b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in smaps_pmd_entry()
Date: Wed, 25 Nov 2026 03:52:00 -0800
Message-ID: <20261125115202.4085587-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <031b595a-376f-4848-bfd1-ea85d273db13@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: ucb58c5mkb9wq8o8w49b1zufdsga59ep
X-Rspamd-Queue-Id: 59AAE40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795607526-670881
X-HE-Meta: U2FsdGVkX19KOfRwf5lAbFWE++PLP4jvHSkPhF85IDXkiN+XcY6hiY0mU25q3ve9JXn1LA5+8gGWzNbuvLoeeOyBBEpSPIB/Sryz6Ism4WuozwSFkYpCAbg8COvSDm+NctXYY0u+5Tq2m9nY+XG2cZwxu9kIRZ5WmRHDTp3W8iRr3CfNFw0GHMFd3gHrzYwJ0WYRGqSxaJ1NmlQwus1NIN8lU1v1SXVnYh6Sl3Hm+jFGAhk0JSRJ4Tc9GH+ahBnCCnJjFIch4uOVx0TwBwJMBfNFMRL/1d2wlZMUTkOpMu6uadJBJMsrJUN13ldTniBA5kwatUn+J4Pp/G33TLXmiQLc5MX9UKWcJZsZGpfabVGA2qxjQ27bWotdH273k29G9HPv5rr+6Y3QzO74D8Phz8kykFr2l7RJZCZHJ/atGgXPmFu4+ko0Wn0f9yJsdTUwIjcs7JsQWFZKjsIshT1PrAu+u/zisYChjZpj5OG+K/SE+jyCvjFRlvvvwle0nIsJPTAPCfFjL9SKu1s8ctAjL0Og9ZAFGBhTDXaUS/1J9TMr5FwOn+XNyD34mHHMMBho7r7qSlO46/JjuuLooA5KCemuWSzbuJFRQNF9y/ybR9/MlAtk8pRMuCLAUFL1A8pFRkyHcU4mAhASZLFcXD89Z7I08Cs1GiJtbs/AtT7tONa6MRFetQNmpdxzohcfvyNHAZXKfB8byD7Bg94/0jxQHrdmSwpxNw2qNHXeSQQ+8BbbrSRXDOux84/Qiq8Qm3SuuE5EY3pLeHYghIKsaHl0TbwFrTVkYVYuIFetJSiTdUgbm1fB1uK5Y8OHX+WrLGSXeJ3hs240/AgscVNmOQVbEOI7/fUlsxli35NsxqQhCnpU/K7SGQLtfhF1PSyNAXRioY82TtI7ma09VXzsu6+h+UOSMZZKZwpOHKAQoLZ7vPNZnt+B/Q5ZDctioF1/z6U+FMlMQ53/BqSQCCoAhOv
 XMvKi8jR
 ZtRBdKb3WA4GmW7kHfDx/gq/GPhba5+wOq+UPUqx35PEOlcq3lqzghNm25NFrgigm6TEdhcX7r2JagCd0sTfFV57+yX1GX96ulF47gUCe4mWNpAbD1QnwpVJazjHnz2JtXaGNod65BX4L9aUmygycJWIfC+UDYkHLtRDj3eFKmBGFnFrLLmcVQ+gMdRXbkllPwhP39YVQ6Ynu2MCkdQtMbjoo9ljH1IAy7bnSvo9/XxGcTGKKl65q5iMCoh1dxA5uZyw8hB+VzZ5kBjVk/5a6qlFhbCT+8A204loA1wYqXGz+c3duFSNJnSlkYrv5km/99MOKD/xoIwL3LSQfWGZthU9XME7MoSUG3Nj/urWlOBXq4oEuyHTd0RzUEEFS0FyMaEKNpS51TOsuUH4koBV9u7x8sS0bcEqMih0ZBmboQS7ycnjLDrLHuQP/pbM1F4EPwrKy2Kd5mWblwiqjX83ttQC+VsSz8kXQdS9vp31+p14J+rmGuCaIPaMdp8NzbwssE/sPtjU3fHZSF5BIzcr9hrboWA9zLkLQro2c8w/aIxlOWfyIQwfcdC/eGS9nWHBPkOCSKWSlogcBJxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 09:25:14 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 11/23/26 18:55, Usama Arif wrote:
> > 
> > 
> > On 23/11/2026 09:24, Lorenzo Stoakes (ARM) wrote:
> >> On Mon, Nov 23, 2026 at 08:32:09AM -0800, Usama Arif wrote:
> >>> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
> >>> into a local with pmdp_get(), the way smaps_pte_entry() already does
> >>> with ptep_get(), so that every test sees the same value.
> >>>
> >>> No functional change intended.
> >>>
> >>> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >>
> >> LGTM so:
> >>
> >> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > 
> > 
> > Thanks for the reviews!!
> > 
> >>
> >>> ---
> >>>  fs/proc/task_mmu.c | 11 ++++++-----
> >>>  1 file changed, 6 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >>> index 540c936aad4714..105c4998eef48f 100644
> >>> --- a/fs/proc/task_mmu.c
> >>> +++ b/fs/proc/task_mmu.c
> >>> @@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> >>>  	struct page *page = NULL;
> >>>  	bool present = false;
> >>>  	struct folio *folio;
> >>> +	pmd_t pmdval = pmdp_get(pmd);
> >>
> >> NIT: Can this be const or are the helpers not safe for it?
> > 
> > Ah yes, good point. Its good to have const here.
> > 
> > I think the rest of the series is good to merge. Should I wait
> > a few days and send a new revision with the const change here?
> 
> I'd pick the fist two directly. Can you resend the other 3 such that Andrew can
> pick them?

Will do! Thanks for picking them up!

> 
> -- 
> Cheers,
> 
> David
> 

