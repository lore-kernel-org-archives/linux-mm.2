Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0ABD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03576B0304; Thu, 22 Jan 2026 13:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3B56B0306; Thu, 22 Jan 2026 13:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9CD6B0307; Thu, 22 Jan 2026 13:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBEB56B0304
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:30:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E68D160503
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:30:08 +0000 (UTC)
X-FDA: 84360439296.11.0C6ED3D
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B01318000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:30:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SkfShrrZ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqfjFZjqZ+qKfuAcLr5Lq6LxiUZh0aC9ms0gfa0kYpM=;
	b=bMNQoN2iQsupyexaG1v9Nkpkwu68ZgISdtvqGMwowKgtPXbpuiDL9UGw9vnb6W+juIHhAc
	d/lg6GX/Z7+akkNHpto+ScCYpjUaMAWfqNVMQygBlBGJ3imUPPtzCB9XOkn62c5AtQoK9m
	PpJiJ01y7kX2zTEo9wsYtLumZave2t0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SkfShrrZ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106606; a=rsa-sha256;
	cv=pass;
	b=cX/ZPOJlKkBZMHxQB/7uNAZYUh7Xldm+1vaJgZ9g7xgl9zuD0rml3mbJFxsbBcH0C+QcDV
	dfenCtqZ6RvudUIA1dct0yXAOZ0Ycz9SpDLu45czrHAdmbOY2YEEisVJPCzK3MHd0diJMP
	9eBm6qasVMwAmh2ZCPuFClH567IAKUE=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso2222324a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:30:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106605; cv=none;
        d=google.com; s=arc-20240605;
        b=DoNpzjPPr+7ZBl5lBFIfp6F/3kOgfA/F4dmvoWO6KuQ3Bmzak/+t6I3NhU5OIeT1Y5
         M5erA+bLz7kbpziYE2elPLCM6nylFYF0UOap/0WbAWYxvJUobu2f1SpwGWWETGXhIWYo
         DpEP0TNb3MgICKWaZJlXIyySY7Dk8dBvaIGVYyupIn3zoTjQVZYumUw8xDUhByhaaTyg
         pPsoo7i5qI7lDUMpE2GLOgFN5IfqcP9fyzivvXtd0h/OV3WZsP8YP5aZtZOFrdlUdRyp
         wG+o5VmxXRKNiUHcvvVfkeGfYHeYifFfEEBRr1ZA83uGfsCQVxKpuYVOE2LEo+89PKO/
         LOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XqfjFZjqZ+qKfuAcLr5Lq6LxiUZh0aC9ms0gfa0kYpM=;
        fh=dUIty9LfZwSsscFVJhCWkjXMsmTtEhKcKtGm2hcn3tE=;
        b=gUB61gX1LXr/fsFkUYtrSZmiqX9W4Ab4c3Voco3dJrXdNqKEr1wdejmmNqDJWU2mwr
         0vsR59nahmJpdQlpgTo77D+o7VRPcw7C2dKziu/x2gwZqgurRbwGUWywpkWeGFaN1rMz
         C/4WuloCDlUSMWl8QncJyqFjt2JeUjQ+V3LG3rtShBicD/wvbKrpLqwATZetPhfemfmw
         oGmAxSIVBPAcrAtegr7aeskUPJAl7VJKKJ43ZzpwHZYeBIzQz135TzAPxJ49oQG1lXHR
         Rd6yaRKKXivmkJ95QaGPWqjSKVtfx+KZqQaub1QX70lHT6eU7iEWwNztkahFaSCCA0ym
         cYjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106605; x=1769711405; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqfjFZjqZ+qKfuAcLr5Lq6LxiUZh0aC9ms0gfa0kYpM=;
        b=SkfShrrZ82Tdkc4WdqbyBrcXWEfrx1YFs7dcMOkrPU3RiQM+NQArNX6SfzYMVJqD1O
         aMaQ/NIZ2PJHtP2TJRcuTtZWZL+LLUPM/K+7KCqasP+5SVaYzdSyIK+C6atfCjcSg9mH
         ZyZGBq5gv2Ijy4cdNy9rHqBs4J4DeHBxCLs0tp1aOxhA4jVU8dCjiOndozTqn48pl1GA
         frL83lUYWsga/djZ2mNPbNVvbiJncnSKOssDtKcA6loq6ZIVzvvyl2wOHFZfvfE7+HA7
         rnbnqiacQ/nTZOP0k+MfC7givXQgcd5VFkXCstN9EX3DonKiZuy+l3tv05aHQofIcBqK
         B4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106605; x=1769711405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XqfjFZjqZ+qKfuAcLr5Lq6LxiUZh0aC9ms0gfa0kYpM=;
        b=a1pKVPYnNpbofEOaVg012AJ1lqcgOVRqeYuGsMaJfQUGjT/4zGP+nq9wwc0vnUn7No
         N5JtUEID6hmfBg+G/MgatO8gtRIHoR3H3Uhx6fkcUI/5+EVw744f5anOPDPJ1Z7dggDJ
         Yw1R4FK76tUNFS4DsAqxw9cd08iP1LZ66gOEEVO5NCPTtIXdblmjezZjpVVGgRq9n8vT
         pYk1Mrqb8U01m0+b+Xb0x5Txc5oJbrhso3AEAJT64slUzG6h901VKOeJcJeeRmH70MpQ
         ZTcOGvnMsk7nQrf4DNLnNRsZ4Sb/ZJqK9coy1FegE+FUVHPYmkum6b1MdmXjLFO1Lu/v
         eaEA==
X-Forwarded-Encrypted: i=1; AJvYcCV8PjpYdg+OGRyc7co8FSV1UpHyb45rXcD4BrVmGppG1OwYV6QIkKTs5A0s7Aln06BEzIf9W9Ftmw==@kvack.org
X-Gm-Message-State: AOJu0Yxq4rcya6H/vC2HDeZS/nufEiCk9/YR2bDlRECEHlWZg+4YMCLN
	75AIq8y01MLxOw4qBLvj4hoQqHIHPGjaL0MhM6KEfaHORdTc3sVrLN9nOUSvgBEHkqVoFFgZED1
	23O1F6G53WcbrELF9pl31xUGYOqtDofBff3ajlYbKuw==
X-Gm-Gg: AZuq6aKlKt0MSRIKLHt/hPeGmpOt9BD/DRcBR3SZg4VzTmWJHNji0T9CkU0EOzsKvyY
	S7J07psWmi4HZquD/RrYblcCvxh9tnNfmb+HXc0IRGewnHbqnJONlAH76+A5IR+T5T1xkbo3Ltu
	Xu4vz2IutjfTMiqPPGT+F/UmqHZCtyTdzCrhGCvud/rd18euFwsysE0gG/pnQFceKt8+bi8MLrT
	iCRX74EZgqfEEnB77siXtp64Cp9EsX6PvC6IqbKwWW8FXi4QN9tdpsZAhaxrDk3YYOyfAmkJHwO
	3DDMH7n0vnJAP6XukF3uGkMTuQ==
X-Received: by 2002:a05:6402:13d4:b0:653:e391:6f2f with SMTP id
 4fb4d7f45d1cf-6584b1a37e9mr194745a12.9.1769106604981; Thu, 22 Jan 2026
 10:30:04 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-5-rppt@kernel.org>
In-Reply-To: <20260105165839.285270-5-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:29:27 -0500
X-Gm-Features: AZwV_QgE9tT77JRQYCr53kQCb10BhXhbXggqjEIyG_WPw09DmKeAZcOWTin2V6Y
Message-ID: <CA+CK2bCB+n5hK9SpMewWURU75a8sY3BJz=MEu_Zy1KwU4Kr5Tg@mail.gmail.com>
Subject: Re: [PATCH 4/6] kho: Introduce KHO FDT ABI header
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qpp1yb58gmx1adzjdzmp8cnptutyo9eo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B01318000A
X-HE-Tag: 1769106606-430450
X-HE-Meta: U2FsdGVkX19nFJKXyiJejRXKTUDsckZ0WVd4gyI+nF0QNC6eQISy8xjuSBlH1iqfDaWJmmnMevszujDPtlqCYywZJJdsk6dyxpyRoq7sM+kvhHA2AcSYKQmYtaO0wnJ6SxMihHWDdjFKNmoJgcwTkw9OJjPisJ8JJeHQOkCGBwN8KederzGxz2OZuVSqjBKf1zygPYbkBZRCyX5RvodOsdqdUedPITGBiyryzDH1BRsA0IEuvmdrzl6tlxW21x9n7RFs4cPbq2oJAuogDODhkRFnCfivZKSzISBGpitWMCm4VXqi9L5asxfF7WM4m29udnWI3Vk6tpe3mlJeaHezUEVy25+vwhxw6h+fLQk+E8HJJt9SYs0qayQ0KdC8yAtmjP3ubaX0fSMHce++Eby78yL9eu50kAyXKdCH92aEiSpDkIrxa/CI7S4zm9yYKrCfSDGXkdkZ/gAOGRAqxALdjQ0KcUqgMxi1J63O2WXW2djo9oNMQPETazT3VJ1XAtci5c3OwATRs7HyYJPFMrOcnSxhKttczBJUfbd6IMNxSskow5AG297Je2XWWvXZ+1E29U8EpH3mDYP+McHtZvss7xPcN+Ny2yQbxUcSiP9mTm6xVXy4qmbMsN2lKoDR5Yy17XmfZrWcqhNFFKSpb5DSnwEwALjdZBsG7rJA4tF4+jdqx3RXpfo0iM/u4xLL21vZevFVyjx5pdCdHigcVHgOUMwSByBbc5TYVP37gHiLa612AgI0TvhNhFyshlI3yn4BvDY9fYFg2awpb0BeM16kuvG+MMPZdSEkZ9/jNnwsTsJmTUudKR3lB7twNWPb+dVGoGuNSH/s5Jqz+I+SZQGOYr8FbrStvyDbWnjhL2eVva1qzsEOA/sYZ4k9qVYzsnmpFuOPyO8gd5uPAvaIBkVl4kytORLQ/XCl3DG6ceJ0w+9nSK2eRkOSamZKVrqvtaQ/X4r9X2UrxbBPvgKJLc+
 rr/J6Loh
 /ilti3MBuA79v3rg8h7HfiICAK3/RhtWOcFbAdF8g7XqKBwGqomwOQwG3LXbKpWfgLQ8XvXrV8cgr+cVZMNHd/kGWLcjeMma+sZslpaU4m2jWoVjLVJYRMCB4kQtYSJSB/g5giaxeYBra2yEFskyARz3jftuVb8NxoyBG2KZPR++r5Scr+MVivWTQOA0HzE8Dl4JZBEIvZstwDjvLlCQBPqsCBX/98KVH65Masa+1E0XPADk0/ATxCUUQMBvRALycSD3BBY7rBugoyxPJVaZOyZ2dTpDpwPGffGQQNg6NDUeEkYS8i5jyGx3+RDY5DZrgR5kg07r1P1nHo8Ph8tRpWwPJ460UZTXRS89x1InkRenhN7hvgka3i2YjjXN070Geu7me6hAkllwcJAQ76tumB1/atvfAF0UKFRkwEMPJk7oipK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:58=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: Jason Miu <jasonmiu@google.com>
>
> Introduce the `include/linux/kho/abi/kexec_handover.h` header file,
> which defines the stable ABI for the KHO mechanism. This header specifies
> how preserved data is passed between kernels using an FDT.
>
> The ABI contract includes the FDT structure, node properties, and the
> "kho-v1" compatible string. By centralizing these definitions, this
> header serves as the foundational agreement for inter-kernel
> communication of preserved states, ensuring forward compatibility and
> preventing misinterpretation of data across kexec transitions.
>
> Since the ABI definitions are now centralized in the header files, the
> YAML files that previously described the FDT interfaces are
> redundant. These redundant files have therefore been removed.
>
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

