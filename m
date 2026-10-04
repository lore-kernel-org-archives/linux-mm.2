Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA4ECA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 15:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435706B008A; Sun,  4 Oct 2026 11:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7636B008C; Sun,  4 Oct 2026 11:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D53A6B0092; Sun,  4 Oct 2026 11:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039246B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 11:09:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60A64140B49
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 15:09:08 +0000 (UTC)
X-FDA: 85285276776.04.D3AE5A3
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C14E40007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 15:09:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=LpoIUQLT;
	spf=pass (imf01.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791126546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjPynkeSS8mj+Hdi4I2aqG3Yn3kZVr1yRJIIH48r5Y8=;
	b=wCsn5Mh0aicXbdwbL9/DzF2+6AgSicnDVLIXqrPhPfIQ0ATY72nJurDpb1hao9GBXBPsYg
	FqzSjA7Do5r7DLLe5qVP+fjVVhpHFwmxkXET1MwdDemmw4DUhzwvINYvwdnlOimhLwVLbE
	6xsEKGA3kYZJY/sCsGR1WqFIaRMOEns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791126546;
	b=fHiSmA2v49W44pwzCTxOE3vYm7hPdFVGCGWnC0XYbzdUc2KjOoVYTaAmG1ag2h3yaB6KEM
	VqKOS2sgzBnh1ZGIWQQ1cQvjTT6ISurEU4k16YOUxEvPcf6C0G8GZJ94ZSwu46+tdEvDSC
	z+TjIPdg3c8ETbtTssO2KcoNICgQkyI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=LpoIUQLT;
	spf=pass (imf01.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 29CE93F1E4
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791126544;
	bh=gjPynkeSS8mj+Hdi4I2aqG3Yn3kZVr1yRJIIH48r5Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=LpoIUQLTpJa75xfXo1Yy4Ab2Q0bqyQRbms1ghZXdeOXBnPr8i1Qu5CRVM+2//H8Zq
	 wIQhbJdr9ZBbDsE+ysoYGzIgE84pQJouWZH1OUtJbBsbtkiZNWv2y4yiQ0VzA8WMc4
	 H8eHMKxeiwwhKuD+fCVFDNqjK3JWxSw3NHB38J4Fsoiko8DnefUjJUEoLd+VGLWl2J
	 GSqIOixwO1L3PwXohEo3UjAMSIFbQ9r3ZjRcx2V9etfNe1i34Q8FwqYDJ2VNOiQpOF
	 pY6v1A0kiPwCd+UWcFcsSpNukpR5FB/WjGHQXfj3ltQHZDpScgtymlb42SyVjq0fxu
	 KB82o/Yz0hFQIEobb0bMiCGjHTcfiUeNfpq61uuSq8LMf33MwzUBhnLFYbFa8RUHYb
	 6B+utuby+DeRxwp2Dh8ZSrSjAc+Fg87feH1fKyIvc3FuVYCYOQC0a4uVpleKI4b1qw
	 wpRxsryILsERTFqxON+9PmVEYcfby+naORmNENZPD8vY9P3+7M3vQ+A6feA6y9BgUJ
	 TpRqMgQjkUX86agA7Cp3rzhYPVatl0fN/wh5LViLllONNFymTOVucjI1ySp26veoZE
	 WOcig20t2D+tOjIVnu364lt6XGTr/4h6TIafRPj9h6ndQzDLlHeME9KlzZPFzOErf3
	 WdqoH0Wqdaan0Y2+ogDR3Iqs=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a01eb045feso9404325e9.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 08:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791126543; x=1791731343;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gjPynkeSS8mj+Hdi4I2aqG3Yn3kZVr1yRJIIH48r5Y8=;
        b=WwbHYSDoiNK/nLkaW1mjdQzcM9LDCf2j1ECiCjGl38O2fSDvVCqSWvjtf1EXM6IenY
         HnuO2j/Z1jhgrTjAxd3mRG7Bj24C9EgOg5Jv2RxGuFY4+lQ4PjIWxUHW67JcDAPiHJUI
         NhmRDQ6EY9vi73TMDROMR3gFhBdA8DSFOx8+LuNV+g0eiv7xHG7f3vpFVn/njT8mILwF
         IEjLeHdRG4P66ImgiYu+h4RPqzJ1X0FsyIzvFW153h79qizex11vQO5alI9pmKMqmqHV
         Wqc6OWZGcK79xlzK/f/zcrOJqeaBbMIDvrMAIyweV2dpIy8l+DR0WLLW0aRcDDxEk4A1
         jBkw==
X-Forwarded-Encrypted: i=1; AKwUvBy49bnc74Ich2w/uMBy+dquu2cE82ptMwLAHkC+mdO5qPJYmk8VkYq8F5U0286AJzbjQVcpYJ9kYw==@kvack.org
X-Gm-Message-State: AFuF++n9sg+Jb6mQg5FBSDQOhOaneqljx3jHMSNVw97UO9uVNjBuZqS0
	ld1AImhQr2sisQ35HzTUjqpOlreEyIfDErPqHsXSK56loo0xDpZ3fRZxggptSHBaDmPISl991hw
	eitjGReL7s5y6q0724Wkrk7da8MI881RNe4Xb5EFJTH3m/D3stoVY7xW5TMV9NWdPel6V
X-Gm-Gg: AYBFou1oT064kEKLCk80U9nha0HTfLaLZs+V12/bUrbN59GriCEOCAzfT9HNcBWPOQp
	uD8luUA+Ff9u7B6JMgkCJfNtasG+egZUnaXqPcSUnDvrHv9jZShTp7YouAfc7fK6vApcIOX4z0O
	eylN65ggiZhhVxYpdubDfmOSx6vn/DGa8MLqpngBkc3b5QVucnh8LqLd9qowlEst74VNigtU3g+
	TgSiXm5/lwOe5ezgyuRgbncvjphF1+z4FnXUG2kT7T7lZttIfMZ0kY1MmTjkXc/UvBHjU2VJ5cJ
	zxvcWW0a6TdxzC/iMoBaQBX2zYlwT03wm87NiiDKL9SAR10IkYVMORQa7cW3OGbmGTBbC/1/ey2
	OGEHBS0g=
X-Received: by 2002:a05:600c:4453:b0:4a0:2423:946 with SMTP id 5b1f17b1804b1-4a1680f109emr87154365e9.15.1791126543673;
        Sun, 04 Oct 2026 08:09:03 -0700 (PDT)
X-Received: by 2002:a05:600c:4453:b0:4a0:2423:946 with SMTP id 5b1f17b1804b1-4a1680f109emr87154015e9.15.1791126543248;
        Sun, 04 Oct 2026 08:09:03 -0700 (PDT)
Received: from px13 ([2a06:5902:822:4600:8c2f:7cc8:bd95:9422])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027727cecsm272425775e9.9.2026.10.04.08.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 08:09:02 -0700 (PDT)
Date: Sun, 4 Oct 2026 16:09:00 +0100
From: Chris Bainbridge <chris.bainbridge@canonical.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Miu <jasonmiu@google.com>, 
	Alexander Graf <graf@amazon.com>, Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
Message-ID: <asJc1GIBbCJ26akS@px13>
References: <asE0R_f2r2TL-3Sy@px13>
 <2vxzcxtplh4i.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzcxtplh4i.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C14E40007
X-Stat-Signature: 1389o44p4uxb9ugi74cicm13gzsohmbm
X-HE-Tag: 1791126546-612426
X-HE-Meta: U2FsdGVkX18lLNe/T1D9dAArr5iGWCbFHRaMmV3JJLAMgZdrs5yMu6tmF76Rvrp1+dL+iayQVGyjqrc7s54x3f4jQhpegTYsqqraz/dvtT1C5OxxT6S8jSq1d5J1fxuZYaBZPjdZOK/xWi3WzUDhp0pBJsUb865f2AqWRMyDm4G/PNTrkAyiK3wXgRAJQ66PKe0ZBf6zyxy9abBxBPychAGot4Z0sIKC1jCY9qdrnMGFWlXE5RWE5Hit1Gewbu4I6M72o2WZ01RZkI8q0i0bzWU8o8/qn9dxTJ/hIjVXZiq9j6H7TH79mILnfGxFdgMTSGcxZ3HSvaTlv9D3kQwk5Jg/HmJt/ptfZ6I8ITXEFH7PwTQBR1xH4aaA7GliiRJ60LbTSxrGpCScLbiA3ouwHiDZ+rlPMFtpESxjKbIMzv64a5C+9jEhT7Omslbo5UacPrD35BMRLTzxyLU4lABlOhFGY+ipsJLxQ7X4szrRqqIAL8tXSObC0ia1NT8X5uXxXyEM4i2Y8owkKECkDDfUGmVi/ftr4/wcUqD7CwwsyyWGweEe6YZRdq9xMbFHGhF6B0xn90zNUJk0b6ngwRA6NgVtVLQLnnXAIfTecySBTy9HS2eD5YuTR9ODsGawJc4eCiR5t0b3934UtP/aOIKrKvQN0gi9WHcr7rpKOQdDf+4ucBMvuiNPMcfAsIBAuqcu2J5m3g6rRazTzHAPPW57x8JCwliGSIVKp8UU3xeFEGO4sHAST6CGdjkhLh2jct+ZKt7fINrFYQnRbveEqRMLHHgkMCxQDUyRhA6FZmU5GK0PrzxasU83PNyUGQMAEK9sTW0rd/Rb/n78c+VqTbnvaR1GnJvIxHg1AVkhEqW+kAxhAXlpIRZ4c15qs32UbMbrizS7HMa7/zxqgKts/vvVn5aXg8n/ZTD1daWTSog41x9yQfi+32OgYoEivNIsgDL4Y41XBVpTIR8gTsWlr00
 I1T6/ZT0
 JbqJcdpMxu+Vk3/L+s+4+3iX3U1+spx5mxslZdEbcu3mAOScncxioJG9XuRPU/avrD2Pyi65JsBMAZ3Uc4rAiY2DML22oZqkt8byGdkGCYr33he9kTX7zlE/Cr+CHIdsQauFrXtIhXOe2Q9kRxTElpLgWViMZYJQ7uq2I/GVqCcB4L02vSLMNJKIANoTnRLkgfpF9DjDiM1VGfUiwgKn+hVTkk/yuNK+XJNcphQTo0/2IH1q/U7Wjgzj5T945LcM6ED+er5gSaTso2pZymzxiDC5Ky0HQewqiMj+tvotqIaXlOy8Ub1dOwgtPWXXv3wwthVXrTBTilISvAjkfJi3Yn21Np9SS3/OtVABzHtfiY/5EeE0E+rhkODBVfR8kieHUHsdY7jupHWOlVkg6CuXGUsbOEmHYDxJpmJOCwKfFvDSaXhNy4XpUOpyXXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 03:39:25PM +0200, Pratyush Yadav wrote:
> 
> Just to confirm, the first kernel boots without memmap= right?

Yes.

> I think the main problem is that the radix tree pages can be anywhere in
> memory. So on the first kernel, they can land in an area that the second
> kernel's memmap= reserves. So kho_memory_init() might end up using
> memory that memmap= reserved. I'm not sure why exactly the next kernel
> doesn't produce any output, but IIRC memmap= memory is not mapped to the
> direct map, so accessing those pages likely causes a page fault.

That's correct, kho_memory_init() page faults. It happens before the
serial console is available, so there is no output.

