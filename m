Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D00EC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5356B0191; Tue, 18 Aug 2026 09:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD456B0195; Tue, 18 Aug 2026 09:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9546B0197; Tue, 18 Aug 2026 09:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7456B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:30:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9CBE1401AA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:30:41 +0000 (UTC)
X-FDA: 85114475082.19.2EDA189
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD128120016
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:30:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VmyuXUqF;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787059839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ax6pSQ+/xfd4HZ06hVopmXYjHWPwUVuXeBPTbOtm2CI=;
	b=5sxMvET/VFaDn9ilYlFcHAyiB9GNQHIo7SdknFl3X9bP49tBlblyh96SPLou1pbHK/K/D+
	5Lu78W1IB7ZRPjMBtzNYdAbjP63zZiVoJg7KKExrsK52cc5eCTXnOCW3zpMYTxfeRSiVFR
	4qYDKSOzrqjVc694CbmIQza1KiG9fQY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VmyuXUqF;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787059839;
	b=iBJVRzK//5BA5GLG50VCW9w8J+zWkfT+LZehdXj8mmac1g27vuhGzEKGOf9m9ptD2+4hgZ
	8xTjFmhYVNLbLsRboY1lnUaxB+020wlce7lwsooicPCdbA0Soj6s4/VZYiHMG9BxiKOglm
	jSeHoRZFy0ylA5yp8NSJZAHclYvIJAo=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-908934450cdso35412176d6.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787059839; x=1787664639; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ax6pSQ+/xfd4HZ06hVopmXYjHWPwUVuXeBPTbOtm2CI=;
        b=VmyuXUqF17xE/bnSKvUw5WlO8IEON40kzBp6ErtETpgEt12B9hsFBhmqLC3kF/uRna
         vmaXS+GRzMMfXCkRyKnbFTNS+mzauJSt5aF8kJoLoZ9PkqBOw6pklUx4RAZDHjqJ5PA1
         Clzdkp53uPZQ7CEQts+xbck02qNJIaiqpiR1BpQ1Z7qWc1IfvpAL1lGcfoiLOW93gk2B
         nRII9YS7lUuZQRd0qXk1xGirzYT4YmGadyMZOAM6dMCN8LZYezU6EZSuzw4WGbTlaBT2
         hD99OTa9+kdUccCQDHbmA+ZaxOXW9cpy5XqwBsC1nHmb0A8U4kKR3xREbttYif5xjcHc
         Cg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787059839; x=1787664639;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ax6pSQ+/xfd4HZ06hVopmXYjHWPwUVuXeBPTbOtm2CI=;
        b=Sd3p06tmMkiYQmBSFHOzsT+x5QPyri+6Ki+elunA2v8HzqRKzFZYB26ASEaJWuAXFY
         2S5B+b8vtejMgrsQ/lhpHJzq+pdkS+qItrIWhwQnOY93a8pPNUWOdanCU7hh+CDjQSiP
         6W6V7+sE6HPftcGVXEyipw/rHWbpE/b13QigjHUVVhRs5ImmFlSL/VUo+msxAqHuMgmF
         aPP3X6fYSrPd2oLT70CqGt90zoVh4/n8auMn6TghO2hDSxPOOtdp07ImBdttjiCGMD2c
         eWc5qQxoqy0kqyq50nw3q+Y8y/nyfrU1nFERPp0BmsOsw4pWGE/F4lxInmkikoMIn0b9
         /+CQ==
X-Forwarded-Encrypted: i=1; AHgh+RpRFnumT+EpMIvke8FHFIlTIhfuiNbo5r0J1fYMybZimc88W83VvaKb6DHwgFRqNla752fY2NFByA==@kvack.org
X-Gm-Message-State: AOJu0YxD9ZlY6m0FQ1lXK17v1EO2N+hlU5Tyk2nRAwl3B1aRRSLIST1/
	nO2OGuFOmPvjrR7Eeq2FXHX4PGZCylTqwNR7NMNkDj1XY88v/2iFMYF/ExU+fHt4v18=
X-Gm-Gg: AR+sD13UUBha3sFVZEgSvoSx4BjbAn32NToaDVwTDqXrH2cBV7QuYFXFerkZtLolyUE
	ulG8SX8upf/7krHRf3z4wwgZOZKoOTOOVziIbjhu9ONUp9Zj3dZUnetO4GWGiEdPlOLWfdqeZR4
	cBimJnNQTqayz/dkYckogawJ+56G1jmKtLyZhu4PyDOWD43JASrd86NqnAwGsZtkKHGUXXK9ID1
	GTeL9GouCzJXqLIivoACmmlN8SXIjltWh3E7+VT3tgeTKZbW/ExkqVpYQ1spaUYXFtLOTYseEkv
	yXBX/bJPIk6jJAVq5waTdt5r6cr2ae1Cgiq2d/FwAzBr1XUzXx2aBjG+Ec3Nvqo0fI3l2bPFvhr
	rtv+XwriWcO5VhBL7hoVjLyKlcpz+917I9aj2utgBmmI/9Oa7ZnhGqqOdknvCneFDd3mI8koc3+
	l36GfvoogzbytGkwILUQKWhz3GDv43jfHCwla0bT3PMMWa3MMP+PaUMMduYsac8onh0ptxZeONm
	y7Np15J6K4MQ4EtY44kU8rIrSEvGUACgfmRQeyqDHQS
X-Received: by 2002:a05:6214:498a:b0:908:a54a:5b29 with SMTP id 6a1803df08f44-90a91deefccmr394858816d6.24.1787059838767;
        Tue, 18 Aug 2026 06:30:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4580fcc4sm32688846d6.4.2026.08.18.06.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 06:30:38 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:30:36 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net, 
	jic23@kernel.org, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, 
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <aoRbDEn1sQ7b22dy@gourry-fedora-PF4VCD3F>
References: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
 <20260818060201.1907-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818060201.1907-1-rakie.kim@sk.com>
X-Rspam-User: 
X-Stat-Signature: 8gh4kuudzif64f4o44mm3uwzfizd8g9q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD128120016
X-HE-Tag: 1787059839-41427
X-HE-Meta: U2FsdGVkX19cf/R4pUQ+Ntsw3P6SWAg3BTnCg4nj3r9IkWKS8M1q003T0BNHcDpam7S0X1XSqVWJpth9zis+pZJsgEutVusGaT0kGqHqmJkhrRtn5XUceB7tziq2Uim7AmovfXkeiyclZ3aMP9OQLriqiiqeiUJF8cZkDO2BISPuIj+AaAb2TCcHWgm8faCy/N/a6VeslOmgNlzLJGVZrZuNaDjBRlLq7WEi08T9SfcOCPaJ0xcmhqaF/pzDMQDdVfSTMeZ8anIBuQrbEypzKOF0OQT9z+UoTQb7v9exN9ZZ8NgajY6AVftTTYEaPn1nXDSMNr1/2UMnpF76Ezh1SJk35CnHjSf5aa9E2JMSrl58mjtDTc7l7rul5bJAav/r2QRHisfMAhfG2rpLCkS+KPGPBkR2NWxcR/lvtpEZtaC6RldqWqg6Evpajna0lG89zlPEZZzRZG5ZYqYW3Zc9ajUSshGHOEcYMn6aUnoTWvokOflxNGbtxTDFHSQ22CX7rSo00yr3wGs8H+0ez7sKD0TTbV8W5VgHvu1oMZuJGoev01LE2ghVoUXd+nh0WxKpLrEQByDXpeqHOkIp4Aa2CYg0izNimtY6oIuG3ZtNXaPHQdCiI50/IupA67aggNkOLCGcJoeUvxuQXwBXDcs54lNqLrdNEpTaLDyx3NtmSSJlSYzesZB+N1fSatvXLl+iFOBAIyLmP87eB/BXMRcuqHNLqiNf2l7yaRr+99pCCL9qsj3JTsxYUOCeDfeJT+5dBbu4teQu+cpmYJtoi6tVE2eHmvSh5bU+fzvX6anc4iFMdGx2KXkdNOa4PAvlCu6QWLggy+XC4CTu+yctIR9yWAF8+U8/NF1wRQvUD5m6scpdS1BusCJbIDGsj3UAlrpnhYA+k2ubEnEIQyWwQH0TdQwYWMT+CF6lZIMMhqiuEcsFG5ELadlmQ9qe+j9J5OGChDBrciSQbNmeYm8rGgs
 MC4+25ve
 1/NmKDETtwmRaI6vJCRXty4j2quiRETq+54TgkOVxkk0FbZDgO0jtsUrelEVxs2sYH4V0TEvv5jRnF5507dn+tPlTCd/qkAhbpl2EEoWKk+iQoZfGya+clMPDK/L21jzHgb3rWScq6ONiZRt+lyUJFI0L/dZFHcjGvV4YuAGmpeGT2DTIdwa6dy/DG6VpY9HB734ZCpEPjFj9TrnwOzNydKgr5iLAy7gub6U4bdsIGatEtQgxH5BmNlDoRY+2f71HhCdSyQDXiFT+i7j6zjFagf+SeKPDyHjeUQgbblnKqk22uHj6JSoHQBAiVvKU+kTaINSTM+afWYsroqm1SINODBiLGO46SJlFPMR3HFr3qM7gxjAPMdPNGyv2AENCqcYKysLpBamxzbFicQlfvbjQUX2OyRVhr+DeNj4ie9GDf5u0sFrz70RIRFmjY4mrkR+VG4xspWjQ/WBSukcVPpojb61E+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 03:01:58PM +0900, Rakie Kim wrote:
> On Mon, 17 Aug 2026 12:19:51 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > I have some concerns with the now additional filtering mechanism
> > introdced into the allocation stack, but fundamentally I think this is
> > a *better* solution than a straight weight-matrix.
> 
> About the cost of the filter: when the toggle is off, the filter does
> not run. When it is on, node selection needs a nodemask filtering
> step, but in my tests the overhead was negligible. I will look at
> this part further and check whether there is more room to optimize.
> 

Not concerned about the performance, concerned about how complicated the
mempolicy - cgroup - zonelist - page_alloc interaction already is, and
then adding another filtering mechanism on top.

Today we have:

1) cpuset constrains mempolicy (nodemask remaps)
2) cpuset constrains zonelist walks
3) mempolicy nodemask constrains zonelist walks
4) memory-tiers.c nodemask constrains zonelist walks for demotion
5) zonelist membership constrains allocation access
6) a bunch of corner conditions that violate 1-3 for the sake of forward
   progress

now we're adding:

7) memory-tiers.c nodemask constrains mempolicy nodemask
   except when it doesn't, because fallbacks occurred hard enough

It's already un-intuitive how and when memory lands on certain nodes.

To be clear, I'm not saying this idea is bad - either as-is or in some
other form - just that adding another nodemask filtering path is making
it harder and harder to understand what lands where.

Mostly starting to wonder if we're reaching the point where the page
allocator needs to take something a little more descriptive than a
nodemask to dictate placement.

~Gregory

