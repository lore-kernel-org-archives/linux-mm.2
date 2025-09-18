Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9F8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B1D8E00ED; Thu, 18 Sep 2025 06:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523618E0093; Thu, 18 Sep 2025 06:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4607E8E00ED; Thu, 18 Sep 2025 06:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37F178E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:36:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0DDAA909F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:36:09 +0000 (UTC)
X-FDA: 83902016058.26.176E8F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C98E4000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:36:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fz/6zZL0";
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758191768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbpgG0xzDyYfgotSXiIlnajj+xcL9QM94oPCfZKoeW4=;
	b=dKfrKZpIPHhXITMjo7U4PKyO4M4HVMqgbaTuzrps7FDX6OI2GK6cmygpOkng49wUqfzoxr
	dCqjW5+ge8ojkWzbTp+WGfjYyAS8k+/p1mCuQf4TJaJkzF+Rin51DM10JtOMmDehtmaD/l
	dIINVhfAD0RvROE+AaCDdg1C8Fzbyvg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fz/6zZL0";
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758191768; a=rsa-sha256;
	cv=none;
	b=o0hI+QYKty3GNUtigtXe8+QMysG6djxQ3P20WJVoy3he2L/1ponIFE6sESVcB+Xm5oUU5U
	uvO1GT/UIYjRs+ko7KkY+uevSrn6pvYCWQsrdgTsIbkp2xq5wMBfrOs8VnNYS8bokv+f3/
	zcguyiJCuYtayEUm6cPDf8Ia3i1qKgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C25F40A15;
	Thu, 18 Sep 2025 10:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64085C4CEE7;
	Thu, 18 Sep 2025 10:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191767;
	bh=mZX5B1t7YSBW9QkRnh+ZDz1Rd/PMlNLLBRIAPafjyqs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fz/6zZL0PAGE1z0p2ms1Dh2wy28tKMl7oNKY8JwicGiteN5NCKn0g689nlEuCrbzb
	 NaKK560c/yH7EgZ7p5MM1Tr4LngKm2VDM0u8P36cmot9SSElPNKEf1K3sC5f0C6XUP
	 4SZ+RDR6NpLCbIAMdogqTjWvzm/XM9yY0k8hgLrGrx4gLYXe4X+tUq5TH324GFCPWT
	 /KfIS8vbv/qopXT9nsg+YSvPwJPkgJga3b6YKXSjcrvb6tdjvW5mEn7yG7CWPCWqIC
	 A/1eyl51xk4hfh9iJ0mRVLO3Zdbd9mSPn4gbJnga534wRGJpBuV3ic6sPSeACCNtNM
	 SIL79ex3q3z4w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] lib/test_kho: use kho_preserve_vmalloc instead
 of storing addresses in fdt
In-Reply-To: <20250917174033.3810435-5-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
	<20250917174033.3810435-5-rppt@kernel.org>
Date: Thu, 18 Sep 2025 12:36:04 +0200
Message-ID: <mafs0wm5wf3or.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4C98E4000E
X-Stat-Signature: fu8pzdk5wi3fe6kzcubj9eszk35eud5x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758191768-877602
X-HE-Meta: U2FsdGVkX18/pGidTzjTnNcKgMRxn3TE607LlFUKXmAa9bSuvlNsuk/+WqhcBWHweDrh3E+Hls4zIGNQ4DLmpOHMMvOh3Nmg6MYlK0mwC+Bwu3WVly0IuuDeJJQXHtsCW5cJD2EjA5Pp8QBCKHeWXmSINT5DB2jTz2FBbNrQU2CSE8NGvNSUiNAlWAENvuFSXKkszXI6pTy0iMNeozBZhCctz5r2rCW0BaTMMEDZ0K5JTMFvebzRSweOXB1OzCfM7jaweHAG1HGWASFqYtatieiWSQdrA6Q3qouCq2A0AloeLCVHdRSJqdtonSREK/GRGe67MXn3xn2tO6XMtQhguZip2EaPDohQMMKvSc4qI+dbgE995agNzzpTSTR5msXieJKQXdHkl//rv09Ky7trr7dID3fjNKxbkYys8Opyd3HwgeHWC/X7Z+VuiJZU7V8UgbG5D+/udyFX7k7q4yomg2U4vcMLaNWQ/HRtKfELDBYBtat58353TXDOe7hF/ET23g0N/21z2Ode5/na8m6AdD0VAf8S/Nxx57rQgfumszeqHvWwLvJVhzXDwaEXu+Flfl8r5LkmR4DvHWltjNO6qJltBb9FkQr2GL/KuV43yzTqIfyPrxTxFtOUxznZ8KfQz5bQIZfN6R8GMH9N4KVmMUrbJ2ZyVUPO1Fk5q+tRIEOaEtgzyYJjp4XQatXhkZcnxSuCbIR0wkiH5iC8OZMR+bXkHEwCGHM5DTDBGOqlaaybyRbL7ZmsEbgzO0gN7GjdLM6CUcocdo44R/8XoYplI/9i0p36tZtAMBnUag/7PwmrQM0goJ5kHdNkoeDW3kSL4RwzEMTSDLip9m7DqsDfTsMUPtoejMCWVZG+xkE3bY1icZMG6UogDRItIU58pw/a1tbMw/BpZ9wEF0iPiDPfBLCoGZvsqaDDbEYjXxJy41gaSo2Rv5v4GXKIYKfuloJqXS1cyxD4fD1b5D1kVah
 BNCbGber
 RNUeOnEBM1ESCQvVh6kgoqvNRMePNecSXORSPdJYD65L1k5fkpmzxAnho4WHhzzuQYbphYufyP/DFCh1sfI7u1f1+J+oPBCYHxHJCV9cTkmc41EK86wHJyuewKZjQ/raRYqJoQ1ybuTOkQD090jNZZz60Fenh4UqWeVwqCJxedo11QKFQQQkxq3TSavzxXWYdlJAeBj+1qxV19Xu/HwOny39D8Tqh7zVRawQacuJMgw3cvvqDuBXEqPVbLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> KHO test stores physical addresses of the preserved folios directly in
> fdt.
> Use kho_preserve_vmalloc() instead of it and kho_restore_vmalloc() to
> retrieve the addresses after kexec.
>
> This makes the test more scalable from one side and adds tests coverage
> for kho_preserve_vmalloc() from the other.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

