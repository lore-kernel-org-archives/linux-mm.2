Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475BDCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393346B0092; Sat, 10 Oct 2026 05:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369E06B0095; Sat, 10 Oct 2026 05:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C5A6B0096; Sat, 10 Oct 2026 05:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED6C96B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:42:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CF7E16042A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:42:41 +0000 (UTC)
X-FDA: 85306226922.06.262278B
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FF2DC0006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:42:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JH8jotTN;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791625359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B7TgaAJNDdxFCAT6n7BBRtHLR7fn0ke7ZNiMxn4Uls=;
	b=8ldG7u39gXKpP2EvWMj1XL4zK/9WElIm/bxzY9f2B5SUIf4FvrYrF3i5OPykFy/jUJwva9
	M6WGwNZNPCN6RC7c05maBiw+MS5QfChLmc+AXfnXmz1RilLQT7tIW7hq7VFwxAHWG0Bv9s
	m/Epq7oIMth93diapglXHLN1DH/cD2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791625359;
	b=JFKSFYo/k0VquSnSDdbqCjgO+E+46aapCgl62qvlhReJN3xQ2EXeBIMOMiRnu9hO0pEKyk
	m0cMeE6Y9lDgxKWOh9paTCAbP6Wj+7bsNgirPwk7bs01jpHDLqWeM0a5e6i8Jut4RX8zj5
	rxDNtGm43dAoaDWZZurzx8aWUTKxYMQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JH8jotTN;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AYKq4I4pt+XRaSTHkcogaEaoukmbVRkhJcniZ//zAgg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791625354; v=1; x=1792230154;
 b=JH8jotTN8PT2QTxlydeHuspWguhlCpn278sbtRghB5i4vNMAe9BAO5Kq9FRX5oqjZh57Q0nT
 8AwiglyrzCqiKsk7JUCVj6dAM0o9QayTCan01lqCItUOxWJTt6c00vrxz3b4jmd/tGz0xJTlanD
 m5UtxLQ80OZPYWhA7IlqSYos=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57f0757703d8e229;
	Sat, 10 Oct 2026 09:42:34 +0000
X-Mizu-Trace-ID: 57f0757703d8e229
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 0/4] mm: Fix page-table teardown during memory hot-remove
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <b62aa96d-6c83-476c-bc28-7c2057702063@intel.com>
Date: Sat, 10 Oct 2026 17:42:18 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 david@kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D9A15D57-0640-45AC-B404-13982B4A20B1@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <b62aa96d-6c83-476c-bc28-7c2057702063@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 5FF2DC0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mef1k47p4wfk5i4jm3iuxqnanckcc9aa
X-HE-Tag: 1791625359-951698
X-HE-Meta: U2FsdGVkX1+nmQJwO4E2FX7/wvT3Rvmd+PdK5UOgjk4Tks1Mc5Zmo7LsuwUiEKhA7QObfSU5NINOZ6kw7tDhXdh9WIU+zwRjVYTeu8W+swHMBgzlzbR+k+ZyCrRBX3RD0M++StOloki56SZKSJNZwQbv8A73oiW5pM996LzTRql3ifcG0WcudJ6MhtUocIegLjwKV8KmgiFke0EdG2MN3YZWhbDuoimGvdA4IIszOfem1UWJHuewNpHTcZr8LwgYlv0s52p50Oiwxby6Xmpoq7LtZbCP3eZkKbSGecnWpHFKmSkjR0o1HctojsTON8OZB2/AzbXPCxSZXw1mvuVbajSI/Ujy9CZeZcCede+MLrb2owzqKiVWoTNOymtmfjCi2y4pbOV3xD5kPN9zvE6ZibVrTskvq7PP9XWhiqCStUuMmhEehECTfk0+s/bjgwQkN4bZUVg5/iuRcuJwBRIVieZpW/nJlLsa1vDfjTFAsCNZwk1Nq/UdU4gpS2Wd0s3VaNpazoeDYd6lzDDGQAqwtCy53Zpwqr0OJ3ckRefMdUOMEWCkNA9lsjw+z3hF3V3dngExpRijFaJcQQd1qYC4sOX8Fqmau3iX8iXZG3HE/6Nh4rLs8JSsR/e29y5++Y7bT0K8jTzBF2DTWnaVOXUWfRw8MS1nhzuz+RBDE4b6/aTym1lfFUhISCA7LKhriHKI2cfT9mgulQ4SDXVHyiUb52WMLVC7AzShYpswwN0qERzsznUDV+ENF/XXvTffhxHeiixoP10E4PLJI0LauLzEnTR1cQTnAIzN0UGksBFx3BrNoQQ4VMfKwkGfE7f+FIZFRkQ0CS/ExGE3tn1zQf/0/r9mqaUdDW6MbURQJD7OXdee5oQEbyY0EoLbRHt6Db2jzwk7ht3MYPtq7ooXSL2rok1aRqxRI+nyxTuGvKuq1JFeIwaXZ7BcHX9thrGz4/p3we8vm4JWA/9+gAcQBP9
 jK/sUVfL
 PLYZM1pvjeuzcFQDw0VAq9Zfn+OIU0gNIMKWa+O+fl7wAAs0rWM5oUGovmuKKvyvPcLKT1CnJpeYpw6HP9yqkajZgrv+4gjyelXB8mFdRhU4zfwx3LNa0AaxTJvU2EzZYfNqRamzfnojS1LtZH7pnLW/Juca1t6HcmFF1RwAtiwQ1KmtSuisVie+vPlmIRS6Lypx2O5Zp5xoSrWm5md7sNZfjuSAOHjhlfqQcqOrSY3C+YN9DLFJnK06qa+uIi7dhEEYj37/ldEeGjOxuHPfhWkzgSdLVk4/bYEGR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:48, Dave Hansen <dave.hansen@intel.com> wrote:
> 
> On 10/8/26 00:30, Muchun Song wrote:
>> This series is limited to bug fixes for the existing teardown paths.
> 
> Why is this a series? Why not send the architectures independently? Is
> there some dependency where they all need to be applied at once? What do
> you want done with this series? Are you expecting it to be merged via
> the mm path or the individual arch maintainers?

You're right that there is no strict dependency across all three
architectures in v1.

I grouped them because they address the same page-table
constructor/destructor imbalance exposed during memory hot-remove, but
that alone does not require them to be applied as one series.

For v2, I will move the common destructor handling into
pagetable_free() as suggested by David. The RISC-V and arm64 fixes will
then depend on that common MM change, so I plan to keep them in one
series and have it go through the MM tree, with review or acks from
the relevant architecture maintainers.

Thanks,
Muchun


