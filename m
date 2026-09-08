Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB12C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7169D6B008A; Tue,  8 Sep 2026 14:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C75D6B008C; Tue,  8 Sep 2026 14:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F446B0092; Tue,  8 Sep 2026 14:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E8F6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:39:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A131680711
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:39:54 +0000 (UTC)
X-FDA: 85191459108.20.1965324
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id A63B8180003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:39:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuO2WAI2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuO2WAI2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788892792;
	b=u0yg6UKaESrQajIkeSFwcUfwrqR5KHy7cETWPAk5cCE1/ST/SSO98zRAHtmY9yxEOOqMVM
	PFpKRlhXvzkQcvg9uYSqh/a36EV+4SFfMs9epzGZvhN/X5OHPC2LPkIF2mLTVLTyw2wFbc
	o7HS45AUdZOJgWEJFW2ARrBvm2Y82gw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788892792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRHHPtqnAHNoNBtGQy93BNsOG6GDWejrubjBMOtK5uk=;
	b=KwRUgu3BgyU15I8JinlWGj0EFaDBKd+zk+gTaE+mHt3+Is7DMTiVeTm6d7s4xLafY176ER
	sZrlnRCTU9SaUGq9NE52Tk5IeEiWmPmtNZ/7BglkRMXp/qcGHrECSE+FYIWKBetAb17do6
	G5lsGyPcFa5BnUhloYiNCO5C5Dmjxx0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49d0d2d37ceso16636095e9.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788892791; cv=none;
        d=google.com; s=arc-20260327;
        b=juLHzeP933Q9rhxsgCDQ7H1HUv8MVOLm05fTZzaCOf+Fms5Uyj4RCSZ4EIFfOU7+l4
         nznrMewKwwFK9mj+zBiJYZVv7YEAhG+xp6ljvJTMbDvfsrBhL0McXBiNHgOGQxyJJ5Ho
         56txJ7wbyX1Fmy0bLwRHY/ibD8xLKDqDEb8aEtCeMc77J8/EgQkikMB16roPSxRuXDeH
         4bcljWFrsv4g9387ouAFrcY/2bNHu8cnKGklEiK2oZ6mQdl1bgc92JEEW5MuGnvfDYH+
         Cwhgr+NUaf+QpAByqdf+o8yxN7JZTj4oyXuCz37vXOzd/G0S8XfAWD1MKaqfzaKFFlNP
         Jtzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TRHHPtqnAHNoNBtGQy93BNsOG6GDWejrubjBMOtK5uk=;
        fh=y8jW7EVjw8yVDdyGe/Qp90qU6zCHReBf74zzUkEZriQ=;
        b=Wx0d8nRhn/vFN6ms2FpqOMvyrvmqKY+5bfqg4eLbC2erQ9tYMTrE6uQRa56T3aKwMk
         hiqk0yi9Pfbt0qc0vxETnShRYKxRohXzZHTqlt/ZiH8kLRMlYGWhIVMRN9ISVTObknEN
         NPWZqVKCXLw2bbE58+zqgzdFbU3V71C2SwS2GvaQuSoKmj9i/E7gAo4PEjha6lzr7WnL
         rbasa7yoljAqbp9/HJ5g4IZQmZbmBlSx+5KgIL1w1hmGSGtblrl1YSsm+wWk0HP5oKNP
         W/15u7K/qtyFewK8IxFeIn8a0hU+ewjh2B4c0ATkCwsnkhAbmzIb7a7j96Opcu0Gem+F
         jFlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788892791; x=1789497591; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TRHHPtqnAHNoNBtGQy93BNsOG6GDWejrubjBMOtK5uk=;
        b=nuO2WAI2oE/aFTvd9bgL/rDoWLI3Zx9WiHU8a1DnjWiFZAQNVw1UMA0p6OYQdhgs5X
         0OOGsGqkZVG3Q9vqWHEkZE2YGXbS5PKqY+HwD60Y/U/fyNLmCKOeJE5/tIoDh8dlkEe1
         Md6jxj9u1K94luJ91wkEAdAuwKwymCpxMKaJrQfaFs+CW2N7gNuo1Dq06iKCLrTiZsWy
         9ZshP24WvXQ7V6Hs1f6IOsEsCZFTV/11+Tpgs9gRsZ8QkYpbfJXvzHs+/P9PUPc88qgS
         xFuzz9km93ySkmAno0TqjiDmNA5N+kUvT0hhiANGO4o4nUC55qohVpHtR5bG3a6Y69e3
         wrng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788892791; x=1789497591;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRHHPtqnAHNoNBtGQy93BNsOG6GDWejrubjBMOtK5uk=;
        b=OJQ7rGeMZ8F05rBl1xnvvOjql7/OjmYZQ/zSer5vmkK8x1bP2bDaLLLOxgSa/eueMB
         otey4AoyAhFwEnGvE8GM3IPrGAQViK9iN6ROr7+0YmlJHCqISijo8SR2l++5shMgMYet
         FXX1/llK62qf9fKmI581RZD/X0l2loNmmBLSKY9oX23sP+pV2KJKB3IcvkkRKVEO7wSJ
         yx8Ngo4xe4YhiUEuMjL1OMfQZP7dn9VeO79S25N286NNrt9gJXNjUIFbUZUhw3UQXvXZ
         Y32ueD6RJMZ0PZ/IPCaC5JmPcBFGh1MXb+jGKd0YDA2Ifoc6r5uHGHXJmBmAfJeHSqfX
         V8Aw==
X-Forwarded-Encrypted: i=1; AKwUvBw8+pE+heK7R+4KYVqL9HKGLVoQN61myNCGQTz+yiN7mja2Ec7n8hQ100m9FV3namEBrwY7SRt2Iw==@kvack.org
X-Gm-Message-State: AFuF++lKdk9Phs/2NuO81qAqCCnbn99vzRWJkuvFdA5k9S0nc8a8gi/0
	EJMmqbT8b6zChF3joe7jeFXuWGM6o+3D9x6sfjqBc1abn+Oz7EIQI8d0dBgpC+GPY13uD6Xk/bB
	OYioRr1j0xutNZ41F2QGyqStcRHI/hJ0=
X-Gm-Gg: AYBFou0HHEVyR29IAydMowI/hRJkEBE3TQXsj8pV6uJpE1vCNdwzAPWlEaJV9M+jBRL
	tc6+1/B63ZLWqRBxf0Vyr7w+8l2bGY1CaoPGw5k+9AsLfD3OBetrgJzl0CxBUrVi3xAUfmsy8qP
	flJTw4ylsHBm9JJ9xiIqPHo7Wo3yKay5eGIA18PNjiYxc7ZNqWJZk/HwkegAU4aCE/V181WNdgw
	qZoZ7aQEdZunGj1Sk02+azK6busxG0XsOtZ+vXpTC3R3BeIpjnKVopK0lle+h/Ym8GnbCdxBIkd
	3x7qJtPdOifDZfb/5nViQY1b1NjQHbH5oFB/iYB3clnIsXa+XKJTQ072GUyIcrLNOxhjhqPl27R
	2
X-Received: by 2002:a05:600c:4f89:b0:49c:e1df:79a4 with SMTP id
 5b1f17b1804b1-49cf822c827mr275918375e9.5.1788892790894; Tue, 08 Sep 2026
 11:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260825135209.3135169-1-alex@ghiti.fr> <20260825135209.3135169-3-alex@ghiti.fr>
In-Reply-To: <20260825135209.3135169-3-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 11:39:39 -0700
X-Gm-Features: AcwNN1UgwciD1I-qE2yD_ZK2P3jH-A8WPIpVEy3cs7LbzeEfivAviywv0_QerXY
Message-ID: <CAKEwX=NUFMjHHbeeRnUm0Ex9YQaesYTM-22WMGRJMXSKTkc6uw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A63B8180003
X-Stat-Signature: j3zyo4ihm49x9jjomi4regftrzog84g6
X-Rspamd-Server: rspam01
X-HE-Tag: 1788892792-410875
X-HE-Meta: U2FsdGVkX1+f4jqqVFwQRM8lrrGmykPhs5ihxOf5o3jfRTExCE5dJrNUVMyrF1FlkWgBPPmSWfg3BXHH8e0XmPB8KsWJTZKAPsmT/SF4Gue60jNoW1D/CN/KWNPN7+lhOQgi/gPnakS5Hpnr9PDjIfvu3Cs8ZkHCe2vZOmqP4FJNJNwzP/aWLDfFP0yOlch8PWmVogvdga8NEVd9Jg7qSz3yWefTEeRddc6Jpqf8bXvAhVrVQ8AScrgp0fmwDCyMXo9GM2t0QOJrLfi9RrRSrebFn/6e0AqJuVeaJ/xWOtB8Or1RCHMZrH58Hcvc+hp+ZK9IihbOclrMdPX1ks6ZeHHYki4pbdlKTayxI9MxyKtG6idwxLgLyqcgy3uloXqhmySK5yS6Iuq0oQ1iORd/QLUCQDVY7a8Nje1EmPrsYFeJmZ1UIx4/V3YS0i9yYAyZT1u23OlNfws65E9dLhgxvGZ4ZtgJkIC84cpZSlXTOCC6St1VVKEUtmxpPaa0PTTuHvRNqLfAwaE3St2BE+g/uUVaa04x1Jrhj8piJWQNog7vnuiwKIYrWh+B//d/XtYEmkeVV+M2J5EhE9ahudOhHM65yFSyiD/GXyjAaMExBKIaarTIN8VE9JBGcnknOZYNn4EqdxP0iG3I4jcEb0nYQhQxn6LBD5OwKelxWuq3yxhOksgwXdoKBiIU6zbBgfKTOBelk+0dQQafYUTzhj+GrFTk/LmJp3HWL6bSpK6KogwBh/ZSw82+fS76dt1zu2iD0voVLrDMpxoJelMdOs0UvszWRSQ7hornlbvt5VQFNPS7NP8KIBGE8JJGhehk8l8QvzlROf15qWymB2TUN/dDw29YpXaqHVYmK8y5pgF/z7NlI1P9N31lmt8N7SYP4AR40Ru8854nZAJqYyASJWdzAXHMSZQ+nR+xkHYOcRXSrogzcR1NBHjaDmDRWKqN/+XFqy6hUe8HCOdEeMFDUMz
 /FBV4HnR
 37Am//P2O35TjFb/Z6BIKA18x47LrBm1pduQlxz49nlmyDi3r/j0dJkEtcHR7QpWao958fuJDa2Ct786J3N/X7TttGR3myYyhwZTvAT/fbYmjcDFmQbxf5WJsUu/cfQCDFx1Nlv1qvaDcGRe50wDHwBlAiFJHkGqzDcCLRrVqNjWJ6BJhb0JBoyHxRIfdmE62nPMXiqPFNjf6Ul2b/NsUdtzk9aQuG/ww3CwB3885BvVEn8pVib7/KOBMhei69pQYF2T45XCUx5xrtyBYOmjQeHVr5Cz++6fqBIU9rlFEIwt21NoFaqrHGG7HNdOz5roQqYAssiD3nQV4jEhLXDL68RKLTh3lL5DK9UblUkxzr90imyFZCNEPqVgwsccEZs7BbWwtqXvrY2oj4/8K/RYbQ9+OkW7pcxTtGMfjiMWyMsIi0oQDyRc90zJsPnyn6YyGpKytv8ivlQ/+jeEeAvm8G7O0Vtx2Hrtv9qWrRAlB5FZ0A2Xfk2g+76r+cDavcwWYvxeS9jfK2w6MMDjPGXY/PYROpB0fcbuXnwJ6VvPoKEwMT6mEke0jUC3rImc3EnUS22D9AsQNmWT+f2Q4ZLqqtkEi+JZh4Mfz21r/Yqf1K3M/zaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 6:54=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> A PG_dropbehind folio is dropped from its cache once writeback completes
> rather than left for reclaim to find later; this is implemented for file
> folios in folio_end_dropbehind(). Extend it to swap cache folios.
>
> The drop takes the folio and swap cluster locks and may sleep, so it
> cannot run in interrupt context. Set BIO_COMPLETE_IN_TASK on the write,
> as the file dropbehind paths do, and drop the folio directly from
> folio_end_writeback().

This BIO_COMPLETE_IN_TASK thing is really nice! I'm glad we have a
proper infra now and no longer have to roll our own solutions :)

>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Mostly LGTM FWIW. Just one query below:

[...]

> +        * Gate remove_mapping_reclaim() on folio_test_swapcache(): a rac=
ing
> +        * swapin may have freed the swap slot (folio_free_swap()) and dr=
opped the
> +        * folio from the cache, and it must not run on a non-swapcache f=
olio (it
> +        * would trip __remove_mapping()'s mapping =3D=3D folio_mapping()=
 check).
> +        */
> +       if (!folio_test_swapcache(folio) || folio_test_writeback(folio) |=
|
> +           !remove_mapping_reclaim(swap_address_space(folio->swap), foli=
o, memcg)) {

remove_mapping_reclaim() and the likes seem a bit confusing to me, but
I don't have a good suggestions for the naming...

(also I'm hoping we're fixing the weird shadows behavior of zswap
writeback soon :))

Anyway:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

