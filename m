Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C313606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LJZKrIFp
Received: by kanga.kvack.org (Postfix)
	id BDBEF6B05B2; Tue,  3 Nov 2026 14:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B660B6B05B3; Tue,  3 Nov 2026 14:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D886B05B4; Tue,  3 Nov 2026 14:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE926B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:00:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04A28120511
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:00:21 +0000 (UTC)
X-FDA: 85394723484.18.8558D98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67EA3140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:00:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJZKrIFp;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732420;
	b=U77AKn9bSxu3yVWqnYqOmZnhIw6a/X+okv8oQPMoAw5mnvrTiF9Em5L/Eg/GxrXC0JXeQK
	N2YoQd1tJ5PtNDt9Q0H9BRdKWe6jW8VtcbfRalQ8e6MYHv0T8Rqsn5H0MgZqH6mu1DW/Ck
	8VLL2e32CqLR59vO58mjKqC5naAd8xw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJZKrIFp;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaKapLJYP5++dFoozepE0lnkIHdswFBWdj5vNlVLQL4=;
	b=dDnRnCGvkAv3wtvpwRLhgyyD0cnYQlM2BEQ3r9B1/S0WYD27BeyOVMMm08VBj1EGhCKW01
	xdKa/q+whexxVAymGpCh8VnFdNSPWCK1CihNN5+8L8yj0DTeIzk98NnCOd8UfSzV0kC+nF
	Pn5EulRtTN3x7K0BK1e/KX0FRvcLsPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7533601FF;
	Tue,  3 Nov 2026 19:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615291F000C1;
	Tue,  3 Nov 2026 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732419;
	bh=LaKapLJYP5++dFoozepE0lnkIHdswFBWdj5vNlVLQL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LJZKrIFpProYve6IpbPTPKXS0osYcR7LSfwpwWEti0f5L7GYgObXcdMpRXAruuFy0
	 ykhywq6Ol+JkTewX3xD8MdK787dydcKQIZYtyRmlur1cLQkofvu+bILxkbyvZ7G2OQ
	 bLwK0Z2jqCPTnCgQV4fCiYglEEMQ6m6jFwV8R3TX57kxToxTAYYHKxyleFKcS5rkni
	 a0ttLb93BNHW70VZqvLeOTAbPOXqWJnsMDFCNGJmSmWEhDTWBEVso17CqnU4KWwA1A
	 6WCOKh3oAvyN2aZS9G+yxLYSFjvXrLTj/9Yh5/YlbwTv9u8rSNnSa9JAKNHTmglXhJ
	 8Phvh1cCmq5Wg==
Date: Tue, 3 Nov 2026 20:59:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <auovL7i1rEcXCeGS@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumvVjoHo4KeuyEp@gmail.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67EA3140006
X-Stat-Signature: k5yogmjxdsus6xmomwztx9erdydoukqj
X-Rspam-User: 
X-HE-Tag: 1793732420-684110
X-HE-Meta: U2FsdGVkX18EsGk4Zr+GTtlTNFWblndClrCVQFa9S5vE/xaWI66AImtsgIsxM+UGcAaPDpPoaIZx7rXRa8ZL1/CziUOBeK7KA4o4IqpY8cLETyMpbEUzFk1ejzgQq80FA/Drez39twU5/L8V+cngT/InvzNfEGGe+3KHghbrWmLAFNy4cR0pl6WnaHQVZhSCMhfogCQpoY6Gnie6dxSQRBTC/Lz/Ie48Mb5G8hN/MXT87m/KgNMF2kV+4EKR50n8VlsnA4Jy4F7ZrlqshPl8CrCuEQtt739yPz6QoJXf/ThDO2SD48Xs3Ps9Q697kVCv9j4iWhmo+aR1fP+oRIYzKFT7P3qn+dj+jJfZQeTk8rYy3/qbWcdtGUgqK/xhBCvnJONCcL2YyLCz+DEoGGmBp9Kj5AXOB/YqRVap9LiGyBbIoTa+18hHQ3fWTuJevaztQIY/HbfG3se4TDc4tuk7rWWbbDS/I8LS5F/+5Bp5yw20afO08E4XqeQIvweYJb6Jl9flCEs6ifRMjEQ8WDb943wyQm9EZBGFKMKpjEUerxq8ZDvTm7hX0SDfBwEhys3DCPinkxG6ruRMv8TYO8DEWjp5STjxhay4hAJwO0yxRfe0Jngo6+OpIh/loeP0WWI1TsmsHcofgfmgRJQc13cYUgHZrK0IL4jcc579jLIfw0nDr+2VNsNPwsgA83bK43wozuBX9N/0v5NHigpQqvWy9yqztEVB8VSM/msGsb2WJ2apb3JzeyaDovvywitKfP26EHM/QbxMLv0TukRl9T84kUXoq3daaDJDGmH5Mmi1GRpJ/g4SA8n7qgLApMaPmXPhSdWgCMZXsYBNQ336ZDHUwk/xofTaLb9Tsgb4l/IRSb02NCITm+UF3/WJdFpC5ayPfZudMvWsW3pzuePXSXRiU+YGa/S1zS/MNBR3IvurXtnYQW6mu/LAemSJrtzxP36raZEa34fAB/2IkECuf9L
 ycF5ynt5
 QyxBVT9glv047tV5xk4LCdCJQPvGIwK3By3AhF1VqvX+7MUbcEadtzM/L4pbH2ov3R3lvIgge8b6wdkyyFsQ1j9/CkyPaWJxMVVDRDHuuD2ZmLSgM4unG1fpfYQaoF+nOCal2XUFvjDtEd2mEKT9u+BOdmC7p2/v81lFsbGAubpGv4jA4DDcbf0KKDjqYXEGuMpLls8YUPvKi2XG2Y9yXZ+xYFjFptP7Sodu4aH0SEuVouyQ96uHnGgG1a+kYEtwvBHIjfURGNR2/NRDQDP7djE0JGFQaqOoLxXAGsmGQrGus+W2tMmXM4tcCu5ZPJRbf/3Op1+YNd/JseO1oY/36x2CJAvaQyfclD3qVL2EySudq0U9fZjGQ4xCjqW2Bx2DuHF8P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > 
> > We've been splitting internal.h to smaller headers, maybe it's time to add
> > "memory-faulure.h"?
> 
> Ack. I'm happy to move the "mm/memory-failure.c" section out of
> mm/internal.h into a new mm/memory-failure.h, as preparation for this
> patch.
> 
> Since this patchset is moving slowly, I'll start the header split in
> parallel as a separate series, and rebase this patchset on top of it
> when I respin. Is it this ok?

Sounds good to me.

Just be aware that MM folks are knee deep into fixes this cycle, so both
sets could be moving slowly :)

> Thanks,
> --breno

-- 
Sincerely yours,
Mike.

