Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A718CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 17:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8FF6B0088; Thu,  4 Jun 2026 13:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62076B008A; Thu,  4 Jun 2026 13:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0C66B008C; Thu,  4 Jun 2026 13:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA6B6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:04:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4326D1201F5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:04:08 +0000 (UTC)
X-FDA: 84842852976.21.08D0945
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44EFFC001D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:04:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NuPQ8T6E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780592646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcvudAyzInANCS3/gRy6s7uXW50Jd5n00LMZGa4M0Ow=;
	b=y7vL02EQbRAM0cWDfLSY6f488CDUB53RwD9niQg5TfE5nUae3wuVX7h1LCIFulgoIABvHV
	CIiM9c3EgDm0RSb/reOl0PP4l1YsAagCsdMuPxn7x0IPGIdH+iIqQEyJwurzCWMvfx+Qs2
	V16Rsra5iSrVzXWwDc+dtMPPJCPt1DI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NuPQ8T6E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780592646;
	b=Pb6JY8JJUixMUfDYBWBUpY6iwVy59DkViLhF7WDl+GK0frKxnvxGe0cCiFwmJC0PGBRTQQ
	Ve2uYC4fccsitKzQ1WwkBSx8zkF5tUKn9893BexJOLtDji719bWr3iMNJst/CU8f8om4Uh
	tn8RULKHYRMShzbbYcf0JvizpkjMGvQ=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6f922e49fso723817a34.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 10:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780592645; x=1781197445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcvudAyzInANCS3/gRy6s7uXW50Jd5n00LMZGa4M0Ow=;
        b=NuPQ8T6EmiQkb77O0tyET9Lu43TjCJHr7+erUR5eD1/nZ/5jrPXWgcbcQBWj+glVY3
         YY/paPD/nqkueaRNtBrtXw8oGYyIR3SUolb5Rr+g1qV5XIEcG2w9waUwTq3BEk9g9bSO
         xLaax7IyKiqTG8QqUEh00ppts8Za4zhVXDbiMgHiVjzVZnxgyONX2Gf0ycyZGvk++2jb
         8ejbx2hqmR1h4PKDOEcfsDAtLE2b1dpZNKXbfeXKjnVUqKH0HcaNPzVrr175T8+GsYGZ
         RGYlMlmRK/wT3eOk1rJAnmAJDn1XWTm/iIDbkKumz22Di/yRgoWoRi3s2lUWaO3x8Um5
         Js2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780592645; x=1781197445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DcvudAyzInANCS3/gRy6s7uXW50Jd5n00LMZGa4M0Ow=;
        b=SSiIWNWGH8iPjsK7yz6h8UwEdIORj7WL6ED450zXRrKYitMnJR2yPmYuV9peKKMR+h
         dhoLqVMFoFNovTPkgsP2sXAYkCRLxObiO3MIehnRA2UJcjNjH4pB64w1XkV1oAGLoW2Y
         VggKwFScBTp4ugzfiVcnSzWG1A4N3DlPzKsXWsIQikqgXyZzTT9aHCzQDL/6nS/bEV+U
         LuexYC7JX8acBYDTg71IajoiWQpGSGHBQhABErX5b/Pdzo+0KFVSS1EX+UQNe26KhbxV
         mtSoLIVNVwcTrkQqw+niQDf83bqi5YrnjqSW+07lcxuGiqpKsD86B1kaC3n0Zqmmh6RP
         QpOA==
X-Forwarded-Encrypted: i=1; AFNElJ9wzJpurebmr79OmT2vYX4pPatEt1wlXFNscCnfXITpqYtCACQz5Oh8AcPQsubg4+55rEJfOA4TWQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7RW+aeaWpESGC67WkCBlgWJ0gKwNWU5ksUm0qpvNmo/e28UJb
	u4Jtevc1CWug/lntuTWrS9WD5sVP5VjltwF8oSPmjOhLuk0LFmnThf3V
X-Gm-Gg: Acq92OEkZe3YxtoIkN+Fo4MV+cJLE/AbYXnpOYx2NTeOYERyZq7CkdtSdQha1RJiGrH
	l54KGrcf0GUS/vhzNC4FpsGMI5BdCDJEqiWWh8mbhOvv1BRXU7Rt/BNmkfnx7c/jMLJuOosA4s4
	Yws23nvE//LJfsdY4UR9CocyblXa0tD+7JROrOnnsl/1ewBiOj0RCSjdT7UkDFPefTRROChVq+n
	BYRfzIXrW3QDooThjyA0gyfeog3e7gUhskSr15WayN8Ld264zMhUJmOBkQk1mreNmSAY2rcUlt8
	VGzBjEfuOqiIltUCIbKrmm38A4ZrSAog+n8j9C8PzoBm7WLjFqY+sgwR0EaoWufTrqC0oyAT1R+
	yfbmAd2EDNDJocBI2NpvYpm55aZ/EhCKie6LgblddKm3QF3m/UibDdxxV4k5eXK81LxQVMsXljf
	8yFYQzphBioAgFHbTagyLbcspQ9UAhTk7p12dLf7Rl0OQ3iwoXNJuY8ps8jUlSwOc6
X-Received: by 2002:a05:6830:398c:b0:7dc:de56:d75a with SMTP id 46e09a7af769-7e6e94ae42emr5492401a34.4.1780592644725;
        Thu, 04 Jun 2026 10:04:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e78de8bdsm4114971a34.16.2026.06.04.10.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 10:04:04 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Imran Khan <imran.f.khan@oracle.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
Date: Thu,  4 Jun 2026 10:04:00 -0700
Message-ID: <20260604170401.1401791-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260604134245.1580287-1-imran.f.khan@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44EFFC001D
X-Stat-Signature: s6ye35zc8qpyrimse1spdg1i9chzrh57
X-HE-Tag: 1780592646-390770
X-HE-Meta: U2FsdGVkX1/8rxzETcgc5Qkl3MnNfw4hFMMeeZdRplcxcrnDqHwSMbiovStR1VWwgzW/gTi1aK10vMeWhxDZnXxbmq4cLn7pIjAPDcCVQ+Dmve7Wy6tbk10YJTtNv6X4LZ0DXibW4+uJgqOCYYM+QTLi6TdmiRuB2IQI/Ekjf8e+6xVvFJ1M9u3r8pPap1XhofJCkMtdDLBLoNVJW93p51XY7MpmgCAT6hDGijcG/GwKbiJflIW2rIYkQuj7gFu+xKMwanFx3xBh8CeG1LyoR/Pl7SkuA64XFbY8zPMpnH8Q9gep6+WWiyEXSJBHBKJtB2KwHi0nkIycv1fKTzh3eGqlY6zIdDHoy07MZEIWWRgrflC3Sqoc1gJYFAIJi4fCNQEAgNZr8amWL0ejh1UFegw4v++DYs2co3sJnf86J0M9Zu8HyJRcA8qEs7mEM5wbpdiyMr06qJ933ONUpNojy0a0KO1A6yzgLfdcx403YBuBFaH+esJExu8y4M7p55rj6cNaLjhoYoEcY6maCUJ/iRg07DsLSNCLkjcH1O252jicBsxfNll0U6a50cnwvE1HCrqXAJtzOnmT0GC42ieKpkiNNHJ0eyj9wPQXK0GN1V1Xdzkn3Ex2YE17xOGWtG2TV14kKXvpKzKmUw3FOidDkjnDqE9indO4uCxc/fraIbYA/Bf8f7QhUggr9SUXcXrDI5JY6Uq6ad94VUjnu0v7rjKjwj3v3yCJJ12nOFD3UHuvtRzQyWxFTa3uhl/1rjmD0fuhOOucGGv6zbM14lCSBaln99w01QXGXj1QtmLJqUdm6tpbpiAOYUa8qZTUaUZh55CnTIpmbMZz9pxPukU85+ket/rlsEsKD/1bKhEp0+NF2+3zulXMNG36KILXxiyJ1Sa+qQphsQ/ce6Itc499alGtPTttjoimXK5S+eF6scB9VvQ+CmetO5RjtAjooPHYeyrUR5Gj8/5lD/nTp7O
 KIn1vOpg
 YhryOh9NUymS+2xFhesjAiAa3hvMG0pTQtdyvRaFVoRsxHUiaH0bltCBhwJVlkOPPUCJbJiLNzYnJFYmkPtbrrQwapcdNQKjSx1pT+1hbKwpr8IwLLVu/Zk7ELP4n++epBaR+/BSrp2UdPgiW46A0pQX9dmEm2+NnZjL35UTzpTPjqu0yyBBIZ9lnS6Iv7JG60rPWux3n5E8skjzoo1tU+hgPUol+IpGfZ9ADsFg+ckeyJNcZBv9zcFhzkJuZvW0GUAc0bW4lBfpKr3sxzE80/U+xCkJ0P8V12r3C9umdU7glIqd9D3KAPTIhOS5cZZV/+tOR6GRzBNlkx4rBto5o8xhPSBuKCqJJASSj/qMAdcQfhr07jAOk7lrj3p6X58XZatmimG1UUfYPZESGUJHXRjdR9SxAnEByJ5Ca7V8DK1RgMjNQZeQhrQDp+fR3iAidyozAqaAyK9NE8fYbX/AnWHFfQYQe0lir2ts8uzvIO+K01uPRZevx8zUpjsQbjyLbpdRHaHXh+V0IccT+JSFhOQYVLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Jun 2026 21:42:45 +0800 Imran Khan <imran.f.khan@oracle.com> wrote:

> frag_show_print() just reads zone->free_area[order].nr_free, so
> it can safely do this without needing the zone->lock.
> 
> Pass nolock=true from frag_show(), so that walk_zones_in_node()
> can skip the zone->lock acquisition.

Hello Imran, thank you for the patch!

Seems reasonable to me, and I think this sentiment was already explicitly
encoded in a comment block in frag_show_print:

		/*
		 * Access to nr_free is lockless as nr_free is used only for
		 * printing purposes. Use data_race to avoid KCSAN warning.
		 */
		seq_printf(m, "%6lu ", data_race(zone->free_area[order].nr_free));

Plus, we have a data_race() here so it seems like lockless reading was
always the intent anyways. So:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Digging into this a bit more, I did find something worth noting.

Commit af1c31acc85325 "mm/vmstat: annotate data race for
zone->free_area[order].nr_free" was the commit that added the
data_race() here, in response to a KCSAN report. But looking into it, I
don't think KCSAN was reporting a data race for this callsite, it was
actually reporting it for a different one in
extfrag_for_order->fill_contig_page_info. Maybe the author there added
the data_race() for frag_show_print just to be safe as well, even though
at the time it was protected by a zone->lock anyways.

Just something I thought was interesting to note. Thanks again!
Joshua

> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517de..7b93fbf9af092 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>  static int frag_show(struct seq_file *m, void *arg)
>  {
>  	pg_data_t *pgdat = (pg_data_t *)arg;
> -	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
> +	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
>  	return 0;
>  }
>  
> 
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
> -- 
> 2.34.1

