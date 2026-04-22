Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27CEF9EDCD
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9426B0088; Wed, 22 Apr 2026 09:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1276B008A; Wed, 22 Apr 2026 09:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6C26B008C; Wed, 22 Apr 2026 09:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC3536B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:31:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 507E6138F33
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:31:23 +0000 (UTC)
X-FDA: 84686278446.26.AD8C5B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB69C10001B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:31:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZI7EFTOO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776864681; a=rsa-sha256;
	cv=none;
	b=i/pZdsLKHHT1wOjWwtw/0AViLc/wevsvFaeXuvyVqMj9RSVGJdZ/RMDY4cHmLls1mlsmZk
	0iFjI64PxvfgAncf3FqvByZNcFkfFdutaDHyhKF9461AuIWH0ECJ9PWP9j9Zxb+WE5DBS/
	kde3zaWV6Y2Bvz6uq4Y35LWmFkW2XtE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZI7EFTOO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776864681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3ilUZDYyvFu9c5NsOzH/I7iI+EvkGmm6eTdjDZhFJw=;
	b=p8wKWkwmUYDkz7xdxeT9u512uU+8TCxxxnvIfBXT6J4DcWahtJlqKtJkSdem0ZUTaYBlty
	hG+eDDSb5BTn1XQbrsHkxTsxhMDLXLwvxjhO9a5gJnHvKpP7roqz+8dSF93cdfLlVU2tfk
	gQh490/0SbO3NuZ/iv5q8lRN7bICp4Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FCA11E2F;
	Wed, 22 Apr 2026 06:31:14 -0700 (PDT)
Received: from [10.57.89.34] (unknown [10.57.89.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68F73FBD2;
	Wed, 22 Apr 2026 06:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776864679; bh=Top9vudgGbwsB9gdK8pkIXSaPiG3wHdOl/KtxsTBaBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZI7EFTOOAO8ZKkCeexRr92Fur05p/Z9cynlOaN/iWBeDk8x0fJPzRCDExPChxCMoZ
	 jEycCoKb1uE9rzLTIdc0gQxIUZlTrxOv0LX3BRkzLxWwKLd18J4Q6N1vrnGuFQnmU5
	 Fp+w6T9cD3Ci3CgJZm2gKcUgGBqrSGovqraV9HFE=
Message-ID: <e881c79a-fe7c-46b1-a518-febf7a278cc9@arm.com>
Date: Wed, 22 Apr 2026 14:31:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Will Deacon <will@kernel.org>, david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com> <adlCN9sUcQdWbf_i@arm.com>
 <adlDSiuBeSduK0mj@arm.com> <aa7c5a29-c8f7-48aa-b0a0-ed147d29fde4@kernel.org>
 <aeHvzh3A0eC-tds9@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aeHvzh3A0eC-tds9@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DB69C10001B
X-Rspamd-Server: rspam12
X-Stat-Signature: gjggd5z91nptt38aijxzqpr1b5ed3m5x
X-Rspam-User: 
X-HE-Tag: 1776864680-65230
X-HE-Meta: U2FsdGVkX1/jkwzMoohHi4KVeg18dHAqpVWTAWY85v6tVAjA2nL591WUsQe88krUICqMqrvfpzHmvhF9GMiVbn/UCCTe6m8bGabwOR02ypAMGWAEiDXALLfAfHuL3wrezDA+X+zI9qPkG8zr1p8Z6hO17XAJ5PzwBn1xbaUrV0bLIXYvkV9JHvy4WO45fY34rmnF1z7qibjgfDi4KwAsrPTqqOvN2bLKj8EP/zKagQT2/yPmKU8DCCajEqrMvLRWUrgTEnGKbLMSmZrVT8YTOXyUBtv+SAsq9HymuhFo3pMG3VNPiOYrMp84vMtUNqmv8m2Mz7kfzrw0JducObtd9kXiSn3cLlLY6YUGCqkxJcBjV3IIX8gg6wI3+5XB8g3F+TPu3RtLruzTWwZ/W82GcYNzAZPkNdszsXejPI6qg/vP16OWMdh4iK2BCI45EFG60IsiAuXkBnLujRa1Uvegqgvz1Mj4kX1cLkihtrYBik3IPkdstcB4GPV80hdmQAMo6vHgmfjvIvwHEFloEsjkpE+K7eGQzI+ZbHHeb47eQDJW0s0uVYg8WkGFmH3eHfYFbFUEwEUeJvW/ekXnhYwew6KQrrlU2e1Plhnbmns/xSZuhSvGJNVwEXEowqwnUTvLxz7nATO3ihecmygu/AVYieZRCt2iFZ9zXxzpfrGJn7EsZToh9vNxfXr8+MzQziL3eKyOgpWScARs1Jaw9ZwHAfvapisgbruseGFiQ0YhNBUAX/PNiywuCVjT4Sze5zm8ViAElgvGgzpuFZF0xj8SdfJT8kkE1SYf+eZvfsXkX5pCEcJDNyVw/suRNe9ZDcvNlC0pyiB5YnjfrDo7MRsmdpdzOzxqoRoVIzjsSF4vULXLZDVMTYqVSO71FA4LvhdY4jNOQQqcmWtJZ8OedeJXlX4fHb+KQfi9XUriFN1phJw+gkrNGD2biGFcjEzopYispZIT5WV4BWCr9w4k34b
 G2tQlUTw
 DRD1lEvojn0H+NxKkMk9pys5qEaM/gYbyRVokltPTpyO/vtAV3IPkL2qSF9gCaehoA5VUI1RymsvDxq5lF4VGH98NBEvRuKnq3qKJAdLciaoVJFzP+L1hqDadrDto9g5f71kOp61+f6LhKr0QzAp3eiU7to2ZgbHIZJEkCmTJ7f67dJmHHjYfdx0DOw4j8s7qpO/cUgAyEwN0S7o9XFK4ztqn7hPRlp4RpfpTE/0cQfblYuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/2026 09:31, Catalin Marinas wrote:
> On Thu, Apr 16, 2026 at 11:03:46AM +0200, David Hildenbrand wrote:
>> On 4/10/26 20:36, Catalin Marinas wrote:
>>> On Fri, Apr 10, 2026 at 07:32:23PM +0100, Catalin Marinas wrote:
>>>> What the original approach might help with is use-after-realloc in case
>>>> we had a tagged pointer in a past life of a page and it still works now.
>>>> Oh well, that's I guess for other types of hardening to address like
>>>> delayed reallocation.
>>>
>>> Another thought (for a separate series) - we could try to map the stack
>>> as Untagged (unless stack tagging is enabled; needs compiler
>>> instrumentation) and enable canonical tag checking (newer addition to
>>> MTE). This way, any stray tagged pointer won't work on the stack since
>>> it needs a 0xf tag (canonical).
>>
>> Do you mean mapping it as Untagged in the vmap for CONFIG_VMAP_STACK or
>> also as Untagged in the directmap?
>>
>> The latter brings in the set of problems with direct map fragmentation.
> 
> Just the vmap, there are a lot more problems with the direct map. Not
> sure how much it does in terms of security, maybe marginally. A
> match-all tag (0xf) would still be able to access the canonically tagged
> memory.
> 

I think with the first patch in this series, we are alredy vmapping the stack
memory as untagged, right? vmalloc only calls arch_vmap_pgprot_tagged() if we
are not skipping kasan. So I think we already have this protection? (perhaps we
need to explicitly enable the canonical tag checks?)

Thanks,
Ryan


