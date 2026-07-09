Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F576C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEAB16B0088; Thu,  9 Jul 2026 08:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74306B008A; Thu,  9 Jul 2026 08:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3BF06B008C; Thu,  9 Jul 2026 08:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92EA06B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:06:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 038C6120134
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:06:38 +0000 (UTC)
X-FDA: 84969111318.30.A9E6B62
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06EDB140006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:06:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BPV8+lAg;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783598797;
	b=TcJBPSquK61+j9ynX94dfTgzRrftV4xF0AH3R4yEXdYXXLgz5f/aCdLoNB5YJqa3IWHPTz
	POt07EIrugaAQyRXWw/s7hSqymnJoU7y3Ub8JY6mqRmWt9FyTEGCxfSiQrI8KvvSjDnbKj
	7cwxBCQYnlDog4pfxVMo7rP150CH4vc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BPV8+lAg;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783598797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJCJDiZFMnEXRuWNVK0tV4OPx1m/p/2vz2kgTU12GDk=;
	b=EDn5+5BqPBxRf3ETl8UJwKjnwBNSHO2o9UhrQjK91CjwHh0/UHyXsLZS9C7cyby9WzmHV3
	15gi4IW6LTqIp9uXQSzXt6BR6gNrAO9NiUlhQ7jjPazbw3RfwpohJnHoIi8ZTLmNpxxpyw
	FjLgPz97no6Z+jWzeu80smUPfUkuOC4=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso956323f8f.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 05:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783598795; x=1784203595; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mJCJDiZFMnEXRuWNVK0tV4OPx1m/p/2vz2kgTU12GDk=;
        b=BPV8+lAgo7Cu9Y+xaIrVt0uUsX6WIgAwQp4tYybzqXGqnp/xvbx9zmhIUpxgGSFJmf
         my2ZUAo+zb1pLSovZSrEGaxkwGeCKT7DiqN5cvdVsMb44xJmyBxNJTg5lvL3yoiCgpdl
         s8gaX/t9ZzTVRZfC8HZS242qj20rfGtZ76nnsW9W2t2nDacefyQgZVLNVTcjyVwKfOPC
         9j93S2juzu1FO1Y/YoenSzk7hm9yIdsy3FXCVmg9Gu/r3klI4vEg3sxQozJcT3wXVaTW
         GJwPAGIL9SeKKdj0z7XlgY38BUTSb/+r3Ocww3+ZJgzsQMuoqpdnwZhOyUxTYGB83wrE
         onCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783598795; x=1784203595;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mJCJDiZFMnEXRuWNVK0tV4OPx1m/p/2vz2kgTU12GDk=;
        b=SxVhJTUAd2rKcpesgqaXqys5qxQPTZfThqvAhpbjGXNMz/BB+EsDIlzQ98tBAmM4bb
         4Pd60+tIHetywBF3Q6zor5eW5oETUNkUoRyJnU97hB/0Clus4772R9vCZwULu/DWAcZk
         GNZF+r3lEcOmf+QJo8yYDh/S4XYgC8Wncnve8ejhfd2MVjPvcFVlHobYblzCxa2hXLRU
         pxSdL3ZacSsjQtQvW3kPKFdmUrQll3mqeBdqt3VodWd42TI6zDAr6M7ubXtpl01HnfZ3
         dqag76iSAQQ+GenQH0GV+98DA7EI3k8YUcerMCjqiQBTfzQG5fXRkPcrEIMz2ZJ++Itc
         nU8w==
X-Forwarded-Encrypted: i=1; AHgh+RrrK9nEWopnou0Iw8fbDMnN2LXaSxKdaG3yhG9uusbNqIfWTZ8P9jKgWBMiEsBatgyQp66SpG9V8Q==@kvack.org
X-Gm-Message-State: AOJu0YxFkrNQYC6R/O8kItEN9ymSDxs2ezAizle0uZPbHcF39EO4L1nB
	F6GaImeFvrUaf8KSm3Z0NhgIZPL1FAOWYq7W1xikyLXDQz4Ji+xkZ3tBbfj8mO1Ey7g=
X-Gm-Gg: AfdE7cm47LL08Mhgmk93NtJZaXeDjou9EbEiXvJ0AEuUxgTfhdXLjtVRxni+ml+A9sB
	o2RbwYRBg78gpGfP+ea4usrm19imL2/Go2HuzEjqSxBZ84NvY0NvOWDvprtqxOkSOR6UMyJBeVe
	4FRbzYzeSadsppdACYBnsbMIHmnXG3DhaxRcuVJc8dUwvbDvfqIlU6F6RAGE3eo4Me4uGisWSap
	zbeEQu6ZXz1roJ7JLPqcqoNGnxqf3CbKOnzsNl5IMYXmXFfIXopJF6SdNbcJKsEWuioTruY0YOy
	iTM2Lk3kziqq7L/gBJrQjAItU7ok6rrFk+R91zhtZWbSvR/hHPlyGStjy5zUK3xVh7m0HrG9hZU
	MHQ6L2meH3Dm8UP9yaXdoy5uGgoKaAhO6vTQypt8TX+kDCTH5FTw/ve6fAaQTWW4rBq9UFMurWB
	rbnY3XSghTroG+WMAhvUEa5iw=
X-Received: by 2002:a05:6000:4b1d:b0:47d:ee7a:9306 with SMTP id ffacd0b85a97d-47df08251f6mr7580011f8f.61.1783598795451;
        Thu, 09 Jul 2026 05:06:35 -0700 (PDT)
Received: from localhost (109-81-22-50.rct.o2.cz. [109.81.22.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d780csm51623987f8f.11.2026.07.09.05.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 05:06:34 -0700 (PDT)
Date: Thu, 9 Jul 2026 14:06:32 +0200
From: Michal Hocko <mhocko@suse.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <ak-OyACkE8lLaRRS@tiehlicka>
References: <ak5-qwmpXrYi5md6@linux.dev>
 <20260709072231.3163082-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260709072231.3163082-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06EDB140006
X-Stat-Signature: 9mrag1ioswgpcpmh9cot7s18snqyfu7s
X-HE-Tag: 1783598796-848090
X-HE-Meta: U2FsdGVkX19htHcSAkV6iyGiR+V4Maf84YPK9CRQDDwY9Xw7oe4Wh+KCzPXnNSK0EUJx0fN7gGm4RthUjq1plrj2XduQ6he0gUmt4fQQWXVQNVowniRdaiZuSKj4lBrUvNF+Fa/VU2N+gQxywtK2zSNBRl5kgCw1nAWyrV7yDbQWxymf7O28n6KmmDyk5Iey2l+wbMJYpoouwMp7xItuLZJyq1NiHHis8z4cTCmVe+xyMwWF1Q4bTQY19Q/Isvywoc84x/ao0jaiI/JGmGLKEm+freONhtm99IY4MhK+jCAoe8SdjrU4V7dLxKgVBq30iVn891FgullWDyf1AdmU+QSgcAb5URtcqFbEZKx1UZTMD/cDESEE64rbYOfj+dTG0vP5+yIyX63dmEi5cb4jWllXCqAWb9qekyQctOCQlVceWLUR6B+YZ+rNE6l3gG/dEBllHFE6h3Jgd5YTN6GMV6YV0RWxcIr/7QnO8zmI6fgYGeATKUdWEh5o8T7Sr3EmBE0MLHgQXq7QeIE/HUrp5vyOBpjhmxyH8khZc9dAzB97WuT+kQMiz1GZBLbbiQgFOioyTWLlWrqv+p2DtFAiQh9iLeb27OzZhdZAErEqP7JzP5WxvYpEo6/12neBfvnE8k4n34mEt9PygAKSG+0mIa5FsTq6rdB4Cce0yHHqgdA/oFToHSA2RYJ57YIw8rPOOJmcg043+3kJTiiOGwaLJVbQMCr38ya1W8Mf+5P567/CSGFetKllOvZRckrE6fdovqjKs7yQeIdjCyXfOEG84hjDMFb15C5JFgiE/cat2XZAC4UmHN3iC2/yDug3+sa8VZVclAJkY9WigUYGCWqwaPz2/M/qWDKP3Zh3uHFwaHs15bLU11g8cbvb4AqGzGx2xeyNQmbbkR1XpS1PaScncBxgzz105IbASkqJkxJZw5/tkVgdzEr8ljBPonE7Ji44qkn8wAD69lfOUgst1kz
 eSdPEF54
 zd7QmHc+yJViso/wKquAoGfSR04osyOJ9DgfaStYTbjmtPj2IjLdp7FOyzlhbhD+UcRfRkFTvVlu+FFAetq1wmYqprCmG7RkydmShh645RYULINcI3EMxPBDo0wCx9+fNVs+HdyBjT7qTdayeAY3XRP8xIu/kAo3RcnauDbFp8TStd4+Mzm5PEh+ZQvDc30etAhveG1GV7lBjMAFeRCHqXqp1AYEXkMK4HIiTxpnrLMbxc07vGzdw3YZ9cNxXpWP2CQP1JTCwujtjJezE8/nghae51HSZUlzOP8Be6vxj+QV/deACM7CETstWxyjtphoBontRRsjOjvgq+KT4bF6MgE2qYWbP2rUogdkEF3cGLxpGQsdUxxIvl0sro6ANgcTERwbfOrurxptdKQpqboFyBudv1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-07-26 07:22:31, Richard Chang wrote:
> Proactive reclaim (triggered via memory.reclaim or node sysfs)
> checks for pending signals in its outer loop in
> user_proactive_reclaim(). However, the inner reclaim
> loops—specifically scanning cgroups in shrink_many() and
> evicting/aging folios in try_to_shrink_lruvec()—can run for a long
> time before returning to the outer loop, especially on systems with
> many cgroups or large memory sizes.
> 
> During system suspend, the PM freezer attempts to freeze all the tasks
> by sending signals. Because the inner loops do not check for pending
> signals, the proactive reclaim task can remain stuck in kernel space
> for seconds, failing to enter the refrigerator in a timely manner. This
> leads to suspend failures due to freeze timeouts, a behavior observed
> on Android devices.
> 
> This latency issue is specific to proactive reclaim because of its
> large, user-defined reclaim targets (could be gigabytes). Since commit
> 287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
> proactive reclaim uses larger decaying batch sizes (starting at 1/4
> of the remaining target) to maintain throughput. This keeps the task
> in the reclaim loop with a large target for a single syscall
> invocation. In contrast, reactive reclaim (global/memcg) has small
> targets (SWAP_CLUSTER_MAX, typically 32 pages), allowing to yield or
> check signals between attempts quickly.
> 
> To fix this, add a signal_pending() check to should_abort_scan() for
> proactive reclaim paths. Since should_abort_scan() is called within
> the inner scanning and eviction loops, this allows proactive reclaim to
> abort early and return to the outer loop, ensuring the task can enter
> the refrigerator and allow suspend to proceed.
> 
> The check is limited to proactive reclaim (sc->proactive) to avoid
> affecting reactive reclaim paths, and wrapped in unlikely() as it
> is a slow path.

The changelog doesn't explain whether this is MGRLU specific problem as
the fix is MGRLU specific AFAICS.

Also do I get it right that freezing a task while doing the pro-active
reclaim will force EINTR early return even if no real signal was
delivered to the task?

> Signed-off-by: Richard Chang <richardycc@google.com>
> ---
> v2: Update the commit message
> 
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..fb472e924fc7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> +	if (unlikely(sc->proactive && signal_pending(current)))
> +		return true;
> +
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> -- 
> 2.55.0.795.g602f6c329a-goog

-- 
Michal Hocko
SUSE Labs

