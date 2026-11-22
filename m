Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5ACF606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aR5tLEBi
Received: by kanga.kvack.org (Postfix)
	id 5BB746B00EF; Sun, 22 Nov 2026 15:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B946B05B0; Sun, 22 Nov 2026 15:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8AF6B05B1; Sun, 22 Nov 2026 15:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 138726B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:23:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72158120645
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:23:12 +0000 (UTC)
X-FDA: 85463879424.19.14BEBC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EDB3A180003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:23:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aR5tLEBi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795378991;
	b=BDsaJUjuR40WFpKuw2c+MI4fOpj3+G4sYpFSmHiKxmr2hOevonnUjquJ8l4uDmirY75r/v
	z/Ra4LpFCxAYudW3aByGaxd+4/05GwpuRoNYqHfjRxAihvxh2W0Rb5pDI4t+dkVFdcQcse
	gFZnacPn7ZE88XkD+DFbXwHHpV1/+20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795378991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5ie3mh91Y4PxnFzZQ4NkpPcqbOA7zUvMeHhYs25z4a0=;
	b=76Rv1uGmxQhzHc8/NwkAeCs+Cuzny4veYGD6SiTXi8nzPv/sjThGHWMK/s+/9zFMRooVF2
	sM9PmVCUcWqVQaxGi+ysuPE4L619+FqEEo3J09kHP6mJwEopZ3PxGBc5rq26NqWUo+BsBV
	1SM0si4wXsljccOicf0JJH+UzE9RfX4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aR5tLEBi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 682BA60141
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCE1F000C0;
	Sun, 22 Nov 2026 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378990;
	bh=5ie3mh91Y4PxnFzZQ4NkpPcqbOA7zUvMeHhYs25z4a0=;
	h=From:To:Cc:Subject:Date;
	b=aR5tLEBiQQ9qYhBlbQ58FE48NPpxIOIUpGWIAD02M7RR45W6n5k+DccC9MWIJ2Nmx
	 dwjYxAoyhRkFAtxbkIfUGEHmMdFDpqFgqdupeb/2hLSojI+rEaPKd/2/GoXtYEzVoX
	 fo5PX1hSj4+/fb57vEVq9MsQ4TGdn+1sLTrfE0BIJrD1krSnQGLeYS+UTR987NuAiw
	 r5tAQX8ugV+IFEAnPmLQeUfpe3UgpX8YcviU55XA7Gzms9R1qof+T7avoeYgVkd2M4
	 QRLHHPo3R4VDTZiIOVCmAbgUkRmm9G8f6maAD62f7EmIGJ54ZP7SbheZa6ZAMMxq0J
	 kzmZ2/LeGwH0A==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Wrong example command for auto-tuned DAMON-based proactive reclamation, and solution/workarounds
Date: Sun, 22 Nov 2026 12:22:57 -0800
Message-ID: <20261122202258.161562-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EDB3A180003
X-Stat-Signature: fi5g6h47gzemfd13eisfzcfwqfiboere
X-HE-Tag: 1795378990-625705
X-HE-Meta: U2FsdGVkX198eJ7Y2X039NFhI0P5KzPRTbCJX7zRYZwVGdUYtQS7hS+jpbwj3IfKT4bs9vdxeAeDcnvNkFj+b9owDGog8Yo3LbDzYT4gLf9Hl8PhcX5xcoZgmr53/RKn38FVjQywztZu203nKeynlffoOuh+5fWAvMelYIEmiQVtubp/eO7A0Ssc85CwH5dtvo8BmaVkCbtSJkAdlHJKgAHB1RQLQmgJ+F8fCJMiJGiGIbFeMnNRzAgVlnMBlPIoRK4+JPwY7Pct4lC/vV6zh+4goJ8pdfpMpCSsuMY0eIUHM4RRX7cP9rKLgj/8NSOu2OONc7exxoefMDwDKIqv7amLOCpK6yakb0Tjuewhm2dc6St7vHseGlV0YPtk4IKCwLD6wqvxePV7jklan9GRXE9jRh6yRxjczBj6Tf/3Ty2d+/R2SlGsdrf4ftWeyuPreBW8kiiIO34Fnnge6/wN27P8b2q34rk0Gishj7MUK41yTNxO+PwpMl3Xau8TXzGw11COl8QjdtBK25DfFQ4xgqiLrynUvLzNAq0KoUQRkrWs80cPReyiaFAG31MwvcfAbNr2KsA+5VvC+sL6z+Ebd3umpzAGK8HBdZBfs11q+FjsBeSbquF8DHaaIKCx7qbLdVyh9sopQFSKgtWfAiCInt4AmimDCrAxsl6G0riuGHs7b2KMgydq2DnZ6dwTndD0U6mYOeWgRkkYqYo4YsEsn5X0qiL8UNNSebmVWpKfialR1rtdMDjNdpcR13lYSya40iNSv/zs4i/DhFxqSAAGd36bwjebSrF+teVJbsjnGVNF1L6ePxkvK9vxSBsmFZoFrz7u8lilcSO/vfIphZmNpdKZYv+DEfCJlgj9F7pTiH3CtFHYEhVD533whXZuni3P0C/FQttbUslh5RbAMjMrgoOC68XwLhF75mwVeRRJXbxsizQNjJ8Xnu38ZwJblcplgzV9dBU8eT5thQ4BEKI
 dhTgcM0Z
 OKfcVvZhaCLUOTrJtf1LKDlK3BzJq6EX8nKhTbupKXsiICFknYHtvD5Dn9pHZhWxa3KXG+3gW8h71lbfjPcu4WEySErqyZt70P0ynZY+HnGGCs9wqi59H7kMP0R0GAfFWBSNPDNzeMqzdrq60SRrDhdaD0paD3hUaGcF3nplOVPjgYvDO93YOAjNsc7ED1dYR9uPV1UlloYAO5sKF0wbTNK2TdorZYd7OfhBiHyv8LdBubZ5sR3Poazo2ENNaBvQv9iOdS4Pu2f51RcrwdQ/hWyN3SNibihK6GOPYcvkIlz7k4zpLgGp9OQUxsQ63y1jNAzSYgHz9t2iQKCodoGh4CJYIrEvHPy84jbAQQygSskI7+IT5p1hBx0J5nOgjdgx2M19GLJX8+iWaZ/kQw4oiKtkG6e6rcpvom8F3C+d2sArVblHF4+8FfCr699zuba/3QR16NQ0eD0Spn0M54UlgJwL2Cn7qaifOLxHRXTa6y5yKuP0vEjpo3v4t/hYpoELKFHyqU4eGHsCeIngxM8inKwk5+nUXnN5yWzhqZI2j5G7S6HhG7syTkqd0CzW67F2tx+Ozd4tKRUc7DC9GhjeSr9qEaKBo8e0r8iDOWoCHZE13k6ttuKcW9SnE0IxMgg1FpcGO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello community,


I suggested wrong way to utilize DAMON for auto-tuned proactive reclamation.
Let me explain more details and correct way to do that.

Wrong Suggestion
================

In OSSummit Europe'26 and a few offline discussions, I suggested [1,2,3] people
to try DAMON-based auto-tuned based proactive reclamation using DAMON
user-space tool (damo) [4] like below:

    $ sudo ./damo start --monitoring_intervals_autotune \
            --damos_action pageout --damos_access_rate 0% 0% \
            --damos_age 2m max \
            --damos_quota_space 128M --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 5000

I found [5] it will reclaim much less than expected amount of memory.  That's
due to the mixed use of '--damos_age' and '--monitoring_intervals_autotune'.
The intention is to reclaim regions that not accessed for two or more minutes,
while auto-tuning DAMON internal for optimum access monitoring.  But, in this
setup, the coldness threshold (2 minutes) can increase up to 4,000 minutes.
Memory that unaccessed for 4,000 or more would be rare, even in real workloads.
That's why it is expectd to reclaim less than expected amount of memory.
Please read the issue finding [5] mail for more details.

So sorry for the confusion.

Corrected Suggestion
====================

A right approach to utilize DAMON for auto-tuned proactive reclamation would be
using 'age_ms' DAMOS fitler [6] instead of the age threshold (--damos_age).  It
could be done using DAMON user-sapce tool (damo), like below.

    $ sudo ./damo start --monitoring_intervals_autotune \
            --damos_action pageout --damos_access_rate 0% 0% \
            --damos_filter allow age_ms age 2m max \
            --damos_quota_space 128M --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 5000

Note that age_ms DAMOS filter is not yet landed on the mainline Linux kernel.
It is expected to be landed on Linux v7.5.  DAMON user-space tool (damo) also
got the support of it starting from v3.4.4.

Using the version of damo, you can also show if your kernel supports age_ms
DAMOS filter or not, like below:

    $ sudo ./damo report sysinfo --print_feature_name_only \
            --print unavailable_features | grep "sysfs/damos_filter_age_ms"

If the command shows nothing, your kernel supports age_ms DAMOS filter.

If you want to try this by backporting the feature on your kernel and need
help, please feel free to reach out.

Workaround 1: Periodic age threshold update
===========================================

In some cases you might unable to use the age_ms DAMOS filter.  As I also
shared on the problem sharing mail [4], you could work around by periodically
refreshing the threshold.  Using damo, you could do that like below:

    $ sudo ./damo start --monitoring_intervals_autotune \
            --damos_action pageout --damos_access_rate 0% 0% \
            --damos_age 2m max \
            --damos_quota_space 128M --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 5000
    $ while :; do \
            sudo ./damo tune --monitoring_intervals_autotune \
                    --damos_action pageout --damos_access_rate 0% 0% \
                    --damos_age 2m max \
                    --damos_quota_space 128M --damos_quota_interval 1s \
                    --damos_quota_goal some_mem_psi_us 5000; \
            sleep 300; \
      done

The first command starts the auto-tuned proactive reclamation.  The second
command starts an infinite loop that adjust the effective coldness threshold
for tuned intervals every 300 seconds.

Note that DAMON user-space tool (damo) of v3.4.6 and earlier versions will not
work as intended with the above example.  Those versions will reset the
auto-tuned sampling and aggregation intervals back to the default values (5ms
and 100ms).  Hence the coldness threshold is also not properly updated.  To use
those versions, users should first see the tuned intervals and manually set
those on periodic update command.

Because that's too cumbersome, I made a change [7] that avoids such unnecessary
reset.  With the change, the above example will work.  The change will be
included to damo v3.4.7, which will be released tomorrow.

Workaround 2: Small coldness threshold
======================================

The periodic updte might also not feasible for you.  In the case, the simplest
workaround would be setting the coldness threshold to small value, like also
mentioned in the issue finding mail [5].  For example, like below.

    $ sudo ./damo start --monitoring_intervals_autotune \
            --damos_action pageout --damos_access_rate 0% 0% \
            --damos_filter allow age_ms age 300ms max \
            --damos_quota_space 128M --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 5000

The effective coldness threshold can still be increased, up to 600 seconds.  In
usual real world workload, the aggregation interval would converge to 2-20
seconds.  The effective coldness threshold in the above example becomes
6-60 seconds.  It may look too small threshold.  But because it has memory
pressure based coldness threshold auto-tuning, the auto-tuned threshold would
be larger than 6-60 seconds.

Wrapup
======

Do not try the example command for auto-tuned proactive reclamation that I
suggested at OSSummit'26 and offline discussions.  Use age_ms DAMOS filter as
explained abovely.  Feel free to request porting help if needed.  If age_ms
DAMOS filter is not feasible, consider periodic threshold update and small
threshold as workarounds.

Again, sorry for the wrong example command.  And I hope the above solution and
workarounds help.  Pleae feel free to reach out for any questions and issues.

[1] OSSummit talk: https://sched.co/2RaXh
[2] OSSummit talk video: https://youtu.be/GolUxZZrVsU?si=qdPFE1RZAaNZ0lsY
[3] OSSummit talk slides: https://hosted-files.sched.co/osselceu2026/67/damon_howto.pdf?_gl=1*1dml5iu*_gcl_au*MTM5ODk2ODM5LjE3OTE1Mzg3NDA.*FPAU*MTM5ODk2ODM5LjE3OTE1Mzg3NDA.
[4] https://github.com/damonitor/damo
[5] https://lore.kernel.org/20261121015324.83753-1-sj@kernel.org
[6] https://lore.kernel.org/20261106020559.98352-1-sj@kernel.org
[7] https://github.com/damonitor/damo/commit/9f124c1b95684065128


Thanks,
SJ

