Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D690AC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5D76B009D; Thu, 23 Jul 2026 07:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DF86B009F; Thu, 23 Jul 2026 07:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD066B00A0; Thu, 23 Jul 2026 07:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87F746B009D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:33:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 205661C093F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:33:08 +0000 (UTC)
X-FDA: 85019830056.13.804A1E0
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A30B40010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:33:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UmK2w40M;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806386;
	b=2Mwo0DSynUCqMmPe8O5WvE5V916ZNXOAIyc+o7rEOXrOIAEfXnNo/sUsbZJoxOLyT9jHim
	QsTdFLcHtUCSEDgqc08Zt/70LlovOsA5Tp45/0SwzktflvZOD6ZK6ycfJm9h1l6TEnB1/O
	QdH99CSMLMdw1bcQpDN7vzeSWZBsvCo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UmK2w40M;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uXExJqvLMtKg00EjemEMSid0MvB4tr4xwG+35o6dDM=;
	b=FO2TPNNaHiimp0B6E3cwbU6F+goBc0YgheFBZxzd2JdIZs9Vehk5M7a/cy5+l08Y5KUlxq
	IC0xpeeVz1Hn1OiQedDvwa7NsqglKFAg+9pWICzQzhV/UI4Ss+GbCoPH+AN83LbM4UtulM
	UV5DuNEWEkeBZ9FBu6IU3Z74BuEwpwE=
Date: Thu, 23 Jul 2026 19:32:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uXExJqvLMtKg00EjemEMSid0MvB4tr4xwG+35o6dDM=;
	b=UmK2w40MFyZ/JojmgRCaLx0E0N2DysqKVJWJd9B3jE/RMQy0AaK4rleRGHpRCwSpLACDZX
	2Sb1AJIWcYppgilQGqaVo6dk4+FQ/IsInEXicA3SpQZOhrN5BV2/JvU5PKopd6qyZbt6nM
	EvQy6fT2YGRXCbcMIY1vQGGZq7+5dmk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 08/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Message-ID: <amH72thTfL0Ur19U@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-8-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-8-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: u6at55mz7gp8so87nmj9mtduk9fouf1i
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A30B40010
X-Rspam-User: 
X-HE-Tag: 1784806386-591548
X-HE-Meta: U2FsdGVkX1+dTO6tzD+M1QQwDWrOptyx37uEU0a7bNTe8vnhybjKMOMuETqwKOMtK+66/7vvNTxpmXY2ctlcLrHAja8fUBYi4+QE4i7BnOAWyWJ2osXpLCsubN+BTBJqLVdcrVywabFaZA34/KFuSV8kj1KemEjtKY48RPp4R4rs0evM+m8aX72Gn41qcjiKL2uWKqVfv1b9OgyCZYYYAuZWf4XDmPa/An8NV5BLGiWBt2npdan/aHuBNMyhzxrLuP9ZJUljbBobZ9Attfzzdl64aEp8znjNYs48gNp1QgF+JouvWsO84xe7EfUyAYvQ0T8ViqR4D3AQ5xQVSCc8o3zxrOGT5nPimDvIMMnF7HEyxJb0puRhCzzdNF8I3/CIcoQ9GDOCxgSlKM8qxgv9PrLpKnnMm8tnNKwe+8zhRjg/9SF3SouoXJ2n9z1pedyvGNEJs005H4/sKXcgP/Jo3+Pt9nYWbr0UIfcxeWEXvYafS1k3Y72Icz+m9GHSbDjUsC2PS5E9AV+254dzUIG4MJIVSI8BvmrtO/RBi3Q92PUQ832BDT0lb3F6K+u35D+cEe1Djroe+FcePVgmYejQ68i7sDmaCC1+RP5BGQgx8BtUcmhZHBUF26dWhKrat9dOE2lzlQKkJQwjlmOn6GNyfkHHhRgscCPzs8SAiiaaH3CBY3w+SSYExlW11WFcR8xmq7Ggok7A+CAemI1n9d0LJk2ovNoIUKhmYjSNqBuhNRPE0XLKV/4vbV3/9tvzWrcVNEso6M58my3nJQEk4K/SJJ23kLt6ABKLzoJ5KlfdXlbvIDfpwheXW/Y0mo6wvukU66kLzYQsL3TI+BOOY70Uafq62QmHtTM/AMoiGuhjOpxR4rKCpb3rQtXwo5TL/A8+XiUdviJT1tLAtYpH0BaWpXgMhTI6BGLcXYsRw0gn8UTmphtyjE9zs2oTJesGNFOxyGyCS3SRnXB2zD2BWV2
 aUUvum77
 2k3BLQ4E4vaDRC7K0o5qOkFIjSorllaxFlZucQih815bsh5HsX4oPKk2IVAE0o1zdx9UCBf1xTRtO5ug+jYinWfKPyxZz+f9M4MsDgx45qmzyFD9fEOBAfhasb/50ntieVIcBM0uZOPSgRNO5J7FnXDk7eMalukvTMjGT4ul0Lt0r5SP76gYLaBDT7LaI7fJKLJVgK7mYjF4r7Z84veVuaTV9A4DIY91XzDgvL8gC6WYCS5z1Uux//6dsIJ7qvHkKQ4QlWH71agEexlL+/ZW9orjyvrlzl+ykzj9fevHmjTkDEIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:22PM +0200, Vlastimil Babka (SUSE) wrote:
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
> 
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
> 
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
> 
> No functional change intended. Performance impact TBD, hopefully
> in the noise.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

