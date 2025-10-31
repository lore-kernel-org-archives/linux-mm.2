Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C2BCCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1331A8E0156; Thu, 30 Oct 2025 22:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A4E8E006B; Thu, 30 Oct 2025 22:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B618E0156; Thu, 30 Oct 2025 22:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B748E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:32:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8297A140281
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:32:17 +0000 (UTC)
X-FDA: 84056835114.22.01D39CF
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8415C1A0009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:32:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VXsRm2pT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761877935;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QV9/aau8/kBCbnurL+VQAEoEEwOJQQtoJW0VC7kNSaw=;
	b=GyOfuSzz0I4erFNfLpAjpU1ejkXXO7lazgTrpCpOCLR8Z68TY99IbGAymBsqB7ozUwreJE
	mtfrJaPKl5SAwds457ILZWOXXQE0QhjrvmbTSz3c30AZffXxKPLblhAuctjO5xKWDJee4u
	rBOygtif0QO4kyb0VQqaaojLLN0yfyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761877935; a=rsa-sha256;
	cv=none;
	b=p5Gpwj+QJm3Zi8YWagdIBy9lo7Qzr9Kobu318YQv42DtAPebLwrNkYUQLglJbyih3MdkV/
	jyqUP0O53sV8Nqf29qTFX/Gi0GYVeEG4K8NVE4j/o4AaxmGJn4ZauGc04WroVFGyEVbWWi
	Uk+ap7xM3cedtCmOZL92A+yIwLsNK24=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VXsRm2pT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-429b85c3880so1529489f8f.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761877934; x=1762482734; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QV9/aau8/kBCbnurL+VQAEoEEwOJQQtoJW0VC7kNSaw=;
        b=VXsRm2pT5hoDGPxmQHwzpeILjjrcLjM/deJNo1YIXiH7XCVTBlipeNLPkX4RdRX5QC
         5aqcTZrdnjOiG5UckrTAWqBslWkjsatpXVlqeosxXuoqAkvdPl4OdZ1W+1V9nCd5kNmf
         ID4Mgjawb/JPtLvpZcrwkpvWHytZXxIu5XdK7l/DpXZU/PhURTECmtlgTG3YajkHAmp6
         6NK0ceDuJ4E3a1p7lsRYEUTF34Vo5tABgNIyMnUkqh/e0+Y1cLKXVai78W1pSJv73qBR
         YEMlslS/d2hpqi6z3xvR1a0fFwpi40BJhPcNhGPRjAZ4KxnOY6kZtZFuxc/8gpfSSDJL
         /JcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761877934; x=1762482734;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QV9/aau8/kBCbnurL+VQAEoEEwOJQQtoJW0VC7kNSaw=;
        b=LQY/UZioIeAIJbDDnef77N5bmyHCDZyUDe791wW8vCWGxT9m0WOY9Mw2ixRR5X4sij
         WBRQmjCnDHUXdzCYjnmzgwP/d1yXuuF+AYIMIexd0xMxnHY+9XXGXUCgleUf7nL7o0B/
         79GMVbW5EtINTK/vdGJStUia8K6aw/4DOWh86ENW0Haj5mUhNG4lVWDo2gMJGt96S1Nf
         Oub6xcnPej7nNKj9NHUHr62hnQaO0pOZMbrqNey7B9S+HFkUNfzlhJ1hbg4YIHjyW3AB
         fiQ13e5BXeNLAg6nelgvKBGqmOByqS3o0Sc3WFY3FC9jSx7DVw39fKP7ObXLaoYAX0e1
         GrEw==
X-Forwarded-Encrypted: i=1; AJvYcCVe2oA78GCRvaYO8PjB9/TEYSVFkpId1wPbohSFcal1tBP4Od8hwl7fEZeeu5S0rAuWN7MOpNrU/w==@kvack.org
X-Gm-Message-State: AOJu0YwrHoDhIFvKWfZuficV8CMiOmXr3CSEW9s7H0YswvjZmk6coVNN
	8FosnN7EglHuSVGu7unnNP+IHyUrSjXwesqIPebIbUek1e8G4L7NBdW5
X-Gm-Gg: ASbGncs26iPVS3PObKo/XBxYU/OuHDxB7QQe9FwKHCphbM4i9DP9uBRrKqdouw2NeQL
	76BUbtgksjWyjDalvFe8RKXri5OV/z+Zt1jvM68mebEkNgGX1ua3KBozdpy2LFhDOWIdxg7KAV1
	buA/WshahBAwmyp2GJ95K1truMgJuPrtN/O2kwo/eFITImEKDHU65Ov/29v3RaDEEjEy1J9QeHZ
	Ok+Q4160Lc0y4y7Zi+gGbzuaC9WluSsyvN0Y2SE2OnF2togXqOoV0M24JHkhbW0I/G5f/O0Iq0t
	3mOOrv2IbO+9togexxhh4o28hSanBe0ghJji/uQKOe10PetKVdUkonh5MCWTW+71BsgA36BuTfL
	7c0yyxucJFGLydHbN742pYWetd+NiCDHud01qpDigurjsU4V5wmL1fo1yBgQONB79BCystYPJcw
	wFqWIpyyLPI4MQYUCslCSy
X-Google-Smtp-Source: AGHT+IGDjmSI9ZsALv2eCXVZl/4MAYrL8m6rIPSbY8ME0ISG3yZXFfPvYoXo+3p6G3qEwgFPt/dYzw==
X-Received: by 2002:a05:6000:4387:b0:429:b1e4:1f74 with SMTP id ffacd0b85a97d-429bd683753mr1506395f8f.20.1761877933879;
        Thu, 30 Oct 2025 19:32:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13f192fsm735011f8f.38.2025.10.30.19.32.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 19:32:13 -0700 (PDT)
Date: Fri, 31 Oct 2025 02:32:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/huge_memory: add split_huge_page_to_order()
Message-ID: <20251031023212.mghlthnfscnxkfhj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030014020.475659-2-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Stat-Signature: 68xegf6od86w8yq51pmq4ibqt1ry731a
X-Rspam-User: 
X-Rspamd-Queue-Id: 8415C1A0009
X-HE-Tag: 1761877935-457278
X-HE-Meta: U2FsdGVkX1+rBOGJyrDGgInJQkOL3fYLV4hpTJTtoDfwgv4WdH902kzsiKaanOa1Cpjmgs1CINFxvbZcisUQAsofpeyDod5aIk4tZQ8a/RDfrN+b0o64PJCWYkvudnmmWynbAzwdI05MRznmd6KPeWrcXDS8jhmUKzmzl5b0yDTb77x27wUlheu8YQy7KaSyTUs09PRulLvExXz/hHwqXK0Sw748lzuuAB6J7aKVri4dJPFbyjJOTiek4XenmpGirJRii4inW86yz23gJcLjf8YF1sSMxsd/SKwUTShvrYB9TSdl8/gF+TjAFc7EaimEubFCsqNhz7AjBYEdn1JAG8+bJLaMogdxZtGYdU7aAr92cNlop5WzUdC0e4DAxjE7iHCe1+Q9LAN8SOyD5VEnVPh7nHRo6ZthCxv3qZsAKYqcamX71WT+L8ecR4Z8tNf2t4pwJijq2CP5CC75uLitvfaH0tQD4+wwv44mGTgVcxhb9Uhnsyl2oa4ehHCyWP2HuxKqptfxQDIoaHRIjqzJyidTfjLUqVLOED5EI+XjNTo43AY0PShXCtcYAEBjwvnOFxDiEVUNYOoLOQDo20ZuJRnWE5XDXChNJILI/NzhhHQvStnKqwoWpH3QNuiXoC7pg6L+RE9RtzVXoxTqJXS6RoHZU9dXicAEQvKrY3mAnyEAcgacVG5GjzlpuUd9h7RPGPnzEAqKwIVbvWa6OyJl5A6+vbnRsA/q2Rhg9doIZHXBEF5OGmHP0/mWt2VGwqrK/co30drIisAu3JFdPQ9E+uyCgAMMDrO7MwLM0Pz0wZnU2E59p5sZIJmIVc1sDsZtD59nzmYFs+YRTJz0KOgefCf8rtwmRphgKEjkS/FsyU/rCcknEOWnIAYFdt6/r/hFntX9sLgxxqTFZXEIGe+dTZdVyhaKN6TQitBf9WiEw6xdaGKMI2/48gcOlGHEqDeCeNXdyMYixMRKktXB9Ch
 AlhpTYVO
 rP9bTUVvAKZ4BM4p+DRobqWrRKukFpQ5/sv+OlEfwVGtLnhsTr6mIojvVI4jiw+EaZGYHz876xj7HEMRkiwDxUhd00MBDm95z9d1meckzP0MNZMgLdMQCbWYDEZuvqv93qy/ZI0CpbSaepMeYOXhfeGROcHZzWWNxy2ZqeEXwTY9p9JDbdae+k74uN97OK+LyFVnZLoHFm7UkKSv0535jpu9Ubp07je78e4HtfdVCRIW8OY4nA0Xu9F3CZj0bebVEAexq0mH977Gq3mHmHjVo9h+yYtq0DApqa5EaJdAGpwBEBG7GWq9ND3BxC0PaK+lDHp2S4YiHoJf5uhMtTPTubIVK/M+ioiCatK3xPcfpucfFpFJqzbaDUFFEt1NjnOpZELXgMn6J449ewJI5jSYF0W+MPFiqnruwD3EqC+WFIoKAU/T9ZN+EM8UU54z0kKkf763FeRYfCsxwSSRvDw1ZyLhV5qM8PLnwfBplWiDQlO7oRQTvLVNV5iBoJW2P9q+AuRylqJZAchaO2Bz11sKD/i+ykF8od8Ew2sJh10tMjjMs0Ve9AtSECfw7kB2MGl97YB/8qt4EqmlI7wO9IXaWAWvva7HJHgLsHsTEn03HrleTIDlW708lW9pxypxRlaW/wlVGzG1zfssDQ4UQzVSP2J4SZx5tpv+XFUKI1zmT5/L6ZqzBugEXuDHDNf95VeRmEL9v7AiTRBjuRdpyNAEnT9hQJfktE8bji3bP7SKMj42SXagh1xzm+SfOjPHwRel5kA8CYux/vx2221UTFswN/dzqk30st5EvG0BfQXXVa/4wrAon6ss4WssTAcNqxuevMv3xzR2sXSNoc8yBEXpkTW0h0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:40:18PM -0400, Zi Yan wrote:
>When caller does not supply a list to split_huge_page_to_list_to_order(),
>use split_huge_page_to_order() instead.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

