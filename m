Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EDC606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHDag0c3
Received: by kanga.kvack.org (Postfix)
	id BBE9E6B05B0; Tue, 17 Nov 2026 08:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48946B05B8; Tue, 17 Nov 2026 08:12:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10346B05E6; Tue, 17 Nov 2026 08:12:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 726066B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:12:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8D14C0425
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:12:10 +0000 (UTC)
X-FDA: 85444649220.06.E37BB2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 303BA2000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:12:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHDag0c3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794921129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC3tAH0+JcdzdHPufDEDOrI0hUeRA+GvEx3SyxbcP1A=;
	b=W8mex/zSzSgOUjAbgOuBpXodpGvalRHlHzJuOFjJ/2YQJJMXHPwQjYlBbVdURqKoYwMKX+
	yPEqlLQrQk6rj+2bd5DFyWonyWgv4zTxvN7qPa1G1SfvR5p4caChXkESEHqAdMYN0G/ROj
	tH3mhQnKYwsryAMZx40WUJRm+pWCIwg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHDag0c3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794921129;
	b=jJDT6Xjy73X/5Z221lx6Tk1kpYlLoHDN9Wa5wsB2MUEFmlomll93u5Z4e0JBTuuLGANbBO
	Sfz2MzFLf9xdSPQsb+NirDkgvqRO7/Z/LRip0bVnZLIApBZ54pLUjNtCB6IAjR5/8A3kct
	Cq3JQPkH3tSjOoY8omlxhFW28evPPOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61F6A41319;
	Tue, 17 Nov 2026 13:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE5E1F000C5;
	Tue, 17 Nov 2026 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794921128;
	bh=IC3tAH0+JcdzdHPufDEDOrI0hUeRA+GvEx3SyxbcP1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHDag0c3LyAwqr1pAj3N63u2qz3WaREWQMTkTk39jVbU/jXCjo98bWqFVCDpqH7gM
	 oAO1G+Fz0bJfY3eTn5WD6cu5C4b/wFHtvWnzsxBt2tyIH38nq9Wee3HFuT6WBlnudL
	 J+QIHYApXJLva/8wxX4ifc0SrbGgxMEpRr51NmfRN4egzS3OYhEtQuktAcMMnAnT92
	 1Xvww3feM0iMHrASdt/ChuZNTI3K0T8lzZDbOPVPfavh0Rujm2nKuYNHbmnC9LCDYI
	 c2g0kiYVtKLGix5ACIWRfNclWVt1LQGZaS9rI3u2rDbVvVfp45lxd41dAlMMJep4Sh
	 kfRbFeMEm3RrA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	ruirui.yang@linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	skhan@linuxfoundation.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jiri Bohac <jbohac@suse.cz>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: Re: [PATCH] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
Date: Tue, 17 Nov 2026 15:11:57 +0200
Message-ID: <179492089700.3802272.5945322500134568664.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ee0918f4987c4914abea1d486043011c.1@linux-foundation.org>
References: <ee0918f4987c4914abea1d486043011c.1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 303BA2000D
X-Stat-Signature: 9r1nd5difkawznq37nfhck7zkxg967yo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794921129-98002
X-HE-Meta: U2FsdGVkX1/OAdeJULhqnrW2rTn4+aYvbdnxev2QQevNLDTeWEbEiBk3GDNcoYmnOp+7m4OZiJnZvStSyAWUh4dc2FaSHm4JzvG+LmPH6rbqmbNn26m2AyXorKQG82wwAJuVGmwIqNu78bsTEAwH6kDoZwhoujMaH7bXPeH1ZvMzRIobcz3j6nbBGdCLQgstlavydgtC34HrBYwQSVNMdMxXXdV6MX/9sUAxbq+YPFrfG6mWPHP0sJXB3Aq8NAdoGUnIia3wVMBblUz62mWIzqtrjcBb8C6eMXz2Q2kpuHfpT5UkENaERXrMqZ18iiPMfqUrrCKamZyLWlKjEmjoXA4ZLXMHco0ugId8L2690DSIu5ggzJZ++pnqQkvxlWFT3NauPadk13wlDR/LkOXJ8z5igRw7KQEX67X5hgnFdJaYXgEQ4dDtPhulom2uuYsZHrTxggloZ7GGWldphK8w3+3TQX493GwjnPr/AoBNKAFzMcEMffDwZ/Wb9Z4YQ9TlPaY2mNwhowAVatHTClyf/I77ml46glMAj1v29kRv9YK3RlRnk/LG5HcsImGW3hvylLG9WfVFJC2sORw1sqMnVzQi39j76M8wSfp/WhQ5iifWmWXC+ay6JkRdsa1cT/lI6kQV/9WCzd1ooOmtZhAdHqP32PyVwpyKqmvHIWMNYoVUHuM5nGG5Tn9HfT4E4BFbLEVm1YbtodyP56vPCP6Wmg/yEYsUxRCg1HB4/U1FtcefKy7OujJBwRmSscMT9vv+AuOVOcb++Rbo9hLk8H/NiAfTgASI2GsHa3ZceBMfWStBjCxab1aJCdxH0CayBVuBl1OR0AVpdxHM3N/XR02EkSF7kTiAYTwN62UMLGFnFt2k7a+7QQkJqNBuM/sUoqAU/rQz0l0xdCOyEF9R2YUqh/Z+6z1EmTc2iv2xDKUF9RGFn/Y/jWw12G4eBRsrH4M6RCJBMlEdG+qLUAJp24x
 NSF1aMfX
 MoN1KHRDAFItMYJqukAmrvhY/760RWmODVUicNLlKLHpgCYgrKQaEpq01O0MOwdFpqIVcROGFZw+Jf+GAG/ldPzb7kHh56P0XOmZ7Gp8rDOwlMYMsY+xorHALdn1RwTJotdRWmJH41UyODW9zIlgn4pr1Hdiu6wDDvIOamn+OjXFbyQU9mFsqAs1HLRypFw4ZEcbXZM+gDeGhzlbY8PbmuVG+jsITf5doPUI7M4Aze3SojGPBMOHj7qOFHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Mon, 16 Nov 2026 11:42:55 -0800, Usama Arif wrote:
> crashkernel=size,cma reserves a separate CMA pool.  On systems that
> already reserve several gigabytes with hugetlb_cma= (which is common in
> the Meta fleet), the crash kernel cannot use that existing memory as part
> of its working set.  With hugetlb_cma=6G, requesting another 2G with
> crashkernel=2G,cma brings the total CMA reservation to 8G, none of which
> can serve unmovable kernel allocations.
> 
> [...]

Applied to kexec-7.5 branch of liveupdate/linux.git tree, thanks!

[1/1] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
      commit: 97d3ca782028b62a26e5855e2af07308da41d972

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kexec-7.5

--
Sincerely yours,
Mike.

