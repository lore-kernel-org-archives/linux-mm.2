Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB608CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176DD8E0010; Tue, 16 Sep 2025 08:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1276F8E0001; Tue, 16 Sep 2025 08:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C778E0010; Tue, 16 Sep 2025 08:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E31628E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:49:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 875E014018E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:49:01 +0000 (UTC)
X-FDA: 83895093282.16.594FB7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7D7AC000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:48:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vG3T6Zf8;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758026940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fprz1xZ/mcGg42/AgPY7FztcFyFx3gVlKE+V0o3eZVo=;
	b=Kv4wQa51gPsf961Ovylf6xe20qM87OBFoWillWnOqoOH6Xgd/Ixzo19M/MD9XOXJ7+qyWy
	Fp+ft3zvmVYtjvaT+Qg/HbQ3z8FxI7mfr0oPEWdr2nMyMAm9h0hgc5yWcPBhL1mZIUlKzI
	y0RH+gb4O6d5HohaYZQhW9UEO/Qi3pc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vG3T6Zf8;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758026940; a=rsa-sha256;
	cv=none;
	b=XnyTq4bAVktXt3V5oRC4AUdkxl/jvFxCl7I6yl5TVui3nK5ffvdWhcGHeu9Oke7jLACDNY
	7H8ogJML/V0R97kuQtkTlx2Gzp8opJPdLNQ3XiUrdnpRj+QKRiGV3R6F/Fc2oQf6hDYUdJ
	gAVaG0s/atHl53O18IhKF4OxvHR5dG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF104385A;
	Tue, 16 Sep 2025 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E8FC4CEFB;
	Tue, 16 Sep 2025 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758026938;
	bh=4YrNCsR+tG6pZaieZYZjT9mkupyBVaPEFfVB53YgEk8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vG3T6Zf8eW6m6XVKvRviu1cHQLljMJq5lwAFbzIkX5FUvGZ4IpWXPGB+bfYW8Opw+
	 x+2weGhsEjE6UQyH4e+9ijZMK7z7o79BmY6/6ylGHainjNYeL2+p+ufqOaN9Elhptk
	 a5vP7PNrFKMzSQYZDyzuYtHHJ1sSxIw3JmmEo78UwhABYMMSaUJZKTZ9pX4nEOTLf5
	 gB/PKSYEaJen/ooKrHcipAnXazTz3u27GESDjb8ZV/ByfIFKApWEsXPM0FirrZaNO5
	 dLT0zncbTLr1XqK/ibIDwWC3ARmDV3C6/TR03oFFTVLlRb4KKj5S1yyISWRJELS4pe
	 vbrsWgY0cJB5A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <me@yadavpratyush.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Alexander Graf <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,
  Changyuan Lyu <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,
  Jason Gunthorpe <jgg@nvidia.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc allocations
In-Reply-To: <aMgey9qEC_XUejXm@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
	<20250908103528.2179934-2-rppt@kernel.org> <mafs0ldmon784.fsf@kernel.org>
	<mafs0ldmnlmq0.fsf@yadavpratyush.com> <aMgey9qEC_XUejXm@kernel.org>
Date: Tue, 16 Sep 2025 14:48:55 +0200
Message-ID: <mafs0bjnaimvc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7D7AC000D
X-Stat-Signature: 8s89tf9mmspb1ryoh4rwkw6kimcnijft
X-HE-Tag: 1758026939-829781
X-HE-Meta: U2FsdGVkX1/hdqsSMjR+J6YqocXAAoAzGEkX3yyH0XbgGwekEqCdzBpY2Bsx325pQE9Duek/OqJMC16DwuikXDlWqMDsOSfEIccsLtKpA/iSLeAyffDbpj8hiPQLD/L+cu8jqIFHnu73+8S5zQQVAH1aoYpA3zm/NRjxIzsh+YwztdeGL6/StY6+/dW2ibXRRLwbCuHr8dHyqYBP5CKdMhoa/+YWvIGdYeIdCGU+cQwnACJayGOHgCJMssbi+RyA5uuLAV7RGZKB0imx8SL5OPNLE7p6GgmdMhMRn/NMm91YlX8MhTaa/3/IXLLV80R/E/Xf10ohChx08linXlirSzqZGOYo5UiVWMIslL9zh8thbAnU1kfIKrag9oILM5H2b/hJ3r4AmreSXMyyAT7PNxUBpjo48M5pJHDHYeHA3H9otPRJEdWjGNxPn1UM9Ek5RTD1i9tw0WEhq1vsbob+FTL6k5DNjrDg/9L+YBcGOpfncycXyi7xzX48dod+0eSyCNQSts2Kqdy7L2Zk1UgC276wf35H3kvRFxSn1QhM3k00GjKogb15OyRNdwEwmALLzbYQj5S2B95WqVoDeiLUXJPU7+sKv0YgvUSpQQDuvndL+zbB5iIN7nwLJzZwmonHXRE6XA7r6YPYQ13G2M01t0KeojTcPx0Ntg4whWv9PoRjWjjz583CacDo9M124mkUJ5GqGuriuADGnAWBWD0kDlmJEnlR0o2NXfyNm262FhZV1loEJhROWgb93TuRGaMdYIo5P/hZOj4iRLRfWXCCC+C6J/LQS7o1Id1Sb1M7Es+AljNqGxNB2b78u3CBkw5SE/X56igWu6xJguBDLvB8Fsf+386LBW923QCW2mXm89sHn3InV/BjmXxFlevIGYqoqmGWr5RUyuOP5KWxbIB2l6mrroiGJXHYRK8n8g5E4sEak0X8W9edPE8p+m9uZZshXtbyF+wJbJILEQz+Y9u
 HOqGhb4O
 ggOkDnDWu0e4T/2WfJprUDclk51qukLHuFI6yM/EuOE+EKLWKlCiHWvJbNb+8MNYiLsZ9QHjQ9Ur6uc5nW83mtEeupRuh9I/giWYhQsxiAxV0HUwHoIcNYNld5LzSDXE0/1Eicf/v+HUEFFAPvVu6LQaMl7WtQPIzc4YxAik4WGggjdpm/RC75hRt06MFpS8V5sq2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15 2025, Mike Rapoport wrote:

> On Tue, Sep 09, 2025 at 04:33:27PM +0200, Pratyush Yadav wrote:
>> Hi Mike,
>> 
>> Couple more thoughts.
>> 
>> On Mon, Sep 08 2025, Pratyush Yadav wrote:
>> > On Mon, Sep 08 2025, Mike Rapoport wrote:
>> >> +
>> >> +	while (chunk) {
>> >> +		struct page *page;
>> >> +
>> >> +		for (int i = 0; i < chunk->hdr.num_elms; i++) {
>> >> +			phys_addr_t phys = chunk->phys[i];
>> >> +
>> >> +			for (int j = 0; j < (1 << order); j++) {
>> >> +				page = phys_to_page(phys);
>> >> +				kho_restore_page(page, 0);
>> >> +				pages[idx++] = page;
>> >
>> > This can buffer-overflow if the previous kernel was buggy and added too
>> > many pages. Perhaps keep check for this?
>> 
>> Thinking about this a bit more, I think this should check that we found
>> _exactly_ chunk->hdr.total_pages pages, and should error out otherwise.
>> If too few are found, pages array will contain bogus data, if too many,
>> buffer overflow.
>
> Sure, I can add the checks, but it feels superfluous to me.

See my reasoning in the other reply:
https://lore.kernel.org/linux-mm/mafs0frcmin3t.fsf@kernel.org/

>  
>> Also, I am not a fan of using kho_restore_page() directly. I think the
>> vmalloc preservation is a layer above core KHO, and it should use the
>> public KHO APIs. It really doesn't need to poke into internal APIs. If
>> any of the public APIs are insufficient, we should add new ones.
>> 
>> I don't suppose I'd insist on it, but something to consider since you
>> are likely going to do another revision anyway.
>
> I think vmalloc is as basic as folio. At some point we probably converge to 
> kho_preserve(void *) that will choose the right internal handler. like
> folio, vmalloc, kmalloc etc.

Sure, but do you need to use the internal APIs? Because doing this way
would miss some improvements for the public APIs. See my patch for
adding more sanity checking to kho_restore_folio() for example:
https://lore.kernel.org/linux-mm/20250910153443.95049-1-pratyush@kernel.org/

vmalloc preservation would miss this improvement since it uses the
internal API, even though it will clearly benefit from it.

-- 
Regards,
Pratyush Yadav

