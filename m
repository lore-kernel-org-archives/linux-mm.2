Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559E8CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 19:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A31A6B0005; Mon, 22 Jun 2026 15:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BA56B008A; Mon, 22 Jun 2026 15:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469C36B0093; Mon, 22 Jun 2026 15:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97D26B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:29:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C11DE8CD85
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:29:44 +0000 (UTC)
X-FDA: 84908538288.06.CF8CB8D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92305180008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:29:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YFVdX2yl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Bm+TR6Fh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="A9Cc/YNp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RtYkz2bH;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782156582;
	b=NsufAqRpOyIYsG92CBByqCKZxYzqcye0Wlq8PtDR09xBid9FsnnLaQ+J9QLcmcETmGynD2
	yAjO4uW+mr6Y3GxgcVYY+rM4jyoTYYFYqlJb/ND1c02cRFWK4JM0Sn6+ll0H0389zitsCG
	VuqHMYpyKqdydw1muOlUJ2FPQw+492U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782156582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOyI9DPf+OPLkTpriyNWetIArQJTx5lcdWQuxRuSzak=;
	b=tPxEn3X1TQnNGpO5rFkoTzArbpVU/Zxy6YS54jw2RZUsbF4YsLjA9VAfhQFMue5+jw4L32
	MntHG4rlHWYaNWWg+Q7/blRCV+TDq7kqI/W3LITTT0BX94+h5t0Zu2rVdlZNbcMXa0XmxL
	Ir3rnInj5baT0GJs3zdop4nzn+ZcBYM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YFVdX2yl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Bm+TR6Fh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="A9Cc/YNp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RtYkz2bH;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C045B75D4C;
	Mon, 22 Jun 2026 19:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782156581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOyI9DPf+OPLkTpriyNWetIArQJTx5lcdWQuxRuSzak=;
	b=YFVdX2yljZkNOCr7ym6aWfSQWl2FzdxExPfWa8tKgA9r/dLdQd2C3atPJZqJxleBgLLpEJ
	e+q7QJxOCi0seV/qQntUCS+Mc/6Px5aVglvAauOMsRLxOcaGmKBhVVCGa+E1UNo4c1KSX5
	exPN32UtdbQVSKkOY2YGYLGRiixiuvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782156581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOyI9DPf+OPLkTpriyNWetIArQJTx5lcdWQuxRuSzak=;
	b=Bm+TR6Fhtr82wUXQE6KMbndzinjvZhwfV761R7emRTGKALwTh9FyZF37kj7dwb8O6Itm4/
	gYo98hqKztDiEUCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782156579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOyI9DPf+OPLkTpriyNWetIArQJTx5lcdWQuxRuSzak=;
	b=A9Cc/YNpUC53pt/VowlLRsrAl2cQ3h4BYfhVB/kzFfJ+hVQ4bE/p7MQ35LQqW0c01TdeyI
	asI2APcT8QxarUpYf2HzoEiiRqvYzgK6SJI1wS19zm/8b4MBm0mVWbrsIxp7bPo2xH6ztm
	fmZuPTHGiT21oM6lTz8bQDN+MH6pk2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782156579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOyI9DPf+OPLkTpriyNWetIArQJTx5lcdWQuxRuSzak=;
	b=RtYkz2bHLTo25azAgm8e6gYXNgFfd5e66zHvKb25qxHlAPYIhm0JzNFhO2UJ5nLN91PX8i
	bJlz0LQibdTS92Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED802779A8;
	Mon, 22 Jun 2026 19:29:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r0YfNiKNOWpxewAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 22 Jun 2026 19:29:38 +0000
Date: Mon, 22 Jun 2026 20:29:37 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajmJT6AAor46gLBw@pedro-suse.lan>
References: <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
 <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan>
 <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
 <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
 <ajk-NMghY50F6Sli@lucifer>
 <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
 <ajlsum91zeh-oRz6@casper.infradead.org>
 <CAJuCfpHaBFtgAyE4jum-=p3u8X3STi3e6i6==fQR+0ksaU2wwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHaBFtgAyE4jum-=p3u8X3STi3e6i6==fQR+0ksaU2wwA@mail.gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: dznairfu3aqk7d1rzmr8hzzegnotetmz
X-Rspam-User: 
X-Rspamd-Queue-Id: 92305180008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782156582-165597
X-HE-Meta: U2FsdGVkX187NXzfMZEWP4Y7jRu60nETeSrpXbce4mnWefrs/sBuNtghYyikq9nzd7+y8dkXghg/gxFu++iPcql69ppbRraoYTWdBu5RAx1tqFcvxLjO1dmk3+y2vFbfmH+7pZ4keXDH0CIIJlqgcJP4+r8JCUHhmLAz6nKsK+Cm6OkeYonHxIqv3s3+ojKSQvMrI46TeS/utbzzlNiiNHp/iDq7zZPM90eFxZ5j3SCCuQgDb4Wx32zDG12H9nDS7IzxGPgdMJeozdQDulUrej9bTCSXIIUCF/cRFHGVaemhdjXqt8P8bgthvhhxIYmrHqnQ+OWKdmUqQws3PHQ+gRJkqHWo6Ht87gDjEDNz3zHFz+VsmVlyq9YQDmWPKay/+XnE8iB4Kz/hIg9Y019/OttPgrUixzNbYbFjaZouPC9t3qcU/5DyawhRFK1isHh0eE+AYzejxGWxiQVaJjxv6HyaH4yEHE6oPlKB9psoTKrX/pEK7fji0C9X5eIQX+JsL2VFikRkj4nVY3cNOutXKZvGA0U9fGBL1aPjUwJMEeIhpT1CJdxAgW1Cd3DFmJkr08S8x0h3Y2Zilpns89KZXzWjEwtYJ2GTAH2DU22L7tRQFGvOQUxq4muw2gagfjJqV45ilTwiXXUpeyK8/7yzf/j6PMmkgrbWiuygIeqQ9KWLMA471zG4VhlwZnjdETM7x9G574stXBY2JlSZGp5K1R73u3sCE3sK0OnW+kmtchHqXRbBbTFknxRjj4QL0Lwz+14T9DsKHmYryGfB3H/53TzgRjoSNT18966/Q3fsCoaNQcU+GaPpBlHNopyqBJjetOihoNMkCYq/PVS67395ai+8WBPAyoEFSrsw9IR4aurOumhyrKlEREcVaCv2b/489wNbwcniA+QudlgDZgN85k6nQbi7luU5nWXCgvHoL5yjLJd4dDo8472GdiL4URHELvYxBJI/c4MHjYSYNT/
 JlVnXKkN
 6OF2PzHy9JM6FYJFlNKw8aotXCiF4tCB7G4GFxYdo9H6dmo5dg0B/J/ToW3cvh8xa5V51zPbCBu5zykfoWqxJaxf9iE9iGwW6M0rrXSfDBaN5pBbPFPt4Qff0Z+myCTye6qb5HrloMdGxyJlmakQta4hLPuqWm+v8wYQMVvkWkLZXqn6eY64IeUyGvjQ51DiqT8i6oL6h60XMsxQZe/Vo4mrYMfJP95t0bJloqyUFO3CmsWCopQPgim+lg//KolecZgfd4TuY27YlHqCs7przDy3mu7czR5A9q6OgCQOJ9AM4K+ilhQUtN71RLmiMd9EXCMalpPTk50RYWSexDdGGtSf1aqnCIRmFoOJUYBmrxwDagI8S/8Te6oHIKyltD4H1G8TZ6Ad7jvGSPB9hDycpnmpl/E7IWv9Eh+qyR10aIo2Qb4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 10:57:30AM -0700, Suren Baghdasaryan wrote:
> On Mon, Jun 22, 2026 at 10:11 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Jun 22, 2026 at 09:58:55AM -0700, Andrew Morton wrote:
> > > > > much as I personally find restricting mmap readahead to a VMA a sensible
> > > > > thing to do). We just need to figure out how to improve the Android
> > > > > usecase.
> > >
> > > Would a helpful heuristic be to do what 7b32f64bc512 is doing, but only
> > > if PROT_EXEC?
> >
> > I was wondering the same thing.  But I think it's right to back this out
> > for now and try that after -rc1 so it gets some time soaking and
> > bot-teesting.
> 
> Thanks for the suggestion! That sounds sensible to me.

I don't think this works. Here's an example readelf -a from a random,
trivial ELF I have:

pfalcato@pedro-suse:~/linux> cc -g main.c 
pfalcato@pedro-suse:~/linux> readelf -a a.out 
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x401040
  Start of program headers:          64 (bytes into file)
  Start of section headers:          18448 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         14
  Size of section headers:           64 (bytes)
  Number of section headers:         38
  Section header string table index: 37

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .note.gnu.pr[...] NOTE             0000000000400350  00000350
       0000000000000040  0000000000000000   A       0     0     8
  [ 2] .note.gnu.bu[...] NOTE             0000000000400390  00000390
       0000000000000024  0000000000000000   A       0     0     4
  [ 3] .interp           PROGBITS         00000000004003b4  000003b4
       000000000000001c  0000000000000000   A       0     0     1
  [ 4] .hash             HASH             00000000004003d0  000003d0
       0000000000000024  0000000000000004   A       6     0     8
  [ 5] .gnu.hash         GNU_HASH         00000000004003f8  000003f8
       000000000000001c  0000000000000000   A       6     0     8
  [ 6] .dynsym           DYNSYM           0000000000400418  00000418
       0000000000000060  0000000000000018   A       7     1     8
  [ 7] .dynstr           STRTAB           0000000000400478  00000478
       000000000000004a  0000000000000000   A       0     0     1
  [ 8] .gnu.version      VERSYM           00000000004004c2  000004c2
       0000000000000008  0000000000000002   A       6     0     2
  [ 9] .gnu.version_r    VERNEED          00000000004004d0  000004d0
       0000000000000030  0000000000000000   A       7     1     8
  [10] .rela.dyn         RELA             0000000000400500  00000500
       0000000000000030  0000000000000018   A       6     0     8
  [11] .rela.plt         RELA             0000000000400530  00000530
       0000000000000018  0000000000000018  AI       6    24     8
  [12] .init             PROGBITS         0000000000401000  00001000
       000000000000001b  0000000000000000  AX       0     0     4
  [13] .plt              PROGBITS         0000000000401020  00001020
       0000000000000020  0000000000000010  AX       0     0     16
  [14] .text             PROGBITS         0000000000401040  00001040
       000000000000011b  0000000000000000  AX       0     0     16
  [15] .fini             PROGBITS         000000000040115c  0000115c
       000000000000000d  0000000000000000  AX       0     0     4
  [16] .rodata           PROGBITS         0000000000402000  00002000
       0000000000000004  0000000000000004  AM       0     0     4
  [17] .eh_frame_hdr     PROGBITS         0000000000402004  00002004
       000000000000002c  0000000000000000   A       0     0     4
  [18] .eh_frame         PROGBITS         0000000000402030  00002030
       0000000000000088  0000000000000000   A       0     0     8
  [19] .note.ABI-tag     NOTE             00000000004020b8  000020b8
       0000000000000020  0000000000000000   A       0     0     4
  [20] .init_array       INIT_ARRAY       0000000000403de8  00002de8
       0000000000000008  0000000000000008  WA       0     0     8
  [21] .fini_array       FINI_ARRAY       0000000000403df0  00002df0
       0000000000000008  0000000000000008  WA       0     0     8
  [22] .dynamic          DYNAMIC          0000000000403df8  00002df8
       00000000000001e0  0000000000000010  WA       7     0     8
  [23] .got              PROGBITS         0000000000403fd8  00002fd8
       0000000000000010  0000000000000008  WA       0     0     8
  [24] .got.plt          PROGBITS         0000000000403fe8  00002fe8
       0000000000000020  0000000000000008  WA       0     0     8
  [25] .data             PROGBITS         0000000000404008  00003008
       0000000000000010  0000000000000000  WA       0     0     8
  [26] .bss              NOBITS           0000000000404018  00003018
       0000000000000008  0000000000000000  WA       0     0     1
  [27] .comment          PROGBITS         0000000000000000  00003018
       0000000000000019  0000000000000001  MS       0     0     1
  [28] .debug_aranges    PROGBITS         0000000000000000  00003040
       0000000000000150  0000000000000000           0     0     16
  [29] .debug_info       PROGBITS         0000000000000000  00003190
       0000000000000444  0000000000000000           0     0     1
  [30] .debug_abbrev     PROGBITS         0000000000000000  000035d4
       0000000000000245  0000000000000000           0     0     1
  [31] .debug_line       PROGBITS         0000000000000000  00003819
       0000000000000274  0000000000000000           0     0     1
  [32] .debug_str        PROGBITS         0000000000000000  00003a8d
       0000000000000540  0000000000000001  MS       0     0     1
  [33] .debug_line_str   PROGBITS         0000000000000000  00003fcd
       0000000000000163  0000000000000001  MS       0     0     1
  [34] .debug_rnglists   PROGBITS         0000000000000000  00004130
       0000000000000042  0000000000000000           0     0     1
  [35] .symtab           SYMTAB           0000000000000000  00004178
       0000000000000360  0000000000000018          36    20     8
  [36] .strtab           STRTAB           0000000000000000  000044d8
       00000000000001bc  0000000000000000           0     0     1
  [37] .shstrtab         STRTAB           0000000000000000  00004694
       0000000000000176  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

Notice the section header table, and how it starts after program text and
program data, and how all the other ELF gunk (debug info, symtab,
strtab(s)) also goes after .data. So (mostly) the real problematic readahead
would be on the RW VMA that covers .data.

(This also matches my understanding of linkers, where they generally do
(to put it simply) ELF headers - program headers - .text - .data - .bss, with
stripable gunk after it.)

It's also the case that synchronous RA on VM_EXEC is already pretty
conservative and limited, see the big if (vm_flags & VM_EXEC) in
do_sync_mmap_readahead(). (I think the underlying logic behind also
implies that async RA will not be started against these pages, but I
am not sure).

-- 
Pedro

