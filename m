Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1692DE9A049
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 02:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297336B0088; Thu, 19 Feb 2026 21:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244B06B0089; Thu, 19 Feb 2026 21:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC06B008A; Thu, 19 Feb 2026 21:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFBCC6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 21:50:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98B5D5C06B
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:50:39 +0000 (UTC)
X-FDA: 84463306998.01.AA7672F
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90B874000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:50:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+3CrSGC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771555837; a=rsa-sha256;
	cv=pass;
	b=boCzU41kflEQ10Bkopk7YEOK0Mnfw0m4f2itKjMcNK7K7ArAK9y02LTKi7WQ0EJ8/uIYPh
	nmKIr7fJ5MCwjAc6oVkT0xn2tWOl9XU3dMK64YeRsBGw+C2rDQLozHG98dkBaB4YV4Vg+q
	ztvetzWXJN7ecLaHq19sv1qHs1wuKQs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+3CrSGC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771555837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//4TvN505NNuNnrj6p7kVS0Ee18l5lpIvo3njUSZ+Is=;
	b=76GuXk0TewPPW3w9JgwUjgyu0ZAVXA0Mfj5dGf+LiRXqclbaS2pbt+oUN2BWl+XIKLqmTx
	2xn273fPlOKlv82y0SKkxbOHXacl26rs7RgZEV0sgEn83/3BfzVVj/HbXGSlRTJa+9IFzb
	EZRMDYO6sRrXb+SaSqJDfuDjHQU6aZI=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43767807da6so1176319f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:50:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771555836; cv=none;
        d=google.com; s=arc-20240605;
        b=kaqaCQ2gA8BTg2MsaRzAHRMoNcDk83SzdLF3LGo+9TmaoTNOxARikjwYTg1a1Ap4Sf
         169GupEu/E0dLDbLMwvBFTsQP2bYQQerIy+tHuv9HsfQhPZCgTF87sfy6UJVuQ+r+Fq7
         kRgUzMU0wr66thNW0/BY6m4pvx4Ilw7550425//z2UOvrndPlcHmKmaAgbFooE+DCLJJ
         T9lpwnMqW2So1UohSUrDROk/hb7wuINm1CUtwb6wXCBfO8q0bcg1ZKcYeLGjJTO7UV1u
         ySLwVOD5ofJK0avudycIvF6iDScxHZ07r/Ik3QIDEoAWHquYrXLYO0eySWWkW8YSqcP9
         OMDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=//4TvN505NNuNnrj6p7kVS0Ee18l5lpIvo3njUSZ+Is=;
        fh=XN7hKfW1GBcJhJlsAOnFH0A8GaWwRpTcUSJsNwTT3yQ=;
        b=afOn/rNq79Dd1IgMd3nip7TJ8vANfP6FIeemiN6RUfmnM5yOCDUNytfhjRPMvwmYRF
         ol9Hkm3uORjCFB+DHY27fgKoXJVloSGTxEON3MybZ590doZBOodUzoOvrxzL1dfZXNkP
         kvZEb4jrSh/rfgRrXkzPizq0Gp99IOWjDFi6bz/Thbp/LXJYm0DEm3FEFmbfy22w6sg0
         LsYmZ4nAB9SWvWWTvsAHeYx4mIbT5PYYsRULEg9n6R4W62uCTcZjVwb4Zhisg81O5NiK
         wPlfVN6Wx8yfT9ceSDTnp4XEdPFyOUeQ6HdGmGe8L26QV6PuBMhpXvvDXyaSZhaE8nOR
         lxhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771555836; x=1772160636; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//4TvN505NNuNnrj6p7kVS0Ee18l5lpIvo3njUSZ+Is=;
        b=T+3CrSGCPgxg+usO6FwUT1kcQVsX6GgwHf6wCf1AoD4pRTGOzu6l7Ue5dXzjcpO/Fm
         CFuRWOnmzv8kDCUzMPv2jf1/i5IDyug18EJIpDWc1WEjxyUqTLUjPEgXbCCDDFkJfFE6
         sg1wOGX/t4cSDVKNfvYSbNaGAb32Pnq0XiG6p8VYrDjY1CbyYpRhc12i1Mad+cHUEfPa
         Deg8Ofgpgrzv9W5f6bCkgaAxcrPKPKBW7nQqv85UialN+KO6BijHXzAe+Rj23hwksviv
         qCpusVs8wK+SmNM1rFgBd8jmMu8mtsFFHwCFtu8pBCJuhNxdyzBINKRyGtyHofxESQ+3
         5MxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771555836; x=1772160636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=//4TvN505NNuNnrj6p7kVS0Ee18l5lpIvo3njUSZ+Is=;
        b=AIax4Su8DBNWZbf5I+H3Mn66Z8vzSe7glRuVy2MruC1D4xDEFbBEA4wxnxB9Gw/rdf
         b3og1t0ypPG2RcwWduhqExTrxZSI85Q9wDGbwgqY8sd7C/qjEbw1e5vXQAu91cSQCyle
         4ErvEJovi1bBwldhKKazW4ugXjv+d1iPt6n4nbiWz3lWhRU/+Teqc3eFE+MRjiMyliCe
         E4XdhvGCdd0VhNkrMaQibi0gZEBzqkgzXaraTpY7Ix4LTaF4wQsyIdGANW384hNUDttS
         mv3yVNGisspaxIE88HC5YRXPqSTFNXkSnUH8Tp5FDrTo4oLWRvtrGqf7b6dWg+jjb+Jj
         Q7WQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+pyAR7n29qDSnWEs41Ylgy7aUQVSAcQKriNkiM3S8Ixzskdp8sU15CgfLVRlCMfgn5Lue28hshA==@kvack.org
X-Gm-Message-State: AOJu0YxEaK+gL500v8/B00ZaH9J72wMw5K4cooe2nXZdxRYQkPE1FVmV
	UVzNkzMp5LN2mcS5GT2U28S41wnOmuLNxb46Tm5pOy793Ibs9+iwcvYD4bYnCn0CYpgFvkK77OR
	vdlmAhikFxbmVK9NGqwUWPUWZfbsgOzk=
X-Gm-Gg: AZuq6aLErGeA+hT9PEztJCKcpwBtEsOmYrmxK9ZmelKEtOSPrBraQS7Va/u+MV2VLBZ
	QKIhy83Yo6qHcU9BqHzOtjvfVYswzxAk6p4K/hyMuFBTjdZWQ8x3KwHbI6MAs76Xq/LmVn3hZlA
	3MS4iODv0z5pHUHhxxtAeb2ctFysurevSu5I04RpMdjI7hdcbhjWUxpmaPwWuBeyjYyNZNgNDrJ
	aWjL89TI+Na5JODTYobvr31mVuzX0o8Dbci46S8pD5I6pL6J20yarl3hvTygXACJ70VawnljbGK
	R/xKlnNBnM7+HNVxY1VdKBBQCCqq907HC8zGLiWOgPd57mvaIJSKPL/HRd1JbATpifyIGNvku/G
	e6KhFw/InFoNFhFHREhDaVJF2DCM4EZQM6uGq
X-Received: by 2002:a05:600c:8b77:b0:483:6d4e:9811 with SMTP id
 5b1f17b1804b1-48398ae6736mr142110645e9.31.1771555835677; Thu, 19 Feb 2026
 18:50:35 -0800 (PST)
MIME-Version: 1.0
References: <aY3+Raf8eZqipCd6@e129823.arm.com> <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
 <aY4Vipl+4rGa+u6D@e129823.arm.com> <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
 <aY74MqGV4A+kwsQM@e129823.arm.com> <CAADnVQKAv+MRNrK=2MmEFKcB0FkmtG2pchdp35xo1ya-ujqVHg@mail.gmail.com>
 <9c7a5db754143f59bdb2129616d2a23495d4b3b9.camel@HansenPartnership.com>
In-Reply-To: <9c7a5db754143f59bdb2129616d2a23495d4b3b9.camel@HansenPartnership.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 19 Feb 2026 18:50:24 -0800
X-Gm-Features: AaiRm510k0AJv93e_6kEPHNHD651Rror5rKfPW512B9wpfkVqt4fKVcueOPO-KM
Message-ID: <CAADnVQJuYDgbwvZa9zuUXcPoHRp25n5NYutbEsv6F-NzeK4oDg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, lsf-pc <lsf-pc@lists.linux-foundation.org>, 
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org, ryan.roberts@arm.com, 
	kevin.brodsky@arm.com, sebastian.osterlund@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6bhnfcmie3rts8atr46e1h6gk4dqzr3y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90B874000A
X-HE-Tag: 1771555837-299062
X-HE-Meta: U2FsdGVkX1/2sHlQ3sreIPLVRO+UFaHbLdiiyrVn+q9w2jrIMXTD2iYYYe5RaN3IK1VW0oaJXr09xTHOtrj7qQaWApbkxu+90E0GYJKhBiX/U+APz7qMIKcNrrAxHXm81F3qekM9T596dH0YpGuJyveW6h7BxWSmewk31j1JSuu53zmU+Z9jzB+d6Pji6U/suCpdauFup5Uu6cF2+R35k9vneuBaUb3Fy2ESAoaEmv3JMg85W9skk0Sc989nEJLy1R9kuqxqK2futOsaciMnq4wvSu447m/UuL/7+7JsdRmQkhKdf16kJ5FxEVEQR1fM0nq+K9gATObs6cup4qx2X7JF0tg/zf0Ap4ROboT6a1F+4tSGtvvqpH5wJv5J73PtQN8pwxH9gNlYjWuPVA+7ovS3shXbzMFXE6Jhx7TTVRfw3rlbqbIjt95szVHtDTmx4O9h2z5OG9wcorFSRDIx9D3J2r8pXuWBz+6r4OBcPQCzyxWijkq8cGkL3DdLm9uotI8hrVQ8xvscwUHb759ku+1O+Z6VPIK9pM7NRQECM1sNwsfXxjVzFS0dmPiK2XCsNY4ar8jvn+Z0QO9WGxXGOj1wBATrspgrNQahu1MyPHaPmpuLdF06Kvu+b++REmvztgZlZ07rc+lHUkAaRk8dDQVrKnbiInBYR7KsBJ+MhsQ6GmyNFTZo4m5YYS/GqZBME3XhWTMTNEQ04IaHUq19RLgUy4XYbIC3NgNMbYkQw0SZf4fkMuySQjjQ3+LJxDSvwGZgsyBMYu4QygWy1rx0K2PfgyMQybi/MoejKW5fKSFEkR8D/7TShW6LznghQZ+f0qpL93iHazW3swP2ZCchwRGocCmDYUGTto7DofzYiLm1r5+SWzbenzumY0XsAe1wFhof0Z6XgabaReL3Zblv6h3LTcPeYE/6zM9Cm4mv5FmZXEjLwsdtZL+kfl/aDSw8Z7Cy32MDOZ0otT+1OUE
 YOb2DZ9K
 Dc6WXpKgqnv8GvZEXNUN2FWSbKTVh8UGWK6mg8hrqUojHsztQO4RPEJ431oStCB5GOHMScfBc8qrolOF2GywB4AwORWnoK1nbae6roviUEjNwojpOiYDrNg4LNzgqWQRp4xm2geL3YdU4XvGPvEC+IN5oHymkLQ3ZwBYYUU3u0ENczgGiWT9roRnlmLFYb7wc33wGe6Gb1m00djdVBuse3Iowl8IOdTL/9ql96PvjUV46l4xx1/5aS8xBmqk8K//o0qGmG7geOOLWnf0QfKxZ82TFLOlNXIpGlhzQn1lBn0T5Jatfgt1Q9C9aiBurachirhYeJSvI3elJXW3ILRFIXD0mDrW6OTaDZ8bTWuX9Ie2i0ROi+JZbccXc4+5xLWHbC5rUvzeF1vCJZAzIRkZOknLLLjkwkz7I721DcmAbZlgPQYDc1HvQekNMHUoWnLY8+1eAFWGH+pHr2V26vLex7exOqAsQ03bWmuMscw+iEx3FXm/8aNJyCDtUH+UG8/0iN70cjTUcPn6oqJX2AGCJd5o46LcEIzamI9yx2HMzW68WPj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 6:27=E2=80=AFAM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Fri, 2026-02-13 at 13:37 -0800, Alexei Starovoitov wrote:
> > On Fri, Feb 13, 2026 at 2:10=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.co=
m>
> > wrote:
> > >
> > > Hi Alexei,
> > >
> > > > On Thu, Feb 12, 2026 at 10:03=E2=80=AFAM Yeoreum Yun
> > > > <yeoreum.yun@arm.com> wrote:
> [...]
> > > > > That is correct =E2=80=94 this is a verifier bug.
> > > > > However, the concern is that such a bug can lead to a security
> > > > > incident. Not only root, but also users with CAP_BPF who are
> > > > > allowed to load eBPF programs could potentially trigger
> > > > > additional security issues through such bugs.
> > > >
> > > > Again. They are not security issues. cap_bpf is effectively root.
> > > > Just like cap_perfmon in tracing space is a root.
> > >
> > > The argument is not about whether the verifier bug is a security
> > > issue per se.  The point is that relying solely on privilege
> > > boundaries (e.g., root-only loading) does not eliminate the impact
> > > of a verifier bug. Therefore, leveraging hardware isolation to
> > > further constrain the blast radius is a defense-in-depth measure.
> >
> > I hate the reasoning that bpf somehow needs this hw feature.
> > It's not. Look for other use cases for pkey.
>
> That's a bit of a short sighted attitude and also you're looking at it
> in the wrong way: hardware, correctly designed, should always be
> looking at ways to help software.  eBPF may not "need" this in the same
> way qemu doesn't need the VMX accelerations ... it's just more secure
> and efficient when they're in use.  After all, if the kernel had said
> "no" to VMX in 2006, KVM would never have existed, we'd have been stuck

This is a false analogy. Virtualization extensions were added
because virtualization software already existed and had shortcomings
that CPU designers wanted to address.
Here pkey was added to differentiate one ISA to another and
now cpu folks are desperately looking for a use case.
Maybe it exists, but it's definitely not bpf.

