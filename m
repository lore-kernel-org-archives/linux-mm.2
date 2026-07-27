Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3607AC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C066B00A3; Mon, 27 Jul 2026 13:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222BF6B00A6; Mon, 27 Jul 2026 13:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA4D6B00A7; Mon, 27 Jul 2026 13:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B3A6B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:06:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 54C061C00A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:06:12 +0000 (UTC)
X-FDA: 85035184584.23.FF68A94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2639160009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:06:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwaW8kzk;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKL24PhADa9GtuDCOccijgP9TvV/abeJZYcT3vmRMBY=;
	b=hj3ZHNRsXHzLubGdJPckjgZyyN7KHSqxdskwJNl4f8sFOp3EbssgRbp2F0IBd/qK4m8Trf
	HEErMTk79+OO9KdwbEEDZMn8zM3of6yYxph73f0MoP+8uuktOTZS8S+/niE2lFfmFPVLOR
	D+qtH19W0qAXCokkmKIuJyot5FYPLiE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785171970;
	b=JZsPKoz19i6L1J8SXbnyoUqZ3AhD6JKY4WFW8KZeqJD+NSyg96Z/VGnVR8282C9q/FoWxZ
	Qxpry/z/o051wr2rBYBa/eQF7Y/Jm4aWsQ/SH06Pu37AwEq9BXlDNDVKMcMi3Nch70q/99
	3qPUkEkusfN/H5CnwKMipts65F+9yP8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwaW8kzk;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785171969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKL24PhADa9GtuDCOccijgP9TvV/abeJZYcT3vmRMBY=;
	b=DwaW8kzkDh9Rurqde2v1OUdkBgFIKiy0cZZj+8I/8qcoGtiZCGSmFSVxzUcR9aDqYps82f
	hbVXIr/wdZyu6NeKo0X/jCp7paz4wKoKCq1E72y17TpeeglaqrKC18XiCBHsB1ympe21Uk
	wot3OvVVAmujrUKJLUnVzZJBvbJDO18=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-nwfZ-kYPNP2EDY5Devj2fg-1; Mon, 27 Jul 2026 13:06:08 -0400
X-MC-Unique: nwfZ-kYPNP2EDY5Devj2fg-1
X-Mimecast-MFC-AGG-ID: nwfZ-kYPNP2EDY5Devj2fg_1785171967
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8ea75996387so68915416d6.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171967; x=1785776767;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NKL24PhADa9GtuDCOccijgP9TvV/abeJZYcT3vmRMBY=;
        b=CUxwqE93IqrDtNS3bpVn91wErmbMiRb0Otg+o4Uu+7hETBapibW8Y8eSKlTBlhXnwK
         T3BcULxczrplcLKtHyyAjFv8elY08W8QvtW+TA5SMQ6XVcz0MBWbCYzzJXuZzU7iptua
         oDjGPEL76biDIcuGksiR2Tum0A4mpzt6BhJe4w9oPrKMhidkimo8QZ3tSO9ru0PdYwqq
         xfbb/s7bpmG8o1AsLqpXqwjj/jABZcTz4EXuS0IB+hPDGIEGm0KEjd3y1B1jNiIcQTlG
         CnhWUzodyb/+ssSOKUAg9U6grOqw8ljTFnvjpCwJazDyDqa5h8/2/tBQ71Fl/QEHnJO5
         BE9Q==
X-Forwarded-Encrypted: i=1; AHgh+RoGz/RZKxQnHMBQX0ty96RgLBrlEXJvrtKOGmu+nslRUStWGBwCapNS4aaVcUOHuoy70QSERineXQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1Z/DSgi7RlkU3iVvP/yfb++LrxgbFOuyMkb8A6KLwPsRL+0nM
	3Eyj1CW8qWIB9lvAlsMLUhqqJWwBg6UE/DYqUjYF88U0QVwWgMvd3kbNI3AyKZVfx7LDofkg3q3
	uuWdqDKrPIF8XnlCoif9aQdWgEgyFKTaclJXdRMiD7peCy7WwrDrZ
X-Gm-Gg: AR+sD115mhzGhfwdOAUaooHeu4DX5GyETrBhgSzhfNsgjO9dsJq2x77WiQUV/+TMAqa
	1kmKE0RC46tNsgaHfBcec4fX+ZYDejMDU88lBRBRLE8ozhDDdB+QXROSLnH+vL4aine7KZ9Qc76
	fylpSx/h43HTLvVgKzu6mIXE1L15JQLwVacvmjIjQmUo+PmVC+o33GzoXJ39BjWF42JHUB8xFMV
	VXVnK0YEoiFHylpf1ZTcs6z90SvdU5pBVEKMEE1iXqHB//6ajU2G/9uDfk9snr1+CE8x/z1nDbt
	VibJpZzfBMmy3GNXKunod8733JiZas0kI3eVGmt/fRbOlLoQL9KTot+SPoxa6iQIPPOkqtRDbBC
	y
X-Received: by 2002:a05:620a:640e:b0:92b:6805:918a with SMTP id af79cd13be357-932fe3c05cemr5220585a.66.1785171967348;
        Mon, 27 Jul 2026 10:06:07 -0700 (PDT)
X-Received: by 2002:a05:620a:640e:b0:92b:6805:918a with SMTP id af79cd13be357-932fe3c05cemr5213285a.66.1785171966822;
        Mon, 27 Jul 2026 10:06:06 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.81.60])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de63239bsm653238685a.30.2026.07.27.10.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 10:06:06 -0700 (PDT)
Message-ID: <cab6b125-f028-4d71-8500-5f7a6b9ab646@redhat.com>
Date: Mon, 27 Jul 2026 13:06:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/14] s390: move has_transparent_hugepage() out of THP
 guard
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org, dev.jain@arm.com
References: <cover.1784856856.git.luizcap@redhat.com>
 <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
 <a0be91ef-7e19-475f-ad0c-0f0bd14d3f1d-agordeev@linux.ibm.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <a0be91ef-7e19-475f-ad0c-0f0bd14d3f1d-agordeev@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9MMDAHcsR54pouiFo2hHSimWO5exDY4zrJcM_iG4exo_1785171967
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2639160009
X-Stat-Signature: tugn9rfw7k936wn1rg5bnfxahqnkwohs
X-HE-Tag: 1785171969-634590
X-HE-Meta: U2FsdGVkX1+j0dxvQOs9bvxqQqUqva7DvYsoMpkf5midOppMsbBXFmhh9oCA3QBxL9NV2SvAgScK1G1tuVa5wsd2Df99nV+//O/12vtVGsKyjnaKmV3nll3bjsIWb0WiHmCWfzU772i4+/kgKHJPvPfG13TD/piWA71h/Ugng5lsslE5YJ+AD7YBIvQS97NaLBRKSym3Y00284RIMabtDv6wKm26ED4d3k0rgfnExycRbOYcOzpOEarp7pgzT+Au/IQF05bMHIkxiUENCwil9enq+WzP0iUFnptsBjTf+tWCk+Dsu/2tvucCUWNw/WkSbtC2ED7/iH8+D+BQC0iBY932zljLOvA9QqNtPlyVY47yrT5UJp/MnIJy+CtqWS6LVJ4YTXCGFtufBD4z/j0Y9cNkGun/YKvB3CPfjHjZXVCrWGUhAIPf+jGB0NNs7e4rKnvlFcOzlgsW1l98VQ+DOOQ9NAzfygzpJ8SgutA3MTTKdI88WTflf9sJC8QxWpGk3MKJK/KOpL7p/aDPkqRUFg+0uVdw0PQ5qlBJ7uSe6xN/zz31MyshonrMQMsXKGtlYxAr9aUk7Mmokq85rEKjExkRgVAkctYEYWyCojookvvrreUPq2QFFzyzRURF7WLjzrKkSWBfXb0Og6JlaBsMVpu8aCU+JzBfTaJ/shMKeNpS7ADUy/l8X/Mm9WGotCXLsdZJwOUJlFPYijIshxkdW8EMj43bqz6rLn8MvzC/hFvxMFoEm5VCU4HUV3gKZ8gz9BEcdauVQl8SYDLUOxP+Eqh1pkaZTX6/T4wYCJNgBMiAI0fEJ6jlXMDN8RlRiFAKSw70Km0A+zRUkLx8E1yQJ1HMVWcaQl5jQrg6SUSZmZJXMCcGbm0Vfpta/z6T2Iu+oRLJhYOiA799KfzqL8o22RQs6cAyQesCjGf95G6wjuOFaIDjm+ylVhq4WhWwA/ZnIHYYrvQEyd0jVc/ba8f
 X1idK7uk
 4s2erFgp53AzD+R4d2vF0WgaLgpIfdlx3M2Fb3L8iyri+UACAx2UUfbcK4maEK2423eJYt1qusXQjlLElAD69nursQWhXPBYHuzebl9Snom3gELH0oPRPL1MIzIVxZpI1urTINep2gVqMljPfJTQUJysVx90OItPqHfEPlXFPVKrls/1ES45mBkaZczhKh2gHxmpALtnnrRQ0K/u9/VR21pXzRapadEc/W4yDQqJbZ7hNw5FpSXk/3TBcReWeskPEeuyI6rZDpZRXgDSW8Yys9msojZNzTIifVMHZnTvL9UWXHPECSrh0KmsJfjoN0suqzKIJirFqo/bnJURwfLuj718pWUrEG956gPh2/codSK9O7VN6UnpCo8Z7X6vwt2awzCGXJOQfjCGqfbfZLKR4qoesKfJyAnf3N7my
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-27 11:41, Alexander Gordeev wrote:
> On Thu, Jul 23, 2026 at 09:34:12PM -0400, Luiz Capitulino wrote:
>> has_transparent_hugepage() definition is guarded by
>> CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
>                                     ^^^^^^^^^^^^^^
> What need? The commit message needs to be self-sufficient or
> at least explain why that it is a pre-requisite.

This series is adding a new API, based on has_transparent_hugepage(), to
check if a CPU supports PMD-sized pages. The new API is orthogonal to
THP and must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

> 
>> CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   arch/s390/include/asm/pgtable.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Thanks!
> 


