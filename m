Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD9DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 15:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181418E014D; Tue,  4 Nov 2025 10:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130818E0124; Tue,  4 Nov 2025 10:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E938E014D; Tue,  4 Nov 2025 10:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFA0E8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:19:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8041D4AD70
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:19:40 +0000 (UTC)
X-FDA: 84073284120.24.5D7F53B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC572180013
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:19:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgXbrbaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762269579; a=rsa-sha256;
	cv=none;
	b=AMB7gbS+mN1yUepkzdzNjLCI8W/EupU3UtBP5TEZfryh/n3JVcnt1v4EAxVGKGtobiGu+L
	OP11yISTvMyWn257IeVqSxX2xO30+N3/MKAU4f0Y1Y97OHQyGw/fCzU/cHhG6y2wOsNBcc
	pqBA0aGAQhoL24LvPCOnBQi03Q2Vya0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgXbrbaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762269579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=vpHpBk1jVIzuo/vn/Uvc4xurVlKMfbzNWNKTG/YZBC4=;
	b=ldz6u+zIvATwIBn3uog7FVXtI/PiQwIlGOtuMXuiMdOFP5hHEMcXeZDP4vpbs2Tjod+IIA
	lW5BiikmzH4OttojkEi/tFqQAYu8aYYYSGjA7MGsYG1W54xk84RPSVqRme9CgNNMUJDCST
	1MlNEqWAts29uXpb2gtXwenbxliUPmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1958460208;
	Tue,  4 Nov 2025 15:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1229C4CEF7;
	Tue,  4 Nov 2025 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762269577;
	bh=k4PWSdB9JPNF7dXkmlfgfPVWmRMPLaoLYeVYkmcgX84=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=YgXbrbawniJRA9mTXZfrvv5psDoKlD7p+oObyOArVrlKfTcatyvO2l4qVYgABbbWQ
	 GJBxUFaKXE+wRxy5wEYzPDSe6eZMjxsxNBSdF13Y7XI3F7C13mzlAdwnGAc8pjtrN3
	 lBoeGx3EkOaCwkEPrq2RhAOnMeVe0NyNj4/h2OLTknI6WkeEgdMCZvAelv7S118XkH
	 vOUgDqW5UXLG2gBBloPAiik4dkDFfJxdCriAO+w28cllo2sIUcr0SbXz4FZPTsGG+f
	 kuWp5LWxjzuZNuZBjZul4Qk9XB7BlWnPz149vmNlPdlFQrjc2c22oyXCA5nb+5/IV8
	 rKXN9Uac8PHlA==
Date: Tue, 4 Nov 2025 09:19:36 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: extend file entry in KHO to include
 subdirectories
Message-ID: <20251104151936.GA1857569@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104143238.119803-1-lukas.bulwahn@redhat.com>
X-Rspamd-Queue-Id: EC572180013
X-Rspamd-Server: rspam07
X-Stat-Signature: 846emsuacmobzub18pbhwts88te4kjzr
X-Rspam-User: 
X-HE-Tag: 1762269578-227785
X-HE-Meta: U2FsdGVkX19zRDw+t9K9v/EUIFTXEZd+fV/tQrJD8U4DncM82wk7fqp/Sb1/wNARvjHYOdbryAAQB8Dqv0kSCPyvtTTSFtzeQhui+0Jux/4HaMmT2cCvQ0F8thJEqpU7ibTIKK6dRL7nTrnag/K+t4pnYidb7CiATIrSxCbfpP07CKmS5IKzg3qVZIIDzR9fpCLwSYa/mmwqbZqlki3jBCdxQWgE+42ydGDN1IXhCLYDggXBtWUK2qFtuoVxK1x7UsP1miQsiMViqtAOagczh9k0UjmJO4sHEJJu+N3XlUJXpE6YRKvMPCA2LifK3ipMNUjKXA+0GtQzLTyvDw45XCDRXF99LV6DJHdTmoHs4sehriuU5qqamtPzwE3HwSco6buiaZGwcz67soVBNAxiP/1VKPjp/7OZtCr4wIMDPjqUBEn5sr6cprvOBSdRECI2iBq59paT673ukC21GXGvhi3sFNJEYDKcbh+SfJFYwrAg8vrWK+daLd35xpvbIkv+wWP4XwdwHkVsNsB2AZ+q6I+bGB01BSfBkcB4CoveXdGo2PF8g/JTEjwFqwGbapig2T4uMDUSS4nf5ifT7Dv+xaY7kb+S5bHXC5x3BVPNemRry1VvWRaNGQ1qgs0aC0Gj01PINXTVJwCaUTQU0ZV6zspoSEpAy+JKwv/Z+JDhu9OBVdKD+cKBSpux96bZzlxleMcL8VTJQlhuxU/utTNr2AHGr6rG81846Q5pnw72f3tE49hPeKbOSb++gDjjNpH15uYl124Ewht9jrHPdv8TciIGLOkMDGJNFcRH9/Gp1tlkGDR0PZNwX5VVBobydpVAE7mbgT2C+x5ktLJozaKEEMCQaqVNwwdfr3u+UwBckq92JJjQdTL6k1FpAvWlc2p1/ghneZonNcILn/4dWUotpZM6AWvp+cRD0O1dcKYv2IQNQimJLx49qTLK6RFGb4xUdNzT7ffWT5Kr/PNHZJv
 zGcDX2d0
 PdBRSa1lGvhLKLRxZMzZAvPLtaqy488yv+nhATPZhP9NMOqQs7MZJSRwLB1f3qUmfb7tD+bO7hpzb+rjw/yhX2WWCBOjsJZOJ96M+B8EZ/1HTGtB8c7+z2z/EYm8PaWgeWIWrpfkxdz6D2QrZzipI7gy3ERmqK/sAUZdYexi9DAA28ELiEfAiDAIuLmT8tLOF/x70nzrrB4scaGLh061kDROuqgzBcy1TK/jeQ8avo/o1w5dMOm7Nt4SjTCpafG/n2tRAtkBHAD3jqlpitmRKF20aDGbAQdsUrY7P/7Zp3TTZV9yfztcBilkT8dli/X4UUU1l4H5kvCb1rrLOraVOo49GsSUtzC9m/UuPa5kVkO2wvIKfG0D5adXKAz0lfEBWoLyo7B5+l3X3M0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 03:32:38PM +0100, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> Commit 3498209ff64e ("Documentation: add documentation for KHO") adds the
> file entry for 'Documentation/core-api/kho/*'. The asterisk in the end
> means that all files in kho are included, but not files in its
> subdirectories below.

Add blank line between paragraphs as you did below.

> Hence, the files under Documentation/core-api/kho/bindings/ are not
> considered part of KHO, and get_maintainers.pl does not necessarily add the
> KHO maintainers to the recipients of patches to those files. Probably, this
> is not intended, though, and it was simply an oversight of the detailed
> semantics of such file entries.
> 
> Make the file entry to include the subdirectories of
> Documentation/core-api/kho/.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 06ff926c5331..499b52d7793f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13836,7 +13836,7 @@ L:	kexec@lists.infradead.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	Documentation/admin-guide/mm/kho.rst
> -F:	Documentation/core-api/kho/*
> +F:	Documentation/core-api/kho/
>  F:	include/linux/kexec_handover.h
>  F:	kernel/kexec_handover.c
>  F:	tools/testing/selftests/kho/
> -- 
> 2.51.1
> 

