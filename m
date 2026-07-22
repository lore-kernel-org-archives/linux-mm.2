Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A568C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657C46B00A7; Wed, 22 Jul 2026 17:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EE16B00AA; Wed, 22 Jul 2026 17:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C9A6B00AB; Wed, 22 Jul 2026 17:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32EF56B00A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:18:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3E911C052B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:18:45 +0000 (UTC)
X-FDA: 85017677010.05.0DF71B1
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id E70E2C000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:18:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DojwhGo7;
	spf=pass (imf10.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784755123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqCXIznA1pzGDyUhZSlfjDm381k0hmycs7JYcnqQ7Fo=;
	b=Sx/ILRD0Kk8KuTadMmRj5W3jdz5XUGD9RUaGE1Yap7KDZP//IMkUboODG1hvyjWYza+3st
	GFKgUFloWxfkiVfbV2ZYxB2jS0TIlqVfExTqDD5US5erL6s48x/1hNI4CsqxmeUJRQDEoe
	dKEZ5RNE1iLLz/r+ODMw4uCxnHqj0Qk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784755123;
	b=H5x7MhXYkylBEhH+RzIjd6IzzZPdM0Bk8QL/T/O6B4AGumWNZ22BnzYSll9MbmAdMd5lqd
	muVPbP+eHQ1jjPmDKTXm/3jA7AYCkU2Y0jN39hDCYTUyX0WZuh+kGkngb2Dy6GENijFcpc
	K2hWxzG+kASsduxm3+g9YV7UraXl11A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DojwhGo7;
	spf=pass (imf10.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cacef7d299so1115ad.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784755123; x=1785359923; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lqCXIznA1pzGDyUhZSlfjDm381k0hmycs7JYcnqQ7Fo=;
        b=DojwhGo7bpDb/N1JnHGExLP0x06qHuPBaOCec1NCQzdvRNo1a19d1IKTbkp+pLzeWR
         qXjcL5QlWi96p6Zx3kiR0SF0UeTmi2aMKSfdjAPtyx7yMGp9FQOglvego+LZt1pWaMYr
         n5kzzFdLJ8HBf48q0/mhvJjdeeh2BqFnFD9CpXC3EH8AZVYRjphLX8fJuSFLugIgyTb8
         FbtENGhkesa2TEf/MoHOOccRclNMyejkF7wqMT/k10U658CLls+IVYrGiBZOAgT+pvqF
         d3CoBSsP7puRq92PRGvG+NiWByL6hRukJ7qg3+AV48iVDsqakYih0ZBxQ4ETnG7RbVo1
         0Xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784755123; x=1785359923;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lqCXIznA1pzGDyUhZSlfjDm381k0hmycs7JYcnqQ7Fo=;
        b=MWJvpR00kPwR+3Nj+7wZuvLwwDCxP2XK6bga6+zhXA7qap53FszanlePHtA7t0xBxy
         SvgwOD5sHc70Dwu/fDky10S2X5fxl0umxgNyvQkgNcQ2p/u8Haz5SwOcHX1mXxeo7W26
         dSI6dVXaEKxW9rh4c0fOH2+ATcssFuvzwpgNpp6198jc3MlI11HcSvdOmdOleAxows72
         huN2lhoS8NbPuiNjoBzxtexuL1T37860OQmm4SZ4/LQK/7utMBmoan3fCTxr+72A9mRv
         cakyPQk7jYCcLc9bO1I03sbnHIBmsafI/agw69JbsNjiDMRju+ZXqgIRF2ZKkqsqaD2v
         qxFQ==
X-Forwarded-Encrypted: i=1; AHgh+RqScyT1xTHalVTGGvi3VBPvNlH7hBseTVKKD7BpaWSiAxppCZUiH5EKfbBChX1L2AQbLzkCD7/aDQ==@kvack.org
X-Gm-Message-State: AOJu0YzY+u78c7oM1HNK20zDFuvuHUfdtzcCkTPcXpkatlPHfzVMZBqH
	rNSR4g+gL59HQayXQUFum96sbTvo1jeK5+iynZ7hTxFUdhnOe6T1mdFcGcXsPvfJqw==
X-Gm-Gg: AR+sD13GmStqUzJ5cSm06w7vG9j5B2vHqNmha+imwLFP8jqJs7vsM1gxKhzC+lFTOJ4
	LQX7hvSyJlVMxVKexZI9X1r9aweE4E8x3q934VWmQruVX8lbIoJaOgKQeVZQkY0uak1gSdp4wGP
	sOeMO3f320Owha+jhu/4h1gPdl6sYD8w7AQqS98CZ1PKGESahhn9YD+CJcr/h8XfNSNCFVg+bgI
	pAatscIs185KRMIi9OzIs9C7Dq9p/Uh6OKteF1rTmewvmC5zfH8aaYT79romErVdUk89F7yebz4
	MXmLrMjuyJRkda1RtdxGZjgYN9ZqrZV8R0lvtP6OVx78f3mmH46EWZkSNED8fjWNM8OmxHCsofS
	pEQZYQbwW7Nher/61j4F+chPPZXXlH3VljuodYLZCp0HKLMpB9NzWSKgUk/bOz3502I/CX47cDu
	gtvfJCkV6EZu/7o33V1r7HvDq5Co0mlQKuFGIO
X-Received: by 2002:a17:903:198c:b0:2ca:be81:b469 with SMTP id d9443c01a7336-2cfa422522fmr1806795ad.0.1784755122326;
        Wed, 22 Jul 2026 14:18:42 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc9f2f0sm13076614eec.13.2026.07.22.14.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:18:41 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:18:35 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] kho: Introduce a helper to init unsplit pages
Message-ID: <amEzq5aXBtT4nLfd@google.com>
References: <20260713204935.3069000-1-praan@google.com>
 <20260713204935.3069000-2-praan@google.com>
 <178456663513.143128.13731300065093148388.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178456663513.143128.13731300065093148388.b4-review@b4>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E70E2C000B
X-Stat-Signature: fpc5mo5a1bngdhabsqgnj6phjduadoxh
X-Rspam-User: 
X-HE-Tag: 1784755123-604273
X-HE-Meta: U2FsdGVkX1/BNWiTu+ZNOYdz7bZsv8mbXMCvYGlkKh8SshTvsdbk0mNIyL6mew0g+e6LTEoLwsRwPZf0XFndN2Rhe2LPoVAMxlTiaFKYZ6o6cKRfSjJrfoNLMcqH8z7rZoGyYz/H3X5MuTrM+/HtlYnXT6eVkmBVaaKsBIPMX1HQ4axMuv22Pl1GNKCv0Tk2Cp2GuaB8MQxvHpzkfghklzJMD4n6fJiYERQayHCWgFoIJDN/sA9MrbQHF6KAg+5+TtoJJq1bFY6LdHEMnE5fpRq3LnhXRoQOfZmaQcjoL2ly2X5P8R+xh48yQ/jCREM1RoLVyI/H+Z6gD9Jgd+P3P1jaalabI365xd7CdyNXO8rER/H6uaJ5Pg59EgAzwgcvaITAAZTbxc+7gujnQCKeI1ovxvZBoNnDnhPH4DDe0HTuz3GhkQYZyCwY9OCLAXF2AnOkNpB8BUROHrJ18ravS+ENE0SiqHlh7go4roueWWETxo7L+ETyZGmJ9PZ+s84K2nOtmvEaZ4dtRQG+gnoMo9lGpcahSpAHsl3iM6LwoD9r7gqD2I3tegZ2PfNq7ZMOyTmbpwhJUuIAu0dH+HoXCO/YKQwh1a9cEQjtJj2rqTXQvD52dIxYCqRaTai07cek4ZTDWenrN2kqpgxzL6sbhWzosrst4FQVCWc9J1n6nmeA7+d/DYQxnlhLvanQcPH/brlCC3MIM0cWX44zk2rPzGiBsetuasuU96GiwaXO2KTiBUNRoQ07yABXtPC3/kglhpnLpxSteuEfetjM4W6duBdcl2eRe157QLAopiRonrW5i9DaHQMYQoysg9JBuxlMuywbwIMdgQkFiXLeSVr66kFRh2YzfzBTJJDVuwgm8/cRS1P3icCVnhdbunptvhFPPraAEWJiwSsQFKuVu8NqtH2E14/wj0uL0XeWdQeJiVuEyYv8RWaAgP9Vst2hQsmhnWbKXOwf4ZqIKghD9hR
 doFK9fv4
 Z2J+FnneLwjUL8JNyxWc1ktRTytjUSLwSXYh6S544Mt9VzUxoqJYE3XxEf7BgGius4gJp4dJKYDd6G1+h2cGKEq+aqQ9GjlLrEdBHrFvt8GmYJf/4W0984Me0x9bJd/U/g/keHP0psfjVZ8pZ6bDf0+rfD98bGtnYqf1bX2sgo20AzYfbTK1430IvzoZn8T0VRh2D6UpwvgKGCYRFwpT+mQcqZVIl1o3RG5k24Fc88iJ4byKUlQFJ0wDzrltXiI+dybgSBEorli7QfyuYPAPzmeHExdfD5ZD35Al9y7svDitzCj9fSR9jWqgGtozQz1TAlGJaKk7DON8GslC84gcuxQZogQb0qjiv1V60
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 07:57:15PM +0300, Mike Rapoport wrote:
> > The current KHO restoration logic assumes all multi-page blocks are
> > split into independent 4KB pages. Break out a helper to prepare for
> > supporting high-order non-compound pages.
> > 
> > Extract kho_init_unsplit_pages() to handle the refcount pattern
> > where only the head page is refcounted. Use the helper for folio
> > restoration that requires a similar refcount logic.
> > 
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 4834a809985ab..07f6f453cd69d 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
> >  }
> >  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
> >  
> > +/* For physically contiguous pages. */
> > +static void kho_init_unsplit_pages(struct page *page, unsigned int order)
> > +{
> 
> Can't say I like "unsplit". How about kho_init_high_order_page?
> 
> And whatever name we pick here, it's surely must end with "page" rather
> than "pages".
> 

Ack. I'll rename this to kho_init_high_order_page().

Thanks,
Praan

