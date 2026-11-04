Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A7B606A851
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OCsdJg+A
Received: by kanga.kvack.org (Postfix)
	id 361816B00EF; Wed,  4 Nov 2026 17:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339896B05B0; Wed,  4 Nov 2026 17:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2537C6B05B1; Wed,  4 Nov 2026 17:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E16846B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:14:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73CDD1A0890
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:14:28 +0000 (UTC)
X-FDA: 85398841416.15.7CCA486
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43D7C1C0009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:14:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OCsdJg+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793830466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2FzhDRzTtc/XzcM0zNgPuhyPMJQZQhyp9SQGVRa/yY=;
	b=z6LkdsBUYwnJtyFHw3yvOmVC+CLonh9KLs7FNbw01DkkQzYRgXOOjLLlBpsIar3+/VWUVv
	Nmel5LSJPvmcSMtuxx8Q9J9t+INWhDpHJq2r500uraX6yXgmJpsAh+m+znkjWaHq+DStRS
	ES/q2CiHPgVesKLm/ml7WrCH/Y5DO4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793830466;
	b=jD7y7gNmOFXNOif4n7ENFAj71FjTH4H5LoAVxm47o0X0N7ueL2WTc2JSscNAO1FizyiEdG
	Nv7/A0B1zecEWTmIMbYZFVWohJiTXJjzpJtfV7RZ4JPal9d/zE0i6aMXR7vwK5hv6F46VC
	d+y5mOAneFBR0pFep89n2VjUuuP92u4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OCsdJg+A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso859731f8f.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793830465; x=1794435265; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D2FzhDRzTtc/XzcM0zNgPuhyPMJQZQhyp9SQGVRa/yY=;
        b=OCsdJg+AaRo+oRLDkIF+ich223nYHheNLkMnt9sWIvv2UnhbW7YQYOGp1gpwJ7inJC
         aBpKgHJI0q4rLNf/J67013IghZ/SYPxeoBi5i9o5A3gCr2EKnA0kzg4PNzUTt+CHzGu2
         9QPFDiC9i+gfQjTKMRfuei4M0JDPjV7584dQZMYlSKgrrKbfof7nw/nJFLfy+yDSavBQ
         uQ8HBkbrgno+9oQFXc77/kJ6uJI31XCDyF6G8MdEjH8XhqtOS/5TUtkRf9BzRM6RK2Wk
         M24J5xG2pb02seUHv+wnWJziCBjwLwPx+RkVG/u6/XIXH5ou9zysAaWwDB+Ks70raTHD
         2AaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793830465; x=1794435265;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D2FzhDRzTtc/XzcM0zNgPuhyPMJQZQhyp9SQGVRa/yY=;
        b=WielZ9AgAzi00Yfg8stjP5ZIFGInLySYktmiZz0g/Lje6OFjSnn2dtP/Vs8DYSNPux
         zI9JNxTPMv2gbEwldcf3dcR8+F4DI953OuV1wJkwigZM8QO69vIIBf8stTKhlq7kT9C1
         hjgLNvc3V5bQ780HfRv7VjgPAYKtCcK6dqSnb85/myZ2dmCwf53BVTsY0L2hDMT2bfNr
         2+qKYvGmnLqoZvLsYkJvDGp7MIjfwUWV6MNmYvQx9VXWDBVkR3fJV8vXTfRV7ukeL9X+
         PS+XfYWm3d5K3kaeq9mfSBrNvHZnBHF/+C5StQvwEP3wO2Bj1GER0AejqiRnqWh3rzE4
         cjNA==
X-Forwarded-Encrypted: i=1; AKwUvBzddzP1WaRKuTBb3DiCmXZwSljSlOGnWUqqRNeTdHbQgyAukWH4AOd+5uSbaKQ7EkjIEoQNZtnH4A==@kvack.org
X-Gm-Message-State: APuU4Z85eeyBQ73kZK7wvt9DKnMaNIRXd5uYrMRMvQwmE2dqiZAbjNYX
	+OM5jXQnE7i7yBfWwvWPxsuqUVBFli/nnc7lSQWhAu75XeuTDni1PtDyA6InNvIGxes=
X-Gm-Gg: AYBFou1nEuEeSM+GnDTEcuGPYtqTFZr1iqFA+FgPfl305iXLsen5NCH8HFz9CUOy4MB
	Y50CRm+pJHU7RHZ3L5hlgTr1rFGdRt7a/Csm8PBIA8SBtKOEl94xS8QnTDzV87ttjx0Z7tNV03l
	hsmE4FSdVsyXLqRlMLrFifuAaHcXr1u+/9SXmNMdm2wvCqBcMBaQdu5LRVZCvWpryBN9bczB9nW
	IR4lIGc8UrkEUu1+WzawmVe8yEnH6D4q7BDR3ogF73glhl3emZEld9SM0sELCbDLUKLN3L8tFW/
	ZujhDcinbmYqGmzGXEMlbu2nYcNMbri490SUtua8sRTAoFJQGwAIQTLPuQvKW6I7hrLR1YoEjTh
	4m/shF0DNdtrYZGnXlw9gWen86Ys7Nu5fa499Ye2smfu3sZgtmZ2SWY+3nODM1WtIErvOW8ZiGP
	rOpyLdvUEc+kIw7fK+W7GUAfzqKUUIiWZtTHQnWdMYRTLElfH+cOHIkFfnpYlA2bs52mWxdYIp+
	YXrbD06M+U9SGV906ScDYotN9RsdytoD5dvXGZykidvw1jyPV2Lhp6TNV1k3dHMns3WcfjMmGXP
	+e7oCZL3iW1NZrw65mHD82QIW8f6/EACpqLMi090iuTl
X-Received: by 2002:a05:6000:2c04:b0:48d:f7af:be35 with SMTP id ffacd0b85a97d-48e6e303f44mr39514518f8f.29.1793830464779;
        Wed, 04 Nov 2026 14:14:24 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed552aaesm6405241f8f.40.2026.11.04.14.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 14:14:23 -0800 (PST)
Message-ID: <ee08889d-4cbf-46e7-b6e5-3cf4fa8cfc6c@gmail.com>
Date: Wed, 4 Nov 2026 23:14:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qjs96uj1co1bb5k9hq3djfym3o8swsay
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43D7C1C0009
X-HE-Tag: 1793830466-391596
X-HE-Meta: U2FsdGVkX19wZz2vDVab5Cut41CQ7x0z6YbhGjJDmBQNn6tsVMAeGmDXy8olmSbYOOmmT54TOPNix7hpnUfG7qLO+7g5rs8HzI6gJYpdh9fnTM84n78IDHaXJD1cJDww79EDpmfq9XXI8FdXkPFSK8Ga2cpGK/Ywqd50XNDoO+SY2TEcoZEbPLB6tN92H9LpKOoCqPrsZIauWsc0Z7Cif8uufD390rp7Ik5gRrRuD+pEpq+152GOp0ce4gkF5zmzsTARDaZnmFt3Xu7U4cVJLa9ixn13eJ1Uu7Cy8hSKvyA6U01OIMiuVnAifWibJRQrRrbUsqy85zEW7Upiywl566UGkxMtq87b9QlS3dtjOGrLnXnbQSVauqgbnqVnkgyu6qapSfVfE9xH3WiOdL4c+sFoqr9QYsWYO+m+LxwhRAzbdjeMyw+iPNch9FZoIPBeDvGYH6KROBfYobAjqBRFXRJAohlYHxbFjkfQNfK4xv24FrYzJsMqFL0A2IDwxFaL1/y0Ig4qOzw8DS2MnK6MRef+dN3nULtE6DP2+krnts/ZDjpMyPfNK5pDLQw+S7I3GVlp2HunzKL8v4yhnvgONaC5dfPfTaVijR6MMrSRcb1qaYvuxsXn4Bx8exx2/fJuWdKHUwyrxEgmRoOgoE0YCuu3p8XWIzSpPGCzhw1ouRY9p4a4SEMVb8baLji+ITUYp/3S3jrn1xsDVXgxwzENXt4euxd+RKcMTVwbVNlijQh1at33zG5eKYN0/amj/L5T+gH3oVxdf7KNzJelWTH56IpW83x4LXAqH3NQv4rRw4rfyAkuh+Fl5IeL2PJznvYdQd/uDc5h1Iz7WG+rDPijgNoByffiEC/r3U5m5VPSle7YTAcyEzVlNvnSAlhL+EtDRsfekQM2lYIBICF3/kv3q8kyLaOXLjc0p7x7DeVjCqRzzrLaiRXkrHdosU9jvyf4vH7Xds3lYaAL6amCA6n
 YRzC2C6j
 EE/YYhfX9Atix1p8KlvaBSfRWtfNIjjGJSRSDA4nhlleGcOEktJQ/FazvAo2kfZs2lHJwzjUdGMrFdJhX7KHvxvRCXH4jbzTqNajXT3WD2DEFBwYaCYc2B56t5vPnzgnmlLaV1qpYRiGYd5yWIdzHSpHbemFQ36g8d4IrmQtJyDmplqWhnK+dAnjFXDPFHwJih4vwNUR11My1yBg1QGa+3IdsP4Lv4WdiZVUKvjirtwy03oS0pfhTGWS4shQDJ8QZyyW4JjdvgxOSsvJDs+3MoHRylOJEegFm0htrM8f3d+67ma0EBbhS+VzZrxK6gWWOtFDqKfcOJvh3KB82DIu69mgFyv1h4B5SFMQ+hXtOFmDHEySE7jmlBvf1qe3pd0u6KpMA82mDM6zxM1KukYbU2hwgYvTtIBRz3sGcrZ94F9sltJ2UBocobJJC1ERrIRL52vl5UMSc1X5S+pjJAAmvEw6zlRHotYQ0rns5ZDPmyBOOzyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 5:50 PM, Mike Rapoport (Microsoft) wrote:
> kexec_add_buffer() users may depend on the order in which memory holes are
> searched. For instance, arm64 places the kernel bottom-up and then
> requires the DTB to be above the kernel.
> 
> kho_walk_bootmem() walks the bootmem areas in the order they were
> reserved, so if the kernel lands in a small area at the top of the memory
> there is no room left for the DTB and kexec fails. For example, on an
> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> reserved first at the top of the memory, the kernel image takes most of
> it and kexec fails with
> 
>   kexec_file(Image): Could not find any suitable kernel location!
> 
> Sort the bootmem areas by address and walk them in ascending order, or in
> descending order for top-down searches, like kexec_walk_resources() does.
> 
> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

