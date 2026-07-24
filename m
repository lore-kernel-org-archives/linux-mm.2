Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BE9C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D4C6B007B; Fri, 24 Jul 2026 11:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E396B0088; Fri, 24 Jul 2026 11:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D1F6B008A; Fri, 24 Jul 2026 11:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC9D06B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:16:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 571AD14032D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:16:29 +0000 (UTC)
X-FDA: 85024021698.30.8CA0CEB
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id A157E2000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:16:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E48amP3P;
	spf=pass (imf03.hostedemail.com: domain of 3yoFjagYKCLUnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3yoFjagYKCLUnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784906187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7tZ6rxVHVxA9k8QZg3mxz8r9NteqReZr++aWJKr0sY=;
	b=qbGZ7bKs2QVJs40FA/RgfLCDu6VmAB66Auc7b33yODaURxc9gerxtSUXdLaIqu1njd06sx
	oTNXDiDLXodbRVEslI2YjNXHppE72ViXt1mWeAUQIjYdrUiF+wAuohcC7M1ZBAzmF53/tj
	nQhh8HtbMXB1hIGmVwGK7QYR+rVThnA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E48amP3P;
	spf=pass (imf03.hostedemail.com: domain of 3yoFjagYKCLUnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3yoFjagYKCLUnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784906187;
	b=v9YB20Ac+IDZOxoQKagujSB0+ppur4/2f/wQqUKlHSQSUBCkB/24a1KgP4+Y7kq5HFEYcn
	yICCE8uW05mgMSWwHrEmLjNTaM1hE1vT0wnpO5BoxcMvekXPoHJVPd77RNTZHLut4SASUq
	8zBMEMfF363nhGBz52I+U5LZyw9Ulig=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-848568a6f62so884480b3a.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784906186; x=1785510986; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H7tZ6rxVHVxA9k8QZg3mxz8r9NteqReZr++aWJKr0sY=;
        b=E48amP3PnNu+PBp7XCkiwtro4Rkx/EuafNUrspp9DjWbTFGkBOQoW1X/cKl1m7sjWu
         vFBy+DFqErunHCcX5zGC8KgOJ88kz0IKMHPLJ52R4XAjP8r8Z8/YbnbV+L9vthRKZExV
         WlH3ubQBiH6v1PXbyUMgKNNc230ZYCGGnTa1tzoyX7VE5c2yu/AuUw0i1yUS+LlrpiYT
         QZ11QK36BqfEA3YEXkHphlSIaLBz51s/BromGNCed5YtUerw790IzXUiWz/lpYjcTiMm
         AID3TEhF2Ou19qMiFHFN7w6k3SNXNn7oOM77l8YpB8G4W5/3RtdfxYfyY2n+CmT2A4Wq
         yrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784906186; x=1785510986;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H7tZ6rxVHVxA9k8QZg3mxz8r9NteqReZr++aWJKr0sY=;
        b=obOU/7IxHwKZlSIwAhhX5OW305RJTimvvbRjWkrvtMEhPNY6RDle8lT8NfVBv5oss9
         tKJRj7BbX1uJT6b4Dd+86oD79pBUymUhIwqTBXpamHf+LT8YmDf7cV0E0LpmGmuSg4S2
         F2vbniwRdpp1/tFoi7ziVPutPCU5aiYO/7gXLZFZO6NyciBCHwYMqg5EXrnhlyxlBIFN
         RPXwXeBBv/sVQ7EhE3QgIw845FivCR4eSRBySrkTzZOJd7MsLAeKz93OT9KInszgxf8Q
         OWAluI+gnjdy7sKV7x1gRLdgsPaXjONdbRFH4WcHUZws/UlF/2kgie3iG8NAQoWctxRB
         tOjw==
X-Forwarded-Encrypted: i=1; AHgh+RpmO+cmXVNfiwr9caRjLrlu9GELAG0djBpIOnuV37hrNwnRH92/DLLJWrLTTUaXDAuly4AkKtaYmQ==@kvack.org
X-Gm-Message-State: AOJu0YwVMfhPdqrPQtjoSacCVAN0ineW6xQbECUgHNj2SGVQ7yXSiNte
	lW/urtEcpz8YF1Z9rbk3Rre+AMsgDvZ0UI5NcWnFL20E1eEb6nWCy3Wvbp8kwa6EtWfY4fkfDPr
	idoadUg==
X-Received: from pgkg14.prod.google.com ([2002:a63:fa4e:0:b0:c86:5f41:8c94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4211:b0:845:d274:bf8d
 with SMTP id d2e1a72fcca58-84e2bba4cf2mr8891334b3a.54.1784906186191; Fri, 24
 Jul 2026 08:16:26 -0700 (PDT)
Date: Fri, 24 Jul 2026 08:16:25 -0700
In-Reply-To: <amNeKcDZ66VrQ5PL@casper.infradead.org>
Mime-Version: 1.0
References: <20260723143034.175661-1-willy@infradead.org> <20260723143034.175661-6-willy@infradead.org>
 <amNeKcDZ66VrQ5PL@casper.infradead.org>
Message-ID: <amOByZH4oWzmO3Zj@google.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
From: Sean Christopherson <seanjc@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Michael Roth <michael.roth@amd.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: A157E2000A
X-Rspamd-Server: rspam01
X-Stat-Signature: 5cr8husa8zrf1ridhg5o9wghqrb1afee
X-HE-Tag: 1784906187-815691
X-HE-Meta: U2FsdGVkX1+IY84+SE4gP0gginH//ii5tJAjUfOKmK84UVKdv/O4FPtH9tqkp8hSwrmat7c01zNlPKvCbf+tFpWhHaThguzP0e3mSoSQlBBZ6a1jLe58LBCAseLOXQDGmNPGreEtbcjqwVGbDh4ytFVR1oKq/4kntQgMieAqeIyBKfi2Z8LUkMpktNY+4CtHgPesJjor930modi3GdpeuwoqCJAhkkUc2xT9MMu/Bez15OGVJwbBEGUojodkeAcmNsot/oWThHAUi3nvFDP+sB1cl31Si3tEgwpj9AbV71eH++We9f5nYFMgrPM1mkmYq4mqQ4+USEJqIUKBLSAqIVnRNZWR9iI9yYk3JFcDpaL/F9hajGJPVrqH6aHL9JjLTWhHbkGSyHlE3jbwiRvftV6GfwHOp7VtZAFWxzq2t2SibPwm7rWKbYvgDY5LYaD3VNyNGIsUn6vikGk2jbwH9Ci2iNH7nECQ9X26Jkn6i1ZkgqLvVP/7/EvOmgAswFoLVN/ITmpO8kUuqcnIiByuXljSf8Em3xAfCAm0lI10oxCVedS7J9COAgKhT5qJgNcp5EHtAb+czpJAjVMILjk4PSTfl0QFHyc1FtA8q2gguW50PtRpzsyLVunHtc0V/3jyMkDfNeh3OLdFAVG3IXW8HPdaZZUOIPXULZn7P4m0ZfAVkPrSSXxFXFLYfh/EeG+36eeZloBuFVozznAXOaVfgePEzATE5pyJrfp/FJPdTehgsNOS9+U6i8tb3tgPSBsTX7W8EA7nj++L7aMlEhITr4QFgPQJ95/lQHXWrtwbnVeiUtKhWCM3T2oKwDkwPbCagZIRoff4mundirbEcM03tSfCEsDqe1dIA4kpomZxoEW1ZWZxx3IJBzbw98T7TbKj2TdI2QF34Rmltsp3qL8TFQcQ0z+2lke3USYFs4g0pChO3jZfhyYR4afuiSOe1JfX5xK0Cmhlw+mn5/2bhFG
 D307zhhY
 gcXME+4hdolUk6CKj5b8zJd2W6hrsKyUtPMLGO/flrYCmAz2HRUvkjTBmziWdth3vLk+QJDhHAt42jY8waGAgzUpgnMfhz/y4/WakEkZTQvj71mOho3S/pSuuJ8tHaSDm3Gc3gdt5UFT7dTnyBBl2v+eB/pgGE6xQ+JCoiU6JIVaOjBRo9dLyhtfMCiHUT1zH/2PLjKyuCeMdryJZz6mL+0iCYknCIQ/KfBqt8u36cNUEO1IAy9lRn/GxVcr7XRnC4kGLrJ6RFKLhI1epSET6hnigcm4JhJ4yFals1e4Bdf8MuKyBFdWTTm+/qAO4y9MBDD5a66UpumyqMUQubSmscujjUDMF00ocx3F5bLmGM2iY75REXmFPrFibJvRs0Q275ARl3ip5xUCbcgY9jvmIhH6h6wqmqV6bYCyIQIB1rNn+1PjfZmS/6P2f2miznzpR1B5APAtx2LiZUdS5Pa7jaFzjKmucyvxnyrezjJp+BeBwFs8D7V/XNP8a7VHKeq+kOTAXx7fhH3++YPGfr7lQ/iIOcHRyELrdMB5ZyDNc1BbZWTwSEAuW9GHp4628Bg5ENSlkophP+IhaSg01bteCIgCEuR6P8+iFZY5W0j6FhEttJw8AKj3XmcDnPXbEe7ZjbU84O0JTo5PcHYjHEKfFuLOHGbMHzZ/iNUI07BkcxVxpIDPF5oiHyJEQ05tdQoZMeErj1JLlrouXRKa0WxNKzq2tIBMF8IT2X2N4KvcdZksaPNtsqrlKjSD/8WybbVoa7XKyIZzdHFxFato=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026, Matthew Wilcox wrote:
> Sashiko review:
> > --- Patch [5]: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page() ---
> > commit b4db4098463261fdf87a2e92b28ce2b4c9445e74
> > Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> > guest_memfd: Use folio_has_hwpoisoned_page()
> > 
> > This commit changes guest_memfd to use folio_has_hwpoisoned_page() instead of
> > folio_test_hwpoison() to correctly detect poisoned pages on all large folios,
> > not just hugetlb folios.
> > 
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index db57c5766ab60..94eedcc7f1a9e 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
> > >  	if (IS_ERR(folio))
> > >  		return folio;
> > >
> > > -	if (folio_test_hwpoison(folio)) {
> > > +	if (folio_has_hwpoisoned_page(folio)) {
> > >  		folio_unlock(folio);
> > >  		folio_put(folio);
> > >  		return ERR_PTR(-EHWPOISON);
> > 
> > This is a pre-existing issue, but while looking at hwpoison
> > checks in guest_memfd.c, I noticed a missing check in
> > kvm_gmem_fault_user_mapping() that might trigger a host kernel MCE panic.
> > 
> > If a guest_memfd folio is allocated (e.g. via fallocate) but not zeroed, it
> > remains in the page cache without the uptodate flag. If a memory failure
> > occurs on this page, it is marked hwpoisoned.
> > 
> > Later, a fault could trigger kvm_gmem_fault_user_mapping() which executes:
> > 
> >     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >     ...
> >     if (!folio_test_uptodate(folio)) {
> >         clear_highpage(folio_page(folio, 0));
> >         folio_mark_uptodate(folio);
> >     }
> > 
> > Because there is no folio_has_hwpoisoned_page() check before clearing the
> > page, could the kernel-mode write in clear_highpage() to the uninitialized,
> > poisoned page trigger an unrecoverable MCE panic?
> > 
> > Should kvm_gmem_fault_user_mapping() include the same HWPoison check as
> > __kvm_gmem_get_pfn() and return VM_FAULT_HWPOISON if the page is poisoned?
> 
> I have no idea, but the purpose of this patch is to stop kvm from using
> the wrong API.  This is definitely scope creep beyond my level of interest
> and the aims of this patch series.  I've added the KVM people to the cc
> here, but I'm not going to do anything more with this review.

Heh, you don't want to sign up for a week or two of onion peeling?

In the future, please Cc at least kvm@ on any guest_memfd changes, both to avoid
unexpected conflicts (the code is under heavy development), and because us KVM
people are still learning how the hell do filesystems stuff, and can use all the
help and knowledge sharing we can get.

Thanks!

