Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EE7CD98D6
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0066B0088; Fri, 12 Jun 2026 13:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860916B008C; Fri, 12 Jun 2026 13:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E1D6B0092; Fri, 12 Jun 2026 13:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 691616B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:04:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 197BD161B2C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:04:39 +0000 (UTC)
X-FDA: 84871884678.13.D8D3291
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0ED59C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:04:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=SkCA5wn7;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf10.hostedemail.com: domain of "SRS0=FHmU=EI=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=FHmU=EI=zx2c4.com=Jason@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtNLc2MCDhGhm4G2cttMK4Gp2TnrnlYCYBd7sz+n4j0=;
	b=LDX0Q92ot9zctuEvhOM8jSIxv3xtMytN15zzK+tnx9rjessavhYTclYRmuWMqd+mlkETP1
	rYOzGNEOKs7l3ycrhCoLGRAnfC53APjp7Nih54NSH/oo2PXyGRjGjXqRt1TnXaktyYpRi4
	OueMvgM1lKedpw9Ya3IAqMrETsx9eHs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=SkCA5wn7;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf10.hostedemail.com: domain of "SRS0=FHmU=EI=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=FHmU=EI=zx2c4.com=Jason@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283877;
	b=5hvW/EFoHktgIOruws1hfoFXbeRRoMuo07i9ffr7rV1cvySRdYvev61b25W/9rX3P6BQKj
	G+rkq5/GwbX63K21TngEoy/zyrIwzUonMemqkOV+WjKc16TsfqvWAe28iei5LPWInhj8q0
	pKZI1niNbqbqzKvEFawl6Q+N0I6UoUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0919141817;
	Fri, 12 Jun 2026 17:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5804A1F000E9;
	Fri, 12 Jun 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1781283873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XtNLc2MCDhGhm4G2cttMK4Gp2TnrnlYCYBd7sz+n4j0=;
	b=SkCA5wn7FcRWHDB77LQw/14w6pahdvrLSr51m2na5mZ8EuON9aLbb518bl6CR8GAANx6mK
	SGq+vTqROsfdrCd3B9T5y65W+G44LUgYXBqEJdYQOYbQ9hu8BLYYCMClpn6Z+GAQPdwOEa
	sSVSCCza0bG+SmaPxIoVMrprCygE3V0=
Received: 
	by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 3a28b952 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 12 Jun 2026 17:04:32 +0000 (UTC)
Date: Fri, 12 Jun 2026 19:04:15 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Message-ID: <aiw8D_tdKYYNGyN_@zx2c4.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9ee5adzshenif34by8isqj3ptsarr69e
X-Rspamd-Queue-Id: 0ED59C000F
X-HE-Tag: 1781283876-228406
X-HE-Meta: U2FsdGVkX19XhrKaC0C3BGyJuhApVsTtVvFgpK/weWq0MCtxOtubLR7OKPLke/clg2pSkN2f6NUqaq36vhbGkfKScGBce/N9MWKq+9SpiKPh5dAQKfYgQMbszUDy1UQelrjaqsXecHTL49PfaBhLBz8f1tlSlgX7mTy9EbjcnOUWCnCNkig+TctfVxhmotl+AK9f20esbjUOZ+Rc4nAQhmacgycczc1WskpeM4kQD3565dd7vXTIPdEtmK6Ak1qzCvehGrJq1+nxlkjMbE0Rj9fbppPd3rhGATLbNSdOfvNbwm0mUA3hkbrVumQURAV6kJEB4Z0b6d/5tlIJQumQQNdOc1d5y41IttPctBIw5NIwPysRxp+FCUMD+/sj93pVRNxsv14MxpiNIpc93uXDyIILVLCr8W7W9xWtSN/bVu15/Y5Vwqfj6AFSzls0/aVNSypR0ateV83u6OC4I3BitP3cRju3sX2RhmFYnhVocqmlORtcHwLAiy/KNKnnN08eD0x3deV1ZGm5ixDvMVGPZtgk/JWlAK3LhtXRN3UEVBPXDB5ixEMX8RQ/dWkf5uJORXHATReRqCLKxga4z2PvWvVozE9qZaRAjpSkEK0JXx6M3FuySCiVuCaBcY8LonkowvUFeGuZc/uinzcRUXOwu/nO9nBAIPxu6T/TnAFf/wgZKpYyNLQASx5BQ1ywIyp+2EOV9iBKRp537noqzO3x8V/GTZIHVo66Mn+mV3nKIwDR8AEPRrnjM3xTa5WNIGmp0VBnbcG18OgIupm3jUY0fYQL20+v4hklLbcmu0Eg90XU3w60tqmZqhVbHHFY745GPKAxkuvnWB2LnIsJQ6tQF6Sn/iawBdlmXpbM639PDoSKkkVXKN8oV1MpQklfHVeyPomBmD1l88/GF2Eu3OxsxJHp8Q1nitT9zun96Wpa+6wg+ug0ggwwgDgr2zFZbnEBXrFmEt1us4QXcVfxP8O
 1zI3jdAr
 XbXcy7bWTYiDRVDqBXXiNDmucPTBePk/r9CIEjpnsKf/xozE2SalVUUfNwMQxEQDNoE78Yq9AIoUnwwGeLnfkYqSHAfrYSNgaGrdxANXBXC1d7xRYePZ/SFN4W17Z8E+WJHZ4udM/FkQvr/53PmE6/BrJaOs1ex8zJU0wO4xaWTJ0vTesoFgcxFfaQdlM9DDuF5T9xdQBt0CqnU+IA5xpbY9TgHdRvG7Qnu7SKV6D83uGcIi3ce3zXOw3poSlOi1lhrrC6q8soe9CWhjHIVuo7pJDQme81UU8WokMTv9xG4m8+gLOWGZ3k74Cg2H5nKCnN0PnrLVd2Vrw+9HxTpIR3x0GrcfVUhwPsEXDuSO608ec6kWKrvpYkAushYf4MIecTlAXJYWlZVb9TnQZX9TCVVS8zlHxtFn2kqp0cmxip7tEcSI1/x3nGrHZ6Dt5qRB3JavQL2dSTwvCNMQyXtk/OQ3BhDFToEvabMk8thC/CiWncgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:01:55PM +0200, David Hildenbrand (Arm) wrote:
> The droppable test currently relies on creating memory pressure in a
> child process to trigger dropping the droppable pages.
> 
> That not only takes a long time on some machines (allocating and filling
> all that memory), on large machines this will not work as we hardcode the
> area size to 134217728 bytes.
> 
> ... further, we rely on timeouts to detect that memory was not dropped,
> which is really suboptimal.
> 
> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
> with droppable memory even without swap.
> 
> There is the low chance of MADV_PAGEOUT failing to drop a page because
> of speculative references. We'll wait 1s and retry 10 times to
> rule that unlikely case out as best as we can.
 
Wow, thanks! I wish I had realized the MADV_PAGEOUT behavior while developing
VM_DROPPABLE in the first place. That would have made development a lot easier.
I wound up just running this in a memory limited VM to test out the different
behaviors, which worked decent enough for verifying things. It would be
interesting to me to now experiment with vgetrandom behavior over intentionally
MADV_PAGEOUT'd droppable mappings, to fuzz that the careful bookchecking of
that works as intended against droppable mappings. Anyway, thanks and:

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

