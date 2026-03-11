Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D461062894
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E106B0089; Wed, 11 Mar 2026 08:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7198E6B008A; Wed, 11 Mar 2026 08:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FACB6B008C; Wed, 11 Mar 2026 08:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCD76B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:45:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4F968859D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:45:58 +0000 (UTC)
X-FDA: 84533754396.01.00DA4D8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1AED180003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:45:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lA1fIAR9;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773233157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqD0PaWCyAkS2OLodKpw+KFK1MpnwVPzgxREHBBvcmY=;
	b=bJLQaUOz6FDo2BtggGhJcJMiCBZmWUfpoBJz+WvXiPABnFiUJ0uO/LGJvfUWpPleEWTd41
	1nJhG/PhxVh2Ko9UO0/VFbCzySBJ4xhshOKgHV8APyqZ1axfyM+ot/X8yt8QgBvuU6ISC+
	zbfa6E2osfsntlr3+JYBs9bh/6Mwj/w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lA1fIAR9;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773233157; a=rsa-sha256;
	cv=none;
	b=t2Y1YiUVSUNiZC6m0gT6bOCE4p9ZCV2j/JRdAk5aDchq9eJQlTW5ZrvFjDMKFPRfSpUaiv
	Jor2ATNi8n8CJstdls9e6iVwdrwrYFy7y6OA4a1BR6pUQkPDSwf3GhjSuQoIfA+Cfmc4/9
	U3vLRxEOQIUDBWbIOsjOb8Mo3AvpDdA=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so36672225e9.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773233155; x=1773837955; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqD0PaWCyAkS2OLodKpw+KFK1MpnwVPzgxREHBBvcmY=;
        b=lA1fIAR9OjUk/TzcMV1C37Tp7I96ShcflhezcoeYDle+muclHLSfiYjHHSuXL2qUS7
         JCnvjuDr5WgOsnEf2k8N1YmR10CY9+46eKOZpTmGCEQu3wRfMKK3xc/TcqNozI9xytIe
         Tx6LS3M7joZO04htzFj5GXHxFg8DmNrHQhzT3e//uBaCPKX1p//y/LDdkgE8PkTqRJQu
         qOpiQHNz33LgemQbB7HfUGDYzRxrqPnjn1oc87ovkdrdq5G4kj7LMuuNsB8A5hYMaUWQ
         eiwKc1yYvHlX2saH0yko4UNqPdwph8hpRZUm6JbNsLXLZyBUwGF717C1tZ3ep3r9L8H8
         Ebsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233155; x=1773837955;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqD0PaWCyAkS2OLodKpw+KFK1MpnwVPzgxREHBBvcmY=;
        b=n0wPP2xHnGtkN13nflnRrCxEnlrpeF2Cz5/kSRZ7G76OWh5/wADiJSuBV0omtENqgf
         I3NrjulW3qlJuIg5oHN78pTi5kkMJ+mabC+MQS88FR7XnnnDKJ/z1e/GjRb4zE1EskMI
         olT3cLClmPtBprAtar98JhxhtN1anuPwjdz3yZlGw0bOm6nVHGlk6dKAnrgxnqYvbKzi
         rFJ0qTlfgZu5wAuMSaJFN7BB95x8rJqfw4wWcxl6oWt89z8CWW/tI6tG66yD6OARVoW+
         JvFXEQEHwj1ym3CbGwZQv2pncEqONFUXdXDx/BASP0YpECLH5ZTE/LGovgym786OcWEe
         simg==
X-Forwarded-Encrypted: i=1; AJvYcCXc/svQLSqXy7r0xh7LEsWLJGM38f6bVBZmn+bw2rR50+fMRb5PDf5vy4vaT0vrHoeD7G3wjdv7Kw==@kvack.org
X-Gm-Message-State: AOJu0YwRKtU0/67UrbXmEfahUw97N4FgOngvJN06bSJH3YREELsNqntG
	lL7GlGOAGsrNI+v0PZU7dq5Rav+UJxgc+eqnY0igBoaqSmABcwdtl2+U
X-Gm-Gg: ATEYQzwc4h8Fpig/PgsCYdepIKGSrbn5m1iiHHpgZilyZVYjzoBkkEQAX9XafT+jeP0
	HZYsZzq0QKAg3eM9Z0aodcHltlrUfoqaMMD1HB0SQDLt4eKr4w0poqHWVL7ahnwZ24er33d82b0
	YbBLY+xz4E8liBe8ScvQRaIQN9ka/axQN9/CG9pgc5i2bO8Y4YnAsUsPjFe534jzah1SMfFUA+a
	XWVh7ZGSFocrI7BzkZGNlRrZTsDB4ELJ1VPlwR66SUQd+scQRfsnZ1reRtwBCqNncj36bw6bF6C
	CdF7tDhaHkmL6iO2PQIRzZ8NavoMWJb8XAcMr0DxMb3GKXca/DxYqyUPeAxJJjtYyka3g9ZkvKf
	49it1Dk3IlYz0zGjQcNOhiESBN7qQgLRbR6WdJE3mapCxTYvOR+rBjGlKWvZ3OK9qKp6vXo5XvU
	tjjsqAKZ2SQmf17Ss6erSj4EWmjE5xEux5
X-Received: by 2002:a05:600c:3551:b0:485:3f72:324d with SMTP id 5b1f17b1804b1-4854b0cabe4mr43611225e9.14.1773233155263;
        Wed, 11 Mar 2026 05:45:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854e67ea40sm13055285e9.7.2026.03.11.05.45.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2026 05:45:54 -0700 (PDT)
Date: Wed, 11 Mar 2026 12:45:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	david@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/migrate_device: document folio_get requirement
 before frozen PMD split
Message-ID: <20260311124554.uqdqyvx44vkvclz4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260309212502.3922825-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309212502.3922825-1-usama.arif@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: E1AED180003
X-Stat-Signature: hqh51brcegufeafqs4zisfs3d61u8ey6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773233156-740072
X-HE-Meta: U2FsdGVkX18dKNaw+kzB5m0GBxh12XGmqVx9CpiOrIZqLzW1OxzDvTJ1gtf6jqnmu5ed16PcoLUobemjzfM4EufnegM474NKNd+L4x1W+ghHcrMgA4TRAQrJQCs2gqS7bcXk82xILRKrKd1s+B8PqJI1oSmmgMgNi1m+RwmitFaGYUZUy+GHzov9b+0lTuQYL6OAQ3RgnGN14oVG9kpLroUO13SzbLexR7EMokTCf4D7Z0ZvpUz7rwBqfahhWmmy5a6+5t58xuDDIRi0ob7ZGbmaNxmCnHaTkU4wKWKsMoGr7KEG6w/daHvnh2xFF0lNQpVI2CsnFc2mgD2Y602M781KCejiWLMmQvqxJv7SXuQlgXuEuGGt7QPZqq/NvmzZzbLGg4Q6sRIjzWicK0ryWOcJWRmH9cymHcrH/J+qnsyrBpjdbhSYCtby4vJ5B9XAhHD1JM62+qyXyONmnGNcse2tCcE5ZWRfFZL2LVs0cWTwyV63GQqYSVvwZLZmdpaAW+vT2jnYHyag/gMViJsxGD7jjfI1n3vhzMqSh8XtLu023jNxkO0e5wvj17EuIdEgayhSVPfCfIU6KvHwEop+qzgYgMG8nd5jA6RZf2SN1f7x1nrq0TB19W/TK141zGeVrJt/bgW6qszruesFT3hphu87dKKShALX8cgnKcNordnddUuDq3LFiJaiE8lXGywuN3tXAQd8ZilnPtI7gXbCL8h41HdKBa6JCOtcJ/RioCREOWewf9aOCL2Mzlzhs+UP8FbSLnr3jlkzWA4Cif2gT72RHeXsNbfXxRiDs1Nzt9cG612L9SLlUdJMdCe8R7EhPEAjvGYuOKUWvOUW1Oi9qxdGUzjOJiv/vWnWPRGGiZfkun2HjafOyrKQ9yvF5jiAyWOyzUolpNC0+o93yMKr8vBRPFQmEWyAe4KMfyOpYKw5QP3d2ryVuU/plLsOiMQr19PC5I18kQERC+WNE/J
 6WQrZorD
 FuksUB1cm0geWllx9QOucHzMl1AzV+arP+Xbe1LcCfLcCmAdS17ueZQobAGDDTfBp9h1LBHtThaJRstkgAOTub5z+yC9QsiUslPn05Qv4C86k0DEzw9WRMjlIAyU/IUujs9OIxY5XlBc3Hu6NLJl+0swFi7qunvZRqI68pmYguwo+O4oqZp/Uh8lkNhK5FKkEM/IkwH1O4eAvae6NmLnjJ/RSIoMc7es2D76o2w9E7IJBvLJL15n5ypNR7lg/U2uVI4e98V+SWmeim5bfa+JGvphWWSNkq4PV0wiubopsAYy5CYeTjeceGBYOXpVne2QFu+f3qVdovpE+wtqU07feGSf9uv8l0U+KXT7kHbI11UmfjhqObDxlNMHOOnpQtvBNcynOjqmBMbUtaNY7Zi0upXuFv1eCMKyK0Lp9jElvlQKhULCOF55BH+PB0CatWyZ4rIAh/CsVNbITeH2Z7txUADMmKr6F55IJNFaLJAtNXEWx3KPBduzIfBfSbFKNa+LvXVBdQmP2HiD4iSIL0nN95OylyCvkKkbLSu7hdOIuhR+G/O5AeCnjKFvja4AaTZANDFWM5ONNOBAO6d009dNSEOvYSdDmXnHcKkiK9oxJz3mbxXs+NBG+KK5PJrViEZepK3J8oT9FyJOvB1HfaYNZWUhFTQthKJYLmJr3pW2b6T4lU1kxzs+FdwBnfsFaiRrYPLmj0av0igCSouLdRk4/ioS4ircCQUUch9fgopzG3g5eiIxaut+NBINuwz3EgQ6yLnwoNicMBRv5d+vtch8kwU5ParBQffATC5PBdke/Tu796d+ebd33uyqDQtmrzutC55+x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 02:25:02PM -0700, Usama Arif wrote:
>split_huge_pmd_address() with freeze=true splits a PMD migration entry
>into PTE migration entries, consuming one folio reference in the
>process.  The folio_get() before it provides this reference.
>
>Add a comment explaining this relationship. The expected folio refcount
>at the start of migrate_vma_split_unmapped_folio() is 1.
>
>Suggested-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Nico Pache <npache@redhat.com>
>Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Another thing come up my mind.

>---
>v1 -> v2:
>- Remove warning if folio refcount !=1 at the start of
>  migrate_vma_split_unmapped_folio() (David)
>---
> mm/migrate_device.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>index 78c7acf02461..fbfe5715f635 100644
>--- a/mm/migrate_device.c
>+++ b/mm/migrate_device.c
>@@ -908,6 +908,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> 	unsigned long flags;
> 	int ret = 0;
> 
>+	/*
>+	 * take a reference, since split_huge_pmd_address() with freeze = true
>+	 * drops a reference at the end.
>+	 */
> 	folio_get(folio);
> 	split_huge_pmd_address(migrate->vma, addr, true);
> 	ret = folio_split_unmapped(folio, 0);

This makes me think why we need an extra refcount, while other user of
split_huge_pmd_locked(@freeze = true) not.

The put_page() when @freeze = true in __split_huge_pmd_locked() is to balance
refcount for the mapping count change.  Since after freeze, the folio is
removed from one pmd mapping.

So we need an extra refcount here, as this folio is not mapped before split as
the function name indicated.

If my analysis above is correct, I am curious about the put_page() in
__split_huge_pmd_locked() now.

Currently we always drop refcount if @freeze = true. But when
pmd_is_migration_entry(), we already unmap it and drop one refcount in
set_pmd_migration_entry(). Would it be a problem to put_page() when
pmd_is_migration_entry()?

-- 
Wei Yang
Help you, Help me

