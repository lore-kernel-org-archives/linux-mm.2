Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB67CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CF68E0006; Mon, 10 Nov 2025 22:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4B98E0002; Mon, 10 Nov 2025 22:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21F08E0006; Mon, 10 Nov 2025 22:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AED0A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:32:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B303C036E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:32:38 +0000 (UTC)
X-FDA: 84096903996.16.49A6963
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78F1910000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:32:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Y29WQPrTSkpTj3SKqRFM3WLmAj4B1iW9lDWtA8TdjA=;
	b=QGofFgXYLjqYoJCFYDHeBmtPvg0Uqv0sgugg4Y/bCws+jwep2hFehRjZ1by9x7Pk/wtVRG
	TQ12gPAOXXvLXctkMrtbAeeHlroWr2uSn14dNQ05CEcgSyDtqB1PsnjEcxGhbeCAW0rWvL
	yknlh5MwxangnXwTG9UIue0De6oMTms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831956; a=rsa-sha256;
	cv=none;
	b=u8+p5Z88EIdC61cTlv8sit/eYvdKwPdGU0Aj5BcmmVo/Qws+/HctbeEJkz/g3+9YmoQHnm
	Z/dR4jSQQRyES//0kgaK2h6J2i4fepFP9sHyZFGOnUAeOTOOcdyiIwEq0JkZLftxiUkww0
	BGxAt4ETLsahVcUYIKEaHwqelizITXg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A909A2F;
	Mon, 10 Nov 2025 19:32:27 -0800 (PST)
Received: from [10.163.74.35] (unknown [10.163.74.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A62AF3F63F;
	Mon, 10 Nov 2025 19:32:31 -0800 (PST)
Message-ID: <cd05f470-b9ef-4fe7-840a-221dafbb886f@arm.com>
Date: Tue, 11 Nov 2025 09:02:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdesc: Derive from the compound head in page_ptdesc()
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, vishal.moola@gmail.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
References: <20251110063725.3118037-1-anshuman.khandual@arm.com>
 <aRHq4OdBCtC_V0eS@casper.infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aRHq4OdBCtC_V0eS@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 78F1910000B
X-Stat-Signature: rtcnjr5i8km1bna1rt1fpa5zreh5xu1e
X-HE-Tag: 1762831956-931783
X-HE-Meta: U2FsdGVkX1/REd2p0dJ6s29MpQc+nZKtc9ESlexHj44Pzhx4v2cEBs9Oy0HkuaoTwE9Ug6Lw8wi7T6JK72/QA2Vh2bGjcuP0tub+7IlSWcvXc3YYmRvCc7/L6ZmReq65yhK5WovgX7eAm7N2rcVcvQx3wi+Z0ILsnILNHgDbH65IRpoBVAONMQ8wNYfOGrJAauKhqe/1308ZkXMQKGNNlxUw3kZkXCsNJcn059sf55043pHQ7I5ZkaS22R+kc7g/xNNzoVOExhE76YSVtfF0k1P/U0SmWRayPpT7aV6RpTvb7IfiRRAjPKXB+YMCkM8PEGYrXhzCU9h5wxphX+/DBPID/3DBj8cXSVSlho2pBtKYzZ+KHxYE3wF+FMmD2S4bgbAGfP7ZpDyU+TqzplhdjZxPqE9B4MmvE9gY31NHyxgjFJOgrcWyaOE6UGFifxSbpq6o7AhwVRL+wYKvTlemtvefrwwpMvQj79dfw7MjJ3IyRAN14qojpuFjljLox5Cet0GJt6dSLCse7PWsXLUuHD709DCdwlQtME43MKk84P8XG/NbfizrXb5c5RrQPK+HdScXeznUoL7TZkZoGNsU/ePZ1BLzCBvtj3CNQvRg7RghEgcvQB36YHhJWtX/8MTM292MWC7ZqjLaNBRTJCVyDbnu9UNB1ZYMeOvCZNr23f+4XqdEef4QTqb+OCPzDXBH7rJBqtNGzy4ESTpEN7NhYSEJV/yiY0dkjUmuL1NJIG9zhbE754cobHxP4T7uMgFq5srR+kklVLmwaQ5uFRrLfDNq6lA9Pe8oYZJvzgkR+iql4NoVo8X5ubjO1ei2RUYyAU1Kd531B6uhzWwSnrlG0QRaJ3IAB/OMYfiQYt20wNdR/2ga/LwOUXjegIi9kJbUJ13g4ykqYG4MtlWrtmL0//qDVNEfenThBOyuU8+jle0MbpFheLXEdtlIXYvM96BW2Zc3r0V++MXx3YgT7dk
 kgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/11/25 7:08 PM, Matthew Wilcox wrote:
> On Mon, Nov 10, 2025 at 06:37:25AM +0000, Anshuman Khandual wrote:
>> struct ptdesc (including all relevant helpers) support multi order compound
>> pages. But page_ptdesc() coverts given page into its own ptdesc rather than
>> deriving from its compound head as would have been expected otherwise. Just
>> change the macro to fetch the struct ptdesc from the compound head instead,
>> so that the same struct ptdesc is reached from all tail pages.
> 
> Please review
> https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/
> instead.

Sure, will do. Thanks for the pointer.

