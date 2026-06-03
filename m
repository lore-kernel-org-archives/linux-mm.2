Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F7AACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D66E6B00BD; Wed,  3 Jun 2026 12:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADE56B00BE; Wed,  3 Jun 2026 12:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB0F6B00BF; Wed,  3 Jun 2026 12:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1C26B00BD
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:26:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFAB2140404
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:26:28 +0000 (UTC)
X-FDA: 84839129256.27.54210B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 923924000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:26:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0H+xz7NX;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780503987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1JAOUHN1/23rK1iVgjg/ko1d9g6DgERUlbDFIlv2zM=;
	b=yUzUguaxcr/ONPd72Qk3WGMjCwuKvvr4OkcZuDAMMbNvS8jw0TsVTsrmq2P+XpAtl6GDtF
	aLEFtoF1AA8TaOr/k+AGL+wdooqZRHBHVj2c8Ci4DkBtnENWrMeoPeZpQRNTpIacp/XoM2
	/9KS5BowHzW0kLRZFZbCR+MHAP8ckhw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0H+xz7NX;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780503987;
	b=MAT/TDqSQ5uCfBJ1n9im0F61b3zAYFlUg6mTD6h7D1BGm8Dhu0j2oi3vjQpJ2oEBpi1cU2
	qZ5p4PZD0WUYqfXlecWQIsoRP+Q6NByx47EKCiLL366Tl+Xft4IV6HCGxQVUn8Cy2CkuDS
	vScEvlLRmeSmrU7j5CSdRub1a+xlNf4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F06A660142;
	Wed,  3 Jun 2026 16:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F801F00893;
	Wed,  3 Jun 2026 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780503985;
	bh=A1JAOUHN1/23rK1iVgjg/ko1d9g6DgERUlbDFIlv2zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0H+xz7NX4oJnZCyJJhIKFDBLzI8WOrvbat8wZ7+BlWqtw7z/kURDWBvu0dJBEQpQv
	 8TcCCtIq/hozD+OxgtcYRIyVXKW4KfRrDIHhYCXG9943BQJ6HcHjnoaKtx4yDV0hQR
	 A7fAxNu6xDMsxLYlOvURUnMWqbO7F7PCa7ViSQUY=
Date: Wed, 3 Jun 2026 18:25:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/3] drivers/char/mem: eliminate unnecessary use of
 success_hook
Message-ID: <2026060313-tutor-trophy-e394@gregkh>
References: <cover.1780397980.git.ljs@kernel.org>
 <010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 923924000C
X-Stat-Signature: e7wriwaq6kbfjjm8cbqabakhfgewohoa
X-Rspam-User: 
X-HE-Tag: 1780503986-662387
X-HE-Meta: U2FsdGVkX1+JSpvYavOa4EkY0bwVHea/3+l6/se395l0DzrjM9WXnE7or0LaNgDdOpW034MSQ2w8THuOqQ7L7CQFAEnFzeNeB/h76tYefXOmTCXy5qh4K6/hHWjmlvYm+6ZmYpwRKz9+yzzCH8zsKjwfXr20PRp7U2v+Q9Pob5DfONIy3C/eGXLLUeo+N/jR9ulcYHlyGIbEXmL4RRNPumedh0WTmIb6uubalf8BIye+KyL/9Qjzx1GHg5mPFeyJoXRNcm4ZHbcItEq8a9wZomDB9TbH/g+rSlLvgFm0utKwPRTIn4WesTONWZ6xtoQoBpW+g/6bJY8Bf32ssGsgfOCyabYL+O5zzwKguxwzXhbCnnDPwPpmuJEYlMYuZ5BuA6RavFCyP7/srhagcgOafOLCIYYKdIGM6KPivIs6qGUXMAWDkOnP1obyS+meC62QUfEC43KuCGTZCdWvwRe6+im6QMGvVaUYYbxtyEX2YOoVzoN/t1WapRGO+jBcQDCwQTGtHF+fWGe/gdA6jYIaXnKpOT08Eg5bbB7SLR5HXzYFMDVI1vHkouLbjEwAyDrE09aP3YT/INmlii+0EEESdL525kkT4+vozRIfo+OetkEV5zi3zzTefiRQwybgKEsZrAQaRmMewH+lMeJltj9n6vdX3YtZLfZbhimm+grZO2Jhx75QdCcz4XstOftCmyNbjNYRaXHNIJr503mG0StEhdoTLXsIVGJqISS32HWSqSctiOm9xvAZsPxiDGwjRy2b+P3jCZp6KnV4c/EUgnBfoi3WvW8KQl5yzOltRG7XmOdmbZfnGq7Upv5L8pC3kTYqsHD0u3VkhpEhEFGisa/uYx1HMeZiVohrAI7d20qsl3zfYe0oCK+p58+uBfK2Bn14hxufgw6cHZL521lb9SV2Sf/TQjuSg5DpDGXzzCUiYEqEzMYtwHNOMdPbIHqC31vexANPitbUNEdRopCFb+u
 +wWWmGUV
 Y2ZDNprVly66zpo1oR9GhAFtP0UwE1gUGmldRaBdjiQaY7maWFuKwUwhtsKtOp1ZZgcWZ2L2G3ri/HuPp69MqQ++M7R5kafDpaDmB+b0dZym2TV/7uhHcjlvr1OXocxLUusMyOz10Ag4pkn73V+ffPdV49dMIvBoOl3/NDUUnCkRP1Z2tEAI2dwGkeRlN2u0kOmJb43gtt+65OYAg1zCY80TLVCW65bPyBhr+YUy6HNy4Rpn6XlQd9ykwa9agFxGVk/QCuJCv5daC434OGl/9pc5bhV75X8iSbbKCqLxyiWvoZITZNb2Y7KqRBOjQ+HiMddTf8G1k15/uubJxTdNvWSAZH/40KVWKc018r/Gx289mFVab26bCJOxmfi2c7a9CevxcLLtPuwwrgRmpux994muIyPU3RfMJX+Ubn0guPyYt4EjDMd9E43xRYjuXqP3cHd/4sui3YV78+as=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:06:25PM +0100, Lorenzo Stoakes wrote:
> /dev/zero, uniquely, marks memory mapped there as anonymous.  This is
> currently achieved using the mmap_action->success_hook.
> 
> However this hook circumvents the abstraction of VMA initialisation so
> it's preferable to do things a different way.
> 
> To achieve this, this patch firstly defaults the VMA descriptor's vm_ops
> field to the dummy VMA operations, which is what file-backed VMAs default
> this field to.
> 
> That way, we can detect whether a driver sets this field to NULL in order
> to mark it anonymous.
> 
> We then introduce vma_desc_set_anonymous() to do this explicitly, and
> invoke it in mmap_zero_prepare().
> 
> This way, any driver which does not explicitly set desc->vm_ops, retains
> the dummy vm_ops as they would previously.
> 
> We also update set_vma_user_defined_fields() to make clear that we are
> either setting vma->vm_ops to what is provided by the driver (or
> defaulting to dummy_vm_ops if not set), or setting the VMA anonymous.
> 
> This lays the groundwork for removing the success hook.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

