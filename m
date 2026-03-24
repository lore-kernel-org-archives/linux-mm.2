Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0F4F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A4F6B00A7; Mon, 23 Mar 2026 20:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAD16B00A8; Mon, 23 Mar 2026 20:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9986B00AA; Mon, 23 Mar 2026 20:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4ED36B00A7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:43:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 536575D703
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:43:32 +0000 (UTC)
X-FDA: 84579108264.10.E376512
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FD9F8000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:43:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FAuCnUjk;
	spf=pass (imf30.hostedemail.com: domain of wyihan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774313010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tP4PkIA/dAss1SYdem97AuKhuaCH6Uwc8eZQpSWtLFc=;
	b=tKkI4ztpC49VnB0Fd8NfqeYbhmXiRzke9cn305MG9zAOyqaM2YYtoJbopl/i3tw+fjkjVi
	xZhrAmaVxkHyBXrPMa37JKmms44xWxuLfXuDuzeLGwW4QibT2E6mxFAwuQOoKbT2pja6t9
	5ld2q752LJgb0cnhmDfrtLbSxae57ZA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FAuCnUjk;
	spf=pass (imf30.hostedemail.com: domain of wyihan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774313010; a=rsa-sha256;
	cv=none;
	b=Lcr8E0eChsuKY7SgTv35Pz5qDZgHIBeDLK8fUdGEoUC/BlpFHwZ4Qi0XEMLgfyn7MXRBS0
	7BZq2AzSuWkzb/x9TGUYMusP5O75lJ+1vlKiIEr2IoGOnoJiVMv8y6lGo8az2EdhKWOQtu
	ttORrmlmHG/qT4cd05xK8luj9AFFElU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b052562254so44335ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774313009; x=1774917809; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tP4PkIA/dAss1SYdem97AuKhuaCH6Uwc8eZQpSWtLFc=;
        b=FAuCnUjk6KEk1dfaaHioVqhSdO65FgGWFOdZNMScj7DMmVge0ppBglMzqf8AGe4JpA
         MrwR8IOHEPPz9EybWN8D0vrhLkrPaKDI9AhlJnSIH/OGzU8Gde9SQoAELHaerrpDNt8D
         me5qgv/BjZ1d/0yz8DI2eQZCcZGRQPbm6CtqqNtPvOsnrzAS3B1iMehYDD8NfQSeQAYv
         Cgtr+y9RTNHNamvzr9D5g8Txc7zE89ppmXhpy499Kv3lC7OJlngrhKAJZHhWbEK2CDVo
         1aj6OcHThZn5ZxrixlIuAAdlKaOuFkDPQNetpCBCZMJ5ky1Oqsebw+pDYb1oZebTe0f+
         QN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774313009; x=1774917809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tP4PkIA/dAss1SYdem97AuKhuaCH6Uwc8eZQpSWtLFc=;
        b=A8davd1rJiEf4deeK9Q6VlrPcErt2UBaZ/17KnUYphoSo69qxlg/xISUlwsOebBTrA
         tcP15FmUx+ebbE5+yR/aq0JMyqqymrXywWJJEV++9WFXuGBHvZVEAyBa4/i2y8SsgkrT
         Tp3l+LL3+coLHROu+8LO2S4FGrepphOgrfEztyVO4iZ+srBaKbksectEEaPhLmizBQu5
         AUvGkOz6CiCUwKyIb1fUklcRzt9bpdizx9q9pIxXPJvNGm+AsoT5SwaQefDpCFOs3SjR
         BBB35jgufLVgCpONZoH4AqYyuc9I/ELWYgNCyRIVxOPSDmGu6y02YubwDM4R++YPYLbN
         RdCA==
X-Forwarded-Encrypted: i=1; AJvYcCVKJKYPAvRc6RTdD3PDfR4ra7hBJZulmb7Rf4dK3Yu3jNbR1xFibAd1p8ENKgUs9sR3zVHNVJDTMQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+3FfTZPtlDv4MbMwAeuovUW5WgdcDZgoYbtiO8nQ0WoDtMYZA
	Z2XV8VNueHoqarTII/ZVfLAgkJgI/3ffWBJGZZWbCN3E11JwOcRLHxv/dQlg32LdCQ==
X-Gm-Gg: ATEYQzzmPc5CiCPq93C2i4X6u3+xSIQ3CR055e7WzeiKKc7LKRw5o5DHm6fcFcdslE7
	SlGzOcuXuNPRGMXSngB9V5f/5dJ58BA2PEoa31S61pSijlbhpXzGrJrWIsGJsiLVbBfPm7TJ1SJ
	+noHqISz4QUz9nUI1Hgy4OpeICbrdvXaTZ+2n3bTGZXkVrS8eZPaD/r5exKw5cC+ycn3rL9bFyQ
	gnpJ9BcFrgRQARtARDvNYiwJdpvS4rUsoSEaVk6y7jMBWKUv0Si2UjXPiI2zx2qDeuoWkiDUyaD
	jBubic5j412GuUJm9z9Ra1th5qi3qBW2j6ApN+HW+MmQWm9nQaiirl9XCDKDBAiSMlV79pOielg
	ZFUesQJJc0V6Thzj5FRKLZ2PI3RWH0Aykbk0OFOaxyqwk4MI9WZ0gFP2+tn7XBTimy9aFmITpTO
	fwDBsdrk3nfkB1SqAFV54tmX6EHQihuKuJYxe/w58uiZF3wx6SyCTOe7xb7wk=
X-Received: by 2002:a17:902:f54b:b0:2b0:5b4c:a439 with SMTP id d9443c01a7336-2b0a5405594mr1757525ad.2.1774313008753;
        Mon, 23 Mar 2026 17:43:28 -0700 (PDT)
Received: from google.com (249.53.168.34.bc.googleusercontent.com. [34.168.53.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409c6besm12352073b3a.32.2026.03.23.17.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:43:28 -0700 (PDT)
Date: Tue, 24 Mar 2026 00:43:24 +0000
From: Lisa Wang <wyihan@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, rientjes@google.com,
	seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
	dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
Message-ID: <acHeLL0l948jRchK@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
 <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FD9F8000B
X-Stat-Signature: bj9on5taddiz5trg5xgu9h3rmcqzwtd9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774313010-149680
X-HE-Meta: U2FsdGVkX19VVTYVnGQPJ9oqmfhc/Pu4SwJSXo05r+tMCnfasSR5+MS0dTRO2oCKJzCSHZEFjqeKDsWgpVtUkVuAqBtot8Ko42qgI1gOQ2fVUYsE6Ehh3wD3aNc0ke9oDRqD+f44z15WFL0jT+NiUiieUI0baMKgWJBiJ4ZAMnyhdrW1pozua1QEzPpGTZmManW44L6S+BDbBpkpc8k4Qzh2NetvUKicJg8RFVCKWznfkwOS8Hv5bH1XGA+OUHvMFzKpdcx4iHHJk09UYpAG0LYG1KMsyaw4UiWwPCJw76e47JLtu4g3RdtxLpzDIshBuSkG4vF3IJImez+TptekYoM92ej3oPKem4vIUwzwjAOaK5l9SyqL5r1e1XzPNYQ6jhV83aMAgxcVZ+qsrfLkJbRss1u3z5NDNdqC7t9JeBAlbQNYTmXQG4L3gWeS6QGPamwu9+hk4H2qqrm0Q7RHROTzNmdZJMabk2Z5Ijdpllxw5HThjKiSLDHvq2SMHXVk6n/FUvpDt/O+Fl7jRkViYUvM+CzlnOYIXT/TqOd2D8AqzSgPluXpdIrZRofypVFO1oD4gdj9xVb6xmfwXt0mtf1sIJZjgS3OkPWeMTAscCEzEkaaHDm8/Ex+fTdk9ykAWTxNxQa1qE+BJbancq0IGuArkqCGdqSbhcBel6WOSuK3nJwfMhFJi5pwXKcfmzC9dc1ELajOwwai5iN3pus/niD+mABLwsq2DZzZ6xpSoRYTtjy/9KX0tbS2e5lnVCeb2h6ky5twHt1sjk88uC+EuMrgfcYOzcIWN3fYF6wU4nJS0+OPVL/ByJMD3+oITSeWKCuuxOyTmc+gRiaUzaRrWLy4L9/GWPxKRk3S+Q/NUMWuJX5Ykeiro7u3FDQU1Ps59QMd/6Mw3x1H81Xh9/4XQOd8/dSgm34iZKOHWwizSKgatzl9yvdw+RCfaVj39Un3Rr9uaJJWEnkA4F5+UMk
 QnMHyJe3
 /Dq5+Z+R4V7GyykyDnrEkL6HuIZoqM4phGIkglfFr1joADjWtv1yAByp8VrB1O5JUEy61qH3f6VzWiBc2W9WzmuizJZ/EYZzRcRMJXHBKNC0wlTQ3qrdXajPCiCoe9sKc+HzlO2+akqpqREnxSPqO6MncOH3rtRDVi4R2vMeITscFWKxarza9FetCC4NgQt1E7qmbYmeJTQ5Of7cKO387iJDLJ2KunUxQae1UietgQXLL5aq7OONAZX0JVx0cBpV3c9G6GbZ0/DF7JhQblEznDFSOiamiwgn9G1LvM+oVC0WC9vp291+34eBpWm+XrqpW6glqpvHSPBl9S4YDoy4JWbaBnXXfj/K3n2fI8Vtz9ewx1EKw7y5cntt0cVtddPSZmszTVknDrWY2Ciy9FuYd/TLeOoJs7NCsKkOmTh1QT8n+dZM785Cp5o9grxrdZHvVjpNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 02:30:04PM +0800, Baolin Wang wrote:
> 
> 
> On 3/20/26 7:30 AM, Lisa Wang wrote:
> > Add a shmem memory failure selftest to test the shmem memory failure is
> > correct after modifying shmem return value.
> > 
> > Test that
> > + madvise() call returns 0 at the first time
> > + trigger a SIGBUS when the poisoned shmem page is fault-in again.
> > 
> > Signed-off-by: Lisa Wang <wyihan@google.com>
> > ---
> 
> Why not move the shmem memory failure test into memory-failure.c?

Do you mean let memory-failure.c kernel code check by itself?
The reason I write the selftest instead of combining in memory-failure.c
is because
+ do not need extra checking code in kernel code
+ make it easier to trace the entire execution flow, starting from the
  madvise() down through shmem_error_remove_folio() and into the
  truncate_error_folio() logic.

Pleas let me know if I've missed something. Thanks!

