Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DA3C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5A26B0099; Mon,  7 Sep 2026 09:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F646B009B; Mon,  7 Sep 2026 09:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18586B009D; Mon,  7 Sep 2026 09:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 804F66B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:11:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA1FDA016E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:11:20 +0000 (UTC)
X-FDA: 85187002320.25.5EF47F3
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0034140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:11:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y +kYpxz";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=qN686EEZ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788786678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0j3fsVumRKOaqygse+y9YlCuGTHtFBd6bkppJhg5aQ=;
	b=crKTYig9ma7KFajhQIcQF7wy6xh24Y/qMJw4RxtW76Xvn+BlNdE7ImfIXzx+JV+jDax5ZS
	O0IVgJAGZ9D4YQl7JqK8VR6M6Ct8xWMnnEuJGiPPdDrhxMBPGXBaLcWlGSFpc3xJ/FgZBE
	HuJOJGRyhVNMU7cDQPCopprVf/BcQLs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y +kYpxz";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=qN686EEZ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788786678;
	b=Qrgl4yeNAMrRBRLQwEUrZEGzO+Ks7nUjjRYjSEkXjTBccHbZWmGdiKOk/Beqj/5ec3hlnl
	LNeynQsO3tQ2Ct9faGay4w8goxvYqZ5nSUtnB6RFYmZWsZv4sldA1wrY2xg3awQwtxVD5g
	TmLM0Orv07WAcPyHSnWBpMnigETdzp0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 3B9701380129;
	Mon,  7 Sep 2026 09:11:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 07 Sep 2026 09:11:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788786678; x=
	1788793878; bh=e0j3fsVumRKOaqygse+y9YlCuGTHtFBd6bkppJhg5aQ=; b=Y
	+kYpxzCmkaObMDKsElaKybkYiQgDFAOfumjkiK0v6gqCc7U5sXGsc22hXru8gl+d
	JzI96FZcZ/XPyC6fLhv+xxX4U9Nanr6s7UlcXP5h/AnnAuGbgNSUYcHQcbBcHLja
	FdW7ylO/d9rw1Huk9KhQOZk51SAFDvTZ7ODcfddfK7WM1JKshD+bvne+CmRYOh24
	6H6L88Ld5HHTMkx4G7QovqMsd0R10eyIQoCZyXtwxFU7qJ4CESxo70tA1DE+nJZq
	zqbzRzwNXRpYZCAxY0FlB1GE2EQVjW3+OTZFufIRIhWI8Rct/RRuMTkAmkHsevlL
	bIr0g8waGjTv4pzBVrlKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788786678; x=1788793878; bh=e0j3fsVumRKOaqygse+y9YlCuGTHtFBd6bk
	ppJhg5aQ=; b=qN686EEZGG/tsa69vxZL8F3XI2sKttIIO5qdBhlAqyUuD6Rd2Z1
	+2a9luALx1xUUGzhRYuwu/e/jmHiPww5L7zzpLjwBpMs0hxrTN+l8/L8BGDO1iqC
	gJ0dm5/FY0/+A/FtoBKuuJpnaI082/eCVnARX/ebCDj9XSIlA95UpwalC6Iflbfp
	cpoi47OLLqvHcV1iMtyuFdpz0uxhQPp3IJeq5MLW+/MthMEvQH3qcHj08wpVvdqm
	kalN0Z8vr0XPBECWwdRcjLSfevn59rw10Nu9UuKrcgJpM5xGqAvOTeYtXbpS/Hd1
	NPOn6gDS4Ii9KzUhmexqVcEBxj9rHWUS5mw==
X-ME-Sender: <xms:9beeajiUotEuDdqY_HytcU5-9lftUbtXdHdAToE2WIj-H7h2eo_UAQ>
    <xme:9beeatr2uKO4gyrglpPPWgLvfi0ZC58w5zrKmK68FKgVODRqivMp6dQvOOG5F_5YX
    YzOfsxJ79VKQsK0rUhMqjKpnMB2eHm546EceyWk2sjpW65VCD7N0lrR>
X-ME-Received: <xmr:9beeaoq899ew8Zak42SLQR9dmL9HG729mbfwXqE-oaLf78542WfmFaeQ2x4>
X-ME-Proxy-Cause: dmFkZTGCNMd4Q9EInv4pZwT0BWMYc3KKxkNKEeuTjTisAjU8d5Iurn0W2J3En98eX2qsVN
    ekRO29qUaexBsyWN7A53qFlun/i+vnBWAtli1SZa6vfamv7SenRmqOOprxPz+Q/bWWetUh
    /S3jyyw9PXvPTNSDAdwTD/58wgq9G4gqlODsXkcpxOTf+YWzdmvXK+ELl7ZgjUbshPyR+y
    c13E7au5/4A72e68nnUGJ/wf/F+5kOOFDRXY2a5WFfQZeYaYPEUG6Ns+q99gBu8gTBju26
    bGZ1UjcI1UN8N5K2VwRkS/SQMLA//GURXziQRtpudSQgoNzKljxQmQV355Zep/Np6A/6KU
    KgQQ+WVW0mlx1tgz7Frln65/T4Y+JYh5W2jxZK7XZg4UEcTOwCLMGxQPa1br0UPh6FhhHp
    /a3rzemnykab/qHDTUU3TCBJK8Bowu4xG4sg7H2gVgADUprLnw/0/jueoSfX9GrLvLfPlu
    i/4mC40gk+iKxWl2JMN6TCPziEjAPOu7udpC4diN3sTcOWsuLoTrzVfXyfCueXrzWYhCFh
    0m2MQ10Ao35Ahz6ncrzA3jteAAuy33LSJ4BQA8zngl23k8KUI4VjgAsF+9vvyfHDHOFwBz
    cuZCynSFR/UpGwThhQpThki9pueYfybMpTXOHzxiSqnZWkAy0cOjIp5wlxFg
X-ME-Proxy: <xmx:9beeaj5W9Lmlg6Tz7-HMToPbyZYSougqkORofRhP4zJR10UQYhs5Hg>
    <xmx:9beeav27-BtC14nEIvXsWKxxdRiha83uzI9zH36U-xBOovqjlTCo7Q>
    <xmx:9beeavl00NZt6HF9eX_bCAPySDPKg5_q2CVn8MuTQywKD2za7MXIcw>
    <xmx:9beeaogSfjhpC-Wrs9S6gNPldI1-5_hT3tJSJjz1oedHd1-ot8D9sQ>
    <xmx:9reeau0BHTfgTqODVRoJfWKaEOCSyeqmMEuLqGM3np_iDtJs2yonPbSi>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 09:11:16 -0400 (EDT)
Date: Mon, 7 Sep 2026 14:11:15 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/19] selftests/mm: add folio-order detection
 self-check
Message-ID: <ap63H6oZmka_oWpD@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-10-kirill@shutemov.name>
 <aoQzXhP0W0FVsvTp@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQzXhP0W0FVsvTp@lucifer>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tw6x8tpmyrnc4f3ye1dz7134ajmawfok
X-Rspamd-Queue-Id: D0034140008
X-HE-Tag: 1788786678-697633
X-HE-Meta: U2FsdGVkX184qjZ8oMa9D+GWFOdmu6yqDOdBd77QokknIfXy+RfU+5TeOmkdVt/25AclKhbw5d9RiGSgHRuYBcrSafjhmPN3nDYI8UV3pdQk5Rxs4+I01bW4lPrTWvWJgZ0zbFQldQCJ5S1ajrWDYE3nEbstYpHdhn0P1bNcMieV+ebn89t2DFUecSMjbLCpHJFXdQKcjGUw8u1H+uPAjiJXEbA45y0FykA5BRvimeYyNrWFX80x1RccDgTzRawEVVarf1McjsOIzeGyxxTN3dYiPoxIejC86iluKIk6Qm2gxSk3bvXs5Yq9gB2KciqAgb9XdFhnHZfBwUpBVtLNRzR8fs0+OwZGtR7KjzeqvnrqhRAPlNNbQCvp9U0CCTrr0NrKgYa8aySHTyTi4a4P0u6Ssn5xrjjJFX3096oQvZOHpRDjyu56lM7AZwrRvfP/Bo+Q+g/20JsFSr173pP08zZAdWG18LBGeiz8yZWTpbsaiEjcGBSOQwll8+V+5hmXafO0KTzKRJn99R2Cqj00szWROzZNSxwJkDLe6PWZrlkBP78M9jPknZPPgiDnVbJgbcMr1Iy6Ep+NgA6KpTwPUCS4tFEXOf4RQowfMAg5k6PGqQHnEcwjeuJvBsZ4VJKY5AiRVHe1gSQVr0TtBKQwzazfsM/bKvFVkCYVvTiSDfVTWo/jZIPM8CcMDo6Iw7nDASolZIO5lQHMPLMs06/Za66QSt7bJJvYDm5MKBD4mXjk3V7li+/WYiRKihiN+jesECTr73yNs22zGM62Xd4nq5aVPsJlAExBemOxpE00lAVN/eX+/p0FN4edTxPJdZvpkzQ7hYkFp/8Apwk1vaeVzHXzGWOv+l2ZXHR7w34YeCQFkQee1k5h7Km4NIyWu5Cf5450C4v6Dt/KEDMZe/s4pzgWPVGzIWIHKkinW0sDbmVDZ8rDQFFWq8F0ZP85NPWRKHWveSJIDiM3WMDnLN+
 YWYjZes8
 mZpIrpZFoHMLDcIeM24zeG6qoTlQwZy/5gZeIiyA1k6XiF0fYy7TR2rb3O1xl7hrqVSWSledvzU+ynhyBSr6vTXjXArZqyPY093woxE6TJCOoFEbpS8wg7cGm/COlV+A/7C0Lf+Y0FbCZoGtPzd4LybXep5ZeXAiOSa/hDWHjKC2WHzfPA4GY8h19uw+pvlG3EPHglfrectM355NqSOFtp9TvLfTMi9PYJCSOkAf7l5AMxhUcsZ5ABKxxP2yxIFi/Q90Cf91wIyNu2ljglvSF6Sqy78cTnmmps+eSSIR8fcBrKOfNp18DVZhM/gMU2S06GPwY/7q6NmtXQrjdGPxCocn1yhhPz8fciYInLbzU49+QnWt8iq+LoRlnWvkF6TRkfF6Ywn4l+pjWw2Ot9KK4K2l9OCvy14BI/FdW+Wk4koCuytMHikeuPI+nRc0ThrgusHqUYg9GV9TmVOuND0YL5k8aJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:30:06AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Aug 15, 2026 at 02:58:51AM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > The khugepaged mTHP tests detect collapse results with the vm_util
> > folio-order helpers rather than smaps AnonHugePages, which only sees PMD
> > mappings.  If those helpers are wrong, every case built on them is wrong
> > the same way, and nothing says so.
> >
> > Check them directly.  For every anon THP order the kernel supports, fault
> > memory in with only that order enabled.  Require the helpers to classify
> > the backing as exactly that order: not a neighbouring order, and 4K-backed
> > memory as order 0.
> >
> > Run it in the thp category, ahead of ./khugepaged, so a broken helper is
> > reported as itself rather than as a collapse failure.  Verified on x86-64
> > 4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).
> >
> > The test needs ALIGN(), which hmm-tests.c and migration.c each defined
> > privately.  Move it to vm_util.h and drop both copies.
> 
> Also:
> 
> uffd-unit-tests defines ALIGN_UP()...
> 
> And really you probably want to match the kernel convention of ALIGN()
> defaulting to align-up (for some reason) and name this ALIGN_DOWN() to be
> consistent and avoid confusion BUT...

Hm? It is align-up:

#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))

It matches kernel definition.

pkey-helpers.h has ALIGN_UP(), ALIGN_DOWN() and two pointer variants of
its own.  Folding those onto the vm_util.h one is worth doing, as a
follow-up rather than in this series.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

