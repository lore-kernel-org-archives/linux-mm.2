Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14847C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1496B007B; Thu,  6 Aug 2026 20:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51D86B0088; Thu,  6 Aug 2026 20:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F796B0092; Thu,  6 Aug 2026 20:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC086B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:31:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F024FA02A4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:31:37 +0000 (UTC)
X-FDA: 85072595034.26.72775EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B1B640003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:31:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHChuiov;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786062696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NPx44srqDXQ3MSLJooPApZRQAlXn9cWqKgTgh2pWK0=;
	b=GWGpQU1mRbvra/sUclDtm99SA5ftJY3WEIh8u1uBllke1Bp2ikmcrDM6Q54OvHd6FTW1Vv
	Zq4S7tlZzLOnjJvKsb+TINsAXP1WKX8oZfiwp04r+3pXFh+DJfQHScrz/0E1m14uNQLuuz
	qrI7ZzAH4rK+/cDaogxtDF+p+WApZvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786062696;
	b=qPlNQEDwdgQES4ebjZDD/jBFdlfxaC5p1gbjC168S4DCPJCGmkvGqGnaMVSH03R2oVlfVX
	um93HC9Dsld57qeM4g19+00zJH7InIZLLiYjqlJFkuTtL9a1qXpgyjWfo3Z4j2m07k9zEA
	nr9om9ICGTsUmVLwUAiGBdfqjMUdpBk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHChuiov;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 904616004E;
	Fri,  7 Aug 2026 00:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF24D1F000E9;
	Fri,  7 Aug 2026 00:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786062695;
	bh=7NPx44srqDXQ3MSLJooPApZRQAlXn9cWqKgTgh2pWK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHChuiov2hnAugjTA2JagJdzCr8QlgHVXcqXautlK9/YdPGMKRGI5jE1e6Jlpmq3x
	 Ax0rIZrzb1+hOfrzxqydbUBRnUzjPXSEWiKKtIRLGn15WETJQswmHibqUpOB9zOzWf
	 F79YfUTSJjHrdBr5CBQQvyVGvkV59jOtH8ttp1mGF5DmbybLmhVery0b0Gc9BwQ6gO
	 19pkL7n/Vxoh+P3x2NmN0BaPh3j5gE4RN7sYYafLDC7mEMU1dVErt8+NwVc9LKo5r0
	 XPiIeqVRdVcyBunnTCITDCNVnrvv1p6peL6V8SjTlG1aoSFG3HQQ/Cj3gc6fjHf693
	 eh3QlppOzobAg==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] selftests/mm: Drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Thu,  6 Aug 2026 17:31:25 -0700
Message-ID: <20260807003126.81629-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806030850.76077-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B1B640003
X-Stat-Signature: fs73gw3zrk4ndzrhrx4cchy97guzx5kj
X-HE-Tag: 1786062696-261535
X-HE-Meta: U2FsdGVkX1/MEPUrmnIlkZ+ul01Z1xQQAZ44pb4nFCpsSjufqQLC3bbPpYU5x6Jr9b4mnHDIqDvcVCyu/D7iEo2aFJ3w/SgY4ZGJHHLRFPFdmzyOj9n26GzFfcCuS7tFhUinWmzBZtp8T3GmjEyc+XN6ZsWilTDIgH4XyMw+dN2KPfjyh4XP/VG54rbifevamTeoK9+JNfF5OTB6U7bzOoNhebkzkbVP90AEcNf0ufolxAGixcqKlbq1WwavIDUvbpZalICYIdCnuxboqaqgXENL8TQjBUCL5qZ/J60jVL+fa8BhoQCjQ3oucyL2T3nQUhOu4FUBYo2cJYHM6bdu/IhMBSlOAFxlLcblPppg2uIeW8OZOCFTSQaRg2xAXy7g3zSHdEUmcTt34VcK8IGcx9hUHaDO4yiL4+/h1bFIQQd8T2mz70fna8G+WzkRZD+VJhI0Lz9/wsoA8Y//wdc4vfYsCdsherU+IbKVi2Rco2MBiwzwM3BqZBgIUhzwVh7tsFG/viyEB34Gndf+/6ZXz1/SNgh1Tr44x3h6DwJgWAEJqhRFsYFmLauw26IM5scJr4IysegjcDuetDkEA5vZ32DpaOxpTrCUbNcQ44A5k7E6154r74UAqg+N3g7qO6nSkG+jYMrsGZv+auoKLqJIeTkDsqTZKTQecunSJoZ1+f5eSClsuhGwJ32W8rOnYNQ7W/1LPpxUd0FbHnDiyZsbS2AsKtJnIy2EwcxVkMNFPVt+Jemgk/O+NoFnfP9d0AB6tX4+/yX1h68qihNYshfcfzNOwCPqMVzbvA3cGfESwanwIvspxWGfCa0JuhMZAZj4Zv6d1t9kHlUK4PgorEohkP/igwVwLSerZ4s1NGC/5CS9VRovYIz7HMuLPqX+miNy939w7bU8SViD4Y6USLb4vtNJnRA6ternRDKZZloouEUGxoN4JgKRqFB0c1nGt0pDOjj43oqFsJZYyYRoq9g
 pdwOYTGl
 y23u4QCliMsL1EFpImXJntFJ2gA6FIwG+mKYJ8PXN4bnLV8a224dALwBQne7fWe1zBMld0KkSt0345NRWXLUpLbmImDWK4pg/Xh1XMsEourmioe6X+UK5OfIb5b4/6bCF3iSlylSiC1DmhOE+sYqmzlkt1uI/h9iT6uQRD5SltxiVBXkF/2Lwu7PEAh9JiYefvbgO/4w6m/m99Ez+DxdpGUng5nEafzDOFGSPFyuwtN9f2pM54aB7ETYgaDfao44lDDTkLZtWWB7VhjGOUeMtVVi70bk1cgGtchj/dMTLlKk/D2X5ybnhnjcbJHlfA2ohK80F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 11:08:50 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> mseal_test main() invokes test_seal_mprotect_two_vma_with_gap() twice.
> The second run repeats all assertions with no benefit. Drop the
> duplicate call.

Good eyes, thank you for fixing this!

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> v2:
> - update ksft_set_plan(88) to 87 to match the actual number of tests
>   after removing the duplicate call.

I wonder if there could be an automated way for this.  Obviously not a question
to the author but just my loud thought.


Thanks,
SJ

[...]

