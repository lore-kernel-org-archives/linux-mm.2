Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EABBCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 16:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2C88E0174; Sun, 26 Oct 2025 12:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA9F8E0150; Sun, 26 Oct 2025 12:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7978E0174; Sun, 26 Oct 2025 12:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A70E8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:47:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0997128F83
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:47:09 +0000 (UTC)
X-FDA: 84040845378.10.0ECD216
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3464080003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:47:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lwK/j3jk";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761497228; a=rsa-sha256;
	cv=none;
	b=BUwYkZzMRI+E3KSr/V93wzC+JrhfVMw9Q37yvJGXuOukbYQ3L6ex9dBDwy99rJ135bg8kH
	stR6QokEmcXf8YH8IVHAks6ZM0DsFPOJRq2+7HNErhlPox0AUY+ecPIvPLJv+rvb69jORW
	f/msp/yddgEzZVQhs0BZxfdFjQPQ56s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lwK/j3jk";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761497228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQUwPvAkHJ2nZzLT1uTkFxreINBWmtgUebt9cW1T8K0=;
	b=hZuU34Q1hBq5BnXOS19IuzQlW3d32Y2T3zWd6h37wycJsv74vnoBkxa8pkOEL+UMcVcn+F
	csHOn9K9Qi1rntkVRlcY4OKCyymrLTaF1/EGQ7kyLDFC6aumSeTe7YuNA5ZsnrAUUlwppg
	Up7Qz6DlXJwSgXu/9fRTCJyxJQ4AjHQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 800D86030A;
	Sun, 26 Oct 2025 16:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D4BC4CEE7;
	Sun, 26 Oct 2025 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761497227;
	bh=TQUwPvAkHJ2nZzLT1uTkFxreINBWmtgUebt9cW1T8K0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lwK/j3jk9nAj/uSS0svWYrkZXKa5Bi4EumIBenDd8s6o2tUouNTzmheD3OznDubIw
	 rkx+Uu50J/RVI9wHGr9Ybi5zvZddSKIXWHORmdnNiS9HaLQx5xYUI2OWy6ZE+R8D0l
	 SMe/Sy1ozlZp2lGgHsU2kZImFFbqZgiAqvIAd0p4=
Date: Sun, 26 Oct 2025 09:47:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, brauner@kernel.org,
 corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 7/8] liveupdate: kho: move kho debugfs directory to
 liveupdate
Message-Id: <20251026094705.c62e10042c0e4e8b093995be@linux-foundation.org>
In-Reply-To: <aP5NLJoSfKTVnsQV@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
	<20251024161002.747372-8-pasha.tatashin@soleen.com>
	<aP5NLJoSfKTVnsQV@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hjggcp8d3h5x7wfdeb8ifuokko51mn4t
X-Rspamd-Queue-Id: 3464080003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761497228-85497
X-HE-Meta: U2FsdGVkX19TRtOY56RQLjeriTvRtXiq7E7f7S8PgnyqsOxyuxpl8naVAildnBAY+S4XTrw8SSWbAVEmVWqTvTGuCAe7o0Q18mhDvBWhnXIZFrSyIJ0ZN9NUZxWRSXWh/lKMCHm5crHb8uqINa1XZrw1b/LQjo7aYGx2QS4PL/ugBXLIS8ZTC49yr9zmJ6RTP9XeaeWA4osK8EWZYL50Ht8rU6JtNBYvElmni5fPEgNGaSqQWYJdojBgLSgGxJz5XzTQAlm+CckOKvP8Jm3B7hxAYYZO11ug2v+sa3orHPAYm99yaZ8c2pjtzstmGgirvEznWncBeNZ6MuA3SCXYtmcqvZJwTvHIBFzpfgOg8ubVnaVaHLY0e5S4UYPBnzt/pqHAaVTUVTYSXHfdjslA0DdBTjFuu8m2oOOktDc/vaR96u5kSkjbm2j65O2fsyHnUhSZcKa+ndGimus9JZ5DPQ2shVS2UpIdiaSBGfedpzuaw8KlteVZI76jbijG450JkfFtsWt+kLgPFtOArwkaS/JIxtm6rKYQpplT08Piom5nEgyI7oUCLYbM25fSkxVN5TgVyuUxaoJ3Vtzl9AWVhJ1qDESE7ZYzinRgwtQLUQTl8F2Dp3hlf0QZqwAQZiWwDocz65GYPWt7DG/SdzLPXSdmKu72UWYBgI+rTZDmNiLvwUvemTBnXqjd7WfEHtFXa0kVRd1c68HpEoNM58xAkOniTjGBpbkx5GuRR6LjlBet7HuYtv0gbizLQkHJfRqJpotMKL2nWDPyKCDB9afzdnPpRM+KFO24DPTmOaOIicAFEq01mG1tyCNZinfBajEAb+jfq8XOvPxinGx5d3hjdo+BoL6n7jTsJ95snOZfeUzhvhIM1axDknfBVRDMoBqDDDtxmt8hkTcET4qj5lmQ4fimsz5SFjOySviLLWIffCU86j2jJAsVm52ta2ZP92ng4HMz53WQVpDKOQTys3X
 Sm6zrxse
 aYlfojZ/40vhjRYBzk4T8y2fSyT8wUQj1cV8EnIh6XT/pKDiWrOygEUertZ97r+Ut0w8Lm+tgyhETdwpzsqhixrCaXedxMhGlAzv58LSW9U3nXTCQLSH+ZkKOwJ6K3fySYUkaQNhWKJQab9Hj4aDliJ0+2QXiaKY8ctWl27GpU10DMwdKB1e/d0M+3gZzxhPFW5x9pa1c/v75lEGOL6RHMxJ7/n+hSfJWvTfOCE2mp9Vv3AcbO5idMviyyehyKlojrYCUMagBYx2DxFBvaOt3o4lMzwl96oAlrynsCWCQAgPGz3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Oct 2025 18:32:44 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> @Andrew, please drop this patch for now.

Thanks, I dropped the v8 series.

