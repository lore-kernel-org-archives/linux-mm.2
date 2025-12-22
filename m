Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4594E6781B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 23:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0778A6B0005; Mon, 22 Dec 2025 18:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EE96B0089; Mon, 22 Dec 2025 18:13:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D196B008A; Mon, 22 Dec 2025 18:13:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D48316B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:13:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67181B9275
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:13:17 +0000 (UTC)
X-FDA: 84248660034.10.B0F5827
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4145410000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:13:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N4DcZn8w;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766445195; a=rsa-sha256;
	cv=pass;
	b=a238UZULQNbZJ8mPnM/cN/fEPD5mUqxYFWWAqghnBWmIw8ac6y9vOJwpiXzURJRt6Go9io
	gRQ1mAD9O6XFchqYr7NjLPaE+YuHAtpqPQz5tv8Rk3TRpJFroE2/m3+lA50bDeRi6208O9
	o0uj4OjyT4ddjdTpDNBP4INkW+/Jyqs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N4DcZn8w;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766445195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJTLzTRHdupLLvRcx3mcA98H9ANSIboGE+S4pWyKNSk=;
	b=w5aRiQ3s0vQ9x/liIZiPvU8VeFj06YzmrZZ5K9STscLZwnefUohM+yGBu81bnfkN403hgf
	THuSxs1npJFFvcs9RIxKtygm5nWNSneq2Mw6wVeNC5fZTcwWR52caZfiuU7wlYRNUUBSWi
	YoSrdG1I4FmVAl6xQvLo4BrU56kKDiw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso211495e9.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:13:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766445194; cv=none;
        d=google.com; s=arc-20240605;
        b=LDNyesIXs6QCatu+pLnNJeU5Qfpi1GPdixU2u6pThi7tjbOO4B+yrG4GJVePYfd9NG
         L2eeq7OW7Vl6bUOX8uS4CphiC0k0CY00f3AvbcSD+MIeApT/C3v+p1s6nwyifTq3ir1y
         dOboGZLY6HIqgEsQxSvd5gKEFvV0Fi/dVCxP7A+7YitrOsEQeD8SbXlpHm+omzbgl8y4
         pLh2KNFjODa3YwHegFdF9fGQRtZDf4YjgkyCnERpPxc36Jt+aVRyLGga9atBc8+JtzKR
         qNgtvauhTOAzWjaKko0yf7TRNe6obrYAv4Y1aQ6umal8nlwGWDKFDUZ6x/PjcKHbOezB
         oNkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YJTLzTRHdupLLvRcx3mcA98H9ANSIboGE+S4pWyKNSk=;
        fh=aawWypLgrsTQOiM55Fx71arAT4B2nKE02m7im1f08QY=;
        b=Kb7T2WQk17fGEb1q9xk8PCgw8ckj+3WdrCx0lmTAjkDn7PEjnPrLLNYGTvZWhISEqV
         BYt65/4aBozOS0Q//GjokuSdebVzWKiTU/Yvu4e1qHqsxAUstaQqu3BbuXQpGDbJUCre
         /PjN8d0kVapeCmyzhvwK0SkACN//y3ssBj8YzEDpdGlDEJt+hwKzlCxhCMf0GaBkE3Uq
         a2VMi4o+uCFlG6Ihs3OJe9/RBjTUlT/n9p3YdP8IUlHt7DOdqrwmmcffuhWI33CwkDs7
         nstTqJtoczcn2RtfbZ+n5mWxncXzOlzrIjokkIXQ0uu+4eTYyCr2SYiE4WISnDUN+zgo
         PE4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766445194; x=1767049994; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJTLzTRHdupLLvRcx3mcA98H9ANSIboGE+S4pWyKNSk=;
        b=N4DcZn8wv7w9RwXY0PBUS5GM/W5C7POFiSiZjK3USg4hW6ely0bQQ3wpcJoP41hXUF
         6DYo25gZSyXGXlXEVz/HZ71e2EaWSCuelinykOTn85DF84Rp0N9hEqi26wphQK8Rnwka
         97PG41MEh6FDlzWo/k5/FehujqQpvGdxmnDRYtE7upNqR0Kdvvo2OVFPQ1s6J+J1Mdmn
         yva8Xc6qe1wP38T4uGIXxXPR8nsbb6uoxtBDkISTXPDdyB0UrSBcgdgQyYarUtVduxfh
         txrTnXfyMYUqsYwvSLRtySeThcaF7Y6ipizk3LqCnIRTNEr3Uskar7hxY7U2TnKAirAr
         XPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766445194; x=1767049994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YJTLzTRHdupLLvRcx3mcA98H9ANSIboGE+S4pWyKNSk=;
        b=W3Sg9R3arUrbUCwLcKAZgUNAQ+jDDYQYuST9I4bwQTOAQ+PLt/+AlXxh1TT8K+YGmP
         2LCleTKDKPCYPiDmf5fjr5NSQ5nWf1ZaHYFw86yunVqwC+LY4Yg6lsxdRxTWnQksIz1U
         vQBCKvyzi8yXc+PbQzR5SQoXh8Jihpnd9TSaEpE06wNDMaDamCyzHBEBHPxG1jxoM4KL
         bJ5Mlwh73qmihIzboSgBxHgTdjGKPoQ3S5Qh7bj0lsC1cZKizLKRVOKoUloHi2HjMSxM
         NJd2GdPSl5Sa6QoHgX0aPRQGioJIUz3BQcj+YT1/RbEAuGosAnd+sMOpZE5bVQnpojwl
         JupQ==
X-Forwarded-Encrypted: i=1; AJvYcCWswRme2pb63pDeLZ+RWLlcP3j7Ay09927b/wjeURmXHHDP2k5ft2PYNXPsnD9sX4qeAffCsoio0A==@kvack.org
X-Gm-Message-State: AOJu0Yzb+e7eJ0oZWYGxQ9qy+bI3OZCPvg6aYyP5yof4+PIcimEsuggp
	OALlqa4gBb+woDJb3tJ0zeH4TZkKLW6/M0VIGsEpMvc9Nxtnj3vqwKJpfKMnlst06/+Aj1wn3Cw
	GeGEwZp8Z6rbFKvqQpOSSuNQg7ixeRxVajaVk7Lu5
X-Gm-Gg: AY/fxX43oB5XVSenhTO/5ZyT1q0YVWk1ZPAIhQMokc1oYP+385RJ4iqjrPFLdMvj+gE
	4V8LcqXKa87CweEtlKMGYEXN1yH9i8L3gmZeH1ftmB1Gi6lYzMFVREcWpgdK5ZkcjVaGUt384Qs
	6Q528EUDedSjPBD+ilifgo3VN75plL4g8YHtyxyLurJAN/9RT7mUJ0197oP00lC5pa3NrrLACGd
	gtTTf5kp3inhfovfTOSRxTltjYcZkwkwSm/vRhyWhYm1UqCt8VUpzu18PEK75qRMtMxaCoCSPZW
	evPNmyHcMbfDefY5NTR3cnFh1A==
X-Google-Smtp-Source: AGHT+IFGkduj7pH8W1zUazH20M0j3IBfzkdlTK/FmiMb9xK4c/lYliUVcovrVAkpHgDjUzWBthuuXRctt88+BX0beSY=
X-Received: by 2002:a7b:cd85:0:b0:477:86fd:fb1b with SMTP id
 5b1f17b1804b1-47d2321463cmr1500555e9.11.1766445193456; Mon, 22 Dec 2025
 15:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-4-jiaqiyan@google.com>
 <aUnCUNjiBOp05kVD@casper.infradead.org>
In-Reply-To: <aUnCUNjiBOp05kVD@casper.infradead.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 22 Dec 2025 15:13:00 -0800
X-Gm-Features: AQt7F2qeD0yp8uj2mESCumPqHXgiW1WK8km67ALQU8AEDyS5w0Owye5RFzl0tRQ
Message-ID: <CACw3F50ZKCGaQrOEgoH6g8YCcK7Fs=tEiywZhqUzqkkeV_SsVg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm/memory-failure: simplify __page_handle_poison
To: Matthew Wilcox <willy@infradead.org>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4145410000A
X-Rspamd-Server: rspam03
X-Stat-Signature: z96urke1shrk18s4wtmbc6mxohzupdah
X-Rspam-User: 
X-HE-Tag: 1766445195-193226
X-HE-Meta: U2FsdGVkX18/xJESpSVLUBScWgmez9A1NzxeMA/V5a7prTJUg+ws5O9y24vKSdGlWeFzUlK95hSlqV+wN8w8nEH4Vt9i3v2Q9UMBlq5AwDoI436wl8oZtgc3GNRJTNswJuqWsM0VIKu+mGzduw+BdsojgrY7OEnyCijlM+yJBlC0Ew7VAQ+CYXgu202MFJL38Gt8VtM9wQVwyIyg3X9mAH3/94P0X+fKfgXpolI1GO6rlrIdEz+XNdkvyxiM30jR104Y9oIfRvvIqr+9VipAuDlNXww1xfj74/NiWQWLZwih7I8abK0MyIEnASrHsHSIqNVQboFm81E60Air9PbcP4p/1qOCCPZEqu+WeGOX2GXGKDF2ZZ+OAHYvPKeuBoCn8Y8xvAT4nAS6akgkUGkSYAgZ2/04YY99FOexIzT8PTbS5cbNwt3ODLOKnGq0AhSrYNl8V5j36Q9n9BfBFniOzfgMxw8i+78E6FQWJDDCUeLpJrJP10P/R/4RMuOMZ2dv+wKuEPXvau9A83QyB2laNTwSaeZ5URVY1NDc7hnb2qwHI/6hGZCGqt1qsFlQpdX80ysVQ83+EYg23vZ/4x6RKLV45KvvD10HwQRk4uRB0c7AjaBAWzqNcOFvANrvp7yNbi/ygHmb6+Xt4nK2HU7vjYXQc/u6jKl5o7Jpwuy0hTODNKJAMLV7g6FgRsC60NCHJ/80kx2553SXWFm3UfO8Y8+2/jbpDUq1tvgm9eN6juJ+F5zmwDrNrFWnSIluB/BY6wvpdffKNZl0s701tLv0dAwj/ViwBSw6sOzB0hrU071UnpFKGQvX3NgWpjaYLR5dM/5039it+vL1oyJEyhOwZxoJ3k3xlSuE8kiaG6ZhB+PEVxtRvrh/en//qBSk2ekD6Q7g2sTVAGzMDDfa9FA2tHZHTCcX5cBjbzP/LQWDUJ1kode3FsUbF6tGPj36AlVpPEgvWXA6si/K53jybQk
 TIurMlhZ
 jpB6A/ZQ63Vk4GAEj9rknUacTbAZtd8Dn8gmn73n4u78eOSdjVUbL6CiTUwYQtMBQyOX3ea5piIzJ6IeHx+vx+WJKP1qaRRs0Dx8F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 2:12=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Dec 19, 2025 at 06:33:46PM +0000, Jiaqi Yan wrote:
> > Now that no HWPoison page will be given away to buddy allocator
> > at the end of dissolve_free_hugetlb_folio, there is no need to
> > drain_all_pages and take_page_off_buddy anymore, so remove them.
>
> What if we discover a hardware error in a page which is currently
> in the buddy system?  Why don't we need to remove that page from the
> buddy system?

Thanks for your comment.

memory_failure() explicitly handles is_free_buddy_page() case and is
removing from buddy allocator with take_page_off_buddy() directly.

However, when soft_offline_page() handles free page with
page_handle_poison(), removing from buddy allocator is missing with
this patch.

I will fix this in v3. One way is to split hugepage_or_freepage and
only take_page_off_buddy() for non-huge free page.

