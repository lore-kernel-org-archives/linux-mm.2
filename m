Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B36C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 00:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D816B0095; Fri, 21 Aug 2026 20:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE6B6B009B; Fri, 21 Aug 2026 20:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B876B009D; Fri, 21 Aug 2026 20:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 815916B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:09:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F60A1602B2
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:09:06 +0000 (UTC)
X-FDA: 85126970292.26.1D816D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C773A0003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:09:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReCjNDZJ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787357344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbas1Lj6lGNlLsOKrFNc7ZwWYQndJ97lPb4Ny4c75cY=;
	b=si6SPCocGVepYhsQdLVIOf1q9p3qwhA957q/ZY1WGveYrHm6Bsh/cWaww5A85GNbcZk9dN
	DYLctHUutIzNfYXYwaxudBmEmFpyfy2Wh6wHbLDOjkv14xGw4SMWm/wraRxHGTmrkT0Atv
	7rYKv3J3zoLJ1ZAlEIFLCzqa8usVrCM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReCjNDZJ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787357344;
	b=sNzIhT/DsydwLTzelxKHz2/HlFlaKyxydv6UQgYHumc+rStVrUJxjJxBUIY2fmSV6KG5RQ
	N3SDRS/7rX9/1ETIpEzShk5uXAdslhG4jt7nfDa69fL8DaxiLHU/2t5B6hA1gB+9sJFtP2
	ZR7+rZ2PBxrPhUJtN2mPCATvvRB9tvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D51061126;
	Sat, 22 Aug 2026 00:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5B61F000E9;
	Sat, 22 Aug 2026 00:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787357343;
	bh=pbas1Lj6lGNlLsOKrFNc7ZwWYQndJ97lPb4Ny4c75cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReCjNDZJIOdKwZrqPgNMfmWIu1749y4AI5QXno4BiCVkPA3ZHChsuoB5uxUULIZ2v
	 XYZcHuX+wsIrT/3pdLMPKJpDPNUu3qrqna6gLtzmH/p4B6/SvcAbbOeU+0PRDz6+/w
	 JvYQJhZlE5ginA58gy/2O/th+vPXU2tRywL0FeIZK8cOiAOrX7rN3MaFSAiP8FX4qA
	 yOC91QOAB2WAyokN1Pd7ztpykKoOHjhkAuAl9RBEo/m7MchgtWptBUf477OeksJ9bQ
	 lny20232lKLxLEOwecp7KkB5U4+Y6tlDatk2DCXfaaYxuty4UmQeX6/tIvegbPEwUe
	 hofboOCt87vPw==
From: SJ Park <sj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Date: Fri, 21 Aug 2026 17:08:54 -0700
Message-ID: <20260822000855.88079-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7ia4tsonw41j.fsf@castle.c.googlers.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kgiemupbeeq5brer516uh434j9u19pd9
X-Rspamd-Queue-Id: 7C773A0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787357344-681532
X-HE-Meta: U2FsdGVkX18vQf8uORN3atKCbEPxHSpT3FXAuj54zbKXbYzLiy+8+G745GVNefoWKDZCIQDviHQcXA6z8KN/dxN7EekQoXXkrljzdfNlKata5If+x5GPsPfTTkUOmxYpxlb8pTAH9ylpOaU0Iq5kxw5kWP1LUBh3hy8g3TOysRPgiIc6CiukCQ3ZkUfdcDEYpS+xOGY25dn3rAgH/Bj+cFeQ/oqhI6I9m0DFAt6jhHSbdVEa1jdPZMmMHGzwyY1LDica/O4NWfC52aBw15r0kgzORUhmoSoRFX4dI1G4G5xib6nSBzNVsURvL2Xji/tKBSp58hVcmpzSwWcIavb5101dR/ioyZSAvPpXS08CUKdmhxywau7ptE9LXwjVeWoOsbSrZLTRbTYL6ZpRiDIFBd8R45WrzDj2DWmBW+lH6N1edaNrYdXkpd81tTspE/dF/RPH4lNT1/eCqqMYBXWMJ/JkLhV6GU3oghk5d1g4vj7ws1+0p/6kYQX9CRb+ihNNs622sgMnxS3ydjvB7SJGllTLJ15wJgPalbWLIlTgus9WKNBmzIfKcTXEO2G8DjdAWNcd1qOrnpTjB+/KV0lZ2HMA8pyD1P66NBYk1I3dk02+lcOnZxD662NGXxKZfS9tOdgx9rLyTVztJ32Ic0Mbsg5IuXhSEHkWU3Xrxw4ZVzGyuwP+YOt9Y963wn5IalbWhZKVft0y0GqOeQ1OXzwC0zcGmgwR+uHFG7Ih70eoYfiRGe8JCTDybTxZViEDyqpEcjEo1cYb8WKfe5uNau+j2zSmuDPNK0bnEcT83CLrzr5QRZLtoOKMUMkW4HiFkeSc+QeLiz9tYwCFcwaww84r7uHvi4H8ddgZO0GYhygufX9OHt6L37qXBQoOOtiLZ28uurlhauGlOma+MInTtlu5AnAnQ0bFPXd5jS2TD/IaE8hiS1l91O+qFtun8zQ9t+lKPuQfEVC/R2PFca2LMxg
 MWc7ZQda
 eUWUkHkTslksxj/dFaAGkB9zFodLjWp39/mWrWvUgInPeCeJtSfvy1uE7Y7NdZdnUNvJZ6Rzu4hdrR0IuNBv4m+qHzeGTQGGgRdoOA41IBoTca3GOueB15Z1S+6BxaPEoSIEK7TKVdogbG4xXE3u2ENf7EFEflosmVM0s9WNgmkl4DOkzzLxf5mfZSHjPwHOi03YFzwaHkFsdY/lE4+UOnz9yn8806E+drI2aoMXbJ3V0NDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 21:35:04 +0000 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:
[...]
> > Maybe we could figure out a way of funnelling this stuff somewhere separately
> > longer term.
> 
> Yes, there will be a database available to maintainers soon.

Awesome, that will be helpful for me!


Thanks,
SJ

[...]

