Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C86AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E611F90000C; Tue, 12 Aug 2025 13:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11AD8E0168; Tue, 12 Aug 2025 13:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D012A90000C; Tue, 12 Aug 2025 13:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE9808E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:20:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F3A0809F7
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:20:06 +0000 (UTC)
X-FDA: 83768768412.04.2384CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8EEA240004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:20:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gM6qhym/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755019204; a=rsa-sha256;
	cv=none;
	b=iNo6faB9RzOPkELfy0CRfnYCDwlarPI4lThPbJzOl3u2u32fSRmKYtm/kpAgCKYgf7fP7G
	ibVmaFJK8S1vICYOWJXXN8vBy+g3PlaMNVSQnQ2v4sw8E1A/1h26Hdd6m+bBaUPlGU3YW3
	IaYt/waTifiP3ECZW91E06KO28i2oOw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gM6qhym/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755019204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHuL00jkbTdcu+rBj71jHaE1m0vyW7vqZsqD6/6J1Fc=;
	b=rjjhWY3SF8xW8XaH7dm81kEywRUU8HMg1wkAjj/kSWNbw/fcCYF6cEc/NT7UEXrLg7/PxC
	mrdBMT6Riolojek0HEqI2ZxkYLCP79LRaIO/N/KO+4/EPvx+9fA0ofMoez8sICzZARtAiW
	JHMMh/IylFwhCEqUM3JXGXlaodwNXVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4083600AE;
	Tue, 12 Aug 2025 17:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFC5C4CEF0;
	Tue, 12 Aug 2025 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755019203;
	bh=mAC0HElfoi9Vm0ysz8JFlbF2hmtehTuzsx2QwPcA3lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM6qhym/4a3Wazw/nb45u6yf19ToNI2AupnrQWSMRSud2rXFjWscjBM03GnmGuaLC
	 EsSxGSxYbn6bxLR4A2ABjxDsa+pL4ZQhGqWV2JTXluMQdvNFq8NiSxxMtND5gTwRzu
	 /DCJj7O5o5G9jFdLQ4APf0J10q1OuZDvhbtv2qaNCwxZni62qKDkKYUKeAtL4Ntygo
	 2GE778oQcigzTGsrra/5sdbfnFvQWrDutwQCehovhpDQS2bzt+lr/jH/3RezA9e+eI
	 SRpDHftSUOViKMiuPwCw9CW9uD00n3W1C88LhfSiOfeftXXkcznJQN+SXh6ZICgtQT
	 cT+O7nxy008Ag==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon: fix damon selftests by installing _common.sh
Date: Tue, 12 Aug 2025 10:20:01 -0700
Message-Id: <20250812172001.57104-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMEQYx7fdx4T7meUb01FoqJaHcW_2RoYnBwJ8GzmJTexzQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EEA240004
X-Stat-Signature: useng1mi58ty938wtrpn4si3z1p7k4f4
X-HE-Tag: 1755019204-865024
X-HE-Meta: U2FsdGVkX1/EuCxpCQR1B+uwfYQuyVZOjM+wumedpdXd89FCKty/SCgl9aujJDqm17gPjqHFL/1RCacAI+3Sct3lnKv1UAdfxQlwXpRG2CUTttb0yWPtNys1WfsKovX3haAblMepY+lhDAcSqGsKL2rKU36UrsnVgvPz2qysyJck0OZSDTm5op7wHKc+nZncIyuX7MtbR2/jEFWHUvFx4mySJrTFzoYDVxi36DBkrUXtziQm0y4pWugFr+mMXqiv8q1CaRQgXYj5cm8plxpDH7eFFwdxM2XRH2n75eGIbDvtdhPi+vgvA0Ai9UvazoYinjQO6Cnhb++CV/uDkXz01ANzHeJBMILPj2RnnzLnlxXcpavSXZ81CU+qNl9NwqLhaUfRlPZP/nOmJTj4hgxpkhk8vmimDS03hXecbF6GoKETZtyBV1HuIP/9VZdhlTXDJixQ8o8us/RaR+PY4ysBcWnaYk7ovReni5bAe8L/yWTIN8ssTYSwrou058nxWEUKfjqlNuPhIdGJN+8bEr4v8f3AkaEZWnpM7nPYHIpjmm7MLG1hqke1arjqK2t1i0k9naiRKlfNo6I4ohSdJh+G2uRGBqv5xkOwDwnBEzYRyJ8rS+TIT3fRhRaA2TaffQBGP6AdQuNH6oEJ0JV+VH3lLDdl4UvjiFkq76/u9CGpE+bNEAg7auiJtfCYx3IvHNIQ2des+JIRKId1b+nUyAmEO0v1Puu986qGManq9ZTobgUj+JM+zYWFkZUIOAerNrFYqpISq7nSzvoUjbjBItuQUKTM7+42myE94eYvLdtVK7U7NMTnFN/6znnsNpkNVxHLY8UusgTs3D079mZc9i3tCt1hKWoB0N6TJGR6pvCK92Mpp+OPCH+Tl1fPhUIG1UQuD8tCX4NJx4i7M+v8nN6ZNFcKBeiW1sbsr0m4D6Cp9ACucSDx2MYFnq5IiLqCY8gk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 22:27:00 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hello, Alexandre
> 
> On Tue, Aug 12, 2025 at 9:32 PM Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > Hello, Alexandre
> >
> > On Tue, Aug 12, 2025 at 5:13 PM Alexandre Ghiti <alexghiti@rivosinc.com> wrote:
> > >
> > > _common.sh was recently introduced but is not installed and then
> > > triggers an error when trying to run the damon selftests:
> > >
> > > selftests: damon: sysfs.sh
> > > ./sysfs.sh: line 4: _common.sh: No such file or directory
> > >
> > > Install this file to avoid this error.
> >
> > I tried to reproduce those error with my vm environment but I failed;
> > with my workaround test method, it doesn't exist.
> > If you're okay, could you please tell me line by line how you execute
> > tests in what environment?
> > I'm also struggling with the test environment, as well.
> 
> I succeeded to reproduce and also check that this patch removes those errors.
> 
> > > Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host shared function")
> > > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > ---
> 
> Tested-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Thank you, Sang-Heon :)

[...]
> > > ---
> > > base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d
> >
> > Does this commit exist in `mm-new` or `damon-next`?  I failed to setup
> > the same base-commit environment.
> 
> However, I'm still not sure that this patch is in the correct
> baseline. maybe it will not cause any problems with the merge
> though... but I'm not sure. So I didn't add a reviewed-by tag.

I think unclear baseline of a patch shouldn't be a blocker of Reviewed-by tags.
Since most DAMON patches are recommended to use mm-new[1], as long as the patch
can cleanly applied on latest mm-new and you don't see anything wrong, I think
you can assume it is based on mm-new.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

