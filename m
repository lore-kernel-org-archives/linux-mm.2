Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E327C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B462C6B008A; Mon, 28 Jul 2025 04:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6BB6B008C; Mon, 28 Jul 2025 04:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6036B0093; Mon, 28 Jul 2025 04:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88DED6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:50:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3602AB6BD3
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:50:00 +0000 (UTC)
X-FDA: 83713050960.29.29B2D46
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2AD8D140006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:49:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FXL6+lOg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692598; a=rsa-sha256;
	cv=none;
	b=f8KM8krIpJ17rJNMNbhABb/8/D7Z8LGGGLFcyuqqm08+aGoNVLbmnymxuS5uj0p4ySPkQz
	TgUuAjaY6qzXxGs+/Kl+4fcVu1Eh64y0w+ffZQwb6ZhvhhnLMl/6mUqOF34eb+ACqeRL+h
	yRvGlPtgKJfaoj5Egz4v2FAHLVEO89U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FXL6+lOg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692598;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsN7y/1kzG5yx277Iqzf5ufFB3MHq4CNNEmgUnJER1I=;
	b=TUm1VEmXwHi4g7DG65x14rlKmoULReSTUHaoS6H1PwumuNG0Q5pY+9be8ce59bR6ZxIxyP
	AO0w0WAhhixFol0og5LNipQP/lRFK1wSBD93nPaDeGypMTAq1EtFRfZfQqFxg7ZkmrbjNN
	PaPQxxWF4NYmoNQVYdpINM1chb65R8s=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae0c4945c76so579578066b.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753692597; x=1754297397; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsN7y/1kzG5yx277Iqzf5ufFB3MHq4CNNEmgUnJER1I=;
        b=FXL6+lOgB93JPwdxEqcLnadcLdU1i4L2saZpnx0XacB6FUvz01/iwdzftKF/pKZG7l
         W0fDABo9cf1vjg+hqx64IplC3QCTRX3ckTeSPzATQlMSvDcOox6PTvVofAr8WCJAls1b
         I0bDywHbAyIiLSpAMq8L7AoFGVkaScy0CK/yFws9mNv5p2eG72IKQLeCKANeVWudZ1BE
         habnDkvQCYtfjMrHX0MFnieBnt39U4LFCmbWpJZdMnKOydg+X+mYBGFd/ucGXWbRKSNN
         5glWNcxshri4FmOEDC5cTRvPH72y21dm8nRfrsrCYreAPLhfC0Tnhl19pKXvyIjzJl3a
         GY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692597; x=1754297397;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nsN7y/1kzG5yx277Iqzf5ufFB3MHq4CNNEmgUnJER1I=;
        b=N30A97dArKvOo4TDhvNYN7OpAYCjghXla4KjZNd6aFT9B9dhbpflwXb8BuVbmBdOUO
         +MK00x8B0hpvYSACXkgwtiszHEtmiXSJMPxNGO6CRKZexcInMBOS+33gz6IY8cZj/txF
         JE+fioaPu0LkjtV56n+sNwn8//KiyyGj8oZn3blz48FDbOf1M+acjlypeVZu7q6tiLIY
         7BbMe/iy8KEGz7ZrNw+xn+v3T4HDMIqGvzIwSEOlY5qRthGQ3hyXT9L2vDewyjgddP5i
         7haH3l6ojc6tCZH5ZuPzKOk74BdLUGnrpEw/EbWBaIEiW/8Wzb125G6sDP366ek7DvQl
         tQLw==
X-Forwarded-Encrypted: i=1; AJvYcCWzH1JF49QO4l8OucaivRTPI/Y6we6kgPMjOfrhkAMDTZPc6R4/jngtjqA1vTUOCYqGlLh92rMPQg==@kvack.org
X-Gm-Message-State: AOJu0Yzcfgs4OblNiSqvfwkwuG+ZFEqWuUBvYe2VprYEZvvrCMXhXRZZ
	6u8XFc7EY49U+/EC2SJhDOC1EwvZq6baGNJSOYpzDVX67WfSJgXjGIXl
X-Gm-Gg: ASbGncvBcYY5MQOMimtOQxrKA0FIwj0GA6jKSvYUmeNq4sjd+L2nTvKsjBglzfoN/s7
	KXIfCOcHsE3Sgrs7Anx+nUMBEmu8ph44proo0h+NdT7PPP72VzgxrE2GvxmtT/xZvvHNY+teSFT
	0UUlsaWPeil/FcRV3rZyNgbVz8APtHH9Q0dYUXo6decsk910dwJn9CtQfwuIB5bY03osIcLWI2U
	P7O8wqcSNL+cVkHP7VPmXcK/d162oFab3ZeyScDzjwoDghGXF2kzDAsCNWUHY+xu/kUh0CyrYLO
	My707uIOKNPaW5KMrM4pgpRvfr2CtuVnj49k43+nYaY+3ijf6C9FVkLgV9FLL70UoF9eCAcBfSf
	2pC0xMHo7C8lhTgE3L+fv6A==
X-Google-Smtp-Source: AGHT+IFaZJsTQLzzOiXfl1Nq1UVtUOTF8P3susmSPp5Bc8zyCjo/DGmP/Cxh+cs7YnmCiD5doe68aA==
X-Received: by 2002:a17:907:3e10:b0:ae0:d798:2ebd with SMTP id a640c23a62f3a-af61940ce29mr1071644666b.35.1753692596383;
        Mon, 28 Jul 2025 01:49:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af63589ff78sm394541266b.47.2025.07.28.01.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jul 2025 01:49:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 08:49:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 5/9] mm/huge_memory: mark PMD mappings of the huge
 zero folio special
Message-ID: <20250728084955.uzobxwoqalcuhk72@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-6-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-6-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: n1mtrsuz5c9fm4tudtr813an6b7de7u9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AD8D140006
X-Rspamd-Server: rspam02
X-HE-Tag: 1753692597-678973
X-HE-Meta: U2FsdGVkX1+WWw5v9f7Ip+gEDYmXvfn+GA22aTo5T+c6rtIxunQXQA04DR0Pxdvlr2UgYB0gwSgdddhzbXpeVM7qLUB5Vmj7aPQdaOIquimdEdTNRaDM18h50GXmtPO7dn5FqAwRCY/e8mmczDRVAFEPAoXui1IRl3yZ9W8VthCcKhgVFo9WwpevV3isQ+MaiT/Z6z0t4kKG5+xogHq4tTmvRKqXT+HBYdpNgBKhDR5lZfwOLRqfSsKI6irNufexXNGQAWWVqs4tiD5w5JmqHv0jx7pfxcMjNZw5bsM+ENAbWFF2H4hw194Mw2zJVlySFnsqDBm6Ty1LZxT6+n92sXsFsVjHUtYxScSgu2OtlyarOq7AhCWjETkrhBnA7QZe80XueHFcyExvPQgIgiy6gah/vqCIHIbLYc2n5485qqz7br0X12HzII6U2AIpqHAJm80u3tizXi6yPJYXHXwCWvo/voKNI2NcxK7Zo1s7SPwfuc+XJ9Z+nEMki6A67pekkpHfaHCKfkDHwtT+vrlZEGHaa7G+hEb0oWEwBIGnf2/M+W8NI9ZR8mspE46OIBIVBaQYUJW4NNz3gaTjCxTVHrOjdbxhUbHEY7l5HAYildujx4T8LyziPGoyXzBFarGau9L6b5vBnebWvQse8h0IGYFH8US3X+dze9MHZPKOU5+k4VHeE/5ieRV1JobLC9/BMJv4ztqh0SarVDvvHIxUO56kYMII9xLtgUsTRH3uHIvZweiRHqPadn0tGCd6xy5yLueQ7uXcHmNrKJAr9OQzLWcnWf0sXP8nLzDWVxn8CIRXJlW2b0pvOGbx/NKXPOIrPjskikpC/jR1BrVZaxPexAVwyYMxeLpwBfHLmqYcgzzXXR6RbW3HeYHYZIwvHWxh4xZcQMbZh5dlLLAOsobMY5r5lO92dG0N5+70PPeHXmhfsnQ8+UKjg/bzcLcmW5B48CUI+wOiTz0T94CE39e
 lTcqG38P
 8kQVHAElwv9vNTgd/dQ6FWJGOcKrV+NzWYEKZ1N/G4cKNIWOO9XrQWDSVPWI9yps5+M9FFI/3jY36XUku+P+C6aMdUqM3Omky1QbJ0fVYNUhR4EqekoMjJLBGS+bkSmJXD1l1fAexnr41Umn7SY5frpaZJYfxg+uQzt8dnJif00dKpRy3L7qcLck7fgZjY/ZXbbdCNmb6QsFwt6P3Nycbj2wmgPeVtv2VdGYNrkZfhuGPvYbhy+uoY7YiJnGcDPjWc+8cdh9Ti7rodjbWQR0e1KiNEeImKHyCw/zKr2i3KDgAMRrdxhKVmv0ucJTLRarFBinpbnSCqEx9FGpgd0oJ/P+hS4m/Hf36GyCI9Ow1Pf+5F6BUuQj+jZ33n42vC8QPvVYqee4nPFfYaEVJoLKKDpscFjXJd6wUlDMpBX6ERqprSdX/XJgCNs+nITzDrM1TN5iSW5YKvJz/p7V8ubSh8xOLXiU2EiHL+Ub3qQvIMhIJmwFNbcuvZ08QbOp75OveDBsrvi3rFQqgR2J2hJag9jwli89tbO2M3daA/GpwyvyFh5QHCyd+SJCrLpwUomJ+u/AxlbkABKbcImcQeq7QQEzTABgc9y+kY6HHoGIxr2Uk0GY9pefXxw7jQKF4pSShcryrR2LQIytVQtNrOvyflpr/knFz3zvZ+CEKftgUY4ZUydWIFeKMcZ/eKxxBAblBanurS8Y99/6XRVHmwcbLgA8MlJHdluJjNU0I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:08PM +0200, David Hildenbrand wrote:
>The huge zero folio is refcounted (+mapcounted -- is that a word?)
>differently than "normal" folios, similarly (but different) to the ordinary
>shared zeropage.
>
>For this reason, we special-case these pages in
>vm_normal_page*/vm_normal_folio*, and only allow selected callers to
>still use them (e.g., GUP can still take a reference on them).
>
>vm_normal_page_pmd() already filters out the huge zero folio. However,
>so far we are not marking it as special like we do with the ordinary
>shared zeropage. Let's mark it as special, so we can further refactor
>vm_normal_page_pmd() and vm_normal_page().
>
>While at it, update the doc regarding the shared zero folios.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

