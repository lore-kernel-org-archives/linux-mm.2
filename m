Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF670E9A779
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2226B0005; Tue, 24 Mar 2026 08:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62486B0088; Tue, 24 Mar 2026 08:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F1A6B0089; Tue, 24 Mar 2026 08:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8C76B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:36:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BF0613CFCA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:36:46 +0000 (UTC)
X-FDA: 84580905612.09.4F964A1
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABA7720008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:36:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W8qWhQFB;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774355804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsbBTSXyjpjhQEZuCSqVwoWgeHUnKm4qEkYJLH/MHak=;
	b=pQMBufTJZnXPzn2sO35pUCwMRe8T4IJTvdWCVnLP8dH8RxlLs+W6jG5GXrHxOSRJZeL/0e
	ydQ3Au3gQhzd8d/cePXe7xsWZwKcNEUmt/yN/RivQ34pbg5Q129BeLKPmJEv7kcVPNOxRe
	2FntTtBjaW90pC+XllqinSZMclPQqMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774355804; a=rsa-sha256;
	cv=none;
	b=m16oXD4ludVZmfjfgUntzhd/sRIBGz0tMQZ/BTmFkfbTStpJyS+c7sqG3i/+YQmmKTpn+3
	tx0+DmP8P1FrfL/oIB3Cf66yJqWZBVw5P4hnfLl51EiHo8kXF8uf2vQtOJPtqDkwowaf0Q
	HJ6zkzAv9UYy0/Djsvb7IjY2xgxZBqk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W8qWhQFB;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774355799; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gsbBTSXyjpjhQEZuCSqVwoWgeHUnKm4qEkYJLH/MHak=;
	b=W8qWhQFB3hB4MQueuAre0jwk2hStSFwdVRWO66uQTzZFPLPceOs0ePpbyKDG9t/j5A75FRBz1EmBeGwm18tVYct/n5+cO/9WM+T1aZ8nnVq+VKBv3Ob+WFZDF/p7WtHz+In2RXhV/+wGXL5rnYKPfRmavuidUEaIhQan05zDH8Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0X.eWiee_1774355796;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.eWiee_1774355796 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 20:36:37 +0800
Message-ID: <52c26e05-5bbc-4f63-84bf-c4879a6de7d1@linux.alibaba.com>
Date: Tue, 24 Mar 2026 20:36:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
To: Lisa Wang <wyihan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, rientjes@google.com, seanjc@google.com,
 ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com,
 jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
 <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
 <acHeLL0l948jRchK@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acHeLL0l948jRchK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABA7720008
X-Stat-Signature: xisbcq88wa6u5jxmuqktqn6onmu5oj4t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774355802-591799
X-HE-Meta: U2FsdGVkX1/ZvZbTW6IL7PhWEANA7E7uenKU2szL1UFVXUcY5vkym0wqW0b4HIcmwBG58l9erACrzKTNZrZgp4Jcj24j8lzUvryt4lwS715rNKlStJMe/b145IOAAdJcWdYhPgX75RyWrPh/wYMsdJ/XJu/hEyLHHMwQJE1OiPk90Ud+qzDPcwfnY+u+pqppUIkKDdQkasuQ9XQ7njuhnqKNNEHP+z6YafCdgLNdBgjgSdO4QWBWuguGLKMgLszLoh6nfuL91jKfeVPUHC+OyYYaNzT6b75+n3x9MnB3mS4MA+G0Ax3sP6PfKe+fyC7uw89fluzvuKcWp5LTE5tg5DrnLfp3GwRIoAPDejYQ6RSF/7B+CoCjR+1YBEtlTtWZq6edzKXQo05iPH9Mk4MxxYzapQ06KYj1znwKzMCD35qVPGQf204nGk5fQKNbU9PPttxffL/B/EAhRmlUKs/mO200pqzftxcvcreLk89Tv/ebWKgSJHBi34UCoNosWZqfVPxnwv+cuwC8n1DxmkX+RV/XAxjc9E5RC5/CT3/vcC9Y8jMoPtV//gMEYM6fVY4FAdi7uHrBRSRokz29gt/+194uuJ4ssW0anNzdkl+AX1dY3ugEFwCwtUmnZhneXnXbS8b+sdRejR9IqEIm3kYbgA4+VbfoQ+QklXv9MwRfgLubcxQagaAtYfFPBPM3JonPznukkefSUe7bkykUupzJclyyuXa5jdqNHqobmfdrEeeWysgv6KcW/WYDQr6FB+nRZ6xuD69GuIkkm8A9AP2LID+zEPnI2BwYy1nR6wRmBdpNdhRYPtUxm8k0lwug4yuVnMAuU9udNKBmfIZh3uN7qBDdA+z/CePpSkANXusyXDR261Fj4CKdDnJPX7M6e3OMfmBrge9fHiGM2Gab+RLVe1S/LmZh1XCfyyPg/84ntIjV4gqHFdWDGVO0bUqbLt37CvzqJEzL/NfU8PYFzVD
 4XNcpHRn
 Fdy/+Dis4GTzM5PPovyLAt/cbXDfH+7aZ7jIrFp0jT5W3wZVSmiZc5Ro5nbsVcmSKIFjQreLvxStSCm7thnjGT5XB4gX86LVCmlYUEpCSXPJWarW48NzWH/cpOOT4qK62z+Eqdb32o2pjVSe3LYYI1E5A91Dirjiezfqy/VfU/fNgE0VTrWUl6ciF8RtomD+p0UhZKQH5W1uMJLu0kgt4W5sqiDOAOQlGrXO+PKEMOnl05fPRul550fo+O8cn1sfYm2pjfKA2EPGMKlW5SvDhYTcuwCCnOiIo6bd64cP5wSDOx8SWdz13zWjxRhT+AoWbrukNspwkb8dqodZqlGbaB4gi9K+j1NXJ3tzNTxSZMeijVoZQQjDEYD2ry4YMMKKZSc5rNPCcAS1YYb9Enk2ORMojlWhx/Urf4Vakmy2DdWBKRbKc1dQJyTQo8VuEPrCqYFXaRbsQdADW3kI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/26 8:43 AM, Lisa Wang wrote:
> On Sat, Mar 21, 2026 at 02:30:04PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/20/26 7:30 AM, Lisa Wang wrote:
>>> Add a shmem memory failure selftest to test the shmem memory failure is
>>> correct after modifying shmem return value.
>>>
>>> Test that
>>> + madvise() call returns 0 at the first time
>>> + trigger a SIGBUS when the poisoned shmem page is fault-in again.
>>>
>>> Signed-off-by: Lisa Wang <wyihan@google.com>
>>> ---
>>
>> Why not move the shmem memory failure test into memory-failure.c?
> 
> Do you mean let memory-failure.c kernel code check by itself?
> The reason I write the selftest instead of combining in memory-failure.c
> is because
> + do not need extra checking code in kernel code
> + make it easier to trace the entire execution flow, starting from the
>    madvise() down through shmem_error_remove_folio() and into the
>    truncate_error_folio() logic.
> 
> Pleas let me know if I've missed something. Thanks!

That's not quite what I meant. I mean, since there is already a 
memory-failure.c in mm selftests (see [1]), I think we should move the 
shmem memory failure test cases into that file.

[1] 
https://lore.kernel.org/all/20260206031639.2707102-1-linmiaohe@huawei.com/T/#m18e62ccb3e87316ec37dcde9389c1ba1c56d0951

