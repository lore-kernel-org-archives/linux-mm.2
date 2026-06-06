Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B38BCD6E7B
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798126B0005; Fri,  5 Jun 2026 20:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748C66B008A; Fri,  5 Jun 2026 20:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E9A6B008C; Fri,  5 Jun 2026 20:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 589806B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:24:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E829B1C17AD
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:24:55 +0000 (UTC)
X-FDA: 84847592550.09.0983576
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B70414000F
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:24:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyEvHHTG;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780705494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moshiuy8JwuZ3+oTcEsfObj1AtXF7PyldC/qvAt/mT8=;
	b=0Y42zOdzAtWnOxLDsKGivGnCCWamq/ExYX9iloVnqnuf4JFioJgavD2suy585iCY7Cy5vV
	G/1HZtPVmCgDh3WxWESLv1ee8+GvSwsEPCzFDLhfpxkGqTg+WC4mdpkpeQYfra5cjoiOSG
	Dv76vS1FgelHDne3PNYO04gdITOcXvg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyEvHHTG;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780705494;
	b=e2kgVuZUcgfWApCwdnbezvK9cxn3kQx+MrxrwSinoMTSzYRYOJq8Pm6tUQp7BFvMktV97x
	R3q9nk5e+aTBKn4vTRkfqfshNvnJSpQGPso9az52Bpz3eehGSpX0fPs2qUkJgAsk1WvifX
	8R0GNgVxQp7vZ6COrh0YSjtPb94qM8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C70D4389F;
	Sat,  6 Jun 2026 00:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B041F00893;
	Sat,  6 Jun 2026 00:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780705493;
	bh=moshiuy8JwuZ3+oTcEsfObj1AtXF7PyldC/qvAt/mT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyEvHHTGx2S8OfnbQBiJk8vrArJ0wxW/Av0tdx4+2ZBODe1njfPe0a0qu5U6c6NSi
	 t9t3AGBRb/Y+gnqn8t25ynFGdKFBQACbzmZxJSxWlZDHF19mkKv1c9qNiYKfTlYQo1
	 u3HOOQdIUkf8Hu5iBdJJBmR28Y8IMO1oJCDt25s675D4E73mTYqDx4Eoma8yrsKJM1
	 eTypb+Q2Nl7dOJJgqTru5dY+ySXAmsR16L2U1BBGlYdsWJFDvQ7sIK8D2OrN4zD6Ki
	 t0leWaUvMuwsKSSI/4JyaaZHi70xH4cYyBDX5s4BKcMfWK3zDaZK6imCI+PX09RBZK
	 K0vizNfCBjGeg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Fri,  5 Jun 2026 17:24:45 -0700
Message-ID: <20260606002445.88776-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B70414000F
X-Stat-Signature: abd8jydwh39t87ukrzw95ado1tgzdebx
X-Rspam-User: 
X-HE-Tag: 1780705494-37833
X-HE-Meta: U2FsdGVkX1/gsEuahX35UHxqMkgrP/VhSIeubqdhI4jqjwBj2MMdLgDmlkjV9m4tF25dXjwtUhR/5zGQljBqd87LFMwnXqwzJ4BJPgy+ncvWCRA+5Q1KUj8+BSyGrmyM6V921bnSQ1Pz6mnK08s7FwDFiq9aTtF5chAQoKObiKCiadRDfi6p3IWT+m+Bfq0RDXoltB+pMURVUpfJJQXLkPsgj6uu3GqfKSBWvx2ihCxPT+WnKa+vOG3a3o48UXmbCKd1KNU1n5FVdk5bgJK8Cf3Hi848C794rX+HJFCvoY3O8Ai9DbaAylRSv1Io2M4Ia9NqLTEg40suKCLF0qEg1TZVZykNt7pt+dhw5BulMWbXmFSir1SjgdtEd8If0f9ZmFeUQSr26V42r6EWut2ldixgChM74nweQVZf13cbbPSE0LpwlZEYNsPH2CxHiHqCOFmoMYAhQQzH1gxbAfGGMQdvi7NH6vNFS7V2n2rRpQVBszstQJaPHF3hGeGetWJFOJiMuy4GmYHKzjDVdRS9Wco1HVnbRyzvaWZFzDtAMV5XjPOdnJy/GJjow5dbZs/AgtSiq29S1Z2n9ZiExCJ8Q+lrf1bT9juOnPzVWjAEGwnAcmweTL1AtYuC4W4m0GyseJzOTpBCSyzJEd4Tkw0bufJZPlCRZPelZ5i0YS/NG+Hb8WIZsW5GZkdeRthCiQ44urca76v+dOkJgOb9nRqnjOjQJ+YSAxmJg1DK06EbKtYRH4LW8Ihu/NCHJpNacO1brMg+6NC+lbyAE7v4lHa2p3wmDCKFof+vKAZbKmPWaSnwUazn350od44lU6LCAUZA9nkUiWYxiOwoEQ2Rzf1a8ceNhETt3xLIMS9kYbKvfwrzI4xggkc8oDADcRxjnNNqsfDIZF8gmNK4+PC69I19XUmbN02WrzXEzCUknX+b4FU3zZMcRkkS0jB+k4C87bG7GH1aOV4WZngECjGBFVM
 3pWzcgd5
 cQuwEm9Bv/vhN4ou/TH0ksagDGFYpETWDbERHoAKbjcicmOcKw2Ob1U4HFlkWxwqSNLmf07bKdHulVHdo1JBdU5koKK/f0kMr9ULgKQikwZudQDyH0R4ea1ELtZaOJpkHwLMQpw9WO+yayohKn8zW8ZIXzmUQ8EZN0ngP9JRZmZYZRrDrriphOGQ2NNw3OQ0ts5lyscp7VUnfS7aY+mYcHuLJJxPFYoqUbThetoY7/fzcXUII2pxpcZLVoSMbljNCiDP3Kv+ZKpsQZr+sJY08trzHf00V+K+3Eg1GRQxm+uQiyPMsjfDVp910BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 13:25:56 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 6/5/2026 4:34 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > 
> > Thank you for revisioning this great patch!
> > 
> > On Thu, 4 Jun 2026 15:03:33 +0000 <gutierrez.asier@huawei-partners.com> wrote:
[...]
> >> Benchmarks
> >> ==========
[...]
> > Also, have you tried temporal quota tuner?
> 
> OK, I will give it try.

Sounds good!  These test results are great contributions for DAMON community.
Nonetheless I don't think those are blocker of this series.  You could run more
tests and share results even after this series is merged first if you want to.

[...]
> >> Patches Sequence
> >> ================
> >> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
> >> Patch 2 -> damon_modules_new_vaddr_ctx_target
> >> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
> >>            and the new VADDR ctx creation
> >> Patch 4 -> Documentation
> > 
> > As I commented to each patch, patch 1 looks good except a few trivial things.
> > Patch 2 seems unnecessary.  I hope patch 3 to be much simplified and wrote
> > again following the sample modules' pattern.  Patch 4 seems too much for a
> > sample module.
> Thanks for the feedback, I will work out the patches.

I have a trivial comment about the 32-bit overflow issue, but everythinng
except that look good to me.

I feel like we are going on the right direction and this series is getting
closer to land!


Thanks,
SJ

[...]

