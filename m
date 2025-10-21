Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B95CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BAE8E001C; Tue, 21 Oct 2025 05:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC708E0002; Tue, 21 Oct 2025 05:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29548E001C; Tue, 21 Oct 2025 05:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1DC8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:41:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F5A2119EF4
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:41:38 +0000 (UTC)
X-FDA: 84021629076.25.6940A55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8AA6C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:41:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9cK5QHD;
	spf=pass (imf10.hostedemail.com: domain of horms@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2M4QI2/OOLg7uUeHMOQoT0d9A80Sw7H3NedIfzkAEY=;
	b=pYmj2C6QdJI9uXX9NG5pb4wHZQ83lPLu+lTwq0HBci2R5I1KtJ6G/v5tubL7wT563519dm
	8/4VUyghWmLG9lT/JCClN3KIAnmy94/hhEFgjnm/5qnP3yhCU/uZpAP0rQsyLpzQkNRmyI
	FXR2vm7uGx4F4sWEGeHSsQLRj0WGDxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039697; a=rsa-sha256;
	cv=none;
	b=NMO2cIgwaaT++w8UiF1kVqFKkDS+Z6h4sn0SQG/SjkyQ9S24W7bMxkSaUhnRj+h22CKARQ
	hlNzICW3g/BwKNWXoqYRy8+vAsEG0K7f050oTDNRB+iUhPeAb1igkEUtuw2bMW8R+dPe/F
	vCx7IDv1DBYiZkPpNfQvFcPNJMthFGk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9cK5QHD;
	spf=pass (imf10.hostedemail.com: domain of horms@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC4F943C35;
	Tue, 21 Oct 2025 09:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8555C4CEF1;
	Tue, 21 Oct 2025 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039695;
	bh=8dOBD4BckFGpaCNrWmvtyD6EjxMvEuwHFVyiglw2y0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9cK5QHDvCtecgEuD/dvsmDKlyKmi7hpjXEiam+xTwlCa6C1FcV8neQJbWc89DVN4
	 kgv9vXizxt86ZPck/cYUq0o5vH+Fd41GrHenD+tScKWNh2+XF/T2bJ8cjRJO7wVeT/
	 k07BQdItFqsZB3iPL5WdzzLvpbYmb3bSo0svZAKi2oKc4ir6oh3Dwv1MiODvAjja0R
	 /zAqdXGGO0hxtutYJTcixCqYTSKsfUpYACdEg7FyuISQrLeoU8jAFsaxdicOfZMgi1
	 35WHLAtSLRcbsNr9fMBCIHC51HaywPQUJF8ObS+95M0nZ6Xy5KKXminhlzrlLQ+3Fn
	 IlPMwbFq47T6g==
Date: Tue, 21 Oct 2025 10:41:31 +0100
From: Simon Horman <horms@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	rppt@kernel.org, changyuanl@google.com, akpm@linux-foundation.org,
	bhe@redhat.com
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer
 printing
Message-ID: <aPdVSyLRKeRN3i6z@horms.kernel.org>
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
X-Rspamd-Server: rspam05
X-Stat-Signature: kx84naeafru4hhyysdmgu4eexowknbin
X-Rspam-User: 
X-Rspamd-Queue-Id: D8AA6C0006
X-HE-Tag: 1761039696-691279
X-HE-Meta: U2FsdGVkX1/Sm0irIQ5/ZKGDsoxLbhBf2ggJLl8rOl6a5pAiSwnGwx5s0N4jS3dj/ZZ4eQ/YZtieo2+8090AHn405A7Vjr2dpYt0CvqLJaKP421LH2beJ7+lleOKJpuWd31kshWpXeEPo+24RPBeYjWX8nxUSHB843htBMKUFge7DMsJsL20pQkiu+Er9DFqlucAARQ2J8AFfBHl5A2kRvJmb+NVgjCDfGfZl7Xhb3ooRBrZVlN3g1SWRvqfflg2g0tjjeSoC568D4ct1od8OHq4MLXrns5l/DCvQL3zFDRezNcTyT16dRTGMFWkcnRdxkoxqn4Sm/G58e8FuOWipfH1JvD/sDEDd44mmGOS3eJH+eLykqv6ET6NWdtV6dnGQtdntImU5yNqmfFO7U5Va385Eaoozq2s5Fv1LDFd5flmYIsFgK6IUIKYAegEBXQIWLfupK257CaZKMu71+2rgQpfdqfV0lrxwv8u4e6toKzximztggxySnUSYiTiNsjecRQZF49XwGZgIZPOu84Zp8OH5pN/BMVAYGCJ35rNMYAaWSoLi2xZ0i6HUbJKo5euSywWaMYyfK3uRaO4WLY2CqoCgKEqDNh/Qy+MOoO/8o5SVmJ2qB4qN64jxySTSnz/Gjky0g3XYWYYZc9ecVejrco0uwapMwr3FtKf7m8DfHiyFiixlKakpoxWD5e+Y/AXPX9Bdb4oR6sF6JFsEU2nXkLvxwkhNUYXpurZf4ZROupHdYZGizigM1MrvHQce9KkREaBq8hf4NgxqpCto7jVMclWKMNye44CtuTv1sHX1eHXG72AKiuuQsGktMCtnIlh5/ohc3MrMfyL1eVSpuFBxRIXt543d2cuFPxyKlj24i0+mjIO5QbytdFXEUvmA+0KDv9aioghDj88OT8xIh7b+UvlV273FjKEMaqRQNYMX826YkYeqGCjvbT3MkU0SzTW2SXut+bEbbhQEJzhn/b
 szOMg6QI
 R//6xLOFO+FxWl7ZLwQC2J7KImx5sHscEiNkAc1yHEwOQ+LREyY9SN/X/XEtEX3q36fiUG9ZZNVh2MXYCelPShtYzumagLQL3OvAUy/4umvWI+8t0VYOq7qDN1KKEFdQx3WDviiWNbTglap4jhw7J+SETTJWVcNMhlflabUM79DTiU4KK82MUqby4vFOY3utC25VLAi3Pgxrsj0M57VrMt3Pv1cxJnb+Q3qhkQshitFH/y5aX3tIVD6yAs73WXMbnmeO7nxBYDOKjDDBnzwFj65PBag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
> 
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Thanks,

This looks good to me, even though I note that this file
has moved in linux-next.

Reviewed-by: Simon Horman <horms@kernel.org>

