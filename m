Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4172DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A856D6B008A; Fri,  1 Aug 2025 10:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E946B008C; Fri,  1 Aug 2025 10:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BD86B0092; Fri,  1 Aug 2025 10:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8178B6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:59:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03EBE56364
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:59:12 +0000 (UTC)
X-FDA: 83728496586.09.C869395
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 07A771C000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:59:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=VR3YINkw;
	spf=pass (imf20.hostedemail.com: domain of andre.draszik@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=andre.draszik@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754060351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BjNwYs5t/TeS7JMzM3vUjVwMjprEYq9o5942+GXyQg=;
	b=VoMlh/vCxXxyBx5+K8WGna35KPrQnB9LZ6iT6QUoslQ18dfRJjiuhmn/woMXBbyzhJ0BWA
	RHQwDg/sTakClMAAmoAW+ivReKCvcjvZncHl0KdTf3GtHUWfQGlr/MflVQBXPJEbJzbU9c
	/7HqDYn+9trsOp5EMjDN8kDUU0b89gs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=VR3YINkw;
	spf=pass (imf20.hostedemail.com: domain of andre.draszik@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=andre.draszik@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754060351; a=rsa-sha256;
	cv=none;
	b=skvYiQnXB1yz37S35iNm8hMqoIlsGC8E0Vm1TaRuvTFAtL56eB63oUb8+e+8ShPOQDhJvx
	g9eTc81kog5d1QLf5iakgfcX4q+lsZh5oB7OG2K/Z4d/hjHmQSuMccLSMn8X5GabdcIFyC
	FdKgJdBNZvKjq/6oXJJuxm2KL+INRnQ=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4561ca74829so10742215e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754060349; x=1754665149; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4BjNwYs5t/TeS7JMzM3vUjVwMjprEYq9o5942+GXyQg=;
        b=VR3YINkwQYCt082+mIfYaMLtmSS7sY/vx9zuaHE6l7C7CSFyX8nT3QRYXWhJPiMu9R
         xb8JPhFq7VVZX8h/qfHqELu/YaPDFJPjkJOrpXmnteN+03UYza8Cl9wS/JP+UyNhV9dO
         xrkvr5khfhJiwtfFkqZY2dMP7vLmPL70DWjV0sSmu6NtzDwSsxb0p9VDylI69Mtq2BMG
         3Es7QJVYSeRmoYaprglipH7XchtgzoDF1+kRgn9BdJJp/VfuECoYl4J8aPhqJwQSKpaP
         2hEg0ygpxDUJm1oT4VT8i8rWNyVmuNTUgMyGbCork/lMlqlHkWPSdInhBKTqT4p+YBFg
         jvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754060349; x=1754665149;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4BjNwYs5t/TeS7JMzM3vUjVwMjprEYq9o5942+GXyQg=;
        b=BHvompDFEyCFr676nxfVy8uN2YWzX53ISee/UGQ3+4aJw8XJkV/g4N3+PWeYwklYfc
         oy/4++JuHSKkRfkWmML3HPNDx50vamP9DKy1oRjf3xvwRe0l25uO7haAvu8TR2kOs4JP
         aaYtBT8hnHURdd6Ua2mHEmJ9JD1uYJenmmYduLJh9FqHRWEt+7idjUUZGtaNcKmm6NNm
         EdwvWbmXnjx+xdVnzHtNGo0NkcSTIybiXTexJhclUtIlYER7JPXhV6mNqSMQTFZn/qpv
         rsCQFJ0m1GtiZ/mlqYMsHD2z0O6+1APpf7dO5FGIWuzPxeEOzpz3YUnLKMKfNBD/sb1w
         HTZw==
X-Forwarded-Encrypted: i=1; AJvYcCVz3MKLdzgGYtIxPLTYN6RyZzAEaJckgp5Yr5/q74VdEVcgtWYsdVBQ7AFJf/AaEoX20R21jLwI3w==@kvack.org
X-Gm-Message-State: AOJu0YzNUMbxSfWh0tjKAJmV71SbBZyrMTKm5HK5b31XfMVyysmixj0O
	zvas0XSR1Unp4aac9Tk4OnpQVs0wPb0RbjVqj1Q8S3B2f/CLlVTCPPIuhPplgoSHj+g=
X-Gm-Gg: ASbGncuh9jShKl0iUmoDcbXUOl6xrvNVpFw9sierCw/SYGM6kNCMxNQLiZNkydpm8v9
	MS00Pb4G8nZP7Q8QtJKuWCx3pxAIhKCTOuJVmjNhOIStAfGWrrbmd+NB+Mvqn0W9HxXjPyVJwlq
	DiaIvkgcdB4PPENDCGr8VhSAsyFXf6/rJewxgctXNLg2FNHMrdQ5fpPzBjPKXXb3ab19JogN1X8
	UNfPbYglthj/QDJdEywgZc8Zi6QeX60EzEIZD+cF/SRBDNKuNmA3qOmokYprzGwNwHbL8iQfiss
	o/mSFo0MVcCzoK1HyhQZE5T/fKY8VUUp3Y9FDdUeILSZLhC1Mhi5zFJ3uU4VaiH6K0IrsoTog9j
	LN9A55NCDe0MH1WmG7M5OCvv17u3BtRrbZ4Kn
X-Google-Smtp-Source: AGHT+IHFVWbDzd1wxGcMpL06tK3u4JPh9n7RnrlNMdR93I+jSvHQrSHrY2AbiMq2wTWtpQtNYOwDMQ==
X-Received: by 2002:a05:600c:8b65:b0:441:b698:3431 with SMTP id 5b1f17b1804b1-45892bcfaf9mr93121045e9.28.1754060349100;
        Fri, 01 Aug 2025 07:59:09 -0700 (PDT)
Received: from [10.1.1.59] ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a3038121sm67756345e9.1.2025.08.01.07.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:59:08 -0700 (PDT)
Message-ID: <188efc4a8e37bc5dc64dd18989f9a254ef218449.camel@linaro.org>
Subject: Re: [PATCH v2 2/6] futex: Use RCU-based per-CPU reference counting
 instead of rcuref_t
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior
	 <bigeasy@linutronix.de>, linux-kernel@vger.kernel.org
Cc: =?ISO-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>, Darren Hart	
 <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Ingo Molnar	
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra	
 <peterz@infradead.org>, Valentin Schneider <vschneid@redhat.com>, Waiman
 Long	 <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes	 <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport	 <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka	 <vbabka@suse.cz>,
 linux-mm@kvack.org
Date: Fri, 01 Aug 2025 15:59:06 +0100
In-Reply-To: <87ldo5ihu0.ffs@tglx>
References: <87ldo5ihu0.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build2 
MIME-Version: 1.0
X-Stat-Signature: ws7i844ug6ny9gfh611gjm184oq5gozs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07A771C000C
X-Rspam-User: 
X-HE-Tag: 1754060350-90421
X-HE-Meta: U2FsdGVkX1/h1nNCxALbScn9+Z0OMFOx7kMLyZZFAv55NTGnJW+7o2Aw8+UqxtTD7VmbCcCNr1oWIZMUzYqH6/07VqlFJnAbaZMwywKcHIY+ApMMlxImJPktXC+GAW5aYZyXy/an+rjvzXBWgPiOr5BvrJLiTJt/Ew0hru/Wgmnt1Lx8zcm2PJCIGQIaob4sogcPpFs9stZUXHnOdw1UuQR1aP+jQJrlX6QgTYqDOjXiX8DUA+1rSvgYj2ILjS76ycoFdzozVrm4447Swg/OTQw0cAM3mj8rDpwG7ELtYrigc74q1BBzKjcIC8Rr9kyCuz+ATTAG2k1AS+YJR3eew6pcf7SSoaU8J/P5WQjpHdGZeLkUFAB7c13GJ21RLF+NNZmRwEYm9+elGn0S8Tbsfgm2OGBUYw3yqzH2ZMEwxy1cMpZIgUYRrfOD1mPghPJUIafA1ayEl8NZEp+iXzVjHWZS4t4RTm70nXqoPxHMbBfqinpaZF1Dv2iMDX49pTQT0uvWJQ1tE3PkwgbgL2LDF3Nk2/PC2xN3cpnPgAAi1zYqf9JmyLRDlqpT0JfIGgomdNz+fhF18jbJxL66AIiR33/q6DsQTs9KTeUaKA8oJsnrf83vgk/Y/ERmJe0zHGiDRkuSmPlqT5i6QKotv6/YEc8mGW9e9Jy2s3Gw4McJ9mwWJrgsESAurU9MBOTYlaC4p5sDF04Cr85rtDcYx7FXl/Mx1PJI5YYuWp+mFYQPZAa8NJ4UPD5qZGxTfAIpAopqTbq57LSC2s+7ANAPcTgGksFcd0e/K3pl4h9cWXMVtIHi3o+elu//1moziMwF5Fh8rIDXqCJVsB/50u1y8zCaxFnGmFIfpEf6hH0oH9C+dlNvK3UoGIo0VZezFypCKdL2KuuehrQlju2jg4k5QZfK9saQE1vdmL+B9372FYeUMxaqRhJFH+Xdxkbn/E1gj6pJDzu///5e4FZwvu04n/U
 LwGqIFgB
 bJcFbcv71JH5HiIEWdm1fWziVUd3EqZrS8+1DVGPcOMxO88SKzmL9UIqntrLOs0geNBw54Qd3EkoSfHaC+Pi2NQH2SrP1cd3Oz+Y21OrZoXpd7VpT2844h5Mi4TUxi3jKB0o7RJsgj+wyRMwRTVb9zVGSstzNrejYgIKKqKS/yapcdpBcYHAWHJ84X+GODrJTblFDOf+xl/Ib2EYqIuQWjnASlZe2g2tYQndWJaVt5kAKdrvmmeJyvh7q5ErTRXlZcCqdBX1lLNzA6Jj4+3YmBOb+Zw+ae63Yf1ib3CmdK3KTydxLKQ9YEoOK5+gL8PfmtEgaQ5hRXpOLumD73SGuhzFWOvG2qrUczj8i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2025-07-30 at 21:44 +0200, Thomas Gleixner wrote:
> On Wed, Jul 30 2025 at 13:20, Andr=C3=A9 Draszik wrote:
> > kmemleak complains about a new memleak with this commit:
> >=20
> > [=C2=A0 680.179004][=C2=A0 T101] kmemleak: 1 new suspected memory leaks=
 (see /sys/kernel/debug/kmemleak)
> >=20
> > $ cat /sys/kernel/debug/kmemleak
> > unreferenced object (percpu) 0xc22ec0eface8 (size 4):
> > =C2=A0 comm "swapper/0", pid 1, jiffies 4294893115
> > =C2=A0 hex dump (first 4 bytes on cpu 7):
> > =C2=A0=C2=A0=C2=A0 01 00 00 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ....
> > =C2=A0 backtrace (crc b8bc6765):
> > =C2=A0=C2=A0=C2=A0 kmemleak_alloc_percpu+0x48/0xb8
> > =C2=A0=C2=A0=C2=A0 pcpu_alloc_noprof+0x6ac/0xb68
> > =C2=A0=C2=A0=C2=A0 futex_mm_init+0x60/0xe0
> > =C2=A0=C2=A0=C2=A0 mm_init+0x1e8/0x3c0
> > =C2=A0=C2=A0=C2=A0 mm_alloc+0x5c/0x78
> > =C2=A0=C2=A0=C2=A0 init_args+0x74/0x4b0
> > =C2=A0=C2=A0=C2=A0 debug_vm_pgtable+0x60/0x2d8
> >=20
> > Reverting this commit (and patches 3 and 4 in this series due to contex=
t),
> > makes kmemleak happy again.
>=20
> Unsurprisingly ...
>=20
> debug_vm_pgtable() allocates it via mm_alloc() -> mm->init() and then
> after the selftest it invokes mmdrop(), which does not free it, as it is
> only freed in __mmput().
>=20
> The patch below should fix it.

It does. Thanks Thomas!

A.

