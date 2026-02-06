Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E46ECD9B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC8C6B008A; Thu,  5 Feb 2026 21:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F9E6B0092; Thu,  5 Feb 2026 21:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E906B0093; Thu,  5 Feb 2026 21:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 862716B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:36:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AD1A5A859
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:36:16 +0000 (UTC)
X-FDA: 84412467552.28.5E0D9A2
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1F564000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:36:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4aantJR;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770345374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezukT8gf6vSf0QeciExJA8vVhdyq2uEBdV2mhNDadD4=;
	b=xhDh9XdxQaVkD9jNWnWsUtF4zFdBZQkx8lVNzPf5rweV+hDu0iOVu8d0GVmVo0nyKlarRl
	4nQs8MQnUNaJFntIYH4O1uTVcOg/uC4DNjSyAnB/pdbMsctPkIolVjZ7xPVC22DeODdIIL
	JCeuAFbhBHRMbwI5QQ8HdFzudzeJonU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4aantJR;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770345374; a=rsa-sha256;
	cv=none;
	b=R1Vlki/Ttkz+Q3eUNOmB1jlEi+XDan+tR3yOAm45K8/26e5LtGGgaDDgfrS4S9NpeY45Nl
	TDtYuED8MetloiVRgA2wCbfx6FgW4wZqsC7gX2FgNGa6vA+ZNSV/hWU/om1RdNRtt5zb9h
	KmglHzh42yBCHxtf4cg374sJ+yb4vbA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ezukT8gf6vSf0QeciExJA8vVhdyq2uEBdV2mhNDadD4=;
	b=s4aantJRfPssrCTa1yKJyIcOivrhh0gnt+2+HS1+182XHUQoAjcmUsCCwlGCcCW5dna5kD/Tj
	2OdvS7KYVXF41Xxj1VvwJZwa4d2K18QfufeULKIkramvSMwkaTpVYwTto6aT8OKViDrr4q3IBEi
	fiiwQAorO5zkQeydhJ3YdZw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f6dPv742bzKm4s;
	Fri,  6 Feb 2026 10:31:31 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BB32A40562;
	Fri,  6 Feb 2026 10:36:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 10:36:07 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 10:36:06 +0800
Subject: Re: [PATCH v3 1/3] selftests/mm: add memory failure anonymous page
 test
To: Mark Brown <broonie@kernel.org>
CC: <akpm@linux-foundation.org>, <shuah@kernel.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
References: <20260204073331.899406-1-linmiaohe@huawei.com>
 <20260204073331.899406-2-linmiaohe@huawei.com>
 <2028f5e1-e032-4909-8240-15fe0b3c82a5@sirena.org.uk>
 <0a84104a-32e3-8518-ebc0-703814e233d4@huawei.com>
 <73756615-b779-44b1-8ff5-b4b2d5e3c7cf@sirena.org.uk>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <92c543fd-4316-d5dd-451a-a2c668fc98aa@huawei.com>
Date: Fri, 6 Feb 2026 10:36:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <73756615-b779-44b1-8ff5-b4b2d5e3c7cf@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1F564000C
X-Stat-Signature: qngf69zss9g9tx1bwomnx4bxwsawxs64
X-Rspam-User: 
X-HE-Tag: 1770345372-633609
X-HE-Meta: U2FsdGVkX18wWwGCrgXJClgxm2I1/sKCHm9eRVOD2shVA96yiKetY+z28lIVVMXoOx1AFFy+7HIg0gZvyaz9BwUepfLcg3qoNOAmc/ZIOXbPpjnrXBTy/259VhbMQokYi7C2cvFRR6rJcVC9XY26A05AR2AYvjoDay8dUdXk+YuPKgP/SfDNM8ecl9EAuJuAYMvjkF1XDHTbHQ1XUtcKea/RaAoChKeRAdMDF8mggJnmhCeYiOqEO5FPkhc0EMEnn7VdCsuCtAtxZLXz9R77+G7JIDZe62I+DccQrD1+DuMjb7dmInYvGHVse+5jxcxE+rdJYYQAnEr9i/qbXtCOeasdzZ923JGSTVKnXZtMzKOeeyiReVPLbMSuxw7cnILYRGHm7N7lNZ9JUWM0cwI0tqAl+CsUcdglRqMm3BhZtekpywXkyhn4XLwCSEQ+m++Tv7uRY6CSFE7IToejMOesWUW3NGHmGGIIB2pYhNLI8oLvL9Ykgp413bX2n9Tg+bOSvz7HdsrjoaM2DLguM8xmgAudLsZlPsXJnVeHyqiPzNuizfeYdW/KJtlgDd57aJJFoCnUPKP/+odIbbWuCifepnWWdRbpwnEWzIh9fbv4bKd3MTgoPcBaVq5aVZvhFhLDextfdvtIgkXbJNG43Qj19V4hjeTytI9O5DFNqVz72E+gapua+PoamYB2mu78M7JNPvJGuUkF3cWxgkCPMWR3hwo+lKxn1hIpFHOUTYDkcqpc8hGxALJ+YxVUVnzfCewy002QHMycXMy4ImNMFZjeIAVlH5ePCFMFSavZsxI8h+d190S1T/e4xTDq5ZZzqu3kIbSoWU8sq3mUo8RjEdAYvfWVd2TCRsl//95Is+dQ4OtceoYQhR1HlzTmK2zFWgzGm0uQ2g24HoUZs//b+cNuiaoG/O9tDVMS5aW8NBp3z5AEss5h1Hsgtu8fLs7nt1qqM2zeMbrj9dgYzIw9NdG
 e2L9VfHP
 U9dKlVsF5lQJEALkDiWFEvtM/asXKIpUwSC20i2RbTweATW7ExyKaNcBR5xJAZuAXoSQ+rHl7nPPky17qpaQbG6VB8hX6QPlTTQmOG3tzb7bcND/7qdFjPGcs2twDFXzMBCU9l02cD6eVFRGkP0MMbg5QZqc5KRFiCEuM2lEarmzJmMAYKUJDxNGuM1Ilv+ULTD8xZ95nG7EcNPEIK4HQ7bXTyHLmbxmRClV1V8rxsGRS56ATSW2MsYyriSdAcm9pWvPEluIxEz+dw8fty8468O7PLOFNrRI21erhMDLqyExP5pP4M+pF2bd8zpRyDxuqdqEqevMWIisOhv+7GcJASoVbbFxrOazE3vXC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/5 19:28, Mark Brown wrote:
> On Thu, Feb 05, 2026 at 02:58:50PM +0800, Miaohe Lin wrote:
>> On 2026/2/4 19:26, Mark Brown wrote:
> 
>>> In -next I added a hack with wrapper scripts per category to improve the
>>> integration of the mm selftests with the kselftest framework, could you
>>> please wire things up into that, see:
> 
>> Sorry, I missed that. Do you mean adding something like below to run memory-failure test separately?
> 
> Yes, pretty much - I'd keep the list of TEST_PROGS sorted but otherwise
> that's it.

Sounds good to me. Will do.

Thanks.
.


