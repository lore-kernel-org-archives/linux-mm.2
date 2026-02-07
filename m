Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE51EEE6B76
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31396B009D; Sat,  7 Feb 2026 03:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEB06B009E; Sat,  7 Feb 2026 03:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAE96B00A0; Sat,  7 Feb 2026 03:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE406B009D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:24:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF5DD139D35
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:24:33 +0000 (UTC)
X-FDA: 84416974026.26.9A6B449
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id E2A7720009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:24:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IgMf2iMN;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXBAuawE0kmuoOn3/rz3GLmRBEBuqtL3Zpb7OgqzWFQ=;
	b=LawFZ4kVmqxuOjiyH57xmBNRNNYI3VfSdQ55RmuK+owph5D6SwHo6+W2j3PJHmzuwC1hiJ
	7w3nMsI7mWCnPwCmkRKTpmfQ3sncqwQaN7YO5BPcywDhm4hrs7d+DcilomS26ZcaA0F0M6
	LkYIzd7PphmsfLWVuqt6EXM0RrPy/aI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IgMf2iMN;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770452672; a=rsa-sha256;
	cv=pass;
	b=AAxyomxfr+9kySooAIms8NepUmB25SUlf/nlUiirD2BoNAhWwFLGLOcZjV7yfKN4bnyp4e
	7wE4AT00GscX+BuZUCvP4NyVhyc0Oh8EigNqFe/cNObA58SgKUjZzNV2lmpFfVxXlGvPOQ
	tVoXyXPxrufOCgopIKN9zX6cJS4UCNA=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59e4993e00aso508014e87.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:24:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770452670; cv=none;
        d=google.com; s=arc-20240605;
        b=URixequ9t6yoTOZXbwwP+5t9UbF2ynfO8uEKtPpaN2s+Tliwgk2ZA6XAy6Atni3wcf
         qo5oYH0UsVqze76N15RalzQQTLB5woW0CB6XGLMwBslDHDMwJekVHKm7yFujgbet0Ic0
         baLlocjcidLAGxi4zrC33k7Gfs0/zcg10G17fPos7IBZaj2m5itKMJyescNWES4SlICD
         dNO3dl15mDQm7rodFB55Isk+azW1ml3wTz4XWL12uRXp6HXVDPGc166XpkRUEMHcR5IO
         GDtzenMIXOmHUqSaJAEGYYXHESoDkBpWxKUJ6tfugI72mCE/NajUyX+25vjfp+aBtvXJ
         WOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AXBAuawE0kmuoOn3/rz3GLmRBEBuqtL3Zpb7OgqzWFQ=;
        fh=HC9aXBHkUx53UOKc0mkbVh83sXTEAR1EmZ0PB0yVDeY=;
        b=LNHlNCXgJwN1cQfhbCZcM6aGIcRL7AHmRNniJ9KvSQejr28vCjZxrRlMHYEeCN2Uh4
         43yfD3hPWIhCboNUy2TH/J09I6gcA1SyQNBHD30tUK4oKP4GKoQ3D5MO47mmaN5nVWM+
         pB6KL+RjfZxoiZSJ38Lho31QeeXmR2MBpd5beOWYT8OpZHm6ayIVcWarEOqpV7M/vxCD
         Tmk3qoOEbaABKHPb/dRiOwmtY+MM32KLpfytancZggwPf81JjSm93Puq0ZTIagf1XVAT
         P/rT0h0vZBUWfptUzchKKDH6KDkWJ7ZMEl7tlhwQVVxttqAng8NBGPHuhQCF0HlUh6ZR
         T2IQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452670; x=1771057470; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AXBAuawE0kmuoOn3/rz3GLmRBEBuqtL3Zpb7OgqzWFQ=;
        b=IgMf2iMNmXII47cH32woaGB25jIyTN1AaFok/yAQNXwu6i/JvG3bt5XYzkjbX13S2O
         H6jFHJKfdbPj8vtrMqmD4JE9+piAw/AtvEH6yYk57QEWOvsMO3GTnlPEKr03bN07qDgW
         JM0RbBn/SPQ9xpH3bWxtc33AzKBUn6sjRqNta0aGpJ53wN9xRK+YIy/pa5Wzc7KV2g4+
         WTErwwcaDog3AIydjj5TLpHnIeRx9nTFwFCHp1VovCZ0MYpy+EJyX+wHqd3j6uUhc8rV
         eXMEBPh16vXUfkS61Beu6EYIQ/+PYSm2ErR7xf+dD7KKBOIIxQ3+MuKaEXWWctpOgkOx
         HHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452670; x=1771057470;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXBAuawE0kmuoOn3/rz3GLmRBEBuqtL3Zpb7OgqzWFQ=;
        b=ly1JRactErKue0d6n2zFS+OAvBVuNo0hY0NMg4gev4dR9KH3IbFmw2KFXlcwcBHGpZ
         rV9ABuBetNlwxCYnLIs0PcCng9LdcplixsearducxzClCCwWBl796reaFcWdUsEdEsB+
         3NnSIrajwQK76a7ljq8KbacgNBVCWtkaxCzjfsY2kT2tT5RyRscYjSFCbAH7ERYfdlVF
         J0J1aLvCkOdDZzSfboYbnIiOYKeaWQHYfXtbiPaWd0FVzrtZw6YbV1mqWqqYtujEDLl8
         5LKpl6exIY+rXsxBbK6nOEIsZIKB5JXwPh5t9vuNrX+s6iVG5gzhGNgmmmpvJ3jE4BUl
         WX8g==
X-Forwarded-Encrypted: i=1; AJvYcCU5TkbG8wzkiPS8t/FWlseiRmL4rEvhRRJiMo1sGCmTE3/x+ItGpWcrCF3pegilg09o+784TG3bLQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3cfpONWgt4KBEnPQJfZiDGIgeciDZL8ur1h3h0qF0oGy/Ewyg
	DVSIQoR1yUSaT3LuyO9dmAO/lY+lb6/AkVnMtQJMGl1Urf6SRsPItTmlBLT0M7QcwME5wvsqq1x
	cMklo4xXB/NxoRBSu6QijJ9AfLdTFemM=
X-Gm-Gg: AZuq6aLfqN2XtpMSoFURh7Ph5D1MPiSCHqai0W17WoeIK4eaAsE4ThckMsJi0BQGy6B
	mW5T5AKVKI2onCsPvrvNtqW3g3jQsw3zx/t18qsu1NtsctqrSPJwzytAGIrVZnYMR3rpYcjq+xi
	Tm6dbx759VbyvvRLF+Br8MfR1eG8fPwBlOCc03KnbveMFLG6MIPuoixg2V0IX/TYhV4A/loImdF
	Y0p+ilIeQk30f6kO8zPEgvcz431fxbi3DELaRVMSAlJM+7gmyNKgkninQ5vOzFUeSvHT2La
X-Received: by 2002:a05:6512:10ce:b0:59d:a4ed:1aee with SMTP id
 2adb3069b0e04-59e4515def9mr1487676e87.40.1770452669747; Sat, 07 Feb 2026
 00:24:29 -0800 (PST)
MIME-Version: 1.0
References: <20260207081144.588545-1-vernon2gm@gmail.com>
In-Reply-To: <20260207081144.588545-1-vernon2gm@gmail.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sat, 7 Feb 2026 16:24:18 +0800
X-Gm-Features: AZwV_Qim-sTWCRJO2BT4vfgoZwVgFG945mvcbL_l9cgmZXJQ3Qc7O4gzm3X_Vw0
Message-ID: <CACZaFFM_3J8S0YE1iix8VicnVsbzsVUvqzK2OM5GN2p2btpdtQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 0/5] Improve khugepaged scan logic
To: akpm@linux-foundation.org, david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E2A7720009
X-Rspamd-Server: rspam07
X-Stat-Signature: n4758pou4k6hg153mzcrq679f35ehryh
X-HE-Tag: 1770452671-585192
X-HE-Meta: U2FsdGVkX1+IBmLZoNVtmhjptV7fMrZjI1JKfmoTV2VEcYVz0dcSPWhondRruwEZme8G9YS/sq8UFv9WA+/+jySSgODipjJkMO6QhjdK7izFq7qiyaFbe829oT/Kl4yu/qjxgbfAHYo58RQH2pZ4UjTZToX4d+8mMBV50GXqf9totLmZRR3sW3PVH0ENLfuY/Hg02sr2Uz3hQTRZmc1jw86MgvV+yKur6tj0gTUl2WiSSLfSm1xjZRo9lVzDIpsJbqoq7EHafj3C5MGJcMSahHQ6BWvFCYRcI9T3cA7Ff0JfXmDkxAfifibE536Ba/bJIMbZ/Hu2sGw5qpGSXAYHC+DwibQUhyAQxH9/vU64jOGFgKym6YeYxyZzzuSPu4M2glXROIRMYFjyAZyUiEALuDynJKOKz9MQjm/j3Sj3Setk/Lb7MJ6dBC3GNFdHdMnF3D1OjRRQUiCPTgkJmCvigTDezr144NEWFPt10QZbYovEw4XfndWXQCyMVrTAx4gXTzWmpOopjQjs7qfch2uftt6N3lnB/mxJWlhetH4U/tYSg2S2Ln6o7fYg0InB90GSYSfoyDvcPZJ3HA/rll95CXtm9F15BDJN1igmMATWVEbxzfCiBkxC7KQVRiZmspkl+9ltAb2OnHDCno//4fVALzwh4NAxc1A3wyb9z297hTHRet6tgFyIDUJ7lUCxSrBkWT5ppoSIO2SVeVPjpvW8hNk5OhWX1OmV+uUiM/blc+WcvfYGc0KQOTb/1Bgpk+n6Nd+y5gqDVtmn6lO5BpsTyI+cv+eeWALJiKU0CAXHuAXq9g01Vt3qmxsuIu00llA4gR9iUNF7RwoNZVZDm+GpKVuAGLYvhiXo0q3tPH+26Z6SaHRC2O+XEq9l++eCAjeGS+sax2nVPLMxR6jPhGUIyAdI00loF+tgLwo4HdIFtz/aZy1vaNEUJaPtwq+1UMH2DmEWHFbNqN05fCQfwv5
 +HskfLBb
 QBdCJtctNsvW8MrR4r/KqTgSvB8RtMInfMqeuBhW6HnerLPP3z0anGYdy1t2tiMajRBwZnxZWiJ2bpGfx6pt+mc6bid/mcYmtMvVGZ8e2JD5ANnK+bzzPkYcVN/FSB5NmpKIiBwYsVPxJrkIkOJql/RjNfOsF3IknP3nxPBg+9PATLOvs7ANSK+DIvfrgl2ZewFX4GRpI7/xJv3Ps+GnhcBufOtr7mFUUCUBAQKKux88MjBj2sxtn0rWxc8dhFVKmVLzZM4UbRlZdX/98oVhk25F99jXU+yXNEwCJIiZHfyAIXQqZ0k4mkCscLKQa6Z2H6NOiDAxJf6W+Pwg8cc/UJh91wRGMfPla8ROBqOw95EX6JZGXsRzLIT144224v/W/HBkovlyoxks6enB2Oqpse0oBu9lUMGEo/dFzBB6Y4bllNZOTN+tiD4Ed18kkSXw+nM9X52bh07KCa1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000714, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, the network was interrupted while I was sending the patchset. I
am resending a patchset.

Currently https://lore.kernel.org/linux-mm/20260207081144.588545-1-vernon2gm@gmail.com/T/#t
is BAD.
New https://lore.kernel.org/linux-mm/20260207081613.588598-1-vernon2gm@gmail.com/
is GOOD.

