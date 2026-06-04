Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C928CD6E60
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 00:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FF16B008A; Wed,  3 Jun 2026 20:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9575B6B008C; Wed,  3 Jun 2026 20:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D3B6B0092; Wed,  3 Jun 2026 20:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76A8B6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:01:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 242881C12A9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:01:36 +0000 (UTC)
X-FDA: 84840276192.16.C797CF6
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id E27AD12000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:01:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JkcsD7I9;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780531294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmwtcO9oMtO4r20fiMVX6YvjF6Gi+HYM7qIN8rIiuJU=;
	b=P7vltIscPoiEiGy6yHrtySnVZc8vDvV4oS/4lgB9A+epVAk35l3eUoEP0NHCfQyOjACdds
	9usQumqdTell2Ua9NoSVoLaFi89x6pxC9EmBrsdJOJeYvCdveDI26rV/sYASaBqd/nV1tH
	SfAYcGFH4sCnYK4D4m7D272rX/DKKK0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=JkcsD7I9;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780531294;
	b=cg75LwNsj9Cwc6T+K+lKnlk5c3TAQp9yOyJkCWL9c5RukgOradY/j+7LKdLEThYydTd5EA
	ZzrIwAvBqqUVlNVcXfwiGiW6bEd02wgWuovYkDwR6AMYTMdjxBNuQ9q1lDO+3zhbM48ZZT
	m6S+nQCvTYr/oH+v5ngcELW/A/yirbQ=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-36d9794d82aso41425a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 17:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780531293; x=1781136093; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fmwtcO9oMtO4r20fiMVX6YvjF6Gi+HYM7qIN8rIiuJU=;
        b=JkcsD7I97SIz1+HWoKSFcUi8gdCxtK3jrv8zKjrX0TnNCmc6GvKqUj0gjRqMZ+Od4/
         JJ9e2aL5ejzVU9ItLkGDmMR7PpCOYgXOSG6vsVOI2Y7c9paeikjFCfKk8s9o/oW+ZKjL
         G1Nv9en4GiiRzJC/CI79IJEensIgGL1Wt1u6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780531293; x=1781136093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmwtcO9oMtO4r20fiMVX6YvjF6Gi+HYM7qIN8rIiuJU=;
        b=HatINN/6n0pcU67E1icW83uGsWkZHdAFSiqvNv4VqXjoo4LM15lakYnLw9mG8YR8+X
         BzXg5TsN6YUrepQnbzNrpLVP6oN0HoAf6Uu/xMs5NWu9NTF32OMpSSbdJFkgpwYJphKD
         SXfZiU98MPlLbPno0E5xYeBFm5Mb8XGfqOQHY0AiHBnncybMvup4uMKyHiFGyJ0RReAr
         BSjL7EZjX8Ku5nWrKH2O5Y5yNUvEGXLSNFL/Z2A2tBfGhzyfMk5Z/6VN/9Cu6u/LrW5W
         jLTeNNFjyq/+TGU5wooAueIKgqRJHs4cBmZyufrSq+jvSTTWVRPI9T+rU/znYus9NqJJ
         +O2Q==
X-Forwarded-Encrypted: i=1; AFNElJ+zUCPD6nJ6jUCwcG78z/tT0d6WsF1SoGLDPb37hIDk4T7cYNaB0uQb85lAwjU5Is6du4JfpZqGrw==@kvack.org
X-Gm-Message-State: AOJu0Yx4Ih/fgUqTL7ZrH7mGQ39J6cdhPA8PTVTdM4iz897k/5n6oHCb
	2Q9qaxR4jelTvplyj6qEG2Eim5Dod1ehNR9P4op3N9lVYNoiU/h8/TpA6za7qDvXOjFgfnwKrWF
	ZB44goPM0CQ==
X-Gm-Gg: Acq92OGVJymprBn8QPKMGHg9AAUCve3SH00WdbKRKb0t48QxZHUriSvmH+/BSsfckYe
	kBgiwN4Uf5sGSMxAYmx9OM7KxJGd9WVHej+ys+PUs/L6JyB6CNDmFKgUFuGPac+wD5vpkckpJ8x
	yYmswbwVk8YxTEeA+4jSb/cu+YPHbkV80Cb5OyI1PickH9Jz4dp7bFLeWEkuobMvd17C+zWAbsR
	r/OGzUFI0KTiUDUTDAMMoHverYuCdEOwxuOqisC1ghsDVjWVvZUnC/QMR18+gEFKiAqe0OfctS7
	MaJDZ5WsOd8nQsnxpyDVohiGsNyjNZOq9XJtAJ9bPLbkmEoIp6PZrkqtXwBk0xtv5qYzgsPgIw5
	n7LxLaxcWxRvtdnTTUZ+OHZ3M6y0KMOfHuspIcK3u1qz/j0kDi1Y8LhRbn/OJacjrPFkDkzGJYM
	ziYpUDl5aLb+lmbN7ShNXWfjO4VcXbnmc5ZMTwzRvv3frXy64v2HYnZfnwFv8+wRTyA8UuLXz45
	6BpExAv5Go=
X-Received: by 2002:a17:90b:3f90:b0:368:78da:803 with SMTP id 98e67ed59e1d1-36e316d0870mr5309419a91.12.1780531292696;
        Wed, 03 Jun 2026 17:01:32 -0700 (PDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com. [209.85.216.42])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f70a285a1sm879925a91.9.2026.06.03.17.01.31
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 17:01:31 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36ba3ea5c46so42855a91.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 17:01:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+7vPpVaUcgutsFC/yYeQp5/VboKUf8DPLV5+qpa7pOMCa2F3U73ceL6/6vvYetINvztS4MArt7qg==@kvack.org
X-Received: by 2002:a17:90b:2811:b0:36d:5dbe:2a0d with SMTP id
 98e67ed59e1d1-36e30c23af4mr5607319a91.7.1780531290626; Wed, 03 Jun 2026
 17:01:30 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
 <20260603230122.851517-1-safinaskar@gmail.com>
In-Reply-To: <20260603230122.851517-1-safinaskar@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 17:01:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjARJSHGWvZKJysvZOVEVi7bNL5x9K2X7ifhfLA9YK2sQ@mail.gmail.com>
X-Gm-Features: AVHnY4J3E2GAiTMiUKCy1DVjF0CiXaoh4gFXUo3phzZ8FQ9ufT44d-VKtd1uRR8
Message-ID: <CAHk-=wjARJSHGWvZKJysvZOVEVi7bNL5x9K2X7ifhfLA9YK2sQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: luto@amacapital.net, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bqczbxkrd119gb18ibz9gsd97w6xsths
X-Rspamd-Queue-Id: E27AD12000D
X-HE-Tag: 1780531293-551110
X-HE-Meta: U2FsdGVkX1+r8CnnXwPC1KNw1itk86Wr9jO9I6bAO+5sJlbNdZ66KobEmvoIO+QI9/zRPD95/zK/x39qWQ3XIbPVlYbap4UCAZ9VHXz9O4/hdvshPyc6n/pg8zWPnNSWyW0ZcaF70uwnJ91Mn1TeR/L7naexaK2/LFjOo3knaehArYya41Al6bxYhc7wA2Lw3K8qlhL/3d9JG48Z8NKegtqnyx6WnxReUEafD2iCtLwKoc4Hj6i7bXUqiFQVkCzGcUf+ddD/S5usE221/HBwrZ53WjcMwnMYRWngxry4Q8OiiWjt3QG+9Dy+6+MAc82dL1hfKHdC6/ffwirN/71Ku1M236epSspVVKQCu/gVSMff+/OVnX+KqnK4ShlNerqllBPi7cPFBUy2vvQiHRArPhfP0UoWiwbK8HoRpf7GFi0efTboV3Q+eedSg9oEqoUuYbR9RLQ0zggrR0f4iRow4S3VFipcvY8xgsZdZVhaB7fBCWRRQBamU8UoS+PZPn/2mkuz3WIT3pwfMeqr6ZzAsariYKPA2eQ4i9mpXeqHSFYLeSMoAR4Z2LskhVL3LKNAoM0iDMxFp+gVfTVyw3z1S4jJoPy+w6Ym/mtZNf46FbJlxTRRVCNOF6V05yucJpixwrqZ6+AA133VtBlrzGGLRl6W02tEMIFy37JYYcwvOqW50JFtCj+MgoP23RFslWR6dAUVH1VOlo5no2bTE/J3ghaDZJgqheefLduoL1LeKVvtgaRMmBWPvNdrt6LxHVCWycT24BpTWZHeh/vlpG0kaNwKELNeFlcyCcGupsXnlBhptN8WiXq9aamRCCp/O/2KBmcbxrggVkHmWpM1jTG6IlUaRxITQqTCufAjuof1FNpaY6UVcJvnA16U2Sdei8qdfmQkpg7BFQT8WdKajisZfPKSivMCIYc+jTKlPioWrw/N1eSzgjxxHv5KV+8xNTh8Hii7AU/QN+uUY/p487Y
 zLCf3qrR
 ASSE4KmUomdYBuTESfifmwAb5XDNWciAze6HKZrtEA5CjXy8MKncw4W9t/DqeeQTAQjECaEPMGxSiC/HUcQTbSXQrUtXDRQmEs0TpQOs0E4zbsiaswjpR3Fn+3Cj237p21gNTgLfsuE0y5MCMiSzuIoXQiLrBDeFSnci4iN4Bs+pBgySRiUWkgHmm77AKukbU5D2T3XkjFFbUocWl1kSkIh00UH1Xav8d29pMk/HzekuMvDMWkZhal4foIpcGoiGlBiUttodJhD2Ms6QO5LM8u6zNLkRuKFA8q0xbG+FBS4DykMWUVZz5RqNClPUjYUMkb2M4Ou66vIP/V2PCkEVB8wOwZ859nsmNJSR8PmlsRFekJ26gWMapIA4pxg2l9DynPBqjXVFJMXMjR8UvySBylCGMGl5jTde4jZ4MVFQGyldRgQ6wrKUVTNG/OgfrBbpqNebxTobQCXFe7Vd8zf2XdSZtximCgkU58Z2F0jWzFldx9HZASC7zw8ysEkc8pKqVLZeRIdnmW121LzoxdaB204ACyrVteP/dI5KPiPOzN55I+lQ10h8Q3tUA/Z+ARsUJve5aFiq1Tq3GdwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 16:01, Askar Safin <safinaskar@gmail.com> wrote:
>
> So, if we remove tee(2), then we will probably need to remove all
> non-standard implementations of pipe_buf_operations.

I don't think tee matters.

Sure, it will share pages across pipes.

But if we make normal "splice to pipe" always copy from the page
cache, nobody cares.

You can corrupt the resulting pages as much as you want - through
multiple pipes if you use tee() to copy it - and it's all just
corrupting your private copy.

And yes, iSCSI and nvme might do their own splice-like thing, but
again, nobody really cares. When it's all kernel-internal, the attack
surface has gone away.

So that's why splice() (and vmsplice()) is special - not because it's
buggy, but because it's the user-facing attack surface to expose bugs
elsewhere.

             Linus

