Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DBAC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 11:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F13A6B007B; Fri, 25 Jul 2025 07:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A23E6B0088; Fri, 25 Jul 2025 07:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8286B0089; Fri, 25 Jul 2025 07:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7D26B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:25:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF39113A84
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:25:36 +0000 (UTC)
X-FDA: 83702556672.10.36925DD
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDA4C180007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:25:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XIWAehMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753442735; a=rsa-sha256;
	cv=none;
	b=3ZNGLURRiQnfG9IBgNxCKbA9UBcfazjNxUe+tMwoXLPqfYIZ+pJc5ucl45OWhEhPohrsrK
	qEYlDvZCbc5A63pcg8Ne3lcX6U5zaBRn7PSqYBLGhvVq14ftR/2IfXiiEOmYrrgb8LEu7O
	m9M0UmNqjZsd3oJWKgTFWAam0zCRp3c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XIWAehMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753442735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7JKBcnXvS7c6EV81hpTMLSU1ROPxxQf8xvSxkWCs9E=;
	b=L9qsnF593vhQvt+R3px/r+/DXqpvVhenTT15oCsDQ14wlraIv9/j1aCMVs43UGG/TDumpc
	szYLFOwG3m61BFmZCFh4qT17hKhfC+o3hN5n6Fjbxdy1sOsoZc+Sl8+hOPvx4JRf0z9mUV
	nnDkzClxdpDOpMxpzrN4OwwMOtJ5Ekg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso9153a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753442733; x=1754047533; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7JKBcnXvS7c6EV81hpTMLSU1ROPxxQf8xvSxkWCs9E=;
        b=XIWAehMoAeYRmCq5h8bez1NLleBEgcUSxuANyVi5jCfvqsg6Th5yPHJg5cqSeExY+p
         8S8oRYCH3/W/CgLxtgcKZhrdJxhfL8AjKT1mLF3nhSU/C+QsjqDTZn5uoJlfc7h5zL/Q
         chvsufFmwnAVlZKVoBUBBCn376bnRO0+Xi6P83cXUil0EvZEZUUnDALq/PFwzQlsmNsT
         N3hyKc/laEEhw8mQQ7QRa/wn05E3vpkNqpLpozIhIwomPYICldjmBhSnqa2iHxAgtY7h
         qmzF/XB/kKGuNFFy3RTR3iTmXdmwACyXRBmeFxXaTbpavz7fbdrDvVEoej8skPsT0xQ6
         XR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753442733; x=1754047533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7JKBcnXvS7c6EV81hpTMLSU1ROPxxQf8xvSxkWCs9E=;
        b=P6Q13wbVDrWyLLQdWt6zjzNIrEZ9bCHQThJt4AH5ug+t1od9lxpsjq4vv7Aj0ncyob
         o7p5ictPThcB2CVeghxmK0aRE85nRBdgaDkP3YZJUkU1/fomf8l8FYrGozjv1r6dRcls
         citZ1GTkqpDG7H1S88ERPD/PzTJN3PPFf8XoOdIBHct/SUPCI8rDeD+rqJhtVWZSkGyg
         2pHt8gTp/uhaZA28lAXPtrojbCxz6p6sJy+bMrKEJMvIdcPlhlk8Ix5P8iwVJ44s1NdK
         OJnEK+5g19yu3oUR6hhM43TYT5TwO5pxgPy0lyX1M64NAZgsWiCHdnXlr/fHbGjsx4HQ
         r4Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWJZ3iVxuCy2NcsdZDc2g7Wn972QOYwkBIllabfCHT3lzIbJJzurP1hpyd44LIo2OLkxOFwHJe4wQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9lydtZLCneJOoONEK2Xl0PEfYYb26TybDu9f+/sQSQGRD+a00
	vdAFFCdmHiJcp+HmNoS7FwpIpIEANxkY3jpCq5e44asbaHVqgu2TV5TCDeFsTkpzeCdASO2TVmZ
	J3R1jlGgwb1toPnqIc22AlzrrKXdmm6GWY25v8faIB9/HPDyI3tozrdAZ
X-Gm-Gg: ASbGncthNExbmUZcvBggjd82IlwsZzXcvfd4RLBROdLeBdUE0s2iEPQbYK7CkmnPkLa
	j0+C6z+kBkN5l2laLL9aBNNxTbLFUAqi2223e65xDvze40kNhsq5+4DzEVQRqDE9StPI2Em+O0J
	PMcEsQqlDt8zt9NXccBJVBTq/jKNWDGriLfuMJ3v5nOkCL/fZUY3d6rzBpqArGHfdbOwwjTuImD
	L2tpoW5I1VOoWk4mVgxlZM8HVzIwuSGBDE=
X-Google-Smtp-Source: AGHT+IHu/Jxe0tRupMk8sata71Dj4GlEaCewOSkFs48tGZQjsE22y5CxcO9LxASkhWClWF59p30fdxQ7Yp6zw9xnWhg=
X-Received: by 2002:a05:6402:26d1:b0:601:f23b:a377 with SMTP id
 4fb4d7f45d1cf-614e7ae014dmr87648a12.6.1753442732938; Fri, 25 Jul 2025
 04:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com> <CAG48ez1O+7ciCNDVnh9MPh_1_1TLWd-=H9L6p90J_9AEbav27w@mail.gmail.com>
 <bf29d398-5f7b-449c-b142-cf9873a5b183@redhat.com>
In-Reply-To: <bf29d398-5f7b-449c-b142-cf9873a5b183@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 13:24:55 +0200
X-Gm-Features: Ac12FXwcKoerpomFAjOzM4_F9BiaBJ1IxkwRsdKpHovHfzexG6clt04_fcJZefk
Message-ID: <CAG48ez1=rd5W5SBAyyqu-=50AsRGg8pdYW5BZ4SFhHqFYOHbyg@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDA4C180007
X-Stat-Signature: m4dex7zptp9ojw16zhs4ayqtfp7kwqcw
X-HE-Tag: 1753442734-598806
X-HE-Meta: U2FsdGVkX1+7AKNomZQm1puTFXt8SWoGc6lTZL0bse6clXNrcfeL4uJza7wJrRB43RA2llSxeFuFtE6c/mToGl7Wx55LYaI13Z6/6mjJX2ZijWRDtN37q6pTrIU7S2kmM5cEtyfmKjOY2QCSGT5zQaBybHXnv/QdkYKt5YPGAom8q5xQqKtGN6PPiFcG6Qx0bzOeQnnde+el5BAXUPkBnm5HdS//QuO1ubwyCQyicPXFni3nMSLMStaN0in3wInWkF6Wgmm4ooDUtqD+Kn/PWAz4zzEJhAofe3ekaVwYmgBhXRntoMxfw96SA4nHjVj4xbftO1VX5uAMxsmF0jJbqP7bXqL9xc4Q2gE8uQVorW0E8LVvS2Lv0phTnucUYySZr3wALeK989DPkIM4oHfDfXuO5tpNR0X7vzxtQO4+JBHf401TD2+erkcjSktn3JvWVB7W9MvoLdwIrDmslNKNRZRTtxTUsqZcXr9jwxIGa2tTuc3vZx05ZOkrsXy3b/bqBFqz40/WNFZYzpoeWUpoJ0Czdf1JI8/35cWEzB5Xm57tCNHxKuwTh2Mk6ns7blQACwdmgJo9yC4set086XDH0IXssnk4aArNv9obTCqgH7iDRoFSv7e8oTm15YwMYTrA6tqwluDjGSG5Rv4nsVAgnPbFEoTYCw3X1ikAdMAe/PYoBRPmwLDjWMd986uTMz2KErocNtSeTxzJ/LliUQ8P47J7jLJUZ9xeqsVLKgii4meEXCtI8lg/DW1UfaFkRZDC+lfAaZO4n8Yxnl2VSqOHfe9hX8m/Hj250hgdJeWXbMUcrOW/451BjQlNHVn6ZTgQRWX6w48arJIyYg4z0EbCeYXJLQ4aVVw/3uxJq0bHHiqgGWOqSUWyhgzTJmSd/0HeR48oVv1TaA/w1ymYQ7Cp2N88UyU0b7UgHQv1U4hGaOBVRFxWdp8epHUS/0+9LUcdqvPFsZGq00YM84MTWXv
 AU5v/m7j
 B22Jt1UWE/wU7iXhhV7Jq3TZ7tmMVoBWc1EUMtdKnsm804XQ3eZAX95zi5MPYqfUHSyPxK885yeRyCnHoWNgCWUmRvPqZwI3Pla1EcWvoegDhdBhCj7QD6F+OGJshdChggNWLqwXYJtpeBZMMxc5NaDDPzI2F0V2HkN66IUQTI5W0GioGPeqT4btxn9woJa8x/yO/8fAtD2ax3gSt3aAbDWtJkksdHThdxkeYLHUDFXSRiTdQ3hddSxijHaGRCuq0Bml+S35XceBWTBKtiCsbMVgDVUqAa8ohFlZV0kYmddo7IZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 1:12=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> On 25.07.25 13:08, Jann Horn wrote:
> > On Thu, Jul 24, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david@redha=
t.com> wrote:
> >> 2) We have a folio here, so ... better
> >>
> >> if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
> >>          ...
> >> }
> >
> > Hrm, okay. It kind of irks me to write it as two checks when really I
> > want to ask "is it this one specific type", but yeah, will change it.
>
> Well, ksm is a subtype of anon.

I mean... not really? At least ksm folios are not a subtype of normal
anon folios. Normal anon folios point to an anon_vma, a ksm folio
points to a ksm_stable_node instead, and you can't treat a
ksm_stable_node as an anon_vma.

