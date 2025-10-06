Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7392CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 19:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218FA8E001C; Mon,  6 Oct 2025 15:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0698E0002; Mon,  6 Oct 2025 15:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106C68E001C; Mon,  6 Oct 2025 15:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 006CC8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:49:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 915CA119F24
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:49:48 +0000 (UTC)
X-FDA: 83968729656.20.3BDCE8B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 51E131C0015
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:49:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hGzSGNsB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddWWDzcyU6VNTUT+j+vF95nhn9qOKIedBtN8VsfvaLc=;
	b=lG0w6zjTuX1e/YpJ43x6Rb+hp2s/w7mM3cBf0mVhftnWJ2g8Od9Fq+X/tXGJvChHlwMqGM
	7xPszNZucyUTdrwafGdE2i0TMF7rIPzKEMJ+/m9XGJuqJ4cY4a8/rLOvwRcsweABFysKCu
	rOiQdR/qjliakwal6gPzEpcuxVevbOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780186; a=rsa-sha256;
	cv=none;
	b=ELCrqwo2hneDGFbIhT+h45QbJEHiq/j6MBpBrKI+wTMHFUJ7VtU5xNHq5Y1ZJY9D0jgNHt
	v//BnfE3ESNDfrKiBfgkTf+oAut5bm19PV2ZS1buICetl/jdBKpf9tmKrDNuORNCHMhDml
	THjz1z8bDn2D1UXu4dTvDpdLxgDx67Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hGzSGNsB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759780185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ddWWDzcyU6VNTUT+j+vF95nhn9qOKIedBtN8VsfvaLc=;
	b=hGzSGNsBFlQlINHSUAEe3eXuWi/xk+Ps64cKHJeVqkuzMs9TtclvLXPI7/iEVGHlBOJlvA
	EW50aKoUB+4ktEhJEN7A/1IHQpUQMMTefjfXJygbXUdcTW9S63uXgr+och9TlCDlNozFmU
	PGGnjk1uo9Ap9jpjbxhD+33cV++oUaU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-haBYGMwtMeuZRFmqllpOzg-1; Mon, 06 Oct 2025 15:49:44 -0400
X-MC-Unique: haBYGMwtMeuZRFmqllpOzg-1
X-Mimecast-MFC-AGG-ID: haBYGMwtMeuZRFmqllpOzg_1759780184
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-818c83e607bso60508166d6.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 12:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780184; x=1760384984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddWWDzcyU6VNTUT+j+vF95nhn9qOKIedBtN8VsfvaLc=;
        b=UwfOoQm12g6HYK5dtQH1GHNuWLkHzYEe6rlg5FYkVVwW8Uj0QDnj1hfw+ajNED69la
         Qi4gYKzTbu9ZQNG7KdGKVQevp4Ea0xq8Pvt/Co0w9/OAs7TP7GxgxSah8qSn9dOsAeg7
         dMOo1kOhdoOLj4k4gc47w1b+3H7ymPZoqgAKcrbhAsR3GCEcahwaMxwoichf2WKpJUjo
         W3CVJm2yyxTnwhcyNd1hd0o7Kok+Kh1797iM7QGMauPS7iueVgCYs8dt5AM8zEdDrcZe
         eMlI6GRmUILPrfdyBAxKOH6LxsW48Y+HRsgJ4iAmc2c6i4zvbdvEtc553XXAPX0Nx5KC
         6kjg==
X-Forwarded-Encrypted: i=1; AJvYcCUpvI4+FirssmS4IwXRpSRj7t+rNXKETVcjISiLWQEaR31mRQ/LPY6o74bu4px3YDr0FjTlyVKEIA==@kvack.org
X-Gm-Message-State: AOJu0YwsHcvB+CgQtU5VUlDm/wLdPGwjFm7pp7wdk1LpwPmG1fW5Bo6k
	qYEm27xulX/WARDwekjqpRkr4qYSsZfjHILytA6W4kgGnavL5qHo35GI2538wB2QaE6bIXj1DfA
	DAONkdcLhxKU2qI4SVqZLp2dFbctA0IY7MwzzmwkGqnMcWgPAhyzW
X-Gm-Gg: ASbGncsDD1dxJYyemCAbBVDm2Q3WEWmIqFNzSYN9ktVzxE1HLQVmrXfTgpGRLv/FtZ3
	1nFJ9b+gmhYY7QFw5Ki6sqomRcs44i/WlNg2JAlgRsd3oIe4WSHbagiPbIbT6DXwpQrspCYP/MF
	khGGbJGjBrkKZk7Jn2kFpqrcAe4SqDS4u3Uwj787C0Ax9npioLZC5rUbK5bS9AZs7NbrXZ2WEaB
	ck8kbrcD6yhl8KH+KJ9F+8ux+YqHkiL/vd++HkDyvroMXNyVr6JnPhdC8GIzgnywcQBrKacTSVv
	qF4gny7/YP7pYFyUTbbH2UjRjYNLiyGytdffaA==
X-Received: by 2002:a05:6214:410f:b0:782:91b4:651 with SMTP id 6a1803df08f44-879dc7d1648mr158154946d6.15.1759780183694;
        Mon, 06 Oct 2025 12:49:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW5HGRg6VjNoMiKzsPi0ZLkMbO537Cp/Pqk9bqBmDBoMktrxv9OoQzVETHcZvFyCFiUijVXg==
X-Received: by 2002:a05:6214:410f:b0:782:91b4:651 with SMTP id 6a1803df08f44-879dc7d1648mr158154716d6.15.1759780183162;
        Mon, 06 Oct 2025 12:49:43 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bd786769sm129105346d6.31.2025.10.06.12.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 12:49:42 -0700 (PDT)
Date: Mon, 6 Oct 2025 15:49:40 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
	jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <aOQdVILmD-4Odjs5@x1.local>
References: <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
 <aOBWF8uLmm9iQ2XG@x1.local>
 <872c98fa-56d8-45cc-a7d2-1b8d44614640@redhat.com>
MIME-Version: 1.0
In-Reply-To: <872c98fa-56d8-45cc-a7d2-1b8d44614640@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8Ey1anz9YMsXDzwnM7odXm_5gVKusIcRjZ4XppIhpjk_1759780184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Stat-Signature: kgryxc7k3fqqutxkmfzhjckkbpya1rsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 51E131C0015
X-HE-Tag: 1759780186-793995
X-HE-Meta: U2FsdGVkX1+kbMJwEkGh+HEq5vdEcjyiXdNqiCdunjFoWlu3Gmq40WWBQDlu3mUIRn5cEUUeOaTCY8XutP+EbE+M6E3TNyt6W6+yfRtij+GmQcvwiHj+MZFaUamLgdO8xwnbmi97GENdznoDpq0If2d8jDzRt5lh1TVmYn5On9SGGK3rJUTFQGpHvlVcmxSW0b4LQpbvkq+tg+ZNslaR4/SVHWZFB3Ordg1aVuNnz1hhtaZnbQiueBNJGBrPVPX+JMm7av6QJmzXiM2PsXIWDpqxltcPCETIKCfqhd5PY/rdD2nzj0PCEF+59ARwmKnuJpMXMNH9AQh+3jXVp1kzbn307nUyMgPrUlChIpnH/qn0V+iKUhV1itkzy4LErRd81nkepymeMvWAfFttinybPo5V3IC+1r3PD0s1kRoHAyBJpMeIpRbeKHi1DsqRCJmqicP2U0aLbQOfq9V0xO8NVNLJd5CykUFjHL4tvzHbEjGQ0K7Zq3EiEQK7FoRHlKZs32mEqwaevCAQ+w4i7lwQeGVo7GgF6wQYtLGB3OlZ7i0MqO/CoRmdvNIUuu2hYT0/nZEclsK1V0T/OqSoKfZv7nv+q+yrAJkcrLsDCLN/fDjEae1wGMU0kjmfPE3Ai4MF3t1rZ94b5M8b59NgoR+xrkJNfxto8HnoxQj3oxeXbwJw5KTC/C1jlHqnBwVqmlATqkAmR3jWQqLEzhNkXzd2gyBWXqUJ/ekLxomYzNrT63NVT4VfaIcfukpaGgbQhk7Hpp+PxJX2G75n0Ki9l2g5CuSrjv2Lyp2hZGjxB+B8AwcyxHHwKYXZPr6CxIWq9Wtmt8BJQ7YBhx7/UA2FYd1+ZNAHkhKRSpC0ez98OTbTFbwIHtqbW9fLAoX7X7tnNIvXRk1Vnm9nNs6yTUpGd/dvh5zVSqTcIg6VgcTWMnbjC1/tKXZexx+pFLVYZJhMulVqvgfnAAZDuSHJuFNFPer
 BrCHqBlK
 DxGEG+Bj/dSjgwQxvbphRTwIgiCdXC7AlHe0Tfi/isRMlNyiu1bTY0MIwxKNRHIhUYuV89UhINNdC0pM2nyDh2sN0z1mEolU/pJVwr0tuKJE38sybQMHBsOHXuIqxSXzItfkcyfASf1WUHC/z1Pgx0RpvKfRUP9+RIRXuyjFhnDNSFQueXQpJKhm1f66bYCLThL6A6U3pxohLrpjVN6A7K+JkM8hi0LA0ewEhhaOKU24ZP9X4J+gKTRIHOFRE2IqWp+RBkDojY+GtTh6lPGLJZWqEQG7+Wfl8UxJM8JEjtHg8CRqPR1abH4QyXypfegL6mFIPF4tfEhFMvs+9ce/tceBGdRdBtm196ou4mwtVtmaiX5GtojoTXSNgZhEg5pHOybdN4Hxyz/LtD4c1GoxUY/5CmTfjmCYvv6uUYLPs+JVeUOycF/P9Ywv/p6stxnS8I61FidJyALjNUuIcE7fz/gFXH1Hi8MZxrpqt3qA1X+UAMdR9GPk4Ceuin69xytZs+Rcr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 08:43:17AM +0200, David Hildenbrand wrote:
> On 04.10.25 01:02, Peter Xu wrote:
> > On Thu, Oct 02, 2025 at 09:22:45AM +0200, David Hildenbrand wrote:
> > > Staring at mf_generic_kill_procs() once again, we have this
> > > 
> > > switch (pgmap->type) {
> > > case MEMORY_DEVICE_PRIVATE:
> > > case MEMORY_DEVICE_COHERENT:
> > > 	rc = -ENXIO;
> > > 	goto unlock;
> > > ...
> > > }
> > > 
> > > IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should
> > > actually not succeed in this function and just abort.
> > 
> > The doc says:
> > 
> >   * MEMORY_DEVICE_PRIVATE:
> >   * Device memory that is not directly addressable by the CPU: CPU can neither
> >   * read nor write private memory. In this case, we do still have struct pages
> >   * backing the device memory. Doing so simplifies the implementation, but it is
> >   * important to remember that there are certain points at which the struct page
> >   * must be treated as an opaque object, rather than a "normal" struct page.
> > 
> > It does not intepret to anon private memories, but something that the cpu
> > cannot access..
> 
> I would not trust the docs that much ;)
> 
> We establish device-private folios when a driver requests to migrate an
> ordinary (non-zone-device) anonymous folio to device-private memory (e.g.,
> due to a device page fault).
> 
> When the CPU re-accesses that memory, we spot a device-private entry and
> trigger migration back from device-private memory to ordinary
> (CPU-accessible) RAM.
> 
> The latter is triggered in do_swap_page() where we handle
> is_device_private_entry() to call pgmap->ops->migrate_to_ram(vmf);
> 
> For migration and everything around that to work, obviously the
> device-private page also must be anonymous.
> 
> It'a s bit more obvious in copy_nonpresent_pte() where we call
> folio_try_dup_anon_rmap_pte() for is_device_private_entry(), because these
> are just anonymous folios.

Ah, I actually didn't expect folio_test_anon() will return true for the
ZONE_DEVICE folios that replaced a previously private anon folios..

To me, that was only some housekeeping for the ZONE_DEVICE folios
remembering the mapping/index/... somewhere, so that when they got migrated
back to private anon we know how to recover these things.  It doesn't mean
it's a "real" anon private?  After all, it's a ZONE_DEVICE folio, and the
memmap does not 1:1 maps to some RAM backends.

But I confess I'm not familiar with these.  Fortunately, I think either way
it doesn't seem to affect the design of the series being reviewed.

Thanks,

-- 
Peter Xu


