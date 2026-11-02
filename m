Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A64606A333
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vs+/+xid
Received: by kanga.kvack.org (Postfix)
	id 45E126B05C0; Mon,  2 Nov 2026 05:19:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F086B05C1; Mon,  2 Nov 2026 05:19:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2628D6B05C2; Mon,  2 Nov 2026 05:19:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 051086B05C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:19:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 920E140C81
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:04 +0000 (UTC)
X-FDA: 85389781008.16.AD373D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7443C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs+/+xid";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JizxB9+/O2FYFC8VNtmlHXhEXe7Zkla/YOFqDR0abiA=;
	b=7v5RfXxSPYt1wXeClZDs97ABL2SCWQ5U5tZzDz7bhyKKlntdyAE2Meq5VZkUx4uyeWe3hx
	VOPfpIVez7836+6Tep3+7/LylvAxMedI8kLFdwuIlQlOTMYSqO1T5BzU3eaYWDFfPLaxXe
	IG5ipLUnWRTOCdhHrUzfQSNTaA5xWac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614743;
	b=wtdgpo9Ojs2h4JuGuXriIQUzPxBC+Pb2wxdhy9hOt7M26CD9SQb7ogWBA6e+V3JmjuWmQ6
	Ht/2+18oa+yaty4lJyWVr7YW20Bs0nHA4fVqITZooxeM6J4F1La9ATMBFDQkU++Mqd8SAB
	gMSNmAbZ6tDsUFiOrjDoKd/3HpuateA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs+/+xid";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4520E43E9C;
	Mon,  2 Nov 2026 10:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C0B1F00A16;
	Mon,  2 Nov 2026 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614742;
	bh=JizxB9+/O2FYFC8VNtmlHXhEXe7Zkla/YOFqDR0abiA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Vs+/+xiddGPr0d165YhQo+3HBwEpVZ5d5eHPOjFpwf2NHdVHmNbVoTEJRPYta/Ard
	 xhQRO7ndR3XkS/bIPf6GzLnqVqz4iVKXC/S8XZ3P9Qf23uyR65SdYiteSdF2zrcWFk
	 MWyQLVMhwJ7Yv9BW8sWc5QIesiIVYlOBJFsbMoxx14fieHA0UM1pBhb3kJNGENQtR1
	 DAfh+QJdhh78jiYBMUjFLA8gNkT33jAuC6uTwLlaRf3HwQRqpOOyYt0ILjwSfnrjDU
	 hgPvvr4nDCX6Z6bI9lefM5IeJnaFY/PT4u54hRiYcNdJYvudF4MYaM6gl6V5Nr1xwu
	 KHA/LJwSvqc1w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 09/12] mm: hugetlb_vmemmap: make vmemmap
 optimization folio-oriented
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-10-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-10-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471105.1337633.3204394103246469526.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7443C0005
X-Stat-Signature: uthjwyrzq45qp9jbhmard8g8yocg8n8e
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793614742-162523
X-HE-Meta: U2FsdGVkX18ROpYF2cxpo3P5D0yo/1V0Kxz2LpKPpreTp1ZN+cxvMcmhY26bFgYfX7CGU5UT26pZ+s2Fus5hXLOMu0JT4UGSFS5eMlMFhoyh5ZWHWy1tcKAUyD8d8xsbdkXyc3r4f3QCJ4v50ZixoeGTNhqYPc7cpyvieyNKt+MSp5+pDqW58Pvz27KyeeaShlaMCiLvBn02cCoq2v+LXtPJnKNF5uLWynCwyPj/0zkImvEgiinrrRGon2aSLHP8V4UWsN68bjr+h/w2eP8GRrya0qdCfbAVYGavCbkb0p3lmQKXtXqS8oMqtUI93sb/QMbPKKjxGC1MwdP8My7ePKa/9X8fogURHLPZUOJOAG4Sp38LEhOrSm3sqo9+9ROUQ72UpN1v8vGHhomERYM9U1Sr5jwAaGi0lQh3w2m/nNqwGlpuflAvc5rLh5fNUa/cVvwtqojgGw+KG5bj3EaIp47pnvsNTjZqxuQH+qERmSttDoXJ+1GFJRvR3yTEQDNyYF58qhbvPXHXvk8f3YOXbRDrVHOLfj7CqCBo0gyWP0ZufoRe8ExSn4Kec/1iLTqyu6VsTTgllWEKOkL7f2xjCDLOnr3leqm7l7S7pjrs2+cA8GblYoLyvVIEAWCxRaDrFw/9rjgYLZXhvCj63kMuUwtJOfjV/YDl504ahbKViigpZ30S/dPY0i5jlVW94lSctZfIymc9LXpxz2uqEcBSDrD2tpMN+GKlE+Hxl6hDOIv6MVB2u1OOtDGkVrWBBxK+xXK8tfMSfUTc38mdgR/Bbz/pm0FlXUAx/5VvJ8gdHSuN818CYFmBShP6nETZW4WOdtzosti3Gba22q81SShxAMvZc3gUzF/7ZIDENPlnRzNMUkPjEcx5YUIi+MoMGCUboyNwj5to9vlHbwcellRNtvFvZf+mFRWcKOHauWeGHySygEBesBVEKFRukcowcyfOre40WyfSK7TnKvWP4uU
 xv+RStrW
 REy7so48nmOsaxm7oMzqumGqex6rvMYkJtNc8J4EadwCp2We0Rbi6VDQhYQ6/lA3dU4lktKlhw9ORvBn/OmOT0WYy+mb56v+pLYXItajJY5lgdYJmyF4zOPe2H8W0+MvIihg0sDNiLYssnuLdjX2KMthSASQxxMO+HZ+19uKz71rasAOJYUvYMFLFX8UjKLhYj/SluqBSoFO6LjBS0NF0SHFhWRKHSpIWZXG4c5cWToZRBuiWcYLn2Mv5pWKTBQh7MdNQKxf0BVjYC+FXx88QeY0mbezLrW3MOSnhHxxkLUD+ab1vAv5mhTZYqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:22 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Vmemmap optimization operates on one folio at a time, but the current
> interface exposes a raw address range and requires the HugeTLB caller to
> prepare part of the operation.  This splits the common mechanism across
> layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap optimization and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
> eligibility and state in the caller while making the remapping code
> applicable to any eligible folio.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


