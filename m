Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6FBCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016886B0095; Tue,  9 Jun 2026 03:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09DD6B0096; Tue,  9 Jun 2026 03:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8736B0098; Tue,  9 Jun 2026 03:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA71B6B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:45:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94EA91C205D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:45:39 +0000 (UTC)
X-FDA: 84859589598.22.D789F51
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30C37180006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:45:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ir0xcoM2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktNotGT5JK3I/QKLXmHwe1WwS3X3UN7pBsbxz+Du+Ho=;
	b=I5CyMnAbR62uTQ7n6XuLQl4j1pZy9ndiNhk33FzEyxt+4/y7bL5Iwpev3b0zoSb4WMxuwn
	Wli+H5EGYclMLlHsIVFaKI612QsbBP+j2iz22mRkK3saRcKUb54ZhYX4NPE178jGnYEEB/
	CE6iQYD+aGIWTD59VzXinDaXiAoiUQ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ir0xcoM2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991137;
	b=N8TlpWRdccQYV/n5OAep5aZlrWewFHT8rXAdoQK7lQg6BGmOF1pQ5BBlOha2g8/SJoQfSq
	FBDVOY2ZMgmoG4zJYa8d/Oepptgs4SEtGpCB/Xm/gGMtpMLsR1UHKFDuU74GtQsTcg8wCr
	vaZD2/f1llVq58e/ixy0xZAkRxGErkE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ktNotGT5JK3I/QKLXmHwe1WwS3X3UN7pBsbxz+Du+Ho=;
	b=ir0xcoM2vUj6JNmJbu+CcwVzu3LZqtzPzJp/pM+t2wzqE0wKOoCeyP3lyYi3Boy3N4bDXvc6x
	dPbx4PndL6ZdmZsxeg4IGgGNKjDFs8FrQKZxExEg87ArBAy9l3W/obldyebACkFqnGmLxtINLwf
	3iQAE9vH2qgPmIqc6x0uilI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gZLNK6bxfz12LD1;
	Tue,  9 Jun 2026 15:37:37 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E05440561;
	Tue,  9 Jun 2026 15:45:30 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:45:30 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:45:28 +0800
Subject: Re: [PATCH v4 1/7] mm: memory_failure: Clarify the MF_DELAYED
 definition
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6ed7e4e9-6256-4348-235a-e5b4bf132f57@huawei.com>
Date: Tue, 9 Jun 2026 15:45:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yod1dmuf11iwexp1x9reqb8t4kefetaz
X-Rspamd-Queue-Id: 30C37180006
X-HE-Tag: 1780991136-673924
X-HE-Meta: U2FsdGVkX1+28UMOrg6sWSYbuIZXaEg1s8dan2OX8Dv7F71PRSo9mxeDpg+pUt4yUXmYqrF9VTTi1xUswFRo3W6ZmQteZgJJA7BlBKyzbgcL7KYm+I25s7FKdzb0Gwb52DdKGIINvGumAUTVpOiOmFbOtA1r1pwYYA10/aos2nqa0yZnPmQf2/tNTl1LY7TqGx4rejqkzHe3mkbSV5foQKoz33SuS9NUvUlpT1HwRqfo0q/qGlYI7JaCybHPG109afxBywjXiRPIcqD9Bf2ti/GQabktkvW1bEAK66wNRKq+SQygjYbXRYTmu1cQ6eu+b1tp/U97Ed8wNuo6l0U64DRz/i/bj+F4ebAnXizx8y/DdRMCwfU18Pc7fXFSr5UQwnGfCnmEQa63NThP1Z1hkYRkW7K/q9V6xox1KnJg1NOYTYuROyvWMgEFbsh/h5TD4pzzusHTHJB8xuarS2hn2m/B440IjL2HYvM0+DpcQIkloIvDd1xpFXE9tyw5hjTYsXBSR3Hj9/01OzjqaTI+GQQ2u0ABWpqii3/TKkBcQj9UfYkHUJaUwSyQrRxU71YJ+lMcQluHQf6eoPFpQr9KMMtLA99eQtntzDzjbUfjYchcGry6PD14/+1RmwO+bmFRW3Y59cQB5Dk7Fva1qOFW8RNAA+YnPpPiOfaw9+QiJGAg5am/uapIDvD+VIY2m0Mn55VRQfLzV64/L8s8dr8pA4jXkBFpvK2oLDfJjU227tn1ajPwgfxa+3EURds/j3LuU0/Fu4AL0bZtfakdZ4Jr+3b3nmEmthRI6Mfags16US5LpK+9LCMDTRfJURQUfuFLZOFicJduZvPLthy7Y66E48hpxfhMaKhGOGqhLlnJjOX9PvnvhMxoSzzJedLoWbzwKJWogPRdCxS359IxeofNX5x8TR9MfhXjnVk2u6W0f7bczkBhAb3drAUYXTFyySOOjcSVZO5CZBUVkXn6kJ/
 O652hCi2
 eRNUuPm9kW6bbHiKI3g4BAcawS07YV9rM4Fm+QtbOmhnemghiqmiuKOOx89pS+a7F7HZvrBSIl5fl5lcNrRkAHMByfejz6fHZj8jOH6sunL58Rr5xrvZzwwngGWxVeVvWEN00ewCRw4UeZYi7GzlaFbvYnUthYXeIgztMxCUediEW0XEvuZlf3Tr+z910ihRvVA7m5JDlhRPVen1cYR66OLPHAo0fCvS76UYvx1Q+t+nHr6BE9wjPfi4aipmBIV9h54Y+0by4g72FtLXBlwntVIqywQp9O5PzjFN77oSgUkGkfiFKKpfcUjYEybdDGEZuTciYQLMOCG9pOSShiaFhQm2+6aAOlYVduvKtHcNA7HGbaHIwmbEUG4sEqhpTzMiGtE3lqatCnEXgpOKbtm6wDzNfxZlwy/vti0oioQdZY1tELXhUkiQORUgv3B270TDhlVQN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/3 5:55, Lisa Wang wrote:
> This patch clarifies the definition of MF_DELAYED to represent cases
> where a folio's removal is initiated but not immediately completed
> (e.g., due to remaining metadata references).
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

