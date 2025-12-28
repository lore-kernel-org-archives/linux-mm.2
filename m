Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72D5D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 21:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2756B6B0088; Sun, 28 Dec 2025 16:37:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C386B0089; Sun, 28 Dec 2025 16:37:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F2C6B008A; Sun, 28 Dec 2025 16:37:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02D7C6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 16:37:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74B96C011D
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:37:45 +0000 (UTC)
X-FDA: 84270192090.24.A8819D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D06F64000B
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:37:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D3LuM5ph;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766957864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXxhIcAHppCB49IrD+IjMQK4iR8EQaYY7zqGjWK2Gjk=;
	b=R7aP5ll6ZJlV1ASCySjfOJsx4iatqs8uSVvinIuNDzCEAwOfomPitBF6UX5zsuU3IPsX56
	/who4DD/XtovVD5b5S+B6uajz4/gv6+iiEwGkZKYtP2zIFcYCTG2V3mgQt6XelMoaXP3ZQ
	iNmofkp6xrFYU4foY5yq2PRMrfMGY8k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D3LuM5ph;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766957864; a=rsa-sha256;
	cv=none;
	b=NLWWRPBHceN4S5jjt1TJLNR12IZySIsi6w49OkElicDEmttkCHcsgT6G6wZkv3nHkmPpRc
	G1UzZkjiP3+7l2yaBey6R0rTiab4XbYCtlhefrxZiiBCB4u9S5J6TDif0Dy834VSbXhvug
	xWvabovNfEIB9wEVy96qUsawX4IcdJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11B2460010;
	Sun, 28 Dec 2025 21:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE2DC4CEFB;
	Sun, 28 Dec 2025 21:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766957862;
	bh=OEiTLDq5pxx8gFQzlcv+46cmEbe3o13ABCccyCSt4Yw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D3LuM5phuTyCEEKnOIhrb/GrSAiYa39LTJQzwIutcMI81u3uYnlZG7O8MtX7lVs9g
	 9idq1c3sEeLYttwVEBIoimtZw306MswYvIe+kqMCDzjVf52iHCevtoURoG7wYtNU9L
	 aQn+/6aBlgnPLvCtXrh09ZitS9tZY25/nRiliTJc=
Date: Sun, 28 Dec 2025 13:37:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, lorenzo.stoakes@oracle.com,
 chrisl@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on
 set_pmd_migration_entry.
Message-Id: <20251228133742.a1f90fc552d346c4c43aad8b@linux-foundation.org>
In-Reply-To: <CAHrEdeuRtROkAN0zNdaYG_GBkSeW=-3kP3xBiQV1w51vGSc6Ew@mail.gmail.com>
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
	<CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
	<CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
	<CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
	<CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com>
	<CAGsJ_4zg_DgQnQthTqWOnwUrhm-MygVB6mOwmgK=ey2dYogb+Q@mail.gmail.com>
	<CAHrEdeuRtROkAN0zNdaYG_GBkSeW=-3kP3xBiQV1w51vGSc6Ew@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D06F64000B
X-Stat-Signature: ys977muptfs6obx673g96hsdrrxmh1yq
X-Rspam-User: 
X-HE-Tag: 1766957863-787247
X-HE-Meta: U2FsdGVkX18AKTuMWvqfb1iOhgDj5h9I3UuE/ao/Ki6TVCpRRzEC4Gga6RWShGQ1Gt85H/l4u0JZ3ZXCv2r0UXyjFsDWHdHvGBiHn4hzmt5Zp4rKjP48W9bQx4v70F7VN1gmzyakclYy0mymhf9J+nOEOfuq5U0H3H1izoFJNLKwLBjpiCcXsnYL8FkaKx+SlgfAv/iw5BBHVEezXKaIi9nbdSzPfxXoR59GmjUz9gl2/GrlVhGPfL2EIoNHCsXH17SVNbMdnP705SqKpVeZ7ikF4cb9Ub6Yyd1URsJxSTtzNzK4lQMmq4fA9H3n8auUsDtnJb8dPWWuNPOYrA1DXiq8C/9pgsufHUvWpOshgEar7QuKiS/SSdisutxKs+mdjWc93CL1eZGjzh/Lv8ZytVULgRoNaP3o84twTBcP4y2n5ob4Nb5Ets45bBp9u0GeBWoc7+Fi7nRRJGq3Uja7ZYG0xVj42/mT38SooiCvih4VmZ8/BDBarAgxTONtt/1IoKT1bl/IciZnpocCPvSp1I04Fl29fFDY40KA42pCn+zAFXEXuD9PScQ2ukXZ4a/WNYr6DN5GFNN8KrgJtd/4jEamNd96GEx5KdFcxSEMFmNbvDDhxAawJfo3KhZ3LIHAFOzJ5+h2/byknApACXaO3bZe6uipyUagkFZt6gHDnCfT34Encuyna95xR4dFZlRAmD+ziCXlj+pt1ThqA9S21sOcv67bnmmWdPRK5zw3b9e1t91QoRnilGarK6NtCIVItpRtm7EQxw4ugpLlPajpO7kuzflX6rABU8SDZ7lNo3DFanwy2uV1CKB1LheAaQF4NO9oKhwW0Ksg1lEtbtTEz3evtbrWXQQ/0/Bh9US3rJ9F9/aSOnIOHdCZrvLIv4LsnQVlxFCj+aPFlIePlPQdASzSliG78l8atgOr/6TuiofQZbirG8LpVVPS9PXI1ViOsOvAhl/uxWrOi5I/3gp
 313aT29U
 wtrRTCcSnm/6/WQsfDYpTqhZ3jAvH4uK3ETJKuv5WidNWRXqmfClZIjDKmCoQOa0TbY4Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 17:58:40 +0800 wale zhang <wale.zhang.ftd@gmail.com> wrote:

> > No. You still don’t understand my point. The BUILD_BUG means this
> > code will never have a chance to be compiled under any possible
> > kernel configuration. That makes it dead code. If there is any
> > kernel .config in which it can be built, then we should fix it.
> >
> > This set_pmd_migration_entry() has no chance of ever being built.
> 
> Hello Barry,
> 

Please share the .config which was used to trigger this build error.

(It is strange to have this should-never-be-compiled code.  Why not just
delete it and let the compiler/linker report the error.)


