Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BAFCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 17:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0DA6B0088; Tue, 29 Sep 2026 13:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B4F6B008A; Tue, 29 Sep 2026 13:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B036B008C; Tue, 29 Sep 2026 13:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDDB6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:13:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12BAFC055B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:13:09 +0000 (UTC)
X-FDA: 85267445298.11.BD153A1
Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1077140007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:13:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IiiM18Mx;
	spf=pass (imf23.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.210.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790701986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jK+IP+9ChRw10o6kT7g5FdTLaEIAYgAes+yeIuQ2Auo=;
	b=iWTQmrU3dCVXJRv9Kcmdko54+P6luSjisg45pZYEdp7RmGETpM6dPyFbRMJf1oVOXVa29H
	53cD6nJpLYK6oRKszxoStCYkubnj25K4EtH4SD1MSajP+KuJS59bZcNOxiv93zEbyDCI/8
	ImqdhChtiAgoCUHttXqgOhYPYk44W6E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IiiM18Mx;
	spf=pass (imf23.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.210.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790701986;
	b=E5fNafFr0LvGrBmboGKRz3O77qD1cvRb0Cj1xT3XFneCjnajbHL7tOYaedrFc1L1VzW/PP
	vfUf4jW9nh/kAutfUlVWHyO49ZJ3wilJW1Qfo2zi4Go5hzKDZLqJIx3y3doYPn76wUn7P4
	q3rZqQA2VNjeLTncNbWt4nq+flMDdrA=
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8863dbe381bso59578b3a.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790701985; x=1791306785;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jK+IP+9ChRw10o6kT7g5FdTLaEIAYgAes+yeIuQ2Auo=;
        b=SxtEwxpZuiMwnTzwKbGOPsDFKYYkE4bcY6PSrqK0xe2nvXHcF8CTqGXxAHKRxC8tHd
         p1pfupS5AesacuPqDpIaiOgxVmkmVkZJFxhQdX2layL8faaXSsIzlT92JyH8jhCAq72D
         x5pLMa8lR1UwwgT0wcl5XNoOcB1x6ymWRa167dOO9wfOl7PBXS7Ev2Jt6qBo9mvxYqMY
         T1uG6yw8mRd8hn46pC43vTKLtP2gsN/Q0/0zUHKMLmgg3nM3quvyoS7q7rMhQIGmo7ZP
         KKE78+THmki6lYf6usEgQ04mc9hW7/RLJgdl+a5axi51z6b8EuEOC0vRklIZIiwODJ+S
         +qBA==
X-Forwarded-Encrypted: i=1; AKwUvByVYcS/7WV7p/7hMz0QUabE7MxLQsANG2FoeMRon/ds5cmcgi5xhv2io5HvgUaM6ueRZ1TzJMwObg==@kvack.org
X-Gm-Message-State: AFuF++l/vIn8bGUi5vZ9m98KkHRfXwAIypJ4S2mHg8D6QYFYKp0yy7jR
	KSs+AxKRg2xjJRcHPKEVF2YUc/oGP0pJ73hqAp5KVB9QJcBKQ1BvxI7hh1Ibg9voY162CDCj29Y
	CgzuO0s5NW1mr/v5OPwSScTJ4ZlU5yNbUWEp3qiS/BzQR3QafbKq98wGJRe6brEAY2efHg6JCKw
	XCmdrPlgwP0dvByzdWTWEhHq7DwZzjVlsZBCtvfiJV6sNCAVunQbtP/8zYymMAFu46qnyxyt4BV
	5Q=
X-Gm-Gg: AYBFou3Sm+1GhiYQ9Vn4uo7mEGRbXikSYg+8WP9tIhe+1j11mzYuqgRL7T/YqPuZhOx
	UUPQrYG9DMPfr01wKPuX3hbCO1kZkGax4BKNM0lt5maWC7nbVszKyE0MELKfNT2N8AliWvPVSkf
	5eWXinmo9HRqCn2p+NKMJyR89sN+/zzbUzLYfGDe+ndgDwSwZS8OMaong1JsSySWbqvdve4u22d
	ceA2NavQurnGmSJsLd1LLN7s9vRJ99hziVMh5c13HOLFM++oWVp7ImhPMZslLsWV7KUlGdOgE9J
	Pct5RKxpmJK6wPjh/iD0yk6iKr4GmCorTRn7uRFmCeywPLTXjy+OapQMaduSMX2BZ/XgjrlSlRQ
	5gYL6hb6XpqnpCwUJ2tZkmdUZh4ZI/72RDr/3W8nsr1BSxG8FB6BomVFOpccs7kVYnmgMOU/BL4
	UO/oBLTpGS2c+0oGjsguOjd0ALwyevrA6YU00=
X-Received: by 2002:a05:6a00:4f86:b0:868:e6d3:fc18 with SMTP id d2e1a72fcca58-87e9937a0a6mr14891755b3a.15.1790701985030;
        Tue, 29 Sep 2026 10:13:05 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8868846cacfsm166736b3a.2.2026.09.29.10.13.04
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2026 10:13:05 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so8892830eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790701983; x=1791306783; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jK+IP+9ChRw10o6kT7g5FdTLaEIAYgAes+yeIuQ2Auo=;
        b=IiiM18MxhPxAp93B8tOOQ7Bq6/yvFSPqgs8S6/7RL9JuG4+Eo/vgyF1LbFhvyO695C
         KxwdaWpm1TPo43AjJEd1zGww3IW+pfKd5hOcMDyj+1lrHm697f0n86MZebLLiC6ipzPG
         /Ylm+LFWZPIyHoYwkXoiu/nIwRhTNBuRiFLhg=
X-Forwarded-Encrypted: i=1; AKwUvBwKIhcJQeWhNDJilVe/fsDn4Z4Y3BZPUrwxo08LfXOEguAFGJwXKQ5F5WR5H3VVXcjqXsSPgcO/Sg==@kvack.org
X-Received: by 2002:a05:7301:4908:b0:348:201a:6c8b with SMTP id 5a478bee46e88-348201a6ef2mr6324508eec.38.1790701982769;
        Tue, 29 Sep 2026 10:13:02 -0700 (PDT)
X-Received: by 2002:a05:7301:4908:b0:348:201a:6c8b with SMTP id
 5a478bee46e88-348201a6ef2mr6324466eec.38.1790701981900; Tue, 29 Sep 2026
 10:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
 <20260929040256.543767-3-zack.rusin@broadcom.com> <20260929075426.GQ4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260929075426.GQ4120091@noisy.programming.kicks-ass.net>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Tue, 29 Sep 2026 13:12:45 -0400
X-Gm-Features: AclHuK9CQF2HwjTfB3IkA5Iz-7VKmkeLlHNlajXqAX5pb_ttJ9z-UY2UurMeehQ
Message-ID: <CABQX2QP0+Jr6gG0nZkDggvyGWCSHMNVKPPavZTYBqH+wg7rdMg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] percpu: Bound decrypted storage for all x86
 encrypted guests
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	virtualization@lists.linux.dev, bcm-kernel-feedback-list@broadcom.com, 
	linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Long Li <longli@microsoft.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a0d16f065ca24b5f"
X-Stat-Signature: g3cz3jfpg4y6hkn1wh7u7cw9om5d9i7g
X-Rspamd-Queue-Id: A1077140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790701986-296916
X-HE-Meta: U2FsdGVkX1/wxL/1bqssM18ft89vWHD0DJchDlarKqotiFmYwD1Yb+0CHKOvINWhpOJs48Omo4N32lU2wGFX/awAI+PfGCaQDEBGondlnR6PS/AvH8ClSurZYro9H176fpVq7T5hmDoCEpR54jBrPSPvX4kyQ60/U1sXnxOay2nI7A8JC5k3757om/manZsopnBbya4g1nBKELhaMuzkQRLctir6eJ/lDomOYqPKaRvDBMBD76vIxXoxVVv+YCIzCg+PH14CxBQhfPtY20t34LXPob6joX/joTT0PUYxomJttUBWi8Gj487JEidYFfvZSFtm6aenRhgzAPnCM5K6rydr/ErKiC5re6mXXSI0qNtg3LjljNtJZjMXdplOgCU2W36Plsc0CdabzGvj6A9mIolIc4aWn1hJIEvjdBl6Owd41FmCcrECtrfZeJPI64klMAyKKZcHrSqfaO98gZcwy4I5ELfXAWXYWQgMc26xjGj77tYZWJJ2vyLStIAzBe2yi67pgNdEf2nHLzC++EYHHMQhSewkecoALbX+ml1epigqGqKAzmQbxGBV38ZjmNCbjrkjhtPMpKMnBdnbEs6gXRF5c06JiZ/Z2CXj5ar2MnOH+KqEKywD7k+H1i0XDtvS/4TCuJtek6qUhff6oDqM85I8OfoaTllbsS4LqMt1XzIlYMO4TtF03vKl0gySjzQ9ij9MRAcELWaRWP1gZhZ2HQKarPsTFzRX5xCczJyEdyxsgJNypFseBKB8RKORKeZ208GHy0QtchO9fuKpQCS6NFUb6ngtT43iuXPyVkL/yYeC7pl6iMtA5ckpNSU8rhal5OR8j/4JtwXfsAQlTFW8BGbpy6ljalH++5U6QI4hUSmE0gPp2GkR9G2Mcy406FwRdAfJgy+AmVPEztzHdJ7CYnEvDdSqJfl4Qcrnll698sV2HTWzVBdodaOTiFqbo0LZd5r7p4C8kjw9ndqXi8H
 VNVDshbS
 eXKPv/2aOZNqY82tRAfEOtOX7I8DVxU5iQowE1UQ4zwuvn4XiRt6l40zDqmRM/rs29B1dauGrlfFKWJdTBUJvVWyjPs9PBYcV/9JH0oW8W9lTy7tSz3WNFZqqFvurKAVq6AGWeMxzFN2R0aDNLWBG2/+moaQTHTS0x2qur7Et81iyYrtkPI0xKyYjkUXJBG+fGeaAL0QW6/q+IWIU4Caei+t4oZvfaFGNrqNYOLIsee1qYvZxWdySyCFyQvt13kLfwQpaUpEngILvLyJq0eTHnXro51rxhpwz9NPKAHDpyvTCT3QRzrasrAc9wjjsWuAnnCGxUkCqjZ+Tg2gGRrRQMVDkkWmZODzOKPNNpVCjlsodWTeox1iA0PlHdaQeBuZwh0ckVBWzagOV3jJO2Su+bwyRITR4ha0RzVdxk8cv4l7d16iM7ryaaG9e4qOXbvEzS0a53eJGaSuJVlv5wuhSz5Ign7CVUVFZTf69B0Mym5WmIcafzwyWdz6KHuDiAEjmeKTYyVfnb7gSO0udmsthGq7GlubPwZOo+UtduxRPdZ4zGEPFAumDoNUJycOVY2dZkOz9DbuXuwm2ovI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a0d16f065ca24b5f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 3:54=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
> On Tue, Sep 29, 2026 at 12:02:51AM -0400, Zack Rusin wrote:
> > @@ -1022,11 +1024,13 @@
> >   * Note: We use a separate section so that only this section gets
> >   * decrypted to avoid exposing more than we wish.
> >   */
> > -#ifdef CONFIG_AMD_MEM_ENCRYPT
> > +#if defined(CONFIG_X86_MEM_ENCRYPT) && defined(CONFIG_SMP)
> >  #define PERCPU_DECRYPTED_SECTION                                     \
> >       . =3D ALIGN(PAGE_SIZE);                                          =
 \
> > +     __start_percpu_decrypted =3D .;                                  =
 \
> >       *(.data..percpu..decrypted)                                     \
> > -     . =3D ALIGN(PAGE_SIZE);
> > +     . =3D ALIGN(PAGE_SIZE);                                          =
 \
> > +     __end_percpu_decrypted =3D .;
> >  #else
> >  #define PERCPU_DECRYPTED_SECTION
> >  #endif
>
> So you're page aligning something that will get different protection and
> will thus shatter large pages?
>
> That is somewhat uncool. We like large pages, large pages are good.

I'm a huge large pages fan too. I have a poster in my office and
everything... And I never do things that are uncool. I have a wwcdd
(what would cool dude do) bracelet and I look at it every time I make
a decision, which given that I'm old gets on my wife's nerves a lot.
That is to say I'm handsome and innocent.

The alignment isn't new. It has been there since ac26963a1175
("percpu: Introduce DEFINE_PER_CPU_DECRYPTED") under AMD_MEM_ENCRYPT,
which common distro kernels enable. This patch extends it to TDX-only
builds and adds the boundary symbols. On bare metal and in ordinary
guests nothing changes protection, so no large pages are split.

In confidential guests, yes, converting each CPU's page splits the
direct map around it. The alignment doesn't cause that: a large
mapping can't be part private and part shared, so a converted page
can't stay inside one. The alignment only keeps unrelated per-CPU data
out of the shared page. Because that page sits in every CPU's per-CPU
unit, each 2M mapping that holds one of them becomes 4K mappings,
including the ordinary per-CPU data around it. In the layouts we've
tested that's most of the first per-CPU chunk.

SMP KVM SEV guests already pay this today. sev_map_percpu_data()
converts the same pages for every possible CPU, at the same
granularity. What v2 adds is TDX guests and guests on other
hypervisors.

Where you're right is that v2 converts in every encrypted guest apart
from Hyper-V vTOM, even when nothing uses the pages. VMware only needs
them when the steal clock is enabled.

If this is a deal breaker for you for v3 I could convert only when the
hypervisor's platform setup says it will use them: VMware when the
steal clock is available, KVM when async page faults, steal time or PV
EOI are enabled. That decision would be made before the conversion
(for KVM that means making it in kvm_init_platform() instead of
kvm_guest_init()), so there's still no readiness state, and other
confidential guests don't lose large pages to this.

If you'd also like to keep large pages while the steal clock is in
use, the alternative is to move these buffers out of the per-CPU area
into one tightly packed allocation. That concentrates the splits in
that one allocation, so the rest of the per-CPU area keeps its large
pages. Kiryl preferred the per-CPU section when we discussed v1, so
I'd like to hear from both of you before going that way. fwiw, I'd
vastly prefer to first fix the steal-time bug for VMware before trying
to do this though (whether it's with this series or a smaller
VMware-only fix). x86 kernel team is notoriously opinionated, which
isn't a bad thing, but it means that a rewrite of core x86 bits like
that will take a long time and it's starting to feel a little like I
stepped into something and you're all behind blast doors yelling "cut
all the wires you coward!!!" and I'm just confused going "I just came
here to get some blueberries".

z

--000000000000a0d16f065ca24b5f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
6U6qgI8F5eiKsQyE0HgYrQJx/sDs9LLVZlaNiA3U8M8CgEnb8VhuH3BN/yXphhEQdJXb1TyaJA60
SmHcZdEQZbl4EjwUcs3UIowmI/Mhi7ADQB7VNsO/BaOVBEQk53xH+4djY/cg7jvqTTeliY05j2Yx
uwwXcDC4mWjGzxAT5DVqC8fKQvon1uc2heorHb555+sLdwYxAgMBAAGjggHYMIIB1DAOBgNVHQ8B
Af8EBAMCBaAwgZMGCCsGAQUFBwEBBIGGMIGDMEYGCCsGAQUFBzAChjpodHRwOi8vc2VjdXJlLmds
b2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3I2c21pbWVjYTIwMjMuY3J0MDkGCCsGAQUFBzABhi1o
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMwZQYDVR0gBF4wXDAJ
BgdngQwBBQMBMAsGCSsGAQQBoDIBKDBCBgorBgEEAaAyCgMCMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwQQYDVR0fBDowODA2
oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMuY3JsMCIG
A1UdEQQbMBmBF3phY2sucnVzaW5AYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8G
A1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBQNDn2m/OLuDx9YjEqPLCDB
s/VKNTANBgkqhkiG9w0BAQsFAAOCAgEAF463syOLTQkWZmEyyR60W1sM3J1cbnMRrBFUBt3S2NTY
SJ2NAvkTAxbPoOhK6IQdaTyrWi8xdg2tftr5FC1bOSUdxudY6dipq2txe7mEoUE6VlpJid/56Mo4
QJRb6YiykQeIfoJiYMKsyuXWsTB1rhQxlxfnaFxi8Xy3+xKAeX68DcsHG3ZU0h1beBURA44tXcz6
fFDNPQ2k6rWDFz+XNN2YOPqfse2wEm3DXpqNT79ycU7Uva7e51b8XdbmJ6XVzUFmWzhjXy5hvV8z
iF+DvP+KT1/bjO6aNL2/3PWiy1u6xjnWvobHuAYVrXxQ5wzk8aPOnED9Q8pt2nqk/UIzw2f67Cn9
3CxrVqXUKm93J+rupyKVTGgKO9T1ODVPo665aIbM72RxSI9Wsofatm2fo8DWOkrfs29pYfy6eECl
91qfFMl+IzIVfDgIrEX6gSngJ2ZLaG6L+/iNrUxHxxsaUmyDwBbTfjYwr10H6NKES3JaxVRslnpF
06HTTciJNx2wowbYF1c+BFY4r/19LHygijIVa+hZEgNuMrVLyAamaAKZ1AWxTdv8Q/eeNN3Myq61
b1ykTSPCXjBq/03CMF/wT1wly16jYjLDXZ6II/HYyJt34QeqnBENU9zXTc9RopqcuHD2g+ROT7lI
VLi5ffzC8rVliltTltbYPc7F0lAvGKAxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBD
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIM95
Y+wYvsgw8fhQBqM5K0hnr0Cphy3qyWfbqheI4Lz8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI2MDkyOTE3MTMwM1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFvC9yUf4NxqdbxrJRcyAp/5mQzhsOLZROjyygFB
yBZ8VcJ9B6XVEIMx3ZhJzgeW/nkTMkE2njNsu0m3mo82ePcyXk1iXQ/Gi9jtgJQkGDPoDvnTYACV
/exkyT1vYEnTQ9UwNxR0tih5JE8C8VS8OZrjIaL2gqiGuewJGFZZNha6AcjbJyVMvn0a9EGg5aUw
VESPqWMG8KRf2gkLgDsHKgdUY0FrlFjzp/HhZ0BEkJdTGXaIu2Yfcf9ti2cBvfhvF820CEUE64xG
kDNvoHKMDbCrGc+XZxH2F4e11DN9nq1ssLS7C+QzPQC0qSjaMKYb7leVCvjULe138pNDm0J+Auo=
--000000000000a0d16f065ca24b5f--

