Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8F960A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zbolqjrd
Received: by kanga.kvack.org (Postfix)
	id 18F066B05B1; Tue, 10 Nov 2026 13:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167036B05B4; Tue, 10 Nov 2026 13:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055CA6B05B5; Tue, 10 Nov 2026 13:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D12666B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:25:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74967140203
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:25:51 +0000 (UTC)
X-FDA: 85420038102.14.3894CAE
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB8DE40004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:25:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zbolqjrd;
	spf=pass (imf01.hostedemail.com: domain of 3q2HzagkKCJoN4LOHM4BOAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3q2HzagkKCJoN4LOHM4BOAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
	b=SU5IhTqcJBRLmBG8JyQNjscJ+oXlMX6CeSlgeQjcP5M0u/KZpoTXJwsCE8fNEVJhA6e7JQ
	0Ss5XqZW06Xn4Tln28h1+qbzJqbpTOnxwyfn8y/L4PgsjYeBjX0N13Ed/0vLDqsHYcUkZo
	MlVMAp4YdoHQptPtkBXX7AQGM455hig=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zbolqjrd;
	spf=pass (imf01.hostedemail.com: domain of 3q2HzagkKCJoN4LOHM4BOAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3q2HzagkKCJoN4LOHM4BOAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335149;
	b=xIVq4tae7vgiz5uulhDStWseJ9eLhchpq1V4wjmnHmUOz+GVAr8lA/IwQgGYi+0NOnCJFk
	sRJOa17JQV6T/iqWbNxTmbnm/pE8fCg0by7ob72IF8qdWf3z2gNClotGJEQFO4YgbmKZ8V
	VIgW5ed6XZzk7jEvykVm8JGqPHL3WhM=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b706aec674so2388620a12.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794335148; x=1794939948; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
        b=ZbolqjrdB7dITVlZHJoASwhMhC+cF87a7g0VO9g/4+XIxIXk7Hdfcofukr3RgAFfSD
         CW6oYfWdfcCDiOvHYC4pUhQhD1BFtRIZGSQ6z0k2O684ZeO2wUBGHTQenGVoha7tU7EA
         BauF7g5lisOu0UyBoAEd/WCoXbEVkm0TOdgYPTzkm0P3jcQ42Sx3ngxD22o67G/xcwH+
         p65a0Z6eJMpgW5+GU7vodvFcWAVI7wiPJco+/ULaSqsMirdPa+PEHgfagaDDqa4w8JuV
         yp355KScpdhNiU54ms+8yXZxnqrhIgssTX10FZvygHTeUS3w3VlbBDg4ArKtBe8Yev+H
         K/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335148; x=1794939948;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
        b=073UuRvaO7bIv+dK4o2UOQ8UdnQW+bILOoNoLRkST3ZARVEFAgOn82RY+/AQmJ1EEZ
         X/1pBs2dHvewNw9VpZn4SaBdvs9toR7e4J9VSdKtZTwzgVwirWr2TNM9gH8h+K4w4n9F
         9PIYBqUas5MQKQxgxglQTJL5E7dsSAxz+eBLRKGYjQihvQyRk59tMbegfMhYUvsXhEPI
         qUfMO5ye9/zml6e2HukTw/pltsPvvrI18X/aRPA79v7sJVIhGefMv4QcGJRBvaVHPTfm
         WrpzYqdGYyqP87zNH/MPfJ4BFaYBAiJItwMS67cYJqLL1ZW0hUwUniL1SGG4h6flTr/A
         3miA==
X-Forwarded-Encrypted: i=1; AL+hErHdRcvjbMFqY7mIq+0RCJ7LOV0JYzPN9odZqWNvJn1FRqR7b6D+ys0B67K2hV6TaGH4jV0L/LkzUA==@kvack.org
X-Gm-Message-State: APuU4Z80hxMsUQ8R2lf+4MgCteAWD2UUENHRq7D/unBusAUb+7XdcFyK
	5h3ZSG34T+dQ6FJiS4vhGQMsOql1tfpvhDMpiWNDZW44fKC2zQVype5U8FIlaGA31B81NGkOWgv
	3MtG5qHt7V8BRuJ7fiA==
X-Received: from edfg4-n2.prod.google.com ([2002:a05:6402:a244:20b0:6b5:813f:c569])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13c5:b0:6b5:76be:be54 with SMTP id 4fb4d7f45d1cf-6b777829b2fmr85425a12.35.1794335147866;
 Tue, 10 Nov 2026 10:25:47 -0800 (PST)
Date: Tue, 10 Nov 2026 18:25:47 +0000
In-Reply-To: <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-6-tarunsahu@google.com>
 <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
Message-ID: <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7iba1pwzz8wqkwi7j5x4x7ynk8setpt6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AB8DE40004
X-HE-Tag: 1794335149-657554
X-HE-Meta: U2FsdGVkX19HdXLflj9jcyWNnZDjBlBokos/2yViHMleAL1+Y2V45hQ/LZlPrGXRHxLqqQpwKnyvFkal3z1lpQTR747mKsTNEO6lbYExcNjaOCFk2oIB6lz37YLHXYbLYuR3LUukHoxD6PIPm05HI/5Dz0W2JBNZxBQqsy5NSxrGvLb5hnKCaaXjIidjQmycwk5y9kUi3B0LaZ8omo2M/EDAKQRHLAcF9NRglLwSPV/Zm6qbRA2ik34uy06n3QY6rfTAV0QYyvN1vbjIsF+qemg4afthKFn1Cbn8Hj/y3YWdBsW3LXhpb08uRxcMKunkr4OCwdWlBNGc5r0zLKqR0ymwRK7lovBzbQr2bVvz61bFfn9LY1AiqB09iyfUGaPjwiYpn6PEmvMpj1G17hHttuCWsiROe+15bFM0dKavbf2wnuKxxRcLY40pCUFtj31w5aPPAy6UQ9bKgMBSZoZ65vjqCO1nICUI45d4Xwq5HrxfZ79/SmZ0UnwGTDVVGi4rhnJ7ox6Scqez51ALv+PAAxFKXHgGt7BWm5eJuGQs3rH1h32fnESFl7LfQoIjm7m83vaxrucrx8syCdEjA1AZwnbEbxOJJcE10/me05lrHZqEk9Tsy04NQ4KCIQVnJg1O1quDBAwJ7ivmbtnEZq29BZ2Y3iaJOyuMfzhw8BGWLD5nJcIOlHBKPKsNGzwHZLkwJawFQJ4g9mW0FanPha3PHAbs2nRafzUg1jio9a8W4s8Siusxzx8lNhstHjDJZmABhBqctHSG5t3kU7U663sfGgQzqcFsaOVhkRSa+KgjfeTreXnuuCWxkoGsHn+v9iJyPifdadv+DAgpK8BUpuzjT93teBrbktm2+inmwDng6WfzIdAXBxbhETHVwlFlHm0I4ofznExGXHGvbP1lEC0fha5rcxvPI0RZJk9BfY8M3hz2Qg54Nvexhhrwv1NdnDFXsRcxLagwnHRVsSHpMws
 yCGtH2Ul
 Ci8ekznVbY0C/2SBhRV1yS35u93UfznP0bJfa897Lhxl+i5t8+33r7Dclwn7G13gumzoh4hbq2gjEjHHhCQEuRNK5/Tu5Uykelh7mQMx4CpvuUPoRtCo2uDupW//veZkF/HRqFb/Mu56rxp7QrFk1JV68aCGelTb34GnWiQGX3WfqIwXPywHD0K9zykE8OijoC9lFPFPpFbgfrjTAijBeXSHCJrbAbZQGk648AVfjTFDqVmuIr98ExR/quDp2LiSEOlyztoAwtJd10/08Ku90oM++oBS48s9yPQzqJ6Ggz2dJ7QApB6V+p0eRk3MhdXP6l/fIzf3UZ5XJUdrPoLQbT1mBIso7oXCw9wvMvlnLAwyJbb/NWT2AnsTMJBGYvA/joWVae0zYnLEwTXfcROGkEOIqtaP3m1QKDqfXtZiXAF9++g/eGvDd9jNeDrwzo1RPXsTVB/VhsrPFYoCBKjxy3MgpbOT/ayG90ovb4Ju/eHvHnf7FDfdSPj3+8wyvmDhyLNf7l8D24gdRu8KYFyqaR/wgWDiA1IQSRC2W0XOvm8fwORAD0YltwUikn0mrzl56UdIW7CD5nqMWzUUE+0YGscyqsNU4gnGZjuOyFD1jK+2XfjH6okeIsPoxXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>
>> +/**
>> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
>> + * @name:         Structure tag name (e.g. luo_ser).
>> + * @payload_size: Compile-time expected size of struct @name in bytes.
>> + * @nr_required:  Total number of defined required features.
>> + * @nr_optional:  Total number of defined optional features.
>> + *
>> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
>> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
>> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
>> + */
>> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      sizeof(struct name) == (payload_size),		\
>> +		      "struct " #name " size mismatch");		\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      __alignof__(struct name) == 8,			\
>> +		      "struct " #name " must be 8-byte aligned");	\
>> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
>
> Remove this extern.
>
>> +	enum {								\
>> +		__KHO_SER_SIZE_##name = (payload_size),			\
>> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
>> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
>> +	}
>> +
>> +/**
>> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
>> + *
>> + * Declares @decl with type struct kho_ser_hdr while checking at compile time
>> + * that @name was registered with DECLARE_KHO_SER(), documenting which
>> + * serialized payload structure a feature header pointer belongs to.
>> + */
>> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
>
> Remove DECLARE_KHO_SER_HDR, use kho_ser_hdr directly.


I added this, because wherever in the kernel a serialized struture is
preceded with kho_ser_hdr, it will only be called `struct kho_ser_hdr
fhdr` which does not display (to readers) that this declaration of
header variable is not alone, it also holds the serialized structure
after this variable.

Using this macro, it clearly explain, that "Hey, I am header to this
serialized struct and I am compiled time initalized using
DECLARE_KHO_SER for this serialized structure and my pointer holds
location to both feature header followed by serialized structure."

Techinically this is just for readability.

WDYT?

~Tarun

>
> -- 
> Pasha

