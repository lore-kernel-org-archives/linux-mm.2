Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C12CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 16:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069768E0008; Tue,  4 Nov 2025 11:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F355A8E0002; Tue,  4 Nov 2025 11:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24DA8E0008; Tue,  4 Nov 2025 11:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CED888E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:43:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A87559BDC
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:43:50 +0000 (UTC)
X-FDA: 84073496220.02.3D0304F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5082920008
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:43:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Fb2u6/0b";
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762274628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fM5+PBSswxXzLdwOdhvkglB0greVBJRLxOBd9y+PPTA=;
	b=jkFsFIyQo3o2nHPKobgeTVk8MqDk51vaTNnxH7JcZpcH1WTToZ89p4i291/XSuUM0i3sk4
	Ejkwx4vPlUmWmDMlcGl57R2Tz+eT7hqt2ZYCHpAMIN/9KQ1lsN1z1N6AQaTnGvQzY5gmoQ
	7LtDf+0Gyz18ar+tojUcfkuDU+lRTLM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Fb2u6/0b";
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762274628; a=rsa-sha256;
	cv=none;
	b=UnLxmxrVXdtDP/cV64i75hZLfJchd6HmePD1rpUuzmrJVwj744MqO3eQw6PaC7RYkoD4uE
	Aqdw0OfIiQYBlZJN/TwZaj+wAZd1laytLl211j/jGtJNvPLVfkL0HHrAzIKzvFmz0aGfvj
	HvDRJfWtRKxBemzKTBfKz+6toO5s/2I=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso1468513a12.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 08:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762274627; x=1762879427; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fM5+PBSswxXzLdwOdhvkglB0greVBJRLxOBd9y+PPTA=;
        b=Fb2u6/0bIzpRZ+D6NKXVj0W1Ekv/ahJ8MUavVRkbDud0KIXNVUr6vgRrxG6CvXqQJy
         IImSRbBy1weuqpkedFVNBGpDG7yr1TVB4y9AEQbjnGY4FvHGb6Sww5GITmVE9524vmvP
         r0LQM+hlWikVTqk1c5hGaJXSDza6pmG37AbhhCWrZqEz7Fa4qyXPXY75tscZGP1NFzAk
         Xpcni5MllixBiKYr8/06il3yrCzLjCoQua73FGxkm02EPq0FjfDlmxQLQZ6rPOC461LE
         MQEtlVdqSGzIQDCNpMIUnqqaqRq7OCCqhBpNsH5FqqEhU4FeWs6sQ5q2JhB2h25h6azB
         v/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762274627; x=1762879427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fM5+PBSswxXzLdwOdhvkglB0greVBJRLxOBd9y+PPTA=;
        b=nDS8kU23Pk9DIIU9/3/XbwMSYVSBHixgBiBWDsX5wz3gf9CeeJF96hYdXzAJ8yPUJD
         7X1C99ZprFp2Zl8Mv/tIKZUDqEQk6ww9O63y4CBbj97LiNaj04EQVRiLUGndscojHjNV
         RuoVCg3p2xTGJKv+JWbqAPED1F2FnpeGA3gNqoLpC9sZFgA9lEpRgHJ46a5YjbdarJNF
         zFa7CTPk0UQ1qMpxuyBhbofq7f69a9LYKbjqdaZ6aEH9HvdiX+MS64vyRPYnq16EtdN9
         ++MOOd5Pcuu3Q5vzzoSnmcSIeuHJNRw/HQoX+RI/Ld4fDGy1A7M4jwRqx6o0Rz/94NfV
         WGWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+ai1vV/1sTPGRXM1ub580KO7gyFA8ugqNDW2rkL9UWz++zIYVYlqyu4E/aEEhDKFxpyvQaRqHsQ==@kvack.org
X-Gm-Message-State: AOJu0YymM7qo5lnlj4UPBDBN4YQsXWEQzSRgjofxCXOLlhI7wb4xRMNT
	fjMVOlMNY7S7GpLx1ax8aSZIX0dYgsyRZokS1EKdFcijBen4ZsLavROxo+szqFj+jz4=
X-Gm-Gg: ASbGncuGLK2tges7v7eylbHwoKryI20HZ/TUVskwFEzCTAO8GzLhYJV7iHs23dtEAxd
	hiw9iQETQ43VjXbtsFh+qsnyRsnATAhBDgOmRsRpT46bdpPN+1QukfZlVzwZRMTuvgM9oQRdWVe
	0UPoWErRpbyGivce5FmrFRaD4ZIQ75sx72nAb9JIZkyQufqNOdoWO+0YB21PDr7YMDqIOSQf/hR
	B93v7HZI9yfCeKjHpUWftLORR7H3jCgOoJmpXtrdvtfb+3/rxgQZFAMqL/5SfTwG7btkMCg3EhC
	UcnHr7mRmttq7sr2NayRu7JD3lmA2hBq3ilmEHe3X5LXV/BO/2qUFcm34YKqFpVXcBZyeoIt/DW
	oDy/MB3l+//S7ldgJZTyqyg107bfUtC71QtkD9l8/jTRp8jvyfvrQN77MJsE0TSHtg8U0yK+RRQ
	mFErl8N4Aoeytekg==
X-Google-Smtp-Source: AGHT+IESytuPJmvxrRFhh/pGCnZWqMW9IlccppmJPewnkjFNqWqAJclk3pildnpFQqc3HRtW5xR16A==
X-Received: by 2002:a05:6402:350d:b0:63b:ee76:3f63 with SMTP id 4fb4d7f45d1cf-6410316dacdmr201419a12.7.1762274626659;
        Tue, 04 Nov 2025 08:43:46 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640e7e9f89csm2367912a12.6.2025.11.04.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 08:43:46 -0800 (PST)
Date: Tue, 4 Nov 2025 17:43:44 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQotQBjnDDeL_wHx@tiehlicka>
References: <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
 <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
 <aQh1EmVd8IPHK0Gh@tiehlicka>
 <aQnV73KorhS0AWH5@tiehlicka>
 <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
 <aQn2fIcj9LduzsmI@tiehlicka>
 <188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5082920008
X-Stat-Signature: jtihc6wop74oggdnysdeub68p6n6sj5d
X-Rspam-User: 
X-HE-Tag: 1762274628-68328
X-HE-Meta: U2FsdGVkX19zJi8ilCu3m3hLB9KfLfTZpnRA4Q7Ab+6IqyMAyUpwE6ZKgCpMkDT7mz/Nn24sOR/aBivsNsawMeoozKQ31fR4RtLATvghAzsO5oCsH+7dtNJ4nZnEmrhYwHqO4IGsXLfTLmn2l/w4GAQMB0t2RHWNELRyHXP2+YGWuZzOfhtaUdsD0ZFDseP7uwetj1M6S+0n7oFi335aJYSPkYR5AwOpzGNTE2nxKnfwJzLjwnqvLixXi6m3awF8a9v0MtCoivdeR5QHuBhL9usItKTr9Z7eS9Js+H3D5iZN1kEXGy4apU3MnQo0EsMqBpn1SsLvWBvQMJ5i9Lg7yWE6LlL1lLmwWBYHmAid3tX6wymnI5bnwM4Lsda84oDleL26zBDaZRh5LJYVbSfdshM2eSTs2vcm1WC/GUtIwm4x9CWi4+HIAuV7Xuxd6OlJeOYbz2aGO7T/syWZ68gN27ngqHuOE1WHT3ZXFEF8UOxnsa+wTIwDeJ2lMi9AMhhSXtEHjv+RyKA2iMx2HUkY87X0/fPkYKMGB5wuMbejXhOEQNTL7d/WdmB5jJywLpK7iCUuZysWBnwKwPS/YEK5lQAL3csv7dHyaV2c2ALJH3taMT4oLxjF1sLy+5qDAZ9cQmkiW/XKrgIUHWMGZs9dDFIyCXcJeBpQTcK1NfX5qRP+9x56/7qM7G4CTdnkXyYkyp15zC40Sk4Y8VB5sox5cPyBczrsZzl44MRN7PSpjmFeItXmDH6QitnooKFK2/WwXoGx970TAPrQqRoXVmk2+NH30yB5TwWJ4dLteeMPpSoo4otdFPXJBIeBThVU6SxRb2imMrReDnQt7skXL83TgK74oflya/OPuvnebez5/I82QH8ckNRqznrNaY/Mz/vBlqpYvdzp7AHSA8R08cMKBjOtBp8W0PlGL2qPgP2aAYAp8uoIbdWvy+ZLP4mXFrWcpEkccQtEsQTsL810cYQ
 vvICuB/i
 RS2nkkcHC0hVOIOJ5MpVUDiZ786a82NJmi/ko0LNHpJ4Zf2I70XguH0eqZbsnXtFhmzPxOJC2PINfspEgGkU0EgAVZaJ/hdtgzyIxQtTQoyerDpeD/xlaEI2V1uiINL/q0bRYC+5eoDSz/T3lIdS65Jm4fK2tWRODDLrjz8egKg8BkM2Zc0wbUZgUNb5IUwcGmD+Wmw7x8gYy0bUWHf7SKwAh0jTDW6GjFDgdUYTRiNjwB+/hPc6InUif0eK6V/iJBFaenGHvUUJfLeRDvF8SIFhlaxd2Gs7LEAJx650UdScGkLMOYhK25LmouWQ+yCVE4R2aA06lRmTo2O2/4BJqMgYMf0s102PSJgzn4ZFJz2uNjgsEzr859jS4sJ1E5PS07u1OGADXrHKAsFLIxpZ9n+czSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-11-25 13:57:35, Vlastimil Babka wrote:
> On 11/4/25 1:50 PM, Michal Hocko wrote:
> > On Tue 04-11-25 13:32:52, Vlastimil Babka wrote:
> >>
> >> OK, it might not create an order-3 page immediately. But I'd expect it
> >> allows compaction to make progress thanks to making more free memory
> >> available? We do retry reclaim/compaction after OOM killing one process,
> >> and don't just kill until we succeed allocating, right?
> > 
> > Yes we do go through the reclaim/compaction cycle. Do you think this
> > warning is overzealous? Th idea is that a flood of OOMs could be easier
> 
> I think it's too odd to warn for a specific order and not that or higher
> orders. We would risk someone would make the allocation order-4 instead
> of order-3 just to avoid it.

higher orders simply avoid OOM killer so it is effectivelly retry loop
around the allocator. Order-3 is a bit odd and that is what the warning
is trying to tell. But fair enough let's just drop the existing warning
and see how it goes.

-- 
Michal Hocko
SUSE Labs

