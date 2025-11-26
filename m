Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11485D111A5
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB896B0008; Wed, 26 Nov 2025 16:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BEE6B000E; Wed, 26 Nov 2025 16:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572176B0022; Wed, 26 Nov 2025 16:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4413D6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:13:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB806BABB1
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:13:02 +0000 (UTC)
X-FDA: 84154008204.20.C1B3C65
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id B511940015
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:13:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=PgtQG0pu;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hrjCGTokKrR0BnJSuEojRuEu2dsqESmm8qkZ4/vDpA=;
	b=coDhBYbSzyZHeN2SHYc6htrde80BD2A7CeTSbwZXWWlCgf+hAehQ8UeAkIS7YTOhKagr//
	GUO1x1uyo6F5Ppk8UDsSM3EZj5N0CtuZTq6DfxTDJmHaF1a+mMGs2b+dsBpoJ6vStgHC3h
	p6MVRaZWGZzmjJKps+yjh8jiTPvWut4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764191580; a=rsa-sha256;
	cv=none;
	b=NxwutuzXb8iPMzqyRAqMj2hjgMVm8Wl0gvIzLfWh8YfpbVeP74Iq6AU4vWB5ijbMo+tpAc
	YAEnOMvS5vbOuFKuORX6bIo4RA7mbGlTYPRHyvfHBEohWmIKAHPIoedwvIzuCjR4m9Gd7o
	sUF06XnkuLRV+DcaAcEr8yXCyIY8UiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=PgtQG0pu;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b737c6c13e1so38516366b.3
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764191579; x=1764796379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hrjCGTokKrR0BnJSuEojRuEu2dsqESmm8qkZ4/vDpA=;
        b=PgtQG0pucb7LHrMQyJYrlpwqKf70JolG9sWyca1+aBRCgOu3kbvwshyQ6CL5PcIrNS
         Sf2nkEWyBzaYIzeYGxsOcb1gVEFtdrSHlMyllN4VrPc5sN7m3rU1McrbHtH+B2XPYgQT
         XvrjirsArvPh3MgXykvphyXpo5m6N4hDoDchI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764191579; x=1764796379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8hrjCGTokKrR0BnJSuEojRuEu2dsqESmm8qkZ4/vDpA=;
        b=SdV602cG6eGIUmNWSLaQOaQWVWxQNEAlaflRctRvIx8CrSunCHLnHnQrP13Krs0le0
         ldCUR1m7FbYT98LtwsqyucbHWSLxRYsoAphTqNjBQcnT7wFW/VzsNaaH/0WxZ3/maYRD
         vst5hO29lcB2KRnWb0OYK66ZD6EkQ/9cs1F4eePanWTsv+7iKxrqBMHn6/W+0u29mVPK
         jgM9oCf2wI61DPPm9hpI/+JxysELOaJE2kE8vr1+8DaPG1EFMIstBr8plPYo/X9AvI5K
         VLF8T8zxJMI3yXIY31MxfDxTVwHnpj/efexKkgSieFAn4+4In9WzMlNheo9BAGIR/jr5
         zkkg==
X-Forwarded-Encrypted: i=1; AJvYcCUWUxFuM2TC6SwioPqIqWi1kaBkjHiQc1YZbz/X2f/yGjxJb/K24uj4cG1i9IPZZfhDVvyCs1MXzw==@kvack.org
X-Gm-Message-State: AOJu0YzKBX7y8Og6IGEBPIgT6r4vlwcGSi9EIY/DTS0JhGfcq1kdur56
	9QnLXnxSr7gjBxLSpTHvWqW470hurhMd8tYOmJ49Y1f5G1i0iXLGsJwgZ3Ey1hcGRePHM25zXtP
	K1qzEEKPfNg==
X-Gm-Gg: ASbGnctZexcdTmzlHjn67+WCAypWaRBjipvF9emeQlFio8DdixGHYmy8b/bk1rTjnuw
	zyJfjFKL314jHX3+/ZHsxcUhu/1YQAmKSqoV8PVWCw0TKhGQVzrEhQgdZkfaxrLv2hmx4lfBRl8
	ejsgsZQIu0m9tD19pRZEsb4BjMAjXuhrzOIfkA32q3qOg9ewccpKzqZmgncf3aLfHhDpolFrjuI
	fjNWKD3RU6gRK/qud3+Reyllm9gmYG7Q85KhXdrcdwl6C9o7eJKta/9LvE81J6rKdGnU9qd+u/w
	VoxrIOpI9/WV5EAIRtiPICvok0FAYrGstn+R52lA1UNnzd6mRCXyQujU37YBnrJoQ7VrkpZIYPf
	lCJJlkVTwnVZMG6MePOA+eCSjLOlaCok5uEOp/1gC4DNU2a4iNv6WXAM8CAOqMvF8Ec0l1lqTMN
	SVvVqrm9VNxwJ8cR31T/6GSslbYQ8H0UK4A6BaxWKBaWureY40DR2NGMOhv8B9R7eDZUaGr7g=
X-Google-Smtp-Source: AGHT+IG6pvUCyJoM67istwf33oI3yVFinBoy3N2gvc2acR604/Xt30I17Z5kLfEj9SVoeu7U6bi+UA==
X-Received: by 2002:a17:907:daa:b0:b3f:cc6d:e0a8 with SMTP id a640c23a62f3a-b76c54b8a86mr955265166b.17.1764191578744;
        Wed, 26 Nov 2025 13:12:58 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd4275sm1903462866b.37.2025.11.26.13.12.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 13:12:55 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-645a13e2b17so415794a12.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:12:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXHOSHpDgeFQPAg1huqkWWieiiCc5X8EFdgVkBLL6lYharw5I4ZsRDdgeuvPHz+OEBzioPzoCUoJg==@kvack.org
X-Received: by 2002:a05:6402:5192:b0:640:d061:e6b1 with SMTP id
 4fb4d7f45d1cf-645eb23b736mr8204227a12.10.1764191575057; Wed, 26 Nov 2025
 13:12:55 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com> <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
In-Reply-To: <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Nov 2025 13:12:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
X-Gm-Features: AWmQ_bmijlsSBxI6qiVA8VQBddyswwSNhEs1F3E3qSXMF5yTCuTDAsS8SQqTKN0
Message-ID: <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Zizhi Wo <wozizhi@huaweicloud.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	yangerkun@huawei.com, wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, 
	xieyuanbin1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B511940015
X-Stat-Signature: d43en81mwmg1ip3wyhw3zpzzj9xupk35
X-HE-Tag: 1764191580-708015
X-HE-Meta: U2FsdGVkX1+zc4pp8oNt3I/VTAMlJrbyD5pGBO4yFgRusNVDB+86GG/JkTZbzOxF7dMCgNnkRV73SwgSmDF7Vj3m39vzI9Mny8C2xhBkhpXVbY8LP5UKqtRR/iChjwnESaAWYgJRqaRhYECAmuoRhdzmjsWVHxjMP+shOLS3vxSX6JGrVqQh3LuhWfsVC0wM42fbG58XhSPPBjuiwVm2ByTP21X6G9Si0+7itJOIbl1JCTM+SM2I7WBCp0tu9gvhikUkZY+N1FzAP2nUixWO/ur8kAE3HeWTQhkjlClDi7Vg5X6f1hlkCFMOop4uXNfuo8oeHFo51aGN70Zo+D4BWlxaQpCQm1xQgZgCriL9pwamm2bylP/FgKSZcnYrS5OXjFIHMtweBV559RNi3NhYI64ooLXZNdKtE3/ubIzX4mLeWR/RkZNksD++mbqb1mg9/6sFT14cdWoFca53RGrmVwIwillkAP48sLkcdfXYsWahblOxhg797MOYVB5Zdsnl0M6nLRfW4jup/fLkB3aq13LSAdygfyf807sMz5izRyENoH0AJYpfNg6sG/M7NnMg2iArUFswhaIT3cH9aE+tVtbYEfJMe/l6chJt/nvoccZkTDsH+CfmefLMkKOX68Jxyhe0DkL6OIIng40dfdNvauCq0YhE1A67oH5vu5mzcNLewgy2QhFs5AXtoJOmrd+zjYQSSe/MtZ1+qcE/KtV69r1zDRE6prp9lQvbJrFA4DUesjGsVRCNGNwYAPL49TmWsr2npQTq1TcgCFOvjIjGdNAOb6f7crRlxoQkB/s39ifiejAGg3fr9Mpmt06gFj9zzOBHtt2LT1vLPtz60kU9bt5Sy7Z4sQA1L89cYbVajjctwsCnA5EKNTdpl8nik7hp7WBtIR5RcNF4Rv9qbIf5Eb842ycwsFd/lOXpoNh8bDjxzxM3rm3YuJKOVIEzE2k/74U5YrLqMQB1t5pY9jF
 pwB39jAv
 tvPeewffagV88zUDuWszR5uq08VVeEjhYDeknOXP7cVQQLZ3cW919dQPRaTUo3EUl/TfecUaZJklRfbh4Y59EffmvYrv1Ta8bIZeJnyO4bNxKnkeM9nRSzYkR3SR41IG2sEsYU72MT3u2G3h+hX7BzzsQnLuF0GMSaQqYKgku2ucYgmSlJ+s7xk9N35fbi24INVOzg4nnWOTdYMJvoQGRX1ny/YCUHXggVwFsZWmkOZLC2iWBFe/021petbHoQ58kMmRbu4gwKk6vTw3g4Gj2G+g1R8Ab0CxnDRPM4UMNP+kekDJNpHpE5ig6HIse730BIi82i3fgeHbL/+JTdX6z3vsWMAKFCTWi1nRyzcAYFGT+d4L2X/43ljL+xu0rAvgmB8vKUZ47CXCDHEC0ciHxqx5QvAASF4eQfOdk7+HPbtQCLmzTqJXL6Dgd51SVWEhtyobB909xuD0WSvac4zq+q0GQ3gVR0nmJUb6NfThc6ckeKV6eEdVf/fCUgLIdP1pMQdnh4Z9hClSgYpOYFrI1mZwFk4+dEuL/523zBS+MEtLn9ak95Mae3MJ7bAKwOHrMncUIXYKSdL9XVQ3jKKjgR4mr2wzE3EdU9mrvD6ZwEgVawBI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 at 02:27, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
>
> =E5=9C=A8 2025/11/26 17:05, Zizhi Wo =E5=86=99=E9=81=93:
> > We're running into the following issue on an ARM32 platform with the li=
nux
> > 5.10 kernel:
> >
> > During the execution of hash_name()->load_unaligned_zeropad(), a potent=
ial
> > memory access beyond the PAGE boundary may occur.

That is correct.

However:

> >                This triggers a page fault,
> > which leads to a call to do_page_fault()->mmap_read_trylock().

That should *not* happen.  For kernel addresses, mmap_read_trylock()
should never trigger, much less the full mmap_read_lock().

See for example the x86 fault handling in  handle_page_fault():

        if (unlikely(fault_in_kernel_space(address))) {
                do_kern_addr_fault(regs, error_code, address);

and the kernel address case never triggers the mmap lock, because
while faults on kernel addresses can happen for various reasons, they
are never memory mappings.

I'm seeing similar logic in the arm tree, although the check is
different. do_translation_fault() checks for TASK_SIZE.

        if (addr < TASK_SIZE)
                return do_page_fault(addr, fsr, regs);

but it appears that there are paths to do_page_fault() that do not
have this check, ie that do_DataAbort() function does

        if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
                return;


and It's not immediately obvious, but that can call do_page_fault()
too though the fsr_info[] and ifsr_info[] arrays in
arch/arm/mm/fsr-2level.c.

The arm64 case looks like it might have similar issues, but while I'm
more familiar with arm than I _used_ to be, I do not know the
low-level exception handling code at all, so I'm just adding Russell,
Catalin and Will to the participants.

Catalin, Will - the arm64 case uses

        if (is_ttbr0_addr(addr))
                return do_page_fault(far, esr, regs);

instead, but like the 32-bit code that is only triggered for
do_translation_fault().  That may all be ok, because the other cases
seem to be "there is a TLB entry, but we lack privileges", so maybe
will never trigger for a kernel access to a kernel area because they
either do not exist, or we have permissions?

Anyway, possibly a few of those 'do_page_fault' entries should be
'do_translation_fault'? It certainly seems that way at least on 32-bit
arm.

Over to more competent people. Russell?

              Linus

