Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A91606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tKqbDw0k
Received: by kanga.kvack.org (Postfix)
	id DB86D6B05C9; Thu, 29 Oct 2026 13:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F206B05CA; Thu, 29 Oct 2026 13:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E566B05CC; Thu, 29 Oct 2026 13:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A61676B05C9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:23:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 393EE804C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:23:35 +0000 (UTC)
X-FDA: 85376335590.19.75A816F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 25BAE140012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:23:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKqbDw0k;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793294613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eiZj4z0YqxczDZhTP4xk2y8uh1O35jeXRePIqjNdtA=;
	b=nMoifoU6f6lqG18Z52G80ZX3DP3He7nW+L6h3Ut1CMOWQj/jdmtut4U6WOgEl+Tsxbwgwl
	Y/XPKJDQZ+tztqe+5Tiw9+xrQAFv78APjYP0AMsLIHm8VcMUWNNsj+QRBQ7PEqpf2c+oaz
	XipwmM/jlLbGNrTLl3dLf6sd+p3YYII=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKqbDw0k;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793294613;
	b=SVll5+D7kN8uvhdURqgWMFVbeSoOaxsuRQJBWsG3cd0tCJyccD6xrJfGRP4DCOLUe9qYJu
	Pxl/wZJ0DvnnKKieVxlQaMoUOVo+6AcuQJVvi2JZtztZ1TUzCvoPn+wY17pDvN5mEicxvE
	CLvuXUeiSpU4RuxrY7mXQSiAvMpY+LI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB56B1682;
	Thu, 29 Oct 2026 10:23:28 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00DB53F59E;
	Thu, 29 Oct 2026 10:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793294611; bh=89SvGZ6WMPqFWYQKrcmNz6K4h0a9xvHSBOWe1Dr2QQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKqbDw0kJstskDmn46lt05CuTnjC3aInPTR+oCreDFmV1TDXRixNV7gQs9bvaolno
	 9vloIPpeqvvl/gryOc82+JKTrXA3ps7tBc9lEcHzJokLGtsLKIA/dqPhL2aktd6nV6
	 FD7SXq5tC9XzlvCsLzMdG06RdEwDTzqfLK4CFf50=
From: Catalin Marinas <catalin.marinas@arm.com>
To: will@kernel.org,
	Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: ryan.roberts@arm.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	lance.yang@linux.dev,
	mark.rutland@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64/mm: restrict transparent contpte mappings to valid PTEs
Date: Thu, 29 Oct 2026 17:23:23 +0000
Message-ID: <179329460319.2444743.17610856580354729996.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c4c33aaddf5741e125e4130f2220b1892b50aa61.1792756709.git.zhaogongyi@bytedance.com>
References: <c4c33aaddf5741e125e4130f2220b1892b50aa61.1792756709.git.zhaogongyi@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25BAE140012
X-Stat-Signature: sr4radhqptcob98bhdne9ksbo1w14g6f
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793294612-842154
X-HE-Meta: U2FsdGVkX1/MvQEMn6DSgiadmcriEOEKj9D+kigRauUxzjfZxMSNgX2CWb16LQSMpvkOPxBmnDKqWFpIaDu/NfgzKwJr5Dkz5wJSEoFuBUK/snmJ6v5NPXY8jJtcEHNN9ROpAfC6f/R8o2EK/Om+XPVE1MRMlHQweyQT90whxUu7R4iVD8ttZNEC/WRXe3GiamrgmSUR2nTvFE6tdlHG01gdhHtaF3cNYZORU9CKh5FdD+s19VCZ0ZMWltuMolqxn+c0Ki/lOdSpldKgDBFTGhzmbp8UCAM52W5uzu+4gx2qJXr/T+yZfSoD8RNrOlICx6Tk8v3jSbynGF5q2+NNdUtBpUjM4ZOBn48S/qWmeKBoJzAILd/qA3bPrH7KPjPXouCHrv+F/HcXu/YcjghQhTq4nDcc0oqVNpnAMP5MKWxuD4t3qScsPT+/bFe1VGICD6PnNf5yO2dv/Z4mzsdNdGqUgDFlCVwO9JmWa3LOwEGh4xEgLY5M/HMpfOHNpcEqjqHYyR27E1SnuG2RooUOCfAQG85XYNo060TybLblMW2WOM8vKxb5NmGas6DvbigvFTc+F7Tx9tpf/d72xPPklqUbVyRRvHF21b7Oxgkvr4h1bcLnYvPzrCj2UlDy0b3RloE/2GFGmlKemflaV+zjE1ipjzA7VcjMGLUdMXIWguLmOTyV6UumavZ0lbwqPg/Cj0DHtE3cgKm+hyQEfets8Xwy0Crnxnl8NeUf7A/HcDB0DOBMuWp5CUPvpIhW1rFXqQmgFpY0i1mi/tvoFOR17pSPTxS6A1JNrJ5upzN/iZOJFBBlmYyveseDrUxVUkEPGGMBgSPV2a3puq0AROp8EBG0sLgeTZJGU6sdBJWyL6+bKLDWF8TDfLSpVsAbX8Plm94jE+avBRz0TWBW/DWGvOm/2UpkWj/REwMEq+PjpnTz/tdjJJxX8Y8LEy6oD4Dl3+KDaZY7mVfjRNJQPqX
 xk+9woyG
 lsGpOMEi3fjepc+7J0AAeoNG3z3FgDGrunLpM3ydIPcctdpxKwDYAomCoF3TsXkW743SAQonCsTsAPN0zuIh0X3vX3dewxIYWr6q6hOKiMJJtL8m8jYyld/lkpseOK1hzCM5WhNzGqXdYF7E6gq+h80f9OSNLRkhSf20ezYCPzFliMUePuT7jIxEmFb+qMB7fsYT6xDTJEXZ8jDpKlad/xEGn4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 20:12:33 +0800, Zhao Gongyi wrote:
> The transparent contpte layer treats PTE_CONT as software grouping state.
> When a valid PTE has PTE_CONT set, the contpte helpers may align an
> operation to a CONT_PTE_SIZE block and operate on the whole block. The
> current single-PTE helpers use pte_valid_cont() to identify such groups;
> this is a helper contract, not an architectural restriction on using
> PTE_CONT with present-invalid descriptors. Explicit users such as hugetlb
> manage their contiguous encodings separately.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64/mm: restrict transparent contpte mappings to valid PTEs
      https://git.kernel.org/arm64/c/486d396b19e9

