Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A23CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6C56B018D; Tue, 18 Aug 2026 10:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5580A6B018E; Tue, 18 Aug 2026 10:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4942C6B018F; Tue, 18 Aug 2026 10:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27CB66B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:07:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DEB68028C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:07:35 +0000 (UTC)
X-FDA: 85114568070.15.8CE4935
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED086A0016
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:07:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="B/ow6Zp0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc14/yx8KFIXbhoySniAcr559uW1aJdvBMPXJmtA6xA=;
	b=XOD/LtLDlEq0rY4IB6ldWUcDFbJSc6ibSYVhLe8Rjapid3ISFNpVL2euglhNDS2nCHhgJG
	bS5UMq1OF3iR2zj7BjQ/eaDR9soie/Xldsx7xGKX+BWaJBW2xhk8spJ13492Ao0CQBKijd
	zgGNQa5nb15nj86WaIJNodKqqoQwBd8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="B/ow6Zp0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062053;
	b=JnnlDBWUzAiLZ5WcF2SxuunuX1sdsZ7/rtjphD6YwDo38y1SX074SZtBUpjinFA58uV47U
	q72donfeGCV/3QH1spglHKRTeNUpi4K1qHsaxyL3tjzzKN7rRPyj7cOOoBmU5pLcKLXd6b
	kEPKoo/DpwOF443juO99A2y18eHlWeE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F16B8152B;
	Tue, 18 Aug 2026 07:07:27 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 632493F85F;
	Tue, 18 Aug 2026 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062051; bh=0sqtwohSLIumibqmsfO/JhI8IBhQB0YsriVnfH2MrIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B/ow6Zp02cKG2P76++iFsGJ6k7yaOTQOK8xrZVon85fmjZmVhaZ9NQtGZ4qPZTEoX
	 JfwIGa8hvFIOJUJzvFjegNEft6us5fqSsEqGAmPLWl0YDshdw7drqJuLSgzgUxTd5P
	 x6LK1qC9ES5qugkoUL869bbTO1dgdzB1eXoGqCds=
Date: Tue, 18 Aug 2026 15:07:26 +0100
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
Subject: Re: [PATCH 03/18] hugetlb_vmemmap: Leave pages partially HVOed upon
 restore failure
Message-ID: <aoRnHjaQ9Y61OB5Q@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-4-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-4-jthoughton@google.com>
X-Rspamd-Queue-Id: ED086A0016
X-Stat-Signature: cpc1si3c59rdzugdz8bzsyk3dyupybxa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787062052-679664
X-HE-Meta: U2FsdGVkX1+yAUBPJhaay7oM1g8uheUbGA1WURizaNT0GehHIa8J5oKcqvtYZLai6qVP8XVkPq8sC+FiBW4g5/19q4Ifngy9THyV4eu73pimDOA2Mzxzvz+avjBqFTcZKBkLRyXTAwqzOeYg2J9GHaTYIMQ1iO2ubACbFpU5zr1fpzHbwd4CKZMtnn/+NYrYtQ5dlKYGS5Mb4YzQGgd4s7VRH5Yi6pJtLmWFNNejmgEiYvuuMurcmRjewCAJHSvIjXb2S0/2w+okNMvIlxdPVwkJpGUF9/VdxhNo/6zVddbgPI3BEIS/36mvtiihLTtnZSX3KnK0LHZSaE+9HQeSIi4R6JJJEG4V0kysav9jKjNijT/FiaPZCW0iV74nzYlNvtj2e8s/EQnCpO8GqFIiGv4uXvXUxbJchYhOlt1Yjgnu5qpwzHKwxyrEwCXU6b+85dvsb0l3mQx3GxVYCTp+HoxTQgm7YaO9pcu34OZQ3pHYmVshwfgBSC9Ih2CM/qhlVvj/NEPUcYOaUYaqW4RYaFUB5ws7k1Q0x2uJOujYTV49j9YQkHrvOcsxKyqIhN4282vjhhXCB0Sy9pUmp7gzpAOg4jmyqtW/wy9lRHKcguMXZihzHSsgz/QAH00/yytLBXe9GWxNv2uf1eblJ0ahg1KoRIOzzP6nuScxs3XfXXyzsaDlVJZV0qxjMBSKByL7zu6ykAXQj3rUMoOmdOlGnEBo0rikw2Akvzif5wBYh7Lmuy6nxximFamtesJJHx9W6X9BLOPllX2qnsecybwnyi6TFxlZ8jzRLQx6PWYmU8B/9dq5H+mXYbNNHmVCSvo28mZVCf1IfPUhpAbXvAkhntVc+bWeAX4iKHrbn5BdOaMW+ojcvPNaKvJbe4eri4d8IKPJFDPPcoQJVlNVeVIC4NXsfUPrXvfzgFJ1NYYXTLLWHob5A90SbbStDljWw8ZKWC+3cZLJ2YZ+AChh+1S
 6r7nGZot
 e2haHK+bSHK59tSBVyYU2oYq1jOz8DCk1gG6W1bZcna+gMEe4iLcq8bVMVmAEP2pU/+w8TPPx0wqiIVXkX+l5Z01i0VhinQCVwAkMvVRZ4HZyGumep3V5aqHAmvXGrGH582Cidf99HvYrSOarRS0tSkj5FnfBgfYCx4Kx5DCr7N9tCpHEluMrE/PGIIYNgfL0cx/dE0ILMj/EB0No0w8yOWblfKqmdGfwBpP9/+lxEEdpVjQG1nbwkFd/Kip11KOs/ZtXN/345LfzcE6LwJrWSpouNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:13AM +0000, James Houghton wrote:
> +static const int VMEMMAP_REMAP_INCOMPLETE = 1;

Nitpick: I get it's all within a file but a static const int feels a bit
weird. I'd use an enum or #define.

-- 
Catalin

