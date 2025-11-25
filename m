Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7AB8D0EE14
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EE86B00AE; Tue, 25 Nov 2025 13:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9996B00B0; Tue, 25 Nov 2025 13:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCAF6B00B1; Tue, 25 Nov 2025 13:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D68DA6B00AE
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:54:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79DFA58A7C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:54:06 +0000 (UTC)
X-FDA: 84150029292.04.6E4FC1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBB5FC0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:54:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8QqTVwO;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpZNFtsXT08NwdUxuN/PGLvp5rh3lkUf0jQ/YbkovyA=;
	b=g/3PSKEmdiYBgn+lOxJBoI6c8wzFzo+6tV4zdLQSNRgHMHwTKbt1X7jkYzKQ4AkS55Z+OC
	vKd+FR3gq+Y/MP4sRa3EDYgI0S/ooBvXm7VSJb9Idkbb8E3BNyT/rAMu5QObdGKhmuy7XZ
	M2/uBzpNN+RIkZIe9rIsYChtOiEFGUs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8QqTVwO;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096844; a=rsa-sha256;
	cv=none;
	b=UWL8qOE4/wnZW+SE9xp+/GLv6XFe6G/fSPm30VboRlskv7GaXDxpBcPJ0Co//t6HkeiCoq
	dEpi9plUwOukPK4uhodWI3O5vn52O5GmmgrF3ix+18SBZGg+rhNc/cCWCnQhU32qySyCQK
	dyQqE9H0ACc+LrIx6PLseAbYt1lLPuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0EF66011F;
	Tue, 25 Nov 2025 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B3BC4CEF1;
	Tue, 25 Nov 2025 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764096843;
	bh=tj4Hk2zVRIwQCQP87xu4QTgjORr+xv2c2i4X2tAStZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H8QqTVwO+aRD63VeZ+7GlQZSXgdn0PXGxn5Hccx6EFhuUK4/IY7RA8zubinfNvfhG
	 ohdpylQnNuvcrKhq3XKX63n7Rkf3tA4+JYyXIypNkm6s/c1bjka/WazLOex514dALB
	 271Er0PoDjcGo2IGKc+1//GwxeZobK2FyBqBCrM+uX7CWaSPKELthJcEBDRn/L3/fB
	 9ZyklW1576lnBqIsb5nkaTc0AATx2Qn1zpm/soahOCU7j3fueeVCVLLSYU8815MK/7
	 BcgVdvhW39fBJc0JzVyOJyl1sm0e66Gx71YE8VunUW/1DLkdz3N8U1Ia+NUUG+Mr7N
	 4GBt6dlbi3Jww==
Date: Tue, 25 Nov 2025 20:53:42 +0200
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
Subject: Re: [PATCH v8 02/18] liveupdate: luo_core: integrate with KHO
Message-ID: <aSX7Nm_yrXHeejQU@kernel.org>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
 <20251125165850.3389713-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125165850.3389713-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CBB5FC0008
X-Stat-Signature: r6rs6tn8izf6m4keqb16bc889b3p3fmw
X-Rspam-User: 
X-HE-Tag: 1764096844-377110
X-HE-Meta: U2FsdGVkX1+BZF3P8EhOQLdmNrW16Uu1XJM99+Vk64o5bFi8cUakc+ZPStt6VNoRUVHG/JeaXnOg0RB37h2lTzpYe6oVB4n9siHvbspVhoCUSfXvi5XHVP/IV4x5YoOykUptVgzU5DQVTJv3O99NLQcAtX/Mr7FfehVtR6E+Ytbhky/hAPCrK0Gq2IhGCcUADs/JixT+vDTq9/1AE/YHG2UEzkQ8ykav0GxSLh8qYHYuwv7AJypR1/bpSskU1qPTeJsyphua0Tg+Mv2kEwuV5vCPImWrxh9DrPOzmW6y2KKE2dvhTbPGXI1Yzb6S9yfah1zjxdp4SlTWvTcI6Y2xIwIdBeGvlQt1GpJTdKJk9QNeYGfhMgDg1M04ccwOeRbYsDAZlGkTF1LJN/qNQQNVCkDzK6r+KeXaikAdCVOdoWiMASK9fWOyeWG7ORDbBa8rgdyH3yg9Zj7P2ss0pRXLdZAn4zgfOfxvk8Krhd773n2GuzS55qj2FtnYUSXy2jcI8CrLly/zM45l1f4WyK0AkPQPn4MDM4Bck9EAiVDoW9g4f9wjROaBtqtigNKyzqouAe7DUW0ahqbBqej0nFwY+V0hg0FIBFUeczXruCVtay0D6oaOxyOclwyUvVANwZH5G8nUM6pVADrDPPqwi91mmiJDcLgXvsAlrYOA6RM+CMua6suacGRqqUCLI2cveTAIlaJEzWMKpV4xvq10t07yfP2uUaghB9FnbBrvkVg0upnAa7gLe8HPmtJAqUgDBKyYMqAVxLuG49EeSdclAkYDtVeGBPIeWMGZhvAw2sV3L34/QlYQei4Uy4b4OZXrOcZAwklOW5ZLXQC53YmApthTHXx0e/FMX3NHGFjKx13BiQwIOSkiUwX9CoRz/6T3f6zjNXNkq3kFN3Ney+26Tf9ekpAuVkyLLqmnfRJXSP2SGZYzJ0q01CikhzHynSrz6ZcgeHcCd30bHhFcCYTpL5p
 ElAr49Bz
 5LtU2RqJhVMCf66CunqazGfRs31g/7/SADfF/Xjhvj1fKLn+cX4fiDYLGlkJjcGZkEFxwC6dgrG9UgHf5DySyaI21RfJv/KyyVo/1d6MKBSQ6D6U5xYVaSapmCLNbeLriexrv6ZjbB1rHNGCy63Q4cltgbaZUCJ3fuPi1zMsCp3v5Me/oDvB4CTqulJhHQMt8ednlUfI5W2UdO2B7U/5pRuVjiJZfGcyPtpr6EUXpssbdbNcnJC6QwK9ZGgRaokao9gunr3D/urK5X5/03jXb2GBxObj/DQPWigpbM1SUxPy8LBNzwr8HBv9rwmQ79j3RpzNiRsS97XZbWoUQtCjLZcS8lIQLE+yA3aXowX6ozfeG1h+enQfnO187EebzjxdwEKWf6FyBww/8Aw5+oeOru8VAkSz0rTT0ppCq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:58:32AM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> This patch implements the lifecycle integration with KHO:
> 
> 1. Incoming State: During early boot (`early_initcall`), LUO checks if
>    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
>    "luo-v1" compatibility string, and reads the `liveupdate-number` to
>    track the update count.
> 
> 2. Outgoing State: During late initialization (`late_initcall`), LUO
>    allocates a new FDT for the next kernel, populates it with the basic
>    header (compatible string and incremented update number), and
>    registers it with KHO (`kho_add_subtree`).
> 
> 3. Finalization: The `liveupdate_reboot()` notifier is updated to invoke
>    `kho_finalize()`. This ensures that all memory segments marked for
>    preservation are properly serialized before the kexec jump.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kho/abi/luo.h      |  58 ++++++++++++
>  kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
>  kernel/liveupdate/luo_internal.h |  22 +++++
>  3 files changed, 233 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/kho/abi/luo.h
>  create mode 100644 kernel/liveupdate/luo_internal.h

-- 
Sincerely yours,
Mike.

