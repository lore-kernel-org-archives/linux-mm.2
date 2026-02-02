Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEFAE7FDE0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 21:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8BB6B0005; Mon,  2 Feb 2026 16:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566906B0088; Mon,  2 Feb 2026 16:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4476E6B0089; Mon,  2 Feb 2026 16:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 357416B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:49:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2A761602B9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:49:04 +0000 (UTC)
X-FDA: 84400857408.11.FBC8DAB
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A6B540002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:49:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AFXrGoLX;
	spf=pass (imf04.hostedemail.com: domain of 3zRuBaQ4KCFwDIL74HLC6B4L7MAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3zRuBaQ4KCFwDIL74HLC6B4L7MAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770068943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGd6G1Vb/3CvX2kkVP9M1fJHJsx1i2LSzEHZHyKjpyk=;
	b=cx+mu2mAOeuJfZvoOMDQz9mBpPSJ/+FSVpBqe2alc9xLkfE6A5N4GM9PRUijbICPoZdwPH
	M0eu//3R0ak8TObbTACr4tygncjatm4iDIi+01AHzIdyn4er49ukTWiivJOy3QX1XIwsdQ
	w6Ex2FKuEc0qxppqm+nWzi/4kx0JI5E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AFXrGoLX;
	spf=pass (imf04.hostedemail.com: domain of 3zRuBaQ4KCFwDIL74HLC6B4L7MAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3zRuBaQ4KCFwDIL74HLC6B4L7MAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770068943; a=rsa-sha256;
	cv=none;
	b=AKXSD4qKb0rRQYn4kwX/aZSYDWxbWmRdM6zvfoZ5AW5QQI7pXoHQE1ZJ6P8h+sg3GxnyvB
	3qHiqSduzvlQM3oy/Qe+ZI341u1SozcPwKjQAJr3rBgb8goHuUETPmZLtwFYfg8iQXklTz
	Jlb5v7Yqj3ylo6pKFM7fIBPa/ROTkyU=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b7ef896edcso9011665eec.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 13:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770068942; x=1770673742; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CGd6G1Vb/3CvX2kkVP9M1fJHJsx1i2LSzEHZHyKjpyk=;
        b=AFXrGoLXIkuixvfmd0FccQdUiyr06JooPs2uUdFn1+ocT8QMsreotDyhojCaKdY3GO
         M8oSmoWwTJ0ownT8cn/U8aaa8LENDnjZoQ//1eohRoKMi80Q8/H6wC7g0oIOjKP4ISRD
         P0j9yj88wFsdNwe/vFw80MoBNliGvcnwF9bFH2YP3Xk3L9r8jYGOhtuIyfhV0urWRdOk
         lbItTIvGa1VlPhFZx3PbJfePPixLrVRAD7hn7bcRgwTES2Bxc3Yn3uls2ttpaDUiZNcF
         d3ARlQAdYidmOoyG6SnAmbakRTF1q8gNRdtXQ6+zF8bnWmfkb/kvhceX0ILzouMa02d9
         h1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068942; x=1770673742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CGd6G1Vb/3CvX2kkVP9M1fJHJsx1i2LSzEHZHyKjpyk=;
        b=h63mQ+w1PsNe7VJWFuO/upmkjlZP/3t2sMWmwKMWcDQLYXqi5WCAd40Uirfsa1X+Ut
         i5LVd8DlZFe1o4LfzbPL92AwrHCV3jfhrqGkVxrN6FpHnRwJnDMOPTLUO9BRwtdTlcc0
         g2vjc0kEgEy6LzuVwidaQdcgEBTmEEIqec6M6Y9eQjem5gRWMymaSpszm2xYBEhryq/E
         G/7RcZoPFxO+8NYUpEZqBrqOQOyB517gFc0IOuDuJkY11Q4Y2twrz07F5srMQUsJlNs/
         im+ozoa/a9dq5TLfPNWkrwfgUZfw9S2TC5HCFw3j2BipkgT2V2PF4GmrORylg9VKKcs5
         jAdw==
X-Forwarded-Encrypted: i=1; AJvYcCXA2803wkTGBUlv2dyV50bjBJJADfVx4zuC8jmO3tJE6ykATtugCeAN+o5nDaGePZ0dOaLsBzeNJg==@kvack.org
X-Gm-Message-State: AOJu0YwckyyKxm28WQAVl6se+ddmGgBkDYN9cdqn3nWq2CQ0fmVyvQ5O
	ejh6pgUAVjlI4M/kbIzkkXaFSDC2RHRD+s81AawaD+cI+vutF7e4Vp39tsOAar8aVaKAUrRcm5e
	Y3gBhfqdDCBVdbBlpv21DPMtzJlsUMtJjasIrqg==
X-Received: from dybnk15.prod.google.com ([2002:a05:7300:cf0f:b0:2b7:b47b:2f2f])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3d15:b0:2b7:2dac:5853 with SMTP id 5a478bee46e88-2b7c8626756mr5756175eec.2.1770068941732;
 Mon, 02 Feb 2026 13:49:01 -0800 (PST)
Date: Mon,  2 Feb 2026 21:48:59 +0000
In-Reply-To: <aXj28ZAsPhp7s5sm@kernel.org>
Mime-Version: 1.0
References: <aXj28ZAsPhp7s5sm@kernel.org>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202214859.662889-1-jordanrichards@google.com>
Subject: Re: [PATCH] selftests/liveupdate: add end to end test infrastructure
 and scripts
From: Jordan Richards <jordanrichards@google.com>
To: rppt@kernel.org
Cc: dmatlack@google.com, jasonmiu@google.com, jordanrichards@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A6B540002
X-Stat-Signature: scgaadbzi1sjn55s68qbqq3i8ubz6s4e
X-Rspam-User: 
X-HE-Tag: 1770068942-428531
X-HE-Meta: U2FsdGVkX1+RCpmKRnmujk9bXcmYCUT8L3hHtK4D8qpPrOo6lyPI5QBKX1XTXCHMbvhd+v+b3ykZY6ZOHS1Ml698f4M0vAXO89N4CqAeNss1AZHXh7gOIAgvP8EFOTRanRSWEovMIIdBkpKgKrkThnQ1QgWWlQJlWK5MKAfV66nVzWfe98wuRDtftBzeiRH7+oht6TkB8RGrI2ci9d22suTI9DDthQKXpKjcraxgjfCMenZn/NAtYEkEeH1tfixJ7nwhcXmCbnz+HennCSWpzjup4E4SqRT9KeCz7r7znPU59cAkdbNAy6Y3mML8/3w6Y8lNFDT1kwodF9cIuWA9TwgE3AgCW/WUXcr7fUwqDyd2OJsoyHzV0iJu0EQWgrF1YmuDbOQaNtBf0LqiXAt8fGsySTl/U+BS7HNxHugs6KLLg0F/ue8kctXlbVDdgMZPbm+YtAfx9SwRVeCfe2fIaI5dGLDUI7Dvf9XVyg39kQUMa0ZV3UDVTG42efa9Tj2yHNzFkMPAL1kny/k3w/DjOIdJrbi8tbmC/Jcq2Ex7qsqcpENRgemjSbMvhHMOGaEYvVIW3fp/V67zONzBdK2fhsaNUoPE0ASsqjr3sZBtfY8cj+KYWAyLSD48KCV3RvKpk3mAcQsAvkEJS1HzPAJFIWjuS27XFCDaPWtYszMCeaAZiFpEHHdd/naqQHtyNlNn8ydeYA1UulgUIsms60rRAjhaJqAZis0TNYB+2v30OKd7OLkhcKY+2VGiTu671va8XxKXIXFwK1mJ9i99g48Olnih3NT2STYt333GGDBpVwp16npMxES/U+lT5FCguxMtxbEgn78kyH4NKgjVYkiu2Jcl0EqxTDfE1zPi5BhFhOC3EUGXtXmoD16OWi9ralvnk+CpUQJY/K3DoBJ1+osNHgYI5rspknvp1UvUu8vYb4rnA5XArMBsJHyc1+dIQTHYniS04L0o6NwjIOINKNH
 vYE3+WyU
 YujaiWkTo0Oyqr3mKL/HNIzEOYo0C95Nq5Z4DCwbV4cEwKbv1MDJwZ43vpE5Z/PLodxrfchGqYWYFvu8tJsJEIRrEI/iMI9f5toUJYm3Jbs/GOf2NvQneySm5P3k926KtpZqzhNVlC8POnk9jgaT6jYkKbgCxfDdcE8CmRSk0RWM8zwGPopf8XcbR9iUcEi1X6EuN7KMfJiL2+xAhEl7kvT7P0tleHR6Mg+hV3QviVIXlrvuYBhxNLP6PsfroDSy4KhoUJDUoA6zWNU9RC4hLox4zTjQQkeaJLYOgY4HrXnpf4j8btgbSyYOfZ2dc7DPZ9Or+/9q93qOZmOI2eqq4A8yNkOw2iGeFGFOH2vT3A791GQ66/yeS6w9oFgvLeiCg4usSYzQ5m04g92RqsrMoD0PRWna9GCUldmiuWm0UMeHcZAgKX3ybj/NOvEbAPRNZlAgGXbvhoMDhD5gExT2R3lY4vn15LAezEn5bu10D9v9FDnjLYZ2QlcNL6jX4Y+Pl7qI0rI+g8fKpT548WWOmydGhXUJczIw56zPJVWllzMFpKHT9UcAtW0bpIE+RRO26ZR870rXYnaqXXHd1USAOwXsNWLqzSMGiiHjg08Y5UfJIhXD5r+kPm1A3w2S0CB7Ys/epEgDJG9NUfEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for the feedback.

>> +int sys_ftruncate(int fd, off_t length)
>> +{
>> +     return my_syscall2(__NR_ftruncate, fd, length);
>> +}
>> +
>> +int ftruncate(int fd, off_t length)
>> +{
>> +     return __sysret(sys_ftruncate(fd, length));
>> +}
>
> These should be added to nolibc I suppose.

I notice that nolibc has its own tree. If I patch nolibc/sys.h,
will those changes make their way there? Or should I avoid modifying
nolibc/sys.h and keep this local copy for now, to be removed if/when
ftruncate is added to nolibc?

