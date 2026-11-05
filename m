Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E8A606D81E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AG12x7tg
Received: by kanga.kvack.org (Postfix)
	id BD0BB6B05B2; Thu,  5 Nov 2026 07:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8F16B05B5; Thu,  5 Nov 2026 07:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6946B05B7; Thu,  5 Nov 2026 07:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7486B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:53:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2953340271
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:53:17 +0000 (UTC)
X-FDA: 85401056034.22.810DB32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8BC5E4000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:53:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AG12x7tg;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EMc1b5KEH9cVXiMGA75dD7QU3+3/XGYyYWj4dXStIU=;
	b=WmIUV8q1PmrIytkjLA07RVcehyDS+HXewyTTGzZkJ9zcHqAwhpQz/PecvM3pa+Z+Z2l/Rb
	3QLcG2sLctEhroSy81dBEkeQFH1XL0TrDJlRLzqkvQ8Gm+TypQzW7ycvxU2PmOZ/7uxRir
	Mzw1gJx0fDbwmb/bK0+/Gl74qSkJ5m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883195;
	b=fSKCyJsmo9CBgOxyfICBQtbLHad24prrlcMxHxTbJRq0k+s5AkWyzj+1y0khoCDrhx/dpG
	MK8qiXe8wBrZk0VQZHECZERaFegDa7hI9gSSRF8E0yuoZWBXWjuOO3Zh4MfJj/ZMY8GnR4
	YOypqm2FGvcaueuCyYWcCYwjaskFTRY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AG12x7tg;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D55E407D2;
	Thu,  5 Nov 2026 12:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9AA1F00A1E;
	Thu,  5 Nov 2026 12:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883194;
	bh=3EMc1b5KEH9cVXiMGA75dD7QU3+3/XGYyYWj4dXStIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AG12x7tgg25+b9BGhXiSz/ofPJ4/nOOi9uaGp8uGSrgkfC6bThURnEzl370xiLQpC
	 6muAHtivbUfevoV3luEzApxkC8XXfAHuDlJqLtaVtu1OONXVixuRtjn5c1UD9JIbh5
	 byWnONieIPW8PfllGp8EESZ/SwNwqh+z+bUeOFhSUE0oNulQ0zcu+Pv5pPKNy1VA/v
	 PXcbV0RACErEMoyZsiEx6uq7lKwa1pq0Kc38NlHNoFAHt2wIyJj2a0fiHRBcgHX0Jt
	 UBIZMH7O7j5NDtS3xfVZrECjEHi7M1FxaeHxqmkQ+XBWSr9qt2j43IsF7RzChgfKCz
	 qsCOafVsbDhNA==
Date: Thu, 5 Nov 2026 14:53:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org, baoquan.he@linux.dev,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 4/8] kho: Add kho_disable()
Message-ID: <aux8MKSzObmqUBta@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-5-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029172956.20791-5-dongtai.guo@linux.dev>
X-Stat-Signature: f6jy3isjx75914o3uqmbeembto8guhrc
X-Rspamd-Queue-Id: 8BC5E4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793883195-753090
X-HE-Meta: U2FsdGVkX18eCQEvBNazxb8epDW5CuIh8KgIGJCBd6u1swRfenmfdTkTgsDUEVh8dpyM5M+bzQbONHmOlW3ZHvAlD+ecctRoVHIEsS2evlt0fh8uRdJRUe9UuDrOX/YhcfiH9hXRq+bA6Pew/x1OXHhJnm0SZskKH6GkI8Y8qwi/DQcWfzVjVcxmKV4OLB9NRkuyTP/N05n9HS+ObO1VrlfU/fQ1Zl1a5fqUDgXyM6vk6a980i3E/06ptZu67CHyqmakmUmFFPO47YcX4QDtSbEvkaxtqCUQBMNJZU+VO7xlCtKnaUn8s60fUxrrI8Din0wedXECJVb/8pwlQvLgt2r7Dq0UplyfHTti4l7tXxs6kJwO0eOGLnesDEGJjyldVXJ/toWxLLo3PL1gD3bBoc2TVKkRDyi01ui3dC8Myl6JhfABS8vQiwJ+8XWhcOt1GNWea+nIpFyncwsUxBS8dOYtXxUVjUynRzZj2GnExdgg2VwLdfe+O9Y9fi1kRK/WBh5oXcns/m7T+kxI9QTJVYt/7IRB8PDdvUH3H7YjcQMb4FjD0y5plaboKgadscGNljGeMz1ne0PTMlyktPfSpxw+rCfqdkoMH8z2JBMXEgRgkqkjF6UeZ0Bq/Rr//7hFMtvH7pwpv+4Ds7RMSpetggZb69HFP1h5Hv6HyUf7RilUINi26tC0EXBL/X6C1D1yTHX/vR+8ggpJPgJvSKag4aHD1SnLWx1CnZKPTxkdfV45A9B1v+Qkxpj9iiquJJd8VhU56sA9wQ8Bktzi63e0LQMZPi6WFDf293svA0r/7zPQjGU0U8K/D0W5QMDt9vGcTCZfUWXE6WlsTVG9GAgSGGwiPoN/VQtmPIHP9U/3RpBLdKGLc16ukmW3QWwCV8RgrIPQrkyLTedKljR4wvExVvS8xuxdZ1Db/uxYPDyIPcIN+66fXlMc8PN17vev/Sp5YirCU7UiIAjaDNFjD+W
 8uvXSTOg
 N2tIGJBFwep5v4sAHHEystn5QMKPsjehH+OaPkr4JyMEDEYFUtEHPSrb30QEjcK6U9w/6BLERmHRj1gyIToaxDkgeg8u7uEuZ3BNi24pbqCeqRkBF79MM9ZRItkuP1BbPhuwZjb9yINBumz5Oe9fRgQ36uWmcZ3eQaJkBVl+jfelMg/dpWhi1GLyDZdB2moxgtgEUk1oxpJ0JY9q7aaFTyRVk3VklvQgBZT4lzjQnOsp/QYsBnvrAZGKEH9utGc/gtdNhCBHuGH9JehD51ZgmeX8+qj+T/LgNxKC7BZzxJOIgOQCULiFihIk+9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi George,

On Fri, Oct 30, 2026 at 02:29:51AM +0900, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> On LoongArch, KHO state is passed to the next kernel only through an EFI
> configuration table. Only the EFI stub installs this table, during a cold
> boot.
> 
> A kernel entered through kexec does not run the EFI stub, so it cannot
> create the table if the previous kernel did not provide one. Without
> the table, it cannot pass KHO state to the next kernel on a subsequent
> kexec.

The idea behind KHO and liveupdate is that the system uses kexec + KHO for
reboots after the cold boot unless a new cold reboot is a must.

Doing one yes, one no, breaks that assumption.
 
> Add kho_disable() so architecture code can turn KHO off when the EFI
> configuration table is missing.

I don't like a global kho_disable() API. It's ambiguous and fragile.

> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  include/linux/kexec_handover.h     | 3 +++
>  kernel/liveupdate/kexec_handover.c | 9 +++++++++
>  2 files changed, 12 insertions(+)

-- 
Sincerely yours,
Mike.

