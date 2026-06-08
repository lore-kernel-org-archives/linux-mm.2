Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20321CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884106B009E; Mon,  8 Jun 2026 07:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8345A6B00A1; Mon,  8 Jun 2026 07:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777036B009E; Mon,  8 Jun 2026 07:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6916B6B009E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:26:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D71FA0AB7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:26:49 +0000 (UTC)
X-FDA: 84856518138.17.C6DECBB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3DED82000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:26:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oXMiV+Xj;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzTddR6Cl/PLwaG5zu4JIpsd8tZT/snvBmedaSMT7bE=;
	b=ZciEDwX0RgmNpOnXtymhV9hChbzQQGxhx4hyYJ9c6gr6KwvERMgmZoquQ2EwxKE330W5/S
	IO4y9xGcF0lIVcS2/QNgX3vm9A+ZPqNssKrEKdf9OBjLB5rRVEMIiTGZF1wqp/HjsVqc/m
	VjZ7Ia9gUz0pbRZjfy77wGEjTIgii/E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oXMiV+Xj;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918007;
	b=pej+pRA98xXduI/yjsnrtXyOynrXqnDhhmwfPPrHvf8EpAwVy7p4x4D5OwXmdIWCd9mlUf
	1dqAZRE7K1wG1q28PK8+Rid5xCaO2e7hDRy9wkBZSRBypeRVe4fHLEJaTZSOKTchQLg+Y+
	oUU7qu8u1b0J0G8vAYBsbNLQfy29QL0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BD412437;
	Mon,  8 Jun 2026 04:26:41 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E00763F86F;
	Mon,  8 Jun 2026 04:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780918006; bh=t0xiNzRFH2GlWmfuVuRo1kZhYNIljG20MsXzjBE8J7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oXMiV+Xjr0oZpEJK/9eUWP7q5NdlK24aRQ6uPgNG8q40wSOdgfcTN5DY2KgioMWki
	 pwLWqk2gpRqkPJXC3IgJzk/ZXUxRAy4mbcW8QiZOVBwlLZ0rYvA7dB4lgSV/RSUFO8
	 GUcT1bkJf4TmqFkPhQ4lhcOICPo8T8mP8GqnZwUw=
Message-ID: <73ecf8fa-7357-4d5b-97cc-11d526876f5a@arm.com>
Date: Mon, 8 Jun 2026 16:56:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix ksft_process_madv.sh test category
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260608103224.344101-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260608103224.344101-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DED82000B
X-Stat-Signature: 6o5qb75mpiqdzmussga9zc5nzbeemuqn
X-Rspam-User: 
X-HE-Tag: 1780918007-287417
X-HE-Meta: U2FsdGVkX1/Y3DOiPUdhBxasmFBVpdRtdsw3gsUVQbctqL7MqeYtRRzGJ7+m6h43hCpVaVsKUXUXcuz0mJ/rVGPdhauJZ/eQBaUm1N+2RU4Jn9VGmQYYFfyBII+dAo/obdiLXsjrsJShIXfbsKWqGiUxPN/zqK3+WHh5Zz82RdVCiJz3nGf1gKp+zjvVCqTgpwEMuSQo2+zfhV0/i/y2Cx2oyc6PLimzuUocgoJ4srERN8o2WyJb2/qPu/GwTi/+z0HTzrfzQXrmyLuXZvALaTxdOLYcfp4fezm7sSUnEga0OpGT5+F5aZi2RRnxf0tY608p6d1I7a8sLEbBKjrfxekc33Pg3tssrpD27AT4gxcpv4swnf+4XpJdeFe0BMruPSNrHp+ryWteudCtvSx2O1xQp3qDCI7fXN4b8nhL7AmNmeNTc5obtmIi4UQLJagAz43WH7QNAylB5ZHKlbt9l6UpimnY78Uu/QA5xPkbYibxuEomKPUm1REnHi70GthtMAJOUlFm6SiQTsNpIGpAVxNpUaOrC5ECVomsFgXHnrb2KosfRjhxwOyhdpQjgCa6Ifv6OOYloe4gRNTWD2rAFkZnSFyP1bp1JajaD8Yc+TXGx61CPewk+xDDq4yBBb1uRJqSd3yqCoQgVY2nXPyeaggBnHZ0UHF/ONTHPrOmYxixYHAeGLgjtyOzDeMbrkYueIZpHUcPsz9DDAeC64eQtbYyPokPM0txC3Wwi2/9dOBhEvdEKrnh1pQ1mhtkejDKynnySSs8BogGH5BFpIMZsmvbO7MuW9u5IbY0z3IVfqaWWXvHeYgQtuihqtDyB/NERLDByv7XtBc7aYlMcFhXed+Mxr3WNb0TQco8VDXlbehKcSkKAWR1qbxcXGKKwDRUWzPSs58UFZ131RJ3UN2hmsBobIIuezFyce1fBLLENqCUgGU2uxo8+hLFfeVQDOY0pvWE2PeTbUBoalsOsJF
 nCLuv7SD
 eTtmO1dVN0bH9lE4KnBC5pDl8Crssk12xj8yuOxg+IGpa1+mOdgfqpwYlB4w9dH6MM92n1RjWjbe7nFb7J3JpaavHKY54Z3DRtVBSIKT8Ik5mMAKX8diiyvzqyfoCPMJ83Y05ilKCHoWCoCbBiTplPiabwB9EKxnjR76sJavYYQqUd+fVT0f/3pkz9W91/wcnuq0J10aQu6ZJDFsJm1nzXrSrmxVF4b9FicLy61Baje22p3VAGx2BeaD+C2ng0nXxHO+3eOSkysvm4N74DCinJk1IU8CGMxfxyj2pkkYntkvEBV7eA743jkpC7FECWgBjkNp/3IhhwUZVhpz7cEgeqv46iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/06/26 4:02 pm, Sarthak Sharma wrote:
> ksft_process_madv.sh currently runs run_vmtests.sh with the
> mmap category. Update it to run the process_madv category,
> since ksft_mmap.sh already runs the mmap category tests.
> 
> This avoids running mmap tests twice and ensures that process_madv
> tests are run through the kselftest harness.
> 
> Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/ksft_process_madv.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
> index 2c3137ae8bc8..edad2d2d888f 100755
> --- a/tools/testing/selftests/mm/ksft_process_madv.sh
> +++ b/tools/testing/selftests/mm/ksft_process_madv.sh
> @@ -1,4 +1,4 @@
>  #!/bin/sh -e
>  # SPDX-License-Identifier: GPL-2.0
>  
> -./run_vmtests.sh -t mmap
> +./run_vmtests.sh -t process_madv


