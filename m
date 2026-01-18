Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0521D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441426B008C; Sun, 18 Jan 2026 07:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBF36B0092; Sun, 18 Jan 2026 07:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318896B0093; Sun, 18 Jan 2026 07:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 25C976B008C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:17:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4F5CB9B4E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:17:43 +0000 (UTC)
X-FDA: 84344985606.05.30A8BA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3589FC0003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:17:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4Jl3OVO;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768738662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3FxoXkmPeID2GJwOJFR6A2aukHlecal+A0ncvlf2KU=;
	b=j9zydcoPtojlp6lrjoUVGl5JcyF47Vw2XuBMtZEa9qM1UtGUXy+LoA1sfkwY0ho99GmcW8
	UQ0yPJSigmuyZoyJNgCbbeXpR4DR8eLTNyCp1a3RotimmUURDN+uSCre+J7DwmLAcJgHuP
	WvahzASIeYbCJH52Za4MPRLh3tBS/k8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4Jl3OVO;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768738662; a=rsa-sha256;
	cv=none;
	b=dP9Beqa8ngN+0F0ZBEsGuq5hC37v7BKQafuoLcPYOGgUhFmAapeG4hzJFxlIKnBZeenJLr
	XIdg7RzqN6NBdHsj0fg1PCTARN+QkNlKFLBpZEyJnKGmFwlARZCWuyx6TXyK+D3OOU+th7
	hpcQzUr1CwPxD5UO0EBcTgu+eLWD1jQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0B686000A;
	Sun, 18 Jan 2026 12:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31F1C116D0;
	Sun, 18 Jan 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768738661;
	bh=qmv8ORmWnoMxTVCGZbpQws3WnDSwMW0jSLeuj6yOg98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c4Jl3OVO8i4mu1TXuQhW1sD/XctkNy7uFszi75HK+aJXhJHpL2KQZr2ANDSkMlQUy
	 PCzDhkSfM1NGk3EsQko9irugSftavEIRviuFThXWk4I1M/Nlrte3sIQp1kDWLdf00K
	 RhRD7/mBnqOs6tV+Qm8UIe8XwSTDlNcESitXWx1Ox0Fl1YfpMR+SirMEveVQZ9PQqA
	 mzZNbQnlcuapCX79UiwV782t3rail8MeDGYsmZ3xY8DJGF3Y0Wd9VTMQJvWTAyy0eQ
	 NJIT/Bz20eAlmVH2Jct+OLTb8Yy2bidlSXNn7smWCVn7FBc3bUKf8+xzw8cLH+Ld/s
	 ZL7gaiciEr3Mw==
Date: Sun, 18 Jan 2026 14:17:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>,
	Jason Miu <jasonmiu@google.com>
Subject: Re: [PATCH] kho: print which scratch buffer failed to be reserved
Message-ID: <aWzPXXqc_jWjh4rD@kernel.org>
References: <20260116165416.1262531-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116165416.1262531-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: 3589FC0003
X-Stat-Signature: garo9nr56gs8nkbamyni4zw9zuqfge7p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768738662-128686
X-HE-Meta: U2FsdGVkX1/dbwWRtH1fpMYgvAxy+Oi4TshiO0F7yv8bV/6HKWUvnvfHuH7eV6/pzHt34aXOqqq2Xkq4MxSAgkfAFhmg6d+HMT5VWfZFzPJXpVJfp1kkU07y3zyHeihVyADB5ZPxnCDN4kcXA6AU1FdcQIudoWQ3wHZvKJ+22QxO3CvZGZ+kDdFoQGzJYjAKx0W3utu4UcJ2vw0Q6CwxE2275ggwA1un/cuQlSRFHLNoAEvyBmQ8C6dAlwaMSjTdVgbZSyFm9FL8Zp8/jcT2z62Bbmvp1szkjedRG9Enk2T6HkL3eqNy0lm0xkVrLJjxV7g0Cu86bCqdUmsdGbLLkbdJofmaC3o2FTrXtZkJj4hb0FhIyS2TQibFjHPbhB5ua6HH20qkUrAmXegg5TeCcUPYEIY/BccUzI/R+F6+7XOilid+iN83QvwAgLrxlhRDGFINS/HNxa8hPbsm5EKkbb5HOLq6CPokPYldGV/4jdmaBZsjtyBELfFlVsMS0q6nBN0R4twaKQB4CbbuAYxsgPg9WMs07VUypl1fXwVLgieDWGoTSJvkIBDPKaH7L+M5N9mAWAPjbSptFRqXkA5hpPtuGEO+WxP8CuxDmMZ2yQZ3EuLJLadVDDeUVhrWZE4RV77srH1tzbeOpErNe7x/NrIhwbbvErT8TVK23OajN5uoBnHMA5+8kAlUixa9WgSNcViNbea3q5AVA7eojzsVbu7hOdvRv19R23bmjIBOqcquJDd3AMT1H6DrgTyIPxFd6cH6pRa+jOXrKmIVI33usdT9/JM4pF1Wgd+0E5JZzjjCGcV/iHmIr2IGO/c2kdSQOCvboQwj/B+Wj43uTaX1PWox1seooR6Dnvy/kRgShcRJ3QQcLLdHrOPGkLbV6IRTSPFzceJThHFKAV9IfvQF3YxSCi310Opq9aNWUt6ubNNP0s+RL18xpOTp3PCW83v83evFkq+stjWzHUSIJVH
 35/ABafo
 v7Zl7d6iJDcjZPP2LU1x7WT0G5INmSrWa4bIjpIEeqOhqDHYB2edmykoVijQjlvHD3avt6zT+zQX164zoGdR8fgds0o2B+3B0gNbQLz5jVoZzf9PkGV1oQP7KmR+Gv/5ZBJ/ISung0rR73MhKehP5ZL8bvEa2+mQl6T0jbnhH3MtyEcTwUaZbLn4TGEFfMw+euTzoRuG270MuWTVzMSixBf5r5hZz+Jvlef+5l/lUHC3+1K79lGuMHtYeMTyLZ2tj/zK2Xg/aKu+DNZPO9aRS5qAOlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 04:54:11PM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When scratch area fails to reserve, KHO prints a message indicating
> that. But it doesn't say which scratch failed to allocate. This can be
> useful information for debugging. Even more so when the failure is hard
> to reproduce.
> 
> Along with the current message, also print which exact scratch area
> failed to be reserved.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

