Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E08606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCUUMM3B
Received: by kanga.kvack.org (Postfix)
	id 7A9F26B00EF; Fri, 13 Nov 2026 21:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AAB6B05B0; Fri, 13 Nov 2026 21:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649536B05B1; Fri, 13 Nov 2026 21:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 431766B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:53:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 657E540355
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:53:34 +0000 (UTC)
X-FDA: 85432203948.04.DFBF6EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5FD2180003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:53:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCUUMM3B;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794624812;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMeqqTu3FFrkLBazBXeFazk5yXuX836uqQbgKeaJdEM=;
	b=Im+M7casZxeEtii2g4fZFYp5GrtFynOyy4Fg4hypNwmeq4rR8iWCKNuRopJD7qRHtOUdEE
	ZoG4Xlpv17qniWurLd9mYYHElqZUFXlL6uYQf584+ocOa8dRFDfBIea0nTJ/qft64RMx8x
	Sfyh3STJ4ulllGbOVWNj1eAsM1bN2uM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794624812;
	b=bc6CLlsrEtCh6VqpgpQyR+/9ifLBsd3E6O5qaO9RfYhEc0PSVLpNO4UHv27B5ID98kVkdq
	5iH5B94XBud/xvu3lJPdtSDlAo6tdQwCmUyrTncj9ij91EtyXXE+5y3UY9EnLSB2VcFfmY
	ILx8Y5lR4wJj0dkPavFPwMBWDb5VgcA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCUUMM3B;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DE4061126;
	Sat, 14 Nov 2026 02:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6C91F000C4;
	Sat, 14 Nov 2026 02:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794624811;
	bh=aMeqqTu3FFrkLBazBXeFazk5yXuX836uqQbgKeaJdEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gCUUMM3BE55e21K/M5raDSyCowvoIZGpPdq/OFmJpzK77BJoOkHKi01KQnTltn2qP
	 WJ6s3Xiv2XZg2df7rnO2Gxpy5dHihONjDqMOC3k1DfufrOOs8s6MqtdatpeDWX/KoM
	 FJzpEEXAZWGjbzocescNhk9yW4IeCbD0jeJsm8fE1IcXaWFLVpxuNvdmvfdYhYxvLY
	 kAcNYLJUjJl6HbmWZbCW0k/B8midBs/vvZ8ZSxyKuS8nHSn64mwPFnAvML0kNkhuQa
	 uR61i9FdXGH9Z72pXVDv8n/5JzCw8ltzxm5o2GHtoLkXgXK9Mm6DmCNXoa/G3v3ueR
	 rJHOK7YyyG4mQ==
Message-ID: <sashiko-outbox-214060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongfu Li" <lihongfu@kylinos.cn>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Shuah Khan" <shuah@kernel.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org
In-Reply-To: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
References: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 02:53:30 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5FD2180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a34n6ctzyqp4yfs5hmhgmd7shn7azcq4
X-Rspam-User: 
X-HE-Tag: 1794624812-396226
X-HE-Meta: U2FsdGVkX1/vjFIGuI7uOWe97ijj7pbx0Al0V0PyK91sUv/HkHAVDLKmXM86cs53ODoF4mC2dJeqVvnXY1gfpFxwNz0LSqZ1FiGIrEe5grplO3grMhFSW3G0dqOd4ejk/kEN9+MMFZVEBxFd4BnaIm0ybEjfnz97XruWV+fDclpitJFL46HL1WLGMG6/55bll/5N07jleJkCvlmyylWd7kxRa/YKrEJrHxBhpOu6cletIFEUUXNQ8QSQrj30bNQwGa3AR/W5rsM9Gprr9Ooc9QaNuBpTvGKR7FFyWeA2dO1e02diiypVLK2bZvOhZOEiUog+ejgzEjk+h48w6biEHhKNAnoNlQZzE3MS4nMP76FfAx5K2MiG6rtfs66d9ZEjgC+7IsPdHK8j/EBY8sRJW4G5pAL5iaiqoBuQqx832qfj6tlT74jI0kraccEf0utu5DEwmVZBVWB0NzhbVSas3aypZIiWq4sIy6bidEJiK4UKaPBcLLdqjYRY/NhD04l/Tzbx1vcjGNur4OHU0M1OABRFzpbUc5AUJylyVhrT50OHG+pmkWQotPp0vS4XLhdVAiQFgj6l6GJrGtQzf0624FH8xXqODdXHqScPPF9ngpAFGL8jz9Gdjzlmvj079yGtMDs/Mxp+aLJ7C6VFIB9FP7irT6A72e165/CjfS04WlcKxAfhbWQbxUoFoLHBN+EfeSAy8LCtickbOHkknvdUlFPBbTd7fbN4TUuNpG4XFWwhCE4W8wvjJXX+bmPpwgRFoKRaFwTZK2+JoEYc3FCzbP+sapmH5wi7KQd8ofTfiVYuCtZMxEQu2CmuFDpXTqfQaoxIXtO2UtpZz+VA8vCmO+HzYR+t2XpLvd/Qon7T7zCAPyqY3ppTgIf5AW/N5kCcZQdIJaLXimSVi7CAEPDjALOaDYEyFoZl0O8pdtGbeAAJxJO+IOV8bYz/7JWnQZEcJrP5+HjZ8pW6h6kKLiQ
 /92h9Z2K
 ca0/zfOvR7wZruCfiXSc/qQYYOBSHAhU8tHHMcDsLm39C+HPjSTx/RhDgF3APs3Ly+MlMxU9H03xLjKlDqaaQg/FMIMGiDzLLDaArg8Uf4f5BsIM19Ji8S6OH6oYm3dW8krXs1oWPFC0ij+xFfXcpo9riv4zDIWqVJwcmkHDiWAO4ECWw/d4DJmkK9lHuazJGyI29bT+HrQ13RyqllGr4fz6qPM6368glqaL6ZBQ8iN4uVc+a3977Fjc1+oqhW2AAIMH2lDc4nhO/1jS/9AuKZBSoL+PvEQ1Kg980zmjFDxkTek/F4BpxYWS6sjOGqLsKBtcBL+9Z9brqMVhV9PjvYDkHb0otIrOR+7fkgZV0aqhI5dwV5MdTMQ4lg75OLNMhfXSOmTkacqE8mkzVkIv3g9J8B+L2E1qckR8kvt6q3CGVx+yi3CTE+fXMT980SJbs0hloJJij3fG7Wf9BipjW6GJIXUM4sVrQ2+7W2IA/Lc371hLgq24uL4jw1e3XN0L+POExy92GeKL2dIpU7dwxcfhI3EP0a8ImLpezNiW970UszTHVm89W+Nsa+N/gsWlE1Fdp4fpwtSt9YrTUVSyf3+G/PYjiQVnpefOb0jHMFowTFiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/mm: missing Fixes trailer for fclose(NULL) fix in
  is_vmflag_set()
--

commit 38a7fefcf9bd0b1ed77197eeaab78f5845d74dfd
Author: Hongfu Li <lihongfu@kylinos.cn>

> selftests/mm: mlock2-tests: fix fclose(NULL) in is_vmflag_set()
>
> is_vmflag_set() jumps to the shared 'out' label when
> seek_to_smaps_entry() fails. smaps is NULL on that path, and the
> code at the 'out' label calls fclose(smaps) unconditionally.
> fclose(NULL) is undefined behaviour, so the test crashes before
> it can report a test result.
>
> Return early on that error path instead, so smaps is always valid
> at the 'out' label.
>
> get_value_for_name() follows the same pattern. Return early on the
> seek_to_smaps_entry() error path there as well, and drop the now
> redundant 'if (smaps)' guard on the fclose().
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

[Severity: Low]
Since this fixes the fclose(NULL) crash in is_vmflag_set(), should this
include:

  Fixes: b3b0d09c7a23 ("selftests: vm: add tests for lock on fault")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-for-mlock2=
-v2-1-f62195fc8394@kylinos.cn?part=3D1

