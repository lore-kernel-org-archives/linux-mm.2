Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20E0C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3126B007B; Thu, 24 Jul 2025 22:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CE06B0088; Thu, 24 Jul 2025 22:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD646B0089; Thu, 24 Jul 2025 22:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAB26B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:47:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E0991A0590
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:47:34 +0000 (UTC)
X-FDA: 83701251228.18.966124D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8C5311C000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:47:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QXu0MYBE;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753411652;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc3hDEGPGsCDebYX51sWpA/bxBMOB24GoB4P11DkIaw=;
	b=4v66vss5a5RHOtwmDAWEC3bOE0wfSClvQdhIK+fD8GOPJ3Vyfrm/hVMjm43wbfYwQQZkbH
	auG/9FgqXah9UGfEYmGywqKwqdzZO7uR8ejZnaZI1Ilw3rb8iJ0CSJWWi8fnE6FFjj2P5+
	skZ+nDIghrWIpW/iMPx/mBE9goMT4eA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QXu0MYBE;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753411652; a=rsa-sha256;
	cv=none;
	b=Mlkxx1embEHPtvkCRUR8jJupbXuYArmcerBXPQRdqIbXYUSwzD6VDKSuJvfwY5iMv3d2CB
	8srcdjyUmIqrWIlIpFo6NXtl7D+5BN7mc7R8qg6vyKK5HgkKC/sJBol63BXnxWEB2nT/oM
	2ThOJIWKwJxksNSxWsP1KEjNQT72Ho4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso2992844a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753411651; x=1754016451; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xc3hDEGPGsCDebYX51sWpA/bxBMOB24GoB4P11DkIaw=;
        b=QXu0MYBE9eANdZM0OdlIbOzZWzY/Wz7JQ6qCtD0aSb1DpXT2ax25v8uHIeCA4Op3PV
         d69RfqhCb0k+6erD+6M6XfC635ATAjXOfbhjyUJsnLXN03WswcngR4JkmPnEjeQesLQ4
         fz1Iyts6YQlWc+oTC0rounXdvDYNvDMqbg473ol7bv/GB2KJiM4/hPvsOwGdBpSEjyCe
         H/Eksg1AHk8jUV9rhUbPKuLt5/tcbheBkUUXRQgJ9eVyNlj35bPPKZh2RkFKYQbygLGQ
         vW8ZF0oyK+tMTBJOGGPNkWnt9xVzFrBR5Jj+aOq3O8DCm/+M7OC/EOaHVJHoayoBN+4k
         7joQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753411651; x=1754016451;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xc3hDEGPGsCDebYX51sWpA/bxBMOB24GoB4P11DkIaw=;
        b=m6X9hXX6bkb8OrRCIoSN0GaZnQOvh6jd/uDm+JMepVyzpysY2aGX6sErjDHu+k3ocZ
         /FO8hYOf7JV52La3fxltrCE5GpwwRdr82+2enMH/LueEIiQfnGeSRkjYgfeRHOxFoZQC
         gkLfiUIkdqLlZ3JSNeRe1Cc1UFx0SojteAz6WXzHpsRyTfiY2wEW8hXFxC9p4wNQqLN7
         XX1uCudib0ZOY64i3hpZFZmVBd+eYvbZTo4InacNrr/aivaRLBk3nZpdndErDhSBZS3f
         8CPn/T4oHfW/cFA9Aim22Sg7XT4GkvKHZq8r/sMxcXT3ukShGS+B+8t3AC/wpIjcLpcN
         JanA==
X-Forwarded-Encrypted: i=1; AJvYcCU4WrH3Sf4Xm4fhbTd/QMllFnKQUpM27DfTr3WcG1cf/Iz3Zg9d4kwb2+4RLGtNEamIfhWoH1N0kA==@kvack.org
X-Gm-Message-State: AOJu0YzwZkx4OQWWF/vaUdGoAws4mUv7xmFhtZZLc3SRtXZoxsfg5025
	w3Uh/1CTFdCxNWL/3LcLjCgiHJRM7u+/3lgqxpVlY9V+eNCG2Ga6Nakp
X-Gm-Gg: ASbGnctcW83fGXRvuhSUwyG88RkPnUBl6pnTEF//t5MMnTHhcwZK3ujqEu3Ih2Bg9qk
	EfonK5M4OCvf1A37JhmN5Lpm7j7eDVmnduKx8JMu4HAMrc8shg0+W1UtqZYEgV3riLG5UOhkMkk
	ZByks0/YXAwWwHuxFKrkmG6qZXbA0WpyPfybKqYPOirhH6v5LQ90htfi7iQuieU6A4Pihh8HLnN
	Nhgiqck6TSZgbqZ6nSTB4CMDcmIw96z5SwIMUe5u8uuGthjOAN0c93ZwRU3R5epWaw1vJhwe1Vi
	BWysKNDtMtyuD6Z2anw+OEvD2bDBpBW8NxzHhzrHvWUGz4fzmX+B3Zb7hjFVZ5+nju+b50wxrQv
	JKG/IIfDs8NNKwwI3Ti51Ew==
X-Google-Smtp-Source: AGHT+IHalRLNdYC73lbRRqlIizE8OiCJMhgGy8d4kUNVhjNjBAndWdZO49wygHZRXIZ+3UwJxXytHQ==
X-Received: by 2002:a17:906:f596:b0:ae0:d4f2:dff3 with SMTP id a640c23a62f3a-af619b04c91mr39263566b.58.1753411650558;
        Thu, 24 Jul 2025 19:47:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47ff42ce6sm195436866b.129.2025.07.24.19.47.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jul 2025 19:47:30 -0700 (PDT)
Date: Fri, 25 Jul 2025 02:47:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v2 1/9] mm/huge_memory: move more common code into
 insert_pmd()
Message-ID: <20250725024729.emodbzsflthdzyzh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-2-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 1ghmp6injm4fwyacinjdrsqoj5xbydtz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C5311C000B
X-Rspam-User: 
X-HE-Tag: 1753411652-346074
X-HE-Meta: U2FsdGVkX1+/pD1O7bMB6DOhWlGKv8cxhCtszfyqbBnOB7LTGG4xRHv4gQjDALiyx4Tf0pjiVSRQ6j0cA55H+VKHfT11dWZavT+cbaYYUcUZZI/k8SJTi6+TURbviIH8lOkMqnwIwqK0TRIOZFijodOMs6GnJbXUpn/NYLEE5nN7judv7AIBQ0N26s4+pCASocTYB4Uv4ydboFVsBRClhvnHsgS4fULcY4d3mS+HZeBGCJ4trtdBX2y5ZJ5HtFK5gye6QVJW+gJkNfjPV/6Pqws9JuP2BWArPcEE9K9tes7QOI/DIO30Q8/wJZsTzifiXbb5RhCThAbOjBdFgKoy0xmsoZWT4ne4Vaj1vGNzpcGgm+Tm4iD5iE/iKJSz9YMr8iEhKSWnekj+1aoU8eelSzdDIR1HSeVBBQl1VTq8fwPyl/2bf8sIkhomxrzwj23j1O7+l8zpWJbsG47q4A6gUjyhE5G3ReILWh6Y3BMbPbe+MDcNqECAOCcFD04+XWczPGCYDViAyEJsolSVyuFwpCS/Hnk6EsyDa2x6rs2sovLgK+QBKqIPlzhw98h/fT1RWwWJ6jzF6gxtETM/OWoK2dcE8Qs0WBCG0+ZY3eDj3hGVcBqViDRZ2CbHxEWeBWZSply9ww7DaBksiv0Fk5YsJeXo9G9Ahptcb64OTWUSgHzar2LU+hJfzizv12+1GgmniybpHMxzChNmIxGxqz3sqQuJoQp0jegsAqZUOGymh4MYdpsduTcUrvxqWFSmf8t5zhP51DSdLeiprMyddrmSG6UJ7glExMAQ0ZHvuWggrX7nTNknfvSSEIwCPLWDUkCd6LAPCDfQxII7U8mBd4WKMoyOOp6c/TCva/LJYWLvVeri4V4waO0U2yWG7lMK53qaBWEapf/wBSBhb94Xh3ZQVZZ4qGeVK+H2Pu72jVUa9yO5wN/8L1BZuYKURrcn1hrj5qLebk2LL1j2oL114eV
 Wr2rpynB
 T5DC5RJM6+F0IawSgB6Kwvuw2ZZbrhUOznSmd2x8Lw2tPzdlsECfsz/VQky0YLRH3br1tHF+e4CNVoGLwpns/NvdEkspGzNV9WfEq3Gvxo8p09/TEg7TFbA9eZOvbmM0cHi+Bvn47+938rHbmGR+qV7kXQ7DwP4QOzdNVH2gToKkbkHgxeSPTS/6Dn7usGX/U6ISV9+KM+W5z/C04TC9qY2nGZnMCvTYQx2g2Tte5lOgzzt2FVycZDe0tbC26GEjCU8askmgl3usw0L+xDOfKjWe3fb4emQf3W76Mf/mQgPr/VTRlu5ziQQVHSeh532GFw4IqQX0DTJE6l9MAv5rTsvD/PfXR0JFk/YLIRHBum3dfhqVmGAGW76J9FAyepH3R1FAN4Ricf9uKAMbVaQCWvLnGXSYlqalVz3N1Rep3jYQaayOkuA+3CQ3X0XRg+FTCsC8uPNKPFhNsTBpvPBg+pPb6mOW4nt7rrY/n5ZtRInsUWm71NbUbFN+4G+Fak8fSzh+xlbNkAplI1k5i3s1uTE+YBISEUsutNNATQXIPGoYN/L3r9er2lftoEA2esEJy/MZ4ZyqN7JI0bw1JIzQXVsaiSey7ierlyG3cznNFGC18MGeHJhu6HJGF6O6Ugut8XHtqEV0fVKPJvA77TndJY6QjRKgxZ4oRl9g2+6qXmg5vuuUSle5tbT9gkOtWS48hkfIcvzTZ3qGeNYAYb+FtdaCVnRQ9+Zuv3YNsTyNa9Mm7ZO511hyM2tBO/LMFV3l7TVOs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:04PM +0200, David Hildenbrand wrote:
>Let's clean it all further up.
>
>No functional change intended.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Reviewed-by: Alistair Popple <apopple@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

