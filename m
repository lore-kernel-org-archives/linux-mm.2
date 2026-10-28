Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD59606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjMR2woc
Received: by kanga.kvack.org (Postfix)
	id D6ADC6B05B4; Wed, 28 Oct 2026 16:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B396B05B5; Wed, 28 Oct 2026 16:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ADF6B05B6; Wed, 28 Oct 2026 16:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9A46B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3072A14028D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:57 +0000 (UTC)
X-FDA: 85373191554.09.FC8E290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EA834000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjMR2woc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QAe5SGrIPwZ0tTzn6oh4wSWtXWrJvkc6TieHYKerj8=;
	b=B+b6HcPTaudcDbxqgWGcZ9UOWmwS4j6NWcp/PfuD3uPWiByLsB5mbGDuzJxH4MnPasbJce
	53EYpov02Gipd6neM0oHa+opgLunsJlEP76pDP3oSuDdA5kok9Kp0KhyVkA+pdu9gq1lV8
	rH+zzwRyHTgz9yTw5W3lo9Y6pbzRsUo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjMR2woc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219755;
	b=Fsa4acn+hDGMX3P3CrppmrGp5yXqA0nLTymzFakAJ+eOSjGmLX9g4K/VE0xCFGPxPPgcFy
	HUl0bQVoAKoH5YFt8Fi2eKu3ElcXvhiGYH3V9tF/58gyqsf3egQi9OMZrqPZhzYhSUV/zX
	RxIIayFN40xPhmYNO2ZuKyM5kcvhQ7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00BF1601FE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9CC1F031E1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793219754;
	bh=4QAe5SGrIPwZ0tTzn6oh4wSWtXWrJvkc6TieHYKerj8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OjMR2wocoM7Ox2qkxXBhUairznGYjwxxr+hvzFGtTgF6uMo9XQ1Cp0IajDgW9HZP3
	 0iVS7OpQC+B9dgU07dSzT7xN348tTAemsVTWhywiJN7fBeX6NliTGmrcukeQlf5td+
	 ObdnFDlHTjb2Ht4zhXAO9R12oYpBOy0QPgLEVI4bY6n9+Plys4IkAAH57manEN+vY5
	 CknM+ZKT4Pxf+cMu5QpPHFFFhi99hl9xoS3ALRGpcMAqOho/PtYRZyjfJy0Kmols1h
	 BKzasg01PyuL5ExBDmP4Mo7v+DQhCfgbMGPPRCGPZZOfoKlTlk7tGuq+AckrLCiU/C
	 FQMhpBEExti4Q==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-917bab38b14so16283236d6.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:35:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwQq3fjPvDOgBByNwmMFuF+zVM1WrjrQ+ccAScJ6s2xOw8Syet4Z10Om+VSxnYDycqCE5TBlttI3A==@kvack.org
X-Gm-Message-State: AFq9FYKz9i2Z1rfITH2rX7/y4EaV0s9tBDyIhm/A82johkK1F7OVXK2t
	acw75dq2d4MxK3Ali1Afp0BGX638SabhLpdnGagPEUW8ad7HbRiLTBDz3pyOPWVygkOqB9bzGxa
	Krzin8bD/HDiupc6mpueVWuTSx/SHz/Y=
X-Received: by 2002:a05:620a:2728:b0:93a:1048:7d2f with SMTP id
 af79cd13be357-94408cd0363mr536255285a.41.1793219754031; Wed, 28 Oct 2026
 13:35:54 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com> <20261028010611.3929937-2-tjmercier@google.com>
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 04:35:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xGy4O0GdU1xwVURjTZ+upbZYGFsKwf-ZjKKkntOiwtHg@mail.gmail.com>
X-Gm-Features: AclHuK-kz9wxt-69rhz-Vpf7nKwcRzuuxuV15spsnkGsOFzx8iPMuvTrFEMb7zA
Message-ID: <CAGsJ_4xGy4O0GdU1xwVURjTZ+upbZYGFsKwf-ZjKKkntOiwtHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5EA834000C
X-Stat-Signature: ycsbyjui93arkyct4ukgt4jzokzu4kqg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793219755-28184
X-HE-Meta: U2FsdGVkX1+CA0OGlXhT6ICIx9yVCdncOef4h4g/k8HRc6hF5CtG9KL0TKGftns71w4bCAlLAhvPLuj43BuKdhdQ26lPS95TNCfDN33mBnIWPjX7HrBI0CSUhC4Ln6FrBsjbvGwfLzEA/jYzuNA6TU1MX0/ZPQYLycK1gg5M3i32bE3zlYOsZvSx9MEJEtZHQ7MToFuvrv7oD2Isy/rXbfGeacwKbVh1/nDev9CVYXUgyoQgTqhM0xUeOPzViGEXv4Yux/wG+mxkk4Da3RYC+H8fQ/0+qL1bZR6PJTLJPfkphmi9dQ2bHveQAwoACMinoTJCcy8t4yLYC2yzu9m4mjPA2i1iXoGGH16LhbPf2apQEQ2DobP5yC/ue/LbZA2iNtINo/+LfbO5TNEmuhDmniCm6641J5q0XPDSlzoVqV+7z5Vi1+E/xt/w/ZIixRLP6HsgAVVzl1UjOrh83/ZI0DY+9EvRAd7AfaMUf+AfzSZQoUNq7ppNmOQ8f30w4esE8XYrKpHHQMx9yrD6bQRm85b0JZ6sNDh6cCD+43HHo+lp9jBDm2L0up0egksCccyLU3TCLYKPnTq+xCOP2xjamdtHf05MS4jRNEed+zmedc2/GhwNgnXWOTukD8Go2Qs9xs4i3Vubu8yyTJV+ELHz7w8I6l9s7GfEqX9Qn9KqNJNSP1ki2jxmt26yobQsYPOEPC3IF8cyC0oM76uxQjn/LI5N9JOF28ZG2L/apVkO/sPdaZ+swGeIr58BBEJVuuTTuRKkmkepr6w+j3PFkYXu89XVCdx+6QtvY1DBtje2xhC8x2vbderKLNlA1yQ5yCB6lI63DKWFYwhKOQ7e4p2U5Z5wwKmmQCRkKlepfVK4x+pkqKx3eVFlJrVD9F/RRcbDqT1P9GBxz3sIVm4LolU6Dn0PiVm5l0AfJB/7xH+tEMldnDDBjOo3tPXjCo1iW0wwfs7+GzynM+TA5+J1jYi
 K7gO0wg7
 hihsC2aqig8mh2czSuNW+P6kvdOksFlTxen5Jd1funjhrd4DSHYmauQUlPa0omh19oiUQl/sqXTmYRZJ5ixeZ3MlXz2gNMLu9JT51YkSAo1bQKZUvTpHfTtzXDM15u4lr7gAnBmN44Ra+v0lFUmgjWrjTLanVEAtMf7E5I8VXpYCAQFndrsIyh4U+mvYoqGINaRETqE5dahPHjxMPWzMLua37F8V6P81rABVG99gXb4EPltYpbc/HP2JW6v5JlNulUxtwWPUYyj1eFCDdREMMaABqNl6QtF4ngzwYRjYm47dMlEyEN8BByIMtnkPNeiQsr8dY83ZiZf9J4ihej+abF8duYk48gId/ClkPZBJjIPckfEwcMDhH+9w6OcuGQE7k+1eXEex08fbrJscTKQD2agXfjTLZxlM45X5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 9:06=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
>
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
>
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
>
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

