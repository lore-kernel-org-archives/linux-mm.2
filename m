Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB443C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5126B00BE; Mon,  6 Jul 2026 08:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCAE6B00C0; Mon,  6 Jul 2026 08:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2CF6B00C1; Mon,  6 Jul 2026 08:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2D56B00BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:41:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E395C140107
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:41:36 +0000 (UTC)
X-FDA: 84958312992.04.170484E
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B0C84000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:41:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8iTsmAN;
	spf=pass (imf01.hostedemail.com: domain of abarnas@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783341695;
	b=gRsInQpyqpTyl3ZV8n/9yJZOp5UDg7cZldcPW+WclWCS96BOoZcV4bsm5MRJ7BKMZhOooH
	COAJx+xLIYoOXhU1CgatzAiaN7MHQnP4XbhNjb7yz2+oi/C/5sqG8T3pzNDuviVWhGbWEx
	6HQHeDsplpBDS4k1S9ZnR/aMCES1rac=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8iTsmAN;
	spf=pass (imf01.hostedemail.com: domain of abarnas@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783341695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNDWrM8Kf/Ycz9KWp3LxHj0yAPyLx4c78mcYsxXCYm0=;
	b=T02KZEiY6fVWjf8lnYY59J46nwsjzLwFEcKkPnQ4XmE4GlOvw5pascTvoRztBBG7XiFYZY
	YpPRyeCDLhy1NxiKYfPJfzW8dy/R+mrHqj3d6HaB7DMznhx2YC0Qp3Iip4K6Omt3t2Ua3L
	+XryYxuE2I3T0CZFfOc0TAF8+X2mFww=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so20530655e9.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 05:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783341693; x=1783946493; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GNDWrM8Kf/Ycz9KWp3LxHj0yAPyLx4c78mcYsxXCYm0=;
        b=U8iTsmANGuEffI4t9wDXe6bMMv6FvYTZOw6SDDLfUUhET6MZYGUPO3jhjOM7Tyr84I
         O/nqVgzCqvrLMLZxunaDTTqMI7dtYdZEqGWkOxvI2M9VgzRo44lbJ5q11Oq9//CNmp+Y
         G+qtJVcsDsAOKuZUS+wJ2BTLGkUiZe2BAI1qJ5KpWQG5VuhHNmZ/wpyliORf0Mgi7EcJ
         WaDkCLNIbXXMTQacai5OViShyXWhvuf/XDNOe21znSi5fk2UPsobmCB9oYm/w8hW+ijp
         BUyqvt0OE/YuDAvSZDL+njjk54PHdyUaFv0VF3iWM9Bpdldb2rBrWf52HtMLplRBHO3H
         646g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783341693; x=1783946493;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GNDWrM8Kf/Ycz9KWp3LxHj0yAPyLx4c78mcYsxXCYm0=;
        b=LQ3zZqFKURJXR7lnVPqZJ7j/2WT1b9EKTd2tWkJsA/ACdWq9cBuYpmJ+tAM33gthqo
         RcutfC++pULXC5ch0jsPq2vB5m7PX6Lc3mkCLppmuz6HilFTTSc62Vr+MPj5ENJZhYUR
         gqtSrfkkKdK9XZwOQsCrEP4PtbeNlVgnbpGUlx74Pg2qRn4s6KmRf7rN5dkrQVTWyrD4
         jC0WiOSGk6P8Cxt8d8OQyDjDjOwz9SeZ8sIbS0JHWrNDsgGVpl3IreeEOUuzKnoymg2c
         Rpc0J6bToYIRgz5J+Iuc6JPzaAQ7g3qHf+xHt83ZhqyZKIfIMucpwA0auzWI7edEpqhs
         9tdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+AhK/SjwM7VxMZi47F3n46jJyQ3ncpM4s75qTPKH7b1Oa+5DpgMQjM4/Iq6nLbwVr0Bsjh91+Tg==@kvack.org
X-Gm-Message-State: AOJu0YyP0LQV5qwAYjPeMMeP5iQQchI14RSth2C1wRfffbo5jASFcoEJ
	PKZXSbbt77VcprwdROjWNy+rLc/LhwFK/54B0D8+gjauzXeLjDB4v0sMjBF9HMmOag==
X-Gm-Gg: AfdE7cnSRU3+ZbU4JoloFCtbpMnIuxFeO67VQOAJfIbX+gqhIF1/Ci8Lal11Sx+XRba
	oW7KXNeBsYaxxn2tBOJL2c9PYyc+N8sk19/LamFWOcIxW0GST+NDSYA1wVBgp6JW26VTRY2XiAP
	gsmw+SN1PigGwf+GRwiGxDORZbKElsWom3M/GtSembU8F+yEVzVkgJGmRNmkWBJO8Qsaqtzw89e
	Qn/VKpgdIKz1kxcXJglmFCmpU5dJk0ezkaw/ELBNJtMQVeG5o7Zghi38IvgGTmW4jtxhbprlaTI
	NmB7K1CGkvlsezYgrgVYwKaXi8vbQNMbREuIMec2cVrPaLQAfyv6gp00vXxbF1o27mk/6UPabd/
	6vbFKvbRgdor+5dcTPsz0UpBgwaQS7ZhMCEVQR6TMx0uF7d7IAl3LGP4IrQgCKICLBnuIQwHk1M
	Vvwv3myWUFk0oBsI9WRI36GYmWC/LteHH5anPTE/seNVHo6Yg=
X-Received: by 2002:a05:600c:154e:b0:493:d216:ed96 with SMTP id 5b1f17b1804b1-493df0b6a8emr2959835e9.9.1783341693045;
        Mon, 06 Jul 2026 05:41:33 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c636ea60sm326134815e9.3.2026.07.06.05.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 05:41:32 -0700 (PDT)
Date: Mon, 6 Jul 2026 12:41:29 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <akuieSDlbYdHnkCV@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B0C84000B
X-Stat-Signature: ezkntf89ttbrhbjxzt6ye65sbhzogo6z
X-HE-Tag: 1783341694-196814
X-HE-Meta: U2FsdGVkX18r8LYSrzd1mWux0VZmu5tUsdvfIJmil/65zs2YApfveccRJflKztn1hNg2ANOPmBkh++zw8xe+hBLgXEefq5jNmkLv8m0+7C/TJzvpgzu+EJVeHzJUtPFrZe59CDZRKy8CpCBorlk5PwwtLiCyQ+onPb3+0oVCzuusRFG77MhmEGgyS9sFY7aJ0ba7oTMgPPEvJMELeLeJQ86btB8/yJDaZUfohdi8b0rYV+FBsp634dfu2h3Vle7v1Epoj8vqaPH4SuTSQDQBsYvEgG+3SOIrK15+VWEB2BuTfIWpzXKa/YM7lQTOvjo9BHbsaTMH25BaCVM31XMZPFTwCW76UhS0quSvQa7/FnnkPKnHQ81FFRD7WWDTYYq8czUw4a27NnwJ5VH4v3xG7WvcVFRjM+AIxyPCX6SiruYusawlbWvIkep7/k5XG0pw3F1hud+BPkNIm735JRGL3yb9NVMoHSX0UOBBZqHlYRmcUYiNi5Em3lKamreKfBECS6ZOyIn+xouPUlWvDzYkHUy/FC7pzvpQXvvjvWwy1S4gWkM5GcqqnLulCfUNg+x9b74PNuLFgl05lnMYx17avGBBkit8VB8OUBe/u2Syt61yPTIKndkipLPaImG5MYfo/QG+V9sk1dEgur6xJCW0S82kBzuE8gMuz+bbRK6xQiPUfKdGOldtL3GOYcyfmWHoTUS3Awq6UnIurn6WvdAr53eS5C5vKxEF21TQ/n7kczgt6b+vgOhkiJb87HeIi0BVy1R9mQkl5a2W3qw7W3/GPhGitoUFRDMdAFiUxnj3iPD9CCrLT+7mmBfKsckyPn7g9qPlOEN2l7vb2CtYPMrt1V4y1hGbUAq7PYgE3QMt69Gp4uNRI8HuXFnOnQINau0wB1ptBcXkKoGMcRh3EOxdyPFNZp0y0qzgSDT9xz2BQr5br/pMSXvSlYu451lBfdYNUQPFtBjRAqOg7QotiEt
 osE6y0vd
 qMK2EzhWJU2hwpJJL4c6RP3fRFScq3r6RiPT8ez3mCUM6chq/tiEccECbdPKWqoKQHAnxceNgATF3LNQbwnzE3Bo3h0iFH/KqtKWLinlH9sRuYK6Ls3r62W/Tqdx3G0A93VILx+54Q0ac3hy0A+Im18lGirIzj56GSSCNw0oWiW8U+NVSfJS9N+fW8sLBFIq76lRrDBCkxMgiYmi6BzCJKLp00tTnPW72WATrWarCBBRtIfxsC5M1AZYYAHAWlo9ocqlQJpZAhtpd+5j/bRhKCUx1as9DPHcZh97KGJ/W2O8BqrksiGMrPyoesVu3WgxqBGlu9xZOEJXC644PuaZzj6wnmmZtL6F+4jJBQR1jpxQZcarwg7jbzMxbaplw/7a1dHzl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike, 

On Fri, Jun 19, 2026 at 02:40:40PM +0100, Ryan Roberts wrote:

>I don't think this is safe in general. Let's say we have a 2M region split into
>512 x 4K PTEs. It's possible that the first 1M is one object and the second 1M
>is another object. Different CPUs could set_memory_*() on those 2 objects
>concurrently. If one of them then calls this function, we could end up
>collapsing the whole 2M while the other is trying to modify the PTEs and they
>will race.
>
>Note that splitting _is_ safe (and protected by this lock) because you'd have 2
>objects backed by the same PMD, so they would both have to split before
>modifying the PTEs.
>
>I think you'd need to ensure mutual exclusion at a higher level if doing this;
>probably execmem is the place that can ensure that no objects within a 2M region
>are racily trying to modify their permissions?
>
>Thanks,
>Ryan

I wonder what do you think about enforcing mutual exclusion for permission 
changes to the ROX_CACHE block as Ryan sugest?                                          

Would it be appropriate to add locks (over `&execmem_cache.mutex`) to 
`execmem_force_rw` and `execmem_restore_rox`?
                                                                            
I see that x86 has a lock that wraps entire process of updating attributes 
(including spliting and collapsing pages):                                 
                                                                            
```                                                                        
         spin_lock(&cpa_lock);                                              
         ret = __change_page_attr(cpa, primary);                            
         spin_unlock(&cpa_lock);                                            
```                                                                        
As I understand it makes it safe already.                               
                                                                            
However, on ARM64 there is a split lock (which works fine for spliting) 
but for collapsing at least on my implementation it is not sufficient as
Ryan pointed out.    

Best regards
Adrian

