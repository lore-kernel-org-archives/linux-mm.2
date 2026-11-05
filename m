Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA0C606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bNA+j2GK
Received: by kanga.kvack.org (Postfix)
	id 870086B05B2; Thu,  5 Nov 2026 09:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821326B05B3; Thu,  5 Nov 2026 09:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737496B05B4; Thu,  5 Nov 2026 09:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 508A06B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:32:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13DC6408DA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:32:56 +0000 (UTC)
X-FDA: 85401307152.14.1B13716
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B95B40007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:32:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNA+j2GK;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793889174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N57O/pymgahy2d1f5FroPzkC5Sl+/LdrVI6cHMQuJ3Y=;
	b=zWY1gaS17trtlHyrorJHwguNXG7wnXZcqg1edRpdVn2CvjX5XL++jYYQCaTT+0UHxvj3Hp
	elsu/32F8rGMx1IJaMd97ATLljOvdLp3wLPpp7/yvSVsTgvg6sI64OeCp2Yfo2nrl2NcBn
	iHiSuPKtgv54rdf0YMjX+XsYmwudgFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793889174;
	b=OkDDKjQIeJXajzrQJpCi6T6Ek7l/94QL+ft2KIv8fTTduM4b6QAMlFY8F83NgvrTjkHLzY
	hCWpYETR6qLAxVF4BGk9vCyqwv258DPpKBvXM15u+PZaw8MPrvdQIOLd/HlzRG3Zpl1PMB
	6RPzRXv8sgY9FAPOaZCq3DzsMoSS6Lo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNA+j2GK;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 648C241259;
	Thu,  5 Nov 2026 14:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D201F00919;
	Thu,  5 Nov 2026 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793889173;
	bh=N57O/pymgahy2d1f5FroPzkC5Sl+/LdrVI6cHMQuJ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNA+j2GK3N6zSE3aTGGssivmU7TfGzCfE09L4qPQVZBB5vtGOIk67ctP6G4y++eWY
	 LTxsBVSfUlACqDIWaT8wRcilvnWkUEirRKrEAwYn8at/pDKeWYF4pLf7kjlnu8ZWax
	 NhLmYReu+LrLaEaO531ZfuPe3huzx264KW/pk38XqSo/0EB2Q8CcwhgXbGUzXXiLhU
	 Pl/BpbaCINW0/NMtRpSdBazyofbkpgTtDrK3ATT+WFx/rCuoNBvKRm1BDsgLnXVmW1
	 5e6T+/ysXXWOqw8VF0Z7UsTqX4q0fHZq2+mOGEGnTnJDYJQgjFSV7Z/PLcxXWasw0g
	 9+W/S1LpukMaA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v2 0/4] mm/damon: introduce age_ms damos core filter type
Date: Thu,  5 Nov 2026 06:32:45 -0800
Message-ID: <20261105143246.91656-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179388191315.401969.13923237674993632654.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6B95B40007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: khkeixphihz4r16brygnh7ky3wgujyxa
X-Rspam-User: 
X-HE-Tag: 1793889174-234731
X-HE-Meta: U2FsdGVkX18FC18n14QEaEjKaAUYN1Nf+XwHMR7dwmuUnb4U+1sueR/gkDInQqztYzatadjDsLp2VI2C2okYZnFyN/Y4NIsl39aEPB07k89QCRQeUvCHEYeLX7yqmSodvPZ5gXVNsKL/TnFyxi/NXtssCEc37Wn2Au4PtFnGO4kKWaEZDxWQzTdTKGbtOo4N6uCf9DZIZEdeu4Wcv+c8DIxRmsoFWke6tdId3Dxp1MtiJtbq4OJTD6dwZXIH/l+W/4F6eFkyBgqadOEFAAzYyWYfeN+Fpy4UmgyBHvRSR1tQUelCcCoVZVevunT3He4yLNE2YG76e7l0CoxPVgfSqNp8hp2c7aoTI2HUWKyqoVPE9eUImIpHtiSeWe+RCXmL0fCSyLydKXj5VZae7N7b0MivA5OljcQgFvUAZQDuiC78coSw2lMdI9jCqwXfMgzyDWwHE4gMkAVrKGEiAyFpC0gvBts9v1lEvdpL6jri96ARQFjbQ22OWRfqf6yLRVuKUotuCGFnHBUfKCWgC2sdUwdH0syKXSI1AfF0cSCTboFaKqcGcBUDu855ZCeUItIuotLYrMt3lq+uLSG19VnD3zDEgmbWreX8w6Lo+/yFc/7NDtF/OQVkbnSeRFDcVZh7Iuud3KQ6iGDjzUhmYpMyAeMUndykWKZ6TC4kkSKtCSFGMY15LpT+3IEVaPpe5n6PYXoILtfSUSbnsstW1dYoZepltYUx9aGpIlW++3W1eUjnsyIf82MbnF47wUpUhsv0ds1j6FjXFPdrr2RORpxYK2cl/WgmMuIxQ2fP5d37eSbNCyesXjYOqLYGERVARneK0kP5r301viGl+udDNKSy9iAeWD/kV9SAcK1vXO6OpEU/bAODTpsyWNDdbC9LRzMxqzuruQUwp+P7tMRbQKYv4SgvZBujjVAOr9YRWhiMWn1/I+yz2d9ZWCyw4GesH1kXfj8TBJ9aMt9Q601bN5i
 MBl/AuEm
 QuYMNkSj/ZeWznUCChB/4Jc85Kp2YGq8qCdvRRTt9ZoQZ86vLj7qjKHKS7Kba3mFy8V86xOepyl4uW/lFNItOsiuRvISuB1OJ8ale9tMBfA+bW2Zqn++/Pu0Cl0xaT9QqBOViUF0itgGzyGnzpo6M43SZYgwVKLGRILsoRY6S4YmtgSlQVXF0t7sqG4NawPw/0t3FoZkpbUI3ipdLkgSzJt9WxQsW6vX3lDAhwNEC1O0RINf5cEAwTSM25FygJdyntK0IjwNDCKdpXtuHYQvgui/x1YqwbKgohlQBETZyYOSFL8RVjuTJaScl0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 23:31:53 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Wed, 04 Nov 2026 20:44:20 -0800 SJ Park wrote:
> 
> > One straightforward solution is extending the DAMOS access pattern for
> > specific deterministic time based age specification.  However, DAMOS
> > core filter is a better option.  It is playing a similar role in a more
> > flexible way.
> 
> Makes sense.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thank you for reviewing, Aveline!


Thanks,
SJ

[...]

