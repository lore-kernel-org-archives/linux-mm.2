Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828B4FD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613136B0096; Tue, 10 Mar 2026 23:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA1B6B0099; Tue, 10 Mar 2026 23:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C0B6B009E; Tue, 10 Mar 2026 23:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28D9B6B0096
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:12:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDF211604CD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:12:34 +0000 (UTC)
X-FDA: 84532309428.14.421341F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9C84C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:12:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WLpxGZnS;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vx+itT2HSu3dk1ig1D+Qzvgul/sL04it9W0U5s6U7wM=;
	b=wVsN0wBorDCUPVY1jPDuWKMKutdkskK/e2phB6Yr+k4wbigSlNeVvurkALwnjWnvDAYEih
	/vC8D/63BkdJEs65or97k+pIOjsLtPXvaZ55073TsN2pQh0+FtnK0DAuXngLifWqgvcU67
	CG8cR6mlnjMlIEMt/cJndhK9L9bQcW8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WLpxGZnS;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198752; a=rsa-sha256;
	cv=none;
	b=VNXqt1zHnHo9rrB8QYAegHjMTKk4IJ21D848A3+liEXv3v8ICNrazBwGX5olvBRo2L1KTn
	YiVoyaB+x7YW5Nrol1/63fyu+c84dJ2a3bEZkbnDkSOhtvDnSskpQLhg/ns+f5c+kwsTex
	vfnF0lJHfbzU8w33Otmh/fMgz2H+p7o=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6615c766e60so9612302a12.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773198751; x=1773803551; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vx+itT2HSu3dk1ig1D+Qzvgul/sL04it9W0U5s6U7wM=;
        b=WLpxGZnSzU94Xg12nMpJWu5TzI0E9WgomDSVaBsxNbynsRRiQ50jSEg2zw+/g/XUBt
         LE2f1CNO38Y1vkS+HdkWv9uvc6Tz0lqkaoARxhPhnQ/Udb2tXewlBL9rlRnmlDmOf7Qe
         V8WFcP4Pi/N0v+UXjSdmRwF6/zDP8fSjdl3YOu8il7maMSV07ltTzfyLwf5w2yMyuo0v
         +6eyXJcL5nDFHSMCgzJPb2FitskBROlKbtVCFLY2KWMxaNL/Y62var/HwIWl87/QdXXh
         juDDBFFaKm6eQfjj9BGxOV0OlTKpqtGwzeBgPsFDuV8rgpVNkaLKVgDn01Y+lGJSj911
         nN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198751; x=1773803551;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vx+itT2HSu3dk1ig1D+Qzvgul/sL04it9W0U5s6U7wM=;
        b=URvPvaHO4ITQNMLOiWelShNAasQ80luFdIwte58TMmX1t/8KdDb85W0A6hafVGFKKI
         RGpsTQ4YDQ38QYB2h7QBBDzab35VyccgxmXqslMCQv9vdKQ5Rbg9Bc5jrD+9k7k9Emkx
         uJoMj3SD69Jeyq5Zw50euMD4GB+qCjFJ78GgQH0rDuhOruv3NDzM9t/fmHHQhxWtaMJp
         9MB2QIHAGToSOugFl2PynPO6zN1nfwDAVB0Gji9SIi6C3qRpj875NZwL+w/LvbnH1fQF
         JNmg/6gY3yaqzwOlLJNGutnjKRtA0ILTCR30CTj/TNiCkDZx5pTkqattwvkuKaI7vwlH
         jLNA==
X-Forwarded-Encrypted: i=1; AJvYcCVkZxA5JhdSKvQEf2nrzMbKRHVWGMOOgXUwLZ2NYE7yeiYkaiPAcKTYdqYLRUB0SPkob+LKwEOwnA==@kvack.org
X-Gm-Message-State: AOJu0YyT+vdYyEovP3OFeyg4iosBa0Cse81k/u1+H83pEFdAeOzq5VMA
	YB5KAZ2vbhNUJW0a4FrC+2M570BUoPOrXWoQtvNjI6J8Xv4fEqVRbGv2
X-Gm-Gg: ATEYQzz7TupRDFCZCfqLdaw5kEhUWUfYwjTJDxfZPDF9Ro4aS2ssMFq5IQXn5/spCGP
	AxMbBzBXyTJBBoaERbAuzUi+1wLOeKIRyZVGsRVDz5naaKOQAK4xljHqG7wA5BaDf7eDvV7mHml
	U5EoDUTN/U4EyMm4ImFm8v6EU0Np9osd61lPIc4L+toaBesYZnRkU+/8WONriGYCSwE69M2EZiC
	5gJWgFvr69B+judzwpcBqMBVBps5vO+zlS+TdRIy8FK+aD68V96e5UN6xq3xE6/m9ghgwonPwC8
	y/bjhCtYv36QIJL/+3MH5d0sXyWorE3gYr+zEvy0ZKLKrYLw3lD2xQpROsmZ0HKW3fz37T80vDN
	EwOj+iGM0tJOiPm5Tej2u05CyQqA+yI/oslzEqA3PGbJW0j+tDmEIjRtK+H08oyI1nXYuRKbde0
	Ih3KTAkQkEFKTD+eFYbnKC/Q==
X-Received: by 2002:a05:6402:13d6:b0:65c:354e:94f0 with SMTP id 4fb4d7f45d1cf-663198c39bamr417662a12.8.1773198750894;
        Tue, 10 Mar 2026 20:12:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66315320df2sm239220a12.24.2026.03.10.20.12.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Mar 2026 20:12:30 -0700 (PDT)
Date: Wed, 11 Mar 2026 03:12:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
	kas@kernel.org, kernel-team@meta.com,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <20260311031229.mloqvlmmqipr7k2h@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-thp_logs-v5-2-686099175bf6@debian.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: C9C84C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: eans8qoq4sr7ekiaid5g37c6cyk89zpo
X-Rspam-User: 
X-HE-Tag: 1773198752-801745
X-HE-Meta: U2FsdGVkX1/NRDNC9lQucucRKiDPpe7j/gxh5C1SZGWJMDpxKd3N+ksDrhxnNYi8G5Nu1yFzsvUD5evpJ4x4lBEyNbVjkXyQY6Dp40o8tkHVqc9ISwS+ZulAvCH2hFuU90TeCM7b1c0/NkFRs/8h6F8ZH+/kG7uKDicf4F5K3ll7iHf4eNul/iny9bMrc5FMFrh+MrN4WwZV1pW8rLoJR1tcYRdrTReg0EA2AFnhfyoLVixTTEQVbfeyyuOCBxyhmR0oFr4HI8/slylrgk9AydxDVBmcOQSJbnshTlJEoqVNcdkNv7/zGRQ0ZMRmwBGH2EGsP/TJP0mW1xla5x0o5bNFSkEUA/CuR+dARLPCLuNYRojs3hNCq9tTdZrOFfEYTUNiRYHuilZOAhIhY4IG0yLTAyD3AIIL9G5HpV26/YQLOlabpPt9BKlz/0Il/D8FR2xiypNo+jwg8yZyWzJr3s65BgnqY/LTNnHP1e2OncXUsblFtVi8GH63e3+0wKUONLa92Qc8hrs9NI9GSe+jKQRViByqchSf2s6t1P8riVYX0xwboaxc1uLb+nGB61USSrqGNZVOBjSGkO578XPhramSNVCbDZL305aXmLouqmBOylRwTTYksHc1NC3fe6iUPKuYtk4JsAmWnHgL68NEacdqspWRDYL7GkAMQfj+p4WKWJjmOn2r8cxNXGOBjRbDedufXS4Db8DoNg85MrQ5cFYKHfEa9YsOzb4nu7RaXqx8WvS/D+Xzqkt1MqbHSQOQu/XlSeiR8XmU5rddWcNJoAifn9+haytWjteLVZe1R9TrG3iAXOMzb9YQZ6jGg9Zuxe5+MfSADKy2PHoENLn+R/k+URTyS1r1qs2Nowhp2lt8RLoXnnK7my5IC/dwJbF/20fN/xcdiBRsQJDbezyh/hG86VX9xjbsQ4wzRAD3JkLuJJpo7ORHAB/gRtMhQ6DwpE5mBmIQvelz457/czq
 Vvgb0sZ8
 Fn7U5O9HOCcwvcq9QK/oN0cVvioVpNQgHKAHBDLzyvA/eqIAjQdk+gflhsv8ye8mcXlPagFke9QGz2cwRlOdxxeLesFsaI8J9OAonSNnkgb2jgaGlCtb/dMuC9Yt2wRzqfsJfVk4Ez94dFIclp2pn0NxXCR8alCm11OtZMSDdDEzqIKSUcrFydmPhKvmIr0FHNHxUGDi0zoJgbsiQCCBP1+DexEATI6Z9FujKEESNvz+TuQpKuoX1LLDAfu+5mo/Ra2pl1QHTooMS9F1PDwvEqcPMD+lZXPUI+y1qI6mbkKbf6lzzpA6XCJzlmqMtbPfpGaF/rBRSrlhHVf6h7cACf3PzIJ3yi0VCeJK7hPuvJxL5tVjMgU4BQKXLDIeDlb97ta/FmJme87fWbnaVOhChiH5x/MJhhLIrJg7k4RXBngNvgZ4Zs+JqL8ITuQND8ouB9EZ7gMJoNlzC99/uIsFvPK0mq7a6iaEgFMFZv5vHw+aTUrkdPJbea8/VVfR00NtRqExByNP/dBrvY1V3a+aJ8m0U/c/BAcstmwpE2Iask4mnLHkhuUsMjjFkr0IMKFVczt1G/Ou4x1ltc3uxBuFwUxqZWvVfCmwMrzuiGklgTwVtQdAGF+51AU4Zp2vVipgyiKm7V0MKI4e4kQZeTLDc4NJP7mo+6kV1UpeYSJJa6+R14/J262iezmHQR/qrJUpit/sZuh3jsRQTeL72+jHmlDGBD6gextSs0aFfDt55CdEuZLr9F/LTRL4POMvprAsGncKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 10:57:08AM -0700, Breno Leitao wrote:
>Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
>anon_enabled_store() into a new change_anon_orders() helper that
>loops over an orders[] array, setting the bit for the selected mode
>and clearing the others.
>
>Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
>for the per-order anon THP setting.
>
>Use sysfs_match_string() with the anon_enabled_mode_strings[] table
>to replace the if/else chain of sysfs_streq() calls.
>
>The helper uses test_and_set_bit()/test_and_clear_bit() to track
>whether the state actually changed, so start_stop_khugepaged() is
>only called when needed. When the mode is unchanged,
>set_recommended_min_free_kbytes() is called directly to preserve
>the watermark recalculation behavior of the original code.
>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>---
> mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
> 1 file changed, 52 insertions(+), 32 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 8e2746ea74adf..e19dda5aaf195 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
> 	return sysfs_emit(buf, "%s\n", output);
> }
> 
>+enum anon_enabled_mode {
>+	ANON_ENABLED_ALWAYS	= 0,
>+	ANON_ENABLED_MADVISE	= 1,
>+	ANON_ENABLED_INHERIT	= 2,
>+	ANON_ENABLED_NEVER	= 3,
>+};
>+
>+static const char * const anon_enabled_mode_strings[] = {
>+	[ANON_ENABLED_ALWAYS]	= "always",
>+	[ANON_ENABLED_MADVISE]	= "madvise",
>+	[ANON_ENABLED_INHERIT]	= "inherit",
>+	[ANON_ENABLED_NEVER]	= "never",
>+};
>+

Just one trivial thing, maybe keep the sequence as the sysfs output?

Currently the output of /sys/kernel/transparent_hugepage/hugepages-xxxkB is

    always inherit madvise [never]

But no strong opinion on this.

> static ssize_t enabled_store(struct kobject *kobj,
> 			     struct kobj_attribute *attr,
> 			     const char *buf, size_t count)
>@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
> 	return sysfs_emit(buf, "%s\n", output);
> }
> 
>+static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode)
>+{
>+	static unsigned long *enabled_orders[] = {
>+		&huge_anon_orders_always,
>+		&huge_anon_orders_madvise,
>+		&huge_anon_orders_inherit,
>+	};
>+	enum anon_enabled_mode m;
>+	bool changed = false;
>+
>+	spin_lock(&huge_anon_orders_lock);
>+	for (m = 0; m < ARRAY_SIZE(enabled_orders); m++) {
>+		if (m == mode)
>+			changed |= !__test_and_set_bit(order, enabled_orders[m]);
>+		else
>+			changed |= __test_and_clear_bit(order, enabled_orders[m]);
>+	}
>+	spin_unlock(&huge_anon_orders_lock);
>+
>+	return changed;
>+}
>+

Nice cleanup, so

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> static ssize_t anon_enabled_store(struct kobject *kobj,
> 				  struct kobj_attribute *attr,
> 				  const char *buf, size_t count)
> {
> 	int order = to_thpsize(kobj)->order;
>-	ssize_t ret = count;
>+	int mode;
> 
>-	if (sysfs_streq(buf, "always")) {
>-		spin_lock(&huge_anon_orders_lock);
>-		clear_bit(order, &huge_anon_orders_inherit);
>-		clear_bit(order, &huge_anon_orders_madvise);
>-		set_bit(order, &huge_anon_orders_always);
>-		spin_unlock(&huge_anon_orders_lock);
>-	} else if (sysfs_streq(buf, "inherit")) {
>-		spin_lock(&huge_anon_orders_lock);
>-		clear_bit(order, &huge_anon_orders_always);
>-		clear_bit(order, &huge_anon_orders_madvise);
>-		set_bit(order, &huge_anon_orders_inherit);
>-		spin_unlock(&huge_anon_orders_lock);
>-	} else if (sysfs_streq(buf, "madvise")) {
>-		spin_lock(&huge_anon_orders_lock);
>-		clear_bit(order, &huge_anon_orders_always);
>-		clear_bit(order, &huge_anon_orders_inherit);
>-		set_bit(order, &huge_anon_orders_madvise);
>-		spin_unlock(&huge_anon_orders_lock);
>-	} else if (sysfs_streq(buf, "never")) {
>-		spin_lock(&huge_anon_orders_lock);
>-		clear_bit(order, &huge_anon_orders_always);
>-		clear_bit(order, &huge_anon_orders_inherit);
>-		clear_bit(order, &huge_anon_orders_madvise);
>-		spin_unlock(&huge_anon_orders_lock);
>-	} else
>-		ret = -EINVAL;
>+	mode = sysfs_match_string(anon_enabled_mode_strings, buf);
>+	if (mode < 0)
>+		return -EINVAL;
> 
>-	if (ret > 0) {
>-		int err;
>+	if (set_anon_enabled_mode(order, mode)) {
>+		int err = start_stop_khugepaged();
> 
>-		err = start_stop_khugepaged();
> 		if (err)
>-			ret = err;
>+			return err;
>+	} else {
>+		/*
>+		 * Recalculate watermarks even when the mode didn't
>+		 * change, as the previous code always called
>+		 * start_stop_khugepaged() which does this internally.
>+		 */
>+		set_recommended_min_free_kbytes();
> 	}
>-	return ret;
>+
>+	return count;
> }
> 
> static struct kobj_attribute anon_enabled_attr =
>
>-- 
>2.52.0
>

-- 
Wei Yang
Help you, Help me

