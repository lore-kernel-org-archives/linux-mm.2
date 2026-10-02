Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE95CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEE16B0088; Fri,  2 Oct 2026 19:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF756B008A; Fri,  2 Oct 2026 19:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8C56B008C; Fri,  2 Oct 2026 19:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3CF76B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:32:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7360C80226
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:32:58 +0000 (UTC)
X-FDA: 85279288836.28.317268E
Received: from mail-wr2-f32.google.com (mail-wr2-f32.google.com [74.125.225.96])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CDD01A0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:32:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/FAcbsq";
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.96 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790983976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owttwFOVeJn79HsAeFoCLAuekwXL2g7sO+gGyikXGBA=;
	b=Qzy3JM8/pr803Hc5N4bTQJG44/hKe+DhN8sikVS0UdgQ0plO9H1SyWuJbFhYYUuppnRcsM
	ABhC6Bf/CSh3OLuvHiHkEs6plmu/DRY9C6T3dGfJ1/SmQFc2bD9lrTie0uu8z3d25jM2NJ
	MPplLD8l2goBeVuiAkYUUBSeWPqHEgQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790983976;
	b=gcOB4ECbuUalzKa65oPcnTTIXEn8rb5bZCJV7vdE4KyRNmdcIEx5kgtcOxnw9mDEpDJAtN
	s8PE63oTUi3s+kdGzfBwu06GgwNCJEcHlEoQ5guwic9bGoCPQnEoPD5hUtpTeiiszXZjIF
	/sxThFPuVyLd/xfA8xJJZXvDEdcfgnc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/FAcbsq";
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.96 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f32.google.com with SMTP id ffacd0b85a97d-482f6350f91so185489f8f.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 16:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790983975; x=1791588775; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=owttwFOVeJn79HsAeFoCLAuekwXL2g7sO+gGyikXGBA=;
        b=T/FAcbsqXqRJpPh3jEoUPWg23xQqBDP5e2Yyn5R6YxT3C4lYyT8ax+B8Zq+8XGwyOh
         XqV3wUiTlh69oFsPZLDGd0nxeFaOawIzbtYtxwe19+u4plrF5UQ2ToBMnYqyM9HMlHtl
         ODbh0EbTr2yCeyvJHg2MLev9k9k0aus4S2Zf0BdwLPMx6lTndl45itsDYOL9884Tk5Pu
         ql8oHR8S8VJ+/co0WL5MVlqt+nvfL0EsUEyuvmMhu8aacvN2pVkau1P9Bld57JtnwnMw
         fzj4C5M0dlVr/a6tONvpDu/e6cELtiya4RhaItfZmLe69OOkauQvrTB7F4nHVVrZ2Z4T
         9I1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790983975; x=1791588775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=owttwFOVeJn79HsAeFoCLAuekwXL2g7sO+gGyikXGBA=;
        b=a/hAb02aIeIwZUC1cAIIFgy9cSzYjcc2vxGMrOhpOJMUIk5f6MMRLiYegUqSttvRSh
         pIUg0dmyaVJOj7YxWGQlHWKsDl6TZr59A9V30B2Lc7pjO7bC1l7siBEEaEri+JRTva6c
         hV4n2yjoirAu5ty24SSELglcNkV5m0l8RgZJClPPn0Jo6O3ySvo0g7Ewn6cUT4i+N3r1
         C2ay8tpRQbQi9opdzlREH8+/7Gl4QvDukz2zhkI8bFgCbKGqpLeaFO1ToEQFdeWK8U/s
         sQUxYGddFPX03Nj5B5iArFZvKXkJIBlwMMyZCQDby+BElJZ06SaHTHMXmunB0qEefGVj
         vfeg==
X-Forwarded-Encrypted: i=1; AKwUvBy+Uk6FbN6X7MYsU/UQF97t3qaEUq+hj4GFxfoXzQyGQEEifwB3dPxv2s+O2nAR0BEnYbFbNmF94A==@kvack.org
X-Gm-Message-State: AFuF++lzYJwWPQqDUndn08KQ6ppeFNnIqbbAs8jAZZvrCDGncYJqCeuV
	cjI5QM6vYLswaB53Zvr18YkgIoubxq3/XFnjnqoBZ77bwDatFsF/IU2L
X-Gm-Gg: AYBFou1yvYUSMRlYG/BicbUe28qZ4N51HNZctHhnhEGfW2aopxFars9NEElfTGGF+0b
	6z40ZmUHjssj/u8DY9SU3vsbbmNSzg7m0MGaYMszPKahHW7Nb3x8fzV/GVLtWkWi3CefSIbD+yW
	9Xh1rsh06iNPM0ykTD5os7t+zz95EePvgW1q+f4JmYv6eCazW6M+fqPvYEmB5Hm1r8TW/EyxoYK
	bDF3C49tBORjC65Wjcb/hbQYsSLKcfrqpLIiwHaqMFHJXlnIzBQv2o0k+2JGHODqnPkv/m9ArZG
	btBME3/pptx5Gh9Fo2dKNCP638osliP7AjojWRNRMKnnBSSWrvt3450sv9dMiPyJGhwIANpkaBH
	lzPcih67GILxC1btwxUu9BCDviXnyka2ikOZgZQNZEvmpzxjWFrLOMfdG+ck4b/dLmjPsb6EqEZ
	RTmj4se3Ar6qOpKB/65BUeIFsg65iQyDmvP8pbfURNiUj5RyBhPw/Z279NZhs=
X-Received: by 2002:a05:600c:6217:b0:4a0:1aa0:7cfa with SMTP id 5b1f17b1804b1-4a027583efbmr65242195e9.12.1790983974947;
        Fri, 02 Oct 2026 16:32:54 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0394e6c5asm92300685e9.2.2026.10.02.16.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:32:54 -0700 (PDT)
Date: Sat, 3 Oct 2026 01:32:51 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 1/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
Message-ID: <asA-ys-Pv7vTUKXU@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-2-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-2-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CDD01A0002
X-Stat-Signature: ths3k68w4spmhd71inb3mcj13pjksz4e
X-HE-Tag: 1790983976-214508
X-HE-Meta: U2FsdGVkX18aKZgYGM5Af+gabDB5j+AWENpGcVUi2R7GpzbpUmRXLwQ0WCqQH6rkFodTYC7Md56H4BEOOMsl9TynknZcveSi6kh8k8hCmDlNPMSo4dtmwRl9yCeTJ5KK039oqYZFEFVgVjf3hp3+THheFHIVHp7M7iS+0PNxVO/HuH/Il9M3Vn4e21k9MFeKCZ9y7XeFSpyq8IeIUdYuJUgpm63835fTjfSz/l0Wt9dzFHwU6pfMgIC1CJFRl4b3XxJAgm0KJOKoXNLynkumwzogadlyqMpRUxvQPgvrbKhP76knyMgFoXEi4wWQ886Tlo9vn4WVZGWWuOwA26FbWpepPGZt2LgRlt/JZ8vRnk6w0M0bvryXMFltTQ6amK+El1qicX20CSiUCE9bJrynWHkJrCww/79UdD74Qu5MDZIWQl919ATIIg9JV22MnyEmfOg1EEEF187R3EVY6Jxwam42FGhFPRQh6h4vQFLvdYbhdGYm8b/qIKcR2acz7H52W0wEdLM0NIYrXEgW8JKv16HjIVn1tUJafxfABVSawFitypwrXOPq7fyVlG8aGdrBOePqVdGVoP587+7I9Q9u04nc5BsrIjseY/2YHAG6wQt5LletVHh5LQiqk3R6XOguSpmu6y0bhkdlgV+fQX13DlUN7Hvk5rdT+0yPf1BHT7Z/5tVEiGgkfOLkLwHo/zoMMwiQE3f2XE4/DoixaBY5m5rDIfZeNfUtpo0izDc4OhFrvWeqFmKbtWjIQKwDvxv5y1e6K9YIj3R7A4yO0UOumb3qN3Ray28eSlWLuf8zANP2pQI02f+BhI5LhaqOXzIMthVV9IygS3NcxoDjTcYL02z3pRRikR8uQeYOIekZGocexKz51nCXcjS6qyT2up9qYEZF+C3Cp3NZ1lEeXsWHF0E1TQgBTqAvhYKxMYrP+BEq09eBJdwlEfTZAUuLa1c3RyFa6jBS4oXP5d1YzMK
 oG3w3PSf
 C+Q/WB+yKFdYOSW9vdIo+fqVgVgBifYVdlY4SiYmXQCgASlj6lWpm0JbduJlYCdPguIGTpI+qH1tqZdnN9MC7qpRfL8nQzNQfsMv9Sn52AW5yagNQOPrC1Vqtuk4q3Eqz6B8hsLA4Nr9R27C++38mkoRjQrNlKJAR1gN6/yquSXENH2icrfQuOtIy5jqLEeBtzZvDUwOoFBPrBkElIiiZIzt39uK/C8PQ4R+ad9EAw5Ljydsh8bF0DuGa3Zcmg2WSExA2Txrg42M2sF+/pV7qwCnPSZjNz1Jmhs7tmlYtsOAHkXQ3Wnlr7OHsFcBZQHryb/NwKZRcTPBxyh8i/M9pdD6mvq+vX915Ymz41nkfzWpGcNElwIKNeJL5vVXO9/A5Uh+C3gVjg286XTuri9yFXAv3zsXg6KgLboDvtXBscxExVlSmeptfdzB+9UT4uw7KZYUdDOKwL3b7f52qNsfXiGj+8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:32AM +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers.
> 
> So remove the function and its declaration.
> 
> The comment above the function describes the -EBUSY handling in
> __vm_insert_mixed(). Move it above that check.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

all three LGMT so I'll RB them :)

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

