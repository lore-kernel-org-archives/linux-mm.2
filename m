Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86335E94636
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0F66B0089; Mon,  9 Feb 2026 22:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EB06B008A; Mon,  9 Feb 2026 22:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1016B008C; Mon,  9 Feb 2026 22:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96ACC6B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:21:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3340813A405
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:21:30 +0000 (UTC)
X-FDA: 84427096740.15.A60B9E6
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FE3A1A0007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:21:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UJqzpTq6;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770693688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ob3kxBXQR1nXrT3YxrZjWL/CSavgOmgr8TQZqlOyF4=;
	b=4JAeuwIHfczWi7RnM0pU38uQU1ptSWyjS9HcPyz50e6NyRIQt5h4Ccbe9S8GpmSV80fry4
	kLrOTOXce2ZLL3CHOasnu+DJ0YosyfoTOVXjNNkr/Lz8G+kcjNaHZ7VuyonClF08Kk+mxC
	DycZ9F+mcHcCUUjqBFUpclm7So410pc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UJqzpTq6;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770693688; a=rsa-sha256;
	cv=none;
	b=52rdYxOQGW+atzuoMIRNXVIRhMeouXAmVXKIKgat77Y8PuUdn7BeNozpN9x2StbpCd7Tk3
	qjxev38ZWTpiAUKP8w2cZsJ7FFvXXhxuRIH9oGd43sGG1EY1mPatyveRtBnsgBzXnuMOFs
	5lrfrkqMAGqT1ejLWDuaBiQ9UXSwPJM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a102494058so28220925ad.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 19:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770693687; x=1771298487; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4Ob3kxBXQR1nXrT3YxrZjWL/CSavgOmgr8TQZqlOyF4=;
        b=UJqzpTq6wLRqFfrLxfxz75IGtI7FXEw9AOcoP6Qf5yTiD5dchG+d6cK/sqyN7G+fSs
         FPFVkQU6Ffhw9zjDKRpgeZtyET1ufeU4kceBDplDYyUTVEVQin4e8n1JIGg0fPCxyqRY
         BxBCGINKVmsg+keKzvgl293y9R3y0J+71ZJ9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770693687; x=1771298487;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ob3kxBXQR1nXrT3YxrZjWL/CSavgOmgr8TQZqlOyF4=;
        b=LLfKa8FAodBqxzVMzbxpV1m5g9x+V4nFs3FrGSzDuiU0+UjAogWUpbajz3JIwS7csy
         LBSOlOR71IVQ//XpbdObVYg12CEFfUO3S+MjVwYnEpICdVTq2NfI66OwfAsJZ5LP5EiN
         i0TU+UyhZIQhRSXSh8oUP7e/BnPUdJDLgSrJNyFbNTgc9phw7K0Z64AwxlYHb0xqsR73
         E1xF6BzqFbbahYz4/Oef8yXne3Yy4ZHI08h95MBe9zkUaipzaIVbggR1XU6n2f5RFAuq
         jCCvyQ2r0hyOgvqdXTS7GTNKPnZLolwkXGxztBaNILY1moHd3EulUHSxscaJrztYeFl2
         HcJg==
X-Forwarded-Encrypted: i=1; AJvYcCXbcUPa57GoPaZ2RQAPCNLf9RBTeQQ2GklCPFh0U8CdX84/WqRBitpXs56Hw3Xz5TtiTh1mjNOwbA==@kvack.org
X-Gm-Message-State: AOJu0Yya4ePQNISVL/iYzUwPbFrrwN6cOkNWpuX0Eue1I3OG+XtGxQvx
	r2DgaL8xEJ9FjXCqDjzPk2ujgrP+/JZ8R0vNyQUMiZN0XLlCahhgXcdNAGOeAag/Sg==
X-Gm-Gg: AZuq6aLWC9wEa5k9QoUcT/Zabmdg787e0bghJAn80UPRJw2PqB2WMJY5CvLXAZswCWZ
	7o4vDDJd2kgpsiGxJZ0FUaPgvjH05Fne7By9FPVcXX+RkGwWeR+CHto9kwu/pOeoEg616ALqGH/
	/Cwqj6mgEX0upWiTKBiBuoes4tKQcvHFuPazPUnfuo6vlZ7JgvJeC0bZeFvhLMlNsGim20aqHeP
	Vi/uA9DQQnh4s8XRh3D2BCU8ksOpSLDUPhS4boQeB4NmRZyFuEb6b11sXpQ9pjRgbcBYWFyao9y
	SNaITLMex0UQQ1gyssUV5d4WFol5i81gT6nKVrcEi5aUAv+MxIxghoEdoJjKS5E3HBl29P515e0
	wnQl7aaDcJCX9iTKJrHoWV9iP6sEnZQEy6zRH1b5kdjXzu+gy5iEsVcz4Ai8UE1EkvR+J1JCtOi
	Vsr4P8Ch6aKpgnLLdx8YRGT2/oLFUuviGAy+mo4eYJKXiVuG8GNshC6J4jjI7HP6GwI636qdg=
X-Received: by 2002:a17:902:d2c2:b0:2a7:a3b3:3229 with SMTP id d9443c01a7336-2ab10059624mr11091755ad.5.1770693686957;
        Mon, 09 Feb 2026 19:21:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3f6:92b2:887b:120])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521eb939sm124285915ad.73.2026.02.09.19.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 19:21:26 -0800 (PST)
Date: Tue, 10 Feb 2026 12:21:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
Message-ID: <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
 <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: t6ig31xppe64domts9iup4ztqxbrbkyz
X-Rspamd-Queue-Id: 3FE3A1A0007
X-Rspam-User: 
X-HE-Tag: 1770693688-133180
X-HE-Meta: U2FsdGVkX18bjh6e26Pf0HG4VznujzXSpv9eL+t2R7i/x3k9fbc6fvHP/L4PefPdafYFqPSonLcyDDSHuJTCB+kL237YTc7IaStBIR+XupyvApPS5SB3MzMjgsKtgk+Fs2XxSKipSKVnQAfYOWWcyODt4Cm6x60nMueNq/NrHJ8ozNFZ83PioBI2gDI4/LUFMZ/l2Q5MfXoBq9BS9hu4+0ooLg7N3j4iScNtiUlMzmPOB0ZGWfWZihf5mIY23NJHLPrsdh4Mwu7inbDgw6WIwOQ2R5HEORxTXV4+Kd/u4N76uTM7rDGzqfkF/JcVadCQq+opQXegxuUcjqFnqmmjYtyTVoIDb5OqOvUDy7MToTjFbr5Jaxqlw2s3EPhxT1Dv2mCT4XiQXqBnz7wKJrU21NELZU9eex50tvsKGlLq2DcwsvUhFql+MeO0/BtS+Jex2+JUzfvL9/S0iifsnbPSmoAkvcVHZPiomeTlu32n762APJdrZ2w2VKnCyv+N1oIIujd1WOzHWVv4NZ+UDE5otk8oUnDKciLSeTK0foI+DbuUX0WDRuhKUdga9ac0dDuhBcJYX4mB3DOlgT9azlN+L7QbtUHu6XsfhJCUD9YowZRcc3frdqpEzHD9Zwfo6XKon7LBjMQjIiJWDr2xSQFV1uRRLhr6WJA9UgLIQQg3y3vH7+H+a4HCYug8RJmq+zoulmshORw/QnYXEfjZrLRlX9f3sX3mNkSSZkY8IU3oN4hno6UFu+SEBrYh450ZA/BvwOf2NWfTVwYxkXx97QP1GfjXI2UaUyhdZFb4iu+U6I+Fa21hdwwWv1f5xX7AhWQ4FVAFwUvgCR1cJqxSaXP4ON7NfptgOkp4qxKfobML4zrD7qfvRU1ebHtljl9MQHbSadAyPf20ThyJvBKFJboldCgFd1VL0yhIqWVfcM+yl5Yb76iQGJgA7kxHG6F9wT+eApRIGQeKMmoaOl2zc4A
 fx47GvwW
 otw/BM5lLoYrAKbrGoR/+3hSueJfFBjjF2Xe1SwTNBY7fqYrOCR/JBKkrWgkkUhxHE7W6o32duuVNfxj45UjmgwHrbOksLjrRSmLFYbEnCFF3sq1jkwKNiDysiA3HmqCe6t27lZzmDOg34qSbfaLVaNED8T6ldXnyGog5uh+40RkKVhA496uVpU+yUPoqxSYJ0GDtv/mAHEPXTALHMTSA+29o6A7EPlhb1AsYJIG1qh4bLzvLoDpFCZ0cPx5zZD2F3qZ05m2ZnJG96+A4ggDGb5PKoEXI6nGihCChKBW7dFSVJ9NEzfORWIb7mH3ocU48CP+SOxqS6UxBFa/jCheEsx446M6cyQrVNiSVmMhk5gfwSh6yMz3tiOEXGUYBnC3YJdY5qS9mQJjTvzBIHG48a41mKeu82127dUgN25bAJqOdx/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/06 10:00), David Hildenbrand (Arm) wrote:
> > > I recall that there is a notifier when the system is preparing to
> > > sleep (pm notifier or something). Could we simply hook into that to
> > > tell khugepaged to suspend+resume?
> > 
> > Do you mean “struct dev_pm_ops”, which is used to register PM callbacks
> > for devices? However, I don’t know how to use it with a kernel thread.
> > 
> > Also look at how kswapd does it, kswapd also uses
> > kthread_freezable_should_stop() to check the freeze state.
> 
> Right, mimicking what kswapd does sound reasonable!

I may be missing something, as I'm not seeing dev_pm_ops in vmscan code.
Would something like this work?

---

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa6a018b20a8..c5d89ec223d3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -394,8 +394,12 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 {
+	bool was_frozen;
+	int ret = kthread_freezable_should_stop(&was_frozen);
+
 	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
+		was_frozen || ret;
 }
 
 static bool hugepage_pmd_enabled(void)

