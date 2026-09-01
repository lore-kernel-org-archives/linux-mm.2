Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAD1C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286156B00A0; Tue,  1 Sep 2026 11:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236BB6B027F; Tue,  1 Sep 2026 11:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DD56B0280; Tue,  1 Sep 2026 11:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2E8F6B00A0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:54:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D3111A048A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:54:48 +0000 (UTC)
X-FDA: 85165641456.28.65BBED0
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 891B940003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:54:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EBROAqcf;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ucz+U5vH56qFJK/L4c9McNdRpbMBTFsKxX9xAzx9wCw=;
	b=Nca2TXMPtAlUAXyAudMzmYaZFDKcETLbUGl9zi+N21TXEj2sBoJ1SsJVc6+whNVULlO8bH
	zUAbYe+BfI9K3JERpLMmwSMnODCBrSiOhv559eEzk3YM+L1qWF0qMZBZpQehUENthEFkPq
	IN+KS0QMlYOVf5fJp7uZfFPI4fe9QbY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EBROAqcf;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278086;
	b=GqBXUdeLvgkxxaPTq60/yd10TlNBECS/Y68PF+jOM3ALMexjB+vFPwIA0XGmk9O1ObB0EH
	5V8qtSpgJzhv6agDs/bugoQORa0gT2dXT/CbQ70BPrXXj5PXWYpXpnC1UdPf3LpA4A9KXh
	w7bb1nkjhNxQ4Y8G4RxjTASLniQlN0Q=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-90cc64570deso14702076d6.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788278085; x=1788882885; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ucz+U5vH56qFJK/L4c9McNdRpbMBTFsKxX9xAzx9wCw=;
        b=EBROAqcf9VGRGy8L72LuHbOwXtF+7FHS70IzxOMhP4AFsawdtjXNCfSLTxQwmgq+WC
         sNYhsrIbWTsHlC38tqfD7wwnWXVtZ1W3wMjfn/2DubWJwWoxSTRq67veKgy9REnGzIse
         mEIcuB061Mb1dQV88QRm5Y+17G+LQ41nIHP8F7snln01C6NpDVmC2BT+LD3jI/CYSWv1
         Mp5V5WOY1/yfrnuG1D7f+C8u3/iTPNzmRDaZNekLhVX2UzF+rA8d22QH3RSzzSf4c9ax
         HGL1J+iLjR780c1gOW8Z452yLdOISVbq+r2oB/AFi70lGWo+c2zj7DdHxBp2zc8B0r2A
         /lNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788278085; x=1788882885;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ucz+U5vH56qFJK/L4c9McNdRpbMBTFsKxX9xAzx9wCw=;
        b=R/HfME6ofw9ZcIXGs3Fz0ImQ4CZUcdhLoZc+1fNrrLqpVWT/INfwhxkV0SudVELHOw
         XUuH9cQV9B/P+BNbEpFITvwyux7MygtQKKl3ECwCsRrXH5kkBlQUtf5u6PChSzyo5CdZ
         CZCO0yAqgObi3bcpr39oqldd3m3c9aoDV+n3c6Awj1LAAhoSzNWE92NH13jDpVIsEkS3
         8c2WSAsV/dmU7CaKDNCIX4n0LVAQamO3J/DOOCLqQE1NZ+H5SayAxm3mf6W6V/FEogJR
         LHlDO3bRwMCX+GPb1HbCSX+Y8rIbzHSE+lXx7Xg3GO0UU9BsAs9jva1xMXlqU/0vJ7qm
         uLsA==
X-Gm-Message-State: AFuF++k9egC4fONeL+0rKnVMUstwpImx3z6NWnnfcxFd5yp0quK2+KdU
	xqa3BzDhQsrovO11CeDzW7B/wF3qpW/4QklzaS1UPrxTuchzjtyQD/SLfYrQKqyDj4s=
X-Gm-Gg: AYBFou1Ck+e0r3kyI45LC9fR6wA/bxEWcXVYYmIW8Eksmo1PtUWedLgrYva/zc8P3S4
	/n5fqDhtMpB9YGorLI2+b0zUb/W8zXn8Bg3JQG3n5xIMXxPuPXXEwU0L1lry8W1lb6BZqfBIXST
	rxa50qRzAwX2jDZAriHaOp6zQZlITcGGi9spdE8uj0kDu0eJZ5apHgi3sJ9g8QDONs2XKJRYLjF
	HQWSTrsmSPV/Ql/Wvuva/6mPkKHqGcBEPhyAaRRRqG9JBRvqSthpyB2bYUb3POV+zuLmvd3QlB1
	subLA2mP3fVMOrtSJCKq94+nS2CAhgahm8Rwisx1ltif7KwxmBAuajJq2V0vHlJM3q8D8x5MjS+
	F2rE3HTn60ucA0Cwos1W4UhgV0IIHU+R4ttksqylLd7+JKWlqt0zncPmyNjy669nHQxtZIIiAJX
	xHU0/GOCe/xAyff4pnjx3qTGONSmVkePoVxq+jwJa96lgsPRM5DCF36vr64hls9gj70MQUQ+ORw
	sPuZQAZWaw1pZ7OHDd438BrBqMdsQQrY9DgIcgxLUGb
X-Received: by 2002:ad4:5cc7:0:b0:90c:c1eb:ae42 with SMTP id 6a1803df08f44-90e9579ed9amr72405516d6.13.1788278085601;
        Tue, 01 Sep 2026 08:54:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4512dcasm111045856d6.34.2026.09.01.08.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:54:45 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:54:43 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, apopple@nvidia.com, 
	urezki@gmail.com, chenwandun@huawei.com, 
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: take a cpuset cookie for the interleave
 node count
Message-ID: <apb1Mq0rJfNwh7Xa@gourry-fedora-PF4VCD3F>
References: <20260828193111.1023497-1-gourry@gourry.net>
 <877bl5qknu.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bl5qknu.fsf@DESKTOP-5N7EMDA>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4k6h9tzc5tqhkakmm5xuhiosx4wu3653
X-Rspamd-Queue-Id: 891B940003
X-HE-Tag: 1788278086-363038
X-HE-Meta: U2FsdGVkX18wLffSjlHoJhuOC1T1bHEksZ7i6xVDJeAxTzLh6dipf2vtW+qhplEwl7ZfVp+o5ljKaNEbhFr+1DF6+WUUxKFWt5G/XeHvaIA2WEjwYnOlerwqQ6lRrRK9oNwBmaFnYWaeX40d6c36phEECTa3+XTK9V7SjUQ0ABZsAr4Xs7ccwyXOL7G+PUorcdKP4l7CVUVT1ljP0zFwVALeYP3nHBuiZEHNQl2X7IltcfoycoZNZhcJVJ8Ko8ckCGR2NwPx2tiJQvAY0w8A2yj1V4DiChd4B9aHw70680D1JIG0hvmRErMAWvesvHVOXMvK1ZwAfA67nFKsw0xyJiRGbsUlDiq9J38EEdvP4nGUkBKhbcxPL2I2HbJyNFcATvLMakXzAJp8qEkGDmQpZeNKGeC3lCT4W9YVe+9eRZwvLWVJKaML0E1fzpSOMwKBofsnXceayNtGIRq89mlLa7GHED5Hr6Y6Bb8zpxNKMpOI9pmwpq/w80C4MTZKEN2IKawkQZruTHjQq1uGvTI5VDYdmPQita4KGzuTjYy0dgLftVc6kgTubP8St++jeSTFrg8yBMqNIRd1j2e3L574dR8/vo23BX12QnjMYVePOJE4+oa+I1DWXTHqQ20u4TxQtvOwMm04PKFxZ9Sst0MeDmTWsw7wTlT2jvF97B2wpWrXQwd8uEH8Qaf4+wO5HQ8lZgN7E7o6iKaOIxFeNTqm/N1PihxT2bKKRHcl61iUA3kueeW9gVFqYn3FVRkQGIq6BrRWpxk5xrxXudFMXaBpGizXyA0u+17kvpEosYGPD+defEplsuH3U/zvLfipaCYizmfUomkhSkiVZNQYzJAgBngnFOktN90E9JAXIpqCFZFcC7lHwTf2p1xXmRHuXoWTkOmwwWGCkgYA9ywqwiIxIyN8tgbqmTzJ59qMDEBUeHCXxqZrJc1TZLmGbK9uee04UjxGp/tsix3UDUhQetl
 u93O2ccM
 BihGohEuSJS7mpKGdI98NBld1yPxT6bBewlCKXRHbNN6E4LNB7Ek8e4AeGESPeRXqpRCTP6xR+lMhs7aMDi9+sRtGjS3u+Pe+7oB+KFdhGvRqUR/Zt8b8qz4YyoXw3xTDfjflymUxTAe8pThFpM1l5UYyJojcieUg8AuablivX542POy2MQRJHC566iYjCpONcltVMc1DQ0qpYu4TKTXOkV5AvYKoeXzEFowIn1WjXdwERR7xOVyZshdsYe35BugaE+q53VK+iH9snjqrFqAJFK3uSWTrLwmA30Or/4HV+xdyl+OXZKLLYeLWB+rIoA3oug5AqnT+d5k4UlJwbElJYiZrObYi+hFHTiM06HulV05rvqGQpMI32U7DhIYCLfOMPEAsmBopll43y4ZTZxBUmQBz5+ocDh2g9lpvPgAoxWTt5I2wk6RTWOuTz/u48NEkF4jE+lONgY3vdZn3PKSQiIlQU5OBPmml+R2BITZoULTNVvbHSmBHKGcu6o2DttUJfv4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 07:24:21PM +0800, Huang, Ying wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> LGTM, feel free to add my
> 
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> 
> in the future version.
> 

Thank you!
~Gregory

