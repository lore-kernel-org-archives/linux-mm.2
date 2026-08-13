Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B848BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886D66B02B9; Thu, 13 Aug 2026 17:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EE66B02BE; Thu, 13 Aug 2026 17:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7511A6B05D6; Thu, 13 Aug 2026 17:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FFFD6B02B9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:52:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7B71802CD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:52:43 +0000 (UTC)
X-FDA: 85097596206.25.50FCCDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D5A1D1C0005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:52:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShP49CXY;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786657961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPWwWsg42NzkR66lz0Lb5/9qFg0dG3r/LXj+Ahvs888=;
	b=eafZiBDglEtw65/m9LIXE3h3BtX2tOlgmsaOpGRI0sMfszaGtiEUIUdjAaLCqY01z+PIC1
	c6MJ17ISr9gJSEQPaqtai76f6dGwK4Vgm/p6H7u2DmqI9dfQ/b4b1jtHhBGcLWUecKazhN
	AjgRe2vs/QeAxvvCCS49BpDvQNwS5MI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShP49CXY;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786657961;
	b=kBTex/DqUfEsl20AJYqeSpoZryS6gsBx4dXrYWCeVVLGTPjW181f4jNgVyKy1/bXnHJEwk
	/1+vrJrya6T8sRH1KamrG/YDDYb1C9N6TdfldVxiuLgid+Z5aGwC2Y7CX+oDEbimpWx4G8
	2OGgGWF+fWBjBZBgxx1eHialhq96Jlc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E143843B0D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A81F0155A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786657960;
	bh=rPWwWsg42NzkR66lz0Lb5/9qFg0dG3r/LXj+Ahvs888=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ShP49CXYLk0QxQg2Nc1k7T6JVdio9hq5raF+CP4pDp9TcRQLjV7i5iuEj4cKagSjI
	 CJ9ljD34h256ByY9CPghLeQkTB96Mlz35t6pmJLmXbAcQ+w7ArpjONSdV1deP9yIuh
	 c+9HCu+MBujMmXMvoun/yRBsOXh5Mtw+8FSzYMLLMWOeNSQUoe0m1NmjccI3jnnO5g
	 R0eRMkC5Kl4fHiGQaKCzCuCEN2FGtrG/gfIxLcwMoOr6GCeYUhpsRVWKOu7KemsDaJ
	 yGjdGek0qQMa8o8nVW3nXhw//B+f3oZy9NdtZ99fGraws/tfjXEzrhkQwO81+2qlKp
	 O/l2YFtLeiaSA==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeb4508f29so2357556d6.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:52:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpfwx11TD9DT3dn/yVXvNqoInb9LIUavgXaOgvgCf8HBfQ3SXfnqS7EDOnNP7gPebxF+7n7VURwzg==@kvack.org
X-Gm-Message-State: AOJu0YxouuS9ciJwZTTIAvxqtoFCnM1AzvLWYCpiklfJwD6P016qPiGz
	7h3dzVOAvgsTschzGK8uatKCYkxEMYPd+Fekr6iC799QoiPZ5Tjgs32ylHNQoXK+qut+B7UlFyz
	lW4D/VidHEQgctpyes4cQ8gLoH8BWsUU=
X-Received: by 2002:ad4:5cc5:0:b0:8ce:e651:5d63 with SMTP id
 6a1803df08f44-90a91dda541mr8189086d6.31.1786657960058; Thu, 13 Aug 2026
 14:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-4-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-4-db943a0d0d6b@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 05:52:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xYDHMF41uVAaCP1=R5xKmNxkGtCd=YvaP_3Rd2ZEpbBQ@mail.gmail.com>
X-Gm-Features: AUfX_mz2Z5Z83_5Hl8wCOBZXplXZUT6uBoYvzxQ-sTw6Oz__9vw0Cqi3EJrW4Wo
Message-ID: <CAGsJ_4xYDHMF41uVAaCP1=R5xKmNxkGtCd=YvaP_3Rd2ZEpbBQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] mm/vmscan: extract folio unmap logic into folio_try_unmap()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5A1D1C0005
X-Stat-Signature: u7cw5ctwrpiqzeah4krf9uq8jai6bafy
X-Rspam-User: 
X-HE-Tag: 1786657961-34783
X-HE-Meta: U2FsdGVkX1+P6Y9+Agq5VXGj+Uv7vCxLOEFcil3eS2OIceyUodNPIhYS7eXRETZkIUNMYvkpT3kC0/FABY3jZhlB7BTArO/dckx5AmPKRedlaBlASWBGZ2iSN4/wgsCSRZNryrjSYFmq3civu6zSOR7MHjeM7LYhsUe4LR486nrtZk6TixmQg8IO0tBrp9tPObvT9sfdkC2gtmcWHKqvIzMbYGBmmLMmp+HvmMJDLOAvpxH62xvdW51vjNzJDseHGPUZNquN/B2isCS4eDvGkSR9TPUoz+KSOnt8FXItbOIEzDu/nZ2oVDgWUVGzMU606ffaSSfqtUs24XvjpmbQl9siOKVaWkBJ8MpLEYU1B9PQKYaCZBTttsN0HrV9E7CT19ZMT/MRFb41S4x3RNRWu9mDCggtdOvHT9olMCM6SCP58UAxZuBkMMzhdc1jDl/0nfsRhmUpJmpS3K6txallXTUkGnHCo1+eC/pUroQI7slEKHppk1QHjeTqQYlEabgut5JDZCXHm35dT2VUN/0+zaETycaD0HQ7s54VmzC0rdZyDnp0UODmJ3KpfStGJrxAp0rBOviJnDwb+f51GVFVGa1C7PrWTB+owcouz3U257iiPt0XtxX8lQknsiaszsllykbu38q98mMFoyGR4otIV5cTnNE9OFNhFJ5knDv/T1wddx8DmC/EMwMBZ95OdxsoZQY+uxyIAVntVhajHhZwwP6IB8uhBSsSxUHH6JbrVfRuoOHCFNIEo8FSjw+xxOctQGP7Y50RVdN+JwIBQG5SgVbi8N0CkfC+1F0ks8aH1NL57mpaZ+giigLUHSeggblMrgUmVIOlSVmQ/VJBVKwObm7jIT3pSWX8a8mJ1uLCBLpQ7KK2zEf7QKwLWpy3Nw0eZpJ2XqM3cYozA3ZLA8iG5NCT8dqVjw4vghaQKpihFJ5b3ICIGb5firoGEyn2L1Ze+6tzUzpOFh+73vQW4X5
 4W5Ei25X
 ejwnrR9FU/07Uii05NTZAJm7AwPwqSVNZ20bUjFpankMJIrcvAWptAwtmhSHMDQ9BdgOajlRBPqusgmjIivKaRq5OliB2EvuLjiMDo+qey6RIxHt3dsEcCrXtDatM2/MxrzJLLbv9EW8/CwEzY9z3vtjhqXL23otmByMAoZbgoCMPi0YGepc/Lf9wAdkYloLbGeIFTP/4CRekzRy+Mu+d//ghf7IxKmpK1x14f+r6eMHv9K3TBzCDJLGWFkSAhRqRuhOhXJjxCJHdBbLjPEmoa6qSjLKW2QY1SUe/b7rsMHIBiqAsxBzPtYNM6gK8TCIHRiHpZpTGszrp3Pgz5JKRBnuYI2eVPIZHSrY9dIqbUACFIMena4+lnZAZ+W7irsUZmexMv7dnHR4SwGhkCTRsD5tfSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:08=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> shrink_folio_list() contains a self-contained block that sets up
> TTU flags and calls try_to_unmap(), accounting for failures via
> reclaim_stat. Extract it into folio_try_unmap() to reduce the size
> of shrink_folio_list() and make the unmap step independently readable.
>
> folio_try_unmap() is only called when the folio is actually mapped;
> the !folio_mapped() check stays in the caller, keeping the function's
> semantics clear: it tries to unmap a mapped folio and returns whether
> the unmap succeeded.
>
> No functional change.
>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

