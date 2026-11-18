Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C73606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DbGudHeU
Received: by kanga.kvack.org (Postfix)
	id 6FB5F6B05B7; Tue, 17 Nov 2026 19:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC1F6B05B9; Tue, 17 Nov 2026 19:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59AFA6B05BA; Tue, 17 Nov 2026 19:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF016B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:22:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C9C5C04AA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:22:57 +0000 (UTC)
X-FDA: 85446339594.18.298367C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E620180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:22:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DbGudHeU;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961376;
	b=mtp6mVKJR1Bch+dR0OE5NixpXeKhnsIyAEQLaGQLQcG4d/hIsuL/vlawPqLw8jssn6eP0A
	+0iXv6muUr6aHBznWXNWsZ3jcA3ikCwqv9YVp24aERu0GiJl6aCwIpdaZVe7JmhkEd1IMZ
	YuR8lhbMp4k7DmAa9xaHZvk7hAv/4G4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6so24GezOUeLshnz+r9/uQrQbBVW4KNO24KQxAvhjmo=;
	b=SvLHZEwBmxH+d/0mdASXR7DZosEj2Ce0B2dVWW3j+64XNXlU9+4UZFVEqBA++TdjvFhWY/
	Tz2cnh3GNXLlRJk7QHdloz8ytYRlTQkKnSIXyGR3EbxA8R3LyOik7iyFUBT8pMIMLkwzHR
	QdlsScaJLOaRR9dsYImDLivx3CTLvhU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DbGudHeU;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54D67436F2;
	Wed, 18 Nov 2026 00:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C971F000C4;
	Wed, 18 Nov 2026 00:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961375;
	bh=6so24GezOUeLshnz+r9/uQrQbBVW4KNO24KQxAvhjmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbGudHeUqCweEAeMPxiCQR2wgMSXbyEfLlDLwKsKbJwxdiEqhg4DKnN/yezAUat6O
	 mbJP3K/MFBCYPuJih/nKmMYCfmRNanyhKuKV95f9SotOSy46BKSCStWd72S+bdT37w
	 Vn+Yo+aVBHFsK1PIVV5Fhe59rrZ3fveTguqnD/RecHwvxPFDeYpwHptd65QFnRpI10
	 qYzboD9Nz835D385n4tpWqET7uH77Mlf/DaVJ6CGXet2/taglWqmGo7+AAN3G41h7x
	 T4v4RXogGhQcxBmRDHR6d/p5hmRi96bQ0eBa1fFa2Vrw0C8pgYmJTvMC627uPdfOxN
	 sAvojtphPURNw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	akpm@linux-foundation.org,
	mathieu.desnoyers@efficios.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	Dmitrii Chervov <fary.ru@gmail.com>
Subject: Re: [PATCH 6.12.y] mm: fix OOM killer inaccuracy on large many-core systems
Date: Tue, 17 Nov 2026 19:22:53 -0500
Message-ID: <2026-11-17-1-daily-reply-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117124938.72111-1-fary.ru@gmail.com>
References: <20261117124938.72111-1-fary.ru@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E620180006
X-Rspam-User:
X-Stat-Signature: gzmrsnjmpsxozkmyt4f7piuy9re31m9b
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794961375-397490
X-HE-Meta: U2FsdGVkX18BJzh5RMftdxrcDs0xr1l2P6tiLrRNUmCRR3kbNDGDeGb2MSN6e3TQ9a/kK87ojTjuMhAWh04NZ43JShlmEUsALCpiLHpC7x2VM/BHLDTDKG6NGQc91LwqUdHMQ0OlX1OEXWWzXP3uPpQH49yXKl8lV7lmfVNDU+Xezz28a+SU2nLWu5owJUhPFu7LsgEa7ozwMKN6xeqQFLN2glRvy6dAqZ39iufT3BJj0Kk91b2awxPJt+/PWI099phpQ2/1uwjE2VbljyHMm3yEMPxSCKv8TtYYaCAXh0d6wJzDFDKnAACKbJyPi+7HuT1te0JMG0g55IKQzLTsGxpYfDG+v5ICveHnY+LyK0WQQJpPUk2bIf2urjepdn3mSYMGO8R4ASbevjzyHWBylwkCm+pWV7LokEMpJwpqAFCAEZ8GkwSLjTtjPyhYQanluJpy5gR29OtmLErgLWRft+JS2nnZhjun3it2LBYpB5FH4uqAvXh4rgRTrNg1SULgnA+lQZAJtrUjOegOaJxhRJ34nP6oLvAvNtsoDG+y10sy7AyW6rKCLXc48MnvJNRsrzRRi7OI7m4nyoLV5Fb08SLX1Vq8mHPyT/HrjJtVdkt2XA/0rwSoSGfi9jtZfwNe4k//haY0KFKtm8VbmqNSULWHDEpU8GPmJow0V+m1OuJCK9v9PsYwc7gSKlD+ca0OF8JJHagPH66UVu/VJTVtKeoVMlW52DQMFG00m6snEVMfDE6zYLxBQJIYO93ZJ1ohNeOEiwsm1GPYVDUp/Xg1H9u/On2QLKcOGlVQgdr8g0R4xqVgL5ninQCSclLxzQW5imwhVzuxcMz7wg64myr2E7BcsVNeJUrNXgSjCO/G7RBVIM2U6GhAijNccvhvTCd/vpCHUSBqWuC1JTcJsiuv3IbrdEGzc2JMjKtFnlMtEJOaSNXIpMgeb4W0bqk8RJR/P34Avxi6rfVH/5Bd+Yp
 QVMBFral
 oIxvHJZU3yJGIX1hlQ7jN+TjLykO0fGkqEwdKm5/Zyuwa4f8QHepY7RnyRrc50GAI6TlQ+FuGHZT9PllY54TgauT2n2/KZmJpZUKiWLQA4dC90ZQ0eOytdePqmLDZe/mUVJSodwSMbN8B6ClMeuOT8pCtLyJSVDscIoR/4YOG+1BXgPAIVYUgZxhVUIeGn+7QXA4aZyjWmN6yw1rPxdWl6ZnB8s2EMl5gnyRa5eJ7eSwm7/R6qnTjcuDTWxKUPxXYbKNyfoaHryo0b+04RQE7hs843PmKssa1X3O0rNNE8dbtGq7r0g9fX31ZujMilI+RcKEJd2RgLLOoMLkSmX2S0AyAL6ZAgkCuJsu1f7swHH2Uv21AMUeakrIllVjlSHtuZN10KSsot+AHoyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
Message-ID: <20261118002253.NgUEjNodcPBeGhwfwXzA9_1KpkwJWY4xmNU87htFCyI@z>

> [ Upstream commit 5898aa8f9a0b42fe1f65c7364010ab15ec5c38bf ]
>
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and console dumps.

Queued for 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha

