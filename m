Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB15D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9333E6B0030; Thu, 27 Nov 2025 09:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2D86B0031; Thu, 27 Nov 2025 09:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D25D6B0032; Thu, 27 Nov 2025 09:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63E516B0030
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:11:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 206BC1DFA67
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:07 +0000 (UTC)
X-FDA: 84156573774.28.2385DEB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 18624A0019
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Md7AUvsJ;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+YJcNTnZipSTHzHvP7VT6KqL2agMe1FxyPDxMOqh5s=;
	b=Uc/w0M/appq555UmkJuSUomGglWW4du+kMCCi8QR3BTLsJq9rvHt2sH1MZN6mXyNsSd4oP
	bJbWzN9MJlnVJokHR9JGjf+7ja9UyREblVqid9z/UCiQGyj57jkisggADyrRhIVubR+xFp
	jLmXEFzZwvol+EODUORTrzkLKxlU+ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252665; a=rsa-sha256;
	cv=none;
	b=yK9JOilfXRhZCihaDRAWpulelJ3GAQIecqJTGNUawB45CQX3jpungNa2Oa2+gjU3Ikqh3p
	Hp5QbJ2Ia4WKWTjg13mD6FJUI1w1DoCCRMSsZPt/cOWLT5I2jTRApwwt0zYdhGn/P1uxPP
	AJSi4qr6PczliOkfC0fiGAPB+IohG7I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Md7AUvsJ;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=F+YJcNTnZipSTHzHvP7VT6KqL2agMe1FxyPDxMOqh5s=; b=Md7AUvsJZXv8HzqmqBQH9zMWlt
	055/vUKlYmH5uhcx9w76D7KXRwIntDZCeyCM2Yq63DAQqF880UbEIVMIZ8tIwaBxvg7sAWw/ypKF0
	9HbCKZbwd7+otQnKIDqFmnmX0VYdKlcwZ0/WbdpwqOza9AYAutIxsV9lZtFL/20c81Hbon8JI4Th6
	99OeCCUmiasQr7OmkQMF8QK8mHYFwex7VIExyOhnHSU6fLyZB19xKJEiNI3eUseO3fqcWoBlZz5Ad
	0tOJNa+SAEAml+PX0EKGRayR8W9ZXcbJ8s9smYXR7dwXVMqbntkA53/kXZDI1swQzZOr4DKzMpBBP
	bf4xIpiQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOci6-0000000BpO1-1mHV;
	Thu, 27 Nov 2025 14:11:02 +0000
Date: Thu, 27 Nov 2025 14:11:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jan Sokolowski <jan.sokolowski@intel.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aShb9lLyR537WDNq@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18624A0019
X-Stat-Signature: uw4r65degq65bdqazxd5daroy97k54oe
X-Rspam-User: 
X-HE-Tag: 1764252664-908766
X-HE-Meta: U2FsdGVkX1/g+9wZZ8LokgGplBYtFvwaGelh0pvgwekWJHnoRNCfVfKXtS1cZ2cY7cKAPF/lMMocWjTQZVIpa6C675oapNTxx//+yNTC065YwB9bKS/sRud1me+qQX97ScOecm7zEo1GRDySz7tkSWOsFAthjms0+0MNYIPyWRqzOl86rwSkWrta9W50ILsebt3oi2XltNqyHB8QmyYxdMg+9lpChJcxPvc+zz5rVyjVe1ovn9sXI7ZxdmTtyY6vKsATndOy3ebPZcJWuzHqEN/pN3s+kUr1bJaxB9Tu2QnntJXuDBA2kVQBjKv684Aos0SclIkrHplKk3kDkZRFOGIy01vR2rR4OxbCPiUwc0oj7h+WXbhouD1SCDBlA9HHNT/38do0XHTj5yGTMzZ7W9BReCVQM4j5nK6nzdC0eA5qIJGRmLQu4d1MMOMNZeRrklzQcjywHW/BemOHKbQt3gS65GBqnHUjvJRxHUOySBJE6VtJkFKLRrG4AwIl3xgfuoJ1pdi4TOapFyafTXNQzs15IRujJLPOw85fFv+vVqaoE2M5aiYaBrqBqx558hYHA0zA4SpU/+kYua2t9fyjnqL0QxREoZqWvAGipjmF4SsSGe0of1tTQ+Da4BCdUJcr+P9zUaPGh5W8R1L3P8Wvf6Zf25lXhjNqXKdhPswTy3sq1W0qJMIjpQ5lisC0FabDQSrNIn1Rxw8VLPgwrkyaWGuezGsLwdI8O5rJ2TypyPqOUD2b1repwOPDK5ogPZy6iyiG2s0rufXghN3ZdJQXeEzTqdfUEA3m4NSCB3hVfhU3+gC3TYIeXoqMQsUdLdK+Ami91vFtZlUMsXBjCsxWk7mRigBmFE4YRO2mJK9DVuqo+gZg2SIOHeizLn1RpiR0dDbt+lLsrViajrm/MZJymQsyathxK/Z6P88cv46SG0+jzXixQUt2YJHYBKf9wXy/tkoBnZ+v7c0jaAJkp/o
 dAysUBv+
 kQtX+vXDiU61VPOX4WyxSiq7wvpuXYMwBDeXIgv59nW/60Bn5KpJrdc3Y2rW/jzWvVuMKglinoa0i25J9JbeI9R5KWN58E2W15mI4qEygcidRDVaZ0gVv6idqTeBpHSTDYkaNzgZz6Hzs9bX5wKVETWqRu1qjWgVTzwN8hZDDRZAT4mfwiSQjzKRcliKJiEhycosn75V7hVGHCyDZ4i/36pFqoBY7435ilxAnT7vjx7tLmRxLR0O75TYbxmrXGH4K9gKQ8yC1xj82UlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 03:03:20PM +0100, Christian König wrote:
> On 11/27/25 14:54, Matthew Wilcox wrote:
> > On Thu, Nov 27, 2025 at 10:27:32AM +0100, Jan Sokolowski wrote:
> >> A scenario was found where trying to add id in range 0,1
> >> would return an id of 2, which is outside the range and thus
> >> now what the user would expect.
> > 
> > Can you do a bit better with this bug report?  Under what circumstances
> > does this happen?  Preferably answer in the form of a test case for the
> > IDR test suite.  Here's my attempt to recreate your situation based on
> > what I read in that thread.  It doesn't show a problem, so clearly I got
> > something wrong.
> 
> According to Jan the observation he has is that this code:
> 
> idr_init_base(&idr, 1);
> id = idr_alloc(&idr, dummy_ptr, 0, 1, GFP_KERNEL);
> 
> Gives him id=2 in return.

Hm.  That's not what it does for me.  It gives me id == 1, which isn't
correct!  I'll look into that, but it'd be helpful to know what
combination of inputs gives us 2.

To be completely clear, here's what I'm looking at:

+void idr_alloc2_test(void)
+{
+       int id;
+       struct idr idr = IDR_INIT_BASE(idr, 1);
+
+       id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+       printf("id = %d\n", id);

and I think that should return -ENOSPC instead of 1, since we told it to
allocate exclusive of 1.


