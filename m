Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD2A10F92FA
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87416B0092; Tue, 31 Mar 2026 16:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38A06B0095; Tue, 31 Mar 2026 16:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75346B0096; Tue, 31 Mar 2026 16:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 942BF6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 278B558B1A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:10:58 +0000 (UTC)
X-FDA: 84607451796.04.38FAB1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 551B9140005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:10:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Li1mXvhi;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paD+/wsH/nD7ZHrccX90X9F31tvjRhK/4r7V4VUt7YA=;
	b=yDOPDKscuQRKRoBaUztFQd4wC03ge/vswq/zvDS1qXXDhNfi/UCit57BJ5X/qIk2Rgrdt5
	lcAXTmrP53bFYXH717HGz4dMq4rKpf4CN9e2vSzDdmFA68wYVQOAkQH6vR8TwGkjKsdpQh
	K19V4qyLMG0WY1ejndY4V8gNZN9Pml0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987856; a=rsa-sha256;
	cv=none;
	b=kIbYi6pxPrCIfAeCaH2/rbTEIRoyyuOEc8OiIppIbXEb9ZWFc/S/p8AuOQ2CqNAONWPwlj
	SEHVsUgxK7GxK/G2CZZYHVfaL7TJ8IIx1R0RIH2uTTkcoA4oAzSvOOzxhn/xWj2Oc+OBRx
	Pix92GdP4rrGlnMaexqWaSycfuWIpa8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Li1mXvhi;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3494D40B7E;
	Tue, 31 Mar 2026 20:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F11EC19423;
	Tue, 31 Mar 2026 20:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774987855;
	bh=+Yio7/ri0s/iJL0oI/nYBoKFzbIqiKCVNVdJ6dIkhDU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Li1mXvhiMq5g/jZpq8A83N8h1xx9VwEqAFLdT1/yfdcvN0woeT/PXqPJKSk0HL+Xc
	 mv9U7u5QwFuVPKhRK6hOQmBJGYdOEo/Jf5MPKTiBEkiOWl5Vsfkmg/fWrHrLMwYwVx
	 X/AYi5V6eMOwkrS/ertDT+mMgMIdNxTrcNpElmVA=
Date: Tue, 31 Mar 2026 13:10:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Frank van der Linden
 <fvdl@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
Message-Id: <20260331131054.0164f3b3ab6f7868add37cd3@linux-foundation.org>
In-Reply-To: <20260331113724.2080833-1-songmuchun@bytedance.com>
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 551B9140005
X-Stat-Signature: gen7i3edih7r79qgywmuxuy5qroxsyxm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774987856-206946
X-HE-Meta: U2FsdGVkX1/8L7CE8lWXr3+ANxc22rC+Tjrn84jVzlfr+LgT6vjw/NbzF+kCAFdnVrvVWMBblcBYv/56XMv2BkmPzQ1pcJk3+2jZxDm2hM1dgGBGsokl4CLeTsD3pGn2gzaaF8AwhHr8FRbh3XPIbYh9xX8ldngv9Zw/6CXl9X1zXSYstZINRpqUFhCm+tYO6dKwgDMLkYXGGym4uy3GT0ReegP2hZmHwoy+3TB+KHZLNgM6xHA7mVtfNtmdiqC4wLwGxeyHjdOQ7wPE/sFnQC7y97OQ4KrCmv/Xg1IOVqGrf1DVlqwkTvAIgZ05oz/1oYsh1nWN70Ij96yG8J7xPQsDVVt2n7UwHVPTy8BaDMT+EUyvpxGIMxAUgvmP4TGJLFwIF2KUd1hVFe7EH0Vc2tegDo9XdAn4xJdbA7jQwaqqz1c2WKoUNZcqwow9MVTQ17BRrqifD/BXQmytI2wUpkvae5W1iClZbvuiTLM919ftMgqWI6wPfWxbJWOkuSGBcFGKiOCdIiPu09HOyzZQvmED36H0T7uMgSx0odimlz9nK5WUTTUoCnkeGaLDwaaRwBpbXAm+7Ancb5FqBsPlbjTPI/3yaHGP77UAjxAdDstbCerVF9pSSVYgaXu/s3uWH/y1b0YPYB92pyrRn+NDkieHq7fwQr+gWGVpFaYgE+hUkwuU2etu2iTHmYLlyWiuIylHnGdfxOo2CuuWB4RviAnZ7BW6138l7lFIVt5uBmhNhgHxuibqrxpOXZkDaMWlAodsLxr3+m3XM1HlRChRHIehhjRy/+eis+Nl5gbad1HS+gQY9vmFcOL2tu7JIQmqNOWbiDbdMNW/fiCoZ5Mdyk8mIbujwA3654CRV6FuCZSDRzDQ0d2aZHdkQx57gv0jdnCzENS62hAzQNw2Oq2sER+I8wpPcTI/EhRgSEl6oZH4xN0tZol5sbXHfcm5hlTzom6ZbHMV0ujijqhZjGP
 4yL9RB+p
 Wk6/TMb4mBTdtbInvJQvnfKuJ9nSvOzwkDUjq1q3eOUqHhRdB55Fgs8jSf0+2s7jsqfYvxUCBrDjkJ2RP2gDEK7uSS/Xnc5yXgj9jqv7rWNaLZCb6ksdu3bJL1nnXOM3lYhiNwB+s0Ee6dZe/o74Nk5JScUle0HSW3aqtkI7VV8lkbQhHOGlD0dh0jaZGt/kOLZjHfQFbQ9dOMIaAxlcDe/VWQcKsUKBrFBQ3jHtz6rKNVEh3PvZpzXb6ubTBcok3YMYt8ffvws5gZWiTEexw+TJzvkRThMos8XDmXxleHvKRhU7fsFwhHspQDhWhpRdI1helWJeIEoxY6yHOsTGbR+6eBnqH7RkKozMLDnLVqMhiDeCWLErJyow/00kvF59QXFu6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 19:37:24 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> sparse_init_nid() is careful to leave alone every section whose vmemmap
> has already been set up by sparse_vmemmap_init_nid_early(); it only
> clears section_mem_map for the rest:
> 
>         if (!preinited_vmemmap_section(ms))
>                 ms->section_mem_map = 0;
> 
> A leftover line after that conditional block
> 
>         ms->section_mem_map = 0;
> 
> was supposed to be deleted but was missed in the failure path, causing the
> field to be overwritten for all sections when memory allocation fails,
> effectively destroying the pre-initialization check.
> 
> Drop the stray assignment so that preinited sections retain their
> already valid state.

Here I go again ;)  Are there userspace impacts?

AI review thinks it found a different bug:
	https://sashiko.dev/#/patchset/20260331113724.2080833-1-songmuchun@bytedance.com

