Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F29DF8D774
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F316B0005; Thu, 16 Apr 2026 15:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF66D6B0089; Thu, 16 Apr 2026 15:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D946B008A; Thu, 16 Apr 2026 15:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA9256B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:32:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6893EBC032
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:32:51 +0000 (UTC)
X-FDA: 84665416542.09.B292695
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E051B40010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:32:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rw1vIfWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776367969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92ERkl7IqZ3D3ZBskV2Dg9cLo0xCsyjyPbt0J7jJ1bo=;
	b=6P1REm5aCYXQByCehFNYZDKDIvi47E7MnK6nPlorkgcFpVoCskWM6owDD2fd7helW2Hge7
	jOwGNGipjAJY085/Naw85jDde9NGjbzdfakrVblnzkxhef5Ym6GrwamATrQGtZMNBltjk/
	qlZbo93tDSrVh2yj5l3Jpdus6RwWwNI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rw1vIfWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776367969; a=rsa-sha256;
	cv=none;
	b=8KV5ehYbfEw7QRC9UTTc8nkVTM+JN2uK04U7UKuMAw2spBF7vNqsRaQgL03ahFom4PBFWk
	38RsCG5NRSTUylC6VkfaidVV9RJc6Xmdq+Wd7xkM0FgcvYXSOpLinVAkYJqEXOwYZfbWND
	87AfpFwLuliDP3cyg4y6TJfuVO7K7vI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CDE860128;
	Thu, 16 Apr 2026 19:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E8AC2BCB0;
	Thu, 16 Apr 2026 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776367969;
	bh=92ERkl7IqZ3D3ZBskV2Dg9cLo0xCsyjyPbt0J7jJ1bo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Rw1vIfWy5g39RTrQBVfk7P8+0yZErGWNG5UA9/vEtpQjlFkvwDTSfy9DcHen7/CI1
	 yvB26rPsstyEixHeRP2kRFTYsbED9hoqdAx8pp9JCjVGtqsECj0BmLbEADz/j0Ea1z
	 cuKaCVwjWLvXDg/CryubhnWhKyfuiuUjmH8fhvqeL/w/0cvoWWHyuhgdCpeuqDPtkC
	 KhOKnJGX3lMBUei6zDvHwn/e429dg5HpUaKZZFagDf5a9Cwpgy1mEmtIvUBtm2UV8a
	 d3rsfZkg4WL5nt8ssrtLumcRxpUUuH7CR13mk1NCsH3yKQQbT7v7wh+ISgR1TJLd7z
	 vH5LnF1y8pygA==
From: Thomas Gleixner <tglx@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, Bernie Thompson
 <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso
 <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco
 Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
In-Reply-To: <0758843e-8f75-4c82-b9c0-25fab502e62f@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.045532623@kernel.org>
 <0758843e-8f75-4c82-b9c0-25fab502e62f@kernel.org>
Date: Thu, 16 Apr 2026 21:32:45 +0200
Message-ID: <87v7dqem5e.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E051B40010
X-Stat-Signature: z4x3ibwpr6hpkefjmhdc68dw8uw3epry
X-HE-Tag: 1776367969-31075
X-HE-Meta: U2FsdGVkX18iDGJLi0TdP+whKOFNKscWBvHPUtLKav0nQqVx4N+L0htM0bvwit81ZxdE8wDw60FA4Z9J0F1kaWS2kT05wcCp91VsMFW0Ns+abN+jiECxB7aqx/TXFALfeRR/gwpcCIWke7J68nVGtZZYpJg96A/dSJ0aQdvdZAFOG//ugBKQCs8m5Otf06CpYBrw/9Kasm6GaGLrLF77oDOam+Ul9n3567UhW6KaXhs0V6r4B+eVoG4UKiO7uaIjWe/h+iiRN0SiqlbUTcY1+ohj4RdrUKgTgsfKj1cfhjdUXGUiwyYGcVg7W9QU6rBCECFGY9PSxgl7fd62EfRFO5msZ5lzyx7J3IaB/kP5gA5w04w8aTMm5vlxWAn3vzr0wH8YhB6hTsKUWrQuugjUIfREtLBKtGgbk/MttdY5s/zg/mNrtvc/z9zR1jd2Vj0bxV9hjc3O6Bmtl5wKQ+szMwoainJtxSNE0dA4r1p/tb7NnCzgNlkk8p5X6tLDIUnqYq1Q3J9ZymtLCJAYg2fCEwE3Vm8XMFoPUCTX3BQBYowJDseeIZmwOJ2R8um4KlcXLsPQrpeqPTYssyyhh1vLzyfLFRJrBQoqQeyrKkZmKREbRvHM5ubAj+/ocWPE5d1zN8CTh/DNfT7L79x7n/0INsQ4yADxeC4l5lIFvxhS/rJNP+kALDsquHf6vtLW2T9hYFvv+4QlRqOGpCgpbDtXgt2DKGpioX/N9cIoMqvuAlXNZmwUssy77CJYT3YltqtXVF/uuB7Y9dW5TZzJaOKExtPCwljT6A4cxqX9TGXyFEwI58Nglf12uqiNcCt2AI8L92G8uLRxNptNC5z3I5WcnwWsOGt8ql4QnmlzUjngiZIeyfyApHYs4JuODQpJl6YsbCvK8wmZ4uHpCHD55YojXvq2TE0bGi++S6tz283Erp6FnbbYLO8eTMUD3IOZF8KeyWm4MK35nKnQPtEatl/
 ZPNhu+Xc
 +gRSMhJargU6ftFeVRBNY56md7Kwz2xipPelwZH06VwPB8o4hmk0rt1VqB0lSOsxDdwccLK4WfJaxwceE8Btgcc5c/EIPr0B3IGfk9MFavShjmXn462twd/cEdf4KUBMxoTT2yEAqg3C6hp4AKjkYXSPEjjhhq+qG4SBJcrF0+PFntG6Vi3xMVkgGHdNKtjrxmzSjLPHnMXTm7BmKAa7gh3reaHiulfSxeL+DsPB6kBhqWVf989gfwBNQftcjAYbE6iF3fw78cB0GK89L8wbUkR2yd75ds+GXp0rhm7I/rbIboFK1OhXL7tNtxmMfWa9Ro5aOJgx02HNkvks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15 2026 at 08:43, Christophe Leroy wrote:
>> -typedef unsigned long cycles_t;
>> -
>> -static inline cycles_t get_cycles(void)
>> +ostatic inline cycles_t get_cycles(void)
>
> What is 'ostatic' ?

That's a really good question :)

