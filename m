Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B626CE74915
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AE36B0005; Wed, 24 Dec 2025 07:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08CE6B0088; Wed, 24 Dec 2025 07:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14CE6B008A; Wed, 24 Dec 2025 07:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC4D06B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:26:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 540281A01C8
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:26:19 +0000 (UTC)
X-FDA: 84254287278.03.DF6EC5B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1236FA0016
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:26:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TryXjFx9;
	spf=pass (imf15.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766579177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFaMyaLN7ofb8ca0IqdWrpz34r7dd+k0wM2WCDT3KaE=;
	b=3rSwBWDDowR/ZmtyIzP18LQDwYH7F9ZaraT+AQDBu2Iub7sOEJ9hWq2shPQwh6dJZPF1bd
	rQutRjhMvLAuEbFJ/qUb/3Z2r8JL2Sg0VP5C0/RoUMA6gZYDtiYXt6Klbath6z33hH5OOL
	ni63Bsik4S6GmKbAEhwiKJt6EaZt0rM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766579177; a=rsa-sha256;
	cv=none;
	b=QH1kj1wNU3UPIeEs+WPKgE29/bemCjXcSB1hrk0ldrsFJRZnY+MTw1hrx62LbmTSWNMvfC
	gO4J7vCtkAoholNeMp0AeK+CJ8oQkeg7ehNJptGSvBGirHaH6Ipc1tXqHJ/Tl5R+9CuoqL
	RQDsRHndUU/w+z+IxqtglhEH4RjR3LM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TryXjFx9;
	spf=pass (imf15.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47798f4059fso4954915e9.2
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766579175; x=1767183975; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kFaMyaLN7ofb8ca0IqdWrpz34r7dd+k0wM2WCDT3KaE=;
        b=TryXjFx9Ig7gnDkp0tL1UMVvLsbYuTJA7rETN1NsohuJYyhwP30QqPxt48HfaHgEpq
         T0cUDLcy8HDsH0fTKt8mP3tfFFNSudQmSvUzTwOhksCEsw4pESUL74hRWt/V3IZWeDSv
         rTLg6kb3LmK10MJmwOE6AapHQ0fLdXhVn1L4vizJcp+uXWFAEHVtonUEJDzPPN7DXMTf
         WINVEodWdqNV5IUmSPx3AYXc9cxIy1iKg4SFeSMIz1I/y4YUt+4N5VG97jJVyzdXoElS
         AiJy/8sJ06u6n+9g3whzsQdGGB0jhHzEBkSURF6gk8AAMtKCxIaPCwQNR8Gj/RrQlteQ
         5Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766579175; x=1767183975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kFaMyaLN7ofb8ca0IqdWrpz34r7dd+k0wM2WCDT3KaE=;
        b=ZkbHubZcV3MTjEFvoB5xGymFPBgzDmAZc1pM4QS3G19bW2rlX2+cr+ji6EMTNEKCoS
         IZnj6c+pgjAkEr5yvuXgJcviJCW1kF9cYWp3WtGn02oykSk2p92G8/hd/bjp4KSbkwxi
         KV+gLKKqWz3YuQwtyDPTI+vuueOpR4hC2IHUmrKguNXWaoUk+n/9Y7UXlXn0pfP39NrH
         DjMS+5qr70hffQm3etkYH37eJla3yP44A1f3A0c7KmZ7EL52I1ukzidK8TUyR+KtJclA
         98fNwaMyLw2Ija42GR1qLfHB7L/O8EjfauoZvx2bQ3PqrFjeiZhIDK51XdeYb3TuCziQ
         7n1g==
X-Gm-Message-State: AOJu0YzgDDCZho4w20GvjZJOWGHv6cVGC0GYSpsp0TrRxXvvKIzddmM+
	pacSlhpFU5IqYY36UCuDAtTnput+gbTOlmCXPhAH5eGUTRqRohcXrlIu
X-Gm-Gg: AY/fxX6G+oZrxOaub7FjXUi6sGW+YkpyDVj3SzdbfpLfjisvy1oAoexjZxbGeykCDG6
	xa8uv7zukF2tgVTxou1cTMB8ZhkL6MsJP2haWsGqDUDUIhhmBLaVq5ClwePG7ozoc5hh0cEDuGs
	ok38rxITT7j+oasp2rDOpwBASkD6n6AHdMGkHRif/nITcwibxlPSJzOBPs6QVfcZkaIYt4xVR/K
	pwxQ88Hw9LqdWium0f0mvBRW6J5kxnt41xyj0oGOanRdJLLF7YsMPORK38cSSbA4DCdGQhnV557
	66d3DXU56xd9WjeuJi54gV46cvOxgZGbpy6fUFiG20OCjE04XrOxABVVBLrevHezHjeC76aaG5p
	ld81TU0qQVj3AroiZtAkDL8VARKKz/SYGZ0aFXJlGUmx1X+A3VNIlMIwW5UXn0GwTu1XNW29n+6
	3BGYVNlWOqmudodm363g==
X-Google-Smtp-Source: AGHT+IHCVi5vf+JW7cs0UQI/61lI+ftkhC5OET7bLF5lpXMP/9qG0WkJH6kguXir7jmsMYCcLoJ1nw==
X-Received: by 2002:a05:600c:348e:b0:477:5b01:7d42 with SMTP id 5b1f17b1804b1-47d19599f8cmr103586685e9.5.1766579175264;
        Wed, 24 Dec 2025 04:26:15 -0800 (PST)
Received: from [172.22.153.25] ([80.93.240.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a204e9sm132695265e9.2.2025.12.24.04.26.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Dec 2025 04:26:14 -0800 (PST)
Message-ID: <edd6e350-5482-4551-aa94-e1ab8d2f9774@gmail.com>
Date: Wed, 24 Dec 2025 13:25:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
To: Baoquan He <bhe@redhat.com>, Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, glider@google.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, elver@google.com, sj@kernel.org,
 lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
 <aUtd6es8UC0lNf/9@MiWiFi-R3L-srv>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <aUtd6es8UC0lNf/9@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s6cnwk1zjn47q4b4y7zhuohn1hnsyb77
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1236FA0016
X-Rspam-User: 
X-HE-Tag: 1766579176-657819
X-HE-Meta: U2FsdGVkX194NfcDs4+0i4+paE4MNSGikaSljRCT2c6o6U/f26NfGXqkT9jZhLVtscCmKqbK1DtHURYJ38qysmf8qSxbwuDB1Dttzwk/NZtJ+rW5hsJE6OpVvuqvdkDOICTXwoHdoajW5m6Q7Rx7hZQwYFol6xbAn+fac22fubhZGQ6UEztu253KyC90eFBoPcJ2iYT5VSSqudLqUbwnzC43ZeAX81oNDdr0V7Zz/b+2fWaBDFVIpdCXrZ1gQy+eKdy340gZrBRfURsJCspe79KFpOjoXE/wlQbGnPhMFv4y171oW63u7lfdf+5XRqtNacxwnArPc3Tc4d7/bpVnfaiby9I0DA/GTP80DgDwK2/PjkhteKPgW3zjeVM8m8mURrW+gAjOu0+UEY668kVae1ZYzmrCaAYcaPt39l3zv4iLd5PWfh1H45pIlIjdJ6KQecmYAsU6iDDqJUJP36MIBLucXLYNZkyJ2qTBOocqyvXr+MUlNrKg6wl6crqvLvKT4ZsraCVc84SCcc7pyPJ7aXlTzBYwSs8z1neEcPZri5UWCrTXeBD4GU3ms71Gmdrf5RMtOyIs+wQ8sKXaZmfvLeCeMwfVuW65xshQnrhtQwLBKKneABjWVICuKx1zu9ilbWhgWvJNkC0xtch8HusYEx/JX5/pnhbOoONcXBaBY00yqw+DxL/B4sgNAWZQnOf14HamU+ixmN2NUv1R/3dS1a3jS3p4+lFB/RVUJkaLlIWdjlYSmIRzht35kdFCenA+RoOHHOi3VmRreLttNba/YOnULGpjz3YsLmucMLWkVmLl4otfDO8uOiHseV61SHI4zo904DjpqrYnW0Dhln56+VWYYg2qnKiu4uzO+7Gnh/0p3ItXOvjaDOD6LnO4bl8B7T0ELpmANipuRxoA4Wiq4Oo70lTjdd8kDcS8jgpsZz6Sx9Ct6JG0ysrQzGYfussTkDpzlFjl9r4xt+nPjJ/
 jqquSKec
 AYNElXjFLQSTM/rgtph13mWFs2N8ilL80sXaH3BnGc1+9tTHOQNB8ln76HMSndFbQ5oLxSyAM1yELqvFtemvo+DA4+bHUp8RGLFODUyyktyYXC3nHktUTpg4yXzz3bTS0dny5K77vc1/+d4PgowBVnKIE58ypoNHvGXY2jvcGMN8i3vxu5CEPIkbo16JR+czrnV6ATBU40g7edV/EIyrx95s7kqZ8YasM+/TXvXgCHViaDdgEbk7H2MGf2FwHs2/zkO+35H8VfvW/BckDs9nfPuj0D8OVXm/OKKYbSu3/KSug1aKjpANStqCzAPxUKcqwDR2Zj5Jn0jwmLrM/1r4iu2kOLyzTy6uLbcsLKQqe6mJbf/94tkhMi8woQRhcPbZKkmyEwsNanUMSHUK0vJhAjAn9VYR/MJW2pc09eunXh3GEbvhDuJssluLY3glRa8sJKfpnUFFFdaHxOjC9SV17qujetqX3NHWifnO5ptnEkzyMNXI/sCvltyu1WVAO2Wqv/2H2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/24/25 4:28 AM, Baoquan He wrote:
> Hi Andrey,
> 
> On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
>> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
>>>
> ...snip...
>>> Testing:
>>> ========
>>> - Testing on x86_64 and arm64 for generic mode passed when kasan=on or
>>>   kasan=off.
>>>
>>> - Testing on arm64 with sw_tags mode passed when kasan=off is set. But
>>>   when I tried to test sw_tags on arm64, the system bootup failed. It's
>>>   not introduced by my patchset, the original code has the bug. I have
>>>   reported it to upstream.
>>>   - System is broken in KASAN sw_tags mode during bootup
>>>     - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u
>>
>> This will hopefully be fixed soon, so you'll be able to test.
> 
> Do you have the patch link of the fix on sw_tags breakage?

I think this one  should fix it - https://lkml.kernel.org/r/cover.1765978969.git.m.wieczorretman@pm.me

> 
> I am organizing patches and testing them for reposting, but still see
> the sw_tags breakage during boot on arm64 system. If you have the
> pointer about the fix, I can grab the possible unmature code change to
> make sw_tags mode work to finish my testing.
> 
> Thanks
> Baoquan
> 


