Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02F7CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76EEE8E0021; Mon, 18 Aug 2025 04:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746A98E001E; Mon, 18 Aug 2025 04:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683618E0021; Mon, 18 Aug 2025 04:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5422F8E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:16:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6D2613907C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:16:45 +0000 (UTC)
X-FDA: 83789171970.14.04B313E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CAEF4000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:16:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755505004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DQbiwhzw6l4S28haUav0JyA2tJD4F3IvGInsZtebLm0=;
	b=KaeLSjgS3S/N7aqXEuvmV38mny2nJj4tgtWccRyERQEd2ihLx3GePwAbg+ZzJXZutphjMc
	VPDQN3PCEppYJ/ZPa+NbdK/ZCH5u7fJ6nyNv8TEPbiRgS4xlPnyGjxastXtrk5TVLMLFll
	ezHxBwa2nGhPn6NG3E/aHhIDNs3LA6M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755505004; a=rsa-sha256;
	cv=none;
	b=RrtXfinlXVZ+RSR0IdYxcYb1k0k+Qi0/zTpNgLkBbY/d+vn/am5BXTEqHKjzdJDtcPBCdv
	zfVoUa+BMTWmdRKVXuXyEHN56NHjMAGAUu9k/R4PJn78DIw8IbCK3py/DhnTKV06f3UBwy
	BwjccDARBkE8BUzbr9dCsDhHL0RGB1w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 035E21596;
	Mon, 18 Aug 2025 01:16:35 -0700 (PDT)
Received: from [10.57.58.12] (unknown [10.57.58.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B04543F63F;
	Mon, 18 Aug 2025 01:16:37 -0700 (PDT)
Message-ID: <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
Date: Mon, 18 Aug 2025 10:16:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
Cc: kernel@collabora.com
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-5-usama.anjum@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250731160132.1795351-5-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CAEF4000F
X-Stat-Signature: 4ofgn5efobp6rysg8uibjkwiy1nwkikk
X-Rspam-User: 
X-HE-Tag: 1755505003-576344
X-HE-Meta: U2FsdGVkX1+G4o4cXDEUkwgD7txh03R0K2+MRyZg+PA/eg0tiYBI7CcE5yo7SMVSgiDDcpbs+1YSOZ5PyA2Zs2sH7+m+xrvgPf8J8MqJRD6dAPpXd7T3Wz3M+0NnbHDxiJul784Dg0rb6h+LltkrAD+OfMK05DDo4ZMk5ulr3ImLmd3MBoK/AHwZo5T2fn+ZhPLjZpJ83FL9x641n+6k1ir5z2gk2inefTeBXBXQotyaYgrFGgDAtdHtiZN2VG6MnKXKJLowtekOQdZ9C0P6h/O9zgLSPwHZ3y6mduvle9kaXgtgLa7Bw18x5wA0BuYNEFLlO3YNJMxl7XQjktzF42YramEN97P8vCvx36u7lZf666zV9v009vLVjDw7ZxZ0LIOo7sBLzeUO+M3sHx2XrTD6xyF6xVYu26QWQGAbZM3fKnIcGID4qeY653dr5gycybdW1Tr0gnSuOZqr1/TIm6DvaPNrE7cOmbmLmu8lzCyoL/C2CF8MyTE4zhJ/Ge3G3l4ikEDMG5wGiQLTlHOFGAW+jRMvRX1/XviGIZ2BKRAC62YyzDAt3nGwxCdgU03TrilKSWOlEzVhQUzq18zhG4Whjs/lE3u3PnvjO6TK3RIqLwmj2aW5l2zgAAUlDQZ2fMN2bdPwB4RxVJu7DddZezw9DN9FMClab0tH93FqxRzcDQEnsBm7pV/kjtC27K6BdQBOtgFb1q/vqTDOdwLTdb6o9TEq/aB+G/5lI2NM4UkCvims2dKGDObwtOAm+cKKK2bG/OK7cyiau6ELc8xdg8G6i66pqAnc/QiUZLnLV61FlPNh5boGAR5B5t+Wnh4Ub2HiAQ/+iulSQvyV85dbRGG5iqVgwGgSIn73CcBsU9gPIP1MH3qhBBIfr+1Dng9LjzvrUX22zxOcc5scsjQ0g9OYiZu18KoupW7qG14NxGDTdJ7oo6YobltKRRaSAjeHN3Z7enr5vOaHP/SA0dl
 ZKutsqQE
 CFVTNA2TgNwrvvihUxQ2oJRDJKInKdygpp23v9w2nc34pEgliVIoIWd0YHcVx3zJ5fMUOn28tMfyZ+dzngqjl4gmVfy/6Da0Z03kSdfzRhBWNajuvurR668nX2FV5NoULGQVXY9ss9nVdO4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/07/2025 18:01, Muhammad Usama Anjum wrote:
> [...]
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 23d4bf6215465..d75f1effcb791 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -20,7 +20,6 @@ endif
>  # thus tricking Make (and you!) into believing that All Is Well, in subsequent
>  # make invocations:
>  .DELETE_ON_ERROR:
> -
>  # Avoid accidental wrong builds, due to built-in rules working just a little
>  # bit too well--but not quite as well as required for our situation here.
>  #
> @@ -35,6 +34,7 @@ MAKEFLAGS += --no-builtin-rules
>  
>  CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
>  CFLAGS += -Wunreachable-code
> +CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value

-Wall implies all of these except -Wunused-parameter (at least according
to gcc(1)).

As to -Wunused-parameter I am frankly not convinced it's worth the
hassle. We're getting 90 lines changed in patch 6-8 just to mark
parameters as unused, in other words noise to keep the compiler happy.
It is not enabled by default in the kernel proper precisely because it
is so noisy when callbacks are involved.

Patch 5 is clearly an improvement, but I'd rather take it without
actually enabling -Wunused-parameter. The rest of this patch isn't that
useful either IMHO.

- Kevin

