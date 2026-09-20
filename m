Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021ABC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D517F6B008C; Sun, 20 Sep 2026 09:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28BC6B0092; Sun, 20 Sep 2026 09:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19696B0093; Sun, 20 Sep 2026 09:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97CAB6B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:13:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3633540434
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:13:07 +0000 (UTC)
X-FDA: 85234181214.20.71FDC5D
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FBCA40006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:13:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kO8vjQfL;
	spf=pass (imf01.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789909985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PU/+R0zMOo7wyj2oD36GxlHMQyt+r5CHwX5Gco7PteE=;
	b=fqaxcpJm0D1T7S9ZfpilZPGYWDRdNX2zPnqjApNeJmVrpyP56qWeyME7DfzaCH6P8otXEh
	CG4BBawMX2TNPn/oI9KQ7LkwWN2pPOfsYUJcNwP2Ha/EpohKtegPBB+uwXXZ5oK2B1qc6K
	H7E7g29+S9+kaBk/PQlLk8Mmes+H8co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789909985;
	b=zbjVDmlj8hpq5Q+Mz23zAl4yGSd02oE3ZnR/p1JvdR7UO0+n/Y/ZnguxMMrMYvPT08Uh7c
	zKS1cICopBAqcE+qvMf6MC3X5RLcwfPgfP7JzHP0XbSvueusl+ViOuSEkIfegACeD1ly2Y
	qve6hTuFlIgGbluVaAdaXMioZMMJ6mI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kO8vjQfL;
	spf=pass (imf01.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd53691be5so19902975ad.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789909984; x=1790514784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PU/+R0zMOo7wyj2oD36GxlHMQyt+r5CHwX5Gco7PteE=;
        b=kO8vjQfLNBCjsxQ2/tcGoDNCVKXw1vBm4KHVyF1N2bulsw2MzZAnjUEuKEnmAraK64
         QLDyjpd/Bty28onHz7idPhfA2+9UsFL677Md85Y/NlrgSg2ufm54PcdH0IU3LORfyIyw
         U2O83IHG9k7ZulQ2n2aEoSeTiSxsd9QHQrVwFpLISRKJy5qEqJLY/WZPTimsdhRtG0Gt
         JfB0eXWLVHzlwm+Ho7tnSsSnddKnlhAfQiPliCwYx3ZI9y8+M1oEb9Y6hxhSj9ZV183D
         cUYcrAm688+xhj9CioUzNyJIR45xu1+rwY7YWX1B6gJP64aGX2dwMxtxMKKQv5va4Pk2
         jKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789909984; x=1790514784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PU/+R0zMOo7wyj2oD36GxlHMQyt+r5CHwX5Gco7PteE=;
        b=akD//y26bAQ80JuFrchjHQyOzCc/iRZDLi58qLS/p1nXQszOGcD4C1Q+74nWZyNTdA
         UrX0SkRGkCtC1H7q4df0U89bKG9+UGDBkBjDO2N+EMVhGbmvZ8E/gUJ55arF06mosVy+
         ERGLWnDYZ41wStjMxr+kU7x6/C7BmZUu5ubxJ/mI0vdHIflKFa/BL11ZClesnv6s6jny
         EyCXoC4pHQj9gbOWIg6j2YKQ+hs4nHIiyslty+lr6seumQlUxQAp7PdX0DgE/iQj53Vk
         Jo4muQPMOjK191uCA9GlbHondLqV0/Y5yAhqGegcBrI53GHmO8W7gysmgEGJzV88LAnt
         YmLA==
X-Forwarded-Encrypted: i=1; AKwUvBxXaAQFzZCCXOkERyle2w/3k5oyiyBxGUAPXQtUQ28QdqLuq+RWpSOt6eJHSId2Y1YG451b1WefQQ==@kvack.org
X-Gm-Message-State: AFuF++nWPauduSvA9H2emO5AsKj895zfoTh/WqmlEyTNTmdv3jPOwRvs
	w2ScLoa/9b0FVRroaHaUKajiX5JkxK59qWBOLw1UV2sqQwoE804l6DM=
X-Gm-Gg: AYBFou1GV6p0X5v/ZS/vEmq7RLFzkJUKPScZwQ+nTT4Rg1/9swvWUdX+OYdyMQMQYNR
	UKs3nTx9wrB3Ps5PHCbJS55A1VjWHqazDAZNEWWyduKVr39cOus5WFeVHmwPvvEOu7ze2VF15gi
	9uBbZX693IgMdtmhAo6TkiRPtOirrYs4nZRk+bap4n8JyLkdD/p9BsGbUnA1qc/pJyUwpbPl3xv
	gggBQo+O54KXJfTzaLhPvwFZZEOrdnaDpF0zwb4BGOaW+XvCNDozAOFRCDpAoC8KZJA5R2u9q9R
	Yi1fr3eireigzs78xuXNosS6l6U4t2OvLdGFlrSriFky5W29A23GogkAFYN/Er5moVjc/uM0Hqk
	yQzmEvNZkGXu5Rv5W6YklorN/ps429iGyIvbZWD0Wt2tb/THFKBryg2BtTbdTQ/UX1yTGvJKKg/
	Hllco07uvTsxsOg/my3eobL1mPkSueEpm9WXWBDqXNNLkdopot7faqs3i2rPtWbOBH/q+TZYbzp
	nUmm4D7vHYvMfJZlASiIXvYYp8=
X-Received: by 2002:a17:903:124c:b0:2dd:ad74:ac84 with SMTP id d9443c01a7336-2ddb1be0d9bmr131483275ad.31.1789909984048;
        Sun, 20 Sep 2026 06:13:04 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc179ed79sm20599695ad.43.2026.09.20.06.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 06:13:03 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 22:12:58 +0900
Message-ID: <20260920131258.613770-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920123959.48279-1-sj@kernel.org>
References: <20260920023111.2466265-2-donggeunyoo.kernel@gmail.com> <20260920103714.47722-1-sj@kernel.org> <20260920122430.610257-1-donggeunyoo.kernel@gmail.com> <20260920123959.48279-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ikrscojmxikspudqe9ne9dwkz94hrr1c
X-Rspamd-Queue-Id: 5FBCA40006
X-HE-Tag: 1789909985-405339
X-HE-Meta: U2FsdGVkX1+WNavyCOOFuPw1HXui8ETCfGNU8JhSGJB5p7C/ShjMBWwMhS+UB52DFfNAVFeLpFCI16iHtcGqpJ/LNh4eQQj5W3tjA7gkpF5Zv88KJZOD0dT7Em6umGaACIiYMdmmK2D2jSFfxwBVfpPHrYM3BTD/TG399wVEq+9DcSFH9fuBNURKgNAG7EE0uRNpDx/fIEG6ToMeDxbnxNMtbI0LKDyZPvNY5bkixBUdvX/q2MczDwUE1GVd7KMfmPi3zOaoVXJIl05sdo1CDddU/f8tHfLGq9RXna8hPGMARmV8DGYnSumIU4pqlq2nBlOTKNB7OTmR8ybFsuxTPssKm4r74btOqVhjUdc5HzKRMU8sUNtE9/KEWYidV14XxStJk2QmY4KuQ7eoXfnv8wPXVVuNgokzLf1hOGjkHCdg5tf2zvOvGiwo09Fv6c3SudN6be0IEY2ljUaqz1h1ZVJicpYTsxtYsH+k/GNvZngi2AwX6umNbE422k0j9qk7SphCiltr2hzb6jT1MHDZKXepdnc/o+iQc+FoLpEZsrLyD6mClx91akpN0zx4K47KdT/hJAY22bHAjFv/zHk5yM244Pmeg5klAmXUHq4vnAuIv5exqrXxvDygfLlsJSU9M6/V43B+C8O2lu3OYXZ+h1wq29lSG5dpoYToXtRZegcVadVRMdrPs5//HbIXaoF61V9NubyO7V6T9MNONKzZwTceeSo2sXjjcteu7VeEm46yjPquMvzz0O+wnCi2uE7ycS0Y7onKMOhes4WRHpDe/3BBCaTGW4/GwELspDEsw0FA+HOIA4JEB8F++yHYPda0A+MT7bf7f2fY2ucIU+8HUgvhOnOK/imxBwudvLtPPz08NQRG/yk+c27ozTWp1PayexjRHUVB0zUzeo6v20IBtza536UpAGZCfZ+hrPfE1lECAWreeG2gvxyFibT4WAPPQacnZQsdfcNWdyDIfbN
 Vp0EBLPo
 Sg2h9EcD8VJ4xziQBpFXcmrBbabLgnprf7REh2WpPDZlXETEiEt5ijqQvNIEgZGlpiXj/fxgfU/ut07MSaZY4CHlPR8EyvQD3bTr33Afvpu2yuXTWTb8ymzIo8uoqKpTF5e8oUTvTYB4HTART5yvTt3YuKY7YeJrZ0SqU7iDM1gESdpbvEfqo3TQ4uwp3GMwjBDxolxJrCJWSPXtLIDaNTZhINAzQ8fFGQMLOSQR6pjiozrQZKzzvv46ulf9GRXVvxI1sUGJn5o2h6UWkl75sGdua9zlIyGBp3pXr0ACiExB6KfWhvjXC6DBmEYcP8wcnygldJ/nZk4LKCe1SxqVfEJwfHEMSXL4RSZOf4cc+yyuIUwNnK7Ekd/dY7jjujH7nyfUnS94/H6Ii4jqOjxfNB2kwAyfN069nAfLS/RZGheHkUaL3kv39bmhGhIVKoucFZRz+A53E+1sF6dbYDw2YtdTJAzhuc0AtT1H2q85oB50myQ8eZJw7XaUakSBAJPXczS7FuvZ7dErj8PJ3n2JRG2WroQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 05:39:58 -0700 SJ Park <sj@kernel.org> wrote:
> Don't post a new version without ensuring the discussion on the current version
> is completed.  Also give time for others to chime in.  As a rule of thumbs,
> ensure all questions on the thread are answered, and give at least ~1 day since
> the last comment on the thread before posting a new version.
>
> I will not review the v3.

I did not know.  I will keep it in mind for the next patches.  Thanks.

> So 256 MiB means nothing special, isn't it?  Why you mention it?

I mentioned it because it is a value users are likely to set, and it wraps
to exactly zero, which I thought could be the worst case.  But the problem
is explained well enough without it, so I am dropping it.

> Let's put "The scheme makes no progress ..." before "so it is unlikely ...".

Will do.

> Seems unnecessarily verbose.  I'd suggest keeping only the first sentence.

Will do.

Thanks,
Donggeun

