Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5515CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281B08E0014; Mon, 29 Sep 2025 12:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2595C8E0002; Mon, 29 Sep 2025 12:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196968E0014; Mon, 29 Sep 2025 12:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07AFB8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:07:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C4AD140411
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:07:04 +0000 (UTC)
X-FDA: 83942766768.09.B7B4C4B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8354B10000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:07:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759162023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5PguIjE2ioWWqPy0wNHkcIPAludmiNmNCZVWUj/tTv4=;
	b=Dg8nMjlm3doXmPr7jCWE2MhVgk1QozZwJR3aw0dKscBSghYseeYk462zD5SDzpHMP3WAHM
	B/6FM381HGNLQl+6cPveX8L+sgxIMq9ailZiTR8QuLn7Itey1E2BLO/Zz+yE0jMkaKzTUh
	cj8CQ+Gy60V97x5RIiI2jAZHkt+2wOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759162023; a=rsa-sha256;
	cv=none;
	b=I2GFosctmnBqT76Z//A+KwZVMiKxmqupk4tSY9HlaWCzX6mxRcULgdxZs+iZI335W1nvLS
	nUbgs+SZhUT5muERpy/HulKdGSJnXWhjRawOE1LjPCRrMRT2i1Eog3o5HVsjNdApR68Hy4
	vvCmtcAj2aeQzg42dh0tv0YjLXvvVnM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50D06150C;
	Mon, 29 Sep 2025 09:06:53 -0700 (PDT)
Received: from [10.163.64.106] (unknown [10.163.64.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70CCA3F66E;
	Mon, 29 Sep 2025 09:06:58 -0700 (PDT)
Message-ID: <7cd5bbe1-c2df-4bc3-a06f-4565933d543e@arm.com>
Date: Mon, 29 Sep 2025 21:36:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: Drop follow_devmap_pmd() default stub
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250929104643.1100421-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250929104643.1100421-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qbeyrpo4q454bg6kt9cb7i8qyi6f3fuk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8354B10000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759162022-170680
X-HE-Meta: U2FsdGVkX18Y8wxB5jS67wi9eSeTW52jv2CKYpAhqOs3RPIjaXak9gFXMV81tGngSlFOazTsUMR0cA8o7fNgUASZgqGaLaKBuDRB4pCyWzI0yTYEfibthDBFCQ62BRoedkLgxskfN8owCichfEYaVnZEC481FbK75SY4431teeBSmIXnM05IU13OTrLOqnxdozujeJtw2YncG19PLtf2j2Bw+CGQ40AX3lHQXdXY17qJBX51EIw0zPMUNuS8E5FpIHxGfrejV3TQwlkiQt6wfWcSNVstGszGMysM6Wcsbp9Eia4wSV8oIgVvXAzoYV5W+koFqAQMEv+iRcoZZFJ1Za1JaFndJOhz56OjthjyonP3pONg7I1KEIMmCsSagLD9Lt3rhF/BGcRX2FfeXdRtYbYVofinM+5v9yyUGxk0FFiOkUKJQxU3pxGegoyrHfDbWI+wOeNFk6NLcd5M65hoGhhA3LDC7pkAP3WgNRl3A14GZ44e8yhhc+/+ViZ35gsNLLGrlXTgqpMlY7kZ7vO5ruPU3HzjkZ2NqcHLKyf3L+JDG3EKKCXpb8LtTPcuAhc92H3J+ig4WV8hzxnBFZXEPTmRkP0QTn8EUFU+LTkXWRIi0ShMcQZngBw1Fb1LyB4N85l5vkIFUCWktvhRIigT6hilPgBV7+YNub8k3cdBXW8ev0l7WfAzO233C+GWa6+ypzX00IvXlC2v91mf6IVFE9oM9nsskxzE4qYIX5JYY4Iy8zKkV0zj7RyRJdN+T/2TDtEJnqirz53wqYx2kcJOdt5jcW3odKjQgNRKlJztXreJIU3JlKBjOsZhx89+ewPYY/s5fE4TuY+2Z+hKa0w21HWFvu5eZr8wWAEsCchHI9G2sxkQy6LFaULO+ej1ES1nGPJw4umuK0fS4W1TuPppvD4LYsKG2gmYBwa3+syYip9ETttYI4lLv8WARRcWKUnxFrCnebQ6i5ar9cdnsJ0
 S4NG7n6B
 BOlEHtiucLJgX11MNURoLEz/2IdX6Bf9K1jk5ARUs26W1oGQDAnmrF9IQge80nP+IR5pu99ceqnTQOov59Y6i5dZq3lHey51+benRZIVM97Tu86q75uYVQosG2FDPEmpY3tUCW9FB4HZvKSP3xUNMHigyMNLm6wCfRZ6HdmOP/cWR/h1VJ3eR6fZ7mIR6hmu94ygz/W9N+b2FMG3aFkY5EhjAXr0aufXH3ilaKZ//U+TympdZJ6O6NG4U0Jt9cpGQeUSKKpBjNAu2DoG04Knrq2xxcJtgdGEJQLmjD5XQXGbwhcnMn/d2cb4dz3WRKX/YgR7HPZDHOexHfK7Bdw1uHKjNqH929WAgX+BuuaBrAYYyYogea9QLSnp2HvZok1NuGVVjGQP0HD6+n6h7S/2LFhgzYhDflBs771Ob4Hhi0YTNAx8w4Cff2k4w8qHWHUxn0IR/POCN4wdsmAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/09/25 4:16 pm, Anshuman Khandual wrote:
> follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
> ("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
> stub in the header which is now redundant, can be dropped off as well.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


