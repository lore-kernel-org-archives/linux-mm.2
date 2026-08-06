Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1EBC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B04E6B008A; Thu,  6 Aug 2026 03:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285F26B0092; Thu,  6 Aug 2026 03:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EDF6B0093; Thu,  6 Aug 2026 03:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECE456B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:03:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A2B91A0696
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:03:55 +0000 (UTC)
X-FDA: 85069954830.30.27383FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9092160007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:03:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ez9zk1ej;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785999833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bun4OEi9tagpmxGrHS1oR5rbRsR6OkYKZiGDfVwiPHU=;
	b=dJBJGjkBuorvqtcyT1b1P+UvkF+qfRiTU9cVZxdMyh95zfjHpte0/cUy1BVg8t/lVvtW7Y
	9S5n38yQCFJ5SK02wjL3Ut3jbVv6qzSraPeDtS0VVFM17hX8zKAAT7fHtiYgjyjUlbcCk0
	mP2R9uH/LKHzXhervnycpQKjskIsPZk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ez9zk1ej;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785999833;
	b=AcIM2038N5HlfAgfFRmV65qkTNrhMIYvsEKKL+aDFTggChufpKAn0v4/eaozio3c4escFJ
	i4buj5t7bLePl3bUwycSSwxT8QHiXViGoegHvNKCrjhifapT7xtXOdJoRiOjmnUpvoMftE
	hU+bwXK9GDT52NRZJ2Xqax22QOmabLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D081141759;
	Thu,  6 Aug 2026 07:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1451F1F000E9;
	Thu,  6 Aug 2026 07:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785999832;
	bh=Bun4OEi9tagpmxGrHS1oR5rbRsR6OkYKZiGDfVwiPHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ez9zk1ejWKwB/nVl9E5bwSkKVYHKWD7WyLDWZ/XomFpQXqO7AA90E93iVx90FYzDM
	 DTeWgJxI8laH3LS3IEmL+5Yf/ydNxGhh293ZbmC5pAM4gOvG+ib+d51QchlnU/Ygex
	 csgnmEba6bBK2IruUkpKnPpOZsQy10kEU1KsgOyA=
Date: Thu, 6 Aug 2026 09:03:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-ID: <2026080623-showgirl-washout-3ef4@gregkh>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9092160007
X-Stat-Signature: 5e478ryujyxf1zznw1tgzooe5qeaq1ic
X-HE-Tag: 1785999833-680334
X-HE-Meta: U2FsdGVkX19CN9AkMIdD8Hlj1BeWp7r9T+zKIJn9RNbaAKiwdCt7C+7ah1ZKefyE33GzOOSLkgNHwA0CQ5Ee6et+oHuxlbRN0fFRX2MJ3B9RbozACLosOB1dEig58kJQpb436yYzb47uzCP7URAmRtqaQhfONO5PBj20EQFiMJTU0JIjKAeshSIHBf7a2UYAqP1Poasqs+XUdeYEoSY3ygRDBotIESPAbJu/hEjXSKiI9Qz5b7rHEs47GUjs+kqzloh8y4+24kFfCx7kGHjmJQaZusIHQuA1mSJzBlp7kyiu5In4nXSC7lXQjKORAFYjFijXin/9Fb20QDaMEMUw+FwCrzWXTT7iVl7gvi20J0xFOH3p5m31qb0PW6D4QYegmilQmAah/G1ZaOhF3PFi4111UVDlvmcaKpGW6KfEPkKGUUgYfOJ0Fx5cD8ExOLdPgCqD9Oi83LvunYRXbv/h2Sx4X6wpQN/S+E1ywOibo2etmk7LU36q5CgenB85G9LQsMipiZUwQRb4qoL2EJUvozDlr7P5asTirRdedMGa8lPCj+uMsasbSibWgK/P29BHy2vDy/cKYezUjggHjVftc+UR8ksEUcyvES7T+6zejh81oftkjO0oDJKqZ77yPQozdFybUW8pQBeVTN5cgTnQ7SxNEbXlM/fxfkER8ps/zjJr9TNU1+APgZEHT2vClOPa4hgt/3erl7WbJei6/P9gN7uoUdkLGXhIFlPJYJvviCJ5XEqJJNF7/k+9AyiAWasRtqsGs6HNZwVmKMJ+KqzMwR78Q2wDrxTLuRcwS+7EnPLZojNnp7jnHvSDajHKgjeQji7EsxNDCdTmQd3xvsnJFX8ZKQcxI98Fi5m3lfcx5eDQYWrfKlwnGPxO5TNpbKEUfEcOOnRC88r+GAL+jRU6q6q+NnZdNDaYIVXz/aATcXjKgi5bz7/KzyvcSe43SM9plvMlJibdv8pV+yC4+NE
 JUo9DMjF
 /rWtwfUj3FO1C06v3Me6JjePrQkOuuBfUQsw7o8OjgEbj6bTttesBkFahai1BUGwy7MfFT7buvPnVKRe6Wu5OrNr9jhsP8gkOFIQ2K4Y6nXEnwMpw+riSmxqJS8N/xWFYP5X2WdFnFRHsc0i5xKJfF4mUOj0BRR7e7SuE9lt666k6cmTVxd95w73aUPEw2u3xelAK8FnYEn6wsX480O51ZVOcCgUzLN8NYMfIyiJOURlllI9I+QYL+U/XBBUsadGzM3hvfZdAh0oPlSIsWN2xl41suZ685nF5GW5nIkzxc/8F0efG9UZIhr6qQfBOJu4t43HQHJF36viZ75dhh4Z1eCx3nCH0ilIYb8XNIjCokl+FzNayKefGtJBecsFtZ4K90tntZGiETNAVEGrE5rI8aDaoAXh21kI4k9aAfOjucXOCDRWVBOWITvTpPCSqMGZW+u+wxEVbq66FjzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:58:38AM +0300, Mike Rapoport (Microsoft) wrote:
> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
> 
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
> 
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

No objection from me!

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

