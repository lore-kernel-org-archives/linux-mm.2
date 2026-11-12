Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BE860A263C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QvQD9vk7
Received: by kanga.kvack.org (Postfix)
	id E2EAF6B05B1; Thu, 12 Nov 2026 11:33:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05D16B05B2; Thu, 12 Nov 2026 11:33:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BBE6B05B3; Thu, 12 Nov 2026 11:33:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1B6A6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:33:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CF6AA8238
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:33:25 +0000 (UTC)
X-FDA: 85427012370.04.A118404
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0363910000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:33:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QvQD9vk7;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmjuPZ8BQZpeLS5NHfXu6uyM92RYmwsffX2PFFxEaPU=;
	b=aQf/tp2icLfDmonA/DuSa60HVnMAWFk9h/hVcS95oFEv+bVJvd2/W5n2nnFF4fdMXipy1A
	5PE1Ze+n7zysVISaI4HEDNgRVkGl3VgZcA6Y2GatY6fDqF2UcEHEW1YJkEYk5PNjmfhurj
	mIlrrbOrUmkdH6JnEZQQGhdBHwv/1dg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794501203;
	b=tOKkynY6h97hDAPQck7WCSDrg0Cqe+tzv4vMEerH/TUkcqYx0DBo/9nJrtMLSRBB6H94JC
	Kn0AjP/Yoi8M9PigtAN0764QEqQLlI+X/iY6sQLBHM3LZ22dx1cb/oDj+nZaij19aMFuy2
	bITQxcZNDhcDdsHI3NlT4L6lCdbCda4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QvQD9vk7;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67bef6dd972so309733d50.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:33:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794501202; cv=none;
        d=google.com; s=arc-20260327;
        b=ZxMGgdcxCkyKxmARJc907EgHOR2L7Jx3UM0wPmBRlTvgf9964M2wSqYSjeZiOI2mY6
         pNHdSfi1Z+9YiOjiu97TKy5qCzkY5Tlz2cG00AtyfKB68Rp+gYkCFZp8WdaRXfpEomZX
         WEw/bpZlOz2s89TYD5clvSuAnqvoWDrR9BwjL7SS7+LXwcycNnAEhsZJ4eO6S2ye+zvQ
         ClmFnb1x8a+RsqBlk8OTJsR+p0iEZTEWiIUoxJZChtUywG3HWijOQ7aSvXHrz0L0GYi3
         faqIbXLNUJekgXbvYjoF6K3T43AeOqfXvOgD6LQwpNe0umhR3rs0LbO2KaTjFSH383Ap
         q+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dmjuPZ8BQZpeLS5NHfXu6uyM92RYmwsffX2PFFxEaPU=;
        fh=R2dxVHYYVDj9RNASr2LyBOh5hUePtkqlLKbt9Zq3IZs=;
        b=GBTGSmlbPpduRKLhjewCW1UI+MmteuowqwqBBBOKbCHIJaRO/HpvzIIXRJuWIW/fQt
         r1L/JzURMnFBVWEVfw4vtUQNOlHkKKAnjw3FDxg1d9zyVMFwxx4OHm7LY0oZQRkUArwf
         wmVio/n4fc7a9U1/7svnLHQ/HyGXSeB0PM0P2eqV+fbYqXqPqNivwzq+kbs3X93nUCsh
         LCiEtRmq4hpqheEr+Ik/mLvqLhgnVLW8b5DwWVRxT9ZX+8w8neKhy9P3Tc86CzoHcChC
         ju1PIa8xdAQIKvuN7xiWCvpcchfkC1JD2+71q91e9rIsnKD8t6QCBfPr4w2CQVVkM2vT
         gRyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794501202; x=1795106002; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dmjuPZ8BQZpeLS5NHfXu6uyM92RYmwsffX2PFFxEaPU=;
        b=QvQD9vk7vfOtDIZdPGLqxKQBfowMbowFcxUty1IZVosQRJOee1btaQfOy/1hGyumsZ
         3LuQQtFz/o5VY/EX/QHTAbUObgy0szNDM5sKoiHFyWBkf6cJumGFcMGhyn1P19Em0EbG
         HFmwY6uz7R2TGx8MsNoX+8ajv5OVOnAJFkO81niEqYYySDR9qEFUX7zzfBxs9FqSDLSd
         bMSm43kk/DUhffvr5w9wdcV2Y4aSeU9UPWMz4Pf7PtC1HaS4b5Qnxgre5Q9rfX8ux9ju
         DhHi7h9SFjaKQmPvBt//wdNmfHqp8JeCsuQ2me4/7cBZl5PJnPeNprM/D4bjz7L0GYyD
         KsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501202; x=1795106002;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dmjuPZ8BQZpeLS5NHfXu6uyM92RYmwsffX2PFFxEaPU=;
        b=tMqeLMU9BWpdLvCYl/Xh3ttj4liuHCV870g+btk6SrELcbBZEog5l6hKuRKq1wgFEe
         igSWuB4ihfZ1Y/vxpQnP2wZLEI5Tfj1NwYuIDeFCuJk1Y1HBejtq9g5QU1jkZKy49DWh
         PD4wDnQZEvelJchjIODp6qIEOHVKNqkx+imbJB5TeQmQifTmeOJDxBzTzd3/lUnsyPif
         KDBn7OAfKkv5THJ5LEIwpXvEeKpcsW0Z7UN8bvYnZdQ9H4v8SOdCvrYuWHooIHRMchaq
         UIIXitr44P+UQkeAMlE3uqym9JxMXkvI8wKveiwHJlTbP+bXASBLnRxjBQ2wxGoADBSX
         t7aA==
X-Forwarded-Encrypted: i=1; AL+hErHdDZNcRNZt8VooZUXfumW9OfJ2ZE9YeSolbeV1NykdVOlOQ7/9CZsFg1m89mMN7yldrYmyTZ8ikA==@kvack.org
X-Gm-Message-State: APuU4Z9g26uQ3jbj6IgB2xvyrtHXMRxbSa91VVryGqsGSKaSTT7uSUje
	lMRcPp4xX02fVceaYICCxOQ7HChW6lN6lUCeECmFP8RlmXigFAk3MDl1NMTmEcFrj6LuICsIS1X
	FZaVV/G0w4z1ynDSqCYoprGVCskqn7Gg=
X-Gm-Gg: AYBFou1qUBFVlZqPWzc7/olSmGPFzYBNEoek5ASN8KP7kS+JqU1DpL7C8vRSBH2CvFN
	8RjAbdXscUFth/bpKiNn1F4aVlosXPYr1/vVgqg8UHn7sz+MbM+JNRg7LlSCrgI+ZSLyH4jJRnV
	WOWjrAf7Oqe4FeR0l1I+SiBFhX6N2YJCA1eIwkbFBmSt98o78IbbQJL+qrVb7U/x9sfhKd1zxit
	UDoRFR52qvSG2YnOJmRVem88DNZpzaAfYKC5MnFFCc98G4sz3+j/CRvHeNLM8IEDpvlqPwGuqav
	yMxlMteR0RBMq+PemX6Lc/Hbqpcs00iBOj5CkibrtVES60qHJ/reOpH3knkTdn0PDEho/4ch3Oc
	/IHyZkgsvmmyqQJB3IeWqk9AI9C0aC/0NDzA=
X-Received: by 2002:a05:690e:4002:b0:67c:f0d:82e1 with SMTP id
 956f58d0204a3-67d893bd8bdmr525d50.2.1794501201888; Thu, 12 Nov 2026 08:33:21
 -0800 (PST)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 12 Nov 2026 08:33:20 -0800
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261109000243.3936824-5-joelagnelf@nvidia.com>
References: <20261109000243.3936824-1-joelagnelf@nvidia.com> <20261109000243.3936824-5-joelagnelf@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 12 Nov 2026 08:33:20 -0800
X-Gm-Features: AclHuK_FGWOWv4UbRIgbbmYPPnmJDJ_Hf17GfXM7QfUltDyC3SKn9TnbpoYkG1w
Message-ID: <CAPAsAGxPCJ87akRFmcKWLW9qQ=zMYim+F6wnLeYmSP7CuEgMLw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] kasan: Avoid an unrelated RCU warning in the
 callback test
To: Joel Fernandes <joelagnelf@nvidia.com>, linux-kernel@vger.kernel.org, 
	"Paul E . McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: rcu@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: s34ptkkbyn6ebjubco6z5shji6747tg6
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0363910000B
X-Rspam-User: 
X-HE-Tag: 1794501202-762909
X-HE-Meta: U2FsdGVkX1+46iYyeTI1TpqEShToigL03Yzn/4olJ9kpz0wBky4CB3XRlB4NuccBA27SL+rT4/XcFPwYYMC2NZRKKCScMpJ7p5TfuOh5RsJLx9cpH7osdcdpX9ri39HE1r4grXoEqRNieV1CGvs9hFt3P3pTkn7OzDvZZCcZYtKBjKuFWHrlSX2SzDJAIygMsDOxd2tUHpyv48siEdYQG3lB1vEkAXpqdTAwnIlSzHe48ReuLB+wXtRKs/43IBUhGtCl7ShO6fbVZyGdjIq0PJ24qUHKDsbb1BX6P4ysqUL/LLvFzO1m3hF53JSUj0yNqIERmUaFysDK3Sv3A2PhfPWi8e/tGf9wQdR+AUSBypE1yKdiwbaETEdBEQtLjY0fH2BOqTKsVukTznLgfgoB3Isv6yagKMXysgH+m/Wc0p/V2NDz2SkuN8AEt4Nzfs0K5OYmAe0OXDgIiH4u4vn/oc8ke/hKfViPPNJw0cfkmi5/Imyrdd7wXZH/PJTdzGh7tnkZMjCeATARxIPcngRCNbn0NhDYrnOWovaqbh6P0kj994SiniZsjt7ioa4pMflZDwUr40AEO3wa/+jncHeNTw7ou/y4WJUEBE5hlKK0X4vX4/hMJ80VVUqXIqungEgmlYaU18SciixunZLfV+Arq0yDfNESzyC9/ZZXi26dBnDsnUWudFkPOSZYmCsQXsHWKRhrDCkYjy5aVwqBUnP0m/wXSF1TpvUMVeHd7blP1YWKLMxiWFXESOGBdLsnSccbHMnoh9+FhCsJ5Pxz1py1lXYHA8wpOBaYd+aeddkYX2vl+WBptSvsavq/ziKYItzAiQShvdE+SYZdF0T8oY/T8vbBNApelJhT6Sw02hhs96nXcknXCpBnBInnOdaMSmcJAX9DFk6ZvVvHP054tWgRud5N+6mdbLTDb0f8hMkx7Q20B3CNDOcNDgbftmst+ZdoU3qM875eqedg6Qhto5Q
 PInH7xtP
 vCQoX/a3V3VQ9h57iSsci0Yv0v627w+3PWnfNlN94GA0paEfPMDy1ImpiDD/q5sKlULElEwpdO4+c/8qzmTaqdDyG4kqzQ9evQlUghZgVRibDfiQQRl2159U7tshnsHjVChF/LIgfdMpfqX43Kk2ryccECntNQofoljJPiBFxmLimz9Y/lqi6b3514mWx543OTTySxc7Lyyj8IJ6Oz9aLIUTzfMMWHw8NJbcLV8dXllihc2uYBJ9CYMdHlj6/5j5AHHlhhi2aai2zhYkBbU55xZQDICNT22jeAz/D16cNhY68aJPQL9GxBTE0KQj8ODjKKy5Ps98bUUEr6pmAyzUoYxqjyiMizoOpPtJY+76DiEf8birXSQtIzAsJYga3LAgFijewlhEBWpLluzm3SoNza+VtDJ4jHaMhtXiMhz1aKld4Jy/1xQKDORZ1XZuSXlFsgmW8ZnHAsysen3XFTJEUSStAKDhYgYqYLsAGjK7rlnY5QCKG1aml2rEuLmY5NBNgXF0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Joel Fernandes <joelagnelf@nvidia.com> writes:

> rcu_uaf() passes a false protection condition to
> rcu_dereference_protected(), which produces a suspicious-RCU-usage
> warning before the intended KASAN failure occurs.
>
> The pointer refers to a fresh allocation that has not been published to
> readers. State that protection condition explicitly, leaving the intended
> tests intact.
>
> Test:
> Built with CONFIG_KASAN_KUNIT_TEST=m
> Booted Qemu guest (8 CPUs), ran modprobe kasan_test filtered to kasan.*rcu_uaf*
>
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

