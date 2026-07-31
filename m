Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8976CC55171
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 23:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCDD6B0088; Fri, 31 Jul 2026 19:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395126B008A; Fri, 31 Jul 2026 19:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D756B008C; Fri, 31 Jul 2026 19:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9D016B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:55:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73EB91A01D1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:55:45 +0000 (UTC)
X-FDA: 85050731850.14.E6978AB
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C643D1C000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:55:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Uo15toe0;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785542143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPIAGymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=;
	b=V2Ic7NK9gWVJf8vdJeYw/HtPQkEB6xXC7Eu6vFgr4hgE9/RcMwgy8hF5GzmphN0bDbqcXo
	uj0VxtkspxZar4FZPOjvqq7f9EPCkSmJgKP5Rqr6Jw8ko45tDPLlcg8dLKEVGUBT3bFssK
	sE9nDGIqWi1PsXUqqpKRfXWj+KS1yJQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Uo15toe0;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785542143;
	b=5CWscfnkMdy9MyiWmT/2QA6Fw/VVJmdQynhnBa+Xn+4quPp2zcdq9rA/hHor14Yc6uW9Cw
	osGDqBR5Xl2GtgGPoni7qbo0X8K5Hg1t3JV0j61y41NYpV21hgTPZ3+Wc1eINr2j3hOeLw
	HfMhtF39LuTwqPWbbunuJpucX+Ox+CE=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VMcE3Z2967728
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KPIA
	GymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=; b=Uo15toe0rPDAPWwZwVeJ
	n4E2aKPhzCtlbJaIPoOEk9oRKi29yWUd6bKSiKw2/UEDTT8IEoVnM0DWGZyllyTD
	40GpyfJ7ynehv56/EO+/jPUwA4CByxejxRy47r6xIde4zro2qbznQsk1f3dywHQu
	wWe/OeeuDrb/CAZQvA482658TGeu20X/PI6Kw1A+xglVLpQoL80+fmUhRsCQSdex
	hBfukncjUKNjTuWp4rZ1AdX9RDFeDZK1825QXT+td5WsnXaq10PJ+COGZwtnliH8
	5iqQ8kshUmIgCn4Ssedi1QZ6CFkegXN0zS0YJNWRRYNyK7IbH/AyMNUtzTFSMG47
	Gg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fs05pt32r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:55:41 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c083f1818so15161721cf.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785542140; x=1786146940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPIAGymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=;
        b=drD732pN4u2ciVoN07pl9YHweiPYk2RNSu0ioN+0gS+loNNPMOeYoY3oWh2h9i+OHK
         MSP89GfQJ6geYqvrLc+jQccz+5tNLVPQJFufwmvidlu41TEQRG3oRV78dQeeprsuTazc
         Exbw/AL8ulT5ZZSxalaNRVD00r4aTztcABttiqnL7dQOqgRvqWYCx90QLT3lHRG3a7lE
         Q+ahy7ndyWjQuV4hPdNz7YczEZ/bAZiH7YiomxRVAx72JMN7oRxG0b+kDeCN+H4/yMhd
         dRXNIKn+s4E9Pm+fSwFA9udAXolloqoEXSvSyfDfn6dq9vLpw4+a94TerXeJrM+OtOOa
         Le5w==
X-Forwarded-Encrypted: i=1; AHgh+Rrf2NdtjrNuh95GdDFbdkfMu9LOdwFH93xiSwQpD6I62lTe8HlrM17B6OovSbeW/dwU/IOf3rvHng==@kvack.org
X-Gm-Message-State: AOJu0YyR5tW+txOdZ4tSl3c260PhlMg/oO0eXs3fkJuOHbV0vZ4z4Udq
	FJWTF/QDnHscFfZwaU7IEfMNRgmyopeOlQxufZZg9b5fK19LaZNg2s2cW3AA0G7t9/+Rm4JnrzK
	PsbDJHNpYKUxHtIg9OUp1nt81KB9oKcm1cev0UCZ7tmq8ALev
X-Gm-Gg: AR+sD12EzYdIZcW8crLNFpJnXwL4xJ93czyBita1x7IEExz2VkUQsGiW1QeWui3XNK6
	AybhkLLNzUtFviCpcjvRSQuM1HtISUfMY5ZQhHpYvr+dhhWrZlJgU4G0Uowgf9MD5gemAh+lNao
	gjams+2QCaNzMhVNSvBvC6y3BQtAekrCl7eb7Rk1jJIlBtpof2zWITNmF8TPxss/Vh28Jnkx0NL
	cGrryZdtlji/GpTqOFicnQMFASW5ZkpQAhLDCVFR4qJ7c9+0LX66vzvJltqBIaUh1vE0LK0/yyH
	DG09+kYvspxZyZw9dtQ8Qi3DFyPGwjXlVY3G8K1/COxs2eRew8kbACepl6Z3u9X1qOJwU2r6s9K
	uw4NowfZxLzcegw==
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464811cf.16.1785542140303;
        Fri, 31 Jul 2026 16:55:40 -0700 (PDT)
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464271cf.16.1785542139795;
        Fri, 31 Jul 2026 16:55:39 -0700 (PDT)
Received: from [10.1.46.221] ([217.192.152.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b8d04fsm6127465e9.3.2026.07.31.16.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 16:55:38 -0700 (PDT)
Message-ID: <adf05cdf-0c73-4cf1-b1f7-9d063c891eaf@columbia.edu>
Date: Sat, 1 Aug 2026 01:55:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale
 <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfX1DeM7QtOoIkI
 T0us3oBL2xXbiJ8o9O5U6h2xI1X9lpPtzEKj+km/cqR4Kjb6J9GsrItgbngge+NKnZ40xM4WMrD
 /MlRZmjaRtboVKPlVHPheEyjr0umFBNzObYh07RBN39n/UsJsHO8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfX19brMFOhE/37
 3RcldkzH6yfSn8R4rmbCaw0pDSOCOTFTljrFyuoaFg6jcmUd5BtU5xsWcNJ+1lMmp9MqRjRCYQ7
 WycGAImrkziR3NoCgAMTodVhsNQLykIbL7dXHrqBQwxpq3aRu5SGDnuIlHepO9NV97L1YoQjiND
 KlFTxvXJL2SswB9RozYcoUrvU7bISjTeWLtnwN9hdNkE9WkwjdBDZ1FZfg2BRjmsnbASN8OU2cw
 hzlN86jDuwo97ZDgDlLW4xBOTtZmVRjGm5zhpFNuNQmGtyJqgcT+tmcToqPGyybXmXe7sKap8Q+
 zgd3R7KKRuxel4iC+8W+s7nKqSbzVLlsoacNLQs3pbFYXF7HaDF4BFPasaBhVF5Df1wcfcmu+0w
 kFoNNvWg+GsvsAZdS5xjXoks5Yhv6c14s46GcfcgAWw02jPsKQPu+2bbbanqVqoktOggH5+k0jZ
 aMzCQ8890DLzmmreJRg==
X-Proofpoint-ORIG-GUID: lxJZKG4hc0_-m8iF-gvWd4sS5diHIw3a
X-Proofpoint-GUID: lxJZKG4hc0_-m8iF-gvWd4sS5diHIw3a
X-Authority-Analysis: v=2.4 cv=FfAHAp+6 c=1 sm=1 tr=0 ts=6a6d35fd cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=NgQitlhRlW+MZLNskBD3Jw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=c92rfblmAAAA:8 a=jDzJYAX_DjbP0Cb_QUIA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11861
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=10 adultscore=0 priorityscore=1501 impostorscore=10
 suspectscore=0 spamscore=0 lowpriorityscore=10 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310177
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C643D1C000A
X-Stat-Signature: fr3i4g4qhz5kiujwzgh13pxpbjfseic5
X-HE-Tag: 1785542142-125572
X-HE-Meta: U2FsdGVkX18ZEe65qV8dyfvbCZ+EDurFRS8Lya7kCDFpFDKQl/INNpfuBgz2V3x9ZzKk8PZJGbed9FK6Y6uWBxVDMnfLwSBykqS4HFPZxFfNs4DVyBXwaHYNsmmDX9y8uys/CwXXSxUPUdqf2eFFdA7eSofBvDLk13gzhFmgsZTUrV1urYbCs1jsgDfPCf2TbZdlf4jaXcKW5MPY1Dfk1A9ETj1HaELe0jHgpDVhPNw+ok27bSQMK6b0V33Z0r0WyrzHkyIxn01RrN2IJQCy0iL+oW+cbif5EShlJGk/C/KJqzYoUHgCE43FIYlcD/hXJfvisz1FWNbFI1i8W/hi60Q0JDPc7DdPm/iK7TzufF0TIL2CJ8DVHLXxRW5eNHjp2MiCA85I7L9qiliioRiLyXgM5NnOiqshSCZy2DoDXlMr1RcoR9zFCIHEqdLxqDe9uKppfmYp/cYQo2kd9aFDdzTjhItJoNKZRih019gslogcQdL3WvL/Nrpx9p+AChTl610VNm775OFFGO7AGmQry8UhOV4knig0mgVJWaYyXXkUdRSEfm4HNnrjNxB89owolQ/JO2t7wGHn6aDWebNWkRXLAOZMQEwx/0PNIGG/tpkgU4vussEXymgr1nWFsDujuahpMnBLOhAJdZlXkwx0LBSdnhsIrXEwr+mpRrlo7NDL2rQJD6jZhFAxkFno7V4SVu5RIM++JOTgdDW2XRNw4v613SfeEWEqKaDiS82UK1aCLdpHY/+TRTQI+hQ43d8QAwWpzudiQLHcqB51c5tEAwcGRBXD2XEvdLmMQdPZdy5wypMB920FvlyoOkBNLViw4UdPiId8d77M0ufJmjQ5KT8SaNhNg6OG4WE8psNYR9e0veS8+GJuR/PrJPBXFQbMTquhEJj1x+hcp+eCyjphHTP5U1MQJeLjvugx1fIMP1IAxFhAXPdjLCQvzvHxp7AOUsoRmzl31xHO3RVbKtz
 D8e+anTl
 Q76aQtQlh02Ow0CmPc3ozH8S5rNYuPItxXd7qJXFIyhWT7zQDaXFuYIYrwhEjW/ulC/lZfylz2Vs/PhDhburhzJ43xcDat6Sb0peIHv0cKXIDp37IF3JPVvi23kidaKLX37/dT0Hvt8drbayP05PY8i1MmCsX57kV0I/lk+23HrcGOV1vC1jHib2+NepT0UEv7EcR+zUekdJCM3d1/xhYQeK+LFjFEmnfTwbMEDUGLuIlBYy2XkGGKQCnOW6rAPPaxRWNxIlUPj+dmAbysLEyK81TG0b18gfw+qxRlBiN0WexOLIhrJ12EADM/dJkwpBTRqndLAe18K8Rb5QLManpRuuiuRfOVK9gpT+qtMGyj7ac46F6+GJb7gTDasXotxLMBAFZeyxl/dIQ0Gkd0VDWD9O0Wu6kGci4Ei9qPOu5REik+fZYrGc0Gs+DKAWIphzSgsUY2iUWJCDPSpn231AY42YdFar4ldb1MRv/qsNqNKp//t8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 2:57 AM, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
> __bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
> CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
> BIO_COMPLETE_IN_TASK on the ioend bio.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/fops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180de..8b39c53b6393 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 

It looks like Sashiko found a couple pre-existing issues in this file [1].
I've reproduced the first and looking into the second. Will send patches
once confirmed.

(FWIW the other issues Sashiko reported seem overblown.)

[1]: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5

