Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FC9CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 19:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3946B6B0088; Tue, 23 Jun 2026 15:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36BE76B008A; Tue, 23 Jun 2026 15:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2333D6B008C; Tue, 23 Jun 2026 15:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC65E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:28:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E9271A00FB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:28:20 +0000 (UTC)
X-FDA: 84912163560.12.6DE97C6
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BFE640002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:28:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzYYe3Iy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of fmayle@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782242898;
	b=uPIwxOdlnsuFPovHAS1Ni3NEYAmadtgRuYPL9ej2aO4R6W/3uXBZGTyUy8l2ALniHhXHuH
	5NS+h1KuORQyjFlCE0HXu0Z13kc1UGUh6HXr/CRPfbHDEMnYTq+XGe1jgdklAyOYsc3abW
	gh0OQXOjZ8yeiK0XODZeVVAcoiET8Lo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782242898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctSNWPFltveQs2acbQSRG8EL+kNJGfmjRALamlmiSv4=;
	b=JqpdNm36ZaNKLaO1ta0l4PwmJt5UHrQxkBfCgFk3y5Tpo5O5lXQwRFuA5qW5lDMtULrJmP
	AVMJF5RO+dYq+xbaeD0eKmFf2xz2uNPN7dayEeRClWIi1vG+hYkrR5tGdgYvx9zVaA2i2p
	QudpZwZ63M3wT0KrNVjonyT8ZZqbpEU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzYYe3Iy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of fmayle@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-139abe0c9e4so1122c88.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782242897; cv=none;
        d=google.com; s=arc-20260327;
        b=hRXx7uT0jfPsu3eHlPovyPIDbVX7cldWZvggi+ZfOvxf7m0Kd4HfdD9o6Oo5vHJh3J
         bUhJ40empaXjptNEhriH8JhOTHcto2L+Nw7R5MWFKiUrPG7XUu3i3XUCNZg1LrBWxWR7
         OIT3FU0OwcbvL41wg4Xka99yf5w3vUjl+vixw5tv5aVokHXZndZXomt1Un1i01i0zY4j
         9cCLYXn45LcRPWb1+EPS+GgOVZOzYUE46hfvduY+DkmCgtWuoDKU6Xsbsokj9ZqgSGKu
         26oTVSlJsJS3aAlpLHeEszAr070VIo/JWnFSJC3vRsDv3OEOu8K/XJIeA4dLTBerrzOU
         0o0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ctSNWPFltveQs2acbQSRG8EL+kNJGfmjRALamlmiSv4=;
        fh=1euuL2R1E/N+e88TmpKZfldIFSMXspxJog4xZS47pmE=;
        b=N0/25E1hKqCwBDCzYYLL7UytzZn3OH/UH3pBX1uPCw6LV7suJLBd1uhVThZtc/8eVd
         y04ETQz66F+/IBowYM3VVISHd+bkCpglP9LNITVM+/wFX3Uc9c3H6npPXEpIWETQx4sj
         YSihaiudPIBbxu/IZDvCRiZfLSAiGGiUDZHorHJoCQIo3Zhb54yLkkB6zS4zVgT7vVvq
         qRN9hKO9GukpVrPIb0Twn8qzK7N8QUD8T8I5KsA4kImA2rW/2KgSp/2hVMoOq5VS06jm
         WNBzzntPgpqTKh50eX6+Zc6dxGaomcmdSSGqdSd+rAFnfjyFAW2x5+d6cqwwiY8c9Ihg
         cRmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782242897; x=1782847697; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ctSNWPFltveQs2acbQSRG8EL+kNJGfmjRALamlmiSv4=;
        b=EzYYe3Iy3jiGAzvelWgLp1TrmGzlH05IvgiYVkFS/qGPWXZxJiNLS7HBxJAHUExI6W
         JWIHKscai0GPydRNyi4PIz/zrV1bxZJ79rnIqNATDPywomgvoajteqMixl15SsNAaW92
         5okELkqiGgpQBhM0oH85dtkz8oU+NR1HLAM8vvS/GqLhkSAuRo4fEXRyvjha2csad4PI
         rwsmD70AZdL52cN0a4M/bDcmYq9G0uBps6RquMKTb5QN7z5g6KWGzmy/yDjUaCJpBZJY
         7H8WrhEuzmHj6Eo9iVhVC43dBICtVnrn9x3BkaTT92XmOvMW8W8OLj56fcyyGfCaNp7W
         6jbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782242897; x=1782847697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ctSNWPFltveQs2acbQSRG8EL+kNJGfmjRALamlmiSv4=;
        b=ROg/O1vd0lFIm48DCDxObSsNb3g8d4xlwXdvTPB38DkxJvIIVwfAF/hjPeFrG28CY1
         fXh9DT9FwBDGBNRCOzv/8KITd3khXlABqcS0rO6pdUF0tYLzUXOAk/MfI88JXnJ5gYuf
         k83OU9ZhLaa2G4hvD4yBfdI5Gmg/wgcX1HwO+dFx/mLqJeQcXSVyRHrSTjszmQYf7nEm
         MYpXEZcBJGqY+MPYXLTgilSP5+sl6zWQzlnbzkI7kT886PW7dKK6KsGvicHuI72nBpaR
         PNk0R7mI1A6ecxxCeyCQU233BI+IXq/jWA6b9IJZjsHexMxLPCckhMZ9ch4YGcDYYOXF
         tbxw==
X-Forwarded-Encrypted: i=1; AFNElJ9bULxFnO/bJxrAAtsPd/ZICRdfGE9/OsOBtrU8ToCB1xietls+Hp9LyU3uFZs5qTnHwE0Q33DGKQ==@kvack.org
X-Gm-Message-State: AOJu0YzXkfb1nI3H5ul+AReJTnJhvAdWykkIg1V6+X3W1LQQTDJKgudG
	5MbFn/tZwRMZSejCJFQie3ad2RoIyKSQCYnbzSf160SGDpXelrqcPpn2ZDlun7vUgzUrn3iNHQr
	zGWGuSuEXLVGUbGRx/quIG6ogR5GGJspXCOqYrzTU
X-Gm-Gg: AfdE7cnMBwXPecA2uZL5P4qKFtrMNSp3lyRUwT4Q3kHYInYfbdW3VRa+dLDytWAEEWc
	sz6PDb6SgT9B+Y3j47L/PTx+pRThtf6y3bKc/I9fofT4KCdKgE5O+tunOHpFlLQgcEWa86OV6NI
	CpP6k7D4CZYDeCQ1vE4xRJgMwxpyRFhVXo9sCmo32G49A7oz4v8WPghJqWOMwF4OzL6ziBC8GIl
	AB2TkkEdS4uodBYTbKDnTZJHnu2Yu8fWWI22w0fPOQQiFjykNgs4M72O7EjGnfxDq4jNbnPe94b
	9dnJNO6bN30JM4N/3APwqiqzZZI3p8k=
X-Received: by 2002:a05:7022:425:b0:134:f1e8:e598 with SMTP id
 a92af1059eb24-139cf6de08dmr36512c88.25.1782242896523; Tue, 23 Jun 2026
 12:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org> <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan> <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
 <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
 <ajk-NMghY50F6Sli@lucifer> <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
 <ajlsum91zeh-oRz6@casper.infradead.org> <CAJuCfpHaBFtgAyE4jum-=p3u8X3STi3e6i6==fQR+0ksaU2wwA@mail.gmail.com>
 <ajmJT6AAor46gLBw@pedro-suse.lan>
In-Reply-To: <ajmJT6AAor46gLBw@pedro-suse.lan>
From: Frederick Mayle <fmayle@google.com>
Date: Tue, 23 Jun 2026 12:28:04 -0700
X-Gm-Features: AVVi8CcOsPAJMGtHSDI_xQS9hzq9FYfdzP8LiSZKEPxLt6IQSan8Zod7orip3Qc
Message-ID: <CAHCxdc4tBb+U7LrrHH+sTEr5Mv_0hJKV6TMZNrrjb-p28sPBcw@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kalesh Singh <kaleshsingh@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BFE640002
X-Rspam-User: 
X-Stat-Signature: 9g3kaqzktmcjhskou1tpmt6e71oyywb8
X-HE-Tag: 1782242898-353731
X-HE-Meta: U2FsdGVkX19ltL9fuiGCBsbGvwNTJKsHMTYmaSEPQgxh5AF8M+9ZmIiAF+qL6puzVn4kZ8NWAy/F0ZmByOAn6AeB5Kte7FYNchJGAGsP4M+NsbzQ6EoM8Cpjv4J83lKL5Vzv9bbjyJ+eTGgNZCSa+QfZLvPw/P/5BUbtC6wY92+jRvRqFFloTkP+OJi+PPxHKjigVswBI7nxD1kHic4tWCvD4C0C6WlWsrqMFcOflRR59ZxWA9rJYEwc4PDJdJy7zMZI8fYC6sMs2kMh6Os1nl4QVjeqzLJvzSQnjH++d+tmHFiG34qzOE60pqIMKUH3+HifcUq9yIJ7iirRwunDcIe11IV7l+GBUPA6gGAoWZa8brM/G++btGpHLqxa/mBMf9TopBjpxoshNZQsT6532Ha4tpf30jSrYybYEpXWp7azZGy4ElJZoOIl9meDJaUU0fN0M2QjY2MxQtcW5dMwA/zVRXlp8R76ip5XN1mIERZYzU9USgxvnwG1ldY0LqQSAOGsI4mtOORZcScKeKHUwSKJsmKlVB3Qy+Uj0kz5SEodDbkJEKEGuCJL+mtdPwMVQewluQ5JhLirTkQ/J1zoHPkQhq/PLuWxr7x5brVm30tmh5fdj6ydV3gWHABXJ0TvSRiGxfGRrY7c3go6fSQhxLm6l38gwX3inCZ+7Q2+XMMUzXDQgswCviBnSpGNBUgerxHuuyIXvdUjvjtr2odwtdh/cdheRWZOQsm/uHqMlcn3K56TcGnqS1242xIIJiS9oiize3qtoeeyq1/Kx98pfEgb04LMl4jOELS2oCSD/R6xHqZksCKYstz0m1yoBwRwltgIjOeqA2NsIoRr1ZYGNMNOZ8ooJUVuqECuuBYseYtJdX2QYR4MICTkCzPN2iB/WefpZ0TXYxJAHlWfKcEGBUL0575GKxJvvQ8ZGfyY5Py6P+J0JGhawYXraCaxOtS8vVr2a6egvp8k8JENIPd
 k2pcbJVq
 vo5t2ho2CjzykPUbHF/jWSlvQgjsjOza15HhuN9HHooH897/e67nXb5CojkqvfGYtSUiEhyuOg6b57d8RfeTpA0rt1P9YD74xpsVEoezceb+Ngm3PX7QdMcM8RvlnqPiFzqQ5jhYcKvSPXh3t/VpSbJGByeTNV9qyJihKKPXHpsm9sczNtCBdWtoxG03jAfPSwXhexGUHNxSkTdDkEYmqbcL1tJAQvT/3xxF75HTvV2T3HEnH3DOjti3OCs7/5IHG3ry+3ZDLxdgmv1/jDTcEx6oEmszPXk5bYlcuwr/oyA+WlKA4M/3qUEsNmdBvHCVLvRhmHNPxBDUxI/KR/tQDcTymoPi2oaAuw8kSdJuJJj/n6pA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:29=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Mon, Jun 22, 2026 at 10:57:30AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Jun 22, 2026 at 10:11=E2=80=AFAM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Mon, Jun 22, 2026 at 09:58:55AM -0700, Andrew Morton wrote:
> > > > > > much as I personally find restricting mmap readahead to a VMA a=
 sensible
> > > > > > thing to do). We just need to figure out how to improve the And=
roid
> > > > > > usecase.
> > > >
> > > > Would a helpful heuristic be to do what 7b32f64bc512 is doing, but =
only
> > > > if PROT_EXEC?
> > >
> > > I was wondering the same thing.  But I think it's right to back this =
out
> > > for now and try that after -rc1 so it gets some time soaking and
> > > bot-teesting.
> >
> > Thanks for the suggestion! That sounds sensible to me.
>
> I don't think this works. Here's an example readelf -a from a random,
> trivial ELF I have:
>
> pfalcato@pedro-suse:~/linux> cc -g main.c
> pfalcato@pedro-suse:~/linux> readelf -a a.out
> ELF Header:
>   Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
>   Class:                             ELF64
>   Data:                              2's complement, little endian
>   Version:                           1 (current)
>   OS/ABI:                            UNIX - System V
>   ABI Version:                       0
>   Type:                              EXEC (Executable file)
>   Machine:                           Advanced Micro Devices X86-64
>   Version:                           0x1
>   Entry point address:               0x401040
>   Start of program headers:          64 (bytes into file)
>   Start of section headers:          18448 (bytes into file)
>   Flags:                             0x0
>   Size of this header:               64 (bytes)
>   Size of program headers:           56 (bytes)
>   Number of program headers:         14
>   Size of section headers:           64 (bytes)
>   Number of section headers:         38
>   Section header string table index: 37
>
> Section Headers:
>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
>   [ 0]                   NULL             0000000000000000  00000000
>        0000000000000000  0000000000000000           0     0     0
>   [ 1] .note.gnu.pr[...] NOTE             0000000000400350  00000350
>        0000000000000040  0000000000000000   A       0     0     8
>   [ 2] .note.gnu.bu[...] NOTE             0000000000400390  00000390
>        0000000000000024  0000000000000000   A       0     0     4
>   [ 3] .interp           PROGBITS         00000000004003b4  000003b4
>        000000000000001c  0000000000000000   A       0     0     1
>   [ 4] .hash             HASH             00000000004003d0  000003d0
>        0000000000000024  0000000000000004   A       6     0     8
>   [ 5] .gnu.hash         GNU_HASH         00000000004003f8  000003f8
>        000000000000001c  0000000000000000   A       6     0     8
>   [ 6] .dynsym           DYNSYM           0000000000400418  00000418
>        0000000000000060  0000000000000018   A       7     1     8
>   [ 7] .dynstr           STRTAB           0000000000400478  00000478
>        000000000000004a  0000000000000000   A       0     0     1
>   [ 8] .gnu.version      VERSYM           00000000004004c2  000004c2
>        0000000000000008  0000000000000002   A       6     0     2
>   [ 9] .gnu.version_r    VERNEED          00000000004004d0  000004d0
>        0000000000000030  0000000000000000   A       7     1     8
>   [10] .rela.dyn         RELA             0000000000400500  00000500
>        0000000000000030  0000000000000018   A       6     0     8
>   [11] .rela.plt         RELA             0000000000400530  00000530
>        0000000000000018  0000000000000018  AI       6    24     8
>   [12] .init             PROGBITS         0000000000401000  00001000
>        000000000000001b  0000000000000000  AX       0     0     4
>   [13] .plt              PROGBITS         0000000000401020  00001020
>        0000000000000020  0000000000000010  AX       0     0     16
>   [14] .text             PROGBITS         0000000000401040  00001040
>        000000000000011b  0000000000000000  AX       0     0     16
>   [15] .fini             PROGBITS         000000000040115c  0000115c
>        000000000000000d  0000000000000000  AX       0     0     4
>   [16] .rodata           PROGBITS         0000000000402000  00002000
>        0000000000000004  0000000000000004  AM       0     0     4
>   [17] .eh_frame_hdr     PROGBITS         0000000000402004  00002004
>        000000000000002c  0000000000000000   A       0     0     4
>   [18] .eh_frame         PROGBITS         0000000000402030  00002030
>        0000000000000088  0000000000000000   A       0     0     8
>   [19] .note.ABI-tag     NOTE             00000000004020b8  000020b8
>        0000000000000020  0000000000000000   A       0     0     4
>   [20] .init_array       INIT_ARRAY       0000000000403de8  00002de8
>        0000000000000008  0000000000000008  WA       0     0     8
>   [21] .fini_array       FINI_ARRAY       0000000000403df0  00002df0
>        0000000000000008  0000000000000008  WA       0     0     8
>   [22] .dynamic          DYNAMIC          0000000000403df8  00002df8
>        00000000000001e0  0000000000000010  WA       7     0     8
>   [23] .got              PROGBITS         0000000000403fd8  00002fd8
>        0000000000000010  0000000000000008  WA       0     0     8
>   [24] .got.plt          PROGBITS         0000000000403fe8  00002fe8
>        0000000000000020  0000000000000008  WA       0     0     8
>   [25] .data             PROGBITS         0000000000404008  00003008
>        0000000000000010  0000000000000000  WA       0     0     8
>   [26] .bss              NOBITS           0000000000404018  00003018
>        0000000000000008  0000000000000000  WA       0     0     1
>   [27] .comment          PROGBITS         0000000000000000  00003018
>        0000000000000019  0000000000000001  MS       0     0     1
>   [28] .debug_aranges    PROGBITS         0000000000000000  00003040
>        0000000000000150  0000000000000000           0     0     16
>   [29] .debug_info       PROGBITS         0000000000000000  00003190
>        0000000000000444  0000000000000000           0     0     1
>   [30] .debug_abbrev     PROGBITS         0000000000000000  000035d4
>        0000000000000245  0000000000000000           0     0     1
>   [31] .debug_line       PROGBITS         0000000000000000  00003819
>        0000000000000274  0000000000000000           0     0     1
>   [32] .debug_str        PROGBITS         0000000000000000  00003a8d
>        0000000000000540  0000000000000001  MS       0     0     1
>   [33] .debug_line_str   PROGBITS         0000000000000000  00003fcd
>        0000000000000163  0000000000000001  MS       0     0     1
>   [34] .debug_rnglists   PROGBITS         0000000000000000  00004130
>        0000000000000042  0000000000000000           0     0     1
>   [35] .symtab           SYMTAB           0000000000000000  00004178
>        0000000000000360  0000000000000018          36    20     8
>   [36] .strtab           STRTAB           0000000000000000  000044d8
>        00000000000001bc  0000000000000000           0     0     1
>   [37] .shstrtab         STRTAB           0000000000000000  00004694
>        0000000000000176  0000000000000000           0     0     1
> Key to Flags:
>   W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
>   L (link order), O (extra OS processing required), G (group), T (TLS),
>   C (compressed), x (unknown), o (OS specific), E (exclude),
>   D (mbind), l (large), p (processor specific)
>
> Notice the section header table, and how it starts after program text and
> program data, and how all the other ELF gunk (debug info, symtab,
> strtab(s)) also goes after .data. So (mostly) the real problematic readah=
ead
> would be on the RW VMA that covers .data.
>
> (This also matches my understanding of linkers, where they generally do
> (to put it simply) ELF headers - program headers - .text - .data - .bss, =
with
> stripable gunk after it.)
>
> It's also the case that synchronous RA on VM_EXEC is already pretty
> conservative and limited, see the big if (vm_flags & VM_EXEC) in
> do_sync_mmap_readahead(). (I think the underlying logic behind also
> implies that async RA will not be started against these pages, but I
> am not sure).
>
> --
> Pedro

Yes, I think readahead of VM_EXEC is already restricted to the VMA.
Maybe there is an edge case where someone does buffered reads on an
ELF file, leaving a PG_readahead flag inside the VM_EXEC range, then
it could trigger async readahead beyond the end, but that sounds
minor.

For next steps: Suppose we show the mmap usage in this video encoder
is significantly inefficient compared to buffered reads or a big mmap
and that project accepts a contribution to move away from the small
mmaps. Would we be comfortable attempting this again as is? Probably
there would be a lag before all users of the encoder update and they
may see this bad perf.

If it isn't OK as is for the foreseeable future, we could consider
applying the limit conditionally. Maybe a CONFIG or sysfs option. Or,
use some heuristic to turn it on automatically, e.g. only for ELF
files, or files with VM_EXEC mappings.

We are planning to measure how this change affects memory usage of
Android devices in the field, but we don't have the data yet.

