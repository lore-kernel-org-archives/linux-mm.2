Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734BA103E163
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B395A6B0184; Wed, 18 Mar 2026 07:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC30C6B0186; Wed, 18 Mar 2026 07:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2146B0187; Wed, 18 Mar 2026 07:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84A7A6B0184
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:03:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AA92BA992
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:03:03 +0000 (UTC)
X-FDA: 84558896646.12.1B59B9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67EE680003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:03:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+3MoTCF;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHsENFWJu5RfeUAa+mJU7gbm+1K/VwnjpaZM6gtznCA=;
	b=Zs/QPvc2rwOUliA+7oIAJVkhXEmRMzzkdHhgLATPhzo6ZjpMX72Q4x0wNiuEf9NJ6kc7xl
	/PGHkh3DY/KdZEFnmyTacAWP9EBN2FPbzZ40TtpoESUwdjOQaDbXo4C4NpDSbiXFA3o89i
	pfAwUSibtTck6BQJxIchhn86Q3lyl0U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+3MoTCF;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831781; a=rsa-sha256;
	cv=none;
	b=drcxjR4gSPWnM3x0JTCgZgqZwwh9j0Rs29Eh5F6zYEqWiWJimPPFGCdGv+o90jeANSUY0z
	jheWq1xOym0ad8a1lupKZ2c7aqMkoFRX88FLF+MMzCzDRonguRQq7eEfQpq/XXCQi0A1oW
	P1XZ6wo9MUpO4ozxq4TybsQnbN5b6O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF13439DC;
	Wed, 18 Mar 2026 11:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ABBC19421;
	Wed, 18 Mar 2026 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831776;
	bh=zfsdZBqryydH27u6JZMfb3afJOf35YTfOia93PQ1C00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r+3MoTCFbOoSCaDnsO98mty6x/IRu1jwhpGqiG9UdhI2m9A4L+uLhSAyE8ok1p0Ai
	 CO9lM8wb7ZgHkq4g3ptKIChmnYSYqVIhmg8gKwDFU0PrqHJgFki/7/SmmLwcdTFf98
	 wKffjIZN34gzR3Nep6U+Va9Ipn9NsKn3+Wuump9CHVsQZ5bgo6n9SdcmTAj44pTc/y
	 YDEGzmLqWRm92GzrlnLvCttlhG3bpFVJwFP72Ssvpo/99OatfSjmPSlDtusovF3NdX
	 nQ0WhL22ieafm7WwepuzVuyKxNjn9eOkayIYmeA1LJ8wiUDvRp6nHUYoSDLr63/XYp
	 F1GelnWWCD1Wg==
Date: Wed, 18 Mar 2026 13:02:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-ID: <abqGWfEINMEeh9B6@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
 <abpxUEijdHJzziEV@kernel.org>
 <CAAi7L5e9GxgvGTFvPfcn81Ve59N-K-o7FOh+Y8qKHwpuCYycCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5e9GxgvGTFvPfcn81Ve59N-K-o7FOh+Y8qKHwpuCYycCw@mail.gmail.com>
X-Rspamd-Queue-Id: 67EE680003
X-Stat-Signature: atuihpybf38u7gq5z63pmhnp9oe8y1ip
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773831781-402189
X-HE-Meta: U2FsdGVkX1+PkcIUgiVKF/MUw1C1AGuJRwfcFqCVR8BzR6tsjsMY/6ht/tnZOl6DqL3qsp2//g9PCiaCixJkB/25iwZVGzAaeg0idQa2qooE03XTF3X22jWwNcoOhrBuNZibtfiuYNCj0XKSBoFRTlAr9Sbgjmj7ArciXWNKi1ER4+TMmMlZlJG+14QlMXlI/Pt0pGuUb8+s/xXiDcFRoXPodY6otwtIfIKBt2mcClLx+gUsHVrF46vHMENsOWm0f6IY+ZJRywggbZLhtoPN0bnqtubPlpnvIbI5zi9SgU2BaTAk86YkI/ocXGMS97IEbCEFI9F+Fbm9V8WXN5kavxH1D96JwINQx2l8wzuQUjWriPjbAldA3X8HdlPDtHbWUmg+0GRn8rtha4tR1GJRHUoEf4jhnGmJdd2xDnlCowP6PxR4ZEL9VePUAundn7PyaYR435f+XgqXloyW+uJ6nhWRN/VAnLNCUIN+aK2lTTmcHbZMwJvPkuxKxhHWQ4KbGdzIqGQ2ICCma6Z92cDbcNxWT8TobeHXbWN0iy83b8QhPUNDR/Rgr4Kemp5G9b4bIELJtFPuhq57U3aczkqoA7S+MwJ2fIbAyt7vkudVsO7/sBFB+8g3fmqyibKqja6/8xdmqg/GLq7nHmKGbhOaxs6MQeECf/XX7jvicKSOwgAHecBOJmNT04AheSRDvCB7SOw+IjTD7oJywILUmg8j5R8czTm6OnA1z6KSAjXmMxzXS5lWi6ZqIwjl4GyVthSJJ2vxwCpnT7prKzAa7OErtkgftwFwkKHbI2IisiCCmQNkqL+8PLC3pPz6C8bKgBZBfHhY0PKEWhzDTMi1IkKCV5npDT7NalLYpDvaklsLr6CRUJZ24sVSz8Tc0YYWv1IiP2tOL9vTZPo4JOPk9Z+0i0bxz6qgzdxPU9th1wbHwB5X3XRtJazJzrf01fHLyHVe8A4Y7KZwHbHHymksxcR
 qxyhXOuU
 VdXuEW7NjF1JUgFWQPZBeMnCNfTlGRbWU4or7f5YmY8cmTPPGDVfg2Kr6RwtDHWpcdCXtWZ/rdlhKt63jKjYw0t13M1j8/rOpwwM6loEuXqdnmP9V3lTQrCME8NV0MorMlFC6aRmY3ggo4vu9Jt4CltdmDgaVHphg73l4PPKI95qjt213N5PPk8vVhEGbHOU7QqoJXoeJPxB4A11duYFLF4RGP1URtRVm3E9bMhKzoPK6sjNF3p4yAHLlNPtW9bwBhrUvZpv4SLyeM9LEb76zczu+JkVxFEcaPMU14UT3HgsP8Vo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:33:09AM +0100, Michał Cłapiński wrote:
> On Wed, Mar 18, 2026 at 10:33 AM Mike Rapoport <rppt@kernel.org> wrote:
> > > @@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)
> > >  void __init kho_memory_init(void)
> > >  {
> > >       if (kho_in.scratch_phys) {
> > > -             kho_scratch = phys_to_virt(kho_in.scratch_phys);
> > >               kho_release_scratch();
> > > +             kho_scratch = phys_to_virt(kho_in.scratch_phys);
> >
> > Why this change is needed?
> 
> It's not necessary but kho_release_scratch() will call
> kho_scratch_overlap(). If kho_scratch is NULL, kho_scratch_overlap()
> will return early, making it slightly faster. Alternatively, I skip
> invoking kho_scratch_overlap() if migratetype is already MIGRATE_CMA.
> (resending this since the last email was html)

Thanks for the explanation.
Let's keep the change and add a sentence about it to the changelog.

-- 
Sincerely yours,
Mike.

