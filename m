Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DCACCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 09:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795588E000A; Thu,  6 Nov 2025 04:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746298E0002; Thu,  6 Nov 2025 04:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA5D8E000A; Thu,  6 Nov 2025 04:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5378E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 04:36:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9C9D891F6
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:36:40 +0000 (UTC)
X-FDA: 84079677360.15.190AAB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id E13F540008
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:36:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762421798; a=rsa-sha256;
	cv=none;
	b=kk+6eSAbIxH4oNZNTOz8ajam8aCwx6U2hArs35u16SyAVVWefjyne/fa56G/EoClDvqagB
	7ORxAc1UIW4v7s1sh5wHfDKQEHfTyGNmWuRd8Gv952jS9P9fK1s5lliXpl85ODHz0nzIdt
	Tey+VlJ5xw/WjPXFuCyD9WS9YF/qboo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762421798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvZ6kctVmWSwQQWUfbREg2qig/Aj/lLgi/9WzY48IGo=;
	b=1d05yC/rydPLWZonx3LBae+zWKWRKAvIIbfqdMrhibwQkcmfUmIdTHKBoO3W0D09cdF1Yp
	kA5sLPMxdlO6GXKg7aWLMtCMCm2F/bpZiftnXkeb36apgh+bRvxJARUTka5dN1CEJuIMsG
	p6PskdX1QZ4d8BUw0N6fPFoCEei3xI8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE5251595;
	Thu,  6 Nov 2025 01:36:28 -0800 (PST)
Received: from [10.163.73.244] (unknown [10.163.73.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 333AB3F63F;
	Thu,  6 Nov 2025 01:36:33 -0800 (PST)
Message-ID: <2be8882d-08eb-4d7d-a846-d29406858bcc@arm.com>
Date: Thu, 6 Nov 2025 15:06:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: cleanup vma_iter_bulk_alloc
To: Wentao Guan <guanwentao@uniontech.com>, Liam.Howlett@oracle.com
Cc: vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhanjun@uniontech.com, niecheng1@uniontech.com
References: <20251106063424.3381872-1-guanwentao@uniontech.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251106063424.3381872-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E13F540008
X-Rspamd-Server: rspam07
X-Stat-Signature: nxeiotpacuj1gnwcmekpd9ebbpwf773j
X-Rspam-User: 
X-HE-Tag: 1762421797-468344
X-HE-Meta: U2FsdGVkX19lbx1lnJ+kZKHtumgQCoociVaup6eLf5rUls3gLUK/t2a6ELm76vYcti9oIZ5kZrn0T9bsOJ0E81phhS3Hd5GTKskep6/paRE3gbQr2+Scc9SE+a9YAaCCufYjaUpZZzOwFjUEBKIxUTN61Oq2ifaI4T2dgu6lywexoDnyyH5FnLFyKup5UENbjdixi2YaQT6r/Bg7pUiE/HYgP5sxSjvNVB6RF4jrK7/N7xp97Oraa1vh53B6YtFu6o6BRSh989nBseHuCo1Aitxazvl+3L+zGedoG9FwE4vAPKxpqKCHjuhwVv4rVgY6b+k3ucXvejotUO27l6XcRNnEVQLiXaaUtGvfHojsuZPnqYJtOIHDisOFQExsWYyZLhqCiEFdejy5g0qms3jZ0Xee8OZNR+C4l2L9DTMEB5aTU+CfPJp+hbHLtXC4UBgYTLhrvsc8wv+94x8ixK1/5KZuKXsm8OgPFonXEbCdH39NAYE8SYiossRWdZ1/njo7Y+JUYqeqGrBWxnL8y/Jjb6+2WdTHhmm/CMja8mxLaWy4xjyQu+Kg2UsdMXCOcI4/JI4UCOMIZ3s679q8VX3e9ySU4AYm22Uhz0DTgw1oR2hUhVpCxqyar09JfjkHCiDgcwHbWYWJF100blRsGVJ/u4X4LSEija42fJqaBVf8/7RCfhU+RJPi8SnVxMZZ9t0RzGV7m8dNDgnmoOOk5Cdeyo2dajQuJHNQaLuKCD/Jz/6x7KcHQLds28lknLf5tXR01UTvnXtCGu1taX9cyi2buEq9TiURtTyflKuFUpfLLG4HGcKxL6jcy5H23Tk7uYawOciEaqDAgN1bA0Y5CBKpb5Dj9895VQnKuUItAcG79bNbF+E8LsaLYp6kswknWJZpZMOfF3q1R7UEFpFOV2PaJrjEBQNUR1jtgi6YnppbF0ncsShMye0XwAXrPZ2j3OjjkXZnqWb5usUd5YsJyX5
 g8Npt5Gb
 W0WJSTGK/ibaaEmCu5ztkqjhmPZksrgIttzvu+OFiB7MjjmMUev8AvneG8kEFV1/D/339sDuhv4mnNNcnNjojOxRsJajTHXNco3Do1MVZ75Wy36fKtB5Oe8+uKYgDXJSc9Pp0yg9/ZjWoRYmdQK25Z4TOxBGf0x2cG4Hs830RjZIh5GVInrd8Po8/fwIIp0CQpdd8WgbZzFLWwNaaf+qFChctWhrriPVp15tAiSB8NRTuAnqyDFFHCOgHlH8bUFtPSHNjB29wbylJA5Sh3m2s0ra5Y7WN/IQMPWZWc+L5bN6x4eH1Mr0HxJWNBVQQvfe4mtfur5EpHvV0SIQtafJWfVZi7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/11/25 12:04 PM, Wentao Guan wrote:
> commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()"),
> remove the only user and mas_expected_entries has been removed,
> since commit e3852a1213ffc ("maple_tree: Drop bulk insert support").
> 
> No functional change.
> 
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/vma.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/vma.h b/mm/vma.h
> index 9183fe5490090..4aa72c7e94400 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -498,12 +498,6 @@ static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
>  	return vmi->mas.last + 1;
>  }
>  
> -static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
> -				      unsigned long count)
> -{
> -	return mas_expected_entries(&vmi->mas, count);
> -}
> -
>  static inline
>  struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
>  {
> 
> base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2


