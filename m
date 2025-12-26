Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E7BE82CDE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6A96B0088; Fri, 26 Dec 2025 01:52:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294626B0089; Fri, 26 Dec 2025 01:52:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176B96B008A; Fri, 26 Dec 2025 01:52:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0603E6B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:52:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99BFC140B96
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:52:58 +0000 (UTC)
X-FDA: 84260704836.29.3ADBA74
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id C56E140009
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:52:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YMjtO2ez;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766731976; a=rsa-sha256;
	cv=none;
	b=4YM9j9bJhaJ+V0g+vB9SFvM39kJ3DWBUEMH8oXZ2S+s2oHdKN/BjCxz39hBuTazrSh2gac
	GG7fvQDPlpismiJSgqUhimcsB/sP6NsiDOB7jW+oVP+YftNWEvYqpYSibOZ8ie0ejAvCz4
	79cLHe+jUwj/z1PQ1vvpx1bwt/niOTA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YMjtO2ez;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766731976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9RHKB2GEF2U8oI5vAdfaKS+jel0CVbWQwZfBlzoOfk=;
	b=lb1qKL61DeQTYvphv+DELbPoRo+PqQJH2//cZqPtf8qXrtrLM9juICjJHMDxItARzZ1zp9
	mtdflUvha9vifW5/kWq8MTy4OYVXDu1X6E0AFMIfx7h3atQlYl2FjfcBmYHA5JPUC6W33J
	av8c2RrgVsrQQgYxH2AwmjSFuUC9IiA=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8885b3c06caso111169106d6.1
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766731976; x=1767336776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9RHKB2GEF2U8oI5vAdfaKS+jel0CVbWQwZfBlzoOfk=;
        b=YMjtO2ezQiYzOxaRa/9t1388QpJoTxqKq0hQEBeO1RJS/W8qMaA4IiMz10vQWPvi7A
         3lxqblD6hy+7Omw7JjqeSF9h1u9ccTK52N4FSqM5MZl2wmk8S0/9GEfNrifMaDCBen9I
         DfN7nwKtD3/8yBfj/cO6oR1sZogq4p1Xw3dcosflJ34jFD9FcmW2J3IhCmHpWrgwr9RC
         TsAGlLEhvsRZtFCQKb8yDqjilKZOUvtogD76gsxYx1HSNW49ipRUtFegN6CXJioy4VEP
         vK1GqGrIG4fFRHNUEmKdDfv7PT0oJL6x0SlrqHt4Bi1IsosB9d0oOgmokwgarprNjMHN
         k/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766731976; x=1767336776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i9RHKB2GEF2U8oI5vAdfaKS+jel0CVbWQwZfBlzoOfk=;
        b=l7d7JT2SfgjraPdt5RMvuvO0lOZbvvLtPac68qZOdSM9p7HOrqL9aw9Rcr9FdVzHGX
         KqXTBZpAjYSfTfx1Q9fLLkaK0wXxmAaPjFa42Z84iVxrV595SLylbZwJI7CZI6PsERaj
         Xw4g39EgHN5Fk8a19M0PEkPJF7LgUkubLa7m0kLpp2DomcPxE4n6bc7j/zhpffCdcAwt
         lFBmZrKpxWcUUCqYXJ1qzesZT8IPJXo+tN7NKu+C1twPfq0rgeffIpaqEhhB7sDW9CbC
         ydyRhXnlN0szJmzVLvfgzAPnnNdz/Yzz/KCJ9tgPQ/UpbM0bdyUAd1g7//XlndBqwb0g
         14MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqmP1GYQ6n4OdcRh/x165Vw+BGdSVUcZk6+Zgn71kPn4NAp+rKTEDENKvZeCEGkcRsZiCfkIZU9Q==@kvack.org
X-Gm-Message-State: AOJu0Ywr7K6zr+5CAbykGMizkiHHe6ATDpK5XlGKnvSlXye6qYfpsGpY
	LUtqSVdQXe9yUKWPFpFAcnwyqeTW5yUcTCJ+XC9e851ZCauGe6fqRf1IZn+lVGIQjF8gWjOH3zh
	Ldb9Iw1N48Vzm6e8vImzvAGZFahRonno=
X-Gm-Gg: AY/fxX4b7bu7jlIbtSPXF/nSLhG4lxUqozedhEoM5xtx6mVqOLmr5TBPXtPqpYi47jE
	IGZEIqa01neEDn6FSo3y8MhsfgcwhmsMKLAYHFQopepBompML60GcqqF7nk+PEyz478T+LO9Y86
	ut+hBc0XgYTPglQqAXYJAuz4oZW/cODC5tXaH8lSQIKGYsTCXy9vLqOzS8y6XwnigE0xWquKzM1
	hc1lVbFgmypiWZhU/Soaby/4gDBdk4ciyYfLjmK6RQnOnxxeAFM6kLoTQ8j2zaEAC42Ow==
X-Google-Smtp-Source: AGHT+IFlDNqlJeNNAKZJAHSPiv4dP0kX9mjlvFiLZnXpE4KiIeonx6Z/sxYtzN3esDafV7KJ0AIulTx3pnE1sviSYKI=
X-Received: by 2002:a05:6214:428e:b0:88a:3681:1d96 with SMTP id
 6a1803df08f44-88d881b984fmr335128226d6.63.1766731975810; Thu, 25 Dec 2025
 22:52:55 -0800 (PST)
MIME-Version: 1.0
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
In-Reply-To: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Dec 2025 19:52:44 +1300
X-Gm-Features: AQt7F2p_ZT6nhNcinPsVmT3d3EsF1wn1Bi7NYd_DWCOEpxgN0Li4iC6ciNGQu1A
Message-ID: <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all pagesizes
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C56E140009
X-Stat-Signature: kpbmgjzfu74ok9qu6i4aysr75ai6a68m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766731976-800533
X-HE-Meta: U2FsdGVkX18dbzz4zGnuoXSz58eMfhVmd6g775Ky0iacVQgCHNHGE9s53VZip+/ff+XgaG54++vpyMJ0KN+ceTHsz8vSqHrukf5K97iFGduV4DTlqiam62VEeTDsZ1NNp8Zav/bEJVF5ZciijfUlbz+4oR+ckqhyYtFoJg6tnhA0WKby4dHwod/yfQtr/OS/7/cLekElQKkBdTPMEaMr172an1UlkvMCMBi7uFLTDOsLKWocLvx+2SmKEda6TvkSn7hTKQmstfj3LpMN4pdHDRH5OAQHOV+HddrddogB/5NFY8rAXTECwp1eN+PxERx2J7MmgOT6zvFR3m9jpe5AgTsiGEQeVYcGe+KpcRMguV240+fZvATbnK8c9hdR7Jp+VqDieVETVLgmZ1lSuJl/WicDAU7dkZqlLRA7K/9CD75ajY3hMNQsCGif14OxVwUZC4xOZfjxP4Q2PenGdmuUN1oA5wqfP5y8y/m0vSqLp8rThnjE89Cf9DoyxDcJLTokWTq2Bu41+9LbBdOk8zABc3OEZBd9fUfI/II3ra7X/1wHmnOpQXBIeod2PcdSvZJ/i8aGL1rdAVGJkdn99dVrdX+Bu+H26bLBdv+qEa5a8YWhxzI609eW+yetxK6CgTZJz7dIyC6ZDm55INPSuauMP/0w6OZsP1eW2wgeZU9s/QCyf1j4408DTnyCnW2e8jStQY9M8RuBvXIp5sFfZHo2cYBH9313KRAQ0vxUr5hGz85gte6K9nK++DL/ecKuFHCpf0cjVqs9FAJtWGIKYQqfpI7ECpY7/yj9iY54J8ipcMPZJpN0JA2eYVEYhAo1q2L9XrUHsCLpw0GPy9Nq9cuqHtpQ73Q6bsYbDoBdRedI9Bdzi4upZbtDauPVB+MHVYEFUwhZLio3s9OWnWVsfAaPhZJX/TNpOwBrEf8MtoJ5Ff/iswzl6gjfSyGoVTVlsXQEtT7IEjgm1sYI0ZGMZBg
 Ni0aH/30
 wAUa8Eq+XH5BsUmf/Vr8nNviwoj8gEMR9J8+duyEsnxzuVBw14fqmW+huz/+EY+7LazJhpgqbizlyCmciSg0oOrC3jjnwKELHuY4PNxU3V4VYKRJgx/IXqnvgm5tBg6sPEWVtQTJgVvs1+i2T/+DDUgoNsbCPVsywUzd2vpVlhjFZHZHZ8g/RXFISQaZYPud2tS5VWRTAzB3RIVX8D2ZU+l08lWbHflZb4Uk/SfZaJnpKdlksBNwbntmlcaEv8qThy+5N5bn4xSW10T27BB0DUznBReuFE8d98UgBhzHO/3W0+O/ulIZU3v4dfUGKM/gmgeJmcgmIM4/lKxxRNEf7EKtHP8dJzKTj9FYyLRT4tA8WHUD8qmpY2kt4ueNf3MJSKYxFkgf8PubMw8VbuCymzOdi6mS0yROGlmonG62Po5T7T4AdxfpT3Vnmfh7ruVbVCluC+05RQzmIbLk6eyampO+1lxWLceAX30x3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 7:39=E2=80=AFPM Weilin Tong
<tongweilin@linux.alibaba.com> wrote:
>
> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels,=
 but
> large folios requiring swapping also exist in other page size configurati=
ons
> (e.g. 64K). Without this config, large folios in these kernels cannot be =
swapped
> out.
>
> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.

I no longer recall why this was not enabled for sizes other than
4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
it appears to be fine, and the swap cluster size should also be
more friendly to PMD alignment.


#ifdef CONFIG_THP_SWAP
#define SWAPFILE_CLUSTER        HPAGE_PMD_NR
#define swap_entry_order(order) (order)
#else
#define SWAPFILE_CLUSTER        256
#define swap_entry_order(order) 0
#endif

>
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---
>  arch/arm64/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 93173f0a09c7..58f7b4405f81 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -120,7 +120,7 @@ config ARM64
>         select ARCH_WANT_LD_ORPHAN_WARN
>         select ARCH_WANTS_EXECMEM_LATE
>         select ARCH_WANTS_NO_INSTR
> -       select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> +       select ARCH_WANTS_THP_SWAP
>         select ARCH_HAS_UBSAN
>         select ARM_AMBA
>         select ARM_ARCH_TIMER
> --
> 2.43.7

Thanks
Barry

