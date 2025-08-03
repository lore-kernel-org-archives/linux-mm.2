Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4679AC87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 17:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC89A6B008A; Sun,  3 Aug 2025 13:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79CA6B008C; Sun,  3 Aug 2025 13:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FB86B0092; Sun,  3 Aug 2025 13:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 967E46B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 13:44:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C5165AB22
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 17:44:58 +0000 (UTC)
X-FDA: 83736171876.18.D19512B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93729140002
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 17:44:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Djj2CoRv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754243096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKIW0KmkhulZ8wcVAHMvOOyte2iSuqOly8sWZxer5wU=;
	b=OMA8Ad+IqI4Fwj86UdWqW3tVFaA70RFarNoatSNvDiJsH1gcPx8lIM7y0zzVLOMFytgAw0
	n771TLtMFIiufaQQLwySIMy8vX/Z+NUbV/O3NgN2kJt8E63NVYcx9tcop6Hz/pmoa73lsS
	++zuACeNQ95oTtPSYn8Jm+BdhGFCb9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754243096; a=rsa-sha256;
	cv=none;
	b=lra+QfSdAgpoSDt/Tmoo4GFFw/fXM/CIUTS+8nkKIOrmRvK/iw7e38U1YuulB99JgYCYXw
	m2OVc4GwWk0jzuVGbWgEA4XypRV0S+qwjVKwDTcuuWKDJnWmM2ORgIv1c2gn2TayCxHWvn
	VxhvSG1yCQNUoNTmaS5kLhcdKlhghSE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Djj2CoRv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A036C5C563D;
	Sun,  3 Aug 2025 17:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A49FC4CEEB;
	Sun,  3 Aug 2025 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754243095;
	bh=NKIW0KmkhulZ8wcVAHMvOOyte2iSuqOly8sWZxer5wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Djj2CoRvwrEUGErYkMnDFIUiRK6FGok3ZQUD39W5XWbRMDHYfupn1SGswwPR0Vygl
	 Nf3zbojho4H07ytJ5rEUR3yo98Cb+tnyz1kQ+mltMuSYVge0euZVFYeX26HYmCPz8M
	 kt0w+SHT5D6iH6ZvjcNa5AUC8wh1he+8cgH0bB3JpbPud3fwew8QnxoGRzPEfQaOxg
	 /XF7T+wt5RhGsKZONMgqX1X4KWnom+wsVBYuQmF+QvqMZ4IQBu+uQ35LWnXvfVHoYK
	 qLe2PmjAEO2WL9Xo6KH2obaxrah0S/axcLqOSS44rCh6ijx+mrxd6OcaXgTv8DmNL1
	 wlO2BqlizLM9w==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Sun,  3 Aug 2025 10:44:52 -0700
Message-Id: <20250803174452.55944-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMGUO88-CkHa8E79TTkoEm_j5FX3ZBVjChXJ5w0eL3mNSA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93729140002
X-Stat-Signature: rk3417up3i7137be699dy165r87n9c9c
X-Rspam-User: 
X-HE-Tag: 1754243096-469752
X-HE-Meta: U2FsdGVkX1+NimB23Xzbvj5GeND//o37HfRTkIjXaAwEQDM3+PcKqLAM34uFdUWbLQE4ZYuxnI5tosnWotMWZaC2FXZDHeGigqEjKBwDGq+Lumo16Ya84GdhJsJOgTIsgmswANvBhfGeX6B1OrW31xwtKmj3uU9OwE2cjKInmhHnNkYW2kQ1t6lBe8OQqDsgEDmO4XMkA/aZ1LVIPswgIAXx3h6i4vQXzWfPfJkBtONuOSS9/7sSETBQSNEPEjThNX52EJvYfQNK/3VPDv6OpJDXnU7CqUAc40salLxJnSt3Mts1jTItgP3yzzsz0q/x/w2eGs7kq4MSOdg0mdTYRWXODufA8V7M4aHdOEfIFRYWoBuHoH4j6g4t3hDGimPdVx3m0JiK6T+JvA4EkVPvtNfce2132D/lA8VEZ9xCayfHJQjImFiU9LfSMsFN6ffsEbzEgC1T0XGcVDz1/sRDwfKAAITTBfPDtAvHcQ22/Pr5E9pWgXxDG/+6de1mFK6GPRQ5BO59Pj+AGSh+Iswd608jce6+UYaB7jafCUdzjqjIBrgFHiXRYJ6BMkEk95Zi+1EJsVW1eP3VVpkPLSlI65bh3ZffybI/20W9I9dQW0P4cO7gdzYBUdqTpnYh9FAQztse2cqEDxsPGxInTyyNKWn23kf9t5pXdr1YMgAUOYPVbDuXHoV8QlDYm2K52UOc7YAvYJod7vzrJLCMtv8NoNIvlUd7OioQ4RG5W4b3jg528mnCEy75YlWD5D01N9oJl3IXcJUJLPj3oVMJZfHWHz9iqa3vfMIDiw56x+n+/IVl2yBaalrH5zHak8TJKRacWa+B1R5NZbzlI8kAh/Was3qETHxpqIRI+6PZ1/M3bBjhsSqQthjylXhl15ZFB1N6egXi9k7J+7W0kw/8Z+S77TA2729JXiOnpeikfWB/AY3X4/P/O7iRLZsvFBmjXwrqvO1++fCI5RKZd4V8XCA
 jJ6X//tS
 AFlC2YR2NkxeowJMVxOTBGxX1nvyxCFd+6gmF4+dFwPF8Ypa0GyCfDPQ4dZ1IgOQeZUXGSOcOzfrCk2tzHF/E3UAZ3sfp6tblWV/i4UBIjIFSdfWjBcBwhQ/pYusXp29EzR1twIZeiIfB7Q9CcL7rTTprRp3C7HV5M2f0vEnDDXdaf9Po+kfgt+/4hnchCY/dvvhxJ9jxLPytENf0wEIK/9+KWKOZxzOJjTLIZADBJVj4Csmr49aeRfxo6yb00RX5+WKED1bwgMpzBU+W1kzWtc2pEvRunWHaStapaQ+VcjenVW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 Aug 2025 21:44:10 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

[...]
> When the discussion of "reclaim" finishes, I'll make v2 patch as soon
> as possible.

As mentioned on the other reply, I don't think the v2 should be blocked for the
discussion, unless Honggyu or others object.


Thanks,
SJ

[...]

