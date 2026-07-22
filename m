Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF9BC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE886B0088; Wed, 22 Jul 2026 02:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90116B008A; Wed, 22 Jul 2026 02:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E4F6B008C; Wed, 22 Jul 2026 02:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5506B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:32:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E02011C0756
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:32:21 +0000 (UTC)
X-FDA: 85015443282.26.4D3349B
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 04D6940002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:32:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=StDsh4Wr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784701940;
	b=26ik+499OwvhC9hgnLudxnv/W9TkS8B/0RgCII7bRAv4kyRa0hGVpqfDks0eLM59GdyAXF
	v6FZMWGjhe2fGqY7asCJFD5orkIDSjhem4UDo7XocG2Wto+jJA7LIAWifP5pVz5gHEF6g+
	5AolX+1+v9sgeKaFvNSgXqtP1ttHCss=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=StDsh4Wr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784701940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6epAAYMkIG/HYt9GjNWbYDPrwxgNXLiUu6MWiJ298Ho=;
	b=n/0EVJhzmF1cShS9I/tzXvmQKBdK6CiFdSOKvbU4ACX1RRnMT2vMTZNaIMyWimPpXM/bTF
	qMBeA+9OlHtTfActw2cST+YXgjpeohkihpeJAeBNnz1LdA9KSgGb8JClBv/SvQuz++OmRP
	/5+1oHJ5TOVto0ygO36ARTBWoYwr9UU=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15b1da6b82so944110566b.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:32:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784701938; cv=none;
        d=google.com; s=arc-20260327;
        b=QfygzAlhFGtBJwxCWyBQFbpfw1TUQskFsU6LlNYuiD9o2WoHHXV6jL7UWgRWeZ/zKK
         p+tdsnD8PpIl8NFGowEr0nt8ZVky1XzDscOng5wEZHm5RxWe50KtDKx7oSgooPxZzVjr
         6VoTJrmlchknOOxRYE0zh/l+AoN5HcPgWbrg3yxWXkiTCqyzKeoE+YuL/eUu/WCtokKh
         BAAUB0pTTTmcp71FbiwxqMr4tcL9OuXzb3rr/WKUNVGkiBh2zc3MwJ/F6pMPM8P9e6yk
         81r0pSSTYP1IKfh7ycppG7bRCwFaKFmQIN6GZNQYrCj2DoHzyNgnhdTh8iMRY6MwtXfq
         C5MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6epAAYMkIG/HYt9GjNWbYDPrwxgNXLiUu6MWiJ298Ho=;
        fh=GZJZ25+oQyMe6jadLF1k+NS0NFF0OqSyrz5A3moqIRs=;
        b=Nj/JRCMsuWKKP8GL0RnMNnLqNgrLGQH3ZPoLnRMijG+OYB9IGiCGxfRURvKYXNtZGp
         Ord2/uASEj8r8mlndiY6ALzhdeqBGR5TfcwP0+W68PjMQB0WSVndbF9l8ZEmTFe/zazK
         Rl+cW/Mpti2l8axlhh5wNvGqzKmFBbdL7Ocejc3A0POuK4nZpTphIIA32y0EI7JSZtUe
         WN0Tz5Y5iMHQt81HvNKuv3ZiknBcM1Ra6Em4qlfLIPyzs12r2q6HL2lqC7cNXeEtHqlK
         Mu+EWMRFHrOvkXYe4wDMQy2FG2gBA5SACQQAeTClY5++ddgZv7J5Ff8JQlyntxjEvBCx
         diwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784701938; x=1785306738; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6epAAYMkIG/HYt9GjNWbYDPrwxgNXLiUu6MWiJ298Ho=;
        b=StDsh4WrP7U9bGioBYvdjo5JrLUXStlxEkr6p8YzRZBOFDS+3fryG5R6nsZute9N8c
         3QLOaoZkrEzSpSeZBOt2cnQqXHFHEWdgDCXRXSDOWVtKyIA+hJMJKULvnBgRU22f/Qn5
         IiGd85cGtJ/VgzHgQIWxdCF9ZpQmwMYPcUhkoh6aGPB6OcqxCz3SkLeNwc6NoafI3gkS
         mPMYyGEci7R7L5cu0tElBgC+2VHWGI2XyTxxBNau9BPruqx6TaUP3kt1AEq13pxKNsph
         JmLMCKEecUPW9moP6+oWWcQKNNqgzBXLkTVXexYD/Xi5J2pvxCnbOjUeE9X2qFWF66vi
         cHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784701938; x=1785306738;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6epAAYMkIG/HYt9GjNWbYDPrwxgNXLiUu6MWiJ298Ho=;
        b=GsMDp30jo4B0KyKnmMBRUxWCQlIc2BYYvLaC5oCdnfs5VEIQtwolLCgjIYgSDJseWf
         RTuLiVglmHFvMo9e6IhX7k/XbZUdt28NayKUgR+6WEQjUAKtKa0H0Aq1E3pOItI01WGB
         jjTUfnrl+crrnihZM/wQDKe9O9TUaR8d55vgv9k2UYW9fJJ+0wMjGp3QwAKloV+EWlJP
         74oCKvEipYUPeBZQPonj1vsOzPIHrndqh7LU1mpkzn+46po6fjn5VFYH3y4ZDh7R5fOR
         KoWVeyiumN3/EAHuJyLZy/XBHfF4MZJYOI6JdenDmKUgG35v4YbytnNEmU+Tdl5VCZGG
         7g0w==
X-Forwarded-Encrypted: i=1; AHgh+RrNQ48Nia/E1B4d4GqflF0aRFb9vk774qDOQm0y62UKy+5FfKiKRdKhMd5N073+RuSwDw3yyvo9NA==@kvack.org
X-Gm-Message-State: AOJu0YwJ29uZxBjwn47XkcTHsl3uZAYIm4Grs8bPARCysR6e3d2npw3+
	70VWwxTBX8RCo6AyC50sNaIp0Rgy5lQitzR6XjjtEI2IP3okcQRENAUdLvG6QO0B8ibVs68E2sC
	v5KkqIjRPW3rmUD93UBPcU3H8qtLJFu8=
X-Gm-Gg: AR+sD10W8jKInckGez2VQJo8S3oPT6N2FoclYrHNVudrAiZXH3VIcQofEwzwoEc5b1g
	0NJgBQi1yoEr+5NR8IkTztT6pZaYe+hzLX5pB5fgb7+3U1siywcihSuoDZeDOo/N0EGiiq2QXVe
	EeV6gd8lQ+OB2bF/bsVoWGHN4ytrmip4IYdIPnATXQozcSV9Rd059D+loWo6lIxZ5aOBDHDlGX/
	SkUOZSjpUZRCulOlGENXzAoW+FGsSIjHq5YCI+yRBq+G3BRihMv2b9psNf1MTo0ugo75pYvaLM5
	Bfc0tX/9ewPO7pOrxg==
X-Received: by 2002:a17:907:3c82:b0:c12:525b:4e84 with SMTP id
 a640c23a62f3a-c16b469ac15mr938228266b.9.1784701938294; Tue, 21 Jul 2026
 23:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
 <CAGsJ_4yvfGZ_2505PRWFHaqdmUvb3R77GFJSzpQ1vEFChAK+Lw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yvfGZ_2505PRWFHaqdmUvb3R77GFJSzpQ1vEFChAK+Lw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Jul 2026 14:31:41 +0800
X-Gm-Features: AUfX_mz1mCudY-8Z72SaI3qCGA3dJ8_Dv-4yerw9MvVzb5hMas3XwFUw_t_eTRA
Message-ID: <CAMgjq7A1Qb+r0p+byXMpum9iM-277HE=Ks7a8it-DUmJ=vOKHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04D6940002
X-Stat-Signature: 3m96tq5ur3f5bigjx3saz3fswu9zzrdk
X-Rspam-User: 
X-HE-Tag: 1784701939-64330
X-HE-Meta: U2FsdGVkX1+QPa+hfy0AD2bnP6K6vfRptbRnJjC37uFLeO670hEFCC3p06+xaD4XrEk5iN4LvVByQFM2BmnxakU+rl1DK3h+korURMV4rP6VTfD5vTAeTRO3R7VPRuvasVCTZjseCntHqd18Si5yd3Bhsm7coleqA4pGaBor5R1qsSl46vm752dW9/PZDsVK8r1syi1vMzjXOiFKmuT6xyy04pE1oDj1H/2Kn8zZqyTDc9hglOfDU2xqBROJaFqwAYj22qag7N8073GfcI9gRMJuT2vDoHKp09VJ0uXbFrz73lVL6BAU5Snut3dF3wwQi7j+ZkGS2PB1HpOkZXImnooMqrQ55ZbE0EYU9pQXF5lz6KzsfxjUbFgZP/Uecddk+9QtZUs7M2sXxL4/DDNEHXMunUwpj5fOvZQ3KF2cc0b97Tns1ukE07BueOMhaWvWtdbBCZjV1d4xBjCe7j3auLAZADz6HviDV2Fbpt07bkz2Ot5WWmaTq2ZalYvOHed9HOqRJJGjNJYO3SH5mEgH+yvQ4mzZD7cin8sus8D8Q0TK5XcTj0AkwCDhnIxSrXip0iMuM+ud95ssOW2TXTEWEaMWjmDKPCRB5jEGL30ZokJ6XXmSQ8TNjTmOoxPhjEl64K9wj7eoL4GyavMUhkN9uY+ba+MiJaXDo47LHR2zvep+oqkLgGHouvJ9a6wWSuNInrCJUTEmyXLor+U8rt35sqAtYgQYMFzheyRoGRjW+d8gip7z6uTYcwGRNfysqJFZDTiWyIRlIgeRhQ/LrPnkYTfknJUio/5R6ml2VPUc1vqFvO1XoCvfmHB+BjTLyeZLsroDue8NgnNY5ZwNl9wmK2LFuU4kxE0SsljdbNyjfqY38UmJEZeQk4h8IEHDdOgyZtaokOc79dm1YhzhvGD9wur/qh8K0fD5fP+ReRYgWdFM1IAhaHH2byYSN2Mm5evqdfhJD86JngjOxZATDdn
 9YLKyLOF
 xzzGW8MJyrrxo86v63UShMJsuPYnLFWr13hgC1qrNhR56UTBgnLETqSbXVL4Er8F45ZInED3XJz59nkp0vIwdAkTToZ6oMI79n46OTYatLiaFjx8yHqW1Pm642+lQpv2Tsih828E+Q7WEY0AtjNbHdrLmp3ZD0IabdBzJLpeojnEzr5Uewti/6FV+zzjVyuS4RXgAMonAsyr9nQtpiBFazwqXo5aSY52/B+j3vAiE1/dnqamdicxrBnoLt/SqcN+U3TkpNuUYCWIQQeZnAW7x8hrPmpgh5Db65Zcxraa5Z1cWhZ5ZOp3tGNSq9oCeNW85V6MlUhEZLgE4k2NSfsFUVhYyf/6d5OkP1WhSsD6fwWvOiDj5Xhd75c2A1EvpwXtbQNmmnk5IPkKQvhPmHXbOwDYd+3Vr1OaHXG+o35Qaigs50uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:41=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> On Sat, Jul 18, 2026 at 5:38=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > For synchronous-IO swap devices writeback completes in the calling cont=
ext,
> > so the folio can be freed right after the write rather than left behind=
; do
> > that. Because it is freed directly rather than through reclaim, it is
> > allocated off the LRU: dropping the last reference on a folio still on =
the
> > LRU would trip the free-time page-flag checks. A folio that a concurren=
t
> > swapin has meanwhile claimed is left in place and reclaimed as usual.
> >
> > Asynchronous and filesystem-backed swap complete writeback in interrupt
> > context, where the folio cannot be freed; they are handled in a later
> > change.
>
> Might be a bit off-topic, but I've been thinking about this problem
> for a while.
>
> MADV_PAGEOUT, and reclaim in general, don't actually free memory
> when using asynchronous swap devices. Do you think it would make
> sense to free the folio directly, at least for anonymous folios,
> once it has been written out, instead of waiting for another reclaim
> scan?
>
> It seems a bit odd that after MADV_PAGEOUT completes, the memory is
> still occupied.

Yes but I think that immediate drop might be actually better be
limited to things like MADV_PAGEOUT and zswap cold writeback? For
common swap, keeping the swap cache after writeback sometimes helps a
lot by catching fast refaults. Because we perform swap writeback
asynchronously, we can easily overshoot the reclaim and send more
folios into writeback than necessary.

For direct synchronous IO devices or direct zswap compression that's
not a problem because their writeback is synchronized, so the
reclaimer waits. And we already free them immediately after writeback.

