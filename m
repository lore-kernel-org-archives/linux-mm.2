Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428D3F46C4E
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDD36B010F; Mon,  6 Apr 2026 12:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E8B6B0111; Mon,  6 Apr 2026 12:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D2C6B0112; Mon,  6 Apr 2026 12:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52BCC6B010F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:13:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE00D1604C2
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:13:00 +0000 (UTC)
X-FDA: 84628624920.07.8C77563
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id E73D940017
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:12:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Kg5ejMW6;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775491979; a=rsa-sha256;
	cv=none;
	b=th41n1sMDO2pMV9OEkBm9nsviw+3xwsJLC4CEIe+tByns/JKvrncEJeP1s9lpHrtuLXuvb
	Fec9TJ9WLKd31W4vt9fVmS2GeneOpqM5MxOX/MVUbN5hFsSm/h+xba9j3919LVddQsCXeY
	nNVeoR6OWnFLGyznOsJW+FZ9XSNCRYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775491979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WGlrIJpvPnuQtTh0sCZ/YJHBX7OWAu7nDVvuxQbARI=;
	b=qF3doB3hyV+A8+mt3f64zDI8mQk09PZMx8egsZGgsyfexvbKZ7363qm43QVq0oecSLSC2P
	PlsplpX8HWnbwEYGTcmzZTJPqA9rQLDHT1+mX67V/CqcVoH1duh47WIAOFW0vvsstStTph
	/v00Aysob65ZHBtQP5cIeplwVxcAl/M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Kg5ejMW6;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d8da3e656so13223231cf.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 09:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775491978; x=1776096778; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8WGlrIJpvPnuQtTh0sCZ/YJHBX7OWAu7nDVvuxQbARI=;
        b=Kg5ejMW61k+QaZkiEAExGPt5j6i8l3XfsS4CUZ8Y2GbgMwpHuuOUw4FJ8S4+2ZlLgu
         OyyQmOfP9RQUi10YKJkYu6Z5svtOWj/WMRIrGjdymfqVWTxRle4Adp08+Ux3B/TTtE8n
         jy35DeicwdrsnHiEnEWWSd1sVnq2xYOV424iBiQ/cfWeOWQcgXuvSZXEdXSRd2od+oHf
         We7SS6rwgq7/Meo96ONrTKaXuzte1k7BbPPHJvjr05WPKZtpWWYR2B5oujhQXoH4QWZX
         qH4ucnQmJT3Brzs5i1sTm+erUC/DEtpLkJEWecUzIbJ7aJrR76+/MfRBON2YSEzk5RWE
         y7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775491978; x=1776096778;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8WGlrIJpvPnuQtTh0sCZ/YJHBX7OWAu7nDVvuxQbARI=;
        b=XAmnAQ7G5TSnZompFVn91FaHVFa4VkwzWo2xY1FEORHxJTSeJiqBNlfiUUMLFWahkL
         YOZZC8NwS0cXydePQxhS9VHfWh/lf/1nHWyIpxr9X80oz5FqpEYldiRbMvsTAN2wjclg
         Y52wXj7R0Tk43ClYj+z+eWR16Kfvd0u7x5/5V3pvFxj2EQdhYH911xzh34rkGGD/hdkf
         cTAti8YV1ujHuZXH6j8QxA5Kx0pEuPwDUkDt/Z4u31wMcX/nKvupM13KtD+RgP0iVOji
         kAKRAx6Wu9kaU5Esvbl/LE12p5T2seY83tNjM7CBsPF3znk5Q+emacRYAHRSOftJKbdQ
         OiQA==
X-Gm-Message-State: AOJu0YyCL3zzxWbPv3juvn4fbGH/7WmzXTQOZ9oNPT2jsXed5rZI4/HT
	+aeG4GujLSLLshVHFvv6q8vKqtuxLF1DzxyqQKMLOYzn0n5GJaFprFPKSWId1GhH6BU=
X-Gm-Gg: AeBDieuq1gvYUBTAd8Z8kaO0aFGAiVQgdA8kHo2ymLSHegyY/KrOva2hM7p10IYSl+d
	opinBRgWC8Pv/N8cjN4GQgWODzmt6AMbDnVM8T4FxbSyofCuwVfIznHWKOevLwJIokkL7Mw4AJT
	lIfG3l6t//iMnxmq/vSdXuymGOCpb8fMk4fuLnCJx1a7ruymKkpm7rRzMZA0IrRcnMaRAklF5Du
	k60zviDZjudcZY+JdWq6fiqta7bSLyScz9Bk4cWuTDDifMXl26Gq1RN1S2GvSkL/zHVV87MJFX4
	xMlavrpycu4IsKQ80KQrXUdLz21N+6jgwkoZZ0nRKUfgZWQ4BVRsp0IgJzA8qoEp97Vdy6FfGOm
	SOJs2McUkF4wa/TLNmnTqwLqyOWbvgUV8t2ZqOcS/qIFEmzFs6DV7X+Vk6ddpatOo6s4TclQTjM
	AucNcKQDfG544YPYqF3UJ7hg==
X-Received: by 2002:ac8:7f07:0:b0:50b:3c7e:a33c with SMTP id d75a77b69052e-50d62a95fbbmr218250341cf.38.1775491977759;
        Mon, 06 Apr 2026 09:12:57 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b93dd10sm115521861cf.7.2026.04.06.09.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 09:12:57 -0700 (PDT)
Date: Mon, 6 Apr 2026 12:12:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Message-ID: <adPbhU4Yt_i6PkW0@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <20260403194526.477775-3-hannes@cmpxchg.org>
 <984aee1a7af2ea4b576a0114a367402537d3deca.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <984aee1a7af2ea4b576a0114a367402537d3deca.camel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E73D940017
X-Stat-Signature: uujwrof48j8me7i8hmn3bi46hrz8ro5z
X-HE-Tag: 1775491978-304313
X-HE-Meta: U2FsdGVkX18tTante5MD5hV9jGDpoRRh18VjtWteO/4aa6miwVWMWfHV7VQ5bwjxB9FfQzSU3BJlgeQnUWW187aYjO2lm+51NAU54DbLwV8OaX/yby3otnhYzDBTk4lcJPyj4uG5Uo9pSCN7Muoxa7J8Yek/RQwY9VlK/YRsnPLDKT76+U++QYif0Dd/IZ/9yxIIPbRwzokQx2Je+nVJjPIuq42Cfz6YtVkUaBoLHRyCRI+MJiKxRMOH0Y/4ZSoYJ0lGX3NKUnQFvnOlj0Ow3pPR98eDZJxItzhESSaUxNIQKh2KthqJ0DpdcvvhMK0rxmMYosApQgAF4j5YBJzfMjYJpO45yGXI/NcC7F+9EXRVPNqNJ5u40uBx0B1nKmnzpXPMPjzzKPccrcA1XVRc08cAGX0KuTqdkIlmUCGzJINoPr5JB+/lY04lyCX34GxVy3vs+B2dUegNXr3Da+AhrIr6g58eEiq34d5yToJC8vC20SncyNqbPk+pf94gNghxvNu4XDtzRSWx66qiuKnNSgqVuLjzLQM6zbtvonBueqjxAw3Chavme7KiytkJGMeyQVSBSYgcTl033VwANPrqh4k1dvNMNFUgmKbA9EZmAAhSJGZweTfeYAHQ9+aVFbyemmKygj4HHhh7PpD7pxAjUKA5p+HlDd1JcMg2zOeJT43YK+vSzPu34eSsCNPKEwYJ71U1AJWaaMMgzYIrl6xcU0n3XzGMVaWe9KtffKS9jXyFYFn4Gs9eU7HaneH4pSW2Pke4Acy8YxQoKjqpA/ctQV+YQ7wGgTzIxJpdgFkxfJKaSwuh37E3Geudp96VEfznkdHgw8klQq3LHqG3aBUC7fayANX2nrCvK/abNy1wJ3GlHZobBykGzRwJIG8y7pFhPcgx8YjXQ3rVouOcPv1CMm54iae54U/ssPQkKpkhSUBBj55YXjSrtJCMC1F+NRKgQfGi62nykxti3gFrl4F
 TAWOcrLc
 YlBYa+iUzwJRaxqdwELCZeafoBsJ6h9WGS0r6Sfd51wQmS16gevld8dClCGyOdqexzTecatma2k1bUy1MyBRrd4rhsDe7KkAsH4opdcwkyJTRSxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 09:42:08PM -0400, Rik van Riel wrote:
> On Fri, 2026-04-03 at 15:40 -0400, Johannes Weiner wrote:
> > 
> > @@ -755,6 +752,9 @@ struct per_cpu_pages {
> >  #endif
> >   short free_count; /* consecutive free count */
> >  
> > + /* Pageblocks owned by this CPU, for fragment recovery */
> > + struct list_head owned_blocks;
> > +
> >   /* Lists of pages, one per migrate type stored on the pcp-lists */
> >   struct list_head lists[NR_PCP_LISTS];
> >  } ____cacheline_aligned_in_smp;
> > 
> 
> > + /*
> > + * Phase 0: Recover fragments from owned blocks.
> > + *
> > + * The owned_blocks list tracks blocks that have fragments
> > + * sitting in zone buddy (put there by drains). Pull matching
> > + * fragments back to PCP with PagePCPBuddy so they participate
> > + * in merging, instead of claiming fresh blocks and spreading
> > + * fragmentation further.
> > + *
> > + * Only recover blocks matching the requested migratetype.
> > + * After recovery, remove the block from the list -- the drain
> > + * path re-adds it if new fragments arrive.
> > + */
> > + list_for_each_entry_safe(pbd, tmp, &pcp->owned_blocks, cpu_node) {
> > + unsigned long base_pfn, pfn;
> > + int block_mt;
> > +
> > + base_pfn = pbd->block_pfn;
> > + block_mt = pbd_migratetype(pbd);
> > + if (block_mt != migratetype)
> > + continue;
> 
> GIven that you just skip over blocks of the wrong migratetype,
> I wonder if it makes sense to have a different list head for each
> migratetype in the per_cpu_pages struct.

The list is fairly small in practice (pcp->high /
average_free_pages_per_block). I haven't run into any issues with it
so far (although like I said, my tests have been limited).

That said, I also don't think it would be an issue to do that split if
necessary. Additional list heads are 16 bytes per cpu per zone.

Let me keep an eye on this during larger scale tests.

