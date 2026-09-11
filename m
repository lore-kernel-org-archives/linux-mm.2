Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA79C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6036B008A; Fri, 11 Sep 2026 09:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4670C6B008C; Fri, 11 Sep 2026 09:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4186B0096; Fri, 11 Sep 2026 09:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBA36B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:02:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7497040200
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:02:04 +0000 (UTC)
X-FDA: 85201494168.23.B430138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4134180003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:02:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGf6kE80;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789131722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbFIIEzlUTxl2xJVgrwWeAYn7BDxFx09xtnVsWU/DZU=;
	b=h0lCQzfCXAid6zMPHnxYRVjP/k1KplW2y+7VY0VTR6UdeyknxJsTFSSUmZDv125R0AhbsQ
	ariU3YSQKYEVOPj1HgSNld0zMyaggH5ekQLwBGuoB+3maQMD9svw2q2RyX6xL2iBKTD5T7
	w5E8hpa8mw/u0rEjRkDPYwa6Sg47N68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789131722;
	b=bO77v5dVbwFn8qQF5iVX8oaFqL0QLxet+4wQ+CbwwlpLw1ag0CsgVlnDHeUMqY1e9D5fZ5
	+T0Rw53nv2tBXZU9gADbzzFw2WN2OHMvvKMyBqBsnnuLisTWmjG8s3wKSicW3ut0cb7e+v
	ngaSxUOawXnr7mk/gmtF6MgoAEBfWJA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGf6kE80;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 169C56020C;
	Fri, 11 Sep 2026 13:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBE1F000FF;
	Fri, 11 Sep 2026 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789131721;
	bh=nbFIIEzlUTxl2xJVgrwWeAYn7BDxFx09xtnVsWU/DZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eGf6kE80/niewCA/exBDVcLLTbWRMPwpulCnRJlfbdYNfHtJSrXSDAl6WIH3FTjtG
	 gaFkHeK9+N2Lb/C4CsTee5ZeaAKLQB1DjL+lM2ijnCJmSzlMbr3eiqOFWHkizw5EJa
	 6HtfC4xrAjaDF2jpRDgtoHcB1UQRrQur+rXjubVZS/d6dl5fmNzS6yupuZRVPW7LXb
	 Hb440HnuyGwFbwdSc5ywhqJam0/v9ujlkJfeJFb2ZObm4MMuicmW75bfytQ9sTVxi0
	 FJ6ZOxMr3f5f1IAxpAdX+Rz4SFHqEUigz5AMi7xOn3sv0tMRyaOJIWBU4RpOMmVEjh
	 0WdO6plnGG75Q==
Date: Fri, 11 Sep 2026 14:01:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is
 unavailable
Message-ID: <aqP7gW98GIiYgL1z@gremlin>
References: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B4134180003
X-Stat-Signature: pf481pdzzppdnfkgq7qpqw7835yirjop
X-HE-Tag: 1789131722-627894
X-HE-Meta: U2FsdGVkX19CAoyQMjuIjNIVgRG2No0AN4fbQ04uOQwucGvQdClMkehTHAPJrgSXVevNVtnA1EntNWZR+3bIt+V4T/t3bovjjcD+vxrpj36+Gx5fWJHoScZmGFi8GpdPL8bibasrh6s8gQZdLPXujNHkLQVytzTL1c+Sxr9Sp/l5rkZScLtSJU92uZ+ZOvuxjabJ+czdPFhILFwFS5u1JwIROCW31/+I1bIDgY8sa8rh32IxjJOPJCrqet5q60FnRHE8zmd8I75Bu84lX5BIzxu4URkDqxUb1MzE33ZX12leAcJXkZrIlme6Ml+vt5aB46QJZQ7ufRbX7z2YTtJumkVGeAFQndj7t50aQhtx9xLuScDhP3Dc0/67Jvm8U5G4E7hHVcY1YtlLwgKG7nzTOyXauoNXqHHJ0TSSn0ZqMaV5iUztGZ9p7Ug1g9r8HQhFTQsXNxu7VXUbJL820asULZr7ghfUgQSMwrYYNP+KIfC3qA4o6zVumCLGPneMTc9nZPN+VPFSikQJeuQJmqT1o0Hk4DWFkcSeggMef7CtfjqLFFK0DHViRMt0N/y4JD8iKa9p2lb1W0zt0fpTh7tQZ52oJIuSYd6fYcKqf0JqlHDgn8O0lba/obkD9QD/EJGDrgAQJkYiU6c6gddT1S0hCn6uq8HYDeSL8h95zDuQ/3FsPezXt40XpUtGTpuSvNy8jJBUZINNjrxwqEyXy0/ZiguBxaCx4KCGUOqrnJMX/2T3/HvtZodO6utFhAw5+Pbb5IdmWFkNNr60tUlLatfLGZe+YLw6X3+HI/hE72WHBM8i6+KJVy8pZB/oeV6lnGLtjNu1crQlX3xnvjBUyD0AuKU8UqraU7+PoGIuIcEDAWdnVjguWaHyxevLluV335DiV9pe0q2vf+gNB65KLDxuj3ljCY419xYuh/p8YqYPL4h8GceFeec4Y4mDcv1anJWzsAdHdaXz64h6zy/9naz
 Ljgn3Ym1
 JokCubjwL3/E4rAUQK8SKhqXR+wmseuRLcK+ui7EL/5uOVJuW8SK/X5yhDrRkIpH8h0g0wxTs/9/1VK/3je+6thJfmpBxMLKjLs3K3ekhd3hAGYhIcor599YrFhZX0wUW6ZII35dOgRPZvGYUfrBOG7R5QIjWliIHeD1I2s7KieqWlX0P13dWu4zMmWFHiC63CQlpfSIpsp7ua81TJe1XcmzRIpcZUNqOlQt7CygwEAas+lHTiAZMvQrBxj3Bmn+sAaMQQ64c/b4cnruu1BTlK73/NmXS/c098nJhSoxqjxf3havbD+1CJfBxerXBy8CBHEFjD3Nyuur0LIQX6zYDoJ9ycdgO1o4Vh4RKVDJxvZmqfWuME04sL7jA0leknNj4qVGPlnOSf5/egtv5PPHyRTJ6hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 02:45:17PM +0200, Jaeyeon Lee wrote:
> The XFS setup for ./khugepaged all:file checks that the kernel supports
> XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=y and
> xfsprogs is missing, mkfs.xfs and mount both fail, but
> SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.
> The test then runs against plain tmpfs and six subtests fail.
>
> The script already has a skip path for this test, but it never runs
> because the path variable is always set. Check that mkfs.xfs exists
> before attempting the XFS setup.
>
> Assisted-by: claude.ai:claude-opus-5

Convention is now:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

This seems sensible, so with the tag fixed:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384e..6315b67b6733 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -415,7 +415,8 @@ CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then
> -	if grep xfs /proc/filesystems &>/dev/null; then
> +	if grep xfs /proc/filesystems &>/dev/null &&
> +	   command -v mkfs.xfs &>/dev/null; then
>  	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
>  	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
>  	    truncate -s 314572800 ${XFS_IMG}
> --
> 2.43.0
>

--
Cheers, Lorenzo

