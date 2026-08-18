Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A6BC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BC96B088C; Mon, 17 Aug 2026 21:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63496B0892; Mon, 17 Aug 2026 21:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C206B0894; Mon, 17 Aug 2026 21:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 979F06B088C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:54:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19A54120A09
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:54:27 +0000 (UTC)
X-FDA: 85112720574.11.B8281CC
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5143E18000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:54:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fz3/fcwg";
	spf=pass (imf24.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787018065;
	b=Kn2tFdY3iUcYFp63M9bm/lADPqFFa75gxq1ppSNs8pDunOO8OayV4CdeSTLM7v8EXMGPfU
	vBVnb3CiCAwAY6njRUgU4/wjx5LKnsf3vQqM8MDpF5yc3F18risSQT5VSppR7TPWR3D5uH
	vDdOLQtDAun8n+WZnJhUa07Ex27sC5g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fz3/fcwg";
	spf=pass (imf24.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787018065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJZh+9l79XGTk+91Ew764dkcvMu0Rffrs34mLTeW4hs=;
	b=OYl+R5Iiw5SZ/JnLQcZsQqKd/ZufT9EAluUKfpaL0HqvKM2ZIlyq3RFdKgUymT3MRZX/lz
	fR5GlOkkjlI4mYgO+gNERh4oSHX71bajnTJzsEtQ2smJQkM1ROscaBe6/P7pedeufq3vv3
	C5DZJvNgEv7p0TB+G0sdrN4NdVX4paw=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca00ea47337so1613672a12.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787018064; x=1787622864; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJZh+9l79XGTk+91Ew764dkcvMu0Rffrs34mLTeW4hs=;
        b=fz3/fcwgg3jUoh3Hi2ZaHPzEAZMF158WQo0j3Xj6YzoKPhXpiMJtUX0DRwQCN/vy2l
         lS73bGo8qadDK1OSjIyJGUgIBoLh4tjyiMK3yi6HZMO9teEerRPeijqvI4k7Xp8xYVRX
         5DhQuozo3cM9QT3V3TlgOZen2Zd6kPtIeILPNohDR8H9M/Afb0I+YNp1cIXxI3kR7jbe
         7gRGAhXMY6AHmgS8IPF84kovFmuNGgexcxSir1DPPTuILQEUtqZwa2+Vumwc0VHD9FFz
         P9PaoH8dTK0n32ZmhGNqv8cz4nzPe2lsHOqlDQ9361Y8LqjCcn2kdg8+l+/t9d6jYlGj
         b5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787018064; x=1787622864;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJZh+9l79XGTk+91Ew764dkcvMu0Rffrs34mLTeW4hs=;
        b=DmaJMQpdPARzcNRYDpdE0HMi6lR4ilx0YsE6f4riqEIFQOPIVUaJiJHGz58bz1qTSa
         uKV5PL+fcPoj68gnEXiUyOB/Jwp46IL+NSFusYznVYyC5JVPP2QZ+STghYKsJSErKakl
         EM2cvQd5vdTTFI2iqgSi1Ur6wmCTF6bLRG4EfriT/Uio3uYnceqR3kr002ccJPMJg84f
         f1vfB4t6QdQqm23ygaO8yZyREHXwC1C2ZkAl/wWcPh6fL+xynriA+pvGoTfjhJlFwnt3
         BA46vgfMykjFniSsqElJh/3N6VuBWtjy51ScReAYBi8lywk5mgrHUaxGtkx05I4SFONi
         kL0A==
X-Gm-Message-State: AOJu0Yy3mThUiLF6yvqHqoycfZZP0+TPXkx0RTuudfeBIkuW4lhtbKwB
	GY9Zhv+3n+EW6FRU2svMJ0RICtKc0Qwna+m3oW0izpG9EHlfA+EAiPOI
X-Gm-Gg: AR+sD12W0xn+pCLgjLanH5uDdJUN4aZZmphySztOrnbXr6r0WBKqxU3Z/xc+Nxwz3a1
	NB1brVgBKdbysVyL4Mc6xfHYtM/AYmK4utQUueMrv45WPAK6GrR3uiz5jRncINv2oI+Fi6IyQCB
	9S6seBB8ykLmvRYTvqxd3q3yTfHcXyxBe/ZrWAD1W2QA8/GJ0O50dR+LWWfg4sTfYka/cEHHTkX
	bamleCPZ/B3cNIxDdViFz/Ib/D7oEJI7aLxA47N2e0ajKXo2sQkR42bBWIEormjMgsmU+CBs71N
	UbQ2DeGfPdfZIr6IR8Zz6TUs/S9DbmbOFq2XE9Ayo4RHgy9PHnn7xBelCWct1iMA2t3DMd6+s0D
	lYDo7xNLpTzBrp909tdAgYP/jBqoUipQFstXMMz5EOuIVj7ty4CXAyWsoqN7N89250poi1VQCD4
	gZYMnWmfe/+v3SPDypvUEFdjSzNKm63n0/gUSj6fXUWa5ReeyR8++cxrdN
X-Received: by 2002:a05:6a21:4cca:b0:3cc:45cc:c401 with SMTP id adf61e73a8af0-3cc71a256bfmr32917617637.13.1787018063762;
        Mon, 17 Aug 2026 18:54:23 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327af7934cbsm558584eec.6.2026.08.17.18.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:54:22 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Tue, 18 Aug 2026 08:54:19 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
    Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <79cbfe54-41f2-9041-89f3-a96e9fb80066@gmail.com>
Message-ID: <9fb6acbc-19cf-eef5-b877-3bf798767ffa@gmail.com>
References: <79cbfe54-41f2-9041-89f3-a96e9fb80066@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5143E18000D
X-Stat-Signature: tewsfieqbfqtog7z196pu5xxwh7wrkkn
X-HE-Tag: 1787018065-609643
X-HE-Meta: U2FsdGVkX19SvljHvvMwfhnc98PnzJu3VBC1mUSgonkKCcDO8uYFtTElki48VdKKzRxTHHIzpl4PmGozcjdNlv/PCDnpir2ig7uaP+ZpLSPuVdvjlXL2q3irus827zDxdAiRsiC2kca7LePQLHLeARtAvUr51K7Xl8XifRY48aTJqzgSlMLI9YYw9skBXroy1huuh4GlUDi88JxUMCoqG3tY7MRNKKppHLTdcTIA5YlRBJlxw91CjnOGnGAd+zwhhyiLrL2JBwzUcUi+OnVZbY4GE0bcpXCEqh2Xv2Q+rlzSg8wqGaG3yWPgqwMZY1FRLJ4bwQNpIxO3iD819CeI372jFZ/A6klH7fHYuFegAiYeyAjc3haQhzWVIRgTTtUW/vrdcMB73Zuox0pPfSeeRo3qmax32mm3qanOYnGEeJJUYAe+QNwHxSSMQ4eTRmYxFJcheTUZ9F+tOPH1H7raU6t+I6rmSlqheGIXqrCyVtcPfi0cub1TjhevgQJcT+j6ekRfUC8dMxD8cb0yTtU8zs1pug+xZLWbp3Sm3YjG2gXDXUVnU85MsEz5uirz49odQJOZfOHTlz5VFKEsXtgsxuZm955fWpKPeQoNOhkkT+zF9ujZ7Hq8JZWKy42Uw0QeOK9vBbbhtDH+mH2MAc7CPZM4GArxxQh5k+Ta8gnZdkrZmdrSozYUCA1GGXV71zlvv8Oumlg5REPGANS8Z6WZg4deI6P9E8F1Np5wsrSOX9xPLOwV6HhVafQXvQ/FHaa2ebHHqC/dZjOOXi7Cqo5JH9AzLNs5nuc40KWMLX++McpupNa+XmavbqevZYZ8mHAhNAV/QWeYmqiSyPnek7Y/rnQotkrN+oiLZGbFm7xqaDrJYtuNdgN8vG9BaSURu29d0MnrgOZIdqWlsCcpyOywTfJNA6EB6aCv+YU5a0Inha3gXxpDP8ot9oymQ0ItOGecuqIi+RCxngN+pieNb81
 0qSVuHb7
 istcaPWiJGicsJJ/Ec6XhB5bn4v4cK0smZ9ZLgY2WOHAvmjXZkwnqklWAd6mkQzTPW0fKNbviFaYZ/0EkaZ12AJ6u3cE34D8O1G6deaaOWSl5+T2S03Zl5YSsHdIjWQJs+n2jPvM3A0EL1SNEnignrqs9vQ0jg+K6d2zsu9i+3dNcWbXsDcITroqDdbqWVpbbNYxws3JCERUT94HQsFvM9OZmd8dGwks0Tnz9LpLT2NOBx174Oyk+iANXAMSxp7U9ymZ9yvHOeh6+YjldZgPXbdqMiHDZEZHOd9WaL9z0tWPT3UKrX70+vs6+XkXlFOJlnsDIpET3TJK9sUeBRwzZEpSWakCyaR4qveYEvx8WFWToPeQZr+WiqS4trqh+EcbCJ1ud/JxBAGtNwYIUMnmPE1ucID3X286yAnsRSOl9YWVJ0oNHbesIqRny3nrTneoMjdaYqEnc6pngpiBCw6NMHDq3q1syIY4EZcTRaG6fRzsJVa3qawLtdLEiA6CxQuxKpSzU9qw0FsTlRfFhDmMNfGuciVaSEL4lkpvgfi/tvrmvvpy8/sszguhVPOr6+AYTuiHBiiYznsaBerQ4Dld1dr3xKnA/nhfOFhHJ3Abyzni5lBfvwCLZ0L+5ChxleZGGATOXV1KnK7+9f4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not sure where I put text that is not the patch description and not in
changes. I put this on seperate mail reply.

On Tue, 18 Aug 2026, Foxie Flakey wrote:

> During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> the error code is not cleared even after we processed it. This leads
> to a successful retry but then the same pages are retried again due to
> the stale error code. This time move fails because pages are already
> moved, loop is terminated and move_pages() reports a failure.
> Clear the error code once we processes EAGAIN.
>
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Assisted-by: ChatGPT:GPT-5.6-Luna
> Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>

I'll delay figuring what to do with Signed-off-by, I'd rather keep Foxie
Flakey because that what is my "known identity" on internet at various
places like GitHub, Alpine's GitLab and now here in Linux kernel
development. Would be nice if I can keep Foxie Flakey, like again policy is
policy not a suggestion if Foxie Flakey is not allowed.

> ---
> Changes in v2:
> - Updated on description to be easier to understood
> - Reset err before retrying, instead of fixing right at the move_pages_ptes
>   branch.
> - Added Assisted-by, received an answer few days ago from linux-newbies IRC
>   that even I just used AI/LLM as "fast path" of git bisect. I still need
>   to add it following
>   https://docs.kernel.org/process/coding-assistants.html doc.

Would be nice to not have to add this Assisted-by. Mainly because I just
used ChatGPT as "fast path" of git bisect to avoid needing recompiling
kernels during bisect if ChatGPT found result first before I finished git
bisect. I feel like my effort trying to understand how to mail, write
patches is undermined, but policy is policy so I don't mind if it has to
stay.

> ---
>  mm/userfaultfd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index c3adedaaf7d5..ec5d511bd179 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		}
>
>  		if (err) {
> -			if (err == -EAGAIN)
> +			if (err == -EAGAIN) {
> +				err = 0;
>  				continue;
> +			}
>  			break;
>  		}
>
>
> base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
> --
> 2.55.0
>
>

