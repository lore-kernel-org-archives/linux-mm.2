Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE6EE7C70D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 10:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BB66B0005; Sun,  1 Feb 2026 05:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D93B6B0089; Sun,  1 Feb 2026 05:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F916B008A; Sun,  1 Feb 2026 05:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB636B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 05:30:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADFAB140924
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 10:30:19 +0000 (UTC)
X-FDA: 84395518158.01.8161CA7
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id B25FD140006
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 10:30:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=pLxzDjWg;
	spf=pass (imf26.hostedemail.com: domain of regressions@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769941818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZDElJ9ZcZR48Aeq9CU/w3Y1HCk2lc3NXhuQunR84Rc=;
	b=oMmSaBuwEdxib8Cm18+/eLhH9i3VwVLDJeWmGkfY8o646jA4ofmUeZAFVf2Iphadal7Mi2
	OYIuCx8tpZ1DcPxYxZpqoq4vsEKvBmjajBiX3wEpJuh3m/9mR7HkiKskFfuWbPooDqCCgs
	JXIHjvudzwHsSPu1qlk4qMp39JAwDtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=pLxzDjWg;
	spf=pass (imf26.hostedemail.com: domain of regressions@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769941818; a=rsa-sha256;
	cv=none;
	b=fBaZacFop/EV8pdAo7xSB5WQkW1F25jOQGXokfQdyzEqBtel3gS5Q34hNMgb+LuQMjfC5c
	CpzedD2LqByadZ15QzJ3rzogHUsYgTDNd69sD4JQGdCJ4BAZT9HKG1BesZUPS3DCthqD/o
	cu4kbo1DtgnjV1E99UrynYxH73FyqQg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=gZDElJ9ZcZR48Aeq9CU/w3Y1HCk2lc3NXhuQunR84Rc=; t=1769941817;
	x=1770373817; b=pLxzDjWgtiH4pcp3Hzdmbc4PfqNXOZjFfTnm2L9zRgTDNPnpBbFCMmnq5IgyP
	jTtecXGPeygFwxIZq9qtwHgcXh4GgxKzRtFFKl8K6mBGmoOIPeiqAD+kKsPVc+8FQGp+kcSkyVzbX
	mzYJmNXsKQWWKSkPq9RC0NqqrK4JvkdmavFJXklLtJqQOTr0r0jv5wyMRAgaw37cSygjbl6h1geUd
	rytOWX9Dhxx7VR7qoKdlqW5clGCgIfDP4tIeaGLNUm8+ElsFbvAORzuxmsux0nLPxsPItlJZvYtQi
	JtIpr4sFcFXz03D+DVX0ELgX8GBJaLbFIc39UzU9ykTBPeAU3A==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1vmUid-00EMA7-04;
	Sun, 01 Feb 2026 11:30:15 +0100
Message-ID: <c9a25ab3-663b-4935-ae11-a750c7bf3aa9@leemhuis.info>
Date: Sun, 1 Feb 2026 11:30:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes memory
 exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
To: Robert Dinse <nanook@eskimo.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1769941817;45e25e53;
X-HE-SMSGID: 1vmUid-00EMA7-04
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B25FD140006
X-Stat-Signature: w99yu516zhn6p85kg1xyf5ayhbhm65pp
X-Rspam-User: 
X-HE-Tag: 1769941817-988798
X-HE-Meta: U2FsdGVkX1+lc5j96/CQ5CJs4VEe9T1QQlrR5zFRqneLRXMizFmWCaqqv2rzdOz8uZbr7gx4g03NB448UeYeui0Qf5J0IrClwoISjO0vBN8j2WvMMu0Csc+RGTvjqfpss2cNhWJXMbq5LMQ5lVzjwsl9oq7sI0I+TQm7QzdYRB6I3a9MBzCrr99b2zvUoBnPeAs5oxmJdyIdkuAjBuvLAGUOevoYflhMw7OWwjV/ER2VaNK1yye52tXzPTaz7JYmiapvC3cP+ugbVnLKLTHZvmILIlR9sN7z60J1p84GDxH6fpUIE+y3v78Y2zvoeNzGSIBG6dVWbiZebSDlt2eqdvhvgfyzY1C4UbSif+9MwFF8sopm8q5oOSENlZpoTlU9rZhdw0kOo/PPQ5UtcgqknFbTbBggM5sy0EkMhxdhm0pj3RLClvYNqE93wY8Xzor+l5EhQIxKb9r6NUqQQjPLnN9a8GT13or+yhWyfwzKUkaztGXwk3HUDRmg+nUBFq78kCundHgq+exBbGWTmqr185B/t6DROKLeROwIDy5yBjq39O1e+A+Yq97mMx46V9lXqK8u5lCOni7HMbfj0QLqS+lufiOKNiKhzRUjkF9hMxIhi++6VR4CCa3LABsFew+soU1O5A5cUonBBCu0Bpi3qcJm2CilnTL5azvENPPk0ZiNBOHXsoLiF9ATcB7BJ5LXIEvq+BA0TzQQ/CNz3dFcE9X87Yx4YM1NTvGSlA7rw8fI2tKqS7M0bB0tzl9RlCwyzhTNtxkg+m/YRzZNJs2cpVsScrXcLSn+DErvL2udkHTpLuUN7ZG0vJARuVdgXkLB1Lpi6IWHDlO4U+TWn+odxAnyTNSQ+qXDm0IePQV30GoudDlGA8gXzA8Kx+Dl2nuG4vmoTPafUJXkzcmyy5fj+6ClZA+RpsFDChkXmQnnMcBIgXakmnpsX/UFVY7qbgurDWGErRWu9BwcA/RRi+c
 8t8pkTwA
 VvqIncljp+718ex5HUBrJ0lfkrPzP5py+06IDIaH5BAKR9smkfEvIoCtO0zYs58eX1ZYH2wEloOycoPZQEIVgheR2M2TpGoIPPXT4nwBKb2on6p4X+dBxnOHz07InEs/O4n7kH7KfpSlkTNVfIcsFNYgMed61AhdNAMrjTd+/gum1pqK5RMnQcyOEp7I45O8M5un+9+EuoQZ2ZMVz9GAG2efII2xmdQgwpbSdIIIyzAjQpOUSFWhn4t9j5oQQsWC3vzmnp3jHde5BgyfDtWr5zg9KGMynekDNlo5nVEZo/UdzvRykl6Bx2nfmtKbztpE+ItAYrtTo+Q48CPquQUo3JS+yDXijdcBQOFjCelWQd7KfuFlebqdc/JYxahtQGQl9oukfy7PhnnQyKrE98nXJ2q7aOHjVBlCT2QMj12p5ngHUeZc+6S9D5YRnQC1zQgkThh0otHva3p31doHnnK4D+nwLuFuz5djLQXmWeoHi+isItrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lo! Top-posting to facilitate processing and CCing the stable list,
maybe someone has heard of a problem.

Thx for the report. The big questions here is: Is that something that is
specific to 6.18.y or does it happen with mainline, too? And does it
still happen with the latest 6.18.y version (there were a few mm fixes)?
Without answers to this question nobody might look into this if we are
unlucky. And a bisection would be ideal, but I understand all that is
not easy if it takes 24h to detect the problem.

Ciao, Thorsten

On 1/29/26 07:10, Robert Dinse wrote:
> 
> Hardware / setup
> ----------------
> - CPU: Intel i9-10980XE (Cascade Lake), all cores overclocked to 4.5 GHz
> - Motherboard: Gigabyte Aorus Master X299
> - PSU: 1200W Seasonic
> - RAM: 256 GB
> - Storage:
>   - MariaDB: RAID1 of two 1 TB NVMe drives
>   - Other storage: RAID1 arrays of spinning disks
> 
> Software
> --------
> - OS: Ubuntu 24.04, with most userland and kernel replaced by self-
> compiled upstream
> - Kernel:
>   - 6.18.6: stable, previously in production
>   - 6.18.7: regression
> - Toolchain: gcc 15.2
> - Services:
>   - Apache 2.4.65 (self-compiled), with modified exec-php to allow per-
> user PHP versions via handlers
>   - MariaDB with ~60 GB of tables
>   - InnoDB buffer pool: ~70 GB
>   - Several social media sites and other complex web hosting workloads
> 
> Baseline behavior (6.18.6)
> --------------------------
> Under 6.18.6, the machine behaves as expected:
> - Roughly half of the 256 GB RAM in use, half available
> - Memory usage stable over time
> - Swap usage negligible
> - Web server and database remain responsive under normal production load
> 
> Regression behavior (6.18.7)
> ----------------------------
> After upgrading from 6.18.6 to 6.18.7, the system initially runs
> normally, but after
> approximately 24 hours of production load:
> - Total memory usage climbs until RAM is fully consumed
> - System goes ~10 GB into swap
> - Web server and database stall intermittently
> - Overall system responsiveness degrades severely
> 
> Reverting to 6.18.6 immediately restores the previous stable behavior.
> 
> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> ---------------------------------------------------
> I attempted to disable the new async kernel page table freeing feature:
> 
> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
> - However, it does not appear in xconfig or other configuration frontends
> - Manually editing `.config` to disable it works only until the next
> `make`:
>   - As soon as I re-run the build, the option is silently re-enabled
> - I tried to chase the Kconfig dependencies, but the chain was too
> convoluted; it appears to be effectively non-user-selectable and forced
> on by default for my architecture.
> 
> From an operator perspective, this feature as currently implemented is
> not workable on a busy machine like this, and the inability to disable
> it makes it difficult to bisect or run with a known-good configuration.
> 
> Current status
> --------------
> - I have reverted to 6.18.6, which remains functional and stable under
> the same workload.
> - I have attached the '.config' for the affected 6.18.7 kernel.
> - I can also collect additional data (vmstat, /proc/meminfo, slabinfo,
> etc.) if you tell me what would be most useful.
> 
> Request
> -------
> 1. Is this a known issue with CONFIG_ASYNC_KERNEL_PGTABLE_FREE on large-
> memory, high-load systems?
> 2. Is there a supported way to disable this feature on x86_64, or could
> it be made user-selectable for debugging/regression purposes?
> 3. Are there specific traces or statistics you would like me to gather
> when the system is in the "memory maxed + swap in use + stalls" state?
> 
> I’m happy to run test kernels or provide additional inform


