Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2CA3CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D8B6B0088; Tue,  2 Jun 2026 22:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424606B008A; Tue,  2 Jun 2026 22:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A716B008C; Tue,  2 Jun 2026 22:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22CA16B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:42:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEF931C0046
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:42:18 +0000 (UTC)
X-FDA: 84837052356.17.8A0246B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id C7C0580006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:42:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GIC99wZM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780454536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRTVSL2FYqphxoCdU85m6PQz9L0mnepXYX/edVhZi6U=;
	b=mAR5kxa4Wk+XR8YCbgeu7oD1TdGN1yvPZQ3dJwbXa0bV+ayIdD8IKbrIa3ZEYa9zzjriG9
	wJ/p8aMyA4pxcssOO7rfxlPdMjX57pVkPQ957PADT8OFm0F6Cjt96uoRVUbnU6tWn/VY+h
	iUoOwheIlRbZakHyLRCETtCT6hI7wv0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GIC99wZM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780454536;
	b=Ybr4wI4sw6CWxe7mTc8i8zncQThlMqrpm1wln2K4JFaTXxdtVWNJLdH1wlMcQj6K317HJM
	88nIH4gSRhDQDgx1DZIO0GM4X2K1Z9BOYRmtr0k69zPvHQ4oQYXexRiqJ17/m13y7TGzLJ
	pJSeZFdWQSvw46nnJC3DcLSdEPBDKCE=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bebbc325000so429010266b.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:42:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780454535; cv=none;
        d=google.com; s=arc-20240605;
        b=DeatgCDtKusl78vuoMb8pmlw9CsvYnjUDUuTXyDwdEh1e8nUr9KDewAZVIAyQ1EuhG
         i/5wUyzMtOZ6DDPEx1OMGaIW41piHI0txaPgwcdgl3FI+Thm/e22tM0PVK6D5PKNGXYh
         oXC3BZcAl4ydu08BBYjd/uPyzwVaBZA7CLI7y0/P2e32DE6abB3YtGnkTqXn/4JMnRTJ
         TDWmCyqFonzUIyk9ZpOObVhAPRr0LxoQ3XmrzJChUPRQOhI8Wewf/G5yfUCEYWHbT+90
         jKpSiY1PoOF1RQ/vQ5yjsAqZ4hwLwmIRba/JnoNZqn4QilQ9GNVeJeTlokod4dqQwXgC
         4LtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dRTVSL2FYqphxoCdU85m6PQz9L0mnepXYX/edVhZi6U=;
        fh=UT3lL6fPVEWnuh63t2dYB8YOsIPZLwSlE+4paCF3TO4=;
        b=Q++U6Z2JKR6gr7Q1uQ3BPl9C0mjeWlGvPlZVg7+dytl1Z7f1k9ux/aIGNfW9kFPVBs
         hovrfRN/9sXGcKqbqkWhhvOWm6oitxpC0Fp+7JayhndSLx+Kf56NYMzMk2bbPPvI78ZU
         cFBE3NFy5mjBBnB0K5BKGUeKmn3wmQvgra4A584/dcRMHEGQT77a3JOqf7qbXiGE2Ue7
         gz8om5ty+PVab/0FpW7y2V3y9NvVMgQs/DGmx1/S92ybj6tfke/6XtOH2vMhFTi8yd4a
         loZonUJkv1BG7tgr6njHRgSB+7C/3QsC8LAkBNjBjjKQJ3AdGD7LivUziv+fWeVBNuiU
         C7Mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780454535; x=1781059335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRTVSL2FYqphxoCdU85m6PQz9L0mnepXYX/edVhZi6U=;
        b=GIC99wZMHn9mHfNexgDugCC0ciGimfMpUGQZcniVbsM9sizIbJyJqezOi6HQpapeDg
         4vuyMBQLJ4Se+RkY0XzCMTcIVNDDgGBMbD3cqbDh9bmy2QGYoFgZxP4OQ66yT0tUvIrx
         BUJb++TOCYf1IND/JjG01CRKe8yCd9CojRKVXHF9cYJyt/2v2Ai5rkzLRUB+SWl9prUI
         DkoXl9/2o+/vZ5liWZ1U9+O9+6XqpCH75dyUdwTISU0gZHCuef3GLaKnfZ05kCHY+rf4
         UVtOI8+ivxN6j+26LsMoInoqGOVHKPZGuh/BLWfLW3XaSrXvKTP58d+lnuMEOH8tz3Ha
         pJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780454535; x=1781059335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dRTVSL2FYqphxoCdU85m6PQz9L0mnepXYX/edVhZi6U=;
        b=HCkliAwip9Mho22dPdLHv8482iv94TCyvMIQOGTnkeCshtHFLuJeVEwE0zGAiv3GLF
         oVQj0WXPTsVpKYCpvRlvl+7Tbbv9v1Qy5uggri/++kWuveV8Qz//4Bv9CU63HbyR6Jx+
         kv64wsAWLKX70vVThiBoHtNKFx5LMlfwAu3BFLF6aZRtNVdAotT666mjLqwTLAFE/YIJ
         WxAQ+kMUsygegEIBEnNm+B6yhQO7GkP+I9OCir7ljXje0pDSDSdITzBaUTo2FVwEYyZf
         4hK571KzF2uMl1fA+vZAMortzLOqgK3Nvy7s6YeVOpwLstKtld0jUYtT8A5UqaQGce1T
         rsLw==
X-Forwarded-Encrypted: i=1; AFNElJ8T2GA/hoenJYoniEiAhgiicnf6LkIbvbt4YHe4xJq1+et8FhnO7Y8oi3pUYHz3t48LD+doSSvOKA==@kvack.org
X-Gm-Message-State: AOJu0YzS6tqbbaXvingpSzWmxq2szqtQbeLKBXNtPw0rvaLnFwIDUV7L
	qVVC204BMwyEj768kYQKwUeo5tZ2L+bBxXZP+jMbq2iukxgFh4hKZglKzggYthvZ69c1p9BbVZG
	Vh6F1yTItqgGgQoNj1aJ+G9EuZtuvQk8=
X-Gm-Gg: Acq92OHrJEhlhV3ypwwEipDej+UunHJNVk5FoHToIFpBCnTYPxKeo9FpAJOrtS2Je3E
	TQyusv2+XlgzKlM9ctwd+q++CbbcG//VC72TFs7jNKOzVd9eDuCBduAZLP/VY8BDl2NsbWsgEHB
	B/UEaWfO3eqys9yA6hV5OVjDkXkTHcCKk+W6j9fvM7v7kZxjlOalgg4e17wDpZQ87dEeXXDaEEX
	8B6mM7BrbUDIWgzztKQOkj3e69V7rF96zxgyFiQN1XC+f1vtiVsmR/WiAQl4NLV6gqjy9CWDfjL
	LJ8bqO6xlwD9ibP4OR28rR9w60nchU/ylCWBHoildVqtCrZCq25apHMHyv5H
X-Received: by 2002:a17:906:6a11:b0:bec:4906:44d6 with SMTP id
 a640c23a62f3a-bf0b10d7768mr46147766b.11.1780454534926; Tue, 02 Jun 2026
 19:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260602222358.49061-1-devnexen@gmail.com>
In-Reply-To: <20260602222358.49061-1-devnexen@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Jun 2026 10:41:37 +0800
X-Gm-Features: AVHnY4JDQDFGMk0a76EICNZZMssNiBFMqpzLzNdJeFfcsLQfcgQ8GLAQzkv6TUQ
Message-ID: <CAMgjq7B5sSjJPG7bMyEf0=c-W9heiPL6SQsedicyp8ahXWrYPA@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: free the cluster extend table on teardown
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+deedf22929084640666f@syzkaller.appspotmail.com, stable@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: uce5bx1xytsss9jxnmpgay1poqoza64h
X-Rspamd-Queue-Id: C7C0580006
X-HE-Tag: 1780454536-612573
X-HE-Meta: U2FsdGVkX19iVy1PFbEEwN/MG39J2Azfw7Ny3OHCIirfjZiphr8kh6dJwyVVVSZvuIlqUsp2mRpqetMGYPD0bitevaEC0xRbKFCkU8/2dOFDXb223ZOmFsm6lJLG/YRlgVMf8BNPM+EvhjjbUQiS0pN/Mmq9qYZfGIA3ZAYCXKgHM+tjKnJ4NqbqhmuNuW/fjGmkreYPJ3V0FDS//Ws70TsNdnL0vDvE39HFoMSlVbleaa8lch44TVFnkqRYIN5oChIOQA0gTMlEC9BTRhSMUeSrU7lbk2Q7Dn4EfFJuWKWwzdPPeZDVkQiXPx6Sqvx5QQSCI/vWLMxswq5dzM3vatWo5apEocWQN9Wl/+CBZFHsSADDH+k4n/++D1GzGX6s2ttA8FOhBzNsyNdK9eFMM4GmuBPdjvuUxfm4Q4kcbSPwl4OLkVeV+So9p0aaGVHbSsXwq4x+xud4jeqKGakhRQDv4ZkRPDrlngd8GyE3sgSpohp9imAEt5hZN/pEcHXhOQU+tq+VHquWx9DIP1W7dCm7TVObHPWx2LO9feCBa9DpRcMF2JX+yT+fTB91dUUvrTQC+kfxjTJ+Z06XqOvfaQF/4uKlwmzMyyLe6W3Tvx1SNJAZZdIOaQa3SjuF63QQBgVgCLtJNmokZ0vDWhSjq7HS0KsRBYUFRv2uxZT5A7+VuxID57o2uK2XBhBr2Jr3wYhp6aq0E8vHkmNGOMyVNObpocvGaqjz24Q+7XIHmZM2eeX3A7sJdkBoyeLoX7ef9u5fmvFos7FITX+y2kAQmLkY2m1G7uHzUjW/5sNa998qbhOpdNoYNjXGQdQXRcuTRKtWdhMCQNcy/ln6ycYKzglO5vnmhHAtPQ7+g9R6/NI4h4f5qG5n5brnuCfIBR74fHsP8RwBoioxB9QM3u7usWTLR9bK+mSMb7/upKEQNc6aezyV+Ahc6OytWgBNagP1UFBChNLNDjF4FMVhK+T
 zfUuSmZg
 nzecg/AjuC+GW9AMw0NSp1DvgFqGqX1d+OrqjRQnDAwvRyaZZ7GxyZfg3w1WYv77fWdxUoqvEZRU7hJaM+W9SxOic4Y4jmybCoqFlHZBhM8LtWXoiND+qZ3RNcseskaRPCt+NLOm5VvAi5WmIht9xBfq6Q4dd8ZonAvZAiIBiSdey7yKqsG9AwHRght/L54aBjOuNOSR3dwY/8m34XOXp4GSXK74H8NmGtuIVaCjR/XP5J5FO6J1cEuf/M+6ISHDeUrtczw22+4GAkT0hhYz14xT3WFNB2p5IQDwSpRaHwfY9LuvTmURdy3T2H2XWWkevd/4E3eUBqOlMeB0+ZHFD0Dj+Qup+tXxfXjn4En70TFCpa23GNUynNaxlE+RXoVnktVPeTDW8GuhKznwzuPbeiFNsWwZnHPzQmG50vpwN0yP85ImDH5BIEFMNkhdKMyI8HwgEsrYgPhFkuQPUpKq1PWaxj2MNswCGtKTb5SrNPDYT3mqVLswAO6dXOvK0wX64Tu2SOHhR3Pi3GFEpYtoVTS1okwPoIlmYpcEHwQCaM6Rxng/WvD96sLicjSZIgE+Z3d1Tz/x5WaOIpVlfOCYizGadZQMk20weaAYUqLpQ8HWukMfRrU1vrARSahqFAZdLS98LcBYerwfsMz7JgvdR977lU+qw6oz/UI40p66FKMjcO5jqudhMjSJprJGr1+mndnjN1TWwtfy0hFLnAlfv2Dh5mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 6:27=E2=80=AFAM David Carlier <devnexen@gmail.com> w=
rote:
>
> swap_cluster_free_table() frees every per-cluster side table but
> ci->extend_table. That table is only released by
> swap_extend_table_try_free(), which the teardown path never calls, so a
> cluster can be freed with an extend table still attached.
>
> It can also linger while the cluster is live. swap_dup_entries_cluster()
> drops the lock to allocate an extend table when a slot reaches
> SWP_TB_COUNT_MAX - 1, then retries. If the count dropped in the meantime,
> the retry takes the normal path and leaves the table behind, all entries
> zero; only the failure path frees it.
>
> Since a swap_cluster_info is reused in place and swap_extend_table_alloc(=
)
> skips allocation when ci->extend_table is set, the next user of the
> cluster inherits the stale table and its leftover counts, corrupting the
> swap count of any slot that overflows. CONFIG_DEBUG_VM catches the

There won't be a corruption, extend_table is all zero at this point,
the leak on swapoff is real though.

> dangling table in swap_cluster_assert_empty(); otherwise it is silent.
>
> Free it in swap_cluster_free_table(), and also on the
> swap_dup_entries_cluster() success path to match the failure path.
>
> Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddeedf22929084640666f
> Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap coun=
t")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/swapfile.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 615d90867111..a69a26aec4c0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -432,6 +432,9 @@ static void swap_cluster_free_table(struct swap_clust=
er_info *ci)
>         ci->zero_bitmap =3D NULL;
>  #endif
>
> +       kfree(ci->extend_table);
> +       ci->extend_table =3D NULL;
> +

Still a bit too late to avoid the WARN? The WARN is already triggered
at this point, swap_cluster_free_table is called after
swap_cluster_assert_empty.

>         table =3D (struct swap_table *)rcu_access_pointer(ci->table);
>         if (!table)
>                 return;
> @@ -1711,6 +1714,7 @@ static int swap_dup_entries_cluster(struct swap_inf=
o_struct *si,
>                         goto failed;
>                 }
>         } while (++ci_off < ci_end);
> +       swap_extend_table_try_free(ci);
>         swap_cluster_unlock(ci);
>         return 0;
>  failed:
> --
> 2.53.0

I think we have already fixed this?
https://lore.kernel.org/all/6a1eac8e.fbc46276.3c3783.0008.GAE@google.com/T/

