Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C3FCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854636B0005; Thu,  4 Jun 2026 03:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDA86B0088; Thu,  4 Jun 2026 03:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5716B008A; Thu,  4 Jun 2026 03:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53E7B6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:32:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0EEE140657
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:32:44 +0000 (UTC)
X-FDA: 84841413048.13.3C380B0
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EE2440008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:32:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HWzBCnC9;
	spf=pass (imf04.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780558362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QeCUKmkVy2NrZVi3REONjZfBBnfnlNmwwM3gXjDs+A=;
	b=tDWySIuYMpOX1T/L4DgUhfqSVfbW4aZdtU20lc1H8AXCxhPlO8k3KN2aCtVhXjbu2SXmbV
	AV2EKiryza6bxwqXnq+YVY3lNn4fZvmmFUPj8mx1iuh80Oad+6mIFQ3Rg2QcNq35o/mbrm
	2WdSRDMon9U5YeLcB10HSUfeo5VtUO0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780558362;
	b=Qp0eWT0Gmss28T1JDZvP2zBqyyBxJWYlwXwVCH6sfK699lHEVBDbaha6C+teQifbyqajR8
	TCQTFCAWAHdS05qV63i8kmA33d8BQJLpnrhdN1eajKaz3kMVFoHXEo85fmFO4Hzq/E8+s2
	4P7eIGovISVkliUAkrEQ5O6+eOLXluw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HWzBCnC9;
	spf=pass (imf04.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68acf0a15b3so546114a12.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 00:32:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780558361; cv=none;
        d=google.com; s=arc-20240605;
        b=Wwm0I8WohAUD8a7dLj55kb5AaRcfMQq2JKHwf9Ie674ayn0ozAaQukM6vvV/iWNJOY
         wk9r2OZ6Bmat0kLY1UgdTa5ZYh/8i2NrpgSBPP6Ic3aQIzZN5deIGf5rjbe3oulsnrfz
         QWApS9Tu6Lf+ymzWLp8yGjB7H5aHZVUrHBXaml5DHtJukEYU/SHHtCuAld0w9i8metq1
         KXreXVcdSF/LGu4XpfGWgZzyUrV8i5FKqRyp8nhz5EfuE1fCdO1TAe2q665M96/9DCkR
         3goyuhifBnHetT0EFRHgPJlHPG55znzYQmamAMq+NRkX1/FQbw4cG1C3KFw/XzynpqzG
         bqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8QeCUKmkVy2NrZVi3REONjZfBBnfnlNmwwM3gXjDs+A=;
        fh=7HzroyLu2gypCt5FSbroIiQCMS9yCOAR5pu/QqRl7Gc=;
        b=aMWfW1u6AzCVdwbVD6hL7maTLfuC1fNBFHw1ZxHxKIyUxcSRtXWyBmet5/sEruuNAb
         cy4i8SmG1zOm2nZ3Q9zjSe/VHPnQdkr7kIzVcVKfB7U9gwhNlBQx5AktkCYpvcyLTTkn
         3GyWJILvcafC5GwqDdPW58sTmV42pxIO9cDrQKPe3rG4G0DXeGDeWr7io0jZFvnHbaiu
         oEXn5Gj9yNmp0pMd+FbzxFk55+yUIDbRj5QIO3P7QHa2GCgT7owpMaM/mvk0jnzbE/4n
         ExeIrr940z/7ETdUC7TTbed7ae+y11DkEJ0fQQSo498OL5tTfkrtbbq5tnTgZ2zmYqTO
         PJJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1780558361; x=1781163161; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8QeCUKmkVy2NrZVi3REONjZfBBnfnlNmwwM3gXjDs+A=;
        b=HWzBCnC9UqTzS2WMRx5skXfQmvPeOJtzr3wIviVdlKO2OQdKpuT+eNguHqIJL20OaB
         bo7Aitrs9+HpwAbED9ZxeenyrNl/hq4fVKf5kTGNV1/UoTyl+e2oWVQCNylNmHo+FO6j
         WPmPMPKEsLTouR3Qu5kETeIrhej57i6j4jtzNVLnrgaJ+a6RnnfxNgTAAT5GbJInY7wd
         /7QQjvY5sOLaRTi9XcKvRx7njGF+1prnNgwg1Yy8GNFgqBBLhlugthXWAdKEIb9PZ1KE
         74r23WvpbHFfoITgURmYHk37lIh/aVGLEh8RWCINR9F+C0E6H5+xzVJ0Lq2w0PZ+ytWm
         V2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780558361; x=1781163161;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QeCUKmkVy2NrZVi3REONjZfBBnfnlNmwwM3gXjDs+A=;
        b=FaY+cEYZoRcB1Hs5XCOuUNHJxfbWkXIkYCSWWYg6STR/O2d8US+H1Cewxsxhjo08+H
         Prl4dh5KGZ6YifxkX1cq62st5w0A142jkgvH6oU41wQTiuoNN5bfL3FjMMz8oSIB6c0D
         c+gN71g2QW/14G7FWaW0nIwib7W8Qm7cLqLfte704Hdqjj0YTL3eopp7GhZupblXVbYo
         rA5DwaGDPCSsoVBVw68kV5/wTel7o30s17+a2W4ZzxKhNRCeEhNQI0CRM8OWiV6ft7RK
         hkm+QGWobGr54uwQKrB3Aib1Sm838O3wpw3SGoU5NFkCMH0VYugkRSvI39fzG4KIKKiP
         ZjiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jMMFF5+8WcC49jJXoIBBBQupUkj1dxD1c1LRc34yi+5mdLl99SsKYrTN0UKBCHjh1V3LNkXHfsQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5M3Ifryf3U0JbDSyiMqGFyNeFSc/SPg3im3wvYSR2eYfBi6uF
	u269h/jXq8ImBN0PsKav5NLw1a5KgJ0EyyTMNyRSxEBXBe34zBfk/soGfEVaZtwdKNrk2hMrzAh
	e/Vdw+f5VRhbauc4EFHuruNP6GRlty2qTa5kICLggWQ==
X-Gm-Gg: Acq92OEaXgzV9+58ZjhH/HIBiF7CJlBCj79DHTlYNyWIx+qUeHXpCrLFQ2i7R4Waw4F
	c/ogd9zXqA2yrL6fk/8+miC5O2cjJZS7GPxUx/FhRv8YsQigj40t+mT3Rl17z/GhGCxVvAr8EVv
	JBsbWIlec+yII1Fuqpv3Bk0nyo/7lpq0bamTnWCiR5xXh0e9eItK/3iz6jdLs2/OTsLgh+XPIx3
	qCbkN2EuLoGkPLdcoQnvxqWxf9/4ie8CbIzd23LiLSOzHhwCVPBThZ5F+ROfWBpKB0MQDsOvMqo
	A4EXJ7+B+GT70R8t52tSP80IHa3rjgbh9s1r/kgRP6oJbI8=
X-Received: by 2002:a17:907:8e0e:b0:bea:4c91:fe88 with SMTP id
 a640c23a62f3a-bf0ad204057mr309239166b.18.1780558360935; Thu, 04 Jun 2026
 00:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260522225853.878411-1-tjmercier@google.com> <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca> <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
In-Reply-To: <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 4 Jun 2026 13:02:28 +0530
X-Gm-Features: AVHnY4Iu3YbvJ8smZ2k5Oglofp60PZLnbqbe_g3OJ5J_F-575g430amKBK4ebP4
Message-ID: <CAO_48GGCdU6znkdHW5gns=s+N0wtNAq4U8s4OtLEyW6Y73oMUA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and set_memory_decrypted
To: Maxime Ripard <mripard@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, 
	lkp@intel.com, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-s390@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9EE2440008
X-Rspam-User: 
X-Stat-Signature: 9zeugjfkxu9d8g3yrpk3pn7mbiq8mjij
X-Rspamd-Server: rspam08
X-HE-Tag: 1780558362-358648
X-HE-Meta: U2FsdGVkX18IbKGFmvpf7zcMKQKIomp6VrYYLzfB9J829LP8Dak5ynXwSq2nDVgWWerDpQYuyi8LNFQxEeSE+f85KBrngC7Phb419RNx+OBBdAgjhe0hZch2XQp+LC6Cb0gCOw5J9+aZC+zHHmVWecMtFnch2pnjq+3l2B6W+ffSVndPWH0j3MoWmk1J3+WDT4oFO8TURlIKv+6fiC3LnAkP57UbC+jxXZsGSMiX/+bBs8QS6esiSJwg3n7f1iEtyT/UY9NnNwIX0nlmn0BinEZ+2XqnBOwxnPk6mxDaZ+SwwySov7j1l7Hy1ATI+GgDdhXOi5qIzRorRu+TX1NTZCeBfJS4uvTWWkuJSf7418cNbM3i1SXWEEcIsU7ckd7NN8fv7ccmXv04cavGNQSv3QhtGl5qsOAYiIUR3g3Yabqz/mDv0zcXSxVFxYE+Rk25sKgeitHpPcF4d8CtCJpYd45iiiCfjkXYWefj0TkakKg11cxCvDrLLkFQod98Xyum7333pt2Ys4cWqp8Ui9isko1Ef+uIw3+cstxw714uAlFcVixnDuENKPXUBXaGLDkEc+v3uNL4Jentg8x+mK/iFY3d5yQq9q5ZD3mdE0CAshjfwB70WAyV5XCtYAhGHYO4tLg6MD/E3JsGcEO1gApd39WHNDD8XNVvuyJNRuAlR/Llv/ZfyU1LnknXtdHA97h1ywpOjLGvxkcAycCE5jO01PDmNSc/6emIO0w7uzuE+gmdwuVn++DPwIr9AVSs/HoKNFgO4AphpaPvlsXJXbMZGmbtFlJLLvkZY2t8dQy7ZdjL3ABULC5Vnvq6/7YVYqvRQvXOnNlgbJX4v1UMslcikD7svpHb59SuYbiPiJoxbSkIG2hdifPKI+ROfXBV+gNmCjHB9DubEOtKXltzUyX7iAbTYTlgEWHkuYYV8bc0VS8amaiPdBJ0gmUCcuVXZUXXzFpfwjUWLXtTauLqMFO
 MwDk9slp
 knLHe/qnsXJy+dSR3WPBncMW6YcppMcTT+NqHAGX1Dlb1a8+FQp+JJM3We0dZ1QnuBUDFepwyHFqrt2ofMvhy9N5uWLBI07vV379EQhAkc/Gb1YKjNcDj6Bf4vmAoiuMqdDEDjL5hEq5u4n6FbM2VMgiNUBzpJor5Uwpj4UWaOl1y+Wi7FQEvMZl72SYpVKWx5sFC7Eu7wArwYG57EHGtgk9YwYrYNcZhszYEskiueOXeZOAfbuEBUwcH4gpoYV0Gpps+n62Hk7ic5AA0A2IWokCqNFoXx2Ymqj8+0tHIJMiQ/LgWE3wLuSyckD9oX+iaS2uRnCiJtNubKg4qwqivhMb2X6SXCHArUFyRT8HH+S0WdQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 at 12:51, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>
> Hi All,
>
> On Thu, 4 Jun 2026 at 11:04, Maxime Ripard <mripard@kernel.org> wrote:
> >
> > On Wed, May 27, 2026 at 01:07:16PM -0300, Jason Gunthorpe wrote:
> > > On Sun, May 24, 2026 at 11:21:33PM -0700, Christoph Hellwig wrote:
> > > > On Fri, May 22, 2026 at 03:58:53PM -0700, T.J. Mercier wrote:
> > > > > After commit fd55edff8a0a ("dma-buf: heaps: system: Turn the heap into a
> > > > > module") the system dma-buf heaps can be built as a module. The
> > > > > system_cc_shared heap uses set_memory_encrypted and set_memory_decrypted
> > > > > but those functions are not exported on powerpc. This can result in a
> > > > > build error like:
> > > >
> > > > I'd much rather revert the above commit.  Yes, x86 has exported these
> > > > since 2017, but that's a really bad idea, and we should fix it instead
> > > > of spreading the export.
> > > >
> > > > Setting memory decrypted is a dangerous operations and should only
> > > > be available to core code.  We should have various allocators for
> > > > decrypted code, but not export the functionality to random code.
> > >
> > > At the very least an EXPORT_SYMBOL_NS.
> > >
> > > Looks like there are about 3 modules using it already..
> >
> > So, I'm not really sure how to fix this now. Should we revert the patch
> > making the system heap a module, or should we export the symbols for all
> > archs?
>
> Given that Christoph's objection is not really about the modules part,
> but that the set_memory_{encrypted,decrypted} should not be used here,
> one option is to revert 78b30c50a7ac until that issue is sorted out?
>
> Jiri, any thoughts from you?

Argh, I'm sorry I missed that some modules are already using it. I apologise!

Christoph, is there a way we could accept the symbols export for other
archs if the arch maintainers are ok? Heiko seemed ok for S390, so
this needs agreement for powerpc.
> >
> > Maxime
>
> Best,
> Sumit.

Best,
Sumit

