Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC86CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992F08E0008; Thu,  2 Oct 2025 12:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A368E0002; Thu,  2 Oct 2025 12:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A77B8E0008; Thu,  2 Oct 2025 12:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7855A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:45:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 305191DF968
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:45:47 +0000 (UTC)
X-FDA: 83953750734.03.DFD7851
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37BB720014
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:45:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Qh3l6E3S;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759423545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1A9QR3g98F/jojxQcsQCrmr26ivi3VklZB9Uaf1MTlU=;
	b=Syxp3F5oFMz6O7ZWjugNq2KxjFssG8BonLnPTtq/iFLf/H8SCVU4qZDhEXVO1zVdNMo6GU
	P1mETC3Lxhj54MALgw84jTzjgNQx6LA1Lta5XfvCKzXyx1MmMcgYoqSaFy57QHvlyxJ4CE
	f5nfgoLU6vR4d6bgcnh33JlR9bv0a6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759423545; a=rsa-sha256;
	cv=none;
	b=RwDEwXJy4tSRd3fj56xz6J4X0eIRUl58/eqXFArTXTINtIerrEo+zaBL2xGVDdeaFDF5q8
	vL+00Wt9CKrt8ymn2/D5/7VldPUhs0iGeTyEefkoZb0nS6AsBamqtGW2tzICRR3ZKXykWC
	sTQ3ONgvR8kYtUX5/HlnC7BHy329j0U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Qh3l6E3S;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33067909400so939900a91.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 09:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1759423544; x=1760028344; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1A9QR3g98F/jojxQcsQCrmr26ivi3VklZB9Uaf1MTlU=;
        b=Qh3l6E3SgHFUSZUIIVdD4dhDmU3h7aGjfleYCqpXVlfxCLRyfWKnnrlFo38ohI2sW9
         4hzlJPsTODArmhVXxXfo12BMDwkSEi/kqHBjVaUZ8tlKgCbYwZOyjpc3hKlcOkVO0VAZ
         YPLyTOSYLwBgtj6S0nwKr5+3nCEWTXy9YH1nHDzCehpl7Ol2n9Vi03PYfOwxbscSN8NK
         3mm4OUg7eRXhl7et4okSGAKxI5kFveypT9w9ojrUj0DJrDfs6EEicV2y0oZkVjcKEpj4
         9mcdOmjMSIegHVm1r7H2+eBqSF+ds0f5ceoLcOGQzVJDfGaa0p2bJPjsLXU6FK2+dW/h
         fjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759423544; x=1760028344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1A9QR3g98F/jojxQcsQCrmr26ivi3VklZB9Uaf1MTlU=;
        b=cZneJGoHaVym6DGaXEDHb+kget1oD+4OFpa4ZvTWceepwdAs6u9R5OmiG/jwZfFJGc
         OLBuNMP36CE2tALARu8uwaA8Q3E9IVFgr0d/8SLkAsD5PXljLp4382+ibacQpmwk+pXo
         AOn+g6duekBNOwZsEKsho34DoVDSPkWcuLXxBY/Z9xcOIErYRW3B91fm/0IRqoDTr8me
         GtG+cez9C6Nyu9sw/ccmzEjMcQ0DdOD9X2Q7RJWz91ojE1fW/d60EX7mHgdtzh+Jr3WE
         rbyoPv/3a01bZpeLFBx6RGRJkdWwgYuj9zKkfv9lGttHocVww7qEXjaCAf0hhd3vAj15
         RwvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlyX8YBpaGrNZ5jMRcHICT2m5zgM9N6FXVkxkxXVP/tdPaI2lTE4o+W9436oMAT4b/dRJurKSxrQ==@kvack.org
X-Gm-Message-State: AOJu0Yzw8qZMx9THS/q/wETAVwViw5JazDofLa2Zl9FPCzv58DVZPVYz
	Zkpo/fk/NvWpY8u+RihWcfUnsmp0b1QU+9PbnwuUOVglzQ8GcSvyTph1+AFp996JkNQ=
X-Gm-Gg: ASbGncttQFujjPmJ8q4e4w1lrwC1BUDERK5eIcSxGdi4mx4AP4jou5rHL3KVgrXWYm1
	LpshW5yhylipOSbEBtljGrCU6ovLSrtDJW38/SNBP8gncXSCyVFE8mfPYTjB9fHCsrHTYU1ZHKz
	I6c2sq2+EoQT4wMU47eX5Hb3YiQXMbczwOyN3ZPALPZ2/9fZ6KgksE22ql/eW0HhXSYdnJtJ6iV
	8g7Bvw4YzFNQr+vk468S1JpUy7q/IIE4mLWSSjNWSn2pc5wsnhHiLir/+2ZxM0tL7paVPICzTl+
	5r787m5tJDo9dUU/w9vdXevwDNcmEjsqJ9JweVMJqXCwuJba6dcVLmQz46FUL33YV7NLsbcxeGY
	iNp9GvF4u+YsKQsmHT/QdNLp8mwoNHB8Z2pGUpIursjS/K33caDqWnBlg
X-Google-Smtp-Source: AGHT+IGOeNAivntNqMaBDACXUIJXINgHBVnHmalDozgA9lIHXQF1UAZCwzUqmrzChLzk9pEqivj7cA==
X-Received: by 2002:a17:90a:e70f:b0:32e:e186:726d with SMTP id 98e67ed59e1d1-339c27a1901mr8380a91.31.1759423544003;
        Thu, 02 Oct 2025 09:45:44 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339b4f3ceedsm2812742a91.18.2025.10.02.09.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 09:45:43 -0700 (PDT)
Date: Thu, 2 Oct 2025 09:45:40 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Charles Mirabile <cmirabil@redhat.com>, pjw@kernel.org,
	Liam.Howlett@oracle.com, a.hindborg@kernel.org,
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
	peterz@infradead.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org, zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aN6sNFBzx8NPU3Th@debug.ba.rivosinc.com>
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <20250926192919.349578-1-cmirabil@redhat.com>
 <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
 <CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
 <aNcAela5tln5KTUI@debug.ba.rivosinc.com>
 <lhu3484i9en.fsf@oldenburg.str.redhat.com>
 <aNxsWYYnj22G5xuX@debug.ba.rivosinc.com>
 <lhuwm5dh6hf.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <lhuwm5dh6hf.fsf@oldenburg.str.redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37BB720014
X-Stat-Signature: pi19xdfpd91rjzbh11oabr136xq9phoc
X-Rspam-User: 
X-HE-Tag: 1759423545-4211
X-HE-Meta: U2FsdGVkX19hdqVXfvmThbAuRMHpORVrcK91B/w0oPkjHHzkpGqAGXgWkb4dl0UIASrSYtPscUjykuwgpAruXWFk0fswaWokTfZ7OY7gqGPIuFTWcOrxJceWXvPHOZaNewONj6QFThTn/YwAj7Bu8yg81BZPJ/WVM2wkyZ6l2BzeBJJkYYjHnw88nTnx3zZdZzk2raG46OGd4U6bCiwKV5AF9GfDe/W2UCA9xl+P55n2QqnVR6+lC7NIrHtRMrTN3V0AuU0QaKektqo6qmg26pWkCbxMT99spwYcCdOabUdmyjzMaNXjGZvZPiyZieyYT2JIlmZu3KPCldz7DOvCY5kA89V6ZQkml8tFa2gi9Uo6EnTGeLvvNITKm59mr1BsY+GZztRZlSuzsbx2lFXpHw5XZApqD5oLT5KdtooIaeVArPHf735VpaDfm0KfOLF3LBkFBHt+dcmbEf+I2APP5RDGzq/EVWHZfk6m5uEQOTMdzil0WZk0LntE2CoL98lhhNnNYIV3risaLd8lcSP/l08zNxWbnKPABKjUKoVf7KcuKk6iJpnxCRVpMXxVIilqdWMB9PWCqmLgv8vP1SzkZG/CB0N7baUGLH4FNnQ+UmVWKKfdT11QbzIqqHfDPOtrtjm3r/KFeJvNEv8rEk0R4vKDPvGNRI7mrFlX6kuGNwlg7ZzAviQYUT5/da/akViQ1EIAF11qrzCQxzERGhdV6sjyFwWVd34Qld8oRgEFYj28iRKBs2LjOwbabtdfGDRogsUlJ5zqWri4KazjP9rnXrlUejGgDMaseVxbdT3utOLX9oZeC2rASAR9mJl4RPCU81OR49UqoS1SkA/plpJqnbBsbo74m7Ud4nxvQ8oFO2oEnonIeYsGIEOHm2a2H+Fo4ryrkPU+hV+Bqu6P5L6f5kLeFxu8XlduA7QDKvqOS3NjZmOQRSJ8XIVKCPLxafdjwDacpkla2t9n/PKIyxg
 svkm0exg
 M3ypkngARjWTVP0TFzJHg/bPd94yqjYHSCZCEdUGr1/XJIorMEdCnEepiiMYsaoxLCjADtevBydMaCnk+VgGr8lqhvdBwpqwQKGQ+m8T4o/ezDx/G34W9rh8t1TakBH8mvT/L/Fnt31coTwRVAmqBZcs7dyGvLnn3Ryb4oYsIRBbja7qJpJ6fKIVZQXHczDBMcuwOjW8UNVu2zKTjAhQRvpdZZGSOMJhUxzPzLwnwNO4dLmbKeDyrI1tE1ly0bDXVpkwSyMxubbQzxi1XBrbG/mhvmsgM/kIspK/DOJsyaYeIOsUYheY5IaIYefZAF0WV0PClWtGfSMH88gxHmOo9miH9nRHYLLSBhIdghxWVnjrRbH4D+8kRAk9Bia6UJ9KxIMVE8PtWL00tatM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 01:45:48PM +0200, Florian Weimer wrote:
>* Deepak Gupta:
>
>> On Tue, Sep 30, 2025 at 11:20:32AM +0200, Florian Weimer wrote:
>>>* Deepak Gupta:
>>>
>>>> In case of shadow stack, it similar situation. If enabled compiler
>>>> decides to insert sspush and sspopchk. They necessarily won't be
>>>> prologue or epilogue but somewhere in function body as deemed fit by
>>>> compiler, thus increasing the complexity of runtime patching.
>>>>
>>>> More so, here are wishing for kernel to do this patching for usermode
>>>> vDSO when there is no guarantee of such of rest of usermode (which if
>>>> was compiled with shadow stack would have faulted before vDSO's
>>>> sspush/sspopchk if ran on pre-zimop hardware)
>>>
>>>I think this capability is desirable so that you can use a distribution
>>>kernel during CFI userspace bringup.
>>
>> I didn't get it, can you elaborate more.
>>
>> Why having kernel carry two vDSO (one with shadow stack and one without) would
>> be required to for CFI userspace bringup?
>>
>> If Distro is compiling for RVA23 CONFIG_RISCV_USERCFI has to be selected yes,
>> kernel can have vDSO with shadow stack. Distro can light this option only when
>> its compiling entire distro for RVA23.
>
>I think it boils down to whether you want CFI bringup contributions from
>people who do not want to or cannot build their own custom RVA23
>kernels.

How will they contribute to CFI bringup without having a CFI compiled usersapce?
If their userspace is compiled with shadow stack instructions and they can't take
this userspace to old hardware else it'll start faulting as soon as control is
given to userspace (first sspush or sspopcheck in userspace).

>
>Another use case would be running container images with CFI on a
>distribution kernel which supports pre-RVA23 hardware.

Container image with CFI will have glibc and ld (and all other userspace) also
compiled with shadow stack instructions in it. As soon as you take this
container image to a pre-RVA23 hardware, you won't even reach vDSO. It'll break
much before that, unless kernel is taking a trap on all sspush/sspopchk
instructions in prologue/epilogue of functions in userspace (glibc, ld, etc)

>
>Thanks,
>Florian
>

