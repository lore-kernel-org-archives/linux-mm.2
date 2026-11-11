Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82A0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CQ3YcXyn
Received: by kanga.kvack.org (Postfix)
	id BEE6D6B05B1; Wed, 11 Nov 2026 12:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F036B05B2; Wed, 11 Nov 2026 12:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4EE6B05B3; Wed, 11 Nov 2026 12:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84D916B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:19:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1380D1C39FF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:19:52 +0000 (UTC)
X-FDA: 85423500624.17.382264A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70B5840005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:19:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ3YcXyn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794417590;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzVvTj1tb0Ep/dVhlciwGP6JmNFPxZFsMdX03oVDkMc=;
	b=uYmNcUHTFjFd3O5PDJUT7jsJQvlwSu2J/xl7dJpkvCeh3CF7yR0lFbS2EN8elD3Og5llHz
	PqKDTGRelLg8YkBDT3f6nlKWqJbNy32U72v1AWnLOvw1VGG8kQY6TAu6YFRjUQqcmcqnRn
	Z4NOF8PsmZXZKMk/3XBnMZBkxPj3KaE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ3YcXyn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794417590;
	b=t/+RpUsymZIej7Fpi/8gd16cBs51S7VbOKZPZm4yk6aWFHbz9cLK8MQ7tBsry5LIx9gmQd
	ZK8mHi9Z9rSM/P80yrH8AxcQLtJchym+mDfPAVwIhaTGC+KoD7oeDYqbBf1P/lcflUCfkB
	LrsZH3RXviFp6T62/GpfgjkYu70oI58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 956A14024B;
	Wed, 11 Nov 2026 17:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98DD1F00A06;
	Wed, 11 Nov 2026 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794417589;
	bh=SzVvTj1tb0Ep/dVhlciwGP6JmNFPxZFsMdX03oVDkMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CQ3YcXynk2NNxkFh7xuYG+u1w6DYEZQOJNfKlFFaE/sNwPgn4RKaz4gOQ20GQbOX+
	 yhiH7qyqQ3QQrpE2UQ8ugqPlDZ1mIOOckrHEjqpDqZlr43m4asZBpiwy5xONb/VcrC
	 3d9Y6PyMSNsQsH7ej70xHWaRigvetj/wYkW3BjHy2Ozc+0MhiMQFXTsOXSnsEvErpZ
	 XkTFlTMTopy3TrLGAvumKZQCx7FDJT/IIikxhIhnzV5MY3+lx7+Uch3VbofCJjs2Qd
	 tbYyZUJ8j9v3WA/x4sJMTl/5PkIimtqddygHCjinVCcPrXBYh40OkmJQV5PB6ssFVr
	 33RV1UalcUW4g==
Message-ID: <sashiko-outbox-209401@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 17:19:48 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70B5840005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: cxnb7yyt87i1cn6pgmyzpcbyugnn9t3h
X-HE-Tag: 1794417590-137639
X-HE-Meta: U2FsdGVkX1+vqO7InoFJ7E0bUnySXClZCR1lPFWT/0itj8kxcMNIxkJaYK92eUni2f5Nfd1njPofvo9Ww81D4lP23R2WI1AIG81K4AW3WM6cDkHwIcndHZTtU9RRf9suzvFkHhf6GBWePBBO1sqavVH/9YXtCi2GWcOo8RVufvQxDqSxOcYWsGXj89KMXSMbB3M8vMz8JaQKZ5FOlw0iiqzLpA91g4WJ6ym5yzyrnIRNNwOioKo0P6ocLsbZiCa6LhR08P0XHq8Wn0Kn0oUxOptIu13oT+Y+b7rI0hdA5d/hGiAxkChy7BErU5mJId76vSzAScmL9GSVyhcBU8cxDMlZTdICqIyRgk2HDgauvYKe3yRIZbt2s3ytwOvp2oCGNp23DyowzqhVI9IAbtiP+SV/RxJ7YPbgPf3ymKoSAmvgfKBhfYf7Wok5Y7acYlwQ6Do2YwPM7G8rX6Dur9KPCqYCBuptDi8+UlKtnj9olUQcen0DIIM4ToLOvi8BFDEkDwu0BI8LV1i4vwltH7ORWaEWbQZiI2Cydb3wEyyMhPDAd/yuCoFs3JwZsb+FCCffksfkxJTOf2cPNclkU0r51GcPt2nfscNYtQjswF21Y7br3IXIvkRLdd8ISpq2q5u1PsSg7S6RPZyAhu8fHdIrjEYqe9E50Z0sv9u0kMTGbBr04snJiDXhFlHQGpcWShlsi7yup9ZBmL2YAd2b2diLuLl5TTBr/bIubY8lR5YRlaejT+kTjKizB2niGvzxoPbe4kYM3O5EVJEycmH8hjH3siKA1kHoiA1vS0474xqjatgSVsgHIKnm4FrT9e7pGNnHVR8AqbP/woKZXnY723wovJwm0wevS2OXpmzkmPIzpHHG0RBIchgtoBIjr7TNIzncel/Ah5fWvmTdGwJbb++WX7RYvojh7bypp9WJ3aQALvOhqL6tfu81LQSst+3WHWF/ooVrOjieCGZ83yEimez
 QQDOmjDK
 V5Upv8+NO3vCqGQr0mpdwImey18EQSd1Qy0Fd280vIudUrwrkwTHA7oJlgUtm0wx0P9WMvhS2+bqrOiZKn/SA/wHxAFgLzTnpRITFFVV04ZdYSGXMd08Fzt6e7HEbZxWlng1ZMIoGQalySvteMQfndkXvmGlCpEtB9ruff9+m1mAcaO1LkC/SRyh6IkPpp0NoUgcOsx2vg/dfMDttUPdEIw5diPWD6bsAzZc1uSJbYOfobGB4B8GECDXTYYg4PueDFUNlnX8gTioXwDKBvxNdxO6DiDTgzXnWKbZoFaQmhIlflGxK7eQYFASFN5jpTVaYf5vhvehiNbhjhgBtqAl7XG5o0o0REVpzEo8mDdcZgdGiPlPqvBs0xoAVvEl+jMUtDZwTO+R6PDTr9OuSI6rX4iZxMtO5CgnHMjpBoocOVPyVznSRdQWOxSi6KEitlio/I/0gbqqhud2/e9SHsFmLy5AifKNDUNrWKeG+LzO73vYc/5lfL3ANjtJSvUHQnG9Wi/yRIkOmTlPEr66rQrz/SrH+0jNtR4nyb5xY5i8pchW/52A+whQ2PWKfjru4mkyY6yWObfTF0w1OJ8wlcfI6hI95oUdMK3OUK8F9msNC6KvvJ8/FmnAqu3BYSsTpAOIOsjhA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/khugepaged: stale jiffies-based check description in commit
  message
--

commit bce7aeac77f8f4e7344a0f568e13d01a781dac5f
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/khugepaged: release contended mmap read lock after scanning enough VMAs

This commit drops and reacquires the mmap read lock in
collapse_scan_mm_slot() if the lock is contended after walking a batch of
1024 VMAs.

Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-wri=
ter-v1-1-275e070f426f@kernel.org/

> Address this by checking whether the mmap lock is contended after 1-10
> ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
> long time for a lock to be held, so is a reasonable compromise for
> determining when best to do this.

[Severity: Low]
Is this paragraph left over from an earlier jiffies-based version of the
patch?  The code checks mmap_lock_is_contended() every
KHUGEPAGED_MAX_VMA_SCAN_BATCH (1024) VMAs, as described in the following
paragraph, rather than using jiffies.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-khugepaged=
-latency-fix-v3-0-6eea743cf9a3@kernel.org?part=3D3

