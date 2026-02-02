Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B58E7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14C96B00C8; Mon,  2 Feb 2026 13:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6786B00CB; Mon,  2 Feb 2026 13:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9086B00CD; Mon,  2 Feb 2026 13:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADD896B00C8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:23:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5182C56E57
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:23:42 +0000 (UTC)
X-FDA: 84400339884.22.6E07D8E
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 855C940007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:23:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X8mvE6pX;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770056620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqsmEA1l4K6M349TDpqaFt5arK8yfZiMH/3re7GUwy0=;
	b=1RHnXLzHR6o65OpT3FSCym4WmxVcx+P7bmRo3AXLHDDEHNPW7HezhmgZd+F7cAm3RnvI0N
	iih2zKcHowyervx4EUfNANWRhGCa9vusRsXU1IIcGlEDfOoas9cs3ZipbJH675CTGUIdmB
	+TMpbVyq9cscwyP9nqgCo5V15j3INqs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X8mvE6pX;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770056620; a=rsa-sha256;
	cv=none;
	b=cCuEovpQ8qrkAzYze6M/hTIft/veWbcrYq/HRSubOY1uWh29LpeLRyo6j78+xvkdL5J0mi
	Opzw+pqfWRLnKiP5CWMAkEP2voFvAok++0R+aIvUS8OPQ5Z6YrFrNHd2/nXKmbSInqxFI9
	rjtoCQPqEXe+TtBQcAN8yoe/yC0xkwE=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89476eaaf16so47273806d6.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 10:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770056619; x=1770661419; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MqsmEA1l4K6M349TDpqaFt5arK8yfZiMH/3re7GUwy0=;
        b=X8mvE6pX5UgjBJw7n8t1MtPi+ztKYUnA5Zwyx2/YrKY5j9CQ/III8BpCrYydHQQcl7
         S4jd0vCfYpGnAYC1nw+zd5Ww/B7VprjFC8gJof9PqpTZK6kBwbeok+mtwWgZwsycvr1L
         YwpjaALSVkdWkiMMwoR04kdHnMT2wSbv+Jr7OZnb4siFh6msSflAjNwXjQ3k4hlq1b45
         6+yihh/CLdJMdAYnpl7SQzmEnzgtYnbjryoxdSPuxFFFKg/maUjDuevt2be0HE4D+xup
         mKBnQHcDbO5D8s6QS9GVm7k4I/idUmRX8mICu6l6aL2+WuvY1c15MbRUDpz5IdqkDsOM
         vu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770056619; x=1770661419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqsmEA1l4K6M349TDpqaFt5arK8yfZiMH/3re7GUwy0=;
        b=d/dRqoC+MWOeuuflQJ8KbxnU+En7O8DkgmzNJX45Csx6QrjKXm9mjyf2hQjS9NBFCf
         KxDfGYUDjrI2Rha0gmO1mQSgbNp7i7HdsuIDbCBmDNCgJsigHxaRjPrZ0fB+PW6i6wCB
         EoA54c/zkWxs+N6qbc8ip3sdPuM6F8e9YgA3IGq5CCiIECd64j8RmnvRz0dSs1O1fL0W
         O5+kCVFLaV2yQYYGdh/sS3nytPzfzQthpZihUIphdEUHJpQfAFmQhuQX+wq7BRcQl8L+
         YTqcJCs8xwqo9Tx6sE9c9guAOatGrJaefZyixbepiJYHAiEjc832BtnBp+UnWReClhUE
         ZFEg==
X-Gm-Message-State: AOJu0Yza2IKbi5vyVZ77Jo06DDf0MzgFdmZ5CI3wCKGQrkIsx37jtnQB
	Sm7OBZp8x+Ido5hxA0W/j/5BpnM/zc5Qi5HwVDmKDZLjobyqx3PCcYdkdbEHfB1wgJY=
X-Gm-Gg: AZuq6aJ6pVSGANn+ui2uuzHRpDr+qqvDb4vls+2D231D6nNyr0olrOSUIY+Tu/DrfMy
	XpBKAi7BSJ0AOfgIEass9kUKB4PesLQi3QBU/p89ccYwpFcLWCioHsulOcX+L7LF1w4CWgTEXRm
	o+NUGoJEg/1UShSmEz5ZN6THInSilxv+a5mHxxg7RPhKtXV9naQMXyug1DhoKiDKqedeUlxMwVY
	6juyCDQwovXPcLt6GVfA3yhM7k+a47Em9Y5LVFSA4a4s8z2f6mpAATAHYOL+miQmlTFPDFzzbqw
	T02q0GF5kvh2yL8/zKEr1YrxiT/pwuVwlH3MgnojhpTXADskPkX6jDt5RPiZBaWE8H6HsOEfCbH
	vEE0I7o4kSY6IK3xU1Me+26A5d+NPwzG3XcIdHBVzXv78dCfCH4hk0HVMDmI8+YWJhogawawsLi
	unMefFw8wYja883Pr+uywttXaEeMsekIrpBQRwxe02rtDRUCVMP8VruPqZ6V0hrKZCNoIYpA==
X-Received: by 2002:a05:6214:e87:b0:894:6558:58f7 with SMTP id 6a1803df08f44-894ea167cbbmr166333016d6.63.1770056619523;
        Mon, 02 Feb 2026 10:23:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm1089477985a.46.2026.02.02.10.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:23:39 -0800 (PST)
Date: Mon, 2 Feb 2026 13:23:37 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYDrqVEOwkGfv2JG@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <20260202182015.0000325b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202182015.0000325b@huawei.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: k1xfehch8hjskjk9kkf5yeouzofq738n
X-Rspamd-Queue-Id: 855C940007
X-Rspam-User: 
X-HE-Tag: 1770056620-863943
X-HE-Meta: U2FsdGVkX18HMJLUmQVuejXNtfF9UYmRPv1WUNccRcJovlM91xHCBvIsq4K/vPafydE2VQoy6QEFY4UW+sy4cIiPeDl/NrQl8H+pCiqlEhBb/qo4FVJ9jc9zyYB8zucJEMIsyTttn0eOnkVVKyZRn5wWO5HymyIiaxhMvT3U2GmUizPCCKiIhr2HOtKnmx0tnbJ6cVSJfIcj1eSS8gWNMqCwteRWApirq6FaKXZ0hb4VKSYuLPWsvIVxqOyRtidUUdqS1iz9tsgiRHM75k6QAe1S8qZBMmOp2Ll4dGHiGa4g3Vz1BrUc5PB2ozAD9nJmB6TLud5HUyj++/iEReMiqcaW1WT0pK8RoQcvqIUcZpnVd9m0eaRiMQlkGvo5yXcNkoL8kEfk+Gf9PAmxwp4tHAPbSNfgGKjdZaGQLaZbwLq4+ZOiK1cg6zm19AsQyTIMhXUnnOAetlVm7VU6GLhTV8M8n8JLGgMAJw7yJ4JfY2BRHSov9hWtFq4Ne1YQpr8x5mJdYHpHXZLGHEM1x36SkdVs5rjXxRresGAhTOdh29bWIdlMk1bEOcC49LIZ5oJNsKlrVbWxdKPmAL8qPyHvz/PN6liC1GqGsCQahzA908FbsXeZXrQVeeI8fSwtg6ldCBj7O2GWGeNl/Fe9loCClAPuj4Hfg+ks5dX8kSJ+hoeRL1ulSQNlk0ywKLK3s+i2Kta+mjPaw2FYchD8NBvdNuabw2RPXOJ4ZMeYarlKRXBXA/GXPuPpAEyjAhlGwx5K7CqkqpXA0iPReRsTMLIREjkHGr+Q7RyPFzcQ6RCs0y2tyTWo4yAj3zxiSbb6PIzVb9cl7SkGYt9Lf15cwnBQdmCBWfX/7qMssl8Mvz8+Nb0Ro5zalfCzkED+piFTcqU0Z4ixPzklHEneQWfZI8NpJk5vkXw7sy3Tu/hQySEU0Qv4TIds6sB5EpYdySv6KZB2kNpygiCDen1Dp5/pTCH
 XbSdNrBz
 6/sjXnxn7VaYdKXqEtBeptO4KpkndN4PY9GmWgvVex+jzXt1PPL3bHt23As8rPkQNsp1EDlJ2r7RGoIRX39eExjtXJO5dQAvhHlr6d6zGIqwxxH4n6YR+Gphs7MbaNWbtg9nzBPTxs8suppRDvbMcU2mfyhEWPzU/NzFLHfH6mmcRtjN8lyqdFCTQIlhYlVr+etCbKAdDckMqbfvOjuIV7A7hpZOlszxot4hwVsbtljIILDbPS4jrP+CXLSM/Eq0HmutbQxwYXGhtBMaC0hlA6E2JORInhQ5FOcjMjrF8oIlLFbpBLzFbfSjP02dyoSFqv2N+kamluafFFstB3Y8LLDBbF+sxJROzaS2LUGpgo5kvejGm6qPbAj4i0gVER5hHWhAU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 06:20:15PM +0000, Jonathan Cameron wrote:
> >  
> > +/**
> > + * struct cxl_sysram_region - CXL RAM region for system memory hotplug
> > + * @dev: device for this sysram_region
> > + * @cxlr: parent cxl_region
> > + * @hpa_range: Host physical address range for the region
> > + * @online_type: Memory online type (MMOP_* 0-3, or -1 if not configured)
> 
> Ah. An there's our reason for an int.   Can we just add a MMOP enum value
> for not configured yet and so let us use it as an enum?
> Or have a separate bool for that and ignore the online_type until it's set.
> 

I think the latter is more reasonably, MMOP_UNCONFIGURED doesn't much
make sense for memory_hotplug.c

ack.

~Gregory

