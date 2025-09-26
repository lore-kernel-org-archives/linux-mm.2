Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A147CCAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 20:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044DC8E000F; Fri, 26 Sep 2025 16:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01CF18E0001; Fri, 26 Sep 2025 16:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74D08E000F; Fri, 26 Sep 2025 16:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7C498E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:03:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACF571A076A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:03:56 +0000 (UTC)
X-FDA: 83932477272.07.626B170
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id CDE0840002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:03:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=M4+TzyTR;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758917034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JzK9TdtNq0q6HuoPTI7S0mcgrs1VMBW3yQfWD8QK0g=;
	b=TLwcSNF/Ed8zXo7vT0ykz7NFZUhckGBEE4rk+fdRkqjCOpHf4yYCkGkFFXb1rkojZ11eTs
	PtcOYgE+iQTh8fcc2c4o/oJeZLEYTsZ02Rp0ZMiQXw4nEm0ixGzJfI+9+Tsl8Nsvo7+P9G
	j2ZVgyA//eISmmSS9c8cax7dn5CTBUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=M4+TzyTR;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758917034; a=rsa-sha256;
	cv=none;
	b=TEfDvW/u/T0+/Bk4LJP3TGT9ZPs5AZilzNj7q3X5lixKgIHLprx5fsAptA+vKSrAL1q8TZ
	nJ4/akIa/n+zNCJr11/dztb6NV6CFAGDU7WavwUWkeDJrYAZ3afZtQBQ0hn22pIcFWQHaP
	Rh5JEv1ed+PSGfx03GIPzVKglVg1M1U=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27c369f8986so25750125ad.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758917033; x=1759521833; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2JzK9TdtNq0q6HuoPTI7S0mcgrs1VMBW3yQfWD8QK0g=;
        b=M4+TzyTRSGKHXuNCvmZdtjARoQJ1vluTU1/lNHgekbV1VA7r376fR78lBCKCM14eou
         U0FZw0mhvOe8BLI7sUw009T/I7myxSC54uqOn8w2kfnGOb97GF5LuEEIop7hTlsy+oZK
         mht30JIgwID0UnAs8h65+08tGeyz2IMyACJ+2e9Wb2pqh223YD1pI5ia1KP2XDBGAHgq
         Oysq+dIjtFJbhgYe/zQlSnII6OY76uS868e8szKaJm5lD2jH3qn1+kZLPwiceV5AB4vm
         slEEP1Vxcv6jN+nvglgHCOuv9SWY70ef98VjGlDuYjfbGKc+a7sEASUaRKqHIUHRgvJJ
         M0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758917033; x=1759521833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JzK9TdtNq0q6HuoPTI7S0mcgrs1VMBW3yQfWD8QK0g=;
        b=GDDZpMace+nDrplcx0Rmf7qUvf8R0HenxIjGgWfDcYsmHhQhPIkGfN07/xEU0oUh0t
         h9iMpdbeYjRKHSR47LrscmT+OHcRYOX9oTdpwmDohshY84A3pYKWgz19Uowc/5aUsc0a
         e3mkg1zIp0TliKVYwwsBj7R+qeSKyRVFr3KUny7T2/ciUNXH8PP5nA9cioCEKRa/pkSj
         qAL7VFJ3QfrwHPhkhep+bI+0nW6RcVD95q9feiRLcZdBBQce4/U/pWyTNRc05kWi8vnI
         oVKhVLaHQQkEGKIjs7eZQgh6vdNuu+1k6Dw594D1prHszEj+4TAgwqJfc6bBt0kEm6yk
         Vi4A==
X-Forwarded-Encrypted: i=1; AJvYcCVaJmNmISqkHqs+nqW+N6sumo7gFBoMYpme9S5tANTYwmTfA0FW2C8RLEFtDHD3WI0wvMbaa34MDA==@kvack.org
X-Gm-Message-State: AOJu0Yw5NkLkv1s16zvdI2lEMQxSUbR6VPiX7baDYgd9DwE1RApEkNoQ
	8admqFtR5Pg4bR0PW6Ev+DpWj0nsd63Z8LRZBZU2Yh1DHgyD9daUdrLwLXw7hW/yJac=
X-Gm-Gg: ASbGncvLRyEPmLzKMu82rQMyhlW9dhgiTP3KFI0/kCEYaFIS7c9NVFgxhJ3DfWZQPIf
	K0GcSxLEebNbhz01grdo+HK2bUw1lDVfLKbIMknUNugXfldg/uq4L7X+ovxGww5Ma2Z3R2Urv9I
	HKkjCZURydxio9Fpcgnd7tHpcOlYYfkLWmI5TS2VOV+0IdPzkYaAeqTW/SOS1LY/HB1yCJhQt5U
	Q9UAJ7kIb/KceAQ2YtQTHVOAqrjdMofRCGjxgccimpYkxpcj4yMAkuVE8655u27UFwO7pZoZE85
	ZaqR0EP7e93sdxa68OpEWV7jRqqUm5EjAJXkwZa7qSPWCcpV9NkdWzk1Ik915tSp3uTObJxMBzO
	TUkPmo7KNm/4eSkLV36RlE+pr0l5iO18V
X-Google-Smtp-Source: AGHT+IEqlWQwd3Eq3xfSDG4ZoiAYivk9596CJNNVWWuT8jIb87TOCzT2mxQOQP9H5ZgZVw/+ZQZZqA==
X-Received: by 2002:a17:902:d052:b0:27d:69de:edd3 with SMTP id d9443c01a7336-27ed49d2c63mr75874405ad.20.1758917033572;
        Fri, 26 Sep 2025 13:03:53 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69b0685sm61092355ad.116.2025.09.26.13.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 13:03:52 -0700 (PDT)
Date: Fri, 26 Sep 2025 13:03:49 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexghiti@rivosinc.com, aliceryhl@google.com,
	alistair.francis@wdc.com, andybnac@gmail.com, aou@eecs.berkeley.edu,
	arnd@arndb.de, atishp@rivosinc.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, bp@alien8.de, brauner@kernel.org,
	broonie@kernel.org, charlie@rivosinc.com, cleger@rivosinc.com,
	conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@redhat.com,
	devicetree@vger.kernel.org, ebiederm@xmission.com,
	evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com,
	jannh@google.com, jim.shu@sifive.com, kees@kernel.org,
	kito.cheng@sifive.com, krzk+dt@kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org,
	oleg@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
	peterz@infradead.org, pjw@kernel.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org, zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNbxpVddsTXL7F6T@debug.ba.rivosinc.com>
References: <20250926192919.349578-1-cmirabil@redhat.com>
 <20250926195224.351862-1-cmirabil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250926195224.351862-1-cmirabil@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDE0840002
X-Stat-Signature: n9885c38wtyphw5dhmnhuzhiejsipdif
X-HE-Tag: 1758917034-103084
X-HE-Meta: U2FsdGVkX18tI1nFxJlCEm3AXHJUQ33elgprmnPy7wYl7TEtCjp7OWwZvuCS3sSUYf68V/NibxRP2HPSgk/dEnTyZkgB74HG6e20awGALzXDWb+MdDGs570cyQHOPa52y+PZ8negeUFjf1B7ujIVpYGRz7V2tCKKi874MFJ3RX4qFy/etBlmlMniY2kX5FuNhHhQcFDtH2qpcyn70PrCmeZZ1FEwKy6atXJAO3ailwA96xRcLvKxv7NTFGF/ILsfAN1xmzJrwPMX/1QhmUzyFgecKV5Gy8+0eBb3KdTdbO8eImGJxUzum4pAvE0iAQgksLoCqMW3DruuzMOY7eDNT0KLLT3vL8aigqHO8tIcayYBYYv9FdibToztH7WJAKXPrb5mM8dwSi+WhZ0iIU1plMn7tOhAkUbeXvsibdkKB5EXdq+IvzjieJgfjwhaSOYf5pH9Nv9E+QvYrYy+pUN1AykaWqK6VrD4FGExxM9AVsNomF40twMW8axiW+PMw8Kje8uT0vD9d9U+Tbd8qD8ijslxP/gQXy/CztJcyc5yCXU6DouvyZYfkeAUzspfG/a2KrL8qm6sU6LxefhfT7h3XSSh+qysQVQNbRkocp1nYGSUSiccu7tMOH0LDzQunQ25RlVHJsavkfJJdNm03Y4goiqoOJBhbP5ZqReD4ifOE2As8hVbcr5vHkAe7OQfEy5Byr85opCX4fxhvepzkuPET4VowdwlztJeFZZnIAL20OMoO8KCEyxjtwNjrqa+srj8vXrCgxeYwi2LXMAP+9N3i4lOINCcmW74B6UdJBmCmrOWFP43q/+ODyHTqYAOPTm7nDXRw902coqBm1wcG97IyVAn9b3RH6v4SORLM0y+YBik+vga89u841rSk3KSouCmPVSdwWAqXPuaELJQSck7cywRBkoeUScTryvIuFbo8Vm8EPJQL1BCEJZCQ8xTIie4YE9S9UH+n3vkjUb4Cr/
 SWmwmSFZ
 1ASboPExOaW5sfHZWAVYDLeTq52utPkjCSqxzJryCT6HeGit/Mnlh63MCS92IFBDRlUo+xADmlCLzH4y0eMeayFiYGrpnB1loym7kGjQvK/5NJe/Ey/J4vLaXDRz2FyE6R63a64sA3z/B5MNbY5BO7I8zhwCEPwTV6pYn4beJhLWSmCOU+sOMi/tuAjzN4cZlQs4CBZPy68sgfFtv4GvN9NwnkDZaeolKhU4Psz1//dvHUmcyxqhe93bN67eMmpaEHAQCuBguhjlzTZdKwUntOK1Ew2MMMFtI3VRpNDZUVMZ66uT1koLbz8u7COAT3pk0lgyIKG+0lEr4zmYVyobIwt8+6zR+jndrGIGOe+xI+MZyyrt63WRDDZM3Dh3+I1sv9iPcN/98dLIHDa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 03:52:24PM -0400, Charles Mirabile wrote:
>Hi -
>
>Sorry for my previous email, I realized I was mistaken...
>
>On Fri, Sep 26, 2025 at 03:29:19PM -0400, Charles Mirabile wrote:
>> Hi -
>>
>> Hoping that I got everything right with git-send-email so that this is
>> delivered alright...
>>
>> Wanted to jump in to head off a potential talking past one another /
>> miscommunication situation I see here.
>>
>> On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
>> > Hi,
>> >
>> > On Thu, 31 Jul 2025, Deepak Gupta wrote:
>> >
>> > [ ... ]
>> >
>> > > vDSO related Opens (in the flux)
>> > > =================================
>> > >
>> > > I am listing these opens for laying out plan and what to expect in future
>> > > patch sets. And of course for the sake of discussion.
>> > >
>> >
>> > [ ... ]
>> >
>> > > How many vDSOs
>> > > ---------------
>> > > Shadow stack instructions are carved out of zimop (may be operations) and if CPU
>> > > doesn't implement zimop, they're illegal instructions. Kernel could be running on
>> > > a CPU which may or may not implement zimop. And thus kernel will have to carry 2
>> > > different vDSOs and expose the appropriate one depending on whether CPU implements
>> > > zimop or not.
>> >
>> > If we merge this series without this, then when CFI is enabled in the
>> > Kconfig, we'll wind up with a non-portable kernel that won't run on older
>> > hardware.  We go to great lengths to enable kernel binary portability
>> > across the presence or absence of other RISC-V extensions, and I think
>> > these CFI extensions should be no different.
>>
>> That is not true, this series does not contain the VDSO changes so it can
>> be merged as is.
>
>Oops... no sorry, it looks like it does. See 19/27. I was misled by the
>cover letter which said to pick that patch separately. I completely agree
>that that needs to not be included if this is to be merged.

Yes I sent another email.

>
>>
>> >
>> > So before considering this for merging, I'd like to see at least an
>> > attempt to implement the dual-vDSO approach (or something equivalent)
>> > where the same kernel binary with CFI enabled can run on both pre-Zimop
>> > and post-Zimop hardware, with the existing userspaces that are common
>> > today.
>>
>> I agree that when the VDSO patches are submitted for inclusion they should
>> be written in a way that avoids limiting the entire kernel to either
>> pre-Zimop or post-Zimop hardware based on the config, but I think it
>> should be quite possible to perform e.g. runtime patching of the VDSO
>> to replace the Zimop instructions with nops if the config is enabled but
>> the hardware does not support Zimop.
>>
>> However, that concern should not hold up this patch series. Raise it again
>> when the VDSO patches are posted.
>
>@Deepak, would it be possible to just resend this without the VDSO patch?

No we can't do that because if cfi is opted yes and user enables it then an
indirect jump to vDSO function will result in a trap to supervisor and then
SIGSEGV.

We can compile vDSO without shadow stack option. That leaves vDSO as the only
object in address space of program open to code re-use gadgets because return
path is not protected with shadow stack (thus dilutes security properties)

>
>Or to rework as I had alluded to to check for the presense of the extension
>and remove the instructions from the VDSO at boot if it is not found?

I have responded to your earlier e-mail on this. TLDR is

If kernel is required to carry two different libraries with a need of patching
it in runtime, while rest of the userspace can't be  patched in runtime. Is it
worth the complexity to enforce on kernel? Because we then will be doing this
for every future extension which takes encodings form zimop space while rest
of the userspace really can't do that.


>
>>
>> >
>> > thanks Deepak,
>> >
>> > - Paul
>>
>> Best - Charlie
>>
>
>Best - Charlie
>

