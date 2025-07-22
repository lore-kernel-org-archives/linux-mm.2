Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054E6C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 20:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3038E0006; Tue, 22 Jul 2025 16:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282878E0001; Tue, 22 Jul 2025 16:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F068E0006; Tue, 22 Jul 2025 16:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 090A28E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:47:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 903F9112D9D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:47:20 +0000 (UTC)
X-FDA: 83693085840.23.C0338A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F389320008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:47:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mf+02rr/";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753217239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EaXU+pypTZWCPj1iXR2AuVgnBswGufo5suBRYYpMEE=;
	b=KId3NRxzN4UgNqKpPDIjt425d+RwZUnAvPDXytmBaCgpa1WIAxpUFLT7gzaPu2Z1r7wKcc
	ahyMXghtJrPULoq+BwHBrrDumI742hOF+vxJtA8bu7RVqwh1OKpga3udceRs0ihdqErf17
	De0UigYebo2Gxo1SbjHBpI/lGhg3MSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753217239; a=rsa-sha256;
	cv=none;
	b=XMVcoupZFPlki/wJo8se/PchdfM0YjcGeXzAx7ky3JhdAT4ALhip6VzY36gNhiela3WJ/R
	eYSCl2pISoHC6hi3iFKenDNTBgtlb+iKsBlJX6iXewEtY34WM3FuJtKpVbv7zQfnXXX2F7
	w8DLgk6JjAxMPPuj1SAXfUFoyoKF9y8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mf+02rr/";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 530DB62A39;
	Tue, 22 Jul 2025 20:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2AFC4CEEB;
	Tue, 22 Jul 2025 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753217238;
	bh=U4DORizE/f7hNR9eFeDGUav+ZFR1aFMf+KdprGRWYNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mf+02rr/c0d3kW1n35vEDCRg28UcNcK336t1EvLB9wFb9F4LIK4EjPkTCxTknAb1h
	 rwxYJDBgaX+NjVqK+anuV3pRqvn5RtzuwY502sv1cd+A+YNCH0yOskV2D503NB877g
	 7rRqIsaJ8KyKh/vLrBeURSUbNJXoMkfwgpycjzB4=
Date: Tue, 22 Jul 2025 13:47:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: add get_and_clear_ptes() and clear_ptes()
Message-Id: <20250722134717.b8c9b09b8915b552447cb419@linux-foundation.org>
In-Reply-To: <20250722150559.96465-2-dev.jain@arm.com>
References: <20250722150559.96465-1-dev.jain@arm.com>
	<20250722150559.96465-2-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xcdrzw5tfsd5oxobfxykpd4am9qtobje
X-Rspamd-Queue-Id: F389320008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753217238-560182
X-HE-Meta: U2FsdGVkX19yvI0qYeXlgUe+vvwmyRl0XLpHmaRUZwMc2JzYAbbmpeFYJ4mFIOQAzF+/U7V+FmWVpWzE1iHeFCdq/dApalEN+PtzbRJZvPjWS3NiVYckZVe8B433W+nwicahJJBUwFGTPs76FqHsmQCW6a/hmSRNkq31vqEKeQAc4ymD1xdctmf4h86xuPh7ei0CGdF0eu+RxcvMT2+a/CYXSCcmr3HLk/J+pE/iTBK28emUlLmB4gL8XaFj8RJg4Yl3TdbMEqP5r3sz/kSgaB+mWIZ8sv82wlM8QZVU9pcEte4DA5YEcLBYiL3bdZo0bk1k1eHniEYj0OsEwDarK5C2oufPKxQg2YnG/Plwv+iT7GRDP1W5lrtMlFKsRk8lVXxJ9c+1ATdTv7DNaXMg4OgN2ZroMPwiOB7iA+BKsWMDUfKtdeRN9/HGvoRlz5poMCUHwzR0OCHop60BwHQbBYgGEuUwTlNg5Ozj9z9+l8AxSvLmVXQ9aNycu8LRwpGNpKY2yoH5EMBqboOUbm33wQ461CR2v4tuIQSWftP1RI2IUYA6fMZD2BQSW3fdRUwW8cq94ObPbran5FzrfRrnnady909I/K62WHjhul2ko6NIYIBvs1Hqf35FEIwdcg04RrbTkP3Ro4t3s5bCJeNPYJMXSRc7jN4ARw9vbU86L+KhOcrI4A+alkcgUtdp8ia4N8JWPT+HMZKrGiHSoELuYLzivBfyvCSjd/yW+hBj/Xn2GsC60P42X0hH17Owl4pxea1UuZPLcu1AcI0HUSAnAy6vjkdSZXZl2U9Kmgsiza3AEKt9/xbicxyvEkbiKOWiLLa5++Yv1tDNdE89n58PC2tmtR5oekDP9xMuflCokYHahg2QvB4/tMkJQynuEkAuiQJigMofWa48lorLaBb2UDnR3RmJo3nswxkZp2+fQ2N7NIAafwCyDDSCX4BvXjTvUzmWgUZqDKGMatoGGYG
 2sNsL4qF
 ovDqfzBBLqrev6nJlVWzFYkQKF7owXpFI8cEq52wTu9eh+7tyGmYjPEob1QYgtR6MuaEihpbT2nBfu/ipwxrs4TJjfl8+TiSrNZ3CA0/4CgdBYoq+sWfc05dCNg9SSN8/JG/nKAWXJQThFZ9DtJQFx4FBP9kYQ/qYjBCtuYfxYZdI1ZA1schikXqtolL7HR2x+SHO0lrTMOuFfZuOShz8/s00FqlRxJG5sUksn96KbdXDyGNSyWZXHirFfOd/htw8uP1K5rXNPS1Q1tFMdwsdgZrYOXQijjkbv6ygduvqEbXLeYPQnveBLU6yQGrbnP96qbPOPVU71G8yjc1Mc+6eYpxRJoHf41XIVTKq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 20:35:57 +0530 Dev Jain <dev.jain@arm.com> wrote:

> Let's add variants to be used where "full" does not apply -- which will
> be the majority of cases in the future. "full" really only applies if
> we are about to tear down a full MM.
> 
> Use get_and_clear_ptes() in existing code, clear_ptes() users will
> be added next.
> 
> Should we make these inline functions instead and add separate docs?

inlined functions would be preferable.

> Probably not worth it for now.

Well, as David has called for a v4 I suggest you make that change.

Thanks, I'll queue the series in mm-new for a bit of testing.

