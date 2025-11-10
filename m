Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC70CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0AA8E0006; Mon, 10 Nov 2025 08:01:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88688E0002; Mon, 10 Nov 2025 08:01:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78258E0006; Mon, 10 Nov 2025 08:01:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1D9E8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:01:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42DDEBBA9A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:01:27 +0000 (UTC)
X-FDA: 84094708614.07.E65550D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90DAF40006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:01:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WBsr08XW;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762779685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1ETRJzdOxlQKSyAz+a76VzFR/24tozVfYIYvOyIgX0=;
	b=U/rOVOTDUPHEHpjFPFqI+lqVdvwW0YQYn3qpMWUdAlDdJgp04i2SjCZdAVVi5oC3GAMmcf
	Jk4hJoBOeBtlLT8eQe7L+mJk7B+GHKg8tpBs7RdAjbsfXBrHgKM+9UIkH8rEH+f++huN+W
	VgCRHx8PRYc86T7bMADCa/Fszb/wTRA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WBsr08XW;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762779685; a=rsa-sha256;
	cv=none;
	b=I9/K9AS9Bn4+xD4gg0VTkryUqos9RtA2WzZigVepkBDd/YnBc0DZ+tviU5+EC4zfj0T0Vy
	ScL87XPMrKddxI5FQ5ZWLIuXcfwMG+GVv3c2wjcHV753yvIdEY/ABT64fyaxTHZW6hORxs
	RpHwM5Pjn9Eye8ZcHbjuaGRl/tuVBqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA5F2601A4;
	Mon, 10 Nov 2025 13:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC7FC4CEFB;
	Mon, 10 Nov 2025 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762779684;
	bh=Nty6eYvSZQwOVNMjVt6MpJ2VRDmLEsf0ItJ+R2b2b5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WBsr08XWCoMFNAwbMOQ0qNvF4Su6puJFwAVVqSGXeT6zPs3x84rtXd1S+NejmtuJx
	 xZdr6ygbytRvjLLjSuil0yB1/WF1G2479mk8z0dDg11Wyp55cwJsF7pGl0DehEuhcZ
	 WVy01lGJQu0UrlJOlsnE40nEMhyV2hN0PmRaLfMiIYzXqz837/kxUFMsbhOvrkv7iE
	 unZy1naPkELeU5A3OWaTwOd54LEYSQj6e5v0JRS4ibLAAqLFQM73hnr4rGzDzaRVCZ
	 6L8e3xlbp4/r2UWtdNwmuPzalQnsl2O8+BHfUBH3qZdlIJoyclPpp5lAfF79lgxG3M
	 MXR0rv+rTTjZA==
Date: Mon, 10 Nov 2025 15:00:59 +0200
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRHiCxoJnEGmj17q@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90DAF40006
X-Stat-Signature: 8ryqirnpf8qwm8gc1ijz3mcw9mtc9ey3
X-Rspam-User: 
X-HE-Tag: 1762779685-737583
X-HE-Meta: U2FsdGVkX1/XSc48GFESzlv3G4cKVV1fpBTHt1Su1rRDk+mhvrSl4LLB3Cp4syaT7BkOZCWwlLGC0urXKRIM2F4Q/AbU8y1BUOwn1BqMQx3iJ3NbcFKVmoXxmTR0MRMXWapvHU8qhoLmEHKq8kjVtFdCqKrcfZKhBM4pL2hjv1Ml+MECvNDuMRWCsOVpxS6Zn4L41TMWaPCCyi+6UTl7buzDDq0cS+HvSdvnHDwrWAhn5A3IZDTx68JOUT4xJhs2W67Gtr+4CoNpPATqpYccRBxVV/x3OCFe93GFwOGfJNa33ZeRMDAkhU7k1lwnf/baPG/ccUfiXKptEW+8ydfXIN9b6HpkFGEOZtErzKpuqxbD87MQBd4ojH6qExq5IBjP+yk2s/WbvguWRw96tiSPcbydhl1vFMXJ1D9IO+w94R+JV1uxxFumWXvphCvPDBUEWC9egREOwj5fTQDBIaNtt+S2l8W7S7koAEeiMoGeExA4+SEUrJWBKUcMr8EnDQFrEDG3sVdt2TB2LOhM0Z5k4up02uDSxZyRIMHpX/v5kOgTiK7u9fgPtMBKYMXeOFr+W5yGy9xl2vXCeE27naHXh1hIi4xpZv9cmLrJrk/kRHMyH7ChfyjNiRrAgiY6Sr7EAX/hX+Eh01naxc94w266BzZqPT+Pm/VrcmVfRVvRooRDwNspTIL3IKTZyDQpnpDkHanl7O9EXwERVHiWP3U6DkiPjn6V+++pbZHSz+we7HL3ntECIc4MW82neY71bGGb+21R7DrUxOGHLqilVHK0xUyXEW1JhU7CYsgJtyWuMWObMazHHeqlaJHOQKxpSZDGXAGIlMGF8dFqMfvzowTADhjFI7PMIPoCt75QCkvsa1Oz2lN5dIo+Ly1queii3YSBovdJuMLc/7d6U98w1VwBByiUFsjaX3BlgZT274ZMx2LKGZLpGXqAxB98PEsZvKrXBSgq0j+7wWCK6snXwN+
 sk6EhmOj
 ILKikpMTUL3bjSlwUOtUlYXPeaztDRos5i3Krjjv8nXCwz9mUXwZM8Vm7+cjHoNfIkv4GYY3ebrPCPJ42+V4zy58CSg+qE2sFkJ0XWGPxfhNb9R3+94LCtH2nft1ywcAz29u/GZp9c/CJOn3J1Lk/iviqS1JY2cwaDu/vvdjoLAhVTJ9va12s4khjqA8mzUSGfJXsd2Jyk1cuXGlULoKWF7GOvdnkY6M3YgarrttOTzmnNo6AtxMFjr9euYFCj2brrxvZBtWxXCND2Ccq87tBnCzrA04PUJUywEnyFxKyNNiQ4PwNyuyXybOl/34MmnO185gMsRpCzS/tdChWu7XceiGiNHiYgPXMRRdYCbF/1lDV/sx6UCbyD618lFArkwa74f1f09VWQdKE3FePXCMp2Bgc6vPc4c/tutpVTzfvHN+Og1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:00PM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> When LUO is transitioned to a "prepared" state, it tells KHO to
> finalize, so all memory segments that were added to KHO preservation
> list are getting preserved. After "Prepared" state no new segments
> can be preserved. If LUO is canceled, it also tells KHO to cancel the
> serialization, and therefore, later LUO can go back into the prepared
> state.
> 
> This patch introduces the following changes:
> - During the KHO finalization phase allocate FDT blob.
> - Populate this FDT with a LUO compatibility string ("luo-v1").
> 
> LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> logic (`luo_do_*_calls`) remains unimplemented in this patch.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---

...

> @@ -69,7 +197,22 @@ early_param("liveupdate", early_liveupdate_param);
>   */
>  int liveupdate_reboot(void)
>  {
> -	return 0;
> +	int err;
> +
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	err = kho_finalize();

kho_finalize() should be really called from kernel_kexec().

We avoided it because of the concern that memory allocations that late in
reboot could be an issue. But I looked at hibernate() and it does
allocations on reboot->hibernate path, so adding kho_finalize() as the
first step of kernel_kexec() seems fine.

And if we prioritize stateless memory tracking in KHO, it won't be a
concern at all.

> +	if (err) {
> +		pr_err("kho_finalize failed %d\n", err);
> +		/*
> +		 * kho_finalize() may return libfdt errors, to aboid passing to
> +		 * userspace unknown errors, change this to EAGAIN.
> +		 */
> +		err = -EAGAIN;
> +	}
> +
> +	return err;
>  }
>  
>  /**

-- 
Sincerely yours,
Mike.

