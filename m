Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B5CD3ABC8
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 00:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CDB6B00B9; Fri,  5 Dec 2025 19:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D544C6B00BB; Fri,  5 Dec 2025 19:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C433E6B00BD; Fri,  5 Dec 2025 19:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B178E6B00B9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:25:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5378158927
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:25:30 +0000 (UTC)
X-FDA: 84187152420.17.8711877
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 55DFB1C000D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:25:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CdZu9Bbq;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764980728; a=rsa-sha256;
	cv=none;
	b=zVl5PZOVXXnQouLhlrW8qKdkMOrPP6FOY4Fqi73QzuUL9wOskLvh5T2WoBnm9da8LiKaCp
	4LPc93Y/DC1o/sWvNklmZZtzrt+ExC9To4VYsGhB02l/lzclfd/ws91XTQFAKqLFZrn+Zs
	kl3wyNAz00SuSPQSyIxEvEoToLKVv6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764980728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikbW0KTFV2Hrw3Ofr3+X6/ogNZDuDLj9J6B0i4MyxZI=;
	b=TE0nnlN9x0LGdjP1u8R0bpHWInet0MLeXdP8pcxXQBFy4oEqJzEkhowQPCprJhcxjNcN2O
	UgjuPqWCg8riyUW02EHrJVBYWDqSxjyOIvK+RVDBVI/GP+6bD0m1sEA/f0N0OdGG1xNtfx
	L2fZNElJCn5iE4Osrx/bjyEItvSRiOQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CdZu9Bbq;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29555b384acso27371945ad.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 16:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764980727; x=1765585527; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikbW0KTFV2Hrw3Ofr3+X6/ogNZDuDLj9J6B0i4MyxZI=;
        b=CdZu9BbqiTv/1eQKxmkkZ4y1p4SPXDCD/xmpOEi868FUjQ1ztymHIrBG2piqN5Cx8t
         TYoWjAFGyCKoyiMQXVXhePKYbzCDrXQ5SuZfxAefMtnRinY9mcH+HEbLsknRpyHNuBAa
         IVY4Tu+d75npnjqrx7i/uvHhJWdBxG2lujQfiVfSm6wAKI+UIIhDiD45Kezl1NUQ3kdz
         q0XvUYe302ErBGCnHA8BfK8gcI5R21A72FHxQ/PPR5dMTlwviT/V+t6Pd4o3nLSlt79b
         98UXSr0BgVHpshw1nbaRV9MHwGQ+rc/B8nC7Egld3lgYTgiIbUPmcyyH784LrhI7tQ1w
         IQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980727; x=1765585527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikbW0KTFV2Hrw3Ofr3+X6/ogNZDuDLj9J6B0i4MyxZI=;
        b=JrpLSye5qBNGzoGK/KN44RHGGHth1uk13xVWtTgBoVjUHo8kUoOaDEZ0ws88DwVdHk
         3N05PsmUHi6HZo7uwSqaMrAkk2uP7JW/p6kgsbmHrKZeuXvpZS7h5umtCBoKMXuB1Mit
         VYnsMKgoxYFwVpvsDVC3ktoWfJqWUsZYwiv6prD0RqhXTM9avCDJMg8GFBQIaYTTpFcB
         Hrvk4UGKWRq42FYEhcKPUp2ZrmcHrcOx9McLuxezCOwhR238b7U023l0/1cwlUZL/jzj
         KAxPp3Vhm6mdDHwmkCXmzfJVsdpj9rPq7Xki+ur0IarDgRpWhZ28opYFSIamXN+xcmik
         Aa6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1nyjc84G72RL5AWplx0NlknLh3TItDl5J6M+bhdHDWpjvJh/9Q7Yi1mCTa3mTNHDS4kKji7TPtQ==@kvack.org
X-Gm-Message-State: AOJu0YxgcK6QGy+zwfKczvBiwaINN22tLklOHHcIQtPGMJkH19yvBIVS
	cIFqEwi6DEoPUxlYAoibNoWtso75Rwdngy929D/IBeFhpMyZwwnuGDOn
X-Gm-Gg: ASbGncu19H9mQJlE+7q2PwghhetfV+SQ0KZsb0bWRLU4VfMR3gpykNfDUDPF4ZIoTGC
	Qw6mGZgcqHgvTGQREdlZeHVBvp/aDO5J42f3cwRrTS0+8dEH/PwETplAf5NYonbxvVtofkVEx+w
	K0Mp2gxUijSrEFCiI+RtLp/J86kSAOmjczvqdqij+lpIhlwtV2uwdI6a4bTZWFXQz8BAYkmmqGB
	oS6XuxNvwv1iR+4lLMWrdeIiFaiObmcvlfvnzwv+0im5AV+jRF3jjozHtsp4MH9sPxcPMTAu7ve
	aWpYxHk9bAmKAvTJZdNC2XEtHk+p/6Qdd1DlZ2b4ag6j1/giwGPb/vMS1gYvqHf4QaeS6qUrJBf
	nXNggnc9wADCOj70ROf0/9iCmf857EFuc67Xs54C7A7H6dOIQEGUyTQiox4g9H1yvAeSzREXxCe
	r8mi3eFGCZXHY=
X-Google-Smtp-Source: AGHT+IFNW5Pka+s1fJrSmP9O0a70sopCozisYW/i5Hgm/pIQW6s98Wjem3XlUIrHt4X3Mvb+hoszTg==
X-Received: by 2002:a17:902:d60e:b0:295:9b39:4533 with SMTP id d9443c01a7336-29df5ca8d21mr6199595ad.30.1764980726990;
        Fri, 05 Dec 2025 16:25:26 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaac16fsm58106245ad.87.2025.12.05.16.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 16:25:25 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id C8B35421860F; Sat, 06 Dec 2025 07:25:22 +0700 (WIB)
Date: Sat, 6 Dec 2025 07:25:22 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	wsa+renesas@sang-engineering.com, dave.hansen@intel.com,
	geert@linux-m68k.org, ojeda@kernel.org, alex.gaynor@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v18 25/42] dept: add documents for dept
Message-ID: <aTN38kJjBftxnjm9@archie.me>
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-26-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tsFx90K4YzyOMDd5"
Content-Disposition: inline
In-Reply-To: <20251205071855.72743-26-byungchul@sk.com>
X-Rspamd-Queue-Id: 55DFB1C000D
X-Stat-Signature: tjna1wdtc4nu4hzmzbh1ifhjrobhuk5m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764980728-820114
X-HE-Meta: U2FsdGVkX1+ypVlx8Mp/6pngTogStMyuAh/Gg968I1M7Qc7Kr3YutKXS85c7+uGglveE7WltO0JE2LtF/d8O9dIHB82mYshJNjhqp93WIc+9wFnC2bPwdHiLmU6c7tMhMixtkt3OIS+30rhDd4kjn/q46gUYBDU+budFtMsm+YXmx1E6Ko3jjvCzNbDwsxwzlVQXwqtHBV/5Y3mwPsJB+3mKGnS3qel05bAp7rVFAbQemC7DfkiOoc3n7ETZKoXX8hDdgUgcAFrsowmuNgwIfm9DiUIf6hl01I3IsqHSE95K3Csxn6CWeKFiV9iUG++uIYW1X9EJSPfmpRHv6nT5AH3UTI7QV+BbLAU0XobeZsY8ZnGe9bRBnTiSYSSoAYSD+Hkwk0Y6tOZipf8+rZVkM3hBJa/ZW7aOCrIorjM8ODBa2nwzzO1hiy6vFTq/6AmaewkV5UIsTMlpYm2C+xf/xGH7rTmWGpN2uSeBc/dtPFQAnkyeqWAwvuH+h0kMzgKRIQ3kd0/4N+3jFGG0JJHId0H0IJibdB7EtbyXjc7JCT35HYfuvMrgqAKmBeo08Y/scyYJwkae5g+MNdLEuOeN94t4jHvHXTCTqML1MlaYfGaIIX7HLhfsgEMvm55DLpcRK2bKQVDjnbQo8f5T8wxeIa7k68/eq2A+xzGr+TD7CHyQqlOc9vxwbBx8PBnyfZtnA17AhIBaAyBz56nN3JtHdqfXS5+E41QC05gIqk0qhX68yumxwur9fd0lljdKeZcoR/5t/u85wP/lVYH5lnU2/VQOhYyUJTDJXxxVxzX2hMqq8mcIs4dDbrb1mzpDrob4l0ayz2qM4x6xvDXsREJAWhJ85PonAF4mFm49ex6HhJv/axZepdiU0aK4yrXhoHwVhmbUCuddxXo2ggP/o1+1ZOyznwy3TLCaY2AEbgdiiXhW+HdPNlZe1o1sEedK1JPv/hi9axyNhe50xBgOccG
 wm0zRny4
 4lqkSDQmHWOIuZuxjfmBOt8I1FbYwE+nFvuurtaKiJ5GxFiKhbeeDNAuqvjznfF7CTjFKk7pHS8gJBW51j11UuwUa5Q7VWBzax45lfrWI4BepRJd/rWqIZoQ6lXWHrRUMvq7/ODYQ94BB6+FSjx5yZ/D9sYqdNWET0wguuG6HQxK12VxaQZF9D8E2hvSBwlrKGze30vZ4hX1G74ADedY0CivJqWf0heDvSFfoO3nQrm2cn1e6csFOW2Y9mvkrq9Scw0THnBMQkitWHQiFlWS3UwPM0dhulQwO10FB2jeP3sCErcLFd1pIiIZH9MkodPUTvBNDj0hmBlMpPWOgvcR9eneGmRDGFLbFAEkO+GGvbJ781KUeYrNffXU3leO7aL9Ji+FqbebLTYA0J++PO+xfJiv6NofhNuz6Sk8jXtDo5spi7ATV/J8jCrwoiXkALqM56aHXwbykLotRmiAxEevrJ0tQ/JT/vzU3hnJuf3mexC0LPpfy8OcS97N/FKEEO4Hg+6k4nPC1UqQDdf8JMDd+F421p80B+GHUURysL0cwUN1noQ+imF230ikA2bwmaYSMV20DqKMPj2BvQXt6DC7ikaoRHlfcbusmTmg4APx552u5msyTTuHJW6evu3V1l0DgWOk9eHMFQPKkHLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--tsFx90K4YzyOMDd5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2025 at 04:18:38PM +0900, Byungchul Park wrote:
> Add documents describing the concept and APIs of dept.
>=20
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  Documentation/dev-tools/dept.rst     | 778 +++++++++++++++++++++++++++
>  Documentation/dev-tools/dept_api.rst | 125 +++++

You forget to add toctree entries:

---- >8 ----
diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/in=
dex.rst
index 4b8425e348abd1..02c858f5ed1fa2 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -22,6 +22,8 @@ Documentation/process/debugging/index.rst
    clang-format
    coccinelle
    sparse
+   dept
+   dept_api
    kcov
    gcov
    kasan

> +Lockdep detects a deadlock by checking lock acquisition order.  For
> +example, a graph to track acquisition order built by lockdep might look
> +like:
> +
> +.. literal::
> +
> +   A -> B -
> +           \
> +            -> E
> +           /
> +   C -> D -
> +
> +   where 'A -> B' means that acquisition A is prior to acquisition B
> +   with A still held.

Use code-block directive for literal code blocks:

---- >8 ----
diff --git a/Documentation/dev-tools/dept.rst b/Documentation/dev-tools/dep=
t.rst
index 333166464543d7..8394c4ea81bc2a 100644
--- a/Documentation/dev-tools/dept.rst
+++ b/Documentation/dev-tools/dept.rst
@@ -10,7 +10,7 @@ Lockdep detects a deadlock by checking lock acquisition o=
rder.  For
 example, a graph to track acquisition order built by lockdep might look
 like:
=20
-.. literal::
+.. code-block::
=20
    A -> B -
            \
@@ -25,7 +25,7 @@ Lockdep keeps adding each new acquisition order into the =
graph at
 runtime.  For example, 'E -> C' will be added when the two locks have
 been acquired in the order, E and then C.  The graph will look like:
=20
-.. literal::
+.. code-block::
=20
        A -> B -
                \
@@ -41,7 +41,7 @@ been acquired in the order, E and then C.  The graph will=
 look like:
=20
 This graph contains a subgraph that demonstrates a loop like:
=20
-.. literal::
+.. code-block::
=20
                 -> E -
                /      \
@@ -76,7 +76,7 @@ e.g. irq context, normal process context, wq worker conte=
xt, or so on.
=20
 Can lockdep detect the following deadlock?
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -91,7 +91,7 @@ Can lockdep detect the following deadlock?
=20
 No.  What about the following?
=20
-.. literal::
+.. code-block::
=20
    context X		   context Y
=20
@@ -116,7 +116,7 @@ What leads a deadlock
 A deadlock occurs when one or multi contexts are waiting for events that
 will never happen.  For example:
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -148,7 +148,7 @@ In terms of dependency:
=20
 Dependency graph reflecting this example will look like:
=20
-.. literal::
+.. code-block::
=20
     -> C -> A -> B -
    /                \
@@ -171,7 +171,7 @@ Introduce DEPT
 DEPT(DEPendency Tracker) tracks wait and event instead of lock
 acquisition order so as to recognize the following situation:
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -186,7 +186,7 @@ acquisition order so as to recognize the following situ=
ation:
 and builds up a dependency graph at runtime that is similar to lockdep.
 The graph might look like:
=20
-.. literal::
+.. code-block::
=20
     -> C -> A -> B -
    /                \
@@ -199,7 +199,7 @@ DEPT keeps adding each new dependency into the graph at=
 runtime.  For
 example, 'B -> D' will be added when event D occurrence is a
 prerequisite to reaching event B like:
=20
-.. literal::
+.. code-block::
=20
    context W
=20
@@ -211,7 +211,7 @@ prerequisite to reaching event B like:
=20
 After the addition, the graph will look like:
=20
-.. literal::
+.. code-block::
=20
                      -> D
                     /
@@ -236,7 +236,7 @@ How DEPT works
 Let's take a look how DEPT works with the 1st example in the section
 'Limitation of lockdep'.
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -256,7 +256,7 @@ event.
=20
 Adding comments to describe DEPT's view in detail:
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -293,7 +293,7 @@ Adding comments to describe DEPT's view in detail:
=20
 Let's build up dependency graph with this example.  Firstly, context X:
=20
-.. literal::
+.. code-block::
=20
    context X
=20
@@ -304,7 +304,7 @@ Let's build up dependency graph with this example.  Fir=
stly, context X:
=20
 There are no events to create dependency.  Next, context Y:
=20
-.. literal::
+.. code-block::
=20
    context Y
=20
@@ -332,7 +332,7 @@ event A cannot be triggered if wait B cannot be awakene=
d by event B.
 Therefore, we can say event A depends on event B, say, 'A -> B'.  The
 graph will look like after adding the dependency:
=20
-.. literal::
+.. code-block::
=20
    A -> B
=20
@@ -340,7 +340,7 @@ graph will look like after adding the dependency:
=20
 Lastly, context Z:
=20
-.. literal::
+.. code-block::
=20
    context Z
=20
@@ -362,7 +362,7 @@ triggered if wait A cannot be awakened by event A.  The=
refore, we can
 say event B depends on event A, say, 'B -> A'.  The graph will look like
 after adding the dependency:
=20
-.. literal::
+.. code-block::
=20
     -> A -> B -
    /           \
@@ -386,7 +386,7 @@ Interpret DEPT report
=20
 The following is the same example in the section 'How DEPT works'.
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -425,7 +425,7 @@ We can simplify this by labeling each waiting point wit=
h [W], each
 point where its event's context starts with [S] and each event with [E].
 This example will look like after the labeling:
=20
-.. literal::
+.. code-block::
=20
    context X	   context Y	   context Z
=20
@@ -443,7 +443,7 @@ DEPT uses the symbols [W], [S] and [E] in its report as=
 described above.
 The following is an example reported by DEPT for a real problem in
 practice.
=20
-.. literal::
+.. code-block::
=20
    Link: https://lore.kernel.org/lkml/6383cde5-cf4b-facf-6e07-1378a485657d=
@I-love.SAKURA.ne.jp/#t
    Link: https://lore.kernel.org/lkml/1674268856-31807-1-git-send-email-by=
ungchul.park@lge.com/
@@ -646,7 +646,7 @@ practice.
=20
 Let's take a look at the summary that is the most important part.
=20
-.. literal::
+.. code-block::
=20
    ---------------------------------------------------
    summary
@@ -669,7 +669,7 @@ Let's take a look at the summary that is the most impor=
tant part.
=20
 The summary shows the following scenario:
=20
-.. literal::
+.. code-block::
=20
    context A	   context B	   context ?(unknown)
=20
@@ -684,7 +684,7 @@ The summary shows the following scenario:
=20
 Adding comments to describe DEPT's view in detail:
=20
-.. literal::
+.. code-block::
=20
    context A	   context B	   context ?(unknown)
=20
@@ -711,7 +711,7 @@ Adding comments to describe DEPT's view in detail:
=20
 Let's build up dependency graph with this report. Firstly, context A:
=20
-.. literal::
+.. code-block::
=20
    context A
=20
@@ -735,7 +735,7 @@ unlock(&ni->ni_lock:0) depends on folio_unlock(&f1), sa=
y,
=20
 The graph will look like after adding the dependency:
=20
-.. literal::
+.. code-block::
=20
    unlock(&ni->ni_lock:0) -> folio_unlock(&f1)
=20
@@ -743,7 +743,7 @@ The graph will look like after adding the dependency:
=20
 Secondly, context B:
=20
-.. literal::
+.. code-block::
=20
    context B
=20
@@ -762,7 +762,7 @@ folio_unlock(&f1) depends on unlock(&ni->ni_lock:0), sa=
y,
=20
 The graph will look like after adding the dependency:
=20
-.. literal::
+.. code-block::
=20
     -> unlock(&ni->ni_lock:0) -> folio_unlock(&f1) -
    /                                                \

> +Limitation of lockdep
> +---------------------
> +
> +Lockdep deals with a deadlock by typical lock e.g. spinlock and mutex,
> +that are supposed to be released within the acquisition context.
> +However, when it comes to a deadlock by folio lock that is not supposed
> +to be released within the acquisition context or other general
> +synchronization mechanisms, lockdep doesn't work.
> +
> +NOTE:  In this document, 'context' refers to any type of unique context
> +e.g. irq context, normal process context, wq worker context, or so on.
> +
> +Can lockdep detect the following deadlock?
> +
> +.. literal::
> +
> +   context X	   context Y	   context Z
> +
> +		   mutex_lock A
> +   folio_lock B
> +		   folio_lock B <- DEADLOCK
> +				   mutex_lock A <- DEADLOCK
> +				   folio_unlock B
> +		   folio_unlock B
> +		   mutex_unlock A
> +				   mutex_unlock A
> +
> +No.  What about the following?
> +
> +.. literal::
> +
> +   context X		   context Y
> +
> +			   mutex_lock A
> +   mutex_lock A <- DEADLOCK
> +			   wait_for_complete B <- DEADLOCK
> +   complete B
> +			   mutex_unlock A
> +   mutex_unlock A
> +
> +No.

One unanswered question from my v17 review [1]: You explain in "How DEPT wo=
rks"
section how DEPT detects deadlock in the first example (the former with thr=
ee
contexts). Can you do the same on the second example (the latter with two
contexts)?

Thanks.

[1]: https://lore.kernel.org/linux-doc/aN84jKyrE1BumpLj@archie.me/

--=20
An old man doll... just what I always wanted! - Clara

--tsFx90K4YzyOMDd5
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaTN37QAKCRD2uYlJVVFO
o40gAP9yWQe507aOQ9xG+y3WznUbz9K0gxVdcJgmBzyPkuLdOAD/SjStuxrT6yQi
Wd1X9MlzPBf7sPwdNC1xXihj1C/n6go=
=b9ga
-----END PGP SIGNATURE-----

--tsFx90K4YzyOMDd5--

