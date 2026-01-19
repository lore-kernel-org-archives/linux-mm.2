Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95624D29C33
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76F56B01FC; Mon, 19 Jan 2026 09:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E215F6B01FE; Mon, 19 Jan 2026 09:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30D86B01FF; Mon, 19 Jan 2026 09:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C196C6B01FC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:44:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78BD6137501
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:44:03 +0000 (UTC)
X-FDA: 84348983166.09.ECC6170
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DAE0140008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:44:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ivSSP6B8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768833841; a=rsa-sha256;
	cv=none;
	b=4eRFj8vofJTNlcN7H1Bm5YpMG9dTevuwx1uC2c0ClGTB8zr1lyskzDAQoSVIyOA3Zok2+u
	6yCwgRC9yTVS6avUhVL2Gxrc6yGCnEPXlDQgE+YbcO4k6SEWkB+Zrhf0MvWwYZYchMWGm9
	KiZj5yng+f4/5S6GnWSOikdyorf6J7g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ivSSP6B8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768833841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw8g4FncQCT0qG+FJkoHCdORpG7mMrMlB+H9ZegPebQ=;
	b=wXvv8LO4bKRa02g07y6fNB2SPlYHZifXJc662WWcwQ1JN1Pr2fD11YxAXdaCOvlW0ePEaS
	vwfO0aldq22eztV3QNw09C/zIjU8P2+/5AOFJvhNIlF0c4nPx+TOwXNl3OsxUzr9fNKZOc
	3ZuPyQ+BmIQk85EYsvMy9AcLT93Jrps=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59b77ff32feso479789e87.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768833839; x=1769438639; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hw8g4FncQCT0qG+FJkoHCdORpG7mMrMlB+H9ZegPebQ=;
        b=ivSSP6B8oeRpL42T9NAXUPglj+f6OlN18sKVHwldR+jxb6/bukRbtwlqciX+sJzWDs
         6AOtSsgGUWRMRXJbZNNVFbxTdprf2TdNYf4UO7ll6I3KHCqH5L8FUIndUsJtxxVQxzEG
         bdh6TFCiXIF2rNf/PwSDivoM6J8hYfuP9COCeaoTGeYPVu3XymWj9jJmvxgFrk098Tff
         e2gGuS8XUMKOICm4zLDBIhHDUl0DQOVlNRVkewB88XVs9NLah5dMxxBTXGFouScKVcAc
         C9Nf5bVCbWi/qaFH1yNjoSntCwAfsEUbf7PXF/w78Fuxmk2y+tZvMok9eYi+k46eaDtN
         SMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768833839; x=1769438639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hw8g4FncQCT0qG+FJkoHCdORpG7mMrMlB+H9ZegPebQ=;
        b=sSUc7n37hiY9DRvt1968vb581u2U16bx7pxoJI2jLyQ1WFenQgw9wVWHJfht6BZ3b+
         YK95S5U9kuebKBuXab2d/B0YMjGwX/M2V3vhAitaSngGAfu6tcmquyO8KSzbopJyAwD3
         iPRxmuPoGm4SVCp6VToMGTAEgcUEwtEyWRPwyXphuwnyVCA1+jQnfrOGjggg6NoxbEDn
         W1KhkMrFJEb7w35b3AfZZuajUhbx0DzvFzuyQpTn3U5MPua+4QDv1hy8zdmVkWEVq+6D
         T41tSyq+HoiWyOiQ8kiErxBtaHD8T/8nUc8pzP8ZLqrdvU3aDi0i/xv0imv91RYauFSc
         dPAw==
X-Forwarded-Encrypted: i=1; AJvYcCU4hMo6GxBZ/aoaAXkBY0s+qee3Sv/+VVaPO5Tx684jsLFfXyzRs/i6LNDIxSf1mPePLuZH6dDwsA==@kvack.org
X-Gm-Message-State: AOJu0YxqVGWRy6Y9osNPSciuDpSG6FAOgToXMv1NNBKZEl8xKFrl2llu
	LyLlGz2QljmlCZyWRSsFSlZIa/FJtkgzVFToA+AjqJzc9hOo+Blz0eTZ
X-Gm-Gg: AY/fxX63SIqSMZzcgA1tVsxlbiqUgsHC6ifc49bLO5l0RwH3V3NUw8Krwl7QJ16OSK0
	0UZnLNXbOUqmOKIiDg2lS0fh3HEIm4EA+j1F9C+6vD1x+IY3x24EOnhs8DzXtiSDOLTL4VmziPd
	nQZm5VFMgYe0EgtBHhrfgpZqVvm2VE1Dl575j5RqZCBBYBaDebJiaw/+P3V2YFhzuW8qGdfS2Eo
	6mQSg910TWzIL5KdFdvXIRMW4svWmh25jA+//g7Iv9qDtGYKbtoUY8ciK8QGXx5o2h7oMwb3qES
	f/2Zpa2PhGnpqQK9E9imbP0OKgTay463PCj/jOOrlmXr2E1J1J6bEJ4pGsKJlcBESNS2kseyflE
	XB1i4tPvIqGWj1n+07mVR2N3AQbt56pEtiYfV1EA19GfAMmhESyRWFVb7VetjDtQpo6b+bM325F
	2ccTE0fbNzGxzcEoHq5lrC84x7omFI
X-Received: by 2002:ac2:4f14:0:b0:597:d7a1:aa9c with SMTP id 2adb3069b0e04-59baeefe804mr2049768e87.3.1768833839215;
        Mon, 19 Jan 2026 06:43:59 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf3a1746sm3435146e87.91.2026.01.19.06.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 06:43:58 -0800 (PST)
Message-ID: <38bcbe9c-5bc6-4bfa-b4ed-e187e048d600@gmail.com>
Date: Mon, 19 Jan 2026 15:43:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
To: Andrew Morton <akpm@linux-foundation.org>,
 Andrey Konovalov <andreyknvl@gmail.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
 Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com,
 stable@vger.kernel.org
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com>
 <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
 <10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com>
 <CA+fCnZeDaNG+hXq1kP2uEX1V4ZY=PNg_M8Ljfwoi9i+4qGSm6A@mail.gmail.com>
 <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
 <20260118164812.411f8f4f76e3a8aeec5d4704@linux-foundation.org>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260118164812.411f8f4f76e3a8aeec5d4704@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DAE0140008
X-Stat-Signature: i1kjixd33k9s7jfoaqgjdhfsr4pxbski
X-Rspam-User: 
X-HE-Tag: 1768833841-758017
X-HE-Meta: U2FsdGVkX1+zmbBpths2ebDWEw+w9N50atNkQPdeiGwQgqV9ewdJxzBHloGlanAhIyaadsYBEAM1L4Xu/knXOn1WvpjfWRmcbbevS6LyZQjesAACTBuXkawmNMs0Jl7JD6UjVmG9s13FFF8DCxaEp32iTt38xfw8fleA8uTxO50b6rZaF1eHJ4BVbP3FzZq8XZY/n0omQEzYVHpRhs+ondgW1zhWJc/gUc1MQR9Mc+v4cVQsoDVT8nWz45AYSnDcbjtpIFzDqXSuQcTtxKaia4mbQ74HqipCrHtPebQNxJlXs8rAkd2DtGuQjqOOrgNU0jhpnckTSSD71NQ0Hvd+y2qDr4qdSEny8/Bh8Lt32VWEpVG+aTCrB2RqDl7U7plwYwDhELt6BSQPACtQ1WiTFReKBf0XjTjWgH6WG9oppWD010EWRzf659oQ9FisWl1wtVg7tEGOrOSWLlYbGnxiGEmnWwhWc5zj4XBnj+/LatpSnF6w9O7rli7SNGbF3Dh2INO3F9AqTAAItaHbyrmETxibrmjmbg3y3eUB3wo5p5tF7Yg2Kc3jdPVxTnWbeRyHFBp5IIJlwbhG+WTsNNho4mA8YJjfgxEmrBMOB9jDaD/7KznVkjtyDdLVUhw/CMlJRufTz9tIRFQIJcDIGxFWCs+aQnBUs8X2NKKP2tPHDcVYCWciXprmfXAgT/Z46pKgwYnZkzv+Xm3tuApx9syMh5yguNxEfVgNNKrPTmlG2Mc9ReSwdearUzkdmmTCOn1ahYfECq8c55GznurKJUnItiZOoGQA8q+/IdqO11xUskrtBLD2un3cZzTUv8wlHivtMXh8XKd3eY6iBEIuJrILa8fSdDJccJL/oZqBw6tApPd0wEmHD5aVLH/SP6upa66SXBQgsMkPrmd/JLfdeJnwp/IEZTdvK6hvXM6qy3FzWiXUxeWoUKJkzasOv0LaDH7xCX9PMvuDcZqbk8j4YmA
 eBNTDKND
 EBJuIo2neHqACM/sIGo/8F7nOVI9vqTNL5/7ifLCqMsITMU3vtAlT0l8HOK1BZLsTkvPf+XLC6P396i3lXcdkf78bF4IS3837/6kYoym0+d2hS8akE29+hNE9Ns5tbDHo8r/IjmyBrWe5RzUnogt6A7wo0AsOCJg669Tz/Eqzu/HAE1Joddsp6nSdo8hmOyfzKcwem4S9tWOf1quyicaX6vV8scGlzl6IWj2WQqtf8OFADFkO4guUfiWwmiG7sQ6vuDYDUA9GzL6si4OAzeLRyl6u7vSdg/Ho8dMQes131W5zVq+ZsZKPWi41lyHrBpIH45Lg2bTV7RtcZl0XX5b8V4v/DD/7ES5Y5awsnFUuHJjz0ObmmZralV6I+iFE+4aRVg5bGo5XWnIUPB0jtjvNysWpLDRhIn2JxHm6GNoYoE01hL/5wHl1IUJ92dIYr26fliOjhZ2D7+PVIx/6ijTMqshfnET4kPTDJJ0+lnKp/rJsaR9vurwfDaKzc072YLpgq3zzmrKE1t/FGpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/19/26 1:48 AM, Andrew Morton wrote:
> On Sat, 17 Jan 2026 18:08:36 +0100 Andrey Konovalov <andreyknvl@gmail.com> wrote:
> 
>> On Sat, Jan 17, 2026 at 2:16 AM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>>>
>>> On Fri, Jan 16, 2026 at 2:26 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>>>
>>>> So something like bellow I guess.
>>>
>>> Yeah, looks good.
>>>
>>>> I think this would actually have the opposite effect and make the code harder to follow.
>>>> Introducing an extra wrapper adds another layer of indirection and more boilerplate, which
>>>> makes the control flow less obvious and the code harder to navigate and grep.
>>>>
>>>> And what's the benefit here? I don't clearly see it.
>>>
>>> One functional benefit is when HW_TAGS mode enabled in .config but
>>> disabled via command-line, we avoid a function call into KASAN
>>> runtime.
>>
>> Ah, and I just realized than kasan_vrealloc should go into common.c -
>> we also need it for HW_TAGS.
> 
> I think I'll send this cc:stable bugfix upstream as-is.
> 

Please, include follow-up fix before sending. We have to move kasan_vrealloc()
to common.c as shadow.c is not compiled for CONFIG_KASAN_HW_TAGS=y.
So without the fixup, CONFIG_KASAN_HW_TAGS=y will become broken.

