Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D13606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLKdElFn
Received: by kanga.kvack.org (Postfix)
	id 1AC266B05B2; Sun,  8 Nov 2026 14:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1EF6B05B6; Sun,  8 Nov 2026 14:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27436B05B2; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9623A6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6021A1204B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:26 +0000 (UTC)
X-FDA: 85412907972.30.35882EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4DA420002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLKdElFn;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEvMyrDAXRSzNt1aAK2qvgfoj7RJAzXbHjO64hkCzVk=;
	b=OxgTGX2kH5hPpxY5/RWAIPVXy5nqlUIHZJjJZNCbWdWOKHntWUI0PTt4OkjSS3gdCIdFv8
	MPh0YjN8BIqf4596djvSWKkti2fX+s1+e8JoT+0p+Y1btAB4xAMTtlQ566SXLMWwh4RiKT
	Z00Xx47F3KWDRnuJYSoswJnI1c1XFkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165384;
	b=kBiG8IdjVDJWNcABP5tmucvvvGCHJ1FvhPEeP94NzRRM/z/ZIZ/7XxEEZ5Cdpv7l88QwMS
	n0be61tF4I/ftxEdziVX11E475RGrTUFfCFaXvbYfsnuzs94gKvuqn3KCp9IlhHCd6Uq2U
	q7rc8UGe33Jvam3bS/knogUrMXkn1UA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLKdElFn;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A0076185A;
	Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E71F008A4;
	Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165384;
	bh=HEvMyrDAXRSzNt1aAK2qvgfoj7RJAzXbHjO64hkCzVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLKdElFnNCfmUnBn9aOOenl1weRXD/H6YbcpW9wA9WR+soFa28mHyOVI9iqQpBogp
	 xayixgY7vJsymheXwiYrddX1JfqByf33rAfo/K2VN9+gSpioDzJ/LQbq586rvg/zIP
	 8JtZ9o7HUjSKLW9/uQNEMWY8EZIwkypdIowsxiqNfq10XizgeISNYUbn0oAQDs12tE
	 Ff7bM/EnJOHTKVjdHzTg77Hm0IyF6tYoxGMkZVIFCtfHFTLPfcOSl481JN2vIAgaBQ
	 oYA2lb/PYqYcdGbUUfMDBryzhykLOfEEwsZbbSwtah9AHvfA93JEtBbXyfoAhnZWgq
	 xZAMGIckEoepg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] mm/damon/sysfs: support LRU-activeness based DAMON filter setup
Date: Sun,  8 Nov 2026 11:16:13 -0800
Message-ID: <20261108191615.113362-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108191615.113362-1-sj@kernel.org>
References: <20261108191615.113362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ett6ouxqu9ty4ao9tdauk6ttrgodcf8f
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4DA420002
X-Rspam-User: 
X-HE-Tag: 1794165384-613520
X-HE-Meta: U2FsdGVkX1/HEMuD+JtLQzR3719FowOF0Nq8ZsP6JeQxYxlOXwRBSFqWGRHyNagPwgqwpiznTb2fJQY9mEmWeaOONB/T8e6mZs6eIbJTY2/aQaypTKg/ifaer9Ogt+Z+ctx5Ues3BYK+Bbo8ZCsBkop+7NcnA637qYqHQmUzq3QbgDQuL7yqD3swLNSDk7jrAuogcuc8Sxd0CfCBf1JRy9b+QjXsc/TTz2IXCapyM6Xbmo6YpQ15SLCWewRrPE3ii0ylCLzCw250Rp7G6lpE9tsXTIW30VMVbcu13xBYI33qeNKwSTYcHpBu1eDGmsBF1u3jiY1qfgDRAvbIVhHqrfgFB0oedcmEDLXKqEgIWNmBlOylPTyyIPfVNE5MQxgjRHWRZGq1W0XOg+/j/x6N08MEWREZqfAozYfDLJ1OyetmCsRGAxUrWwn2WbxNail4iIM4qQeOvljoBIsEqarLKvLvujXj7M2jdwvA1qv0TaEC5mc14wWHB84H89j+rv1UMmFlJniCaAj5NYnjN6E9af893DpNsan5devJz8Y9gjr+i1jha9DWMyw5Jll07WQPFCOs5LNP5bXh5jyC8TK1ggCv78in6+GoXAgTPTx/TTE3AD/YrsPdFKOnVeMaLKEUtq3k1FhPaZbreVR0qVSrWYqb1lbnwB1Pj6PaU360N0b2hJzV57o5UQeVeqJ5SR3UVPmS0p0VDGktMDUbT6I8hDJWwLyqKpwNq4CT3OCExp7jUh+0ClnlX2UJTcEZ/vOwUo7KNr8aiX11B+AurJaL3PjMtcu7qxEFEHFkKHeE+LlSiDdpwOHbSnt6c+gQFhIMUf6t500U1zVmxirPnOdYXTtjIAx5VJJaJ8QQ7fPLOsy9Iud7Qm/px9hDHUpEmKkxURhIUpdh4oRtH9MYCc5z9XDRDmcd8/YqfINRNbzmTmcQUW+G4eoxYlohQpn3OmBJ+OtAghYZ3PN1J4Vdnzc
 MoDW2Da7
 7M0bMp8zdQtq3++q8893279PVq+HkTN+EPZadoh0EuDKk3GP6As294FiNoiwzSGIdMRDJKVTEsGhrKMcYdub+xH7bH+tBYZpeoAhO8Mn1dYN+A2FTn+dD8CcGw+6w4GWngtrDMLdYXGN4Yx4coJGbSapEujgWK5ww7MkTePxxiNvmVzYm0n99lFEczbLjr/CPajTnN2CRmoIL+OVQitIWZe1BcWOyVDj27G+7To3Hh6RTs1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support DAMON sysfs interface based setup of DAMON_FILTER_TYPE_ACTIVE
type DAMON filters.  For that, wire the type with a new user keyword,
"active".  Users can set up the new type of filter using the existing
DAMON filter setup interface with the new keyword.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 70a4b64fb8ea9..779c98205a94b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1011,6 +1011,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 		.name = "hugepage_size",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_ACTIVE,
+		.name = "active",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

