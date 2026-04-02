Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9246BD3943A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51D06B0088; Thu,  2 Apr 2026 11:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D030A6B0089; Thu,  2 Apr 2026 11:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18866B008A; Thu,  2 Apr 2026 11:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9D2F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:27:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FB8713B8BD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:27:20 +0000 (UTC)
X-FDA: 84613994640.27.75E170D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ADC70100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:27:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xvw5F5tP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775143638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTeh86hnE0GtI/9v0Q+pVy3UOrI0o6uj13j0xRyD9zY=;
	b=CYd06TUjpuY/NmANWljf1fQtJ1BxRFYviKdnoJ9kJ7A2KKiFkjA63QyF+e8rVuMcWZm87U
	QaRxjvkum5ak03xsn6Ew9ENuyUIbAqR2Kui6fe46p7TwAFi2OsrKMIxHCu0i74Rkhx81U3
	6x/Y52GiUNR7q+Ewp+GS04raYtS4pAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775143638; a=rsa-sha256;
	cv=none;
	b=Zgt4buf2IjMTurEQBWkvW6L3zMhVJ0NsGXAm0gfum9/F56gg+OmTlwVr1chXrsi9AMT6RZ
	27iFSLEE/oiEED3zJW+k4Sb8Jx3TZiyFmI5ISqg62iEfSpsvGMbIL5GTN1jL6x/JDsVRtD
	77XYsSuFH7XeTXNwXOWFabKxjemzbzE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xvw5F5tP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F72660126;
	Thu,  2 Apr 2026 15:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D96C116C6;
	Thu,  2 Apr 2026 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775143637;
	bh=wYa71MaduBNZb0rWMPKbI5WgvqyTuGbCnrO9JdEsbek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xvw5F5tP1fw4iN14lQQ2Nt3VdLPMhT6KyQZLrvk3kESsKR2+6uixcAKkA6gINcgVA
	 stW1h0g6/KM//E0BZS8FyBKPSpsOhmL7ztuNbB4G3wl5MZWDyXh3NDQbIHEuzvHK3p
	 Lfr/M8R4dLbBs9y1InjELI/TgB1QoNoqlOdbK92C1zTRdWV1V0cSmYVCrovjmF0c9x
	 F6byvPURDYE1PwpUspAynEkzjhRZIc+bmolhvmolE0Mcw4juHtc74ff31w1jDxVQNp
	 B47r+5ecFAVTyAlDX51q1d4gDa2zP08Mby8Dv1UeYjnGPJvGswHS55yX40YD0WsCZi
	 kYoZ9QpDp2euA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu,  2 Apr 2026 08:27:15 -0700
Message-ID: <20260402152716.75168-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402133952.73301-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADC70100005
X-Stat-Signature: yzmzxscojws6x6yq9hthnj7ftkof6y78
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775143638-555874
X-HE-Meta: U2FsdGVkX19q3H2+8O+oL7rywMGNznL+tBnn+oiBQcoqKtE4uLiYphG52AcA6T0zaW5vLQ4ZBh926e1zHyzKNGMn3VhzjlUpJJyXfjr6T2u6GTS72SPDFfrJIn09bRzN/N2xvMdF+PJU3AhtLX4CLU0k9vBIHque7YQRBHExO+JkMxLr1Qa1cPAh24lbjiNtqVD8UN62mp/htR1X+gGGFoye7bve8kg4fYvyxY87S001dRXiShFNlsUpft+W/CKbelZV7th1pHW6T8Z06wWXuDzEOS2ot0fecNKN+I9YYfkVzqutru1tW5Zf0fCx9wKSpf4WQY6ji6eOJCj4hcYTHFqOvRMLY2DCBRkvoiIPWR8eMVUDbTwtB6YbBhUN6qUKA/6qgi1vDFoJZaCCCuNEENvyAv0lTzPeJDXAwFLKPswmkwYlWp/gL/e5wJyL/WGkYWR9OZ2d/cYYVdNt9VQNg4iZMIBIn95vw6FYxdtam1Gb9qCw904U950h6lm/RIpFp3cUjxpVWMgh93BTfdlu50YcqHTv0NRsXg30yXp3ExM88zRK/E+BgsctN9qQAHAHyKejmMZz5MbVm5taIYreOwkRElaRvHlNYNIBO1p3egoqa5NvxjPAF5WAstcDdFWvpnAlmdIx3utgN57cOLt/tVjGIdyGL6ASRs8MeGd0ShzHpvScmGGX2uhZijueidNCOvk+jZftnoQXFmHwssAtnWkzR2usBXJgIj54UQbbFPvQ1RAjzLBJgpAAbO/u2k17dXWopBQ0fLBl1sroZ0DITirn5ynlWHVCX1qxpan4aSqsltiXFG2OQDjsPmW3q3cvkrsJrDKlQxxos4p9UIe4xtbrbsA5aGVwJsQnkIIrGtWM1/SwaGmXpyf7Xw64v8nzzc2P8KaeaNp6TK1+m8mmir/QcPxdGkMNBhpz51JNmM5lzXHASS9FhgXhHbMCRwkjL7hLzyw/97fz08y1D5I
 CPBi1HGX
 CWX/mVYVreHHFdAT8/NKpgAc6B7WjvZu0fTI2GAPW2XsUSN0Rcm1eA68bDnKW6qBliS9yod4o4ljuvfzN2osWYjBad1Pz9Ory6/zDPaIyglNQiRsaf9ZiCRPHSfPU9rIDzGTxl0IkEZBdeIiVsYyknmwyBpy3rt5q/tMmL8Hq81QHqL/V/h57zfDC4o87nzoL/WMDCa/9QzzG9uapPHDh/vzg31k6GpwqAI9imQK56EyIFbdMzLOztwzkRaJFe4VC5kqFgytviaZRRE6GVk2OWQE3q5/hYF4p26Tz/5MBWt4uuELDH3mwdvonSNExj8DRgYSkig8AbzXQveE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 06:39:51 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR: sashiko didn't find a real issue here.  I will post non-RFC patch soon.

Posted it: https://lore.kernel.org/20260402134418.74121-1-sj@kernel.org

[...]
> 
> Forwarding Sashiko review in a usual reply format, with my inline comment for
> doing discussions via mails.
> 
> > # review url: https://sashiko.dev/#/patchset/20260402045928.71170-1-sj@kernel.org
> > # start of sashiko.dev inline review
> > commit 8adb3c95d68d8448c8f57865d9874a5277cc1540
> > Author: SeongJae Park <sj@kernel.org>
> > 
> > mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
> > 
> > This commit attempts to fix a memory leak of the damon_ctx object when
> > damon_call() fails, by deferring deallocation to a subsequent start call
> > to avoid a use-after-free with the terminating kdamond thread.
> > 
> > Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org
> > 
> > > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > > --- a/mm/damon/stat.c
> > > +++ b/mm/damon/stat.c
> > > @@ -245,6 +245,12 @@ static int damon_stat_start(void)
> > >  {
> > >  	int err;
> > >  
> > > +	if (damon_stat_context) {
> > > +		if (damon_is_running(damon_stat_context))
> > > +			return -EAGAIN;
> > 
> > If the user retries while the background thread is still terminating, this
> > will return -EAGAIN. Does this break standard sysfs boolean expectations,
> > forcing userspace scripts to implement arbitrary retry loops?
> 
> I don't think that's a problem.
> 
> > 
> > Also, if the user never writes "Y" to the "enabled" sysfs parameter again,
> > does the memory remain permanently leaked?
> 
> In a sense someone can argue so.  Someone else may also argue it as "cached".
> Anyway the total amount of "leaked" or "cached" memory is just single damon_ctx
> object.  No problem in my opinion.

Because the reference is still there, I think it cannot technically be called
"leaked".


Thanks,
SJ

[...]

