Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E40CEDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3236B0088; Tue,  3 Mar 2026 16:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651026B009D; Tue,  3 Mar 2026 16:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553626B009E; Tue,  3 Mar 2026 16:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 407C96B009D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:03:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6E3B8B1CD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:03:48 +0000 (UTC)
X-FDA: 84505978536.06.5EB001A
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D012A000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:03:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=sHJJSBlK;
	spf=pass (imf15.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772571827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4rybKDMoyY2IHTBJRDgn2ftLBqB7p9GFO8FxLdaHZQ=;
	b=zZwO5WXckDI9ly7tq93hNW0byV5sAHbsIl387IFi4p7ziKsB8/oVrTReJdSKVg2AUitEUy
	Hw1XBW+vIrIENGj4RSauKnjmHSC0Fli0lO5+PoOyoLlY4H25GwfBKqC1IbQkU8A15iWbx8
	HlE/b3maMUPCmlXbKFyICtfoassBPV4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=sHJJSBlK;
	spf=pass (imf15.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772571827; a=rsa-sha256;
	cv=none;
	b=dCeFsx7lSHBIXUj6bFqtsNux7XWrRkTR+oMZww6kI1Jszfup+iyHfv25Fpy48C9Tx5v92q
	JzGOGtLc9Z97xvw2Cd+AwhlhF6eCyx3zL4sxupySjx2HMsrBuAIn9FuVdicmoT6gxiyN9B
	59WhlhA1L0PV0XDukAMPUM/Usi4c6zs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=S4rybKDMoyY2IHTBJRDgn2ftLBqB7p9GFO8FxLdaHZQ=;
	t=1772571827; x=1773781427; b=sHJJSBlK+JYT72qt2LvkQQUhbfIeI9oJ752tLPGBQrJby8X
	LeqEkjqQI3Yvhd7r/lAMBOQpiupqxQEoo9ElzARvkJmflkmptCBzRHofw9GoUYntJl0AXhh9SviJI
	iHOQqmptxXsjSESTE+Cr/dI6Hr54rUYtqWW40FDYXGplzw8FTf5NnUXzXDoAGfZ1mtFTIC1qP5fhw
	0B9ZgAJh0FQ331SACb1djkH9MATNtylO07A1KC/A3KxpurkpQSAWipWsteGcaCeo8HxPH8LiebsUa
	NfblmUemOLWdz5qW573nXrtkhn6wgKq/F+bsegatOcs+on5YH1mCPVIpjDiZwibA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxWu7-00000007KeR-3L26;
	Tue, 03 Mar 2026 22:03:44 +0100
Message-ID: <76682f4db2c378774fa8eefaff497570ec904cc1.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>, linux-wireless
	 <linux-wireless@vger.kernel.org>, "Korenblit, Miriam Rachel"
	 <miriam.rachel.korenblit@intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2026 22:03:43 +0100
In-Reply-To: <aadKDCKGHk1Ua-7_@slm.duckdns.org>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
	 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
	 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
	 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
	 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
	 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
	 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Queue-Id: 2D012A000E
X-Stat-Signature: 778z6ntxooufgh6xornjyb3odyo1j4x1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772571826-801159
X-HE-Meta: U2FsdGVkX18kUv/XfofDwQK7JUYBclKWLYWqknT2j24bb0fVwHIPoD3PlF2+IqJraARkAREwVPSaCVxaky8/D6DiRiwaheI9Bzizy+SX9UH5zxMz7MUJKm7zR+Gdo92tUbaE4tr3LiWX8MLCFzLDn4WVaJvlnMF9f7azscJt3WbKJrrRXH4y5iM3Y8c+LTBML5iG3Pvq+jpv6qoFb3HMnFoUcjKi+NTq9JKAoMazjH8lx0XXRpI0H5RGAvo7AgmFyVydepLBfY1UNv7eduyBC26ZY7MrqjbCRgnAfMwxmyavbiYEMnYwxYH8t7HUxZPEMK9deb9TPnYLF7EKcS+hsbdK9oKEYLSLW9E5P0NNHc1pIiLI4/cNqKAZyyiYd6qEEum5/XEiDKrL3OkhmaVX0l/69MvLpHYznd0Bx7zVeroOq9OJOJautONMV31SQoPlxjX5qutRe1zXvOZ06Kl1o9SlyvJbCXbYyjPcz2zw88+DV1t2V2WZrx3K7vD2wyhb/gZgrcKIFKE8vBXrGSn62CMzReYPJoK8GUMLYNvy/rYCfqgSyDDO/6HNfwSwLKWolILELC4XcCRHrEGT/YSphBrLcFKzrygddhlh2ZupP7xgGcBChqu9UGfpR4D6qHSvlhiYvgwNwT+mDGlz26+9e+mtT3RKazSgPtEj11OUggHsZoNPqgTjHx5Zk2wsk3X5o+jkWgw6JypEQEfguiNBdnPpeJp+CdP0o9bcjSDN2KqMOtYxR0ChhXAvZS5DNdUoUKEyUh3ZvmkNH08AOMwWBNvTD10z/fPx+s3KJNFj6fitrz9UaHpTc22uuiMTjGxC3BPsWnbLYg1E3hgwjpj9fVea18+4jnI2+99p7Ja7KuU8y0+RxYYv0Xa0497hd02PqCdBmKOCzuHKQzEhuBXjWDM4JPK0WMrOIX3Mby+bodrOwMJKpmFvIKvvZjtAAHaMTJ3he/wXgHI+GxC0yvM
 aREuNbWi
 JzWYksnLTXmhInfgHqS/My/HwXljil4pGmrXPBkCaizZj673QuqTVpywKnALIcdQv72nYR8f+g/87uwNx5wWhxKjeAqW7Um4kL9FltI0vwWK+cdl/O6MNpszLhK1mEIcwK+yuKbRiojm/4QtavcUZZFXeb9nHVE1ehVcC6bNdiHW2yVK7ncqCNXWBdiHPv4M9phAT88k84ZFfni+A+gW34Biiu8OABCZOY0Rk79aesAxpp28zaDutyrU0JgNQmeJ5G5Uonigxii9ZV7gC7xoG9tYVZtK2WAcFX4K2/avtPGsEmBgu00oe8HTpN/wZkyiSk/Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 10:52 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Tue, Mar 03, 2026 at 12:49:24PM +0100, Johannes Berg wrote:
> > Fair. I don't know, I don't think there's anything that even shows that
> > there's a dependency between the two workqueues and the
> > "((wq_completion)events_unbound)" and "((wq_completion)events)", and
> > there would have to be for it to deadlock this way because of that?
> >=20
> > But one is mm_percpu_wq and the other is system_percpu_wq.
> >=20
> > Tejun, does the workqueue code somehow introduce a dependency between
> > different per-CPU workqueues that's not modelled in lockdep?
>=20
> Hopefully not. Kinda late to the party.

Yeah, sorry, should've included a link:
https://lore.kernel.org/linux-wireless/fa4e82ee-eb14-3930-c76c-f3bd59c5f258=
@candelatech.com/

> Why isn't mm_percpu_wq making
> forward progress? That should in all circumstances. What's the work item =
and
> kworker doing?

So it seems that first iwlwifi is holding the RTNL:

  ieee80211_open+0x62/0xe0 [mac80211]
  __dev_open+0x11a/0x2e0
  __dev_change_flags+0x1f8/0x280
  netif_change_flags+0x22/0x60
  do_setlink.isra.0+0xe57/0x11a0
  rtnl_newlink+0x7e8/0xb50

(last stack trace at the above link)
This stuff definitely happens with the RTNL held, although I didn't
check now which function actually acquires it in this stack.

Simultaneously the kworker/6:0 is stuck in reg_todo(), trying to acquire
the RTNL.

So far that seems fairly much normal. The kworker/6:0 running reg_todo()
is from net/wireless/reg.c, reg_work, scheduled to system_percpu_wq (by
simply schedule_work.)

Now iwlwifi is also trying to allocate coherent DMA memory (continuing
the stack trace), potentially a significant chunk for firmware loading:

  dma_direct_alloc+0x7b/0x250
  dma_alloc_attrs+0xa1/0x2a0
  _iwl_pcie_ctxt_info_dma_alloc_coherent+0x31/0xb0 [iwlwifi]
  iwl_pcie_ctxt_info_alloc_dma+0x20/0x50 [iwlwifi]
  iwl_pcie_init_fw_sec+0x2fc/0x380 [iwlwifi]
  iwl_pcie_ctxt_info_v2_alloc+0x19e/0x530 [iwlwifi]
  iwl_trans_pcie_gen2_start_fw+0x2e2/0x820 [iwlwifi]
  iwl_trans_start_fw+0x77/0x90 [iwlwifi]
  iwl_mld_load_fw_wait_alive+0x97/0x2c0 [iwlmld]
  iwl_mld_load_fw+0x91/0x240 [iwlmld]
  iwl_mld_start_fw+0x44/0x470 [iwlmld]
  iwl_mld_mac80211_start+0x3d/0x1b0 [iwlmld]
  drv_start+0x6f/0x1d0 [mac80211]
  ieee80211_do_open+0x2d6/0x960 [mac80211]
  ieee80211_open+0x62/0xe0 [mac80211]

This is fine, but then it gets into __flush_work() in
__lru_add_drain_all():

  __flush_work+0x34e/0x530
  __lru_add_drain_all+0x19b/0x220
  alloc_contig_range_noprof+0x1de/0x8a0
  __cma_alloc+0x1f1/0x6a0
  __dma_direct_alloc_pages.isra.0+0xcb/0x2f0
  dma_direct_alloc+0x7b/0x250

which is because __lru_add_drain_all() schedules a bunch of workers, one
for each CPU, onto the mm_percpu_wq and then waits for them.

Conceptually, I see nothing wrong with this, hence my question; Ben says
that the system stops making progress at this point.

johannes

