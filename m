Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB24CCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2509B8E000C; Fri,  3 Oct 2025 12:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201998E0005; Fri,  3 Oct 2025 12:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0A88E000C; Fri,  3 Oct 2025 12:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F10228E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:19:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 872905B959
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:19:16 +0000 (UTC)
X-FDA: 83957312712.29.F060E52
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3ABCE100011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:19:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VCmV0uRU;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759508354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUV2nFW37hZ6zqfgIp9TiMcltnTLwNF5HDwWy7gizic=;
	b=uzqxWM0rRie1/NHFvh8u4TZda0+p1Wc+Z/FwFy1jO7qH12xd4ruiJ26MFhhJ7D5PHyYrbX
	wi8KT6VVg6NaaaEJ3bq3XEQ8844U0Gmtj3KPRqVa6p03+zcK+Hk+sBaisv35XLdkHha0ea
	6GOCvsMJ9810Cn83F9bj/OhULarPtWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759508354; a=rsa-sha256;
	cv=none;
	b=ihtK73+OwgIcURubGIa+UMzjHB2zK7UFG4mVD0X/vHxRLh2pFokhiBstHLjY6KIral9ISv
	HGpobb8MOOrBjNZy9CYAYptEzRIC0Bmyi3qRA0GzjmhLvxGKBhovMIoM51MIOoQp7aHco7
	Leo+2a6QHPK5Pu9rDPQjQ67CEsSyFSU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VCmV0uRU;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b456d2dc440so386366866b.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759508352; x=1760113152; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fUV2nFW37hZ6zqfgIp9TiMcltnTLwNF5HDwWy7gizic=;
        b=VCmV0uRUb3bEl27e8z8nFIKNUYF2o6P/ruhZuTU05JaTyfbrKDAwY2kFqrYusAfoVe
         NsDaEfXV4UvzmwmUk0kSKclAqu19Q3Kdoxhgb8jezws7AAQhMu6Fz+ONdECp4DtHTtB2
         xhHWhQ4ZJqJGeBtAgdV0Nz7NrcR/+FPOLpisE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759508352; x=1760113152;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUV2nFW37hZ6zqfgIp9TiMcltnTLwNF5HDwWy7gizic=;
        b=SYibrS7nnjufMoEAa9jjgYEPH/88FEYXaHXNoqtymfxby+xsV1WPMXDj7JQeSmYIf5
         YZJcvpmdbaLGwH6Lp83Yzpq9LsAQMX1Ysb/O2LcsrPdbO5uFGJfDZc+T5PFj2P8dGhhx
         um5QIUhLnStkRKjU73oPFHxt2eu/fpxz/i3ZIILouJ/MihIQjCTmps77obPB9QxITjuf
         0XqF4kOagXt+X8oPuOFUuaACjXEKqgukFbBR4EDLMZAgaYi6i5j9xFOoJDkep0JTVzlP
         wGXthHS2CshDLB6DWar3biZm/veCggSEHtL2wbxPCG2lNBeCHsb1D2RZEvq/ixgRG0S/
         IKGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLCFV1/In86uzupKzsAUwiFYbkTUldXeZ3lM8YuzkKwJNeN06IXAQnLfNyCoy2rWZwSlgTOISLaQ==@kvack.org
X-Gm-Message-State: AOJu0YwyI/FidCwEC9J25KKJZKOAw/h00Ic4Wrf7huIR6DL1+HMb0GyY
	sWogBij1o1RIpx/LlKJbhSStJAYvHP/m2na9qisxaCl5q9xZngqQ3aYTLNVfb0VfDFHgvHwmp4F
	+hfCqbPQ=
X-Gm-Gg: ASbGncvUuOzNIoF44wuST32zhYkyJSuS+dQ+NkdXc/71B5f5j9NS8tYotNLPiD1tB7k
	XV36oajOwpkcY5nxCwzVosu5NzEtqWi+yxW9bbNeEiqCx5nOceay4ZzS7QbZSxASB6z2pGtjOBi
	EL7v+yOvFp26pSBU6hIiIsEzznTnkrFHTz92+A+TsNwr3dxwB7RqetFi+2DjVt/+SNukpzEo3gu
	gtAG2weKR+/9x0t4z7HdcH/j7C/sZghJb0ArzCL+lK8xaHFwEZ6fMCK9Km8yELrCCHv3kTQAw24
	y0h1AmwwXo7jc2Jf8Mi5ee19j2rjSDfLWMXRpcG2uaE/jM6kUegOWKsJspfhehpbPHQVqOS1cCC
	1KmW3gkTK8udBg6ZVzjAn74ygB33XpwTu+OBrz0LnCcLVzLcvGPdT7u5PPOvHxrzAYqAlfYQkwb
	F7MvbHTegaWGt1pW61srUW
X-Google-Smtp-Source: AGHT+IFerBL9dpdkBCkddrXob4yi9zYqt2ddX9wdGXe6gp3KODU0/1N9UTHz6oLMratLhgojlZQ1dw==
X-Received: by 2002:a17:907:9408:b0:b3f:33f6:fb57 with SMTP id a640c23a62f3a-b49c12783b3mr435092866b.9.1759508352094;
        Fri, 03 Oct 2025 09:19:12 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4f74esm467775666b.67.2025.10.03.09.19.10
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 09:19:10 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3e25a4bfd5so485062166b.2
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:19:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXFscwsaVG66no8fD+X0ZuemuvyQSzFnSo9P+9Y4u1AYZsaIeTctZWVqS+OTfVNA3rYYFZ9CpAE9g==@kvack.org
X-Received: by 2002:a17:907:7286:b0:b3d:e9be:7ac2 with SMTP id
 a640c23a62f3a-b49c1278127mr425786066b.5.1759508349852; Fri, 03 Oct 2025
 09:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
In-Reply-To: <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Oct 2025 09:18:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
X-Gm-Features: AS18NWDV_Wr0ZuaC3UZb73XNzshbvF6xfGPRkb7B7SRlcIpX-t0bMDfrJbAe05w
Message-ID: <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3ABCE100011
X-Stat-Signature: 8bkjh7ub41km9fh8p73hfjtkzw6xcskz
X-Rspam-User: 
X-HE-Tag: 1759508353-792672
X-HE-Meta: U2FsdGVkX19K/sbpYYDuNqjAit9Ik9pSbCpdquNY5fFS9eEQz+r5b/N5hp6fAnrfQkx4O7KUPGUAx6vMV0gW5xJX26lxszpQtu34lv7tZuvV8iptrSywMu4x4QoYBkfZZzSrKDZEn3MiD8vd5GXgFVR+qZkciwzVC5BC20P2SW4mL89AV3qYTbfpVZDGy68uNWGeos8ZwezSGCBXc4DajM20mzIPPvLR7tn8UIDscJImJ3NSKPNmYrASOvXF6fSKgF6SxbJ19y7H2QIf7z+4jqEmY65PillrtS1O8SSbVRHASm2LNj3/4WLs89cxpkuySpPYTn0mpEghY9o2TYChsVXml/TF3Irr+ifuUYFAlc0QMpNUm94bAEmNxKkxyoWt6NLggqZDFb+slohiGubx3uSXh1KakL566KYXuz8o+PdddqnN1bcKhUEsBdPOg8uRCPqSrfqox5TG0L7PZQpKNKVUdZL9s+b8oCLCD+WgCpXzLbjbSkadO/B0v08vEVYgUgo/mSwPmoKI5pkr3PsG4Cw1BZRfqETJTxgoSUMkOFWz98RfNypUQTnv+k4SrKiUOAp9rOYq7CXqZJFKiN9606c2KlB9JhtMXw8aq3ySkOtt9y/QrbDaBMfm+5eEq5q20OjPXAgIqZd1rvoEVUX0qGJxL5FOHgj2Sx1jlQpWJNieP1POttFKUW4JYfkuxHR7bI61AfXRTrE6VtPqZ329arsXFi6Ee81hh5f+r6HSPwEwitB+MtE/Je90zCFZuslk3PNp5dijDa3TGkgrDD/5EHXZaxXBmvF6Y8eMEMzOMvMF/LYOvluXeVf9j+CNcHOLsUJr/YqReaUpZYrfF165tbCXwbVG/ldtDx4bDwUTxsK5LUDtCjKPoL5jZdxBR6/5bY6nAAB/GqwtuzWofqDiSRoEL+BiUzv27fAeKzfCQcHOsUluZYJpVvuOIOIaEA64B4bWi4FhpD/de3X5712
 as9A659z
 peQTL4iaNlhIy7QQHUnK+Fm5C/gyRh1AaFvvgMViM1OeQhOSpeUm2tgcPZ6Gj05jYzraW7hVKgIuhOHjKzijm7CAuXosc8rvVGu9YRIbRivesrzSPonGxRHTbBHtlU9olNAyzijsPlZJjDRCgTQ0kFOpnHMUNPAvGwqA9VRmB7uT7Z/MRzlJ+SUj9rqmy3lVh8bYny1VCAIQuEXvBF6MxZFba+96REGuCe9uG9BUadvXzuveTrlBDbmbXlUtvJs9D3fjwC5iWCA7bWJ6KIxxzmKY+ID0wnypk20gm5+ybnPE+7F3yVbyRaRMPpWltCH70d9HixPlOWfkrqvambvv5IpLgFP0wDmE+qYo8A5wGGYKHJGAKwZhUS/GoH03BhdXlp08yZcVE6cln0p9anVz35x7rnqPh45WmCvFiM1EY2TSfAX4MJSUgJZ6+UfEpogTDBS5aEV+NNZ+LUduqXyUcjfm8BK55WGSCjApgnM5umHdQqIC7MyqFoka3w+R0E2lalKw4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 at 02:55, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> So, you intentionally bypassing refcount bump on the folio which is part
> of the usual page cache lookup protocol.

Yes. The big cost that Willy reported originally was the cacheline
bouncing of the refcount (due to having tons and tons of very small
reads on the same page in a very threaded load).

My initial reaction was that it was a completely unrealistic
microbenchmark (who would read the same page from  multiple threads at
the same time unless they were just doing some silly benchmark with no
real-world application?), but apparently there are real loads.

> But without the pin, what prevents the folio from being freed and
> reallocated in the same spot under you? Do we wait for a grace period
> somewhere in this reallocation cycle? I don't see it.

That was one of the theories and it might be the right one. There was
some discussion about having a sequence number. It's a long time ago,
I forget.

I had some reason I thought it wasn't an issue, but after all this
time I can't recall.

There's a reason that patch was marked 'Not-yet-signed-off-by' :)

         Linus

