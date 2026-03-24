Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00093FC72DA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 23:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1796B0088; Tue, 24 Mar 2026 19:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299406B0089; Tue, 24 Mar 2026 19:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D63A6B008A; Tue, 24 Mar 2026 19:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED1B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:56:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C390A86090
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:56:09 +0000 (UTC)
X-FDA: 84582617658.25.18F7CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 342EFC0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:56:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PBp9KCP+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774396568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0K/BeYyv/79GnAkQR3Pc+53//iQWf/atDo2TbDZAqU=;
	b=jZGK0rR+z27jchVNzlEGoEapWvJOjbQUEqPQoY8ulqyLPcVmiSrGVIzjHaazuq03hx1GKB
	R0IJJpJnlRcdjBieZpnV0hVinPG/caB7Jv0PXPZABZtfLsp4rlWh8nHbn+H9/wUay2Z5VX
	54M/nLLqV5tr++pOEIl62Y7BM2nv2q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774396568; a=rsa-sha256;
	cv=none;
	b=x4OtfhAmVIZ0Fljf3BM71EXD6ZGszXF4Qv6sM2GdKmU5dp78ajpvGbr8DTw2BO93KmRZMH
	AtXLh5i5/ltvEiIafyrPmQ9++vu8jwtW8D0R/Qra3WKyvfIb2NrttJLOsEt7V8GJpi2QYW
	k8kboOG9V7jxXajhK6X0mgINPe2zefo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PBp9KCP+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DA7C600C4;
	Tue, 24 Mar 2026 23:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C5FC19424;
	Tue, 24 Mar 2026 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774396567;
	bh=4uNybzToUKp0EAa2ve7IC4o/Ki+L3VO4Pq1iJB1BAU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PBp9KCP+HTB22gb2kXON2RUvZihG+skEDsleFplTuA9hcaKXm0c7btgBY7E+je8tg
	 NG+mNtn94cmgHl2PQb/6bKQe+GDc2rtIqwKbuAtwmQF4eWKkM2znUoOTCvCkChd8Kv
	 KFtbZGAhe4u4GFoI17yLq9TIJObhfUfcF+yGHKds=
Date: Tue, 24 Mar 2026 16:56:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Shuah Khan
 <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
Message-Id: <20260324165606.d75200ac0e5458a5ffb83d5d@linux-foundation.org>
In-Reply-To: <0e9cea41-7c49-446a-b67b-256584960516@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
	<ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
	<457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
	<0e9cea41-7c49-446a-b67b-256584960516@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 342EFC0002
X-Stat-Signature: ufp6jftcc4pk6of8g8nstbak633i8eqf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774396568-659160
X-HE-Meta: U2FsdGVkX1/STG6gpCARJkZ52rz0fhuFfPzGS2U0w4MC3tS9Fs24SdVabDHRtC1w6KJ0adtw92UPl1TZPOu0Fm++1AaOtOxT1dP3A4A/L9h+590OfvvbKa0bpCwIx/UzxOXyQ1Vrz8BGxUdwh+99JkAFQyGT9GGITnt+YBO+tFhiYXwmKmEaThzaXOKQ5cafwdAbffYwbzKjRuwWZkBU1x3Ll/jGsy410VgR7IYm0uXnRm5APMg9I6cYpjLiMko4lrba9e+HlS55LR03XzP6fsK5JKimKxG0b1qX3lAxWqmKgeoWcsVYCIUs7V+PhVQSm8dQ7F0v8EXM0xpbTLzKDyo7XaY8PG/Jm93VAqyvS6nDRQ7GYAEMTjSao3F2eulRvWCOxcaY+6O/zvM30B86YkjjVpyg/RFHYhUR07Snq7Y+Ao3WF/ia9EbXiDYaArm02Hfl3KwAQ6EoMmXQXfr74xNK/3eH8MYn7K8FlbP811qTVN3ocfqGQqwynFDJIPXO4MjabLrezzP256gh79l9oVohGODrOP/6vzQfu1OmSTobDmILbG2mS1Khrek5b1Vi0S3mYMI0DaHAvR2JvdmWdAP4UBZbOumPnuHSNmEtYvBpIfO83fpkUkiCLMcT9ezEU/tBi83/0kg/qWLIpBQjJAVLJArlRJ6n2d6FO2NBvxooh4BqhD2y5qifQ/W5VZpG6IRT95EBjp/LAHf/3w6bgm8MnzmWufRCl8pzo1g/PScl903KhD0fxNFqMylAwmaEiwcb6vUsLxWWFBP34/M4TjgQvcpL8/iQ2JB/Ddnxgtlh0HENcPqzFojbdN2/mYz5MHZ8tjCDyU4qkCRinrb+QyHGp6fe+/R8RMwLRTaNye+E1GGXFXrlOnwd+E5PLvJxxpW/WDE3Xki+PFXieAwos1j2W4vCG8zg/vwG9FSVmt2uMxMD/NhII+qbDujPjg+sVKPDA+PJLXrMWIwLcJb
 +04f2/yk
 rn4fIJD58EQQl1XltIJ83FDQXhgXfG+BYk8K0gv/UhqrVKx7N3UzQZFYRzFTsOKgWd5Lx4lAqUxbDmq+2qfUNxq1+G96UVdW6nHUBDnqsmukez3jZu7GzGwkchTmYZv2K5nPuYWbH7/B7wy77PARLRcA5RCtbP+gBuQQ8l1hVf1cASgCBLwfd4FYScoHVlocOL6CeUixM+4EvkK0/3skNVWCf0seQVf5sgVM+cJD318j1SrNDGEZBX4h7fVOFOrdm0ODUI+ODxZxDK7W0kLtYteg/sUxslRcOiN0mSL3UOPgg6/+hfl6cSnJZI5o5RRuII/VMsPcxkiGRvPPYZ54ly5jRvsnoSERIwvGPTXti8gnGCz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 19:56:01 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> >
> > Because right now it reads as if it would be returning a bool.
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> Thanks for the review. I'll rename it to
> "check_uffd_wp_feature_supported()" in the next version.

There was no next version.  I added this:

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,7 +19,7 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static void uffd_wp_feature_supported(void)
+static void check_uffd_wp_feature_supported(void)
 {
 	uint64_t features;
 
@@ -347,7 +347,7 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
-	uffd_wp_feature_supported();
+	check_uffd_wp_feature_supported();
 
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
_


