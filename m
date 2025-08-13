Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0098DC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809F19000DD; Wed, 13 Aug 2025 18:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E03A900088; Wed, 13 Aug 2025 18:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F58D9000DD; Wed, 13 Aug 2025 18:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 583AF900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:22:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC7DD58F8D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:22:16 +0000 (UTC)
X-FDA: 83773158672.09.B53C97D
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03A01100003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:22:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VuxIDC7Z;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755123735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8JinYnL0VDr2NpcSrx00lGYsCzEd3kG2rmko+NI2R8=;
	b=Ah/5ZlKZe6MflHgXqrEyLPh+PcLsO64PJG9lN53JYa4bXahD4nAye/UcQgHES3fBPZdvxV
	NSRiIhDl9WAA6Vry9QapT3mUfUuAoJ1/OodslsOiOdYfDXl0gZmQD/NWygBAuCZP+cl9Gj
	gqnWszcuzdWz+kv7rA4OVQUddbFGX7w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VuxIDC7Z;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755123735; a=rsa-sha256;
	cv=none;
	b=NWqJMoiFQcffgYHxZTK+HEhtC7HKUWwsPLYlASeTxwzaSO43xlrRCsfvBOKPLd4ACQ0rgu
	27xAkpxifK9+uU9XkT8nkeG/b9zKh903IjNH+B7q2LFvBldSTVcc//W36aiHmJ5WW+kQgM
	Tw/lYj2SeFVw7cD4PwZcq5FhmyDuwCk=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-50e2e0ce5f3so1204753137.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755123734; x=1755728534; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8JinYnL0VDr2NpcSrx00lGYsCzEd3kG2rmko+NI2R8=;
        b=VuxIDC7Zs3x/Q4c7IJKYHhbv48gKTMF2wvcppcgGzwZuhL4x3zKrqaBn8ANGZg0wl3
         UQM2m4QJ38RfWoloisMqdRVaC6nByab4kYmfX2VQI6zRUZGckXH29Ltu9jqbuk3yW2rn
         4aj+3znE6ffeNglsz2HEoRn0l57yxx8mhsKJc8VzTY7ajzoTDtuVE9a0M2FzutxKjAPt
         oew3mKBOaioisLFGRWwTOafrnCLzNhbwiFNrCjS0mykdLjgu27Rns6rE0aJryTgdIeZF
         L+EI7iSSyCDvtiPP6a1CZUu6mCGBOE7NMx/YYiiuO6g35RBgIfJ0TXZM14OK06mAZfzB
         lv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755123734; x=1755728534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8JinYnL0VDr2NpcSrx00lGYsCzEd3kG2rmko+NI2R8=;
        b=QlQUWTxIBXsxpvlhVlb03Ar6gPRNRrdTFcCwXd9JPqUPgFUlnzehzPEvxE1RIHd1RM
         BUVus+KY/+F9Tn3zMAh2/tIQDx94TwWHaAXuAUAsDKjvPpHvFg/mAOkwN60kZ/JHgEZi
         gWfrggLf/NTmQ7Aqo3DoR+4sCFB/qTeBOl2mz+Lf4PHE3pGFF4wVjZ4Cb7vvCMPZVZF+
         7rK5xueoQv3OYngkFt0qUrvRqgRj5MMVsTWSUQh0eVdWk7cOL/en/a6clSQPL9wlJ8C8
         IY3i9hazZrVUIZwd3MUxBI6PJVW/xdhqxs1+IkxxPjhy07EOHsdfPqbxw+irMhrwpS+W
         2GuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw3wIGF6C9osZ5PUXQXEr23tAwh8K7wtesSBPo9sxJW7q2717XwIpzLcLK2dyG9Zzeq5WEoR/wHg==@kvack.org
X-Gm-Message-State: AOJu0YyE7+DkJtIpzSKK6QxLxbXF5PmxUGF/hGS2lBCIjKkodRrd2GRM
	HmoRtYIBnzOWf1Tr7lkf/ZESsLCHPgx2pJfZ9LMMwQwT0NZRIVoeASGekKhAYg0NnCp76A1RtCH
	5XFUU4QC6KlaafrxeoSJDWLIqBE8b3/g=
X-Gm-Gg: ASbGnctKUGqqklfl+yVHjMjmoWfiFqrfwGFIwCmsMNxPx4sYwI5unlZAR8f3h3HVyXj
	X37ZUGqvn6g4J5rxMxnxmhtPWrKu4GYwzT+1oaJU93AIzu/0POwNOVCO31WNpXSF8G3MBldMZ0K
	GDyGbNEuc13OStmqAhlZtS3B/pEXRHyZw7NUEUr926MfUw0ZpxcoYwbUjPz+8VSqwxFjOfTKDsa
	lVg0xwT7s4C9OwJOAg=
X-Google-Smtp-Source: AGHT+IEB9dd27CpqZ3tZhuk+dnRMQE0xsKyMYhBLvHiogzgWl40eGKb7DS9F51dOLlxoW3soSY2bjnSiK9f9mYkmwGE=
X-Received: by 2002:a05:6102:688f:b0:4e7:866c:5cd9 with SMTP id
 ada2fe7eead31-51063b913a7mr150333137.11.1755123733925; Wed, 13 Aug 2025
 15:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
 <20250813144737.c3f388313fe13ff44856daf5@linux-foundation.org> <CA+EESO4rMS5ot_wJfWVT+7rDKYgk187xnZJ3NNZsFgUXCbG1yQ@mail.gmail.com>
In-Reply-To: <CA+EESO4rMS5ot_wJfWVT+7rDKYgk187xnZJ3NNZsFgUXCbG1yQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 14 Aug 2025 10:22:02 +1200
X-Gm-Features: Ac12FXyNzZAvcnVYDVRHlxe6ItaT4qyY3OAZCnNUj5DlNTf8sPTsX6OWzQ8e4FQ
Message-ID: <CAGsJ_4w2L6ztZZG9aypa7DVpSEt5vJWPgUuDj7WY5KYtZRFvuQ@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fe331xzd5aargbb3un8mspebifpykmbf
X-Rspam-User: 
X-Rspamd-Queue-Id: 03A01100003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755123734-902143
X-HE-Meta: U2FsdGVkX19N2tUghJgpr6aFsq1WtqbpPLq+0C3YIPtPHPnDu2wTaI+34vxfOlZ+BSpcRxVVZ8CL4MaA5truhenpoV7UWHVzNQDx5BZLuj8UcHXtklR1YZVg/WWmBtE/IB4ytf+w+J4iNOzRhhhhhPTS4Ttosy8e2xW8riPg4Vjc3+qoSelBuJ44pOjrapetnAb67YigKIdVxYBJOnwO4GMquL9HEHm2vHfTtVOEK8qybVoF3HSHA6yo0XGJnwiCr4zzGtRC8NRt2dM9/guUnTQW+/dhd2JWGdJ2GjQGKO72Oemm/Bvl5v0rVw0Gp06gRyvCtBJc72TyU0/kqDNv5mUcvTrInwkwGu9zPVLcROiOHtFgXTPEICnNGnxcRjp42rpTalPoW7alKKL9CfgqGIWuGb85yanCn4dP4hCbVS7WCycpJLo7U+GZMLY3q3G14DZrUwkxx4n4Q2GSXE0MaxtFe8V9dJjtM8BNF0OIXP7exf1cOIfFY21ddPQsRqnH1plxCEiofoyMd55jep8Z9JdTXlrnAbH6TWrDOb49j/o8i23mmSgXumbNJWSIZ7JvAdXzoIbeXfCPrWOdHOd/Gf7OS1mOhQrgAkclU9LsVJiOeYuQ5ymCMjLH320m+vTDlcgn9z8WM/w3faD9ns0k5fN18RDATmd84M/OfX1HSksEX8+vpkV/VKtad7KbiPMnxzRAxIkuLP7hL4P7rlG08Z3tdvu3ZzzEhYzr5JamCufUdPbH4hRcGG00y12PoupXoU/JAmGIbmnuFbmDcQUeiyOfy8JDBz4lRDmnD9QFTKVTVuxmvxMC1L4YTZPAmU8IB5I8wrQiLvNBz0SveM6W//sOEySAjBvdCg8NaRPYQvOHVvRKupLQYEzvQa8icErfshfISoGeqVtdFk1I+BoUti7Lyd8CR8oi4uB5+e7N6D5i/o/Lx0n/Lad+aTWIq0ODzZXK4quFC/o9yMkFxKR
 3j8DBwVt
 z7AZPFTAnTlFzqtAeCcimAR2/ryrPsKKoyiUivjdBI7rMkvtGNFx7Ge0P3fxgKY4vpCp0+5sCjj5XZmNGHFJnDsz6I1qDUmgMCB9RwCCJeKCZnE2gCIgiMWqJTD4mkNsFn74H/HnxWQIxfFJfw1YfeVReEvBVnoPSkRtXowd2V6DOLfGfvVdY2K9DVfzbR1Wjn5L61NsuUmLAFzWXwGVxJ/PWMItTFkWDqCKTeSjXvc4enHD2IEzyJLRNYrv9N0LHRkCp+639udSEVprIzG9Jt91md4jt0Gd7QsXiftw/CXKpgBaIBKBkwXVn+AA/OFt9oeSMPOi27KlsnaaawJKL9wEsCYnA8+gCYRygx6n0d92OWauoFsEQ8Igi55cGhH86mSMjPDjqS6L/2GZzsIsnJibKTYpv7WPGyz9W0auOSL3RqvO+fxc/lj093w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:02=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> On Wed, Aug 13, 2025 at 2:47=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Wed, 13 Aug 2025 12:30:24 -0700 Lokesh Gidra <lokeshgidra@google.com=
> wrote:
> >
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is require=
d
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD=
 GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the tot=
al
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), an=
d
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> > >
> > > When the GC intensive benchmark, which was used to gather the above
> > > numbers, is run on cuttlefish (qemu android instance on x86_64), the
> > > completion time of the benchmark went down from ~45mins to ~20mins.
> > >
> > > Furthermore, system_server, one of the most performance critical syst=
em
> > > processes on android, saw over 50% reduction in GC compaction time on=
 an
> > > arm64 android device.
> >
> > Were these inefficiencies a regression relative to an earlier kernel?
> No, these inefficiencies existed since MOVE ioctl came into existence.
> IOW, the patch is improving performance, rather than fixing a
> regression.

It would be nice if Lokesh can backport it to older Android common kernel s=
uch
as 6.6, 6.12 etc.

Thanks
Barry

