Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2137606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwYLa8jG
Received: by kanga.kvack.org (Postfix)
	id 8AC256B05C1; Fri, 13 Nov 2026 14:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E286B05C7; Fri, 13 Nov 2026 14:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D326B05C8; Fri, 13 Nov 2026 14:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1496B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:10:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A3B1A01B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:18 +0000 (UTC)
X-FDA: 85431036516.21.7248B17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9157580003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwYLa8jG;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597016;
	b=IJ4gNTHlMDKLbYY1WzGE++pdFeKvlSNluqthvTJDgxBiLKESKl7KVE3p+AuH4le4NtiwOo
	uleraeW0yBQ6DQURvtG0xfH8Yp9Ea8ElTSyhJhM7E3c2PiiOslXDpj2oZUYyYuVYCD7YrQ
	hLQnHukcE/Sihia08CryagLNVQ19P6A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwYLa8jG;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	b=HcywPMRVjTaVW8ecf0kKaO1N12My3eGpPwkeQLnzbFECN9N7z1nwTwGB2cD5gIwvlctKEg
	wpKUef+4R6RvWXgdaVbJVSUUr+YO+hOnBIKIwsU1hvuJ7Vek1PaI1Ay4+l/iZdxECILDyr
	NHJi7cdTKEuFt6pXKJr6L0at0c/i1Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1968E6329A;
	Fri, 13 Nov 2026 19:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA541F000CD;
	Fri, 13 Nov 2026 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597015;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwYLa8jGfbANwBDnffek3WSTjnOxSqseDsz0gJCmasHCMIgVTL/kaniXXnkVFiZwk
	 I+Tb++mjKgi0LH7Labd1QZpZBG5bEqMXb/hhRv7RollZgOmb6AjC6QJlKRo5m7zVgJ
	 ETjDC/haem1aRUCYjVfss232EiQEzpmvpohUV3n3k3IdBWKNqQG+2cfngBWCajQPHE
	 eR9MfVh66zuhPL5Y+C81zb7RKMvbvEwMWE/Dq1DpnI81n+g6D5na7oaBaMNs2c1aMN
	 /r5ZxB/y2n1ptwScnzw/xsTG6zLpXzM9rnF4rf2WC0X8xcV4pr9E5p4OZv0G7SImXX
	 rwIPtkNHOvrmA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [PATCH 6.6.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 14:09:59 -0500
Message-ID: <draft-0009-redipietropagealloc6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113110724.2920455-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1fmy4oipm36fqc77tari7isuacj3e4ua
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9157580003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794597016-375254
X-HE-Meta: U2FsdGVkX1//7XrGxYEhyIAKPPbC/ZMaVp8epLp+pCej/dJ5oslrk7W1smDc9iKHzr/OqlJB1sG7yrLWmSdkvB0eJRnxxcTNuciaNs41GJLMWE5vtEnkV7JA7LcMcFhBbyI0tOOoZ8gSRJIw3wvtw6zGlnm0SFRPpEsqrKDhNDwXCx3JNnTG4ieUqhbPtQ7WNDT2MfBmUW14Dg4GJShgSHNC5D2tPIeoX70644A6eqKuWylaZR2lnyTY1pN+21BEqzih1UECSwykBxxzzYE87NVD3BUF1acFA/VltMGFkUUF9BN20/gQ8G2u7H8jgbqU6Lv5Ct8qipn5FRdD/gr9egv2Go4IjGNxXMSvBbiNHyhmXdpZGzfpEBNBxpGpFODDH1fJMTFqBOpz1sjBkOh21TF9TG2/wLtpK0FDNzK1vgC7H9re0NsTuHSnr+29bJ3gadHoGhi2V1ARJEr5Ly00cbS/FrcXLZvPjklr081D4oWEWC80GgrRSROnNUA/Y5XhT8lQRygVie95j9BL+QywsyJ233lFh+d0pPz2QyksiYoHOjYBzXCm4qJpj9M9AQspsGnkOikDtmL/r4EGo9qIr0Mf9EusoQKAXA9R4sJFCg/DXx+cYDwVZsm1ppkOFtNTYASHyln5Y6ycU2Ulc69R8OimIkpgxe0cYxRIuKi/dGJti6GP9o6NfD+adDBsQq9LFvXe/U4ES89YcdfZvToHdAZcrWdsk81UDqG8Rw6cuCIVaFLJoq6eykvuPrcLDI+Q7KcuoaFHvJoTCt5LXEooQEDUzPHyoecJaH2ODuiuM8xQdvhVvBkNUNmV/y07eX/qxh/msNadkpEHu3jY6H+gD0wBM3g6rd3o/4fQrCeFyjKBzG1kIZ3vWLyLbXK1CjfPDnDPMjKLHuHw+H1fX7oNcouZc2FKbl6uwY1MN7vjuSXwrnuh7D8oI5uvZCVZyfqQCxAuLlDnNupCC+D+O8J
 cUh0mCR3
 mEkcYv/BIsyHp95z1S2nXA4xrQK/Gj6X4UIfiuzxKONCuy6+rqokXCk8UxahZV3eDpGJz3DFck/RWZLSa23ER2/Cr4kD9SvWaQWupKOd6F5oG+kv35OPXbkUBXePt7N77uz90+hlaXfoK+zjb9+ZN4zp3XyxaQmJo8RIY8a90eCqyyLkCDgR8wUklsDoK/JkFDEpMldpIUn14uBOpCM7kSGtX3dZIkirsrhCwKOGzHN4OiFPgtzx0CtrERhlv/zxJQw7CZkS0D7zjDOZ4FOg/csRDCBDX84iiwzLOY92NB/eA6KFqhT3MTvQbDl+XJA8HlwZmnggdMciB8jZ5UyaGGe6GFew74bUJsxBQmSLW+hcMwFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, Salvatore Dipietro wrote:
> Patches 1-2 are its prerequisites from the same mainline merge (Cc:
> stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
> adjusted for this tree, see its changelog.

Patches 1/3 (6ee3d87b9408 ("mm: page_alloc: do not give all non-blocking
requests reserve access")) and 2/3 (fe21f930d1e6 ("mm: page_alloc: remove
ALLOC_NON_BLOCK from ALLOC_RESERVES")) only carry Johannes' and Andrew's
Signed-off-by. Since you are the one sending them, they need your Signed-off-by
as well; only 3/3 has it.

Could you resend the series with your Signed-off-by added to patches 1/3 and
2/3?

-- 
Thanks,
Sasha

