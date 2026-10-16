Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE12DCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C10C6B0088; Fri, 16 Oct 2026 05:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872D46B008A; Fri, 16 Oct 2026 05:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739666B008C; Fri, 16 Oct 2026 05:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 493FE6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:46:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5393D1C3661
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:46:16 +0000 (UTC)
X-FDA: 85328008752.04.BFF2B6C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7C9AC140002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:46:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPG0U0rK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792143974;
	b=VvfpyRMqdjs0Qw53hJSxIpLEuEs+52PKPmp/CVD7XFqRWEpx1CEquGSfkXXzO7EaZww4VN
	ZAGlkxlPM82lgcJeIGQek5Fj605SKfTWVFa0JHuLunxvCJQQXARr4lgFNfI5hPy3ml3vd9
	H8c8VD67/JkxfPl+/gm/VrwO8v0/AHI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPG0U0rK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792143974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
	b=PVRc5rkd0q/R6U7oaM5FAp1Q5zHZqX1LUn3IwuOPwBmMmD8k4VeTUcasFah+MSgDeadw9L
	OTEW8KfgCHgW12DXbKY4jwKMsJig1O4rTrlXyZ1SbKFnwg9QHUl8s0Qbc1VtaIMQrbpCj9
	+B+sZXBAtDq+b7IVy/RbUFSdK8g9Uyo=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a01933b584so52872875e9.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792143973; x=1792748773; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
        b=sPG0U0rKljh1EDDuLI7sMBHTOaxe3N5WDpjCVIsYwGN81CFU9Jh5avUt7ivJASqbLA
         ESMKJpvoeipFlFJjUGG0nb959eg3bx48bzSnvdS7563tcs5SSZdD6bDvH3UROhDvxki3
         mHnZM31lkM++LghPpcru9JVLe45SeS74zwRlYx8n1vA2EfkX0lPFV0ZNHohrUvIZVh1y
         PxV/OhvJCvc4EXmU+e3NfEEeBlVurq0mnfhW62z0N+a6UhKTf/xIgAiwKILB0D/c8kQK
         8z5diGnNFu+YGw7Jt9eHEuTVRHbQKl4abLcBQ9HMgm0x91h9VEpd3hIx0kHY3kX4sxTh
         1CFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792143973; x=1792748773;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
        b=gAecoRczov4CO6zmRTPLuYReWrcCBHquZ6o0YEw1vXya+4NbhC+wavn1hf89rjTk2m
         n3t6byvvB8dnUYQ3vnsgd7XPFkF8f5F4nhx+IbIZLEBRhvMQ9t2YYYV3T+H8qCF91tgU
         BWosVKbc2GEb+QnX4FD2HLUT29WWqvsuQWPeh+GnSdVlCaft+ftb3Lj613Mecbn8RgsT
         Ew6Iw8HCIgs/A1y6xzIQVLEF/PoRGQOHO18ozlfRyyywnP8EB0nOcJIem2OiZmMi8mHx
         Oz2YgDQicw/sfM01OCkpeKIBBpnjoMtYmGV22Nu0w3VaAOeYyKi4uet/S4DXQ/nG8ANR
         lFTQ==
X-Forwarded-Encrypted: i=1; AKwUvBxWQy7OWrzbnUvkyIAVgk5le6fMLQm3IW+sg3iqyaCfAptrS8KagJPzOH8XPg+HZISVOlixkGvpQA==@kvack.org
X-Gm-Message-State: AFq9FYK8bA6i3lDwnyjp7ZX0tnapLKY2VxDS0df4ym4FvONDgzkKFqwj
	SnMK5TqHvKCje+7IPFCy+vfcDsmnyD3YtyWx+2Uz4gNit46kt8otoKWe
X-Gm-Gg: AYBFou1u4lynvea1VTIABzKC3hjVNWobxIgKFXs9lTPP35+e3FG/qXrUqZmJEr3ausK
	SkVXkIglfImwSDk3kjeNrRWm7Bs038KVoB921IAPPJgwUyytKmanECYn+03fsyiRLHGB42zXeiz
	4xvaylGUCZOLzW1npJ6PleGbad7cZkj/349Sy/Deao8hLeScO+EMPCLoIwfZ3YND5C8kyjueo2w
	BNolJnJvLCW/LawleNoZdsuCovrlVFkpcR4jfYEAHbDzXio7tGDds+arEEu9wJgEy5fmBK+NvPC
	uJLQXXtA73NaBp/oTz7LBk4DlfHMRoZ9j8wctqHikjWRn4+ZbVNYE+ubDg0uDCh9yKpdb4h+dmn
	A1i9BftoPTbczV5pjQZqzQiR3Y7QQ7Y/gDwe527/9pgUxe/XX7xsax3vlFkF3Hmau8SePCeysaQ
	WLbHHmqV1tCp58kJBhssE5ri49YZ/lbBjbA3cfXX0jaxDGzVUVHLUDhERLvGeEO49tjBnjotaSx
	MEUgAd0NZ/r0O+/szs1UKO2/TYiRk1F9JQJS5BZcfmnLfYp93kML6wNeS5ntvPOXXxgcP8DU1AX
	UpmCPaqQtRQ9Oo0/kp8c0p7Bg1PT+orTWmw=
X-Received: by 2002:a05:600c:83c6:b0:4a1:7093:40c7 with SMTP id 5b1f17b1804b1-4a18e493048mr406737735e9.8.1792143972697;
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca43012sm17041055e9.3.2026.10.16.02.46.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 07/11] iommufd: Use large IOMMU pages for provider mappings
Date: Fri, 16 Oct 2026 09:46:10 +0000
Message-ID: <20261016094610.57849-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016001448.GC14213@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com> <20261014093733.90312-8-griffoul@gmail.com> <20261016001448.GC14213@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5gwje8bkcoijcxkk67fab4tdp4faf1d5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C9AC140002
X-HE-Tag: 1792143974-744888
X-HE-Meta: U2FsdGVkX1/f5YMcNR4W19qPBHgRIHLS+fNJpcgt0CkKNiHrFzZ4LaGhrI7ZVJTPfNFQmipoEFMna2sjEP+4kjXspPbJehwMLxRraC+IVsLKda8IWSVI7uo3m9Vtg2Ckp0zlc8dKeClAWT6/K0503ENSJ5QmTZqMYRd//toAMiOVbaN1Yf7szE5X1eSUo7stzPr7FHRoKpPpEN5RShFfQaQoCF3ahzSpINS6EgO7FO3enxhyBH8gKiBCy2TpXocZFvhlX6TdWraHL4cjz/RwD/bBTa0F3535I/Cw8e1IHlmE2up70B5r0I8KxgTLysxiPS2CpDcQtIzIVCHBVSHGhzL+Yhr+DalArrKp1zgsfSnlSPZrbOTgUea2ujCaJ09AGr676KZaMWE4an7dm/TfxfCWo6NnKb91D8dCnTF9qvsFJ/9WW6uYmH6pV9DcxbK8HOTIyA9BZ+3qG80eXzErX2/YCGfmqm+S8BS779pw9KkZExsbSIe7NLuoPD5QSISPi9XtWHEbxnAEcajyIfyw83DTAseIycL+sp7PSI7lTHG5gYYA5su6s6XVT162iDLqXTMfoU01/cK/Bjrg63tIFeUDDM07pu+w68t74uSByS1XCPZus7N8+QZE6o5yRDCey6JEA36eeKumRxuHBX5AYoT9oDrxwpzOwleeKxy6SY+gf/h3o6TLZlfLXECxzC4crPtWBXHZ/oDaQf4oGJm3yZkx/QT5yCHr90aMknnB79UNhwsgIGjefek16qhoVbQc4RJ4mczQcThCqHqpzjxlcrbmJq3GY+vEgy1b05HfbiBGEf6qfScE3BWIy1dwn0u+rVYJCmbz7fOqDol9TdD2P/7ftGicP/P3tPmwjC9zAHAMLvJWXM/W7lI8QEFw9Ttgg2H09kSGqaYe5bdW1OJGNqTKIdIlrK786WPlUHu31VTe1kJFRxCWessXXhsjiFh9IU88Pd5+MAisEZ6OZCq
 2G5xzhfz
 9ajnrU+yyIWc9d/nTC4uBXLlkqKHfzxdhmtfeMLKfL6sKZVAvEF81jq4Xo4XPl4xGOJADTprG6dqo2UkLfY5Jz/belIMzdfSRq2bt3tj0y+w4N8YZXPthqYF4MGn0+NkJSgobtz/47BFwnCsqojUC/QW3utD1rJsT0w8/7hX1gPhrTthurMeRhD1gx9i4E0VgQyXX93ziGBAZQeN0HDvkcshphkMh7TDD1dRids+cHBRFobeceWQGHNNzEYmbwxAqU3Lf97laF0hT/G3e9JNZAk7l2LcHo87gu+2ksxd5/ezxq9pNyF4+ry5z8y87qpxTKdGklvNjxZqXTo/oww/mZ0dPMaBDm7hEyXz8d3RcB1Lx2kw4TAOZVVwWxQjwjCUyzZCE/vfgPVTxfzSorHsK5mdoKClSyHgw2D0HjEWstGUfDaGQlxJ+gQFojgWuAm7gkstGN5dywL2kfVAIsxT8jpJETOzNDMH5ZAdAIHsyMceZcVIZw+ihM0VQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:14:48PM -0300, Jason Gunthorpe wrote:
> You are going to need to go into generic_pt and implement cut and a
> more suitable unmap to make this stuff work properly. We can't over
> unmap on conversions.

Agreed. I'll drop this patch from v3 for now.

Just to check I understand what you have in mind: a cut operation in
generic_pt that splits a large entry in place into smaller ones, so
that the revoke unmaps exactly its range, and iommufd uses large pages
only on domains that support it?

> Also please don't write commit messages with AI. WTF is this even
> trying to say? The subject is "use large pages" and this text says
> "map each page with its own call"

Sorry about that. It goes away with the patch, and I'll check and
rewrite the other commit messages for v3.

Fred

