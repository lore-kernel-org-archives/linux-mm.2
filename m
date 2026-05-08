Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70441CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0AD6B028E; Fri,  8 May 2026 16:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81576B028F; Fri,  8 May 2026 16:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A702E6B0290; Fri,  8 May 2026 16:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 966146B028E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:55:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26A80861C1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:55:10 +0000 (UTC)
X-FDA: 84745457580.14.D71DB7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3AB2DA0009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:55:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qs5A9MTa;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778273708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fGUBuehlfwtwPghD9Y8K10LAmv+BHRmZKvs9x/XSKk=;
	b=Ni2CiVHOXmF5w4LImLnlx0c8m0jpTI65qkL7iY7fk1hwbF+zVb6DXwm6NZUu3KgnV/5vFA
	c2MH9yjgddOvZn53fukrzCZzBL/Dn6TzotrBVK7fuH4BWLcjCLq0RTqXaeMLm9Pe11wiJE
	HGLJgS5lvHvAZ4KzXJO6UlWrapy+ASo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qs5A9MTa;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778273708; a=rsa-sha256;
	cv=none;
	b=WxCYh/J825MT6a1qqC+D8bxeMRGcwzxAHBMZQM7RliQj6encn+LzOV4K2OIiiPpN/2MA9W
	70K9xA3zIlWh61d6LUJ6Y6nvlcVPUgy9pUqvDi0ZVFC4zkDwl/ejoKjHXAEu6/f0K3e7mT
	2hfLiiK1r/15SPJA+aUvHUX3UoPErYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1199140768;
	Fri,  8 May 2026 20:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A93C2BCB0;
	Fri,  8 May 2026 20:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778273706;
	bh=vLXuCV49JY/nCWOKRvNGfbOGdAU5yx67gHZWIVTMj/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qs5A9MTasyW/MZTWjl781rUA3+rm5IGMl3iJV9wo8sCOgpQQij+pQHJryBa+JNAud
	 D2QW2QYqclrds4uDNw6HIJ2vaB8uXcbPQdaGyVluwUIjyDmWPEEqI9zc6G1LCuNFwY
	 TttGY72hASAoBsL1ohRbrmPa33cscCuXZGpo/RyUv2iB5KXOcAUNLzVaaC2+kNwMyW
	 9xGSK+px3UXlLb62VshQPhR3lmXnfidxqltYElOpH+j9sHEPmjkMIoJp21+3II0/GM
	 bwYWkRq46ZRwfPt77aWH9b6v8OreD70Rc4+no2li6Ui5xmYUl3sjYF5WhYTFQ+SnV7
	 s6I5DhLW1VJQg==
Message-ID: <5987cdee-9174-44fb-8e2b-41e6ad969612@kernel.org>
Date: Fri, 8 May 2026 22:54:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: introduce bpf_mthp_ops struct ops
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, roman.gushchin@linux.dev, inwardvessel@gmail.com,
 shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net,
 surenb@google.com
Cc: tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev,
 dev.jain@arm.com, laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <20260508150055.680136-4-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260508150055.680136-4-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AB2DA0009
X-Rspam-User: 
X-Stat-Signature: dpqafk6168h3kenughdueqy5caz88hmi
X-HE-Tag: 1778273708-874480
X-HE-Meta: U2FsdGVkX1+zKw1H21abCvGsjEcXLZ/G7Q4s4Yelk40E7Z2SP3tQub7RlLKhvLCfegbYUwz+m+2JHQogLqVOapHpqixka4vbRfrKunn+uakY4VtbRWccTvMSCG+g8QOFKT4OAOM3e66Cs4D5TLTlHYVTbSccYLWIjJeArO7njJ8m8f6eRP1iLag1f/uXCJozYza4K7KTz6kHEuvylYIJAVi4tRaEhB7gOzlQ5of8OBLaG5xtGc1CSUOBV8ZgIk93DkH8ltliwTncxALl0Mduw2x25yAUrw4AgkjDAQBpHQ+erPb2s6ma8M07wjY2bZpUpVOxYghmQvjZFaTbzhZhES2d6Rgr2+0tTn64m3oiu0DQ19Kj2w954LHevIAaB/SInW45bhLGBlsFuDMCNLgGW7Q8AmnNfsjxcrBsQdEi4G5kWlW9e/F4i0GHCRpZYAZcvxdK9amiWrTlD1dyMR3GVdWsjo+UltCQwIa284/3EO14dykJFXOKS0PsEWZ7p2d24l42Cr//90UuqhKzk08cSF8a5BJwDAFSf72jzwMJdy7XDgplW70uG09NJffaq7PmE65n5NCSlQoEHATfH3I7CO5H2b8K26XXRYX98j09XME1Q9fBK4bbCg/onP3920yvtE5rA8guo4LV4sEmFkLDYHRtHXIv25jUOBrCLlYnepx1JVyG4xQmEC0wR4xOkBmBuzGxt9LhbeeLNvi4njjejGz7rvjzDz2VEr4xorso46OBMekmOgp4BL2Py2uVoan2JkN9SQ7DHlM+3k8Qzn1s+pAYCb3+Gid7PldeE6S4PI/mT58sv+sxpOpRxbjHjTLTYv7vh3Rmhg8WRfIBrRg/cWEFtSE+3qvkrHCXZ8M8I4+Kx1NdtX8gqz0Sbp+2iDsm6lbsE8Y3BXOcZG/fCG5OrtkHeQQ9suuf/Ud4tyxx6g021JgSHW2UIpSZCElf2KGv+ARy66i7BCPu9m7LQ+y
 ocETQNxF
 iEwevLfGSIGIGzikIVbQysPOYJh41hW+OsZffkxaZTkgnDMrk/b/H6jZEnJYGpPOFulS1dgSgfuO9Bjygm4PGjVxq658W255W+nZpte4Bugg0E1J6lfW1P8lmpoy8B0WeKbE2Qct/haTJnVmyivxhLfBii/UiBGUOJ3wNyV6JSUSrCr5mNWzDIw2tEaw1qYGlaK4xqSSYiMQwVyur8tmNdCTXNBA9HqDT1+va3Lp0ib4gRBjVgOx238BZqRZ/EUR5y6ZqBaSpfkD/E+/H/8eUm2OcwhmGXnC9QnQhO7Trhvcxb3PiNptU8Bv63zgNgUgsOs8EodQ6vvqE1qzCOXe6JsqKh87uqK/2+t99KkCvhZ+LnUdPQ/CklBJniLFa2dhRIMhkUD5w1wHKIQsRuea1woiczDU7sc9QBV/aEITqd8gQJhCL2qZlwkI33g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  
>  #include <linux/fs.h> /* only for vma_is_dax() */
>  #include <linux/kobject.h>
> @@ -296,6 +297,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>  				       enum tva_type type,
>  				       unsigned long orders)
>  {
> +	/* The eBPF-specified orders overrides which order is selected. */
> +	orders &= bpf_mthp_choose(vma->vm_mm, orders);
> +	if (!orders)
> +		return 0;
> +

There was some discussion around this in the past: where should we hook into
(e.g., deferred shrinker?), which information should we provide to the hook
(e.g., vma properties?).

We concluded mostly to "we don't know". I know that Rik van Riel wanted to look
into doing this properly, but seems like he got distracted :)

I assume there will be a lwn.net article covering the "BPF in MM" session we had
at LSF/MM just this week.

Conclusion: ABI stability is a headake.

The simplistic approach of deciding an order for the whole MM is very likely not
what we want.

-- 
Cheers,

David

