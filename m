Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72A2C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B776B009F; Mon, 31 Aug 2026 06:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBD76B00A0; Mon, 31 Aug 2026 06:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012326B00A1; Mon, 31 Aug 2026 06:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31006B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:13:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B72316042F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:13:14 +0000 (UTC)
X-FDA: 85161151908.07.39DD32D
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AEF040008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:13:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jg7wA0vL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788171192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67t2MAwM/CJHQTc19wvE+OmwIIUNA6nz2MWrmdq+rUg=;
	b=e28WwIfSUM+Pkar0nSaSOAYUJVE56yEXsOTl8Uw/QsJDH+8pvVlQy8UXFNJ84Cg8oO6FtL
	vsuHOl50dg4Bf1fY6KNmfvZB+nHlfgp91DqjB7IkWKz3agA9g5NDgLoi8U4lsx7QfAC1/M
	bvI4S9hjZHn+aVhNVH12qayvAZ636qA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788171192;
	b=dyfpcPcLqsssb+4yhDnIixGpX/dz6SVQlc0ip27gQ6pi31ESB1GVTYcG6cIulYOkpztMZ+
	ix1PxD5sxaAO31mFrpO+u+NTYogtzlRd4FkLc78zBnFmSKlK6HtCCBrtF4siJFG91ZLHXo
	i45bBiToi2qpyu6Pkx2WHuHdSTT4I+g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jg7wA0vL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c20e70a0962so420745766b.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788171191; x=1788775991; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=67t2MAwM/CJHQTc19wvE+OmwIIUNA6nz2MWrmdq+rUg=;
        b=jg7wA0vLZcbhJTzNj8beTE3TlPhaQJANq8RMi0pWXxGkQH5sckjnhFzg7hMIi81VYs
         RDtY/yWUcJ96beQP7zpIc2fMqFCI3Bm6PjqhSxQNlOdVvxLYakMWeE+l6st2KBVDxWiY
         EWLxXjvffkA+T8rRJef4StD8a7S9jMDqK4fM/0Zcu6QXavPptyA0kFzjRn6k0ZCJ4Pu1
         CvgY4JFG5iel/jJj2WSu+odNLWbdH1xAdBYyghzKlMLuqVCxkqZO/1WhSlOf0FPYe4nu
         bLh2izYeBFvX1bIVPr4ZKs0/TEVOOWhR6ruQKIEHHa3eFGnko/j3v1jXwK9lW3lSQOL0
         4WMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788171191; x=1788775991;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=67t2MAwM/CJHQTc19wvE+OmwIIUNA6nz2MWrmdq+rUg=;
        b=RliPhmuh+FzlcUudIRqWqEqFJoix/ZIFGtwdXzZlCgPCFLFX3gwbWf1rfk+NxK5Gu/
         OPY2Nw6QWf0yVVw17ey1K1yfCiXIXOqWyAX/i9vl3yejjvsnUgEHCl7AsH9bDyLMn2RO
         P7sD6W2X8A7ISRdo1WBOLpPtZ7z8mHgk2J8ptxSUSmbUg/If0/HGVU0CamtMmQb04PxO
         2jBclixlZla+jq5g/aerDkDzKZI83Xzus5oI1lq8MjioQD/oS1gzxt8FyjmQtM+/ylG1
         w1nOj0v7VExFA6q0ADToGQO6/j9cMXbW2B4RILvJS6kMvOzyLNNtApePKLoIiaSZ7NqG
         V36w==
X-Forwarded-Encrypted: i=1; AHgh+RoKFaoAE6rfgoObQpQefG4Zl063ho8tLyFUqKPxA3PedAAq2CvICE6RUydgwVnjamoK0DtN4crGLQ==@kvack.org
X-Gm-Message-State: AFuF++lS1z6EZYGvNkUk1sIOhf8Ggl/jipRZY8VkU+is7Kj9zzvYop4k
	Q8TH93d/XLliSCT7BuMXw6En6n67gG4E2CDdQD+FvRMmlfziYMyeYbDj
X-Gm-Gg: AR+sD11G52Ss4rPdl1izkFCnhQtaZbdUYAgK2VtW3V1z/+Zf8REJQy9rAbgjwNIw0ji
	iegcgG3SXuA6Nuu4QnYajNeSZ6hCvT0f69QaTiYuTB3vVDafEce7Vp2+W2hiVNgXvaSlY+Xjj2c
	1KeKvrTOGvtKqWe3XWZLVNf9FxuA1JdBCqA7DKbeK1zwIOVXGpW5hCxiF1yEtZKNl9w1nCjjCUs
	EcstsQ490ygeLxmDBa2OGV2axJojImbo5h7JA06h8CECSKBPS4Wa4InnmJ6VdoFQ7vXjSmYHYJw
	Jhn9/5gXxaduMxg3P98eevcOqsAyLZg/pRY8h6+gXbGl8FQZrbXPoXID1UhtMUU+R6Nk9HI5EKv
	HJE9iUIq8C/vv5h8eaudoIW9/KHh7fKh3l1xKCQo0vQsKzgmZPlAkvqzzL7JQesSkFFWDL39BGR
	69sYFK7E8v2refnfwTC881YVj4DED6d6oj6mC27nazbzdYlYp/aI+LWTm2RerIhLtbbIXCetWNb
	fIlO/oxkJ7cbGzKZGFGK3SC
X-Received: by 2002:a17:906:1013:10b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c25aee558cfmr69135566b.11.1788171190678;
        Mon, 31 Aug 2026 03:13:10 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f1b28f6sm385832566b.39.2026.08.31.03.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 03:13:10 -0700 (PDT)
Message-ID: <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
Date: Mon, 31 Aug 2026 12:13:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
Content-Language: en-US
In-Reply-To: <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7AEF040008
X-Stat-Signature: x5ym1enkgxg4igquncpe18tsd9z3bjfe
X-Rspam-User: 
X-HE-Tag: 1788171192-457482
X-HE-Meta: U2FsdGVkX19vEHYzcClXo8LkR9ITd0pKMpq/bOxl//F4I0qyFPabDj7irjl6LzRvCfahqzI81EOBjRobUPEgO/wMefn7X8dP69RMYsMsU/5vtaStTfp23ePiAXygNm/Je5r5dQ7UlDGkBp68FTdoSi4IOpnhooLbOlzwQZizoCGGK/fvCkembLTxtbRgUPxgam5HGy0NDA1A9/jEnoJcFRE04BQBa8L6rdZ+2kCgzDIWsGxQWISdG73hsWR1FDeCF55ramz/Oj9Td0Y+GctCUJsDnb+KyQtis4nLHcZoG9xjEVmw152/ooAivIMYIIdLiCnUicjjQ8k1mHY0alc9cTINUXsbs40968D/6Uk8Ultg2VZ/Fzdly7xz5yllbRhmnuX12nI2UJfrn1QOiv2wOyVg/ds7SwLxy/67ag3C4fDwk3H66A2x7MFY3Lsofqx906F9LE9Yc6EZ980u9hLGXsVJlrfVB9Tmkt+ZE3/CRZdRU0jalCnruG2hIwk/JIkuVs3+EnPsi9l1SdwG/UIav/+19RtsVWg4LDjyEP0EOxjRnl22ShaidrEwuZ2awiVD/6zfEoJRQsB0m0FYu0aOkcXN9QbR6kjNf5uaFvivcmQAQP+7uXjrEwOuuElGvMonZ1d/xTfkdOJWps3vtken2faHu+Fs/2Khjg1rrSwOMMi202eZ4QD81/dHgafCtuBJjHTMjg8MtU6EKCE02qTbdWeqKcLgDp6lrDFZR5JbwYOB+w1BXn1MS0PHX3iK8qtdPHs7k2Dz4QVEGCV0ETVgMkwOfe6pF7IN8K0tETQwNcjv6UOvnOjPhix0qe74u1RX68FnmdReBnBz0sBjXr06nluqFG87wR9mkKbRQJc+jzpl0HGK1EztmEQbNj6ygDmNhTRtfFxixXU+Ye6X+ARL6uR1gPD2Q18z8purzJz8U5kztfdFh4w+TBT7TG2hx/XQOcPs+NVvD+KvVbtDKW8
 N0fPDKSz
 KHB/SuYCwwue7VBodTGEgJmtSzVMyXI9wvhPhrMlc6Jnq/vpA0gHeSJmxb+Ms8f1YUjD0N+UkMhIcR9/I7QdoJ5bkLdhERmucWwaq/LhWK7Yyl7NmuHWUEXEONhgFAGyaoID2wXxo0U/xWmeFUpkVdCE+TDrAZdSZwvwh1efIycK5iVhYUKTeegbm6GwljVmzHFz3slH1CtOh9HXMGBxUf4wjTeUfhfnZwP3QkQHWvhGdpWUyBIwcgXBnwId5zz7cFywepTYg8ZufVXhxnNphAVhkFZmYbcumfCc8lLl8g5Ox0S5nb8XfRYTB6ZmL5HqUURC5wWsG4gGAuqE0Qoy+emDS3gDrj6HON786ZQ4WFJaBBg7YTQKMCUs2z9im693SffoZNSAFF/O/yJZ1Qd1VAP7nM0ym/zx9U7HZpv7Dcdem6S5gsDsGexJEHuk7hRo8TpKHJpA5EBeIt/jAah2jCBHyedM5S0SzVanrxZqIQFItacvcSeeXxa8hILEScO1fNxz0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/08/2026 9:47, Mike Rapoport (Microsoft) wrote:
> fifo_init() allocates the buffers backing the software FIFO and
> endpoint_alloc() allocates the transfer buffers of a USB endpoint.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.

Except that they are a bit large.

fifo_init() may be requested to allocate up to 256 MB of buffer memory. 
This memory resource is split into an array of buffers (fifo->mem[i]), 
each 64 kiB (or less, if there's trouble obtaining segments of this size).

Citing Documentation/core-api/memory-allocation.rst:

"The maximal size of a chunk that can be allocated with `kmalloc` is 
limited. The actual limit depends on the hardware and the kernel 
configuration, but it is a good practice to use `kmalloc` for objects 
smaller than page size."

Regards,
    Eli

