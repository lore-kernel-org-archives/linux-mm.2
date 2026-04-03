Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C51AE85367
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E256B0005; Fri,  3 Apr 2026 10:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DECF6B0089; Fri,  3 Apr 2026 10:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5E46B008A; Fri,  3 Apr 2026 10:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4297F6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:50:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76051C27D0
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:50:21 +0000 (UTC)
X-FDA: 84617530242.19.CA44E63
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CF1A1C0012
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:50:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sOCWyImO;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775227819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nO332cdhj8pkWKcB2XgZGKk4lKtIFb9kXIiefVqdlI=;
	b=BN6t2FvvxKDsB2akpg2O//pockZoI/+nAS2TZ2tgyDxo2whgrXCfqUSf4og4/L837VKiZm
	u5sRSmKAxnbL/gy7OIw3GwDFEZnT1TuG15VKP9Q7A26kzXpbantk9V3bBp4pXQGaF85iRW
	yMcz5EOuOs7Q8quwrad9vzy0DJYGplI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sOCWyImO;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775227819; a=rsa-sha256;
	cv=pass;
	b=NHnipjmpPKd+aeJU9i+kFZxESa06s9KlkDs647qA/uuL55rppS/MF6gkMfrKOW2IrQYqOo
	uVVfzw3dOwFRpgkwoQ1sXIWR/4alt2Dp9RZZHkmOrkAFRct5iChJj9KOcn8ETNWkqkz67m
	GwvcmAdJon4oiVw95kisqltKbV3GN4U=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-953a44f8404so570194241.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 07:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775227818; cv=none;
        d=google.com; s=arc-20240605;
        b=i1iRR5kRak3rBaAWDtngkipTL7BxSbwkaGf+6pYAViacdaBZyzEUbuFkb7Kg5NI9Pn
         OtVpvo3e186tEeXpl0Ra7D5y/D+jDLcUe+pwpET7NHu/3IuZ4AxHxy+0fnQRvoJc8aC3
         8LR5vHnrMJS57bIyIWgyPG9Qrl853bHf5ccz5RLoZLlTz4AoH2I/WPYqao66eVuERFJI
         bbqKI8t7IMwOpfsDylyX32Gvn/Z7SWdc1XF1Q6QpM7XGTjGxfjMjBJC6KJf35DtLW5RN
         AbCuO6Z4mCpwRMHtfyDoicFMzK06tH6BVdI3hIqyNyt1N4dMdt2RYmHXprA3SjPncI5G
         UD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=2nO332cdhj8pkWKcB2XgZGKk4lKtIFb9kXIiefVqdlI=;
        fh=43WQnFOcGf624DEfJ82pqnhyXg+dzwIBA9RSOa8oe7k=;
        b=hm1qALr0agI++XxT2bpVcyBdJm6MrVGkJvZqJ/uItVn489uIV1uE6KuVRBpg94CTBZ
         t20RXkUITtlYvlFJamjqcsk5F4kC/2imASU9oegD7MMt0n/EOBSS9t1E1sFOd5HABxxD
         YdxUe3heJbKrdWHLfm6AUPZrkTMHcNRIAtdtElfM61bmcqdeAYWJ2kMBzyZ7kljVttTk
         zfnMWrgJEurRFL2lyge4TKwf90gg2L0HWtJLIxWdJ0M7RRU9+vYC94Ib2F5g9osuI8Pi
         QnCQYbdvnlvPTNYaIkcUbn2AyBZQbGEH5NgE8OUhYmJCV5RYU2KL/aVi3Cvv1Tskwc5p
         pONw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775227818; x=1775832618; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2nO332cdhj8pkWKcB2XgZGKk4lKtIFb9kXIiefVqdlI=;
        b=sOCWyImOjMxP8N44VDfFL3Fx8lB9Ho/nEt87rCYb2Hz79PhnqJho70O+3aZ9GHt4o7
         28q+ys9+EXXInUdd4UYMzqOcrlKEoZ5Z9WlN5pfFqTo3YPj2BABghck42MyVZuO0lyXh
         MH1CK/dMofbpxaLK07QxTHDEoBVuZQETFn5rP/bh7Qu/I+qEQ4tYiOLOdTXkzBdBIEXP
         bdnuoypwSM7Mi+TasVDGV3jrsR6IcB9+E5UxZ1muc3UVTOLQL0Cuo4zSUOeY9WZJAYXo
         Q626dof8xzCLEJVKjxLOSLKS1aAaSBw6FIPXBQbVFxWwEBRIgkDSAgLLl94tOWA5mNUp
         8HyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775227818; x=1775832618;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2nO332cdhj8pkWKcB2XgZGKk4lKtIFb9kXIiefVqdlI=;
        b=BSdBR/7veJPZPHinFBB5RJ5aLps7xmdZpG5V8eIfDKNwGck+BJ9gORU2B5iGW0WAb5
         ZxRSUJ9kBhg0cbDzlmdmjqxMLvuLiDfw5kQ86gMUtjWIfXGZDcq/U1HLARavZmQodkHh
         dqRdMrNqOd02iwSVMP13aRAnDlJXDZbo1mJuqMQ24e3SgnQaBPsgOWTxtA1cCbc9fdIe
         28hgQue50kPF7qoDriWQPGvuioa7r+SKmnoo08XzjgCdYiu+PTJPcLweyc3RCVCWy+gp
         DbsBuhkPwq8BZhz0bQUpvGgxq4tgP9Hpo7sPJdBx1O2/dQEPbisWSSgEfempXRx3GRYL
         vWzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB0FIjarQLWWSDaUGBwzwA6Ui3sdc6htogJ9UBGrKRcV6FvVoSkaH6oXkgt9SJZVXDdItiMjLq3Q==@kvack.org
X-Gm-Message-State: AOJu0YwatYMIxvfDoV4hexoBHLrLbg+7k/z0I4SwobyByQznK2GSf8WJ
	7fiNGfyAbDgUO8+22yFmA54rNZPJHZxwsMhEGUxE+QtkKVF7C9PHRjB3GtD4C3RYGdxU6Zv4gmK
	UPt3yi8QkqWRr0vqbh1SSeTEqNANJOHWLl4oeLCbo
X-Gm-Gg: AeBDietARfKG4cObMGOU3R/Ogf1q1C7BYPtyfHN1lGXJIXRNhAGeP2t42aY60UuzoO6
	UR+F35c8Uxo+G/CmXEwzONDZjfSkl78VZoDjcVooju8C+RfzIFHq+6BN5Zdzh8LnQV66mvT4bZM
	ycow70aToSwRWBTIIC9haTsMEt5tG9afbUA74avIc/1M9JIGbPNA24JgoZ/5hZPmwgB3WpKt4iF
	vR1PFceNg+J+Snlns/tyKfbhLA18btIzKluGAS/iGzbGGLB64JK9NGz+L6i61yLE8FxWWwcPEmT
	cRxdHU2jVKbnB4KO3OfR49rTKTnvASlIhsbniQ==
X-Received: by 2002:a05:6102:5a92:b0:605:8280:5e68 with SMTP id
 ada2fe7eead31-605a50e2a2bmr1113935137.16.1775227817848; Fri, 03 Apr 2026
 07:50:17 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Apr 2026 07:50:17 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Apr 2026 07:50:16 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com> <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 3 Apr 2026 07:50:16 -0700
X-Gm-Features: AQROBzCC-hVilK2nAfJ3eE8zmQqqNa0fWthx2SZG4jgOFPeFQ_7rmzXurA8c2f4
Message-ID: <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: xj55u858nonzfwpz7t3ubgr6c6j1cyi4
X-Rspamd-Queue-Id: 6CF1A1C0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1775227819-889232
X-HE-Meta: U2FsdGVkX18JgKzTWtvqEbRL14D787Eo63ucJMevGza00SBJyIQyrc9fVgI15/6clovmT0+y1jRf8dWU9VE1C+UokpJa7jX83J62UJ/mhBcFJ+MkbpWYHivSJO3/3PVK132b1ON9F+H4AHexk7+VFIzwBDqDBiMbmea8IDRTewwldCJE50oAJHOUM+Jw1313x/LoCA0JiD0W8ePJT9XYNfMnGvtMQ9j0+CtfdCAbv74nNgZK1II0uMJvw1oVfUt18IozGRDCEFfFyKh4/CNoIuHnAlJLrEzneRXsRZqyH8xWRptLPu53XIkyOgrg2pJSiORlFC1ECJPMeMmwx7kQ6XUsWFSIvtRGOUsdrBVL+knghK+a71DqS4T9G7Iw2Qg+9Q0hCHHXY793csvJvlr0kTU43kcDsecDqzHcHUQU7rcWQeqpi/2lUon4vA541XFMqj4mD7yNy2PkIF7/yODZYba4pEAyQXe0K4kV7xjaPk9L0XLv+Xqc1h0P1GTe27TxHP+KQGEwibnuc+kk+tlmJONtJUqs+NVxsixcui8xzW+RdSkNLtzg/Y1A8bJY6Rbne3SeyCmREbPQdHenEpuA/Cl1Q1j64whlClCIfyNeIgNu52y+RW1DOR7Nzaa+mxqy43H+XAxMyOvu8R4qVbnaKWVh3k2U5Sw4mNQPVvd2IMfxji9B1NKXrhSE07EgTocwbFZeU+/yXADTl2n7YsDjI1gup9EljtsvN4Bpn3Hop26ma3PBxf3hvnGSeST4Wpt0tiFGlD5ginyzp/ThEAZHpb/k7sRsKTIi0g8tJ9rlnDsjkbNyqrsp2Ag++Ceq9RorOEdEPBT7/gHhJMLMCo2ZYGFnx82iU/StCYceOYfl8dyqfu8ncpf0Sx4R76ZU3wCtvA02XOcT03xHLHlrr35qWWiH0yYUcVEt87zYPpiYwinDDh5nzKacTYQc7Qd6H0e/M2mADSAoiFa0GvPjeYo
 n6zgZ2uJ
 JtXc/tovmPzw7xyEA3S14n/+UjY9dnX9zGqq51JoWm9EFNwCULrHo7E1fjgxNfz3pdhw+iU8XOF3aw6a00Ss8SbQrYjYlE6Y227G9g1CtICHNWoiseOq/GEmmBAz8ihACa+8f1hWSTXOB80XoxGx6NLPDaJeDhDXSrp9V7J2WDykgbELzpFxOJy2UZqBJr1MNT8ADSmG6WuFLQY1cjUe9YTk5ed+uB950bYKw9U2/RmeJO/Zs7bWdCA7BTmMyxcB+h4HKO/Ti6f/8lyyyowr/Mde2s/2E0zg7+ls2NqNLCEBiZvyaQgOFXgVWY3L8F8PC0iWhsp7nMFgA1Cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
> guest_memfd's populate will first check that the memory is shared, then
> also set the memory to private after the populate.
>
> [...snip...]
>
Looking at this again, the above basically means that the entire
conversion process needs to be performed within populate.

In addition to setting the attributes in guest_memfd as private, for
consistency, populate will also have to do all the associated
operations, especially unmapping from the host, checking refcounts,
and the list of work in conversion will only increase in future with
direct map removal/restoration and huge page merging.

The complexity of conversion also means possible errors (EAGAIN for
elevated refcounts and ENOMEM when we're out of memory), and error
information like the offset where the elevated refcount was.

It doesn't look like there's room for this information to be plumbed out
through the platform-specific ioctls, and even if we make space, it
seems odd to have conversion-related error information returned through
the platform-specific call.


I agree with the goal of not having KVM touch private memory contents as
tracked by guest_memfd, so I'd like to propose that we distinguish:

1. private as tracked by KVM (guest_memfd/vm_memory_attributes)
2. private as tracked by trusted entity


Currently, in TDX's populate flow, KVM doesn't do any copying, it only
instructs TDX to do the copying.

"TDH.MEM.PAGE.ADD Operands Information Definition" in the TDX module
ABI spec says the source is accessed as shared, the destination is
accessed as private, and in the case that source and destination are
the same, the "In-Place Add" section says the source will be converted
to private.

In SNP's populate flow, SNP-specific code in KVM does the copying from
shared memory into the destination, then makes the destination address
private in the RMP table before telling the firmware to do the
in-place encryption.


I think we should think of the populate ioctls as being
platform-specific ioctls that, when called, accept

+ destination address: private (as tracked by guest_memfd)
+ source address: shared (as tracked by guest_memfd) or NULL

KVM doesn't touch private memory contents, even in this case, because
it's really a platform-specific ioctl that handles loading, and the
platform does expect the destination is private for both TDX and SNP
at the firmware boundary.

Since SNP (platform-specific) only allows in-place launch update, and
KVM had to provide an interface that allows a different source address
for support before in-place conversion, then SNP has to continue
supporting the to-be-deprecated path by doing the copying within
platform-specific code.

For consistency, guest_memfd can continue to check that it tracks the
destination address as private, and sev_gmem_populate will then hide
the copying code away just to support the legacy case.


The flow before in-place conversion is

1. Load memory (shared or non-guest_memfd memory)
2. KVM_SEV_SNP_LAUNCH_UPDATE or KVM_TDX_INIT_MEM_REGION (destination:
   gfn for separate private memory, source: shared memory)

The proposed flow for in-place conversion is

1. INIT_SHARED or convert to shared
2. Load memory while it is shared
3. Convert to private (PRESERVE, or new flag?)
4. KVM_SEV_SNP_LAUNCH_UPDATE or KVM_TDX_INIT_MEM_REGION (destination:
   gfn for converted private memory, source: NULL)


TLDR:

+ Think of populate ioctls not as KVM touching memory, but platform
  handling population.
+ KVM code (kvm_gmem_populate) still doesn't touch memory contents
+ post_populate is platform-specific code that handles loading into
  private destination memory just to support legacy non-in-place
  conversion.
+ Don't complicate populate ioctls by doing conversion just to support
  legacy use-cases where platform-specific code has to do copying on
  the host.

>>>
>>> [...snip...]
>>>

