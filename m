Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A937ECA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 21:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F826B0088; Tue,  6 Oct 2026 17:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0326B008C; Tue,  6 Oct 2026 17:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0236B0092; Tue,  6 Oct 2026 17:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3683B6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 17:55:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B63861A030C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 21:55:21 +0000 (UTC)
X-FDA: 85293558042.21.3C9D5FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B6D240007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 21:55:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNM4U+Ff;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791323720;
	b=6siHgt74Py8w+zkLYHpMTldYFPjPBamPJsdETmkmQaheBn+Ci6/6rUUErCOt+T31jgzyqQ
	aoqll3c0odcfrFz1cTcgK7PkVsVw5YYE4Rm+3cUCY8W8uAInA1grE0VxV1jq2zhrhChsUt
	536LKIslJeF1BHdHdkWBI1AYP2bpRqo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNM4U+Ff;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791323720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6cFzmPVwnvLGajBYkemFKtr5g0mwddLRoGytSZpBcQ=;
	b=g48363rd8zwYEUmzqP18JAriwuZoNK28xICQjKqxG1vlvBHEN9uef8QFDUehEd3zzvoP9V
	4RvOZaUeMd6kv9kXwA8dP6Q1fHk2EmTSzQLZu0VTTViE2fvjxA4cZ4nKPW3qaNVBccqbtC
	Bf5M6W1JXw7XqdZ5FCi0AAPX6X2DO80=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7526643809;
	Tue,  6 Oct 2026 21:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D69B1F0089B;
	Tue,  6 Oct 2026 21:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791323718;
	bh=p6cFzmPVwnvLGajBYkemFKtr5g0mwddLRoGytSZpBcQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JNM4U+FfrDsXu5990fwPYm6E29Rkx4Z2Jnv2SwaQHObk/terRWHB1dyEp0e6TARv3
	 he5XCigWKBrVTsXRj+vBYmp+MOTpS18pIF/4QCPC8Oryq9OvaZvGZg/g3GgYXuIuhf
	 J6Vr14biXn3SW9Igv5wQFFKarNudhjYVJ3TlNzsi3UV3+oYdOt5Zlvzx72+chr+lJA
	 iTglIHE9dfWIxKGmIYtihtacHmp9QMlTBfYOKNbHXQbBIXJE0ZTypKLL6hNYRElVvp
	 gWyctowbQSA+0XTQdJTU3vxFX9iVd4i/dcICnRKPyU6QCx2aYE+Kicch5b1UhOq3V6
	 LWZgF1xyJm80A==
Message-ID: <007d40e9-221f-4dcc-ab74-e2f1ff706dec@kernel.org>
Date: Tue, 6 Oct 2026 23:55:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
To: Kees Cook <kees@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev,
 linux-hardening@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20260914223219.901347-2-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B6D240007
X-Rspam-User: 
X-Stat-Signature: co4yheebc4h5kjapnc1nwbhjxma8px4t
X-HE-Tag: 1791323719-490049
X-HE-Meta: U2FsdGVkX1/W5V3iS+A8oPuOP2IcO9yzOfSqSxKiBOarCG403DLCN3K77CgCVKQ2via+Kt569xGN1nCvxyo5pqFzVkwMV04J+neqPWsNPnsiQemZkOvu4pN/dp0+RG4peLTap5zYNBnuDh/xd89w32zbrTeQvXPiEQOECO4rcVTVc5glca1/MyTfNI8F30zAXNuwt5O0yoG8Kd6qxCZ83tUoCMFt9mLWLUJvACXWXM3s3nAT2nfSVCNRcGBmazngtDo4fk0l3Bax37e3AqBfbGIzwAQXl07DzTzYdeen1s7nhgRyvfwskh7NSQVscryf2Jn/IVXMnRLmp6JxENqkVmkVRDq3NbZKKYRhvpEyrVbL5j7vEseLigYmgcnIKyHwcN0L7fmpz4i6eSEQp4zpZTXun/Znr91HA70/6d52zxfOuE4fZVSMnZIl+MAyc7be1XdyWTksoXIlAHkmanbJFyp3Re8rICfTcayeIkW7aGaoFc5j2B4py/9OUGHyxoNbR6Zyr9zCEEtaT9v+eA2VzK/lWVcgo/9rCG5BaGvYOpLSwzfqi3QibL3e0Cy3dMdDYXyKXsmTe/pXMZ7jjm2gNKst/enVmOMGaanj2qSYdRcQDpXXc9HixQ0G8XHtMpwEodCCE6OMVWGf3xdWOBPhl7TyDvIrQJzA0dcFQqtfU9+E3JKd3dOD6VmhRI27WX/c1OuVqvruS5ef4u5wdy1ufcGotvGvxkhYEtVTU0EVaOIA/Gzl5GQSiuvUNnn3/kCx6FgGwENPWorZQiVgYKUTCN9TDdcIySc3Yujj+tI2LaTI99Qn6OYgnpz0yO00xb+NoFUF7uGa8749HUVLrbJfnVrNRy8x8tYdLvESy7vl77U7coqJPKaCmyZXYUyajKLlfsA3yb9XATt3QzCuEQ3WQr+XRETJBhsIifN2qvbGron4VmmkvBOwr+Tt9rBb1FupyKykp+K/GdjNP5AST/t
 NxbM5Tqh
 Zh/48sdg15ZhLh7D2ezzBPZtQ5w5+qVDO8EASAZU4iqDdEgCY0t8jYYEWRgUJt0VfbKtbRUPWWK9sid/6Rbri7LnaMgk5M4l33W2fAdPPD2IA7xZ9MeT/j5m4PoNNNcNdiik+SmBSt+FXKRBUXYYIYMYSwyiWs7Z1hZYH6K7cn+ldulzIe8YbgRttfPVMaCNxZj7a0V4fCkF7H2Rhl437rkyJmwhJu06AlrDiVgPjMrLIfwHqklCnSOtf+H7Nllx3XxhpS+sYrlvGxKo2+w1ecH29sxrbfpPG2s4AUYMPDhQAskOKz9Tnffj/sMkunoyZv4whEbVms4/+6QM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.26 00:32, Kees Cook wrote:
> Mirroring the type-based allocation now in use for the kmalloc family of
> APIs, provide the same for the devm_kmalloc family of APIs. This will
> allow for future plumbing of type information (e.g. alignment) into the
> underlying allocations. This immediately gains type check on return
> values (instead of the prior "void *" return type).
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>

