Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B434CCE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE398E0016; Mon, 17 Nov 2025 20:06:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021A38E0002; Mon, 17 Nov 2025 20:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1018E0016; Mon, 17 Nov 2025 20:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D876A8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:06:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 736771A030F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:06:12 +0000 (UTC)
X-FDA: 84121936584.01.A77628B
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 901DD40008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:06:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RM1Q3dFU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763427970; a=rsa-sha256;
	cv=none;
	b=DvhFOMYGtokrpn34QWVORa+KWboML3VIllnTZJ0v4ll+eHHK3GfLn9v0IpfDX6EtXIdksJ
	oeh8tbVUjtmiKMDFfWAG1+hzIDPtUGd94HY84ugETnIKTIuZf71pLB1c1YSGiVAIMdiRs0
	vv2fbsRNwmLLeQkStJXhBPsghkOWaNM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RM1Q3dFU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763427970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuT9qaNyEjZfIy16bIhwfj6VRiigeFvL4hxLaIBcqis=;
	b=1tJ7x6jEDkaoqMwjGVSusAD0HIjjsvnKVRru5Eu1TN430d4BkWe6c1iB/nAYF33J1e2I49
	cB2Gar22EiqLsxYHqXuNvLHzIoV6CgrJaseS8AyX9xhqQfDNWdBAdbjzx5ckNv75kHNEM9
	VBejP0IogUTtF+USEf4yB2ZMAi5WjHY=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso2977507a12.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763427969; x=1764032769; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NuT9qaNyEjZfIy16bIhwfj6VRiigeFvL4hxLaIBcqis=;
        b=RM1Q3dFUQNtGUIZyYgFgPrPlypcgizBmUtDdBTmSuM+Q/yZnxq+i2Ioe/gn4Kj9meq
         39iY9fKl8wm/LF7Aj1xCv4ex0a6Z4ZgwWt6MGKUaw6HIBjhMcykoBM47fAF35LQCGe96
         xM4ZdyKvoDeGD8t/0sTS9bpSknsBUqvN0gazJIFugoVXD9MRs8eTSAp3IZtNYq/1zhNN
         r8iw4VxKbm1xn+R5PCufaZyGOpv9hC2EINDdjOLtUssBed4s1yPS15FSXxZFxYwdBACh
         PGlF5N55DMH/P+dDHH5itvQYQdi3oGExdIiLftXAm1O4NWcf4awcGnNleeQ5XKsHBgcc
         gSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763427969; x=1764032769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NuT9qaNyEjZfIy16bIhwfj6VRiigeFvL4hxLaIBcqis=;
        b=nMo/f7mSszQnvd13BJl8DogQ50cDZPaVoCXRoO7y0JnIwUqaUUAEcJl7yEP7VE+Ejx
         95QIzyVxSCbYtROlG+TliXW1ta46uJa7fFgtTf7mcCsksJ4/6com8C0D0ORr37GbKAhU
         GbeFjealq044yLx6RdnLgB6O0WjYtFBk2E/cZSJP75TFjAEAxnSAg7mydipJmJ/GVv6j
         aGm6N5VmfejEc147RQUIaPR2IMBxsuxz/AdxlbZIvsCB8T4PUo9C0Yk56wtx+JHGGvEM
         +mu1d2LiOOnNmGuOnT96ptK8NBTVzor5CnUOV8ghc3zVOvvb9d6XoWTJ0MyJzjYGoLq/
         FIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYc0LNc8PF6f0Gn3YDF37nyUthj3GTQv3+MOQSPNhTNgLDXL2d3UK+K9wlLygWAdvOX69t3+cDEA==@kvack.org
X-Gm-Message-State: AOJu0YxAzOZDKUTB+AesPY90ogMWo/pW92dDOui8Utg069MEXV9PvqnT
	kHsE2p828MJlF7INlYSRUuV/gaaprBEJdH4G50tiDg22ZylPh9CPjRla
X-Gm-Gg: ASbGncvXWMbXsE03daYk77no0YMsngSy/udDk49eJszA/1rZs98xsrmQsGQZk/qcP85
	Di7AuQ3fJWrOMg8ZYFuHQ5a3E9XPyF1G34Z65Rlhg3PLPil+2EAOV0XaQGjWHTvReTKYUCfWRE4
	ievtHhW7ka1bWLQej1qYidIHbtgmVocaO71/J5uliXmyFkYbnG7n9mTKaEsygi35QGj2/yGM2pU
	yGFce+AeifwjgoTp2znD21TVgIoMatvzQwfJaxhT3/AzgFNQ2HFV6ohCacTGlMQ/LsZsAYOfkoL
	MWOPy4Z8QEFJMbetqF5PqWqnYjP08yqTM0kQga+/6lNH+neu8QG242SzDJ2Vjf6uNtufFxf+Fsq
	/OtIX4vAQnv5jRthuiQSSEtEDpP+tJdNTItHleXZebnXAMe17WPmFwaLWY/4Aq3gpZO5jn6K1rC
	ME+BrvQAqwYw9zjHMnEMZF3EXebnEELkXUD7H50QhRdqKmZjWjahkjgA==
X-Google-Smtp-Source: AGHT+IFwH0TbW37DQk0Ytd0vjS1rf0XcD6M8DDxMQ9u0ZyqXmO0VVOfpW6HRgHzgDux3Viwk3VROTQ==
X-Received: by 2002:a05:7301:420c:b0:2a4:3593:ddd5 with SMTP id 5a478bee46e88-2a4abab97bcmr5228685eec.2.1763427969103;
        Mon, 17 Nov 2025 17:06:09 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49d695821sm58437307eec.0.2025.11.17.17.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 17:06:08 -0800 (PST)
Date: Mon, 17 Nov 2025 17:06:06 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Heidelberg <david@ixit.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
Message-ID: <aRvGfsZMRIQuC3TQ@fedora>
References: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
 <aRu--sVhXRWthmhe@fedora>
 <b7e215ee-fce6-4a7c-995d-8ea6625b1ae8@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7e215ee-fce6-4a7c-995d-8ea6625b1ae8@ixit.cz>
X-Rspamd-Queue-Id: 901DD40008
X-Rspamd-Server: rspam07
X-Stat-Signature: okr7i4147sz9qdgettppuaqoazntwi7q
X-Rspam-User: 
X-HE-Tag: 1763427970-576271
X-HE-Meta: U2FsdGVkX18j0V4lTCBXhAqkKqsnqsf8sQlUf2whOSRmhmFApxyQlm/SSql+P/6gZWAuVZuCv/d7joQLj56UpAfc7bxekauPCKap4zNpIbnOeVjKYoqJNWb6bl/KCrIigd6HVgA7skyshK9pCS19BOa63ZqpGNumWJIyuEsRzadx55PS+03FvZvAEhq1C4/pU6Yp4HplCJeho1ajW5LltlPVhE6hoAD6hASR4NLzt3ojg3Y8+83rY75831Oxli8xv6HCGlY7+/gaWZgwGlsfJDKlY4jOfIE3f7CBtxmqiuNCRnPbT4evvU4QO+VMgwSS4a9lDNEynWvgwctG7oV9T4DzSVVynQqN7yunl/MrkEBvZ/HLiL6DeOsedyeQYrQ3sjc6WCSLWPu51FO8s5cmln8FojPc3z754dwpvgv1ck91JzqNNZQlQFrrBiG5w+HEMfUi5HKys2bb8u3O6L3zgC5jD8lsZVX+BsuIiaPJOPOBuC/DwGbmynbiXl3i9PQWWgzXSH6ob9O4Hf6yfsGzhYCXT1iLv1+j+Ry3sG2ZYsrwvcOCUQQ0Fw+APyOa1cA3BppVXyTywUdIJf1aWqG0y7j628qfUWc+HoQ0sC/mGLnlLktqAEoqCcaW276lgwIndm8lg6r4EdRP66OvcOBNBY5NZErM+YDPVN6KWlHJ6aGLgK0h7Y9uDQamm1Orx0uakNd7QoSu2fGzEfm4VNByXWG8qs2IYV73HRmK1T8LfCXGFf4H+IKCCgTV7Eh0zlaWSMwK0WvSgOwB+0h9comdghirIexqBZhToSs5QIu2NQlnnuUuPI2IxLQw7h9AGRCxDcIMb1xKp8jM3yrgWl9V6XHazZ9PWR7uzQhKrOELsbUo4VKH4qaLp753yLfYwyZQeOztGMEOrvOSGcShaBkH/rmVyD/u8syGlOTrgkTWy0tbmPa4dHWXpPA0RLUqEGX2ArzaCIGtM2aPkS4P4Nj
 7RFsPhlW
 WBRJYLBlnJ7dqeRFKYPisagTRH9/euSfH2hb4gMLM+azcH1o1qO/FJoajOezSF4I4bhnyVYPl93TGiEOZmb4siaJhIZcM+WXwvDdQTWuKnzu1xjU6KrtLxF/+FsHYLyuS0DWHZq5TciwJRJiyMVpvugKIIK0pmUVfpmJhmm77lfXoBaDGreeTLNLCklPVPLokh8++kNe9aTgGEkeyOPiu8dqC+Gzuz6d5Iuzk6uI6DDFAFtd8hEyl2uIybhk432/gkIYq5Q/91CpjrekNClOH+NqbKjW4kRVGCB0zhiijZbO+33eyBg8Nsm5Z755iYc3syOd64Omv6kz6Wa7qe18Uo7ssypKUSakppPSV1famLkg9a3CBgUL8NBpVbQgVlul1SKQI350fsnYIOnsmQZeU7EfqxTJSf7MaBK8FF79mSMcjzMWCCZv49nguESc/DI2Rl7v5J+OnKYuCbty6jihkZT0AtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 01:51:23AM +0100, David Heidelberg wrote:
> On 18/11/2025 01:34, Vishal Moola (Oracle) wrote:
> > On Tue, Nov 18, 2025 at 01:05:57AM +0100, David Heidelberg via B4 Relay wrote:
> > > From: David Heidelberg <david@ixit.cz>
> > > 
> > > Without WARN_ONCE, the logs get spammed immediately after the boot,
> > > on devices as OnePlus 6T (Snapdragon 845).
> > 
> > Do you have any snippets of the logs? There'll be a particularly helpful
> > section that says "Unexpected gfp:"...
> 
> I didn't save it, thou I'll run the kernel with all logs again tomorrow,
> what I remember it was "__GFP_ACCOUNT" in unexpected section.

Gotcha. That's particular flag has been added to the whitelist as of
today. Hopefully there are no others.

> > 
> > > Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> > 
> > For some context, this patch begins enforcing the gfp flags passed into
> > vmalloc(). If the logs are getting spammed, that means the device is
> > calling vmalloc() with some unsupported gfp flag, many many times.
> 
> Yes, it was full dmesg buffer just after the boot and I think ongoing.
>
> > 
> > > Signed-off-by: David Heidelberg <david@ixit.cz>
> > > ---
> > > I'm not 100% sure this is the right solution, but having WARN_ONCE or
> > > rate limited warnings here helps a lot on devices as OnePlus 6 (sdm845).
> > 
> > Can you check if it still happens on today's mm-new?
> > I just sent a new version earlier today that also masks off
> > __GFP_ACCOUNT, and had an iteration earlier that added
> > __GFP_HARDWALL.
> 
> I can try tomorrow, any chance it'll bubble into next-20251118?

I'm not sure, Andrew should know?

> Thank you
> David
> 
> -- 
> David Heidelberg
> 

