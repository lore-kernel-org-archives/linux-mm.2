Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7804DEB363C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806CC6B0137; Mon,  2 Mar 2026 17:43:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794C96B0138; Mon,  2 Mar 2026 17:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6933E6B0139; Mon,  2 Mar 2026 17:43:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55EB76B0137
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:43:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D795558766
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:43:44 +0000 (UTC)
X-FDA: 84502601568.09.5659265
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1DDEC0012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:43:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J4L8dyiy;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772491423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jq1qCTUFeZcgc54IVQX6IaZ2ENB7YbwyZClbPsI9hHg=;
	b=zRCQtFfI4iAI4kfn7yJ9M4hA2eLSwz5rLBcv1GUvKqxnqEUp+GDuRsmeEnRGTrATZkPL8h
	wSlpgkz6BgvQC5n3NVD/iDXS0Rbr2nB7q43pd4DOwQXTAdOdELGlSIH+NVh6IWuEFQudfd
	EO3bJG7R2+egaMfRIHeenIQ24zMsdR8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J4L8dyiy;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772491423; a=rsa-sha256;
	cv=none;
	b=WjI5rh7ynxoMrsufOYpZqBMXKb7b+M+FxS4b/H4kuhPRa4VO5jMPkWWxhQGqPa9vWt53D+
	1ek8VMF4HPLAUOC+XDJ2j5keR/9Za3jKgQYyUirNUHZSss8NXH+Bf6mY8rNqvQD+U9QRH0
	/sDj1rV6lxuWjjHvzH+myLoBoq0Sjzk=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-127380532eeso1973380c88.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 14:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772491422; x=1773096222; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jq1qCTUFeZcgc54IVQX6IaZ2ENB7YbwyZClbPsI9hHg=;
        b=J4L8dyiyuALz+zJJxu5Fod/itWV5nRqJIBCN7qxH1ESLbt9+EDF9rRcHghqfp51Gc9
         1Zpjbev5EDuNPpcSY4s/RwdVTKmto0HG5OavGRzBarob06lWUIb5D1xalhpKBtZOwJdM
         4cCWtETajm0Hhl2kLV9Rz5ltglu1UV3xVocQ8leNS3CbtlawUpPwA7JqjYCdC2H1pAsk
         EjkLs41l4SCT22vz2HBkvOVOvQcweBeVUFXeQlLuh7pJZazCfrHEVQCX3aE26e/7girF
         Uz4ar3thrfDz28G+D+Qdh/YEwDkFx9RNZUM3Msfv6UQJ6FrstVUQGkLLvVPNc9/Daduo
         29ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772491422; x=1773096222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jq1qCTUFeZcgc54IVQX6IaZ2ENB7YbwyZClbPsI9hHg=;
        b=uC0BdGeF1ZvdKplmE82HnY2xAKheP61ZYNSXYd6V9VkbFVnfTnTUfkEZK5ZxmKUN2S
         KkGJwmYXqovqOSQTe8olx61AhpAmH15Tzcwo6i/icoDJRMH/bqysddHICDcwmlW+tQau
         Em8nkewPBx4vhxng/oH0GIRvZbzwrnIv16sR5nEGmx30cIx5I6WpzsZZk88dsqW6jRL/
         9InkiEfJch3ihOdlIQZPGf2jEAF8MSqug2wPdNZFcOP4DvuaEX17dqBwNVFcZe2Y0ngH
         n7HFnn0yAMZMQHaOVCmE8wQznYS8czq3MfBd2L6MzNF5EnE3HLiUjg39rckUMAf6bTbL
         rkJw==
X-Forwarded-Encrypted: i=1; AJvYcCUev2bhNGnrxC6rGJz2I7y2jAuJd1pNDLp1g4Uzu/BS2ZOv7P6vIuRIUqHW3vVbJLPH1by7UAiqyQ==@kvack.org
X-Gm-Message-State: AOJu0Yyrvel8e8L1SxlV3SQxIKfyR54kd6R7vxnB9PleSduWdkSXVpou
	O0dFYtXELwUaYlnbVShocSXIGEONyOV4RiL0MmNe2ZOSH6IWMY/Y78ti
X-Gm-Gg: ATEYQzwgdNtLHsJofP6aSHpKJIgH8QjmT4V+8Smp041sSrUDE+19wCrPa1yEq+0xBfg
	XL+Aww5s9UdVLKEwyQzwPfitoGCkUc1HYSatCft6/PO0e6cpLEAgVX3jzioKUQydKx90cRFItlo
	l2maqc9oo4ByM/Cu/qBnHsduImKatj8ygfBv9dhUWTVxAhtTOaKsL1vEKrDLdc43Xkpmbde3uHh
	gdMAtAhSoD4qr77mkLNCagqIVhT22bD6MfQW/EdxAga4CMjGaIiPNE+mcacV+mAUUqEyiwWqnUo
	kJwj/ykTIp7AMCpnCdXx0Ij0/pWxh3soN9ZPwgbxebCmidJ4NqYAXId6MuRMyqxu4dgOVXstGMO
	T3twOwGb7mEs63IhydWgwjBiGHUJGoLYV3N3KPbpYeTew7T96SDONk1b6dLe1zct4C1bGOiJuUb
	yxg9znJK/nxZsIFJQfsvwhjaAJlVpf6w8pxThoexGwUQOZuvdRR9DhrYFMUtakh+zrucaVfxDZJ
	YbQUvrYjxqUHJk=
X-Received: by 2002:a05:7022:6183:b0:119:e56b:c73d with SMTP id a92af1059eb24-1278fc2cb33mr6521069c88.2.1772491421574;
        Mon, 02 Mar 2026 14:43:41 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12789a43a18sm19226688c88.13.2026.03.02.14.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 14:43:41 -0800 (PST)
Date: Mon, 2 Mar 2026 14:43:37 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Message-ID: <aaYSmajuukDL869D@fedora>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora>
 <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
 <aaI6Vq-uyJ6F4P7u@fedora>
 <bf7d3f8b-8cd0-420b-b418-8b45bcfbcfcc@intel.com>
 <aaXyqZpenNthBTq4@fedora>
 <c85f864e-7784-4ba4-9fae-e957b6305d92@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85f864e-7784-4ba4-9fae-e957b6305d92@intel.com>
X-Rspamd-Queue-Id: F1DDEC0012
X-Rspamd-Server: rspam07
X-Stat-Signature: jj3ztwkdxgenfzjpodc4ecp46cr5h1tw
X-Rspam-User: 
X-HE-Tag: 1772491422-377
X-HE-Meta: U2FsdGVkX18DUSFBuKScOYSCeuKwNg1lfGOiP6ZBtPBXMnHdnmsJogrgpfG/vAaT/XCd2VpKuci1XTToYr16oxInSwMlgsmq8Y0gJYzdXMbCZrbHZrX2fHl6zIQLa9n81izRlOVngr59dgGEzJ1GoXC+va2UYi5wkFzsAmsYaNYkdDu+ue3ZuNKrEyG5BLGmwwMHmefcFZ+sWfHBdAsQ9KHuR6VEXD78wBWvJ1YFogJy90ARnJtK4t5uCsK4pcG1osigHEndV5710tWXrl6X6EXHjZi3KQxPw/XimkFqi6HwOOYwzRiUPIu2pPEgFIoToQjAYtXzqhGjyFnsZx9i4WaeVydEQ0pewk+pc/OUZPy23Oi/UHqN0oJ8tBZJlZsopbtSOLkTZrAYT4D6bmj4JdYOyyj+M0DOVMABK10olsMCNYC3ipqTEhqvqLARQpSH45uqCUYidWOjjw0CtyPD7rvm8aeVpf7eVjRlaLTKSY2CfzDmqNpR7i1byGvKQhQJEs53PjUEcLdrXlsvjTb/DpT58otpeTtejRjllKQ/XYoBdrupWxkB39kVpKkb+KStUsmeRhcuoaMRU5S7ODQq5EwZlqo98gFmqH13I9XUqnQ1IHF6bKPe0Cidw6XhMJ4LcJg+L0oQ58pR2xStC7ocr7HHa9+HwOetgpfJzwuUsbf49TMwQy8MD+uRrMycn2X2Fg1ebtowrsFCbeigsZ/k21RaBsYdE9RiFpgpmEzLeQ3iswAJgdLGQZJVqSmwn8nr6q8OeAhoTqCzN5SZy2FPHCb5yCnFIBstZZ0oizSKIsdWziqYOWk4J4CfJCTYc2ClEjlHdEFcV2o/yA8y3hzNnkl4b+lPuQRun0n8+UNXKXZYaV6xKIBgGixWuRCK7pVxhQa69nm6h+JhWU9SDRKt1RgSv5/Ro6bxAOsiTTyq5uWETy4VPJ6LhtfdUnxqWZCEZX5mljJlx2GphKF7Gq+
 /Cogo74q
 jFo5vlcwSxFWBV/PCbLcdI1aAqNmzqlaEI3qeAMCTWCjkqF+CQ1anjeqQ4V1rW2ZR/Dn/AI2g1vI2l6GIrMmes0iiI1BZxmrjnCjRpDox2OA0Cu1Ygj/pL/DCpVxOcFQ+dL0SgTSs4a68/yynJxuiv9rlZESLq113PvN4e+yI5RgdDrho7SyZV+aKecimQpsksHrzvITvh4ITDtIJyYz0JZkqEpbGogNeou63GnT0/m/3+NA9+BG9kGeSmmAlTu+pD4tBHyH4hzsM0B9k+/W40XKAZNGuNWWbADEZDGUEef1VV0j9PgN44/DEYUMXdyOzB75Rr3Xz3K/YXspnWdSmrHzH9jTgFVAa2s1bGSNd0av0FSMB7bIgIOuA8KXWGJ40ra+VHNDyKfselk14w//dUa5UAeA090YDBvMJYMY4adTrbvBWdM8FhI9PJh1letMC1a1wMKHRsI1tLczNe3Cl5rxMAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 12:55:10PM -0800, Dave Hansen wrote:
> On 3/2/26 12:27, Vishal Moola (Oracle) wrote:
> >> I was actually kinda hoping you'd be able to actively go out and find
> >> some reviewers other than the maintainers.
> > I'd appreciate if you could give me more guidance on this. Who am I
> > supposed to go, if not the people from ./get_maintainers? I don't know
> > the x86 folks, I interact more with mm.
> 
> Hi Vishal,
> 
> I personally look at 'git blame' or 'git log' manually and see who's
> been mucking around in the file recently. get_maintainers.pl does _some_
> of that, but I think it mostly looks at others who modified the sames
> lines you did. That can be a bit too restrictive.
> 
> It also couldn't hurt to take a quick look at lore for who's been
> patching the files that you are, or commenting in threads.
> 
> The more of that which you can manage to do this now is less of it that
> I have to do later. Any effort in the area would be much appreciated!

Thanks! I'll look around and cc them on future versions.

> Oh, and if you have a friendly LLM, it doesn't hurt to dump your patches
> in there and ask it. Couldn't hurt.

