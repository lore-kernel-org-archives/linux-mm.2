Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CD5606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zAyOfWU+
Received: by kanga.kvack.org (Postfix)
	id 34A256B05B2; Tue, 17 Nov 2026 18:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321CC6B05B3; Tue, 17 Nov 2026 18:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239026B05B4; Tue, 17 Nov 2026 18:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0C456B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:57:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 735831C3EDA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:57:36 +0000 (UTC)
X-FDA: 85446275712.05.160F257
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 989DA40008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:57:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zAyOfWU+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794959854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
	b=Ic08UQn9oflBY3UutWjV7rMuEshYxZ7Q6TsB+/DV2dWaBq4fHO1UPgVKURkVCyhcuJcF5B
	Y9nmgFUVxyf/4SDN4q9ADW20FT9PINnooCoVSy7x1fL89wm4/FZmxvGQigsVV9OB9zwbd1
	n6/OUHKgZ4VPuFJDdSvwr82yMDnX6JA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zAyOfWU+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794959854;
	b=7umNwmjWBdbSGl0B8t0nJhQw/Lzs2gL2JXCtDSQv82zUu78OsvcjrMwMntCfgmukOUCSjh
	d9j0iySNcYDnKg6X7yc927dGuBclkpQIMKHMIcL34qnN3jJQAibeordrvOgDSsv+XTQDpt
	30aP4iqr5Kd/zTss6JV5PrGI82nJjpI=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-71ab5e64742so248099eaf.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794959853; x=1795564653; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
        b=zAyOfWU+eAZwEMD4BONr2sl/t8W9N+Wog8e/KC1PJsN9wo+sw1CtD6TSdf7vtMg3TQ
         9VqaTMG/2nk/FXA9jwrWll5/GohJSkwUhyWolbmUR9w/wFFSelOYRk1wH3ThCJXdYi/S
         ykvgGadOnHnhw/oollOYPX8T9oQucZVlQuqNmaFJmDK2/Pwq3hr8btIdTCPyj7m4b10k
         2tdL0WqgOQ+q80lbATtV/p6eIYO9v9be2Za5FV0hUy3S2/u1wkdT4taq+KyZIHfxrXn5
         la7fsyAvsPPn19vCUGAptMh7AlErkgLHgDQ8PPSlFNK3M0fwH6VPx/UXuX0FBB4tu22M
         Lqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794959853; x=1795564653;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=q3OTBwL+TyzHGc36tg10hWnQr6i2w3v45IA4aHIlkR8=;
        b=yKCj/W0AUkPoIwQUhVXytYEwB1bvxOu0Ums8P2lI2yTm4uQz8FzQ9FJNFChphR+kwI
         GDQSQWusd2hY0C7WCsS3T0Rp+VSmYfZSyLB5Cv2paAs5+V2wDfGn4z7aPeHk6KkTz4NR
         T/cF4CZzN+hsTCvCn+Hvmrwox+BMHZiomMWfLrvQ+7lGWntC5B7CI1dWwWFh8lFkPoZ6
         k/sMunRMiiPAbbjsPKhP31TQzhzgyfMdXSPDs+BBOSJFIG0xoL+TWn5FmXgTDcCnZuh2
         w5dgR5kw48msG8fM/hD2v9jwVaMyEgCEkOKuKG4Dnj9gHaUejwhAmSCsoq32LWcHnfHU
         QS/w==
X-Forwarded-Encrypted: i=1; AL+hErGFb36ZsxsBJY1lKTjaWyH76EQAST4wyUMOwHj/goC7r97VHBja51mKUJSl5VlPjSaxa09pcsLNww==@kvack.org
X-Gm-Message-State: APuU4Z8SuJ+fCOa+TSRFj/gCuTHLuTURwosTwul86tq6TVM1At0Rigl4
	ZpoqN0xtH4U0AODlpCi5ReGkRk10yDlOvAtpz94CThKgMVxUbaLDxLFi
X-Gm-Gg: AYBFou1RInirIg667/j6fymllpYfrBgXUNofNbSSkyYXU0fMrrI9p+ajeml0aWlSjkQ
	ta8Ho2FR+eDElk1Bmtk6KOhY401R4LAdUHPfSD0WXfNanZVrF3lQBmxlyG9fEjz03FGOt8yGp0q
	o1lwkxKG+TysmbmWvBNqGmU2zk8eCii3tws+evkrLbyQXJdIEwMal362IxWV/Iylj37l2oZZYKE
	gHgleFuBp182gmzIIQg+8YGC0fE/CGGNOTDcP0G2EFTJaM50G5KlzxNDcbkQydJYwD0Brlyip7b
	OL0U0r5E7AmzNSqtNBal9b++eze4w2IjBDWVOBpqLn7vQohAVxFRAuAjj2zpssEVju70N4BiFeR
	7nXmeecg2BWBP3xxc8nv9hfeM/xKBtOS1I1TECqbRJQybx1qOej/LXqAdyHuLHXLufNIBMvWAkr
	E4cjOyCfz07Mw1kMYWhte7zjlBvxuzxTMUX8dKF74TAJGwV0cweaxVjK7rNMnAhax/Sm3/c0SCC
	CuNqp7NJoYHr2MLJV0S4fO5nVnB5Sotb09KBYKoYhzhTSxMXq+AqOjQabuhNOeyvxp1+5aCkpUZ
	G/qsv6/mc+H+qHXNklpJOSyiRcJM19zuBVwgjLw1mPd0dVIKWf9PhfdbetNY
X-Received: by 2002:a05:6820:1c8c:b0:71a:e1a9:4b74 with SMTP id 006d021491bc7-71b1859452cmr762291eaf.72.1794959853612;
        Tue, 17 Nov 2026 15:57:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71b1945800asm648215eaf.5.2026.11.17.15.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 15:57:33 -0800 (PST)
Date: Tue, 17 Nov 2026 15:57:31 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Down <chris@chrisdown.name>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcg: fix zero throttle delay on 32-bit kernels
Message-ID: <avznwfoMxq9s2NwC@devbig011.atn3.facebook.com>
Mail-Followup-To: Hui Zhu <hui.zhu@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Down <chris@chrisdown.name>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
References: <cover.1794902513.git.zhuhui@kylinos.cn>
 <6931674296b98139f5e02821d66ad1855eba36c9.1794902513.git.zhuhui@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6931674296b98139f5e02821d66ad1855eba36c9.1794902513.git.zhuhui@kylinos.cn>
X-Rspamd-Queue-Id: 989DA40008
X-Stat-Signature: bemqk6armohw7duixangu99b4bx171z9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794959854-439953
X-HE-Meta: U2FsdGVkX1/HaHaYO0qlju/OCLXXyqAkvLjjZspfl1YjI0fqjguiCCI/GyC1KOuiG5XID+sYXIZLtq39UClGnpXIyZFRPIeFLReQ7F3SQYXWu/J7vOlnvjPS349kKOJOLirXEJASYsXt9WXoaS07znLQ8oHvxn0sZexAE2Saz179PDaygN4WKecMmY3TdAQZ9LhHP9TWGDlIKMD91zNrIAR9z/Z6q+Na02LDw4Up9fxDCOOPt0P1p7FKdw7rn/+tjxC8grLcteTm2dDWRrYS9MdEvq9qYm1l6ikwtV4saMiv4b1qpJQzOmigr7w6rcCAnCvbtxwkqByQbDDVD7WHI9+J1O3rJwbNW2ptBesxP6QrdopjR/Btj9r5u9f87U7lNPbkVWwsYcmexLML3njgvQYHqJE8Y3z0ZKPgZSHlZ1PbqOaC/OLTP17vQ0MUpkHq6yLyN01l0qJ222hK6WMTM+9Av4AJ7VCOyBX4L24mDVU92Db8hfr6SA6eewy2KNuvHfw84rjIUVQQWepxrDO9+xgZBHAXpFaeuWyjsmfJhpko/j+HRqN4D0EsONkejRIP+AScWNLR0klaTSst1USoJE1r1crufCBQjnia6QekXGx1tvBv1kseIe/rIXmEwDRzNFltZVkaEfQ726kBiJxRVar/JjC5OAAD3sgr1xYcMgAJarQfc3lJ86eTS8Rdhq31WLhcnP8ANxNuWbO6o2Q6/JBTY57hbTiHiAyKbKaqCYdsfmKk/cHhpgSf4Wqcvq49aBwAYypSdpBnC+e3qcKRzwGkVF0L/IR64jDgAcwrrvAQOEc9VsiVNhyYgsCNeIhzbD2Beg6vSvi12GcX2OUS7NSZoIL47L0LtggFRAKKVnONIR4xkO9ejLdQ8t0FEGvlT25PFFZVOLSIYVco+m3tKOPlgf355i/wbl8oO1OzBSFRMWV+cWEekUBLVacEeGI4DD2cDhkUs3MttEexA+7
 l6UGE5sz
 OQPrAtnnOOKHsRXah12Zi/Zy+VMdoCofca8NKg3pJbHE3C7UrKYvXe2Hpuaei9tIlw40zrzInZfVQSoffZIuG3IaMZmHoLLKB5exrfGuxk+ezFK4pqptIp6ohIn9/kel0Y28uxcLt1OCy6i310pq5VxJm+tCI6cZsFob5CgjiWqu3B5ZhzmhenIc4GHKo9Jj/gWcwsIL75PJhaxXLROeOjg/lWIPxngb0npmu9cJINDBKSLXMUF1GdH3DgpJXG+SAyF7TjtU1MZ/P+NkLkNqBGmx8k6smV2g54bUNezdRPWKq9SWrWFKUv+uOMDFqVkivuSbclCMOxA2cR1pg6w6m2pkXFJqZQSJQNooi+ezHAlTedswVnIgEq9GjRgMi8Ok95lOme9RosbQ+Jb6nObjLSJ1Pu+iSB22mtIMRSapcw0rIHd2miNNQ/FtlZd586sYEoFfd/3kLyJp0S07njtSR7OJTrB4PyjdBewsjBU4LYQ5jGeNWVBVTxT0uUAOD9X9TuA7AzXHD2cDQ25C6Z14rOubWPjany8djigjwil/oSHGriMyJQKdRwvtqaLZN8OuHBkXJ6jhr8LvbdEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 04:04:20PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>

Hello, thanks for the patch.

> calculate_high_delay() stores max_overage * max_overage * HZ, computed as
> u64, into an unsigned long before shifting it right by 34 bits in total.
> On 32-bit kernels the store truncates the value first, so the shift always
> yields zero. Tasks over memory.high or memory.swap.high are then never
> throttled, and the reclaim retry loop in __mem_cgroup_handle_over_high()
> is skipped as well.
> 
> Keep the intermediate in u64 so the shifts see the full width, and clamp
> to MEMCG_MAX_HIGH_DELAY_JIFFIES before narrowing to the unsigned long
> return value: a truncated result would escape the caller's own min().
> Nothing changes on 64-bit kernels, where clamping each term is equivalent
> to clamping their sum, which the caller already does.
> 
> Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")

Is this the right fixes tag? That one doesn't introduce the division by
MEMCG_CHARGE_BATCH.

> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/memcontrol.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..1ba42724ed1e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2576,7 +2576,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
>  static unsigned long calculate_high_delay(unsigned int nr_pages,
>  					  u64 max_overage)
>  {
> -	unsigned long penalty_jiffies;
> +	u64 penalty_jiffies;
>  
>  	if (!max_overage)
>  		return 0;
> @@ -2601,7 +2601,13 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
>  	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
>  	 * larger the current charge patch is than that.
>  	 */
> -	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
> +	penalty_jiffies = penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
> +
> +	/*
> +	 * Clamp before narrowing to unsigned long: a truncated return value
> +	 * would escape the caller's min() and look like a small delay.
> +	 */


I think this is a bit verbose for what is happening here.
Why not:

return min_t(u64, penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH,
	     MEMCG_MAX_HIGH_DELAY_JIFFIES);

Or just dropping the comment block seems fine. I think folks should be
familiar enough with values wrapping around.

Thanks, have a great day!
Joshua

> +	return min_t(u64, penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 

