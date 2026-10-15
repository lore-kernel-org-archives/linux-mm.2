Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26A4CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C2D6B0088; Thu, 15 Oct 2026 10:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD456B008A; Thu, 15 Oct 2026 10:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2786B0092; Thu, 15 Oct 2026 10:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFCF6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:13:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15230C09CD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:29 +0000 (UTC)
X-FDA: 85325053338.13.FE75477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 755E940014
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VK2jk6qM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792073607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSbVaC0f2gNWsRFqnc1zPjJqFLHG96Rj4dv0cQbpqHk=;
	b=oMo7jx/uDnbjwrxtgK54PnSh4qvpzONMXD54qasZkikLGsPiib2l/hgTMwwQDEeEpRcnvL
	rWycxLFtrh/TPuHriGEnG2/KKH2cSjaADjFkJ/RDr2PO3Qh8jzV7FQWiDQ8hCzT8AGNzpv
	vf0tXJXyd2TLrod+4HDECFlxGZviffg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VK2jk6qM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792073607;
	b=Vg/acBxpMT+9QYZ4HmYSCwWj+q1cIw60gqCffWcvjQA24+3sljZAdl4bwM6rX0L1uaWt3t
	d8Nl0cEA97FRAFBgz2+L2nrfi9aZDAl+3E8CeJXKNAZA5WsZSECCO4mayvo0/sXvdQhLjF
	xukCf6dqVPKUi9u5dY9Kx65vF3aeQvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5DE3601EF;
	Thu, 15 Oct 2026 14:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C5F1F000C4;
	Thu, 15 Oct 2026 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792073606;
	bh=vSbVaC0f2gNWsRFqnc1zPjJqFLHG96Rj4dv0cQbpqHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK2jk6qMdVNH/RTkBn4PiZI8l5MImtqd3I3/rcyPP3Z0H9vIq89Aqw22/KwApHpvq
	 sq8EsJleJfgC6Cjn62uzJ0PV5sSqtxM5ZHTry/w8PU8mlXfWxmH9jGrONj71JsufQn
	 BdVquPDJF368SCGof+kurkib3QSmOjvG/gWWEwXssUECfiN/Re+GlMjz62a1bxPFDV
	 XgCdx/GqOrPGwHc8J29qkAlYhs9rU6NH0I4eWzlJw1qNGsNbubg51pUq0zBCzySD1j
	 R16wu5PI+4GtNFfiN9cHyLrRR1T1D7o65TYAd88FFUWkm5QxeduSsN9z66q/PyV3jm
	 32hAyDmOWkq1w==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON_STAT: idle percentiles out of order on 32-bit
Date: Thu, 15 Oct 2026 07:13:19 -0700
Message-ID: <20261015141319.88393-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ba95cnqfx8cqoypszgprbuop6o3ugg4f
X-Rspam-User: 
X-Rspamd-Queue-Id: 755E940014
X-Rspamd-Server: rspam08
X-HE-Tag: 1792073607-249660
X-HE-Meta: U2FsdGVkX1/iqFwEBt0+RS3o5ACrnkAsMYbpbsiZt6EemkBOMV8d4detmaqs0R337PJI3u6PaVaZtt4Can1f1G0ulsd9H8ijYEKd5x/TkuS5EJggQkneCidMiQX3EyYNkbD2WHyUoRfPNTaPe3/kwW518c7yBBATA3Kju8G/DGXJEIsJrjDeH8deZpn3Dp8wLA2Zs8JLGhcfCHW45Sx7DStEJzQaQanTjjVy9Ca5b6AOWYIAo37mB9OGntQkdKYIdkU+lKo7NM/HZ1IXumnIgfDrN2BVzEfYHIP7D/ZrDPesOKUiBIoYJ/EOWnxvvoWz2m5soPQpZYfhVfZgkfFiWdAtCwVBCIwfVeHmJdBrLbkKxCeMSnPAvM54Bq4RDPcn5TMIUA8pnGlrbHrIoi/Eqk9OnkEBVYbVSQuuHoqSEyemChthFnI7mSQgGjMXu6TvV7pg/yf2kK109eZZ3bRUgQJ/lFq5NRIWk/b3o7lNUlhZV7uQkXFkjphICVp+AdRNfStzU1u26hmmaDoFBJv0K2ctaaCDZwlBrv44nzg7c52DgqIlWv7M2BEVApdSZnFbseVyrDUkMpiSZkSa5KOG+2Obk5fC6jzm1bM7d2jmYxhUX3Qi963Y6Hhp+geAcQjVGmrPEMo8es20pmsJTi8EORulHkedPSsugJmHvF3yZMMQADTystC9k6VpZ97tldhGjxJJ8bVPEmZL0WyUSnD2Er3sT3K39NQ9bW8laLgIzwSu7Vevn+zMK95oSna7F9atx6PTfWB0Tx/ydTueyjeNsidD7aaxO1qRpbpv/m87nfr6rP8QFPDtcNOJVaG1CVMlumBjT97rJWG+z6xa/QGRmXRsdgFPQodx9teFIMzkTAU2jqnMFoEeVZ2JIk0l2Mcwo2DaEhHnelbAx36N2s12XM2GwqZ7gSSnx5d6GVgBOobpK9nSclprjONevxc+htnRXpHcbCL421jn/otoj3d
 IyeGdOns
 K72Mznmz9RS9XXD5IW6ag7geO51xYraHiOwpokgRVQzzy2dpRQFZzotgVUSv4aH6GAyqLjXPj54uxoAHrJHZwtxsUNZdXZhd2FAHG0e/t01nhet+kKQhx2uUCj8YjLqA1zF6OE0Z8tiNQDNv4c/5yfIIx0giFfj7fQqIBM3jtPNwuPkLfPRuS2C/CxX+blG/Ni/6+1alJ6rBUzqKQeybcmUnFBHa7wTCFmPUyO1iKXNW5HxjWvLmvl9zumWn7dyZsEMYZs/qtY0LtnsNQ4k+gMM/dZlEajWnMtM7YJj6n/dDbC+WUBQUhhJwFyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Avelin,

On Thu, 15 Oct 2026 04:24:12 -0700 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi,
> 
> In an i386 QEMU guest built from mm-new commit ad9f2d463666,
> DAMON_STAT reported these memory_idle_ms_percentiles values after a
> statistics update:
> 
>   guest uptime:       22.51 s
>   aggr_interval_us:   3200000
>   percentile 0:      19200 ms
>   percentile 50:         0 ms
>   percentile 100:        0 ms
> 
> The 0th percentile is greater than the 50th and 100th.  The guest had
> 256 MiB of RAM (MemTotal: 254216 kB), a running kdamond,
> CONFIG_X86_32=y, CONFIG_DAMON_STAT=y,
> CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, and CONFIG_COMPAT_32BIT_TIME=y.
> aggr_interval_us changed from 0 to 1600000 and then 3200000, showing
> that statistics updates ran before the final read.
> 
> In damon_stat_set_idletime_percentiles(), the loop compares
> 
>   next_percentile <= accounted_bytes * 100 / total_sz
> 
> where accounted_bytes and total_sz are unsigned long.  On 32-bit, when
> total_sz exceeds 42,949,672 bytes, the wrapped product cannot yield
> 100%, even after all bytes are accounted for.  Upper entries in
> memory_idle_ms_percentiles then retain an earlier value or remain zero
> on first use.  DAMON_STAT monitors the system RAM address range, which
> exceeds that threshold in this guest.  I did not capture a per-region
> trace in this run.
> 
> The guest init read the module parameters after 22 seconds of uptime;
> it did not write to them.  The i386 config, guest init, serial log, and
> build/run steps:

Could you share more details about your real use case that require the setup
and how this becomes a real problem?


Thanks,
SJ

[...]

