Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69446C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA7A6B0096; Mon,  3 Aug 2026 13:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553A66B0098; Mon,  3 Aug 2026 13:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C3C6B0099; Mon,  3 Aug 2026 13:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 035CB6B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:07:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85AA9A014E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:07:58 +0000 (UTC)
X-FDA: 85060590636.17.9E1A361
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id AAA71C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:07:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WG95luHu;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785776876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AY9HtAJR9GCk7X7iJyKID8SJ5OmIiurLNVFZdWTVieY=;
	b=BNAMBmPI+or9IU7h7tpYdV01nY+qqkU+XIyMo/LN3JHPxG8Wc4f8B8ccIntv0P+8SMaXgf
	+2Vi9ITnTmdG9JcoxViAX3CcH9nnDqQuLOh4aviAQpbmVOPMhLnhJ8xx8sMVTQbsJogEyj
	N9MnLx15RUundIFlPCSPYjtpdwrk3Ok=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785776876;
	b=kQvI4YVEElglDBFbHsKBwXiI/LpuAXDJRcA2LJPGOMdYukBhUjQmPCWZ3m9N0INb0MEQGS
	cEy7vk31lCPCclqhVpriVO5Uhbr6r14VQzw3eTXJBnpx62O6ZoNzePa+bQvSNyv2mCS0ez
	mNix6hzlwXC56MEh22h9T4jK/EUKC7A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WG95luHu;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495437bb891so830315e9.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:07:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785776875; cv=none;
        d=google.com; s=arc-20260327;
        b=fHaq9RJx+h2Hn7/9QoWkqWFi6zjpYTb3BQXw8HlfvbCKaD+TTJrFBB+HR7w7KHmadm
         g8+YYnTnr1ovC0XL+d3PaqtrfCoOWgfGAENA5bOOT2YVsWixP3/n9Xe58VA+0fk89Jzc
         lAdLGBHT0jSMmTktrdcZmxrbJL6MKbiOVOPbJbNw3CGYJyCDNQ38UPF9s4hOeTNSjW00
         VmoHQDnrfAt3KB4/X9BN8ot6oBeEDetMXZ0HX7/FXddqDhzqI2UC8I77T/k4JO2d+6fZ
         ufrxXc9HMeCHnkb9TWo1xy6oUr+hGwfkAU6bgSQn0+Ka1pLcZZwptsK03ao4B3ZILXUB
         oGkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AY9HtAJR9GCk7X7iJyKID8SJ5OmIiurLNVFZdWTVieY=;
        fh=7lPRTsSc/L8+y0rfDoD1SVK6MNBIJnc0+oHSvwOvvGA=;
        b=H48vFIfIgh1mA005uxvaZQFCwodXHvpGtPTjc5dNCGcKg/lCEV3jviBr5+mW2pYmjx
         FvKQ5D4xkO6v6Erh0BKzYHsk3pcBKqNmXBD3zQbHE+0oYuqThZ+MvqUCfcYtHPbIKgGL
         totJftXUQ/gZxJO9qQ7wlxYWwvWO4CCLsyj9fqrImj8b6oYZJebrbSOyeaTJfQTdpm9Q
         X4dHR721qaxUwp2Kdm8rVAQ1CpAqZvmxkws/FFkaYQzNGrc0HnwEFiTWDK+8SgcA3SuZ
         fiZfz77OQHTOaBBOwMNfTnHrQsa350gG0xtlqmt7w1UA8Ejp3TzqJLO4zcro+K/OOC9O
         qb1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785776875; x=1786381675; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AY9HtAJR9GCk7X7iJyKID8SJ5OmIiurLNVFZdWTVieY=;
        b=WG95luHuJrat5STZSstKr/JZJ//+w070fLTzFOzHaGwLWhgCcQajcs2AyNX9sT6xVb
         S1Bqd5ZyBJdUTQ8uc+pOme4glnC8Di/+hOifoRKa+zKkNEsww4S3aZzG0HKftBQijTtH
         v1WouKCWwQ2lmEmO64iA62rkY/qGo3NXT1GiPAA1Fd//NwYXF8ZG7n1pS1FMdf0T3k6n
         lzvFOKf5fDZADXCRpIuEVS0uWfUU/yCKmyZ+klHAco+iDwd1eW/gXmeHHKi9/Rj5ZVqD
         hbfn0FJh/8AK9sy51VWL9+ILL8Lu3z5ml1wwVqaa9VrDwWYLsoR86N94Kp/J6Fs2/WKl
         2RlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785776875; x=1786381675;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AY9HtAJR9GCk7X7iJyKID8SJ5OmIiurLNVFZdWTVieY=;
        b=VK4bTipDaOubbSa/i+amF6kzDGqWplC5pDth6hT/Unq8/TuYFp9UHfP2QvYVMZcIM8
         kOxBhGxtp6rDP86dbtdnCwBes82WmU2NKepTSFz+kYkNKz3BixqxiwnyRANYH/UjPR6P
         TIYqNlHPz3W5z6iI1E88P6PrJd98Pkj/Ui7ofGH48/76qWVbwy9PBm1SgZPCbLUHboz6
         hDmobaNVOA130eKdcrPDOtiEQT+HaIkjcdSHD6heWMI/hKiDaQReTkK06Y+4JSA4nBaN
         gh8JD2a3hiKt0GNfxi7sxlTgMDR0fBfAlPp8Wj22+tj/Te8xOsbKdVR+aN7WH3NpSUil
         fgvg==
X-Forwarded-Encrypted: i=1; AHgh+Rq1x7dllhqLPiGNI7OtkHbPVkMsuqzxE2iqSaMVFbPvF6FDB5QsEQg+JzPEVCjFr+kM/W9vuSt6tg==@kvack.org
X-Gm-Message-State: AOJu0YwsxrzsbOxV+LkaQZMoYkwVUYxkV4U71/uPCx2QQa4we0pRhwag
	qnSPFbhC0QU9F4m6pZJSB3zzA1PaRg3hYvyv6OKv6ZOMw/OJhiLpO0J8mtNWoWWxhV0c7CQGyAi
	d4iWGNOvQtCaXxkl9P7oPX0SpkcQAV7Y=
X-Gm-Gg: AR+sD13QP6SmoOzZCpP9XxOdNbZUilsBNYDOtL4CLBNZ0tvSK/iYoI6+ayaT7QdmOaf
	PcSl0L6cwIIIAldFHVQQDndIS1PvmYnuW6GFRu5q7vpwXrhIRsM935a+ICC2t+ohz6PpNR0uJgQ
	lyari3Vl9YPfPZ1WCyjNcAwK4X4yZpnRUsBw7WjjUklsKSfrph+ZBo+yY2nuHrXbDoQ+WsymoH7
	4b1bnw/pRCPgBIEOp7U9ewqqLrn13i56smINUJFlDLNIaIOZYUdCeMklrIERNDcw2NA33j3zbNf
	u0CT/lOpcp0KVC6maSy7c1eudi9zAbcUWCh5UFk+MFEVW0CDyaR/jZPjTCuckMJ6lat85LEmUMg
	+
X-Received: by 2002:a05:600c:8010:b0:495:4f84:7280 with SMTP id
 5b1f17b1804b1-4994a0f6838mr8934005e9.4.1785776874996; Mon, 03 Aug 2026
 10:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260731053721.1412304-1-wfelipe@google.com>
In-Reply-To: <20260731053721.1412304-1-wfelipe@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 3 Aug 2026 10:07:43 -0700
X-Gm-Features: AUfX_mxK2pE7QLD-Afi_iM4HLF7xsV2DwxivLERlho7rxO9QErLlXLVDFWruvGk
Message-ID: <CAKEwX=PE1N5ah-8JhwdOk3=gAniiNZ5rqcYGp5Kjif9=r84Ctw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: drop list_lru param from zswap_lru_add() and _del()
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAA71C0002
X-Stat-Signature: tkqxb45cci3habdpow8475w1b1t6apgp
X-Rspam-User: 
X-HE-Tag: 1785776876-325539
X-HE-Meta: U2FsdGVkX184pv1vv+tmQWEBYD8gXDDf8zeIynmobmd2jq+tYZAPvOJAG80i6KiLM18VOQCPn+VQ6tr1eF7Z9kAPi9pyrlmmy8QKrn2fFY/JuaxeqBL3SFvK110+68Un/3BV/I+TSCNWQwo81mcKlLrkNp2So4yeO0QFn3GSCVQleM8AW/olSF/AUuEhZPTvoY/T/v/f0Elsb2zyAUIOEXm00k1pXZnPqLM5PkrOFewMgdOQPJWACnzOeZ3Qku4jMbc/g/V2OfU06//suG9VYeRxziBlI5WA2h0wv9/RWaCt/vrn+ZT7BjoaAERpJpl2ms8rL/GZ3uSIJpO9jyF734PLdCSUt/HllrjBMGYvlt9dm8ItJL7KfRrqRPwgyfNLpXxOi0dpRhNhi+VpGaaRsTjQ7iCyUH8R0u8SSP8J/gUkzkJkXpqNneOvMPNx9HH6HCedLq88xJxMm1aiu/3i65EH9FGmK+Zeo+b528DdLPn7ZBAPEDxs0LwDGI4dC+PAksULEkGkAzio9xRTWIoRknWVmN0gF713A0RFQrIjhhFw+ibIeq+aprGI9V9hfLgc4sqAJSb3y89XWm8DY+2l1oW/R/cxr0aqcZf6KqOLZDp+zKCxPVtLnHfXKL7Dk5Vx4AwMeYyTQh4ZHvf3fFZd/8PpY4X+lKlDDjKDZ6c17Za63Hfab1/KzUjoIoSS12NQ1wdpy0WOfqQpSHGIF6DcGBoxBeGiE4YSe1lCqd1ncQzLwyYkD+86sE1+N+xHgMkrs/G+2BqRYLonhiMyZ89derXTYhpNHnv9TVyANKqEp22wa9FU4deHEdXVUGcYzKbJzkLA9obqRhCH+5XxjylXEPT922pcPsXDo7QvP/y/k8fMB8VUYg8YcciOAzwVFAdkZtrZdq3oRW/c9K0Ps29L21RXEcNplLKtCiJb0hCBuJYhCUxH7ZTXNfGEI+WbSbeclHbTj02mUhD66NPBFTy
 UAd4By33
 dseSxWS03D1KOcJ2aNG+iQ8C2YWrVLuCNnHJM+0SR6mxclgUgwPUY6O36vM+ulOrg8nKPKw0tsiztOvg38prP2wtEr/Dji3ofSKWSME+J2TAfpi5WsDuMY97warAOjUcZIMPZUzSM9rRG3ZZ6tQjtE2Anvrtid9OGY10IsLLa8Da9cR3dxBTNPtQSO+ihAStFb5/I7tfF0t+0klVzxEf+/AZkGjhhv2EEQX9GAetgbQWxCThvvCV8luxpjkZWs/NtbsYkR2qnnN1EqERvOSx1ZOROlJ21731DS+kHCzharPBxWji1HBqVCawBNrCOZWy74KslIU2rIOYIP6ir47Xt/6lpdokG6/IO5cdgcAA+SVxivg8dQGLV4JUrCOvGF/avcdZuBL0Bx6jXwnBo0jUlHz0SW2oqTD4CyKaLNcYr/xRdhHtG8w5kftGnpUnYQYkzV+ipptvtmlAkJPuS4TjepAo4RQtrg3U51W8XB1RvATQv12noQNXV8QBXeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:37=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> Since zswap_lru_add() and zswap_lru_del() are only called with the global
> zswap_list_lru, remove the redundant list_lru argument and use
> zswap_list_lru directly.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Beats me to it :) Thanks for fixing this!

Acked-by: Nhat Pham <nphamcs@gmail.com>

