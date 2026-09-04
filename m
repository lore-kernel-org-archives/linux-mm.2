Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E3CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58B96B008A; Fri,  4 Sep 2026 18:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3796B008C; Fri,  4 Sep 2026 18:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C825E6B0092; Fri,  4 Sep 2026 18:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 988676B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:35:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D7A5A3D31
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:35:16 +0000 (UTC)
X-FDA: 85177537032.22.7AC1F98
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6461C1A0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:35:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OM83EIbe;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VK0eX8bh;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788561313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NS3IWLMNep/DrvoibIPUp7dIa6zL29X7BYhj1p+bdp0=;
	b=jcBL5uMSd5yqmnxe0281Aje63OBHljNBnmOcgp7IMu6RfJI+Db4hfm0iqlgoCa0W9jWiHS
	IAhQ7tF4ujvA5EeoriGQPmzRsTKtidbfaAw9uHY5Afc0qJ+RmtoF3G3pZTtA1hVkaJadV5
	Ivv5Iittv4BMl+3bxKiVizgjZbUHccE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788561313;
	b=fQZCmGGTqoUTCZjqvyNDraaw4wbQ869XxFGu47cWK7WJUglVWG12jem6BkqX3upTmf50vj
	bOsm+fQwZriMBxmsuLHKoMDjVpzs/kPfJm2sFMoyxHL2aXokQ+hV3AHvwGHrpPfPFIWrIm
	2sPFUBw9fjYbLM1AvyH/7d4tWFccQCk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OM83EIbe;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VK0eX8bh;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684MWkmq3078192
	for <linux-mm@kvack.org>; Fri, 4 Sep 2026 18:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=NS3I
	WLMNep/DrvoibIPUp7dIa6zL29X7BYhj1p+bdp0=; b=OM83EIbeyrJBmKFxiBn7
	95BjxB368qVNGNObkjZ85O1d248QOiUYlzhhJJep+Gt6Hi2B8Fzo7oVG64eJc/tj
	zbc2s9qp5g61Kxn9jIQmS3ffGdAlGQCLFIZHun44tpLrXKQNNfvb8FNBH5XRYio2
	Z0cVo9Dhz5NYwVILy/CkqWJ4AHXPq0IB3wvtxsLVRMEl30S7UHiN5mLrnAZYCkPg
	El3m/66187L/MxMuSPzMn+/WT6GRdkqqrMx3xhVwRJ1iy26arqEVzNfdiHL4NoDp
	xnLYfSKwSetCrD1jSwhPGIAgpUmWjZfBSh9+fhBno0Kz/ApUcGuNj1MCJ7bpAC3u
	VQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gfyvkuqbh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 04 Sep 2026 18:35:12 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93494cce712so273380685a.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788561311; x=1789166111; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NS3IWLMNep/DrvoibIPUp7dIa6zL29X7BYhj1p+bdp0=;
        b=VK0eX8bhtfh2SndFD2S7uLIhe97zD9CJLPIG6xLa+H6a84TYTWbUlCqx3YFGBNe6Rr
         5MXGJ2Rrgk4coVXPK/kIQhVDjkV9YsnlrbZM8uPzPbkalLG2WD7prNv63yTtevKyq5hL
         lCQWru0KuFXflZNFedjYctn/DA58ZJT1TLfNdfX9kNA357q9zPlyvDjjeuE/HPghDQFZ
         v5wj+jp/MpSIQatmS58Y+HVta31/XU2xuVIgNEHqzcF3Z98/mj1gYJE7XAaBHnMxkNdd
         mnwiPJ4la0q2K1YwJttgeoSrlBTmaUdbNKELl+P+qfm33dT0Nq3bvyTQHXxw3DrL64gv
         9mMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788561311; x=1789166111;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NS3IWLMNep/DrvoibIPUp7dIa6zL29X7BYhj1p+bdp0=;
        b=QU+Al7+H0ATIR7+0JyCxRgC6tmL0HCLiKFXYTz6XJx4SD0G3mnIVf525WpNRPlkKCj
         A8M3XNUs+lVsj8N3EzWZpdxQPp51xXW96HG5kgJ0twheYLK0zEOLEmNHB1H7tfkkcrlp
         y+8HVJLa+hvm9scS880Inl8v6dkpWlfwrHecPJEBsPv9LQOjoKotYzgN3YzDEZm0ObjD
         vXu8JXm80wKGLs1EvEfUQsmPxgnnUJYzMOCeB8b8iFoVDRXAxLzTNPXCFHmRt/WBZNS7
         0Aiu9/5jI2rr4gdPd8lPD4AOktF4nx4kKiWGa9RofA2asaTGBZ8Str8OqbFk3K1LkHFD
         FflA==
X-Forwarded-Encrypted: i=1; AKwUvBwe/iJg/zB+AIvVl68fC5xiyhyNv3vygxwuMxQMjIeE1PZxlsTrEZM88okuh6e3R+N+jBAnzM0N2g==@kvack.org
X-Gm-Message-State: AFuF++lGYLwZmiV9Q/6+3TVCksbmVf/kd6pv4wFsYt/90S35aP1s3RcB
	7U7/KtGpAVQCrIJ7MHa1m/fcg939UdpfcJgZ8/HWtnAky3nftayTFmgFF+xbnHNO65Fc0spcdMJ
	Emz4r47SSS23O1sW9SrKQTBIyagCrr+oaZampjJ3qqXjBktr5
X-Gm-Gg: AYBFou0rkMAg7WEvuUY6x5iSRU0r0gLz7jPNzE6hxGEMo9lfiOlLzizk2gvWBVINqPI
	lRCFrWN3tM2EQtuv9CgwcIw4vJoCudHnRL0q9MSUzXsGxirL+YRhjU5x42zes6bDM5u1VbtUyL2
	KrnDU4fsl1Z8DfxQBqW9yZe051nXilN1u9TV6v5s8fMklJwvkRgmOs885suqMzYn2H6Y5X3+bPb
	ggSxw03Gg++G6/ZMEAeom4Q5V0M0bEbMDPmND0b2SzA3d/nrMuHN9zvbp/Sg+odxqmZW4ONptRO
	QjGyLfuXhrewXBcL5veO4BGcxpJlVLfqZIZfyxTn7XSIOFcpRvcbMsc1W5tD/BpNZy8hEDbjxEO
	7aQf7rJ7T0k3k6K7BGu94UivjwLWhsiEPD+i6+I/Yun8R0xvkJ9WA
X-Received: by 2002:a05:620a:44c3:b0:939:8905:ce9b with SMTP id af79cd13be357-9398905d927mr531684885a.17.1788561310791;
        Fri, 04 Sep 2026 15:35:10 -0700 (PDT)
X-Received: by 2002:a05:620a:44c3:b0:939:8905:ce9b with SMTP id af79cd13be357-9398905d927mr531679985a.17.1788561310278;
        Fri, 04 Sep 2026 15:35:10 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-158.net.columbia.edu. [128.59.177.158])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040664be1sm31193686d6.18.2026.09.04.15.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 15:35:09 -0700 (PDT)
Message-ID: <789e5449-fc8b-4ef4-9571-26abd514681b@columbia.edu>
Date: Fri, 4 Sep 2026 18:35:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] f2fs: complete dropbehind write bios in task
 context
To: Wenjie Qi <qwjhust@gmail.com>, jaegeuk@kernel.org, chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        hch@lst.de, jack@suse.cz, axboe@kernel.dk, baohua@kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, qiwenjie@xiaomi.com
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
 <c4e69fb1ffd6c6fd968683c690ba29f2b98c9fa8.1788438786.git.qiwenjie@xiaomi.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <c4e69fb1ffd6c6fd968683c690ba29f2b98c9fa8.1788438786.git.qiwenjie@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDIwOSBTYWx0ZWRfX5f/qxMg8zozR
 pD+Ny/ZRsWAD4VoKSfsXnMKrMsAYXZZ/USvk2bzjB+UsxfnFIjpPiocsBt9Q2izKR1iv26oKVcp
 HsII84bJAmEuk1gBb7LSgTRmIbqhBNsO5HsYcP+F8ShyLzszRyFTM5tV8i6uL9/Si1eSDSPFG6P
 6H/ssyVAwhwB0qscxTrUflNbOe16Fk73LYWmQFQemWlObs93MJJgDBLTHJY/JRTv3kWthi0xIBg
 S8nOByQXvqAg8qWbQDmFZWu5uOxIeqa95lnIpgMInuFDfB2fpTxXB193s/Pgo082zApgOHqmAUi
 JBQGvbMYWA2b30aaNO9ScungKOtVRyy9pTYB35k51+gKv5f6zg/58L40+vboxoUpFhqMqRG3VKh
 OhIvs2knhmUcKlPQkbVPlHokDCh2vvoe/yt6Joi5pUPDn0RLpX6rb2KbV5I9bZN+Bqh9oUTt6KP
 BjtFooDwNlgK5NEtfNw==
X-Proofpoint-GUID: UMHRWz16AAWo73OWgrDUEHWJ4o0Gl_w9
X-Authority-Analysis: v=2.4 cv=T868ifKQ c=1 sm=1 tr=0 ts=6a9b47a0 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=tLges04aSNaZGVAfhBIy2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=IeNN-m2dAAAA:8 a=r4jUT_wghbJ-rGNBW1sA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDIwOSBTYWx0ZWRfX7lsanUyG4lRE
 nf+nORx1Ly/v6pSHkfvs6RwM8QaezZnF07ykCUFiYldFv4xnj54EUOgvBzUvrPYAUcO9gmGDY2V
 zfKssQGWQ37TSO+/5UEDDBUS2cdCTfQ7Khj7mnvdE9SNnmBxlwPT
X-Proofpoint-ORIG-GUID: UMHRWz16AAWo73OWgrDUEHWJ4o0Gl_w9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11896
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 adultscore=0 lowpriorityscore=10 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609040209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6461C1A0006
X-Stat-Signature: qa47i9nxud4duoiktpfhjjtzobx8rzqa
X-HE-Tag: 1788561313-893267
X-HE-Meta: U2FsdGVkX19xLk+gqrz272ezWNcReUGU/A9vpSCoNBoN7l9hxs7vr+R8zPhLRHu4fx7fY/DDRO3zUX7stTBJ3+ZBKReTbiTQdBwh0Xl3nOw8VMOsdXqPno2e0XXHDtL6avjKyVTftImzc4kUgYpvs101sJUzC2hQLzpwHO3EltsLyX/C11K6RZTaScujtypNmZJ2J06nBOdRN/d9Lq3h/HyUhOoFixfp0kqfp56Iut7eCGGrIYlcdEsT+erL05qBb3mA5lvUCM3ApBCbKvs3ssA8jigf/m6WG36N3msil1L6eD9SniJAVtA2gTbxA6HBTW7QCpeWY+jfbyhnxm3bx6uSfJ4Aq1DPZNwx+OrVFcpiivgTTLWDxTrWShaDNXget4z6rHyB7kSM9a001QX/W5CkI4w7QwsB3AX4jstJSF7mykMWmENvZQKuqI+LQblrrIo5a1VEbeL0gpWY3LeqJiRMcNYGICPSDBdlriN/d8A6YyjP+9fzC5Mmw1l1rOfBFZuG9Qgzlr//zB1jwibHc3z2WOU7HHFFx2XQltilxbpDHLQmaMnHOf0v/+kSfZKvONgAj0El0ivUNpNfwIdsp0v7pgeFhcEha8o1cT9Xqfw+5I7559jxA+PW+XhgYPqmTsGC4K1ehr7zshiJfHbUKvDTaodWU7o5iQKyNjImQXVvZGWSaT03WgIwpLtrMF6wS/KzbJJiowfySeXZkXVWh7XBsSRsLcsIs0BNJSRYr4kyCxuD8rCLOXVO1EmrfcsTfi508aNEOu2updBFILnIHRUMXoIaeVak8YzGGjvR9NsG+3oH1kGoVQAQa11tF6n18RgVF5a6pjfjR1gU44S26ikkAQrEkqvUmKt3cwPDKLOhzJMOYkHTB+YamRlLsH5gVQRNtJqgtTvA00KOSgxnimqPDpOyb43i75uCdJbTYTq9WvDHW6goIh9qxX3hgvwLFrt2i65Sq50suaRD6sY
 GdilehnO
 cj1TaOoMpAIgVcBHXy632zf2dAAMW4xTF7dHiOaGtY5Q7opWIeJpXf4xh7ye8pFoGmxzO52ke1qL3ZUqcwL0xmB1/OXSiIOv8up740rK/QMrtQtDqCaY7Domw93HxYZzpXVgiF5JbfGCLlogM17PP4hOA4M41S7n+j86dHMQjphOdq5H6qV37REvJ1/23frJvsJxRxH82djgfgzmGKeVEwatBOr6+B8fw3O1Hr5weTRU+CaHBn31taC1fbpyO2VufBHgLNF6qswa/eg6uhxYDac0XCJEV/ZuCc7g9B3PIdkPOPlO0UKC6FomJfSau440nyUvPHi8CIhsSX6cJ6P2bkFFwncLK8jxmYVdi1QZbSieRv2oK8BoONqWVwgKJGfsBwjunQc4/Ctm4UvBwgwPHYmzUvHBvpTnFkgp6HF7c+5QzrhwyMywgJxr8Q/bLCgJK68fu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 3:59 PM, Wenjie Qi wrote:
> Buffered RWF_DONTCACHE writes invalidate dropbehind folios at writeback
> completion. Mark these bios BIO_COMPLETE_IN_TASK so the block layer runs
> F2FS completion in task context when needed.
> 
> Use the same flag to keep normal and dropbehind folios from merging in the
> IPU and OPU paths. Classify the original page-cache folio rather than an
> encrypted or compressed replacement folio.
> 
> Keep the existing large-ATC completion path unchanged.
> 
> Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> ---
>   fs/f2fs/data.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 21f396ebe22..b0fedacfd12 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -503,6 +503,8 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
>   	bio = bio_alloc_bioset(bdev, npages,
>   				fio->op | fio->op_flags | f2fs_io_flags(fio),
>   				GFP_NOIO, &f2fs_bioset);
> +	if (!is_read_io(fio->op) && folio_test_dropbehind(fio->folio))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>   	bio->bi_iter.bi_sector = sector;
>   	if (is_read_io(fio->op)) {
>   		bio->bi_end_io = f2fs_read_end_io;
> @@ -793,6 +795,13 @@ static bool page_is_mergeable(struct f2fs_sb_info *sbi, struct bio *bio,
>   	return bio->bi_bdev == f2fs_target_device(sbi, cur_blkaddr, NULL);
>   }
>   
> +static bool f2fs_bio_dropbehind_mergeable(struct bio *bio,
> +					  struct f2fs_io_info *fio)
> +{
> +	return bio_flagged(bio, BIO_COMPLETE_IN_TASK) ==
> +		folio_test_dropbehind(fio->folio);
> +}
> +

So I'm admittedly not very familiar with f2fs, but why is it necessary
to prevent merging here? For iomap, we concluded that merging was fine,
as it just results in some extra folios getting resolved in task context
(see commit efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind
writeback")).

>   static bool io_type_is_mergeable(struct f2fs_bio_info *io,
>   						struct f2fs_io_info *fio)
>   {
> @@ -985,8 +994,10 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
>   
>   	trace_f2fs_submit_folio_bio(data_folio, fio);
>   
> -	if (bio && !page_is_mergeable(fio->sbi, bio, *fio->last_block,
> -						fio->new_blkaddr))
> +	if (bio &&
> +	    (!page_is_mergeable(fio->sbi, bio, *fio->last_block,
> +				fio->new_blkaddr) ||
> +	     !f2fs_bio_dropbehind_mergeable(bio, fio)))
>   		f2fs_submit_merged_ipu_write(fio->sbi, &bio, NULL);
>   alloc_new:
>   	if (!bio) {
> @@ -1086,7 +1097,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
>   	    (!io_is_mergeable(sbi, io->bio, io, fio, io->last_block_in_bio,
>   			      fio->new_blkaddr) ||
>   	     !f2fs_crypt_mergeable_bio(io->bio, fio_inode(fio),
> -				bio_folio->index, fio)))
> +				bio_folio->index, fio) ||
> +	     !f2fs_bio_dropbehind_mergeable(io->bio, fio)))
>   		__submit_merged_bio(io);
>   alloc_new:
>   	if (io->bio == NULL) {
> -- 
> 2.43.0
> 


