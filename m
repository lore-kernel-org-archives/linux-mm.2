Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19D5CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 16:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07498E007D; Sat,  1 Nov 2025 12:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF268E0045; Sat,  1 Nov 2025 12:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BB98E007D; Sat,  1 Nov 2025 12:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D134E8E0045
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:37:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C8D1BB84D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 16:37:05 +0000 (UTC)
X-FDA: 84062592810.28.3E50841
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D232E1A0005
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 16:37:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOnF0Fpf;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762015023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5Die7jIIGa60l9e7IEoFUD436s7N354SKG3hOSIsDM=;
	b=5s7cA3LN6FvedtsJGvfaySyr8KRacFBCHsuVUxUhr5oHQHOvxkZEHD/veFyuvTacDNRVbr
	IAvnzAF2vheO50anx81sFI3WNbb9im0Ob/vBG8RsEnIwXzy+6RYGQKpbcxoVPwkl56Z3Cd
	hcwgBYj0FIlgxUsLxUx4uSPVq0rZyNc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOnF0Fpf;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762015023; a=rsa-sha256;
	cv=none;
	b=tfsdRSoRlUguliijgGa/JkyP7wvrf6Rk4tODYJIqUn+M4vKkegmDEBGfg6XYTOXVOs4uMf
	em06f0/5seEIwowDH3AP1cEZXnMHaTaPuMbIEeDfdXkRMKN8ME5CB0HHRBKfyVTEdxnRGd
	lch7DTPCwM4ghl4d88zDBYXF36dgwCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EDF360142;
	Sat,  1 Nov 2025 16:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8196BC4CEF1;
	Sat,  1 Nov 2025 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762015022;
	bh=QD1sibqRBPzm00GzNbQgSKI+qAFQGKOnEE0guoDboxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gOnF0FpfAq9rrWZiMV3zfkX9ztq4b6Yktm75vsXmspy3ST7BzO1Ixq6JpNyzceFWo
	 X+wPmGG1brQhD9vmmKBXaFJar7QFv/YmuOteYTHBtlKBIbs/2YBqalcRXglEkOKzgh
	 oJ1zVD8QVkEleLhOC9mroC8ZN6JYD6bAFKzfzOAHQTO77Ar0ZCMX1o75+BYUQnHJo/
	 v281cAn4LSibnRiNaeLw4MFUWKYMsJarhweqxCJJhQUbxY9FpHd0GVovxuNcYHhX5c
	 yL6tX0QSg5foWhpnk64eF3SyEyyRy0s9Hmpk4T1kpuVt8+RZZNwP28C+Bs6b6SlJc3
	 6LLCx9xGIXEAg==
Date: Sat, 1 Nov 2025 18:36:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 8/9] MAINTAINERS: update KHO maintainers
Message-ID: <aQY3JUGAcS3FR8uJ@kernel.org>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101142325.1326536-9-pasha.tatashin@soleen.com>
X-Stat-Signature: mp3hz7eat93eh6dnhukark1gypn1wrhj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D232E1A0005
X-HE-Tag: 1762015023-474137
X-HE-Meta: U2FsdGVkX1+CWZIaUK7h4XziGYyTO+L55juitL1Q1rvjzuIA1Q2tQt8pRd8dITJRfHRXVSs1e/M8pjpbDCUKt1tRvEoMq/hhR+88Qd+tUAs7Zic/5XEA8x+4HI8H2EdJ2/zJngXvpwy6P02n3OYk/FqmPdZoRy0BYLR4XzqzKEL8VFsh1mpfs28OELyHySjjqcukkE1KqlfMei8KYmygrXcy6Ae2RmlTvi7MS6pIsoQ5CmdBEdMCzlEIqNsvJHiajCoMoiGnTmZv/CH3eNnDsJHiyIHwF81i3Smgs4z0BiI3AWgio0CsNNaH9GlAgmstYiUAu7BbrDjXBT0nhMKkKet/HtINVFGlFXCFfFv3pHvkxDHExSGv+FSbntrEdz88bgiz7NYAhcXOgOzPvbUSF/C8qICiUKkoyWhX+BM0OW3Igg0nUxhfV4qS3FmmA1NwLuw/r/nwhEOGlFt+ArPOlbuMFnk6wQLXvTwNoSW1BP2rLCpDw860K9UIEC4yM22bYZSdD5cJhlhram0j36QQrj5wk6WHwKeVZpamx6uLPaRJdPX3+mgmHoT2H6y/IAXfYlweZ55vv0uNN/7l9O3MHxD4fjAZ3f1f/ToIDf0qyOAOxMwQCeon9rXyOR+e6iduhEZZj3oo5MraE1Bl9f67W375P8HR+i4m0kUFNLqXOoRWbpYgJ7WrheYxpC2AQofTUXHhrMB3iBQoqicgr9S8olvb7qYwwMFV8TERFb6IjgvpADzzsUT7pMPOuoZO0QS7CGBvg7jj5av5LDVTd5lf+gTYTZmPkkS6OLE2KLhJW6LayCSbnBcI6unEJXubBCIkbwU9NhZlp6jbk0TkA9SHMnPSDYjc+mxKh7a/W877DL1e/FyZZGELugNlbq5sgMr7fpHx2y88CdvBIDA8j3dgqDNc4C64lzE5Q6mxgBI8zj7Va7b2B2fkHT69tmewwUApViTwtFsNeqyNk/tSX/T
 5oOWkqr2
 Qxpn9vIFlKn1Kb+OVg52aSr8nmn28UP6MExkSoaanCCZCoHwe5Z2jE1hAUpUSj/J70uLUT4yc+f6aKCcuLHjLzlZoPbHbPD8N6x/xOPc+FQW+uB000BAIOibhxeQGbM0f1GcMhKQyOoUA/pTPjQ2DyCN8HQF66bzxih0Zm8YrCtzkTjPK+AvYHdtwPSxZwvQ9kNfAPdggeLyzVUsd6+Mvinr4n7dHh7ahOAyGluKk0zA5O7d07vnDtGZ5jfF3TFennouqLhOAmAmcUTcGhH9pBWLyaNzYU/xmjkpHhS/qYn/p54/3twOOEumGq6n1f8OxQoWon48fsFrrBvylavwB+d9fTgaSyIY4pDq9CLKlZlYLy/OnbcZvyysD7lFx37drfCW+Ijy2Qj4XqKtfE3Db0WVHMBAyOBzns5Adn1MMFHzT3LfpgWm5IOht64nUtv0wh8ciw+e5PKeN5GzvGZwG3n/gLfbecra+JFUtZchke1kmcqwNkf56UBM+J1kZa1hrdXNT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 10:23:24AM -0400, Pasha Tatashin wrote:
> Changyuan does not have cycles to commit to the upstream work of KHO.
> Remove from KHO maintainers.
> 
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 764df916fae7..6200de2027fe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13788,7 +13788,7 @@ F:	kernel/kexec*
>  KEXEC HANDOVER (KHO)
>  M:	Alexander Graf <graf@amazon.com>
>  M:	Mike Rapoport <rppt@kernel.org>
> -M:	Changyuan Lyu <changyuanl@google.com>
> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
>  L:	kexec@lists.infradead.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -- 
> 2.51.1.930.gacf6e81ea2-goog
> 

-- 
Sincerely yours,
Mike.

