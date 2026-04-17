Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66ACF43697
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C433C6B00F2; Fri, 17 Apr 2026 08:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF36C6B00F3; Fri, 17 Apr 2026 08:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBC46B00F4; Fri, 17 Apr 2026 08:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 983DE6B00F2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:41:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45F84160198
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:41:50 +0000 (UTC)
X-FDA: 84668009580.08.FE9EAAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7B4E7140014
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:41:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPB8bTUB;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429708; a=rsa-sha256;
	cv=none;
	b=KNVpDtYENa2Y9dZ0suCig3EnKBNKiDiKtHj/Pcz07swAtJ9KIEi+MTuWiBXlVj+7HY7C0H
	n7hmhPn+7FldhECP1t4OQAPYEBfhlsKRwohKOQFmYAyTjUVYyZw6Fq1zIYVxkxDJORt9bM
	l3s5vP2bat/7o7xi05n1EsJV+iFYgzc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPB8bTUB;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSZlw115SfnlZoPEXj4btccD2efJpbNlyvD7c6PMtbY=;
	b=5V06QDkHDEJb1wYuff+W5GOPTkqqd+4raAJ0tRYJ5141+5ibD5pdnRiIhpSziEwkvD2NSM
	5/PuDsnVa+lYNWbZUaSX2Hib1f9wiRejsoRew4Vdb3wGLoAE34fsKqMYfngNpOhNErLPYj
	CCoTWRGdQNMdumHHxyuHnmCYQsKrOx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C37F660138;
	Fri, 17 Apr 2026 12:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78DFC2BCB0;
	Fri, 17 Apr 2026 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429707;
	bh=GUBplnlCMi99Gs/84QdBPA+gbdFXK1Nj+AsexHJodlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RPB8bTUBq/1b9zMrL+pk2CxwlWv75pQfDdbN992NdkpZaIm0PK8auIyMKGKgx5VRb
	 U1CQsjOc3RzHsrCAjFAUllRWTWyrXwKefCh5YeqxUtd7jiPFJ1Dy5SECInSHTkpgQY
	 Opxv6KGhj6S5B4YQYdYAY7ZeNc7hr3r4/K0jmzE1G+f3gdS6izQwpzqfVYLivzalhV
	 TY0vOSx040V87BdmFuPB968ekB9Th5rHsOCUIippdM3228DsPzrwYrS45plgww8gCu
	 nWhQdWZ0Fc7L2HCf3iPq6b4FZymLzqgeAekH+CEqMTAJutUvk/XTgYZNhAgzjEmjEZ
	 f8O2zhXC8AWXw==
Date: Fri, 17 Apr 2026 15:41:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mark Brown <broonie@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <aeIqg0m3YL9OAyH5@kernel.org>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
 <aee4e68c-077f-4056-9d40-69bc849d1538@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aee4e68c-077f-4056-9d40-69bc849d1538@arm.com>
X-Rspamd-Queue-Id: 7B4E7140014
X-Stat-Signature: pyqmwaisfgeme5k5gbsstoqd7tq94ufq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776429708-841628
X-HE-Meta: U2FsdGVkX1/jSJr+aOxDYcR/nIevhBN9frLU/Py7CKJweKkcVe5GemK8GpO5ygnVhbA37Pez66TuIYKHeOcm0quE1zs6+iy0BnZnLhbtf8LTPGeAyskws7/R/WsbR18w2hBf0X0QBubPuRnjNg00AwW1w9xrEeHyWmm7KUp9zv4yI9DmJh/n9I810gVquh5nFzeprGUsSvNz94XJOhcVHF4objve4qGJSKFTcP5yWG5mpiXFIYSocvGhD4osMKAAcWRendX/R0+bNNaauKgpydgX94p/7KHgx1c5AcqeUpBPmAUvVPufrgbm2Z/k3lf0Hp+mXJ40saDQ0Maz4NG6YvII6EOT3bZ4oM6uo0fjUgXjjQr/I4HVOaeHxqdU9bapmzkyY2uYpMTE1dKEn09Rec22KYZVnU/kXFNC6IoMRqcS8Y7vDuavRg9rQNDmTubd5mnlzUYQvH+8G9j+wM9rLDJWYZa1hPUJvK1fy6niSFFFKQWA6zJ0I8DQSp8cbQ8wJv7RGajKBnd0PHm2BjdXMs4dNR4nYa8EOFnKpiy1uIHyJsLmDaZ9+u36UNeOxPcx+llIgV+X69coRSPzf/BfI0OD7o+JdavgQfO6eMMMCparkAgCGe5KYWT1iKNnK15kxUH5a0GjZHbccgQiwe2G3H6K8zt/Odowd9rSnthvJzXkKtjvrce3wOdU0eNuOihgQrLuRXd88YQPH1M570SXSxm/5IP9QUD696k0+d0pTUk4THXtAqS0bh+ksqxdSRvvYQ5ZMm+xub0fB9LT494gdJfwBRVN5X6TwFoBUiHjYwVNQB+tKS7tAwDrPFxtwCmpvAOx8vV/CPO8qjqoRfoQLeZfGUtpGJxkB6l4bcUt4dWHR3nBIgeI6J4KhHE6xTxIdcnAYmV/aNGrkvP6ZLn/eeKTRXUZ8Zz9sGH6CIJPv80UpdXhE4W1IUqXDNlZjqxrDJ6NC4UZrA/1XLdecmm
 6hMLrmAH
 lRhu6I3K9DJCaDAeXKPJNx5YfrIvcRFyVTK/OOfaWqqRcZOs2cnrNPskUejPtF7WVo7916BSLulhRZSufqrmhJwcn1QS/SjE5xxOGXKH6uNlgLVumSt23+lxNtV0R7JlPRacIKt7jcquLm0V5dP7odyql4OxcNjUzMPATTv9jDegNovCHZnM4ZPgoSYjDda2WB5fN2S/XXQwLxLwR2L/dO0KuD1odZGpr3Knbek2L/4gvJIsg/zSO/ju8rN3AOgWmij590ycSUXHXkv75qMNaMyFUcP1s+a3HJLzU3O0G5dODEas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 08:26:36AM +0530, Anshuman Khandual wrote:
> On 17/04/26 12:58 AM, Mike Rapoport wrote:
> > On Thu, Apr 16, 2026 at 08:10:53PM +0100, Mark Brown wrote:
> >> On Thu, Apr 16, 2026 at 09:05:11PM +0200, David Hildenbrand (Arm) wrote:
> >>> On 4/16/26 20:40, Mark Brown wrote:
> >>
> >>>> Several of the mm selftests made use of /proc/pid/mem as part of their
> >>>> operation but we do not specify this in the config fragment for them, at
> >>>> least mkdirty and ksm_functional_tests have this requirement.
> >>
> >>> I guess we could teach most tests to SKIP if /proc/pid/mem is unusable.
> >>
> >> That would be nicer, yes.  I imagine some of these will predate there
> >> being a configuration option here at all, it's possible there's newer
> >> tests that skip cleanly - I didn't look at the skips.
> > 
> > Enabling access to /proc/pid/mem keeps the coverage, not that it's great
> > right now, but still.
> >  
> > +	mem_fd = open("/proc/self/mem", O_RDWR);
> > +	if (mem_fd < 0) {
> > +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> > +		return;
> > +	}
> > +
> 
> Change LGTM making these tests skip rather gracefully.

Yeah, the issue though is that open() succeeds regardless of PROC_MEM_
setting in Kconfig. With restricted /proc/pid/mem the failure happens in
write(), and there we don't know what actually went wrong.

We can try checking errno, but it's fragile and it's better to fail the
test if write() failed IMO.
  
-- 
Sincerely yours,
Mike.

