Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597ACCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A027B8E0013; Sun, 16 Nov 2025 13:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B35B8E0011; Sun, 16 Nov 2025 13:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1EF8E0013; Sun, 16 Nov 2025 13:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 760778E0011
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:25:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17294C0A1D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:25:57 +0000 (UTC)
X-FDA: 84117299154.16.6B102E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 73E761C0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:25:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMIwuVuH;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763317555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ueL4w+qxC3R9Yrwrpb+mtJ7z+O2xfL1BscnHq1oCTk=;
	b=slQrLY1lnMTUAAguwLPF4/02gu6HIglFNN7mxAZOBFiytkay1iNKT6ZT62MGVXNkUK0q8V
	XTxqvPkYmxTciqtTv432OaWHTtcXEQ7m/OEHOBAT2ZWEpVfMqTjyAzHLaTbdN8VWXRxRKp
	xdSNJ80bXn7sgJhpW1z2SNb2QLIhb0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763317555; a=rsa-sha256;
	cv=none;
	b=bNgN1S7W6UfjFTKIc5KO51MDHTy/KvulJ7gLthes9KgG/hd1kr3YzwmLQQP6gmYozFdCJv
	s7Gt/qUmSlGk9l1wVFfkjYq6OwZ626GbKiYMz2sTMifA+V6rv0yC/mFkGNUGRcMurgLWwG
	BDh1lvhMjJJz3Kp/VZDr94gXrcHFaCQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMIwuVuH;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 056774077C;
	Sun, 16 Nov 2025 18:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08E0C116D0;
	Sun, 16 Nov 2025 18:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763317553;
	bh=+H9kC5zD7GOV9MudaE3ortYpw/BxE5AQe7gf6a8981M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sMIwuVuHQZ63VF+zCAo9oX2pCDZyMCYP5Wg8cjEsP3YQB9I0BpreQ9L/ablGpeUME
	 oCs9zr+bX1CKb5waMw6erNYZisB571UuMGrkKaBNYOUMk6gCsaWyqrfsZ0hyGUqbfu
	 ChqUNCDi1QwEeRwhkaCjZzXrvMknXrk6keOxrsSGvu4jHDYCbmMoFgOaz5ojW3ny5g
	 9rs0tggzMGM/Af2Y6UssYxHC4mq76M+pvKIUlV01l4H3Qwm2iNKqxRclRl6d7KvIaM
	 412Cjl2c8GJh/Gk8fEJh8XDHufdpHrLLofuGMQYXKBdLYLkz9loxs7BS19SxE6zL6o
	 QKTJauwTCUg4Q==
Date: Sun, 16 Nov 2025 20:25:29 +0200
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
Subject: Re: [PATCH v6 07/20] liveupdate: luo_session: Add ioctls for file
 preservation
Message-ID: <aRoXGYC4GeAoNKPl@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-8-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E761C0002
X-Stat-Signature: 3ux6dns19h6d7fenwguy7k118wckk4ea
X-HE-Tag: 1763317555-516377
X-HE-Meta: U2FsdGVkX18qxIOxsdBNw8puCVlQYCk242D0hAg/xGFsZN5w2e6k0MmbdrjULNotpYVB/RnUUppYgf/1E0WpGcNACyrLc2X0ubgTsJc9/X3m7nkOoONz5bqm08AVWKs61G8SypgebOckfjRfLRr6vPbJ59gXDOykGM6oK6NzfJlGXnb8B1BFLLPegtRW3sfFmSLQ6uP5uNbwb608FBY/P0Eury8+Aq/z3trmHt6bDCTOtIb5JzKBnc43Ae43VhmHHzKzYU6mnxi++WxxMq9RJJZcbZiHUu8dtqdUs2GG8Bsl1VoQQMXrG33lu4AAwCR13CwcrijQPVtNCfgSZhy04U7K6gazIBxLs1eKhrqC5RL0K5vzOzW2wbXcV7nGMzSMR8RK9POzZyGOOHkibmISkbUSCCG2IAtbKiR7iKsZGXOVIRyBw0XHbA18luH7TkHEu78/QWaf3/ieF0crSq7P3tn5JHRyWH5vzET/pB51uYN5lxd2neSMHMmJq/xgk+3V0COoWusyEjq0Ra+etnf4bpcNTXrjhvW990DFcGB+i1pSlYF3qzd3KD7FeRinqY3th5yUoQAbj1I5/iJzzla3sXaLT2GRkm5bP4dSfJgFLt79KcABtQKmh19iMLqqe2d1UAP/Fa58JWYdICR9Ttv63IVvurVnvYsvaI9DWsDhh666JC4/Ch/kvcXNKHkOIDZTLZ3PHlyu2Eh4pZ+TyZGhIfUn4YU+Ygr603ApHu8mOboFsgKd+CWLQPgA9GBBpyMpD5JMAfQXsuDr9+bmFFbmRDzw21KsylT/MtdoG6qiMWr7jWfl9DohWbmweWaaMNNyLlsiqSrFM/WCkkNS5gNTIvgwCuELvn9cUnDeLp7YhQbHVs4zrW+JDPo5cLSLfaN6WXnZaph5peWYvrRrdQ9oSdhWQx1Tibmj3LPHxhBE8FWe/0X202KZzY8VsY+QUe9nY4qxbjO+oUBtxzCM+zO
 WDvpzswD
 SRf2f3Tyc9aPuHjAuETHN19SFXrkXDyNYm3MCUcrhFtkZjtFwYLF5LXOLgeFpYfgmsPUKB44SveTZKr4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:53PM -0500, Pasha Tatashin wrote:
> Introducing the userspace interface and internal logic required to
> manage the lifecycle of file descriptors within a session. Previously, a
> session was merely a container; this change makes it a functional
> management unit.
> 
> The following capabilities are added:
> 
> A new set of ioctl commands are added, which operate on the file
> descriptor returned by CREATE_SESSION. This allows userspace to:
> - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
>   to be preserved across the live update.
> - LIVEUPDATE_SESSION_RETRIEVE_FD: Retrieve a preserved file in the
>   new kernel using its unique token.
> - LIVEUPDATE_SESSION_FINISH: finish session
> 
> The session's .release handler is enhanced to be state-aware. When a
> session's file descriptor is closed, it correctly unpreserves
> the session based on its current state before freeing all
> associated file resources.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/uapi/linux/liveupdate.h | 103 ++++++++++++++++++
>  kernel/liveupdate/luo_session.c | 187 +++++++++++++++++++++++++++++++-
>  2 files changed, 286 insertions(+), 4 deletions(-)

...

>  static int luo_session_release(struct inode *inodep, struct file *filep)
>  {
>  	struct luo_session *session = filep->private_data;
>  	struct luo_session_header *sh;
> +	int err = 0;
>  
>  	/* If retrieved is set, it means this session is from incoming list */
> -	if (session->retrieved)
> +	if (session->retrieved) {
>  		sh = &luo_session_global.incoming;
> -	else
> +
> +		err = luo_session_finish_one(session);
> +		if (err) {
> +			pr_warn("Unable to finish session [%s] on release\n",
> +				session->name);

			return err;

and then else can go away here and luo_session_remove() and
luo_session_free() can be moved outside if (session->retrieved).

> +		} else {
> +			luo_session_remove(sh, session);
> +			luo_session_free(session);
> +		}
> +
> +	} else {
>  		sh = &luo_session_global.outgoing;
>  
> -	luo_session_remove(sh, session);
> -	luo_session_free(session);
> +		scoped_guard(mutex, &session->mutex)
> +			luo_file_unpreserve_files(session);
> +		luo_session_remove(sh, session);
> +		luo_session_free(session);
> +	}
> +
> +	return err;
> +}

-- 
Sincerely yours,
Mike.

