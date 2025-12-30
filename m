Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E315AE95A6C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 11:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3FF06B0005; Tue, 30 Dec 2025 06:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED756B0089; Tue, 30 Dec 2025 06:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC506B008A; Tue, 30 Dec 2025 06:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE556B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:37:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 128275FEE5
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:37:56 +0000 (UTC)
X-FDA: 84275938152.15.A0DA3EB
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BB1CC0007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:37:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EXQ82BhS;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767094674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Jq/YWcpAHyrHKvdGDEz/0WDZdNHmowQop97a+xcOpM=;
	b=GEcoAsfXV/MUDZ6nZk/2Fzp3XyaNk6X62uVawftt0UmelrqMjMGVJIFT1NghIhqForM4cA
	FjMjPQbJFdq3bzFAIHmUuQwKGw/xBHPUfMssmUIHQwRb3HtEyB0vaEfruAsQQICiZRfww0
	5re9f8KbtfwBfgJcFHXcMOgGZQ43iX8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EXQ82BhS;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767094674; a=rsa-sha256;
	cv=none;
	b=ps6QEIwVvOJwIyrp7SHKTKr75NbgcTtaMSlgNqipw6715NoKFJXnkbj+18VflynsGG+1NK
	fKA9mblYz19ld2Mlfb4C2oXd0VLaRmO+0w4PtulF4RFONDYtFp+25381/qaQ7+hUla3P5E
	5NnXgzFB31iDA+vso0UfbSceydTn1tg=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47a95efd2ceso89497345e9.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767094672; x=1767699472; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Jq/YWcpAHyrHKvdGDEz/0WDZdNHmowQop97a+xcOpM=;
        b=EXQ82BhSVZfpRwnoznWYQYIt3jrUir+rMLzoIbdYStCJAnMGZU/Qh3UNLoGrAv8+Ra
         Og03AQdkst6A/GbRFUBrLb5syZqZMqXSV5LjQ5tfbj9+LSnFIvjATVzLQjNoODTqM8CE
         gTOM4JuSGyPc9CCTti+MYCZlXheKLAcsuKcn98rjqtSXDxZz9ub2lWxnHjYTFFAnpBB2
         aI+ob14PpQx6r8BpSR+HOssIHSbyfYHfj0W4eMqPWRXpSznG44k2+VYIydwBfUfslv/M
         usO9Y5oUzAJUcYWiMT65adYX46SqETpmeYK8aIO/y85vCfG8AhO3zWMcPhndNycmsOZ9
         JrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767094672; x=1767699472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Jq/YWcpAHyrHKvdGDEz/0WDZdNHmowQop97a+xcOpM=;
        b=KvkvSi8YmR9+y6AuuEqeoFcsVr+XPDrkPSesQ+wQzsllvXimA0qOy6GQK4yYldoyb3
         aN1rQDdAnlJtamyK0stDZ/z+GXFEzZsXcW/F5Nk53A23MbMf9aVJNlVV/aaIWsAFZG9v
         loWmBvK8+8F47qj9OhLPo4/uENMJ6Jg0H8rNrGjPAnlG3xRozCHR12K9iV9CHbX8DdRc
         TJV3pDuZ95Zz0EcXrXfWXIN/nmaSb2QqSc879JRe8zCeObRSVgrsbSn77TZAW7FLfCv9
         j8i6JuCt1KrS6MSwfeh3VFcCjSpco/LAxeBJYv8pToz4wMOerBA3R8fFHxRxtQ2vJ4JO
         y7rg==
X-Gm-Message-State: AOJu0Yx1YJRWlP4sFlnUKSlIAAFFQ5km7wKdn5CQO3KO7z5SNBg4e+FK
	k6h3giux1RqzqfgsfBhF1mvartNsf0L1VTZHVSTcNNxw08edqhesiLqRcTFSR0B+5eA=
X-Gm-Gg: AY/fxX7IuoWwDCLG3zGgoWbviJOaG42zI/uUJkgXQzXURsQ3/lOInVlzJ3Vc/FTG7xr
	vh9ZwAS62JPGclgDE526Kw9NjvuDRs5ltYgogfkARs54YPZBIovG2J8KGBCR3IfpazpyEUouj9w
	A5mhXgixi64siO2fh1zoma7BpmVaQbeiHTfEtFYdEj9DnBheqbRsWO6p8bg1bmcZW8HA322qlgo
	jqavpP0UlyS7aLxTx9zToJzPyJsHV/cX1BeY1GMu4+GbKp3s/e1MNhX8CVALjrcYBaFwxZ+fyY3
	iqNXQcPoYq8zupILzS4pVffwsYVO6fqzSrztUPxLBVI8QAm4j+98US0U/k+o2lByzGIcOcmVdfg
	q5NfP19yQIx640pFzqMLZZ98gqbUlGCVz91Vxb++aseymm6B0HSU0AbM9YNT1a5eWgw5eeNB6uF
	fn9xTGvYbGqq1LeLpfA8ku097H7pxTZiQ=
X-Google-Smtp-Source: AGHT+IH/ALRIJgngfCVn447K6XVqJGY6ztCi6Hrq9Ox/xoemMijWPuk9J62Uy2/IxZdGfgS/5p3HdA==
X-Received: by 2002:a05:600c:3e18:b0:46e:1fb7:a1b3 with SMTP id 5b1f17b1804b1-47d4e6fc0f1mr156751285e9.23.1767094672378;
        Tue, 30 Dec 2025 03:37:52 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be26a81b6sm662176195e9.0.2025.12.30.03.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 03:37:51 -0800 (PST)
Date: Tue, 30 Dec 2025 12:37:50 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memcg: scale memory.high penalty based on refault
 recency
Message-ID: <4txrfjc5lqkmydmsesfq3l5drmzdio6pkmtfb64sk3ld6bwkhs@w4dkn76s4dbo>
References: <20251229033957.296257-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uwgqa4sz6s6dsalx"
Content-Disposition: inline
In-Reply-To: <20251229033957.296257-1-jiayuan.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1BB1CC0007
X-Stat-Signature: smycyue75uaiwgni3sogd6xez3y7bau5
X-HE-Tag: 1767094673-88959
X-HE-Meta: U2FsdGVkX18IGKab21nM3bCl2tqf1EoqaO07u2ScuIo0LAP+2ddUSPDTE+2UE4ndbk5+O+WEeFZZ+Je0+XW6zQzOfQnUjdPkifeVQKk71jX7BOiQvuxhljM2h4ZTMUbJOIXJqAoBmOo3Qclkp6+35Msa50BeYeLuS1sVozDza2/pO/GS/F1SfISkN6uJelyCrfXQqAUDZHafGI+6zxz2CkpGgyDCu/SXsyacIxoJLhynU138OCgcJpFhXRqvMyNbpe1ukAdyYw14x5lN2132v5sBMhR+Oo4vR56zSUTe7NfL2FwplA4f6A7Bvg6pq3sG9UAK8cEItK2y8r92dsn3lXaiQYMgEqGUQ2QgXV7ZVpfvW9qItNzanYNwfeLDGDEZ7rxVCoHUXyAJ3sMlOi+Rpl3eR0htCNL4iAQlTm4ZqduXY2cIacmueZZfT599HB2kEOx1l32yqulq1UESwFPBdhRIfRWuYF9Hj1/cOcgxbr2QuWin95cUKBhd/jv/6MZXYVyNRtIqmd3M2FF96JvslwHN8V4hcHLUTGtCM7jRjUxI7Qr0WBktj+8Urwg4KXnTzw+nIHCP5E2MC6iG/v/42XkS+jXVbWsW2pj6k/u4tiYtZLRhI8ctjyQqpvCsTDx/0zlYvwJ/F7Tq2Af/W5pI0Wq8WMV7ikjqVLu5D3j5biVTziuX7sW/xCoEQX1SKCQCZHqdTPn72kx1JUNj+ezavEMNPFBew/PLG0n8IjsZ3tZsW2NgKH+rCxAmBxKrqzmumQU78vlqEfN7Naf/BSK72YzhXi6ZP1XzxUKJj7CPAxGV9H9JBhlX1jrbuLfd+IZCYD2VCB76brV8T7rwS7Ig+RMa1wW4GG51WexqLyDPFSJWCAraRnkLSEc2aZ/AF2JMGcOwfsiMrVqEs3D3u4KUmD5D5Gwnr4CT/e0PHSTx2U1wyU6z8lPUWUMy1zNYzznIOj3u0YbdjbZTgHpLK4G
 sk8XhAuc
 Fejo6YL6tMS4tr4QCb14MLwcFiIYfKRHOj4tfx9U6Fp9Wfe1VQ6ZhgrJDoFA4EXCH1SGVJ/nDkAXmQsDYXGFJqv3vMUAETuYY+T8sGGOPhQbi+cUX6swvRREgxZNi2pJEwuaJJwRj6gwST5cjWiQE11P7MDLQEQqlKtlE4qor88OjADM5v+hsO1s+VtPfx5VRqbe/fIEE/iM/GtVYUl3MDzcr0uRvzA/rg4+BTM1+fB//LCNS7peocn/EWGuJiKfB6u5X6JxsHL/mEPr4ZWMGMdY97JP0DLfl1nCEd6PMbNb/KYqpnZJhGoKdJrWiBDofjagTCcvKlDRIOLAjidD3DHl48e00j0mJbonyRkiV+u/nuxfCYAEO6ctohKW+SRWSFuvMX9+oirOjkHlgagp5GjDtzJHTVRG2LZY8/+y+DTtfsFWwKaG5eKTFVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--uwgqa4sz6s6dsalx
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] mm/memcg: scale memory.high penalty based on refault
 recency
MIME-Version: 1.0

Hello Jiayuan.

On Mon, Dec 29, 2025 at 11:39:55AM +0800, Jiayuan Chen <jiayuan.chen@linux.=
dev> wrote:
<snip>
> Users are forced to combine memory.high with io.max as a workaround,
> but this is:
> - The wrong abstraction level (memory policy shouldn't require IO tuning)
> - Hard to configure correctly across different storage devices
> - Unintuitive for users who only want memory control

I'd say the need for IO control is as designed, not a workaround. When
you apply control on one type of resource it may manifest by increased
consumption of another like in communicating vessels. (Johannes may
explain in better.)

IIUC, the injection of extra refaul_penalty slows down the thrashing
task and in effect reduces the excessive IO.
Na=C3=AFvely thinking, wouldn't it have same effect if memory.high was
lowered (to start high throttling earlier)?

<snip>
> This happens because memory.high penalty is currently based solely on
> the overage amount, not the actual impact of that overage:
>=20
> 1. A memcg over memory.high reclaiming cold/unused pages
>    =E2=86=92 minimal system impact, light penalty is appropriate
>=20
> 2. A memcg over memory.high with hot pages being continuously
>    reclaimed and refaulted =E2=86=92 severe IO pressure, needs heavy pena=
lty
>=20
> Both cases receive identical penalties today.

(If you want to avoid IO control,) the latter case indicates the memcg's
memory.high is underprovisioned given its needs, so the solution would
be to increase the memory.high (this sounds more natural than the
opposite conjecture above). In theory (don't quote me on that), it
should be visible in PSI since the latter case would accumulate more
stalls than the former, so the cases could be treated accordingly.


> Solution
> --------
> Incorporate refault recency into the penalty calculation. If a refault
> occurred recently when memory.high is triggered, it indicates active
> thrashing and warrants additional throttling.

I find it little inconsistent that IO induced by memory.high would have
this refault scaling but IO by principially equal memory.max could still
grow unlimited :-/

>=20
> Why not use refault counters directly?
> - Refault statistics (WORKINGSET_REFAULT_*) are aggregated periodically,
>   not available in real-time for accurate delta calculation
> - Calling mem_cgroup_flush_stats() on every charge would be prohibitively
>   expensive in the hot path
> - Due to readahead, the same refault count can represent vastly different
>   IO loads, making counter-based estimation unreliable
>=20
> The timestamp-based approach is:
> - O(1) cost: single timestamp read and comparison
> - Self-calibrating: penalty scales naturally with refault frequency

Can you explain whether this would work universally?
IIUC, you measure frequency per memcg but the scaling is applied
per task, so I imagine there is discrepancy for multi task (process)
workloads.

Regards,
Michal

--uwgqa4sz6s6dsalx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaVO5ixsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiyFQD/ei6EZorHB/tmtb+SAqVc
bnAhT9k9zviy0M2zfuXDRkMA/jd7o6cfA/S3bGwo7fO+QBFKf0X3xEhY4FL6v8xk
yIUD
=9lXp
-----END PGP SIGNATURE-----

--uwgqa4sz6s6dsalx--

