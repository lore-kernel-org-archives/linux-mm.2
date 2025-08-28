Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435A8CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3828E001D; Thu, 28 Aug 2025 10:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853428E0006; Thu, 28 Aug 2025 10:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741FE8E001D; Thu, 28 Aug 2025 10:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0668E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:12:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCCBD160130
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:12:18 +0000 (UTC)
X-FDA: 83826355956.14.6A584C5
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id ADCF0C0012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:12:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="YCVcq/ky";
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756390337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGasVQTUSyANud2IQBdV3fHYF4iddxokxxxLGRFQefM=;
	b=2jx7iYuct1zvNGq6Q+CjeqoWPmaP+ND8aQuI6KNCSdUlNix2HqR0dlkq6UqETZzVyVluYj
	3FtqvwopSFFkZWBqy1CwIxQXIKpFHIPNBxkkBiVJLHfBW4cJU3qb6mZ2DOYmhqd64JKxPs
	hoHzSyPF4I4PFaJ4e1nyvCX2tz21rok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756390337; a=rsa-sha256;
	cv=none;
	b=76j3zwa/yTU6sXIpDd16F7d8zbqcsYWOWo2lrq5tSR7pRgyR1p7Onb6blPAWuKnrVjyz5m
	W9IPGfMan74BfPvGgw9Kane14aYNOExsne0ErBTdpVc6jcjC2Y0W0/DWFuodA4cqfEf0mo
	jgKLCeMu35oloxRJec7f5J9K1KM/ll0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="YCVcq/ky";
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb73394b4so144286566b.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756390335; x=1756995135; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGasVQTUSyANud2IQBdV3fHYF4iddxokxxxLGRFQefM=;
        b=YCVcq/kyFVN9Z3oI0fcv168fczsf7lN0zz5McDp8R3iP5/ZJzg8FfycEzAiLcp2Y6J
         X9BORcA2mFfZ1O+iaT54q9fDFIM3M1K8I/MMRgEwOZu0XiErxub96TMJ3bwOLsnPbV1T
         Fg/ipYL2u4CSg/LMicW4OBQfHZlPxAu7lO+s3u7j4S8rTyCBQwSmni2zJZNslgP0k1Yv
         uyeNbsCNugTTYhMJDhm16mM9GVENWWwFxm6TpU/7b4lVPBvwiTC8NKrz3fHGytKo9KgL
         tIo+lmal03o/w77LsBSAo8EcOVZGPJcjTN9AyHP5cskZChi8HvLwo7/YFFEZql0ePYGI
         T4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756390335; x=1756995135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGasVQTUSyANud2IQBdV3fHYF4iddxokxxxLGRFQefM=;
        b=sMP28BZEtc/A+BHwEIMIsnS1uo7wcL6eLdss1B18Zmluc1BSwSA3um5tk6DPBPPMqr
         FL/N9I/bZq4/P+gHDikP/U1oYWLS2fdGGzVd5PUn0Phj5p8+3Mi69NX5ZPvNbv4yWRDi
         zYBGs3IELUzhy7VgmCSbyyFcBcK0MuGZvovzvr3HHjft33A42rjFUK2yh7angMg7pBGc
         fX1zzXCz+EsCTGzyOpLZ1vGSOIcOlEkLIh7xJOr1nYtCHOi8W62Ob2PhuEtQK6PqifeC
         725bDXfvgLp9LRQN2C0jbv/E2uh00b8TLiyIlsh5TmnV0jWuyKIwi2/Kg67DedgMDqQB
         q86Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyPAxFwhhqMc3C8GgoMuwXus1qkFUbRVXko3c6soDQOxujLu/PN9wc6u106Bti3EkNfpAcqpG4Ow==@kvack.org
X-Gm-Message-State: AOJu0YwS3GK9/VeF4gmvujUmruB58XoCuYrEVehJJyUVVTP9mSoY4wq9
	ywRGzj6l2gQykhxR0uE9BXvNriVZ0rTjJHC/um7FHMdCtYDG7zSUajA7cWteZPvfcg/asyg7uUi
	qlC8gHBwCPBSY5HU3AeQWtfl0M9f7RFVvGghEUrEgFQ==
X-Gm-Gg: ASbGncshz/r8fn2Ey62I9LaSd03iAvgo8DBvMx7tOlvYxO0CCUYZx0FaH3AlDH3lawh
	3ygVSnIjerOLV6T5iz+GuxV+fbIGHlCQOyT7d+PkxeJsNN/dwPj4Y30O0e4QPLeTCePlFPlmYUE
	fIHN1wyJpHinUDSVjW7zlVufVEY7cmqj94WihkvSqo6+5PjmO186z5qsmiiuOxRu8uNcejxaZLL
	vAXp3qz4rc4EcZGwmV+EfBSAdJDAoEPrAE=
X-Google-Smtp-Source: AGHT+IFYQ+Zn1M6659H3JoC6ZjECHDpntiTMJRo82QHF+jENTwKdgEQHRcp187NWnMZQRXCgEoui+0Tl9MtmvbJvLxE=
X-Received: by 2002:a17:907:9408:b0:ae0:c976:cc84 with SMTP id
 a640c23a62f3a-afe28f5264bmr2173253666b.24.1756390334998; Thu, 28 Aug 2025
 07:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250828130311.772993-1-max.kellermann@ionos.com> <c1f290b7-b4e0-4ec5-b60c-b1e6d3e0f21d@suse.cz>
In-Reply-To: <c1f290b7-b4e0-4ec5-b60c-b1e6d3e0f21d@suse.cz>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 16:12:04 +0200
X-Gm-Features: Ac12FXxs56-Bnps1O6YH234WEdaH20xElL8cgETIZv7UvDBlU6oHboOZvAU_sQc
Message-ID: <CAKPOu+_TA3t=wbDS2mWp=WDy171YQqS6kR7AmSnpNpGn8cwnyQ@mail.gmail.com>
Subject: Re: [PATCH v2] pagevec.h: add `const` to pointer parameters of getter functions
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADCF0C0012
X-Stat-Signature: tcjbbfj65ks1ujm3zgawmseidjxwe37m
X-HE-Tag: 1756390336-636134
X-HE-Meta: U2FsdGVkX19uAzdERTIMCJ1eH/5gBgaOO+sNaO5ZJicvZcjjy8hI3n8sSQIUan8pHkuCc/mzebOka8aQOGV5fuuV2GDLkukWUvEjEjSe93QUi4zB7UTSkNGMgonaT6RZa1/GCQOovsYd9MbQFQ62HIIkvW2vIT2dF0Z0MGoucB9WaJgWiImIPx6vxE1o22fUhUKn+l7yl3+HiY9Cwa+SJlAFODJvI6204UfJcaFpY0LPFB1dtKMX0hpa7gXrYR2HOQ4kwoKKCmSVGQpUOIRGhq2FuJgl1TuaQxmr+G3Ke8wBxlFOe403pfrB/GkOO0eLx0v0p+hUiDNVxltkfkNUW4CvNYk/1ZYby5o9dO3szcqCMuek3spAvsXyR4WukqMVl6czHs0aDvTdOHMz5E1Z9LDs9R3BJYtuW5yyS0HAchx0X/RCczMsVnpPbmnw3tgV+w+JsD3j93S6LEsifb1lcAtpct4Tfc1dJ+2qt0DSATDqropKEQuh7m190x+JFM52rWtI176tCOBdORoENwBP3yW72CSO+yXVFkeLBLkcHxEb8WkfMRwE7WGaQMywQ+IhSx0k362Y/3F/CQQdUxR+xK2Xs2sak12wEW9ES25UlpaPAGlWTc7J/6ulsxw57HKxWRU5T0Q9BmJ66djXR7Rfs5pFd2QNoFWU0/MK/C/jqYU8RMYb/YG6c1tWkKsTjbr4e7ph41IUL7VG8CrBgATI2wR9xOekLM+blc73n8vNKuA3R5GOcPpE1e1aFose7lJjKrOr7EJrFsN7nZBVgp9xh3D5kud6Y4oPnAQncBMdc0pnpDBsV2WPgYPFvVvxMsMCkglh4nn4f3CPHzwXA9noAt4oB9niryGJhMv2g4WKjHMitObWS1MDC5MOKwveXChear6G09A+TkgHI/dPTEPdGzhszjK9qPocJyZm4aCt8Hx7UnPrnOE77BbijDUVPuz1S1Igg3O1+erxxslbjqg
 IFgr3RgE
 j5kad2SqL1jPu3doSm8vIJth4SRpFqraoPYV5x9ri2K+WLGVy/4B44VPI5BjLSIR7yVByiJBlqJ5eyojN5jYOUrppuDte+FqNyj48dZYxS15in9gCUMv7YLatUrmWUEFx8y+Q7NZ1ZeTQJv5riMeLpgpowE3Kaz+H0imNa9tbhUtGvxypWYE9NxFgtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 3:23=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> Note that your Cc list is still not according to MAINTAINERS:

I did, but I did this on 6.15... but master has significant additions
to the MAINTAINERS file.

> Assuming you don't intend to stop here, a series with multiple patches lo=
gically
> gradually expanding the const scope would be better than sending a single=
 patch?

Yes, but that would mean more work, which I'm certainly willing to do,
but only if I'm confident the patches are going to be accepted. So
this tiny patch is a trial.
In v1, Lorenzo had expressed general objections to merging
const-correctness patches.
I don't want to waste time with something that's going to be rejected
anyway. I've been there so often, so often has there been one guy who
just rejects my work, after similar patches (by others) had been
merged.

