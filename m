Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759F2C5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F51F6B0093; Mon, 10 Aug 2026 09:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC306B0095; Mon, 10 Aug 2026 09:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3226B0096; Mon, 10 Aug 2026 09:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20F086B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:16:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BDE0A1000
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:16:01 +0000 (UTC)
X-FDA: 85085407722.17.7914F9E
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90EAEC0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:15:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g2DG2Rc+;
	spf=pass (imf22.hostedemail.com: domain of 3Dc95agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3Dc95agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786367759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
	b=WJ2/UVLSH6bfDT+CgtvoEOW8KQleOgU/4y/3V/oAA98RpGMscC7P0BHBOf/rT/TTDfExeM
	yySxXrxXS8/Zd86M/bGZ6KXJL5KTKssazMjba2BfVIvkqs3rj1nChc2HXaDQXsO0b4xifu
	/rS0yVOgBVWPIc6LPkAjW2sJ6gy/4i4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g2DG2Rc+;
	spf=pass (imf22.hostedemail.com: domain of 3Dc95agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3Dc95agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786367759;
	b=RrtsHf5m7SHBA7Hp6mxpuShZSN2sVTZbD6eEQuhdEDycjPP0me8ygyHOCkRtA00nH7A0FG
	kSZC3D/uVkt8Amjx2flOeuR5DOue/Nugbt6g/XYv33pQYXxIdEFgKqGEIU8SGVgWKyCiF4
	VdYd9064CUrikUQxLo9NQlkyc4NatN4=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1686e23b9cso137057066b.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786367758; x=1786972558; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
        b=g2DG2Rc+TXq4kCOse7AQ57l2frBt+yYbnQzcQhfmElvYk3bZLOTnBK2maw0st5TbUt
         +TuJexZGejRiYW6+h0Y3aAffHMK+TmcgkUWgZPAaiXwWKs7lMzJ8I4EIwE3G/45WcLF/
         uSSDznxuLDhmpdtusmzlNMRHHlD3Dml3pFtxrrm+oLpUdClfi/n/vS7t6PkcxuWOcrXo
         eTo4Nx944hiTcpiZtwrfOC+p5lW97vNONy6miP+C4nNjwyZaii4DRs3ULoxrIZnDmpfk
         KII3sEWCAE/a+3jtcUOihkddLu1rR+IJkgLHaieChVFpRIUKrlJg2GR8bkvJZ1PiTYrG
         tjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367758; x=1786972558;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XU+Yh6jvhHTQ2a/3HxdMnwUDwPqj59NubIS9TFTIlO4=;
        b=WhyRmLXWT8djeSPkEzwbAxEPV6PjLkvLGWP8/zwKAplNwGMZy5obFfgLneI4faXBB1
         EWc/oCx3w0SG/eakHEO7Lqw6R1y2xlKKlNHtHBuKZyaGymvlTSYFVabct8n6RZ2pCond
         6UQyMUzd2/9Iu9EM7n/IndisOUe/XCIkox24A3AHNXn+QUCpmga/3m57t/THuOb2xDLm
         s4Z85AJvOH8lSkmJqQNRL3vjrwcBp8FXPqVur6JBEqok+mw05SyE6lWjijwL+8oFl/VZ
         hiNSVm06oca1EIxkk8c4lokO97FPCKULLgnB3jJsiM+0jVuJpIYB1cxCbp/UuZIUc6MT
         zUTw==
X-Forwarded-Encrypted: i=1; AHgh+RrHVv0NK++a89VeZLl+ESu7esKEVz4DjwKQJtAhyvqMilArsG51PjBY1MYNd7tWPKQ+Beo2my3NLA==@kvack.org
X-Gm-Message-State: AOJu0Yz2A0sNU8cLCjwXsJNl6+MnkZES3E8WftAphYEmeaCsYVqy+/+I
	X8zXQg1Uanp2kH3fehmjmooPV7X38KGqulQSb7GE5YF0wAN4SO7au+saWtSCGiY9mJAIvkO2vo2
	3xd1D/V6gYRBv7lV3Xw==
X-Received: from ejcww4.prod.google.com ([2002:a17:907:a904:b0:c19:52d4:dc8f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7955:b0:c1f:5f64:1912 with SMTP id a640c23a62f3a-c20c68b9233mr86192466b.7.1786367757496;
 Mon, 10 Aug 2026 06:15:57 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:15:56 +0000
In-Reply-To: <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Message-ID: <9huz4ih286b7.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: uac854ein67nb4nr3gmuejdbbx3xssnz
X-Rspamd-Queue-Id: 90EAEC0007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786367759-444160
X-HE-Meta: U2FsdGVkX18LdjXYjzvR9vgjRVmMTbnT3qJXv/r7fRgIYDA3T2trEAyrnqBnTlMcTCSO7mNP3lcscXYqLECSTiG62kS1TVxOczZGkIRidZoiCUNoubRmMt/ouGMv9yXARzH25HPevQKI4cHIRphnZKc9lAOTpk9EbO8i4YVRomgO10/dL0tr7tUF/sQRhjg9HCasCqeNhK6pvtcaXgrt7zzUxJbpm6J0IirxuTFBTKjRPZVc8ua1A7566mX6+YFQgl6rym/88ul14M5Lzpr73EX/2rZ6+lCBWUO8k4UIpFE5nBG2gXxqRys646q3+t+PfEoGoYHwVf8fNpoYBJW40XA4uNnYlClb9HnkPQWSnbQZaIfCT4q8GKXzBa1UxU0UUrKXSo4saf+sjYzVFaVWJxSvG66qmvmvbYtX+JVkaNq0AInR/qSW3xOq231IYyi2I/PpPkf89uTDpJ5vIqmFXnwk/djBt7ZhFlly0Ae9Yr7m5mbuughcEq2Xg28g7cDI2xHsFDCyDU2BD7jCG55CljzLKNriUA9F4byv3BC4XYgIGiIoz2TUuDIU5DS4/p7+J11PFuSoBcDTKX98cfADapYgnxhSej5Ze7+9JIGDGB0pXGQLXBon2gXE2EFV7m3SC+TuO2y/o4JOphz+F/JAAY6eprv3jPM9nmbNFyqUmfDsJjSr8oX0VDcv+LrlRfvMfR7raRRiAAek7175p+69Pd7Q8HNYLxSeM0ao384bSvtq54FTQ3Gwjma9hcrwreKE68bBjIv0dhFp8wlnsUYKW6Mce596m8xMz4KO9UD1FidsVXBv2ycq4qJqeei8qZpc3+r9oMTEse26YJMesviABxp9dDdYpPGQxPYiuo2OdzLLgDtYrVB9soVffMTzZXQHQ1BULiFlWM2X+i5wVWTzX6Z7qpEWGM7GhHBzkvduI45LntKPEzBX53Yd98fCXcJoKrH+6I1fef/CvsIQ8Ft
 bJhs1Wew
 HM7Fck4JXObd5zTdExTzdaSQK9/kgK8RHTn1FRGpCNtpvv9P6pme0o7OdBXfNPVBePMCBQPR3c9HmfgFO5SpEXB0Z3eAzUQQGxkJvKCCSM9i8tQ54TodNQ6fRRD0X/sW8h5RiFBhvqBtd9XO0ugH/wv88CCkTHmSP/eq0nKm0m2UziAtlBcuqV9nAG/B0AYixv6B5HnsyQmMGCOpq30d0KZGmsIVG6jWODcDOiS324nasQrxmf3FRppXgG+7XAwIZH/dsccC1WPi3+nl/MU8bko2INc1283k/1v+AwYsDsGrUt+Hcd2xtnvmzlN+izw2vKSKpOKbDxyVXo07IW0tl8bJGsRLfYbEwfif7+WY/5P9fuHATJP1V4iQhiuIffjlC7oVF4LcGUFf3MSQkpSIaHsvDNgJFaCqpeXgv+dU7UjKquXTOR/Kzl7VIrJ5++mekdomi7nPBhjLJkigYlNh2HdoNvZyEp4eqoO2GdICrv5v9WTvNNc7lPjbC/ttAZJBp2FqF06O9NGjBDsdIApAO5+1lnW/SM9ACQgyGVcu3+nELyfJXvqW4ibRNBN5gjZ8jWusyXw/w5bYMIpba7Sng0YHv3avGTKRlOHAD6R76/6gMcNo7Ns0uHs0ZCkZeot66wE1+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Introduce kvm_gmem_freeze() to freeze a guest_memfd inode's mapping,
>> which prevents fallocate() operations and new page fault allocations
>> during preservation.
>>
>> Use a global SRCU (`kvm_gmem_freeze_srcu`) to synchronize freeze state
>> checkers without incurring per-fault locking overhead or risking per-CPU
>> memory exhaustion (as per-CPU structure not counted in cgroup) from
>> per-inode SRCU structures by faulty/compromised VMM.
>>
>
> I wonder if everything to do with freezing should be gated behind
> CONFIG_LIVEUPDATE_GUEST_MEMFD. What do people think?

Right now, Only liveupdate is the usecase. There was a discussion
around the future usecase when IOMMU FD can use few pages from
guest_memfd and will have to prevent punch_hole operation. But
that will also avoid new faults. So freezing is not the solution here.

A SEAL type solution like in memfd can be explored later. But this
is very far in future so Plenty of time to discuss more ideas.

On gating the freeze across CONFIG_LIVEUPDATE_GUEST_MEMFD sounds good
 Idea. As in future, there is a plan to remove the freeze at all from
the preservation path. Before LIVEUPDATE, there was no usecase and in
future, that usecase will also be gone. So gating it against the config
makes sense.

Would love to know what do people think?

~Tarun

>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> [...snip...]
>>

