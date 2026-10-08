Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DFBCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 13:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945106B008A; Thu,  8 Oct 2026 09:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F58E6B008C; Thu,  8 Oct 2026 09:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BB16B0092; Thu,  8 Oct 2026 09:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 535FB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:44:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A81E7140280
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:44:29 +0000 (UTC)
X-FDA: 85299578658.27.33EF6A2
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id E02E12000B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:44:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ApFXPy7Q;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791467067;
	b=KL3dLA/aWvKf1yeDHO7pqaLxW04Q85AbOH5pK+FI0UetuYXN7+7U3KIIiG69gvDa3uy36d
	TMDdRMUeRpZFxomPumHgESrGUUmiY++j1yXP5QHUJm3DU59hBWFsoQr60JNSFL6qW9T+ce
	it7qbLWCSevibZPmrOCz7Dj3G3ucXiE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ApFXPy7Q;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791467067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4rMUcFNA7Kug8b24L/ljfYv2etiGrFoCHCGWctjsHo=;
	b=kDuzLM9Pr1X6UoH2OYLzbMTls1EC/MlLWMHhoTo7gm+3MFQAD8FVEsZlIU4/C/ngzKTlK8
	p6jnvcQ6cnDDuqlGjPDnlvHb5sOxP1lkTPSeU4gKLo+WGNRSJLYwwuDHPtRhirekcnDtyd
	zf9ErulERdsqpHDNMaipWXYMzCFChNI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e831e86ebfso600265ad.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 06:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791467067; x=1792071867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4rMUcFNA7Kug8b24L/ljfYv2etiGrFoCHCGWctjsHo=;
        b=ApFXPy7Q6IYJ4MSWoT7hOYG1j+LCkhRz7DLW4Ptkog2ASHbZflpVID3sBQ7rjBO8yr
         gL4ngt30OhjZeAAKt5zT6jDIMCs5RqTgkIDBp4J1qUFlgQ7M4bKBnMwxYLAwNHgW1oqv
         qmEmmR+AVHb11gSrjlImmXUEkaTD6oRcv/0GdaO5/itkUWImHKIMnW/QxapliJjcCSwh
         rwO9bRQKhjphpadGJ64HuTF7k4TPEScbeoYEXnfmhBmF+/bIlCQn9O0zSk4ImQU2pDRl
         0bXZHIGBW44X2GkmHLhhypMzIb1PfJx/7tm1L/GuVVtH79ItupYr0RsFIrruGlh+Urgj
         uk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791467067; x=1792071867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M4rMUcFNA7Kug8b24L/ljfYv2etiGrFoCHCGWctjsHo=;
        b=XlgMggJU031rv2bO/nTIz6iIzlbCxdQmICAPelXbEXTTYBuYzBCl7cn+x5J/heGLik
         D9ZwuxwhUCDT/TdWqjpDg0enaobhqey9Vws3rzpUdDlZIj/9xq2xG/UKy3in5LL8BaNj
         3nSeLIi+TDLxX3HGkk2KFSC2cCY3atrwAm/Y+BFlhsx510vFkl1UG+s99h9ak92858Lh
         F1dR6Es5uo3GWXiwHfLPu8K9E0YoHFAmh4nk5cHZx5pWIJA1Jlsz2pe+seG+mzCjGCAV
         o0JqvvBnQu9kE2m9pOUAQCkIQrMyO/mJFnQJZdr9oUwM4xRV1yyR00AkRuFmvIoVlWXq
         LSVg==
X-Forwarded-Encrypted: i=1; AKwUvBwjUsDBE4zsW7LR6PBxL2+vRJX6KOfjgChwgsWIU3grVV1EkP5DMPEH4Vjr78yqwr7oqiWinJVlwg==@kvack.org
X-Gm-Message-State: AFq9FYKI9ucJOfZNetnHvFsKLczTAw9oCjxuArYnI3iHwq2JCKRnHGri
	dRtQtm8RFDbQX0i9ZaAWBqyF1FTsTJH4pS8T7wXpFlfkEsu5UQDQEWFf
X-Gm-Gg: AYBFou2to9UBNCpJ3hEnaX1bykqakNdlyYdm10O02V8f2AUPt5fQnohvkSHZpvCAL/r
	2jFPcFHwbNmGxyH4q00H0KUAJ4oiq5FRfVzkw/5ao7Kpw7i7UHI2/vD3I3oXfdbBYV6QIJtDvXw
	SK3CseyPydHXj4lgjbaHo0hVoGTmjnY+7Qn6esu2zfqD0W4zQTVZdHn9JXigXu1aDMT6Dc7cB4M
	sWhnTmB2M3mC3ks8x6t0vdOY8XKZ9+Xx7I7sQjeuHHdX7X137RmiqvG25H5Ic1wnUdKHCRnW4bd
	CDEXLAO7iIEa1Ak9DOKIj7pOnv+ZIcFKzZOj/uYwh72NAeLjzZnz4KIf6BodrlRK63An8B2un+v
	abKZLgbYtYX/fYQPGlfiLmuQWfAyQnxzeCZNUuous+BbprHKWIVtLZhaxGPLbTS2YiUB9jDZ72l
	hr+P0OmZDxrPwQCWh4gNrxx00VP5oZfYX0M9zq3VT+q9kL+waoualq+COe9wPQTuMltCBF5yHEy
	mt7cJW24BBpxbTfylTC5fiboQ==
X-Received: by 2002:a17:903:1a6f:b0:2dd:ad74:ac2c with SMTP id d9443c01a7336-2e6004e3b3amr50094555ad.30.1791467066545;
        Thu, 08 Oct 2026 06:44:26 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:d08:1334:29ed:db11:2c4c:ee4f:606])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604720215sm25363195ad.34.2026.10.08.06.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:44:26 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Thu,  8 Oct 2026 21:44:19 +0800
Message-ID: <20261008134442.31243-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261008123231.45171-1-sj@kernel.org>
References: <20261008123231.45171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E02E12000B
X-Rspam-User: 
X-Stat-Signature: b5ge33fe85otwnrj81uogysyr6xxgjue
X-HE-Tag: 1791467067-442586
X-HE-Meta: U2FsdGVkX1/O7NIbnvn9cNqcrLVEnSKphzMY/PtLBC9BSy7xI37kbdMu7wrBVQXOArnL0Y8nVWg/JIW67wdK4FU+5bQovR8GOm8TjKXSbMyDF0SIpQdi3IMyj/rGpvmq2wnno3LkQGwyfHET0h4GZHRu0a9uB5PPxsT1PDOwByNflRBNo4y/z3pgF5W+EfCNOrL1bcN/XImTrPFO6tEk9myYKS0Zhp+wYaZrrv6AD8YSxK6XvtWtStvpdhoSyylxyeLMjUmRVSulAFVYWtbya5JLn5M/ZE261STOICU9ImAA05hotazTnGbUtTcpWWDBjPfk8HTaWHeh17l/1JBZHQmUyctoPNRKxyZ/ym/t5x0JI5h0I9cAzA25fU+86NgokmcQrD7xtnLT845+fZ2f6GQF6ll3GwK4peGBVKRPvfmNgYXJag7cZVrwDsrMAomW+HIvIapeuMsaIErqZ+ptlTN6cXnVi+uIlccDiwo83GHI45+OC0+15yiXgLO9CpXa6Yf9/+aqC0ZxdtDSSQOEo8TteQSAkqd9D85UjYtIrT7sCp/tBxs2abseTUTt2YxMdeJjLAlfEVoclrqZmHXZiNBXPaeFF0gl0xCdDc1DlNLlO5tPbyHZl/YRj7EoNsWPlNVxNUK9K2LbhYgpuKJSoUYIcunRYxUXBu8zK5pyewAyhAKf0sIkrDrS2iM+RoPcYj0jeU8Z32CtlG/fHYT+VHzihdhcS8xjXGdteFQHo4vey7LO+Ks6Py1eQO/HY7THPCKdu7a1sen+UpYwHEpVcz6th9PJXzPwHKh+w+bqGjliyq7/PuV6TGq3VAFO5L5mIO3b37YYU7lTrcv3KBsxY3zSOAwyBoYM2bTmlQVEHgFSNSOn7uE2KhzN0+Hum4U1bQ9yk4O13KBWDcqHL9uMXfMyjpBMiJfQQFFCI0vsgy47HZQQxdEVp8gaFF+ACoqtJ65Il+Kkt9ntx9Xeokb
 lEVZyBzG
 2KnitvrpcB/GWH6O2nK9jJOQUcDBr80W+Q9yMUrRgSrfwLXGyfZcVtN4Ozic3Nzs2UOZ9aNaoUAPmhR4/UoMfOt34FAlhYAhrNdPSwnYnlI7H+wcCQoAcnbG0h8CVmLlrfnV15TX3RiJw6gAM/lwsfZ/g3mVj3lB3yQbG66bKwT9NoY4VfM3U5ZPFxQYvCRlrswaAmtln5WHBFW1hLocQvHJfLdismvy5G/0CWt57iXqIVagn2F/lAUAu/+CaPBzfyjjFYxavJ1f01/u9xSULdEBewIFEtYroGm8hxKN2QPgPEmA31yKx1bhOnoLLQypfl1hAhCq2bNjPQTtiJVE+cuwEq7w2r1RPGTbZnvvPJMDNBcutTBOWR/ynDZY67VS9MjyqnDGj/g1gxX9m8rInNuTEFhK0XVkmmWOYuPt7BgcIO/ie6q11aKTsyNcgigg9TRpZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Oct 2026 05:32:31 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SJ,
> > 
> > Just a reminder, I think you might have missed the question I asked.
> 
> Could you please clarify what is the question that is not yet answered?

It seems I forgot to ask the question, my apologies.

I would like to ask: after reviewing the reproduction, do you still
think this is a real issue?  If so, I will start working on a fix.

[...]

Best regards,
Rui Yan

