Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1804CCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A65A8E000C; Mon, 20 Oct 2025 12:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D048E0002; Mon, 20 Oct 2025 12:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292DD8E000C; Mon, 20 Oct 2025 12:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 122018E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:05:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD55E1601DF
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:05:46 +0000 (UTC)
X-FDA: 84018968292.21.C706624
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id F026C40012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:05:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DbP5S16h;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760976345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4JsBaddaRYoEAs4W8WEBwtA+SYjh8zLzD82hzn+tek=;
	b=GMu1HPzDEeOZP54qdkdPDTBbAYmZnOEKsKrmyvQiAYg0+98Nznw8KXA83UbR94tkIu0xHu
	Ein2/RXNy+kIRzlDSRxGIUUbxMaUb23Hid/pm4M+ao4yofyIQOfMX4bF4ybrcbM0OLUYAp
	wnGN1FbL405C2zT31T+rISxm1ID8AtI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DbP5S16h;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760976345; a=rsa-sha256;
	cv=none;
	b=wg5AQNKXBGsGXhGrpL6Fx22rC8YnGlnHnfD4+beUF+5NoYKFqn3y73iBGdZEL+9EYaGkGr
	P1UxALoMX68Ye8rduM2aZqjLdk917kAxNjMhhtSPip0e7BwCClT0pKnzZGXoG6ygQtZC5G
	kdK2ztH4FcA4CeI1gE7p4BL0n00/stI=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87c1ceac7d7so69818546d6.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760976344; x=1761581144; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p4JsBaddaRYoEAs4W8WEBwtA+SYjh8zLzD82hzn+tek=;
        b=DbP5S16hulzoOHzfPCyulS90/T3RBYNMrcMdIhxdDfYdRJ+1NZh7fHK7l2EZ3eV2Zy
         8WUm+gh9KyfvS+m+m90qver0ceqoRx3yZSdbB2H/wEVW+2ObZ4EkMASvEQ7kOg3DbTFE
         9FZ5GZupjsH6LqVhotuwT+jSJclAlMImjqPLcPK3sGILvnpawg0k6HAApxoJ9RgJeF5B
         zhqBlqJRZ/s4OrI0U6AOTmT+9T4cONLLVbaytfjATHM5nMsVJW+EOptIx6Rr0kA2dqFI
         bvS5/Z5IbKKxU9iMnlDtzL0DCmwY1zHxASjAzCAN43lbJzDS2dcAp29QJjP2xqrWvFrb
         ouKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760976344; x=1761581144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4JsBaddaRYoEAs4W8WEBwtA+SYjh8zLzD82hzn+tek=;
        b=DqFO4hV5nGtGKdbVmFQ/wCNLb3WVJk/5U1a6Vwc+l0bUyTs/BEFpRVEkQ3sXNHv7lz
         AD3dk2knBbBP2s1Cip7XVVLlpp6zK/TZAl0rqeNj2agWE3oHmewhiCLtKMLM/AiHQgK1
         sbU0raPgLpxkwJ5vksBq7h8FFIMVrflqoQPomrOVjWFsQMQWDix2zapLiwMx5rPK6XUb
         gNe+fFseelnrLXVcMnbh6XeindPFTkL5yNBv/3jE/Nw2YWi6Hxm6kmRJCcfO6kGsPqpG
         gyPX/VDxNHCwJjUss00RHLH6FwBoAl18obSSt5zOXB8B7y+d2JViKKHj3V/trIIikJ2Y
         WGPg==
X-Gm-Message-State: AOJu0Yx9Zg26ZvXoot3bIlz4y6fCXFNFClRLyHCtGjK89PH/MEvtESot
	EMGHSK07UiiT0sHj+Lh09d6KYihRPjjevgSwQsu6Im75GULzcl7Pt5iHoYa4njz53OI=
X-Gm-Gg: ASbGncvBfQpUSoPYMfHBKRp/DAC/PLzHrhFaSLMlImL6WdAMI+ummPs0haemHcWIm/8
	PY7j9kBsMnCmr+pJovIxTuvZ+xHS9u6b49t0DsDfWid8E0cW+B9MKXdZcxhlkkcABNbnToKvWhR
	upKWRoIkSznaBcKdHklAAz2AHQ+p6ZGk2p4kGglaEMrgfH8Sd/X6IkaW1Ov7H3jGe/w/ymBQOSV
	SNhp5n2rv/iSL2tbc4YwhoAYst/Vx+7Hzp4nDKGz1TfyAlxdDBlbjSdKajMfHS/tNtDSri57xGX
	67DCxt0xU7g+860YICIkmTo/Hda3lekJMl+WUXO0Nmic9sKF22RJK0KNB9g4rqqI3Xj7zoiyQb6
	cd1ia4SJGtSRC2t3+o3Zi+lMT9r6FvkRuTwjzb4N16ohzUsNPonuul6VG0rxF7AD32qbwzjj13s
	RPdm4AeTy1sA/4fTousjNLXkCETN5IZK26Y1o9EQkDdGVKlZDynKAiQ8yd0dM=
X-Google-Smtp-Source: AGHT+IFO0Fmmp1MECEFi2jzErsOgbxowWqJ/ySBor/huje/sLrMYVoPz/DTL50HIV6LVQv5D46sXow==
X-Received: by 2002:a05:6214:230c:b0:87d:e2b:cdf7 with SMTP id 6a1803df08f44-87d0e2bd165mr123924826d6.66.1760976343811;
        Mon, 20 Oct 2025 09:05:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf521be67sm53378076d6.16.2025.10.20.09.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 09:05:43 -0700 (PDT)
Date: Mon, 20 Oct 2025 12:05:41 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, osalvador@suse.de, corbet@lwn.net,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, mclapinski@google.com,
	joel.granados@kernel.org, jack@suse.cz, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aPZd1dAIzAw7Ii8E@gourry-fedora-PF4VCD3F>
References: <20251009161515.422292-1-gourry@gourry.net>
 <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
X-Stat-Signature: s3g118mhzx6srt6zrzr3jfa3oi7t3t3r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F026C40012
X-HE-Tag: 1760976344-281552
X-HE-Meta: U2FsdGVkX18GY+FUhnm++WGWyZud5AHRQpJIMuMwPz+uYh0C4xgfrlSnOpAqtf5PCJATJ9C7J0lnvW1wQ5vx6WpGy+SMPpax4du6zjtopnkw2oTutG57KcaV2B9DXXjHArXUrEXQs23Sud0EYwU1Ryhcp2HFc/zQHAaaZ9QdmwxGceKA740gXR93fUMQ8mT2QJwSej0ANLECvpjHMD30V4eMjlgW0BS2BZAfBii5hZXfAU5MnbzU+AfY6PKR0dZzp2B4jJHnoEw8eBdIYlXuYvjEQR0/82DYytuYv7rMz9dLHbvSYOsp2/OBwKlpWl3wnqzcN42Aa+0H7NC5OGtAQyEdV1dW4yqS/G+09WDWKqX3b2S0InvuRf3BWvfMnGIdI4rgzmckv6pKIAVClYZqSx68hM5ZX1BALDfbR2U5XkGllmO7QH3f7s9WgiwwOrcEqmh6KZgtmy/tO7HWFhfEYV0T7kqaM+mmWBtaGXRmsjrHCD+NEBRH1J7W9bVBNv19ziEAwM0DQ/2JRF1hYpp2KcY+ISKqNQgvrQDLrJtYqeNJFPjPJtCcH5UYWBjgAzQvimOj2fsfbd4cvDEM2hGzS6MU+eNODWgxPMwuPHT63n2mN47l75PU1HJ45jI4Rfoh9ePTBIzDLOWki4VNtuGb7sH+1X6Hz43gm0Dyv+ZUfN5J4Fu2acIDmZnhw4gZ+0LKBJRul9DyMhDtetV56lh1XD6zPfI8XqMzEJanhbuBSsMaqmDHg6j5aPgKiobYoTsiiI0cwZigRzxb7jIESEg/GQmAfCPaiUbRRawAoihWTliBYCOxVs2ySrv3NNZNzt5bVjHMCxtDjQEnQCO2pX0Ohs2KcnfC2yzISCZZgmHqmKDyefuRWTkCmy8STBE7eViowM3jXBB+R2R3TNZXmn8MmAVAs+mpaY6OkvAq0CqNlA8favxML0T0bCOhJOAOep2h2No+6dsMsoWfFXZZHUK
 WdPqBs0t
 2xf5QvfCk0GRw6eGdkzEN3DxYavu6XQVQBjR0uj3VsoTkg/XTs4g4LCZkd6ibzxvo9PkhrEHvRrucK/igUNfxYM5N4ymiPFxKwa2iuQoYBw/cSzwdckkv1dWt0DMJHnqtUf2yCksyHMVBQ/LCcULXyUo6KEWcjzTmVSzPw2R3niuKKrKhe9wxiS/dsnO8S9EP8FTwMJkSi1IsiinEaKC66l3zVSFtAxmy2aZocGqnPmOg0C/UUberryFxS441XCAk9bsPudRyY34LOpyMrlDZZ66VIcyhHjhBZQFzg5g4GgLisjo5+co1HqH0mTUSvokvHJ9I8Ph9ZZlwN/ldVKrhNtb1292s7gBIg1qbAJnoQvX0/DKVvi05H1V5Q/g6kuEoXFdTVr64l81vz9mK5TFkIms7Kb3TlLgFwCDfyXV5xxUW8SGY52loyEUzvlbGI1BfEO1Yslyv0XovZhV3wQmUWQzpJoGjdGi/qOCesbwrT1YJbK4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 04:17:06PM +0200, David Hildenbrand wrote:
> On 09.10.25 18:15, Gregory Price wrote:
> That could be supported by allowing for moving hugetlb folios when their
> size is small enough to be served by the buddy, and the size we are
> allocating is larger than the one of these folios.
> 

I think this is roughly what you'd be looking for?
~Gregory

---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5549b32cdd31..5def2c53092e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6922,8 +6922,12 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
                if (PageReserved(page))
                        return false;

-               if (PageHuge(page))
-                       return false;
+               if (PageHuge(page)) {
+                       /* Don't consider moving same size/larger pages */
+                       if (!CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION ||
+                           ((1 << compound_order(page)) >= nr_pages))
+                               return false;
+               }
        }
        return true;
 }

