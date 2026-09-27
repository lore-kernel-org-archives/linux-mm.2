Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB60C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 15:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8FA86B0088; Sun, 27 Sep 2026 11:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40746B008A; Sun, 27 Sep 2026 11:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F286B008C; Sun, 27 Sep 2026 11:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9D026B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:07:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 195A640A1F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:07:00 +0000 (UTC)
X-FDA: 85259869800.18.13D7324
Received: from mail-wr2-f26.google.com (mail-wr2-f26.google.com [74.125.225.90])
	by imf22.hostedemail.com (Postfix) with ESMTP id 39301C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:06:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ehNLbuy/";
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.90 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790521618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrMFIXOrRMNN8CamXouNMnZGLVuoBTeO83yFUevJuik=;
	b=4a3kzGPlB+735rlHAo01jJLKa7sVg/SGo/TWDGoKN7vCQD6bafyk7XQAS+KvFhle0+bQ60
	UzhjsDpHmkm71wi3Zgz7aJx3+yoBCFEvUeaL385SWuwfCJWic4R5Jtwc0HISTKjxXqL1Q1
	bbrNjR1sDtMK8Tun97X/oeH/ea080zM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790521618;
	b=azYvQgpW3U0Fbp3nwTEuwjorDqJ8BfkQSOGVKfl5cWNAVnxVR/hUGReF8pHV74p9gmhPrL
	ZYnZ5vtc4OTTzMnEKoJSE2SpCzKOSo7PR9DhDj3OF/MsgNCylMOX7j2gtXP3+2lAZXKtya
	h1xJQhrDgXewlIVZmaxA2dmC5L1Dizk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ehNLbuy/";
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.90 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f26.google.com with SMTP id ffacd0b85a97d-4843f22dc83so1881410f8f.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790521616; x=1791126416; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CrMFIXOrRMNN8CamXouNMnZGLVuoBTeO83yFUevJuik=;
        b=ehNLbuy/TJ2bqsKZ+LWmkM/GPOONiy4xpcaXsokAImRGRRJZvqs4437/Vr7cwYRTFp
         fF1sDhjfcQ6HowxIxv+MKE15GOyMBdwb07O1UDVLJ3vqVVnyRf1wOHV+aJxXjrboduGs
         ALllwTs9k53NgAVx2dG+CRBZsCxvlxrfG4meMuztM8GkxkPlv1I9CEfl+tvrFl0jfJDu
         uev+2V0mPE52/pg+XKUI7wcnp+gEwZXPLfc1Lgh+SFZEMwLjFeYq+YbxHLn7dJ8MKrgf
         H9qCSrkNoGVd5Rka0222hcRa7yl1wVJiAVbQ43q1Kl+fFpDj8LAL8j/lmiJXqOGpULvw
         2iTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790521616; x=1791126416;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CrMFIXOrRMNN8CamXouNMnZGLVuoBTeO83yFUevJuik=;
        b=XrCjT1NL1E3g0qDfL7QE5Er2jgi2WzimpZB5Rw5w4USLbIdfIEBrCZJydU1o0EPdx9
         g72eFRc02RcXPPBR0TGWdHfAHU+79HFLZ46W0I1BTjJ9wYHii3EFglkT68TwhdkBSXXb
         UziqVooZIcvmDUI3O9OsmNK1YJYUqE84kyKwSFGIPQhHr4ionxdUerN7o1lXK/WjWxdv
         fKo0SfQWBnGM8wmQEwHtPb7U7OuabL7AOuLW3vIZZX7/j6X4FAxu6pZKHjgJ7RyDheMO
         qOM6wrKnHhRfetxYZgPt6QbD8XPmR4bIp0ygPPQ76WtGJDMV+xKJQFgEd77x0s9GztDz
         z5pw==
X-Forwarded-Encrypted: i=1; AKwUvBzEK2FyZzQhtAoXH+TltPyXB9COBKMME+rXB0jzUMH6/ulXjScN9Y/HLFX0GxCB7aGXsjHAxaTZqw==@kvack.org
X-Gm-Message-State: AFq9FYIjQt1nizwDaB6654ggGP3yBpWks7PChRBs0t5zOGEpxAeFCmBh
	ObERxbAKffwM+waqOxFK0k5BUy4oJWzr7lEiQlNj+zLCMbKoVMMg7OtF
X-Gm-Gg: AYBFou0J2g6KvYGjrIFXhQpx7lDVhhsFVgU/BcuXrZXR510xHVJP+vz46dvj8jnbYh7
	06eWIK8N4OxK1dsYmxV06q13jbrxWMGjbb2ips8R+o3uhwvC24BEQ9xWxVFZ9SjEEo10k/1dvNE
	c1mVFBIfeAOwPOLx44ung7P5/2gpy55WxAjZDD/GKHwqWhs8z40JzjHb2C0SdM/+ActJwImBrEQ
	t+d7ggNUs2RV6Wnbq2pIEcGasscVsDji2A9iMzTsZU/QfVXvdAfk7yR792DiSQ9CEKAm7HNBJT8
	M5lFDgYp8Md5bwWVMJB9EHs683uOTsSc9m+eAPNVAUqXKShpl3SbXjqlBFqoXq6o/GJ6RU2GcrK
	DRd7A0wEmzQokptri22aqxGEoQXkejLkJoAKG4+zf0tQi62GVS5mt/K/ga2ctyYU2XTrO2xrEzu
	zvIr+epLIfqf26NDt+t4iXB72nFQPPdyD1sJ1hNoUPgCkDlYahP25XnwJZLRtQDeq6EXEDPw==
X-Received: by 2002:a5d:5f45:0:b0:487:2347:817 with SMTP id ffacd0b85a97d-48872abc804mr19369239f8f.33.1790521616280;
        Sun, 27 Sep 2026 08:06:56 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a638sm20467465f8f.9.2026.09.27.08.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 08:06:54 -0700 (PDT)
Date: Sun, 27 Sep 2026 17:06:52 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mremap: fix locked_vm leak by splitting VMA for
 MREMAP_DONTUNMAP
Message-ID: <arkuBw_l6iL-VLuC@gmail.com>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
X-Rspam-User: 
X-Stat-Signature: j7hfcueixoqg5amcx9fsu8ztcg1j9yqx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39301C0002
X-HE-Tag: 1790521618-6547
X-HE-Meta: U2FsdGVkX1/AWaPp19ULNa2G+pQ0Vnkb3TxqGRCaDdBU11gRzls26QghLpHs+ViPp1UtnHk1Lc1g4Ncm4Vg0aqQRUAcCS/S7tipUcxjzDA/2gPo1D7iP0rNs3PTNaIWaoZiLNF8pNvYH2rXnfQG6spdZHH4rZQJSGfuLPVQzZ97gXYleiD6pHfOh9TOCv9+BnspceHZVs4/P/IlVCOVZBK/vK/wgyaIivWZJ5usqDjc11+ceLUiql6yyhOyYoY/6b1vUWsruGOOkJ1HnHibaKVWF0J+63QgEr3R2ie43cCNDFSz+G2TqmFYPG3mqS7eoJVTuViaNLKDerEM9M0jhiOBOQFuBE79Z+4DTX6p/73nNNPAazZeZEk7gXbyZejdwRQAmcZ+VptihYTD4MXDe3Mk1n7ylzWotjMrE4DO2Kdqw4O9D6C0X7hi3F/uMOkjBUbxFx5QnMeTfuydSkPYQrqx4vEooStnLtd30ltO7nrp1JRi1Y5q1XemBnM/jec7yW47itHeir055Xh+Ur4jbs7pjm7spQgjz17gBa5SQ9N1/A1fqkqqj0cP2YG4+VAPm69r48o4lE13rZlEbtCHPhJC0AoTtBGJhf/93u5+DgDG7rvdPZkMwPmDk2qD3d/W3P77iDEfnCOfO9pn7+Ja4ZkUkpYnQfZy35GbvLVHKspyzOmtHwnkD+EPo3objZxBHTpVV4fIQ8PdEVYs5XwFCHX5y3qdk+9pwT4Ve6yHhWQftcjWmpdmEvYB5d1z4LXYC0YbYv4kpQTGzwCMvu8kx/H5Al2x/JuoRwJWCxlQbUtuin65aRzaDM5BF5ebHYEhDZ/Midhir5gL4WRkh88yMaQ2Z5SUq328imWqQ6zRWxMDTiE/jeyZj3eelQJFC+nxTVWEzp9tD1j1l3NY72cNr/Zmp2ENxTH3lYfgD+BdLlqcOMt/jif0mzyTT9BQ99m4Hxcji634vOUxowC9eXfY
 RfTCkM4d
 QgMAfkianIGXU24TUWdcmQURmPK6dKXEsmZTXAOplZzl6wWncKaJ9b0lC4n/NEebyx0/24EaW7wkTDXWVxpI0HBe/iyIxrHSBRhPu/v8hS0LNFpjbKJ/HK0YoOZ8cTEn3Sn6EQca5eXAilvbBVVaKij+4IHzyaTUWngHbkzJafPBDi5qANiVlY/XG95uVH3zVJ+ppII/fIMhu4U+Paelz+ArYZRo3hQoY37L+6MlsKBQU36XZqN0yXQbbZJ29cuQx5Z0eCplYw6IR9Lznm5+yz6RN3b4lqC2NH4S4q4EHcryk+CQpyiKHPCTWxwmSUXLb383q6RddPsYiw2gBe/DjOcgXtfzhWXB7rUNWAdwH81Stec0GGgdMt1I3ITdCdYEoqRY0BRVuqSbSxxhErmwLN+fRZR2rGP7mXgahcvFR20Yz78e6Hr049wJEgNyxSICWCWuQs95iMFmk805qtF31Eh7gCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
>
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
>
> Fix another of these - partial copies.
>
> The long-standing mremap() partial VMA logic has the baked-in assumption
> that the originating VMA is unmapped and thus moved.
>
> However MREMAP_DONTUNMAP defeats this by performing a partial copy
> instead since it keeps the source VMA around.
>
> An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
> but the operation can be performed partially:
>
>                            |-----------------|
>                            |                 |
>                            |                 v
>                         <------>          <------>
>                         .new_sz.           new_sz
>                      |--.------.--|       |------|
>                      |  .source.  |       | dest |
>                      |--.------.--|       |------|
>                      <------------>
>                          old_sz
>
> The page tables in the specified range are moved, but the original VMA is
> kept intact.
>
> This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
> cleared for the entire source VMA and set for the entire destination VMA.
>
> This results in an mm->locked_vm leak as the change is therefore not
> accounted correctly.
>
> The clear solution here is to make the portion of the source VMA which is
> mremap()'d distinct from the rest of it, a.k.a. split it.
>
> Therefore resolve this issue by splitting it ahead of the rest of the
> mremap() operation.
>
> In order to make this change re-expose split_vma() in vma.h for
> CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
> instead).
>
> A quick search of how MREMAP_DONTUNMAP is used in the wild suggests that
> the partial case is either unused or rarely used, so this should not result
> in unreasonable VMA proliferation.
>
> Since this makes every mremap() MREMAP_DONTUNMAP operation operate across
> an entire, distinct, VMA, also eliminate now-redundant code checking for
> this in dontunmap_complete().
>
> Finally, update the sys_map_count check to account for this case.
>

this also LGTM.


Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

--
cheers,
jose a. p-a

