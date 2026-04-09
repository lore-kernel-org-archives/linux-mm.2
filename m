Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5D4F364BD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 21:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1C06B0088; Thu,  9 Apr 2026 17:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB91D6B0089; Thu,  9 Apr 2026 17:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF7F6B008A; Thu,  9 Apr 2026 17:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDCF66B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:24:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B597139D95
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:24:46 +0000 (UTC)
X-FDA: 84640296972.08.A4D106C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E1A4F180019
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:24:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mwpb7aRF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775769884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FZgHmN/Rbigh+5tNj53A5Ca+IYqaD6SM5ykcg30XXk=;
	b=sb5qzY0+mdIgGKp4GuhXtmYu0JqH1pGUyBCX+u+u0NGTrEiFgQCEoYWzQBpUKJmQCDjbYi
	DI0heA8dZs05f1fa3Yj4QU83CO50233VS4plG3q4rcFftqsHOfKmXiBBWAKJv3A7mOQtTZ
	OimO5/qfsfjHZ4ZJNaoUCT9zkpanclI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775769884; a=rsa-sha256;
	cv=none;
	b=J0qNvPuLG9F0qbm1jzIcdXzc/nipnoO1eyEDqzzvpiS2z6bkbFw4ZTt41iWzKhcCNAxJ8z
	5+2OE6Y+ixClhmgJViaW8HIJk1FbO8YigqkVvmx6PAF3UfqenBhkRkDndi09nT+oU2pDh1
	4g2saWbuHe+WECp3POCCKsCf7Eu1sHM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mwpb7aRF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775769883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FZgHmN/Rbigh+5tNj53A5Ca+IYqaD6SM5ykcg30XXk=;
	b=Mwpb7aRFhxa8sKJkPoih+LiWbZuw85uwO1oSk0QUAj7tfeaG7jh+IC0qtyMric99XgpTR1
	V+7InL5VmQy7Ev8EIRzaOp/N7hiNd6+ZVNvto2er2c0wYILDys0t5zV0qYo3RrWsOujwW0
	+XdU+yZIwxLxCvnE1BwgzyZUOT3jlM0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-1ane-i4BMVemKVXb37YcFg-1; Thu, 09 Apr 2026 17:24:41 -0400
X-MC-Unique: 1ane-i4BMVemKVXb37YcFg-1
X-Mimecast-MFC-AGG-ID: 1ane-i4BMVemKVXb37YcFg_1775769881
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8ac04b2fc4eso43606996d6.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 14:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775769881; x=1776374681;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0FZgHmN/Rbigh+5tNj53A5Ca+IYqaD6SM5ykcg30XXk=;
        b=R7kYUO1+ea+t9UgmGsIy1CLLGtperfsyopKz3xMeX5kvc3lJuqC94vNhqg6oG8h6T8
         ix8Hfi0PwiD7JZtjcg/uqswQQAWx+Uex2XKmSRHNb3rVCgNKE3sc4Bx5ijTI94VuRQgu
         nmb0x46DCMWUW0bId3fwzwPIDSTXUievQuNJDJoCyvJF0EZ7VPeSr5K6BtcnH8qEMhKD
         xbPCC0a1S60dav58oFCi4YZIA7OVpkOqlV4gLyfA3BJ3QeDWg8+XP6eaCclfM8hXw44J
         YXapPmLxw7tcC/hCB8WJkAn3Tw0m0ZJJJWPJHhv/vqtI8PG7Q2vf3Oxno54O8iksN3CR
         RWGA==
X-Forwarded-Encrypted: i=1; AJvYcCVDDWXUEPl8f/NXGXE9o6nXOp/K20kUuwNRmHTjn0+Y3/g9gb8A6ra2RZP3mg/jXgYx98Zw9NroCw==@kvack.org
X-Gm-Message-State: AOJu0YxT3p6RzbHLxjEn4Gxv1MhVKtXlFAi6RMELCbIKKx7WT7acX9LP
	AcvgmRqolTHJHYHS1VukkS3ZB70xFK6y5cDoWQASEhiaOxiTCdoEg43q5YkZmP9cJ6IZreBuvc2
	ApknRuG0hHh1z7ELRo8Cc+w732kRq3kMFK9ly2ZRkmXj70Ki5h3Yi
X-Gm-Gg: AeBDiev57SZCVi0JHaL7sIpf6GYf8B+vbS9J1TCW9BkqAtkEjEczp6FwM7EoUhJpVO3
	TqUwDyso2gZOjsorwVMlLKxqdIyCnkZTb2lZGf9SWi23uickDiykdn4eNIC5KoE190tO6cgMRiP
	yIWAATkT553/osTRAh9Terf/7ldRFNTqxJTESc8gfbl/hHB4sexcm8126qFEoNjfa5l8JaOlAiy
	ywScQyXuszKEqAccmbs8t6GoHqbQmzgu1jMVjakXe/djhAvXm3sDGN6ArtHbbTYKZq/h4/2hsd9
	wgWnPRwKbCtBFR7SISYrf5HhYiqdBX5ahfpXW2qsjj01/j2LxyIc/U1iQa7tstKaI1+6jCjzp2t
	50psXO7KC8ZFC9S6GW1yYFONEW6di1sCrzQxNT/kv8veDqhlPAiMLquz5jSPcIVZQn9BEpdEkPJ
	5ean9bSUMfFyZtDL8=
X-Received: by 2002:a0c:e017:0:b0:8a0:f8b7:3920 with SMTP id 6a1803df08f44-8ac8620da18mr5916056d6.42.1775769881319;
        Thu, 09 Apr 2026 14:24:41 -0700 (PDT)
X-Received: by 2002:a0c:e017:0:b0:8a0:f8b7:3920 with SMTP id 6a1803df08f44-8ac8620da18mr5915806d6.42.1775769880857;
        Thu, 09 Apr 2026 14:24:40 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84c45944sm6173456d6.24.2026.04.09.14.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 14:24:40 -0700 (PDT)
Message-ID: <4f8f3e44-7d5b-4b8a-baeb-f42fb3e8a074@redhat.com>
Date: Thu, 9 Apr 2026 17:24:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] mm: thp: x86: cleanup PSE feature bit usage
To: Dave Hansen <dave.hansen@intel.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>
References: <cover.1775679721.git.luizcap@redhat.com>
 <16fe2db0becab98db70f53e4ce1422450a9f40ee.1775679721.git.luizcap@redhat.com>
 <F9F90195-D89C-4DBF-BDFC-311A32D00B9D@nvidia.com>
 <631bceef-d32b-475f-9d1a-644593aceddc@intel.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <631bceef-d32b-475f-9d1a-644593aceddc@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H6iqc2vOmQBvWEV75snhHijGtHi_lMMrg270VWoMWoo_1775769881
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1A4F180019
X-Stat-Signature: 99xpksbh7qfdzc9bug396syfq3fnti1h
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775769883-956114
X-HE-Meta: U2FsdGVkX1/o+7H1VDgZmVZZxAlfXcwiC9Y7rkFDIjwrkgF0NUNmsF8vmLzcf7QzR2r6uYmCbYve8rVGnT0glDoz/hV9Duzfq/8YkORRPhUbc6Hr7c336zuw4kjLDLIobd5tF2YluAFP2FWjXsvpUtmeWy3etl4tF/w8eAGFclk8NU0OKL+woewTIJLUKt9FVJr2Bd/3ISLV4N/zSK1nXN4sA5d1URxZyNJ+iRjEJFWK1irpLRf6YgZ8X/ImzYxaqkfZCZrCLhaGoeOPnDzfJuJKrtWoVWBeeqTSPVNlxNrs7Cq1okOYSBYApMRO/XRP8KeQCyABkKgIbk9VsMTB3q4HTaswQJ1yiSjGuNScmo2+WUaxVy4PxbPe8Xfh+dbYd+eXy56UTYaG4b+GIorQ0eWqi7UeTu1o/lSWUIqQ/P1TsHrCtmsJXCN+W2Zrwc6h54OcloaZBv9/2wk+ivaKTyHyvebj1mnLS16MBcjI6mn6PBaEQkBM3xwKvdeGMLTuPShUDL/D0rO3UHipbMD684YrixI9h+B3+kpyEc4erOf6C2HlDHunq2aN3daZuIHT4C1DP1lgsjk4oiy29o4ykkWO46ZIp27ou6TFbQBWWQM5UMQcb9axSifabj17tRnyqobtYKuCeqxlsHquIDP/oYO4OyWrbB5eyMuk9+IBFRbXVcqfR5bP0IsQbTVUJ686V0jeLUP+UJ29wr9KzzSWxi1klCw1sP/xAVx94Oid3eMh8EJRUw4YCAblqA61qLdb1xCplSU8Fgpamqi3+Jz5fxLwrJxCAYYhPFvlWj3JzaM5HPOy3dQhVF/0bFfSQ/eTzVw9X5hBEXIK7ifYDExp/rdpx1zLLv3fZuNiqIv76aHwIAMf+M4LUnzolqnHGCpve/Bb04C5kOxUfAvD5vBQB2v0+K7IgAKlRet3VfDtY+X/b4B0+QPa1lCaFqSIPEy7XTpeGQ3WpbCfcAiwwAU
 LrSs7eMa
 Y+z6w9YjYmTW0CwWwiKbEqOfei5OVGeyISBopbLlmPbFyPMgNlzZS7qY3M4SmmWo5iQwscxEv0BBozLyzH5JFrRwkiHPg67+/x09h9RnKGfB/AzBI9GimwhmnnDwZRlrhuJatlcOob/IuefADxuLA2DsWluPl16IGT6yUaIviWmfpGLcA1V/HXpCK3mOvcQflmVXpLbvfkNpvlGYvrZjmp9msLbArkr/68E2TzC5KiN8vIInUTA8kMuVM0++sT9+T12oz3KmKBp0Hso77kd9IznfHEoleRILDk6hyW37fWvGIS6Bhcc3XP5stOdI5sm9bABs4WA0W/pI3dWHIpgdRReyhNM9xVPOm0nWfQ82HJyRoyZgy0ld1s+/ZrekrLAS9OoGF+3EIhaMGm1VuDsElLW4C5FD1hKoPhys+B8PXRoEZ/Q4hbr4ysYWhcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 16:10, Dave Hansen wrote:
> On 4/9/26 08:57, Zi Yan wrote:
>> Historically, THP support on x86 checked the PSE feature bit to enable
>> THP. On 64-bit, this check is redundant since PSE is always enabled by
>> default for compatibility.
> 
> What do you mean by "PSE is always enabled by default"?
> 
> A hypervisor is completely free to not enumerate PSE support to a guest.
> Any kernel can disable PSE with clearcpuid=3 on the command-line. PSE is
> also disabled for at least one erratum (which I think includes some
> 64-bit CPUs).

You're right, I was wrong to assume that PSE could be ignored on 64-bit.
Thanks for taking the time to show it. I'll drop this patch for v4.

> 
> Here's a snippet in a 64-bit VM of /proc/cpuinfo on a normal boot:
> 
> DirectMap4k:       83836 kB
> DirectMap2M:     1939456 kB
> DirectMap1G:     1048576 kB
> 
> and with clearcpuid=3:
> 
> DirectMap4k:     3071868 kB
> DirectMap2M:           0 kB
> 
> Just to show that it's possible.
> 
> So perhaps I'm reading into the changelog too much, but this doesn't
> quite seem right to me.
> 


