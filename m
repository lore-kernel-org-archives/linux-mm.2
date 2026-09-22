Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92239C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA626B00B3; Tue, 22 Sep 2026 00:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B4C6B00B5; Tue, 22 Sep 2026 00:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D86F6B00B6; Tue, 22 Sep 2026 00:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD896B00B3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:19:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F184A03A3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:57 +0000 (UTC)
X-FDA: 85240095234.09.0299195
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CFADD20008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccTXWVkH;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050795;
	b=FQj1AgEZO1RAP7/K3owJFKqjrxrdzz5GyUQspVJimqpwabW1rwJ4+ZzWladphMCkndZYc4
	ROwnlery70Tf4tLjwKOACf3Nl3qPqPWsvr0ARm1YsltToNc9EtM38R5A4sk0FGWB7uFokJ
	Ejv0Tn9EuTGbRJdwYkiT6knj1gpNzZw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccTXWVkH;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050795;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8Sw7e86frpTB8DGnAC8KcCkQBMEmIhrJF2hdj56sGo=;
	b=4HUKfbCE47QXfisxkYd2ZKdRMx5xHrjtfmjWjS+Hj/6Zjxv9AeC4bwzoKO33qay4FmJXsV
	sFbhLvT8tfKP3cbTLmvsPIuwiNtFQUvsZK/it7wljtpKqQmasR+BG2720GOJpT149LSCHG
	8FhLRUj43udlT6svyghGRuyW/+fRBdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21EEB40314;
	Tue, 22 Sep 2026 04:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA701F000FF;
	Tue, 22 Sep 2026 04:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050795;
	bh=H8Sw7e86frpTB8DGnAC8KcCkQBMEmIhrJF2hdj56sGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ccTXWVkHEb+h1bpy7+9f6lh1K4PvvzccB9NYyOXwkAV54BzWnMLSXLt4k5p/oKlvM
	 nTF0unkDISFj1iCut6TIrk4f84DKJKCn2dyC3glr7l2m1BUmNMeVS8AsFnKzYf+gRO
	 5yBagAwduhM+38NYbYaYIvJKeRIi11XG4+zJnDJjdAuPxMp2ek8hWZMaUKpiQARG4q
	 Cu4KMlT96Z8NvbnmzGUw1KfNaqXAnAeEDhdRMVx68BzpfKjjUffMAC8nLP6d4mOM/r
	 0ylvEv9zRb37RPaO4/kNHR99RovesLc0nvE6pT/c0O6a6AGV2zgivh0tpF3StirQYc
	 AU0ee+eJmj2NA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] kho: rename kho_scratch= commandline parameter
 to kho_bootmem=
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Arnd Bergmann" <arnd@arndb.de>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Baoquan He" <baoquan.he@linux.dev>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Alexander
 Graf" <graf@amazon.com>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Rob Herring" <robh@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Saravana
 Kannan" <saravanak@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Jonathan Corbet" <corbet@lwn.net>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, x86@kernel.org, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260922041321.233986-5-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-5-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:19:53 +0000
Message-Id: <20260922041953.CFA701F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CFADD20008
X-Rspam-User: 
X-Stat-Signature: m94twhk7pkk6bym14pt8i3551afi6rc1
X-HE-Tag: 1790050795-754463
X-HE-Meta: U2FsdGVkX18FX6xneufeSaktk6KztD6WzTRiUFbsuoZmkgp+9u0iT0Cn8xNutAIG+eIwiojf8Ex8c5NJ/Zmh2I9GZc73In10VbleNWkAC7YeaxXY4/68xQigLuPHv4qAHLEefzpBzj2wrqEUYD51mZW+6iGUH9lu8BbWqUyfkrIkXGNVjhbK+Ccmk/vGEDEuwonFITVi2PIyR8z9yFV5RB7CrgPhpcRlDtTu9ABvmJwZLArAudR3mSQ9ajdV7NRFa9fo1YpclWWH9cJqz0JFMgLzt8NxLQiOCPn6VRoROSsch32ad8yWOl9tCnbceUD5rxlZJrPFr14NQqeElU+GPiaLfUMpQ51Up+emH1IG4goASzj1lPgr7IlPPWKuGtsTZgzK9xgsNuTKyFqEOkQBvzppj76B1LJWS+ViMaM+EzEGJROd5etHeoptRHpQyom6S1wXmmYulgctRjh8Fey8oEqImqkoPWcSPSqdp/bfGF12qk7dNPaoYWlxZVaPtcEVKs4Ps7g5n7ay5AfjApHzXulGwgZPhrx7TR6IcPnU8of5xOIaCZXPf1ENjS7LGlEsyxX5uKirLagKbdCS9CHSZvJO+mCK/oUgM/O3TPXivIlu1XFON/0tVzdBovQmvvxdgNFK4xTx7DBrOUTAVPgfdL2yT13b4BKFFcdauXHpnfRKaMwoX0kKdgbVAizkydOww87HiByxuqL5OjE3A4/H4kNfAlWhX0mPRcxaaBYP0k3RVmjimr3x9LlwU8MmrTJ0jIrydS9YLCdBL2M5yqIgLX1+PwsH0IZa9YYYVEJR3hbXtQ7GPh01JMw/SH3syVgKKa7wOBJRoh6Cqm2Y+rYfQS02aH1Pj0d1KYckGdCM/ixlrgoY3tD6O7ePSV8U6hXiyimKMJtd0u5yPiuBQLegmjnwpt5Qorysj6LL3S8eV869iUalNkeVqaHl0cC1LFskRPCNhj9TubwZw3Ue79l
 YdsnHW83
 das3JVJtwSoOrNCOl96z2I+hfrzmvBWajZ9nJ7etOP7Dj35lda0h5um04bSNyusxowGlFEF0unk/t6RcySKASHMZf64us5WiyejqNXc2ugvUESVLcsltOMiHUe3smkSWyUkcpuIpgaytVVRqmV4o4KdpCR0Vd0otiyXJis2nzh5tMZmLplGLP8S20ev7uVdskO5gRJsHB2yzSiSZW/xpFOMbManSLl2T+6YJfMp9ZwHtgVtd25nZJAwzAua0/goGnABDntEKhzW2Bb19f/6xhKAeTWSo6w+FDfLqrKtv3Tz8WcZQvSZirtkV6fv+fQ8MCx51SFBOAXt9g9h2Y/Ek9HzN3M3JuQ+jl1RNpX8k3VL45uMcccHypseh4kgpeI9opkfBNGmGtyfRKlcAdki1n7Xi/SNn6M8/ojuIjkoeCv0nAVFFY1LIYnMfvgi9ZN5i2coA235jX3LSm0G7ZvDWRYZAyoG2RtJElsjC1E9ERbsi31kbA2M0LB27oJFw6IsVCnURLE6LjlkgMPjy91fXJE/Zz9eLE2cNpTP3HpBKq0RBXvpjY707DNrnK/2RSKCQjoAwR396G3DD+sAQNPHOafX3mYAb3VQz2P5c4xzG2MLHIivfW3+9Dfb37y71TU6mWAybkwNSJBgHR/HAO3T/ObjbWES4mKrlBXG2A5Tfg8EBKylUrFCbc+6VAW87nzrOltyNjlA5VXKdOWzqXqPuKI97D+IGvjZFR9idjzNuyZfaU9mjX7JY+l3J7Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> KHO now no longer uses "scratch" to describe the memory areas passed by
> previous kernel. Instead, it calls them boot memory, or bootmem in
> short. Rename the kho_scratch=3D commandline parameter to reflect this
> terminology change.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D4


