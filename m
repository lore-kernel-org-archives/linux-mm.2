Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69A7F3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D28F6B0089; Tue, 24 Feb 2026 10:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180106B008A; Tue, 24 Feb 2026 10:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C8A6B008C; Tue, 24 Feb 2026 10:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2DC56B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:30:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92C0887BF1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:30:13 +0000 (UTC)
X-FDA: 84479736306.25.3D5C225
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id AAB1D160003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:30:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rxIdUs8k;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ07Nk0trE7IYI4IVsXr1fY79mavMg2ecBm7mOXPVF8=;
	b=Joqb+D+7i9Y1U09Aq8lCwMFNVjLUPJM8QnH2m7QLbk/Q+J/th5MYiJAvhrO+PH9hSy3eg0
	dY0egebTGD2oPPHhSagtaIVvRH+baT0iDesbrwnB6yHXnz3dge+MmN59u28NYSnyW+zfKW
	O1OKs60KvJdOHdiVbvqziq+eiViJfEQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rxIdUs8k;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947011; a=rsa-sha256;
	cv=none;
	b=losUx349QOIZRJCGcwhEx8cw4SKKcXojKjGgIsg+O6KmkV7KbB+HmbDALVm4Mc82qMs8NV
	qF1CXYhNoMPzA0kdVSt2Ps/na7LVpMg6xjiTwrdQ2NybhMKCrmoRAivzeQ5YRde2DlAPxZ
	VIoR2uZSPXGZTZEGmODg/2jvPwp6ha4=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899b08be919so3070496d6.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771947011; x=1772551811; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJ07Nk0trE7IYI4IVsXr1fY79mavMg2ecBm7mOXPVF8=;
        b=rxIdUs8kQwjP4AkF+2jyit8LJ/SqhrDg/i1F1FR0q6oog7v2awKVD3YLs3R9kFlnq+
         thvpNH0lpZC36C+d+Ddmh+puhkw5TkTOZMMqR7LucP9QEi2mr7t5nIGNwV+i7jogptFm
         xLCg4AOCW7Z211HErpjz0YWrBdHd8/kKUVn3Umu0p8GAb0OTOUT6FOhIGt9c5jCj8NPi
         +AqexPEsDN7LMPwhbKJ56yYEBmOMMgM/2uyiYSUYi02TcG1C4tjeRggynLNsxcquSGeB
         amvt5/Bgdnd/13wH67dF/FWpFhcq3ZjYJQLkGatH+Q1LTTq5vu1/aJ7dYqh/LR5h+xq8
         zGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947011; x=1772551811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ07Nk0trE7IYI4IVsXr1fY79mavMg2ecBm7mOXPVF8=;
        b=mg11AowH53chtJ/IfsMyXYLtmEZNAetH/ErzPFKwVScbVTJvW1fg+qC9vkt5nAdu8a
         qqTHDg6NjDilz/cFMJdqWUbo4nO+ixgWcTQWY96WYmPF9Enb0O8tiT6ZOvzLCCmyrWXQ
         8Stlw6gFtLvIZEuWC8HrJaEqrDAXMFgP0IK3fdzIMRJhV8XVscGTjbVtBQFLeP1eOIVq
         WQQhwSk2jrVowsfHXiNigHHhxT6+5ts/afQq8eO/UO3SohR3l8Qbqp/KSx8kuTNTwYPL
         qJ4wA2tMZQnQRBDuNoIbp5+km+4aj8uy66BCHfI8sQ/F2BmqSnzyvaX28/6vQUtSd3+R
         ogZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDlU72eqTYW8fWP5cHwfE+X46tYmpWOYgjea7Oe27NT/yJQ8Q+OYRA4pPqAvp6oHEsmrcGT7XXYw==@kvack.org
X-Gm-Message-State: AOJu0YwDjzvEPnOjrVQMKMDfjxdaqeloCueQgFzJjV8g2IowLrEHiZsS
	P5luwLigO0iq7UsoEjs07u+fvQlmbL45R81AyVf/cIfkXGnp/QtIVCLouWZcDIHzV3A=
X-Gm-Gg: ATEYQzw2sUkWOCMkIbp4uo0StHWIR2r9OPNmvqplB1fpdKzKDY+peBpoUjm7ScQFVRb
	2v4k0WuL973MZ6o38Yw1p+5bQ9Qxf7n7DR0UKnVPZOi5NLwGG1RlA/fmNwXkpAAtvn7ZykYCu7d
	41FfyRnwvHJp1Sxk/QVh+V/fSlJHEvew+4sBn3ZELVdrhZcqlKGHrzXb01k6t1Qayd9ODoC7gBb
	tX+v/svJdULzfLKcsjOo4wHWgAFAg3cFoZOhSuLAUF895Kohrolykb8eqRBc2z5BupfbbYfG/e/
	opSWazyZP+nOIxf6uzbAPxpruKhjaoBDuGWsAzpdCDSjO46EocXyco/6nkoLwtHfQumn1MYPHpM
	XnGBotXcHIml+f002IW6A01b6ZP4+bQVvl3EQAo8YBUvUGfXLvhZajLGS1WvVQuFZkQCbURuByb
	kWowjMtCeU6XhWekPpjIgDF63Gv5N5nN5SsFgH9g/a91wspwySQqdOd8dcBo/yZqVKC9BpkrzAg
	n4snMy0Jw==
X-Received: by 2002:a05:6214:268c:b0:895:bc65:4b0a with SMTP id 6a1803df08f44-89979d4c803mr165241676d6.43.1771947010409;
        Tue, 24 Feb 2026 07:30:10 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997c6bb2c3sm93512236d6.16.2026.02.24.07.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:30:09 -0800 (PST)
Date: Tue, 24 Feb 2026 10:30:07 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aZ3D_8GJit3FYhQc@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
 <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
 <aZxsBifRchLn2m42@gourry-fedora-PF4VCD3F>
 <7a574665-0a65-46fb-b87d-d2ae28308759@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a574665-0a65-46fb-b87d-d2ae28308759@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AAB1D160003
X-Stat-Signature: pqq9hpbgxggudse1bse9b3h151h6s5sb
X-HE-Tag: 1771947011-436303
X-HE-Meta: U2FsdGVkX1+Fjwn6ag5kY2LGiQBDmk7B/jfguLbsqH2C8mbJRb6+Zl0G38WkTr0PDe6WUWpdih4LGiz/22yhfCePzzdgpL7glPmlqVEPOp57L5AMCJNICfcr6YzYM/lfyGGYGIteHdOVlPG4HdwCytxr7VoNIOrk0VD01gZ+kgwCFa8yuOCZ45XwV72k1DMksuDjpKJhEWW6GTCxgVHazUT45e3SGn141QvplSVdyAHtVWXcMSlVYkQ6caVoojq6et6l9CRBpG/ds10n9yLExrWK4hCnvWOd3HhEvJodhaJDdvciuisQ/FqXT9IhwZX+pQ3uf75ZipWVaY1UELcqqaQzHrfNOt44UzIwwDMoUBGPcbxUjbfe0De//v+rf4/+dChx/H3Yhd0QCDqUX1z6vyV899ZME318SkWMYwbBQkrhGkDJVosIKT+lIRaBWF1Oi21SYOGACoyuV5oswWf4tR5rCoujkoA8dvny2nX64vDts7J+2RyQSVJSOEJAiroSHEfqRgGq5Cp0ZlHhNtUkpv9X8JrZlKtvqkfX7TndG1xqa5ojBGXaj/gY9gSOQoqatvKvEikRmr6Fmz0vFMWPdQUU4B4sJikuicHapcp0SU+ou/Gb/d1Do4T5HRiejcVVNWoBT3dOogqS5GjNte9jx+cmEcspczqbKFyXeaGfZ3TAizypmjsrUhTty1UMXMcyrS6b7OkvxpN4oejDHrcbpyzApTOoWWpD98xQ6hBN6gDwcNxK7KIhYyKzhQzM4DYh0jMyhI1v5LtVb3d4uk1w60pbTqRARd22LaaVrfdwmwLo/1KVUDg2N65D6tgZtBJbFbrmUFARozQ2zXfCSyZ3nwXr7oLkV4sOSX+otFuLHYKmleI8kTxppMXQZbsDm85DvXNKmlz1utTku2jRW81/ulpTANlyV9GDZ4MNUZivIL0WyBl13kXbc6D273vAStAt/1YO148Vuv0V4dSJIEO
 1u9q4+K6
 +bC5HP+Xxkaw6mvxoRBpGZE2Ix9ckzI2v72e+GBZI90BgGimRtfoGBOCT3rab++DvS31aN9CkNoRpkFevIknzE8KVOW42gzMPoG4wIZG9PP0kVZEgm8jjOOimuG0ZkJoJioOYe0VjJrBBcIeweB/97Pnq2HQXAuU1/3stP+mTc/1Xs+zLSx9zfC0hqnnECMVVif4xTyBfBHaKpX4w5Kd8SVg2TC3pbbZ6IwXkPX+5cBOfOlwxiiZvtpWjFeBHZ6jMGVELrBLRjjOfh24iVu5t69/CSQ07qIHcgwCUBqwhvNHe3VO94QdPyHdiU9w1bpJtxx9f88+bqym2m6qS/7a4V39g0fDXe8NHjg6I/qAVvhmlUI+zqDMkGW/mjbZYJqKBDqJBU5qQ1d3trUYLxd8J96bIHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 05:25:13PM +0530, Bharata B Rao wrote:
> >> Time in seconds - Lower is better
> >> Mop/s total - Higher is better
> >> =====================================================================================
> >>                         Base            Base            pghot-default
> >> pghot-precise
> >>                         NUMAB0          NUMAB2          NUMAB2          NUMAB2
> >> =====================================================================================
> >> Time in seconds         7349.86         4422.50         6219.71         4113.56
> >> Mop/s total             53247.66        88493.630       62923.030       95139.810
> >>
> >> pgpromote_success       0               42181834        248503390       41955718
> >> pgpromote_candidate     0               0               577086192       0
> >> pgpromote_candidate_nrl 0               42181834        29410329        41956171
> >> pgdemote_kswapd         0               0               216489010       0
> >> numa_pte_updates        0               42252749        607470975       42037882
> >> numa_hint_faults        0               42183772        606540729       41968150
> >> =====================================================================================
> 
> For pghot-default, with target_nid alternating between the available
> toptier nodes 0 and 1, the numbers catch up with pghot-precise and base
> NUMAB2 case as seen below:
> ================================
> Time in seconds         4337.98
> Mop/s total             90217.86
> 
> pgpromote_success       42170085
> pgpromote_candidate     0
> pgpromote_candidate_nrl 42171963
> pgdemote_kswapd         0
> numa_pte_updates        42338538
> numa_hint_faults        42185662
> ================================
> 

Fascinating! Thank you for the quick follow up.

I wonder if this was a lucky run, it almost seems *too* perfect.

~Gregory

