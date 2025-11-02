Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB1BCCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E991A8E0005; Sun,  2 Nov 2025 12:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70AC8E0002; Sun,  2 Nov 2025 12:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACF98E0005; Sun,  2 Nov 2025 12:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB5818E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:50:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63DAD12BD91
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:50:04 +0000 (UTC)
X-FDA: 84066405528.16.5EF0DAE
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 828B0C0005
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:50:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BnWuvBez;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of groeck@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=groeck@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762105802; a=rsa-sha256;
	cv=none;
	b=kLOWGh1qBVD7IT9AUP64zqhvsKFITGM+CNX2ZYGb4a3ao6Ef9Tj1nxVb4O/gyvuII65WpD
	0guemMngdGla6nTEn59Xc1/egzVw9O4yJDJOxcohYbD7leAESBanX7FhoEXmhjKCWLcL+8
	SnIyKF59bFnK25Lj9sxaSIT01om5hkA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BnWuvBez;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of groeck@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=groeck@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762105802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eQOuzyVymqrjJN7nLk0xcoaAwNBEOp8HsZ+4tadSh8=;
	b=CQtE0C3Eiaj7wBlpHPUHo0Qv5d3aToVvhfEqV+uLUIG5ppn943ZGEsCwGfyYrSdlO3nQC7
	i/zwYWC/t4a/8/2ZlignqbFdWIXm6rl8msobWQeQK1cX+xfKWme+SfLP+KiA/cXwBZgiff
	/9IgGs4Dhc3ZnKhoTzGigijDizzwbE0=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2959197b68eso119115ad.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 09:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762105801; x=1762710601; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eQOuzyVymqrjJN7nLk0xcoaAwNBEOp8HsZ+4tadSh8=;
        b=BnWuvBezTbNqT4Vx2RN88qo+reAa40rszC9WjByLb+WD3cf+Kx8FzSOpij2ap5wdMa
         P12dHjKwmRICMzx5JxZwpGWHTim+vw4Sq+Gxyvk7/lDHdWJSP9oQ24TVdhPrKZ67Bg9l
         V+rfauvHf+8KeJNKkLJkGNm1LYGVIEq6Y8GIjScIG/42FD7SCkJU2A80UZljP76VgGQf
         ZycI6RnehmbA4Vwu7e4P+W63ygLHkRRTBRFpGNlYeFNYPSWJ3LuuYjkQgvkEDRIjw97r
         BGspvlU05oRK7gGrsxVse54CZAdFJxdNasstVD3QU96L1fmrGjRqd+X1N66+Vvbf8ZaS
         oLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762105801; x=1762710601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/eQOuzyVymqrjJN7nLk0xcoaAwNBEOp8HsZ+4tadSh8=;
        b=BtfsMW8yJi8bZyY5BA5ARiy6NQ0+9yEta1fGnhFXz5uKNfMd/u8b7KzPiZMOcBPaUO
         l4Dmay7QNeLGzJ5FtdYYXz+3aqHud8gGHmQEUOPOc046ssT2SBDsWHTjeliR4GL8SM2w
         rQH0WMjV3awZnKEQvb8TWmIVtgvlZK+iEiKkj7Hv9aE40L6+/rVF0yiRcHJiWBKRSXlC
         4jYlR8zGFdA0hVcQM/b56to0bqS1KDFSti+tHsBsRP97CwwLaa3Nh/fpvF2hfzTloR4h
         VcMzGBQ9xs1qGMqip7vM/W0Ic6k4vieZtKTIB54kU80Xpc0MLqiRUYi4FJ8J/eQDq3f6
         qsrg==
X-Forwarded-Encrypted: i=1; AJvYcCUJVVYxQxYdfIGVMzIYWwg7+xK3arYpMoNaOCIWc8kDQHe6DIIhbAmGL+F08ii5ztUsO/uJ2QrV6Q==@kvack.org
X-Gm-Message-State: AOJu0YxwpxImRhisYuCw6620KWxfCq10UOwPFTmwFH0NNGKWeA1eTezH
	UXe99AgC2LOHuvOUtWZ/I3zmv207jZAWK2tYYxBcuJwvIgMdexmP1nJF46lKkNzRfk/oppiDJ7p
	nc2iDyKfI9liektYirj8v67uFeBNY6kHel+rEdCMB
X-Gm-Gg: ASbGncs53OEP1GwB75jwbzZ9EDFzN8U8tHFPM5q1XO0iKjBi12tQh+ROzAMv+Djebi0
	7aQnRJqx2CBDPM3S8A2nb7t1DulkJtJbr/WCWq4NnqkFVHu2bWzzzWT4rz5vP4W3Sm0wEYorv0b
	H4Jq9ZQkWU3g1bphZYVGW48WeMq1zOJ0bsPAcM/aDcOe6a/wU3RoXtCE6p+olHJMeoQRysqOJA1
	EyrzgITjDy932ZXi5jB9oOddn23ouYb7sp7cyPQbgMT8UwtyQZQuIWaT3LfmX6Xo0plrNQWIx2l
	4XeRx6mNVi5uywhsm+0=
X-Google-Smtp-Source: AGHT+IEAICGtm6NZwDsByzAJ38ijLdVal4l1vq6PUUUbo88S4qCmpEjKeMXQGMqibYfiyxUc7Vr67BHJv3oovdCQ47I=
X-Received: by 2002:a17:902:cec3:b0:265:e66:6c10 with SMTP id
 d9443c01a7336-29554acb52dmr5165755ad.4.1762105801057; Sun, 02 Nov 2025
 09:50:01 -0800 (PST)
MIME-Version: 1.0
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com> <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com> <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
In-Reply-To: <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
From: Guenter Roeck <groeck@google.com>
Date: Sun, 2 Nov 2025 09:49:50 -0800
X-Gm-Features: AWmQ_bltYJ86Q3HtfXxhBr-_kg1IjduAALHrq3mVP45Prvfz_NGkLOMlSeQlc50
Message-ID: <CABXOdTeOU0qeSicdDU6DjNHWpzCEhK-66kTdwWjb3M+=Xr3aMQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when rodata=full
To: Ryan Roberts <linux@roeck-us.net>
Cc: Yang Shi <yang@os.amperecomputing.com>, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ardb@kernel.org, dev.jain@arm.com, scott@os.amperecomputing.com, 
	cl@gentwo.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nd@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mhigp8x3a3ukjeuj5n37gezpw9n9wcda
X-Rspamd-Queue-Id: 828B0C0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762105802-5497
X-HE-Meta: U2FsdGVkX19+skNGVgbZR7nAUnmDSTJOo8Tuqowyh8BX0RHUKWLdSr95Cq2VCX3AL3e7ejX16CUbDAtHDcxcegMPethTr0iTZpWS8D45PdCfj/o/dPI8uDYcX5zz1QOsAxaxBRaeSZzZjKi/plM4qmN9onG7DZRmSQz1Rkm1dO2xSim7WOfcmJFsW0NP9XZytejvqs8zbPU55ehvx4IOzaoifhOv+yxXneJr7rKj0naSedh79SyhahWIJFW4cVQBW7ENN0CD2GPnohyl1KvyZM1c9pIJCPIyWYgmd2945mqm7EGWREibP8eMObOqzVlHWq57krgyJYdwYXhDc1meVbgtRc1l0K+izrj7FgaUUG7qPL7mu0HNbfQBqade8z3gNrqDDAQEk7kUiHdEZJxFfzpotW0KvDWVtshaEkOqIGi0p7arcf8n6QOVNHCVqfdE62Vp0LVhAIJArKAaEV1Ar8BMVUMoDXWGVrzC8JIvKCHqJh/U5yP1Prg9ZvErYw2DZIsG4udRv9JOnPwSAUKWsSwZ2t+LDOXCEz1GZtAalBMLva7HXuL3J6yhoRahqqi3TmsSIxUQq1TBPHTw0kKoaHTcsC4gp5SUdm/MxOFW8QLK+BZrY2ewVGhKsiFDE10cJvk+HKz94txijeEIJ5Mtttj4SHte5YHMp5BAIGjSN6DvRhwUHfy0euEOjI6k0lIx7oUBDGcHJiYQ5J/MO9T6mQPjUJPJh57xj7lQngG4yKK1WytD1VH3UILivntKR5Doz2545oqKwbOnf8W8q6gdhyfadAJkTfcvFusUK7pNe+QsVv8tq/ChKb4w6Jepi/ZVCgPjxauruVedfpaVbLztFvW6RDarF4Vl7s8lBLL30PUvWUWWhJTIWfo3Sg4pqFtoB4b8eHFjjinNUmsD1fUnR13BcYogOALsH/g9Y7KDIQbfbRDLLHtGrJUmQxZHv451Yy6JxtcSpDzxtw9EDKt
 4XNRdpGO
 4JH9UujenP42AGJuheMYpkb2cmIVvoxybE6aJYLtOUBzqbXbDly0mU4BW20bB5UByjvOaD1zRdDN8i0tx8bPEwPjOUzipdJQ/ESND1kRLkEf6LuehQ4yu92Hx16afEg0wurGzyDn8QcE3Zhvso46xymsyzbnp3hyGch2dwMTMAIC9G5YJQ0hjhzMaO+60P6yTk4UQDoOC9F9s42+XfF1rjIj57V53Jgy1Nn7KK4+HT9mYfuIKVgbfYlJpH9/dM4xV6N5AUsqZokKOwxFuuLPEDdIyvTRY7brtAamxahcilcQVrgTkmdv70NA0LT4i/UDiR5qwhNRKG6LyGzorMZBvX8UHkFwt7lqyS7SENe3lzjWoIhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 7:09=E2=80=AFAM Ryan Roberts <linux@roeck-us.net> wr=
ote:
...
> commit 602ec2db74e5abfb058bd03934475ead8558eb72
> Author: Ryan Roberts <ryan.roberts@arm.com>
> Date:   Sun Nov 2 11:45:18 2025 +0000
>
>     arm64: mm: Don't attempt to split known pte-mapped regions
>
>     It has been reported that split_kernel_leaf_mapping() is trying to sl=
eep
>     in non-sleepable context. It does this when acquiring the
>     pgtable_split_lock mutex, when either CONFIG_DEBUG_ALLOC or
>     CONFIG_KFENCE are enabled, which change linear map permissions within
>     softirq context during memory allocation and/or freeing.
>
>     But it turns out that the memory for which these features may attempt=
 to
>     modify the permissions is always mapped by pte, so there is no need t=
o
>     attempt to split the mapping. So let's exit early in these cases and
>     avoid attempting to take the mutex.
>
>     Closes: https://lore.kernel.org/all/f24b9032-0ec9-47b1-8b95-c0eeac7a3=
1c5@roeck-us.net/
>     Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rod=
ata=3Dfull")
>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Tested-by: Guenter Roeck <groeck@google.com>

Thanks a lot for the quick turnaround!

Guenter

