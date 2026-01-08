Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A5AD1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9716B0093; Thu,  8 Jan 2026 00:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83136B0095; Thu,  8 Jan 2026 00:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD196B0096; Thu,  8 Jan 2026 00:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8C116B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:02:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B4211B92A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:02:15 +0000 (UTC)
X-FDA: 84307600230.23.599B819
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9E1E40017
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:02:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MuHyXbUY;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDQLBDH0hzNYWmGjfmTHWfMT2Yz8OM7xrwWEUEcAt/k=;
	b=nmonC98cGIVzRtU7xVWB19oHhestp/V/Y4TGYfLGIlN8g0nzXDQh9/v6JPhlDQLJNUaCPe
	5WGexvZgLo7oyDhKy1S4a7HC+Wzh1wa1PKwbKaX0bQkCzLLd05pcv+wcqbu5aSZlGfRkk+
	Lz2jj0LmOhinxN/T/LJtJXeOE6D320A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MuHyXbUY;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848533; a=rsa-sha256;
	cv=none;
	b=0bSPar9Q0pdn3qE++F+zRfOs3VHHUdmHWcBu7jGk12o1QE7/yfq+j7P0SxDlLSjJuwgzOI
	4JrGuLCjC2QeFpagX9st5tJaFyqaXM5Qzn/zBPV5dDkva+Goruts6cOi3I2tF3slse3Vz2
	hAzyG+j4NmieF5mvn6KuwQ+JMpIykUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1F6A60097;
	Thu,  8 Jan 2026 05:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488F7C116C6;
	Thu,  8 Jan 2026 05:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767848532;
	bh=i4vxDHGS1uCPrVEmpsixJJW62XNo1Hexm5sGNP4HlFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuHyXbUY5gsIUFy+nPKOl8ADyxIguPI/IQJK4MooIQvzrXrOv1dSjqvd6sL2FTTQR
	 dsTx6NRFmFE2kFF02ftOKz9Tbk12OTfkey2pgxVBKE4M8YiqnfDabVxUdcmeeuT+by
	 ldIlmHeJPMfY593xmKo4ys6xlPvD1ABrhoexmOGv8qm9Qc9qXBmQkw8oy5n7Re814Z
	 HetvJrum9TH1HffpcDkGris04F2JqKm02pm3EhhOrv8N+L/wx39iNNM9JHIkvENVQO
	 rFFouuRy85Cu7GLmYcLuGTEa7eBpXQZ8nlsuoLG6bQvEuHr7glgbhOm06G0AjnziCq
	 r58hBkxQjP9/g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Wed,  7 Jan 2026 21:02:02 -0800
Message-ID: <20260108050204.78666-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251227221206.282703-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9E1E40017
X-Stat-Signature: 8scxee11wsmrbsht9gdr3g63acs87kwd
X-Rspam-User: 
X-HE-Tag: 1767848533-673023
X-HE-Meta: U2FsdGVkX1+BJowvhzEqPleGi+qSZI+mBSe6Jg2JxNh1byJ2bZTOwGCda/HLntPRGRNConlOCj3xJbkpXn6vkr4COCwXg/9EOz8UkgThSw/9xsL/nTZgfJuafQOmtqU/GJIfkjGbb8476BfnBcPySdBT+Xbvt+HN2XICX1fVmCBzJ6sXloI47BBYEAR0pi0Lt2MyoeHBLSULTSpQMwQPgQKPEJ6iIqAw6BqknpPDURpgIqQj8KGzYwJ/2EaACqsGIy1wRWVOrfEAZ+YzBi3l61Uof3TWwDPr4Gqdt/ewiPXMWuUubbYJmOyKooRDJpK6cteTvR6aw0U9a2xOrS6jLBulkLDmmlhHuHN/XkoCMQFcg7l8wvIZW2yGrguAKkPftsZcLl0rRMMpfVtvRyPRoDEs3B/lKP0lt2x1RK2p0gw5n8saOja+rpqdFbhvUdpfs/Z0ChVUQ/YO+VkLMycXH8wtHnY5+xJYdbSSWZprAalZld6jbLWmWdhZX+PwzZT+bGeKjtUV+IFJ0MoX/kjOynY9ZOn2NkcDNe4tJrA4+h7TyvmSIeVfTPQufEjtrFvvXMYNFPRRLViH1EeI0810IT6QNoylz8v8HHST0qukOowP3MYLA2sVRebdz3YY53nSU2/KiUAGN5PjJ+pdlVvRa26IjvNiDzMMD3jmxyXRs2d7qnO2gkg3j8bb7zSfyeE7/av2eWznL+wimGch/2jC9Jrqqle6K1Mkx7D95e92oRrZB7lbmA1JD+QzgyXtjk8+gwUXqaEsREX3Jcoh66SecTcQWNpYY6xfsWmt2PoiGfNJciYokHQJZ4VN2bd52pcq6UFQb+8yTfo3CDeFya97mDsvO2+JatwFwMPOQH+1IpjS5Xg1h5QFbFKb/FrKdLAAgN477wfaXH4+9b/KvkxdY/b42MhOf+J2OLRIthYYemWqFTZiFHOpPun42B6Gsslv5PHJsVDdu74M8CKIlak
 WWJ7tB0Q
 x8akfWD2wuzaW9tkmJVtLb2xMAb8qMxhaR4BadggDWMwKu4lRyBltfmrWO/JmVVkY5msk4WfcwvRwRl13Q4IW3koj503Srxgz/7u41ey6PKdvU4+x/2IXgX0qw5HzLavYFSbpjjZi/A33iB5e6eoKbqsxSu0yr8O2V1x2oNCFKDgHqk4uu1KmB+qMb6tFE7B69tTgKCD3Ks9MvZpt4CLOKfuF+h/HjIqVBplgfA4fuRqcX1NQ59D8aEuQbDogqABkspmDJylhdb8TlHQ8w2DqLKLLPX5nAXagAK7mAAbOCmjDrF1MshAUSUGwiXRy9QtVYzmuxkzTlC5AZtYqpJ5vhfR2SbxOh/vbqXDV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 14:12:05 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 26 Dec 2025 20:31:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Shakeel,
> > 
> > kernel test robot noticed the following build warnings:
> > 
> > [auto build test WARNING on sj/damon/next]
> > [cannot apply to akpm-mm/mm-everything tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Shakeel-Butt/memcg-introduce-private-id-API-for-in-kernel-users/20251226-072954
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
> 
> damon/next tree contains some debugging-purpose only changes that not aim to be
> upstreamed.
[...]
> And this issue happens due to a damon/next chage that made for only debugging
> and thus not aiming to be upstreamed.  Hence, no action from Shakeel is needed.
> 
> I will resolve this issue after this patch is added to damon/next.

FWIW, I ended up removing the debugging-only-purpose commit from damon/next.
So hopefully it will not cause any noise.


Thanks,
SJ

[...]

