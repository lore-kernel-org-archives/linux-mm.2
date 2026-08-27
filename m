Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578FCC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA976B008C; Thu, 27 Aug 2026 00:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B4B6B0092; Thu, 27 Aug 2026 00:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2D16B0098; Thu, 27 Aug 2026 00:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 032346B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:43:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64C391602E7
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:43:04 +0000 (UTC)
X-FDA: 85145804688.04.7BE4275
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C76D840003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:43:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvqjgOj1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787805782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5YZ+GuJeRRZH1agj7KcIAS0ia4/0OkA85eBYTvNaP4=;
	b=B2qS6UKBH++AMM+GlxaA/zM6g053S2eOmtlOnedi5yP5UEklmfZmWnowCadTTKPp0mbrxI
	WF4oPFxmTH2/QNH8abCJUp6T777Kn7lHHvPS3W2iUIZykdGU+pCAcJ3SVqyMjDOecGPG0X
	P8oOSUQRKtPE/bZKH7+kR4cJSSBhFm0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvqjgOj1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787805782;
	b=3B6auT8DxpM87Wk1MSJN3QDQml87tXN2I7xcOowlpVW3IP5RVneUVj81qZ1MKtv07v2U/7
	LiyDYGFBz9VIKeReBfVNmDL+p3xr9uGMiLiDX40TksonmI2zoU9W4wK2YdV5F9BrqzQjF8
	CZ0DI8IWrpcWAFsbG8GsEBshkD1XKLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71420600D0;
	Thu, 27 Aug 2026 04:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D657F1F000E9;
	Thu, 27 Aug 2026 04:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787805781;
	bh=s5YZ+GuJeRRZH1agj7KcIAS0ia4/0OkA85eBYTvNaP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvqjgOj1EeO3PkjRlYBNA0v5ab+DZndSPRhb5IcJAffJjXlfz6SB9s4xsE5i+GLMq
	 BVgzbIg5YiXTLph2KxJ8eqGjPZCAzV5EuiNFHHV0m9fez8UGqV9p3F2rlmV3k8eHLt
	 wxrAo1EA6qeAjFCagOD6FIATbl7j1BM9PedMPiLUDGgCdszNNTf83hiPb2GbmFp2I7
	 +HNlQXYMClTpl5XQXLUrbgNt49IUL0853m9S8uG+cDysuF8ApjDFUuIb/Q8iZG3Vem
	 f3wCaZ+FIelR8eODNQ07WVzyvEvNxKxsfeXOoAKJpJ0zSqLCadezmJoe389kiqk/XI
	 m7i+C831kMuxQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/damon: fix wrong behaviors in DAMOS PSI goal and sysfs refresh_ms
Date: Wed, 26 Aug 2026 21:42:53 -0700
Message-ID: <20260827044253.94417-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827042920.93580-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cdfx5incx3kd873wuo6bpmeo8rdww8ec
X-Rspamd-Queue-Id: C76D840003
X-HE-Tag: 1787805782-128933
X-HE-Meta: U2FsdGVkX18bb/7LYvKsu0xfj73rF65K9a4Ntkry6ZJib4CMu/YwBu64kmPg/aMRR5H37KtWqmFq3IQkQn0MF19ZKjuA3LevNjPyv1Ql6+rMO42FDyWoGwRYujOgET/vSAq7+aA9LSzazRPJZSCTR6DA8cSxLNDhlWNwi1xH+G7BgoIb3ON+fYY9nbyEoWxfPUSpZRjItRedVqt9meF+I1hSRakc06WgFe067jP2ao08la1Uqs865fI+IFBtsObnc+rajNqpwJAJ8I4IIGdA1iuI2IWBg6C3usxL/KA30GgrygCxEUSi5XSlRyCe2QIwLyDsgNGWQ85H2Ks6NhxDm6r3Jl/t0u9ycpD7tnupKuYgNP3+rAX+4ktTY2PD+oyrk1dcF+HEm5dXpWQ/hKGampYHmWR31O42JL1vOHV0Yalps4AdsiNFuCM7VHxyGZZMTBHhLWlmr7M4HxaT7uW8YMiN5Wp7hJdD1qP17YF6Sep23p4NOPKFOXbZQteGdiUZu5ZpZbZ1URjUHsQq63fpQWceLVvSmLMBYqoINKGxQGwwzOqKtxKTg+CT1S1R+PXGP1kieIg9prVMkvXnv31sHZnfE13RXb7UXRhd1Z+5vqtAqIVCs4DHKHtdN8dNab2JgVSz13XaCQ6e8e46QA3r7fPG71ojWPh1nCy9AC85/au3jpiEScupVDanFxD7Xv3fFJ3A4kCVVL9E4k0Xf8r13s74nNdbMZ6vTnQB0JA7WVGXkbQdmig8QEaLuuEvZJCEyxw2IcAVwb1Ia5dVfByqc8Ke1KBD6Y/BYe+bU6JVOYylidCIhsMhQsPotJHc6hYUYC8ro9zrQ6gda+zvPtAjJj5z1BCf3GOFBitBbYYoBdtvnz1cCLMolWZkW5xv0PVpeJjjbCttmsA9YQKAeHeZZmrQKdGJxUsWhCdnLvbx//kp+GYZ1DtPlX4Ww1rUTWzggCyE4Oh9wlIfbXJOikb
 Sw/zTKjP
 OyL+MRc6NHA0mxzNwlpvg9YfE0i2qPG1QVB8OGmEQuJL4OKsoWr5i9QJoZscA3xaJzJUCzIU/dd0rJ2jmCmh1YQLqNhpx18jBnPszughvi1lVKwmfP4Ba6vuT2OUCjMYFabPxeVBFK2VHVFyMZkq/2CChbsoJrANAc5QMlJkFsoLaOYC8zVIJgMSb4/JcRSnQMIVywnRkvYO/IMjPP0Nl4bEiom3lFJaqCKwAV2IZ9mMuu3anXHfLEOTRh+hInoIEg6h/yWLCLAxRwNTcGNx5Mlssbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My intention was to send this as an RFC series.  I forgot adding 'RFC' tag by a
mistake.  Sorry for noise.  Andrew, could you please drop this series from
mm-new for now?


Thanks,
SJ

[...]

