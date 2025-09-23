Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312A2CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 04:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C6C8E000B; Tue, 23 Sep 2025 00:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733678E0001; Tue, 23 Sep 2025 00:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648E08E000B; Tue, 23 Sep 2025 00:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6A08E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:28:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDDC211995C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:28:52 +0000 (UTC)
X-FDA: 83919234504.04.8189F14
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 124C6120007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:28:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cRbkEEzR;
	spf=pass (imf29.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758601731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0L8/Mj/CMf/BboL9XZ5gn7LsUamResi9L+Dypyqa7g=;
	b=lDz+S9NKMi8gJ6xWaySdgVMuntgOCryCMVPvp6iuYXV4NXoVz2d9GcSm4rFsP1PFD4eAUx
	fZBbdC9j3jhX3jAuEe1W24rt5Gz+OrRWhF73wANzY1NlmDkD8lCXnb6HkjX3ROPEl4UHxf
	jPcD3xeQUospl1RFu/F/JPIJmnaWlx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cRbkEEzR;
	spf=pass (imf29.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758601731; a=rsa-sha256;
	cv=none;
	b=cxV+TZC7ri8XhJRgKFOXnu/jj1JChM1iK0cH3HplW1bXpM8G+aw+/bC9+882iwyv0uRmHe
	D8q28zubYvuYA39ZLPiej/tZHgz9W1uw4Wd+2gANvUCbu8oeBRDq5C9Q6DjzmpihPIOPy2
	4bH+rkoJ4KPj3EnP9VJSSaRUBj3v5DI=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fce8b75a3so6254039a12.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758601729; x=1759206529; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t0L8/Mj/CMf/BboL9XZ5gn7LsUamResi9L+Dypyqa7g=;
        b=cRbkEEzRoMzMuKrTd33W1bkcJorAxpOtxSvS0m6igA+i4K8JaYDDcYY/Hv4fb5SGH7
         9f0xVgiNlZd24WJzsSFLhP0v4cDiNExrGnkSrohwCCGhfYyAs5k44qSDXcRr/0s657rF
         h8Ke9desCghVCA+JV88HSJABejmVqgdnUhN5SRGVNnsfu98CGTG5IOYFgNVrszrICI9E
         p0GwFpYYs1CBZEq+XBlmdKhfjTOqm7Dzt1Yzu2Gy497wn7m3anL8BZAIGHXwobgaTIXr
         qhbOGThq90wiE5XlDm4eOJQ99j5+9n1fH9/U4E0OCqOz5AvhV3z3npyvYmtM3oUVZvUu
         T9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758601729; x=1759206529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0L8/Mj/CMf/BboL9XZ5gn7LsUamResi9L+Dypyqa7g=;
        b=eovOxw37p9InEVGk148Dsn4uxgJ8RLV0ZPSX/yomAk7KFnIUvoRjdjL8kIko5Tg9jN
         YuIQ8F1mQJ7E8/pt4IVcDRC1fGRmilY+ynVxmzfzNvMal1UuMzHhrrU58huwtmyRvFHK
         Kt0P+1xKAqmeMRZ7UQZ6ykGdN3I1nH3SGSc6MmvQKLq2fOPpZdyZ4FyzwxgjifOxtHpG
         uar5Va0XgVizscHIEyWdtnqBtECUC84D2R243vavm+4PFg1MvTRAhrDISlT2NoOK6SCn
         a0dOjQA0R7NtUFXt6CP9iSTceBRutInhU0LTPtzqsjUmYEGHKng3xQDsxKFHF5aKo/7G
         GElQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1lz/hOeaYVfnxAJdqO5hP5RPlrK3CHx7N6Jbh+u/5OqJ1brITxNMF7uqrsEMH/BNg3177Rh5uQg==@kvack.org
X-Gm-Message-State: AOJu0YxbqCGrFFp/eTNyOx23YL4Zn6yzkyD757C/yEWIm9qmwTvN+lF5
	/6VXlZD9947RHpuJwbJEoLWVFhQ9E5+WpCVYe14achrpM2xx/ngWsxq0qyAHGSipSsUkLe9xzw2
	5nzeAr1v7gto4g3c+ocYq0JoTqm8DOMY=
X-Gm-Gg: ASbGnctTTvM+Wm2mvNwsGw8y9iO8K9O9SdUwvX6mIugx8EYLpqlv+j51SfWs7AitJgM
	lzm5okNfx9VSEAnIo+7QFQtT/uZlFM9Xzh2biIutjrOnqmUkDUW2PRsOh79tfNqSkPlbgqKdXaF
	htCaw71APWg2eNuf2i0G2DPTrw4VYauLKXWKx3bQIAoYxUaTlGtt/bqI9BbelNb0MLSfxvfb422
	X5rnfPKd2D+wFk6TtuC2myzuq2AD4XguCXE5QJd/HWklgGVwpKxfg==
X-Google-Smtp-Source: AGHT+IGI8VvJxjrSqdRzk45M8/kjiV8JUO8fNyOSSFYDwY0MLzTPEqc24EHBbra4TdMiT9VAbUvHKiQhHatek4cxEcY=
X-Received: by 2002:a05:6402:90a:b0:632:9d0f:dc6a with SMTP id
 4fb4d7f45d1cf-634677e7c45mr842619a12.17.1758601729233; Mon, 22 Sep 2025
 21:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250922170357.148588-1-viswanathiyyappan@gmail.com> <aNHBUJxAs-vomIF3@casper.infradead.org>
In-Reply-To: <aNHBUJxAs-vomIF3@casper.infradead.org>
From: viswanath <viswanathiyyappan@gmail.com>
Date: Tue, 23 Sep 2025 09:58:36 +0530
X-Gm-Features: AS18NWBRX3q1A98kbmNFmK2Q0aBW6YNTfnGsD2smO2bt-RtTaenmbYqnzoT0BHs
Message-ID: <CAPrAcgOsYofEUxOB81zaJb0vo994N4diDzYYTaZ-hGEtke+dyQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_* functions
To: Matthew Wilcox <willy@infradead.org>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linux.dev, 
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 124C6120007
X-Stat-Signature: awg9fzhs4fq8e8pxkwkbirttyktutqpx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758601730-382676
X-HE-Meta: U2FsdGVkX1/0GiUU5JJBmtTv1WhNBW3JF0PZGq+Ue7zo/jAlwV0s74M3XnogfM+1+baRtcPiXuUOVCAU6yuEiofsKN1LkRjnKHb36UzpE06Cts30b0Ea7OYckym7tFrVhW+uCOe/Sgzx3lPASHSMHyyCzRAuAbgWhH/6tTncIk8YeGb1qnuSyCR2Yt5YhCIrbBL67ZgqppZtLyYl3pqESQc5JgU4PRfeGBfi4ECjVQhoW+KsENzcBWBB+7rACieUp2H2fytmwDRGW2zNTQNveDFq/XCp+ROctFEZYLDstpJKym1oTzwQ3FeZc16wFjALdbmQJK7E9HQsDCsE2EmvzfhMhw+p8pECqTMdS+wfpINN4AIK+Jh0l6Q/0lm+1qaDHOCP1iD7L+O4ZLIRWR5m2kA1n7SPuwsnmprgUvJ8Fu9HHhpjRISazKbzeytddZVEPUxvksZI14hJpQ8HvxKC3YlugDeaktBN8H4tPGITZwK6AY8d6tyr0z+AUXn+nz4NDcBSzIsKVA8n+zYA4OQx59XXMj0B7yeVJFAGnA5quW0mGopIBXCcBsiFOPTbBpbo4DUjoBIIOP+mbeyh6FkZtGZv62+vpZJCO1bGvjY0SDyq6Kjz7SaQsEkFoFsk7TYpQnqB+4Iv2Vv3w8dD0fW05zsGgxbawgnbDLqgBYhX337VPkbwDRvQCCCs9BMNDUIkDUZ9FfJub7VEbr7gN5pojItFJGiOUi72sR9SSkt5txlTMBEmQ3dDP7ujKRAPXAjHoW+vJKeBoU7LIC24wRuJFWjZSfzjaUiMm1CVUaQvrSdQp7M2eLar6dqiHbwHoOOrq2ZmLJj9dLMdMstneU4MboovstOvUJg6wYsYYRPhC+dcZ4nSO08x2if5b9SjgbBxcAfcBQo08ennzm24CyeDVxbVY7t4rBBhPKIY7INIxtSwwqDzIPemk0btPD3WnOp80Y51So7sYJIf+sFRTDL
 30JrGndg
 19GkthvkcOj1MeiNZ2LPSUce1VyFyeCb2rL2OwDRCtRo1ycnFx1ShB+HAXxH0uPBaq/b+EPI0XVqFuvMoBEotLzN0psyrgPlMfwTfJuDNG4bXM040xYGUuhyC6ZXCi9jjq65tbdNnLrhLrYH9w7IlaEF8gcHqQ6tgkC3zinZxqk4fDe97wWMMoExLk0+g3A8fCkmlKwFEZftmEQ92HnZPH5Fpg4s80WI6XH13hz0GRH7HfB895dkSO93bA0fy7bfdjlYWnkBgjuNtr7XgW08WwbWsFOv7qhUYmM0AEGtiDW2XVA4JYAGodSj7NRtAYoE6uFrgUTICGUR862SO1u0H9sZNsvFURbqdFuzfWnjqlufAtz4yF0SyxTmgyJnjgoudcKrgafZcN+UxZfA58RlANHxg9aBsKGY93XY19u+c0IOTmCpwD3fSFW35XfPBB047GOtWIH/evwz3Ahh9tmgUep7vdvvxRmg6fZ8Sx+Et2VZ4xVVA9kNVDIK6sOrVYKYMjVpSGUTGrNZq1bP1JECJZ/H8Gm6Xiemp/ZsuuIQ3OQrQO8AkmeA/gRjoDYUMbwzqmzAQ+EzvmTE9Ock=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sept 2025 at 03:06, Matthew Wilcox <willy@infradead.org> wrote:
> Is it really a good idea to support 2^28 vclocks?  Surely there's a
> limit that makes sense to the PTP driver.

I think I will add a new macro for the limit and validate against that

Thanks
Viswanath

