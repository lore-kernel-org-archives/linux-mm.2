Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80D0CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 06:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534C48001B; Mon, 27 Oct 2025 02:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DC88000A; Mon, 27 Oct 2025 02:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BE98001B; Mon, 27 Oct 2025 02:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3465E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:58:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAA7416034D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:58:19 +0000 (UTC)
X-FDA: 84042990318.24.C034000
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2345BA000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:58:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgYHd1gR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761548298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec87UVNa5eRmR8hfs8sH6j92e6f3tj+hMNk7rV7r6Is=;
	b=cmkQpJNRUaOzbfcKz5S7Vvrgj8REwguxNFIq9hoAM91yqEu9Bo1VxFba3ingFr2Gc6Tumt
	DRjT+9zlfJ1LbmlbSgX03H8oxnuCadL4Vswa2effZSUDoJ1i1WxazHVjRYD8h0tqLH3KkY
	dHm67KTTqLUrBCpXa7w2SrcGHdbfOTM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgYHd1gR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761548298; a=rsa-sha256;
	cv=none;
	b=cnqf59XFNxGrOmxDiHAFCz5YrBWMX4W49kuSbcSgZVkqBReUfK6G47sog8R50kW5Xk2rPz
	VN7a0icNFy++Bcnuqe9ATdKcP56M7W4JLwMduglu2S+og8mLbnEA+dCM2aY7xaxdNxXJtf
	r+/Sr0LHHQ8s9UhVFDDB7On9A+p7vCM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A0046038D;
	Mon, 27 Oct 2025 06:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AD3C4CEF1;
	Mon, 27 Oct 2025 06:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761548297;
	bh=lbGgWupkovq81DImc+Wfj/Z+qTggpqUzQ5AribnsI4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WgYHd1gRoMxFqKfxyVNMKdMBnx9LTmiWGz9jsusgML8qyb1cDoittaMKbRXdbKibm
	 p3C6RKP/o0JYKQ2ITDj2QPCNF+39qqS3oj+PCGUyAR+Qa7GI0Pd45iPt0aSo3fcOZ1
	 bOEXHU78SCT2qDR5iScbhySSNt4n9IdSiyHghmqANQwbeVeQK9P9Smyu58ciepIfJR
	 nQLa6zLLFJMopTremXr7vWdGvhdPZL0ze/KJXCQz9zywcVPNoviWG+SMNVygDaaw96
	 Q8/6D7q2pMOfzkBj6yg1KTjt2J2zW9q4x1RKZ6mXMyH7ijGHy1jJOMEAUGEwZyNbxV
	 ohhV4WLdQZxlw==
Date: Mon, 27 Oct 2025 08:58:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
Message-ID: <aP8YADj4ha3trjJn@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-9-pasha.tatashin@soleen.com>
 <aP5Mcr9WCt5CHon6@kernel.org>
 <CA+CK2bCUc5Q5PxCy3jGN9CC48Zz_evq51d7Hps7=r9g28z7tig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCUc5Q5PxCy3jGN9CC48Zz_evq51d7Hps7=r9g28z7tig@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2345BA000D
X-Rspamd-Server: rspam03
X-Stat-Signature: wy8ncquoifeh37cbwdw9ut8kwmk1e9e9
X-HE-Tag: 1761548297-731927
X-HE-Meta: U2FsdGVkX1+l1xamy+F17+yIDqF5olVDo60n3qNUuAEbcsQFCojclIkTpccJy1F50iNMFeZ0kD2bUC13kU01AICavggp1TGGwvSmfkKWGCBv4LrA+cnD8E377gvQxVRWVYOwOHcIor0SteexPl1o+fEj2QJR8ioe4kYjZaoWOPXQ33XCmtMlFjZY0A9hVBd6qIauhXpXMdp+UP70rWLTtYoR22GMEVcuoVaKRiBvlktNs34/+6Gz00n7a8In8JTPVfXOgLric/fuC0PInJhkkNPkYb1wWHpTOScEZGn5FMot5N+G9a7V96xQvZDCbbuBsC6K4Kk6wFSWwEWHI2sFNEgl0/9maFLnhwIDk7LQ4d6/9Hi2d6DiZhmcbS6xz70x19KlPVG/0Iu3cOs0Q4i4TJ2xxoH4TbAHBiiikvCuMbdWpm32F904uhh1gPSJXHIa64JhpEj494kU4ZGrzB7AuoCj6hT2OUKDNTxITTlAELOFw9UKTBeR+Ypt/ZWfzABMywhhNk3WZpMhdm4yV7JhWQU4YNLhtTw0DwS0AZBLfvE2/F2c73W4NyNlRt8xFs2ZCHFGRMrUvyzPt01ehmm4LK+vr7nJvF9twSFU5KtgUZKIXc300C6g+oOVdyDTrkZvvH2xcKWG6IJgwSwVGGZ2R1/w+UEG6tcJLRq6lk3oYt2R4xkwQcC3EvPD3gD5Dtf1gsggQYv/ZYP89poSipDL9XmtlruHsUpHEphx3WbppMjDKyBDrHNULZ3Gi2ZwCPyzAOdSBb8vooYHOC8DVOLhTeVQ788zrc3PRnqJDqJ5KP/vlYCBeSzytrok626XsqtR3ZkyZTET5myvwXiOWEW4Y9YTYeVkz0hILvTh3M/PkF3LHSwPbB9xWsAL4cXH9iAdGu+Bv1MJIO4e7g9Hqagg3R/MQG7F+UR7e2aS9MX3k39xHSlWZyRSt48ur6tqd+ec2tWanMihYrK2tUWgInn
 B5pD4m4U
 6jj2DoHXzCEzYH4oRzyoP1sT8LHssBq0gq9wiesWkkgB87YJ4+Xdr+cQCxX0oFJBOIooINvT8ayjacz2QqRY2B1BR+VsdBRBcw4xAOSqJQxmTeua9RDP4ronAb+Qn9FY3KhDgoyH9PkzOnF5XB5LSq5F1mxuNGHC3f7D4BlQsmgdsc/HB4bSiD7eD4rs7UmHQ4L9P/BMop/EDIHN0aAU0x1hsgZ+cHOocR26Q62trp1TVWDj17gWOdNs4yzmKW43srFSBBBufiG0evfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 01:41:30PM -0400, Pasha Tatashin wrote:
> On Sun, Oct 26, 2025 at 12:29 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > @@ -2462,12 +2463,14 @@ static int __init prepare_kho_fdt(void)
> > >
> > >       err |= fdt_begin_node(fdt, "");
> > >       err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
> > > -     for (i = 0; i < reserved_mem_count; i++) {
> > > +     for (i = 0; !err && i < reserved_mem_count; i++) {
> > >               struct reserve_mem_table *map = &reserved_mem_table[i];
> > >               struct page *page = phys_to_page(map->start);
> > >               unsigned int nr_pages = map->size >> PAGE_SHIFT;
> > >
> > > -             err |= kho_preserve_pages(page, nr_pages);
> > > +             err = kho_preserve_pages(page, nr_pages);
> > > +             if (err)
> > > +                     break;
> >
> > Please
> >
> >         goto err_unpreserve;
> 
> While we can do that, we loose some symmetry of not performing
> fdt_end_node() and fdt_finish() if fdt lib ever adds some debugging
> facility to make sure that open nodes/trees are properly clodes, this
> is going to flag that. I prefer my current implementation.

Why do we care about fdt that we are never going to use and that's freed a
few lines below?

> > >               err |= fdt_begin_node(fdt, map->name);
> > >               err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
> > >               err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
> >
> >         if (err)
> >                 goto err_unpreserve;
> >
> > and drop !err from the loop condition.
> 
> That is going to miss one 'nr_preserved++' . We cannot do that, we
> could move it to the beginning of the loop, but I prefer keeping err
> right in the condition.
 
I very much dislike the error handling after this patch. From a single

	if (err)
		put_page()

it grew into a complex beast with special variables just for the sake of
it.

What I'd like to see is something like

err_unpreserve_fdt:
	kho_unpreserve_folio(page_folio(fdt_page));
err_unpreserve_mems:
	for (unsigned int i = 0; i < nr_preserved; i++) {
		/* unpreserve mem[i] */
	}
err_free_fdt:
	put_page(fdt_page);
	return err;

-- 
Sincerely yours,
Mike.

