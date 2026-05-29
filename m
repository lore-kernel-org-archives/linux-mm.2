Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56900CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFFC6B0088; Fri, 29 May 2026 09:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796F46B008C; Fri, 29 May 2026 09:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4606B0092; Fri, 29 May 2026 09:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8CF6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05E328B4F6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:57:46 +0000 (UTC)
X-FDA: 84820610532.28.3F622A0
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36BCDC0012
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:57:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=he5yjtqi;
	spf=pass (imf10.hostedemail.com: domain of 3VpsZagYKCEs5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VpsZagYKCEs5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780063064; a=rsa-sha256;
	cv=none;
	b=4COWl+LHkY1ubC4MtQF7SZ4rET9mBazyQC8+Bklve11qhjsrWrZQLd3gSKHGDyzdrnKw4C
	oJHCH7ib88brmgYL3Mf7fd96HjJULa36mEpJEI29ue9ymKCWDhTjhi0UihT3Uv6caHQ8Vz
	cr+RMDLFACzm1T4f2ngVaF1OYDVay9M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=he5yjtqi;
	spf=pass (imf10.hostedemail.com: domain of 3VpsZagYKCEs5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VpsZagYKCEs5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780063064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7V3EuRCYlsfPg0omB2BiXVnJ9x4bOVCssFd+7Pw8f4=;
	b=xZ8CrqF4HoMchtYbaGHf00JPm4v0BXAhKuVM68DnVmE1E7aCcpLcyJP/tbp3v7QIIhlCEG
	UMc10doEbFScl81IiZIiKbGIPIty/FQkWGGvGh/HVDYhA9hIJbkiBakEXywMgA7MgSUjmy
	chRD4kfUGCaudZzpHxUrYOGZ34LPpts=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c857ebbb0easo139295a12.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 06:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780063063; x=1780667863; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7V3EuRCYlsfPg0omB2BiXVnJ9x4bOVCssFd+7Pw8f4=;
        b=he5yjtqiu1nYQmIzyBX1cGMhlUAsmWL4YVQeIjjYQMYftI+TGoNfnPUUsizH7RpyTe
         Bm4sI+7s05swbu2e4ugvE+pULEfYQLIOdpuwd1f8uGsYQ48DojMH+3XH9Xn/A8R8o0P+
         Oc6qspPRd3hKBKOEhZMJFNmLQWopRIjSc5zcrfX1tq4e48KAp0DOR8YyqzEQEFb8i4XJ
         S/xqkBSdnOCt8gGIRMUr5aDCiBO9UwajppWA5wu4UD8WoLramp+dX0OkWWrnP+17rWq9
         kyOCAdTOFODeL/YpuHXjsSI3p0mqSVjiBmEFfATe+Jx5wm0LqUPiceC5geS6cO61CbYx
         HeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780063063; x=1780667863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7V3EuRCYlsfPg0omB2BiXVnJ9x4bOVCssFd+7Pw8f4=;
        b=klr9xk2WJIrx/LD+eiBiL1a4UvogDnc+/BrS0LbYwXV7jj4U8SL7sMnLVQ0BHeszuq
         GAmJVfwWpEXMYA8y6reYTz2I/Q2XZXn2vdL7f5zEdG1JmhtC50ZjsdCf4sJk1CJ8nQOy
         u2MorcUXeFbPQTakgMM+GwcdweCtDkEDgzVsnuA0cDXiu+/HMpMc9thVVmjHB+/X2wJ8
         Kxij4Fi5WGvHo/AUbFm9+c+KUI48SkdhqwvquNdQ7YBMj7KcJ9Nth1Y7OH6SBrMQq4yj
         VLXyg4hAwA+p6VPWsr+oNXXciO/T+99nEyGDS6F20Ous3/WqPJEv0W/3ZzXX8zkM079Y
         D/eQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Y7X3cCF/oyh3K7+JTBXThk6RLmAyOPblU2wgVmtOENLG5daztd6J2x6fbvo3OM5PNg+wT2910SA==@kvack.org
X-Gm-Message-State: AOJu0YwoixSG2PFHMJXreU1SvyXeBzfxd+WChZ0/dQYbUMvPfYOLERGX
	e8iCUiSOWwppMUZqaxZ1AA+Wckilfh5x2ppiwYDLeO49ZFiTmPrxrXYtara0JO0yr7gP0Z/3/4x
	3C1EbFw==
X-Received: from pgc20.prod.google.com ([2002:a05:6a02:2f94:b0:c82:2d72:ac91])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9186:b0:39f:3559:750d
 with SMTP id adf61e73a8af0-3b40fd77806mr3582072637.31.1780063062497; Fri, 29
 May 2026 06:57:42 -0700 (PDT)
Date: Fri, 29 May 2026 06:57:41 -0700
In-Reply-To: <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com> <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
Message-ID: <ahmbVaCUcBrYK8qO@google.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
From: Sean Christopherson <seanjc@google.com>
To: tarunsahu@google.com
Cc: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 36BCDC0012
X-Rspamd-Server: rspam03
X-Stat-Signature: t77arqitr4ygi4aoxrqqam6fnpeuphja
X-HE-Tag: 1780063063-166748
X-HE-Meta: U2FsdGVkX19BktzxazanDhgF+ic2YwcpdIogbl0DoQ734izVJ8GG4aqRt6n40RSEZCQku3zfLUWKvvH7FLWOftc75BiIKENdbGFFqlDQaaCOe3SV12IOTNEiskiNKJCtq2Nn6nWd2hgQDfyJykjdU+bfyMXZI5/E2/XMmEvdbJfbG+uEf/v2jodUJ6MQyPw+riYw30GKUZwY5zjFExbAdX2K/FzolAyZJLiEd0BfYtj+IxCbNPf69K1ktRNkCnhptS0ox1H4uFGWFYxKwLWENFluhScb60qyFFFAhWrwR46MyRgNZO1ZJk49uhw+tZ7LZiFiHLv/1JdPkz/WDDBMYvEOSz9WnCc0CRcjuPQ0i56toOcSTsDD9ztOP//Cx2vRQ4ASBukew4FEViB6qulCw6Bto6RcNPX6cBQVRkyIUHjppLlSqFNR/REkFw/p7xQPwFHhGIW2Lc61aAC/IB0kXubJfdT41sxyNfwsqC7TJJOR/ub/MYEjWLgFfegqujjovSPdR9IMkyt8KOHtG/+E4BxIplDjDSr93QL0tBQ3p/4hXXgPVgJ2i97KWnUBwGwGjlhSKcN8OCLxLJOKGWrsKCJ66P4E4BtDqgu/JfQDPCK4i+xUWMqbCHkpwzm9tSUFafzZXWUuACJct8vCJDnsz+6VVZuq7ibumohn32CIBNGi3m+xn2Z95ez2GDH1MCjXERxi1d5jsseP8q6wOPo5YAtO2QelmzleZuywGJ0O5QD4HwjkjWGCUnLxebXz45N0hu9V8b4H6SAu1ZlLXaOr6hgnoFlw+oUVxYgOfcEFbnPMdONJUhVQmIXwR/s/DxTs777sAwSakYQakfiyWXbSiuj8u6brItvSyXA4jNcqiCcRK2sJB7Xuf52aalIA2c9UydBGoIAIJ2AUI4uCl5iL1RtK82x3dmA0GPPXucZ+DTayj6G8s+xifOWw1QnRZ/ohw2IKWq1WdWu8CDWD9Lu
 Mh/Tqpb2
 Aykx5+dcHSuSmGdSn+3KWeVKvzvYacHmcdxnvghg94BQTxjiIRQkF/TG0pG80mZrX4YGJoO079iOZrDTdNyPHNAtvhuUGFNdP8D3yiq4yzTtqm8bAKGMCf1QB2GXZ4zIUsFFPokBPWjoUNd7rIt5fY+M39sPNSXb20ntYe/aLTxtmU/KfDRLU+V5scn2KpOBFC4PHx2u+A3MpKOYvy3e8mglUk6YTOIABLvkSBWqaWn0GdK7H7Y/m9huiQy0xYICqv5sh+YW2fk33eDbMeFBJc847mvwHjd4jw7obxdmR2vuqipf3N7PjQj/cenyAjYtW9YjhYL7Nv0U9bhParwK4AsZj96x3wL/DvmGCN8weTsXS2TsSHtG0GyAYPx61vzDgZLOUrTsRBiW3Im4dpgBipuq2mqquFRJerBbjVbJ2fSEBKnCTiG1nHuXrlpeSYCBO54hD+0hk9jmXRT/au6jwMDfxZyWl3mGrg6DFOyjM9QCvruJt67oibQv/uFCW5Oxi9Avvd7Q2QZQC4ZmG41/OOYeMJzp13qXTiVFdpQngjHP+7NnXixBRz3FyxLU+7Q4VwDH7q3HP+5jHXClz1yo6raGvWRXd2JTMd++aZfyDbiWbLtaZJGjTrYIHrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026, tarunsahu@google.com wrote:
> 3. No need to preserve kvm->mem_attr_array, as this is on deprecating
>    path and For this series, where only fully shared guest_memfd is
>    supported for liveupdate, preservation of these attributes not
>    required.
> 
> Due to time constraints:
> we have one open Question left:
> 1. How to check guest_memfd is fully shared. Currently that is being
>    done by INIT_SHARED flag. But with in-place it is going to change
>    its meaning and it will mean only durng the creation of guest_memfd
>    it is shared whose folios can be converted to private.
>    So for this series, I am looking for suggestion, what is the best way
>    to find the sharedness of guest_memfd which will be compatible with
>    in-place series. OR we can go like this (my personnel recommendation):
> 
>    if (guest_memfd_is_fully_shared())
>       return true; // support the preservation
> 
>    // This series
>    int guest_memfd_is_fully_shared(void) {
>        if (guest_memfd->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>           return true;
>          return false;
>    }
> 
>    TO::
>    // Once in-place conversion series lands.
>    int guest_memfd_is_fully_shared(void) {
>        if (No Private flags in (guest_memfd->attributes))
>           return true;
>          return false;
>    }

Given that lack of support isn't going to be limited to _just_ guest_memfd,
simply disallow preservation if the VM supports private memory:

	if (kvm_arch_has_private_mem(kvm))
		return -EOPNOTSUPP;

