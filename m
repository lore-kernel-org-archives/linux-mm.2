Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAE0606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZHCnSDpN
Received: by kanga.kvack.org (Postfix)
	id 169C06B05B2; Mon,  9 Nov 2026 07:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119FC6B05B4; Mon,  9 Nov 2026 07:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FC46B05C4; Mon,  9 Nov 2026 07:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D877F6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:12:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69510A069B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:12:52 +0000 (UTC)
X-FDA: 85415469384.16.8BBD8A8
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA7FEA0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:12:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZHCnSDpN;
	spf=pass (imf25.hostedemail.com: domain of vadim.fedorenko@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=vadim.fedorenko@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYz5XasKnN4TugzUWfM3/cMdAY/x2jzfHlfhQ+galWM=;
	b=dK6joCyrtsaY2hzKz6d+zpWR3Z4D+C3/ND0t9JAyFejbSA01xgKyXsgcA86DFrN73EMBLm
	YxEtWw/AP9LMsZ0F1kKCBqx+3oF6U1YJCh47PaENB9Dlj+ZXsu38cK+XSDLZC2FYk/hPf5
	kHxvBm3btJT5ogFLkCPEgiAifZqtEz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226370;
	b=jkEl0j/HxvXwxgFxqr487PjEtUpVysycdEnBufoJEdB6zpT0CEirDLmp66bwodEIGsx30t
	hFFyglHX+I5rlpYVjybtdSkgDhyuKRLPTJAPP2ZVE53DLR779IYBW/VDqxDiLGPAj0wqpB
	ezJqzXxgXClPstdf//5bLxrTRZ91Lyw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZHCnSDpN;
	spf=pass (imf25.hostedemail.com: domain of vadim.fedorenko@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=vadim.fedorenko@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OUZK1hzYgJtzU4nG/ylLO2w+RnFmaiBPq0yD7tkY4Ik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794226368; v=1; x=1794831168;
 b=ZHCnSDpNkPq3NM5T6edR1zp/xB7qZJSfbdE8sV6x9s6+F6gMapAVhQb8vrotPpnBD7QpADkY
 WTDu/1vlU/NAeAbMgHSb/JWlgZKrNLoD5WgTPisGLTBOMXWXkGpqqnnIybhgzxReRESxBteMwZa
 yFsNK1ZMXAJwN7gJ12G0ML2c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84c5a36d145168ef;
	Mon, 09 Nov 2026 12:12:47 +0000
X-Mizu-Trace-ID: 84c5a36d145168ef
X-Migadu-Flow: FLOW_OUT
Message-ID: <b2d2255f-c9f4-4c94-a739-b80f9bc49323@linux.dev>
Date: Mon, 9 Nov 2026 12:12:47 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] ptp: ocp: replace __get_free_page() with
 kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261108-b4-ptp-v1-1-71160700886f@kernel.org>
Content-Language: en-US
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20261108-b4-ptp-v1-1-71160700886f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA7FEA0006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: c581uabpcbd6pkrep7sj6srak1skp8ts
X-Rspam-User: 
X-HE-Tag: 1794226369-84892
X-HE-Meta: U2FsdGVkX1+ayb3W97QPbFMO77mJyKrg4GBp2llPFYrcuEjyON4vmlHA21eXCNuceQYj4AZe69CceQIXshwlgAw06vh860w8kf+X23Clt5nwSwLQGLzwpOvAFlEuwTytGXjkkBQWuC52JSgdGvXpaBnzT0b783O7k12/cGM+YuEHVcZKYLjVJyfP363NkNEeJJNXhrSxO31Ra+64QjsxTb5oN86vN6AHgFgX9Ghf6I3XNdCRTvvzz7L9bTBuM/27jxegt7BTld6Q7NameiKSkeZRKkm6bkWrsc9npmgrvjTnQYbb8MnOZW9k7RP0yr04OLdNu7WC6FlOXISgBth7HLnmqNTASk6hTR+PG5xSj7u6YKT173pObMo/iH4QX6UQkkYX4Nzq2Wlgz0v0uyCKhSdb09IfRO3dBf2vs55LhhdXNwqamYgO7nzovjnTEpwAM4Lj88eEruszfj8k62aeYStrNGHmw8W+oHEFuwOoEJ3TwMjVjpzUbe/zjwVCEzxDqeNmRarAlU5eipbsru49qQGlozIjZXnLdWjqXdhEHGgUJfbstf2KjrscHDHu8TJxiP2fkDs7EN7IV5k5o/Y89h+4VX7HJ6dgwW3eNM1Yk5MUSvlQwGhvyJAzuy5hwrAgqD+vX3HffbKBBnfuLSNXx2b1fkh0NxxpjH2Zoa9v8BZ2DSosmbKYEH/fpyCLAVnPMs5jkXosCw0v+VjaWlZ+sDGjy9lrNsp4hV9zxAZ2J0q/BH52GDWbrCn5qcHWvlC1cp3FA3E/FoFi4LjZ42pJ8VBzIyjyjrl9B3wVqh1dpbGmqor3g8aXRMQe8WBffrepqZHRc2NfFi6CGqXqXLgIX0cDo/R4DkSzPYh374rJ3zor0e1wFdCR4bMJZwMlwKyFPv9hj6aMwebBym+fFPt2brwtSckp1RczvdcJvPTXOBcFitm/3gs/0a2lcpt+EByfhw678dVIp4VgM1l3E42
 /wFsX4IS
 xWd5r826Yn2mjOoJlyTD8MP4O7SnoUQJ/vTDHvjrkFt+obb03JCKxeoXzQTWooaSzvdWZKkud5v7T3CIB7j632+OEumBJPS+yq/u7Yr6Gi6ZhIZVpA/8m90uIQHTXFO8Ml8LDFn7AQ8mA2pXq37QvzCVeg2mXslbIhCSLjqGYTn47PNvSJVGjugZxWasvKKwYhbRt0aVmKaRgxOHIUeuglU8yPK3vtrO6ICpdy/wUuVwHD+UBaTZj6CrCi6k01IJFCW3T62NscouQ4LPU98HGr5/C/tjThUgN9JoknWp958Y9/htEUU2QBZZ59qcf9kQFOzAkWt5WwBPsapSovpkqA8m9ADHV/sUN/izvOs3KkPL1/77SBnYg/L0FH3++QoKExQfE7nULhATWJ/Tj+PBdDpiHJrrcxzKdGgVKgGg2rnhjQJ+iAQ4UpY5pI5GJFvn74MIfV/8mkQfS9URPU2U8xBq4Ye2rNOmwDpUACEFgrviQ2AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 08/11/2026 08:40, Mike Rapoport (Microsoft) wrote:
> ptp_ocp_summary_show() allocates a temporary buffer for formatting
> PTP OCP device summary information.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> Removing needless calls to page allocator helps with memdesc (aka project
> folio) conversion and gives a nicer API without casts.
> ---
>   drivers/ptp/ptp_ocp.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 625a85b2dc7e5..decc56892059b 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -18,6 +18,7 @@
>   #include <linux/spi/spi.h>
>   #include <linux/spi/xilinx_spi.h>
>   #include <linux/spi/altera.h>
> +#include <linux/slab.h>
>   #include <net/devlink.h>
>   #include <linux/i2c.h>
>   #include <linux/iopoll.h>
> @@ -5281,7 +5282,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
>   	bool on, map;
>   	int i;
>   
> -	buf = (char *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   	if (!buf)
>   		return -ENOMEM;
>   
> @@ -5497,7 +5498,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
>   			   post_ns - pre_ns);
>   	}
>   
> -	free_page((unsigned long)buf);
> +	kfree(buf);
>   	return 0;
>   }
>   DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);
> 
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20260624-b4-ptp-ed56a38a6afd
> 
> --
> Sincerely yours,
> Mike.
> 

Thanks,
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>

