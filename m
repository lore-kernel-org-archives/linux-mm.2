Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54371C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B416B0092; Fri, 18 Sep 2026 11:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C566B0093; Fri, 18 Sep 2026 11:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342D56B0095; Fri, 18 Sep 2026 11:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D9C6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:28:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74C3480709
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:28:28 +0000 (UTC)
X-FDA: 85227264696.03.8DB262A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id C143CC0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JTa7w1HA;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745306;
	b=pFc+ybZCVeY+PfPMl0Z4OcTTjy6BN9qPfsgqkkW4eybuul7IZRBWPx7jlit9NHYLJvbR4o
	8lyA4yj0tcoiGzq/+OtmHuO7ybNubQQcWGYwkAcRujXP3IGQ+X8ss0eEJEs4ZTe0tojC+o
	rbU9mlHgiBtcvm953b9/J0pRqe2VTho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JTa7w1HA;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/jmJ7LZZR/1sSBpc7h3MkpctCTbA/0VAY284FY63k8=;
	b=b1F2jiakjg+XenoXFGzFiMm08c6Id03Xzo3Kmjf+4JQR6H6rsOAaeWe0pb7RuDe9tXa8TR
	9OsbcuoYMuG99PpuhEM4l0TYbRDGym28FvhcoO6djtJml/si+GwDCJxWAqQFAZVpeQi717
	1mcxrZ8cp7pdlB/miuR/qzoIb0rNRoc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N/jmJ7LZZR/1sSBpc7h3MkpctCTbA/0VAY284FY63k8=; b=JTa7w1HAnYJLKRzmXqqM/n26PT
	XVERCbe9w1NQse8+JSAoioonymw9wi5vLK9SsZzoN90WrTjgDiQwU+OaXAp86a5/Ii5tYXQO0izMZ
	WX3CS0Yp/ScF6ORLsZwJdjG0A8aw1LN3XlrQpakTWPsxfB8JhzZju1bTK5R9AUbrp80nVpHrrGN8W
	cO/aaM8VEcxuEkf9hIJ8w5Fw5SYwXC785b4tlNiGKvsPXbFNEfZX+l/g9v18MiAIoQ6lzvR5ExgL9
	wCKQBPI9INQ+fzEGLXsrYkcM/qtQ7d2mMNwXEyD6BVVjQsIoDNuO/UZoL9gq9ZB+qWbNT33nHTli7
	CDjYGqYA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7aVB-006p7a-0M;
	Fri, 18 Sep 2026 15:27:49 +0000
Date: Fri, 18 Sep 2026 08:27:40 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.or, Borislav Petkov <bp@alien8.de>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, x86@kernel.org, 
	kas@kernel.org, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, Johannes Weiner <hannes@cmpxchg.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	harry@kernel.org, rmikey@meta.com, kernel-team@meta.com, 
	driver-core@lists.linux.dev, riel@surriel.com
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
Message-ID: <aq1Xr4b7BXZForCe@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
 <20260915134535.C3FC91F00899@smtp.kernel.org>
 <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C143CC0003
X-Stat-Signature: ds1mjjyfgadzfg4agr5ng9ie58xysyad
X-HE-Tag: 1789745306-370143
X-HE-Meta: U2FsdGVkX1/qsJ3h5f3HrZhvtqFwhaktn+1vaP6r4RghtVWNqkf/uZVXglhfAjlRs1jOFZWFzJwbmm8jUMdh0BfAOhgX7nIW2LA/pfQ73weh8p9atGAZE/USU9h8/Ytcm/P+PeUbnC7IMZFSpwIL5MP4ZpPc42Jn6JqyFfPreYf6sEu1A0hhQbZpUzb/NPoK5OU/qDI1ZvqypQjLLPhKn/nAz2O+1vArDhd20nGOIA+paxbva5ukuaB4A4CiZln4KqYAWpmSs08/okBP44oeczuklioLKEuiMwfaAYfcxIkd1wok9igvHsOcAI4GMZlcnaNKaUCHFMlKyiwjG0xoYZgNzxsFxFOIja7uy6CHjfCs4ljBSIo6mcf5zZgzKdK8TMcvKM2QXSZYXTo3Lzw3edaaCHJj6/LYeYStVuYPFm19Tmnxz+u+Np1FJtCMF3Abh/EuRGehwLLkv3Xke7nBOA62AgueUIgoo4+xo25p6BDVy0K4SojHsqt/qBc6ClPRF6HitH4B4hlLipS0p8Agk3kMihFRvPt/kBdvLksNq/KYan2KDZrJn3jvPEqbhA8q5/b74Jy53rikYvp1dYfLt904/fZQEeO4cRhQEfwbXb6FsNH83n9DVxPdMRrXEkidBX+Z3ba6T0eUDBVlm31UrxAxbOUm4/EOBOeTUNhpNKtHkw5pJvea5D4e56NrnSbIyQEdFtlCH3873mxF5/3NxCBVgiMUiKMRjexU4kwqZBZg7QXBSg1S8mGzjLD0SZiUVhAnZA8bamXJo3JFRzKstI8NMDGs01mM4QzVvgz4sDGiNZQsAICJj8b7nyVMewLx3PPQM/D2hmbTJzTyUMD96CSNLG1kfXo1JRreHsJAzn9Vrn5EpzLLIIBjO4iCLdZCL3xfmozHDT7XuhM5yzXN5kgMq4G22MnIfGgdd0nj/TJYFMdrCMOZtOrFUdec9MmQhyBHCbaXNNhgT3tdF8y
 a/GwLS6Q
 dIvEu4E8iLJYqTYda3j4NK/zuA42ADxlfaYm1hAPPGXkHOZSsrvH30ZKInaS4NGYKZ/gpST6mPJYwYoDPyVlQ3Hq2pevY5/SbN6/6JP1E5mn57mJiZ2ccF2aBa15um158A9veBJMTamysQ1nyF/ScinNwEfe6FNbb2rardfXHBhxrbquVCzt/W1+iotTNBS2TA0B4uIYy9SLzThF/mUmp1dfBm5euWycQt8LN0hWzvEDwj09mh7cjFeooWTB280C74XbSblOyBS/TNDq77SwuXk3JfknkpRphfKDoWFLkaxQxk0UbyvypWVcnVwkkzeRJJlsvvTc+9k8X80bhLLGEJNM/a9/qCmTpNREpT+7GedUcHK+sOvGHwZtXqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 08:44:30AM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 15:45, sashiko-bot@kernel.org wrote:
> >> The bitmap an earlier kernel filled in gets in this one through EFI,
> >> but nothing reads it back yet.
> >>
> >> Introduce range_contains_poisoned_memory(), which the page allocator
> >> will use to ask about a block before handing it out.
> >>
> >> Signed-off-by: Breno Leitao <leitao@debian.org>
> >
> > Sashiko has reviewed this patch and found no issues. It looks great!
> >
>
> David has reviewed this mail and it annoyed him.

Breno is curious what annoyed David here.

