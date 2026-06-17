Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91954CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547FA6B00A3; Tue, 16 Jun 2026 23:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8B26B00A4; Tue, 16 Jun 2026 23:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E71F6B00A5; Tue, 16 Jun 2026 23:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 172C26B00A3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:15:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B7EC1C10D6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:15:13 +0000 (UTC)
X-FDA: 84887938506.28.48F9EF9
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2695C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:15:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RyvrvsqH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYheglZoN7ZQINy1Nkai5yf7WMqEaDWpcm1200AttNM=;
	b=3TrUFhMJCfv3nprApDPT6aoH7IGqBbFis58WBjICw0MRhyKAHSFt3AWRzdpjDB5pAe74jO
	eCWna4SMot2DDBIi5RR3ReIB4lHNiMJwtueiS0I4F1Szfxkzebk6RF7wpSWoyBmCe2azSA
	7EhuJmGJp2CRTmFIwhVFrDKP32B8d+I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RyvrvsqH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781666111;
	b=OQHKraAPYjdo4HKOs/lz0VxpYta+bo454vOAPz2hY5BrkrP17N++JXG3JsJSQrEOsPfQEZ
	0VBGd2mwMhDblo0EcCE9YmNWboYqwV89XEIEuxpx4Jyp7Q5zl22Iu42mg6yEOyJu1kSKX6
	1JoQRFzAhS6a8qagB/4m1LzBm+AeVYE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781666108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FYheglZoN7ZQINy1Nkai5yf7WMqEaDWpcm1200AttNM=;
	b=RyvrvsqHUQr2/2WVE1SSai7a83FHouvM1ASy/wdoWScK1x0Ub9zIsGQpopfn4pf36Mxb25
	DnpJnpNqv65Zb0KEYBbk16vQR2SLelhUs2cgnPVUw9x+PvqztbxbbfbOsDMaomrwInQBIw
	TbjerRr9NnM+ci/z211zqm2KqH7jzZY=
From: Lance Yang <lance.yang@linux.dev>
To: balbirs@nvidia.com
Cc: david@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Wed, 17 Jun 2026 11:14:54 +0800
Message-Id: <20260617031454.29210-1-lance.yang@linux.dev>
In-Reply-To: <ajIBTyWCLDo9RAHR@parvat>
References: <ajIBTyWCLDo9RAHR@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2695C0002
X-Stat-Signature: o7pg5gdjtbhwsco1dcbqnpdb5k9rbtc5
X-HE-Tag: 1781666111-600031
X-HE-Meta: U2FsdGVkX19N7YChSQH2oLZTRikQuDKWPiQoyz5p+m8QMFevpATAX56mWEOBL16M5dQlfzUDI+q7JIVgcbTXVbw2AaQABptDvIK762tSdEwMcPqjLv+6Lgb33zH8VmyEdiVPuhPnUjiUMzz+P7HeSBRou4W3Izg2mEdZ444bDBXkrc7f6G8qWmCEsHt8HwTGO4Ww6hpYuIZcH6TKYhsZheEtvQ3K4SbJfu948BOvgifvYvyLAzQpZXrjg25+G1Qf33/djjSU4uJZAI/Ev3WzpWOcWksR2s/h8d0/zC8KYQFF7YvNOTp4jMDGdbOyiSggqGwFmBbqGQIwyu/6OjtsY9BWUPGCOEaQqRqzWIG08/7IGOna+Tcz/Mk8LLHZaoVUniPQPSoQ+613PCKazAXZ61MWVQwGma6vVenB5eU+lOuDC8HZ6nRsbYcWYTYcAVeS0wyQ7tSuJ6DeEQAjA7Tt0RCDAeFtafCDINx92l03Sai4FvHcfL6ifsKnvhrw/DPQwolqdW5s0FcpsCU8b7Gkjh9/KMB3WL10HBlmElzBC9enfj0ZivQ/s+ximocbsvHks5TMGAOXjAFNytmfzNzJr0vBOU8AIOBnWziTnnWH5ht4niQJkLDyBfme1ZD/U6ap9W0gIbY9ODNnM94QcM0htWnf9MMe/0bpyNVE4lGsAZ7MDY5eZfP4Lb7ij6nyYecLAMdsL3A7hsvJogMVdItqF6Q6PtEKIMNNvPAwtRxpFMd6C5mJ+HTCw9jIlVsxn9SRxPP+Tu7qPAPO2x2QqppDWpVZVnXZYxGvaOHg3UpV5aC7t8ZqMAehwZKYTQ3zWRo5Zr2BBZFzrkbWuaPKs/PDzVWnlDGG8O+4+1m3rSlfS3unSTQeD/gkodZgBmXb/NYVUmeByFSfPnCviH+OvjYjuRMSilP6uKp/oHAiJeYF9Uglt7wKANgbyx8qD0JPKTS8Ht70QslaeJuTDTP7jUA
 QVdJ3KBi
 PNNKtq9vWEzsk0sGkaFUb9+Iz0+oTl5Jat7hDPPRu8xPUBD4ND+6BlLbU0ernVatCbvvkjI9vO2A2BCM50ZOeqRlxydNOZ/oYczvbSsGYfN7xZLXo9QcF6fRwtKw6icN397F+E6EO2ZAIEP08HVwilS4kjJnDh3BfNtXuUpa+fKdEAeCe35Qy4YGh/VRF9yg+rHJfr1PcvGVl5R2l88C+fRYf6+imUGsFdi6/4oxkxwcmZdRParuMaCm8Zcqv1AG6t20SFIVX5N0pMZy/l2XsKMiEgz9+Cl4hqSHyxpcwfJZawKU9diPkjvwfSTW08PlGm62uHi9ccohK65U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 17, 2026 at 12:11:14PM +1000, Balbir Singh wrote:
>On Tue, Jun 16, 2026 at 03:07:53PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/16/26 14:30, Lance Yang wrote:
>> > 
>> > On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>> > [...]
>> >> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> >> index 2ccbabfb2cc1..21635fab209c 100644
>> >> --- a/mm/page_vma_mapped.c
>> >> +++ b/mm/page_vma_mapped.c
>> >> @@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> >> 		 */
>> >> 		pmde = pmdp_get_lockless(pvmw->pmd);
>> >>
>> >> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>> >> -			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> >> -			pmde = *pvmw->pmd;
>> >> -			if (!pmd_present(pmde)) {
>> >> -				softleaf_t entry;
>> >> -
>> >> -				if (!thp_migration_supported() ||
>> >> -				    !(pvmw->flags & PVMW_MIGRATION))
>> >> -					return not_found(pvmw);
>> >> -				entry = softleaf_from_pmd(pmde);
>> >> -
>> >> -				if (!softleaf_is_migration(entry) ||
>> >> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>> >> -					return not_found(pvmw);
>> >> -				return true;
>> >> -			}
>> >> -			if (likely(pmd_trans_huge(pmde))) {
>> >> -				if (pvmw->flags & PVMW_MIGRATION)
>> >> -					return not_found(pvmw);
>> >> -				if (!check_pmd(pmd_pfn(pmde), pvmw))
>> >> -					return not_found(pvmw);
>> >> -				return true;
>> >> -			}
>> >> -			/* THP pmd was split under us: handle on pte level */
>> >> -			spin_unlock(pvmw->ptl);
>> >> -			pvmw->ptl = NULL;
>> >> -		} else if (!pmd_present(pmde)) {
>> >> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> >> -
>> >> -			if (softleaf_is_device_private(entry)) {
>> >> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> >> -				return true;
>> >> -			}
>> >> +		if (pmd_present(pmde)) {
>> >> +			if (!pmd_leaf(pmde))
>> >> +				goto pte_table;
>> >> +			if (pvmw->flags & PVMW_MIGRATION)
>> >> +				return not_found(pvmw);
>> >> +			if (!check_pmd(pmd_pfn(pmde), pvmw))
>> >> +				return not_found(pvmw);
>> >> +		} else if (pmd_is_migration_entry(pmde)) {
>> >> +			softleaf_t entry = softleaf_from_pmd(pmde);
>> >> +
>> >> +			if (!(pvmw->flags & PVMW_MIGRATION))
>> >> +				return not_found(pvmw);
>> > 
>> > Looked at history a bit, and I wonder if this changed something old
>> > here ...
>> > 
>> > Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>> > migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>> > including not_found() cases. So lockless PMD read was just a filter ...
>> > 
>> > With this fix, true case gets final pmd_same() check, but this
>> > not_found() case happens before taking PTL.
>> > 
>> > So a !PVMW_MIGRATION walker could race with someone, e.g.
>> > remove_migration_pmd(): we make the not_found() decision from old PMD
>> > value that still says "migration", while real *pvmw->pmd may already be
>> > present again. We return without ever taking PTL :)
>> > 
>> > Not sure about practical fallout, but should these PMD-level not_found()
>> > cases also take PTL and restart if PMD changed?
>> I was hoping that we could so something similar to the PTE case.
>> 
>> In map_pte(), we check whether the PMD changed, which is slightly different.
>> 
>> The actual check happens in check_pte() after grabbing the PTL.
>> 
>> For the case you describe, map_pte() would find !pte_none(ptent) ...
>> !pte_present(ptent) and !is_migration, and effectively grab the lock and proceed
>> to check_pte().
>> 
>> In check_pte() we re-check under lock indeed.
>>
>
>Thinking of the practical fallout, not finding the PMD for a non
>migration worker should be OK. Is there a case where it's not OK to
>report the old state.

I was thinking the lockless value should only be used as a first filter,
to see whether entry looks worth checking.

PTE side is roughly lockless filter + PTL/check_pte().

PMD true case now gets PTL/pmd_same(), but some PMD not_found() cases
still come straight from lockless "pmde".

That mismatch felt odd to me ...

Cheers, Lance

