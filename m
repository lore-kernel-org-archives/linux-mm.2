Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732B8C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487E06B016F; Wed, 12 Aug 2026 09:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410CE6B0171; Wed, 12 Aug 2026 09:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3008E6B0172; Wed, 12 Aug 2026 09:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE1E6B016F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:49:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B505D403ED
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:49:05 +0000 (UTC)
X-FDA: 85092748650.25.A364A93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28DAA160003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:49:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UexFnpIW;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OenMr5nT85sI6+yUZ5su20Q5jfaEjzyJzi9hJtpz57s=;
	b=lcxZR7UxC/3o0f2g7AJrZoZQkvIBcoZGyUAjl6u4jzFuWbCLUkNSBRmsaIG60q1a8YBZyy
	KcKHxyHOlfxOn+l58qS0UndWU7zMO/XePWvN3V/yr1KscS3fjxZzvkRZf/aDba/Qyd4fAC
	VFHxubUICu0m/nZLe8USTPjZGue5TEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542544;
	b=rLX2DJ2rRl6dUlfzULLfqw2pwAytQxr785XDt6n1/bjuhgWTE8KphfNCXSmtFC5/pPhH/X
	0CI3wZliJ8Znhs+c+pck0/gSXZGJ4bSP5uIbwWjBbRFCc6tBXu/SOgRQbTf4TutsjQClwt
	GozxI8amxHnwHavkqy7NH6ednuHQqdA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UexFnpIW;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0F6360A9E;
	Wed, 12 Aug 2026 13:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9664D1F000E9;
	Wed, 12 Aug 2026 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542543;
	bh=OenMr5nT85sI6+yUZ5su20Q5jfaEjzyJzi9hJtpz57s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UexFnpIWk2+YiBJrt9VA2Sfiyzo5Isjw4CnK/CaYnaL2+bfwDCWo7W7E1fiiHF6bt
	 NTBmKRKR2t20kh915uCjvT6d2N1ALd3LLMhii3XVXwSAYBYYoyYEukDPCAldIAf4vC
	 sEHEObdblFY4n+akVftR4rtv4qfB3ZSFuSROdY4gQ97JnRWwbMtamPLobUoM9FYUQY
	 SWpAc1UtsLTNSBn/HA5nd92QIvNPIGFU3EdPkhcSwama+ZcyD4fijjoSsJQE3Mt+3n
	 frnZA5FzMSQWct/bezhFsRc1DKWbD8pb6l2s01bXo9zvXWRJMMZpHvWJur6a7N1IPe
	 JFnGvrKJyIeFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Samiullah Khawaja <skhawaja@google.com>,  David
 Matlack <dmatlack@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] kho: Introduce preserve/restore APIs for
 high-order pages
In-Reply-To: <anxrM6HPKPq74So3@google.com> (Pranjal Shrivastava's message of
	"Wed, 12 Aug 2026 12:46:43 +0000")
References: <20260803113944.3694290-1-praan@google.com>
	<20260803113944.3694290-3-praan@google.com> <2vxzmrur3880.fsf@kernel.org>
	<anxrM6HPKPq74So3@google.com>
Date: Wed, 12 Aug 2026 15:49:00 +0200
Message-ID: <2vxza4qr30vn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: 7xc5wum48ziimp3rj7gse1kjwpbdtm78
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28DAA160003
X-HE-Tag: 1786542543-587492
X-HE-Meta: U2FsdGVkX1+e+hptjaJrULe0hsJ+VOpGs6E/hK5tJz/GBLgsHdKVahJqUBektR3NYL4YslfdWt2AoASmaMpCk1lEgvqg/ZHPVeFujkG89gMiCpBEtZp3lxr3Hk0r2Oa5BBEPqhDUxyTRmb5nsh4xXeIPVlwz3Q3sKKA5yUHLNYPFvVvGiE6j3oeZZBmZVDDxA/K+OTBVgUCfX1YQ67zArfQj5eTzZQUIq7Y1guy7GKRjZ/keuu0CWd+ux1WQeLpK3yI00M5hnU4kfWE5gnTK5cO0nRPwOqHBeyvT2DRpjYFlx7me3sJm6L6g6hOW+MrgbJqS8A1njvPsrbx/zzyvvd9o8OUBmBT97j27YHznUeADvQhksIH8gMd35JZK0KTEvB2iIWfVZ1Hwkm9KPSUvMMcg2fI0IZD9VI2WrqlAh/QtDSbYi9bxuKHXa2HM+QsAEudf2s4ymRBOxBzusX6ftF7ktom5ctqFXq/1mpiovIwc4fmccgiuHhVYQr2ckA66yI+i98KRDcFuzydXwrlXaH3xowyFKyfiGWGum0DKaF5RuMor7zY8cwNjNjrADdYasZhxmZS+497l4QqqwZ6UJgL8oC1EcZmp1+HXB2K3W/JBPfZqULRwH3uKWFMm+zbyKNu3rZ1RWfcJTS3gCvMytiGWqEQ5P41ArrVWJGcz/VRUBUEUU5QbszEG6rY4iiytwPS17aPQS6xCFnN2Rcmr18SyMd7oRFgumTF6ZMWxm6SlnbuO2bb2LwDKa5Q4XbatAQiVopreGY4iD7MS/ZWffjrVB/ENp+ugmxC6TjCF1TEUOVBon/rUa9VPu69wzcAwsh82Xd6jFsHKjBmW6nB6II7AggZCrX9yogIxIoFhreeqTjee8ZWgxozabN9ot5OMbBNQQQGNkOSYYkktufzdjOto4kSskEnPSOXfdlytOrYJMJLiUABJt5Ko/xu30+3PPclMW+Y9aNP9/vxWJ3Y
 jwJyJbPP
 xI7D0L83V6TU+an+3iF4vVzHtKJRCbBNwcKoWxeCabuehfQbsHQpIAtD2Ui//F7Dst9O4rtIMf2CKSkmwl5MXNAV+y81xJF7b+5DbO+AK7V8O9Qi6behuUgtB7nSM83k4iOLSiwPWlQBY3BK6UPMobHGmueXu/qHwJEqsMUVeLNfvvV04WhTDvrjS/K7sitKwO6qzZlebM1vottYO9SVdnZXtE+TEnQY7LuxQJJzEDfeINUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12 2026, Pranjal Shrivastava wrote:

> On Wed, Aug 12, 2026 at 01:10:23PM +0200, Pratyush Yadav wrote:
>> On Mon, Aug 03 2026, Pranjal Shrivastava wrote:
>> 
>> > The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
>> > that multi-page blocks are split into independent 4KB pages during
>> > restoration. This is incompatible with high-order non-compound pages,
>> > such as DMA buffers, which must be restored with tail pages having a
>> > zero reference count.
>> >
>> > Introduce explicit preserve and restore APIs for high-order pages,
>> > which preserve and restore a high-order page block as a single unit,
>> > applying a refcount of 1 to the head page while leaving tail pages at 0.
>> > Rename the existing internal helper to __kho_restore_page() and
>> > consolidate the common restoration code into it.
>> >
>> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
>> 
>> The code here looks very convoluted TBH. I think it will be simpler to
>> make kho_restore_page() only return non-compound pages. That is, it
>> returns 0 or higher order non-compound page.
>> 
>> Then kho_restore_pages() can call kho_restore_page() and then do
>> split_page() on the page it got to turn it into 0-order pages.
>> kho_restore_folio() can call kho_restore_page() and then do
>> prep_compound_page() on the page it got.
>> 
>> And then you expose kho_restore_page() to be used by DMA APIs to get
>> non-compound high order pages directly.
>> 
>> How does that sound?
>> 
>
> I like the suggestion to use a single base primitive and mold it via
> split_page() and prep_compound_page().
>
> However, To implement this, we'll need __kho_restore_page(phys, &order)
> as the internal base primitive because callers (like kho_restore_folio)
> need to retrieve the order from the KHO metadata to pass into 
> prep_compound_page(), and a raw non-compound struct page doesn't store 
> its order.

Oh, right. I didn't think of that.

>
> By having __kho_restore_page() initialize the head_ref = 1 & all_tails
> =0 refcount pattern by default, all three public APIs can just wrap it
> and call the appropriate MM subsystem helpers. I'll spin v5 with this

Makes sense I think.

-- 
Regards,
Pratyush Yadav

