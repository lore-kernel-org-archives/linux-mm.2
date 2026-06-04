Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13210CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222176B0005; Thu,  4 Jun 2026 15:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA296B0088; Thu,  4 Jun 2026 15:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136C46B008A; Thu,  4 Jun 2026 15:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 001F16B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:52:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C92DC152F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:52:46 +0000 (UTC)
X-FDA: 84843277932.04.CA94262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1740680005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:52:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfzsMKUO;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780602765;
	b=J8H8A20qCtaYI9yllu/cBJlgxpm7UFlj+r1M7dB6wKpnT6AiUAmOeDayrlRxpoaOTaRnqx
	tMqCU61J5wVkWkALKofKymBc45vWFj9JKdU+sirC3xLk6S5Q/ROGdu3bvTTltpR9AziNjb
	CNTGmvGgZWMKrfTI+KIMztZBqrZYPKU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfzsMKUO;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780602765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIKLTDwE/7XnDlM+Wic3OGmrWlthwW9jYpeO68RttzA=;
	b=O8ds43GGdUHKdLZg/rJY2lKTsIIWXZPd3DZzBIiI/rMkDFFEIUEGyYx0bjtRaWPIyDeMVQ
	37sbDvyjyB3UdfstmaCk239wyYamATIQB+DE5eiXU8IIOGYyAv9t2KAzrG727+D1t+wSt1
	FEHufwd+ADQSl3czqcA8nUKyQJJR2NY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 833536001A;
	Thu,  4 Jun 2026 19:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2DF1F00893;
	Thu,  4 Jun 2026 19:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780602764;
	bh=mIKLTDwE/7XnDlM+Wic3OGmrWlthwW9jYpeO68RttzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FfzsMKUOlObmu5OK/0v9NiUeZlIYhv2y1WNoKK1XZAHQUrUCBD+fyRgxOMeycF4jK
	 hk5eJ1gc0q0hltxMHkeYsgjfXzAvDWO/BbRK5dRi/2ff62lBGX4Ne7E5E67CLfjmip
	 q9cbWDcu/naAAdaXqkWASZYJpsY8H+rrHUjHrhcT7ZlQpGD6/y+9Dup6yPunV1XNV5
	 DyMaNmgvT3+uJ1XjA/m3H2MTQS9NirZ82jE2zzaDfUtpkysjFM+MhHsWOfq7FiJfOE
	 9MehWz+U8x5MwB3yJzE0GCz/IqCZarDBIOfUtiOds7WePTYpeM4ClUpdfPJobSzUFI
	 vGXrCTBzi3AuA==
Date: Thu, 4 Jun 2026 20:52:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
Message-ID: <aiHXZokM0TekWmog@lucifer>
References: <20260426062718.1238437-1-surenb@google.com>
 <20260426062718.1238437-2-surenb@google.com>
 <ahhMEBYM9bixF2Lg@lucifer>
 <CAJuCfpFJvuFZkgKwJ11RjDXYhTz-a31HO9-5C+Yc=KxbsGvB-w@mail.gmail.com>
 <aiElxkLHn2yC3W_3@lucifer>
 <CAJuCfpGWeLz7RBVYHTnMpH2O77yb9MtjMKRK1LrgijafC_0mSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGWeLz7RBVYHTnMpH2O77yb9MtjMKRK1LrgijafC_0mSw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1740680005
X-Rspam-User: 
X-Stat-Signature: u4tgmu8rhorfhhpxsnjzj4w468ooqfkx
X-HE-Tag: 1780602764-539559
X-HE-Meta: U2FsdGVkX19kFgX/gT/LBK9jUww0f8McJR1SOr0oqRsmk2cCtnZt5RXMPiFXTPK4WbdfPzIRO7nYa502z24FplESLOLwFuGYONMpkZEGyan/iFTzvpb325HAqI3sBTeYUGS2DSqPUKHSXIU29WfAwQD160MrD2tnxgNW2j/vooqGnvjYgYXsdVCHHOW5qdPumi6wwLOZndv9xDdOyWylf2D+e32P+qiwH4NvBd/kueIlfL/p41Hg8P/Ghl29Qdw9WVNej+GLlH5FREArxd1tN3M02UZUVX/plctTrv6Rv1vmzTG0ViYcr/+PYpdo4mTxA81AhWbzoQhZOreZPag8q7tug49sHZxXGthJc1R/Zo7HfEeMvcQqLwBcaYQDjDXXNDYsqABjXTTzEOOtlvlCpwXz9DJ3g0prLfVGuAiJN2ul9IjkkXgYqlUzttl1utWxSi6GAhV/SV0Sns4QgHsIwkRKvcEluatqAz9FGSgIe1bnFs96EzytCi7qvAwZs09NAxFzEquWJpKhtTJvOxl+U3qo9iOu6GKKV8xvdYTR316J5BZPqWYdb2Xv1VOhZ+X6NfJRh1adoC2boJcNPMMsltQRYLUlVH8XJK36QetxtrPpyX2Ttal7/itLTBas9Ns7PBzKhgLg/m2QRdgWHTVJqNnutwrotGsdcikAo+c1SyESyhJxeqfHcC/2pYg8pZw6ceqSU6b78C4j0ud/Ptvgd/ueux+nJNWWQ1OXGNI4u4hklnm1KyDSwM0wZu18QkPwrz7pzwvTEbl/ZrPQYg9moW7B/skkTVQvj8kGJVCRgpmdjUfOlWXuyFIysfvOvqrpU4ggENXH4q9WMNbo03Vh9LG1CIGtsnOsK/1yfqi4iFKwx8AW8gqnvZNC9S177udbDCQ1rPRwQ//CWAjoluzJfmaiqzwzcILw1wJ8dbHiOV/kRGBMu/KHm9cjrE/LVD5UWu4zEOu+/HQ4QrxQm55
 NjsbEUUS
 tQEybumo7Yev3AVaAS+AzKYY0M7A/3p1enPBPHK1fpbHOzqArJIWxVm4xSUqmFEEB8W3Ez8EBWLriCM1bGjWmUMrCaF7gFg8X9RxtxBfeVgCcoZrAFxQNx/xBkdgFinwS7qrrz23BmBhBB4+WGSDLsWflbO2QbwQPKGAInpe8XqM7QbewUgxl1tvQwp+hF2AeYJinF/Ep6AI9H2NqkTdxTQu24lVRpr2f7v0+O/8Eo+n7/GFjpqwln94MAqfU8J8xvB4oti8x9Cn2VwvsnMuSslUeSu/9OawFzI9JVcSWlpJ/jI8oa06zHMC1gHnhqOVskoSuzx1AooOuFQVE2Ea7SAfQCsG0uQGmpgIkyrNEiBb/FBv6pvHicv0FFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 12:26:14PM -0700, Suren Baghdasaryan wrote:
> > > > We need to pull out the patches from Dave's series and remove this option and
> > > > default VMA locks on by default :)
> > >
> > > I didn't see any followup after Dave posted his v1. I agree it would
> > > make things much simpler but I don't want to delay these changes too
> > > much.
> > > I'll ask Dave if he plans to continue his cleanup. If not, I'll pick it up.
> >
> > Great thanks!
>
> I checked with Dave and he will post the next version in a week or so.
>
>

Great thanks! :)

Cheers, Lorenzo

