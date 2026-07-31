Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC8FC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE9D6B00A3; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C166B00A6; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71546B00A3; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD2F6B00A3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9339A1204A5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:43:49 +0000 (UTC)
X-FDA: 85049643378.25.66DD0C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D8A74000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:43:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9nXScPb;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785516227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lSuYcaNlXmC2iii63pednXBAuDRAZROOC8ripxWX5Fw=;
	b=oYo+usze2BHeTdgGiOCsq2qVDw/2xCV+Jjc80eHAlSwc3tfn+EBep9AuySl08xx7pgCwmf
	/DWplpzLH3vSrf3AxtMSmt/lHHzN/kfXjUEcfXwwAkCLbEq3qQUaZTERTtC7YuhEW2AsDN
	T1wK0h5zXXFETz3Q0Umvq29BfrDa26M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9nXScPb;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785516227;
	b=xqjevp5RV4E60oMed8x38Fv8zbSFHKtBJfqJPGGRdurcGsz3jfRemlLaD0GSiZAPUy13Ra
	+kl4bAtiu3EsaFcYsL70KiA8IAaj7JcgskG/U9QMOj1qWAt9AioWBLMGdCWbnHVhKJrBUR
	y9a6agMhjpq7vgpCf9slQuuWUaq3B/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785516226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lSuYcaNlXmC2iii63pednXBAuDRAZROOC8ripxWX5Fw=;
	b=Q9nXScPbp3FqklxVoPZAiKjvAtgqi8UBlgPDfDvtGFFyN7R2QVj2JZeOR8Cesm1FSi3mr8
	/m0n+J+f3tW0F9h6l7IaTJuf4ZipxCgQtxRDoO5JMadbmO5SH14m7YZYYCCa1DXtzNFY/D
	eCmnYfsPslwbc/gAYU3K1gNRjO4XRLY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-78mVl1ibMY-YkSjw6UAbiA-1; Fri, 31 Jul 2026 12:43:45 -0400
X-MC-Unique: 78mVl1ibMY-YkSjw6UAbiA-1
X-Mimecast-MFC-AGG-ID: 78mVl1ibMY-YkSjw6UAbiA_1785516224
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15eb4015e7so134617866b.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516224; x=1786121024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lSuYcaNlXmC2iii63pednXBAuDRAZROOC8ripxWX5Fw=;
        b=Vxd5LGa8A/xA6HE+tRA3rlTqTNUSzBQ5JoNDdzgKoJ8RGsjIaoICFNjFA0M/vTCYVn
         aoZTPdzgagSKLXKWj6ZwRURY0SBaOmYcAyHgzrEANji6NCzEU+Lnezb7HqX4Oy7PyaB3
         OZDxYhspVGchRWUuPzSTiFBIIfs8UXpb9t0mcz9fCCZsry3KDu6cC1fQzpnTeK+TXvoT
         KKGVFU+NhhYwS6qr86zFk8D7c/lAODUn2SjlmfZIKnH7kfaT8fAt1OlsAOjcPMYlY3nr
         PUzSLlgt45pMlAVyzhb8RSQIlSeYS0N4v7PQ/dvJrpCV6p9ZD892HA6uZGXqh226kgBb
         cNwg==
X-Forwarded-Encrypted: i=1; AHgh+RqXuz17GSSNmu+8xpXZcN4IrAervvujxq8TX0NbvyzG1RUdboYoYzyc/zZvTnBcVrGfTMlo+TRFxQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4wZInp94BXZG1XAPmwcEbj/XF2tydQtPqQ1LqXpj1ZYKQK1we
	qhMDOl0j6dCVEZQ6jybeAuH+EQ+evPHchK1C+3hA4WDSrlSBYMbqAMZSLy5Nq/bDnUcJv+QDETz
	rZ3heGK3Ovm9dy9yE9w7eXtOd6FC5piaoQJPokgtaLa/l+iZ7HJok
X-Gm-Gg: AR+sD11KDuI3ClgV3NJgUnAJHmwwJ1PXiizBvV02vfe6P8B3yR0UREmj683OaodNfsy
	mKBKdigxFcQun2nEwKPBQ4wy+zi5LT49V9dPatJtvTG4pvn7nLuU//C408syqF3TDRtx3GRsvBL
	kW2m6mRMWYKWorJTgOYYJGIdazdctkUrnHyWt9f35NXQf92qlZhkIBV/HmduTwTm510Ht7sJ6cp
	MTzKALez5/4/zNeASqMA2h6eIAKMdm/h30Ju/q+3RM1y5PwyCtSmcHBSTSOpEyNEfNaa7cZQPG4
	nrePPoIA8FjmM/0MPrsdXUyOsYuF22UqIBzEMekyZqmOVHZtPIPJHLKt9VG6LHyDEpbMURKj67x
	Mu5/AL5Iyc3UfgWkmRX+GiSpB0XUoDaunb+S5U/OUXBmegoaMkaJsAQvIGJGSKHwxWdzjOijxlN
	m6Buo=
X-Received: by 2002:a17:907:e001:20b0:c1f:7c45:2dfa with SMTP id a640c23a62f3a-c1fe7ea4b7cmr19853766b.7.1785516224120;
        Fri, 31 Jul 2026 09:43:44 -0700 (PDT)
X-Received: by 2002:a17:907:e001:20b0:c1f:7c45:2dfa with SMTP id a640c23a62f3a-c1fe7ea4b7cmr19852166b.7.1785516223725;
        Fri, 31 Jul 2026 09:43:43 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd455ab7dsm206911266b.58.2026.07.31.09.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:43:43 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Sergio Lopez <slp@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	bcm-kernel-feedback-list@broadcom.com,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be followed by .pfn_mkwrite() for write faults
Date: Fri, 31 Jul 2026 18:43:38 +0200
Message-ID: <20260731164341.1109827-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dlG52PK2EKsN70yOwsIsFPUraaetZglafDM23ETsStw_1785516224
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D8A74000F
X-Stat-Signature: 4fxu5n351mkqpqokj9efhzcqhra59tch
X-HE-Tag: 1785516227-557135
X-HE-Meta: U2FsdGVkX19sN0FAd/Um0PmXh40t9eO69EI3mr9qjyHicwoM1ZsZ7MENoFf7SGif2PBVmq4mW8n9a1rUpkzPDlZ5eyyeuMSb4bmrHVfjOE2QKReQOitCsxktSSg5d6/qhD3SvjsURZLCULPhEdpVkkNf5oLmdNWLpwFNOGgBRxZrO91OcNu1Fv99YuF5HsPPfLAaPuSmxMUUMXZ97cJ4KBeLZwPtaabQTgZe+HFhko+vqb4+hvccqa6WQ48XiQvchd6PhTcXxEV19t0GQZ+KiOVr/gh7bO/JPEbMdKZGO8ZP3wBwrFOY0yycesUhJGhHi7dL8pa80jzLsx4BDF8tUD038UikCE8UBCsDQoxU1XHYieS9HzQo18NxZ9heRGa8FzBzn5XqNRdJiSu2WaWrPDU9dT2AjSCSRc8/2Uts6LXZzWljq4CHvH/quYREwBhcWEuK4Fnq15ZhabSV6guhW3Qe41P702f+fShq1mS/Sbj5nZABYNjS3XjXfVPm9qvctEMoA/8Voz1mFknt+05KbSJE9BzKkg//yRFKnnNJFrkkJLfDQzosp1SfdlXgKokU7s2rQbsSztFqaw4SKUcrQp3Wsv7hChZSVpWqLob4KUpb+p4VWpKiLgKq4IUdJReYoK1ASJq0iNDiA+KGeeXVj3O3/2UDeXm2lLuQXCz61oSlRyoquuZLrBiDxFdH1nlknWFa7STDmLChbQf0JJJWBT1ChMd3RFNVdX4U+Wsre7m3qPXIzMP3zumjjPFptqihTArPlHuZeppD8LamxAP+vuZEC1PDk3bUXdOryk+5A4TkxfjuP0TI3vx1tztrnn5D6LCwHGwtFfiddKxRXIOwdgCfOR4DvESZHxQxAPwS/B7qnH+3K3/55JsowQYiblYbk4KsfRLNvK1nWNWNfy1OJlBtAcuvqtAw4f6oKE923lgoPpWvqBkHQif/qswDFooS9LZ9lFasUW7y632G3IO
 NVmf7O+2
 XjVT16nb7nTZjwdrMtyWmSYdHBA0WljNrAzTJEuWJxWDwh56pvTZpoZN806qRlY2+XcVJdYKlKmQ8HOy3WcmB3xWdRuOx8HJW9Qw6xHSm5kUviQalf8fvUNqHamI9cNvzG5658i4llpPAiiHnq4ZsR4cYQ4MhTyKT/YAJT6xhwAaVpaOMZ8LdjhZXH0fgLiintHt/TrB9S9DoM5I9+fe+/5OfC1GlknjMCnL4R43vHV72pwARYppiUiv7/rsvFA+oviCe68VQ5/6fd7FEqWk0+A1b06hkuVCdPSZ0DCqRMxRNmWz/7cORZxsQYIrWDS4PRiIaLlPNL9nQSs3z6PhWEtqZEDFw5j0cyfIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Warning - DRM parts (i.e. most of the patches) untested; I have Cc'd
the reporter to help with testing these patches.

Right now, users of .pfn_mkwrite() have no way to create a PTE
that has gone through maybe_mkwrite().  Because vma_set_page_prot()
will have cleared the writable PTE bit, users of fixup_user_fault()
will see a read-only PTE and have no clue that the page needs
a *second* fault to reach its final status.

Handling this in fixup_user_fault() is problematic: the information
about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
which is an opaque pgprot_t, therefore only follow_pfnmap_start()
knows how to retrieve it.

There are actually some preexisting functions that suggest how
this is supposed to be handled, namely vmf_insert_page_mkwrite() and
vmf_insert_pfn_pmd().  So, this series adjusts mm/memory.c to export
two new functions vmf_insert_pfn_mkwrite() and __vmf_insert_pfn_prot(),
and then teaches drm's two users of .pfn_mkwrite() to call them.  Let
me know if I should use another name like vmf_insert_pfn_prot_mkwrite(),
instead of the "__"-prefixed one.

The drm_gem_shmem_helper case was reported as a KVM regression, while
the vmwgfx one was found by inspection of .pfn_mkwrite() implementors.

Thanks,

Paolo

Paolo Bonzini (3):
  mm: export variants of vmf_insert_pfn* for use with pfn_mkwrite()
  drm/shmem_helper: use vmf_insert_pfn_mkwrite()
  drm/ttm, drm/vmwgfx: directly create writable PTEs when mkwrite is
    in use

 drivers/gpu/drm/drm_gem_shmem_helper.c     | 38 +++++------
 drivers/gpu/drm/ttm/ttm_bo_vm.c            |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 44 +++++++------
 include/linux/mm.h                         |  4 ++
 mm/huge_memory.c                           |  2 +-
 mm/memory.c                                | 75 ++++++++++++++++------
 6 files changed, 107 insertions(+), 59 deletions(-)

-- 
2.55.0


