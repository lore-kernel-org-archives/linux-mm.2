Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3290FF364BA
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 21:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7486B0088; Thu,  9 Apr 2026 17:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378626B0089; Thu,  9 Apr 2026 17:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DAC6B008A; Thu,  9 Apr 2026 17:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 192386B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:19:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A46E139AAF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:19:29 +0000 (UTC)
X-FDA: 84640283658.09.7E281E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 48915100010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:19:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J4zk6i1m;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J4zk6i1m;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775769567; a=rsa-sha256;
	cv=none;
	b=Xv9qSgCMWcIsRK9MqJdzQLNmHYXahipUTRXCyzd158xFu18+Wrn8UCmrF13TLImQCFJ2GA
	hvZSysU69HNXlrY2TkBy7vY3G67vbBmOlJYVnVuXo1Ra+VMIKUoZ0wKvbvg+0iXErUD2AE
	mzWZiooSJsI4hdlCTJFI2b5smg/Lhm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775769567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIUt9WlgOJJqFjCvH2t68LmJqvUmIIgnA/Q8Mpi6SV0=;
	b=R4cy9DeWb1/YaDz2zIBUtyzhQYgPYy0TeuT8Si5ZEWvZ6A1psdKNUOD3X8SdGbCE3FI8zp
	hqCzxzeFri1Ki25dLI82zGO8Dtm8HvSNnrFeBkwfzZLatVId8gUDM+VCHqnzwNiaK/zzIe
	cD78EFI7hJt9vbqDLiuTMs2Gvrxm+c4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775769566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIUt9WlgOJJqFjCvH2t68LmJqvUmIIgnA/Q8Mpi6SV0=;
	b=J4zk6i1mLiH5vgtEfsOuNPn4JJp9zprbrhnbUgguVtDIVPCE5yRHtVdssvcIWLYGodiYV/
	wlmiQFgP0G4voHFzLd613H42K007TiicDH1BG/9QwM7U/oobBJt4oS3dRj3i6e6ChCb6B7
	nSqkjyFvm+7Dgoiz8RX+6o83EQ0WOdA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-glVyxqCVN6CUXWLjVbnWZg-1; Thu, 09 Apr 2026 17:19:25 -0400
X-MC-Unique: glVyxqCVN6CUXWLjVbnWZg-1
X-Mimecast-MFC-AGG-ID: glVyxqCVN6CUXWLjVbnWZg_1775769564
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d6061bd722so271985585a.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 14:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775769564; x=1776374364;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EIUt9WlgOJJqFjCvH2t68LmJqvUmIIgnA/Q8Mpi6SV0=;
        b=PZSKOEPOUzZ19QXf/Shkljz2oxTQiEwnPXAfzbeBiBjwiWsgERa8c8tvz+a+VTvRIB
         4o7E847zfspTISKI4nu2I95p71JEQWsTjllAdc/9zxXd/xrdjozFo7T/dZOzdIHtoDfv
         dSAr0nTn2RYmDeSNFgkkeX8uUpx8vZlCQxuMIeKZA/5SwQz7wvoclfmmGJ4fw/38fZ7z
         ZmM42EZ7PT/sbwYKxZx7DsaUlxBO4q+sJB13yYnnCtNs+wFSFh6QSXbB7fV2aSSVwXk6
         a5LepLCD9ZIo7exGMlSElklFcKzGPSGPsulwVZ+jcB8OYtHB1P31F+mNtA29BtonT15f
         yCyw==
X-Forwarded-Encrypted: i=1; AJvYcCWlYPnYKYkVaqXMC5wFQjqqy9zFZEaePVNsZAd72CDdJqjDksqm+DV5ZDNpi8lywDJL4rkdj2iZrA==@kvack.org
X-Gm-Message-State: AOJu0YytMcYFk5tPMhmVpeLc6COz3U21+VsNJ7o2sb8YaSsMPTpv56Xs
	vg4s06R9gFdBdqzxb1/FrobEcmbDqmVmQij6XCMUXIRF6TnmE9z6cYr2yMvURPc86ayoX5CPDm8
	GA6IIdTnctxwK627+7pI1jcBbntZ9PVUYe0Gm8RTYjNW9kd9sw3L4
X-Gm-Gg: AeBDietd4XJ7ez1WP3o/5StQmunQEN4XyYVvB+HlIgWjtvd5UlBPpRmd+upfT2KjZiX
	GHfPLEBsCXip+LSmCJUMx0YDxOCOsRACH528MKAqcdcQu0sRa/EcAf3iAkdnCmSdGYitt1MTX5/
	gD8fPwyv3ijlH2G37OBg4wOMEzwnBjvxBmz1bcQt0Ya6pQMS16S6FcvzxZQbL2qrkdJ5gLeHDr3
	dBPPURW2pMwj+QYQZApBlwI8J+C/lSX/vaYATSkMkiAPtltzzi7WqvjXFUZfX8tkHnfeEiEu02B
	+WKHtm5HB5SsyiZ4EHHT0sT/Gp2IZqFDGgt6xLelnVdu0ZSpQrySS9yj3tcZTmJElUsYQxsbGqI
	9mCixiruGy/7GGLgz7KNcOGLWFKTyHMB9fKhBP1hvIsfp0HQlBuUGXuGxmCXUMP2GvhE31l5HpQ
	+U1yTUgZ8gn77TGhQ=
X-Received: by 2002:a05:620a:404a:b0:8cd:b38e:9042 with SMTP id af79cd13be357-8ddcd022ef9mr81979785a.8.1775769564480;
        Thu, 09 Apr 2026 14:19:24 -0700 (PDT)
X-Received: by 2002:a05:620a:404a:b0:8cd:b38e:9042 with SMTP id af79cd13be357-8ddcd022ef9mr81974185a.8.1775769563966;
        Thu, 09 Apr 2026 14:19:23 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb9637c5esm47958885a.38.2026.04.09.14.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 14:19:23 -0700 (PDT)
Message-ID: <e5b309a6-3371-4094-bf05-4d574ebd1867@redhat.com>
Date: Thu, 9 Apr 2026 17:19:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
 <772C4431-FA93-4477-B1CE-3BE5EA97FD0B@nvidia.com>
 <7830cda5-b3df-4da1-805b-278d5af6b2b1@redhat.com>
 <3B2D36D9-4B04-4548-ABA0-AE5DAF66B2EF@nvidia.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <3B2D36D9-4B04-4548-ABA0-AE5DAF66B2EF@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qxumPCCr4DRsPThqIYYSoAzO5_V6yfyrElL6d5Muy_g_1775769564
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48915100010
X-Stat-Signature: bj3n3157f56mzxk9fk7m1ufh5awg97oa
X-Rspam-User: 
X-HE-Tag: 1775769567-639887
X-HE-Meta: U2FsdGVkX1/4Wa4nRN4G72cTxEuNcJngeaWO5vz1XlXcrdlP9+SETRlt60eDBu8sj1y9TFLCZ3E40Wp3qb8BxnB0igBUVwG6VA0GdB4ft4BNkGP8CoENIByteZmu8ceEa5I0vSwQyNeYAa5O4Znvxk/q6fDO1p9JpXJmYcx1hRW8wZqshVAbveu7+hn14S0nZiyY4HpUZ7bWF/zbmK9Fv4mJK02AqelZy0LZ488nJj5peMfvQlEkrVQRU7xngGhyQFUtiiTEUlTKjXWt8pF0qvS6t7rZsWbujkqiL77xbfuVwf6M/s9TSdGExHOYBfwSUwWQ1YNeaSxen4lmJXVKMhH4KK+1ruX8Yff/7oTC1wtza64CN7+MdqPsqeS4V2ixehEIV5taz3XJiKD0D5aChY16FYoGicmOh+aiFex5CrWZy/+mtWJl4Dnd+IdOJB5M+JUyusjbmLEG0mwF4d7KiuIIqZFmztDg98LiHLtVHIALl8iJOjXLhcmv+Mj65rs9kWomDxjbKAS8/6UnBVZ6U780VcLNILTIySxR8JhzOH+V82YAOBYzSg5oUzBr0UOpSmFYbpxC0Bm/u/Az9rkdCZ5j3Gs1dtrpvyiZ7oiA/r5QPn/zlQ6/2MHaAVmW5gQS+Q7GD8caBUuj1ap7+Vj0yNgqS2cAhydxh6I5EcBVC7Ec684yT+Vfcfde9IFBcON03uRfo056Y5fEI6Ve0Ek1S/ki4hMZ2svnXUEFQ4jiVN3jgT+yDjG0llGEuAitXCb2mmjKymCkAVC17TGbNLpR1R1rFEC+PmpStReIjirJCa/dsmFTZaBxv5yNnCop3AsmAkY1WaTahcIObd1sem+1uDlYypW17CYZL+Flt+x1aKbqNWZftOL4wh6E2+6Ma6nunXr3h8f3tLt0HZXrvV7i3ZcXnlUuFXAUVHkPBDykpeG1ohvW6+zDTOF9TVmPpBUFoGE4HC8ZR+lFVDMX2tq
 FsoDVX3C
 RgNpLFO99zhsT72H9/K0m4J+5y0XBOrO1DZ+dCTluDhLzbwfIhP3Mb5VWfDOF/tYefqFLREJJaO2+lXwA7FuhMTc3OfM0nVwpAmpGcliD8LUl+WCNfledjXH5A8jJ3BLti7w7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 16:10, Zi Yan wrote:
> On 9 Apr 2026, at 16:07, Luiz Capitulino wrote:
> 
>> On 2026-04-09 11:55, Zi Yan wrote:
>>> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
>>>
>>>> If PMD-sized pages are not supported on an architecture (ie. the
>>>> arch implements arch_has_pmd_leaves() and it returns false) then the
>>>> current code disables all THP, including mTHP.
>>>>
>>>> This commit fixes this by allowing mTHP to be always enabled for all
>>>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>>>> created and their mapping will be disallowed at page-fault time.
>>>>
>>>> Similarly, this commit implements the following changes for shmem:
>>>>
>>>>    - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>>>>      check so that mTHP sizes are considered
>>>>    - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>>>>      when PMD-sized pages are not supported by the CPU
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>    mm/huge_memory.c | 13 ++++++++-----
>>>>    mm/shmem.c       |  4 +++-
>>>>    2 files changed, 11 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 86e489c0a150..6de3d8ebc35c 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>>>    	else
>>>>    		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>>>
>>>> +	if (!pgtable_has_pmd_leaves())
>>>> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>>
>>> Why is BIT(PUD_ORDER) also removed? I thought PMD THP support and PUD THP support
>>> are separate. Here the code implies PUD THP relies on PMD THP. Is that the case?
>>
>> This was a suggestion from David to an earlier version:
>>
>> https://lore.kernel.org/linux-mm/dac20466-adac-4e47-8f50-87f4774fd57b@kernel.org/
>>
>> My understanding was that if an arch doesn't support PMD pages then it
>> probably doesn't support PUD pages either.
> 
> Got it. Can you add a comment on “No PMD leaves -> No PUD leaves” for
> pgtable_has_pmd_leaves(), so that no one would ask the same question again?

Sure, I can do that.

> 
> Thanks.
> 
> Best Regards,
> Yan, Zi
> 


