Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE61606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NjXUB23F
Received: by kanga.kvack.org (Postfix)
	id 6968E6B05B4; Sun,  8 Nov 2026 06:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF16B05B7; Sun,  8 Nov 2026 06:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABB56B05B8; Sun,  8 Nov 2026 06:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4406B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:17:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1D15C0412
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:17:01 +0000 (UTC)
X-FDA: 85411699842.21.76C89C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FCFEC0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:17:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjXUB23F;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794136620;
	b=uteEA/eohRuR8xvmv59o3MAXwjF74EnaRa07w2ozFvHfJYG6EKGNdqNlNmjCNK7Mc+vLPa
	6WmlGUOIFh1Kv2Pikl0izx0OJiRTWLLG+FUemPq+6BdC501IvVatmeV8RRsjCGYV8Dmscj
	EhSwQSEyBIXPXOjbEqxgVjNq5ALHdME=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjXUB23F;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794136620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18sr8SyzOZMx8xWY4iklgq0foK8c2ImoU5MT3WMNKwA=;
	b=Ivxkac974J0LLFJ/57T38lTrUA1xAjGPGFAqFOzouHe4QNQoSPxjWx0qWfsRH8VGhS6Ljy
	UEIFgj1y7iDo1XCaJK5HCcWiPCW6CSmVpLR8gYTQ+Q7aVfdlGWruAWDhyGPTAYQP+hrRbW
	ydntOOxPm/v9RByWSidkEjkWMCsrBvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70A56407F1;
	Sun,  8 Nov 2026 11:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141BB1F008A6;
	Sun,  8 Nov 2026 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794136619;
	bh=18sr8SyzOZMx8xWY4iklgq0foK8c2ImoU5MT3WMNKwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NjXUB23FMioSLJAxJrR1OG2vEEyBmNcETTcQBhxP86pvaRAPQDlQDACTFYDEOBfsJ
	 11lBYuNqO0IOkffu33mynJ/20vIUM0KoS156ybm1OCXxUIyBygpaUshG9fObmvaWE/
	 wyJNv1Mps2MREvOQ1QmOLIux7m+ArsojvdXmRKJnNdYHlw4K//V+Fj5lxboeHhvgjM
	 zS9SVK7FyN5UhOatl2m4+UXL/SB+vlhzFwy8x0/0rceaAje+z3fjL0pdGYWIFRBpZC
	 jGDyUr1gkDM0g7LYgkHi0GhRNUg5vboazwgz7BnATIjKfYdop0i/A8Y8SrTd9wtAqf
	 JO8PYjAJ+8QUg==
Date: Sun, 8 Nov 2026 13:16:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr,
	pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	shuah@kernel.org, guoren@kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v3 4/4] selftests: liveupdate: Add riscv support
Message-ID: <avBaI9bFdoOnZzGp@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-5-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106071459.2003-5-cp0613@linux.alibaba.com>
X-Stat-Signature: bagjdox9iffmcn5oem64oadex1jc3ath
X-Rspamd-Queue-Id: 1FCFEC0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794136620-717000
X-HE-Meta: U2FsdGVkX1+lBi37ZTR0iu+b7Fyzi2BA6czgiXetMdk0gYI3cM36TVZcb76rtmWKaI50NoBO+P3oyQaiwBPyXmq65aFFIvw1QbUg6yyWbFpjGesjeJu7Jp9uw1TKMUaHIKqQ5WOt3ck3ZajmmDBYvzL1LuifWLhEd2LBuFdNr9MxSoSzBezcrH9tAn7W+ZPHbFCb6FidCrnLwXTPqY96UjZ3KRO8UHYBvhqB6NX8ZBjyKLFDbkjB0tcW/GO0zu5mtdamAOIZ43GXNN3/QUrsJfZcd70CSn7CiVmumiFc5SfQyROgXa18cJZCHxRWgzqg+Vc9KPlQj1+78RLYOLosn3CDy6S1FMXZmdtpnw3CNYdYcoJAjiJ2RF8lghCN8FsaHY0Lkt63/nTDF7Z89mmOa8oXn/tzpJDmUwdEqskjLSxCTYg9W8+XkxPIyzNPqdQ3P3yYfWB4c3ygWvaMINAbLtdDU08wW3CLVJvcOTXhF8JqEddb6WLkQO9Vj+dnSoimOmpbffd54a8c+5YU1rLERYrknZWO1Kc7fmFFnutkLvs3XzzfoU0VikyVh14mvQoQnIGThrbz8hORADRecjZarURfbB4mJ3evnbcopeMSCS/6aCPsp7ZsUhIgczCfdIFqaVbge1cjZ4QbXA2+y6ICbNiOOSShbSb0CME0Vpmlz1Y9QD63mlP2zYUx3H+SZEifgPQdySS411s0rW+5qgQQuDeCzWS0k4iycocCAU2WyHsvO35HpHQimGz/+6eQUJGIf7PR8TUVMSxuKQh7t7e5/tUcmETA+dZretEk+g+9yOR+AQKpznIig67mvhxL2uldVFsNkMiu8mXMJyu2dNgyLIlVktV4Ps7N/IINeqIOEMh01aCpjA0bYj38EGJabfOFxJF40T6ANDZwO0dRBpWgVPUGT0ne6ae4o1DgEW3pmX2Wu93Kb0D2R4Tx9Hx5BsrmNCEpnbWXzNVAWkYgW6Y
 sp2Lwcaw
 pa5KGqS+px6ka95B2RqECwX1Hm6fsV7L8DfnQzEmdIIf6zmQR80OES/9OXy0XeFYw9zEbZ1mrwufvnSxeYFM7X3rcxqTeyoOPG7v0rvrlUvEIAX9QoDrMh+4zucI8htC9954CHrXL05+LDkIFmwkkxDUW+Ud4ZFUKkUd6Fl8bY9/hvt+Aoqo2QgL8KBbbhgajUKF/qlcqUZT+sMYrJ7OwafIL5NkYb3QP89L4RLKvxlXFSD8/FvRyKG18xJFASIPiG28ip3FpcJ3G2QyZymF6GS0dgFYa5qJzPwA+IDF02n4ywZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:14:59PM +0800, Chen Pei wrote:
> Teach the live update vmtest runners about riscv64, so the LUO tests can
> be run on this architecture.
> 
> LIVEUPDATE depends only on KEXEC_HANDOVER, enabled for riscv64 by the
> previous commit, so nothing in the tests stood in the way.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  tools/testing/selftests/liveupdate/config.riscv64 | 3 +++
>  tools/testing/selftests/liveupdate/run-vmtests.sh | 2 +-
>  tools/testing/selftests/liveupdate/vmtest.sh      | 8 +++++++-
>  3 files changed, 11 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/liveupdate/config.riscv64

-- 
Sincerely yours,
Mike.

