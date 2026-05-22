Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8978BCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86456B0095; Fri, 22 May 2026 04:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35CF6B0096; Fri, 22 May 2026 04:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B3F6B0098; Fri, 22 May 2026 04:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3D8A6B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:17:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BE4EC2B57
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:17:41 +0000 (UTC)
X-FDA: 84794351922.14.DBAA209
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8C9848000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+0l5dv3;
	spf=pass (imf30.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yY/E6ZSKFGdQK7pRAN259rZ8xF0VVM9mz8KaW6BbCBw=;
	b=bBtGy8b44+VUDiaTErWVEwjbrnxnETkPr+fStEcy6GY/+8qqfBfZTieLtAatmVtkDLtxFZ
	zcU5+P2L5Y4DNIih7fRvIigCUnCRGlBL9SR9ClNCQcAu1JoK5XyLIaTWJ1KgYwCRKOUSyS
	xcszAxnwGE7+hwyL9C3klLDUpIpJcBw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+0l5dv3;
	spf=pass (imf30.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437859; a=rsa-sha256;
	cv=none;
	b=ZHTWUFqKRUyvMhPWzJCoaary2Y47F/NGANLQ7Mj+OkOVS++lwtmK6LkgkKYU8kXr3V1zbZ
	0035Sh5un9eGbsvwXryJTK9kJLQMqW3vjgVRN1c44LAnHMDtB8Nbr1g9BkC+XYZ2F2th/O
	rWv9Nloud4UBvvXobDOzA7ENZWcxG1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22DE46014B;
	Fri, 22 May 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C852B1F000E9;
	Fri, 22 May 2026 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779437858;
	bh=yY/E6ZSKFGdQK7pRAN259rZ8xF0VVM9mz8KaW6BbCBw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X+0l5dv36uk9ZRyNgw5bYC2gHHMUvNT6ww7QJw63eSLMk0rDLJLyO5JnBIM74YZ/A
	 E/WoPRvdiy//iXbapkurl8y+WmcA4JOPr2qxgU0VxBzHu8/T6m3I6ZTBWDgAyIIoxs
	 ReUbEYbJ90zc+g+Qn9aqxBW6HAp2twsXazOCdbmtTVl83RW14RFJMcdFxIDY4b4fKi
	 YUV7Kt3Ti0JnsMVhSw/DVYia1qqIlklHvizoRfY4rae1a+PU49srruqRg2Fnk8uB9t
	 0BvfkmC6bJIkM2DXlY5ACBjzidvIVgfSDKz8PaiuQVSEu2UxpXxBpbuhi8iEvKNjG9
	 2uy4/hfEUBg/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wQL4a-000000058pm-17h3;
	Fri, 22 May 2026 08:17:36 +0000
Date: Fri, 22 May 2026 09:17:35 +0100
Message-ID: <861pf3x3hc.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] irqchip/gic-v3-its: Use GFP_ATOMIC_RT gfp flag in allocate_vpe_l1_table()
In-Reply-To: <20260520204628.933654-2-longman@redhat.com>
References: <20260520204628.933654-1-longman@redhat.com>
	<20260520204628.933654-2-longman@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: longman@redhat.com, tglx@linutronix.de, bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Stat-Signature: m318pt8r5tn5kzaq9m8dssnyy8t1jhub
X-Rspamd-Queue-Id: 8C9848000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779437859-194947
X-HE-Meta: U2FsdGVkX1/L0HAMI6oMVCqlfnSJkIDt7OKuJYcDDz/gYLZJQEtD3UDc46NSoeBGClVw9K2qoiRnUE4CINXSRSTOC5Cyn2ec9z08p21gYFGU4tM/4dRcy5ofg46qZqSbLEyw5bFQ4NnQ3LgVC573raWgGnuSOvYKdb0tb+pOKwm2Y9Rb9/kJnLBctt341baGjYt9SC5JEEukKp/kJk1tYBtu8Iza+UFRRSyhbIdtJPZIsR//qEYZ8yDl+tWbBLs0kV6HD6UU6mWjbrNK0z2LSuJAmgenJxkkMS68QiESRgP6M40cVrizb2PtO9gY4tT4Us1aUztEWcJ5RYIrwkMdG1oYxNsxB/wExIjIFkF0mMw1giVa4jHAghLaDNuNX/+oDk7vSqIYIx+4+Mh648mFHSgSBhmoc4GgtnqffIehB8ngpJQ2z5AEVB8tPyKn5RMVfeqklTv9BrBwaDgExbAZig3nfLrXRNuGg/WSzS6NDfLSwE3gNr6JJVlw5fgPDcNqtweuOioOIT0zo5kRQ590Cr9rFap0sH0GGZMp4g+E++FMzR/r2CDawFdZ4+oEiZadPZ/PMj7MTOWMexE25fjAGxkltkuY+WGW0vDoCqxUnoLyfSmzG0zdJKnxqWG8fQnJ4eLFIe8DVtt/TMkSu/jvUySNPPAm3dd03uOQvwp5rlkvl3/jLJN6/P9r9FK3GWywHXtt/X/7vnTtPcQHmHxC6xAsJxELmr3hOdDy89Quwgha4UcVGxAolD6tokcyaWYfaf/zxVQDQ0e6mK9M+Q8Lkm2Su3NK26osSimPlDSnhfpuZIsyg2pECO5skmr8q6cPBHZAMqp9FvKu1OOl3carFiyw8DPKY21qdWSo38j66Idyi+d5cyMaIn7nC+79YTfz8iOaCwIAs4V1uY9xQLfctc8ku4zfjPWFn4+1gAZslnoIZTLuapNJOvBuyx+9ZfSRl5Czo+SfIPPu0XHBLYm
 CH9xkY6k
 +OeAldt9PLjxIvZi4D2/Xxcgz0pxGLxeP5zBlOn1Wy0ISgGOPZXk9Q7nbVgnAnG89GG06sF3OI3XpG9PCKxgRbeoOzyWBJclv3c2FN51fwfrms9AvlAEkbTcC3yajJOY8rU11onwM3XdOr1fzZ8Rxv1+lW2KaPq4sCWUMLoTPx2ovcXjCTT7ExLR1vtVD66eqc+qw1QrWaRmjXacwKN97+3hC1Fi/WzKE0meElodq4KkkXW9CaTZCUwJy8MimigefvN2oo9mitYfVhgww3GvnSW/TUgxMthPVksPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 21:46:28 +0100,
Waiman Long <longman@redhat.com> wrote:
> 
> A longer term solution is to defer the allocation to a later stage of the
> hotplug pipeline where interrupt isn't disabled.

And that's what needs doing. Not papering over this in a bizarre way.
I proposed a potential solution a few months back, but didn't get a
chance to work on it. If you have the bandwidth, that's the way to go.

But papering over this issue this way seems like a bad case of short
term and unsustainable hack.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

