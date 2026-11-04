Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154FE606E821
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JfHVVkt2
Received: by kanga.kvack.org (Postfix)
	id 2BDF26B05B4; Wed,  4 Nov 2026 17:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E346B05B5; Wed,  4 Nov 2026 17:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186276B05B6; Wed,  4 Nov 2026 17:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E12656B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:32:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73D414089E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:32:24 +0000 (UTC)
X-FDA: 85398886608.05.7E1A51B
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B5C7120006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:32:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JfHVVkt2;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqrMQTautnZWVcHeal8+VHryjxTdMHJnQLEYqFDhRfQ=;
	b=yUXBEtC3Ndb6yJkhpIAyYq0exi0SRowDB6nUm/D8okP6bso0DW1auZFM8ptyS25g9+V/pC
	P7ZaYCFv8xLmT5avrLi6lOuA7iBIu+61LybNSYUL/f/Vg/slYtFa6GKkulz2UfDxITM4cU
	7ziUnPrPOLy2DLpRk8Ht91kpsCqgHxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JfHVVkt2;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831542;
	b=NnoPMWem9V+lZqJJMwWYCKphN/DrfJQoLLV1rgwfxI7IUW6sH9PcwfPNm+m8CzyRbEodGC
	p9VqsFOgNgfFpTcJLZ34KHohxzMFQN7BMlYQ+pJHR45WthtM4KDQym7JYdZduUnD7GxanU
	aigzkXpK/95P2f9cp96yM66FCjoWhx4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e60f9af6e6so12126255ad.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793831541; x=1794436341; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AqrMQTautnZWVcHeal8+VHryjxTdMHJnQLEYqFDhRfQ=;
        b=JfHVVkt2wYKTJ/PhWOpLuv/6JXcYnjNiWnNV4ryGplKiM5PkI9C8ooOyI1NB+HeHOg
         qFjsvzF7t2eXScLysLVPFVJK5Ap71gufs32pNHPlxEE8nxc4aXla3yUiTuMYpcZPrAoh
         ABsV+UqLuS5BDVF0k5IUFZdPryoPstCYABNy6SwUB5Jb59ZLGe3lSSJyCfxRp14dMFTv
         OM1XHpG6Tn7rPraY7+SLe2nsVNtqA3oiGrsx5Dzrggf415dUAw1MgndW5a1faHHMemoe
         CPuek+/6AxFUW0V5K3vtFQQaCj615Us8X9ayECOsn9DxSZ4otNRE2E0OQFUkGIosET7y
         IMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793831541; x=1794436341;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AqrMQTautnZWVcHeal8+VHryjxTdMHJnQLEYqFDhRfQ=;
        b=Rj9ZoSgp0BXe4QMnpaHj24lUp9Iqx9fO+xKYN4+nuV3hpl4PRu8kV/s4Mf295z4+fr
         otTVuCg+CIl5VsG1BOmiZdhPRGdbW4W9Fws3k/r1c/lnMkVDSnhHW6QLXwNqt6he8lN8
         dumQGMJIKayMGrYY4cEWdK3/vafDIgjlya3trpf8QJ9vI27AIqCT3lmQs0mPjAeyiXqg
         EFp2J+V31DsIvfKSlogcoqNYbKATbSMRbQ6KAKJtZjrp/hNDDa1UhTBM5YZOLFBdn0G9
         yA97OC+h+2gst2dDrj76l5vpx2eO6KY2MFsCET7mf/59GKauEzA1TNWGkGxSmaTJSuFA
         +7gQ==
X-Forwarded-Encrypted: i=1; AKwUvBwptMYhfDElxWYQKUgQQOK1jvW9UJ603V7DEOEcuTLh8BK3NSll2tdort0y5mvCbB11xw/hE6d1NA==@kvack.org
X-Gm-Message-State: APuU4Z9ZhWBjmOUsnm9DeY0LMX8DuPZKcY1Z06KdfDW3fESf6loKdsht
	7AYxkOsSUzpJbo2Yyge8PZ0E36hA/GjK5yCdNlN8++n8Kjgv5ysaC2U0fGTwJ9cZkw==
X-Gm-Gg: AYBFou0IeeNuA8MiSiUr9ZIeaskCGn2oOauKYFPlFHif6CmPqFZqCYoeErPnnpnQVI4
	Ey0xSM1GYc3uzV40CAdJukg9pI7RodlVgZK4rTSrIFNfJWkwKljxnPHHcW6Jo1+6HgE6uGrszNe
	DJwZtxHvmiRIFwRemAhQiRtUKBy0fdUU3M7wMBme6WKqsG++IpMO3MHBru3d6nd/tbHFD3cKm0m
	FJ77FlJiaZrRTB/O6gk8A++20ptWxzHnVwhPQQ0CNqsEfjV3595Kdc35KHCOd+OdJlCNCncViJi
	piF0N0u4UBEHNAwZ7zy9Vo+UQQGis0bh4u0946eJI1XjT+9IDu44YkzjfwBEtxhijn2T8yd0wYD
	zJdPQdKVa/D1iHdXHZ1Z7Qr5aW3ljUZ6u/d8P1Q7gtevrWY5lA7bHTh6e6pQ6qpWs2QXfzPJI9F
	Yp8Jz/BA5n62di31ETlzHy0GbGqzC6RU6Z2ez337ZXtIOXqVDqzILDb4gLez7Qjj24rQ0cf+EBc
	EIIXpi0xLgmPaQ0MVCN2MeG0X7iLFKhQ6qM6HcEOEcNi9TYs/XfNVTEJ2gLJd5JWVvvl4/V6UBj
	iVGAYQJ3Thsh9hDpVUNzGsekbe4Aqmdro9GcltoVT7Xp2/GvPBwmTnaUBQslIRODiV4BdDZwl02
	BiHwu1E4fJw==
X-Received: by 2002:a17:902:f603:b0:2ed:130f:869d with SMTP id d9443c01a7336-2ed130fba9bmr22390155ad.43.1793831541004;
        Wed, 04 Nov 2026 14:32:21 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed090a1475sm11919255ad.41.2026.11.04.14.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:32:20 -0800 (PST)
Date: Wed, 4 Nov 2026 22:32:15 +0000
From: David Matlack <dmatlack@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 08/10] mm/shmem_luo: Allow preserving tmpfs files that
 are still linked
Message-ID: <auuyb7FYBX7xdr5z@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-9-dmatlack@google.com>
 <2vxza4nok0ji.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxza4nok0ji.fsf@kernel.org>
X-Stat-Signature: n9wpm6thyhzsiimyyyncbro6xp493dqt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9B5C7120006
X-HE-Tag: 1793831542-428974
X-HE-Meta: U2FsdGVkX1+3KSp3dY9jY1q6kc1f2sEwcrbEZTk67BV29Objj1FpEK4jONNNJTnSaqN4mILZ0d63CNM12RDws5QC6WHORYi97m/Q9sBGGruvQwmeUQxPDQrUahIL68Vd7zdXbrGIf0AbmCtyppygMDdF4+fvFnADmmYHzw2Z5x3FUAVxV69QSuYNgF1h0BxXmIgQ6dGBmQouRPs2V2jG/9F8Hp5i4BhZumDpcS90ZZCtuUyyaSKXAsjEBNI725bmBltx08D/VNuYsV32GP1O9W1qeoHlLrm+KcRcDvzaMJVA5zXgRTX5shWcPbQjpcJxYD1Al37JCJyI5DbhRJQCfz18YNxhSLfVjOG1/H8usCOMRFnEqCbx9veddaDpZWCCP/BZNxZIliX8l54xIxM20fTg93kIeQlGyNiFpL5aIgiP4W4A1XLKWkXBeegApJZhI4HO4u9Uw7jejd3CV9le+qHQ6mvHG3y0YdhR5+vHzKtg257SXTvQzDp8bWZ4cEm16GxkAB/soDNxjWdz2sZ3WCi6/NV882RvYLO2xY0Wgwn+dgYmj4GLAVzNJQDNsmzoHVwnAYUSYHer1khZkbLmm2vXasc+3RgWyT7R3FDQ0BjcyNgOe1Mt0yq/5HuR1etGnh1HHZ5Z1CrvFOcXR85meK/cYTU+R9/Q0dW7YK697tFvUAzu8NkqD0GRbJsqw1C9Tg3GqRc0PwTNi8IEEI1pp05RNyIMbodeBHrhbTihMkCZg34zbzL3Pd+QC+g4DCm6z53vX+33aHhe3aLsZP0mywIF1ZY06VgI9wt37FKF8JANyYWncHYqSewro0ySZW5eQ/0I0Rz7IthRf2jRq0uyX1UUgYZfCGS6Q4JRSwb3FUbbkbXtRmTN7dEgTJANZmM5RSRh/Hdfjm/1BVNfvQhCbuY36HAmBt6d1AxDIFNPF8uxctIrdqCS7zFJENmIwVjevzlQWgedI8FPB3RlEgG
 8BmF0Aoy
 ero7JALfYX5JDBx3/bUmVb5RnVHq2O5n0yxeCRbv94OmEmpdJBB1dB738FaKthFRYbsU3ItHBDYrBnjdKnpJOhbX4YBlncL1YmKV0ShN4po2R6R386CWHsIonYoJJrX5sY9mzZx1ykVJA3sziKle7txgz2vwirvMvJGsEi1PCL9R6a04sn6MlVgA3dmU8FXaF+E9S8l08qthIjdpnix7nJwvLA2rbnfgHkz5sCxELoFTzsoTsOVJ7kwv0wPhRC0JeaMUlITud176IIiKYyv4tdDIyYlNxGkO8fUOVi7xJoz73TiAEze/cCGnMGV2ZPTijuR/Talgw6XGzf7WdHu/MJ/BtauGiiyGGCVQmCTKRkvrFP4JIDODEjhVTsy8IIXhqJzcaNFbb617ycpcCKnTP5vBvZ9rUe7oYI4mS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 05:45 PM, Pratyush Yadav wrote:
[...]
> > + * Preserving a file requires it to be opened for reading, since the retrieved
> > + * file can be read. It also requires permission to write to the file, since
> > + * preserving it affects all of its users, as described below. But the file
> > + * doesn't need to be opened for writing. For example, a binary that is being
> > + * executed can be preserved through a read-only file descriptor. The owner of
> 
> Why are you talking about preserving binaries being executed? Seems
> oddly specific. I didn't know that was a use case we cared about.

It's the reason the check looks at permission on the inode instead of
requiring an fd opened for writing: a running binary can't be opened for
writing (-ETXTBSY), so requiring a writable fd would make it impossible
to preserve. Preserving binaries is a use case we care about, e.g. to
carry over the binaries of services across a Live Update. I'll keep the
comment shorter and more general in v4.

