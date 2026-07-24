Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44371C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A24C6B007B; Fri, 24 Jul 2026 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AE96B0088; Fri, 24 Jul 2026 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5336B008A; Fri, 24 Jul 2026 12:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8A686B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:51:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1895F40451
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:51:22 +0000 (UTC)
X-FDA: 85024260804.13.7CBFF62
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 185F040006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:51:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tRb+F/ER";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGiv6Xscnmlx4gMEVXMVRTWdGJsXLR2BdXop5F2AQBE=;
	b=LVDqI8uJNwgtvbi0ct4+oQNIH9Krhe7k+ZcdFUO6p+b1/aoVJf4wbMWTCt28lOTjGliPVz
	4Pv/u4X2Ad5eZF+7OrqPMmHWQBVQoFbeBctwd59TcSVIDbbjkJWWIzrD2e8QNUcL9OHGQe
	pd2Dx4S2Qcz1tfHlwiHFGHUSGN5ihYY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tRb+F/ER";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784911880;
	b=ypXhhGsQs0ur9e238A4hG9iXLWjg5LPD9AiiLcsHpz5GpjpbPpfXKj8KPH0geGHijY6PdB
	exAhSugjsg69Psr5MqTuGyb35ClFYx3qZSlAZzES6FvxJdKcY/1pllwy3QUnmhy8zGgNB3
	BbqZL5Xz4/HhmjMuLUdXf4oGDoL/pEM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381216921aaso628208a91.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:51:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784911879; cv=none;
        d=google.com; s=arc-20260327;
        b=cyCSYcJDKFxJipdwK/I1BTjRtNhZBxVmPuR0QYsqDhuWta9RANSbZQm3pv9ADI9IVi
         S9KT+RF6JhxE78JMOfY3ckzCzVeJHLUSeiRviqnj84ceHP8PNP2+jJdqrBQrT9/h41H0
         WTGvB+tlGzszeHuDypXWiaPoC0MIHpg18cFoTm/eHGNuLuH41B7xGbUmFr3zsDVO7O1v
         Sl2F28bov9iiRWWSpfpVO6AnsvQVwBSn2YrrzW97fSyXOHcTbsA4Alk3icFc7u47f/bo
         2nxAMgK6aUU12QqtpMNqhZSAed4ZffySccx/0y+LzZYDmFGtSlxKZvo5I8LLXfZlRN8Z
         W4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=MGiv6Xscnmlx4gMEVXMVRTWdGJsXLR2BdXop5F2AQBE=;
        fh=VCU4CVUrAzrtZaBTsOb2EgVRYDyOkoP8ebbCJ7Xmco4=;
        b=jozYGbKYkyH1jfZzm4CYqM8vSGNN3rI/o/t3ZTDSqdPQbViHnNuG8NZmQojIk4uk4L
         /8YZ5o05EPBEBirklRCQs8+wQeqQOqOgQo/jIq8FXX9He87UpC41Nw/LVH7nKWaZomf2
         TPO2BSavbM/x/yasXkNk1KyO0TQzhsKiAuRSwIusKpCOJIHVAduHSKz49f+RIE2tXopG
         sPAACABtO6GvyEyIOdDrDdblPcK/2yGCbeUxPJKrMudZN2DonUHX3qgPhB5T0fNs36LX
         lx2lRttLoiIVbNrEGBf8yQ2WeSYLv2rcmwmxwWyffLxkuU2I8jCdj7XVNdgFj3aWJP2b
         bU5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784911879; x=1785516679; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MGiv6Xscnmlx4gMEVXMVRTWdGJsXLR2BdXop5F2AQBE=;
        b=tRb+F/ERLo3xN+O6HoFGTHMH2HVslInOJ4WTveLEvv85D+UyDdBfQOHTYY0IeEMybo
         GoBrMSpNpNFKG7cXTO33945B2NFZgcPM66mkZSkEsbgJ3mZoNqHrT8HcOV25HhHPnnES
         7ffQ3sYK+xf2zoKLNRgrOa4PDUM92C1kSDAtPg0bMdsBpQpn0AUs0htDZWzplEZoS/GY
         adPoxMqC16CURg7SJG6Sz49blQI6gfyTksPBcteuINVDYwcTnDKLefEkJhrXBvearRFI
         18HBanc7yoNNJeUCUKerfoUZYaE4/ZyuOZpd9It999wyezrkJRic84M1+IuIiaOl4WgW
         WtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784911879; x=1785516679;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MGiv6Xscnmlx4gMEVXMVRTWdGJsXLR2BdXop5F2AQBE=;
        b=efLHYDKa5kizBfV5DbMFH50yu1FljS/oWSRO4CeU9B02P2OTC5jPiTPrItTpRaTYPl
         wOi3dEXQVKaOIQtZGxaLmcZRPBnq/UUTjcqhtiO3tY7K50SNPKC/6+HBHnNX3Bv6aXS2
         pZKhaEtwQRCfBL3v0oTB3hnpt0vqCMSrq96vXe4RcAxVKafQqBwxp820gUa7zZJVv5TX
         NikY2E2OO5Zq2+Becr+A1s9EE9SuFc+AQPTvMiFoCaMVRRVRHATVzQyPioJ9J5HicgII
         RqIqSLxshCgH0wPAsIY1BfS+cqy6chiXP+/IkejvXdRB/ZBJaNTQj8aBRoyLR3vpy+uJ
         0xIw==
X-Forwarded-Encrypted: i=1; AHgh+RoCUDK6hIOtGuJ9XqWq9TUfOVB1+0Nq9jeZ18a7TRE9qHdXKy2tgKCwUtGjxw3i108RUCdQ/ZLtSg==@kvack.org
X-Gm-Message-State: AOJu0YwZOma1AnQGzadoTaoktxEv+VoOBkaIpXnLQ4h1N3htNjO/+Ad2
	4Lp1CHk3fwfBGEdGZl/DMoAhfgGISnYeGeHWHbHRzCbNvlTw3VbmRvEZ/lnCEgpVVKFwpOAYLnr
	GXbM1zBu/mznMbJkoAg0MbZXr8Jzs2BuXcji48mje
X-Gm-Gg: AR+sD12hm7B/6jW2l5/VZBZ0DSqY4Jjv9rfnqgyi4eSbuyPlZd7yYaznudlCS43qK4n
	8DOtmSZTRaEQj72Bbone/Nk2tdcrhDJw5RS6gyNp5gsrQsRSTAw5OwNB/+g4qtVNUdj3s3Vm4Qq
	fA2Jmf7TVKezmvO6b9QCv97dZlXPFh/JBOFG4u/fA5fH4o2wPL3h/yhamVbU9EZIh9GmNfl0fSe
	CEAnMGTy6SQ1/mgrc10nKqKtkhPbQOb5tjQNNL7u4Oi49wwY0UttmsGzg8O/B34l1WArIFjKqFW
	JrYe5lYEmQiwc5aotSs332nArcpg2KSyAeudiUFxf8afqkLL
X-Received: by 2002:a17:90b:4c0e:b0:38e:8050:e63a with SMTP id
 98e67ed59e1d1-38ec648af5bmr7316123a91.6.1784911878269; Fri, 24 Jul 2026
 09:51:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 09:51:17 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 09:51:17 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <amOByZH4oWzmO3Zj@google.com>
References: <20260723143034.175661-1-willy@infradead.org> <20260723143034.175661-6-willy@infradead.org>
 <amNeKcDZ66VrQ5PL@casper.infradead.org> <amOByZH4oWzmO3Zj@google.com>
MIME-Version: 1.0
Date: Fri, 24 Jul 2026 09:51:17 -0700
X-Gm-Features: AUfX_mwyv48CMhJeCiSTsLkrFrJx83-q7QT7s4fVGWdzAx4oC8CARZPYON4lVII
Message-ID: <CAEvNRgGs4Y_A6FAAnyrdUY2icmZ=iVPit31VWo0vxZiHFcyeYQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
To: Sean Christopherson <seanjc@google.com>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 185F040006
X-Rspamd-Server: rspam01
X-Stat-Signature: tp9uhgy54a5medyqrghb3wr78pdyirzt
X-HE-Tag: 1784911879-461188
X-HE-Meta: U2FsdGVkX1+QCcK9IbWbndkr3Po1aD/AihiTk5O5Vw1vTHrpiemCbdOz1l03hkZOApzax4zwNC0XRNYje5j+avhbb9jaG7MfFwk/OjI7mCiHi6ap8cO3hYFFmfp3KmrNewdkviCwHd20N5KNf3k08OcYIRfpD9goW+xtLbBCF0x1rilLDIBV+Tj/NPmj5Ylvpi3GMTDZMnpnB/e4LEEYWint7VarRTRMJXZjLv5DDIcffr4mjRTBpL0g3ZDK1SS0fw2xdEOIv/Nk36tVQZlzr9McLSeSa7SIdrVG2TChZXhseOREgBR5oPSXG5TJb8D6Z9CLcqwJoEVD8XlGSgrJ2c9vV+lAIjvQzt6iJD3s6j8JwvnAZVbYvuYVq+vOlezvZIGF2wjbwKQqDoH8u6+/KUF8Y+rcbtqTaPJjMDW4+yA7QfvGCS4Ce4NUOLmHn0Jn0Oa9wauk9eHZm9IbVQtI1rxM12yFd6YlGBf8XfrGQlFsHAy524pLML85qrTSSQUCR0Oh7s3Kcxe7bygi4JLz2mL6CWanMBP8QfE407JZEIKeDp841bAtNEqwaAbwI2xHseLUr0j+4U/bPA636l5+R5IoSka5n4ZfYa66GDTlEgY2VcdEBwQg18v16EJyipaSKHrC/QboXtyBqqbctEIo4RKq2xQgsAaeRFR/nK+PcjlhorCZuYwB8DPtWOAcHbt7x+lOVd1SLERHE6rimOWjbQtKVLz0waLb0ox+yzJJ4i9tHj5B7zVd6YJIldqeLI3HvfWMzvQnH2O+n8KAfoN5ugeeqAfmPUM67sET0LvAZhASKpaNv95j2N1Soepzjq5cyp9crcVTTIskMVKI9w1p3di3z36K7MosYLCjKuPnVtFwjnOVWT5SpOiDJUscgmc4GO9nk4Z/T4KuKyviAtcaP2GmHnGPqdWVwI+UfX7GeYFlZ++g3rhgsutBNW7SFCxq83NrVfHtoTJwNyP4/+k
 JAGGkTfx
 jQtmZcgMIuCKO3weNJncqbCej0rcgteQ3JfuW2t0cgfkXmQFZYjd0xN78N9VZxCmppuP3CLxt0/RpFmd8ct/PdI6ZCxT1gHdzUo0ELzQH+qzi4/6O0UVIFOFbHF/gnn73N/N8GA1PRWel6+OXcaYY1Ctwn5iZaLNY72OmqzNl7MVLKMpS/3wfS0SlblFIojLBY9VQ37nzE0uC0qbHCNgLS9xFGZ/I6Qd9KUyNl5Y87fIqSkndBqucIizey8t1u4vERmWHjw6ujTtYZV6vph+BIjxldHqv0eAttYGRxrshHMQy4naWNBkvtHB4autpzma9eyh2PVLiDLLYLi6cLZ0npuyLSjzzmVWw0L82PHqT8hwiv8DEcQte52iQ+144tsfjruqluR7HR3IZvwukfOQo8pq+5FO4Och6jB5gAuPmT6EJhTlAcB1K4NMSiVW9wByQC8zkvT0PkptwtLzu+PQi48y7PwUf1KHQIkZxzphGKq5RzxnFq1BsdiyQtl6ZrDvBUO9i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 24, 2026, Matthew Wilcox wrote:
>> Sashiko review:
>> > --- Patch [5]: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page() ---
>> > commit b4db4098463261fdf87a2e92b28ce2b4c9445e74
>> > Author: Matthew Wilcox (Oracle) <willy@infradead.org>
>> > guest_memfd: Use folio_has_hwpoisoned_page()
>> >
>> > This commit changes guest_memfd to use folio_has_hwpoisoned_page() instead of
>> > folio_test_hwpoison() to correctly detect poisoned pages on all large folios,
>> > not just hugetlb folios.
>> >
>> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > > index db57c5766ab60..94eedcc7f1a9e 100644
>> > > --- a/virt/kvm/guest_memfd.c
>> > > +++ b/virt/kvm/guest_memfd.c
>> > > @@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>> > >  	if (IS_ERR(folio))
>> > >  		return folio;
>> > >
>> > > -	if (folio_test_hwpoison(folio)) {
>> > > +	if (folio_has_hwpoisoned_page(folio)) {
>> > >  		folio_unlock(folio);
>> > >  		folio_put(folio);
>> > >  		return ERR_PTR(-EHWPOISON);
>> >
>> > This is a pre-existing issue, but while looking at hwpoison
>> > checks in guest_memfd.c, I noticed a missing check in
>> > kvm_gmem_fault_user_mapping() that might trigger a host kernel MCE panic.
>> >
>> > If a guest_memfd folio is allocated (e.g. via fallocate) but not zeroed, it
>> > remains in the page cache without the uptodate flag. If a memory failure
>> > occurs on this page, it is marked hwpoisoned.
>> >
>> > Later, a fault could trigger kvm_gmem_fault_user_mapping() which executes:
>> >
>> >     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> >     ...
>> >     if (!folio_test_uptodate(folio)) {
>> >         clear_highpage(folio_page(folio, 0));
>> >         folio_mark_uptodate(folio);
>> >     }
>> >
>> > Because there is no folio_has_hwpoisoned_page() check before clearing the
>> > page, could the kernel-mode write in clear_highpage() to the uninitialized,
>> > poisoned page trigger an unrecoverable MCE panic?
>> >
>> > Should kvm_gmem_fault_user_mapping() include the same HWPoison check as
>> > __kvm_gmem_get_pfn() and return VM_FAULT_HWPOISON if the page is poisoned?
>>
>> I have no idea, but the purpose of this patch is to stop kvm from using
>> the wrong API.  This is definitely scope creep beyond my level of interest
>> and the aims of this patch series.  I've added the KVM people to the cc
>> here, but I'm not going to do anything more with this review.
>
> Heh, you don't want to sign up for a week or two of onion peeling?
>

Looks like Sashiko is right, we should fix this separately.

>
> [...snip...]
>

