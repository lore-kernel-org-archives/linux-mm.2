Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91325C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC476B007B; Thu,  6 Aug 2026 10:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C44B6B0088; Thu,  6 Aug 2026 10:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC396B0098; Thu,  6 Aug 2026 10:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8166B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:51:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA54614075E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:51:36 +0000 (UTC)
X-FDA: 85071133392.02.710E72A
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id B06BB120011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:51:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XrqQZQD9;
	spf=pass (imf29.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786027894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWpFkxMOaVwGZ0w80zyQ1pa/gmhP6MxYxEbTBlhIS5E=;
	b=QBGbG5eQsF2vu0OwqjP9tP3koR9pAbvfvutZaIoTixt6m0Ig3K88o23JtXPioxBA8i72nt
	ghqWA9Zqcw9tjcUHDAWH26nBBs+CjI5QkIOFocS3NgBv81/fzlFQPXGBMSVO6YOG7hoKwN
	cioe0Iu+rPt0XVIOmdO72mEw8pXcgS4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786027894;
	b=NpcOmLI5WBaS9mx6njPOwO/Mt7MGzWNytpQ7a8cyRFc06GQXRqs8kQoNHaHzF6KzrdShqb
	6tJTXg/myRQQPz8KjWxMCNhy71yQHN/yf1xVsgU/X1EZ6CYrjuYfTPMlqM0GIJDaYluwv1
	IgB+k3kVZdW4glBdVoag91j2UUH/hq0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XrqQZQD9;
	spf=pass (imf29.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so6182625e9.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 07:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786027893; x=1786632693; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GWpFkxMOaVwGZ0w80zyQ1pa/gmhP6MxYxEbTBlhIS5E=;
        b=XrqQZQD9s/xmsDLyysQWZ5lgy1NlEwbFmy02tDm0OcucX/KaKvu+wrsj4Wa9RQ2kXb
         FF8wcjfh0T6K/b7V1dTu9I1Y1hSsWsM801X6p20DZk516YpqE2qVgoZxyhpaDYbVlj34
         T4a1LJnMBoxD3j8XvDABdONnJY+Lfkp1CkwgBG06oX38tqRNNsfQlo1YjRidD+EKCMYQ
         FjQdU/EnOaDUPQtxVNUIO4uFNgu7HOiWh5nX1DhRqmV/3J60TsCqEpiKQi7s4M3I7IIZ
         ME/qR8jc4rVoUxetyvG5cJjp2SXyJRb037MYLgKKTCbv9nSJ1Dd7pbKRs9lZAyv3e14a
         7nxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027893; x=1786632693;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GWpFkxMOaVwGZ0w80zyQ1pa/gmhP6MxYxEbTBlhIS5E=;
        b=YoMQ9EP/ios77eChDOMHm6zZCbK1wv6iWGVUliCgoxie2TmPK8iocPR/vYrgbSuNk8
         /wTxRs8T0GvPDYVXNbN+EaRCUmNmMc7P62HU0aAQi5oZZnf3jWj1XOQCzyatzlkhIjCP
         vGMoPar1razK8Sw+UaVUWQMY5QtYyYMP08/7SVWsIskt0WwVWg3mbdBrKQ3bqg5yIXos
         fq9P3+QKbNl82BNW3BqfxqZ6tW8ctXeNIh7PxeYDrHeaIr9wSmQA9Wia2idzzDuw6O9E
         vOFevCRolLaBHP2etRRl/D6AbzBtwtNJGwEbQswyDmXhAtG44B8tlImN4WiErM4vQnfW
         5jLw==
X-Forwarded-Encrypted: i=1; AHgh+RrR+6ZKWFxuNhd6A4Re6D0dKnCpOFOtexGc9bYNmw09uF96JwGeWBmTFPP6PFhcrk3wnL11f5tZUQ==@kvack.org
X-Gm-Message-State: AOJu0YyMWt4nXEdpBbibwvLpfqExvutDE0kTGCR+iiJki7LY6o+MZVNP
	6hm8OwXbSQ+Xen1aY9J3cQlN4zBYMvH2G+aqdOo1d08zjC9epoXZaVQBxqF6c1Y/004=
X-Gm-Gg: AR+sD11nqpwE/OxDsB489oaloLsud1Dcnqp0n6UJLBiPMrEKMdNHqzYwp6E7LhnwZmj
	UkxJUgUgH64pW5BqsPjXnrAUbyAFkZvjoboiY2dhkjQg4YBpUM2o/7Y+snPUYq51HtJSR9ysWnY
	KjQ/yXEOAHa3jNEeDs/yXhwnFwucM8YirhnmVmOgo+f10d4VjGa0l2IKFVUBY0Edim3jkFR1qFh
	INaWb2iuX7hiDP8jgl6lZnQAa8y+i2/N7YNu5jvBrKsMn+uu+1QfRttMfXP9H5jrQTuRKnxcsBc
	H1VpgRPH9GOYa6xZVLxHqMNOn1UazH3P3ZEwjvNZ1rX/nZ7759uKd0LwEZTuD3VDKDeDEO9PwXl
	6fM8h0MIyhUx7Pe+t20wAJ0yybO3KRJHp2zsIQ5C8b3WX6B/bhN1DzWJXsDw0jsp2h+pOcrunYm
	6D5pAsesCxTjofB/TY1ZfHLdOy9hytLRctV8tnmAbbEvONZS6DwEZOzgcmS4K/Va3ztga1ABmyW
	wpJwARJldon5fa2QMxOZVyyzg==
X-Received: by 2002:a05:600c:4fc5:b0:497:ff5a:38b9 with SMTP id 5b1f17b1804b1-499553f8440mr50043225e9.9.1786027892968;
        Thu, 06 Aug 2026 07:51:32 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995421b1e2sm85741405e9.8.2026.08.06.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:51:32 -0700 (PDT)
Message-ID: <cbe5e31c-1bf3-4b25-b85e-dc98bf0263f5@suse.com>
Date: Thu, 6 Aug 2026 16:51:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] params: fix charp corruption on allocation failure
From: Petr Pavlu <petr.pavlu@suse.com>
To: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: samitolvanen@google.com, rusty@rustcorp.com.au, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, liuyongqiang13@huawei.com,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
 <20260729123243.790023-1-yujiacheng3@huawei.com>
 <b5d285a0-1e72-443e-aad0-dcac32d00d01@suse.com>
Content-Language: en-US
In-Reply-To: <b5d285a0-1e72-443e-aad0-dcac32d00d01@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B06BB120011
X-Stat-Signature: fj4dttdxxhezdd5wgh71qygcrh6s9gum
X-Rspam-User: 
X-HE-Tag: 1786027894-190508
X-HE-Meta: U2FsdGVkX19jJOociFtAktwIsbsIXr+Jfaykiocax+ZNXL4Hl9/h+Geegurul6jh8O+zdRjmkkGcARBz6HAzLj/5WhlCmszLpqLuXNdZuh8ANw3C8RuJc2AOSKXHnl3Dl8NXE72MK2ok2JRpcFmmxB6szLAsJ1E0pXZwbfd1rso8/KvKFvwQKZ7Uy+YDQRmKQiZhENdvstfnpYHf1iTo8sCkiBACXnosHw4pq+xo3vRzIfMDjGHRi6pNBAwsQMRSF8lFJrJcI3KckWJu2z/2U/Vne/5Xg4lHgiESTV9elDDXpjOfBxIG/zpreCxkLOycfCud4Q7HOZeQL/5ctxJ2we2MGX+a0zQEBjEeV1Oxz7fPQDf00ugDmqKP+ujzLZvhbQQi3O1cJfgHJ0Ig1rz0Rd9AvLwBR3engLvhBhxEEUg2eXF/Yj7XV6rJAOtEzD5FkZA//aDVzrYeH0Y26tzjye4ok2hKUp6VzCRlvto7kB68NeVUvJjPhbi1z7caLA9Chs8Ds299ERfeZXUk1o5yCuYS+LetYkdoFM30E6VqLSpXela7yX0OzUqphublq/5YguvaGz2WZSj3r1wB1hkkjmzj4o+23iRxKZexL1QThAJAFYzALiA6GUCdPVJVkmV/R5Rg4KZvjLeyLjKdn2LKG8Blpan0AHv4cOsRTEeVQGZ6wbJYgNY16JKGXzlTD9v2KbQcHC0wyZbhLZF2oAk1/xSRPcDAg/D667r0vg50xYshEylKuujtLqtBOZSQSDAutI+TA5EDR1T9mQ9a2VxkGdyWPtYOoCkXItEsCQ/vM5qOSvXXZhbb2myl8eAkA77HHNl92q7YJs+F3pZERf77O9u0XXXy8QO56tDmtdyK9vZToYYkGp6zzN79nsVNpFTL8Wh3U2+nJRl0nvJaCx4n2kfzISU+3v2PMKJZ1lwtS5Zo4T7+STHYOnf9hyoQ5bMA3wtbtUOJ5kWREAPnPDg
 q2j0FHUy
 Z7MSBAewpAIxDkCbkbK1fbCCf3jMdRr0cid8Hak0B7ILj07AUl27GzyK4KR4gzHAR7XrFjBaLjdF3asluBO1gvKFF2fClYrFhHy+TTP0MNEzDm1poLLRatvO6U4tcYIIdZ2bCAOqGxHMW20Z886WElmSLDZW5iZg8Bpyf8KKCmhpIweyI+gqHL8OPMuuTQIwpSy6Y8Fvq8UbyPdd2hTP4W41fhMJICMYRzUwhum9bjL7aQkC6GEqcyLsbKWMh5uae9Pcz2mh6eJ8vxwpuw//eZHrHqPwuSmVU1V/TdXR63MlG4HfnIXGOwdqsAApRnDHuszbdVwOfXOLiqeHlYxXNO34ph1Vy1G82scdrQwKohN81+Vv06O5u+JNGStnihnc7w7n2eeUs5WYG5W4mD90pem4zPtrfAajnCdk64D21HSVq6Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 4:21 PM, Petr Pavlu wrote:
> On 7/29/26 2:32 PM, Jiacheng Yu wrote:
>> param_set_charp() stores charp parameters in allocated memory after slab is
>> available, and releases the previous value when the parameter is updated.
>>
>> The previous value is released before the replacement allocation succeeds.
>> If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
>> left as NULL.
>>
>> Failing zswap's compressor update before zswap is initialized can later
>> trigger:
>>
>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>>   RIP: 0010:strcmp+0x10/0x30
>>   Call Trace:
>>     zswap_setup+0x3b1/0x490
>>     zswap_enabled_param_set+0x5b/0xa0
>>     param_attr_store+0x93/0xe0
>>     module_attr_store+0x1c/0x30
>>     kernfs_fop_write_iter+0x116/0x1f0
>>
>> Allocate and copy the replacement first, then replace the parameter value
>> only after allocation succeeds.
>>
>> Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
> 
> Looks ok to me.
> 
> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
> 
> I'll give others more time to comment. If there are no further concerns,
> I plan to take this on modules-fixes.

I've queued the fix on modules-next for v7.3-rc1.

-- 
Thanks,
Petr

