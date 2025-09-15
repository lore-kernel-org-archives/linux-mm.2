Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3DACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BBD8E0018; Mon, 15 Sep 2025 11:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CA18E0001; Mon, 15 Sep 2025 11:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1327B8E0018; Mon, 15 Sep 2025 11:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 028EB8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:43:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD56E11A5DE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:43:34 +0000 (UTC)
X-FDA: 83891904348.07.2517954
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0F3C180011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:43:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hn74nRZn;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757951012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4TpjbuEkSI9D7sI2TIuMaUkLm3RGFxmBSKlWPmE/RE=;
	b=5OREi7mFWDgjWYhwTKWcZ8a4J8VqVGdCg43Rq7XFhJIOBTBdpkshQoqg5jOcWcPRwXePAp
	QFb5khRW/GJwiyS0UkBBcg4XSwTICO3sLAsqBtKk+cgP07i1UAjFwshABcXe90uXYYsVLK
	TpcKBNfqTLpPn+7MOfo9aSsxMZVVO4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757951012; a=rsa-sha256;
	cv=none;
	b=bPdpFsMnaRNAQpswCYZgdK+Z5alpuXgk8xX4jl8KVYF51bGPm93k+6x28nH5lc8sWMQI/u
	N0XiAz3NqkvZhWZmx0SjzSheoW87kyAza8FMLKjSK4vHIAbJXC3E9dYcQR+vAeO4gSMJwj
	v57yfPSgMoOZm3ZKA32nhCHDhfGo+HE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hn74nRZn;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ebc706eb7bso437673f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757951011; x=1758555811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4TpjbuEkSI9D7sI2TIuMaUkLm3RGFxmBSKlWPmE/RE=;
        b=hn74nRZnhonWRc0kFSSgbl9ToFG/z6alX8ZlNOjhVjwpoSCnPd3TevfFiChDwyrCol
         wnFZdZ6s1rcDHdlWEwZJGs7Es3gJ9TccEJeYT+VfnFyzt5vHQ88sGIiXLebcHtyFx4Ll
         9+yii4e3b0Hr6pSk89EBS9BSENHTpW8UfyQxVfqbDDStlydF2V/giikVHdjWcLqyCBYj
         oTcgxynubbDNuuNBA6rGfxtBBxTA4Th0V9jeVVOMtb8xlD9NY/pKO8vghht0hfLry4w4
         hxJJeHjdf9OEXXfOSgxysc4Tb8zUQRGW7HpL4Bk7gBvzRBhwYvyHI5/Q7IyTv1fKxXn1
         RAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757951011; x=1758555811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4TpjbuEkSI9D7sI2TIuMaUkLm3RGFxmBSKlWPmE/RE=;
        b=oQ6jMjeloLBFTzxtfM66xgKApv90k2IAc3SN+GmPsEoDDtu6yZ2Y4uThaWZwZM2o8H
         zHbJHZJZpkeOQaTZKUK4fq6rKa5g3VLbRmktgNxcLcWG59xhzbTyG0uBGG50Kcg5pUK2
         uQMeb4SkASzX6+Fw89pGerqDC8Zyz8Xu3flhEW+IsfFJv529vZjlXKV1DYZRFVqWSjo7
         F77Jw81Ag1ky4M1fkWZhP0wM2z9H5yXgHF6y4Uas/PpKtblyzuX7mewbM5glMdI00CJb
         A01HpHTtiBQ/s+NX9TsR3Wo8M3ndFYksy0NfKAf4stNxqlmn+AqEEz5wzZi3xmfxp8O7
         2ugQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo9fyseywEIE0ArMMhDY8XtUqpyDHXsDqJQrrJpc226KEDkMfJxc2P83dCFG9eiDQgSoeICsfbYw==@kvack.org
X-Gm-Message-State: AOJu0YwLuwvZPTLDkNdHl/K8bvH8FCgewcrLxjv3KGIp/gQc53loHA6e
	ysDdssUQYCKVMlRmY44CgxY+3JGYdoaX6MgGSaM20rg4XqY8jwnsZhbc
X-Gm-Gg: ASbGnctOMPiw4IPrIS7BfvNNGdM1seIl9P4K+qjv+/cSnsBviHsZNCPSN/XYuSarCM8
	xFxEKwnC+2djMCSNw8AbtkP4wqChf32KdwIGBkctn8iUHC2UiZVD0wgEeEoWeXTMlmqzS1u8Bf3
	tOJUSdVoWCKke2YwsYgImWoj/KXBH0xnETzsASDH0nyUTpD/jmxivbWav+5qWRRBXoPQE0yCTu1
	exWDyLUqmrrtdY3qzkSglRX4LkO15p1U/WgmTuu76ENqr9bV/ufqnqpKPocKstUWMF4iFO5qbO5
	CwyQ/R89OCA8/bzINu1OEyw/u4wMTafEKR1dC2b0IDweVX0NfGdOevzQ258RUyTQ6myN6MLdvuD
	r6SOgirl4kdMcillDHiuBxIwrS9s4Jf4o5M/CtM3MeHiRF4oph3CXzJSxqMYMkbHZ9EpKe2nH6i
	BhHQS3uNqEPA==
X-Google-Smtp-Source: AGHT+IHo8rprzs2lnPAlHcfPi3gQ8kIkTHbVdYwaA2RYfhtKfLsiiB/E1MXC3I20/8ZIV3TcLzdQDw==
X-Received: by 2002:a05:6000:26c1:b0:3ea:ab6b:3873 with SMTP id ffacd0b85a97d-3eaab6b39damr2657222f8f.30.1757951010719;
        Mon, 15 Sep 2025 08:43:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f3105510csm5969895e9.6.2025.09.15.08.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:43:30 -0700 (PDT)
Date: Mon, 15 Sep 2025 16:43:13 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-mm@kvack.org, Kees Cook
 <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro
 <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] uaccess: Comment that copy to/from inatomic requires
 page fault disabled
Message-ID: <20250915164313.42644914@pumpkin>
In-Reply-To: <20250910161820.247f526a@gandalf.local.home>
References: <20250910161820.247f526a@gandalf.local.home>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0F3C180011
X-Stat-Signature: d55o7rf9a7kj3sb9exseoaehanzciwbw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757951012-755745
X-HE-Meta: U2FsdGVkX1+88gcH/a+NPZVe6EZJ0ORHCFNyhfcjxDWrW64VTtDSfvyXXq2DxHBOwYMl8mMwf67KFzNzgq0whfq46YDT5HpDIssT+8jXUlgMZA+qYfpB/dhyQTlZojpSVwsS0E8PBc817FD5XvkTrlTmVmVNZ2rvLfxNZM9Vdxg8xGkITA7K7E4mnDDvuxppkQNz8TFhoTCD3savOW91zFAre+0XdL8p7vDe9Jflu8hcIdYzjLkmjqaNEgf06dP40SLuPwK4Ws07tMvzZpobpI2ucEv77LKNVJk87oKdlA6PiFbC91wvbU0U/L+ZWihN/qa+mmBLkpSR/ir8gBpzmG88fWhgoztwOKxq2oSoLgAZ6W6KXRFIz6DWhU5j/1hg0c6DyKoDVfmCTbff82WfpIOjXrm1LAOaynLuqmFhBvTtH1j0IC3rj1/FcxlIpKMd3fh0t/QUVg4z3D8LnCPmrYH8CQcKd/8G3i4L1vATEKaZRWV8Chjt8E4G+kWOFmLHgVpGIe3OmkGrxz3qcnry3yqmPpLmB1c/q119Upgmu9lRMGm7i9j+r4RigzGavHhHjvKaDeIP4sb06RVA3CF5wqHnutwX4Z0iAh6oBM8Z8eeWuUHowltqkJYa3ZBe+a1ZOEqZ7jfMCRuLPeiZp4g/bZ26Rt1gWG4zE/MnpPInuxNJNMfEAwBealQCWmXndWoM2OAdNrEwdO3v8MPYr3xbBzIYmnhJ/kxaP5F98iqQ/fuyEV8Mqd432gR8okajyryHG+akt6eKBgIt+OBKgHasOXa6x80rzzURlcgj+OsroAC7pg6/4mZdVnS638X+JLL21I+s/tBM8jc6dRlP7r/nwqY6sLh8inmxPspUeH6cCclbt2eIjxi+LnCg3P5yGOeQXmmggEo2JuDfIKsRW4Yy/fjxngGFKmUxIS9P2qZsUtrnW0+A7qM56GCfhPTkr0gG4uPcINCMPt4tu4DHLQb
 abgbjK1W
 +AHeNxoirJOe2KTQ/b4gOQNghG7Y99l6A4aeLnjjE/YcSNkczGMQfJU4UxvF0Q8F/NV3V31NvIqlfZmGlsuQ/fUom3lAXVw3ilgCqKmXGvjQFGcQ1yp8XG3HZwbG1U0AD4XTA1kG7eu9V2KoTaofRBDrRd3L+1XEimmUcF8Jzg6yBwKlsftRs3YMk+0HmJnvAelsJqyqHJldofhbdd8+x8fUlFg3D6WICLDtyQPwP89deu1sBUuqdPXYUhwM07A8R1QXclgn0oM0SxXqctgsqdxGAYOo7iS15+5V/RMgHsOs7Y+jLOT5CSvb51ZiytffJiqv9zmjx32vYBAPqWXTDAPHy/G8zQQGNqhHkFyTO3uBG0q2c/YLg6VqYYXMzLliBbdugb4ErkXtL0ugeg7PLK/EY3HTPvHXDdF2sy+W/sWswaME2dCmCoXSEvUwvTYjEvRzAB+aceTdjSPz5w9t9O2avjOGtNSAz45xKpLte26lTNML1nNU6HigWqpwZTlMU/hahmeW12XRpLwS+LoOFEHLfEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 16:18:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The functions __copy_from_user_inatomic() and __copy_to_user_inatomic()
> both require that either the user space memory is pinned, or that page
> faults are disabled when they are called. If page faults are not disabled,
> and the memory is not present, the fault handling of reading or writing to
> that memory may cause the kernel to schedule. That would be bad in an
> atomic context.
> 
> Link: https://lore.kernel.org/all/20250819105152.2766363-1-luogengkun@huaweicloud.com/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/linux/uaccess.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 1beb5b395d81..add99fa9b656 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -86,6 +86,12 @@
>   * as usual) and both source and destination can trigger faults.
>   */
>  
> +/*
> + * __copy_from_user_inatomic() is safe to use in an atomic context but
> + * the user space memory must either be pinned in memory, or page faults
> + * must be disabled, otherwise the page fault handling may cause the function
> + * to schedule.
> + */
>  static __always_inline __must_check unsigned long
>  __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
>  {
> @@ -124,7 +130,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
>   * Copy data from kernel space to user space.  Caller must check
>   * the specified block with access_ok() before calling this function.
>   * The caller should also make sure he pins the user space address
> - * so that we don't result in page fault and sleep.
> + * or call page_fault_disable() so that we don't result in a page fault
> + * and sleep.

It is worse than that - it must avoid a COW fault as well.
I suspect the comment should really be that these are not the functions you
are looking for, you probably want the 'nofault' variants.

Even if the code thinks it has pinned the user buffer it has to be better
to use the 'nofault' variant.

The only exception might be in code that already has page faults disabled.
But even then it would have to be pretty performance critical for normal code.

	David  


>   */
>  static __always_inline __must_check unsigned long
>  __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)


