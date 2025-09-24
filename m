Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBACCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816568E000F; Wed, 24 Sep 2025 11:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F508E000E; Wed, 24 Sep 2025 11:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F27F8E000F; Wed, 24 Sep 2025 11:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 477B38E000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:39:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1F7F437DF
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:39:10 +0000 (UTC)
X-FDA: 83924552460.27.59812B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 778F812000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:39:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9zNEpBA;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758728348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3hnbNQr+CMB/T5Lrt4+Z4OuC6HJ7S7MgiA4J3LQveE=;
	b=6fJbCgrOyUfvWCG16MbiT63eS9XI1CWRcD/y/1e3or/xUckowbUKDFmSM+b5iVo11wDx+/
	keQ7YxuRsC7UAWtorRxKONAZab1NXdJGuqbgIltWTJ5SsuLgKZq4N6X51X7NS8vgiTGQOj
	y+ZatsodC4kByHDVkQumy1kbmjLCqqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9zNEpBA;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758728348; a=rsa-sha256;
	cv=none;
	b=49V/IvNf1vaPxMhCcZeYX2N09r15RAo7utcqa/LAVbxViAxaR7EWj/GrX5Qp3L7OLowUyD
	+uu3RrCOWfmO/M2Z872H7JGHZu5mARFKKkmwOzo8ci+Uy2Znj/TdFlXHL6KyTlvcB73ioN
	lg+6y8u0cM4+vz+aF3Eo3hQSG5byQPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758728347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I3hnbNQr+CMB/T5Lrt4+Z4OuC6HJ7S7MgiA4J3LQveE=;
	b=V9zNEpBAswA52VYbny3szVbJ9vDPYODmjMbzsr7CK1GxvsQO0Hts6eqrXKhU8RqbtkUT3c
	407EX99x0VMTq3eLcrPzDPvAflEplP2VKMGTV6SmKgqD/pvPo5j/XflA2oK04drBeOWBlM
	iOuroFk8iFgqTgvqNR/299KrouOx0/Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-5nZp2dDeMLmzZfmjNEeaLg-1; Wed, 24 Sep 2025 11:39:04 -0400
X-MC-Unique: 5nZp2dDeMLmzZfmjNEeaLg-1
X-Mimecast-MFC-AGG-ID: 5nZp2dDeMLmzZfmjNEeaLg_1758728343
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e303235e8so4095415e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758728343; x=1759333143;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3hnbNQr+CMB/T5Lrt4+Z4OuC6HJ7S7MgiA4J3LQveE=;
        b=qNZz128qu+ZAVqLmKwnXKjLu+YZ67YYcpt/9AZraKnfpiM6vUt7zeGcrAU4ijl51Pn
         MzHT+LekV6FKpAJV2p/Fd6+tHuxhvdtENzg1KrHoFLPLjwp6X3N4wN6tsxEeskewzNBl
         RrYCvlVQbaQrMjNfBlF6MgMjeq86I4c/pVLM3pmklOi7sKTtRb98wv4XNVag8ZL2JHUC
         LygpM3dnuwbfcOguksLwk/FeT0di2U+DTAVFVyAjUxV2/GnpQaQ56avL4QdjB0I6FHUi
         w0qioKV8s29K2b9Sqd4XaMLJhAn/ldN69nrOIUsCnZVxzHWQoplgGvE2JTNeUBA6Mkff
         oD3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2m04bVIJVJzBmE0+22IcGYOKJTWLqrjcYi4GufR4zal5oTcgBeAZh/Eo4SpPkJbwTIYLWuDN7Xw==@kvack.org
X-Gm-Message-State: AOJu0Yyw9iXlsZAmczupyadN5KPl+M9u42iKY7poGJlXg/HD34q+lBF/
	s4T0ScCZQNIEZfdiCcCqx2UnV1TF/rZOMkkEApKFSp8KBdTe0Em6F3aQAF6+ekjFrLLJhN7c9nj
	Jz+dGZW7fbOnwNcVJjCVYJ1AsFQHBdUy02JX8Fcc4k2dWsXAe4s9a
X-Gm-Gg: ASbGnctGKXXFcZMSiAEUfNZpaOLlrh5O18/+j3tEmnYpLRUQbXzKwR9bOY162BSSnGM
	GEH95oxWYbqdJ9xzR6CFHDvzYG9MnU8DBI89mTe3FU56fs4GKUbUXmQaNbtaEUzaQfDag1D3mvB
	N5jhvn932NHK1DIhLKIeW/VagOVYC/ap+6XmzE1vkkngzk/fyYcXu2t/5DOYW642HKBijXjlT0B
	Gy7ziy8FvtU/Fvx90EW2+LojSGnziOqrNkUxg2BD/oWmd9edxYGRwKrJXytewBTRGepUSbrjBJY
	9hnvm8tD2KzLwCD9ypZY5I6liAdk44JuoSwMuNDB2s10QCswzKXP9PitY3SxGTVAVcWLJrKUDoD
	W90CrdwdH0WT5cu2E9udUW4N0mYzZNID9HlPrKtWcH9eNuT4KuKw0ECk6GAI0q0BWBw==
X-Received: by 2002:a05:6000:3102:b0:405:3028:1bce with SMTP id ffacd0b85a97d-40e4886dea7mr389080f8f.32.1758728343156;
        Wed, 24 Sep 2025 08:39:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgd4QFIbHl+KGwltRD/ttCSG+TyRobItnmS8e1jCrWLoT42l4oEjJc1CeO+4N34B2hOAK5lg==
X-Received: by 2002:a05:6000:3102:b0:405:3028:1bce with SMTP id ffacd0b85a97d-40e4886dea7mr389052f8f.32.1758728342727;
        Wed, 24 Sep 2025 08:39:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f3d68sm28588947f8f.10.2025.09.24.08.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 08:39:02 -0700 (PDT)
Message-ID: <be77e0e7-4cb6-4a10-86f2-50e8d001fd84@redhat.com>
Date: Wed, 24 Sep 2025 17:38:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "patrick.roy@campus.lmu.de" <patrick.roy@campus.lmu.de>
Cc: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "andrii@kernel.org" <andrii@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "corbet@lwn.net" <corbet@lwn.net>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "haoluo@google.com" <haoluo@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "maz@kernel.org" <maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "rppt@kernel.org" <rppt@kernel.org>,
 "sdf@fomichev.me" <sdf@fomichev.me>, "seanjc@google.com"
 <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>,
 "song@kernel.org" <song@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "tabba@google.com" <tabba@google.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "x86@kernel.org"
 <x86@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <20250924152912.11563-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924152912.11563-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IImolRA4yw0Priq6wLnpt_p6rvSUH-FVC1g588MH2IE_1758728343
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: srooiteht5uuranb694rnny539pytjfj
X-Rspam-User: 
X-Rspamd-Queue-Id: 778F812000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758728348-904884
X-HE-Meta: U2FsdGVkX1/GeD67FF8Vac5zRHMawGeoBDejeej+yD3BFtnBa+r8vGZiYULpqI5NCTOGb/to9tAGAQslxSMfQuBeZZqa6sXsBa+gJE+vSXcbNPExzJ47kBzym9kpRV94r41W80HYLvasLjSk+thb5KIa4RJWZEFKzQmo/MitUldchcCWzDCkMyW6PsxGEBknHOMnGYcDRH0YH/yGRjroeFbmAwKfD+OZrRR1KGcZQ4PmDCvfdKDef14iaolWjGac9wvZD802tT2AV1WZDEgWc0ARZWfCEsGBlkjG0dp6JhwENm9/Sfo2Fn8rkEWI1KbzF/BhARFVjHMkyjOqSWm+B274AG5NVKKL/fcG0GPRS9HgHQK9QcmsconS5aFt5q5JDgCuqWa/QUvkQ2x+TAim0t2h1Oemz7Y5ScZyurCXOvM0cxWex3/cYf4Zl3XkSPtPFZLj3Occ6SUiYnC+LdEmf11MKBfQSG7F/xbHxLsQQPKhY5xQq/jQpWQHL8uAqouwWBTvUXU1/o9jre3qeYJC+OuF+zhJLRbKaMMYAeBx5QMzDUCqYi1lT9hjcq+Y7+TY6HyzEnai0Aiv26Jf3GHKgYg7586mS6yA2t2ARd92iD5ebb7p2J47YQz1p/RctXCgwodYAeMcQzEgGkzrPqzmza4BbdMlUHEFiG3QQlmZYFprJoZXEws1bXS7yWAV6V52P41n/avlqjIWOfjgQGBPNaIFHadPcjZvy3M+kReJCdjWZpwmhJfiYhYzwb2UEo5kcF4TBCbLVXc61f2PYYxNZlnINlDdR78n9dkQBDkmidafDNqAXRkDXI6pWFQXL74h+sXT7N75RIxP88q7B/JOXNcZEYh3XQxvgFsIcuC1DmOt33vshRvPEz5W12j6z3fN55dylGwDMnx6pGH908y8suimwsx+pugdo5qsfQG1ybE4Sk+T7yX2C54M/WqQe4fcGKrvy8XhU1LbhBk2OSC
 IDtIyFp6
 SbUJfV6Ocukw5bd1C+3/EyROi7mwZZeoz1/wimGWr2aYebKLxttd6ZCyRXXW0wUclhod7AB79cw62vyMMttDIqOdkkOrCCut/BdYZy4dDHIh8S8BjG6m5JV22fzd6TX46+ESPaUsjby/GUG+pb5QXpyZb4cosPl11szJbRkUaFAMoysETFOtqXsdOhiTzkPg5fcTMGZidl0h2bDYtZEUfizrn5yNtQi8oBFZIv4x5IcMPR+eQzbU1u5ZZnsAjWy1FpMeq6F6MQC4wNo0U4DbH32A5S8AsgU9dgZ33mA/oZw5t4jIp0Alx4TEZ2Gf44r0aiJjIXCx2Z/YHP4Ujqy/g+slHAEbvKM0fEIW6TpxVfk6BLdbY8BqVZ5JzGNHXRlo2rINORwUCqy25ce60nAs4MT0ri9SqRk/QyT1Fyl1l7Izli9BvV9x+3lq8O0rCd4NJq+i5lhyOr6iI8+EQkrtFHgNe3zCzLXNo9gprIicyn4jV17Q5qdlnlUb77+6X9Y/z426REQaGDLYVEhT11uO+05GNSvctBVQ3hTnFgW98KMKHqtgA87XPz1znvbLh4Dm2O5XnIYILej5Wir04imy9EajkFebQt1kgd1gJfbrkNuFZ/vHrTmCDXpdGAVeQVF2yma1msaDi6MjnW6UEzHuTEHwEYmUfP0qg7go2nzF1DaRFJTgzhh+LFzOj9u2E4ccG85eLbF1v9YzqY9O145WdJN2Yud6LQnyVG4k2cYMQcNsR+X8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 17:29, Roy, Patrick wrote:
> _sigh_

Happens to the best of us :)

> 
> I tried to submit this iteration from a personal email, because amazon's mail
> server was scrambling the "From" header and I couldn't figure out why (and also
> because I am leaving Amazon next month and wanted replies to go into an inbox
> to which I'll continue to have access). And then after posting the first 4
> emails I hit "daily mail quota exceeded", and had to submit the rest of the
> patch series from the amazon email anyway. Sorry about the resulting mess (i
> think the threading got slightly messed up as a result of this). I'll something
> else out for the next iteration.

I had luck recovering from temporary mail server issues in the past by 
sending the remainder as "--in-reply-to=" with message-id of cover 
letter and using "--no-thread" IIRC.

-- 
Cheers

David / dhildenb


