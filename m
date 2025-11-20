Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6897BCF8570
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93EC6B0092; Thu, 20 Nov 2025 04:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BD46B0095; Thu, 20 Nov 2025 04:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81C36B0096; Thu, 20 Nov 2025 04:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96A6A6B0092
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:21:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E8C95B35E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:21:35 +0000 (UTC)
X-FDA: 84130442550.09.FE12779
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA020C000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:21:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eu0rkwm4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630493; a=rsa-sha256;
	cv=none;
	b=lOiTlb2whviegr3dvfxmhTQk+stP/ZrxT23Q8gmAY3t68gdi3NmGjZL0YCndZZ55Ohu+Ym
	yZ0tCZ0QCtO7WIEwsjAb1pL3oWuSBblh+UTWbauXkAGy1WmFvRfIIPPslONGG18tUZ1U/d
	TKJiovZYTHG2XOFGzlRYVp3RasJv7p0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eu0rkwm4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qExihDuno7MaUro6s8FSJYa8KtjgfePenn0sjuTqV9s=;
	b=KIgQ/Kvyz/YE1yiGwsmMmscK9OYha8J2gqJHaBXIVNnNhqO5+4BMrZ5ejxrYRSuXTUMBYr
	shH5k1PM7kI4jkBAHnnC5GqXzr3NB2ec6VSsDH6ZlFDlHzczKZuOgTfSatydJBnMYX9Un0
	WsSoerwoR1jq2ArN4wStvgaW/Ql64Uw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 263446011E;
	Thu, 20 Nov 2025 09:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69759C116B1;
	Thu, 20 Nov 2025 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630492;
	bh=qExihDuno7MaUro6s8FSJYa8KtjgfePenn0sjuTqV9s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eu0rkwm4OBhsJQEJ00dt0+Lu8W7F8Xg4qqtuoQiXLuc7+DVYohnk+hBynpVP84HCo
	 6va4jxO0d2DFSzImL/zm7JxlR0CKNPehqnSq/KA27pgEZqlBnEgVkmRUzhkO6vKWsA
	 4zGwzDAiMNtewJneTXI2NcaND2UFiWBZCWdiO793ZNhKru4FzNo30AEq45vj78cSCI
	 U8Z/iDCQidE84ggxTX1yRdVvyUmgHxYRiPuWVeB6peTPUAfzzI1bTgxDkqXRV04Bj9
	 O0FibFGbf2QjoPt4zKGcP4tl8MKahPARfvWzscDk+GGESNDrjDIhszZIjM+rhvh6Fm
	 OO/SQekExeOAw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Pratyush Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Matlack <dmatlack@google.com>,  Mike
 Rapoport <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kho: free chunks using free_page() instead of kfree()
In-Reply-To: <d41ce2d1-e353-4e5b-a17f-52d888a560b4@web.de> (Markus Elfring's
	message of "Wed, 19 Nov 2025 21:06:49 +0100")
References: <20251118182218.63044-1-pratyush@kernel.org>
	<d41ce2d1-e353-4e5b-a17f-52d888a560b4@web.de>
Date: Thu, 20 Nov 2025 10:21:30 +0100
Message-ID: <mafs0qztt2h5x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AA020C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: cqnj91t9qair5pcg1kiz69mseux5g7ea
X-Rspam-User: 
X-HE-Tag: 1763630493-978955
X-HE-Meta: U2FsdGVkX19TY1NOHCQg8oNGIengjjymlyHbcjXWvY6R/RHz1TzoEvh51OUz9SGp3QL8R8QpULSMVx7P+CSV88LyDXOoryhp0leN4Abo3qN5rhw9/x1EmRy80omSojttsuhjWhHi581w31+pbb/bp3fNW3tWSuu5Cu+lbypr9bzGImUgKDZMuTdITB0Qj0QOGGRwOFZCTiNA9RAqEHGdjhedvuNCZuiPGfyzUl++ACmvXvxaC95eHUyOg6ZSngjqJj1f+Sm4s2H6kPsgN6zPtGyxOjQJytXm7YIdAurOhnbRYZMsgLT5aTld4er5Q8QC4gVnh6ZLP/vbSevMpZfbuuJ4Su8KlthbJSmqOIGam17anaB7OeolwoLKfuIMqkm2URiccmTt/2dmwhfpH+I0s9yGUPSfbyiT2RemqYjh2V66ylDrvydv/ognNnKrxbCmL6BexH6yD9YEL+JOFDhyBcGZ0JoAG8whCJUcsevcyyTIYW33slMVz9x0tH21bSKLKLK2TtIpi9gAnQq7WgUt8PG8tY/7uzy/xEkak+FjF4A3TpiaT9HBMQrlr1u+kfmiSBV6Id9deayWZ+AEnEkV/a5beStKb4FxIpr8wFckYVQbZBEOgY+Io8LpqGGMRJGzmKACxmlhjcmvteaD1CtAGn/DmfWlaan1/Ahoz7M7D81XLurdgpfRL5y3MDd730YuLyXEJer+ZQvNWt/f4KgZHalLy/sFwxQ9/W0s//1W/MGDfmuv8uFr7F4UFAqWYMdq35K9hhEB7jZuPJPiGL4rsWJEESU4KgZDIcVMbvCpvvhMM6kprixHGdSlLSSTYF04cHtCM5EMOTy77xVJxUE+wGlrf3QBLyea4evN5e8UbbLf/s32N2U2FG20c1O7vaTICAEDhWadwclfNVw0sel4MCw5pnd9XPy+y/m+/yDGE1iqiugFXocypWq2Q8tdsQYY4gxeUfnnZIfmwCbCKwL
 PLYMyNXI
 zugZSthFFSnodm/WTA/c6WxoYDc/bwmdKXoORw/QodnlKgH6ZCqWCkEXmQMjMSOqq8u/pYvBUOVNS86qaQZlfnqphFL81/rSk8qFf8QGU/8POBVnI7HSAwSm7t6hxa6VCs+Ua3Vf1izlte6aGPwelQkkygV6ndrubVR88Y/uTf6cawvjH+Y6vNrgj4uMh3U9X28cWCf0z5vbDiY+ybfRjcwoD0ZKQn2gXbFdP9NiCh8LUNNLv/BGOtzomELzcc45L4gE9espuJ8iGv+sZvyvJeZTwO4HNSfVs/ZSN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19 2025, Markus Elfring wrote:

> =E2=80=A6
>> When the commit switched to using the buddy allocator directly, it
>> missed updating kho_mem_ser_free() to use free_page() instead of
>> kfree().
>
> Would another imperative wording become helpful for an improved change de=
scription?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst?h=3Dv6.18-rc6#n94

"the commit" here refers to the commit fa759cd75bce5 ("kho: allocate
metadata directly from the buddy allocator"), not "this commit"/"this
patch". I figured that can be understood from the context and I won't
need to spell the whole thing out again.

I don't understand the technicalities of the English grammar so well,
but IIUC imperative mood is used in sentences that give a command. This
paragraph talks about a past event.

Anyway, if you have something better, happy to take suggestions.

--=20
Regards,
Pratyush Yadav

