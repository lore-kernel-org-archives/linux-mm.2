Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845E1606A8A4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYh0Hc5W
Received: by kanga.kvack.org (Postfix)
	id 83E4D6B05B7; Wed, 11 Nov 2026 14:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF846B05B8; Wed, 11 Nov 2026 14:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF466B05B9; Wed, 11 Nov 2026 14:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43DD86B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:02:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCF52C03E3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:02:04 +0000 (UTC)
X-FDA: 85423758168.07.0193714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD936C0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:02:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYh0Hc5W;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794423723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGvA7aNbElvHdqmQ/xMwu/aFIwDZ9xdeje6P1XRIG3E=;
	b=e9vwsSPf///FHa5ujIStsVos95O1hmgu4iMRYM3Oh8JhHtxJ3zonw3Hfwnh7C7Kxc2hzzY
	WusoPurlLbhDoQbyyeFuN77qsVV9H2hBr0wNhXKQvOBaGhRam9WBx02cNyFK3kJKFNf5+E
	B3VuABtZSaEm1bdepk3RG6K8S1Ofpx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794423723;
	b=dM1EIX8DUXJ6YKhEGch8EiuPpHVOc4CXIXJ8xZZdSkInUSgVcW+y14lQ2np3OPbeUOGZZ/
	O5I0k49h1418+US+/voXLll89MtxPXbsoNOc94EblX9ffUmhlkREWB2U9wEiwRqRAC/xOD
	hdjTvrLMT2Txjh/N4khNZeLwOqC5Jbk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYh0Hc5W;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9D5747630;
	Wed, 11 Nov 2026 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B051F00A06;
	Wed, 11 Nov 2026 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423721;
	bh=UGvA7aNbElvHdqmQ/xMwu/aFIwDZ9xdeje6P1XRIG3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nYh0Hc5WTvLXWR0PpdeDEQycij6SQVynG/D9w8M6LNmJF6fZnX+KZhqmcr9+DofTL
	 1t869zG0ixpyUwRsMt3QwMx5ThEG9Bs8ZLo8VfWWQs03p77SnH/0m4BPhxklYl5p4E
	 qLnpsBM96i9dW1JgfsTos/MYnkoPxVDpBCVFBQHCJWqxB1Cu2A6lj5t076B63LWVYz
	 pdtQrojzSvgJpSxUnaZ/WAP/T8jpr2H6hsgE/UDlifpjUWOel+gkuHuwUYFBf8Nmkz
	 CiO2rDoMh/Uzwyh6wFvwy84CBThROr1FbbUXBEb1cfAn7v27vpKfkasmGPV0QRwnXS
	 2dQy0JEAJJGFQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 45AB9198004A;
	Wed, 11 Nov 2026 14:01:57 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 11 Nov 2026 14:01:59 -0500
X-ME-Sender: <xms:pLv0auFvRs13t94fambPBJxaah0jl9soK9jYvksUwEnSQMFUiv7_cQ>
    <xme:pLv0avNH0BHJJysjdWJ0KAtbCZ2JluCm6hK8b7C_Tzf9l14Wp-zveuD2kDJmEmCzn
    Lxjr-dasRnZykEn0_ssIzr-zAvor5YsYf5DIuhLOb6Ib69OgTj7StNE>
X-ME-Received: <xmr:pLv0alf7Lhu2rO9745tEPXz2cD8D1p6-Jfg8z3UY9esl3NWls50yvUb07cU>
X-ME-Proxy-Cause: dmFkZTGUrBls5w/UEENbc4QSrU45nLKjL4/o++nqxC9OJS9f5x3nG4z2h0vA9zTXVlIrwk
    CwfDyXOcV7vO+BP7Z89KGrkm4YQkxS96v2gVR/kgVbZBHpUz2ZXhJO8sIGLtQj2Tn3CoVw
    hG0wp+uaydBlisb2ScHtGCEd4zxa002LBa33wxBHeD1SO2skN4MjcRow7HuyZS+C9CHS3X
    1FcU34iQECUsMDUhAG3tswsFel1JQc9DrrukwJo2Jx7ZCpcvn27jIuhpDvLHrUp+EucfbC
    UuoCLpjHnrpn3/cNfboWDuvRCcwgCfNKam4Uj7NynoW0ZDHcY/FmkLsgm6RcxCgB13MxaY
    qNJfZ63LHM1TLvxg9XzJ4AZzQh2FqHvqBn5XcefCQ7zln8J+tkHM7S7B3qyxFVOyLsCuG+
    aXReTLfd7xIPgO+kPGAOWnEnz8FBaJOvZ2d3vb6i132Qck9TpIkgM/rYZXgiNKVOqYa42L
    KA+Pt7RK+i5vWp3sEQpf7ObXQtNV+HFtkVgrWy6//p7vnTbQrBoqE6VZXWDe45Ooi5rv/e
    mJwBUg0Sigiy6BNH4OymxE2Wgf794hMQ05VG4dg2BtZiuXTvEm7vo+sNZZO2hC66pNhjlm
    BWq5x2q6oauGQt61tBKF3S+un8za9g8FYXHJAg/jFFoifSYnVYbwyGVsKt0w
X-ME-Proxy: <xmx:pLv0akTltdapm9PFC0tYwCjfAj_TxsUfUqqFlu3hmg46Vn9rjKYBOg>
    <xmx:pLv0aheLpWDc__1-d2kIRQApBXAWn3YxIOmEAOk47fqwuDNJZuG4gg>
    <xmx:pLv0asoogV_DY8Y9z02GhVBDWQKjBO9Bmtqber5ICa1Iy4WbDj_Qig>
    <xmx:pLv0aqeVLJlCdZkd1bX1rMWUV3dXQYLG_JvpLsklDqd7s3qtsgiPtQ>
    <xmx:pLv0aslaqHjoC7cmEZh296IHSmUbxZ7gIMTcVtgfZSFfqKedoNBkqcuE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:01:56 -0500 (EST)
Date: Wed, 11 Nov 2026 19:01:55 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wandun Chen <chenwandun1@gmail.com>, hughd@google.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: improve mlock tracking for PTE-mapped
 large folios
Message-ID: <avS7FfzvjieHufUE@thinkstation>
References: <20261110123218.1579490-1-chenwandun1@gmail.com>
 <5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org>
X-Stat-Signature: o5ob74zk6bdh191cyzi1ywyu6fx85yr6
X-Rspamd-Queue-Id: BD936C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794423722-735803
X-HE-Meta: U2FsdGVkX1/6ZE1gei/7YkS+qiD+XPQ0EOuDuN3z+isfo8lbg9bHWdUeqLI+Zs7jTZIs8bib56rKCTxcGt1vDfyeSBvu6myERNZlhO9uVDlKp4uzzACsQcBgJatOAP+ivUm0cSRF5fQPGoleBgo+c6VyYD7iIGTNxTlwIJYUjGVW7O/2JeS5Qm7uhb+AimGGMjT0WrWta2qvzNjUbm/80gTkmXqnGOCamc4XcLT3oOLSsVfHhqhRdcqs2Ypl6AShDbbAc86ceDZ7JfG/c7ubb5dY1Is1HyBKVb6skT3N4QJiqvBqIlviNsvUJMuHhQ2yBD5CntbezfBCOoH1yvqS1AwDMjcJPwt2brcOkc/rI9Rc97pPD25rsx3tSUUfzkvkWzGf+7ZaiURcptzSRg5qFlJtnmJmPby46NaXyIH5whjYoSkY0/YSjhRc1mONGzs7tzjmy62sKWyjeeXEBGWUy3o3PjCO4NpFg9r+PEa1f1f6y30WC0BHqSwGZisCWuClOXsG2f2lL26wluxLsBQWhsPQS13X9v55Gddb9zRgpCBTy5l+CuA4FlCfnjdhBdRTtifJiViGrMgIDqdv/M5rMAXo/6nDMcqKPdCOlV4DA9SXMTZbyZQrlcMH5yHfg5WPctBytIubKa4j+rvlWNe1Po6Kg6qg9XJDcbb97unkm0DYQ0Zk8xG+YOXjbgnCIy/6nhxnz5mOn0+ZEzu0dIpkUQlprmVal3emrSWqjcARROSfTxbpYnPBSCjp6yAjw7k9DKGPTb6t2O4N498x9hr61p+J/a9RDn9mu4lHhZmVbv2MUFtlvmSJoz/o5iUbt7dh6xPMj0GNgNVIppJxmkyw+LpYNh3Fdp1sFervcM4BKlURA/73fYk39HROXQGKOeGpc2iL3HAZH0TGvXx1hqvifZ61zgoGTvH3P21TVouUOeeN0I2FQl5IoUQNUSalvdhNMOkk4J0hp3IHiyK0MPW
 jFwYqExF
 3Pxn25VKq05dJfnKm6qMlTGkr0NCLT4G3i840MsYIBs34EIe8fHh6Zeds19KtD4yadTSJ/f2endy+aPZV1vy214x/+1MHQvTsQCX5fn0HxdvGvqC1DTehdrwEInvgnTreM0KLBhnYHeKhq/dlR/cJe9dsL4g2MoWw5lvVIfSGDgXNFh5bqUhOxusdZU/ddqBfcmCxyptK8KNpSLOZ5XSCWEAs03Lk8D7a2E8b/AJP/xwU4lS0fgjzrZC1u/hNa9Kdd9SmuRx8/KLTWS6WrEs7wdctw7w8tofXHuBEADpf6wMqwtaFJc4+loR3XZ2Flj1hI0kHYI9n+7/U8+7OSjIVaE/s0LewqsA9Bt/HM9usA7H/ZNFrU+q1fhTOggEUfUIsOCRm26+z3UUqbTmVfZAI5rQbvmNb8Xu55dp4p42BOkSLub1dqess/pGjAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 09:00:10AM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 13:32, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> > 
> > Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
> > mlocks a large folio when all its pages are added in one rmap operation.
> > However, when a PTE-mapped large folio is migrated, remove_migration_pte()
> > restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
> > result, PG_mlocked is not set on the destination folio.
> > 
> > Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
> > remains undercounted until that scan occurs.
> > 
> > Restore mlock once the full mapping has been restored in a locked VMA
> > under one page table lock, rather than waiting for try_to_unmap() to
> > restore the mlock state.
> > 
> > Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> > ---
> >  mm/migrate.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 94033c222e04..140e291d4587 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
> >  {
> >  	struct rmap_walk_arg *rmap_walk_arg = arg;
> >  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
> > +	unsigned long nr_ptes = 0;
> >  
> >  	while (page_vma_mapped_walk(&pvmw)) {
> >  		rmap_t rmap_flags = RMAP_NONE;
> > @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
> >  			else
> >  				folio_add_file_rmap_pte(folio, new, vma);
> >  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
> > +
> > +			nr_ptes++;
> >  		}
> > -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
> > +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
> > +			if (folio_test_large(folio) &&
> > +			    nr_ptes == folio_nr_pages(folio) &&
> > +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
> > +				mlock_vma_folio(folio, vma);
> >  			mlock_drain_local();
> > +		}
> >  
> >  		trace_remove_migration_pte(pvmw.address, pte_val(pte),
> >  					   compound_order(new));
> 
> I guess pte batching would be one way of handling it, but that requires more churn.
> 
> The spirit is similar as in try_to_unmap_one(), where we count the number of
> ptes in one VMA. For consistency, I would call it "ptes".
> 
> @Kiryl, can you take a look?

Looks right to me. Agreed on "ptes".

With that adjusted:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

> 
> BTW, why don't we care about that in try_to_migrate?

try_to_migrate_one() unmaps the folio whether the VMA is VM_LOCKED or
not, so there is no mapping left to keep mlocked; removing the rmap
munlocks the source.

The mlock is rebuilt on the destination in remove_migration_ptes(),
which is the path this patch fixes.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

