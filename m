Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91E1CA1011
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160B18E0005; Wed,  3 Sep 2025 10:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137BC8E0001; Wed,  3 Sep 2025 10:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074B88E0005; Wed,  3 Sep 2025 10:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC2AB8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:43:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BC87572BC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:43:17 +0000 (UTC)
X-FDA: 83848206834.24.317133D
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7D1D440007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:43:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QXv9l483;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756910595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGwaaiEgG2uJ739eo0IvB2a3tBMnpx7x96amjNxXmdE=;
	b=rBCzsjg0MNUGnxs4EVib+06GfiiPphNN8cyqgxQOAEQLxWVsDntFkyguXn2vuYh1AkrpMk
	zylzWRouM/rUAhpQw2q5EJ5OynyxRm26TI+Smjfgene6U+niWeHgnlZhBIMX2RCLX6EoNX
	Ijecfd8IcJ6EtjrsHDZ6QoDbg6COv+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756910595; a=rsa-sha256;
	cv=none;
	b=kWBxA1bwJotiVxDpxuOm0ikuUL18chM35mRjYD66AqELpL/yAPewFbtOWisehZ8KdnpeUE
	cCwjFWPwiRCXjDgqj6HI8bbunj+5uGJaKrvSe8QfDeWmRoG9/zQwoooU18YVjdglCGkdHd
	RyLJwyN7oTGe5G08Or1BmlFIunuNRz8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QXv9l483;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so12088a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756910594; x=1757515394; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGwaaiEgG2uJ739eo0IvB2a3tBMnpx7x96amjNxXmdE=;
        b=QXv9l4836qVdzuBT5jgQncj9uXNKlZLCakrOrJw4HJCAEcP8eX+iD5je75ulhI5ZpA
         Y7lQ0G3NWOWzGcZRIB1dyF6s9x5uM2FgvzQPgE8ILYZzReBwN1UyIcCVOHJ/ABO5uHar
         iBkHpvov1Feg63FpZcZzBLObG023yYrmzdJhs0nQ8hS+EmT0Ps29R2LW8ZADljbmPple
         tdpR2M5sPmWqR0315jkq7M7vIjome48dSJ3GQAqXwSzPSsRUQ2gCp8ye9cQj3l4fIrlS
         DsagduA4I+vomhsap+Ma1ewrrvCQ6/lZpwTDTPD649f251CtZw1Ie07BABRsQv8Ya2rP
         3Dww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756910594; x=1757515394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WGwaaiEgG2uJ739eo0IvB2a3tBMnpx7x96amjNxXmdE=;
        b=aNER5P8i9sa3HH+4i7l++ANmbj4zVgnKs8xp3MM1t9GZN1Qps9lD06SK//aL7Lrz68
         11804ej+IXOkhUEUEAOwg8849ls/FyGq9Dz3joi+mCDkQz0w75qT6lq/ZBtST+pZBLBv
         /Cu+W3o2wXfNhGW2mCVhZBV8s/sdYjdJUBAO9MeLqPLjjhI0s9xhUPw94rU3RHcuGAuR
         fsZqw4aduK01YvyWX8e3rZvMqi2Y/Mhx56xdGC/clum+XI72XNLvDmFB+o6Fs97IL48T
         2ddbk/W6Vt+1R4RLWcIbWgaIPFukDoCUcWuD4S2V4CVpAYvzknUrgW4daTaTxn8XQ+0B
         RInA==
X-Forwarded-Encrypted: i=1; AJvYcCWmUuLo0Yt8QU9fjQ9YgJK573MHn2/KaxzAYYtVMYET+GL6jE+IR9QUW2LcEHKM3EWD+VJJoB3Lkw==@kvack.org
X-Gm-Message-State: AOJu0Yz7T28ijK1yS9HoMbq7KOXezk7mnzuGWU14HnHpi2f08rkyEHRf
	6ZWw6qzy47G7PK+Af+Ul08+NGOhnvR6/0ukuB0Dm/XHu8StxuF4GoMp17Hw/uasFKpgcK0C0edL
	Pw36jacfOs98bs7olwHs/Mcgy5uiFdArdFYCxy5j/
X-Gm-Gg: ASbGncsI70qAeE4Q1NMg6SznXdS+3kMGuY0R7e1+65E6/10xtle9d173L4s+xdIxj6C
	0Pj55l5hYDaMpSkg4168s9+JgJMytpi1eGKAMY3IOdkVtMYScby5xQHgz6aShK7h0YMRREDKIQQ
	voCDrh0ubaX2zkfTgOzdA75/ffqFF+3eXq3b0j/Pao+1vmh4AXgTGZ3SYKhkU92HLwQwbEsg2yi
	hOBFAgG17z8nwiZLiJCrjeCX/TIWpWL+Jx5mERaEcmM5Y2C7o2D
X-Google-Smtp-Source: AGHT+IETLxUe+4k2b4K1IWMHfq+S9CNpDio0ukz77dfuuxwdkY0trZdeCTyAjWWcWxymJkgDSATXOOwKKAuH67K7jyM=
X-Received: by 2002:a05:6402:11d1:b0:61e:c5d1:5d4b with SMTP id
 4fb4d7f45d1cf-61ec5d15e4dmr191325a12.2.1756910593673; Wed, 03 Sep 2025
 07:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250226030129.530345-1-riel@surriel.com> <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com> <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
 <920DC212-880C-4688-A577-2589CABEED75@gmail.com>
In-Reply-To: <920DC212-880C-4688-A577-2589CABEED75@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 3 Sep 2025 16:42:37 +0200
X-Gm-Features: Ac12FXzU2aeQNhD7RbGeHx_UXqP-ts1SYeO5NRICDK9MHW-Hu7SIMmM_qY13dsU
Message-ID: <CAG48ez27-HYHoorKU00xByDa9mu1Vnuh4yjE3sr+6z6ATKnzSA@mail.gmail.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Rik van Riel <riel@surriel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Borislav Petkov <bp@alien8.de>, peterz@infradead.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, zhengqi.arch@bytedance.com, 
	thomas.lendacky@amd.com, kernel-team@meta.com, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, jackmanb@google.com, 
	mhklinux@outlook.com, andrew.cooper3@citrix.com, Manali.Shukla@amd.com, 
	Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@intel.com>, baolu.lu@intel.com, 
	david.guckian@intel.com, damian.muszynski@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D1D440007
X-Stat-Signature: czktt6spk1xpe8x5wsgu3ctkdnrgsffy
X-HE-Tag: 1756910595-394979
X-HE-Meta: U2FsdGVkX1+i5pUwIuGQ55Ku766DLjDs/RZpVPWoXDDsznsXhh5IXxu/P7qM19k5FC1/ZKNY4MKIYa+hC4+RvAgNSU7ravzS0RBbO7IV4WTVXfaiJLdFq9HdcufuE1zoIUo6esukk9tVNViBo7MNpZCile8ae7fleCrPti/Mhe2TQH3HrCqPYkiXhLDUNnBA9GQBhKs4HVEc19x91oQCNPwk7OykS+x5JARGCPW8NyR5vsbyVzabf48JwCU1nVA/hYTgqYmwMwWB4FdfxEeYs2wSTJSZUliJ8daCT9w3NcSlPe2vfkyl6RjkHpeoFVdm+DvudDOZXfoBQrA5Ch2qfrc/dj0bMC4P/7TlE0G6xae2R24HyOC5ZuzVyTVozUGJgF6FMum62ukbj94gRkguDP+gDUvEFBfIeFvAkysK8Pvr6jT0EQTMjAQp+etpaXFKAwSyPkx/aTTUaJOzXMe8WS4zELs0VoD8B9qBlwbrQqYjKhPHW7CVO4pl3YuToW5wFXFmRwFQKwuT+KvVY1KhZzftzH9/GKZg2dB+M3ItoLFWOY6pemk94XNYfDh39rxGYpYQm6CyTRODQ8skAtF37Jk50DhF1tKX7PrAxt4w27Ojz1ClTYyHuqw095U+f8M1WUmUTIC4NzuMu1iFN//lhryDs1ECKEcUENTinLvKrOUoIZKuLBVqKyOdFG6V9RmVGbg+b3pAr0fwuppxMGOpqmrbjlYll+u4Azo/nHWjNNd8tGYy5NRCr95DlYI/lbaO0OI5iwSQb9txuNMBsU86+f0nEbBA7XFTMz3nOIJkq9bmekSKEJXAVhGYkXiPQtGRkJc5bjb6j8+Lo+jD6MR5l0kBfDUSTs1hoP+tWwdSJOdKKpLOIVNa8SjQx+YIA233kwUigtb8v87AAYfjvj//gB1agrMIw1QXJqGquSx9fWYvoCj3tSrOSJyUUPGtOJfpbLMiO8+hslCD+F0BImv
 IFtdyORd
 Wh3uJcGSVSHsHph7gPwphtNPdvirHFrj+sLv3/hsvFrI4p2/fdBxhuXyFPY+z+6LACCxGiws3TXuF6AG19azPE+3D8B1D6DRbipurENLpgsLIfySy+0jBgrcyb6JH5pWk81NqzCbVzK+vwsgCEkhdNHWAUokhalJrunfq7feSRNKTNxjd8oY00vSZFIQOeoynfxjNdrEuPiNXvxWaytHLiSHb0aQoyUrvDdeVDI3QlyRIL6PD8aj6KpNWu+xsl/jr1EiPVFnZv2mBiB1bATg6OLKSUGFmLgMPc695i7SJu5uK5MQxIZyMdsUgXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 4:18=E2=80=AFPM Nadav Amit <nadav.amit@gmail.com> wr=
ote:
> > On 2 Sep 2025, at 19:05, Jann Horn <jannh@google.com> wrote:
> > On x86, IOMMU flushes happen from arch_tlbbatch_add_pending() and
> > flush_tlb_mm_range(); the IOMMU folks might know better, but as far as
> > I know, there is nothing that elides IOMMU flushes depending on the
> > state of X86-internal flush generation tracking or such.
> >
> > To me this looks like a change that is correct but makes it easier to
> > hit IOMMU flushing issues in other places.
>
> This change is not correct. Do not reference info after calling
> put_flush_tlb_info().

To be clear, I worded that very confusingly, I meant that Rik's commit
4a02ed8e1cc3 looks correct to me.

