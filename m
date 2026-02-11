Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FEEDECD6D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839666B0088; Wed, 11 Feb 2026 14:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7886B0089; Wed, 11 Feb 2026 14:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C92E6B008A; Wed, 11 Feb 2026 14:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58B306B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:37:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E33B7C2273
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:33 +0000 (UTC)
X-FDA: 84433185186.13.85AA983
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 955D1100017
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dL7pYdy9;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770838651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
	b=B4p7VL7bQ6qjM9oX+lWuvRSMzJmPvYq1P1scTSba/nU+zwZRfruyQY+R5zKIxMK4pkHEvC
	pm8x95qlScvGTGv2zUcq17UoAt6YE9/yNajlT8+2YanWYaxyZr+Unq66f0htu5X15tLauV
	+qeSZjHtOP/4T47NHQGw2nUKZLcUXVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770838651; a=rsa-sha256;
	cv=none;
	b=4vltlGf2XgSG01HQ+A8MY9e+Sno48xRx1zdufCYpm76nbELLMLXetZkNHCcxj4VD4y9xJV
	Q6goPSxpuRP0Ia4MJAm0sqosmEy3d0m7syiVdSr0W18gqvjHkaz5cV+9+sWEQlEa40KZWo
	1H20AwzqhNiyLzD1hHxHY75BYWJxPO0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dL7pYdy9;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770838651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
	b=dL7pYdy9tSzhHLNqJjvANSeaOX8It7q1xcytV+wrqVwY2vx3BKivbK8Qa9/aeYSeTwpDQF
	VpZPVvY1J/ve7IsgW/D/T7BIHqAQOdQF19gcjZ0N33sU8trxq5GG65CtmOyHK0XLcicaZi
	Wwcsgm75IM7cWep2k7sdtoSIjbDG2qA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-IPM6PLuuOjG4EyrULSmODA-1; Wed, 11 Feb 2026 14:37:29 -0500
X-MC-Unique: IPM6PLuuOjG4EyrULSmODA-1
X-Mimecast-MFC-AGG-ID: IPM6PLuuOjG4EyrULSmODA_1770838649
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8ca3e7722f1so379113085a.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838649; x=1771443449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
        b=LwyYH2vs7+YueeH6my0rRxVqbFkP6KQcGwyjmmSkf3/QkHjeINV8JVzqWmvnv55bTG
         xYe6Fy8Ek764xm/E9TO8gw2skvS5pRyN1sLmgCEREr+A3dWiiS3SmsdkLLqQiuseGsq1
         REAnHzO8H+7PNizKqE07JtpA3kHCCvpqxvGzqmaMa0gvIXwtCB6z8B/crTJb5wXLLGCo
         jNJ3oSBpp3ZUZmdR3Sa0dp7JdEQAF/L30Ev7tVLbzfzcBA+Pn28ZO51yulzdpY/rNYSb
         afBNg2FDyn2UEh3Tygcbaj0GprWqZ1MVhKSOU1rilSZ7VE3I0Acq6saqaNJ14Yk8mQmH
         gCzw==
X-Gm-Message-State: AOJu0YwCJVoStajV0KXt7Rm9j9xPqS2HPcoQm1aN9gcWOkDJBrmwdGQa
	KgdQRjXoQpT00wqIJyei4KGDHGL6joFVPQYvO/Vix19PIeU/1150xw6y02buTTxQwFuuUV1Te3y
	Gv8VjyTD1eUU5s9vB6vXk5rVuH9P+v5nxAI1KtNhdfXD77oeXuW2SWnRmkCmc
X-Gm-Gg: AZuq6aKGQ7VG7lJl2Jen1LHF0VfLy5eIGFVEmtFZlMkFUdZ6oyne9G0FijiUN8ahe86
	gs6UuPlABOY5t5nNxz3ISA9tt1utOmKTpo2hU7rdGgYYJT2oUwXr1h6PXi4nqAs8FSPVyTdEnyZ
	4psL7p8N/xJyAvChGtHU3Emjin1Ni1PFNqG7ImjRb0iP7BejrFcxZ68RdF+w5WapUgl4zDDiybL
	YFjdxlKbbAxkyUZG2OuvKM1nTz0+WI9TNs83YJVXu5Jt1AbmtdpzS9zV+JrQG7WX65ZOy8lnA4k
	kcvh74Xe+/oobkwP9+lnti3FlkKyBxCQ5Ce7m/UL22dGxLWZka5J/S+uM7n1Df6VNFhD2cPrNnt
	1OA54qlJSYAUB9gs2weYq85fu6yQefphqPN6Bkd0+T6VCXj5nZFFT9usaEVVCC+mZ6tq5Nwa05E
	62DjFl8A==
X-Received: by 2002:a05:620a:bcd:b0:8c7:110e:9cd5 with SMTP id af79cd13be357-8cb33d8c6fdmr4442585a.45.1770838648992;
        Wed, 11 Feb 2026 11:37:28 -0800 (PST)
X-Received: by 2002:a05:620a:bcd:b0:8c7:110e:9cd5 with SMTP id af79cd13be357-8cb33d8c6fdmr4438985a.45.1770838648496;
        Wed, 11 Feb 2026 11:37:28 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cd8aff6sm21074646d6.27.2026.02.11.11.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:37:28 -0800 (PST)
Date: Wed, 11 Feb 2026 14:37:26 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYzadvQRCw3iOVsc@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
 <aYEhgA1dY0biVYb8@x1.local>
 <aYhj_H2X141wU3oF@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aYhj_H2X141wU3oF@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wwRvzyDtSxLk5GdVvugl9ym4IoyofUHEj8LMyFAAaKQ_1770838649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 955D1100017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3j9jau5dmzd9cgqpaqbxw9gnbq1rc3w8
X-HE-Tag: 1770838651-763790
X-HE-Meta: U2FsdGVkX1+7I3W8pllLucf7uD5xlJ4KbYc22O+MSZ268fYoveJy/rc9lAv2QEi7+XLAH5m6uO4TzHsQfOqDVTIPL/yC8K9JdLbKV7DRwmgyG/KUHWMjibNgM8uSkA8IDKtcC+9Nqq97rqCqoalMysCa5Au/NRArJv9OZj+dH3jV6NLemsva1x8AIKmNGociHCokzjAf1ZdcnhVDFOtF0Eqj5kzZ7wBgPfx9u+jp9sLV215QdsGkBqBc/WPnImbBLQXy4R059V1TaZJ77nlzA01uWQ6Kef8cq/N8AN9H4fZlfMid6Q40moQYKD185RLh+spJUqZwLLRrN3/hWr6MAcl7DoXME5fZbPXhZYlOPwBtHQ5AgRAM9bShcUfs0Gp5P31W8akP9hBNjtaBVrngWcMMEvXhVbVNCoo6bo7gma3V7cED5LqaKZQLmZVUzLXpeyXBjbs9OGDHqBJRMewweDA/R+H9LvWOBWjlYxLoCPguTXc0Lf2I7pu47NTMbrAkUXq0nUE+F+4wrvlPlzJccLvI8PxkpRZdjHrzrg1+Bw0RSpeoZPTveUBO2VnB9rE1uLZTtLE/s5XMwZa3yOQ7xh0po0TspeENIxMRQEqlXCVLZzlh/78uVkb/4piE0SmxjWI2SDzyWkhnuf1JOVzHPYG5U8ctNGfRVPofZLirphpr4ndYWNZAqF/U9SnXnz4Ze//b0bywScCcikQ/R8HUm5h75hotM7XeFs4xXzJWR75fL729PaTnBOF6X/zXwaUb43bmalI3+dV9yW7pQ5NVwJVcfGVIeRvFzYwGgKDtQ6oBvM+rlFJE8ysbjTlmkHVhb5HUMEHyzmcF4xWts0bFyeWBgKzM+XyrJTecpWA8jcLc8DIVEotBr6hEsHiWqE7CxNij+TumkKXwVhFdvMktR79anPPlHHN3jMdv36XpgQc6bXu3kWWF6LTk7+9z0rXyktSV0rDLGQ2MH9m5Xj/
 I5PEthaT
 +uWC3tBECoJTErnJgJ9kn2n/7Re8auR5ePONDTrV+ApvCWbL9UUrQlT3SDzsv/vQYmyr6rVdbhxM7FkX5XxLKNjRo3yHmZlgyKe/0tbCenlRMywoGfA9CBMG1J6hWx/em2uNUvythG9PjPqYlvC2rXR6tRzGhX5Ndu1R4+o/PKFuG8Uovo4strbn2YfH+QNkzGRV7dV0+f0rottT8QjUn/GoawVSFnZnw2P2oBnhC7fhGJcdjYWo1SwVifJwQBf/LqPLiYQYS9v/QPP2dfPRMy0bVWISSL52E7OLeqn+BmejrEE+LGLL8hkllqYlfcpLpd/WgmZTlhBikAGI5dBTvKkptRo+SnOOGuBOnr0pFmA1Us/GUIMx0lF565Cc27Npns7DgsFHTxxgOiVehFTP2LF19W6bIOFcahWklXf2MtB56EC56OqcKRGMEXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 08, 2026 at 12:22:52PM +0200, Mike Rapoport wrote:
> On Mon, Feb 02, 2026 at 05:13:20PM -0500, Peter Xu wrote:
> > On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:
> > 
> > [...]
> > 
> > > -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> > > -					 struct vm_area_struct *dst_vma,
> > > -					 unsigned long dst_addr)
> > > +static int mfill_atomic_pte_copy(struct mfill_state *state)
> > >  {
> > > -	struct folio *folio;
> > > -	int ret = -ENOMEM;
> > > -
> > > -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> > > -	if (!folio)
> > > -		return ret;
> > > -
> > > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > > -		goto out_put;
> > > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> > >  
> > > -	/*
> > > -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> > > -	 * zeroing out the folio become visible before mapping the page
> > > -	 * using set_pte_at(). See do_anonymous_page().
> > > -	 */
> > > -	__folio_mark_uptodate(folio);
> > > +	return __mfill_atomic_pte(state, ops);
> > > +}
> > >  
> > > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > > -				       &folio->page, true, 0);
> > > -	if (ret)
> > > -		goto out_put;
> > > +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> > > +{
> > > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> > >  
> > > -	return 0;
> > > -out_put:
> > > -	folio_put(folio);
> > > -	return ret;
> > > +	return __mfill_atomic_pte(state, ops);
> > >  }
> > >  
> > >  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > > @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > >  	int ret;
> > >  
> > >  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> > > -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> > > +		return mfill_atomic_pte_zeroed_folio(state);
> > 
> > After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
> > impl with mfill_atomic_pte_copy(), so IIUC we can drop it.
> 
> It will be slightly different after the next patch to emphasize that
> copying into MAP_PRIVATE actually creates anonymous memory.

True.  It might be helpful to leave a line in the commit message so it's
intentional to temporarily have two functions do the same thing, but I'm OK
either way.

Thanks,

-- 
Peter Xu


