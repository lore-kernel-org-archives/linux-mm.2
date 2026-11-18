Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3170960A261A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1907E6B00EF; Wed, 18 Nov 2026 09:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140F26B05B2; Wed, 18 Nov 2026 09:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EF26B05B5; Wed, 18 Nov 2026 09:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D21E36B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4178E160794
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:16:23 +0000 (UTC)
X-FDA: 85448439846.20.CF5EDC6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A718180016
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:16:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NkRayhbqFtlPnHUvyhGbsBwanQgB2ADYmADCwUGi5uw=;
	b=qFQL6bz5w2KUvaGT23DVcIDRQMv2eJS9+65fvmMcuJWkYvgWXfdhTwaYhZ48nDq9X1l8A7
	umnqSthmrp4JipcoXBF1LR/0qQgfzNnjHXHrg/Q2Yyj7FWV07KaULGjannPgZIliTiRXS1
	2ww/iJNBFVCsfdMOkLJd1HbTFxWFSpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011381;
	b=SPxbfPRnG4TrMtzOPvm3aLUtlz6ukMM2euJ14vhLFFqFFouuLHwcGMY5wBRKFprOFDpGNt
	hgoiha+zAFtXndpzdJFDeOpsbANf4LPsQgMM9V5GZTx5m8ty7zdVOJF1ON/eA50+QGlIY5
	322nXZKdrXfgvEviFA7uw998Euo0sI0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: 97239286e35a11f19a56ed5b684f684d-20261118
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3094af1f-aa7f-44f5-84ce-86c27277b13b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:3094af1f-aa7f-44f5-84ce-86c27277b13b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d61cf93fb4fdaf745f8ccd974ca04727,BulkI
	D:2611182216074FAVQI0Y,BulkQuantity:0,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|153|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 97239286e35a11f19a56ed5b684f684d-20261118
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 821553608; Wed, 18 Nov 2026 22:16:04 +0800
Message-ID: <bc48e456-5c1b-4479-a426-6639ef695914@kylinos.cn>
Date: Wed, 18 Nov 2026 22:16:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/damon/paddr: skip non-LRU folios as a whole in
 pageout
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, sashiko-bot@kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A718180016
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z5igcj5x1p4o7rem6maqzhs8rqhudxne
X-Rspam-User: 
X-HE-Tag: 1795011374-273866
X-HE-Meta: U2FsdGVkX1/3l4wQ6NlKZYzQzEqqtRIVvta6TnvCezBQpKoYnN+768YHVo4mGavHajqeniMFbc0tf5Gl5lbSA8HFdF5jkyl39JbG5vQTKzvWojypKroM1SNAkJxcHML5M+lO2EInH74jXczkg6pik5p6Ij19WZbG88MZo35Rkxhs4N2fw7mcvt0BCqVSi6on/4o8DCE4NV0lH0U5RhSsPvzXyAKiMKI3GLWSnXDUmDQy9vMX40pseVFlBpT+AW29FIWH2U8xxJEi3o6rDJFj5qdsimw9Eg9aVh6+rBBFoo4zbN8iLnuAXjoW7z8D0yJoGAND6NlODKUi0DeQBEvd36XXP6QNxmaURGpILjH6gUc2MLhPRgbkPKOnCBzApg4neGvgFzl841Gxfe+bLtxiYLV1bllNj3N4eoHLIQzJpokGNgTQsVNvskG1fUg/T6rb8VbE3pTTISd7C0b2tZFD8hS28rDv9266/tyhWPJ2TtjvmJ2pMOZ/RjC1RR646UKMaDVtHLMtKJu92OJBsy5aW6wwLVnD29lUWoZBV7Pw8r1hPiTxeZV8MkwBAE/tg1KHOISgYtTBVVHtpHepK+AmzSx3zRWS0Uu1O/IAzVIpJhMI4E/js0OCtjRLPFlM1J4YDNWAozWmrkCAtPhij9Tlzis5LqWQcDT2XUx3l8402NHRKK6NF0TYV4ZRsy6Q4wiKEXm105jCy7rTUv22mZgPv9nE0Qis7MJGeM8A3CohTHsqxI9ShDXa1khgMUikQs4p9JZaGB3z/x+DGqD3EVTJU702T8t7E5mEB3mGdxgJgrDHbCqNd1Gqs1vjuQC3pWfWjrgm8A7WDY1eTaX2tw3ng5FiaoxrEqyvVyq+tWtFWF6Nu+MpCxhm4WsqS7u1sz5qSi/arUL4Q2cA+1DroJpvt1JQVxCOIP4qSuRwxA7+QekP2GRZ6l79U4TqdgvIOhulL3WpPbKVsFp71O/HFFh
 UB4+ZvR7
 dwen1H1eDk1BTBK7g1D3f7XKL91BCUY/CcpThEPWsCrfQXbUlyumuPXbFmIhfbUP9rmX+ug+s4c9gm9CX9uEf3icWxYFa/WuSTBIRqBYHTX3YISI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/18 00:24, Aveline Noir wrote:
> damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
> not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
> loop then looks up the same folio once per base page even though
> pageout cannot reclaim it.
> 
> Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
> whole by advancing to its end.  Do this before the filters, the
> accounting and the last_applied check, so that adjacent regions within
> the same non-LRU folio are not walked by base page either.
> 
> In an x86-64 KVM pageout microbenchmark, traversal time dropped by
> about 99.7% for regions covering whole 2 MiB hugetlb folios. For
> 4 KiB regions within hugetlb folios, traversal took about 1 ns more
> per region.

Good catch -- thanks for looking into this.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

> ---
> Tested in x86-64 KVM guests.  DAMON KUnit tests all passed.  Ordinary-page
> and THP controls passed the 3% non-inferiority bound in the microbenchmark.
> 
> Changes in v2:
> - Drop the redundant hugetlb check and update the subject and description
>   as suggested by SJ.
> ---
>  mm/damon/paddr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5b773012a876..0a205fa8d468 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  
>  	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
>  	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
> -		folio = damon_get_folio(PHYS_PFN(addr));
> +		folio = damon_get_monitor_folio(PHYS_PFN(addr));
> +		if (folio && !folio_test_lru(folio))
> +			goto put_folio;
>  		if (damon_pa_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
> 
> ---
> base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
> change-id: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b
> 
> Best regards,
> --  
> Aveline Noir <jm5905938@gmail.com>
> 


