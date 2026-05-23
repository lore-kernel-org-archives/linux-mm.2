Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533C3CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 20:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47EF56B0092; Sat, 23 May 2026 16:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456B06B0095; Sat, 23 May 2026 16:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FD36B0096; Sat, 23 May 2026 16:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4386B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 16:41:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2278A0C19
	for <linux-mm@kvack.org>; Sat, 23 May 2026 20:41:42 +0000 (UTC)
X-FDA: 84799855644.02.08D0DFB
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id C739D80009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 20:41:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f0luFaJm;
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779568900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNf7CFkgwF1rfbyNmnV/eQce4TyQWDhVxKWrw1dKd7E=;
	b=PNDSYQJD8YFbhQ8LrBWTZZwlTXqyynPqYZmrOp5FIkCHXEcxZ6iks9elyXJDJmdQetjZP4
	MgrnOCqsgy8mUoSiklUcjow9FVjGvvz9L18G030X4+5s3k9irYEsuxi6OlD1jIh4KDf9JT
	BQou2iVOwM8jRWMO5WD69jKLcCdzPWY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f0luFaJm;
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779568900; a=rsa-sha256;
	cv=none;
	b=f42nMfOeILNuE/2ZhYI3TgYQIxnQS+xZ8SWqjyum3N2rNVOnLlui17kOXSnHy8KXHZadDd
	9eyG3VcpWnZptK51jgAOaHi92KOvQzN0vg9sqeBBQfv+NDMKq+CgPF9n6qT1ywQwfh2yn5
	5QGBzstbOF7HGfkY2bv8YbJUJOiKOus=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49041e84237so16023515e9.1
        for <linux-mm@kvack.org>; Sat, 23 May 2026 13:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779568899; x=1780173699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNf7CFkgwF1rfbyNmnV/eQce4TyQWDhVxKWrw1dKd7E=;
        b=f0luFaJmpHaPazvbSybaBhOV4p3Yczs2Fk3zIqKePKXm1vJEEQgPmoUwVbHHkTt7wL
         g1qJ/4ZqrDakB+N1EFAbkMcOvxgTGCVOuOrfLqVFbbSgYlfsU83ymycCVn/P50DcfO/L
         vzcXFLx0tlcXBSrilGZgOMXfxhkyb4XKlyy904Wro9MxxxWxxLAyJjShrnGoTIHLPLSd
         2VS7x5TRaKw5qhV+MC+SRHQGbxcFf5lLFUn/5y7xQBrIq92apEgwBfB1uF7cISAi59ef
         QE3luH8QbCeGDCajmk0XCF0eNH1m03ZnoRPzIjPMPRFpaHGq/emOgf85N7wxxAF/7Rj6
         xwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779568899; x=1780173699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNf7CFkgwF1rfbyNmnV/eQce4TyQWDhVxKWrw1dKd7E=;
        b=BZLq2DzpEITbmJltikMcvPtvJumpcvUMBwZjyJwf2cgp6RbsHBsAp4j+j6YsHY676n
         7c56QGDi7KvaCkMR/tU7fqQymwqrC8XyJ56RON2vofJ8FocbcZrnr35KxzeCn3azIswh
         KaISjCl1NoGr9UlbVGr4Pyq2lgeF1N/mvNenQFLK4mmFafGmOSgLJOi7GTAoaVw/w2ZH
         lAUZ3+jnQUwll/RI1wQZV48uQ0mJAtWOK6nI2dv5cLkjUasqWFhYPBOh9MVpfQmANQxH
         ZM0sjwK5Tsda/U+s74M1o6GJGutBa4Lo41YgHX1FhZSS5rNVr9i5ynUFPlhWT3qkjoEj
         HvqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9q2PcRxMNXDvjROV8WVAPbHniAYVrop/8JPCsL9qBn9yQGgyDe6PSEajPk6craCrMp39/ZpOeTHg==@kvack.org
X-Gm-Message-State: AOJu0YzDT8WG2X42RGdevd+AuyvXTe4LlZIBsPGJyYbF2NUcV7eGwM/h
	uzw3FirvjDKDCHdiy3rfCEfjVTLFItIfrmHUAVa3g/BCZygezJ8of8UT
X-Gm-Gg: Acq92OGrBNzgLANIvfeMp2kUmBe8OniJv4WpqmgAGDJtH9fhWoG3lL2s36fOMo6LKY6
	FoTp/zBfTUbXVJwVs4xKc1n1L7V8w471XSvDxkuKTzMzfHp3iYdmbMStyoqqy4CHpT3EpyXF9XF
	S+qkSrwyT/zaxfeyazbjjdPHkZW2nYHYWk5ieSIRgsR4Gqh5LF1HVxli4qjM/+lJ7OH7a7TujLy
	wYXFAHmRPHWgiHZQqapzbzXulqFBL7oLgTpIOieTQiF+GIJv+83hwHMgnxHs1vRdVgl1lX+IWmB
	JCOdTVA8SdT5VYLN4vT3RC4r7NYRhFAwvgGt85NrBD/ND9xcznbZ9bcFpt0k327KKv+4SRq+zDw
	l/xdkqBVYQiOQGMATNfaIIFYPWnNrehRrMPAvzZmYsT5kYeO3zol8PU2CuT3vtUhZxCF1K/YaO2
	HYnn7YF2dipSkonwef+Lwht8ACUKZzDp7eTu435tik
X-Received: by 2002:a05:600c:4746:b0:490:3d48:6cb9 with SMTP id 5b1f17b1804b1-4904225f7efmr126899095e9.3.1779568898911;
        Sat, 23 May 2026 13:41:38 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49059fb42dasm16015385e9.7.2026.05.23.13.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 13:41:38 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: brauner@kernel.org
Cc: axboe@kernel.dk,
	jack@suse.cz,
	jannh@google.com,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mjguzik@gmail.com,
	pfalcato@suse.de,
	viro@zeniv.linux.org.uk,
	David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with read-only files
Date: Sat, 23 May 2026 23:41:00 +0300
Message-ID: <20260523204100.553125-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <177918418452.771415.4371785688744608623.b4-reply@b4>
References: <177918418452.771415.4371785688744608623.b4-reply@b4>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6c9ppk4rhnd1fmkpa1u63dwbiicnn93f
X-Rspamd-Queue-Id: C739D80009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779568900-135192
X-HE-Meta: U2FsdGVkX1/ZMt+65CrKK/Cznh3AlGXL0xlzD1MhO03HYW1mRPfgnQaUxLb1mJWzW4XLjP/uvqHW+aOIRionN3WWVzQ5g/JBsdnrzAkIXFgBWhK/JqZbPUdIe/KjEE67ddlFATwsDYsRsB4nk4onVw/CQrB/E0lsrSNiRuCv5iLmh9iDspworD0qJJWSBa0UjjU7Fi0mJUrmBCXTXfAZP8JtkaY/JLgZyJOLcjGZA/n+AcPiDWypbiKJdagBXgB/BZ8TBHEcx3/cEUi1wIyN9Pso0eYuRVovwWksqw1ckCrBcD3bkkQnzymYrnprvRM0+juITlLQ1A+JxDHSQCs82WSprdqlVGWtxhIOBGID5ZMYtS/vqiPJ0rRQy86gU2N7NQWPverjgkyzGbodj4+3SZQrTz9y6t3fmqSTL/WgrcfMy9ESRGjMiZYfx6wOdjfO/PoDZNOI3eBJEOLBs/ArA3rANbZw7eRuxLb/DnzYG2FtBDvyGrnjvvT9Qgi2aXbMvhWTSFNuPuO/kQdbzTbf4aHTOmS+eovbV+HS71Gr4ya92NrLBskJDnXFYbHCe6vr6v2WXX/qdcBk2UcmcQyk51cUT4s+N4H9yE5fOl8Pegdn/V0AZvIKsmdR07qMlVWH3LY/n+RrqCpi2e9IAfBdZZTtDmQrBnh5aGRPUTxaOJGcqNcgJ0t6IHoxwZIXxwKyNFyHBpO+gBng7FZkVtqni4vlAqPV86wSVfLvSzwrS45Nppkjhqf4nRIa9iTFbdqlv+MfTGjMOYBVsLCtaLk2FFTlZnpJRjUMAMi3kn5Q1YLZg97cEkE0mHCxzuwrP7wFaxEprJ/dhEkuPmSWQt31Nycun7x5TVbixLq4U8Xqq19KP2/mk3ivTFPEvWgE2XElJ4LSlbDqtztE3VsUlqiuQwfPvlPYMCuECottR0N2iPphwnpH4MTOF5hPuFbaSo1Nrikg3dV7RLnl0UyRYUv
 X5tritQJ
 5XZcBcDiVs+R+JHtH3mkuTinwyc25ygQPaYDe8G0iJQ1/us/55/87M9Qzn1xphvEKzkvcgmOOnAWy0lw7/uDa/KLVHd1K8uOHP9THmXHdh03Aj/O4dmisvOeba+WiGnGmJMDl5gCsybo5mwSnutnbW0mDkgOzTQlEtSqi0L5QSN7IOTxu1jJ/41EV9041d2v0urVR1+B4y7Pg67InBJM3cQJwIqI/WBHIDXyheZRbzCfP9xI7anjUjsxDiBETz1zz0KQYbmRtVHF03C7LTqPL38eQD75KO7hm3+MeofL4DZ30sXVFtuh+2tqyO/q5eZ3I4XBH0yjiq8tm7CeeCbbbIcvF2gTYTqIOChWNNHp7qf4jOblK+miU8KV3Ml3nE0awqrlSVYnc8e16tThXjf0RnqVj9RfzcdaR7Q5G6pb2/9CPwVuG1iqDkqOOiy4P+gmF/6/ZYJsI3/hZlgXLuqGr0ttBVttCURbK8roH0NOL8OC4tkV5Jjwl2tf3HlJoHDvGCX4rqTdtCmwJmO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christian Brauner <brauner@kernel.org>:
> Let's discuss the other aggressive alternative: Can we try and
> unconditionally degrade to copy. This would affect sendfile(), splice(),
> and vmsplice(). Worst-case we would have to introduce the sysctl
> retroactively.
> 
> Thoughts?

I think as a first step we should make vmsplice unconditionally equivalent
to readv/writev.

vmsplice already was problematic from security point of view long time
ago. I mean CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).

David Howells also doesn't like vmsplice:
https://lore.kernel.org/all/1763225.1769180226@warthog.procyon.org.uk/

Linus said in 2023:
> So I'd personally be perfectly ok with just making vmsplice() be
> exactly the same as write, and turn all of vmsplice() into just "it's
> a read() if the pipe is open for read, and a write if it's open for
> writing".
https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/

Even experts get vmsplice wrong, as can be seen in this thread:
https://lore.kernel.org/all/CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com/T/#u
As you can see in that thread, it is very hard to understand what vmsplice
man page supposed to mean. And you can also see that vmsplice is very
fragile.

-- 
Askar Safin

