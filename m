Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17018C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893EA6B0089; Mon,  4 Aug 2025 03:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B6A6B008C; Mon,  4 Aug 2025 03:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781626B0092; Mon,  4 Aug 2025 03:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6525F6B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:19:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91529140F87
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:19:36 +0000 (UTC)
X-FDA: 83738224752.24.4C1A03E
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id A66AA1C0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:19:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LqehWx6E;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754291974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oE+jK0I7mLPY3+tSedssnvqNY96rnU3UqPwusHT+xSI=;
	b=TWrwDpRPalSh7pOXG57lHKMgQfRK2QEWezy29MILTIR4NLMUAh5UwFTDUq5C1gTZecNmCp
	oHSTr1idh6ygUiIAPkmPFzxLvh5x9WaXRfKN1YUf1kuOpbaFIVP8L6Z0MU9vkeOne1OgAi
	XDbeslSlPKwJqqzJdnQQe24ZLbtGZsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754291974; a=rsa-sha256;
	cv=none;
	b=KUsPC6CHW5WRDmGt/QKWlVK0dbhMP2t6RqqUkqbmgbfn3jT6R4M9TPMsHPB/k8nkuKo68i
	3luLA8XsumUCCIfvHn0ZDqDLkybPZEGg78xE7p6qA2HO1xcFuYc8mnZJYKPqL9h9kNkTjs
	hnwyGAJH2dOSUt+drvgoJXifJi3qst0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LqehWx6E;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-88baa491d52so2159497241.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 00:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754291974; x=1754896774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oE+jK0I7mLPY3+tSedssnvqNY96rnU3UqPwusHT+xSI=;
        b=LqehWx6E5DtE0TMdnT1aSbSs0YMBxmn6n4aTJCJtu3Chr8seasnEheNTvGC69SnmgM
         zTF2iXAd2OflS198uhk7y7kih0UiufiI7oatMN9YZzXNbFQEWvZZtOgxYpnBy2tfeXqn
         FiuwpmHGRgUWPChPeSTiGTQdRV4LPmXbUdsQtf+atNjTutB40tmg66rLyQghigtx/XP9
         HKUz1dSn9sa1U5mhvfhQGgSWbAqFuU1rmSJO9eEjqX0rPSL5beUspKrYGTfr5nbT7HEL
         vK2hoM3ODA3BnDud7l4MRYeAXnRfFvHND36OR3GMFy/nuf/PX7l3rk9wZJIREVj+zpRt
         6C8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754291974; x=1754896774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oE+jK0I7mLPY3+tSedssnvqNY96rnU3UqPwusHT+xSI=;
        b=opzGadOK1SliHAM6tVkENafgiig63+NqjWi+Cs/OPiAEf1yltCzcrbSKULWKdnS4SQ
         01V5OgMkKPj5fS4+SBgbJstv3TXUQ54F0xgoNJcoYhrR4t8GDBo7VpOefXUtZ3339Wnz
         pCHfpS/nMacKIRy1xGtfMRkRZdHV2sr7YJUpEDOR7gh8icOXjdhFcafEsFfKr66vE6y+
         FaUGQ/gbwXr1Vv1nGLd7jOXSzc5DCKchbrFx9BgrauO6f1grGV7fdFPMCfEbG6eOpg+A
         CEVi+/4wvUfLTo64dpCvNFmvGOrEqqlJrfNlrrGSwwSEgLZz1p4hvf+PYrCRU35e1r1e
         sK1g==
X-Forwarded-Encrypted: i=1; AJvYcCUiu2RAQi/zKf3QOFlEzqB75uqGrW3Uj4kw2+X8KsJ0LBVBn+6KMnRngbjK7gosmvQ5Q5D+N0+f/Q==@kvack.org
X-Gm-Message-State: AOJu0YxQAtNM/TNOibblrhrFP0WbgXc6jjfyOzjkm5ENc/Vt7EyBgzD/
	e5Dw+kMStc4BORSP0uyDqU3j8tV1yL1QVe58bmzbsfQsNqiUcyhw54ipS2CzEmoDhmOBgzU112s
	nvVCKl+lBhOEEnYVhkOUA5Ny8DfrkU7g=
X-Gm-Gg: ASbGncsLClJ95Sq5cw3zymVu17JaGXoUscQhLGA8FqzrREEZXGn48/JOM45IGSTKycd
	oltnghzSYVCCiMbFgTUOZoYNlXcF3YZDv2XvqEO/kges4IeQkHZaLe0h9ihVHyvL8bGQ2alAweI
	IqGD9mNUbE7afVRb6l1L3Mybb8OWQJMKOYDtrXGnrRJbZP53/TZZFhNyYpEiuBhJ8q1cRxfEPpP
	sqvDjY=
X-Google-Smtp-Source: AGHT+IHIHjI5MYWeINur/RAU4kGeuEnodFp+xm0rJ/4u5tVFs6YXOYCd4Z566t+gNbTxJkjSM5LG5rNhX20GXJDXPuA=
X-Received: by 2002:a05:6102:3747:b0:4e9:963f:2d09 with SMTP id
 ada2fe7eead31-4fdc213519dmr2975464137.10.1754291973644; Mon, 04 Aug 2025
 00:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <aJAFrYfyzGpbm+0m@ly-workstation>
In-Reply-To: <aJAFrYfyzGpbm+0m@ly-workstation>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 4 Aug 2025 15:19:22 +0800
X-Gm-Features: Ac12FXxLO6_fioid_qXwJgf4K-CWznI8zE5ixEHbnOLYS7IN7dCTl9scP3kp4MY
Message-ID: <CAGsJ_4zYrcooZWh0hRHqUoaiuu2eZMOuEAdGjmGArL9k925KZQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A66AA1C0003
X-Stat-Signature: ecnot38re3auzx71ajai98ybmw64mn97
X-Rspam-User: 
X-HE-Tag: 1754291974-391547
X-HE-Meta: U2FsdGVkX1+M65lfeaYNkpIntLMDihXNxIJNjxE4Kj3jK5w0p8d7M5WzbeaSP/N3HyBGwg6Hnwr9THk+/EEj5fXA5m1DZRGm3/358ZsfsHJkGUEcohvdPr2ZFp8FVgFksDSpbJ9opm+ofR2dwzqxrq4+eFgyQZ9PfZL8h9LIr8BXG/JmQ4J8rRQlQEmxDmYFJO6Vownb0BB3hfG78txA9zkd+ZW3QHmlF+09SgqjuS9+Xcy+7yCQSdpnkHxLvAzjfctMMiwPAeGZ4+L8OsKXUxjt3mBJkS2AUIL8A/Y1t6e4F9FJMcXf0dITjd8t0xO903wVpLkZ8s6u/NQp+GEzaZwnI/TvgtdSnzGRyvmm9CP6VHUnmtVzmpn6VrDKIh0BYE6n2jinciahxiPjNeju6yumHuzxYbigrVzIKf7MHri/yvhYyRuHkAraLoH4EDsrKiPb2M4lRp2sb/OztddAKb30WTpfNOrBzEUqjP5QnpfU+aQkjDplquu9kOmiyTC+dxNK6rCXQ4g0axoLJeCFK07+e3guVXbe8/yYLgX5+q3iiPTL+BTmoDMX461gcqjhm6ne3zcE3LmoH/UJjpXId/NSn03BeOGdcgAk6atPGaP3Iw6zyYQV0gb/mt7iwF+ediGS//Zw64Wp4Gicsfq+f+QBrLMTYJ4D7+yoSvZsIrKcPRWFmT7hNZXUX/Evg+RW57fk6S+Uq/DZCHqfq8akbGi/kjwhdHuQ2BA46hMUFlWQPvoSmGsudUYvXp60HSVup6Lr8YlnGd9pT3+YeXpXjxMeFxJr6TBh9uLR18PIkUJK/NUwhBZydAM71D36DAVfBpPsM0VYFzXSsKUWZ6QMh/bR74cjJM5RnNVTvZ4iWYksyRn6tBb5ZpUYbqkGgkNM36ZksK9uCTtEUV68xuq8W+BegdMfa2NmwL9weBOP4imfSeShI9OBZLP1KfgWRalhebDfMXxbOB+tAcO2sGc
 lMdqKUBD
 15+7U7lFATs9f92YBAhAJhe5rebgcm3XWRpgr4ahecQv8/wCB/7cSUvA2zulkGqzaPX21tUpNHGXah8EghTlc2vBas6rAR7vYEFn/zzQDdSGICg8wM2KKmKKfUzV+hjnQulPyF8sdmDSmd0WOJ/WT2uSuC9nXqXpudol9izGcCrn7Tq7JumvWmaak02pP0x3WnW3xwNe6AqLFfTY+/eknbZ6qlBhUL9X26kRlQThJMIhbY1MPoD1/fRjkqlX1mxzNRi8AorDPQFQK6U+6+Ei4qWh0t9rPspgdYyCLI/dZ2yDDO5oBZ4Geabo7lUOmUgDbklPHbDK4qYR1vOg76m47FSxEwirii8XINJACsCTT9lX8R1fv4PvUK11tg9n6JkZRPThkTmIUX4klaouhbiJZisoaH851DkPrpAONVhwQHe49UHyHlXOqtggJAI9dPRsSFpWW/hHBVKbxkTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 8:58=E2=80=AFAM Lai, Yi <yi1.lai@linux.intel.com> wr=
ote:
>
> Hi Barry Song,
>
> Greetings!
>
> I used Syzkaller and found that there is general protection fault in __pt=
e_offset_map_lock in linux-next next-20250801.
>
> After bisection and the first bad commit is:
> "
> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> "
>
> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock/repro.c

Hi Lai,

Thanks for your email. I gave "repro" an initial try with today's mm-unstab=
le
on arm64, but I wasn't able to reproduce the issue.

Please give me some time to test with your kernel and config, as well as
on x86_64 (though I'm not very familiar with x86).

Thanks
Barry

