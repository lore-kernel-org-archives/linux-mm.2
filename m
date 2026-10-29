Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D938606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bmppn8Ma
Received: by kanga.kvack.org (Postfix)
	id 6BE4B6B05B1; Thu, 29 Oct 2026 09:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F5B6B05B2; Thu, 29 Oct 2026 09:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E5A6B05B3; Thu, 29 Oct 2026 09:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26EFF6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:03:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C36214039D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:03:53 +0000 (UTC)
X-FDA: 85375681146.04.9B14536
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 576884000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:03:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bmppn8Ma;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793279031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF90/0GARuMWHyMTMB3Xwv0e5GgnH85LGW7qmrj44J0=;
	b=J/ZoQLPOzizKuehXiYCDwgP7iM4px4JOPYbyqH5J5Q71aZkGEYRTosvsSB8vO+0Tplg43/
	JRJmqLXbRqsCkLONxL7htGxSSEfJuEaCQAYS3gaPfTtW3/B2hfk66QuWqkObcly7JCBaHx
	Kx6v2Ezk+0yxB54s0SaCafUwdNXmcyg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bmppn8Ma;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793279031;
	b=Q5ws3DNzAmD1FmegPLHiMECJM91hvLYKvYFrwqSC+yGCREW7Vsp3YqW0tum7ZvqjslFgMX
	s4Mi5K47b+LiMUEWIoXngap0JMUfh7U3nTqBDP3W7vK/kMwuz9XKnty2kDBDLERWSbHFmA
	PMc8cYb2AJuzRPCtP5akZk0BB7VSJvM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53653e30353so31942001cf.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793279030; cv=none;
        d=google.com; s=arc-20260327;
        b=rK1sfLzxg73ZsVgid0ksxFD5973Xo4MPa/htaf595s2TX1ePjPZJ4qkydHhNj+yG5d
         x0exlUlgEVRNC7P60NkaltpUI4RL9d43/YhNpS90S84nhmwNBxt0Qy939wWESkW254Y1
         0v1z0bK64EJhmLb0eFceKNpkyZl2m2pqlY/x8dhQO6vt5Tls0rJ47jHcTlsbeled1HQu
         Dhg9mBAzkPHYVSYT+3jy0rVnqguc2KE+rXMh4WGYvvn9bYGnu4Ovbs/o8OKDt8Z5PRoK
         BKAk+NyOZrMqcZ1KH1oP/56BXOg2YDvq4OH9GuVDWLIm1LzQgDuF6o+wEa6UHA21VpYH
         L7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KF90/0GARuMWHyMTMB3Xwv0e5GgnH85LGW7qmrj44J0=;
        fh=jI1UiW5c84zzy+TVoAWLlk24LZj1Oz6kr+MgkfyNhFM=;
        b=pZP/COxWdtPLeZpVAi/FfAR2tuJua50fqS3utFLlLn3UH620ol8cnWFKpbtMrylV2t
         VwIsXljDPVqVrv+uaRFReZ+EFXnC1+ib9yjrSCjDPJvtonn8bwCbUyG2dpOEnARJVXHC
         fYL2NHOzqy3se0xAgAEI91z4LB4JMLEAA3SlXXCKokEISGq7KLD+nvVu2WNkno0O07eW
         xPu+/11Y2PfEmYFbtakOJlJPAh9otlJUVZY6Q0gZEUY/xoI6IH3G3HjvPcsrTRiigmMY
         Vgl4AwM523U4HRKMKTbI7KZxHobVV08IVwxpvlGsegX4/wlQQYXVvGHt0kEsh2C211uj
         mlmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793279030; x=1793883830; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KF90/0GARuMWHyMTMB3Xwv0e5GgnH85LGW7qmrj44J0=;
        b=bmppn8Ma44yKY0KfmcMfZRNrdTBvIUz7KWnG+8pA4yCOPjRIgrr3e1Ik7EF9CB25/u
         E4pEZYuXZbgXJXHoDyaUFLwW8orMD3yB6JKXhs1yBNtmDenm5GMyTRXc/ApeE89uuJ96
         stVttH1BZtRS3X5j6iaQgqGDDtrzjdGfvrkV1cYYS/Edt3NihmnrePMBLgadOLKBsoGI
         erC/8wt3CiDT+g6Qj1mJNbWBm8+EGiAJSD9rP/niX75Sm1r4RAsz41gf+5OvFcUj4rC9
         +rPxA+jlTXAqbKX2AXMM/EGAMwt/Ji5JbkUCs/LV1sMRoQTUl7ERw47SezZTVPdQ5upC
         el8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793279030; x=1793883830;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KF90/0GARuMWHyMTMB3Xwv0e5GgnH85LGW7qmrj44J0=;
        b=Rg3+FxV4TQEcrRNxmrgMmNu2azEXHdD0nzwQ043TkmXbfSmTxW/DpxX+7c8W1GZdjf
         649v5PxC0VMnO+Du/KctGpBBsAvbzZNhPs15I2/qXzDt7B4doGr+k+G18UNeyDrbApBb
         u+cAnv2HuvHY9sVSsTIFeKYLX/DFBlmlOjKuICLKKU0YMFIffeaRqEUx72NFZFNZO6GP
         VCw1xUmFEJMlkdHHPNQfy14BvYc6Ci1uSQbV9QD1htyhDdIbdveztw1jf6MdJxO/vEOr
         Kj5EZ9SOuXbNDFPbVsdmWtZW9cX6R32vFPalWpL/Mr4vRILmfQsyIQtS3zwnl3heAYEn
         Vqjw==
X-Forwarded-Encrypted: i=1; AKwUvByoSEGZBqkP+4neuP6Jw9cFpOXaqdI/qWJH/CdSNIybdMIYKqBdKncwOaJauWkpDEH2OaY4Q3lOjQ==@kvack.org
X-Gm-Message-State: AFq9FYJStj9rJRSq1QBJW7WVvBdHKH8aNYN1KehS9OCrtcmVtqFH5Tnn
	ebrIClpmyJTri8SLyDs3VOIr8ZjRnFvWGlIporvUn7CwJcU27J1A+Eu8PGirxw9uqhufSyZVMBn
	C9x9phS6cZUMufIcqJKYpfhmJ9Ghxrnfngt2+cTsV
X-Gm-Gg: AYBFou1B8VaPdGVeNsjJlVArAfK27i1i5D0UpWflRwT/rJQZYZHGa8iHcjO0Fv3fl4E
	2hnmjf59FSpyyteHN/4OPoqO1xgXUyTeW2MYeDDnCm1wrFrTxvJ5L7vItDrOamGxRfu3YavcGrE
	RYiRYhFxXrKqkMOZzqvi6zB8o5Xdj7OvIj+XuTtlM9vGY9j6VXtBFEy+fIpIi9aleWyXphoWIfN
	Xx5fA258BzrPDSKPumwG1xJzaP6Hzosqm/8Gz2XZczM2gBGpOD32/F0h8I2ATAS+mVbS+54SivC
	w0oIm/TYiF9QUsgkb2ZPnu799F9tvT5uqo0IUSY37/Js12FX6/aWqslv9PFvU+ImNhoRzLkgqMT
	BkZ1HtyHnG6gisiLvVOGTuuixTlgfZNhsKCkgEnwzwrGcP14YFLs=
X-Received: by 2002:a05:622a:528f:b0:537:b9f5:e05 with SMTP id
 d75a77b69052e-53fcc7cc0camr87903901cf.69.1793279029444; Thu, 29 Oct 2026
 06:03:49 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 06:03:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261027154649.91571-14-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com> <20261027154649.91571-14-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 06:03:47 -0700
X-Gm-Features: AclHuK_J4_B8WHMj3lc3Bqk_zMBRzyMWVypxyBk9aFiFYwwISWnD_-KRrJmOcto
Message-ID: <CAEvNRgFYecSKycFLkxwyK7gWZqKTXTPJVetSZm8YBbo0kg9tTA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/14] samples/kvm: Back absent pages on demand in the
 sample provider
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Kardashevskiy <aik@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Ashish Kalra <ashish.kalra@amd.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christian Brauner <brauner@kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Connor Williamson <connordw@amazon.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
	Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
	Gregory Price <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, Jianxiong Gao <jxgao@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
	John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Justin Stitt <justinstitt@google.com>, Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>, 
	Steven Price <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 576884000D
X-Stat-Signature: 9jtdi5t869adpds5se6uh7e6dqt9j65z
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793279031-85232
X-HE-Meta: U2FsdGVkX1/EWsXVRKF88cCjTUwBdyky/2v+0xYbwkqcEODpw1xZlElorknU9+qOpTMkjPVLZAZmtKQ+PDQWBODe/crpqECxexVJRb+K6hdDR+DoeB61EoAZBdDoU+wZBO+edc4j6uSJsZQtofd7PGD9UqbwEms0SXGDpjKK+rIjszuqNTE0U16JYAis2yf5j6DLSKHxdiWzV6Ht/oX/d88T6FHKIs5GnWPpSBXfWo+EjwARcNpApmDr2oHWtyJ3AemATiVBx8eqHyQyRD2qtS6lKQZtdt8EAGzKsGsapeWEBvneQcWhfvdxZ0sX+aDgQaIWepXd2nW8k9tZQR1O2fnk5VM0OWyGnRG97ybCZ7OmbFEaWVcGcTZ3pQ22NXQ2+oF89dubdIDi/YyBNzstTb6v+Qh7FYT3DvkIXWr6eFxRBYzyhup32CnqmH2pP3eby4iAL9pytBCaguwhcrFKBoR+gUG+z1d5j3Xh8akxIMCa15ot4ll7tFuhc2Mshpj5wV+6WJWxanc16UJy6Du7bDICjZx7i56ssdx+IvkcGGaEsbSoqCfgp7A5wWyph+1iLMa9lbalGTsO7qpSyANth87cUXLh1ZPCWZy8BK8ek0cNCfHtJ4OXLkElS8ZuRAtC+6nFS4o6MkmCm8JSV8V8FVpiisN9iXlk0b9iZd4MAKI8CzkKd/VPO1WRLT6MMHJyY1m9e90XopXYJqyfAQa/bzXWtcUdBBeqlehXxOQFo0MOO7DxCiWeLMyWizeIpxvbnLgI+XiOOw0IURS4O0ix3cvFTJG9BYd9WYHLNcirBHIkxkyAp9w7NIfhWxTHZ/6zw5JIdYFYK50zuqPI67kRWfQc3y+wxc1K9TQo1huX9UCrpHEEppEWb81yKg3/ZrhwPRd17dR5uCr4IROMpKhihTuVsaNuj97LI3xvIQsrFLfQlziCoCg9+u0qTi1vX0ZWvEh8j+JzijAmtqCUd5T
 3GgA9LBl
 QzZvZczon3mlwRUhFZJ2MnmrfoQxYOYquE0MlI/o4JIeKNh4OgpxnCKWSKKYZ5L2K1HpF57Rij5YneRIW8dapnRC9faRbj62bovXPTNE2rhHfxVr6c9RlYjiFLxdM03I5YjIGMy//e8y2Hw64WIGmAishHNiQ93x5aAiGgK4Ay7oetY7GIvAUlrN08IFQRw3huRy8lMdUGAuh4TgicL7I+bxhRxQtEx/o8xCcfxZGHo3MCx9i9XA4B6Z9f6KgdgMkwJhUlpwm51El7YcihMGefaVSkkE0EFvRJrXWwAGCeTwIcsW8KQrM3RlzTM6G6ouZ3U8f2P+2fUtw2xW8ha9BOMXeli3XN0+dZYXccgh/HY5iHlJirH9YwZgCMY10cqGnHelNJ9SFUxCgTJy4M27IXhv1WchLqbIg8O76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>
> The sample provider fails get_pfn() for an absent page and keeps its
> frames on a punch hole, so tests cannot exercise a provider that backs
> a hole when it is asked for a frame, one that backs more than the page
> asked for, or one that frees the frames that a punch hole gives back.
>
> Add MPS_NEW_FILE_FILL: get_pfn() then backs an absent page with the
> whole 2 MiB block around it, and put_pfn_range() makes the pages absent
> again.
>

Can what MPS_NEW_FILE_FILL is meant to illustrate be illustrated with
the ioctl that sets memory present?

> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>
> [...snip...]
>

