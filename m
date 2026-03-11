Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB521FD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E156B0088; Tue, 10 Mar 2026 23:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1418A6B0089; Tue, 10 Mar 2026 23:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E536B0092; Tue, 10 Mar 2026 23:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3CEA6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:13:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70AAF13B16C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:13:30 +0000 (UTC)
X-FDA: 84532311780.22.880F659
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 710A01C0014
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:13:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eOn+UnwK;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198808;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STn/LE7jAGdnYlf6ghHyWjMmORMVJ379U1/iWrgh98k=;
	b=ADu0GieFOqxuEvvMM49UnW1XMWqigoaqsFDrBjmTCrrCb6a9an1auP6LsDFleR3xnOvX4I
	gw/lqY/RqLCxG1VaLusyUvAlDGzgoTKLY2/F2lEewW++hAI5RTWvFAP9LmbtMC72l6LWsw
	o2O6lxTQG4ONn/NKKtLpfzr9GtYXIJs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eOn+UnwK;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198808; a=rsa-sha256;
	cv=none;
	b=jRQS+X6onTx7eVIaejKVakU5beTK+15r90rlJAk/z1IRmnyvdyAp1nXfhQXS0Rf+TDeOrZ
	dX0pOA0Kh/SHZLSiVoydo+RnH3051vMC86esSmxrndn2/E0xzxKK3GKlFWeDun2EU+nRNT
	3tCKhsozxmnHopMY1ubOoAWijauEDlU=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-662a1855af2so4173377a12.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773198807; x=1773803607; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STn/LE7jAGdnYlf6ghHyWjMmORMVJ379U1/iWrgh98k=;
        b=eOn+UnwKbTg5T/LTsBLXRf+R5gY8ZAuzLiwCFENNKEtOiIm/Mwf1ukL1vxP7RiFuLx
         azliCV/0yEJbuBXhIq9nZWPg3BOe8Cn+2LluWAsN+IivHz9PBbb6CVi/09X9tB8nAAp/
         2TqUwFaBuqnSdjAChagM3AkYZoF3BA9IYhLNjp+Iqk9N+KhahY0kn7xVcbOugqtgTyb7
         C4D0bpzC7ypn3zCpyq3TYNpq3X2r51HFKKEdcia+DaeFr/+4ek3+a64bGzXkKVdaAt1a
         WVoac1PgNmFCNDFGVXBha/kR1oaP7gMfAa5Owu7gJOJ4of1xcfl+4oWwslmYVVOxZ7lC
         EZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198807; x=1773803607;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=STn/LE7jAGdnYlf6ghHyWjMmORMVJ379U1/iWrgh98k=;
        b=IRUOwrwAVdZItFOGzhJfXlUYVfdqIHhYDgaUgACjSgxfj8dK4jUiXXCicN1VaC2PE8
         HM3uguJfXKMMnvlAr8MvHJJm9UhSxdjOJRrGcJKG2FBuXlIINLiRTA39yA412U1iZ38E
         A+73+G2L4jKjfqHXqrp51O67xJgvB+WgL30yoS9u/YM9yP3FBGQSuAAov9yGMko8DB5R
         tR8uJysRzeWuvbqjWU3L1k7PcuFj7UWyeJmnDmZ+b5JlphOSwrqTg71ER9iWVtJmashT
         tYGFTjeStwLAVseVIAlggoWF72EJ7SQOocBg1k18z7/WuV/DGDvSJIvl42TA2WBQlY2P
         F6pg==
X-Forwarded-Encrypted: i=1; AJvYcCXOlSRGj7d8n+mXMOQ/E2+vj+4JET3oUEv5o/OZDUnsiFytPQPY5ukvzzrAs+O5IcfhNHyTSD3CQw==@kvack.org
X-Gm-Message-State: AOJu0YxwIwR1obeGlWtKhrmkqo5je1lKi3Ru+PYffwW/S34wBg4IWl4h
	wVa72+ZWXaCO3tQlFsZT3mZQWPedBfys9HiMR8fG190Y04VUgFFjGYtY
X-Gm-Gg: ATEYQzz7nOHX/eR7GxBxQOe7cBFW3ShHln60fiTfxQVKZ+Dx94kcyJsxYuLElu4I+87
	6lrwuKYGJgx7YVl378/y9F8fZmtRnW1Bo0cFqVNi06xQXnZCFOWOJWBoaIY+sr46W9w6LUZLeMc
	ErKfQRP/DSITe3FnlWf6QW0qqp6EDzmzXhYEv1fLFzE/WkjwkNqiehJ6coCxLrkApqgdMRXZDXc
	QwY13oQ3NBZ+8KeGo9rXrwLtV/orVJmP+hJyCxek+dP8nOzTVxkKr+hSmYf+OBRh9sp9CjG4LHw
	01CnqO2oRWrFBDFQLr2cspKfonI8MKWBOobYKRS75Gw3cFpgAqOPvy3ybCYjRttrK/1qFUH6fMX
	jOQ7VAShkBlDcs/IiYV91akovv1edUuzPK/47OX/MZLBZo0nvF/7rd/z1pJ44VWztPuDWyA1vrP
	dPCuaFlT8JbfsazUTyCpUMgw==
X-Received: by 2002:a17:907:1b13:b0:b88:6542:86a0 with SMTP id a640c23a62f3a-b972e59297dmr39950766b.54.1773198806661;
        Tue, 10 Mar 2026 20:13:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972e1be45dsm22497166b.64.2026.03.10.20.13.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Mar 2026 20:13:26 -0700 (PDT)
Date: Wed, 11 Mar 2026 03:13:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
	kas@kernel.org, kernel-team@meta.com,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <20260311031325.7dfjig3w3ee5udqt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-3-686099175bf6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-thp_logs-v5-3-686099175bf6@debian.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 710A01C0014
X-Stat-Signature: bs33ma5acwqgnaoynwfa7ffrgfydpg3d
X-Rspam-User: 
X-HE-Tag: 1773198808-926926
X-HE-Meta: U2FsdGVkX183hO7lbTcP6Z/jGjFkv8WogCK0FrHuNzhAaROT62wzp+N2mTO7hF6KPRmj0J07gf8KIZCNyp2D3w9Hx9wj/ATXD6RM0q/oCz+U33sma3FGZqWINkto1+116qWhildQu0coukxFCW8m1SWHPEbJd3ntvcEycrxs3xKRhv+AJbzvyOKR4G0DzaC0lQi1X3CHqcPkE047fekVARKvg+YnyCNhkiYn51U5cvK46f2DVAuJ0w5C+VYf3C9nDjLY232CZXkFY3sHyxat5txZcWkJ6T3yDCCufYkBpmFbwxmK8Siv4ZoxWgEd75WTr5cK1WTr7USsee5oL9+L+IorVrNyBvRyvUDvqpH06meYmsi8lrIj3CzNm9dfNpWJCeUdPxsMuLmvtCBqNsiqSSFtHSyVaGpNoragTxfRUbBcfIXaHi2hpRSnMoA8YhDF6uLQdShpsXat857xXc4k6MOdo8v95VAXhwOOKErPZN3NsQDTiCevqUNAji+81Z4xoaHssVH5kmGNGpZGnYuZJc1ffuxjDso95GwOuZ3JsIvUqugH18MPyHRcIHZTOiHdzncX//CXrXpb+3m0zWV7DOBBLkE0/GtAgwh0/J9R9JLj9U5YiKpW5Cqw5d6jMAlY2a6+hP4Ec+nPssz5gkfjmakxTMdbmb3JQghvQD71FzfPUYh13PXASYXK6728UEGbiWFRcVxUCJ6RPBoYA4LKB1JctVh6+PBbOlJtF8/Eol7zbHX+smnbSZPCsoAtGxHO0rZhG5KZTVDYVlOEEwQlBXQTlrFTLQT6OJBQeARZri20VP62NO04mneqEJ2G1mvwheHAkWJA1OPpp8V0w89CtU4H9fywkPpuz40HVknIBcFx34WBuw9jzV03BIid1oIFPH/3guCCMh6/5XyW1ZgyK4/bSMSH1RF6LYNxEwQXqbgCvKS2qeRDNFuyXTxtCRsVTjDEk2Ykg7tqt59prQk
 GYS+73wX
 FqqierlVoZdjsNYGXFrG4WbECojz4m4TKrfRNckV4j5DciQnDk0RRIF8A02+QGY/yrIjc+GPry5SCTuKq3ZPcBsEFggLnuzBQ4YZ8k8Vv4Zg7Fk9B2KqdOWWZbSW1Xcryh9weFheCx3vz+sf2h8Cvq0R+CggLrKczv+at+5KE/AkrEde1KfVY4eM83FMWKwBdZKypjyc5f/RTeSagIoDX5+LTVlYNqXpBP159QQ7WjpfcVTNLsv8AoJbLocR/FEGGxBfVP9YNC0jfvz+qXPKz0fkZg3CMjRJptixi+w6YznG5uymDh5TEn/NtuUR0qKY8EtjL3M4G/hrVRsikpGpkjF+0B/Qxmi4Ve1CWl/Rjduw/OMcuHXlXvGsSqOQX7xchdvCE/FV65p4dzBXTD+i8wHh076r8NvFHpmlo0ltJgc2xAW8j1pXf7zw0keeAnxExjmXiRBydLLlDbdiI6gGeEsjMvsN7EQBRG0tZhEgm1SKj1FfaHsP0LTX6spIYSzCRT9tKvsZ5sVLJsl9iSKJtQNAdYtas380lfYgUQZWm/MardytT4BusPKPQ+tBW82SDK2HH0DKu88BuLkkJ49pRAPnZf/LWBzqkG6R27UjlFN1jx39eeVjYDT/7mw9g4FsbI9R4R9FRWJAPyck7l0JtiVVviBrr/DBhr4o3/5riq62jRhkNx7t1VsWk5Zz1eofgzCgvFOaFVPH628fvW1WZEhHzPnKmKR5J2Fq4HzpavX5nv4BpPdOV+UET3L7JZSE5k1NMb5ABQ5G1xtHm8E1r6d3N7/sJcKs3d8f2f3R8VMJ1Aus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 10:57:09AM -0700, Breno Leitao wrote:
>Refactor enabled_store() to use a new change_enabled() helper.
>Introduce a separate enum global_enabled_mode and
>global_enabled_mode_strings[], mirroring the anon_enabled_mode
>pattern from the previous commit.
>
>A separate enum is necessary because the global THP setting does
>not support "inherit", only "always", "madvise", and "never".
>Reusing anon_enabled_mode would leave a NULL gap in the string
>array, causing sysfs_match_string() to stop early and fail to
>match entries after the gap.
>
>The helper uses the same loop pattern as set_anon_enabled_mode(),
>iterating over an array of flag bit positions and using
>__test_and_set_bit()/__test_and_clear_bit() to track whether the state
>actually changed.
>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

