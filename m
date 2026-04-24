Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1837BFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187776B0005; Fri, 24 Apr 2026 15:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E436B008A; Fri, 24 Apr 2026 15:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E806B008C; Fri, 24 Apr 2026 15:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E662F6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:58:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87616C17CD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:58:19 +0000 (UTC)
X-FDA: 84694511118.01.4312FCE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F3B2140005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:58:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b+NfRjtS;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777060697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jx/+X7z1qY/OvSf5HyX8x1jyhWzg0V6nE8tOpGh+FOs=;
	b=NEB9S9uPwO8WPdX79OenNvJLGHYUd+XfAejqjX1aoiB6YIh/iK69RzYyHGPWtZbO4ry45i
	PTg/e/WgcYxUewMErX79MMY2BeI+jsfGDEXDfpYU+HMw1/Xb16WMOjcoGzudxnOQVKCWQ4
	odVhMItr3b3RZ5IKFJ5H+WcbMO6lAGU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b+NfRjtS;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777060697; a=rsa-sha256;
	cv=pass;
	b=MAS/C1sj7pmryjKC/RH4U8WV9BZRmgwrkpB3efpBiyZO03OxunOfNjRZ78WzcOakCOTHiW
	C9xvp6NzShDEfmmWpUisZk2h0lAjEwtQ44uiZ8Cjig528PtyRYNBDlpklEYfSSUjG7oJvX
	h0ecm+cWTxCu+qr10oplHtFPPIbUZNM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d864c23bdso5153241cf.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:58:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777060697; cv=none;
        d=google.com; s=arc-20240605;
        b=RKcs7EBpsppTDbCkDKJw+UDWTXSR/GpYCLCgpGy4l4u6uw6w3nA8/MKV0H7jLD2nYo
         biMIp/mKT6YeJLetaEc24mlWXnpYk2BTdFNm9EaIOEyG7D16FLLUpPdQEeY8qXC2QEoA
         LtJQc+Iaq8Pm8wg5SUxoFy6dISpmm6DFgEpAN/jMKwDykL7vC7V79ou8F+/lQrur13Mj
         i6U6vTP3E2GY0HS16DhHLh4t9+K25bsj3YsV4BGwYZIy/OqofCBbpfu6hBd/nQHwpH17
         VLd9UGHpo6GUMPXqATrYY0JXdVM5VQOJGpeomgtvmoxxI885ZaROmQ+kmgEbAc+VeZPT
         qkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jx/+X7z1qY/OvSf5HyX8x1jyhWzg0V6nE8tOpGh+FOs=;
        fh=6C81nK+E1PBjaazO3DlJ4wm4uSRi29tHxtLR79N3cvs=;
        b=P3yhoqU83K+GruTDWRK9Qwxs+w4uaoyGFctF+ONOCpRiByjYDW6Xzx9szD3uhdm6h6
         60RFpdOFFuEjv0iqd91HDoCP761L5q14YuPxIMcXeQeQgDqeKc4Ef6WbuTJQRpF88y4M
         P9wccWamVfiBxvp/uYHNiAt59bfQJtz8lF9RpKBMj+gZs8uRWn91kAcuN+zFIm+APq8j
         RUUKsbQhQmMd1wn5EGJ8Pm27TtD55Z0vADbr5YwEaePFN/lG2Pig3zDUDrK/JIlQhcXo
         MbLB0/bTM2xZXvL89TlTPJSA7r7dMn+qvgJiHPoCdwqqab8J1iObx+6PcGQZ7KIcmA6U
         V86g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777060696; x=1777665496; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jx/+X7z1qY/OvSf5HyX8x1jyhWzg0V6nE8tOpGh+FOs=;
        b=b+NfRjtS31nFhcOxWTo/32CJ3vtSZMUWEHy7H5chvgfmucCsSm7VkDgwXb5j24RG00
         /SRNkAJwHzHyTeBEOnLdOKUrABKPjHUrfAO1b7HjQ4EBJs+h77hmdXBreiZJzHYFKx+K
         1DH78qA2GsTfOcytlkaFRLGFeFeREXMzZdq6z2uS3HIENgWpi4mka44H3IWBTFNLo3WU
         J68jvm2KJtfHZ+KszPzsheG8C+4OcBO57sBpTEBF8N6kxVzKHKPNqC62y2QkDErNilJP
         hvf+n8M2vZupbpBLS99yfBcrNnCDbkcUZ+hz+C3fzs9tOQZPXHbkGXLgyS5PBi/gGqut
         qZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060697; x=1777665497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jx/+X7z1qY/OvSf5HyX8x1jyhWzg0V6nE8tOpGh+FOs=;
        b=sNngNvF75fMidemvfuVWHhuYCe13Hg8OX9Bju7QM2sRKKTdbk/AmLoF6f/XZytzYcu
         1go59nC8YRpjVHB+ismh8t1v8cCmww5HN4AL5tXcKxwAbhYBxzVaRU8/3N+imI6rbqdc
         jHsf9ws2MjDVbntZWMT3rGImEagAPgF3jbwDeK65dHb2BAPUXP1Yqnuids7Qp4voG0I1
         BWShjwOyTtI2DlD2RZ9d/fJLmnCY3Q2t7gRItZgQuEmCpgyg0KnOou0Bo5SCcIKarj2V
         JaI5pNcbFmrxjy3cGscCPZHUJk6eh8ptaTqmkDDQy6RSp6OG1PLG+KIZSlvX+pLD6KOU
         Kbeg==
X-Forwarded-Encrypted: i=1; AFNElJ+UPyoLGp6uHWdnbG3cgLfbqL9aINuslnPoIbH2c7XEV/VhxOk7MWRL0sZ+WfcYhUEYyGAH1NNkmg==@kvack.org
X-Gm-Message-State: AOJu0Ywb0/fg2ZZ6M7npM3sklkWQtTmmcm6EYArPw/UB7qSwlsrhCnID
	teZohZiCV2AIH7wRLGyTpcJXOeHKefHjEXj0PVWc5JELfoB1G7uLlBkgb7uKvcpxXApwTPTxKaW
	cZGCFuQXB/MpUxEQAvXd6B1tnPFfXNMXdsoiMP3Q/
X-Gm-Gg: AeBDiet4420vFmdU1piDwtkAoJ1sg3KV6WZ0XwS8OB3OWP5hLAP453jF4N8JRZbV6iP
	mRNWEKksQGlGfWqDwNCa0BD5NaN87sAjNKhB9lj+Z0VqUUfyIe9pHq0IKI4YSCJMMBIatJzXQEC
	h2dto0g75H4e4Sw+hoMyg1eBPgKGfxaUyu/tte0+VE7mFruey4CEz025VNBuSLvixWsMN0jQmV8
	ZfTa55OOxMGjvocgdBQx7fPfpyF9rhQE8VwZnmQkHNOTHQ4scvsAeQ1OHSbjDUgXCREy6X3bJ3W
	ftbL4BVaXqgDr2h8sJn3DFx+rrU=
X-Received: by 2002:a05:622a:248e:b0:50f:bea3:9475 with SMTP id
 d75a77b69052e-50fbea3aabdmr20044151cf.14.1777060696083; Fri, 24 Apr 2026
 12:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com> <20260424070234.190145-3-surenb@google.com>
 <j3vswsvp6jp3hopogpc2qqre4mwneeffoutbytlgt6sah2blgz@33rsxbylk7bv>
In-Reply-To: <j3vswsvp6jp3hopogpc2qqre4mwneeffoutbytlgt6sah2blgz@33rsxbylk7bv>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 24 Apr 2026 12:58:05 -0700
X-Gm-Features: AQROBzB1Rx4ZvLow_W2QFHi8uxoLOiZRRVGVFV_nLgtZwxwfKXdBC5rKzdCtvYI
Message-ID: <CAJuCfpF+hE+Rf5mkJXBr1rc8_VX13RUu1MtQVaAZZRYRPskRXA@mail.gmail.com>
Subject: Re: [PATCH 2/3] selftests/proc: ensure the test is performed at the
 right page boundary
To: "Liam R. Howlett" <liam@infradead.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F3B2140005
X-Rspamd-Server: rspam06
X-Stat-Signature: nnxgp87a6uto49di6tp4uozxyc49y37b
X-HE-Tag: 1777060697-825614
X-HE-Meta: U2FsdGVkX1/P9BUJ6wpFu9W+ytFvZwzbaZl04glFFBEwqwyMsyqU8Trw2koI27RgAD+WM+am7Gg4W037fXAAGDYJWpvAe4f4vum7zsP6z8xlLl3pzk9gm04DpVcOBfYS4Nm7FE2DDQsgQpPVJ8yInGmXdMZJWWJ8mbT6HgF+DfW5rk6YD7XJakZ6imaP7FH/S73nhsfQoE1lVc8kGm9HEXMHAcN/92fm9cOn0pMBnWz2muggXzslH3rE34K8mrAUwY/Q8aIJ/m7hyM+cvPXJJaA9sW444z6mznipCIj1qFIP+fdsac9QKCV2PzlqbvmYKrleI/ZcK+ivqB9/Uv3YPkK+RrFAdhkTpNkpU49BizJz//F9falnOTKvoNd+S3rFUZARqwadYQSKniYYOpGy009wJXUB+COdyI8RX0V2PY8zOYsBy10lDiNjWKFRiGl5XiE6bS27rubOkitzYnQgclfdeWmFdfCSmA4lWeOC7Ub3b2dH9hd1+es29iB6LGcn1ifSLf0k2+hRQI/H6fqjwju5R8uTJ6yGG18YYz3VCl1Xy0chXxsOJdufiZXXtdmzB3R7TP7phGqE/SWI0f46bx6QDnBXF2msnu3nBd9Gvmg4GGb5RvPa6GRqK6bJ6zFm7flY1E9UJzR3t6RsYxE1cINfiV6HaaM1KljF67RCPIVt/8HdZrN7e9y3qKsFcJ4olbc0jWBRJDCTRqzqqIPu5c/ZX6CC/RsoxZuiMlM+QSRFegdpgkRysfHESlU6HiQ9egJTt5x23jmtTobTfp2BEW+DucjTdpU/kRzLB8HUF2dcel9+l3rX+CH5JNL19SGjdJgOrwqvqRvTBk03VzsNaLJNR39h7lSmynAwG8W0PjAcFQFlE7O/TmNekcdHnfPJyHgAUEpNBNh/HilcCBj4hTMqxpiw+8UTCBpt7wn/D+Zy9ZqKAIfVowCKVJc/vgQmFgiLCnFmb/4gY6kfmxL
 9Jy5nBhx
 p2YeeEe5EwK7AJ3FydoZsav27OmJ71QljUOcYJt9Dg7kKi6uEDnfn1oHzIwjIpMLjIHkB0XTsyHIfOc3EeZ9vdv5O3Qqm1zPwRMeF6s0iACiQTaUNbk3E548FeEWjri+gw/rZeI44SG5RdXhJuy8m60izv1MLREcycbybK/Zl4JISHM6C0zPr2GKLLQg7SEC1SPISAc4hSK3R6W2i7mURgG5NcDazRGMeMzWe9pQXFQTYsgIjiAsZ1t0ItdBPpsxdqhT6UoNs/seLa/Uz8b7QGiYxKdBF2mUmMZsxD+VVVAEK9B63YOeRfGg5q5haxv6ZhKjc6mYDtqgRfCI/H2oR07YDagEjtJkZqGvFeO34SKERZMONBNAK3MUKgtTaFhk6GO4TCX7RyLvmrUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:21=E2=80=AFAM Liam R. Howlett <liam@infradead.or=
g> wrote:
>
> On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> > When running tearing tests we need to ensure the pages we use include
> > VMAs that were mapped by the child process for this test. Currently we
> > always use the first two pages, checking VMAs at their boundaries and
> > this works, however once we add tests for /proc/pid/smaps, the first tw=
o
> > pages might not contain the VMAs that child modifies.
> > Locate the page that contains the first VMA mapped by the child and use
> > that and the next page for the test.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Reviewed-by: Liam R. Howlett <liam@infradead.org>

Thanks!

>
> > ---
> >  tools/testing/selftests/proc/proc-maps-race.c | 78 ++++++++++++++++---
> >  1 file changed, 68 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/test=
ing/selftests/proc/proc-maps-race.c
> > index a734553718da..c5031b0593b7 100644
> > --- a/tools/testing/selftests/proc/proc-maps-race.c
> > +++ b/tools/testing/selftests/proc/proc-maps-race.c
> > @@ -39,6 +39,13 @@
> >  #include <sys/types.h>
> >  #include <sys/wait.h>
> >
> > +#define min(a, b) \
> > +     ({ \
> > +             typeof(a) _a =3D (a); \
> > +             typeof(b) _b =3D (b); \
> > +             _a < _b ? _a : _b; \
> > +     })
> > +
>
> Another implementation of min in the selftests.  I guess it's somewhat
> unavoidable.

Yeah, I was looking for a good place to put it and reuse in other
tests but the only common part it seems is the harness and it didn't
feel like the right place to put it.

>
> >  /* /proc/pid/maps parsing routines */
> >  struct page_content {
> >       char *data;
> > @@ -77,6 +84,7 @@ FIXTURE(proc_maps_race)
> >       struct line_content first_line;
> >       unsigned long duration_sec;
> >       int shared_mem_size;
> > +     int skip_pages;
> >       int page_size;
> >       int vma_count;
> >       bool verbose;
> > @@ -105,27 +113,68 @@ struct vma_modifier_info {
> >       void *child_mapped_addr[];
> >  };
> >
> > -
> > -static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
> > +static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
> > +                   struct page_content *page)
> >  {
> >       ssize_t  bytes_read;
> >
> > -     if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
> > +     bytes_read =3D read(self->maps_fd, page->data, self->page_size);
> > +     if (bytes_read <=3D 0)
> >               return false;
> >
> > -     bytes_read =3D read(self->maps_fd, self->page1.data, self->page_s=
ize);
> > -     if (bytes_read <=3D 0)
> > +     /* Make sure data always ends with a newline character. */
> > +     if (page->data[bytes_read - 1] !=3D '\n')
> >               return false;
> >
> > -     self->page1.size =3D bytes_read;
> > +     page->size =3D bytes_read;
> >
> > -     bytes_read =3D read(self->maps_fd, self->page2.data, self->page_s=
ize);
> > -     if (bytes_read <=3D 0)
> > +     return true;
> > +}
> > +
> > +static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
> > +                               unsigned long addr, unsigned long size)
> > +{
> > +     unsigned long start, end;
> > +     int page =3D 0;
> > +
> > +     if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
> > +             return -1;
> > +
> > +     while (true) {
> > +             char *curr_pos;
> > +             char *end_pos;
> > +
> > +             if (!read_page(self, &self->page1))
> > +                     return -1;
> > +
> > +             curr_pos =3D self->page1.data;
> > +             end_pos =3D self->page1.data + self->page1.size;
> > +             while (curr_pos < end_pos) {
> > +                     if (sscanf(curr_pos, "%lx-%lx", &start, &end) =3D=
=3D 2 &&
> > +                         start =3D=3D addr && end =3D=3D addr + size)
> > +                             return page;
> > +
> > +                     curr_pos =3D strchr(curr_pos, '\n');
> > +                     if (!curr_pos)
> > +                             break;
> > +                     curr_pos++;
> > +             }
> > +             page++;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
> > +{
> > +     if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
> >               return false;
> >
> > -     self->page2.size =3D bytes_read;
> > +     for (int i =3D 0; i < self->skip_pages; i++)
> > +             if (!read_page(self, &self->page1))
> > +                     return false;
> >
> > -     return true;
> > +     return read_page(self, &self->page1) && read_page(self, &self->pa=
ge2);
> >  }
> >
> >  static void copy_first_line(struct page_content *page, char *first_lin=
e)
> > @@ -418,6 +467,8 @@ FIXTURE_SETUP(proc_maps_race)
> >       struct vma_modifier_info *mod_info;
> >       pthread_mutexattr_t mutex_attr;
> >       pthread_condattr_t cond_attr;
> > +     unsigned long first_map_addr;
> > +     unsigned long last_map_addr;
> >       unsigned long duration_sec;
> >       char fname[32];
> >
> > @@ -502,6 +553,13 @@ FIXTURE_SETUP(proc_maps_race)
> >       self->page2.data =3D malloc(self->page_size);
> >       ASSERT_NE(self->page2.data, NULL);
> >
> > +     first_map_addr =3D (unsigned long)mod_info->child_mapped_addr[0];
> > +     last_map_addr =3D (unsigned long)mod_info->child_mapped_addr[mod_=
info->vma_count - 1];
> > +
> > +     self->skip_pages =3D locate_containing_page(self,
> > +                                     min(first_map_addr, last_map_addr=
),
> > +                                     self->page_size * 3);
> > +     ASSERT_NE(self->skip_pages, -1);
> >       ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->fi=
rst_line));
> >
> >       /*
> > --
> > 2.54.0.545.g6539524ca2-goog
> >

