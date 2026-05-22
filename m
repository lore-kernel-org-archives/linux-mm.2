Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAD4CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 23:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704386B0093; Fri, 22 May 2026 19:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4486B0095; Fri, 22 May 2026 19:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3E16B0096; Fri, 22 May 2026 19:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 497346B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:14:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C83A31208A1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:14:53 +0000 (UTC)
X-FDA: 84796612866.24.A1E520D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F9C3A0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:14:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G2A9IOS3;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779491691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCJZIS3EJwvEDcATBWIFn6gHp7ruxYI8VCEk1vbgm7Y=;
	b=fRNxpRafC1WplunDM3yd8Q7ILCJfiliiZS7YUKekQgIHTpZ86KzGWnKe2HRgSvyWOFoRdi
	YU5ghTbuVN7erVA25PSqlO8NiqEWyhlrSsB9TH2Fxao3ofSP36RI8e35UFNzkK+ipCbsqZ
	gFsmOV9QNaEsNJxSN6IpTejhdAjnPLA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G2A9IOS3;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779491691; a=rsa-sha256;
	cv=none;
	b=X+rUBSGVpQH8hcPLbmYjWiCLYHIVUZAsz/vbHvEc/N5gfoEPoRAZ0tC2AEUXIwA/CIz1H6
	/2y/5K8kT6XTtZlJRktxjhUX3OL+E2eQFGEIWCv0U59udW2qD9NsHO8bl5/2snEdcc0nz7
	LT4EgnlLJVZ2tglRrFh9z7cKAFAUP64=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMRvII2787879
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=SCJZ
	IS3EJwvEDcATBWIFn6gHp7ruxYI8VCEk1vbgm7Y=; b=G2A9IOS3JesynR/UdOCn
	/ut7BaIFp+bYt3cWcBDa1+1qX107hdOZAXsxXWg9TXcFIIQbTqVvqIeRJL3bUjRB
	UDu7592o6g/OwynE+EnnlBOTkWS2ZjX9GmRuW1agJFz/DlTmacfQAt/E5dOs6kpg
	XYQYlsbSRI5JZ9+o7MhW637PGbZF9haOkuwD+34B9dN4iOrRO418PwB5gjKphlWD
	4hY51YdLNL2I/qkxN9JZKz9Pq7doj2Mn4gI9amxgvsz+E5/mYktzg2FkrFBroOJp
	8rjK6HV2y0PoqI+nzlXQ/e7TXg02cUei9ufFo3UQVCp84CjljxoEdHozHaD8/A2K
	ew==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4eatyqadqp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:14:49 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-91030497912so1629734885a.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 16:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491689; x=1780096489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCJZIS3EJwvEDcATBWIFn6gHp7ruxYI8VCEk1vbgm7Y=;
        b=ZHrImSx9JVVgrF7TYp22Whpc0Mhn0ViMy0sHwHQ1fTgr4FbOy4kuov9zSM/D+n0Vog
         wR5OncDk9cXjF90v8F2qteIKgb0sYZdm9lN3FRA59myeM6MMjUAUFM1TZNXbOevCne6h
         32pR9JUvYlhp3CBBTknaUKCU7rTL9izTDhOTaImeKctEz0Pz1T9+CmbI2p1G24PlLJ0C
         3qCEcltCEb4Q5RFA4V3xzt1Px64XwITMzA+/aH/qbTg6GX1DhxPDt1vHBlyi8tdIp4/d
         2Tr75eDNoiCKwp/MaSz9SQQ6hnCM0aSLSlyWLKae0INPRLvKMfamP+vnCX8tIsixkj4F
         c+HA==
X-Forwarded-Encrypted: i=1; AFNElJ/OeqDqIVuwnHjChwVBBIR/ENKAl3NQB6YkW2S90AULoXxqZuJpT385Ur9dsQ+p1nx5Ua1euHDSvA==@kvack.org
X-Gm-Message-State: AOJu0YzkJJhZY4mWIkv1+UNfrma940jz8jNFNpO9M265bkBDrU8ZcGaV
	14SYTifmHgG+2q8DIfvqLrnnC/sx65M2UyXa9WNf9bpvvfdozdD7Mq97yfOiJbVMyD2fra3FlYE
	Z+AhRucMiVOWPUzQLaOeK9fVIf/YYf5iQYbLvRXp2abMi5NwV
X-Gm-Gg: Acq92OF8vcYd5gJvcmyDpWJ+mWovaPCnAPohMsY8zzB02YRdm541vT97Dccm9ZkPqit
	vDV/QQtU1fFtAlm7q3Ez/4ht5VX4zPMwAvBy0RkHyDfZyO2CdL1VZahK4yRNUH8/cbYxhHNgONI
	n414tCp8VlrMBy53XtUG2mtyLQURth+uiRLXbi2oyXsd49ezISjWUoHZLMmW0WT1fVR2Q5bUkar
	E7mSczRjbnEC+CSLpkHfomykuVVNAuQtJ2eA02FEONwGTavIXSSYGVdOE0Zb604nfYSk1fuYXih
	iiTpj3LywAJtibfwhQOoWo6s1hU4o7JkcQB7wbKEsfkUQLPUH6XfzpkJOfyDW59fWSElKhrJ1OU
	0BrVAWgiBIqmUFZ25sAVdnTYgDnNA5xen/eRLzFLNP6tm04hN7j9ACQ+vHx9J8H+L1ECkCUmJOv
	Y=
X-Received: by 2002:a05:620a:2909:b0:8f2:c47b:962e with SMTP id af79cd13be357-914b49f5399mr897288285a.49.1779491688915;
        Fri, 22 May 2026 16:14:48 -0700 (PDT)
X-Received: by 2002:a05:620a:2909:b0:8f2:c47b:962e with SMTP id af79cd13be357-914b49f5399mr897283585a.49.1779491688439;
        Fri, 22 May 2026 16:14:48 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914bb9f4689sm249676485a.38.2026.05.22.16.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:14:47 -0700 (PDT)
Message-ID: <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
Date: Fri, 22 May 2026 19:14:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMiBTYWx0ZWRfX2dbxXfMqW1Bf
 maVmGB4YiRXndrWlmlmY4ErZm1dKstx2Jn1OOhd77ijG5eJjiGvM7vnPUw5mqSUMaI98cNF2Q29
 n71e/qTlPSIVJzJiYo0v9dKYhSjU98oq2hFvuOSbMU/d65TyukTtGBKrPp7LxLvrSvDNpH6rSdQ
 aDmCeTh9eBLNAfqGKXQHlBhc/nmK+jRzT1akUAkGuMyPNaIRFl05DRjuarGSRK2i4AcinS/a6Qt
 Gk7I2YX3bBhNLhmCu8yJ75BlGEHIV+c5diNzpcYu9PKtCq6VoLHHl4Z8PqmSy8oPl43FDF9W9D6
 PAS6+8+Iz4z3y39/mbonwqgvtpXWb2hrfJ3duDQ2QFYthIBGD416oN7xTdL9AnUHhsy6j/HPtZK
 BSoaMe0egpEaqmfw5quofPNZ4pfy7V3wc2FEhqdKvlY6bemHeHG5inkbuu82QNpVx3jfj5P97L6
 gyMo66E+w3tJLv2EWVQ==
X-Proofpoint-GUID: D2Jsi4y370zbG74x4gtCTNtfcg6C8BSh
X-Proofpoint-ORIG-GUID: D2Jsi4y370zbG74x4gtCTNtfcg6C8BSh
X-Authority-Analysis: v=2.4 cv=QYJWeMbv c=1 sm=1 tr=0 ts=6a10e369 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=c92rfblmAAAA:8 a=lIN9f26y6YkxF9qERjMA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=10 phishscore=0
 lowpriorityscore=10 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220232
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F9C3A0005
X-Stat-Signature: b3j5snrmr6dqrm79chayirbizai6xcqy
X-Rspam-User: 
X-HE-Tag: 1779491691-588128
X-HE-Meta: U2FsdGVkX1/vwyA3Mslol96BUbjzMo9uYPatV1BoBEuiWfLq0/HCbsjtY0flwa68fuF9TeT7yEvS/yHKiW8dnRtVabz5ZpcZnwKGpi1bklMjswt4GEBht4oeH8rShsj3ryzELh+63hbmtxRW85QA+3KxT++6MRME4vpHTNWAQjjWCgl37HMBSWWVpwKxEZAH/DZzp2W4YC0+gqL4FVmdxYVVjHRFh+f6fmMP1L39h3MuA8LVBGdHvNmdU36I+alT3Qnld6bAWskyq/pEncPJ9qYU4E+M1mW1BacLBkYpC3RgUxN3w4KWZpQlktkwXS2217ZBtSeLw4Qa+D/vJ2GuKSpjVctHpY55B17dwmbtuZlmwh4pRMsL7vzIIWIsSvg6voTqrxPJbDrq4ElR5FPH8/vkmqSZIlAoSATv8MeFNGYfhcndFb//UMsaxI2S5A900isdDQ/GFCG75USoN2Sa3fJ6zQe7lD7KzKw4bN2iIrnTngjdr3XfM4LOMoIgxxJ5eqntWno7g+p04AGVtmj4Vuxwl57ELt4SwjOINQtGoVCP/8LQPsUKV1M/OlqW6SqRUr9dFF0iIu0ULiCKEzb3dCuR8S7OWGwSR3yXBbFNVvjU8H8EhRXZOwunDtI/xA0iMBMpWtM1Oj/QWpR3/eCnOcHNccSjdfDLegbkCCi0SSS7hkdPjzrbUhehxHNnSJMD3owl+lt8Nrd7BfG17klToaeyzrNuFc/1GCpK7HX3p4wLTxKhY3+mXXFfQXljkJIY64ZXW2/kzbtw1npvD6bM0ftEjtIL5mqztnCY8EjqJwxOz5F2BJY65VO9cipE1nARjfmDp31VoRHJNo/XENglWyZ8xZ6o2jsg6mwa4yXqeB0e5t6SQV3gtdEw3y3/ZUznccZE46W3v0k8sTEgkk1oYv1gERIgCOhYxPP3cu25qcVfFcMXMlEgCYqh0KLC7lXXgzjuULqtd6szRFUtbSS
 gTKkKn6N
 7V6UIAgUdLaBBMFRl3P5XPIA4ASaz99VrNP/VDwbwCrlGQv2tiRCKnZSNQg5uHsaCokpCVrD5y/q/ujQ5b0Pr9pUaergus8ExEiSiOCgYXyxUfgj3Q9KTQM5PuJU0sejzuXdhh6OuPvxlIB5Y0pqH3DBPnHxuVqCWFzi5xwEKrlXUqNQqjBeCoLW3DdxFGe9fZr2bD0xEqeCr7DlQ69Jm9Pt1BC9TBwHyJ2ZDuRROdVeGGG4y+iuwrjNW0kEUtxvNYDVRoDUf9gfeLFOfiaaGknc/PyC+lp7yn4sID1mkoiiKv+1yRBTQqcbUA7Zx7HokEiytcjzv1A1A0qSGTk3m/a/fJTIjz2fCTmWxjaYG8+URVI7k+q9Fh9chNIl9UyUPdQrANn3MO6oZKmDLaBZhF9f8BG8T/GRAm6fd656ZxZIrlXO63wlTw/45E7S9YmqCj59fo80dda4frrHzMCv48A9mAxZ50UKSCEv3mIpbcFe4aaO589baR02XYER0gARrgDXybn/jB2PTC3dzEtNOqca5Og5a9UaD6LXy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 5:51 PM, Tal Zussman wrote:
> Add block_write_begin_iocb() which threads the kiocb through to
> __filemap_get_folio() so that buffer_head-based I/O can use DONTCACHE
> behavior. When the iocb has IOCB_DONTCACHE set, FGP_DONTCACHE is
> passed to mark the folio for dropbehind. The existing
> block_write_begin() is preserved as a wrapper that passes a NULL iocb.
> 
> Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() when the folio has
> dropbehind set, so that buffer_head writeback completions get deferred
> to task context.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

> ---
>  fs/buffer.c                 | 19 +++++++++++++++++--
>  include/linux/buffer_head.h |  3 +++
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b0b3792b1496..d0abaf44d782 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2138,14 +2138,19 @@ EXPORT_SYMBOL(block_commit_write);
>   *
>   * The filesystem needs to handle block truncation upon failure.
>   */
> -int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block)
>  {
>  	pgoff_t index = pos >> PAGE_SHIFT;
> +	fgf_t fgp_flags = FGP_WRITEBEGIN;
>  	struct folio *folio;
>  	int status;
>  
> -	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
> +	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
> +		fgp_flags |= FGP_DONTCACHE;
> +
> +	folio = __filemap_get_folio(mapping, index, fgp_flags,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
> @@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  	*foliop = folio;
>  	return status;
>  }

Q: "Is an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() needed for
block_write_begin_iocb()?
Since the legacy wrapper block_write_begin() remains exported, it appears
filesystems compiled as loadable modules (like ext4 or fat) will encounter
linker errors if they attempt to transition to the new API."

A: Can be added once filesystems want to use it.

> +
> +int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block)
> +{
> +	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
> +				      get_block);
> +}
>  EXPORT_SYMBOL(block_write_begin);
>  
>  int block_write_end(loff_t pos, unsigned len, unsigned copied,
> @@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> +	if (folio_test_dropbehind(bh->b_folio))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +

Q: "Does this add unnecessary workqueue overhead for read operations?
While task-context deferral is required for asynchronous writeback completions
to allow folio_end_writeback() to sleep and invalidate the folio, read
dropbehind invalidation is handled synchronously in the reader's task context
via filemap_end_dropbehind_read().
Could this be gated by an op == REQ_OP_WRITE or op_is_write(opf) check so
that read bio completions aren't forced into a workqueue?"

A: Seems worth adding a op_is_write(opf) check to avoid deferring read
dropbehind completions.

>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
>  		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
>  
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index e4939e33b4b5..4ce50882d621 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
>  bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block);
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block);
>  int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
>  		get_block_t *get_block);
>  int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);
> 


