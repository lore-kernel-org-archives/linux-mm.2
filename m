Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9565D0E6C2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F0E6B002B; Tue, 25 Nov 2025 05:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FB76B007B; Tue, 25 Nov 2025 05:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F296F6B0088; Tue, 25 Nov 2025 05:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6AA6B002B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:42:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 934FE89984
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:42:48 +0000 (UTC)
X-FDA: 84148791216.19.FA4999F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A09F40006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:42:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wMFOmfV0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WY7EhNEv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K2FYgCgP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="J54rdR/m";
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764067366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsYspdjC0lpi9JmCQilKQweJ66sk4zl5eE8yE81CCRs=;
	b=ayz569gsYuL+usS10vrXC3PqnEsBXYES+VcJZxn//9Da8PTNYeMvj8Vhb62Fmpa5tahIC+
	+NkAvGqvalhFvNA0sCEMasLo1bAu+Hj/TVArkF0DxswzxlISa6PjWWdSXc3mPQapki/zDF
	llsNb8R8zKEyb31pspViMAsjNAIDoxc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wMFOmfV0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WY7EhNEv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K2FYgCgP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="J54rdR/m";
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764067366; a=rsa-sha256;
	cv=none;
	b=cLUTxlLflp6O8CZUc3mhVXGrpqXVkpEhBbB4xSRARNp0cPLNLKUmi6xqm5og/ssAHRqKN5
	bkSXmOhBQ9otVG9VKn6o4ZbyogDXHTJWpPgZWBjKMv7PKRsxG4qtZ5sO02bMCEkrLBJZWB
	RLhL1jkmOJrMHVtn2mcKEg3yYcXUoQw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F53922773;
	Tue, 25 Nov 2025 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsYspdjC0lpi9JmCQilKQweJ66sk4zl5eE8yE81CCRs=;
	b=wMFOmfV0+x/Yh7CMm56VlBlnQn/SjulBKf5Drv1UP5Br1KP+afi+VZLWXQNwZ/5GWjVvlV
	W7dVeKSaoC0KFbN8OKsJ+EtWQ7E02q7VMdMgz22hebAmIstXrQ7Nn0JU0Ti4/uVqJ4LEhg
	LHes/c62gT5AUJgvtMONKF5Uidj8YXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsYspdjC0lpi9JmCQilKQweJ66sk4zl5eE8yE81CCRs=;
	b=WY7EhNEvDwQkbNYSwBQmlI/iaBNtANR/gBR2OZQSTnZzxO2x3buhhuR/QBWLP9egatayXB
	yl1LcGujoc+KyZBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsYspdjC0lpi9JmCQilKQweJ66sk4zl5eE8yE81CCRs=;
	b=K2FYgCgPxSBYbK++lrRIDXKEC48MYnC2nSGgvwNpJgbuWEuFlH5kPY8z+amA/XrFIp7p7L
	WjA4NNTce1KibnEdhSifNyHcDZ/ckDBvTY/MlB8M7qB+Qv2f/f5YjPYOefaSQu7nCe13Vg
	VPuLPH6mxSnH211BBjqhxZncKmrDA60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsYspdjC0lpi9JmCQilKQweJ66sk4zl5eE8yE81CCRs=;
	b=J54rdR/mXqBTtJR/9i1hqqfUiUBOEZQvN2+kshns9Vlo3mnxux34iF9W5RzxDAv33orMgM
	SxvGtELkbp3/wNDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DED93EA63;
	Tue, 25 Nov 2025 10:42:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OAlUIx+IJWlpCQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Nov 2025 10:42:39 +0000
Date: Tue, 25 Nov 2025 10:42:37 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
Message-ID: <fs6mvtx5tla556t4bo4cex6i2pf4huvdzbfwymtckqh6ughd3h@yjjpeyko3kng>
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
 <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A09F40006
X-Stat-Signature: 6x5hwd1uxdongq8358wwa7gwjijs644u
X-Rspam-User: 
X-HE-Tag: 1764067366-668365
X-HE-Meta: U2FsdGVkX1/XAMlk2EaaenR4Xt08wdz2x8MLtOhOa3VbjvurKj3rbo1cLdntwSDWl6ve3Ob2SFzp22zWEciG/bkz1GxhEywa8t94nwSHV6EnfV9HfJub/4eHZq3j1aEnDj7TG7PcdrCNpXeMVvN93WxfMVEclxNZYVYwvzXIoOP/YHbEMpj6ZXHVHBPXmN+rUvp4gJTXrP+6hPyVKvKAgKPXGkfpRBG5sjyK4ynjDIc1+OlLehjFjZqr/Xa56PLVOZ0kh8V/bjyJxgvY+AuWqRIZm8UpqyShTdqsaUI3AU09Qw5V9Y2uHw8UcVzeYEGT7VxEZ/he3xbBEAzWZcXiX/eDVtJXu+7Q8L/Y0MpHTeZcOa2EZQDADEVmq/hfNI7Ft5GBXRb1mkPrD0SdzyOlkqidcIoLGC32/ANnVgQY8mFDyw3kn/DOK8EiAYrxxMG40hrCjqUc+7Gxs7bPK2TrsMnIV8zuoUu01rVpypJAOA9hJn5KQs5D7WbzMRAcaqezm+gwXMfgnlHarOvgsLCIJxfqC+NtyLntKyIhyCJrc2yOXOG3URyOEdlgIltOLSZdiU01kMKaE2i5+tNouTV4RrmFbFcU0zdRqSKZu3es3HRkQacBrwv99MCi1vX+w+TGJ8LCqOwTe6curEmP5njQtlml5sI3K/5MClFDPz0iDqpSpj7q9zT9sceQeWEUbYWXkhbE2VKaWSuIxhm/mUI4nC7Aw9mIfPAeto17yp4kM3Ks8rOdJf18nQGGw7HHoqmS+HiGqoeyD+UBONXs9atRtO59rLNlVTBxmWJg2ge49BhYjhzdrPTfDnqT9Ah1asUDh9I/+nHcrdb4Rhrci7X2+TW+JnPhIeBafugj/mRubX+Smt92IZVcI6aojSu40JqiPiYIF1WK01MNzsmy9w0WjJDOSVG8lubkU/DoMQ9KjWLv/0igdXjCJaY+QMYBo/NiqxOt1Z31RrrNhn/OKwJ
 K1mRRV/L
 zSY16p+l3Rhlh54AJv9zPzu57fo/ppP/J59w2oi5GD4y7eJXz0Oc7LYtVG6btrrq78E1s9x2+i9/7ja8ctTHfX9MDyLZKR1g6J46YzuuNSIBPro71vhVpKav7nKMFPaBgHIpQ1YRD0p5PirCWU54s9BKDlaLl8Skr53alefClwfk68qcDzygOFBy7HVYJWtcPyROBwuR/xxMBLSClRyb7U3nV3j0g+58lQLF12Lt/Iley8xyaqnL9HLZIvKvpFbyfD0IYRqyXbY3/b0xknsHW/x6jvcsSmI3O4FIjl1tT6b8RbPGRU6SLjrGjVVCkaSZ/+W8jUYQgGouVCaIb84paz97tkafO3UaruFUJTg/K5vguskQTtk6IZSWIfdLW4qTYT5akMUpwCedy2uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:00:59AM +0000, Lorenzo Stoakes wrote:
> In order to lay the groundwork for VMA flags being a bitmap rather than a
> system word in size, we need to be able to consistently refer to VMA flags
> by bit number rather than value.
> 
> Take this opportunity to do so in an enum which we which is additionally
> useful for tooling to extract metadata from.
> 
> This additionally makes it very clear which bits are being used for what at
> a glance.
> 
> We use the VMA_ prefix for the bit values as it is logical to do so since
> these reference VMAs. We consistently suffix with _BIT to make it clear
> what the values refer to.
> 
> We declare bit values even when the flags that use them would not be
> enabled by config options as this is simply clearer and clearly defines
> what bit numbers are used for what, at no additional cost.
> 
> We declare a sparse-bitwise type vma_flag_t which ensures that users can't
> pass around invalid VMA flags by accident and prepares for future work
> towards VMA flags being a bitmap where we want to ensure bit values are
> type safe.
> 
> To make life easier, we declare some macro helpers - DECLARE_VMA_BIT()
> allows us to avoid duplication in the enum bit number declarations (and
> maintaining the sparse __bitwise attribute), and INIT_VM_FLAG() is used to
> assist with declaration of flags.
> 
> Unfortunately we can't declare both in the enum, as we run into issue with
> logic in the kernel requiring that flags are preprocessor definitions, and
> additionally we cannot have a macro which declares another macro so we must
> define each flag macro directly.
> 
> Additionally, update the VMA userland testing vma_internal.h header to
> include these changes.
> 
> We also have to fix the parameters to the vma_flag_*_atomic() functions
> since VMA_MAYBE_GUARD_BIT is now of type vma_flag_t and sparse will
> complain otherwise.
> 
> We have to update some rather silly if-deffery found in mm/task_mmu.c which
> would otherwise break.
> 
> Finally, we update the rust binding helper as now it cannot auto-detect the
> flags at all.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Scary but cromulent-looking. Thanks :)

--
Pedro

