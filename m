Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FB7CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 12:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2416B0005; Sun, 10 May 2026 08:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363456B0088; Sun, 10 May 2026 08:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A976B008A; Sun, 10 May 2026 08:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 124C06B0005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 08:45:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC5501C0311
	for <linux-mm@kvack.org>; Sun, 10 May 2026 12:45:38 +0000 (UTC)
X-FDA: 84751481556.07.95019E3
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id BBDC34000E
	for <linux-mm@kvack.org>; Sun, 10 May 2026 12:45:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRU1Kowz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778417136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdhWyaWXzaWwO4E5O8KkAS5mbQAZBKf8kRalyM8PNnw=;
	b=3yC5B0lg0s+K4Sp3kvN3rUgD6hRgWqWgtzQt6trbz8CzhletRGIXIbulVdjkDZwMtN187c
	LrBhvvDZwBLO1FbcpvnEtoK9dPjAEji1Ydzw73wBw+5u6kCg2tv+BM3X0T1tKcTMOmqEK0
	SAfX+pYv/Px65DmupnDnSA0ROJAfr40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778417136; a=rsa-sha256;
	cv=none;
	b=Z/xeAfvO32poqOJ0kwzX+XsKyML6BeP75jrACtmpqQkxFCmMfEpY1GxZzD5qATFNMNilpT
	wuBD3gzfBhKsKIB+Pn7Q7bgwYQ2M3myrrNbWPIqlqVFSEweRhJ3AkN1Sh85NgzN8B5fAcx
	4w+5m6IqEJpF+zEoAaLvjl27wnbutcg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRU1Kowz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b0046078so27896745e9.1
        for <linux-mm@kvack.org>; Sun, 10 May 2026 05:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778417135; x=1779021935; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdhWyaWXzaWwO4E5O8KkAS5mbQAZBKf8kRalyM8PNnw=;
        b=kRU1KowzHJ0TwSifzAjCE2mwSDysEWwFzr4nkUNVlhJgoTXs5nVlxbN+QgB7JqCxXf
         UoJKQH5fujfEBomu9Rk43vJ3xOMCzgIPOP4FGwG6IazGlWmga/aqjNwNHEjM05ZJonBp
         VCEfpgtQX0OChNopkixlBZLpO/Snkr0FrgzfwX+2c5ObmqbuiXpOMgzDpbn+RynWD86r
         cC0xCi2qeBx5FmDW5tPJzEsArvlN3nTE8GcT22Kn3jJTSPF8CFDDdTLF2CCNJRO8xGeH
         z1w7XJkGZzAKC5lDILfIf5nxugBwM/XbN7Y+35dWdsS0pGzjRYtVpaZ5r2llPGZtW/GS
         M+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778417135; x=1779021935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdhWyaWXzaWwO4E5O8KkAS5mbQAZBKf8kRalyM8PNnw=;
        b=k+vk7thL5jIiRdLX7wxIY3wiiayopSOxig0BRHbU82BDrPKequ1NpKHA9rVYPdYyx/
         XNRwcjTdlbD92CFRV7DKsO46Wglt+Gm9Ewd7Q7zpE/xuD5f+8mn6ezEHy1+vHgGeZauP
         2w6/2Cr6ixVoULFDNezZt0O00866Jrr9QQ6U0SkLUuCNPXJ0P9nR5gxKpDude7pclAwz
         mMbCe8ezsrDPZifGW2iY/kCcAbk9AHaWUSLfPCBkNV3MKogyFhGTw0duoxHT6QY8DRWE
         LNlk5b81BH683EP9izZmQh8eAKW+WxqmrTcMo2fsmVmWVjyDlq9UwEQai1PMdbF6eI3U
         0G1g==
X-Forwarded-Encrypted: i=1; AFNElJ+O3btG9K3u16gZKHblzM7cnTT611NEk8Ie1glMB8b4ZmVy6cIn4QZX2umOcaysHXNC9QsMYvxjMw==@kvack.org
X-Gm-Message-State: AOJu0YwV3LeXG1WwrvQaZKLWtdQnCrnMjgatNlVAw6EFvEp8TBE9XuPu
	ekystcv6N0URocHQj4mJPgxWB/7bSdL6iH3Zhqhq4Q5xNOns1xqFGkjr
X-Gm-Gg: Acq92OF6IWQ2LkN2Sy06oHlm0z5FvbRL3N4Z+pFvunrJqVdiESxNkSos1wt40UkFjOu
	XWnLj+3xWnEIf/X45+TLopR/uWE5FYXdghGgngCjAfZ7FE8x2WwEKwSPPLDH4GnKaEEYWVPuBzC
	9p6CKjgv0A/2Q1ChxIwQQwrR8EeXqQ4DyX0VNq1btQclq2V1u921xeJPi7KOEq4cBwSVXzodz58
	PpGX//CGmmjE9H+ByD2R+5wrOnJfOajxjZFUDZx9JT71wGHdnF2lRAC0AZFOVQMApMK1k6S4zqF
	biKwzzX83zUZRjQxV+7EfBoruBPDLwXdJ/IGOaPWFYF1SqL3fLPREMACZaIeHn52a1Hn2Dg7/Sr
	/a+uAZS3jq2FJbU5cB9EHcDnNWKnrW2MZ7/i4G0XiTQex4r+rBu8bxF36mqheNjsRzN06s/sH/a
	2qciY5/6BHavU2uGRNvUm5eP4dZbpYJ2lQLdDsmCudDoZ9iaFH
X-Received: by 2002:a05:600c:4695:b0:48a:76a3:2b9b with SMTP id 5b1f17b1804b1-48e706b26fdmr93427255e9.17.1778417135052;
        Sun, 10 May 2026 05:45:35 -0700 (PDT)
Received: from fedora ([94.119.44.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491bae13csm18186868f8f.29.2026.05.10.05.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 05:45:34 -0700 (PDT)
Date: Sun, 10 May 2026 13:45:32 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: fujunjie <fujunjie1@qq.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v3 1/2] mm/filemap: count only the faulting address as a
 mmap hit
Message-ID: <agB97DSWxaS-z093@fedora>
References: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
 <tencent_756F151FE66F3D80479A6F982C0AB8569F09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_756F151FE66F3D80479A6F982C0AB8569F09@qq.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBDC34000E
X-Stat-Signature: 8cdasbd64q6brnte3krdaqf9rxbrjig8
X-Rspam-User: 
X-HE-Tag: 1778417136-958081
X-HE-Meta: U2FsdGVkX1+bmyMDFR2gs+ozyeycU4MqWkGPsEbS36M9euV3bG652rjmfXOvcSvcxf5HTJj9u2ZA2ToOb8heauog3AEMIn77kxS2+JjN73fm7wYC3sLap4LjbxM5m1DLZ5uLhb1cOnCRLHAL77ZZvCmp25+m9yBBVvl5xRX0T3X+mLgM/OmaMptaeymiOKfGeGUPovbQm3oP6B5m7tLkegOS8PRCiM4LtgQgvgepdQYgP958DO6PWte2+1mnaipTTyKSuiNFSQJe3ExvLsThtX4/oYSMuZABGF1rqwJjFAPtAJB6v4EUM/Ma73O82IRxDj89jTpmvdA33sU4yt1rbJU1HMVGbMaIHrepB1mxv8//Dv7nctOtre2uGFR1Pxa7I3Pigszq3JLFP8kCaSlJEBGLdHBV925EZgWw9vpCZr7o7XME4x8YxaBFgByWRI4jXs83wA5IRp44tHPecbMtzb/Ek1mwOOWmMcvtehqWSqVM/QcNOrzndfl5xe1PpneQ+BfjxyXeYR+P4h4WXviXVgNmCZKyqhbGloKfMUeNZrjvoK4LDc2y4HtO6Rnvy7OIwgRbXK62MIDlBze56s5V0uCMRoIjnYvPp/f6xb3e03u8Wyul66vV9QMLfpT0q7qjGYJKvXD2stiRZuissjbGt5vRKuAFz8ib9WqqkDQ5xwk7w/u2NDejjhgirSbru5xGTPyb1WUqVy18+J0cria2wrBZnXdn6Ga1qc/PQWUohoVSu+e3sJvUY5QPWkPYRzMNPBAqQMiQWqlf466xJ3u5B5lL7/xMfPvfuU1+yuN9gpbDnNoy1naJgU8gUwMKYEASIiGLpKgZNNNj6GS0Eg3/2kZ/YhPa8h4fQ/VGMnDjjloYCPNJAPe6paaWevpZsi4Vp6ABxhYc9RLBT2BfPwN2qmVrjqqakD/uQIqlfi4/COItKGpXsP2IyvBoxD3PVvPj9Edqu00od8KgrYom39X
 jbv1ENar
 t9bf1ym3WYg+20zMo/bbkzNZug+gS0K2huZh4vExgIqH3oh2dVBtJlUeNabsQPg/I/uX7DhHYUqT7hZks1myyOo0Bf9hmP7rFJU+90KFMThEzbZ1xqWYaC9pK8LGSGhO2quiUJ3TC1erLcT8ygXPxHOAokcSnGAPIWfGsZQ70Rbc30N2jeV9nE8YKo3UnFjz3huid2007PxecUtwyxMHobk2W3P3NExGW5ps03OA3o0LPfof+ZmKTLuXRfrIpvbSazUAN4jrT7DQW2ZHB60m1U2wKXamnPj5MTDKqkJEWhhSWYn3a1RUmRcDTrrPM5D8A2G02h4jqJQVSEIapHivXyFjEfrSEaPB++RSAjjvsvOjmiUG3Lc6TQhRGw0uqPT1pPlzZjGFpOpvpljeg415Gi8QTG/uzky/8LF8ZRRiDChqhd5nS4m2oatcmrgVn4V1jcTSZYkySLmc5goKRW2wX6/7Q8JhyrkxzW3GrXyBaIEQaAtyTMXSaosD3mlI7b8nCst0Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:59:43AM +0000, fujunjie wrote:
> filemap_map_pages() reduces file->f_ra.mmap_miss when fault-around maps
> folios that are already present in the page cache.  That hit accounting
> is too generous because fault-around can install PTEs around the
> faulting address even though the fault only proves that the faulting
> address was accessed.
> 
> Move the mmap_miss update back into filemap_map_pages(), drop the
> mmap_miss argument from the helper functions, and decrement mmap_miss
> only when the helper return value shows that the faulting address was
> mapped.  Keep the existing workingset-folio behavior unchanged.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

