Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E2B606A339
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=SjJWgH80
Received: by kanga.kvack.org (Postfix)
	id 3C8A86B00EF; Wed, 28 Oct 2026 20:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377E16B05B1; Wed, 28 Oct 2026 20:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243596B05B2; Wed, 28 Oct 2026 20:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D25596B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:02:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43E56801D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:02:05 +0000 (UTC)
X-FDA: 85373711010.22.5E11D56
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6AB5740003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:02:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SjJWgH80;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793232123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtW/sYsNMYd14q833jtnLcBy0iGbA94LyKtY63+yQks=;
	b=gxHMJdGJkNC4ugO4Fy8SljdCXjvbP0IoHylM4AAJPW/suKNLyft0xRcyuaV4hrc46U7+u2
	t3/QjUre+x2SHu/7OD5cjriusX+upKPoAJ48pSPjtcNMCORBF1wu2rRPTihM5A97WvFsgn
	5VPaPapEl3BXsdbl26DD8p5cpu+/AX0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SjJWgH80;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793232123;
	b=M9hG0V0nQJC95p7lWtII6VaYxTSNIdI+qryZjYarswyWVNJad6mXhpd87N1rSSpsipjMVt
	LFwOyG8Xuc6j9vCiLJg6Zsxtm+E0WsHr1z4kqRSSaa57Alh0Fz8Z3N7yVvGU9Lnn2BQQi1
	4hRDuNJwkpCVSVhmn/ME/o6LFrWdP8w=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5ebf39def3aso533898e0c.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793232122; x=1793836922; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UtW/sYsNMYd14q833jtnLcBy0iGbA94LyKtY63+yQks=;
        b=SjJWgH80Os58IOSVlvATTqTlHAngTiTv0N9AloxAzslmTYHMVf+5WvmcAKXeBA8zUT
         bR2V7pcFgZWCFx0b4kGZW46NnIGLwRXXXUbBD+ydb9MCm8OpsF8DaWj7lB25NlwI0w6U
         GaW16boifZqCDXpShe3ZbrcKkIc7ZfO4PMLhuw+paNSvsngAHtRqrfIttkUKekAdLOF2
         g5xp04OFr3Cspt19b1qSIrUwynH7vJFcwcm1TA21zCqslVJQPDP/DzhQdPcaj8qzua8x
         qxPJ1y7SnOHsaqQ7gxwvQjhDC8ZBXiV6OuteklHtC9MvPD/6pnGrXK7wHCls4x66WYPX
         m9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793232122; x=1793836922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UtW/sYsNMYd14q833jtnLcBy0iGbA94LyKtY63+yQks=;
        b=ZJorW8HGi6THDPV071ql1NrvcDCP/GXUM5BTvwv9GUF/F7iVbbdsTZWKWvICAnM/ht
         nzgOQAFaqiIjtwSnrkO21a7o1IQLPsOXnXylR5VS5oh9k02nc73ZGyE1fmV3x9l+ciWF
         O757ZFGMC5FsXXmi0Qh8qcmlALLSNgmPGSajHdmRF55MmFuYKGM6AsvTTbRQrgTr/uNk
         mBfEv5MCTcyFHzZpKC/N5zYNGHf8kWwQ01tX/6mKZuFmaOzUdheusNta48Q0VZ02S+mb
         /5mYOTcOrAefx78Q8/TxdEjVwLq5sXE4uwGlGtYVr3QT7Vdm/oMYfLBNTnTegKLGbaDc
         lCEA==
X-Forwarded-Encrypted: i=1; AKwUvBwD43ZLuV8KSRVVvZOsmKpLueWfhYf9HozirBQ87CBRLqj9X8YQLaDeJe5vhgM7FRPw0VxFk6l/kA==@kvack.org
X-Gm-Message-State: AFq9FYJKrPvg1sXFaIxZCnQMcdMVesV4rKqF1vTwJo68d9B8GfMPjz/d
	hE9qBuC1/qbTlco++GVEHzF4CuSZeM44W5uyRkwVE4TLFyK6+D3aUcdEJNBtn2/jUOQ=
X-Gm-Gg: AYBFou1mfQTEarX5trZAkE92Xw0j+52ioKrq6kfUAhgVzUNeMEh92IqIUwZXjR3+5c7
	BY4TbyB702yFzKDq2bVtTaDanR3OeZ/Kmr1bFE5SFiZijg40ACouXxu/hxh/osv3RroRJmE75yd
	RxjNkufjXEY2bTNNxOqoBuvUuPuBeC8o11STMXr3dpw73iYYwioXb15lgj0Bvw/J+x6H1WWMSLS
	X8vKurjtczjeyBLp4fdUSIv+ocD4+in8EwIICVaME0AMApEwjRmUPTN3DbHFJPl8eo/l0C+Em1S
	wzPlWMgZBmI162SA5wErGWYNTHeDnvJVrmzzVtzTvLSazWpuPxb6PCtVr/mu/oeWoQ9YEYIo1io
	tqH+Y+hNrvdJ9N68CRNQAjwnaCb8FfvjeuMdH4dmMiNaeq7ZAVcenV9yzlKpa04ykxHwn5UkuQv
	8M7OXpIOE6OW5TAQciaXEznFV8CLJfz+/uO4R3TB340BZmmf+bdxfA1+5X6C+N6Nm3pITnpLRqY
	g1lhzgOwq+VtVDlUIYEOsSxzMPwXLPbRuhqTBgZUsQTBSc2p6NdQ5B2RbRwBt9ujudQxRZfaCzv
	zMYyict1ja/YjKuqozvzFDX8O0D5oLJmHzZ6/Gd1Zm97G2FWbwcfcEuw1XhfD2z1qzzf1AsUpm3
	+zo59MTKvIOoGa+xGPI6Rm5sssRKpnu0F
X-Received: by 2002:a05:6122:1c03:b0:5ea:d14a:ef8f with SMTP id 71dfb90a1353d-5ec4cc14f21mr1861192e0c.4.1793232122251;
        Wed, 28 Oct 2026 17:02:02 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f931911sm3523257e0c.10.2026.10.28.17.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 17:02:01 -0700 (PDT)
Date: Wed, 28 Oct 2026 20:01:59 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org
Subject: Re: [PATCH 1/3] mm/memfd_luo: don't use memfd_pin_folios()
Message-ID: <auKJXHWnNMzju7cv@google.com>
References: <20261027173031.763213-1-pratyush@kernel.org>
 <20261027173031.763213-2-pratyush@kernel.org>
 <179321872100.1775665.6881420026761127422.b4-review@b4>
 <2vxz4ie5o2ak.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz4ie5o2ak.fsf@kernel.org>
X-Rspamd-Queue-Id: 6AB5740003
X-Stat-Signature: k1xxksik6isjpgxqdscfzmai6hakdcfx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793232123-683258
X-HE-Meta: U2FsdGVkX18Vjrn7GqkrbSAqNBz2T/BMOyJoJoTJJUBVrNRLBJZuSIPCYIHDB1OerMFWRBfjqujQwvOss34msOneRXD6en4x7IzfWmKYFpQ0FPwOGLZT9cvimFMFAmZGW50lF//R95o/aZA2q7rgPX+gC8eKpht7+CseagG+c/92xROMVNv9kKsN7ldH1X2oM1mSpRidU/LvXLhdhm5BjxzKRrazl6dRfArQ7H+2wbys3WZ9wh8TM3saqpvy3443HSqmnEMehcWj9ZVoe6W/kGNNmV+QDjaPLXXuZPPnQSqTyoey5blIE/m7s32qeYpZrMFa06W4pIo1hYk/Nso+DTZgKmbx7uKP83VhZ3ebttrTZZujhCHc138bY/kIbGB5ajUQyUbew4RGV4/6MAw3MXWxUGkSLhs5cdVQuE+ZwAZ/R/jIsA/iLeGIduVU+VkpjS/mPub5jYswzIDzjR0ylpUIjtSEmq5XzaT9iHFy44+jG30mVRWxmbf2bK+yQbo1N5hsDThUazFffqzGn0wj2BqyjGtHJtn1v400OXh2iGVVEi40unxNmOm0Tyi03tgNH7zOURNXlWsD9SqwHOqT2CIZBzre4yOxEHk0n0HV8FnsHTOa8hVkYJGk790r6Amy3Xlf0s+xGKowb9nvGbCWSRS1jH+RfDnykjuwpRk19JtvkfVxwuVTSMGM4USOLSi2e/g7VjbyTgMRv7tcYTcXfG485bL7zZpIIfwtYeay4wkrz9vW8tL48Y4jJYdoMIMIWV5xVt9fuNPcBHoLMgU7TB/zUfjewmgW3keUZVX3b+p85hoy7TYQGPBDX5BQLZWcUr+49O4S6GVPxoL8MzTuU2NIpaRZVrRFZsisBMy9syzCZThwxAzJ9qmc31Y6ZU49GzFQfQhjQsscJ78Oubipeun2RlLLwUknqCnIY6atwf59udtzgEqSQlnw9WkReY9tpG4o4aJzcHiJXWxi2qW
 vh3UBlLE
 FaRmeOShvHxbY9vlzIoe1frQjaDNLIIqu1pMEeHdhYZPAlZz68XydLsOKtAbqF6vNQ5lCrfH4rG2oiO2gA+P4lkK+ruKIYanO6sMWM8Gnfxfj6vJfINbKOX+w7dr8O28j8GTYQVTXG3/8hj+ZYunILcLvVtAsNTzf2Px4us/RnfM9UqrMQaq6ANnyB0kb/JcxmK673mykbxxD0gjTO9FVBgphnQHIX0+YU62zhQDwx8R5GeOHQk7dpnbXLuNmwZ7EuHwflPXfbpvw6nqZPZY4gM+cRwrwlqqWmaHK0mkQxPEEZnDhBwEVRxQilfI5QnLLbf5M4HDj60WEqxnEeAp/7xjLALdNCFrrVxA4k91zTY6KYDIkrpTwlSPMqvbDgm5eIFMutDCKdM5TbEMDOD6aVHd4byFpSJodgUFWtT0TuHAdEEPdN4KBv8h5TidahaaJ41opuPlfh6s/Ajs+wFN2jo7rRjlK376UmbHiDquY0f2TgvErkqmVZc2/hA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-29 00:04, Pratyush Yadav wrote:
> > Nit:
> >
> > I would suggest adding another helper, memfd_luo_get_folio(inode, index, 
> > &folio), that wraps:
> >
> > - shmem_get_folio()
> > - The !folio_is_longterm_pinnable() migration retry loop logic
> >
> > I think this would make the final code a bit more manageable.
> 
> Sounds good, will do.
> 
> >
> > Other than that the patch looks alright, feel free to add
> > Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Once the nit is addressed.
> 
> Thanks!
> 
> I think the MM side might take some time to gather reviews so I will
> send this out as part of a liveupdate-only series. This patch is useful
> on its own anyway.

Sounds good. Could you also consider adding a patch to that live 
update-only series to extend the memfd freeze from retrieve to finish()? 
That would close another gap that does not affect us yet, but will once 
other session fds depend on the memfd mapping.

See:
https://lore.kernel.org/r/20261022225035.377445-8-dmatlack@google.com

-- 
Pasha

