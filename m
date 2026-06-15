Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B64CD98DE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 12:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF3D6B008C; Mon, 15 Jun 2026 08:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C66A6B0093; Mon, 15 Jun 2026 08:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203F56B0095; Mon, 15 Jun 2026 08:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155B56B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:29:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB2C61C313F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:29:04 +0000 (UTC)
X-FDA: 84882076608.08.75B6E48
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDD0D1A000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:29:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PhK9ZeAb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3DPAvagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3DPAvagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781526543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CT1s7ATFj8WteSPKKyFJkoKC4fFljJpIcKayyOXkzbM=;
	b=5BGDW4oJqnoN3Wn4SeZfHbA8sKXDmFjYXDbZrNPGHvX4a1EQkf8YDGI145yfgXDJKwJuup
	GhkNLviKrVqBgIu0xnArawp+G24GoobQokpl1dHZcYNMWjB0Qh9GlY0/neGN10eRktMEbo
	TsbDfi+9GEZDTSRDvGJovf2n5bIwBRw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PhK9ZeAb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3DPAvagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3DPAvagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781526543;
	b=jTeFt03vORJOEAdUAG6bALIz0P6iMsUO4/0g20w9hyHIjtCL8qP2V3DxjaPrNCDs/A8qq+
	XqBKwzWnMLx3xjEv0lTBq8JYLEGK2zLN38M2fMPWhl1MlTJgyoxIuQGqn9ZaGKagHN1Qer
	Aa28pAPATX0fVoV+UdDjT/wSnQDYbVE=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68d2339febdso4079281a12.1
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781526541; x=1782131341; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CT1s7ATFj8WteSPKKyFJkoKC4fFljJpIcKayyOXkzbM=;
        b=PhK9ZeAbFZsnqCyx3nYULuaQ31QeV9Q5mApklOW5RSu88OChQsQ/yXEJaQq6IrzKH8
         oGR9HiO5ejZsCHNP0IdlFTCRv2DXnbKVmOeDcZwzBRUjfOXdOfchkWVkE+JKTRu2LtiP
         BBbl0Z3CZmJvQPQvdeC8WEIsRQJIj5JzKP9Dpw3xjaKPw5F5w14fH+vPq/04EPHCFS9H
         EHCDBJZ3zSuHKRNYOU7Ij9apW7Vm+D2jb/fM/Ase0Y2p/2fHRTDHpKL1NCoFidPlb53c
         EQluTKZlyDx/HRDmZCLf/p+RkisPjWGA5XoE5Gj1Wvfce2SejTuJEqZE+MYsRkEUaNaH
         LGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781526541; x=1782131341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CT1s7ATFj8WteSPKKyFJkoKC4fFljJpIcKayyOXkzbM=;
        b=qlRjFNd2AICftAILhBAXJyZE84BKq2MarPEQEAGCj7gQbyEEae6KRvbaLowGeKtYtR
         ouD7udZTvB0XfBriTvAxaq9WvmXwdKeLtscsXcgeswpUJeCkAnM7DPSIViOvu9bLZFRE
         ZPg1RnDPjB1PvwBUTAwTVeqq5KKoY3woIJJqfpyDqVSx5uhb6Y0TnDM+i7irsoask563
         Feybsx6qZAJRKlVvgftio/3NSB1oPKBYb2LpZLdX8NH2aJFGx6ajk2bxQ/uJSKzA7akF
         EAIkx09hZ8Iw68ewXqnFJY5+gUXg72v+3YwW3yV3GX2XArnNNg8uNBEd+0jXKcWHE1Pe
         qG5A==
X-Forwarded-Encrypted: i=1; AFNElJ8fUJ6MK+DMgOEjc/k5+kCKbKlXYvR/Xqt1mM5LIcVOFN715PZQ8Q8K73pId39zwPC7ER1aCyGInA==@kvack.org
X-Gm-Message-State: AOJu0YyZ9KPpxWM7xN3JnKD6KKlECuh7tMQt+gCq4mN0jHW++yJi65tH
	y8cC8YEKP4YExzhle0YEJXy5MdMSttzXaJDwi2l1L7EzsQ8s/gox8SlVTlB51ZdETiXog61eAbt
	TegMrlAE7/fLlDh4TfQ==
X-Received: from ejchy18.prod.google.com ([2002:a17:906:8a72:b0:bfa:90b2:a153])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6e86:b0:bee:f402:5567 with SMTP id a640c23a62f3a-bfe2acf2cc4mr672276966b.41.1781526540559;
 Mon, 15 Jun 2026 05:29:00 -0700 (PDT)
Date: Mon, 15 Jun 2026 12:28:59 +0000
In-Reply-To: <20260613012521.835490-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260613012521.835490-1-skhawaja@google.com>
Message-ID: <9huz4ij4xa0k.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH 0/1] liveupdate: Add internal APIs for file preservation
From: tarunsahu@google.com
To: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EDD0D1A000A
X-Rspam-User: 
X-Stat-Signature: dpddkt3uw9xmhgu1hpybmi8rbw4ho3qq
X-Rspamd-Server: rspam09
X-HE-Tag: 1781526542-13661
X-HE-Meta: U2FsdGVkX19geD3Lx51jC6WjuwPRiB+Obycs545/nbdOa9eh5xxq98eMbTC2PDGQitXh9N6qV9W9kZZ9mOVAf/sj3gDv4kbxNpsnLw5im23fSSnQKsmNK6LqwA8oBAISvi6DE0ODcZOOJx7lLAdE/9G94eUgTXRElzlEVqS/rMlSOIlO1TSAC2UbZ2cFEyUEsugnd3N/g/16OYy4xbD412bvmhJ6S7FtUSVClHd0K/E/h9WRSaU4bww0ZzzXq5Skc0RTn8cbQi0tpjzZWIldqU8xKYQa1RhpiZy96RuoZwfiT6s/z2tyRvoFHK6lhcaTUdZKr8Ho7QWwYUGaUlEY8GX+kzzM602nN+s743aLjpnfYphFmyZy9Wn46qgqzhytQg0KS+m6WNql4BH21oy9I0Qa7fwPm/OfsgFnSeFaK5I8cDFpD6RDkia3f+dNGuAqI36bgtNnvIbYiZScp2EhoMTV/hrIxlS93Bh/fjr1xB7I+iXRs+WL8JBH0GtgXCIMW4TzCPaf7YG2aYo/1NrF78aXcIJcFeHv6cx1+nSwcIaGDfYHw4gHHlZ0T2weTZOP3MtsF6yalt5M4WRiaWE2ka54MQ3SZh80wLjrbsSAYy9j5HPFu6XGfBqJVWxUXdiWLnjtdaRVu9iLQPXzcm0XDCxH6YWyoazAf28OOVUztWq/nLPFkEPMFOEhoLz5smi2teMcXMBkRnv6riiGhrqAJ7lOcjTINwtGigGvwCMQG0Pjm0WC12VJECdPujIpkalUVIYFt5bPaEwHPUuGOZnHYvWy+zBpWXCnWiVCQ5BpEV64BvtSTGNWAx1EsnxmUZpVQI+QJjFfvVZVB5yYaudywWHz1PwrRsKpYz8GjkWRS/bqi9W0XWWrfX8QlwTSjkDGMmkET9FaP9YOPuchNhw+y/SfYfNiyHooaeKmuKjL/SIzqUwh7HanNTUka9EUI94uH2fFrwfVSxPq5E3YhCc
 5iEgHSuN
 yM32edj6OB9jIeWRl1HTOd6IL1N1sSjlQiMXbF/1tObjE0y3BxnRa2Z6bNtYBUoXd9yoZzDbH+uFnLk75BpkKCR7ma1aoDj6E50t40MFp39W+e808CyKuFqfA7h5whyjSZxF3aeovHV0hyyyVjp00Bw75M5VMBbOmcWMvEp4e25tMjH0bneXwRXG3a2tdv9ZgA4oqgjku+CX4XYeB0bO/F4+F9AWYe2rzVn2399TYzxiGbTDBDBXK5NDDQtGVO68NtKk0UOF6i6WV6xNG2fnst/PnJGjuBCaTpsLyOifaSmQhaxcQSdNODyM4VYawg7sFisp22OyuXgbxCGfZugzD40ntn4IXUIQCpjWzYXg7H4g/5lKC7sCg8+J4SXP6/2AlEdDNHJH88rE8RQ+y8GfKX+5p5ZFECMyH4NY0BtiupfdT39NqnZdRQGSfBdNqq56c8VNKNqN+mN8z0jlVHKI7F123WiBuhQGdg4B25NyKFpywV5Y92ynGHHK5VUNLHiJ3j+LD77qPtDkRGARnXviCSSeUEX3I57SJz/1AChJ/pY8o0aq9NMvkr1qDh8ptWctHAh/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

Thankyou for sending it saperately, Now I can remove this from
guest_memfd series, And we can track it here.

I think it needs rebasing. I see it fails to apply to liveupdate/next
and mainline both.

Thanks

Samiullah Khawaja <skhawaja@google.com> writes:

> Live update orchestrator file handlers depend on the preservation of
> other files. To make sure that the dependency is preserved, the file
> handlers needs to fetch the preservation token of the preserved
> dependency. Similarly during restore, a file handler wants to fetch the
> restored file of the dependency.
>
> There are two known usecases of this,
>
> - VFIO-Cdev preservation requires the preservation of iommufd. This is
>   required by the IOMMU preservation series:
>   https://lore.kernel.org/all/20260427175633.1978233-1-skhawaja@google.com/
> - guest_memfd preservation requires the preservation of kvmfd. This is
>   required by the guest_memfd preservation series:
>   https://lore.kernel.org/all/20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com/
>
> This patch was being sent as part of the IOMMU preservation series, but
> now it is being sent separately.
>
> Pasha Tatashin (1):
>   liveupdate: luo_file: Add internal APIs for file preservation
>
>  include/linux/liveupdate.h       | 21 ++++++++++
>  kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h | 17 ++++++++
>  3 files changed, 107 insertions(+)
>
> base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
> -- 
> 2.54.0.1136.gdb2ca164c4-goog

