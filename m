Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B00AFF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2FD6B008C; Tue, 31 Mar 2026 03:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAE36B0095; Tue, 31 Mar 2026 03:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0796B0096; Tue, 31 Mar 2026 03:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9915A6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:54:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F2515C5C7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:54:22 +0000 (UTC)
X-FDA: 84605595564.10.C03B4E8
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66E5E140003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:54:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="N/8a+sV8";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774943660; a=rsa-sha256;
	cv=none;
	b=mil5mNRAxB3flMY3cCDxzsDxE1ebUbL5I/MQNNJiru0+9z0cvXysYCNRHjkwbzbXl+5Oey
	ZwOQUwbX6poZ91IXKN/jmunvZ6J635IUw6VTfLOmgNskPXYflzdmORZ2g+pFIntIi/pEA1
	JT0AhruCf6bhDlJgmxkLuUe9Bh9ev+Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="N/8a+sV8";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774943660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wsu4DztMs+VdyrJ+OBacWYLGnGnECl84UeSFyFaYK1o=;
	b=O/+/gCH/pdg1fTjb5B5fPpoRSm49W55lZCL2rA0i/Vge8ArCELyh9aqd2A3u1KnKQSBxyM
	Fu7n2vFLO60A2PUqHSYIlh1RukfsD2IVmu6LoSXTUV5+RGVNC1ktcnrBmjVPphwtsDKOpD
	42bWaYjzVgriiGHHVnlD5GgAOhyl7jQ=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso47410995e9.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774943659; x=1775548459; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wsu4DztMs+VdyrJ+OBacWYLGnGnECl84UeSFyFaYK1o=;
        b=N/8a+sV8eKWw+UQUMBrHFzKmOZB/8wjvsgB7Y0qsUga9H81t3uraIUzbdwK7OvjXwv
         D/HhgVDhCc+22dxx2cKigSJQ1an9vz9+HrZQHLJfQVYeNSgVdUhO4OV88wuo3pXetQNq
         278yvVuZbOo64rx3iCiRxwB9R1ERPgG0s6uV/uXfECdB6Tx5dRilmTo9bfTdDGT4qH76
         dcdzQbK9C7KLrKPeWYg5Fu5UNWfvaquNbKHtvggcx6JQttF4TcJM2pVkzvjLaChOvRUU
         oI7l/PW3XmF9S96qi+zfm90YhLo0Ba9V7CeGmeOF5xuJ64tTZIU1uDF0KyQcIsJdutVo
         ETFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943659; x=1775548459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wsu4DztMs+VdyrJ+OBacWYLGnGnECl84UeSFyFaYK1o=;
        b=c+jt67JCtSyrUQ230fzfFNwpim+5zFwE6PTjlVwg49iL23ILSYmO0I6S17QSlSRmlf
         HsQbs3cK0qJVi8OxqMR7iVWKFJYRTwM+GfA/+BEIOlv94BHihx2s2RvkNVAbuUTFNrnO
         eTcNEvh6iNfoYIcAltg9B+Gm7qVkVFlBg4BgkVT2oeIgNdazKZMjC0fXJY+WGyfg45WJ
         Fiped14HmEabOzG+eXsurMpu300I1z80LvIpM0lQtAmdv0IE24V309DexOb1L8sn+xCz
         qnMxVIhFDBGTIeti5HbFzwN0Mrddfr8PCPT4bVbggRHIFnWDn5IkAIoQRAmtSpuSVnMT
         X1KA==
X-Forwarded-Encrypted: i=1; AJvYcCVBpTErZvxThOhggV96Cul4TWRdkQ07BM8bARWbm5n1LZG71uDyoVV3r63egfV17x5kOH/sdSOrbQ==@kvack.org
X-Gm-Message-State: AOJu0YzZt7CZ+TDoP4UBl0vXE8tvntriexC88ZsQhOwJmEUzdFHYZtui
	RTmyukspVI5uaQVR6j+q40vCQHhhZghCvt2qfoKI0t9uL0G1wdWz2ptrCbtC5khy0z8=
X-Gm-Gg: ATEYQzyKtOBqWVDfkeBqukG8P9h6WkGYUfha/aYLcQl3KmqCqNy/lYcHiMClBEdD4t4
	jFqkLCaXA+Rz0NMbTqRk26uyW8mh1SWegDU7WqO+twk645bfPnJ6x1EzkWYNTUVUUqXGWzd9535
	pyoec0CZOK5uXQJt0UrXLyzv+tOOo4dOesw59pE3gv0v9pqaB1qTh6W0iUqWZhP6jGnNBbyVxYs
	5NaEi+OizPaS1Iew+8JX3NGq5/WZPmmqo2iFKao2th909SQ2t9bdEWZNAGDNeJkVf+L5K57fL0X
	x0Wp61RsUvC1z2tseScWttDFe+buS/6VPw8jlkcwcnlvUqMZOWKzsKLs4IXtxJb1TItvrKRI3RV
	3JHJC3rO/my/Gza+nYJtd+HWBBlqFU5lMCfA1+WY1WoFxwu/u4R556V7RGHmF4eetjJTqkiFF/d
	82L8RgodKNyqyN/L+iAzcGzAYKN8aKpvHIby9b
X-Received: by 2002:a05:600c:8b03:b0:485:3c66:e230 with SMTP id 5b1f17b1804b1-48727ef1756mr294092065e9.29.1774943658787;
        Tue, 31 Mar 2026 00:54:18 -0700 (PDT)
Received: from localhost (109-81-17-175.rct.o2.cz. [109.81.17.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c8797ecsm18417425e9.8.2026.03.31.00.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:54:18 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:54:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch v3] mm, page_alloc: reintroduce page allocation stall
 warning
Message-ID: <act9qKsVjdmZC3KL@tiehlicka>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
 <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com>
 <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
X-Stat-Signature: e4e5pidtb4te5de97u7mxnduh5uhqzan
X-Rspamd-Queue-Id: 66E5E140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774943660-266024
X-HE-Meta: U2FsdGVkX1+pwS/rgSoAWTSar+d59QLFjA5CadEd5f/rMECIFvIA6Pzj7Wu0FHe6fHRtGr3b+wO+rMuEvvUORIdhW8OttiFk4SAX1U4dE1zNHJVzMjfejZBZppyi7ACLKmntO1kTISMulHIde/CrrFCtv7VllqnEiECXnct7ZZS1hxrlCLLz38kgBLcFveqsQrMTnLh96vhr1e1UDR0e4qCyExWBDNqWjxSQ5RFgqr1VvPGuXyXda0EU6URkt7kurnSURD57XyN0bJVvKGNN4abuD+hdPfeuKKYXwsKZv2qnajDsMjjx3O1bbW6NrWbDJ++bUap/0zX4uMmJ7/sNX5JbeeUDKoB4WJ0psAt7fbSQvtF/KHcf9PgmYZb0rwl4HCiF75xZzWYFxSCM8/UQjy4pRfc1r9IdGjQuFR4hSbjzfdp5VEY6yWHWmpFmPWd6Vth9euetX7kL78S7jC6JNpR02RrjkhD+0G/jzzFyJgw/wnDlQyqspZKbP3FuNsySn8SOV6djR+YiYfr2TjQphkMg1GxKTQ4+LjlkV5MO7KIIaZjzSENhMc9DfoONCN9nO2XxvUETVpDt1bu6w9FbIOf6XtyDxEF1OZf6D2PhxJGOS8vmBn1FeMLyu9NmXJcPLMxPIcGH7zLmonzQ4WDfYAU2WaqBO304QMfF/cLL91jQfK9EOIfs+GD4ugJAsRfZKck61rm/8eWz9eZ0bNBB0pC+m2EBdQJwVME+pE1EdErXA8MoKXnup0xqnIdl0gKukSJSeBZdcs8IQUALUxZ6oggMbsklBrutn6sWz4S10LxQlWOXA6WPS86Pm15pT3SMgcqdX31NUuSMCPYaBt314kifDe0fqQmQWHIJBZ2jDhbc8Yc3uM7Fi1xOKtDR0a1KGXNOWbGltBFn7c/BPlH0IXSi0Gb56YWwFJDMz2OFTCl7oEsii0SXBYbdCas2JRHgiLP9auXJOLiGImWgScU
 z+CisZk/
 MmOFpoCgLTNKRBni0yDTYawow8wrGWGih3m9DvbrIoFoWrEe/3PTggXY5crZZ49/bVex/yS0cKHAxGamdKVRy+5JnAvsq8vs8ojVKy0lgexownM5YfD5T//vXPJzCUmrG9Nf9tLTBcfq7XYthePt0kBelYaH+8djt7EyienV668egWBZoXluUXHWwKDKGCafaxwF3kGWQF/qFB4G+i4MqoLXQ84nyyiAfx2cMWsR4jf0pIHGJ6pYoc1kfEaK95+4/T0cA4kvkQAXP8uD/0/IdH8fHywQj/C+GdO7TFyaY1+slRIhBoVPTdWO6i9AI0v0ZOuFehORSEfaVIdACKB9lFpoNvUxtP1VCN97/MHcf++IvWbf7Yyn0Sbg4oYDq7OCD1G0KtTlhDDT8vqaXeSCI1fX69UhQ8m5P03jx8VUO93DbVFN/2ekhmmX7II9dryicgfz/iS0n6Db/xMC1aT6NyuNDtcFq8r57jvoyKq40MJcIqLoLR0a1VRcrSzUg0akaz8pOxDxDSeTOB21E3dU4zRTG0sXfBRzYjVnZxDb8S6F8jbAbeIijuayQCoRW4EaX6vxlPWaYT/Ft4+qITNVe5I5vAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 30-03-26 18:20:57, David Rientjes wrote:
> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") because it was possible
> to generate memory pressure that would effectively stall further progress
> through printk execution.
> 
> Page allocation stalls in excess of 10 seconds are always useful to debug
> because they can result in severe userspace unresponsiveness.  Adding
> this artifact can be used to correlate with userspace going out to lunch
> and to understand the state of memory at the time.
> 
> There should be a reasonable expectation that this warning will never
> trigger given it is very passive, it will only be emitted when a page
> allocation takes longer than 10 seconds.  If it does trigger, this
> reveals an issue that should be fixed: a single page allocation should
> never loop for more than 10 seconds without oom killing to make memory
> available.
> 
> Unlike the original implementation, this implementation only reports
> stalls once for the system every 10 seconds.  Otherwise, many concurrent
> reclaimers could spam the kernel log unnecessarily.  Stalls are only
> reported when calling into direct reclaim.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

OK, let's go with this and tune it up as we find a need in the future.
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!
-- 
Michal Hocko
SUSE Labs

