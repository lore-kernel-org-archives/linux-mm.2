Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAE0D2ED0A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA606B0092; Wed,  1 Apr 2026 10:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2BC6B0093; Wed,  1 Apr 2026 10:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8416B0095; Wed,  1 Apr 2026 10:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF166B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:07:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0FA11A08ED
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:07:01 +0000 (UTC)
X-FDA: 84610163442.11.4A1685E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2426440018
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:06:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U61ulmMY;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052420; a=rsa-sha256;
	cv=none;
	b=zn9P7+5ehN12PiQ7T/b/fnwI2590y6v9h54uWx8y8LHoMO+ZmpvTVOIvkptteBF12SpU08
	7a/vV5N2iTL4boayHY5hFK7ZU2FCZ0KclFfGYkFq5wX88I6iC978WXV0SqwJ2DBBqj5ASQ
	oXVzEenrq38nNbe9oC3BBVRg69FLs64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Kx55uf0D7Gc53sbqvgS2TKfdci9DeXpth9CJGILJ5k=;
	b=dI1WdkfISjJAJsedZClP75mdf4I+uRN/JLfuVyuk8XbMsF+NbGS5IH1CNsk1t8Hf0jULdE
	G02wiChNr8yaUCsfV8+7MCXMSa159XoXhn3QpRulXs2BBRzV+THNeYu4IExZuapvgK8EBI
	NvSS09L/ajt2MGntRqZ3ZjGJ0zNCkfY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U61ulmMY;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED3BE405D5;
	Wed,  1 Apr 2026 14:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E5FC4CEF7;
	Wed,  1 Apr 2026 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775052418;
	bh=GCQU01a5ZNsuOCEJYuG5sSvpFncIhytdteUSQSLtuig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U61ulmMYXO/Yxw0dI+GfTeGBv3vu/sR2an67Crxc3iRUCR8cQLH+y1P0zuQot2jbJ
	 71RWDV9K+xygQo5j2djepYA2QGko7NLMwLUaCOiBzpbJKOdz9tcaZdq75lQO1/BRqo
	 tsuVxCIwA748CsNNZZPWkZqi/Zxs88VP5BABlslc+UpF5wbqSDH4adQNPfNPgUyqCi
	 2dUVJH8d4shCVNmVeGYRDOYtAQudo+Z5b4EBMzedTMoTphcqByUw7S/O1JUpMAbG19
	 OpsW9K4XJBhdosrhTJCKhB6bA15+agZ/07fGKRvbkVDAFqux4pahx7Uk7MXV8/J0Hm
	 N2x+Lo1QPCj4A==
Message-ID: <fcead016-04a2-46f7-b667-c8feeaec9a13@kernel.org>
Date: Wed, 1 Apr 2026 16:06:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] selftests/mm: fix hugetlb pathname construction
 in hugetlb_reparenting_test.sh
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <05459b5038595a3a673507e707402839cdcc2955.1774591179.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <05459b5038595a3a673507e707402839cdcc2955.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2426440018
X-Stat-Signature: dc67x1ec59w46arp5ib9i4184qxiy9w4
X-HE-Tag: 1775052419-577268
X-HE-Meta: U2FsdGVkX19laTnXxopcqxN1jjDGe0hsmxGCvddrUPslXuZcUr0I1IrsxGupIIBBfpGxo4NTV6AYzWCDpTGaXb3VZ4Es8iVx+o6j0KGAHG+O+YUP5UpIQXYJvuwOeWyq3ZolLF4uuAZMolHnn46bpIIod9N3hWSeqLTzxWQAQPg7mO3h1yw7eAqKYotYXiMMZYU6wFvqq18ji0xLQIZdy7PEK7WQuOywSFkUJyD5GqjbuU/JnAgNAAfcjSA6wMmE0D2oEuojELd+u23ZQfx6W5o+AxYR03i3WjeaoDhfhSUN17HRnOVjlcQWh0ME72jA90k4oDB8L9r+KkITOjyh7+SLb40BV7O9p19Yq6A8Lbk+Hrbmh1ihUQgBCnhkS1vRldelWTKFg0uEbRRwNOOiP8iAt6EALT5OdNJtGWbewcUKKgjJ4CQhmVF+sbxrbEr0HX8pfwOxfm4C31EoWZZmBRzilWuBpIpdmyOR7FdC9xIpB2zZtfUqjQMLczcoakx+VGYQMtuFLukoy18RV0Hf2K7gJgDHc+g0EDizOnEVulVzhVleew0gDvpiNJtFqs/vefr/aWo61zWiU0b+zOxIkSRMmZw5ou11DHig5vyVFr6o1fe3kpNpVoVyA7gL1NiwTkElDHM7xVm/RfoKqhaVuniNdhORqxpJNWg2XrH55CrG0iWZscFPAmeksxE0XuBZjbNbs7JeleSMQ/QGd8ie2j1/Oqx4ciFhTi27y+JksB6iG0KQn8rkqT7UdJRXC7OJPbZfk1IRzM1IT9KUC4bTFLycCBfG4o4+v7Z9G4KuyMYmt4DreoDpHkmrnfYOOOntkGmVGx1r/w3UiGQEK4hLUxI3+ttxTc/3fno6+rtOiKk2NhP1F817keVdMdO9ZFuG/2PWu7wgIl+lCfyAfEqSQaZ4/bJZ4ip/VIH3rzNHpkltbPHMWKwqVao5djc4yhOk3jLO74Fi0PlOKpyuxe4
 l41Iq0tX
 Urzky9zBKpu3jwhkBKPjaUv07ELEpBlaUo1EmAi4ELfSzv/8TSifsA2aAkpCOOByPiKpBG7FGEm7+PoARp0Fr8Z3ZisGkz6tI9Bm3mzoFfiRWAgFyUfmIYGPqfwLyc9WypdTShXo0zKCv8upIZD3QAr7wOiP7zJA1CmHly5M3Yl5VRqvnGi/WJ8oaqMi+pPKKnTlfWhcVlu/2Z2nMItKtJOhWyW+jxpTLc1FeR7A290K/7tK301kc4TgbKbN0uL8V2Z+JfI2WDOndGugy+YRUgF/wvqNyeHt5SYo3QAtikLJ1htn6626j8CfaZinKYIhntB6OLxLUoYstK7zTCcqLPi8sA9jMiYvHplroiQpxEOWHkHVHjex2lo4ho12MTNBd1vMOiwQCvramBt8GEm0GAB6ABuTUf/j2mu0weHmMapG8wNad60hrA9NHbUG9NEkZnk37
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:15, Sayali Patil wrote:
> The hugetlb_reparenting_test.sh script constructs hugetlb cgroup
> memory interface file names based on the configured huge page size. The
> script formats the size only in MB units, which causes mismatches on
> systems using larger huge pages where the kernel exposes normalized
> units (e.g. "1GB" instead of "1024MB").
> 
> As a result, the test fails to locate the corresponding cgroup files
> when 1GB huge pages are configured.
> 
> Update the script to detect the huge page size and select the
> appropriate unit (MB or GB) so that the constructed paths match the
> kernel's hugetlb controller naming.
> 
> Also print an explicit "Fail" message when a test failure occurs to
> improve result visibility.
> 
> Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

