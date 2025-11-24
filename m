Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA306CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B226B0024; Mon, 24 Nov 2025 00:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D51B6B0029; Mon, 24 Nov 2025 00:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06036B002A; Mon, 24 Nov 2025 00:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D82CE6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:30:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57A4EB729B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:30:02 +0000 (UTC)
X-FDA: 84144374244.26.F0EA991
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3D0710000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:30:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MRnghpgd;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763962200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oP+yhzqbDj+r8aqmNkw74lkuup9E5oOvabx/V9yzpg=;
	b=tHx9p1tSTDdvDbYOBSqG2zOtLZfj5QnPyjujuGplpjHLiVpsfHS6zyyWunYp8LheCl9+HT
	fDsLUxQrju1V82PoOcssJ1gFr4DqcS5vQHnBT4JESS1a8eEfo93v52kVDBrrNJuaOj7foB
	x58FdD9EiXc209YKHh/CxD+zrH5tIbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763962200; a=rsa-sha256;
	cv=none;
	b=kmUIboJx6vQmA2ZIo90yLCY8ipoZbXAZ+ZbZ1xcCehvmpC2gChE+xH/Ot+TqulxgaBgSRK
	NSwB/teG8BFOi8aYq2pdXvBgT0vCytfcIwDeBzPeKH6rR96KVg+voeFnthL2rhR7B1FBrM
	x1zXY78wTPJpHnUbwzfsh6+Q0QK0kN8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MRnghpgd;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B208760135;
	Mon, 24 Nov 2025 05:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0F4C4CEF1;
	Mon, 24 Nov 2025 05:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763962199;
	bh=avcnQohM/OC7Wf4uBeH1QDfwgtHGDe/RN/kIl6nBXVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRnghpgd13pRJdYK6+YcIVwuhCJU32S6SQktdN6Mq+ySxvLUOGgr0o8gnuO66HPK1
	 h66cNv/2EeVpqH+4atks6LnJT68kY/kLaiDptOqUUY3374opwcfNE6Odr7cOpnbB4A
	 Rc72VNiqRugdTTPVTaaseoGDWgodD4EMggXgRsIjF/yVN/7rQnDrjgdh5JHgB5SHbG
	 hn8jjeu95Jk6G7boj0DuB5csL1KP9cPJj/Wg0VZYOJbcsWes1anOGRHHkQCCphdyE7
	 BsJnsCsvlrKE7JtLYsf/8iLqNlQC0EHW+/SgxVNp0lrt8b9VT0FDr1FwoGvLLnVcWr
	 FWBqSXX7nAC1A==
Date: Mon, 24 Nov 2025 07:29:34 +0200
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
Subject: Re: [PATCH v7 17/22] selftests/liveupdate: Add kexec-based selftest
 for
Message-ID: <aSPtPuBUcVT5Rifl@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-18-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251122222351.1059049-18-pasha.tatashin@soleen.com>
X-Stat-Signature: huzstnsfjiauc3km4iara8tgzjwjnjct
X-Rspam-User: 
X-Rspamd-Queue-Id: A3D0710000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763962200-149112
X-HE-Meta: U2FsdGVkX19lXD68kcVOzQ3KzuZCGrpB/UsGy3VAUte3hSl/OeO9mnAsWwR2dVZ5djYWLnt22J+mfpVkaYb/ekX6eso6bPEPcBT96KrJ0m0+mhyqHqTDHU8pScb7VxvJ/pEg1lIItd55Y0Xuky6Fypy5+oRQc32zQQAgtAkLNW5joaLXrif4+sG+jHjBq9IJiTnMnKSbNp8jRl+fjTpD2ObJOqHwWi2+T3hMZB99/BAKrq52EJBlulaVCiFBFM8uD4ewhgPVDcokh9Qc9TOGjll0klI1Jm0rIhbVShbXoPkhMTqirIUbC2t5VMjqvn2R2RnQb1qe/0h4bjbC/M/ndH9L8RdM/EzI5RgI/zbAstdGQ4aZn5VAdhOhCkpqc+LjkqUeuWi0iNF2aZsv56QEZjNgOY14ZY/9IZF0rpcj4ZS6D/LdBHOGDeTOa4qfWrjux35wqDMyVbwSahfDQ7SaVOE+kSnQNLBj0FZVDkdkkLGH+Tag9C63ZYUK5e7ygt0YDrw+Sktug1DiDyUy3O9ugjI2cuVncnxV6uBIQ3huHZuKH7L95ZnAsnB4iaqZ/UzaYAqRCFN50ZOeBlPLLmC8gMreVg9W/21LZFXn0PeqQc2LA5maJ+GNK4OIhg14XVFmnH0SqFoiE7YVB3MZeykc3OnK/IbCFWKvVohfkU/1obQeLTGQog47nm/Yvthp87MiFnGNsuwLWDuw3rGO6ectTbvVH9+42LPxgcwSNct1pF3Nhx0SmLQXq4gAJAxHZY5VH+CqiKdGKP3HGWhdVamD4bTVsbm+13fQvofHbI9ggKDHe19kunr3jrEJChKIX0EqJNPW92yrupHVK2E0L/5ZRzXgRxtLEzKQ60eBi+bDdJouoOY8uA87H/eJZsqdhrjEEaZi/sjltWVLCgu3wfCktzM188Z/3k7f72R9vfH4Fr5BkOZtYIrvtTYiW4M2zfrSjXVpvJlfQwz8MRadZtl
 O8zKl9kf
 w3nQOKxVBRoexkeetfsorTAw97/xkAbJKX4u102Hh2wGWjSISrmhdz81rnSUBqK+rJPZS9fPVQug+gY8ZSscHzQlmfUWfjipwLM+P28c9BiKhvJg9Xxy+v7uctB+TRJv7cwuGLdhFi4ZwfrgNzBGf+6hvd2xtarVPjUzaEGGcfYDtkHvlge6XJuEV0naRMC/YW0mNrPklXBb2iuYWrArfcFtSp3NKwAgffqY/Sp/MD3Q/mhN2zIttMqXnMLA70WQh5jGMwwns+2Ue4ppuJ7L0JJ6hBKUFQGx71NAZ3C3nfg+RFvX+ynaPmcF/gda3IpesmIsDDbLVFYw6jRY/rClHCvW1ph2TCGjvLOqZa8tnxgOQc2hlJQgGvYxZkJtpXSxgsxVu93aIH51QFw45BlKTAMTliPhtBgPCcmXPEPeh/rlXt7e/Dz889HblHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:44PM -0500, Pasha Tatashin wrote:
> Subject: selftests/liveupdate: Add kexec-based selftest for

                                                         ^ for what? ;-)

> Introduce a kexec-based selftest, luo_kexec_simple, to validate the
> end-to-end lifecycle of a Live Update Orchestrator (LUO) session across
> a reboot.
> 
> While existing tests verify the uAPI in a pre-reboot context, this test
> ensures that the core functionality—preserving state via Kexec Handover
> and restoring it in a new kernel—works as expected.
> 
> The test operates in two stages, managing its state across the reboot by
> preserving a dedicated "state session" containing a memfd. This
> mechanism dogfoods the LUO feature itself for state tracking, making the
> test self-contained.
> 
> The test validates the following sequence:
> 
> Stage 1 (Pre-kexec):
>  - Creates a test session (test-session).
>  - Creates and preserves a memfd with a known data pattern into the test
>    session.
>  - Creates the state-tracking session to signal progression to Stage 2.
>  - Executes a kexec reboot via a helper script.
> 
> Stage 2 (Post-kexec):
>  - Retrieves the state-tracking session to confirm it is in the
>    post-reboot stage.
>  - Retrieves the preserved test session.
>  - Restores the memfd from the test session and verifies its contents
>    match the original data pattern written in Stage 1.
>  - Finalizes both the test and state sessions to ensure a clean
>    teardown.
> 
> The test relies on a helper script (do_kexec.sh) to perform the reboot
> and a shared utility library (luo_test_utils.c) for common LUO
> operations, keeping the main test logic clean and focused.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/liveupdate/Makefile   |   6 +
>  .../testing/selftests/liveupdate/do_kexec.sh  |  16 ++
>  .../selftests/liveupdate/luo_kexec_simple.c   |  89 ++++++
>  .../selftests/liveupdate/luo_test_utils.c     | 266 ++++++++++++++++++
>  .../selftests/liveupdate/luo_test_utils.h     |  44 +++
>  5 files changed, 421 insertions(+)
>  create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
>  create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
>  create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
>  create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h

-- 
Sincerely yours,
Mike.

