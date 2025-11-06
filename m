Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5C3CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 17:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7988D8E0008; Thu,  6 Nov 2025 12:09:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748728E0002; Thu,  6 Nov 2025 12:09:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610678E0008; Thu,  6 Nov 2025 12:09:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6238E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:09:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E58C4570A7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:09:05 +0000 (UTC)
X-FDA: 84080817450.02.E71C46E
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 141BA40005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:09:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Tig/9GJ0";
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762448944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxXbjl0HhdoITaZBDxLqmLJTjrhCiLD5WEPTG0leRLU=;
	b=hsil1MJ/MFgmNXb3BGX8IJ5i93ygRRlE4SSL9DpJIzhXmqKd06BHDiXx7K5yFT28jJiGLR
	RT3THPuox1cVWcu4aGjuKdxvC5UaNCVArf3abIJFpC24drQf2Mm//w+pKcjYj2U4wKReUU
	rV3nrKd43VzRjO2uDmh6QwOM7dXIhtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762448944; a=rsa-sha256;
	cv=none;
	b=kkawsf3rG26ThIP4Mts5BEevgBTi0mxgmhLqtQT4XZanVbdT+NMGkUj0FigXqt5Ee9Adkm
	HNCEg9wCvw3LeLuaT7An2eeOUhQ2ulsYIGZqG4KGKcvMn2AB8j4fOkjdNKCUrA6j/F1M11
	sRmBcVVrDmP7wOqZV8smj0Pwy6GpogE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Tig/9GJ0";
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1180747b3a.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 09:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448943; x=1763053743; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nxXbjl0HhdoITaZBDxLqmLJTjrhCiLD5WEPTG0leRLU=;
        b=Tig/9GJ0RvYbUCmFvP5V4n5rllaSVCLF0URJMfIuUOFtWFwqTXJI5jJprR47odL1Uf
         Q3Zghk5qHzUVegwnmvefvrWld4rdmAgXsiAVAmJ0dQ0OjbzXRx3HFglIvJCWr0zcGOpQ
         suz/4sjTkfrPPko4zFz+PEebQRR0SCYKGmiaCE7vKeCuQziRQXSMtrfb4GZ6c4MvRVs4
         j1mxrjsE0W7obxpHHF/JD2XMP7XJ5P/p/+PctS+l7nOwS/W9RpmF+zYphshTG9cbGPRv
         pfwb9nEv+DoiRCpNTiG7gMvG4AuEoNZ3Hd94RikCzHggQLDuhyOHJwVCe5EkEooG/ODH
         hxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448943; x=1763053743;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxXbjl0HhdoITaZBDxLqmLJTjrhCiLD5WEPTG0leRLU=;
        b=eN/E+A9x7vs6yPsXnywUn9H2gF02R69MCz08zobvA4SzJoYqoFSoTa+ARE4N7EYPcG
         dIfHsPLa06scmLIzOPXkFrJIGHxtumM1UZT8/7uoNDl5nhHC8SYK28443C1QMkb2NUu3
         L1ieifvSN7WYBs5Qv0+9jH5cSLnGVTfxmG7RElT91/3iXKMAONT9rQch2dlVjxeRo8/k
         8ElJexLEi69HOMcqu+1VyKP0jswrKNg9rk+qXOYbjwPqLE03aFXCFzzXvO18Oaye4qTJ
         sZ9OGuuRlsE06Z1w6Zto48I1xL94jDrFGfhkTPwSMn5BAdnUefQ5mzz4cyb96U607hT4
         /tRg==
X-Forwarded-Encrypted: i=1; AJvYcCWRZbfpH28IzjBVNK0mjRKvRUd9TLNDjdkC1zAm6Jsd7xWbr51CufemTyjrduKjC1TMbUFfe/C2xA==@kvack.org
X-Gm-Message-State: AOJu0Yw/yqAaTRPnAn30C1Z0oj/1JUvMW7Zv/OObn+Bs4OxehZqF4P84
	wqqIXgW55dDRaBw2P9lDjTqFhwDu007m3iwWdRRWUtR7ndzoKg5kOcsi
X-Gm-Gg: ASbGncvoKo0nKPHrOsztEq5k1jb+8rzT0HaoPUQEK7cbw8cnotkaMWfmfNu7hvZZJ71
	8keXRrKp6a5GGH5IO8rzAyQsMxP9VqPJhqS7p7PEOhzFHb3bP3BwT1y99OGYNJBAY5hW1Zco+ro
	ZVBW+kQSNNS0pITLYyydjLY2ORF+aL5tXvXIlOG3CX2mi1XIWML2+/GtMmmVmblyMDmLSJLyTxP
	5PUjTdaIu7Kt/V20v5d4Y8wPzFMpnl02ioR988CSh6T+Nt9qYgX2T5J9tGTrAPvM7PcAapgGpGm
	aE7xOGtQcIwHMn63GDMeLPYiuEWwTmTVhSmm3Wx8i6RRk+EK7HHJL2wdBdOff1inhDBbqpyszsl
	VXCDK7h9lRnRV3526UeVGdgwlFKaoy9mAEnOp1TvlyE483X893K7OB5JuVCOrXb0WRXnHUA==
X-Google-Smtp-Source: AGHT+IGcGbtG/gxArci+CopvKuv0vsWkSHD0Cj0H8EsVfNgzuLLOXCCQpVWCS8AAZU2IHguSNAAo3Q==
X-Received: by 2002:aa7:88c2:0:b0:7a9:f465:f25 with SMTP id d2e1a72fcca58-7b0bdb856abmr331762b3a.27.1762448942695;
        Thu, 06 Nov 2025 09:09:02 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c9c0874bsm68007b3a.16.2025.11.06.09.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:09:02 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, 
	Juergen Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, 
	xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
In-Reply-To: <87ikfn3yvs.ritesh.list@gmail.com>
Date: Thu, 06 Nov 2025 22:31:27 +0530
Message-ID: <87h5v73xjs.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-8-kevin.brodsky@arm.com> <87ms5050g0.ritesh.list@gmail.com> <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com> <87ikfn3yvs.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6tn7f1cweje8j3t14wry171zfdaqtac3
X-Rspam-User: 
X-Rspamd-Queue-Id: 141BA40005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762448943-602313
X-HE-Meta: U2FsdGVkX19vaL4JQiFJE6pH2Qr91PPVvfsxrAaXVRmGuI1A69OtHLR7fYlxlWBJAFTgvNgqByLbzWnO0aLKY4qnT+ob7aBcrjtS5seXgEduBMcfiXtdFB+n7kEw+wXebKLt2aLn1r44rj1eACzjKLJFo+lbacqokVYUltAoITsNLJmHItVYdBzvWeFRfH6cYRDpYXWupkbBNE2A8MSPm5h7bGGaJdIYyNJ57A06SpxmIedy0+2eoZeXN48IjlrmExW74FsD4NJVd4fb2jFI0u/ZTcA1Rxt5xxaiEBHpIqJaGtiV4fLbsKBrXRhyhk2g4H/YjUHJtmfVJMaok0BP4/ftQv3F4bEWRnw6Ivy/cwyaZwpdb+OMoQjN/4ftGioZ7KMfkz1fyS1F2MiiAZBe7HKetJhIoddXLtJyEykFF2K+9myBpkKHQqP/h6K2w2Q13B/xE4MgTUFqCqMoW0w43gQvg9mwtnOtlFVPyyKj2gZJ1cFJqHpgo+2RXCljbuOR/BcEwEke9FePLyko4j1neVSRLuOff7T1Nmjmocls5Py1a849hPC1VH9EbE4PMsuaOBFwW6x/WwDPE8UjjkYynh+tBBB5CdigomFtbsLOpCPrZBXjf8ZZsXBckDt4Aj4UJMTX1lA4qeco5v8Z03ZpDHTmHnHu/uWxNtKhK0RJHJkazxXvybiD6y4nMNBKAYa+TbjvMTgLV0ofg9CRNjA0/vO3uopJkUZmA7t9q0IclXJXGgoTM6MFpXDiiJfiOPuHOQUCTDtAxXq6T62CK/8KsVmxbdsFZy3RrJ8OWx0RehyqXocgkESgWInmvamTyTzPzNDf2BDG6rrfDtWzeLTaTtquArXi04NriLtqO7lWFYPMC7Fyb/1k1DqHtDDAHTi2WOTbSQKlAoSLRL1GJnhzfRlI8RqCgZKNY7YnHtllkBInA3a5jst1vSgsuzpfr13urCs66AUCUiRin+GBHqs
 XT6x1stX
 aJR5frHVuJfOuIRGJLhWIM7kvX1XoMLwB7nHGdRQ3VnRBYyFBTeew+AMy75YUDSvHX1nUXSyC+ESKXwOoxPHN08XU4hfxaziRXuyLYKLRdTXT6P8iOjLxaE29kPo/lsMizBH7cf9PSupvKu8kEhdwW6D0JQ2EOH/apuemLmURTrju6C/y0/Hk3mfpcBVhBKR7inPGn164TidTYOMHMYQpARLi8xv8+P8PaVhRByhtxhTbk6zU8/M3dQkN4OKOaQzkj12jumPGeuy3nTUp8xmmmIkpRWprfh5/44hvvz0uwKIFShFiLxhSoFrPTxlwS0WpzYpgry790jiaKsb7t1MDCV04736MfWejEtXze25WFZzMfOqCQYWP6aj5DSgS5lf+NS3BjzV8LHuIwMiFEpn0berD/5t4XNe6Oa8P6NrqYUTcgvkyJldrcb85fUhJganBC4/MC+gNvXQ5/9cY6eEHP8/GOREJP1bemxcJyrqpAJVA5mI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> For e.g... 
>   
>     arch_enter_lazy_mmu_mode()
>         hpte_need_flush()
>             get_cpu_var()   // this takes care of preempt_disable() 
>             adds vpns to per-cpu batch[i]
>             put_cpu_var()   // 
>     arch_leave_lazy_mmu_mode()
>

Sorry, here is the more accurate call sequence for previous email.

caller()... 
     arch_enter_lazy_mmu_mode()
     ptep_xxx_()
        pte_update()
             hpte_need_flush()
                get_cpu_var()   // this takes care of preempt_disable() 
                adds vpns to per-cpu batch[i]
                put_cpu_var()   // 
     arch_leave_lazy_mmu_mode()

-ritesh

