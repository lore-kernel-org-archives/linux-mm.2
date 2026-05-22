Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E9ECD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6996B0096; Fri, 22 May 2026 04:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE496B0098; Fri, 22 May 2026 04:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB536B0099; Fri, 22 May 2026 04:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3D16B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:57:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D47C81C04BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:57:05 +0000 (UTC)
X-FDA: 84794451210.25.D2A4CC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30AA940009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:57:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNlsbfD8;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3GcOzyKQx/opwSym7kmkIz1q/A2cCWc6XlxcY4I5Gk=;
	b=sAHyiyXPUj5QWUMnfplS2TaNXzkyvM4FLNbTYNYugrjWW7avi8JKVIVnsOn/iCNxC5GGFX
	Q1c8ti7ZLlGwOmuVk1OSAXUAHDQcyqQ5RPJS2gOjWoYqm0xRP21gHJigpZzCxXnQ7rb9Sg
	DLpIaaTknGAtxlyna0zp5j29ZFMVpOY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNlsbfD8;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440224; a=rsa-sha256;
	cv=none;
	b=Qpdqwbg74k1WCMzBQYWdIEWJFk5HS09+yJJwf9OWUSoJxX1nfU2a1rHl3+CT4Xu8RBg39T
	dY1x3EzOnZvNkR0BqmdrvkvVjWT/Gnh1EPNhacJinbY+pwmKCxjbFnRmYRg74tmtfrPDlm
	6dJLs1NyHoOzS5ItwHh7fwpFAhcH7z8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55CF240BEE;
	Fri, 22 May 2026 08:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4B01F00A3F;
	Fri, 22 May 2026 08:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779440223;
	bh=I3GcOzyKQx/opwSym7kmkIz1q/A2cCWc6XlxcY4I5Gk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=fNlsbfD8FjyTESz6OuzkCrX4RT/DuLxPcyu/Fd2CWNvrQlVVadwmxTQvZTM+jQuH3
	 +3wcE9b8vq+xdlri3GT5APNk2OWo4j+dt61XJJLr7tbQVnBfgLsIZyB4Wz0FtY7iLU
	 fNwLX5kgMMD7YYwA+dh2k5Hct+Jgx2QbBD9hVbYr0/QyYTNXnut68KpjAXtnOohpfP
	 OzIUmnohrA3no54L4NePJvPrDaDGt2OphyVpVR6J9D8meA1IB/+cUaJfZQutctmUh7
	 d1i6kx8Cg0CH3HJ7ZXqDSh3ijmYjAjIzOYKLauI1+NC4npOv5AQ2YLni+i08nMyEno
	 znrxSt+xX2sXA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 19/69] mm/mm_init: Make __init_page_from_nid()
 static
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com, 
 joao.m.martins@oracle.com, linux-mm@kvack.org, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260513130542.35604-20-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-20-songmuchun@bytedance.com>
Date: Fri, 22 May 2026 11:56:36 +0300
Message-Id: <177944019670.3663073.4082076266566320906.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30AA940009
X-Stat-Signature: yxwbzy8ucmdoubau4x5g6y83k75up6is
X-HE-Tag: 1779440224-792882
X-HE-Meta: U2FsdGVkX1/O1LSMQwLvmL/Yqy9GA7NormgDprv4jFQhBvg2wRKAui0MosqOncWsvBNZRvQX+/BHmPLivNvK9RhzhXNaxAe7Dmc49GuR2sBRB88kkNUIqubJdCyU5gMsUWeiktW1V+88XBgm9mRW9s8lIYx2VI3tCmT4MkHu8dohjKV3YO+dmVSuTp8mll7Ba+AraLJyyZi3KpM1CGGqhpsaIrhipl+FKU8vbLz1Kd1f2GNkcC1zW9abnG3j8bNeF6/pV4A+cSUJiEjMGuQCZpWf3pruLR189dEBs1eKhGQpFxdfwJtJt0GQ0SoudQewXI0iscB/JjRyfH1gWFSQQamda3qiZ2JVlFVJHPD4t6J9BMnxgpLEZcjs7FKVD8mZNr5QXHSRJBMzMWonHblvmHXb0IRtn2YBnDLyDQjoP6n74rtEFjlB65YJPB3FmzL69861Z0a05BZTAuLhmO546qlyParBvWhs9zrSULxPLqR/bgWQiOcYSw6YwDOHFG5bo6f965whXfiiAf1TrQeCJi0fFkk9UUUq8Slccs/bXYjTYHZI+WLe5Z9h13sBn5rNJXx+dHf6WZEWzp/HuebKmg49tyW8LrqH4pxIrkfRVTIaOPRqlxDWWBGlUFZaxHX+0RqMyIYjhIJ6aGsBS2k9aUcaeXRrFcB/SsxslFH6WLOnE9yGJQZvfaFHnzp0cKx8lpFVYAHqPev7NTUAlAgEcYMAWY9x6vtxF3YkX7SYn31KrY3wLz26ANUE/u3wIzUBlStEnSaXrEbe/b1ExNg4R1Crg+FUBiEKrWh6uoLBvPsFC4IJGJVnnP9AIZ5lmWPLOfIVB7KhJLBbSo9NZ6xvOQJm0rK5lEN8bU7Pzf7t2XfKOkj7sTPKPQHMwNQKarebi+JqFYFgvsdD4MdpFj4xBZ6u0ijQZ6xOpK0eyw2Mp8iAxQTvxCglWs1hDza37WRYHeu2DfWoJu0OLVoam5z
 N0EZMJNI
 o2LKWLWjDT2e2Oyq+OZ2SqVQJHTtFxs1WTQLiWl7z4IXySNvkiZ0sp814C4pO9ODFoqeh2V6ieW27M7GmBYY02ogeZlwxN+8Z6u1NePHnicau9mJ4TffpX9wW2FwztjMJOdUCYNUxx2xk+WLhyS9Vhmtmby5VVN7ODvzoLfKhwMftfNFVC1Du/+R8BVRA/IUECIecGvfi3Pu1b9XW0IHdiggKiqJBBmvKSyH3wVuf0Tm9H5reaQFBHwvmWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 21:04:47 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> __init_page_from_nid() no longer has external users and is only used
> locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.
> 
> Make it static and keep it inside that block.

Can we just fold it into its sole caller init_deferred_page() please?

-- 
Sincerely yours,
Mike.


