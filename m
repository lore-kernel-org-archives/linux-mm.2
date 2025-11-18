Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F92CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9A38E000D; Mon, 17 Nov 2025 21:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880868E0002; Mon, 17 Nov 2025 21:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FBF8E000D; Mon, 17 Nov 2025 21:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 636058E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:14:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FD05C032D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:14:53 +0000 (UTC)
X-FDA: 84122109666.23.C825BEB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3046180017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:14:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kp++oQ5C;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763432091; a=rsa-sha256;
	cv=none;
	b=zEYYVc48J41iMEIJdw/m7GpsZuXwEPVjRw6j9IRQMDghjNza14W4yZPsFM95vCeLqLE/oo
	bHcNLAFreLF1GLvylqbs7mXgOSvzNjtewtU0ifGsQtSetR9bugbR5cjiML0YJPVv4GeWyo
	s+A+9eDPEzUH7JAVgECf2j/VHqkeHlg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kp++oQ5C;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763432091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sQZXbj1YdX31C03O4RWI6hvbK1qocJ5NOHys4I9+yw=;
	b=Nm4BfvCwD3ChWkrTNw5IeCKSFaQhkASatYGaZmBufcX6IGWQ5LoEmR1WlgghSpZUMAd6lX
	ILw9lcFVkHql8FlREYQjCQYeBKpZglP+Uu/KYOC+wFMkiSFn5TXnSOxTmy+WUmdnDxxCAD
	tM1wk0pi532b3xDE/zZdq/3WnFAP/24=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so4842993b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763432090; x=1764036890; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6sQZXbj1YdX31C03O4RWI6hvbK1qocJ5NOHys4I9+yw=;
        b=kp++oQ5COX0S7PB1ukWnFAeUqxYA5K+DxgNjQdfHSys0G6nam9yYoMeerQr5PI5CPw
         AWctGsnTaYbj0fSWiZ2UkI17vqaKoMouPuz6C9X5y3R30Kpb22yhtt1vwfrnnrDjwpZA
         EjP1kI5bBjHuphRM8PAYizCl43yez4TI3ZmPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432090; x=1764036890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6sQZXbj1YdX31C03O4RWI6hvbK1qocJ5NOHys4I9+yw=;
        b=ZpOBh+pnWvi66mnm+pIZBiGphD0SarQBnskhX4i4gbUzHqBYm6l/I0zoiicDI1/gbf
         Gbp/qrGLbZ9+kCRwQiWQHiiIjZxUR/XchXUfMFKu5rpowK6iGyHBUyJ3CHTDyv/GLGBE
         ND/ONFf7YNrqQAyaQOLlFCt5bnjlNtyE5WXcn/L2qGJUCTliwhaqcXyOLvAHYSHNnV0R
         3f8I98y1lz9sL49GhODjUw576qKmbZbwtpWeCdaNYomW9lUWILsu/Y3+xh4vl3+lhDtu
         xdY3ph1M5YDkHHLjTvuF6yB+5VjFM9nWn1zpd1GZu4Am8Pk/11RncQQyUjzleNSplsw2
         Y7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjzrl8OJz6TH5uSwbNLdqPJhqhJiIfHF7/uyTYCZZMllNH6HpjVKIqBc1o44PFjkC3zxZZ9J5/fw==@kvack.org
X-Gm-Message-State: AOJu0YwlVjR4hPirbLUeHENr9D58WbHDlWiJ/jz1NdjKDgzHL+sdJgW9
	WoQ41N4Y7fcRaOk3YPFuzN/yCgvttBkbWK/a9CkFn/ncp2gc05on2G3Me/hVlTJx5A==
X-Gm-Gg: ASbGnct5zL85AvOdvLP7yOZEFoHQ9KwZyci5SyqIMKryYjnyMmvRtSbgMePp3PFFLMK
	rd1NAqbslcmnkSOD+GHLXv1YSYqVYbyoeKH18C7FXaU/OImyEv2GSpWNQy4z6KpMcXsEqFuBzQT
	xSAmuT7F6oV3y76q4hgaubQba2IlVisWavVrouTWFiczMXGuEQyc1TklY1H5qodHKZqfbtr+uCZ
	DTqAUJtKi37nXrnoWKsoxAucABqHupJSKuPMA5tUf5/HHnDT8raSAYz5XOnzlE4GQkwR2hvg32E
	YdsZoqgXa932T9Z3O6BU8rZRcOBAoYHktEznA4bL1frtKdBWQGB4uSOfhqeryvpl0+7qU55Ovkw
	+da+vNVV+o2A+Iq6I7q8xLtFH0tgW4n3URFvoCtDPT7bIwg1Kz6SkiXMoab45/8hYP88GgQAapa
	h5WKjuwGPYiXBJbTaOTGhNvHBMMg==
X-Google-Smtp-Source: AGHT+IFnhFnm/WfC6A+BHWhwAiIZ6Bgw+D4M+jdgTMpC0ZuxdGNC3uhzeJpEWoMZ+hyyVF9I1M6Tvg==
X-Received: by 2002:a05:6a20:258b:b0:35e:c55b:9203 with SMTP id adf61e73a8af0-35ec55ba46bmr7643528637.33.1763432089994;
        Mon, 17 Nov 2025 18:14:49 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:54de:ef1f:fc04:3ba4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aea0f8sm14739557b3a.5.2025.11.17.18.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:14:49 -0800 (PST)
Date: Tue, 18 Nov 2025 11:14:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: bgeffon@google.com, akpm@linux-foundation.org, licayy@outlook.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	minchan@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Message-ID: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
References: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
 <tencent_547137D7C2F3EDBCD52FB12EE2A202EEE307@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_547137D7C2F3EDBCD52FB12EE2A202EEE307@qq.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3046180017
X-Stat-Signature: tzebpdyesywzsmc4751inaym88p4i4w8
X-Rspam-User: 
X-HE-Tag: 1763432090-503174
X-HE-Meta: U2FsdGVkX1/lF+myr4NmAPD0qz04feCS28WoSZtWYswH4unv69MNmvFdOdDfpqmXmZneL8uPHOa1WxAWlltiRhKjIELGw3UhedPwmTu4vOgOxKM8E9vPSBGfW8MLlSFFyiejqCnv9Y4UCJLMYnjpnwpqBfOyi79iSnyMqFJxYgaiv+KEv5LL+jh5eM9LykYaHB7RCr18UuAZN8vovxwqeOhSHPrDJUKLhVl9E2lvTFBL56IjQAeH7WUUxo+EXdkOJ67COfVEbkZYkxe0TgrMThL9/epLl8ocs/pO4wBvYigxmFdbfqPukgOO6GskfOAAlH3sc23/ECFoEY26LZYI2fJPXK2qwzygVyb6fWscfSXFwmjOgL+i40+aVICP4eDZqB9rbTAEXlduvktN4Hi64x5k0mHccHuKOlD5N/8wdFagUkKkKfL5Z1LjD0ekG+lbVYaFJQywX9Oh3NIlH3eYoR32ZqYQgSomevMBUr9AI/ZIizDz+FoZYeCaIUN6EXHQ3hSD+F07sXYEZtKNaMkiTFa7AmzcPFn2Hm/626XRPWFDFQ04lJIaA9fKtsWqu1O11v77aZVLTO6xOaXb5Nm8xAWqcxbDpTcp33IAGnFFVwKpdjfzA+oMGn4pGufSJP5Rqydg774VzN1RFMYOMWHj5dlHO6K428rKcugJUvSffbs3UfBJiST5SDyv9n/ij0o7PneRIIsvW+InSXMEbNn24BClfIZ/sSk1i8/Syl6e3kJanJky2DW/Tgi9kRG9tf4oILYj82uCkHxBSxx11QCEZ8YW6YZdj5Ki1kJk0brH1UyUlGrCjcIiwTZeeNCMuwGgYRrTEZdNtkme0UP5GkvLErXNHYvHuwxbFSHJQarVxGIjoTVMhoWjcCxc+jPN6aueaDYpGs+1iNcv8qlp3kzJnaIrPKXEGJxCuJPD10xDRYz9GusqjDGVDCKk8kcUEWa0d6p77KctTwY3Xv/FnD2
 1J54Du01
 ge9FZGhTMg8qUapyRa6f/awYM8LB6FA69Ycd8iaelcDyqh/C2+NAgxzzW0ogjTiqorMNqezWvGHv0v956pOSgbqS9FNsaNJBQAEucgHvetJkXu2F/Me5movUVskQgF1aJgApuzNRNblkZGEBbwrvy3JqS3n3YvwI56aTI1iLWe8+aiRu3RVg3tLWe8ZwlBQZqt/4NGxV0FAJ8P1o+vrpdOXu26Pvi5O6dLqY4MmzmfxX2G80AiWWYGy+pKMg64SUfRWR/x/6rRV9D4JgvTblAtPM7cyF8l4qeXES78LpAhhQ3WQPkyfIKGViNobjE0BYCJnGH7OhzihJCHjmRt8q34Wpx814XHt5KkLtFQG6pYeQ97/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/18 10:08), Yuwen Chen wrote:
> On Mon, 17 Nov 2025 10:19:22 -0500, Sergey Senozhatsky wrote:
> - index = pps->index;
>   zram_slot_lock(zram, index);

D'oh, indeed. Thanks for spotting this.

