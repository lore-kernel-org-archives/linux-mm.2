Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B51AE63F12
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4942F6B00AC; Sun, 15 Feb 2026 15:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464AB6B00AD; Sun, 15 Feb 2026 15:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DFA6B00AE; Sun, 15 Feb 2026 15:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5F96B00AC
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:44:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D46D1B4DEE
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:43:54 +0000 (UTC)
X-FDA: 84447867588.29.8F2E652
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 88FD91C000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:43:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gaAcgtDO;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771188232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUYiczTId7sm36/pcGB9sAOFpwsRYPpRXY+ssJjaFVI=;
	b=p2a0/Ww/tTGMoeVKPoK4ljOmdN71msv1R1xwdWSAF/oGpbfXT/cKjfWm0BgEMl8CmOX9Sj
	/IWC0VOG0mq3z6rtv/QF5NGPzqma2iBFAjxyIsZRQKYZuUQNsdO8sQSpNfHm/rl3ZjIOK3
	igj4cQttiadSLVXp+rCANaUnU1kqllY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gaAcgtDO;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771188232; a=rsa-sha256;
	cv=pass;
	b=vTit2oB5saKyB8Bi8OZXV/hJv4+MBvZsha+lJuZFFuoxUsojHm8OdUBRQIis43QsMlaxS7
	3s9sdUL7iIFW+dD+Oeeo+W/hzK+na+SCrGNLRI9aW4E2+tLM0AO4ZT5cIDG4/lXlsj4+EX
	AfzXxImsQsjhFg55aVeG3G5tqdbtctg=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cb5138df1aso120162885a.3
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 12:43:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771188232; cv=none;
        d=google.com; s=arc-20240605;
        b=NcuJ5Y4QD0zsfgU1DpFT2GPNluWjz1wuaqAbZJUZ/6Av4fMuTDqWm1CS2KYZtCc/k6
         1IN1sczG2zQB9aHWKBANGhAhlV2zx2ftUMl6BDABq4utmOKWU4mjSY47wsacBes3xHH/
         jHmhjA4plGEfkJw317mC5W38hLtVKiA89mOGFJM4EPg/hGKR65YjmUw68NdlkujjeG2N
         K7sb2ZHRVzv7sPaSvgotm9wNvR8U0vJwCvTh9juytC31N5KlDBR1KA5/MZiVqYTcsjGu
         +7eVZDcxRDhlv3oKvtMprL1CixFN11GEIlycr5KvsrZgV2yoApUSj66cqi+y+WVADLCD
         tIag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sUYiczTId7sm36/pcGB9sAOFpwsRYPpRXY+ssJjaFVI=;
        fh=kRqncPBM301Bs9kf43Bf26ZLy0CpcKhlf1Z/seRyxLo=;
        b=UeyuTiTUDQ7ygkPvtkCgCfsE5Yd5Y4LBXYgjScViTeuAFRKCWBOBbLVRvcOtIyLjQR
         BW6B4aeXvbVSzwRryuSpPPG1RVbfxCgskNy3XEqqs2Oa7HlklB5L/LH8Tj2A+fGVEJuy
         atzZZLgTK7qdAQME+ki4qHJXO7LD9f7HtATZZyFLYlYu49UlfK1bf2NCT0giaZ8uzxGi
         edmDKcAbF0XzyZNvEoYmE5Bv8bVphWcZNV2w6526khliFhCzueh9VKYszHcn2y4b/DC6
         e4X6nnzyM+XtpkzC0VPT/cv6w5qXOro9/3QCqla0wc12kHzWpbmMCbvvhoOLmkQAsMy5
         V0qw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771188232; x=1771793032; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUYiczTId7sm36/pcGB9sAOFpwsRYPpRXY+ssJjaFVI=;
        b=gaAcgtDOuKQyy0CGepSPqVfek90lxAwbgfSvQY+0FF9BfsnjbOW9j9/rD79lNupA+m
         3pyKBCiQTF7h/A6dwyzePlBY6OwldsyXnHQU1MuSsJGNzMolNV70fHti0Uckx4X/+ZZW
         JxA3LiHPbE/Lc+0qbgsRGXvaT/sFvAQJry7y+a04zaws3vUX3CPlQwbLB0SRVTDOH8Tx
         jd4fu2+VI0QL4a3+BWiW0BSnco9RpZl5/yCKSP9fiawynr44rvqBB245tXfVmQux7EZj
         /AB78tAITOZZFvs8jk8lIaYyNrrQrEsIEt9WKXNPhYDOUkQNH+1oHK0AZzc0vbhvoTP2
         VS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771188232; x=1771793032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sUYiczTId7sm36/pcGB9sAOFpwsRYPpRXY+ssJjaFVI=;
        b=N6jp48lWU7DnIORhkLNjzsVITq0V1X5dG8ec8IdA6j8rNMbk8AlGxeXeIo0CB1D8SU
         Iwh8qctZp2UI4q2f5AtTUPp4D9SwczIqrOEW6vqJ4kXzzVmYo0q+rhOI73wwhHqff3TX
         M6qpnBH5EFw3io6NzmRyQZOzcySMkahaWSJ/XGTo1sH1HxqazGkTXb/VdOQY242Vkiz8
         3AOxSVjc69RCCtJtlHML4B16jZMRWWwolGd2o6PLz6qpOgyTx3w76Rr/wLFKH8H87tjN
         qEE7Q/6fzDSGZE5HU0esefnCeXz3mPkpEvfNhHhICkzqfBpjTpGQ0o1Zu8TaSGBLoBnL
         9GHQ==
X-Gm-Message-State: AOJu0YwFKCcWiWvRV/KEQjjrBxZjoyMCNAxhxjHkgcM+tCr/i5WP4wLY
	ZF7rkHQL3qBxaSCSd9jXiseyQxrbvvJafptY2h303KROtgd1n59vUbqjbIWadmKHF5+YiJZrmw4
	BNzwd2JaBi2/ydDH6+yzEcAS5KtNeZ31eh1E6
X-Gm-Gg: AZuq6aLECoxiyOEaMCHJuhxTxQu2vOLid0uigcVYAJuvM7K+Aeu9i3tCKCayDhyayha
	dXA4fZ6whXppCYT+Mz785lB7kdn/31qrKO91NDGiFi5zYprDdj3VgbbJqAy/n/VeI9ZCfXxR9NH
	B4o7moR+2r9TaIlN3WgmRj4PWQ2/XR+718kFnPR8uvOfAEvXMO6MVtzBWqR825ormhjdXtchY9n
	64ChbkYyjq6kUUpCC6liZh4ZEhOt1BLHLNoAADmZRlwVefibpKgFrO/Hf5fk8KjVOjLHri1E1DV
	iFIeeA==
X-Received: by 2002:a05:622a:58c:b0:501:4ff5:ae3 with SMTP id
 d75a77b69052e-506b3ffff08mr84696281cf.42.1771188231378; Sun, 15 Feb 2026
 12:43:51 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com> <20260216-hibernate-perf-v3-1-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-1-74e025091145@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 16 Feb 2026 04:43:40 +0800
X-Gm-Features: AaiRm52fgDtfNvU3kxKbZLjl0RB593izYUrm1DGrHb9hftHazRJhLykKi9hoAlw
Message-ID: <CAGsJ_4zTCnL-bYN+nMXJEDPqHtF3hgiyHwyCoTc+nb-t6wouRg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm, swap: speed up hibernation allocation and writeout
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: e166onbexnqkxziu4hb7uuk6yg3py3f6
X-Rspamd-Queue-Id: 88FD91C000B
X-Rspam-User: 
X-HE-Tag: 1771188232-345635
X-HE-Meta: U2FsdGVkX18O3Od4IcV75qpGaVUh2oK6ATFLXUz3YrlbNRnI2iUnTx+GM1tz/Vi7ybi5lVbN8LT9lfNb25e5Iin6cUklA5P9OycmVGq4M7DJl9bW8eEKZ54N2ZY23AIDon+GYh3lgUd9AdsztkpkKqA9UXfMJH0/pPZaYX8M3E7imwhnwAJ17DyinKh40O1oeWgy7o2eNkdzvn0bW/eOusuOCA3bpZy4elhAYR9YmkHhH8zpip4TPGzZnx25gT2vQc1ZGAfANZL93UpMHSs1A16qQIim7Amh3BmWqaFr0zjzfdL7krfnSMVRmdiNPKGnz57ZW8JkiEeCcaXNVqLMo4vfJB5qGFU94aO4J8WeiEGkfKhLuJJDdZ8IqXlG64BC9nwuBRht1VXCmBpt5kaVisJCEvFHJ0ezHjE1sNr+EjF/vOkTNjXNcbADmkJi2Mn2kHTkTIJmAbJc3t0Nj+jw5r+Pa/smIbV/3Jdx0BXy51FC9mZqvzm9YAODOpIa1M7cfo3MP8zT2ejICkTAKSSBvcaMO4pKcJ7kZsED6dx6e9gM7ecz65YWITco4BewPjc6IqaAIg/g8wpWMqsF3j4mIAKXdxv5mcl43L6Ypw0G8ZrLfyxI0N5bAbFteLinw7oupt+jYiD1YUzsJ/8dXFcqbPN6SO4A6OSW3RQ6adef6DEje4uA7rbRe3nHKwFCqLBy53gNfrm2gymI6ELIAWq+Ik5cg8Q0pqJXwtLcc0uudN/mGhcwyMbM0Qe/hBDlzVIDX4WUxeVMUmLak6za/2bLcxWPYG6fV4z/AiTUPqFx4F9fZpIEF1zqtH8f9Q69pa1b6DwBoeh/8lMF42MkycPhNhSe9ixPe6YxgTHpqmP+/LsqX104nz+rOWeaOEoM5nHRfuSo2XYAQMRNWawy3t9isDoQKiZN5FDnYZgLqrl13FCLYjpMEHfcWvJZhJB887zXDeJleaSUsnJJU5HenkU
 90kkKv+y
 HlO9DPQRf5xPqdLa3mx22cb6ToHH/V4M0SoIl/4zd0isSbpcrC3vjNyzFdo2e9AuHkVXlbAGKD2OZR8YfqftO6aoX11BFYwTr08Hc5Ot0i52Bx2J4/xN6LgKaJ/fxo1DuVLgxe2/VCJurPoNplvjaKQJJ0AiAlRKWBXrC46fRI1CiM/6RBBORdH/o+VngKI8dNQE91yURnvtq27KeTsXZkhBGK7yhipoF9bX2iNs9uaMKeaTbSUEFZqA9Yrqe19pbAjZmxHwI4CEfXcwKa7J85j+3g8xu7QrlifFQ15qNFyLoE8vbF2gUARuAWq6f4Powil+aP2gSyrccCspo0XUQsAIh7eQOLvCz3J1vaDRKdgzWF9ewiQPO5YYsUhZW1xtfw7hU3o7h5XgHs8LGV92rfURIfeXqgohpfY1QCCMXn5su5MOhjzhfr40DWDfCjrKOxA7aNdyudSRUgc8J7Dq1VmQuSh1WpZCNkdCnPfMTipwumR4sWL/v7BPuvFJ0olG3wDi3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 3:00=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> hibernation has been using the swap slot slow allocation path for
> simplification, which turns out might cause regression for some
> devices because the allocator now rotates clusters too often, leading to
> slower allocation and more random distribution of data.
>
> Fast allocation is not complex, so implement hibernation support as
> well.
>
> Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
> performance is several times better [1]:
> 6.19:               324 seconds
> After this series:  35 seconds
>
> Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
> Reported-by: Carsten Grohmann <mail@carstengrohmann.de>
> Closes: https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bb=
f49c22e@linux-foundation.org/
> Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c1=
8f@gmx.de/ [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c6863ff7152c..32e0e7545ab8 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, int=
 nr)
>  /* Allocate a slot for hibernation */
>  swp_entry_t swap_alloc_hibernation_slot(int type)
>  {
> -       struct swap_info_struct *si =3D swap_type_to_info(type);
> -       unsigned long offset;
> +       struct swap_info_struct *pcp_si, *si =3D swap_type_to_info(type);
> +       unsigned long pcp_offset, offset =3D SWAP_ENTRY_INVALID;
> +       struct swap_cluster_info *ci;
>         swp_entry_t entry =3D {0};
>
>         if (!si)
> @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>         if (get_swap_device_info(si)) {
>                 if (si->flags & SWP_WRITEOK) {
>                         /*
> -                        * Grab the local lock to be compliant
> -                        * with swap table allocation.
> +                        * Try the local cluster first if it matches the =
device. If
> +                        * not, try grab a new cluster and override local=
 cluster.
>                          */
>                         local_lock(&percpu_swap_cluster.lock);
> -                       offset =3D cluster_alloc_swap_entry(si, NULL);
> +                       pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0=
]);
> +                       pcp_offset =3D this_cpu_read(percpu_swap_cluster.=
offset[0]);
> +                       if (pcp_si =3D=3D si && pcp_offset) {
> +                               ci =3D swap_cluster_lock(si, pcp_offset);
> +                               if (cluster_is_usable(ci, 0))
> +                                       offset =3D alloc_swap_scan_cluste=
r(si, ci, NULL, pcp_offset);
> +                               else
> +                                       swap_cluster_unlock(ci);
> +                       }
> +                       if (!offset)

I assume you mean SWAP_ENTRY_INVALID? Would that be more readable?

> +                               offset =3D cluster_alloc_swap_entry(si, N=
ULL);
>                         local_unlock(&percpu_swap_cluster.lock);
>                         if (offset)
>                                 entry =3D swp_entry(si->type, offset);
>
> --
> 2.52.0

Thanks
Barry

