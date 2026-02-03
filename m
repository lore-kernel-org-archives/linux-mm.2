Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB564E87842
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA166B00A4; Tue,  3 Feb 2026 11:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058A36B00AA; Tue,  3 Feb 2026 11:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98856B00AB; Tue,  3 Feb 2026 11:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE4896B00A4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:22:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 743B5B9559
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:22:48 +0000 (UTC)
X-FDA: 84403664016.14.9B1A828
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D871CC0008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:22:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g8tx6q1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770135766; a=rsa-sha256;
	cv=none;
	b=G6P8bocPc5tWGu2eUdr6EEiJyb0QAyM7Nve/DStyYjss3dqFV2rxJhX2p11hPauSCNRTNF
	GGnENtwxWe7VGJtBzUb39dwu/auOHqvAiZdeUp2UnEFBv/foMOxT6EV76mgnJxX91iVd8y
	pncK8n2Vi9/bJK6G4jO8iOcHutXoaFQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g8tx6q1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770135766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeZ0MgyO1fyDscEfAG6lz+HAP/ww21XmDgQOMzqN3E8=;
	b=hm5am4jdK23MX0WEIgyGDiNmaZYgpmxmcwAZ/oHiXo9AE/hFjKQ8hw7ctvxW6f1JUxlqFB
	VrjYWRk8luBVxu4EtRUmxffwE2JPvMypbQ2oeCUFl5kI5NfKh8Y0Ag5RDMmZxs+Ajnypoa
	i2Llx1oeK6o3ITUegnyMfoD+pUtfseg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BF5B60143;
	Tue,  3 Feb 2026 16:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D756AC116D0;
	Tue,  3 Feb 2026 16:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770135766;
	bh=1oyZKFwjfIKHh6YeT0LaiF3S2saMqK9ByktcAWWIavs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8tx6q1mPUSf1sJXgzbw92G3rlDMhAkfEXATLVPku582tk/LtlNIenhVOB2H5bFEL
	 TAfh/begikCvK3c8XBf5qXD6iYsx84tWXMpfsNNFo32z2Q0ccGzKzUVgryVAsjPxUX
	 FmA93KD1+YcSmT6S1wWrVGMX1kHCN+tEmdFRzPGIU/Vjt10UNyBMSsdYk/3vgpSY40
	 nAnMGtBI0Zdj12UpMkEW93pf1gLHRLiKNLeTZZHnlDtlaJl5PW7eI7D1hDeujyoQrO
	 28zvS2EdH+ytwUZTrC9Nsj8f/WM3ZcFyQP2SCSfY6Hly4/YnLp3qsxqLnhpML3AG1a
	 wxTh30Z8+rOkw==
From: SeongJae Park <sj@kernel.org>
To: qinyu <qin.yuA@h3c.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/damon: remove redudnant mmu notifier call in pmdp mkold
Date: Tue,  3 Feb 2026 08:22:41 -0800
Message-ID: <20260203162242.46851-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203095400.2465255-1-qin.yuA@h3c.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D871CC0008
X-Stat-Signature: ac84tmko9hkfpbikmczbowok913ddayx
X-HE-Tag: 1770135766-607546
X-HE-Meta: U2FsdGVkX195K0EFwdRufSmbcHpGiTtHOOV2FzECY+QDYiFU4dRurRokIq3C3S9QIJwYk5hipMD2p4SpPV3ZAedfl+scEs9O1boYUJ1E3UxmC3Cebfj89TwdbLcqODNcfYI0KGiKwWIyDxb1C7m1x03ekIxLVRRdaFx1EWqscNuUkk5klyW/hB88jldZ8ymnCUExBjPlsAK+Jw98sZh6hhwXli1OvSEwCZLdd4J4jkHKu6D5OjVebnLrIzXS+oQ+mY7+GudabmiphUTTKdNe5l1d0QN6kpwmMmJV8wqa5hkgkXMHickBH3AGdoU0GgvYaD0T/Y8n2VscK5/hfpKcembH2NTfnJW+3spCuUNOiaoaIZg7HQJTifd1kikYQc9xlA398glF+iLAZWcAerHOKe1VIUTpKY0zaprvE/qBJylkZ3z8DAQCBmI5GZ7GnXhEVxh653KsD8jQiixDZoHLAdwrEKmbTauFikIsx9AGHDWGvJbFyceF1qp4rVXYrsXb6yvdKyt33YwLepssmU943Ud/z1v5Hn0idtRweflmC7vz6xj8rAi0QeQJf1G7XAtreNp9ySK9dB03XzEz440RE7cOIldP07O86lXnH1WoMySBtEIVvpChaQRJABajpgNrV9TpSeJaU7KNZdEArrgBVTHqcmQcJ63wFTz3fjIgV9F07550DtbXN7LPQst80H2Q/yv1fcf/wbQRCijawtPFhXxNqZOMm9c/mJIAOfNHM0lGGS48ynbML/f/TNxqxAVCqLqHvEbLwhkC42AJTEr28oT1tyiLmZWj8udZTfb/HxSEozdMtm7UHWHkrVtsJBanRn4CfUbgunMl9j4wx1qbZZIvJ7bOhtQSyUu6/aSPpOhu8zWRWIfhl+nhl6GEC9IYvxqudr9oQIn7salT0QhXd6RyNgCozzq8PrTxzGuUVmdsLya6668nKXNUceRFzSPtaCKhbOAVHoHytq57RWx
 hOqwiiF2
 fpOdxKCjPSxsWo6Hh0Gv5sAR2K2FU8rmFp7nN/BDRMdcjpfCcmUmZBbshk0ssGGyRgwHzB0vhgyiyxlCMcP1AzuScuqWkluvAjOmbKpsxAaPNLlw2ksQCCEDhsHCtxtbv7LLSeFLC/0lvy/K5fpuXAe230UqGQ9ZPqWdaQ7oF+KIqXhoMCbLyXxjUcGrEf/AfxeYfk6gcWZ+8SYVl9Y6DMO9ZUYHk4vYvU+Qzv5h8kQlELneIw6kRF5oshjkFlnepDCSQn+f6HAdsGbygNMTQ7kocueZAGFV5L+agQtUZjinu2uJXPqlzx0+9HPhK7PO9YyhNvqrkmgejXb2hMy6O8eTOLhg9KiezR/LkOH65Igx0UPU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello qinyu,


I'd recommend to use "mm/damon/ops-common:" as the prefix of the commit
message.  Hopefully Andrew will make the modification when he adds this to the
mm tree.  For a case that Andrew might not since he must be busy for next merge
window, I will keep this patch in my tree with the subject change for a while
and repost if it is not picked up by Andrew for a while.  So you don't need to
repost this patch for the trivial change :)

On Tue, 3 Feb 2026 17:54:00 +0800 qinyu <qin.yuA@h3c.com> wrote:

> Currently, mmu_notifier_clear_young() is called immediately after
> pmdp_clear_young_notify(), which already calls mmu_notifier_clear_young()
> internally. This results in a redundant notifier call.
> 
> Replace pmdp_clear_young_notify() with the non-notify variant to avoid the
> duplicate call and make the pmdp path consistent with the corresponding
> ptep_mkold() code.

Nice catch, thank you!

> 
> Signed-off-by: qinyu <qin.yuA@h3c.com>

FWIW, Linux disallows anonymous contribution, and this tag should use a known
identity [1].  I was thinking about recommending to use real name, but I found
there are a few patches that using this identity (though email is different),
so looks fine to me.

    $ git log --author qinyu --oneline --pretty="%an <%ae>" linus/master
    Qinyun Tan <qinyuntan@linux.alibaba.com>
    qinyu <qinyu32@huawei.com>
    qinyu <qinyu32@huawei.com>
    qinyu <qinyu32@huawei.com>

[1] https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/ops-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index a218d9922..8c6d61342 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -90,7 +90,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
>  		return;
>  
>  	if (likely(pmd_present(pmdval)))
> -		young |= pmdp_clear_young_notify(vma, addr, pmd);
> +		young |= pmdp_test_and_clear_young(vma, addr, pmd);
>  	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
>  	if (young)
>  		folio_set_young(folio);
> -- 
> 2.33.0


Thanks,
SJ

[...]

