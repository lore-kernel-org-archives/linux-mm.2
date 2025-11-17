Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89345CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7DE8E001C; Mon, 17 Nov 2025 11:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D04A8E0002; Mon, 17 Nov 2025 11:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5378E001C; Mon, 17 Nov 2025 11:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79D358E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:34:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F3991A01E4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:34:11 +0000 (UTC)
X-FDA: 84120646302.16.258E253
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C7ABC0016
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:34:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ym2TuohY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3f04baQkKCNg4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3f04baQkKCNg4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763397249; a=rsa-sha256;
	cv=none;
	b=uwqNzaJ+SVWXBuarhej6Bx+SY6KUjlaeeuB5IeoPTd9KXSbC1cB2W/p5YQFOp2zpd7qJwg
	sq8DQC27xHrrq9oNot7acBm2CcQtcYeF0HAkSZSN0x8IR+bb6fOhsHgZRWgtnWAvtFQPeU
	WW3MrcEMl6QtIC+b+3qZXE1hVs8opwQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ym2TuohY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3f04baQkKCNg4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3f04baQkKCNg4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763397249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnt6AMffwSDJMbW+9hMVzLqsThvI95BECbEYPsOm0UQ=;
	b=UkFbedsMgy+ohLQ609cF2/wMQh6utNeYdah2hh54Vh0Zax6Yx6SFjLjbyRmKt0QSYNnAxn
	q5q9QjlmSFkPFTRZK3bB9N89wtTwGClorTrizb7Aduwg7czICLvDEAlysMH9oF5BrXlUF7
	04et5Pz4CQAVacTT33sYgMbeJVkBFto=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429c5da68e5so2564438f8f.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763397247; x=1764002047; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dnt6AMffwSDJMbW+9hMVzLqsThvI95BECbEYPsOm0UQ=;
        b=Ym2TuohYYSgR9/AEAcKDQcO18veod58/f5x6gYODp/XzABbF8L4Ol8zJXUsyHfwfit
         EkqfZ1sFTygAMLtQ/1Y4iNmftcjgQweCS9q8LfEY72juUyS6HSfPjxke9xO9dbB4cvPl
         vVeCh3JrzKnVinffux6BMeRQsf6a6rrE+X9x4ds9etbEDycOBwnuN22/AKsKYA0oG0Cy
         vIV1f/bLE5TmY/L9xSw6Bya1dpOEHpvJfosD2fKqh9s2dtKwIYkdZuZlhlLbjDvpE1DV
         VmAshGzM8sA9MPaEvg7pky3Nnbj0rwOG24Y+32SbgO4zghf4aicnZVONtGBwzdFX+X4V
         VqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763397247; x=1764002047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnt6AMffwSDJMbW+9hMVzLqsThvI95BECbEYPsOm0UQ=;
        b=QiuoL007c8P/IpM83jo6PlRaoJ3K7oMzyeFr0KXO2CPxFNJRqVgw2JYNMn6HR+20BD
         fs3gSzMG66OOKDtHMNonl/EmSIvBzkPVzOzt2tPq5sQqLRZ6j6UZvmoegCJcrUIl2YBJ
         tGG1TmfgX1KNcAl9uqIhRETclsGQkCrpvLgf47zRaHdU/KV0wCj9v70RpzgmFoyLEqlr
         slpHaRvVyMNLedvJIvXs3+R4Q2gDFZKKU7/qV3QqqQU6AdpkJeXYXyJUe61OP5dSr5vz
         RxRhOohYfwuYxuToRHplBpWw5O5a/1q9WxFe2Za4Yo+9E28+15LRUjPWWkk+i+VgydNs
         +1CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpllz73YDt9/O9DE3gAzlFf4GIuaH3CS6Y+c1Y5Enuq0CJU6TMMNR8KC3vLE5NQhaKBLzX5u++bw==@kvack.org
X-Gm-Message-State: AOJu0YzdwWBO3jKgvEyFv7jtqfZrymCq+t1vUEFK9m+p8Vnn9DDhop2F
	KTyP8hsCwE9TlTL+7qYvKE4b3aNR0M+siatgVg+qWKUazR59BpU3y2T+iFUt6vqxb1XRfzS7EnW
	yM3IhjUkcoRCdJR0WbA==
X-Google-Smtp-Source: AGHT+IGf3SSTcSDNX35lGHyTDeVfIkh75oyqd6PvBpSYTmqxSNGCpLyaYAzVUgwUDnODNmGVYD8Jy8eTO5xF54g=
X-Received: from wrbeh10.prod.google.com ([2002:a05:6000:410a:b0:42b:33e5:ebb6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2911:b0:429:cc35:7032 with SMTP id ffacd0b85a97d-42b52821778mr17645835f8f.23.1763397247461;
 Mon, 17 Nov 2025 08:34:07 -0800 (PST)
Date: Mon, 17 Nov 2025 16:34:06 +0000
In-Reply-To: <8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
Mime-Version: 1.0
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com> <8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
Message-ID: <aRtOfhNjlCavCTjU@google.com>
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C7ABC0016
X-Stat-Signature: 5kucdcuqr9dy9axmg188i4arigawgf1g
X-HE-Tag: 1763397248-145041
X-HE-Meta: U2FsdGVkX1977WLiUU+ZQf1k29bAqMGBP+Ae7LrmBK7n3B+LnGEf1/HJFgUJS2Xekn//zan7yJO139c2HHKjuN6/BSxGHey7wkBKwMyZl0v5pWfYrdEyEO+VwPKZm8h/JU90p+1eVkC0YeUhk190KTb4ohM6+eBxvviEdor9WvUYJsj2odZqUSbqC0whp91SD1NMc+Md1VIv18aTMy4aq/PkhmXX3uyeppHwKYpoWuvxRqvEXkNt9+miJBMDxtRWhc957IqbiWFFrK/6+pmfZ4e8Ujp+DYtonoBkCG/xT38a4Mstb79/9tS8OwK9wEIeFdPVtDs4cAiyNsFxniwxxnOW6Li6zHskbLNlXcUW/CTDst9KjaNbsfWFRX7FN5e0rW/PMS9p+SPRMppZOpmk0La5PKUb8x4vWe16YWY5hJHi86MEofRPwdw/QxKTBlNuieD+RYGjhvFBfDlccoaFsUePZsfrpcgiOxCrRZ/S36yxkg0tnzTu5yyCW+Suq1d9AziT8thghJ2rcKATUOpeFQgC3rt1E77+iUTb/1VP+gStwCCchnHUvr5lGUgx/pHr5hSeYMbhTp2vcIRJFBw+aAXScY3DrVCN9Vk3lNE5DRIvhEFkSYS3zEqJlJH5VF3n1j3wfA6Vh+9HwHo04rHtlR1hvTGypf8m1mpa77gsm6i7IYbIH3QbQu+c0kRgQuqEXmfTcfuaMYxoNy8JYg0KCOM5BCLEDgetiCO7L3w1aQlUZ0EtNqvQU3YYnK4V58bl+PlOC7RSsIamuHfV8r9SwatuzdZIi5Bd9GqiL4nuIUd9tkCmN7um4EjLiSHqSazjbejJsgGnNt8rqQtNeuKHF/xruBUfDOojNdejtnOQKjWnpUM9ugg6gEwHqD/ipCHYbr5KOhMMx160SenTw8/Mhw6yvAba7rPjIdXRf7h0zG4QbN7w4Ir9eSRLOqGVR8yBh7A2h+Ro1WiubZkNISe
 zsYmSQ5X
 2ilbieyx1yzQ6WDYDOBMeFyrNNsP14MHuv1erm2qib51xAxPXpoBRMylZXe7VyPnK0BCrDLTsb0fyLJOE+cBO3EMijZiNWYBsw9Q11Li2kmKP7S0ekseEmUvElIHv2Jlvg1SaEt7bcKrqKnchiWWBUiFgHi0jUUiHqb8Of6qo2oK0f0dwCQlMJFF50fogCD48RYiBZ5YVLWFB1wPCrIpIEqXrovSnZ8a/WAX75eL6NEdtfk8ZfDa/eQuTq2/7rv4RoTa7J2plq11mKv+XlBDOPS6lS3BpD9PNDrPzsSdDlKGL+HpcVIssDMWtCRuXjGuRvzwImJXoZ373TYwt/4pyCVVoXUnXlRN0TVwE1PQUSJ5BiOANk9L080lPPECB+BlNpAp6ZaWEk1eYxVLPUnD5eChZpGhT6usdQc77/ORr3HktWW9yXCiQnhq2FGXnbRR5qzI/GHB/KyIESJul0Uyfx9yi7RF8tVN33wlSOFSmXuXRoxsbCZCDYhNedDLshTkNT+raGQm3GAFle8jqL7BikrpKL0NbWoXepwzfXZr9mb2Y0EIA0ILdRPdoSXGYlQG2UOyEvB/dEsiwIxgwF085gutf2/ovliIHhvNLU80Ie0X7cMu4mJyLNx5g+b5XHYbv2qgr7e/dYaB6G7o0J/Bk8YnoP82SKqh66IudL2h5B9e5zFH8pGf2yZJ0Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 09:57:09AM -0300, Daniel Almeida wrote:
> Hi Alice,
> 
> > On 12 Nov 2025, at 07:15, Alice Ryhl <aliceryhl@google.com> wrote:
> > +    /// Map a physically contiguous range of pages of the same size.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> > +    ///   this call.
> 
> I don't think there is a restriction that forbids you from mapping a region that has already been mapped.
> 
> If A->B->C are adjacent regions, and you try to map A -> C when B->C is already mapped, I think this
> call will simply return length(A->B).

I think that such overlapping ranges are not allowed. It triggers a
warn:

        } else if (pte) {                                                           
                /* We require an unmap first */                                 
                WARN_ON(!(cfg->quirks & IO_PGTABLE_QUIRK_NO_WARN));             
                return -EEXIST;

Alice

