Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDF0C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F58A6B008A; Thu,  3 Sep 2026 04:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6F66B0092; Thu,  3 Sep 2026 04:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCCA6B0095; Thu,  3 Sep 2026 04:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD2986B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:33:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6AA3F1A047C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:06 +0000 (UTC)
X-FDA: 85171785972.22.BE2E94D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4239C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vUa9quOt;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pDYT7mMj;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788424384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1+RlBHvN9fvzT0b4kNv62X9v1GMI5wMZBpkbnRiPgg=;
	b=fbGPMBdlJllno2TQoaI1eJ5/DwrVpGmat3hRFT6JumSp6vO9ibQ1ad670MOV4qs34j0n5b
	w6/mUGHRNfOCqE37Ft906JUPgbKhLvoN3uRIksAxMjn3/xwtE/uq+UJDABDeOsyXQw1KAY
	nroS50M6sFeb8tERZ4aKscm8EDTPcho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vUa9quOt;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pDYT7mMj;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788424384;
	b=HS/6+xiKnX8WqTB9Z1TFdL+XpxQP6mJivHE5U+36C8yj1VWM3SObXw7iTbSNwwg38L+md9
	RzYXbBtew4mBQ4aWI8FZXRJJr7VQnLPhDV6hcZ3gbO2+vDZIdCTphHZhkKMc0VOF/HMbtw
	22j3fGW9k8a1D3CC9OQsr5HirTXBJCA=
Date: Thu, 3 Sep 2026 10:33:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788424383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1+RlBHvN9fvzT0b4kNv62X9v1GMI5wMZBpkbnRiPgg=;
	b=vUa9quOtdWvGrJdQKg9qmPHqIX0hijGLSqebL5wOszU/E+xMyu9t3mO/BgVc22rrwQBzE0
	2gtj5wZCMj1nMiiKxwnK5qMXwGmtBB2YBp7gL+0Slq4S9V2QyhqRYHlTGjQlxltu3KZqx3
	KWDuI+MafYFwR5xQdVu7oZRZsTWLfG38XWs0zJGjWOC+GIkSqJQad4NseEvESz1mv+X2MN
	GVTzjrJbGtMcpNgD27buFrkZeV5sb6a4iPf1BLPXRpwjdXW5AqYHzNJkTi/P6H4isoqjp2
	iTfDkeW0OaKj2C4QvA5Y4ExsyO7duoV0B58XB0UpvaKT6VQEafBV+DqNzM1wJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788424383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1+RlBHvN9fvzT0b4kNv62X9v1GMI5wMZBpkbnRiPgg=;
	b=pDYT7mMjHy+UmJD526epCpQMfULaZm9VG/JxzkXoQyK86LxfyaVsdICQtOpNwZDkryABsO
	kEso24WTDRccffBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Message-ID: <20260903083301.2aPFamvg@linutronix.de>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
 <20260901073339.uyKHXWCX@linutronix.de>
 <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
 <20260902104143.j8BXrjKq@linutronix.de>
 <1846af86-cf55-456d-9eca-975a88777a40@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1846af86-cf55-456d-9eca-975a88777a40@kernel.org>
X-Stat-Signature: 9dhh9ui1mnx4c7kkpu33174octg9bzix
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4239C0002
X-Rspam-User: 
X-HE-Tag: 1788424384-602414
X-HE-Meta: U2FsdGVkX1/lS8+63VS8K2Jyld8AIX3kzR8+2JNIWmLckIKIc8SwxtynqJRqsU+ogAPi0fUnP7keaZhe3wVu+750d650rU4WYFQbcHcD2Ku8laKw0Hckw12eP8I8d3fN0fVPm+hmGeOnez5BNACkZq24o6je2viz0N6Wt45nXjf2lctC4mhI+Y2DJ+o5FxPVgJ1PVodu1Dds2I95xnmR5HqJn78GsRXZb8E8vZbiObbPTOqtIYFqdlEfu0pk2on10Ibb6MeSKQDC+btes1Kkbk4mZP9NLpYzWX/KvIJW3Q0Yydeok35KIdDwY7dPtChZp4d+j0GUbUvAdFHP/p2kUqHH4ALW5dEjx455v9ktl5nt7mM4plw/2mZ3HoxUGPGNnNpTCuBclW7q9eGXwCgkZwknrq60E3jDDeX2zN1RXWwrAxCgE4XfmkLyuNTRbl5jOYLToD5fnGpewYS7odlD7IWInNzNfISnM50FbiaemanbrPXDTOAumsaD/vujq5K0BZ78Gch5OgZeHEeeTwiB76FCAXwoqGgnUPnpDtUYahWupBbwN+UuUh0jN8+dxfM3UU7a4ius3v1jh/kC1F+PqJP97aMZzNk0zg7GR4JhhT8I1Q4OKkFJKjqimxvOm5CWE/Pvd93ti0gv9uW8wrzkJtusC+J3j2XTeK9Z8a3dNTu8CVBx/Fn9wfZgpT8gPnsBMO8xccXWHCetFPbDoLgSXWfGRRbNBpki4lTsAa1nA8JM/hpbrnFc8zlpI7Auf75xK9WNJvDdk6pKhK9Ytj/YgiS29YCUapquu0TstV4gm2MRlksYfIDLnH6RnSC2x9u6kCR8y0HnUG5MSN/gFaPVRvqb9NoVAMu+le/GG8pNiDIn07j92LDwSNzkGcuu31squTqN+Ohb/7N8wzJyPn7TAWDIGoObG52fx3QDs9LHROTrC7ripmXYHBoCYgO7swBn71uJw+0NaWbMCCCYrQc
 zb4n8UVI
 dtRuEVfwWs7rSzrOh1NFE7CUD8XgPL/u2EUYZKHsV6s5YENan/yGTI5Enj4otS+7fhUDRlIs8UfkCZ8j4BVVReNqNzvnolCsEKF/Gi6onTYzJ9+7P6mWCjZvoJ1jgb8BkqgDvGBmBvkY++sMiyJQ1tya9EFLN0iBOPL/Ycb96VndPghSnZ1juNnca0XiGHcfPR5ZFUvzSsPcZD3mbYC46fc6SzErRNAiRLASKoXNnllJp6eYLqZS8oax4BUtCf+IHWCxZOF2UCkU+9CvzvI+CpPb4fh6YnUDATKsxZp3aUgOo6+O/boAv9ZwvLNPLDOQj45lDSAq70HcPCwrM6NaWIRf02O/I76yyHMeuDMqh9IBvyOzUYDEzcz5DIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-02 16:13:30 [+0200], Vlastimil Babka (SUSE) wrote:
> >> Per sashiko review it's actually bad too under the pi_lock, because
> >> GFP_NOWAIT means __GFP_KSWAPD_RECLAIM which can mean wakeup_kswapd() a=
nd
> >> thus also need scheduler locks. And it's not a PREEMPT_RT-only issue...
> >=20
> > \o/
>=20
> More like /o\

Yes, true. But it is not longer an RT-only issue.

> >> > It could have a pool of X
> >> > and if it runs out, it runs out and waits until the clean up process
> >> > feeds the used sheafs back. There is fallback and the run out is not=
 the
> >> > usual case.
> >>=20
> >> I'd rather not invent new pools, since there's fallback and the sheaf+=
barn
> >> is already a pool. Could be enough to make sure the allocation attempt=
 is
> >> safe, i.e. use only __GFP_NOWARN.
> >=20
> > So we avoid the allocation and just add it to the sheaf+barn and this is
> > it?
>=20
> We don't need to avoid the allocation attempt if it's done in a safe way?

If it safe and does not not increase the free-latency too much then it
is fine.
Now that I look at the kvfree_call_rcu(), there a timer, hrtimer,
workqueue=E2=80=A6 Oh. And a __get_free_page().

> Note the new sheaf can be also served from its kmalloc slab almost
> immediately, going all the way to page allocator should be very rare.
> But if we stopped doing that sheaf allocation attemps completely, we could
> easily end up having long bursts of all kfree_rcu() being deferred.

Sure. If you have memory around then there is nothing wrong with using
it. In my naive thinking I assumed it should be enough to fill the
buffers and in times of bursts having plenty of RCU callbacks which are
throttled.

Sebastian

