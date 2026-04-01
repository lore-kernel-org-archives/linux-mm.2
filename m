Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2698610F6FB7
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E676B0005; Wed,  1 Apr 2026 10:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6516B0088; Wed,  1 Apr 2026 10:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8332D6B008A; Wed,  1 Apr 2026 10:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 715486B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:54:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14CFFC23A1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:54:01 +0000 (UTC)
X-FDA: 84610281882.04.4DBBD6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 70E4680004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:53:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JZa+fA6P;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGNQwjNu+PHUefsK+z9OAHHg2aKtydAnKWUTN7FLa6o=;
	b=4BFennQsHbPy5zyKPcoTbrvbQByGoWFFeYLtGNItozk5Ka3mTv6zqP6y5anFuOMXqGTsI1
	oRJJ0V/zq2BXnSYtkwElyN5odIGuJ2+uZcEJ6ujVX171s1lo7aT9BpY6FhSEBCiPbnVlm4
	qibyYIHW6jElaFbhHbycWuBlyhh8Dxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055239; a=rsa-sha256;
	cv=none;
	b=zHHCppTTfzMp8b32G1ACPE5p5CWYzR01q1nJ6fZJZ5sdZQcG+UvmgpnjU4pBoJgOdeNfKi
	kpHu06gXNXMbPjl1pZ1ftSscaxAA/VuVcgBskRdaqcFOu9fK1VhG7fJiS4GmfLwKeYz5Ld
	vS77xgaMBGIkL3SMJry0DKqBizqavIc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JZa+fA6P;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF328600C4;
	Wed,  1 Apr 2026 14:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F140C4CEF7;
	Wed,  1 Apr 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775055238;
	bh=rFGY5ev9Y7kYDBfSHZFU8byopPvN3quU/Jr4BYZzu8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JZa+fA6PKYVV0qjX+7MGsijZREV1+8Cw3pfkbInZDs5kFqcLMnP+RtCTstbrwzk18
	 sZCmLUFl6Jmd6it8307l5kdUYAWPJNyzvWcLPrEuR8fhgAaMzrwx72Qf4DDZRMcyCj
	 u52swkCc6TNon3cCLr6KnkRvqzp+lcKPbsLo3j6TcOoOnlIdRSEzFR9f95KGiX7d2D
	 wDSAxiMRnbttyAwlf+xwBDpnsXlJ2gsXno+1X7rKok/2cm6+JsnCH6L2sWB/4hyiuT
	 EPgAlh/K/pIPHY+wW31HQHfpBSuRMkIUyeG8BD4UhyZt84a+YcLxS95qnUFAePNRUG
	 nClyVxDdQ4hNg==
Date: Wed, 1 Apr 2026 07:53:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, WANG Rui <r@hev.cc>,
	ziy@nvidia.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com,
	dev.jain@arm.com, dsterba@suse.com, jack@suse.cz,
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org,
	ryan.roberts@arm.com, shuah@kernel.org, songliubraving@fb.com,
	surenb@google.com, vbabka@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <20260401145357.GL6202@frogsfrogsfrogs>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
 <20260330160942.173324-1-r@hev.cc>
 <acqinu8H5jo3Zw7b@casper.infradead.org>
 <b6596c2c-94de-43f4-b30c-c9361d55e3b8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6596c2c-94de-43f4-b30c-c9361d55e3b8@kernel.org>
X-Rspamd-Queue-Id: 70E4680004
X-Stat-Signature: 61on1gw3zf364bi17pgzmoxhidn7pymw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775055239-891983
X-HE-Meta: U2FsdGVkX1/MJU06ud4otp6h8IMxPAz4Uqe0mOwtq8BLQfpjQYvtJhXUulCuR8ObGMuzOALoKIDZzQJnXLecY64o1Oa293E9XHJrMvK2vtwZK2gF55K+vhmjXqEfJ78Dq5fPn9qv1UGTYbq7/Mq0i96YO6Nh5rdvVrWuZ7N/mPioMfhQw0wtBtuWyc/RBkxxG3GLNGVQlttKgQtkNotuQt6mAT/UDxRqYs9To6dsXri61YLyZBtUtorDoiPYKhzKOEY8pao44erBbBFXWBGX/1zwGjIA+6+ZWBr+22Xs8jWZ2NPl1/X13rgbo0RW4ReGHr5ulZ1Msts3F5/rxtiLyt56QOnSrc0d5IQBZbgKxbSm2mCXHilrWp4NsuYNlA7CUXEQKjoa+oWF+QL+Inlqvaj10HPBt8RaGg2xVq6bgVPHEtIWG1RAD8up7ag9QdZB/eRvQdlrdudIgQsCFF9In2WQ40slz/db5z+8gBA+OCvB3Ufo7zQlx9ayhIb41HQyIEaev4LBr1APy2YpFqW6VXV+T1dwgpCRK1n6vMo0wZejyNnvoBj34O3fG6VN+bGU1Spm99aG/SULk17iZFw8t/aCJBfwijnyLc91h+vbRZ756f40PwXS1Ju6UGOfQV0h0Qj/Q1lDpnkjJ7FRAjufQZ5rj9b4N19LXqwr34D7udauXpfOm4Cp3BjA9jPG9hpSQwRE7MsFlu03RrXd+F7AzUGrijSdOSnfR2mA5NoGwqA04RlYf/alSmyHpzPMLeCWS3zBN7LZKS10p0GPdRjlW3UAHHabqdjmciIVpPdsWINGeaaEQjjDwTJ94AR0IMDeZz6iZIV/2BX1zEsGEM8YNWxlu/GGCAf7OGJUsM6H3JfUPuabqVDTXLrBj0kJWonDI7SRZZoqJDtJzJnuSoyfY5P5Y9MaV57cyTIUzpXEn09mksR04JbBhvHBxmqmxc70F64W1cRsQqFQJ144NbC
 fFMtOZpk
 4efHgB+bNtmyAzm/GJ0FFZg27fbbjS3OpCr6m3dPdBRT2cV4NBPorlmuLMyYoZc1N4pacJTAQu01/xusrGyT2JV2ghFPF8C+XpozFQUE82KZxr96Kfv1l6hQMt1T/UlwN+IqkTvvOsvv2QrCl+Bvce8qFhXENc6JrG93kfZt1hy264VIOddVF3I6euOD7aVf2BZ3fuD8/xqTeL1ZYbGAZyyGJCEyyA4WJ26WZYSlJo8XEapC+Z2MZ1Tqj+/hVhVkJkTFSlbWb+wrN+ZaQd94JdtW6wrn+KoRYmCAQJRup4dh/mh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 04:38:21PM +0200, David Hildenbrand (Arm) wrote:
> On 3/30/26 18:19, Matthew Wilcox wrote:
> > On Tue, Mar 31, 2026 at 12:09:42AM +0800, WANG Rui wrote:
> >> Given the diversity of filesystems in use, each one requires dedicated
> >> engineering effort to implement and validate large folio support, and
> >> that assumes both sufficient resources and prioritization on the
> >> filesystem side. Even after support lands, coverage across different
> >> base page sizes and configurations may take additional time to mature.
> >>
> >> What I am really concerned about is the transition period: if filesystem
> >> support is not yet broadly ready, while we have already removed the
> >> fallback path, we may end up in a situation where PMD-sized mappings
> >> become effectively unavailable on many systems for some time.
> >>
> >> This is not about the long-term direction, but about the timing and
> >> practical readiness.
> > 
> > If we leave this fallback in place, we'll never get filesystems to move
> > forward.  It's time to rip off this bandaid; they've got eight months
> > before the next stable kernel.
> 
> I guess if we don't force them to work on it I guess this will never
> happen. They shouldn't be holding our THP hacks we want to remove hostage.

+1.  There are too many filesystems for the ever shrinking number of
filesystem maintainers so the work won't get done without leverage.
Leverage, as in "hey why did my fault counts go up?"

--D

> -- 
> Cheers,
> 
> David
> 

