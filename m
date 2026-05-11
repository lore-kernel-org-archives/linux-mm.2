Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC581CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B8C6B008C; Mon, 11 May 2026 02:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2233B6B0092; Mon, 11 May 2026 02:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1609A6B0093; Mon, 11 May 2026 02:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0963B6B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:52:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D7738D4E3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:32 +0000 (UTC)
X-FDA: 84754220544.28.FE7C166
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9437180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=s4UcPdhp;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778482350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJMLXjcI26im9xhxw5BNpjzNLmJVL3i6Qc/ACsf+MrI=;
	b=S17B7/MXqCB9Cg0Vl85E8xR7CetEusuLnl+NjivaVJUuuexjI+FRioBpSjEYj+YAGkYuWp
	dU+idgfvlGEH6rSPL3tcAH9h8pccQNWoBtN+MxhNf4gBnBj1Oq+6RZ5hhN1syl68PE9kuz
	1pPY+gtu3fesC1cEK6maw5K/k7GSYss=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=s4UcPdhp;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778482350; a=rsa-sha256;
	cv=none;
	b=BKRgSg/kYOmxE2ggtWKJ9fYVsWHMdJCvdiOcQ/OU7X/00pyF5f9syxJ47iVV2uiGC/X2dT
	TB3FyrrulZyMFLkaMSTpUIT7e8AClgEvWvHCz57SyHg34O5CMaCFsNCzfT7syZuuc8cr2W
	elIWQZfdLWa8cWJUVp0ubfBkEXmExyc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778482347; bh=sJMLXjcI26im9xhxw5BNpjzNLmJVL3i6Qc/ACsf+MrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=s4UcPdhpU4ak5ukd2I/WMPJ7kJoOwf/ktiWr8AL9E7XlXPhHTK9EQGOP8gLLmlytr
	 cxBonI7MKYzETwP065w0tdJ2hU2rC+ngvlm00r8rpB5VHMMZIcJy90bPyM9A+7xx0m
	 ilxm71JplqL+Org4gq/GXdRmuea73KfhMYVtmPFo=
Received: from [IPV6:240e:604:311:bdd:c445:e8ec:eca9:fced] ([240e:604:311:bdd:c445:e8ec:eca9:fced])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id D181BA5C; Mon, 11 May 2026 14:52:24 +0800
X-QQ-mid: xmsmtpt1778482344tk43alsnr
Message-ID: <tencent_C372613CCF2B0ECFAB78EC8C30DFA05A6C0A@qq.com>
X-QQ-XMAILINFO: NHTNowOA4hJdL9MNiUn503bk+gIIoshFg41SfYK7ZghKAjSwMb/h46Np7NdrWy
	 BOCKNIcDS1mY0Lu0VOYm4/QH0ue8n/Z263k3FVaMSFLRonuvkhlvbv/Botg+NJR8Cv5Ro9ADJKmC
	 hYPV6vRZU7C2RNrRZo/yEedM6jjnb3hmF7dlhR6Yx84+nVSGeQTnNZgJdHsA+5f3bJPDIQLLQF9h
	 ArAUfz346GiaUsqgg1l41Meh3msZhgV0PyuQcMZgumiutQB+803tF/KxW+kkYTaTSbzzc1Pu46Ov
	 cT+clgy4em7iAjS0/sZCsryBCgLw3rMzXFCmn69TJEUflBKP/Yrs6sK+CndYb3CgbM0LbAHqlhYA
	 IWV5EmKKKBvGcNwPxFKz9w9qyOMMMpnWBs1yukZZu06GZuNTKx5YW631+tzLxD3OTViRcjVC0EWD
	 GaRrfisaMhWg+zVU8NOhDIWL4jBznAxasDbMnuVOK7ewS2sefYgB0MdF/j9WpmpErX6aYHicWTfc
	 zLtTg9A0xCZuKaeKkHwh9d8fpL1FRKjMU+We48aSNW8oUaEaJ0L2pmg4qcodoSRimzQA0WZG4S+J
	 PwIjwGs9oD5pppkZdf8xEZJQzdGbB1lOuxX3kOmADzlcUowCdAMoifLqJ5K4gbYYwvWW2qHUBq1D
	 UHHKmkQyh99Ipej1/pq4CUtKdeYVEGmr1y7+i1ap93g5f6UQi7zMS3xS9CptsnkWgIAEUs/MUZe6
	 /uiABfDy+L+MtzTM/JUGhAzgFD+9CAAVDY3L7cN1LyKOudczmx8Bc1fX1N1Tte6ipgrFXh0oeMR/
	 e4NaFUySzFXJLSOiwPX/myXzByAyRlATTCmxuMG7Cq+PZAiDGgew+BHsmiwlBLdCJ7NOe0odf+LD
	 yPuofSMpgKiCDnQHwWVSjlmvmUuTYvG31LN8aHmXEeuCf+3RhRuF5W0b2JybKjpQHkfNpyVcu7S9
	 MHnIn0f9xzsv6cWoJb6HcMUtq5lS9TuLgTNZCRu+uuz15mbflwm9iXCgHnCn4i092lhf83G6avcn
	 6dkqrse5z5g5qFct92oht/QVV7PdcBwcEF9kSAqHtzZxcmTY+XYD9NaUozjNsRvpH3iGM6ITgPrp
	 kcE6+Drrr63E99Pd3upTyW3U1CCotov407AWgcbZdifkuJz6w=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <a19c1140-5c5c-4dec-9746-f81f78f11bbb@qq.com>
Date: Mon, 11 May 2026 14:52:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio
 failures
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
 <20260508163549.40a7f3c8c4286a553855b02e@linux-foundation.org>
 <agDK6PkESVR5OOYn@casper.infradead.org>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <agDK6PkESVR5OOYn@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D9437180004
X-Rspamd-Server: rspam06
X-Stat-Signature: u3s1dj1bdbuyj4hooe183ac5hk546khu
X-HE-Tag: 1778482349-245436
X-HE-Meta: U2FsdGVkX18IEld2PkdtHELRVKSSMCtYEzsyDksff/H+Y21MUf+llmr01a9KXE1pyqiJjD66VgFLmiqAJDiW9OLWB6w+bBSWwIFLHmMjCCnzyUWlHG1CnCXEGzHmmptahFt+/UO2oXKlCuNKFRPaGyCb+mR0YL1iu30ztSjoqNPnQQeVmpx+Egm1G5wsjl/UPUwSaogLSooz1vxVh9lsVrh/IH0ASvy+hoapfGR3awhyk9m5ONDQyFnFKakYzasgL99RSVeyA4YjCW9HuU1GgwmYOSjmOESzE0uBhsseDnrqaF+6KV24DXmlpuAr7+3xn5Zl6XmXFfqeNvUkS3fSFfHQW+03KaXh/K6JCfhFmtS5Hwh7eqIhq8U/yZ1dQuzucVrT/2qZgyYEAwjnOJixxNyrJMKbXZWZQBw/T+hGAOtaOeZFZw27cCKFVCRW952ycNaAgh5lmZqvecdglegvy1ZFpOyEWaveysPQQl654FeSPixdYcYNihRuvx8oqtb+y97q6pM9X44j3EYLACfm1CdJhgqJYjuwAaLJ5OYXF+9Ql3ROkWGU5S6ijKw0ooyhOGtK4LQhI4EX3jI9qjLhr2Bc2KJ7TAzKy6VMfBax+xXZ4UaPDUCybsme1S1ko+ICvtNB7LeSyq+eDHY2nAomW0JpJMuOXR6xMTVEKVcCMONYbWx5v4MI2HD60ittRYM4MiEcYWo56OhEL9L+mqnvNzXxUvdMF+OPrhsVNagSm8B24hvEEk2CWSV+aKXYo5Aq27RDlypHm/PzDOlSKydb69VF8NufLMIUoYLw7xBhBpdDT25XUv7s9nDn521+ZHfey9VNXSURA+oj5rA9I9KVhHd+2jSKASpKJWGSxs91BPNrb51DickskMnH4GY+ZgU1i0YgX6tzGfCxY3ZJ7OZ4vHB221cVn59WSb4B3uKl8bvYvABYoVtFotY04klUVyigrRFlYX5akGdJESD7TFC
 JcbVriF6
 I/mFQfLAXc1TQ1TPMsKICI6N4PYQjJKHbjvJvh6fEWw84wQOpszkiU+DJh8fdcgUegcjoZQ5qgM6gj48Zwgu1wdxr5xuGgSy1G8s4YSv6Z4xtAvq0ch+5zgFDztzJB0xONShKzBHuOf1MhmVImTFVh8DmiWC+1EUjntk5yjoMv3hjWtc0iR5GOyceZ7TSqFRbNbQknQ+2Q5tBT5zT6/fBzFTZP1E9+mp11AGITV+rSTvDNQgiNaJtJJGH3FobuIwsa6zvDcALQ51bSCnPIqEIgx/QshuXY5mTkQSIKnHNUYKpf4JD9xrN/I1p97zpCk/mi0vFNK+bsqJMc13S+Q2f6khz0+qW3tqwUTgh+ZVGZxtrzvJP6YbvS5dYY6E6JSSbWd438/WRRtag8EFVDh1mtB+gf9lcaOfwmbXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 2:14 AM, Matthew Wilcox wrote:
> On Fri, May 08, 2026 at 04:35:49PM -0700, Andrew Morton wrote:
>> On Wed,  6 May 2026 11:23:59 +0000 fujunjie <fujunjie1@qq.com> wrote:
>>
>>> generic_fadvise(POSIX_FADV_DONTNEED) drains the local LRU batch and
>>> then tries to invalidate the requested page-cache range. If any folio
>>> could not be evicted, it assumes that a remote per-cpu LRU batch might
>>> be pinning the folio, calls lru_add_drain_all(), and walks the mapping
>>> again.
>>>
>>> ...
>>>
>>> Teach the folio eviction path to report whether a failure hit the
>>> existing refcount check on a clean, unmapped folio. Only request the
>>> global drain for that case. This preserves the existing fallback for
>>> failures that a remote LRU drain can plausibly fix, while avoiding it
>>> for failure reasons that a remote drain is not expected to resolve.
>>>
>>
>> Thanks.  AI reviw asked one question:
>> 	https://sashiko.dev/#/patchset/tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com
> 
> That's a pretty poor quality review.
> 
> My question is why we do this bizarre thing of switching between an
> unsigned long and a bool pointer.
> 
> I would also avoid creating __mapping_evict_folio() and do the test for
> folio_mapped() in mapping_try_invalidate().  It all feels a bit weird
> (both this patch and the original code), and probably needs a lot more
> thought, which I'm not in a position to do right now.

Thanks,agreed.

The count is not really used as a count by the fadvise path; it only gates
whether to do one remote drain and retry. Also, adding
__mapping_evict_folio() just to pass back this bit makes the interface more
awkward than it needs to be.

I will rework this for v2 to keep mapping_evict_folio() unchanged and do
the folio_mapped() check in mapping_try_invalidate(), as you suggested.
I will also think more carefully about the fallback boundary and use less
misleading naming, since an elevated refcount does not by itself prove a
remote LRU-batch reference.



