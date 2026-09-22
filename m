Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A48C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A536B00A0; Tue, 22 Sep 2026 08:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C926B00A2; Tue, 22 Sep 2026 08:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3B06B00A4; Tue, 22 Sep 2026 08:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8743B6B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:17:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10F09A65A3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:17:09 +0000 (UTC)
X-FDA: 85241297778.30.087C0F4
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id B88B41C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:17:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RtvlHxQO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790079426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgtWhH7fN1wZ1neVmdj/h2QBFjKH8NY7ifeQrzN/T4U=;
	b=LS1NAhxtgvRvBWUsvR+KlhKgzBEHIwk/T1tQlQrzccEgbrYWA+z+nHykkeo9BTvLVj2Bjf
	Jfk+6SUeutT8Usb/YIaJEbCPwS8fhGnQkxgWzFfF534RrQjj+oRXupkaeiIwtFnweCB12k
	9FOKxmVRyB+fwBCFqnJCCTmoSerh7xU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RtvlHxQO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790079426;
	b=qdsXgckeYnxh1hnybVoZuPhi11a6g2OkAMJ6Y+9//lWPxwwVMSHQJD4DvoCtHTNvZl/TuM
	m64Ez4b9rq6g9/IxQB4XmJnCpIZaTTP8E91wsKfttU20WbRBnMjRa3QGD9vGBGx7c/Io3T
	6N2J5ZVaGHkiGuRj79Bvv2k4N0a8glo=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa650c8so592918266b.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790079425; x=1790684225; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UgtWhH7fN1wZ1neVmdj/h2QBFjKH8NY7ifeQrzN/T4U=;
        b=RtvlHxQOfF48gzZQrvHL193qr69MZQe4hm/xaInN0gb3Inc5nFrACvIjYpj6qW1oer
         yA6zogUKCYf+tUewYSmgPtMsxgIDNu6nBxHQyqy7U3fUOZBeiziz542mVu9bd84Rw6Fo
         RzsL6nGbrx0F7v/sWYNzw/AFDIbnnpPmcoS2jJoOgMCwloR5ZVjUU7UllPcqEJboUpye
         Twvq3kBFDvoulcc39NAma8vzOtL09xsmuOl4wovbCERJcx3HvWscHYQmD94TDQvziPEH
         Nykwixm72wPeEQZiHwbpp3/KvC42VemBqZs0qwd+ZnI5qUqlyxd1yNuFSjodBukBxl/r
         btJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790079425; x=1790684225;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UgtWhH7fN1wZ1neVmdj/h2QBFjKH8NY7ifeQrzN/T4U=;
        b=IWwJgaOSSBPbdYCgrkAmKngN6VhmpuabVO7mwcOy2WkW9qY8l5sq1f19KNC9LVUQ+w
         Vu+FNv2j672oD2xaOpq++cF1e97GJHeTVe1+wbBboG8hqnBS1OCuA5AWMdGNlCls4rbw
         15mf8DrtgVvA0KRIQTExYMaH3lNXVJTas/oqj+4kLaHBCnbl0+PywQHnajfcol9Eu4lt
         6rHf4GRDHPWxaJVJDdLR7HTzflPXUM5gkrpGap9CaleykXKFqWvbg1M4J3RDUUQ7ttef
         n7kJ84X8r1JN2BcfgJBg5j20oAL55w8PfqA+XY32Oesw75EVGdqk/N8SuFeuudEl4fA+
         1XsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzgCaaAaUpekEa/iNTh+Rea8DOEc4vahRmOdpzUtKUjJTxG0spCkjIlAx+XZA+cCEQPdaYaS1UReA==@kvack.org
X-Gm-Message-State: AFuF++loWY51hMPUGSSdgNNSuW8yU+JrdElV7daBQjt00xVtl3Q598CY
	IO4nypUbpbQnIQO9MQrmmRxvEnBD5AxPu8rxiluVU0OGWveFYzL50zRm
X-Gm-Gg: AYBFou2lNPd05pSlfV8jqA4PLhQ3+EYbi3CYfjigzx9XZ2Fd9mtKicQpH2wH5PQXDmd
	NCR0N5BUrhj6UI1VzWhRUdGrhxtV/XSg3moWc4wlu0vgvUjBU8Qstt5zbI/FfLovfI56yojRqvL
	P7quhtfG+dv2TbR9v2Lz7nfZrwb69mBIsKIPp5iq1+/g03ma+USJ8iBkLDnKYVjgjTwIsxTe8az
	oYg3r63KeoiRRU29H22SaXSSs4Cp6monXrdl/4hMvyUyKxj6nCiNvrb40KBsk1dJCA4njHOTWQp
	c+pb3Z5iQiebCjDve66XnEDsLki4XmLNVC/fuRjuPtvnS6KGucCF2m6joeEA7dR/0kQyaJsldMX
	AqZDkkd3aen+2Zts2P1HXEMswS/iLPEHjiqDytSdhxkYfOZT0WVMpS1qrMi3CiPAx9EHVzl07kD
	afLLCYGG45RtJ9oTmdASTB/CLNi32x9gTFqsk=
X-Received: by 2002:a17:907:e11c:b0:c27:420b:7c79 with SMTP id a640c23a62f3a-c2a8acf45edmr237310966b.48.1790079425184;
        Tue, 22 Sep 2026 05:17:05 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c5ee0b4sm74104166b.50.2026.09.22.05.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:17:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 22 Sep 2026 14:17:02 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v2 1/3] mm/vmalloc: fix vmalloc_dump_obj address
 alignment for last-page lookups
Message-ID: <arJxvj1vaCeNCisu@milan>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
 <20260921-vmalloc_dump_obj-v2-1-73fceb3ed1c8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-vmalloc_dump_obj-v2-1-73fceb3ed1c8@linux.dev>
X-Rspam-User: 
X-Stat-Signature: tyr31cxwf6jnef8kowytdajpjqdtrrpz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B88B41C0003
X-HE-Tag: 1790079426-735670
X-HE-Meta: U2FsdGVkX1/sN9FkeuQjCxVuNK0NJ59kwPdLr58GL9P54H1yH80+ODFvolASPl0nXirHiiVS2/yjqEvbN9kq1m8YXwWMkzkIJTb+agGqWaXRzkQgZxKjmKVFSdhWN8sV98VqCnaE1n7ArqjbBV9jCRglOgk/dQFfOnyXAnjwczohCD5p8pe66P0kCCQDMbo76TlTS2AWnVIYZ7IR6pOXZQl4YuajH0WhI+EM4Cbxf9r99o/brk/dsDGFqmk2nOuEQL0G7vwfLlRy8Ger7cvHNLMJyfDz5zfytnFhVICYmRoxSmjqCI748iYf4MoZrGPTXhSF/CzS3HIl5CfnFKU8OZ++x0njrTg/JLVvASeI9fMrqWKddMKH+cyFDxrEPppy6Yaju+0ryIf/rFlDAJszffEtOUwCbUr7RljX0H+jTScy+0LMSnIE6kQj8VsqZKhPyfRt01kmYjlNkjb3kZemBTUVBbjxDYXFCek/RiSoiYcGzwA62ARiMXOseBDoCZ1kLzEyw/cBLguLkHo8VfGLQLEBwOoXGHvWfEqk5OhEbgnwIotRalkhHLUOr68PNnVWWQ1R2NSOVb4c8iDbHcOjVefNZ0b/VZbLySoBMcJy4CwvX/GA1h42j9HTyhbWRJm722aE8vlzZd2u5LybN+6qaMXQ3Vuq3uIMuOJpu7dM7GkYLEL5wtx3wr7pfLBTSQoygionlyS8e1QreoLo0vNMPJupnodxdDWtnX/EN5zwhx4mR/mATKHwK8FhTdjvQLG2ZxlJ1m766t5vQAo0tEMeYDf3Zs0BoAyE2C1vjw5E/KQ6lkxVXwStrOXJFZvwTfBJukaNS9AxHLE6IYk7XYW1Phn7D6OW6LFEAIoYdjvSt6+XW7dk6HMoQ2KV1O1xTXellwYWaAmGfmlgAcdgfddjtVF5YCQIKj4l4pWxjC31rGyrYa8rHT5i/kRnTQtCgY1fWIOEk0LNLhVycx3vyMJ
 +CNAxFvw
 aXCkvEz356XwqU0ds9XjbtXZ+IUFBnO9UT5RW3J7C6RKcMUjLXy0a3Te6oXCGMAVY+SkG+ffStZzPmPLwBJhxrEtYtDvMgy3VOLeb1epHrw8Gs7BX3ZlHYj3fc6cIJn7Zy6p7IBXpebbZzjUGQa1q8dSjGm4ciOPCOz31QcuywOnNw0+xLKvLDD4XoAA6LH9s0WS90kVkEUSitG+7W13FE4JWGBPlrsrTA9oulQsjchTJoC72rlcjuPhru0B8Gfr8pZsFkyU01Z8NkwcNM3jLFbQie/BnGdLQkr9zvQFiIthdMADCdhhfBMvWtrdVUhHbOyDXl50VfWSP+vdYH/BzGjGriZEdJkotUrl0ZbWeWr/nFLBQViR3FhMDnlt4wrSODC1scls4TPGYHDpfcBsO3s6aLiocpKoWfs+N2dt7Khv5aFLHm7KqUH7oIGVyUwOePhpaQNwFeJ+oxycLKGDGE8oBENRtEsh2iK+WeQWJ8yJzQHdbIMhxGN2CE0Yl9gKgUUjo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:17:21PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address
> before looking it up in the per-node busy tree.  PAGE_ALIGN() rounds
> up, which can push an address in the last page of a vmalloc allocation
> to va_end -- outside the [va_start, va_end) range that
> __find_vmap_area() searches.  This causes the lookup to miss the VA
> and return false, degrading diagnostic output in OOM dumps and KASAN
> reports to the less informative "vmalloc memory" fallback.
> 
> The upward alignment can also change the addr_to_node() mapping when
> the page boundary crosses a vmap zone boundary, causing the search to
> hit the wrong node entirely.
> 
> Use PAGE_ALIGN_DOWN() instead, which rounds down to the page
> containing the address.  This keeps the address within the VA range
> and preserves the correct node mapping.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 859e6d2d57a3..df42d8a6f058 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5277,7 +5277,7 @@ bool vmalloc_dump_obj(void *object)
>  	unsigned long addr;
>  	unsigned long nr_pages;
>  
> -	addr = PAGE_ALIGN((unsigned long) object);
> +	addr = PAGE_ALIGN_DOWN((unsigned long) object);
>  	vn = addr_to_node(addr);
>  
>  	if (!spin_trylock(&vn->busy.lock))
> 
> -- 
> 2.25.1
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki


