Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548E71099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 21:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8393D6B0117; Fri, 20 Mar 2026 17:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8105D6B0118; Fri, 20 Mar 2026 17:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726E16B011A; Fri, 20 Mar 2026 17:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 603CF6B0117
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:20:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E05A13A91E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:20:10 +0000 (UTC)
X-FDA: 84567709380.15.DD5DA2C
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4042740014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrPEtCih;
	spf=pass (imf07.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774041608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcerRo8gxSECfH/hn5isyzefV2bKoN+KpJJsnoPnQtQ=;
	b=uETcaODsgWt8Zwxu2meHi1PBxUH1Ex6nsG4PMnCRyU5JzI2rcY7jMsoXwK8JcKtNf2SWzR
	E6u9MX5Qs7ej3+Yb+b+2TW8x0ETCF7xhSOmDDJHrrY43GN4A4shaTVGjKqLOjNrbRYbVmE
	O4GJkboje5Sio4BPQRSmAdj++Ndk4q4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774041608; a=rsa-sha256;
	cv=pass;
	b=b+qaVSi63UAjuGj+e5KBOGXg+SJYJruNT3QWejol9AnmRMnR5PsQ+cT1U9cQDILCeNtaym
	OEJbh5ZpQqwz7bY18Fn0KR0UHw/ogYgg5ULFK5gDvydS3V9SBjipqVQCHy8QDoMZdHqMUC
	E4QepeJHb++umYD2a5nhqdpdnIQ6BVo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrPEtCih;
	spf=pass (imf07.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-126ea4e9697so1239c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774041607; cv=none;
        d=google.com; s=arc-20240605;
        b=Qckla1bDjwZnitYECA5jFSLA8WDcWl1hnH2SiuksjPYHtJdELz2J/WRfWEgILI02nJ
         NyGeHP16488cqnUUgfSre2fAS8+/l3NQ3BDyhTpqXsEjFn23xzFox8OKSCJbGHnIaIR5
         im94DulZmHN/nHDfSxb8AAcn/XalY9wCLEs8HINayqGlFihVE4vZ5kzPxRAqlg62T2ty
         IMXN3Vt/Qw/1ou/ITWy33GGhLYKuM4BUdRXauaxaBg1X6GVyKs0PAuBuhn/Jb+xurJv+
         ycR47261bxxbEmw8rc5OVFQRuIjRDQ2trjA2hL7tfe11lQHdUp+qr4fwY9D1KhMNafRy
         Ou2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LcerRo8gxSECfH/hn5isyzefV2bKoN+KpJJsnoPnQtQ=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=e1JhxWKlBIFuW9NgOeP8ZdAWNom4UNTMQpD6O3dSpoWdzxWgulvaeidg55YiyOD1RE
         B7OyhC9S8MvRSqZy3AIAKje2An7F5o+62W9yaw+h6UGfuw/g5UuOInfunqKq34glKGRD
         fcFtNSg3qUFhYPXN2C3jNP2F01AEQt/8Ex+byYu6ELE3TAxBf0rerIfkNgMXDztijDA6
         W4D5edTniFzBbYtTon2dJi+RZ7IgnIOiZ4d2MfBOg/gUhH0SoonINkOQRVaLfqhe85r0
         81ZKHcm4SLW4QZE+cGY0SU287jSsnxn+h/uEqtzkjrzYez8iuJOue/ENPGOJlbX44Moe
         tKqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774041607; x=1774646407; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcerRo8gxSECfH/hn5isyzefV2bKoN+KpJJsnoPnQtQ=;
        b=VrPEtCihEe3y/0ImMFA508T5uqtsxwekzq2avpkjbej8zd1m9XqZcEsZtrsO+HbRsA
         Otta0FpDgwQ2/wRLyJJmztWRXSiXcD/DlO8WYUOMoEcsyStzWmbKJ3+dOT4I/o4piovc
         kgiGBqOrBO+YP18GUDKJqJ1Oh8K6kB/2rh5JrowbPuR7irEdR1B3vGp1KwcFpJRM9dwD
         PslVHiI5sVjIKsbE6IQkVnWbNNVwXL9QeAHJBmHS06tXVDyclZX+slaLgndcpNSlb20u
         2sFLjPdG+u30ryucoFCO0qeTaVhmzu50ozG/ZnWsxdn4OgfRZlylC6tfaxQ3X7/2tNxp
         3FfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774041607; x=1774646407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LcerRo8gxSECfH/hn5isyzefV2bKoN+KpJJsnoPnQtQ=;
        b=YimEnzclawnOhMm+O/3Sp/djgqErWHEapK/UPWEV+ZtQGb1pdtSKykr11TN9V9c4sv
         fBW2HkmHD0hGyiyRJDjBi9LU2EIPj3FKxiiSzvm0VRBQZvHGriKgvilfnBOMzcUlNSEY
         n6cgheQUXSKVbQmscPwvnxsIvDIxAIB5J5ZgKgBSmJHIsl0ET9byi6m5QqlQlvxzTO3b
         D3rC56p+hu50J63aJkeW7SEZhVgIUUrsLcGtdjabJsSwho/98EHtsDU/QdBe0ugpONbY
         x4Y2GGdLhWmq2B7Uc6m23nieLM0Wl8muhOcTW7YX+Erc5jKAl6Em0AtusIh3GCQ2Ywz1
         IH2Q==
X-Gm-Message-State: AOJu0YyZuTfyLTc4bXrIxlQ3Yn1iJ/uLz8efidvH3M2Dl/MZ0SLVD2u2
	pfVjDiL4+oOFO6pXEVLgmNCUNWsdNGD4PY+iSPJGU1GovMF2GfCD5OTDMdrVUUvU8GW4f6UZy9I
	Y5pZfIQjz/d5fmlkO7Y8wNqpwdaOCOw3uWKM5WVlX
X-Gm-Gg: ATEYQzzQgqXOkhlpoS8uFhlzk/yGzWRgjLA5eHS8cLLk+05Zq/ksw3M/WEWDDzaGzhy
	YT7sPYZU49dfTI+4+UDPKcwHve7pV7OocTdgcG/Ox+KrufUHztjsMorUnT+TEiI29xb8YckIDKb
	yVwrV0vegLqa5SjZQ0SNnAdy9Y/BEhQEGzdylpi8hPzcH5E+N3bF8bMJcJ/CtAMhQgSIsXlLMy7
	53WJ9iuPx8Rm+s6c2GH5uNMdGMzb+bDxtl5kinKTnKWMoNyH0lfyXSanCjCQUhlvNs/En3e4NQt
	QEKK1zBc
X-Received: by 2002:a05:7022:20b:b0:127:67ef:c594 with SMTP id
 a92af1059eb24-12a7ba464c2mr8869c88.23.1774041606396; Fri, 20 Mar 2026
 14:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-8-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-8-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 14:19:30 -0700
X-Gm-Features: AaiRm50oO8XUkHdcqi_JZu8hBzMvSHs6BH9mM-hfGMmXWmoDfSUXdpgfRzigNos
Message-ID: <CAJHvVcjmKCOPbN5oJa1QZSBtKYsxA+hW0A9SiS=b6dkOqQ4z5Q@mail.gmail.com>
Subject: Re: [PATCH 8/8] mm/vmscan: remove sc->file_taken
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4qa19htw35si8797nrj5xk8dgkft4oyb
X-Rspam-User: 
X-Rspamd-Queue-Id: 4042740014
X-Rspamd-Server: rspam12
X-HE-Tag: 1774041608-935621
X-HE-Meta: U2FsdGVkX1/WXI/WtJ74F44w7H3E9SBXYbcQ02JdvB80+c+08A8BwK+seMofMMTrSpsZt+ZMQZwTjGfc7DkKtMzcCvqMpvYzYx0tuK19VCbF9MzrDTKc1LT7A2XpFgCRxeXoG8/TLLH6JUrXuam3i2SWzFXC0eaJ0TqFRQSsl+sEmvfe6V5UjFawbvuzGy71GmPCu/LyKUc1qU5dKZCf9rGpxAanRglGdbf0hOj2Y3I4vYUnGEM5qfZkqqFqKIvYKWfPgcfH/swn/bavF9CXQVzChaLyd5s+M7bCw4VcwzEaxRvaDXOdd321FFjur1wo+1Zt2PHQbxr8tM9NAvH2q38AtiUxgZ24GfHRj5uaqVZTct9fmdsn87eDqkH0DJkXRsaax5q5J1uFetkKh9qNCEFRFCKFx60EtX31DDURMI6mE5uCAJgEzP0hugAFXH/+rl2pyeh/XziC+b6mizYB6rSCoQinZQQ+35DMmmnh2YIsTLlZzdKhV3E1+tfghfo9NZjlUdZag4jN3x4gRY3fYoc+arqkfRlR+9aN6+wL9BZSg427eNzEcLDikkcFssN8BVl3CBbxNXaC9I50XTRIyE+gZDOlrfcMFqDHi5iamDmbaCEiCaSHVFxqkAL+yx7CofpF8IdD0Ve+T8+860Dk2DkAngJIE0tTvo9CJInnVIMvf+BuaoljEiMO7tmS1YPt6uQdp8+c9Yeud6ggB6lbi2ihmo37BeCzQf6kVfUCvSBUQaCrTk60/zTH4VjnDW3fYqlbghrnsiLddtTpJBoKsNJ017d0ml2ioHnJz7Nql95Wth8C34aeG7+ktHx77X6Wbrtrv5oXptWYbF31Ab6v3wvbO7qGGIQekP9Gg3DG7JTjuEw6JnEkBCc1kTqKz+PiYYxceLTXqeqZKe35KbFDQ+2bCxnDN9DYtRdwY/Dsu/1XaKd3QDq9flnCPnMRJRialWH0cPjKm4NkG1mLab2
 y9WvJS50
 licBnvDJ815OVtj3HC3uffjOMI06hLAc/KREXNMkdCu7V0IZW5q7Xh/5N/fHJ/qZ880G9G05kTzlkjFxgWnjrWCIf0kcJ8XkKF6HR6RQ+RpM4RaiMAAjanZIYtLVv+UrXHCHm6A7AaFGAmymDS8iMFXz22TQkbxzzv0QMz05UZ2711b1LLbGd93IboljohU9z6DgFGEFvHbfmIRZ+shSVpOvNVkKIZ3uiiuS4INDrxGdrZcEDEzRNdZ1k9KDzKK7kSc+QY6y4/vtwZcIsMJDbIshT4hZ6cJk27lCNMZ/SHpLwDe0OQqage1lKP77zN14H3YlUbzGNJhalaf3dXlb1x8o+UBR4HcLpgDO1xsx8CJ8h9IgHnqyqvFsOUs1f3Ul8s2M0llHPOTIqsG+JVaOH+GGCNvjyD2AEburR/Tt6CyRCihE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No one is using it now, just remove it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

> ---
>  mm/vmscan.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e11d0f1a8b68..b95c9fc17edf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -174,7 +174,6 @@ struct scan_control {
>                 unsigned int congested;
>                 unsigned int writeback;
>                 unsigned int immediate;
> -               unsigned int file_taken;
>                 unsigned int taken;
>         } nr;
>
> @@ -2041,8 +2040,6 @@ static unsigned long shrink_inactive_list(unsigned =
long nr_to_scan,
>         sc->nr.writeback +=3D stat.nr_writeback;
>         sc->nr.immediate +=3D stat.nr_immediate;
>         sc->nr.taken +=3D nr_taken;
> -       if (file)
> -               sc->nr.file_taken +=3D nr_taken;
>
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>                         nr_scanned, nr_reclaimed, &stat, sc->priority, fi=
le);
>
> --
> 2.53.0
>
>

