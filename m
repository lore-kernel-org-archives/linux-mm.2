Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11560CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F72F8E0003; Fri, 12 Sep 2025 09:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEB98E0002; Fri, 12 Sep 2025 09:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD458E0003; Fri, 12 Sep 2025 09:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E28F8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:02:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5B341A07DE
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:02:26 +0000 (UTC)
X-FDA: 83880611892.24.935F704
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63353C0022
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:02:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bx9WnM4q;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757682144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6pmjetwrY6Pjkps/LwmTPHSQvgSA/RNS+9TNChzIHs=;
	b=GVn+0iiSJnCN16nnuci3PGbjINWIJGHcqEX2frQQGd2sVHK1rq23EcZn4/fNUyKd4Ap0Sm
	Ped6u4b5J+Lksbe2ePbTpcGsVLBv4xY7kyocaT/+4FEyVrNlcD21P7I/bpLW6cSm/2//7D
	+w8pdjouU9MkycfdEjqIEVkhESQL62E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bx9WnM4q;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757682144; a=rsa-sha256;
	cv=none;
	b=WH81XRjFm6YNGoONDfAvS7pKVaP603ObnYcuxlEADIps3Tzd3RqtY8hdWzZoJyzRTIbwJO
	uYsK+8uD8j0/Ezoul6BlCYFuAMWuzI38sEwRoOyhjBuyEBbdgqUSetoFs/wNvnzAfTB+31
	OGBjPtsMIl/UT6xJU4UCgyOMUZX86X0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757682143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6pmjetwrY6Pjkps/LwmTPHSQvgSA/RNS+9TNChzIHs=;
	b=bx9WnM4qpQxSWGnfOAs9nwWX+8d4sokUVaUi2kJs57ZluJJDsArI49rciCFQ5q7O48gcmR
	KeE81MPapXf/bKVQpDv/+RoQDmsFvxTorPbCWEMmHK2ZWoXEMsaVUhIL3b2reHEYQybKK5
	pIPow8SKs0g7HMXG49cLlTF8Vp6LDDc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-44XmG_8AObmdl6UXb1sOMA-1; Fri, 12 Sep 2025 09:02:20 -0400
X-MC-Unique: 44XmG_8AObmdl6UXb1sOMA-1
X-Mimecast-MFC-AGG-ID: 44XmG_8AObmdl6UXb1sOMA_1757682139
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dde353979so10851835e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757682139; x=1758286939;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6pmjetwrY6Pjkps/LwmTPHSQvgSA/RNS+9TNChzIHs=;
        b=D2FpanEaAxkm1oaVl+jsnOEfoEslUtjd3HFErXCOMeIYrucpeBYDW6JfCIYWRWWV5K
         DWl7Zk/zLMAwth8n8SBu9XgAkbdRM80HRJspvjPlvFRo2CHeRJrDjnOF7vSBuxhGGgsA
         ypxz1DoWYV5KiCPpbxHAGxgZP0Bsobl9pagZizCyUTm1RW4qsbJgEBUAqZ3VUVx07fPE
         A1ZpZZuxnJ9MXnHOWPayxqqgDMVUAG2w4FZ+1gtaHIN6fu3hs7IWOpAYE36EhQUUJV4w
         5zkq2sTrm4bSkwH7yWgClWW9fTmyvYBG7ICj+jrpWW80s42r20VmSqyeUl1c9q17S6iN
         mKiw==
X-Forwarded-Encrypted: i=1; AJvYcCU0gxjsMnzlZnhpCciVuHAq6ZIVuVtk/HnXUtRcFMDXaos+ifxbkUbW8kvY1sVB5oRrCmD2pkd4/Q==@kvack.org
X-Gm-Message-State: AOJu0YxGMFRPpkk+I15MXDhcdTYjHDWBPVryHm98TVIJdIXWTcFUMLwr
	D0HAcEchhXDGuntAzPahIMTBnYi5dmMlg4HbdXuFpmX56839RcAUeYRg1FK3FXnsbSodxTGhmcm
	Aarq1QL55HicNnaQayeH8Kh85oNnfK16BcZVWb+y6RcSyzCk1qtFQ
X-Gm-Gg: ASbGncssOmtTzFUX5KJbhVw+GB1479MjzFRP+XzmSDIa/CPXcngS/8UU9Wup2TMvnjl
	vK8EB0cXsau8suYodq6cGHUF3IR2qW4SPBD8QjxaRm0GWB7PulgUJ52+O2PZdx0OuddKakSTtPg
	bZmBxllMbKT+Zu9vFXueNyWziFieJ28LHw5LuF4EW9rZmClC80QsoMVq2SPCDfjrkGiMzGm6yh+
	RJ7ZX48CBPm5A+ug3YpGBB4a9yPcHPo7ZLrld1UFRCpeXOkOd6sgYs/fcAooMuVS38RAp7Toyee
	bmNeLIDCsx3O8BxwmwOogMrOFJWoU2Lf/hUd10LPYmxHCyn8Gnov+kzZPeyKezNWqgvW8w==
X-Received: by 2002:a7b:c8cd:0:b0:459:e466:1bec with SMTP id 5b1f17b1804b1-45f211cb997mr19987415e9.2.1757682139257;
        Fri, 12 Sep 2025 06:02:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8835/Sw5cx2XNXD41yV+ksXCYwqrt5aGn88DM3+Lr7h6frt33fSGmBjo6KK3fA6Iu30zVDA==
X-Received: by 2002:a7b:c8cd:0:b0:459:e466:1bec with SMTP id 5b1f17b1804b1-45f211cb997mr19986575e9.2.1757682137932;
        Fri, 12 Sep 2025 06:02:17 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f73f.dip0.t-ipconnect.de. [79.241.247.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d7c0dsm6591328f8f.47.2025.09.12.06.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:02:17 -0700 (PDT)
Message-ID: <b46d3430-fb84-464b-b053-490c6ea083da@redhat.com>
Date: Fri, 12 Sep 2025 15:02:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
 <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
 <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
 <a17ab4e3-627a-4989-a5a5-d430eadabb86@redhat.com>
 <9ed5441f-cc03-472a-adc6-b9d3ad525664-agordeev@linux.ibm.com>
 <74d1f275-23c3-4fd8-b665-503c7fc87df0@redhat.com>
 <248b4623-8755-4323-8a44-be4af30e4856-agordeev@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <248b4623-8755-4323-8a44-be4af30e4856-agordeev@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f58PKkF9gMuxlTBvcOopCZZ7ACp7Y-Ww-ycP77YLzRU_1757682139
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63353C0022
X-Stat-Signature: zstkmzmbeuueftira3sf9meobj8dfyto
X-HE-Tag: 1757682144-420107
X-HE-Meta: U2FsdGVkX1+X9B9LmBFVfqxibFjxSbRuALMP4aTbTs/xtAaf8b/t0ghH4DVEKcknXL2IFIkldM62Z+Rgw+LHTC7wQzLrwV40NIZYWXKOHgXm6hPmh+ENd5tToXXwIe5v7BfsPwqYhBbyCbdhcqG+K6cyZmnblpSfDg4IT//ihTE2skRCzT6aPj0AWfjhXGCUgbXbz+UnaHuoW1T7BhEFG+5ofkOUBVpxTpfmjjelEXuo6BAiKuhOsOOTeMFHTUUql9SeAO+gDr1ghJne7WVivvlIvgafeILZ71obGNIG8YxnxZJvMisrJ78kwlIaxjluQuL3zgJGBlatbAM9ISTYJrO07r/tFD6EQzpcPGdMudO/eZETVz2yjwV615iEWn/QhFqitLan1lc1ULp8mhZqOCO51pnRzFoVPrqpAg4uLIMtHtzR4wDAH1iVC7UfCWj8O+bTbOj3G7Zfe7CttPYt+O8hZGxv/CEVSH2t0j/aIznkPbjVfouEAB8AG1Cx3lakDDvK+Qvdeoa0j854k7lPUpVuyIFKWEzrY4T7P/hEvj2G7sEuK/CR5zD8GIWcB1JrkTO5CHu/+vXJRNn6RYGl2yma/gfw573RZpXSR95Nq+KF/RxUn+qwxaCRn1/Oq+JHsZZrxLVuGnSqBHbEJpBED9WgHhEPyC4jlfujRRrD2PTv5cUQksE/u07qRczZR3lXdjP6f2zufS3L9MRVFKX5hpfsbTW3r7K4NODKTHjRU4e7ViTS7Ahd67nuHn3CzWed40hPg3gg0Hd8yddm4T0u+lYsb0QMCjoWu+bYBeNkXowyAdV52dI3NS8ZyZyuFtrazbnzrke5VZLapohUOz7bx/ZmzrxjklGiNLhBA1+ZWCVjoMFZJOppcF4irbk9gQzbGPrToku1/Y1d7Fqf6cQjn1Z1VjQ/waWlgdaDcgQ5XWYpPW7QE8uEDDg8gxWq8+9HIIyVXVHcRRjE9+khrIt
 qsMMpPC3
 6EUOUgyWa1d24e+k/GIYfkwJbcaWzdPuKfpYAnBwD4ynRmB19gYDr3SFfiwgLW85sJFOXk23Lfp4ZrL7u13tiATr34sX1amDlQ3WQkfmWad/iB/0QcThe1rStryzLTZUXhjYUan069oSgx68r5tRXA5EBzfJXjUbVgVesU1Bq2d0wyknHAlwj2tCtiGvDExInM0jhpITNQX7RCqUWzWGG8sER57FXEavYjV5HJdDq/9QbO8F+fJXI+aNwfhXFIzn4buBauH+gLEOP6yAwfHv3bB3bxx+bkqYAFGNGn52Eegvs5gTO8t26yxmssZWm1A4WMfgeXoRk/utQ71QcS6/5lHG7rOUQ3UqMvFZMxQsqtK8NjzLR83QKAgbIUW5MVMUtst3UO0vuIVEqftUGYeQwQtz5GJs0Kht9gjlMu8+CmztrZB3H7TzQ8ACWIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:56, Alexander Gordeev wrote:
> On Fri, Sep 12, 2025 at 02:40:55PM +0200, David Hildenbrand wrote:
>> It would just be passing more context down to the architecture, right?
> 
> Yes. Namely this one would be arch-defined and arch_enter_lazy_mmu_mode()
> by default.
> 

How would that work with nesting? I feel like there is a fundamental 
problem with nesting with what you describe but I might be wrong.

-- 
Cheers

David / dhildenb


