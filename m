Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDD0C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9F39000AB; Wed, 13 Aug 2025 12:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1CD900088; Wed, 13 Aug 2025 12:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB78C9000AB; Wed, 13 Aug 2025 12:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAA53900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:22:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80C8758D45
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:22:36 +0000 (UTC)
X-FDA: 83772252312.17.241700B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id ECF4720007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:22:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755102155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYcNKOMDve46LrUSX0OXGVn7stno1PN/JfRyFPWVWbk=;
	b=xFY95wiWCufOAw/UCqcqNvtd5/crHd2y7iTIfP5+C4mSCfr3PHTi9hpWoWREkRKE0WKUqn
	56wFO+V0Z4aRjaajIjGiaEw+qPS5OmkdmeQ+5f4cA9cL8mnLCdMM4JAeykIgVJGH+Dt3es
	FOCSssPCBjrzOYFKiS/zVHaM2oAm+kg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755102155; a=rsa-sha256;
	cv=none;
	b=C64owRnS9XkB1R31HMwMmwTmlb6g4SFpKkKL3SHJyccFvZmM6Gr1Z/3Xf68XZBI6AW4SRr
	m74TKUXYZz57O7aVcWLUTmPOSMlzkTQhYh2dFxISwzYkEdxhTQdXTm9tlRkgqNXpnKj20F
	BV+S+1uGsXqxyToG27zBLBatpCKkuMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BB10601F4;
	Wed, 13 Aug 2025 16:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE50C4CEEB;
	Wed, 13 Aug 2025 16:22:32 +0000 (UTC)
Date: Wed, 13 Aug 2025 17:22:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJy7xdOu51zEGAMH@arm.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813085310.2260586-1-gubowen5@huawei.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ECF4720007
X-Stat-Signature: qetyrwkqqmbreg1w6x6rn8zyfppzyoum
X-Rspam-User: 
X-HE-Tag: 1755102154-984627
X-HE-Meta: U2FsdGVkX1+7xkjsntqaSN6LjdAjrsgHWuMoi9uJ0XVYPK6UBpHebLAUn6JYeI6WlnDaBl0g3UU9OWWOcRWpixaSZtrow+cfRiflNB+5VI6KRCNj9bfHyGK9uCH1q2YMEgEQLL1TaV7xR19vm2/I5UYh+FdJJsTJMjGa9E0NDwAUBOct/X29KcAcYC2uK2jI9w2gP+270MSSSCyT5j3Uazyb2Xp9XfCjIc3KECUEgCxdBd9JIQ7y2R3sj2RRVwM8Dxi87apsHgVMzWmXjOhXHy7ksFu6WQpbMTvVazsZ2T6scHXRT5qI7mJuhow19HH5UIjM0Zr3TnRtej8RdPnWZ8W/tAEsB8vdcznpK9t0FELPayG3hs1zDWq+GZbYpudlXH8IVlu3eum/b+yqvKVoJvrA1aLLu4r3JvRSmOaNsEaVOPvow4TXasve4lJppWjAoJeTAAYloxJ6D7J+7Inv41vFq9Mb9ElFZ1nJJ7/tyPC4TehEbOLV8GgrISpTiYkMNCUcsFeAUAs19y58dbl/iyLWMU3vsaqWqCgnSXm/caah1YiJFHMCKFDOBlruWvKFN1wVwtX7SAyp/fCkj3lPMhO5iPMhILewaF7K87Xvr7pLKcxP3diIuJCBbiWXyzv+6bTNZb2N5E++LS/92Uj1bZpQPx27IPxA0cYpjvm5SzTfp9G9/7T2zJu08ssuTZtPh+n+4YZRJMjAJ7LJxiOb8/I0yt6HpK0HTfWOOwhVEhJZYTN2Kid57nlRhsXYmtA1bS+PFbAxbsQ4hkUwaQg8LVT7lxXIPykhNx4yYCz2KsQW6U5Idd6s8UTuGNSanWR7NQM3wgetCwLTHCHJPKD8HgbPrh88o+4ZupeAKW2O1+l/sCqPoKiHS/8Xt37Ddx/bJ+7Xmz0NJE8rYUNfdymu7RzbkPQSIBPX4VYujyJ1gjVlwkqt/5/iee2Jo8bndxcsgnd9MFIaLli0CgWBbKj
 l1xgGdZ0
 SNGvgELWhhSkRFqZ+ejl/u0OLdrv6JdOBigT73flhiVcrwYP8fbvcR0PSdjATx7DrHFKc90hBwlOjwO56udkQnIJQKReqQfXDGzCYq2i2ON/jLaFd6gRqzAm42GSM8hNqyeNhlxlwMQgAKJTa466RFsAmhKJ1hP8AkWSkGwrbe4/WmqyK75z9cTCcD1qlbAAvyGbA7PlsaY93nnY65/3DMzW48vzsV0+OQXU3EJKu5EHTF7C/gS06dMfcgQY1JKvpzSSZPf2soRHb4bofqseO3NFhNV3rnyf3+vImEMvek18dfNXWtlUXZo4LbDIKQ0veAWdoQkyCICwiU14qVtMYiPQrC6BQeQgw9xbmvYeYfRlszBxfdE7mAfFmFUK/Ks90hUFTHVf5RYdQGiGbBe4A45AnhTDPLvMEm/d+gZsIK/ZGKtIqYuqFYpH0EXIPASmapwNCz9nw7fc59+JHhA98+EzILbjDh59hA4NsP0YXY9MefS/ceGFtpo6juNQrLgl80p1+85wzeN38PIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 04:53:10PM +0800, Gu Bowen wrote:
> Our syztester report the lockdep WARNING [1]. kmemleak_scan_thread()
> invokes scan_block() which may invoke a nomal printk() to print warning
> message. This can cause a deadlock in the scenario reported below:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(kmemleak_lock);
>                                lock(&port->lock);
>                                lock(kmemleak_lock);
>   lock(console_owner);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() if we want to deferred the
> printing [2].
> 
> This patch also fixes other similar case that need to use the printk
> deferring [3].
> 
> [1]
> https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
> [2]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> [3]
> https://lore.kernel.org/all/aJCir5Wh362XzLSx@arm.com/
> ====================
> 
> Cc: stable@vger.kernel.org # 5.10
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

