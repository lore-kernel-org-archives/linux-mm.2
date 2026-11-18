Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A35606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Jma0BAlt
Received: by kanga.kvack.org (Postfix)
	id A46786B05B0; Tue, 17 Nov 2026 19:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EBC6B05B1; Tue, 17 Nov 2026 19:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F5A6B05B5; Tue, 17 Nov 2026 19:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 738006B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:13:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CEEC1C3F26
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:13:48 +0000 (UTC)
X-FDA: 85446316536.04.0842987
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F93BC0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:13:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Jma0BAlt;
	spf=pass (imf22.hostedemail.com: domain of 3uO38agwKCOUJOYPZdPZLTHUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3uO38agwKCOUJOYPZdPZLTHUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794960826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjqK1ZKqoTJgPH+MFlEIuxyYmJgHMciHIUmqwesN1rM=;
	b=ND/mrPlMXAU+YDZQ31ztuOzl7yW6nHiq2/qHWPy4oV+YdrxGJreF9eHE87sjB0++Q5ssRk
	W7Vr0bRo57XVQkxQE/u9EIYnr5qt4Lu34VlcOjN/ltlpMShm1/EpVO/evu03xBjhR8O5KQ
	GiohPCV6CoFHP2LlCPQz4KypQeGTuEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794960826;
	b=RilD2KH5/C7LkDXGs1+y9nMV2k6Ia0MyB/dB3sF73xcb6qEpSj2XCCUNJt9wPNHxI7JhPw
	l6oSm4jZKWl+M0uB1WD/sLZodpBGsyfdVz/KPiikrju8qlOtCIT9gmGTt6S6vH23uEzy+I
	FmbjxiOVMfmSmJ6wjDBFCxqHPMxR03g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Jma0BAlt;
	spf=pass (imf22.hostedemail.com: domain of 3uO38agwKCOUJOYPZdPZLTHUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3uO38agwKCOUJOYPZdPZLTHUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so644500eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794960825; x=1795565625; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zjqK1ZKqoTJgPH+MFlEIuxyYmJgHMciHIUmqwesN1rM=;
        b=Jma0BAltQXhbEClEcm8yLPmwiTmYuWnPJxZAJD8pjXmoGOx9TtNbJTXvIjOCCCIylm
         V44llgEFs2oSUpwk2ne9yVO7rnXw1TIxYcK5pMIKiivllxZnLwvBQnWhLZ3pDEelZ3ON
         v0kfPHpZxtSaYgxLXiII7QIObad2IznmTWfV56bhqu7ruXRdzI+0R+rBER52v3dHGs/d
         HbG5Lz8fCBTNykXG7P8laujUk5LczR0tL1SId2dCZyjJkBST5rNtjs/OSV7ktJZnUJ/z
         Vrsccqs8kFLb8O4DR1YkXI1kHTW8s1s74Q3A71I8JYIZCy9KFAwy2Pr/EipP/P+ksCve
         kCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794960825; x=1795565625;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjqK1ZKqoTJgPH+MFlEIuxyYmJgHMciHIUmqwesN1rM=;
        b=xmWFlh7RSHZZkL++XTeusSMjsF+nzk1OeY1X2tYbNJOHamwrnNr6iZfKAabGQKeZRj
         2VcQmin2B7neMQaMhgJXdxkgfFLAT+EGPo4aMhHtc1wKL/yTG3DWv0EEvq9Ev1JT8cWC
         hYVVe9B2+HrhKhA8EuY822wEBGv7on9psUQO7prmouBMyoVV5kJ18h8x3GlOZSz+rpkd
         /WogbisfnJqb4eTKhAeMacVpYJVQW4bqE2oZQ94f2RUvPijxejTz6q8g1EBULhCqRVHN
         TbrM7YQvrhGCzayZMJIMPNT3sXk8N8Nty5zG9+VLCKu3DGrZxkwOGsJUgoNV1Huf/MKY
         U8Gw==
X-Forwarded-Encrypted: i=1; AL+hErGWDzOqyg/T5jbrjRQ9Ex3nSLcI0NGy17VMTj//SzQs9Iq+MnderFJViJpkNQ4aZmoHDS3GNvJWow==@kvack.org
X-Gm-Message-State: APuU4Z+XDZ5sva4cmrkiU3UUILvricYkzY9rLVMsPpUhrY20fOtDaL58
	QYlnPrGd+M8bTauWsnJxErtev64okxHKPQ1+rJZ0S/kM3PicUHP5FrHiT4D/OUCasN/9ErkJoW9
	dHAaIrobSFuFvAmu0sVTeyYH07wiFug==
X-Received: from dycjq7.prod.google.com ([2002:a05:7301:5807:b0:35d:1771:4816])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2291:b0:36e:ff7e:e57f with SMTP id 5a478bee46e88-3828083e1e0mr821168eec.19.1794960824542;
 Tue, 17 Nov 2026 16:13:44 -0800 (PST)
Date: Wed, 18 Nov 2026 00:13:43 GMT
In-Reply-To: <avVVRYkIAQnLC_Yu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com> <avVVRYkIAQnLC_Yu@google.com>
Message-ID: <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F93BC0005
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: gwaj3n8n8h3d1cue815ugebntuq6czjp
X-HE-Tag: 1794960826-466621
X-HE-Meta: U2FsdGVkX19l9bblMyHw5KM32OotT2/TUm/II+yrIRGmUJ7rXAgY2tq8u6mdL0ubkurKkq+HWq2cagAM0rHddpm+T/MDwgrlpC+TcHrmfdij4bsI718HJbvpa56ZehVOS1B2B1XHlMjP3JhA2UgAldai+xw8ErUXdZASQBaQ5DDBh0wD8RYeQa8O41wkeNmwd4IutIUPh4BizUsqG6M/aptODkvv2CzbZWRqeZfJRmoabWfA6mjYlrzZuHvS2VrEPEbo3kB+WGU+5+rg96yxutPBaZr7NgQwo4n6U0RSE01FqbIuD84irFwJewIFq55xZGFL5k7hjW2I83H6TXvxp1qpVCZZQ4Ivi8ZDtLdIVyZTcOpHkTxjam4tn37G1zNESqrVSmhfDPZQlpARsdf8vqwfz1v46L50mP+6kTc9DppmgdAJ0pmlXnEzFPZ10A4dfJM5F+HddmlICVSiWJAk7aTgV/gQyWoL5pn9WChQMnWi/ZUllLuxTHwhdrtcCpTHixA7PlaiYT/3lTUylcEraqaBtpaEyLuNg9sG5mO9Z+/kLkkt3PZ2hbsSac3p67KyIYD+uLXBLkqO+k7lYjXOM0O8/UmQ5I4qY64wfXAeBNvP8Och7ZO95wW1FGJih0Nuxvrr1bOzmVLmnP8TcTqxXVXVNEvJj9b6WwTD97TgxQLgJnwKi0d0yel2HW/z7LwB485RBCRKwcSNm0DaBLzUCOzT6lCJbMEp3VEP+S5+Fp0Gwx4wo3jsS23inB+U+QYZqvODE1dajQ7Yi2HUEwNdqfHlZNuWIp2K2+wpADaFe6xIyTnh3PDgAh0IAE/SPRT6bRKyUtvMpe4LmpAmpnahDbP+qi6nk5/8xRCFH8Zb37diik7vceS1CYRBOa7yT9Rhbd2WeysvFiUZL32NTct5GZybe+wcUGWW0WlajWoVB8ZVTIWTvPFeP1vzj20I+fDL5OQfhQnZPlXDFavfHLZ
 yTwlq4Sn
 XdyTrTqSCHmyfjSxgwdWqprwBgYq/BFplPrkD6gyLzTq8FvNsbZ4Z0hJ003ZtXtNTE/oh1YlLHlS6riz/g/7lU5bbno6wp9z/6oF0hw2G6D7ip0aG1G26iaPly+5kFUYvR3fYuR+NcebE/xcBECR/8IgnxGYQPhf8+5+k1Uy5Bxv2drBbeetr19uw+8Xm1I+5/HD3hx4+ZB3jfTMcs9gj9/RiXJrnsjOAwh4WCbsxalnI9GqfpLij0B+9qMLTTgIgmnWrE8p2bsfKWoPbxc8Sh6L5f/GNz9hYw5Hc13S1FD5JFEg3NG2xCqzzOGZYHPdE20a41AxloieT/OQWLJh9hLRDlbvbvX5iwtx9fAeZL1gW3YmjK297m0nSDHTMMwQ7ftnKOjiBjn6gimQwI+yuTfBf9ITJDy2rC5KPRaVPh+CaEfZeecE9V/lUbFm9GsJOUaOGMPzjt1b3QbWy6J88rh7JmADiUu9ma3iGj601LGN1S55xcwai4diBLVcId0jd5Dtk83c1mt2n9+wXCZfY+N9aW4kFs/99sO6gYi6iOJkHz6cKKk77CQrbpf7dz9a9ubU6xA1lhnM3CXRRv3S6FH4iAo+44KJIHSEpBTq9fW1vTI1ugWUt8WOMCWYdjX37O8gH6pjpW2ren6TuzlVLsXOI7D+eKG6oV1llr3cgYAidOVKPX7lEj/EkVRmbPgJKWKFlcy5/EmcmmvtDpdis0zycxh7fvbsw2Uf1SHR0nF7viH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 2:58 PM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
>
> On (26/11/05 16:53), Chris Wiseman wrote:
> [..]
> > Maybe we go with Nhat's idea (CONFIG_ZSMALLOC_SHRINKER defaulting to
> > ZSWAP_DEFAULT_ON) for now, and if zswap adds a proactive compact knob
> > later we can just kill the shrinker?
>
> Sounds good to me (on the zram side).

Thanks Sergey.  Xueyuan, are you still planning to send the 2-patch
series (CONFIG_ZSMALLOC_SHRINKER + unlocked zs_can_compact() pre-check),
or want me to spin and post it?

Yosry / Nhat - any objection to starting with CONFIG_ZSMALLOC_SHRINKER
defaulting to ZSWAP_DEFAULT_ON so zram users can turn it off right away
while we decide whether to drop the shrinker completely?

