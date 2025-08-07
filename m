Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B26C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CC86B00C3; Thu,  7 Aug 2025 13:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D0B6B00C4; Thu,  7 Aug 2025 13:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C286B00C5; Thu,  7 Aug 2025 13:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 928F86B00C3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:12:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6641FB6B47
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:12:56 +0000 (UTC)
X-FDA: 83750606352.23.F6D6D15
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 513124000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:12:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kc6zhbrI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754586774; a=rsa-sha256;
	cv=none;
	b=yGElMZfCndam4LT0pnRHW2UWW91cLs6CzCaFXBA9xzl9RrkB8qIeFtDqdOuWVc+oILBaO/
	7L4FHcY/hVpmLbYqiFG64yq9L/WPTAApglx0YXSzFojd5CHJ64OKi7r7xJC2Kvw3xVP/+i
	j9aJVj9xWdP88j7fznFUpxzYULIJIWQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kc6zhbrI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754586774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEUJrNTVfNIvacBySzD/xtaOi3Go1shw4gqk3/yKQ60=;
	b=I5eDS6ObZPEyY0KGqNjROVJSQuT5sQUERVnpqFe0A/0rd57FLCFCGNaEbrZzYC5d2iigY1
	S8IotqmnvDGDm8d+HKPaKfWv/OV0e7xz9gFx12UlOKbljWD8Rc3zTrSP6kcW6XsvnuKjQ/
	/X2HQs/2tZCHsUuuYP7DPAa6uWk6if8=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55b98acb9faso99404e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754586772; x=1755191572; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yEUJrNTVfNIvacBySzD/xtaOi3Go1shw4gqk3/yKQ60=;
        b=kc6zhbrIk+U4EdkWlJ0adKjuqe9FBdOVdrt2yHaXwZjeR4swivKGmIerQ6a6xR90cv
         WVX2F/OvCpI4tLgLlCWgPoBa6QOadtcW/VIy9lYZn6W8eZ48FupgCSjyGbDEz49zoFkC
         2G5e1PVihC4WXTaLA1MZ5Q/aFbi93sRGOYRaWJbPnzGQl3LjqtlcCG/zbKaztEWU7HMX
         WxHBAB9CTnLSOiYFEgyDAQ9dRGH7U/nEFa7Cfqf8y4SUeWj0vwwUAE6Id/j7HGDIlZt5
         xthbPxykdbLmImZvKfmOL4R57/AJgPUBpk/6OgwIu62S9eIdPygUySTfNkIDTWPDcJo4
         4Lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754586772; x=1755191572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yEUJrNTVfNIvacBySzD/xtaOi3Go1shw4gqk3/yKQ60=;
        b=GFRw9VwXiaJrlhYPk2gD3bKBV1rmo2mD+znuzipYjF0ppCWfgFm1nM1hMhKgD32B62
         YV4pbAsrQrrnGWp65JSUbhyVk4giVLd/+bRx4zTENkwsSdhADzH/0c61KpQPvsem1EcC
         HK8/Isz85G1YKr+gtUnWfx7Ul8b3ZMweHmI3CtgSl/aq1pbeRwtKH4ZhQ1Pg7bvKWTor
         LCyWbO1CkMfqZWTTF5UjGnAM43uccXA8gw+2KygO4o6bMgUIm+nafk1y7CvH0aASmsB5
         yYrYHTradBURR5cWu24soPn2UhzIRFuRAEsAe0lb/tmsaMcCZfgsJYmogKPNv0dj5chY
         8pug==
X-Gm-Message-State: AOJu0YyTXYQBnmDzI/7jcwpPlDN2xyAfK3tMfDEJV5KJdalPr95D0Qan
	JFvasH4oX/NP+cgJ4iaeOH97gzlU6j3KE9shNUVCPOv1rK5R/GA+8BMs
X-Gm-Gg: ASbGncv8DRrbJXQsIiy60iHbXJSRFuX4kzgfWJ1Bu9HMJmznTJrWSwDwZP0XOYrulag
	kTlwo2LBBnV0xelBZ5mSAQNp78jXU61j5Soz/ByCubcyO/MPrj7HXt6+dX1BOMW9GSLPBIhv2oA
	VXYIJh8kBAmKwJNp50CSMJ/+HyhYdMq7BnTkm/+Fe9LlEDfLero3ly4GTWxjyUQwIB4a5tHpHMs
	L2uSBqEloRBwLPayUJ6pQfWgB8aAYPUdK9+gnZmIQDmhbp2t8cQfkocBWPtTQbo6yIZz5sBIvDy
	K72970h1wBxM46CcrhxFK/AYDE3KXVxIpevirali8d1m1TOhE0oW/ykSovhwiten8wbx2w84a0H
	tRAMLrXwqr3LtjjqL/Nt7JxxAoqHr
X-Google-Smtp-Source: AGHT+IFDp/pH+iVJaWVs5CYee08Thd88h164T2tOnvjWqZ6T+8QyA37ORG7NjbZDbwdSaJmL+/ye8Q==
X-Received: by 2002:a05:6512:3d8b:b0:556:2e02:6957 with SMTP id 2adb3069b0e04-55caf35f712mr1032543e87.9.1754586772390;
        Thu, 07 Aug 2025 10:12:52 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cae595sm2715631e87.155.2025.08.07.10.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 10:12:51 -0700 (PDT)
Message-ID: <c540359d-b609-425f-a921-c7dad3213811@gmail.com>
Date: Thu, 7 Aug 2025 19:12:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
To: Marco Elver <elver@google.com>, Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org
References: <20250805062333.121553-1-bhe@redhat.com>
 <CANpmjNP-29cuk+MY0w9rvLNizO02yY_ZxP+T0cmCZBi+b5tDTQ@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CANpmjNP-29cuk+MY0w9rvLNizO02yY_ZxP+T0cmCZBi+b5tDTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ycw3hpq5stcsy17x3368p7atqe4rt5to
X-Rspam-User: 
X-Rspamd-Queue-Id: 513124000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754586774-714628
X-HE-Meta: U2FsdGVkX1/5bFqRhD0npHm2Li6UqXSOxK6MqPpGXAOdDXfWSF8L/Bk7dF6Pj2YZgpEhH1F40qs0/DuqMfQrgY3+BBZblg5Kh+4wGQFLbmm4m+R+TiARJLw6zEshCiQidCG6ekMVRzL2fbkiBzQeNfIwM7oU7lAdXDqOpPzMY2B9T+DR2ljDS6eIFbTQg8aIG4VrsduWaEtmZTBHwyBI1uICv952nP7Jmo7n3AUQoRdBtQKetTnrO3DPJImgUiJ6/1XHiQaBjAUu5+sowNjRBQiLFrk/04jlTX4Via1sVeVPvfMRnlowhxXCaiBPaqC+JiCJ+SEokwjQZfhIznyAmd8T3tW4rbvO7W1qcss3R8QdMPM5n62uQyFxECvyAU+25eFdx/0K0oFSOQcalKWhbRzOPChAGvLi+RtTxVmVACoWqkFRjPOP4Z9pV8EcfshIpD7MPluuniSBhB6PQYDfkZGizlDQhstlhjjydNZS8RGupwpLbl7IdKBE6wFPbXdxTfKsxh5Vgp/BS3uE0D6P58lbOSpvJ8QW5TOY+jjoC3fM0aU8vgk+S/ixA+f4y59EzWXFVQLmlGYV0z057c5CEUUiI6aQ1sPqTYEX1l7UW7WqYE2HIeIfjBvZoyGtv5AQoe28/S5MkJmfEEEvfrMRFv4T5B15cBKCtTWxhgchDzgcjm8Bv2rzoa1HsC5tpmAQbKug1RYRagJEjBuqJYkfRDmqWSobHtf93T5+r86BGk3AQvopkdAAGT1hiDk4HlRAzk+nIqQUGcyo128CfzWDmk8IcfIS4F16ZOysZEHAA3rQHclqydSxCaMdRk2gzsXzTp5lHJ87TNawtHfS0Rl1c7TWRI0kjoao5QXIy2FgwKbbI9A14BNEzBFysk8hkMmvEmmJTP3bsVaoixOjQ1Rm7CKdznNP4Fy2P+BMTuQF6s3Na/uo5MSz9b3gySzmrIZ3WTBjR+cmtMd8zuUhsFi
 VyCwAqlZ
 RB+TOYRtDQZ8TZ8kZ4qc+A63t7v4GLFj2wFcBI9Byn2pmu2y92R3FNR1WRBh21iABb71UgPjn6LA3BVWZnmJdqSYfS1vzgPyodrRuRm4q3HiT9I/3vC9oKl5/igd6tGhfeCdni6fBBMGcuc/zKEmQvDchkAKUubWYP3Llous5iDD/eeJLTuQEu6w4JNDdFXn51DR1N3KHG/5HgDu7KbNp+tMhrfuZRRApTMJzhdzqN4oEFDjlynN9tZByc3Fsordvrpq6FU6U3QLSPe+xStgp9mZd4NZ6oVU89JbvMtdVJ3LI91PY0ZDszaNBJBgrJLUOwN6BGrGMOqbgzWeIvqEF28yOhTLvPdald5vkvSjpZpaywLpvHSyg3aGy2LbNtCQL381JHvJTxJ+7XLzfM8m6jaMbI+ZEE6tkhm8rb3HbEU9QSXNmNqLzoth8TVK21ZYHjhZasr+oCbe6IUd1MtQ9OIplbmiUyU4bZkJHsrBJQ/jpyXb3Zpf3j9IeRHczAbGhcvZBi5L1f3rZiNNDfQv1cMYvbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/25 9:16 AM, Marco Elver wrote:
> On Tue, 5 Aug 2025 at 08:23, 'Baoquan He' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
>>
>> Currently only hw_tags mode of kasan can be enabled or disabled with
>> kernel parameter kasan=on|off for built kernel. For kasan generic and
>> sw_tags mode, there's no way to disable them once kernel is built.
>> This is not convenient sometime, e.g in system kdump is configured.
>> When the 1st kernel has KASAN enabled and crash triggered to switch to
>> kdump kernel, the generic or sw_tags mode will cost much extra memory
>> for kasan shadow while in fact it's meaningless to have kasan in kdump
>> kernel.
> 
> Are you using KASAN generic or SW-tags is production?
> If in a test environment, is the overhead of the kdump kernel really
> unacceptable?
> 

kdump kernel operates with limited amount of memory, whatever was provided 
in 'crashkernel=' for the primary kernel. So it's quite easily can ran out of memory.

By default kdump uses same as currently running kernel, but it can be configured
to use a different one.

At least in fedora it's in /etc/sysconfig/kdump:

$ cat /etc/sysconfig/kdump
# Kernel Version string for the -kdump kernel, such as 2.6.13-1544.FC5kdump
# If no version is specified, then the init script will try to find a
# kdump kernel with the same version number as the running kernel.
KDUMP_KERNELVER=""


>> So this patchset moves the kasan=on|off out of hw_tags scope and into
>> common code to make it visible in generic and sw_tags mode too. Then we
>> can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
>> kasan.
>>
>> Test:
>> =====
>> I only took test on x86_64 for generic mode, and on arm64 for
>> generic, sw_tags and hw_tags mode. All of them works well.
> 
> Does it also work for CONFIG_KASAN_INLINE?
> 

I think it should. Because we don't initialize init_task.kasan_depth we always
bail out in kasan_report().




