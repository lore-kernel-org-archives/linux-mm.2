Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73604CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3DC8E0010; Wed, 17 Sep 2025 03:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB3E8E0001; Wed, 17 Sep 2025 03:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9DE8E0010; Wed, 17 Sep 2025 03:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9908D8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:25:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DBD311A1C4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:25:19 +0000 (UTC)
X-FDA: 83897906358.08.92CDFB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB90040006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:25:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TTrZ8pul;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758093916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxO4as0Q5XxTHNvaMG0p9FD9iYcKS+h7Cf1+/OhamkI=;
	b=41StAHpp2KrR+3DlfY9uLPnBPb+8RZ2RIDPaQUOLQWB2SIYAJkY0kAY7EqnjbQJNdReUum
	fz2nANcx67JC6Wqi/GLFNmoqhIkb3DZXWel8aFeU/zASaDtXmdLlk2M4ZiHhWsyXYuP/RI
	1JcYmw5ACk+s6+hqT9gVmdZh9iNSsGM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TTrZ8pul;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758093916; a=rsa-sha256;
	cv=none;
	b=t35zIg/breWUfOuy0hK00q3RttXJKZX2WyiarNv8FoVRcoG322ZSn8BOGXRSp2i/0nZ3h/
	+8bl7JotGKCpe2gDDVGjg+lL8iNcW1lT0RRS/iI12VHBnfGaDHMaAF8e1VG2G4hVbhVRYB
	l4rU/QyerliyxqFWGJnzWqKWfhDdMf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758093914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dxO4as0Q5XxTHNvaMG0p9FD9iYcKS+h7Cf1+/OhamkI=;
	b=TTrZ8pul1fq0AfyJTB69hzXWb8wwqgpOypKf1qs3PnGCmyQ7JL2iVN5osR0LZaQUY6dnml
	BGmt/bltagzOWaqaiMduLnNh/kxjjqD9WPdCEtIQWxtHS5FwyCoa4OAgC0waHApp8HCaJi
	Dox98hoPPplyAt7E/gHNw9tzAuIi0Kk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-gsFbKxbgOHe3VtxgS82FlA-1; Wed, 17 Sep 2025 03:25:13 -0400
X-MC-Unique: gsFbKxbgOHe3VtxgS82FlA-1
X-Mimecast-MFC-AGG-ID: gsFbKxbgOHe3VtxgS82FlA_1758093912
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so622529f8f.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758093912; x=1758698712;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxO4as0Q5XxTHNvaMG0p9FD9iYcKS+h7Cf1+/OhamkI=;
        b=UJ7EPP5M4RF3rjy3gvtzkk8yIdYIF+eHwzy1754yI5WEEiyT5FXaaD7C6Eyg8GieFB
         dCqdzz4yoLQLXUlqDi7ap7H7nwwobYdNSm4Y6deFQjVvs+Kl9w1hTnZYUDx9Gwsgnk+7
         90kp+ADbs72YS/LB+yDr9hKrITQ5N/KlQyo9onGF00RBdMrcB4GRbJ2wm+Gjxiv/RIuv
         s/sR0j84xHO+GbCeY1yZcZXupmvATQoietCRS2en39ngsDlR7ZlsVYJYsYKUCR63yiNb
         RThR2fTHmuREISk9+1NS0JcTozMEMiakYvQMJHUtj96BH72yGnqvkQ5ODDj/VMfpa8Vn
         b8ug==
X-Forwarded-Encrypted: i=1; AJvYcCUPIfDcLgqgg0anti4xnn1kLTVscvhKNZJV9OpBrcg0lOK+N0Z8k7Joy8SsWgoYK4KEbTR8y+pz+A==@kvack.org
X-Gm-Message-State: AOJu0YxiqDF1k/9RfrzstPf4hV03qmCcPmW4MsUk1ORBuyTCPEgPIMYh
	wK82ifTNGupQxv2UJvz3SsJipozzBOUDbNzX26HcJU2nJ9TburtyohElYCypBhWXTk6JogHo12I
	vz0s9IRAUuIQztxk8me+Maa8UvKXXbxHVKcwmNAP1skdqRm2u9sYf
X-Gm-Gg: ASbGncuzHbpu//IQC4woY6S1gpdIrj3t0HJBNrK39Td7SYKth8M3zrsgGKxhXEbXV4Q
	Q6/GUNllS6rrHHIWlPsPaKMCrJd0w2M3cnLNlHw3YpI2t83JnfY/S4BIHJF937Gn5ivN+mXsxi+
	GM6S/VXj2IYIlQUreUKit+p5ajkQ5GlZGnZZgX4lJDs8XZ6hwsbPBImfqHWV+WN/tEg5bWnf9Gw
	QtAV+Mg/ZwmSsTBNjIqH3Sycp+fCOZ5nbMU4b87gk94VwJMWRZcaaWZ934FEP3AFRFQsejeCSCl
	fZcKYRPP/tOQD0nkiVjR3YeQrZf9dsykSOHgKPVR0q5kafM85/4o3rkoBzTY6hpyar93ZITmlGH
	CRgTdOYyiphh+natauM2E2d0oJWt90hs8cQ0amW4xeHSxaWpXNZuMyDr4t2Xih1mn
X-Received: by 2002:a05:6000:4013:b0:3dc:45be:4a7f with SMTP id ffacd0b85a97d-3ecdfa3f966mr872683f8f.57.1758093911910;
        Wed, 17 Sep 2025 00:25:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEHva7vHUul9vtNQdESzjClBi0RsKFeJIXOBVMnY44/FxLP75Brxg4KOfMIxcyqeJlJmK3fQ==
X-Received: by 2002:a05:6000:4013:b0:3dc:45be:4a7f with SMTP id ffacd0b85a97d-3ecdfa3f966mr872646f8f.57.1758093911401;
        Wed, 17 Sep 2025 00:25:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ece1247bb5sm390090f8f.12.2025.09.17.00.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 00:25:10 -0700 (PDT)
Message-ID: <bc87f2a8-7a9c-4416-9106-bdf4b98e40a8@redhat.com>
Date: Wed, 17 Sep 2025 09:25:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V13 2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Conor Dooley <conor@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
 <20250917033703.1695933-3-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917033703.1695933-3-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I_Q4McyC-XNHt5yq3N1Zy5OIp51bWACxyHniiy8augQ_1758093912
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB90040006
X-Stat-Signature: ru75zexacddaybztzf6x6zg7r7mn4uqw
X-HE-Tag: 1758093916-597255
X-HE-Meta: U2FsdGVkX187Pv6Y8/K4nwTytIP99VjWWi6teH4H6CCgP8q8hyK8MWeOq2Fk6jdLpIS5bYoytP94yTWBEmcaUoBI1a3ikoBrl2tbSsAqBFmmbrCOFMFOirtLTbm1T51Kv8VGdN7xg5BBddjt/nk9+Mxafw1Dn+pEwfWQfPtHGyMwd3hGt9taiAbLt/R8f195uwCNdT5TQlJL3jN1GesRsuFVRsbrJcdwGIgKQ9ZzyR642CKxVQdnhvvtE+b8ZzvASnty3tsdPfoQ+ZyApdhy38M06OKTo7n/XNPc6JBHSAaY887Ur8jHYNnlxN1QpMlQ+Hod5jTDCPiAo1gMmgAnO0tV2g16Hf9y2hg1/CzNlP0uoTp8DCEi/hCR55Lw6Ray8A+ipQOxaDtFdRunEkIxK92GIJsz91kR+QMcjbvck+AUwCIRW/e+OlTYKqT7JA+VqWYzZpYpjU3xZ6raJHfcO93Sn92t5SojcdRzwIXqywyT43pfWzvvR4SItaQ81bqCYFOv1ue3woBG/9MTC1tQBAF+NDnIwFLfkQ1VZOC3k1kSFkRl8b8xBuI+He3+c6TDmB34a6m2OF0gXdMIMSDjMCdZ0jFbVpUkAJbQN7zzQkJmwibpTpC3ox6VxF8KugM1hV5oNFbtIyQOnPjJMq+c9WkVJH6Lydal7N2P+P/hNCjKn4UDHElpVyCMya5UCOUqoDIYOkzbgxAlPLDNPExe4gEDfj2aFgCE4n+tUN6+b8LNTY+n3KlQLB9MGMwo9sSqIY34AGbJo6pdrJvggczM8uuKvwrqorE2G0TIPjYqbcI18QUnhaU2Dbn/HEXrT6EtJ3hZI74Is6P+REQQ0fDD6xtS24r+cAvFmsCt1/s5KZwPSazZJDDVNCXJreSDt4wUdDi/S0YLc/F+S8ch9sasbbULbu+DXqPMKHNAhQ06KdcNHz84J64p8TblQCkjKAa9/cm/QtCK2JckkgoSN65
 CnvSIPJc
 suL7g5b2CeKgPEumLK3TQzdQpSwkLue6lrssLZgy7PB04HbEfzgrjnPRQFd4q/RG5oKSPv0PqIqNnx3dR1OMvC43eWNBb1DBAtg0w+vYI591l2S5ZNnTmY1eikkI4TGO1FkqeYro+7LB0EYEya12ymy1t9CS4eWcl9WsnXOge3zOKQBN8jAVGTrZ8OAdFRQvZ506oS2fZ/zRAoykWsLM7OAXmUSzlKdk74V0/17m1Jcjf2aLoEIenwRFkn/UfWkHHsaT+eyCXaAiK7istmkVtJPYEFHn9vDgM6bC0Bu0m5medkO/4YHodQdqQbGcv7O9/xZYc7kPKizVXRL+W2VbSgYbeTyjDsva4bSwPCEUDZXKeHkGlEQ5xKHudV6etEbb7qG8tyhaT1xIyoW5pFChEJyqyfMlUflx9dXzIjUG8xSeXUNGANlJy9W+f3wp2tMEPP59AgpTmbYpEsoX5PQYhjm3xbvHp/x4TiAep8oePY2xGZ6jgN7MiKqvNfV6uunM7HA8vPt4PHE6fTUjisNsAT9GLSMFr6qrjjvMD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 05:36, Chunyan Zhang wrote:
> Some platforms can customize the PTE/PMD entry uffd-wp bit making
> it unavailable even if the architecture provides the resource.
> This patch adds a macro API that allows architectures to define their
> specific implementations to check if the uffd-wp bit is available
> on which device the kernel is running.
> 
> Also this patch is removing "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
> "ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of pgtable_supports_uffd_wp()
> and uffd_supports_wp_marker() checks respectively that default to
> IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) and
> "IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP)"
> if not overridden by the architecture, no change in behavior is expected.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---

[...]

Taking another look.

>   /* mm helpers */
> @@ -415,68 +475,24 @@ static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
>   	return false;
>   }
>   
> -#endif /* CONFIG_USERFAULTFD */
> -
>   static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
>   {
> -	/* Only wr-protect mode uses pte markers */
> -	if (!userfaultfd_wp(vma))
>   		return false;

Isn't this indented one level too deep?

> -
> -	/* File-based uffd-wp always need markers */
> -	if (!vma_is_anonymous(vma))
> -		return true;
> -
> -	/*
> -	 * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
> -	 * enabled (to apply markers on zero pages).
> -	 */
> -	return userfaultfd_wp_unpopulated(vma);
>   }
>   
>   static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
>   {
> -#ifdef CONFIG_PTE_MARKER_UFFD_WP
> -	return is_pte_marker_entry(entry) &&
> -	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
> -#else
> -	return false;
> -#endif
> +		return false;

Same here.

>   }
>   
>   static inline bool pte_marker_uffd_wp(pte_t pte)
>   {
> -#ifdef CONFIG_PTE_MARKER_UFFD_WP
> -	swp_entry_t entry;
> -
> -	if (!is_swap_pte(pte))
>   		return false;

Same here.

> -
> -	entry = pte_to_swp_entry(pte);
> -
> -	return pte_marker_entry_uffd_wp(entry);
> -#else
> -	return false;
> -#endif
>   }


-- 
Cheers

David / dhildenb


