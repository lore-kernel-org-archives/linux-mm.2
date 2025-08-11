Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B3AC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C138E0064; Mon, 11 Aug 2025 10:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053738E005F; Mon, 11 Aug 2025 10:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84DB8E0064; Mon, 11 Aug 2025 10:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D57B38E005F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:41:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 532831363EE
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:41:26 +0000 (UTC)
X-FDA: 83764739772.25.A139723
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C8E2540002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:41:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Akj0APD0;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754923284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gbggx2RPFlVO4t++KHmOzrhjwslbE7WXGI1AzTGhb4=;
	b=xtqo9un/2ub0rWpdc5k10bW0TriUJfO34JX/ugbIWuUx70/s/xRund/SHN0Wij1H5p4KZS
	C5sScA8bHuhfKYOuXcpPyuT76DAnMGqILMaFQdsplVTI4msbavPcPfCsjsr9fKyvXKYjFa
	5Ey5RKPWhfYF/cgNIyPTByHg4HODkgc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Akj0APD0;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754923284; a=rsa-sha256;
	cv=none;
	b=hXoXMppVEsgfyhNjAjvmSxstZibHzEfOvben9mRnCUlzf63eMp/BeYb6Wpj19VuX/XBCHv
	1JGFz8Ac2U5XFFZjbl04bgHQbWzKqE/gL3bKA3j5zzYANqm63UTlPozyPc/3d1W7P7mzWH
	oMZn6XS6IhJ7PPwEVYNzqK3n7FYWcYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754923283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4gbggx2RPFlVO4t++KHmOzrhjwslbE7WXGI1AzTGhb4=;
	b=Akj0APD0GSx1fo0YPRuV8c1SZeO/LsLutMUxkDafmALw0XwfGhmisiybIOdewPmIoBw822
	xYVsGDGoX6EtjqbfPqoHgPiZIQN/xLbRu+sBjDzNG7I384Cu4XBF2p5dsOkSMBIobmndLm
	mVcCDu6uqF77mgcfRZunWuFD1VbzJa0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-xMaozdQZPUKNh0vMFnQ86Q-1; Mon, 11 Aug 2025 10:41:22 -0400
X-MC-Unique: xMaozdQZPUKNh0vMFnQ86Q-1
X-Mimecast-MFC-AGG-ID: xMaozdQZPUKNh0vMFnQ86Q_1754923281
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7891afb31so3318670f8f.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754923281; x=1755528081;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4gbggx2RPFlVO4t++KHmOzrhjwslbE7WXGI1AzTGhb4=;
        b=EO5Kp0J1wog3xBSm+O22aFzQMLN3gSXRlBngmIXhdYp9cJtiA8SsUKPdO/D5+ca2+o
         k4Be2lgENb+3Zc334yx/RVGBcyDLFn+mEGDGmyP8EjU3TUK93XcVUkff5cTwUAP17Brm
         W5z2gyNvGoe3+elh1Ii25i1L8XeWlOm4V0cBprQ6w/5L8SmjbGJXc8aMC3jJbW3K0vvS
         SyZjza6I0Br/pq06WucZFL+laCRIXnTgWuicJ2CUQ7V2vMj5U/i5KNvz+X04YAvdcQKT
         3E6yYGdRngekACX0TKDHsDTeNipYieUtUNG+/oZNOftPZVtuozU3HjAd8E17fvJU9SZ2
         4dVw==
X-Forwarded-Encrypted: i=1; AJvYcCUaXjwlTiJHSoPmWnrrKqpA87ylH8uboG6eqrLxLtL3POREkqU8i3YwB19mcpT74MTWzOasjPEgAg==@kvack.org
X-Gm-Message-State: AOJu0Yz4FN6+KETy141LpCJmMB4GTLxTgj6nneQnkGH8DRLMwxoYI4wF
	eedYYn5ZMvaZlUXjOsxM6zpbx2PCEP8JvHmSEnKCQ6vbJcQm5wuat2K20If43B9x6r6qp6/UInK
	3zkipFYV3vJoKYqNYNaRfVxGAfqk36THUgdYdnLjpQuizTU0Zo831
X-Gm-Gg: ASbGncu7EKURNxJorWNahEYX7C5MJuMi//PG7auvD4VWW24DhNaiPuAxot7E4hn3IIa
	kGOPf6OnXxmEf+47WjLrlGiesmaejINSsz8elQK7oBjUzDoMgdbM3RHPrthODTFTFdoHVYeCl3l
	BckMT1oPA1iPwgIynupavhzKezF3diJc+ctzveQ8/oGEW3+IYLvCZQomdLa1XgdmecNyeAmvWJu
	jzoEtpxgAkymYPbqp+NtQPbx+YSZ0PE4rUTEHHDDfuU2ehmyK7UZcSKJSHht2OILwdza3bSnBj2
	64N9Sqt1GDjIwYrJmVAOTDoXR/DXYxVQJ1kN8ndzoUtrjPvPa2xRbB+RsV4LoNAbdwWQiQl2xiA
	WPzZQGTzzU6TGgdt5aUwfFB9TUXrJS1+2OOahiNczJzeRApHhWgOCFifOwPEZY797iXg=
X-Received: by 2002:a05:6000:2408:b0:3b8:d1d9:70ba with SMTP id ffacd0b85a97d-3b900b7517dmr9713525f8f.32.1754923280200;
        Mon, 11 Aug 2025 07:41:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNmqOKGQy8og6iuYjR3rW+/P+X+6GleHhPef0aGzUOgh7s7rRGq5mXZf9HiFNB9XK8mxgicg==
X-Received: by 2002:a05:6000:2408:b0:3b8:d1d9:70ba with SMTP id ffacd0b85a97d-3b900b7517dmr9713436f8f.32.1754923279410;
        Mon, 11 Aug 2025 07:41:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48105csm41145907f8f.64.2025.08.11.07.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 07:41:18 -0700 (PDT)
Message-ID: <42956218-bda4-4089-8f43-f7352ee73b4f@redhat.com>
Date: Mon, 11 Aug 2025 16:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC V10 0/7] Add NUMA mempolicy support for KVM
 guest-memfd
To: Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>
Cc: vbabka@suse.cz, willy@infradead.org, akpm@linux-foundation.org,
 shuah@kernel.org, pbonzini@redhat.com, brauner@kernel.org,
 viro@zeniv.linux.org.uk, ackerleytng@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
 tabba@google.com, vannapurve@google.com, chao.gao@intel.com,
 bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com,
 yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com,
 michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com,
 peterx@redhat.com, jack@suse.cz, rppt@kernel.org, hch@infradead.org,
 cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
 roypat@amazon.co.uk, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, kent.overstreet@linux.dev, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, chao.p.peng@intel.com, amit@infradead.org,
 ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
 papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, aneeshkumar.kizhakeveetil@arm.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20250811090605.16057-2-shivankg@amd.com>
 <aJn_ZvD2AfZBX4Ox@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJn_ZvD2AfZBX4Ox@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6fMVSfM7QiurpZsE4b5CCxmWB1AzJB8xJh-MT0jIIwE_1754923281
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c7n4imabgba7wd7nnjbak56bzh68wof8
X-Rspam-User: 
X-Rspamd-Queue-Id: C8E2540002
X-Rspamd-Server: rspam05
X-HE-Tag: 1754923283-534498
X-HE-Meta: U2FsdGVkX1/vwhacqwg4CkikHZ2BFbwBUQDOwECEHBNySo1eaeMUkZ8RI/1RQruri2Yk6wV17gW33KLbGiGTyaCjiMB04GS8PkUBMjRMIwr7OdNoVlsD6/wQO2lx6ErpgF7h0Q9Fy0DqDX3l7uZNzbuej1sFBQcNl0vLsT2dQFexkHYXtwaI0HcCIHhEvs/K3G+QRM/Y/10gNJyu4FgD5U8DNJ2iY1TeSBJVEwcJoMI4zAoojvrJmJHI707B0zEQi3OD2wRNfcxu98BRcZw3nPAV622iDpI6aV83AdrCA6p+jlf50Oo1svNOyDqS2aLgRo02+W8QGoGTzwoQfvkiOo+qNG7A5uwvdrXHPz+49zEg2RNfuCb77LGIcwbE+7IZ79jbsDOckfsIPz58FRa/LaZWIwjFDCJAUUSoo+af90Or4j+PrgF9EfKucI6v+yPrepRooLBUvzp+q8hacsI6RfIW2/o1JRf+gSH9QFiEBXMUkojvoBfMBlj+34qeQSkCpGfEU5rflPjhIaRXQkCYqeVCESSJua3aVVyD69J/MXhNPJeC9skhNGNPfIb15CmPHfOUCT0mwIjCYBq996NO4JPg+MFBK8hOJqts39jtDUSnQlnTzT4oPCIcBt8yQoSlf9c3C/hs0mp3wK+XEf9/cbiA4Km4Ltj+gk5On2m5LWiOA9HQ90hq0OzUWywUekel0qg6SP2QHQxvFZnd1jgd86DJUVycPhuP+kVYaH4SYHCsySUR0hmuc63l/nyImXsXlkUf1ekfJqDprO8AmxV7MGFU1/gQrwKdQeYSsNk/HZ1+GwP9axNIxm7GOjp+M3MZrrQd0Cs55ZHJgJywHjEmmoXTcgU8D5WhKesCzRBOBp7Wpi6BOYxW591sAP73RNdjmhfuJrFEHF/XfvXSFokKQJZN7p7BESpOwdAkGiZBqEkWueQ+XArKUf6zgfae9Aqe7huFmB9bg6fSDRQldOF
 bD/g8NoZ
 oMt7uO/PDKvUQr0/MK1qZhv+klVAQuYrBiOq2ACI4lAh0oKMwW39+kWH46CG5vra5MDLdma9hU1GJknH/8i9wKIM+Ll018jAp/8k4sctpNS8dZ95hhbojj9gFHkGMr122JHiH2STG2hMWXmoJ2tk8G3ppurCghha73iR5hcw2Ghgdu9//+KdEHcKIck6kuCBGVhsnIuV5Zva4P1lzd0BuDu6GSAhqPbfUyH6Qgm1aXK+11bmfApfoPifTzhMklMHVAk12E5WFIXkln0wWdDh+FGOxTGOfnAtJeJQGzlk82HATzvJJwDJYzx3dvbnZihDeJR7lO+KWcvxv3UPsOkZnGtVK53PymxM9OxuY+OnMh83J3pm26pZ9LH8M/RxKpeS8kh89p0y4MADmhyrQPauwen+ucxryPGgHv1lrta6a8yrWGXhqiT0Oxs4cBCTQn2ZU/1fH3sDxPr7QK10XBIBXH7KCq7YaX7uz3ZNBHVHPyoKpRihPfS/mkA9wr4JjmaXnxOH8ofdwYVB2sg2bhhlg4n64fLSaqjYnj0+J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 16:34, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Shivank Garg wrote:
>> This series introduces NUMA-aware memory placement support for KVM guests
>> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
>> that enabled host-mapping for guest_memfd memory [1].
> 
> Is this still actually an RFC?  If so, why?  If not, drop tag on the next version
> (if one is needed/sent).

There was the complaint that !RFC meant that it would be based on a 
consumable upstream branch.

I think once this series is rebase on top of kvm-next, we can finally 
drop the tag.

-- 
Cheers,

David / dhildenb


