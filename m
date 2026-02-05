Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D078EA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88046B0089; Wed,  4 Feb 2026 20:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36146B008A; Wed,  4 Feb 2026 20:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35D86B0092; Wed,  4 Feb 2026 20:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 906186B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:27:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B591B7125
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:27:34 +0000 (UTC)
X-FDA: 84408665628.02.2704082
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A891320007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:27:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pyJpJzjO;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770254852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4xZSDwMtMpILqPUh0g1D+oWhI8mD+8ufEUWVFNa1Vk=;
	b=tP8ee8MD6fUh1tvs02Y1oBprxYk4YZGzEA0z6uYTKS+6yq1kpyHoVoVZTnlT+pBkgT8z89
	BI9fJ9y8G18f8JSe42VgYYWInvldJPBF/qBeOBc+6byvKKC07Yxqu9CI18nFmZL7gWxQWn
	kTtk0SaAKTMXXyJWJys0Su5oMKY2WRA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pyJpJzjO;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770254852; a=rsa-sha256;
	cv=none;
	b=EZFQfpnwLbCEUPoRWaLVBTdtieFKKGy1+MYOsii3RNrbXTiCPgBNxCPnKXpZDlWrxiOu61
	pHWIGxG+xBisDko6c6sZb3khp3w1Ni8A2dM59MRBYN+tSD0w2bi4WqcXzApYBv4SD20lg0
	Ts7sCkucnvVMNuH0HVeEDzzGqqy80Z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77944409D7;
	Thu,  5 Feb 2026 01:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9E2C4CEF7;
	Thu,  5 Feb 2026 01:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770254851;
	bh=CqRepDGpG6EQfbU34iZtOU5/lQov044SwfW34EId+vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyJpJzjO7P5yaEP+q12GtUKuEnGStWhFf5kj2g1d1ugJvIbq0fr4AAWhguvXCaAkC
	 xr9lABG2IWzIzjfQ1HBNmbx5+DrtLr7B7U+O4B+sQwtr6soow8tI039wKSGK3F4dfR
	 P7GWNtRvCyK1OIcQnKK1U3xjzyNmmBTLnispyETikkBbSeEldQY8V/9LHtgY7znFSx
	 U3+6/8zg/6nyAYFCQy5tRLvL+KszBlq0QWzCQ2hm60jJONTpmoEORdff94esYoWmRC
	 Ndkrk4jSH1/5dXdiyP8NAhZXHZkn+X3PwEpDLmT9Gv5t2bxhEO3uY8dmwPN86rZwQD
	 6GUbizx4mWiJA==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	qinyu <qin.yuA@h3c.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_idle.c: remove redundant mmu notifier in aging code
Date: Wed,  4 Feb 2026 17:27:28 -0800
Message-ID: <20260205012728.68407-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <61dec3ce-f421-4148-8191-dcc98bbed310@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A891320007
X-Stat-Signature: 47gnjdzff4ngfwrn76eft84pyc4qi3tj
X-Rspam-User: 
X-HE-Tag: 1770254852-882571
X-HE-Meta: U2FsdGVkX1/jMSscZFOnJCht5ZQFB6B02tD4Ft8oGNGmMK2quUIZ4xiPrRaQNVfcKaR5E4RzRHQH7zyJepwdWsukJHK24AWyrtYQspBDVuTW/Fnnt5BQfbQsEbF0bHwW0Ne7spyyMiSpMXBiacNiuoAmHwT6ejzzYLFnraGGtFVGyHuqDdcWQQuNrxCpgmcVAjCSHXhHFpv/vY22VyT/0nVB+P22v8+pPvHVFhyxNbP6tpmsh25Vzu7NQ6X8PzJNHfaEY0IrnM1ZjxPWyMyrCtXiJT25rv5mWTj8mNCdNbhMSj0/WkXYET769VK2RXhvjKg3/l6rTEK8WqRQ3j4yfMM/JtyPqCTFFJLLJc9or/WiFFWgAmRWQ/aquoh/85lBNTIAlTvFlpF9w44aJT0ISp4Pl+5iNNYInrbov5RkUeZBY+TCGwHxiwB68tOJ/ci4CnGHQLivOiqYSAzOFJw6nPF0O32jOSs+/CPGXsf6P80iSnyxPbKs+7Zu56AMnVD0Og2u5wXoE97EmCYYvrBJFxOQs/9/YxBauBSnrZnj0aRYvhYJtd2HYypg+gdrrFJnVILe96SVgBrM44n82Cb+elTXqbNYOXpk7K98X7bZke8qrCsYAYzaVUSTUEWByVTNEB3cckyF5emQNh6Hzv8vTLfgXiya+5WQkbN9UVUtmh1zStP3wcPbNNrF8ZI3j8BKRDsMM4GQXuGsOp2KXfPySwFMaMZGwgI90fbs2Zp20NkRi/kGsG3C32PSjeBtmroER1wLddphTvpvocwCCfvZ8W1TFyj1itLlP5hlBKLydcm89/oIX+3Csy9Oq8+sL3Oz4uD3GSuUrVXHg2ejE+9Dh/wrIbmM4EBvX9KzVoWULa5Chzx/K5OBnstxp1f45bBi0MaNh64WFcXlDqxZQC85lzUxoyn3qFK2QhSCLW5ZDW/4TJAMdIIs9qQ48iE9xFervFWShsyI9DJ/naGe3x4
 31ARnM7n
 AjSy98dY3zZ347jC0apVmWqJzfY6yRQOrFz9WyNxwL1+6tfSJsJR1M6neL6zVtudrov0ocwpC6iI0Wg/7Qv+Vtc5tNrEXwhR2pgxy962CL1hLdfh3YxGiBffxVVUX8gZnFf0JvcWgyAXWzGPlP5rvrsqFrcP2b4gsHF2mVn8MiqVpRPK/7mn39qrC3nSKXlVYKdK1hLqPu6jyaTjiIj1KIvyOQUBfES6fFjN71AhjiZ8ucPhkhMuiliFHwIryX32eBjWWpJA+AakDu9s97m5JxMia22j9cTyq8j0RdBcI229EZS8+0pV1u5Iel5pxJ3q0azfH8PVMLQJUzy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 18:04:34 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:

> On 2/3/26 11:26, qinyu wrote:
> > now we have mmu_notifier_clear_young immediately follows
> > pmdp_clear_young_notify which internally call mmu_notifier_clear_young,
> > this is redundant. change it with non-notify variant and keep consistent
> > with ptep aging code.
> > 
> > Signed-off-by: qinyu <qin.yuA@h3c.com>
> > ---
> >   mm/page_idle.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > index 96bb94c7b..9c67cbac2 100644
> > --- a/mm/page_idle.c
> > +++ b/mm/page_idle.c
> > @@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
> >   			pmd_t pmdval = pmdp_get(pvmw.pmd);
> >   
> >   			if (likely(pmd_present(pmdval)))
> > -				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
> > +				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
> >   			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
> >   		} else {
> >   			/* unexpected pmd-mapped page? */
> 
> 
> ... and it's now consistent with the pte case.
> 
> Will you also take care of mm/damon/ops-common.c:damon_pmdp_mkold() that 
> does the same thing?

Thank you for suggesting that, David.  And thankfully qinyu did:

https://lore.kernel.org/20260203095400.2465255-1-qin.yuA@h3c.com


Thanks,
SJ

[...]

