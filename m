Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD05606B9DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=XnEutz/T
Received: by kanga.kvack.org (Postfix)
	id E3BAC6B05C9; Tue, 10 Nov 2026 19:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12EC6B05CA; Tue, 10 Nov 2026 19:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01D16B05CB; Tue, 10 Nov 2026 19:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A40D26B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 245E21601A8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:38 +0000 (UTC)
X-FDA: 85420942236.22.E0C0249
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id C212020006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="XnEutz/T";
	spf=pass (imf31.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLiSMF2P5bM+KzZEojnsS0Nzj7JPVB+h93rmBjLbkdI=;
	b=uz8o/dcvxIB+zxTlEx2Oxv+zXdt6qeQAvJVMXXtgG4GO4GNEKpgXWPZgaxM0CI7C+OSnzJ
	JxuuKJcw5BzPPziQCuhuYVk7jOurKP9HiUsTfXDDa5JdmofWJGQ4VBOUSReOYrzNDHmxz+
	lAGTb4j/E4tbhvVV1zFkAt1LqKMSKlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356676;
	b=aWVq/4HFW+zt6WIWqxSEjEKsdSiJiAVBkht5A1tBZl1Gatn40OKRB1sTCTCKKmHkaFT9be
	Ow99vGhyL/AP4gr/SVE/aIKRzgdDZaB3mN2bwObD3wff9szK7JBxPi88LcbS4lGmOmmSFT
	IcKmBIIBBExxvoGromxPJsJwIVx1uT0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="XnEutz/T";
	spf=pass (imf31.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4BBC540E021B;
	Wed, 11 Nov 2026 00:24:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xTdtctuwWz_x; Wed, 11 Nov 2026 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794356669; bh=VLiSMF2P5bM+KzZEojnsS0Nzj7JPVB+h93rmBjLbkdI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XnEutz/TX94FbM9IWw1v5hBYIuwAq5JzddB2zLR/bCLd7NxWsZbTduGfwlaXxFvLA
	 Nh0fdsepneObwKj8gDmP+8PDfFPI9Dy6nOrj30TqcaWxsBcrz5fZsHTLiWZyq9XELO
	 nZqQlk8EqxloJJTBW9sxZ6e8HWk9Ld392pDAGrOjl+HrG8c/RAcDjaRT2AF7hzIjVv
	 gk6hQOBMc5Ich3OF/I2xVnlrWc0S1oqPTo+MZCmb8my80ZlfNdR/6O2XdlBpOwQK9z
	 j/pN27AQSBfDsgLc+aDcQPYfDLMes44pugylsdUjloPsufKZdDsxz0pjW0KJYAuGum
	 ejfr7nRN+Zewt1nwS/AMiijJfCdTCykh/fR8+ki5J26HP2BaZJ8WO/qqh5IczdTfpV
	 CB1IdBR4d/M7Q6lQhy8JMYAx26cjgT0FihHk69ry8BSWfkH8ohGT23lXOcVgTMtwu6
	 xXpfctJ+eai0X3P3Jhi7701mg+ZAv3feWRN+v9CE86x+47HObyYohOCLE2ePpA2464
	 GvNeoTdGYVCspCOGjZnqEuu8NrNsgpZU+//tqhdiCb2HQgbnvyxNownQ9FgVLs4Nik
	 PeSJcaDoMfAAlWAc0uixdyRyAejKdbeeOBPWbwwIqQ+yGLoVb5zCLBByK61H1ruM7/
	 wvNpDwgM9yTdMMsfHlFMOA8E=
Received: from ehlo.thunderbird.net (unknown [72.170.223.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A86B440E0218;
	Wed, 11 Nov 2026 00:23:51 +0000 (UTC)
Date: Wed, 11 Nov 2026 00:23:37 +0000
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
CC: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
 dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com,
 mchehab@kernel.org, ashok.raj@oss.qualcomm.com, jic23@kernel.org,
 linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com,
 Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
 james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
 erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
 gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
User-Agent: K-9 Mail for Android
In-Reply-To: <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
References: <20260726212812.89266-1-shijujose2008@gmail.com> <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local> <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com> <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local> <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
Message-ID: <1E6CF157-ED3B-4032-877C-38A4F63F7E40@alien8.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: btjkjwua9piiw9u7b4u9ybxcf6cmgcjo
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C212020006
X-Rspam-User: 
X-HE-Tag: 1794356675-319101
X-HE-Meta: U2FsdGVkX1/5s7RU84GANT4KhkfveVnlANMgutxoXIi8bYC1MM7I3F6zg9UXkEO4dtorfTYqiaw8bxTE4UUEeEjYvvmDgSLtKQL5HQa7BkrXkygbMQc2LpBWpHCzU3OOacDcjRL73Nz4XggilS2zXoFbD6E6P6FmYvODtqZnZ5iTu+MuSMMuP4144NyzQXBsxenV0mHTmBj+XtJl6pLBVCJ63a5XptykLJVd9hMJaXXyCv2zCtXXMWJEZQavzXL5o9Q6pAmZ60Z24mwDK/OGmkYHAh6sSXoAGdwoL8+OM1Bil/ggLxrppuly9EOUTpEkBxBCeArqYa38LIugBSS4HXMeBbvKsIYF2WHUoQhKAM5bXxgFWIad7hy0VkNVT9ZEPKJBAKLLkSV3RJP9vn+gaD1yaoE3vaRWX0vi08f0Bnw0gKLAjxgnyHgDcRn3zwlizWpjESH2OboT0Qsr7ot3W29al12opHe3GLenesTjBPwJSUG1UNoEH08lnQXlBgxZXAI/EFb2SM/PVu+n3hNs90GocQSm5Q9yGRbDCSida6Gaj7zvtF/zNjXZrQVS16U1t0hdW8uY7i5B/BgFCnK1DCh8eKJiL8nhMjwzFQxSc80Hx9PQTxaABSU7mmhK6d27gzGVRisD7Teuta3SsVMyUWRLj2au1vvJ7p/fF4+HvbC6jCXTOzEIAEvVtgxBY+pvdpvegjt67N9t2IzIqT2WUpn11yxZVFfYbMWjaeC7QS9o+KATUO245A0M/h2cXH4tA6DTlBo/JiMlLTPl4PCqXia8mYlIJtUlbPSkQuL5aNLfURCGNIRSAQQ0YhEy4srB8iQVX7TIJPqhKpyiMfcwlGusmK/lRUzjidsRhTdlhxNgszKPd0AKwkZybBsrTZVfmVNL9spGR7eyAC8HG6hWo6fbTERsjqnrCKHnIRUCTlFt77lyMcEg59uEz131FMjY+dDM7VAYwodqEehH8/o
 ZQjpJSQY
 QSEZWXlLY5KPEx3ti13fygVTVxuVDs7bLORyoweigAlNjEKoH252/WFt+mAXoY/xCqG/cRBKYWmxmXnrdov4xQXz7U1qKj/UAnlNojhGIwjVhAa1Z2vzxj7mL1q3kHrZSYaj2SKHTTLBO0nCWHzBJrriJpujDOumQP9AC2A4wnK9RivTVUW1CM2Mp9yec0fblJgGPeScDCWJ247XtFb6bWpALS6cBDCZA1a3PLCK1qRf9CE680Q3WC3degnIghPqr46hN2ZeAEHOzCsduMfZoWdixnXRN+EmBrT20jUu4PoNBhKTMCxFysWG6NeeRjVSXU9vSA+/HNWzPMW5HX4cIG3ziR+fVMznXHHF0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On November 10, 2026 11:00:45 PM UTC, Shiju Jose <shijujose2008@gmail=2Ecom=
> wrote:
>I am sharing the changes in patch#2 here for feedback while testing on
>other platforms=2E

Thanks, I'll merge it in with what I have locally=2E Once I've gone throug=
h the rest of the outstanding issues, I'll send a final version for folks t=
o take a look at and test and get a chance to complain=2E

 :-)

--=20
Small device=2E Typos and formatting crap

