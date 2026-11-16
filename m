Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABD0606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbM+g/jv
Received: by kanga.kvack.org (Postfix)
	id 35E386B05B1; Mon, 16 Nov 2026 11:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3350C6B05B2; Mon, 16 Nov 2026 11:06:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AED6B05B3; Mon, 16 Nov 2026 11:06:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F38666B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D7F9A0186
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:06:52 +0000 (UTC)
X-FDA: 85441460664.19.E4ECB9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4D56A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:06:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IbM+g/jv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794845210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pu2B5V4vcyRH/xlSfCXnnvZnLeOA4huAlDPsEgmYYo=;
	b=i0cJNv+COEHAsy18i5SRtZTSaNxOPzzoIro0mQWO7qJxecpHsbVc7zGKMFWSTCbPqvgEKU
	9heWy/tAkgvDiyU0s0blM5ein8K0fcblwg4b0MEFVJllWfqv1fhqdSbpQV437d9tWxO2dd
	1n5EC1KsJw1y+QNgxhFrO+Y2ujIiZsM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IbM+g/jv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794845210;
	b=FB8qrnKCMyk3noCTY2qyA+X8G8MpnsZs4liSVCG7hsVZgkJIz71IxbGSbHpxIZRs0uMSTU
	ZYC/+d259SHqgAx3jCQMeXEJreqgHJESJxIfEEuVvbEKewI3AmpbbJRDhtvvj2zlWStlDP
	VlJ4D58i9d3oTm7yWBCvFwHRlLxD1wo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3EEA45FC8;
	Mon, 16 Nov 2026 16:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085071F000CC;
	Mon, 16 Nov 2026 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794845209;
	bh=7pu2B5V4vcyRH/xlSfCXnnvZnLeOA4huAlDPsEgmYYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbM+g/jvwxvSgv89m8Ope8PTzx0a5ve8Fe1kKzHV1wod9FPspM+8Q986YnUyvovpC
	 osQ9FyDdiaqPv5fUsahzUvIFPCfY1YMd74QlvjebhbjRZFCdAzInjnSQUK/wb0070b
	 CP+K4vvxfMLZSrdBtMcDBHAzVZDQ/wOQv46tfrNP4F4zPm2Nbe252nUIvQfZe4j0xk
	 +1FHLK2VRbdEPyPQWX+kVby0W0GGTP3cG8ugaOwPQwRJX3xvHFVtqOPww+jYSmDTp2
	 /3p1ClanfcfYZKZfSg9FHJlKf9rA6PNNzRZH/dbRHBGzzlmMMFc8OscpuS6RX3NDnQ
	 FWTeqCKOiXhDg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [PATCH 6.18.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Mon, 16 Nov 2026 11:06:39 -0500
Message-ID: <2026-11-16-1-daily-reply-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116111734.3798483-1-dipiets@amazon.it>
References: <20261116111734.3798483-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4D56A0002
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ptrhbuxbpw5b59xz1g85c5qbbtcruzxt
X-HE-Tag: 1794845210-466231
X-HE-Meta: U2FsdGVkX19FmfUGmHo6ipGzJu3LHGlB/X8n3nHha4VYAXUGbd3bF1N2Eb8xU6ykP1oalxQ2y8cu1nRN43ifSSmjX8rsaETFe+tL+/xR/sNtSipgJSR7JilIYNmeQOzOKnz/Amh4y+mB4m7mvC2vBBaj7nGD13JzIJ7NuJvRTs7HAqWL8r/d2QQhcHmLnPiv6cJH7+wcjFmP1O/YprbqNXM5ul7P5wBWOSQby6lthFlUQt8qW0vaLDYtd9LXJZaK95WgXIscMr48UYHpVdyiNOahRVcsjqcyB9lzEmZ7JvMOl6lg0/cXTn6JkAnM24EmvDTSZkjiOWyBUgi6cKFZYwfrc8U4s6iRvhSP+dmEeSzFnPmKnSvtmZIFwimbLDFp10nEmC2lYehL7cerxY/+trm8Y1qC4FGs2k++5gLkxHZ2cKMOwttwjcL7pNAv1caw8470qC96BrtqrpizN5xttJZc2PCgP1OH7mnA/8ZQ2WJy00ljDcvhIHNHR5pV2/8QQEfs4bGyddIGJOL8BEbDpTrVASuXfIzP/ZHYA2MrMOyhvavOsmwWb0xSYKDfO7C4pR0jKhkhbSGaR7QCKG1hCuKnz4ymuv3StLbq3oBwe/vY72f/Lpi/wlD3HMmVpEvrys0FjypCCmddYJhhJ6GwlW57xye4DNtOi/flTRmUL/8OfSQJuddRJIeEpuwq7npkcwyVo697thqZB8/JIht6uzkpzc4JcXoEuQA8u8PhOCSsV6GQ+TjbfB+sjPeHADKXOTg+k3LlYzJ6YXPVZnuFiRbWQr3YBwlkuMS4M5Cn7igVt3bIHSxci37/NkTFtUrZCxNqLSVIXLAn+kkwwcjdHR5vXSiHMDTgv1nv29nd7rOY4SEkw2THZoZKPwdAj6VJmaWTb06JYdwjppiMr6v6zJ/BGNj2317uzHs52YE1LhfdDC5C64UULBHZcbg/kjLgwEXE89SlTkbWE3FzdUp
 2Aqf3ev9
 7YTkzIy1umIp/WxyuJXvX88EFXG1ufdQJxNumBf7eSi23jOHL0pSHF7pAW+PbeVNJieRPG6YuvVpLTlekNZ4LXiwOWttZghbUVvK27oU09M86dsZ/YcGzoLRN6T/0LMi6lkdTC0guq1HOX2wWkjx/TlzwEY9TuqKi3kEpQ1wfbQ6pU6DWGl8+P1ctPr5M1dPH92jFaL8mESb8uWsui0U/B0NgEVJHiYQocGKf7lQu0CE6eRCKtK8jV0hhXgQ9jeoIfzpD/iON08UKPrFMToI1sHfGzxi7IxoJe07wkt5ePUnIrY4XMUU3+Xw+i5P7bxLa2TrMYzxFtp7GiE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Patch 1 is the other prerequisite, fe21f930d1e6, only moved from
> mm/page_alloc.h to mm/internal.h. Patch 2 is adjusted for this tree, see
> its changelog. Acks from Vlastimil and Johannes on these adjustments
> would be appreciated.

I'm holding the 6.18, 6.12 and 6.6 series until Vlastimil or Johannes
acks the adjusted patches, as you asked.

-- 
Thanks,
Sasha

