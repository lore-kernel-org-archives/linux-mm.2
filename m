Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C5C606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BdZCdYyR
Received: by kanga.kvack.org (Postfix)
	id E5C9B6B05B6; Tue,  3 Nov 2026 13:05:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CFF6B05B7; Tue,  3 Nov 2026 13:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC6F6B05B8; Tue,  3 Nov 2026 13:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7A7D6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:05:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EB111203BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:05:51 +0000 (UTC)
X-FDA: 85394586102.20.E793EB0
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35484120010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:05:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BdZCdYyR;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIk9eOu6sfTTG6oQRXGPr58pAWgkze4z9h4PinwbNw8=;
	b=OJmzMNTFnA8ZCeCl2UlAajt2TQYD8vDANs3ojqfNbOv867lj0fmza6tRVmFfiXyZbOWAlr
	2v6CZip+u4ymU3d/HWbAh4rRXwOAW8FzQAPftET7e2G65FDLdwwCN7Dqzv8H8aqToVhTL6
	tcWql0bmVNsUUNll9zMBYsPexCkSKqM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BdZCdYyR;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729149;
	b=SZL/jT0Ej+Pq72Av6oQmYRJ+2Cc0NBhb9R2im+Z7n9TdHnaWo0olzqytYPcQLgvYYJ5AKB
	4EP12RZop0FWCuquiGT6kEKAAy0WCZbMnyUoDOlzdJJ9Mzmc/mvnum80haSFrCV+nA6wtY
	A/xPeVqJXp0zGUupaEFwqjenNS6h/Yc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a064dcfcfdso1619609b3a.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793729148; x=1794333948; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DIk9eOu6sfTTG6oQRXGPr58pAWgkze4z9h4PinwbNw8=;
        b=BdZCdYyRHAeI1PR8AWHkPWxfO1JpBm1MBVDXD3dvHpQzsZAuF863pDpASk13vXTb3j
         LkWd7fjiOTugeeaVANPTvlesp75GfED8E1GEAmYGN+GYM9Q9LCqyD9Pl+4DtbS4OaZLE
         5172gJXtMbBgb/q27dEuH9zYXcV+A+ARA4K+w/py0XvRiH6rFsQTOnh23KcHKFQdTG2Y
         EohjYeNrwC8XDnjz9DrcOpzHwZ/RSauD5iKUVr6p3qw0s8UfbOLrufg+440UU1X/fAno
         UNGNaYZ9UFhQkZ3dqRUC3mqhD90pZnD8HOy935NtOoIQltiLptQKQ/1NJP1VwlPOqe8/
         eSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729148; x=1794333948;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DIk9eOu6sfTTG6oQRXGPr58pAWgkze4z9h4PinwbNw8=;
        b=M0cj/YjbjVv2Z2uzmrp0/nKeEZgDs/KuuEqYcG1FGwD/RxDf8O1b0YyrV/ZUJx6PmS
         i1lvbQke+IK0tPF0qJemaT2aj16GBgP6wPvSOSzFlU4xMJXeTAlwpk4OFXCBDz8QFaUN
         x6gV6Kf4mm1+O+PmL7r3zmZXdonVLsIASd3KFJFwELYlUuZ4MNxloyhv764CHy2cCN0b
         5v+BMEX/ZjdHPATR42ofD8TJsUn7dXDE5b0q1Km8+x/+1c9A2gPo5uFUn67WSH8knuwd
         k07WNlcx+tASF79aGFhu2aplOvcAcJy0EzQk5YePYWo53TiDcBppwxI6kM3g1C5BsuCW
         EfrQ==
X-Forwarded-Encrypted: i=1; AKwUvBw0/d97R46HiDYVOEz4RdrGvYBoFkBUc4QoA4QaxaOVmeF+adWQQ7UwlWm/ChcAcbwqrXDVT7WaYg==@kvack.org
X-Gm-Message-State: APuU4Z9Yzw0b4mJj4VcKxBVFJMkaAaVe6LOJ/0tGqXM1eu85EIr4VhBi
	faSahzxHrsUfBYzWlozihOsMPA9iO1F+1qPFv9/UuKvbc4dAN2zwR7CB
X-Gm-Gg: AYBFou0VDKtApM+KSAKpByhDtFqrG98f0CWmuyT1UvPwxQXjKUbSZazzZEbG6yv+Sfj
	LnZJNjC0LufEvEV6+hAMos0hTNxY9jFwPRc5fWztt1ZVWqo5EsKBnG4yYS8Oq2OqtgIQuiDcnFr
	5AjEH/rV4lUxajoevd+6ae8zWFh0Im6OTwYefxPc9JwnHadthlNe90cD75on3Imu20NnPLDuCBq
	GoYh+rURefRZXAPRDWkge+7/BMAMXEZaFXPzVbktfwOOYU8v0HnP6kBXC3fR4JVoeD+zKA5oMpT
	mho2rDM+5fl+cW+K/sK1Ev1cYoKBskstWPTUzFUBzlf+o4U2YZNTOG0tdBy4R+9aMF9+baBvzTR
	s6a+IK1LUrrkiYgBpdbdDzvvIXlY0CpUT2oQGSumoTt+I61E0F7xbAXH/HeWIc1pRgs4ENnjY6f
	jzqnb02yncrd0S5ryPTdQGXS8HqZOOFT45UZBvnvU2pgN5K5Vx7toiiJ9nhcY+HHxGhxZrWpEyh
	BKkOL6JdB0eD/wOKxvVu08aCFGdwS9iqte7uT2X1Rn4hfx3HuEQNTmSrsN+yCY2dQAtdLprseTY
	wc/JsG0CgJd0N0/8dTno29xq7vt5W5GSYZmjcamwtV3Lb6kM3cxejolIvDOUKQZzmFoR5YqFL9T
	jVhKK4FhB2M9z1HDrqjP307/8Q3OBZnb1tes=
X-Received: by 2002:a05:6a21:3216:b0:3de:b120:bba4 with SMTP id adf61e73a8af0-3e928e5d19emr11228287637.50.1793729147815;
        Tue, 03 Nov 2026 10:05:47 -0800 (PST)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46981369sm61910a12.25.2026.11.03.10.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:05:47 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 18:05:46 +0000
Message-Id: <DMLRWY2OAGS9.3KD9RKTC5MYPX@gmail.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "Federico Di Pierro"
 <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/8] bpf: Add user memory kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jiri Olsa" <jolsa@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>
In-Reply-To: <20261103075916.100050-3-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org> <20261103075916.100050-3-jolsa@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: umo6abzm73wuw99w117mp5czuhjfuyki
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 35484120010
X-HE-Tag: 1793729149-404126
X-HE-Meta: U2FsdGVkX1/mdXS4Ddo+ywxbuNlPDeIL9+NUeUAyH6n2dDx2aWgIX/jZoFoUKqtHfp6h5ubq4Umet1zoHTJ87mORj6A9jaNX6DtrW6Qky4yqy4KprhMP4E6U/5A0uFBorVTxLu7N+dLnnD68a+d+nSLV7oe8Q39/yFwrlJPYrzZiC/y+KFFoutdUfRvMUE4pfllYONyrddK0bA8XXWySHBu95TDD5cJHt3jzHamDGXpzUNkcYmqdlUrKZ9buFYwKkfbPEEMa3ilUHwsyKiNwJ/eW8NfPBROrHe8F3pJhVCKhAHn7iua4JqkmojhrLKHvzhUfZ/525O/yJQ5LL/jaLfNpkhsSOZ5I73pS7Yuc4q/hY1WVLP9VcExHGYQWHAIJWnFRU4GHE4IFwDnYWUi53Xg7J2B/n6uNPxX7AsbI491xdlmDYYXYyGsU/TOflT8A4PR6hjvtnz2mDWg6TGeWaec+IoJldoQtjYjQgr/5y4fSlfxJFVmJI2+3Kol/SLW0I163B25ARVuX6cZDdEjeKLe+8B2itK/GIy8rqXKbP14Hx+cx1+ncgXdvY4mf6oKWKRiWWOlYuR+NQ3///9yMZEjEwJkbfFg3VO+KqYtWMPQwwFV7hBv3bK+mYd6u0QbTROmTqDbtI9+lBMhJYtCP4zGOtHshzjJBsDZj9GrysV8T4nkNm4mPFOqz4kgs1i4bA7Bxeg4d2ogkHTRQQurQIRxqzE2SR0aVh4IGPXdU4DTrBOck+N+8M7p7bd27xsM7eQxjSHrOiak35c5fjVXDxCJNezbjM9iI1XO+yi0L1ZGWZKHLeHzFLPNI3vflSPHeq2KVWryb0z6qzAzS0E/wK0qyN4RRXKD+7X+1TclBZRWd+AishmEuNSc9YWX9aPQbe0RymZQKmNhgN9/cb/jxV2W24nQFAAjhNaVUQJYwjNWpk/PUEgvd5GrxrsXcZ+uebSATFyn8TJlMUB+IQ6i
 d8TFEj9E
 s8C3q87z4+tsoQ9DfPoJpyQ3QAyywxgRJquvCytrSOUrgvY75a4XKxYCe9oZ+AT4w4BijZXwqIVF9BYDNj1pOJSprXDlG2yNtjUYwxodJlCiq7+mzaGXtC6CYW7YO7/g6TWfuLVV1HpstepjCqKCeUvHMdrj0+Bv8GcGixVmx6uRhcixK4rUvLQL6U4SyvApYCPG8wry29QoAfdtjsTgMKxlj4PUe+5z/RW0UNwb0qhpAqjxgXFZ835zUUooPDHK20V8dqleF4EqZbvyocMxFubBwl1qNV+BUV2hBFmMk9LFbltMwzatk/KQ8Eoi0U0fU6U/BDI9UhxqYtBg9+87ubfTEw6IDD79QxW+I8cUwPOi8gQHaXYmprtyijTPpNbZW3YvWXAM6udKhIoju704zdw0ZQf1IJsD4sl10Qn2HIZOPWjI3LS54BR+HiwmLSNSD1fAStjODOs1yJYcR3QHOPQbXhXEs2k3LLXGAtkE2a4JOpNReQKx4op2G9YuvMljalcqIgCLlTfqOLqucZEU5uesOIoNhSkXQscv1Y2QchYLddYKVkUqtfx4UwyDwvrIkA1+gS98OLS54AqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> +#ifdef CONFIG_IA32_EMULATION
> +static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	bool compat = test_thread_flag(TIF_ADDR32);
> +	unsigned long addr;
> +
> +	/*
> +	 * We are not in a syscall, but x86 get_unmapped_area() paths
> +	 * ignore TIF_ADDR32 and rely on in_32bit_syscall().
> +	 */
> +	if (compat)
> +		ti->status |= TS_COMPAT;
> +	addr = vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> +	if (compat)
> +		ti->status &= ~TS_COMPAT;

Do you have users with ia32 tasks ?
Without this code bpf_user_anon_mmap() returns -ENOMEM in an ia32 task.
Nothing breaks.

arch_uprobe_get_xol_area() calls it a HACK, and that one is in arch/x86.
kernel/bpf/helpers.c has no arch #ifdef today. Let's keep it this way.

Drop it and say in the comment that ia32 tasks are not supported.
Pls don't add code just because a bot said so.

pw-bot: cr

