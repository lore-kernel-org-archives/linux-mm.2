Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93A6CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 14:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6578E0007; Sun,  2 Nov 2025 09:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66FC8E0002; Sun,  2 Nov 2025 09:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D2F8E0007; Sun,  2 Nov 2025 09:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C158C8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 09:57:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F8FA12BB49
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 14:57:50 +0000 (UTC)
X-FDA: 84065971500.21.B7804A0
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C5E6C0008
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 14:57:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VeH9R3IQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=visitorckw@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762095468; a=rsa-sha256;
	cv=none;
	b=lw6ulssisp49crZjGGwoXWBEmb7YyM8eRgsY2Xwms2Ok+Ea1LwO6Ar8E4v97VmkU3U2FES
	0ELWJDWYgChyskUaTpF0WxwQdfN35xoU+fXRRPPg130xcNkRm93MIpxsnmWSMkRVmmq1Re
	J8shNfwj0jl2t8qf4HwP1m3ytbCY8V0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VeH9R3IQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=visitorckw@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762095468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW+evJrk5p1TwCCxbQG/bGH1p9PSRSCoapL/P+6NYsg=;
	b=4DVSee8sJOj8POuLwTDXknAaAaKMidpSmpaPs6fgvX2n/kGSxJ4SouMkhv7KfS0rd/QRWj
	821dgnhy2Vn+dzTuXHIuL3gzp/toXwWvinLB6+CwjHVh/cs80kkWZ793PkV61FM6j4+Cfl
	V8aeREgfOBaA50cxotRdGAKtyJ7wr1s=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a74b13f4f8so2494023b3a.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 06:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762095467; x=1762700267; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EW+evJrk5p1TwCCxbQG/bGH1p9PSRSCoapL/P+6NYsg=;
        b=VeH9R3IQwMUBOqFhKVc7S5hE+mjJa1uXt+CrmMKSmi+WvWQXhLsrXAyOuqOHdXPRQF
         bAWXBsuxxSa0nXaquTjTttIQIVdruubOnJLULg8LzYdkzmIN/Lvp+kX5cdnJWwZ+IOBt
         dgAs3styyR0gQCFZsrQ28hKeyzIY9dJ8SpnxwJV04ZaoAn52yvTF2CiQkgbRqkmcEW2M
         kRtJY3OAj/SMQGFl6hA8FpTH6DVpksoMMlkNOOlt76x8Ion8tiCU38HD5525sRLZwVR3
         Dv3hg0lWRiRYs/9LaKGUrReHlsmu1aJDEffvwt5P2cbJP82vI/s2ASval8JlNtOM69b/
         y7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762095467; x=1762700267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EW+evJrk5p1TwCCxbQG/bGH1p9PSRSCoapL/P+6NYsg=;
        b=bo4PZHcRIwarRdpEt08wzWPvXkZpxoXY9Cnge8voIN/UqJM7nMBwSPx8ubMVdP/25V
         MV8lhJD5ws4csxhBoSjLNK2AXprlbhXer043khJtaHmL6Pose9BG3CF34mWnnXW7TjI+
         p622Uaov71kak3JVuFqQIsUSg5gQGWnVaVjuUHEIM9apnIAWH9eh41fh4kuqdBWuMHfi
         OC0tTBx87j8T03mp6/w/1Oth0dCcm7F5ACRlZjER4X3EvwraRx5mjkbiM5j8BWUOrX+y
         IJbCOLP0TH16OUOw6nMEMFJ+TgQpZl0QcbDE5cSxtHlkBEkeoJxG/QueLU1feJgevitV
         b5xg==
X-Forwarded-Encrypted: i=1; AJvYcCU7iJot1UQnaVGgFBZN1UblZ6yewno3MlyGjr2YSDBXBZ+mDJGmL8l5fKNOuz9BqRKjpRWLSBkClQ==@kvack.org
X-Gm-Message-State: AOJu0YzRV+Sso9/7P7M30ZGe2gqmK8KqSPy7YkJ0eCz4ScwCXB7Eo9X3
	FcyOeKl9AiIlF1LUbmFDxKB0g7aJtRmhRkgycIG56/viDiiNoQFILa4y
X-Gm-Gg: ASbGncuN4atPTrFkMjpkX5OPIYnezmUGpD2dk1JeEagKZ6/0V/gFNVaS9DrfXyNmWqW
	Ym981l0nK7Z9QgXQ0xf1vCjhReZdGUk1cZ4qKYa0Z8oxITAJb10grtgzNJpKdvxyy81qZbTP+1E
	xNCpWEyrQju2Q0WrjCsG10zmsqaZGt4r/NYYCGLJKkIqYXYGm3IWcmwMuNqBbpmCAcVhG/VYR9s
	SpGfrrxOkFbrnCYfvDAOYiRzULyqvcsA0G4H3MobQlhhAGwj428CG2hZcbLWD4j8JycQ1TLf8qg
	Xk8kV5JBVbXT7PNmOopYAQB1IhODWoL3pzct7YVw5cA/kTiXC2A2J/kqtXA5Fli0xjWqObc5iS+
	UVG6wvwUpLRPKpI44dGWZin3A6kBs7YO5oNBc1Nkr3FRQ90uXMj05IN73p3mFTq+Rd9+wwsTp5E
	Ac0rh9aZ+eOHfM3PGWo0kOFZrLWw8XWV7dBHs4laH5+relhtQISJs2SZsYaQEm0RvmnS4=
X-Google-Smtp-Source: AGHT+IFU2DNnYwsIyV4r7s9YtpZ7QQ1tNNIWx6HST/ojw1e0uIZWMRFwK+HdG4jzTgIZNpdYhvzBag==
X-Received: by 2002:a17:903:2441:b0:295:28a4:f0aa with SMTP id d9443c01a7336-29528a4f2a9mr121037185ad.43.1762095467244;
        Sun, 02 Nov 2025 06:57:47 -0800 (PST)
Received: from google.com (114-39-189-33.dynamic-ip.hinet.net. [114.39.189.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29556d61d85sm54355065ad.68.2025.11.02.06.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 06:57:46 -0800 (PST)
Date: Sun, 2 Nov 2025 22:57:43 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: David Laight <david.laight.linux@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: Re: [akpm-mm:mm-nonmm-unstable 87/91] lib/base64.c:36:28: sparse:
 sparse: Initializer entry defined twice
Message-ID: <aQdxZ_bmyfWTEvW2@google.com>
References: <202511021343.107utehN-lkp@intel.com>
 <aQdfzCq2JH5QX9AH@google.com>
 <20251102144251.7f0fa78c@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102144251.7f0fa78c@pumpkin>
X-Stat-Signature: 3zg11wf1b8puz3gpqprrnbxsfiz4zt39
X-Rspamd-Queue-Id: 8C5E6C0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762095468-388364
X-HE-Meta: U2FsdGVkX19cswrn/NiG/EJueT/lacRURaTebi2MPd62vB7UWhCRgJy2du0NYUj46UTkjZAPPJcm1bK11/WkKYMCKAX2RBEiBIIw1+i/hlSNXnfvn9a3UFq8Mr+05fftI6fuIPFuXvjO+aDULAYq+AwKqkh1VeDDt9s7VhzRElpBpDyvi2qklpwKgg/Y4yPWlR0YgySvJ8HVaicSJuQDDBm3U3NNXlaJYGsNOQfHpa2m3DY/aTyhzO3U+6NG2czfayf+j3ESJO+M/dl4Po3qAVv8jdGRokpb8LJdJgUYtVCJQHjn1rpN7Tp7bTa70ZvpVugpvs3n1U66K9cvS4f0hdvQK1IYC2VGsW6Jg7ErZbTEf5RkoEVpey2qJz9JbqS4CMQEjNGLBWO8KeIHkOZxXs0VrhfJFE3D3zYjfHK6O+v36ZNWEF/OXPBH68UiLe4cbaXa9cbd4TyUoS17G0WUZDEYhvvbQRjjr64g9c+VLvotKtrrk2DlNzaNC+A3YsUlSBkvdyuLO4GHRdQk7DRMLclPe7jx5xDqt+yM/lYjgZ2VvE8wMaXHGAxuzmXdziSjCIyatuEcSMmXHgLzaC4UIefp3DYlR35SHnSrik4wJyC3prbYrn85BxD0elxkTiGKiYM5zEIqXyZtJ4GFoW7KqSF9KbQ0eGSqOUXa/2BuMseBnd3ReqL1/5my7921mB0eEWaobwTfInxgJm/HkeReT/J4IhVPP6B18vvn0Dus8lbbCWnSqp2NNgyRQs2Q5bG1hTqMaKxwTiBpBr8VHOAxkSAzTtM0mcI1OMnHrB6y5/tfOHl6TeH7ZiwDARJ9Cczz7MX6ztCgcOY8c0O56jppRj9dCXs787/JAxL34v3HLYM8cb8FUwKvcIBsUH5/g4+ToTE4qVEhNXiHKFYJ2bRe0zKQeDcNM9gJKsfiFPRZeSmF6sSGinByZfFRj3Xwq/kphT/d18Y1Wc8ASRVcV/L
 1VyyW5tI
 QBj1UjqvIdTQqN0if01oN1j5oQMYkYZrkeAeCf9S32ZaewZuJUWW1kaAGO3g2UZmJ9qLOjTHMMeBUQYMqsngzHgSRWxtwY+D4EK3v+PCS5RE98VuGKago1uLJwSzOjnL7qHaCglEOD/85YR4APFMF8AZjoc6a5aKEOiX+8I7ajklh6q2kcpHTBW+nHqCTYrIW2WVTXQ5fyaNE+ri1yQ9+ErIE7bzjFIylbunLh20gpoWgMyd5Rqj3wTqh/FIIogHBh2GeS90ypNmz3hIxP4jiQNIYEvLJaT1CNagnxtnXtmGx4Z++IdoQUoGPELnBBrf1bXXj6YCGegV+IrSKZYNjOrKkayHATMaPhXtxQ7QMgt9RnbQvUX+5azvvJJTvjYiE46b3ys44ubJYrRkyyxT3UHIBzfCymgdkHid4y4QHH36clyboA+yIinAfWCzHSdYcYxryWdiymeoKyoVKq65HxT39JH2VZpP4jV6Zs8mwTIFWykowq63eW4NZcJ5UYRqSX8Fnsdwj3gPax1qZphPnSzDhzv8NjJd3saFym2oIUaLro2fiIpK4omgSJyGHnM/GXg8Khsrf6IrZnUauMRWuVOXqVvdn2vPyy2yFksKY6QTZ9vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Luc Van Oostenryck for sparse discussion

On Sun, Nov 02, 2025 at 02:42:51PM +0000, David Laight wrote:
> On Sun, 2 Nov 2025 21:42:36 +0800
> Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > +Cc David
> > 
> > On Sun, Nov 02, 2025 at 01:36:16PM +0800, kernel test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > > head:   97751db460a7c6988b2ab988d9889d4309f9cc8c
> > > commit: 5b693a7ad2acfa88e8ab0a047335ea4c94fecdb1 [87/91] lib/base64: optimize base64_decode() with reverse lookup tables
> > > config: m68k-randconfig-r123-20251102 (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/config)
> > > compiler: m68k-linux-gcc (GCC) 14.3.0
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> > > 
> > > sparse warnings: (new ones prefixed by >>)  
> > > >> lib/base64.c:36:28: sparse: sparse: Initializer entry defined twice  
> > >    lib/base64.c:36:28: sparse:   also defined here
> > >    lib/base64.c:37:25: sparse: sparse: Initializer entry defined twice
> > >    lib/base64.c:37:25: sparse:   also defined here
> > >   
> > 
> > I guess this warning is triggered because we first initialize the array
> > with [0 ... 255] = -1, and then re-assign values for ['A'], ['a'],
> > ['0'], as well as the 62nd and 63rd characters.
> > 
> > This approach was adopted based on David's suggestion [1] to improve
> > readability by avoiding the expansion of the large 256 * 3 table.
> > 
> > I'm uncertain whether we should reconsider this method to avoid the
> > warning, or if it's safe to ignore it in this case?
> 
> I was worried something might complain.
> But any other initialiser makes it pretty easy to forget to initialise
> one of the fields.
> I don't know whether the code can be annotated to stop sparse complaining,
> maybe sparse could be fixed to ignore a non-zero default initialiser.
> 
> The only other obvious initialiser is to pass in the values for "+-/_".
> eg:
> #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> 	[ 0 ... '+'-1 ] = -1, \
> 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \ 
> 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> 	[ '9'+1 ... 'A'-1 ] = -1, \
> 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> 	[ 'Z'+1 ... '_'-1 ] = -1, \
> 	[ '_' ] = val_under, \
> 	[ '_'+1 ... 'a'-1 ] = -1, \
> 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> 	[ 'z'+1 ... 255 ] = -1 \
> }
> 
> Then have:
> 	static const s8 base64_rev_maps[][256] = {
> 		[BASE64_STD] = BASE64_REV_INIT(62, -1, -1, 63, -1),  
> 		[BASE64_URLSAFE] = BASE64_REV_INIT(-1, -1, 62, -1, 63),  
> 		[BASE64_IMAP] = BASE64_REV_INIT(62, 63, -1, -1, -1)
> 	};
> 
> But even that is error-prone, and doesn't really scale.
> 
> The static testing tools shouldn't really make coding error-prone.
> So I'd definitely look for a way of stopping sparse complaining.
> 

I also think the current code is more readable and less error-prone.
I'll loop in Luc to see if he has any feedback or thoughts on this.

Regards,
Kuan-Wei

> 	David
> 
> 
> > 
> > [1]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/
> > 
> > Regards,
> > Kuan-Wei
> > 
> > > vim +36 lib/base64.c
> > > 
> > >     33	
> > >     34	static const s8 base64_rev_maps[][256] = {
> > >     35		[BASE64_STD] = BASE64_REV_INIT('+', '/'),  
> > >   > 36		[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),  
> > >     37		[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> > >     38	};
> > >     39	/**
> > >     40	 * base64_encode() - Base64-encode some binary data
> > >     41	 * @src: the binary data to encode
> > >     42	 * @srclen: the length of @src in bytes
> > >     43	 * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
> > >     44	 * @padding: whether to append '=' padding characters
> > >     45	 * @variant: which base64 variant to use
> > >     46	 *
> > >     47	 * Encodes data using the selected Base64 variant.
> > >     48	 *
> > >     49	 * Return: the length of the resulting Base64-encoded string in bytes.
> > >     50	 */
> > >     51	int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
> > >     52	{
> > >     53		u32 ac = 0;
> > >     54		int bits = 0;
> > >     55		int i;
> > >     56		char *cp = dst;
> > >     57		const char *base64_table = base64_tables[variant];
> > >     58	
> > >     59		for (i = 0; i < srclen; i++) {
> > >     60			ac = (ac << 8) | src[i];
> > >     61			bits += 8;
> > >     62			do {
> > >     63				bits -= 6;
> > >     64				*cp++ = base64_table[(ac >> bits) & 0x3f];
> > >     65			} while (bits >= 6);
> > >     66		}
> > >     67		if (bits) {
> > >     68			*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > >     69			bits -= 6;
> > >     70		}
> > >     71		if (padding) {
> > >     72			while (bits < 0) {
> > >     73				*cp++ = '=';
> > >     74				bits += 2;
> > >     75			}
> > >     76		}
> > >     77		return cp - dst;
> > >     78	}
> > >     79	EXPORT_SYMBOL_GPL(base64_encode);
> > >     80	
> > > 
> > > -- 
> > > 0-DAY CI Kernel Test Service
> > > https://github.com/intel/lkp-tests/wiki  
> 

