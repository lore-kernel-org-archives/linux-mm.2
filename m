Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF94EA811D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162056B0088; Tue, 10 Feb 2026 08:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143186B008C; Tue, 10 Feb 2026 08:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0707A6B0092; Tue, 10 Feb 2026 08:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA9AC6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:55:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 987FB16055D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:55:28 +0000 (UTC)
X-FDA: 84428694336.15.9CB3027
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04361180010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:55:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYIHdFRL;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sD0GLwSYXIdm9e+BN8o4k7OyBkQyu546gqHQCZm6No=;
	b=hK0FnLOWzxUYyAYTY79V0O6kxlqA1afS1fgBlv9Fb7TJGZ1/v+VoipNeCiLriiTMZcfBcG
	6towdcMUpQ8YiRfNgbOkJqCKA25WXH+yqX00PNK+rpAOYpOdWKww2gvoC2nhrQenKpe0ey
	RFluRJ2I3Rrxz0xhs9Y6M0r3SY+LUZo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYIHdFRL;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731727; a=rsa-sha256;
	cv=none;
	b=38mtOe/qAR8QGP5m2aZQYwBKur2IBjQouzL2lF1b6asl/JlOlSnyEC8Ix9jSBawnK7noXZ
	DtLfdcrcCKr7SIwL4jfsKqkOQOqxqnmZMJ1g4YCLFphYV1L4UxXh5sczGRa2NHITSEUFK5
	HIbzcMk7MlO3Zn9SLPAHATAQmC4jLN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6200E60097;
	Tue, 10 Feb 2026 13:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6240BC116C6;
	Tue, 10 Feb 2026 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770731726;
	bh=JE2m8NIaql1tE2VnNeufIkHeTWlYa03U2mH/McAh6Hk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iYIHdFRLbDb9dyt6VlP4jwIQGdzjgP4C0/I3oSr8QEKEq5jTwwRZJUrRJtOzzA3d3
	 ul3zgxJmUr3HgWkJ9HBsTJhVcnU6ZtPIV+vw4ytNw5WIWXRjsP8lMqQVR5eP/ZLhvg
	 gI/eXdV6aJ9aetiEmcgNqbvi75ULz9BNpcAHx5TN+sw/9PfvzzJHmZc57gBXFB11Tf
	 9X9MSeHPJPU+WhI5/mPpj2wApuaADExGIrm2td5yuTzfHvXfi+U9wpB1Fm+hFe+Wmc
	 tvEEIlVNrrB4Ss88kZIoM+FhYl4NG7IQUEtReipVIXgHjLdNh2X6kUfDrpRyr/hDsl
	 qZ1v9M/CP76+Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] kho: add support for deferred struct page init
In-Reply-To: <20260210130418.297153-1-mclapinski@google.com> (Michal
	Clapinski's message of "Tue, 10 Feb 2026 14:04:18 +0100")
References: <20260210130418.297153-1-mclapinski@google.com>
Date: Tue, 10 Feb 2026 14:55:22 +0100
Message-ID: <2vxzecmssnxx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 04361180010
X-Rspamd-Server: rspam07
X-Stat-Signature: 7zpfe8kga9rdotbj18pgm9yhik7qou8n
X-HE-Tag: 1770731726-553115
X-HE-Meta: U2FsdGVkX18pt0OYLYaLPdxsiO/1CEc7Ky6wfcKo5lZN+qLMrIy1GPnelKfBB2NwnSpNP8PLC/h5a04Ib3iIxvJs9gVmry+h+958okLiknpCyK9N/KMtGqBmImWxHxDmih7eXsugJKuyVS/ctCwOJZnujjp2kLazbyNXq7V8at96CWiqWrj1DiEdtIkkjsGSdCElRDkMsGZEEJBKg4r+cpMM1e/qzEVwcyTnRs+6xmNLl/CKIwUR2R5PlTGjNbG1GhHRWW91rF/a10PbSPfjgDT3J985CBSFU8P/NNtUKOQ7J2K9cnIpdu4q1HJAka2FcmGFHDd0wiueM4NyuyPB1lujl8x6iiPkUGcOyFikX3qTmTcy+SBuYQW61bwhSHn35dipcizO9pRK1rIURI3E0drh/c62U8BquHS+kdVdBwFQaY8iuyqRFGE7xNVRrkzsKAC8CwwIoVbDQAlqWAa/pfTsPZy610dznU8NYjssp2HdMcKUJQ4F5BEAdWDhRwQtbZtbqDfkx9md8QHmfG/w9O9aA8IW17l9WYiHAeD+WlVTKytLkBtjsvgAbtC17Xz4A6dh1BMMtyt8hKvRaEB5PgfxZuQQpDuPExL16TgjLr/H1R8kpYPrGzW+47qN9TMDF00zOF5Tse359f8gFhvlgQ7afStDD5lguuPQFJdFsc+L5HSQW6OGz2MxAusYrQZgsyvGG7Jn3ATlClvj0lEt8Ebe77/KyT1jsv3U8IAAhwuvuKFMw0XJckBp0W3OnoI3BxzY7n+lbBFQy35XFP/rdt/YMdaOOFECpQeuSePamvZBQSECrk0NhqbYShuvx3p933f4jiB3cqp7o4+AKRgmuISjbb1qcx1WC+oP0SqDRLWqMwjIvDAfvIbR+UtmzaSWr6+rgDSBebpAqljcFp5MTsw6BT5TRxaWeiA5tqQVTi3QMYDkPziuFs4arv68GBy8iz5HhXH/Zlu50E/b9eV
 //QPpHDG
 fiCBXdBMWb4Vl4/GKEXOIMLe4SCliA1V/rhH64mn4KXRqmISGWm2v3Uu065tjKO8qvLL/Ja4NXNgbgsxIWfVO+UDTh7TTMsN8rB9i4IuU76pqxuehexDoexIwzGHS3DefV0Q6SnxGMAn91xKkilitm8WNY30wmqWjc0ZAI4SCv5ub95zJhASPqsllnSE9UEC9jZpe9cKNnYH+QieA8xnJyQwDSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10 2026, Michal Clapinski wrote:

> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
>
> During KHO restoration, `deserialize_bitmap()` writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> ```
> BUG: unable to handle page fault for address: ...
> ```
>
> Fix this by introducing `kho_get_preserved_page()`,  which ensures
> all struct pages in a preserved region are initialized by calling
> `init_deferred_page()` which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

