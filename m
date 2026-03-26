Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9606C10A62FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BCE6B0005; Thu, 26 Mar 2026 10:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD1C6B0089; Thu, 26 Mar 2026 10:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABE56B008A; Thu, 26 Mar 2026 10:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B972C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:31:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F4BAC3FE0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:31:36 +0000 (UTC)
X-FDA: 84588452592.11.AC44D99
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 426231C000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:31:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z0RxibhF;
	spf=pass (imf20.hostedemail.com: domain of chrisi.schrefl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=chrisi.schrefl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774535494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv2EfhMbcWOA2sU2awQXAMiSQ1dwjbJBc3BzfW+6rZQ=;
	b=nkiDXrdR+uMuV4VyjEHFof5WAfyNRZkYMld7lHUTU8SpP4X+ZnPwjkmvf4vdBCjuwOIKoC
	LhuusCaTjtgqL7oqBhB79eN88NxfFirSh16cOJqOTkr6VY9+B6zBZfwwsnU+VfmO1FXD/X
	hhXaLYw3TYFB4KrO3N15BQ3Hn65cd90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774535494; a=rsa-sha256;
	cv=none;
	b=Rc/27uG71DlXnNIdo+07nAI9VgEWfdYHblVY04oD3Jyj+kSO3bpeMd3Ch/ZgqAW6RykSea
	NDrc0WIZHCNIkgBPZ1j2WA5m+f/g3IjHuKLMFKBByd/X5uPPjFNddIzc3z0FqeUxSaSxgb
	DSGJQSoAPwahNij9hWdRWEyowHQIFjk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z0RxibhF;
	spf=pass (imf20.hostedemail.com: domain of chrisi.schrefl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=chrisi.schrefl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43a03cb1df9so949568f8f.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774535492; x=1775140292; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jv2EfhMbcWOA2sU2awQXAMiSQ1dwjbJBc3BzfW+6rZQ=;
        b=Z0RxibhFCUapK3PZQStEsHR3U3L89ctLZYST7LySxBKewvXPWXpmeOIl/XwXb3hFEB
         W7a4zAnMfi3sGgJEc2tPsm3pa8GJzaEd1atxOygDVKa5Fvg3XWu12f4L70MIWCrX2G7t
         iWWdOtMvyt2So6COQ8YO6Ot0pg2TccCnKTj4Ln4wPSJ7V4hc3lkM6Cj+H8Ujx1rSrdIO
         KWkRWzQoohkRjD4oDt+qgOqDl09QD0nzmKuJ6HpXBQh6AU9g3za5jgv/WOX2tcaun8F/
         sHRrQg0LBpC9FYgdNxoaN2qzpYeZKtXdlNjYfu1986ifUMQsc2pa03dAAPGvt6LAYdpl
         3OaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774535492; x=1775140292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jv2EfhMbcWOA2sU2awQXAMiSQ1dwjbJBc3BzfW+6rZQ=;
        b=XriMNkQ9D7H1qfic70Zakig8zR+6UfXPQifcAfxiPp4i0S8mq2212/v3/NcSVb5fT/
         urzUaNV6NYSaM3zpzMQH1joAYQrFuFsHV3e1otEKtuOPBCIwpU6kNte2vvlo5gL6Mhma
         2HHgIL0hubptO/PE5Cz2SUF1ZZQ3raOdtSEe7t4UMXij9w0SGU/2Y3Cj/KW8YeK46pfL
         Cso4iWA+g2wjDKaLQE3bW8H2GACv3+70AkjIss1rLsTRtsRopUDO6VaWj6P1YqynPTac
         xKF/hVp85qfuNpwSojeCV3IrD+EJrDVvEkN2T0vrnqc8vMNXSBRkneUuvlxmLD9XDibk
         Hx8w==
X-Forwarded-Encrypted: i=1; AJvYcCWrbsqyppHUCPj9wdRS8zaNwPYE+NQXV4bGoP2qBqoJRoWNVYRtzuvGbWJ9VeClVTllyLsC0RkqhA==@kvack.org
X-Gm-Message-State: AOJu0YxV5TPcBoihWNPYGUOdtsNTwHNJydIJ+sdaH9VHjwE/AA6PDjQ/
	qAJa5cElYZ5+5Wa+st+4Fsvx7m3nwlByyz4nT2e85OWHsOYffi3ShwOf
X-Gm-Gg: ATEYQzxJ1wOiKk16bduQXtTX9OrZscbWfrukPlc0lK1x7sXcd41rndo1mHPH16j/DZQ
	ABhUydWHHdRsvb5Gj+zvaTSiA3E0RVvyA0xzwxZOi2bB1uo3v/DFZdv1tZSVvTDGPYd+eW72avq
	duNwEFAKpXcEUZX3dYGYRsYFRVTrPUqYwWLQQX9TqJUNtGRaPDnJIt9xa++eB/95yg7DwhpOpzF
	mg7cL9I7ZMZdvkLn24Apeyo5yuB0O0MpuUA2MGT4ITnlxXxJFiDvO8CBqS+MBX4iuLcxQENL7vV
	n2B4JrQfR/QdfxzqBLuHnH02IKcXHRLM/+izHEimHToN6rYfOmMib+7vCMnApHGdMLe8qn+1MQT
	pS2usUuz2pIAycpuR+cuFCFTM58NeMtkEsmtnmhzxh7oUUZNNegn9QdwVnYA7mIbgHhDG37/IuG
	TUOMKWGYH9+3hZAHnchPqiS+MVGdEUHvsE70vM
X-Received: by 2002:a05:6000:4381:b0:43b:5672:f02 with SMTP id ffacd0b85a97d-43b88a21651mr11427910f8f.7.1774535491079;
        Thu, 26 Mar 2026 07:31:31 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:d2a7::cebd? ([2001:871:22a:d2a7::cebd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b9192e528sm8063097f8f.1.2026.03.26.07.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 07:31:29 -0700 (PDT)
Message-ID: <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
Date: Thu, 26 Mar 2026 15:31:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com,
 akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com,
 bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
 david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net,
 justinstitt@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-um@lists.infradead.org, llvm@lists.linux.dev,
 lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com,
 morbo@google.com, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
 richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
 urezki@gmail.com
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mf5317i6wtnor9hz55yci99mxyq5kgox
X-Rspamd-Queue-Id: 426231C000F
X-Rspam-User: 
X-HE-Tag: 1774535494-408342
X-HE-Meta: U2FsdGVkX18P3Apd0SDt4Yk1r8sC/mo1sK9fjAv2A0DL/V7CBEl37Z37o9AJPlVfbdRpjG+LDpp92YHOxo29vTcVU+ugAOg5CCmIqxCgN8TWXtGy77uw6quTaAzt05a42L1+YAm9AhXuJFib58bHMGF0SOPx7rPZabbmdTttQp9gY87IssaKtFemU5kXJpz0KeNiuzfppK90YNwtrIcwkFy7Re76DdXzqyy8SZNneke+crN4PcP6p7qPZZ9QrqclhEq0DmmurWW/qfxa2NgkFDXRJphEE/MWc8FAW/elsutIy+C+DTZtXHab43g5LNCrEEnSnf3pCcDQJCFrhFgmuFZmliE7MZx++MRLku3JEtAbl5KRXGcFNTNBQ+8yb/2e5Rd0u1NUVGGJwp4+3MIXA8qXU4sLbCSGScAmkGwfMgh5FlTePazwkuBv2K0l0+P32Z7TVf/0bIxY3EPUWiMbIwkREgyCnz6d1cAYhGmB0QrfCh1Hf06eRSlerBv7E43xHE4EdbCk4Qtpn68yMt4KUtbFnemS9w7XpK/vEo1oxfr8/IXLRTpWRemnXZ3nC5co5DFJLtVXNkYdkw+tpD6c3CelODDf/k9AIi/k7o/YiD4bYgRxjqMxKnIDb/QNUVJaeSFmK8IFJQ5ed4+Na+HyNCyn+0S/m1TXC2iayIXldaZlmofEV/VgAHWFfctTlZTzIodd1oc9r9TF9QpEq5/IgLTfJUjtqAQ8JStWbask6+iT8QLeXMi6mqXbhq6gcgOkxvAFrKC53hUstQMl1x1kswnPJAGnl4NxMdqFpAZUDSrW7JQmuyJBcb+X2wICEzeijpGjt3BDBvRcnIEXlfEBzC5tBhjtCMxqUcrEw11rY/Z1ipjAU+D6Wb1IpGqQqSYWyJ8J04+J/rQd4xuqsXuA82vvIrW8BRluveAo+U6gFl1puhm5o4hw2MoGll9PeaVOmZAz0NAFg59AWho1hyO
 zVYa2yT7
 BnwcEPsA8Qj2LnkCoHyni6chGYxyhqeXDcKelKvirfGIjGLJBmeBSGlCUxv7aeWq0loZGdsstO6xAaj1NtPndlD03BYP+gPktD5IGH7/feN2w9zKnM9kACwOHsl9dLGW+L9zKpRyJC1HLl1x4VqZ2WoQj/q5pAM/ggqDPJFNI/xBLCkqp9lsDvgyqBSAbir6LiBKpd4Z8bwRTrgRR5YM+ngO8eilms6r8ZTJN0PcWi+gyNxNBLBgaMug+sqsHtmx72j4OD3Tk/iJ2AsxjNTTFI0r2h2L3WV/BueBj+Bgh1wVdEke27J5Wv4y7RB0iMRN7wTQh6fxES7AP4IKKwjffMK1EtkDEfZ2fte12ZdXzL+NOyEjG7NDNx3XtRN/GFsVwG6zpLtGtKSUJ66kIM68wlIF2NYi77GieTx50Tc7iRl77sf08CXCTCFVuM0WVyt0jO+l8R5aGirXeonEOIUN1tJVER3L5Y7oAr8LJXfQEmIlvfaz4+RVdgBXGWbIpbLNbEIHDU86S9IttUt1mCZk+gujGhdwvyeOYAcus1aeFCS0W2H0qtqHZZ1GFDlS6dnoXe47RzJr7UY9oCwnxXA7a1jWwyl8idp9JV1ycV0B2K0TMjX+gFtqxvwhNMFT7lW8BIrW1js4ViJkSucIqA/Wuqp3ns401oTeeu+xwhnPKswKo4QWQJzHmfMr6UNFwgijEXNwAXETSbffyc78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Miguel,

On 3/26/26 2:47 PM, Miguel Ojeda wrote:
> On Thu, Mar 26, 2026 at 11:10 AM Alice Ryhl <aliceryhl@google.com> wrote:
>>
>> I noticed that the Makefile currently uses the arm-unknown-linux-gnueabi
>> target. It should probably not be -linux target to avoid this? Probably
>> it should just be armv7a-none-eabi, right? We gate HAVE_RUST on
>> CPU_32v7, so we should not need to consider the other variants.
> 
> I think Christian tried several targets back then and eventually
> picked that one.
> 
> Christian: what was the reason to pick the `-linux-` one? e.g. was
> there something you wanted to rely on that target spec that you
> couldn't enable or disable via `rustc` flags or similar?

It should probably be fine to use armv7a-none-eabi. I've mostly used
arm-unknown-linux-gnueabi since I though it needed to match the
bindgen-target (which is -linux-gnu for all architectures) and 
because from what I understand clang also uses arm-linux-gnueabi [1].
Also when I selected the target I thought that we would also support
armv6, but since I had no v6 hardware to test on I disabled it.
[1]: https://github.com/Rust-for-Linux/linux/blob/rust-next/scripts/Makefile.clang#L4

Cheers,
Christian

