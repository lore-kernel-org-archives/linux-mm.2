Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B720F30296
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 00:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B966B00AB; Sun, 15 Mar 2026 20:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D99C6B00EC; Sun, 15 Mar 2026 20:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1256B00ED; Sun, 15 Mar 2026 20:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF0156B00AB
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:43:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A11B13C2B8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:43:56 +0000 (UTC)
X-FDA: 84550078872.24.9C7B14F
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2B981C0004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:43:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rE/VXmeN";
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773621834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
	b=ZrcdtTofhAP9PvDT721opItn65EZPqVA4e4yKdyls2qEfJF2ok6tSokoh7T7p+4HkOKoPY
	Nj9vZAqG+k9zKAJQQ435zfhkMk8QbijFsAafqBFJxgAYiPnoUzH0txDWD93reZfeOoP0zu
	b3Bcs+NRgbWTIro01AsvtenVgivLb8E=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rE/VXmeN";
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773621834; a=rsa-sha256;
	cv=pass;
	b=gnbRgufbCgDpcrT4WO1+QpWpAoMUU4345GltHIOY46FrpD2Wsckpr4BQdrHuk0B4WDv4yY
	xw9RObxiSwM3qVo5mS8FUPo91SCQhQqqR5B4SleSEN832fImyxEJsse+bDThR2G8U+OZH+
	2jkxWv8z+6sCwUaZJ9qE81qJvHFmr0g=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso778361cf.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773621834; cv=none;
        d=google.com; s=arc-20240605;
        b=NdQrpE6a24GCI33LUuvPBND/zVdokjKpeiNtK68AbksmuQh4HokLQl+fJrm9sCNHt3
         ywn6h/cwZJhqayJcgAZHQ9vZQPnGTsy6Zi/FCdG7G5cZ46KP660K0Xf0w8bojRkM6GpS
         BT0oTiH2s/zRqQLo/t4RvuwFakx3DNJDNETCDPc+tFziLQRQJ29hhgEad2fnLKGGBB06
         0iRDQUskuNR+fkL9GnKsag6lRIQUSYNy9Fj0K1PQLoC3tfbDIBB2Ou/arwUx78oA2tCQ
         MCeAelhyZ+pD+ybHHN3q+vFWE93XkII4vjXFHlhLKeAw8nrm2wusixlrul7KqyzIzEUB
         I7dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        fh=D4/X90AF/yBWSUBUsZrrT3KBFQjukZAceLmzE0vsJuM=;
        b=c36YWZFg0GhYXVuMCCofleXW/YIVlTIXaSoOVJ1/lOO1Hl1GRUqckWzs/auKPh1IX9
         hPw8oirrbQj2fGHQ/EG5GEegwblZOskmXnb+D1L+JowH8aZ1KPgZrsgg8Sacau+tfV1a
         Cr6GKEEEGSvabUkceHXBGpffI4dYtLYQGkYkZIXakHsykXK1P+XSqO1TP0f/f5GTj0nY
         BdS0gO4hmv0WW3313AD0ctMmD9cLrfGencbRgjALbufdDBNj3mZK159qtIDlbBmWhvJQ
         bbDBzHnLIC2gElZ94oskswe96EJKVgHz/kRzztHFWEHlhzUqzB0UknVLtxbCpaOpfAko
         wqGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773621834; x=1774226634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        b=rE/VXmeNLTXbzezxp07LcRBlt8T/2A7iTvbc1qQGz/fc80gnyUvfPI2WJw2PnRpyyO
         3vCXYuS4ixvrSg3hD2Q6kewkUloxse0SbOBl7QF0gtz2kutrq+41SLMX3+JRYSpdjLC5
         LRIl3mT6q4XCWcnRStY52urmtYqYxEhdNYL20wxYqHcQBjXsK7oHqHTqvde4SWHIK+dJ
         HSeNmKxvMY37gn+iOR94YLZ5CX4D5fA+TaL5NLa9lxprmWzx58mAle8sRGAb4imCXjdr
         J1oT162OU578C0gd0vOj18sv8zSr4cvwlYH1SdK67UTN7QB3EfcowecoQ94UmOqOJBR2
         eBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773621834; x=1774226634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        b=Yul8DSzkCNCSSuReTEEhvFGSSAKOCxx2RyPEuh6g1fnWQXsu2Y2AJYsVwD0m4v82Me
         jURAH6jadliCF+lOsJ2U1eaPRItPrFb53TuQSnMt+AK37LeDtYr+dDh+c74E+VBHsoad
         b5xiLoYiPfju0/T+o7d0/fCF8sYaaL7yy3alD+tJlRLDAWL68YdTCFpwksmhPQPmBN/0
         ji78M2cVZ+64DQImAxP26AjIU5NdE5v1ciEM64igExoYY4rMnytNHI0jnfLeX+zUAHjW
         0/x3UOuUn+BqSAgnzYto4Qxz5KZrfGSV6LC5Z+Y+LLf8H0vyPKU/ubWSdBZpm4zT2kaS
         XJVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw0xHrAFYVw7NPw+EgqpngvqWNfnAmFvw3HhcAB55Ki8Ulv0V2M+gHFLCIKMuawaM3v3vwzn+8vw==@kvack.org
X-Gm-Message-State: AOJu0YxodEMOQzzIklHm33dfIscrXhIVU1IFdEpmqhLV8erLVQ1yp2BD
	pj4L7LJ41MnASf9DDrrCQn7mBNvVDrofuAraD56TrrxPaTFGob/kH3yOZgcx7nBFe6gI48EVwlU
	7kvtyrBS2dND1wfZoaAb3INhZcEGtzBdAtnbnxDP7
X-Gm-Gg: ATEYQzzoKYLshZsp/7A+fhbqulXzEzJWQYF5GwMKzA7IRt1hhKe4Q/+k+oUSI6ci2tZ
	hZeGX7u/Sps+ehTPMsMmuaxoxJ7ZvGgzJZm3ZGrNpQZkEgaQuP4Mi3NP1WQztq+cWKkpSIoRmTQ
	KYFSfMCfiIdugE9oDpND6uC7ddpSRmP3HxcQBIfJA//MABlUbyenxxN9J7+0oeUJO2KravlI2DU
	buSkmBLimqsucLJf3/U9xC7PSzKn3YCUS4dewIap3gD6nM/1SA5hI1A327AZmIYpu7EfHgEbN48
	L1PWJQ==
X-Received: by 2002:ac8:590e:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-5096aa2ae2cmr17578141cf.13.1773621833001; Sun, 15 Mar 2026
 17:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
In-Reply-To: <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 17:43:41 -0700
X-Gm-Features: AaiRm51H9IsCynzRpnxAc6_DrzYXD9cjd8fR558hmylwDQfMj5FrJzUnU5dorNw
Message-ID: <CAJuCfpHVN66abFrJgorXKBsjv7Ut=CP-E4NpLMC4SW613tJwtw@mail.gmail.com>
Subject: Re: [PATCH 03/15] mm: document vm_operations_struct->open the same as close()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A2B981C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: b4r19qw7s7y1j5rbjtxz1m674ejme91h
X-HE-Tag: 1773621834-484943
X-HE-Meta: U2FsdGVkX18W+yu5QCAe05tT2EonAjektJkhamZM6YzEP0kRcWkpHjAZAx3DBs5p3N2IhvXLfD726JH18aPjyRRMlmeRi5iXll0UqMCHRjFZwssDtV8WMSqfwdwTEPVc+0YYgIRQUdcEpZ8eq7j6q7Zate9xtje0VbQiqWwvZg8qUre+66aCu/avJl3YBWqOMtLByA1XVdKyy8hfekFVaUIsKz5sfpudohlfdZWddpDFmN9AX2oDDLcRZYQHNBlL9xfeQ22XjpFiKECGqdDKwQNmBGCxs1uO1/bP+18r4i2/3kWDgBsfLXURQcLCHfKZD0+YISyuvXHirAATk1A57Q6VEkn5MhI0cH8vr1MbMRKRYp2pssxq7BY2mNGv3pJH8nSJ/Tv1FRVEG9n3tg4KVH1Qaba8LvPlZe9iNqE2OlnFlMzYDge3liMozY/U1owuGWBKEXpc9xXeLpJj71TtbpJVK0bSP6K8qwy9e1X4smWUG7qkmBr9d0cnyZ+bZ7SWLBmxonu2meRfpj3b/bCAObJaVT6tr7FlrALKlw2VAzCyA9jhbER1DLR66q/4VJ3Of1d+mXyiRpCw92xxs94nxJQNvPEwG+6uvY9QPNXYilbnRFemIrl9o7ZK4/xo7rGBQdAQ5TMlfY0SK5vQDWVwZhxLHzRc216MhUbTkKACiwYKJ0qdsnO3eQDr1Bbcv1hJr51SlpyfsN4jSo5PtpzBjo1bfm1maYienK7UOnp4n69mrWQyFa+kG1J07THvNaqwLI+Mtd/BzBSXDg+UqnM2Z3Ln7K1n7r6VwEeQGVGpl1A7jvVL/wXVQRxNWhH+c40Gdp4VGdPu1uOyGTxObVk2OM/I+1TrXzyxTB51c04TxV7qIyf6vCOsc+0JHhLc8PWFJQukuPoEND8gt24dELCddolVjWxFEIk4ENA3tZz7ChHQhAJg0kjdaIf3lPS5UseZQasFs8Xc+eRaNw601L8
 Bnt90H91
 R+VnSI52cSmGZc/Nc7qXKDRDKzQIrZZi8wIx9TfYtAHCbo17rT6JTADbPcly5GHnBcdb+ZKUUOavCOxhTsRrWGtUw+Oi53jQYQL1e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Describe when the operation is invoked and the context in which it is
> invoked, matching the description already added for vm_op->close().
>
> While we're here, update all outdated references to an 'area' field for
> VMAs to the more consistent 'vma'.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/linux/mm.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cc5960a84382..12a0b4c63736 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -748,15 +748,20 @@ struct vm_uffd_ops;
>   * to the functions called when a no-page or a wp-page exception occurs.
>   */
>  struct vm_operations_struct {
> -       void (*open)(struct vm_area_struct * area);
> +       /**
> +        * @open: Called when a VMA is remapped or split. Not called upon=
 first
> +        * mapping a VMA.

It's also called from dup_mmap() which is part of forking.

> +        * Context: User context.  May sleep.  Caller holds mmap_lock.
> +        */
> +       void (*open)(struct vm_area_struct *vma);
>         /**
>          * @close: Called when the VMA is being removed from the MM.
>          * Context: User context.  May sleep.  Caller holds mmap_lock.
>          */
> -       void (*close)(struct vm_area_struct * area);
> +       void (*close)(struct vm_area_struct *vma);
>         /* Called any time before splitting to check if it's allowed */
> -       int (*may_split)(struct vm_area_struct *area, unsigned long addr)=
;
> -       int (*mremap)(struct vm_area_struct *area);
> +       int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> +       int (*mremap)(struct vm_area_struct *vma);
>         /*
>          * Called by mprotect() to make driver-specific permission
>          * checks before mprotect() is finalised.   The VMA must not
> @@ -768,7 +773,7 @@ struct vm_operations_struct {
>         vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order=
);
>         vm_fault_t (*map_pages)(struct vm_fault *vmf,
>                         pgoff_t start_pgoff, pgoff_t end_pgoff);
> -       unsigned long (*pagesize)(struct vm_area_struct * area);
> +       unsigned long (*pagesize)(struct vm_area_struct *vma);
>
>         /* notification that a previously read-only page is about to beco=
me
>          * writable, if an error is returned it will cause a SIGBUS */
> --
> 2.53.0
>

