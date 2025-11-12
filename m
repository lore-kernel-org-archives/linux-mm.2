Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458BFCCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0FF8E0003; Wed, 12 Nov 2025 04:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EA88E0002; Wed, 12 Nov 2025 04:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4808E0003; Wed, 12 Nov 2025 04:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3366F8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:10:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1C5012DA52
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:10:14 +0000 (UTC)
X-FDA: 84101383548.20.68DA1D3
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1D3FC0004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:10:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZVjocBTV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762938612; a=rsa-sha256;
	cv=none;
	b=geREP2k7gwLhKNqyNuOVKhrDj6n8m/YadcppktQVm1+7TLICXEq+GePZvPqbTjjrXJ09va
	stjdFsBwqHadSOLlKNVNLku8mfbPWRnSdf2nABaaWQmkHKo74Rf3xKznXUjqJAA56nGWGO
	o6Gch4lIvslkDPkMnzHXsjCvNANaQjU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZVjocBTV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762938612;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xq6Pkz3PynpH0qi1kBl1OjrW5Or2+dSMMg5022+CzXI=;
	b=hrE78C3RJBW1UNYXN70qJ/wIhMSrvdgK/bga6RqlrVbwsWNNoBIjpgk0two/eKVqPENX5a
	rQXMTrUYTGK2AYfR9e6yc2V5OzV8ZewaNBTxZ3NCLfWTQgUNNouMNoijPlC6OnRbzCp3xH
	7C4KgC2oUKnhQjtWtH/pihCxxg7tonI=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7260435287so94225566b.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762938611; x=1763543411; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq6Pkz3PynpH0qi1kBl1OjrW5Or2+dSMMg5022+CzXI=;
        b=ZVjocBTVsdhtJue2lx5EPVB4Yv1DTaZUDK3QwQmSE2iaswz5U9H+Q9iWep1PVInWg5
         rztkRO8SgEqBxVx5+2QkjygzfpjEQHeDDBvho6wClD9uDOfALhnnlInvcCMk8AnC4EIr
         W1f025GLs/+902goH5S5xODxFdtHLxXeF/EJaiJxy2HtxsAgrhX4MzgxduHiXBY8rhV4
         L3IRwQzhWOZ4jyhS5znrhg5AxUzehb2FVhD1g7AUg5h8464ha8ubT82EXsiqqLGy8/uS
         puUdwGXZTz8wClcDxAx9/Q84iyO5QprkRhofcT18bbTRZmhr+DKbQi/ezZMHPCuSod7A
         YgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762938611; x=1763543411;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xq6Pkz3PynpH0qi1kBl1OjrW5Or2+dSMMg5022+CzXI=;
        b=XGlZ601y3Hs8UMdR1RGKjMa+SUBzmUDueAnusgXXen7i7W6VxcTZL6tL0rH3vIGz/K
         +PD7PIuzzbHlPZuoJhjzBCKopizMk3S2q9PPDU3kF0FGErgKM2CWNvQo0ULrkZvnaaLl
         bjtT1Zr8xPiiM+XYu0x+TsgBt34IB1dNDAxVcKyVz9QjIVDjudTGnJugOar0OEJusH8K
         zdaOLbRN9x4+YjItmSbNDvMekFb4Pc7mZlAC7rWkTOFQIFEBwB383JCsp+HBkTmvIJmR
         o0KoZlOZFYhqKVbEuh7FFPpGzm0QrWKbEeAOxyEjvHXc4EgjZ/AuBGPRaDFanwjS7/qP
         nFvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa5TnRzWFGCeyK0oDrS6ZmG/QiTTRqbAaEDm22Fk/MIuNUL54hcaNCbW3E/nZGBNkJ5hXM8IwVmg==@kvack.org
X-Gm-Message-State: AOJu0YzBoToUT8RDIMdRZiti2CAaNv3pCRAkvMdQcNYmBmhg+rUOXMWP
	ABwq0OqsuYLs7stGGferH4BnPekw7j8yDy2zbfROdhfrNcTal2GNYoac
X-Gm-Gg: ASbGncuGGeiux+HuAt2P0hEYZOrdbnO2NdNjgYBclJtwr/00G3x47m42/cjvl9cyT2g
	p3FMU4i+C4VXVbQYjsyS27lEa1zKY5eTLaABO6JyWeqdxMdrNvYjk00MggtTalbxFEFRRakcQfv
	iMo5YImd9hKjRY5SXguUie6k6j6LLQ6ZH82gSu3loOGo+wdXcRsC4zW2gcVUKKVM9sGgDUopxNY
	Wi8XcopV29CqUAFVJUVktdyV/ZSMTMvAFemNIoCPcRwIkl7OJm2WZBSUt1A8h9iANvYnsbbLPU0
	yHXTOlTsmxZEfsCRegYRd0gi4J26Z+X0+FYN2/O7Pf04uW9NDXClZoBEXF0+yeXn9yW0XZ2uRCg
	CpoDiECeDLyRH6ry/YzwCwtc0P9hGeE8BjsdE4zim04IVCbTpQR8AnM7yJyQlh81Nh+p0pK/8w3
	Zhrdk=
X-Google-Smtp-Source: AGHT+IFG1lbFQXG4fnln8ZtPUziEQL0kZeEfj0v4OL0cUWGm+I0pGkLzjIzHZcn2EYT7SNPiF/SERQ==
X-Received: by 2002:a17:907:807:b0:b70:aa96:6023 with SMTP id a640c23a62f3a-b7331971805mr197887066b.24.1762938610695;
        Wed, 12 Nov 2025 01:10:10 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbcb0aasm1523156666b.11.2025.11.12.01.10.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Nov 2025 01:10:10 -0800 (PST)
Date: Wed, 12 Nov 2025 09:10:09 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
	baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Message-ID: <20251112091009.5xewhutnvdaoxt5s@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <06096f8b-4da0-4b5c-af3c-fd8871437c16@linux.dev>
 <20251112034008.ojwghkko74psu65v@master>
 <811bea18-30d0-446f-8840-d99698a6a9ba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <811bea18-30d0-446f-8840-d99698a6a9ba@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1D3FC0004
X-Stat-Signature: 1hday5p7ybr5c9o5apidwzzdz5rymuza
X-HE-Tag: 1762938612-963396
X-HE-Meta: U2FsdGVkX18mp5vAPboW4S39NHQ7PaDT5qYcVjDlZAnLt62mUn+xqXBMRjn8Djw0jM7SLYjXNGA5giTnatZElJHaeba+OYy9OQ87Xw+3wnvBclE+1d3RQiDZsLcqHqe8TasEaMBFwIGf9wSP//5wqp/ldPpOoFCsbOk4It+4V8/HvDDI7Of8HCa5EkMvgX3p07iNnsnGQbRxspeQlr+70eDUpKO3J0+DgE1S4ADNBIWZBJlXBUGgCAMDQ09kSogwRZHFymMIzL1BrbNE3rwfJ4UNcN4Yg4FeCSjr0UvLhzO45jiCR+vwJM7EL7h0CjfTKchDot+T5IULgrzCJwT8RhEZO5qQr9S7vpDWOs3eFZ0UoGi42w2z+i8bPnKdOyy5CtFSzyvwVSYqi7DY5flubSAJqV6NU3APN+l5v5CRsku2nLXWvQ7HynDzOTFL++9x6s5XwcRXcDZ3YCVFouFt39j6OKqrYBpfzhSuoLfv7WxuBh/2g544QYr20HV59eAixXtfH0kZh1UGVpi5Ea4Z790MkAq9biQqDZXC+BsXZip1BhkaEfZV6OMObm/FNaB/WsFnvyS9KGsbMs57lUeYhOjlfO/qfxuzM3BB//Ucu+3DUdwat3/h8X8msqVFFKwoCQ7JYXQEOsiTwvoSBCFsl/dLHw+C1Sk46LQdNsA6fPBGuzPC32BVUgamPygvFefRalBLRJUUaH/88aO8ky47I6d8IGL+BIcci2rKMI1+yTfbPN4PS79iq7J/lRbZTprmyZzOZ0ZoRwCH4KicAltAPOfFvrE8IXjAEXATDdOYPqg6XwKLYLz9SgOG8CeLCssQmfq7CRKc8lQuATv5UfiULrthA7uYioxzfLw6oSqSj6zLWIx5k86tdejyvdOX+l9g2U70PugZypuV8Jb+Mf1mX5e2PqiP42v5lRTK+qXJUl7dtSos1ij26cgc3wPuZD2JgUhEoff8iQO7ONTnyY4
 0HD3wtfz
 qBwuTYDAJaIrrvYOLTC2R8yVCOMlr2WZx+4QmGsX0YSBSjPX4IwY8k/vheF9KVS8ywX2yfa0cbEvsNYvR3iwytFpJbFgWXXZlAVX5nSY7s8EnIkTSjOm/h2VsNArbFynN+NSCifZKluq4uO29DV7DLwFj7m44zn0fxuPVKWa0jFmx05y5u6dVvVKAp3qBQdevky1sFPDTXEu4kAs704A4rzflt58FYsBE6Oco1xVrLSTlkkZIOff41YMebVhSydtKf0VLC/Jr0rWfN4hg/zFnuFHZSEy+XQHf4xSxTTUHYUNuAFTPcAmCG7GKSlG7D4/KnEQegvhKEyIwvNiKcpon6vIGCLnBK+gfMXePjUyve91OGgzcrD/taNQJFAtfHd3seB6Jfnk7GrrPfTsBCDc8/QHWvMjFRzalZOHCEMB0Zm+sMaA+MObe93lWYKEljMkHG3HTkCPN2RQ6681CiaewkqVEmpVh23pMBUvWbpIOp2QxOwaIa8NCS4XfAoCR5KyArHUnefRK6VeLhRgS8uJ0863CA9lQrH4xFK9a2S/9fcYR+QIuAIYI/BcpQSgcZEIbRYkUp9QzklGEp6qTT6e6aWjnESn0L/TAmeYbgzy3bYSGP7ihM2yLIELZR2NCFEqRH+W/48nF4iqfutGti2WrmEQvYykuDgyrVINbBMtpxXfi6uTWGYjqXYTG7s98iLH0oFSdvD97sHNSUw3vwptUi4t6F+ueYn6rox/HgyIZ4DvfSGvSYKFD7uVMDZkE/P9eXfSjPNTrDMUgn29FSZbkH4kT02qFBpJ4dv8SId32zLrIpog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 09:28:34AM +0530, Dev Jain wrote:
>
>On 12/11/25 9:10 am, Wei Yang wrote:
>> On Wed, Nov 12, 2025 at 10:37:06AM +0800, Lance Yang wrote:
>> > 
>> > On 2025/11/12 10:00, Wei Yang wrote:
>> > > SCAN_PMD_NONE means current pmd is empty, but we can still continue
>> > > collapse next pmd range.
>> > Right, bailing out of the whole MADV_COLLAPSE request just because
>> > we encounter one empty PMD is too strict ...
>> > 
>> > It makes sense to treat SCAN_PMD_NONE like the other whitelisted cases
>> > (e.g., SCAN_PMD_NULL).
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > ---
>> > LGTM.
>> > 
>> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> > 
>> Thanks for the review.
>> 
>> I'm currently evaluating the use of SCAN_NULL versus SCAN_NONE. It seems their
>> usage in the current code is intermixed, and I'm questioning if there's a
>> strong, practical reason to maintain a distinction between these two states.
>> Should they be unified?
>
>There was some discussion about that in this thread:
>
>https://lore.kernel.org/all/v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh/
>
>There are some cleanups mentioned in the thread which you can try if you want :)
>

Thanks, will take a look.

-- 
Wei Yang
Help you, Help me

