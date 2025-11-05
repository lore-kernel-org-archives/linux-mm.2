Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70540CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 04:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08388E0006; Tue,  4 Nov 2025 23:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8CA8E0002; Tue,  4 Nov 2025 23:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F58C8E0006; Tue,  4 Nov 2025 23:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED0D8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:30:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 354AC8604A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:15 +0000 (UTC)
X-FDA: 84075276390.07.CCBE6C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FEC040006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIGnQGx1;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762317013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06woPWOwQOtZNwOFQo3C8Fknt3FAPql9ZhOwy3l4Q5s=;
	b=0svKqN176vEsFg9cuWmHQAiZbWtlS8rdbkK1Uf/XHhhF6xpJdJtdqD2A/dNSCkk5fw1wGM
	A/KUbzZSKp0RoZzEjNROONUmMuxx+ZCwk9bi7SCvs3O5rewckckwrCA/rF93yuYWdRuDZ4
	TSLybfPX5gUJFBih0yNuuLzGdqKk4Rk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIGnQGx1;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762317013; a=rsa-sha256;
	cv=none;
	b=WIWrMwHLTuTDHWcO294vxw7khhGw1mEaBf7QY0npqGFUs5lzGGUYIQ/VgSv0Lqy7DtzFAJ
	kmWCZabkU0Ca/zdcDAaDtF+AxIWVcYwKFnp55UJVWfF59Q2HQlo1YW6r1ptZGgS5SuEGuA
	r069JFRI99wS6NgyHizUo4A4ZfpbBLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92CE060211
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A3BC19421
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762317012;
	bh=G/qCxnB36EpQNhfOT6yZW99z2x5Df1pKZ3J9/Srh9Gk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WIGnQGx1BiRBWNasEgXGgOHz4TfKbjlpAUFR7SHBZauD4a2qXWKUWkh5JShfEiVx8
	 5eCiw3XpoNlf1VHZK3pGwY8JxUhJHDWvqKoAevPiG/LL+x8mBgjplf4nu7vM947Rc0
	 PCvZ5X+0Oeqw9IVO2/e53l7eXIk8KiqbcLMenCg6USvE56YvZ1x3qbMa1ErpSUaxld
	 iR4iWCrBJlF1pu99iFelX4MG5XGLEQa3Wd/f4L9KO1fgqZjw35/er+e7k9UqQ1M22g
	 /QGz9K+HJdWa7l9DztdP3qIf1CmFoIjlJT2/iL5wtpKRc8eTLZbRV/m0/v6exWiMEN
	 nPCj8Pu1pSwXw==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63cf0df1abbso6659231d50.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 20:30:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXMz76u2cHI0R6HkrI+V4kACk1Ph/YMP7OtkQ9exnnsyQxYoZ6QmsxZMuov64bIzGP5xtfklNlh3A==@kvack.org
X-Gm-Message-State: AOJu0YxRV1Fd8MLguusHnGPtv4W3dXIZnMEqxSvdj5xivzSa2WAv8D+o
	5fj+BbbIiUSV95PvZGpF6YZ3ZCcYqd9xqiJMQECJ7T3xMiGHeFi3eeibztZbDQkfYbz8Iz/bNWD
	85lBvYUiap5LfyMTuayNli/RMrTwnwYtRI0B8pfbhMQ==
X-Google-Smtp-Source: AGHT+IH33g5FnRetLaV+B2cvyq+Sil9CkgltDyJbE+WpAnXFrmxDGMPntaiwOV7n3KL1ni8IIFhrSUi3NSnTAjjHfE8=
X-Received: by 2002:a05:690e:424a:b0:63f:c6b3:cd03 with SMTP id
 956f58d0204a3-63fd34b6103mr1396353d50.8.1762317011548; Tue, 04 Nov 2025
 20:30:11 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-2-youngjun.park@lge.com>
In-Reply-To: <20251031065011.40863-2-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 20:30:00 -0800
X-Gmail-Original-Message-ID: <CACePvbVh0tWth+WZv-CS+1bHFhJauBKGG-0+QzSfA+_=Kruj3Q@mail.gmail.com>
X-Gm-Features: AWmQ_bmX5CGCUlxAIv0nL_kujRgA2ZCOYLiUfzWjfRRtCR8FjiOg1-a3W3PK5jU
Message-ID: <CACePvbVh0tWth+WZv-CS+1bHFhJauBKGG-0+QzSfA+_=Kruj3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] mm, swap: Fix memory leak in setup_clusters()
 error path
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FEC040006
X-Stat-Signature: irpzkceyrhj6opz1bhgiqm8dzna5dxqa
X-Rspam-User: 
X-HE-Tag: 1762317013-840635
X-HE-Meta: U2FsdGVkX1/maAVmMp4x9XGDDaOPq3rYLl3jOVE1/l28lMy/VPcGZKWiADkHSQHP6JlP+Kx2t3Pm6sxP+CAUib71FU6QhS+VtZ3fZt50w7lc9J60T+04YVVjQn0QsZ9YpyEbr6Mxl8/To5Ut0iDEDknyYmqfK//mn1b+heuUFmoP9C/tuLZ0074pYan61tvoAP69J1RCu3YtnrUtSKGpOx/Hvsxgogvkwi5HEhW17JUrzwgR6/DRuj4Xo7krKOxJ6yqQ6lEuxNyFEDWshG6i5s+PcS0ED2AXkLbLWelaRnOceAksuw2IJyu8zNqIYbOh2nal20LlwQG9p4chrkJlvBNqAL3VW1qneAVwTVUz2mGrcdyVyAuThivu8k1y4Lf0bqqvWtvPUqH6LuA4hxhGCpRMlX5V5/hSkZHVin+C+ZaYXD6SZmkrjEtxUZWapFFcd/szsxUN3aT9Czsx+1Rt/ydi1KF8NHt9h7dU1romqWjRUYcugo5V9784zDcL7pTYYBK6jhTi7c9SJaSUzAbrmpTG3GohYzHfCAo9udjqGA7/4xGSa3lzsM2gLw8bE6YoRYJ/MyVN4m3E0cj1SBXWDu6DYU3KYQvmocYDpy/Nm/rwW5LUc9FzF0ChrBWnipKi9mMMkd3LbGM/1tvK7GnCN/wN1XZhdlgCsiK795eouxTnypxcPAA9D+whMH0PVNgkHxxhfd/mc0rkxRGMgZXNSeqxWIaDap7K8UxqVtztk+IXsx5lfhhMWylYAxtXVAIoP1YQrpWXNkCwFbg/FSaANCe9mcqGdXYZ0U1z9l0ptAbcQKsw82IgPZP1LgPJM0YYtjCWJTEpAJLbvtFRuDZIdgSN5fRVTfu7/2D7rdob/lzozK4CTi7RNdTlAOrVCnreDfdEo0UB49RcJrt0+rgNd03SGWwX5WyvXqRMALduChq1UfohdSEB/UYgUJnQPkT/lyWESLRA43hGP4c5MzU
 nGHk9T7X
 6+Lcq8nzmp3xTGg31FSs1v0PcJitjx5VRXnEpT/71dXl4/SoovpeHG09OOgGW5hiD0ZZbYcrelfQamrVOKCCHFWWL02ZxUW0Yv53GCyZ/EB+5pO4LXYfA2qksp8e44pMX6T1cx0VY23Xh67axeaDFu+9rkUQ4U1B9i77m/j5bZVY0nEUtWwS7gZrpPNXEilmLNFboqDGdhyUmas20VcAQ34SRVli9mZDmWRU3gfm+rBPm5wCBYrl7ps4294eVHlqSSaUO46E3aGo4n5vwpTqyRWtK+3u2nTOXLU3KAAoawpOXRXNtr/lTgqhVTWKnp36y9IRmLN1jZMzOg95xwch/hMYDWCHdxiBHPTfjJoMnFW8fylfqGOKdYeK27mss464c5OAeL47wSAueRTvzr9UcEyqajA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the late reply. Has been super busy.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> The setup_clusters() function could leak 'cluster_info' memory if an
> error occurred on a path that did not jump to the 'err_free' label.
>
> This patch simplifies the error handling by removing the goto label
> and instead calling free_cluster_info() on all error exit paths.
>
> The new logic is safe, as free_cluster_info() already handles NULL
> pointer inputs.
>
> Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap tabl=
e")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c35bb8593f50..ed2c8e4edb71 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3324,7 +3324,7 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>                 si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
>                                      GFP_KERNEL);
>                 if (!si->global_cluster)
> -                       goto err_free;
> +                       goto err;
>                 for (i =3D 0; i < SWAP_NR_ORDERS; i++)
>                         si->global_cluster->next[i] =3D SWAP_ENTRY_INVALI=
D;
>                 spin_lock_init(&si->global_cluster_lock);
> @@ -3377,9 +3377,8 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>         }
>
>         return cluster_info;
> -err_free:
> -       free_cluster_info(cluster_info, maxpages);
>  err:
> +       free_cluster_info(cluster_info, maxpages);
>         return ERR_PTR(err);
>  }
>
> --
> 2.34.1
>

