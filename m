Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5088606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjCQaFgT
Received: by kanga.kvack.org (Postfix)
	id 9E71E6B05B8; Mon, 23 Nov 2026 13:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999476B05B9; Mon, 23 Nov 2026 13:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADF06B05BA; Mon, 23 Nov 2026 13:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 590BC6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:20:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B34FBA09F5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:20:56 +0000 (UTC)
X-FDA: 85467200112.29.2E4063E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0831E16000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:20:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjCQaFgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795458055;
	b=b1lT9y7UxWH+1JY/wX2NRE0ai+c//aODeKpQp1eYntEKUJPbElfLy+N1W4thcC+E7G+5nX
	WApCEJc31XGQCqNNTLuJKo0YurMJa6uX/CYYcfs/u8SS6hUaMKIpzI2TR420cJf1Z3Zlj3
	gwhb9MsR2rRc13+gexJnkkN0p9AR8Gc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795458055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYRtQaK9bBhPzxGCpD6OlN2FA/DLdvIovLXNdKDkqAU=;
	b=eGXC9QJB1upVj42KK1JpBpeiIU2b2h7Kh+KVB3ckq4dWfvZAbOWKuHlTP40/ZjrPTsYkHk
	+lV4mtBirUvnvcmxyjWTlIni9W42nqco4FdJzScCnSjVXBet8I+mz3gardczkcgbQDhDh5
	PQdQ9qtTxM/VhVb4aKpnsZv0KA990tg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjCQaFgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7294A45994;
	Mon, 23 Nov 2026 18:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255EC1F000C6;
	Mon, 23 Nov 2026 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795458053;
	bh=SYRtQaK9bBhPzxGCpD6OlN2FA/DLdvIovLXNdKDkqAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjCQaFgTP82giEwzzRMCNkCKr1aBuGc55jIzcXhhf6L2LHdB3bycCzFw/6VSOosCo
	 8lMHNZ0FDAhSKCjIN081TsjiVg5q6x540scSa/1KRCy0jin9IUbMmB77b4tq4oWVSS
	 SO6LYSWR/LTaiaBff/ln4BwltXdC/OMVGl4lMt2qCcLZCeOXYxaQ+Qc+HVpBYo9bCj
	 iFFzF51j3DjiWM6dRf28k108y+s41ZDYRyWiA2Ar+/mABpD1ToyWTkYQ1oYXFN9DcY
	 6JGQ+MLRoy+KuJCZjoPbwUy2NZ89HcXtbngE0NwHSSIlOOcdLFdshMFrfKyD6gMgrn
	 x21LP9Q21GvUA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/slub: Genericize x86-specific cmpxchg16b comment
Date: Mon, 23 Nov 2026 18:20:48 +0000
Message-ID: <179545803368.3865273.2843095802985514919.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111011108.29311-1-yangtiezhu@loongson.cn>
References: <20261111011108.29311-1-yangtiezhu@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: ra8zcge1fiqdihkyimk49c6a4rq1b94a
X-Rspamd-Queue-Id: 0831E16000A
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795458054-224564
X-HE-Meta: U2FsdGVkX19+9o8gkCBYHRy+OS7gPL34jE9LUs8CKTqYlnY9j1F+UIGRGwTO5OaSDMPJBdxqoLzYLB9z2IAVi+/e72FJzwIYk2QpqRiK7Bts/n3dvQ4cytEcY64GavbVAwa1f0SPnHd/Gox+i1MPYaY0a+HmgVqnPgW5MZEJgp24To2G1flDL0pD6OZ0OnoleXS17xZEzwvR+ElD0Lhvun70XhrScZP4f5OwYvliaEA9h8h2b6KtektrT0s9PI5nCq+G4foaIMK4PA99mSx7cenTSmndnh45KnoGmV9KOkRbE/0lUn1X49CxeCTrqYt8KKqA0JjE4lNxXLzlI2kDEqO98hUqlFJd2O33dArDePGsLRloMx/qTB5/elUFgatxhav7AywShnBr7a7Z9PyxWqmGQrav4R4Ki15rPiqNXj2eOuh+SGnIXj6wjGc/keJ9+xFmbT92UHi3qUAiIGKlDpTlWV9UGdF1beWDwSWwTMsN1PzJkBTutLQC6S0vjyzKMk4IKpFX1btbCB0mBXxOEnuMZGBekbxmfuR0A6E5dqTAbMNyDn42OKwahS5rKmL145xFhW1Ovo9r93/quF14PvUwVBKHx39Er1dpZJowRX2j8IHaN0+fliQizyF36IbXTdO/fggn5/f9jqcdtU07WXmY6Iip1q+JaNZyfPnqI1eAEh1qH3GkBwXLnJPxtr/OBLcrYH5W957x/OTBO2tIpetwW5qM1dkC4odDreKKKXc1R3N0/1B4d+Eq1fO4mNBP8ukosCoqKLGyw056LOuFuLp7/li98Gak6ET8pzTMGDQ+Lr7ai6frd1RZ/TyoiYFSYJt93FNw7K9kA8ElNAhB+Isl6nuhTNJh4VNIoNnVqokYjVMrz+yxw842OKR3Rzq3mkgwtttDqeV9EeFVdiQGivBC5n9/zo+GG7JZkj6tMI03pYj6CJWk7kDHORFoN3K7lFhDuc/TSp2lRK7kVeh
 wr8n5uCB
 5wpm10R+r3VbsKoLQuioBq6UBRg/bEYK5biI/HfAs86tJgZCRJWXS203OmrSAWAev4Yrf+bgwXOKbKDe/KTunJz2xf8lvC5lBQ936zuJjrb4hrgI7x/FWHdNqh6OgcEXxDuvpoe0G3wW5G835NeyPPxEHy/Qw1TVKH3yncM2lRvAyOYfEGyE4JTxAbEj/HT03nKDV6byAY8XlzIboAOSAfb/8mGi3kT/3AwX8LupjeDhGWI/Ih3E8F9EnHWjbWoIfpKpDMYyxzbcjncBUUbTQknoISAxhJr8vSCvhShnd7OOkuPAWWxS7fVeAgznw1mQMisstSo6/0RtqLEYi20bu2899ggUNMmUbocTEsk73QoLwHkEA8mkqapLwI64XL0rwrGEyAH2CDVmHPbeO66RZDbj9xtU2wkIbcix7UNHd84VyFYaRA5aO65YHPieBMSfWjGmz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 09:11:08 +0800, Tiezhu Yang wrote:
> In __kmalloc_nolock_noprof(), update the comment from x86-specific
> "cmpxchg16b" to generic "double-width atomic cmpxchg".

Applied to mm/slab.git for-next, thanks!

[1/1] mm/slub: Genericize x86-specific cmpxchg16b comment
      commit: edfe1515dd356af6f6d7b124cbf90ae79cb6b9f7

-- 
Cheers,
Harry / Hyeonggon


