Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF8EC61DD9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 15:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BB86B0088; Sat, 29 Aug 2026 11:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D966B008A; Sat, 29 Aug 2026 11:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114FA6B008C; Sat, 29 Aug 2026 11:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4C1C6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:26:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 438D6A2ADB
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:26:02 +0000 (UTC)
X-FDA: 85154682564.29.0AB361F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8BDD2A000B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:25:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Gu2zFIuG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VkFm5na0;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788017159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
	b=dMN9Mk1iaj1rn25XBfS2wtzr0ztsga7vTTIEjfKfWho89mROVOFH/4MAyOuPOdZMkR2WjP
	TpLhtdCxNeHYinaAhbWLCmaL445XEpMt4N4dQ1Day39g+lTFAXKFGrzef/sUcEBDNQjQRG
	4IP7QMcAdU+/WpTCIFfpYfrwXZDffqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788017159;
	b=znjuJTpKgve468VxJhjC4DNpYFPimV+rsS/KBHMHS3B6/ZQjfzgXC8YfsFMAl0vDn6nI9I
	1SXKJuAGBs0o9r7+qy04nzBzvHItI1cKtfxfP/G9eNPciZ15J6tdJcy694nodlwh+OB2CF
	y9JpuIrnUG5LiIRz9zWUXVtxAfgEhBk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Gu2zFIuG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VkFm5na0;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TEbYw91444508
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TFVW
	lDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=; b=Gu2zFIuGUDCk+rJ2VDBk
	70a9GXKIRmd3CKMeiyckWv/D5MP7Zgaj/CA+sovdSkrETK1IrJb2qFnGnQEaNT3S
	N9KtoDtS2aWLMgdaZS8EG79pcfDMQu06yKTxqcmPhJVJAftER9ykGtp1pbja1UeX
	kUFeO1YwKQdpDr1sZdsz5l4M5OOqmQkrZTmdrHduJ4FxpamhWS1IQq9E37/oh+3q
	nZtzyUcZ5SRVAnnPNjuAJxQT4FXqYOGakyKLjlrLX5KwZ+Imu1kdoq89hPFZ5bjm
	jEkOlYV+J6fGeVEAdtwq+7wZe5VJJ9mAqHAPx4qs90lyy6hcLcj/IAjQH5/0tLN2
	0w==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbqy7a8b6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:25:58 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90c8cb9f37eso21475946d6.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788017158; x=1788621958; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=VkFm5na0WNP0LPKNuN2sszcPhSsLZodgzviBDLmP5vZ3zvjpCl7naMNe460CZ8DFze
         gicpvo5xukausiCqk7HRMpmBvVT+AMNY31H2xvGRZ98Lkp5JbmssJcubu+sL9+s2K8qP
         bEqgiZqmv4QZ2n9Gv9Mj4vj5yyzHr3f7g44Ao/yKIfX+749eg3miNA+wcoPjKy7JBkzv
         X3ZuFS3kdheAXRbYC53Li5YULmLlWg2O6FOkzipqsnhc1T9fo0dYdbD4UftEiodArv9Q
         Bm7srYDSOeI2xO0oJefzatwxuXLHXVAe5leN9fCh9xSby2ep7RYhaQ4jF3AdIUjBPuW+
         GBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788017158; x=1788621958;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=ME0vxZoDC29tWdk5VLITflPuSLt4JkcmRsXagPA9N1/ybfg5fBmKawiVfEO19+/9qT
         gIJvFqeQi9nqta+joaJnURYvmiukqHnsRDKjwuDIgG5N+O9aSiXMVSFhFg2IBLY2gH9d
         nv2hvHMESNhbw9MC7jnyCezh58TW1CGOfoz4hbfHIcK41TUnhDqb7+DUsMlBpMuPLxXp
         RaF8CJYoYfZZUdvJuT3/92NezmXr/czgH1UvOLsBBDRVDuAXm8nxXiN6r8FBBCoTkN+c
         QfPGml5I9DqBPgho/hBqk4kMTjuAIE8URK58TxMK8CfG0ERLPNCVY+PjLMxdUk/QrfQd
         WggA==
X-Forwarded-Encrypted: i=1; AHgh+RrR968Eromfz0LwhjhunKXqc7TNOF48Pdjf1cj6fQQyqSW5cO/FrggrRqCERd66xM+cdsXd8+VU1Q==@kvack.org
X-Gm-Message-State: AFuF++kIgi2hbQKj7XyVvnmUsA8lcz4aM1efoTQQWb7FtNxR0PWrl0go
	trTsFMSBUiSNvfEJmyz82z9ll3PFLuQlL92eHa8wMcE3Q4hel+3ADZ2LcZgtuYAXPB0V5LLb0Qu
	spG3bbxMPMvBxl/5wkp67WFUUtjxAPorIwyZuzJULrzU9lKJ/
X-Gm-Gg: AR+sD11CQF/jPjdPG58wDG85+khGQIvvudoiN4NNaYY1KfMmzHqSfbu0XuxzVdMhx1g
	0/ub6VEWzgJWcLr2vOfg8e4xss8euZGrL1xNILkXrxglymaKs/G5jRZRCFbWh6LyDbR/oNBUh4Q
	5/ckNDFE40062WVOvl6fbL7M/oHKAkHwLypXIOUjCCOWeaa5+ykpJOP7KKeAVvYNSDRRQV79F33
	lfrkpEWDtgkuKEYZxNzqhFku9Trocb2q28/Dcd/zYNmkM93M9lNe6nUrKQm9zaXE7b2JDO9DBg+
	iSnLJMpNCJVd+99E1feZigtXraT1CyYAnkaz5YzBJpqA/Qna9hOkVlKsYhPwhkhwTeqE4roPzuD
	pAIhRd4sOMy+sQVrvoxbhp1YWLf/RAnmGT/yah8XnqXNfMuo=
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173116541cf.20.1788017157666;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173115921cf.20.1788017157157;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
Received: from [192.168.0.175] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca1ed292sm84339685e9.8.2026.08.29.08.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 08:25:56 -0700 (PDT)
Message-ID: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
Date: Sat, 29 Aug 2026 18:25:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
To: Barry Song <baohua@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
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
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
 <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfX9UqypJIxUYc1
 HbyT2W+u84Cp7b5hh3xyhG6wD3byMOF4injd6XvqhqLdGmZSn3C6WKs650ZnFJsSbmwAmp8tgXW
 UlwKNdFYD7pGsIU9t7P5KZ4Qh2YDOIfTZGJeiQIIeaFFe4FflwvA
X-Authority-Analysis: v=2.4 cv=e+I2j6p/ c=1 sm=1 tr=0 ts=6a92fa06 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bN2RZfqcuyHWyQBaeeoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: suznue0R8lwMdrhQfEYzjChHaAU_LMcj
X-Proofpoint-GUID: suznue0R8lwMdrhQfEYzjChHaAU_LMcj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfX1sk0FRzYuXkr
 LNgPQI5Hbc7jG53NOYhAhrrSd9q7ABscPfhzVU2Kc7zDj70egAoCgTWnF3QwSnFt9W8OMrOVJ3d
 fUzObByF3ViakLcukHtmQw2JXHu7JBzOPILfjUMGwyBV9z9ZwIqx/gKXoTetvMBHT7X0zRwdmhT
 1WmUU+rjRjSz8XhrKPGxTI2aNrMMHzwyzy2G16LZEki38nvAxzhbErKyv5wIQy2Wxx4EHpdfY+y
 ZKXB+KR6RFVLTcfISrLn6Z67JdjxIH8EdVU9de0AKbML9flgHsS08A0QVUV51bbK5Uh2++6jlNr
 dQPc9qu3xrq48gPL6UT4zkk78ni88dZuL+vXVo0h1DuOoRKJFGsUya6BsOVKkbtCtZgXb2waWLs
 DdPZugG2QW4nDRwwVuHQK7BGYda10N7jJvzy/oO8YqIiqyvplqVHPdOJJF3VWs3c1b/aX8upi8z
 DVyL74Pd5yoPtpZ/Fiw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 bulkscore=10 phishscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290133
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8BDD2A000B
X-Stat-Signature: o3ofp49sskb79ykp58brziuj1ods1ikh
X-HE-Tag: 1788017159-335765
X-HE-Meta: U2FsdGVkX1/lJY83wkS630M5K4RgPpmfGpm/58TiLClXtE3DIEGs29uMsdaeHspPJ6pDY5UMLjIQ1XxuZ9fkSPINYwxi0AbUISryIecvDxcXRXxtQX9mqNbma8z7O5VIewznzoXexOmOXWrwL9CoNJ3361F2cfYu2eG/2HX+Lz7kKwv58gqjnaNiaH448eHkvAcThR8a/dodcm+RJmqZeDGpnJWYmeG1cYHaFZQKYiQ65gLfh8UZXROcQ3Pm8SuvXeqa5sUMm2so32zUfn3GdUg+92qwRQCzLsrI70MlA7q7a45gvI9KT83MkyJDCxv4/4Y6z6GQCNQjV5o4lu+anAssvTYRhGYNssU2DKzsC/6i5fU3QqAzMheLndMowRiB5CQz74+0Gn5Q0iXC2/Ryzol9IyLAuGhDoRs9pKqB+KvjUAlHUtBMcEzRBgsVNWkjNqTy1MmEOk4NPVsNW1Q0mejK/fM3vzE//By02nqJv4YyTs3Hcz14wddcMxnoN6ml2rcdS52YzPbevEttKUT+B2kISGMKYn6jZkzjNfMdxpl+BdvDTd97E9SKdCIJBmt5dxJaz32Y0KxMz7FfxJwpVH+uqDrnF6BSBUPPJBisMcofYPWU//t5DCqocQIIY3QJd8paJPxWlCgplI8nZZr1PtGdXCbMEYMfVwtxiHZkWmW3Fltf0iNUnODCeaxwVOuSp8WQz20WDbqlzXnyvFBNycMwCoDmbnQ05paE9382JxJi26R7MerVeNUVyxe4CqXdW91jizdsGQcbaayTrjvqE4hjXQwQ7Or0Virk9LK74wxzERNTAPwHTZgegerM4JgSjTH6hBvGgaAVzURTEqj38ygbZHY0O8gFCyuyuRejFxcsdDbrAQu8FYm5rV+6z4LTdaqijFgoo1rIpWYOYVnMNUwPGW9vQzHkyo+ypnCIccW/wtMP0hSEYG3KWb7MBJW/2z6gOtLgqyDINJtoPi+
 uzvu+XVZ
 8Cy7qcaG5zRgdw97lowezAtOobB6mMziaXyVT+Jm36MF2B56XTEtC8aACcUVPrtbUJp5tslT+P9O5qC4qzK71wVXe0DMBg6zhTJiuzOle9hA5mKPTJhRl+PnCp0WFhin+C0Yz2EgLVGKUkkT5Qu8S8kp2efIcWZlGr8U4FBIs55oxyMAOc67FB/MboUU+0M0qo4dE0vXyXmGCje4C1aK+fedcEpFBBvaGDLIx4H3mt1/87LKrMY2Y3YApHnJEtSHa9uG2OM3M9fK26C8DaSMB+KFgKFhK2dxFqCyLdB9fHlQE0PHVyXSzbDRebj8jjvolHGHi1n6izUWF9e2jFbWqHzEOsWSuX9Cp/jkTIWVhYkNci8XTnLFWSll9PH8bDjT3Q0R8Gx0RFOmrofkM/aG7bM/AKOLz1i1YInT3gZqgDUJM8g4o0ff5CDI6awwW121tbaTPMyfz6siBs5K8cnYgkAs21StQPSLDRO0nyFwBsIh+V0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/26 7:11 AM, Barry Song wrote:
> Hi Tal,
> 
> Thanks very much for the patch. I’m just a bit confused that
> folio_end_dropbehind() only requires in_task(), and nothing more.
> 
> void folio_end_dropbehind(struct folio *folio)
> {
>          if (!folio_test_dropbehind(folio))
>                  return;
> 
>          /*
>           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
>           * but can happen if normal writeback just happens to find dirty folios
>           * that were created as part of uncached writeback, and that writeback
>           * would otherwise not need non-IRQ handling. Just skip the
>           * invalidation in that case.
>           */
>          if (in_task() && folio_trylock(folio)) {
>                  filemap_end_dropbehind(folio);
>                  folio_unlock(folio);
>          }
> }
> 
> But we’re applying a much stricter check with bio_in_atomic():
> 
> +static inline bool bio_in_atomic(void)
> +{
> +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +           return true;
> +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +           return true;
> +      return !preemptible();
> +}
> 
> I feel like something may be missing either in
> folio_end_dropbehind() itself or somewhere in the
> filesystem/block-device path.
> 
> Do you know why they don’t match each other?
> 
> Best Regards
> Barry
> 

Hi Barry,

Apologies for the delay.

As far as I can tell, the in_task() in folio_end_dropbehind() wasn't meant
to be a generic test for if it's safe to sleep, but rather filtered out the
known unsafe case of buffer_head writeback completing from IRQ context.
In contrast, the bio_in_atomic() check needs to be stricter since the bi_end_io()
callbacks could sleep or the callers could be holding locks, RCU, etc.

I see there's some more discussion about this at [1], but I suspect there are
other instances that are (incorrectly) using in_task() as a proxy for being able
to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it).

Additionally, it probably only makes sense to use bio_in_atomic() when there's
some deferral path, since with CONFIG_PREEMPT_COUNT=n, it'll always return true.

Thanks,
Tal

[1]: https://lore.kernel.org/linux-fsdevel/20260829121335.3491374-1-qwjhust@gmail.com/T/

