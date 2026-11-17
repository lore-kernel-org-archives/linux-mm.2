Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A819F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NfT3BCBl
Received: by kanga.kvack.org (Postfix)
	id 96F666B00EF; Tue, 17 Nov 2026 16:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2A66B05B3; Tue, 17 Nov 2026 16:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2586B05B4; Tue, 17 Nov 2026 16:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E582B6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:16:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D000CA05D2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:24 +0000 (UTC)
X-FDA: 85445869488.26.5288CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07D6C180006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NfT3BCBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqAg+LPxRBAVJs264I0Nj4xAJBhpyH8UCjGixQkGIfw=;
	b=r7cV8zLbnZqUfFWUVWaJG5mzN1sVRdc9KntNFUaZObhNRFETC1cGntIeTS8lX/nqv2GB+P
	fXCxBIaxaKXxEeJydnfoPMcpPMcQD0eDD4Zq6mIdqSjxIAszvVPu3PBOxEMhD4orGy4m/3
	gLydMYbYKbwh/597PeDPeoU1nFRtj4g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NfT3BCBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950183;
	b=kzERo9uzgyochspIvk4XH6E3a2G7NcHe0WG54Mx+T8Lra9T1MRPsgvsHi7uCiSNUZ0pLkN
	7cQQ7WBzk2cCfC/cs+tA+vd8mnmeAejbD8T2yfxKdimimcRoyNhgSnt2msTlhVman4Ewfx
	qZMkKS/cM0TQxPTN9EBLDCn+KoGlzSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 887AC60DB5;
	Tue, 17 Nov 2026 21:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D400F1F000C4;
	Tue, 17 Nov 2026 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950182;
	bh=zqAg+LPxRBAVJs264I0Nj4xAJBhpyH8UCjGixQkGIfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NfT3BCBlL2QuXC4ZmkKQKUBf34y68I4+H23xRXOWODNFtczmXf4BF7M0qvY0wOCoQ
	 ZpCWSc3/fN8iOlEx53CxcU20Jjq0w0x40y5XvbLbYVYEjQw0gqe0LNeOrILacFjzf2
	 YioqfyXmpZqu2ubj3sWcrJMARkdM2gxVxb9OfI3D6G5NGcuippcxs9kDiYhBDJkloO
	 CnqYP/fT705C0nNdjq2P4oQ4AiANMUNUfv97/85fXCWrioxHP/M2hYJ59bW8NqAlkO
	 kZNkW+qns82j0ZHEVsOHt3toN0SHcduSP5ic72rMqUWaXAhHiSyyyFOPTyxnjra9Dn
	 iRTKC7xyHRAwg==
Message-ID: <0efca67f-5ab1-4ab2-8607-abf94366d384@kernel.org>
Date: Tue, 17 Nov 2026 22:16:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: check exclusivity of the page being moved
To: Mike Rapoport <rppt@kernel.org>, nakixii <nakixii@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117191853.1314834-1-nakixii@gmail.com>
 <20261117195228.2675563-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117195228.2675563-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qqezzbejck6umpkdw95q5itmmsjdqksj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07D6C180006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794950182-755028
X-HE-Meta: U2FsdGVkX18c2wNpwLAdPmqleOfo4UHLWBp3kQ8FxyFj3YvRgIGXHW9EWT+U2krjDVr+kWE5g35YHH7yNAseTG0RkGMRVMzn26GN7BoNKAAuSJTTW7aZoOFFmLX4xLU6RkUdiJzIS017HFKXfNXh84wp/M+9NtzdM3uge3wzK1wiq7Qj0Sgbh26pcZor2FV33355+PM0UV1QfjMdztSAVpBC81F58J8IkD4YP/l6zTGK+dvaqgScLsLSkaRDNeGqJMosTvmKf4OCFA8yh9pKGWeeyixCP/o+efIsWDNjXOziTuewWv9AdY6B/RepQvGlIZL5+paZYJ75H691nBhwiC1SS1vGN1AGu/tyTsq600tD3tfOq5bzmdnJ9HpUX0dY18VlLlFdj0XWZn07cwHAJ0cvObB+GTB+xMeVV06goh7GdHajTGuWpc1Ug1vCU35hfZiA/TcBakXxkJXLwhM6+Vy9tUj1LrONsW537OBmVO94dslquIAa3yCqItre/yyITRpjdth+YlHwj/ILQcxv9+Yop0SsjhV3OHdVdKdUrd4FrefMp7Cv1tKWmQ1whV456GoNdDLcSi4rMeik2wfi4tnI0CAcXPbsG2aM8ZluJMWlcB4Q9GMOI3JY4vA3vOp9SSTQgDnStg3puerCvq0a7r5sliiWNLVGzwf7YVy3c4ECcVHO0aAahLshfNY6cMjk72440sOAfOlNthYNicKTq4bnnWXl1tAQO1X17g/0miwmt98r/UkZ6AvPDFjTjpjOOq7R0WMDhsg0rlUvGKZlXPEfgjwlm0wFLChZ5Jfgie6MIvmBKLsvherN83mVQzqup5tH2ttxuZ+X9vLZK/8tp/9Fg2vxq+0YGpSLvNdv2JVbj7/1oaFbx/jZFBaLgCKW6rKYeKBOIGN/etcTe/q6kbM3ghTetu6rGSlvWylH4OK88T5Dake7wq7CKygk60V8WO1PoDWUtV7WZTbatSr
 XRrggZRw
 rmtptBN2+pLyCw4Ya6FMyMLLsbkksW0PCixiBzCB9ghP8MHqXmBP2WJl9TONMtt0JdQUS6NGmXHjv2zz0o5jZHA5eLWNliN9sFC8U1I63OtcBB6IC4Eji3Gyw14CkWFcJf3AGQ/0A+IKxTZzAcEANLr+ltfQtqRUuSRODlfyktSrow4kPJVO4LOQeguWH5LRlRfdB+cin9Q+lc4euG3CxIcdXuZdUyGrg7e3VDmtG3arG9vGUF8Hv7j8t0so7A1GMgDTh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 20:52, Mike Rapoport wrote:
> On Wed, Nov 18, 2026 at 03:18:53AM +0800, nakixii wrote:
>> move_pages_ptes() gets the folio of a present source PTE and then checks
>> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
>> is per page, so for a PTE-mapped large folio this can give the wrong
>> answer for the page that is actually being moved.
>>
>> This happens after fork().  fork() clears the flag on every page of the
>> folio.  Once the child exits, a write fault in the parent can reuse the
>> large folio, and do_wp_page() sets the flag again only on the faulting
>> page.
> 
> COW reuse of PTE-mapped large folios only appeared with commit
> 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for PTE-mapped
> THP"), so this scenario didn't exist when UFFDIO_MOVE was added.

You could construct something odd even without that by using MADV_DONTFORK on
parts of the folio to then fork().

-- 
Cheers,

David

