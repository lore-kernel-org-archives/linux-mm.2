Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BAECD98D4
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375D76B0005; Thu, 11 Jun 2026 03:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328BE6B0088; Thu, 11 Jun 2026 03:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2157F6B008C; Thu, 11 Jun 2026 03:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD4A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:56:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DD7BC1E20
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:56:29 +0000 (UTC)
X-FDA: 84866874498.26.1C8F53B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 055B3180006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:56:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwEgXzhc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4CUTTj1LLBvt23WQfDYUZoOfs2On1CLjSZO6t6REcI=;
	b=NSP4uYB/1hVN7q5wIhxD7uNjm9P7MiDiRmv7JRsj8YbxmdXn1VSb3gC1a+oQ/pQ27DB24L
	YYWZPzMUjBzlchW1BlO3/OAuY5d+m0pCvmFzdx1gxIQIf9YTgB11wwEV+d7Cb9QPoU2iYV
	HUSQSC954qWoUaTY7x004PeNZVK6/M4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwEgXzhc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164588;
	b=bEIOTkWHepbmReTl6Qxj1HT0L4mbGhH7GLJIZ0m5BajhDFqxEV4F/+WYjSUJS9LBbC9+wb
	QivSBitKWrpuoNOgygeCPDNRlCB+QbIoifKa09Uh0FVlW4X5ouqraB8G+oE+PoJSCO6Nfz
	RFp3FiDcf0OBb9P0LiQCSokneptrG3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A987600AA;
	Thu, 11 Jun 2026 07:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17F21F00893;
	Thu, 11 Jun 2026 07:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781164587;
	bh=a4CUTTj1LLBvt23WQfDYUZoOfs2On1CLjSZO6t6REcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TwEgXzhcjfcH+o8flQYenxnUgab6Oke/RjBQ1UCEhJcTQzCdm/PVDqD6orTJmZZDd
	 WbhwEdep3rYaoG1RwJ5Os+ni6Kj+cVXdlhaKC8tcvpKzcjW4+oDmmSBO+WKArFPM8/
	 ZnkZEuRIq7Jv5v9eGCiLkK7rwEYwPM4eAGP3NW71PJeS2fMAllIo1UhxzqlBWhF5Sj
	 qrtIBCl26qjNG+BFmZIKhYRUoXhsmA1RruEjlNESbrnREzi5UvjZisqIvJfGEzYTvM
	 nODevr95peYmmpE7aOldoG+wRiuTpjwk9Im18sJVDO+8ZNnRVYe+iYeELHj5JKTuzL
	 HWeug/S3df66g==
Date: Thu, 11 Jun 2026 09:56:20 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/3] drivers/char/mem: eliminate unnecessary use of
 success_hook
Message-ID: <aipqJBeoYxUeH1dh@localhost.localdomain>
References: <cover.1780397980.git.ljs@kernel.org>
 <010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8kjdtqkffegsfjxdm1b8zni8xb5rs6e7
X-Rspamd-Queue-Id: 055B3180006
X-HE-Tag: 1781164587-959828
X-HE-Meta: U2FsdGVkX1+0z4HNS5JYbEMPC7UVEHGJSHDY1FGamEZcvruBad54Uz+kPoA1fLqdFhBl1VfLxDjH5iLzT7dw6/C6+MPKY3VC+mQW9lN/wE8go1Lb7whrPhWBFyPejZMJCBjdnbL/YlDxPw1jToNpNMnG6ClVP24Vk24tMA+YOZ75dwRsB3nh9kID0f0ef9o86OWPlpMJuYm/wcwqavr3ewE93MtZKpLZI1oW75/Sy1HRCdG8vhdGIufXx1jt2Fcc76FsSQj1Jpv3zqErhffhdB/d9XkHOQR0gxHOZMrJpklrrewlqJa3cPj8UZrwFe3MdjAwLgvi5nja4mrqSa1wQ1Gq+KNgTfHYn/P7ExyLtORGJ5yqeM7rZFAfy47jguG7+RfCRmxZ7vt+vJbtRrW/mAfy3SwLorluWBBraB7HMwt8NdevugkrpfCUemYg7V6uv8NmZRHzEAZL/b4LHptG2huJapTft4ePkt2JA8Csxgx0sCIEJrpwSKeVNP55YSE5p1RWbMzGeEpCHV3Ry+p0ac535ObmUqR6FpzLQVqsZrUD9a0WKp7pGCTSF+1ry2MYYT82uvBAzyRvNEBzz1zr0XjQ17w3ykCSDmzUXAayoyFLnlRWvwxAetTG6j/nu+I0c1VOt0V9K/A7VHfM1e49mlN/DVY2ZGff5IMQmO/Cvstr2uA+gf7T7M2cBRAcwNI9sFoVy9acBhFXiO2JO0xJTLz1uZMoW0q7QpqjWepxver+r+QrLa78oA2Q7QxN8E4h163yy4MuaYFr4+JrDBYMnJ/ZGWg2tC58107G5WAodUaY1JIre9lV4woZyiMkxMdJYFS5WHUJcfvk6OlAXvTJTiSMgP1zoTDyX0AUZjb5bJyoW5hbQm0C9KBF7DEvUSISEVHwh02RMjKzXGRcIFh575OujjusG2J29JF441lE9eK7Fvx0AJOQZxoEhbC4iitsHvjsANiU9RCM0STgAoq
 fUF9aUjR
 xTQMr0CGpJLRabUb+kBgPaL3banPBYLApj93r2HDk3e/x1Ym779O6WLADA8pIOWKQyZkFdWzp6wpAt+CMmG6YYd9uq4huHaAGiPlqzSgyzbgr00G5Pl0MeiQDaVXBlQtox+YHFeBWZ34Dy7mRM1kHDg1zgmQ17Jojxvjw7i5gFeuzMmMDC+XjK+kepWArUBZolBsSNr9n/8q4gC3C7AZu3Zl5PtIPZbWa9tZnwWuAmrXz3hwnbkRQi7AF0AK2hfWz5FIu/Jr2M6mke/FmVKpafUPlNB37KYIUTUqf
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

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

