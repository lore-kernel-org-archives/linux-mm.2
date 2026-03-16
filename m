Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B5CF013E6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C736B0169; Mon, 16 Mar 2026 05:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913826B016A; Mon, 16 Mar 2026 05:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FC66B016B; Mon, 16 Mar 2026 05:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 704476B0169
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:18:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17BF751F36
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:18:30 +0000 (UTC)
X-FDA: 84551375580.30.C44FA47
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C022120002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:18:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j2JZqf2H;
	spf=pass (imf29.hostedemail.com: domain of 34sq3aQkKCKsLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34sq3aQkKCKsLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773652708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQL4a5h5hztheILgUGktpxEkb7l9DORW+uY33oC+48Y=;
	b=3J23E17ODIFc3t8zSORbCUnbfmm719wQRUFVCwQPHOZb9V9oi4q5Zitsum24KxGtZ9BDZE
	Y12jwRGvmAbkVJT7upB4UrBS+hhsWV64aniyM9qY6CubJyziXWGq+KBRr3mxE0oP8n//Ii
	nGsYa5LbyiDEfysZZKbx8nxylK80DXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773652708; a=rsa-sha256;
	cv=none;
	b=I0ROfYLBNw99b9eV3ZkvsYuzetSW7mnfRPE2zRxBvfs2vcCJN3D1iP2m/9pwx2Qn+1x980
	EQaacKGmI4LoFElhQ4V8NqUlR1V8j827r4XEgcgJkRSB7cRKiIYNzdzQ3Io+kVh2cBaVrh
	MqXGT7SB9O4hP9p04aKp+17HqQD1bJU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j2JZqf2H;
	spf=pass (imf29.hostedemail.com: domain of 34sq3aQkKCKsLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34sq3aQkKCKsLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485375aa56eso31820215e9.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773652707; x=1774257507; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQL4a5h5hztheILgUGktpxEkb7l9DORW+uY33oC+48Y=;
        b=j2JZqf2Hn61FQhLV49SwiW+WONXtHxFhM0i6z0BVFEQXZXNMzveO20/LV+vGqYOTK+
         v/d0bcxP7+XXBEGrUedSt7IBOdX72uBZmfN0yAE2LH9avv2F5OCRrHRFKBCM/3687ULT
         XwmOGi0LTaw6XT7qFUs8WMDtjM1y/8nf/5I/wa7Kdq5KS4DyBJDLbDL8za8RCE7EhfSY
         uc846wOeS4oo7YKLRCR0zcjkld1PoFiFSXwcq/m3h431MKGdAIO77QqigHAM4cBo2CR0
         d+begFEkc4dv0jDTuWB9zF72AQlkbzMMYi6N03synfc/jJyZE08wUfetxAtOHvhYm21u
         BP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773652707; x=1774257507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQL4a5h5hztheILgUGktpxEkb7l9DORW+uY33oC+48Y=;
        b=pzi2JRO/9A8vfVxbEPGnZt63DlFvUBfKD3EUZjwYkT+Z7BK/bI5d+1HPHGD2YAv2+0
         Texpw+mplG7cSHlxVxNnZ7uIWISTenjHgByGvNBMm32ufVCmKhOITqW2/vwApK0yrUl9
         QkbdD5wvmz75oNt/208QGGZNtPKYD19BkzKkKYeQ5rpWEiIipy2AMovhD2T0CjCMyauJ
         qd/o38SvQUpZ+REVu+ZUBtb2ADPSHc3Ncc7xiMIDutC/1SMlI0Qvm5qOQpGzVa7BwmYv
         kpg1z+kBtDWjrXwDe45JtBKDz6sF8zzQ0OBDCUZnDOEdNCy5rJ1XdvCUsTDevCnvM2vB
         yIrw==
X-Forwarded-Encrypted: i=1; AJvYcCXTmQSIXVkSi564ufizJVbNupMwcn3uw06EH3GxWXhd4PdhYEoF4qRw4HqtK3R5KD8A8VM0RNF/0g==@kvack.org
X-Gm-Message-State: AOJu0YwM3ai0TENR/vjs1r5rLyZiss8kJPVOH/hxS0jt6RUARLkBJnKu
	sjKCOqCQusbAe1i9ZGCZ1J6+vWWjUbIBI9qyfcgtHRA0egwok35eXCpOCvWG7eQ0M2QAyA9iokC
	lMJ/jou/0H//Q2M8AQg==
X-Received: from wmgi20.prod.google.com ([2002:a05:600c:2d94:b0:479:2d82:5535])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3588:b0:485:5d25:81a9 with SMTP id 5b1f17b1804b1-4855d258656mr167384855e9.14.1773652706667;
 Mon, 16 Mar 2026 02:18:26 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:18:25 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-2-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-2-de9a7af4b469@kernel.org>
Message-ID: <abfK4eji5jKSeO_W@google.com>
Subject: Re: [PATCH 02/79] block: rnull: add module parameters
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: gwb4bes6bxzuux1ymui5tsnw187w3e8w
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C022120002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773652708-764515
X-HE-Meta: U2FsdGVkX18znL8csi/xbHNbjG+1v+gXN4q+WcGvrYigrxo9hrX8TnRl87WY0DXd0eW831+CN6xq60MFKiIN2V6riAvBTPl2boCeTyFoBdFe83EllwN9A8AYQO1pr+blhg6QBfNRBS2c9GNlgcaUJzzK/GafqbqyF5wjKk8No06c7NJHk4odcnKxIylOm4chDvNvvcUV6vkVp35MO0fSh4rR0G9M7ocKx19I+AdOs1dba5dmNNoOAvIEz7iqdbJDXReIpoXnjUE7qjS8CSGOpAJJ+e4RmGpAF1tCEBZT4thq4mE8+q3JA8CnR1lkY7Ps9pa2fu8wtlrCvufGFMvB1BdJUNVRaY563PD/X8ceCY9WlQB0sCStWbknibbYs00K0kWqVTEBpxcjzhiIbFOb1zCGfU+4klnUxpSJbxwpiVXz8+0UwY1kvGDIWMtaTsYOd2g6NzXxEkDE4unD3ZExzKlWmNfP20DS4lBiu08EERSuHJAZKmcHKo+IFYPvvIrks9IpLtLZFkZQ6dDiNItlGLsre2Kz2ZOxMiwx+/07KnFpixtjW3G9LK7tesf1+jDsxCqNKfmByjqZyPVyyQXFvttsNNRIRQMJciUXY54yPp53seE87lzy0xmLUDyxm5YDkZmX8HXfpLG8tdvsyg7XULQN2P8aVZt/w2Hk7gwpJvy2kMdNhanZSlbQlx+MQ9QeKQCd245dyBmHc+aS2F306zgyWo2sHUhKws9nv390t2CZ9sQ79VP2i9PlmyVU5AW/aDS9wBlK2BGB36VETqQQwPhG4soqzz/vSmQ0aDszpnEFKy9VSS6HdG2V6J8yun8746TdsErecoRIxF795IRsNFSgqLhGe20mTeMxh2dFIRclBI+RCNzUI7VctEnvnjJ168io+4bBeQJfbiYgrou/H3xU+BTDMRqZ5FFuSd8tpizAimKqDLAt640rqKc9dsXcYMqkL6UAhSAnoUrNJ5C
 s40vF3Cr
 lT7gPyKcpi3wTRzfmNt/YIngapleDBPew9GYEI1DSeztNt1a/1Ukr8AE4ZJLk6QQikqDMOrjMTFgWakKSV/Pxcp0pq6DAO/g8sUXDjTBI/YnYJpb2EZk9M4o/p55g7JacRcqUuUcorQTaFX7y+B+c7tddEsf1WjE3XydZOMBK24THoOTr7bqsS4/X1r0K/tJzabIsVU3uZEQPfsjRKRxww9jAE6DqAqNcX0vOv4Wi7WuS/XGIgsNukXoVrwSU38DZ5cA5CGbgndgbHoQXaXxgPBF/lLqywdyGiT5WepCU88YZ+AeIZZSDE0a7C2lVA95LbZCuSK6ETZC+XkSOyYNukkXuLQVHVNp6DyXiY4ubI+sRTi5911V/6qs00P7/ZcirbtNqq8ze30a5p9jCieZY6RRTgXcodgdx7BSEstSJv80M1RLX1h9RK5bTeKun92855Ph9FY4rGjEegNXQc102SMXRywtkHqqO/SlYNHOLWtZpsYI0wWQ9LXrMaUPDGBfp9sdasrmny7JMEiIssdRgN17vSNM1797Kub87QdatdBRXixXefihZ2wJgMNMB4EtWxoPMweJmc1nUGNsfq64iaHhdJ+mJwo1mmQVLQdyQceMfvodygaVGB3ogSidZR5aIYglLGg2PawJEqzfXtt0F8aR0IN12nfOicSuzRCNkK+iKKMVXKgvNQXlSL74tTVneckTpMrMG/gA5MkxAflOY9OCqChQjJGGeWknvzRRosLa2UPdwuM3F4dqL43ZA7SRszq1f/yKD7BZo8Uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:49AM +0100, Andreas Hindborg wrote:
> Module parameter support for Rust modules was merged a few releases back.
> Add module parameter support to the rnull driver.
> 
> This allows the user to control the driver either via configfs or module
> parameters, just like the C counterpart.
> 
> Please note that the rust module parameters do not support boolean values.
> Flags that should have been booleans are parsed as integers and compared to
> zero.

Since this is uapi, you probably should support booleans here. Otherwise
it'd be breaking to change this to be a boolean later.

Otherwise lgtm.

Alice

