Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4870ECFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A768C6B000C; Mon, 24 Nov 2025 00:31:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A269E6B002A; Mon, 24 Nov 2025 00:31:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915E36B002B; Mon, 24 Nov 2025 00:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCA56B000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:31:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEFF7140236
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:31:16 +0000 (UTC)
X-FDA: 84144377352.03.B7AD473
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CCA2120005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:31:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N73ygbiK;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763962275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nsfloe6zyOU34DpXESBNlpvo8GR0vwQ2XkRL9zK9hQ=;
	b=GfPBXuxXvrpCkMm/S59dqn1tJdAu093LsmsKkX++Xlj4wn7y2IfKJMSepwXp/wVF9kA4cs
	+FeZzqFKmsTxGFHlcIKHWBxS5P3cBI7zl4y/aKqklhAwJiRnC4mU1q/LtoO01ChfMHfZ+K
	NVN1qGRIr9khgBJkH7Gtoj9ed+AF8MM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N73ygbiK;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763962275; a=rsa-sha256;
	cv=none;
	b=cL7mt6rbsjEIduIUSasSdDpsMWBaw5pdHJVVphhoaJ28pHGOfb/TtLDPSiyjVBsVlcOKjv
	3SIpS75hai+5xRKVpj4yapIlbaaeJvME+esiT3bq5svwLcoNGaARpdp9WZU2efDtpVG4cf
	1+D33CEKpBobRmmC5j6APC68jConyog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A675960160;
	Mon, 24 Nov 2025 05:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4672EC4CEF1;
	Mon, 24 Nov 2025 05:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763962274;
	bh=RWeJY9pJHBZ5U4aPZuJw/0Z5j5nXGO9gJXgSoHnl1Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N73ygbiKs2BhPqYtlO5jZRWbVaKbo+e+4T+IqZEHKKEzdE9g2qMn3x8qjg/NYZdpK
	 RwOVa+22eRllg+5Y4ES4PXmjeHKwgi9j+fXiPfzAa7Temd8Vgh8CHpgEGbyuX990Sj
	 HzaB7m9tXVgfRD+z9Bvkf7uqmUod3QhA/SL/AKuRI13cwf5NKDEJwQfDnQnE2+6MgP
	 hPK2YB2ddPSiJiIDxLCU3yxjj4dNFLk2qGt/HqPcnPBgN/T01TVf7wqkN0GaozFfJ+
	 npHKpCkjKuRjZS/cCD9GnWqf1KyMu2kc1yy5pVZkokJh6FkUyQVtDHVtOOXT32Q7eR
	 4q7LnRP9e7lOg==
Date: Mon, 24 Nov 2025 07:30:49 +0200
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
Subject: Re: [PATCH v7 18/22] selftests/liveupdate: Add kexec test for
 multiple and empty sessions
Message-ID: <aSPtiYSV9vkYvlBD@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-19-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-19-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 5CCA2120005
X-Stat-Signature: u4mmkmx71fm536oazojbgep6wztzn95j
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763962275-540981
X-HE-Meta: U2FsdGVkX1+7LGsGIoHNrhos27Jp8MXWMxBFI39gqzUIap47p9DO8F+64XQFYkXswYfZg+vkonPZW9EscsgTndtanJ8KpEhYncq626N6xrJi1wH93+2Ki6FNqXjlrv+R0Lj7BxStMgM7KVoYQli9PbWHmjQwWf1VJ1aNlpfcKFkEXQZZ7QEbFu+/8tWsJY96GlPaHoGsevUogsMUu1DNI3p3Cx8tjqyEQfzionwxKp+xr0gi2/oVNPRol2pVMXiKeOFEX8haXzr6/FIJUqQ5nVXhhaYjgQl/GQGB8pabkvO8f7IJJAZLOGHtJj/gpjNKNYeTJkZyIR8VDdpe2HVDoYXQ/u1Hyg8YCs7zHvdPXWaeyUyMKPs6T4A7fiHw5I47tUnujmdHqtvTF1N2RSGs1oCUvxAOU7rfLuqlLHpwmflwiWFdBQD8X/Wi954BlJ6Q0oJK4iSnyTg4MjP3kuszUZrq71exZlbj5QxyHAxMbegrwxPsYWmD1KbhsCdTPV+8OOl2tcRnrgjYmZPl/INUPzMfkUV+1GsELjorosGPWePpR+DdGAJeShlvCpCLv/jWPQkFxFMK5JlcoiiNw7FxjXAL17AJQnMLfGnvCYR86ggA1iDfWD9LdI/CkbDhdXO14FouLOX4hploItAHyCnt1edyL4NuCuNt/k9Z01BmTbma1Whq9SWAAf+u55UO0TTR83zgt0nV0qdID2jM/XcSS4Ox3Ik8N35O/QM3UMK2TuqdLW5ZmF/Sjst87nyHjsUK1Fq6ZXuIjx+fGC8q7DgaXQIFwbw7gZmCf7fisTyrr60c7pZpzSQNe+yKnmL9+6aFaK+On5/CkHuO6+ag6jUgdaNs98K6KxXw/AUl1hweK533KYWg4d0WaR6TjTgsr4bmnw7sTbaCB+NVzRcRz1Nmt/SC+Arz1P2qFttkol+P7MRZkoGHhrQoojObQZSaqg7C9F2upJt92WjRweFiTdy
 s89lnPsw
 CPXNoTYL0o1Fi4ziwefQvlS1/md/F/HcMm4BFf7zzblPDawLRdYi7v5pu5MJxzvJeThSQe4RGFwYpzNM56vNyh6MHm05FWVj+REMFkU8oHq7ruIcDi3Yi+leNgAnjM7QSOn2xYxBsn3cJ8rCndZ/L3UrEJ1hjGoO+GkNt9v2908qG4wfBuCLUGNelNF3ZAAht+pFQuTISmRnHNDopWRXL9FbRKYJMS6FUUlfDBlm4gbKxZclUkeFnhkRxFfSbCI+uYtifqjSsvzTGl4lwAOurYOfEXD4Ko4vVJUAx3XmGCB+9ygt3F6HE0agI7gdtuRptV9G1ZtrmzasEw0Wg1uTDo0qG8Hsk/DKinkJaOji2/oQjmwoGJdCvDeU76WsWSBxhG5jdwwHrPSVqFT6c6Esn22momg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:45PM -0500, Pasha Tatashin wrote:
> Introduce a new kexec-based selftest, luo_kexec_multi_session, to
> validate the end-to-end lifecycle of a more complex LUO scenario.
> 
> While the existing luo_kexec_simple test covers the basic end-to-end
> lifecycle, it is limited to a single session with one preserved file.
> This new test significantly expands coverage by verifying LUO's ability
> to handle a mixed workload involving multiple sessions, some of which
> are intentionally empty. This ensures that the LUO core correctly
> preserves and restores the state of all session types across a reboot.
> 
> The test validates the following sequence:
> 
> Stage 1 (Pre-kexec):
> 
>   - Creates two empty test sessions (multi-test-empty-1,
>     multi-test-empty-2).
>   - Creates a session with one preserved memfd (multi-test-files-1).
>   - Creates another session with two preserved memfds
>     (multi-test-files-2), each containing unique data.
>   - Creates a state-tracking session to manage the transition to
>     Stage 2.
>   - Executes a kexec reboot via the helper script.
> 
> Stage 2 (Post-kexec):
> 
>   - Retrieves the state-tracking session to confirm it is in the
>     post-reboot stage.
>   - Retrieves all four test sessions (both the empty and non-empty
>     ones).
>   - For the non-empty sessions, restores the preserved memfds and
>     verifies their contents match the original data patterns.
>   - Finalizes all test sessions and the state session to ensure a clean
>     teardown and that all associated kernel resources are correctly
>     released.
> 
> This test provides greater confidence in the robustness of the LUO
> framework by validating its behavior in a more realistic, multi-faceted
> scenario.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/liveupdate/Makefile   |   1 +
>  .../selftests/liveupdate/luo_multi_session.c  | 162 ++++++++++++++++++
>  2 files changed, 163 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c

-- 
Sincerely yours,
Mike.

