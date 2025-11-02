Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8784CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 14:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA538E0008; Sun,  2 Nov 2025 09:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E920A8E0002; Sun,  2 Nov 2025 09:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF138E0008; Sun,  2 Nov 2025 09:42:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC2EB8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 09:42:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5667B890B7
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 14:42:57 +0000 (UTC)
X-FDA: 84065933994.13.03E0AB1
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53841180002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 14:42:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JTZvWWyN;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762094575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/l01Iq6vPO3vdFoyhFUx3JTe7QcEcGli20S9zTwZ0A=;
	b=yWd7ajVVcLMbNK/gPWvQhc771oJM2VBkEr4zcf4hDKMiIiUw4oVHlcHIHzw3NxFhC8wESA
	EzzrNpEaSkixNfOxp8+VMbtfexb6SB1u8hlm28YGaXDaMkY1XMMTfzHJ1XkVNXpUXxxUst
	KoPRZdydhE6DthEqQv6dwfTCTuXhBzQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JTZvWWyN;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762094575; a=rsa-sha256;
	cv=none;
	b=LUfFMg6LOyKlT2JxgSkI+C33iUQ5Z7gWjROB4bqF+4qqChpc2CWi63Qyx7XOuEUUPruGx8
	aN8RiFZE3y3S7MIQC5niQrKbSSgM4C86uQc4KHgy7ic1asUCzgjyuw7SgnGHcnF8Nv2pMd
	ek//OYA70cCVgPBs94I5ARk/qttSqQo=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429bccca1e8so1405493f8f.0
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 06:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762094574; x=1762699374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/l01Iq6vPO3vdFoyhFUx3JTe7QcEcGli20S9zTwZ0A=;
        b=JTZvWWyN8L6icD9OzuN2RYPWkgM1qXCtLrT8dP9tEofAzoLkJXAMM+8pT22/smoWs0
         klIQdetIsM+XH2a+Y6YxTuQ08xoPmatSPuALs0sa8v73tZlt/+IzKDPGfben7Jr4RsN5
         IrV5bN5IpQ6Zy+OudGftV25LBjt3tP+wFRR8vRIZkApjkj91lfGvVjd1ogYEW3QbpttT
         kip9rq8NLnmgHJDXQmwwRPN/qcBiiSq1xeB4F7qMbWSsx7QmlsG1RiZFy9B3TNQDf12h
         Fhwa/7Rye+kUwTkH9PoVqbdPl8s7vKFDwbWmXEjYbPRCplEqVoxRN2WIto9bSfjYmFMa
         7rPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762094574; x=1762699374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/l01Iq6vPO3vdFoyhFUx3JTe7QcEcGli20S9zTwZ0A=;
        b=KEUYzB84s4QupRnJdM9Zw619yF9hCIYlohOE19/Q1K3P/OOUAGvxF8+EyTq21dfmpC
         Nflw7xXuUubUPKLy69htrBLfa3p3OWVLgB9qGl95cmWRCyzUDe2IdVl4wcrjg9LbGSNh
         gEZQL7KhX4f2nupCw0V5Ni/jpPtZ9MFVZndZ/sQ4xCK06f+V5jxibAmAgH5zEaiQJLUy
         N/8ntSNSyfWD8fQBKokDgdSq4mQbb0xGdFv4WadBe1+YAzmNcPLkQgPpqwOdqe60uohd
         ze/0WlnlgSZDUknmwbSCSLA2rI5PiGNbsYMyEvi8WjlSCp2NO+oXihH4k+KYCwCcH69Y
         873A==
X-Forwarded-Encrypted: i=1; AJvYcCVTQnEVpUo994JQ2dFKa5v6dMfeAt5MHywquHPsCoAURzLfwcwqQh44SkI3KSqOQ//CpQBs4tCiww==@kvack.org
X-Gm-Message-State: AOJu0Yw5iovin9iENmelDAbrQmSqMubloXBxb0JBLxArexiUy60Fm59t
	P6Zfi/Q1KRZTlDRrM1D1d4jbJsxJo0FuQWPVHE8l/qaqyRKEZcd2B1Ko
X-Gm-Gg: ASbGncsV2NZqF14VVwu4QRjyrUVJYMtO3Dspgs2XOn19pm6WdCdApW6tIe7sgPM3BYS
	0D9WEsTRSy0Ppm34zlYPY/g49YTIC3GpVBFJQ2OlGvvXjlSaHn3Hf3Dd35EXUsKTmuBXXWJa50x
	5A/eDnWYdBVGW/81Ot9/M4Uwbi7C3j27BP8swu2FIEuEqboEyqSyEGammWMofgd6SFHIqHoRBWM
	la9sBHxiEYrVddix8PMFExIMVs9agH+C75LzNKMZnJ846Xj6KORXwkB6mJzRV7ctuwstqiI6Wx5
	vF3QtkyogFD5MFe8Kr5uB1heSZvzS0nlOZGyZ6cf+9bTxFCEFLEyrXMDyO6g2g2M6Ri1SfokPz8
	4KaJGrCfC0zsa2SPq0W/w5wz82x0CP5LLBPjPABtbcAM1D7IjzufZTmD/sYn1NnfC8cLvmUM8SS
	naOaTLmBoc5R5eA8jUT3IK98bvWB8SJjHcfYokBuodTA==
X-Google-Smtp-Source: AGHT+IGwk7NnFJJ2q/GzuT4dp1A2zHQCkjebIZnoggNuBMbwztq8FVr8fUfHMAkKCZzaddYwMARkxg==
X-Received: by 2002:a05:6000:400b:b0:3eb:d906:e553 with SMTP id ffacd0b85a97d-429bd6b0fd0mr7392923f8f.55.1762094573419;
        Sun, 02 Nov 2025 06:42:53 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c394f0csm102090855e9.16.2025.11.02.06.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 06:42:53 -0800 (PST)
Date: Sun, 2 Nov 2025 14:42:51 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: Re: [akpm-mm:mm-nonmm-unstable 87/91] lib/base64.c:36:28: sparse:
 sparse: Initializer entry defined twice
Message-ID: <20251102144251.7f0fa78c@pumpkin>
In-Reply-To: <aQdfzCq2JH5QX9AH@google.com>
References: <202511021343.107utehN-lkp@intel.com>
	<aQdfzCq2JH5QX9AH@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53841180002
X-Stat-Signature: mcnhpkzwfpsontaysehq619bbu6cmw1q
X-Rspam-User: 
X-HE-Tag: 1762094575-385871
X-HE-Meta: U2FsdGVkX19IqvVUfjTE3E4kRsSEIbgvI+S8ucH3sEmsLQ6C6S11syEV+LK/aXgWQSYdEXsBRsefHzlAWe8y8eiBuQwyUxvUI367PvCuvvzRZzDE5AHD4JtQNJt8PfFkDibHe/z9VMzc48LmhsrHaoFlZBxTeWHcMKAnCerS6dg1w4BkaRw+mvE/Q/iwSWBsH3xJ0VRZgh/VikzCosjRBNLiZR4wGwFF9JV9N1Fc6SwB3Gk9QZP6WF9U26Lw+peXuSew1Dp+Gb6umxdYeSn1mEjpie4IuCsDxQZ8SVfaF5OQomCSwZh047rktdjdd0uUe5UqmdmSnew060CNtIMNhaumeEc0CWFNWHup8cdkDrB//3wvYW6ASArpIBiBUNZLsJj9SeDvKVQxzcCiR9s+mMlqpX7Kc8UD0N7z1Qv3dyEbPATpTCmN3V02A82Pemj4xp6t3IoVPD2r4JWtP5OEWL9nez0a0hGiRXRoX4ZSBLaqBZ4+0xFeXHUCgUhvkRX2im284ZJ5F20VqFnQ4wHPsQzVOCsSu4rUKOFAV9iG98/co5cc4I6QDnrUB9i7gldDlZszuu8A/PcQ2KffT5D5aRAGjjb7bDDbFLlFddQXPeD2nKiscpa1/hdPWQnniqrVFA9MCaAgm4FLiECUhZvaDmC330yM0e6yz9Ui398XvJ666xYznWg4RzvrfARtkWqRJJ3fHQf2kvSScNEVtJlF5VP1yzQACzOiVsGRlLuWR0Ok50dHWj1KOhuIR0QMEJzEvrq9/pnVwDPi966M7Sx8yldBbz0Ed3DAERgOX3bu2pL7rMoMmHVtBCaA6ojHFQdLqqOAp/cWEjzYkIwvqI0NGPHjcqnGal3qMyoKe9cMcKzpB33xSjltma+Tu3LrSUVjZYaW88cMKiKVi2ZG/1/kZC87xVt/DpAlTYIJY/8SDDHWyQevDIfxdlSzsXrBXIVTSwsPrkDp3HvrkrzcgVH
 +lNcRMjg
 LLHZeX+ZNIACD80fn0D0zUlffc1qvqBFmKvV6AO7KuQTVwfE4DNg1ZWlLxF4+bChGjgWLZFQP/LLOX9wuBGclg1ErSWd6YdwOcStOm4mqY9X0YmlA8OZY2GvQQZte4Ixb5Mial0qg/5OJ3okYdDWdtpsCku4kcsT27cenr+FNmivCzqtkgD7fP+/vgdNnKirPhvAAAmn6tMVzzk7+eqqEYt1j1G0VSUtTSeRg81gk1saZnXS5KpG2DRz0+rAfhQy9Ry8LLPB0VEDolfOu4igR/0m1OXfQ3CjRT9w1m0H/8SXFJLK+CA+42A/hazyCK1c1AC9YarHI1PKja4PUwZVrrJeZptH8FjYzexktCToEFkuH0FY/e3FtEvqSeVnThO+rKNPdnC+bdqb3RG3bvfKqp/GqfAdMZ9h7aPMSThiAYwLii8omgVfX67AQsvn4bjqiAh1xWL4OqdEH7axx30LapIivUAZjZr+K17SqUES6hNBgEdHRL3zEMx38SNs/ZnCYjUL78ci3lmtmSp6Gd/kJelbJqZYLHnoc3RTn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 21:42:36 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> +Cc David
> 
> On Sun, Nov 02, 2025 at 01:36:16PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > head:   97751db460a7c6988b2ab988d9889d4309f9cc8c
> > commit: 5b693a7ad2acfa88e8ab0a047335ea4c94fecdb1 [87/91] lib/base64: optimize base64_decode() with reverse lookup tables
> > config: m68k-randconfig-r123-20251102 (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/config)
> > compiler: m68k-linux-gcc (GCC) 14.3.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> > 
> > sparse warnings: (new ones prefixed by >>)  
> > >> lib/base64.c:36:28: sparse: sparse: Initializer entry defined twice  
> >    lib/base64.c:36:28: sparse:   also defined here
> >    lib/base64.c:37:25: sparse: sparse: Initializer entry defined twice
> >    lib/base64.c:37:25: sparse:   also defined here
> >   
> 
> I guess this warning is triggered because we first initialize the array
> with [0 ... 255] = -1, and then re-assign values for ['A'], ['a'],
> ['0'], as well as the 62nd and 63rd characters.
> 
> This approach was adopted based on David's suggestion [1] to improve
> readability by avoiding the expansion of the large 256 * 3 table.
> 
> I'm uncertain whether we should reconsider this method to avoid the
> warning, or if it's safe to ignore it in this case?

I was worried something might complain.
But any other initialiser makes it pretty easy to forget to initialise
one of the fields.
I don't know whether the code can be annotated to stop sparse complaining,
maybe sparse could be fixed to ignore a non-zero default initialiser.

The only other obvious initialiser is to pass in the values for "+-/_".
eg:
#define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
	[ 0 ... '+'-1 ] = -1, \
	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \ 
	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
	[ '9'+1 ... 'A'-1 ] = -1, \
	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
	[ 'Z'+1 ... '_'-1 ] = -1, \
	[ '_' ] = val_under, \
	[ '_'+1 ... 'a'-1 ] = -1, \
	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ 'z'+1 ... 255 ] = -1 \
}

Then have:
	static const s8 base64_rev_maps[][256] = {
		[BASE64_STD] = BASE64_REV_INIT(62, -1, -1, 63, -1),  
		[BASE64_URLSAFE] = BASE64_REV_INIT(-1, -1, 62, -1, 63),  
		[BASE64_IMAP] = BASE64_REV_INIT(62, 63, -1, -1, -1)
	};

But even that is error-prone, and doesn't really scale.

The static testing tools shouldn't really make coding error-prone.
So I'd definitely look for a way of stopping sparse complaining.

	David


> 
> [1]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/
> 
> Regards,
> Kuan-Wei
> 
> > vim +36 lib/base64.c
> > 
> >     33	
> >     34	static const s8 base64_rev_maps[][256] = {
> >     35		[BASE64_STD] = BASE64_REV_INIT('+', '/'),  
> >   > 36		[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),  
> >     37		[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> >     38	};
> >     39	/**
> >     40	 * base64_encode() - Base64-encode some binary data
> >     41	 * @src: the binary data to encode
> >     42	 * @srclen: the length of @src in bytes
> >     43	 * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
> >     44	 * @padding: whether to append '=' padding characters
> >     45	 * @variant: which base64 variant to use
> >     46	 *
> >     47	 * Encodes data using the selected Base64 variant.
> >     48	 *
> >     49	 * Return: the length of the resulting Base64-encoded string in bytes.
> >     50	 */
> >     51	int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
> >     52	{
> >     53		u32 ac = 0;
> >     54		int bits = 0;
> >     55		int i;
> >     56		char *cp = dst;
> >     57		const char *base64_table = base64_tables[variant];
> >     58	
> >     59		for (i = 0; i < srclen; i++) {
> >     60			ac = (ac << 8) | src[i];
> >     61			bits += 8;
> >     62			do {
> >     63				bits -= 6;
> >     64				*cp++ = base64_table[(ac >> bits) & 0x3f];
> >     65			} while (bits >= 6);
> >     66		}
> >     67		if (bits) {
> >     68			*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> >     69			bits -= 6;
> >     70		}
> >     71		if (padding) {
> >     72			while (bits < 0) {
> >     73				*cp++ = '=';
> >     74				bits += 2;
> >     75			}
> >     76		}
> >     77		return cp - dst;
> >     78	}
> >     79	EXPORT_SYMBOL_GPL(base64_encode);
> >     80	
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki  


