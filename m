Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537A5C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591C86B008A; Fri,  4 Sep 2026 15:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568FF6B008C; Fri,  4 Sep 2026 15:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC0B6B0092; Fri,  4 Sep 2026 15:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4196B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:31:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC15740176
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:31:24 +0000 (UTC)
X-FDA: 85177073688.12.BEF5D69
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5EEDA0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:31:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Eh7wTRhd;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788550282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IasE0lL7i4xilSrjoP984i9qLy9vPz5YGSTLXTZQjBs=;
	b=mA1xnn49BucdryDZaVPqotIiUpPj55AxfGTlvyen7yWkVsJ719lG2KIT1c//scPvxQJ2bp
	BfPNLC6Td3Np3VdgsjxNG6q/bPpMus8WfNrZ8CDlAMNisOtoqpxlHrF0uzPJCTJ9DemIfg
	RkMgsP0TVM105LQMarKlTjJ6biuWxX8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Eh7wTRhd;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788550282;
	b=0YSI4Oy6Cy89RhzOO+7TfBGmQ8cl3KrYej+I7zrSSN8ZMZZiBEmzi6f3LjIG7skxZemID7
	MkXo9CoeCtsA+10Ip26LrmlKb4u5RlgT72HNdxnUdwuvpHP7sgeQcM/KsERPjNN5wyda11
	Fzu1vNlqt91YyMR5kCF+PoPwkioO0ZA=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91041ee9230so12345586d6.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 12:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788550282; x=1789155082; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IasE0lL7i4xilSrjoP984i9qLy9vPz5YGSTLXTZQjBs=;
        b=Eh7wTRhdd9e5HA4mOO78Kw9Xspzrb3N6tJj7/E6sB37eT8AK1M+vbXldXMjr/h7HYQ
         sz3HaTnMo/RVQQRslfrXdB+Hc7nI8x+Z6uyQTJcvK0r/HZMlDrGvqya8LGRK+24mBVkS
         caSkL7RJo3beaK+1jQFdAKNd/CuJkv0D2frwv4vV+pUijo/NrS7e7lqnRVC3+AIOSMS+
         O28155fZD6a48UplufEZ6gH6GIoc4CWRI4uGCl56UVLOieZoFTm4WcjJJKb2cZI+tzuZ
         chnBt3qMBGqTsM/zaYsSZFj6Y3K6JX618mwtmD+PmgltEvsZnQ4ndAWwytV8+tKMdo/v
         13cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788550282; x=1789155082;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IasE0lL7i4xilSrjoP984i9qLy9vPz5YGSTLXTZQjBs=;
        b=hFSf0cslWSd5U+KTiy3mcLVr68xMMzbSySdLrG7f+BrJuNCQGvNCgAp/SjmUMjzwCc
         FM4KxrdCOCEUwUmSO5u0amm7SarvETYzaJfyvEQl8AzRzk6x6S1EYJ9gSLHDzf9dBbJ7
         EJBKv72QacOUfI9V+m+xk5Pmj3Gm/DSlezplbGAqSKkiOnMR1y6fChsl2SIiaOpgLS7D
         +NVv00hRqgEia0Vv8T9xPuMqlspzlis4TBOLPxJ3YoOth2aDXFS49iGfKMkMxCIGOO2A
         PvrNDrkpF5lAcWlN6mT/Jwi0awUT2iiUOfh3LQqxVAeqW2i1uQIpKDdx7uVxUdjPjx4E
         7N9Q==
X-Gm-Message-State: AFuF++ksftXGEFtlKXXYA0fHuwqzDmiFPb3XzYuPhCKu7J5BTNY6Ev85
	phjD5LCtSjCBCdvDrS6L9u75lduTH851cGW/4j5+SxxQz+j0FWW8oP3o+q3WSJ0gl2ORt2eBGFe
	xOa0u
X-Gm-Gg: AYBFou1yZH/RskiERY5E/ceN5ZP2MXJtvYdLaAxrQTMjq2zkI1z8/NukpBLWMtAjE/u
	p6SjtP6nhGBMxUZ7mzbw0OhP2y9sTCscrYyUN5R9TzxXBwQ6ylfrJmSID5Fq2M1kRNCB05tPBCT
	+0LzVyQso5yl+ReVrgEuNUmas8BKBbfNpflEhAhEcRJLjhl1cyad1dVpDXMIDED5eS7fvh1FmNo
	DyaoRUW1zr44Mk9gJYJhfuIYr1UxEziVf6RIgAY2EAHRuqjA8AW13AfOMB1cO01ASR9L/iKHIDW
	yhOHvhU31U7gI3EhNt1pRTuOWEn/TAy0cFqQ0lwMKJuOejUTvj1nqzcFeu4gNQMA0zHR6/voR4u
	ugc/1GKw/6mP4l9IlUSBnvG1DlXs95/ORgiiwRSDZZH89sB1aHKu2oPmNLYUxHxQW/PmXT2q0Bo
	swxfGAJz18uzerg5Fiw9utAbD68kami1DHj59d8pbu2obyH0nz2pTbcc0eaJyaLbWEOaB2jCmXJ
	EG4VPBna1JMnkY+YKvTHjJvfB0J2k8vK0xK3nItf4Gh
X-Received: by 2002:a05:6214:600a:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-9103ef8d685mr86892886d6.9.1788550281921;
        Fri, 04 Sep 2026 12:31:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040664474sm28898236d6.21.2026.09.04.12.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 12:31:21 -0700 (PDT)
Date: Fri, 4 Sep 2026 15:31:19 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, raghavendra.kt@amd.com, shy828301@gmail.com, 
	baolin.wang@linux.alibaba.com, osalvador@suse.de
Subject: Re: [PATCH 2/2] sched/numa: scan read-only file mappings in tiering
 mode
Message-ID: <apsX_E8GBzfp6lui@gourry-fedora-PF4VCD3F>
References: <20260904182006.1562449-1-gourry@gourry.net>
 <20260904182006.1562449-3-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904182006.1562449-3-gourry@gourry.net>
X-Stat-Signature: dx51aag69ofcpac18wbi3ebikk6zpf8u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5EEDA0006
X-Rspam-User: 
X-HE-Tag: 1788550282-863012
X-HE-Meta: U2FsdGVkX1/UP0xWrEGPvmyfIww0pxdj3+n2wij/1zBfzkL1C9QyPUllcQ92MtPN6JOVOBz0fCkXjqxLHaEHXn6+mMCI9vB6GyoBHQ3xipiavNajPPy6DMOUvAtkOe6dqCv+upl3Q8Yo6f9EOcwwDh2Q9bS9htMk7FZkCpqj8IhKyZ+KxBN7MYfVRMiEbcTckCvBphOIMzfLRu4T45bTTKrxSYZ2/FoE1pSdJ6gE1vc8KcXmjAYvYuL11D2nwV4zIxuaa4It7Tfnt4qIhOZ6jAaVIizUdBcGp8M7XJ0F+k78SA3H/wHj9wCk0DXAk9cn2IGaT1Zhp1aiKGdslfQYQOy8NL0rO5FEAxHLmv/l8hnHwVmrlLV7UiiBxvIz6FMcjEwgPvFbuCM3Ra215A4nQB4EnYIGbvFFnaZ8yBypBC/LiWeAcGJ7unGArdziWQL2jdk3g/NjzmzE6tFzyehc3Kek+GQsdUDYVBslRJ/dKR8ajDuDEnaTzsnIpP5p8pp2OcbxBtkc96H582mV0KbTvLpFIGYKvQ69YQhYx22zw5pAS30l/LPDiXjpmP2QMszh0yEF4plcrY3DOekL+kevAFsRfFoF3UiHu/IltBYM0mvDETr7XqgMe5xeTLh6N/aMLYmJQ35rQIihYX8xKSq2VNWkwoo55vNvv8EH+ADDTUxPG9WNkZR2IuchrlESGpKkXODC8Lm7M7Rf0QL/61ROUyMzCBRV5ryIZtL9Vd/5IKv6KeBZYQzYG6Om8m9OYXt5hPHNZI52xV8ou+TJy0EDQbP+cg7gHbRWPG/45nOYILxUjZFMqqZzPxtSpSeRX1K+9sgSOIWrdQ3/SOtwspzO3EoPW7DUZ/ieYMxTWoroytU4l2H/x8Oyi+zcKKzUTzbWSYBe1gygDwL4eeq9y/o+gq+oqmWf4D3tGRF/IqnmEC992PCcW5Nv6XIiCHbJcAhbzUEuoM1DtjhF7vgk4uc
 Rmr+uvHI
 46nYq40wH7nsxvPCWQsDhltJ/a6r5KFC27Ln6VavUZkTodiXVzWujIIE/qBtDHNqce+3IVAiwU17X7TtlTEh3B6tm0UOOtugDu/uz1uO2PXj1vNyI/zw/ypfbNjfcm2IqwrY6qwYTwHL7fIPoP7enKrBUttFskiuKo+rJqoOTWeCZnC+pFKjpHPS94SH1f0MjBEpoyO+FWBNpKLkc62UHCkRC2ofPgknzLdjnR5o7hzhUudxv7JR5/dRaB39RBripl5Xo1M32e4miCWSxTmZnaKKf0MrSc2+gLG+uYFyCifDSJlodT69wCozJ3sVa4iVlMsfk5fKPZYn66jA2tuEZu7Do2sWZ2btDYNvw7O/CidODc4Go/HbS5je+MWiaV2UNm+OiJVdmVD2d2Zc3Et+2YNPJQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 02:20:06PM -0400, Gregory Price wrote:
> @@ -4302,7 +4316,7 @@ static void task_numa_work(struct callback_head *work)
>  		 * VMA can cause others to become "permanently unaccessed" if a scan
>  		 * cycle is consumed entirely by the large VMA.
>  		 */
> -		vma->numab_state->slow_only = false;
> +		vma->numab_state->slow_only = ro_file;
>  		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
>  			if (!(sysctl_numa_balancing_mode &
>  			      NUMA_BALANCING_MEMORY_TIERING)) {

Sashiko thinks this causes unneeded rescanning, but I don't think it
does. The cursor prevents it from restarting, and when we loop back
around reset_ptenuma_scan() bumps the sequence.

It also had concerns about concurrent scanners and ptl lock contention,
but mm->numa_next_scan only admits one per scan period.

Either way on a rewalk the scan hits pte_protnone() and moves on.

~Gregory

