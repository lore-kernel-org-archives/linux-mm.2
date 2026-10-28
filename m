Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B4F606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=jmMcT/GW
Received: by kanga.kvack.org (Postfix)
	id 553AF6B05B2; Wed, 28 Oct 2026 13:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD396B05B3; Wed, 28 Oct 2026 13:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4606B05B4; Wed, 28 Oct 2026 13:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 002786B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:47:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE430A72BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:47:16 +0000 (UTC)
X-FDA: 85372766472.19.B34B294
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BEF240006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:47:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jmMcT/GW";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793209635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
	b=EZZFbU4HxSs7cQf7uwRZC1RNSMWQoI9KFrDi2qUc/2urMzvlo9V6yfobmPbGbXCVDZCbQ8
	xyEbSxfd3NLN0VTEb5+Ko1aCJov/TUk0JAmvmn81d4H6fJxH3psd8QFY6lEYdwPHuxNGFu
	V76p5F5k7c5Cxsh730B3l5/ZMIRrn9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793209635;
	b=5Sg2RttumVnjVeSJKhvMIAdfKO10XGWRLutJAN3o5lPXZr/7OqdpXnOmLuyfFK00721R45
	bphz6z5v1qkx2C/i+0+GzJUAbKq1y160CySw8gmW1ALhYuvWepwRFlwj5EjIj7z62NlC9l
	uECWHsdyMYVv9/CJpGS0U2+J6/xZAlY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jmMcT/GW";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eac7220e9cso565658e0c.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793209634; x=1793814434; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
        b=jmMcT/GWAwPWN1QRDg1xKlmKmuN088qGhOikVXkUE4A+JUZjW0iXN77rm0YwaOAmWJ
         VlJWyFsPB2P8sHawN2IDcjjd7tDB1D46ftLMMoG2K268zvUJMhNbmcEnS1wFwOFJMYJl
         wFBZ8xZ7rp2LcQBKwH+CBe/CMKVhDv35U9m1XDJX3ROIFl6DTbBgjANSnTnEtizcPk7x
         HvrmbnnEwDkaEfI1O1YCfAa9wD0ExQsUoTiE4tdkAJnQgrznWQgJkYh0aztBc6xmAEum
         mGDvMJha+LYzSQeK08ul9rb27jvnT1yB4KD1vOAGBmE92WFCotNcJvOBZJJgLizPlIsO
         RHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209634; x=1793814434;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
        b=qGvWYT8EcvBxgNJPTHYDUke37vVtUqL3LC73KyJnuq1iwgCjbzSSRUOJsfdwfEklIQ
         +jE2WXYNZJSgDIXmk8smtMXtMEO+h4TfiThy5IAFaOeEuLeo/j4rPJqwvdbTcl5XRcl2
         PRpclpwRF08oBte8yb+kVdHAOcmCwdJkb6FjsfbRImb+bcHzRTU27foxhZx+eFuqWL7m
         8PYIzyvj+UuObRjCt005juhHL4/o00MLehCP4ZWZxcMHVyYNjxtUUZ8A3ITnDMcx1JOe
         ATl9gftTMyHH4ClopAIehyBSU55p3L3WBj4fME1OV+kFgbgNGhFNOs7ITIKNsyjqFoYk
         0gRw==
X-Forwarded-Encrypted: i=1; AKwUvBx3tIyUKPzHcoVQnqAWN9RQ88jgtDUk5Bj7iBKjlxz49Jomor5FzkqHRuDjjNGyI7ZazeScKV2LrA==@kvack.org
X-Gm-Message-State: AFq9FYLr6UuAauHYHje7ANFd/W6QUh2fQM0/PTGF1kKHr8/tmKL5QCEm
	qxy//B9m3ud57axyWGqbqOIapJwAwG14sqHpHJdaNuYFLe8a4ytJ+9XKspn1CEuTnUE=
X-Gm-Gg: AYBFou1dm0hwcZ/Ms6gdFn6jBRMn0QWkTYQhFE1FaxhtuOBzZR38QRm26phGP4652bc
	CrCb7D3X0d6LCj0dHVJ7mJDK39yR6vbUEk6sT7TB/RhXN1cWimCAMdDLqaPbRFF5tYdggaC16b9
	DccxreqZVB3Elx7yp1GVb7lPbnTLEC5CLY33rEx7uw4lqkzQ0QwCbFtnk8jfLrIAry/pVufK6/0
	7zWlTxr/3lVvoqwpQUHK40+PnESP0VGeVZEgoIwDNRaVqvM09IFoADvU0NBPB7zfE5dyFIp5qkn
	YFho79nOtTSMCrBv7W7wlE/QSzViCIPaxPJq3/tcx5bviKBGndzmBAHelYqmcqjZ8gCcAlnhCSj
	RnMfY+8y8fTEM/yoV855QgcYd3A4zIZDg4BcNIUoyjnc6rBeyFxZPTTZ+lH7jCinkDlrlc7sjjJ
	YMUnDnNzbyfQzCNVhk3CpJQIHPT40Pgc0POBwmXopWsHeq4x57PMfhicKl76TbuwXOFYYgOWgCu
	7rGUv1H71xdF0QQtueykyab0B2IakdXcyRLvqS1UoDchRdsMskourX+ehK5U4pToeGvVUuSA6gI
	wE1a6x6+S+Cyt00l0ZpHQ215Z40wLyotr2xjd5Qz6xQtVfK9T7fSDvyWBMrWOhla/XER9gtu6Zq
	EEUipGn/4owR0WDNE9ZXALjETTd1+An2368VE7YWrvnr9TjBzoITGcQ==
X-Received: by 2002:a05:6122:2896:b0:5ea:fae8:e69e with SMTP id 71dfb90a1353d-5ec4cc4f065mr1774474e0c.11.1793209634129;
        Wed, 28 Oct 2026 10:47:14 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec57e4e556sm445088e0c.5.2026.10.28.10.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:47:13 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:47:12 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, 
	seanjc@google.com, will@kernel.org, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auI02M-pZO_aQ4jn@google.com>
References: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <2vxz8q3hoicx.fsf@kernel.org>
 <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BEF240006
X-Stat-Signature: qzo76pa5xedwb4p5c3ziy9fdkumkgzk4
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793209634-461190
X-HE-Meta: U2FsdGVkX1+nOo5okAYYjTHy3ksqBBR+GDcwq8LXO8Xyq97T1WzulkIVsvJCC3aI2N1umNzfkM/7k0SFZGT44s/uvuBYD/lh3tlcWZeygqtLwpM1KjW1ieU7ZeKzfiFctCQYQt9iPjQewb3si14uG95kyfkCC4Yf061/m47Lavf2X6Ug85x2IJnC9vKyOhCj+00ntdcjpi18KyaSUODN/0dzZsHsoiVBd/9+3tLXgKEwSx+9cgNYUcb38X3fZ9yLdJg/0IgEbJTqzadMlId+i0gY+slZOdW39TLpV4S5MQaHhzEXHDgFB6N0mbh1N8XWey9mclaVdq3saxGRNrD/BDtWg1DBaaIYZVRaysP2QxsB7jb9OFaSk16WXqCa6Z0ETL8YWcnktvZ529m4iHdkcaDCqFiO54Ri78Rh9pf8B5hI3CjLH8z/xHH/eJKq6NIQuu0buk1y/QaC+f6QoOGqv+0JI/pHq4UnO8c/g4K2z+IsCIzQ6y1UtMj/+jq/r0wnH14gSCfhsl2GWcij4lRlITjXgZg38ekIDsl+aeLQfetVtanTaIsVrBBshORf/ukxjmwPzbNLIuNp1kP5dYod5S6pSvu8sOO0LJ4u2JtayhV5Nb4iKRWkO2uPkiO6l3vVpYGkmIdszQxwhElQRM4bnwSIXJO/pn7aQG0e+x9Obk4dFY5oJFgo0kSvQon9rFujg/TQ17wRiPa4vvOlQEhVBkY8Ac2y2S1GdMdLjNOXksMByQYSNqEw0DfbZwz4GYweb/mpsdEOlxjsZuPQRVlD6ykZM4GHadp/6Z8WxMiAbWMHRc1hb4Ll5WgQt0/Jx1GwN6aZdwwJj7WmIWblp1h/LFW2NmVtOno01BztO9pBXuXtdLqzA94LVhcG7Uqcr3pbvVoXT5T5bjO4rEqyRjHNjtuepgdgfy7aREwwsOhqrLre6et7IP5C1jCw61jQgqGRXqQaXdrtvadB1WvDtHy
 i4KxM/ZT
 0jXH/AeZfCCK59nHeCFFY+8WYEOZ5JodbsjlDo8LcMG+TL6UOPo0yzFr946i27Y6Z7wO7hfffUKXvsKZu2/SzBM4SKXFTCFUONZRL7XlQz7oCnKbgadn4CSXYQYYVLN4J7KkxDu8yY6PC4yczWL9YdjBKKjREE9QlFQDZgW9AWdKXQi89/5JSBfMkz7GWe2Br5ZAefhZmVRgfvNCTlbpB9FYwXnWip83RvMM8qncoskftZ5++NtlyyJYaHRLboi14rgU4jBGib/kLVDQur7JBkmCV2d43Oy6bKdu+5C1d3mWIBAn6msawvAhsXaSgUxPUtcSKwKpMUk2J53D1ieKwRnPnRwfGz9DwAb5cGWUN+isZry3rCwfY6ICygyCDb159KM4i6Rf03lS/iHSRUsPpWbLca3L6cd/TYLTaABN4QRgDHJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-28 10:24, David Matlack wrote:
> On Wed, Oct 28, 2026 at 10:17 AM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > On Mon, Oct 26 2026, David Matlack wrote:
> >
> > > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> > >> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > [...]
> > >> The reason I care about keeping the header compact is that we are
> > >> defining a foundational kernel ABI and want to use this header across
> > >> almost every serialized data structure so we can evolve them later
> > >> without breaking compatibility. While some top-level structs are on
> > >> sparse folios today, other serialized structs are tightly packed, and
> > >> we are looking to add KHO slab support in the future where tightly
> > >> packed allocations will be common.
> > >
> > > My intuition is we will have a small number of headers per preserved
> > > file and per preserved FLB. One for the top-level struct and then
> > > optionally a few more for sub-structs like arch-specific data. That is
> > > why I am less worried 8 bytes per header, even if we fix the folio
> > > problem.
> > >
> > > Maybe where our visions differ is when there are collections of
> > > serialized structs, like KHO blocks. For collections I don't think the
> > > elements will each have their own headers. Otherwise the elements could
> > > be different sizes.
> >
> > kho_block today doesn't store entry_size in the serialized payload. It
> > relies on its caller to do so. With extensible structures, this can get
> > messy. Sure, the owner of the kho_block_set can track the size somewhere
> > in its payload, but perhaps we should store the size in
> > kho_block_header_ser to begin with?
> 
> +1000
> 
> KHO block should track the entry size automatically and not rely on
> the caller. Otherwise every caller is going to have to store the entry
> size in the struct that owns the KHO block, like I had to do in the
> PCI v10 series :(

I am fine with updating this as part of the versioning change so that we 
do not have to do it twice.

Tarun, could you pelase include entry size change into the next version as 
well?

Thanks,
Pasha

> 
> > Anyway, not a problem this series needs to solve, but something we
> > should eventually do.

