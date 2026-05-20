Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C5FCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65466B0005; Wed, 20 May 2026 04:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A162B6B0088; Wed, 20 May 2026 04:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904D96B008A; Wed, 20 May 2026 04:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9716B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:50:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 311431A0221
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:50:04 +0000 (UTC)
X-FDA: 84787175928.10.B6D1DC0
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D15FA000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:50:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Cc0yWRxR;
	spf=pass (imf15.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.167.48 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779267002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHVbOPKY9Vb76fr8KkDuySXZ4b9eJ6v2RV2RgUHrSMc=;
	b=JOLTpzlIVoYoIUCrTRHyIxZKzHzQusjwM8c7THT/eeSwF0e4/FZykQQtT0SSkMZ7bXvKXc
	s4qhZW10qorNegLqKQJq7VZMrdxPAd2AFf3j3qFx1FkRZ0of0JEx+9HY1tcUOiTsv8Ihll
	aDZLfwp07QBhBYJ/S0l2FI9WMMXqOIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779267002; a=rsa-sha256;
	cv=none;
	b=j6rd1qBKNiN674eDIIzPM51dZK9EOlFnp+5jiqoSJkNqS38EIblML4dsPcmeBqN8vixp3z
	lM7HkX9wwfXye9h5KG0rb51Z5iZxBGwO5QKUghh70r+LsI3zs58uLs5VHDcWXsPW3ofrYO
	rbzqOgJ4xcKKQUu508uafB6YEihvjHM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Cc0yWRxR;
	spf=pass (imf15.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.167.48 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a4002b1183so367038e87.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 01:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1779267000; x=1779871800; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHVbOPKY9Vb76fr8KkDuySXZ4b9eJ6v2RV2RgUHrSMc=;
        b=Cc0yWRxRHwlB+RcYT7iVfxpIxt/OFD/uPNWzDaIOekdAoWtV09Vyl0npZSVS5Dnt4t
         NzlRiU+Irb9tprG5pBPuwYhIo6uJdyl7WG7y2jAU2NQF18FkkNrBD2LNiNXLr87xpKyk
         QFELy4Y0J2c/xCYYsxDBUkqESRSw1Yqmgts40+8EEMeabAUbmN1UCSj9FXm+RZM7gOaA
         KT3hZK1YI+pybA7WDTdD1ItYkJs4bhqQj6oW/v+7ekdnIJOt9AOqCsSiFpwb5wtvLhqc
         uA3vaAEl6MX6JQsg5ye+LQhkxXm0NKCmgXAPjWdd5kSizb0E20bPviwL3hNv/mw2Y0/j
         Lm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779267000; x=1779871800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AHVbOPKY9Vb76fr8KkDuySXZ4b9eJ6v2RV2RgUHrSMc=;
        b=mImURu3c6EuB1HMmTLPnqCd/NKLg/m3FVVTLrndb1clzeMRCqpvT3DbumIu5Sbss4w
         1aU+J/JDlTbvOsax9KJ55NZuqNeGptutqPzSE/1xz89ycbCEIgD9P21nzVMKsNJawiOn
         jDbCbMAlNcnRfEMsnL6wFvGXrSHoCb6v6UKxIBu12PpQnOVCYNmZX93CdV7qHZrQ5AWB
         VsbY5a4Npi+hl+b7OFH+6RO4PgtvcPrORo3ErIEEc/IRo8VHHAZXLLGDxd+2v9DhQKn7
         fpnct4WW7hyDe0PpLlnt1RpsuEpmSDny1vujpEd++BDitNIvzfKw1o/Oo3jyVxtjtof9
         +m2A==
X-Forwarded-Encrypted: i=1; AFNElJ+I4oDDcBceT/vRTUzy6D5iDqweA1oSwEp761soRsXpDbQjZv7mmFxi7I8+iCNR/ctn7raxIcITpQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2gzIcmeLYJ6Mqc6zWPaHyRy9Xgb6jrj0Z3Mm+PXIBvtNlHwZ4
	b/01y/XaBVIF+q5t290M1qMdzFLTsY/iatixf3Qn3J72Q/NMpZWTS3ZkOex6Y8CA9GI=
X-Gm-Gg: Acq92OEQjhJFShRpgTR0anpEE0JleMqnj/kjqazIXq3Ik2OcfSDkctjB/lVmTNBRHTP
	qzBGAXrMZBlWqu3bHJsCTdD9s5+aP/94rc8Bp4PfQFQsadnJRcSsDWZ0WOcJrGAJbHssLRhtoj+
	maKf3xHMKxuLiGK+DWvCk0hbECrM99U4APh02ffa1F8dOqwSfdBveViQE/zBJMvpa4iX9Os5BiK
	dHaBgbzTgIy9WrHSBCVfSQWstMJkjl+9DI/aGcKAJPFB8rvOOJ6iS9GrbJ3mMOhkMVLJmrIsOzj
	kWMcsd/PfNDE8RdqqK16q3vP4tizBN7eofQFTYMQ8mIxBlgzx3MgrDY1wRSIaB+IJhWZDu/v/KG
	GwSViQPzBpBrOc4k4hGJJ1r0Ad1hLmTofq7YV5NTLjQLIGk5gulC4+wyGKbOoGyNi8aL+U0FMU9
	xd4svz8swyd+zxfsO81H7lBqqTeW+kyxv4j7ieuQW3Rei7bxrbHElkEYqZyizr0rICVE0wtqBBc
	ZuaSQ==
X-Received: by 2002:a05:6512:3409:b0:5a8:7396:63e3 with SMTP id 2adb3069b0e04-5aa0e74a2cdmr2752689e87.5.1779267000074;
        Wed, 20 May 2026 01:50:00 -0700 (PDT)
Received: from [192.168.1.100] (91-159-24-186.elisa-laajakaista.fi. [91.159.24.186])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164cb606sm4751429e87.63.2026.05.20.01.49.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 01:49:59 -0700 (PDT)
Message-ID: <ce867744-3efa-475c-9a14-89a09dfbd27e@linaro.org>
Date: Wed, 20 May 2026 11:49:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hugh Dickins <hugh@veritas.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
 <ag0n27-TUg6BwKfK@fedora>
From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <ag0n27-TUg6BwKfK@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D15FA000A
X-Stat-Signature: x97gp6k6efyegjy7w4gqdojikjih3mar
X-Rspam-User: 
X-HE-Tag: 1779267001-944149
X-HE-Meta: U2FsdGVkX18HGxmM/A9Q/6sEkNWWyQTrcJtw+EF73L9zTLrA2w96tOcXsXBthSOd17Y45jgYU5YElvGNh+61fNjJQ9vvHl8VRRb0J4F3Wh1h9/VxYxDC941LfVRO2cvY+GhG0X4pZyRHEZbGii7vMMj11epF90AS/QBEjp6dSor8G5t6KdSuVY26YusQXkCIf+s9kt5vijVbCKZj9IzLf1Igr5ZH1iak+YHtghVSIcLOSQzhYSIHUtrsTvdnbDRIpEW8UQEZWLi0GbmvvOegaeA40KaHBzCjK1glJTiU95MeP/RDyypa+Vfkd2krpsvj25o5+ri8at6W7Ru0ZRUIU3nperV31o9XXF2Z/IeZ783rgaAILmR3KUnu+l0CM3HELgjhujRJD76BRhXVsflXIMR7dxo1tWJ6SQd48K5BE3ribRLylifsiVREB8Q5ghMHYPPqRoL0/OmffYTEAmpwxaUCs+IInZCtKRxcRnE1ggKU1SXXRKgBcsQUJHbT+hG4czvec+wRwxF/ibzN8Hgzz+E2ICCeo2D5z+PZMTmt5QS70YV2KR+XW63v65ApsdFZ34/PgSKWHYLypTqmO9xjDc+zQqgw65rcunTKS1njmD1Ge4RkZWH3CFsOYy0FZYi0LV0WHAeUw3nOoOFw7N0hT1sEx9APXe5cTdt1cnorrf5QQEYu0YnzPgyklKAnjmEbHSNG2dlmGQ3QVvjJ7tt7BKlmXzzx14mm8qVJfdTlQTzoHbqAfxHlGEXSJgyrjfprsz08Jn7uIo/QwT5lSaSZNJalTsqI+PUyrqgRyAAEvFmDAlGeL8f/BX/Fbe2WlpDahTIYS1QEfd6VXDv3BLzreyxolkgIEUvE6bqT0+uFxTRtFV36Vsc5jzfSQm8UaIKG24FSqMjlI9cUY9V52acjIlwS4fU3GYJvmnxdQF+N5u8HQOMTV2hpfDNO3WPcLLiQTaSjDRBVucvcIvB4wcn
 PaUo4SdV
 hI3b7tOEGPq70dWibVSeCbkQcl9lUM+1OVLvF++xF2IgC79E7oqzIMiETJ+5vYFt+ASC4Rlfgxc1Anb407EsU2eYM88jPSTPh2Cn+e1jUcO88pCnBXuRkzOdUOV7wS48eQlKVNoh3t9H94srZ1e5J2KVX+BDHzlBmEKGGli/6BmQWPV+eIMWx7sL1C7nNbv7w4v8bNzJGXmUw83mnqPYyPxzTo1UaGMOcs13hmb7hdy6gZlGPg4an36+Gq/EidrFFHqeRQZAG0xGxIXzzv7orp4PiaC7IS43FaLUL64fXo2rFa9Rup4guDhKtbJEHgB+MOz31
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hao,

On 5/20/26 06:21, Hao Li wrote:
> On Wed, May 20, 2026 at 04:10:19AM +0300, Vladimir Zapolskiy wrote:
>> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
>> names are blindly used as symlinks to slab cache objects registered under
>> /sys/kernel/slab. This kind of symlink creation is successful, but its
>> dentry is obviously broken, as well it breaks the access to the list of
>> /sys/kernel/slab dentries.
>>
>> Likely L2TP protocol renames cannot be done, since the defined protocol
>> names are exposed over /proc/net/protocols for years, but the symlink
>> names can be renamed, because they are yet to be properly created, and
>> this should be eventually done by this change.
>>
>> The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.
> 
> Hello, thanks for the patch.
> 
> Could L2TP possibly be loaded as a module? I noticed that
> __kmem_cache_create_args can also call into sysfs_slab_alias. If L2TP is loaded
> as a module after boot and dynamically creates a slub cache, it may bypass your
> fix..
> 

you're totally right, __kmem_cache_create_args execution path should also
be fixed, I'll send v2.

Thank you for review!

-- 
Best wishes,
Vladimir

