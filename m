Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA68CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3952F8E0045; Mon,  1 Sep 2025 09:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345418E0008; Mon,  1 Sep 2025 09:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213F38E0045; Mon,  1 Sep 2025 09:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05B7E8E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:39:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D33913B021
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:39:52 +0000 (UTC)
X-FDA: 83840789424.11.EC07848
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66073100011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:39:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OhIIMhDh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733990; a=rsa-sha256;
	cv=none;
	b=VTIyXe+2W33I4r13p2A9DIvNMTBth+Wwvh/QgX8uBEMwqUevWH3Y4jGF/JkvRTy/gQQnwa
	vB4pK1IYCF621cviFz3g0hWBUiwQc46XqKCzu+50HEXPwEXnJ5T4S7HixBEHkEvL/d3pFQ
	q1zwW2S2w09iOjDHgkMSO9DZYKA3kuc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OhIIMhDh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3id/gOofLyuF/iZzklWJhNUkAhzxEH18RZFHORTa7Q=;
	b=uxkynj0g5FWJ445QYuSwratXixEJjlGEl4vh4A4aI63KLw29za+k0GCW76/MjDeRm0/g0s
	ritCepdr7n1B4v2X5KC2xyT2FeCafym+R/X92FYGGAU3xoakc+e81pzqlz8ocfTP43TQm4
	UmZzbTROXNOSy8SvvkIbttEOp+oMQ/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756733989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H3id/gOofLyuF/iZzklWJhNUkAhzxEH18RZFHORTa7Q=;
	b=OhIIMhDhN0R9e+Qpi4e5rhyVhRYRQcc0i7MzxZ/PzPpDCXrV7EI5Z5wzzXSVR1a9nxXWYI
	lW28PCavEN3yDNWWrdQP/UTU9w/PhTXyBCXOrWLH4r2KlgMvNUSyTEfmbAPZI6A0fBESuY
	s/lWoMCFvoP13WdsDtmRy64Dg72jUWU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-EX9OjilxO56m0Y9fBDW1Mg-1; Mon, 01 Sep 2025 09:39:48 -0400
X-MC-Unique: EX9OjilxO56m0Y9fBDW1Mg-1
X-Mimecast-MFC-AGG-ID: EX9OjilxO56m0Y9fBDW1Mg_1756733987
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3d48b45fad0so944613f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733987; x=1757338787;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3id/gOofLyuF/iZzklWJhNUkAhzxEH18RZFHORTa7Q=;
        b=XRMaAV90DoydECRoyKh7O/+tk37PBjNONddnQuU1UNJVmRRV2JRp7FbzCyfw8CRpIQ
         Yj+OzNrZZ9l/MdD/faxcmJgzhaQCMMFyga5Gln4VXIw7SxAtoUhrwex7/aSs/ASr/6Dl
         QeSxlTocPk/tU/B1Ru1E8cnj+w8NtNtwhh9FfWamT51H96kF1CIusUe2HUu5oYMsYQis
         AXOYlLiPmvSA9bcEYXDhk6bTZV4FM86tlsVVhsJjQAVzfdPAE54MGRHHTLYtmeEahGtA
         sGPePKDL0RZiWb6MLJipTiQqQKjncwOJDpir3oyJJ/zNzRGO3t5XtKLHsyOSf/08KCBf
         0g6g==
X-Gm-Message-State: AOJu0Yx2iyG5yPF+8LchVJpoppIHofZLaA8qNKDpoop7xr8+6vKGL9eY
	3owqgQIT5WfvZw4cm6nCM+9c5nxkK4iXtkTB02I2YgNbwZzO92dkNivCTfV73zsQ6S/ivZ/S1Kx
	pHXCzpL655K79QUApBiFGEqbitg6nrApcYlQJl8vgvs0ZXImSmcMp
X-Gm-Gg: ASbGncvXzGlKyzrfAW+B1SQoyKICLhhsZ7Qn+RJ2zTcBozfLyoHEvZ1AcCcRaNmLu/G
	mchIp3J0K5iCFxPBcLk8K5id/BgYPmTI3ba6DXfKUHn/hu66nMZk4TDmNvngxPf6yPL1YZH9UBL
	xKXHvj4JeahI/YjI4eOHAQrG5WdDdtLktWEzimdgf63eEEQQE/atPvNGtBry3xN+On49jSTEJbq
	9JJrZcUbCwIh6HBZ+UJQ/nazTpn6yfHBCfsgnTWr8WzNzrIm44IN4Ce4LAckv7t815/NToCaGP6
	cRQLT3sXqoEbo70KULsR1/4dF5hTMGLE5aVRmvrdBh0132Ty/V4B9/zqn+GfeFUnMCILlolx3AH
	aK9ylPDou5uozj7RcoprdHNUUQlLV35/tQaQBtp59DQYhKBfJns8IblDev0yw4Avr6po=
X-Received: by 2002:a05:6000:659:10b0:3d2:633f:d02e with SMTP id ffacd0b85a97d-3d2634f1711mr4945718f8f.2.1756733987323;
        Mon, 01 Sep 2025 06:39:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF16bYB/CPbtI8bBu7Fukc9/QEkuztuZV5dc0Mxq3hfWjQ0mUxmJtka4Y09bvawf1aVKd4/5g==
X-Received: by 2002:a05:6000:659:10b0:3d2:633f:d02e with SMTP id ffacd0b85a97d-3d2634f1711mr4945678f8f.2.1756733986750;
        Mon, 01 Sep 2025 06:39:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm238421945e9.5.2025.09.01.06.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:39:46 -0700 (PDT)
Message-ID: <72558e21-2ebf-448a-a93a-3d1a3181a592@redhat.com>
Date: Mon, 1 Sep 2025 15:39:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
To: schuster.simon@siemens-energy.com, Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iIVzSuT96xemyV9rOjeUTHNZD0zxW3LVey6XYRBM3H4_1756733987
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 66073100011
X-Stat-Signature: ugbc61yzripepui9ze5xw5asah9ejctf
X-HE-Tag: 1756733990-905676
X-HE-Meta: U2FsdGVkX1/UiWOZmRwWbuKKIvyJMooK7Ln+T0OqKEnXXXsUPW0tWnHarlCKsOc1OrCZdseueRKTjVLLnlxWdTwA4gLpYVa4awm6p1jNMHOEyRbZqckawETep3Q0ynWq/gaQNYBddCs5UIE8JVHd87s5VvcPGKYHob8Z20RQKJtFn51gmfWse/Se5sAH1LwvNzqhqwTc8EZ1k2xROD7JB3YRCkensIr/7X06ekdsOUHjOcZJn48EOp/izDryxKptMbmI1mp9rSi8pGF1KlXPg61ZQenTGUBKcI3aZ6VcNfsFAlG0cNzcH5XTKHMDT++pQRH04Jy7zOLNJNjr5PkRAv5vkRdyIOwUhj5bKYRsp+iQskGEtGeSqRfm/eUleTuMQ2+tWLvOkwCbXp25YJe6kZxwpVmNf1OtPtA4wXh9gF6iDNH45n1YEYvtgnftPzOT0aJHnVMoP5t0I7N1o/L1jg/9uG1b+CAEdDabwgYrhFhildL7HpGtO8aos4MCZIcSCeWwOq/aKB+UMaCBhlzMDmfgl8OWh9yOWM9qOaaclS1JboPrYgraiN13zt4iksGRdTGTPAPNt+HLMNYBjPLhII0aJg/G5MnDjLkqRZ5lacrlD9A0FDt9bR2Mi0VZtowNIUDRo2U/Z7e/D6q5uTVcimg81Q252iGm97dkWj9+n2pamt73qKytu4+GlpG4Qvqtg64AgFVerRRtdrItpb3jqjjbpLaOT9id+OhJCZtCjAOCTFKPLxC1aQm9AzuzAgAwTcd55egS4BekE+jVL3r59ANlfSOhm9ZhfYjjC/10V4kGbW2qCw+G8LCDSmSX8btoe9/InPnRmNRzDtgQBphE4yBZM+I9gneQYalmSKit6+aFH33oCpvdsikZ/C2QIqlODVX+Za3jPz/+HQ8QCYqGWX6Iw5YumdH8N8SQ3i618BOYqmsqqoqsl3LLt1tsE/ecZ0ryuwernMOUhkUYLLG
 GbsxjZwk
 s5EWrqq39VaMkPDgaiYLSMRcXXyGV1SVPsQuKODP0axqIp1KkpgnYOLntyLNyrtDzit4IH96n6toCD9YYWIDWavsWNwlL94YFF7VAONJF/l++cRifrSt+KX+aB9GBX2zxiX/LZCmdJKdlmVcXlgp9IfL7GyLbANr/Y7hYH8lA0417fdv22w0DlK+EQbL/WJiBmLSsQNJ2UIFmVAs5iYfR2uoJTmA+JssjVIUoZO+cp6T7fsYfhErRIdoi7BjIpF2BpiOTBikWzZsV18kcAkWlI4b+kLgjJEFt444wlq/PpVHeZd+0pYX5qKMjVzbfBkrZLRQkO3FXpQ7bSF3Cx/V38GqeOJr3Z9PzMD/G7hbk7I21O3pCE3/Gzk3uA3pyXYu8BniCs1KZTCNRbEOLwZT8EL75ud+Ng5v+F3z4E0mZWjhqSa5T1YXkze69KtkoyXCNW0XBjavo73w7IgrWlgk6XVtApB4az+s531NwyelRab2Tpz9tHxR0db+gajmXn+34EuE+gh7kz6txLmm6RvNGWKEMBjsHB1z+jmgf6ZcFsCwwNtuG72QP7fs9bRUkWUBxfm8AM5QaONBmeZzGaZxIEz8GHrZMaLRrlwpp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 15:09, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
> 
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32-bit to 64-bit, with a new type of u64 for the flags.
> However, for most consumers of clone_flags the interface was not
> changed from the previous type of unsigned long.
> 
> While this works fine as long as none of the new 64-bit flag bits
> (CLONE_CLEAR_SIGHAND and CLONE_INTO_CGROUP) are evaluated, this is still
> undesirable in terms of the principle of least surprise.
> 
> Thus, this commit fixes all relevant interfaces of the copy_thread
> function that is called from copy_process to consistently pass
> clone_flags as u64, so that no truncation to 32-bit integers occurs on
> 32-bit architectures.
> 
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> ---
>   arch/alpha/kernel/process.c      | 2 +-
>   arch/arc/kernel/process.c        | 2 +-
>   arch/arm/kernel/process.c        | 2 +-
>   arch/arm64/kernel/process.c      | 2 +-
>   arch/csky/kernel/process.c       | 2 +-
>   arch/hexagon/kernel/process.c    | 2 +-
>   arch/loongarch/kernel/process.c  | 2 +-
>   arch/m68k/kernel/process.c       | 2 +-
>   arch/microblaze/kernel/process.c | 2 +-
>   arch/mips/kernel/process.c       | 2 +-
>   arch/nios2/kernel/process.c      | 2 +-
>   arch/openrisc/kernel/process.c   | 2 +-
>   arch/parisc/kernel/process.c     | 2 +-
>   arch/powerpc/kernel/process.c    | 2 +-
>   arch/riscv/kernel/process.c      | 2 +-
>   arch/s390/kernel/process.c       | 2 +-
>   arch/sh/kernel/process_32.c      | 2 +-
>   arch/sparc/kernel/process_32.c   | 2 +-
>   arch/sparc/kernel/process_64.c   | 2 +-
>   arch/um/kernel/process.c         | 2 +-
>   arch/x86/include/asm/fpu/sched.h | 2 +-
>   arch/x86/include/asm/shstk.h     | 4 ++--
>   arch/x86/kernel/fpu/core.c       | 2 +-
>   arch/x86/kernel/process.c        | 2 +-
>   arch/x86/kernel/shstk.c          | 2 +-
>   arch/xtensa/kernel/process.c     | 2 +-
>   26 files changed, 27 insertions(+), 27 deletions(-)
> 

(Adjust To: list)

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


