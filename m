Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E25CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 12:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61476B0088; Sun, 10 May 2026 08:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E125D6B008A; Sun, 10 May 2026 08:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00EF6B008C; Sun, 10 May 2026 08:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF1556B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 08:46:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 593F012041D
	for <linux-mm@kvack.org>; Sun, 10 May 2026 12:46:14 +0000 (UTC)
X-FDA: 84751483068.04.6F10850
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 77EAB80009
	for <linux-mm@kvack.org>; Sun, 10 May 2026 12:46:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKeja6nq;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778417172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UiYX3DX2mOcITjXbonrx4I6NoJQHM2UHkbJQh3OAx4=;
	b=DsF7CqHBoR3t6AeXdI4IZ8SZQVwUySo4S1PA9/tP4iF0Fs4R7W83NS7gOALlhE+uR4b0Al
	+0VdeusklJogeR44WYIQlGpFTU3Y1JVfr3XfM/GWOxBXsUNtKfbtR2pAht1TZbEQ0Sg1lc
	ONFDHBmrv3Qz+I00tsoUzeQI7kBBl0c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKeja6nq;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778417172; a=rsa-sha256;
	cv=none;
	b=14ZdrX+vfB/BrQ63OT38d5nfA2Z3V9U91j/wAg+pXhWJlrIvzsFTtvFn22gyYU5qnsXr24
	RUmt60i7Pnltst97eSyMNSDlF7GD4X5bNzcqe/RTnuastqILfwUlV8bj+QDAlVl+M0rcNw
	AUMh5NXL+BUg1AJ6WXMkrg8uuzRHhTM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-44c4cc7c1cfso2693077f8f.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 05:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778417171; x=1779021971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9UiYX3DX2mOcITjXbonrx4I6NoJQHM2UHkbJQh3OAx4=;
        b=nKeja6nqe88iBTNLHvNumLeMVV/VGeAg+ThKLWExIxdlvJhBOeBk8K+Y71mwN28GaO
         eKGHgBh/6gibl+TGaqsA0anB9jhB/CGfmDYvAu1ADrJ/B0Ez7w5oMWuDmcqfyjfcCF6o
         i3oth0KrAnh4NEMFP5+b5lIb9VyOwqSUcwjWpyqQYcrSnqeiF1ZF9hSEUVmWCLF0+RS9
         aSHyofO8x/mtEF0lPko+UQxJsUQLTbuOOi11pVEV9pLRbcAvS/7IGU6doRJzcolA73+x
         64u4ptkw4s+78wX8u3AbzvDU7ZEQOJNqnk7sfrJ1F8VVJ+AWaEy7m29y83ox82S9BkP6
         UAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778417171; x=1779021971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UiYX3DX2mOcITjXbonrx4I6NoJQHM2UHkbJQh3OAx4=;
        b=I4j0Snf6cp8YFoCNJIk3MOwk7kwQ6+C56kOm15Z3qPQ1OldPqs1bngD2XsogZogjQP
         6RKvZ7+Q5lb9Ov7mPBKeLo7VfZwCesTm84bKkdhYQZb+oJNSpgpPUodAknfVcviH/que
         gIt/Q9h8r3EFLzMmPt3uUQxZeRZe9LkBwy2mPuZ1/o7O/TDhj8y39/fjCcgAIlOzIYDe
         e/246MTfgZ3prRJWD0N62Rxla8/RV4luCYNvbQaS5YiNRMhkxbjoH5XKCn+A8EPmiSJN
         i0er6H6TNBm/yXuiJ/XSX4PxBR1KhejqUXBvINQXVhuJeCwQH+0nK9N6HPvWid4kVoWd
         mHlA==
X-Forwarded-Encrypted: i=1; AFNElJ8IM0NHO8KTmSpTkGMucDoyzET990L3FHDtb8dGufLwiPqkPeL22XplIZcehE/6Uhu90ij+OCjS/g==@kvack.org
X-Gm-Message-State: AOJu0YxAox867xW6Xi/l8JfV/2xb5oBR/YIZvBNWDjTW1C9h43vbb08V
	Dxqv1htwsFGibMnXIeI9k5GoinFM84hZMq7ePiFb55mNNTPjI87KG6FQ
X-Gm-Gg: Acq92OFG78V0TMHBnpvkQSzla28kIeeC2XPYME2UlMq+cKjpMAQui0KQls7uCdc6hLf
	zSjDK+YYJTK1ziBwE8cA72Z8Nylys4BVglTZfwIu5tuPdagPeq2Je4u5qT6W4JQ7veckCxkRBu/
	+X6s0qhN3AE8O4uLi+dxz/lAmDfLiJRlbH2l5MqW9gWcvFy7ZhHRUokZOXgJ0WewPyjOOrZ7n0P
	uqRmHaIUgSgo70GYjLU51VkJm9PHXvjr5qaoPQ550BKlR9paDHuCIiYB4jDxh+KQXib6KRNKVX9
	pEkMVmwQ7xhGQq9udPhpVy8dNGK8wZYH5dvU9PFt+O8RhKUDHELU2Wr/r1W5pw6N5/3NhybVIeg
	akjiBMFllR/KQ+LO/2JCKagHqonbDPxwKr+adbUvqW7+oVhQJwNYoJuetNm7bMfxB5WGtUl2W/w
	y08IaRPUhe3aO1KeKFFUo7GERcGad71+/P/8dh21fkCsV/m6wMBfdHNwdwOws=
X-Received: by 2002:a5d:5f90:0:b0:43d:6787:9933 with SMTP id ffacd0b85a97d-4515b52450cmr33701387f8f.13.1778417170769;
        Sun, 10 May 2026 05:46:10 -0700 (PDT)
Received: from fedora ([94.119.44.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491f8d4c3sm17943645f8f.34.2026.05.10.05.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 05:46:10 -0700 (PDT)
Date: Sun, 10 May 2026 13:46:08 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: fujunjie <fujunjie1@qq.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v3 2/2] mm/filemap: do not count FAULT_FLAG_TRIED retries
 as mmap hits
Message-ID: <agB-ENpPdELp-7HA@fedora>
References: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
 <tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77EAB80009
X-Stat-Signature: qfraemc1unht7r1nz93fbsautq68uixs
X-HE-Tag: 1778417172-882447
X-HE-Meta: U2FsdGVkX1/hTrwj9ZqSDulc9drW8uF6lctlMdbJ41fsriR5DYGxOJZImTAYlwRLv5O7jX51K43IWhaodQRYuP1IJusJjkepjOOYY5HEvQnuXWOhrtU4+aSKu0hNyP50o8QtGurBrLQFacWCUgW8nztM/5/i/9rktgQRjlhmjrtl78k8gICDpA/puFBbv0tOQZAB4W2JUisZKiT5sOi0aU1scd3YLoqjhoJsGq/XFoJxBcHAiC8sweLU+R5C5U7SbGyrjZxOaxM5s8ZgG0FOgDelevXh2cLcK/9FaIGUfmzIimGbSwY3V1sjshJqVpuA5bE7zK0SP8ljnyKuMMhWCy3y8aN21kMIKpc0eTYNSnm+TzrKzpiJoIzgJyM35we92T27RZwtQZ7S1YwIi+R3IbFV9pdSjm4+YKR5jDw+Klb06Up6CXur1WTdByLfg3zHjn77tRaQOVaT8DJcmMMJBH6xAibKkR5RCkOeSflPvPVOHDXUKT2sp1oDm0PEoHyKRA4CbFosooEIJIBDgC/s/BMiyZcFK3v1vjwluYMgxzM+NC6g3MQT/x6Nzv7U3op7Wz++WgdRq2Ry/XC/uBKHLDAYbMY3zmaumfcRfYw+t/Alt3I/pvrifoByoU34KTgXYSCFv7wlEGZ9kiZU2fRYJuZ7x83KN1IEkAkCufuKfIQJ5jq1Zr3u621tc47Y8h1JdsEiNoDd5a3aF5Y0LvFuly0LZurdyM12iZxaVl70595BSrJaCPAVidzmCnEEJiYtAAguaayQ5yeLvkJZKn2r10FeW8KyMgJZEVIKN0Z4pnoO67sFMnPm8Du1uFKA1Ja+ZGttwN8vXxXCukulhBUwjNIUSpCFTW3oIzgZtoyypYRnQisEOjo0jhQ5IugypOesgqkSN3436lBHa2XpY28gmL+PZl8i2H9SnjVrZC3PhLAZNSEE4RJFqNOVw+TtPAiZcrhP4VSwoOZJwNcW/W/
 u9Xpl6v9
 vRYQEm1TKFHe0tD1SHHy1Bp9D8uZxLZ7tzgS5hONRIoD4Oqdyq8mP/S4VtfePa0TNHM+LwZh01BpKRqDAiuMTaHV5D3VpNrJte5PaazZtDCxP05qs6m/XLikdhxis7xTqsSZme49QY3Yp7qPpKCy6zMaPssSZW01mkE5c51KW0e/0Uc2kG/ZDdrMaL3DBfrIRRsNslMydZuWGTYQrSqH48PvFsVnTpvv+asuJPUSDk+7z6V8lpl9Q6JfToiGGjPFmD3i8xge92lnxXc3POdx9Z8hkEHo9MkR34O9aX42yamOa9BXZOH3cLPM6Q/4Ij7orcSFGwGjeIE/EIl5kEaXPx+z4+d3sEQj+PNp5fOD+pzyqxCui/RRT+d8ozv4OYJsAxrq3C/fkBSvoK4sMFcGWtXbKdvBKEA7lCpUS5yIXtgMo8WK76DmWeY8KtgmI8RAIvBJMJ+WwynqJMXUptmETGhy3gQK8Yp5/lbXeiAbtkFZ0N7xVunM32hbHEdR5w4FM3nqRvU2XhwBbeMtB8uN6/EJeH9r5A9gl9mNXPx12AKkKidk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:59:44AM +0000, fujunjie wrote:
> A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
> after dropping mmap_lock.  The retry may then map the folio brought in
> by that same miss.
> 
> Do not let this retry decrement mmap_miss.  The retry still maps the
> folio from the page cache; it just does not count as a useful mmap
> readahead hit.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

