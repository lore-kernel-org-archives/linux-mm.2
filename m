Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692F5FC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4C36B0095; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBA46B0099; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE566B009B; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49B8A6B0095
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:06:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 073E4160A08
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:21 +0000 (UTC)
X-FDA: 84485724162.03.94E6906
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id A73F51C0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="TJD/rNGH";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089579; a=rsa-sha256;
	cv=none;
	b=XZauMT1Th2vwRbkMiIPl3W3j2+b4kkT+IF4gRCOwMAGq7cEcMUd1L4udFtK950OAC8guAw
	EbzLjJbpFu0FzMP2DjVQEcwPsaO0MgOWuh/E+AkDrGriqrTJggksyDMpSnc2Wry7E0HkOw
	3HU71CB6vOD02XJ5nGDEtGfVWSW0pNc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="TJD/rNGH";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRNHYTQlLX9EerVe+YBMUcaaqn9OJCKpaOuanb3o058=;
	b=fufBuLswl7nS8aNep2/lJ6Ln1WMkZiwYNrH4d+MVVG+kv3S55dNvshE7Evsq/8n+dKkr1P
	Etcuh+/fyPVqKOgRXf5CfrqThq0JRs+nv+JOEJHZ9NxO8MZg+b7SV7ty2odByce3Es6MiB
	LlF4Rb+WPa+o+dDP9b5UaJRT/eJoR4Q=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-4376acce52eso285200f8f.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772089577; x=1772694377; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wRNHYTQlLX9EerVe+YBMUcaaqn9OJCKpaOuanb3o058=;
        b=TJD/rNGH7fmyL/029ppBAnsYmWL/b9FtLBqRVY16+XZlrMb4sXEYdQp3/7QOXFpzwj
         HOisDIxO/1P2i1MXa/7RX2TPofbsC5oE0pUZn6CMRojPhusWoFLX1qFcZNqn2Y+iNlxB
         912Nxb6kQ3KjmWBZsstwC/oISrGlDwMA97hxRRl4UwvTfKKqA9jzM8OSlem4Qk2CAFWZ
         27fH4f4PYeVnzGGwXs5NRWue/YTS7pTsndki1BGdUshikjrL8ebiUtODWIczfctz+pdf
         Us0a8hkiiFLQsSJVfaFCNk6JYUqU3KzykO4+eudKh/AAM7ZOVxe3OcyMxZGOGNsW2gW3
         z2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089577; x=1772694377;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wRNHYTQlLX9EerVe+YBMUcaaqn9OJCKpaOuanb3o058=;
        b=jqXuv71+/uqVu3kmYs0WzHEvIMG0m33y79xKBmdoBeUiKSdWCpO3PsHRgmLBIJVnDj
         VleYV/UXujdNwCWFgnc/fMFPIPSeZyrrFti+vX5DWBlQLk76eUAVzsKayb/l48gVsYyO
         0gfA8UAl4jNQ1FXmSles8KAjak11ZbpV4HRgB6yImZ8cP8bHtPgpqowOCoR0FA8jCSHv
         p6cjAKT+VuoFfZCYBMvzLUGVe4722lUaXOwly4IskW9jLMATI5qOF/qWM/dWjJtsfYVE
         2FsXZ8cEse7CwQ+JSR0vH7PhE/T++azhB8YIgzU9qhu627hRjskwn4Fvx+cY6N8FNbaN
         N78w==
X-Forwarded-Encrypted: i=1; AJvYcCWPLrmHCzuE08BXNW5AsCpbyhKd/fYiNvxqpDl124AHwxYolSzUB7vI3yuVbBqyxCYzJi3cz6al3w==@kvack.org
X-Gm-Message-State: AOJu0YyqYCQW23djEbDe7I1qcASl2QzJfLTVjc6hlXqMyqcgOkAmGrhv
	SZC5LZkv+1cfAkjW5FSJZ8EVsX0xnWSOZOh0TqKT++bSCmdfhPXimYs7P+dkeplNhb8=
X-Gm-Gg: ATEYQzyO1q//bA7Js5A8a4NCoiVRtjGrMpJEd3CfrhvOVOYm4kHZcW0FB8m/JVvL5JV
	G7vznZVw5cQ9dqwiHK4aOBlIsWpXGHdhLp8lcIiXRu04DKaEO9+BqMigkuB06v009JqJdPDGUnk
	fFGwwjn6gGgLFfgbAjVocxuMWVJOgwHb+2HjZ2xkuNeq/NBz8CFU6xiIca6JBXcKjUhNdPPDb+l
	STok/OiccmU5OX48Q36CL+fnCkCLoaWc4YKri47st45NT1fcwNyi5hAh01rZ/ZjdPAcONLZWYCL
	ALgYF3DSQSz6NGved5tkCaUACfx77Pm65lIuJozzl03+Qq81cQ+x5oW7MH2x1vyabvk5LEdDLix
	T1R4lSXEaFInHrCoxgdB74WX5tMfOj3mkgnvfF3YYtRUxn6AdR/FYtYFFzfTE4AMJMEy+I5RrlY
	5XoN+YoNyw73dYXVP2x0XWTpZ2UtdJFZAH8g==
X-Received: by 2002:a05:6000:250d:b0:436:30b0:759f with SMTP id ffacd0b85a97d-43997f341b1mr1907374f8f.27.1772089576879;
        Wed, 25 Feb 2026 23:06:16 -0800 (PST)
Received: from localhost (109-81-17-39.rct.o2.cz. [109.81.17.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43986aa2f84sm17021783f8f.7.2026.02.25.23.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:06:16 -0800 (PST)
Date: Thu, 26 Feb 2026 08:06:15 +0100
From: Michal Hocko <mhocko@suse.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZ_w51dnP27nFZxL@tiehlicka>
References: <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZzM_44L1vKzcOCy@pavilion.home>
 <aZ3ejedS7nE5mnva@tpad>
 <aZ9ugjKvb4U7_R93@pavilion.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ9ugjKvb4U7_R93@pavilion.home>
X-Stat-Signature: jk5dgmi4brxrpt1abi3ipudfhmr8hq78
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A73F51C0009
X-HE-Tag: 1772089578-348732
X-HE-Meta: U2FsdGVkX1+0X0Sf7p9ELQsQ5GbAVz3CTvCxNOI/EKRsVREWMLWD0b1Mx57HpkNXed4VXt0r/5NqX+8EPR3kckzBSgVI9THYl7tuGp8a/qzhbWY/o/BFlJT5B2RZVJSp7ZY+t0k2VtCAsI5wSBKfzKOnbqMxNBgbsjWpYfX859ECqAwZdufGtcaKuPf6hNXsa7gclBMPforgMUYVo+9PQWYjAjBTFOxlaZVIOPv+LCtmqBpghsSIJAdER7BPNq32CckUNAl7nDMjpU9U23EaqQZK1FMNc5NZqpWKF8SY6VIid01B8gLlL35LiB77NTs6L+uBbyczSP4X4E7lDXecggDksepRSVnfFD+WvXhOc7TKMClngqeEMVskkAz0z7McsIyCohs1AO8/Zc4cZM3i75M/FpH/u40z2rOMIUOQFyWAAh0QQRC+kUphv8kSFcFFjrsARwx18yRyCS/ReN3ePTWQFM2khS23Oc1NqUYW6udt5swkRVUQSWf3FD9DxT36iVyRkdKlRhgs8cJwEY71zyIt7imuWSNs56QXAQZDHFV+yV/FyZR5uLkQIr5YOxnL2TJonV4EsbTmpSO4brZ0F1qXjIVVwRKNYI6Wm81H6qtfKv285wSqMIbQyHfpe2T4QHhYtrUTIJJ013qBYp2l6OqA/uoqR1lX0eXML9v5CQZ4Q0NwHsyGZ8MI8Tw5w/ZSlAgTA1ue81FT3lriSDgZDxdHam8uucqeDf99QeO+zHX0GGZzvuNUVI3va/EpwT0p9kQazRVCDhEFQ1l8j+M9yZ1rxxqIjDVUZL2uL5rh0ONhhm4mXFFuEcUPj9RjSX5Op4NSfhke2116GQZDcRl1j4bMs65UHDrA9xzA5KJMQH/Zw1ri7rgZFDgqYvvSMK7rSPcQpNl4BveL3HJwf0OE0vlChuLWOYPQWBngXTwqQX6wFqNnlo/5lDk0V7+shqJMLVWdFbHptBMwoiT6MMb
 J5zN6Rr6
 ah4t5y809kW65HtXiHjZnXfVP3AeSZ2zB55j0LT9KxnoxC1x4+qqIsKyA5QxxLK/LvUcfimH1067OQ5QdY7n8aPL0wxV7jjoMF945G3ivYOiPE8fdOpwDeXwyWFQe4mEDW9hPKCmiVTIIcfBGDlRqpPY5r4peu45rqnr6WMTx37VZF455GOjuSqOGJf1e03DE0StxExUpBP8mvp71kgdkLFwT3KsHw+AQdKT4znGwbgFn0yeTQPNi+lOziXZdZMlXfCeRj29g//CmXtvagkvcCHjFqZsrDeYaPBYAu16eNv4jyQfZ2eNM1DFAzsrr5O4I5szEjucA0e2q6apq+vSUwgp9rmx0lXSis1EJEX/LittccLQyCEjRQ/XTkcZxeE/hL8NDuoWqTZxEbfNHj5AAeWs1IkVrYMrnOYryHxrF6QUFITaDxGHoWMFWMVCgsJfpuODJTYdCdUQZItAOWgyQF7s58a2gcjna+tYgSYrh6UWfthoEsWsGqwfc7ZPok/m7HH3PO7AmGbenhhm3RM/NkwSUzMm4fsYW6f1j7dYPbI+z/gd9GdtOq9mAIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-02-26 22:49:54, Frederic Weisbecker wrote:
> Le Tue, Feb 24, 2026 at 02:23:25PM -0300, Marcelo Tosatti a écrit :
> > On Mon, Feb 23, 2026 at 10:56:15PM +0100, Frederic Weisbecker wrote:
> > > Le Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko a écrit :
> > > > On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> > > > > Michal,
> > > > > 
> > > > > Again, i don't see how moving operations to happen at return to 
> > > > > kernel would help (assuming you are talking about 
> > > > > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> > > > 
> > > > Nope, I am not talking about IPIs, although those are an example of pcp
> > > > state as well. I am sorry I do not have a link handy, I am pretty sure
> > > > Frederic will have that. Another example, though, was vmstat flushes
> > > > that need to be pcp. There are many other examples.
> > > 
> > > Here it is:
> > > 
> > > https://lore.kernel.org/all/20250410152327.24504-1-frederic@kernel.org/
> > > 
> > > Thanks.
> > 
> > Frederic,
> > 
> > I think this is a valid solution, however on systems with many CPUs, in
> > nohz_full, performing system calls, can't there be significant increase
> > of lru_lock contention ? Consider 100+ CPUs performing many system calls
> > which add 1 or 2 folios to per-CPU LRU lists.
> 
> That's more a question for Michal or Vlastimil.

And practically speaking we would need to measure that on real workloads
to be sure. Keep in mind there is still batching going on. We just flush
the remaining of it on the way back to the userspace.

-- 
Michal Hocko
SUSE Labs

