Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C54CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56696B04B7; Mon,  1 Jun 2026 16:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C074C6B04B9; Mon,  1 Jun 2026 16:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0166B04BA; Mon,  1 Jun 2026 16:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97EDD6B04B7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:10:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62DAA162913
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:10:03 +0000 (UTC)
X-FDA: 84832435086.27.DE15F83
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id F409E4000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:10:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDXJ86FB/Xnvqi9RF8rrZVf1GrIi8kltJ1EOvKoDwfg=;
	b=PKDc/PpZNPd1npzLmY6oJcVp4WN58326G0EWjKZeId+FxUqpstpkjzu9PH2kQjyGz928zl
	dqElBYhnJaLqZ8tLKmYgJV25mltja8i0Smk2lWfNaVMpJ1DdFi52nU+E6y01c8CuWnJ8L0
	PIBtNmIyml7Z/XVzFcPQPuudg49gkwA=
ARC-Authentication-Results: i=3;
	imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780344601;
	b=0joHvehdetp/T6RScW9AiqrL8jvb6yDtlZX8FTqqsU5yUCe+T1aTd8xQBk8PJnYcld5wSE
	1uFy6NXuOR/cnR7aOEbXSaNREd/QTPVM0qHoaukkNjYDUkI+XMfv5KWuGHYpskW7wqoYNX
	oXhfGTAeYpELDwNFuedvePqj5nGT+PA=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 870AC9187B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:10:00 +0000 (UTC)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 589C54020A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:10:00 +0000 (UTC)
X-FDA: 84832434960.18.F6674EF
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52FC0120011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:09:58 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDXJ86FB/Xnvqi9RF8rrZVf1GrIi8kltJ1EOvKoDwfg=;
	b=xaxlZa43b/E5mv6ZwAwowsn7iL06nfg/C0woC8F/+F7CAdGEnCkafYCwaQR01EVf4aT6q/
	T/vhAkLYeRmyMh9UOv5aOerpTpv/QVm+nviTjIvH76PxHWbjt3e5EPA0VG2EVnyptj83jd
	ZIzzBUWtNtEIlAaaQZwdDYNf5j8KYoQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780344598;
	b=TE8fUt2VkSZRnK3puILJoFWrcMV8aRYoMmmkirBcJaBCg4RpwfQ2RbuSTVZne1g99LRWvj
	lQDR5Z0pNBxT9v8OHm22q1sAyhcy82SyPsLpfaA3mVHUrA9T4+ixq1fhBsTC0GQYn6aozb
	iOfXFMwFFgVMdwXXNOvbS8igrsfN4lY=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6D0A140780
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:09:57 +0000 (UTC)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B22C990A3A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:09:57 +0000 (UTC)
X-FDA: 84832434834.28.E52D50C
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id D43F280013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:09:55 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDXJ86FB/Xnvqi9RF8rrZVf1GrIi8kltJ1EOvKoDwfg=;
	b=nRPgSRmykywytZ21hfXPeOtr2Avx/VQUczVlsUsOiyWaLULLStJ9UBjdWPEx7Q/oHRNDr3
	XlMqVKRBAaA+RbMyYDi4QnqzRKhb3n49cLmgw78JeCGJJ41s8CXbjIIV6wljEIALAV+Hnz
	KtPP8sDHy0393iDdan/PQ1C6ISuuk54=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=HJp+sRV7;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf02.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780344596;
	b=16/ALXVBXsrS6yVxtq8kv/sijw6o9DNijRVQ8DZKE9NxEcvrOpAlPVBaR3oIXjUIouF/mS
	zJE8c6FoA3UhEy9wUbhLNtwiSL/bMng2zCwaNrKSTwm1pmBFUxZcwJTSMfhk+nAUVPgnij
	7vYEFuP2ZcjuAbKJw3zXka3MeYHfMSc=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 7E93A20B7166; Mon,  1 Jun 2026 13:09:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E93A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780344581;
	bh=eDXJ86FB/Xnvqi9RF8rrZVf1GrIi8kltJ1EOvKoDwfg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=HJp+sRV7Z+MPOGir5B+cVGDJgSKPlmbFixBaKBsui3oAaZjlZBs+SpoXYgUhogRkt
	 2V69j+/mhNBX90+hxId+3srtlmItfZ4xvOVH6zQix9CSW4B3cF4dMKO1vETTdCKdTk
	 t0hko/RYjtgxX/S0C1zWqVZwqNlBNpYmi1ctKyps=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id 7B665307029C;
	Mon,  1 Jun 2026 13:09:41 -0700 (PDT)
Date: Mon, 1 Jun 2026 13:09:41 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Mike Rapoport <rppt@kernel.org>
cc: linux-hyperv@vger.kernel.org, linux-mm@kvack.org, 
    kexec@lists.infradead.org, "K. Y. Srinivasan" <kys@microsoft.com>, 
    Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
    Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
    Jason Miu <jasonmiu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
    Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
    Justinien Bouron <jbouron@amazon.com>, 
    Sourabh Jain <sourabhjain@linux.ibm.com>, Pingfan Liu <piliu@redhat.com>, 
    "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
    Mario Limonciello <mario.limonciello@amd.com>, 
    linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
    linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
In-Reply-To: <ahxrc4pTvVU20RTX@kernel.org>
Message-ID: <f9d95fb1-ef3-d4a-19e4-afe7cdde5d1f@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com> <ahxrc4pTvVU20RTX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-HE-Meta: U2FsdGVkX1/ITT1IyE3AtojfrzDvVHGlKXQb1MJA+mtwAjphOd6OyNlUP12yhwTadj8mcsfBjsoZ8OK716FABXqyd/G93RRHv3yPw8qyh0glr1IP3/XEJcWHG+F2c84Xgksc0bBog5bDW4QXbPF+10DAiAWZftV1PFkS1Bytf/FmvvdI+t8g8/Yg9dfeVpYXagmCDGMB9oiOCKxzxQjpnJ9o1LUCDsNBR6jJ+J/HrZiG/a9yDbpP5bOKICMD1T3ZSllJjR9NOf22ZYmuwDyUwLHhL1nhvwjE0RHwAG72hDU1JxzSRQ27zOShjejm1r4UxezeKyvBHZP/kJlibJ9MBffHkyZVPvxPpRzJL78HDp6EMHXO+3edzNepmARuQbtpxhI9trJVbzfrLiWcrznDcuck9bKqkZ5+/vPqGERg0nlWsilCXNNS43xAmW05I7PnGNAA/MgeuhASUFK0YYmizERWzu26Fy3K68YlW0LuSx9wDGGvx7y+ufllROdgOVFuxp6hhHL6og28l0w0TFQ0OzXD1GE6ZSjtNkX7XAOMs7NgTj/BP0pEHBhsGaX5wBbO2NRt1D+jb2P9qI6ncueBdVXssUUbXW0JSL1BfOHwYN82vEzobYHY6toKrmBbhtJjjt/2Y9gYIf7idGcjyNmmk9jQckQUDd1sUQZCmS7e64EKFerYgfx7KbNWa+8oZE83AGcc10SHhrb7SVI0bU9bAfhpe0bx6ZXaazDTxnjTUHAa15HjTP7aWcLCPgbFplNzZGAqLjYMJB3D7Mf4pndjlhXakQ4/XGVY3D2vGwbKA53+giZvTDYZAat1DSmZf0AVSGhkHLbZkYGs9dv3/YREBHRfqnhlKyC8RRhUvUHsvhTAjr9LuKHmPSnsk7c0eaF9Rta/CMJSnnzmOdDA3K7yPAlIgg3bRIqAIu00GFhaE6gM3BT+PfQ7qCaKIZ3+k2FLgrzKCUVJqcftsygvwrY
 XYMEvxo4
 OZAIsmf5KGF49aG6+uZgoy/ed1nXEs8u+SaBHjhOsFIl7L8NFTb8+PEAWNjALayR1s+l2nWM7AeSCFKtCy3l2DGRccLodqKYbxJJv4rW4ScYHpgqLp7muFSNImlWQU2+JynilMMmIScQW1Gj5pVYYgG9ySFudQRiTTeymBlz+nIdzXhydKVaJCIzN1WYUkwH9RUn6vKzbsvVJjQ1QyrThMSIZJMtYRO+5hYSmF+KuT2TjaFRXqEcH2VCNfgIjzgeql9Wp8fVc9NUnmueY/xQej+81sGGv76ILLjRa
X-HE-Tag-Orig: 1780344595-144884
X-HE-Meta: U2FsdGVkX19NAia/q0O5WjqulNVNDeAkZdfNeVHrCuSvTJmBbi9evrPFmyTxBhhbCNSTp7qpgYP5mZz9lz5XFFEdv64Pv5X85LeMswvNtIC2Ho1LFA67kzMSJeOrLPyVZYqgcCYNdJfV4s9YvF2SLJ+6PZ1wAQEsVtpKEtZM9vSOGSaMV68tvOSdqhA7h9+WbRLyUncib+O8Y7bw0F/al5V20Kqfr1x2P2YUJpyUSCNq/RhQSg1BHysvqmsUTtHLzws5PjoeRa/gYV7e4zSug53hUTBDbULbzA0iLkSj3xWD/TT+1015h2KSRRKn7Ne9VCjl+LGwOi9z71IP8ko8ihTRk0jpUQi2r+LcvZnQ/z+XYl32b15CMUvAZQKdzZRuVdQM5HZ/Ux7SdaN8kVjMQy+Ehr1XCnl9mWNRh5FMXQHyYWcAFlpEOAt6jH5k39sU5fw2s26pJTDX2x70mZuQJ//Kl0ucVmGpHs7T19JGD9TNAtnCr09uc69g8sBSANGj6mfDdaAObDUA8EwyY5qHn1qD3ERrX32O9vtuaZwL6PsOteamq5Xfu8YVzRd3Iy4/cFZ1kHgnZW/h+xelKAY1t9CcX3RGKJLcOV94+k+fCoDjxGgJb72lNSEBvHfaglDlPjYLFG1CcYT64vgEp2RT9+NLz5RAT4aMRLJ6BWn5ygIoyrZ0TlZ9yRaEYshAlgCeLv70/tul3eLDFH4/qJTw975tK7adhozdC7lZ8EImHi76QDEZvxaX9BhBVqjrtcPsu4D33eImtZ/3R4ejAjU5vTlFDWx+1AZhFZFc/J/SqdNZwInhx18fBPP8exvoPuJNb3PZWrHmZ5d6Yr8emZz1XkqfDay7Igzb8aGfKIAkgDvuWVYVWXCBAVz+XLCA2ycLNx7uxDE5ruy2y8mTDyDW/Tz33aULfCjm7o3do23x+MorpEQnb0jxXh0R+NaUNuxrP4bdCbSpKD6aiKSE8h9
 wcAWj0ki
 /ELm7VP8AkCtOCAV2Aa4VTUh3SlIbDnEt/gIoxeU/kHFXa6Lldx8lc3MvF7RPBgAKg+GPY2xe4H1thQ/KYrE2NpV79gIsgTaL4S0YSXshFvG+kNDJMDl+IViToACMVhTm1msTN1NlkF8IT4z+g/VeEahUL1Am81XbrRyfcBZbee8iBXmVZBW4mbdTl6vC/uzeFx1CgOOHFXwc5gfov0vM/FApPsBA22WYKrTEwAuDQgZgtW4=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F409E4000D
X-Stat-Signature: 8riz4cymxixnju15pqqwfw7i191bfdor
X-HE-Tag-Orig: 1780344598-104909
X-Rspam-User: 
X-HE-Tag: 1780344600-827442
X-HE-Meta: U2FsdGVkX18xaLAUDANupskMgiy9Oz9+EWwuaLxk6RLhV2lT0YItrK5J9VAfIY7Y6USW1YCfccZYPjrLyZYQpT27Lefp9q53k1ABBB8TPyhlKAFDtJhSSBy/RWygjSXW3tYTfZ6k77JpdbSOamQNATQEOdvSavCuX5DwcTkMGys2oAT5Sk+jJAi0g30BjOitEbpkM5OvDIE3sy6VWAT4UFh3XBjR0Z/wB6YXFkSK1XKxZtTFb2CBVwPt1iQHk/EEd+iNmC2k0F4kW7iGFtz7fPQ/d5J07FO86vKB9xxIB46OsiEjlC8jxjssbJsWAMF0U2PJZvFLR/kpuo3UiQP09YkGhC7QUBjCV8xAj+NwcBrcSk/5wnfwQEyKPwnpL9l35mM1ojajG7A69rF8SMqYf1RUHt1hIXKlHbYygax7RfkiuZR8MXID9tuCqtLs+XvHd0OaJ3NlIsEH4wJAAfyeZIRz2Ko2bRiWtQ2XX8vNQGPqFblENn3SB4UUTOUJ0Ba4aB2D2Jxw2WVRG15GdqBesTohrNsZxXl8V+JpZP5AustnD1Bh2q9rc4zFSxkLiyPO9kkrU+DH/40maL6G4yWkW4l+++AlFLh2Qr10GjB6Fz5+asrSUxh8bRJq7G3sfRr4ebB6cLmR7PaQr1HdxN6BhzDbHasRrQxGDPCemdvM0Yi50huE5zNpH7jLo3PLEscH+rmg3Vt5bP/lu98CKM3dMGsDg4WgnxyuX62ng04eVsQvjwkvEkIMM2CPPcTmjSW0SvQDbQwvWXGD+u/z1N8q/WQ+fVmFT8zyaFSYzsw6uwCB8i1mFAJ5I9f4ztt10K3HPHR8pndyISJdjIu7I6AykAStqX9E33C0kPCb2UIeVhyTcFawiruWrzTOUecBJ8X0gYrWdaiJWifg0O9PFjdAEmFdthqotsRcd9oU68DSsFJJIaFPx1wwE68oW99oBzTC7Rz0zzRh+oZyaC0RiDH
 7CamZVv6
 nmlUPXTlscjaPcp14a/Dwl95c5nJ30jcCZ0GTKuH+Ufmf+d4S1/3aZzajksiocgOKAKB93Jp20+Kbz4hMgdqqjVWXm7o6L+8puKKEXzr1l0UJw7IMN5SAe/mL6HbKMhoIP8AmdVEeXHxZgjbZSY76BsJnv3WZ7AmRzwzaqO2FtMe4n/Hkzf+RKXPaG1WrLuQNDNd+hHwnq3vsogGkThv6n0jC52wapR4JcIubQsxR8Tb2+Zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sun, 31 May 2026, Mike Rapoport wrote:

> Hi Jork,

>>  - A freeze mechanism to lock the tree before serializing for kexec
>>    (patch 13).
>
> There were a lot of effort to make KHO stateless and drop the requirement
> for finalization/freeze.
>
> Why is this necessary to add a freeze mechanism to kho_radix_tree?
> If it's a hard requirement of mshv maybe the freeze part should be handled
> there?

Good feedback. It's a safety-net so we do not accidentally donate pages 
without being able to track them. Thought it might be a good generic 
feature. Let me keep it in the MSHV driver.

>> Patch 13:      Radix tree freeze and del_key() error reporting
>
> del_key() error reporting sounds like something we'd want to avoid.
> del_key() is called on "freeing" path and during error handling, it would
> be hard if at all possible to deal with errors from del_key().

I hear you. Stating "yeah, it can only really fail if the key isn't there, 
or it's frozen, but not due to other things, so don't bother to check the 
return code if you are sure" is an odd contract. With the freeze-logic 
moving into MSHV, will revert to no-error.

>> Patch 19:      Export kexec_in_progress for modules
>
> Isn't there another way to differentiate kexec reboot?

I could not find one, unfortunately.

> Sincerely yours,
> Mike.

Best,
Jork



