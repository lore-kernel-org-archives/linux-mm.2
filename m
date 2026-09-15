Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8A8C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531876B0088; Tue, 15 Sep 2026 04:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1FF6B0093; Tue, 15 Sep 2026 04:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8536B0096; Tue, 15 Sep 2026 04:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF886B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:23:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 714FD1A030D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:23:13 +0000 (UTC)
X-FDA: 85215306666.18.0E49016
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71AE9140002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:23:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P7c2eoF5;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789460591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6qc6m4ClgS/DLLK2dhqaClRHVdlT2q0YP0qs+LnEzs=;
	b=mn0p8p+2dKYs+1l4uchA7Y9/5wEev+yNwTdlansxxdklwiCT+wMkCNiwrS8TwkVQGUifI5
	xxi13XWL05b6eXt7rGxM6C8V01dBOL0v5g8fuP2nbnzw1ao8SdmkUCTAAOj6UWCtFmLiEJ
	jWkvf2aNVSMe7SyKoEBUJqMvO8y6rls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789460591;
	b=CgwKF/GjU8VjansBNLSYU9l51cldCIZT5rZyVeddhDhaNzW3pWPI5u7a38qZn/tDAEQ7W4
	DthNhqRJeFFT6Jm0KBveHuHSSjhcSt3/kO228W5HQLdwOXX5PyFbxM5kIfGXAms9QZ2sq7
	75/SQT1AY5YBsXmMrXBtc9upXLLIMm8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P7c2eoF5;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so689885766b.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789460590; x=1790065390; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w6qc6m4ClgS/DLLK2dhqaClRHVdlT2q0YP0qs+LnEzs=;
        b=P7c2eoF5wolfAUkrDL4+ZGbTAS+daXwljZ7sL44gMf7Gv6c3V3wOagPaE23hWzQLV9
         214uvEsGewZcZBp4its/E6xHLjA8+f7xpC7P4JXj9mkdjGnIj2gQEndVhRXphK8QvQ2S
         ERRL8j+WghE/69h+IUHtlcXm4xqfKeKOWA2Olf54ZCtZdh2R+dXqHY0DZ8UM00hC/zcW
         Ngj9lUJHPjiTQk5CcTlBrnko0NwY+WmgrJEXBUCyHbpBTJg5BhoADD2UwpYmcDzkohyv
         W9ZCV5iD8CfUPQUAIv1oN85vhlIYgbwEW4PGDp5ymhUK09+BgmmcIgir2hKbozq8s1lq
         FwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789460590; x=1790065390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=w6qc6m4ClgS/DLLK2dhqaClRHVdlT2q0YP0qs+LnEzs=;
        b=l2nszul5oHeljCn/Y770CA9hS9H7gNvCY3ebE2lEJre7gRn735SJJA+elJOPcL4ook
         RYGWd4LZXDwxRhmomExKwv3bbRetkfm+fb461kyOrDkUIxqkAHa4lkte3Ih2SLUec/wm
         qQ5Bj3DimEIBhYJGMZR8FEJveaBdgUZ+Ouc+x2RXDXRi+kTWZTuiW4ntJLqaBXBACz8Z
         z0A9gFklqVz3CrzB1Wc8cvCzOmOqcKo8ImhDha7Hmq3UoVH8cMZ7RQ/mTPpRZYg3GwV0
         ZD0W/bNY9lZ0NVHxk7+Z47kawj9m83Lo8EHQC0S3wes7/63YTmpehZxH+vcmgahWJdS2
         mTMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwGJ5mXLzay7oknBvijqFqjqw7FsneRqwuXygh3LwJKk4/2/vQ2ZCDCS1ZtQTuAiP6ebNvH1VMLdg==@kvack.org
X-Gm-Message-State: AFuF++nLi8uUgfD4ShMvb/0jC/qJh4BpdCVtvXPmsdDlnQFHoe9cgilh
	gwrNExh2DXBW3jzVgJvJ40ns19XIXNDD5XXhIbBzLDoO4zUBO/7CKlFX3q3kHM5kQIg=
X-Gm-Gg: AYBFou35EYsPLaPMwCt3qdMoXBUnq5LGn8lUU1M4OuPz86sE/Ei2A5FZv26gxIWoZQv
	3EsKOcVuZZdFAH5K2lOdXInxessivOg/sPK1y9OFWwDwTkzS9dzqa+pPH38LwOtTY1j6oL3ZyRe
	SmGs8IoAJcw4PA0lCDnxcg0M8iX1JC1i0ycX3w7N2owqqsHn/Dtr5YCglbyRkbp/KmGXhbBWSRE
	VUw+L7dLYcWFjJOzNCwYaogQb4TzspgXKXS2DUpVWmkytnGWrIKDD0J2+8HRTD3DabBc4U8i1t8
	aSCpmKAm2wcHX3nDpof2eIsEDssMUcoHAPQxVzB+RLSko1hrG6pHQYa2c9GueZgNpSsdLs3Ny+G
	/rjNmd/0DvIAh3mQOLQPZjqjxZdIXTvcZRmkIpXxdiV7BYiaERmZzQelW4hxUJf3Rqe7gjY7pV5
	wJXRghYZZ9oV7QKEvzp8e2nFQq21uDjMlJ2nQsBElwxC7N4/3SDi7CntqgyujO
X-Received: by 2002:a17:907:c18:b0:c25:32b0:e56c with SMTP id a640c23a62f3a-c29b85fff39mr363642766b.4.1789460589999;
        Tue, 15 Sep 2026 01:23:09 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966148d25sm536702166b.61.2026.09.15.01.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:23:09 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:23:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
Message-ID: <aqkAbBpYheX2DEHg@tiehlicka>
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
 <aqg-oG2HDIUeK5Us@tiehlicka>
 <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
 <aqjsPW92SgcHONKO@tiehlicka>
 <3c8d1d8e-0e67-4d1a-b73d-4eadd6266aa6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c8d1d8e-0e67-4d1a-b73d-4eadd6266aa6@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: katr1qhs61thmghj694bcpi956cnt6xw
X-Rspamd-Queue-Id: 71AE9140002
X-HE-Tag: 1789460591-797868
X-HE-Meta: U2FsdGVkX19vyOJfHqcqXTV9yt4RpfCEMy3igmG/YBChO+PsihIdwjiWEoYu7YN3Vxeoq5cIPtuE2s8uQ0rE+JnrgbVK9sbTrBmUpDODjEWeFB8myMQfAn7yGm1NxAp7AuPjfQAZikWyGekcbGGJm5rjXrcWH4wSeqE9Ysch1aBW+2vEm2hVsKx84Z+qyGBZeSDzX7T7s6ic2hQWqWWhbho3rqReOwKrU7e+6e+CwgyqZ8IUdFGKJIlN2S2Fkut6oBJH84XlUmmWry0/4ZUlMyLQpPM6y4ZJYm+joM6+bWbeglgPOT2kMSAWrFO5H7U2W/MeNvpiWU96S3WHJiJGbU/xEPCrVjjhcHu5zBmrzKI1SmJj6CJ7Q+Wtfn3eh0vH4HS8i/BAfH/wedrPWaF9CyWOWdJc9hlRP+eZ0B2HX+slWMs3Rx5yjNfh5sS4TqkN4mf5lc1Wu/BOb+b8mGWIIm4aul3TuX4k/UYjiIGLdnzAPc3rIax9i90ZbrlToNBY8LFPezQlcpEKM+QKN6QBxsGNZcvtVunyctd+G3PorkA2L3o0Zqfwjp1ySFdbSAz6PVJBzpjG20TNZ3BAei8+MEkoivX3G59sAk8GDQvVDhsJt0vSylz0ZCPYJ1IIGtmIsfJdI/GkmuCy0m4DyxfDqQuYIQIgGiqig7AQtTDj6YE9ant0tIhs5ZWLWo6M68zsAjGqEiA0ac340i4Ps/LX6ZQ76aXh0u6YckBRxlYey931g3KrbyxU93bdnLksCZGqvE4F9sx6WNh3eI00uBalzt23EqOVV5fqIsKHxeP4dZLlu9AdgGWCJ3E3tvRq2l1V846lUTDX7lo6grs+6C5M6HfQ6b0q3t5LDrLeMTFTzDphunbUvdW+REvNn0Rn8k/73E5ZEPr1x4NTHxAfmBn8ETLCZoSmlCJDYWxgbx2LeDjTMzmnnvZcbpiWjEpzoOoNvu8Sinef3YBsS5bjfse
 j7uSigY+
 Ru7WmcBKBwSYLnY9JaXxJA5i0phSDR5dz/n1cmGrpZgGLat9aTTAJpwbxZNetLe+IU1W3jgAPJIXr2rcc48JuNbYyRkExicsykKoJY6t1gsdqBkzULu9lFzD8/GMF4P+2TPXk2LJ0oAvSkXbNoxLqJpLTmb0y5/DyNt+UeNhynGvl3EOuKPaQlaoyLxTdiTpRiHrVJe+h8fQW7LOyTtZYEpbm+Oib8GUA6Qk049UanQoLiI9G+wZsSG2vS3sfuHZ2yqBRE6nepYHnYN5BUGPkQMuevi6okxsiocjgWrNzdWC3qzcux1rdlrXJ9vtg1PFHzhVOC+seGMRX5td7JGeBR5cQ+LZH/45u8S4phVx8BjmGMUltD7st7dNRCkX4hi2lKsUGe5OI/FxfbWtWwvZtj4ZEtB14T6kOjMEQ1XxWPUZ7n+tkw9G1svoRk5S/6f44y0v09UFMBX2RCfna+g5D6d2CdW+LaGuP9JaInwTxkD+k7cY4zKdTdi02rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 15-09-26 16:13:11, Jiayuan Chen wrote:
> 
> On 9/15/26 2:57 PM, Michal Hocko wrote:
> > On Mon 14-09-26 20:35:33, Andrew Morton wrote:
> > > On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > > 
> > > > > Call Trace:
> > > > >   <TASK>
> > > > >   __schedule+0x487/0x1870
> > > > >   schedule+0x28/0xb0
> > > > >   schedule_preempt_disabled+0x16/0x30
> > > > >   rwsem_down_write_slowpath+0x1d4/0x750
> > > > >   down_write+0x60/0x70
> > > > >   __ksm_exit+0xb4/0x230
> > > > >   __mmput+0x12c/0x150
> > > > >   mmput+0x1e/0x30
> > > > >   do_exit+0x283/0xa30
> > > > >   do_group_exit+0x34/0x90
> > > > >   get_signal+0x952/0x960
> > > > >   arch_do_signal_or_restart+0x41/0x250
> > > > >   exit_to_user_mode_loop+0xd3/0x560
> > > > >   do_syscall_64+0x385/0x470
> > > > >   </TASK>
> > > > > 
> > > > > KSM is just the one LTP happened to hit: __khugepaged_exit() has the
> > > > > same write lock cycle ahead of exit_mmap().
> > > > Why is this a practical problem we need to care about? It is kind of
> > > > natural that the oom victim exit path might race with the oom reaper. They
> > > > share the same lock that is mutualy exclusive. The whole point of the
> > > > reaper is to ensure there is a forward progress achieved. So before we
> > > > start modifying this let's talk about any practical/real life problems.
> 
> Hi Michal, Andrew
> 
> Agreed, the hung task warning itself is harmless, especially for a dying
> task. The real problems are what sits behind it.
> 
> With a 500G swapped-out victim the reap takes ~600s, and for all of it:
> 
> 1. The victim cannot exit. __ksm_exit() needs mmap_lock for write and
>  queues behind the reaper, so the process stays alive in D state for
>  10 minutes and whoever waits for it (parent, container runtime)
>  waits too.
> 
> 2. ksmd and khugepaged stall. Once that writer is queued, their
>  mmap_read_lock() on this mm queues as well, so both daemons stop
>  for the whole system for the same ~600s.

Right. But why is that a problem we need to fix? OOM reaper is taking a
prortion of the exit time by doing the leg work of tearing down the
address space. Exiting task would need to do the same so it is unlikely
to terminate much faster.
-- 
Michal Hocko
SUSE Labs

