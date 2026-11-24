Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3104606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eCyaknUD
Received: by kanga.kvack.org (Postfix)
	id A27AF6B05B7; Mon, 23 Nov 2026 21:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8856B05B8; Mon, 23 Nov 2026 21:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7C46B05B9; Mon, 23 Nov 2026 21:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 525936B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:05:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B148E40853
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:04:59 +0000 (UTC)
X-FDA: 85468369518.17.9CF8339
Received: from mail-oo2-f8.google.com (mail-oo2-f8.google.com [74.125.231.136])
	by imf09.hostedemail.com (Postfix) with ESMTP id B895214000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eCyaknUD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795485897;
	b=jx8yPzDvl6b1acdc8NGM+1ppYA84k0IodD+OGhxI+SEizqoUPy6IOwuyUN/h3Fz4sg2lM3
	oJ8wYrYBWyqN405IvujvIsWuhPqOUF9tlm7xLOO80USTnyNeQNFMZOuNTYwSl1KqglBvt6
	w+qszYGZP3dQiDTnmNyk7hrT+COSa6A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795485897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsF+tVR2dZZjjdYGZuSRze/PIAMVBGDvDbNbw1sJLak=;
	b=T3WAqvJygOjQS1Q8emDUoFkKLoNgVRff+Ly5CXVL5/Fy17/Nc1I7enYfHDC28y99FjDCAa
	Ss0a2bNX6TtVXwMADr3hqN9qeCK8lpw+OknO21VDe754tTuhaNOaTbBXHKxBZwZMKnGOa1
	b3VKf5Wk/Jz9MgLoQNPtcxxmr4ZtwHM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eCyaknUD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo2-f8.google.com with SMTP id 46e09a7af769-860f0ac44a9so1558008a34.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795485896; cv=none;
        d=google.com; s=arc-20260327;
        b=fD7kJvFl6GUxDoFqLEDC36MqOIfg/1FkbvG3U3Yk0zh8z606D8WCdxkbKL0DO8PrIh
         Jr3tI93tScqXcRG8SmoyZTH94t01M7R3eoIDvoK+5yra8BCwM/xusONjj+ZiQMZRBcHO
         VvGQH0E1jhsppIOj3WAtQlrdXN/re7HlcYsz9vQ/DTf41XqSIwbhvEpi5LOgNTc+ySLU
         GLcc05zRjCV9kG2lf/hZdG3nC1gO8ke2rtO2lH1zRMcZ3J898TeRZ1KFg8HrfAd8l26X
         lb8LWWpe3nZn6HZD/3fj1sXfvMUx9Xr6xpyEJK7FSsvZbL+tPDR3oHihoDjGG1om/yWX
         t8YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SsF+tVR2dZZjjdYGZuSRze/PIAMVBGDvDbNbw1sJLak=;
        fh=m0BATRmMb4TASuYQOAFQmruZWcnxjwGRffou0sLogps=;
        b=CnQQk8PRklLN9A2UIbD+g1KaunmBIFVfcTRH4okp1VGf1Klw37X2xyBOReK0z/geYP
         9ABIJiy3lqPnKVYaDtypTgcEy+OdZijV01oTDtpcXNEK1Yy7yqkcr3LHyvjL1PMmxILd
         DFEl562LPnbqGNqdpBr0c8I2WVmJxynF9rNM7L8VDVuSCoaIeaqk3MTGrucMcrzYLaaM
         sKh2K+OomgDXGoyPUPK85p71rpSbVU71ed5JvAUZxmHz42+zB5Y0EFtTHUKsdhzRmi34
         vC7sTBmG1eRw4zsDVXjH/WyIui+xlt+DSHe5mXFQhZjmOgWRQfC47/azQB1ZQN+78RW1
         jCOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795485896; x=1796090696; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SsF+tVR2dZZjjdYGZuSRze/PIAMVBGDvDbNbw1sJLak=;
        b=eCyaknUDzHIhA4D14/a1JwJqv1FiVLPI0qbQ+VHSfHbrmEdPrnBgD914ClBnLeXKtZ
         NqOAZsdG2QsgqPeI9GEaVa2wfIsN/miq4NWcl2kVlYkZasAkCdYBJ+sKepe/+SLOMGie
         /CPlQd08urIONOI8uxIAgttMU+nZ20qLrWxhZjRMUwd1DpJtOPHsVVQmU7jetp9KutAH
         nVFgeDbec+INi6SS4Ly+wWFRyyc6UnYhUCfVuMogdwkOUz5i6qhssMcDjoZfl+M4D2QM
         weva/FJsTzfktYgUMDIztezjy95UnYWBUfXiVXNYRgbucWasGdmULKUZgdyGRK7prLwG
         eurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795485896; x=1796090696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SsF+tVR2dZZjjdYGZuSRze/PIAMVBGDvDbNbw1sJLak=;
        b=h/HkNY9FXTZ4Lc45c7jVSeNWCdZyPaDL/d4150CZ5EVYBqyhYdJIhNTPQo0F25w3IN
         xNEcQGEFog/7kjmOYTWyGkpVaFXLoG9bDxGKHN4VLu/IeW6k02gEBGsa2VGxQ4MX6RWP
         JHZVvc6tFMpxM+aEmt6woF1gXPKu2H+LXSMymF65Q80WGZGHE1JiGzmq1gFbok18Lia2
         czRNKHOt+028yCQ+lzz01/Qq1qR2KVdrBITxBNIMdZn9oE0Vq52B7YL4QPJSP7kjFSeF
         vhMsREurd80CyUfRhhXpAd0PT9bSVNOUsPevLwMqC1tcmdcg8prVCDXMIh6/JVejM1lQ
         88Og==
X-Forwarded-Encrypted: i=1; AL+hErEMqgVxC4KInzdJQpaYqh64YRV68bXUNHTwUr3pkoS1wySRFQEeeVCCHOOz8AgANimosJ21sVvD9Q==@kvack.org
X-Gm-Message-State: APuU4Z/0V89E7El00rOBJXwXKdI2IB/pPEhZCnsRWGoXXOj++tyaKPGy
	BB0fbVqowrEXBMJXfLPInidwikH2JdpTmLiNaYP/B62tuHmNPlOhSiG/HE+10Uf/TJSFyxpSzUi
	TagtUcvhr5qYY9iOvOf/qopGi2Vm5SzU=
X-Gm-Gg: AZFdTZelJfFnrH23KLxpxpSLVf/masXyS7KqJiap/ywELkesklQscKRQWUuhFLhbebq
	OFyGdtLMvInN6suztkNf7s+GUnxCk61s5u3j56yenXMENe6w6gr+V4JW39vyHo4BuRoJqL+N7/I
	fdcEEiqZIU5wNlVMpG/dIjUQKrr/vx1x/Yo1oqphxSRpNhVpnyBCOtWQ/rZGVke0qjveEJ1/9Sh
	4barlfDcl3I8/nJ2GyEmRfkmDfbc0RHn99UvarS288XPcHufZaTGMJRZ4Prx63m1r0hDegalPe0
	jWCQUyXd0JX1u7BEaxrsOyhD+EQVq0I0TGBPWq4dstWGq1OqRtrrZ4lGfBVUA6LpQyMsDa8qtrb
	/0WJm0FEaZWfFY6Kl6J/tAtb3XuSg2rDxmlk7V6ScaiwNWEUTnypganyxqA/u3WYgOllPOqyHsJ
	n+0PQ/lsNimm3beBzW6w0KzXrpJ6U1
X-Received: by 2002:a05:6808:448b:b0:573:2541:1804 with SMTP id
 5614622812f47-57a0a20ac94mr14111097b6e.19.1795485896484; Mon, 23 Nov 2026
 18:04:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <179545322647.4.683470932650691650.b4-reply@b4> <20261124010507.90151-1-sj@kernel.org>
In-Reply-To: <20261124010507.90151-1-sj@kernel.org>
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 13:04:44 +1100
X-Gm-Features: Aa3M54pb-4ILmEklgmD1c2iD062twsVtwMwCSlytUWUvsxSnv-_pzV9-1H4xjJs
Message-ID: <CANOyQmFCkqfgQLda1EUADP2fVx_o6g+w8RuTAV5ugJ_sP3OkyA@mail.gmail.com>
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
To: SJ Park <sj@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	damon@lists.linux.dev, linux-mm@kvack.org, sashiko-bot@kernel.org, 
	sashiko-reviews@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: zgqmkkiogsyxhytrzztzgtji91ncq5yt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B895214000B
X-Rspam-User:
X-HE-Tag: 1795485897-309565
X-HE-Meta: U2FsdGVkX18Z7vCmByS/4xos/JYqeEoMeh4En9lg6sb3QlVqJ1urXSO3cmZRHE54rWom99LcXy5uLi6x0d7yXmn5/0Nv7wUyxdQ4t5Rzn/4YwY4ZKeTZjR7zhbPcQVFpK7zkT5fZABTRD76tPasTSrOL50lYhy6rfjdBtjFZz+Id2S/zoL89q4/8tqiCUbnnGPBuE0bLDDpaAs2Z+9QAi4cEfL+fLUwIDUaYIToG+KW24C2ptQs4xxR7GeQZmWhM/yaXH/UeNhGgJSH5K9WI9ooXKtkVYodvTF5I6q+HUGdsb0KfkYxw+9nIbMiOwEiBLFVAj/nj+85MvR4BHkIjN4+WMz63u43VubEjGLj0PlDQN5yNOTqIxW0QDQjtVjQsSdx8MX3j+BTiExJMm/ECnyYqhRXhGyE+tLTscR9k5C4gxN3MUl0yKIcQo8Cqoh8SP0xghkF1gIo8BgKZ32pqhlkYSJAfjB9iCs8yEeavegXamGWWFkcrwWDPOui7M+mQwCnps8Agz1BgXc01CLbaAY/AO2YyjGuOPBQoQ7TxcHnyBI6Mub5CV1G75SobV6n8idXRbva0gntAKYoBakJjzS2VY3oPng3R1hojCJEM4mVthjtMJSejHjIi7bPBiawBbpWwU4gufZAR3ISOcCqLKtcfpH0xnHrA4zdsuXuYP5sBl5HCNawPHlrbFkJeZjkBDTOXJ/Es/MNr00DjwPmRK//jDfjqoen+6A/RU0rvKBj2BLFUm4NvrOttybeEucI1rorDQiyHnpkfitNkd8WBpBP1zm/LYL8RvuEuL4yLukhFYmrn5Cw4dbTZ0o/WRaQwrKj4XxtbXjXc313Fdzbew0+rs47WCMxCH2zfox+fDxrsZ49GdHSu6mTVHUPjBsoQ1fO34k7dzZ5RBnvv8lido+JH+fyw22rMxX7qXipQ/gYIL5p2SI2IIYSUGgkjda/FNUfcBw1VWM7XjBlR3e5
 wv+0b8vF
 uYHXYGR3k9TAvPpACbgXqZY34ZmGjY98N479M2gEozoRnrOe1RclO+aMbalakLKnZldSdH9xX5oxhBfXL1QksLA8nRz+g0hQjsYRGRIZKWRdY2V9Ghr0qfE/N5WhOvxRb+MCrLEEpM9tVThqEYPcrssNOvW/lPX0yv0+ZxX38iLsj8FZFPey1SG672OOov+GS+7srIw1VZzmKBDlNBExt3xKBDb4+TCF6N9fuyRAHslVQSunBKqwn/yaa0dWlLtOrSHR0oC+/kv/cvj4q++O+4OoRWbnNyfZwT0LpuxP7QsOJuJDkS1PZTM+4dGt+CCiRkDHGWx22AvZgSuhSRvUX4LZgtBxZAyRMS9MeUOnRQrUD1PjtbWhmzyg7PjwnTMg2btjOR3h6aAmUCsIITzdRob7k8SJxWyBUonZqVf+b96TAG0Ht/q8kDhQa4HmMDy+YJhFcG0YnwbI7pHO9qbOXx1WSNBZ0dfKZUKDAAyGLLLXkAfMWtFrMsFEFuuQbu/oNi5zWFKdJshPl7x9j9NG3UisaH8GGbqWlzm8ZYEo7MRPpUUEfzzcJUoOVB0ExJgHjJ4aYP4S+jCWuUgdm+FzBXdeRwwK/Tdtss5hi5/xeknEEhCUe4Ii9uc/UD3AUWgbn/jdB5GPtxCtACzpuY8dsphpml3vFk8MZKRJiUNqfsFh9G6L0m4TKFQ8qZd9FEOKXpUj6lzEacLfdHisLicKz7nzXC4HAl/8WC8Y8BarHsbFv23Hu1L2dWKaaO883iBq2NeeL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HI SJ,

On Tue, Nov 24, 2026 at 12:05=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
aid if that will add something that we need to maintain long term,
> without clear use case.  I think we could revisit after we get such reali=
stic
> use cases.

Sure. That makes sense :)

Thanks,
Aveline

