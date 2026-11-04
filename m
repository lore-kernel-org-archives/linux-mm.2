Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65864606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=ZJQ2onOM
Received: by kanga.kvack.org (Postfix)
	id 847B06B05B3; Wed,  4 Nov 2026 00:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7BE6B05B4; Wed,  4 Nov 2026 00:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF306B05B5; Wed,  4 Nov 2026 00:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B57D6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:29:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58B501C354F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:29:36 +0000 (UTC)
X-FDA: 85396309152.11.56A3471
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31F9A180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:29:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZJQ2onOM;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793770174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZhQHFa3fDIYYUFeduNwTqrhejieaNOw9vQ/LVe4bqc=;
	b=bf/w65VgUm86DO4O5wKyTdPQ1Xb/o4R8fZ+rufjQkvrsaL7UIrJR8Q+dMcA7MfvNbqCj/7
	0TKH91yjDy5PM4M1e4vU7CY3d8y/aVvE5ZimKXS/7u2/YEDE4wCf5ZToli3Ufyzj0DtBQa
	R/1TNvyO6fPgr1VHL0petlnWfYO96gI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793770174;
	b=q681PjJAfWZ/WgGEaQUXedQcdNB3Y33FzLnpy4YbGFbeN9iK1OzNRbteUm9dTkX+mkvun6
	TJSi7Cjds2x0UUPdheecCGBt4mM6TJX21YbSafT2tOIBEfNdLI/d1SV/GxWOZwtHNoI6Nl
	zlnmON4NA73DRqTv+5dKySnC4PwgJ1E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZJQ2onOM;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4ceaee6770so43666466b.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 21:29:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793770173; cv=none;
        d=google.com; s=arc-20260327;
        b=W8rOD+AFSsXg33i0RUQVy1oJWiv8gjesMziEfWQ3tiqPVaPj728hFS0eZPXTmEpDrH
         bmIPOaxtDVAPTsVm53ffc4rlCMVjeRwWHT4DGlce0vSFfdP0KxWaIG45g+CeI3SMbCj4
         yK5XJQxGBItXtQ+6Qeq7WAr63BNdH/BvuejYgGb6bdsTop1Kg0abB7cGYIl7EERmEnWp
         GipHfqYZ3v8l1UrFKXNBWZrdsDrlEJD0lLoC0SoFuW8PDbArhjVMQu3TLgBY0cYVFoR6
         eyXSS56HtbWNqSt7UAFsesxHCpR1/ZyLBrhROmzQEPHyqzoiShvZr1qQCUp+Riu0CyVi
         KXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cZhQHFa3fDIYYUFeduNwTqrhejieaNOw9vQ/LVe4bqc=;
        fh=obWYHMAeTjaFjjt4Co0/xyzdnzwGy71ADUadhl0Rh3w=;
        b=V5o9M5ahUblzCmlsW8GAmKPVAn7yStAMe8k1pR5sOat0HNE6znCyHXVHYs7g7M78La
         I4FV/Kx2JZh/XwYOd5RhS6XskFMqP7POvkj1IvVaZYFfCPllzcfPC4Ur6KBdPc1a9Juz
         lkYh6RTvSRnnLkj3m155s7yU7HEnKGwcf0EguOga2kDCziY5pC99dUi8INSdCF2IrSQQ
         A15oC1FkJwSJrOPuKUPHH5KENf/HNhSTneeFRSLzOLzi8gjB83vZiqXkXUUfBbuUbFxO
         D7PqtGZoGB1jO42WUKrgAz6JKjeUL1Be0sJsp+ncvYxOJFEV2G+dW5T5iwSW71IhGDnN
         MFWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793770173; x=1794374973; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cZhQHFa3fDIYYUFeduNwTqrhejieaNOw9vQ/LVe4bqc=;
        b=ZJQ2onOMNiVmrVF4sVgRQ+ZnXPbUA+dRcRZ+bm5rfsBbaF7rQ+/dhqHzMoggjNyRQT
         fizJE7XIExF1Y/N+ZL6E0h0fseM9GUZtQKfKi2H4At7sDKtEtwd6gYHiyVpffTP+WsbN
         rtO8Ch2IZdx32skRSwp+RENK1kKHtDkA2iwUx7cu0O1Kyjd/pgnEtr5azDByRfaDaVsQ
         HAYEL+5kX1zLEmZrwjtrKYXOGd7eWatcA35O2z+viArQuqLT8kzbykad6Xw+lWevUQgI
         UoXGlWNraW+sXjna6nHVjZV1hh3N6eDlwhog/L1Y12BU2FgfVTseQxqDV6NHfqDhEWEG
         62Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793770173; x=1794374973;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cZhQHFa3fDIYYUFeduNwTqrhejieaNOw9vQ/LVe4bqc=;
        b=lhUlh6QczlxJBF1VuTClDMCMggOQqF0w9LUPWaLBhviDMbAaIYNRJblhoCgsKWh/QJ
         d9kGXBhpWP47Bfc5QbmpJorbFZPuAg8C3Ze+ZBf7iJlBle/eqJL46Go+IcVXQmBpQd2K
         ggOgqeYOM6yuYocm/NSDP1CReG8lbubOzZNIGxaTgujQFXWq4j9+U8iYTvBTZaQo5Iev
         txcwJSuvTNcWB4jhWSVIt/XKEINwDLw9GlRjpJPeij5Z81vOrEzSdQmMNbh3WfDLgSpc
         /o5H6zQqOES4mi1w6LunJGZk219wayioUNB/ag2CnD19ObkpMnBIHTIbzf7K6L2yZeTH
         FrWg==
X-Forwarded-Encrypted: i=1; AKwUvBwk1c5CpYI8SjnqaMpD+uDOq6BhX+VwFeUHSIDDQCb2GZhVH9wCzzmhKZJI3QoRzQ0PoJLu8Y1GjA==@kvack.org
X-Gm-Message-State: APuU4Z8vQOXTJK48gYRPmDI82KmXty6EwOEDtpnxkRFcczYE/IS8SEDh
	dPq6whKJKf1V3nwJvU9kI8+G8/mu9cKo1d3XOzB/goXDxPUGNeGTaD1zD+g8EEpa/YxRFgVKuYV
	z0oBh09c867YkhGk5ebUmjLhWN793rfsUUIeCnYPJ1g==
X-Gm-Gg: AYBFou0sDymJgDM51hjnkHG/xMFdejuvzjwjvGn2mHNeP5d8HuwSgEJlloPmuQ/P6M+
	NYCro2h/Ha/t7CmFFJAntHBPTCF2qTUE8VQLHul8xbIz7AiDGhaL3P+AVP9JLn0/TmVHZVj/oF2
	eP2bvRCZB0nitleVSm32bJSyMUmIy7LDgZVP+Ix8yg3AHFh96Tbb4OSHHd6ADBakAf6P2uuN5me
	ZTdgUDzISHTJ1svlQYFY/Q82c50xqkg9rboYaCMbpSnPeZkvmmv0/qrhPLq4ZyPzWtcq/CzdNay
	2ZJTs7foYG7OcweIBxy/7ZzKQ1QpmJI+RNd+wZBTFWyOWwe2qcPYbVVf7yzfiMiVrgL2P+k3oKC
	3kw4CU5c2y/7ma3tSN8HjmfAR0CWO/xNovEoHQFqerrarfaoBegWmu+DYOUz6sGnd2g==
X-Received: by 2002:a17:906:dc95:b0:c46:2987:2169 with SMTP id
 a640c23a62f3a-c4ca7a4f156mr1344359266b.24.1793770172638; Tue, 03 Nov 2026
 21:29:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-3-max.kellermann@ionos.com> <CAGsJ_4wYYiHvDj4Bqbp_hg1H9-WsZvEBJ9h5eNdX-Kuib_f3DQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wYYiHvDj4Bqbp_hg1H9-WsZvEBJ9h5eNdX-Kuib_f3DQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 4 Nov 2026 06:29:21 +0100
X-Gm-Features: AclHuK-8AA5Oj5_0e3X9V5IdkisojDeCpVwYIMpIa2E1dyyt14UIk9YqekGGG90
Message-ID: <CAKPOu+-BArn2FDfOWthdJHHbkeEBVAZ9z29XRT88tiXYO9rmHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6t5ei18jdrdtnqn6esni69hbj8ztmwd8
X-Rspamd-Queue-Id: 31F9A180002
X-Rspam-User: 
X-HE-Tag: 1793770174-880984
X-HE-Meta: U2FsdGVkX1/nLWpjIeXM2/K2oUbpgLwEoxueGJNZWAAi3COvB8KfLfqzbKuTS+LQkPRq+qExs2qtHXvg+h7YTp8JuImOBzy/bbWrHvaLxdgWBuFIOGCP+jskwufq0JrCGyTcyY8/50S6B6s41YfONEh3+RsfQ+8qgv1/f+Y+tWLtzAWpDQ4//Lj4ZMb5OS9bLerBCit8rjusnVAdPnAOsi8F3+7ClxQ7/nJP1VG2scCWTqML37H84bjhJRfPQJbjyPxVWI464lAABSusTEqy1bTjvK6FQUgDkdqlvcLkhCYIjW6ur8KpXAHWjAp6YyJyBeeKc2zumdO9+d9Pn28OnP/q3JLaTQoh7iMaxMjR83z0gXISIOZ3XIVDSh+ExFZ2mxPB11KRccXWqbb5Fg5NwPT7uHWRRkc5DsrqzXERg1080VM3uv+AmzEO9dwYnrLuDfmUuEhHlPZpbkT/wsRjRKyynI0wI+6K1O0OfjublklqVK4kWumkkY9d5W19trDqHbGDcp4T1bLishpFeuAofYcUlHitlm1r4EVGJ4EUhPBKl80ACv/ksHvF9k96C8Q6UwgUZEyfHRHj0K5qKEcQNUEgOifnR+ALdExzbPk5GBM0pxHQ1nERCEMuMVlzuTvWRxA0UuBTc1Aic4CF2F88a1rUaThnJdbn8eVPm+RTOo+rX4GLPN/G+fnkR/Jky8RSHqxqtQEpXItQ1cBFY9vVt44k12vh+NC4ph/XDyAt6829ld9ipQKq8XQZ4p9+mJOJDXSDQZREd67oYT7iJSkjLI1Qv8o58VwDxR4Yq0AN8JyPLPNWpJyJCvycM009e+LClBiQQZvgMdIObcC++Zlezavby1BnezkR5Eilo1CzTGedA/gC4noFmuNg03c8bbB4sqg7HEClBWPfepXg+6H/Bbf3a/isBZCT+HrQ8EX12SsxRvrocGq8MPHtx5mh6R2Vy1VxYO0OHQGcLo86Iju
 e6q4y3Hl
 SZkNBHHE7qRKgGjJ5zG6apNAGKAi4j4DPy99LcU6avDWFgr9mg1LbLaQYy6H35hRuUIGi/ykOjXmH9Pk3moht0oInfMpHBTfRXwZveNzymA3XdOzusShIegMQGBUWqyZi/NXNW4MWwRstJznxuZ+1LUFWmIWfwiV7f4iKW3qmac2n5AtKH3TI4okB+5A0RXGG83XTu0VJ6IdkV+dTGEIXXvqODPAeDItpi8FPPVhzoV2SsZjLkskLXEdr395LqsueR+xJuLrgzdVrsNDyta/5XvE2W4pIHXhGt1GgZ22F6HZvIJ/Qr+t3Uakizfv95V87S9+dkmeLdrpCBtkEBxiYaqpyU3RxOxnU4DhSb0b3lPqNSJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 4:22=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
> Also, MEMCG_LRU_OLD has been removed as I replied to you in v1[2]

Oh, I rebased on linus/master and not mm-text.  I saw MEMCG_LRU_HEAD
was removed there which caused a rebase conflict, and thought your
mention of removing MEMCG_LRU_OLD was a mixup on your side, but it was
really me.  I'll post v3 (as soon as I have figured out the rest of
your reviews).

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

