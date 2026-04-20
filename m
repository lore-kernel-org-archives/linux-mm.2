Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DF7F5A8B6
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DCB6B0088; Mon, 20 Apr 2026 15:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83EA36B0089; Mon, 20 Apr 2026 15:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CF36B008A; Mon, 20 Apr 2026 15:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 604D96B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:33:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D991DC34F2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:33:10 +0000 (UTC)
X-FDA: 84679932540.29.D1929A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA0ABC0008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:33:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhOoLovM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776713589; a=rsa-sha256;
	cv=none;
	b=qEa8ulc8rl9tvBDNpRpwGXg5FzhTcfxIG+LlhSSh2HtNfwsC9OhbRllF9yIZedw4fCyaZZ
	+mmCz0t4QTsaGg8ruqlI6Fj113iW+9xecQoiNbxzI5vE9xzEKZoFA1VEUMO7Rv70XXxFI+
	zxzC68nrUMkJMKX0aaUxNZjJjmQ31as=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhOoLovM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776713589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugnlLfdeLCy0m/lqbt6jwIC5NiRsjFcFmWE5Wfa57+4=;
	b=xBdChKOlGlRoZ8Jhhq6YrsfWBokBMNcYf26v1L44KzOXKy6deL3dYZl3+h3ADoYMU1skUn
	kF56KurFpOJcsNgVjG3hfSzm2N4t3PzxCbVkLAPxLD8Rl/OZqgNdp/nYAV/7j8msoFYVMv
	2WofG4EiLB3+KURYTdYSSsgKA507KDs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0BEC40660;
	Mon, 20 Apr 2026 19:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2861EC19425;
	Mon, 20 Apr 2026 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776713587;
	bh=ROHURSFqXEmiO9zYHy02vl5zPWT4sGYhRhuV9GrYv88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GhOoLovMsZtCsOmnmhHkP/J4+H0vf+IXj2J/nxV31EasOGwNROhvhPkOLk+ICpKCG
	 fKSjJSIOtHXGPeUv2RYS9rUwM3eCA8s45Q2Pa+lvY61jGzi2hH6mIAavgB+iiiyqLq
	 uSQBg4qUKWoJ/RMp7w5MMN+7U0caNJoNpYua+b0VU4IXp7qcYsGEjd/DtDc2KOB8gF
	 FnxWl7tLrDNI8x2VbFPhoR0i72oFuDIFeM+Rp/KQde0ORyL7HmkQ9pIQgNNc+17Z5u
	 2jzX0Z09+ey7ic8IFNt1MdxNxd5j8y39dxp6nsYM2tPPm8UIsqiL8WSGEOzfIN/B/W
	 uMKnNAnaM1viw==
Message-ID: <ab6ff538-2829-4308-b805-888e566e33ec@kernel.org>
Date: Mon, 20 Apr 2026 21:33:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
To: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260419174747.10701-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419174747.10701-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: q37w1a9qdghr5aynftdmcnwi5ag1ww9c
X-Rspam-User: 
X-Rspamd-Queue-Id: DA0ABC0008
X-HE-Tag: 1776713588-447372
X-HE-Meta: U2FsdGVkX1+2Xr2Uaq+QW+QvAQ82tSyzuLh4QR8YTuOAwy/PHlcScD0//8lb+zagAVQ/SwRmJ9hAwbrOj49KAddkOC3u/L7qC8BAP4b/Fo6Y+HAaKzD08RRsIyIYv125V8Y/jZCvH8ZxRrXQAokXXdNsbb9QZUNP/C7xSLQbsD1h9B2pal+NzI0FUQMg5+giBqt/jKkEse9VC3TNx3j0hIyd5bZApQJZfQ2t7aa2HM4xvFcDXgtWPJjCj4mgdrR8NQGwyrz8WM/2qFu2P4Zph5OAD5vWFoPETqj0Mr9S8AcKNsnY2rjIsyCgcT6v+59S+nAZq5ye94oXfF/SjhM487usAZy/Quu/+nHQoBxXO/ZhddDNX9ogj+eFIHk1ljhrAtHjjExGmRXdyJkjqC9RASBDtUmU3eAxlViiLDiYKTnJeUcKMXwR8juPbcMHXr/rs2nQPrTFWVvz2tK+F5XJvgESgt142s9p998SLgL1JOT1FZFZwDYof0N2Se61N/MaQNzQ8w6Sw8GOCfRHsOaliNA3yPfXnsFSYVdkT63AnjxnBdRIvMXheDclA0on4C74S/gBPaZSL4V3L/usqLV1RfHxGUXrVgW6d8VIy03WiEVulJomy6VLsNGw+MbxJOEa7AGBEUDK4g9QcqlXCZJfT/7e8HkfZHAGaci6ogiJeyV5BikBpYLp3BmoehaF2yFeV6rQcm9Vqw9YNZ7VXWWIBlXrpO8bKh1zsBQ5q7gpn/n+gjrc1IXJ6sA7HcpVlm0UsG1w8PV2+CXzGuq98s8hNjOBrs4Cj8oeqTO6c3gnwBfoXGYibBIwByzOCYkgtmlOpwtWGaazhzq4TTJuuq7c/vMAERavbKwNZYU8UyrGVjefweJZGiDU+OguwXznL5QCqaMaLqlxcdUamb7AqCpIt0H9vqsxGnrubnYj/p1WWzfmn+UemP0EgfVXOMIC4eXqStUm1bkbKaBnC81jt3e
 HBtHy/ej
 KIb/oXs0CeI/rttXZuvjEwNIfb1ntyTlzI4PsRWj0X/OZeAPZE98g6JsSLvYBNHPJfs6PIljnnOStdq5N4JfwsNu6lKRg7c3p4x/vdzqKmsVgjuLohQqF6mgf12P0EkZap96x4vBHmxLw6Dva2IHCC+FSfmn1b2gWmpXCgQHUNA+KYJ1BrqVQiaDUrcV4EaLzrjUxxddBCEv8IWttaC1DulhQB2aefroXzBWkUiPcvBOZDpd2N3AeMEDvaX7jd21qlm7KRLgkG7CAklhbXHMAsv+iX4ybruqCYAmlAWjC5KvZHi0FzFGU29WXIPyEcs7GO/Bn7ZlygVbsmOVaByjx8HMlEefJrrzYv+UnExZAx+N11QqYdtZGgYCJ/vyMsCsJjQK9PgRcmgSD22CuZxo/oHx4phVxtXfphL3+Tv+SKGGrmnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 19:47, Sunny Patel wrote:
> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
> 
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
> 
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

