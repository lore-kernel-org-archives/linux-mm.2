Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6D9CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AEC8E0003; Mon, 29 Sep 2025 07:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBF78E0002; Mon, 29 Sep 2025 07:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2218E0003; Mon, 29 Sep 2025 07:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE0D88E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:09:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 960E758766
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:09:01 +0000 (UTC)
X-FDA: 83942015682.09.CD63851
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf14.hostedemail.com (Postfix) with ESMTP id A532210000F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:08:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=BFr9qwPG;
	spf=pass (imf14.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759144140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIkbgwB61F3CFgvTxKLtgC2iQ5qBPi72OUA4jDc13Rs=;
	b=tAOeBegbT+SjOjaBn849UkGDDD46u9pzK7QUMhEP64XSr5rb6PHmcRCiwWD0CaOnmQa95P
	foca0/TABNXW8Yx5/I/aBnzRLwMa9fpg8EVort/siEuJDASY7v49cUb7kAMl85XwEpcOlw
	fmURaZrmR/CoTBY4pokZ+WNfJPqEQN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759144140; a=rsa-sha256;
	cv=none;
	b=k/+VgPdcMswlAmXAmZ2naiNiJbvMZuaiZHUg4SEuW4lVMXpP/5CE9Owx0hguDw2oqy9+rk
	weWscWAu8nNOXYNNlyyxfoSNpKl4joghIuyTs9akApBtLaTTKhDlKte/8h70ivGRv4U3Iz
	y7a7cq0PTSy4pUxuAIM4pp4MFOs/s0s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=BFr9qwPG;
	spf=pass (imf14.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4cZz2t71STz9v83;
	Mon, 29 Sep 2025 13:08:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1759144135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HIkbgwB61F3CFgvTxKLtgC2iQ5qBPi72OUA4jDc13Rs=;
	b=BFr9qwPGCVOcL5z8nMNsXDm3b1xc5f1vVoE+XByhUj9zv+ygRPS6k4UYgDoAB9RRo/Xv2T
	PUXOs6ILjNZQjoOajat8A+E6ycbrJaLlImyN7HFpbS4Ui8YgettdYjxtk2GsAQuMEnz+wF
	9Ib6tB41iGYeoMDRnJMmyHyn5oL+jpZ6JxCAc3IhMw+U+Vk+GBnJtAkWIwm+ayy9BNiNDq
	0Jl4qA/7DndQ2g78RRRdWy1YS1hdfBtXlLYwfTxn78gfSf20oZFlY3hQ9pPBSEtsepgSSF
	RbiWrd8SVNx5bERD1Va1zIzi/pkRNd31hHSjsv+JMYlb3kR2WcmCTTfpm9oF9w==
Date: Mon, 29 Sep 2025 13:08:47 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Message-ID: <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
X-Rspamd-Queue-Id: A532210000F
X-Stat-Signature: 8wszeuntzrn1hxwnnfz4up9ppkd5f63i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759144139-422705
X-HE-Meta: U2FsdGVkX1/IXl5wR/ePtGdKzGuCdbZ0dI7ZzHL71P29CGA2EvvlWOT1oZBRr6tI2fN4c+L+n0YFi9Yb/xo2N97rK4V0m1UM0Hdq3tpt5J1u2mqdnaOUrM9aTaCzX3CCdWegCme62mGfGEOz5JxA47/nyiLez6ahH00kLq/iyCC4ynZPKVhLV98JXydrsfbBT0DXHAorRY5gm0wBe9Pf9w1YFZp0tOajISrC4jq4APfAAzPCpW9iHIUDAfjgfLnaMegC09dlp1cNrfxFCxiiSeiv6ujV8znS/y120CHAyHo1OkLBeHfUuQNozE1NIwaStjgnMn+Y//Jf7YlLquof+hMkjMcklhjqUreNnL55BKvBg88eXohLy0J1YH9gu8YKKmf09ZNv4PPRJO3u5JxqNT0gmt31DmY7PffbNyxAEIVJVqyNEq0jTFshc1QdSnn7XqEtYsA5SyJeV09LQ392+zW99MSgnvExw2WHiTAZpnrdmn6tt+AEefLCYruez4cOGh7Ti7GQt8LzmXEm7DC7feJdoSKpyL0i99mDL+QijrU7c4SbD5o1NPNT1Z8hkCrrt34ffC0U3i37OO2vI2A3ewbZhYdF6ZVK8W9bJsihhLnxvRs1rQek6r9r80xVWR+MfoxsiQqVrTjQKrd25VplQGjjfUIYigMm7pa3vdXTw1iDUOwhBal9xgRHp1q2U+34/dlApoOra1abU3I2eMBiXLCYxdeonc8GARml+2Nzfnkh/iEnKzDoq8cNDCqoX0uUwewlKi+9VvXIFlJWBPSWY93nCbHz5nukNYzPSC7+JAC16GN07jGS9CzNX+/U0DOm0bGfc3ONDAQgoqFwavB+fWIrwVQI8UGn5bl2noEfX13jQkMmwDOYwAVirLIqbof38IyUnLcUckJB/f8QxVrlUtvzTH4MtUyqCkHpcii/HEUi3F5Q9AgEyqNk/C/r4lWJ3AHqwAzUipusmZHKbaH
 bo4/UPkn
 YIESX1mj3doVxXPbzhseH+bzQyVOjUuhj3cjU3XUdONyfVKgsEeWm9u5OIVigtPFEHrSgoOSGszMt/8aAxSxpZB5loNQFsTD2uBOqjEiNOI8riALa6AvuH4JGX9p05elaaqrnI7ujuAEnfia3lND0uRwXkuThgsX3wiPsv7iFR2EYUl2hmMlzeEtFCOKpBMgkyJd1m8DPP/t35amV4CgRHZtM1qHwWQCxTyvwDJ+UHhtRAaFGB1z61yEvPM1ltj9C84UiEiHlX43S63oDhRtx/nRwXWE/sF4LVFMieSZzcB8ujqaWksQjhArPY5KDP0Bp2VVd1gUQocMB3cqkUD1U559w3L8s4ef9tEl/jLBaiSShR5qyUmnRuqx2FGwpOEqDlW5rEWzlaRctx9/PnTCsZpgEMAItQQK6YgaCSWzaXWep7nhHKUune95IPepefw48RuFTSnIjeHDaBlPopmigq45rYnBXVOqTcL8KCDc6JGfKZ4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> I want to change all the split functions in huge_mm.h and provide
> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
> 
> Something like below:
> 
> 1. no split function will change the given order;
> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
> is smaller than mapping_min_folio_order().
> 
> In this way, for an LBS folio that cannot be split to order 0, split
> functions will return -EINVAL to tell caller that the folio cannot
> be split. The caller is supposed to handle the split failure.

IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
function if new_order < min_order like this:
...
		min_order = mapping_min_folio_order(folio->mapping);
		if (new_order < min_order) {
-			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
-				     min_order);
			ret = -EINVAL;
			goto out;
		}
...
> 
> WDYT?
> 
I think it should be fine as along as we return an error if someone is
trying to split < min_order for file-backed folios.

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc985..e15c3ca07e33 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -387,34 +387,16 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>   * Return: 0: split is successful, otherwise split failed.
>   */
>  static inline int try_folio_split(struct folio *folio, struct page *page,
> -		struct list_head *list)
> +		struct list_head *list, unsigned int order)
>  {
-- 
Pankaj

