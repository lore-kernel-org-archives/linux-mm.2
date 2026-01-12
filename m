Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68185CF45D2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42D16B0005; Mon, 12 Jan 2026 16:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1056B0088; Mon, 12 Jan 2026 16:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AE16B008A; Mon, 12 Jan 2026 16:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 968C86B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:51:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52A381AF321
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:51:33 +0000 (UTC)
X-FDA: 84324658866.01.3EF3AB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id F0A3C1A0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:51:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2OtPHar;
	spf=pass (imf19.hostedemail.com: domain of bmasney@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768254691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG/xt+Zo6w++4JbumRD15X/stpwb03QCR9/DiPk31F0=;
	b=496owUM83fLquNiHnGHu30X73KWK6z1x3sKbIWfdlLLK1HfTvHb+PUNbBbCGN+S6QX6gI2
	K0/I+IAEzv1vN0IlSluJ839rIM+gTIWgKlVtCImNd3YbA0GZd2ozF5XyNJ4S0xN3BluttB
	oTFA0aZwbJfNqZexwxsWpo4X1fBj2g4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2OtPHar;
	spf=pass (imf19.hostedemail.com: domain of bmasney@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768254691; a=rsa-sha256;
	cv=none;
	b=3PppjYLqq6w691ABJShK63I//FLP1rmtTfoJshTYIKSglGjGoo5AmGavDA9XrBXzz2uwMN
	uquDbi8rcN/FBFT/WHtfK++9sQCDrWvE2OzEq3/1JmgWaXTGrOJlHOwkPgUy8SnGpoDQUw
	WwBp1/nFVdRytesfDq+6isbObWD7AKw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768254690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lG/xt+Zo6w++4JbumRD15X/stpwb03QCR9/DiPk31F0=;
	b=H2OtPHarThKRwAYf1v5f347cepcaySumsS9FK/ofr9lFfsYw6yCUytsibj+gcWNJjVUONE
	nPnIHH7iE8bkcPyLkyIaflM6bsPwM6Ov8kUq0A9aF0s7LZx8F2uu1sZbVQCFInAHi8JM+T
	5w6oqGVW6Mgvxa9bpLJIxj2kBUB4PaE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-hxU4ure4P12m3Ko0y6lmVA-1; Mon, 12 Jan 2026 16:51:27 -0500
X-MC-Unique: hxU4ure4P12m3Ko0y6lmVA-1
X-Mimecast-MFC-AGG-ID: hxU4ure4P12m3Ko0y6lmVA_1768254687
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b2dbd36752so1774530485a.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768254686; x=1768859486;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lG/xt+Zo6w++4JbumRD15X/stpwb03QCR9/DiPk31F0=;
        b=lU18NsgDkWNPvmY/RjX83hH8joCe6EAiXLQNZqc8UxGVzFnJ2eQ5kBbumZlYTo8Who
         BjVEbokrjcVMKr8TTLJJgY46kKhy6vrWyY4HiD2NTDLtH5k8KZ+WB4GlK0bh61+JB9N/
         /pUrFUbsNUxI1biWQ640ifc4SUd5FQgKgUEloCdI4bGGoGvjMryT/4/o61U5inHXpdOT
         Rv8leXlciLfNUzNk/8IAgd2oZJ2d9P85Oqj6Yox4bJmlNpcsJPwvSQKmI5QYfN2qsOAz
         cSo588q3ZaQ+u89gjIGg+fFGjZsCo2fDUfa/S3O+C6jNBWKittIyQlCc19OgnGhdd0tZ
         nBYw==
X-Forwarded-Encrypted: i=1; AJvYcCVAaLm1Kr6yPQQXulHKehYpMSVgZse4QSH2IznNINsn7tRT7uB9CAK+8Dosv8i4jo2tqy5OcsbkKQ==@kvack.org
X-Gm-Message-State: AOJu0YwPixw7kUu5oMAfAmI25MXVpn7Ls9IV634yt2+CPBwVQdobvmox
	npNh+/UCAgur88GJkl6LGxse06Y5EZcFyDpqqwMLUi9TjWkeHXCWZf2kevtqJ6mx6uyDHUre3RE
	e3AgajwFNbYPLwDTdr7WOHmnN+58PkdpgQzMMqPIILePzJPCbKs6U
X-Gm-Gg: AY/fxX7UVSt7OFMzZy4KxhDOirouY4+MMFd1mx2LwA/TWJN0tnbR7l4wwJbYBy6O9ay
	9P97ovOBsP1wqzYKORc/Eyma9K2Gurqs+arRyspCybYSjnme3dvsG2STCud60OTsjC+7j3Fe+t4
	yOQX8JWJKv2B4VHU+qneOdfl1F7UQuHIN6a4XbyfeskJA+YyTgJMktrClxf65IARn+4GVr/UW5L
	sjgEfF6PM0r57LhTDWFaqwq3mU6VU3mHHo8L8ykeE3aEIWzNIKdi6+yrnnJdDdBeVU+XkcWOaq6
	An8z2d3/MSpSM/pFaKv6WMDglr3j/kI8mZrbQBsjFDtanK8YNSs6rG0s+zF1rqinEms0AQi6OrZ
	QPKZNywmG
X-Received: by 2002:a05:620a:7101:b0:8b2:eb66:c64 with SMTP id af79cd13be357-8c38938daaemr2617950185a.29.1768254686487;
        Mon, 12 Jan 2026 13:51:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCkpe49S++VqEffSBOBVXTkUb2yNggyXQirptPBh8ES7ItwAnLFAB24ZEcsyfb77ysP4HDOw==
X-Received: by 2002:a05:620a:7101:b0:8b2:eb66:c64 with SMTP id af79cd13be357-8c38938daaemr2617947385a.29.1768254686087;
        Mon, 12 Jan 2026 13:51:26 -0800 (PST)
Received: from redhat.com ([2600:382:771e:5aa5:103f:e4ff:d734:7cd4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51ceb5sm1676840685a.35.2026.01.12.13.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 13:51:25 -0800 (PST)
Date: Mon, 12 Jan 2026 16:51:22 -0500
From: Brian Masney <bmasney@redhat.com>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <aWVs2gVB418WiMVa@redhat.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-31-david.laight.linux@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20251119224140.8616-31-david.laight.linux@gmail.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NpTlgvPhjdasjKEus9VKCQLpun8joUb3A6GEk9Dbxtc_1768254687
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0A3C1A0009
X-Stat-Signature: 6qh3z8c51y9biugscyxzdgizhian3qqd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768254690-729099
X-HE-Meta: U2FsdGVkX1/pfYnS6xJSW71IPMkeH1W1QwxOcLZe9L6m0Jzd9KrAlMFqyT8dLRBfMuAeqiBoGxlGT9rSoc9Hn/9++UWVGHHk6ba7whZ+c86bON0etgNuc9bEq7WDAnI84zBQp4jfgtISp3GynVioZmagdwhZrYct/XAts07Ksk3EH85QdSzE1kj99q8gG1elgE/KviiiAD+B9jDqlXg5TW0d2ts4tkI5q2GIFKbzMZBU71Ii9XC1B/+9+B/Mu7mK5utrncslljlfNuha7R8X/vC2oizsJZ92f22pnfL8oVEJKt+qwE9B3Wt2bQHb/Hah/TrYkqNrTmxCmGtbo6eEOwK3p0lhdwQZbLLKSrqncXY+2rv50ONdTPitsXq7PHNqFybuDL90M9AJpyNKF6yfmh6SURy5I1552oUJ0aD/4IRhSh6LQ4atsDm7Rl+8oJAVbOzP3kPoQYDoWN9/Eto5wB58HZmv6rOavDS4M1Y1EPpGdEPYs6rxLsOEXHymZCFwNqysIldYEgKcXl4PVopDKdX9esAk43t87s13dTciXT/fYQGK69JDmSV+qJomVCJ8OsJzL8/xPDkVo3f58v5tPQcHWW0/OTtVvc0ZgxZQGRWVu5Gvj96cmGJ445cLr4BvHtFobABNK/xSYPuOQF5SoyXGsGzZqvRw4rbSMnqaQNmIUtbVVI4HhpAtBMOYqyhEMheQKfaKhxBcn6iSTDEWfuMp70ldy0DfElhEi1v22gt1leyocOyejFAKYRVeiJsgyzLpikQz5FE+QM3JtGeSfefrNUShHQsO74OtMkdRaIEMsbBYiXocVIlqt0eXm5dkgJRF3E0zWZ/3KvtwUa8Tj66mGBebDXQWHHaAWFkrhj1IUXP3eZcKFuy5OWCr4MEqjVAFYz9NrykGsCHm3vqBG0fJTBWkHBbG8tGTqZV7KnviOe9vQoU7t8xPSTwJuiiGdiqYb/jeUcx3dJr/BjW
 u/28TjIX
 s2btZziMfhtBdxIDCAcSIxlkx13dsqwGKjlBsCIdlgCajG6OENERkSZXIQBZGJhs3tmFjU5ZezVU2saCzihwHudh3UZ82nMDwMkYKfdaFzoB4PT0A598p2jjRXP7MVE5Jq7tcV4+uPEGgapOXV+AGeDSjAab/GgRYEWikHxQ/+lOUxNbYszkf8Ce9AktO9B2mRfzAhZYQxnUjAoml5teFTZjnvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> and so cannot discard significant bits.
> 
> A couple of places need umin() because of loops like:
> 	nfolios = DIV_ROUND_UP(ret + start, PAGE_SIZE);
> 
> 	for (i = 0; i < nfolios; i++) {
> 		struct folio *folio = page_folio(pages[i]);
> 		...
> 		unsigned int len = umin(ret, PAGE_SIZE - start);
> 		...
> 		ret -= len;
> 		...
> 	}
> where the compiler doesn't track things well enough to know that
> 'ret' is never negative.
> 
> The alternate loop:
>         for (i = 0; ret > 0; i++) {
>                 struct folio *folio = page_folio(pages[i]);
>                 ...
>                 unsigned int len = min(ret, PAGE_SIZE - start);
>                 ...
>                 ret -= len;
>                 ...
>         }
> would be equivalent and doesn't need 'nfolios'.
> 
> Most of the 'unsigned long' actually come from PAGE_SIZE.
> 
> Detected by an extra check added to min_t().
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>

When doing a mips cross compile from an arm64 host
(via ARCH=mips CROSS_COMPILE=mips64-linux-gnu- make), the following
build error occurs in linux-next and goes away when I revert this
commit.

In file included from <command-line>:                                                                                               
In function ‘fuse_wr_pages’,                                                                                                        
    inlined from ‘fuse_perform_write’ at fs/fuse/file.c:1347:27:                                                                    
././include/linux/compiler_types.h:667:45: error: call to ‘__compiletime_assert_405’ declared with attribute error: min(((pos + len 
- 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error                                                                          
  667 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)                                             
      |                                             ^                                                                               
././include/linux/compiler_types.h:648:25: note: in definition of macro ‘__compiletime_assert’                                      
  648 |                         prefix ## suffix();                             \                                                   
      |                         ^~~~~~                                                                                              
././include/linux/compiler_types.h:667:9: note: in expansion of macro ‘_compiletime_assert’                                         
  667 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)                                             
      |         ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
./include/linux/minmax.h:93:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
   93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
      |         ^~~~~~~~~~~~~~~~
./include/linux/minmax.h:98:9: note: in expansion of macro ‘__careful_cmp_once’
   98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
      |         ^~~~~~~~~~~~~~~~~~
./include/linux/minmax.h:105:25: note: in expansion of macro ‘__careful_cmp’
  105 | #define min(x, y)       __careful_cmp(min, x, y)
      |                         ^~~~~~~~~~~~~
fs/fuse/file.c:1326:16: note: in expansion of macro ‘min’
 1326 |         return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE_SHIFT) + 1,
      |                ^~~

This is on a cento-stream-10 host running
gcc version 14.3.1 20250617 (Red Hat 14.3.1-2) (GCC). I didn't look into
this in detail, and I'm not entirely sure what the correct fix here
should be.

Brian


