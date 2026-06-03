Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA35CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645BB6B008A; Wed,  3 Jun 2026 06:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6886B008C; Wed,  3 Jun 2026 06:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5338B6B0092; Wed,  3 Jun 2026 06:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43BE56B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:01:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD954A02E8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:01:20 +0000 (UTC)
X-FDA: 84838158720.14.981FFAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A45410001B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:01:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjuSI+Mu;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0UEN0T6ZdBymDl9PpvYHn+oresFz/OvDTAtvxMlbog=;
	b=kqDJef9H/PBdTU8p3b2QGIoXyaH5yqJimPIyredFAodvkWxswLOFWCArRSKxkQsyYtQGpC
	wWvN1WWfJhRVXtfytMPNMD5KVaVMeiAx+4Vmp1V2ogl18jrbnELmbtiJsOQw3KbonNROtA
	C9fQpbDXZ5Kc4c9Mm9r1HaHF/iGAqIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjuSI+Mu;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480879;
	b=BQcpLXBGzOf5pUB1htfmAsOxa1IPzCikQ29/tiDtxjv0DQqlrvVJWo4RfhFqakEhPYpTYm
	ztuJSriEUL3OyTYUcibJEIBicLy0AmRcecAgenz/feXTP211x0Omue1BwZdc9KHEsDy8Wr
	fMv7M2/FrSK5dHUkDAao+T4OJNco0Mk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EB4F408D1;
	Wed,  3 Jun 2026 10:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3031F1F00893;
	Wed,  3 Jun 2026 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780480878;
	bh=q0UEN0T6ZdBymDl9PpvYHn+oresFz/OvDTAtvxMlbog=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gjuSI+Muvpa64FsbQp0C798uC9heDmpv3fdEuh84z+86XBxG1fvEQ67e/vX8+wL7K
	 Y7rr2et3VW/Ny+hwumBYFnnt+Bpq83US7jerAsqO5Ald11hBK1RHwB2JEQrQkKmOjQ
	 0EfslI1ewAJMPW6RpqDuQFlvdoNwuXdwoKfK+sl5UdzUVmDuQQspUvRwFrWixz6c1/
	 HLw2Eq5uEFinQ3xWicCLCAos/nLRrYe4XMyXc1o+nti2tRVsov4/Cryr9DQL9/90XL
	 orlUdVKatU7mpJqzxzmCoKHBiPRiULCkShyXv+oApD/apilcFeKpSlS5gKXv9ITn6E
	 H1ijxviFEgHRg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/5] selftests/mm: make file helpers return errors
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260527142432.230127-2-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527142432.230127-2-sarthak.sharma@arm.com>
Date: Wed, 03 Jun 2026 13:01:08 +0300
Message-Id: <178048086818.472368.16811711474077698399.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A45410001B
X-Stat-Signature: okak31epmfwtw7huk3ag5nffaxkiqpw5
X-Rspam-User: 
X-HE-Tag: 1780480878-818505
X-HE-Meta: U2FsdGVkX1+0WCT5WhqtQ+laCZh18+d1b7GxlOECQSwwsPGZqvEtZzxN5X3tvCAePyoJuHBaxa5d5qx7bJCShzQVc9p5ZoxiSvq+L8qK8lEi9cClVhLngOIYfPrassSWLX+QI9Us8mS2RT8ntD3s5nuW0TzM2nOPyBChuiucZK0hgweKlgHry9qCssHBK5C39W66Vx08fnJBMLgoPvr+X7cstuiobzM/8rQef1WNlZazwUxsGduYF/nJPEuu1oT62YuwQ4G6rg2bsqa+BnL8eXhYzYFAzXYHDgWflnTK72zq22lkV+aOyUIbfhDykNHCNTVv2eHCbQgoTGIVpEX6+lPXXNo77yH9sJU3G/6U4obtg7NXL88I2JcfVVQnh8jUwt6dnVicXUUi9y2tI75/wiVc081LRBPJs9DelgO+PGGMWH3cUkJrQwmHqK8fik8pgrHQlO9otRHajWKquKfcJmMOWt9GPMdlJ92vQsR/8yIwHr9BKOwBcYH4+mw1SvY/3Ujmu77knWek/iKXpKDCO+vaWGbQbzJ4MNGlFNbNVkun1kCcHRmFPjkwryeqfwBWKtfIdomxQymPauoJREF1RkjEOL0eLPSYz/AsJvriJ8bvxxFqw4byxP6prgyqJfOhVNph30PnEq9+WcCUSeIXFdsYY27+bDTJkkziHs6yA2CrBTA7zOvLVwM13uMMP4S++9L7GGXSowrpvM3io/V7nB+FrmNvSyAvdR+OfpPyKYOfeeYj9hdu4ALGy5wczNj6AQN+POCmYCVRy89g/Ua58RPUMyEJ72pnRyw8fqvK49riHZV+wD1E6XFfgsbbiV17n5mLouQaSzQDwrKBciutLOkPj2cWfqTtyIPl0+YDPTZQ303AXdLJH4idnk2uiSM1ydKEWSd4od6nNaaSrV8rk+O2ZvnSApyMtZMJpxL5uyt74Jumk/qAOAHy8xvE4Vb2QerdB/Myd1RiIemT/KD
 iCPMFlcp
 zjPRuuUUzhso+G6iX8ezfcxowmReJ5mlOHAcG1U+7Ab79boK827cn54owTp3gcW/Td84TwBRxh2dHM+FxD7ud7KOa1g6E5naylh0encFbWiwfLYgty96tdpkCl9/2Gvef4p8V1YRZPQh7xsquMDr4tl82u0tb4HMDtsZwVubJVIYNaatLBiLKUjvhhDiSuPpR2U2Cs7J/6qRalYmSD1Uum/WDJxm+B094VHEolxLPIr84cWGHnof9hATiNQh0PyDeoiqDqxsNWNrpaxZMJZBoKIHt/4Uf7F0sVi2+slX1ru3d94w67a+oh/jO2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 19:54:28 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:

Hi Sarthak,

>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 2eab2110ac6a..c2f97fe97e58 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -61,7 +62,9 @@ int thp_read_string(const char *name, const char * const strings[])
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	if (!read_file(path, buf, sizeof(buf))) {
> +	ret = read_file(path, buf, sizeof(buf));
> +	if (ret < 0) {
> +		errno = -ret;
>  		perror(path);

Hmm, looks like those slipped ksft conversion :/

For kselftest compatibility this should be

	printf("# %s: %s (%d)\n", path, strerror(errno), errno);

> @@ -103,12 +106,18 @@ void thp_write_string(const char *name, const char *val)
>  		printf("%s: Pathname is too long\n", __func__);
>  		exit(EXIT_FAILURE);
>  	}
> -	write_file(path, val, strlen(val) + 1);
> +	ret = write_file(path, val, strlen(val) + 1);
> +	if (ret < 0) {
> +		errno = -ret;
> +		perror(path);
> +		exit(EXIT_FAILURE);

These seem to repeat themself, how about we move prints to read/write
helpers?

Then it wouldn't matter for the callers what the exact error was, and no
need for errno games.

>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 311fc5b4513e..290e5c29123e 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -703,62 +703,72 @@ int read_file(const char *path, char *buf, size_t buflen)
>  	int fd;
>  	ssize_t numread;
>  
> +	if (buflen < 2)
> +		return -EINVAL;

heh, this feels overly protective :)

-- 
Sincerely yours,
Mike.


