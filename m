Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C32C44533
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A3C6B007B; Tue, 21 Jul 2026 03:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1E36B008A; Tue, 21 Jul 2026 03:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7085F6B008C; Tue, 21 Jul 2026 03:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42FD26B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:55:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB4171A0419
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:55:18 +0000 (UTC)
X-FDA: 85012023516.01.C819E82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0593B20004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:55:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwTdCDZ8;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784620517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fyuBmwDf+2NBoAiUA97wVQlsoPJEThMn5l0snSCjYk=;
	b=p/RTAbbMh3ZkAk4koivZ7HZwsOSkb9gyG/aazhJbdzJNIqNiZ+OhwureZ4mQ/iY28O0hU4
	THiVJo0ekofHInWgWyPVjegm3Seaf1bm3O3Op7fW1s9Q9RjppUc1mznqxkSy+f+mIymI4Z
	zvwChm+MbShEJ6+/cQPrMpVor9Za4Jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784620517;
	b=57NKx5fKLv4ecpFkILfGtZlKAdxmus7OGc4Ud9eRQHWGENdxcOREozDmk+UyGqDyI1vt6z
	PqbpkpZf2l6AqC0lYGOcKG76stRkX++Jqcu+jLEn86IHtr4KHeVGA7NLpj/lAy3m6Z0QYb
	5hv1mAGYSWjaH+O4tRlhx+SalhkJDTw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwTdCDZ8;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43E97437B8;
	Tue, 21 Jul 2026 07:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174501F000E9;
	Tue, 21 Jul 2026 07:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620516;
	bh=/fyuBmwDf+2NBoAiUA97wVQlsoPJEThMn5l0snSCjYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JwTdCDZ858uBa97dRIbYsqvjUYqjcK7MHEOkl8tOucsdC5ezY7XzsGSELd6WIATKd
	 eTR4kDVQf5h7eU0RGIheIpWtuD5Q8rl+5zeSF3AfsUeBAg1wBvdJ8hWxwE45O/CMEd
	 0nbu71zXHs608kXZAIgGNFQb/nLL514l8xMh3mX9xWtQYHTxk4k8PAZg/nVt9dCVCG
	 JWdy0Ay6qmN+QTFa9u4z7QHtvVyb8Qi2Hi3B/CYLZRo0jq4n1tXHFtowaiI/x8eKWw
	 /wQcKW1CE2re47XgLv9S800evVopE2vSIn7qyMF46nYxZeZk1fviFR74mkTmEA/VKC
	 C4aYXZaR6H+Hw==
Date: Tue, 21 Jul 2026 08:54:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
Message-ID: <al8k9mvfZRA27G7m@lucifer>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
 <al56t4zyjYlCl-20@pedro-suse.lan>
 <CAA1CXcD=zNg8q34DhsH8+BnXACA0TbD1+p4QEOCcY2u1qoie4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcD=zNg8q34DhsH8+BnXACA0TbD1+p4QEOCcY2u1qoie4g@mail.gmail.com>
X-Stat-Signature: 7j7srmkjxcxif1fh1kyb9zubikjqxs9w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0593B20004
X-HE-Tag: 1784620516-474604
X-HE-Meta: U2FsdGVkX1+9jSXkuOQTcKB944g4z4u0NORkDVIIsesqT8s0Kd0sDM3nObONL8sjpyp6wRCTmEtuCXQYzeRAvSIhzyLZIlnt7wHzrOZdG64DVpTEotAfJSgBSZMFBSXkE4OKA9/4Ycqn/nt7AKU09ao1X2LrsXxW7Bm8F1U/U5SfxhLFnRwDJ2oVwZPzmbW/3g3CH9UkemNZPezTIMaqYoZDlUt4g5IqM3gu/7WTyaeFuShWqMoaOQYr18D+LOfsHVEEp3eE2O0MPOK7PKilYwFpqHA7FiZWko53yYrup1J2g6d5jmCFDRZZogE92yNp9ZH41JylHbDphlW37QHUf3WQlPLK9y8Zs+N5O20PYbkGfv8ozLpxi237W5M9rHnv40XUKeCSaRg9nCXzwQXXop/iy19lxIzFLDW0Bw8Aqo5otl9rbWGuvWvC/OSUzREfRNZWikHHbLCp6B3ESfzdtdW2eBtpNRN7gy+58DStK8Cd3sjCLHDf5/UpeqCkRGnw9N1meJxi8AS8SyaXheY4sxZvdrZIVpkRoS8temkKQD++hWH7Q1z4fz7eMrDKF6QhK3JvUPFJTe8FDOZeulOAs6JdkhAt2iJzoMopWXP7RZ/QlOXAlGy7Aggv6yNJA8fkZxju9ENrYONWpLyVQAjR5P8YKClchmeigyKQuwsa9n+/zGpZQaWmOuBX+uPHJgpNoSTQRIxX6BNKmg4VRIshK4RxIC5rNvC7q5j6ldArOjoFTHHGhoBkJxKAJvAco5t813enMcwITUpwHIwGP/zPwtU9qa3R/UbXuUmzhTdwPtkpyuI1bab4scwrkio3XTNfM9FW9AyPyL1AQt569K/8/R5hNg+Fcv6cZW5M1pgAdpoDVzh3P2KmgRqt/4w2LNO4pdWRGAs/Z4qRb94cm4GV05UGkh05kvuHAKgCfVsCWu9HwwVEGJy5MUVwPJkul9ARJmMK5WSeOmBRlFJv4dO
 7jhjC6Sw
 NTwymXN6KpZPEvdN9KCEd1uixW2VUJc1wzEbBWd5iww2sMhVr63sZBYuEtMSdAIGjipyR47rF8hZM7UoRN8sIfid6QzHxxp2zp4adu11+xRb0YlZMhnP2zWt6hdZ1m8xSmlOHaj5TmOQkRSGcfYYcFdQG0ePGo2wdaeh1OkDYFZqke6+2cHaox7XDIZXgd2GiozDZMVP3sDbMu4Xw+Wr08WdC5r/OAOlpuLORpH5TqtXp9/E3P6WyQRka3CKR9Svdt/WIWt8HmWrzVF2SbZrLug9qJs4C1aT0GyNkas1VI3E+YIPkYKBsk1CfXtlHRntdGXspxP2RVLKxfOjO9Mal/uGONzcY1RdvtKiH1gdjyyvm+5Bsx4AaZjVRN9U2OS8bqlYf0fWLwhJt0Fo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 02:14:45PM -0600, Nico Pache wrote:
> On Mon, Jul 20, 2026 at 1:49 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Mon, Jul 20, 2026 at 09:21:11AM -0600, Nico Pache wrote:
> > > On Mon, Jul 20, 2026 at 8:33 AM Pedro Falcato <pfalcato@suse.de> wrote:
> > > >
> > > > Here are a bunch of cleanups for collapse_file() that attempt to aid
> > > > code readability and understanding. This is part 1 out of N, and only
> > > > attempts to address the main collapse loop. The exit path is still a
> > > > mess but I figure it's much easier to review if I send this batch as-is,
> > > > versus sending the whole thing.
> > >
> > > Hi Pedro,
> > >
> > > I have already prepped a cleanup series for collapse_file().
> > >
> > > I was waiting for my work here
> > > https://lore.kernel.org/lkml/20260715025941.1571316-1-npache@redhat.com/
> > > to be reviewed (and in mm-unstable) before sending it out.
> > >
> > > Our series have several similarities; for reference, here is my version.
> > > https://gitlab.com/npache/linux/-/commits/khugepaged_file_refactor?ref_type=heads
> >
> > Ugh, this is awkward. Do you have any suggestions on next steps?
>
> Let me review your series and see what differences stand out. You
> referenced part 1 of N; I think my series covers many of the other
> parts. I basically broke down each stage of collapse_file() into
> helpers, and cleaned up each part respectively.
>
> Whatever we decide, as long as collapse_file() gets the proper love im
> ok with it. I did, however, communicate that I was cleaning this up to
> David, Lorenzo, and others.

Yeah I'm keen that we find a good compromise here, as I genuinely very much
empathise with both sides of this - being 'pipped' on a series is horrible and
we generally really want to avoid that.

But I hope that some collaborative effort is possible here?

>
> >
> > I can try and take in some of your work on top of this series. But that might
> > be hairy.
> >
> > This situation really does suck (I've definitely been there), but I would
> > prefer not to drop the patchset.
>
> Yeah that might be hard. However, there are other parts I cleaned up
> that you haven't touched in this series so perhaps some of those apply
> cleanly.

It'd be ideal if you guys could figure out a way to combine both in a series,
perhaps with Co-Dev-By or similar?

>
> Cheers,
> -- Nico
>
> >
> > --
> > Pedro
> >
>

I'll leave it to you two to figure things out, I've left some review here
already (the general thrust of the series is good and cleaning
this... 'organically grown' code is a wonderful thing), but will pause until you
figure out a way forwards.

Cheers, Lorenzo

