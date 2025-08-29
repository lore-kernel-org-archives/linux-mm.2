Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5E8CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227136B000C; Fri, 29 Aug 2025 19:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF206B000D; Fri, 29 Aug 2025 19:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C776B0062; Fri, 29 Aug 2025 19:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 051836B000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:03:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACAB01409C1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:03:21 +0000 (UTC)
X-FDA: 83831323002.21.E09A5A9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id C62AE1A000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:03:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnwdlmwI;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756508599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oj4QW0mRB1TfcC0bp9PnIUqJfZzQDzEwkawvrwwWBg=;
	b=b2AXMXPLk+edR/fdKGzcdFTfoI3tL1Q+L5sqQQ/0MQ2wGP7nqEa6zT2Q1PKmVi0Kpmvvl0
	AuDRLcpXv1iur9Cr+Y6FlfuhYKea5Ifl74O3W3UN8gbQ9uHb/HK4oV8vYwfd10p8AMdN8g
	uYefRhHwdmombzdPieApteS1mZGEje0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnwdlmwI;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756508599; a=rsa-sha256;
	cv=none;
	b=bSlkwfkYwyOmJB2JEmRlxTF7gEu6llA1Xjaggb7R7p42WM3sk291+mSVMhRxY/rmjCqPUH
	H5qV8UoRK3BhDiXJlbRCq7Xd2wQi5OEDsoBlSGpz0BqIOQsZ8WYt/tywr5s7yAOcjcHl9f
	vm81yG5Mm1Lz2zr6eCpVnHGAWJggy10=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24457fe9704so27772625ad.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756508599; x=1757113399; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oj4QW0mRB1TfcC0bp9PnIUqJfZzQDzEwkawvrwwWBg=;
        b=XnwdlmwIgS3hvXlrZOGfOpwp5VFx+nsSJWKlzOLO9WkOEOuuPHTH+VxJgCT5kbDNZy
         xX/XeK/EP2NLNYUlWJYkMOzdj+WIi3/J+4a5WdkoWEq7IO6qkLIOwt4C+2N0bgkd93g7
         WCulxyZ0ZtKEN4xNmqewnc8BBhHJrq/wRXmaSwCbFOlq8i4C3bvWvwh7xu+GlFHwFABk
         RtG7aCGNfLqKL3WvoiQspLIslCGAfnyA3NExz6G6WaM+GBWcN4zWTv904DHdgXEAo6sH
         TdDH7nFE16RcXF4XoxeT5IeSjRYz9uiZAjAy/mjNAjn5Nk+rGUGKvd7FyjxDPtLONmQw
         PPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756508599; x=1757113399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oj4QW0mRB1TfcC0bp9PnIUqJfZzQDzEwkawvrwwWBg=;
        b=Q/E57BN6hv4UPz9tK+xDUKM1xdbwCKlAsZURq7O5IRGWOzn6/w5Y23+4CqPXjiUjLl
         6XZ/LLtS0HKVXnv5mFlUGLNHtcmxbUvgFF5MrgpyrMF2nzxWB46A6EKy3QyKM/jXUpdz
         bpxiW8V+ZaT5Aee5zfWbEh1Henap1BXRdGlpvjJ/Flk485MaT037LL7SyGFhORc9Y+WI
         dGVpV7EQgh/jVZJp0Bu4Jlx6LBWdj0mgVYGKmk5BYscktttwAdAERhvcyAs3qbB0T/54
         Q72lchbSxErBEF9O2dwwz3jMGpjfOmWPFOXQMoRMmo+gYiJfuBzwP6AbnP4syjFzgrky
         ohXg==
X-Forwarded-Encrypted: i=1; AJvYcCUw/XNRNNUjtgDJWoRxU9RDTKISl1d/td6KeSm2Z/fURHnkq07Iw1GhaUxmndxNS3Xlc1/mvtMAtg==@kvack.org
X-Gm-Message-State: AOJu0YxYkpVi7wWHnaqyNmCFnlGHzub+RLjcU8uYMJdeK5AfJY2cAcIC
	hRLLrLbanVRmSjYEJgghhrnK7pRrpLT4aJP+RGUXUk2Hl8NAG08hvQvL
X-Gm-Gg: ASbGncsEn4f/kYxLLZ+eGR2fdac87sV7T/dbYIZxnzpvMFcwCCyzMTSJXpumfQkPPw/
	HOfrP0NxtDD22vIx4k7KU8T/oRMbQ8eMRWJo6APC75jr78KCbtiBpO9MjEQRf25YWl+xJdr+xtg
	zVcNhvgilapRXcbc1SGWCltdAEmmtU695R1Qps/ZC/3tXcyxg4+6sKpwxVrmfdwAp9pHEQisA9i
	R1NByKr87fFyaRTaANY6VN9YgWH3hGY+1rLFNzvVBp8KuK147K99MAXF/e5uZ5Cz3u5pVTPlnjp
	OTqgkuLZ+PCCc0cvD8E6Dt6trWleYsRpuKPmsIScuHy378oKEEH97zazvMq0kFAewOuyANNkGP1
	9e4jR6h5YSeU++5bHyqGwiA81nUn2lxOFRs+/qPeqgFmMGh8shESH2Q==
X-Google-Smtp-Source: AGHT+IFs2LIpMANw8QwM+tdtUSR872Tm5FcSSZAgM+am1WMsvCTQZpL9VlI80fpyk9T7Zoxr4m7TPQ==
X-Received: by 2002:a17:902:e751:b0:246:b467:eea9 with SMTP id d9443c01a7336-249448f7469mr4169525ad.21.1756508598596;
        Fri, 29 Aug 2025 16:03:18 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24906589986sm34697255ad.111.2025.08.29.16.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:03:18 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:03:15 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 05/12] mm/oom_kill: add `const` to pointer parameter
Message-ID: <aLIxs1cFhneGU5D9@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-6-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-6-max.kellermann@ionos.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C62AE1A000D
X-Stat-Signature: 9b5tw8enh6xurohtuh6oepxyf6zwp81e
X-Rspam-User: 
X-HE-Tag: 1756508599-119452
X-HE-Meta: U2FsdGVkX1/bB4C/Nnzy2fmB9r4OlzYe4T9hevP6P0TJsAUZg3iuKvBTktasnTU7QrV9jlEuVxpORxGqV3hrRqfX1eq9UOIIw7Dmd3MhW2lAVQtZY629xQeBaCgCFTLeNYINa8UDcK7PeYW5RA5Y1p28SKo9XRFGc5Gc9x1Ss1DOzxIcGNVMhNDNWA03EhA3c6YBskf/VNvb9XfZb0cKbgd9FOtBa8tc0bLGXa6zSZ3It/CjlFeXSfcsfz8F91m0tfBw5pR2i35Jkifeq1VB3ESRtxGPwJptYJpSSMfOUPtOGlQLt7W46Nq7JpO8qvvACIdqfTm0T+h2JifO7SYGW3zuvFhYxpZy06LQuW+Vcf3sE2Z6G0rX98gOUTgQk7VAmjW7W4cqOc1KJFSi+zLpPVAUlwRWzKRmHLKQ4uYGu3grHiequi2tvW73TQBX8RSjzprmAtINxGoZ7cA2CQ7E1DMXpa7/eWUiTFfn+ZO27dAh0hTOrTl0H2gssfjZIO1Li4SesHfMvHcWAI4lc6UuUGzOkG+9jkln2ENQPwGbQAsPn4mm2PiRvCI2fA66SyeiY0+uPxzIUWuub8z79chsYTDWOwtQlrZmff4h1va2dQTo3ci3HQXUJ6BO/TM8dEwOTRjfdEz/saL5Nux9dTfR0Mqqd4oynber5UxlYF0r8IE982m6N4wh2N3GzeREJ8x5+407MBLZPtsw97FWugDCB95oIEIZSG+rZuA7urX841WMMklb7SwMDCTqCLp9CjVBgGXhS+gdwQrcS80VgDc09l9S9SOQhtM4MO7En7wrCj8TYyzyWydWLZurIP0moM1ks+eYXylm7Fq12W/FF2vF9id7YjlItXI4p0gjDeIINqrogLo05n2cSBVLf+4cX6sGzpWW7Y7C2WVBxfQyqC6zP81I32YawNf+3lfG8EX377ODHswIutsA9uGzl7UNF3gHr/WIknMW4VjdQLUBR2m
 sljaukvv
 iKRnFY2SVQEhpA3apJo6+zDwMYL/FJb6AcsV1wsUyMWXAUhgIgSD3c86SaeQbUWux8oLHJso/OeD1TnbD0JHWtktwJ0vTVIs5ESyh1xtzCmMqubFk8hGhMme2iT34mSxMdTP/aPJJdbZCKCB+XpdU+P1HrIz4KPlGn4ZNAPHWEQWsDS+rvIU6JTy4SpFE7XG2WQkTI6mxSJ2Qu1gwlIHxeapm31gvpeorTYfGa6OxgY4dNyE9PsXwiflkBqbEjOljlWtcnKURlve2mvQFicujw+Dn5XQ96+a9gMOn2iuYEwobyPktMl9sDZwsct0M0xHSmdSECwKgCDOpL+on44zBJUqUTQHe/UCsKXEgBOtGJMMZT3P0SaHEQ907EagxVqMp/T+JK+udhEOLQc1+J2PwKMfqwseNTkPAVhYWkDmRvVR8sMSw70BkP3TO+bPw2oyTyAeKSY2XPxrEitJDJ++vb/f/mehZoMv2Wgcq6wnG3CzlTATKy92j0YgDjaj47VNimsfJZAL7hVjn+spV0fuPTvI8oUAm7i/U3eJ8Om07ropZqN7l3NKDixq4jxuRmr9USutHqOh+hnfhwA9bk/lEAsiBfw3LuW+UriUE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:52PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  include/linux/mm.h | 2 +-
>  mm/oom_kill.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a40a3c42c904..a795deef93eb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
>  }
>  #endif	/* __HAVE_ARCH_GATE_AREA */
>  
> -extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
> +extern bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm);

Nowadays we're dropping the extern keyword.

Also, Is there any reason you didn't also make the task_struct pointer const?

