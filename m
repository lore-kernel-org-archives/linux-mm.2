Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BB8F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E936B0095; Mon, 23 Mar 2026 21:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E6D6B0096; Mon, 23 Mar 2026 21:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5243C6B0099; Mon, 23 Mar 2026 21:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4369F6B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:13:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFE2C14101E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:13:25 +0000 (UTC)
X-FDA: 84579183570.08.0AF7AB6
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28DFD20008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:13:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RN910dX8;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774314804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDu91jmxCGX0vwdOqIXVmf+V+JaxTP+PZU0Tie2nYn4=;
	b=qRfqNeZ3EiX40YdTlWUWph+4cYwCIOLjS9porwRaIrI7i3Ht4gnB1c3sTWR3ch4vjqpOEi
	xuZVe/XXELL+fMuT85ZT2DcZo5d7Oi6DQbz0t2t2rI00Ba44W8ncwPK1jJ8Zfg0iEaY43p
	6YDuZHNAMya8AiXlBT0I7c+yf4l5Ewc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RN910dX8;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774314804; a=rsa-sha256;
	cv=none;
	b=EGB8xkiBDGW8x1GelVl6X27oJ+Q3kKuGASiMDC+G8L8pYqP6YdJuGx76SDgPTaTOy1/Qwm
	+tUNl/Wp0Ad042mllbUTlHAUwW6wD4Go3SCNhH1ihpN2RftI9nQE5Fqcf6iSfIRhWVnCqS
	1YYPCCnZYRYyFp8XKPFREaR9Y2NQCBU=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so43295ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774314803; x=1774919603; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDu91jmxCGX0vwdOqIXVmf+V+JaxTP+PZU0Tie2nYn4=;
        b=RN910dX8c5yw8IrLj+XPmEVzYvUwc9l5uU0MNTLAu4X3BoKjrDJnjSQ5IhCdiHjh0j
         wpRyiB7/s7knIH8OccB64Cp/fxwAgWahATBKEHEDUtIIruxPxfjCsrQerg6AUE9JT5Sv
         UdeN360DXsxWM2WWGlHm7vJ7IZojYChOl6DRQ90dGlKVPaPLO7zvKI+a4je4//sKT2TX
         63DqT+l098cA83eiIMZU1o22wwIO5uF8ovqgZ/Ve+YnTTGoeVZ5P86trtAZ0lCBBdojN
         LAb4uy1JH9dAbROY8EDcshUyihx3jFGgzPIUAq6KjaUNA7BbAvjJf0o1j3xBrBSGVIKM
         BmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774314803; x=1774919603;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDu91jmxCGX0vwdOqIXVmf+V+JaxTP+PZU0Tie2nYn4=;
        b=GvbLSdVhlVahKKtn+uHs1edzwHfeD1wOschXyZCmGacbb5+0k32Ag6D3kxD2AYl6Dm
         yw77D/EYUZdjWuSPZRgJr5eGljTNUXRnbcLEDh5LdjB3O0IABl9Qla0xfpewtgw23b2F
         rCZq02a1qxrABTfg9gps1r/bla1ghfulDxEl7rBmzIRQb1m1opiOBLU5QRYL9yLVxuuf
         1bYmC95ASIvdbnYGGgx7bDJCF9JQblXucdbnsMWhrPuyjRkJ5/xj7RmrfISSyFUF/K0e
         sxnHjZIv835DBxvlGr6vZ0X8Lzjk3Wl3Zb597pje51QzLWBE21pWWIRF/A1Blwtduayf
         ynEA==
X-Forwarded-Encrypted: i=1; AJvYcCWmSxyq85O6Y5Fzx1aDv6AWHP0qfLwpXbLFxRsHIDGUgGQnppzeFapssRhPaufYz8MUUT6LhF/48Q==@kvack.org
X-Gm-Message-State: AOJu0YxKiFx3ZChrLDtpu6OPDubWaBIBbq61DhjhLvTIkoPICzL8ZfR9
	NYjoF/v65LOfj/r2V8vl4OPsuYx1+wqhFcQkfA8N+TN0LVnLGB76LVwQONAZ7emURw==
X-Gm-Gg: ATEYQzwZMe9NUxQY1tbmQie6yUzVUwINTAasYXyJD7RfeOha7ri1KbVJASiFFCyfMNu
	plCe0IZZapYjsIQ4069bcqRkpVjlIVRkHoaQvjysY+pdp5BwmjqKo/Mzi9GyokLumitbQSebnHC
	21Ts/9RTwJtQ5Y9KGyvEgTmaZiEBBJ5YsL8zf+Cypx4Yviqg2yFjoqvk/aGZ+h0+GhYYwt4tzT4
	swNf9FtJfguwLfPWTnc25ZO2oC+mBdvCGBkW8X0w/fQ3rrGRs4snl4DvrPjs13m6pSeREsb/VUx
	wTJ672OBRE3qdwmInyxrXxEihip4TtDdZutyCx9gkUga2THv2D0USLcxE47+xpuwYX0g77gqZo4
	iuHZPkfXZDj1CM9zUMuB86mqpZQTqMHk1Df3WYTALgQvazmhBnpgJIxxeBxAcX4XKuip7a3TDm6
	C0pr3rudrHDevywedIsJTJwZ7U0oPuFa5lmwt2Su69FKy8vz1X19A1YTMjRiDA9P6NUvELsaeNs
	rp7gEaXjYi77tEAIAlpsmzCtsItmUjq2JKziLX4uKvr63to1MjI5A==
X-Received: by 2002:a17:902:cf42:b0:2b0:7a9b:82f3 with SMTP id d9443c01a7336-2b0a53e6fc7mr1554665ad.8.1774314802283;
        Mon, 23 Mar 2026 18:13:22 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:36e5:9ffd:34bc:bb90] ([2a00:79e0:2eb0:8:36e5:9ffd:34bc:bb90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836b8b95sm125621305ad.83.2026.03.23.18.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 18:13:21 -0700 (PDT)
Date: Mon, 23 Mar 2026 18:13:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Michal Hocko <mhocko@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
    John Ogness <john.ogness@linutronix.de>, 
    Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <acFwIJTk0L6CWuW2@tiehlicka>
Message-ID: <9c21e9e9-7347-18cc-9dd5-76fad75719dc@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <acFwIJTk0L6CWuW2@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 28DFD20008
X-Stat-Signature: w1jjnihjrdgozx788utw84oiap5kgamy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774314803-974453
X-HE-Meta: U2FsdGVkX1/Ij2pkDaaPlBCDIEAtiGomu4WAWDiRjI6a6D47eNkEd7V3DeLJvp5K3avrBCYckyRlwMkDOROV3pWnWtABwkril6VEqSA9DzlsvptPpO6XD+ivd51Df6O3pSOX4Qcdbj6+AKIEGNKWgEhkkSxuihPzFEvrBjGhk3n6F9ZJ4v3nFPD43a1BXBok2EzAvzxqicoXt0LJYYHlUMjBxDfrTKcurf3twvL1xXXGwWUDc3GqCXOewGf3r0RgLl5kqDkmiyH49ygst8Ug5WtIqA63z/vmmtmHVoLOYsNiV9GTIzDEXk9/0ZQEt64YycZWap0HztIk3vU4VPt+mhvaSyPmwWb92D1gs+piilm3uFNLiedL6CG6H9tS5JBWkwswCSYvWDRD4eSn8xv7HoRRN6b9kf0DUzxi6vrFG+nao+JvEHBPKkUhaN7UJbEDUNByXUaCIxcHfNTQixRWX3qYxRmYswr5mKSk/lP0njbZgLP+bm+qjGGFca/nrxwSYaZopcMf/LKrz4NtT9ZVQdjQcAlPWaM/9qd/G2XJB9HeAIjsBDlb7hn/NOjht9EJPElcbNNUKOTgfsRA7/FW56AVh7j9dDD1HVFYW47r5UlyIC9NpqEw8Z5CSjgqEw5zYQz/i82mZOSTEVpcrdofBFloYVrJ6pMfxqop00nur5z53kz1cL14h2EawNkXmvC62vzi46huWHUMoej3yxV6s2xvcbSkaXSSUtXF28mxDWlB82w4w2Yvza+OcTdFOAH6IIsqegb8FkHnl58PVpG9QJR15Zr2irF9XXU4wTmbIl7fvrRL4Q+UqNQtz0EgvkD1EfcloQdPtfUUgd7tItFID1bLzjW2omvtQ4cpY8VcGH2SnX2OtcFqMI+V4OVIi17SPK3z1BUwKKTLJpvhe066FB3evy8lQdIu1JBYKgrN5LegrJXMcrtlGFQsSZZGEUFwOtwA/sO1vCiWsZStXoB
 mwZWus8D
 sSXSPewWNIKQC7OC1zzkzjk8SJyAreXE94JB0KvIwnivDKbsSA1EudOwPu27ukZTGF97j9O48hQ1DzODJQH8NozQNUNa63tNehBuASlOmrrTj8Gmi3VSj8FIeOoY1i3JPU354O2eZ1PjxJAP2csgMMeacmUa75MpKeBQ8bs6hcv27anhm8F8owRf3pSADp3A4HLEDFiJmtfQ690WQES6WgjKZLV2kXvv8o6s3+3ytrIF5/sOUzB9vCxhfK898vsYAAPZnoGh7U4rZUXh9nR/aaNwn+F94fkVdDvCGXguqE5sl6HPfO+16z9lX3qpH/5MsznCynIzOPa595qrfg20DH4eErpQausFeTMf+kelLC2oaBuz5uOr9faKKAO3ugeNasU5ZSIykMnsgo02dTTm6DkZxGFENVKy1HoMd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026, Michal Hocko wrote:

> On Sat 21-03-26 20:03:16, David Rientjes wrote:
> > Previously, we had warnings when a single page allocation took longer
> > than reasonably expected.  This was introduced in commit 63f53dea0c98
> > ("mm: warn about allocations which stall for too long").
> > 
> > The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> > warn about allocations which stall for too long") but for reasons
> > unrelated to the warning itself.
> > 
> > Page allocation stalls in excess of 10 seconds are always useful to debug
> > because they can result in severe userspace unresponsiveness.  Adding
> > this artifact can be used to correlate with userspace going out to lunch
> > and to understand the state of memory at the time.
> > 
> > There should be a reasonable expectation that this warning will never
> > trigger given it is very passive, it starts with a 10 second floor to
> > begin with.  If it does trigger, this reveals an issue that should be
> > fixed: a single page allocation should never loop for more than 10
> > seconds without oom killing to make memory available.
> > 
> > Unlike the original implementation, this implementation only reports
> > stalls that are at least a second longer than the longest stall reported
> > thus far.
> 
> Am all for reintroducing the warning in some shape. The biggest problem
> back then was printk being too eager to stomp all the work at a single
> executing context. Not sure this is still the case. Let's add printk
> maintainers.

Thanks.

> Also it makes some sense to differentiate stalled callers and show_mem
> which is more verbose. The former tells us who is affected and the
> second will give us more context and we want to get some information
> about all of them. The latter can be printed much less often as it will
> describe situation for a batch of concurrent ones.
> 

Based on Vlastimil's suggestion I think this is trending in the direction 
of 10-second reporting windows system wide unless that doesn't work for 
some reason.  I do worry about reporting many stalls even without 
show_mem(), however.  In situations where the allocations are 
unconstained, all userspace goes out to lunch for 10 seconds and that can 
result in thousands of threads all reporting stalls and spamming the 
kernel log.

Idea is a 10 second threshold for reporting stalls and then only one stall 
report across a 10 second sliding window globally.

