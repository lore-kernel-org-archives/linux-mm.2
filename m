Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD6BCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0738A6B0088; Fri,  5 Jun 2026 01:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023636B008A; Fri,  5 Jun 2026 01:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BAF6B008C; Fri,  5 Jun 2026 01:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D80556B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:47:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90152A0366
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:47:05 +0000 (UTC)
X-FDA: 84844775610.19.56C2618
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F51140002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:47:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aaUJ4a39;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of error27@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780638423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjDrLfKQSx9/iTAOpM8mEBvBfa+kxAhmd9fKCaMvT60=;
	b=BTdI9XjGqCWpfP94Cx9U/rHQgkEe38IqLjQvASwap0yUUB+AS6/OiRSXg3QeeGb17do8eO
	rr7xd0nsabQjU+VflY/6EvR4orG+x8Ptx327bRF7r3iNiG+P6G99JqodAbGRSrw23a5Bks
	vo4lwZU7TSJhyIj8UuYvGTF24oDNi9M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aaUJ4a39;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of error27@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780638423;
	b=Fn6MVmiVqUqbQS8v6UD2IO+p00J1hCSRO0xK/8DwRI5UUlTv+og7r2ap79bv23fpQXTPey
	xzEo8EOcOscsLmMDk3S+zebm2BiaFJ3YcoukpUT72CAHyedJcXuTdDO7M1OqYsVuCYaZg2
	84gjIVJ0KWz8jmc+H7GwaBG9vgHOtFo=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49068493267so10743165e9.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 22:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780638422; x=1781243222; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDrLfKQSx9/iTAOpM8mEBvBfa+kxAhmd9fKCaMvT60=;
        b=aaUJ4a390nzd6Vx3GOIDWcAOlKTXvs1WpMATPXgTZBKf37APm1NpSf1ipzm6+2Dh7V
         NqEzxBsUPUNlbpdh6cbmVsNi7GRuFuzuJ/IfDQDKBZuj6jwUzhuHTdcOZ8CXe/AM9W6f
         Im7DTibNClomU9qfOXQCu4WcK+PasDofJr24uAWhXgCA+nudtR8+qfeWq2SlPQNtIRLP
         INqK4gqQxYm6KBsiOVIKg9HlUk9FBkXXsJ/Ihl/gVmYZcxmenR6UqdI36f0E1ECDYaWy
         l0tnmagZSvYg6NnLV0cbeW08YMJp7ViiLxAyz6V7v5my9ckZTexAWNLltXR6TIPGAjsB
         EHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780638422; x=1781243222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjDrLfKQSx9/iTAOpM8mEBvBfa+kxAhmd9fKCaMvT60=;
        b=WO0i7hbPjV8WRPt2TJ0O2DicNwDsMx3Dg/NMMZudXU23rTiVmNrXREvQg3CeApSEyk
         0/oAZSoOteXvFA/oW4hfkBjkHhwf7s8AALrALiLf+ty72W/13IGlyiETLrR1VGr0TRgu
         7zQNQQ/W8O7EpGP1nG/kMqVOcsYNpsXSFQNWDhp6pVP5wNMZkDXZxm1lV8X9veEDr0P+
         6Bnt4UXZhIXibYSXiIScLSqek+3K7yVkSbhpnPcQGF4L2vdGJwFB4tz7wzgET4oaIhK2
         gqQ/QjGaCPcQK5hNzUDiaNLiNyHBjYXtoMzJa4u6C399wFpqgmM3n29/MdkycV3Laemn
         ybpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+dKnn4jr6nTBcTKXOhBNSf33gV+rDq0vPiwqHAY9WfbdvFWmkz3/Qv0kbTtf8X9nJr8I7uLxAGmQ==@kvack.org
X-Gm-Message-State: AOJu0YygzTWZT+7CNzSdpk2tqnQ6ytr8Zh5wqycBY5ihlNO8eyj1jJKO
	3Sd/1GM+t30PqO0MD5P0UzoakDTewnluYYm1+KNwXwoI41Q7eMxqmAaK
X-Gm-Gg: Acq92OEa9lkatTbuns207atAQ8EaNraao5+vnKVRG0rs1JhKQ5vGPeUDRr6xINGxuJt
	3wLGhZRBBaVMh02QeveS/pR6XQrw8OoL/dRHDN1h5eqAwbsyGaVHgxTgRapXSIs2Y0b59bzOcpc
	vxzywTASCcQOdaUZThGYFrkzINLKCqVGRSAqgtuIYtufDr1AGrxQdairCPp2Z30VUabMRfcHFqz
	OJKchx1IUENuiA+FDKyZrli4SC0dgskzm5nkJRhEYsMNuzEtamg9U+x+E2wgoFsiVZmOC+pVAWo
	ZvHWXBtKQ8JAh/Yygu9tUP4OwgTS3YLDONosKPZdKMt5xzQXFsMtBwR7VcNoRUaR6ar2K2eGT2e
	xWW3o4zYYP5Eg78FLo/JNwcEPsR1JlFEr7CJ+mvnvnSfvjt/HTX2ajYlR7oeauWl1qA4YlbAYUO
	8jhoz+aTC52w4kO8ehOafqH+5gGVyvDg==
X-Received: by 2002:a05:600c:c493:b0:490:bb3e:30c2 with SMTP id 5b1f17b1804b1-490c25f1682mr28690675e9.18.1780638421991;
        Thu, 04 Jun 2026 22:47:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm21676813f8f.12.2026.06.04.22.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 22:47:01 -0700 (PDT)
Date: Fri, 5 Jun 2026 08:46:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <aiJi0WcYE8FZt-jO@stanley.mountain>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F51140002
X-Stat-Signature: 1uzwprhmftygkamqwfs59utaxckep9kc
X-Rspam-User: 
X-HE-Tag: 1780638423-513144
X-HE-Meta: U2FsdGVkX1+pFSpCZGBwB8wXdhX8+UHrWaNEpaActKMy9Z7mP+j4H098v58/wX0kNWugvYLrI644fmDBiI34LeE+6/7OTm/0EfmmLLa0CuHwwP9Qal2yI2WapBdOchT5dDuwx8el3fxDVEtmnSxd7O29jTSfiRP9G82ybYxeL5lnlGX5v2vbEuPm6DNxG0EY3E9SawSNLNHG8zLYnyM7xOVEcZIKRCvbx4HwdAyYZFsqkhuROAsztfGYVKUPANwDKeWhG5stU2tiZkKYT818jlGkHlGTEJYquBXEPgXJJsSaPJGfZ6LoZyPWEu3vN8mPDhPMCdZp85s+J51IzFIUd7ON5S3xJ+a6anBtshNu3iC2MncVndt7cKHD7QHZde+SjkOVKhpq5kN4hXu/pwaNeUNgUAU4mB9KjVMkk/9uvsgKBPFRTK+/Rnyoq263evx4PlCl4Pf9BM++K+TPtKGKKf97+YxITdfTaLtbz45nPfDD7cxYu+tMfwcKc3rdPv9wphChtdNdqiNPjCxaZLkRG0xaHqda5Bwk28fKQzdfHu4F6S0SXipk6bcMnudu8KQaZz/uWKCMdWg7qSydxcnS5yQBKugWit2A4rPx/W+2/BuoxT1O0Jt0xNcQVIqH2XaIEspy5qW7K6FII4LsXxO+1p+2Z4nrAqaXpB5l2KbfUKcuecI4Ui0/pHJOl2ERlyqO8U9B4wQ7nNa8U9quYtS7rTcy+7Qks+DyL/9XOwlZm4q6nxM0BBY+R99vF6O4OG1b8ylcwq5otnYz5vi8JaYjwKxm099MCsnFhXPEjrdxcAkdcWQpKy0lKtd+kWr64hOPRyOQ+LqjhfqoJ3CXXqWy5h7aON+CjiguIABx7KkDVqBiYLW8vXzoYkHnhcdpIUVye3SjyjaQEz8d2BJQdn7Bw/SH9/Q4odPALFdko82/FJtG37RJXBt3G/o08pPuFnKmrnge8JpMdquW8m9QFRX
 CzMBuIEc
 lC1nM7lbUb2oVpJdYJck0PoYCNUvttLfdt4gt/+QmnSnuKT/Y2f8Xal5KMLfWTmnk9spYeZCzXrnQqLO3G4nySO30m4mW9VPTt9iqiNT8mA+QgrKysxQm8cOV7vcI3cukSOFtMkFPVGMQ3XGWlGrQpEEjTXOuMQ9jxMSQpnQKdZ+W/y2lam7kvfcWuDRDYOmmEw/OSGBputn9+1SwqAAqOiLw8vbL+jBIDcrTb15cRz1JTZfpXXChdfBQ83uCReQzFOuttrMf+ntqnYJPWC0VbHi7TMsjtQEF0c4zSgWrLPCD5fB290wP+46YECXDLtzGP7CabE5oCQaCDcsOky5zwd7JxFfVkhBQDm9GznPj49yerUPAnpG57JvkNMl/0d6O0F0QFVCdqnkUvXFodheaLjdnvpquHwh1+bEDtWw0ZbHWq5IKb+buwkiaC9UL/vCYdvNDGA7PxEZRX3pyc5IQBVIwfVzJb5zV9+YQ0QfyzvewbOiYsBPI4PasRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:12:52AM +0000, Dmitry Ilvokhin wrote:
> Add __nonnull_args() to unconditional guard constructors so the compiler
> warns when NULL is statically known to be passed:
> 
> - DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
> - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> 
> DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> pointer arguments (.lock is hardcoded to (void *)1).
> 
> Define the __nonnull_args() macro in compiler_attributes.h, following
> the existing convention for attribute wrappers. Deliberately not named
> '__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
> userspace headers are combined (User Mode Linux for example).
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
> Miguel, I dropped your Acked-by due to the rename. Went with
> __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> spelling works for you.
> 

Sparse doesn't like an empty __nonnull_args() at all.

./include/linux/spinlock.h:608:1: error: an expression is expected before ')'
./include/linux/spinlock.h:619:1: error: an expression is expected before ')'
./include/linux/spinlock.h:631:1: error: an expression is expected before ')'

Shouldn't we specify the arguments which are non-NULL?
__nonnull_args(1)?

regards,
dan carpenter



