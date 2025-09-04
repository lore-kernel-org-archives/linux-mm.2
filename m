Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B58CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4608E000C; Thu,  4 Sep 2025 03:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5298E0002; Thu,  4 Sep 2025 03:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2868E000C; Thu,  4 Sep 2025 03:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6608E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:46:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 056CC140A72
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:46:48 +0000 (UTC)
X-FDA: 83850786096.12.69DCDE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6131818000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:46:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ei8kWMgv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756972006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66epv7iYAOJtQt0fkqSt0TC2k3gxag5T/p32LfnmCe0=;
	b=oT+wfMRLXWA6Xb99K2ydeTAHrHprsH68CQbs/2m8Bh5R11SvpWb5l0MEMRxZRhwBZuFAdq
	3bTxJ+p6+sm7VubQ8TN8hPbql6LC6ZpYLgiOOvHcGWTDWVikESu6Yg8ku1Wv3/+H/Z5tJ1
	EmcdoJvIh40vC+gRQQU+m8D1Dxr7GV4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ei8kWMgv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756972006; a=rsa-sha256;
	cv=none;
	b=C8KFiWlOYO49mvEv8eYeZIm65mE+HO57sQ39EK9URpuS/r8Ib7dA4beq+3PNiYsE1dcTpZ
	WmwwI2TQ7Lb3eRwJZTgftyKivCnFMNk8aAFvGWnK9sktArF6oAs4Ss85heiIoXjovp7n7O
	L37uYHZlhELMDk0pfzRL/fTfIBNvQF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E35340425;
	Thu,  4 Sep 2025 07:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3113CC4CEF0;
	Thu,  4 Sep 2025 07:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756972005;
	bh=ayhnFOvBI35lN1QuVk6R0qQPQ85LgwB6FlWmSDytSD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ei8kWMgvmOrl55vH/goejl0rRfHpQQ1VmNfXzvHDz+lTW0OMkPved487WEfKf7TiY
	 KUNMyus/fVOJTuujNmC9bMhq+b90A2Zz5no4E5gchShcIjFAp3C0qq8ONOlyrsP3tQ
	 +ximJtJTMRJlFQCtfQD537bk775UQQ2nitfJpfBZ+gtDiQZdBjVO7lZcQnf4SNLq/0
	 UXxcYiDXmQJczRfJTfZuX7iYkFm6I1ypem81PHfCTyHAkg8RENBZZ4TOux6iEpx9cV
	 hQLAvTaqU+wqtlSd7RHiRrc05M7CVuS00EFQrenJKysh14aiq2C+dxydSw3KfDUySQ
	 1cUCcdAhFXjgw==
Date: Thu, 4 Sep 2025 10:46:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/18] mm/ksw: add build system support
Message-ID: <aLlD2CDengxSl4fS@kernel.org>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-2-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-2-wangjinchao600@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6131818000D
X-Stat-Signature: 1jp8c8xqgdhftpjor3riof9n9gm7dubu
X-Rspam-User: 
X-HE-Tag: 1756972006-110387
X-HE-Meta: U2FsdGVkX19uejnXxhklLtgz366e0BpwI557MlJNTe1hVELg55g9izDQ1ikbGxHcKWfGRfDFplxzDD39J2HzrUBT2Gfy7c6DWFLLwfMAIenLcBzmUQfW9DNDg6ZBPMBSfR1KlNj7SzkMbdqZwXo5sIXMxvKy0mhimTEOV6+Ia8qpp/CzFQUsS+uXzZxkirKvlThEQsWR6burtcI14zrlwZ+7tK2Ai88Y8BIUvyEfSbnMIVsTHL78AvpEsm1tekSaGWtaL3jABk647TcQT6rexIVmQ1QR5aBj07fVe/z7GoEHkbmd17ERfQl1ExeoD4TB9QYkvm4561TrZDKBHhxsFISWm2cgzCwO0QAqdgapkbKWJyn3NvIDWKFRfTT4zCOe1MrqLxhIIxU77Ch7KxGEt+BiMIEkgtvU0uElwXJLNXLwTEi+7e3qNSn5jI/lfVr7SEIkdvwhkJQPd1w7JtH+dLF0UCLKi9/rgkH200sxB122MNk2AZ9SUdbyUUlemn6eUoxloIwrOYdNSQxHgIVf50clUqBFl7ld0ZP1B6NPzdYaNl9mydxa+qt315Xqs3Vus4J2oIct5yP3TH5Py32QNEd+/k4PPUmiYOgybjR4L9RFoapowwT5QRhmyeOmC2tHVvTbFiYS2EMTNbTV7KGW7D8ezliJBr2f+prN1w6DCXOrFOpzGyaaxC/0iNffHcp348K+qSfKKWxi3/r392ZDI0p7ZHuDiU7EL0VMDKfe2uQr2WF0xypXPUsX4dws4ZzAc1O2y9w215HeHaYZUyJ+oFzF92iPLEcJmTI3UCNqLzWQ15CuR72Jq7dqTLp9fBNsI+CnfPEQRtL0Zb8deSpO5OZaKMcI5SDnFmtHVpP6Uddw8MKTld8Xx2xmAHBDwRIvORiKNqXwjpwjvGndcjwCfbItHs1vAkMDoRsv6PolCJvT5fqyB/a/DYwVWC9dQLNhOnf+K38k27YUbslLaoy
 FtaZ+R+F
 RzZwYc0tTEoZqCoMwdBfB3E18Qb/TPhT7n0R/SPVfKpzveLJtWOgS1XnFDzPd0Z7xjRYRDKhFPzT/MKke5ffv0X3GvLqCCOUR9kBkdr0dNdxu2rZ0D2Qc5tE10/BxMNPNbYg6ru28BnO98ggQDu/leY7vM0X2HiTbbXYZjPTOVbPPIGxE6b6Ve9eYQgZWPNNkNlYJ/Vf2/U+Jf9UTjDXpOQLkMl6eYdjLivU2L0ZaXi0wgg2/wXC69xD4862U/EvEHv3K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:20:58AM +0800, Jinchao Wang wrote:
> Add Kconfig and Makefile infrastructure for KStackWatch, a real-time tool
> for debugging kernel stack corruption.

...

> +static int __init kstackwatch_init(void)
> +{
> +	pr_info("KSW: module loaded\n");
> +	pr_info("KSW: usage:\n");
> +	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");

It feels like this belongs to Documentation/ rather than the kernel log.

> +	return 0;
> +}
> +

-- 
Sincerely yours,
Mike.

