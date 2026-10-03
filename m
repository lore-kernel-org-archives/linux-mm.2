Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C850CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 15:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930016B008C; Sat,  3 Oct 2026 11:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E10E6B0092; Sat,  3 Oct 2026 11:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D05F6B0095; Sat,  3 Oct 2026 11:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51C426B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:09:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4533C09EF
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:09:49 +0000 (UTC)
X-FDA: 85281649698.19.9237A25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 18B7140002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:09:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RD8CUvis;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791040187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIxj6ry01eJ+GYC6y0yG2M4VVnKiRtjxj+gvc7C8aEM=;
	b=b/qjrgQNuSLSiwXLN2xMOVjjakiDtYlgmrE4EtLYVSpIwsskC5s4QKQ2oF07nwThBC5nNG
	KOnuVAOOFVNCZOG2o1mPQ9bheyuc4wXFvU2H9RFRQay3GHBlmp2bqTxN5fy/uDVpo/j6Sg
	X6uKAV1+lUuzAK0k6GTMwzCy1oyAvfk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RD8CUvis;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791040187;
	b=itUJnMtq2qMdpSq2rrIYsx0Sk/Ki0qP25Fa8Oa8y4fAjnPJ4Fblh4+xRXIgdWk/glNUz/H
	OCdnpCi7XR51zmXMH6t17bf4vDoRfzSzaMYbJ78qGoLmpuuXdhsEOAk2ZJfpBfSc7gTuI/
	lT3Co0zxWSYLrTrQMbhKpHRtygESzEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791040186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YIxj6ry01eJ+GYC6y0yG2M4VVnKiRtjxj+gvc7C8aEM=;
	b=RD8CUvisjigs3p2Nxy7uEjRKEXy1P0DkunyLuYVJmTvNybAntusECFBMsa9aIQFBrM2405
	oui3zr1xD7f7oGnp2oHAiSYObbIhfmRBxOINWCWcrJkmpVPbrnEHxcsUrNylWWXxHlMdyB
	6Y1mWdQmDGBtcProgvqdZ0C+7orQVEE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-Z8H1DDPROt2xacL7UDeWWA-1; Sat, 03 Oct 2026 11:09:45 -0400
X-MC-Unique: Z8H1DDPROt2xacL7UDeWWA-1
X-Mimecast-MFC-AGG-ID: Z8H1DDPROt2xacL7UDeWWA_1791040185
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93e4c03d1d9so37349485a.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 08:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791040185; x=1791644985;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YIxj6ry01eJ+GYC6y0yG2M4VVnKiRtjxj+gvc7C8aEM=;
        b=W3dNeyYqvdEi4urSkph3BvkkTySVAl5hQqWXDH/LCyrxj3Fl5nGvZJDAFFhdQ0posj
         c076hiW7YykbDuyPb8ebS+nJW+sK60mgYaVrDdXxlEKW6FunBbWvwwo9RWv9HL+Gsm65
         pSm74i5KmN3dmkXr+tYYsr6UiNRDvPL2ZV8o8zHurqypjpnkjwK+hpf7dhPTyrqLORfm
         Ih+wEV3t+yuCh4TFA/W6mxbOlm8p41tOSveQhRpPJ3krN0NSxJ7e0Gfy6IiXhj16EE27
         4AVAqtgcfDK8RZ2nDJFa+eNWvVwkg35T3pp5HZ3TGiX0AdRXTOgxK7j21LDyk9M6sRM9
         ftuw==
X-Forwarded-Encrypted: i=1; AKwUvByF2R0A/InKGYinTN02CUllkr9i3MI/HBuFCIPeWrcTpRYI5vzxYqERf1OCkxJl3NZemjOBbTsuVQ==@kvack.org
X-Gm-Message-State: AFuF++nPUED2mC1ue7HtUHGYY+FuSmR+e1lsxUFqm7nQ0pWws24vqc5p
	upiW4kr8PWL2DgFuG5XVjG/8jElhwKcBxcM+KTzLius0FNCq0R+GoE1nofcsGuGPoGUmo47HEqU
	/f/7GCY+oL0DxchXcmdJaM/HD6QY8H5m6SrHNiP1+iA8/z5nmjrbvWRMBCmxGYXg=
X-Gm-Gg: AYBFou3s3vVljDpi01AR9JBFkSv4FODNOlgXX8kTN+L8LeWFYQPdfvCsVOIMmSvZqV9
	T9XqgxU6uqBSvjUbRpE0fy3bHLZQWID4P+XQcWlbeAz4dN5Foi354FBslK1DhSRv8qpPntJLVnE
	j1wA0R0Dxb4WMj//csYw64SelvNuUUpPofJ15qj3codvszPEQn1pMnKw6IoMugrCquh+CzUD7Kl
	V+I/GnOlI7qPBN4iOWRo2QTujxXZyjeggZkHLlJqMUHOxtPlLzJbZwzd4obM9lf6xiNmSNDf88C
	/Zv4nC0N5DXvrEJ/JqlT+jtYkZuuRe7GNDJZy8+mxmktMGDCe0jMdU+psKiEK7VBtyF3hVzk2JH
	FT1I=
X-Received: by 2002:a05:620a:4113:b0:93a:f9:614a with SMTP id af79cd13be357-93cf1748ff3mr1013750585a.34.1791040184710;
        Sat, 03 Oct 2026 08:09:44 -0700 (PDT)
X-Received: by 2002:a05:620a:4113:b0:93a:f9:614a with SMTP id af79cd13be357-93cf1748ff3mr1013742585a.34.1791040184161;
        Sat, 03 Oct 2026 08:09:44 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93e457a4e20sm361949485a.40.2026.10.03.08.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 08:09:43 -0700 (PDT)
Message-ID: <0162d0f5-8e75-458b-a0a1-6071f46d4b35@redhat.com>
Date: Sat, 3 Oct 2026 11:09:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
 <b63f546b-ee92-46c3-85bd-bc64dbaae367@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <b63f546b-ee92-46c3-85bd-bc64dbaae367@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B9WLHAhdcaBE14MS5IzX7LORo1LN7RcSd4S7IICrxGg_1791040185
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18B7140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7s3h9u4hyy1fpos85794a6obopmfkpyf
X-HE-Tag: 1791040186-260800
X-HE-Meta: U2FsdGVkX1+PT3cMxgTNNpG+fpI0+CEQrPKBGVyeJwTIAP4mqRBo3fXcigzGg27JMkDCt0sqywRXrsWI74aTeLExeYGNx0Ww7RRFlzO9XOEvapvG2oiPaoYocInuuTrMLgShrpkjK38FWBpkMPiK6Rye6ZHhL4nkbxYhUXhLvOtabu+5wQqI/MAiODlhpqmGmRdfRx06P8Ie8Ly8tUmOSqjma3hnSY+hzFodRJ1z0tM5mRjTeAIKOP7cnTJHdb0bIjnrK8AKHAFVnCnC2QWH1ye3h+sXoFlXQluoT98EuFQKpKi+ifnc0Hu8vX2oiT2BtKsrEQ8J1bVY+7oKwDXG9H+u2eG14M8Dh7N+HITpdMrUwnW99meb2kKcb0uQHEzb+sP7Q4TfIQqeZZ1lkEEkeqvMFuqc4fEla/wx9CmY+b8QLhwcBcU2xRioEJLnR9lXmuJyX1Y0u/XU2f8F5MxySLVAqHlN/cna1EapYh27/phA2MLreNrlyF78qLK4HOkPuRxtTjh8B01DrqCWvX7cOCKLvXi/xHz7vCniZ0mrJV6QZEFkHNXHxnjUEtKF89k19bRSrDitH4YU/0GAq12ii0mrmNeM7kNhaqmyG9Dip3cThdCz8CfdZX9RMRXpw6PCK+PoXI2/T+lRI15weTKu55Qrnj8BN+/3qA5WFA0Mg4uS91DGUTblkHkD6xqRZjPelCDEgYaKK7ae5n+srl53ngJI6/F0DPyMkSGakPN3CDTQN+mR83LAkasiD9vy8RvMa1+vQq9EoVAEaFliAqlhPmYUw9KL53hhJXGIv7IUWYrGXRnUvBj4/bFYy+Gj5rI6THnUpp1kE377Q0OmU0KZTRzzckjrH5ZYvEOSNr/+ch6NkzYwcz6HCsgsZQ/1mTjdRQMXP5UX1eUBWUJb0YLszOPzN+xheW/79OQwUZFLxKENKJIHCIErmN3+Q/i9GYJjF/oZcKm/rhgw/+Mcq1q
 As3953Xd
 U2bmP/vZH9aZPgbjign1YE2XYhieDh91NpEW3Z4LstBnMtvFLAqDeNKPL6e179BH1yP5UMO4u0gDeTRUy7t1isONlYzDkMMQbvLz/lQ1wji/xEKhDBbgyJb7V/bO6jp9gBwaDPLvNysgMchnDN53tQSNq3q/5IUG2Xjkr9jVVuPPsRqtcevxpMyhFr5nD03VJarw5E6h12EdzC+Agt+0zH85S5H3BaUqoO+r7VqhKJGswc9oZIfTqhFZAyMSKHuhepZJAMr3d+4ATlXvgteKHMAYgCb+uqEG4C7P5mbcefR/yQpo1Sa/kwPmMcv9KyP0PyXIcS9mmn1OrNsEV/vfJMrrMAMKo8vVobW1lLuFbKKwFupAdI4bvzJUHzPaqGqvBhfiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 3:23 PM, David Hildenbrand (Arm) wrote:
> On 9/18/26 03:45, Luiz Capitulino wrote:
>> In order to enable THP support in shmem today, besides the user
>> configuration required, the CPU must support PMD-sized pages. This
>> is the case because of the following has_transparent_hugepage()
>> usage:
>>
>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>    if the CPU supports PMD-sized pages
>>
>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>    the code block calling has_transparent_hugepage(), the
>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>    supports PMD-sized pages
>>
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>> in all cases, shmem can determine THP size support at folio allocation
>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>
>> Additionally, we need to check if PMD size order is supported in
>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/shmem.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 776dff8a848e..930657d05375 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
>>   	else
>>   		return -EINVAL;
>>   
>> -	if (!has_transparent_hugepage() &&
>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>   		return -EINVAL;
>>   
>> @@ -1524,6 +1524,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>>   	generic_fillattr(idmap, request_mask, inode, stat);
>>   
>>   	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
> 
> I'm curious: why is that not handled inside shmem_huge_global_enabled() ? If PMD
> order is impossible (well, okay, it is possible, but we simply cannot map these
> things through PMDs), I would expect that we never list them as "enabled".

Yes, you're right. What about renaming current shmem_huge_global_enabled() to
__shmem_huge_global_enabled() and then having:

static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
					      loff_t write_end, bool shmem_huge_force,
					      struct vm_area_struct *vma,
					      vm_flags_t vm_flags)
{
	unsigned int orders;

	orders = __shmem_huge_global_enabled(inode, index, write_end,
					     shmem_huge_force, vma, vm_flags);
	if (!pgtable_has_pmd_leaves())
		orders &= ~BIT(PMD_ORDER);

	return orders;
}

Would this be acceptable?

> 
> (while shmem could allocate PMD folios, it would have to map them always through
> PTEs. I think this would be possible through some changes, but we can defer that
> to some future work).
> 


