Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF69F532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C9D6B00B8; Tue, 24 Mar 2026 01:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4156B00B9; Tue, 24 Mar 2026 01:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5213A6B00BA; Tue, 24 Mar 2026 01:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44DBF6B00B8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:53:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 180F0BEF2F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:53:42 +0000 (UTC)
X-FDA: 84579889884.27.F79A38F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 452D0180003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:53:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yze1Njm5;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzbNzyvofSkHDrmxsguNNuZmsCaCuOfcET+64uHO95w=;
	b=MIx2PsK8E4SQJTCa0ahrKJY4TzoAFIXxcB0EWiK3IioLAheKhpkq9vDnU3ZIFDK5DsMKlO
	L1sEhABHb6H+gIocZpTPbKh/3h+eH2oKNrvrXuJM7TV7yQs9QrHsF+PaoEyMXyuCgX9dW/
	9ixuQzRMD+/EMjgyomjGM/Bx1fl95GU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yze1Njm5;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331620; a=rsa-sha256;
	cv=none;
	b=aMRQcoiLDXJMntJHhobGgbCkk+VaqxQclHJRsp2qnTZb/QsPS1wLZEuN+Rl/SQsw/M1gCV
	7hOllU8JHFTeo7ojj31IGk4jiBTziuV9Q9lOpowXFO4zaYsabCWIcUD50/4AvlyMRENFw5
	Ib/dAqQgxew8AjQT/eCyAjBW9cJ00tM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b04e6a989eso5637795ad.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774331619; x=1774936419; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CzbNzyvofSkHDrmxsguNNuZmsCaCuOfcET+64uHO95w=;
        b=Yze1Njm5G54w9xcDqmCJol99NeKK7klyYITlGR3WdTUc5XErsGxB86RKdi8oUvOJF4
         BrzE5by80W73wCgwHfCfFaOcbxjZb8BmnhueaNNn3TGi/EYCebR03EPtnz5KJ9j1a5h+
         Ah5+0aFh1H9NFB0CxJg9+HAmwUKaei5+dSRRe1JX0jvlvBGqg1WJjvDAVaKHI9vVboWZ
         6ttjDFQo0rPvZ+rPXVF4+KhoFzvsgg6kgKuaLqlgND++8IsivARe6AEEgoAhdu9wBR6J
         GWLFLZyveOVxcK1lX8HuCaAmySBqFCrUyZUml5isSIEFsG9DRcXqs+lzcuG43tkqz2TE
         e8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774331619; x=1774936419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzbNzyvofSkHDrmxsguNNuZmsCaCuOfcET+64uHO95w=;
        b=JSCXEceY/gGa+bSr0w/1BMq+TR4ag+4txSRcJ1wnWVsz0vuxVZz7LEPvPebQAA3AlU
         ZSr6VR2RJNAJ6sTUcHI/DlYT3RR1rMO5ne1DxM9zGRC7QC+QohzaY5wKhWVWYVQhhyV6
         1FHu/U8uweyZcciepz+3h+NnbhYAe/KwSBd7WbUzAekndIAUmoAMj9nhovKtQT7J3HYl
         qMyy++dpV3+I/0Ehf0gH0i1t60KLY8gk8SAW9iLywYXpuFkIbybaJVxfkdn7AyjlLVq7
         o3Yf+rMpGvjxV7QFVOSt/IzadoL3/ZkFsBMhnKhCdArz7FKgo7ukhUr2cGgDOUBAaVmT
         kotw==
X-Forwarded-Encrypted: i=1; AJvYcCWgTeE9rixsGtaxfg7We74AYFylh0G5os3gfAB549mc9SSCkUclYI2UYthTgnYeDmUwEMhOBWHiFQ==@kvack.org
X-Gm-Message-State: AOJu0YwoctAoA9m3ziHBHomekuUQmYPri/SuUgPBVnD4N4iXQ33bD5Jw
	ylJsq3L7lnjRhPvMJoe8Mx5FpcYsGA3S6vN860/OEphjI/CNljBGDoHI
X-Gm-Gg: ATEYQzzVzQHrMylxQBk/nBKQVydPm1IYP/irFm8014A5IeAozpz2x0cfFguW60EoYOP
	LjhkSq+CbGZgZCpEfJZH3GdYUBlnRceIgtAtthfkhHLG6QDV44Xz0oBDq7UYtqHdY1/cg1pajwm
	ujLqy0TsXvXHXfQ2W6CBoIGVMccslFIfDgt+gxvdN6PlYwfQxqbFJmiAdgByStcJLTqZW23MJs4
	CsQ75VwCCINd3TFFDBF1zFv1j2xNEc35R7V1rLcOny0YBgfX8lIsSSyP3GC/qBCbzKpUvKbZaK3
	dSwbpPl68Fk50dlpnyyHsjyKv7yd+fn/4xzUl2LblD3LDxxQORJ23JTWYVjWpnyKRRqUvEpiv/p
	OIs9tRZ3Bb5m5ZzRxPSYF5W5EpH2YQ1wzVrLAADqzgnYbHvOl5XHU8N7Y78cCw19m+IHImOYsy+
	mw+1ypfuAimOV/2XwvtFPENOHOQWvM49h3Fv95hu3L/APfncYgSISsYcAS43+MfoWrau01
X-Received: by 2002:a17:902:d582:b0:2b0:708f:4dc7 with SMTP id d9443c01a7336-2b08278afb0mr138908715ad.29.1774331618826;
        Mon, 23 Mar 2026 22:53:38 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516194sm128476465ad.4.2026.03.23.22.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 22:53:38 -0700 (PDT)
Date: Tue, 24 Mar 2026 13:53:33 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Pavel Machek <pavel@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 1/2] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by pinning swap device
Message-ID: <acH_svpUwaNtFeJN@KASONG-MC4>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
 <20260323160822.1409904-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323160822.1409904-2-youngjun.park@lge.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 452D0180003
X-Stat-Signature: jca6dcrm5efbr96kgn1pfpm6aetc551y
X-Rspam-User: 
X-HE-Tag: 1774331620-838621
X-HE-Meta: U2FsdGVkX18O4+V895YRBuW9Dt51r2LKk3a3Qj4bkHoEpJ/xcy1IAaJi1IUllTkFS2FnCTkreDa6stH1e79XUS274p5V7Z294jtQumecdINEAlJKa78X7COXH1i3TJbxGixxrTb3wquQLaSuxgM+lJUfr2IPn3555/Jc3616921aqN+Sl2x6qixzKB5Nw/W6iqhrXzn2IVNVg7p203PnCJutQ3mJnrh2nshjscBjJhduT/hc8K6fdppKHRY8KHxCxr3jOalDIE7moL7dJiWQgaF/qkFVyh5tHHybF52N97DT3U687gmdTTzJBOTt/AfQVAKAVUW3Y5fMeD0kQfuaQFruf1SghmWWK3q0+EqAM8cmBWGidCZauz8zqBrmb3LoeU20sDxQo4N84Yab90yC+JzMuhyXhqzEjMT73QfNvvpnM7619EwRoynEumgjGVzPUUDqAHUSi9MJOjbpfT6YK3YTaNxVa2K5tHtDuvKcHqvUP7h4UdL28gNrp9ZbM3ncYSphhJtLQ07cLa+5jr+uaxC5lnHYuBXC03TpmtLCrXYnkgs8EL3+N1vOZ6fHOmetj38gWuJIwm1L203pcl8fylQcxhibf3orKQzB8h5WnE0si0vBYUYiHkq5k5a2cN/r3NTXTn+f4MZ6H3oNSZ+P++jEfIrLDdpeHtbSI92jh3ctUSw7AAdC8oFtPQozTkhxk0e+20L3O0HKjtsaA61uRnebnOzMVcKb84cJNIgJ/yGSRfiE9rwNwFSrP7kecPGLj4oP+mkLuqFi8eKoCbtXg/O0QjxQNl05ivSInp0oZiyiofVRtWhcGHzxaeYg4W6lHk7wUXc59u6seSCXUNpo2hersZ3Da6K1AlTcG7xw/lvFU2prEr0dqj3K34zsCnG1UO3B2F2yp1teiHTx77HVYdhsqOHlYis4afUelaZqrUBX6PMGm7LAfr6mgkuhP6hHD+4suG4rsD1GDj/ObC4
 w2yPIcQC
 MpFvjRvwPuwI3PnLvmv0ysZx2TdbOWs8HCm9J0qGPYuRkcE5y7VZTclo9sDLuJO7wcWGMcUruueDQSlsWH+9Cwr2y3J5olGIP+pKXr7oUfDeYBgySh9q+TBvPG8Wg24yyZqMgzQWcrlhl7S9Q0i1SkipnF3z7TX8DUC1/ixvVptZPx4/2a0lmX6B4ZZZw/jJHOICo55yhgXj/SruvelR4X4FHmdu3bszq9Rp/Z+cX+KbA9NvLFEGLeO2EyFNErC7xLhcoHAmteb2/TKwAqdRq3b2Yu/LwZBL63AVs0VbPdFlNTKkM7SMuhYLb2W7o71xZ4ovGMU6q5E1suVMQGZjjioITHS/pplmuXJr81WiHxITQgZlojiKBmv/CX/7PH/T2tVu21uUiNqvz4vjCXJlP3s9H3yx7F5bcikcwPd7iU9MZy36UFQgBa6FDB3FzYDKFeJdLNd5JyTlWPJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:08:21AM +0800, Youngjun Park wrote:
> Hibernation via uswsusp (/dev/snapshot ioctls) has a race window:
> after selecting the resume swap area but before user space is frozen,
> swapoff may run and invalidate the selected swap device.
> 
> Fix this by pinning the swap device with SWP_HIBERNATION while it is
> in use.  The pin is exclusive, which is sufficient since
> hibernate_acquire() already prevents concurrent hibernation sessions.
> 
> The kernel swsusp path (sysfs-based hibernate/resume) uses
> find_hibernation_swap_type() which is not affected by the pin.  It
> freezes user space before touching swap, so swapoff cannot race.
> 
> Introduce dedicated helpers:
> - pin_hibernation_swap_type(): Look up and pin the swap device.
>   Used by the uswsusp path.
> - find_hibernation_swap_type(): Lookup without pinning.
>   Used by the kernel swsusp path.
> - unpin_hibernation_swap_type(): Clear the hibernation pin.

Looks good to me, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

Just one trivial nit picks below.

> +/**
> + * unpin_hibernation_swap_type - Unpin the swap device for hibernation
> + * @type: Swap type previously returned by pin_hibernation_swap_type()
> + *
> + * Clear the hibernation pin on the given swap device, allowing
> + * swapoff() to proceed normally.
> + *
> + * If @type does not refer to a valid swap device, this function
> + * does nothing.
> + */
> +void unpin_hibernation_swap_type(int type)
> +{
> +	struct swap_info_struct *si;
> +
> +	spin_lock(&swap_lock);
> +	si = swap_type_to_info(type);
> +	if (!si) {
> +		spin_unlock(&swap_lock);
> +		return;
> +	}
> +	si->flags &= ~SWP_HIBERNATION;

Will the code will be simpler if you just:

if (si)
	si->flags &= ~SWP_HIBERNATION;

Just personal taste, free feel to ignore.

And as you mentioned this is on top of swap table p3 so you based
it on mm-new - but isn't p3 already in mm-unstable? Maybe we can
have it there? Not sure how much conflict are there with PM.

The code and design looks OK.

