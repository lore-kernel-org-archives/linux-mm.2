Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF394C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC74B6B008A; Mon, 13 Jul 2026 20:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77976B008C; Mon, 13 Jul 2026 20:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69766B0092; Mon, 13 Jul 2026 20:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01636B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:46:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D421A018F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:46:20 +0000 (UTC)
X-FDA: 84985540920.19.29EAE56
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id A0A9620007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:46:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783989978;
	b=37fweMyTn2c7JDuOjFO7kg+ZzFKLkQSzIkiHEWNeBXqQcQVm1UEVMWQ7qYew0Vrr3ZfC01
	xhMGJ6GLm+3VOdB3cD2zz8M7Xs2hqeNuCRETpm1/7j/itNij5zRpuVAOFvN6CQoSqiImWS
	SDysX6Lnr2UQoR2eb8qwbzHIXD6ey2o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783989978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OTiGwCBfcJulfC0Sk12e4bNbbG1DyStUhJ0NnHPVZ6Y=;
	b=71zuivuEzlI75ROfc4RufjJljDPFkdRV1PI3XXfVN/C8sPSwfHfque2nwNvdr6jMraCYga
	tZP3ysrmYImEiGI3p5SK3+c5huxOp3b1EkYrFtKuLFcTN9n8BtsfIDxbEhRaQtuz/Ekj2B
	pQwrB8tjM6PxTukA0lOOUNsV/fMd6YY=
X-UUID: 66763a047f1d11f1aa26b74ffac11d73-20260714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b9a02f50-6f9e-4643-9cb9-ced1449825f7,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:b9a02f50-6f9e-4643-9cb9-ced1449825f7,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:f0c52908228f37835a4e6c072af3c148,BulkI
	D:260713224606VYPSDRI6,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|136|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:99|1,F
	ile:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 66763a047f1d11f1aa26b74ffac11d73-20260714
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 138411820; Tue, 14 Jul 2026 08:46:07 +0800
Message-ID: <45e2e42c-73c0-4d2b-9b4b-bd44730c2378@kylinos.cn>
Date: Tue, 14 Jul 2026 08:45:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: restore failed global reservations to subpool
 in alloc_hugetlb_folio
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, Zhao Li <enderaoelyther@gmail.com>,
 David Carlier <devnexen@gmail.com>
References: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0A9620007
X-Stat-Signature: nhkgfaji9f3ka59waxbk1eggryud338y
X-HE-Tag: 1783989976-811527
X-HE-Meta: U2FsdGVkX1+qSFHLwAMCbddUfxI0L39ybzkz33QJyayxc3vpzFWmLPtLA3VYJlC/hE/Ewu9t8jTC+Bv54xGW+IUfyWi4ZILP+GC4X2bfTyYOBWrc6aeRWpRYWYqeFwOQPH+Zh2XS9k6xOud5Wc0+y/gVix+/5kD6QRPg0KKGptCb3Fwk9vdWYraitSoY52TybQj194Cx8HkIhqHhFGWBXZ3T57qUIUONkQKQugkc/W1XnP0lqexVU/20pD0WA3s71WHXTRaMk71d0D3vOnhUkRjLaq4L9dz6WkvYCGgxlxcXlZJFP7ERzhN5SjzSMYyIcn8Dnjt9Xe13WKCMpSvR3ozAjOwIVS1qP6zYpzpjkWI053CSz9mEXiyLFysN2buTjH890UDZhOFkexTL75BCLSwRRvB7vwhy5WmKx2i2yaEJWDu3HqBDEGq7Qp1kfdJba8ccBVUwmXKMd3sZ1PeDQKQGJnAkCQ3X4vdlaDMCV90NVAs4KPIdeDlIUSVnexVMxwHW5iaV5TA83usDYJ21N8k1iauYIG3MjowGU97AFeg1lla+rJW9GSB4YT/RsYQOnSEH82UtNw/dzUlPDNnSrOybVSgCzRAo72wQ1h1KkF8FcD8e9X2kCjdg1wfrkwfiZhUvPwEk+hQVBRUrPxtxqMUiQMuSQ/rYbZHWav4MZl8JcUoFTJDxeRcbGkfNYZRtTDk92LQZ/+4t2LNoGtPyiYeKTgKBsXpjO50oP3kh23uyQZE95dFIEdW7PvVCNV2iV7VhjbFWl/vAaPv6N5Km4Em6Qp3Hr1aiz+g8dF1KG2qh9BW5TurTbPlSxv1ACm4+HgLqiFRLy9yLFH9yKmcQoRZBjv//QOekQl68wOQ9lR1hk7D0RRfDC9Y6FMxVy91abCRkwnYjCewaJRhWsEMeCNdnF18uvfg9xq02k/jzPXGEKJyvCGjORlpQ3SL1VUS2y5GqjRBzDMLis958xNq
 0ROdAtOb
 1YGkHl4tAk4ulAIEekOOQ59kWchEEue6Id6s/MKqEtfc6yZXKBu68qhPsx7i/rGuLXnW+oDVLh2ZbZlTbk5HFCqbfWd2wovxUD8b4rZm4AEvIfTuEqRZW+3TX19AD92Pi06nJSWBihBnn5DNqYjaRQVOHNsyrc6Lfvq5t3QK5B3EBjbQJYlNRSg+/MSs0Scs4c5pff1R4HALc1z9U/xPskipeSqtJsCljUnOO5YUd9jNLegmZjww8vu5uagjS9Zyr6X42Cf1szwqiLxFX/QU/AFH/3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/13 22:45, Joshua Hahn 写道:
> On Mon, 13 Jul 2026 19:50:08 +0800 Song Hu <husong@kylinos.cn> wrote:
>
> Hi Song, thank you for the patch.
>
>> When hugetlb_alloc_folio() fails, alloc_hugetlb_folio() only rolls back
>> spool->used_hpages in the out_subpool_put path when gbl_chg == 0. For
>> gbl_chg > 0 (e.g. a size= hugetlbfs mount), hugepage_subpool_get_pages()
>> has already incremented used_hpages, but the error path skips the
>> rollback, so each failed fault permanently leaks one used_hpage until
>> the subpool is exhausted and hugepage_subpool_get_pages() itself fails.
>>
>> Decrement used_hpages for the gbl_chg > 0 case too, mirroring the
>> hugetlb_reserve_pages() fix.
> So something is clearly wrong with this codepath here; there are now 4
> competing fixes in the mailing list currently being discussed [1] [2] [3]
> including this one and they all do things slightly differently.
> Let's please agree on what the correct solution is, 
> I've CC-ed the authors of those 3 other solutions to discuss here. 
Hi Joshua,

Thanks for the review and for bringing the authors together.

First, apologies for the duplicate submission — when I sent this I was not
aware of the other proposals on the list ([1][2][3]). I ran into this leak
while looking at the subpool accounting and simply wanted to share a fix;
I did not mean to add noise to an ongoing discussion.
>> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/hugetlb.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index d6c812d1857b..8413ec92d836 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3073,6 +3073,19 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>  	if (map_chg && !gbl_chg) {
>>  		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>>  		hugetlb_acct_memory(h, -gbl_reserve);
>> +	} else if (map_chg && gbl_chg > 0 && spool) {
>> +		/*
>> +		 * Restore used_hpages for the globally-requested page that
>> +		 * hugepage_subpool_get_pages() counted against the subpool's
>> +		 * maximum, but which we failed to back from the global pool.
>> +		 * Mirrors the fix in hugetlb_reserve_pages() (1d3f9bb4c8af).
>> +		 */
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&spool->lock, flags);
>> +		if (spool->max_hpages != -1)
>> +			spool->used_hpages -= gbl_chg;
>> +		unlock_or_release_subpool(spool, flags);
> Why are we unlocking or releasing the subpool here? 
Good catch — it does not belong here. unlock_or_release_subpool() is meant
for paths that may drop the subpool's last reference (e.g.
hugepage_subpool_put_pages(), after which the subpool can become free). In
this error path we only adjust used_hpages and never touch spool->count, so
the subpool cannot be released here; a plain
spin_unlock_irqrestore(&spool->lock, flags) is sufficient and clearer. I
copied it from the hugetlb_reserve_pages() sibling fix (1d3f9bb4c8af), but
it is not the right helper here either; I will switch to
spin_unlock_irqrestore() in v2.

One thing that may be worth keeping in mind for the discussion:
a833a693a490 is already in 6.x -stable, so the leak is present in those
trees as well, and a backportable fix will be needed there regardless of
which direction is chosen for mainline.

For what it is worth, I verified the behavior with a small reproducer (a
size= hugetlbfs mount with nr_hugepages churned 10 -> 2 -> 10: unpatched,
the subpool only maps 2/10 pages after the leak; patched, 10/10), in case
it is useful to whoever ends up shaping the final fix.

Happy to help with whatever direction people want to take.

Thanks,
Song
>>  	}
>>  
>>  out_end_reservation:
>> -- 
>> 2.43.0
> Thanks again for the patch,
> Joshua
>
> [1] https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com/
> [2] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
> [3] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/

