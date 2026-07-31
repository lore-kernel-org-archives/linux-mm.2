Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFA0C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC096B0092; Fri, 31 Jul 2026 13:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583ED6B0093; Fri, 31 Jul 2026 13:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499496B0098; Fri, 31 Jul 2026 13:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2F86B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 284CCA04F8
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:25:39 +0000 (UTC)
X-FDA: 85049748798.24.E9368FD
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4AB44A0013
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:25:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVJP8UHD;
	spf=pass (imf25.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785518737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVQMyDPxDTS6fwb+X3TMjpuyJAk3p59jQk9XwYz65a4=;
	b=1xD83nm8SpuJ6jtJGyEr1r68Ox18yn9zl4t+orVBtuw4+xRn8jwn0dbvwFHNra7GxGI+Dh
	8DDWDTPuggWL7nrQjO4aeXVFFYsl9R2+GTk1yxj0av3ExWdLeM5DsHrZP7rvtXvtgog4js
	M/FBGaOKLNHTR4Ldes46IbWDSZztDs0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785518737;
	b=hmUPaOsEj8+CemrEHgPLI/S8PcKLIQsN1gcrgGhXDlWSWEbHrF4nhnS73qPAOw9Uvup6dc
	95Ytps3WOS41tFRwVLFwdZhPsfR30mCUopRMb2cNuPU2RHs9AiiqMS/ybUfdIYeE+xhLLa
	Jf2rmTDKQVnKwabXph52+kP+1hz/tJY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVJP8UHD;
	spf=pass (imf25.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cacef7d299so2885ad.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785518736; cv=none;
        d=google.com; s=arc-20260327;
        b=XY4eBJp1oqQYrE/jSB9t7FcG1novWvImusnPBEwC90iC5HJ6bCUrWA8pOnuKBvfH0/
         rrzrSj6ZBqEMz2/ChMpdck4Qoee4AgejrMjsBshZuZUtTqe+5bhTOa4jQuLDJmEE4JbP
         vOC9W+9KGJuPOgKUxqsEUqYsmBiDqPoj67YzIlbJU4g3OEhAwNf99AGD+o7pmppD7Rc/
         6Vq3JRYaoq5gfOvdMlhz9YKilfy4D88Gvdt36XIpM+bpHSzptc6ZSokuCa7Hs999zuvp
         /+O3W6nLc8QjKLuG6Z1ssW6jyWBHrNBC4ffd4hhez7KTwV4vNtJDoMyqAKqTDaZO/CKy
         bsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jVQMyDPxDTS6fwb+X3TMjpuyJAk3p59jQk9XwYz65a4=;
        fh=4SlupNw5UXDMPdpi/JMX/bULL/XfKJFBQMM6NOI0p0g=;
        b=ZO1tYQmnyty02OAfNIn3qUmzgVSvEcXNzN4x/f9qXtsd0hoV44BHB/5SU+YhxkQbvQ
         yhLoC0SKZDXYAkMd3LktdnT/GI8iCmNvT9xS38LS6FwN9jJrnoue0gh5cfpIynaxJyeL
         UdlW8wG8uHSr7TuLkrI8+7usGuDvIqd/C3QxXC6XaLJGCKB97ud8XF5l3L0d/QY374dt
         k7cOs1rdP//tljzMRIZ3WZpD9VxZ9cIO7f4GYBXKh8pAB1dC6F3OcwUP3MpZmYPcbmj2
         j++vn4s6NzF1qmskjGhszyGqkFEvOM+tL58LzqhhpTiFwf4asHDSjd+qilIsAM269kCQ
         ZoIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785518736; x=1786123536; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVQMyDPxDTS6fwb+X3TMjpuyJAk3p59jQk9XwYz65a4=;
        b=lVJP8UHDbOfN5vq5eydKUh4DiFu3rKwV1eUX911b0zEMdW8FFrqgh7AjhCXcsB9Z6y
         xbUvvN9L7vT+2I2Yjuzvd8nIm/fknGa/4rd4QoOUyvpcZOP5YQVLFvLjVIumbtscAldJ
         GAuHaWhTjExYGvyJXeHhNzY7z5dteLlivscufG1rlAQ+1TutA8NsYTFNOioJpKT41EeZ
         CIe6Fb4CZ43hJR1fMCJwcKoR/CuULvlvWxbEnM8+u7IcOyD3T47Ib5lfGJxqpjBr9/G5
         kWBsOtvRD31qaccTeJGbnpA2dy2kLrOV9RgrTHM/f7Wt/CiUiaZsr9NUhsiXLpx2WN1B
         HtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518736; x=1786123536;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jVQMyDPxDTS6fwb+X3TMjpuyJAk3p59jQk9XwYz65a4=;
        b=mzePa1/SuiQluetQyghFi7s989ZqYrDbPYcNzhTvt7r3aXBL1oIRnb260K6WYNc2li
         dRj/kVj4jIER3uyzpnw3M1x6jCa2HbMK2ul4p2Kjyk6HwWzkpaSVrVwhVyc3QVFtvZ3e
         KRRMcX8P9IaBJ+WhulTeEZ6w52p3H8wqtVMACGLcKBhtekoOqbX2hW+R6YjBNvhgXyE3
         SIYl+LSVT+v227VbXtrEFk7OvFaWzk2mSpGqhDA/wfR3UTL51N7woxJSYtfgV3Nu+lF8
         O/ZrWeDzw5ln5DjhskWjuCv54zKyvJoCiJTaVol+Vu0naoSldbrI29CyR4OyHShNJ/y7
         ICoQ==
X-Forwarded-Encrypted: i=1; AHgh+RrZpm0x0bb6MnIw4PlV3J3S4o0DJJK6T/kDgS/9t3no/qjnqNWJ8lSG1XvI4UFzbkMblaNE8s+zLA==@kvack.org
X-Gm-Message-State: AOJu0YxH0xNhsmPJtxhpkXk90/ZKGCLWzJyymTwlPxjvMYhswKppoU14
	ixrd87e/YvBFu6rMoNZCK5itex4yte4uOodiBAMtJm/My5b/zbuKpBlhqqcESr4fksZ27vsE7Ng
	Mvn3RZMztAJU1rS2GE6xzQXuUd7lD/4pB0xFyarhM
X-Gm-Gg: AR+sD10Leqf0Tog6GbzyyU/QCAd0AM1jGYiVFgkkT7I9+UqUHRwkbfIbz6NiwSb4d4h
	4oJB4DksbrTN3VCBWXL22RwjkKxAFiqZYE2bGEOhFjgDK4h8mRukqP5IwVJj0aWKAwhAqXJT41A
	2t2UF3zJ0MnpR5EoY/ivUtyG6sVlNaLAnPkEZn3od5AKK1zNqPcF5qr1xdzTJ03MP+f0peaYOaE
	tYhAEdueUJq9fFzZhynYZtIerWMzMHu8uQVjq+XxC74WXv+h4RBhGQJYzXrWwXHXtMsnuHgaXxh
	niYFKAmo5jEicMjksf9KAfW9UqNnpfqvWto9Y5N+1Iv6j++AOVJuUAX5dPfzKa/003KtJl9m
X-Received: by 2002:a17:903:384c:b0:2b9:e831:5e5c with SMTP id
 d9443c01a7336-2d054694188mr204535ad.4.1785518735417; Fri, 31 Jul 2026
 10:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
 <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev>
In-Reply-To: <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Fri, 31 Jul 2026 10:25:24 -0700
X-Gm-Features: AUfX_myhN3HvpnSZA75M0vcKNhp1NwWoLudXYC4dn6MNqViceOHT-BCCP0o6lSg
Message-ID: <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4AB44A0013
X-Stat-Signature: rfrtkudaw35krdc7f771ym5wie1ko7io
X-Rspam-User: 
X-HE-Tag: 1785518737-539684
X-HE-Meta: U2FsdGVkX1/N7SmMHGRzUKQyjojN0S1P+uEaSx4m8IZzrBiqIQ0GqN4vdR4dcWDHprOCSxoL4L1d2JfEb2jVo3C+VbthBhdIHy2zrgOBtpL1emTPpqcm8MlxW/TBJP+xMQjBx36QevoW7zfYVbJFgouQoQiDqp23MsWYlJ+5pPRLbCE8UBSOIVmGcOBBm+rNapGootVzi5sfBSfAdJgt0XHam92S7eb9SegyptuvK01d5ONsWZ1MVarAlu6a6bdO9rYgf4D9KkI9hlE0wyvRmwkyV9WBKMSj73WjF7+0mrjCLYi7eolH/mZnB8w5asLYdPe3iFv0RmcZL6tG2GRxoeVY9wkHkivZYOH+XE1/PpnHT5EJjRWXIMKYoIGEkf6AwX5QlzMK1Zo94YeXBhtBEhDxAaI15asccOTobl0Zg3rZfKqlsQliCjV29VNVdUDqGTn2/qnZG7G+thjYzW9IWdUNCpmHwlGYjZl9k91/THCKn/KTxsi5MuLF7yZpiEW6TDDqhpZXGtptKulOo/UbdWwn9QDhSTrysHKbdo0t0P2PDsvAq834g/AfrhjjGC9a4B2hA0dCOlwiG0/l8ivcK05UIlH3IEW30Qc01yxzGwgC/7IYUZV93yzY3UW8KAlnv/AhwO01mv76r94vdNS9e5Cl1xPLiZlfAafcjPkqqN5nb8pls8pYqH39d2U0CjcWn0ApB5bpMW1iDlw17eVc8DMHaQfKW1hcwSuBCuDUPbSSzgY/Bmqyh6zh8MePCT9uB3cV8x/UEVuTn3NWDZLxgCn8pfNPDxtd1TXEePg4l0QxCXz49z3OW6p6BS4noPFSk4scRrJ2IlNX8nCjGF1a7oRsdqbYSGoZ7Ldkjoo/BZvv8je89gEMficmaW9CRegABEZ3LCGNN+AsGH+ohPulkij9Ec7WfrU8E4pkiMPXebToSVaYbziLFYwA0QMmxzZxMkNVP1+mOmqTvw6aVXm
 yiZU780T
 3NCPZshHOt5eTh5WbbzBSiJp3VrVb7KbT3qw9TysAx0qCGV+B4UMXngWY2ckhPjq0IntFP+5+o0xATLBdE13d+1dtew4SW2kUQhAWZGK9xJRRlsFKC9Jy5lCFrBumaCSlhiUYPkAw2UHsYHknpZGBQ/xRTM3lUPsTt9kpBPfXoBvHt0OPWYzcC/CvUHKWbcajTg60SLHpqUcEcLL9lo+OMzLZpVJ0nPU0b0pslqHYoQ8GcZWiA4YPHWs2BOLb6eVKIldU7UXx4No1YXnGR1jSPg31zx65r5AFv+2g61TFHfXL37uH+R/4wX6ciRNKOOdPBPP1/edB3tS4Hpa/epP9qZrL0mDfyodmztlRsAjoizA8G+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hao,

Thanks for reviewing the v2 patch.

>
> Hi Abhishek
>
>
> Thanks for the v2 patch.
>
>
> On 2026/7/31 07:48, Abhishek Bapat wrote:
> > Currently, userspace has limited visibility into the exact active
> > runtime state of memory allocation profiling and its page extension
> > compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').
> >
> > While reading the sysctl provides basic on/off status, it is currently
> > impossible for userspace to natively determine whether page-tag
> > compression was successfully enabled without scraping dmesg boot logs.
> >
> > Resolve this ambiguity by exposing the active compression state by
> > adding a new read-only sysctl `vm.memprofiling_compressed` to output the
> > state.
>
>
> I think this should be vm.mem_profiling_compressed.
>
> Otherwise, you will need to adjust the procname for this new sysctl
> accordingly.
>
> Also, kindly add docs at the linked path.
>
> https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm/allocation-profiling.rst#L33
>
>
Thanks for bringing this up, I didn't realize that I forgot the
underscore in the commit msg. I'll fix this in v3 and also add some
documentation about this.

> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   mm/alloc_tag.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 52aece27b00e..877068241f06 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
> >               .mode           = 0644,
> >               .proc_handler   = proc_mem_profiling_handler,
> >       },
> > +     {
> > +             .procname       = "mem_profiling_compressed",
> > +             .data           = &mem_profiling_compressed,
> > +             .mode           = 0444,
> > +             .proc_handler   = proc_do_static_key,
> > +     },
> >   };
> >
>
>
> I think adding this sysctl alone won't be enough.
>
> If we set boot arg sysctl.vm.mem_profiling=1,compressed but profiling
> gets disabled due to insufficient page flags,
>
> this sysctl will still report 1 (compression enabled) even though
> profiling was shut down.
>
> To verify this behavior, I have set up a test environment locally as
> shown below:
>
>
> [    0.265503] 4046 allocation tags cannot be references using 5
> available page flag bits. Memory allocation profiling is disabled!
>
> [root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
> 1
> [root@localhost ~]#
>
>
> I'm unsure whether we should initialize this sysctl when profiling gets
> disabled at boot.
> If we do, we should set mem_profiling_compressed to false in
> shutdown_mem_profiling.

I think the way it currently works is, compression can only be toggled
at boot time. The new sysctl my patch introduces is read-only. Based
on the current behaviour, if compression is enabled, and profiling is
toggled off and then on again, it will be toggled on with compression
enabled as long as we're in the same boot session. I don't want to
include changing this behaviour in the scope of this patch. I want to
limit the scope of this patch only to expose the current state to the
userspace, hope that makes sense.

>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
> >   static void __init sysctl_init(void)
> >
> > base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f

I'll also wait for Suren's comments before sending out a v3 patch.

Thanks,
Abhishek.

