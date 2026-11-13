Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD916606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e2gHZ26b
Received: by kanga.kvack.org (Postfix)
	id BDEAB6B05B3; Fri, 13 Nov 2026 12:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E966B05B4; Fri, 13 Nov 2026 12:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E526B05B5; Fri, 13 Nov 2026 12:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0D96B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:06:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4B1C1201B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:06:43 +0000 (UTC)
X-FDA: 85430725086.06.14E8197
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 471A71C000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:06:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2gHZ26b;
	spf=pass (imf21.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794589601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmmnV/ymSMAI2Dol5zCaEFZv43vlX+d7yneKTBH5aJI=;
	b=S6sx9094DobBkXi3zb/dXhAUjJ3igTk6RYxYphpypAqgfNhNuNLvrURH7MUnVABjCpnus9
	IR0qCzikTOXv2K8mHjyeObj3++CErfW+C0a6lCMFXrpMLl7zlilrOXXsJkmi0z/foyUGYc
	NXmMIeOHJJIVzheWMjtVdGXzuQtOYYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794589601;
	b=pjF91fpk7TtC9TdB8RvO597v7Vodxi+w5E9yI8HfzOooeEifj1wZVpUPfCOQJRcL7UVcDB
	bp6qKYjOyLsW15joYTy2FmFJX6SUCj8Xcs1dGxbekI6D2J+EaIZ1XlNFZJrCCXWG7mJM+Z
	m4+cqqKOs/NFPw4Jy59sNCs14pqYYjA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2gHZ26b;
	spf=pass (imf21.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794589600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TmmnV/ymSMAI2Dol5zCaEFZv43vlX+d7yneKTBH5aJI=;
	b=e2gHZ26bDcZVmjNnP5itMSUk0JgsqlVoufhv6xY8lYsxY1w3opJu7NVXsJL0AvdpI63mfY
	ABeRWr3Z5VBwI85EXuKBY+LG3gX0iEyduiduJrFtDNQWcOkXykG9mnQavh7414TxRav0Te
	t7zj0wuaEfaVh0tk0jA8CP6k7naMr3E=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-2eOvm-6fPFCESDqIkGDmow-1; Fri, 13 Nov 2026 12:06:39 -0500
X-MC-Unique: 2eOvm-6fPFCESDqIkGDmow-1
X-Mimecast-MFC-AGG-ID: 2eOvm-6fPFCESDqIkGDmow_1794589598
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cdacb64970bso585586a12.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:06:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589598; x=1795194398;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TmmnV/ymSMAI2Dol5zCaEFZv43vlX+d7yneKTBH5aJI=;
        b=HcTgkOAqEribSnQ7c+dxzMcrwLg26EuKa8EOCXjQH0AKyZxDinvcdosUMN2buH8biZ
         9hgjh8miLJtdGsw1O0LobB1iyJaC0ctfx0XosuPdLvMs/SMjolaqv6bjG1Y2/EcSLw47
         kqW9GA17VJ4YXWtg2XL+uyIspnt40Jln1tvDXrxmXSNrRNnyfiQDciC4Wyyd9NHGby/X
         HOIaiSRmFGXM0cMzErFL+SF0X5vFpP03yGmKfQOoXfHxiquLJ7CUsaCER0BBOHS/pXSd
         K1RRymU9efttxXdDVaPOMP/+pHO9wBssM1S+4ot6Tfk62nqhCUGxPn2BpOOtr62Af3Cq
         XNig==
X-Forwarded-Encrypted: i=1; AL+hErH90mxkxhd7otAMs2449b5f3rgAi/E+3UdJelChTLz5gI5pkMPAF2D9BgrQDK8cG9IeMWJLYgimkA==@kvack.org
X-Gm-Message-State: APuU4Z/Yx9bph3p29DFTrdHdW0ZwOFKwtj/2aJsPUnB/kbCH8KdEz76l
	IrA3TCmluFghXt4K4yHAund1sNTQmNBR02WPBvIzH5JxrE3I6KD/+esg6DPPFwErd3mng9HOvC3
	LvdEhRGAHg8s8jFopo133ZieHRVhNJYJQxH1AFLaURxUfMIXv5Z9r
X-Gm-Gg: AYBFou3An686hDJWQ7cXFYKqWnbX9zY/VjS6m6I+A5cx017lb8UG7YcV/84ZfgZT7Bb
	Pw+KMjxR2Ra4gKif4WQ6N6f+M5MP989uXTdDbosbjfysR1QIM3/fcLYnDO+reagquKhq+cmA1D/
	WExwJa3N/EAA8vUKcn6X8rjVg3N0T156xHE5JImAPUj9fGsvmVwkRML3czRfr3XC32wkWJPLeQk
	++pTC2jc0HArbQ2KcBrpolxjAf0zz1/BaywEk479FpvfHGhBSlspjFwkEFEjDTBtavLOhBslG+5
	++wFT57sc+HnEDyDB1roXnviIrZpww8rpr7CyVNC1NX+mQP3ZDCy6OWAVfp5sIg315sEefJIkOL
	axE1isNuMS3j9+g7+v0wdO5yQpxB9QmlM759djWETtHhci/hQL4jaEAC6eLe030sXfEf5Mpw=
X-Received: by 2002:a17:90a:dfcf:b0:3ac:7556:8eda with SMTP id 98e67ed59e1d1-3b1b0a1b56fmr2668129a91.26.1794589598109;
        Fri, 13 Nov 2026 09:06:38 -0800 (PST)
X-Received: by 2002:a17:90a:dfcf:b0:3ac:7556:8eda with SMTP id 98e67ed59e1d1-3b1b0a1b56fmr2668105a91.26.1794589597671;
        Fri, 13 Nov 2026 09:06:37 -0800 (PST)
Received: from [192.168.1.102] ([117.245.168.128])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3b110c0sm2247977a91.3.2026.11.13.09.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 09:06:37 -0800 (PST)
Message-ID: <2bae83be-bb44-4541-bf1c-5861f73a7394@redhat.com>
Date: Fri, 13 Nov 2026 22:36:30 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] kho: reject zero bootmem scale
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
 <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H_C-OmcUTQ4TsjYwjUWjm7BF9dcpQlTIFA5kzTqS940_1794589598
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: idffuo1zztq7k3xn6q98afxbd7j9c3kb
X-Rspamd-Queue-Id: 471A71C000D
X-Rspam-User: 
X-HE-Tag: 1794589601-416516
X-HE-Meta: U2FsdGVkX18xNl7KqhWlKgUGFwYOyRP9CHy7WmP0YuTwn6+YKsCmZKfkBptTtieghjuv4XtKRWAYw0U3zSbz3BDqR5Ms8TemjcOf8XCIelVzFGOirA3JzuzG3Ob23erg+H0+WyiuRo5i8R2949+6bz9aWj52880ZOr5RkrXPnwEPp1RynRPpbIED0WS2i6wxQqUHzYQ87LF/oNeX0g68h7q7hXQ1ybY58pk7aImSVQqxkSA+3T/5yobBsYVH+bYsHGTlu21nQpWSDIeKaZPGhu9J7L+MaA1ZHGuGb8FFWT1fUA9gvWp4A+mFJphT39KYVT43txrU3N7AdVQzLO3jSA2SY22AWqOyOl3j08eB4J3jpye2HTdzW30AYK/XDWOXZ2MAxYCWeVWqQfwzgjKaNIJ0sLSNAcMopSNIze/On52Au2fGdN1I6UF6SKYaI4JcZIKAlCR/7gOZ4KvZzT7+/0XDN9kbmR1DGyRUefVdE8XcCDd984RUAKQTPQntCm8E/1RLFuCe5v7GtVFqfSIbJ+If75T/2b3di6eJGu/0JrrYXruzF0E2jYY3df8QU2ofcnWdh8f8tTWclpyMAQM3mzV6ls+h35WZ9gpK+lLuY5Ym6cl7j7RLjga3czV07HiyMenb9YYJNHqKfqrum4x+6RYGzFjexYVzbuE+WcCOgeUb0j2MonqLWWoEoQ3ZSg90GdPr689jb+becRmdlIt0ZAKEW366YeLqp+KUC0yK8Pv+kn/MRcHy4NjKJihmFuRwwruBd5O9l/k6Kevn5GVYm+SerjEO2hSPrackMd/YQuNQN3toe6Lk5FOsdWRtT6ztx6FpkNokLQGwi82Pr/BpJp8GakAMyJ6jfFG1qUlsDf2zVs4xoLUNWzsna3uGOH00HRyDg3WT1FOimJghVycnTK1BP2v9N0HkGWkyZjw/SMYq01vMDbiK0+CiYiSry112KvroBj0J6iG1U5INZgg
 jyRUYLyM
 bl3avPcrl0+czMGxtHaWmv6o6sjp7Hbo0lPBWzZ2qQHUNfYVgRT0FAqbDiR5Uhg8MrJM/l+XzhON1vrjDMFLWMvcP5Tr8yNKTTPQ0xILYNp2vChfax/qssX/vXzm4dwZ/7td9Bg2Y5Wgq0/bqrEF6H9sXMGHdz8BUwQjyx1xtUSKiI0voiOYYL1BnqrExyNJ6n/biQnfUKH6icKTmDSlR/0y+7MY11bP9N3Bf2N1JNgAUERDZ7xqvZkwvK/wN6n75AV2c2jVCGUbU9wLx4E15DlJMWLNhF0QzDeAKGQHQPpxJ+9ODrHrQjCXEMR3GWOwm+iBjAnSc3QQjj/XP2oEgSTSYJtMWnkx883tfJ/LeLa7vzVtt9UHwAmUC6guN7Z7a3kYp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 12/11/26 4:08 pm, Mike Rapoport (Microsoft) wrote:
> kho_bootmem=0% sets bootmem_scale to 0, and then the bootmem areas are
> sized using the explicit sizes that default to 0. KHO remains enabled,
> but there is no usable bootmem to load the next kernel.
> 
> Reject zero scale the same way zero explicit sizes are rejected.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe31819..b30ba686cb301 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -703,16 +703,22 @@ static int __init kho_parse_bootmem_size(char *p)
>  	if (p[len - 1] == '%') {
>  		/* unsigned int max is 4,294,967,295, 10 chars */
>  		char s_scale[11] = {};
> +		unsigned int scale;
>  		int ret = 0;
>  
>  		if (len > ARRAY_SIZE(s_scale))
>  			return -EINVAL;
>  
>  		memcpy(s_scale, p, len - 1);
> -		ret = kstrtouint(s_scale, 10, &bootmem_scale);
> -		if (!ret)
> -			pr_notice("bootmem scale is %d%%\n", bootmem_scale);
> -		return ret;
> +		ret = kstrtouint(s_scale, 10, &scale);
> +		if (ret)
> +			return ret;
> +		if (!scale)
> +			return -EINVAL;
Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

> +
> +		bootmem_scale = scale;
> +		pr_notice("bootmem scale is %d%%\n", bootmem_scale);
> +		return 0;
>  	}
>  
>  	/* parse ll[KMG],mm[KMG],nn[KMG] */
> 

-- 
Regards,
Mukesh Pilaniya


