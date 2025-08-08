Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423A5C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9466B009A; Fri,  8 Aug 2025 13:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94D76B009B; Fri,  8 Aug 2025 13:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB126B009C; Fri,  8 Aug 2025 13:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 976D26B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:11:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B349136564
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:11:27 +0000 (UTC)
X-FDA: 83754231414.14.D705BA2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C5DF18000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:11:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CElcqtEb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754673085; a=rsa-sha256;
	cv=none;
	b=tp7GjDQhDwTviOO5fjYL3vveAalqT+UYO5IUtDSqHv03GEy/TwD7zvDWp8ZIqCAnw1w8LE
	t+HLY2AIqxGLM2EOwtF7q8c4+28KSJTv8oLHcH8n/WF+DoxqYamZuz4ek9jueKTIO+axIL
	DPF5cg5G4quGliw6Bj3UhdUgat6zbLI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CElcqtEb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754673085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AN5FDs4VNH0biEgFUkAbgzkMJXtI+2MaO42Y1e0buVU=;
	b=4LU8QFfOhtbhPqZI4V8RKaa+jBTrCWGo2iw2VpnGWw6tmGYSOrxJlzTbMxEfvyg0fF9oB1
	3nwXhxifaOwvcTV/tvxX50pNXLxxI5r6V4RBSGfv9PK4766sUmCCckZfkIVljBiSSpwblL
	F7ynASrUjj+2IXrizNWa+UNZFGv62rA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id BB824A56AA2;
	Fri,  8 Aug 2025 17:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442DDC4CEED;
	Fri,  8 Aug 2025 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754673084;
	bh=cxbahvdxrfG2bKXR2hXt2zf+TgKZQvSGJhqzadrT3gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CElcqtEbjbOBhnao5gJCZSLSGFC2i1yRR9YmciKVw/TuVzK2lZoP9TvQvBZ6MEgQN
	 sDK7wQJRME/P3g+yDRivHfXGBbAeKyH+RsN2OtQG1FucMAeSx3i1MqWfE1lbplbh9u
	 HF6e/tftlRmmButPNn+kvGKsXj3XCAdsNRDKQg/3VkDUuu7cZPQC+MTlaHSAOGjgEo
	 v1F3t8hjeKDxo/RM0JQxiwbHTTAAydCyJuGtE+VE7dssIxSPdmRe2aadhk3/xD8O7T
	 9HTWYtnKdXd815wyfYHNo7To+ZUe8hsoGTFuSCvAkO/1P1bPhOAvikUd8pU8s9KNVN
	 tsJ8IbGstUaSQ==
From: SeongJae Park <sj@kernel.org>
To: Philip Li <philip.li@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	kernel test robot <lkp@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Date: Fri,  8 Aug 2025 10:11:22 -0700
Message-Id: <20250808171122.52633-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aJWU6RA+t1XpJLY/@rli9-mobl>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C5DF18000C
X-Stat-Signature: 9u5xdz5bh96g8bjzu1ierzjmmdwr6pf6
X-Rspam-User: 
X-HE-Tag: 1754673085-417173
X-HE-Meta: U2FsdGVkX18BZjUcRlO511YiTGFnsbUf/zKpJGIMXTZQVQhkyePZOrxjIEblxVM8vKNKBF1Ju9PrDqWQo+wzPRw8hvK9d7N/yq4y10Rlwlmf/s6Coq9Tb5GaDMlv2mjczNYgD5/Pz9LH6QbVx2McOpUfwiHswNt0958oiVBvzCbVzi/wFbojCed1f3hbNtjsfrfUCh9srk3SKoAreqCwbsiI5u0n8Y7dF7VbNb668wDg1ZH1nFMgmGssPV8Z4caHBCaVvTq1aATR80BHCgOfGskquC+K59P5iOtxjv6P3sRJYVjtV8ZyuHNoZQUSfxOGF9pJ/nhevXZEkMK5DxRa1IltLmcgI+UXZC03lWqj36PIfPGzcbQmSjQNdIoKa9ogDojBhJdLsTDF9d68bSAn4VqLTAX/kvbjXN/pGv7TbScya3g13I5jry+NllDuYDwFhsliOXRqlFY6W0ZZmiiZz6j+2+OF0S3S/JKJ+h//apNbNFN5zbUJohodFRLMkk9hPDGZdJM163lPU9PZPYqqGk2nlddvcQ6jqKkAftZZvQniDujySLFQ3sTvHscRTpub+KGrF9jqZMsBDt0UMjoZzM5xpyLONHKXeKLWcPGCNj9oCU/SpDqixSj0YbUNgYzAWTpGdQHqPCaDEzy8V53pAB0IOBnw2wRsPCRiMTv7U4nQppQNh0Rmtn/aH/q4SyG8QvU5WMKQqKhZ4rsmTUJpgd/AH0Sr1dKWnPW4s9UpzNeLtbBKbuc2pR+i2OTRnSBBuzpRwyx1F8Xc3nWREJrxVbdcw2J7SpjZnhc17GSsmcA7XbpcNxi9EvzZlDRSqsAUVts810161+LKihW8rAzEv1fhVRd4k4wnYMnA5hntwBOpvKVp0hbSFIKC06wmNTLlC1V5mXHjsYsKK9a+ShbFuAcqvWVhjTRRgyws2u0oIG9kOrGcSN+RXjaoF5FjtbCWogpkQC2Qf8gEJwiauEc
 5Fyy/4Ds
 qitIey3Y3Y4DUFFgm+J56Bskxz3Ra0CHHWYtzZaTfRusdxobzPZKMQHr03XGDJyzDvgDtAn08+E13Po0IQ1cgdeiGLgavFi1P6EC/iZ9TeDRBpXWn77kVYMuu7xbHAKnmrtl0twSU+UeZPeaQvVSGc2BdD+U5ri7d5fye30eyQ+3axwchMNgGrZk1yYg4MYFW4vuyTQCaWKvIT4pbTzo6WJEK2SHvmoitKFbkU+QasZilL0Oj+l0MHPfCoVETbfmH7wW/GjglHiTs2qMhFjo9xYb68yIbobOnDPIkq8uc11Q79iM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 14:10:49 +0800 Philip Li <philip.li@intel.com> wrote:

> On Thu, Aug 07, 2025 at 08:58:05AM -0700, SeongJae Park wrote:
> > On Thu, 7 Aug 2025 15:16:46 +0800 Philip Li <philip.li@intel.com> wrote:
[...]
> > > Do you want to just ignore mm-{new,unstable,stable} branches, I can configure the
> > > repo to handle this?
> > 
> > Great, could you please do so?
> 
> Got it, this is configured now.

Thank you Philip, I also found how you did it:
https://github.com/intel/lkp-tests/commit/1d80cffb312355044007b6e453c08a48a1

I will send similar PRs in future if I need such changes.


Thanks,
SJ

[...]

