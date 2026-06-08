Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D65BCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986046B0093; Mon,  8 Jun 2026 11:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D266B0095; Mon,  8 Jun 2026 11:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A456B0096; Mon,  8 Jun 2026 11:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCE96B0093
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:34:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27927A019F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:34:19 +0000 (UTC)
X-FDA: 84857141838.02.4575BD8
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 04E791C0013
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:34:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKCzATxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780932857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFvuwvkDonr76BkGGSbGUk4htZBG2nwk2+RBVXrmVU0=;
	b=N32jnLc46wnpygSL6jft7lfGQ14X27DVHNBKd6tk9VsYi5/GYFbtMGsyKM/goh/cFwdgMD
	R+3OF2v5abL5VnQjP9V9tTKL4YOVlAtZiqjeeGXYNOO4rTcsDhY1ilVhmJMopdaVKtBeae
	DmmQHBxqeMIo50B1IbAot0/ViiLpxDY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKCzATxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780932857;
	b=6b1Bq0ojFnXlhk3/2rwtnQd7MWsP21DCAC3GHnXI8g8TlvYsPOErql8/4qnNYxZgP6dio3
	YGOm6hQr8MMz1szbHqSxaAspWJvybM9OKuU0B2zgD0G+UcnJjWz7Fgc1rpP6QN1nvHeUe4
	qElT40hpiKUEGRY0CMUHCMXOgu9zdls=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef29c5561so2335535f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780932855; cv=none;
        d=google.com; s=arc-20240605;
        b=dMVc09CqAt9tsrgAV352bf9wYVmzKshJTOAG7VPQ3jlpbgAwYfQcf4SbvOVi23uiix
         cJh9n5bL8SMAH5oQlrSLb0pJuaU9rtNs7DVsn+Ahn/sL2Qa9ECJKYEMdx2LlJYDfI+o3
         qftIwyBjfnngimJM1YIFuXc/JUsxVfzmC5+So/5k+DUOJSZkO7jNBVVkng03SAmmu9G+
         w65sD91xvhkIr7LNnHoDWA02Mwb3TP4l5YzstJAqt6MHisDocj38DYbZi0goNx6TKZD9
         8Y6LpIQJgJIwoLnQ3G6QgAC3/9vveAKvbKsdLjYgz4zDMTVVfPXQ/FsDlElyzwWfgndX
         1Dlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZFvuwvkDonr76BkGGSbGUk4htZBG2nwk2+RBVXrmVU0=;
        fh=+ldBult9OTVOkv2PuQAPSayg7D6fI0eIAjfMWewZyhY=;
        b=DhKZJWCUrw9DM5rKW8WEEJBfOFTzT6OXmXEsA8xNGUEaw/XZ3671XF6fFzFaE2GBYC
         xz0Qn3vWdH9qLdINe7mzJ4eKOfaHqMvtGjgEtsH1sAZYTuIzdf4enQO6Bm8O3nZ+S86J
         JWQceCUOJGCD1AhpTJExrxcS9kJEbxsJ/LZ9rZiaoxhNEHbAmG7DkDzeWlz8ZerW6kxR
         97e+JiqGPhcV36NDjthzuM9craBIJ7eZr9REXhf9zpY1vmbpP6pWWVALUhWqtPUckp5F
         KcsOSuOQkDzf0Qq3RukjJXy3uawyIaHzOds4KYnWv1P4j0hCT9OCfdTFlsN3LP0pybEb
         g5QA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780932855; x=1781537655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFvuwvkDonr76BkGGSbGUk4htZBG2nwk2+RBVXrmVU0=;
        b=SKCzATxgLYWGk1qzoejcgFvGbHPTXJqsVqwAwOLJ+Bq8L2WjH2Iqpptl77n6y3Ww7r
         sizXaXBmOfKtbUqRqa66d6cIJkc3+XhgAaym3x2FnyJy2GUI6V48kqSIsRb0oJzJ0MbL
         dq0ZmC4rUk+bIxiLE4gtAeYGHYXsXJRGb/57xH+FyMUydzDEFxKXPnBX4htSdIZSyvR7
         LS6iHZkQque1pWj21yDLOR9/LAJKTuDadD7XTzGve6yyV9RIQiz4vFtIUi5jRGeHIvyS
         1aOyp6AmbQuBFzkdzTT4IEjsUXA9bxMNqaOYZQpqAtiVtD7Z4vT+4j88c90HX+3BZkHm
         K4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780932855; x=1781537655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZFvuwvkDonr76BkGGSbGUk4htZBG2nwk2+RBVXrmVU0=;
        b=bdvVWX3ABn3GulKuF8YqBs69bxtE3yzQIRVrBm0ZO63a0FkKOEst9g5+I9l7e7ZUey
         U0Z9xDWfVe2uZLXvPDSveVxveUNH+KMbKM0Fzn0E1Y5spRGuS1R9pogXvpgglOERWRDJ
         QFl9TjZvhPG3mgJHxHsXa63YvfPrPNHbpVsPre3XC3YW30HUffHqLGLFzWcTbFwQnhl8
         TEACPfy+wNyERz1JvBpkDCxtgotA/Kwd6Rgq1Wk6lTIev6jGry7pUVMj9gSvRTDzJ38l
         wTUCXFnF0RR72XJKEMwojz//wPsAg2HSlBsr/E24iiowVyJKwcFFpDDiR7fxVLNX77pV
         nz0g==
X-Forwarded-Encrypted: i=1; AFNElJ//nKiXO9P7kEt3yK7QjQdJ9EdQbfkOpQ+6ySLWUFFS4N6UuSnYMBB6WTjhvyn1yR/ZjwxyqKa9iw==@kvack.org
X-Gm-Message-State: AOJu0YzWF2Sq+/OI764Dwuy+45r+fSDploF3Nhzhs3X/6RVB86+BuGfy
	kcu0u2Otw2dcte63yxkgJZ6wvBpTfktGqjrAIC5vaF+hnHR7wXWcbQa8PfKmcGIam/YRpQ5SkA8
	UlYtkGleUMkipavryHWEVrUQFa4+d++g=
X-Gm-Gg: Acq92OEl818cHkZuLO9nH8S7s0TNMeE9WaZpdsuLAmy9SnGKmmraxT2pp0f3vpqOpEV
	eS3x/8VPA7CpGo1Xtsi2VNcg5i5HK6HcxQ1RHrjAVH2OaHIsCIiUVEZtNcdlyk6zNTNMqslTEvL
	MuxFHX8npsgmKxtCP9JrVl3+fjFYd0sZA6g5z0MVdzKOM8AUCOIxAgxk1ybSQs+rWWINfhcBqEA
	eE24zIngpNjuCJCaFk6QIzfd2kAl8gWsNK1CrxgqhufSLgcqSHo6K+UH7M8TWu4FAFOfh2pkQqn
	wU4EDOoizlraiK8XtQLzhNshPddhWvsTjOghNejMzPvsVCIsKQ==
X-Received: by 2002:a5d:6889:0:b0:43f:e990:2f5d with SMTP id
 ffacd0b85a97d-4603063423fmr18604006f8f.35.1780932855051; Mon, 08 Jun 2026
 08:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260602172247.279421-1-usama.arif@linux.dev>
In-Reply-To: <20260602172247.279421-1-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 8 Jun 2026 08:34:03 -0700
X-Gm-Features: AVVi8Cc5wyMI_tEU3dU-rJPa7wKWvNruGZq89TJMne0HHa-RaHGj7rcJpBdJers
Message-ID: <CAKEwX=NFAyzvZjikP34onoZwJoQEbH2bYh7KxR_CFNM4v67iLg@mail.gmail.com>
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 04E791C0013
X-Rspam-User: 
X-Stat-Signature: nzw9wg9dkmm5hasyezh8ipujeg18rmag
X-Rspamd-Server: rspam09
X-HE-Tag: 1780932856-964507
X-HE-Meta: U2FsdGVkX1/s9f+0X/+6PPJSmewrIA0RGbV9FHTj8NQMmG1396mhikuP8O+5UWWT57Q/JOUlKiyX5HTyxciAqh2WDjglDmvfb1ODUKvCYHhG0ioLNb38gDojv1QWKm5XO851j682jwrYHi6bVZc7P+J63WUOAtXPzPrG0JbZVUiiNHvk36YSVz/uSyktyJqvczygKZRqx8f0STwdN/G1MMNsb51hyLhXAtjXPvoGr4oqqng8By5rKxGDLdjsFtYFcF9h54wcrbflScqO5nlSf0CQ6VgWnLjxNCqbrjY+D4k0ICosSVpMTO/x+WTf2Pzu8gmKEBKFdAcB9WHXpVvhQNM4HnCfYe1N1/KuDxkIEGUpQR1drbTQmilJ4DKASH6sWcU2f3orVYAfSHFKQPngKVjnmPhR/mk29twiQBAadQh03nr8FsQcIRqjor+3OEMOjxBFgh9qN5kPQcA0Ct0GQamkRjJqRXpXVjxti/jvScLod4TwXyBik0jbwHQRqzJ5mYjAynUaaw9dsdRwyMrCB0bi08YDvcqa0FFLz0fjllRcvZkkTx/gMyk81m/y+BZ9LrTAAoNeyRSSMjm80tvUi5D20il/00IhMqTBpPtNersdV+ImH1Gy8OgdhiKT+CwBaG5UN6U99UQezQl3SdXDmdKDETAw77eMYQ0+7pK5WG4dkeQ6T0eTG+kAYI6Kfbn5rOq9e+rO2BPRzr/a6gwblJaiI42aKNNMWgKAIFq7hk0Wo5uxnuCGXuWzTUpTrXikG4awJuRwNwswYFSDAYdyRrtAXDayb+wJl66yZXM2e3tzfYjy2yXjcmFJrDvb5yAntUGy7OIHrxsjCIDADtJBQYAfCMcBrNzFH550kfAVkOK5Gfmfv1CkXzJBwxmNLQZ9hbIOAErR3jtWQycwqt+jVVei84vU3/tQmIMGfgr1h6eG2h94LF00dn/Wt1uCnyvvt61op5EiADMqv/T8mCp
 XMnbSrcl
 h+CrykWThgJU4JMNW5M0OEELIgBXVix7f3c710mBQLs/hli+nbC8kMSMHM7/rwDHgPKDw5yf9y+aLe/fjh9fz1nyncLxQrZvTGZf9TS33i40aJd/HMzxrRkKdFhWPTC6BivVXTkaXzPurQN4M5eV+91AITY/S+O1zUc5wq6oXXr+SUC9z4VMQB2Odvn+UzaPOfn/p7G87BzdItT32MyYQjosKgDF2cFpf4/lW5bcF2Gx0VUmt98Vvn/TFdF2BHFSHLpousHYmm0eWMfBsv0LO/7A3aNja6At5XGlRCy6qjMFxBgPJArGHzM5vJgIEeaxdHXQrHuGf/swU/x5hc1xvSCjnT9K+oWbCO2rNyJiHTH9ubl6Reg998Ln9i+NeuC+sa8vpcmo5FOlGfkX/l+VdtXTmMFIbRRp9YuM0ZcI0FEFRzpAO9FZNM+T1smjS5lwhWWk+dq5vao1Ywsio0X9lNhqkWxrj6Dd8IYDQ9zFaSVJJoO+QnB1rBoGTFks/KptojWEbN6vOXR8DwZufBOQJH+Hvn5frZQio9Am+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 10:23=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> mincore_swap() also fields migration/hwpoison entries (and shmem
> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> return, so mincore_pte_range() can spuriously WARN and report these
> pages nonresident on !CONFIG_SWAP kernels.
>
> Move the guard below the non-swap-entry check so only true swap
> entries trip the WARN, and migration/hwpoison entries take the
> existing "uptodate / non-shmem" path.
>
> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cach=
e")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> This was discovered when working on PMD swap entry series
> (https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev=
/)
> ---
>  mm/mincore.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Acked-by: Nhat Pham <nphamcs@gmail.com>

