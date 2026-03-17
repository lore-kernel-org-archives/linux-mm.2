Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B573AFED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0352A6B00A2; Tue, 17 Mar 2026 14:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F284C6B00A3; Tue, 17 Mar 2026 14:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64D46B00A4; Tue, 17 Mar 2026 14:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5E966B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:01:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89A19140238
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:01:07 +0000 (UTC)
X-FDA: 84556321374.16.29544DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA706C0018
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:01:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FmER+cSc;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773770466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3OIe9Tw31hcrafcmjKu9AOMecDPCDvfB0y3op+xPDs=;
	b=rm7zKyosBfxn18O1tC82oeFRzeNPGTJGuESWF7JUpLzJi483tpnGsCqrNn5pUvgy4pXUun
	YTJNf/9oS9ttnlUjxN3H2EeV0ACcOP5sL5Is1+e/MxhG8GB00Mql833UsTAlp1vC9huJgP
	ycDLvIVyDXbiiYxkA77nMZiLJmrLnNs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FmER+cSc;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773770466; a=rsa-sha256;
	cv=none;
	b=CkBLTnRME4RbjP55KvTflRJnBzeiIC3LYI/N4l+XUyITvAseFRAaMvHVh5jQzvKszqWKqS
	RCdcnXYMXHY84KsMufeaIQeNBibNIf83GZOc036VBYVzEQUxlBJyLBFFY7SnINbeKSw+kA
	7pIeT98NL8QFRMYtIJLdKxi3v8o7h8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B40C60133;
	Tue, 17 Mar 2026 18:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FE8C4CEF7;
	Tue, 17 Mar 2026 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773770464;
	bh=CFg2US6vjV2aTZL3y6So8DxUy+nlf5f7+zOMdGWG4Kg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FmER+cSc3BeBQAONJABsMs3PW893hGhqNg9jlYr4B3Nd29slzBhzw9iqnJhN8rhiC
	 AeWELEG238AaH35Tl1wTpWHR5tclbTt1RQfdhvDS3MNXjouYTHMG17+pV5sTGt/fX+
	 esIKA/qnLn7pWRrQANyAZrL0Wn7mrv4UCdxR4hgk=
Date: Tue, 17 Mar 2026 11:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-Id: <20260317110104.8bfa06e7a88ae6d26bf9c33a@linux-foundation.org>
In-Reply-To: <13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
References: <20260316140122.339697-1-ljs@kernel.org>
	<13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oaqgjm7qupz9wz3bktnzt7e4wijpyzhz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EA706C0018
X-HE-Tag: 1773770465-374717
X-HE-Meta: U2FsdGVkX18l2ezfoKCiWidOwiN9AL7rB/JWe2NP0Ce1bvRylv8y/Pczzyt3fdt7fo7KWwLNEFpvqh4fg3AEg3G+bbIILftUghTV7zIGSoVYS/rEVNcVA0ViAwBl2OpjaO1LYuW9bopfw52NFJ1BMIXbhoIst/qN6ZtVix5giP/z+MGMvbDqx/wkAdMFPGFviwSqQbGso2sToSL3ISPWAA92I9TaoNHdHfC6aQyeyV3PcYuIVCOFIszbX24Sn1TWOSghH0PG8RLEFAsfqSCGKZcozxJrYcbdLXWeaFfMQdXIERndBJScETFkV8VUh5d42MoyvFuig7NxZ681NK3Zysfi3Dv0qZ4LzV+xKlVZrgP1eICkkM01D33w4gnEze04uZfpHca+qj9Xmj7UXQhmkCj7UTNzH+sZzyLkn+oJfg5LtBR0hlnJAd54rZ+AX8QFNAvKzXbBviKBjV2SDR1Agi4zrnB/vvV2fh2eyzl/1h3qz42DA+5TYtUPCt31sVqgcVeepr0ski1/SjGEBYVSTuoE3OuK5rryQq+qknYVxFPrBdg5ro74nu29p8xotjTWprUnfMHF1pBABUyZmkpvwg+RIqPdjcQNvcB5J4Fd5mNK5EFqa9sOwbxPxFF+u+jN7XC3leu8e2F+rVfAm/2A6Y1PaHJfnlsa4KA4PLj29OVLtD2MStzTv/2oIUIz4PLZwCNQtHBlnkKpFMIwipY4iGK89jtMMD2ZxSg6ta/OCwSff90QCPg+a5qFDzlVtB9OsM2U9wZA0hKNeuWvE95P1aDu16eZxw8NyVh/ZGFuuYkRWIap7Ukdxx/+tU6GGYFFBcvWqIzEyTH0oUaTGgVCTXfRjF9zcUhN1rk86NzEJkVX7WRAF2ThLhKNC5qBIhkfc3CaEjZMJo5u4MhZvKVriQaN1FmW2baDZLuSP0feBFRUwZlQY8GhJ893iS3wnZiQ6YnAy1byo1h7W479BAo
 1eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 12:59:35 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Hi Andrew,
> 
> Please apply the fix-patch enclosed to add a dcache flush which was also
> missing here.
> 
> ...
>

That was a lot of sleuthing.

> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -950,6 +950,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
>  		dlen = PAGE_SIZE;
>  		kunmap_local(dst);
> +		flush_dcache_folio(folio);
>  	} else {
>  		sg_init_table(&output, 1);
>  		sg_set_folio(&output, folio, PAGE_SIZE, 0);

Which will all be lost when I squash the patch, unless someone follows
the Link: which I add to the footer when squashing.

How about I copy your sleuthing into the base patch changelog to
capture the reasoning for the flush_dcache_folio()'s presence?

