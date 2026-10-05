Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158FBCA5FFD
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC316B0088; Mon,  5 Oct 2026 05:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C8C6B0093; Mon,  5 Oct 2026 05:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CAA6B0095; Mon,  5 Oct 2026 05:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E85936B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:09:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C5D8C018A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:09:21 +0000 (UTC)
X-FDA: 85287998922.01.0D026F2
Received: from mail-dl2-f3.google.com (mail-dl2-f3.google.com [74.125.229.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8858840007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:09:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPtrOMoa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791191359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Duw2nxZN8kxbqWipjB3kgCvhqho4PD5wPOWTNu1vMgg=;
	b=VHKqmXPuVPcAeOw4IPWEGzUfprtUtBgQMDLAUsu1wbE8yAXJzyHG1GxOSoUU/U4o+TgRzp
	vzIFk6ITlVhppR9vMPQJNVsufMclo16+b9cJLabdNuNENsTjAO72akKx7xe3ra+qJNnfIH
	PeZGb/sbRmQfD/aPYime1gjyolV+dRs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPtrOMoa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791191359;
	b=oUj+zf8ZcvujMbprvUSt79paVYArohhL5xCP/3HoJBRs9ZWyc3XZSG/BNrrBBzClMZVQxq
	tszLrOXrggj75JlnFolTDcNHE7/q35xGKWPuqreNSe7S2wR5kBrakGS/S8Bvh+FoSkm4l7
	dTEfq2+9uC0Se/5zpdUrTDuTREZ6UD0=
Received: by mail-dl2-f3.google.com with SMTP id a92af1059eb24-1521c45a248so184222c88.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 02:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791191358; cv=none;
        d=google.com; s=arc-20260327;
        b=TWHSYMyUr1riwengF9tCS++32S3c1RwCLpl30o7jaRq93QCr3PxJdp2qVcNXKgleew
         no+S9Simw/FGWkBaIZAWY8cn8NmCRtum2KKNGFCMlFUVAOkT763h2wqmu4XNMNWEZEe6
         785yJZIl4BBgG2AAWDComMntGBA3JMWpJoFdNBucz5bQFls9V6dc4Wj/MbfBWGT3rWxs
         n13XMPVV/GBG5+zfZQTmdf0OlczMfCcPLRf7nPf2AA2EnJ+wVtlrEN0bsUwuVQ0Isyng
         OegZRNJVto7WBGg3MvRFqk3NCK6Ln/S+OIwMAEPv+m18qh8xIuLlC/SUoOW17ozH4Zeg
         0rdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Duw2nxZN8kxbqWipjB3kgCvhqho4PD5wPOWTNu1vMgg=;
        fh=79wlAEnNGwgT7rQGz887jA8mD0N5wEa+6tQQKd4cCf4=;
        b=CjDYOiet+CytGt62/oft46ibgHX604RBrnGnfu+kzraiAwOXHcRxo5802ELZU2hrwp
         IC7usl0GY1XHQeUFEML/4bEOOZef6HKeV2Eti/UzeMpTDcpRkpy23AeOHLsCnYAi8iFa
         6ysqKLHvSFRLJUDpNE2mjcSxWjxyGY5E95/moXz/IT6e5XUn1+bdsmti0i05yl++mlho
         TpYF4qEBVzwlVSfBAQUogurNYn6/SF2nXNcXqjS5sNL4qUU00cJxEwIdflLBroBIZkbJ
         0l1+FCMFPsLlEYMYum8uYYTPohLc6WFB+zkjUm9L3oDBWivOZaEDT7cBesitTuBzYh1x
         bngA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791191358; x=1791796158; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Duw2nxZN8kxbqWipjB3kgCvhqho4PD5wPOWTNu1vMgg=;
        b=fPtrOMoayeF5axIhqC8xbjGN6qUtURjLoG0Uj60bfUTkHnfASUyvLzsF5CawnDOJwW
         UPEzarggYEd7Oe7imXL4r1eqNubZDfgwhCcwY2YQesdyItj5/RwZAGD/+d43AYRfv3n9
         e/s+f3bzlJDwdoYV3zbQgWDZHRjoITB16ZsNgKl/hYINyziHeG4iCQnyDlp9BdGsYiJQ
         kmmpKyJ/qn/JkI1JZ5b4aX8KACHVo+rkKu7HaHlJ5/61EDyxgnrBIbe8E5kP5yAeov/d
         soDjadqBqL4eydEMAqeNUGyLthV7OGJtapojZBF+aJd7EtbUyNTrS8M2lsxPho3YM2Zd
         pjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791191358; x=1791796158;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Duw2nxZN8kxbqWipjB3kgCvhqho4PD5wPOWTNu1vMgg=;
        b=GHFqV8lFfe+3O/FTYq32TVYahm91yMxUlnmEYzoRhka+HVqfi1YmP8/No2cOlirSlu
         kaLs9ar1CnssL2RZCFTHzykpwHm6R+d20wnJxbaHQNlcR0Pg3i+JzhtNymVtAlxULHPs
         aocfI7bO/S5ZxpgJReZGbbHrfFYRIoFedVvtDpWGxiwfRJhIwDqGYT3wBzRrTXUTGlDZ
         6K2kzPZLbowLFozX3gEwXItnU4axXDEh0vTdtiFVD9XUCWibtXBT4QHuQHkYIizSUdvL
         xTOE53OK0CacFCkreAX7KkoUCCfWxe1AFwSblGYdMf6dHRWG07RahhKzSXnwOd9uqvEw
         +Gwg==
X-Forwarded-Encrypted: i=1; AKwUvBzbG55EGOUoDS+Eh/uSk4obAN7asyb5dulMNq76l7lkpt4Lm2KyqlZCMWHWYm+lRTyPxCUI9FfJuw==@kvack.org
X-Gm-Message-State: AFuF++lESyHTmJvlGLFO6DMuIytYb6NG5DWhrYhAp4+23AAl7bYu3+Ot
	yUXsBCd+oJHS0dvpptupVVw7P0bCCKVBks1ikW2a7XDlCKfKaiY8sAm2unTFeQ2tMIj+7JIfNO8
	4v4aeTM4n44tBxz7pGXTWw8OBG26k7w==
X-Gm-Gg: AYBFou0syraIm25hWIMgED6J+EYTgdT4RbBOPeYCl8afnqU8rcrq0Qob3G+YTDy5raJ
	4R4i00E0bzYZfe5R3agkDQgAgcJb6dfDBA7tzN0vQcafNx/fi2r40mMakpwg5EcgWiuEF+Mg5WF
	cycZALgKwi0DqAG5620VND0wEq2I/kL/AMCAA19YeT+J+i9AZuE5WBU6NWeRUVuNyIrWU5q5dPZ
	DeeKsf/mUo7imYs9JIpUbr4JvhQ0Tm1WC+HXGJQ/T7y1ltSTD4XkdjOnu+WfCRGRiCeGeZj1H1B
	uq9rbdJBMFWslKwP6hXM0yPIlq8rlHU07JWb/rBR3Tw43tEtOCZcwKr2VIp77gixCLA=
X-Received: by 2002:a05:701b:4583:20b0:151:ceb3:e105 with SMTP id
 a92af1059eb24-151cec32443mr9674795c88.11.1791191358038; Mon, 05 Oct 2026
 02:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
 <20261004083036.613169-1-kunwu.chan@gmail.com>
In-Reply-To: <20261004083036.613169-1-kunwu.chan@gmail.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 5 Oct 2026 02:09:05 -0700
X-Gm-Features: AclHuK93ndMC4ovSjSP_cU8HjtSfyaChQiTBQ98ae5wltCXWwtXcA60S-czM1oQ
Message-ID: <CALa+Y17BOR0DBLS9-vns2SQfRhCueT0f82XCVojHhg9uacOX+w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/9] mm/damon/core: replace the access report
 buffer with per-context rings
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, Wei Xu <weixugc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8858840007
X-Stat-Signature: oejwxmhu67ywuxzypq4xsrnojzj5zspc
X-Rspam-User: 
X-HE-Tag: 1791191359-997691
X-HE-Meta: U2FsdGVkX1/JZrGcaI/AEb39prYfZWOzE4ZPH1H1JI9mAb/yaYfcZr/OJ1xxrTSlvH5PALDA4eylr87iO1QyDw6yEQ4D7jVHwn38l6Lhst2IkwdeAHLjI+Em8ii24qbKLJWh/x3pOQU6goHh9Ncp4JuxloMHmoJcWKldOoFv1K3uL+23CFuPJKG38npJLc9GNSR8w4VkX0cNuEdjtfSwr+h4Ls1IYXfW3J+5ePc8ktI5Bm10o3o5J9gJjRl+T5SnjIur7BTS27g8dtc/wVMomW4uDvGm7+MAD3SryVLiMQLuMV8VY4ePb7o6RXzdGf2n4c+chPNiC1MyKMYmPG7f+R0E8TDyYODeo4Ig4ij4qgKdAraBdjfhhvfiTmdwhzzAjTkqD462wfg4jLBJ1nT/MMIiY6jmgZWoYC5EJH32T4QcnPNxK7xMjXn2YLmtZmCSWGLssitsWu+D/NAQ6Nuf5nuYmVmkhAx8r4ww+wA0rbYV/SyIUNexuj5qGr4spWAbbk94H6rB8IG06ftHl+FkwQ2XKN3ZObalPT/kTWZ+2IIQ7oWQecZILMZF3MbwrWpwzRYn4cWPARKpyggswQ2uNp1WTHg2WgQJF+SIz2burbwfEkE3RxbBewOoLqky2oxh0WkqiYaXU2c4ZPsZ7gFAeIWJERBPtx804eZFR5e6OkRca2ulfJnkEb1QbUfhwRcLphOCod+Lkd0melPfpEwvz1npQHZO2YjSgd6J2ZYwZ64v5lpXAWztvf5IjAfWORUMc5FqheQi4txivqOAuQGhkL9i3tz0GD7S0kmMoDwnrRMRH39x6ZiofiEQ9Wfx4HYHR8pEehF2WoKedN+uTPGZXonwBJVdxnW63k585i6gmPsSYTgwECCmZglC1A5puZA348klfu4Rx19MgIuP1Q+4F4GvuxJpHnSmxkwYzflRNKYEo/TqiD1y2umVy+lu752NKrBA+e84ThkooG/YI9U
 Wuleszmq
 nWCHbs8FD/MnujSHRcYz8s8SWcQgVFG0Km/1zhmsUC9S8w7vzDzNxncAT3N9mpe9ayAa9aBDDI2K2Kiajk15izOd/WPxr4Qlq+78ZKzSwJswsxvCh1yffPd8Y1/lb5w0qxoTMZBL6pVM0F2hYglCD9ej2gEKUMsAuw0Le5JI9kfsjpECN90H7/GgupGCi4iXKIku2XhuVVAiSEF3I5mgUojHlxxwdDBnXM4RUjZN8g2hR5oLbYqQG5nSgXJT+x8CSOoWMpU3iQnudvoWJQnE+aSTztC68MjWAYoXUSj9LKaNwzq4hFqfi5aCJDaK/c2SocuWVju67jVXXYHzuOytAkImXslrTXOhe1FxOCvPyfE7IY+gNV4UyB05jpDR5hOdwdGBhXZrT9pulkAvkIk/fIl+q5Eh7eAZtVmoSjsBsnlKtLh1H1Zej7ATmtDljDGMNqCoOl2mndvGt5+VALnfgWNUueRPhtZOJQHkvqAyvtOwL3FjRN1WKTd3HDKdQhPAr3aorugQ1aqtvPCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

Thanks for looking into this.  Yes, in v3 I made the drain raise
nr_accesses once per drained sample.  My intent was that a region
receiving several samples in one interval should show a stronger signal
than a region receiving one, and it let the existing access-pattern
schemes act on the samples unchanged.

> Unlike page-table or page-fault based access checks, where an access
> report is generated from a deterministic access observation, a
> hardware-sampled report represents a statistical hardware event whose
> frequency depends on the PMU configuration.
>
> For the same workload, nr_accesses may therefore have different
> scales when monitored with different PMU sampling configurations
> (for example, PEBS at a given frequency versus IBS with a different
> sample period).

Agreed, and that made me look at where this information belongs.
DAMON's data attributes monitoring already keeps a per-probe hit count
for each region, probe_hits[], which the probe weights apply to, and a
PMU sample is exactly such a data attribute sample.

So in v4 [1] the drain no longer touches nr_accesses at all; its scale
stays with the access check primitives, independent of the PMU and its
sampling settings.  A sample instead raises the region's probe_hits[]
count, at most once per sampling interval, the same per-interval bound
a probe hit has for the samples DAMON takes itself, which keeps the
count within the samples per aggregation.  The meaning differs a little:
DAMON's own sampling tests one address per region, while a perf hit
means that at least one PMU sample landed in the region during the
interval.  To act on the samples, a context sets a probe weight, which
puts it in DAMON's data attributes-only mode, and its DAMOS schemes
select regions with probe_hits_wsum filters.

> Should we document this distinction, so that users configuring DAMOS
> schemes with nr_accesses thresholds understand that the value depends
> on the hardware sampling source?

With v4, nr_accesses thresholds no longer depend on the sampling
source.  What still does is how likely a region is to get a probe hit
in an interval, so yes, that should be documented.  I left the
documentation out of the RFC until the design settles, and will cover
it there.  Since I was already respinning for the v3 review, I folded
this into v4 so that there is a testable series before Plumbers.

[1] https://lore.kernel.org/all/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com/

Thanks,
Ravi

