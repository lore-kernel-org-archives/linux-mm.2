Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0128DC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 18:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872DC8E0002; Sat,  9 Aug 2025 14:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823DB8E0001; Sat,  9 Aug 2025 14:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713148E0002; Sat,  9 Aug 2025 14:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3D08E0001
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:45:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90DB5580AA
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:45:19 +0000 (UTC)
X-FDA: 83758096758.17.EA5B060
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F8EC1A0005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:45:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijhIxJv1;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754765117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eR8zOZ3z2WcWE6RFK1IoXRDArEFQfISp1rsngDDWJHA=;
	b=PuZmE8ymgF88kQ7oh/T8ZVzlkeZmorIK0n6mqW+yF5L3el2KDakDT4elfbfjVI4JBBzZTQ
	uMbthvz89u/93FMXb1p3Vfwh+Jj4PkejiK8T9eeqhvHVmsGSJkOwN4WHQEQDjFoYkxBEAo
	yn5buwPywDv4Eq+FLa8sc+wFUuqTe8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754765117; a=rsa-sha256;
	cv=none;
	b=k/A5FE4IyxA9EMM6HS/A8Tov70a6Z3ewWQii0sC42S2W+IwIVjA1sU7tlzbD4h5CKArhwp
	tI6qXSAk0shpFxlnlGAo8gdwmM2B7p83JiXzoEu/AXVgyt6uWmuIdSORQjxLfv8OjCAxsQ
	Ujzt/5bXSHYA/HsMWf2d+KGf4dF4L88=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijhIxJv1;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-acb5ec407b1so447865666b.1
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 11:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754765116; x=1755369916; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eR8zOZ3z2WcWE6RFK1IoXRDArEFQfISp1rsngDDWJHA=;
        b=ijhIxJv1Pkbrz1KlcA0AeBhC7/NFz5D2o7A4+gnhI/owsgU2liwIuarAc5EFuDeYQR
         J6ZviX8JueB7OKztsXa1HF3nVcNA3Drmk548gObQoXyuJCo8Kdh5c3PzHrBMD8LcnPFu
         kl5rhg7sjPVGHLMbXIdpkkLyfh7uQLYKmf3NgKsAFJLk416KqxfZ0alVhal5OMtJd2tk
         8MjcGUlhWqDgV6X8i9IqcSERw8HGztRlqZyGaOUaKRWTd6vrPcaF4ux4H1CVC1a6oQsc
         jC5cMH80AVyan1gfliVFW1rq4z10UH4oC9TYHUu/UtH8vQ1gv6DWQ//txX+r0ArGnL9l
         rGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754765116; x=1755369916;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eR8zOZ3z2WcWE6RFK1IoXRDArEFQfISp1rsngDDWJHA=;
        b=OibRpf1PHCIearXZWY3mdPC6r72Whj+76c+ciJMhNbX3d9+uktCJn4NBsJJ7bCNrby
         UBvqZu37OBbNfB+k73SieWuWraAZG6mfrEYZuBoMmNwjCTD/0FDq2PcJh++4q9PgEv4M
         RGamoOQ2IXL2vnel5zpKRrMy7bMdnJB5KomDRQbniEy6r/JJQ1TYMBf9dHNwlNKv6Exn
         O5iBae9f5P53XbDCR83Q0UMvh8um634a3Gw8B8ANaGCu6IHWwEDXq6vTkyHuLyoDS6uG
         M79GTAk0cxqCJ/U9fXP5FMuuHWGiabo4TJWMxXB+WaS9Kje2DnTKhbIkOh+tWxXymrWG
         BFCQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9ucGUii3saVxicC5QAJxpmAWcWn8zeHfS0MdkA7hQ+Oi6GC3QwY2Ld0HI2X+WGDn5kurgneYFqg==@kvack.org
X-Gm-Message-State: AOJu0YxAGJ4X2Q9jUE6YdsnUKueJLTClB02KXhHNLT6e6GAHGfiLgwwY
	Emcqk3JF8SS4h4FJGLxShBKB1IvJ6FkEf/EOYcQ1E0rbE4NH0uihjf/E
X-Gm-Gg: ASbGnculH4NNSijt3RAucSZmoHgNkc53NIo/D5mUTgDX7j6k5FbanXoVVobRh594IxU
	a2gJbeAP+6G3KwSWeuu4lsLNLid5r748M4fybziaqML68xpaDeYxtz+ASdrUkn+ujDiAmq5N7rS
	I2RCDgRpjVERH1ipflluvH0sR3OWzuxi9TBS3tp3WuYRUrJBCM4D+eRvJdYWjIgmctgEvf39yeW
	JygluAhwRowQjsPy4JxlePsikyODxkMI1S2uS6/uyQG2WLuk4W2G9vlxms0Sqiy1MPkiB3M3uEs
	PT+bNzTJXVBUAI/J+TzP2w3ZFzhRG8ETOLDDkG3ZrwIzIAQmdUnRJRUYU+bcRmV8AG1Px43BKRZ
	5C6/vQKzjQRG3pWQzyE2mNw==
X-Google-Smtp-Source: AGHT+IGSLKkdoXK2TOxZXhsboglDsLFIiyNrDvo4bkRRZ/lXamgG7y7rXWOoHMoxfnH/vEriZPA3Jw==
X-Received: by 2002:a17:907:3c84:b0:ae3:bf5f:ca20 with SMTP id a640c23a62f3a-af9c640ed5amr594511466b.8.1754765115775;
        Sat, 09 Aug 2025 11:45:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a21c076sm1676437966b.102.2025.08.09.11.45.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Aug 2025 11:45:15 -0700 (PDT)
Date: Sat, 9 Aug 2025 18:45:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
Message-ID: <20250809184515.sd2qrwrae4a5bv4r@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F8EC1A0005
X-Stat-Signature: t5ias5xetgbhmuit5jpznbhyubpoc4nx
X-Rspam-User: 
X-HE-Tag: 1754765117-930835
X-HE-Meta: U2FsdGVkX19H/6fInHFCRQ/5a5zKW5pLYdwCaMuESQRfJs55VSFEepcMUpXuosBgUEwp6wdbcSuu8eKEQSKfOMNDAGqb109K47fmUBux3KTEGZhI/IOcieW13gj97TDxtp7fug+2Ec1Bp5SZqTWRW0Sw11OVjZkkR1NTYL54Wk4MMna6TvCsYWWoexDZRFQrqJzdsbkRiZHtMaGOGJCuxKzT0301wE+FVV3rrUaS1ZAK308U+QczVW1kXOvnCf8tncO71aeVPOGvCO7I6CyGMS4t9LLnkrrofr5BqKy7X+TEO92prEYlVc8N7bNeXJv7z6zOzhz1gLp3BRzh/ZWVPreTzSS1io4GkhQzOzJGi1W0+NU9Z1vyqBcTaSTO4ff9lN2olPkZz0r/pBuVm4ag54d3jTBARmoT800CnQ3m9cMcEoJXT075dVl+89lYqOkJNNh2LEIqMwPWhNybIkKmqZZ2mMNa5WxeS6B90934dUqKPm0rHM2nYU/Zhpk9/zM1PGOg6TiMAB/2Wf92xk37wHwP8JF9cUuc7oVD4dCKrDyEMdHEdDkbwm4btUErnq/IQ2T9Nv12w3KRig/o3lQNjz9y+UqRWwnpsi/WQbKJtRGl+FTFew6S60RLoVKBvzIcc3gK73PklGiK82R6tESSLUARTMC5SlqOAa/pldeG0+beO331qKHDQqfdrMgbcIbDF7+VmcnUFjuPLNqp4rQ+OvvMbOQ7D17CF0OppDZfKRcmshnqB2CjTjYn+j6+KIqzVsxQ/8EjZ28g6SmMcMrTuOet3wOc8S+iooQ1YZilQTEUZZCNDDBO7xLhlrHM6bNK0iQDfVzzxdwFBqO8uG95vrXiPPwRVJ8FQavvFH9kzkyqCQ+CDT2ikg7GjEUbS+0XzPfqG3fvHx6F5LfoDwFBVUbjuWnAGL/pg3hOSmc7x9LCGmfY29IKLuucCp7nR/Eja5SInbd+geUXrBwhN5H
 8TSwVvCU
 S81gPl60uW1XPO0ESSL21t3tDY9R+cw3YSEihoAWTFu9lZWQa9AoUtFYEHggoaZaqkMBBVbkU5VlvcQANfBcJvQEQsA3GfAL4y1yL3xxOCp5DR56jkY0RsxEIOXvgx11IsIQtJ5yeWjY7WqtLS1cOLynwNZB1r+LtYJC++m0zCoOAOJaAdpnBCRGFXK47L02hl/BCo/MUgcP3CiMBu3XA1s6VApOaAcrJUtYe0jm1PcdpaPSoVHlT5p/Y4X3DsgsltNLoNR0lybUPTorHqv4PMNg6rZzkldO9eqRSDL895Knx2qaX9cuPjGddNZ04puT3eA+ZqswzJ+MErIovIZyU0K5rW5JC/XMk0VRrQIme0PlxvzkRqHd5LUMECWNcjB07Ny6t8OqDP0RLn2OWv03UhgGP/ECGjghMyiw0Nj1Z/iBFvWjnyHjHovJp4s4eVKjsp2dfoI923MtPOYfOIKI7065nPCWfJYT4/4bVVil24Cmz9DZ/VksQDUkVOi9dyHP4zHECX6RkjxYBmXDPJoYAslGRGGKUiv3tX5XKJHtJPQqAjkxpVwvzWhUcV/TRxfHEc6skdtFNLxNNUgeXqhZoCRz6Rb/itixm6IxFWrV/d52rpsxWSLLYjXkQBpIv2E1u47X9V4zaPFh0WQjimFolN3sR/VZ/sUJytMYLu+iGsNFYtX9wU74kcUu/SWuXsAkapC+CCjozr85nPEQ8OMOG0rLk9nBKllWhyO0owz1Y6F7/mjZa2YdTf7QYnXa1FYDuVY+m8YuQTeGZpCJOa8wQl4dZIJKI6N6hMxqY/CGv8qVVx80r6RyvQQO4yv5OvYDv0LTD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 03:01:42PM -0400, Zi Yan wrote:
>They are useful information for debugging split huge page tests.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

