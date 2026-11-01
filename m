Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561AD606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 04:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XPTW/R/H
Received: by kanga.kvack.org (Postfix)
	id 3F2696B00EF; Sun,  1 Nov 2026 00:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C3A6B05B1; Sun,  1 Nov 2026 00:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246746B05B2; Sun,  1 Nov 2026 00:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECEFA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:25:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52F37120787
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 04:25:12 +0000 (UTC)
X-FDA: 85385260464.12.5CC50A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72407180002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 04:25:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XPTW/R/H";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793507110;
	b=6XMWyIflDa0FS/v/w0OfKQd/0hwHUNe8ZiE95VuHNDUTkXUNFo3pFyQ/LocXM50zx19+75
	cRx0u5c07ICG3vLC/ZFmPTRictOlfHkI4ycKnZJKKaMOKhd1jX6oybK8F1uUgYY0q4b4K6
	c/eBJ7+ao/JSZks+EEcct4nbvdJwe3Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XPTW/R/H";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793507110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaJPl9a9qhxWoN0NnjUzfzvyBJovsF7rWwGHYOTv9cA=;
	b=KrRdkLXYWgY463VPkFm9mXK5bSX7mZY2NHoZINrO+gpwcpotUgqLcz/f5VuVt1LD0cvwif
	VNJ/AbPKCikGNk52aYaqhqcmMCr82bYUpeELV8OPdgrF+A9+obl450rDK8Vn/AztsILkYy
	3HXnZH8Apk6zWevqYiDQv7IYAmuIWQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C49C410A4;
	Sun,  1 Nov 2026 04:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9C91F000C1;
	Sun,  1 Nov 2026 04:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793507108;
	bh=AaJPl9a9qhxWoN0NnjUzfzvyBJovsF7rWwGHYOTv9cA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XPTW/R/HdyZBfz+1MYvVMhTd7exeqadSGQnqrCnmq3Bk1dfSl/sDytOqoQpiSmGMV
	 w6UIZQnaIrYx5uviPDZFwtdPCywav27UzXlhJdvtV+A/BkrEMrMOa1hjuO168/CGxh
	 i+gq4WFy6pDFSKYdAEfeJYecWAOdsknlcn3kHk34=
Date: Sat, 31 Oct 2026 21:25:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Hildenbrand
 <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Chris Mason
 <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in
 memfd_pin_folios()
Message-Id: <20261031212507.31609e7ed27de35253b226c3@linux-foundation.org>
In-Reply-To: <CALCETrU76ThzLDbUfpoota5=xcoOS4aZrwgK2B3ELkYcFOjGJQ@mail.gmail.com>
References: <20261031203540.2282507-1-skhawaja@google.com>
	<20261031194058.d3bd25ed950e5340ab595f07@linux-foundation.org>
	<CALCETrU76ThzLDbUfpoota5=xcoOS4aZrwgK2B3ELkYcFOjGJQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 72407180002
X-Stat-Signature: wdbddyrat9b4rewxnp86hi1ns94s5ksi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793507110-411985
X-HE-Meta: U2FsdGVkX19R7/vply5KhLnb0hGw6daPSKAhSRodoGG3mvKwzjYcUfDdnQCD2ciGOa53p8vRX5CVFEr5yqpYomd+RVbB5fH8/HbNXAP15hBXU2lr9aw1+khkwgXr7hw46ybATO/uVRvFHZUaujLiT4d31hg8YTgNgCFUMJHoM0YcdpF5InNwG8QqAylIuqLSAQ5AOXNuN7e2JRPLIoaN07gpvfVLfPmWUrlYMbvFccW8dAa2oQLWSzfiLADrzDtm6tcIYMgYDiwi05rKpNfCX6ahFSpDjygsWI9YisUmqFlwifn3/XELP7wX1mQx+mAqXhk00OWZsPygmO0VofVnDuEkakqBCWt/A/m96Y+pDlO5zZhTQvULFhIXzCuS13GTcWgn+O0XySxlxty8y7tFA/9u4Csq8FMjrQbMuxeeOrmCfhez72yRuILSjX05ET0XpQAsUI9333SOuoAGW27GkUyI6v/aBKzAQ8pWJu+zZHfA+WCvssy0dfxKu9/Rx4LA/pD+viUA4tgpp0Z42/JnqbYjaHi5Ko1qieiayyl1tXb/E2S1xiYlQkVs2i34RVVEbMBU2H95aoP64bxi9GglHlWv9VN1dtMD0bQ+U1L9YE6T1ZMQ3zetPDpN8MekPk/Bo6xDEHVjMKnbp3JMgIt4DXPQO/H/Yr+EPOusG1WVwsskE1IK5C5lXEOO3iiKVFdRyKOsZozo9EMZ9DpYBcoYDoZTVkwxevARjSni6uGkQ4RlHEL7HZ+cEJesoavhr3bdVPC5/vJmP2XxjZ/j1THaDE6441qDVi60VBb7BRruBvfixJYBBmrQt4hvvGx7QZh+xvZ3HF7b+rcLOlGbyyfufqyhVIGd/tURNsXmK9Z1MlngT5ZGa1tvnjS88UPQLQzqWyqyIAquOg+P18ulISoL7UuANMuiH3Y7RBlkRzdjkR1yL54PnemK6RP4YnH8/PwI+ypfPMc86Nw+326Sb37
 0S91RN7G
 Lx2oa/lmrtXKwakyMpKBuU27Li3Wo85dB40H3rb2jZxwrxY1vfs3vt5utnIwpnpeeRZGvXaRgxoSU2/w/tg8ftNWSEv6mznJZSaW6HArIp2NeFHKBJyLRhRsCquUFj+Ozrz3Muh+N8QIbLDbpOEt0HihUxXY/VOYHnYQEPEDvj18JlSWAesxWS4wxvcmiws64Gy0D2kvS5M9WiO4GEIOAkUBjQy+Gh5Vc7ATvTb9tQxW1qbn3pmV3wfj6c4ViCKnbfzauQ2j+1ZGUqpc773uSgxNGDTFf8xw2Axeuj+0KaeBsnkTp8muHgxJ9vRSioKKMimtu2hMO/TKfh0yVkQhQnbAoB8Desm+9ScCGov/e+xuFSwn69GjAE8Hq0aNLevwV6jsc3jvvT9n9RuDONoCJxN10NgdK1sa7Opm3y4OKpQ5qdLiD0wPqUQn+clOZzqr9MFDZD9zzOn3vPrZHz5+nTEPxzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:20:03 -0700 Andy Lutomirski <luto@amacapital.net> wrote:

> On Sat, Oct 31, 2026 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Sat, 31 Oct 2026 20:35:40 +0000 Samiullah Khawaja <skhawaja@google.com> wrote:
> >
> > > memfd_pin_folios() pins folios from the page cache without taking the
> > > folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
> > > its refcount check while memfd_pin_folios() still pins the old folio,
> > > and the caller ends up with a folio that is no longer part of the memfd.
> > >
> > > Lock the folio and recheck folio->mapping before pinning it, like other
> > > page cache users do. If the folio was removed, retry the folio lookup
> > > from the index that was removed.
> >
> > Can we please include a clear description of the userspace-visible
> > runtime effects of the bug?
> 
> It's straight-up data corruption if you manage to trigger it, no?  If
> you manage to race a memfd_pin_folios() against collapse,
> memfd_pin_folios() will pin the wrong folio.
> 
> Fortunately, there are a whopping three callers in the whole tree.
> You can hit it from udmabuf or iommufd or memfd LUO.
> 
> The former two will direct DMA to the wrong folio.  Fortunately it's
> not UAF as the DMA will be directed to a folio that is still pinned,
> but it's the wrong one.  DMA reads will read potentially stale data
> and DMA writes will overwrite that stale data but not update the live
> copy.  (The DMA will not be directed to some other application's
> memory, just to a leftover copy of the calling application's memory.)
> 
> As far as I know, the effect with LUO would be for stale data to
> reappear in the memfd after handover.  With the patchset that started
> this whole discussion applied, I think it might result in misdirected
> DMA to freed memory (I do not stand by that claim at all), but that
> patchset is not applied.

Thanks.  How's this for a changelog?

: memfd_pin_folios() pins folios from the page cache without taking the
: folio lock. khugepaged or MADV_COLLAPSE can therefore replace a folio
: after checking its refcount while memfd_pin_folios() still pins the old
: folio. The caller then receives a folio which is no longer part of the
: memfd.
: 
: For udmabuf and iommufd, this can cause data corruption: DMA accesses
: the detached folio rather than the live memfd contents. DMA reads can
: return stale data, while DMA writes update the detached copy and are
: lost from the live memfd. The detached folio remains pinned, so these
: accesses do not constitute a use-after-free or target another
: application's memory. For memfd live update, the stale contents can
: reappear in the memfd after handover.
: 
: Lock the folio and recheck folio->mapping before pinning it, like other
: page cache users do. If the folio was removed, retry the folio lookup
: from the index that was removed.

Samiullah's patch assumes the presence of Chris Mason's "mm/gup: fix
clearing folios in memfd_pin_folios()" which is in mm-next, so... 
->David


