Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5511ACE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57AA8E0023; Fri, 14 Nov 2025 11:32:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07F08E0005; Fri, 14 Nov 2025 11:32:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7418E0023; Fri, 14 Nov 2025 11:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B10D8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:32:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48FCAB9663
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:58 +0000 (UTC)
X-FDA: 84109756836.14.65054F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A4B6A80013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFeoJ6AE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763137976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQwUHs9mWvyDTTdNsueei2ITz9BbdtS8MZ3avVTDba0=;
	b=wxslXP48/9lhMpWYtuHQuoClfmhqP8azL6w6QssXIX2qWuz2hX7up9n4wqcA9wFquyOs0e
	bGREutZV20Bz+MuGupfxz3bQp6xs/PJfDkJ0OmELkDxI9wiCJTyipjIoZb9fnYkzQxK1mW
	43wqrL7jeDzvboPb7LnQ0kk6HZw2Qv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763137976; a=rsa-sha256;
	cv=none;
	b=aEoZgTtqa9lTBqUWG+VtodgKDka6Tm7y8k04PM6nGzZbZ1t5KtPJjLgB/jc7EFb7S7owvH
	Jn7LvoQOVxmX4c8AMQLLfnT72EfiTDBx4+NJNbMq79oancRL5KmUFIWunSFJG5DX4ToAOv
	dOVXMpZk+49M9hM0Xa+jdWe59COCZKM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFeoJ6AE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 384276016F;
	Fri, 14 Nov 2025 16:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB46C4CEF1;
	Fri, 14 Nov 2025 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137975;
	bh=fy9goWnm4WyDrFh6uM2Y7bCHkbvkrMLy5j0RbsMDiTQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VFeoJ6AE+ab565fJGL0NyGcL684TvXpyQDHI0jD/X4tc9MmYPcp8rhjUchr38DYrC
	 MlI2XwZfDQ+P7jMolPtXjOxmTwQQY8I7nvHAdffhTA2EMP65mqswANw4qJDeGRTyoh
	 dOMoEMNKxP24ISiCp3Sq0qKO+N9hkDgNU3n0l3DEeyOL0Cb/ydyjHxyqzPr1MeIO3b
	 QtG8Y8+hSi6VLjaDZu0KmoJb9ZhqJuk59kasYggKZrt+NI4Zxw6CeNUEGhUQg54ETu
	 2iIQHOl7RFQP+20PonMZKaD0vpTepVwssKwzQmTalxR6HsH1lHzEbccJJ+YiVmKE5X
	 RFrxGbK7LM1kw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 03/13] kho: Preserve FDT folio only once during
 initialization
In-Reply-To: <20251114155358.2884014-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:48 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-4-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:32:52 +0100
Message-ID: <mafs01pm08thn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 7iiih48w1fqsy7qycpehddxp4c9rh377
X-Rspam-User: 
X-Rspamd-Queue-Id: A4B6A80013
X-Rspamd-Server: rspam10
X-HE-Tag: 1763137976-707044
X-HE-Meta: U2FsdGVkX189rZZxpbH7O3fTeqb2NJMeva71WVR6KpHz9wxpot909JmyJwHmfcmdSgy/x7qTMkoupy8y1SN+i1G8/D9WjbI3msTFShHWniqnLi1NnqHvMMAxBvmr42ogq9QSXyIrfOE1E2uv1fX9BgMXlvJ2pol955dYGzA9TCcdcUuIgKN+/0PshWxKSusavGfK5ivhRtw8UdQ8RleYkDs/8hs3Ab+Ch2oGiW89MxTWq0kT1v5FVbxROtuul5t+L475RijbWZA6lAzdaEc+4ku1qu0EBLBlgQfxMCqm9b3JA79yFTs8Aet/WTeMp1JZmV4UnzfvyHQnyhYO6LTcj4E76+p6IB9KqFdareXNZ53kvvSHZ4mP/JC471X0WVsU92axksPPHvJjjk7RURY+hctac7i4IY3Kva4rn+IUDu1n2Zaw6jRe7HgnnplrXYPXt4QYfayf+tV+tihx/vzW1oAUxDt9ERLURb7F1xmlsQP8w8YSmqw8wVXyHsxo64r+NPrAnWjcfh4c0iRKozkyZZnU91JdMb0J80TKYtI2qhFnQwGapSBYAZr1K2hqr+ZozKCeBrMbHuSrK9clPFm/u7ulyen3lMGUrqO4jCAFeFyUK5l3XlCAxRMzZglfzIEQGr+i28TEpiwBGnOxzHWsX252NUMQ235Ro6x4J8LzQwW00wQIo4YwxcBkfE94h2hr1ffr76YKzQbAAcwDAXLtMA3ci5rAeNG0KNXGGQpE5OJaXNIQ7dUu9yPIR7g7yo6XMlfJtRLkLsrQaHNZJ1OhZihVVoyBkd9V8JJreKAABvWLNhIXOS7ilCaNNSqeSOzrwGK2b1FhiOvSiKOJTuL7+6LaIH+mRrnt9F+03/JFxTSnBBHglMse7Ho7P9CHm6hDVMaHhhOBD5iEcIk2e2aohNm/VIJ9ujx2zyeequJ5QVL74ztv1cz4JEhG7kwUwJVBnmBj8Q9uyNAZbk6cKxY
 hRBzh+SY
 4Y/gs2x670kdMbM5qiOWVJDn9qPVj4lLuUbzFHMfhkkBKigLqfygWqngM3bHj/GYzdqGzF+F9/7+OVRZg9Y9ymJsa03m9HVzZII7QyoUAoMWFKfSqdVYAK180dzzdM/zOuLMI9yeFXvmePtVFYB45i15q/Tw61Ve4cE/XtuLLNiE+qN1zlO1LkXgkLGer1Oidz6/W1q+J//oR8SlNIAvhDWJHxVJPM8ZZ+J23PdBDcCYNyHtkaYrj7S0xpuFhkgWaCyXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, the FDT folio is preserved inside __kho_finalize(). If the
> user performs multiple finalize/abort cycles, kho_preserve_folio() is
> called repeatedly for the same FDT folio.
>
> Since the FDT folio is allocated once during kho_init(), it should be
> marked for preservation at the same time. Move the preservation call to
> kho_init() to align the preservation state with the object's lifecycle
> and simplify the finalize path.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

