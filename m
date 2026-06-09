Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD9ECD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840166B0005; Tue,  9 Jun 2026 03:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0B06B0088; Tue,  9 Jun 2026 03:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7066C6B008A; Tue,  9 Jun 2026 03:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63E576B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:58:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D5F91204AD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:58:19 +0000 (UTC)
X-FDA: 84859621518.20.D168383
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12D7110000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:58:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=neXony9Q;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZW27Z0cG5ZBxv+2DhR3no8vztYQbkpn9oxsBKpw1oU=;
	b=5oC7iCwSZE/NMrKRxeTuOqEFhzpttB7XcQ0KnomrN5MqnyN97WahjjgbKgTZBuFfvNsOmV
	VHgMhe7jyZtEdGCNj/fqLA0YMrePwDi2r+DKDWdVvLB2Q6Ii+cWeW6PntzZX/PPyfoMpbh
	A9fJYoZquzDXFawHgysyO2s/Pj+itw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991897;
	b=AcygRZWPINpc9w0dccY9Rb8bNm6S6apKgDkHIMJI18Ug72/Jso+y5l/BPkIkoYwqt/V9/H
	i3yUeGszQsgYLGP6E54dDnd0142OSSpHumEPCw0rXSknRbjPF2oiDQkpR0FYnQr8FerCyL
	XMp3SOde2tP85R7vMv8qFz0xZ5DaNkM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=neXony9Q;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aZW27Z0cG5ZBxv+2DhR3no8vztYQbkpn9oxsBKpw1oU=;
	b=neXony9QCUc1tse0odsjp7be85xjmajBOkbHWEkkmavuVuUTUb5tf1zrE2TlNpkIaLDj8LeEX
	wC9dtZwjGcb+Avq4dCXAGUsaIKrs62aMIaLXnxiaeFz+I1Efoh1t72/I7nrI7zL6GoESbeQXANz
	+u1mwXlQ4+DUOXVVHfox6JM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gZLft36s7zLlvJ;
	Tue,  9 Jun 2026 15:50:14 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 99E7B402AB;
	Tue,  9 Jun 2026 15:58:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:58:02 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:58:00 +0800
Subject: Re: [PATCH v4 3/7] mm: shmem: Update shmem handler to the MF_DELAYED
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
 <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <a87da745-4310-d5cd-3562-384b12a55a35@huawei.com>
Date: Tue, 9 Jun 2026 15:58:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 12D7110000E
X-Rspam-User: 
X-Stat-Signature: bj15f1u8iacib1ck3jmibju1od5pk3k3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780991895-737301
X-HE-Meta: U2FsdGVkX1+CwWY0A0XJfqSPJF8zs/hGKUAwDMfH1SZm04nngz6GXi/tgAruFWPIwAC0A5q5rHRYySjRjWQ4EHVHpmUp+IrrV01WKOdRpnBc7WyjOuQqHAMYdgExNhxp8uXJDkTgXZ0Ay91TpkGcPkMmvuDRbNXzmT/ekwEHSa7rqrEbWcStfoyRk5GwQhP7E984KWREotj+XiwVmD9MSxQi1SrtvSKbIfCX/+iH1JH5mig6gUd57eWzmzwF7bQ6+Y5cgJQphIRG1iB0UereYc1foSPwrrbY8dl+NnJSLtcnTu36RMRvO5lpn3eu2hzuoMdJaY0JVWgfpVB3QTWOrc65ksoOJZ9ICfU1wJsFBFCFBGfmSrBD+lFNRjGq4WXmm8pnnv3idnBuSgfCLUAMZLOmTbYlBSg3g7fOkE+ZCJmLIwZ830GMgAQFSRVVEjrOCbVL8OuoONHQeJwY6uMpy2zS0fpTYWXESWonkWLAp4TQ01A5BJOBs1j+klCwj6NCx+LwG1LW6gES+5mT6jjhKAdfLDC+bQgjzPW6s2opdp3EGjSumSxoMz1k4HV0SF5nD9a6X7mQ5cm+FLgfpic498Q/BxSpU8CB62t8UxVQyhLl5/R18R6RvibwERE/ppfw0grLgpG4EFbyxUw0ggkuUhT7JKWmTlfBE/WuRgotI3HiHU9U9ZJv8o1dhvZvHsj4b7SL+/vxaLi8VebHe1eOLBR2Aff4kq1xAblOyoZh/iw0KDt9g75L1SDsKfZDr9aZyNHkPxZ0Y22vW/BxTL/Q4ouxtNtpZODm6qE3hLrbfkYLo+ZifXzp6/fEpieV5gW/Jd3VPnPpJAiMI3pWm3hq9FPj2QoFLeshPzHq9+74i0JnHcfT47msTm/3Fpkqb6CPd+iFpM1SQ355DoN0hE0f+lR0fCeAf/G81h/dJnZ5/daZdxekxF5Ps8+KyPf3xKnFjJ7mQiCVC+lokAitiDx
 cGXjSopl
 vNjQsjE6U9JeopJJtwHJM1hwbdh8q0F3A1wBJNv5m1ZzZArsz3ZM8G4GHnB52PKPi0LZWdRoFVVrkEdUybVq0E86TsY1U8LRE+cyjqPKFsX0E2DbzhGk7ZcNC/pxc+PyuT3bcdCQWf10U/aAQgjEwNLbUiMNpp78xgi23n0JhHX5y+syD4Q5J6m3FGJQh1MzR/AO2TUU6MfL8cgUYEgsaKXllYvJKbo/vscFba/DG0cZ7C++cyKn6bzv4h3+0Q1rGGWTJunqIHaxFxpBO+kqC+qUhuFq9qE2onaMR/a7VD1zfi8yF1qFdbrVaYaxSQxd3D6J3flzfcYDD//wEKMS5pm28bICvV0NRPa3ct95jMKYEbC5jcc9V0pMyafDUJdXxGzBDRt7BDg8UE8FaDPuK1LNYncMQUNA3PiBzTCTb4m1BZln1CVAMLHI0lNJ390VylQcI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/3 5:55, Lisa Wang wrote:
> To align with the definition of MF_DELAYED, update
> shmem_error_remove_folio() to return MF_DELAYED.
> 
> shmem handles memory failures but defers the actual file truncation. The
> function's return value should therefore be MF_DELAYED to accurately
> reflect the state.
> 
> Currently, this logical error does not cause a bug, because:
> 
> - For shmem folios, folio->private is not set.
> - As a result, filemap_release_folio() is a no-op and returns true.
> - This, in turn, causes truncate_error_folio() to incorrectly return
>   MF_RECOVERED.
> - The caller then treats MF_RECOVERED as a success condition, masking the
>   issue.
> 
> The previous patch relays MF_DELAYED to the caller of
> truncate_error_folio() before any logging, so returning MF_DELAYED from
> shmem_error_remove_folio() will retain the original behavior of not
> adding any logs.
> 
> The return value of truncate_error_folio() is consumed in action_result(),
> which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
> also returns the same thing after this change.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

