Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00D3CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3446E6B0088; Mon,  8 Jun 2026 20:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B546B008A; Mon,  8 Jun 2026 20:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231B06B008C; Mon,  8 Jun 2026 20:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1760B6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE82E1A0246
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:19:53 +0000 (UTC)
X-FDA: 84858466266.11.91D5790
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8573100010
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:19:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EWPajVLh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d98c6s2kvLtGQyL/fPqKwrvfQEsZ3E8WA771oxSRxZc=;
	b=vN6YMFfFxNn9NqGpDrokOiX5FVHl0+4MzyoT7kvGX09k/B6uEz1JwsPzBqsObch9KcW8Ra
	8pZNWuGjBCrxwhIVzy3WyQyJntEtOzS6xi1/o+nkyB7jFcvJtgRGGeEpS2M4XKyLj38x8E
	p4yk1xcWUD/3bOL6U7ZS71yhOOUL788=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EWPajVLh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964391;
	b=UrlG/4SR7OrL6kCOE7ut7yt+1ixhHLdeqhpSOSV/9XNNCKiRZ7FqD+Cfc01brGlXqsjMiC
	a0DOOQJE/1vBJERGyIwcdhk3g1NQwEWYrFPQGKyU0MpDaWWQXX/X5x33O+PJXg4FYmtF8R
	MVKh4edqh//zxvPp/53bmP01oCgfBNg=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3967738c801so42093011fa.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964390; cv=none;
        d=google.com; s=arc-20240605;
        b=ItaA3oT1b3UWMNWSRKJ1ME9jGh/wVrTKz/ywOm+JeUqp09RVON6MSYAVVEvBLtX7Sm
         mYbvVZl3pjTiBnGA820Jlc3yVmV+pjfwYUW0rYEv6LXfKHOy7U2uh+mwMk1vQjQMpHoI
         VYT3jjw4xhiKLKlPjKNKpg7a+St/g4Ma4UPTm9AYOI6rjgeOkPeXuRh3UhwthC5lJz7R
         z+01UCI60nvNdB/rNH5dKPrf+Lueihgmpt5IejLqBkPhFxrXeXlB65FJasEvfRzO3anX
         vMcrqzKBaWecucBc5UvMarhWivq465J5kQE28zG3giET/fGRGXJDDsUbEoYs1YjLDegF
         hqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d98c6s2kvLtGQyL/fPqKwrvfQEsZ3E8WA771oxSRxZc=;
        fh=K7Za8RQ2ka7bIHWrSglaTx2jEAipxTu+k4Pi8o0C3ss=;
        b=BGKZ3at0gKUBF/fM0k5uJ1cYO7M1Fp2t87Zdx/KHEiOF/9jhUI/FqP1tTdfI0MyGLJ
         ObCIsRRu1JiouMDLOXMWhZpNDuW4V+jfga0JT0zrKx9G1oOkhlmcDhFEjXTE69WMd6Rr
         C1sjopMo5JPZLLbAbthkaFJWvUY3/MPfBzXCkcWmmvroWU5jrP2x7fdTG81nk0zWTu1d
         vRFf29L4MQLB518buP5t1vXJxHnPpAcOv1PeaYqgdyGSGN5ojKv+TZO9mgpfRNvHC8W9
         VxYkDWT/jMhNsSP711tTpuvLVq+kMzkKP2qr+qoQIUZenbIhtObmahQX4QsR/3lTSeV1
         cvpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780964390; x=1781569190; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d98c6s2kvLtGQyL/fPqKwrvfQEsZ3E8WA771oxSRxZc=;
        b=EWPajVLh025LdSaTKFaGps8jLaGvZG6wEoI9WhEMW3yIzIzRHjKFkFcZ2L/GHxwlik
         8iN28OO67VB9B/Oy5wUUUK3EhwCIvN4PznFKcVkwlh5YVWgUr3NXb3tMCug4Zwk4jOWS
         bcfP4urjQxnsdxdu1xrYlMEKyV0VdYPXqS26DVWamgGQ17B/qkab00SOFDT3CFHr+Stq
         GOTCFHUy8nPaFdN4xpl2+MTJCdZqb/IHGkdJoFmUUQ+1m94kNVu071Em/eeprbQcNrWn
         ZMpZ6hq8KQJL5qWnR/Ke7FSTFE43CTJuuNhscnkq8O0E0Io0XBGxjKTo586CXmW+zjvj
         do1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964390; x=1781569190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d98c6s2kvLtGQyL/fPqKwrvfQEsZ3E8WA771oxSRxZc=;
        b=FHzGZDhK7PRoKuc5yLl/XWFCl5tWCroDtYDOoyAfBk3RjfjGwsXtrNy8DQhSloinVN
         TD6T25WecrR7P0pdoyKZOaVe0S63+1lFKKm/3iL7lTK4RLkNE1YRWl9PaCHuG5DUA2O3
         acKQxG0pKPZFG+GfyIwEkX7JZ8N/pEYkYX9QDRQC5WN1sQ3EmNv77J6yaShcw5jloeWo
         1jwdW5gtCoTZVrcKnmsq6K3BoeMfJTWlV+PElwjTpo10eSQzbjO1I7xroQBOsWMWMT3f
         0NZH9fDJgIiDOxssCZqe37Bm1GUIBm+dCAdB+R4RtNw2NvDQoBCwWYvNIfUBtQg8Vp/J
         D3WA==
X-Forwarded-Encrypted: i=1; AFNElJ8TYBjyHIMtQxVIKrwk0k44qCh1AC1rTSB61hTRxwsfdIJy5W7AVUopCp7hDEs3tPTpn9ISUioX7w==@kvack.org
X-Gm-Message-State: AOJu0YwQ1RMyIQd0bI1opQJ6uhMpNA85e/1iFoK6r5zNlb7SBidl+Eea
	bh2HJWFe57asguYIxvTavd/AoPAkAHOfqlhxpsfJ3dPInsRSbw0ONzdTZcceggwZ3pZGoa6Gq67
	QAzDaVPq2PoE9av1yqLzvvb4G0O1TBAg=
X-Gm-Gg: Acq92OENFF/fzCQTXlMzU0V2rHk9ITGtdW8D8sWYVL7m5Y+fqaNJ2L+zlbkkvhJhi4u
	xuBKhfZFMtIBtG1pzhLDsoFtpXno+88n/HGoETfzWNlXcIdS40sdp4+DV/ewpyeanUEztoEuNUQ
	tPAG+rQ/wjUL9NXHFqRRaqfGg+kucvBGlG67uCv80NJmoLiuK2fMRhNVaYYdD/P5G7eKejk3sWm
	c/dc9OP9Vdb62+wVekwuBAwlZsCx9Dwv6m+hbGDY6SrzI4I1LhWsDY17mOdwnLdstfXNKtEnFRm
	kuybQi94gbBsXfxtqw==
X-Received: by 2002:a2e:a5c6:0:b0:396:746d:a985 with SMTP id
 38308e7fff4ca-396d0909e45mr49447141fa.27.1780964389837; Mon, 08 Jun 2026
 17:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-3-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-3-willy@infradead.org>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Tue, 9 Jun 2026 09:19:37 +0900
X-Gm-Features: AVVi8CfNYybqeEpp46RIwFhqYlePCm1gyn4zUKznk7FbjqXZt8we5ivClHmKorU
Message-ID: <CANFS6bahb-gXNWhtoTAxnf8cx+iV0hsAr6zzrSh9q1BmvR=HQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8573100010
X-Stat-Signature: b7pkfimg14wspfujopj8wsangmuuxjp4
X-Rspam-User: 
X-HE-Tag: 1780964391-88970
X-HE-Meta: U2FsdGVkX19ML6FLIUjrveS3oI/nwJTcRIiBh68lBagdv7UHKfqOFtT8fvBzN7vUSr59AfZprgW7e6loJt4p3RBR6uvzW4EqDMBMUCnZT9lps5aksOg3LidzWIiqp4n57O+GCZ3fPgpn1Q/moXEKsDdmyla02Or7HO9ciQ3BtW1HskaEcjvoC8o8LL+bjKCy9jzweAhPLg3ku6dbLXTkeBAGPjlplVuz1J2SruAbOMO1cEqjYjmY/aiPrDiv0UXK6LxOAg+ED3Q2NGz4zk0J2qLEpQcePGxW1sY/5/RAcNvUO97thnz7amMzXdbtmppuAz6W2raJYFKvvUJaW+l8b3qbwOHPKCvPCNMHMty4hutce+9vbRrtsARj3vEB62r41PCMZxsFiSUEGyic8KJn16MGcPK7TM5M1DtfFm5P8944w26ygxfnU6ZJXpy9iUrEoNxaB96ahcun7dNZV6YPrRTNdBmnglmCEwIzhRTpymSNwRxN1As7whVoqWeHz84avRyiwcn+XbPKlEjLxKMWCg6ucjspURAT6YJ871VGxqt13Fxad95OIA4xHmhz5mfRnZ4RVBEerNKuGsNrq8r6orgom2GWyUNng+vjtzeS8/z5ZKJ7WRK4EN+AqVelZa3KK9jXpWo0ChBgd44seX60LQ5A8MHm9PAf2swMAF4rb5w1Y9PRtRPzCvvNtc1XKWIpj/To85Rb3wqPXoOvxsU7TRm9GN32LQo1dbdkV9Qdi6YP3YjmgJetH5VMeNhvrVxE8TTMn/l5GMt+4WUFJmBcOYpNttfa+JkSH9yFwm0J88bMAprEwsscMzcyIHw4TahtQ2P57hpMwtuxPRmZD1DTqidCu1xfcGqIQmhhTRWI6OrTDbUTfPCR//EU40WIgKlErznlKfc2QIumAf/FwJQTkM6fvpFnsGrCRb9guBZD4UoxPNV7NSvRO9jIWu99ZxY+FGpvuEZYRYJJE/V9XSm
 tjp/9tvA
 3+4tAN1q/2K68qAYYDLiXBbIa3xq3r/zBn2+XajsZgRMqJ/v5Tvyjk1i9tlExbtQgE8+QesSpwBoyeLW3E01RaN6ynDoeVEvZ4shCs+l4cxSDKE8xkgjgjkBrZowI7j+KnVJKxOjduQe7pgfYYkvPHLhjOT8Uc2AzqugMVD+kCkDRvjxLxvPIYBka1B1S9sBXo5y7x8XaliPTpBponiCYpkG9jgKJxsbWBB7vNw/NIQkJFwECjDyjfQZzPT0Q6lLzWscFws8nppS28fdR1xjAzjA2Xy6uLr+Z2i6S/Bm+8kYlh8zo1GfyXhNMQLDL6ihzM5bzxpotoLyhJhySypxgS4BlSvgOOt8dKqZzY5gwoN7O5lu1k14nRAPnTPtoghvKd0yQFS9fR9Cz4yEfSETM9yUJSO6lDzalfqlf3YNvEc0TUYrMy3qs4jf/hCCgHOsLccGpvbs+EQheEHdlmYU9MUGBN8rkBerYaCzQqkdtmMRBczayq8mb8QcErw8oksoyFZ4DTtlAhNnwK/T5Z72QGxOQSuNVzmmYzOvW98KXEfMHtNUzxSOQgY0mKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:06, Ma=
tthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Nobody is supposed to use page->__folio_index.  Use page_offset()
> instead, and simplify by working exclusively in loff_t instead of mixing
> up loff_t and pgoff_t.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ntfs/compress.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index c904858dff3d..b279f38636d6 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -105,13 +105,14 @@ void free_compression_buffers(void)
>  static inline void handle_bounds_compressed_page(struct page *page,
>                 const loff_t i_size, const s64 initialized_size)
>  {
> -       if ((page->__folio_index >=3D (initialized_size >> PAGE_SHIFT)) &=
&
> -                       (initialized_size < i_size)) {
> +       loff_t pos =3D page_offset(page);
> +
> +       if ((pos >=3D initialized_size) && (initialized_size < i_size)) {
>                 u8 *kp =3D page_address(page);
>                 unsigned int kp_ofs;
>
>                 ntfs_debug("Zeroing page region outside initialized size.=
");
> -               if (((s64)page->__folio_index << PAGE_SHIFT) >=3D initial=
ized_size) {
> +               if (pos >=3D initialized_size) {
>                         clear_page(kp);
>                         return;
>                 }
> --
> 2.47.3
>
>


--=20
Thanks,
Hyunchul

