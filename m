Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22300C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 20:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207D36B008A; Sun,  6 Sep 2026 16:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8896B008C; Sun,  6 Sep 2026 16:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0815B6B0092; Sun,  6 Sep 2026 16:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D162E6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 16:21:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49E27160606
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:21:41 +0000 (UTC)
X-FDA: 85184458002.14.FED2890
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC57014000E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:21:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TosTePwf;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788726099;
	b=QPx95ucNHK4+o6rm17PZGNrjiew3qJcveyOMlCb4dwFrlTgavWjMsTlVA/DKd9Bgz30Tma
	PTsH+4Jo/QXjkqaVvr318Gr0Px1vAm9G5dOtxOcAJUQKEWL0F/HX0UqZszxdvmyet5g7c5
	3oXRj1D7jgwuhcwIme3XM746teEelHM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788726099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzM9ANcfWxPv1Bv9pbU9NQgz9pQl43jfn34ZVVQEB/g=;
	b=n0Sp3lbpbhsRdxbvtRGdWsMThWKT7/+S9mSNYMkKRG5h8NGRzKkefseU4ObECb2WASu0P8
	TDFsnnXtSU7rQ7AO1IUfzBx1keBCAxRw1BMIepIrkDYaoz2A59dZJZ7kEDq0wrjKxjznF9
	TGV3T2ETd7x/2fhHMwOvcoZXs5FOswE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TosTePwf;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7B67601DE;
	Sun,  6 Sep 2026 20:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7851F00A3A;
	Sun,  6 Sep 2026 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788726098;
	bh=YzM9ANcfWxPv1Bv9pbU9NQgz9pQl43jfn34ZVVQEB/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TosTePwfV3FXRZluEZKjQtM7YblVHqUl+Kq/rBGavUUQUaJJ2tkSBoVrwLv+urmI/
	 1ZM/z5QIIt4fYbl5+KSDcWf2tccHzY5XqxKm3WzezC+5W5RYLqKcQCY8duMTTSz2Jw
	 UsGNAK1gLp3Cy/lvnxrtAhV+o7BeE4UL2mmh6lo210nODfVbVYYXFNk/lcsVkL/vQz
	 Huh1VSUhrcDIGHZqy/d9UaAtX0l7RxzsxuFcwNUDpXfH+x2UV0aDrhat+lI8lrg98Q
	 dVyRTWyWKDay6xUA9sD9LqHc7BSRasvSomnf69+KuiTD4V0o6s+DMOhmJ1BYV5gcMR
	 qLBYNu5cELkVA==
Date: Sun, 6 Sep 2026 23:21:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock tests: model the low allocation limit
 within dummy memory
Message-ID: <ap3LTQlKTpDbAEJZ@kernel.org>
References: <20260906144011.848898-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906144011.848898-1-hi@tychen.cc>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC57014000E
X-Stat-Signature: jcauo983qux9b39b4zdhmwowtzmrx7rg
X-HE-Tag: 1788726099-667230
X-HE-Meta: U2FsdGVkX190kwvwKroahkRebNKMMboE7PXZZF3gVa+GLFNHT1HzCU253dzYMlRvjKFcMtZBse1vPUQLFe5twg+krorWBaW3T/I8+R0/5BAd9kudf+e6FyOsqC1uvnf5d9kloSEei0hQJ4WN4WZxajAgDbtod+LQgccflvDwLDcLuWFrVdt6oasPVt+kXq2Sd5a1yayJMWoTodZIY3GqCrDtRlh0abujq3OLR4fxBq7o62Uez9c0PAXwSTW7mb/jMA8KEZm1yDKES2nTnNuNuLuVO9D62K2/A3uKps09HAL1SKj7SbODbQH6jrx8fKoQUoEJouwZiot45tgxcbq9nOmkChy1xx8EWTV/8BSXGI2FY941ohwVh7SLkZcJcsKvjBGF6DHBtW1OR8W2WHwYesHrUBLFs5O5PRiY6ZmY/Vfb8HOQ7xpNgf8NC4SdnXnz65ZlHXbZIWt1b9WYSXG2Pvjd0EOB7Y2Epfe3hqQDrTKa743P0zyVBQ1AlwwkMbeaAXXiJAEu+9TBlkg7mFMig6zxyn2nmuFk2a+wxM99xseWreQBndNnC7mDs6esNDuZDJxhKHH/RdmGGO1o+KsRlK1vVBtctq+I4azPdJBX8GEJZvC8hRreCWV3IOPz2Hb8qPKxTbnOq+MSGzl3PRgSTrraqC4ywh+nidHKJEAX0U3nJNXAvS5qjyy8zwwQBGoSxA1M5cy+jibvnMbOBnrpmKTTyHK6DIgZVn67kIA96AtS2C+48HbypHybPSHx0A0hdlzGcF9wtDrquVsycYF5aodaps4KiJGgMEpbob3+x9Dhl7wQjR/pT8eme0ETQTL8AmsGzoF302s1+1o0oNHeLfaoclMblqI0xD0+jd6RHX5pKXGIJjFEuWWmyHTI0b0EoLtveW32a5FkRw6fck6vlCmy+h9y8x397PkijA5sfdmwq5vs8wkxB4x13cu306zhA/XqmgM1Wk0DPTCGPQP
 GBMQFY27
 7I2DCG0jiuenJDe4KhVXSRcE0OqjjdvDg+pFUpj30xyFzXIXvmj7Db24gvdGjS85Z+3Irgxsoxlomia/S8bbA+zyXeidm8Nwc6RnNwrMxKcMmXKrJUsxjEGVInEEeds7Ro4dWeb5NgD/RnnGs6e8rbrouHaDsRD/kwI2+uJDXUkO1cirAT+3dJAYtb5Sl0U2rS4PgK2r38S84BCqmJEhlFHkouEis7Qms9uzUZhqEL/0pR1tzowbOTH8DfYNl6TQDol+eWNPXAO0aD2Av6qSfWo1BtVj9OnJW5zceEPA5uPa135s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:40:10PM +0800, Tianyi Chen wrote:
> The simulator represents physical addresses using the address of its
> allocated buffer. That buffer can lie above the default
> ARCH_LOW_ADDRESS_LIMIT, preventing meaningful memblock_alloc_low()
> tests.
> 
> Use the existing architecture override in asm/dma.h to place the limit
> halfway through the dummy memory buffer. Resolve it after the buffer
> has been allocated, so both low and high memory can be represented
> regardless of its address. The production allocator is unchanged.
> 
> Assisted-by: LLM

Please add LLM attribution as per 

https://docs.kernel.org/process/coding-assistants.html#attribution

> Signed-off-by: Tianyi Chen <hi@tychen.cc>
> ---
>  tools/testing/memblock/asm/dma.h      | 6 ++++++
>  tools/testing/memblock/tests/common.c | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/tools/testing/memblock/asm/dma.h b/tools/testing/memblock/asm/dma.h
> index 13ff8e5d22e..6607408dcf2 100644
> --- a/tools/testing/memblock/asm/dma.h
> +++ b/tools/testing/memblock/asm/dma.h
> @@ -2,4 +2,10 @@
>  #ifndef _TOOLS_DMA_H
>  #define _TOOLS_DMA_H
>  
> +#include <linux/types.h>
> +
> +phys_addr_t dummy_physical_memory_low_limit(void);
> +
> +#define ARCH_LOW_ADDRESS_LIMIT dummy_physical_memory_low_limit()
> +
>  #endif
> diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
> index 3250c8e5124..4e6a920c459 100644
> --- a/tools/testing/memblock/tests/common.c
> +++ b/tools/testing/memblock/tests/common.c
> @@ -118,6 +118,11 @@ phys_addr_t dummy_physical_memory_base(void)
>  	return (phys_addr_t)memory_block.base;
>  }
>  
> +phys_addr_t dummy_physical_memory_low_limit(void)
> +{
> +	return dummy_physical_memory_base() + MEM_SIZE / 2;

Shouldn't this be PHYS_MEM_SIZE?

> +}
> +
>  static void usage(const char *prog)
>  {
>  	BUILD_BUG_ON(ARRAY_SIZE(help_opts) != ARRAY_SIZE(long_opts) - 1);
> -- 
> 2.55.0
> 
> 

-- 
Sincerely yours,
Mike.

