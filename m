Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1EEC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4144B6B00A4; Mon,  3 Aug 2026 09:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C32B6B00AA; Mon,  3 Aug 2026 09:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2650D6B00B0; Mon,  3 Aug 2026 09:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F25A46B00A4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F2B0160481
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:36 +0000 (UTC)
X-FDA: 85059460752.19.F97789D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97CB880005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfeROh1v;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKSEegNXfW2lpOQAddhRouW7LuvpBaU2Q0GuiYjnqCw=;
	b=BrYZxTRNgMKFchD/0ZhTibTmpXPDtp8W8oXZAMs6yTrHoTCteDAv+2lscr9aVAPDsBiOhc
	0TuSbHNIlW1uagwYNxeTsXNPDTJ0CD5J8RM9nZqXdl8Y3JQ3Jm8Xn8gzh3VE2yPOw/oDxJ
	e+0a88L2U7Cdy+FUkSNSGZAaR4jvjRI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfeROh1v;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749974;
	b=HKFy7JRfyWg8fn2NlWOfIE538YfdAQCZ9Z0kQYDEcS886PigzrMHN+5kS1fprXXNt/p1oY
	+xV3EPHn51rLMxASP7vkcuQkkLMhlFQ2EIYEmYyVZkQl90WNfbTn27knFyaKNLDFQ29kbw
	LdvFaMJBnYVND+YpBW3LwO10XINZIeE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FC3F60A61;
	Mon,  3 Aug 2026 09:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCA01F00A3A;
	Mon,  3 Aug 2026 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749973;
	bh=BKSEegNXfW2lpOQAddhRouW7LuvpBaU2Q0GuiYjnqCw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IfeROh1vbwpu41mP1+qXu5Qi0C614XgCnptV0j/UQQK2WI8kjZTg7hDHgk70tKdgy
	 KXDlWA7APDzfCyR4agogf4l5RdoIkbBMe3anAhxiSdRl8oc6c63ff1MVjuDJFICIHy
	 Huj4iF991WfP1/MZGpGjBLDz/OgWcZfWBkhhBg67cgeWuUNN+UPcdgOKKHTt/g5SCR
	 1GfMKW6HnxEYN3yq66ooaT3iRVISjMCGaukeCOiw9O3PbFthPmvHZGcoAgGAGMlNnf
	 /hEjR+VkjxQQi/MTOq4tituznJc/cSZwBsvHepKznw+d1pOAGGxtkvDA/ECU228qU0
	 5GYHUsSnN0YpQ==
Message-ID: <698b8cec-3bce-4dcb-89e8-5b0d0fce4a06@kernel.org>
Date: Mon, 3 Aug 2026 11:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97CB880005
X-Stat-Signature: htphze6i997tykywozrmzn6eqpwys7yr
X-HE-Tag: 1785749974-857033
X-HE-Meta: U2FsdGVkX18G4WDeCuMn3wxUQf0BCpTK5VkLfjUx6je8Ux9IosrK262trXZOG0Kv0Ntftfch6QXN22t3q/bvWyReFH36MiDNxgezAduM+C4+0u0nMwBIw6pxF//2mJ2gMDj6sHB/sEWm7DQhYlk8dzZ/2Apm2fwjM4Glx6mXH+p71rxrO0u93o2GuZWyD2UgXPlX2DhUeug++OhQ3VJTbqN+CddjV9FBlnrJkHY2zWo8R7Q1GvDJhO0z351R/ThGaf+CJ/1Q+Frj2xGGJ8Te0MXx5z5RmA/wWX2OYTfFelOxzk1qt+iV2nbuc+ic3nrgA4bnqtoxzYHpSoHYgvpLhyT4xFa+ljl8fmSyCdeRJRuBCXMVBipMVGpifwANz2ewm/RgPcigDXrpK7m9LmyeRCTQ3BWf31zzYR88TBXbXSi2UbbfJHDsYqhQNqkTU3OUFFLaotWo6XcFAq6ZsKhxOA2ntb7krbLTaMWMalNNI9fHT39V/VGxgsHKpmiajuwB7bbZ9UQ8G02ve+l2G3vPQPBD6VfutBcJcxi6R1zxBdNw5PKB+s8dPT2oiZZDjKbpTcrRYyE9RgndyAUPWz650CAl0eJ4WCugaxDz4cMUXcCrGzQ+hcM4LTyNHKinvxNDzj4Cin8it0//zZUBWB9vlez5wdVXLFjA3Hb38seB6rRS9pDN3pDuCt1HhYLZ1aogchkRTnduWOV/0hpkv91nRQbjajR7lAH8+UABJ5wpuvaMYzV0LucfVNNfCIEeHdUeoojzmcaSiVUG73G2XTQTyo0jJnJXmGYmepWUsV9FuLdY7PS4gI+NMdBy8T1djXa1C4TnxDpq7v/m2HxN6TEAyaGQgNleCFqhXxmezgyJdJIxhJ+xeleo3e+LocsOeZ1IUZ+vpo5/leTQn4uyZ3MVhApCUemRltBpqYVHYtE3XpI6IAmvhmqvxgfhY+n8Spwr6HqMB6v/k0TtdNIMGZX
 axd0XzU1
 5vEAUyYbtxKgftkDqEaQDpnhhm0sBbUxTOkjFvN5VsAHNkt+oEKcJNd9fO46XZUgZy527rn6chsvCGjOmtB64VxjdA1sUzt6zDDsCw4cymlepugtUrU6ofk/sT6SHEJW94DYN4XklXlG0+qh6tOZeECtMSbm43v23Ht8ocIsQn0KlLYsCNuu/kgDeji8XBcPJf/3tKKV8W0M9/5WrMnLJ2Z8gXtF242gF3NFEZQSwldd67wL+ckFxAqe4MoibZak981RZO6pReB8ptx5bk1MQouzDke/BWgCYn6IvFBTA8E7hHAdlhOWu7S3fAFfIOa86htRbDaZZVuQowD9nZOxeuRXwDwG2yOCZCyZ9BH4Gll5H75Jbw82Ke1RZgbDDAdLvB/4y7+JhF/o9cgkHD9hXdHE4Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> This is potentially useful debugging information and matches the existing
> page offset provided.
> 
> Use the raw __linear_anon_page_index() function so as to always output this
> value regardless of whether the mapping is file-backed or not.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

