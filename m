Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D43606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=eBuJlBVu
Received: by kanga.kvack.org (Postfix)
	id 4AF906B05B1; Wed,  4 Nov 2026 00:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488F76B05B2; Wed,  4 Nov 2026 00:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3783D6B05B4; Wed,  4 Nov 2026 00:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACE86B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:39:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8409DA046D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:39:25 +0000 (UTC)
X-FDA: 85396333890.04.010C339
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BD9CA0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:39:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=eBuJlBVu;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793770763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
	b=4Yav3fKzivlfj8y1Gu5ttc0PZgrM1CzJ7tLNP71z0UclRAE1n/mF3cJZH5m8Pjo3Wtil0q
	0fjU9MOPe9rlgJPsl5LFwnLuiEU/t2GpTdQNaES2jGpVenm3u1i6YiXRjCFaL8l8JZS6JE
	ZwYyX0IZplcukSoz8ZySlOwjaAADCdY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793770763;
	b=VWVqv2q157dSeitMC65DWfgMKKsHOdooenevPB7ulQhj6KP9V8BxZ0Qu8QjrUcozcZ3bxm
	4j8ttu+FcnLc2iAVxQ02yebRANZKVXqI9bVfExdv+18hVM6ZIAsZAfNnhtOYx0841msLp2
	njKpIGZIvehhBVVAVXll41XLS+LT+9U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=eBuJlBVu;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso610722a12.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 21:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793770762; x=1794375562; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
        b=eBuJlBVuWVj1zqffuoHelbWM3V8n5faC4OK/pWq/taEeUt4fUpbVjIcu49vdVdDJn4
         77vi1EYwcmm7rBGKSniBDptIe+UeUMml+jdcLtHwRJdI8KoFPsm1dwAR23pNDbvDSK28
         onXYH5KAh7HGrk1DzwCAX5b+ae4Ha45RX4ZVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793770762; x=1794375562;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
        b=adk1jLxoL8CqXsYnSb2Klk5PDRenwmmXaQJZovvCZ9uZq/GZINGzG+kdeuYxRAgIMd
         9+cZgNCYFNpHiC6kfG0D8H+gs9L6LFVvKZaq7P/I9T+B8RGKPYmxyLneKumxpSkhy6Fw
         1UOKXI/WPrSlv9jj4QxzLdB13YCebOvg6VphRhww9HUHxSx4ogb0LVEkL3BLA+FZ13LO
         QTnkClmmO+tbtkXWbAJaLYG3Ef4hxJsnceRhVyPazfViIA6iCJl1njFADFrXtvA+Q9aN
         grtPbOtJD3xfHtMGhLlcNAPho42nBbAULJsVeGfHcmWI2t/6jhZfkEyozV1i8DXppr5H
         IO0w==
X-Forwarded-Encrypted: i=1; AKwUvByRefakq0wvma1Ts6FXaeIZ5ppZpwAIq3l3Byr7gBvs5Gk3NzMzZSUjjZOLeB6ypfVvTgSacwsJ5Q==@kvack.org
X-Gm-Message-State: APuU4Z/M7zb69F3tDD8whWjxq7XMNPyEukY9XhjPb0vRF3kKmX3QQ/PB
	nMlEEw51Bh81yAi2sbOBkHYR5gCSkgTUaIpgTpHiOHulG4YfF11enOJCxLVMQ8xZmrkmAkgKqdO
	2REZtQ/ZDQA==
X-Gm-Gg: AYBFou35CrjV4eHuSMpUsh3inoD7cdtQ/2qu1ZL58WYoga6xMp20Juk16Vd/AoPe8HD
	YGl6A9Sgxne/lanb+DAACMGFhXSt+nUuQXmau1Nmx+2g721cVFZ3+5kjju0y5tDa0c0yJNDFj4n
	9wjxKY+T1r1S+suGw2SPUAa2yf6Qh5r/yW7IjEM+2l747MEbVqQgZaR5wtgJzYrzMmbFA77gA5W
	ObgkqQixGlEngiVnwGPA4b53xkR24GtIc5yes01QOZ1F8SNG5w/gV+Xn+hCv+hXXYv1tlOGl3k3
	CVl9OBRORL7FlhvbV2sueCRlJ8zY65D2P4JHocAOvQ591oOSsQCYJ/amA5rUMROjOhRHWLi6vQB
	V7YvvZwH/yRGauEu+Cr34nrar8ssSquJDxQ74CCt6m/y5BE6LGjnt0WCkT4LMqbVT/UR+VhlWk1
	Z5KFwUZMDmPPMgYNuejgb5/7DOVT9UkzsxQ0jhkBR9Rk+KNZ77GpsqU53RrdqmHIUSRKxawDO0g
	PJzP1vNbZtOwI4hRhYOzibRGCO7amRHNiZD5R/5mTxOCMZJGE9M/Qr77BaIkkjCdn89ad1sN8tX
	+8cA4PWZo8rjv2IM1a8hnTYDIhQwNwowt/BzoSaet6np4VdNtcQ2YnFn/XTmkPEntWiRWwqji/a
	xaw==
X-Received: by 2002:a05:6402:234f:b0:6b4:2960:d383 with SMTP id 4fb4d7f45d1cf-6b4dcc50022mr12268685a12.8.1793770761593;
        Tue, 03 Nov 2026 21:39:21 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b55ac5aec7sm394002a12.20.2026.11.03.21.39.20
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 21:39:20 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso45136966b.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 21:39:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByGGeKw3YnvMukkNbX47iJEX51q6sPa1H3WFiHpIQiNKeUQPL4ASzr38nijJUOGGXUtCI/VEgoStg==@kvack.org
X-Received: by 2002:a17:906:9c02:b0:c4d:f63:642 with SMTP id
 a640c23a62f3a-c4d0f63079amr48032066b.33.1793770759887; Tue, 03 Nov 2026
 21:39:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028154218.1668182-1-liam@infradead.org> <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au> <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
In-Reply-To: <aurAxRpCwzeyXeVj@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Nov 2026 21:39:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
X-Gm-Features: AclHuK8dMub4vC2TPpv6BcEahTt6-eYYmVZ48SoCIOo5V1xGWkBIA_qqXcqQYc8
Message-ID: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: 9k7k1xkka8m4gw9nrhuh91f34h7yfpk7
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4BD9CA0002
X-Rspam-User: 
X-HE-Tag: 1793770763-253889
X-HE-Meta: U2FsdGVkX1+9hES2rfcX6BvaTqKBPP+keWNvKbi9OjzSlv+WDUJb4e3CWA6pADPHLaV0pbdihEgB+26tBsynmR3uL/tcCYDJ/wpzQaFz2NN94NuGNS9ddMykRt2TfnYITUrgv3SThmVygb+SmwlcoH5r/ZwycRc9bPsi47x2z9lfPwL2wfLmGRRH+NZu7XUYHwyOLyNUW2F+yYCrmFIeDy4LKKr4tMhmI6yZxxTgFueWIpwBsuWeMV9bRn8CCbCq9tHk+TB1wz0NmpORnoK2cOdv2MQjdVCxBBYueTcp3iBOdcIrQ1CGEL8cFb+zB+t2cpQYVJT+8T2vTMLL/Wv8q75Mgpr3vfSqeIoi6Zqo4gY2Neq3TFIEH1Ra47aRDgJw9ScGkZFCniY6bSY471nwsTMXrLT4UswELgowlYpkU3xXWbe/WssBu7iXTO1lZctyeTg2APnOO1tZV/6h/giGuC5Y241yfVB34PL4EJ7AM5eIELz1x+AT+U92DvvTGJyRr/tqnvS0ENu4VgVytNi3i7LnJdxDGK1RBSRp0h/np8jl8Pm5cdZrWSO+EsnogxCNxXQN1uDmQqnbRmCtG5q5hnB0H+o7S/aidqHvHR97/h0L4c/WOAPv6AUyXVB2MxecL7H+63p+HiC0jswhB/i2VkpvjiLN1MXPae65Ip9bM9fi5wkgpGUgvNQMNNdAhg/+pV+TRLuxL1dMm4jLQw7+A+d7N/5O8fIsf/EF3H6QLvw+vo+7FpEM2R2rTK8tu+QEcEld2TAVADv7lTi5eWZjj3Oan1Eu6ngld3ClztPJjhh9ZuVUAgGRvraHP28KWrCYc2cSIl/cuvVLU2Q1HMMfn7H1CwvVUoLfupo3m6K/GwT8k6bggfzgvs0xrcPoI0SIbknHuBUGUKlQZauGCKK3HIeGB0mhUFZDY3em7UrHL9WYq7H39I9zyWrOcHOLns5U9OcnD9PxcAhvEVqN6wE
 4KeLvieP
 n03utqTSFcTCNxsjRZs6zrtHeZuzMx8GGJ75haV0qUZp2S4FUOETiJ3We23T4EBEa5bkQubM4NIpXVCBMM0+1Y48nHhyw4Xe3RanYyCd5pYN/QqMNsSEmEWHJRyoBeRR5xgkPFZ0IYibNsHFSfnvgJU+PCR/00mDUvaqAA1gzArTM45za3ajR4jnzL6XvEPLe4kUWlL8Pk57A8to3utpnxO/p27/ecqGtp2tYpzLatu+PXEGSY3UYVUbdtQMeTfDhB07YN0gAKup6/wkI79moD5HV6UT09b53azHmZelIKfkB6P+fZtp/ZP1lakHpeAlN9JPQt+elX9FGZ5rQLHBYgM3QIrqV5JmDU4ncGGlRTLUtVcGC5NKU33Al1qowOuO++2w00aNcKeVrO69uMqDRgKpkO3p5kD26PxtlpIChPCGTx2/RQ6+vxstLayTGbk1pdUwlXECeVQ6A19tobtuKE9bLqO0uRjMCX5SupAT1j5YkBLVLYck31UgOIkB0JokdmY4qqM3dxUXxEsw7/m4e0F1J8wCd3DdbQ4Vc7lk2BXO/8VtisoW4P+WXalgJOUYXm+e4LgUvVJ7FQAGauiw+Wn+IcApn7tVCWS8g84O3q7KBZ+xF5/k99OaefynH2uTNvkwVPxAhy9QlMCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 at 21:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Nov 03, 2026 at 08:28:36PM -0800, Linus Torvalds wrote:
> >
> > Sadly, the commit you point to doesn't talk about *why* that
> > braindamage was done. Looking at the original thread it seems like it
> > was for kmsan.
>
> Here is the link to the whole series that was applied (v4):

None of that says why.  It only repeats what I already said: it seems
to be due to kmsan doing bad things.

              Linus

