Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390E7FCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6906B009B; Fri,  6 Mar 2026 11:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7E76B009E; Fri,  6 Mar 2026 11:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA926B00A1; Fri,  6 Mar 2026 11:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1EA6B009B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:05:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F1FABA5A6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:05:21 +0000 (UTC)
X-FDA: 84516112842.05.CA1246E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10D4C100018
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:05:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJoQ2bvj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGI8hDv4KErIrKVrQXRYLcKUw1ZI2f6KMRRIbIJLUyg=;
	b=ny1BIxoOn77fxj1SaC4ozw9D4HwhvqSgcsgtUEEL+6Ceruaf89X+T5HxxceOE8kKbJ9vVY
	JMOu/T7q9z0JvDy45TPK0Q+G0YZcg74PvzLcT1Q7g6UrDD1YAKOEeXZtZ6e4Qq+DsN0XFx
	J5w1ZehQFHeuuhlsRwUvfQZ8LPPDM4o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJoQ2bvj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813119; a=rsa-sha256;
	cv=none;
	b=lImBaIPA0OJRjy3JdjhtYkun1hAYmtJPN7TtApVDVm6xBLu1T57Jo8VjQ5qEokxBKK4tKw
	O7xh9xeJyAFtqwyv8QSCvRz6kreXorcJL39yucg7nQquCZ6h98LKd+7hJbPr76BoYZ6oyt
	i8KUW0npQlM38pi0wOI83yUJVBCB39U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A63B40547;
	Fri,  6 Mar 2026 16:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D320C4CEF7;
	Fri,  6 Mar 2026 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772813117;
	bh=TLRROmrsKI9S3nwfOkVUtHkXt6pvD2xr1+JIGTbR0qA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bJoQ2bvjxsIEpf4N/uM2reVOaClEKLQf6PDTK2nLQDlmHRDqimLETOChu2W31xBbx
	 GApqfvO2XPzidk7ZfppUfpORlqHcBvATNMnUYvsWDEPeAaeHxvKXqkYZTfR3k5yeLV
	 zWUyMmSUwhpmjnQ8kW/Sdn7ZqnlkpDshjThoMSCEACc/h94tOlJIbMhq04/eaFB5rw
	 nI3nXE7f0kfL2b2g5O5GI1Lzm4pKmjuWPxFlcfajMe53Jpu1z4/MeEjmOe+l5ueo+N
	 OqvnE/xehbo+kLBhr6Ea0wtvdH/0xTc2N7yWfvFqIgOMZ1KWqk5Y/68aNM9DykCBTV
	 WsANCqZvIUYcg==
Message-ID: <fa4d1fb6-8433-40c2-bd52-5e358a103035@kernel.org>
Date: Fri, 6 Mar 2026 17:05:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/13] mm/hmm: Add flag to track device private pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-13-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-13-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 10D4C100018
X-Stat-Signature: yh9nnjdu5u7qfj59tzq5ukfa9f5affrf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772813118-354011
X-HE-Meta: U2FsdGVkX1+UaJGnqGWCoiPWpcznRxLVJcEZ/Wqp3X9ZpiONPmKoeOcCuoyuOYl/icHLyMzBiNqbDNwhLcdvQjSeSB/gSLOstNMlQesVJcicFMxvAch/R3GOneIr6yVuJfNiKeI/cu/ioxaQtJph12YRQQT1G80Vo6BTJtu/RzmwZ624nXTrqT9S7C3ANmms3XJgWzUas5QdMS6Vg/O7LSoKpHTOag6rjLMJ3JqSS1XoYm1uQmMkZPaMl05rh18yhszB50ON+wddB2619pgE1ppsRQvOHCf2QC4J9XD/2GZPF+GqKJaqcY1jUiOMny5sAFqNF1A1K1QbGu6B2X6oi8Fz9uOu4YNqU+Js52x/5YU4jFAXnl1OlMCGnrRYHGrsG1I+v99yV873DyxPfXrv+jppC+6HbdA4dpHg4SYR210ua1ID7zBVh6b3106DPYBoSJ3eyspC8s3Au677lNpONtRqDqqV2lWXnIhu/nex4/MWGl+D8fIZ58J1xBQsGGFI2cRRTmZ9SbOCYvR0IFe73g0WotSQjE0gHklsURdpoTCCh9bqQWgUBB/We2tClahot+I/EGs9gXOAVRsZaIZVtbMWWaEaLVguSKxvgLycGEw5TIpFlalEcccuH5uzfIgMMUxd2a0iM60e+nZT3QCz4RdA1myHHlrlnFD8n4ShsosFqFze6iMiO2a5OdwaRkf4NBRnp7T5zo26kaZX6zx3oh3H4FDCthcJ4ectxW9+X0l5RF/CLkDg45wfTHdziCIxAK6Ri4epOvQn7C+qR6uw8IiesieYpNts5/98d4o6TosInfPluru6HNcnhrzG8zXKrQ7rACKd2nwmaTIY1UAfMtdmD3xqUpVc3jXbQ87FXRTfvEPIIasEfBGsG08kWCwUPyF1OrKtiAWJP9RNrrXeV72YsljqvYbsdVm62eAjR95TdIhshwKLRmAY1oFSl7freJuzwSQOKHNg8zPfuD5
 oN3zwq1a
 m0UYgSQWdY6FyV27CLVf2Rrmg4LnE+Hwte/0uSXmnkq/3YzA04ILYGfxMMI5uWaKF6MNP2NgV5M3mGgHXjmSx9QGDIXuBTRqCjceBWdhWbjZD9jpes+xblPNfHxx2mPzAmQrHd8OPfeEa/W0NBQLGJfv4CIYyxCrgWhdJ2Ow6vFFcPHIwnqMMD/KFZwSL/lqvp+3dA9ecivGsHWALnvUXEfN/rmHz4EyOD9zw0nhOnN9BmTJrK5hhlV/KKJAPBDXbeJ27glKFk2gbbuhaxdBc4wM7Es9cWycBMgvCDtWRr+qX3Db5pSEZaw3xCsKIHxGnGTh7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal pfns and must be handled separately.
> 
> Prepare for this by adding a HMM_PFN_DEVICE_PRIVATE flag to indicate
> that a hmm_pfn contains a PFN for a device private page.
> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

That makes sense to me.

-- 
Cheers,

David

