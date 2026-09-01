Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE980C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1C36B010B; Tue,  1 Sep 2026 05:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82A86B010C; Tue,  1 Sep 2026 05:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71B66B010D; Tue,  1 Sep 2026 05:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91F4F6B010B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:40:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 039CCA023D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:40:37 +0000 (UTC)
X-FDA: 85164698556.20.E5E4D56
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id EDA72160012
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:40:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X2pyHvy4;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788255636;
	b=extoPHNvbztwPUVctjrvaJtdmBrqb47s8KI1AI0AJyhx7lCE8++KPaIGxflLQBaPSjhSQq
	0s0VxfIatv0Ee6/r81tijl5k6JpNiJWOeXYKSOZs2mYvv9NdSoyQVeQjB4OreiGuqFhAeh
	HAUdHUoDrro7ohVtCm0NUyjUWAq8jH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788255636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5j9n+oKHaFzgx1DDinsR7OA0Nu8ZG/xJIjlL9o5nBTU=;
	b=NHv0ulzaH5QDGO6bHa7XBczhsHovx1HZwhxV7EvFycrrBH82GGMeivGQsbrJcTWpwOmW0W
	hcxIu0XTYUtXdW/Cd+iJo02xIu/rSxV/kRjEObEheH+LHYt7s3f3/4SQgjJorMp5TeyT9Q
	933ylGCNjrFv7SMJbeTj0uf1UFnAzf8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X2pyHvy4;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b8be0409fso5156965e9.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 02:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788255634; x=1788860434; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5j9n+oKHaFzgx1DDinsR7OA0Nu8ZG/xJIjlL9o5nBTU=;
        b=X2pyHvy48pFjBhm1ie0OKpblGpkr95EJGz6jzAPByDYmJsb6FE79Ohd2kBD7r5A+o2
         VH4IRBIia8d/nPyC/hum0kjPCOINbPdNRK09yhY99rc7IXvoXrQc/69aGuRXHfv6Dl6N
         O7fcgkbOH5WunQW960BWoihNWAxHVrM4j5M/2HzHfOosRvNWV705bjIdQqeIwO+MMzB/
         mv+amLy51EE6UnoedRXLPJKl5e1BxlD6zKjJQ/cho1ZhPnTIPbrNHsCDQ1DkuHCDiR90
         EHLEMP05TjiDAU8P3pjMmmwYjXi+8wZJjHFmRuGdk2gkAes+OW1xBRELEvb7/JX1t96K
         8CBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788255634; x=1788860434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5j9n+oKHaFzgx1DDinsR7OA0Nu8ZG/xJIjlL9o5nBTU=;
        b=DIc0KM9l9cf1h/1m5/6yr9xN/au2YZEFpr87ajSbY0gdA/UNXudpvsfyflxbCGpXih
         sMn8mkeu6K1U0/YYz+IKXgbB+CPVtNw/dvjkV0dM+sO1bN7C7fuVTt8oUfibdeJHXcOK
         udlBM6wekqBk5e+fy3kBFvTqozAiS9lj3AMAz0hJOYpMwz4nrj2cNntA4OzQTYG0r/Y/
         fp1SiR9VoNn3epS6+cPyRKi8PJFig01klN98i6Ev85om9Qp4zmwYnJuISyU6hqS1+4fb
         aneXgy6jolVWLe9tXmLbrP9nneE7rD3snUlLGZfEq2heavJH9yCtFQB2JRoDF0qp00UA
         RpBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqCb6oTuHc6Z0bzGWRHX0rpgeYbwecQgNZX0aDxzFd6ZexpGSsm5PE3YF5tn1ufaMP336xu/uYpSQ==@kvack.org
X-Gm-Message-State: AFuF++lqU4VN8hxA6RaiorrR31shzBa+xWUQb/eFCe+FM+MK3/abb13g
	nG+9BICer4toWbkTBZOvZinUpmL1RMo5wZzXAENyU4kY+VNqKRm1zB/FIqPZ23G48C4=
X-Gm-Gg: AR+sD13j1lZcSr2xO9KFCjmn0lYA1vOnosEMufaoclwrqsmc+4SQOFKRGe//veFTE4S
	SivVzBbuv/qAXk2Dr9AnRSORS/NPCbQPsCm0iv94+DLFi1sMKDbkNr/RF42QqODTWpBmeQmn0sX
	r9O1a0kMljRSCuz+xMblksjVdKbEz1KGWAPWVaRq+S3X5lO9uFgHnykOTc1plxjBvWybSIkvcTY
	KYKevTPUHkpopRgtE8KcEmmLurNCcMXMd4L2g+J6Ry3DNYZKpIAnfBniVRSMSUYgGfZrQFe5V4V
	kooD4I9ar0Wfgt23pNJ1qkwJM7hHkO+UYfDjS/yum9ePN+GWP0sWhpK687h3dc023hZqTyD0BJp
	hfm7FN9EUWc2xWcrxxJTAMF/j76j4HULvorZ5SSpJzHRu8y1vriRSco+NyJe9606iP/G3BxhPEj
	b197CGDNmWV5IjUeek3MKH8TrIEamHnPZxGh0DnMGit6mPk8lO7sXiFFz/mP2dRsk=
X-Received: by 2002:a05:600c:1f91:b0:499:bf8c:cfd1 with SMTP id 5b1f17b1804b1-49b91c1c784mr475965405e9.2.1788255634423;
        Tue, 01 Sep 2026 02:40:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce1e3a9sm54689305e9.15.2026.09.01.02.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 02:40:33 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:40:31 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, dev@lankhorst.se, mripard@kernel.org, 
	nat@pixelcluster.dev, tj@kernel.org, osalvador@suse.de, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
Message-ID: <apaZdbM_l3kJIiyK@localhost.localdomain>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-8-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xo3yor5m4gjcubez"
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-8-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDA72160012
X-Stat-Signature: f7ue34oksxffw39kxq1u3sd7a3hx8zom
X-HE-Tag: 1788255635-562208
X-HE-Meta: U2FsdGVkX18n/9i2Qf/xEKKATpkZnxQhjA707tP7JHnru8O+brZTK+nxbZcNmD5UJH6mzVKkaoRXRfuIRWGmgMFTxVoaCsk2S69z9yVgIsi2iMkqtNvF+S4geuNJqYeocdC5PbEHsdFgE2ksUcPQQTlFOSSdk7W+/J268JycjIV/keT+z+BwNu2NW4yRpTilSzRU9Mn959DulVBuwAmoR9RIXZauIq0OxsfKN+s8GeT/7jw3jktC5guHBw7ZSMQ099apGxNZnRfmperXrZ4eSJ0ssuenLbFGEXAmIZdQ5/HxssrBIQP4nL4r3za7ot7Dj6c3XaiqG77QIn2jBcHZkd4aUciBxdUCfsMncv3PkhHsdJqQtLhjq9s0izDH/D9kfTW4W9NdGQB8yZsx9LAZCOQZIN0zpd/1RbTsIKMSy22bV40PHEsX1W95ctQI2F0s211k9bZsCPQRjlCRcjG//9RkAWYDS3XWVX2OTeWF7IisXTF1h5441fdIL3qIRwkPQ7XvJbBGlOGjCZDoV9Ird1A1e/RqCscNdfszfAfmCp36hn3rdowyim6jNGabJqPtuBkfCmPCqbfCcgqu9IDtsrhGC463YZwiufNPfg3lDqhhdloKDGlqfKWjrtQfb7wvM+Pa1kX67lvt5oYgBMYV8oI0BRAxXcBZx12cWGAEZZJlJVCBbMW+qFD1ezHylS+huHTQQzUzKNnv3MQb9o/LB8IiD0shDY5tR412KtB7bVZioWiigVIvoPAaxlFnWfzQ+uN/TKN6zR1eNXsQJbH+miWQqDTLq+STb9SDnxJm7BwVXKn3whYBe675q9OqV9t5lahwV+ZFxR8gruA/CYu197JoeB79k7KCFjOlNpvOHYO0xPo80lZ672eiCcmPN2oZ1KKS10W1OkgZS8S8fFRi8DQen4il4xvrSXqS4V1HHBwBxrU+GTktJ8++XE1gTe6l0MBFBDXLZkOECtk91tW
 G2D8swzN
 rTKiDMpMgudljeQL8/wrk6n9UGomAIGOlJNev30aeOTvrsk+SlpeIPJWevrgxRgNjXIoFTa38rHPIhR+vVWT7Q71wsN1DN5ufuDB3jRpVYK3ZkokqE1tid5OJBpD/4C9snRJMAcxiUj5EsigNorVGOQ16+HHupHJCrwLL0Ueztw+ShNiFMEagD8aNNb5iCG/TsOrQdM2usaeqvfJoQXMfD/2/PASOBadqUdj7VmyWHLeN1g0BlH7mQsGrJ69Hs+WSPLo4eTlgpEkzvWoaWakzvsISvjinyEKg3qnElFP2tY/aT95J69SLyNSzG7o0rDWUjhTYyGdFoLKw0ljwB55drIwYKzN62H6yAXM2I84RdRUKYbQO+/E4nXzMQsTANIrFxrbT+zEpbzlNAwULcxnuwsbi6jWHh2koKXkU2Pss2Dis9/WDet+fCUyAUKNL9bALnT1hKMCcTLE6POobDpFy2GTXdJeZqz6aNRlPg/Hwgc/JPChrbArg5eI5LQsMFarnQfI+hQY+jt72ul5pf9rc96pumyZ9DzGo5/tFh/6jQo6Ns5hCUDPwm9Az2XEoxohkDEbNEk5sg6GIOxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xo3yor5m4gjcubez
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
MIME-Version: 1.0

Hello Joshua.

On Mon, Aug 31, 2026 at 09:37:51AM -0700, Joshua Hahn <joshua.hahnjy@gmail.=
com> wrote:
> Before this series, each memcg had one stock shared by all its
> page_counters (memory + memsw). Now that the memcg stock was folded
> into the page_counter level, give memsw its own page_counter_stock
> so that it can benefit from caching charges as well.
>=20
> Note that while the allocation is conditional on do_memsw_account(),
> the freeing is not; the freer will only free non-NULL stocks. This
> matters because do_memsw_account() could have changed in between the
> allocation and the free.

(Just a passerby comment, I have no remarks to the overhaul.)

The change of do_memsw_account() is because of re-attaching the memory
controller between v1 and v2 trees. That's not so common operation (but
not ruled out), pre-condition for that is that there's only a single
online memcg, namely the root memcg. So it needs treatment especially at
memcg offlining (which is what drain_all_stock() (also) does).

I don't know how expensive page_counter_drain_stock_async() is going to
be [1] but the v1 parts here could could be guarded with
!cgroup_on_dfl(memcg->css.cgroup).

Regards,
Michal

[1] Now, I see in 5/7 that there's the counter->stock check which should
    be quick bailout on v2 (maybe quicker than the cgroup_on_dfl()
    I=A0proposed above).

--xo3yor5m4gjcubez
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapadjBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiQnQEAn+3D5Q8gH9HbW/icWG8F
xGfgUIWouB8aOWqljr/HvZ8BANwLXDa9DIP7tkMWmP7WhMnwN1qjocussmXJE+Bl
QhQK
=VQ9y
-----END PGP SIGNATURE-----

--xo3yor5m4gjcubez--

