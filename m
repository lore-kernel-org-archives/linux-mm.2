Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA74C982F1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A4166B0005; Fri, 16 Jan 2026 13:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947B46B0088; Fri, 16 Jan 2026 13:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833286B0089; Fri, 16 Jan 2026 13:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 721096B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:30:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 143FF1ADE39
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:30:30 +0000 (UTC)
X-FDA: 84338667420.18.D61D300
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 146588000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:30:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mruLAG7V;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768588228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78gXhgLyIFLLpASS5oKJ8Lx5Grl+s0Di0xH8SDZDXS4=;
	b=5VLyPZPmLcVQPhi60ZBFCVayQSHrN8WHNE1XhRapHDRQP8DrXXX8qWO8PBXe0ckYbP51RY
	OcgUu4XXIWIvEkgLsI5AaP42uGsV3JuyIOE83hvyOMvTbww23S/W+/X0GlcaVCEJiENKkT
	S69o+2lV2lx1SALhct9RljHcztRDB/E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768588228; a=rsa-sha256;
	cv=pass;
	b=AYObbx0oSoeg3tWTM4Rv9uJsu1YKLvTfeId7VGSmlsYCCKpBRGDYQqd1VkWiMHyKKchXm6
	F9XBtGkYAi8yan6y3GlT2kSF7uutTlKyAjp1XN3ig2bblQuRGkYfh3RQtTjYKJpt7AtkFA
	j5T1ZjgXd177jaDcR5kp7nXdZ4/jqMw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mruLAG7V;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014b5d8551so15361cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:30:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768588227; cv=none;
        d=google.com; s=arc-20240605;
        b=PQ6lG4XARlUtqRvnxCbSiJqthwtpMK5EZnKw15GXXfgE4bOiZcEVbfYFFbD5ar8U9k
         yhewPhc7M7fUwtPWpr84oKNnsnszTC6/s7Gy1VDw5W0WPIBiNoqbgwgTXspWMmxpulBh
         vg+cE3OQDbl+CPOzldcWOF7FbSe2+PCvPjXbhnulX3PW6A3/Rz1Ve/M0eP+Fz439iVQS
         nDHGNvpdd7tLHwnHFt4QI5JFlRROWL2rNmrT7GZJpKIg8kxPO4JYGchGbziVwGrGGxU1
         xk3jpaKFtJ5nxwGzl0wUgPDQFCIwmIzgfg9FEwGssSCUFlO3LY2RY7I62mQDFDicuKM2
         8kFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=78gXhgLyIFLLpASS5oKJ8Lx5Grl+s0Di0xH8SDZDXS4=;
        fh=e3CoSg1bfx45U4imMsF+IcYWT+eeVBHQ0bI9bt/f4ao=;
        b=XUeLYIuv5+Cnpw9dj+LBXqYfJ1ikOC+bvbHHbg5yKq8cbERLu3aLncZ9muHfAxTgXM
         pW8h+Jb8TcLZnBgjmEO4im/cd6dj59wbtaBwXKKeQP88DoKJwofhwFx6SC8don7MIWrz
         Tynq7FfdvufPspHhlqBnYHBZngBmp+aMmAGWbT8sAU54qYLaPFCs5d/5oYfQDYSLLki+
         Cg3BMIEHiF2dx/JL6hwD8+Z5P0ekrpslXbK/Jg2fTXRYbAoGBDjQojz8XX8z8/+TgxJH
         DsFO4RjpTyHy2tl6MJuSsRhwNGmCESW3hn4+0Ack9Nb5RsdWT7UW2u9aH1dXVmwHAErE
         g6kQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768588227; x=1769193027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78gXhgLyIFLLpASS5oKJ8Lx5Grl+s0Di0xH8SDZDXS4=;
        b=mruLAG7VJi76qSGvElBABxuw47zNmh8nWJRkzK7sm19OnWB4Bqo3170COy5qb4MYVv
         pEA6RTg6nBRl+2efSfNk41IucTT/xHHBKmIjWf3aPCY7WXd9ZOEzkh79ffGGQaHADvV9
         YUmgoxfQGWoo96UhESSPd5Y624VYYm7IXPw31g+2alEwOB87gkpEjBZrJuBsizBi/nQa
         1el1fmt0kc4melKdZoRy29WpPRfvEKCIKdCd4zhyBGSTC+navPqf6RA2RCHaPFEfnuH9
         L88E0MFgR00xA/1Qhgt1TBBVdc97YR4k+6hhERUwSc7m+6uxEXPBRX3vTHRxC1U7GvR9
         pMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768588227; x=1769193027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=78gXhgLyIFLLpASS5oKJ8Lx5Grl+s0Di0xH8SDZDXS4=;
        b=b92VgEbRKhz/basAuvhuHRn0QJEAqlJR0Tmwq7F95cHEMAaZbwKTrWEAen+0j3x6w2
         RoB6RyWc3RwaiKTKGkw22GF+2nXX89dJYuA7S2FOOzSzExFTg6EG6nLg9uqOJ3ZgaRdk
         LYyGcuoEASWxtD1woS1RR1MTgiAzCvQwVRTEkNQotIr2OxFUthrSPiDUt/xNcJEUDfl0
         9m//K92OfA2nmrUVAUX39GOIsH8ZVcZmLG6IrCzH2kXywUbWN6+EJvvIyV4JGJ4HpFwI
         1D2fx6UBglJqLZD2vnZ4dwm3gP5HxnBu+4AZbrX6MUHphBjEXK/jrHx0UT3xUFhUpz3p
         C0sA==
X-Forwarded-Encrypted: i=1; AJvYcCVGgBkiww/TqXqMj0Vo81Rz56/C2FxpLw9z5oyWPMV/FkvD8vn9z4OkUk4uVdJdxF1/GS5Ql/zw4g==@kvack.org
X-Gm-Message-State: AOJu0Yx6dMVhdFxpDZWzdLdMkcrB+ld7j74ZdeT0vazOuWOdbDeQK1MF
	Ucp+DMD37pUxjqSZnAHmuViWZxGIkJis2PMweOiYqfIv4RLo8aiblKnBH1wTbEqfRMqRPlkWRpm
	c1Nwe0xQg6Y5YwnCIP3C8Iu0nlswx2esq0lOTz8Xv
X-Gm-Gg: AY/fxX4UCwL7NTeS66KX2Y9gstb0R/styT1bKxD+AFIUyezu3jg+J8mf4evLARouCNL
	iQIAoMDZvCu+Fy0JGrAdFUodg+ucylJ8+jqgoBOYvdS4KOM5lj1+qfF3Hq2hIw7Z0BQcf9d2cpZ
	qj4wuVmfJfjP6FP7UdJAXxDlBwqd51ovxPCmorBJg5s4E3MHIrbVoBJGSgQu4nvRAQR1twCvfTe
	+rZcBMWjZl9HYF6Eo/qzD53/4kt7/L5vXCiLC4UqUW9k+fjAI+HacIevToFN2rS4jyixA==
X-Received: by 2002:a05:622a:1999:b0:4ff:c109:6a4 with SMTP id
 d75a77b69052e-502af961d0emr427261cf.4.1768588226665; Fri, 16 Jan 2026
 10:30:26 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpEQZMVCz0WUQ9SOP6TBKxaT3ajpHi24Aqdd73RCsmi8rg@mail.gmail.com>
 <20260116021835.71770-1-sj@kernel.org>
In-Reply-To: <20260116021835.71770-1-sj@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 10:30:14 -0800
X-Gm-Features: AZwV_Qijfm4QX7A8EtjaARaEPudSI5DCWWeSwN_9u_yVlGn-gJw7kPfo1GWvE2U
Message-ID: <CAJuCfpFevUwXxwOrpH3+VOibjJw0rBw3=QL-nqeKreNEky7_Gg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
To: SeongJae Park <sj@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, corbet@lwn.net, ranxiaokai627@163.com, 
	ran.xiaokai@zte.com.cn, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 146588000F
X-Rspam-User: 
X-Stat-Signature: 3nh9p4uxkt9rcjo7tds884a6x7f5h6ae
X-HE-Tag: 1768588227-852613
X-HE-Meta: U2FsdGVkX1+q1wab3VJdfEGynxuwUfQ4jx2/J+QbzeFkjFN8yy26nHB000370Y6zMMmh7JMPlbYJ65C67LxKdH2487T6dsKivIqKsTdJ3hQjJ59O0m/q8t2TYSs3jabWFz1wTpuoT/wtQUGd+OwO9aRAFm6jugDfE+HYCd0cy3+M6I8LYg1kT0cmD6gNWEk84jvr+NDL9VcRkhwwkdHR7KLJtk/WRQz2V6SN4Y8ZpplxDoIH9BxRCaHBL4BP7d3Of62mNl0zub0z8gy4CtsKIhd9XOmFR5JpyTBV66lzttUR3iDoaXQl10cSr/nEm64ljxmrzmc6ovzDST9YygsuLpSx+T+B0WYmP3p6ys+vPiRKlU0E0Xen6Rem62agLlNuG9L2XvjeyET9gFkgrNdObYQOMg8Es29BInSyzZrM4ug20MQ2LRdww4X1n8wSbiOmkvQxwIw8mIfL5i40VlRiZXDALYWWHh9cteQhnS1zEL2v1fUY1mJSV1UgP86Uj2FrUV8s7qVSniuxlmRq8XD2QXgQSAJ1T1JAXBJm5P3qDW4UbNd7EdCNiQPuQGzPiW6Se2vT6abCQReo+L5CwuRDEDGJXGffiZZZ+zaLNIhmNM1JwyZ9j7zewpTI8BrHDjSrgesa3aiON11oGaaXuiz2n1J3OTf6x78gjadIaIfEmqBq/qs5+RmltFa03qjRBGAQ482/2tsKmby26Kc897/SJ0iqd9Fy0oDXxbDqCmJjnDPXyG65X3tU8xvkCnUkPyQPhdNzxTZw/5XUb2Tcc5CpRPh9eCcW5jBF1+c4/iPwpuw+sU0rU0teXKlDC0RAFjGOdDtKZRqZlmNcnlHb8vkNI6/ckL7rv1PtpyW3M+os07OX2lxTBmMLWWLJWhPLi1ZtGrnkBQZr4yic/vdE4t0UCXkAPjGLgiOsUZLAsMkcxAk1XSi86cDtXU27d3LUM3M32/5aGWTAX76vVd6qU+U
 RHKQP8hJ
 sADbtmcf0563UVJNVDwVPurJCLPbs9WSE9ji56Dc1cI6WQSoBAgi8ImSUsQp8NFlQM6vLKnDWsgdW/5GfVCgzV+RGJf7vF3tkSxoD1LzIAJNmI0NecdhrO2qN11ZCJBrQ6jNyqSgMZ+1/6ULxdaHryhc05CC46/bc1ECiedYzPx+mAccssCfST+eTcCIvBjLjRdT5puAjxKdIUPho1dd97nrZaDWsbO5yITvquZGyZu0fOSjZu81BcC1UaRmCXovhfrDu0Q4bWUdSQZXbRNNVmKgQViscNUbQueYNatw/J/hOakJbh2KS9QToNRZUZH86QQKliR1G6ChcNtHduuv7/4Yu2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:18=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Thu, 15 Jan 2026 09:05:25 -0800 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > On Wed, Jan 14, 2026 at 9:57=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Wed, Jan 14, 2026 at 09:45:57PM -0800, Suren Baghdasaryan wrote:
> > > > +  warnings produces by allocations made while profiling is disable=
d and freed
> > >
> > > "produced"
> >
> > Thanks! I'll wait for a day and if there are no other objections, I
> > will post a fixed version.
>
> Assuming Matthiew's good finding will be fixed,
>
> Acked-by: SeongJae Park <sj@kernel.org>

Thanks!

>
> Fwiw, the typo is also on the .../sysctl/vm.rst part.

Correct, I'll fix in both places.

> And from the finding, I
> was wondering if it is better to put the description only one of two docu=
ments
> rather than having the duplication, and further if the 'Usage:' part of
> allocation-profiling.rst is better to be moved to
> 'Documentation/admin-guide/mm/'.  But I ended up thinking those are too t=
rivial
> and small things.

Yes, I didn't want to complicate reader's life by adding a reference
for a couple of sentences.

>
>
> Thanks,
> SJ

