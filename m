Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B844E674BD
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD096B0005; Mon, 22 Dec 2025 10:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B256B0093; Mon, 22 Dec 2025 10:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FF16B0095; Mon, 22 Dec 2025 10:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 457DF6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:03:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3B52C03A5
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:03:27 +0000 (UTC)
X-FDA: 84247425654.17.1D07002
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0ECD810000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:03:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GS8CnSIr;
	spf=pass (imf05.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BovpYoyCqPQI6cHyERY9sM0XnG6cSj0PGe1+XI7CW4=;
	b=ZSEsYmMUUiOkxA4xxhT422lekv3jGEHmZUqg8ZtutSGyz8bcNVCKqp7Neq1lDUJWqiefVn
	JXpe5FFAsEkC9mZBnnnALbha8g396HBN6l5+LGwKHgl05/JL5dIRxVaCec+FDueMDGQSJb
	x96D8pCllXxGrggEel7gayG0Aw8z0vE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GS8CnSIr;
	spf=pass (imf05.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415806; a=rsa-sha256;
	cv=none;
	b=38bxMiwmfHBBS6pW/ya4C3nin0jysMoZqWkXwey2r6MWjZivDEvCSrgWgoRZVOYWLJBdL8
	4jk5HnuUqGxWFjyyRSpmI6wxbNgOd/9Evepf9fgAiAMaFrIV0epBJHBoZ+kYgg1kN39pKI
	FrSvH8030L7FozBZe3ROzODxEtiqie4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477770019e4so35197975e9.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766415805; x=1767020605; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/BovpYoyCqPQI6cHyERY9sM0XnG6cSj0PGe1+XI7CW4=;
        b=GS8CnSIrcrdWE7zgFilsIl2i3+Vri8YyQEwGPuF32OCtBkvowkkRj3FEDsL4pEAdS1
         g/Vdw9WYb2aw2L2oaiwA7nYifUeZV9NncxvB5N6d5hA0aPmmKqfEie8QjI1Jw/ka6wx9
         nTvX/0Zu5CojdF9xqJDHw81rgw7YfnyUJK/f27lpyhG6uLnkbHXMhBLmJvBi3/GqtlOr
         o3+yBBKWZ30V1ixWf5P7JgsTFZyeY7YzSshbT6h4GiBvS5x+bvrlo+tnDbw+5b8/utGJ
         P5kKV384hRH035+HDjgHkfjbaFybLkOJu1hbFvXKhe/S9Ui5ohxspZ9s1GJmd3Cng6zO
         062Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766415805; x=1767020605;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BovpYoyCqPQI6cHyERY9sM0XnG6cSj0PGe1+XI7CW4=;
        b=UyzZlkYLvSzC/gvkaet238a39dpFLmAM0tbSoEWOljkeUrc/6ygHxs12p/McPofPuz
         m798hUN9Z0WQDfLwt0htfHTTaqxONAC1kCnRuAPkHddI8hfZlB25cvkieUS0gzxMZ9FW
         FFsXWQDTF1TqLPw4nZANNQxI/J3m6cjaV1HLC/c8gJ9dtTtiiJrY3VPs/B2QzEwac+jb
         O8+j6UHL/gDbdA5Ii/9t/KdgJHnpBFtqn7b+FTzcbc4PItM51F+oF2TUfNkLvwGU4TH7
         cFdg6xVgPXcdHKH7lNldaauCDC3eRuhy9gECrJT4ohtBvJtcVE0InVxBcQpeB6gkmKw8
         +Y3A==
X-Forwarded-Encrypted: i=1; AJvYcCUqWy6akVI5VQ92aJmElDTaVlPtkqjY/pU4ACYT9xjOcZGC9s1ia1m5U0BzHGA9FJD/akrsVvrfiw==@kvack.org
X-Gm-Message-State: AOJu0Yxq0NFtGS41/cAkcx/ec8NTSeYrTi6w2jn9SmaIhfOsY3db4HhP
	R2jrX9/aVaC+EixoIYdN1vT3AE1Ps3cUdpMmcKzUkp6vsIqT1O0aChKw
X-Gm-Gg: AY/fxX7JhIFWerJ4qYY+h2rDybQ+y3l2bgxABY/XRwiAX3XLPw7ifigQxU3G/sn0Tpy
	23D2IjtvKb2AlrjhD5YeVTEYATWOf9n/M2iB02VKH2Qxj15DTJcMw2qJS6BDNGXnhk//kEUdPnd
	kB3PCiaBc+uSrSlNOBSEUGTm1X9bpQdBMdXb3+S+I8yQfRddV/A+MeALOf+9zZXNknjACXJeeaL
	Gnp0MtjvOkEhcAf/As4hAucyWOFJM/Sduex/Tasxufu3dRNvUV2/lxXGRErlq+elLhOCEzUR9SJ
	StZtIAgbqGFwIQVOYYdzrobZoid4rir4XAlMQEQCax2QkZTykXWG0j1K4WrUsVlk1B9RCN/0Wx3
	ZiFmHto2qod3PGXw8f1Bk0Pf/Dxr4D+uxOkoQizCWR0y+fyLj3OepU5tdBh829W+m+rCmKU20y3
	b+I0eTKO4TtorWmHE=
X-Google-Smtp-Source: AGHT+IFJuusyQ+1Mz3/8tYi1eqLylmqECFtDDXhQgv1q9fY01NTCrKY3AspjaGJTpIOiZ62UGg1d9Q==
X-Received: by 2002:a05:600c:4fce:b0:47a:935f:61a0 with SMTP id 5b1f17b1804b1-47d194c659emr102417425e9.0.1766415804486;
        Mon, 22 Dec 2025 07:03:24 -0800 (PST)
Received: from [192.168.1.27] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4325dbc522esm11740249f8f.11.2025.12.22.07.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 07:03:24 -0800 (PST)
Message-ID: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Date: Mon, 22 Dec 2025 16:03:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device
 mapper devices
To: Askar Safin <safinaskar@gmail.com>, mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-raid@vger.kernel.org,
 lvm-devel@lists.linux.dev, pavel@ucw.cz, rafael@kernel.org
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
 <20251217231837.157443-1-safinaskar@gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20251217231837.157443-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6m149mfu8h7iukk3rhr4broeyck4d5k5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0ECD810000E
X-HE-Tag: 1766415805-796686
X-HE-Meta: U2FsdGVkX1/WZlvh5g3Ztx1075I1AKdN8M0aABkjtk0hX270bMgXSLNYfV+JnmAx8QF3SwVJIpeGY3125/gaqlQcGzbqUkCkcJJoyuW30fRaprTI/yFivSxXTKXSgcJhB8lgXeLBPw1T0DP3QAh4AcMM3VpjxzFxBCbiNX+buf+vC9ZNPmPdDc53hQhwFw9r7XVUDoP82WLuyyrqvUuYsVfOCBcP/qtOttu+JYhviq1rF0Ge0egPMh2Iy6MfJOJA/rNt5eFqNTLaYZTXdvISrblLIYkXcoHtXtgNjhVim7ByUAAt2YYhlEYNo0OzzH2WlcKeA4/sEpe8Lf9ncYJ++o41MrwMqa/cHfyttYA/0Yza3gV4OPUCuawFIHe6pwdBNi29anI0xDwuOFAi841S25vFJycRIaMbg4SPoyLpwCSfksGiR43ctGTUQGrOxmUr/TPk/kYBQAei+HsG5A4QUd+84yEM8BUUI5VfIoTY5TTG5fJIis3Cchf3yoH3SiC8/89f2zEAH4xFYjaAJZHXkmFdpXMLg41HwRw59XDmgOTKRpiLjQKVB//rFoyBhlOucBBfUpvOJEZsMVKKtsMT2B9as8hqr5pIbPL0KIMyEhqZ6ghWF/asVN/IsiEMoj2WWkaCzBE4D0vzbGQ83QSJwx01NxYZKCQB7LxR3qMps2VZwDnIMINBL5PLpkGp62zwsT7sbmSjoHPiE9jhiXkor5CuQJJxlK2qQIwh7LTomnv3A3pepYf+aOhIEOu2iHkpuCEAOVwXyUC4CWoXPykuNbBRSitPEpkfso8YKezCtHWHpxtJFBlx6dxUbzgQHa+9RH7ZmWnMia0rVHoBrHtM4Aodap6mBrf5s8YEC5PWeqEG9jGQN/Vsj6RU6CaVccdwOIYl2rbWK0Wf2Ny/t6brmPwn8C271748gjMD5CuoszlKwSR8aNbEetC3qqnbw/slBpkUmAcvWjrL6kjiz9E
 or54cmjI
 siT1NdhCdDA+qhTwhffX/qr6qQG1nz9AdFF1f041SsgQnoonPLbyiS/oxtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:18 AM, Askar Safin wrote:
> Mikulas Patocka <mpatocka@redhat.com>:
>> Askar Safin requires swap and hibernation on the dm-integrity device mapper
>> target because he needs to protect his data.
> 
> Hi, Mikulas, Milan and others.
> 
> I'm running swap on dm-integrity for 40 days.
> 
> It runs mostly without problems.
> 
> But yesterday my screen freezed for 4 minutes. And then continued to work
> normally.
> 
> So, may I ask again a question: is swap on dm-integrity supposed to work
> at all? (I. e. swap partition on top of dm-integrity partition on top of
> actual disk partition.) (I'm talking about swap here, not about hibernation.)

Hi,

I am not sure if Mikulas is available; maybe it's better to try again
in January...

Anyway, my understanding is that all device-mapper targets use mempools,
which should ensure that they can process even under memory pressure.

AFAIK, swap over a device-mapper target (any target!) with a real block device
should be ok. The problematic part is stacking over a filesystem (through a loop)
as Mikulas mentioned.

If I interpret Mikulas' answer correctly, it is the filesystem that could
allocate memory here, and it deadlocks because of it (as it is swap itself).
So I believe it can happen with other DM targets too.
(If I am mistaken, please correct me.)

I wish it could work, but I do not understand kernel details anymore here.
It seems we are still in "a little walled gardens" communication issues
among various kernel subsystems, as one of the former maintainers said :-)

But you asked about a real block device, so it should work.
I guess it is just another bug you see...

Milan
> 
> Mikulas Patocka said here https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ :
> 
>> Encrypted swap file is not supposed to work. It uses the loop device that
>> routes the requests to a filesystem and the filesystem needs to allocate
>> memory to process requests.
> 
>> So, this is what happened to you - the machine runs out of memory, it
>> needs to swap out some pages, dm-crypt encrypts the pages and generates
>> write bios, the write bios are directed to the loop device, the loop
>> device directs them to the filesystem, the filesystem attempts to allocate
>> more memory => deadlock.
> 
> Does the same apply to dm-integrity?
> 
> I. e. is it possible that write to dm-integrity will lead to allocation?
> 


