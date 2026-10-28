Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D5A60A2605
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ao+YfK+n
Received: by kanga.kvack.org (Postfix)
	id BE23E6B05B2; Wed, 28 Oct 2026 08:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93046B05B3; Wed, 28 Oct 2026 08:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80ED6B05B4; Wed, 28 Oct 2026 08:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 841336B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:51:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97B3FA0CBC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:51:45 +0000 (UTC)
X-FDA: 85372021770.07.8573F68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96E5840006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:51:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ao+YfK+n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793191903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QgwrBI3wl14x9XOc2FYaDf/AYjSUgDXY7fYshPzgk4=;
	b=3+ZR50cY3MlMvq49oOdPsxdmbT5Zk9ftL+sTdwtT0CNnksmFiG85cLfzi2ESaDgRTWO1Ke
	q0cmnWnCNxo5ZsCUrOIusCVHE0b/zg5qIdCNTFwgua85/Wm8UBLOCpllwFqL0Zgi0IROGn
	U+eaQvEzglL2BuOAJzPgmgnlAb0T1tQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ao+YfK+n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793191903;
	b=Mi+YsN7lqRU9ovvkBar8KmPOZc39x3BQa3W07L0cT6seuGQcatz+nIf1cjTq1A4FO0ZjfN
	AhJhGJA7KCQWBUoSz0V9N1aIqc6EpNpMYXDgDH9yWlV45kyTCZ3pGtDj5NxXyQr/HAsEek
	fMPLaUN0OglKRf3PXzO7IVH+GlouKes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DCE143D77;
	Wed, 28 Oct 2026 12:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224201F0140B;
	Wed, 28 Oct 2026 12:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793191902;
	bh=4QgwrBI3wl14x9XOc2FYaDf/AYjSUgDXY7fYshPzgk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ao+YfK+nSAQM4GiNp9a/zdqZLC9qaI76opULD7jIjHD/2eOT9jY82EpfycUF/1N81
	 xYvkdUVcPInNCe1K6ICbzLZGRFNJokRXoJPOC51qVN6eH2J0PIYFc5IzOHyegvMKfO
	 nWi3vrubywaYejKlhc2OT+IeAht/n+AGAoh9SNA9l48a0mYd0Q42M2F3oq60Zge0F5
	 Cbn/yc3i5s2lUg2eQ0HBRduwcTegcKmmFozT3nzLrWqEZf810F9EEN4LCyf4fWTDIa
	 6yUIPd49TUZrlEX6n18bNB/4qVupRhyX8uuuOUk5cyp1p0DDWOpXLayk+Fuo7Lh+bl
	 S3jdLH8ga9QoQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4DD9C198003A;
	Wed, 28 Oct 2026 08:51:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 28 Oct 2026 08:51:39 -0400
X-ME-Sender: <xms:1-_hak0yawTSG6VO74TCldACfwO3HdoRCjQRlREmV1hoRQIc6vOvTQ>
    <xme:1-_haocqEnrkyUwta2xwErVYeOCIiW5FNRHeoU_NJK3aFAcFRdNyp4NGkHaTm-Ut_
    OVC30F-b8kah9WafQmmwmUefq4HTVmMliQXuVTtM3ELLUaCAln8Jehe>
X-ME-Received: <xmr:1-_hamDkh6Epwxm7nIAHt5kwV7S078xkEeZemQLhpsgILXOro2ZsRQ6ToOE>
X-ME-Proxy-Cause: dmFkZTGE3qyaXVxGyol57PkJZIGWeoKTYQuEzvLABDKdQ+sPhlAGnOjiWdxNbmqxYTkZLW
    FPOtYF3Mh0BXDufsWNqeP+u1K424UqG0/E7TmpbHb4ukX06jB/9APetf2z9qWTvS6jlpNt
    FE2AszEFmluzvuiHX6sDb96WV7WyIkQ9Nc9fBCcK2tbCWlZqLQhKyX185ZeAMIDLHF02yX
    uYcUC2c4r7nNyrceOdZs0exaSF/Yx51DoG06ot6xyfmEvG2un6aO42EF7PMSI5dOAz1uGR
    HlAySkWe21xaQAcJ1lXFnIC872ASFxKh3j8Zst097HloApiGG/3LCYe70+lEIIl2aUdwZ8
    oEbpxq/mZKn5r0FGv210ENmig5Au9zdHfgIRCQyt5mMx0vsXbIiQU0EJcagVIfmnzTnICv
    61YSQBzN1RClpB5jCEd+NIwi7RP38LtABLc3FOislqtD+SJOEDVNxHYfByu7inVkbxTbsW
    NsDUe4ovMvC2eJ4tRR3yKdzvI8x/BbZBTi6DVZC2JrsQGarSRxqLTUzlFuw/eMbCp7cvWa
    YlQPjVsYsSBvRnaAucwl0RhZiK8lajB2LICICvdG/Gd6vfKftiBz7Ttubhodhk+Msv9Bg+
    DwANTLTEo/rKYBRyHGSJ7MyTNqd0LJKKtulcG83ksjGE4F7mVZLZjlXk+t7w
X-ME-Proxy: <xmx:1-_hag2rZ-ERMvifHFoFYhVm1jTki2folsDUc64gKMMgL_JvZ0hVVw>
    <xmx:1-_hahNmWBD1bTvVYoE8UCnoS_073bpJvvgkcIwaMjiVsDkrsflSJg>
    <xmx:1-_havY5Dr_j3lDt7rmUk1dHnpoCwGYymU5Iy_jUlBz1c3h1roCwOQ>
    <xmx:1-_haj1HgrRVJSrCm5vQRdVYVZIBRhxIC9bths7jdKhz3FwI-08w1Q>
    <xmx:1-_hamtCvEwO8JyxD2zmga0K7GCLxU15ZgDVmaDefvMsn9KlsBeJ-ggS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 08:51:35 -0400 (EDT)
Date: Wed, 28 Oct 2026 12:51:33 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: skip collapse_compound_extreme() on THP
 allocation failure
Message-ID: <auHvwK_vtQYtx_Ui@thinkstation>
References: <20261028100119.11340-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028100119.11340-1-zenghui.yu@linux.dev>
X-Rspamd-Queue-Id: 96E5840006
X-Stat-Signature: tp86xujkqk1fbx3849fh9hwshubt7c9h
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793191903-875291
X-HE-Meta: U2FsdGVkX1+ISo07RuylKGBTl9uRrQedQ8qJ49JA5qjk9upCubBzvClHsedQi0AZTt/mR6JIirhMes4VsScjJS0MvZ2WOWl90emfICH23r7mQxCUzlj0iXFZSpqm013M1lBAW4kPq+85E3+aU6lO8F/1kfgRq5QB1kG3G/9AQsF7MezCJtAUKqE7258QmZDEoTX36TpcsJOvfz0gSp4hY3/w5trm1+bzt8QIuURJlkN9WHEM/2MGzGB3yTgiVw0uXv+Axt6/9Hn5YttG8BqgCVt8rIrW5vvCXw0472bXQQkqlAqXn9bb6PjT4X3c82aUp4tNZb0mq4qBmV9bozuD/2mo7+aFXrQkbfW/OEFLjKg86IgATJMLjOQxFbyp6MEBZNvnBtf7KaNQVggj+1/YjmUthg1Hl1D75tKqQFZarCBOkqK92NTclbJHIkYd+xUkTjP0EJQKeyVXT5AM3gFlcI4YL4tDfxY1fIy9lZCLw7+R195k+H45InJZjkEx5MKtjjkvjSeSI+/6NlYBcO3eAQejTkQdLxDCiGPfuXO+JDRu6huu36JzdNvWgS6/Z0+BY8KBoXQcMctIkQV4e0pvp8d+0bxAuuKLvo08SCzlBcRKRemn6rpRfmb41dacxURU9BJTJc9521dAkhloIhNIzu+Lcq+Ld+DlJMX2UMsKi9rB9ycMpnddsbHNkiUcw6RF3uXVE/pz4Y4xE/4CfhmXNRIQy2FfI0pw3jyee4zogO1mjJZhzo4/uzFtDSWg2cVhKQkjiZxGKv52S1ZAQUGisr5jxyBpah99H7tTUEMltX2LHdL9GkMnSDYeiNJvt+AbHOwm/UXHGGbOztYVZ4k2xeTeSqCXuxOfIF1ucGRxI0T3GoXIQwRwlLAqEu4K4cr0vz572uHdF7CXJSDacZ3yRwlCJ4/Qt0krC5pqcM/v94UtKxqOVuLVnH55lAcaavy4W1/UQu3x0/ieuUh6avA
 7VeGmykJ
 Zy+nOJDz0E4dI8e0XpF9AbBz8anmSQ3B/sDN0MXNjFeZDUkEI2lgHdD4ADYdEW+1xw0MKRuFyZijmCeqii1Wwi3ekaezYkQcBFx/dgwIJNki40MUFzs/0NBIzctCxeY4r6lnuh7gmSgeQ8v7bEqh7sT42eMpADRQ8mubfvio77ebd3yV9ue7SCD76NbAVJjXgbU4cNZDZUUY5zWfQzpJZMOQlNz/pevDVzkUTWIAsDc5/XM3yKyITOAhhy1l0jSw0A0taXCv3vDdDx57UM9YrpjQM/CerPkRXLptWt/TRUqPRMze+vUYAt3WQdO+RpH+VfBUH50mbIS6NaNxi3ZgTDZBTJArvweb5tKAY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:01:19PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> collapse_compound_extreme() needs hpage_pmd_nr PMD-order allocations in a
> row, and it kills the whole test binary via ksft_exit_fail_msg() as soon as
> one of them fails.
> 
> Gating the case by PMD size (commit b36bec6a01b1) -- the current workaround

Nit: checkpatch wants the full form:

  commit b36bec6a01b1 ("selftests/mm: skip collapse_compound_extreme() where the PMD is too large")

Otherwise looks good. Thanks for chasing it.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

