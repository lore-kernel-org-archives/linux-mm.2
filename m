Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD4DCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 02:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC9A8E0013; Mon, 22 Sep 2025 22:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BD48E0001; Mon, 22 Sep 2025 22:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C646D8E0013; Mon, 22 Sep 2025 22:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B11F88E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:29:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E67DB7711
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:29:05 +0000 (UTC)
X-FDA: 83918932650.08.24E39BA
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F71A1C0007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:29:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KUFyg44D;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758594543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBqHLoQEf/Npt09p7CWAiUjG43kXXR8Q43uV99bdbew=;
	b=58gPFk9cmAfug7PS7nG9j+9zKio9/AYExN/dObEwox1ja9Y+4eiwyi4m/KT5VjpuAwZI4g
	DBk/jvmFMkM81piVqSersJXOSrz5JmBgc0dlUwW92YJ20wktJ6FCM4OreeNfq2/mQ6DiX+
	cLnET7wBBc+9A1TIMeO3uv3avomvz7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758594543; a=rsa-sha256;
	cv=none;
	b=x1ICLAvuhDVuIHOuyKP6OIZxFVA9Ow2XAWXN/6OzXIwflmasus+wlIf7S88XbjDDND0hE2
	LaCmtWGu9rS4PSEJ87iZKFiDhMpGHv34H2BbkgCDztKA2xj6nBKZq6PMPwtv6yND5kPKrk
	IWjROCCEYhV+n09NY3dU8Pc5gkJZamk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KUFyg44D;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b04ba58a84fso865552166b.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758594542; x=1759199342; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBqHLoQEf/Npt09p7CWAiUjG43kXXR8Q43uV99bdbew=;
        b=KUFyg44DuresOJaEimBR3lEn4+78p15ki8Q4iotE2tl4jNruGx205PL9sNPhvfAY31
         hU12GvJ/yIsZFiimBnvQffRfLB7Q7T9RjjCzdUXjEoPLHtX+A/USTW7HMCzSBjPzyKbI
         u+BqqTDr/erJAL9ipJXeGZo3or93wrLGchDB+hBKsfDN0NLVSjBh5hdVVJ+zK7qx0/Zs
         x97aFmNFRocm55AuP+cKw3LSIgo/ssZZgPF1gzZOVl9ACVG+beww9BaV9sicmWSIa3Lg
         iZ/a9N5wOCZuuT0hK7LJM3nnfLsIV9vXqIk2Tsm7rgXcA5vgnsCxfXYvEihfpGp7gpJi
         W3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758594542; x=1759199342;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UBqHLoQEf/Npt09p7CWAiUjG43kXXR8Q43uV99bdbew=;
        b=qkmzRtZ0eMMZsuEg7Q6MWv1v2vKIXcQVMEvu8uGLmS/YLtBCp9bODKKN9zgiq6V6mD
         AM1WqbW8r9x1czy81PSJIeW0Z9WLH9Bs38CtDDTuo+qi89jGJn+jgDI1cj9387Ovw5zN
         nEcrSpWo0qeJ4Fnogw+a1IWlAZu5bJUKO3c2LKkf//SMdD0f+vbzpuFzKF3T/cfAwxgR
         prOY1UxHLK6+qu0BYU3+BKh2wWG8Txhzbspq8OnzWzPOJYy/BmblE7UN1hxqQqzVED+0
         P2ZYvZTS2f24C/bMmkOWFi8Erc+5JFmLdW8NGCxnTcQfTKPbPCwJBUHkTzbVMudmze2C
         5UAA==
X-Forwarded-Encrypted: i=1; AJvYcCVpyPcJsj68B/I0e4INkrX0BcuQrbUi88zqEmKP0RHvJv8wKe1xiTN9SojwzBtPmG2e9GJihZuZ1Q==@kvack.org
X-Gm-Message-State: AOJu0YzK3wrd+lzhKJKArYaL2Bg7ZJQCRKk3QROR7vdXbj/I7JAdn2bZ
	U3j6zmh3C2L4vln7F2vN2O8xC8t+xE7Js5baj7p7FfRy20EF6X+uleui
X-Gm-Gg: ASbGncvbuq1uJOQEDKMcJQVudsVmkAUuoe7NltLZOxwrQXXMaJ/J5SZHhD36njKZ9GY
	k4a9Hu5/7jVNl+T+4Xh5D7X7xK5377xbQiLxaeQeYlomv6W6Ec7bif9+ePk13WgT4G7E8GTp03B
	KxHbWFhrbg84IgUcY72CkZNr8CVda9FxUQaHut5LrlcfbDLzYUJdR0pm+OOtojsp6sY6PFRcsoa
	7yzTm/GJUl+T27H+m03LdIt5ILXE0XGWLEDx6eku0uQCeXQqPZohI1AooFb4O8gmCCDBbvcXzuV
	9ay+jbk9GycjhW3+JTC7jTXrSwHMehBRWyujSMCaLXFvj8xegd5CxBBNCaI1l0ccpufLITS8lfG
	/Yscm0fuPPCjHcX8h7MCMewbA9dIbcMCP
X-Google-Smtp-Source: AGHT+IEIHMVCIffPBe/9Z5NBuOjCfg4C5FU/n65GHAiYlD0hvBLo36yOCIQ6ZXcmw0EH50gdL1sw8A==
X-Received: by 2002:a17:907:6d16:b0:b0c:fdb7:4df2 with SMTP id a640c23a62f3a-b302705e540mr73287066b.21.1758594541891;
        Mon, 22 Sep 2025 19:29:01 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b29e6597caesm580894566b.73.2025.09.22.19.29.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 19:29:01 -0700 (PDT)
Date: Tue, 23 Sep 2025 02:29:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
	kirill@shutemov.name, hughd@google.com, mpenttil@redhat.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH mm-new v2 1/2] mm: make is_guard_pte_marker() available
 for hugepage collapse
Message-ID: <20250923022901.mzjqkrkdrwn2r7n2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918050431.36855-2-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 7F71A1C0007
X-Stat-Signature: bt6mzna797zbjtr4p7wi5a9buc5wmuq3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758594543-572036
X-HE-Meta: U2FsdGVkX1+UeeCoHE+KojFECjGhLZEvIBCHufaqmVs6EENYrUotJUFqTQp2DVlOjGUijTd6W8HuZ7PeCRbvl5NmbEY926WTav6dPz6USnrYBAkmn1mev3n9Hg530AZcUGXycfcVZvAXu/jiKluq6vVzuMIYjx0OFdmFxjxZ3X+3ZH08HViYAMdhTwwITx40JCA2mxfXUI8nHZZyV7Q/ELP+lUqzyha0vqMv+0+5xtrAy/pmx60dZIvsGh57Imh8kyfFU01xoft2NWvN+kaq59nDErEsefMjueg5jHt4ZqMH7+SNCiWO6eujN0Ah9niomQYIqFWXZBCM+AHw2R+Z+kXALH8OaLCFcyMUeba/QxT2Dj2ScsHQPiIZqHH+SMAcPBVL2bevwV4dB9uX3uWbldhFlL/y7bL60DHJW/Mk4F2RAr1JGyKZpEHd5+TBgO9RinBQAUOV8lrPDrlryQ90RcZqrsjSh42tWsr3AhdiRDn9lhgS3SU1S1PUYNuEMNluGAXi1f4IfsaLUXX8g/a+MiEv89EoJO3iwwyqFPtHlJwuK+8JUD4JPTkxf5mtvVZZuro+q04gZt5CzSoAfdNHiM96xh9pHd9etSctDbP3abvrnt90iAeaE9z6h/DwRgSlOa4gHyQ6ZMDM3Zn03XBq/kVjOHBAmGxYCwsPk0Pe63oSI7XgIaMLkdhDnnYh7d3GEs18lkcD5A1ZbIrKhmR2d3GGH4Zhvu9alAzvtCNGhVx1vSeFKB+NUeTQxqrUT9QHBgJnEdzsF+z037DQyX+DyBAvdXc/KTUUX8Zo0Koh/QtgD8TKgl1QWKywj0abwRM4zaHpRGEs+Aza/HU58K5j8gIXD6dBMOATiNhNIjFfNp/H9OvzdCfU+31O7FzvaH2I8kQ9DQqsPsSUCrSfppJYtaPzdTsAUnmcE5gXwzu6wqfZBxvlC1esTmcT5JyISrcBbBWaqe5DAzl2NY/1M+c
 mBA2ICkw
 NgrGujaFukjeYaF5jBGxecLB1oOiwv6vquSv0G5/tG1d7fkNJi3NZSpypkL5d/E20qiUjnPJTO7IJsPhYMHZmVDn9hCO0Y7nqX7l7FH0nMCYCXYtVVTqf06WSH9qnLVAiaGb4CBPLqnLrWOK8GGg4tPP5+NQOBOM1KmqhwOQQDTR5KlOYYTDNgjdf6UgjIg1pXek+YjX5CIFIvaODF2QzTmViTYpIJkvpiVL1pWv9IZGbtX1s9R6d+SZGn4unywLzUL0hf7j+0/dU3jnKbernvjoQQqb3jJ5PP2TpTyf5jaesDvDxJ/dNzPbfApR8TCjlXRqw2Sj5pZhARAQbsdnQsIZKLrJOMqmwyXTDj++AyiF3zIG4fdcMNUuuPGJN3zIWG2l0EmEYAZ1HjhUGsKpLuOHEaheOWnjSSGoZr8GNx/uBqEbw47zC/HcLeNTQAzHWPK2bVnkHmETwYgTKDbByV5PYZfk7gGPipBSvWeWYquvoqLLyeRslz38UC6cZi82UxcL4NnqeAnhPqyw6CZRU6vZK59YG5u1/0rqyJZimErMX5nJ7PM4v9WoFpreXxDHIJi/L1QurZHV0X8WxoRb7e5do5i9qh8O3DCl3/1P8utR9W5jUJpWekPmDqcWV3FLuVTOc/e+9h+Ak6ywMyR1ubcFimjkP1WeX9JR+BGvUh3a2HB3xw2W2cgfyk8jYyyRwMZUhV8kZRP3Jn31TdpK0HcDVZQw6DWku25yGNAVx5P4OFY2OICazOqPk+pQqFQFR1TS4cDf2WKxbwLKT5fXaXHKT5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 01:04:30PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>The hugepage collapsing code needs is_guard_pte_marker() to correctly
>handle PTE guard markers. Move the helper to a shared header and expose
>it.
>
>While at it, simplify the implementation. The current code is redundant
>as it effectively expands to:
>
>  is_swap_pte(pte) &&
>  is_pte_marker_entry(...) && // from is_pte_marker()
>  is_pte_marker_entry(...)    // from is_guard_swp_entry()
>
>While a modern compiler could likely optimize this away, let's have clean
>code and not rely on it.
>
>Cc: Kairui Song <kasong@tencent.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

