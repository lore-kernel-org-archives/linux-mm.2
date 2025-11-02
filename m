Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF66CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 13:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AD18E0005; Sun,  2 Nov 2025 08:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB418E0002; Sun,  2 Nov 2025 08:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB0B8E0005; Sun,  2 Nov 2025 08:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0538E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:42:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9A2112B945
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:42:43 +0000 (UTC)
X-FDA: 84065782206.11.D95FA54
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24F9C1C000C
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:42:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IS7WEgKd;
	spf=pass (imf20.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762090962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gO7NlorKZwi6OyYGVCcMlcZm+zfDgmVHpdXZK4TIm50=;
	b=XaAuBTesHUroflGiYpqPP0AKiedNSdW37/hLp8fQHic/O2kHz/yGD5+7E85SbC6a4eWCsI
	Q1B+xsV1zFFWi5UPQpPhI8tdu02s9HdMMnHXQfyuN4Zk8SW4UtgvQjDKDm9lMpYzmi3z/Z
	0w8SvQFKCfbxb0JR88hRCc2DqQ8lGHY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IS7WEgKd;
	spf=pass (imf20.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762090962; a=rsa-sha256;
	cv=none;
	b=lElrixMgKreOJ0Hk45muJNBjuiWfFHhntbIBleFyyt8TU/3QJfblYA1YSvjW2jI1/iIjfl
	uhTEyOzKBouLeXgUxQZFuL+xC1JMYdORyRanRLIL08/2ZN67G5mBr1PahAs8yGxGYXExPW
	h6W+0ZSuYuiUKepMEtWT2QR7N/khtDI=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so3406188b3a.2
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 05:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762090961; x=1762695761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gO7NlorKZwi6OyYGVCcMlcZm+zfDgmVHpdXZK4TIm50=;
        b=IS7WEgKd4F6sGl88Sr5KwsSpxh6KOXGLqijAmelbNvBbvaBJux99FvRv1t/GqdZhWG
         qACmVhupNofvKGXQ2u9CTS0DGNgp88FgFMNIuJNfleAYp+X7dZ6OuPcmFvGo53velaWr
         WNrbF4lkPXqskFAseq/vAwOObQXQ6PTF13o7kr+brEwqI2KJb5tkKgAm8hW03XpC5ZD1
         8HO3M1r0KknnGoXBx0B0OaXVfbhTxW7G2VQr9ohh9X3bB5GM4L8oHIGq+m16HhDJeD4C
         AH69f5CxLvKNOY2h/FySQFWLYlMwJuG79DKLu6kJTbxE91XNbbPinejmCBTAFVej8LrE
         VnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762090961; x=1762695761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gO7NlorKZwi6OyYGVCcMlcZm+zfDgmVHpdXZK4TIm50=;
        b=teIP74DlvTOnXT2UXxLqL7AE4PIB+L+K457V9nd04gAibDar+F04KHKLb5TyZYB/P3
         d13sYy95c9jF8s2tN/4eg3txlfwlqs5sf+mkkfqOBpvjLAKw2+swfCokp2+l1QCRCFTu
         rxXLtJ0AEwxoPq+LSmpPVeFUoHfkd2+ZifRfOsTyzUzrBcng8I7vJT0O2ErslcYa/oJe
         P8vosUTUb4IFa4hnjGMlp+ZtBAShTyPXL7aYw3A5ZfOxssqiFQyMP9VsVUv0XIxNtNkW
         h+5svLyKfF9EjAaeJN2j7m1bCm5TDv38N+sFDTTVOUnPABSJjtrNaPdfoBvG5Y/a2Bqz
         OVzg==
X-Forwarded-Encrypted: i=1; AJvYcCWBvxJX5Iy3HoztjZp/YPQCMGR0OAfgs7Ik1Naj3zKArlYCn4oniSqEy+5wLHj+jEM+aPBtjbu7gw==@kvack.org
X-Gm-Message-State: AOJu0YzFf3FeEoIHdTpEJBgVbIvzhBPtrD7Dqex0SXy8HRBCeX9Xd8Zz
	QGXPxgsomNnWNaijTSd5hgM6ap0ViR/4T9iBUY9YpniFNlLM2y0lioPU
X-Gm-Gg: ASbGncus/1xCX3qZYkd1Cnny4WvAn2HOWrBDSzIUv9jDUmONPgAMmJuytPwwsW+BhdJ
	j/3jQTJZyqWPWsRMtQm/mxvgutAEsWrgRds7qya5L25AOMJ6Ct9gzGcekBfFhmgtjalqFRvOzMA
	vK0KuEkDWMVk3fzbeCjCoE4FlI+tZh8h9NdTsuz6SdBHWFNH62lj7+RyOfz9jv3rMr/ROASWKz0
	tddmmTBTzUFrorQXWS4tUcrPqFtJtFUMqLm+rFK8gmidOr2tBtKuFCPKXuMc/ARZiaBzGuic5jL
	tOEOMYBUe3NaGwz89f9PsrMdiE7i4ET6UpcfbHt+W2vjfhDAWW0WSeUwpM7sDN3ePxnWpPhBeR1
	+kYCgL7Zlo3Qs2TpSz+In4ojq+jejR6E7gPneF0CPRopviZ8HsywOv5uQ8/3IR+aZ8I4QwYeLKD
	xRWQNYv8T1NyEsifMkdlghMXeDNe3x45qHlqFHfaKvsISlzcLfw5XkwYBR
X-Google-Smtp-Source: AGHT+IHdlKoMU5632pn4GfYLR+xsjg4vaTjWq2y1LHCLtrZP48xtBq0+y9hcaZi8ys6gnjEur/j+KQ==
X-Received: by 2002:a05:6a21:9998:b0:342:41fd:38e2 with SMTP id adf61e73a8af0-348cbda97afmr12398047637.30.1762090960905;
        Sun, 02 Nov 2025 05:42:40 -0800 (PST)
Received: from google.com (114-39-189-33.dynamic-ip.hinet.net. [114.39.189.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34050b56b0csm11456022a91.11.2025.11.02.05.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 05:42:40 -0800 (PST)
Date: Sun, 2 Nov 2025 21:42:36 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [akpm-mm:mm-nonmm-unstable 87/91] lib/base64.c:36:28: sparse:
 sparse: Initializer entry defined twice
Message-ID: <aQdfzCq2JH5QX9AH@google.com>
References: <202511021343.107utehN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511021343.107utehN-lkp@intel.com>
X-Stat-Signature: eancnm3575wz6qycz6qiruo1b1u95eor
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24F9C1C000C
X-HE-Tag: 1762090961-183951
X-HE-Meta: U2FsdGVkX1/bgxkgLoBppSyebESO6mi7ed6ijcD8vDawqz4OBk03qtdfexFPZRoQ8oynA5RNe9LgRlB86M9P18cS8rrlU1+fzZqv5DDJ3otFgo6ys52BEtFin0rvm3vXLAseO7A9UxQ1Z1OwCKu9RREeuADqL9k4XM+hogNVoGbgSmtjmtJnaLRn7UOuKmeMHjUhUtuDSrhByjKj1Tw/za6NOYTkXOETRz5yKXP7mD175CkxeNQ2giKClcCFKMaYYTDSyu68r3pr2oPLJJ73spGITx9FfsXiTMGMSE/gngfNxZ4Fy0vEUFOx42wTAKblAEjCcnibwQZ6GZF46sxmvv648N4Bj0gmlZZaOsCWvsYIQCOMx5Z37wo7mmB0Vw+Uo76rEPlkglnQoyGT5S3fqdjbVqwPpow+m+OBRWAkv26w9xWQn6eZhQitt5dWUhJRmvZXuGmFHeNjaD9WOKVSgWKR0SkxpsiQoUaCEGkX8KMtHjwR94c1nCA0b1VUl0y4Yn4ANG84YreMiq4q6F6mkycFvI4hwn1FvOucifN4iuKREdtww1WUMhy9827gUJCd9A1IpZJALlcFletoRM9uMdgTo2RTvZalK9JUVYYaDQSXDbkLe3lwLF4o2ML3s9OY/dqQYeb6nc/KOMEszUQmTgS5IGahcHH4nmCcqCAYx0oeciuSYjGWagDxNtRxuMT0B5+gwPwVUXoocZ2MgiUjKW9MOiibacp/FP4rzJxUyFJfoPgTpRs1O53DxaK6GBYI2vA+lhRlnyvLxGJhm4qAd03OTN8iOtKflhk33cmhL8miAEhZA6/crzJADxbGh6uU9hX8Detn4w6cci6+VzQiNvlUTpSCl3J/uKjuR5gtvvREeemTg4TbKZMs6XldDgwFTVlIosTpED2YT+q8NUZPARW3SKlqiXaYbbxUryu/OTnCeOeT/sx+OKcIMFL68mY1D2/H9GubEZa1AXJWJni
 wfVi+n3/
 Et3eSvh//yqskwbkYR6hLf33qDIIqyPLKg3OU2hdut0ND9wcv3nLrN2HUum5sIENjDXIR+uEH5B+uX78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc David

On Sun, Nov 02, 2025 at 01:36:16PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   97751db460a7c6988b2ab988d9889d4309f9cc8c
> commit: 5b693a7ad2acfa88e8ab0a047335ea4c94fecdb1 [87/91] lib/base64: optimize base64_decode() with reverse lookup tables
> config: m68k-randconfig-r123-20251102 (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 14.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> lib/base64.c:36:28: sparse: sparse: Initializer entry defined twice
>    lib/base64.c:36:28: sparse:   also defined here
>    lib/base64.c:37:25: sparse: sparse: Initializer entry defined twice
>    lib/base64.c:37:25: sparse:   also defined here
> 

I guess this warning is triggered because we first initialize the array
with [0 ... 255] = -1, and then re-assign values for ['A'], ['a'],
['0'], as well as the 62nd and 63rd characters.

This approach was adopted based on David's suggestion [1] to improve
readability by avoiding the expansion of the large 256 * 3 table.

I'm uncertain whether we should reconsider this method to avoid the
warning, or if it's safe to ignore it in this case?

[1]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/

Regards,
Kuan-Wei

> vim +36 lib/base64.c
> 
>     33	
>     34	static const s8 base64_rev_maps[][256] = {
>     35		[BASE64_STD] = BASE64_REV_INIT('+', '/'),
>   > 36		[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
>     37		[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
>     38	};
>     39	/**
>     40	 * base64_encode() - Base64-encode some binary data
>     41	 * @src: the binary data to encode
>     42	 * @srclen: the length of @src in bytes
>     43	 * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
>     44	 * @padding: whether to append '=' padding characters
>     45	 * @variant: which base64 variant to use
>     46	 *
>     47	 * Encodes data using the selected Base64 variant.
>     48	 *
>     49	 * Return: the length of the resulting Base64-encoded string in bytes.
>     50	 */
>     51	int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
>     52	{
>     53		u32 ac = 0;
>     54		int bits = 0;
>     55		int i;
>     56		char *cp = dst;
>     57		const char *base64_table = base64_tables[variant];
>     58	
>     59		for (i = 0; i < srclen; i++) {
>     60			ac = (ac << 8) | src[i];
>     61			bits += 8;
>     62			do {
>     63				bits -= 6;
>     64				*cp++ = base64_table[(ac >> bits) & 0x3f];
>     65			} while (bits >= 6);
>     66		}
>     67		if (bits) {
>     68			*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
>     69			bits -= 6;
>     70		}
>     71		if (padding) {
>     72			while (bits < 0) {
>     73				*cp++ = '=';
>     74				bits += 2;
>     75			}
>     76		}
>     77		return cp - dst;
>     78	}
>     79	EXPORT_SYMBOL_GPL(base64_encode);
>     80	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

