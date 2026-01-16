Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8DDC982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC1A6B00A2; Fri, 16 Jan 2026 10:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4266B00A3; Fri, 16 Jan 2026 10:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D176B00A4; Fri, 16 Jan 2026 10:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0CFD6B00A2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B747F138EA8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:12:24 +0000 (UTC)
X-FDA: 84338168208.15.F1C258A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id C20E8140008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:12:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BABgMMte;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768576343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jwwPm/+NByjfvPSjDi/ub7pXS4EPNaeT4AY2tDnSHI=;
	b=gXEAgB+zL0LBId+jBM+9h7A1LbgbFkeATZ9WYSm1iwMaoH+ZYkoOR7Dw0c9LUIyJxyZ6bF
	fz1df1+t/Ktxm2ozHfmAXs0qjL8LV76WmjUXWQASEFOF1C5Ys2udEe7mQrSpTbZfzukXDP
	C+FYKlI2KCztDbzHl9oB2UAoz+TAF5Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BABgMMte;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768576343; a=rsa-sha256;
	cv=none;
	b=0cnmt7ztgQnK50zHpHelIFKwwGSumaPSxKPIQ7X25ujujBq97C9jC7OaCx0UlrSvybbkKy
	6ymfXKY7k8CYa9Iv7VC2+/ykD1bp04smUGWvkgcDeR5nWtfklYEzncK64nqG+/eNY+ChR0
	WQEMSxCNb5N7iLmTjmVi3i1zypqGwhU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8jwwPm/+NByjfvPSjDi/ub7pXS4EPNaeT4AY2tDnSHI=; b=BABgMMteKKeUC8CZLqU8YLz6sJ
	gKuTkGksLV2DmzSP6lF43jBJ8USZk6Pi0rTcceIdMa8mmKHSVwGoS2Vn7tbRwj3kKizqiLyTRxvY+
	p1xY1o46P1n25HZMb4xw8chd18b+5RKuqZett5murO73BYEDTFUrW6srhbgF3yiXbwxg08KgsTZju
	t0Zn4qm8k3fjc+MTcdTagK6xbBefacu4xvdt8V3wpFaOYy02z2+HRGv2nOc9x7/q8eSjmIMwQu4iE
	GoSBFysx5Y46/NuY/mtY6lkqmME+uSDwqveV4iiZ84V0l6dohNmCMVdogZxBgxd6Rna6Hy7Qn+OV4
	LSFJrSww==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vglUm-00000009VzQ-3fYp;
	Fri, 16 Jan 2026 15:12:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E716B3005E5; Fri, 16 Jan 2026 16:12:15 +0100 (CET)
Date: Fri, 16 Jan 2026 16:12:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <20260116151215.GH831050@noisy.programming.kicks-ass.net>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: uekftwpm37wqndkgoo7oqmy9dzmdj6jh
X-Rspam-User: 
X-Rspamd-Queue-Id: C20E8140008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768576341-147552
X-HE-Meta: U2FsdGVkX19x9/6Jtglm4J/BETlwPdBxnoOZOI8dhWbt5K4QujAtcpe4C85T//6imD6irKXmBMNcNmoJyusviv6o4vk1uVMpiqqKlITxpLvg4aiudlJ2Cce0jLxtPX61HpVk7auNXS31P0w+wu0IiVa5aVh1ZgIMzGsENYGkoR85chPAsHVdWiDbqgAzSwNRIA3E63I8gloF0M33+RwukxBkr3VdrqYjjPQox5t706V8FKXtywincv/aQys2fRcztd2u6ji/hVv5QoNxSjegOdWJLODu1HK9k6vHdTNlXnjxceERJOSLC/x9kpqJL8WIww4DA3rY46845fN4h+2XigSC36YJmFAmuIRotoeKqXd4b8nnNKXk5amkSHnUcwKQo9NVWhbDkp9B9HyS6YFVB7n60018x3RkDCIMlapXsVFMeV5RIZ8KcSnoTSr6TjPcdKX3pqzN0rn1jp6VIQgTmtgnDfR6zjLa/2hEGRF1a0Ds7910ulUKn8zwNS3CiLi498Ay3tW0lITEyvniLq7/R/ozjpXaJh7W+hlkH1WxUxH6+D2aTSOvvrxEA4/WjmUfODSAzuTR+bi4OaWdc16F0u7VlFR+bEDruljL9PA+FOPMuuQd9qLxzfggx41xM39DtirLDZQ7rTTzXixEz0RqJsh0YyZyTHSzX4XafKxsFttjWRiWewICPjaAccYlFW2DLu7SET/iDlTbdOmUJbr8gPPsF4Fb1NRtFxfiYi7A4ZgG+6DTwjPZgVkBii5AVjxOu8Bfyh33kQ9dhAM4/OkluEAfCDWI0CvYAsap2iXpInSmj1AfVldmc0k9FjD/b3luNG/KAZzD36BdKQlIhADP5tVF2PuviDbHIYcePz9koWXUqIWFmh0gtKrOcrssu809ahFsgndsFzYgfzPrnMjawPhxZEE9re5FTS2bDeiBMBkechM9eY3sCZqi5LcvDhZ314bkPj5osg/s/3CnaPw
 iJpmRoYy
 UwPS6MlaSfy1fOdGsCooJ2UZfAnbi3VpfZm8PtzSkBKk3cVnG6W4kukDV5uuXvQg1kykDZjX4ea4HK87+jJHq2CZU8/MNFIzAJNz9JcLcgZ6Ukkfp6owsUSqI+Eyk2NZVthugFH8rj8TKbR87UB3SGFnT03pmbLxJ15oea/73xdxCKM9hPkkF/Q7S8kI/FwliNSBCParFBSMVTI7BVlg7cu1JZaIKCzwfHjihNIyNX10LbUY/jBb2CiRl7zePqw+syCMt0fD1FHrO3p6L/O9MgHJBsoJjHbeEE7YVoeBg/RjaTA4BV+9i2mDhSH4bbF/Oww7QQs2ufzY7vDH/sE6Mx/T7epVU6KL6f/Sg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 01:36:45PM +0000, Lorenzo Stoakes wrote:
> As part of adding some additional lock asserts in mm, we wish to be able to
> determine if a read/write semaphore is write-locked, so add
> rwsem_is_write_locked() to do the write-lock equivalent of
> rwsem_is_locked().
> 
> While we're here, update rwsem_assert_[write_]held_nolockdep() to utilise
> the rwsem_is_[write_]locked() helpers directly to reduce code duplication,
> and also update rwsem_is_locked() to take a const rwsem and return a
> boolean.

There is a long history of abuse of _is_locked() primitives. I don't
suppose you read the email thread that led to
rwsem_assert_held_*_nolockdep() by any chance?

