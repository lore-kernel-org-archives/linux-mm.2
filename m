Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC56AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 13:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977756B008A; Sun, 12 Jul 2026 09:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9010E6B008C; Sun, 12 Jul 2026 09:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8CB6B0092; Sun, 12 Jul 2026 09:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA6B6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:19:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDBD54019C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:19:26 +0000 (UTC)
X-FDA: 84980181132.12.A57594B
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1D3920005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:19:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UWrz2uy3;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783862365;
	b=JXSQadVJRcgyLylbk8ZBIelHIHYSDXmK8VRPeMakMe9Ib3w4/1aHg14W1jVcJberP5cIpJ
	hLHQZvNawIZbJe6+mKltIBBpq/vqUZD1vwHPnCsD6BKuI0ZfQ4v1FzycWLE++JpI7JqssI
	4++aiY5kvIWIEwmABOAS6oQNeshhAOM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UWrz2uy3;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783862365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39bk0iOpnnnuS6FEq1W2d71iiM95MbzJdYJU5SoGT3c=;
	b=DXDpmFdmWCegnsE//D9P3hIDWsbQn40PtyuGBTxytxF0D2qSXd4B72ErNG00qDQslNgSYu
	/qQrH3eevMsdbPhi+SsxGI8mNYKjdhwMTI8LbvlFeJOBZjhAPeG0eQxy0rHKw5/mfDn/nO
	hPABnbHsfj9PiHmIdSq0hU2xI35J6pQ=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e4fd65b2bso121330085a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783862364; x=1784467164; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=39bk0iOpnnnuS6FEq1W2d71iiM95MbzJdYJU5SoGT3c=;
        b=UWrz2uy3Jsp/6e8j3X6ehHk1Rbpen/IygGqvykv44yEQV0tRSvJOcdH2hFrEmUNvLE
         6SoKvTr+0eoxVHXT/b2g6UtHpknl5VCWMXScaXabOOj6ynx51gONvqQPKo8qnHWpMd/5
         KAGBnvakPCUR57rUmB9s1RKGGgXmD0ViqiolviZn2H0MnVzImHue+2G8O1y7uvx3JgtG
         brQMxKdh+5z5q17a6UiK8mh3ndkhg8isdth2mIh29sPgF0jSaRaBfgUlmSZpDkYQMHnj
         wyOpcspVKUkb8ZA7hfeg4mVM119Pf14sOuxvGY2vEf6VX4AxcWg0sDOiQUoKFKSROZER
         fnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783862364; x=1784467164;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=39bk0iOpnnnuS6FEq1W2d71iiM95MbzJdYJU5SoGT3c=;
        b=I0F0qSmCgoRhKbMO0A+hanxYYKuylG7kyPlt348dyIDKbv/cbTUjUCW6xFNuvcGMXy
         3sOpbUmmL/gP2wWw49lFKA/KWoedaJapT3IfFGrG2bkHYefTJj5jspFRrth06sv3vqvx
         zc9WbhVKT78vM3mIbdQMG2B/6aCohWObqj4XveYOelNnpjoDYmQsLbkMts36aMtXuQT4
         HSi49GGdfpsxgC7WRS/D9NpryXaK1NNvLK5xY3TRjvKKA00NDeMT4Ql7u99nzlfBSN0T
         UsZcjSzaP+DW+WeGGHKBC79wDqTn0zEb53WEehEx/VenmYGKq872FJo8By3ymFVUidac
         VOwg==
X-Gm-Message-State: AOJu0YwfBwx5adovnVgf5CqwMEaRdPai9c9na6xurqYs6qOOsuTwKBaZ
	uxgKAlPQu18mvpCbIsQL2Dw9wm1JQFlLUd9tySdOiLSgtTxRcwXekLWlza6JvxU1mNs=
X-Gm-Gg: AfdE7clK0bmL6S0bTPTj9AEkPXTYuMYJhpm66PCd0mivOBU2WFxBn6dUR2qhZnPtvdo
	3OHz8jrZYSVekeVNYKHvh0KZPk0mvIdMW7imQzZ3k2nwqzxkfASzX/5jFvJUQeZhW8nWicN8yBJ
	f7C15zDfJLnQpxVkjFMDjZW5PTaSTTxi3JUGFDkIDYXmvsLIiUBEwT96IpTf9m6QG6pdLposUpw
	1Xr5uFia2pV2M2kwaESNoU7Sgmf2ftStwUpnSX+Wed/hqQLKgocAQ0GxdyU63WDNbZtjKgqIhWY
	w+CPXbp3riir8Ak07wW7LCvBf4Zb32qUP68Ydys4rs5Jz4fAs/sfK0s3Z3wAyegw26Th4A0KWoo
	hLvrtvCmjUwMLEynaWGkVf45BTnjvGsMosBQRsAbWOdWuohT6oiXAiYGoSin0v+bk9LZsLW+o/2
	H8UKI2I14/WDxx8W400VKZRElg+ja42wdD4EKTF4Oxk+ex78juZDeHhSz3hbC7B6Brnq4y
X-Received: by 2002:a05:620a:28cb:b0:92e:94a7:16e8 with SMTP id af79cd13be357-92ef2b354f5mr605721685a.15.1783862364130;
        Sun, 12 Jul 2026 06:19:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b4b38dsm900591885a.10.2026.07.12.06.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:19:23 -0700 (PDT)
Date: Sun, 12 Jul 2026 09:19:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alOUVvJCSQDO6yNn@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
 <6a51920acece6_35cf3310061@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1q15GSERqnHPArbK"
Content-Disposition: inline
In-Reply-To: <6a51920acece6_35cf3310061@djbw-dev.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1D3920005
X-Stat-Signature: w3iadu8ueoc9xjtc7mjmyfxzt9feusq3
X-HE-Tag: 1783862364-12933
X-HE-Meta: U2FsdGVkX18kM8V/T5tVaoZnDdZonaN/r3k2Zfk+nDjpO+YeDtsujK9QiUJq+7HGqy2lziHppq9QxdZf3brpStULJJcvjc9W/irnqDj63n3J6yvTjmw9cMFF76oBKgt8nYKGGsPM5BB5/xTpz3c0mDEP+vFkICQsbltyGLyTdzVBy2a+F3eBkyKBt6uGKHMQDwoN/5yLYPxZEcBxjcb2CVn3Ds448wpqy3YWwMfB52/ubD5QfDbWHMpx3i32JsuB8p/PPtdBF7DKLsAYODu2dh/Vb2X5BoZ7Tr8N4f+pphW6b801iheukrZ27tu8Lokfi1+J1dL5v9D0DObDpPUPxn0Jd7B552StBr3Oa9/4UUiDXdJF1j4YWj4kujzU9ujfjhlyy+COA6IhdR2sDi615PWDA0Wh4frz1Ro+sxgiipSOMtiwF91zJ35r9Ns39Tm4xprqXQAdCJyt/dla6trEMBMFPGwWqS5lQs5zEq6QdBvkaKI3Fooz4tgCz1vB2o8Q01/+7+b/R8fROEHjlVO/TAGCbo4mJoqInrHQt//KmMfcQHXFsV9rTLZ51fw2x4ZfrxNK2+ea3PhRxFB1WlJfHoLd8y+pEXXmQ5kGIgmUB8lHBBbAzzunLlmNoy4Tmx/R48J4V3XLddIKU6UmWqUsF7rECYOh1omD37G19SY1EeT2XSBmHCVv7OBlAoBrUA4iLcziCbVWnXiv9wJI7IvMtmASXpDMUfICQaiq9iPDl5NzvCixu/gAsXtmcqfkf9INnLWROR42DB1gnvuz7nfSrMrvB7cieTllZ2fqFwgc+aHrbLCcyPajNtImNdISOLRXzOGDxnqlckZpbk6qBX0TmebYY+hGE7EVunYxxSuTYmW+Pi2o8gcfkoYYIEQTBbBQb3RichW2/OJ/01lfp/OyKm7qfu/bCy4Wzmoazt35PHXveNtosat+KKeBDxmri+COGyZrfksQQraYlf7HkxZ
 6B84ng3z
 7YfBIGpFrURqzN52HN777gstaZpfE7e3Oub/VyYZ1qjgfSn8wP92wkzjqGZKN/rz34ncWuHrOqsb+rn5iqs1m3RbkGBLLLCLiDBeP0A/t8Zo572YfwcC3bxpjUZ9bmi1kmLBCZyV37eATFtBrsdCS9gFmDtNFSwhy56vhfvsMCnC9waFqUvmVkbHD4You2CkXCYRES4fRp7v0HZXkcobQy7SqRDupiNxgo6BGWag5AQSN+ECC6hU9KLe3nPCqNMGrfbcyQ6YMN5kKmNycphpFi1VFcj4ZOSG6n4zE4ZMtWj3wi/X2hUauEqfoLivw91HuQ5/wvfGuHaIBYfhlXtlauYpAd7EmsDsgJTfGZluXIjrXKAn776x+a2ueOrVxE1tRMIFAG1ZEQWAIJ3ouX5DL4j+P/XjJwJqoXyv9Ps/Cv0mfwJOVL6Pc7yWPxf2eHGBbE/3XVWk5KZicD7Ixd2OkYPOkKTGyA7+8kTvE/5kG4IIXdSo8chuP6ZNSqFumuwPh/r5/qYkY1HDrMEYjFKexYlntDvsCyBmdc9xUQJZmDZXsQQMlqWilcOGyyi1BawH9m/uwkk+sMC1cmEF7BjtgzVlmKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--1q15GSERqnHPArbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 10, 2026 at 05:44:58PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > > 
> > > This was more a matter of having the DEFAULT set consistently across
> > > the dax driver variant probe() functions to make the behavior explicit.
> > > I didn't want an un-set value bug to creep in here somehow.
> > > 
> > > Happy to drop them if you think that's unneeded.
> > > 
> > 
> > Ah
> > 
> > Not setting the value in each of those places is equivalent to setting
> > MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> > 
> > So unless you have strong feelings i will keep them as-is.
> 
> Right, the mild feelings are only coming from the changelog mismatch
> which says "Oh no, device-dax drivers can not specify their online type
> besides the default" and all this series does is keep the status quo.
> 
> That can be had by just having unconditional:
> 
>      online_type = mhp_get_default_online_type();
> 
> ...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
> first user arrives. If you are respinning the series and that patch
> drops, yay. If not, oh well.

if you prefer, i can add the CXL build option to this series instead of
the follow up (attached).  The code is fully contained in DAX anyway,
and I have it sitting off in another branch anyway.

I suppose with this, we can terminate the entire series and the first
user that grows an opinion can add the following:

cxl/cxl.h:
    struct cxl_dax_region *cxlr_dax {
    +   int online_type
    };

dax/cxl.c:
   data.online_type = (cxlr_dax.online_type == DAX_ONLINE_DEFAULT) ?
                      cxl_dax_online_type() : cxlr_dax.online_type;

~Gregory

--1q15GSERqnHPArbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-dax-cxl-add-build-time-CXL-RAM-region-auto-online-po.patch

From b2cb5c4f5f03dd698df97ae3db2c0207db4acd83 Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Thu, 9 Jul 2026 19:31:28 -0700
Subject: [PATCH] dax/cxl: add build-time CXL RAM region auto-online policy

CXL devices using kmem follow the single global auto-online policy.

On systems with multiple drivers using memory hotplug, this makes
management more complex - a single special kmem device forces all
kmem devices to be managed manually in userland.

Add a build-time option to select CXL device online policy.

  - System default   -> DAX_ONLINE_DEFAULT (default)
  - Online           -> MMOP_ONLINE
  - Online (movable) -> MMOP_ONLINE_MOVABLE
  - Online (kernel)  -> MMOP_ONLINE_KERNEL
  - Unplugged        -> DAX_KMEM_UNPLUGGED

Default to system default to retain userland backward compatibility.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/Kconfig | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/dax/cxl.c   | 15 ++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 80aeb0d556bd7..52450225dbb11 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -212,6 +212,47 @@ config CXL_REGION
 
 	  If unsure say 'y'
 
+choice
+	prompt "CXL Memory Hotplug Policy"
+	depends on CXL_REGION
+	default CXL_MEMHP_POLICY_SYSTEM_DEFAULT
+	help
+	  Select the online policy the CXL driver requests when a region is
+	  hotplugged as System RAM.
+
+	  If unsure, select "System default".
+
+config CXL_MEMHP_POLICY_SYSTEM_DEFAULT
+	bool "System default"
+	help
+	  Follow the system-wide memory hotplug policy.
+
+config CXL_MEMHP_POLICY_ONLINE
+	bool "Online"
+	help
+	  Automatically online memory and let the kernel choose the zone.
+
+config CXL_MEMHP_POLICY_ONLINE_MOVABLE
+	bool "Online (movable)"
+	help
+	  Automatically online the memory into ZONE_MOVABLE. Choose this for
+	  memory that may need to be hotremoved later, or if you do not want
+	  unmovable, kernel allocations to land on this memory.
+
+config CXL_MEMHP_POLICY_ONLINE_KERNEL
+	bool "Online (kernel)"
+	help
+	  Automatically online the memory into ZONE_NORMAL. The kernel may
+	  place unmovable allocations on this memory.
+
+config CXL_MEMHP_POLICY_UNPLUGGED
+	bool "Unplugged"
+	help
+	  Create the dax/kmem device but add no memory at bind time.
+	  Choose this if a userland orchestrator will manage the device.
+
+endchoice
+
 config CXL_REGION_INVALIDATION_TEST
 	bool "CXL: Region Cache Management Bypass (TEST)"
 	depends on CXL_REGION
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 1a7ec62122134..15f70d578c22b 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -6,6 +6,19 @@
 #include "../cxl/cxl.h"
 #include "bus.h"
 
+static int cxl_dax_online_type(void)
+{
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_UNPLUGGED))
+		return DAX_KMEM_UNPLUGGED;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE))
+		return MMOP_ONLINE;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE_MOVABLE))
+		return MMOP_ONLINE_MOVABLE;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE_KERNEL))
+		return MMOP_ONLINE_KERNEL;
+	return DAX_ONLINE_DEFAULT;
+}
+
 static int cxl_dax_region_probe(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -27,7 +40,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
-		.online_type = DAX_ONLINE_DEFAULT,
+		.online_type = cxl_dax_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.53.0-Meta


--1q15GSERqnHPArbK--

