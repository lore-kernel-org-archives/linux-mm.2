Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C75CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5F28E0025; Tue, 30 Sep 2025 02:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187798E0002; Tue, 30 Sep 2025 02:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027928E0025; Tue, 30 Sep 2025 02:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0C828E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:49:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C122443E1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:49:36 +0000 (UTC)
X-FDA: 83944990752.07.8AF42B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A7F8C0013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:49:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cWPn/YHw";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqRlzhy6X/OCGXbjhJnXJHWuco4CEjpdGpSoiDLw9OM=;
	b=Vf/1UMtlf15wVg/uZmUReHQEYLxeAAKnjWZqc7GHntFR8cAUL0zIyS0KWetqzoEiYzZX1z
	VrvToAg6bZ8QTcrL3z2Ho39fwaA32ICy7tUxhQe007jtiM8fKTMgzUJ8I2QCwzoD62+55j
	dYDm5nIDizah7SoH71aKHY+og2zzYS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214974; a=rsa-sha256;
	cv=none;
	b=BFKRKf1G7lPU9Y5IBqA3Hia0cqBNJ8X/SUU21Lo+Rp1Bnyf+QzXbYGpDG6XkI0Oew+ih7k
	FQ2apZaqXMJ6oMk6q+VM92q1xa6kIVGFFCLxBNRQjbLtP23buvRV1tOCXTdcn9eaITPc2v
	xKNRZBF/9i5p8EntTPnMKSCgRrE3Hmg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cWPn/YHw";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mqRlzhy6X/OCGXbjhJnXJHWuco4CEjpdGpSoiDLw9OM=;
	b=cWPn/YHwPd2B4yFiIEeGg9p+l507dxYRKoRh8m9Z2afCMhlT5iLmjLKkI9zU0i6jBK3xO1
	jTsiwSFIT6MxARK9fGgAhMyOTK7UOlB4SIRVEsG+3jeF3mcYLOPXppHovCvOZu7Wr02J8j
	BvHYWel8OO4c7H3TaGe5RTRhY+hzZpk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-yPdGD9ZJPgKHr2qBTc340A-1; Tue, 30 Sep 2025 02:49:31 -0400
X-MC-Unique: yPdGD9ZJPgKHr2qBTc340A-1
X-Mimecast-MFC-AGG-ID: yPdGD9ZJPgKHr2qBTc340A_1759214971
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ed9557f976so3626683f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759214971; x=1759819771;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqRlzhy6X/OCGXbjhJnXJHWuco4CEjpdGpSoiDLw9OM=;
        b=MP7O8WJ+41uCOoARzzTjsomJfQ+Y/Q9kvkGpFDD14NpuVKQ3KBY5E0I+Y/PjMp9fk/
         HmSbvdAgF5ANiS+Eb593qhmhVcQoH8dc+NZsobr1Z5WY6yTwjrYmr0KY+V3q/HeunBu7
         z9WROCcJ1dGYWiqfxEedH5K646SCj8ANFEFxfRVt+JTZ5GdLr/6GijFkstlzp2OZB48/
         arZgVGyS2yhbnAdZEK2TrsCVEv+o1Gy4ptNmURVaQqhRc7VayV3EWhC/YNzFEcimy9kg
         7UdR2Psca3br40+UF4rvjfJRjJVOKplxj7vbEDzPErlHE8+kKy7BdP6RjJeMnqG0bnsR
         d0ug==
X-Forwarded-Encrypted: i=1; AJvYcCX1Jx92WsVGjDRxkNWijOeznkZTc77wHwKeQLeJUDF4WsJmlF0gQP2Geyzym/0nrY3zqlYL/0kqVA==@kvack.org
X-Gm-Message-State: AOJu0YytXlSvHncOOleDsLscBmbtYB6YiKdkwObdCCIfYw7d16uokMwH
	mOkav5DqRYni2U2986LJiX/Nh+BMeJwU1PbJSElPj4tPVR8ZQ6DPH9MSgGMzPoi1OH+hKySiY6n
	kpW3VKlMvS2uESanEWVs5EvMxkQAiFajRhv3z9wp/+r8bF8PszoG/
X-Gm-Gg: ASbGncv4esxSyZ6/yDui3gGr0jdYHXxSsrcTP2geV3k9yJwuIDZ37j+w/3UgIyz3dRU
	p9ELnKzTmllUENQw/7Wkzjugh2BvPQ63+q5qpHoq/eGgzxfaC7Nc9DHpe/MwWOL9PTvLhDzazWY
	7ZLVrE3Cp4TI9qBXHmHIzZ1zNhdDS6ZNoJQAs3dsrGzmGSv0n+4fiJvEAPh8u7qsr3Y3hY+9gZJ
	8F40Xz67eg0DeyDduvacghD81ZmBdZgcZULMu0QcsZA7dgjZchFywCdVw01m46gT1xu2lXJ6nRm
	ceECPt1AI2CAkyvDHa02zJ057/SHx2x0fjdUDYoN/7sXipWOhJci9eD+leLxP9bTWeBHd/ojxEh
	1FuD4fzsD
X-Received: by 2002:a5d:5c84:0:b0:3ea:15cd:ac3b with SMTP id ffacd0b85a97d-40e480ca367mr13436896f8f.30.1759214970671;
        Mon, 29 Sep 2025 23:49:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjJ1kh+gHGKjhm8s7ngHlJgKibrCLfy9i3c10QH8wYWazuNRp/0yTM4Ql0YUWytAaTC1Wp7w==
X-Received: by 2002:a5d:5c84:0:b0:3ea:15cd:ac3b with SMTP id ffacd0b85a97d-40e480ca367mr13436821f8f.30.1759214970148;
        Mon, 29 Sep 2025 23:49:30 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b5e4922sm7544255e9.1.2025.09.29.23.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 23:49:29 -0700 (PDT)
Message-ID: <3ed8a6a5-9983-4b9e-bae1-4c433568de16@redhat.com>
Date: Tue, 30 Sep 2025 08:49:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/23] tools/ksw: add test script
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Alexander Potapenko <glider@google.com>, Randy Dunlap
 <rdunlap@infradead.org>, Marco Elver <elver@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Kees Cook <kees@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Sami Tolvanen <samitolvanen@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Rong Xu <xur@google.com>,
 Naveen N Rao <naveen@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>,
 Nam Cao <namcao@linutronix.de>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 "David S. Miller" <davem@davemloft.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
 <20250930024402.1043776-22-wangjinchao600@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250930024402.1043776-22-wangjinchao600@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDMMfUT3LQpnVE8gazfHSdaZSaVkvZ5LYc-VJYnuhbU_1759214971
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A7F8C0013
X-Stat-Signature: asdxrw9seb3qzp3x7jzt5jpep64xmnrz
X-Rspam-User: 
X-HE-Tag: 1759214973-897673
X-HE-Meta: U2FsdGVkX1/XAuJ7EocTyb6iIT1xkVjJdaKWj55XGDoA33AS1kx2Ss+AcE8MZ1UBwGP+RAmDg6cRWvENsfBf6hAyZltAMV9gL6toQwHaN9B9VBgjCY3C/snYUgicpns8nRlaJOidL4ufeZBErdrCWdjw4APVsK29T0JU6ZbNPF2I7/UKwNCdzkOHAXhp0lfAbAsQtkK3TowYKuL8emqfSX37fyKWk7wU79SIb3xaPZ6wmZTETbQulYaSgsmGU++/rnG7QN+dgG5B4o1JZSX9FYiuscXCJ5bLQ91poyCSnrjN+MxuRiVmnAYjKX2WgsdpxXjAvgO119BJhc6jV+cznnP+BOKiUc+xicyHT+6ekVd3NhjNIQQJnS33sXsayyH0pAhUHMqw7i2XtIE8vQPGTZVhEFBU3fQqEO3DG2tdmYhmDadW9Wlg1Mz+EWrgG5FtldaR/LI5vqKLOOiP/KKwEg7JwecFtgJxO6lUeQLIvJAKTuCvR3iwA0jcYloC9ItbxGp6wsMDGk1I2FZRlj5zewVqooyQFLRVmRl7ifNXF+ClUpTEgmDOscic8u3tIWcnyOqH4V+I9FBccPdrmNuVdmh6CnE1HxmFApwGDf5ZTF7+3QFDQryVWu9RNKEpoPPWZtGTwlU4/eGzWSGb4qfHjxEtuHmUyaqiOitkm6VUopcdeUxHrPpRjIewghzRylMpCs8EkMMBXtURKBFazH0lh8Wfs9DE2kDqA/vPd4H+Pm3ENO4ZRfFCkXTmQWEyahy41oZnu87AiDa+7ws26d5Fant9H7La4R4hNoXrMjEdKS5HJwQuYRTTvkdU7F4eeXGFjZZ2IGKTq3Zka4PrZq1F/nSzI69XAYW6VuPYtmLcz5UyTMmoQQ7JaZrK3BiPBnt5pwwTYQd5fJtdirUpFPQzSa4gZDSf1IgK9Foo8JdQcnfFpHoIvEbZcyqYOwNpEFOjJ39nCtu1J4d70vNLOzO
 ldgZMw9X
 bOI1F5ZWZ3wF2b6moIr3BtjSjlpkjEs2OneZLyEBe7vmfEjZT0LQBUXUmrNSlTEMzwoBIpsUfqYWwowp0ndrDYmYLUAZUDMiW81ZjNx9unAnx+pEhemFmti5RelMq1Yj5xFQW7+VWFrwircPH2UOQo4d/WTQDQxKZXyVsg0jXTU2dB/S4p3vbYsQYUu8HntC/m2D16nfGBz9RWCTVBUZ+WH/KkDuLnrLUepjVEHDy2oBnTukxyTDoJWZ9wSTYuBGBnSJb4t4HtG0hJgVG79XieISgVm44e/WhiRttN16/TKg7GWgDo2xayuaPVWSbhB+2FqRy0//ERODSEeOF6RKz7GDvsBXyYVsfUBNOMpYqcqNvAi+VHDqqxvKU4RBYzbdF4tVsM3NP5EWQmn4OKQLQ7Qsw768xbXnBip2HbabwcwTx4lewzR8c4KneYOggvUoN0Q/nOIgKKL1jfG8ujImtnDpRSaLrKNMXrMOQg8nJIArwGszG53Zwtk27u4ey0RqovhLSgbB4vKJiNvhiGIPCDZXjIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 04:43, Jinchao Wang wrote:
> Provide a shell script to trigger test cases.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---

Do you think there could be a way to convert this into an automated 
selftests, living in tool/testing/selftests/TBD ?

-- 
Cheers

David / dhildenb


