Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15466CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 09:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1BA8E0018; Mon, 17 Nov 2025 04:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589A58E0002; Mon, 17 Nov 2025 04:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C70F8E0018; Mon, 17 Nov 2025 04:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5578E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:41:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C969EBDE52
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:41:10 +0000 (UTC)
X-FDA: 84119605500.06.5075BF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42926180009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:41:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZw1HmSe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763372469; a=rsa-sha256;
	cv=none;
	b=adXXR9xd2oJky3YV8U6sc7s+PlpTqK+Bi+yiI15H626US0/LOV1hnSEGNFevpqOtlWZ8iq
	qUEkVVZcNRyK6iSFYxThlYITp/R/6fUrow/S44n3RfotbDWsMoMV6NhFtvYt3w64Ir6YlE
	1BFidvk7huPpYlW28efyMnlcHXVrrF4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZw1HmSe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763372469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r4Dt6eTV56zOHcv9pZBlwFiP5MsCGLM4hQ8wg14fm8=;
	b=xfO74MC4vqgYC2wKipqeVWhUSh1RTn9TWFDoKyxRfIfxA5BuY2Geul567CI4sCHM7lOIzg
	hueSPon0QSoyVZox9z8hR5I6gsQ+yQ+3c2dLg1kwz4KkOjzQ4IzcVHrkDuqXQDdcrGNswA
	SL78xGyJ0IeFrv0KHvB1flHzDpNeD+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C987601A0;
	Mon, 17 Nov 2025 09:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294ACC4CEF5;
	Mon, 17 Nov 2025 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763372468;
	bh=LD55be3edOh4ynHvlMDm/XHjOHztjZ05X5TLRldv6n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZw1HmSe6e5SFAhumoJoHd0IXoPQTP7+MM7Y+b8c2vcXdarBS83di9/hyntP8Bwin
	 QoUWbpZMGv8BUQLEhg5/B1QhjlObNdlqeqG91VFVurp9EWnhWkrfPd+wi4VUWtf3HO
	 l5tPEffj4bxsk3DE84PYjUHLcb9eQokPwtApJ8+RsXygkP3/+K2tUR2j2V+GkAS/rx
	 8hVpFGSKb16yzjkjNRPW9MAxWCY1qHhILkXy91NV+lQrn0avug6sJRmSAbrWCZE0Us
	 /cwZ1J7nuJ9g5szal7SnFP7JqhWGSgsgSX5FVOj5dyIHN1vYwYt9xNndhqpSqSQ7dX
	 VsczE/cGhyjIA==
Date: Mon, 17 Nov 2025 11:40:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 10/20] MAINTAINERS: add liveupdate entry
Message-ID: <aRrtmy--AWCEEbtg@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-11-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42926180009
X-Stat-Signature: 6aift9q4ebp1b4cqmu1qikupf595fczw
X-HE-Tag: 1763372469-278381
X-HE-Meta: U2FsdGVkX18t3XafeDKF7f9GdolXCuX3SOTht4PrrPIHj585fy7/EkHgasr+W82i1XBBvnbucb6Q2T2eblib6pY8kQNyyHBlPjjHrOdM6KIuR7xOKOPa3DYUJvfbKILpN7pjkMkKFD60eruLnGixSUt4BfjjhDt4inXexdOAm6f6q/s+afLXkbnbyIom3SEk65noBtVbeU/KN3jZMW3TI4WlDcWzy6GdspBoex7iR23MBemiicBkgfQjiAQT8Cprji4QUtPvlfnj1Pur8qCS2PcKLpvwyC6F9h7dri8Iroto2uJwKbSKNSZqV5/EUG/ncqABgpkVIQFyV5pSipfKPsha0X4RlTiTgjwscyrE1BPuFZP5UhFmAlRgngsBUV/ebXQ5r1DFeZ5QD85cXeK5V5evNpKOwpxzB4QdeIbNo16PnGV7Z8f+3/qSEUgj6j8IbdQ7iV41NuQUQzXk5Ff+blEfbAqPmMcHJfrUPeANJ/UrHSM8HFriCzqubSxh+QrONrgQtNrI/0QicYS/+EEZWoLh1zVJzO0AFOIZaZN/HZy5QVwyrJgUEe3Mqncny4qrXvqVI7HtQzqcn+vfjSayB6/ClTR+DKoYWFSkXlQEanUHUul/VzWL9JxdtI5kEMWx95m6Pu+2AK5WE5kDS5sqiYPs6aLZ6ieBrLIGfCWslLsYOgkhxfHopLwPhzAzFKr/DR3A/3rACslnG7O2dTpyxHgu8lYxpZGSYNJI3C0gBIXizWy7ZxZtu1vs0YQzY5dl39PXCFOGYXvczVhGq9aLVU0kAIplTk7XTINIopRptOMEU4MFQcCAm6NX9UM9sv34/v4w8G/4tYrgAVneHDFG7Kzb2NjklPXBXGSon66AfT6RhqYvJ3dHOrsiWYcYW1kSwsgT6cR6n8DLKVEqz7OZ0E66N57r+4nPzZQD/O3k/jchOtA+gn3Nz6K9Cph4FHFTio6u4+5QVLsjy4Xo98j
 sXvkIKmy
 wVRANvnSzIRwjGISee6DJINvvVfgi0zErf48pzsiyEitD4U/fudC7XlDQdjCFJWBUIc/bKf6CYi7TUIMNUDWQiHU4oyvrmfU/qMYfIKyYokiHMjMeEim7Fz25mNLYlpqMNBP5x+NaDQ24FMVoyA4CGZ4iyX3rGMGvxbcSpEj+zodAQiB4CeKxb78gQMmAkh97+m0mh7YroPm7uFj7Z1AQ9qfnoui4ItXxsNHAF3W6/q3TZjJ5IU3u4M0ATFexZt4UMu81xlMcTjeZuzuUXXeKq71dJ2av/0b2NJt23jTXfhUTz9fGGRw4GSPAFXB+eM64VlShcKDFstG+M4ucJm/U/82+dsB8lsr+SHk5sHHezT153H4RDFBMc4MQBqYmvPHGAYG6SSXuIETNltsXJftPu2INNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:56PM -0500, Pasha Tatashin wrote:
> Add a MAINTAINERS file entry for the new Live Update Orchestrator
> introduced in previous patches.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  MAINTAINERS | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 500789529359..bc9f5c6f0e80 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14464,6 +14464,17 @@ F:	kernel/module/livepatch.c
>  F:	samples/livepatch/
>  F:	tools/testing/selftests/livepatch/
>  
> +LIVE UPDATE
> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>

Please count me in :)

> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/core-api/liveupdate.rst
> +F:	Documentation/userspace-api/liveupdate.rst
> +F:	include/linux/liveupdate.h
> +F:	include/linux/liveupdate/
> +F:	include/uapi/linux/liveupdate.h
> +F:	kernel/liveupdate/
> +
>  LLC (802.2)
>  L:	netdev@vger.kernel.org
>  S:	Odd fixes
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

