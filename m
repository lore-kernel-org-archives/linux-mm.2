Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE653CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 15:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269C66B0005; Fri,  1 May 2026 11:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A716B008A; Fri,  1 May 2026 11:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1305B6B008C; Fri,  1 May 2026 11:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 067AA6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:52:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C588716010A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:52:23 +0000 (UTC)
X-FDA: 84719292966.29.CAB6AB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 064E418000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:52:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVDd9j10;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777650742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiF4i7SeB+vqQpOzTdzc7LyjPQDII4G9BWeiAEqxhGE=;
	b=57Ms+RrkA4WvAIaU+Mchd1Q0K8R5kL2WJ3Dn14W5G8rLwfZ1bqRARBr/c1faE+ztdz+giH
	/E5iWqbKr8HGHsNfTEx3pjeIe9t6Z58YQzI/OGKZseCb4UmlyLq+vZosOmXmYdKgeoXoIc
	nZ6kFadge4H5PPLUQ8Tyb29uzLMfNkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777650742; a=rsa-sha256;
	cv=none;
	b=mAFZ3mq3+e8vx2/nV2k/LrnO3cE8ICTNwM/I454LC9QZkzHZ+2xRaBC0kUEEEx++s3/WM/
	/zrJC5tv2k6diwcc2zyDpkS3RBSLGIQmTuO5Oz8qmtiFzHHRhxrOJiN2Mq5l5W6g/Mxu5X
	8Ap6zTzE/pRM4IQmAJPpb2aq+SyoR54=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVDd9j10;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DF83600AE;
	Fri,  1 May 2026 15:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578D9C2BCB4;
	Fri,  1 May 2026 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777650741;
	bh=CmRbcbTi+OjVPZtnCXwufH2SPkRkS5oJkc2YfZ1djM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVDd9j10pzEBSdRC4+QeFj4BgrGtGegXqADT53FcQUjMhslsOR/0b8M/SeBRUjbiL
	 U2fYt86IaWaPqn4mV1onqa61I1SUk7HLNDW/omvLoBf0BH4n82Nt8SShUszHOEgWX+
	 Yg2s+/jyz3VDnqKEVso8YuKRhMIWmw5AZKuu313vA5DlmyJ/Rx3fmNczFEGG/bRD5C
	 eqUXB71O0/nCiiPJ8qZcNkawkQKohpdSSJ4uA0FZNvaLfCO6RUdrocyE/W1A7fSAIz
	 Hbt9kjA297YFDx/3kqUo5yAmQtYP02v7yShDf43ds+6qzWhvd82x48N7/jTN1fhgjc
	 65/sBiyDMsG6w==
Date: Fri, 1 May 2026 16:52:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afTKsSj0i-ZkRZN5@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afNM-gIqxpyJ6ro7@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 064E418000D
X-Rspamd-Server: rspam04
X-Stat-Signature: jw9ohmei1sqctjb5sknnfty9rj1gj7ct
X-HE-Tag: 1777650741-269211
X-HE-Meta: U2FsdGVkX19JN6Q9h45NMbPWlpOzeIrOHLOodW5cZcoKaVrJB6AA1k+TI6355FBBUWCyV5rKeVG6CMfBeKpgaFDNzqjMGREdpfSAe5iO+OrXG8h5Sbalxa3lg7IgxDgL1HahRGUDHnyyRb2wpjkzPs1vWaoYaLPYrsCK0mtF5GJoDVR3uu8tGF2AgJyudHXo8iXaOFGQbhJpYVkF+BE/CG7P1qTJbtoWUJoj08ABsc+JoAzZKBTLadBgCFjdVPijYHO3iY7ZjzumqPBpusP1aidJ2gcOJ/qG3lTCYAs1OTic/HtDhylTszRFQyEVuba5vT1vti0Z+Zj+OoUOoHJShFhqw8ELkMzRKQIJ8soq9xyKlvNScCdACfuPFVTxwOoDNn5tg7EqrwpUPbUznFSD1zwiURGddm1RjrzvteWvc7erDbXdI4W0h4NQ3PpinrXIzeNC9y9aqOo/K7y/8Q7CcbuHpuDci9CmB7CDJUE3YVHiYEZae90JcY5cvt2wMI68YPET8nhxC4Qr+QN4SXxpwQI5HRRpmm14k2nhXhj0LQDH9qsBuAZmlWpJMVfvIkOWhv9Ss5dUXnkdSbJlHAGtVQapCivelceJRtjXpWzRwc+22u3u8atUhTAL+puBBDJDs+i0k6ri9wCjwGCKTDW1OZo6kEL/yttH7qtEhcUyZz0gkLHopLF1unaMHBKAG9Jk4dUe9g5L39bZKAFgvODYYFBIYLT2wEytBlaV4yA83YfSosQ2IVWE0Qx5coFSgD5peMTnN1Uw+XvZK9gMOUfaic/oNqdvxt/3l0E3/MCbHLYBQefppNbR5MKL+PKWxQe1vGUMd2Jyl/ZChOXTV15Dit0rTwCJKPIAQg48OE0OOIJyofFQLoFfZ/YO/Dwek30123/xIO24lO8avf708dmqEc8RhPOOo36kzugceKZf6aElfJ9aHNlU7r+Zy7KTGquLWLrHSzj4P2x/+NTEukR
 FAvaw99s
 LiJe8eOF5K34+rPo2tGuhJtjk8wcfdjfjIEdOzlUx+M+s5atQsWN+oKXo6+DJJLZSl7xeTQD+5k83M22lO2zAQEKBWJSb0IAQZ9MCdKD0e1BCxWWWCeAcuepqj0TgniHEXwDAOqqp7+L21DLQtd+yuK7GQ1VKTBv6UHAy3OsKSuRYoTz97s4sPzssI6uQJd3n/iHCboRIOVmSK3aCGgng0eVEGgeXHDG5CAI+eRlFyUj/LuHSUlLvlZUnP4ggTmUpCiJVEQz8Rpi7CJkPT4YfY5WO53bvdVumiGa6P1hUqTqHdQkLfLkZoHUnKRC/Fmyfs75915Ej4qgBltKqcgIxSCBA/3WUFhwNSAXm7o4b/0p5nk2xxUYC4I+9gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 01:37:14PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 30, 2026 at 12:04:22PM +0800, Barry Song (Xiaomi) wrote:
> > (1) If we need to wait for I/O completion, we still drop the per-VMA lock, as
> > current page fault handling already does. Holding it for too long may introduce
> > various priority inversion issues on mobile devices. After I/O completes, we
> > retry the page fault with the per-VMA lock, rather than falling back to
> > mmap_lock.
>
> You're going to have to do better than that.  You know I hate the
> additional complexity you're adding.  You need to explain why my idea of
> ripping out all the complexity now that we have per-VMA locks doesn't
> work.

After a brief eyeball I share Matthew's assessment, I really don't like this
series, it's piling on complexity for what seem like niche cases.

We already have enough weirdness in fault code honestly.

Let's maybe discuss at LSF if you're attending?

I will try to have a more thorough look through when I get a chance.

Thanks, Lorenzo

