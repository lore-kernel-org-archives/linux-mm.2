Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC637C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271656B0088; Fri,  8 Aug 2025 03:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249806B0098; Fri,  8 Aug 2025 03:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138436B0099; Fri,  8 Aug 2025 03:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 053A86B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:35:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC723C1528
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:35:27 +0000 (UTC)
X-FDA: 83752779894.03.DED0751
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5AAAE1C0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:35:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cfDnQZdy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754638525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGUp02ljgDkColao+b89/BR39VWVDPN8zzvjr1NWowo=;
	b=cdzvKP39snFgndinHduAMaDYOnSQhWb7B1KNn6QD5PlstJB/noam/ncWqpENWlDoUJg8nR
	g0Pz2XGnzCy71M/SDfPf+Sm2pNjrTvCqJgO3CnZ5aZCa7J/9/vR/LbmNP7GYqylCJYbLPN
	6KlIZhir0Uu+lxWQOrPWCIofsSFH4qQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754638525; a=rsa-sha256;
	cv=none;
	b=EagyUdTm8jxTi33P3xlj6yv52BOOtKLZBIcJkfCPtSeUFrGDyXk5AwZulNak/mb3S8s9lJ
	eBPYtk5Z1rNKsjKXeSu3mxZqqmKbJdj5fT6I9xtiV37iaptsN1zlC65g+HFcbBhdb3ZQPS
	gT1/iB8W1I+Z4ohQPZu4+3gFrOXZP84=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cfDnQZdy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754638524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aGUp02ljgDkColao+b89/BR39VWVDPN8zzvjr1NWowo=;
	b=cfDnQZdy0agM3frlv4Gw1chzOMkQtAvRB52Jnwx0a+l9poH70yF33Rh49wBpyw+6+kC9cN
	nUY2y5TPBsoWosLUjFppVhZYfyGwIuoll4D9tHaBhpYgejl7/t/dJ7MaYTCK1U0vhiDO67
	yG27zoBEJyRFckghnXiervVqYT3KbSo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-OomciKvaPLi0Ra3tBc6GVg-1; Fri, 08 Aug 2025 03:35:23 -0400
X-MC-Unique: OomciKvaPLi0Ra3tBc6GVg-1
X-Mimecast-MFC-AGG-ID: OomciKvaPLi0Ra3tBc6GVg_1754638522
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b8d612996cso1189091f8f.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 00:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754638522; x=1755243322;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aGUp02ljgDkColao+b89/BR39VWVDPN8zzvjr1NWowo=;
        b=Ob9UCeFs9u2w2DAJPD3WMTbIaNE8r+HGP4BRoUXDV5tT55lAkoVMcldYBYYz7LhiFo
         i83uSy0GwKGe8Kmn3QE62JhmPKOYbqhXaeNOSGn5/9BKcwjf7PigxlPZl7+pHc4o+Yek
         6SQuVK7NVm2tWxxVI0xYjNeBbocHQ/npEa8dZirwnczeUGgOuyHsomSBBSx3ZoyU3+KD
         fSrXYouDLxavoKV/FvYrx+NokgSRi9GI3CNG5UpQCsveszeQbDmOabDiBAy1YE+tda7i
         wmLNGEFavTABBGDWcQ76K2sNmiMq2t5kuF4NE86IRyo64COG+l0UWaWPvPF8SY/YlsKX
         cXkA==
X-Forwarded-Encrypted: i=1; AJvYcCUSapaZ4sEMeM8EhyWRCrnrR7LHDR06cGVj/7k1vvkeLIeF8ejXp3IWONIVuLuf35ycLPQIiG7zjw==@kvack.org
X-Gm-Message-State: AOJu0YzGzUyL2e2oI6wRQSammecn8mj22qaq31Q6pQDv2/XYVD6Qf6pS
	xt8g5kuX7Lkcm/RTs2YmoGqe5a0C3ExHlWQkhYCm9GPDUEsygOr8m4AcDooS4ttFs1qLKUa78rb
	Oc8KSovTT7BfBYgz8TSFBc1wm9jIaNVmlIL/njBHasopUH7pGhqyN
X-Gm-Gg: ASbGncvtXpSIA/2A2FT+oSV+4RLnPEdo9KT85HtgsYD3ga5bJCH49BChVFuRfDk7eW6
	tfy/t7Rs3XCBfSC1XKuuOaxsXg6N6NwpmluGbo1PMlWqBz9SzUlM1WROstvqYv6mhTD8GIGdmFK
	ptxmi2rtfCzMSSSaOBD5nA5VDBuHxgJ7a2mzwk5OfxAxmusleWb3KxVtXVZMe6v6Wf2aUv4zaDl
	3lqy0xhHJ+uRk6OCArgDJiY9Jiy0FP3hOIqPTfEpJTHRSfPxFCH1wo5O0sJjk6sAKp3ao+rMhlU
	DLcoRhLpWluCFfqlAbbBmfDvPnjndjLKeu8iCvPCLYXG/V0srGLbUDiLdLinLUhfuwGS3wc=
X-Received: by 2002:a05:6000:420a:b0:3b7:942c:5447 with SMTP id ffacd0b85a97d-3b900b80ffcmr1589209f8f.55.1754638521933;
        Fri, 08 Aug 2025 00:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUob1TxDp76fFmSgnDhx3VPz8XsypW4lOhMZeFT8ap01Q6k+aSGDNiJmcvI1+jkiC80gkcQg==
X-Received: by 2002:a05:6000:420a:b0:3b7:942c:5447 with SMTP id ffacd0b85a97d-3b900b80ffcmr1589178f8f.55.1754638521452;
        Fri, 08 Aug 2025 00:35:21 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a580.dip0.t-ipconnect.de. [87.161.165.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf93dsm29343830f8f.27.2025.08.08.00.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 00:35:21 -0700 (PDT)
Message-ID: <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
Date: Fri, 8 Aug 2025 09:35:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
To: Qingshuang Fu <fffsqian@163.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20250808072106.153449-1-fffsqian@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250808072106.153449-1-fffsqian@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TjsK4M946q8dEtRWBz0iAd7zxhAx-9VaEDBIc6WM4hU_1754638522
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4rrkbnd446o6dgyt37zccsxjrsh9cbfx
X-Rspamd-Queue-Id: 5AAAE1C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754638525-965406
X-HE-Meta: U2FsdGVkX18xVepRCxk+4O5SmA/UGc8lyJNnxxmlbWOmyJkxYhBQB2C1o0n7kouUuHEbeVfVlQtOqyfY4SR8Q8w8Sqwcz3HnGxZDv7VqY9I55/DHGOnClLVffNzux/0Ls111TuABjn2rHXD9G4CbahIYnukyAWAxjIT6/ujHOhHWsQn/jRajmcPzkh+9TfXbqdtBRda7xxJWHqIUDd1Qqi/T84bqHmEY+QEjiXx+GQWtfrwQcy6LLcZF9eZLtxBmiMv7D5SGN6VQvGsts68x4j/NORBksLsoIJC+7FYrI+FmSfDTgeWlgv587v+T5nJQAasT+Rtg7OdEfw8t+ZSK5jJoJJSybGRY9Kjo5lyYBTu4z1pajqp22NxKrA2hGYwtqPm04ek3ppXYxE0mme41Ar5R+VT+Wncj6Pm6X57vqGDzff8G7N3pn44c7J1yAwWtX7N7qe2xacsF8L/eWSN84ZUTNVINcWkUgv65iPDDS/5FI17QgblkypgvXp7KRtjBgtM3yMQ7CKu0c2j/vDV511mxxmqCqtyc59eTGKzLNSp0Ntvol6hkSXS/g87hklAY6JWsS+KUoG6pdYaYdJgZmp+BB6AifIph94+hAIVGJB1X1FRCjexOAU611cc3rJl7MFg18iCSHoGNWuB/wW1Vza60klRzEnO3OpipzCKOoZMIpsQkPDwjG9Ns4X6WFxYkrNdJeL2H/MGzupq0P0yuZBtwDYh8HrR7IbOoW63QRxi9Mfs0Zx9PvrTKVYy7mRejRAImx0i+qY8+nb9rrbQhoFkxjEUexGw4cgVw2MEdUvD/NGPvqy4Z/hAiYCSVpQvDcRKTEjBaJWxq2Pyag8SVQc5MobwltiBZFC/FUZoMwBjX3+5EQR7Sgp4flg/gbX606wcoJKAuHuM9UYRbrfCaZ+09JLIXMKfhJzgDB+nnGc4x4WLVi29tKTDMUTjouNcDG9vSO2VSxaagcJGaEk5
 +D/hgm0n
 2Y1ILV2NNs7XhZYG5d72ii+jGWgU3Es4xs2WY9K28SZZsP+3bePyHyGKuIQ2riRcKHscjwyJOipFFU+o9NDSEeWqywRFxG50gWcty8UhKVTEcoudCL33+qVLxP3V1T235l9LJF4VVVFOP1AdRCuAdUi0qVlIDsDJc87f6A7aK3bfj7RoFc0gWYwp6mZTezSO5ObGdtMSEbZcAAF4lp6WL0AqZiWUJJST3GfgO5rJflCHeD6Q5gookY3uTRn1VIWRuYWiE/xKXKu98V9Q1YwGFnponDOIxxDt6XcclAfQrWn4+WiwZS4fS6/8FA2FJ0bcbRzvYLdCrfIRze1Jb7JVgrVyW03yFimi88xHsxXC7M+DgGlvPBPATxFdER/vmGhfAEQwOBQUfXSpgZG+mqiXZaMLy83Ox5iNzvPhjocOBU6kLnKOsnmm7YDcX/fvlmTjyRkWt/Xs//zIUjX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 09:21, Qingshuang Fu wrote:
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>

Subject should probably be

"mm/vmscan: fix build bug in read_ctrl_pos"

> 
> Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
> is int,but MAX_CR_TIERS is an unsigned type, directly using
> the min function for comparison will result in an error:
> from mm/vmscan.c:15:
> mm/vmscan.c: In function ‘read_ctrl_pos’:
> ./include/linux/build_bug.h:78:41: error: static assertion failed:
> "min(tier, 4U - 1) signedness error, fix types or
> consider umin() before min_t()"
> And MAX_CR_TIERS is a macro definition defined as 4U,
> so min_t can be used to convert it to int type before
> performing the minimum value operation.
> 

Please use empty lines to make the description easier to read. Also, I 
think you can simplify this heavily.

We should add

Fixes: 37a260870f2c ("mm/mglru: rework type selection")

BUT

this commit is more than half a year old. How come no built bot 
complained about that?

IOW, what compiler are you using and why are only you able to trigger this>

> Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> ---
>   mm/vmscan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7de11524a936..f991196fd8e5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3194,7 +3194,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>   	pos->gain = gain;
>   	pos->refaulted = pos->total = 0;
>   
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
>   		pos->refaulted += lrugen->avg_refaulted[type][i] +
>   				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>   		pos->total += lrugen->avg_total[type][i] +


-- 
Cheers,

David / dhildenb


