Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B72C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621426B00BD; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8C16B00BF; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4728F6B00C1; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F158B6B00BD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86DEC1401F7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:43:42 +0000 (UTC)
X-FDA: 84994908684.09.29F1FBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D1AEB40009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:43:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJauAJak;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213020;
	b=xqAG+jXbUbqL4gSntg+o+hAmV7Giy2nVhNzP1D7h3fbQXa6YRV1PuLh75eD77zoWk4mtXp
	FPvVieU9K6EFvHlfD8TUc5IabaDfRXD2AjE2MByNWUjZD39BfREunk1EF1vxsFwOCPkG6o
	hVRuOuodoEdjSut0cURusOr+OALZM1U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJauAJak;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU+AkHG+unovjoou+Gc++cD5SyJh4xwusPC7zchS0m8=;
	b=Fc8vYavzCeGIzdqooTwY1n1dT2Oz62h6Q05t28j4zDT2s/7J2w1kAvBVTZI5YbJhmZeqk0
	fHGCRSfdLiYlNUF77jhu082UFKC3KkeSiQyoOZL4JW0L6uyoOcTssilwF732HunrnzGB6K
	C5XkKsMCeMIgWcTShomhJAW/4SpGwjQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61231600B1;
	Thu, 16 Jul 2026 14:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0C1F000E9;
	Thu, 16 Jul 2026 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213020;
	bh=mU+AkHG+unovjoou+Gc++cD5SyJh4xwusPC7zchS0m8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FJauAJakhRvLtd584lr/GAriHLfmUjBqPUdRIv4YrgWA5IhTqvb2tRcX1o3i24R+g
	 2broTkPr1VeFpwXQXpsesKck8xUKjn83EjzPBr+yqgR86w4zBP2aCYT00Cyd2D2cix
	 MPeXf+WXorOO0Rj40ZtpBDXH2RA/12A1xbXD7FbhFEUpMG5hgiCDiPukBTEedWe6UH
	 9hPL/878X3Rs4xlvQjToaIItSVqWLW2hOQ6RBfrZ3UtIibFGKvR8bhvbGRZyEKSLnU
	 u9w+91zOogOw1vMlsvBhVj2vSKayZKuflTHagKlETCzG+3EdoJU4Mn4mixnFkK5pPV
	 lqcN8AinTwW6g==
Message-ID: <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
Date: Thu, 16 Jul 2026 16:43:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/12] mm/slab: change struct slabobj_ext to a union
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org>
 <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1AEB40009
X-Stat-Signature: nkfiom5tkidhnta9izst8kq5b7osapbn
X-HE-Tag: 1784213020-308621
X-HE-Meta: U2FsdGVkX1/l40EkppkkpBJkr6BzfM+4Le0queCxT3gdtBfBRdP6f8OP5kvJECuLs2NzpicYMLQcNAAeLh1lGX+NtHuQpyh6CiCnbek/wgpt/x/Sr2eKL1n+wSKgJlXo7naXQmmljE9agGo5h//eVnmPAovkueFaJkMRiEZhpNmoSf8y08Cf+D5elVxZU7PajYzpHpquj+T2TTiT89ym0zKajzMAX03VpZrd9y5u8n1rtQBB4W/NlgHCkZG3ZUQc/thdpO5+bQMobqK+Nnu/MeYrpf9GbN299qlcdLqQXoRSnwhhHoTMGkvdhO0NGv5IYfYFbozDJUg1HPXAZuUizFft2fsgZrmTjF8aIL5Ofp1T/A3iQqv2cdtRGtcTGskcB69+uDXsOLLSTusGyS9fpnXC2r12TxBvkThM95shZJ5377whQFTwrFNBHikAa2RQuYMjY4muCHQgMCa41BHeJXyKRaN+tsKo8EHzuTyDHvHRcJaOaK1KUvLKkjE/BKXujIW/MF5kAvUcI7tz3xQrdM/WXgVtxx5dvOt4Yd85x15LGhlhPQTY8U5EBSz/KtWQTXVFRhW9tmnRH8aCqy9ofPSYi4I9aSrffvWNDy4wDxIoZ8PW0Af5FBbsmAVbc0gAEJwVKAWDPom9EysNlMaZYA0Zwfz1g4lic4v7+30dGwS+6dV+zMXZUnJAmh44Au9IJDJRuEbeGoXWWYP6Q8OXVSnGbCpLbcknr3nZg44YWnXkVKetcty1/ZNvmH462gzqkdwXZxFqRjbPVi6UI8mukYP35pZi7stWP701qXHlYv+15phnCXL3rwjeCjgmub9McIHKuBfK1to8alpxcRmEuKcttMzSjNupXTNv9qnqtZazrlGLk4+j/tmTX7CLaQFdUjkpPC2O8xQie68XG223nNw+aJOKIloh8dr8I3bhkV24X5k6hTOv9XI9ByYHOMuIbK7OwOySM/ec/fkhlzE
 EUdtLDWk
 6ikVRlE2+mZR2UZj34jAqfcE2dbLYiAVHbL3zGK72ZiwIqp19YIKB1y0xQQC13t13Ij3TKey+39nnFx/rRE9PYRAZrcGTEYjshNQyXuZgLdMKdH3VTxq84qTsn5rNjWLFbDLE6yB2/be7ECRkNWLCFpJ9/E3mWvoKAzrNSWaPNOpg7V3EWfUsEoE4xV84fgWC9GzxsgnplE+CtBTQgCeQRIKb9IU7aIusoPJ1YO/4BknpOFiD39MPgSFqRAs9qVrrz5Y2PezEt8CI4N1JHkA1lXHYiNwToBCU7CyrgWaKA6j7HSHvBdM1LmLtm8qC+YdYJaiqyIESCzlbobXOj2b/NOgLWw8bgpZMxAfvslWyPvgbhnQX+tP7yqjNM/VN5fS+jdCR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 06:11, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:11 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> No functional change intended, the layout is still effectively static.
>>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> This is much cleaner than what I was preparing. Nicely done!
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>> ---
>>  mm/slab.h | 41 +++++++++++++++++++++++++++++++++--------
>>  mm/slub.c | 17 +++++++++--------
>>  2 files changed, 42 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 3ad9777ad600..359ab8caf61e 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -554,14 +554,34 @@ static inline bool need_kmalloc_no_objext(void)
>>   * if MEMCG_DATA_OBJEXTS is set.
>>   */
>>  struct slabobj_ext {
> 
> Perhaps we should add a comment here stating that every element of
> this union should be pointer-sized?
> 

OK, how about this?

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -550,10 +550,14 @@ static inline bool need_kmalloc_no_objext(void)
 }
 
 /*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
+ * Extended information for slab objects stored as a pointer to an array in
+ * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+       /*
+        * All elements of the union should be pointer-sized to avoid memory
+        * waste
+        */
        union {
 #ifdef CONFIG_MEMCG
                struct obj_cgroup *_objcg;


