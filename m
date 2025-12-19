Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B89D78798
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4206B0089; Fri, 19 Dec 2025 11:09:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489896B00B5; Fri, 19 Dec 2025 11:09:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5C56B00C6; Fri, 19 Dec 2025 11:09:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3266B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:09:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD074587F7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:09:45 +0000 (UTC)
X-FDA: 84236706330.23.540B8FA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6D7E8100012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:09:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cQPXOwId;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0mjmGpOW60lNIbtFI+r1yzZWjFojlQMo6AcrdT+eeU=;
	b=MtX3zvV1vV7xBZZk4b+lI1GQw2M/t1Mas8HIpoCtOOKsrFPa3pSodN9tI0P+CWTyJ+x39l
	nd1EjcPIys2+F6oMhMO4c2tcmZKkjP+JJKq3msQ9r3QeKiS4piY5kzMQ/qGJRcyqt5fjKx
	bBLm2qcECDmHbpB9x/M0duGJ6Adv/oA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cQPXOwId;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766160584; a=rsa-sha256;
	cv=none;
	b=i1klpxtHiaEvCaihfC+paUaEvhTNbHPEBUsUcWqMSByPt/SYOgM7ITzUYBbIn54uBBpHku
	blLv9ZvaHN0iTlLrstMuYIDGVOwmHk2gBaW5bVG5B2sVVbWWxPK3olscu+1Kol8D69SFR0
	+mC+ovR8fmDdczw1AI/H6BdL0eWMSCY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z0mjmGpOW60lNIbtFI+r1yzZWjFojlQMo6AcrdT+eeU=; b=cQPXOwIdyvnpu/TFP07Kw09C6Z
	Zgy1qKTMnuFS26B8P+aXQyJg4yZg3HLAkX0xEcQUFb9VBegbEKRjkggUWliQXDkfWH05DkjXRjOzA
	C4BLRuOUlXgUUmKsfkfx6kx3zmv2NSgsK+y1W8xs4lHqP0rFqJVj1TuUoQKMEBLGbF3mTb79Q6zEJ
	qP6HF/hiSnTrGdltfke63GdUe/UA+lwz6mkGqCjTkGmeZojrYwKo2MrL2Q1VmR3IzbxpjnDBUzzdf
	Cfjw6depJXCBUEYA599KPGQpKSdlZIdHm/i8FF7iqSZ1+vNinkRhiBYj74IVjkx4IUl5Mq6kSTNQy
	n2YND57A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWd2p-00000007n7R-3Bk1;
	Fri, 19 Dec 2025 16:09:31 +0000
Date: Fri, 19 Dec 2025 16:09:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	akpm@linux-foundation.org, david@kernel.org,
	catalin.marinas@arm.com, will@kernel.org,
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
	baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <aUV4u9pOHxvQiDcP@casper.infradead.org>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
 <24b9d33acad627997febe9b61d398fc53739a333.1766121341.git.baolin.wang@linux.alibaba.com>
 <x2s3l56rqwgcpkhpu77pjt65tfwgmchuy4fuyrj7h7uag5gja3@c3jbws4quxrd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x2s3l56rqwgcpkhpu77pjt65tfwgmchuy4fuyrj7h7uag5gja3@c3jbws4quxrd>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D7E8100012
X-Stat-Signature: d89krjgdz9i98mf69fd9trhfp9mfg85o
X-Rspam-User: 
X-HE-Tag: 1766160583-666672
X-HE-Meta: U2FsdGVkX1+hlgIgvlv0OFcipdainU/Tp63o2XeWGZG+CHFGoWujBDSkW4Mw9n1PnFyCpbkdoCoRdebUwdcUQsuwfGSGHcXX7F9yiI/lgcuMJ8nWUlG+MLH7F8Fxwv23+jor/YIPeOCl1E0PQjsvgBMN7NERfhxQof9tVAe8oJc48l0MbB7/bbmD7+jzh692WBmap7JUU9V/zKwAGqzynYCL751CETPEBdMZROQhG8aJD0Ge4Qx9ihfUNm9UORKqFMW7lIvGGtY8GOKq0th7yPMNCPk47c5VcEi8QldVaYquH0pXRBzAQTs1twzBywY/XgZcblf6cTA2CF/MxBNsf316uX8mU9qdpoWrX+SXMUDNloDHiw0ar1qGZzabM/SA2GaWQG957KbxBHS+Tg4Fq5BcxHbsYCDJgfNZa3/sZTfdmqvKdupv/EwCB3vSjH8oxwo5vuZ4jcP/zWqg8+x29TifGS3w+hZzrJvNbA9VHrDU1PYWjT8fqiv0sEt/mY29gEiAx4UyyYsLEzCWzAvjXoIkKPw5PcDRlF2tKCiIT1jWt0e+YUthYh0HwxP6LmtXtLMa+pmcAe3GN6PIQo62GWUFLzyRre+fwb+gpd1ORzxrwtq8RFB2wKpUt8cI/hHUyp+RUmTLmRr/YPpE8mgZtEPV57Iubdp1+9dwWHECaLbgt18WoXwWU+tUvkV2enRplQu8iMxvQCsFiXkBkrskc57SSqHIY78JtNvcw8gBswKYRNF2P1CUE+gqc8Qe1LqF0+bK08W4b3sFVFbblHD3JFPbrkxkWmDmL/7L5vTxUPeI0r2HdRWAowH1oLmVnsHfv9JF1VwnHh9k8Nsvp79vePnFiLLMXlWVmMj0DELwjlA/vjvYJIG3JvmwDOwK8WppJflFc+7KUREvHFSsCBG/cLLQmJ/8nmSPz5lMsMtfHSr0K5V4WxcdbapV+JUOo+0VRNF4vhC+mROVur1yxhh
 NPR8pw3B
 aWMc9F0N8oFqLye/7mgTP2tlkAFrMkaB33k5InPxwVuB7k/GoC24GLzwvrgulih8adCHritlDUMnvNptz2OxoGMQansvzbdjssIrBesvNzxo6bCpSR03Ako0752LvI+PhA3cEstsntYeuiqNRvVFboy6VkzUB+mcb3vC62YOM+hsjXig4MvaqBUG49rc1bb9IH0PXAzoN2ImRu8YW2EbnGF2qdyon+8ZeuHkDmpgK9e/r+E89gO1TJ221aq5PUWgKNVPN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:47:52AM -0500, Liam R. Howlett wrote:
> > -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> > +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
> >  ({									\
> >  	int __young;							\
> >  	struct vm_area_struct *___vma = __vma;				\
> >  	unsigned long ___address = __address;				\
> > -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
> > +	unsigned int ___nr = __nr;					\
> > +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
> >  	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
> >  						  ___address,		\
> >  						  ___address +		\
> > -							PAGE_SIZE);	\
> > +						nr * PAGE_SIZE);	\
> 
> Did you mean nr * PAGE_SIZE here?  I think it should be __nr or ___nr?
> I think this nr variable works because it exists where this macro is
> expanded?

Yes, this should clearly be ___nr.

> I am also not sure why you have ___nr  at all?

It's a macro cleanliness thing.  Imagine that we have a caller:

	a = ptep_clear_flush_young_notify(vma, addr, ptep, nr++);

If you have two references to the __nr macro argument, then you end up
incrementing nr twice.  Assigning __nr to ___nr and then referring to
___nr within the macro prevents this.

That said, I'm not sure why ptep_clear_flush_young_notify() needs
to be a macro instead of a static inline?

