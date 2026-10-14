Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F41CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA186B0088; Wed, 14 Oct 2026 14:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1906B008A; Wed, 14 Oct 2026 14:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9866B008C; Wed, 14 Oct 2026 14:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D313E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:24:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 640B2C0269
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:24:51 +0000 (UTC)
X-FDA: 85322057982.12.EE2CBD6
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 443C21C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:24:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JEmWZ1u2;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002289;
	b=1Dx6AMs6hp9njG2FiveTeWvKPEwYAEh/dDnmm8DBFWGG2YRHJLHLOuY5FK64A3AZdCdLF7
	eScpNQdOFMd31iRnMCV8MOB0qihNXZ6CG24GK8pZEwuzE3v86Jed7r1ibLHmfQIxX/FAb3
	z4cFudwKX/1spNt/ChJt6uhiBAuABbA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JEmWZ1u2;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RklOVidugQxXD9UNgFNiDO0jv9PvJV28lokKFTSWA+o=;
	b=oJGYP2xAxFN5WQv/37/G5JXy3nk0Zzdr9KGUa4xQlDARgsiT36IROdisTmWg5MCECZHrSu
	Bi07pMElXMnuF4uqQ/DCwkpEhxmeX0mhflLWpLreANpGPITPM+IoXlu6EknYb4zV1883GB
	AkLkaPm6/HqntvFv/VyNWHuhUahCJPE=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so4791971a12.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1792002288; x=1792607088; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RklOVidugQxXD9UNgFNiDO0jv9PvJV28lokKFTSWA+o=;
        b=JEmWZ1u2nrrfwBvT3YwAdbRrKPLAwxsoKSGjLBt04Vrina36C0R4nNZKySW6bVeDOC
         QMmvZCyWDljLNhl5xDDvL8YbyuciD1hg1oVfzsclL3L2Xfornk2HTAfN9gfiQI4WN2v3
         uBXaJefFziXSgBlDkcvmh5dH+LhRQdKHa1jMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002288; x=1792607088;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RklOVidugQxXD9UNgFNiDO0jv9PvJV28lokKFTSWA+o=;
        b=uY2FdCgF1QqOoE1RVcBbe2lyPbWmWnV2ZaTGGupkwA503E0d0sEGMGyT5XjErLMHEH
         xeQKb8xEql62P461KiQW5xM+uBWrAluONYTKH0sDqEbUibLNVgGeKK+uM1jAbCWfbsr7
         uCSEM0RsG8zojEBhnIYvOZ8GV+i0unhjqDHX8CBrWiaL0FL4nxOwhKxNRPFUVn3Twbw4
         FOOZ3RMWwsPfyoQ5wf7hqC4zgiI+qGtIP6IgOjgrmJsFiUFvEoJ6XuSBN4Okb16s7dJJ
         Fr+a7/pp6mkJLXeQjbIeSHVpMWv1PSgBajrpU29mdBbbC68Ms3SQcaqW9zwVyplUatNA
         EMHg==
X-Forwarded-Encrypted: i=1; AKwUvByvM0/yd66Ptz49aVh+0uNWu4YL8QR3iXmswCk7b8mdMIo4WTHWk+/8/1puqkpLSl9hRtri3p9S5w==@kvack.org
X-Gm-Message-State: AFq9FYJsUuxJy9xbJXA82tGc+0Feba1g6NpndJoK6uSl9MqBjfcZix5W
	90yOrqhumYuGZ5lWyDxpDo20IdKRegE7TIOOhHPYQlqFnywFETi5uksXQWjb8L/yu5UTCjWMTUM
	BfAPEKZFrjQ==
X-Gm-Gg: AYBFou35NbQrBqpp12vYj0iDrCgEaAJQkgrpxdrUs7IpJ6GXnc2EePPPYFLDBYxPPzV
	kiTq+YZIJq15a8UNYpPwcI5B+RKD5GQBUhYtqSw0u/3bGWzUkJoFip8KB+/9RoKFtP/MTWFssvr
	7ATZBBc+MEz4Db5sGaopR4+iDWrTQcjYq13FnZ/8/Dix9QBMZCDwVTN0ms9XaMo4IVocA8M19Wj
	GQ3rS+XfC+QfBTrm1avIfyUlyYFw15qkwLR1nHXuhu+s3SnoIpnZucGqMGFSC+LvrTJ92Eg0VGc
	e9x2jtNcTPILRIuXaJjhtZwpjKcV4ZanQLkQVSsPZ8iZxRjysf9aTYTG/gOxRRUDru/v5e/wi2p
	n4XSFnL7IIdbkcCLA/on373XOPKMykMozkRkRpqhu6T6JQFTDGtyVTwEgYE96IlnNTl2mtfX8Eg
	kMPcYMjveqc7aN/Qh2I5IrqeueLotvpWAVlp2RKWphdfIQ7AxuKFJE5ECyEPBi1tNBno1pFtQeZ
	zYFp4OxuSAWHH6/SlM+WXwbBUQNj6n4fseqEkvKfV5bEeBo
X-Received: by 2002:a05:6402:52d4:b0:6b1:bfa2:28bb with SMTP id 4fb4d7f45d1cf-6b1bfa2389amr6889505a12.15.1792002286766;
        Wed, 14 Oct 2026 11:24:46 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b203839a13sm1397468a12.9.2026.10.14.11.24.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 11:24:45 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e6df2742cso688397266b.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwgvAbDYNFEFKA0HH5IWUTcWfoinYsuzgG9NT6CLyKjouGF8RsGdDYDyEnrnZvS928V4XRhs2309g==@kvack.org
X-Received: by 2002:a17:906:7313:b0:c3e:c599:169 with SMTP id
 a640c23a62f3a-c3ec5990f58mr73949266b.22.1792002285129; Wed, 14 Oct 2026
 11:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad> <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net> <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com> <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
In-Reply-To: <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Oct 2026 11:24:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
X-Gm-Features: AclHuK8Xr9cbB1shH6xYa6oUAEmAg7bG24kVsMU7gBf-QzCkJVoGpHArbyivVDg
Message-ID: <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 443C21C0005
X-Stat-Signature: 31o4hxuz9jthkfgped11bh4q43d71d53
X-HE-Tag: 1792002289-269172
X-HE-Meta: U2FsdGVkX19jydSmbaAZ5S5Sd6xQNTBJzHedkXU3/nU1bDu/tIQ4T+FyMcKkRP7Qsgwo+Web/x+N1YsEmPEOwKWTAEINDYOe9xzA6U9q/hze9KoK37Ij75n2iTJXFX3xc990WEytzAO2CtcnBFX5gN9Xhdp3aZV7EsVlVGvL5KJ8fc7iKvQ/gt4LI6aGWVvoQDhvfwItfMUS8/9pc6t0JQmdSfkcs5E1sUDqWopAb92nicJ76sZYKpWh8jwigHOBoPwG1iZJ7AaWUiJ4U82RLJjE9ycyw4FbW2AQhCa/I1YSH6SRUnB+x1TGCoDym7KmYjnOqFpB85T5NzZRM/WbrqimEFO21WFAi6DHLclqjPA47KY0YvAXLrSncD6P7DC2humUPT9r7sEArCT4rx+OdY5mE17y+iJvGokeh8+a3Vji9Su+/CTK4FeRr4jijpuXiLc68qSL30ny2+4tdxJdpbm6ccHkGQW1H4IKxhY0NJH71TKHAdvSoI1Z0BpyOpoqRWFTAYF4kNI0GCPHTekoRvh85rLp6sg5Ab9rshQZattMbMIc8Se8iaJgdfxHqIw39cI2TTAQcmDRaH8Ccf2vW3R49an6Et3uBIfQxwCkA/atsJylkkVRmOCHwwsUWZsyvSmJs4bq8W0Nv/GXAEfeKVaAG6sahT11zUpY+eJtpOad1mlS1NcdZ1AEto0dryOMadkyVbBb087zeEEv4+8yFyt14nZmqtwZ8oliPgpZdkCv0hXvn7+0WoQSNpzctU8OC8KHk+qi3cFLd7aoMcVlXuhLyDFdpn2zhKWYWX/xgrnOG/0O89k2syXG4N/mQYDaG2L8bYcqB4X+lh3DDJXP0KrEBhVG8aNzcD2oTtVvVkqNCTyYGBCAvKnZodz/MMs/OFZGBhkaffLMddZnIKayotJAvF7yCgATZE0AFVUkxxD4tmcuXegUZwUAQrVkNVqqqzCAE7XaO34aTNNqQ/g
 kd2v7tI2
 iU0IN+mqBZ6mtz2GLJCou4tArOpO00igMRN/iIlyvMI+0U2T0sIR/2aj81flS596EKyPtKm42vZNLRnsIxqdH0tHmqduADCNP00WdMFQW2RZdTEkgcVmTkw+K5FoiFW8UJot2BAo3Q7AaB5dWmPTHBMOvyHxqFruhBQiPt+37RSy8s/ePqQy3usKOqTJ+7kuyLo4wf5EmHxy4EIfd1ewKKPsEVFKRuckSTXEucy3pPbC7FnWFhS3kHBru0RN4D6cNqKuFGpUCPC6K+0QastBQHxojxHocahOHEvCiU4RPQ0MD291MCedrHScFyBkIhXey90hcfe67tEX6Km1jTIhR9NOm7oWAnpxlER1KVz8206Zt1j1rgSHEYKc2/dI/rZcc8qbowYeqAM+yFDxYKmx6rDWz2etJhZnqVFurYjtlKOWJWbhbpAQd+R17iHZOfdF9EpOXE3Q7xpmf7DavFTgrixHG0abUFGqACHWR7qfrgAb2STbRXi7iBKRhVyjTiqZ5ht5k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 at 10:44, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> I already have it:

So that was my thinking too, but I have my notes (from the original
truncage/hole punch patch) about mapping_exiting() being problematic
due to f2fs playing games with it.

Now, that's probably just a f2fs bug waiting to happen independently
of this. But the path is

ioctl(F2FS_IOC_START_ATOMIC_REPLACE) ->
  f2fs_ioc_start_atomic_write() ->
    truncate_inode_pages_final()

and that truncate_inode_pages_final() is the problem - it's what sets
mapping_set_exiting() on a live inode.

I had this as a note for the original branch, and it became a
non-issue with the change to the "set PG_rcu_free on hot pages in the
read path" instead.

But your change makes it an issue again.

Now, I think f2fs really is just buggy here. Calling
truncate_inode_pages_final() on something that is still live
afterwards is wrong - because it's not "final". As far as I can tell,
there may still be hundreds of active readers holding that fd open.

I might be wrong. Adding Jaegeuk to the cc.

                 Linus

