Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F579606A335
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5VSZ0Eu
Received: by kanga.kvack.org (Postfix)
	id 59FA06B05BD; Sat,  7 Nov 2026 14:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E276B05C4; Sat,  7 Nov 2026 14:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DF96B05C5; Sat,  7 Nov 2026 14:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFC56B05BD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:50:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70704A7F8E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:50:06 +0000 (UTC)
X-FDA: 85409364012.06.2A4009E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AB8B2C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:50:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5VSZ0Eu;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794081004;
	b=aDcUtHP9hZhp4wI+16U1uvAF/2rS4y1yZLzg3eTkbNSmdWJF+ShLhN6gE1mUUaMXc1+OWE
	nhlQYtR88qcKOm9CJNSphCvmdO19/dZFbFs98l7HwdZMKZQsK14Xwy/EU7voLvXGAUGx4s
	ygJmJVYuEgLaFyvFMOR3FxaCNJ79RO0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5VSZ0Eu;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794081004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJlOV9BBt4UR6jgbVIiAcYdmTN/stgIBQ5MMHSHMERg=;
	b=mN+fXRF7j1Y75enEl0M9zAgD67OADTNk5O5aicrHY4v7T27Lo5fvI5X/SAvTfsusO2uU8R
	au9e3pJXJSumWsVRN5MEV6KMC1hguRAGA8obMxPjM4lSahiVDlE7hT+z+mgtyECFNdbeYW
	YV+punprlIPZsaBIm7eIKousNIUE+1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7ED140F33;
	Sat,  7 Nov 2026 19:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2250C1F008A1;
	Sat,  7 Nov 2026 19:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081003;
	bh=SJlOV9BBt4UR6jgbVIiAcYdmTN/stgIBQ5MMHSHMERg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I5VSZ0Eu8fHazgOSE6oZODYfX0H4ZqLHG7+cbCIGbNBhsoCRwFXHcUvpl8SuhIvCH
	 QOyRrMyzx83kKD1sT3B2U6KmEnH2yex6XzTp/60nF687YJhfWaDGdj/7z2XrE1Ni0c
	 al7qijHGR1hCtSJ5Kj/8fjo0wviH009lm6nZPds0Hd/bYI07s2aRwMw4hT6Ogzvbdc
	 2O1+O7jpePVCDzjdIQG33uNX0x3513HM6f9au5rdHEs8PDLNQ8LHzIm8jnipBaRIOV
	 Qq5Ghcd4xgrKVdi4AzCFDAI5qmuh1cYnw+P4JZM5AynzTVzes/MIyfxlRgdXgFR9C/
	 +30zo3cl/sc1A==
Message-ID: <21ac345b-1b34-4df5-8dd2-6c57912c661a@kernel.org>
Date: Sat, 7 Nov 2026 20:49:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/ksm: align smart scan skips with the scan
 number
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
 <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB8B2C0004
X-Stat-Signature: mrw1bddx3oxmut4wo9fpbtmhti1kdhh8
X-Rspam-User: 
X-HE-Tag: 1794081004-525038
X-HE-Meta: U2FsdGVkX19U8wkR57GVS/yThsXGfY5O9oZEv7xfGSScWUC5rmU3Xx7ZUQJ5RRgkATLPAnrQTEkvR6w1lxxDEeh65kuezdQUFdNVKIYU7+5XvqjnsQyCzeA14tbrW9jBJzWb7s0fSaXQtTlNejqzSpvCXwIg68cPoaLttF0fHFfQhKNGASO8d8wxJcr3X4v6Hap7ZuYomOU5LjLFyeSLa7OKLqLfN4nrmHDahDaFivC5/mFDE6I5fAbGpTJKahfL1S5YarMvoVhL0HApjqVdvgz6smXBl0dxZFb3lJoVPhiLqoWvYGHGL04UImp3xWrHZcrdy27YQp60X4h8jPzhdfPRlHwt6nCAkuzQDH8oQUEHcPXuDgZm1ZKDeUvgGLtf0ZCA8om9Xn/b6kjXWuvIICyh98nTUaTlkyWkx5z7mhlJuGloflQOlOnaia7dax68sgmP1owb2SYX0dL+xcRbfB+TpR8uGdz7ymp8J5RVsPysPq+pbnKGUF8JfnGULib7jZEOmuaNUVcXSj/hdZtR12nh3y/aEVTx1ysDSDLL+xWl6zPihHghZCy2GV34xeaUXIz4YJRkYtnRulya7tGhwDh7T+GOpNpFn3BmG3Kf4rn5nuCcCIQJ5OYWc9h+uApvanStBaDwZ7cdXUH07booYK9jZvt5Cdk2BeFCTpbLpwbY365TQ1JVcoRgFairNxPyFYDJ0FmJDrfqFghzNzhuhpV34TgZHJ0mJRc8Sl3jsy/AsBxtuBsNdgbx3286VkL5inZ5ysTtBtXFtNpKFZ+v/K5lWETo8BFHRxwJhQXWANHx4GUQ+BEDXHZ7eJv/6iDzGUTJCYCOFDq8bQwS6cpCW0+uZyqrI/ZGJ/a8bf9hmClZlAh/qpErOusmTlFWoETy8SoLKEEDxNTNF5rBVcOI0vtoERSSCkyitaqzpuXd+gl5yfw1aqFCSXLOjRHedfRQS/Retq0ZDFMEM7AgzPX
 CHRbjq5M
 85+3eaQGmSOQhjt+cD0KwxNLKb4EHWx79eARmUX3VJ+WMxPaGRfAPFN01oT11jAlQvjZpCs+OCmCEWD668xL+p46zo8eH7B++nNGZnUxsD6p7/Nz3l/zxs82KkGh90VdGnh+SE/hIt4pHysgEZEeB0/XXAuPfe/1uVEr437+9khiNcZJZH+sX3gMYtBL6HtkMjp2WoRBoKEikHT+WhfAaiIDSHQwf5SV8Eu3aimL1x/5Mjyf8r6mo3hqzQxw3kDbL7cIvEuuLLoN/tL6RQiAo4NGK20gagqkLqCywqgmogooSYb/TVpwoRso18ImcsOniCPX1bPw6lSh8EbiCKEf724gSHovk2LJ1Ycw308DLJ+eOnkguixU59zRK2UKtALZfzC9E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 17:57, Qiliang Yuan wrote:
> Smart scan skips pages that KSM has failed to de-duplicate for a while.
> Once a page is three scans old, its rmap_item counts down its own number
> of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
> at every ninth scan.
> 
> The unstable tree is rebuilt on every scan, so two identical pages that
> are not in the stable tree yet can only be merged in a scan that looks
> at both. Each countdown runs from when its own page became mergeable, so
> two pages that became mergeable at different times end up on different
> phases and, once both are old, may never be looked at in the same scan
> again. They then stay unmerged for as long as they live. The pairs below
> are counted by making a page mergeable, waiting for 0 to 20 full scans
> before doing the same with an identical page, 20 times for each wait,
> and checking the pair after another 64 full scans, on two boots per
> kernel.
> 
> Pick the skipped scans by the global scan number instead, with periods
> of 2, 4 and 8 scans. The periods being powers of two, every old page is
> looked at on each scan that is a multiple of 8, whatever its age, so any
> two pages meet at least every eighth scan. The longest period goes from
> nine scans to eight, so ksmd looks at more of the pages that never
> merge. The rest of the table is measured on 64M of such pages, median of
> five runs of 256 scans on each of three boots per kernel, CPU time from
> schedstat:
> 
>                               before     after      after/before
>   pairs merged (of 420)       361        420        116%
>                               334        420        126%
>   pages looked at per scan    1792       2048       114%
>   ksmd CPU time per scan      6.30 ms    6.88 ms    109%
>                               6.40 ms    6.96 ms    109%
>                               6.15 ms    6.88 ms    112%
> 
> Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Reviewed-by: Xu Xin <xu.xin@linux.dev>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

