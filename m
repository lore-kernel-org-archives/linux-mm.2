Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CF1C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BABA6B018F; Tue, 18 Aug 2026 10:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BB46B0190; Tue, 18 Aug 2026 10:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A77F6B0191; Tue, 18 Aug 2026 10:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5806B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:07:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5C65C0202
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:07:52 +0000 (UTC)
X-FDA: 85114568784.10.23B4887
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1263C80003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:07:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jlQrt93o;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ln7Mczd79sZi5QwsaLE9jqFE0MNCEuo9MspZyFqDHr0=;
	b=N9oFWbTHJDz60fc3IG+Pe7OfzS64Q++/702lA0apDEK5DjB9nUj2tHuXaCkdOx0f3i1wpg
	RoqMMPoEVvvbngd5kR28/Foj0fyVH2Gv1V94G638w4R9Dteg24ury6KFmNqSmUpmacODdD
	vT3G4EwUlnZogpRMeLiKj6t9k+256QM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jlQrt93o;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062071;
	b=jMzycDAeLMCggUSYzLTgNja1tFKxsinssna0t+BAUc1wMc7pVEz/Zy+qCVKT2xG5/8+SXa
	639uXf2CTwtXDI8KBV1wLxsrbkTHCfq9hWCJXp63KY0yZy4FuOdBAon2+whQBjsZeYYatM
	8+vHGX11zGLppkWdPcnirsIf/KkPTO8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44278152B;
	Tue, 18 Aug 2026 07:07:46 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 187C43F85F;
	Tue, 18 Aug 2026 07:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062070; bh=XYnpofG5ApFYBdgBh7eiqhDJLh9ipL/B1jlA8wAAIas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jlQrt93omVnNUGW5AJAWkmrhdAxdJUeYlENyL9uf3jbP9mEjIJbPbVHtQ8AbK/8XQ
	 qBdKSDBteuuzyBA4Km/Yh2uL4pt+s6L1zOxsmN2ydh8aCItQsF1z7h81P3Gf7S8WvB
	 wrjfJAgW8ba8u3QAJm4YaQLsE0ncWlqwcTgwpqOg=
Date: Tue, 18 Aug 2026 15:07:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/18] arm64: Add system_supports_hvo
Message-ID: <aoRnMRZ0jE0ycwcT@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-8-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-8-jthoughton@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1263C80003
X-Stat-Signature: bj4zua5xeamtfzay34gtebe5gpws6rc1
X-Rspam-User: 
X-HE-Tag: 1787062070-291858
X-HE-Meta: U2FsdGVkX1+dMNWrd8u3XaIBwl9akjdGYd7K0k1J0fzwO5s58cLnkB38OYQlFdSdlZR6Gh9CRXuL5VlDnFdmnWTojLfWhgrSO+x6W13vZ0d8ru23Rdl61U7IbUjT8jOAELFLBbrnF3f68239k8f+FJ4mti0QQUFflPUqYVwkYj/7WgXBfNRo5zBUp+enoktWdCwAIxQHsI9bmsu6JGFrMhmDR7U6WjdDQaY4ps5olbs9Pcy8gV1E5vwHpOYAc+zvzUvfys/Cv6QMRqbjtuIVSnn6wCEPy+m9w9Wi8vgRwoeupnvILuBUoqgtEX21x++P1YUyErZTu2lXFLfHj7e/hmHsL5m2KQLHPGAwWDXutGRc2yXqQgDqt9/W95dywNKksuDxq8Ijd4Z2RFZ48cnWLZ0OEV/q5Z0mk+xdblPH457TspgMeZvFb6zVxvk2zveaEKL00KxO0q7WAjNVsov+1WuWIcO8iz0RrRRX1slXrQj61V2Ttowv2Q7Sbvcsb741f6QBGdSLt8dZPytbZP5Z6ymMxiedL77qS3rbFIIUFsOPTQbAp8CFi/zVNGb08kAHj9s9+AKTGIB5BCvoVeo2vLVnJaAiidffyrDYMmfscdeYdbxFDcPuSIfhiQ0B/W1gJjXVCqiEZZE3A6gA36J0BJEEIXsYWUBgbOg/CAhfX6t0M1NsKo3pQSjEQzmsszmvgCYFMWBEoXYA1B9k5Q6g+PBZE/9CigWc43lGfp4skjXHlN4hWjVg/pCFIYiNXpgaJ5hMLtwWy4J0lfyxstRHhx8oB6fo9PRPhf8qqGa+KC0voXLHKqw7tPShJ3IFSJPPq3H8Oa7I9RGjE5g3pEJRQGSlS8TuhzNKYn76sO2iSit4ytTJzwrmGRAXQj8Rv7FVM+KkjRQL4ToMj+IsLjIDHYKZnYmOPXx+2rGfk8dxULvmMsNGCkHZootGx2PrQD63ti2YXKAN281r7DC3UI6
 txtGAMbD
 amW0OunpL8ZJVtBVvgx0sGvwQglUp+VmQxSx8vVpY7EkfvXBk7sEfYsxAuRZGW7wuPsXy4Z1fu4jAsHIT30MGRxaCs+ZQro9verZ+GvIGSmU6l5GgNtR1YuCLhOOaG6cA72Fly6NGVOrQ+inZJnJ/b4IouQlBSO6j9a0qRO97cCBAXdQQnBXdXpuaETheekZKSSaJsplnNWPCQlKE5uSZqG0ShYzlMkvyz4OUH3j97xEasd/4OY3O6l8FlmCbvrbUQi17c9l2taJkIdyV/7+/Ev75dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:17AM +0000, James Houghton wrote:
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 25c61cda901c..6db3ef827f86 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -75,6 +75,8 @@ cpucap_is_possible(const unsigned int cap)
>  		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
>  	case ARM64_HAS_LSUI:
>  		return IS_ENABLED(CONFIG_ARM64_LSUI);
> +	case ARM64_HVO_COMPATIBLE:
> +		return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
>  	}

We shouldn't use HVO, a software feature, as a CPU capability name, even
if it's called HVO_COMPATIBLE. Maybe we can come up with a hardware
related name, e.g. BBM_THROUGH_AF.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9a22df0c5120..3b9224b99a5f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2172,6 +2172,16 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
>  	return cpu_supports_bbml2_noabort();
>  }
>  
> +static bool hvo_compatible(const struct arm64_cpu_capabilities *caps, int scope)
> +{
> +	/*
> +	 * We need BBML2 to support Block -> Table transitions without taking
> +	 * faults, and we need HW AF support to support changing the OA without
> +	 * taking faults.
> +	 */
> +	return cpu_supports_bbml2_noabort() && supports_hw_af(scope);
> +}

I think this is wrong. cpu_supports_bbml2_noabort() only checks the
current CPU while hvo_compatible() will be run once on the sanitised
register values (SCOPE_SYSTEM). I should be something like:

	cpus_have_cap(ARM64_HAS_BBML2_NOABORT) && supports_hw_af(scope)

-- 
Catalin

