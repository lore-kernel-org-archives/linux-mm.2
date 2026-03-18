Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB18010854CA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 02:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94836B00D0; Tue, 17 Mar 2026 22:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E5C6B00D1; Tue, 17 Mar 2026 22:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CBE6B00D2; Tue, 17 Mar 2026 22:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA2D46B00D0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:16:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CCB81CFFF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:16:43 +0000 (UTC)
X-FDA: 84557570286.21.FAFE027
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC257140005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:16:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773800201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr/HoyV8eSEtrozy2zI9yZ6ZLU85YzMto/2OvfICG94=;
	b=ZJ1CYARGlLqgWAb3CfIZTINO0/b8qnJxg1z0BXWvg+dGJzkq2EItqyMzTn8EmoEFwM3+H6
	+EoWbB4qqmBXtT4AzU4jFR/lFIpxFJJNJ9S416vc6HYYyS3Br4PGweZR9ZV8dagiSuaiHk
	uCEuz1yQwxdXYCR9CFIBFoRu22VzbHw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773800201; a=rsa-sha256;
	cv=none;
	b=pekkrGVQbS4RMwnu6liLPWAnuZIabPjJ/3tIqYy1cIbgfB78oqGpVZAR9Rt0IQvjYP2rTp
	sIPXr3LbXZqlsDHDBrVUOccJ0Lf0Wn/Hx57aFJtawT7KU2DwEnm+rCDeLSjBur/GKvmzP9
	iSW+Uwc7mx6KRllehZTcktY/su6QClU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Mar 2026 11:16:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 18 Mar 2026 11:16:36 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-ID: <aboLBJtDUyDedN6M@yjaykim-PowerEdge-T330>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
 <20260317121628.abc7f555ec78963b1d705fd9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317121628.abc7f555ec78963b1d705fd9@linux-foundation.org>
X-Rspamd-Queue-Id: AC257140005
X-Stat-Signature: 1atsz6n1hdmxdr6tb338b5nqrpshbxaf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773800200-760936
X-HE-Meta: U2FsdGVkX1/OIl3sVuuWdoRRJU+OBi98WfBRwecwFMNHXGA8yC8zGA82KfQmNYbkFAB7JdlowFpiQPOs9qynH7X+g9ZSnMbHFFnZRF6AWE35dg6EPQk6Noe4fWbENw0BXT9UsfpXNhB8sk468xzVhNzzQ0lMzFmKanu+jsT1wa9HtctmhmVN5aORTYTHc6FMhJHEvOBkkZA0hRrAGtrNleNYKI+whbppqWPSSvWcq0uh2A7GWa+zvZzJFOSd4Pa4oZD4COQ3TeBfOhOV4vp6pZ6dTOZ5JpUaJFnUBwMTnTUyy97gnliZCaR8LJwsxlmlvOYyxhqnpvH31UHrRr8ZTIJuPvSFlsfZCIsFobAwejxcmxzmkXsoLF+7MEQQuObjx0XjDRjhxCrASmPgKfLKTxwtjitEXoCi9CC8GRm9OuW1k1FZ0av2nc9XJtUO0+dqjCt9m9IQcbkXh/RPf4bk2wQCNlxciP1aJ3nUhJyQ2S2NWMHFXrhaLcjlUfqib6PV49VHIKoYgPGWO9wqMSEccG4cB/Nyn2VoIVeekUPLe1vkSMpKi7rNoohCVfutzVucgDJM37yALPS0WKrvTYe5qkVKOV9/yIrJONxrKu6DoziCTWz+R9F2XuuGBakl1ZjYxoQkTCOXmLdA/w0rUpgoa+8gCqXqF+8q1yZSMXvhMz7Vts0BQeiFwG6p3KO6v3JYqyUWBiXgfb7JHQ3PpbmNB+YbMfooxPUop00aD3H1qbRDVNNErNXcFYfmxdiEpV5L9tFUd7yuIzPJM+e/EUAJuAGRlB48PQKRmYzL3uSYnjzKoWXyBfBmyZfCCuxPbjQDOglnZmPP3sVPXL+jedpraQnlChPdfL2RH0l55jAPsbl+wfp0beaTUCoqlJ3xp928dm72WUyAmO2s52S+ceTUvOA9vMV8swcTxS1csKNLH1B9gzZSbS6QJV4N65L2ucMgclSvrBAGQPKzu+zc8p/
 zVRHdLnh
 czNDuhEwHlDm7qWcJbpcxnbL9X88QKw3ApKf3Fh9h0vQxUMY5L+YlMoNwKcP15g5XXq+HuhF0GJYjkSWWQqnbDG4Xvk/q+OTuAvXS/gDUDAvVctLfHJP5KbnBD+795LawBU0GwfMa3gYL81Qu5xCrh0MchC742z1hGFzay+wfQEzLZxyTYiADod66rjwFzAgaWGruDyNBhz4n3gRlYV6NXxE2PDX8WivFin+i9eCSvvqioYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:16:28PM -0700, Andrew Morton wrote:
> On Wed, 18 Mar 2026 03:13:15 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Currently, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the type
> > is acquired, subsequent slot allocations operate on a stale swap device.
> 
> Has this race been experienced or at least demonstrated?  Or is this
> patchset derived from reading the code?
>
Hello Andrew,

I found and reproduced this race condition 
(using a custom test program for verifying reproducibility):

Pre-condition.
- swapon /dev/sdb (intended for hibernation)

Process 1 (test program)                Process 2
-------------------                     ---------
ioctl(SNAPSHOT_SET_SWAP_AREA)
                                        swapoff /dev/sdb
                                        swapon /dev/sdc
ioctl(SNAPSHOT_ALLOC_SWAP_PAGE)

(The same race applies if the swap device is set up at `open` time
via the `resume` parameter.)

Process 1 operates on a different swap device (or fails if no new swap is
enabled), breaking hibernation. The practical impact is that the subsequent
resume operation will fail. While rare in practice, this can be easily
prevented as shown in the patch.

I initially sent this as an RFC because there were no real-world bug reports.
However, after review and testing, I am submitting it as a formal patch
because it has clear benefits: it prevents a potential bug by enforcing the
code's underlying assumption that `swapoff` must not occur after
`SNAPSHOT_SET_SWAP_AREA` (or after `open`), and it removes unnecessary
reference get/put operations.

I also considered, but rejected, these alternatives:
- Enforcing SNAPSHOT_FREEZE first: Breaks existing user-space behavior
  (e.g., `s2disk` in `suspend-utils` calls `SNAPSHOT_SET_SWAP_AREA`
  before freezing).
- Marking the swap device (e.g., SWP_HIBERNATION) to prevent swapoff:
  Using the existing reference counting mechanism is a cleaner approach.

Best regards,
Youngjun Park

