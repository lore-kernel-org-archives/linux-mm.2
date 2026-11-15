Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB170606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msNmsNkY
Received: by kanga.kvack.org (Postfix)
	id 3AF536B05B2; Sun, 15 Nov 2026 11:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FAC6B05B3; Sun, 15 Nov 2026 11:47:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276446B05B4; Sun, 15 Nov 2026 11:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0210C6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71F3F407EB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:22 +0000 (UTC)
X-FDA: 85437933924.28.9D39DBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D27412000B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msNmsNkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6louHoinpNs3EUNID7jZdBIRJOWqtgvhgkrI+xPQ6fA=;
	b=8h//mrCRDiQAvyO0JG7+6ERN4UCN5YljmvZIskZGnuHpXfaduxZKTQpepYd7p7l8WJqK2I
	ifgMpXs9BU4QIT4yOaPIlC9VejAN6BVEhh1kfUo8r6OggYJjvPY0OuVHQdWEt+6rx1D1nv
	p2swLFFwDqf1kcKhso6Bfp//gKjlhAM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msNmsNkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761240;
	b=TugktN+txhLvAKEMwGvld9RK4XtnHgueNxVaXosi/dpmeuT1TYj/MZtwhAwbkttU561sDy
	t6RKBnwPlyKThSQjOrQI8rvrftDBqHBrhNITNmBjoIlZJqFs6WcyVJX6H8FZNrtM+tKYNV
	kCwKhjQR1YmePQqx0tKt/H85OYlcJfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 670C3612AD;
	Sun, 15 Nov 2026 16:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6D21F000C4;
	Sun, 15 Nov 2026 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761240;
	bh=6louHoinpNs3EUNID7jZdBIRJOWqtgvhgkrI+xPQ6fA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=msNmsNkY4vUNtQfsBy1bM++LCbRCkB37JN4KyI8e8w/mmLlLWwSnMTXliSMxMWRze
	 niFA9E8WEZDWSwAE7tx5bN2QtyajUJr1KARLTobRkzaWr7u5ytyfUHI+wRFEQAMTkB
	 wE/JGETR1Ps2qejbK4wk09pDyxGoirEhcblTVYtgtDvdx4UMp4ES9YnSfxPFivPTY3
	 hRNkNblmkqOws4jg6toD6i0PG1JbcxtUdl4zVWEY/tjCrrksqPR3TH2lVTcYJATtYz
	 QjUIjt8APtlU3FLtMSWDHf0VepIETgKGJPDi35ZhLQOJes+6HE2NHIl/J9Ue529aLm
	 7bMDSMX3/F0YQ==
Message-ID: <sashiko-outbox-215655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/balloon: fix NR_BALLOON_PAGES accounting on
 migration failure
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>, "Eugenio
 Perez" <eperezma@redhat.com>
In-Reply-To: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
References: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 16:47:19 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D27412000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 93scrn7c5i6z3cwqdcubq3jetsmm8se6
X-HE-Tag: 1794761240-825286
X-HE-Meta: U2FsdGVkX19QiuV6QjVjfrFGbDxohJQz+3gkDmPJaaN2FEfJ3c4TVsgdWxRFGtEwbHYbxQuJECBl6gLpg1OPN4fqRQVmgGqPowoN7Tk2u/uWtYSTgE96TAVygYgXRC9tPzipuwdbsSyVGqrYW4GCVJqLwQYFIQKT3QqBHZVz1CX0UVroW1gp8j9Hz9JeDBUnJ6ft9O1LhYR8kRPO/Y0cGGvediLfAYTfb6xstGMbwLnUG/5zcZBmMsGML4C19tXNFaS294NEaVfOQ5DCqgX/z2ObcEc4/Qpp670KI3HxOKftp0/wtZ9fX2SP5Svht2gjjDwuyhdmZzuLJJ97StT3AwFQxQea8wczaLcRoa8DB+65n//2+O0PBHvJ15bfNyRbyUuQabVf0sDuc1ixpJI2CHlV/euxefyhRJtWge44ZCmlPpzJTr00W2rYAfq8li59Cdp9bC7k/RBUoRQ7CEWMlFSWY1G5knzbbLspjE257MWMH54oTzY1DbzLMw3SkEj8j+eRPw2vpBh+8X0VlDDK9ACu2VJeOBj+0JkEp3gCwLFWIRR/r4b6OVGOof+EdooMQ3vfWEUbWplwFU9ox9IlJ0o6ki3NN8Qts7WHtBAJUYQrI9A0jcAM3+7W3ZFdLcLWZ++OrIvvQmp1spDyK4QeIqrt60950H0ofuD56Gp00LLSbOi0wmmJwi9tpFzLM1Y0nXP6+tLAxF3TUmuFc4/y+DQ8JHdTcQ3rIC3c85evdmoWvkegHu0VDtDBIto3rvIo/jULuOug1aBP9Tu40Oj6+JBwm96xmCwSmntczolYf7zxReYNxmWXeLC94t7U/X/rtweCOUQMGgWv1hk7Xq6Hlx+ItxBUoKFOz7eqLyJBs+KDygU8w3RK3LxNYZCedIU57ZCpZPSotqzETWyNuSFOe4O692dPhvkV5LZrusPSfZwC6G3WureB6tFvf1vZ0cWqmwzvG8kn0iwOBcj6yYa
 dMqAYB95
 clKRyO1tKoyGlW0GTqMaBAayZjLs9B1hDyavJCv4ZpM3fvAB14xIH/dgL97otTZ/0E6FN5wE/E66e9PFXk2XcfL1BBsvmTteuDFK6zlG2/OYKFc2esmFW/J8aLFaUl9dT0GSMPqIYtPWwhKvT6f+GtE/ZPtgBwEqnppOnO5u/8yC+Vvbd5E9MOMi9AFRgvKm1MgdPoFF1orYO2kNHtJasnecSdOrU6aeQPpnlruoNCpNl5yJBzO6T3kM/+ryAl3MOAL2NS8sZaUE4oGTrU0RqoP1KhYZz98aGL/Mns+dn7RONWXwg+loxo/zIZpcg09dgNMVtgyPc9E/WHdqDSlVSimn//WQC2IA3Mpas7sTwrY1Pla3wpMJyb7Rr4Tq5y46AnBvfJT1MV7dmJSaRtBOao+OrUHGnLbXvHsgB+et0YPfI37ZOu8xdPzOgnJsdeHsTrwatB98rGWNi09TyEIUsyRAn+3Sr4maq7u99bmVM6MVjjoexswHvuRfL4E7pWc2INaxKulUt1RZGE/a5CEzOX4bpYGNzwrfiTWRB/0/gkXMP33CMQVM0XbAv33w0I0E1z6abqTUuWzGdnASnrsYH/K9PDteZQmaIMIOobsNjOyT58MW6YUBcchufpH9JgA5DsfLzSp6/hXNzsJ5vXrb/48r1WL2la4o4rmH5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/balloon: duplicate subject line in commit message body
--

commit d7902e64fbea27d19919ebb1f5426990572ba432
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

> mm/balloon: fix NR_BALLOON_PAGES accounting on migration failure
>
> mm/balloon: fix NR_BALLOON_PAGES accounting on migration failure
>
> A balloon driver's -ENOENT migration result means that the old page was
> deflated but the replacement was not inflated. vmw_balloon returns this
> when its deflate operation succeeds and the subsequent inflate fails.
>
> balloon_page_migrate() accounts the deflation and frees the old page,
> but does not decrement NR_BALLOON_PAGES. Each such failure therefore
> leaves one extra page in the per-node count, which also contributes to
> the Balloon value in /proc/meminfo.
>
> Decrement the counter on the old page's node, matching normal dequeue
> accounting.
>
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES sta=
te")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

[Severity: Low]
This isn't a bug, but the commit message body repeats the subject line at
the top.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115004708909xx=
05JgB9nXnOCG0zL7h_K@zte.com.cn?part=3D1

