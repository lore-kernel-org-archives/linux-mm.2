Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1800ACCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 07:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E238A8E0003; Fri,  7 Nov 2025 02:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4588E0002; Fri,  7 Nov 2025 02:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BB78E0003; Fri,  7 Nov 2025 02:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA5C38E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:18:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3932C13AABD
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:18:39 +0000 (UTC)
X-FDA: 84082958358.12.4A37CA5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BEA0120006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:18:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0foV2wBI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="4HhAeH/I";
	spf=pass (imf29.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762499917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heYXyy7Nh4RID45V94BklvzF7jWiD7JOdC5Cl12Mf4s=;
	b=4b67rCIdpg/7e92Iqmn6iG91foHuQgPGcqD1Bp2q0VGrrSmYrpFsR7F3jmD/5a90leXAJi
	hOpZh1qSVs1J0O+cIJVm8joXwnwRsJHg3/I3vrnMSRoECEshkC45BY6+8RgEkmFh6Lro3C
	zUeCFnc5sqDE+uVJur6KGxZKLLIooA8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0foV2wBI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="4HhAeH/I";
	spf=pass (imf29.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762499917; a=rsa-sha256;
	cv=none;
	b=YTXs36zOMuQNoUtWoxPREd1Bm6tZFe5iJUo5PToYjYNar6FMgW+ziApb4q2VGlP506lvoQ
	dw8k0WgOQg4uLsbu6kr4FJtrXmu5oyj2xSe//LD1GtH1ErF6GKhV4JWcXJcCE8bbY/pAvx
	4Lx7zJgK/NQSxpXmOF9uFRjTf2gkSag=
Date: Fri, 7 Nov 2025 08:18:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1762499914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=heYXyy7Nh4RID45V94BklvzF7jWiD7JOdC5Cl12Mf4s=;
	b=0foV2wBII5D5grA3Ma4Lt5FTDQyn8Ne53juxY4gS7aVgvVSZXUbiBlhKs90ZgrmRJ7M7Qg
	Z6G+38Hngk5eVpswngQf3nX1dzxhEFwEZxeVH8uRERcPiYFwsrXOqU2ZmaaWQgF0UkvpeF
	3plGMA4JWo5AWbvwSWW1L2F207ZETIJbh1z8DMdmcj1IOXNMWegkXDvnhsU6/H5gI29d2/
	HswQZ64w1tAajFso/zFtJOy6cV7bVF2jbBPoGMUUHE7m57a/DfEp+IUR4TsA37m8H+ultr
	DBIEAx7lSeJGWpH/hDOd8ONJs54WzX3OY25xpxC5vo2Nw7qihWXBwpthO02YNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1762499914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=heYXyy7Nh4RID45V94BklvzF7jWiD7JOdC5Cl12Mf4s=;
	b=4HhAeH/IM7xqCjhvO9k/AiYYQLJbrdErspxJFo0S3UZwapJog43P00CbuK4lrm4CnbPUYd
	1j0RSvVxRq8llyAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <20251107071832.Ty2LfTyY@linutronix.de>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQ1_f_6KPRZknUGS@harry>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BEA0120006
X-Stat-Signature: s3czqpf4i9tiw76w6e7easactiqngp8x
X-Rspam-User: 
X-HE-Tag: 1762499917-256376
X-HE-Meta: U2FsdGVkX1/hBcGv9DZZta+JA2djQwiJs+XPoHO9KEP+p7pIkz/qOxIxGdq9XF1IW+rfO/fRrerUlH6QWFCI/bFrb5qFAIXpq4chiVUgLhsV+c4JzkL9StPGxszftMN/EcJpbu+kF0ApHxiDjSWQGHhekCVkaKNMJmH/GEc6BDw83qkbjXpgNCfx8ZHPUwS72keUXu44GY+6PNed24/xyV0NZGP1mOS+PVHIhDMAWvXghxvGqLnXF8ia4WENaKP0TAtlcEFQPiTdTRgORvtwjY1Tk4+tU5R9/F9M3u3BN8IFRfDeHcocYsas/WT49BiABGpQjk4YATmJ0NQPnX5nllS3KvRRf9j2umcT18E6MvZbBOUFx8wSxqORDGkewGJxFdyRNUqR3+Kf0FFEi0MBwaNY1UFsb4jaaDVxF+UcwIME24fH3yEt09GG2+pS6uuajZ+FmxtVeHxHkNTOzDPHUfhz652zNjiwNVmOf3Ar7O09q0orQ3/GwQlxYKvgGf3gY2+Z1edca8ZjhwQ0hTnvkgHiN8YP+O95Oc9ML94xpnkfBgi+xQ0xoTUL7EHy4kbmwjWOmljnHFRn51KlxpxGMsu5UXIhdzQiSh6tLdrM0S1nv749Ay9MBj7cBLUBmi0fe+APOZ1KiJDxKm7uThcJf35Leau0HfiYo7OygGZa+LGaxLizGdNxm+J5R2c7et41nNFcSCL2zhvEEgY6ACUeGf0iZU1jo6suhoJbIs4kXIRxcM8MrhikAmTl3bPFOBe1ExOsgyokL+ZDg4kT06Bj4V36JKEk9DRHXsHIfjScjUBTYTmYTyTlAOCXC9SwWifDPNibK7fBToUmWOeTvnUt7bkO9IluUyQRtTs4h5YRjbDuCqzHjNjwfMYMsDIc/MVKmQERxC/9MqPoXKD3A9NbNgQnCsAN3r8K7H1QbNMhT0+Tze8M3QMoJBzmzjrABcSUkobnJ4VtZ4QCx3WNKf5
 CM8rFREN
 xiSM02WfEwhhxZgjW2wu2v5Jl5QW9R2ycjxXSx+Bhz+XWcBnWotgL9tVAn3+VbnkO2AZAMVFMHVu2H7yvWaftpZ/PFAqhKVuBW/517CNn9sTJB8CFk32/eSmtHk3P34aUo1lwqkrooz3z1nwvrIy/8+9qKAUiWU4bpxGJWiLdVukh4FuWfEe+ihnIUjcYZiaE/XDse9uIjzvsmmMHlhB70l26sRFslTekQvgSKhbThofQqZyJd4PODBm6Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-07 14:11:27 [+0900], Harry Yoo wrote:
> > @@ -4735,14 +4734,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> >  	}
> >  
> > -	spin_lock_irq(&lruvec->lru_lock);
> > -
> > -	move_folios_to_lru(lruvec, &list);
> > +	move_folios_to_lru(&list);
> >  
> > +	local_irq_disable();
> >  	walk = current->reclaim_state->mm_walk;
> >  	if (walk && walk->batched) {
> >  		walk->lruvec = lruvec;
> > +		spin_lock(&lruvec->lru_lock);
> >  		reset_batch_size(walk);
> > +		spin_unlock(&lruvec->lru_lock);
> >  	}
> 
> Cc'ing RT folks as they may not want to disable IRQ on PREEMPT_RT.

Thank you, this is not going to work. The local_irq_disable() shouldn't
be used.

> IIRC there has been some effort in MM to reduce the scope of
> IRQ-disabled section in MM when PREEMPT_RT config was added to the
> mainline. spin_lock_irq() doesn't disable IRQ on PREEMPT_RT.
Exactly.

Sebastian

