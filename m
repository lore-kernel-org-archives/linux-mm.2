Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A67C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3651C6B009E; Wed,  2 Sep 2026 23:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D716B00A3; Wed,  2 Sep 2026 23:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255956B00A4; Wed,  2 Sep 2026 23:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00C116B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:06:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8540A40410
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:06:51 +0000 (UTC)
X-FDA: 85170963822.24.1EE74F9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB33920006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:06:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J4Ns+DvD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA6TfANf9Ze+7t1hoZyjavPl8IZuFIwVPXJVLouCJ0o=;
	b=WZnSpp1G4O5dtHNjS0okkANdvoNHXUEueC8ezRGoq8nqplphqHDpYs3sA1GWL+qqDVjKjA
	55A0rinq7ikFdhhEUrrK7nmUoTTJjfKNoCrEno3CbqHWPRpOH3uO8IOFVrEsaFLmZLi9CI
	K99snaCnBKn1/MdHcpSjYFJxs/bDTvw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J4Ns+DvD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404809;
	b=cOX0pgitivG0kXc0fscGBYVGktnungSWQpMjYLS0zFPEE+6Op18TA+6PQMgWvlRW8WBod8
	SPjst4SKb9gzM+5uA8k5uBpZakx5OTNFJlwrVCN7uF/ARjiU52FYHqvj7QdZzrjV9Go9cV
	gzAqUonKFlFDMCNfnmL50nJnw7ads1k=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d5cad1a6baso17358855ad.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788404808; x=1789009608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nA6TfANf9Ze+7t1hoZyjavPl8IZuFIwVPXJVLouCJ0o=;
        b=J4Ns+DvDaFTn9gG0tcC0RSnkIFHQX7gpr5MIZ+cqzvEHQOaarzPVPZxPExpPel6dco
         ZypNmoGz+y3s4fcb4qnFfewAlOWecMG2HfQ6oCYFi9HymYgj4cyghGql/oxQzNlKkoOk
         q++dQHO6A/i+HKIkb9GYQlfl04Mzy06KP9CqQCyD3G/RDOMrFQ17/3WPbKgcYq1M/bz5
         eGq2g+PlKjU8esxeafXQXc4KV/5MklTSeCW6hthV+/AsJMM/LQsD3BxR69RNpiVzzz4B
         YF4mCeKSsyYRewzugyxj+2/AmPsq0JV/w/cVqgZ83ZNTmavLRpWR5Obc0gkmTKuQDi/8
         dLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788404808; x=1789009608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nA6TfANf9Ze+7t1hoZyjavPl8IZuFIwVPXJVLouCJ0o=;
        b=iOGPNy8Dfdlktv2ZtQy/uhhV9tudnkO28WO3MzIM1/ObJTKAp68GR0rd8MuojR4jSE
         uBWGAG/ZpU+ZNDVyFsW7hmn+ZuSu2ocuChfA071ivqXnA245Yu0dldpYyooFbSXNqL7Y
         pTUt8pzWy2NmmA4+quHRcscxCXRI+jfKM9Vz1EVdrdOW2xA0p6rd9GuPQhmZYyz1E/oL
         bDlCn64Xn5Zv02G+5LGuqjv3OVIdumKsSEZ+uRYYNiVhpGQyxXNckxL6xEPJp27UsJ1M
         U4HIky14uYoL4hAzfe5KefpUGx6n6YyshiYHRj/m4AA3wvoy1xryhKEPAft1aEKFH5Zc
         DSZw==
X-Forwarded-Encrypted: i=1; AKwUvBwO8zsJWQk6VCu8KrIs38EStG+N5lcXnssyFwZcDYTzTEhgepnu5EHtd9ot74rKgd5TwHoE6qpSaQ==@kvack.org
X-Gm-Message-State: AFuF++nrFaaojMQKheHGJoyaLtnRwbElcDOQLyJDR8jl4lDPAJWKs/u3
	RzWhannB78kcf+Q4aW67CY06QEl6Sp42uQY0VAiG6UBaZ2W52+fW7XhN
X-Gm-Gg: AYBFou2WltkLkDqS2UhjWcMEfLiDh6dcgqP3F3E6x1soCVRf8wst5FNCp3/aBRDHxy7
	Bl1eeyc+0eNfCnHHhyx4U/uXBSidtn6a/rY2EWnEt24qdnF7n6wHwEzmIOjahCILR5CEaub1Ku6
	h7T2+mflgHskSJUfzPXTBI0DqPtMnPmPZBZrvMnMcfoGEDqw42/GLVYax6AqNXvoPoo/aPjWwWZ
	8ExANMc+Bi3H8mgulfaQZFZSGZkdC1EjuolK1/Ckm5wwvvy1IGNWjQJK4t/sB/H4JTKxRHmw6y4
	G4b3vOl1xpXw8GiVi0dFJqmHRT5fjE31abyi1/wbxQxA4VBNy6hQklA2fc6K0JV4MoS4vPOCwnZ
	rC288Ihq509akGUGMzCzAYT+Ty7qvAfKQ5QLlcgYbXRtdY9o20NEHUAtp6DXKz9sDAXhb7TZLsu
	yNzxuMrcSBqUTgufHiS08fvVcC4MDTwqZ1FTk9EqIqndgrRDBUGxWDVKnrCDM=
X-Received: by 2002:a17:902:d547:b0:2da:e68f:45b4 with SMTP id d9443c01a7336-2daec641a74mr132974085ad.8.1788404807892;
        Wed, 02 Sep 2026 20:06:47 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe0cf327sm2889785ad.11.2026.09.02.20.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 20:06:47 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 10/12] selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
Date: Thu,  3 Sep 2026 11:06:38 +0800
Message-ID: <20260903030639.321705-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fzsof39ay95tt5qfhr3odj5cz4oshd9k
X-Rspamd-Queue-Id: AB33920006
X-HE-Tag: 1788404809-908124
X-HE-Meta: U2FsdGVkX19JWgJfMPeckpNPlqvFoL5j7gziqxyeA+wD1TavPCx4xaHUAK8L2IiltAZvBHXQ6eJwrYaZHhD+kIGJpOuhc45v0dmizc5dzJCmmzmUsRYP71e+LYq2yeNuH4BbvEnfSRn2VijqNtylz4T6VXrztbe4nIIpG2nE0hT8mMC3VKCvi11b9v4s3QPEH6RELGeptG4ebyNEE8nllq4LhYMCalFIw0lXf1NbqBy3kqjGO56iJWgzbONdPb0KSnE++kaPgyf9cWM+32VDl+KaIhiyT8hHTwf9OXIucKw7XyCOb3j48qRBGkbHFXx/0G6LjOPmdcBpBRM/0h3wp0xPxTS4B4DS1+MXrJbqlEpA6Dl7wMvYA+mFaQydy2Bitv6Vxj77Lws1zY6gYul5Z5DiSgxxC1yOfmxfgB1qyhAltKohn4Y5+tRjcyIYiniWVUCkJJBIjBZrn8UTmkDw6Fyoo3Ji1ezvDxyxvv1nnTgNjZ+1emuMG3zmryt5K826yoiacwZRIG2c5GjyAZm+gqjNqAvuwF9L1FUsVLMTtDtIv6J30M/280to1mQ6AowwsWCsN065DoCJiuZtbdY9Qf82NlHDPXp0LeqYLCFM4AXUmC8oDbwSB6kVfbHWOQAUwFLN2IhHYSidUukNi+AVt0TPiFUCBSQSBum8Mcc/MQrD2VOgTIkPYnZ4NaHITDzD0tPy7gYgrVgnWAqzJr1mqn6zDIft97+EV7OpPuk7hzGk7YMKseFU/1pMHwMDHI7bGwMw7qemRJwFZI+7HenkFF5bkynLkdNAQ4dG2s4NNwP418kwg/MtTNVEScNqlhrEviN+z9k1zr3J8bdv1cE+t3xfH0XJeVh4r5fD7ub0UD+mPTBB3/6v0LM/+wAtp/PSVKfXcp4LuJglJyBKfeYYVezHXn3iAO2uSIKs2HHfo/d0Tbm2coa1VJnGoQZsuDRDllN2iIKab9dqSrhpWAN
 A9Xk2481
 w8AaC+zK9lVSF1whyjtijuw7qxV2HImxB42o6oT89FBFJyX/SOBPNqDMld5FfB1FUG2DEI5sT5m5M88D/cVSCTR3nZxs+i5UVkkpk2wdnJVQVnp2ZGwyM536+BtSXp90RGxeK9N5xPoKci/kDeTiSufw2VUyU7j64hLny9BFPPRaQOoD+NGtJvlrPywWcPiGJBP23YATTW5LvfCOEA1xzc7XsUnWUlEI5SDL1G0+Pd6zCX+s7/Z9b222kYtZXpPMY3Pxs9IO69yQFZNOgtG9Lx1pNM09ieUnIjk2SVf6uCf763Vqd9LJ06KezCBoHn26bpFkqlYFlUG9i64Ffnb/r7m8ozOoR3rksUQQF87aScuof3q324QR467Zor7vivnT6bry8ByIg9UArraTobBJ8n72RqOe4yODiKnJvFA8xymRnGVKTm53L0Td2PlohEd+m/RRY+6vHTEluIiOq75Sb3AQ1LtR8gz3J10DSPS+MbYXZbwSJmTXVB/aErA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:43 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON sysfs quota goal target_metric file now accepts 'hugepage_mem_bp'
> input.  Test it is accepted in fundamental DAMON sysfs file operation
> selftest.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  tools/testing/selftests/damon/sysfs.sh | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
> index ddebde6edabe4..b66593c9ac471 100755
> --- a/tools/testing/selftests/damon/sysfs.sh
> +++ b/tools/testing/selftests/damon/sysfs.sh
> @@ -210,6 +210,7 @@ test_goal()
>  	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
>  	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
>  	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
> +	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
>  	ensure_write_fail "$fpath" "foo" "invalid input"
>  	ensure_file "$goal_dir/nid" "exist" "600"
>  	ensure_file "$goal_dir/path" "exist" "600"
> -- 
> 2.47.3
> 

The added test correctly covers the
hugepage_mem_bp quota goal.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

Sent using hkml (https://github.com/sjp38/hackermail)

