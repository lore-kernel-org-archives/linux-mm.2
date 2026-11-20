Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA09A606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wz5aLeHU
Received: by kanga.kvack.org (Postfix)
	id F21506B05B2; Fri, 20 Nov 2026 11:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2026B05B8; Fri, 20 Nov 2026 11:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F776B05B9; Fri, 20 Nov 2026 11:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFF7D6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:21:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E5BB40F8B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:21:15 +0000 (UTC)
X-FDA: 85456012110.19.EC95DD5
Received: from mail-pi2-f9.google.com (mail-pi2-f9.google.com [74.125.227.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C36A1C0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:21:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wz5aLeHU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sdf.kernel@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=sdf.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795191673;
	b=CnzxjZe4dxbjlLQoQcxRLGetgPOAuPiHKKC8AYiduF3GJov02ZB2sWm2oxKAihewaKMBzo
	jVjN+hARC8P4YCir5msdN3XQskaM/HPdotoiZv5AV6x6OcGl+rc67DQ3r+NptgfrvgP9I+
	f16ePrPwH5PD/D1s4PjcvHnq47wqdxw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DlHp18CPjbRy2dBjwYmV0o13g/8Est+vNGExs52wGVI=;
	b=QO+uJ4bL6KygJkkZjYq5qUhauXLW4kQcFicZWgl/1SBPfuj7BYSc9MjbsUyharLyHBS19z
	fI+ViVWL4+t8LegPodV2J36EeFpZIA/yBjRXwjn+zHmf9QQHIu2pGkhwoUOHREU5JfCMUR
	zhV19Q+a6qfSN0EgYzrLbdZ3HZQ16T4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wz5aLeHU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sdf.kernel@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=sdf.kernel@gmail.com
Received: by mail-pi2-f9.google.com with SMTP id 41be03b00d2f7-cdd9779aac8so181910a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191672; x=1795796472; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DlHp18CPjbRy2dBjwYmV0o13g/8Est+vNGExs52wGVI=;
        b=Wz5aLeHUo4+ALVoQQsOjsGWOlYvYylq8vke0C8IsGSD+QY2SBVCIKV6h42WxKMAwHI
         ZQ91FtASyorhj9NIMug52RPibvMluLevBpNV8r6mkjrnvRAKsYNwNSZgxPgbg173Dtuo
         PZ34uq0xJDTiWCwnV59sLuPFWDGj1FMiScCQMv65xeNlgzbc2hbIbXNKFepm3R6r7SUs
         OFPY9eSJGMLO+l1A6mE5cx5cXziitlay3ZUgCAzRBoHs/inH8phJI8LES4RDYZE8LQCP
         tadnIgMRWbdRQn5qH7T7qkUbxHk/Q6n80Lmuq5xy0JCz40crs4NxltDCzGAvGAehftmz
         pdow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191672; x=1795796472;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DlHp18CPjbRy2dBjwYmV0o13g/8Est+vNGExs52wGVI=;
        b=qHdmw/1IT4f8omnaYs/qp+rv1otXzA0vD0nIy+aCKKAX+4CpC/3tJj/9AvatuO3H6V
         kzX7kwLGgHBj1DqW1d6TVQcMlnjaBZQujDA9Lb+OY1sSrnMLtasIod5kdD0hp9Q6VLwv
         Td+u8YkwBZb2NGn2yr6eHpJNHf18wwuJPhEHyXCMXIpPuniFHTKCHOM17KjZWS7Qj0lS
         Fahmu0jLNBSUhT4sJ5KFpUJFAJOtclH7FT2snU4FACpJlHpUNCEOiFu23EEug+EOteG8
         8I3UhZ3WttoAqDApZt9oNrC2Z2VnnJRqly32ZoS4vCAUdbNqS0iXRlgJDI8V0WMnuaDr
         onwg==
X-Forwarded-Encrypted: i=1; AL+hErH5ERdw/SEPgKszXuIrW/Cqed5AwTNCqSW1Ymv1bBDUThZczCZtqxTrIsOgXSrxUnyVfQedML+Akg==@kvack.org
X-Gm-Message-State: APuU4Z92bkB2aX93QaBV6w3YN4v7sCShry+FrmTDj11YSGdnbk/CN/Z0
	saAAl92ZtilffrKHKDT097AVpB2oOcKNzC0LTqgwF8sPFs6O/KMqueLQ
X-Gm-Gg: AZFdTZchb+SARbpIuWUGtseAopQdkrAIbqCdpZAvQ57z3fBScDQLQtvQhw34dAJ9oi/
	5QX1XyGT/pjFol6c+TGwjVjo+u6hBFFkUN2Wn1oi7Ub76+xOalS28Cqlb6M8GCfWD2nz+kaBPSE
	SL7nkWDz7RZLmkuRWvBKeGdsKkUuSuX4i4oehi1in6mFt3Jp/1kYB7jPdXSJO5I9Ejq4g99Wazl
	GKFHISvykBNUpJkR9hS10Jqi9j3AmI6mFjbixFr+Ce/z1ncvzkXjpuqxFTD8ltPSLAbQ9o1Rvgv
	pRFprNdZb8DwS72g7xetW7rlpZ4qltnnkAnzsJiCp9p3B/GuLC6LNBuGo14lGKV9oez1AyvG91B
	Uvqq+Feid9euTL2XYMJtlWUatN5q3d1CUbuT/sbrKZOmThjyoZ8w6kRK4zQiB2Ko4P2+15c20ec
	9BDv8ko/d3IQ63V+Nhf445SgRM9Knf/IXnDEVcxKpgA7lL0E+XJ3Nbev3hZeveMIC9hRONx53iL
	mBsEAxNgQ7McbB37w+Vf94rAmKDdFZhamKG4YGJL5TqFDpyFfRBwQyG4taACLt0B18JCY1LsADm
	Iri34j0WEwqOcR4hHyyoROA=
X-Received: by 2002:a05:6a00:1c97:b0:8b5:7fc8:866f with SMTP id d2e1a72fcca58-8c87d32b004mr3231608b3a.44.1795191671804;
        Fri, 20 Nov 2026 08:21:11 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:60::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e45e32sm1696071b3a.24.2026.11.20.08.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 08:21:11 -0800 (PST)
Date: Fri, 20 Nov 2026 08:21:05 -0800
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Rik van Riel <riel@surriel.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
Message-ID: <awBy7PoxdEMEGWyW@devvm16445.scu0.facebook.com>
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 6C36A1C0009
X-Stat-Signature: 6znnn7nsuwwwri8td8poqw96nibw67jf
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795191673-370337
X-HE-Meta: U2FsdGVkX18UVPWz5tFdNKKajzRY95GAlJG+y89fpR6yWQ7TM3nJFkEmQ7XAhuhTJWszFfV+ZU7cr5VHpEn6eWlNWiXqQQg8PUrys3GqkmvtzXv8sxlPBHmlRtOdCLh/y1FIEbasQbX8jqhH9R+kX3Raudj/zghLbUafHL3n69z68gSpwOYSBLGOKIu1UaxNl3M1FZaE26bbAOYI3gGFhj/d+TrsJwDFo+1X+TRh5T+ykbiN4yShihsBlDhILIF1/kA9JIx8CgaaIe/Ld1ildyMq3GAO8ipYaxzTA003XBZh1ZcvNPqJKG3cb83+NcfoH8tDx6cjtnDS15Fip0yRj5imZzL3ncaDeV+q2sYeSjAiDI9kMI3rEoXp/bYcIEDEGNpNhRBaXieMrGnSJLaZYnMirbN9O9jkGIk/Ov/PXk/iYRlt3YtuVGtWFKogwmJeHbt6a2L3B42ca+ijLavXlbLLE/7tcuWUBMQR9RqT/f31GItVWQ+RDvrvV81Qh+bUV9iJkIbWIjm2hNt9SdL1WyeySOPLaibX+z0hSgpRFa7VZHxROfZtbgX4eb9Vrd0turxK+5iq81gfIGFkjbodiEdvr8MJYXi4mBoXJ+B70qJcizVIvOoT1nX1zJ8pSEHN2ud2Nb6sZh804ES9/g5ERdLO9/QT6r34WvOfirk15QvSmbfNO4TUfUKAqpLiVfz/Xig9yOpa9AytrWwmrXEn+daZ4oE3Kh69dicIgQh5P90Yeu6u7x6ApzdOQTC/NCVFcz8iU4GSO+/pPdEKgNcm6tH07LjIzXO1ai1JCIoyTw69HKHJcZDpd6cNL8iUXB6sp9uXN6HDZpqKdlbi6ac+BYX/ArJeUMTzjkkJC8UpKBIf94hysfSlBz1BurVwKqsuZZy8bofJmx9SP7Hy58WltJxDe0fXbmZHNssH2U07l4jgdMulGX587QLJg8+1g+Vzy49/2J5e0X/JJzmUQM+
 p6O4BSjH
 dOhepo8TnmPlgVGIbJsDhj/QEASJbKgwntM0Lk061Plq6LBU9kJSjYLaOCNLFvZncKBKXY0Ih5RvrVmRhVI6YDGn3eYmxGI8hDz2ERjQnkwo5s/OSnK1Sj1eviRRcd0nl3kFWeUY1ULMP7q6ktmuOAVGXKuOcE7fbpByYhVTcFmZ+XOX9TCt7riRmc8qKC7B6mpugXvwyiHxADBFotSCv4r0ixsFhTL+VdpJWKl4CMpZLXKB0H/iRT0zT4L88KoxoQWTvDDinYEE99Plk8K3O7Wt8wN2WovEaz5NsJYSxjqjpht4+WPoC0xXmbgFYDOzmMdjWBzIxh7DpuFNz/wFGzJNmcUFdzhLGhXsHW4ARZuMOuUM2xkYVgE/3OqszB+kbOx0SVbb0fshwH5f9YFLYqr+wQRf8rusZSLXoq2n9OHsd56MLHMBGjvuOHTzNftcRgdFe5DTuoGLcQmr3PbuA38nL8Q68N7RQIKsgBlShsfluD0BWVTa8eZSutPfcxvpl+YZKa6aMeMqBhXlEnX7dQE//589BNDhcfwVrBTe3hkEbEHymgkour0Z5LDRYgkMxAia27QHjsd/28Cfr7ju2q+F2T37KbII4JoKob114P9TurORkEYpt23McL+ZUEBRyE+ubyY33gA5l0TDAhk6tkqLpp4XgAP+GJdOYdPSc0HaDc48RoGHu83iIuC3SshERqiA2E9k3iKk3LBUNKwb8BYNw9w03vDQ1NQ3OzQ0brFwxB8CIZTYPHo5e2Vf7ixSuRb2R/wiGnb1nPmQpfQQ+jnUwJ9GZ1dhh2uOCxQ9+JFZR+R4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18, David Hildenbrand (Arm) wrote:
> Various networking features copy frag references of an skb, for example
> when unsharing a cloned skb (AF_PACKET trimming a clone), when copying an
> skb (nft dup) or when building NFQUEUE messages. This is an effective
> way for multiplying folio references held by an skb, allowing for
> exceeding folio refcount limits.
> 
> This is not specific to large pagecache folios, but with them it is a
> lot easier to reach the refcount limit, as page table mappings can cheaply
> create many references.
> 
> Let's introduce skb_frag_try_ref() and skb_frags_try_ref(), which use
> try_get_page(), and use them in pskb_expand_head(), __pskb_copy_fclone(),
> skb_zerocopy() and pskb_carve_inside_*(). All of these can already fail,
> and their callers handle that.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/skbuff_ref.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/core/skbuff.c          | 35 +++++++++++++++++++-----------
>  2 files changed, 76 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
> index b6f6da556ee90..560ddc863bbec 100644
> --- a/include/linux/skbuff_ref.h
> +++ b/include/linux/skbuff_ref.h
> @@ -44,6 +44,33 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
>  		       skb->pp_recycle);
>  }
>  
> +/**
> + * skb_frag_try_ref - try to acquire a reference on a paged fragment of an skb
> + * @skb: the buffer
> + * @f: the fragment offset
> + *
> + * Like skb_frag_ref(), but acquires non-page_pool page references using
> + * try_get_page(), refusing additional references to a page whose refcount is
> + * at its limit.
> + *
> + * Return: True if a reference was acquired, otherwise false.
> + */
> +static __always_inline __must_check bool skb_frag_try_ref(struct sk_buff *skb,
> +							  int f)
> +{
> +	netmem_ref netmem = skb_frag_netmem(&skb_shinfo(skb)->frags[f]);
> +
> +#ifdef CONFIG_PAGE_POOL
> +	if (skb->pp_recycle && napi_pp_get_page(netmem))
> +		return true;
> +#endif
> +	if (netmem_is_net_iov(netmem)) {
> +		net_iov_inc_ref(netmem_to_net_iov(netmem));
> +		return true;
> +	}
> +	return try_get_page(netmem_to_page(netmem));
> +}

I don't see you removing original skb_frag_ref implementations after
the conversion, any specific reason? Do we still have any skb_frag_ref
callers left? Maybe at least you can make skb_frag_ref do 'return
(void)skb_frag_try_ref' to avoid duplicate code?

(optional) Also, an easier way to migrate might be to make the existing
skb_frag_ref return bool, convert everything, and then add __must_check.

