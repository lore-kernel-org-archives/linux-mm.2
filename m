Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2405CEFB7E4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D8C6B0095; Mon, 23 Feb 2026 21:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB666B0096; Mon, 23 Feb 2026 21:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C70E6B0098; Mon, 23 Feb 2026 21:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17E0F6B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:06:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6153B8DA5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:06:31 +0000 (UTC)
X-FDA: 84477710982.24.7270073
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id B847F100006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:06:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G0ds5akF;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGujA8hS1VQqUbv75LvcnfS357Yi5nLYG7BGVulGCoI=;
	b=gCOha2Ssjgtq1eKCbAiPmP263RYzbOjmEP3pgsTgOBU59VgKASxfvQS03lhYKUKQM+eCLa
	LK0FkYT4hBFZbsSdDYqF/orNCInhjMUBX2e9wX+Xj0T7ALBmmkV0NQ7k1/5nSaocGt4khs
	T5wyqXJFOpKR9oeZvdI8u8vfYiNv/Sc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G0ds5akF;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898790; a=rsa-sha256;
	cv=none;
	b=HaaB9FoqJ7KG/0TZ1/jEnhPt3m0Ov8KyOKGPUJxXDII7GPA9yUtm4BYb0DyT75e459HrLp
	fVh3i1SgqnRdd1KX8xhUZhD3jRNjG1V3ySesx9sWsF9UCkSeafFeqPHJnthXbLaSV7f5XW
	OMX+Z4GQ2t/jJNv2etUE8nmDbkAY9Zg=
Message-ID: <26ffb92e-1e62-4e1a-b31b-465a882c2ec4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771898786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGujA8hS1VQqUbv75LvcnfS357Yi5nLYG7BGVulGCoI=;
	b=G0ds5akFrIA0kgIZ2TZoxRkmowm+ZNSacUP47Irv3kLMysJFvnDZftaxaHKh2dE6U+NnpP
	7ZFsSIjaM4xzt/2/0qIRBSqHS9pHEfEftOm+ah+xqpMHoIjm7AHkAfNJnJz3lG19xt0g/w
	ncDUJzbnENjBnHnqWzlDZ1arS7Cqw9g=
Date: Tue, 24 Feb 2026 10:06:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Dave Hansen <dave.hansen@intel.com>
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, npiggin@gmail.com, peterz@infradead.org,
 will@kernel.org, david@kernel.org
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
 <20260223125826.28207-1-lance.yang@linux.dev>
 <a0c434c4-ec65-4a37-9422-5614249124bc@intel.com>
 <1373db93-3977-425f-ad59-5970e7e50b48@linux.dev>
 <c348453a-6a1f-43e4-acbb-02bbeb2ce805@intel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c348453a-6a1f-43e4-acbb-02bbeb2ce805@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r6ddedygro7pzcrjb3hx6ad3hdnts8nx
X-Rspam-User: 
X-Rspamd-Queue-Id: B847F100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1771898788-916499
X-HE-Meta: U2FsdGVkX1+oX4vMc1w3Iy2lTXRq1llJzwdYJci3Imgw4rY0ZqxDA+0F+aSPXwTVPe9bIEdM0rVmaSD+n10GQXG64Mr2fuQcIMhrPKFcbhdRvY3nxw0jkm6ArDKOfO0aKCcIgc36DImTN1y2C6LSyAOWtPeVaUg0OSMJvlDd7myUV/NMPQSKwdYW/pgVM3VlT0a/FIWma0qCOJ1j4roxWpVNtFOWMiWFCaq2ZlRWgqYFdld3fkI0CfKU3AcIPuDqcj8vTkm7zOe011v3Nm3LSAq7U6+ymfSwpN3i3qg/xC360r1yCHv0IQy8xxthcx5Mq9u1mq7s+oiW6D/ZHCad5lGB0JYZFhfc8gVA0ISzKmVKPaj22NlX+iX+haBMxKXEIf+wMfJPlEuL+xE9XCC/QMllnkkYI6vHgkce3afoR7wN3VEEUTRtGkLSSTjATbZVHEDrsuA9nn7XUEJpHsdg4LZFdvEdurDffhwf36lEi45Tn1ePkhnqJuWyzHc+GDRVKYBfpus9WEsrni6WBl8/QucL4cOrBMaXCaRB6eMrdb/+UhZBoEC0V/yZpplNQS92wpVzBLH0HRF/azulmmndcT5ha94+65gV6Ryf0GWnZoPkvKewkPFUqdngCMJc6miurR4JzXD5+TgYRyryfq9jJhvpa9XNlJq4mvfkfmMRcerS3WI9JoqxyQnIBrmL0UEFKM/X97X3WzpkBgorw7zGvqMEnVDPhoaXQ/FMdJyyXcfnvMzJaOpYTURwzKbPaXitkJW6sVqIfm14dmu0jMSgPYtar6799V4dQ6M9vSKds6tN6zcBcw+IcZQx/dg6TsXPHfwFywosT+0KiqnwPqPDSvCvnjXot9YtAdVND7niDn2U3wXkTFSbI9ZrWC/OUDOYuB1CEv1SJtSVat6CJ8Pu0GSqmoiXJgg9cSlM2RDbxl2pnhIItUd7qeRZlJSIrMOHvGt1qkYAKrITbzj9yoK
 Z8HeWfme
 M7mMiPJb9Rqt+cFBiGg6ymw7afcKozo7voXsz3pYoauW7RHfydavGxwxg3OINbhjiD5gMBmPkmTeoz0s6erTkd1o6YwRwWhfxuYYHtdmLkjvW8DT1AjQF1RZfd42s/VTluXmU5shYZNw2b96+eLkwSjf3CZXSwDzMDRcdbWh7TamQ+vDeUcRRpjm2peP4oZ52+fi7vKvsxyvW2VDL01kt2HxKik7j+eVL7fTCcEyJHfkh+OPlvpkDL8uEUkcPVvkknD1VElMhfspvuURcJnhD+8S9hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 00:35, Dave Hansen wrote:
> On 2/23/26 08:29, Lance Yang wrote:
>>
>> Note: Use this when code really needs to wait for synchronization,
>> *not* for freeing memory. Memory freeing should use RCU callbacks
>> that don't cause latency spikes in this thread.
> 
> Yeah, but I'd probably mix it in with the other chit chat about
> non-atomic contexts. I'd also make it something like:
> 
> 	Do not use for freeing memory. Use RCU callbacks instead to
> 	avoid latency spikes.
> 
> to make the commands clear.

Got it, thanks. I'll update it in v2.

