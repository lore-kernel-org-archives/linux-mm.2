Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE36CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 22:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF2A8E000A; Sat,  8 Nov 2025 17:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA65F8E0003; Sat,  8 Nov 2025 17:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E36C8E000A; Sat,  8 Nov 2025 17:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4A38E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:25:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 402FC16082B
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 22:25:00 +0000 (UTC)
X-FDA: 84088871160.14.B5A3FF9
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60BDD20005
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 22:24:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of djvasi@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=djvasi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762640698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rIK9zYAgTOFKn0gaT0fUYRv/pXw/XsmvNmFsqqYFUAk=;
	b=h++I/YxOV+7NZJzckrBAF977PnzxZDFMz1BD2aBkHPae73MFPd87Goo2KBHOF+KppLBLuN
	nsege5CwS/fTZ9T5EB41G8Ef0b07cGG3BN06vF3kA2xsiR/tlcBnb2B4yQX3B166xlDNCn
	EP9wFoGYUxA6JLGSqNJScJ8Jy3/Okjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762640698; a=rsa-sha256;
	cv=none;
	b=QHtRZtisMt3StosjKZDUiB/LkUDLzh+73LLvwWbmJtlSD7w3B31YwpgN+lASxNN4Zq8eHC
	PDrcHrmoB+Iz7ow6weelN6FYGYvYFcJuG9qgiOj7Uc1q9rer5PI5UbNT0MtAIcqgtJmmoq
	s0u2VDI8VsEf9eZIIJH2R7swWkTfrAY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of djvasi@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=djvasi@gmail.com;
	dmarc=none
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88056cab4eeso12425986d6.2
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 14:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762640697; x=1763245497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rIK9zYAgTOFKn0gaT0fUYRv/pXw/XsmvNmFsqqYFUAk=;
        b=pVDolKGdh49n/+L1HhyUpbOLsUKdbmteEyLS5MyYmjvTWaY/4VLzTM1Kt+xlFKMVLF
         YXX6PDumQA/8uuLC1RpQEfEdxkII6aEV9dyX56VWKeomEYOcT0BK/KboRGHzmpmoz2WQ
         a6ntgENK2lZ81vzmzwyIzomgH1WLFrZbsl34r5wyst/13D5pqA4pLk+SdeuAOhYYGpA6
         oiEa+AMjKI/0uRrIgQaqFa6sRQQ3pybMBn8OJV7F+CWyUIaAgkLrv003lkDIVWIJC+Pm
         u4FpFufW7NPrHILlknvfFXy9j0gbfepjFWb5l+GIurAGejjts/ymhSWRnlEiWiGxs9F/
         I0zA==
X-Forwarded-Encrypted: i=1; AJvYcCX+jGWnvSf037tq7JQhvTF4rNr6CzgU2w5gnIhz1XC6XQFzuDGe9q8E7ABUj22GlP0JAl7qE+ggCg==@kvack.org
X-Gm-Message-State: AOJu0Ywk4iCyZYMzrGSL9MDJJBumFGdw0j8Pq/7jQ0TtOXmBIk4XvLGf
	msmyJLwAgL3GCExqL21tyJBaMrn7guYzZB98begBhuUGGqU0wjumzC/v
X-Gm-Gg: ASbGncvbez9w/Zyc3H8DA//6YN6W7M3LOYrrPC5DBDcQ07VzSe6W/pM7i7qqZa5RGv3
	HCNz101HV4FFulmeglDLpoRO/j3M8wUFsiyGgCi2OQ1UnG5Fl+fc0Ox06Gce9Q9ECMoAZoeTVbC
	3qvrBbFl2Bag3SpyQvHAIWOvsnDOG7JQaPnlIvgRXhjstxumVn5h+oTZEa6RypN9sBos01MMy9j
	fRQgzEd5sOIIoXKVtJZ/dQ3eZwpC7EbO4zUu8pPO4BVj0eeIMzzeWK4zcPHrSRBiHfum5ckDj9U
	qdYE8gceKUI4C2oTqYAMMHhu172w/Q8TthlMezOeH7tCmyvNCaAJXdaCZ2MgQPfNXQ7VFd9+Oa5
	zdrMBb9KR2r+sVzVV/Fg9RaL2V4D7UrwlEOG0wyEE48tp3UaE+7ivBA4SqG4vIdK2/imHz5zyLw
	Jp
X-Google-Smtp-Source: AGHT+IEjXFwr+Srm4QmfVRgu2vNEak6lu57AWOlSK22OF1wICTm1uk8SpWxSTMr5t0Nyhn7q3c8MDQ==
X-Received: by 2002:a05:6214:daf:b0:880:5851:3c61 with SMTP id 6a1803df08f44-882384ae832mr39079716d6.0.1762640697346;
        Sat, 08 Nov 2025 14:24:57 -0800 (PST)
Received: from [192.168.2.45] ([65.93.187.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238928a80sm21582896d6.9.2025.11.08.14.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Nov 2025 14:24:56 -0800 (PST)
Message-ID: <baf4fd6c-1796-47cb-a9bb-72521a217453@vasilevsky.ca>
Date: Sat, 8 Nov 2025 17:24:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc: Fix mprotect on book3s32
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Nadav Amit <nadav.amit@gmail.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-mm@kvack.org
References: <20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca>
 <878qgg49or.ritesh.list@gmail.com>
Content-Language: en-US
From: Dave Vasilevsky <dave@vasilevsky.ca>
In-Reply-To: <878qgg49or.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: riz1gkbcrajwbrf6fstncxic6ansytt1
X-Rspam-User: 
X-Rspamd-Queue-Id: 60BDD20005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762640698-307869
X-HE-Meta: U2FsdGVkX1+8uJHGO1rgXijUBf1QEwIn9Vu+nMelEbxSWy0vhRIgIe4C4h8nSNV76LEDgweA/xRUPcRyT8pP0aqmc/pV53PoPDhCSEOIWTA6cGsP/mf91o7SMfHSCy6tctIjZSZl3EPfgN/MKydSpH6YgnW3M6pJ5pHTqAI/+CzDrZxfj/0ULXaqTUpsqdpeyE4b1fmkW+VrOCkWjXEsTmXcICD4gKvc66o/jO8yoOYWXYvD+CV9x/6YU3Zy+5smbVOr/dnJrojayY5PK9/zDtlnzDHPnzHEmIXIn5nFxBpdwfPvUFARofxzXt/DC+Bs9oGIDRp9bvxtsaK123Du0jybFQC7G3ORzm/Q+0cmFvyWNE3fATUC319BbC3lwj9FkjliYsynoXUaHj56DpxlJFKYRGZDI/LI1z2UEjmib/rDN7FXn2q5pWrmw7k+YxyL6+kGn99UQWdVKHBJ8YmQPEVX6klSwLk33cTfIck5OToH6vzHbPvcs1X3pb9ZbpYlxd2i/hM2a4GSSm9Rmvm6QNgjRxX0Agq66IEvZn+pMdJsJbbRcGFB1oKDPrcdDuIDaQ/MyAfw+DcPnr1F/8eKKIBrKDn+uv6wWSg2SzvEX+PJKwiJQFcO4o51PkQI0vA1ueQRvt5uZyK6eSqi04FDfMZ+vuuE6CSuOsLiI280MEf6KwZMoh0un5gpiSc3Xqn+GUmNycb3MCpt9kwgv+HW/RYQAkwZYakahEtockmmD8wje5CVl7nPUDX32iU4AF/jOo6SQBWYcuNN/E+64l7Dp6ZXLfnh2XV23x2aImSw9+EtqtxQrXht6rSvnu4M2VgTzYbuH/tD9E+I1rcjzibCAwN9UqNM01SccFvv1XBlJ1An50Z+I1wTgczAWxuRwyliEi7jUWl/tyJzQzYROxQeLcNCKwbRCgth9Ee4N4/th81v29mB3XPGOjteVruCIaoNgrCqWld/sCbQoXKb1sp
 MFKrrgvS
 /DHn0XgzieFsyCNxP9ACm5H9/4wX2cVVGY5aza4H6CWs6YMfBvR/EGYsU5NG3xhZJnNNHcwir5HVG4ge2A+Q7r3SaVtUnTFn+HdPB1XPyPPjObdN3I1rJQsuwj0Qx5/oVAlX5J7o1ffuqh49XXdzWIr3qkkH9Of7r1Y8ju4kU/a81y6ujj1kmXcCFhkyJJT9q1Ew/RatqLVS9BA7RKNPoYO7gEtsntnJDVaccMz471Plr72ZsWJkA/hMSxLHwBggO8Oyacva8fBGp39oaD4mehFj0skjCwMR+K1M5Rnxo98fWxO5ZWxtxZ29maqvwSXsN7j+5CJdWgKs4DbYrERHmykgl69x0Co7dqg8kRUHadtXwJsRHVPPPb64WYOgFNZfjbqPE+50J+/wVoQKtXuT7TBElILjeA+BoJgNcrpPacotOWWDswDQruxfBk1tdF6f8R0Em7k0jQWjx4EE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-08 14:16, Ritesh Harjani wrote: 
> Shouldn't we flush all if we get tlb_flush request for full mm? e.g.
> Something like this maybe? 
> 
> +void hash__tlb_flush(struct mmu_gather *tlb)
> +{
> +       if (tlb->fullmm || tlb->need_flush_all)
> +               hash__flush_tlb_mm(tlb->mm);
> +       else
> +               hash__flush_range(tlb->mm, tlb->start, tlb->end);
> +}

That seems reasonable, I should be able to test it next by next
weekend and re-submit.

> Thanks again for pointing this out. How did you find this though?
> What hardware do you use?

I'm on an iBook G3 from 2001, running Arch Power:
https://archlinuxpower.org/. I found the bug because SheepShaver has a
configure test for mprotect, which was failing--I was quite surprised!

The bug reproduces easily on qemu (with the `mac99` machine), if you'd
like to try yourself.

-Dave



