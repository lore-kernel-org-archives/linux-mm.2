Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7B1CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 07:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DAB8E0006; Wed,  5 Nov 2025 02:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F478E0002; Wed,  5 Nov 2025 02:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D260B8E0006; Wed,  5 Nov 2025 02:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0A198E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:58:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B55157520
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:58:32 +0000 (UTC)
X-FDA: 84075801264.10.634CA54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D3C840003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:58:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6ObfpKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762329510; a=rsa-sha256;
	cv=none;
	b=mLOOlUfkv0KziYeZCErtFGOKK6tPwoPYsVxBvUQCKuA0k06lv1sQqRxp5IuwViswH6Clfm
	n/tnq+r+wGsJUcVBQVn1dZsey9IG2lt5dlUiUmQI3YHBDyFbQcjWnyz/GAxemCTw4RWluy
	5ziKlU12Iq7JjQuczjBRmti5ccjM6UU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6ObfpKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762329510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRUcTYDxUrCCV8bR9IPIq4SsTn0QDo8RSisivpq1rKw=;
	b=8Hu/vtfDWz1aMSKv/vWenMWGc+3xHYTaDagG9pUrTzaz0MJz19uaozRsvwTPjOA3OjQc0i
	683yHgQXuDgDn7f6MUMU8wAmXWthE7fTMfTMTGUbHrwCY/UtIYovjm0RtTzx90G0yKN6aB
	37iZ9PTY/mV2IcDD8Zsg7nerpjlo4SE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC0D960203
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7CDC116B1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762329509;
	bh=3pNy9QxClwj2kv4jlqSGeQTQ/zml0Gy0XSJJ2Ks/D0w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s6ObfpKVXLhJI7peLyLlBpv4c+cGeuzM0lpFUk2LgXC7daeBirLtkqy3Uko0oWyCb
	 c5gzwl6LgMVt7L8zlZg0J9DpP1N2/Y4NZd2X3M76d5TMjTA6TDVk7MDEUL0Y//dTky
	 QF9XUtwuPidYl4WGDjlpFzkBuBZgZpHhiJXvV9VRLYg5l1NnRzlI959rWt7VsUgiH2
	 wcGeubbjYoNqmcb1FfqBfEjuKP0DsgD4IJGf9k54NmrIWylpwMH9gdvF/MgtiRdsTQ
	 R1sl8aeqLixcxj7chin5Syzy9/CJoRKYsJUGQ7hKl4BP67JpNLOXTh+GP68j8if1AT
	 9D3PTtMiD5D8w==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63fbed0f71aso2396934d50.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 23:58:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWXIh2DX2pGoAI10fNmalAhVF8iBgLu9RR/EEAt5LeueEUgieqpZojaUo274XUDQzw92FlSdsZ3Yw==@kvack.org
X-Gm-Message-State: AOJu0YzGTwVqo60nILa7THsAgy1CN7Sx2v1FAsxpA9vkFsowDdBZvJw+
	NPrr6kRUeY4Tvth9V6aQL80c1N3spIKtJLEP8t8slsl9QddiWRgixmBSTtJmCyAto3yGN5ONsaN
	VOkVJzcpWeRzqCmxt0hUwjioXXzEv38pdLY408Q/ZqA==
X-Google-Smtp-Source: AGHT+IGCh0MJ44h4JdM1eWSh5wtrs+NM5eUff8w0BwpFw0BG93mIVLtbT8yVFa3NnS1oBap1cuYit24TVsps1IZD0Us=
X-Received: by 2002:a53:b10f:0:b0:63f:9f8e:3891 with SMTP id
 956f58d0204a3-63fd359e6ccmr1561033d50.55.1762329508793; Tue, 04 Nov 2025
 23:58:28 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-4-youngjun.park@lge.com>
 <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
In-Reply-To: <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 23:58:17 -0800
X-Gmail-Original-Message-ID: <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
X-Gm-Features: AWmQ_bnDDurF8c8B1rFrtDsIWioSz-lnVyCP5KT8n6G3vARUHflgX93x2qcUdZU
Message-ID: <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D3C840003
X-Stat-Signature: imr957hdox66qz38xgcpmor6e9i95drz
X-HE-Tag: 1762329510-703466
X-HE-Meta: U2FsdGVkX1+XUBdCvVc9w7HxQApTXcfxtMqGqHm2oyjdhN/rTNn0QwA7GLHc0rZUIvXlkJz3L63WVSmrPL8v//Gc2k1fjjuEXKoSLiSEtfS/fH6nAZDBDrrK4y8c2tiXZLzWFQqSUMoMUtc9kjov7/1gVI6+Vqe5ihwF3hMgIEn8Tw5+JiaVCC6pe0zw7NuEc8ZRfgzA0Ci2Ed8NPYkxeInwq+YMgZr1fFSGlueIb4+nmMAxWhPI91Rw9CJgWWn3YHdrgB/KxxjNb6E7V/6Qcw4TC5mITefsvd6/xpVKyLpW09DXA/xBnpYg8uUT28L4w48THdX2mDGxWVLwnotPfY8bUD87Qdc/8OO1IUqH7hW0A+P268eDIsrFI/KUw/Oy+OeKjP91ReaAHT0I4oqeZzIUufzkN6oiE67D160RAQptvDM/ndT8sJ3N49a1pKMVOV5yd4RIZQN5ouYVF/LRZyslGpKmdUwv7yg0gmjxGfyA3fvlWkBOyo0mVse/j5RPiliW/IlXtZML1uKoHTs6GVD9lr7F5eiqBg4N8XLk3/ye9rpsUMeaRUaN+TwPRXcoitgj178W12sj1Yl8eYo3slwEJo22gCBaYrRU5rm5wZdBYXvKvC9sjD08VAy2HDkWaOaCAdkSahP8b4WbTlhKV+d4VTdi6IORe7JN76J7RDSnszB/xZzP2Xgowqos9e+CM2NgIPJwaqB5Z1yuB4CBEt+HmiGyfKWSkSRDZSql/6oGsmNjxe4CNUj0jtg0XF798ApjlO8k/OLYbiQRvpN7DFt8ArGNLGAWj5WQNkDSDx631j5dzpDH9JjlX2qWMavmQ4dla/krrwx7xguNynJUgDD/h54GRM7f9CXO/mCdGYv9IYaQV6XH2gO0pNhaERTiUwp1bYn7+glAiGlfLd38XwXKVSjRkbCZcwf8jKVColmWEh5L/Gt8nBMSR83KwsfeO42miD8m670RXfZgr26
 4mLiqiOL
 wTCt9W6Ph50E72xNUbQNx6I4uI3tBZm0Ta3otDGxSDj6QUsjOx6Qz0DM+QbfZ5Ts0dO2NdsmL0GZEzd+zwQyMD3JUXgpSBHFePnVcncbI0UovEMYaIfPgII40OwDj9tLp5HpBGXz4Re1abtvoOPOE56/bgQRN0KQ7ajp4sOMkfsrpHKC/Enni7dp5wWcq6dhPHzqqBQ2Voou6MA99PC3jGgL44sDV9JbeKzgl00cJe6JwuZl8qXhcL6skUbuKQ4JlCavpiafpkiXBbX8Q1skWeFpWbpjvCvPOqfE43FlUEodPPu4D/PIBFXjf+kgus6HhJbgHcfVdptK25bLhn43dysFcfvgRnEfGtsygLZkf4hUH+kEqWE8nnzwLbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Actually this patch can be dropped. The swap table phase II 1/19
already addresses those comments and fits my description of what needs
to be done for __read_swap_cache_async().

Also, the comment adjustment is much better done within a series that
actually overhaul the code rather than out of series pure comment
clean up.

Hi Youngjun and Andrew,

Do you mind putting this 5 patches series AFTER the swap table phase
II? It is the comment adjustment anyway. If there is a conflict with
phase II, I think phase II should take priority.

Chris

On Tue, Nov 4, 2025 at 10:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> >
> > The function now manages get/put_swap_device() internally, making the
> > comment explaining this behavior to callers unnecessary.
>
> This commit message is not precise. The previous comment explaining
> this behavior is not just unnecessary. The comment is plain wrong. It
> does not match the code. __read_swap_cache_async() does not internally
> call get/put_swap_device() any more. So this comment regarding
> get/put_swap_device should move to __read_swap_cache_async(), the
> caller of __read_swap_cache_async() needs to manage the
> get/put_swap_device() or by other means not to race with swap off.
>
> >
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index b13e9c4baa90..d20d238109f9 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -509,10 +509,6 @@ struct folio *__read_swap_cache_async(swp_entry_t =
entry, gfp_t gfp_mask,
> >   * and reading the disk if it is not already cached.
> >   * A failure return means that either the page allocation failed or th=
at
> >   * the swap entry is no longer in use.
> > - *
> > - * get/put_swap_device() aren't needed to call this function, because
> > - * __read_swap_cache_async() call them and swap_read_folio() holds the
> > - * swap cache folio lock.
>
>
> I don't think we should simply delete this comment. We can delete from
> this function but please add a comment to __read_swap_cache_async()
> regarding the caller's responsibility.
>
> Chris

