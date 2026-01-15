Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC6F2D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEE46B00ED; Thu, 15 Jan 2026 15:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572586B00F3; Thu, 15 Jan 2026 15:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474536B00F6; Thu, 15 Jan 2026 15:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3617E6B00ED
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:11:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D49BB58E52
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:11:13 +0000 (UTC)
X-FDA: 84335292426.20.EC52968
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1650AC0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:11:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoccVYjW;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DJvmUAxFA7f3CQLgPdeGUDeqhnxQ4o2avS319E39OU=;
	b=P1Hb5Fc5mg3o60MhzFy4OFP2nZpjA2cTqS8vnjQdbphqvPMy3E/MG3vlxYuypsnNZmCGk/
	m1Ypm/FORNSraKHzXCTwwPQNwW9ZRwpOUFci3IvKaVhfvlW+jtD2dyP5uyCuItx+ZGWSlr
	ZTZK1E/Oh81AmLyvcMjLAtNadVvVvfg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoccVYjW;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507872; a=rsa-sha256;
	cv=none;
	b=RKnO8bWQxvy3buj8G634tSdUYOodKQOtstqFOlgic+Ha/oybXa5RB+ClsgMCGMQ2XabwE4
	6PvXkBgW/n+6nlnvx48mflJFvu2wyk6+3MiTeK5pqJk/rXMLloQeY/xe5xPV7oQofhbNOR
	YRE+oBoz63Fb6GQP7MAK3rLONhxXmS0=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7927261a3acso13925447b3.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768507871; x=1769112671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DJvmUAxFA7f3CQLgPdeGUDeqhnxQ4o2avS319E39OU=;
        b=OoccVYjWkYAiXbxJO8YJg2hpzMyNzzvesp2ZY7yy4HpBIj1xIUhRzMqXR03cd6cquz
         uxUKlx1UWkMtm6lx2+fHIxoZdyYLzVqZ5rGjf0dUKE/JN3NGFCJUyymNrW5gqT7eulCL
         w2vgWuUVMKya6/9O/KyIbgQGAdL82EMd8648N5D2DKAAEGVnd/oOKjz3uj2Kmz8Blsv+
         HH0JD5vIDUYJwMNu2FnznY/zRWY/eOV+VcfsLOt8Hq/NwaAiEqY85qo59DAyKz+NiYk9
         wWdGYWOih/rgaLyXHGDgaULhEmQ8dZ8m6GqeRrhD2/1tIDr6IDApAcdpjEK9waQ8s1z8
         U2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507871; x=1769112671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+DJvmUAxFA7f3CQLgPdeGUDeqhnxQ4o2avS319E39OU=;
        b=UObE7aPNwYlVWVO+XoAo2qchY0n8k+hszMlMb3pXpjPL8zM1w7N3wo9JajldQEfS+k
         GGgr+6y5j7T3+Oz3KhlYXyvfr+c3mpZeflyHIkL6YMNmfK7PzPwhyrRPmcNxVJCQFQUt
         HLrlSupIf9icVkFhYX1XxrSgXjvS/N+SFFBL9XmNGLnnlWqJKOmm5u/2aYQNh+oc7gCe
         yLNEmKbp9Zoh+BWRAgcuGoeA9JWoJR2UHSLbeAHR5Q4ionV9Hijw0Taw+odsFwc7mRa4
         zq7wp70aWosNm0C2OEGn/IPpQaH20JzI9/qtYF/bdSOhqBfWoyr5VB/dEzaWs9bmEJKK
         9WcA==
X-Forwarded-Encrypted: i=1; AJvYcCVi6AbKUn4kmN/DESem7qL4+nV1dElyrYO+0qHdVVCxeqDm+oLrT/KjxYQzJ5gQKJg4AMASoRQwbg==@kvack.org
X-Gm-Message-State: AOJu0YzkcsRXZ4+UWI5fc7nWhEHDqBW6zoL0kTlpW4elUtxtVVqapZ6o
	WtxltUnuFh0MixQI4ux8PO7GVD0g40uu8fIM/E5Mgh7nH1PQyqY5MN/b
X-Gm-Gg: AY/fxX5pcz/5gA5bnHAP+kD/Jw0eGutp/O/MAEt75bLQ4WYYcKbn8MyzPJE/QlQVTkt
	EnogzgNQKW6/WWbyEfRx+zxA4IgQl11miNdF8vkcmcUlsd0RQHsevEU1tYOrrSOzvvbqlULXZaG
	lZO/cFywH2LayTEQPjBkaCxhEd/hFJz+rmJT0SZL6xfmW8pG7YlYdIWMvKpd+X9Bba0dCwg/w2q
	VpWZaCumL3D6ZnyDpDPPLKhA9fPWvoiYFO7je3o4rhq7iUelZTbNClp/Iq0PEAuMzIkvKoquoyw
	SjZqNQmdYRKONWwSBNeRdu6rPW35V9x6cSEk3ky/M/omPGeSfmfdiT6jQ1NaHB5UvBi4yN+a9Gd
	sNPHq8GwB95o/Sv3boz16/aW97R3gFSWfm9xR8Rs+WtBNwg20JgVgKsZNGF5fyKiwcrGAc1lTnF
	1+kArPKCUMKg==
X-Received: by 2002:a05:690e:d46:b0:63f:ad6d:cbd5 with SMTP id 956f58d0204a3-64917750a39mr255389d50.60.1768507871038;
        Thu, 15 Jan 2026 12:11:11 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:47::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66f6f97sm1285097b3.16.2026.01.15.12.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 12:11:10 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Manish Kumar <manish1588@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prefer 'unsigned int' over bare 'unsigned' in page_alloc.c
Date: Thu, 15 Jan 2026 15:11:07 -0500
Message-ID: <20260115201108.1028113-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115200753.1002036-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1650AC0003
X-Stat-Signature: 9f6mnwjkega1w7otbiyw6xmm6s9954u7
X-HE-Tag: 1768507871-801910
X-HE-Meta: U2FsdGVkX19ft1nsZ3NmcvxX2qMBrX7jkbMIl3oAH3ojQtdyS3JfFukqal3Wr/Y7DAnmBBn1IJRvEglnlLAQzhppY4sg7/5HyaQbDbeYs5mhgICQf6EDyQJaUrVFz/TOgPmir5D/X3Bg/3/VxNJFIg+mh2HzqdHczRF6OZYaOZRveDDGf54LwQ5aqnWTw0e590glEj6366n6/TTV00nXmlBz7mXD3Mg5sijzvwfBggYsKYj5ktLxlNTMcMDacu0CasCfbVuiPrlhEFp90/qFQ+56ur5IYRaoMzxhlpzU2HiNGeJSWqJN5FX1txNFbEdxqTuIrUOXdbeP4lm4+YV5jQNWVjj48tFgE4hdp2sGh2nBLgccciyNP4bx62DsahCX8ifxuSgD3A4dvAVMwMJEvLjcX9r4gSy9ztK6Cd7WWOZXCvQpGeKxtORjYoSyeoKQq6wkL/NrJ13DTXfJFGhSKgAAekIjUlymYCY2TzVqklx55HDKgfmI8BWRI8NF8XoETTO0pPX7MkSXULfdEMzjJW7FYTpfG1E0ZZjx8V80UaJdqI3KbH6sYarXJYpHPnYYevOkFv9RtxhHGiB0B/YmVKeB73wd4hkiePYY4xsbmTSS2sQ/zPz+If6IKo4ZvCFekBcNW4xM3ZXkOWV3QjhZ9yX8cFevBjojQOcrKa5liKlv9lBHYCEN7LylrEkixVwhkOga4LuIgl9xUoufaiNNGG+/39LUfW4NN5vn0cb+xG69K8s0C0LobOebI32hPI7yiDgfqy6v7beq2ixwIG80ea5MxIdATJFnL5LVOAPAClQ1ur53xUk3pJvz5LB23rJkAl4sdH3t86buyEK95AjdWUiX4SKZMWyGKXpMYR6yDsPPfNKErUF6EgA2M5I0axeDhR5LNFadPGFfkoe/c74Sv0dtNk+0tmg3toE1x4/aiS3O9G8yIs8c1ws2MDg/bCzjTbpM9B3+XyJgKuC2FzO
 4NVcAmQW
 6SnDLCB3nGVtJr9SzqzRDPNSIDRTHDEMJpB2nnVdqTObPGDI1PKUNqw0CGx6ufK9TI633Ggk8J+ynWgmfl5T+vT+DKELAOHnNeu5iyvdKlqB0d6QoBvcIKqqNEZvE2IfpLtZnzVlBnwaoPsenguA40e1MtB5AWw+ggit1bkVdQCxxEdk+KPrenSeU/KaeIMX06lSDW+cluZ5LTUMzqJWdS40s0OvtW3b8ig9+vpAum/1WYev56JvtM7AAJwQfqz2PG2XRXvRfEDuZUK900WMWX2HUc4I9DIvsQ1CtZlX8yxS4Y4EeZ74s4VOCY9PDOeUkpslADiBCqFbY6GBaWVsD7GqSAiAL3yXTiJTSp+mqk13oxZ1ap3U1ar0i6fFvJjAtLZjiXNkWpxkME7tR2FTvre3JPb1tAwbDWDewgq4KpJjLlL1Q2wI7ugx5Ry8PM11tntcMJMy/VFBPOh1EmR5Ah/3HxSRgOlPEZilf+Vv/AhQD8SmK5l2ytWkwTEpCmEOcntXRHyU/MWjSKUq5v0vNewoNX+pCdrHZxAC9RA92g/eLMrt53xzkgyTT02mZczNDRZyA85B7ZM2ieZ9CEMGMJyT5facvb7NhgtA8sOJTd7C4p7eN/V7ewf5uOwoY56CmRRa1IaOgHio9HR0NL0TUOGHcLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 15:07:52 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Fri, 16 Jan 2026 01:18:45 +0530 Manish Kumar <manish1588@gmail.com> wrote:
> 
> > Change the declaration of 'seq' from 'unsigned' to 'unsigned int'
> > to follow kernel coding style. No functional change.
> > 
> > Signed-off-by: Manish Kumar <manish1588@gmail.com>
> 
> Hello Manish, I hope you're doing well!
> 
> The patch looks good to me. However, I just have a few comments about the
> other patches that you've recently sent out as well.
> 
> I think it could be very helpful for reviewers, if you grouped related commits
> together (in this case, mm/page_alloc.c cleanups) into a single patchset.
> This lets the reviewers view all related commits together, in each others'
> contexts.
> 
> It would also be super helpful to Cc some of the reviewers / maintainers who
> are relevant to the change you are making! scripts/get_maintainer.pl will
> give you a good idea of who might be people who are expereinced in the area
> and are willing to review the patch.
> 
> Thank you for the patchset, have a great day!
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Whoops, one more thing. The deletion of an empty tab is included in this patch,
but it's not mentioned at all in the changelog. Before adding my reviewed-by,
please elaborate on it in the changelog, or submit it in a separate patch.

