Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADECE94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47DD6B008A; Mon,  9 Feb 2026 21:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5A16B0095; Mon,  9 Feb 2026 21:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4AD6B0096; Mon,  9 Feb 2026 21:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9D3B6B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:20:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69923C178C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:20:52 +0000 (UTC)
X-FDA: 84426943944.05.C1D2F56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C41DAA000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:20:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gZtqXKeH;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770690050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kL3xj/7zBkla4bp12bcSgkJkH65ElURfWpDx7Ofc+L8=;
	b=Y2pNKQ4pIJyv0NgRAw5CoymlQoXLy+WKEf1//gUhK+1aaPhH8NqskM2mOEvHhBY6o8KZSg
	/1kFXQ7ExXeBj/3sVu2BdUQ1eOhFYcTEjIf/c5F0wc8zk+RsJ6xtzKAmwGv1ok7e8gR2vU
	tuvA9mqZ/wkd+4oUAvtLBwze8wxjgrM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gZtqXKeH;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770690050; a=rsa-sha256;
	cv=none;
	b=BPu48i6Uvk5GEYlUK+G4zR2NRIfBTHHqxoLUAY1LcTGodp9q3e1Y12QaFlniE3+NUuiHI4
	aaPIuuNxdanw90lSn4uTR2RCGy8M+rrh0iD2fZ38Ra17XTpTQWFaynFYK0+1jE7Ku9NRgk
	xEqG4OH64RFLjpCE3d9sTjN14+Lt+uU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26B8560008;
	Tue, 10 Feb 2026 02:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A11C116C6;
	Tue, 10 Feb 2026 02:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770690049;
	bh=eWtI5RFsKC6TyTHlq7HVVopqrqrklKZARh2YRmv/sYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gZtqXKeHGukuIE9ccY8Txh8UsRLzfJaa5ckipLJmgRlugQbQZ+bOlrnf5Krrd35OZ
	 GoUA8CqJLUU5lA4XCGCe+64y8003akQ0uSt4iq79F2d3LrMovEMyTpgA2OodnbVqUn
	 QfZ/Iy+2mvj7xeZXMtejMz3XGkV/wBHwQpLq6ZiI=
Date: Mon, 9 Feb 2026 18:20:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Dinse <nanook@eskimo.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
 memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
Message-Id: <20260209182049.74695cae76dfdf7718a12877@linux-foundation.org>
In-Reply-To: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C41DAA000C
X-Stat-Signature: gmmnk5di9g43e7hha79ducu77merb3gq
X-Rspam-User: 
X-HE-Tag: 1770690050-913547
X-HE-Meta: U2FsdGVkX1809MX+l6+xzNdf1vpVa9MhV86Ho+sFkBsVS1T7IM3HVBXU9v4K7XzrGlhply7sC5QfZ4eyMFfYpJwE8eQjUiWCKiCe4BciglGQdd6yUgUHA1+b279uK2rJHBkdwTnW4Go/MlySB+aCKiP/gkqoYpatNfjoNWJoLZ5AObkLPcvB5aMkGYZzHHgk6q2lywGmHrX4JClu6YzCQHFylCeAqCdllNXfqsjjLTtkj/oAJTgB/okkbpFQGqiP8CTd4fRS7FyGWFjLavgkOsUGt4cJCQAVCNgZ02Potpi0NRYXC1p7jNLK0mgpXfzydE/WOPWGVkmozhXey5e74rEXmH+wUh2xByWp9Vz56TSJrUXnZc7OuF3b9QRx+IYGxa7PCPbMjNtVnnO08jo+P9uNI4t4gQ7a/mnV6fEzC6WzOpqGbBGZMXcedmg43Jn8py03VtV0mucYH/nEx4NVYpr3SQ/zCGaCOqvo5qpTitkKOwcPCIk6zufPBbo7V2VIgnk4yQb7IvtVXvrWkZkdgGldWzqJOgCoPGArAweKT2VLxzpcmeP8thd9YTUs1uzhAEC00aswCkmCsM+wNX27MLNf90SPnq/ev5M3GqLN3f9y2e/umz1pEfvZpzZpF5U87oCo1OHIOkflZ229ByHXeBwiUo4BQOzPjFfuuaJ3Qk2Rl1t4nBQKMATRMMfGlbEYzaKbXPDrnKdyDYciSDRe4DtX09vy34XgKSF+NplPKZ0UDFHLcXAZiY6K2UoR1ucgCf2DHfosdyTVWCej1JfwHpwlyxQC1GeNLfiacwxWX00bjKFCiqoF5cnd63mWsZtmQjj9HEdUQCVBkLrf6hY0BLq/10L5hrRBAySYDALFNAaWIGr7N1PZ3jscDexhQtqd/LKpOxVZm2VEIVBo1GbZ63LdVR8j1W+KZnzVbQwtdOyChaBS8fwH8zUe3bVlTanYBlFUAVCDPtNWxWyPCdv
 uG4160R2
 o4udeNa5mnHOE4InDpq9mWk2sVtcLmc5066i7sYzfHp7z7vI4bFmQZ1nUVDUF09XGxlq7D1wBYo3i/fxGCXqg8fLXisVrdEWDg2mGW9eM0X2nnUnOyt8ND9fyg3WrfXUnphOXdkxjEkLLnmiearLi9APAUUfuvG4h4lgkDF4sCYeC4KsxUQ4JPG102KHReEgOB/uSwJV5FM7rKFLnUdM2Q+mVuLGlLCnJaANLUSg80xvqlw9q1s7egUr9jh1k1iPtHX2WkB/I56XylExARrVdJE8EUNHcmy8fywF2eCL1LdKD5Mm+j1TXUmUJjA9GKB4+cviJ+HDgdFLtCValJcmEuravH5PsGxeihW7n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 28 Jan 2026 22:10:11 -0800 Robert Dinse <nanook@eskimo.com> wrote:

>=20
> Hardware / setup
> ----------------
> - CPU: Intel i9-10980XE (Cascade Lake), all cores overclocked to 4.5 GHz
> - Motherboard: Gigabyte Aorus Master X299
> - PSU: 1200W Seasonic
> - RAM: 256 GB
> - Storage:
>  =A0 - MariaDB: RAID1 of two 1 TB NVMe drives
>  =A0 - Other storage: RAID1 arrays of spinning disks
>=20
> Software
> --------
> - OS: Ubuntu 24.04, with most userland and kernel replaced by=20
> self-compiled upstream
> - Kernel:
>  =A0 - 6.18.6: stable, previously in production
>  =A0 - 6.18.7: regression
> - Toolchain: gcc 15.2
> - Services:
>  =A0 - Apache 2.4.65 (self-compiled), with modified exec-php to allow=20
> per-user PHP versions via handlers
>  =A0 - MariaDB with ~60 GB of tables
>  =A0 - InnoDB buffer pool: ~70 GB
>  =A0 - Several social media sites and other complex web hosting workloads
>=20
> Baseline behavior (6.18.6)
> --------------------------
> Under 6.18.6, the machine behaves as expected:
> - Roughly half of the 256 GB RAM in use, half available
> - Memory usage stable over time
> - Swap usage negligible
> - Web server and database remain responsive under normal production load

Thanks.

> Regression behavior (6.18.7)
> ----------------------------
> After upgrading from 6.18.6 to 6.18.7, the system initially runs=20
> normally, but after
> approximately 24 hours of production load:
> - Total memory usage climbs until RAM is fully consumed
> - System goes ~10 GB into swap
> - Web server and database stall intermittently
> - Overall system responsiveness degrades severely
>=20
> Reverting to 6.18.6 immediately restores the previous stable behavior.
>=20
> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE

I don't understand why you believe this issue was caused by the
CONFIG_ASYNC_KERNEL_PGTABLE_FREE code?

> ---------------------------------------------------
> I attempted to disable the new async kernel page table freeing feature:
>=20
> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
> - However, it does not appear in xconfig or other configuration frontends
> - Manually editing `.config` to disable it works only until the next `mak=
e`:
>  =A0 - As soon as I re-run the build, the option is silently re-enabled
> - I tried to chase the Kconfig dependencies, but the chain was too=20
> convoluted; it appears to be effectively non-user-selectable and forced=20
> on by default for my architecture.

Yes, CONFIG_ASYNC_KERNEL_PGTABLE_FREE is always-on for x86.=20
arch/x86/Kconfig has

	select ASYNC_KERNEL_PGTABLE_FREE	if IOMMU_SVA

so removing that line will permit you to disable
ASYNC_KERNEL_PGTABLE_FREE.

I don't know why this is conditioned on IOMMU_SVA=3Dy - that was an
unchangelogged alteration.

Please do persist with the CONFIG_ASYNC_KERNEL_PGTABLE_FREE=3Dn testing.

>  From an operator perspective, this feature as currently implemented is=20
> not workable on a busy machine like this, and the inability to disable=20
> it makes it difficult to bisect or run with a known-good configuration.
>=20
> Current status
> --------------
> - I have reverted to 6.18.6, which remains functional and stable under=20
> the same workload.
> - I have attached the '.config' for the affected 6.18.7 kernel.
> - I can also collect additional data (vmstat, /proc/meminfo, slabinfo,=20
> etc.) if you tell me what would be most useful.
>=20
> Request
> -------
> 1. Is this a known issue with CONFIG_ASYNC_KERNEL_PGTABLE_FREE on=20
> large-memory, high-load systems?

Not as far as I know.

> 2. Is there a supported way to disable this feature on x86_64, or could=20
> it be made user-selectable for debugging/regression purposes?

That would be good.

> 3. Are there specific traces or statistics you would like me to gather=20
> when the system is in the "memory maxed + swap in use + stalls" state?

A starting point would be /proc/*info - try to spot something which
increased a lot.


