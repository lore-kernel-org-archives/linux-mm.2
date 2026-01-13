Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2B6CF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 00:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08FD6B0005; Mon, 12 Jan 2026 19:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C2C6B0088; Mon, 12 Jan 2026 19:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9984A6B008A; Mon, 12 Jan 2026 19:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89B8E6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:55:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C41F1411CD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:55:41 +0000 (UTC)
X-FDA: 84325122882.13.2F830E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 584A5140008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:55:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCMcADjS;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768265739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AtBB5Oc+AK/IkEDi4NJKFpJRL/0v/WmXKaIhaD7PDQ=;
	b=Oh5mFDhpYwWIBDy5RfgsaiSOSY+0sX7H0ciuoe3B7l3EYa8lB1uATUItIpU8CPLCfNU2j6
	Oa0aonl5ocLLkV2CIk+4Uf7OfvzluQdd4zg27NBrrkfvPS7RgOK4FwwuCWDNUzIg7k28oO
	DRz4BbJQli8sOFy283w96tGVBETSW5w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCMcADjS;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768265739; a=rsa-sha256;
	cv=none;
	b=WEbikkkXVCt76wDH/wTED9lleZMzZFfv8aypeYMaKCFSNJdFsNz+1gik6WXG7JXvS1MOo8
	ZmcxicMhLmYlbEDZPQ4PgvtTuL3A32v4NPdXuf0GYWqVYUHocLX6agyCgdDyeWup9igxgy
	vNAsXx2vvNcSvL/Kv7yWqDxVezr1Twk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C1CB42E0A;
	Tue, 13 Jan 2026 00:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B84C116D0;
	Tue, 13 Jan 2026 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768265737;
	bh=3LvNuOICCCHw8CTVsMV6TZmC/0QdeBlW1az1MITCPZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCMcADjSLPpfUz0wKUSqyDnBWj7xSrzlcrrAbUqCguD/fDiPKTzQMbPKQvj32P6S1
	 pTg36BIEIm6C0U3/yY23Wp/BOmg9xuW8KMPYsMJjJLdnWx3I3fNBN8VwznKIESGSTF
	 Z7NJ3lzCIJfv/6BojwpA3WafvpcyfuDT4IE/d+AHNEDPRlkA1ix/prtRo91R+fMKE+
	 5+UJ95BkWxMv/5onpZL6VlbVsJBNL9GDG+YDGoCBM8jF6Q70OEDug/pmokhnGnGpsE
	 6r26Au+MjkWOLokrbbnX7AyGhW2XHCtBtdCb+F7CVCdlOvFNjRHCJBPOONysdBWMQK
	 7FsfC1q7XgzLQ==
From: SeongJae Park <sj@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page in range
Date: Mon, 12 Jan 2026 16:55:29 -0800
Message-ID: <20260113005530.101000-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b785754d-ba6f-42db-9e44-66fd377aad03@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1qby45i89gtwztz17fsc57gdkayshyzx
X-Rspamd-Queue-Id: 584A5140008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768265739-392003
X-HE-Meta: U2FsdGVkX1/Xq3aGv8DR+NSmKzComRak4MiWK8WwhvGI3wEYCT5t/6jXELROEIko39woVefvxMd8q7w8qE/3PNAxqb0k5clS89PWNtKezwArLJ15OPh0nkgdjsFKfoXfHuNvdDpLdYxbOC78X8HL6IH8KYsar+UzKC9HmAvOqIrXDQZ+rPsVJ+fPjMB7LCTkTSor0kdqSS4TH+0S2BJIT4X/PLcK7AXXrPhXXv+FzBm5eLLa1yD0OIqniudiOIWnoKyzfhuAbGkDZaIHQb/nnkkotyMUyVw5dqv5F38SZQixRGl6I7FSXZla+uzGVmXjFE79PnOK+yMWWsHTGlamkG8L+QhCjglH5gVcotqSmVMRRoIJ+a+/tQNV/j97FbDygJ8WAPKhaFwWr5pCeom9vI+QyPynKXvOFNtkpNVFD7zkanB56QVDjjtpPrvRDMr+Rqe9TuwrfT8opXWlQBRJOGC+yBhuSo/lE2DUPyvpWhEkkAn5VG/nHxd3RnxJPqmZ3E1l072Su1OS8tEqnfbg2CSSkllmfy4mYkLOiiD7XtA2MsJn4A4+Y3Um4+QA7GVXv49wVD37M92m6yUfn6wvS+K7+b/rcL4d6fz1I4yuYlLcjMJHsm56pbY69+gelcphacOcmwRevBrjRzfrZfiOj9OCfEtIN1ojB/OWsnjY8StCLmgiSDEJFpBqKVlqLnHv6f88UhqhZqiVlnGvHoTn4tuASRpikl5OTa0lAs06Cn2a0IpsH6VxGTcf8u7UT4vxCEFfx70vBcd7xuFoTU2LL5yzSvdun9sw/lLnVKl3dV4sFxQ8dQULen4UO0Bi5ogYd7qrR/8wcLm8jtewTt7V4jS0TcmtKnA+q09V6Bwbk/hntq0zpAF602rHQle9F5MKYgBtiLDUObNvJvt8LpCEKGAALQ6PUINT2ZLk1vfZMR9RnwdFk+NIgbwoJ0/W+dTJlp2x3JRRZ1NoPMdR8OU
 B96j+Fn8
 wp8kST2ZpuwvUKGdNHpEu067PWmI5cu8Kt43SjWrfVpVYnwzkp3n9OFBKGNkK42gk/QZ//AFbj+VjX34LVJuIOX+FpSHbfcpYCmwu5e9yntN/yfX3vWXoQP0uPR4nwWJvlx0ZgWOWb3sAn8nD7uE+g4FfbYKORG/gbRjRQoaxu6CrMw1IBoxrjEEDMFMfG0B0bhOqElwhOtgIRRUerC1DIXd8158To3Wyu8lxWOT5rFLVFPVphQarZnLI7FlqUMxepn8lMkhb4iKw1ZWZYctAgayZYAHOPD97oUvX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 10:37:26 +0100 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> On 09/01/2026 02:30, SeongJae Park wrote:
> > On Wed,  7 Jan 2026 16:48:39 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
> >
> >> FORCE_READ(*addr) ensures that the compiler will emit a load from
> >> addr. Several tests need to trigger such a load for every page in
> >> the range [addr, addr + len), ensuring that every page is faulted
> >> in, if it wasn't already.
> >>
> >> Introduce a new helper force_read_pages_in_range() that does exactly
> >> that and replace existing loops with a call to it.
> > Seems like a good cleanup to me.
> 
> Thanks for having a look at this series!

My pleasure!

> 
> >> Some of those
> >> loops have a different step size, but reading from every page is
> >> appropriate in all cases.
> > So the test program's behavior is slightly be changed.  I believe that
> > shouldn't be problem, but I'm not that familiar with the test code, so not very
> > sure.  I'd like to listen voices from people more familiar with those.
> >
> > Meanwhile, I'm curious what do you think about making the helper function
> > receives the step size together, and let the callers just pass their current
> > step size.
> 
> That's what I initially considered, but considering this discussion on
> v1 [1] this doesn't seem to be justified. In hugetlb-madvise, reading
> every page instead of every hugepage is unnecessary but still correct
> and the overhead should be negligible. In split_huge_page_test, I don't
> think there's any justification for reading every byte - the intention
> is to fault in pages, like all the other cases this patch touches.
> 
> - Kevin
> 
> [1]
> https://lore.kernel.org/all/a3ca6293-8f85-4489-a48e-eb8d0d3792c5@kernel.org/

Makes sense, thank you for the link!

Please feel free to add

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

