Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47AD6CA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 21:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F6B6B0088; Wed, 30 Sep 2026 17:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0D66B008A; Wed, 30 Sep 2026 17:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF596B008C; Wed, 30 Sep 2026 17:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DABFA6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:26:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEBF3A60E5
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:26:07 +0000 (UTC)
X-FDA: 85271711574.26.5875849
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf31.hostedemail.com (Postfix) with ESMTP id 26E2420003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:26:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R1LHplEw;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790803566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NcEBo2bS8P+fcdvedqvJ3Az2pTigqmXIzaSqCZiwQc=;
	b=r+JIdcF/l+EJHKPw1HC/fL791JzJXIvOf97rWLgTiv5JruGmDgXVqKPxEBmN5e6r+Iqt0i
	2CYa/a2j+tIHmz5UwYsDCTh6EOSCfLT47TCm93AQlm6xaiWtiDKU+paS5LYATenys9JwHY
	HrUADvvnlWuAGgmNoR65SHoE8IdoK+o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R1LHplEw;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790803566;
	b=nl00uy972SNDL3gwr70nn5/k51Vsug99yi9PBU8q7yreLunKzkh9R/7IjYQiTrH8GAtwKh
	dbkZFNBHjhBXD0sTqld1/fevNH6LQVDBVMaEB4YjFTOx588g2jJ7AIGBtJix7Il0vM1ZcX
	jQ/O49SY3sMu6B3zE1/s5GPrRxbSKOU=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a00d8bec5aso15420305e9.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790803564; x=1791408364; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6NcEBo2bS8P+fcdvedqvJ3Az2pTigqmXIzaSqCZiwQc=;
        b=R1LHplEwzRSYfQkmroNXTnHZ5nQqGzF5nVbU5GuzYPBvB2BP7ehvmqWDjfV78iQR3v
         SiqUThycH7Za9gHJAEWGF83riRbQ42xuXATIsOBI5AJp93udPeo2xFe3pmTifbImM8EH
         UbZidPguHDjdu9yTHs0tbNQaHacG3WMTiX5PpziRXWPUtgLuqWpvliC0abpHKBQy2fUc
         3JCmJm8VBhVnB93nDb/2y4ZoJvLpfIWm3Q0nBBXSg556iLLR8AcEDihcyPoGB/sGutiT
         iNE4fcPSJxghaRQeJUHxuqncwQbThKHbFWScrQSW+ZF1eGbMZc9XbaHNyjriwhSX7ZNI
         fzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790803564; x=1791408364;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6NcEBo2bS8P+fcdvedqvJ3Az2pTigqmXIzaSqCZiwQc=;
        b=TZ0y5FKTLeXABIlbo2lyLh4TRfLmN860B5/V9lpEKqbomUs/+7asGN91la+/JdeArQ
         rDPuPGFP4qIcbB5ONI1jUmy7EsbiZMabyyPCNQVKWFKbpnvuPWygEPMfidmvtaOOGR9F
         CxISCHufYkE1hz285JkT8sDlbygIFTdtSbMl7R8b+KgFJ61vCS069tDLQdToJFS8VfX6
         d4kevqCvKNM95WZcK0DwADNlGz53drLgrDmAUz7cmcTeuMy4c4PxOTtPh/GH8Q4ShxYQ
         Cvdrpv3EUuMkSqKsREzZ8uGWAI/x/NFHKgfk1Lp70VI10BB8hzj79LRLvr45ITIVMrqe
         xrdQ==
X-Forwarded-Encrypted: i=1; AKwUvByh/IHSPglJ5XGzxPVBjJUKr0EjtML60Y7fqgkvQ10MjHB3XBmS7FzRpPMRHQY3VjGjePAr5BLHfQ==@kvack.org
X-Gm-Message-State: AFq9FYJ4cNCp5mqfpwW0Me1QPSUvArqVyfvs/9NZ+MmuzaG3gNsUOK9J
	/JOAfGzKSmTRlbnk/edyCalhJpQEO6eqaOeA/EB3obrRJr7N97ndfB3e
X-Gm-Gg: AYBFou3VUUurzt6v/5RPFDJJCRMtLAvz8GB23wkn7OzdfSKgoiPlS+Rp68f6/+uA4o0
	Wl9zAYIze1jFDLUcL+3UcQYyhNYy/5wTTmSB7TNU98drulDmlaDL5gv7N3OFL9iwGB5Yn/71jkv
	b+aaApTwWvkh03t+JwG65z/ngosPeP/XzjaM3ePM5e13tvu0rK3aQ9wodcV6qWTadss5bLLwDUJ
	G3gRinlISo0RoBhmqX12ZntRCNlYSfGwlYyaNjqaAMEl8Go51TLA9SgY67mk37SivnYJDyCfHS5
	fMCzBci0HzoFnk/6TNu7kHbIXsl9L5iIMqv0RJk1fKxI4Fxb8APD0IEMAGF5SZ4P9AQ0CSYOfaG
	vC4QtuZqoxgJIda1NaMNn0qDe0PJjaXd/DSnsflfJDSNoV5FY5eBTBhAd4xY83aCmWtXmuXhzx2
	EIO6XNg4cURewaVA/ZgKQniLuSTqYhjbnXVFR3nEyjN++QX1qFlVgN+fbq20Q=
X-Received: by 2002:a05:6000:40ca:b0:488:6561:b324 with SMTP id ffacd0b85a97d-48b024dc409mr4686934f8f.9.1790803564433;
        Wed, 30 Sep 2026 14:26:04 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b068bd8c9sm1825610f8f.2.2026.09.30.14.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 14:26:04 -0700 (PDT)
Date: Wed, 30 Sep 2026 23:26:01 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Message-ID: <ar153_VaZlIY3qeQ@gmail.com>
References: <20260930195110.13296-1-kaloz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930195110.13296-1-kaloz@kernel.org>
X-Stat-Signature: 38mee5bknq963tugsqhkgng4ewq6zfdz
X-Rspamd-Queue-Id: 26E2420003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790803565-807557
X-HE-Meta: U2FsdGVkX18nEWODEI7mHELT8WbcMs8rrYEw9JFiKdafuQfGt2hq201KEqjImeHthiBVqjBTktd4f5zKSbq9f06UB0fGDb7cbvrb78FGU55RdKPQNRpI1H6DXZ88DWN8tg4VzkrihC4yRNJGwDn8PhjSVhjUiPFjUp42dCWHvIdisSgFz3zhO94tS5iriC+rTrUFK8siVSLZx5uV96p4rG3md19xikpjODhAA3Drc27u9/VZ/Dpff8tYxA9D5/sxy+lzfO557QhmntL+KOd1gQ3u38WN9KzFDx1GKhTmIc4SbxNEoTtQm+e0Ho3huj2JKO8dLNHRxDTQYEHiZ6GO0s4gyO1ubzveauYDzIWypQTH3jTPHM5sYljHz/kS4LwXBlthbymJGeYYCOBvgv5pCW+/mjuHP3H2TppGiwfGTBeP1GUEaFkQgg+uk3iDRqeY47lFTPAlhDxnbgWO0cY8NQvlT4w1MlUNBEUXDVrZrhwMFNIvXzK5LfqEnch3RI4zpD6EssQyiI5gznHmly65BwrTDX5d/VA2xEew6LyBdqFgZfFF73t6faxMS9HwbCaB5GHlTAFGICtMjHHDqXkOpsTmiNXNLlUO3A0R8aPBLiF7pN9QraArczlaJA1CxF/LkPxE7GIgHvrujJvNd3tD/wla7O2uz//uQqoBOEGJbXZPFsbTiH/vSR3KjF6hGFP3A6Xtsm5boncOpQ6LqEoz8nyJf28CAyX2TnyGbfupE6xB9WaBl1QUUc57n4UwHdm2ahkiGy1aa28CJmUN7QIH1oXOrr1Oi64qQKFJySFmJFjZWgBkT4b9gNHPTUu6uXDproekMCnng1qYAmq4lvUSIcc/Z/7+J2EumdGq1pZh+Rby6HBp0lxNoBn0d4LxXDTUNy3hnVqaSTRhIQauKqtqUsj7sZ5S5yiCRqxXaCGkBKhm5kl3IY87lARapIU0xqBFm2rV0lQCmyJ0sL+6ZTT
 gcpbJlRf
 jsaNrwRECTEmWL+0eEoWVUq3By5iIT5ZATPCMAPiyLjaZsG8TSdPfvdKRNQbtwZU6leTtc7eJ6W74xCmj/f3J10IXeiYoFhWhU38ErhMfJl6jq9BeHBTPPxA/uhv5n17+VY9KER6v/M+Bio1k4xoP/UkUNNFXAi7YHFYanoF3UvGgQ6yeQiCImwcJHZSloF50FiYrAcqk6TE77P2MCrYXKOGclhU+669jkEyTW8PP340CHp5IPrwhiFEm84EOGy6CELm1+lBPImMrWYUlDzGnpS5F+slEwsHALM1hkCG4oVnUggLQTSfqf7ls/yUR0L3s3U8fi4poIegrOYiIaHp2I7MxeQDfVwL8mXuA9PJEupl/r992jhiOYg7Td/6cnRjS8viGYyWFp5J+vx79OqaEizVS8HuBRe3G6es8pX3y8FB0bEFZL02mi1hF9UyQciLjhB7vRbnwskoiivoZc3GRw9UITVpw3ppZTTHWXdssAn5ypLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 09:51:09PM +0200, Imre Kaloz wrote:
> kmem_cache_destroy() tests slab_state >= FULL for sysfs_slab_unlink()
> and again in kmem_cache_release() for sysfs_slab_release(), with the
> cache already off slab_caches in between. If slab_late_init() runs in
> that gap it sets slab_state to FULL but never calls sysfs_slab_add() for
> the unlinked cache, so kmem_cache_release() ends up in kobject_put() on
> a kobject that was never initialized:
>
>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>   refcount_t: underflow; use-after-free.
>   kobject_put+0x64/0x2c0
>   sysfs_slab_release+0xc/0x20
>   kmem_cache_destroy+0x104/0x1e0
>   bioset_exit+0x13c/0x1e0
>   disk_release+0x54/0x140
>   put_disk+0x18/0x40
>   floppy_async_init+0xbec/0xd10
>
> Seen on sparc64 at boot, where the asynchronous floppy init tears down
> its bio slab while the late initcalls are running.
>
> Read slab_state once, under slab_mutex which slab_late_init() holds when
> it sets FULL, and use the result for both the unlink and the release.
> The kobject flags (state_initialized, state_in_sysfs) were considered as
> the key instead, but slab_state is what cache creation and
> slab_late_init() decide on.

the enum has nothing between UP and FULL, and the create path skips
sysfs_slab_add() while slab_state <= UP, so both tests are the one that
decides whether the kobject exists, and a false value cannot skip a
kobject_put() that was owed.

it would read better to me if the changelog said that. otherwise LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

> debugfs_slab_release() is not part of the race: it only looks the cache
> up by name in the debugfs root and does nothing before that root exists.
>
> Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
> Cc: stable@vger.kernel.org
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>

--
cheers,
jose a. p-a

