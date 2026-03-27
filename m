Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6CF210A3D9E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35476B0093; Thu, 26 Mar 2026 22:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CA56B0095; Thu, 26 Mar 2026 22:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22866B0096; Thu, 26 Mar 2026 22:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A14A36B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:13:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26D551A0F69
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:13:49 +0000 (UTC)
X-FDA: 84590222178.27.F629586
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16733C000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:13:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tK9PyEL4;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjWyka2UYBINy62WAyF888cXAxoCTEB683Pien5qO1s=;
	b=nIsj5s5kUHA3Cboh5ESSTPANqwgaJqJlG7eTak1ISLRidkbDu5GOERDf1xgyCymaZSRLLk
	2OneXf54temgOOd5wgXOO3ia64o/YD/ncluwYxqQVp50zNWgjUYzuqT2Lbu/sFMGnd+3Ww
	2YiKHOd2fQHPHLHnhPKJgA/eaZDo688=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tK9PyEL4;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774577627; a=rsa-sha256;
	cv=pass;
	b=A5LgRlK5LuJ4adilBe2cKAcaCF9PsbafyQcqeZCMk/GA8fWEGI/AWGGqBmh2SynVEzHtqF
	krrtnrAIhnel0yqaTcGJWH1FkteGoNp0/Wt184iv/GGjZvyPNgR3VsyIZXDvbJ5Rf/dDj1
	hxktmjVsHzsrR8sE1zrWtk0Kkayfz/E=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6611f41eebcso2113308a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774577625; cv=none;
        d=google.com; s=arc-20240605;
        b=T/ANGGwFFivqHZJj82XBEpKmKoxiHQZAmUDdx/6K32Ub/b/hf00WPCEfz+gMXF1EsI
         7AHXeHuqBMCzb1Wj3w7S9t9JiquP9LDAUaYTARPW9qgwePOEuBv4x1NoA3RQWxxqB/Y8
         grWPQUx55rnIKptUYf1d4DvNWTaZ184DNjSezHRy9d5hDlNBzYtvtx34IT5RE79EIN9j
         TnXwZMu84zD9Y6FZR6c+x4l4OaocRqx06jLxRTi/nV7FWG8cEVc85DxS+lbFKAc4Hcby
         Y3ZdRb8zRIHq2XkVji3Z9ww5uTNOEtlzxROEKq/E8xpLDwELjZHq+bYXoXZXcdIUDBKo
         FUFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TjWyka2UYBINy62WAyF888cXAxoCTEB683Pien5qO1s=;
        fh=eaHIIg5JbB+GCUdvhDi3Zlc2dxdIOtHZ/zxzGew1vgg=;
        b=Cc7xiX5rQrx8zzPTvjgKPqTi2GQKpwZLTaD/BHJ+lXR52XPTXpo+DpUxaJU9iqdHFF
         /O8xXzFuq/gWK7KinIS4v7LdcgiHtB+lEForTTr7Kk/z5gnbivG0AN4koxO4GC2STaRf
         DR5SvouTSyRcwJt2pRylgOUHxdtKsnJnGibJ1h3RNJZi5ce4ec5GIPZJpB2XKL9r2tuf
         DRCgQo+4jmlFNY1g6aWnSkxzWKZCpWTlOYX6SnhbWGuDTpT0xx51cSsw3VlMP+UAGDIf
         H4Mt2vPiMnDlVpdt/pT1bJ3oMuzCfKhhl1ZQ1cKsKaIx50Bjgm9iwaSY8n+lzsr+jSov
         lqwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774577625; x=1775182425; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjWyka2UYBINy62WAyF888cXAxoCTEB683Pien5qO1s=;
        b=tK9PyEL4XMTwnu6I5NcLKRXpubOnU69lJxD4yGRePNWlTwTxXQ+SBAvZZnBy1ZaiwV
         3IViiQIXY2SUjA3/WQQkXVcMvTYD1MAd4dNTOk6mWL0shmowu1qLi9tqBjaXkqG4Qhgw
         Y1QOeMOFAC7wRmab7YipSTVPuLQxbtaB3Uo5EXn4o3KvS/XmQ9aSpGChPRbMI388NpHd
         zbmY9/u4LOEs4pSeSaKHvTHeTI0TWPjvyf9BwiXEAKdfdG9ELPhKcR9OJyU2VsCIhZG5
         Pz0J2a6b/zkcIHSu+eTXOsSZN/vScsXSzpad6wbn3Prbhf2DMS+xkLJgG1Phg1sCUsF0
         tPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774577625; x=1775182425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TjWyka2UYBINy62WAyF888cXAxoCTEB683Pien5qO1s=;
        b=HBk0lDVeyhObIoN/l10GV5ZXe+VHfC0NkzkhEtC5G++1zRRg+kHVpRN55G1a+ZX76s
         PlkccSsO4wtmnmGCVWAmJbMZJMaeABKoPXy8y3kX3AAuEwGi3YHLZsv+b2T0f4MOMooE
         xE3WV8N43Zeejb9mliUYTvJiUiAbDU1DjNYbemMuF94jZtL12PxtvluSwOgrjse1Qneu
         n0d+lkiFSSfiFnPxXKCPeqGMySRZn7stgUghPskz/JO9t5Yv7Mkek284lhDF/T6OPn8v
         /C195DjgIYuqsv9E0HSqXproRb5XsLAB4/s4aXrmfh+uj8OAcqU3uNCfTyQY4iRrwBa8
         U6AQ==
X-Forwarded-Encrypted: i=1; AJvYcCUam0frGOaGJ1FnbE+Z590uNHsvXwPXCUQjALm46Um1keyR9X4SPRPS+rTKn3gMoX0FyEASe6HCFQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9X2qfEBwZ3OpZFI1z/jYYV66h1h/exrHToHNrScuFE68OtAem
	tkf83w+TMyCQPM0Cs/hq0aIA38gEWQ/BsfJMj4jhjTY910+/ZvxySo9WtstS0nUdU6dWPnVEKSG
	NhH5CFVm5uPX/xkcTQS2AIFjcIPFleUM=
X-Gm-Gg: ATEYQzyY7jTKPhYeyP7sceeWFJkwco9UHe7kwH/xGhSphLcqZLdjlew+FugkSryMGad
	v2J64gvHgunmdT2HtEs8b7Gov51xwtOu4xH7h2OfQE7lAIlEfCX5x2qskXvn3KDvKvA2pDrzCnu
	xjM6XOBN1ddv1YEJLsU5AN/CDIEl9rp5KCZ9s6Wa3Pds8ZDqjzmvgv30ta5DbbVeYDFl2KCPB4c
	D8mZcDrvzq6pcPyXr21Q80BJmrEtLV8lTecBJe4/eMsT++TYVvpccAYcqx+LWaQNrGpqh6NgFth
	iqnrWsYEQ09ATEaeAOw/JPBAxEC9S/iUqyO9IAkV
X-Received: by 2002:a05:6402:520d:b0:668:c2b6:f80 with SMTP id
 4fb4d7f45d1cf-66b28b55c91mr343003a12.19.1774577625153; Thu, 26 Mar 2026
 19:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260326185629.355476-1-ljs@kernel.org>
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Mar 2026 10:13:09 +0800
X-Gm-Features: AQROBzDenKGDqyfXgvPTeJW3CNUlt_eGrEG82tjBIA7j7hKM9pEXGDjQkeGcL9o
Message-ID: <CAMgjq7Dy8W8WQ5qZCc7KEFsQb+VYeR_o-=1C3=3w-K0yb6HHcQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 16733C000E
X-Stat-Signature: 54tgpf9q6xqyroa33k4az7xjqktzpbbz
X-Rspamd-Server: rspam06
X-HE-Tag: 1774577626-909827
X-HE-Meta: U2FsdGVkX18ugrk0tOJZimTp+MVjzpiNuenbvR1rU0bNWK9Asg2xVVmpHJy0ua4HcOvKe0NbWpNMOBCFZ4arAlbjRahVsEHcrjnfkITyqI/Iv+P6vQNeDv3P7aHX6+OnD5rwkZNuw/1fmOC57eGF/gEKKv2pQ+N1b1N5TPzd93Qx/jKd3Ob+Ua2mHh56JBKuonWY6mfuP386ISvESckgvljc5bxEcbzrZtBeW9dCWCY4UyrGHGh3ilAS2JbCq17Wf9ypXvvRKznIxOb4KbA6bxciw+2V473ENlHMAYbCSWajLi5S2uAN4AYP61ZIjKc6k3LRkCO0mMiYy4s4eZpQvJbzvchgy//GwJCW2g/xNv+gvT6cRaw5UZd0zAr9qBAudur7tww1xV5t80DA3J+zdfVxadq5nAj4oqWMElQ0IN1FjomKdzC95ucksCEapgt/GBKct5/oza4W/43kEKg+DVW/ggkZ3bbDvTrOB4Jo5A+PX2Ypn2IO1NQPIaxqY+gea/1/5SXseh6HzcBBeNh9bazGZeEmfhGzq2/bCeL0zsm+jLy2WMiyOPTNjZRM35s27Ucs5+Z3XMuaz2rMx3bGBHlRxTWr7Sf1G8B0fYm9ZmYtKjvGbzJe+RQ6ol6qli0T15JuYU2xPRogTiYh/yZbQNbZ4LmBAzo6uVEr9L57ivNIg41Npa+6kTFz/SX7mFQ0z0lBhbPoC1aQwle4pIfQr9T2FPIt3fh3Ib6Lr/H93khrPNa2XQM1fe4zqLV+f1qDR0QZMP5HAafsAiBmj84mdT9WCSTvvlJiKRDKrPiY4RStgN41IbHLdKAOzx7aEO/svwVAAUYDZJULxAB6Hlo5D+9g7p5C740WjQpdwex5/iBN1NfcjclvvuQL3/qvtAQzU0GdVjn7ZIOqtITgnRK/5uMpUlF2PsqA2vKrobHy255gcEmuvEOYJ39vAkRgaDVnov/DvSXidr5GswqTyYR
 SIdHpC56
 hCb6Dz4F2ryutKTsUF1+LsEb7vLmiYGx/G8pcQ4TsYjudJyAJiKK8swkrTlXWNFXduoW24qHYxzTi0nvk5y5FVysBimv6E4Ug6ivwigfas8k7QEQ26tlyP9ZvEpYBFkh4eBIR0nRkKqOP/0+mglKNIczqT2zubF2QqgzSBAZvCHdrErVVLc2u0zfArHlNI8vE8w9mDJnRq9dggZyt1vdARbBYTXROiO0oDblMMTLmv9HXU5nSbm4M4JPLJ3fdjloNp8Ph/FhK9YHTSStbwqGC2bYyWdURfP9BMP5suw3Xkh7XU3ulOSLOxHO3ba2uIvp8hGjgOG+JKt0EODffaRgaEKESSEA3iOqoSaTdVNoJ45s/gwPR5mzHDu0XY4vg0U4FV8dxb2q4xr/o4NcIoxNMBr4/Vwq42aczcseC9spvoy8AWTsF/qnGhg9J0+ceHaVHMM1FaYcGy9Ai6tZq3x6neewm51bOI7facTOF6hc2Mgr9IsdQDNaNqOFN2mP3Pc8+IwOYjb/6IcSJEJYQAN00hI19Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 3:06=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> We are moving to a far more proactive model of maintainership within mm a=
nd
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
>
> The MGLRU has not had much activity since being added to the kernel and t=
he
> current maintainers who kindly stepped up have unfortunately not been abl=
e
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
>
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
>
> At this time nobody is quite exercising the maintainer role in this area =
of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant wo=
rk
> or review.
>
> Therefore add further reviewers, and at this stage - to reflect the reali=
ty
> on the ground - we will not have any sub-maintainers listed at all.
>
> Each of the files listed are shared with other sections in MAINTAINERS, s=
o
> this doesn't reduce sub-maintainer coverage.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> (Apologies sent first version of this without MLs attached :)
>
>  MAINTAINERS | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76431aa5efbe..16874c32e288 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16757,8 +16757,12 @@ F:     mm/migrate_device.c
>
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:     Andrew Morton <akpm@linux-foundation.org>
> -M:     Axel Rasmussen <axelrasmussen@google.com>
> -M:     Yuanchu Xie <yuanchu@google.com>
> +R:     Kairui Song <kasong@tencent.com>

Thanks a lot for the trust, I'm glad and willing to help review and
improve MGLRU.

Acked-by: Kairui Song <kasong@tencent.com>

