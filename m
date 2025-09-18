Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EA6CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2426C8E00B8; Thu, 18 Sep 2025 01:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F30D8E0093; Thu, 18 Sep 2025 01:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB138E00B8; Thu, 18 Sep 2025 01:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECD648E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:55:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B33D140792
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:55:18 +0000 (UTC)
X-FDA: 83901308316.02.E2F1E57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B276A120007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:55:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Guy9/b+K";
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKrCYz9xpAzIyzftdIL3V/90piIa1hzvp5f1tzNxkW0=;
	b=wnkrDP1W83a3Bh/yzFoKWfONN7aL+7HqDaOh+vDhDncCCEnwIm0CiCrV+r6hU3jA8qpgjk
	hM5jMt5dQdQJ/IXxfL+j5INPgRxBjWin1rOFSlKnaRTZ5t9ARrNfQRX9I8Dbi2cRvS70H3
	2O4V6g2qE3VytIvV7cro0lU+CS/LY1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174916; a=rsa-sha256;
	cv=none;
	b=FwCwUd2JvRg3W04/n+Tyu59KHdneOfcgwEQLluD2vXb3O2tX7+mjSnylWNRXWurwjduHL0
	wra2EKAZYfmhIfkbTekB62JGLQCttF/WLQj87JqD8ioWapKMQOvQ8IsLQNAA87PjKYerlZ
	swcroQOlIjRG+yAKHTA3F2Oeuq347Oo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Guy9/b+K";
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758174915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NKrCYz9xpAzIyzftdIL3V/90piIa1hzvp5f1tzNxkW0=;
	b=Guy9/b+KNkNL1jB+7SGAh9adseiMVZxu2aL1SRBwv2UJ1TMWrovVCEC3qJhbZWtg2q1Qs1
	ecS+7PR1XGg8b8xNdh2NKnt7Us9ZCaWYZKO/aJqt79c+wOUoWw20dSIPJca3mextrfgJOa
	jjeOZIF5T6YowZmkqEDbCmKP27YMJMg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-Eaqo6HteOWatqxJzD-HT2w-1; Thu, 18 Sep 2025 01:55:11 -0400
X-MC-Unique: Eaqo6HteOWatqxJzD-HT2w-1
X-Mimecast-MFC-AGG-ID: Eaqo6HteOWatqxJzD-HT2w_1758174910
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2f1a650dso3182695e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758174910; x=1758779710;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKrCYz9xpAzIyzftdIL3V/90piIa1hzvp5f1tzNxkW0=;
        b=Y52Sun4V8rE5piQymPewISN8I8um1oqW7hr3yCSfrVzyhuqsbYfXwpkXT5QvkX4pBg
         QPwnGi7BftxoREj4GipkBnTqeh/UzBSnlMj/t5Z2azFKrMvKqNzo5qAbIeBkwW12Ssk9
         z3XPSz2gb5LyshiPYi6f8NIXWIRVT09ESG6tN31LyLI3fMQBFS3BzNxxCjidrDUgyFRb
         o3GFys9xSg+4nn/faSycAk2z1OXHmvr0AibBf5TcGbrIu1Uw4Xp/Q/UmDIkjtJIdVsez
         HHELyVefEVMktOeBaugQuNFgfuXe456Tb7ehQ1aXOd+Ikq/czndDleP9byoFZggvH21f
         UFsg==
X-Forwarded-Encrypted: i=1; AJvYcCVqQxFJNcDaF7A7nhxI/y309FwK+0Xoj4Zkjn8C1HIbVf1I57up3oaqDaPLx0PIYjlZUwuT+S2OWA==@kvack.org
X-Gm-Message-State: AOJu0YxYDyHuOWNHgEIHKnGhpipA7IlP8EtUtst5rl/vFoI2oHLRW2hH
	CxGXX1elq7f9w8+xi0uB9jweVHzZsJvH/q/HWbCMF9y+l7MLYGPwINLCLppiJfW/Tda5XHMd9XL
	ui6h6kso2JHSQ/F7RdBgO2Lzkb6xVEiHCx4vC4ejxwpt1c2X3ve3V
X-Gm-Gg: ASbGncvQcaDlz/1bjXMdN6a3ZgfnqAGmIGD9R+0+vrzayRGq0PggKdCFAMJ5i03xWd1
	0agcBNy9CHDccsHONrSwPcO7eUnZNFhu1V3dxz/0umeqYN5eXZC8RNipXvBnkQ5nnY3YGvi3n8o
	jg0PHQx0qYJrALIUm5PqOSBwulZrMyM6d0OKggsGK4gfUltVfaZTYt47e9xstyB9QyTFfMPp71f
	zDtw8rtEart3mOBKmNeSg5QTT9EqXZEqdmA9e8eS/LUSb2Lmk0B/0CsUmIZUgoM+DJGs7i23/sf
	JtiUolB+gu2ApSmQIii4NV5JPPCQGtycE4eyI1SZA7xI9gEKrqI0M3fXkZDxJX2guV1l0LyhPiZ
	te9n6s+UyefrXxG3TzVsjOOAJ+I/d2nkoCgTOgUn/iaFyuMzbHt0rEEIsO8FXAL4sAemq
X-Received: by 2002:a05:600c:4452:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-462072d6ee3mr42901195e9.33.1758174910347;
        Wed, 17 Sep 2025 22:55:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+w/U1G077wqX5gf9L/drxt5mqXTgrB2KLVuNXmu3a1/ZafTB85mAnpV2PhRybFjEo929q4A==
X-Received: by 2002:a05:600c:4452:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-462072d6ee3mr42900825e9.33.1758174909797;
        Wed, 17 Sep 2025 22:55:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f321032a1sm57041195e9.2.2025.09.17.22.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 22:55:08 -0700 (PDT)
Message-ID: <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
Date: Thu, 18 Sep 2025 07:55:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/node: Fix double free in register_one_node()
To: Donet Tom <donettom@linux.ibm.com>, akpm@linux-foundation.org,
 clm@meta.com
Cc: Jonathan.Cameron@huawei.com, alison.schofield@intel.com, dakr@kernel.org,
 dave.jiang@intel.com, gregkh@linuxfoundation.org,
 kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, osalvador@suse.de, rafael@kernel.org,
 ritesh.list@gmail.com, yury.norov@gmail.com, ziy@nvidia.com
References: <20250918054144.58980-1-donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918054144.58980-1-donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3UkknWbq-SjOqHSY2dmzQKdmMUop0cg7BimXkQIhSpM_1758174910
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B276A120007
X-Stat-Signature: phy5gi7rgbc65ixquwrin7hh4hq6jped
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758174915-901394
X-HE-Meta: U2FsdGVkX1/JsY5lSqwZ/xytu/MMeS+ZdI/gjVAF16GDZWz5VcVkDP54xGJtXZgUrBtusOQ8iLIVIDxtecuJRbnVFCl3teK+eaCNYTsZG/skg1XofxXceRx4x4q9zg86s1ZMMu6DXNahT7DPxA/gRR88zcGGEc6QMBVev2sGyLP6VX5HqIuPr7fsazQCgtiRyD27+Ngw0Oc4u6h7LXA2gTwgwPgSbstZzE+IRiA3B14O5gldbie7vtIOkiM2vsBAkXL/lFEDlIV66Rxgc9pGnTRXsKt6wMwexU1LRPH79P1hI8DiT375pKZTDGMM98pQcO5VTYTS+BDiTrdb41V8QmGh9PjGaozvjkbzWDvlYjaWd3r3TeZZxdFCs+DsqNFGoQn3G7clRObTqROgmWPKV3mKMJLNS8sVhtjit5g32Zv1EH7X3JUENszN+46v96QwQVt9mPMTRzgXCzZoMzdVZ4HwNEfTAJMGdg/omspgEa4vLgVygM+zplXNwGRG+u4q+Qh8S8oBLUJ/YjMkwONTv8Ku3SlX0YvYc+ONP1XMyYOrSZ+NXtwqbHqTO9Zi/Tnyyn2Zvuxw0arjm6m1hW3BK1+LJh8S5cnb61TgUOSvEikfJkT9+oKKOxMzAuvyapxX9E0ZCCcoZLAcp4+1GcI5Zmhhnr13PY2zmGNhEJdBdiPzvjhMH1WI3Nw3/ejRktVOF8e2Fjb6koThDUL2iYzzKR5ZLFliCrJh2DRp8b6v14jwmxyxBaGvKeQhHsarHPiG+iSgHX8L6fO6KDhdckWFOTAIAq555HOmz56FBXzP+jml0ZM9nzmCfva+3Q+f8HnYw0QQ9zl9sAxFdJLIlcANWc8Chz9Kt6/jqti69YkYFZTJYbJ9Xb0W7W8NHI9CubS93opb+1H7aKV9SPE2kAbBbq7KwTOEo5HNsFLQ4bvWMe2d3ee2ngyn+JwRJpPyTq3bfY34mCwcNxSwS/l56uU
 JtMmLWpG
 ytQZQAsHIy5HEApvvtvv0E4OukQqkOJ35b8rXYsj03Zz3Xzs1AFhcDpPXPSMTRBmkr9Pt55kLMPNJamCG5GVIKhdW3L9BjGAVlOYdyY1g4C0arVmwXPzPICRmxZUU2/6JQ46RgxRQCpFsoZb5zz3S5mIGYOjzJ+LvlRqeO7yjmShuOHar0FC5h2FtECIqTAKpYBcnmAwnpy4EYTeze7p7OUgjK55InkmT6fhkq3b4W6GioTDhCuOGedTGnSsu8GJCRUjZ6leA359twH+1FJgfm0XbeNm16PSAiHZzhkl5XiFk2JOAnxYrIEXxbyWZtr7ehsq0Io62Yj9cbimAHh0NGpAx3HtIJdrRuWxlD+z62OsNM0pYAi42nDR3qgLZ+mRvtOXk4645GJFMTQWm0kVQEUfPj8VLaYob0lNloTjM2JJk/csLdvD+Kle9OXfwDGrml2LkoDA4VNW5HJXYu8drBRwEH1IoM9iuuhubouGSvd1WgiRSmZcGRn2AY0OM0J8YmJMBP7OHod6wNEhm7V+5b8gcgepZMvCYmzA6qnSShwmb9GVei8pRV8ucG6NRCMuTLFTt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 07:41, Donet Tom wrote:
> When device_register() fails in register_node(), it calls
> put_device(&node->dev). This triggers node_device_release(),
> which calls kfree(to_node(dev)), thereby freeing the entire
> node structure.
> 
> As a result, when register_node() returns an error, the node
> memory has already been freed. Calling kfree(node) again in
> register_one_node() leads to a double free.
> 
> This patch removes the redundant kfree(node) from
> register_one_node() to prevent the double free.
> 
> Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   drivers/base/node.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 1608816de67f..6b6e55a98b79 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -885,7 +885,6 @@ int register_one_node(int nid)
>   	error = register_node(node_devices[nid], nid);
>   	if (error) {
>   		node_devices[nid] = NULL;
> -		kfree(node);
>   		return error;
>   	}
>   

Yes, that matches what other users (staring at mm/memory-tiers.c) do.

I wonder if we should just inline register_node() into register_one_node().

Then it's clearer that we perform a put_device() already in there.

On top of that, we could then just s/register_one_node/register_node/

And then we could do a similar cleanup for unregister_one_node / 
unregister_node where I don't consider the split function really valuable.

-- 
Cheers

David / dhildenb


