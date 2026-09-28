Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06733CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C686B0093; Mon, 28 Sep 2026 15:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13BB6B0095; Mon, 28 Sep 2026 15:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AC56B0096; Mon, 28 Sep 2026 15:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB1646B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:20:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 461FD1C0CA4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:20:28 +0000 (UTC)
X-FDA: 85264137336.12.EA8CC63
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DB2420006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:20:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RqFymikj;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBqyVMo6pWKAr13NYV/9DY4DwxVan3yzu41fmE1Qx6w=;
	b=f6M7cjQVe4Q1UHo3Uac9vQxNow/wvUDHKwNGwYspwd5hTOtlp9rjNLLuSP60yjM/zwN0Eq
	R12kTOzryn7NPqOV0sbH6VdVzglUYnK3KzlJSFT3/4/IBTw7COXCV/Ab+v4PePwNOS6awH
	T2nC62DU1j4rtpaE36j9pqhWzjqICIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623226;
	b=ruaDNOGto14IxX3iHHrSNuPPksm57I907zjqOH/+pa5FBk6oIX6MFfefFnjwSVg6qyf8ON
	7kYMtvRtCjv4YdsojzXm+YVPM1uUHu6Q4Qi/Rj/AwSTEIIvDqH564iU+L5UNxwZpJXDDBi
	nEeZT1kS4mHxe+UPtWLO2B2D7s0DrTs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RqFymikj;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=XBqyVMo6pWKAr13NYV/9DY4DwxVan3yzu41fmE1Qx6w=; b=RqFymikjtUZjzYg7puqAnn+sg3
	61FRddqIeawfj9uM+vYWtCfo1ylwmmINy9FVZ/tC3YoBr4aJbIxEXtzk8tGX7VF962W5/ko1IE4pH
	KonoVPFwRYCXr6IMzmkpDCSMyDSAZY/zqDxV/mCwdoNoAM5tXfSzkQUN3apsLc04f+dO2/wr/GN47
	fslxlNodhFwrFldD91LdDL0Shf4oAvq9/kpLqsB1DAq9kpr0v0pi54xZnCxJ165Dj5JiEfHoGb14+
	XqJsHdq9vLDUgWcjCxT3dZasZuSlJQzWrvwEoI6aKbB3bzok+wGAUIx0NeBWwrnl2M9jV0GUdDAJm
	b5C3yInA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBGt9-00000001Pqt-0G3I;
	Mon, 28 Sep 2026 19:19:47 +0000
Message-ID: <99217c46-6ec4-4af6-ac14-18f814f86ba1@infradead.org>
Date: Mon, 28 Sep 2026 12:19:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] kexec: Expose the crash memaction bitmap in
 debugfs
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@linux.ibm.com>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1frpn4g7s71bb3yjdg6uxqthynhizri6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9DB2420006
X-HE-Tag: 1790623225-533238
X-HE-Meta: U2FsdGVkX1/ByJf1oylA3U1+r7rKlwQKxWC4JRSkZzki8vKjK3A3d+gX5NUE0NCKdUWAFo/HKMu1jQdM4UpQD19fMF3paUUmz0kISwiVh5/HKvpY49Z8LPvu+MtKXEGlPXpAF2OtFNCipYWD0pTRbkeyohUXg/0IAeWXLw7NVnWFp6s1OhNJ5qXWzYz7Wf3vVgwIH0qpiW1FToLk9bK3mssWPBDRKX3AhbixhAsuo20dGutpYT3Ky7XQlz51Fqlrob/aDoFDRXDFB1mXiHxIvJL4F/AJUhuR9kRLsB4ou51qu5gn67q3TJnddezvQnUwPpky27sYNPlY0IOslRqkb7FqszJY9jk1cOXp8TGO7y9vc9Fx/zC8dBmBGqYUHgJ8s5WSl4+X3/6ggMwdQ8jH8RL1aA4wqjQna2YwQFxxUbz4vQSCOC3qxae81534YXn7UQo5D23uC1BOqhzWC5S22bks5/Xwt0kZ2W8WXhXZ5Amv3dzHp+XtTFN5z0CUG3diEn/xo/WR3XHsza//IZb1oKkriXz4yzezaclzadQfjdMzPB8uM3TsXZ4rnZAvN8zYUOIs3gPQ/ep8PM9AAbP895LF+NP9wYjk8OP6BfaragpyRTTZkjtct2nLuI5641rI4fNNgifd44mniZHrOkZTluzG4Rgb+zmKFSAtk5+XFLbOLvtpA7JL+SOYVbUzfYJpinCZswBuNUy+fphctto250A3g4W/x/uvVW2y84JXFDwIUnvM9NCb5mSGfBM5QieT8oJl49Abb1KRpHfZ3g96y6oIJcXM6gsF7IBxZ1jGcULOVH+QBYbafS2vx3gNSpU3sN/PaZuGenTU89nlfETGwKWo9M9nNs8T7J45i1gXuNsY5C2RXfGrBSCsOAiv8Yha3y06WQr7Ndrv/x8u6s3OK23S6OdemUfLLAsrn8WMDsHiT20jjHu7dto0tou1/Qq0a1kz6kUXBE37DKCGDux
 UF+X+9TI
 V803uYee8CW8N3FvVVbnKJUEJZAq3C0CP85DyWb4CgKWFaunfVGUwIY+eRiZil2v2U/nKhfzLdbGVMf7P7xEeHDQrkfjwuD1zCwrBNOaiLxMzdSpndOkzY1dNyiyOLh9ZMMG/O333AoojqTGkxSUo9ZUXaF/aSJBoboIch1ay1Oq19dHVtSF+U+oaJWLWa8CoY7Gb2w6gqrVR7D1Y4y/ZPVr7Ah/XV7NVs1l/phW5sdq8b5MQNCfvzJdy+O2r1HJxHRULHp3sKkjlVFjJ5Q2nUsid4OY3FePRKBQGXHDT28kO31duTBfOdYQ3B6Y7js5njNUbqgIOmdm1PjF2l6uJeUSFNS3jUU5nmq231VuhNuvbq24mRo37v7JvWHElzkSE56tW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/26 10:18 AM, Jan Sebastian Götte wrote:
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 3cdc8d459ac0..b5380e16bfaf 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -204,4 +204,18 @@ config CRASH_MEMACTION
>  
>  	  If unsure, say N.
>  
> +config CRASH_MEMACTION_DEBUGFS
> +	bool "Expose the crash memaction bitmap in debugfs"
> +	depends on CRASH_MEMACTION && DEBUG_FS
> +	help
> +	  Allow reading the live crash_memaction bitmap through
> +      /sys/kernel/debug/crash_memaction/. The bitmap is used when
> +      CRASH_MEMACTION is set and when a crash_memaction cmdline param is present
> +      to tell an eventual kdump kernel about the use of certain memory pages.
> +
> +      Note that this is a debug interface only that gives no guarantees
> +      whatsoever on memory consistency.
> +
> +	  If unsure, say N.
> +
>  endmenu

Please adhere to kernel coding style for Kconfig files:

10) Kconfig configuration files
-------------------------------

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.

-- 
~Randy


