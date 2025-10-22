Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD87CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAF98E000A; Wed, 22 Oct 2025 01:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2038E0002; Wed, 22 Oct 2025 01:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EECF8E000A; Wed, 22 Oct 2025 01:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC7F8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:48:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 070A6C0635
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:48:47 +0000 (UTC)
X-FDA: 84024671094.10.488F451
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72394A0008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:48:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvsJ03pG;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761112125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vijkhvdnaqXUNXUQBtHoef26B1+6QgZ0Ag5T8q8C/Wc=;
	b=zrhHUi0EpkEeePHxRkV64gc5DZTo3m24zNgC9jDngQo4uDIxuVrHyUTbqVAld1hgFFOeVf
	3WuqTZ+R2lBGU2/nS06qm9Whgz8k4FOrl3JtJvFDh/H9uflaLlc2HJM0waNKL2l0acxdvP
	nngFkNLr/LRRCzPNgwJFtB6S0SAJHh4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvsJ03pG;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761112125; a=rsa-sha256;
	cv=none;
	b=pe5a/sQbNHmAe08qb+vyLVS1vyS87UW5oLCzi2eRE1yhfiIKpyPOHlOfw52sqgBRZANt+G
	mSRLJ+xQDUo5Nl8SDYKqHdcstK8VFDWgzz33XdA5fkxLioFG5YUu8/9K3ZbqElHFLfSQWk
	S3WereJMerauuokZJVaKzPJGIK5eOpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F89E62820;
	Wed, 22 Oct 2025 05:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65C1C4CEE7;
	Wed, 22 Oct 2025 05:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761112124;
	bh=fcipi0rhSVh/MNjzf96g6xOkImIIzAGSVFrNKZ8ddPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BvsJ03pGBLi1YmtCZ8C0D8WvcHS+RmRHNPZql7RGpbklXYte0LYpupraBCS4xOuMO
	 7tx5BZOJK7thCe6TZFgyOrnoF9I6bfopWVDyL/y65ALY4qy003kQfaka63vmfVR2Z/
	 QSY8SeskvpY9pZE3E/eEtDypZcHUmieSsMAhRtnVIItxCjfIL9qb6gKYQIYYQLGJ6N
	 zVjxCXptAk7rZJ4GIBdloP69N1KCaa0pooMlqHjyNLSBRZPZFANqW8glt6eGdpk20c
	 SH1aazS15ehjZq6kUZtzL0EPiK1//rZkPY9t7G2A6GPPq+s3MgrOUtVcQ9c11GmMYC
	 PQq/bC91NY4Sw==
Date: Wed, 22 Oct 2025 08:48:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, brauner@kernel.org,
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org,
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Message-ID: <aPhwMitTY9De7md8@kernel.org>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <aPchmxfh4ACM0vY2@kernel.org>
 <CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
 <20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
 <CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
X-Rspamd-Queue-Id: 72394A0008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c66yhntptkzyq4pnsf8ggm7oi3r84wsf
X-HE-Tag: 1761112125-111808
X-HE-Meta: U2FsdGVkX1+QMFfhdpPU1MSCaIeTjfEo75Tv6a7CQG8yKHA3piIp/rejY3/0JFA61N9ozu8HmMHy/SCl8ejTEY3mRle7b3AVOUy9nxKYZdeDPpeT++0drza8hd+Ot40Fd+AdBGL1vf2z+d8Oe8SINgUpI6piheja6ttq6sT0aBazjqWwPtuIQ+E7rk43Gs5BQlLtum+tkF1xCNTCqwLi/nwR5hwtlNFNVerWIb1GD7wS73VsufaadRUtyPT4K1ezSv2CkkaUciZo7EXepgMq0nUVS1/d+X9glfYZjTEymsbCd2QZbz+f7D5m2k/Zii9PEzI9cdeQa2p5n/zAtNpdJFDzgX8wl18kcgTVC9ukS/CdMYAoKWH7DyzEviNNQh4N3Hdi9pwWTLm+EJIk5EB4TQidQLEuDld/NeH4oLZaC1ig7zpDYI1qPsdKluKt020SfvGCrcMw1qH5B3ZY/WkArw6XZ8odwcFwxDnMJ6w4wmiN19Nf+z6vc+nXlW8tHzbotQynOsrtFEggFILVXf7vvbFlebVZESPeAmZo8D/P+r6cTRfqvhUT+lVDvamc1bVCRwqz+XTB+SDVh+yxVa3tGu1IOzybz8rE0ZecaaAc4pyd2XxLtx3oz72EydYZlcA8ZUt6EaHbCsOZrwLPiLtsdwQgC/1L4n0omDBm0w7U36uXye82hrVibhuvcmQm5rldxUiIYAKevaeBBIq9x+qDAbECkKiYZ/iUQ2FEb3tMV1tUScK6KCISZgQDFOSGzOiHl/YlPtrm4iOVaLp8PJHc56XtX2NzyDNlfDfE9VPulfULiPDy8GrXyk2PzkY1cZq3/R8vGE9D1h54ftNa7tOxIXANzqBNzBl2961HTVzW6o7BlQjNLAWHbmc0DYqbirlqEH/P6M/ygVpXwso3qUUziwFKiuIDKqTYbvbOmUolwMgiod0DMnDNM78/hOSh+92Yaxq78SLY79T+VTTfP3F
 nvwry2oL
 PyU498ZTtH8zgabh+9Znx/AO2cY7MRplfdzOwDqDJXK1t52TwPXjl3Z9CxATecaXcO5nBSLq1YwP7S28h71v2i+EXcuB6wolCrTO2UAcYBzIHKjRw3ovkVOKFpdAxIxaW/04sbyT3D8qxf+HoIc7im5TiZHV6Bp25kksl+EsE5wOuVdIX8spIjvKDST99v+rjHznuo7N18Q5OBwegLA7TU8Ot57DtxR/jinm+5eQ8x1oBJ8y1ez3l9UBh6qMk1bxmH6aerughB0zTQXWNP7JFwAxwh4Kq7blDPFs/I+7VBmy2sV+cYefs5pnZMFeo17/Vu57GwID15vKbX/cXYNAuL6MMcxQ7DKD03q689Ld5b+XN89ds3jpOCdxefnJfy62zSI6tJbgef+KcQ/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 08:15:04PM -0400, Pasha Tatashin wrote:
> On Tue, Oct 21, 2025 at 4:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 21 Oct 2025 12:04:47 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> >
> > > > With liveupdate: dropped from the subjects
> > >
> > > I noticed "liveupdate: " subject prefix left over only after sending
> > > these patches. Andrew, would you like me to resend them, or could you
> > > remove the prefix from these patches?
> >
> > No problem.
> >
> > What should we do about -stable kernels?
> >
> > It doesn't seem worthwhile to backport a 3-patch series for a pretty
> > obscure bug.  Perhaps we could merge a patch which disables this
> 
> We are using KHO and have had obscure crashes due to this memory
> corruption, with stacks all over the place. I would prefer this fix to
> be properly backported to stable so we can also automatically consume
> it once we switch to the upstream KHO. I do not think disabling kfence
> in the Google fleet to resolve this problem would work for us, so if
> it is not going to be part of stable, we would have to backport it
> manually anyway.

The backport to stable is only relevant to 6.17 that's going to be EOL soon
anyway. Do you really think it's worth the effort?
 
> Thanks,
> Pasha
> 
> > combination in Kconfig, as a 6.18-rcX hotfix with a cc:stable.
> >
> > Then for 6.19-rc1 we add this series and a fourth patch which undoes
> > that Kconfig change?

-- 
Sincerely yours,
Mike.

