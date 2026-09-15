Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DF7C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5576B0088; Mon, 14 Sep 2026 22:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA59F6B0093; Mon, 14 Sep 2026 22:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD1A6B0095; Mon, 14 Sep 2026 22:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA0B6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:26:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B5931602D5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:26:45 +0000 (UTC)
X-FDA: 85214408370.21.E70B37C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 725E0A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:26:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPLksAgY;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FF/hMzJEEBjVHj8tu5+0x29Q3pa1mk5zwrpdsL2Gbqg=;
	b=czr1QQEq8R+smRIOnEp3TiMqm+ufi5ZBQR6yMbLgmPT7bWogO8cUcoR/vlvUnrDSLw+Gf1
	kPmqUphv1/sTmSHr6O7jUxe05QhhhMnkSI0wNAikfLzf2FRRFSi5VKMIVpCy/bA/SvaHiR
	2/gpmcSA/Lfg60MNHyJQLS43UEiIozY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789439203;
	b=kydTddLrjxivoLEyREe0n8Jacn/UWBg+cISmqXalJN4wr8uE1KBpKE0rURrqG9f21Ctw+P
	cfG7gbwG1neWqyc09E57Q45KKopC+VcOCqW6ah82z93WEnpe4KvZzZcQy3ieLi28698HFM
	fvtfqAZU2vXmt5w12C5RzlXQVZuWyUg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPLksAgY;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E81940138;
	Tue, 15 Sep 2026 02:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D561F000FF;
	Tue, 15 Sep 2026 02:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789439202;
	bh=FF/hMzJEEBjVHj8tu5+0x29Q3pa1mk5zwrpdsL2Gbqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPLksAgYffr0yle6lKJ6XByLq/4bc3FRUCodqnf4SrClABYzHbAlOrsZjitB0eoFM
	 rFkVa/PJlHlAg2Ran+D/zwQBrPw9NSVmsdQ+90da47gwcAt9fnNMHf/lqveBv1ydk7
	 W2Coiaw+m17khA9iK1rsB6UZp7xpk8hrVgSUreA6NQnsSf0woOVy5FhFt8NYn0X4AZ
	 xiQyesN0WbmdeGF5iOnybS/2YvZux6O/LOm9qDKkCtrGxH6kh5mSnYXOxfm8A9Q4Tr
	 wayNzZCNfrYd0BvA6va5cTa+uUq7QT7ObBguny0eiGOnr7f5zEKCGuBHN/XIi9Hk+8
	 A9QDivFwMiVnA==
From: SJ Park <sj@kernel.org>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lianux.mm@gmail.com
Subject: Re: [RFC PATCH 4/9] mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
Date: Mon, 14 Sep 2026 19:26:33 -0700
Message-ID: <20260915022635.103818-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAN_Opa8qSHcDNU8k=EWMywUADizJEhHPpuia3jMcZ13i5iYXgg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y98iej9bdbbfohuzba3is3pp6qka97a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 725E0A0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789439203-646246
X-HE-Meta: U2FsdGVkX18OckGoQ1M6E4eX+vpuNJFrXndI9pvjvWQ0lZjElAzkLMTYbZG2wNs5I2XavxyyA/S6hLpCdKlIibhBP4BrExNBdsPk2Slm1cpNwCBm8I4I4uU2hSlineQCiNIvd1+91/JyLfXTL+1XsNwKAPopQXCksFv9aVHxSqMvmiltwzJIjNDOBiT+WWEqrQVCMqb4D3C/6Pd3I/2s1CuLvkN6S8tqwd5ISeGTAka66dDXR8ntekxG4VXORea9xHgYqZkCOwHc/QzbFuJPUC7GWThLttgKCkgOUhkNhhursRSaEmKXmFrSkB8IQgyFREscHYkuxN+Q15ZQnnzVZUFosCdya/ISCzQW30QXDVhIRafmVqNqUE836kejcsKLJqeqUdZHlNXI8dV3b+AHfhwduMlS/6ZdY2/WMMJoUhm7kg38N/JQo88SouyWGSTxw3D68CdYJnzTh9Q27MK0ZbDNq3Uwkb85ed7UOcKn+AgtwWqxCaEZE1yePplISwNnQ6rpl6t50geBpWoEzTmu+XZ5HyUuxBfLJYyNdVmgZooa0m90qVe3QCroZ/mBH/8R5BTA57aT9RibvMzIYCP3jTBXGClbdXv2iLH9ZArkqEEZWG+BbeHXJAUiw01sFaApStLsVLELzBALhmhtJtlpzsKVlkvGm5FyM7Htmr5w3CNBQ1sxAAKXMTs89FN3GCBV3vkqgkpbCYkRRVr42WaeITbVrEQwnMRVTbH3v4OgBLG82OWhQZrxeZRl7C7BEtlqoed0Wva0Et0aGQqU+d07DUyVgocu8hw3WdF2CXe91YewJXgsjp5mOUrYo/UDzMKLqsDcMMB1ZKxlykZd43X61QNEHynxYYrTjFKQKrqyBmVazEBPmC+RByDFvyEmy1BI1xpT4h0ieRQDz7aAZ67HeEnUn9tkrTf3rTGMVOSCAHsL4aKmwXJyhbFLbV4Nvf+bcvdEUOjnhltCbciPQIL
 Zpktr2un
 G4d94lT7EUhkLydv7oX0+np1TlLj2HqvXFitl7cBm7ixpaoJNlbDDhaYkt1d4EviQ92JqmCDERZAaZlVPmTS16yLsKzyOqkYxQJMdcFWpOmYeqtnIvtkAeA0rAVWVIYsn6w0G3Scw/OinRRp4XeclAGf/bVqu2LrSIu5nLcSEPniKaUbs+BZ5uAMdPqxRdonDZ0nKbx893A7unkHmnRjO1wK4qj82yctQUjyWJnQxNT88yTZA6Vcwb6n+dX81WFXS6dPENgXcLA8tm5n6leCcTsRS9mTQqd2eayawT0bRfoYX8eWR2C6nJIKcKiZhhgthhbzw194u6P40QvkspzoTAU7kRQJw087Ap1hwYuNzGzTsUCgZKvg8+OJgVsgfE4CkIrfGVDMkBEehRezI8LWuM45NLvFWSL7qNWHq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 10:19:43 +0800 KunWu Chan <kunwu.chan@gmail.com> wrote:

> On Mon, Sep 14, 2026 at 11:16 PM SJ Park <sj@kernel.org> wrote:
> >
> > On Mon, 14 Sep 2026 23:01:48 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
> >
> > > On Sat, 12 Sep 2026 13:08:05 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> > So, if user sets only time quota, and then commits the quota to zero while the
> > esz is non-zero, esz is never reset to zero.  As a result, DAMOS keeps applying
> > the action with the esz forever.  Correct?
> 
> Yes, the stale esz path is confirmed.
> 
> One clarification, though: it does not keep applying the action
> forever. While charged_sz < stale_esz, damos_adjust_quota() still
> returns early, but damos_apply_target() continues to apply the
> scheme and damos_charge_quota() keeps increasing charged_sz.
> 
> Once charged_sz >= stale_esz, damos_quota_is_full() returns true,
> so damon_do_apply_schemes() skips the scheme. Since the early return
> also prevents the charge-window handling from running,
> charged_sz is never reset, and the scheme remains permanently
> inactive.
> 
> So clearing the quota can result in the scheme applying up to the
> stale esz, and then stopping permanently.

Thank you for detailed clarification, Kunwu!

> 
> >
> > If so, this may deserve Cc-ing stable@.  Kunwu, what do you think?
> 
> I think this is a functional bug in the existing code, and Cc'ing
> stable makes sense.

Agreed.  I will post this as a hotfix soon.


Thanks,
SJ

[...]

