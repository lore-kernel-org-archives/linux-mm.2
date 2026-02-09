Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422E6E81BDC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611186B0005; Mon,  9 Feb 2026 11:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEAA6B0088; Mon,  9 Feb 2026 11:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C696B0089; Mon,  9 Feb 2026 11:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3425B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:16:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2EB457397
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:16:33 +0000 (UTC)
X-FDA: 84425421066.06.F87FCA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAEA8180006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:16:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQEG6vdy;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770653791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTL334bc9hZcTD5U6MFc8VoasDQq9uQ8t/WBNXQpL24=;
	b=RrV0Fc6LJEYv14y3L2q3sOm4qxmkhBqqxok0ZtuNIFLqYAAsS14V2Ziso7a8XXprIvMQ+9
	UgzH0o25+ae8sXlwOlr/7IGFpUBveoYWnkbnN03skhX8o9Vi5g9mLJNrXZB3YWvsXjNJsG
	b1ddRPRX0fGPETILUrcsaqrOS4t01Hc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQEG6vdy;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770653791; a=rsa-sha256;
	cv=none;
	b=4uQbYSyup7cCcHil4Q3d41n7iRM9DhHXUV64jrHKwb1gPofsWAmx5XDvc7vuPS8S7utMud
	r75Ka4YjSOwDnJqLLGT6Kbg0jJFb+YYYyHjeeynbDtuej1yi/geANBPhqRCsmTiX5WJPRk
	mFtcFeDv+lD2dqg2xgqFjeQIuDHCXME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 515F260131;
	Mon,  9 Feb 2026 16:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD5EC116C6;
	Mon,  9 Feb 2026 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770653791;
	bh=vt1m/YOd9IGoIYCdeHUIlqZ2Oqusir4jrcBZWBjYrL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oQEG6vdym0d7y+mDS4mckjspiFrBRMy57rK7QQCVbwtglGbBixQOnocFEnuomyYgU
	 XJGp6JvCvqxa5RyOLw1GlIHlU+EA59hbAclZbUf9fHbtgZsTrElXNUs1dzXqAWX7Hd
	 aNOisi0TmkJr1ZPpcbAMzUps35Jq8FV0/ON11B8L2Dew2WOB+esSYOJWstM446v9ZK
	 VlI1NSA9GmnFlPrpD6Kn1HDOwryS32He90Al746jC5fdRT+xVetB06P6gvzvDag2xj
	 faXEKPtayMSiQk5Eo9V/fOJzHGB5cdEub80Xex37WYJKe+KUGjHiVxCnFlLdL4dVsg
	 +gUOy2abjKAbA==
Message-ID: <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
Date: Mon, 9 Feb 2026 17:16:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xd5ttfa4dsate5rpk3qnawcpicx9ypbr
X-Rspamd-Queue-Id: EAEA8180006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770653791-515191
X-HE-Meta: U2FsdGVkX1/AFTPWj/IPAoLJKZH+AMUxSIAgiFg8owwNMdJiYO3pmQHC9yYroKzlMIVJbO/6Ry5ZXV/ov7vJfGo44lGhwG2ojRY0DY+7e0sLJzTXQIafoFbIBHYglH4MONoneQK2E06yNeKbva/CCwcTF1xwn21T/k0ML0rAYv2tTX3lTb4sT8DqEQLSnOYYbryCZqCW7lqbaDb9VlVPIVMw7NGM2FFeV9qqIJc7LRx/28lcx7w8cunfjvgZ/nHjSyjQM1G+e+pLnGkvlsp66f78B/Trt27mx83AVnLesh1+weSZe2GyBX8EyJbM0DA131vEmqf9EAjkt5LjP3vCm8iVRGQMxQ09qZeIrjeBVyOjatSB3XaSOpB82SAkJaJ+IHPi5iMjwOwZDDR2oE4OEtbtwG+Bhh7Pftzdp41mUdBBDCDJZskACjVmeVGoblLa9rMW7SZYjfpv1umz9c6wmX0KIUXeugTICClSJXOcrAzPua2nPWba0Tw6idsMAIM8uBkgj1ytTV0w5Udbk0VMpSLeoUM+fRIzoShqMuJwsB+VNFRts6ef6dPMXK8Qwvh6V4F+nIGL8r3rWFSks/B+GRrFpaG4TdZNFQUktsK/YgZuaH1h5SfAhqClRu7rJ1kNnsQFmfTgYRQulg0AETwWfF0v7gLm2ePNO/P6q7mDKqWiNLqcKQj+MqGv1N1gsjvn15hDmShhJdNtfyqME/KPjExRiv9oTerC6PuZizhDOJ3v/OLhhoEOQpWh2WAAVf7EMtsVLxo83XJeqRFYSPTSkIHVrEvf2eQZRA3+z/jiV7ufKCzil6PfS73USe+SZhRwNu9g3SH011PQXndtOTLuXVS7CM7IrilRpNVzIZ8Mi14HQKiBJSYU0xmEZUEdtChGjuPMaDuOy8eBIs6wLqGzaW0pWhtUswheFJbwDl26SwYSbUZb2dbMaByX7NngRme05LmcXMVwtNJeI5x3LYb
 mQBATRgE
 698P/Jbx1ys2wt9IZ3QoWmTwpiprzuu/gxT/tpiqFlZBOY8uSoR6ny2lUvYO9ZZ8ZCCzkSLYoRhSunwpHdGEGzGeMkAej3kiJ50gMzlHv+FT39V11VDTfldEUD6EcoA3BkyWg0KFTXw2qR4VEiqHmszkQTch4U56rJ2IrK9rI3tdg25Ijbo9JrhYsLTFlCsenO+3EwmOBzI8N/Bl66CYHICs75r1yTE+r2sUFML7Ah+unuz4Zv5ShCQR3uJvYy0EpLVtWlaVtfvQU/rJEddQ5tO2sHum69D/424F0wSvlLJy81i0LmQoj/GastlVCWLmoVnZ/iYifcQ2jxdqlV8pSDOGzQRpP+wKspwRocCcWAwQfdLMCDW/CmIJUGfndcATpW++7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I recall that freeing pages with page->private set was allowed. Although
>> I once wondered whether we should actually change that.
> 
> But if that is allowed, we can end up with tail page's private non zero,
> because that free page can merge with a lower PFN buddy and its ->private
> is not reset. See __free_one_page().

Right. Or someone could use page->private on tail pages and free non-zero ->private that way.

[...]

> 
> For the issue reported by Mikhail[2], the page comes from vmalloc(), so it will not be split.
> For other cases, a page/folio needs to be compound to be splittable and prep_compound_tail()
> sets all tail page's private to 0. So that check is not that useful.

Thanks.

> 
> And the issue we are handling here is non compound high order page allocation. No one is
> clearing ->private for all pages right now.

Right.

> 
> OK, I think we want to decide whether it is OK to have a page with set ->private at
> page free time.

Right. And whether it is okay to have any tail->private be non-zero.

> If no, we can get this patch in and add a VM_WARN_ON_ONCE(page->private)
> to catch all violators. If yes, we can use Mikhail's original patch, zeroing ->private
> in split_page() and add a comment on ->private:
> 
> 1. for compound page allocation, prep_compound_tail() is responsible for resetting ->private;
> 2. for non compound high order page allocation, split_page() is responsible for resetting ->private.

Ideally, I guess, we would minimize the clearing of the ->private fields.

If we could guarantee that *any* pages in the buddy have ->private clear, maybe
prep_compound_tail() could stop clearing it (and check instead).

So similar to what Vlasta said, maybe we want to (not check but actually clear):


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22f..4960a36145fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1410,6 +1410,7 @@ __always_inline bool free_pages_prepare(struct page *page,
                                 }
                         }
                         (page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+                       set_page_private(page + i, 0);
                 }
         }
         if (folio_test_anon(folio)) {


And the try removing any other unnecessary clearing (like in prep_compound_tail()).


-- 
Cheers,

David

