Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0127606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OQrbZSeg
Received: by kanga.kvack.org (Postfix)
	id DA1CB6B05B4; Mon, 16 Nov 2026 10:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79ED6B05B5; Mon, 16 Nov 2026 10:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69FB6B05B6; Mon, 16 Nov 2026 10:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8D96B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:51:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A27840175
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:51:42 +0000 (UTC)
X-FDA: 85441422444.28.5E9E18B
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3EC3A2000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:51:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OQrbZSeg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXYWDIxTCeCaQE5l3PV8c9OeyPodmOKqfIOFfbx0Yzw=;
	b=ptpFkbn3c2MoN4IDk1GvX6OAfTL7sYgFSeTEgeqhsyztXo5UiBVla9vdu2fUse0YMlQpzL
	QkfgxiA6OIlLPcUIdKsPsY7svgcJ74UnlfG+GrrMFbKbXbRt2VD3TFs+ET/Z9aBKI9ZkrN
	MISN3rkLFPV+fx31QdtQDembOx5K4yo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OQrbZSeg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844300;
	b=ZoJpOOaeh8yByS82NxnabDoXsTiEuppb28cKPQeQL57RRnpy8Qp2adzoX3/yvkhGDBYdqL
	62JB/Amr20Rm01uevxZoAChcPQJSnmcpIdAR0tYRzD7vJkVefyG3JkvagWSIrpmNw1KsdV
	lnduLMyEEvjqRVtaZytNEbsHBtnguxA=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5ee029fd76aso3437123e0c.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794844299; x=1795449099; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RXYWDIxTCeCaQE5l3PV8c9OeyPodmOKqfIOFfbx0Yzw=;
        b=OQrbZSegnTqjhhEipSp7GTcO3aUlVVvgS3uclzZ+kTNHlbvy+3i85WTRoeTW77w16q
         bmCXDGfrpEsLQZMzEFOvQOEOB24mzkUh6rkeKB5Oc4ETG7C5EGS5i4CIgjCMLaPFArhr
         N94ozaAICVB6IYT6BZDcRTAGwA2vViEeX4EssdX2p20mLy0//UiVcVZwhPgb4pe4xak2
         uqnYbLaBL+v3YUOV3PowIAF1EsNayQWQwAapmJBl2ebtnHW+JY9XvzkWxOCDDLGVuPq9
         V8/GWrPDaBQC8hRHwmrnx2hYY79y0L5Rp2+o7ALSBrILYW+riFgPS773mLeGXZycHkBL
         IIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794844299; x=1795449099;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXYWDIxTCeCaQE5l3PV8c9OeyPodmOKqfIOFfbx0Yzw=;
        b=sD7HrNlMzAaphDXjux9t28miAXUM7c+0KemU6bTZ7HjOyrDgcrXpk1krPp5r5okiLH
         evNlQPtxOvsOZROLWQrKuYVyr/Gj+d1NfPsBioQJKKnfNbh6RVqk5RGX2ixUUuIKQ8HI
         /hPxqoN79L/J+7rrSdQC2WtV2pjxTZnUiMa600VnZbxzvRZC+/EtTIxIDONp8rz6JkJP
         M6JGerZsyFdJ3qa4fsUAlya+/YQQH+bonoLekgMyNVYzOs1hWji9fV+A30obR2FMbjzY
         Hc9bjfZxyigc14BgLxOwH/+zswD4u9Fy9FxqzYv9JSXkd+X3aazxhpwzdejwI3lZnGt9
         lcLw==
X-Gm-Message-State: APuU4Z+Wfr+N7JMIcJ+XCnQjqGxWGMNm6ieZtXnb+pUsjJx8leEtaWnc
	fe1j2+7VyHCbZLv0yNhMK/B4TSfpOJWyGNJxOxPIDLMEag1Q+TFfFttGyguBkybFoUJhKJjMrGn
	zM9u0
X-Gm-Gg: AYBFou3bQA5wNQuaE7zuqBXLG1jbZ6e4krwfKo+Lc1n5o60/O9sIUyieIfkU+LQ1KjD
	7z//lQEVmLPGWJU1EsXIv7vpbqd/++xmjOikeWcJKUeRM+Ss+l3rW56qERcSqfI6t6bDElThZuD
	XJwLCBx1DosRDqe+S/E/3/I+1hqGhnWqjsDm0MUNvev6f5b3ZM6ADGeCJEgZShJKp82WAqHzTxY
	+wdXfccAjX/96CeEkoDN5b0tjg8LKHsNC/9LoWTwAQLoPfk1yBXwZBMbQIBfVd4ql/CWOVUEVqp
	0IDa8I2jiOCDX7evurBhgvqpgFStRQh6yMwGht+RmmrQGSnEYAWFPLdD2gHsdmf8oBvwyjM+V+j
	l/mRoS2Qv6CpLaah73f+nCiFAXmJCA+zAksiPQeuMdocAg+G2XFWP6+3m0RwfTrc5qZowFBlDZ3
	30XlCkMSDivJnaYcWaTjq7O9CzOugDw/5/VL8wprmn5l+d45/tRMMp88oKxkWzYuFm2HmVtgHqF
	x55OedutIUQWtGwZYkVm8MpV1BXcIMZFAHJNuoYtIJ4Uu2BcLeJIrRhjxE90wZVps8Ugj9RAW94
	NbwaFPE7Vs2t9Ydx3Wc6XD67ErtHRhoeswwmjUod/xCUMR8u9upUFK2Kf7F4fm6ElOXVXhU9v+i
	WMn/FFGtTAQFdaMalQfg1NVussnmuWpY=
X-Received: by 2002:a05:6122:62e6:b0:5c9:a60b:e5a2 with SMTP id 71dfb90a1353d-5ee34a87371mr3856682e0c.13.1794844299167;
        Mon, 16 Nov 2026 07:51:39 -0800 (PST)
Received: from localhost (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee34e8fe0bsm6514324e0c.11.2026.11.16.07.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 07:51:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Nov 2026 10:51:37 -0500
Message-Id: <DMWR7BK3N2LS.X31OPI6CVASV@soleen.com>
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, "David Hildenbrand"
 <david@kernel.org>
Cc: <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: Add IRC channel to MAINTAINERS
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261112212230.2805832-1-willy@infradead.org>
In-Reply-To: <20261112212230.2805832-1-willy@infradead.org>
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EC3A2000C
X-Stat-Signature: piztugtafbafpd5p3hmsupxok3x6sbrm
X-Rspam-User: 
X-HE-Tag: 1794844300-470597
X-HE-Meta: U2FsdGVkX1/Vg5+X+0CyKOs8yU+tePwP/rmIveVRrCuY6gPrx+Niig5olINNBe9tAUogQ82XB48OKs9b9EqGEutYQyg1zIE2y168XgblFDsZB+zgtjIXlpkPA13UK8Yt3uLAWcb9KIKCVTJH8hhlxk3LUFf8KC0W3KmFNjVRcih/Hzwmm282ZTtqtKMPGY4qLUaWPk3Z1YOK37pIS2CvsSjJtyj+CA26QFD2VdA6DuCPouAGDKlXasxcWeleTedDgfei5HTJZvVI6Ld3rB0BzvE+1xxWaFxLBZE+kppmlEEHICPRCFAmhF0FZxIbuoptDW62DXRuPyo0tCyza2y4L9OUAKtrkMovrDu70ec+tYUEoRuGUW+3Kt8igm+Upu+Ym1/GX5GcCaaEgT1ZmV5DbSA/cqFIpNXloadYTU6xVuT5kGIelSd5ad7R/ecsfPI3OO6DmHNRVJ+ci7AWlsbR7FSu541njk/7QgpbmmwWmiNJ+2N+1LGwcfgP8LJfyEHqdKpQ1L4MRH/zoH38VWRQAuF1m4CL0PuPVcfaR2pdVSh3Pb3qIrLnLZ+WqXm2SnPO/KTBhMKsyMdgDDxHpTBTD4EXwDfGmvLzwUTHvD06BfBVSWiB0JPSVeSA9nMNDumn8EgZ6/o6n48RUwMY9U+uPJas5LqB0PaGH+iWuii6TpGGOovHgJVNDdcKqgL6aP+qyaRVyJuqcMHmHL6AddobIl1NkfmAt9ModVsM6wp/Okun6a4Knijy0a5c9X9edOHwb9B9nuLbv+w6mx+vT4y3XSNRie20Ugpbayyk4bx/mxobJwJN3d05Pi9RhWjPUXly0rD7RNiaFx4XjgDclr7znwCLfoUYkJUUid3FG3bteTMwJUsDPfGQUk+ntaOkaaas5a8h34GcMwlkwJ7EPkho7b9HRTsic1LiZuLl2Wetr1EENZjDPAvBNhptc6v9I9vnOGcrqztqoHWp1YT4kZo
 0JbHvEdC
 AINqLrfss9GpqHdbc8ojIayzcs0PCtVhZJk9kf/EE/qhP5JSg53hYl/yqCKZiJi7F57FEwAtJ8+aZI+L8DLkG6tLjF8a0OvCnHRsjFR4oQvDQvy5WZbKbkvrEqMTjO6Oinw4olpPTNvc1V18my5XWK2DWe4XdWDYGK/3KzIdqZOM5jcamxhYZkmh7V0T/bBD0w9LCzF9bhUwek6uiMEds5PGbF93BDDNOq8bWr4qirh/Bqj8x1cLIftQUCM/0bYX5d80Gxx5Ac8BYbCRvoNL/yVP7V4QO+pkKfO9p29/m0P3hLDc0RCaoD/RK62jheLcURWjZ9Sj5OJVQrHh9NXnEZvgr+yfqDRykgfYbnBxuavQ7FbrYP0O0EGyVShpzJKh2jUMO/J08Tvtw9khZogtzkSb25KL88iUdlejs1xiEas+DNv1srLYnYshviSSFnKdgjzbZ4Vpy67dEtcfMSOS1t1RrlPyKeM7dGiyV78f0PuJuIodOCiJeBEXZqk5GbzY2RbRIbrJZHBHNGty+F+Vf5Zp65QSQinR1ZokuLPqO+kCoU+p66qmYepBi6Y4R0UZrkbD/TZG6T7x0XMqButl8PDIuTD0h3HIXxzTpufI6O/lWi5Zkn8FPaz6YZp/GdaSBcLHQFA6u+ejRcm4KJLInnOXA0y9PsIpMG9F25FLUNLygcd1POFqYK0u8DZ/6HVnt1G/Vz3Nly9+7Bfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 12, 2026 at 4:22 PM EST, Matthew Wilcox (Oracle) wrote:
> The IRC channel has been under-publicised for some time now.  Add it
> to most of the entries which use the linux-mm@ mailing list.  The only
> exceptions are those where I think that none of the listed maintainers
> (or other knowledgable people) are regularly available on the channel.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  MAINTAINERS | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..d1582d4788ff 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5177,6 +5177,7 @@ M:	JP Kobryn <jp.kobryn@linux.dev>
>  M:	Shakeel Butt <shakeel.butt@linux.dev>
>  L:	bpf@vger.kernel.org
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	mm/bpf_memcontrol.c
> =20
> @@ -5918,6 +5919,7 @@ CACHESTAT: PAGE CACHE STATS FOR A FILE
>  M:	Nhat Pham <nphamcs@gmail.com>
>  M:	Johannes Weiner <hannes@cmpxchg.org>
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	tools/testing/selftests/cachestat/test_cachestat.c
> =20
> @@ -6868,6 +6870,7 @@ M:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Muchun Song <muchun.song@linux.dev>
>  L:	cgroups@vger.kernel.org
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	Documentation/admin-guide/cgroup-v1/memory.rst
>  F:	include/linux/memcontrol.h
> @@ -12212,6 +12215,7 @@ HMM - Heterogeneous Memory Management
>  M:	Jason Gunthorpe <jgg@nvidia.com>
>  M:	Leon Romanovsky <leonro@nvidia.com>
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	Documentation/mm/hmm.rst
>  F:	include/linux/hmm*
> @@ -12377,6 +12381,7 @@ M:	Muchun Song <muchun.song@linux.dev>
>  M:	Oscar Salvador <osalvador@suse.de>
>  R:	David Hildenbrand <david@kernel.org>
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
>  F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
> @@ -12410,6 +12415,7 @@ HWPOISON MEMORY FAILURE HANDLING
>  M:	Miaohe Lin <linmiaohe@huawei.com>
>  R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  F:	Documentation/ABI/testing/sysfs-memory-page-offline
>  F:	include/linux/memory-failure.h
> @@ -14792,6 +14798,7 @@ M:	Pratyush Yadav <pratyush@kernel.org>
>  R:	Alexander Graf <graf@amazon.com>
>  L:	kexec@lists.infradead.org
>  L:	linux-mm@kvack.org
> +C:	irc://irc.oftc.net/mm
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.gi=
t
>  F:	Documentation/admin-guide/mm/kho.rst

Let's not add it to Kexec/KHO/LU; we have the mailing list and the=20
bi-weekly upstream hypervisor live update meeting as the proper channels=20
to discuss this work.

--=20
Pasha


