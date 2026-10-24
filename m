Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611B0606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 01:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFJ/Q0Zg
Received: by kanga.kvack.org (Postfix)
	id 6AEBF6B0BC2; Fri, 23 Oct 2026 21:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686EF6B0BC4; Fri, 23 Oct 2026 21:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3F56B0BC6; Fri, 23 Oct 2026 21:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3931F6B0BC2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:25:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFDF21C2DFE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:25:49 +0000 (UTC)
X-FDA: 85355778018.18.8601DEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1156B40005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:25:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nFJ/Q0Zg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792805148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbjDH2XGRGAyB1Jgh8Mq6npQkQrEQtHcwNp3x4kkvmY=;
	b=heUHnV0SPBR5a5SUBbtCZrTB5W+MikgDm1/xhT00I15/DamEtJZp0bfpbHYC7UbFb++kg3
	TrGOhJTfA99Xj0aSNAzby4KILOfOdX429+7zqSb4tM76B88Bl0abMW+w1sP7rpNpg82OJT
	uXv3k7wD1qE4CxPp+e5O36jjOsf5GWQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nFJ/Q0Zg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792805148;
	b=mC1TAsE8MQPgew4OWrQziHyvujUxFayYdoePqaIB2kbCVXR8D8HxgkNKqS2VA+nmSgcrHF
	TWwlwVokh2bgm3WOmXmROacR84MF9LaXjp0XoA9H91lmAWfVLMmHnuG+Qx6q0orsSP6u4P
	AtPWIpAkDR08Pqlz2omH1HBOEeZLp1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41B2143247;
	Sat, 24 Oct 2026 01:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CA11F01825;
	Sat, 24 Oct 2026 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792805147;
	bh=wbjDH2XGRGAyB1Jgh8Mq6npQkQrEQtHcwNp3x4kkvmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFJ/Q0ZgIzG50WO/AI1/5yODoNQj7ueXInuMSDgVRCkvcZuqgZyA+wItoQ+lRHXid
	 3ZbWaTENm+BgSkvdsFyXdhu1QvyUsNNYcu3lpNBnR7fGH1p20yKHKo/PsDi8eGAfuf
	 rvQ9qJ2a6MFod7iy42qyBxhTnwHW3deIUxQFTYcgFBlo53xiwUv64EH5fF++rRIBUm
	 zmkf6b3FK+R5D2uJ+pfO0nqXewuq3OU0rK76J1cIBqvrXfjUBp54kL0Lk85gS4tAEf
	 64M6g5UaEFIvLzlCOBx1Xqm+YI2WF7q8gnR7VnRrIPew2Hz2g85yrxEY3NjbR4KsEA
	 AKbZva0DwYzaQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shubhang Kaushik <sh@gentwo.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH] mm/damon: align MMU notifier range when clearing PMD young bit
Date: Fri, 23 Oct 2026 18:25:39 -0700
Message-ID: <20261024012540.89397-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <179273169185.2.1655708299473876346.damon-pmd-kvm-reply-draft@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1156B40005
X-Stat-Signature: 5i6ezgwycpmfg4se4ohw1n7c5obyji8j
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792805147-958126
X-HE-Meta: U2FsdGVkX1/g67Vtnck0YHVPr4Ia465iYiONTVnxNuKsNZyl+dJmZ2kUxhWu9CbJPr9rfMlaFLefP80lcOzj1WG1KoRQ/Pfy+8pzqe7c9IOR66CCVQXsBhqKSZn5MnUqx85pel7LXZQG+7GkmUDTzemsOc4pzokZg1pbI+0qB2/PEkG/MpOqIYU84Fqly34L4nBjM+gkjzQxOIrQPH6SQ2KpfjGEkMupe/yjenV1tU5ve4xSHcTTnnpMZ87LdZxq8hsD8oVaMVSjeEfVBLPzKpMi9kjJ/bF6LjGOwK8oxhY53cczJ9RUve3yFQC4SMrWXriOg02nongBRKgR+1eeE0cgMO06owkujynxpU+rAUMNpgERgzQcNQ8x3E6siJT1bOlcX0Uag1BuMb6LaJlKncr+EeHmMsHNJuBjAPUyS+koWBHb6LZNxjNBT6dzVZ9aB7DxTPhdlxdISAXfhkne4819dvfkbal7RJfYJ7wMFR/wbEU4BVPsfdbSze+TSNFdjqaxdvafbB6jgtx09b5hsi0PbztRU67ehu6T3M98uOIboTPnygTNDbUSAkSBPt26MD8DpOnIjizMNLzdm6HLY//X3VVC7OPMuBt4cnhGF7sdaBWw0BX6wxMn/rSLrw0V93hGZah04/dfidmGuHI2cvek8iOEJxDFmuDPirWfY/h4YT3uysEHW5KQrOgQA9emnQUPPh68EcA+JXkz6WQn5s8iwn6sUwzzmKUXcRDJ1UsBefgswD7L7yLci15Ri6Q+RlMXl+/ehQ5pRgxL2pO7fZExMIlIWplR3vzTDHN25sj0BRwNru90dxcUcT0V5N0paWc113JfzJ/kJlNSMU0wsnaxaDwjVXPD6nSVrji6d2fp4PE9wvTmri1GF6dTlSJY4K8HGAvhqEYlTcxx/QcYiLPGfJZPhNi0Pb3FVm5bOeMBmvEhgNxCJRwJH8q/bGNztweVidJweNcrNBaRLDc
 kn/bulgZ
 K/aYAamxLvxjElDAFYwohPCEvV45VhRa9OXUbF150ErJHV/pgqAo8ljnWxhn3+uOavmTGaRqyiy6zcWu7t3JsWjdG7iiW6l5+0bjQGqmbAIvV5vgFnzl4/gGLBO4h5ifm0ZNo3B1sAmVYRu1weQUZXYE+Lx6yXTDDHprhq1SG6lXGc8Jy2CAbKq+hgnifb0xUxnEgKr2zr+NHSIhsH+yb1aqoSRcXt07kUTvzCKouuK3iHBS0tfAofOgZO4RJJ/UB740pZ6lw0/9gbRuZt36JKcgbpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 13:01:31 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Thu, 22 Oct 2026 17:20:17 -0700 SJ Park <sj@kernel.org> wrote:
> > I Cc-ed them.  Please Cc all
> > recipients who get_maitnainer.pl is recommending, from the next time.
> 
> Sorry for that. Maybe I will use b4 next time :)
> 
> > However, I think this patch explains its context very well, and therefore
> > this link is not needed.
> 
> Sure , That make sense.
> 
> > Were you also able to confirm the expected wrong behavior (missing part
> > of the sampled huge page and age secondary mapping), too?
> 
> Yes. A test with nested x86-64 KVM confirmed both effects. With
> 4 KiB EPT mappings, a midpoint PMD sample left the first 1 MiB young and
> aged the next THP's first 1 MiB. With 2 MiB EPT mappings, both whole THPs
> were aged. After the fix, only the sampled THP was aged in both cases.

Thank you for confirming!


Thanks,
SJ

[...]

