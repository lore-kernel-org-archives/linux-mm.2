Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF3BCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2716B000C; Mon,  1 Sep 2025 07:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9436B000E; Mon,  1 Sep 2025 07:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8526B0010; Mon,  1 Sep 2025 07:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598186B000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:06:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E92384D98
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:52 +0000 (UTC)
X-FDA: 83840403864.13.03410AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C23874000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZPdIHbN+;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724809; a=rsa-sha256;
	cv=none;
	b=MP4BDKbtKLd+i8ze45OT/7nBcMP5G1f2mvzgGqsYG3EzY68NXQ8oGZeC7x1BXjlGS30GSv
	Scvt4OdZOEf7djRWxa+F8Qldw0gqyQWopl0TEHqbOEgvP777VpjwrwBpllsxcaVGH14eft
	Vb02vTSL/yaKp4BoBzbMSjwn6CW6e2M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZPdIHbN+;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVr1dt3a4WUVmixiCg4dgFeOh7bWE/lfiJ8EO3O1Gpo=;
	b=i5RAb+d/6C/mbkPwGeRoQ1hbf2eP9HH5FyLW89mEzyU8jh3hvLc2H4+u0Snuni9/7Nm5Lk
	dcAtSMnLitgRqAbLZe/Rm1yrdnhUfMxKebBrpKAuKUTSTiWkBKPfnpkrVrivanBJ1MyszZ
	OfCWmKEwXJRrADh2FE7nrzaC3W4npsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756724809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QVr1dt3a4WUVmixiCg4dgFeOh7bWE/lfiJ8EO3O1Gpo=;
	b=ZPdIHbN++ApZu5CtuDgqdm9dx6l7X5KuN5cuwHdpUPdgu1OM1m/snic2cEwk5THZgE3MOb
	0KCaYn8vMD3quLRv5Ho/za+v0kw99s93lq8pI8+Ts303HsryM50HCFwUkQXo/NoAeNX18k
	QM43RoHbtkHItiADf+LA2YxF/nxR0vc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-IhbWFqcJMzaTqX5h4IaA5w-1; Mon, 01 Sep 2025 07:06:43 -0400
X-MC-Unique: IhbWFqcJMzaTqX5h4IaA5w-1
X-Mimecast-MFC-AGG-ID: IhbWFqcJMzaTqX5h4IaA5w_1756724802
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d17731ab27so1980039f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 04:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724802; x=1757329602;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVr1dt3a4WUVmixiCg4dgFeOh7bWE/lfiJ8EO3O1Gpo=;
        b=qEip3utm2Mx3wgx9eCO9zfbHip4LaunRqur1EvGNOc10AjpajSfrBqGvZMU4/iwwqg
         LSTUybh7YgWwPx+4579VIfenSzCX7TNon8vJZtWRdnMtKwz3Wszll8uaHRUYgtrL7TEG
         HJslXijKWbaSbVO/A951ZjDrr42vjAC0m+EOihE8fJFSzOsCxZWJitwiYkRWm+Samo0S
         tz5ccCud9Yu2dnINCwny6Vl5KAhN7K4/tgprnMYo/T8mAsU+g6iRPZM0S6y2ad6+/91x
         tKHVGRAF4c91t7OgEBfVKGvO7AWngjEDStaj2P60bP7u7dVSTZDTpkUP0ZT1G3UtFjN5
         8qfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSeZ9wdOlIcXYtBaQDZxpucxDjH5nbRXorOa894aLZcfbBy3Ov+LXF9hgENyqoARn2ui97G418Mw==@kvack.org
X-Gm-Message-State: AOJu0YxUhHaZAGqCAn1+Z6JbQQExlnh8ehIXrtNeffW2Fz9mBnJrcSjN
	IVoVkBqeB7xTG8ABVRmL1nksPrr51YBJM8xaIlk3U6lOlIDXgBgNBG05+HhPbGLDTUXQ4v7iUkk
	tcH/RY/4J/vxEtaDxjR6CznfTwS48DeMZfeP6mVtXEOs1JWP8Rm+B
X-Gm-Gg: ASbGncv7oTkDVXpqZd0LWTuNXOOgIvbJZZJ97KleWQa+iMA+n9nlZ2N1RuE1GpKkcQN
	Q3/gjSyIuQ/mEYbWa4LmQ/1+pPfMdH0ETrWWe9SMqMNNiqt8YmtLoCRcFS0k5Tue9/kkc+PfebK
	j/pXUwCsS7E1x5L+IAL5yeTNdkUR9ahZe5MZv2lMhx/4TgGw4mVmJLkLoKPHNBYCSVpxfYwuQN2
	RdYBaWmkjUbhCh++LuemXy2mZusFQt0awtPo2lR7AVuPXrySj2cuZ+wLrxGWTpTnzMWY4bKVnJs
	9Gi3vZk0Y50miJYofYn7y8xc58xD1tj2JjHgpyIJxzSJIzbbpsc0VBrkkzQJKyWtwZdxaNXvg8y
	fEGdT9lh4Mu+ahifw4QARQNJaUuLJCBfF2RUJcw0G5+ZEo4+OeMPCz2lwj0qhebLncKk=
X-Received: by 2002:a05:6000:4282:b0:3cc:19d3:8d78 with SMTP id ffacd0b85a97d-3d1dc69a1c1mr6067938f8f.7.1756724801668;
        Mon, 01 Sep 2025 04:06:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnFNLMPPscF9b/dFiH3ejH9LoyRSZRP6VErKQh6v400tD4mpYb60MjybBstgPmnFIevyHNdQ==
X-Received: by 2002:a05:6000:4282:b0:3cc:19d3:8d78 with SMTP id ffacd0b85a97d-3d1dc69a1c1mr6067912f8f.7.1756724801209;
        Mon, 01 Sep 2025 04:06:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0f85c287fsm12972589f8f.52.2025.09.01.04.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:06:40 -0700 (PDT)
Message-ID: <fe4bfa9d-2e1f-4f2c-92b4-7ac827ba471e@redhat.com>
Date: Mon, 1 Sep 2025 13:06:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer
 parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, conduct@kernel.org
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
 <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
 <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
 <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
 <593bf6fc-bb12-42bb-b763-383ca16e3adb@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <593bf6fc-bb12-42bb-b763-383ca16e3adb@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6h2ENuw2b9CEnM3JAuu1auRhLJ33MOfJmc2TxK0_Z0o_1756724802
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C23874000C
X-Stat-Signature: csusbf79g54ezzxni13a9unrbt8gwtbh
X-Rspam-User: 
X-HE-Tag: 1756724809-388520
X-HE-Meta: U2FsdGVkX1+EzDPjNZq7lHrhiXIktRH2rMtWiGxiXlNS1uRn1/pnYfxdwZfaBPNqd1l0jrKEiZBvMdJN9u37MqUGYSY2PaovzYv8CxGKOowq4nNUSPr/mzjNgCpA8CyIv8IIfu+sXanXqS6jPGbhoEuy0qdTU6HEpXJ+KLwYRQ/xsP4QDZ+P6DwrNqlPJXfTQa4LiPDqOR2TOuJTco3mrd7xoiNQA6xKTzhrAPphM+/U3vsp8URtubyM5bmSnXl+m196XAV2t1from6Q6ljN7485giW0L0k5RqaQf9yVYEdyv9fNmF+wPcCcQIAaj27ZLW3tgOw3FCg5PsxQn+YgbmMRcFgmILFaFN2drWb4qWozQzeo2TocDS29kO1naO0VJQYuxKHBanAlZJ0yD8AyD8jutK/lWZUqW4aDnFl2vBat1o7b3LdfEJZMbkSLThhRqniwMI87uj8Uoj7Tuchs2/EPrGt2hiLfuWO8CPKpgS5AlnE9DgeGTyTfSqlNwo6ZmmZgOyFIzWNNiafdfC9cRzuvQ2EmpZFWQDUP/J0O6QgFYCOTABhpiFu+4DbrTOfkFKFHJgeo0TZ9ZTdjX1JYYkdn/C6kzmHMam2JcHO7CWMURzAmcMi7cCbRNlf6mrAV3W5S2hdNL3cIp/wPWObHR5Lzrc4fEUG97puongVBu7KE1M/g/4c/15X9NFlBS2gxsYaqRlXAiKCv4s6SGexwFINb/psN/Y88djvua46jPmJuhsb8oVMTWt3BDGYq3tj3fSXr8cTkyLS+7UaRt9kDjocfeLMovPza9KI30fcBkdCbb0TAaQxuMk5xVPNgbdZgaldGMv4RD85/xePfQR1ThT2UDAVuMPLT20CLYWUGD6XfcpPM5MEmI14pAtONDEzPRiZvoH90aoEKBx+K054tTFawNLC+lxB+K1sWhabH6zWAKc4XYxvh0wVs3TkK2Zs1ui/yvwe+lsa9jQsUikh
 GlV2sRMW
 H5FjT7DD6UrTZTW7b1zKIcdxpP931l5GymmAu09+ftw1uhx8b2jUqvpwle7sszRa2muvCkHw8VVMwXj/+TSqrpgERZHFGp/TI7d5GzQiBDoAMzZR2WBlCdt34lG6Uw/uOlYUhqXmNRZB9OMA2VDWTKfUYMlKnPiQ8u3fIYtzpTJ0O7vAExvkpbuheut7fleoun616tFep1y/sIUIojx5RQywjtfq14xtJZS3cnh+jvnrO4nXbwL9OI7nA/NMvG+7sTSmv1Hi+KZMXXfxZ26tdnzXLeRTVlFfysooBQoUdV5+IcNIbuE+aa9FGhlxfGOng4dDHY7y1M9IBZCb9G0o8cfwyXBArnBTzzfdP77MOUNeAVjRnRebpG1UVqJmRD+4a4eukNz/LQD+jfsOjwX2W/OJ5yNeDLIzbMVOQLGtEfxJcERBpNbdkniat1ldv8RAdUg90y7TWceyUXgOerTIpJBPrPav0R5atb71EVnrZKVCUiKscDCGoEuRzNtmQqch30hAqwejilas2H75i60kqm8PUtGibpKwXJKvEFHliKclIJdrXAITVHAho30Dy0uPiW738RwfD2JwVPtcnVgq9FWThNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:56, Lorenzo Stoakes wrote:
> On Mon, Sep 01, 2025 at 12:43:42PM +0200, David Hildenbrand wrote:
>> Let's all calm down a bit.
> 
> I am guessing you are not contradicting what I'm saying here but instead
> trying to find a solution as to the _series_.

Of course.

> 
> However, and I'm sure you agree - I want to underline my view that treating
> people with disrespect should not be tolerated in the kernel.

Absolutely.

And just to add some of my personal thought: a good patch description 
makes the life of reviewers easier. Not caring about that can be 
interpreted by reviewers as a sign of not caring about review(ers).

-- 
Cheers

David / dhildenb


