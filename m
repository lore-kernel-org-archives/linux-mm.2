Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFC9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DEF6B0088; Fri, 10 Jul 2026 00:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEB66B008A; Fri, 10 Jul 2026 00:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDC56B008C; Fri, 10 Jul 2026 00:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 546FB6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:04:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D96C5A033E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:04:36 +0000 (UTC)
X-FDA: 84971525352.27.EEBF670
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id E865E1C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:04:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5aJXCrL;
	spf=pass (imf21.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783656274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNF8W2Ws//G08pXfRWGw+maScnE9FJ1h0lp7UzMe5ks=;
	b=0JaOdVSyT4XG1hqZahcnQnYLwPjN+y5wDwLa8KntKfJEmRAhQw6zbaFqIfBOAnDV+1YNHc
	T9ZhtzM4IUwBEFrnhuvUeIo0WrwTP05fdXVh87/ljqCoNwx29RIqxeEqb8pxZ8Epd/zAWJ
	uzdyRLlOGdNRB3zTtlqxmKsvYq9ZLag=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783656274;
	b=T7uTT0bghMr1c4svEe31FNRbCFpssUBMXOfaTvgwXxtx1J3UfCgq2BpcBskte94JVCJqZP
	6EhqfFx8JkgY1TjfXB6R9oJRJuRznRyXlsxxsDFVNQ+HPKZh8Iqq1j9ZLLVPzyhD3cVJSU
	xa6XL+5/ZvJBPDOdtSGsdvl7kOkcrq4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5aJXCrL;
	spf=pass (imf21.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493bab44440so2316815e9.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 21:04:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783656273; cv=none;
        d=google.com; s=arc-20260327;
        b=Pu29w6lC0/ihzDmTdcUFrKf22O2wfUuyoML7b07yk1phiXQ+903IUGosSGGXu1rSBl
         GfEAQEc/gbJxFKnAjl+dYXeh5mLoAhVAv0p+s96TP90dRt8B9ahuHu4No8H2k0KXvmax
         gIEU/uy6sa3c+6r68YjmSMdWgdBOcbE54DwHz/kP0aY1PDafVWw0PNp1GlKPDWEMTo6Y
         Ziu9LuOe6XAWtTZiqlZthmYaLECuqRtPXkTjuIJm0nk9IgEKI2tthUg4c4jnxYqmAePy
         jznKrW+L28MiPoa6+BXBECuBzEsmq+rdyubw1wIcYLTWgZqb9MZ/wuytexb5L8NV/1sw
         zfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yNF8W2Ws//G08pXfRWGw+maScnE9FJ1h0lp7UzMe5ks=;
        fh=yiK7mRgXWapgEs8UX9zOwmKlUL/YzRc3pwPVXgeYavI=;
        b=FCaZJU4n9BQhHFTYSYU7Tm0ErZDhGITkYWsWzuYDT54gqnHpS46OMldL3eClxR5B4k
         8cW46/jFI+MEF+fbvb+k9tb7M27BH2FIMdNha9EJ552BQoNNc4G9EsMJuXYqjRJbW56/
         3+wwDstQIxBC6eneJHC8yR/ZMRnjjWbkiPl4OURjnTpo/U2LGam3NSyCtyC8X1ifPsN8
         TPCkik8eR7SkcltmkZBe9dKoewsGlOr6PHMGBZOMpPSgRNBhgmY/09AvSjf4XQepqdO9
         Qfo80i7U2P0GUOMmyaELsDBB1Mg/+fQlB4m0UstkIOdSoS2INRkeRNK+c+vbgk+pMD7w
         Veqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783656273; x=1784261073; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yNF8W2Ws//G08pXfRWGw+maScnE9FJ1h0lp7UzMe5ks=;
        b=j5aJXCrLhQdH1mbAkAOntU8ihb9tIHbn2ktVkOTqrssQhrzXMFoyx2ojaHB3Pl1CbI
         i8QIF4SG7ZifqKjXH1leRSkgJIb+MJH7/jnfclUBKFArezFFFJcLGxz76zzQPbyHEabt
         Axx/dPeUuC4wElM0eYIesAUiCs/tLMku4VU62UKM9Q6zZtIiHVXeGwDwPtPKcbogeYVW
         ehmsj++uurAHARJ1JS/M7wVbIrSrvYt9hmCkPPiJfnq8z26Qpte3EsXUBnR2RFpTnLxx
         GAh2hFwFgC61e4EeBy5RK669Ra/a8Z7kGFzfJHTI6yA3z/zMiw1WlCz9x353R7pI4Yvx
         2yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783656273; x=1784261073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yNF8W2Ws//G08pXfRWGw+maScnE9FJ1h0lp7UzMe5ks=;
        b=JA/6GN5shCt5rMA9YyT+4z7CNxaEcOPAXqSBqRiwd9ccUap4zFj+s2LJfYt7X9TxQ1
         9Y93EHV4tbB9hHkheQiacmOfLRegx16QHZFztgK4ngcMJ4JrSsO7Eq7lIZ94jqWk9sam
         96NPdYNDZT8uIEG98FpvG8RJnqVafclWcEcMxkrW84BDqrLZlTmWFZcO6pMLUDVkIKcl
         9hcaNemOQRny3MCNwmr27eETHmdU92XSnMuUa3IojaYpKcuwBFWy2Dfh24qqwWsVfEkn
         1ykyiziklZoEe/x/07xwM2T9his2FsIXempWOIwV7z1pjHOuOeiMM5l6Fb8FZI2+KdUB
         ceSg==
X-Forwarded-Encrypted: i=1; AHgh+RoceeoKP9X0hYesP7E1FVNE37ew131n22UmV3g44myF/+qDHP3mJtnruA/qlSAJZ/dWqh1C7aiaLw==@kvack.org
X-Gm-Message-State: AOJu0YxV5OWoTfuY96YnN5pujrN7GaWa3q+uqH8B2hAf+acsTmUJjUpO
	cstoLwMfX524wfuAa8Cx/hPEw8Lw0oo1PseM1t0PBJk7AXHMLREk2c+NWoy6BiYyPB+6g4fiWQX
	/3CvSek/xUpqZ+B6qN6u6SzBIOQkkqIY=
X-Gm-Gg: AfdE7cmBLoXcImU4URJEimkcy7R/ZrrLe2eUxjEV5bpl3IjYjPuRxMJI7ORWB5kfTIz
	4a3ga5fOhZzWMhU+Qe/+3QlJnpjoSoxXJb0kaEcf+fP6DpDugq+Xk80UYCskMnV9ht6ox+Uq/dI
	vJvFcj6o6bA1ZZ9Ayebcc57MuVObT7XM9J+IN+Nl2ClT7NRh1lbodFEYLobO5j7YwAMwdGNKoep
	fztVFlqOaAqwq8bvAezCZy0VCG3q1IWrz0+f94I7FszdC2vXtePRhahQnnoXV3fHKnCdU9NjWbe
	DC0r2WC2TlH6jwpHKww26vjCV8CP
X-Received: by 2002:a05:600c:3495:b0:493:ecf5:89fd with SMTP id
 5b1f17b1804b1-493f2b4a78bmr14602065e9.17.1783656273222; Thu, 09 Jul 2026
 21:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260710024429.70923-1-ahacigu.linux@gmail.com> <20260709202247.8cf6d7ab840f3a45c7eac409@linux-foundation.org>
In-Reply-To: <20260709202247.8cf6d7ab840f3a45c7eac409@linux-foundation.org>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Thu, 9 Jul 2026 21:04:20 -0700
X-Gm-Features: AUfX_mx8fwfMsUChs_VwUu-MP1oRpVI5QRdJAFRKV7Vj4n6BWeJ5YI8iKUQ1nOk
Message-ID: <CALjTKDkqCnT=AYS3VQPYE7SEqRHDHZvUt=8upRnRQDOpnjbfyA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E865E1C0003
X-Stat-Signature: b7tx7ff5e8ye81u7z78n6617jwouq4np
X-HE-Tag: 1783656274-162762
X-HE-Meta: U2FsdGVkX19raTU/WrUwh4DOuwqJhnd552oua7/21aUaSGVBDcA/GJ56PZLpITUNEwn9DUikHRRk6YthyTZafLjPdI9udP0fxrE8gRfDZuX4YG/rzHAw6oZ507jC3SRJc40B85fil0MkosPQdtrS5758oi/tvowkL2INYuJklN8moYYi/NhH9LGRPz+Mw26tlk1wONQ2/IEStMYDu02MlqVbiGdEdmSd/Mp81PyXu9ghNjnl8VAGFKeyP45U/sbZ8sGRY47G/eaRMjCxVg73WZlBG44am8k3ZyALT5Fpf37F77XnsECCebaZoclIQdk7RX5Kg3dk7vMWDVtVRiZ4V7jDATvX/p9+aXDcyNmkQkrLrxPYXm3RC6MvcxHRe4GqyUvl431YpV2pdjaV10GXsqeWQIEEDtb4L6I3f6AQk2zfjQ99FtV8JOCX5A4F1bca3RTzCSDfawUzPj8KU9oENhzh/tRHKA1nmtNqcLkj+BQhV4YmjINkS1E5Yv9v+0YNJgXDZ+ejSM5fOZX1HdQqV1A0DDYK7Gm4bbzdfW77M1pHHFfWI8NsZNQWgKbZr6BjgHROPDWAfQkVuZHYniG0H3jahReAgZFgj0cfBJh5+4v5WdgoI++vllo165x7yElQ3PIlstn0y3YDciSSba92vpixNvohzDU/nUY4cZ/9bbORUGCJG0KMbiXat4imp1cdVlaNUFO4VJcbrQqPLnmEa/10km0TBzbvpQiUeXpKft/xATQCVHQvVp18MoRGaDiklwHugnIi2pPBrKkDn7qNzFmNy+rZQc7ru3ymNt9nsFiEK2cYbflIteM3BKLb5B1Sjf8RrZGmgntSGe7k3f/v7cTMByM+i38msZ6X5goXwpPADpaCLeNJcHj6KHThiLzI3Ou1EsloY1BMc28ng/90aRzU7EgBOYmG2diBfyaYtg52289O6Oj80lFpxOMOd0mg9ibaoD19MSrueQ/juru
 /71xyS9l
 GW1y7Mq1RL5fKSWDOiwXSZ+Vt0QqSaX6+wzK6b/oXWbYx/VwRHtvCK/CjqqRMgW68tb+L0EMnBSP96h2bF5NkEWeZqE8JOXtWyz7IInTgQg4GERLMyWaLMu6OBTrhewFwT0Gv7qyvmYspj3KMFfcNFZ75I/oIzKVakIK0mrTWYULPIhCg+aPZVQVsLGob4ApHYMxOZkcXdOMaDAfZ6rbZE9gHfYu10+VxkY59ld31+l+qvrnw/UCldY0fBy3vXxYnB4mt/xj6LIEIQ4xduUv9iGjV0+O6yc6i50zc8ZdoPC/f4N2Ki4Cn9DSU1IPNLjOsSFUyJv360/sITipUTIXarew8WZGX3oLz3JgaIUVAUUu2MRXYqbAReEYEjV1B/DBRTVHCFOw6t6fXNqu4OSn0Y+7Pu7dXFUVwHUuitwukUbOqwozj8FpgZdwbaQjDK8okAEjUalPDY+2naGWsqY+P2t1ZQ4q8DiFhD8abcb9XzN9QHyAmx2ht0uXykF+PnQnvxFcjTlHyD7K/SFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 8:22=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu,  9 Jul 2026 19:44:29 -0700 Altan Hacigumus <ahacigu.linux@gmail.c=
om> wrote:
>
> > Direct reclaim clears the hopeless kswapd state only once the node
> > becomes balanced. This avoids cgroup memory.high reclaim repeatedly
> > reviving a kswapd that cannot balance the node.
> >
> > However, it also prevents global direct reclaim from reviving kswapd.
> > Under sustained memory pressure, global direct reclaim may continue
> > making progress without the node ever reaching the high watermark,
> > leaving reclaim to allocating tasks.
> >
> > Unlike memcg reclaim, global direct reclaim follows the same node-wide
> > reclaim path as kswapd. Clear the hopeless state when global direct
> > reclaim makes progress, while continuing to require a balanced node for
> > memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> > scan_control is private to vmscan.c.
> >
> > On a workload with most memory mlocked and the remainder under sustaine=
d
> > churn, with swap enabled, comparing the same 60s window:
> >                               base       patched
> >   allocstall (all zones)    413441          6532
> >   pgsteal_direct          15889552        255619
> >   pgsteal_kswapd                 0      26079382
> >   PSI memory full avg60     13.10%         9.37%
> >
> > Direct reclaim was already reclaiming many pages in the baseline;
> > this change lets kswapd resume doing that work asynchronously.
>
> Does this change have any user-visible effect?  If so, please describe
> in elaborate detail.
>

Yes, the effect is visible on systems where a db workload mlocks 80%+
of memory and the remaining memory is under continuous pressure:
allocations stall long enough that ordinary tasks (e.g. ssh) become
slow or unresponsive.

> If not then that's OK - we make such changes all the time, but they're
> less fun.
>
This was introduced by commit dc9fe9b7056a; for long before it, any
reclaim progress revived kswapd. Now only a balanced node clears the
hopeless state, which is too restrictive for global direct reclaim.

Thanks,
  Altan

