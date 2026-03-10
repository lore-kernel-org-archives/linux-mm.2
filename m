Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DB2FD4F1A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EAB6B0088; Tue, 10 Mar 2026 14:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D922B6B0089; Tue, 10 Mar 2026 14:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74366B008A; Tue, 10 Mar 2026 14:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2BB26B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:40:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4608C1A02DA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:40:53 +0000 (UTC)
X-FDA: 84531019986.26.8168733
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 67B7B20013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:40:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfuih5LQ;
	spf=pass (imf13.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773168051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjFZ9oZWWc3RZ4UdO5rq+AZbr7uPDX73K58gh1+yuH0=;
	b=16iPjgnkJT5bfCOpfg9DatcyPabHadRZr97CMVHN5stDbPPiHkSol+dRnoPvPWHnhe5m8c
	pxah+avYmx4Rysr6ZuaVtlXU42k4YTb/9u2Bj5ntzApxS9yIuVRfxcv34/51bPauYlNakn
	Br2bAnuK0KpxFWOj3vWqOikHflcRJnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773168051; a=rsa-sha256;
	cv=none;
	b=b5RuLiFDCcYx8P20DR/qNPB3sDJqb6/KgufGDJvNqjxlGXKwxk0o9LGTcEcGX96RtMo/KG
	ufhsusFobj6QiCgNhCM6FcNpGFqyc17RHTCEAh85ovW3aXphMBiHhwl2E3KBRkUYTm8RPt
	mlxc7qZ5eNLv6ys1fqivkXsJ87qEbUI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfuih5LQ;
	spf=pass (imf13.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c73bbdc01b7so772160a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773168050; x=1773772850; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjFZ9oZWWc3RZ4UdO5rq+AZbr7uPDX73K58gh1+yuH0=;
        b=nfuih5LQbG8w77hYTHorAg8RUEx8BHRMSRIi5J3dH35dWsBj9Ldx+LWx7ic709HZ4e
         ZbcPBhsymHpAI9XwGozr1ee9oG8oEOD5TUrGSZhZobtaytWzDo7jWulONwP+hKNgw5bs
         ABDZTjphCkayv/zUPE5KoqCSDfLLhJ0NA1Hx6OHcHzlO37yTqGCgxXANKBHVnI7STTU5
         f1zOnksPCDWrFMcli/fUx4p9Bwcu2JSHGLECPkIw/M66qVSTUfcyOF7qpLi1C5O672hI
         lbdWTHCoyljelGpJl+TUQ91vFoNP1lTs28CYujMCs9KacXU0wP9jBzIewqCVWtL6b7Oe
         Y1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168050; x=1773772850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bjFZ9oZWWc3RZ4UdO5rq+AZbr7uPDX73K58gh1+yuH0=;
        b=pzkcAoSZssTw3uhXXHh6PjXZORLm7WB5E2742J37Jwt/7yu+IeVkFaVRCmKKEo613C
         IRXTtfbShwidFblXcLDQ64+dDcO8zlGP6p8O37hneAEUk3wN9+8LblI81M8TVl4E/fMT
         Ucq0P9KSJresUGiFLhKHx79sKKOKlZdcKSnNuttvZe3QPiyQMLauX51UoHFhEYICEv0f
         iUnsMInluuS8urHotPRT4pEUWKKvexmES6ZJ/gVC0N34h8J0/SqYfyUoukF5qZipKV/m
         ntDtWzTlQXe8bxDm/D8hs/QEf+g3Jzu9kFHLheYnn0p2AWudhtnrZdNyDX+xbztdkUh1
         V9Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWwMk9Z3LX8sWAT+4iv+G+kNZnj7SG1AgQQKzXGWrds+lLX2IgXZXC7sHF/02NsUF4GrtnEemHzBw==@kvack.org
X-Gm-Message-State: AOJu0YxA2XBW9CVkOZccTl4KKDyJpR7JBfJy7/Kl5o6FsJFS30DvY3aS
	pONFY5641HPDLv0oAvJDn0ba206nJE6KAYXFGrmxEL3Pa1wcYSD9Ivue
X-Gm-Gg: ATEYQzx/jx752B0CAZi759tVrIy2uKgn+yD2CVTtgB6O9ozLFxK8uewWUCwsRPSJ5qU
	0LFS6nCrOfupslm7nRQwDxn0kaQO1Gx4DQgH1CeLr175zIFelJ4+vyUoi49y2r3tG2TQ4EjMvFZ
	ohysAQxEfLrGWob8xIdwzyJq3jEcpznOrkDVTmAFXNyKQaZ1uaiakCTzjsEiY3o3+R5n5523P4p
	oV07qZq5/8lpRF5Em4JGoXuzTeZWdEvQCwz8ymADV4zPiS80JqS1rJSGwrB/YP44zSTsKRK3SeW
	kl1ThFBZ7dcvf78zbhwYClGrsAZ3t+VYEXossQTgdwZ3kjYAzoLnuhbVY2J7h1kQ1dEwxFIV7Yy
	cjqDaDPuLOx4F3kD7myCgt6KjaQ7rkrJB7dwq8ZNpLiW5BHw23kxq4P+AmMp4qTY3cz1K2PHlZc
	uM46Cg5Muw82eL5OGLEb2+1PCGj8cOqYFGdxEdhDdXGzb0Dg==
X-Received: by 2002:a17:903:28c8:b0:2ae:5671:7071 with SMTP id d9443c01a7336-2ae8252cf0fmr96662285ad.43.1773168050081;
        Tue, 10 Mar 2026 11:40:50 -0700 (PDT)
Received: from google.com ([2402:7500:a44:85b:2953:97d3:b283:95c3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e58592sm220535625ad.14.2026.03.10.11.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 11:40:49 -0700 (PDT)
Date: Wed, 11 Mar 2026 02:40:36 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <abBlpGKO842B3yl9@google.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
X-Stat-Signature: 4om5jxj387n9uhmb8zd1nub6jbx8n178
X-Rspam-User: 
X-Rspamd-Queue-Id: 67B7B20013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773168051-41169
X-HE-Meta: U2FsdGVkX18E+PtQ35noytp58L0eSY9d5zaD4FmlE1J0AG37F3TyEaG2cG3FeRq6JbvFJ/WOwNwCz5rejef45+H3WsJCAYYtHPpSgpyeb7H/TY4lciTG2sJjBO1s7oCWBg/YsfBp//+CKVCYGUDs0+LdY1r61q95M3lcq/N+dU5VDq7G26bi+unovC3ylWiQcjKVhEvgIGBxjudhufx9Efg8nNTcbpneBDceShbCrmnnPblecpHcwkuFm3mCe0VzAilgMjzaJUt1SrYr+bH+57Ij6lgoNl4TsK5rB8UMUWdmjq0VpR1Xc1mX1lBPRhkuDSw1i0cerhWxTFXda9nWz7yAYu3Z1aryxgnOYYnptpNxyiH+XeNaZCgGQNtAmcZ8ZPjE9DlCIpbkwGFVksJ8bbvWIrKmglidcNierEuU1tPmUAPGutGt+WcWZEHDI9+SbFyR/rKAfsFEvv7ZFZBaVb8aR6XGTGiGziPeM6hWqS41aiBiz02daR/VLlO2FEj+nVGSNeX/8XZ6/VEmTgwH7xD6y1UXQ/QpwWO0E49sBEgmP4HHusSFEyz/VjfgWduMf4hpqkiZS/Y5yYfTRpVTD6Y2eIwUyp1UUNH6J+47dQjnGYKFzF9wryy+MvGqSO6C0vcccpoYJJeMA7kbHXzd4LZEy1PSWIPRoU3ymtHJsHJh4NdunPjsVEXO/U841F5ROlUPAiVWcMJFNNWAeuQG9Z/IHp9+wt3kUPytVipiz1td9DP+kooEhgguLgLWUOm5U9r8I6T/rwXEZjQL80K0jV3HPdOFsO7khclc+lQQQKfHv94S39X0+rUFsIMcmbsnIt+NT66xadkaYNPJRYtSczod/vtLPpBpWmK9tv5Xjuq1phN0xFxztmYPbaGmjDCEXfwfcM0WVmRDJcEF/N/Gbab74KlSrPYPkbjpUGOX6wA6EXJ3BGmWuAKWX/WcPvOKraYFCf/mT6i1Iq8gH3M
 NUPMpL0S
 bJef0ZVtwvBqnFDeyyQFxFRaSKC9UH8scmI0Hs+pqnjWiHWC90qF7ldZXuIjaZ0w/5WhS4vW0O/Vk4UC5mHWhtKYZ8C8Rhk6X6Cx5SftnisbeUt2wl9CbhuVXSKCI6B2IlYfAJfBhdfwldivOSUdkr8VWL4L6V7s8dAQxE+0ewp8gq17QVD70Fgz1VaRf5gAm+7GwtWTtu6MzouL1l/Bdu0Ug7PhtKP/6hu8HkT29/nP31ll2Rqtlosz1uLs/2bFhW2P4o2GCd+VtaRLkpHoQ1QPCtQHjTq/+Y6EIevDA94nyRjo0yaGsmzct1i52izS6aI1USAqRTujCkp6rXf4NLhGRv47Xfl8V6T4eRj9ZOuczzBUjZZu/LaXj3JQMlCX40mc9iPQ13MfZ9mmDog/AgF9DKvQRSbTervTY+uXqy3XOJ7ivD550UrjlrVB2xU2kyMPeBYK4RsOtSL12OyuOQNNcNbqnTVMyZ4arGd2WY8y+lDVaNYBnQLiPWMJf6pRb6qDuVxAKNZ7aHOUPrQPnDZRUdSiy3WspqyKqG7PLrR6WvNGxL9smi+OOpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Philipp,

On Tue, Mar 10, 2026 at 12:48:26PM +0100, Philipp Hahn wrote:
> While doing some static code analysis I stumbled over a common pattern,
> where IS_ERR() is combined with a NULL check. For that there is
> IS_ERR_OR_NULL().
> 
> I've written a Coccinelle patch to find and patch those instances.
> The patches follow grouped by subsystem.
> 
> Patches 55-58 may be dropped as they have a (minor?) semantic change:
> They use WARN_ON() or WARN_ON_ONCE(), but only in the IS_ERR() path, not
> for the NULL check. Iff it is okay to print the warning also for NULL,
> then the patches can be applied.
> 
> While generating the patch set `checkpatch` complained about mixing
> [un]likely() with IS_ERR_OR_NULL(), which already uses likely()
> internally. I found and fixed several locations, where that combination
> has been used.

Thanks for the patchset. However, I think we need a explanation for why
switching to IS_ERR_OR_NULL() is an improvement over the existing code.

IMHO, the necessity of IS_ERR_OR_NULL() often highlights a confusing or
flawed API design. It usually implies that the caller is unsure whether
a failure results in an error pointer or a NULL pointer. Rather than
doing a treewide conversion of this pattern, I believe it would be much
more meaningful to review these instances case-by-case and fix the
underlying APIs or caller logic instead.

Additionally, a treewide refactoring like this has the practical
drawback of creating unnecessary merge conflicts when backporting to
stable trees.

Regards,
Kuan-Wei

