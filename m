Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A78606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCxnCtMv
Received: by kanga.kvack.org (Postfix)
	id 1A8B16B05C1; Tue,  3 Nov 2026 11:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1333B6B05C2; Tue,  3 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A2A6B05C3; Tue,  3 Nov 2026 11:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5F1D6B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FAC9A8037
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:25 +0000 (UTC)
X-FDA: 85394312850.11.AED4E78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CAF3D180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCxnCtMv;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	b=BhiZ1KGiJjhygiXM/cmHf/POD5akjDkQlnTnNSsR0r4OKLVHJyMm80TnexZKjfn9T20CbR
	VStWH/sY9V2j8uncsB6xwL/GGHjJNbFwgJmjN7O5gWNYcFu6YVWSanGS6nKIovoy//PZTE
	ZNyLG81rMTGg6FkaqJenvYLZ53kB/s0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722643;
	b=mnjpZMBTkZ0UnWIEEnsy+ewsiAEswnU/4vb9KJWAjVMNX8V8icyDE3dKw/nVPbsr2tCHHl
	DmROfsDofBzegd3JSFX9AUWkEzniyGYvfCQbEx6h1JP+INe66/OWA16YKDA6UW+RCRWaQr
	wR0916GWITlgRfvHbYqxo8Ja09aF9Uw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCxnCtMv;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2663C43C94;
	Tue,  3 Nov 2026 16:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C81F000C1;
	Tue,  3 Nov 2026 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722643;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fCxnCtMvmols8l2UoWEtSEoz31l6QReTQ3w3+tw4CDZ7RWZeIU7e6Ox+mOVQz3Hfo
	 ptHPiSHAcAuJz69eDvWdRbYnVRJhsRW2FrdtBdG3QUkK333ENIAO0bMe9XjpgQf6/a
	 ZvoGNhZW6PLcfg8419V0Gy0sympMA2xw4/FS8U7/QKydi38Gjo4mFlaQ88CigPEsad
	 TTAiMoH5V/pCRmzQVIoLsUzPChEIlprteHlZEqFFr/IWogJEcefigWGk43//LTptvf
	 x5SWFLYLLGbpG3DY3KuLMqCoDIdQQtL23DNKyGAdigkqQ0DFNWJU/a74YSA5ozXkFn
	 MmWfymy8ObE9A==
Date: Tue, 03 Nov 2026 06:17:22 -1000
Message-ID: <54f916d834d4fde5a50d09e8eb57bbdf@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: read and write size_t with %zu in test_zswap
In-Reply-To: <20261103155456.534684-1-sashal@kernel.org>
References: <20261103155456.534684-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fw9k85hygxhf48nrstcd8mirosfgbo68
X-Rspamd-Queue-Id: CAF3D180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793722643-419825
X-HE-Meta: U2FsdGVkX18RD7rz5O/2HStdpNnPFwz/DxySv94vAeDhE0AnDYNh4zZ5rNmnlRwvEANpHyhaIJKm2lJbSz36fXbSScE83z5EACh4X90/tS1dQF2ELGRXf94ut9g3J6oql/1Wg/proF6sba82vsuvRFess0BDjFevRmownCGhfSxXeRPlBF1W4mRXcNfY23GH0YiBpzul5GOsOT0AOib/xN1I4zIIWoU5cbdJgxSb0TGdkdkPUyJtdQTK5H8Pk98UwWRfA+P9RQIvQo/KAZN69smLot8It5LDOCnGG8RZw1dR1nHSIx1k48ROHMYwVcw8RrkiE9ytxci2wqx3k7NDbtA+feKeMZsk/BRWynCZOHqcxtzohvuG2lkSWdhIKIzC9mCEs6zKU23yE67lxciysL1FhzZlAMXTFdv+nmO48Dq/iA2yW9VBTPXGK5u038G9+SOKXyg/4okHi/fPZpcksQz+O/ZA2duDRZTfEFF+OgSq2MO1ozytUz2oUngZBwie+6v8fE6a1ORzzccpAWRSAuMmTDN9tuuTeL6piT/+zSxZvGr/3+DlwVEEgzRzTUZhdoAAcugSDNB115eGhElroc/bpSUS3cZP0jXv21wZZnEj8mosAioUhsc3vQKWAQmyNvA4/sqN3A6f1c1EvueLtzq9KDf2CIxAqtgmWEzYqMlJZ0uwKM2meOC9dtnyELTAM4t+45n6b1CU6UWDPzt+Y+cFBoxUbldRuzCw0V75bg/FQTyX04XPBS9kMWJy0czQ2Lyt0BSPa0pSoZtjkU3dzdrjs9pSww2x84zX3Gl2cAP2N4xT5l6LJUtrXiryCVs+KhaKnDj9rI7mMOiLLbt6R6SXIiWbhBWrenR3W2EhIoDWZrgj8X+Y1QOcFrdMjfz/h9q746Mce/49ovXps+Ejk0DgrZfPpQPG+1JlIdDkt0Cvx8XiTg7/pNeX2lhnVS9x26qNxmZgCn1eTr470YF
 KmuRtHD6
 VKNbJ+cbdis9V3OTl0OdUmVJr3f6rFbur4cyQnk998HqeskIghQDWPj0l+zpx9aC3FbOkcn5BGOoMjeDY6WFbvdGKp6bKzoy76tsMewMKU3VL50nPhYEBnvnUXhyBLrOC6bEB988uC4eX5rPn3Awy1FtIiH2VdzQWLVW9YnWoS7FI6TCncQJcqXbUjdBbM3u0Zpw0z5itAYkfcMV1AuBZ7WQe70Nc0N45wCeQFVhyy8AWG8AdLlZ9nxSyiMGhXaKser61aiu7F8wQnAI1W2iV4eC4Xzm8FN9UgdguN4bYZjDu1AEdrSKoZl/yiGqxvkUv8FZ3YDO5dNoF49UFgy18u4to4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Applied to cgroup/for-7.5.

Thanks.

--
tejun

