Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0339ECD6D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 20:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE186B0005; Wed, 11 Feb 2026 15:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BE46B0088; Wed, 11 Feb 2026 15:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87826B0089; Wed, 11 Feb 2026 15:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B47CA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:01:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F9BA13B35B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:01:16 +0000 (UTC)
X-FDA: 84433244952.06.586F21A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 096BE1C000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:01:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1K6acCg;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770840074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
	b=GaK6LOXPVLbmkEerFIg+Cf0p41rAhAcyPPblUR09vUF0pIVhbw8H+5hnN2MJfADFtmf4oA
	oMQKQQJxw8cSWTWbMiYzZVjGSF4E5kts9kkhO9a8YDuoWNKDjWrYXHJqVKMqsgf0jHcvH9
	EW504z+XsP6jrivJ8T+Xt8vM0NtgbuA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1K6acCg;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770840074; a=rsa-sha256;
	cv=none;
	b=2rDlnkb6SBi3rJFeqClxnXRb5x4v0xkhkP6/W4qg1VIrfgYzTLJ6e53erBo/FiVauYjNhp
	mm5Yzh45TJEC2KpqYLy6aMygte6Yzj0w+9pKrVNXJwxlZHYOl4KTbKr4h1eU+eC0l1V5m+
	8DRGz0aNXDTv1nD04JQIZXz4YkrhI3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770840073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
	b=b1K6acCgya/K1zT3bKEJhSS9VDdE2U9N78nr/zb5wo+oQLMl8DIcWGi4LZySpRGR8icIDl
	crCUj7bn4sd/RE3aDcT42IzsE9wkzXM/4/EJphcbO+TpEF3qMetTbSHB91jhHUCAgScOIA
	LHz9PwsubC1YIqbLwu5kFhyXkAaChgg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-xBSbIhsJO9qz50LFeHnE5A-1; Wed, 11 Feb 2026 15:01:12 -0500
X-MC-Unique: xBSbIhsJO9qz50LFeHnE5A-1
X-Mimecast-MFC-AGG-ID: xBSbIhsJO9qz50LFeHnE5A_1770840072
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-896f2e45fb0so42411426d6.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770840072; x=1771444872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
        b=UGFi88vYlR5clh5K/HJsIyGOmMUBi1Etct47g7wEdySSOT5oTkG+OaLiI8KqEuhQ1U
         WCJ03FrkHzLmBWX96fBhP9LyWtgEF8HujeSWKOc+k6qWw2OfeZqa1E0d+dmRcLS5wbCL
         jJEBX7OG11OfO9jJw2tOHVOpiEBrlgC22iwp/w3JDFKi4zOQoI3uFQy2p80knCGsh60s
         UBVea2DQUl8ynoklXkzVpZOLH0PEN3kVICrMDv1czymHy99oFmitfEG4ZcY4f7Tt1Vn9
         63vdCd6wEyLkbQzM5QZGbHcFNP4S6lMWo9RBQkonJjFpdo62TQZaPUfyjHXCZh8TKa0a
         OVhw==
X-Gm-Message-State: AOJu0YzyS1v+c0ZQyKMiGl2WognVAfO1fnDU2/xM9WDOdsNifMoMWUBd
	7zrw2+6drQjJ7pXioEh/3g3c96DrrxgPyPQi52+GTg6BdMd2edNhzY4wCE3J38QbF1o9hMsbRPe
	ZmTzP4Fsd2j1v8WDGVQfqYxj5bdf5RnGKgJaYNOfBOUvFqZ+Q1VIw
X-Gm-Gg: AZuq6aL2cBfvjKGb+zkEM1SDwh04glVS2k+TPoCnMLjA1acUV1iV98E9+FLB0dQdmiz
	mZltgu0Bq82YfDklKgYtFpTacuYtRWRiUo123eqB0/ZSFLZodlVXH+qA0xzYs7fUYD60kMqXc3j
	K44KOiJeUsF4cbw22U7cyz8EsF4TaGOMJdKL7ymHQIwwaPKumOWkxY9/Ch9XbPx3xhmJk+UtXi9
	JJg8+WxufY+F5vGchq+MXuIjdR5+lMTU5Nts4cMuZdO1gEuvnneO6+lWpMZapD8MaFTKLHsYsD2
	qyETnghAUQiTmatDl+e6agLJgUiPWHPIyYVswb0Bq38q0KtNoj7y4gmeWbINuW0zd4x80JvC9Ow
	Sw/jA+1Zgv3aERw6RJtuhMWos4YC4A74BURlsPWCS9/Pxc+eoGpNSQCZ7pxR2PnM2s61TQtZ/g9
	AdS0pFyg==
X-Received: by 2002:ad4:5aa4:0:b0:894:71fe:89f4 with SMTP id 6a1803df08f44-89728d939c3mr2000646d6.11.1770840071504;
        Wed, 11 Feb 2026 12:01:11 -0800 (PST)
X-Received: by 2002:ad4:5aa4:0:b0:894:71fe:89f4 with SMTP id 6a1803df08f44-89728d939c3mr1999556d6.11.1770840070818;
        Wed, 11 Feb 2026 12:01:10 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506920071c4sm3288501cf.1.2026.02.11.12.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 12:01:10 -0800 (PST)
Date: Wed, 11 Feb 2026 15:00:58 -0500
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
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aYzf-hS4pUY9ulss@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aYhm_4difwN5XXxe@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Je53iKXNFChE6Q8MMjO6_sH5tpwo_5Vh4av_78b8OPo_1770840072
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 096BE1C000D
X-Stat-Signature: b8zyg7xrxc1crwkyunzws93qfxeqwxjz
X-Rspam-User: 
X-HE-Tag: 1770840073-601255
X-HE-Meta: U2FsdGVkX1+3xYT96DGJ5hU9jI7aYMXjKt9AXRVUCmA+K2YddYEfW2RJoCugxYi09KPqSaMNSLXb+eeUkGvc2GLAY5jsoon0ODZDwRcKuqHsaKzLNmdKEWrF0Gzy1CWa7SM1JTQGsy+G+f8c/UNO4L5hZ+6ic9yXBUIIispyDFCrnF5lxd041P0iA6KE3qQcXn/Mn0f6zEqDvPUgy7xDgbIOeMyG+4PlknuXXwhXgYkocDL8vKvBFNfJbEcE39r23Czsq5pux+havkvwCw6+q1iC5N5lLOTXNy9RxsKOC+gP958Iu7aLdyyYOIK/s6TIqGjcuf+wLkCYncDOKRo2NKHgaCckN5sWL/bG3JJE5B+l6SQs9tfpC28MKGVxTIqZ1PLT/fUxuYu1DwyO+GzP276qC5D1D4OOi4dD0I+oWk4bxCrZZ6pPgegBpX6w1j0HPiAylkVnCau5nTLXPqtQMKOr8yyFZDVPku4/4c5heK6zsrOaobt+IFRxi7dsBuZam3qPNj5RJT4WdutpO2jTxcRaTSXII3PC+o0VN9mkF0cAwb9YMWnpb3FdrRRkt9NR0Fh6l9TxeeDNhT+/QWctb0I9sRqP6m8vSM8XU0vifITo78R4V9840vpU5zuDXUEp52351YO39OrMKtDivuVl5QW3j8d8YmcXQD5yjgnli4QIaNTFGkSRPsO0fh9USEI3u9hu0C/6pYHJZlbMoS6EnYjQ8X4PA+85XUvnEbmch6uFVrRy9WRTaWzgAEiefNKwGSVtXI9a/qURi+aoBylqbeTTIeLSdKNdd5rsc1+ruMQPcRhL20JKFNvdrB6xcmkjkJsevOq53FP9kA/+F4Rcr518x9SZocuH5bOJQVwjn3FORahxL6ULdBCSKZleVi620/rw2Yna4ZvxNzGzFiFzzBNNh0hposVkSQww05Gg6rxZAwomyp5zkb0gRmJOEUdf3O6ZcH0cyw/oL7Qh0J2
 B0uGjnLj
 KbbzwB468F5B1Zh1j+Nep0KyIiYpyDNIoTEqln6ftFbzITJUOz5odaKiJp7YWSSbuAZw/EFungQUs8XKWNPe87pkd4mcX8tHmmtsCfH8+XMrMXU+n64mdljVpy2EgHMToLWWu64ojJSiD33fXReUt/JoLAxnvAagmYDLvzVEW5dPsyn34vg8X73+COyL0CoeWRwMrI70uWkxu8LbRV+8tQ074CbPALhhahpWMNHgu0zd74T/Eamj9Ni2agOiwZfeF+txm3492wPhV1ILfvbKwXA8l3wkQS+c1mAc+WeTonVoooDTSIg9HrcKfg4Y8hKfAdQjZiXb0STjJPh9tbqTGe32BtgL7/LpFUfyVYhKLyRJ70p2pZ0sEmXE3nv9/muobfS6PAELtn/Ijkw0Cw9qdr4rblIv4RGUEvGRmx5hjQgEAxcWPmtn+8STSpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > +				       struct vm_area_struct *vma)
> > > +{
> > > +	struct inode *inode = file_inode(vma->vm_file);
> > > +
> > > +	filemap_remove_folio(folio);
> > > +	shmem_recalc_inode(inode, 0, 0);
> > >  	folio_unlock(folio);
> > > -	folio_put(folio);
> > > -out_unacct_blocks:
> > > -	shmem_inode_unacct_blocks(inode, 1);
> > 
> > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> 
> This is handled by shmem_recalc_inode(inode, 0, 0).

IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
accounting in the failure paths here.

OTOH, we still need to maintain accounting for the rest things with
correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
testing this series against either shmem quota support (since 2023, IIUC
it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
"size" mount option), etc.  Any of those should reflect a difference if my
understanding is correct.

So IIUC we still need the unacct_blocks(), please kindly help double check.

Thanks,

-- 
Peter Xu


