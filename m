Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED47AFED2D1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E916B0088; Thu, 12 Mar 2026 00:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECC46B0089; Thu, 12 Mar 2026 00:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCEA06B008A; Thu, 12 Mar 2026 00:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAF376B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:47:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49A6B1CB57
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:47:28 +0000 (UTC)
X-FDA: 84536177376.18.22D527C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 829B68000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:47:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VnyGzRoG;
	spf=none (imf02.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773290846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2SvhJ+b53Uvh0SW06/h2KPYmtALDs9kOKOYcwwDLA0=;
	b=q2ya2NSeE0+SxawSBzJ0Mj9u6evRw3LHAt69PdYgCMVnW56+4MF8HEImziKj5gayifjQd2
	DXaW1w2BylwwWIAgFyLLbUzxCvtI1b2fOb5pin3xojVkQXxQVVUQQ5Iin/fTX8AIbstni6
	LUWCDKYiDZLjI8v9seJzgBTeIPkea9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773290846; a=rsa-sha256;
	cv=none;
	b=LGwY1u/oUPbRJ1kI31NzZVKBezsAxbLAXYH7y8qdwVPlWwzPKFNo7zB0SDkC88jcwngRyV
	O2W0FnzdU7+/iTVnOJPJ4t6LXMnt5WUf5UQIMIL3zsBOZ9xJaP5b59yDugK1f1r1UaKHJ+
	RVhjNBzwPzit1qgFYiiZOizNW6AfCoU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VnyGzRoG;
	spf=none (imf02.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=A2SvhJ+b53Uvh0SW06/h2KPYmtALDs9kOKOYcwwDLA0=; b=VnyGzRoGzkd8sAAvVV3Y/W6ZN0
	tKjKqCKmOocvgGs2WMlfWDZKSsXB8ZVZckIdwVxx+isq7qvFLGieQAcdQINeeSI0U5lmzoeckjN1P
	fpOlTWJ9/v6707emE9rHLMZBDNwcmeIh42L5g3RJRUZ5PluWGXtKUDSp+15rNVwAY6n28KPynzvip
	8M+n2m480sEjG8LOTrXHMf9kL4AvUVoAinWEFH2hdIxCwt12t7vNVuvMadKGy49cneNMRZ86dUuvn
	kKk0L70BiK14w69z6fOhbwVFm7woPVZnv9og0y56U9VuASYMSZf/o5lXdue2UIhgTKAlsYSpxvMcM
	lBafm1tw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Xwo-0000000DI74-3YB5;
	Thu, 12 Mar 2026 04:47:00 +0000
Message-ID: <e398475e-4db2-40ed-baeb-89c2bbf6a0d5@infradead.org>
Date: Wed, 11 Mar 2026 21:46:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/25] kernel: Introduce meminspect
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Eugen Hristev <eugen.hristev@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: pjros4wcip7fhm3nneia8ox95mw15zkd
X-Rspamd-Queue-Id: 829B68000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773290846-987439
X-HE-Meta: U2FsdGVkX19pBFMdilK2k1fMDo41Tam6R5UnrXeciCpkdbAOxJYEztrWwQMCiQmiMgtgmsnj9y3z5XEEDUCuRiz+KgdIcbEvcGAJjYLDhNRq0Iwe+H0R7LA97RGj4YX+Y6FqYnItKIG2g4VzrKbICj1P5bI/jSvSkAfsQaSgszGgvYdxOFv6MVm8b+YTWijX4nxQ+WuE/aM8dGDOX4fWpiyAdTwNVF3oz9A/mBk5ha3l/tKqjQznPzVgma/1chz6b6bqttSlSEfq7ChzD2zE0O+OQ5CtL/O3BQhJuRD93aN8I+xjizxdaM/I+GTvZ/38ClLuiptSp3k4tPkZaWb+jaziFxTTPA4wCmmw2cK7JE8xuj4G9TwYbJe8zRh3p+hi6kS7PDZzoTZZxi6I/MT99+dkljXim4qQyoTehC/DdSY/mY3XM1DySlUQXuvJGrqOZK413Y0Y6zg1R19+6pjNvP6JpnvMStdHxajFozVd3z4H2mRgZtf2uvghWuuX95m0tIjjJEFSwp+gIqioyugZupcBleBeViZLqzovVfTl4HWhYz+kRk0U8blEvnlBPSdbqmeRA01hxtoYC8+ePXWPxrrKGaTFXgJyP1WGuw2MeL1TKJ2JPijTTAepXr3RjZlY2icFaF6CWHBoMNe/YHyADl2BxoUYJXMDlaZQO4JLaLPm5g7HpSLuqHyK14SsLKKWzYh58v/MHb89V5APbxdO3N6ihB1ImlgOM35pAtSELIue6A4yzFeJHjOfzBQLQ2S4MI957Wvl6HSu4HgBfkZVMkdme6SHcL2lo48AYjB6y9qjzex2o0fLJDizF8QnNACJqyWHXCkphhkiiYwufOvqtzuEieS3Ont8DUtHLOCA7jpCDGIb2mesbX0jpziBjuCbGpCQocUwvTkZIw+D/6MOBgOLoxgSDKY5Y74tcBt8vvsCt8//g2wSYvMvY+9+yrKJQ3XmsTNnH1C4Nw+2OG+
 ng77NWxy
 sEcF+Zcgwhr+6oN+SWqCzX1U9lAz1lAZXwcMG2rP9Av+tL3fUPdwuMZsMiF5+tu32SML3x8hdQwYuoc1kjMpPRFd0ihRAlcfCWaQJI0ajhMUuYEtsDn6Cs0KU5EpVtE2W3KAZT5ld2eavOMefnJbOzgn6GyNt8M73b2xHEok3schG9tEbR1/FBjpOBCeGeQ1qfo0437K68Bd+lT+2wPLovjwr55vZCyo6EWzNxV0NpcXt4+GiHulhkF+nkFJUFQjl2GaDUV1Qh2AVrYmCFXjCo7CJW9/nrbcdzQPLdQrgUf5QYtwEkhQQyyuZCAt3qFRGaodPxfCs9hR3laGmllAFH7xy/CduBoX7mJReUZ93e9kyZEKHuBaXMcuVYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/10/26 1:15 PM, Mukesh Ojha wrote:
> diff --git a/Documentation/dev-tools/meminspect.rst b/Documentation/dev-tools/meminspect.rst
> new file mode 100644
> index 000000000000..d0c7222bdcd7
> --- /dev/null
> +++ b/Documentation/dev-tools/meminspect.rst
> @@ -0,0 +1,144 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==========
> +meminspect
> +==========
> +
> +This document provides information about the meminspect feature.
> +
> +Overview
> +========
> +
> +meminspect is a mechanism that allows the kernel to register a chunk of
> +memory into a table, to be used at a later time for a specific
> +inspection purpose like debugging, memory dumping or statistics.
> +
> +meminspect allows drivers to traverse the inspection table on demand,
> +or to register a notifier to be called whenever a new entry is being added

  preferably...                                                is added

> +or removed.
> +
> +The reasoning for meminspect is also to minimize the required information
> +in case of a kernel problem. For example a traditional debug method involves
> +dumping the whole kernel memory and then inspecting it. Meminspect allows the
> +users to select which memory is of interest, in order to help this specific
> +use case in production, where memory and connectivity are limited.
> +
> +Although the kernel has multiple internal mechanisms, meminspect fits
> +a particular model which is not covered by the others.
> +
> +meminspect Internals
> +====================
> +
> +API
> +---
> +
> +Static memory can be registered at compile time, by instructing the compiler
> +to create a separate section with annotation info.
> +For each such annotated memory (variables usually), a dedicated struct
> +is being created with the required information.

   is created

> +To achieve this goal, some basic APIs are available:
> +
> +* MEMINSPECT_ENTRY(idx, sym, sz)
> +  is the basic macro that takes an ID, the symbol, and a size.
> +
> +To make it easier, some wrappers are also defined
> +
> +* MEMINSPECT_SIMPLE_ENTRY(sym)
> +  will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof(sym)

     uses the dedicated

> +
> +* MEMINSPECT_NAMED_ENTRY(name, sym)
> +  will be a simple entry that has an id that cannot be derived from the sym,

     is a simple entry that

> +  so a name has to be provided
> +
> +* MEMINSPECT_AREA_ENTRY(sym, sz)
> +  this will register sym, but with the size given as sz, useful for e.g.

     registers sym, but with

> +  arrays which do not have a fixed size at compile time.
> +
> +For dynamically allocated memory, or for other cases, the following APIs
> +are being defined::

   are defined::

> +
> +  meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
> +                            size_t size, unsigned int type);
> +
> +which takes the ID and the physical address.
> +
> +Similarly there are variations:
> +
> + * meminspect_register_pa() omits the ID
> + * meminspect_register_id_va() requires the ID but takes a virtual address
> + * meminspect_register_va() omits the ID and requires a virtual address
> +
> +If the ID is not given, the next avialable dynamic ID is allocated.

                                    available

> +
> +To unregister a dynamic entry, some APIs are being defined:

                                            are defined:

> + * meminspect_unregister_pa(phys_addr_t zone, size_t size);
> + * meminspect_unregister_id(enum meminspect_uid id);
> + * meminspect_unregister_va(va, size);
> +
> +All of the above have a lock variant that ensures the lock on the table
> +is taken.
> +
> +
> +meminspect drivers
> +------------------
> +
> +Drivers are free to traverse the table by using a dedicated function::
> +
> + meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
> +
> +The callback will be called for each entry in the table.

maybe           is called

> +
> +Drivers can also register a notifier with meminspect_notifier_register()
> +and unregister with meminspect_notifier_unregister() to be called when a new
> +entry is being added or removed.

         is added or removed.

> +
> +Data structures
> +---------------
> +
> +The regions are being stored in a simple fixed size array. It avoids

               are stored

> +memory allocation overhead. This is not performance critical nor does
> +allocating a few hundred entries create a memory consumption problem.
> +
> +The static variables registered into meminspect are being annotated into

                                                   are annotated into

> +a dedicated .inspect_table memory section. This is then walked by meminspect> +at a later time and each variable is then copied to the whole inspect table.
> +
> +meminspect Initialization
> +-------------------------
> +
> +At any time, meminspect will be ready to accept region registration

                meminspect is ready

> +from any part of the kernel. The table does not require any initialization.
> +In case CONFIG_CRASH_DUMP is enabled, meminspect will create an ELF header

                                         meminspect creates an ELF header

> +corresponding to a core dump image, in which each region is added as a
> +program header. In this scenario, the first region is this ELF header, and
> +the second region is the vmcoreinfo ELF note.
> +By using this mechanism, all the meminspect table, if dumped, can be
> +concatenated to obtain a core image that is loadable with the `crash` tool.
> +
> +meminspect example
> +==================
> +
> +A simple scenario for meminspect is the following:
> +The kernel registers the linux_banner variable into meminspect with
> +a simple annotation like::
> +
> +  MEMINSPECT_SIMPLE_ENTRY(linux_banner);
> +
> +The meminspect late initcall will parse the compilation time created table

maybe...                                       compile-time

> +and copy the entry information into the inspection table.
> +At a later point, any interested driver can call the traverse function to
> +find out all entries in the table.
> +A specific driver will then note into a specific table the address of the
> +banner and the size of it.
> +The specific table is then written to a shared memory area that can be
> +read by upper level firmware.
> +When the kernel freezes (hypothetically), the kernel will no longer feed
> +the watchdog. The watchdog will trigger a higher exception level interrupt
> +which will be handled by the upper level firmware. This firmware will then
> +read the shared memory table and find an entry with the start and size of
> +the banner. It will then copy it for debugging purpose. The upper level
> +firmware will then be able to provide useful debugging information,
> +like in this example, the banner.
> +
> +As seen here, meminspect facilitates the interaction between the kernel
> +and a specific firmware.


-- 
~Randy


