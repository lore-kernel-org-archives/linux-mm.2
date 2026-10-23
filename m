Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D96B606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jIby+CaR
Received: by kanga.kvack.org (Postfix)
	id 1DFEF6B074A; Fri, 23 Oct 2026 14:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177B86B0BCA; Fri, 23 Oct 2026 14:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DAA6B0BCB; Fri, 23 Oct 2026 14:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6F56B074A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:17:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 987CA1201A6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:17:08 +0000 (UTC)
X-FDA: 85354697736.20.E8CE44A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C58310000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:17:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jIby+CaR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792779426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1THp/OIN/zpNWmU48vsr3ZYeiyjQo4uPof3S/m8ebdU=;
	b=RUy8Pc9RJtLiBLIeKO9ELMEheYnrIlOnItIkuwWhrovRavr5RUOWH0KIOmI8lpLbB6T8pn
	zEjgH1H+m7BVwpmjfNHembKBgXMXBoh7OSoFTe0KlbZZoMmmi7lGjxOzVN/FJaGTOE8AO1
	W7fV+PmixfNJVrvqBZDsQAc3w8iYYIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jIby+CaR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792779426;
	b=DsD7JMocQ+HPHlVsyIVQlBiV/GOcGnR/7Z9pArSbB+vfiC07jZU/7C2/YUg3Q0o+PLSaJf
	IBglOnxgTzMQE5AgaSNzdapOel+MXi/gs8xyqfUBtPwIs7btbsEdABCZbra1k3Ofyfe+Xk
	sKwclDgoTZj4LivLsZgNffugE215jwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792779425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1THp/OIN/zpNWmU48vsr3ZYeiyjQo4uPof3S/m8ebdU=;
	b=jIby+CaR3UMtb/OEnH6jXRLP0aZnNBPbRIRTaHlOfrLsOySy/xOdhBR6n95p1biDSI7ENU
	d/f8Abiv2CRaf0K19HJop2Me2XyhlTG24L7SS3wAl+vxH/XrtfiYm++UFzhudOBGaNr896
	x2bE9kSAiBRNhG1BS+AKMNUfrxdcS2U=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-fOXc-AB8M_akJjZotZKmeg-1; Fri, 23 Oct 2026 14:16:58 -0400
X-MC-Unique: fOXc-AB8M_akJjZotZKmeg-1
X-Mimecast-MFC-AGG-ID: fOXc-AB8M_akJjZotZKmeg_1792779417
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f32050e72so15075185a.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779417; x=1793384217;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1THp/OIN/zpNWmU48vsr3ZYeiyjQo4uPof3S/m8ebdU=;
        b=K2rnyl0Dl5rTwtYUvbhW9K3LnR6avyUL8zFkWc+u6n9CG+2bA76lT9UhNhyrLymAvs
         TIgxErsI1TXzVUqSci8enZNj9QRyhCDajMN3+JbuSa8EL2Ee61Qqbou15s8Fa+dB7sEY
         +zXu3TPnoDG9dnWGshv9poDdvQau3S1kF00KC6xYZ0N4xuB3mE5Ds4l0MFkYlv0Kg311
         VC+vrIolaAAMlATHXofzQMWtHH5onAdgHWFlbM4/cZ7M1YNGpmiekVINTFC0W9muLvbd
         H0+clrkzi2T1XYvvK6lET0MkWZ5LRW4Wf0Cr1jDi/la9sS4HNQt4aUTJ+BpOsacENgrW
         UB+g==
X-Forwarded-Encrypted: i=1; AKwUvBwEMxx2KiZJhPIpwGRDoWYF3Qft7hl5Oh8somyszegU0ccmeVvdeaMQCPYHp5rEEBlHg3nAvYFLtA==@kvack.org
X-Gm-Message-State: AFq9FYIM2gbTja6pEgaZXy+L8DONsHsy9dlUEDOhXisE+sQ3VisxeDny
	ji6h6WSC/ATeFue7cGm8ltWZ34qdesOAAalTeFGWQAwicth09acVVMWwd5rGWuDJrkAZkXAmYcG
	zlttJ431MsQT1T937P20GLZ7BfqKCEZjufM8BUH3cMPAkN+ptzXVBfnzNUVac
X-Gm-Gg: AYBFou0L9NZEO+9RWlMJQeF7oF/AOl9jIOL0Ejl2cHqCKeYRDed0dK0OB27j2l36XMc
	5vmjr/ZC7MmlMsTWv9kEMNbNKYih353FkDpjC5C1LKshFRPQuJ+zX6aJjjVBjQriNBhn6ncHJyN
	YSTwv6+YTS5O3mBFLwYYu+S2tKyIV9opRkqjZr8tvut163hb5tP+DHWFkgbqwhF+xA8E36USy+F
	7UTiTM+1MIfAfi2Nk9kjAu21R5W1LJ+DhGyO37Z0f0LYW2etXrb1UwJ7Es22khgvXkvQnOqhr8j
	APt1/0zOSEt6qwNUP285+3OL5ZwBEXTtnyPglLUkuy78p4USe4W1+sW33esju5Pcr3cIhcdCXFl
	41bs=
X-Received: by 2002:a05:620a:260d:b0:93f:47fa:b727 with SMTP id af79cd13be357-93f6f91dbe0mr566892985a.28.1792779417389;
        Fri, 23 Oct 2026 11:16:57 -0700 (PDT)
X-Received: by 2002:a05:620a:260d:b0:93f:47fa:b727 with SMTP id af79cd13be357-93f6f91dbe0mr566890085a.28.1792779416972;
        Fri, 23 Oct 2026 11:16:56 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94047b2ab0asm81343485a.31.2026.10.23.11.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 11:16:56 -0700 (PDT)
Message-ID: <f49c5d8f-b83a-4b1f-ba91-07eabd0ed46e@redhat.com>
Date: Fri, 23 Oct 2026 14:16:55 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>,
 Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261023023106.515365-1-luizcap@redhat.com>
 <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
 <9544f4ce-f5d1-498b-91ed-906b37122e31@redhat.com>
 <attZIKD7GfoNeqbg@pedro-suse.tail5790ac.ts.net>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <attZIKD7GfoNeqbg@pedro-suse.tail5790ac.ts.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: adiV4jmO3M916YicAsHkp_eg6FDChIetThGDK-HPuak_1792779417
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C58310000B
X-Rspam-User: 
X-Stat-Signature: w6kinqj1tizcd5zojb7zs948rjsk34et
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792779425-590367
X-HE-Meta: U2FsdGVkX19FSAzN/6RtZeM1+dti1rtqrBZbks9MDMqpxkXfuSYXAAJzpRJAieMMamORa4k/jj2Kh883+LM6k4caXnk5CH6I6nVc000N+/NlXGbhMx37Ois72XzO2n95FoN+14Sory1WiuMtUmsfRmm3wttrz6vvxrf8atHLOgN6fLMC2tGgL6V+wpSqJLg7MSf0FEPIrfhi05xVQzs86oB2goWZJ1qt4Ikol1NTuGkLf+GLCMXN02KuiVF43t2BD2Eo+OnMR2PYxssIEdTCS0vSSpufblLcAMVuG2lZVQI/rafFyELEqizVAFyCEKoUz9SX89o7GeF8l94RpSBsglQukY5V1wS30NtkB7GrLjFD/b86Cl95E89hpawU0Th4+JIAke1JzObeBqENj0zl0ZfdoYSAVzaLgvU3bP/fHmssltnghKDfWjnexl8MfmyEt7YLfrCRBMpKNqIlqflGwr9K1M0LO5vu8Jyf22JrWqretLLQDqnrmm8NP3ZYCnYSJtark1gjBHvodNJWO3aIpritOauWksE2Oxj03GalSE2QoRBmHM+7Z2dp3B1fXQdtEV9M9zaMOmXe8Qlpzqnnq1p69CCdnhxgM36qdcEjC69VenaBxVT6TPgg+9WlTKzbMH3m4qi0RTMq1JnE+GCeNwasxVcvFK2JHMG+f0hhnRyHkJ55iiURhDfViEhvTpl5M4BiMq+JVFFqRypC66iE0K1u07JFNHoPZt3mYwB41cSX6RTcA6/2llqolAuiBbRxyPTlM1tTmbPMRAWM1jARKEEpNT/KB55ZVXIJnAYReKpxJyS/Y3UdPmwjWn1dpY1VH6Y15TdJ6BheJIs/pibt9lJp7Tk6hhjo0tI3o/8EsQfC/sPT3vjqPTSvzH6CW8IEh/mgj7b29kIjKV1wyP1K7ESfYgIlkERjyS0dm7e2v79U1BvgOjK9gcnWOUe+kdPO2GBlQvzVrQvXMljkpIn
 WnOJyCw6
 l59ttTNI4FF1qs1R8YjRSfj1sTOLZ5KfD7FoaJ55eXqv2SpEHmO1df6rrbyDLbtJY5gW45VBpqYWfRJhWkE3q7mYq3uQh1KmdAc4gtev6GclDNlrO/Va8n4lLKzTHE4ZFJInNRcZ6+wuoShful1DEHu+mOy/3Dnlmpd3IA2Oq/oFu+3VA+M84DyBhhtohMDTyuZR9VojjkU9+eQPLadyWCVibJLpPNJF7Vb0ohko3dkUGppawfp2oixpZf5SzgEekJdW9oh1aycqFFj/1bs5mpFxbtWMTUS1y+f71RKdva3M4BuKzPRUoQ7dKRva23n5lsE22W4H0aKFBNS++i/Zaa8J6COu6qgaCEG60GiDuelSFXWobHIwmhte52Iy0bXo3pV6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 9:00 AM, Pedro Falcato wrote:
> On Fri, Oct 23, 2026 at 08:13:56AM -0400, Luiz Capitulino wrote:
>>
>>
>> On 10/23/26 3:16 AM, Vlastimil Babka (SUSE) wrote:
>>> On 10/23/26 04:31, Luiz Capitulino wrote:
>>>> Growing a VM_MIXEDMAP VMA with mremap(), with or without MREMAP_MAYMOVE, fails
>>>> with -ENOMEM when the address range after the VMA is free.
>>>>
>>>> This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
>>>> after mremap resize"). This commit changed mremap() to use vma_merge() instead
>>>> of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
>>>> a VMA that has any of the VM_SPECIAL flags set.
>>>
>>> Hi,
>>>
>>> 6.1 was a rather long time ago. How was it discovered just now? I.e. what
>>> use case broke by the change and prompted creating the reproducer?
>>
>> The use-case that broke was an application running on an older kernel
>> and accessing a GPFS volume/FS. I was told that GPFS sets VM_MIXEDMAP on
> 
> So the application is growing a file VMA with mremap?

To be honest, I don't know because I don't have access to the
application/production environment that reproduced this. I got a
detailed report with debugging information that allowed me to identify
the regression.

I can try to get this information if it's important for what you're
proposing below.

>> a VMA because it inserts pages in the process address space with
>> vm_insert_page(). I then asked an LLM to check if there was anything in
> 
> FWIW this is really odd for a filesystem to do. I see we have two filesystems
> upstream (at least in 7.3) that do this; that is, cramfs and FUSE DAX. This is
> arguably weird and should be fixed. Perhaps the VM side isn't giving
> filesystems the right flag here.
> 


