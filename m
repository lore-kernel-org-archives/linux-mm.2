Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37CE1061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA786B008C; Mon, 30 Mar 2026 17:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B7E6B0095; Mon, 30 Mar 2026 17:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A236B0096; Mon, 30 Mar 2026 17:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3B946B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:09:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 381D259AEE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:09:19 +0000 (UTC)
X-FDA: 84603970038.09.E0DD637
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A0FD180007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:09:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NsYiNxWj;
	spf=pass (imf16.hostedemail.com: domain of chrisi.schrefl@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=chrisi.schrefl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774904957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlsVcWSeeIpbPnsSYMwOt0k3yfDPRs+s8ihr0jHypXY=;
	b=hIYDkueb4oq7/4u2c1V+9WSq+EAajz8I1Si4joeNHYnxgdV2/d0v6XGV2UPy7JgX8DECi8
	z0GAB0lioM6cUItGs3i/siXmnYKNu63oRm4q+J9+ZC3HjjsSblqRwoifZ+FIautUQODGh9
	THedMezSZl9kasksede+GmL6TzZtFcQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NsYiNxWj;
	spf=pass (imf16.hostedemail.com: domain of chrisi.schrefl@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=chrisi.schrefl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774904957; a=rsa-sha256;
	cv=none;
	b=I5FNAGiaAyJOVpzsA+8BuOIdifhLPIw6vvhT5jzCWMZ4ivRW/XTPue5HNojdOhNZINUdfV
	1E1k2Dut1At7UOzgmh4+gf8Y/50QKxhnCuuKwlTanHcb6CUfI6vYqSCUNnTiFKmc7U2kLQ
	cVJDOBisrAMNcZm1pBT1PRgV8qqutO4=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-56cc6fe8815so2019767e0c.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774904956; x=1775509756; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zlsVcWSeeIpbPnsSYMwOt0k3yfDPRs+s8ihr0jHypXY=;
        b=NsYiNxWje1Bb87agZWTyC7Py+Ud+aB0jLmBgwcl4su7fsAf8FXDztcRpmLfdx6yLFM
         QjPrFSwFfnQJ24LzmOhaS81PznVdYEii3HvhCHNtD7tsjhXH/D9NccH01l2xhz3yTrdS
         d3MhxBjk1k+8BaZIufE3/onVRPI6+lWNIqsOT3WY0zz/nEI84SPN8hE/WgX2Y0msVzHP
         wAgphYoyKzIXByRpdEeN3zFLauK3GXa+2axgax9sT+dIGFb2+kHvehaleLg7M/QfeqND
         RUKEYkcfZ/sjRAv97W4l7dMvmmFwqlyhmdQzi2qlMrInx2R568fUWnj+nLqXiIrIX3k9
         BixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774904956; x=1775509756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zlsVcWSeeIpbPnsSYMwOt0k3yfDPRs+s8ihr0jHypXY=;
        b=tMme4wXd2KIV50hluCFV1H9md8z+A+pBL5qtm/yQUk4K+wFweKfaXh56BQVoJD7Ee/
         I/8HFCnRlNbnsdet8O44lNq2XJ/nVR59ki21d20i0DMX2zgwiYFkqcpsE+9YJcsGMR+o
         ioNrzbafcynVliB6L/jfjicLGbUO5uTAg31pYIqg6wEcA8S8gRtiFKMCp6lVCl5jVSb2
         p9/YL4budzz66za9EWscv6Wd2pteTv/+UV/U/AnZq7r2X5r+i3vCWiVKfjUbta3cHleG
         tzww5f9LafHRNTvTLH6s8KjSI4hqflJIOuJl8/+jx11TS/MUpTgnV0hWbEPi1hd24u2c
         7hAg==
X-Forwarded-Encrypted: i=1; AJvYcCXmb1gb8BmeM+NoRuxlcjgzGn4i2dlcq1vz23O64atfO5khCBRQJDiXeS+AP7x5WjyRXqYMy4HpXg==@kvack.org
X-Gm-Message-State: AOJu0Yzt6BvAqJK6JxkzN6+hNWB9OhVzLujOQRG4l7Zznzkn/OOJa5+Q
	Hl1HwQ2rMcI1fwMFUvsT9V8MtyLmDBYfSfB4WxqcKZdsU1v3x2BnLxd/
X-Gm-Gg: ATEYQzwSwHVnW+HP6bXE6ftOSFC7DBn+ot2FmZDah2H7tta6kQXu30DzGbJEVHwjcZ2
	Sh1TO9G3oS80wb40sObGp2/11R4UwAZVnY+aqsoRbfR/caur5GqrI6tBM8A/T3+01AHZyRXClvm
	SuGt0RQ2WJe/QYnpRfeLKIk+t27sxhyUeXnEgf21GpOTBnQ/cqdlVB6N8BQOBvaneuIuSSXJGEc
	gtAHdUsLrya0OPWWJhLDa7uIqLjB4gS4QxLLNUZqrqPyPsVVQZVEH322zZSwY8Q2krhlOxgHHoa
	f4WoyFORyNH1XelYTH1JcgezwFEAZii2b3IdyiOslZFkcb9iT8xLOa5h41glvYXAodWG4w7H2IE
	yWQssIX7ozPXA8gVZ371sVs1rmMjmGBYfP4glAkxdyO2sUdwEfCHs1we1uwPo4dOGHWVBrE3zBl
	aDLbVW2qbuHnWD3duDrUpqF2il6rJWeGTT+ZMN
X-Received: by 2002:a05:6122:3c44:b0:56b:9ba4:1372 with SMTP id 71dfb90a1353d-56d4a5f8c0emr5672211e0c.9.1774904956234;
        Mon, 30 Mar 2026 14:09:16 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:d2a7::cebd? ([2001:871:22a:d2a7::cebd])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56d58a333c9sm9989448e0c.13.2026.03.30.14.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 14:09:15 -0700 (PDT)
Message-ID: <f159850d-5fe6-4329-9703-b355305fd106@gmail.com>
Date: Mon, 30 Mar 2026 23:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Alice Ryhl <aliceryhl@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Jamie Cunliffe
 <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Miguel Ojeda <ojeda@kernel.org>,
 a.hindborg@kernel.org, acourbot@nvidia.com, akpm@linux-foundation.org,
 anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net,
 johannes@sipsolutions.net, justinstitt@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-um@lists.infradead.org, llvm@lists.linux.dev, lossin@kernel.org,
 mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
 nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
 richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
 urezki@gmail.com
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <CANiq72=b+cr7Stxph_hXQTmD5crCvwWTqdaGKOJ7W1-66v4i_w@mail.gmail.com>
Content-Language: en-US, de-DE
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <CANiq72=b+cr7Stxph_hXQTmD5crCvwWTqdaGKOJ7W1-66v4i_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A0FD180007
X-Stat-Signature: m3qfhe7upedh8ksuc1f4r88kztkrpcjx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774904957-78583
X-HE-Meta: U2FsdGVkX18GYiIkUnyWE6ctRwDj7uVQtuSRQFG9FgcjMKgu9AJMReGP5lL48VEdyq+yJKR8lk5ixHMsX8ET3jOnSwK8lfi4woCn2IazTSUf3zDQ2e01U6D5ogyChzHKXhjQ40qREm2md0ajeoSf+IiZ44dv4IbXzWIK9c2X/20eovyI54VGf2Y7/70G0TfVDs3MjLVZ9WLINe07GS/Scb+F5zCLtVGRbMXUXF/5hTqIev8/n1H8cYnk7y0fvN/UpMfbjcFmzDetTgVmuynClAuQeOuReoc+2p4yEOXRhwRfHnKYr4FRHPlpCCLmASdNCi7oSNOf9VTzQ9dfHNexvDWpbd9YFCpEtELJ8fWvUfRwyYiyaEkEAjL09kyjPvZXwByGfY0hV3HuhT6evz+pi/YabTqWEIK+4l4PiQa/vCP6a+u9oe+QfJao0yY1HYEBLCa3hcXiQLZ4Jc8ns7Q3zddfZa8Z7XbJHXqGvKO0DVy/IzMugCCXqYcUPyQGNYgY1vUNSeRPZqEbSIcz8TWMTpH3ZmBzu+hSI43gqeyJbZCpxo10lECT2A3mJ0lvSUmdyFCWFAqTrYu3f6dcjUYs/fqU2PgJtulO73yiRK70QkDcBi4yHBi9A+cw2zurZMMKEUhL6g/L2FvS02zLPXi/vjdfR+dR+ti/HnYuzI5sjSBFZ/vxfop1GcO+QWGF3l1IcwQH8T4oqyVle5398GCremj3aGWrteIrT8ZPtsBFq8T+WdA7KhI1l3jItmyplQZKUDxgWf76niCztQrCtbMoXm7VODj5g4m02Qoib1y+iZojiKVTKbl0VWDvt6HECy5YoS8vZLm9rH63VSNwUQlicYZqoyQ+2XWoqFY9XFM2Y/hTsTEaQFyojW6ZB/LPN9Zy95Apux/k8xiF4PkdUgikT0lnSX0doBX1wapb3qgRZGUEGOO/EizKjKjKaK7ZgW3S8ikyPhbDRF33Tgh9U2q
 fqnm437a
 UNRsMDBh4XnWprtfF0MejCQeeGwDk2wx+OgyrYT4KJPCvXBQVuMGI9jVJXThYer3vaVnRvjp4Kb/XrIN4p8oOzatPdKy62c9ePSB/U7utdFI29YVvAObrZUFJnunjgDGwxjjt5cvEyftSwknEs0XHVj6nHFJMX6EnQBR6LVCqL24bvmg8GBsTqhdgchK8A/eJJ25lsBxttqaQvwO5tfMBozqOs1sLrbwo0VIUY4owD9cxTeKOBdctRDlLzCSjJOhdc6b6mqNVyFXtK1BmknuI/4G4IT7nMPoURn4JdX8TCgxIuGwnZoXcNLVuLjt15ZjHi5Vm6QV2UQYD/Zh412lSRELZx57usS/+a3Uqu9VDIqYMqMqO2Q8rRxx6v64nmwRMpKomJ5YKqGxXie5lshch1Gm+jqHyyce917hFAqmij7LnP6MbpoOs3ygso+r+RPVcDmWNB15lMvJgmYUHnjyLd1ymorN7AEWELQBCop0oky6HoV0iXgmur/3A7FqS/vNNU897t3pg/E83bKXLjij1XSUQTXza6MGu/J4dSdxZ3n2+P/vr9Jbhx6tT44LspEQFJoZWrvtLnZDYNkI9hUtb4Ja4um1K8Rsf5lSA8eFcynmWXjEs+lCE20+g4AgJwrWyBAnql2q4g4M4++7dyOH612UzPJc6PIJyDDYzUrX3JrA7nlx78RPvBx2N8xaWWpLHdGnWo4DRsLyxIwt9zOm6cj4Z5uWskBnPxCm6/lLZj8xN07EUy8jPlBnlGvE0nDghj9AD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 6:30 PM, Miguel Ojeda wrote:
> On Thu, Mar 26, 2026 at 4:18 PM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>>
>> I'm not sure if this is still true, but I believe it used to be the case
>> that the -linux-gnueabi target has one behaviour for enums (fixed size)
>> whereas -none-eabi, the size of the type depends on the range of values
>> included in the enum.
>>
>> Certianly, when Arm Ltd were proposing EABI, EABI had the latter
>> behaviour, and I think there were cases where Linux used "enum" in
>> its UAPI.
> 
> Short enums? I see `c-enum-min-bits` in the armv7a-none-eabi built-in
> `rustc` target, and indeed:
> 
>     #![no_std]
> 
>     #[repr(C)]
>     enum T {
>         A,
>         B,
>     }
> 
>     pub static S: usize = core::mem::size_of::<T>();
> 
> is 1 for that one, and 4 for the other.

I guess we could use a custom target spec, but I'm not
sure if that is worth the hassle of adding another one.

Cheers,
Christian


