Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A72C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2C26B00AB; Tue, 22 Sep 2026 04:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA506B00AC; Tue, 22 Sep 2026 04:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F80B6B00AD; Tue, 22 Sep 2026 04:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6136C6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:13:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66EC71203B9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:13:02 +0000 (UTC)
X-FDA: 85240682604.30.8575CC5
Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 293271A0009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:12:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dHviHVJ9;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.31 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064780;
	b=tbr510z/4etVJxmiix9rh9dIbjnnP7XjLRsLxXT9NJu8jhyMabZ77aIMX+p91s3tiu3JEC
	buYNP7sYb+X7kD4YS8FGWa82vb+DVXmRU3cCO2yuyOZOAq8loFNVJM0mDi61n6N6A0u6o+
	8wOOBl895+OkMy7MAVtYlUs9tYqXThg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dHviHVJ9;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.31 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgNa3/libDCvbtZBwjfAcECc9roNZSpEdeb3sDJmKkY=;
	b=tqhYF08Ow3Mvns35vG2otdlV36D/FBYcNLW/dVqTy4jlK1eFRrti2aAT/EzRv3dFFUA0mM
	kCaMI9ANYVJD7Sx8Y38AifMaTVaOubHdBuDJtm6TSJRAKRiGXII9XJF1WjAil2MWo+5Nm6
	HLStCwvdQYHBdLxyitghNCCzemfa2lE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u0QxjtjmQE5VvsgjRmYJRV+MOX2c7kGivVyl2p9yp0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790064778; v=1; x=1790669578;
 b=dHviHVJ9ydbDTEnVN2wn+D+mLbnXtT6cg67RjAAyW/cXorCbCPX2xacHpXRwdJzckoSsdp8s
 2pfi+msGR70nlVMIGcHPhNG/1oTXS0SoW8U6gB4OEO/WeZMwcbqcCHCTJNrJYW0s8igSIbSZMi2
 fOG1V3Tq5n0QvejcsGVivV/U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 048c39df30f9f240;
	Tue, 22 Sep 2026 08:12:58 +0000
X-Mizu-Trace-ID: 048c39df30f9f240
X-Migadu-Flow: FLOW_OUT
Message-ID: <96981a8b-0a93-4ed1-8d71-f01db02035d1@linux.dev>
Date: Tue, 22 Sep 2026 16:12:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-5-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 293271A0009
X-Rspam-User: 
X-Stat-Signature: bgw5gioe7g3jeh4oekpgj96rnobz1oto
X-HE-Tag: 1790064779-57583
X-HE-Meta: U2FsdGVkX19ZgMSs7GFQs6XMT/mdzskUf++UZOtAt1NALGdUIHBrUGvQ14pJkSoYZCTYed8KbARNSkjmkn8CLWQIqutqy9FfHIpxn5Dy7QbsoBATVNfNbPQogNmZXLAEtnaUo7LE5F+yGKJyIP+bxV8HSNV1yG5QhfIfu304qZ+O7XaclyY/CRVpQ66s13u3oCdYU7iAsQHeYGvvWEZnwcLdCMF7C6p7SDdJopNu0djdOvo8ZGgzaBWBDEREPDbLeM94J4gof/f9zSS/bQW/aV5e11SyvWL7AExsHir85Ejd6ISmOqIsnHzhsRfluLQvwonlzOY7FEfW/MTOlsznR1vDurKfRP2j85/QsPaZtDedV5thCL5z/dYfH+dEYjc98W0vn4uZX0K5YZhAxkVR5PVhzSoubBQ9P3CJHBLfMtxRsLaJhKJYqHDHFTfGOGJ7PDWajSndCqKABZSnbQoJsHbipdy05Qm2f/OwzUYxeYmWIHgK87g6Sx6/oW7ig/L2r8XfvlurhJBpdKj6INOa6Fd6XEd+WPjGvAlYENOS9MoQ73m5TfzsnGQiY3tRX6MDQKk2Zi8ohkk5VMgZjKxYrUIMadyjYhbBRCBe47JEs3xXAKiiDw7Sv8HHN9Hf0zIKP7F3xYDDQMu/eJYJkCwmCNhZ0RH6zhmokiNoWTZoAEfHHR7HlIB8WqfDqVDTdHyyaFCag/58VrvRHM6P1tNzJ0GzFnYkdNpVNJATKZDPps9VotPZ3kzyyYDWbEh/9bvGoBh9R2ZFfce295dxDdiEuEJXS0TCDnLP0+/0F+vTTfn0m+l4X/IHLQLERuijR+HJJP2xb0WyJfe7e7x7/w4KgrO8uvdTzTw9LxS6DdaH8VeSHk0xVGAw4nxCVrePNs44zyKsFGG/iSdS+XmM23tmSeyOVOQH7IVjLNb+vQk6KouJ0UDX0rlllEDIL1YJDpL6wdVAmjJrwkBDOsizGF7
 tghYt+KY
 jM7D1CiL1Uf0eXoowWvk9MnoJ5FRnVoJykj3Y4cM2AKbtwRns6NF0YeZGYpWJSow3w+gvF7wOIwNcN2ItUGb6R+wqcPifkIvi3pssjWHJpUM6MH5VceJ8qKyLQpxR7QuvXEbAcS81nFh0KnxgRrK7Ng9B2Q1enkPj2dLxOuv7D9nmqH41u234tEI7xnvVv6aSMvTdArTvfFCO0w/bazftKoUsNODuwttsaTkJ0HzXYbS9kh3t0Fzd8IGG53GtLQk7qxyaiYRTSmP61ElbVnSeV7SQbbh7bCEoqqSBoACrYCHFvy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> vmemmap_pte_populate() no longer uses ptpfn as an input. Drop the
> argument to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


