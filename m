Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D6BCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 07:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812446B0005; Thu, 27 Nov 2025 02:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9366B000C; Thu, 27 Nov 2025 02:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B09F6B000D; Thu, 27 Nov 2025 02:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 541D16B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:59:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03AFA1A08F3
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:59:18 +0000 (UTC)
X-FDA: 84155636838.20.FF71883
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id D942F80005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:59:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MYJzZeXL;
	spf=pass (imf30.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764230357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9iBKcpWfLkBP0f8MQKdR3ZLtXd1IIP5cJjZBkNDvwo=;
	b=8AQXZ5OJG1Oryrqt6vDwwM50H3BjAxVQn8sCwLVP5eJWUDBGJWVKBwaOFx6kvCuLyA3VRc
	6f85uQquOMhUG1DJSRNfJ/W/RgsLKLX7Ox58o74gk9+i5zywXhBpo26a5G9tx0+NBeHAHn
	VvZOi41iuSfGzIkr8ZGMQzjF0uZJmZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764230357; a=rsa-sha256;
	cv=none;
	b=DB+eUYnecVE8A4w+sHDiUomJfJWi9+BmA9rvty5BS7vIOhhnYkrgl7BJ18XcNcuy8857Wu
	ZOZa3MN9UAxnvH2jXsz+FvIsu5TWCr90hty+MkhtQv90SH8faRZghowcxFo3gdPRpXF9i5
	+sgqyg0zWIV3eyAwUbYOGpOGQGf0m0c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MYJzZeXL;
	spf=pass (imf30.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso949061a12.3
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764230355; x=1764835155; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=z9iBKcpWfLkBP0f8MQKdR3ZLtXd1IIP5cJjZBkNDvwo=;
        b=MYJzZeXLixTZMrnb3KZ28Eth15lOLwZU7wYJoKBMfmy6Pj/uC2A6kCHiAID87qL0mm
         4GOyZIQjDmUPiWYn3y4B2rdrY3X0Ukpxt0X0hPJrL7MuUZEe9b/6+g+hmAr+we4oIG9M
         J20K3bfBUV3gaFXpz5kUP9S+bBcAscff9lQyJ5YfNlmDES4hahk+c/Iq4XhLIPsQGExq
         oet0ZVWuuBxG7axsajJYEnfWvDCA60nnIvYALzXfgGrodB7SvqStyA6Ez1mi5ErBGz7m
         uWxBa2MMm1ZCNmeQ2gRYrAZT+bJMmXs4t9OS8yEwlw8xiAGblWS9ep/2PLhtv3Pmwlwx
         40WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764230355; x=1764835155;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9iBKcpWfLkBP0f8MQKdR3ZLtXd1IIP5cJjZBkNDvwo=;
        b=fVuBPTQHIiZ/Xax8YSOu+slUHKvXpiXZdxP19sY6m4F34Ce52wqEdrqy5vJqPHH3oD
         8d5qDLlobCggtUnkt85wTd4E577R62Io8NaOMSObivsQ4tVWF7yhbzYtRGI1cZOOLisx
         Flj6JAElJnq5tmcA9gCjkOvTJvYev2NmgIUSSwRKwEi76ZX7enp6X8ey3dRkh+K6Y04W
         lBNxFfOF5ND+dGVyrED1Um2XGw+7ZwVitZuezFmdNX/qSON3ePg6VSCEjOGyPlV9w/AH
         eHC3+046sZsonu80ZQiq65xwe7xHUbgN9gqhZRwYdwJeE4LuQiZVyazsJVJ0XNWVQ982
         HMOg==
X-Forwarded-Encrypted: i=1; AJvYcCVRg+VMvcIERAUhpwXoq0ycYOcLVYz99Lla5hr9keQuqn690yehKspEd9Q225EFmUYXRO8FY+bS4w==@kvack.org
X-Gm-Message-State: AOJu0Yw2Oo2cViXXD5eko89pL76Ohx4gtHp3aikpNOxfK50j0ZDPe7Qr
	RGMQVzontlZoT+e02IU4iC2Lm1fZYBFhq3xcAnW1xNXcQTjL8O2DL0yv
X-Gm-Gg: ASbGncvlUJSCNYqLvlcjFE1qvRCSdYnhBrxGkmez5alQ03kEQrXvIscri/nno7WbtZg
	WRjyufKR5vCv0XnAiQ/EkUXZGWGtw+8D1i1K+RpTZHUIqyXu9QT/dEPBcTp9rIdCBmwyt297dpx
	q6d8cuLG778/3209fdBf9s/meqKnCFXBsuD9xAtkSZKp1engKHHUITo38vJ+Sz1hIK3bX2/LAzC
	PltimWEPuwrrKBmFjrQa3/E4bF9jLw3dMy4+38lYAOcbGMknUlNbIDydYSisxGuKb8eeu2885BP
	vsuXYp0+3ZKnj3XUllUOOey1tHmUMPhY3AgI0ffsbdolz2DeA4GV917QhpP/wn4lmJvZj0UJzX6
	eLqIQ61G4t8xBZZ4ABZ7oCie793MrO8YZ92VbyVNQFzdaZSN/WNmt7r9Mu/z1oRbaSPfOQwhsUd
	yGF+/ycIeJDtAa1bg=
X-Google-Smtp-Source: AGHT+IGUOKW6F5FS113p653lsKvlpeK2sBEh6Ngnt2v9kCLGX4w6J8eiuyMeBBixqNwPaFIiEPaPKQ==
X-Received: by 2002:a17:907:7fa2:b0:b5c:66ce:bfe6 with SMTP id a640c23a62f3a-b76c558f2eamr1050311066b.55.1764230354708;
        Wed, 26 Nov 2025 23:59:14 -0800 (PST)
Received: from [192.168.1.27] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f51a9819sm97759866b.25.2025.11.26.23.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 23:59:14 -0800 (PST)
Message-ID: <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
Date: Thu, 27 Nov 2025 08:59:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
To: Aaron Rainbolt <arraybolt3@gmail.com>, linux-mm@kvack.org,
 cryptsetup@lists.linux.dev,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: linux-kernel@vger.kernel.org, adrelanos@whonix.org,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20251111231835.1232ad8f@kf-m2g5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D942F80005
X-Stat-Signature: z1hxrgfouj6sutkp5rdarruk4esixuxc
X-HE-Tag: 1764230356-160893
X-HE-Meta: U2FsdGVkX1/n25GO16CgDlDfUXSlKcLBzGuqP0zMOy7r6We3LMY/m1qq5R12E5pJWPixQXkpmuulRk0a05icKYayavMdFEoGFjnJPp7efuMXpfoHpdWsBrbvXMUQhBfm0lYobzvb0b+DcnGhvS6dBcOgaIc2XzVSVjE4hCCQRB2mFDztUJ0DtkwRQUojKQ3fKynw6ZqHgFFP3D3zjogQohmr3CoNR/faxCJAEpAoTUmgxR4WY2h1mpIfQMFkUcqlS3eZG3V4kZ88bgxZ076GHCLY2EYPFGR7leF4W6XOEwYa8QOXl4vtg4ueTD5zUPfYDFtvjd34xAvOYCI/WNKSgOVTJHohDp+oxYEGAQT5NqKhdvXmZDRyo1Bh3arN6P4bEJcDsD4TTw3eqoraXhPI0ASZep/9oOko/htcJ8QYX0gpQ7+GOVwYbzmGko6DyOS24XuCzNz8wEOMnoIzrhPO36zk0MqkHJRVaUPyi45nljB3MOnBUeHJSyZhYPOIYT821WAaN9zMJqgc3jM2oGgWc3hi0ucjokJQTteUtbf1LIssUnEC4HCXOPw5PyEBX1D7EkobJ5dMgQ3ekWPNVEX8G+oH/bGedyGbW2xdlWAycc74Pgmgj9WGjlW0SXiPLglAN7b6ytBYaMcC7/91bsWDAM537IkJtIPpysizUpCgbbRl1EGSz8Ly0+Kz7vpc4FG0YBE8+KbVg9iCnBWxusjq/u4fXidOgZa7RcfDWWdqFmERJ343GEiaGX8AKPU+Ab4dxw2rtcyXhgPb15RwU+BP5XECzhtuKZz5pBM+vjBwJLFCRHogjPzCn1UdtUaQ/pWtASTVOUkDiHMu//eUfI5Y8ae5sJq5c6n27t8vmq4TKO8yvs65h+kqwi2TOjU/97nz+9y5t6wsoNhLOxHeIl1ufXX0WT/+uNqNwzL+eSd5SHw3InOHi1a34R4lFK3yX2y18suOUv6IHwWacmdGj5e
 M3PvYYtL
 4V78MzMxXgQgL4+8tmu6bqoeLIWnVjYnxVCkFhwqNXqaEs33VooZR2EbmKltE9CrlpgDA3i+HsKWTpOHaczHZNPsBZGgfJY65GuX+AaOCFEtPGuUUQ+Byebe42TZxDXKVXhyckXsoUrm4WWgqWbJmnS7COvzfdE00s3RBIwYvYDvCwmAMB2qzADDw+0MU0CMY6UyWwBHDKt1G9z3cz1S1krfOMD8s+cvwYR6Is+rUEIzW12rKf4zcHzq5abX2KNkFVzUnqAcgATM4oUZLzMWEH3FPk/yAotVzfQgUtx+ewG4De9n66YrHlt6VE8Pqeix2mhBeHQ0YN6lr1hMJWtU0Dq701qCc238bduf8pa679l+/116/WHTdaQePW19HPzAVijA0hIBIKpycSKmqXOfEN2z6p4olDXz78K1GJpwNOoazKHYre3+7vS7cSb6To/lKbkdxYLHFIlSrLSEOf+nyUcgYbSO8ZEb6a1/d6IqQhT6WnDUE1ziDbv+EGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 11/12/25 6:18 AM, Aaron Rainbolt wrote:
> Not sure if this is a memory management issue, a LUKS issue, or both,
> so I wrote both mailing lists.

It is not a LUKS issue; cryptsetup/LUKS activates the encrypted device,
so it is only the kernel/dm-crypt handling IOs.

Adding cc to dm-devel as this would be another combination device-mapper
and encrypted swap that could cause issues...

However, could you please specify exactly your storage configuration?

 From the subject, I expected you to have an encrypted swap, but it is
not clear if there are other encrypted devices.

Please paste at least lsblk, lsblk -f output, and also luksDump
(or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.

Thanks,
Milan


> 
> I'm seeing an issue with both the latest mainline kernel (6.18-rc5) and
> Debian 13's 6.12 kernel package. When physical memory fills up, the
> entire system locks up hard, as if it hit rather severe thrashing,
> despite the fact that there appears to be disk cache that can still be
> evicted, and there is ample amounts of swap space remaining (gigabytes
> of it). This issue did not occur with the 6.1 kernel in Debian 12. I'm
> seeing this occur in very low-memory Debian VMs, with between 512 and
> 900 MB RAM, running under VirtualBox and KVM. (I suspect, but have not
> verified, that I'm seeing similar behavior under Xen as well.) These
> VMs generally use a swappiness of 1, though I have seen a lockup occur
> even with a swappiness of 60. The filesystem in use, in case it
> matters, is ext4.
> 
> To reproduce on a system running Linux 6.18-rc5, with :
> 
> * Follow the steps from
>    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions,
>    section "2.3 How do I set up encrypted swap?", but creating a
>    swapfile rather than a swap partition. I created an 8 GB swapfile
>    with fallocate. Reboot the system when done.
> * In a TTY, open a terminal multiplexer (or something you can abuse as
>    one, Vim works well), and open two terminals. In one terminal, run
>    `htop` so you can observe memory and swap usage.
> * In the `htop` terminal, sort by M_RESIDENT.
> * In the other terminal, create a new file `test.py`, that will
>    gradually fill memory at a relatively fast pace and print an
>    indicator that it's still alive. I used the following code for this:
> 
>      import time
> 
>      count = 0
>      mem_list = []
>      while True:
>          mem_list.append([x for x in range(2048)])
>          count += 1
>          time.sleep(0.002)
>          print(count)
> 
> * Run the script with `python3 test.py`.
> * While the script runs, observe the growing memory usage in `htop`.
>    Swap usage should start at or near 0, RAM usage will gradually
>    increase. Once RAM usage starts getting high, some data will start
>    being swapped out as expected, but after a short while the whole VM
>    will lock up despite there being gigabytes of swap left. (On my KVM
>    VM, the last time htop updated its screen, it showed RAM usage of
>    712M/846M, and swap usage of 328M/7.40G. The python3 process
>    running the script was consuming 551M memory. The VM is entirely
>    unresponsive. Incidentally, the python3 process also was in
>    uninterruptible sleep when htop last updated its screen, but that
>    could mean nothing since it might have come out of sleep between the
>    last screen update and the VM lockup.)
> 
> Under Bookworm with Linux 6.1, the Python script would occasionally
> freeze, but the VM would remain responsive, and the script would
> eventually resume. Even with kernel 6.12, both unencrypted swapfiles and
> swapfiles that are technically unencrypted but live on a LUKS volume
> both behave as expected. It's only swapfiles that are themselves
> encrypted that seem to trigger these lockups.
> 
> I haven't looked at the code at all, but it seems like maybe memory
> LUKS needs available in order to operate is being consumed, thus
> making it impossible to swap anything in and out of the swapfile? That
> seems like it would cause these symptoms or similar, though I don't
> know.
> 
> Let me know if I can provide any further information on the issue. I'm
> happy to bisect the kernel if it will help.
> 
> --
> Aaron


