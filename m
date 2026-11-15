Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22531606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YYkZvG7T
Received: by kanga.kvack.org (Postfix)
	id 34EF86B05B5; Sun, 15 Nov 2026 14:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF146B05B6; Sun, 15 Nov 2026 14:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9D96B05B7; Sun, 15 Nov 2026 14:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30696B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:22:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B3B9A8523
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:22:06 +0000 (UTC)
X-FDA: 85438323852.30.EDD7CDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD8761A000B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:22:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYkZvG7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794770524;
	b=deTWkAQz6OiuYeXUTqTive8RW8gYcHEEYYKsfFZtU5qOtnn3E53zIRKDi17DIOh0PTFbc6
	fBtCPsqAcifhoAL4kZCJHaKpI5z0Qg1mzBevVnMKQxRGHhOuAZFYk3yZPoWliPSWrjPE7u
	AyHW0FtOwfMUbyGsfb7a2qj+AT4xil8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794770524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIMpcp5q0yTDtJcCpdNxmcyuVAuHnxRcCai9kzJu3Mg=;
	b=ic3xCDzSQZok+8fFRiChN3TAC9CN9mpJHSPpCP/h7QmGGH25+DEwl5APF3HDKKvWrmv/Rr
	DIX9moL7oqJ1uDrqWLjADCH/rJnAb7r1CgkSUzctWxz06faEoWCLeezk4oU1dFjMr4/jeS
	fjMxXwK0cXE2IWHhlFHNICqfAbWxqX0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYkZvG7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ED67601CC;
	Sun, 15 Nov 2026 19:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877A31F000C4;
	Sun, 15 Nov 2026 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794770523;
	bh=TIMpcp5q0yTDtJcCpdNxmcyuVAuHnxRcCai9kzJu3Mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YYkZvG7TDza6ISUNrA5UxvkwMkMaTYDOKtlTjJFwt5WNutN24VaxlsSYmqhTVY9li
	 mIZTkFQTGnBegqSkt7a9Ipe9CeKF14uY8FAe0wFb0LP22FzQ67JY+dckJsIF+yidHR
	 SlTuALfyn43kZRzSCEvulKt5vwiT2jphAkIg9eZwP7a32TCNO212ENSsJz4QQtyUZj
	 1uKDAouRdv8wY7F0SKuAiAd48ic38IeJ+YXUSFfSTn1IENOSTLTqYFK9EJ/6mtwox+
	 84H0dI6au4UnWReLyQSXq7WX9642Fp1ZeDtPe87f1hFUOQ5oASWAQ6wHAa68wYrhKu
	 nF6Tbtja0p8lQ==
Date: Sun, 15 Nov 2026 21:21:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Mukesh Pilaniya <mpilaniy@redhat.com>
Subject: Re: [PATCH v3 0/5] kho: fix bootmem sizing
Message-ID: <avoGVI3Ja6ZgRBL6@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
X-Rspamd-Queue-Id: BD8761A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: tgmehqiok7cfmzmfah8md8e91mnrq3qr
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794770524-332223
X-HE-Meta: U2FsdGVkX1/Ml1lWPFeVHOIWmYMQ898FRxLqYT9J2wYg/DLbiJaV5YjRuWcsuqNqODstqO8eVFBP71fMqaLkT0ZCo07xpRfXfaX8ex7qmnvrJSLit4e5q6ra87D6uWv9GLnmAMp7gczWMwoJjAzs2FWbsc0jJD0aVevRELjfgbvAYek/9lQayBW0fF5H8jtdOU3QF3nDaQSa4jYjMjy2ly5Xdw4rO0GGbBOsgaEDSt1ELJ/fqVcsQM00geMcNR8tYbNze6cw5KWFwvhSfVdnsBA69kMAKtvuaEIzod/QcuIETDQJbJVUsjElwsYXHtNSCSVsega4GlvNaptXv0LRCtLqtmSYxqXo8XA2/wmjVY/HHNsbHfNYAaOZtS1UX/xpCd0vL5mE1nQPhQn5eayJNkoc3+R9RF0TKU3epMwQPdGZ6ynzB2uPcTnhtvkq42C5VTZErlt1Cj6/2yF0x/aN49f/6yPJitrhgaUm6acZDnSc9b9+JW7zjmNBsOGK9Iq1t9sYBIHzixni7MEwxjT2zjkbNWrwIqnRSlW8lt1X4gKzHyF6+OdIo6eBxgCE1EN1S1jvVmxsRObLsiwWxZVV1I7pOSFZi8yPyidb/RToWhj9UdxbbEYEfVOio/VVrzw+fwpy21LAeVsl9JIayAxCc7f6Tec5xAXp8cnXwQZWg+abZPzZFFXMCTaFn/IksBNWHOO9glUqRl2EoIdh7BIVa4U5drgBrDm+vx6gQTvrlej8Nq1UtFYCsV4xjMRlkYLe+NXMTC5+w1jvIhejVBQbSlLFTB5HxWGv/7D/r8cL13/cbaQh+RWZLgg8Up0lgmGjBFS9WuywZ+xIgsbgogZN482Re0hQmzJbC3tuEeCscbkqQHj2HEJCcJ2hWS67O096bdKKXKY8h9HB9e2y3kPMSmcDn5XTVY6bzyap5h0vlR7iDYrDZkgUtvWNmUcjES4TgUeSVgrryXUwqYS8m3K
 5R0Qru05
 fibXi/PD9/Ea/EYuLR1Y9Db2Cno2gJkU0OxzM5GzY482ajepV3NlsOPMqiNYINN/xlkfFK/ocq1+1EhhPI41uWBaTBkj6nTW5cLktPjaRq6v3C6UKzFBlmRTTwxd9QTeW7S2uwFOOQ9dEOsn3fXqh4ZsFLav1JqB9gIGR6IBw8Xdj3FC1XEL7g/NYvQWx+k7zcw0/gipGd2V9iFS6TEh/UINoro/OJdoR+CkQPRDHHeDnukfrLRV5SnFifSIR2PB+dhGN/FfruDlxzLLDl6GG3f0sHs/i+8TXzTBHTIJ91chNuzE+T8EwTtyYg24qs93zE7V2VxM0/rAs88pdKShxIjJLdDT2vEEdpRHW0rsscyz1IyMbLNxZMy3zoegA4OKxZAM3QtUjxIAM2wlPWc3Aqw7gkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:38:52PM +0200, Mike Rapoport (Microsoft) wrote:
> There were several reports about issues with KHO bootmem sizing.
> 
> The bootmem areas are sized from overlapping views of the memory reserved
> in memblock, so on NUMA systems memory allocated on a node is accounted
> twice and with CONFIG_NUMA=n the lowmem and the global areas are accounted
> once again in the area of node 0. Besides, the lowmem and the global areas
> are reserved even when they are empty.
> 
> ---
> Mike Rapoport (Microsoft) (5):
>       kho: reject zero bootmem scale
>       kho: walk bootmem areas in address order
>       kho: skip zero-sized lowmem and global bootmem areas
>       kho: fix bootmem sizing
>       kho: docs: update description of bootmem regions
> 
>  Documentation/core-api/kho/index.rst |  31 +++--
>  kernel/liveupdate/kexec_handover.c   | 225 +++++++++++++++++++++--------------
>  2 files changed, 158 insertions(+), 98 deletions(-)
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261103-kho-bootmem-sizing-5d6aed47a243

I took this version to the liveupdate tree.

-- 
Sincerely yours,
Mike.

