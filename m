Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D07CD5BA4
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071386B008C; Tue, 19 May 2026 08:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049A96B0092; Tue, 19 May 2026 08:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79CE6B0093; Tue, 19 May 2026 08:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9A486B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:45:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 835C9C16C3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:45:41 +0000 (UTC)
X-FDA: 84784140882.26.7642922
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CB1B80010
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:45:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mZ7KFBy9;
	spf=pass (imf02.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779194739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
	b=cOK33/jj1TaUW2nOQ/tg416VBnuZ9l/N/x7JxQSBHnMGtiCqWOgMXaDEhqgSfYhhS7C8Vt
	VxEjaPs56md75TkDNsyzB5074P0vyCPTcofc4zRCY6y7WAz1PnReGWoH3c5AP6My571cA3
	UzNm5mPLfEId8KK69E+0BSPaZ3uODG0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779194739; a=rsa-sha256;
	cv=pass;
	b=vYIwIrLOSY9X5sNIgtcUd8yt/og6b3U5OXRZQY/YtDsVoI9a1QeVa52MXj+NnQOnHUAuT6
	y/RjQDtjNda2+Q6FXI4EnNHPHk7FZIKv5vcRhQGNbbWcWsRmVlN1zUbBbt2cs8qwLChYKl
	Rz1Jty/qM6ibePDro9vBMkyupM9ooF8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mZ7KFBy9;
	spf=pass (imf02.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-303da604df1so223018eec.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 05:45:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779194738; cv=none;
        d=google.com; s=arc-20240605;
        b=TecnkU9EEpC64WGTJJOwoIxq8w8ci3ZSP71FzG5GB1SfvFkDOWAIYk+mz1gIbM59Hc
         Vb2f0ICHzq71BVfWhzm86M9s5Fl3WE05ytCGaT9zHN3VbbdWZ4mLmzLuwNzVcRVzA3Sw
         KfJDyACTbxXrCz01gP9lgbAM7DtOZujyYtbNxVg/5JGhgMNzVv4aTqA1cip94CV88tHE
         qpQRKXQyUJvfSZxjXiHI+vfNFnuJwCtVnWnnHE68wfNSLChVfnbBfPZ6kxqlBGui/kX+
         YMg/uW1XFubgEBn6eazy0KMuAnhndf3GrpY+8pA38oxo+35BQf+UoDPyTapfMHYi2Nxj
         BonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        fh=Yr09fX6Xo8ApZ2Scf4d0h5K8+ouRIlyGqS/StEMC/1o=;
        b=J3UXK4APrHoRLvLqtvBJJNRYcvjk7xV93V69ejMMzYkd8IryiKAusx1yH2al/RFdUX
         v516Dn4nO4UAjrPCExdUolPxMrlmq8nmzZmxCpmdiXSJP/RtRdB2Cau8n1GYUnG2Q8Ec
         uDNnBoU0uKhkdYN/JSy44sfn+a4ChMOZC9IWiwA/ZExtUzLV20cCGu8qcvW3x/VUrDt8
         dOxVFVbLXGJbYGGsRgE5H1YDk5XoBCy+j+s35ja4hHSSThGFI6l88r3w7YtU1LRA3hIe
         AzAyORtb0niss7gHXCZjRRGfBTjCg2JofVafWXD1NEVr0q9RIUWG5IGc6dAG+ub0EwOO
         jf3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779194738; x=1779799538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        b=mZ7KFBy9ARVG5TZ68iysjGJie1HmXkSpGzil58xnj8rSw2lPVfZGb0ty0WjtApCupl
         ArOnbC4QcyghNfl7Pj3N6t9arMsC7rYhJbR81SSVPxxhliP4SzRuEOgarEWqvG7Ptbtz
         ZNIRkHIm+ONWIs2rWy4i+DEm6e3KPgdmhHXHmzlRs2hHneGlm23Ro69AswotirLPghHe
         45f0XLLYqDvZdO7lZXjRT9FgSnEExT7uWpEUriF5WR+4wnA4gJk0PuPYvoCh7Z5ijSPy
         oHuPJWgSGzUeX4i8EVNOk4DoGXZ5YSisoXHDFtcZb+gP8kjmks+oWMWgaFrxv1xETNnM
         0z2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779194738; x=1779799538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        b=ki/B5vwmlEZpZe+7uCRBQ4AHPK9U5z47GoiwAsYILDHEEeJ/jZJag9EUeKus+GnW2U
         dPMmveEAJTWFRd/iLXMkxqf35rEUde5P+C37n1poF+fG1U1jarSRcWPUOMzHgR0cbFRx
         lULrGt4vvPKqOwBdX0bkBIAtBsqoHxp0eC7KUI+uTkMgHUenPoagQh6NPqzM4p7I0Gff
         3MUaiz53e6QxygpjkA03H1cMoz+IyfuTCnC/UX1t2nyoZgVlqs2ttsXUDgUDXgVcIX+c
         2aybstKzcYpHIBEKKWnW9vpM/gH8AoO1TTRsuM4Ti8FLIWM3b55ETZXsR3HvFFzyRp4o
         hGCg==
X-Forwarded-Encrypted: i=1; AFNElJ+Q0WPemJeQarMNXFthMcrJloNBKweluUaDu3kwvf/ztJfCbNunnek8qnH/C6rwgyIq7x9jUW4Xwg==@kvack.org
X-Gm-Message-State: AOJu0YzZNGXt1w1e3XsLX9gYRQJPc2JoQYsnh2hlG+dU0/MWRfr4Hj6T
	N3OhuGqZXcEXXWYvL8hixj23Ih5IjSWpEYQzAkuqcxxUC48laHoKBa+lc8DZlVGHZGLS/BVSXSV
	R1UEo6roNataG5xy7tuBwsrtPefbL4Bk=
X-Gm-Gg: Acq92OHc8kJ4I7VkjctUNnAah8kWHN8M2OFwMlhg2ZCSwopw+doYhJHT/n4xlUEUlYJ
	0V43V6jxldU2RAwhzP89yVLDV4hKf/mME/1pBfxeFxHs+yofI0oH79VtewJk8BqqygBzN3FyHW8
	wYjdeUCQJT18DaT1+28xaY4xS/Hfq86zKfXismLLmOFJEyODSHRe1y8QK1C6yk0BN9VCPbhY3fA
	z6DMlRDywWwCFYU7LKymtzU/FMyapH+b3rrNcEY8+r2cBbMkFE2clk+o6IdrGixmzgCdJOx8seJ
	w2gRmqlttlK3hoYNXxHRKPrx0pq78LdADb9iNwW6BJM2odLGKFCjFg3/p/viNyWdeuMqfdmI9Tx
	D48EGvE5vxCJ1cv8tJQJdeHw=
X-Received: by 2002:a05:7301:1284:b0:2ce:db5e:354b with SMTP id
 5a478bee46e88-3039868c605mr4201196eec.6.1779194738147; Tue, 19 May 2026
 05:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779116497.git.d@ilvokhin.com> <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
 <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com> <agxPiQKt2pykEIA4@shell.ilvokhin.com>
In-Reply-To: <agxPiQKt2pykEIA4@shell.ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 19 May 2026 14:45:25 +0200
X-Gm-Features: AVHnY4I3tKHMpeVy0SsdLCwhfLkAoVFoOWpjpia5ybm3cMqW4XsbiRrpZww0564
Message-ID: <CANiq72nTDFiGp5f6=Xh3w4jnULq-Vs60Bztj6FhfGFeihwa_QQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CB1B80010
X-Rspam-User: 
X-Stat-Signature: xz7c4awhk7nenzdsuogrgwgzqj4etcqd
X-HE-Tag: 1779194739-960020
X-HE-Meta: U2FsdGVkX18csjCEZQGENOZsCbH0dj74V2/A40CLdkyvEI78qtfrgsyWjafz+xCsX/ELZuPbNPybfUKDWj/zc6UCV4LsZ+33iSANlsdF7G94Ou9AgiznK3vk+GU939E1gMSdLFEvY7wzzFnNDEFv64sF7Kxe0gHnyJmEQ8y2FqbCwntdFMst6NURV9bfI9uBA3OSP3YhMzpywyOpDkuXyLA8sEwDMKm9hyZJSD8MkstWo+uK1UJGTkKr0PFwA+DdYxLpbpuHudUZ7TWDWz7mJtMIijKCMGGdB8vRlrpKi37B4/UXBbKLOViOqJ4PeDha/3LkeqQqje8MIPVb5r8IXNKV4rK9Go3/njUxa2Q83u1C/1lVQMkGHw4qCJEfqf//LB89YYl0mbwm1JmbMtAcMklPzIEfEQp0VLLNHZBxZOeLlzSi/mw3YGPA2S+/RE4fFgOeYVuyo7JmjA4C7pBPaJ8Wkz1tdaA1we+d6E4ZCG9Hp7b11T+0ynkvfzXBPJjEhSykH9Q48Ahrpa+1whdtjAW2VzSPYe+mQTRDZbsOpbQuGlY9uDAyl1CYnWm87kgIUq0tUg+jpv6ixz2lse6/Y6vRDYZLikot8CP3qC1FNIcmljjY0bSgZK0CSn8t5qwsMax9hJdDr+aV+PvGz2UItCQEyElpg/iOgaJhJbGAE+PMGvtJrcLoHqOhh5ANoKCOYgRb8ZT6MA0mmYUgHGC8jgTjNMP9kXZvwyOiRWzscfYTN0X0bad9/uNP2I7p4/90mi83nnvzwTbk5Agx2OGBgJHmO1W7PFHYSP81quqDaPJ78yuOeeROD7I1GVg2C+M3Z23Tr1r+OJuIav0FsHcfFfmOxssdPBmFMaJ++vxU17b2pTmQEVUyL2Ft0i3YQU3LPquNVHD4PjZ/y9eteqmwrTHoe1JC7nOHdbNqa/38l3DHF8wYMh17QuDg7VnRvOnWHQ5aQ+vSMGTL641sUf5
 sSkrhDbM
 Er6F0Qkcz9ouUY2mrL5kNLI/1qXi6IbBzgiMVzvYEtIDfqs+lE4gUkA0wL15kavJygzI7/H1gfUN9U4YrQUxbvOQPZ7ebI+qQcrtqFbG/nmwfxXgbqKpxh8alsm6Blc7VoGy+9r4OmGKIhFnfmbc6+5W4P0u7hCXUrKfHtp55APo6jfjqSSJ+uaIZvnppBMQJL2MXzAH8bXUH2r5zBiL02aHGE0cL+ENK46clq0gEOZkPtXxyLFf+CApgnw4dgWsSRPRy2uOTDyNmeZzh6h0ctKcawoKK0xVhTZ0KXhtkQ1QG4vj3RUnokRTiQraWIuSAceMOaOIPWmT2AtGgqzZkq/pcyaGXayg1QmctNKKSke88njWlnTAmAQyk+bWHm0Pepoya/UsdBAM5l3XlwOdnA4b796/xF96WxA35ep3Qh1ebc4o4tq3AkCMHYm/nsGqNWSOuP1Q1nR18j1TrQFtUAFmy5a5q5NGJAbYn932WtA0Y09jhTwGKDye4rdT/yb56exbIJN70kx0zzCoTI1XFm0Tq/cSJ/q9iTyH3MItlMcreuyEUTRtjFWNv1xZiB3XUFX+K1/KwqIIasdIyE5mwg9UHyFZCIbFhm8LPeu4UXzb/tr30l1ywEvwWK0hRajFwUK1sJtqmpUlEO72z6Sk4SGsU5037+taUx4Gt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 1:54=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> Thanks, fixed locally.

Sounds good, thanks!

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel

