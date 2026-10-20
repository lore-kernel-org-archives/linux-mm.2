Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D835C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=dJyet3W7
Received: by kanga.kvack.org (Postfix)
	id 0C0696B053D; Tue, 20 Oct 2026 13:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0711D6B053E; Tue, 20 Oct 2026 13:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1F26B053F; Tue, 20 Oct 2026 13:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C39546B053D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:28:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 502BE1602C1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:28:33 +0000 (UTC)
X-FDA: 85343688906.09.E10E92C
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AE1AC0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:28:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dJyet3W7;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517311;
	b=TxWSsmh3QODOjS3SrE/RBSrqumHJ8N9lmd/Mx+SrhrHRa4S60bPG4/VahzzkpnB+uq0GuY
	INfk+PrnbxfTryVQlFw6n3qbpJGQ5gfTr5eCz6nH+TKl5pdTpNHnyDZ8CSmXuVru1yD1fe
	2MiSEgPnTH/eHEOr7tM7I/w4B6afYbU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dJyet3W7;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd2xn7InKp+SrI7s/BHBhFnK8Dcvi3AeSU04cbSblZ4=;
	b=afUJTbsMzlttwdu53Wqu2mQRhAy12Qj+dfdP275zI0ZOKVOq2eCirwqnqzl+Ycq3UlEjQK
	yGceo9ssRQ7XhYJD5zO9KqvSPXat1FkHL15rc7P3batWxg50/5pFk3ftwjxWnxiKyrF+MV
	VuH6kdQQNc77pNv9wg8RwHod7zJ3uaU=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e55db58cfso291370385a.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792517310; x=1793122110; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xd2xn7InKp+SrI7s/BHBhFnK8Dcvi3AeSU04cbSblZ4=;
        b=dJyet3W7rv9i+zzlbo3m5KQXo0fxHRaLCegf0T28EVp/qF1Y6aYASJTBMi6xQw72F3
         jjWHx0Ern1DYLOsehUlESlp/GMaB6+zimPkRwDpALzEIgkaPUeODaxpg0sioupGVPj2c
         cum/DpfFruozk0E5v+hJM1n6pjGOXmwFbH1pldFIOJt+rPVcPQSmS9+jBfH81HyEFzjY
         eNLsWsgCH35NHSdz4IhkCVNbttMhSfg8IpWJNTI83kvEQdN7w6FGdOcEktSHgcJLw3ms
         F2Vl9dOcxNj+GLMHPL5VHPrx8aPoCGwkbAgp+yuG9t45iYhJfpasGCY3Vp6KrlN0nwpW
         KXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792517310; x=1793122110;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xd2xn7InKp+SrI7s/BHBhFnK8Dcvi3AeSU04cbSblZ4=;
        b=E6VSDYlibfBhzTZ9rEirQPr7Dn8ONY/f8zak+Xw6Ao9gy73IW+nTE+ZAHsZjYmNThx
         XDA4IbXHXYI15HWT6dCaSZkT5RvoJ9t0pNVIaJKe0B4lokeKkN5GsoLqxbh+WBZOgFIS
         bXuZXzJFNTS3vBO+3L78vm4HULzF1f1diCUDqvRVnFHYQmAx4qDkX/bEINOMMtDRT8I5
         s91+nugnwo2XJyN6rr1YfMEGnoAJfRhQR1DFz9tofn4xMoS5fPp/r8SvbldD9OJ5FUWf
         wZZNgJ7KI5zlAE1dpoghdv8GdgIigu/6Z1HFXD/ubKnL8GYr5s7Gc43ghTEVmQZqd+hs
         W1WA==
X-Forwarded-Encrypted: i=1; AKwUvByzbsKosjs6nXWIjmF1uWnxCT+c7NYqY8o7FNFulsqtBAwkG5kZhrmsXGTFo1zeUBmWKsJbuKKjTQ==@kvack.org
X-Gm-Message-State: AFq9FYJzu/LI0E2mFUz6VfEOLrZeO4FE9WTvVKVFg7UOKOPAnlbpTU+/
	WafDIe9e32m5/5FVUjks8kB403Vv7AFqkBkMsfcbZedeJJ/foGTk7NSI2YQhNBeDrzY=
X-Gm-Gg: AYBFou3PUvVtUPHf7DJ48oScovNuooFh2/vwcuUrsO7xA58+c6vbZJFw+bas/akyc1+
	miSE881S/VlA4xoqigwouuz/qLX8odZ9sl//cWkwnUdubWHNGbnmKs3WTAmlrri6a0mPUV2bsjo
	+3A38Vlgj/QhklZ/atILXejHrlgQyrliUcKHC9AcMobe24Q5xjYZuGra9hB7GPUx+e27IY8wt6T
	0zRrdLaKOO1pssqHTDgwIbtJztiFZs1gM50XIhf2xdP9GuI8ZjQtw3NRAUaOgLoASgAS0QcD3Uz
	pOaV9QoqxG8BuLdpgF8klXYqoJUc1B1lrc2Rv2DyJYHouMoIYVamAn3v793oeH8Vi1lK2VwGHNK
	nb3HIL0ThzG/OCHp9BxE3jNKabJIwnyJYjtpsbWdqqhBcum7Um7a0TDk8cfWQ0kIF7+t+vI6u5X
	eQUVFtDQj9ylpsQ0akSWv0eydvluRwX78clFr7oY6Yx5Sytb8QxUXlRAFwwzTIexoQOzLGvQJXl
	5Th6dxNUjfO9mU+vdPoeqCTauGLgA8CtfNlHt1T8WNHxjMoNM/x9uvh
X-Received: by 2002:a05:620a:44c3:b0:93e:c12c:9b70 with SMTP id af79cd13be357-93f29df45b9mr1944842885a.75.1792517310522;
        Tue, 20 Oct 2026 10:28:30 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10b72cfdsm3288526d6.12.2026.10.20.10.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 10:28:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, shaos <shawnq1@163.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
Date: Tue, 20 Oct 2026 13:27:36 -0400
Message-Id: <179251725685.2936366.12518786742522387392.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AE1AC0003
X-Stat-Signature: muqssu8gyo7row5ddtpikixfxz6yag73
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792517311-26495
X-HE-Meta: U2FsdGVkX19bWz/D4UwAItGkWMkj4JESEF8M0ipsUyXZCSSmf7vtgjs9DgfCHY8Q+OBkrczgkfMbfSkSBgImtMWDsq+hT6QD8klapFw6gVKu2dRsZku1Vk9MBojhLO1cC2vxhszwZ43IpuMfJKT3xkWJsXSHt9iRodTrueoDyhfBASKNFmI9dRPWA+ua8eWQmBmOD3xip8fKVIcxUCjoksRMHeNhYkP7j02BiMRg3FXwHA4Ve0VfsOw4cvd34KEr0apqSVj1mh6IHb//tnXo5HA5BAdyrokUgvaGIg3+dYRM7wD2JIsYDttkYtbZD+QVZ9zrtc8fLRb5zKT3ygkwmSxg5k6Ke/AlxwSc4bOR8z2jrEhSG96o6X8uSBmquCxo0/Nc4sIZQZs/MGu4+rShcoWesjgdKb4b4FadW7cCJCOJ43qSMZxeOtavO8KzxGyw0pHCEbpoAcuB9BL3sEjg80bgU+19XLyZggo5qRxe9OtwV30axkHz6295jXdiWdu1NV79rqChlUj57M9hQ7u5wrjn+5RuE+M/wNRzTRd61KuAUJe4ddzztGdr42A91gOk3pwdfs0NDPj9Q2Bfoe8kmMaXOMOBPrldOWBBVGG3Nqg1waWQ2QGfHOyhuBdT4SKk/+YqbEEgCoC41kJN4IV1vkWuFACoOQ5qyC1dQPvobWDyXIyUmu76/h0e0rme8cg7neT87gg2VTmKvi5GcZKfnvuxAq3hvGNzx981ULC0fA6JMl05jeUW3DoDiLyO09U+OUjnGQy0KMjIkmHuGjApHR1t/cIY6EZRCDcmMy12RIDUorA7TQh62RPuEwtz37cmTaqLsl9Mnb91cD4Sa4/fa8GFp78s9zuswUfo3D/Kf+PMvFvXrCqLNlsuQ/fLCS36+Oi2XUK4FCjkNcEGXUc6Z1GBaG+0BiWJcSZFiVlO6sHhLUlMCXpIk3C1MyjEBcXXN6xkf8zPbZgljiUBAvu
 b2MgyQU+
 c+SBfG8Ow91vy6D6Xn6jpQcF/UVilLDvm4V45WZke1bEhsdo+MlEob32ALqJuxcX6oqSq42ny5bq/pSy1KN+m8Y5K+2g4ZmE4p3wKUROAFs3L5Ct1p3bgdXkeB0w2YUx2EfuB7hbRDdcHtrw+NiR/dJuRlig8WBd2M/2g8LMTRJofxaCerloA+EEAfPXsEluTeXGaaQeb+J0WzFgIsmDUXqBO+kxC8z0bVuJg7LezLeAbqmtxH0KfnFb05qJd6OFevwSfI771aHw4Tk7yD55rG/YQmzCk0AOifnPRNYW0NyEuJJDBxLgP6FyApVQeSzJFUW+7weiWqZLq5CC0Fj/ldqaxW202jt2f8ESFDSnqI30glpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 15:55 +0100, Lorenzo Stoakes (ARM) wrote:
> Userfaultfd often causes unexpected interactions within mm, and does so at
> the intersection of uffd, mremap() and VMA merging.
> 
> When an mremap of a VMA occurs, copy_vma_and_data() calls
> mremap_userfaultfd_prep() to notify uffd of this.
> 
> However, mremap_userfaultfd_prep() simply drops the UFFD context for the
> VMA if the user did not register it for remap, i.e. didn't specify the
> UFFD_FEATURE_EVENT_REMAP flag.
> 
> This is OK for the VMA itself, as upon page table move, move_ptes() clears
> UFFD page table flags, using vma_has_uffd_without_event_remap() to
> determine whether to do so.
> 
> However, this doesn't account for merging with adjacent VMAs, whose page
> tables won't have received this treatment, and thus latent UFFD markers
> will be left around.
> 
> Worse, it'll break UFFD for any VMAs it is merged with. This is very
> surprising behaviour for a user, who will then simply not receive UFFD
> events for VMAs they ought to.
> 
> Resolve the issue by explicitly checking for this case via
> vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
> function explicitly designated for mremap() operations.
> 
> Also update the userland VMA tests accordingly.
> 
> Reported-by: shaos <shawnq1@163.com>
> Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
> Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

