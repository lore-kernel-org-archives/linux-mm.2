Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28188D5E147
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8A96B0005; Tue, 16 Dec 2025 07:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896E46B0089; Tue, 16 Dec 2025 07:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AFB6B008A; Tue, 16 Dec 2025 07:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD296B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:44:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C969595C5
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:44:24 +0000 (UTC)
X-FDA: 84225302448.28.179831B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8D9620005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:44:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=De2yOmV8;
	spf=pass (imf03.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765889062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lTD5T6FLVPMFiI1zK6zOO1/qp2X5cLGG7vD5u13cD0=;
	b=d5nJnBHl5wByDVLRdchK9vqvQKlXs5wSEnsSXuE+8rjom33W9P6lcWckoJaUpnui+MQBMN
	aKDYCAhemnd70OiDh8Zj6UQxSaKYCBzko0DjdiPGRtdpiyqS2gUKFnZFsNFWHOpXxaYvWj
	l99HG7Me0qfuWHudpoHjUCl7zgpBU7M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=De2yOmV8;
	spf=pass (imf03.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765889062; a=rsa-sha256;
	cv=none;
	b=fP/Q540C6xsey1j9e4K+X0OZKewErzshtEdb+kbbUjuGzNVjvL9lLaWYQ1MK+bu1rGPo/u
	hJhUcW07SNb6NVLbnUHfIEIUO0y1f+UD0QLGpAw0xU/0roOkpXQ55VqtFQQ2kzTz1YY1wg
	HD+bfPrAlV17QT5Pvc1II+1e5TmWSdg=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so29375395e9.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765889060; x=1766493860; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/lTD5T6FLVPMFiI1zK6zOO1/qp2X5cLGG7vD5u13cD0=;
        b=De2yOmV8SmJqrFzGztOElhPrg33EpHekUNtewGJOFSIzO5Zu2oulijbP3vPgHtpLaK
         vjZvlTrkl/JcpDHuTmCSEbNrMFzf0EXRPqvrvASMEjQpjkve6MJ3qMQf+VUHuHagzdnk
         /3g2DHaJb3zI0BMZA8nZ9kgNzdtOLv4v57fZNuoaBgzQo5WehLEwF2l5enoh5w3MmNxy
         wkm1S5PSjUSLt57h6D/z9I5YRe8fc1iv3eK06AVj4I5LxBRbSZ4RCuBepqXwotAzhHS/
         z/dAVQ3YAIcJdiRUkRUQ0UlG0bmGtamJlVdZAuC3P9DulV2Pcq+Ce9/eJz9JIvNrNSFo
         5kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765889060; x=1766493860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/lTD5T6FLVPMFiI1zK6zOO1/qp2X5cLGG7vD5u13cD0=;
        b=aryPQLu7busaPETRAIWnvq0dutmjvI7/vWUoP+/eB72dfsm9Qd/EB2sxyPEfsDUdX+
         mNOEwcKkopqUWD4JfeP/v4iv2opdoF7mx3PeEyQ8ZngS9fdCfkI60KgHkEcf0wk43TTO
         9iD5951Dx8ye/ntrftKu3ZaqOSBUl+d+9uW+FXn6RUHxAV6epS5pFiUMNL5+T124L6uR
         TT9F8T0l2nhp+3+rvKKAz88kjfnZ7AZbaGsusrChK6tgTpsZaOLfMOIcEV5WX6EgyJ6p
         VmRwS4Fm8Zr1/9m4CqNuEq7m3GRY6I2X7SzaCcxKWx/l6i7sN52wbDGk0c7z06Uojy8/
         5W8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9M5F8CiPEavy+bD6s2gdAdZChaOeJ+reTr0NoSi0EQCPMtK//ekgSwuxJkyguL+iE6ZKQ4U5xVw==@kvack.org
X-Gm-Message-State: AOJu0Yx29TF4cRXVlikoXIgAEymkjy1YoxQJMqK/zmnMLNUEfaqbyEyd
	TAC3tkIFww6LJIKWJpvYx3wDaZv7osMEvEANEvHsVUIbX3lw0aQiiVnV0pxDE2mJznQ=
X-Gm-Gg: AY/fxX7YuFsg53Rcj1Ksza/MqG2HZSoyCELrFsC+BcMYELzCGZqTde/BdgWvZGnjXP0
	eJK/cEq/BD9sacbuWFb5trH2PZirxS5lTVcuuTfo7wVW4KjqoQ4HiaiC6LxGxoKmROLEvMIXzRF
	pTo0DEsziMBzq0CcpVk+kX5KW4kmq0EX6jz6eavqyetpxlCRu4tql3XQepWK3GMS1yahtV1OjDA
	jJcs7c6tkOM7UClwETgobffT/LxS4ZuDSk1mDHzb8Sz1P5jYcVRfAhK4oV9vVRtmcOPOVKUVm8J
	NQcApme4EyMnTun7wBQFJw5Bi55zVCsWSofb/nQ3+9opZIRFDcvROJw6OnzfHnIiS+BdXXkTRM4
	J7WXPun1ZJS3m7wCJ/7axgNt5gfmcoFaF+JsVFYTG8ojCSPLwo2OEUczcm4ib3FrcH2gfcCeAjy
	QU4HUrFd7tTel30A==
X-Google-Smtp-Source: AGHT+IFW5qDickl4JAEFRsGArKDI6FcAB611ceysvy3jNS62BLSz150yvQDh+EMhh7oPcWPJX+4yHw==
X-Received: by 2002:a05:600c:3acf:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-47a8f90f96bmr152908605e9.30.1765889060304;
        Tue, 16 Dec 2025 04:44:20 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd95e0161sm9700215e9.2.2025.12.16.04.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 04:44:19 -0800 (PST)
Date: Tue, 16 Dec 2025 13:44:17 +0100
From: Petr Mladek <pmladek@suse.com>
To: Joel Granados <joel.granados@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sysctl: Remove unused ctl_table forward declarations
Message-ID: <aUFUIfVvRcYN3_ID@pathway.suse.cz>
References: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8D9620005
X-Stat-Signature: 69dfd3wrgyubsoo3qbrxoompyybxi7jj
X-HE-Tag: 1765889061-566686
X-HE-Meta: U2FsdGVkX1/lCY0a5oYPjo44EnADh7Gf0ABvEgtpr5PdSq2llzlhdgnJ5GJtOrqJQyJ3X2NRbTLf0lluSbbkiRjXeSDIkxOWunMKCnthY7tfE+4s5pAoMueetwA/+Zx96fCxk4jj9eq74STqEBno516dX4QZL+wt0hT4arbcK1ByzexJ6groS2jV6Jmh3v1ppspil9eVz/ukctMgL+pnWcj3bs8qd1bToDVPBDV4us5GuhW/+O3KIzvkmMRTTA0pgjg2mHYR4maqZw2hub6EfUHnTByEGaLTvitMWcdiCdwOFbzWcSmJ9IWJkH+WIx61WLrWUqzzAcd8WFDx1SQ0bcCEKbK+489YKbfRid7nEr+YVwgv+39HzpaeztIq8nSQeNU5XJaujlB57juK0LVZ0+ftRQ4Iq96//wMrs1fzRjekYWOuf4WQaBFniQGZRmC6fPFK+91tILOMf5cE/eKlu4cqGeK6xgktbggUrPYBCIVpfy2RkzQdM12iCbwR83cuvhHS69wRVBa6EuVJWttPAQkNsbBiwelQ4qsz+ABZL88FSqoSK72kbd2NXe04NEji1EtXg2qVILHd/fkKMwvgis2Tr6Zw8RM7ql/4qCoUgIYxSFjvmdm/KyTTaim7+60TZPIzgiwSQbt78Nikiw3Gs1DvrDGWvGqY3gP/NPZbwyy+kcbLQx9YTBMmri8bMr4FlVrgeQcuqnJV1DOdsV1w2kERE8A+yND2unj372CWAmnXUr/s2QFvnWrcdP8azRWEiGFTKiSDEz8y7StTfhDd0RAvugzLoamJ7xN8RcuZF0ZBnDDFW3Wuw5GgBgiHUELLgsNol0h95qLpT1PH/LM9L9RvULG26XUefAJJhkAgdoWh1GnHh+zT7GXmpX9TAxfs6YJ3mPzkndyXTT3fJY1QBhr7Sz99gyg5UR5Szjq5Nx9ThROlIaF8Vz03owySvr3RmTs/IJXcQ5/l+RqBnQ7
 Wqg3R/37
 a2nCJLJanUpXxIGpla4itqs/Km+5QJ0lqzvz8YqYNmpkUIjqgg4R4TOJrGRSUijRM6Fose3moBsuI9JEJIMNZe1imyV4wYg/1IjFs+DKM3sBm9HRgmsAbnIc6RatViqtU+KOCdUv+2L1Ha/LfQ+yvS+1nEUVZ84E9UconcyVCJpi0/F0DG7DGlD5r1IoXvhlIuHY6n1FvDM0LhFODX73Ln5tAwjiFzOXsu8bCOa8HNzlZu63+Wz8jtZYR0pKgb90QNHTKr2W3jaDg5aPU1rhlkJUKD2d2EiWXltr3lV/J/FYO4clZjHgvcOz1hnKs+8Sfd+3gQMZk44vbW6LZNZO/tZ3Rzr8PAWDkIfV6YdjpysESnbkqxj0r5r5aWN+MNjrpTZy1kZhYdzKE64bIw70BFA60LfXn9kI59yVYnxWkJ+3lar/4JRfrjgdVOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 2025-12-15 16:25:19, Joel Granados wrote:
> Remove superfluous forward declarations of ctl_table from header files
> where they are no longer needed. These declarations were left behind
> after sysctl code refactoring and cleanup.
> 
> Signed-off-by: Joel Granados <joel.granados@kernel.org>

For the printk part:

Reviewed-by: Petr Mladek <pmladek@suse.com>

That said, I have found one more declaration in kernel/printk/internal.h.
It is there because of devkmsg_sysctl_set_loglvl() declaration.
But I think that a better solution would be:

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index dff97321741a..27169fd33231 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -4,9 +4,9 @@
  */
 #include <linux/console.h>
 #include <linux/types.h>
+#include <linux/sysctl.h>
 
 #if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
-struct ctl_table;
 void __init printk_sysctl_init(void);
 int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos);
diff --git a/kernel/printk/sysctl.c b/kernel/printk/sysctl.c
index bb8fecb3fb05..512f0c692d6a 100644
--- a/kernel/printk/sysctl.c
+++ b/kernel/printk/sysctl.c
@@ -3,7 +3,6 @@
  * sysctl.c: General linux system control interface
  */
 
-#include <linux/sysctl.h>
 #include <linux/printk.h>
 #include <linux/capability.h>
 #include <linux/ratelimit.h>

Feel free to add this into v2. Or we could do this in a separate patch.

Best Regards,
Petr

