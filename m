Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2543FCA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 22:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F766B0092; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEFA6B0095; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDDE6B0093; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADB686B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:39:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CD004036F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:23 +0000 (UTC)
X-FDA: 85264638606.11.4D4601A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBCE31C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyKwLPXm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790635162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yECMVpm6aMrRRgb4i1PJTGXAUbugl9+MAA5x6Za5tPw=;
	b=eySh4iuvG0CxhLJYvdE/sETKSz0D5HCRZn7rCcgj9VYH8iCvASAdDmrl0GS6MyiH9jJ91O
	pK71Ro4b6zOH7ttAYjwEq5HdXebSGXOWr5aKf1+jOuJF2jsry33QVc+nBp2qIE51h75xns
	0ZMXm7rgwDBrwDaAYGDTKW7heh4QREk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyKwLPXm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790635162;
	b=Yrq/egDjXv3C/qo4ZjZQPA1H7zzjO8lrG6IWCpN2NFF0XrZ3MFnueUnPWJeXFI+4Wu6/hx
	F6VpEausPG3TBSAd7awI4hQWuVohqyl5JMGHzAaSlDUYbsdJyh7Fze2jJsGEkR6HDG+v1+
	Et/TS4pnfupRWbGl4Sr4XtF1lMAMtQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F00F3400C4;
	Mon, 28 Sep 2026 22:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA841F00893;
	Mon, 28 Sep 2026 22:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790635160;
	bh=yECMVpm6aMrRRgb4i1PJTGXAUbugl9+MAA5x6Za5tPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyKwLPXmWuolFPUDIhs6kOkpRNAttXcMLscY3JDbRF6vSzSS/JdUigMzSyzPJWrIu
	 55tUYhh49d656eBVA55jkdp2uzNnEOwtKfrJ7wKHo1JlhwIcR9WSF62jixdGpzybfO
	 28LVEppFpzhZPFBmAtuxY6x9glkZcJMcHemXzTu408tQ6MyOhDMXyupYN0UbqRHdm3
	 /e0q7jTvwozJAhql1UoOo17dDoDSMH7VPb1NOD662dCdHT1zzhuQRExnZ7EgDw3ABF
	 CW1zrpnpY5a7s4m26QGBcdu1M6ATM5zdvN++mmK05kNzr9RfGmAfEgjCFNfFgKcG+p
	 0/6pA3knQiV9g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.18.y v2] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Mon, 28 Sep 2026 18:39:10 -0400
Message-ID: <2026-09-28-2-daily-reply-0006-re-hugepage-mremap-alignment-6-18-v3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928130916.231112-1-luizcap@redhat.com>
References: <20260928130916.231112-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBCE31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dccakmim7epjc9w8b4r68ek367zzcorx
X-HE-Tag: 1790635161-400467
X-HE-Meta: U2FsdGVkX19XF4bvMimE3FJvvLGd+eQGmM702lwZzAu28uVeTBc+9RUTKpytRy+mhRQO1s5vSz2hRF9HeObKoG06EzFzLyaonDX4xm9NCeh7tAdCvAziK76tD/5mabMXuMbanz/YcrNQ174DgXpanijI+yDggYt1g98lGY1Qxig7M1dMgZ/475hXct30zXivFOqrL/urZkux4tyZKwIZK6Erv8hPeuZnT4s0SdQVZdFSII2kxkz46cEmgTuPW9jvAf1hR61O6hdaUTypjtldPEtEUsCHBLoJAHcOCuG9oukv8UbjQod9g2m9wN5PwqIWnH+JbCia1svR5SRJjXnctvf0O4mwJULAYSd33dLF9e+QHzcZ9AFjrCkE2reIp6IjDc00euegfs3tP2WFZloU5+Ojnii7veOotHM6o8weJJW+HhaQB1yPwrEgjM8kAL0D3ENMnNqhHKUEjC8RpM55WrCI3DscsyT6ipG5eHabqcyMGVo1SJeRj7sMTa/gl1Emz6CPkSEWvugKAk6MzKobKJjzrIstR/4Ly1hthqKSvuVl4/fHr2ULi1KYYMdRUEo5Zt/BniJgwyrcsJhCUILvVFubro3oBzG7M8pVhheeJhQL2Fj4BW8iT30dikixXiK5E6qbMarlLR7E191Zd2KxEXPiGTwyEU3Ank1NgTnC8fU6R8nCPnkF6kTJ4qLFvy7u2mmBlofYMWv1VBFBm97xJa5UTDhwar0aQwoIN+lGAM2+ux/zUL1qwTdwD1I4LuRafG6rGR3TOQ4N6f6xjAZQCl1v2VlBr2wU4j3TV7olNnnFi5YbB4CXmo+WRtjxWxWDQc8nZ743TmJMT6HM2z++0AERrf9xkGu08RKkxh0ehlgj9Lfi9SxDFpXsaPr46hpLZdbtlq/4yUNwNLm77Khb/c4btNrE0Giv8/aRNfBq11rHXpj3fFJeDxaW4KbKAbLBAnDIgzKxKiPQJz2plEo
 Kx2720Df
 mS2d7QGVMOz7/Dm98XkHQCZdtifL0zCTe+WqQFZpDtdOR0o2oHIBy1DCyBZUuNoUDN8JKFrt4yppq0tobwmxE10zHxMo8/wt4pgSYZFTJhAPdXwXNoXaBDkS+cLzRZ/b9m7SdsEwbssqWUw07i8sC7zx3yreFT0Y6g36C+lT2hv2KOCbGv3HpL3wgbqSSQyG0KZSAWi+/VXYNeus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> commit a914785f6349da754e1226420bf4e51961956769 upstream.

a914785f6349 ("selftests/mm: hugetlb-mremap: add setup of HugeTLB pages") is
Mike's commit, but this patch has you as the author with only your
Signed-off-by. Could you send a v3 that keeps Mike as the author with his
Signed-off-by, followed by yours, or otherwise makes the provenance explicit?

The same applies to the 6.12.y posting.

-- 
Thanks,
Sasha

