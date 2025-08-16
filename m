Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BF1CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF718E000C; Sat, 16 Aug 2025 02:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7E98E000B; Sat, 16 Aug 2025 02:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9581C8E000C; Sat, 16 Aug 2025 02:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1FE8E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:56:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8EB61403AC
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:56:54 +0000 (UTC)
X-FDA: 83781713148.12.711D739
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7434E20007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:56:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ebURtJ1g;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755327412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN8fg+nbiX9r2kmZVMOFzoFbgLpi1t5HuR+4HKB2nW4=;
	b=inF9EGqpQXCuAggTdhrWNyRocQPXCAqNNdBoChXMLmoSCJfFnkHzUmtLnEXrCDYXGcFKI9
	KMA3WaoMJB6fJf7BaSjtIZFdxSKvLGetnRcqvABgllJDwwpPd0fV2pzj2qjCnt+1Y/sN+v
	HFQMolEigLDroe9kg6qRQJ49K/yowHQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ebURtJ1g;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755327412; a=rsa-sha256;
	cv=none;
	b=uayP9y1PVutC4ENr36fl1y3zAD4IU3vC4BIVm3Im8Zeojfp9vRydcv11aL0Czxuuy9paRZ
	eNl/nds6DPkKkiJCtcxerQcD1g2C59rEoDemc2chA6bEgzrC5Y5VMH6H1B7vareo1RgDu/
	IR8hE2YO/J3FxU9MAm2RqLL/ZZVqeUE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755327411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KN8fg+nbiX9r2kmZVMOFzoFbgLpi1t5HuR+4HKB2nW4=;
	b=ebURtJ1gjobSwfhSkuBf6zIz0ZZAOfjm9tJo4rQtjInCaUwUF40838oU57+OICLf9VyDsW
	01tl+kAv+8cNyvg6oRSdEko8ULH+L61T1n7YDrFXPzfZPAsXsZD0XKtGtpluDnWu6Joug5
	7QDmLwYEQvPZldTVfWF9t4sfoUv7ERQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-tow_seA3NPiItqk8oxzsew-1; Sat, 16 Aug 2025 02:56:50 -0400
X-MC-Unique: tow_seA3NPiItqk8oxzsew-1
X-Mimecast-MFC-AGG-ID: tow_seA3NPiItqk8oxzsew_1755327409
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e41475edso1748658f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755327409; x=1755932209;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KN8fg+nbiX9r2kmZVMOFzoFbgLpi1t5HuR+4HKB2nW4=;
        b=WM/bDH+gdPvSMwQOloG8DNOEa8D0fMS1EnYKf3l85VsYvP0mtfuZIFu+q9fduZnePl
         e2Fypvs+nj1b3rAWHyBG1X5Ee5szRbOPZlLcojV+21A7Ab+K2JJQDWjOfzncdvKS6MKt
         v2MqdRHuMXtiisO+r00EuROQEWzVGGpDj6SeKBkWF/EX4jnOMHy3ecWo9vsJjQw4sT7i
         atnlW4yBMbjY//2Q7dTfrCMCgX0FSkY7Sz1fxgLnilYbPnPYwB+SBB0eNEwnMWbUPvOr
         7dMeZpa14TrTAfaZ1oXlXCMxqZVkjd2jXl9KY5AwFWD+fFWQrl4NlPcPchVR4FoF6gp9
         /7FA==
X-Forwarded-Encrypted: i=1; AJvYcCXmRzYxseTDRbQtxLnu81PUhZYMlz94Ysc5Nrb4k/jQV9lqibqBWUYAbDlSiwjsTKK0oz0D+gRApg==@kvack.org
X-Gm-Message-State: AOJu0YxO7itrCGeSa27qqCfrFNGWOISAbQ1kwREUF6NtcL1PFSORRXF8
	3+yN6sFxFV79rYFn1ptFyjMko/DcrwUvJttNXHUqKOn5te1t8Lg3dOiAKdkM5DWlqLlb0nEObTJ
	ZQiKgeA5fo3ylUV7CVb30xJoM+bujecGsfpnXpzDuzZKaplUZVtnl
X-Gm-Gg: ASbGncupl5Xa6Gt1jXKGzKmjNGflVbISwtE9eMWgvaB8hHYT1TGXdMfoK28Jg2+7T+J
	AmX47Sog174pkO/bLvJa02tBlh5M192h2bs6w1jLavvuRC+pA7gm35wcU2R3d5MB1If/JTAJt53
	fy8DsnF6vol8tbKGKVWW7f1DXRVlZVppi+RtaS1BmLoUZVCFb2snOGo9RxIp/Ct+7eFR7VV3V3L
	405CHJS1xQFWqpvZ5yMawhKxELXCIZ5B6aba6aNIsnm27I2uDF49tvS/s+Oq0t0UbCiv52FrnNW
	3thIkL06sCXqMDeaGuA2ccBzFSo3EYIqdTOXmSdNnKOSXYP1oS69xJ6DaV79+yJD+z397O/v4e9
	Jv7W9QXTUTJcqirDcwxCUTIJpEj5GCa6t/uIIZ3jyV2o92bC7PogXzRYBaL/5Lij2KzE=
X-Received: by 2002:a5d:5f53:0:b0:3b8:d3ae:26e with SMTP id ffacd0b85a97d-3bb69b7d31emr2962686f8f.53.1755327408875;
        Fri, 15 Aug 2025 23:56:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO6LdVmZCPII/OsVa8BXcCaSLsJhIbHGjOSatlSPMXt4cEzP2EZ9sEjNz9iVGYBsrMs+Y2IA==
X-Received: by 2002:a5d:5f53:0:b0:3b8:d3ae:26e with SMTP id ffacd0b85a97d-3bb69b7d31emr2962666f8f.53.1755327408493;
        Fri, 15 Aug 2025 23:56:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a223206c7sm44705415e9.16.2025.08.15.23.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:56:48 -0700 (PDT)
Message-ID: <701bfbb4-6c12-4614-a322-def3ca923c78@redhat.com>
Date: Sat, 16 Aug 2025 08:56:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xiang Gao <gxxa03070307@gmail.com>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
 <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
 <20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A3R6D3IDuLUs1bf3l7G9oB5UJAwf76ef0Jds01leGZw_1755327409
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7434E20007
X-Stat-Signature: qgfpbcp3crncs73y5r7jafdm8hearrtq
X-Rspam-User: 
X-HE-Tag: 1755327412-359407
X-HE-Meta: U2FsdGVkX18kMBkP6UYdtvZkoTGb3vOvGzCcs+dgS4hyFg5op/Cazv8gayDVdCgI/X9OVgqONvv1mZo3mtfZ9drLh61xOytyHk6tesw8biqKLZs0RUHam+U7XBJgEwCUOyQOgiXdryL6dFS8fB3FsPre4Eqe67JLq/Wi2dtUi4VOy0gXc2q4n98/IuFTvmSN8InticN9cZ2essy76KgEW3mqp/tfa+2dI68WfYM2rGJCtvlk1v5WsBJTI1DZmqhjjK9+v2BP3E0YpuLm975YoTS/huOh7nKeePdnBH/2GLph8XcqzgtDzU1rV+hU6N/Eh3zPBkS+xp7GJotB3+hHsbbbH912Qkc9U9UGN1s1mFObez400hNvDjiHEoq33pSPUDUf3wuuc7bPr4jEWed1wYrGDQ/KhieNQ58SQvKb510cSCzIuV1gkY/K05/JqBqtx4nJGLW/eMo9rWXgKRJdpJs4i5umTPtjX4DiaglnhTQL/WphpR31CzKfD6W7Snb76MwnwtOgAaEvUu9XpYSbFJUGLDyn7wDU2PboyfADBkCMlvauoMj63EdFiO/P53D2qYkM43/5jxkgjrjaaxQLKjupAqdzh4jPw1XXU4+chYsr0Dt/tVxNpq3VDeA9GWJ6huGT3pzIMrNdx9b7C3iJeuFPhYnVRRQSzulfBwEVbVDi/jVAhU9ML4NlzZlpxmAYwbfFah8tXm4XPmju0K0CW9LosIBGHZmwEjWRVcjjL7vqEHVB4vM1FS651eFckHF3ue8yNQmbmcZvWHUQzG3NlqZUS0izVypLWB7OaU8bSjakTD2wvFsjJsBk4ewcUvH0RrYEduAjaKZrf3ynIfJfaZYiJfBWn11iJPs0ttO+Zcok/gypnh3hIAsHjOLtD4oSkmEbiM0YYl9GYelVGbm3DcxmwPIc2zt4TJY3jjJbOyNdzyZ/EfLzpwg0D2ZnN9qReUMQioiurhZizrj2QSA
 V4184bDi
 cn1GppFJVpb9q3Ymh87O9L8QcppRz5rC2ZHP0Ct7YLryeP4u/JWbCwYEr4gz30qFwLyN3Ft06BBh61sm3wEbLDu6jk9FsDZ/qvXmN3mdi9KhOieHhElCR7gjTIxo9FKcVrkiSEiBWiuu+tr8J7fC3lFQ6M0k/MsxwFiVTstP90RqUHlJz5RXj+jH5dLBVDXxEmOCL0AWC46Xf195xm/NR2udFewbbP0LfqyKPwwMUjoV2RIr+87kRvWa11P20M1BEUzHPSvIXLo/40MnswbKQ2VhVNsVWMpVAnVvh6Txh6OPAib6rb0d73u4HWHlDelRknxpaS8cdZBHGZ1CGCTCGWpVlrwgeI1AJqNKI0N/2NS2eEs6HpFayMwc8iQRnGNE9LC3fQOWGH9yY3x59RDhlDlKtkxaJyzh7yWMPn/XV/u0PlITHbXNjmT5DaTyDpuGrwrtaobm8qCyihedyBr/n3qMON5GdlKjTNoMsPnMEScgFC1Lp/2qXBCuWuastUOhDEOmYWHDosM0Go1JRBlghV7GPuoJCYVp2+i3POZ/WXnIEu2kIF44sJ+NL8CkMVgKF+R2QQ/eUYacVjJ5ONseZ5USK0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 08:45, Andrew Morton wrote:
> On Sat, 16 Aug 2025 08:27:39 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>>> @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>>>    	if (!cma || !cma->count)
>>>    		return page;
>>>    
>>> -	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
>>> -		(void *)cma, cma->name, count, align);
>>> +	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
>>> +		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
>>
>> 		^ one space missing for proper indentation.
>>
>> But doing another spinlock cycle just for debugging purposes? That does
>> not feel right, sorry.
> 
> If we're calling pr_debug() frequently enough for this to matter, we
> have other problems!

We call it for each and every actual CMA allocation? I really don't see 
why we want to just randomly make CMA allocation latency worse.

Is the existing pr_debug() a problem? Maybe. But who actually has debug 
messages enabled in any sane setup?

-- 
Cheers

David / dhildenb


