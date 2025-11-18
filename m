Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C072ACEDDA4
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 16:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055D86B007B; Tue, 18 Nov 2025 11:56:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D6D6B0089; Tue, 18 Nov 2025 11:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85606B00A2; Tue, 18 Nov 2025 11:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D75E06B007B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:56:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 861B4135D5F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:56:15 +0000 (UTC)
X-FDA: 84124330710.12.3FA3626
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7406F10001A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:56:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHc9rdmS;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763484973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnZHl6EdkZmdNegwl3qorciCL3OsPRajekD+9uhu3UM=;
	b=2IhPGtxxS7zeSYhl91/gZfxY0/ibfoEHdz6KOjyhfzWap7qelbaiG2O0qlAClCWGn+H9br
	2pli3UlNSE9MpYlYEI+OFRzwbXgoSNGXkFB2ppTNPgMekrWX5F83jivTQqq/c4N/XgfMcg
	m0I5p+3jOJ7sINn26c2CzrYzbViTSWQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHc9rdmS;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763484973; a=rsa-sha256;
	cv=none;
	b=lhURGzB9FNcByUoyUtrsdFNF4F3UTxJPHSRfMvFwGLjNlcXq5m2tVeGqATy8G3/EzvsVC9
	Zf1tI2HYoMsDRxhNyNAeNA9l0IfO6UJkerJnMNvQXm6aj6fRBsIRXSDSgqaXU1xiA0Vtwf
	OddOmuGetYI822u5q/VpmxfA6qPMytM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47789cd2083so39910025e9.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763484972; x=1764089772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnZHl6EdkZmdNegwl3qorciCL3OsPRajekD+9uhu3UM=;
        b=VHc9rdmS5PlKfFPr/fO2ERhcoj3UcP28Gf3fjh9rql8TACuEWAmtsh1SgnmmYevub+
         kQ3sMfVjaDftesfA523GH3ZYPByH2ToXZZbLV7R+FC+S1hnfpmYtdcF9lVaj0x4iSFuX
         KCc9xBPjuRL5Psa1GygbcWG3W/Tf4ig4FaivvhF/MijTvoO/Fk207sm66je/nA30T8p3
         zxVQTVvjOs53JWNOT1J6KrBWs7olbNTmw79VHl0XrMJr5oca9fToIeYtT1uH8YKOQ5ke
         rCXOUSTN6gOtXgNJrrC3vfTu/wURb3MueaacGuzCc8nEuFg4AN3+9GC3Of5XVDX8Kbh6
         ecpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763484972; x=1764089772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qnZHl6EdkZmdNegwl3qorciCL3OsPRajekD+9uhu3UM=;
        b=fnKfUPptrfmSIFnJ0yxefrgxnWOQhvzOaEiSLbvlJZuwv/d2111aOXiedPKJBm6k20
         pDTYJOzS41QyzaXx/ERJahtQ03vEa/HLkG3JEhbESw/r44xEf3U3G5hItobBtVSZVcGR
         qcP5oGpCl26364B93GhF1MWnvnvp+X9ELZY1g4xSJBoE606RGFxZQgjMWk1UaPMolGUt
         ojMBBoeSDGyj4AWU7Ste6buBmVvFKf70xVE5WHDxtRvLoMZBzYhmkGUKlO/4AO3M+Wdm
         0chlwL+v/jmriXa29l6eYtzmZtAfCaMy+aOUWJqLvkcFo3FO9hwq/RVkfXVNPhw3+YAv
         2v1g==
X-Forwarded-Encrypted: i=1; AJvYcCXPQfyy1f1YUlN6EHDWCDPvJyCvvYu+rdorTdjlpndlirGb6okPUS3foj+c0Z70nT0X6nzW18sDkA==@kvack.org
X-Gm-Message-State: AOJu0YzMQWW2IFlw+UNX36siSRiITrRhCRo8OKX7DGq8NAhk6jVOgLsO
	U795+LskG+C5ALvF4VlBit7g6boPxLVkdDeGGhrmrd2ACH2TWiFZCjnN
X-Gm-Gg: ASbGncvJ9FkmCYtr4CLKASCV5X2FPryr82HcHIwJ5Svshze8jdR6dyQUBV+eSdB4tO+
	tUqb57Rfnxldradovi8Ott7QuI6Imv10Y0VVoYuyoFjf4KDd0vLsVeT38w/VVEwPbkQQFmlmlSD
	j4ZZVxXPvRznbYVNdL4KJFXgE/fSIWXQ3IEBcoRmO3VGWFNRhRrUC0nBgav2Wa8VxZ8tJRiLAE6
	aJsV5eJoK5forVAY8iAq4OjEzntDKtsl3Nh3Cj3EZFTpSLjfkyFWKh1aQVpe5sT2w2J+f/h5u9B
	aK8XPfuMHnFM6caN+vnW24iYF976MqHrS0AIArOFFCMDEfYoXdRTkxc7LEfcEew8N0Fos1a1fss
	kVpHnF9MfVKjH3XindV7GQcaDlEpcO2zwYwFsKjElaYTlAJgIOwPk7RzIK/+1aWsqeGVGA2zbSZ
	Yquqt2AF9NhvC6DCiRckdO5xHBKCTWadSVh/GFw2ekJSGciciOOAMm/l+SqjzO/P0=
X-Google-Smtp-Source: AGHT+IG7RLyD5r17W4B9aNcEk/dLQDIBHTizsXKOqwUqzCyMHcM5ArtxErg5wUnqaERmxMbOekTLsw==
X-Received: by 2002:a05:600c:301:b0:477:9650:3175 with SMTP id 5b1f17b1804b1-4779650335dmr97097495e9.0.1763484971559;
        Tue, 18 Nov 2025 08:56:11 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f17291sm33150084f8f.32.2025.11.18.08.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 08:56:11 -0800 (PST)
Date: Tue, 18 Nov 2025 16:56:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 Liam.Howlett@oracle.com, weixugc@google.com, axelrasmussen@google.com,
 yuanchu@google.com, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/pagewalk: use min() macro instead of manual
 ternary
Message-ID: <20251118165609.16c09e74@pumpkin>
In-Reply-To: <aRyOWrARRlUCeEz6@casper.infradead.org>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
	<ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
	<20251118104537.7ebf4422@pumpkin>
	<aRyOWrARRlUCeEz6@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7406F10001A
X-Stat-Signature: ru76ehd4wi9ngyxj6wny63y9u5ghkoc5
X-Rspam-User: 
X-HE-Tag: 1763484973-616197
X-HE-Meta: U2FsdGVkX1/F1pYikYu4V3+HkY/ETDJWmmFgFcqb4Xck3uP8vMY3Bq7J95zEfbX8r8n8rKcVqDNS2gkT5k3NMIITFNV6bt2ZBsvY5c+5G5O6vU8mQK46/IsTDN75GG95o39YnaiEMxARYmQDkJsbp/1VyTeFavWmY8sxoM4RlmsiBNkAs/dgFv/OdQZ3PvgBWNnQm0F0+zC6hnEqSyptrXTqknfO5V3fmTLmMfta6dY91chpM2R9lc5xVeAjqlleNjnDKdcBy6cjg0Q82ofwmVK2M7XcYjnf6o/R8izHVxhKU+UHk/cdjtpWjwCtn/mbs47uDtqzx05XsMWb8mhaPjIMSxU9a0AuiqNv+ZK6Gohegwxjgf0xNnQ3Di9Id8OrLs9Mv4k74j8vkgCynjCEcdBQfzwuB46OmU8pJfteyKyaaDU2UU9hvvXXE5KW9NqrBtW9q7SUzh2wy6bEYNqWFC/30xibiCUUjcNxXWuE1w/6puvnI4L5WAm6TVqh1a9tYlK9D/f29zQL7QKhldO9B2usmDVYaeqQfEcob4YvNIIMI94OOfW/EBa+iGfIveAW+2EblsVJLX18jQHBCfl/L6d68pl5ltNRqk3GiEWxjCT5ESzeQsb7uYsqT13iq7PO76iHhi9C/xeUaCdjf8AgYSjCZr6hH+yRvMMEuMH5Ch5o2WHiL6LYnIel/QfugyL89HvzYSykknXLUR6BXgN0h8iaX28SDkAlWOERExS0P8igDaa/G8uvvxE1dvZHq1qRR4yjL64ZP4JLnQNkeNOwhXUJQZXoP209p3xQDOY+ioAVdQXwNeDaWqFnxC0gBn0nczGCycILnyciQtOIGi/Xzg/ZLY0gTGHPOCfbqDsI685VlouG5aC+8Ujpo/dzQnCfPnv/NN3Cn7jfFUxe8WOBxnUTZ8sz83ZHdQFFm1vq1Xg5C8KPVQmc70LgeViV5X8yd2GTqN+j5vH5oLJa/14
 eLSasSFg
 uNMFJ+8epWsqqtHtlkS8fcC122A9iWYaY2ApShB+7qhCDCgpWoLWGMCnVaDhdFaMaL0VoCMvVpvoSsQmVajXHn0Cm2RVSRoS4O0ykJKk3G5UZ5wJukqV4LrH6FC29NlTrql29Wxy6wOL6QjlRbXAzrZn3daAuZRBQT1LK7mIZOiUBKXbpPv2xd/FP5eY7NpUuwg/vHcQLC0t6oAmJcsYG1ZYIAV961qQ5m+c3OwXk+E2p0D8tmOrWbkuVoVAoxPmDbqcWHofK1ZDdAEgMwBlsW8KraffXpwrN0RgotWsZPJqBpRwhUwuYeFLeZrVkSALqtTaa4xdN/2IbD+tFGNTqYkChe3B1GTlarAxHeSGbUpXLVQHP3RFDvIbjI25yPMOpaKioduDWFHbxcCHd0RUGSiC2mGRtYEroGqe8f60K0gouu8Qkyz1YdZHXOZ5hi7NNiZAVIkY/YLSwQG2MaEOORDNK27j3DJR5iInuZCrX7O+Bht2oqrPaO6w4thPnBMVO/2fSCgwMlSWuFqE6rImhBWj70Y67kr0efkbovbzq5FV3OgqBm3qZLzt9QlSnNG9G2AiPTihU3yAyyIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 15:18:50 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Nov 18, 2025 at 10:45:37AM +0000, David Laight wrote:
> > On Tue, 18 Nov 2025 11:38:49 +0530
> > Sahil Chandna <chandna.sahil@gmail.com> wrote:  
> > > +++ b/mm/pagewalk.c
> > > @@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> > >  				       unsigned long end)
> > >  {
> > >  	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> > > -	return boundary < end ? boundary : end;
> > > +	return min(boundary, end);  
> > 
> > You can remove the temporary:
> > 	return min((addr & huge_page_mask(h)) + huge_page_size(h), end);  
> 
> You can, but I'm not sure that's better.  What would be better is:
> 
> 	unsigned long boundary = (addr | ~huge_page_mask(h)) + 1;
> 	return min(boundary, end);
> 
> if you insist, we could do:
> 
> 	return min((addr | ~huge_page_mask(h)) + 1, end);

Indeed...

	David

