Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588A1D277C1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 23:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C676B0005; Fri,  9 Jan 2026 18:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA3C6B0089; Fri,  9 Jan 2026 18:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBF36B008A; Fri,  9 Jan 2026 18:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E87A6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:46:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2AB81A0E5D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:46:06 +0000 (UTC)
X-FDA: 84314061132.07.190BB02
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id E5F3B4000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:46:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OB5Xpsk2;
	spf=pass (imf04.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768002365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9C6cJ5xC1qmhxW2t2YZM9EJ2lpuou7pguCgEPd3I+cc=;
	b=KmGkAyIC9eouBu2UvJaw7MB3QeAOHuNC7eZCQqKiMXJ1Ei12/+X7fqTIYUt4ZeanTXGziA
	OvMSSXRDJQYv3hJhnJt7UGtLUhx15y87DdfqExl6CV0sUc+xyM9u0Dr2f4XYaqNdIMSj//
	j7vdWcbCmWN84/+nhIgNSAiPyLq5pjQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OB5Xpsk2;
	spf=pass (imf04.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768002365; a=rsa-sha256;
	cv=none;
	b=zPi8MXkooYX0DakjwkGDeYdxQNTI4hWBWRBuW7wNYyyNzdbMif9jFxbPbpQt+roSOjOhRx
	pwqXiq9x2jKwntKAj1uB5QaGVgA5jaQf0T88AfREB9Qolor4d6goEfVmoUfM4W4OBUvEzs
	Z/P3Qys6s4HP5/gYQtZamOGfEeDIPRg=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a1462573caso31315ad.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 15:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768002364; x=1768607164; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9C6cJ5xC1qmhxW2t2YZM9EJ2lpuou7pguCgEPd3I+cc=;
        b=OB5Xpsk2rfyQW0JuUWycFJlxmlWyOTfcHT4rYpFZsx67EX2HPn3C4/Ge7lu3j6ephn
         TEMxSx1ZNl/Kp0lpdAudfc7zEriVyRDzo1u6D4HBCGk3bQNIYD5Zk7efRkvOvtCyQxTr
         MvdFujai4XPahcwlA9d/hD/rW6ALDQpCVQOaqrekJn2eOCkv7pK2bbiN4C50oVKVqWDC
         IAzYG661FvVDNsqiz9W1nf6sS+r4yN92dWVU9nGOlXFIOwvXEGWmuZnJcy68FyLV7WqM
         IRFJf7QVzHfY1wRWJJ/IyI8lql0vgYTi16h0s1rnQRmnh2fjW1Q1lcS+X1+BBNYPFcSs
         B1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768002364; x=1768607164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9C6cJ5xC1qmhxW2t2YZM9EJ2lpuou7pguCgEPd3I+cc=;
        b=UuAbFuGWH2SYydQTHBn2V5bfmCsMRIlFAHDnGfeR40TV42aDR4I3UvSihYzPRSmREK
         hfOmnav//481k/J3OquoNQRqmUX8wrMvBxTSGkdv2ugcLSS1cdCtghpdIZV1fanJ7Kid
         tzTdTl8CIQFXDwZm8iL+gw+lx9MlVd7IsUrLIoA5Wmd4mrqVDhNwAGVkWWt9ljKC74Il
         TRw3Z1Ai+9QIiJm1GhecqM2JlEGlXeEfAk36WKbRYgw+kVH+7xXHnGGljTgn9uxfiEXi
         Nupd+/o4gqCzmGzs8ri66mvjjTZBCsVjifoqmTDABoLj7HX0kXU+9L6R9e/RaZLNcst4
         tnDw==
X-Gm-Message-State: AOJu0YyWEMPJYB4rjIoaTNW0dPBcR+giJTWRnRzs4clZarmPab0RQy4w
	2acntbPA5br3FY9irYBM9QVVAwfLEvqVdBL3XLwEu7ali52JnrffNE3fepslmcC+Ww==
X-Gm-Gg: AY/fxX7/BIiCy6/DiLY5hEsgXcV6M43W5QbpR2wpHrMKd8s7b1rmn/dqrvF+YCha6ux
	NSWt8mo98UjD6nJJNAZSUP/vbeEZ9/vRjbNK6v2VgC6/4ddNy+hDlu1ucArRb7We68M7t0pABGe
	bxfJMY9RAAbKQQCT01KLxfzMDdGwnFpwT88iuKdW5ce7HvtPP1LsrvnFBHyFvi5578Bhj2azAcT
	WtV1JsrhR3W0Wh5q6x5hrJxVKrKhk7owkEEQtoTCYzCVmuNInLd0OeEr0x9i1cqk+9v6ayzIQYU
	K28iOZz3Zk5qlWwZgHFuTGLx1QpF6PJ0gtDfOfBNaptwuWwpWqLkIssB39wiOjUWrg9bHdhdSrJ
	OTjeezTFQlVGruBtkpWwwJCKsLjQ38Y5R23pfBm52cfgBoE9TmVbh7IOz260++Nx8L1h9c1649Y
	cWBQHlQUgceVPY8XIZ3WxYOEnZEMUnTHhgTVnF7jXkKDKKbyAcPm1q
X-Received: by 2002:a17:903:987:b0:2a0:7fac:c031 with SMTP id d9443c01a7336-2a414932ea9mr1154085ad.14.1768002363484;
        Fri, 09 Jan 2026 15:46:03 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd2ac2sm115208825ad.90.2026.01.09.15.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 15:46:02 -0800 (PST)
Date: Fri, 9 Jan 2026 23:45:57 +0000
From: Bing Jiao <bingjiao@google.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/vmscan: balance demotion allocation in
 alloc_demote_folio()
Message-ID: <aWGTNfrLBhCM3_-9@google.com>
References: <20260107072814.2324646-1-bingjiao@google.com>
 <20260107072814.2324646-2-bingjiao@google.com>
 <761533a9-b188-43b1-a24a-1893622ce18c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <761533a9-b188-43b1-a24a-1893622ce18c@linux.ibm.com>
X-Rspam-User: 
X-Stat-Signature: hnbufb3m45sdeur4efgjhd4au4xuwjau
X-Rspamd-Queue-Id: E5F3B4000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768002364-729348
X-HE-Meta: U2FsdGVkX1+fHGDe5h051Ag8NZeZyJpMi+wQKWM4QjpavQTb/o8rcnVf81kaWg/q+NYSiZrZ0DhXVae5G9+vHzbUD4wrHXLCNIf1z3N9j/5Mk6FowKikFFzB4Coi9WRFSyE7PM+TXVlROBjl/tFx9ZQOYDu2uhz3tzpTKHA9IuO30crc/p0qBfRhaR3kTXPJDhusmFKidIVF/Bl/toR02Kx3JW//7TdgVsrFUj8Tm4PLt0MIg2K+s+7r04cK0B7nHdmWoTDFPRVF/zhn3qGs/zpPbDVUD0Gg27LbUPi/abSH7AKj4qpoonRCB8/bAo+rKOzh0QNOumaVHlmzP6S6R2s9ZBDWoh2Y3Z0aPVn/RzL0l54TzSDZ0wayz+QJ8rdKqWQNbdAS59OQ7b+Jq8GS5qQEqxUtGtUy0R/948LGbSOkBI/N2UMRvV4q+aF5CkqP86JKsQycDCJ2y+PMuyxSQpAuDKcWVY1rUobHrr4sQ1Gq2Xqg3GPHzsP9+JyweznCGfPYQKe2o+79fbpqWWPXV1oRLYST6tIUoIcbn+EhYh5YZwnJmFYc/8JKecGzkhrNriaQbuTRqv/zOoWBbTBRY64Rnz+wG8BbicIExcpidQSXMsUac9/YIGawAh5DpxWhrAFE++8NtHAGQmkyZzpItXlX0++H628w8BQRuwsfPV511wHZ7H1X+gYZLPFmGBrM+A57xzMUaV4S8Vqa9WYwlwxje8CplJMnQijsDyFaVRFJYDXSWbFWoUyYxRSXSz58cQUGNBtDpEGRWqGcihTa5OARm8sqzQz0EAdYSYJ1hFECVRrbY7AAAZhN+RLegjU+6KFxnC9Np2Rhhjxg6B8U7xJBUYlJgiinB6IDpkE8h0teioSB0S6KZXFFsXy1EN4vP2akMIuhG2oZr8Ard4eHIyCcfkAJsspVaoO399ciQDI7rz+FOFrbhGMgFwZlW0zGK7mr8A1b6lusUYQWN03
 4F09agnj
 UZ0NHXg9sqU3bY+HfHwi6IgWRpetfNnTG1YNCjSJeea3H+QVdqWRnqPJ6q8cdbOHiafJbw5b2KqREOqMgA5M4m9VqRPzDBPgSyq/58scL3Wj4JvdNz0M4XMtkxBVPFNf5SaMaCcMEGbCwthlGR5zpvhMU3xzUcX4T4f5B/5B2L9iuBshYTeN7L9NLRuXUOliXSehtAh30q+Rz09o3D4738vJp5t+psmCJrgAqY35cZX1NymnP5B9Z/+/DXFW3Fn7QYSCZfCYxWRZep3ZQEl96CBLIwO8GQc182kKW3H9ydEDQbixyylX+DclXez0u3Kv2pGf83ZNIGo4LKKOhJ4lqtIZ/WHuyI1T+Myp5P62pTxAshl588ZrgUr5oonvtkEjQ+qxzqmOgEzOW7aqjjMDXY1A5/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 06:14:02PM +0530, Donet Tom wrote:
>
> On 1/7/26 12:58 PM, Bing Jiao wrote:
> > +	/* Randomly select a node from fallback nodes for balanced allocation */
> > +	if (allowed_mask) {
> > +		mtc->nid = node_random(allowed_mask);
>
>
> This random selection can cause allocations to fall back to distant memory
> even when the nearer demotion target has sufficient free memory, correct?
> Could this also lead to increased promotion latency?

Hi Donet,

Thanks for your questions.

Yes, the random selection could select a distant node and lead to
incresed promotion latency.

I just realized that the the fallback allocation should not weighted
by a single metric, such as node distance, capacity, free space.
We need a thoroughly study before changing alloc_demote_folio().

Best,
Bing

