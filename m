Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFF9CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ABB6B0093; Thu,  1 Oct 2026 09:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C126B0095; Thu,  1 Oct 2026 09:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EE36B0096; Thu,  1 Oct 2026 09:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9C016B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:18:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 542FE1C281F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:47 +0000 (UTC)
X-FDA: 85274112294.13.19D3C5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD8424000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYZ5V1Ya;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5FsYadTtnevApWrGozFMTCLK+XsLP/b9oyt3tDNxBs=;
	b=enqFepUf8I+5B/0SZPhUsb/Zm0Co7teHpQndqz3A2J40Vq1fBIiRKtVs78+irD85g+wLd7
	304LSlrqr1oPDRXKj73vmQy2UscXqo5l/HVtolfQf5R5P8cygNgwvzKGPty20hwmlXW7E5
	3f3CQXipmbjFfool1BUCNaX92mKoGpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860725;
	b=5OHBG+VxzqmZipnmG3lsPWz0vg9ADf1PuYZ7of/iOyfYS8+7dHfH9Ya9NlCnjwEFcdd8So
	gR6jwXOo+dEooETdDrDnngTO6mkYjNoAisa95j0HO76KD1HMyKP/udfC3HqPPR++waEa0g
	lK7u2t1w6v1TflanHeY2xg9nplUR0lQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYZ5V1Ya;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F0F260A5F;
	Thu,  1 Oct 2026 13:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711FC1F00899;
	Thu,  1 Oct 2026 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860725;
	bh=y5FsYadTtnevApWrGozFMTCLK+XsLP/b9oyt3tDNxBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NYZ5V1YapvkYfNNJp4VxDViXGOkXhBFNt8QYzzRT1T5mqGlsusa6OgFa8yKSE8Ekz
	 3pTypRgwhn57ayHVfRoRP3LRNYDJKio0rATAiAaoCUM8qDRCw7ykuW381/ZH3JrZ09
	 zgWdlkJaCedGI3xW/klWef7r1dI2LurUhyjZJRUm0P4hFkVvNYfvZcqMp1BE4RNPaa
	 YKiKkwHj2cfy0IRz2JxeB/WvZBJtUtgA1DhhwDmWEc0Jjwu59X5sFYfloyCSKG4d0N
	 NO65C2HuYKIl+zzE4Av0unlFf/buMEnJ5rnSNZ3O/pBaG3O8afWYJGa7eeKC0gv6Qd
	 B2AyeNUlAyBEA==
Message-ID: <3ff84555-4000-4fd6-afe9-533e128064ed@kernel.org>
Date: Thu, 1 Oct 2026 15:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/hugetlb_cgroup: add trailing #endif comment for
 include guard
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261001123747.634845-1-lienze@kylinos.cn>
 <20261001123747.634845-2-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261001123747.634845-2-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD8424000D
X-Stat-Signature: jr7bidkpijbdnxd7qkddw131s9or66ed
X-HE-Tag: 1790860725-51455
X-HE-Meta: U2FsdGVkX1+Iol9A07SvGdEPKMiri6Z3exPeG21ITiQQmh5Jn/dd1nF2dgJvZdSLcd4YlSXndT9FU/8JYS4lqGiHp55Wfj97Sn5VW4WcfN5fp6xRb/dPgcSsmY/6D/N70O5my+l/LHhUAxq4KUDrwyDt9eYLi5cvX4q80morCun90kzMMmY4WgYHB1tCmS0R1/qHFQQOc1ZafmClP+mDNnSyG7cfPvqIC0wczoGfdbgx4DSCDvKXe9PspzNj7jvWWW2vJkUb2EGiDAgsOfw9//7BH4cDS5RFyGjr3p8b3EpIxIZA9oXCmMZ3nw2NMjbFXWWJrc0YWm5sAJgk8no+OAq2bcqmwpnbZ2m8mSnxdOULexXApZqfVbvB4woNYXo4doVIaJ1QH8OfGL08AClzP5dLd/tH23kg5a0VepPHWIvLSx2tZBqa8Rs6MfzOhy+BYP+GRdciU192WVtyRIJ34Fso08l+owbTtD9yBpPfJzpIsnVBQS8uBDvG0SjYEkh+atRSPQJ8V1vrbZh5ussbcBcS6SjTYoDxLZ/QYpyVaXakkmDmHKV8U/JilnkL9JRN1ke07FSXLrt5VMQVgilmN9xekaoXGAEDmVw/oPXovc5ojtf7Y6jU88dMvZwyR/ZZR+NPblpZ4BJ8uk4ktyuwtsqigwu+eFnYAFTAbUae+J7BS+/gGDEXTn6fGvvaUABx8oKIctfVwqI6WJvdW9iGmIBNxggBV0KNPk7NLLAg4g9nBoamub+MMTGzWaCjFtgxuKzKD2/Gsxpc65Y2ClVK0W849JGwN/XltSgfqXxu14Ih3JF9QvM3m5+o8Zo2WceJJy8ksauSLJqmisCixvGXqEm9rVVUcmlXlytINoOK2bl6bWAWQClwbs3QHhFvh7WkupMYPDE3jL1JLUU+ry/fbuXsyc4vWCDBGlxcX/nx0NBveZQG/rRlahUVCFD2SPfJqEkPy4ROQXOVner+52v
 y6jZNI+v
 NRlfG/+d0bmtoTnOP3gxaUy/zkraEHpRqd6E/nK2cp784kYs+Zrix79AALGE+xsEb8f+rp53UAB+HelUhinDVo3i4kREIEDlUrn82pwn+uNO+Rm0/1JBtoSEjn/l7HzV2KBqt40ezGcAJOsWqKOzCV7VWXeTtKFAtgk9JtSl2R8PoaVWwFVUs7cP2Iuxaj4cGj3PpVYxnYmbUCdM1qR07x9SiTRHzZY0WQOmPb3STVswm8eiKa5GsC4PYOyEiiSUc29Nvo9om/ldoRkFQBDjSXd1Ja8Eg9uif2UKVyQTBFooW3M6ZwghN/WMI1tsz+jlXKct8u6NDH4cQWVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 14:37, Enze Li wrote:
> The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
> is left without a comment.  Add the macro name to the comment for
> consistency and easier navigation.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  include/linux/hugetlb_cgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index 16d72c8c71f6..b4e0958eabf3 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -268,4 +268,4 @@ static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
>  }
>  
>  #endif  /* CONFIG_CGROUP_HUGETLB */
> -#endif
> +#endif /* _LINUX_HUGETLB_CGROUP_H */

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

