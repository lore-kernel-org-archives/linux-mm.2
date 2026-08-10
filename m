Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C3FC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E126B007B; Mon, 10 Aug 2026 09:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF586B008A; Mon, 10 Aug 2026 09:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDD86B008C; Mon, 10 Aug 2026 09:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6E586B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:20:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71B238015E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:20:39 +0000 (UTC)
X-FDA: 85085419398.09.F165533
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id C595680002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:20:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZLLShh93;
	spf=pass (imf02.hostedemail.com: domain of 3I9B5agkKCAYzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3I9B5agkKCAYzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786368037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoXL2lcVuXDTzwRL1s4LiTCXpMnjYT/r+wP/urETSuU=;
	b=ab0m7RDybUCeNiUrzXK4hf/EPbs7QOCM2kt/5NkZzPW/DMkeb2vyJ/LN3dt3UD/KjD8piK
	EYJWRDbGrF0vOQR94YwQMrVGfDwy7iGFXER1YXd6UA2mwPrKRUsM+PD3u4YR5rsb5Kbng2
	BzWW6gZ+q/4tHW8Fe6vdMjbBKfbwKIA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZLLShh93;
	spf=pass (imf02.hostedemail.com: domain of 3I9B5agkKCAYzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3I9B5agkKCAYzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786368037;
	b=D6v2WKoqSSFbuLaE4sSVDK9iVuG2dh7CC2GeaGd5JXTgk60VdXD0FN3uO9guwvSQvUmouU
	jgb5c+y49daQK62AOWEYOYeO/GgC8YUILewIlAkwm1faUsFSIAoOASw4qM3fEki24dkABw
	oi7ojJebRdRVRkPpyS445Jvowgx4N8Q=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c20262b5e10so210660066b.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786368036; x=1786972836; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoXL2lcVuXDTzwRL1s4LiTCXpMnjYT/r+wP/urETSuU=;
        b=ZLLShh93VJ5FIR9W0kF/czHDLGbv75WyQDKhbFEgmBcZYJGlRb8DSOJys7yW4lv5bw
         CaGyvyJkb/39fnjcpxld2cneS8gThUfopgs+dJC8k+4AUUGIBA1F7JisVcRWaJLtZe48
         J2oTyLdRIKXWNeNN2JFVvYK2V0ohJv36KFsgKm+fTFkfso7o86f9C8Hnjj1TVRycwJj2
         HFtiocSFnIFBeUalUUZhs6Ib+TKUFlQYx/EkccT8n86H2WvYFpvlRRX89/0CPmfwX8b1
         lR0/B4KTk48AtKV01HCC+1jhPymC2b5OOIm5lACOpQI6jkhFS/Pohiau9N0PlB6Mw8un
         rUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368036; x=1786972836;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aoXL2lcVuXDTzwRL1s4LiTCXpMnjYT/r+wP/urETSuU=;
        b=Z07uEx+TEe5BYvgfnmefYG9X8fdX9OsVEFxgpqXWvoXArtg4Dh+ElN965bu6aVFjwi
         PbkIhLzizPqfRTyyBP7i5R852rql/z+sjiFLduFNyumeEgVJxL+Qj46RDh0y/btP05dQ
         UFTi8zfRxWR8mOnekoLl0n2OJ9bGGP+5xC9uWlWkB2z2UIOq1a2P5mX+1kYXQUhUE8G/
         K/8twwvK35ifcA+lZB0DzZDFth753eeV/Lh9A2ugpFnCoHofOjvukF8FOb/liB9Ta4NQ
         HyJwoTUFS0jBcuEOqjqSroK1yD2QtoZFjbYRWL6t95/ZHX7/CsfKWpOWZ/7hsg0jBg0T
         os5w==
X-Forwarded-Encrypted: i=1; AHgh+Rpmj3pUusRgrPmpPavM0LTFRp5v3gjGHsN366Bj/+VrkNvR6ub8DdOF2z4xXN8IGNqQKQdLAcBzDw==@kvack.org
X-Gm-Message-State: AOJu0Yz45f0QkqJAmKcV/RHHJUNaGgHR+5lNpm/sa5+NgOPv9JYkzMJj
	fcp83pmrFku+BIbCf0FaKLo73OitIgHDbw7bFqWC2T3Sor9n/Gymf96N+C6mI8YgfxuBjnfCVeL
	Pg65AqOse1kS2ORLdyw==
X-Received: from ejczw12-n2.prod.google.com ([2002:a17:907:e00c:20b0:c19:71f5:ee20])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:ea8b:b0:c16:126b:98b4 with SMTP id a640c23a62f3a-c2039c03283mr2125010166b.3.1786368035983;
 Mon, 10 Aug 2026 06:20:35 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:20:34 +0000
In-Reply-To: <CAEvNRgGJ0s5Vu8xRvfPmA39p2Bmkr-U7JFFkshM9Dyk9j+t-YA@mail.gmail.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-9-tarunsahu@google.com> <CAEvNRgGJ0s5Vu8xRvfPmA39p2Bmkr-U7JFFkshM9Dyk9j+t-YA@mail.gmail.com>
Message-ID: <9huz1pc6863h.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservation
 via LUO
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C595680002
X-Stat-Signature: uwgjz8gc8ub8nfen6mt8xmk3bs3gt9hs
X-HE-Tag: 1786368037-688298
X-HE-Meta: U2FsdGVkX19wt69jZDGBSzoachaFx9JKaBLH5rN6ndfPF6U8ZDhPxdM4kz/aX90a8FBtwg6QGnmIu0PPCXAnyBH8oomJ6vyQcBzCvGyYDairkQuq/gx50/oj5ZPUQSUYKj8RgUeyrjtrAK6ztdOZEB8OZJ8qHHEtPv8GtzOcnljf3gOAH9Skyaz3rKbziAQLp52mIgWdTFnsHt3BYlN1rEz2jluDZcyMqCEspWkFJEfpNazYdS3kcmCJuY7PpI/x9S6qEmeNNaWMB0W0MGuwMx695xRRQITLX1xZBDsn4zX5DUuda/TknyJg2Djsa59pgzsKNxFZ5CBT7R1NG1l7Ua97wpTl6HVKJJ4MnrK07wcRQrSf31NECPMkFm+78Yf48Vxe8e6n2p+dqJUnSv1bXLjLhgJb6+hftRsWBY8PKhRFXqjR6g7ya6Rlj94OeedkoISzn1SMlRS3vkFCVA91vCSS4fhnQn2ITycfFl6zZ7R5GzdqaHU8L4rILR3enYUCZl6aMnpAdbT78IEadzVzsKKsR9uHtIE29k0WoEmDTpVswpXKOGglbgYmTiZH3DP8bUeHp0C1rUpanXpHZO05/9rwuzHjQzfT+nfWs+9vRkKjyOJx3k8tlR2/IDuNjRul6t0v6aH3M2J7nDUH60/TaYciD1olgxc5GjrE71xdhB+B6JxnSUnLWXiwO6KF6tLtsnbuGv/ZTttHG2hrwoE5aRrFf52HkfhqGoVRo92W+G4yIaiUJIQLXD9wM1g+0HT741pRZp5rDsQ1u8qnWfd8dFOH1OX//QVdbliyKcZQT2Cw5cqSjinD5mBQM8ZtJG2RUy8KDifM8zNdJx4X+Tkwp1wfnC80Kqq3jiz0pbJv9n4EisoFRZv06jFgkew//S5iXHzOfUubV9+BFKzlmFpuPx1UGVelVCnRNQUzjDFuJ+u9G92x6BYBOBjfZre7bqH5XpAj8wl43cH4w+i30qz
 p0stsm7y
 iYmnsFyO7iDJxRL3RDsgV+hLBtK3Df2tP7gWhAF7ivOli9oRhTdo+pD49ur8tUpToytqKVrrLNHra9jIGT1UNxVie+ix4fvOxYkAPhWQ+yEpLPxWv8tows8zEtPefoTIht9y4+z0+55MUDGGeSGdyLmRhuUP7jrxRxqUiKa31A++yNBZzUv7ZgkLyL/JlhXcaNIHfmOxc7/NVfPktH5Fl1kSnjOZzH4ATZGanRKwL1+mrXA9CqCptjr6mVenN768azv2Dp7OJaDSP328X4rmKv/MJjczUN7/F0I8nZlyy1hrGr3JEjZqz9qCOlT+7yHC7n2fSpcUVhGpUlTtXUKsfsbCaMgFtKoF3juSpNnZ6RdYoMMysLBeeB5yrqqyoWQtlZl/dSaQfv0mNEx9s9jCjIzcgL5/9XdgaXuAT6M0UrlJzUZ4nWa1ttp8vdLlzrcYJGkjFihgRmIbwjAG+EZHly885IY5jJMcjNPK5SHYl5ibfPra9A/vMuvS+yvG9ARxHzgAsayZtjH9G5GIymFETL3HX7I9+U3yv6VKEnkXZUowSCtt5JS8ZKKwuc98OiSzFBjmx6eere3gZJrEqYb4KlzpLSSOKovtrNgAGrjB/oT9S+NhJfIxD5Q+/5p9PYXDBXOwo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>>
>> [...snip...]
>>
>> +static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
>> +{
>> +	struct inode *inode = file_inode(file);
>> +	struct gmem_file *gmem_file;
>> +	struct kvm *kvm;
>> +
>> +	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
>> +		return false;
>> +
>> +	gmem_file = file->private_data;
>> +	if (!gmem_file)
>> +		return false;
>> +
>> +	/*
>> +	 * Only Fully-shared guest_memfd preservation is supported
>> +	 */
>> +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
>> +		return false;
>> +
>
> The above check can probably be removed. I think the core thing about
> this series is "we can preserve any memory that doesn't have any
> encryption state that goes along with it", and so the check for
> kvm_arch_has_private_mem() below would be sufficient to gate that.


Sounds Good. Will remove it in next version. I will rephrase the
Line: "Support only fully shared guest_memfd" => "Support only
guest_memfd that does not support private pages and also can not be
converted to private"

>
>> +	/*
>> +	 * It makes sure that no memory can be converted to private
>> +	 * even if it was initially fully shared (in-place conversions are
>> +	 * prevented).
>> +	 */
>> +	kvm = gmem_file->kvm;
>> +	if (kvm_arch_has_private_mem(kvm))
>> +		return false;
>> +
>
> For now, has_private_mem == has some encryption state that we can't
> preserve yet.
>
> This also gates off KVM_X86_SW_PROTECTED_VM, but I guess that is
> intended, since when work is done for preserving encryption state, we
> can then test using KVM_X86_SW_PROTECTED_VM, and only then, remove this
> check?

Yes, It will be enabled when private memory preservation will be supported.

>
>> +	if (mapping_large_folio_support(inode->i_mapping))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>>
>> [...snip...]
>>

