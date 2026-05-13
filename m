Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07645CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715166B0099; Wed, 13 May 2026 04:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC516B009E; Wed, 13 May 2026 04:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6092B6B0099; Wed, 13 May 2026 04:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 501B56B0099
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:57:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14A99C273D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:57:23 +0000 (UTC)
X-FDA: 84761792766.01.E6AC8FA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E17E40004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:57:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZfbIcZR3;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7GwIAiUCQltnlUa2mOf33ISO6ume+fnsS9+fZ/PLDQ=;
	b=M6M1ne+6hD0yDW2K4L8rPNbeuzlaBNzMJVQRCovzmhyLsjH1I0dDsMqPSvve6z/tT/FWs+
	NGgJup7/hqgi5e5XX9z/1BBszIZa+29032HwMYu5+3rMYlp3VKxZFEZnLIb0jxYMu4Q0yH
	enRiNs7TjdsqrDRFxPL/dkLefMMa/8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662641; a=rsa-sha256;
	cv=none;
	b=UXCT97DcqPwoIjoVf4lhXQFzhBeVdUVy4/9ADWwRr+0aDYJMKFp0ZZWScPPN8JtP/N7Gny
	gb0SvIHE7hvmv0e4MvJPZcKa8Y/UjPW7fVGeamX+AKyMNtTt/gZelJkARjDs0RL03a0jl/
	80vxQpobPjbDJ3NdC2Y76xy8SI+ZLWc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZfbIcZR3;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S7GwIAiUCQltnlUa2mOf33ISO6ume+fnsS9+fZ/PLDQ=; b=ZfbIcZR3ZzNjzKikmMIuW0z1Xt
	IYCp1T2miKkSNFo/1S7GA14NHOaqHtkEWeOxtPxsUU/0jjJxTzr7EZFoKoGkM3m3XzCBQBXK4eRxP
	9qt2SeF86cDfdBxlFt2rHBQBdo4vZi7tjpWZ7BHujku1uzLWYbVOzbYMxsQoL1v3aohKAEB+K1qhX
	AcRLfqHON5ykgFe7Do4uw1M/+sI30aFl7kcQhpQVyBoGJ4FiUmR0eURkAnkV63usLma+wX1rXVSiz
	hfRmudlDgSH1x5zjKrhwuPtx6G3kB8bS7O1QkwCOoW6mohwKQbEmCUu8agrQJU8oW3MJWIJfTpS3h
	BWQTpHTg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wN5Oq-0032xN-0C;
	Wed, 13 May 2026 08:57:04 +0000
Date: Wed, 13 May 2026 01:56:59 -0700
From: Breno Leitao <leitao@debian.org>
To: ranxiaokai627@163.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agQ7wu0h1oPNO0HR@gmail.com>
References: <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
 <20260513082558.50743-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513082558.50743-1-ranxiaokai627@163.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E17E40004
X-Rspamd-Server: rspam04
X-Stat-Signature: quxoj1yc6qxzmoo51kg7yoeru53k1p5k
X-HE-Tag: 1778662641-565536
X-HE-Meta: U2FsdGVkX19fLpSc8YK4V8WHDACeHasIfobHhUUw5YVyf0ZHlMH1BbGzDz3gY4+neoL5SDiKAsOyBO9w5LS3Jj3XyvZJ5GyiqYcm5h1Lh4aV93ZYO3kMMlcv1c3cg3GaezkmakbWW5mTduYXKtwuw73etIOXFvpxyrYY2LG93oRkZw/IPD2vACNk6BqW2iHmZXMzV+QK83+CUe94rxNwdpThUMj0+B5FvO01KjHhkvEjuENHYzmr4oJUDSO7ElQwtp8apW9tufzdhPoRv37RP3Uts2F7roAaDPVBx8oL2J47BmQ93AoqLw6CkQZO1WrMynsUjRrFeUxmTfIVnDZXBIpirD+SxSO2Cnh5pzFT4Fh2pb8euA2M1fn1ViNpqRGiidGlKi4TfBeDKf7BmGqIoWdOSTb6NhKuyJJcZA5eWDqW+CwgZrYn9ko3S+LkD7RgKvaW75dNZ6e0UMSXwHGx4/DS8zIibeCQ9J81pNmM/yu14cWENC0J7qphkXRPk4aP0lCoW4mIH36F0NierjKciJ6yr08Ck9Kz2sBIlznF/z4nGJ+gW5D8JH+btVIfdRLp/P6F9mxDJCaq9Xgb9XuUwt4H9gaI7udicYr1F+mhTP67TVP+TzlbjxUtD/sJcsHswvHV0rRzXCwq+jJIpzvncuDQJ+3xVYmADjWjbN8M9P1DuOhWlJ7GpQVwQqsK/x2a/6VlQTiKS9ShqKckSWqi+etIqU9SdRvoqcQoYdeiLyuzRq14DMHQfKX3KmSMtCKfhIKi0qRSBZxsFZpk5f9wzPKGoIl03xZw76Qesrl5XU3+iXG/WZQ1VqdjMYL4zm4KpVDYk3e3E7SpWhbWKLfhOpD3q4gm12tA1M3BT7zSv6tsOP0sf6A4FhoTcqhXfzAm9ZF3oUW1eegLyfQuqbAAaF3+IweF1RlM/K6BynX5nE36m+A+5YqXMAV3JdcDWKW1YoOjLq7t6mnyryBsYWA
 ZRI2r+aJ
 1MGrcBg8WQijxw4TyItLSBukM5tzRetWMjjlVomWuXNqp6+GJcwy+VO08boDKxG+ilUxzTBggSCID3OEXy96xERl/kBx7ygesvPNz0+7YmJVoQcPMkOAHUHSnI1MnCKlP2M4e+e1MtZvyLSGLNAkkZkl2K8XWZ+uaNAxkAQwD2qyBFbrZTUXUyWduB669sIoKaCYGHlKI3Z4x3RzfR+4KEHMDKvdKRjz1CnDVCFlTjRWJ5yTieHmQH8d+U8QPqnnGcZrP8AJIjitDxEmGGs9IlOiXPnQQ2FGQDWoPEZsHWsyZfV6HN01XVuJwHe9e7cAkKxsAP6QmYcqH44lKOWN0YQY3g1THWWnNsFa+airrZLLhKe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:25:58AM +0000, ranxiaokai627@163.com wrote:
> >On 5/12/26 8:05 PM, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >>
> >> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> >> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> >> thpsize_shmem_enabled_store() using sysfs_match_string().
> >> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> >> calls across all branches, reducing code duplication.
> >>
> >> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> >> all test cases passed.
> >>
> >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> ---
> >
> >Thanks for doing this.

Ack. I appreciate you taking the initiative to convert the remaining
instances.

> >Moreover, I think we can follow commit 82d9ff648c6c's approach: if
> >nothing changed, we don't need to call start_stop_khugepaged().
>
> Thanks for the review.
> Yes, indeed, We can further optimize this by following the approach
> in commit 82d9ff648c6c.

Agreed, that would be a good improvement.

> It seems odd to still call set_recommended_min_free_kbytes() when the
> mode hasn't changed. Maybe this is to handle the case where the user
> modified /proc/sys/vm/min_free_kbytes in this timewindow?

You're right that it appears unusual. The rationale is to avoid breaking
userspace for applications that may be 'triggering' this behavior by
rewriting the same value to sysfs. While this isn't an expected use
case, we need to maintain backward compatibility.

The discussion around this took place here, if you're interested in the
context:
https://lore.kernel.org/all/ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local/

Please CC me on the next revision.

Thanks,
--breno

