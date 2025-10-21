Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32734CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9025C8E0016; Tue, 21 Oct 2025 03:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA788E0002; Tue, 21 Oct 2025 03:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9378E0016; Tue, 21 Oct 2025 03:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8D08E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:58:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B6A8160349
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:58:02 +0000 (UTC)
X-FDA: 84021368004.18.387FCEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E3A0340003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:57:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JlE9O/NO";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761033479; a=rsa-sha256;
	cv=none;
	b=walyEcUzGSWW5aCkJRZNXGhumV5OMBv9hj9ZlaUglE16E9+CfbBc1oSBBP+Ip+F2NC+ilh
	lsMDQRZzoWLHfTvWj99PpIR/wgTbqY0jEmZ/FuVcM7esKUCCNLfv1/EPAeR9ua5sgV1TZs
	j5S1zkWaAd/DxuK8wc2VghNbzyh9pkM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JlE9O/NO";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761033479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6eMKFbej+QUBomIM39UwXetYGWu9Y7arv53CZP2AtM=;
	b=7R4T3lwupQxW8ug2n+xw1cJZ5QLCcx6OQmJc5e721Rt109Pzp2yDpWG69Ry8l0m4n1bvvp
	gA0vIiiSFxz/S2lm6KD+wYo8wP/wxaGgiDbxxwZE47j6T+D0uUWwIZ/JMwz9Hft9flB/1+
	18yPqi3NsUw24TFMA/nr+XD3F/hy8uw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761033479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B6eMKFbej+QUBomIM39UwXetYGWu9Y7arv53CZP2AtM=;
	b=JlE9O/NOx5QReqs+mSU0sIGmWphyGP6BJKIlMzHFbpzqiDSyzV4YfxgGeN8xT3NsaxSdi9
	ypEH6h45HZuVy3/s35nMYl4lVGXbIikC+HPsGzXGDB6Ml2RPrDJwTQjOmdgciu0DaEyk2M
	3mMCxSHlMnpF7FD9162aHD4+zct6wzA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-uEUoHzJZMpullh0lQiQXOg-1; Tue, 21 Oct 2025 03:57:58 -0400
X-MC-Unique: uEUoHzJZMpullh0lQiQXOg-1
X-Mimecast-MFC-AGG-ID: uEUoHzJZMpullh0lQiQXOg_1761033477
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so58818345e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761033477; x=1761638277;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6eMKFbej+QUBomIM39UwXetYGWu9Y7arv53CZP2AtM=;
        b=CKAxlXAcVFwx3sM/8iCZCljI3AW2lY/JU6V0ulNkZHmRTFOkh1um1KbMbXBfZN7A4E
         Do6uyf2dmvVnFypnPCpaKhuyddDLt2t/wxu+nZPteUrBwzpEez2BwojbfM/NP8K0yPza
         joE9kl25Mfmms6D9/5C5T9D/AHfEtsZuNzG/DVci2N/UNSm4YTL8Zygl0EtPdWyvCZqQ
         5+NcOZwGN0kYaN3ws3FIDLifPg5IA5yxjwtDXC6iVmx1wbq/+4O6IyZgjdSnuxtA3SaF
         iUwiC0Xa3eUKYlENByDFDV0Swa70zAUe3BP1LLLTYJ5bCsF5KA+Apbp488i5UY6bWVgJ
         fbKw==
X-Forwarded-Encrypted: i=1; AJvYcCWhpxTfIgbrV6tUJVmpy6eK9nVHWyPiTjA1O98hCIQohl4Cf85cgTwCFvemj3IY9x+P88eaLrwYTA==@kvack.org
X-Gm-Message-State: AOJu0Yza9bF2Syy4bzq+BfFUswS9H8/lg/sIEcRnRUMy+fckA/mWkrcB
	wiKPvrpfHnwBneUVL8i6EZDNcS8WPyor3DSL0mI639PLzD2YHQcZq8kzCeyUXMDc81B5XaLppJJ
	k7SAa1AY8ucsZFMZ3vcT4aZYtBMTm5gP69EqVty9nktZDASkpnW/P
X-Gm-Gg: ASbGncvJtvxIQwMk2+dJ2mbBV2ijxIqT1zJQMp5jBqZF2bZCb3OMw7pmB8wxTPblNIK
	ZdGdiohV44jx+mpwlKZqPs6rkOKOeTdhD/pO9V7fS5BlcwtRl/aoJWIDfe/iwqoiIOG1ntyhgrW
	/MWYdoVz0zt0tuAYRZNB+UM2pH0gFM98LIqyr6k0F2wx2MXvJoHrgXDTt41UfDnAr7DMe/PUL7f
	kR3nd0GoThlGe09f3TMik2WNElUw+zgIX5pvDAJ/rfad8/RKK3DB94Ojie9bCyLje2/JWpbSlFt
	5H9JqyLaCtwI35gn51VSgA4S2kEziSFSV6I9kl6rH/aRjpyMRmQtgj558etmwP2+VPUmkTEaL0G
	5WBoEW6R8dF7F5mdo/SGYoqXGkI4Msw2a6mcFOEsDvPXZECmqGnOwlZTWKdfZv+5jb0cA7BpNbq
	+kgHqvBtb2Yqgp3GwXZFcluckZRso=
X-Received: by 2002:a05:600c:548a:b0:46e:6d5f:f68 with SMTP id 5b1f17b1804b1-4711787a2cdmr108346615e9.12.1761033476772;
        Tue, 21 Oct 2025 00:57:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDJFbjuB3mwrwyYzqrJL+fmfXcjBy5U7Nf/cnLxTGYNtC8FgM9hOpaN1CYcynMUVdb2OhGfg==
X-Received: by 2002:a05:600c:548a:b0:46e:6d5f:f68 with SMTP id 5b1f17b1804b1-4711787a2cdmr108346535e9.12.1761033476398;
        Tue, 21 Oct 2025 00:57:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c831asm259795265e9.13.2025.10.21.00.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 00:57:55 -0700 (PDT)
Message-ID: <99148386-52d5-4d22-a9f3-48dbc9d77273@redhat.com>
Date: Tue, 21 Oct 2025 09:57:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
To: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 jinnasujing@gmail.com
References: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jcTFHOI37fKj20Do_izVV7Zi9IH5jSNh4rvsnwFZ-fA_1761033477
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tuubzo6winm37zdj8xtww13ipmonuskq
X-Rspamd-Queue-Id: E3A0340003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761033479-367641
X-HE-Meta: U2FsdGVkX19sQ02wChC2kBlMm+Yv4ZD8b7NupBER7Z6U1IsxRb6RT52DKcESdJdC7/yJy8HtdW7+UHxSk35Nntg/D7jXiXdVvqGw00G89y9GpxNYk387u4tCTWSWR/bFmrUtlUg/J3cgO1CJ4NGDZWHMe80AxVrXgYASKWTpZGSCMCFjR8ED7ccJFATwWRiVefJ51e2b5s5P7oiQ7tz5TWbteuwGN5RUqDh6w1olKXyyL8T5rE9ox/hkEchiEaaiCwRoI8kXh2mvzIhY4N1sOwtZF6nrpzCYZMIo+EJgKji3Y2+v9rcVefs60fDyu7xP17DW3E+Xj+F/DUnq3s9DTdc078XuVfs8mFZD7tajfBe8hucLe7ldjTcpT8+A+bmA0WACmbgTA2+yfywx1J3u5E+8IU7FGbfGurmNVwmqdSPyNajSS72cxZE0KsvZEPW293IPlt/MNgcjSOSbpjBFnUkMLTgKb+uNGmUp4U/YDbAQgHqG2yamx6FNMEEEnFs2utswH9ZLo7IBEagCqPuTHSxR3J4DtY0h2e+RAsjAmWB6YXwlgLxoYNnzBwOVJQIn9sKGS46PqolP8FBggSPQWs1im5R+G4D4jkOn5K/mv9+vG9Ucx8/Z7QW2hfR882vzRjHik/xxeEHWQ2cLSWUEON5zfaP4jRgj7PBOKcq43xCy/Ck/5Dfc89H4fqe1UDIFt+IFpyDyYDLuFcRKOGWtNTBnF2OxoJL2puQlHTRvKvSz/ljARLnX1wXIl1EuJwvS71VYwLWxM7wn2Ob/4PlINDOzkb5mHtotE3BDKA/+Bd6QKGneVwTGItfRJE8dEZSiAMT2LmpO08t2z1u8k/608rLVLaJUv/hSgM3QffOsLuYANmimwuf99Y8nM62Zlf4w9iGYthF+LJHzHuLEZATff7G9IDc15HZOT9bgKHFuH3YKA/LhDTJ3LcGDCOkEn1vRjRijc5GZLcpnGVxwq3z
 kl+V0Obn
 XiDtnD8AED6W8AP2XwJ9oy3ydty7/3DPVn2ogZyPh/SorRvJdk/i0Q/SRsnAWMDmElT+cYzTFMF3Vhxrb6pDs6fS6ZudZf3A4Mgy9An4igG+x/UXTOi9dSs7XxOGg3cbPgY/F7OsHUOTsUR0zV3Cb9MC19lNXIo2GsiIHEHX3rZZAtCWQOi48irONCXYZ/p5QhtkDvMa8TVy1a9pcYwPJhBRrBt3wJfvXzTdILoZ6LHVEa4PFenYyqspPwPuAPsYDAx21Pe2+Md+0EiGBAqAxMyD2C9gRt6sQKPgisHMUEX+yPfVTTLfGV6EtBMlSOZaQ1vtv5MnywAmXQsV1shT2aSFjB3KcFRk3Y7iLEoe7Bz8c8AtJqWOUg4Xy3SCv+1e3AkjKFqvRl05Sq3w2N2wJi9lkUrYESIuZJsZd3j/o4I6+1trr5SLBqQlbJEG3Ep2VuL3P86U0iLFtJdJL7DGq11wccXC53RsYdEje9kBfAP83VXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 09:37, Jing Su wrote:
> Adjust misaligned braces in the fold_diff function to improve
> code readability and maintain consistent coding style.
> 
> Signed-off-by: Jing Su <jingsusu@didiglobal.com>
> ---
>   mm/vmstat.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..63860c3d22e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -782,13 +782,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
>   		if (zone_diff[i]) {
>   			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
>   			changes++;
> -	}
> +		}
>   
>   	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
>   		if (node_diff[i]) {
>   			atomic_long_add(node_diff[i], &vm_node_stat[i]);
>   			changes++;
> -	}
> +		}
>   	return changes;
>   }
>   

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


