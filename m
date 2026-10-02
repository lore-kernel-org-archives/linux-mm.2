Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C129ECA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C839F6B008A; Fri,  2 Oct 2026 05:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EE46B008C; Fri,  2 Oct 2026 05:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5716B0092; Fri,  2 Oct 2026 05:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1BA6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:53:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53D5BA7625
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:53:38 +0000 (UTC)
X-FDA: 85277224116.21.DFAD300
Received: from mail-wr2-f33.google.com (mail-wr2-f33.google.com [74.125.225.97])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7189540006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:53:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MeFDlLBK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934816;
	b=6AACHvzJo4kCClCmUS8z3otkmxEszYKTcvW99ijV+S7gIfpOoh+PZe5pO5o/wMB14bkhsH
	OCNqvwWxTea2JoctJda+MaMgihtqdfhQ07qCWWy6g//slcVTP5tVenJnrd90th88jAFvSZ
	3jUXCXa9VMs17VI2+BbK1Q8ULc2S7YQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MeFDlLBK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNC9YCP8AT7IxNNn4b5VtrbR3K2PgY3ERGLBHswr9ww=;
	b=TuBxd1ylW3zUKZBx1+JXbi2BKFGuWk5kK/48E2bh703vFd1zAsNhptK9Gcyz9T4TdPB6AU
	En+m3j6jdD8GaLg9Et8pnoeaF5viQhIxtsQHmIL2NIbxk+rFRecMRCDoSmnzFelc6rrOei
	59WgUCJsj3CRbB9WOTMF3eAA4UG7zXs=
Received: by mail-wr2-f33.google.com with SMTP id ffacd0b85a97d-48b104f6aa3so769165f8f.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790934815; x=1791539615; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uNC9YCP8AT7IxNNn4b5VtrbR3K2PgY3ERGLBHswr9ww=;
        b=MeFDlLBKZW8TPbbvW6xpRBz0Wl6K4GfPlIE3H8qHlsx0w33cVRiwzjELS8D486Bmr4
         NWAe5Hv2jAohsH6hssmu65T32VlaJhkdT6tIleZWdwk0K5MuUfMtEL0WGhX3et2vv41X
         t1O+TH1sGfYiE/nIuAuNSRdWlncf76t6suSWVzd+tOY4yqtiv4DU59jHLn9qNXGuhry1
         /w/pKy2MK+kzvj2mPWZsG/fL4iXCSDmBx37UdPqRju7NtqEG+iPlw2xtMbKenrr6haYH
         j/iGOzOkkVaum/ZvZHFt9j0M1cSPS9DUuofuRzNhyAdHp+rPdWXsuI4v82a7XekaE0d1
         3OJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790934815; x=1791539615;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNC9YCP8AT7IxNNn4b5VtrbR3K2PgY3ERGLBHswr9ww=;
        b=Oh6fTe9PRfg0h4vHRiguqEkD2rBcageq5spYC65OxT7hu4XkjijdlqZGM2YssTq5wq
         yA97ndohshLmyKehzKBNXrtzGPSaa01q0+II4T9/69sFQOc1dfXuw/Ghq5g2VqUmSDlq
         1w8buUGahmAsO4e5CXGiAoY1hTzDxNAwwxni0XFR8FdA6b57EsgqyrBQrTkyKQeAwqrM
         Q1qiQaDBDUY9wiYRUEWeKUTNcZXns+fBNXhdy7EIa7ZUb945c50Ie8bdJNP6zh5YglRm
         xgK3s2jijg/jXV/VAHuKAzUkxw0e5xZ7G+HmskBzY2sPsr8DcwZ8z9Lm+VZzfYXQGWzd
         9YAg==
X-Forwarded-Encrypted: i=1; AKwUvByNMbZzUgnDb+ItC7EpCuQObnYbq3GEiaXssESDPloU3qQY99krYxZS4YTOLQwEwrmW2GM37hdpmQ==@kvack.org
X-Gm-Message-State: AFuF++kIG9cCWTQY2MfC6OhCGfnBP1t5PzFWYbQ4XC9ercrwGuozMNCM
	uJcuMYrRaA3esDKPvzDnMmWonxu3jNd6ZWp6rOp8bAcrSt+s7Vhpa9P/
X-Gm-Gg: AYBFou0z7CiMYwU5Wx9TQVWmHe/+CBNf2tYEkpSq+ESxd0kjSC14VBOAqSg8wbkn1hG
	qrTs2EkAJ14sgISx6cPr3SOU7LSK5R0XMDiKZGixJ8HuU0R+03UwbxcR/Rm1Oqc1vQcF13vyarw
	4+eh53hl3y/BAcPnh99jgGq5tNG0L2QbMZ2gQ6ICm5wDqMQCaeqnau7fFcR/ZuvX0WvgwZS5DUV
	VGaGRXF0eX69Za9LkqwSryA88l1y/p9DkSjVhq5gd3UkrLNBBkCFFKiHE4jSO+M5T25uBJUwmz0
	fvBIP204uVTs4VW/NrUE/ZvdDQiDjLhQNfBw59dsejls/4vyJZxn/OFoXQOd0pWnSQimD08ThlP
	LFqb7USlDXsdxi0qUXpf8h649Fpgy05Y5/MMkq/9PbC8gqS6XLX8xkgvdwtKfl6qEoR8o96d++1
	aWVRDK9RXC6Hn8gqvpGb4TUUiOQpx+s7LikzteIqCmAolFIv0g6R2RkbXCANileTF4SyEdEApTO
	RvLyO2vGcx8pUQsTZlExrpSBeCC7XVuSP5ZOOqXIyiPkw==
X-Received: by 2002:a05:600c:1f87:b0:4a0:1efa:c74c with SMTP id 5b1f17b1804b1-4a0275a1d54mr38515505e9.20.1790934814461;
        Fri, 02 Oct 2026 02:53:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a02854073csm58305185e9.3.2026.10.02.02.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:53:34 -0700 (PDT)
Date: Fri, 2 Oct 2026 10:53:33 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot
 <lkp@intel.com>, Josh Law <objecting@objecting.org>,
 oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Memory
 Management List <linux-mm@kvack.org>, linux-mips@vger.kernel.org, Bradley
 Morgan <brads@mainlining.org>
Subject: Re: arch/mips/boot/compressed/decompress.c:undefined reference to
 `__ashldi3'
Message-ID: <20261002105333.6f77abd0@pumpkin>
In-Reply-To: <ar4050mdKL_W8yI9@pedro-suse.tail5790ac.ts.net>
References: <202609301826.MFaFMsmd-lkp@intel.com>
	<20260930120159.7e4f29a82d461bd8b040454e@linux-foundation.org>
	<ar4050mdKL_W8yI9@pedro-suse.tail5790ac.ts.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: e44uxhdj7xq55q3fhry79su48fbou8bw
X-Rspam-User: 
X-Rspamd-Queue-Id: 7189540006
X-HE-Tag: 1790934816-707119
X-HE-Meta: U2FsdGVkX18BoWGyaSsVKDv0fG3Ecve++R2bY8Yesn6Gj4eNzlHf12vvv/dudzzfPPImis1Q28wyBXHznQeHl7mnfHGxqqMwBb/EMfEt+fsRapDnk7zyPqRxCy+Fd7RhMy4BFFtqJ2Yj8S5cYiP0kz0Xkzr8a3cgKd8xo8c1zcjjrNpFchnuMj1HQ4QUP4CqC0ZvQxMqAzmbi47RSef758oD3FsNXtC5qQD0t/IBMS9XrLYxrNgh1OvsSM8USF7P17VRrI5ZxGJVTcLc/5qhevHiMUBTuIjpUq7cQh806QNJxvotW+QPYsNMydoKWDNnUTDSGf5QZGeM6uNMbPrmW5nXlcWGPuXdrYbL6p4JcB4KufBgjVN3OU88TVJ4/s67DKliOkWJEXjEC/987NTf1a7XLGDnm9yaBpUANi1an0x8cSG+Oo41Dk5/ooSSeFJC3GupMJla5XptfhN+8bupQqduHmb+umGfst2f1cc/ZOBAmVED6zmvSGsKSN2Ph4dCaRlwWx9FZ1IzFWR39rXt18kbcRdD2W/hF/z0r9K9g/dRd0q51SFaVcIdwFfXek0MevJC3lA9fb93WIcFBWSwKe+T4LJidPxQzOyhTl/SHgjAjIM5r/o7xtVAApsmKCZtlHlngX05nylwFd2bfZvM/68Mwo2cSshPaSzoxXtWH7xYmO9k3rSZUo6yY0LwdLCE7f53QVAs2kPVJ8VujLBesAMqPoNWLic+MDPOkFwBqkV3x8iV8AkCiPxS+h2pAU+zOEVxML/MlibQ+HefGITSMzgzJ4eQ28qnZPkMvzf2c9JEtX46jWwsuS6nzgwB0PLJWTERWUZwJBBRA/hg9lt24t5JXq1438yqMOfHV1hMOJMbTrMbjw+TAGCtvs0YCYWYMyoPRFdRXM8E68tCV2vTSrzW6f7D83nOc+NEPJjdRZKo8pcVsWkxS6+9U+zKH+8CcJbardsUAh+hIwI2eZY
 OwNUUShL
 YUjxrMGsjM/NPBYU7BE6oonHi/D7fCstEX/3+NKk2xxSKt875Kry6dj0g3wuaLPPXiZDAjp2tCJnvXfOWXtaFt7y/E+hex3S3oRRIEG4fupmnX4dTWyLl/0xMIvzO7s2wrdokDIqTZeKm5mdPi91Na12f2faI9E5vh3izsVGjDv37VGtYCN54mcNSVK4ZzsZT+niyd/JbgRR9UTPAFW9aVrmget9n7G6qgBJL66u453anw69l13hhLxxHE0lIF6YIgWYkXsgjyeomf9IJvps8uMC5PHO9DPH1gdCFKnZVjXyLBf800QtPvwvpi0ThWrx6NgCBeEwIk2DAIpYB5+SDRN7/km7oAtSntmay8Wh59y4549Z1e2vV8aFlL8baR8hrAU5ldyTOdrfaokuVuZstQuHQq8yUgWZxOS2MlvIKK7So8Y59y8w/CERmURkWExsqisluI9sK1JN56AwpZgr2AcEYROsfPSxZzYUjO1JvTKxZTRyNjxHaETeeHuzGh6/a0pcVt78A4dCbmTyE97RjtpWpuKlje2ugdorqUimFWdythlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Oct 2026 11:30:09 +0100
Pedro Falcato <pfalcato@suse.de> wrote:

> On Wed, Sep 30, 2026 at 12:01:59PM -0700, Andrew Morton wrote:
> > On Wed, 30 Sep 2026 18:36:50 +0200 kernel test robot <lkp@intel.com> wrote:
> >   
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > head:   551c722f40809618230001baccf219193e22fc5a
> > > commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
> > > date:   6 months ago
> > > config: mips-randconfig-r2300-20260930 (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/config)
> > > compiler: mips-linux-gcc (GCC) 15.2.0
> > > sparse: v0.6.5-rc1
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202609301826.MFaFMsmd-lkp@intel.com/
> > > 
> > > All errors (new ones prefixed by >>):
> > > 
> > >    mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':  
> > > >> arch/mips/boot/compressed/decompress.c:(.text+0xf4): undefined reference to `__ashldi3'
> > > >> mips-linux-ld: arch/mips/boot/compressed/decompress.c:(.text+0x168): undefined reference to `__ashldi3'  
> > 
> > I dunno, I'd be suspecting a toolchain issue here?
> > 
> > --- a/lib/decompress_bunzip2.c
> > +++ b/lib/decompress_bunzip2.c
> > @@ -135,7 +135,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
> >  		}
> >  		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
> >  		if (bd->inbufBitCount >= 24) {
> > -			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
> > +			bits = bd->inbufBits & ((1ULL << bd->inbufBitCount) - 1);
> >  			bits_wanted -= bd->inbufBitCount;
> >  			bits <<= bits_wanted;
> >  			bd->inbufBitCount = 0;
> > @@ -146,7 +146,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
> >  	}
> >  	/* Calculate result */
> >  	bd->inbufBitCount -= bits_wanted;
> > -	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
> > +	bits |= (bd->inbufBits >> bd->inbufBitCount) & ((1ULL << bits_wanted) - 1);
> >  
> >  	return bits;
> >  }
> > 
> > 32-bit MIPS should be able to do this?  
> 
> FWIW the patch seems entirely bogus. I don't think you can have inbufBitCount >=
> 32. If you could, then the patch would still not fix anything, because
> bd->inbufBits is an (32-bit) unsigned int.

The 1 should probably be 1U (or possibly 1UL is 64bit values can happen on
64bit) rather than 1ULL.

Wasn't the problem being solved '1 << 31' being undefined (or UB) and one of
the static checkers deciding that should never shift a signed value left?
That is entirely bogus anyway.
It is only non-portable because C allows 1's compliment and sign overpunch
for negative integers, gcc supports neither (and I think the next C standard
mandates 2's compliment).

That is separate from shift right of negative values being UB to allow for
cpu that don't have a sign replicating shift (all modern ones do).
Think about it, for a shift/rotate left you need one of 0/carry/high-bit and
for shift right 0/carry/low-bit so two instruction bits can select one of
0/carry/low-bit/high-bit (giving the often implemented but undocumented shift
left that replicates the low bit).

David

> 
> As per MIPS itself, MIPS does not link ashldi3.o into the decompressor for BZ2.
> It only does so for XZ and ZSTD.
> 
> Changing arch/mips/boot/compressed/Makefile would work, but since the change is
> entirely wrong I would suggest perhaps reverting?
> 
> 


