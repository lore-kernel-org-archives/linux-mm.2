Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1197C87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5A86B0089; Thu, 24 Jul 2025 22:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD026B008A; Thu, 24 Jul 2025 22:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9DC6B0092; Thu, 24 Jul 2025 22:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4E16B008A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:56:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D54B959B47
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:56:11 +0000 (UTC)
X-FDA: 83701272942.03.FCB2B2E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7B53140007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:56:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhDw5hxX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753412170; a=rsa-sha256;
	cv=none;
	b=YRiCoVaq8YxAx2kiraju2FestyoRHMuwFw2kRmntZ56lrbs4raIpgF9eWQ8POy8Ji4cqaV
	pxagpWhZFYoci9xlV7gOJK/eWRmtQXI+m6FDehd2xTTiQh37+L8ypq+FqzNFr8KZPx0tcJ
	yZJ2H9emxD4DJe+McHc94mI9+EFfuO8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhDw5hxX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753412169;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzGOuzDhEi3TMJulLXZr4GFUL3lm8OH7E+i1imGtL3w=;
	b=yJ4ZDbCbrT6y6TrYiMkkgrjronoqFTjvLe1j9bbeY0j6HBF9YP6bUgjFnHWyZ1hizlGwa9
	m+DYLZjs9fCgIFfHQFCZSZgodIOD7RlkVo5dE+7T+/K4CKGMCjP20n/jljvwLMQ5Xd5m8C
	ohRZL+JcDqyfMOnWfyiJoUaAc/vUNMQ=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae3cd8fdd77so333803066b.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753412168; x=1754016968; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzGOuzDhEi3TMJulLXZr4GFUL3lm8OH7E+i1imGtL3w=;
        b=PhDw5hxXJ+jPlFRO2HMiM1PquLjOGYBTCaUqADmUGR9XjYYf+gNbvezO35ogll4OAT
         Cy1GKzGFp1G1gJOB5jyEZKRMpIbHRwf6S6tvmKiIs2f/HY/I9GEGD4P9+5w6K2+a5ri7
         zvhKwBt2WrgZ3Iz3s0Bc5HIBBavQGEvEVZWpcL87DyGP1OAgnRzh0bpAGdABQSXlbhIx
         zCf7SqlByZw0ROg6yyvuVDkhKfYX3CsTVgPKTxzRfPaKHOrbR18M/A1s0TDCqpTy8j1s
         SIHWI+HUkRDsSfQW6YI4fqR87t2cQkQaju2cLoGpWjOdlOudYIAwKy6GnXOepuoCTyNC
         qrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753412168; x=1754016968;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzGOuzDhEi3TMJulLXZr4GFUL3lm8OH7E+i1imGtL3w=;
        b=NBh1N8dJU7ZHqPAfs7PkwYteWdD1mV184La8zf7ZhpXsamP+0Apl5Jw0zCmQbs65f2
         BgIGvCH/42zojunzRx0ycyEEfxKctEMNHUs7P22xa0FRhWv7GM0S3wWs3402T0ovrlX1
         BYx29lKIq9zoBHnFcp5/C+QUPqoNC1NSPMvUGLQxMhxQfwOzW0olq4a8/jPxsSnvRPcr
         iuLLMnrcYFoLkc1vWhdLbtQ/Unz8tESHqPT73O+GmB2yanspoSGut6B6vM+T9s8lxNKh
         7WsT6ALI8vRSB8E+tQszuNXJ4HetSkJ22IFm6EczSd0fhDNRoWj8Ut2ibOWwIWwpr/+r
         xr8w==
X-Forwarded-Encrypted: i=1; AJvYcCVTRnVDiSPQG8npUc/6GZTtzj2BFO2dg/C8qiiOseRW6FCzcvYeekot1GmmmAPOLpou3ZQXMTr/Gg==@kvack.org
X-Gm-Message-State: AOJu0YzncO2qv4UZeITT8fmNO6sCsSmdXx6xw66l67LZjQRTqb2vFwTT
	MuXpUlOI65XD3KMlXTGaq5QnfY6HoYuXfADZMpY8/FiS7uwOqAcusI9wmdbTg5fA/T8=
X-Gm-Gg: ASbGncvEsQeCZydUJDFvJ5a5Lz8moAP46ymln6nq8506KJAEG77gCaq4U4zAV+Asqoy
	Pw4BpEDv7KrZu+Mp8GgccGCtqxUm7DeLpfuLtv6YHxiU/ww5biUFbV6TgAqyEuWK0Q356rF6vvI
	8b1uDWCnEeJOzFnySwR7ALtIsEb2p/lMg6W0zV9CultuEZEzfBdJijn9bOowJVbmO3J03xE3pdV
	y037qU6VlyPAdQBjGDd0TE3X5csrbdlhfqHMXIOOJzBHxB0O4eXqB2UCM1lS8kih/GsHPxVXvKs
	gYgRKTR69qvDlabVrmvSKpEySyqkW50GZyaa41VqjkPuYYUN0DOmXaiqrSnsnSYG99wFab+p4n0
	4ZQ/s1iS4PZuzZj3BnU78gkZphopeRHj0
X-Google-Smtp-Source: AGHT+IHhkClQ6+YPICgV57QIRUaI7tNGak2Dw44PbpFkJLABqr49v5gkdZqRJ5Z7WHZCF0LZz7A43Q==
X-Received: by 2002:a17:907:3e1d:b0:ade:4593:d7cd with SMTP id a640c23a62f3a-af61c8a6743mr34848666b.13.1753412167981;
        Thu, 24 Jul 2025 19:56:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f44d85esm196204966b.89.2025.07.24.19.56.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jul 2025 19:56:07 -0700 (PDT)
Date: Fri, 25 Jul 2025 02:56:07 +0000
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
Subject: Re: [PATCH v2 2/9] mm/huge_memory: move more common code into
 insert_pud()
Message-ID: <20250725025607.vi7n6wvwmzajcv3q@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-3-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7B53140007
X-Stat-Signature: gjf69k9yxpj4ffimqry1qprjx151kb5t
X-HE-Tag: 1753412169-561618
X-HE-Meta: U2FsdGVkX18nJxa6PHj8nZp4APP5btPUWdIfx5pTCPc69VQsyRd/+JC19ks4wrqYhu9XdpMfMouOmcK+G8dba3bVP9f8sQmVuoKi+D7xGH8L9YLh0kO9uMVttnl2A0kOf9FqLgrRuFNeqPnJos8gDjktWn0+z4PW9OKOkWkcWPbau/oaNfthes1RoPy/3PLPz3oGOyBu9CeIRCl4NY3ggF0uIMHWb8RzqYxMgz9Fad04AI7E8tY2MsgEmVL2tYP+BJ7WFiyoSzib49QpRPAluLStxPj8blzWsUnWpkulhRcQFCSoznZnqbECaBF29IPhnz9q39UC3QHyA1lG9J8pCuaqjmC66+N09yEK6SaFiYqPxnqKeGvKkXFRNZtD/lN01Hp9T2gg8b9MdLEBe6LQAsUA7j2sU9niDgQNMJDVkVc57qXYXUr7VxhrBesYXZNjPWlzdJjDwfUHt2l/7Xx8KH2bHuO+sQ+9b/79klHEy0j/LnKm4uFgfX2PC3vMLiis8K9Tpwj7n6g9E/IcoBpDiOoWSEs4vTNpET0nf+nhUs+DGeye6jSarq8k9cM3ODtGaVzcB3MQqAgKXvHj03kp3UvQ809SXrfWEMNIQoqBcbTgywcCFDchydrQP+wVde/lambAbE2pwdH/cEl5aWe313kRcOcGeAoT9ymwuTsaW9ATM9H1xZ8KWXOgEpuSnpfO1Infa5giKDENFl7hgBd2G4/XBANDhUS33KFgiNoA3AzgXsQVrPdST+JmFraxaejAHwjHemTpCnEng4dDv/XL/aVXIwSuIlkLm5CDD1Qayrw1uzhkBea1M6w5wLAMCPgLk8fmL8jRgSnopuyfY03PHre6QtDZ4WE5JM1Sw/EmrKYlLIbHFTMsV2TxPyrg1Qv9r7fT+MFE4iGFN0PI1WJafcHVNqVRKwKrbPExQ0UK9ssKQjCp/fzT/HEknveW7D3NOQtr9s3GV+zYejd8cr0
 ti21saJn
 2k0tdPPktR3Y4E6CXGh4kAMTURLRcqK6xkdBN20MxGZiyAHDkV1jdi8bB4SHZi6+jCB+4+/nNC7dH/URdK6nX8OOpMLzkD7dhvFQMG3Y1qtBnqxlGSMVM4ndyCXh5UiHWmeR4yqIE0mL2057JqepLsJhJB4ZNYdlUneC7aw964MSuJPfM+UcJdpG3sFid+G0Dat56e93MZ/VoaghcWJa9HtTg4BAognjY/OaRI50jDnCFi/CRdE+7ma4Z6vKXNlRgKs+cBeYB5BnG+ROXUCekYx2fPlCWvTCNxKQZ3bqFL584g7JoFzjMcB0eWMLAEc2xoHYAjN0IL+Lb5Sjj/hiNtZuNdyid3In4aQdI3Y3a6Q7GQC8MrvsyrxtZlddRKFucUn1JfRoJaSCntxkDiUUYlZK4FXNtXY/UbEDcPCdAeae8pZWQlsOqng2ItOMCr7XN5AlBaJPK3zF+3pKO4K2ha+S2TYs3f+fVt97GXC85b1p5pjngkDXJcgQOL/Qj7gx9sknyUbJwA+Dcmv1khTApbo2/peZQcI0WpAppc99W7uE4TylJyCkX8Ojw5pEsXIEgBQOGJFLvCZobbz2BJNkvC2kbZmYF/5FFnQsArZAS9ynqJ56BvOyXhiked4LrtbZosG9q1fJQHVMXs+2UbUSKlu1BOzP82UwkTX8rq575yw3TjJ+fKhp/6WEV4K08fnX2iBgseUehVfnXUC6FstTD3qbMEdeuU+oc1m/rYBDrwI5y/nFQ49u+7Dgnd5ZDrHmoG7+S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:05PM +0200, David Hildenbrand wrote:
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

