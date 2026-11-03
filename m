Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BBD606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b151lrcN
Received: by kanga.kvack.org (Postfix)
	id 444916B05B1; Tue,  3 Nov 2026 13:40:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6D16B05B2; Tue,  3 Nov 2026 13:40:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E386B05B3; Tue,  3 Nov 2026 13:40:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06F3D6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:40:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CAFD1A0522
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:40:15 +0000 (UTC)
X-FDA: 85394672790.20.A83E713
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id D386310000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:40:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=b151lrcN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793731213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
	b=8IPs8STrQ5hmll7tW9ePhR3+WDtpZVTf8r8Lykt2YsqmNWll3VPwjGNlakPC3pgEx5Doo0
	L5Bt12DgPsUYEKznhagd9DcZaZb14T1oRSskK0kA6unKpC6d5vd7rbzfbUWQpKISQY0MtB
	j2bau/R9HdMQqx2lZ/m1KCMz/hwYjQ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=b151lrcN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793731213;
	b=esdGhm1qEdIAaIzW/JcF9tdfjd+oCx0Ht+tjOUrEEyQqQRTG9eL733xK2NY57grwjQ9wQj
	vJyhblS3be+tkyMW06LV7fxTmRGaeH0zV+iAGcHGO358AfKkkDdOgnJxy/ykt1OBEYABwM
	uthPuKL205Hh3aeriSm6R6tcJcnXKZs=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so2491268a91.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793731213; x=1794336013; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
        b=b151lrcNab6arvqWbvexvOEBhGKKL7vcyLxD8E/cvFGFXRbbN1sKIKUT+MML94rZv0
         EjOG89AICnfl22SSgMmO15ZiLsCSFjS6YpyPYrEUVpTbHYnMbaMvd2t/44sLTnQfhPRP
         hf9kFYoAN01fA3CLJZ24uuW8aITGnrxsNKmQckjwBQefsDI5pniEkARoNM6661tboGha
         4EQ19NuLvNAtlPlSdB23I3mxVsRfvYwiBBtWAtW2CLs+gS+snwZfmAFcreupTgvMHKfs
         oVN/8LoR5E93lOzZxxQGvzbnpy/LfQmulnjMj/RQBpEzUwmG6R7bFTnyeGl+CiG5ZQ9a
         828w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793731213; x=1794336013;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
        b=Jd3GBrmcmlAVMhmM6ZNJnCSSzhlD5lmuR7NUH4v2x07d6RatuM955pn9urf6q9a5Lr
         0iCGeAW2BFXMDXot/kIx+waUSAVRkKdWU8MgZKJUgmrJ7+cdeYwvkLXuGW6Tk2J7uO+r
         2+s7/JikjPm9TAz5dc4oiCvCAkeGw8cAgwuWIqN2ossl1VDcB4IRO2ImMjv8jBl+6usL
         UGvnP14jM81BP5J0ZRnCRBnHphuiJIYZQXWpLjrjzEjUGU6yNh2QHXyAm9uhJCd9DMAB
         pgRb/plqV6irARB5SxvpoKDT+aypdRCFVtneNZyJYR5fdDdvwSiwJbGYAccue71xHrZs
         AjTQ==
X-Forwarded-Encrypted: i=1; AKwUvByZhV28dywTwc9NgIkvjYL1eN4tQ6K78/BWR26fTk9iMwUNMK9+YCMeRIwJevMVEZMFXUvhes5TQg==@kvack.org
X-Gm-Message-State: APuU4Z8brA7gq8pzTgKYUbZYszyYQfBD5d/mFPcdVYx+35pI4Xot0dAx
	0jFyX5I0AgCawXFYKIzKfe0f8MJQx31Siwm6pOAngslWhCkAoRYOzCeO
X-Gm-Gg: AYBFou28pqYV8lHVI9t9fBNEh0deB908Rrg3h5cIykiBxkQ7HZa0kCS/UvEd5RPii9a
	UWkapgyGD4fqQzAgMVsd8b8F0eeb8mdg7np/FDJDxc1Hshgd4YRL+WoDtA8hwMAeOKZyhYm3cbg
	w/7jN5RLpBd79Kg+v3Xo1hbZ7RljwQ8ABdMlylrKgTcSheUkC9zTWtLTcfyMsOa+BZ/aqyqq288
	VBTljmiYivyqr4aHt01/zymm5lH1U+4QEk6oRXamQfX7jNvzATgI7c/6p/1N78+wKeujF0J7Nj5
	+hv4B/ZvtbvM6Yxc7d0wlTPLwA5uOKsymqAOFnpmQXyJhpuBMZaBf3x/DSLjLmxyEjPfGxRBu3Y
	8f2f03U2Wn20Tg6GzbV6k3VNqvoKQI0kZTZKhZPWz0bqN59lLjZe1pkRFLvuiZ6kUrTPc/pwSTG
	kCLjDeKiZfGM/ewTHLPp8JV6zkpPFYP9CaGeeOnOUYvV8xpHE5viLIh3xYW7M64qNSSq1BqfaJ8
	ljlW8d5yTIEKSX6Wv8ryqJ+auMY8PvZtD0XfNBjZ3ZGSdZl9OSdTPyO/tYys7aBJDwJSIRzIZYD
	n67Fy/fdk3GoqIJEv7djp9Q0Y6Rj0rg0m+oBPGIeUAIHEsIS8XhGK872RUgUhrYTQnWe9wxJeDd
	jR7ggbDsunSivDnXcqyJ+5K9N3SRh9b4nSw==
X-Received: by 2002:a17:90b:3e83:b0:3ab:2737:3396 with SMTP id 98e67ed59e1d1-3ae89855ccbmr11961848a91.65.1793731212415;
        Tue, 03 Nov 2026 10:40:12 -0800 (PST)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094d70a60sm58552a91.1.2026.11.03.10.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:40:10 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 18:40:09 +0000
Message-Id: <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
Cc: <kernel-team@meta.com>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Sashiko"
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo (Meta)" <harry@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Hao
 Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D386310000F
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: dnest3eprz6digrdcc6zne8mg6tmc3bi
X-HE-Tag: 1793731213-918547
X-HE-Meta: U2FsdGVkX18blceMOHANmW9AIHddNl9GHTsWrEzmtriAvnx9Gy9yhF2o5So5oqxZiRR7GoGTdJMQcvJbAIlKMF/XWT6RCzSmCEKuHi8rl/X4dZLnSmxCoWlG0eAYMUlESQhbw8529rT4HZuQrG0CT3Hq+H7cAP3ceAcqcg0scmkVr53DRK5KW1SN2RRUku2rhFNE68+eP1pd+Up0Eh6esfchMy2nRLYJ//qqB4R7l6PQqWMjHR8L11o+zDczbiVC5ZuRBQibu2SZj2tHzXRBXJYRm6w66xdHVdZ9aJo37QMxtRkaLccdTu5nJS2vp8FK3wirW53DaxuyedVjm5S9szB+5T0O/xJbcTIjX1jv5sETlZDq1TDHc5ItVXPAmJnc2tlq1+s3ORjXpEUJyxF4368/RS14CKwfTaU+eJHzSY+QhaBeISGf9gqElewKzexYguRGm9Jiel+ncAf74ng/L2ewFXHHzIqntTKNOVwj9KYp1E+w5wL6500di1ml4OHVLN/P/YHbvZNBSfmyJgk/kz74C3QKxxQ/KxETC2cLNtvnYFQ5bLyTMH0cdlScMz4Mw8o9s1zzdAF9VyqXU/x/ZqEtiJ3nS9FwYDTvNf67GZcL/P+z2xDKeH2pupxmUb79CSNXtNpKE+wRMjSrpwQW7ORNp3VJOL8FidVlxKmSVqw21wyDQJwlpNTAnhcQrI4AD6bNkNdIGAIWoJTforvA3uN21tdzunEcnI0gBlMo9DIF2yKX2db4VuTVyxDt+tfnEdt2sX9lrkJG9J3YvfqsV6Y6ndPF1GYJOeN+NlNCdeZ69LCiyCCIWzzs6+XHFwZAchWanlAWz0NON8oJ+YE46hky6MlVlt0v8rzL3vf3hcJniOoDcVDVo23Qu3ml/tuX7yiyGVwa8xQDaxoac21rfxh4IjFN3IAhxMMZUKEGkcQXk4QdsGGfzf2atsMsy14P14Z674MIHaAh7niC2J4
 JxqVpY3L
 Af71iElA2F0eVF2moa/HhLnEwDWY/8W6tbNHsXJ8n5rP/E43JxLoIqcHIwtP8Nm5s1uaOr8J2xO+6NHUzuR2h8yxiU2vivPHibuX+NqEoiSfxbfuSc6XBgHnJKuAzNi0y4EVCcmA9w+5dwLKUvPWpkov0HLJvtrfePB5TCs3hpoELcKGynO5PO8uPMylAbmR63hiSJqlcRriUYyao0mx46DK0MohYe6/3nBgTQoq90Wnp50smokSrIWpHk+uupY9Aj+1NYsBZXqw8kPrV6dSr8hXljUtPFWaLnC34Gh0lOKBnWkhM5OX8zqbuBjK41Yy/7dULC1jGNW+UKqKKyaSb2EtiUjdpZ3KzO84ZU+M9T7QnF1gIVvHVl3FdkKMkDHBvhZEwYQO4gQ1y4M/UIoTjuD5mCINEB6AT1ohGDBBpt24SaH8xG8V5dTjOFF7RwHJftPkwmwFpKYVx3zdyxkBBIa/gK5JU5a1GTuhXO8t4nyieGCp8BaCj3OiCT9yltxpfIqNkkvPZjFTZ7hEsA6pFDSxtJLRwc+xOcQcaDFwMGicCdWKmlDd5WrX3hOuNxMJtPbkX00cSiK2nGVolFJuaz+ppNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:47 AM Harry Yoo (Meta) <harry@kernel.org> wrote:
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> +
> +		memcg_alloc_abort_single(s, *p, allow_spin);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);

can we call kfree_nolock(*p) here when spinning is not allowed ?
Karl's patch did that. You replied that memcg_slab_free_hook() should
not see an object that is not charged:
https://lore.kernel.org/all/asaAwg1KeZoEYd4K@thinkpad/
It's fine. __memcg_slab_free_hook() skips an object with objcg == NULL.
The else branch relies on that. kmem_cache_free_bulk() also gets
the objects that are not charged yet.

> +	if (likely(allow_spin))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> +	else
> +		defer_free(s, object);

That's an irq_work interrupt per failed charge.
kfree_nolock() tries free_to_pcs() first. It calls defer_free() only
when that fails.

Then no need for allow_spin in memcg_alloc_abort_single(),
and the fix doesn't depend on patch 2.

Something like this (compile tested only):

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c..fb92b48 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2551,7 +2551,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;

 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		if (likely(alloc_flags_allow_spinning(ac->alloc_flags)))
+			memcg_alloc_abort_single(s, *p);
+		else
+			kfree_nolock(*p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);

