Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C527ED5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 05:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB1B6B0005; Tue, 16 Dec 2025 00:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182FB6B0089; Tue, 16 Dec 2025 00:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0580B6B008A; Tue, 16 Dec 2025 00:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E585E6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:16:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80FF01404F3
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:16:57 +0000 (UTC)
X-FDA: 84224174874.28.5A89022
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id A74CE16000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:16:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QJDDV6gB;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765862215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjD+cNbyJGOMAKpBo5e8LJBh9aFpu4/6uuuLCwZXOF0=;
	b=S0RQFFiS5T8jaSlLeD7xUKA7GitOR2TldHhIsDCuXWb0D+5vQc+LcwHsrg8EGIl0Fk9jNB
	1MnBEDhul0M3BIpnc+S5j24JidU0BxP2ePMZ4yt7AeWI7SU/IjgmgTeEhlUCtfZmfR5Grv
	QCqpWrCJ0wwSkWE6GWKfuRKCCKy9av8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QJDDV6gB;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765862215; a=rsa-sha256;
	cv=none;
	b=EbLyUJ+aFhHwFaDON5KWVlQT4YC6PpoYOzKa9XUY+O8GlnyBWqUNTettwM1WeuIQYYbh4B
	KXVARyjzxZ4NDahvfrUBjTv4W9lGbgw9TdvKXwlVNQHDFcrP5m7ShnZmCLcVy5pe8b+yM2
	TiyjwFnynRAiqHot+7+AJBC4RKYqaiQ=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7fbbb84f034so183472b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765862214; x=1766467014; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xjD+cNbyJGOMAKpBo5e8LJBh9aFpu4/6uuuLCwZXOF0=;
        b=QJDDV6gBq16JqLhaz7pY3nCPaHYr9t4rdDiByzUpme9iEAixtJNO0E4FcPLWkuRKRL
         SB0hf0fYJJ0N+ys6Q+MR+dGs7r38T/dS5QcMX9RSR/1oinj6ZtqZ52ObiTswT95Vkr4u
         71kkyHm5wTVJfcWsE++NYqkaSsku6KeVpREeVkoprcb51FZTZ9DNFaobwLJ4R69ih2uo
         p8TKCygOYpDdqGZbmtlz31FeacikU0narhIf+2t2vE9LdmVM9i5jS8Bmqh+nnF7wLIQI
         GsTFj1xCgq77Htgal8yCb6Igy2Q9c913o6DEo5JMvcFk7+HFvmQiR1dJ8akJcp9my2kV
         i/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765862214; x=1766467014;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xjD+cNbyJGOMAKpBo5e8LJBh9aFpu4/6uuuLCwZXOF0=;
        b=jmFuZA1C0+pkJhklxQmg+/q44hLsKeHcPHHa5ucObuXN/0eSO8ECwpZA7zS9YMEI22
         W8/cXynN/i7/GDykcES8AndcsnjXcePzOZisEURojFkN7pYgC+OLT1Mu4WLv+bmKkTwI
         GO2NyemcGdbLXqdGPpDlQ20hZgZ6160kJ83CM4wmxVmNBKn2+4Cm4cjSyhpYLZg/SEK1
         kqWo2bTUMAbs6p9X5H4U1bfobGcK+6+RbR4lrlE0wnGPd0aL9SYRZaaW38SlwMxnFieW
         4jjpxjZHEwXmIx8WmWsDIH2a+KiUsoABc03SQlQX7HeUESigD1o1VRNDPunXOQ7t+nnI
         sfHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVth8OOAViQ77FzlEu6kH+z7tWpX/R+ajXSwJ3Li08MmSNSXO6TUQTmTNYQtuk8cjMK3y4FfsKSow==@kvack.org
X-Gm-Message-State: AOJu0YwWe7dzYfzWouaqeUG/WIPGl84GxAfRb57cEE80vqO8oKLw6qVI
	9MOTtdEf5+Ri4jp5H9p/pmBnwN3oRe1321dad1aooCixa+RvVxWHzFSR
X-Gm-Gg: AY/fxX6luZhnfojC247BaZ1/ST/SyQQpF9L6Ax34hU1uAAPe20oJoIMKuWzIQ014Dm0
	Fa2xHpxqz4aE6/k7JwAyr4MnrqVxBalt9OOks0/g0zd/49NsMFePE7jJkk7CrGPlYlYZcefgJqV
	G1MTyu6NjHVRVPer+SdxfwfDtPj08Z5yqn/BWYfnGGvkMaVRmcaOvC1kMvtXObnhkO5TPtZ7BMN
	le2xT9MK6LwLfqprhYXVqOF50lMPg1WH5hvXQa2EOrS+uIYLK4B6X9IpTPIBThQ1BQM6VA7Mupl
	lOVKJl8k0KEQUI7T1y5S/Cr0rE1TE/RRa8OudNbXMF6PgQ9sAqegjmXDTP1nl49ySkkb5ZoApXu
	u/yDK/22jz7YjsC8laHcz7FO0pLtoEoQap4mA9McXfcAxCXgTrC1TflWvu82buv9mfRXZFHaikv
	2CW5pp
X-Google-Smtp-Source: AGHT+IFRNBpu36xO7SS++RmJSf+Yd0YivNXXnhzhZN3Px6CmR0fp7AX2KZRojw083jfNpLsrb718Lg==
X-Received: by 2002:a05:6a20:5491:b0:366:14b0:4b05 with SMTP id adf61e73a8af0-369afc00407mr13380900637.65.1765862214371;
        Mon, 15 Dec 2025 21:16:54 -0800 (PST)
Received: from dw-tp ([203.81.242.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c25a87487sm14064659a12.7.2025.12.15.21.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 21:16:53 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, 
	Juergen Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v6 03/14] powerpc/mm: implement arch_flush_lazy_mmu_mode()
In-Reply-To: <20251215150323.2218608-4-kevin.brodsky@arm.com>
Date: Tue, 16 Dec 2025 10:44:45 +0530
Message-ID: <87345b6m9m.ritesh.list@gmail.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com> <20251215150323.2218608-4-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A74CE16000D
X-Stat-Signature: 8c64a4nch6bqc39wy8koer6ycdfn7ohc
X-Rspam-User: 
X-HE-Tag: 1765862215-679419
X-HE-Meta: U2FsdGVkX19BCbaHC0BG4Z1MpF03DDctKB/BqlwHJTvWuLOeCMJVn/Am9WoyeA55IufHRUiTV+k5zlt4s2IRHyvoyTAUD9RJBoFbZTZN7c7c2Fdy7GxqeT/Wf/FQ7jCTTmV6PVbP+0DX/cxFI+bDo5ckinYpDufhluJa1EIDdibBrhH1W8XqguhNTAn3+RFbpMrmXM9wC+JhbxIQJc4wXszddqiohrcmttyR562f60urqZ3EZz9iZyHlaa/FKoPG6lPtnoL8td8//9p3FmpSENVBiBCaLx1NaaZQE6EPSNxhUY2Wob2JnzNz1k/0S1Aoz7sY5YG9VzKec59oxGgQsqcpUAlK/8MXbu+pLZrfvp1Ii52dYjT9w2+AnJBzo7y5ENGw5O/dPP1Kbkwm3+P7KltHXINyWNu+nyYoJGvxqEc/TeoICwMKLMkQbyHo8R90T10gurocka6BRCppf2oOnMY/7+mlxYJca3UGPcH0j3WWTaR/Y0IwQNVRYO8XrLQuYhCyPNLjvdxCU9x7K2uiA8FOIxE1lkzMkanmxYr2zHV+bHbzRUPH5i571XGf9n+iMwVUj5gGRXQV44ZCEfo9yYKCZR15VCPRzdFdsvRCzZ7H9S9cPrS8mprpADctrAO2+qbCB14irH22VHoWO788ePVBP1+PIZhEcY2qv5iWj+CYFy7f4fNl0P8P65wQGlAFp1z95/qe7onXYUrnpnQsDmNdorPF0FLU9FKOAiYlzthu28/OIvRwZoZHHoFFnNpGZKuj9bikQZwaODYlJwO/QYyani0FzBglzTQ0xOMmAN7ILA4wSbHCnNv9V4EZnFtSvWCLB1dgW8eV/w/pi4zNwqs9JT4bzxormllhpzGsjAbXxF+obqrVlLxzKRIW6tIRHiLqyAQGdL5quG/wVmuii8ij9nPYwD5MMLEbv9VKHq0/Ptbr5LIOK0i2PIrt9OtFwe3iQFtPmM1wGRIs7Ku
 aikXqHTY
 dWTcDZumojO5/mMawRsND8r6le6iaiHghnEaLjTs7/uk7DSberqMOCo11lM5GHxFkbPdpONHYptSnT+aOLQDf28W+V7q0VjCXwgTAaF2WMnKVeXyYPDcaMODUD6yUG5tOe0BImY2ed72+3C7fRyA02VfeHFW4tgafhDreHvDwe4d+g/WwfKBzbeb1TsOqv4l+FG8gIXFFsYA9NFu1vt8VA6cryHsq11/F3AlAlnry4bfPKgUzkP9EEkZm4AcchJYrvEuIVj2q+OUtXf/mn45PWxQpzO/OCrKmnJ3QUgBpLVeX8nHClA2RQd4U1emT0pfG2QJ1T9I0H23IJirfMwzVYJIAzKquIcWSux055ous6R7lD494I/Mw7Kc+a7johKsptuJxOcto2pddtfwc90BaUPxSlUt8vMM4uIOmCahYcOi33ziaYKe5j+nBKt9+cNg+G7KX2p5gZlN8b9t+zP1ih7hfHpyQFacLZo7nnh40GKPMADoACUz9gFjft5thEGsMF1SrrdPtP7j1Oj3m+rRLRmYuWe3QTCDe3z6xfE0SEPoT2txIcvjsbgw0I0581wTG/SBeUzvmmavEdDgek7tHfN56Wr5R92fNjfb/sL8K8aL9+1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
>
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter. The
> radix_enabled() check is required in both as
> arch_flush_lazy_mmu_mode() will be called directly from the generic
> layer in a subsequent patch.
>
> Note: the additional this_cpu_ptr() and radix_enabled() calls on the
> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
> patch.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Sorry I was away for a while. 

Thanks for taking care of the radix path as we had discussed previously
here [1]. 

[1]: https://lore.kernel.org/all/87jz044xn4.ritesh.list@gmail.com/

The change looks good to me. So, please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

