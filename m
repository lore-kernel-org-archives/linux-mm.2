Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DACEE0AE9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 17:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9D66B0089; Sat,  7 Feb 2026 12:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567996B0092; Sat,  7 Feb 2026 12:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448FA6B0093; Sat,  7 Feb 2026 12:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30D006B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:34:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFA831B2E82
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:34:47 +0000 (UTC)
X-FDA: 84418360614.04.44FD45A
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id C57F82000F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:34:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SzlOmL8x;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770485685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB/fqSueCYt2RA3ppkdZrQ1ODDWf2CGc5HEiG/Wtd9g=;
	b=63mlMj75Ek2kRFGqt5KamLd12+CGbVuGuNJVMAVl/JUx0DQ4mfmkpRm82bImQtc48r2wV/
	RxbeoH6iCYhPkMsxkby4s/DwSIPvSAPkGBr86zbtYNyU04ox0Fq1VHifAN3Rx6ZdWdbFaU
	L3LUu7SPf4RysZsHp6hQ6BLnqToFZPw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SzlOmL8x;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770485685; a=rsa-sha256;
	cv=pass;
	b=ji5wW/7+cNP0eIOzUMARoRNJUOdfeaimq05huavf4Td3lYKyo9IYJ5fR4GjYxBOwwamibw
	abNcHrZes7t96Z7wrv15CecRs/XPBAYGyLS9FdiyDKuzBWTQrQq74svrhA3Hd0rscLfenz
	wHlJMpKfx5npKYDz6RI0BOTD1FMTU3I=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so2126502a12.2
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 09:34:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770485684; cv=none;
        d=google.com; s=arc-20240605;
        b=knGQa/4N2DvF9OLevStG6CrbcuGiU29C+f/Wiu8cWI8kQl1Tl2Ib/aOO4f7gMOU06H
         yJ+sMrnN75Ew/0qL0mXG6hzMWLU6lc7vS/xN8GYWPi0wFjbjogt86C/C8fsEOQI7XN/s
         f52csxOqJ5Cl+5ewZ9WHV4d1QXA5mt3AX+VjbJaPbc9hINviv4KoL0wp61P0JEmqHfvA
         XdHoypDslufehm2myve0kPvTUSLotM0sTR6eZwsuwZy8bWciWP31chY3wnfW2iUC/ex9
         FBcvnSHWqp0hxxFYYOAcRbk4foOMibUNb6E6EsB/NlQVN3sDFQNXaAaDYxV1SFdJcA+o
         2oaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jB/fqSueCYt2RA3ppkdZrQ1ODDWf2CGc5HEiG/Wtd9g=;
        fh=nSzc5GFwsWnfriP59EKZiwCXAluZkuqfbFKkyKnPn10=;
        b=MzE3mqk4s/5G9dpsCdR7rRT251IF93tPqLUWH3iAqaaBEZc6tTH7JN8jPJEj8p6Oc6
         +FZAN5qZ9p6hS/7nTO5R8KM6GdI8/LDbmIPsSuFcTCIYAW8OKVJf1wuReuQdOlICdNnI
         I4SqAWntC0xy85iTpLWIV1GxuzecuAvJxoECUq6wdGiFASbfC+Tte3HELE5nhJvohfDX
         LD7lufOMb8iKgw+gQHjkc44YFuJKP40t1apWg/SpyXtdtBUe0kWTM0X1R+xVdXMdH+r4
         Yhq9T0c3xrg88OYAeBQtrtGSG0WYZjkqvVjEqkKkBG1AEbItwOPXkgfjSc52C+eqv2xP
         XwTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770485684; x=1771090484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jB/fqSueCYt2RA3ppkdZrQ1ODDWf2CGc5HEiG/Wtd9g=;
        b=SzlOmL8xp8/xiQxiCPicRdbScyRXnHFureXeuckQcPVB6n/OwPi6T71Zy8zvwvdgpx
         jL8JQLzGcMM+2e/5JUwG9G0ddUWecHr2fECHrQEIfDsVBCNSu8EqdXT9AUi7dkTOjlM3
         ds8sXF3SbE+VEwuibxEpOA0GuA9rX8oo8euhJduNjI5fgeBHyHuOu3pgYHOcDAf8j5LT
         G7qUiExabhRHjRPon7oLT4FkOH1SKZhbloyi1waDecC86Nq8Tn2vmrMPE6iuWM4jyn9I
         XnArykXUyCi3C4gUp4tniIjKePXzhK3SIqT9SsCK4VadHTMiAn6JQh4401M/Qe85Y6r3
         258w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770485684; x=1771090484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jB/fqSueCYt2RA3ppkdZrQ1ODDWf2CGc5HEiG/Wtd9g=;
        b=MeHmjvxeNbriWLxdIGL1yLG0Zgmbkzk/FoaYnvrDp7koSz/wGxWEfqnCbOxhuSIQDY
         ySEGw3hUpBgDQhui83IoJ+X4hYbQs2Iu4GET6r17xb9ErnfnFEtVgTSy4vHdp5W2DXnE
         r5nfiuAdqsK0AGspyGjoahFYhPyIRGnJ8+ivIP8zXTXx/3O/3iNHQyePOtPRDzetD3op
         rV10q6jg2Wf3VMXm6CqUYxVqZaM/JCFWL1GKW+ztQuYpy2xVcGxMdxKd4idIItBXKh4G
         UdqUp/EYQ7goguYLN8O7fELfR74FdT+VSHmQw2YF4ZIgjJOpeJLbRn7LvCZ0V6SzTcNm
         9UJw==
X-Forwarded-Encrypted: i=1; AJvYcCXo+int9ciUON/l8v3b+baxdsZw9ljdydDWs+MVpCWAYpxFgHp+EYs1LdS/Zw9HJLcVGUZqX3uxBQ==@kvack.org
X-Gm-Message-State: AOJu0YzePcXIqFTia8W9Xf9LHO4Eo2HcZ0QG66i8B78ptNRvE3lp79x/
	o5uUmXxZugGtjFg7XILEShRsIoY1Z05JtP4vR85cf6R6wn7aH/y2kVOTJsbB2WziojvqwbKA7e6
	fdx+/Dnkg9bjDoSceKvtSTFNG/3aFO+RuKXTzkHXsMA==
X-Gm-Gg: AZuq6aKoLfa7i1Jd9Y5wiKnRmXHcBvCM91/FuxpugDpeJjOt/LSmtkQUWXo5M0CxJVJ
	IYEKJkYE8EVtA7anMS6TfFw+osfThbSAR8X/i0+rATwaNQ6DAPJR0WrFRKTxZn/YADjflBi3bZY
	mwlJZufbV2GDsgqlCcFpi/C2maE/32SZCFHD82lBhLRVRoJ8RxbTntAXz2bBhd3Ud9tGFNXyVxa
	gIMYq2864fiREwgWGpxk7MIhptEigzxS4B4ntqMZyqgGwIZjKw2Rg3bdnnGPm25dqody1WO/Qcj
	DYKbqBeIhzoF0YUjhgPf2M7H8HQ=
X-Received: by 2002:a05:6402:4306:b0:659:454b:7167 with SMTP id
 4fb4d7f45d1cf-6598419575cmr3540228a12.23.1770485683992; Sat, 07 Feb 2026
 09:34:43 -0800 (PST)
MIME-Version: 1.0
References: <20260206043121.197564-1-ranxiaokai627@163.com> <20260206043121.197564-3-ranxiaokai627@163.com>
In-Reply-To: <20260206043121.197564-3-ranxiaokai627@163.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 7 Feb 2026 12:34:08 -0500
X-Gm-Features: AZwV_Qh6oCM3WhmWEP1Nry3xlXhW5Yie6guDA3kOhQ8BM2V2J9MhOnj_y4jt7p8
Message-ID: <CA+CK2bCW9fNShn=BUuje3tAnSydCQoKw-7TXYK9HahO5DvZqUA@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] kho: remove unnecessary WARN_ON(err) in kho_populate()
To: ranxiaokai627@163.com
Cc: graf@amazon.com, rppt@kernel.org, pratyush@kernel.org, 
	akpm@linux-foundation.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C57F82000F
X-Rspamd-Server: rspam07
X-Stat-Signature: kdf3mux6dji7m9spawu63m6uqofiockz
X-HE-Tag: 1770485685-530846
X-HE-Meta: U2FsdGVkX1/Jqioc602DtfEWHKktzdDr3KAUJlyB/2iz3KxNBr6YXKKatMTZhrdZ98hm/gE1bFPmxQT2Snud0zbMn/BMLylItFWQ2eYlUGUPLKkrwNQSXQL2VtD2kMFTHD/+eZbI1crP3mmQdhIacna86DwT1nvu4PjfktNRymVViwXXXkSAy7fzvkwpbnOqVtI7xq9tXM3PVKvOsNuvhI0l0uiVTx51p9XY+tQqsfdwygjUJFEg8jheFegNJiFJByjD3lIJr0izSu6YOdhRW1di+NrqH9TgbWhPp/eNdDfqN5OHbrkrJAI9WD+TlNJ8haln8cRGCc3FGC33a6M9UziEFLAhO0ANHy4CYxltUUfUeWCx7DFIOCmbj6tOhBy3bclyVAjQHbtBGVpYiqOA7Rkv3+UylfTsz/q7BeNz3BJuCKgeDm6pXl8DDcYGNUxnRY5fdlNpnjy8OVQ4wIHJ8wffpH7eVrrSkrdjhc2ajtX8pBuXppmQmN5mmt6tyfnBFuDBO0ZC3ZHyPG8tHWDML/wkJN/ha5SRx8P0SG5meJpnCcoeODc7+iAO90TBlkHJkDgAfAAMMmLw7aC9L4/1nf7fwlvFf/nsd6lpnUdwFqFJ2V9eKcK4TiOQZUP4cVD5PtgHDHnm348gKXLfhjDzsU/sDUsPHcFYWmF98OYtkc9TisqFNXzhdp+SIwZaFoDqr7mfoS8vKhrPB1tk6WJZp7M37tYkfJfYPbUgWe6enTHGbL7GuK9Y++xzc5nygeNcAW6VQPhCWR+zYeVO19uspS4JkiaLrP2bkLpvEC9RE1xPPnO5MXX67vzbM99sQFONdlBLNQZwKxeBHWP/A1ks8u1vYulWp15DORbvQXnKp/4CvdiwlQiloGI0bJNwJ6zk/7ER4jwZdZMApizkNQFrFaNoViDOmw+aVV69WLxXbcCjNIhuJYfuZN0inoHAKqZNgK36OLMfPkSl68u+IRF
 b5R37MOC
 OJlXUN5oKN8iKHaP8A16RYO2vZhZVU6y3BaE/xs2F7hmHhbe8YAkika8se/rORu9ahzPvGCw8CgpSGxibjYaWBfvVKa38d56UcZehDy+rt08n4UWQJkJhldwVwip0LHf7Rm7eUoPHLVQGwB7SRaEqLZuhjwICNYLjV+tv1IfYqCreBQNpEJSI4uAMUa8tMm3Wa7Cn/HaDKRfvhpoy0iMsf8IqMWGs4iz5iLv2KxLwrPtMh513n/a34PFhHad4YjJBQDJwcF0kF+1G0o0C962mzNaY1FiFwPRX/eztP7PyVdmTTwkIYCMRvOpM3sWmbLQXDdb/UVz//2zy5Lw8fC8y1vWf8uNlYCJ5jck1FjMPQjGqqlQm9gQHFur5iMwqopjonGjBYB0TO2uFTPn2zmeNv2Ts6HZ4jrLStjYimabeUHSfKkTqbICPXEwbunzX0L4bg6V6Zt24BVeEAIxVWhB9brCZC7hwNjgFZlA2tTJLIpCGOO1wZuZF7vxB1OD5ZF/BZ/Fm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 11:31=E2=80=AFPM <ranxiaokai627@163.com> wrote:
>
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> The following pr_warn() provides detailed error and location
> information, WARN_ON(err) adds no additional debugging value,
> so remove the redundant WARN_ON() call.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 76b714db175d..b851b09a8e99 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 =
fdt_len,
>
>                 memblock_add(area->addr, size);
>                 err =3D memblock_mark_kho_scratch(area->addr, size);
> -               if (WARN_ON(err)) {
> +               if (err) {
>                         pr_warn("failed to mark the scratch region 0x%pa+=
0x%pa: %pe",
>                                 &area->addr, &size, ERR_PTR(err));
>                         goto err_unmap_scratch;
> --
> 2.25.1
>
>
>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

