Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2647ACCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA528E002B; Thu, 23 Oct 2025 21:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D15B8E0002; Thu, 23 Oct 2025 21:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED728E002B; Thu, 23 Oct 2025 21:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 589708E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:41:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 122BF5D4F7
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:41:08 +0000 (UTC)
X-FDA: 84031304616.28.3B15D75
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50473120005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:41:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPV3slhq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761270066; a=rsa-sha256;
	cv=none;
	b=ScXoO2mFyzRyV1hFC4wbMzBUKAjCNT63Vw83ksAXEo7MnorZy0DxypZq+c3wwcMB2+gpRw
	iBRsFu7575ldiBZYe9DVkEcRC93lH0hWcbuyLQwgwLNz2G8rJgKl9243O2HLLGfLD4VvRq
	VFd2iiEYdZLAFcBhjRyOvAaCs5Bb0fA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPV3slhq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761270066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V8kOqNOsh8UaPdUFo5M/73e9x7UlGg1quQtezT5Kvg=;
	b=VcVcTMnFyRDBah3a6RalCc2Gn2sWzjR/Iuiyluh7IcNq7nV2Lccl0/MPN2t3RJM5ZLkb6M
	o6RFNZtsWQysuq1BeSXkSqn+oAEwjT0oiwhkkmpauENYvqQXHDtkDPyTL4DtUJm588Rr/b
	RcJtcIHp0ibfwRL9CiW9esiUhsNf448=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761270061; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+V8kOqNOsh8UaPdUFo5M/73e9x7UlGg1quQtezT5Kvg=;
	b=bPV3slhqx1O0bfpsIc7jOmF+VWXenuQ2bgeUfzvwnOBiafNTGPtZds5A/sGwdD2NOh8fnR3v9bjBi02HPK/c8mrtVDduZlHImgEDFBr9X6qGFh4GCUGbb74f62j2IxOrnNPWA+uanJgNrpg8E5D9xMg3pAcxbwJ78oVc81LeGQY=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqsXDkv_1761270060 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 09:41:00 +0800
Message-ID: <b746b524-af09-4ab5-858a-0a29f72a0ea7@linux.alibaba.com>
Date: Fri, 24 Oct 2025 09:40:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n6t54r7twx8ns13qcu41eepy3zfi3tgg
X-Rspamd-Queue-Id: 50473120005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761270063-397478
X-HE-Meta: U2FsdGVkX1/xYUmHBGae/s8OorXiHRx9g9Fu7/zLPnbFbkkeVavnz6RhWA7EbdPLuFtg4H5LQJPDDatRumVyU/jm9YrI2j/uBiF0tkvhusRqA3tFo8+kel4R9Cj5pVcrUk3eAKGydkG80Ap4EWBBYdPRjDMHFzxsVHTwv4AwHMkdmS2qx/jPRPyK83Wf20gedcSBogWZgXJuc2X4+hd+EnniRqoUW3hNbHYGe6uHWYl62HkEnc/Rw3m5W2PsJUD7mSnzbgA5t6d2Ru1/P0jdFa2jrXJ1TcyRCgicOrXXgEeitC4ZkowpCZlu8ijy+gbl8I4kwoqdhodwOSXjfILmnPG6AMQwKOEDEoki4+FYKvi82PtV/VV8NWBkkSJHVwb6W1p18y2OP+kKArHpPkaUPkEkUbjB41tQBoUnL/UHWQiqhLCXMcDp58v8ilWmVNqfkBx6FCGciequxxJq7UFVK3g85yTju8dRtS9kvLxnahcTr1eeDFYrgsTJWByTEov3laBpbQJ538cbcWV68Ky21tA2HyYt/MC2LdmR2pW1IQnGrHiACyMQCxBX5NMDQa3M3vMiEX8nrxxgnWPaEbxlnVk0NmfdNH/2KFxSqAVnS2yAnAs0NZFJUoAK/4vl/lJQmE3b3DgRePEPxkYo8ImmMgCTq39xZWk/Wk4wLZ2AtnLKvdFVAg5DXENDZxlzRlDUVn38UUyI6BrpMWrkgX7jxZ6OGoW1MsUaoQd1hun4wEhZUvRPg8jVjHiim6GVy7emSREx2Jtrqi3n/rBvzTJvBknelpmycSiGoX5OsddQ505OWMkkSEA6Tl+6+koLEH5ypqb8iI/MfvGGzYHIphPTjfIPo/GJhxiqn8lC2uTiSSyr3JftWUWbYp00QmCXrymJQSgrldXC2vkZvI8ic9UXrCCNhlNkY2aX/9wa3KoMuWpJpEFNLgF9xYllmT8bV4Qaw42IAGpnUU12dQkA4Lf
 0Pqpc5Uv
 YcS/lZZfF/WmCyQJHYH2PAEcv9jJhy7fPj1AwmxM0+y1uQ+ldieZIeQw0fsXiC7F5m9XGdhkDjjGythVUN+HfJ+iQAU8j+NHG7tNYyFwKXWWXDlk8rh84qt4O/Imp2eWUz1RnZEWfJ5zkuCbCzW0/lgyZd/DoG7ESjO63LNDexFhIrQhPUX+ffFZDhSUxW5HmM9iR3Tsh3/EfSkFIYnmDstBscG3ktmUhdIo5guIutUdH2BpE6Jnb0FEk2MMXNdg4w7iZafA/44Bid6hPGEd8U81ewTJz1Jgsd5ulNT+P4gIy8qxDbv5MeRvo3CkxxamN8m/+c69AaYoWHOZjbgeKdsIqY4RlO//wjeI8wA752RfjZYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/24 02:12, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
> 
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.
> 
> Defaults for shmem and tmpfs were not changed. They are remained the
> same as before: 'never' for both cases. Options 'deny' and 'force' are
> omitted intentionally since these are special values and supposed to be
> used for emergencies or testing and are not expected to be permanent
> ones.

Make sense to me.

> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

With addressing Shakeel's comments:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

