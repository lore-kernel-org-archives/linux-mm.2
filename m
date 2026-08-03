Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6A9C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA2B6B007B; Mon,  3 Aug 2026 12:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AC86B0088; Mon,  3 Aug 2026 12:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4234B6B009B; Mon,  3 Aug 2026 12:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDF86B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:53:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E1721C0968
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:52:59 +0000 (UTC)
X-FDA: 85060552878.09.629A6E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 289661C0008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:52:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SMl/LxQt";
	spf=pass (imf18.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtGzPJBXwX7RRhGk6ithqcA8P+0XZi1RHBFh3/RG25U=;
	b=CbEiRK957QqwHSlfYkRsONSrLaFP/N9yMN+3Ma8B6/Qu8SNlwXpwNDWCm908/Lk2dn4zpK
	pIUf6RJcDlpwHaAFSyu5vZNrsB92ZM/d6CRYD2h7sdPsH2oTIdNFS+IYpP+SLGhPjyBr+D
	S5dmc9gkfnwwnwNCe+FsSL6fcfSZPmw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SMl/LxQt";
	spf=pass (imf18.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775977;
	b=6WMhRTSaRIl7fdL8gRa2CyPE7VYdwZh5jHmvDjq6KUQzFSqNVOEfE4wWwn9Y6yvG50Xv3D
	naJLNx9Vfkvld5lj96ImsRr2JZ0vFkOKLyImATH+A2gJ51EHn9ZosvJXeMcyiWkpTIuNOZ
	YuLikvJYy0t8z4ypE5/JsHiMLQJ2kl0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785775976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZtGzPJBXwX7RRhGk6ithqcA8P+0XZi1RHBFh3/RG25U=;
	b=SMl/LxQt2/cjKPhQKFSyh1FjVxkOUXomjPib2q6vvzOIXm962W4rkKapUWeS2FM6qDFwtm
	tJoj4kiO6WToLLiCWUt24ul9UAqMvOIVIM6ZGcaknE69OQskrAral/vQFsPkpcT/we8iYK
	hWhyqavG00T9rH8FIIPnc75CvtC13B8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-IL494TFFOpGy18qDZDNHmg-1; Mon,
 03 Aug 2026 12:52:52 -0400
X-MC-Unique: IL494TFFOpGy18qDZDNHmg-1
X-Mimecast-MFC-AGG-ID: IL494TFFOpGy18qDZDNHmg_1785775970
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F4011956069;
	Mon,  3 Aug 2026 16:52:50 +0000 (UTC)
Received: from [10.44.48.18] (unknown [10.44.48.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38B111956087;
	Mon,  3 Aug 2026 16:52:45 +0000 (UTC)
Message-ID: <d439aeaa-a29f-4732-b4ad-3932bcc26520@redhat.com>
Date: Mon, 3 Aug 2026 18:52:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 1TJQC4-2u-Z1GY_Wg7CMjJYVAg-sUDBdOpzuNlBxRpc_1785775970
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 289661C0008
X-Rspam-User: 
X-Stat-Signature: nwtusdkyn7d3ohki394645gh1g5g6gsn
X-Rspamd-Server: rspam04
X-HE-Tag: 1785775976-854424
X-HE-Meta: U2FsdGVkX19Qp89R5lJVbDao6G1/xTxIucgEsqbSHqObo+dCiNtMFD48KMTzu/UUGhowuC53EDSlFo6SHDpMtD4XXjizNB3Ry1p/m8IBeHwPqCTB5f+GboIuhndHbYQEGjPgTnavy4srzfqzIxFzyxkvoH+5KyTLvisxeynILw3bNmVIULAV6n2ymHT0FLzXs8ao3Vbpv2HmpWcTKFufg991q+QZ4BUPl4FWFOdbbu9UvR2xf1sQ8JXNvSDuVowiYa+8zqoN4PhAvnfSMzfLVlcyFuCvGUnXvULOpNU88eFmGH17fjwxakrciSlKVPLs6z453HDF7v5TaoC48z3rTVukCJ6Wv7D2dQ8BiomaQRV1Gx5q3TmRnM/kzsO4jhZJw4XlegpYEZWzzLJbDQmvfbIqPekq0vynb0vjDunUxffRLehGdGOZz4XkPdVBFiT8odMfbLOKCMQZfKGsCYRNt0bH6sfJY5e4cJgwD8IsYuLBRDHNwT1F047eIuzsaMgXb+y8g0edfCeyHWDzMA6/4MUVuRT7/cbFZgcvZ8tLvtrbcAs2b5mBWURIq79xQEpopf2sfY3gs47CKivwFNoFFUWKXXNtGrm5eE9b2jjiEoKLCUDsJ3U8Co6I0mlEq3l5U5XQUMMFNKltVpaby/jzUN3HgxYGnBLEJxeG5VTDK0Q1iLeJaiLtdBFFD26qCHoiTR4P4hKdDOEHodWCldYUehaykQxZRMqA37OZYWkbNjZBsPW+774lmzBdOsd+Fl8UFfePk8rsxIp5a993mwed/p+ayPqhomGrfhVOGgOk6tg87jkvIu51gxl7W+hmMtlEDLUd1YzlroXZSP7bWo3qUS4HLi57QuphLX0vr43Vuk3G3jmAqS8T4BHdKrYwcJxYsMF+8JWM384P2VA3zB45OK64lrSyx5NME4zExBvDrB1t6Z1I12JOo6R78MmOeMXk4iTLtsoz4MeinN6piF4
 /b/aNYXL
 deVRQXjn4mWDtg9MbsaEHdhsSrY8R4czOolYrnfqUzTgb3cX8ZqpYdlQQIGtVuy0tUfC7yJDmc3ZvV++MufB9Ui4RLFHDTf2CbPXHaDbjoO/d3ETqSXfvBTgUKexaGErPLqmTTemrrpL+y+VUNIphkAOQ/NdoVMqjhKJBW6Gz47/RzFFy3709NaPV1UQIOkFf1M/Xqd81XPihzO1Otla2pGm6Jr6DLMAGhVALwNydv1BLH2K5EoMZmmqiWZws6Zhewu4Cn6ArUuOYmiZ+uTPxC7mLLdxhdwcp545s87+0zkJiTdU/S5Xp9d9Vi0ZWQxAizknCM7upfYwiU/OWO0Bmz37np9VrGxOKafjBMh0+4h8v3k38sXg44PtqzyLjmpRf4S1QQKrPNbB+9ds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 10:55, David Hildenbrand (Arm) wrote:
> On 7/31/26 18:05, Paolo Bonzini wrote:
>> Reported-by: Sergio Lopez <slp@redhat.com>
> 
> Reported-by: without Fixes: is odd.

Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API") would also be odd :) 
but I can certainly add it.
>> +	 * @write_fault: if true, fail with -EFAULT unless the mapping is
> 
> Just wondering whether EPERM would be better.

It would be EACCES if anything, not EPERM; but almost all callers 
already pass EFAULT to userspace, and write() to a PROT_READ area 
returns EFAULT, so I don't think EACCES is the right choice.

>> +	 * writable
>>  	 */
>>  	struct vm_area_struct *vma;
>>  	unsigned long address;
>> +	bool write_fault;
> 
> "write_fault" is a rather odd name for this, given that this function will not
> trigger a write fault.
> 
> You want something that matches FOLL_WRITE.
> 
> "write_access" / "check_writable" maybe?
There are no for_write, write_access or check_write in mm/,  but there 
are a handful of each of these

	int write = (gup_flags & FOLL_WRITE);
	bool write = vmf->flags & FAULT_FLAG_WRITE;

so I'll go for just "write".

Thanks,

Paolo


