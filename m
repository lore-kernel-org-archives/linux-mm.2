Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BEE606A339
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Oa+RYcvU
Received: by kanga.kvack.org (Postfix)
	id 263E96B05B3; Fri,  6 Nov 2026 08:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AB96B05B4; Fri,  6 Nov 2026 08:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1509E6B05B5; Fri,  6 Nov 2026 08:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F286B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:51:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88F8B1C3C23
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:51:03 +0000 (UTC)
X-FDA: 85404830406.21.43CFB80
Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F3761C0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:51:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oa+RYcvU;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973061;
	b=pLAE3m68LOenAd3TJNgZMUSgyaXFjVrXBBIcZCrmscf/5cRibaD6+i1sA5bvJNlndIKb6M
	ZhN2kPoiBe5KZFjWh8a6pLB6csnNdYYKVva2uAjqAyBa5NtgWKaaLSeTusZn2iqR5HdT0V
	a5apEivaqB4lHvqVuJ0eg6mCtzsbFqc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oa+RYcvU;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCYv0pUxgmAeB4rdFLxkyhkQaEAR/KeTjA5yN8eBLPw=;
	b=KHyCsY0DFOtcjiV4WkZL6oK7o5oU2ijd9LFw4HKpqs+ofPi+QkWKfhVEgtSUzQa6WGwc4l
	I8zoLdLt294bkDMFPLRVoAFg8n3DS3rqQDTCYvg949rCZylSqPxuiAgEhhadkKiRCUMAh/
	Vw4fWMv8SuG8daAVLJ35WAHrdz2LkMg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aSjJokHbfeqfaOpdHS6iuJx1acJZQq2O8WuSPhMF0YI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793973059; v=1; x=1794577859;
 b=Oa+RYcvUBR5PfQFFNyEECSKE8IZFUE0qtcC3TqqrH8gbPiNFoniV3V3wuatfAQl0gXy12YzC
 H8NAGpfZTqXU/gE2k1uaedWlmbuWsfz2rNEktpesnIBFVsUREBprL/vUo4+xz1fZ94VCGsMRe3R
 OPIImH5D+vmH4STXi7jisnI4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 821439f0cfeaeec5;
	Fri, 06 Nov 2026 13:50:59 +0000
X-Mizu-Trace-ID: 821439f0cfeaeec5
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Jiri Bohac <jbohac@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: Give crashkernel CMA areas unique names
Date: Fri,  6 Nov 2026 05:50:55 -0800
Message-ID: <20261106135056.790448-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zj53fxj6iku4joppw7nzgefe7htkkygu
X-Rspamd-Queue-Id: 5F3761C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973061-696242
X-HE-Meta: U2FsdGVkX1/Gi1b9ljMzh03PXN4DRNBiyuSnBlx+Ns4bgzIQjK7i+5V7mxy64x5aei+rU8GeO6r9XPKPBoU9sexI3avXroHZBYP3AI1aBlwz0PfN9YJjulVbjBGUvJE2IkdrpRDuCy6ZEkoHh6dvXHllCTE35y5SFU5QgZA2QtwnPQ73sAbbPe00okuD6mfeHRfivQ+jLETp1DH+VnAj3sqnUHwKd+oN7msTo8x4iSXAT1Igy80QMMmLj5c5NprPoSJZ2Hv49uPYtrO7rQGAUUFRF+2xpltcP7ko19Ib1mf+BM6eAZYoSipuhf0YHkvlZTYEp1mdVk4rFIm0YvixqDSWX07w+0LdFpDy3knCD5P0v0kssZYmHE7smdov61ZMcvgDBquof7yiAQ4xNpdyaPGyVqIeSlMjd4aTSec1nZwm+tQrO3H8sVk8t49+2FgBlt1OyqcjdjAoZ7Yy/SVxB5sG3bKP6zE6r4OeBkHVK+wa82q/sFPvCO2LkYEH39mKRBzVma74wKZJaTNHtRDvZuti60aMap+CZGkly+NPBcDlmZfQb2FtvDYTb0Il4DuASaTje0eZkfoKGpmAqc4PQQRUC20c4YNof1UoDzl60XVgm/Aopx6HFcB7NGJSIHhKeIWoVArg5+b4XAxzkVHZmzzYAiw7f9E2oeFm/455hcLImplLld9DGHHuTWZQNRfsOP2RQ/H5xxP99zbOQ7IOlZD2DzfHEFs5Jid0j65ul6cc701dgdT+0vuf2IIQ0hlk6DFPavmGyfI6geF/lZ89MudSnw4pLn6r5LHIETweUD3iyBknMHhN7kdx/rjl1RSh5pOmX/D/+6W7+P4I4SWs1mwWkKtk+nAIospjdFgYrR6sMZlVXYkI8oN5xiBHaZGNVBFGJBOd47VDmCscdwEAynGmsLy3vI5+9S5hMV5eQdB5nw/5sttJci2NWLC5oi9rGQsiNlgWW8rXQHATqAC
 NoVVL8PZ
 E0lx7LgauxyzzqgJlxsGrLJxB1mJsT2hu7XV4VRTLv0RwVVwydIIVixtkf/pAP1/8jxtmSdAT19eyjGcCDJxHL/VoyuWZAOCoGVfCtW5cui5bhzpkri/tbjjJF0lN76qyeXCxg2kCPntFJgdBj3c37k6OUfCIKcBw7GKzS4ZC4mpzoipx5XBqrhfcH8fGahHk/lrx23c26rp/s+IFhIuPSkqflnG/bBcjT6B04UBtngMVhfibymSePiGprGBMpMaK+UdrcVRhc+W5/bIslrbPxpqlVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri,  6 Nov 2026 11:43:09 +0100 Mikhail Zaslonko <zaslonko@linux.ibm.com> wrote:

> reserve_crashkernel_cma() names every CMA area it reserves
> "crashkernel". If the requested size can't be reserved in one piece,
> it falls back to several smaller areas, all with the same name.
> With CONFIG_CMA_SYSFS, cma_sysfs_init() then fails to create the second
> directory:
> 
>   sysfs: cannot create duplicate filename '/kernel/mm/cma/crashkernel'
> 
> and the error path removes the sysfs entries of all CMA areas.
> 
> With CONFIG_CMA_DEBUGFS, debugfs refuses the duplicate directories as
> well:
> 
>   debugfs: 'crashkernel' already exists in 'cma'
> 
> so only the first area shows up in debugfs.
> 
> Keep the name of the first area and add the index to the others:
> crashkernel, crashkernel1, crashkernel2, ...
> 
> Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> ---
> Found while adding crashkernel CMA support for s390.
> 
>  kernel/crash_reserve.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Thanks for the fix and pointing me to it in [1]!

Acked-by: Usama Arif <usama.arif@linux.dev>

[1] https://lore.kernel.org/all/20261106104309.3669583-1-zaslonko@linux.ibm.com/

> 
> diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
> index eee37a11380c..e58318b1e092 100644
> --- a/kernel/crash_reserve.c
> +++ b/kernel/crash_reserve.c
> @@ -483,10 +483,16 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
>  	while (cma_size > reserved_size &&
>  	       crashk_cma_cnt < CRASHKERNEL_CMA_RANGES_MAX) {
>  
> +		char name[CMA_MAX_NAME];
>  		struct cma *res;
>  
> +		/* CMA area names show up in sysfs and debugfs, keep them unique */
> +		if (crashk_cma_cnt)
> +			snprintf(name, sizeof(name), "crashkernel%d", crashk_cma_cnt);
> +		else
> +			strscpy(name, "crashkernel");
>  		if (cma_declare_contiguous(0, request_size, 0, 0, 0, false,
> -				       "crashkernel", &res)) {
> +				       name, &res)) {
>  			/* reservation failed, try half-sized blocks */
>  			if (request_size <= PAGE_SIZE)
>  				break;
> 
> base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
> -- 
> 2.55.0
> 
> 

