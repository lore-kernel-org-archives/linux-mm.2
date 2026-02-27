Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37C9FD5307
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522406B0088; Fri, 27 Feb 2026 02:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD386B0089; Fri, 27 Feb 2026 02:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4FC6B008A; Fri, 27 Feb 2026 02:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 279D26B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:46:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0AB4C2051
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:46:23 +0000 (UTC)
X-FDA: 84489453846.19.CA92281
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id C7F52A000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:46:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JyUI0hl6;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772178382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPz8QjAwZvhtyd1YXSG1O5BxKJR3PUgfbJT3DkGnKNY=;
	b=U7IUoZCs5YxuPgA+wwVWcUBBR3MS7gMmgUH1KkfMqG43gFpmCMktIsrqZ37KXMH7vF0dBa
	bkX34SwQ+NUPVqBTl4bNgxom9gVHtt0YGdepA44SkFex9Z0mbO7azN/rOJgEd0Joi/na4U
	SJWbQAWD3Fao1/2HFLwf8+0hZiq60qM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JyUI0hl6;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772178382; a=rsa-sha256;
	cv=none;
	b=A+tyTe8YVezoBl+DldyOfd9iTulzcuDExkfTa2taXdxlHt04XTYqCgPpSvaRIY3f2L0hl/
	kq4hUmgeO2BwG3qYFPHiDCGMhbXzW7iCFfgbwiPdMSFxFbvlLf8QRFV7Dmk4BZCjvrRS70
	7NWwF1rUkjZ+RFuK6k0J91wfhAa/Tks=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so2230975e9.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772178380; x=1772783180; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPz8QjAwZvhtyd1YXSG1O5BxKJR3PUgfbJT3DkGnKNY=;
        b=JyUI0hl6EmW5eJfsBDtWPqTo+WFGsb6yMjUT3ctp/QRgtOB8cn/i2AuNRgv1+oJGtk
         njEvstrwq/Y05z7poHhcxYMtSqyutHhId6Uoy7Ocu5D87CoGyNHq4zVPaj7RvY9YKpTF
         vjJwBrrebrkhLAfSdwaKzRp2Jw8PlRpuSVpcIvIa6isP+tlZpiZjmPWGIIuYW/HGUhER
         Be+q2+ToDAQk9k13hoWRD0/CrYW4N7+JtWgVg6UvwjqsFMIAfsb0iSF5XNJzjrdG/I5V
         n3YOI1SESfs2X0+h5klWMzIBtlgGnl12xsN29Yx4lXFKUkNjHhSkvsyaEGYwFwrSZ/nc
         u60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772178380; x=1772783180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPz8QjAwZvhtyd1YXSG1O5BxKJR3PUgfbJT3DkGnKNY=;
        b=w+Zik0Cdu6uxMVjho5BTB0rxsjTaPn77GjDgeUeZLd0xByE1kGVqPGh+zP1N+gpPj5
         BtDoRXrKl7Nv/0n+nr1lTpLKQAODCF9bWVRVaqkTXP6Co16FE0t7o2ng6uOOi+D+FPlL
         0s8+v5FToeIbEiZhY88ax+O/srk/GE1BLpSvlFMjjDT65l2XFY3nTvcdwG9Iz2PqEeIw
         2lscY8L+GoL959Csoqr1z3CWZ4IelOp1tfOA/uGQZwlJboiaZXv08F3Hq8IJsia4NH1R
         z7RWWsvNTKm6l3P6T47ZSFni+kBctW/XO2f7QIm86vvprb9iwa/UbaDgXYFzIe6+kUQ4
         +3qg==
X-Forwarded-Encrypted: i=1; AJvYcCXKj+Kg6xGgqRnrEQWuWfiYZvzYhpkHaEvrEIH0tmtyzk5eozAwWS+cfWG4lOww7TmmG9fpOXpQWw==@kvack.org
X-Gm-Message-State: AOJu0Yxlo0qt9E/sJOjDDufzp6LoOZrjGyEC9D99ZCy2EnfcavXB+Z3V
	HPruTeBgIr97nf8GX1elxG0EgkltIGaivZM+2xfqK+8IhNm9360HRGTc5wN7jFoumIU=
X-Gm-Gg: ATEYQzzDw+ZnQ8rK2piscsZzelvsmnqFFzK38/hgHcbc7E6BCKaApdx7BOkOlm1tJgv
	UMbfBTe9dXMpNM3yCbYp2DpL80LermMyw9YC8TUE3T+T5989OP/HE7/k0AMr6+R/fUjzfDprQlm
	TSp9QmaXimeHJXe4lUgHcbo44QKABm0zIPYDvgBroDiOGDsNvi6ZN5WAA/bY4LsBxqkRQo3Ei/N
	gDOx5uPhPtgpwweueO/bKJTZW2f76tkDx4BBu+7dQkIEDlbDifjo+YjXxcw/16/g45rYiaK2cqP
	AWFnv1HE555HceeXAg+/r3f8dFvFJ6/6suKoDnKEKuFhzczlYiZxwozVItHfAs5nkz55Fv4qW6q
	GVNd4XTw+xFY14KJLQu5pgk4xb9zLs4ZglqsoQigUF2jGfEB2BEgg4YsjFLq24Hzxj7PXf42KDX
	NTQBAXoEjdqHZapi0FO1liUtopUJ+rgfIuaaLagNeXHhjk+IpHgU5kPZO2qg==
X-Received: by 2002:a05:600c:4592:b0:46f:ab96:58e9 with SMTP id 5b1f17b1804b1-483c9b7fadcmr14391835e9.0.1772178380074;
        Thu, 26 Feb 2026 23:46:20 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bffc17dasm97998005e9.2.2026.02.26.23.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 23:46:19 -0800 (PST)
Message-ID: <25f6a18c-0600-4a21-977e-19b8b4b203b2@suse.com>
Date: Fri, 27 Feb 2026 08:46:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, vbabka@suse.cz,
 harry.yoo@oracle.com, muchun.song@linux.dev, akpm@linux-foundation.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260226115145.62903-1-hao.li@linux.dev>
 <aaBM0fN8fqER7Avf@linux.dev> <e759dd9b-0857-4155-b570-cd002155f123@suse.com>
 <siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ayzzes48nmamd1txmu97ujg6hcc4bzf
X-Rspam-User: 
X-Rspamd-Queue-Id: C7F52A000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1772178381-138972
X-HE-Meta: U2FsdGVkX180P51QvcKA4E6JJ6WCMDmc2MoA3490mzzbLwQP2fh3eLXG/Dg1k9jIuiFCT+51FXYhnRDTwQRvGpLikhkS+yd9/SwBHFEufwXndiGLzUfM6W2LlbSOnhScvEg/rnx7eTRWJB0vY1zxeUKXXEhbG6Ce9HV6P1LpliiOJnoKOwhXK2eu+s6tjV/gQ3i8TMcGLmv1MnYxw5NW1Psv6dArqIS4UDmbXbA1NNDnZTfOroY511u93ZuZVGpq9hR6OSWpeUstYVfagcyWsoO1AIW1TJFR0e/ZWN4SZHZcc9pynhTkmplq+0zPYtW0rn2YiNBwX2eM0Fq+nHkSSACZO+51FDRmsmQyH/uRzaZKQzUvAdYG/gaE0YBs806AEJ7F5FDa5IcYyl35dI3XoP89un1Iq56ApVNLomGuXvJLiQpJwi1TZsbTXob6p3UgYbOTmbjWoiTFge0609ds6dTbmOpQYZTLXpbxzLfatlTE5MHzioNtU9DKusc1lixywEEq8IuHYxnaGWI/fbUVouHHtSkCRInglRwr6tH4b7kOu9FBM4A3L3CJ7KYCfu6v+ZX+xvTmjs31vPCmDxZHhEegxEELhpt1QEoSWZyvrAlHgZ+ihSNqCYHvGiFzRqxZZ1984IBpLTwta956GcEgN9yfw6U4+fnekG/ICYYWOEX6iZNaoFPrgppPehc0JACk2djIhDmyFQTpIj3EhMpSntLvlsLZ1m92+8EUVx7NNaFDh9shlILWrRMupWx0Skf5ykwuFzMBKEv43wYsn67aFwyq/S0mPP7amgjsY0Nx/oEP9sPiWKSktVNyCRGvkAb8//Sa9RmxRWFms0iltfZ9NjAq7du2gQKUT99I7jxRlRaWjsh7Lje5gwXlCBdqjuYjfr6qxur6Elg2tZJ8osOpY6pzhGI0WzsbDeUpSCGZ4LBgVDZDB05HAP4T94taLvnDTeeSYKifXdTo7uSIKBg
 j2S/ARJM
 9Nn7QPmrutHSJl/xg5ykMUhqQR+I+R38/y9S1ayJtqmckLG1bZt4EVTsnZDsb8pyyom49Ckz3yUoaYHqS5QyfI8H3ioy2YyLd5BuDtBXQBY3WjkW6dsvYImjS7l2fPkVLKXiwjyITtEgEIYVJj9uy2tBNrd9v75RRNmku2JuqBExOimxJloa46vp0cIhDNdQ+XfMYJrIl6wF/HwzxzX0i10MEpKmavbZYZny4nQcr9eBenvK0o70UH19we1ZJFGw9iDtRPmndLCE4tUvOToJUpHcCwobQ60HRZu76jq+0P+kXJ+Ye/7TuqOkAsEh+iB0r+1Vanzb7e721lwsCcWX+7srqTBjrz1veC2kGJYSkISmSioebvPhes6ooIwH93yVSoBk6GgmmnII4RLqCtJz7LRzMnu9YBGTfk9lfaRRguDinBi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 02:01, Hao Li wrote:
> On Thu, Feb 26, 2026 at 02:44:02PM +0100, Vlastimil Babka wrote:
>> On 2/26/26 14:39, Shakeel Butt wrote:
>> > On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
>> >> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
>> >> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
>> >> than nr_bytes.
>> >> 
>> >> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
>> >> Cc: stable@vger.kernel.org
>> >> Signed-off-by: Hao Li <hao.li@linux.dev>
>> > 
>> > Thanks for the fix.
>> > 
>> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> 
>> What are the user-visible effects of the bug?
> 
> The user-visible impact is that the NR_SLAB_RECLAIMABLE_B and
> NR_SLAB_UNRECLAIMABLE_B stats can end up being incorrect.
> 
> For example, if a user allocates a 6144-byte object, then before this fix
> refill_obj_stock() calls mod_objcg_mlstate(..., nr_bytes=2048), even though it
> should account for 6144 bytes (i.e., nr_acct).
> 
> When the user later frees the same object with kfree(), refill_obj_stock() calls
> mod_objcg_mlstate(..., nr_bytes=6144). This ends up adding 6144 to the stats,
> but it should be applying -6144 (i.e., nr_acct) since the object is being
> freed.

Thanks, I'm sure Andrew will amend the changelog with those useful details.

Weird that we went since 6.16 with nobody noticing the stats were off - it
sounds they could get really way off?



