Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA33CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDDB6B0005; Mon, 18 May 2026 16:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5E66B0088; Mon, 18 May 2026 16:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC4B6B008C; Mon, 18 May 2026 16:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0FC6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:20:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D1D5161877
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:20:54 +0000 (UTC)
X-FDA: 84781659228.13.5A7E53D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id CEF081C001C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:20:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NkxhwMoZ;
	spf=pass (imf20.hostedemail.com: domain of 3onQLaggKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3onQLaggKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779135652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE9J24ZIKiIJrzUDfxiR2ZliFW1zd6YjsXv6l2fJKwI=;
	b=Jw0BO1Z6XAIUVPU38LE7UjwP0inlZtHR4iY9e1y4aqM3LIHv2eg16bmfW2XyTrCdGz2Ij9
	kPEquXnz1MVEVTAPZOqZN8rnbdzoWW0Y5o6Bn7Zj2e3g3v+mnXgl/19wy7Q9Op9AOrnIVg
	odVXVKF1c+AAn24poV1Sofw0wtNZnUw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NkxhwMoZ;
	spf=pass (imf20.hostedemail.com: domain of 3onQLaggKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3onQLaggKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779135652; a=rsa-sha256;
	cv=none;
	b=gDaY4eYHW3Jax/RqY4/mdYlWL94UZyzpGIJCHgCu+v2OmAHaFmoLDOXj4iQs4V+I2ACy2V
	HsORt+N3fuwf5IZUOkkrtIgYA2udA7iFKWER3E+CTMTjp3AQv1q8xO5UBJCWGuPLgjOtr8
	IB5W6XbUQUxRRH5QnA3WWxdhmM83o3s=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fde68e420so25807985e9.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779135651; x=1779740451; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mE9J24ZIKiIJrzUDfxiR2ZliFW1zd6YjsXv6l2fJKwI=;
        b=NkxhwMoZTq4gs5RvJfWiwg9XSY9zovTWeYR/8DMVEbXZjscGvSJXPfeCP9Ons9w/zp
         +w29c8eH02jc2gchQNGbcIlFxfmomC4m0nx0QPE8bguRgfmbLs5VCRwhIVpeIIqELy+r
         9mWmYhDwMFP3JSeR5JUAMD+FT4Lw0kORXKMurLVrU1eQAcd5xchxewBU7nIFL6fq/I+U
         C4C2hH0WfWikWfZBXqc8OJdaQgD+176C5JUVnhU7NHp+9vYNv9fV/ypXAQ0XwEQgwD7y
         4xBnfnNVERfC6Wz5dCq0lRJvR/8DwAH12nDUQZs2jEqGj1/wsEGk42YJa2rRpdHoYkRU
         gC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779135651; x=1779740451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mE9J24ZIKiIJrzUDfxiR2ZliFW1zd6YjsXv6l2fJKwI=;
        b=BnQxJJTv9771OiQFWDAUc1nJ5E0wxv15O4zenzpQE9bwjoHQSxb6WPkbjIuXeUo+s1
         ISIT0LZ04NPJn9lRzsfrmmzuPHctQWIf5OBMzT1VqN6qIbxOEVSRWNLR6v228PwK2r/G
         klg4vyI9SrCb1iCg7+Qr21dmgcFXpiR0hIicHIsMsir48LjGGRGr4T2a6pWYFMIE9GeW
         4lpj4FJpxUeU98nw4RNs771WqVXyIlSLbIvPc1z8yKfZeWeVoVLlC2FrHhxXTPbuOEsV
         S1RJGYLhPwa96jiKeFdeNGhYPV5NvaemdQNJdPJsX9IbEFDHfA4WAQHSWW2Oz+VcVSTq
         zorA==
X-Forwarded-Encrypted: i=1; AFNElJ9xHV3ghrzvAea8H+Pl3q1oq7KCbAvbs6ufMS5s8M4/eR4muCMCnKoCjEmXAK6/vRdJqOV/qGIcQQ==@kvack.org
X-Gm-Message-State: AOJu0YyCLk1UwNKSFUbCDrTLzSrAs5raMsb/yRvf+Rh7TWzP3Pv20Yjs
	3G8kDG5Ptt+TP9gTCcP6KrfuA2FM/D92JNWPKFmZX9mMOg4bFnb5oV/4AfxdpCdGmc5QxZnBddi
	mjfRqNaU9Zu2/fw==
X-Received: from wmrc10.prod.google.com ([2002:a05:600c:aca:b0:485:3a2f:2f7e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2d82:b0:48a:53ea:140b with SMTP id 5b1f17b1804b1-48fe6898017mr153226065e9.28.1779135650990;
 Mon, 18 May 2026 13:20:50 -0700 (PDT)
Date: Mon, 18 May 2026 20:20:50 +0000
In-Reply-To: <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com> <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tun9sicgrcssyxosioyfhs8fks6bqn48
X-Rspamd-Queue-Id: CEF081C001C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779135652-591906
X-HE-Meta: U2FsdGVkX1+kB3Iv+THoIw3a0otftLO9jDndKNTwjj5fINrrVYOPi3xP6mlK+D6rww1kIxIIU3JP85lQmuIgygrU6Vip+mCCppZ7eMW/9PscTSsRVaXzKX0PV1fFDgIhpyNvROpenr9xuFbUeW+7EuB4sMhZsYgx42GhBNr4zkYNdZyiy1BvsAMMFarBrtKA2HutTcisXCqrI+pfN3QVBq8zjOTUDUL+GdFGdOHMyLMoQefmpD/8ZmUACTKhieHlTQ7eLIoMw6ll0ObC4VOHgLi3VwI8Bpm70z/OnD4LOk/8bHnQqCtKVLL/lGa6YsU/XWZ+VOnWsPKsrrLA5MWzxHJ9SMHzN1mjLLGyGJX4scVhSYiMjdxZ59xrWvZbQBzj40n+2IzWOAgmed7Bmukrss3qT63ZxwicTvZXWo7R/doAL+2RIKl9ZfVn6E1Sk+SijR/lF7ptFXxzpqBXAh9E+I1DJDlm8w8ghJVlAiAVMLpUIogwdIJxDy4+2/ocUsf6opIgVoHb/Gwg+eqbusKX08OddOjpISZRUSv6tcFEUXh9ycDu9Pppd+eG3QUK4Lo7vdXLXGIkEy4hNI4JKvE4iwHN7EFlIJjoZAKC0aIFB6jAiZtH9jUbQ7d8UAvWZ0TnGg6eFEHaEbMKSky5tD6pHzp4+KLwCAPT4+JBvNdmLOgd5rVYJtC2tN/JPYCPcfrcbndQxN+ZBmf4bC8y+HDGETmSWlBgjPA378fphPln3pnQk9USoGlBqAVml6tOD2ttNrG6wLY+Q0Tlp+jmG5m/tmgWiacn0TjtB3UfNn96uDyqy/g3+ZYsRp9KkgV6GeLm657ECdJcpU0otgNAkMNDT/W+PXmZ6Z9i30qMqQPiTS5h71SK9XXS1HtO7HeIEHkSHUvZ5RN7ed96Eu+FKIWqlfcngUkugEOMox8PnW+wKIS5idWPqgzRRf2epJ4S3xmOwZWuvnIjMf6GxRxleAE
 H2lBLVZN
 OWGEzBoEQBXj0L6HtRFYbtqVU0W1wXP6iN8ybz+BZF3FIEjeVHGf4ygZcd5bVe2s8laIb5Lla99uk/OE5XKgnzeQrK1tneZ4n7W7wlb6wWrLD+/56SaqVL3LQrDSyW0vcBfIyIJ9PVASw2kqY8CWhHEUkhr1gUnJbP/lHXD4b0j0Iz3GLdWFEv306CdWNngvvZRDpCfqe1Et3qnFO3j2HWvWMzl7iCeK7dCQbq6JRzHMhrkEYfyfGXe+ivEGz6Mg/VPTi61lvBuT7+sO2GB6Dx3PW8FBw5EYxjg2nmIPMIqegtRpnutZShVUGC4t0JLwlszHxZCjljIBmRD6mCeqOLDHl91hU2vNsLnFNAvVP+5HYQ2rM7BX6DqzoLTNdgFO3oF5HPZ0tua3LE4hQvU55N1gAx2BF6TmbLNoMQQVu1xSA2XHtrJRdyBalnMf5wvr26DuU4I+PUHOTl2Qqyg/XthEYDBER0024WxEpmuIQkQtjcFbBrlNkdZZrvQEZSQm0bEHwJfo97dIEXWtVoB2to8jARv+4er6GCTFC1kCucTNsfFXAEFMignmTBPiGrE8+spk4u+yBg7+QfPdRSUwzIJ7t2qiE9kJ/Uj3fjD4Eb/wyQCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 18, 2026 at 6:15 PM UTC, Andrew Morton wrote:
> On Wed, 13 May 2026 12:35:12 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>
>> In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
>> could potentially be merged as independent cleanups.
>> 
>> These are all independent of one another, if you think some are useful
>> cleanups and others are pointless churn, it should be fine to just pick
>> whatever subset you prefer.
>> 
>> No functional change intended.
>
> Thanks, Brendan.  I added this to mm.git's mm-new branch for testing,
> along with a note that [4/4] may be getting an update arising from
> Vlastimil's feedback.

Cool thanks, (also I got the "added to mm-new branch notification" and
realised why I missed it last time, broken mail filter).

The 4/4 update is already up, in reply to the thread.

