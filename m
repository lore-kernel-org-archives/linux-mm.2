Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EAFC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 01:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515CB6B007B; Fri, 25 Jul 2025 21:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0166B0089; Fri, 25 Jul 2025 21:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEF16B008A; Fri, 25 Jul 2025 21:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF896B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:24:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6431A09DF
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 01:24:13 +0000 (UTC)
X-FDA: 83704669986.11.BC1EA8E
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B26D71A000A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 01:24:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YwkoOtoF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753493051; a=rsa-sha256;
	cv=none;
	b=C46jcRnSg3Cj3qpUBFl0A+sz8zak7GX+52671cLG9kyXnfhnFpeqAiTVW0qG5QxNzeTxWr
	KAeNZzE4kR0oiiuO918rGaqE7SojropP5b5tmNRmGT88pvX4qqgWITCiqFtouj0YLb9FO8
	ZhGosfpe6z5WjIEA/RXNFq7gVRffDAU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YwkoOtoF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753493051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAoS2k2FG0BBzk7na/Di2MHMPEED+EAUzwwQBgazTVE=;
	b=sb8EEMHesWOWgNX6g03IsSXvtbdsXEwhkxerUFLgriyKuuORjwzh9ciLSvok+304/9dpau
	sWU91AgrbPKy7gj8/RjP9c+N1XMMOPCPduU8cMuF/mBdZ+UjaQvYyM162LUy6qi3F9bUb2
	IebG/5m3vGz0ov4rzf+DLDt8f6BYJXg=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-719a4206caeso28916897b3.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753493051; x=1754097851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAoS2k2FG0BBzk7na/Di2MHMPEED+EAUzwwQBgazTVE=;
        b=YwkoOtoFwI4f5P98seXHGtbnggfLTbxDvYjuxvGp4ZwxbcSHSYbtAmVcBBsq5KbXGe
         J0xWDJ6jvoZjVyIdmdM1gtukzeUXR+9PbyHzs+CQBt8DaVQdilKIkpYGIJF+09geCx+H
         wQCcKYpXkBzZRXK+QuyD3eZLObuFzDSyEoLAj71cVTnLEze8wqClfd2ni0js+BUyrpXV
         e3QYI1BI71lUeAPCop2VVIm50zTlvp5VOJugvP13fj5GF1AEpBNP1BXqUFFtUetWgUOt
         96ISk3pJgECdHgVwL4bEc8RTfuVpnkD57onm1cBR1G44nCABj/AXqjCLs+tmCD+qXkPP
         KM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753493051; x=1754097851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAoS2k2FG0BBzk7na/Di2MHMPEED+EAUzwwQBgazTVE=;
        b=jbng+ZNSKCkRS7P+zFyVmy0Dqfw14aPbriDxQNPD8BCNjHhzFLBtTEZ41LCt2BO/mB
         pD+mOnC3lNb3kC3rKWGI1P5Cgm1qo6Rqm/NccE9L1DDzsCgvUghJEmNO3oMbT1o+qtSa
         3d02/5YiKaOVl1ogS58DROaCXYtTcjbaev3kzLslg9UDBZMBRRgYEw96pIYAgMrr5be6
         LCxHZnfsBdJyE7FKq9CzjM7I0CE4232IOI45eWOLbEyg2CeZ9dyGG0H9vkcpEnSwf6vS
         GARgKOFQHETDZaM1J4ccR0fYZwkcUotVP7J/TZ5wJ7ddhSHfjSBqtpsq6CdekqTtP2rI
         /DxA==
X-Forwarded-Encrypted: i=1; AJvYcCWQGOkjbndTGeCe5OrVqE1yPkMKC+XeEyFyGpbiEu/6dahl4tX8sX5VeQ4aAocm7KodTxklvTLudw==@kvack.org
X-Gm-Message-State: AOJu0YwR5qdiLYgDCgFqWRSHJlDGZjIbRo6ahOEAm5BNFVwEVE27A2WS
	58O3+Ndmn24P3oTpnfAPwOBXjiLK21zVqAwJE26t3LmKvTuT8f/3ydZG
X-Gm-Gg: ASbGncvCTRn+p8tRhdPFp1Gz953ih4nhm8wI/NrPv6Bxi5xZZ39NIDSkGY7VVezTVlK
	BFPIJfgGA9c+t82dyn4MJAQlIay8scbzz82dm4yVcjRV3Ura90W/HCiZ7zv63tOxfPX94Y6TZjX
	wpMHhBkPfRpvvtJZJauxJsGe+D61HooemuqZSRe3hWkBC0F+JvN5MxrHr8k3Q7hVNMyWySIgYNN
	Z1zO3UuAc53+GxA33RTMFmieUf7236lkmgekm4rs03/TthhTkiiQBor+tzUo19DnSXq3/WBEmMM
	r0TV7pgjranvI5I5Zi9ZBCaGt5YgvLYyYFWztbHwnI/sQMcCl9dRdWxHzzRoCL4gu/YvKI1TxsW
	xMfKPcDgspksVqlkfM5kPoQ==
X-Google-Smtp-Source: AGHT+IFq3cRfkS463mO6STS9/bqaq2B+E4mgisgdVwoE3RpChGzqX5rt5oxN+5Xa//+7hZetgSk3cQ==
X-Received: by 2002:a05:690c:6c8c:b0:718:344f:73d0 with SMTP id 00721157ae682-719e3297e88mr56579327b3.3.1753493050536;
        Fri, 25 Jul 2025 18:24:10 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f2152de0sm2402717b3.2.2025.07.25.18.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 18:24:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Fri, 25 Jul 2025 18:24:04 -0700
Message-ID: <20250726012407.297378-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725214426.51487-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B26D71A000A
X-Stat-Signature: 7rgdrn8gpsy3s67kw98ugdqwxo6n38my
X-Rspam-User: 
X-HE-Tag: 1753493051-788528
X-HE-Meta: U2FsdGVkX1+ynAoI0SF0Arr3zcMKD11KM30e88UloG61JOInnyk077US4MtrYlPQ0zeU33g/TIcqPjTl824qtjPMPAUzS1s3fGPVOdRS4Ad9VndqWDwIBZ9nlwy/DmFswWUGjseD7wpIjAXtazRKh95VekIBYZDYUuXykc6KR04BS3gLeB5vHtqpSP+MZDuMsbBXBibOTSCLJoT3eVjFeT53xMidstvn8nuvHqgGrWW3mmDy/3KVXji+kAA+JDAN6vTcocnNVUigr+xjZnuWiDmwMndUaZtQNaXCEJbPrw3OKtTClkqjDUu497smlIARkDnxk5ft7f2TNDXzV8PjN9OEABQ2sWoPaI0Rk2GzvWCdFRN0h+ea/xMUIXS34C+L07VRp2xFbsHwMCB3vUMbopY6d53OnSGy1YKxPBYjBsSwF1kzSPle1HMEMqo+Zo5Ct3NMq6t8egkNw7mrYYN5eXVjAy2vAfoL7s8n7uWut2wTLKHnv3YiaDdPwMG4kSrrDQZJoehsuFzbjmP15IBnelT5K3R56SS+G5jS3/YYxSwjue+kxOOXP7R7zO73T+Jtr1hAVVKNArjozgW5keZG5ji6nuiCUnPfgsolUqdvab3wWhPPkKraOyQy2nARIajHjVmPWROF6daVZCwnPQa/lbwesr/JYavPM56aodNifo3fo7L6318jZQckIRXhxjwkvT1QxizmxHMA01CshvBSBglQCnBcnW/oHybsGApTp9Qf3cQ6hMtHIeS8lOOUOLbuKSbH2wwBcRBTL5tZc75srM1ScbnncHvaqOM3MCTU3GxThxao98gDnf+3RA8pgLTX6S1y97WFqEnYQoKRx+sIb0JcukO7zhNpC+VRrSZTqhgOJHn5ulbZLKwugIhbogt9XLMdAEfdfgYDSfjQ/ts7Y6lhEqMb7TXE5rFWHstQBv3samdGu81wSt9bSs3SjkCEl/NJ1eAb9uuOKn17hhT
 eLNVnbED
 7okstkx7zFN4EfMlBq/Uw3fyJfGKscJosjNEtAgMxZYsxQQDuilMktQ4/nkvkPYIMwbp6/p78LzWkrEn3s8VVsuYpiMAXWRZxVAEjmVwwr7OVaB6rzCoGqpi3aUhcD61NKlvjZqtq2H1VNksrO0bZbx5MFnXKRv64+blh2P1aj1WaEYSM/znZkooQ1LmoCaKoXCWnnhWXjcFGntWwyjYrlX39n/LtQrKX8S1WcMcADRRrvE889gyaA7YuerL25ZSNPmXvimhdweNB3cMl4GQ2gDIBR1T7tUkgwgbUItwNjngqvxNnw40Tcl/DxzkB3XaC06HkyH1k3evEUBA98adloGjEK8Fmb9PEYMkZFhvpQEeOzQJgxmvV94CPqQp/yOgA/9HI+SOHl8ZwtvXt2nxIbk1xvDXsPCv8WOgYw3ayoDUBftkWJTbNq7KvgeibK9XR+amirUE3HORJp4w5CW78Ci1NUeIU0tAQRq+IvCNOgeGOh70cl4ltnPuYvK4FSMIBITFb/B2XiKLSVimr8xYG01tYPc9eDbVD7A+Sw1rygLlHUsmVcEKh8gkdlsqOt+Dt1WqW5kFIkRSa9796ENnGm4RIFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 14:44:26 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Joshua,
> 
> On Fri, 25 Jul 2025 10:35:45 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > The zone_reclaim_mode API controls reclaim behavior when a node runs out of
> > memory. Contrary to its user-facing name, it is internally referred to as
> > "node_reclaim_mode". This is slightly confusing but there is not much we can
> > do given that it has already been exposed to userspace (since at least 2.6).
> > 
> > However, what we can do is to make sure the internal description of what the
> > bits inside zone_reclaim_mode aligns with what it does in practice.
> > Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
> > description would be to explain that zone reclaim modulates whether page
> > allocation (and khugepaged collapsing) prefers reclaiming & attempting to
> > allocate locally or should fall back to the next node in the zonelist.
> > 
> > Change the description to clarify what zone reclaim entails.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  include/uapi/linux/mempolicy.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> > index 1f9bb10d1a47..24083809d920 100644
> > --- a/include/uapi/linux/mempolicy.h
> > +++ b/include/uapi/linux/mempolicy.h
> > @@ -69,7 +69,7 @@ enum {
> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >   * ABI.  New bits are OK, but existing bits can never change.
> >   */
> > -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> > +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
> >  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
> >  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
> 
> I agree the new comment is more holistic.  It explains general
> zone_reclaim_mode behavior (how the system works if the mode is turned on by
> having any of rightmost three bits is set) well.  But, I think the old
> description is for the specific mode of it (when the rightmost bit is set), and
> the place is appropriate for that purpose.
> 
> What about keeping the old comment but adding the holistic description on the
> upper multi-lines comments block?

Hi SJ,

Thank you for your kind review as always : -)
On second thought, I think you may be right. To be completely honest, the reason
I submitted this patch is because I was looking into zone_reclaim and got
a bit confused, and thought there was a possibility that others might be
confused as well. It might only have been confusing for me, though ;)

> And the behavior is also well described in zone_reclaim_mode section of
> Documentation/admin-guide/sysctl/vm.rst document in my opinion.  Maybe putting
> a reference to the doc together for readers who curious about more details
> could also be useful?

Yes, I think this is a very good point. The comment block above the #defines
were added because in the past, RECLAIM_ZONE was actually removed by a developer
because there were no explicit users (although this has changed since).
Perhaps pointing users to the admin-guide can help explain more about the
context of the first bit, as well as explain what I am trying to do with the
comment change. 

> 
> Thanks,
> SJ
> 
> [...]

Thanks again SJ! I hope you enjoy your weekend : -)
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

