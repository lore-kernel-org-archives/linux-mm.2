Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9214D3900B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3908B6B0005; Wed, 14 Jan 2026 13:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3144D6B0089; Wed, 14 Jan 2026 13:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2206D6B008A; Wed, 14 Jan 2026 13:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0FA6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:42:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C49C1ADFB7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:42:33 +0000 (UTC)
X-FDA: 84331440186.14.67157E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C28B0C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:42:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixSrRuMj;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768416152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBnCNREOMaRTs8GPX9o6jn1T+H9j4SOjRgO9CydcfTQ=;
	b=F5RlkZiEmTkbSvfnuQfVYKCZeXf4/I/SUJRXE0LxEb1uI63Q0ek5Rfatc27946Xq8CZc3E
	ucY4ZOd7Z70ZcbAcLLdP1fupALVSVJdgCZseEc9FgUPMMAR960TYl2rcJMlkVTlta5kdhf
	8ow40cEwOAHqRif2EVGmhQReOWKcFZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixSrRuMj;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768416152; a=rsa-sha256;
	cv=none;
	b=pdeOkPI6X1Z7/NUWbs6TmXo8Cjabuhtzm2XaB5Q03K8MGX5hSpSMt/Ke73aQY85KSC72IH
	n6Q/riLc5aYpABFmEHPrUyI8naHjIFrqMWJ0H/MC21uKtwWXJ3xSjQrF7aJaOpl5Tl6rHf
	/3PuZ9AGjnO+msoHa1kETbn4Pa54RKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6769D442D7;
	Wed, 14 Jan 2026 18:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B409C4CEF7;
	Wed, 14 Jan 2026 18:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768416150;
	bh=ycsyR+UpdbT5i32Mze2qlwVxIhWj61Ue122fNAYGHY0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ixSrRuMj11g7YibcuR9ajWVVm3hwT2dwBpFnZ4aM4ryqzWSCkw9oXmRW6zfsIgTCP
	 jahC1f4rIshZtEZluXbRp/sCICEQOAPBcF9OadgwyNs/jEupj5lVVWX5O1epJEj0TM
	 D681YQbymK9TlZhbbH5aGzvWA7pWz9Ak9RG70/bM6V3TuJ12TnE+4/XwAL3Q21xneu
	 NFij89IbSZ5Lq6779M9VT/TZCQUM7ppogVxMlx4xqQ6BRugL8KReK5fGXg+WsN+FLC
	 AdH9yQFF2eMHSm5lewA1h/3LAqm5B17N0KoqzBS1UfcUBCPpKzh6I8bgvYe3uMUZTJ
	 48N8FVxcJKwAQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  ranxiaokai627@163.com,
  graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  akpm@linux-foundation.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
In-Reply-To: <CAJuCfpEwa=_fubhf5wBnFKrKpOgjyXRy94f2BDx38x_NALE_OQ@mail.gmail.com>
	(Suren Baghdasaryan's message of "Wed, 14 Jan 2026 09:59:10 -0800")
References: <20260113033403.161869-1-ranxiaokai627@163.com>
	<2vxztswoi16k.fsf@kernel.org>
	<CAJuCfpEwa=_fubhf5wBnFKrKpOgjyXRy94f2BDx38x_NALE_OQ@mail.gmail.com>
Date: Wed, 14 Jan 2026 18:42:26 +0000
Message-ID: <2vxzpl7chw8d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gjpuep6jsr651bfyixuyrappmsy55fbc
X-Rspam-User: 
X-Rspamd-Queue-Id: C28B0C0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768416151-505221
X-HE-Meta: U2FsdGVkX194sp9DXmsIpd7qD8MV8/2Ua0ZzYgQaTSt0gcf9+ik/DhI9ALPheft6Rk1wtN7BSmPZyYDhPsP007C8Tn19D5WdwqtmhuxznoGt173VkgeQyp2xjbkTwxNJrrzFcR6ZdtrX+f7CxYaMevJouliq9jCX4nF7eRfvFVMOjTFW74M0xLgVL41jzC95G05NOkM1/pi7zwG011pSrmithwnxypQttiM7jSgqSIgvcUSTs+aQSZ9+GfnokA0N2mMTfp31hyVbHzKs80IOCzSkacrmusj4gi+2WboEbm15/k2SkNxzo31+jZ0e2FxKirVrWXH35Xr2xmJ0T10Hps66+3HEFrsBgMEV1vVUgE5mDu8waFADDHhRLdW2kX34hVaKZCw7n6UJ7g35N9OQ8oxp/ulNFdlLHMHPDJr7iH2LLsc+5+59FUX0CpDmiM1LT5NKkdFOBBaSf6hFaw3wCq7uU+6JLwTk9yu6056DgeGYTzHoDnyOPaXrZEsZB93Eny0xOIqEUqcx44lKM73mLvrIWnLeWbIvjMSnKFnYWTOn85BGplzjVlsDcPfK2iDuDXaJtcjT+b7YsVSjoWOTbtsAT87NvgAzQW6uTiIAOQofHPqVTzj+D0bs5ffQOoc5Q8h/fWOwgii/VbkuggQYoyr6S3QzQU//OqRYcnz4TT0e3qejmg8SqD3IDkBkdk7CJjSG9e21AYwkg9W8Az/8vf6fxbnVRQQsPzafdahStQNj35iYAfXmth3A+Qtl/fzwBN0UweGOIa/MgP5w7cN4H3rGoAOOWdmU23PsZDbgryGmrSrkDUiVlQvUO4rCgmjFNXLsqHTsosnkVjrw9bjRORVI7ZdLrgP87o9D4d5dVvUWz2wc3/EzKcSIEQJ0VZiH+vgHrIRKubo9o67GAFnpuYbjZvl/6sOZ3/tsaot10r2iuRa4xnOVISmHbmQGSgWlu1feNyMAoZO/V827GAb
 dIUpGgid
 n+L7QPh76CaZ4XAZ8UyeShJyOs1Hzbl4XzWiAckPjNyJzUUYfClGIlJubYbyNMtPhvvBBefwbarrCQUghCsVnrBQI0ubRXe/5Z0XlVqDUc8bZfMY0n6M75zWQNicStjsi+q/NUoSmpL4LOPEjvbfec++CBiymWrJkZ2r631dVjuogmgFMHqIarLfGUF8ldlKFH5WJFFDLCIR1yvNuFJmmWz3M88ednSSDyg/ADkwqk5qOM1+B9XoTQW6C4kjiU2mFnTxRW20Kx/hF9Tlc87C4SVNxlJzUG61H67igxhN6QkGI6b3rnRPV437fxlJzlg5axa+6DlUQciYT7StOG+X2zrVMJqqYNhhGdwts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14 2026, Suren Baghdasaryan wrote:

> On Wed, Jan 14, 2026 at 8:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> Hi Ran,
>>
>> On Tue, Jan 13 2026, ranxiaokai627@163.com wrote:
>>
>> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> >
>> > Memblock pages (including reserved memory) should have their allocation
>> > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
>> > released to the page allocator. When kho restores pages through
>> > kho_restore_page(), missing this call causes mismatched
>> > allocation/deallocation tracking and below warning message:
>> > alloc_tag was not set
>> > WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CP=
U#1: swapper/0/1
>> > RIP: 0010:___free_pages+0xb8/0x260
>> >  kho_restore_vmalloc+0x187/0x2e0
>> >  kho_test_init+0x3c4/0xa30
>> >  do_one_initcall+0x62/0x2b0
>> >  kernel_init_freeable+0x25b/0x480
>> >  kernel_init+0x1a/0x1c0
>> >  ret_from_fork+0x2d1/0x360
>> >
>> > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
>> > fix this.
>> >
>> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservatio=
n")
>> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> > ---
>> >  kernel/liveupdate/kexec_handover.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/ke=
xec_handover.c
>> > index cd6b3fb9dcae..2d47f2c50bd8 100644
>> > --- a/kernel/liveupdate/kexec_handover.c
>> > +++ b/kernel/liveupdate/kexec_handover.c
>> > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t p=
hys, bool is_folio)
>> >       else
>> >               kho_init_pages(page, nr_pages);
>> >
>> > +     clear_page_tag_ref(page);
>>
>> You are only clearing the tag for the head page. The tail pages are
>> still un-initialized. Is that intentional?
>
> In the case of a compound page we set the tag only on the head page,
> so this is correct.
>
>>
>> What about non-compound pages (the ones you get from
>> kho_restore_pages(), aka when is_folio is false)? Do we need to clear
>> the tag on all pages in that case?
>
> In the case of kho_restore_pages() we call split_page() which calls

Not since 7b71205ae112 ("kho: fix restoring of contiguous ranges of
order-0 pages"). That commit removed the split_pages() call and
open-coded the page initialization logic tailored for KHO.

So I think you do need to initialize the tags for kho_restore_pages().

I sent a patch [0] simplifying the page init logic a bit. I need to do a
v2 but it is a very simple change so I can get that done tomorrow. I
think it would be good to base your series on that since that would make
it easier for you to modify only the kho_restore_pages() path and the
end result would be cleaner.

[0] https://lore.kernel.org/linux-mm/20251223104448.195589-1-pratyush@kerne=
l.org/

> pgalloc_tag_split() and that propagates the tag from the head page to
> all the tail pages being split from it. However now that I'm looking
> at it, I'm not sure pgalloc_tag_split() works correctly if the tag
> reference of the head page is CODETAG_EMPTY. In summary, this patch is
> fine but there might be a bug inside pgalloc_tag_split() if the tag
> reference is CODETAG_EMPTY.
>
> I'll analyze and reproduce that case. If it indeed has the issue I
> think it's easy to fix it by creating a specialized alloc_tag object
> with alloc_tag->ct=3DCODETAG_EMPTY and  make __pgalloc_tag_get() return
> it if the page's tag reference is CODETAG_EMPTY.
>
>>
>> >       adjust_managed_page_count(page, nr_pages);
>> >       return page;
>> >  }

