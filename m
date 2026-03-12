Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2FBFED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E466B008A; Thu, 12 Mar 2026 00:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336A96B008C; Thu, 12 Mar 2026 00:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239516B0092; Thu, 12 Mar 2026 00:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 148F46B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:34:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9D3A160364
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:34:24 +0000 (UTC)
X-FDA: 84536144448.05.804B139
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 11A6240004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:34:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=icdKWQ8p;
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773290063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/GdNouIWyw/Hxd+Cg8eyY6MPPfVnuc4KC8I179/6Oo=;
	b=Emh0wGcaps3lqNMqfIIh0SrOdwZh3A+/VranM3m1AC4UtedK/mBQV2z7f9Owb76ghrn0J8
	+UKj5eMRaw8ItjsTgeTBTmLekXRtZR4qiNb8Y5FBKdor/Snwp073sb6IiSY+doM3riEvNU
	0eAZTyiWz1mduUnmmMtbPwHeMBQCiOQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=icdKWQ8p;
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773290063; a=rsa-sha256;
	cv=none;
	b=nGMDCi/zqMeQUG9wN7zXrBwRRTP0udzjgTPQeZmtMQJjbbwBReA5mWbsVUQ1jeQeRjGsu1
	/Th8xSadvPwRF0CmmJ2EKmfKPOd3ay+Ndvi8sANFjh3vMbIfhjFPJnbwdnY27AWl2f34Gr
	MfoXnNNKUNM4OnKEbHh4npvSWc6etm0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=W/GdNouIWyw/Hxd+Cg8eyY6MPPfVnuc4KC8I179/6Oo=; b=icdKWQ8pM7+BfYu6G/Y782mRO3
	ZX3/3xRZ9+vCXzzSlrbsiZVR7HH4GWF/miznAlW4YdW0B+VOUA/Hu8SmAyIVK9mlkRz0C3rd5S1oK
	6uVWDOjBPgZ7l9f5N2V/h6V7x61cwzmp6c0knIkykh+vUWtKrpx9bAwcWSVoTjaOdFdc9oPf9r1i1
	fvV/WCMCscSDcOuE7AD4/vKXaQZAqSQg3yhEOECDAmsmi9Q279WdIBbrfdM3q0wUg8BqI2J7tEBN/
	eNC51BScMZXvhdWygSXkDxNWWGThaGq8c7RkkfIbyPpT0s2CVD2O1neaXgrP/SSJM8OdqCtnCxHR6
	8/3/7IHw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Xk8-0000000DGZs-2BrU;
	Thu, 12 Mar 2026 04:33:52 +0000
Message-ID: <1418e495-8725-45fb-a865-b75fb87477f6@infradead.org>
Date: Wed, 11 Mar 2026 21:33:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/25] kernel: Introduce meminspect
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Eugen Hristev <eugen.hristev@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x3q8jsmfss7rp4dn68gaikmt7wtey81u
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 11A6240004
X-HE-Tag: 1773290061-530092
X-HE-Meta: U2FsdGVkX1+xvc/cJRa6CD8xAmAZQZZcFk8HTNiat64sRDAxrXemfL2Yl1G9kfWumec5wiW2plGtDABFEG4nNpTdvLuqxmzET2s6888pMVH4afDC/y0dQnOZreqoBT5xR5wFSYhpDLPbCALqtDDs6AV/XTAeNh1kUVs84Oxy7IjicJBO6ahye8M+j3KHFjo7wBT6cXv6nfD3/OV/n//Wpt4b/9/mcqlWCJZG8tP+nTMYPTd2q42TB5AtLNRVaZRIvOnydvGEjQBqmei5iV6GQEkls/gHld9Mo53srcqOu2LbHFXgo7e+ZJPicoXUThhGawrAeCGu6hDT2bsPjPYqg5ayYTg+egt+1Ru5LioFXPD0sXMK+X5d/1ab/G8qTmp2IUN/8lfO0MzaWnGPDxT4CU+4SHw0GXLSAmj6JhyixEGK1OTwTuMSU0TkwXmjkmPTAmoA49nHnewdPFDAdkDNNEovTRjgz+5QGOt6D+aXf9c5VJo2tER0Z4jjYA7meJr9gnwC9tN+T5vkmftwI+a//LsljwVNCGugLEoxGulYaniuMCqlzaJuWiR9Q/ouubv9PBj7Wgkz7ZWJNyNbXyKm7V5POK3Z7RZWii0N+LusWiosxV9IcL3hJlMPy0xGZC9G4sOipT5S7oYKAMoLwbrgIrKfhcLE8x4S0+NGH6tocgAJaPeUnSSZBTkssaCWCBZg1udKbim/BELrXFUS4RVY+FvDECsmWxqGDsoHhz68rpSvPnC9Zbw/OVlFXFouZlmWIzdd9jRt7Z26qYvHnrB2caJlEQutd12LKHc6eH8zB719XJJuIUtQaXDg6k3wBD1mAZyZZEEpFlKpoWOJdgYkHE4KOscEGOijIJ2esO4BUEUiW0ROqiDKAoP/owgEOkVLtzJwtI7ApCIGWt37DOP/UepBQtCU//wqEB5V1QZqczqPZaeLHXxhZ3q21nAaV86ryvRWyn97uqLTwnROFLH
 7nHntVPz
 4Tn8IWHt/05irV7yoC0F93+vx6aSiKqxOhcdKi8GOUS7q6kSv1hN7p1o5dqtpyJ0S2cNYOsGGAlXoiBdw1afoKTbafh3Cg2XkkbPN2DSldiQWNcM4BucWmRTfKX0+oNxJYvRkRkNH0X7TQunAH6o9DtLfk+hNbvnQntrCnUbGDOpxMxIZCuoKn0PC5W8JVlknnnj3tUZS/PyjjOj0VpL0RADzGDS4f5cGkYOB1k7dmLiAQ4xiH47XqHujIqCF9OteYmc2OuZNe48V6hpt+Yjk8nnPMAGR01imkom06Imjwmh2mgyIrmTuRh0Gu1VazL1goOGvqWw1tlIEzY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/10/26 1:15 PM, Mukesh Ojha wrote:
> diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
> new file mode 100644
> index 000000000000..fa2b5a84b251
> --- /dev/null
> +++ b/kernel/meminspect/Kconfig
> @@ -0,0 +1,19 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +config MEMINSPECT
> +	bool "Allow the kernel to register memory regions for inspection purpose"

	                                                                 purposes"

> +	help
> +	  Inspection mechanism allows registration of a specific memory
> +	  area(or object) for later inspection purpose.

	  area (or object)                     purposes.

> +	  Ranges are being added into an inspection table, which can be

	         are added

> +	  requested and analyzed by specific drivers.
> +	  Drivers would interface any hardware mechanism that will allow
> +	  inspection of the data, including but not limited to: dumping
> +	  for debugging, creating a coredump, analysis, or statistical
> +	  information.
> +	  Inspection table is created ahead of time such that it can be later

	  The inspection table

> +	  used regardless of the state of the kernel (running, frozen, crashed,
> +	  or any particular state).
> +
> +	  Note that modules using this feature must be rebuilt if option

	                                                       if this option

> +	  changes.

-- 
~Randy


