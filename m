Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF02606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2aAKF9+
Received: by kanga.kvack.org (Postfix)
	id 30A4F6B00EF; Sun, 15 Nov 2026 13:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA606B05B0; Sun, 15 Nov 2026 13:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFDC6B05B1; Sun, 15 Nov 2026 13:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 007A06B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:01:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A026C0824
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:01:54 +0000 (UTC)
X-FDA: 85438121748.18.5F4CF44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB79C1C0009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:01:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2aAKF9+;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794765712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5e8BJEiuZ4whbgu1Hr+6JPc8nqHGgyY0u0a+RokHVQ=;
	b=dZKDsRyb0sZaAxvZJOYd4f7r3E13Dpvrj7zTaAleo0zmHlLtBBygxtEl321H7FtCKuzNh3
	Hlf6x3EVGLbhf/Wi3tvqQde6xODYyGGGjsU+EDIy6QOSQf2AhuB8OS7ePtkeI7sRZYsSkY
	vb2L6t5yVgRvhixG59g3jeJ+f7A5leI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794765712;
	b=pnP2UDxwAn0M17aQd3EIAS480MI7q/zjbA1QgRqM6UG6NHVuaenroABn/eysmjUIgopmlG
	kUkFwwUeKH5RZDVCtbTH05tfClGMuaimzw4jGV5KU0shridAIMvon1NIwpyWSJD8LNwSzU
	kvAC0TgfbmszLuw2yDhbjBornX7e47k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2aAKF9+;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C45C43DA4;
	Sun, 15 Nov 2026 18:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FBC1F000C4;
	Sun, 15 Nov 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794765711;
	bh=E5e8BJEiuZ4whbgu1Hr+6JPc8nqHGgyY0u0a+RokHVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o2aAKF9+YecDzzGk4bV1bgV0jRjVUpJLhAYO7F+KOkCHqua5bwkkqaIW2TcKzIbVH
	 8RrypZah37W8SoLFH+cHTWDJSt7g97GkpFDUJwpOa8fXEP+C7Fk6eZGhN5bZ5QIWGv
	 rNolRUfDXYPxamX3x3K99oNFg+prs8oECrVd82aJgQ4n1vZ2k1l/hIbRyzuBfF8uiT
	 SP3N1MJ5SlYTbuy72JItmaVx0qM0W054SYKcPl3aN0rEaY1nttQPHOG1KwcWmsiT9y
	 t6SsJiUY3zhw8E+wDnL4kBJBk7lTf7M92W7m9dew6fxdbCTR+FrT6wxWeM+LVgDM2r
	 6NmZ515+KqNWw==
Date: Sun, 15 Nov 2026 20:01:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, robin.murphy@arm.com,
	maz@kernel.org, will@kernel.org,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com,
	pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
Message-ID: <avnzgVJic77yKMoh@kernel.org>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com>
X-Stat-Signature: hcdrsx9ion3hkc4uaa8d8wif38pe6nnj
X-Rspamd-Queue-Id: AB79C1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794765712-679143
X-HE-Meta: U2FsdGVkX1+p5i4niEi1S0kGEEicwH7DwDv9WtUcgbsyD3+80y7+69XMAjI4XhNT+7gs89858FA0ssYsAmJjvkp0nPaS+UgYvVt64kW+2d6g4qf2DCIheQajuympAbwGRVk1iiPPenGaogPlJH1tCE4VImW6NcDM2oFrNutUCTDs/qbhodGmKu36rAiC9w+ZqpZdxMOMxDzLZLX1iRDDlyLHLxGa5dhXGtGnJmQGUC+AeQIIBtFOPfq5QDILhEGdi2GJpNpKVamqMI6DNIlqRqylGt5ZVMxszV20/2PUps0q2UKCVuxPgiMmvHs/LJyIcLTdAU6XTRMqdsjV4HnnDSjXSROQscKX2Am8ZvBs0MyEWM59XCqC9mEyCHjoDU9KfFLttY9gJRmQ2v+oh4hCN8Mx9v/t1IU4ZUhZ2i32nY7jiZOt2pZB9/+i0xS9O0jyXwEYJuvCY8VFlHaDcIgceRimuxi3nPWFnRxWbAwkrifU+NjeJNGCeXKdL+el6ym8I1AWpyIzeZGGqcusUNJ2dcYqJ9NJdKY1b/y1QJRSvNT9VdRw7aBC+4up98YeSvDP8RyVzY6MjTf6E3EjqFsuaK6tOMs64NuRDtqsaLgdb3IuE1hHp+HmAyh0hKE1X4h+zVUjr4F78QblET9G8q+biQR/NxX7GdXuccES8RiYOHdKfV7BGLJ7gY8VVpoLdICXb34cUa6lC6PrT6cko8GHknC5ssJgjL+u4DYoS25pRgVUsyD9kVNTzlFED1zjt5uljpIO4SQvd4zjvpW6ZYnZKdlRqv7NMfJVQslC9hPUQkkaOWWoCE6fdhOxq0AU45yTX938h7KmTsKCQWDdNQihMo+hwrgtGRAyvj9cHjkNcWOtivrBGUsW19TunotLBuS61rE+lkFNhmi3G6wl1L7RLOk7bybW8GVSb1XglrcyZv7TLyoBVIQc6LhMi+qW9RcPdB/oavDJ9KsuSG2lJ5T
 Kt4tQFiT
 YU3Q2i3a3zKwM+KoXFyOBLLz2lqvXlYi0rLzeeLdeO1dQFm44+XntG5bH9K0SqnfWfj2U0WfOedF4pZJAErh9M/fG7N4e15h8QBpbcpiffMLHe5sXEuBVGS/ZHzibXSLc2AWHMQM+iDOjDM4dseGZi6Zah5HZbU7+qY0oxe3UB6zNBOrrXmQ+cmcaiaCJYcYCrgVwLJcYfHPq1Xl3dwP6RCN4GArZAmwxbQ4JF9ry1wlD9XfRr7wxqA7ElaJEJIO7L+9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 05:01:48AM +0000, Tarun Sahu wrote:
>
> Each subsystem registers its serialized structure with:
> 
>         DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)
> 
> This establishes compile-time assertions and provides type-checked
> helpers: kho_ser_size() for total allocation size, kho_ser_init() to
> initialize the header, kho_ser_payload() to access the typed payload at
> its dynamic offset, and kho_ser_validate() to validate required features
> during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
> kho_ser_hdr pointer while verifying at compile time that name was
> registered with DECLARE_KHO_SER(), allowing callers to document which
> structure a feature header pointer represents.
> 
> An example demonstrating how a hypothetical structure defines its
> features:
> 
>   enum foo_ser_required {
>           FOO_SER_REQ_BAR,
>           __FOO_SER_NR_REQUIRED,
>   };
> 
>   enum foo_ser_optional {
>           FOO_SER_OPT_BAZ,
>           __FOO_SER_NR_OPTIONAL,
>   };
> 
>   struct foo_ser {
>           __u64 base;     /* base fields, always present */
>           __u64 bar;      /* FOO_SER_REQ_BAR */
>           __u64 baz;      /* FOO_SER_OPT_BAZ */
>   };
> 
>   DECLARE_KHO_SER(foo_ser, 24,

The example should have included 7 fields total to make it 42 ;-)

Seriously, this magic number show must stop.

>                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
> 

-- 
Sincerely yours,
Mike.

