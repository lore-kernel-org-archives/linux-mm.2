Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B096CC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915676B008A; Thu, 17 Sep 2026 03:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7B26B008C; Thu, 17 Sep 2026 03:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6596B0092; Thu, 17 Sep 2026 03:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 612F16B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:39:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7670DC026F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:39:42 +0000 (UTC)
X-FDA: 85222454604.17.9A94C02
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id B801DC0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:39:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u63kw8gg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=eRMxAfrK;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789630781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0igQin304nP9DurEyIteQCtX8TEHH4rBGYmjaSQfzyc=;
	b=ksPCEiufLkPmZbDytdp5Y6mQvu18H3tN2mRZPHuTaj1uXqZN0OTngjBnlC1vxBPCPY8ghd
	gkOmRMUdHuBaJCswef55KR8AttwIeDpnDp8tTgNFB6yYxiB/+lYdOajRWip0x3t4cJ6ZGD
	yq+/AU7eehb1lxDkwFSkweOP6atEgxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789630781;
	b=s6P3f0lYOzbU0psxEuVRETcd+zD/xn2W52wtP4s638y9Z/5+b3jx4r4HiUZ1z8X5ayyZIF
	BwlYNBdGvbwLql2vjgtdBE2KjHvu5fOFSusXvKynREr/0v7+6LMTdK0PR5+Vsv/lW+zNvy
	dNoAc7LiXSrUi3MgajJhYKwCphK4Iqg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u63kw8gg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=eRMxAfrK;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Thu, 17 Sep 2026 09:39:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789630773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0igQin304nP9DurEyIteQCtX8TEHH4rBGYmjaSQfzyc=;
	b=u63kw8ggDgGCYSxjvQA2v7fDXEW2lPCH1T+Q07Q/QeLn6cQV+2QAkbF1Os3VH9gwTCzR+R
	DRXDoGuV32CuTSNNju1d/A5BghGYPzHzw4YMYCFo2e8SDD3M1RE5n34J3WZ0sGrO9/foyO
	sILJ63OAVoUFhFEAkLwa4KaR6gC0S/wMvhL7c2LXtwg6Zo7opY24flhjzCSYnpSfWQh6Ce
	iRbmIfJieVUHkKigmQm2fVMHRdcpaV8XEXLTZp/sanuNNneWMw++bHhaTQpqKkHNBUZ/ED
	pdIlgdPrcbBFUm2ZUa78mX1xwOF3m38Zw2ggeQaP2LG9tUGGODaKwt69aX5XYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789630773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0igQin304nP9DurEyIteQCtX8TEHH4rBGYmjaSQfzyc=;
	b=eRMxAfrKdQDwv6Ea2Fg6UimVRKEms3XXSHbs5tePWbDxnZDFePCEYBq747W5wzcm1chwGY
	+LVsn/6TxAlf2KCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, dwmw2@infradead.org, dwmw@amazon.co.uk,
	kvm@vger.kernel.org, liam.howlett@oracle.com, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev, lkp@intel.com, llvm@lists.linux.dev,
	lorenzo.stoakes@oracle.com, me@brighamcampbell.com, mhocko@suse.com,
	nogikh@google.com, oe-kbuild-all@lists.linux.dev,
	pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org,
	seanjc@google.com, shaikhkamal2012@gmail.com,
	shakeel.butt@linux.dev, skhan@linuxfoundation.org,
	surenb@google.com, syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
Message-ID: <20260917073931.iggMficE@linutronix.de>
References: <6936812a.a70a0220.38f243.0090.GAE@google.com>
 <6aaaa2da.86093f18.33004f.0001.GAE@google.com>
 <aqrZMReaQPG0M9oV@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqrZMReaQPG0M9oV@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B801DC0005
X-Stat-Signature: cfbpdw75udxmczp8qza43ac1p75pnxf9
X-HE-Tag: 1789630780-194807
X-HE-Meta: U2FsdGVkX19T9LmFqJNQzGwFxF1s835pPwJ+kx7Ainz4knfmhXjSNKOhnTjaBUR61y2/d5BgaOeak5OzMgydEbcNKbOC0tG1pvrJ36YRV+64U14MqSf2Q9BlXi0JAYOUKWnkXmxUNj8Ba/a46E31R8XtvZ86U6K3Km1jnZU3rpLWcNaCy9lZ7V5Ituxg0Ng6lIaVJAKXLdIoyuPgCbytKX8rrmKB7gusEo1NzlouCcflYTQ83NztBfyjmL65En5YGiyJ091c1VFAOxK3QI2MTUDN4HCW3ix6fH6J39/Q194cXsQdPHDsGKlPQz6W5pfnZmS9FPRLtnWPSwI4LmbMCfChPTB64b5PYJU4+XlDbWvCscm85vyBLkgSG/QwwiegEMCYpUVIbMKd6ZQIG8BsClLCIXh+pX5+0RzpOpa10opI1IE1j3cb0W9ojeHKbCC7ZgWpk4jPg3gIArEndzSOtso33HnO0Zt6b6e3mdh2SMUgOwNR4gwPFh5VDn82ODcrgFhRIlWo+/iA4FGB1Pwtd/mb3RZ0gSTQhAY8tKWYEIO4h1hRvK/TRZs/rv/r5Azn9Id5sElaTkFCquYnPHIixwhjSRhleEnoB7avZXPwicI+i1MP84LQMLY5MumKMOkqyDPOSRs3JfPp8qV4Q6MrEvCl0q7q57EAn48L/nj+tEPDGOiKgpgvIQ2SUgxGKZwLTpXz5DVD9JRV9jS/3IJOpTw7EA+MotjOU/5ErnxBowYf0prBnsDiVa+HPyOUhNdluiRAQZBPrG4OScshrw0fzcwiueGbFtfzreE99MtXrq/TVPPl5bF2N5CAcK2I8ivzvAj9SCiYQGsQoDloPyR+pWVDjfNHFThP1ZBw0nuAji5V5EYGlreRwDEfwxE+Yc2OR0B4xejO/CEYXK1FbGkVydEyChuTOokQIp6jLzbTHHeqA1qj2tckf0mCvIr2EraKb2/CnGihlN8sgKmRf7f
 zT5M1AVk
 Xe0neJAftUiOBN41Jl4zcl3zpcMiwXu4qm91e6xvQmY2rwOq4RQxCD6yZmz7u505UhGRhDxXiKP2y5MGLQUPZtXr61GTF0G6i+f/Sd9VCbcx6P1J3AmCmlW4LBOw+EkVeW9XA1P/v7aw9S2kABeu2IQtqLMsXTCM94EMKFi2kqsM+mHhuTyuLtVcBSZbPIqV6qfO4nJ3eir4CB87fhL4nFZlbbR1LMoXqai/zB1wa1MGkgEI48WPvHfrKK2c0UJDwrEd6UZOBGZ8Fx7+ROeTESZeeO5wj+C90Y+ikRROVFJIVsB3c+CV9SHnDP0kHC8DePjNF61NfB2644MidscFe1BaO9b0nQdzyFSz+XDRVGYAlBS9Em+T2+8mD6xXGKwFC6CFIvWjRfVZchFyfF+1J31gdkhDyU8PVLo1nk+P5Zmvz4cN02DTLlPBRWCQ/yfCHQdZh4+6pEj2AVGjrGHPmLVMqxRVQnf3K7H6vf0evF+RwMbdJhLKiUIGnEDbC/CtuiEiu83pFr+lxFHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 19:05:03 [+0100], Lorenzo Stoakes (ARM) wrote:
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac

> Seems like a false positive and an RT thing?

yes, it does. The proposed patch has a matching reported-by of the
report. dwmw2 did test it via his tree
	https://lore.kernel.org/all/6a8d9a7e.a5a502ce.31d34.0069.GAE@google.com/

Sebastian

