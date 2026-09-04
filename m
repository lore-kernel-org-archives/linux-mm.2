Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBA7C624D6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07456B0088; Thu,  3 Sep 2026 23:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF316B008A; Thu,  3 Sep 2026 23:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BB96B008C; Thu,  3 Sep 2026 23:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988D46B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:11:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 096FEC0713
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:11:18 +0000 (UTC)
X-FDA: 85174603836.19.BBEA3CA
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 119EFC0005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:11:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tIP0PUq1;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788491476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GLPFSnnFeOlonSv4cUL0ZxqzHYNNFqmWiEIZlFftr0=;
	b=TmEq9OqFJz0NBVDWG9/GsIIfSrnDui+miod/lu5VjYf1hVDo+Y8PGokPJgQD6dvoM1cpS+
	ZUwEZQ0eaSMs17NB2W9DkTYk/kmrH06VpA3AymEEsslWLx215Zm4GBEM5I/aZ6NmgiPn4b
	rnk+Yv6KhZYjhOdxtcd2zyEPCYQYgPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788491476;
	b=qweMG4JS6MOB9U+b4Ca2L5bEs5LJCDpVm2p1mXjOssnTPitEymJVUqnSpGwydQvsiBlFK8
	mOOqEq7x+W62sXirfUMg0vfl9fVN4xqMq9YBxhEWGHugXvUIxGsDf+JYiZK2GlrIiDt65R
	9fO8yL9vcwC3n1sZ/A6oGdBYCpgMPJ4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tIP0PUq1;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nx/eitTR44C33VFjQT5eDwZTcChTpu7T7AIpTkNv5MY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788491473; v=1; x=1789096273;
 b=tIP0PUq12dU0AdfeuLhKXHPIC7GZk4dQfvotWfPZjBVhXvOw9s3vCeHO6VIEy/icCoYZfTwR
 jvKIXO2+z2Bo2WERgsssEfGAAQc630iIfIsRCEpYLH1X02A0mhaRoiDxZS3UmiStPUSL3gy8sPR
 MphpGHrucCPQMo3EJPke+xHQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 946ef5c41bdd8706;
	Fri, 04 Sep 2026 03:11:12 +0000
X-Mizu-Trace-ID: 946ef5c41bdd8706
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
Date: Fri,  4 Sep 2026 11:11:08 +0800
Message-ID: <20260904031108.11986-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807103714.33074-5-dongtai.guo@linux.dev>
References: <20260807103714.33074-5-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 119EFC0005
X-Stat-Signature: z699bwghtgzuz66en8f565zxeo7yxt5k
X-HE-Tag: 1788491475-819514
X-HE-Meta: U2FsdGVkX1/l2dz5rRfq8kb4V72y1zyW+/KmG00HExm4Y9/DXfgPJZfEZE6FQzkW7eHBNkztSDoDYKkapNUT1Wen4HeJUiMQoc9qZ7NRIDjo4DDg8h9dtQBzX/uU/ctfaekvfbtRa6aiAfJIFrdTCKDkthdvsa9c+aMQSZru8okenOLrxdnkUgjE+MbzF0fXW4Wt6pcptEwteLrU1ynLWOFhBDxI+WCKo492poDdk+tGDxrM4hhaUMSRgGuEzjzyUnFSmn4oK2V8JK5hE3kwWGhpHV4h5yJVvkfOddLvWWwqAKtnv8aSokLOEQej6Ei7Ai8zrJ/9Wfe/IdEhwBvQFlZABCQv334Zidb22jIDjpMRf1KLICJSAdwTtq6a074C8KU083rXvMpmZ+fw5zVugz+1vGP+Eb0MCwsY1P7VP9T/PS9cYhSgzs0rI/F1cXwu1T+gmo2iuMUa/e4IAFyjApvyp7LLO3GkfkjDs3+IsMAoPPXQd1nsUqv/ogqy0TwgKMVxKtymjh7jtqckB4ModT0OwegZFS509KZNnJLwSLKGlANEoWVqO3XGnDNbqBoHFqDja0qbkMxiURxt7j6lPv1A0OShi1VFP+CygGU3NeUIqJwkSk1Xd2QDBIBVDc7OTEMvnfrD5GvzmPjGN033JdO8fzRUk4xFRAJhM86aCXdUkZUbu7ioY7kNic7dlzWnnLKVsJwmSn+HnB4Zswg6GVgtaIgc37rHtsrzDqM+yzqr/5u/X8kMwnWRgEOc1WX9DU3BpAQwVUyo3SmX5d93/5wVvIRbvnLnEFdyqiJLSKRFIxEmSEoKXsQljBksA2jhBiIvmieNU2IbuLYsGStlUvtCewhXlwli1oqDCTB+NLgtz4sjL97Vxez7MaudD7if8nEXdVpJtBCDcD/tJCUG/mRsrEzw7m/GHge2Ov2hK0d7QWdtQEXOaKmqfs9ZBCpFlyM7104aeKgr51YR4Jh
 RS8rOBra
 SIF2yGKRPO3b8GHzyEk1jPDQBUcAOgqa+Ssb76MRqGtj9NWkm74YSXX/r82Dy8moeSvfsyxOLMCnwef4xw2J1P7tpUGIxnn2v/x7aDzKbIRMDpyc4AiTtrfC+oCTd4ktdz+mdQg7PU0jzsRKxUUBsVo7sz+RKjvpzdXpqVBvRczBrls1l9BTYqOrpcH0q0DLP7X1AhOq+oTUqH23iXaNInodFPWSSKsjZkoTVSxfVQ1Be3cZKN5u34YHVog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

While preparing v5, I retested the LoongArch vmtest without the explicit
`kho_scratch=16M,16M,16M` setting. That setting was masking a pre-existing
bug in the generic percentage-based KHO scratch sizing.

The percentage heuristic itself is reasonable, but the old implementation
calculated each per-node baseline after allocating the lowmem and global
scratch areas. Since memblock allocations are marked MEMBLOCK_RSRV_KERN,
those scratch areas were counted as new kernel demand and scaled again.

On the 1 GiB LoongArch guest, the 98.45 MiB reservation baseline and 32 MiB
alignment made the old ordering request 224 MiB of lowmem scratch followed
by 672 MiB for node 0. The node allocation failed and disabled KHO. I sent
a separate generic fix here:

  https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev

With that fix, the total aligned request is 448 MiB and the LoongArch
vmtest passes using the default percentage-based sizing. I also ran the x86
KHO vmtest with the fix; it passes as well.

Therefore, I will remove `kho_scratch=16M,16M,16M` from loongarch.conf in
v5 so that it tests the default sizing path, matching the existing x86
selftest behavior.

Thanks,
George

