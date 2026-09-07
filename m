Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAA2C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CF06B008C; Mon,  7 Sep 2026 12:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD796B0092; Mon,  7 Sep 2026 12:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC6E6B0093; Mon,  7 Sep 2026 12:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCB8C6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:04:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EE07401E5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:04:55 +0000 (UTC)
X-FDA: 85187439750.09.6E532A8
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 94E441C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:04:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RyUNVlxC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNnTBID4g9aytHQLyfm+JMBPPEsDRdj9xryUeJJj4sA=;
	b=3lZLZ+a2qYvE+YHBPyniwSbn17WLVyD2/VNTxQu1ug1vNz4XT3bfvzFMblz5WkwaPB7SHg
	D1yTf/5BdrTGUVXnzIN8xQhcSnGxh9+METhCdeOr48DqsCYhMqAxLQo+JMmvzT/D2T73Va
	2bU0VQr++qlG/VnE6TwnfCB9oVkMBgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797093;
	b=bjPYrmTMtUBQixOhVx0FwDmQrkTkV1EduGa8FSXg/JwRqkzCSu328U/t1ez3lkiHP8xlpB
	CxRssLDkMyEs0hgRJ6nA+gCPaCF5VKF5SvoovFnWr4tiPCKUYByhr5aNvH8P+pk6+m1RfH
	yLO98vlrCqWmdK5haVrDKz2qjKc+Ujk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RyUNVlxC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9397e2994dcso312676485a.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788797093; x=1789401893; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FNnTBID4g9aytHQLyfm+JMBPPEsDRdj9xryUeJJj4sA=;
        b=RyUNVlxC27Bdb1blFB3DCxJFfc3vl1kH/dUnO+zTf2PQaPhaG4Cl7RpHtpJrBNawqi
         e/Y163knI6nvATVP+OG+cvZKMGeu/Fcq1dyYgQvki3cKmjtzwv4KzRd4vIfnp4h0Xg0c
         JQQOcyOxU0vIrWZO6ShcNVK0FTpgF4F8/959rk2/jvmxs6qKaNgPvxp54nN7g1vXvCOJ
         GLMSYqfcHFYHvK+4LdvblIEvuljJawN8MzkEYieXixk2LcFEIHUU8W/MfVATgAOMi8mr
         GAClc6k5Ekgiy/WGOaERXgivs7AAxxBufh61uX5ktIl98pbUKB8PU1000wF9sZKp02iV
         mZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788797093; x=1789401893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNnTBID4g9aytHQLyfm+JMBPPEsDRdj9xryUeJJj4sA=;
        b=OxzmlUbsxi30YQS4ycUJMWGjbwtq+jn0TJHn7f0BgUegdkL54r4twmy8t49iMaHWhr
         Eijfp4ixB45IwbmQduGhkWRDUZXo1JKQursjEN5T6qqCjDB11SqGBmZ6EqNsK/oUlp8n
         d7UgfB8xcPeB6WCvTrVWO9wngtVIn7YOQuPJlZGYeegg82XROuwoDT9ExazUYnDq3I6j
         F0ccOTXsTHakJLRCLZXVfmdNL6cgrPedhnTgpwHzzAQX8JaZ19ig6PSX5njYUDOaX2VT
         CoDFilGUmLAGEBHxdmP7CPIl/tX9Ce7UQewMOUeZeiWN1ay5wFopTbIZ+ns+d9R2jwqM
         92Sg==
X-Forwarded-Encrypted: i=1; AKwUvBwgXORvhQ61ARjnxEDiO1on5Hiy++WEldfenz2YKbAo3YsbZQlI3aLa/8E1gsa0exS+oQB0bYQrVQ==@kvack.org
X-Gm-Message-State: AFuF++nU7p5eEX02QhS9fOreuFweXBVGSEQedc/BySawzJperrgq3GBS
	jX8WoTxBupcpoWhPmMcSxYGwqjuom063rQW3OX73rdDXlECL7JjTmS0JIaPFTDI8LIc=
X-Gm-Gg: AYBFou1BjAgYf32aGaGpiV4T6W0w+wWztg7/urMf50dLmwX2ZRB77tbp4uDeSFfxXc9
	4zW/YlBA7ukwA1A2WZ6XVLp4svvLuxJAP41cRfbqN/+YvAtnKCxax4cYf8Nx49MqyIadfgQM03f
	2bxBVM5flxdjSqzCfg16+iFm7Kpg38sjW1HHiXKwPSakZNsu7okRGGIdvW8F8Lh2VJIrXa00YRX
	Ym0ZNhdZc4tt2AkzOQUJ/Qa+hHaSpArRz9MMr4eznrRSvVyT8ui3ko3bMhC/d8pt3MeL+QhlLop
	yyMqqJGckW1wYgCvWZ54+Vx2QMCP7ruNK8QDI/Yq2kBJtTdxZTKDmTdEMzliaQ1ZZrLTuWw7/PY
	M6X0QDQLfiYbfWiesJnwaZHb4QwsnBD6vu8/+rHkN/i4ySPpviXZy9fBRmjFxYv+NlTP/XSPeLt
	p2SFXbDznJlf9jOcaDGiin74Qmd+dXzvsZayov78g8RZUJU6sFYfuVbV7Tci4LdENmWOAwd2MU7
	4hHg1ymSkXwrzf0WqXCXeBbdKW2AxTgepF3hSrB26AB
X-Received: by 2002:a05:620a:a38a:b0:939:f89:3688 with SMTP id af79cd13be357-9398048b90emr1959600685a.42.1788797092662;
        Mon, 07 Sep 2026 09:04:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fbb70f1sm932389885a.40.2026.09.07.09.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:04:52 -0700 (PDT)
Date: Mon, 7 Sep 2026 12:04:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <ap7fOu5DHkKtqlkg@gourry-fedora-PF4VCD3F>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94E441C0003
X-Stat-Signature: xyw66inf4umssdmxnpwkhxm86ae71mks
X-Rspam-User: 
X-HE-Tag: 1788797093-8532
X-HE-Meta: U2FsdGVkX19nCmi7DUi1mAl0bUpDBHAqGPT9aErGVLA5+540ElUH8VcdqTpFQmGkgDiMBViOYwusRqViSbLiIwwHrdF1s/l71D2HfpHspeV9p6VYbz13lk0jjIAzqpgIXiPdn3QtEwjVyUrrZ+R3/lnErwuQnfTLwAMkAwAIyWvjOEuLcAKmItlEfg9sEOEOJwD51IWUmquVXTqswG909c/KRLG62LmOrutkUJ7uyIxPte6IMRdETrfOlLbYGD2lbEY5unZKAjaHTTvFk36oGNUpHo5SPUXBA7+ONhUcxXDOfxNJ4tYzHJEGe4TACjr7dEx9lMDu/HCpSzeGkF2HrfLhFM+kbbJEbaDe6VR6nefPE52D6ywv+CFRN9IagUM/dsT7ORP7rLCW8T/HURFaXY644rmR2TfZzN2bllZ8qqSEJcfR6RF7fAY1SDE5TQ6ys/XxIquEG5DwY+aAFQ3VzKkJQVsWnHv6FvfJ3vTaL7d1OIk0H4K998TBnJZjouXqnzsvj6e5oeZLaebtJD4ZYQOHrWJUoMHjo1Rj0k8GPmi7EaMetyvyBmkK/TyLibTvByJv53JVe/Rs3nG1RjhtPGVBtqKb9+umCwcXdkvDh//VSD0gWCdKnddrTcqk2jV2gw5GJRWVGQiLpV3VPupFd1KssPCTDnWKGxje1TK5JTwyjVY0Xhh3IBBFO4Knd9SePVvZDDaitqShQ/7NLwZqcwcPfRQCjnaM2B0hea3zB5PAc7qkwuYwKF3chan3FPpxI+raFOfAwtiDytJfOSC4oK+4fYffT/UI3IRJaMvqCtsZRtozLDfyVg/rV24kKmcNXNgqboPn5U9prNqSQtavvgsg2IjHE3iNpO8viuXRd3EHaNxVWsFJWO4tx24ismxVtaC+3EC+30kjV/PKRLiH+86Sh1gXCIwC2OAtxbp3fqJb934aJpzlCM56mZqlKvU0UQbqXjdgFPRe/GTzbCM
 CSgsiHH7
 337eV8W5qFoM8rXILaOaSB550mgcD+23yy9ybzAhphQQaSdiEOWNxq92DOADZPyP6xmaAoCZlQLHLAnROgDEswisod/Jh4/ZPdLXNtvayKosKgnJqmbjMkX2l/P15PVPu90fwgk5T/X4oSThvF1Y6THDn/TmVkWS/r3O3b3UXU285gE+p1jQTfajVTImRiSXfJdmdrOxq2EAwQhYg9s55UBIsBkmY8FMP5qUlmHDT+Fz6KIFCoJ3+X2BoN4a6dYWvebDzhf2sDBKY4iJX28BT26inRP1tx336LMUE1V9HlHxPXaRXupK7JYb8gskw7sLOBhmSryX12FUu4aC2epMYPW/sbGDygvY4jIhSZlSDmOQcCVTiMjAd/MdC/IO3Z8F6p3M+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 07:00:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
> without the success_hook hack we explicitly permitted mmap_prepare handlers
> to set NULL vm_ops.
> 
> However this is dangerous and we really only want to allow this for
> MAP_PRIVATE-mapped /dev/zero.
> 

"this is dangerous" -> can you expand on this?

I had been experimenting with mmap'ing kmem dax devices as a way to test
generating a driver-defined efault mempolicy on an anonymous region, and
this exact pattern came up for me during mmap_prepare trying to get rid
of the "fileness" of the VMA.

Basically looked exactly like the /dev/zero vma.

I understand this is a hack, i'm just trying to better understand why
"this is dangerous" and it shouldn't be a supported pattern.

for clarity:

   fd = open("/dev/dax0.0",...);
   buf = mmap(fd, ...);
   /* 
    * mmap(_prepare) callback marks the vma anonymous so it takes anon
    * fault routes and sets an mbind mempolicy installed on the vma to
    * prefer the node the dax device is registered to.
    */
   buf[0] = 0xDEADBEEF; /* faults an anon page from the node */

