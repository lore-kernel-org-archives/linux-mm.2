Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2DDC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB056B0092; Fri, 28 Aug 2026 02:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BE46B0095; Fri, 28 Aug 2026 02:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A966B0096; Fri, 28 Aug 2026 02:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E37A46B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:42:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B37B612028F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:42:45 +0000 (UTC)
X-FDA: 85149735090.28.22BB45C
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9BBC1C0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:42:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pk/GoxxL";
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787899363;
	b=nGDEoIyl8dJV7f9yFB6MaOrmhDOpKy5P2bnirU339Gl19LeP43ISNHbPnQpu4jrN+TxSjj
	EEOyCEAgvG014UZW45ooG/Z8F+EH3Wgu0qm+pEeLLi/WHfdt3vNvV3c3CB1kCks5TY3PYC
	2JxoDLoaHT9slRgJHMu5QHLiL9rlnT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787899363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1F/vttu+vhSUybmlNoSvxhrUsq1hJOcWYGb6fs+h+w=;
	b=DuzH73qYlA80EYRNWOj4n+g4abhro+z3rEjZHuhcu9S8skjd8sbk+w2Bc7j+7qH/PGx1Mh
	wRANkNRllk/wxhSxtUIpAN3PqJJ2Oi5BZAva80iIzgVMJ3EWJxtRBZpq90HeWtkfrGMDmA
	3CtnlFPoLhkIVU1mKw7VsPcY+UozFCA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pk/GoxxL";
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5c675e64ffcso1161083e0c.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787899363; x=1788504163; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C1F/vttu+vhSUybmlNoSvxhrUsq1hJOcWYGb6fs+h+w=;
        b=pk/GoxxLX2FynCdmiH/D3qL7NXDfkSONSVGDeWqw+CmJF9Gv8mjMgmXd4zM2hQI6lK
         8FlQ69TTFKgFXcgFqahaFr7DbQANmFCWrXdUQE++fM5aT7pR2v0NovClYQ6yLsKjUcPp
         o+L355qUrFu6Fje/utggB3GJV5tfBNL8Hp0BN2mupryWtzpZN4UHqDXAoxr9t8mDQ8c/
         RaGOIYUHY9s4Sy2ggB1bFDdYZUbW1e2mzazWBBN99aV9k3qY5J9SEG1Vh2sMdEVwtHsq
         w2FcmtznhGOucAwzEKAm4rBOnVrGOjNsN8vLIrd25jGmRGyA74IZzpME8AifY03W6S0d
         vhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787899363; x=1788504163;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=C1F/vttu+vhSUybmlNoSvxhrUsq1hJOcWYGb6fs+h+w=;
        b=ZFgS5eKrfgu4BkvDkjrdpTCnp73xT5ZutQHusdKY4NW8qXwyK0GHPvlnIEsl5DhvXz
         z3NVJswK5BHmJwV256qzZLA9/ogVmo61s/ncWOKQpEt8eSlLX0TTLJV1xAiXT7A4krk8
         Jh8PHdDTMzyVNy/LVMDumzGgmg9UPsEOqPYQliF1XHFjzsSFfi04HXs5y+SulalhHdcv
         vcWPuAinKzDo68yNnnDQEC/ibOcw2Oc4utl2HR1UYVbzMFC+1tPBI/F0Auh2jVNJM4bV
         07Xagwr9jTWPu8TAHHKcikpUMp3asIcQh50XuM6qH/jIHJKqbML8mZhnEYfk5Z1fQzEZ
         rhIw==
X-Forwarded-Encrypted: i=1; AHgh+RpO22HzVBOLey8vopGA1PmVzNMOeT6IybOulWdDvLlOnv6wJ67VOVJBSyQRvUEWDlxFFXTFi5Rhqg==@kvack.org
X-Gm-Message-State: AFuF++kmLCLzg4hs9j1JxS72Rn5gvoHl8OBFCCEqidbJV0UO+piKXC3N
	lvEE9qElLNkhAlCd6mCNUalfi5gqWrF6rL9bQ+6yUIHjQXtDf53PEEPQJ+2RORml
X-Gm-Gg: AR+sD12xZMg5EO2xPFNvU9uPjCCrlEtrV2hVazTpbi1H1uGKjbHYKrFLV3c3RBjJtU/
	TtwB+r9sx0W4GexCYSrCnsvrMzKdlx2dKqI/eAUfyBLx1S5/1EmWYrtQEomDfvhiL70tMk+3pwu
	xOqaNjPCDuKobmZi3VU02yHDFO5d78qTvWUlc0jObiCy1zO4mVe3kYkqmhicAu+27yDusZj8uMO
	gs3gZSEf1JLpjdHXpPOX2aAv1+rc8PmPJJ2PSKZVZI+ZPEBq4WmC3PiPRhYuAJVPXYx5Afkjw/V
	qUWVtx/cw64BszJYHS5VZzBTylB65CupRxf7+eR2BOQjpIOYX5Eg4cPromiUC+roy2brSvxWiUU
	b3gBFP40w0iSwwpyXC2wVq1ugwFAgm7aanGN/MUTDNfnKprNwqN2j7BntrYMiUTw8ZcxizUHkYS
	zu2tDW2UFo3pcO165mGmMM1GwwQYxRwKQv24tSIphGUa+fWQN83lY1t5c0APa+fJhRkThwixrCh
	Xw=
X-Received: by 2002:a17:903:32d2:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2d74cc74a80mr48204205ad.3.1787898881596;
        Thu, 27 Aug 2026 23:34:41 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598b068esm2546405ad.70.2026.08.27.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 23:34:40 -0700 (PDT)
Date: Fri, 28 Aug 2026 14:34:31 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <4836208f-a84a-42ca-aa74-bede23d7de41@gmail.com>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ao7Nr_FALfP7cTY5@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9BBC1C0007
X-Stat-Signature: snyc7hb6irfbudi56zn5stpi6nmxnmzg
X-HE-Tag: 1787899363-430767
X-HE-Meta: U2FsdGVkX19Yntc+BxQ/3J4aJDnDbhlRd94lsX2tGB8Fj96JJW5DmPbKD90GpDZoCp8x4T/GFCoO/1KmRUyI3ueTu+fqu27UDMj0hkR2hMLTUhyrElDgxZjdO3gidDOQgwUQmk0R4O/Rx/mE6wW6Mg17SgQsyqqMewbnZk/VR8oGepQtPM3fYbXp5Ja4e0Sv2GJsXwG2e+DYhse2kJ778zdS6rQwA1lLZUN0is7TNQgdY12tCqdMM/7Q2PZXh4ePWJpR8AWYLhwVtPsRRPq1026WUBoBPVVLw4/20ZzbTAR5PJxJ4DCw6YvihMf2ssDLzqs5znn0vAx8tuTUSt9dxdQ0U+vDI9fCAlU0O/MeXQbHKrvEIpFcnC4roTOeE3FmnKIegQcnjKBQM0aXtrrCdkRH/AQ0dtmMotIUVPOrdFHR7BpJvv6bugoxaRFOJFWwj5K1sPinQoG87d+Vo78YkecJKLjQn3GvpRRCbyO39aMvfF1Pf7HaGsuBSux+K50dL3/ot2soCDhZgYk7eVu5AnPC0gDN5IhOLGHfRuSu768Zz1kcZk5u0+3yQTV1T49lYqY6sygKfHGfEcqslmfrsQFPniRt+3jzSJjJJ9T74y7h3I9tcOiUB97GY8294+WOBTY7tIeY8k2rGek6IoQGH52y58ET5RjYJ9ZBof3tMmhz2ECaOwLYMd0TRQ+quOd6aRs7whu4W84hoKmZ4MggZmcXZ86pVYMCaTNIJBo6lt0t32gRa5OJIoG87SAAl5ylUkAWsjc95blFh7eyax6AFfmB0zNdGsr0dVEEzLbuBKbwA0aCId79giNYOTeHe/gRb7tjiesqat3+KqWkuaFSm1C3BB0imRJQhgQgGz6S9jOQEAz6mzcRspjBefXv1a/ova8rQousfv0GmKZmbZcEyimnGW89igV4Mc37/gy/pCzS2HVp07GqIoryaLhR0ZPhlXKD2cglRShPOhR27lw
 iENE9+Lg
 IAk0+eGt+RGQIlaDMohENbJGXKTgziKcrSmjtUoOKJz0vSVVeoHOwDxvF38SbTcEOkG/t12wT961BvhuAkdlLvfcnm9JQW08OJAX35W5bE4fRudtrzGd4yZawgCFWaYIkVLDz18RVQRuUlzIghkCYxZSUAZfSOoue5clfVdHZ5LLgnI2lhkqrNge0uyQs9TabFFF2i7F6Gjbfbmq2nQkSc4mWkFYX34yimp548BivVQwIwEcEkw5pT2e3kqChhTRrBtRvwZiRnODtgs12DYA3k6gFLMHiWa3BxZbppLh+vKcwV1wROWb89Arbyku5AiRV6kzL+1+xpl8QXyK4Q7qeyJaBpgoTt+XpavwzG0F/P06Epstw64Vq2+0ynslif6ScPjwkdm+cFOPJ+O4uXSN9QmjJIyIPO8soQ9OChD+rcEFVNmCNaiS9AcOF7HDh03FK9Sv582Sk1cgSc6ubeKrllZmhb1fUjzuteP4QlHKQ5jMOTE4+7ChBm9t8etkTnVNZZJIT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:31:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
>
> 	~107,000 words of review across 948 emails (in 279 distinct
> 	threads), counting only prose you actually wrote — quoted text,
> 	signatures and attribution lines stripped. That's a full novel's
> 	worth of review commentary.
>
> 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> 	and your longest single review was 2,404 words (mTHP collapse
> 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> 	of your top-10 longest reviews).
>
> 	Estimated review time: roughly 300–500 hours, centred around ~400
> 	(i.e. ~7 hours/week for 14 months).
>
> 	1,615 THP-related emails in the window: 948 reviews of others'
> 	work, 278 replies on your own THP-touching series threads (~31k
> 	more words responding to review), 382 patch emails, and a handful
> 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> 	emails), June 2026 (113), August 2026 (111); quietest was December
> 	2025 (5).
>
> Think I can be happy with that!

Thank you very much for your hard work. Over the past two years, THP has
been extremely busy, especially with the addition of mTHP-related
features, which required a great deal of time and effort from the
maintainer. In my main role at my company, I am also responsible for THP
and memory reclaim functionality, so I fully understand how demanding
your work has been. Once again, thank you for all your hard work.

I also am relatively familiar with the implementation of THP. If David
is interested in my R: or need some features implemented, feel free to
let me know. I'm willing to help out and reduce the pressure on the
maintainers.

--
Cheers,
Vernon

