Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E19FDEE45
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57B96B0088; Thu, 23 Apr 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A090B6B008A; Thu, 23 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E476B008C; Thu, 23 Apr 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 813AE6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:23:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C05391404FE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:22:59 +0000 (UTC)
X-FDA: 84690944478.29.37A053A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F76C100007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NSHVaFxV;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776975777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yoTTIK9jvtoaN6oDnsx9bypKCAdqDn3T/Bi9awqNlY=;
	b=HBYYfKI8l46yCxD/V+FL7ulDzLUaBCjpKYpp5h4bnVIPzCgpKH69vVv6FnDggRGbaSAvoP
	XA0THsPw6gPzL80mQ0A/j4IYjC67mSImI0mzgrrmtRsIitm5/eGSDFrW2NSdyQWz6Xc5vR
	3kM7MopcsYFU+8KK0OLasTlN4VcS42Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NSHVaFxV;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776975777; a=rsa-sha256;
	cv=none;
	b=HwjOfj2FCvyCVU9XGYXEu8aDJr0IM6qRyyWTJX/D2y07QWBri4F32RWBqu4PdOVH61IuaK
	8cdrISnMXShlYJvSVXKG7IJeod3EC+Lezgs1gXTKElx/Q66MAY2GXzB8UmMMMDf9rZzF4h
	lvau9zhCdieM4B6N0Zk2hVYj92FIGWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D7B344569
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E63C2BCC4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776975776;
	bh=0yoTTIK9jvtoaN6oDnsx9bypKCAdqDn3T/Bi9awqNlY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NSHVaFxVgnvgDFPLBJRn/HSJnZnyGD/ETRl2aeH/5+8ftgO6I014jzvwbboCkL/DV
	 vSWn2GWQ5rtQ7079GaIuISrBjyLDaPTqQi+kf9+KM1vwpr165BU01xWZy4Y49+57TZ
	 UAxDW/LMf95RShQtkbIfGhHE4qT0faGUC97lsJtH7QRpv2bGHVpOhjrs/I8Y5XG/Q1
	 nF91M1WNGQyg5AsFfd+gta7suKTnNv09DE/0DPSCHxU62RKYFe7Cx+cUywkvw5vJ1D
	 3XjZTzwYiowb836iNPatcsPWNutQlMcwT4zF0r9zH/oLbvkvc2ftXVJ4tPBCp7MYbU
	 E8NxenGg4tqOQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8f97c626aaso203381866b.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:22:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Z0k8Zjw9aZQvAyTFs1K1dgpq5X2/l668zQ0zDOlmMz7ZjscDwRHOOdtqpebYOmznzCBOiaRDjmw==@kvack.org
X-Gm-Message-State: AOJu0YzxdkBB0kvGwrJv6KkIa8dbdBBefGVN1ZJ09Kj+TY3ERHsMs76M
	GQAjZSodW+E1CyeDbB4wiMRKDNxnOljXVK0lKWPrN4pdMYR3C3gjJp6DxUDtqwXIQSYoxCZwOn6
	gBEnyXC08eHOOoIQVbFFcGycEqNCIlj0=
X-Received: by 2002:a17:907:6e90:b0:baa:65b:fe43 with SMTP id
 a640c23a62f3a-baa066b40d1mr643391366b.38.1776975775156; Thu, 23 Apr 2026
 13:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
 <20260422190847.216343-1-pratmal@google.com> <da96efa9-401d-4d11-90cc-00ebff340921@kernel.org>
In-Reply-To: <da96efa9-401d-4d11-90cc-00ebff340921@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 23 Apr 2026 13:22:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOurrz71zxi7kbe_fYxqyQiizrHpkv_1rqGg3x9YzgAdw@mail.gmail.com>
X-Gm-Features: AQROBzAYv-6W8FmrEkCiowKjw-qG_okPOzeXzxeHNGb6zyZqY0KL08DwDTBCY10
Message-ID: <CAO9r8zOurrz71zxi7kbe_fYxqyQiizrHpkv_1rqGg3x9YzgAdw@mail.gmail.com>
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: pratmal@google.com, akpm@linux-foundation.org, shuah@kernel.org, 
	yosryahmed@google.com, ljs@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: toccdec9goacdk1dt8kwsttqmmftjbwo
X-Rspamd-Queue-Id: 9F76C100007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776975777-347194
X-HE-Meta: U2FsdGVkX1/OZNdfIgjQ5ZL81DpmpdSVkEomMU92FPqXh2bXJswUJHqRwG45pXrgU8nXNLzbQ0y2OTX9fEzjfeRkBdljurxWX5KE1d/84thrwIuepewEsuyf+XEZ+XOgIiRbwjUgzWoukusHJpfiKDQ9JYSURWFi8J8WbQOOnAgDXkXXGMwy2GABZ0tp7+gRAuOV9SEvUINM8DtZ4MFHp44q+oIR00fZ1qWjQlc+lceP6PuKyZUoep29B4JvWxDU+3TT0udOQQxFE4e1KluyR0J+rYFFsEzMjEI3Cr67teWcZX5iK9moAj96dBYVwsOYaW5ophMT49rWx65bce1NN2Zfe+4Scp0o0p29Tfq1kBGDoAQzDLVz6J0kNccFUiQtHIs+o+lLmiLwyYhEm7azq2K/flgyMVHfgvJ4WQtD7EmNaqv+7KALl33ii7IH/MjpEONma03T+cGf83ydpmOCjNNPe7NTXE84Pkwr/JoFxMoFINjNzOnQKFgh+j8cMuChXi/4tVkH+H54TUwD5Cz5Dy7KOk9G1Oagxl0EPkn1EpxIMEVsUCfVSS62hm6UUa2yctUCQdNfg61wT/CtpsAClEejFUkQ74iv7KIhaCcPcqx+EhrjHcprEBI1DQe98A5TYhdk3BSnBg9Lg0Vzywv1Bl8c4wR/yIFqKgS35ilUCTKUhXYnSfp3kgX10wpxBb+BVrmyaE2V+F6XDIWqs8Q+vzxaX2ne/POPfvJy0OgFHqcgdc231V7oW1qoAG7yOkXbvnbzjrWwOIAXH2j93fPxktcYN1UjOBCXSZMQptB1ryYqMGgXfWe2NWySyfM+y47O7+/ffJjAPOXIlvJLEGsBaiTvDVLBfpvgMOWPzePjujErpL6pbVQs7Gf8c/Yu3Cb6Ivk85EEqHtlo4gbVm+pAefcwQtJKV8cIKePicE0iVeYAxEOpUhVOdYcMxTdMJ1T52UoePoApg7cS1qk2IKt
 cmqR+Rds
 BEJ1KK5pI7UanhLtmDI/bh8MSaSdoUyNnIMV2oIWSTdcnTQ53b9bfMWTa4R9wONMxY51UZ9mUF5kS0zFj0lqKSx4vwmddbq5I3WS8iF7pFvikrcSIgcbxDcZz3b6xlttjtfQl2s/hp43q1b15S2yHH3nAlPNBkVJjN2WakBNOewlTAGthArD3kfmcGKVHhMXg4EqKtY05ANvBZ5zRO7KhF+VlHMz+2FjRxM1djVGzS2Mbp4joo3Es4LutrgN4N7Qs61QZqs489EqP8eii0Omdw7WIAvsjT5HYxGb/OvBW6TnurrWz2pwpVYQ1WX5R3sZ0AHY7bgTm8WTVDNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 6:28=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/22/26 21:08, pratmal@google.com wrote:
> > (Resending to correct David's email address. Apologies for the noise!)
> >
>
> Heh, no worries, I didn't even notice.
>
> As long as you CC one of the mailing lists I'm subscribed to, even mails =
to my
> old RH address will still hit my inbox.
>
> > On 4/22/26 18:04, David Hildenbrand (Arm) wrote:
> >> On 4/21/26 20:30, pratmal@google.com wrote:
> >>> From: Pratyush Mallick <pratmal@google.com>
> >>>
> >>> The current .gitignore hardcodes each generated test binary by name,
> >>> requiring updates every time a new test is added.
> >>>
> >>> Switch to the patten-matching approach similar to KVM:selftests.
> >>> Ignore everything by default and then allow source extensions (.c, .h=
, .sh)
> >>> and tracked non-source files.
> >> That looks pretty nice. Any reason for the RFC? (iow, are you unsure a=
bout some
> >> side-effects?)
> >
> > Exactly that. I verified that the build works fine, however I sent it
> > as an RFC just to be cautious. I wanted to get some feedback in case th=
is
> > might introduce some unwanted behavior that I'm not aware of. :)
>
> After taking a peek at the KVM one, I think what you propose makes perfec=
t sense.
>
> I do wonder, whether we want to make our lives easier and rename
> "local_config.h" to something like "local_config.h_gen", so we don't need=
 the
> "re-ignore" part.

There's also the *.mod.c part, but I am not sure why that is needed as
the current .gitignore doesn't have anything with .mod.c in it.

