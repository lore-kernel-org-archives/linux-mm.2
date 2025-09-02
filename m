Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3488CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 05:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3138E0002; Tue,  2 Sep 2025 01:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA758E0001; Tue,  2 Sep 2025 01:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A078E0002; Tue,  2 Sep 2025 01:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE7778E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:40:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACE79160AB3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:40:32 +0000 (UTC)
X-FDA: 83843210304.13.916BD33
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id EF8D6160010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:40:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MpPycDDC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756791631; a=rsa-sha256;
	cv=none;
	b=gL8RIahrLFIiw0pB6XkSGLbNIE3Bwv6M4pfZDH7jJuQcQTanZLgnE8WqsL0R/5+mrYfGP8
	7Ify6HBvhEGV3bFNNNAvznDq8+CWXCgErbzhejyAzq8vTvzoD/lIcEXSCiA91oHZirwv+K
	5sg+J6RkZR9KdMHInCKGgsHSmAnCAqg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MpPycDDC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756791631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cMIMYJQfFGiekE60FGRLjgl1mruUZ9xHSw0rex8Y04=;
	b=X8Iy1DCJu+E0Ep09KELez3WL0Fe/R8d8nz39/MG8B0s4VC7wxIgE9Pz6D/KfJPcKi/mHz7
	bSm5ImzPpD3ImUtlWAmPxRaAfcQ0E/xru2diMW0uOhkcICyRUnt2dzxqK9ePyUiP9HR3gZ
	Ada6u6y/b+VoF85iv2d+Q1BqNYpo9VI=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b2f0660a7bso46578511cf.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 22:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756791630; x=1757396430; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7cMIMYJQfFGiekE60FGRLjgl1mruUZ9xHSw0rex8Y04=;
        b=MpPycDDCPEyvtwC3/CqfTSJDY1XtNSmiaRbV+675EArj838+6JxrNbdjBcAAeBjLwB
         NBY2ZYsgBxMzv84oWI5WzUinTWl2JLO6gYkBCkoOe7Ft+lJYfsMrn7iYhM67eMVCXGN4
         6JAFZo7R/Mvmpg2F246iC6uJJPO9j8b5mUKgkRnx6CtDZ3gEXfA0xyyD7nePcqc1kSpy
         RpDn1A4XwVDB3LE1L8RyWXK/BsXC3lcqQ5vZzO9E5Vv9unnIRJqOjlxMg+PLA1DbEaWy
         qbtUW4Kx3utvVyqVpSo1nduIZ7likfBNa0zd8wNF2MAjCE7IjOahwGy48Lxn5s3bay6v
         c4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756791630; x=1757396430;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7cMIMYJQfFGiekE60FGRLjgl1mruUZ9xHSw0rex8Y04=;
        b=W7iV68hgbie5ApqI1mShwkwnLwTxKzj0i2R9pwBfWH4UlCuU5s9WxbnAKuWEMFs92L
         ho5QYbXaMNOV5I0/dufDkLfOFdjR7KovLgE21ZbLLSe31KmAOJ8HBoblGezBF/CAHuf4
         OQehjFKcp4lTC1h41TZn3qywTXj86Gkv7I3eT991+NRtay30RqpkXMl7gQuLtWnhl08e
         drsAMCtyc4ylqDfUKdCa/LyTwhvpRjaxJYWTYCUNEky+076GrreycKf4mDTqm+7kaZqt
         NNJSbObNT3BkbgB5ljBaX1Ct54Bbx7IoG4MhMVzJvnLnkI2fHxNSNv0bKvbaFubHiVG+
         mlgg==
X-Gm-Message-State: AOJu0Ywwx6Y+A4ElVG6eXX3aI95Y4TByUtA22sSr2o/g4dmaoa0FYqQG
	A5pls42WSeIkMsp0pRfUczArLSstr/mu7CSZgdAA0j/4vN67Q5LmtsfcevVtR3Xz6+JGrUiX2X5
	cuK/QST06Kz7oSbtW8AcLXdIOvFhJj2c=
X-Gm-Gg: ASbGnctkH89/r4wNCM0mnoAI2jNEbzgs6bEQyDGCa/juwpNP768If33cLfPVXb5jlOw
	GmWQGBlxV0ygIjNu47En5e1jRYTTa1+uCPnaRp/tIpDzzF+ILEdHXu8SBfMqN49Ipjy/4eDc4vU
	JafCuxoZHmDgiiGmO210n27r4hWkfkgtbv5UYEUf3oYwfcF6j8Vm8SE6ToWmfDjBxVGOSNxK4kh
	T25zEPGTfiBsrmQ6Q==
X-Google-Smtp-Source: AGHT+IHuM1h51UhnlA/yxdASgBhPyYJPIAYIMlQ610qlfw2XDY3Jn8anY5Kxkxf21TbaAbOqt3gpgmcGZLfm0zhJ2z0=
X-Received: by 2002:a05:622a:298e:b0:4b2:9461:58a7 with SMTP id
 d75a77b69052e-4b31d89da64mr112097321cf.4.1756791630032; Mon, 01 Sep 2025
 22:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-3-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 13:40:19 +0800
X-Gm-Features: Ac12FXx7uTtHy0cUMFCpITeASjSt1GLFJr9Uq8Fm7KxX6iJV8A0j1aBTmHg3o7s
Message-ID: <CAGsJ_4yMdzUOU6UZ+Ueo__wxHS3WPJoh6u3Lqo7iU05qBHc1fQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EF8D6160010
X-Stat-Signature: 751zu48g7xgcqyd53uhzjqa59hhc86j6
X-HE-Tag: 1756791630-816854
X-HE-Meta: U2FsdGVkX1+dwJ7VGlaqmUQIg2ZKkd9DDHsa5jjnnkbJDOytJ20cxLv6RP1UQeMbzUwccz/kSJ9ge+dR1Ra/XZncZYBolD/5xMRSfTFKs6xgp9Mo1N9hWgFrvrp33kXoY0jzfStgsbdvSVgSfeu86NefBo/XECGHqCoudVn/xT5IXFR6fq9CwVXtyIgFKeWvpOVO4cZ9i5Qp3V/li7ChVJqkmNPRGb6YzMRUY87AOXfnyJh3lu99al4bbtCZptzeQYLo5KYBWpJf1DmgGTMOWIOXhFNTlWbAezw/StXiWvyQSFw+WkXUlf1+dcznTv52B0pNEf3n8YxBxlL7fBkJ0TKKg6QEEh4iBoBtohwxkk8reMQyHOgcH1QdmoN3sWlmcxfEcpGpdtPpZY00GZA4bNFxWiog7ENGlhqFxtHwPumisPhnYfYgwUz+R536DkIuhtupc+OkMHUxf7O919cm/aFDeilICinx/9kRLlROldOZacjDtxjDpDNXp1D6L3cBrDesnu9frCXGqg5JUX3jmuFFgmiIGGz9tXqOJmV15e/N59P1AH679+ytTbOkIJlzUro80M0e8KyGvQavu4CyNRajhb75LrJcM+NCrWsg7IM32SKqz4JfFnEDyfyaTiQ14rFvkSfRh05GoTlDWy5LckWwX0ybm6CL74MvHuSS2kBuWqDbtVI2NelEZLh8CAdNba7WoiXAJJWAGK2e6DB4oM2Tx0XD9SH1GQ9at8xlRN3WuZe2CUAsug2u8vGLRpgc1daQtIC/l4XfNNalD/Ks/kbWTZd24daWUeKAYb051hfuAsCRQXOI26EdohgKFOX+UPiiqwce8zqyG2Pn3U13cBCjI2587yXWKw3Vtv3IYidd8OAbIh4dTU5CZTFNCbOw4OXhaKU3AbcA72vjXZq65LubGV/jxGTsLKDi0NHCO///x+6I5tZw9bc2qBjECDocT7zsrIkbICD5m3WWHTl
 KoDOTtnk
 /l1H7lOeeNvv4Uy7xXJ+XAeeTX5kJvZKyP2laUp8NyyzyRNc4AjAkN1sdSEeGUzwcaLGB6t0ENEeOLw9PN0+SWlwr3P6EFHPGAhFvxYSh+a6Huhn9hseOZ2DheJ3IfkkotPsie1VCBhTRYLpOtp+lAL94JbQA3wgfEaldALv6M2nlPjnm1g5CqMmJRu5pocCu8jvMecPPDL6+iQIdzISxRNOX3Bj5hb1Qb3YwRo5nh1QXE8TUI8EcVqIsxwf3f+WlI4aFwTYfUMd12aysE3RpnUpGTLo2lVWbqDEsuzJj84b91AXUyXk+kiA/o3wIFNL3pBOxZ9utsWd1g64av8yfJgO425OhW3OMRG4z6VF9BtjXuuYJQ3EUvt4kXanmqNkupL2U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/**
> + * folio_contains_swap - Does this folio contain this swap entry?
> + * @folio: The folio.
> + * @entry: The swap entry to check against.
> + *
> + * Swap version of folio_contains()
> + *
> + * Context: The caller should have the folio locked to ensure
> + * nothing will move it out of the swap cache.
> + * Return: true or false.
> + */
> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t entry)
> +{
> +       pgoff_t offset = swp_offset(entry);
> +
> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));

VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);    ?

Thanks
Barry

