Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1310FC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 07:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867046B008A; Wed, 30 Jul 2025 03:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E256B008C; Wed, 30 Jul 2025 03:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B4E6B0092; Wed, 30 Jul 2025 03:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 665426B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:46:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB4575886E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:46:30 +0000 (UTC)
X-FDA: 83720148540.05.2EF9B23
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8F3C980002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:46:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hqbuTHFk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753861588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rw9coQSPDusbh6xlzH1libYuWMCbw8rIDakkSoz4oHQ=;
	b=chZRIGhMtUvkLXv0zK3Ta+WVy5dIXC98OQtBy4twRbC5RbhCfda2p3szuajVDs7QkKUmym
	VQ1y58+hAkvH5krOfrI0Pawxw5HkhbFwA3n9gHHzVSLm+a9ImjFOMJgr39BYYT62+eqiHR
	NzvvK4aRErSZzVqG18++aOwUTlPRd5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753861588; a=rsa-sha256;
	cv=none;
	b=PEiwxZtHWE6YBAyPOiXfVy7wHyDv798EzYWduCNfjoZsS6Ra5cAGgzmQAq5OpzOZgkf75V
	FX6C9IZ2HLTVUEh6EY1JIO/0JTde30GF7kOAGDMwFnloKErRKn/In57gXjxXASoU/nwJPB
	ec10r85XFEhNURQtkoNlXqTHomdvEgU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hqbuTHFk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753861582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Rw9coQSPDusbh6xlzH1libYuWMCbw8rIDakkSoz4oHQ=;
	b=hqbuTHFkY7Wd99fNVDc/QqD83GFNCXqkkwMFpGelhw77OH/bEsQtw/UHzl75K2aJJV94eSgtKY/fQ+k/QuSqZQ6ePnAxyv8XmapXC7+S1CKj/3fLtGARLRi9/3XxFMJgA36IpwmixhfcZetqDkr8NaBc0igUfgenII8Ou85fXPw=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkU-UhV_1753861580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 30 Jul 2025 15:46:20 +0800
Message-ID: <817c59dd-ad54-47f1-ac16-9cb9583308d1@linux.alibaba.com>
Date: Wed, 30 Jul 2025 15:46:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, patryk@kowalczyk.ws,
 ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com,
 joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
 tursulin@ursulin.net, christian.koenig@amd.com, ray.huang@amd.com,
 matthew.auld@intel.com, matthew.brost@intel.com,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
 <ff93c415-7ce8-a331-9568-7543c6a37992@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ff93c415-7ce8-a331-9568-7543c6a37992@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17eukiwkssapc8ya8tjh6uker6s77w5t
X-Rspamd-Queue-Id: 8F3C980002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753861587-844656
X-HE-Meta: U2FsdGVkX19+Uq5DG49PmbITwRVT4qTmCODKZyA2ozwxhYCmxFrNZK4psLIoSo/HxdRVE+ayLKn4V4KN9UKOdOPMKAycgnxtnOlk9aUSTgAHEyu1hZq4FZjDNStwij0I+4CMXKXvP8zW+O97x8qnu9edfTFcRR4so19zTkECb06lw8VleiZCtf9v6YUsGNObI3IDoX+MZqsHuiYXwmRY6xbA0k2Q6GkNorB1T1OiNrFP0XnZdEMg2j9WEX9WA+BbCkW0jpqKYhMEUkLQw5PGQL7PI0O+IARKAlwV1zZ1n9Ab0tE3nWudrmCvr5iZU0bLg0i8vtlOEMW0YRZ0Y2Ez07sqG9O0+1Qxu9fatHR5nG7NjwFSljfyIWib0PcgqNABtZmdIdovpsYvk1okgrGy4P8nTUXHVaspExz8Cr8j99AEzRtdJXbAVCbznuSk+ZwXstNlsGa1mqulnN2EhaN8wWKHLpVWZU9gEHZsNZFPqD2MDHldhv4LdS/kBHoHywMo+DjUOHuAjpI49SFz37VHhWc+QmTP7gclwmamBYHBX+2sWJsgv2Yh9LJSGMA+eM2LT5hzdrxJdNf0KIW4ltVO8biXxlnZhNf2y0/iqBMIvgi6mkUg0nEdBYFvfI5PvdUkK6xVWehEHZqDUSjgduKN0w+DgYyRgYaQPxh4n4uiuZZUaqzmO4WGjgz4sfmc1Z6G5fc9cjgpxzAcwg+B/Z2DzCiPDwBK1JkkAQ+i9gYEZxfpjf/im+vrBA9lNyILGG8KNf0xOtXr+ncB+VrqBuVRBB841yMtu0KdTqqJ++o07t8iB7vHxivUQLE+8t/eciKhyUkVKUYQp9OeDFjHuscglwmc4V6anDRANGmvYVTnpTDowznUdLTn1wnJi/lLSbsa0VAZ2mF+cjbw4tFOH4yHOhwg3EqCgF1bT2EscTNoATQfdfHJn/GXP/RzwpkfBMkOCr5QqgsPmlGCNSOgmBE
 qtucPbJM
 K3BdikKShqQyyXfOgPvMF4cy4T4K2esLwa0ny0Ng1e6GNPo8+/mxH4bePl6FGxeg5xUlVa067H6U+xEExCJM/qpAMH8D8gk4gfQC1OIJllcIB7sLhCeQkxLj2Mqx6oAbpji/fI6ZQtaXmbrBRBQzyXRAEfOb4rwbmjU/ZIzr/k5SuEFORE9Ql10ShV8RJbEBHCoYsXLh+u5loMdfce0YPmy8hhmps9AObIUU07co//9mi22QyPnTA5tGIAycp2eyiK9++FCep59MTknlDcf5vkFwu3EukwtHIxJOK9ZH404qZZclVk42S0RgemzjocPjXUgRjs9f6cuWRMn+SWIYDBBE5ojq7CCezYXQd1zMjbJCApwO6QCOrySu3xi6Xcj2iBKXg11hMtcRCFE1n4rmN+yBoucz80B7dfVF+krhpalSL7C4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/30 14:54, Hugh Dickins wrote:
> On Mon, 28 Jul 2025, Baolin Wang wrote:
> 
>> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
>> we extend the 'huge=' option to allow any sized large folios for tmpfs,
>> which means tmpfs will allow getting a highest order hint based on the size
>> of write() and fallocate() paths, and then will try each allowable large order.
>>
>> However, when the i915 driver allocates shmem memory, it doesn't provide hint
>> information about the size of the large folio to be allocated, resulting in
>> the inability to allocate PMD-sized shmem, which in turn affects GPU performance.
>>
>> To fix this issue, add the 'end' information for shmem_read_folio_gfp()  to help
>> allocate PMD-sized large folios. Additionally, use the maximum allocation chunk
>> (via mapping_max_folio_size()) to determine the size of the large folios to
>> allocate in the i915 driver.
>>
>> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
>> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
>> Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   drivers/gpu/drm/drm_gem.c                 | 2 +-
>>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 7 ++++++-
>>   drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>>   include/linux/shmem_fs.h                  | 4 ++--
>>   mm/shmem.c                                | 7 ++++---
>>   5 files changed, 14 insertions(+), 8 deletions(-)
> 
> I know I said "I shall not object to a temporary workaround to suit the
> i915 driver", but really, I have to question this patch.  Why should any
> change be required at the drivers/gpu/drm end?
> 
> And in drivers/gpu/drm/{i915,v3d} I find they are using huge=within_size:
> I had been complaining about the userspace regression in huge=always,
> and thought it had been changed to behave like huge=within_size,
> but apparently huge=within_size has itself regressed too.

I'm preparing a RFC patch to discuss this.

> Please explain why the below is not a better patch for i915 and v3d
> (but still a temporary workaround, because the root of the within_size
> regression must lie deeper, in the handling of write_end versus i_size).

OK. This looks good to me. Patryk, could you try Hugh's simple patch? 
Thanks.

> ---
>   mm/shmem.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3a5a65b1f41a..c67dfc17a819 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5928,8 +5928,8 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
>   	struct folio *folio;
>   	int error;
>   
> -	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
> -				    gfp, NULL, NULL);
> +	error = shmem_get_folio_gfp(inode, index, i_size_read(inode),
> +				    &folio, SGP_CACHE, gfp, NULL, NULL);
>   	if (error)
>   		return ERR_PTR(error);
>   


