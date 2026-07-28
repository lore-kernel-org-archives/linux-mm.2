Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1DBAC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3886B007B; Mon, 27 Jul 2026 23:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BC96B0088; Mon, 27 Jul 2026 23:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B21D6B008A; Mon, 27 Jul 2026 23:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3A476B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:01:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 371441602BF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:01:52 +0000 (UTC)
X-FDA: 85036685664.13.3C45F49
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 61C451A0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:01:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tkOJMMoI;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785207710;
	b=jLlVSQ6H95eA7kp4xunW0sFygQluq9lNBOvfg+1W/K2YgccWuqeirt/MoWkK9ULAVaL63J
	BNnIrVtDGaoa/8j4I79NRjcUlWdyLFiF9ZF5wXnGfFsz+sk6KV/8WguuQ7hyb2kSxEB7aI
	2FfT/pE1sJsBuFRqrgCH9Ida8tVZS7Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tkOJMMoI;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785207710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4Pummo+n71rvpjOibaLf+dE0Duq0sHkDOk4xh1L+FM=;
	b=hhdQPhOxTA0J952IjqAJIgyIkkxwtzFxw/G5+h0/Nwpvd70ZXPHxSxjh1cUjsrOp/i1aBN
	mcGsJdIDDxArTDVfgWeHI0YmpXWL7rFbmrZOkZ10Tg/oDoJ32mCxxJ1zIX5CeFjRIdWhXe
	tbRDbY0s0kfxevJOgB5AY4zN9lxd19s=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92f0b5ed131so240401285a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785207709; x=1785812509; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U4Pummo+n71rvpjOibaLf+dE0Duq0sHkDOk4xh1L+FM=;
        b=tkOJMMoIu/oFmkr5Gs8GG5ak9p8ZTT+LAWmy52PyKrOUIbpuQFuxkXo3vU4r5Q383S
         KPkLrCYKHEYurksoqYrRPqRKVCwQpYjBEuydynZaK8UODkgMguWqlgu78+08OtnpwNvC
         AekBYeKz35gcktYpqGOmYh+cAFKMEuloiFvLSEo1bI5JKUQkZVonCwr+mqBZp8OsjiYL
         Pa+sMy4fs+yrWTLBhBTjhXFwGjYQw99YClv+1y5DQOXGA3N9kzFuuVR/qSxJJ/N16YHy
         +gAeq9xy1ATRsUhoOX1tLoWLVc386UlbKctxO5Z4bkS8Ew4gN0GFZkCxBBTQBA2bgaqO
         DlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785207709; x=1785812509;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U4Pummo+n71rvpjOibaLf+dE0Duq0sHkDOk4xh1L+FM=;
        b=Ev0OE6E4/DERe1zbp7OlLJlrtDRtBX+UGpNtmTln4M9L0NtEWwSOT6LO7LeeiYhoDK
         JMEXnHCxb28n4PaJb5slNNBB2WPpvAtD1fL+Yf3GQGt+wIEP3dJcv6aVhb9LCSZJjEWK
         htE31Og0E7ALAZolb5Vk6ObREFLhvonl5FwErzoG/4+Y6Kfq/3rDjIPV2vNXbO/Zu9q4
         7KiGvVL8oTW5bOu6gakSGIVdSa/Pw1oVqhIbZYGn+4v7XZADR8buUZ8mHBmXUdGHSTql
         RYQJe0/CN9ylgu3aZ4x+XcJd5+mqQisH6GNJI12GWwrar9sTpWBhmbbB0t+xE3qxdtWt
         chAw==
X-Forwarded-Encrypted: i=1; AHgh+Rpd8mmh5P/QEFzXGips6dyOpHMUeEwbzTR/YY89QwpxF6K03Z350Sd7MfqLTsSbNi8VvrxB24DrLA==@kvack.org
X-Gm-Message-State: AOJu0YyM8fw6WgLWdftBDKVOFSIYmXCWlkTuDlSv49F4jNKBYt0RxTNo
	jX77h81cjvjaw+sTmIPEEX4OFKYTPaBSrMEEn3VxBXYqr4h5f3mTbzI1wJjYgJ5LEOs=
X-Gm-Gg: AR+sD104PtzhsYccD1d/dgx3m+CyO5alPwii2544jBOXJE8CFMUEc+6SkiauQ5lCWnA
	5x1wubXnkxPcrVg9wUaDCzTdyEHZnq+ssAA3Eg0rImO6ejrzt/yGqh32I2NhhXvazFVXka3eOmA
	ksGwlVNqK1KyF/eGj7QMwH5r+jxbJhyn98/M63z4XK0nsqkL9grV/M5j5SPOW005bQFdGEIdyOB
	bQ7jjny3v4Hu5roO2f53oOnEhvynNTU87TN22lcPN0Q1NRkG9noIaq8RrW2uoabnuu4WOyVj9bA
	hoj3/LBQxumSgh48La8nD4ryJsx+0rG5GY6Q755w7qPwQ/NDnXF6MIopzpiqquZ02o4iQBVZx3U
	SbhXXxtJQzdRZcREx1SUY+G0HI4M/q25h65YcRSQPAovZqFdkytLTA5PeQFFKdwgxteeqw9q+w2
	ZLX4i88BN81sHJlM1FE+Qn8dXkT5fR9vnoL5dmsqPle5JqJmb5v4L/jnPvmg==
X-Received: by 2002:a05:620a:45a5:b0:92e:78cd:13f with SMTP id af79cd13be357-93302659657mr50219385a.33.1785207709426;
        Mon, 27 Jul 2026 20:01:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de53f36csm753319885a.11.2026.07.27.20.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 20:01:48 -0700 (PDT)
Date: Mon, 27 Jul 2026 23:01:43 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v6 02/12] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
Message-ID: <amgbhnH2JJqnCQu-@gourry-fedora-PF4VCD3F>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-3-willy@infradead.org>
X-Stat-Signature: n8sqo5t4fece74hrjgk7icnwj5xa4afr
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61C451A0004
X-Rspam-User: 
X-HE-Tag: 1785207710-627323
X-HE-Meta: U2FsdGVkX1+ol8Et3HzBWL4wGGctToIiQp7ST1KskQArmJsq40eBkII11zAWTscM6DDUYaG5Stn3DP60ASNKyMsRmze0sCpiF1HOihWvScFDeOquCmoJCkDYqrPGyKikec/jTZMnUV115jP8Sg1GkLP8KStvF2afVHBJ8SwYDF8ooAAzxfJeRP8uCvG1tfBWyQJEC/a5qRtNAa0RTSUHDcTQyBrzW3N/yVeVDjNr+8GfjLQbC0orZhuLWUf1EphsYbsOdgD0r7h4hvNAUYahyquCE4LNdKXvgZn8F8dgTuIkKXqgTHb9+2Lhm8J3GFiLgHkDkG7ZACOmD1aQyQI47XPTJ8Gb6RO+PtH29DGYJ8kc6z/Mh7LnDy+C11WSgkx0Kc2mskwFYoEBeHDI9ammCcO9ImzcAI6kGV3W+IH0lzRmaRbGlinC7nqkEzMDc6BkSu3P1R71/SvhkOn2qspUzqPYrNvzYVV6zHIauvqctLj0vnsVy8tey9/N9OlRVGvj7BNz39P9gMioqo7zX/wtRnlHSyc8Xn9YXWD8bqcNobFxWPy8jGB8UGx/N2WI3GLGxEzRAD6QCQdxxaOLee4otTXBL4SoqFB7qpnWTUkOGFrzDa1odNkT5jhYhqrp9fEAqyM3kXYvbf6RzNx6aMG3YNbpxgHM7V2X8aENhSP/aSmdFO1lY8ya4wWx9Z3xq52ZsZy5WCtKba5xz3/VxlPoumVgMRWZmmJC1rAK0yDrcXPQhYtZySuGLCU5eK4HXKTMWPwM4Aa3jcgnUrEY3Q9aWCRmYMEO470hdrRvA1kWPxnjuv+7ZAhl9ERKwD6LJOvsVTH1AaFtkJISh74f4UaO55665qwCZz+PiUwfyJ/y9LBvWLViauzMGrJd2OniyYnicQa6HdySoRTDuJuqIzvoT3PbczyssbiZkl2QNeXoH6eSd1QjPnBT1Io4s0Nfe3/Vxceovb6v8dkzsR6fJVW
 fTkRlMIP
 HJXNuE3wiBU++JkoRqOa00NmaqFkS+ZdPfU5c0pR/kWacA44XRZ1EMsUYGoXjNWpDx3iM01lae3Ig64bOcNPc51mQS1j+h50uja0fiRkJMQjNdi1nmb48DgN6AKxix9eG56qhE+7LPSau9PuELJNqXza6+2p6JTG0H00zW4k6U7wp86zuWrgymoyU7QtLJNYHQjaaF0LbOUPn7Ci/8FgMzMi7m1nkb1BizHBgQLHGjIqhLvhS8FxDVWz6IkVBFOqSszcCnY0+oB+2O83jmwUOl91/XsepRXQ97oz1tMn1sf6I2iccXF/mwQxeKrsux0AkPcu4yaUNeYsBZV949gVa6HdLmTynFc4hZdOfdn3I5AfmTBQHOETvkHnLvXJJyulPb0VF9b240XlL9yLv8/OYPeeRFXmSie2CAC/lb/Oy8mZG82uLlfoJ/cDpGTgdTRrWKPMkcBYNk9rOJvshQRn1X1h5X7kohr4YFj0xh08K1ugdlm6F/KOCM52sKus5S41NVVXt0wZg6jw3ks7OgDKoY6DxMTyyt9XKDN97Wfv1Ysvlhrt35wkmwo3kCSM+2YKUKeRX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:12:58PM +0100, Matthew Wilcox (Oracle) wrote:
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Gregory Price <gourry@gourry.net>


