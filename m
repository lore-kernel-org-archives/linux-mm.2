Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BA5F327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BBB86B008C; Tue, 21 Apr 2026 02:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245D06B0098; Tue, 21 Apr 2026 02:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DB76B009B; Tue, 21 Apr 2026 02:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F06B06B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:49:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9535D13C1AB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:49:16 +0000 (UTC)
X-FDA: 84681636312.19.28CF577
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id B18F4160003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:49:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A3CwKDs0;
	spf=pass (imf08.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776754154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdNywBu7apdyTFV9cnt3GZxXLndr1pBULjY0WptzCm8=;
	b=V+FRt7aDFYyUL1YfZPgdm+Nbxd16exiSmMXDlFBmQQDhcnDfzejEfbUjqScLnIcZw7c54A
	9xFhttw+wK1E+WqmyeYXak+E5AxnYdCFdtrctDuiU7+Ywl8GdAaZfGIotjb+C0A6WJ0MVp
	7SJ4mQAf9II3QCoYUj94elbKAA5DM6s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A3CwKDs0;
	spf=pass (imf08.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776754154; a=rsa-sha256;
	cv=none;
	b=0hh+I2XffbxYqJ5isM36+HuxXPSde2XwA0eSbad1dgndM2V33ABrG+kbuu73kx1FkTOqhQ
	BWVNCaqNxQ3FVsIj5VX2R8MsLddtyhadla1F8l8XQiYMPdFCTk24EU4gCT3zfBclot5uKY
	6UJYH7Bv3/uEFCBszwSSFffW+3whv/M=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so2678085a91.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776754153; x=1777358953; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdNywBu7apdyTFV9cnt3GZxXLndr1pBULjY0WptzCm8=;
        b=A3CwKDs0wxf8hvO+C6mhRYzQEGsY3iWU61mJecGiXw846Uoi/CWaytzC2QerpXafgy
         zf4mvvi8zmEJSm/e2m8SzTcjaT3azzffvj2nxKhsZh2WHfHJ7GjmAy2Sm25ofgDNqql+
         +LtqyKyreD+TSpvLjKMp0GTfbjwjSIwQLbMFYqxUKw/BxEl6AnS9l4ipbm+mV4z9yL1V
         IPH8nCaZ8M2qkjgRUKZH6iAgytqHIcsDDDWnvwG4ojeXGMwmsIpYE8p/CJyP7rLpbqXH
         O3sASLRqEI8QgPKXMXHVI8RrT5CSQQHEUyiAZNU0V9PVNpF8X86sPxa/yWi+LNH9d1OZ
         m3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776754153; x=1777358953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VdNywBu7apdyTFV9cnt3GZxXLndr1pBULjY0WptzCm8=;
        b=QHWBAq9BWAUh3yyN6oXKxQIt0NX28zjMrhWZWCrcMXYUs5zOtF5KNO4+vGHrZGGOSR
         n6ZPwLJDmfdk28cTDAMVkwav5kfEJx7ImdsvEhBVQYBgljLqta+h5neDMN4Ue0K5mIJh
         fL6zGQq+KfeX1z6nMWjrhuxkznGHJfGTP4dpiupGcOIhw57eJcNqdthYlHB2sjVHExtS
         2PlEaod731/xpPsIkC/I2zKTZD4u69xSSQA+6liTgdAWsJnELZg1XWhOJOw/zhu84Ncb
         OJSOP1C/bq1j5w//qN6Yzmqti/Xk6ZchhTUUuWB+WtxXRTC4LODFcab96rkLlZUZcWtt
         Y34w==
X-Forwarded-Encrypted: i=1; AFNElJ8EfZ554iuEJGCl7DP6T7d92sdotabebQnACfEzJHrE5EM1PJafJOIwkUG5UuULjXATRECIHMlKvQ==@kvack.org
X-Gm-Message-State: AOJu0YzUH18wG/o6d5hlsgXSBfRc36BC9wO2cZIy9rwqISKH45xU/o46
	qUie3DrZeQhdVPe4IAg3HYDI1qs61ru36xzdUgDVsrfU8lYZvq3QBgP+
X-Gm-Gg: AeBDieshrmCNeLwArjl+2GRVNbrdPOUG1x4f3Qp0jz1VGwQeWpR9beH9U666kkFGki3
	MeIO8RoHlKPiq94LCWEkh9CZmUcsoVNi5JGpw5KQ0JXZIjAYtJxRCiuHKsPqTcskm7zTP8sPXaJ
	BOJbrHG1WoDFumehbH8gmntLL/QUaPYSkI79DOINgoCc714FnmRdmNIQEfzapOE7cBdf54yVM/S
	WoXFH+L7rqShWewDwn3KiCwG4ftPmOUgxIBd1+35/CEgZYYjKIgJTBzwYNMdBVy5vhg23Z00evt
	uLlkEtAxfcZU1Ix+oTgs+0yyT9eSzguK12q5aLyLP6ue1Y2kJsv8S012gCSyXR11D1UuylgRCwC
	1oFcjyHWKMfHAtR2BllqPNZPgU9/NjP1LKlGI+B2qliGhZY5Gwme2/BY2+0R8iLdtBqWOtPD7sX
	IpL395EQmjlCfqSrCEftitGHnvTNMyWuiZzDa/ZGsf2nth4b303T0QgRAym73hRmrugnTRXP4OF
	od4IF6tUDk+Eifi
X-Received: by 2002:a17:90a:dfd0:b0:35e:30bc:96ed with SMTP id 98e67ed59e1d1-36140402361mr16891174a91.10.1776754153374;
        Mon, 20 Apr 2026 23:49:13 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614195a8f0sm12278674a91.12.2026.04.20.23.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:49:13 -0700 (PDT)
Date: Tue, 21 Apr 2026 12:18:55 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>, 
	x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, 
	Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, Paul Walmsley <pjw@kernel.org>, 
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 32/38] powerpc/spufs: Use mftb() directly
Message-ID: <aecdpyvTLJOjCdFp@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.723429844@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120319.723429844@kernel.org>
X-Stat-Signature: qx317edcpatxg44fmam78ibrwdb7qzz9
X-Rspamd-Queue-Id: B18F4160003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776754154-895145
X-HE-Meta: U2FsdGVkX1/4SyifaJkmTVdC/GRm0nDpR9oMsAA8H54SSBEnpNDfpEUf812DTMP1BbQJUY3X8w02Jw84cXZlmiNZmslsx4cevLfy9T3RAaREdE8we9Q3j45aLpuyI4Jcwak9qnu3BLbD7UpKccOx8CvwWJW7wFstGNTTpEXSqyiTGUjnKMk+f1+d5nveFZDl6Kd5frGCv6m0JRC6LpP1Kd/jWBlcHU3ISDUFxI0foJ85zdazqAqxOzv3kv6aLK4Z6tlzbpkpIICSaJyP5USkYdiETaAXiHYVUm0Ca5ycnnOoNW8UqJaqMVNzBx4/AiJ0+LVz9scqOqw3CSh9Qq8TV0LZDsfpatc31d5Tc9+/UBsZERZiPmNboKuRhFS2TZ0ZrJBYuAzYae/KkwpWVKd83aI+O8hFvC41uWBvrzzyLGE0OnL4Ol+VYtvrR3x5dFOMEZ8DxqTRT5RVklXGUt9Ygs6J9e9iaIbMff5QAUWO7P+RXs/HlkdJ2+mZzR5qn3PP+uPfIbhrP8Fo8Ye/2qm26qRMRl5vu77cztjoXpLFBlIctU/l0Bazr5xwLotsZWIiH0HO7cnXiF4IOvCJU7WkF/rNoqtY2tZNJZzpx1jLoGoxwgiLzbqMqdML7pDHy81WHsMglJL8TNz9thT4Cxo/zjr9WBErpTY9GMsS35NjxvO2gQ+4BkNvloTLFkPvveaTx00EUL117iMPxsQgi40o8j8yKEm1jUmKCM3woeQENNVsvvnl5hig0bTmw+bTjBqGF3+tvaQll5qAIhjfIutOvHv7DpEuvHGDWKtB0a3HTkDz+tmLLlpKHNYBDgsFZ6eiiCnRJ/CStiz153S0OBIJ4UxYHvYTKxSAYfSx7G9Rb6gjQosT0M0Al1oZHkbaV/nTtpsnD5oa9ZmgwRyaWatp6z3TguhcyrmEX0662R3z6t+37pY5AJjvxI7KT6/OldySbbgDBL4uMFp0EQg5R5q
 rtKq+SWB
 Fk/n/DiWqedhlzotmpufGmaq4Ow4bijuQmRz75+YepIqtx6GmqHplny/UIBI72R2izjvQSqiAH0ksJlsLbGM9vQJBC7SyWsAxeaVfWjtcfDcnaQOnMwm4gjmShIZxUgdF/y3p8m+wCkOj+p7VGvyr163+NvyzFXQKucPCKZDPNbynhl1wfBXIXEFyYh4QsyHiJUOuRip2zKFkZrKkxGbollZ6nRY5yUAjHnuPoYIqj+yRCPggpJIcx1yhrjm5afMOYRBb5FLiKFz1xR0IbtVSysfX+UCOWT81QwHFXCOKnEx5Fr+W3f8Xpf3OJkZkUVt2TtKb4t6LmLgSRA6ds2Kiq9l2mF9y6p8muv/zRCdHOyBQgSl/yPqPP4s9slYl/0dyxvLjcIbg6trJN8D4ZLfdupHpF5Tb1VKhyxOhpFB36l6RYzjnphtHfjrv44DW8+6/TmLFPXuebdznKR7BZiXoojmuwJ5qEHISPUkNDinp47+lE2NFLFUOrrd4V5dDS2e/td7Dz4hyqCuoyS2W/AJATFkWbi/NzN4gSVONgV5ceT12YdohRERFK6hM5Gw5hsPN2tY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:21:04PM +0200, Thomas Gleixner wrote:
> There is no reason to indirect via get_cycles(), which is about to be
> removed.
> 
> Use mftb() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/platforms/cell/spufs/switch.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/arch/powerpc/platforms/cell/spufs/switch.c
> +++ b/arch/powerpc/platforms/cell/spufs/switch.c
> @@ -34,6 +34,7 @@
>  #include <asm/spu_priv1.h>
>  #include <asm/spu_csa.h>
>  #include <asm/mmu_context.h>
> +#include <asm/time.h>
>  
>  #include "spufs.h"
>  
> @@ -279,7 +280,7 @@ static inline void save_timebase(struct
>  	 *    Read PPE Timebase High and Timebase low registers
>  	 *    and save in CSA.  TBD.
>  	 */
> -	csa->suspend_time = get_cycles();
> +	csa->suspend_time = mftb();
>  }
>  
>  static inline void remove_other_spu_access(struct spu_state *csa,
> @@ -1261,7 +1262,7 @@ static inline void setup_decr(struct spu
>  	 *     in LSCSA.
>  	 */
>  	if (csa->priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING) {
> -		cycles_t resume_time = get_cycles();
> +		cycles_t resume_time = mftb();
>  		cycles_t delta_time = resume_time - csa->suspend_time;
>  
>  		csa->lscsa->decr_status.slot[0] = SPU_DECR_STATUS_RUNNING;
> 
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

