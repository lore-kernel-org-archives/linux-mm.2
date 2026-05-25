Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFA8CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF176B0088; Mon, 25 May 2026 13:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FEF6B0093; Mon, 25 May 2026 13:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75BB6B0095; Mon, 25 May 2026 13:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C54E36B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:19:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71BCE1C050E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:19:46 +0000 (UTC)
X-FDA: 84806604372.29.E12D77B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D573818000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvQBosqH;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wu0JytchWi892cy9Rbe8Jo63tHJaQJzkGdnUYJHGi5M=;
	b=ZrpCY4fv6uQg9oGIuv5J/mraGnous7+u/zv0oGC01P0xVpjLIhTs0S5QECxlH9vmymt1Bj
	EBoEBU4z2oevLsiLnB19Ff+pp57VrL2H/acEYLe6K+JWAipMkMXk3w9A/kjWKWmv5Ei4sA
	TNzxhLjbnRURgHJPCfhbQJQyAiqvZgs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvQBosqH;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729584; a=rsa-sha256;
	cv=none;
	b=JWFmF6GaSTkH2PzGQkmvI9oWFUC6TqAChw57k9Il6cwINl+TdANICdLHBEi47hURMdZWmX
	ZsbDVLEc+rK6i2IEaC0SpszHeIZhXAz5ApfU+XUAEGdPe45JUgVnz9ZUoCKTvquTCdYJKf
	n5o0+MQha915jNonYLUd7m+sUjpyLlg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1225B440F8;
	Mon, 25 May 2026 17:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21B31F000E9;
	Mon, 25 May 2026 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779729583;
	bh=wu0JytchWi892cy9Rbe8Jo63tHJaQJzkGdnUYJHGi5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dvQBosqHNOOqzeyxIGbT+uY3fnEI2sBSVY+Fw1Z+kdR0F4bUiCfscUkDYq/sZhe9V
	 nVZsqXRIXK2/WnH/OaWD6ulApKmgoiFEITCjt1BP3xR6rjdRzHF3fljRYtYLEEOvJw
	 RtLOazVjgIFAu9DE95fN7v9WEophxyqhbSelwTraQ8uG8WZyQtw8XWxfDys40L10W+
	 dqVAw00+UNPrRVC82gJUh6pYAGSiZOj+NvPmNDNlAprtsmpWJdk2MKj9wyAzA79ZYi
	 XRyUssQNB9GRKHAsMtOXMISDpslXxRp/vdLqcPqYh8mA6t5imwPj19jO0nlBzbK2mw
	 kXYUk+Ovr6dQg==
Date: Mon, 25 May 2026 19:19:33 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/69] mm/hugetlb_cma: Validate hugetlb CMA range by
 zone at reserve time
Message-ID: <ahSEpapIOBUFjAhs@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-13-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-13-songmuchun@bytedance.com>
X-Stat-Signature: eertkk6w5wkqy64ijnmejx76u1w1a9s9
X-Rspamd-Queue-Id: D573818000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779729584-454880
X-HE-Meta: U2FsdGVkX1/2SMQG62cGWqSkJog78e9aKa0bDcn1eadoI4Hpb29X6+bZ8+FDYPm5M07vF7xBFs+jX6bXwMFkMvG5dlPIdw+YkJgQpyAcIqqZZnBXG3TzqETDw3p7IAKoz5iUH9YO+q8fvQznf/PTwRqfWwCSoKVpiSc2EXh8TcL+eqx+1TPL0zgUfNSyRy4R1hIdcf6RKvHRM60/3lTt6ITzCMQVu6kgJUgOJ7Xlvsy+W+ALow4rfZPuLF80Qgk8kmIg2bxSNgmI8fJxSggHKuhBO4lnhs9F6mgHWS/ivUSfKYPX43N6MFCKfTzIMZmyDKxw37FebvZDEjFbKYjGTPceJRbAzJsu4Hoify8eNRMnfJS/ApgkXerffh8Jp43uRwiWGtdPEgsDECtLhqx3iYtH+HzIw8pR/7WBZ3MaAS25BRt/N9H7dzwW/CckILizF5yBf0NFE+0kyYjQ/JPl/N7EdFwFWV+9VUXxQrcYRFms9Ux4fv6QiK8rBlEdq1AapRUL9hV9L7AZjXdDQd6X1fzpZxC7Naug0v/K23uNsKxaQOJIIkMhZ+GT1W/NloyViy6y5RnDgPqBMI+DkpUjYemgc4Hqcl/Fr5SDiY2zPqnLL+oLxaj9ooZ6YmO6ulblkL4jgdvc6XKBXR+duC7BxVhFTg9Q1w0wVuQd1AM2qVOMAo2+mgNoXbBSQo8qLwyfcjL/15wMrZ669cTRTxUeY/g6EvIOokkYWmWQa8QmlYs85KwDr9MV3+eNoWNbJgxaTz55Tod95Appba9xLHLSKMnrZ76o3EKNyN1k6ri4udaAj4HT1qPJFjRDb9eO/8kODe4cEJGZ6nd6aCS8MdSFk0DU5L/3fuRgGQOpHAu2V8SIGsneOPl/WXZTJ8ROH71LVnnNjchbU+19eiJ1pNu5EaLj83AxGM7hHhHrXcms/X1sM+y4Rmz0aqdW3hbmuPiUdKr7z6OxwlN2t4+PINq
 EaFPNVhx
 DmQyhqMyYdllu9roi+uTx1G8ovFNcSqRI6xPTsyAxvQXlP3hWJ+StXGT2EbnPU+a0T73GZbo0f+wk9vdDnItaOFA6nemotGcuK0h5lYLnNceDftEcS6L28P3ykgt0G9SavPOvA6DMB8C0BNVCaTol1dJEPlJAU99J9Xs2Gwy9317PPiiefuixJFhsuA6dZkqC1IcnJrysnO2M9YRtyHvlZXa3qV9cbKxmTWKkWor1k8ZoqY5CjOCjZVRg8eKRv9keK9vnyLmo6A1FPN9Mbhmk1aIweJQy1WxmafPoz/msX5vxDQjxOdgr/AvTSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:40PM +0800, Muchun Song wrote:
> Hugetlb CMA allocation currently has to cope with CMA areas that span
> multiple zones.
> 
> Validate the reserved CMA range up front in hugetlb_cma_reserve() so
> later hugetlb CMA allocations can assume a zone-consistent area.
> 
> Also drop the pfn_valid() check from cma_validate_zones(). mem_section
> is not fully initialized at this point, so the check can trigger false
> warnings. Keep the sanity check in cma_activate_area() instead.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

