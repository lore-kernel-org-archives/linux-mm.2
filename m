Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070EBC982DA
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 11:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5096B0088; Sat, 19 Sep 2026 07:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9966C6B008A; Sat, 19 Sep 2026 07:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC496B008C; Sat, 19 Sep 2026 07:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5956B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:18:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D43E640219
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:18:53 +0000 (UTC)
X-FDA: 85230264546.14.2C094EE
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 161381C0002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:18:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZpN2HmS;
	spf=pass (imf18.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789816732;
	b=vNWywclNqFfAuAbw5MFEdO4y27ADUr0R4N5yLlRFzqXviMTjyeyQgCFKAZVTKaLKMsO/RA
	dBwCIIqgRhFVkOfBk5Hhz3LhmeyQlHny/Bm5BHCJ956eGK2r8D/lcS2NttbMclOaIZg06K
	723YyhKMD8HLrpwaqX/JVzrzHqr06e4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZpN2HmS;
	spf=pass (imf18.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789816732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L39ypsoCsaXODRPsYiAzziW2qCyMrLIBDm6+2y7I9Pw=;
	b=GMJm0NykcUREfSj+tVgEW4tjYp+40R1UJlAA5DEF1RuWThyUq3Y1eeFd0+Hah8U6CMb+Li
	7XGLDI/zAcGmSKwHlyLfH104RcNfhL0dg75Opw0hwcCnVjVbC2aj8w058LpGRC7QRYh5Ol
	M9RvIVpvfI6MhRxztBGc3h0Z9GoOyso=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso1648544a91.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789816731; x=1790421531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L39ypsoCsaXODRPsYiAzziW2qCyMrLIBDm6+2y7I9Pw=;
        b=TZpN2HmSSDhlRwR0cX4DuLctR6ZOEVbGEpw8OSkSjOZQGtR4DWT3qKF6ZOUUw/YStS
         oII7M3JJi7yZxDFvKtKzau1sWxbQ46L+O5kdlcIy7EANcnmqb2LJbYxX63NO6WnH8pYY
         kEeK3Su86JmJ6iSOUFmuva3bdt3FBX+t3hTKH0guOx/8ghgAD4h/bvkXN69awDqHY04Y
         ljXwO2XWCg5QtM34pDfrcDxAKEjADZbqkqjTmsxbwsrEsq7a7rGTOYpq00p80o24a5E6
         lna+AEezkwEgNa0HIpKkG8328D18ETO1PrDkf6onDeKdRoDwdbrg8/T1mFA/UMcZIr4K
         /PFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789816731; x=1790421531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L39ypsoCsaXODRPsYiAzziW2qCyMrLIBDm6+2y7I9Pw=;
        b=OEO2RJC3CNiym1ZRxGstZjHN6NnvIkff8iRGFjNrZgZXZNQAMiDeUw4extjhEULIt7
         V3hRSJVyUoR1c5/mLFURQia0DCdMiQT9lMeE/CvFod4o2Z3BrV4cwugjo+kGSoKycUA/
         3ktCz4I83yWE/L7oV7r16i19qtTyDuvUM2i3Te7GpQzXyzGyF+gdnqqSzBmYfpmzD9YH
         b7oyCISrhFpPoYDcawpjCU940q/ovbjZGTllcGHPHJrvvvot8EHcuI7zPj84anFruzWx
         kTPFus4KX7glcfk9bUVZRNmUw/DHf0LO5/YU3wfv3FAd3dJ5cyi1Hz9bDeUikh0qDMNE
         HW/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxzZPSw96grmuk7ufc2mNcJd0WR8tcPpQelCM1SsUgDZVqC8XxodjXeK+mHNanUyX1hDeMw/8bYAg==@kvack.org
X-Gm-Message-State: AFuF++nL+xKx9azDgUm0pDdATp6AjWMWG/we7SAeMi9bN6WjMq+ngyoC
	6aiNqmIhCIi9CpM2LGVBdCx4Pgzhgh2G7Id0Uq1LU/+eb0F05FncgiIC
X-Gm-Gg: AYBFou2ldrgVhNrMIcEA1y1gAGH/7ZucT72xJ6WRrz0WQjAp7W8NkjKhWGYYlFckSLE
	1d+KREFxENTNnzd41u5jghxCiM0TTxDmsvNqwapbsyfDUrjRIeXlmr83a8XYxziFswFJmeZcFd2
	PPrQOnCQ2I0xf7IZPHjpeplYJ70NDjhvBmHZl3nSPSSKke2kzvXEhLqTDpzT1NueALhp+DqYeYy
	g0JNtcykMjNx0jjQgdX1D2ON7ucA+1AQ5gcMt7mjigU6TP2dqj5GdeNqYgEjItSLLFpFX53Ru9r
	PlrcCdQto5HvdXX7xz9VZdO6CDIVeq+Y06eJq9Li0EhmOxYSZ0Xc2tNRzz0FVk/cfYOyMeLM66w
	EShz0Ce0g536Mx11hY24AX0AH1Ps+L6b/6uZ95ZnzF7wqkdvmWoRu1psV5bifcrev0LRVDqC76f
	6IM8gtvTZ1nER52dMwvYoiLmR2t+ktnzX9rd2qzG4y52LbVCzqoHE3+AsYJt+hQRkQMEPHgmlvw
	9T/DXsDB269IixN9xiZbbt6T6f5yWTPK7Hz3fkOnUvCcbRbKqkATZLxFkxwVrmJDm6aeFwtMWrK
	YU3UDGsCZqlV5YrhXBVEq/PoEg==
X-Received: by 2002:a17:90a:d410:b0:39d:f024:c7e2 with SMTP id 98e67ed59e1d1-39e54cb099bmr9731882a91.4.1789816730922;
        Sat, 19 Sep 2026 04:18:50 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c4bc0d2sm4086100a91.12.2026.09.19.04.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 04:18:49 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 19:18:43 +0800
Message-ID: <20260919111843.656-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <8cbbc303-59a5-49f6-bc14-28fbb58350f0@kernel.org>
References: <8cbbc303-59a5-49f6-bc14-28fbb58350f0@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 161381C0002
X-Stat-Signature: ars9kjte7enrc5cd114ys8pkzq6we6sg
X-Rspam-User: 
X-HE-Tag: 1789816731-141310
X-HE-Meta: U2FsdGVkX18YyGqFUCmvzqc+WmyAhB5LepakDzGPSUeA7zecJptFailvMKAGbEAARx/Wp/bB5MZ3lN1KG1b9f7Dnl27uODFPe+pxI3LUsP3wgF4+gLVdj8gks4cLyP2wr9eC759tDPlSacs14JMuS/sA+nYnIC1fF+AmTYzyUGqvmBO/rGNKUUH+1yTLNCE7xUTL2D6zlBJ6WifxSOgw3AgEeh8pkZ7VvKUo9uFoVU56BK5KNAkfk+4nNFmO0fQxNd7UP8mp+NnoJidiBVBkX+s80fw+14RjNx3bvgg2qz0xTtWUYIiXQs6jRb94qnWkVSrwQlTBwsyeAU2BJIM7BweTExIZI+m8iaFkwWzZaMyL26XaG5KIqj66gtFDLe5t6XGfR0UQ8OMQR+T5sljsxhaUjpdmV31Mj5f18olmz6zSk2z6neJFWkPKwQxoZQYsONytPOXlR8yB1PJ14y637akVv2Wlr1zvB5BlwlnOP/cZgosAeC1xPSWrRDy8CfOILusUJGmtGhX1JQMr0szVYqn59qN3PcwHX3cpWtTtPV71bFlb8xjcM8Ndgpg/TN35R+WjSldrVQk0I2scjYF/nBx25HfOOIlZeCphHrewohQWW94buSrb4tCukOOkBaNiuCGKjcN1nyDYGMJTO56YycHnlPEEGlwrYMULtD246Y4pZHSyaHNkEja5UPBHAAxbJcAOnO0e60Vcnw9EF/bb9/rwFYrtgx80tJdXOiGqbIELHVm+986ycab8maQCHuhiYm66YtrvchQoDjQ7pZHARUfdiDVBieDezzHIDqfxUiY5s09xavilDfqxesXL3HWapV3/3iyxF3PlPK4lx+4ktpPBzqMfUU41sfkJDVSjSBEX5E84Z5D1vgtjWhT8A/0n72az/UrK8UI9v7TMyLe4p/Ah01iX0BugtO5/pxsWMMcjgcXnyFZLzh+JNTjmKJozW96yfbYFyC7FH2EbPIS
 zDjnT8XA
 ExSKs7/mR44GYJInUkk1UcPs+BXXFcSwDT/G1S62MWUEwxbH3TJhnwfMbdZkcA9jRGiQ93lvhrH1S0Z3ZdAgNf+4jb5gWHG84+55sASKMX0ym+dflJ9K8O9khsNLchEKgZl8mMjnw/GXFIHcZnS3DjJUl2jS0KDH2Z4scGM9rOEO8P2tlZunU/cXPbutMeyPc2LJHEO9/P996IWSlx/m1QZD/h7vTHWsSYVEBfPwlZ9mpOxE0Ke8vdNjmyE219mNZkpdL0O4E2A+EosrEUjmFhIPoubYjEbe1Y4rN68xaAyU4l9e5ZDCAy6p8nnwiD6RvMevbL6Lwx43NIIyUzryA0Dq8ANpdiGgR/5YgC93yfI4Zt8Op76HOCuiRsvsJJ6uyXWT0iNh8kwwdZfVKF86Pxy/A7UR5s5JzpKCa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 12:08:35 +0200, David Hildenbrand (Arm) wrote:
> Please don't send out a new version
>
> * Unless a maintainer asked you to
> * At least one week passed

Understood, sorry about that.  I'll sit tight and wait for the review
of this version.

