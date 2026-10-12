Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606CBCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9366B0092; Mon, 12 Oct 2026 10:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49AA26B0095; Mon, 12 Oct 2026 10:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3899B6B0098; Mon, 12 Oct 2026 10:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17C2F6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:06:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EB28120DD3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:06:31 +0000 (UTC)
X-FDA: 85314149382.03.B6A7FF6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FA7D40009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:06:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J4C1eqYN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791813989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf2mdCtowqAvpq+ux31AwRPL+X/yyRTmrifL36FWrPk=;
	b=Fb/MAE2vFlxi1q7qSn/kzuLqN7NPKA92EwdN/NV9qB8WXyZEqlpdoveXtmwRmpbpwszDYa
	TDkcV23UoXC0YKwnfx7ycZKwATYRsAVE+URDL+xmoyWImGCdx2UHo8rRHYWzfrBzTuNgrD
	wz9fh7d5mF7E03Ah3C6TUVcWGMzauD8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J4C1eqYN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791813989;
	b=Ka0laSruratMyzOmL0+NCN9mpT4AT9VEcSk93++oBmdkxWAskBiOt3hmfFZ2sYmBX704Oh
	PpDafXQbsrS83bVeZXoQe2ZM6bzKQ+/ZVQRr9q7gYojvv7VnLaYCtD/VxQWgpfmJfIX8hu
	0arAYFkZkhzXDcsQ5PXmksWOYrsaT+c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791813989; x=1823349989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fzzlqH8xHwUZy1zctnsZGzN7D4EhPpUIpklSEdpBki4=;
  b=J4C1eqYNYBng5Qlp8ke7u9RguRnt+84xMTCpge18JFJeUOsvXTGO9LhM
   4SLyFrDnZdf4nTFi6yN7qgj0d5N1LvLp1NL7tIhDfAw5clXjEMyP1nA0T
   HrSwEBjQSFxulbVs4zQbLuIvlx44sMnt8BmLF655cjVFNw2dE7Qm54ydG
   4Op4hAm0kVvSYtKizdgOHUQyx23Br7ov7oVauDA7BeMxH7+XHaKuH9MXd
   PdHPPH3XqMS1nXRKT9mOHSrPfwiFaBiscQFdzgkUh6OcaATLyNbaG+NP5
   sAblGlwgD/bHChlaOWshQ+Eaw+xFX6tl02oTJIJPbj4G3dNG+b9GsItyq
   w==;
X-CSE-ConnectionGUID: Tha/fkmjTR6xMzHgJJk+7w==
X-CSE-MsgGUID: lla0fRc/TXyL05YALCiHUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="525147"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="525147"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 07:06:27 -0700
X-CSE-ConnectionGUID: 8ALfAHMXRlu7SktTAZ5ANA==
X-CSE-MsgGUID: w3Nz3XA9RlWr6NOaqxTu6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="974418"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 07:06:26 -0700
Message-ID: <6834c567-63ae-4795-aa27-25f478f0c0e2@intel.com>
Date: Mon, 12 Oct 2026 07:06:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261010112457.49485-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xmt8x5i6wmtxedzsigw693hy3u9e3hrw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FA7D40009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791813988-833206
X-HE-Meta: U2FsdGVkX1/rc3N1AJimSYNYvW0O3saDsievtCo1mEb9fwklSOvaSZi85ZanjH9ura8s27nMq6zkQhw5OlcdQN3utnOoVI9I7/goYmvi0FR/qH7gY8dm20fMijSeWiwEB8CDiqE6N9wFFywgniBLQlPnzvlh1P3v7GnQExIRdtVP3HGhQUKHjJKSlFxM6H6wn3m6MsVx36mL2HiZXB9nnY4MdE3fjWWGW7Lf/II9CcFwBPXbEcE1SBgw5HcJpCDcZjgUXWBLwXu5ELCA0DAtG+dv8QGAXQKrwcSl1nusfGUf5tx71vRJL6xqZrbLubclzPbQHw+uVqQnkoHX8weUHC26aQ4wXexEppxcqM+bc7fLL23UYHG7iMHLqT+W1WuWIlzoRA9MvcA2Pi0W4xjCTsrR+NLap+gIpEM7pRqbKEdq56NtIW7FGvhxhYxCUevsjucw5d9+lPKtKeN8duh1OlkDEMoAMaUZFWy7mWllUd6qik/grtnfAaODhiJxfwcv9GnHudV9GU4cra5h3Ks7XjEWf/CRrLiL1thfxmyj3QMDa1fr0GECCLNcbQZoYhNpFnoB0rs1qjDWVS6a8CkJvwkChLIwxF2rB0wPoI2iCXwxlvZdb05v+JRQMG/bCwUkePpR1gxk66lJ+V9FHIOBy24qEtw1gNuWWtHdnPAeSv8dM+HN6ZgLlktX8sBkkSxQrsPmR90YUgM20ig06n9EmhQa1fd+yTqHTOEKVP82dckTT0Kp/2k6m8V9oPKDg1SZQsZwyb0WosTfJJIFfxmt7TRlYFTUcKy+xAB5W0AdW1qSjBVsbswLRwQWzVK3yLaxTqUnCGSk8280Zanprw/PrL0o81Pp11vO9EtIwEq6XpbOKBUgA3W5wFcCgclyM9Pj0RLWZ5ngQnruJDJhkYQ7o7q/0gEUQYTFtmBDdMB3EaRA7xTil3AEzChEVxZ2hEL3qouvdo4tHi20NMyKzXO
 az14qXWg
 IO1KV+njjA/0D8iNdz2j8Q90fabdGcbaRSIQNlw4Mu0N9YcOX0Ec2B/dPF4hIyaNyMqP1NIIpm9AzISGe3jQ7aKyclYygnm/O28kAihTnGZ79pLwsdrlYUKBfXN/Ed0JfNK9Q8T2R+sOPZVXf5kxhRET8SNPxbPmp2IUDLpd8YpV6t70BDeUJVTCv2aTKdZWuUPE5Ep/dXEAMXkATMRtTA65AM7vxx1FikG1qdvpfn5guHjcR3ZTncvqyL4DXKUTiLwsptvTwfrN1mqOaLIi7WP65Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 04:24, Muchun Song wrote:
> +/**
> + * pagetable_free - Free pagetables
> + * @pt:	The page table descriptor
> + *
> + * pagetable_free frees the memory of all page tables described by a page
> + * table descriptor and the memory for the descriptor itself.
> + */
> +static inline void pagetable_free(struct ptdesc *pt)
> +{
> +	if (PageTable(ptdesc_page(pt)))
> +		pagetable_dtor(pt);
> +
> +	if (ptdesc_test_kernel(pt)) {
> +		ptdesc_clear_kernel(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
> +}

This is an improvement on the last one, especially the changelog, thanks!

There's also some room here to comment why this needs separate user and
kernel page table handling and why some ptdesc have dtors and others
don't. But that's another patch.

Acked-by: Dave Hansen <dave.hansen@intel.com>

