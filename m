Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE70CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E818E0011; Thu, 23 Oct 2025 12:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564798E000D; Thu, 23 Oct 2025 12:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A788E0011; Thu, 23 Oct 2025 12:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3634D8E000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:16:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE5A25CCC3
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:16:08 +0000 (UTC)
X-FDA: 84029880816.18.C0225CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 484D320003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:16:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SW9p5SZ1;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761236166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF8+qm2b7jZrTE48PPY/DK3wP+sibwHsCL/pU7PiDjM=;
	b=Rzs9OE/LgljCTJfSbzFBXxqmCEMtSRDx3agoZ6CyzdkAPbcwsQJe3DulxMe5QeBIvxfsYR
	CTHatOWtEBd/sZRn1+qLM1j2BbW+F+tAtpwjmumSDUoUeVFMToxLbls0uJB8l2XhIXHQw3
	z4MoH8BDxXpKJ38ilRP82NTtiLUD8Yw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SW9p5SZ1;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761236166; a=rsa-sha256;
	cv=none;
	b=gPCWBeoBko9afxLnZ5iTuXiHLrhV7LznqZZ/IhqHGZEx+XGr2nvvlEfQKJLexo6cOZf9Oe
	DhmDyohSrM0YzRnx1CsXj4A/rPchzZEbbBhdq6p1QvkOPm9HfIDG0nu6O/iUXEZdU+9tum
	4MBXII5PkERYawEUJrn/dqiHp+HCtSs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761236165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JF8+qm2b7jZrTE48PPY/DK3wP+sibwHsCL/pU7PiDjM=;
	b=SW9p5SZ1DkunhlaLOVnaq8z/wpuB5pQz9/SemQ8OR4HzRXK1Rldbr74Nm4ArQ8S6nFx1tw
	e2nvI4OlgPVd5KSi+bsGtTnZ8yrzumGR27oSqsEisw5LOB4sEdKwPfrt9xwOllWu8fbiZS
	KKl59iqAYN1Y6q5B6SJmfcZPtgVzcOQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-cwS2EH9mPhe-MG0u6oYgNA-1; Thu, 23 Oct 2025 12:16:03 -0400
X-MC-Unique: cwS2EH9mPhe-MG0u6oYgNA-1
X-Mimecast-MFC-AGG-ID: cwS2EH9mPhe-MG0u6oYgNA_1761236163
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so14476895e9.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761236163; x=1761840963;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JF8+qm2b7jZrTE48PPY/DK3wP+sibwHsCL/pU7PiDjM=;
        b=DkoXu1Up7Y3bevT7U1oPhxktshtGYKP19ojRk6++ww+TVUenaTowmuGID1KdOfNLg8
         x0+n7QA4RkW/+2LpBbAh7yoCA8UEFAkPOlgr3vMharWILOtlOlE16mQtEeEwmmKDGpqU
         oY7A35jIhgP6W4srPXc3AhVpvBOVpJAccOiGoWtYO9yXkBvg+2aBV/jUTrCQLBbRzft1
         rHebq0iFCyforB3csOU7yPqIyk06EjRQKd6XdBiy/9JZlb0upq6hicSjrdSD7Fm/kDrT
         5AlcxPA8yttwD7w/e6ghQh9TYhsfKWamu4pmLHgd1f+rP+M/zhvfK9FL52BLLPX4eXR3
         R3BA==
X-Forwarded-Encrypted: i=1; AJvYcCXkKudYzVibS+IPZ4LENK50f74sB9IfKoQeIVdFafdz0rafyQJ/xOUALzjc5ppv2tCGgULWTRya+Q==@kvack.org
X-Gm-Message-State: AOJu0YwsbTnJiKblUjh9brBN9h93mGQeV7i3J+CqJ7A9BWmfFgl8Pvu1
	gL/ONHZaEoDzUIKzD6TqW9M7KhwXHbwyxKuGpM+Cwv684Bxvh1YhvN5FfqekrCJHrV9Reld7gdo
	pJzK7y6J7Fj63YUGkTtdrmu2aJ7SHIBnEAbMrEkZaLJ2RSaa95OcVnpSaleQo
X-Gm-Gg: ASbGncsm+DkrqkQRnSop59g2jkDqTQqIN1bAueMXo84vafQYlUQDLm2/jX3dP5TsQbk
	wmlvp3xUdT3u3OrY5jAhuXsOUMiAEE9R+t38DFwA4aCR8KWUUdmvUAhjOPxxSpPuTnweOAfw0jq
	zfK77vCvViUHZNpfUey+RtHOWMHrPmo00lJoH5i5GX0LaqQIKufukpWLLHcnXB6OQ4EYzBJV2Rb
	7OSJLKbRZ8dMqzeZBso6BaEbmaI8fylF6KmcgvKnRfjLemZhWCdls4aHryYncGEmspTzcadeJR7
	p8w+TIZUKLGrVNX7B33tYITH6QsCgUTMb0jxkqYRKLSb4z1EmSYH8QZuwiwp3RpkEZCVPV0XrZo
	RStmYKQiw70ZFEnnCsjvC4njaLgMBrQ6dMKPGayJprMbVpZDjP95f758l5MCRrKAi/k5/fmTCyr
	1y9cazLbhpZRb2PyyUisA1santPFA=
X-Received: by 2002:a05:600c:190f:b0:46e:49fd:5e30 with SMTP id 5b1f17b1804b1-471178705b0mr189600915e9.6.1761236162668;
        Thu, 23 Oct 2025 09:16:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGxwA3SATV0YOnZsaSJoH7DQG6AfDDy7Cc5CBBqZ0685TqgbVdTbAExPm3EWf90r/qAD3W5w==
X-Received: by 2002:a05:600c:190f:b0:46e:49fd:5e30 with SMTP id 5b1f17b1804b1-471178705b0mr189600715e9.6.1761236162256;
        Thu, 23 Oct 2025 09:16:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c427f77bsm107646305e9.3.2025.10.23.09.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 09:16:01 -0700 (PDT)
Message-ID: <c6b60121-61ed-493b-baa5-3d55db68435a@redhat.com>
Date: Thu, 23 Oct 2025 18:16:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Long long Xia <xialonglong2025@163.com>, linmiaohe@huawei.com,
 lance.yang@linux.dev
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <7e533422-1707-4fea-9350-0e832cf24a83@redhat.com>
 <122ef241-787d-4e8c-82cf-01ff318293a6@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <122ef241-787d-4e8c-82cf-01ff318293a6@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O8j1ZEy9ycG_WuRVMmeH1Lv7UswGEakQI4mA8v-nlJ0_1761236163
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: as8aw9pj1kfw14pxxe8ik63pznez3rok
X-Rspamd-Queue-Id: 484D320003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761236166-896811
X-HE-Meta: U2FsdGVkX1/1i+msclOOWu301nP5BLmeaNgbdB4BU/q8mmb1iaNsd1FSpGCeahmsHGIRPkZ3bNZoCxqN0Gblg5ZI9uknrwVgzegp3cheyj2z3zFVXMqHhOXEy+c4YJfn0mDzzZlhVmvVYDvvnPkgjrtW9Tx8HIgc2OcA7dthNETGOzD6WlV8E+yJXOWZU5WZLvp8gDYz/8MCTgsKCUhxB9kGM9hCMeH5YADsjk5kDmBxMYe/gxt9h/z+kuy/gYG78bbCCn0Qc4pVe4XbMsG4Eo35rII2B1fH3wCQgL0L4I8NDEPcpYd4zbDPD+s6I7ibPSPFcfciphV1fq5kel8CJoaLx2e/HZjGD9IPeYdKWpApybugf5MvlNSRlKU6GrS5pN4i1HgiSTi1Ipi0N01lqZMgVrtXoL02HcMsQ+9lZjqq2kFL+1nY/R7eYEG+pAmPzriUBw/NG5iG0OKaNZO2jVoYjcbtHaAnXU+SdTlm41f+lLMiJSQc1/RLqZ79I8S8sgGmDjoO4Sgs7+kJBTxM1aDqmODQnMA+CutDP1N/Mt4Ue7Q/zyuFf8vEzXAAMSIqTwZ/QtrmcHRv0MZ9SlqVvBNjRfm1hPjrm3ILHcekwnkEE75wupzsz++GZUDJcFLOa7HaLMQP0gg8v6+1zARdLbyoXGT+AcaH/f5KJNAh7/1FL1Npc6Rxg8UCDqEYVqc9SCsiTg4DCkp4UgTzbk/Qah+kko2FpUaYUigYrYSUhXVozxyk4jL/U+oAr5xw+G6XUnfyb5UzNFi7FN2DUmTkmvM+FmrzgVbYjd9Tfdafax/+jiqP4lgAK3aycC3XVSEoJgg0fgZ8m7WS4TYsP2k8HVEXSX3xPs7E2s++KSLjxNE7YdhAJzN9/rU0xEWXGBK9EtGOqyqcfjoEYqG1klwzgSi8F6Jsq0GEqam2wOMGKNjyRgnLVs9HCQvqZG1pa76E0UVOZwkhvNckxOUUdKl
 lFjEc2SM
 tKVyPilI2mj9mU2mibIuVXyw5MoD0KU7NcQ0uKB6K66Tx6nZppj/k3axZUqiCOk4hFWiy9bJKkCmRpu0EGwKi8hrrtISZaoXACChXt2Vkog2JCPLF8/XjO+MqkwhvcvrVHvJDZcpiOCCeRvYBm3GEMTidhFl0RDhPrnaUgjli8kUPXJr8WCumOJkIGT6RsB/hYuX0zvwOh2qAORCimUMa1IHlTcn3Lz4uO7raI3FFECvrUZMfqip59OIPJcaFy/935XKY0O0BlRJ3tc842kPo7qb47eRvZcSojsujSU+kUSCG7xzs+hkcpJIU9M0WAKkTMIxEdWzI6bXUtTv+1SPspx+OHuFhKvfIi+ODI8bW6rrBqgFOnCePVb/R/LxPez14/381MqrQPsEUOiA5a1wHSrMffIOJoB47zsu+GpsniwmjVza87DBUBlSYmZggpWjBklgRMexf3eN+PYfvonOJN/pxbz2Ezz/cql3ltessk9VddAHByufcGOVsDS1lJm1WBFknTDmINgfSIiD5l5yhlRcsZLljZsDpSro+KSrh+gS/LNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 16:00, Long long Xia wrote:
> Thanks for the reply.
> 
> I do some simple tests.
> I hope these findings are helpful for the community's review.
> 
> 1.Test VM
> Configuration
> Hardware: x86_64 QEMU VM, 1 vCPU, 256MB RAM per guest
> Kernel: 6.6.89
> 
> Testcase1: Single VM and enable KSM
> 
> - VM Memory Usage:
>     * RSS Total  = 275028 KB (268 MB)
>     * RSS Anon   = 253656 KB (247 MB)
>     * RSS File   = 21372 KB (20 MB)
>     * RSS Shmem  = 0 KB (0 MB)
> 
> a.Traverse the stable tree
> b. pages on the chain
> 2 chains detected
> Chain #1: 51 duplicates, 12,956 pages (~51 MB)
> Chain #2: 15 duplicates, 3,822 pages (~15 MB)
> Average: 8,389 pages per chain
> Sum: 16778 pages (64.6% of ksm_pages_sharing + ksm_pages_shared)
> c. pages on the chain
> Non-chain pages: 9,209 pages
> d.chain_count = 2, not_chain_count = 4200
> e.
> /sys/kernel/mm/ksm/ksm_pages_sharing = 21721
> /sys/kernel/mm/ksm/ksm_pages_shared = 4266
> /sys/kernel/mm/ksm/ksm_pages_unshared = 38098
> 
> 
> Testcase2: 10 VMs and enable KSM
> a.Traverse the stable tree
> b.Pages on the chain
> 8 chains detected
> Chain #1: 458 duplicates, 117,012 pages (~457 MB)
> Chain #2: 150 duplicates, 38,231 pages (~149 MB)
> Chain #3: 10 duplicates, 2,320 pages (~9 MB)
> Chain #4: 8 duplicates, 1,814 pages (~7 MB)
> Chain #5-8: 4, 3, 3, 2 duplicates (920, 720, 600, 260 pages)

Thanks, so I assume the top candidates is mostly zeropages and stuff 
like that.

Makes sense to me then, it would be great to add that as motivation to 
the cover letter!

-- 
Cheers

David / dhildenb


