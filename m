Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B62606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EudTm+OP
Received: by kanga.kvack.org (Postfix)
	id 8506D6B05B4; Thu,  5 Nov 2026 19:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800186B05B5; Thu,  5 Nov 2026 19:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFEF6B05CE; Thu,  5 Nov 2026 19:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47D1D6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:47:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C61041C4739
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:47:28 +0000 (UTC)
X-FDA: 85402855776.20.4191AC9
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA5DE40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:47:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EudTm+OP;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793926046;
	b=b6MWDQWoH3dkqteM50AFamgwjvWp6vsdVL6+Frx/Vxo8i1YCYRA2szyz7lWWwRMQTjfV1p
	TS6KMHP58fuKR4HXrj2iWxZnu3nBntwQoO1tDt6w9GCRPqrgfXQTg2fyIASsbolj1w+2Wt
	3nKuFdh4hbnW9lpLKWVqQ++hJK44Zeo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EudTm+OP;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793926046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/Pn/3oT6XlOFb2SsTcDdo2UH2iFiBAGJC3TZJWHkxg=;
	b=DTh10PafHm3bqY5NyTreRHEay+poZnvkHcuYtPCPoMCh6iwnIMujh71q9ZtkOvVJAQPqQK
	QK9RH4uVBKIT8VCzgF9VADHx7fr2/qLryy53+1LCUWsw0OkzJeLeUdk87ktTSiW6Fe2ERj
	+XoSq0ZBBaW9ZUWYIdWbiRJQZ9B/5dw=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4550d8ab15so12259866b.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:47:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793926045; cv=none;
        d=google.com; s=arc-20260327;
        b=CUMdGAWnAuKIWjh7psM7CeisJgTZZu+wXl8+dabehBBpzwBUW6n5lLq/qjWB1mA65C
         Mc1xx4BHOnjS27k8Fv/EnvbiAZLY+uyKt1CbDv3EAg6s/M2XyDXw81cPpKDvoKBkckWp
         ubKSMnZ2nOJDWTtmXNux/lUhLvWLY2isrYUK87YqJITkauTpJ4j1Yw8+fgrGQyhX2qFj
         7gKa2GCTi5/2HolMDCrAXIMpihvrklU1B8wQTVW5i0sxkPGXu5dVXFjfXEIG0azsCa7Q
         FCxNLzUwhGX/eBMOVqhEoP68yqZbCBqHKVurwR5XaUDhe5Oto9HtXuP0z7Mlhk1PCqS6
         vYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/Pn/3oT6XlOFb2SsTcDdo2UH2iFiBAGJC3TZJWHkxg=;
        fh=SdP3H5NtZLKWI1vvvdexIhkkCmYkEfOeS8OBuOep/DE=;
        b=FyEIscN/oYUbW16hxmRKTTSFrnHI6m3zp6k5Yqo6HuFnniYoKuar1tJ3rzcmYv9uoY
         6wH8WBK+P1Oi9qi1ymgtU3Fg8rwDRxzA52i5aGYBCXShFmKCAcro4SkQOAQgpH0YXdfn
         lVSHiXh6oqkl5AS+aa7/6RM8Rz7SywyzeLfiCPZ1ItBqaMp346EZRyaf9XFVvS87jqDM
         esYO0KCmqklsIoU0JG6p3OP13KX2Q+yNuSeI7MBFF34DGUmMYgVxH6g4m0znVhf493Nd
         25AWGDUDlwoZJUC+UeS2Bo4mth4wF9Niwr9WdRnSPWuN86t4apQjswOQ/+KUxosxmV/7
         dJXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793926045; x=1794530845; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/Pn/3oT6XlOFb2SsTcDdo2UH2iFiBAGJC3TZJWHkxg=;
        b=EudTm+OP7tEcpPyXGebvvz14MFakzoBQdTM0GksJdxKcpFu1gbm7T6mD4A1eLnYrG0
         V5OxfNPxiQt0VItDN4QOSHDghXA8jHdtZKoIgtdKlX78oK1IAa7I4qsHuEKeustS5ceG
         K6q5itGSm1OG/ccEXlVauW0CHbIXnerpjX4BaQXrvzNYXALcCEoxpAo9hYhe26LAxmSI
         OAnFMAX6JHQHP8bG2M4/V2Dq08h1t5benR59KG5Yq1epH6kaUdntd+g1vMn1AhyM9sjX
         VhwzIO5QDAuFuyIk8gV4AzCHFnRK6BKEB4GpvZHAU11Jxa5s+fnWib9qEzCgIXcbKZGP
         7StQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926045; x=1794530845;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/Pn/3oT6XlOFb2SsTcDdo2UH2iFiBAGJC3TZJWHkxg=;
        b=hwIvPB0G6iJeymeGwHwGvXgPbnJndQlKWi8zYroT8V4YAl4pYVIQYSNIMHsmM9ouZT
         5O3IlS5nfc+dFgCBbf4GewkPQyMs24KuUOAw12a8ezt52ZXVUoXBW3iQgL03/dwAgXY6
         MANKRKFKt4rcJhtnagen00YKm5kpNXNXeqtb+YMuD36gkkyod3nm/ZnCbufWo24tz57Y
         OAgLYSeU8/qeJvID/NyaOxtwcuY28vtfMcurR/V9aM5n3yIFTMBoUdM1EcuB4ydqkZsO
         4+3iCvGnYsQgjrjjQCpdUp9TS1FRdWfQhf/qZRTyJpSoaoRtloaHf9NKVSeqTAWr1IXG
         Jygw==
X-Forwarded-Encrypted: i=1; AKwUvBx9SQETK3w77216Phpk4LJMKaEl44fXa8I8MD6m3bhicjoGoT2n7GJdNC670OONB39QzNqmw+EfhA==@kvack.org
X-Gm-Message-State: APuU4Z+2EDv8rypXLhidqGRUlb1+pwdVEW62ZNkvpRQGKMMBKxqSFTUc
	JK3zgDMYiSzXYN8wm7O9idf59qhekU4Qsm67S5xs42BbR9w2B7uyVVyIdXoll7XruyxUAYNOfwg
	ilq8j1fCPb+uDnGvUZmrqCFVNNS6I0BfyZKsWRMdj
X-Gm-Gg: AYBFou34Hk9aRFwR7QD6M9skLlNEVOEj3uPjjpjRMi3ifGu4fIqbgb8eZRAxIsK+QWO
	dNaPX8n91VVyCJtcn1FgRKcw5ZWQAxu1LxWmzIP5jSMHHmY25sPnS/K08VeT1A9N36GJJWlCPZl
	sMr+IeqBf/1tmXArAQzXAPr1vEO3g7jy7hMsFd+MAGDLFZtaasACRD0uwsWLSF6I/6Q4ggU78Zn
	YqWlWFSfi8viqmWskLhUFWjnWb5DTIOTD9TeudzubQSlPbVPe1qAoGhcYqaWNK2wRIlIf5fFiob
	3p+FDDbG5/Izk7ymqVqsjoKZHa2MiQn93pwiJ4l+RysqNKtXzvqf5qnfv7pe7aAqYiUrnxbuQ5D
	2ICkfX/pUnigZM8LqIGBKNhF/54+jMbsSOWR+5w==
X-Received: by 2002:a17:907:8687:b0:c48:a838:c16d with SMTP id
 a640c23a62f3a-c4d34c333bdmr88685166b.30.1793926044754; Thu, 05 Nov 2026
 16:47:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Nov 2026 16:46:58 -0800
X-Gm-Features: AclHuK-6t-LHK5FESHi0261vrVlL_qd-J_ZV2n6hQwmFkPQFVA0JTaSgUA12BTs
Message-ID: <CALzav=dOnBUdYKN8ucD8tMF_5RuQZOzYG2aW=K9Grd5itgvnMw@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] PCI: Index saved capability state by
 configuration space offset
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Cc: Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Lukas Wunner <lukas@wunner.de>, 
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9a9351t617tamezthxyt6qmz1k9ynudf
X-Rspamd-Queue-Id: CA5DE40003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793926046-246690
X-HE-Meta: U2FsdGVkX18aGcpiUXHojCzRvOth2/Hswv6+knSQoxw75/brP9dCm7v44ufflL/+xzk/nSTC132qJ6pVbaZ1C0qSmQTr35t08pErWEDH0k2iFkSgTanQxVrGgtOXyo+l6d1nbL2V6dMuCn5GSYAfgGq01B+vLtSr2wT3t83PqDgUFMtkHKCt3wroDgvZZntNYirbjUBxVkuIL3kAjDU6uUT2LayO+i6Rn8S3PtRfjdiE0MdNxzHS9Ft+llyjlpQe0/+R9RHqF/H4AEZGXRa32amtuyVpATyzPXPg1isnM+InMDjT94u9gG2jyT7WT6EPinNvC810pPlNpLWl5Wz8uJ1998cGecGvIszh/MMt+nz96wy6Lsvr8JHN3KT3DLZ5cMEIa7rJ+gb0ndSY4szLMn4uu9zUhbukk5NUnjWlDk1LOUjMfZ/SACK8e4vBqyoGoGvqlZ8lXwAyByA6eDz8RhT91kwjXw6EqUzJD8ojX3ggsISEDaiBfBZSXLHO0vyAjDumMmg8DZPQbvV2CAI/0D2zVKvrT46c924VMLGy6Zc3ON0U9ZsHCUTLcodxZjqMexqZLtAk3J7GKl+0pBSyb5wbthTgqGzvZ6R4HDG/EcjZ4yzIRQNmhE5wL5Cca9jZnVSXTdY0UfVWpSwYiVjzNfMxGUMj4P9CzY7hujvUe1L8Zi2yaVsDr4XlJa4M0moP+RXifmce+PwuNiaTw60AuxKxT4TBfC5W4qANX3zdZtERGUqsY7Iy2f6wDTICNAzzxkfEMY1QeWbxBPt7PM2jZ0sFYh1Knqf1p1FUFYQFxbsZutJV/hb+Hlr9mCsovQR+xJH2FsA+UVETb40u5AGKFhOeeVFER14DJW20nCuiDg5li38NxZDHwEHyELvfbp8kfP+dqOiceZBOZoe2KqFjfYQY3/KEhtAFUnEKFlF83Pvu21bKEj4L8ruIV/6ryXtc6qsSF9IU36Txm5bd4l2
 tEZ2Nybx
 N7I1QbIPyuu99NLjZRqml1/yFKqEAdEHtSVshiLiJulWFpDzuOXDSknEuLU6L8qjusUCifC2a7H5P/vjy9zJUJAUr87iwiXm/NzYOxrTvCCezopxUjY9wYvnXIDLZAX6s7qeWUYmbdwUrLelpQhilz9/doNrBFXm3mIEwLYiCHLvbYSNv+OwDLuhdqPDPqx0TeNpCdVt7u3v1j73OlOo/aVdzUUUIXd0yO44S5I6jYYlAkPWevgc6SXdKdyy1PUbmnjHTTAiExzXld+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 4:42=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:

> Merge Plan
> ----------
>
> This series applies on top of v10 of the PCI core support for Live
> Update series [2], which is targeting Linux 7.5. This series is
> targeting Linux 7.5 as well.
>
> Both series will be merged through liveupdate.git, matching the
> agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.

Apologies, an update I made here got lost. The PCI core support for
Live Update is targeting 7.5, via liveupdate.git. _This_ series should
probably target 7.6. I doubt we can get reviews in time for 7.5. And
as for which tree, I am not sure. This series is mostly PCI core
changes, so I lean towards merging through the PCI tree. Only the last
commit touches drivers/pci/liveupdate.c.

