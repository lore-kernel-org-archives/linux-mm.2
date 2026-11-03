Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA43F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZY1WNr25
Received: by kanga.kvack.org (Postfix)
	id DCB3C6B05B1; Tue,  3 Nov 2026 09:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55086B05B3; Tue,  3 Nov 2026 09:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44096B05B4; Tue,  3 Nov 2026 09:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA56B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:45:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE3A812045B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:45:42 +0000 (UTC)
X-FDA: 85394081724.19.E3695DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0DA0440004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:45:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZY1WNr25;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717141;
	b=5yRrpn4kFUJbxQaukC77fDDnCUK2s0eHWBfCGA5oE0EyrWe1hkqe7adHkECYjh0dzMTi58
	m7/gmdY2wDVBpk0/KkV/OgnSunlxrddZSOt6nWK4NiEAaa0W2AzX7iNvJ7620e7rxgSF4+
	FvJEK+T8uw7absLlwVseMJ0yl1t+b6g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZY1WNr25;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCL6ienR6vsHs1rddhFc4AKsyfVTg4cYiIABXe66O0M=;
	b=DMmI8KFQNlt9yuCQ3nKF0HoDIWbYsT4eNtyIE/L+3/w9EclRkqzAimUYhmg3lcd/m5cUxk
	SgJIo38CJYE8E/xKjT3COduVmOPbR3oU8gN/yaIPKDq21AQC7cbYGnVUB7QnNR8t42F9Od
	ow1hD+qopF2kZbs3kQCU63iRevtWCEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F7A76022B;
	Tue,  3 Nov 2026 14:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E123A1F000C1;
	Tue,  3 Nov 2026 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717140;
	bh=BCL6ienR6vsHs1rddhFc4AKsyfVTg4cYiIABXe66O0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZY1WNr25RicuYSX/YFwdj8SN4PIN3yIx3Q5nv+2Ki/G1ymiibwii3bPyPf294f7TH
	 H9qx7tBPdAIRSKB81305msBlTqyTu7f+RQdSm2gySplVyZ4bfpguGKVJkpweDMw8NX
	 9V0bXu7zouY+vveCWfbmLwfQDTHcP4WDiWj2AJqeCuWKSxs+EuGM0fzk4xjnHLKURa
	 UQEHlUrJoaldjBAnRnk7MqsJaj7FqPfOJ/4H2/8KjH/RxRvveyqx4Vr89RuJ+P9Dpf
	 1IB3q0/a9XULP0BL2YuUjwuyLb8W25z20yA64cXEaumZPNq+uD5sZqtpiPaZN0Ir4z
	 c2GjtjbqSrT+w==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	enze.li@gmx.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
Date: Tue,  3 Nov 2026 06:45:32 -0800
Message-ID: <20261103144533.87946-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179370190119.71013.18301574509097172702.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DA0440004
X-Stat-Signature: 7p563hsjn5co9g8q9h68esnjtcoxt9ww
X-Rspam-User: 
X-HE-Tag: 1793717140-268863
X-HE-Meta: U2FsdGVkX19mBVaW+t2da380LcjGSkE7fk6OsnqGu/nO6R1FK9BzLK9B+Orr6P6YZbXeJ5St8GJt+w0SkPKR+enp2eTlctCX/9KUV7/4Tm+KGzUFT/Nb2uEx/Whr+jwUMF4SrSGPCbuySFVI70lMqPLIAcHwONCcHYsOWbYCdMOwZqLkRhBLgFEAP8tahVOkJ6jeD68Qqh63MIZtBke4rCw9jSBf59YwdqAngtZP4qYttK5MnykIQR2esxUCtZlOqQTY1AKHmkvNl1OmIjMS/jey2Fvy3TneajiooKH2NyfVg+v+/VzNKpSmC5kUHuYRDZARtEP1lTYWiRYGuf3qxLZ4WrZOY+3TgyihkODf6r7JSlEeHrbEBPGpAmAvEUO4w7jW8vqC8Js9CJgQwevOrOr2eXAsOQTSnHM6Eodwg1v+WQ2MIsoi8aUEgRWEuLFuvB648cqcpY1uDrLrQckkgsT+u7ubFy9r8m2K/e9O1ypZn3Smsw9hLi44uD91yYXd+hqDDWLcBonE/SpSlqQaG8V5h6TIq0AqRH9Y6h8LKsB0laXe09Ob0Wm+1RupyQDa1TPZhNy9Wuq32d1GV7Tddsdo8N+Rxd/gkXgx/8dVkskq4jU4vUDRRLwj9GElxrPZZafNViuxMh2e2R2IGOp9XDViZEVfJhxSe4h3QXCh3dRw8jF/Hr1pb4Fly1GfZ5gFcxlKhmyJidIqW5exPHio1EPr/mCIReYAXqWrU9F7bGE7iixXIoC/0hdPKoORDmkOIo7GSNwdL6AlGbrpg/psC0pzZPqFwLCuZT9rY9BL3aimL7NSNmFL43nxDjWBT6VeveKUiXMO5JgOWq2XDpBHY4Yoo+rYWUtCho+DSaDx6MWrW4hsVsCDHiExXGPSPQw8h03QHri9BmoTgnBn5lVIycn3tyd6DVDOTCBL5MEJeTy+xk3UN3hFwKWDJNhN/J8X7TOOQ27QpbwvyoAcSKq
 nlLVLCTA
 NqmsEenydeiySCiLk/Rkp5BI7PpZhvaLbFf5clUZOJFroG8Y4Xc4O49B03vZTXohFPE4oM54B+QP2pd47liHMXDb3A7PEa2V95gYYRlME4uzY56u8r8N4N6Ou5/CHqCsz0WFP8Iz0NqmF2AcTFL/sXipGLQKGXXCyF4SEpxnNisPBIyX9nM49ulkFi/eutXGYrXaHjqkTY7ovIAGDo0j3Th+1gwSVUk9aqGoEDZ1HniFo1XHZ3+aEOo5yZrjcWkuEs3lterA2qqBmgI6hQHl9hjS1pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 21:31:41 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi Enze,
> 
> On Tue, 03 Nov 2026 18:07:14 +0800 Enze Li wrote:
> 
> > damon_next_region() and damon_prev_region() manually do container_of()
> > type casting to fetch the next and previous region from the linked
> > list.  Use the dedicated list.h helpers, list_next_entry() and
> > list_prev_entry(), as damon_first_region() and damon_last_region() do.
> 
> The change looks correct to me.  list_{next,prev}_entry() expand to the
> same container_of() calls, so there is no functional change.
> 
> That said, my understanding is that the kernel generally discourages
> changes made only for coding style, outside of other work on the same
> code.  Documentation/process/4.Coding.rst notes that "pure coding style
> fixes are seen as noise by the development community".
> 
> SJ, what do you think about this kind of cleanup for DAMON?

I think whether it is noise or not depend on each change and the volume of
traffic.  Let's suppose a patch for a real trivial change and there are many
patches for critical bug fixes waiting for reviews.  In the case, I think the
trivial patch should be deprioritized, and we should discourage sending such
patches while the urgent reviews are done.  If there are bandiwdth for review,
it is no problem.  Nonetheless, I would dislike patches that making only
trivial cosmetic changes that doesn't really improve maintainability.

I feel like we have review bandwidth now, and this change looks like a
meaningful code maintainability improvement to me.


Thanks,
SJ

[...]

