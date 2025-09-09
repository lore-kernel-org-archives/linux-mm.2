Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDCECAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6F58E000D; Tue,  9 Sep 2025 04:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E0B8E0001; Tue,  9 Sep 2025 04:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3788E000D; Tue,  9 Sep 2025 04:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1D58E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:39:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEF0813AEA3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:39:27 +0000 (UTC)
X-FDA: 83869062774.23.0B19A72
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0100AC0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:39:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTmseW+H;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757407166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCEi5TXqHrjB+a+Qnvw/4IXVrSNxPFGRspDA4CqFOK8=;
	b=49fiGipfAUNrs63D/oLbw4bH84DVZU6lYikUFeYe9xjcE5IJq6497GYZoA4Wx6YM3pI1ge
	BC9ToBsH3Vx87QwClwpI9CcDPxSukPedYQUpb2wh3QdCpLGPQP8HfoyasneUhNC3fHBdQ4
	17EKzx8wVaNEcw+aMoLulzYvQnqtTlA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTmseW+H;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757407166; a=rsa-sha256;
	cv=none;
	b=Xvq14aQoDNvOHDc7fcB9JLKxwBHq3x7HRsG3KojGKiRFkOfrts0M2I4oKnffBQ8grk8AuP
	RyMmVsXTe+djCb1tVkkM6N88TAEGvA5n4ZB0JGdXR8AGRT3uBg7kAxmlOt8bD+c4DQ8sfa
	BZz+i5hFoowAneImk0ahlUIjtbDk3BM=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-772488c78bcso5266336b3a.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 01:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757407165; x=1758011965; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cCEi5TXqHrjB+a+Qnvw/4IXVrSNxPFGRspDA4CqFOK8=;
        b=UTmseW+HSOIoRDYwiy3SZKV5EUAR3q5TPmJsActAIul6Was4wtRExX+/pjdMj2HUAZ
         Lqv0jRlSJ+5L18ZQZUH713aDBhXTQOVW8F0hMzbfMbHCLLmRCM5TOkh6goVi0Dzfih6P
         3s8HSJ53AlMmFgkzObEiqKAP/+sNWXtdBAe0iwNJ645o5+fCNn2vaUaxl9RdBpRdnbjg
         E9IPE+0SJaUvK+AiaUs7lJ8zaKEou/EAkCJNPHsCDNgyp7EXrcD0oLarpZ+aJACNGPqG
         c4myxXomRKpel5iIKI9UeNWRQU/U/vziDpSY+ACvOhTOyNsyTyenyLP5QN0/r7sCKm4H
         g66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757407165; x=1758011965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cCEi5TXqHrjB+a+Qnvw/4IXVrSNxPFGRspDA4CqFOK8=;
        b=SZIQP9+5ByamU1UZmSlruMJz5SyeTM95Zm4lcwtU0ZUi2mHPxhpno/XRDrNjXOPt0f
         Eq0DmBkBn6Bw3OPMir/orvlJ2EhoYABjdfLWDKtSYVzGBYUYEZT7fk2HJlOpsZdoU+w3
         wsK55POUcgkwldeMBd6iHslFp2wWTTC7vburo7OsmAbvHT/nbbeDUKazMjdNwc6n5LvG
         ElEcwkinODzWoUeclp8hcpvSKi7SwAA8zHfxV3Bt5W1aOcduTv5uKAJO1R76YXxsVCkP
         yS72hrp0ADjFSs2nQrgiMjGX6c//sfApqZdSoDRldPirlwDY1S3Wvzm/h4WDj6GmlBu+
         tvPw==
X-Forwarded-Encrypted: i=1; AJvYcCXuTg9Wp5kqUO5fY+uU5rUJz7kD48HRrT6bVrjEfJbVYIE7VvnLJEd5TBSs9eTWKf1Mhz8+Vpyu+g==@kvack.org
X-Gm-Message-State: AOJu0YybcY1xxqnkn1rdnzdNXJ3O+ejEikKoyfdn4CgXBSSJHb+OkpwR
	SdsH5eybPm4+MGh6dWA2/6I6ppntDM66Q/n+lE7lVQPjo7iCHhEw23KN
X-Gm-Gg: ASbGncte+wVmMmzN/nZA260u6/ROPcYEf7qopB31p1tzobRrjMXi/rD+4OgHxwCs7uD
	uqNGhVt/UimyiYg43FKeHZVj0N9CBdLK1QJobjjGV4im3h/+yaEyWBaeqyiOlHcfXQxBNeD8emH
	0h4YefXw+k0YJH/9BemSp9g2FVwju8vRtMFXKdeU7pxqGSMx69tfE4CFwNzT+bEHyprP5TRNKnm
	hqVpBCDn/WUsNjDLAkRcj7KDg8WU2IzA6G6B5dyP2G3LI0Xqy4flTZLJP7lXlQNfkR2udzZGFfO
	fse/tD0uCxRUZMk6eEGiYI4MYZ5jTj+0W8PS7G4cgM0vwsd0jM5zVMTP5s/EJyrzJQiukbPNBDq
	qsk9f3+rm+zKqIPjPCgY=
X-Google-Smtp-Source: AGHT+IEqDdTDuoBLWzTwJjBUZvu7QFNnG2+UEDgnZAiaxek/ZB8pmRsjGPRE1NnETcQe5FjLxfbPGg==
X-Received: by 2002:a05:6300:8806:b0:245:fbee:52ec with SMTP id adf61e73a8af0-253444159bamr15811368637.36.1757407164725;
        Tue, 09 Sep 2025 01:39:24 -0700 (PDT)
Received: from [127.0.0.1] ([2604:a840:3::10f3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd3095df7sm28092073a12.36.2025.09.09.01.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 01:39:24 -0700 (PDT)
Message-ID: <f73e6e8c-282e-4d3d-9dc9-49f13b20a255@gmail.com>
Date: Tue, 9 Sep 2025 16:39:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/18] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Content-Language: en-US
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, "Naveen N . Rao"
 <naveen@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-6-wangjinchao600@gmail.com>
 <20250904063832.GT4067720@noisy.programming.kicks-ass.net>
 <aL5ns7h1NaoD9LPg@mdev> <20250909170017.dae27d8be77f9ec634e0d56c@kernel.org>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250909170017.dae27d8be77f9ec634e0d56c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0100AC0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dgmtfwo8ftzi14m87saet86cpk677t5o
X-HE-Tag: 1757407165-272396
X-HE-Meta: U2FsdGVkX18HwXJknzXNhbN4mDGwo1sVKS2KVO0DvnVf6jbxQwiPpGNA6QANJVKnfYmWkzx81gJzN+zXlw+DNsC25haCItt1dly+JBfbwG5WwARXv1HU0zKn2vx8Dxxa1T1HtP5j9xi26CJb3YZTnYd16+4NJyTW+fVxUWlgG3qyjpupVxBKn1y6P1agkSGkflvRA+XzhyRYwQLoqm+SlciFs95pfpFr5MCKQ7MLe6tOD9Pg1OjgpLi+WMfaegbNRA2lDgx1ocHWp5bifUz6LpNnXRopHmqP1J4/dOyLGUbWLFrzX1DlxYJLnzEsZJ5Ynm/Cj9eyCe9WnmS34Uh/uc6BuzVoMVkm3SBTXZOD9XqtpaiT51EZPckiioUawzCognM+wRXtQEMrw+vr3I1YP5/M/noWzk6CavWAvU6fClCa07JtlVg/Kim7KveGxrkyQjtd/SdKwusSWBIckFA/F+xFBywoq3VOc1vmVMeabVcQ1Kg4SbPG9UvW+D1RpwqWet0n2QHYswhELkZCw0rvolwFBW9Pj6GKtnyEb2ukX3eNNpNVOArsiUZjyeDM9K0ski7lzt9KlzxMjg8C9Q26ztNh3CGlN0LRwEo/ZrAE1D+HDJ/8ZRyRnprnMJrQ3sZsyZSPBnpVMWVk2/ehtTK2p/SZP+7V1z9gYqgl8uTmZ+jRgKaLky0rrKTsLk3YqYNNS7P6mqg3JFyQQGZ4LTINP6iwwM2FxQNsPOPFHQQdJ2t84gYwTkhXiF+92VUHzBwbl8ffB/pQKnTu/8JzFNixTVXd1NaP/RQtZ2vkbJUS90n6x8ynxqLG0detwH+Bk2ldWI9GAOIlnAMAbRfYwVSeNEvIDJ84/0mpErePDaji1xmCgo/L7VM8kxXnLZSTlvqP6fmARwXe/FHUvU3VzK6jZwbAakDZ56iTlZGIkWldlC+5a+nnPOyZhKtiw1ewlsjHn3yZfD8KsNXQnET25+X
 GhIJFblN
 wK1tz331PTsPFykDjRIrv8SswrCMkxQ78o9llrcDpFDcQtwtD9MLeLbJ5mGiMECGshU0R9ue2ICl4si+80iqCDBl+yVeTJ57bAhP9R9t54EOxBb/rd6lMjbs4BY92sC9yCUag1miA7Beg7gOo8uDEdsZrweDwEzhxA5qIj+euoyag0g+EfuGGLPWCg5oZyCmcYbLMmXpNIBOPdVnFbsSHXa3I2yucLTp7jSF2vY1iZqjNzDTC7WrEqXRg28m+mKFkjzUxhU32AN47jy+4oh5APmLCpWYC1DWZ3dQELHfeAyGLHRjHEs3ziMqkLeOOMkC0gFpSf6xClbvz3Au1vFX9dnAv2TEX0BcFc0HhXlD9r2EisT1BpTk8ToLujo1DKXF0d1qwEcYmeo6f0+MIG0WPdf/UKHW9LuHDAQoEghLUYSsRWokdeqMQJ8lgMplY+4zBjpzZasZbMnLZtB85Fpbj5/wlPS7lWl1xoTSiWjfe8Hxo8Zs81l88CpJMyEf8j2N72nmBasvegI/BMNobU+h/Mmev+2tB6ssFX3sBeZz5ShZAGplFg6u8yPyyAjOtNJbadVbuIdPeP62yfr7ffVkf8TTRLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/25 16:00, Masami Hiramatsu (Google) wrote:
> On Mon, 8 Sep 2025 13:20:51 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>
>> On Thu, Sep 04, 2025 at 08:38:32AM +0200, Peter Zijlstra wrote:
>>> On Thu, Sep 04, 2025 at 08:21:02AM +0800, Jinchao Wang wrote:
>>>> Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
>>>> parameters (address, length, type) without freeing and reallocating the
>>>> debug register slot.
>>>>
>>>> This allows atomic updates in contexts where memory allocation is not
>>>> permitted, such as kprobe handlers.
>>>>
>>>> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
>>>> ---
>>>>   arch/x86/include/asm/hw_breakpoint.h |  1 +
>>>>   arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
>>>>   2 files changed, 51 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
>>>> index 0bc931cd0698..bb7c70ad22fe 100644
>>>> --- a/arch/x86/include/asm/hw_breakpoint.h
>>>> +++ b/arch/x86/include/asm/hw_breakpoint.h
>>>> @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>>>>   
>>>>   
>>>>   int arch_install_hw_breakpoint(struct perf_event *bp);
>>>> +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
>>>>   void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>>>>   void hw_breakpoint_pmu_read(struct perf_event *bp);
>>>>   void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
>>>> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
>>>> index b01644c949b2..89135229ed21 100644
>>>> --- a/arch/x86/kernel/hw_breakpoint.c
>>>> +++ b/arch/x86/kernel/hw_breakpoint.c
>>>> @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>>>>   	return 0;
>>>>   }
>>>>   
>>>> +/*
>>>> + * Reinstall a hardware breakpoint on the current CPU.
>>>> + *
>>>> + * This function is used to re-establish a perf counter hardware breakpoint.
>>>> + * It finds the debug address register slot previously allocated for the
>>>> + * breakpoint and re-enables it by writing the address to the debug register
>>>> + * and setting the corresponding bits in the debug control register (DR7).
>>>> + *
>>>> + * It is expected that the breakpoint's event context lock is already held
>>>> + * and interrupts are disabled, ensuring atomicity and safety from other
>>>> + * event handlers.
>>>> + */
>>>> +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
>>>> +{
>>>> +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>>>> +	unsigned long *dr7;
>>>> +	int i;
>>>> +
>>>> +	lockdep_assert_irqs_disabled();
>>>> +
>>>> +	for (i = 0; i < HBP_NUM; i++) {
>>>> +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
>>>> +
>>>> +		if (*slot == bp)
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
>>>> +		return -EINVAL;
>>>> +
>>>> +	set_debugreg(info->address, i);
>>>> +	__this_cpu_write(cpu_debugreg[i], info->address);
>>>> +
>>>> +	dr7 = this_cpu_ptr(&cpu_dr7);
>>>> +	*dr7 |= encode_dr7(i, info->len, info->type);
>>>> +
>>>> +	/*
>>>> +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
>>>> +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
>>>> +	 */
>>>> +	barrier();
>>>> +
>>>> +	set_debugreg(*dr7, 7);
>>>> +	if (info->mask)
>>>> +		amd_set_dr_addr_mask(info->mask, i);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
>>> Yeah, I think not. For one this is an almost verbatim copy of
>>> arch_install_hw_breakpoint() with zero re-use. Surely you've been taught
>>> better?
>> I introduced this to modify bp_addr in atomic context in my RFC series.
>> I thought it was clearer to split the introduction and refactor.
>> And then It was used in the wprobe series, so I left it as introduced
>> in the RFC series.
>>
>> I agree your suggestion is right. I am willing to refactor after wprobe.
> I'm OK to refactor it to reuse arch_install_hw_breakpoint().
> My point is to have CONFIG_HAVE_REINSTALL_HW_BREAKPOINT so that
> we can easily implement the dependency for other features which
> requires this feature in Kconfig level.
>
>>> And why would we want to export guts like this?
>> I wanted to introduce a real-time stack corruption debugging tool,
>> which needs a helper to change bp_addr in atomic context (kprobe handler).
>> And wprobe needs it also.
> I agree with Peter, it should not expose the architecture
> dependent code directly. Instead, we need a wrapper.
>
> Thank you,
Understood, I will use the wrapper instead.


