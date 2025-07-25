Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B066CC87FCD
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105686B007B; Fri, 25 Jul 2025 03:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6A46B0088; Fri, 25 Jul 2025 03:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DBB6B0089; Fri, 25 Jul 2025 03:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0F856B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:51:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56DDF1336CB
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:51:04 +0000 (UTC)
X-FDA: 83702016048.23.88BECDC
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0F947140009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:51:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=cEo5gAAh;
	spf=pass (imf23.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753429862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOVFlvbl9upVlLlSJ+gKg+QG/EzUMWB+gqdb/rBhNqg=;
	b=SKppJH5xxpQjIlPPIutItzerB2r3KQKCsTm+0kEyYy9I/tQ0hksDIPImq2svccnqr9NUyA
	24q4NqtUDdK5GH2YNdAx14PUw25PzJcP8b4iW+Vut7nyTX9E1v87sqeoiA5DZIbziV/pL7
	ULScX+Qk6AzcH0x5nxb6e8n7mOYNHQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753429862; a=rsa-sha256;
	cv=none;
	b=g8nRk1siv0O7VV7K45syXDabdsDAPNhvHwe30Sgzjc7x5ysUGsVj5HTYpP64U2w6KOSzcv
	/yuraCglkSsAKibzq0cl3KIhOSny/Pm9rQUioBwAN8OmBSN045w2E8jIi8vneopQ77QI2/
	w66bAjadcT6XGQbBqreIB9PcT05hL8I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=cEo5gAAh;
	spf=pass (imf23.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sOVFlvbl9upVlLlSJ+gKg+QG/EzUMWB+gqdb/rBhNqg=; t=1753429862; x=1754034662; 
	b=cEo5gAAhm02lDxNtVpWZ0CftSZDWo2bUI5Q5DNzW+abLNXO2fy2fGQequSy31xZ42ghfhFgd78v
	3n1YafGd3WyJJ6BC55Ny84eQodDx3gcrzZSa/0Q614y5e8R77iVbCE/2R0B6Ps+nhYN0hH/yIAH5z
	3tDdnUw141c5fHBfsjpIxGRBpY51eXyTvEIEzTOJkOxKcNfxxjsgMIkYnviJ2VqywJ0l3Zdtwk8Yw
	1ZgMLAnApVpWFCmJCSyeM3NG25iAtcf2UYEfdt7uGI3UCM/TBiFkgKgjdJrM4lAHHv6FmsxBXorcc
	5DBoP/HYaxgGPJD3PXXEBWDF8WDi2d1eAwhA==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1ufDCd-000000026hp-3NTx; Fri, 25 Jul 2025 09:50:51 +0200
Received: from dynamic-002-245-058-127.2.245.pool.telefonica.de ([2.245.58.127] helo=[192.168.178.50])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1ufDCd-00000000chc-2Fcp; Fri, 25 Jul 2025 09:50:51 +0200
Message-ID: <ac3a117c91d27dc7eff8c22ad6bd261dd2557451.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/3] drop hugetlb_free_pgd_range()
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>, davem@davemloft.net, 
	andreas@gaisler.com, arnd@arndb.de, muchun.song@linux.dev,
 osalvador@suse.de, 	akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, 	Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, 	mhocko@suse.com
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
 linux-arch@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 alexghiti@rivosinc.com, agordeev@linux.ibm.com, 	anshuman.khandual@arm.com,
 christophe.leroy@csgroup.eu, ryan.roberts@arm.com, 	will@kernel.org
Date: Fri, 25 Jul 2025 09:50:50 +0200
In-Reply-To: <20250716012611.10369-1-anthony.yznaga@oracle.com>
References: <20250716012611.10369-1-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 2.245.58.127
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: 0F947140009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qf381hshrbjcw413ijw1a77ii8xu3gfg
X-HE-Tag: 1753429861-785343
X-HE-Meta: U2FsdGVkX1/e1H5SjS7RBvmN474E1bPv0j7zz7td+C3/WjaiKOBYGPOvUBA4MkADMExKlntPHHVS78xAvSVqOu/+zah6uQoIsFi05Vd1qubej7iWusWEQKehwEk0JsqS6591qOu+HNHRHCr+QMNMnq1RP5MWpQjBo60uHAedPSqcYxC1OOJeLZitVl0BCTt6IZ70fYODCpNX4JNfHkI5rtuLvhp9scKS4dKkanBKXOyr+8wr9sa1b2vSiaFoBfP2RPFOCFWBwohB1E3m78Sx0Goa92UsZG1HaV0JCCN6BNumnIKZH+pt/rdjjmMJvX4XDw6L1DeWPmeTiJ7cxZD1NE/rXQA9FSxmnzO8lzRErh1PzRkw+y23Gz4xS6NCQxRxPsGIGktP7VPS5ZN1wIC1qfDf/nQSTYuTartNWOJYRVqvy7xBeryi9eJ8UI6fwS2K9RKbX1+8UlPsLM+yWTpHjDaShOyWu/Fx38rM4L1r+kocVm9tuzVAMfdVtSxHrT/KyIQ5jT/4DZ9cC4UAo3Vmx6tyEQyrjItJfE6rAK/+k7xUmh1k6Il2WZ2LcqZrXGhwfTiB4O6OP/EKxx7OtI0SXL2m/OUJWJ4FUGH5PcUb91In5m4hYKIaq/9YHaNJPJqF1+HeqZZCCIfvNbCFzWVCNyYrtTLxK5KneEelqrBXnP4cAMm9engq4qJUyJAvS9miGYmBTBNyr3FW6VkmeYfCAtGgqRTOYUIW2p0DIM55vOhhmp9A0PvDAnLU3QMXGHVlTbmcW+ufNbSajqcRAqjpHIwKOXxrUpmzh7LcqIqcF6+K4mX4qvNSmORfeef/vlyvRFIgkROH1ULkOfA2USpkrj0PoEqrBtgykp+C2GyrycpiPk1VeyFg09pNCSBnKKjp18R3xgot9TZ3BLdUpeHEemdMPce1mjudbZW7ss8IWxEI/d1yo5ZcDdJQjKKjXhFU+9Ve6AmIIVmE2F2Pil/
 U7KlYpTM
 Z9wSEde9fS4PTewZwMNEveo+DqrIOwSDDgCtpaofvPpsCLp0mQsZIoZ83unveLVVf/fLi4bDxq8JOdOtX5dgHT5qK37uwX9yNA0g6dH37t7tWobrB1yMIyScfpICwooI5xfH9vsgP7UJTn7laemPppcQSJFNTEigY5pbDPt9QCgk8aN2F7techLytjYxyN5tQ4GgY5poVkXiUG/3K4KHOFW/7qVFAmsmhgubxkZCcdJSjWUSOoaX9vgvGqTEa3k4lcEYZUjumPh893pU6rTIohnVC8rLvGQAAlAjv2eGtOway10MzjUn+ar92XLYvX5FZyUvB5AqDkYU0rgaYTZbzy9nByxU9i/bjKbH9/96Uv4MeX9dPdpRrVpJCxlaokIfcAfXOK7qJQ2umhqAUhNGxBk7pGegsiH5BZBZW/4uY1nLD7WI6hY0O1W5PoGtgwc+iPdTKJXWjheeP5VpXqWoTaVhFnIeaP8lJIwuOpn5i/Q9GJPKa0FfRpfZYf33NlpO8rVABxce9BKitYUvJNlTUOFBQzE5rr1ENK5t56wzGWkA2XTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

On Tue, 2025-07-15 at 18:26 -0700, Anthony Yznaga wrote:
> For all architectures that support hugetlb except for sparc,
> hugetlb_free_pgd_range() just calls free_pgd_range(). It turns out
> the sparc implementation is essentially identical to free_pgd_range()
> and can be removed. Remove it and update free_pgtables() to treat
> hugetlb VMAs the same as others.
>=20
> Anthony Yznaga (3):
>   sparc64: remove hugetlb_free_pgd_range()
>   mm: remove call to hugetlb_free_pgd_range()
>   mm: drop hugetlb_free_pgd_range()
>=20
>  arch/sparc/include/asm/hugetlb.h |   5 --
>  arch/sparc/mm/hugetlbpage.c      | 119 -------------------------------
>  include/asm-generic/hugetlb.h    |   9 ---
>  include/linux/hugetlb.h          |   7 --
>  mm/memory.c                      |  42 +++++------
>  5 files changed, 18 insertions(+), 164 deletions(-)

I have applied this series against v6.16-rc7 and booted the kernel inside a
SPARC LDOM on Solaris 11.4 without any problems.

Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

