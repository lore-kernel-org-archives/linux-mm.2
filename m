Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35268C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 20:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22BFF6B0088; Sun,  6 Sep 2026 16:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B65B6B008A; Sun,  6 Sep 2026 16:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EB96B008C; Sun,  6 Sep 2026 16:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAE0D6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 16:39:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 644BB1205E8
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:39:50 +0000 (UTC)
X-FDA: 85184503740.02.AABAA71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C59361C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:39:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cp8wQt8a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788727188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lfkzVniauHBDUZUWwmYVmAXW8jioDZoVwHD1zl/aeo=;
	b=qpv+TRfOZdVN4bySeMv22lrvV9Qj/4fffj3TSDUkWZGI4fSiACoo/XsXa6orNJ17ieLFa9
	oJQopLQEzWkSyjag9nPc2hTyl7rPgePoRix9QQVBcvlK1hv8/1JLhahI1l2hc31PJgucil
	Wl2STuiCkvn8L1fw/ZN6Q/Hy4KHxsOE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cp8wQt8a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788727188;
	b=Wa0Ny9ANGsokeM1R5RF2w5O3HFLdSY7031dVdYcn/SfmkCZ2qnFbxKzK79vaoXT/erZZPG
	LoyQ5QFjkb3+/aRk8/Vip7ZIA8OsmiGYBHujYJY36dbJvvdp8se+n5q3xexwK4qyniOjtj
	UaGXfUg3vij3H9TsZEB3AMBF0PCXtbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 284BE40AF6;
	Sun,  6 Sep 2026 20:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F841F00A3A;
	Sun,  6 Sep 2026 20:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788727187;
	bh=9lfkzVniauHBDUZUWwmYVmAXW8jioDZoVwHD1zl/aeo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=cp8wQt8aNj9FIuyGPFzrAcRmVtPOlyFJs6mbjmxyTlntQd9qnR2Rmve+W1ZA3fBv+
	 6+H5TpbE0vf9TAZZ4DSuyMBRvoEZL/BllBU0dc/g2eEf61w78Ka38iXC7RiWUXlXo0
	 dRnyL2RPbFrV2sNfipbi9kMPUldv5J1xSUHeZK2cOghPOVE+EZjbdNJl4CJRIR+KGX
	 a5igwscUE7ctwAA048l5Py4Hc4jVtrsy1mlY9NurCjNn6SN4rBlHdXX7aAGIvyeF8U
	 jGbOXs9AMbG7IHcewhwZvUFvUW4EeIAc1QWiLnhTz/bzHfHFylAnj6OvvaVU9XUJ65
	 5q6FgCKLIZpCw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add documentation for
 dependencies
From: Mike Rapoport <rppt@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
 tarunsahu@google.com, open list <linux-kernel@vger.kernel.org>, 
 "open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
 "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
In-Reply-To: <20260904220555.589752-2-skhawaja@google.com>
References: <20260904220555.589752-1-skhawaja@google.com>
 <20260904220555.589752-2-skhawaja@google.com>
Date: Sun, 06 Sep 2026 23:39:41 +0300
Message-Id: <178872718104.3691424.15410189304450384708.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C59361C0002
X-Stat-Signature: pjgzyy5ahudmgowef3q6695drjnnye9u
X-Rspam-User: 
X-HE-Tag: 1788727188-446211
X-HE-Meta: U2FsdGVkX1+JSPW/bnGvoT4JVmOXES0fTlNCyLEk4GCZhZeZ8LtmFywLJ8nQ5wTPs8XSaIHA2yCWSHPuzYAVJUdK6Mo6sGgvwr4+MNWR8bBFCjkqDX8BdE1AyfNpHXM+4gQkA/4OpZ5cwq+GeUlmEJ519VRdw4RYpPuGAPM6XH/mebNVQ54DoyTXkYpxmOXhumRvlkGUPaKT6BKNVxj36ntDXu3oPyhEm2bZA2amgX6JPFgOY7gEHpJYIV+t4Q9HCam4gYewk1rXoX5kTlWQ6+OkJcLocp8WrvdAicppmmyZBdlCMgQvRnt/ZpPzGD+gxCRe1ph5kRU9Ayr9jMU7/WXN0+MbVjKZbUFUwzOAohan9jEiEjpKiLJI2e4SgL0PQ7f4Y1O5ZTTKPBD8Pq8Sr7HV9x1ArNhd7fsd/OLmcTciZo9uzIMr3B0g1KF814bdMNxIJn5dMjD83zxVEmbJk3HGKA/b7htjGWlQ5882TJq1m1bPt3tvnu7y1KQ/30sAJf+62RKRin5UWNMmrNAz0kfw8WP5HLGcHIBkjoxxw8muW7P4uVLtubHafdPXPA4pbvaBZz+w9CDlSl83MrjCEblRnSnasKzIZgaN2hx1zI6WMPPTfSyQOU06VIyXWXXTrjfBMod0v9UKl+qB+3J4i4kve/jGD3rMxyHC10v7wxtr3l3kjo4TUhJ8XdzGhoIMDCK6RolaSybUrgdDq5K8bJGyNmqC+NOqOoQfybeMgOY+ns9NRNf0pbP3lqyLaZrHM9+yxdD2SKUl0Cby33mSRZ9GCkA034pOO3Wy1y2bt6ePzgCLPLCwIuSrqOXyZRVYs5bTL9q9JPC1wHfOqw1bWnwx/IIkfHfHnYY9XJeLbqxvL/uEESxRfcdRV6fPJwtwaxl75PfF9AbXK7+c0BCjI8Fa/Tp6Ho1ATLZrDYeg0xQcz9BJ0GGPKLnBszwzgdilIbK7sn+AxXxmfeVutgr
 6At5hu5S
 CY6F6QDUr1MJoTEaFhNLCQ0I+ujSKPyjKw3SCKCVLiegr/Oyo5tWWGOqB9cuOQ6tLFIWHIWjXLbgXSqtZC0HAryi7Aop6Sq2XUvtvwcMUCUL+fzGZ9X+7RYXa1A1bRjD6Xlo7TmOjNACkR2KCRqQpfIaQuDjkUGAdd21azA7zlyt29Nv78enY/4QDwuX+r5QZVUIQnqA3groN17jSb21hMaR8YRFQu6WEjHuCWNaZV5DgBiu257DgzJKGuu2jvkFAr+kkOC827PghKLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

> Add documentation for dependencies between FDs preserved by File
> Handlers. This supplements the previously added

Why capital F and H? :)

I think we use "file handler" in the most places.

-- 
Sincerely yours,
Mike.


