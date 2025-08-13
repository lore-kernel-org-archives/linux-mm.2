Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E000C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 09:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC18900051; Wed, 13 Aug 2025 05:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3E1900044; Wed, 13 Aug 2025 05:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10B6900051; Wed, 13 Aug 2025 05:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B107B900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:29:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E12158438
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:29:42 +0000 (UTC)
X-FDA: 83771211804.25.ABF9E1A
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79F30180006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:29:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jso7J1n/";
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755077380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4kWL3Gz2TOFzlWsu7ST+2B8+6Bmel5cv9oUEg978SI=;
	b=1BKa5+K3Zz06cv1polOsZDlMylPbQmp7ouz1V0oWcowjCXL5SYRA+KZhdSVOESkaUdJ29r
	FqPmk9MIjFD8dH1EKGNnHmJ0iYpqRhuddfyquF99yFLahFXYTYMRkxOHr0P11rQZk7Mbri
	3EbklfSLIGAuPJzFCoA4r2zVFFChN8w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jso7J1n/";
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755077380; a=rsa-sha256;
	cv=none;
	b=fhcxG1RFfaeOMPupr9ggnrGhG5TFIAyHBjqfJ9j05iBPwHy9oQP6r2N4GIJeUcdUWlDO2n
	92002w+Z+r9hUmRIaZB1sE7tYxtnhb/s0NZXwI+v3q5J4liEQkGzGRpDHfBA8hMJCUHn38
	qpkW+qO2kdSA82niksxouTZfe5ah3H8=
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-88ba493e984so410283241.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755077379; x=1755682179; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4kWL3Gz2TOFzlWsu7ST+2B8+6Bmel5cv9oUEg978SI=;
        b=jso7J1n/d1ByVuQNn4+RdqokqLnOXWUUxzR63ymUnKc70LTZNmSlTAz0VTk4xz3wZ+
         CDWi2x7P/mJ3fApdciZMN7KXgqZFf9XawyuV0UybDJtpmRjMmWY/ESBSPYNbCDJT8dT1
         TtsPVcwd6vPNdt9RyKBsUB3SOOwXT0j6QMiK7giJrBzLijeGOWBUHCCUw4oKxefFKwfZ
         Fe099oXO6GNakpUTLCvTrwkD5NupiQ8DBIIwcgOG6gBSXB/ufErdkfNOMpDXN/X+Lcox
         Yh0mPlia841uwE5Lpo2NS3p8A8l9Qmn4/WXQVRBw0PIs+y5aJSR9O84Zf2FdCKkt6GOb
         UDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755077379; x=1755682179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4kWL3Gz2TOFzlWsu7ST+2B8+6Bmel5cv9oUEg978SI=;
        b=RY/5RKZ4HkHrx/LgHbSk1Q/hblwbjKy2HgwBy1pGpwCst2nIzroJpspTLBk12LrJ0Q
         n6Tfx5cfMNziFrHou8SZLVhSUFB13UKkQP2/jUvtKejpJWMNok+Wi3FiXvdKEfg7uQZF
         +kVoXNEuc4b+D0lMBDxWsODv7dTYF0jSYUmbVb9gmE3ikvyQ6iy8iN6MM4nRnsXaukTt
         xxoKeV94KJB6wUE7l5faBDb6Vn/5ENy1ulKdHRmVeiHa5YZ+Kx4OYqnDndx+mtbx3lf/
         6TbD7B8qLCAuaegMIkBfQLBZ96Tt4En66/ujWm/CGrPZNd/DyhzNI/pVjhVuwwLuJm5k
         h8vA==
X-Forwarded-Encrypted: i=1; AJvYcCW3V5cmdAnZMo8FWwDuYlgp3jVMiSUh+HBawAo//r2bTv7XeAfZEJOLxMj3pXKIDTruNmZNkDRPgg==@kvack.org
X-Gm-Message-State: AOJu0Yyp+bM3osqesbyWg/e7NMWXL/gl6X0my/KdJjFHuMRL2fF+pqk1
	rW0lj8LUW2bQHbpTMNjTmyiR8sz5fvx+y3aRGtLzbNM35qi4QQAhLSMXdzAtOc+WQ+cLNF0VtyY
	Rq+IjIu5HzlhbgN94Rg/in4aXbRRxgUI=
X-Gm-Gg: ASbGncsINF9PmANxgoduxGxzowxx0EQV9hue6I61sBJmgacXghD7b0q845Hk4hOX84B
	2LLIuYbzZyIumWjd8BseGdrrVvRP/yFl/3TC8PvEbuJQzBp3u8UgJUBwr6zzuCnm6lUKxH/RNJU
	amjHBdrxMJ0O1Wx8Q1GgD0lBdeHopAyyLtGefC17xsU9SefawRQLq/bxhsmy8CZvXjoEab/Dn0F
	gk7EwNkyvRVIH0DoTms9jAV5h/L
X-Google-Smtp-Source: AGHT+IHzVnB+RySoeR02l/m4FBqF9cFbiEyh6+2R3vKbPFEwr3aiZ81rtngMx46hTALCeVUB86t+4btFV54x8MopFRs=
X-Received: by 2002:a05:6102:510e:b0:4e7:866c:5cd9 with SMTP id
 ada2fe7eead31-50e79f44bd9mr550744137.11.1755077379395; Wed, 13 Aug 2025
 02:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com> <CA+EESO4JFCR5P9PFoY2zo+X1Y-qv+-yy8X887isoqXwfQBtn1Q@mail.gmail.com>
In-Reply-To: <CA+EESO4JFCR5P9PFoY2zo+X1Y-qv+-yy8X887isoqXwfQBtn1Q@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 13 Aug 2025 17:29:28 +0800
X-Gm-Features: Ac12FXy6n9uSdRGJV-oDkgvaggWtIQ-s6auZffzcE9MoRq2yoNDzUzt5eVn4S5U
Message-ID: <CAGsJ_4zK5iLtYaT2o6ctnZNUgRoxrxkDJ4gnGrTOD7CW5vuRHw@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 79F30180006
X-Rspam-User: 
X-Stat-Signature: ibcgq9c19aeygq6cqieya88nzm4ie1k8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755077380-14770
X-HE-Meta: U2FsdGVkX1/PvlwQrgD8T4pWOwhrTHnQpPgYplBoF7NI+llGnc2JtfhgIw3ZTDQeh9gbzBpVaqS6CWCW+TBuEPHBz0OeF84rJAs3VDR/7S5lYUxrFkBacRuslQPXMwXkVgJsoz1VULJ9p1zraeg3LXbsj+AGoeoVwlJiv+6QJd60aGiLfVxwGnDZb0Un3fUWysIy+wpI20of+zJHSweZruO/wQG/2cl2/wBBXD7aTPZozCgutttWoFr4rhjxiY/5MgfQ/aP6nEaJ69y89xXm8tzhCQa8zla9KkYICj2CXZYUbuSTK5ZFYuefHsmpdFsPTdqT+iqrkgnmda+/ELZgdDPDq4MsHlzlhmC/V3tH4pzTqtgR7F4gQSdEefvKm3xVoopC/pQWjM6/0WvaelLTZpXQFJxn76HO4uLUQnK4cGrOd3DuKFtZYIWMY9lN1IfG/w3yb/pG63i+9N10FvpqoMfXuQg6bVNri+Z24ZdPd3qMKbG6jePvEAopQQey7ENnXaYH5ztC797DfOSQIwEdGGu0nPXLi2GXV5FdcBQhIZ+UABs+sCBxIct6ssnKrYeg4aZYAnjkKyiCsxevelv6QaXU0vvi6H8YFKHMiMFa28Rc7bxFdBqrlE9qK8e9y82Hmx0D6G1FJn/Rksln0yoxX+1At+tj2Pd+IGsSFPLun+hTKwswoDxB2inApUrWMBqjvKahC4c8bVzTKeeL3n3fEO9LvWz+vwZTS7h3SHkWL3klwX31JlBinCGSExL7tlw7LBqM4VhseR1Mbmg+lUbMks400f/49vOQgIJXshoPwjx4X8CO4nBwvRLeYdeQba4ppyK6lvAvK3gsGnE0gekrwJTGD+0/ZEaBM4q4+kbZhUeYJN9exoVtVAZc18DH3zxDHeOeujB2FpcHzCNFnR5rejfyf33q7DUB3jRdwPlQsR6KO/Doqr2SKPIs3pKxrTI0My9X1zXuuqUEOgqiQvn
 Yt6NYZOh
 HjA+55/oXYMhXS0tgp3PvNnSHD4mTPj9F2LXCEeZt8k0wN7N4kBRB2qYmZlIWl6tWIhGkWxU0+eYrH4ODSxDL6vbkjgqzmFxU+U36PFsbevvBBeAVwCDN+L9lJYe5BN1A2bdnOSYMhTJ0oElyiYTGmlKKcE3HER9BCcT9becfy5AsT1SKkSu1pOxd1EzWoEHUFSpCxHAworEn94Vm3Tbb8QfIhpWzex35LDzvfnvIoO9A0u0bBwXnzctBK2u8GjXnMrOxXBkWqxMovLJj04RPOBjYuwLs6HxA/GzUwIJKKIjPliLDLMmue9tkyubZYOO1Tp1KAdVTJbCUEcHwwBl8XU0Wm11QZC5UFfoM/Dw6jrqLnMpDnpllW81hqY8DvzeJw1xmgTl2AKjEuIdDkgKce5DOnfQXYoshTtuBUeeHTzBBd197bAvKUWlqufisQtD4Q0pX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:

> > [...]
> >
> > >         /*
> > > @@ -1257,7 +1327,7 @@ static int move_pages_pte(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd,
> > >                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
> > >                         err =3D -ENOENT;
> > >                 else /* nothing to do to move a hole */
> > > -                       err =3D 0;
> > > +                       err =3D PAGE_SIZE;
> >
> > To be honest, I find `err =3D PAGE_SIZE` quite odd :-) Could we refine =
the
> > code to make it more readable?
> >
> Agreed! I'll replace 'err' with 'ret' as the function no longer only
> returns error but also bytes-moved if there is no error.
>

Looks good. Should we also include the following?

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1246,6 +1246,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 /*
  * The mmap_lock for reading is held by the caller. Just move the page(s)
  * from src_pmd to dst_pmd if possible, and return number of bytes moved.
+ * On failure, an error code is returned instead
  */
 static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd,
pmd_t *src_pmd,
                            struct vm_area_struct *dst_vma,


> > [...]
> >
> > > @@ -1857,10 +1930,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ct=
x, unsigned long dst_start,
> > >                                 break;
> > >                         }
> > >
> > > -                       err =3D move_pages_pte(mm, dst_pmd, src_pmd,
> > > -                                            dst_vma, src_vma,
> > > -                                            dst_addr, src_addr, mode=
);
> > > -                       step_size =3D PAGE_SIZE;
> > > +                       ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> > > +                                             dst_vma, src_vma, dst_a=
ddr,
> > > +                                             src_addr, src_end - src=
_addr, mode);
> > > +                       if (ret < 0)
> > > +                               err =3D ret;
> > > +                       else
> > > +                               step_size =3D ret;
> >
> > also looks a bit strange :-)
>
> Any suggestions on how to improve this? 'step_size' is expected to be
> different in each iteration of the loop even without this patch.

Usually, we have:

if (ret < 0) {
    goto or break things;
}
step_size =3D ret;

Given the context, it does seem quite tricky to handle. I=E2=80=99m not sur=
e,
so maybe your code is fine. :-)

> >
> > >                 }
> > >
> > >                 cond_resched();
> > >
> > > base-commit: 561c80369df0733ba0574882a1635287b20f9de2
> > > --
> > > 2.50.1.703.g449372360f-goog

Thanks
Barry

