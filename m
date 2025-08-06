Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D79C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 11:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F5A8E0001; Wed,  6 Aug 2025 07:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFB26B00B6; Wed,  6 Aug 2025 07:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE508E0001; Wed,  6 Aug 2025 07:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFEA6B00B1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:10:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE336BA2C3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:10:28 +0000 (UTC)
X-FDA: 83746064136.18.7CEE32F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7BA6BC000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:10:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d9auzkIH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754478626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XAY7c1HtX60oJJVxckLBFD/t6sL+wBhfaXA+lmyJDz8=;
	b=keiwI42aTljKmgFhRqntZaouz117FogSHo/VjVnzDHi3ys9ppfzIYFw/mQj65H1UVREKpZ
	eKv/GTfOwkrm6rw5s6wZ2qj+E0zExskDJirxoSvAAhddpA3wo7DkNqbi/7JqRRI72sh/Mo
	s04lgtb6I9lu9TKgbwdKkC66Doe3kYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754478626; a=rsa-sha256;
	cv=none;
	b=yZe3X87SXZNKT8eGaT7YqviQ+EgHwKlC4ozftBO6nOPeSWXuW78DplZX16ImNvjFLBWPaA
	RiyTcgECSCaXYhNtLc/r07FM6PEfRglPr/jhdT/bjBJVJ8VDINQwZhieaI/Ge65qdkaVE+
	7OdW9w9PuO+f9KkNZb2NvXhHA1mrrYo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d9auzkIH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754478625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=XAY7c1HtX60oJJVxckLBFD/t6sL+wBhfaXA+lmyJDz8=;
	b=d9auzkIHodNOZkfqs87W44T5Bj5X1EeFqunWV8kBhxBMvvkprhzWOicUGrWsKIgdGkBXow
	XCP4HnyDwyobxpF9uxPbsd5DfWJKTtD1gcRbWdwUuXL37JUM6EwKpSFQ2mOjgMbZNXQGhr
	EnF5Dt4pyHjaRnAxBP8pUp9rCfUtY9E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-je8vcgeQMhmN_USKPKWJWQ-1; Wed, 06 Aug 2025 07:10:22 -0400
X-MC-Unique: je8vcgeQMhmN_USKPKWJWQ-1
X-Mimecast-MFC-AGG-ID: je8vcgeQMhmN_USKPKWJWQ_1754478621
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78329f180so4659207f8f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 04:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754478621; x=1755083421;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAY7c1HtX60oJJVxckLBFD/t6sL+wBhfaXA+lmyJDz8=;
        b=n4kFE7ITS6Q/gprJUsCU2jf9M04daUNnAF5hwpVCz42nkx3E1k8bw5wWO7kbRFm0jB
         gQcSdIN/M9nYW1wdxm6BYoE0hUb+Jn0b7gx/2z/XJAMhZd7YYeQN1kM24cGYvuho7Uca
         Nsj1ULwWNieU/XiE5wnrUgtnLYBwQj9mJCh/ZN71MJyZsCtnXIONom+m8cLOLafzz/rh
         fyqNyXA69ATUeo0AoBL70ow43LSUDxqph005wVhLoAMch4Vg39l/Ff36OQKl9AbKVYEm
         4gM6M49oLXcpJNiT/K0aY3DrD6cNv3AJMT751yz+5hiYwZqVmIs3w/KOcxm7XhopiDjP
         IreQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkJdXDFQdnKkC/BprfmKAdHxj+GWjWuxNlw267JcOAuNUHjkbcki9r7HdAMLBcQ5VwHQrXRZCHXQ==@kvack.org
X-Gm-Message-State: AOJu0YyCfaOwAifCvm9yDi/kz+YUwsuUKAVFJwR3BPSAfGM4alFXoRTK
	VDQAfDdzsm7PF5NwTpmh1cN6M/+kvqi4q5YPMKq8N+uash1G0kqura8BotDFUERxptldvASVWq2
	GgL9vtoozc5p4MCCf02fSs+WFA5iWgDx2/kCt/BoW3iqbrbLPFeg+
X-Gm-Gg: ASbGnct9w8TcwAtADrdSX6RxSDE5e02UvHb16mXEvMdAOJqP2QDQsKUAJvEuZvtPFYW
	AOfQJdQJzNNgWaU+MwVdpprSsDr66Hw0Vb8muFhJE2K+EjF3qNY5oFZnHCI+HftxDiKGxTllUGX
	Bknay5BPjFNMpfvIWKuFdW1OTCijaqOwRaip8LO+le/ErEHxPJWSzOPH4uhDT1Ko1EzCVMroY38
	zBSFbC+zwt5EiAAgW1afkLKx0PuKjyGc9muQaAQ6Hj6PgzH+7rCtgPObUvek5ftm9/mDefBI3/x
	xT3tI+UmnLxYl7c1zawxa/YOZqF1vN8TPxy6/xrth8U4Uq4oL0w+RNZDUikpxKm7cd7m5N+R33W
	af67BkJz4Maq0RuyLqh0xnzuoimMCo/4Ie4SM4zwvYlFtX9W3qbngCxjci+URNXvMnIg=
X-Received: by 2002:a05:6000:288d:b0:3a5:1cc5:aa6f with SMTP id ffacd0b85a97d-3b8f41ab508mr1975846f8f.34.1754478621295;
        Wed, 06 Aug 2025 04:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQzGmG7gVuLaEDM5KBNP9RBSztU6v4bneU6B2Iy0jHsPSiD9zV/vDYLW9EhPrxzI/pFKH+Bg==
X-Received: by 2002:a05:6000:288d:b0:3a5:1cc5:aa6f with SMTP id ffacd0b85a97d-3b8f41ab508mr1975811f8f.34.1754478620676;
        Wed, 06 Aug 2025 04:10:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5862be7sm48237635e9.15.2025.08.06.04.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 04:10:20 -0700 (PDT)
Message-ID: <92ebd740-2dec-4531-ae91-0591eaaf6281@redhat.com>
Date: Wed, 6 Aug 2025 13:10:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-08-07
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D5ZWzktairQYvbDpHDj7WL2Y9Rb3wkhDFASG3MZv-Fw_1754478621
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: okg9nshzoopawoygg67tgatssbsspcnb
X-Rspamd-Queue-Id: 7BA6BC000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754478626-575495
X-HE-Meta: U2FsdGVkX1+cjRyMjDJaE+mESwZjtisLkCZAzZc6frK8NYcc/OhaygCMju76+rjMszFqDXNQWaVvJi2tMLsD180pFlHXLg8ZXDZM9z3CRY6pKYXdKpryo70XURDTUVMfPf5uwMd2FST4SHtwJfg7rqde9GnrIUCYqmiYp5xQgNVNdPP0yeV5wOO8oy6gvi0QrGQWWZl8kWWh04iikIsYzsxAeZH2JpVPwabdyx3wt+NOB42QCKqeLYR9jSfPmGihM3ZFhyNTE0509wnNOTh/haJlknSxxvRZ1oEcDonYaiDuDu5eoqylIk6MJD0y3ODMcYgrDos5rKcoaoCA41OI3S2HwzQ9ppPwphggwgvkmbXUDVWICqV5ksWJOpxYVVZmJgnna5HJhTEs+eiQQgp/J/d9cftc7sN1SqMhCs6cNP9zMBGwlY9f600Jrw9czWn+03fQKxxGuj0C1qwuJZqQ1j624kwo3mQdP/aFJiivFlfrmmn3nIavqW9S9PTGlTVHgqT9ohq9xpVP6WzUKqhTP/TOawbAguVL/i1B22qPTmeDFiH1QPvtRSYJqh+a/KhHYRosJaALruWlFs38sqI6uUO8A+X2KhvbY1iCZUYOCIuqo2Gi5hLjy61W9rYtIW3Qvd59H5lTCUJf7kI9YWcilc1FYb+zmESa9fGbJyUluu1W+4smdLdd/F4kIOltsiBbEku/UgIe+Uh2MYQD+G1mOZ9S8TSdmQJehyp9o4vbV280Xwq511aP53VdAvrAr3AtlM1fRURXL/BcM2hsNPpTdM9X/aqps3jRBx+e2PNCOADSrZddt/a9hi5jh7mIqUWl1s6h7bj8fGhuHFUiu5cBluBtIU8FT0AHDzXfsTVI914UqBELJ2ik3E+9t2L8xqC9y7UfNBMfWaTgv/10I64TFSPD/B8+qfVt/FM/L6FH6sBfviIr0YgGr+CucrslDaK43ZN6GFAPbeWnuP8/t53
 uxQy6hoq
 IMCAubpPDTjVewjU2EyF2SRtKaOrCgohebapRiJpg+vWxgVuFDILg9aFOV60pdXtV5jhNiTRGUgSW5TN8dt3im0qhlZUFB0B5g0jtL6gyCY14izXgiJiBIx80ewI2415+vcCBz/n1/MI3LCI7AssInNEOYhqR/VpQtG6ETQTdTbmPgMNh/GWtFdMTSdaZ22qTbEbqRflgEhL8DlMb5Ion2Mi1RvBGokfYlztG7xl4RJT3OxnD7lC3gqX2/vu2KQ1amo+HV+GqTHS+LsX3c0dkEjFnZg1Xfw+xKd94/qUvFcowvvgLbLD19ENYS566TP7IgyTA5YDLl6HadOPbdCZ298AMhYHh6vOaYibqSVVxRnOMcE2Qp5Wt5KFXkdbDuS3SGna9OQkAX/7KEuftVMh/CYvHkKh4CuV5EzrYH1vWG5pBTXbLNmhgXVR9rnxyNZ+/GO7QsLaTLF9KmfDLnreqeCmrpdYAK6llxa411iR1XCTO+npHdRoiOZ2JGHw8fKd/92cJ0ynBXAb6wJ/mQpk8xfjyacfCcEDUqcKBD7bRt2OvS+l+O0oO2YpEWEKaUWh4onLimuo1qx2VNPtlPw8LxVlBpdJxpGkMSSO1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday, 
2025-08-07 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

For now, it looks like we will be covering in this meeting:
* Using VM_PFNMAP for guest_memfd HugeTLB support
* More on memory failure handling

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


