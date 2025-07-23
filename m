Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD04AC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2901E8E0002; Wed, 23 Jul 2025 04:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267F08E0001; Wed, 23 Jul 2025 04:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1563F8E0002; Wed, 23 Jul 2025 04:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F08628E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:20:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C21659D70
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:20:40 +0000 (UTC)
X-FDA: 83694833040.27.B3FE487
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0571080006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:20:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZeM2Gzb7;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753258838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArrbP6ULmISQTAdQsbfYfBJ/dfwnESI5dLXQURXYbWQ=;
	b=UH8nI2J9KCDlL59LHEos2meNzNmd+2VYxLAhH0crGHK4uMqk9LrjCmA2OR4ZXDYSZR8wl6
	P2NMcX++1ibEzWBR9fqc5cHWZJ40OAI7xC7gL0fZTxGmUzC6izku1sqNp5pEInMyzvT8QS
	7oCFsdhivbT2ZLyCezSIkWTu7oOfeiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753258838; a=rsa-sha256;
	cv=none;
	b=ypFSrdaLU697/4OwPhTiG8suYLelVtTAOFwip6iTAbQ9v0ms1+hXrmIlGNXAvv+4DyJJid
	RwY4DHZehqBk6HsrQ+wXk8Qcw3LHcNspR2JsfVXQr177pRP70Gjq2NAN7HhkMAkenHGGkO
	MSDuFY6dmNHTWpVCLTN7r7Lpi1i8Dhw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZeM2Gzb7;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753258837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ArrbP6ULmISQTAdQsbfYfBJ/dfwnESI5dLXQURXYbWQ=;
	b=ZeM2Gzb79SjUckNly7CfOFvAjReMMKT/e1iqf0P+aBDYH3MUBdNzblCz2ud+dqn0gxNVd3
	vvKpu5M9q9zaV8++nNftE0UFRVGoIjCKpd7MsKxLYXPxTG7rETOvcBtJVgBxwEhiaxs9jZ
	QBnN2lfjDgtKB8DKvA5HPIi6rb74lVY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-PmHthjSyMnKEnw_cjyk7Eg-1; Wed, 23 Jul 2025 04:20:35 -0400
X-MC-Unique: PmHthjSyMnKEnw_cjyk7Eg-1
X-Mimecast-MFC-AGG-ID: PmHthjSyMnKEnw_cjyk7Eg_1753258835
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso2695553f8f.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753258834; x=1753863634;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ArrbP6ULmISQTAdQsbfYfBJ/dfwnESI5dLXQURXYbWQ=;
        b=Ngicc/2eXDLcdnYMiIwj/X5uiRiaH/52T6dHFvztr+NGe0OyLxuqVaRNQ39CX70Lcj
         NKVJZ249Oe3+2pgOU7nk8TtXMxjqrDDU2R4G/cqcmVHTicWy4QqDlEQ2xoDuAxZviGKv
         q6vmK7G2h4Pd31iNMVIIU33YBymMZfnVojJS3tOVou2kpR20V5EOR8p1OBrFUun0m4s+
         xZMpYVDUuBcOH1fPSrPJc81sUnBmekXRDXfjC4o4s0hGHRqX0cagk/CHBORcTao5C2nf
         xNnHOTFvKNSs44nN9TJf7BFB3JA5wRukyXR0wtBJqbBkNMz4wNmB5QzY+TOi3luPulYU
         MxlA==
X-Forwarded-Encrypted: i=1; AJvYcCVb8cBNHj8grzGgWDYnsDbflX40md5Z5bR3zWMQiWqMUJ9pFDzkFmIuIindfdIQXdmUNtlQQUgD+Q==@kvack.org
X-Gm-Message-State: AOJu0YwhMKv18/hPCEtFyCvYTpj8HPWxc3EPKHg9aH3io6wFpCUUMj9V
	Z0Xn222mkLuJ3e6VuC0AzZLDvmfusdja9ylorSsSoDGyA55+/y8n9m4NuPvSTkmNsKW3yxcqZhZ
	UFdzBOEkO3QwhRShZxPWkv8K0aHn8pFhYRFhs12ngzUTlAMIkTy8f
X-Gm-Gg: ASbGncuJI3bfKHtGrwy9YRIf5HE7eUrTUfNu1ThAmBtMKgUC2le7cW0Q0ikQKycysUw
	xmzYvbNtVk8PeqMBPw0NfzETpYMSjDaxMY2KURkUu3NmgEASKwdxLh9IxzbmRW4gMMAZMjPLofm
	8SZVToegLYU1oGGmcIwvaLAhXME3ybcNFzn2VThXMhYvwN3d6ZgJ5YzZoENp7Il+G3cBUB99OVR
	5/wJSSLn0NdQRqCorIPsuo5Pg4Na+Uheyv8Zq/LG7lYmMweLwdswYQqYunAHXLRzJwMc0OjacOL
	ro/CjdkbCy7i/VrL2QLeVKHNbslLYU2CISmOYrXBGAB/KJX9RhMBg1bx35xsImZ+zGCG5x6YKd6
	6/06MzZ23+eqV5zX+JkoSmHe1WTH49SyIke69jgwvz7L0JOmFVcxBO+UM3RpPYNHFifc=
X-Received: by 2002:a05:6000:2088:b0:3b5:e6f2:ab4d with SMTP id ffacd0b85a97d-3b768f0784amr1449545f8f.42.1753258834439;
        Wed, 23 Jul 2025 01:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuehv3n5C5mV94SzfgBIwheXZpqlCTL4RcfpQFRxJyOhldB5Jf2Jv2Nn3bHC1HmTGXwVtUSw==
X-Received: by 2002:a05:6000:2088:b0:3b5:e6f2:ab4d with SMTP id ffacd0b85a97d-3b768f0784amr1449465f8f.42.1753258833789;
        Wed, 23 Jul 2025 01:20:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76773a0e3sm2532813f8f.17.2025.07.23.01.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:20:33 -0700 (PDT)
Message-ID: <42146bb2-c017-43dd-aee2-1f1a893d3b17@redhat.com>
Date: Wed, 23 Jul 2025 10:20:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org,
 akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz,
 bfoster@redhat.com, tabba@google.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org,
 hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com,
 rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com,
 amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com,
 ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com,
 pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com,
 suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
 <aH-j8bOXMfOKdpHp@google.com>
 <80a047e2-e0fb-40cd-bb88-cce05ca017ac@redhat.com>
 <aIAZtgtdy5Fw1OOi@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIAZtgtdy5Fw1OOi@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dDtqvl6QzrzTUK06s03q-z17PV4YVT7i1--4eMNHE6I_1753258835
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0571080006
X-Stat-Signature: 7zwas876beojgydzy8q815sb6p7nritc
X-Rspam-User: 
X-HE-Tag: 1753258837-902320
X-HE-Meta: U2FsdGVkX180S0bHSFcabohYRkS028pfK395NbtWRR1WGPJSrgrpRF2IOzp6SWOlh/uKgDbp1Lmo0q22q4qbKpJG6RSp0qVyGrzG6jsotEM47dLHMi/VehwLz3q1hwjrQC1hAfZaF/JHIa+aev5nYvMjN/IhRB1yq9e6zk6w0d0zlBulcrkht5CNus8UfKs2HDxq6/FYPPgpvIeY9UsYHWBxyiAyfem6Fx10LWXtkJJp6lpHtPy5cPSw0uh1qU4LIiL3tnzt7s75pFfYnismUdEPmPmEfFDxBkQQ1ZJJxjeZZZ9ViDJ7O5qMT7k4tZqxhH/o8Tl43WIioXgDhbstspbDiWSqzevBmTt1r2Ie4j3q8cOuzExVTUw9WfpLhheF4i72nQxUe9IoZK2jdjuyKTrLdVnDdNSKVFrHHDaTRt/4STjeiLQUDSjsSL3XyMC0UX8sSZJ2HINKN+fAGKyAHxPmEk4ts2GtVwAXhZxvgghwqzN5YVHYyZf3gDSQYp87a9oT2huJatqr7R4CO584pe5uQ5NZY08WN43H9TyB1Kss+XWWIig2YHDDjNXY+GTgkB4WbWXyPXimdjHrYtRgoXEGQiT2sXJfy5VhD10regOP6N9TUxYE2Ll6DyhwKcv6gHZE9HIgeX54y6JU+2S6C1YMDRGN/77RbBt+pZFkypd+fE3pL7DFtnQG/QiAFXhvQugbHCgUgw+EL9Hh0mU8MAtjgqWQVwxK4seFUrycHKXzZtDNeNBzijP2NwzEShIe0iUVTKNyQVPmUfg2OrXz+dR16ZFeUbxcPaLmcX6NxEASQFULUxwsJ5nzcIcahZukvlYJ0ZLLRtDYqP+k2FdaBjsKw1ENe7LvhAVdxyaISbbQJRV1vr80UEDpKR9QnIzij3NrT1ZkAqYKlc5Xxo+PL+6ezeXeEHPrNPfrST5fCtsmu6mYf1Bx49FA03uOVQhDqyz/U2hQypD0KZ2qZQP
 fqvEowYn
 jBDpPLSQ5kKDqDJlmnzuU8gVGddahC3/gj+5bbIzery+b8aFUGV23AlA0NzszhT10sqePTeyC6VOnmw2/tIEpZ2ToTp7FQCrUuaLUFT45K/oiUrM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 01:07, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, David Hildenbrand wrote:
>> On 22.07.25 16:45, Sean Christopherson wrote:
>>> On Tue, Jul 22, 2025, David Hildenbrand wrote:
>>>> Just to clarify: this is based on Fuad's stage 1 and should probably still be
>>>> tagged "RFC" until stage-1 is finally upstream.
>>>>
>>>> (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
>>>> still feasible looking at the never-ending review)
>>>
>>> 6.17 is very doable.
>>
>> I like your optimism :)
> 
> I'm not optimistic, just incompetent.

Well, I wouldn't agree with that :)

> I forgot what kernel we're on.  **6.18**
> is very doable, 6.17 not so much.

Yes, probably best to target 6.18 than rushing this into the upcoming MR.

-- 
Cheers,

David / dhildenb


