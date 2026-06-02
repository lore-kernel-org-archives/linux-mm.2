Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F98CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855016B03F6; Tue,  2 Jun 2026 04:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE036B03F8; Tue,  2 Jun 2026 04:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B7F6B03FF; Tue,  2 Jun 2026 04:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD6E6B03F6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:13:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 086754080C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:52 +0000 (UTC)
X-FDA: 84834259104.06.7E89AA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66F0640003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKXzTPVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9masuDvZGRAE5YhO0nxFypjCa/sv5HXBG/vt0WeBSHY=;
	b=P+sNKwskMYMvKTCGen1EdxDPfUdrx+fhnEnUsCBQbZVu6fpAL5eyzhsaGX184V+uTNMOfV
	b5zF472dPM2aawPpov5roCCKf/PCbhwwATMkcf6XQSHYSDIqkyOlwOJhhSEZZOCXaJKsIN
	RaoJfFjUS6SA2Ewo94jDm7QQmWwqWj0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKXzTPVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388030;
	b=KixKuPD981YTLfoTSAey9JzaQH7dgsdZYnIguItThOwvW0RueEIiiS8k/QeJ/l6aDSukKY
	CMYTshz+0L0MxnjEgb61ih/3uy8kN/GZ1od2wWtgjuWIzIm3mKId7ragBuX8RreVRCZbyX
	230mgiERB7TkSq7RpQv1ua19vXs5O0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04FD160142;
	Tue,  2 Jun 2026 08:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856151F00893;
	Tue,  2 Jun 2026 08:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388029;
	bh=9masuDvZGRAE5YhO0nxFypjCa/sv5HXBG/vt0WeBSHY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=BKXzTPVeNI3EzsZztLA+Etdw4lE1OGP7XkpvZ37eeDEGaDydQwyq9IugNdZBmAYvs
	 FnqxLdkt/2eygj2ytRe1nnhKx+iBbgy9pHJ0KDBfSNyODINtGD+F1dpz5xpaS4QY70
	 dzhesbOX4O+UE04WBYEPnUNMMhUfwjmCBQvOBV++UUSG9fn57/q+2X1iZUv3GtfKzS
	 Cm7GMdTCvrapPt8AGMxEExKMmU4sl/gawXrebtYxnhRpE/TeHiZ+jxfXv9ny1a3v8S
	 6nFXBkwl0eHnofOmZYQ64h4A+zO0Mdu8DNmWNYP6M03PUMobTq2oOtcAlkY+j4vc2V
	 If0s6C+uH6NbQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 03/13] liveupdate: centralize state management into
 struct luo_ser
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260530221938.115978-4-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-4-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 11:13:34 +0300
Message-Id: <178038801487.119771.6308607614059754603.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66F0640003
X-Stat-Signature: o4f897oan9yibkj4zbbxpec99ssjxcof
X-Rspam-User: 
X-HE-Tag: 1780388030-618712
X-HE-Meta: U2FsdGVkX1/pGhesAy/K4P/guhVNVo7harMhfpLk/Pt/GDpRrM5Npi8/e5ltIuXgGUiY6WWl+GWc1EKkoT+lQAe86TeJkeX8S5/zkb36L+TmmJ3RvwfJO0TiZ4BDAFv/Pjq3Rax+09Y7OueHredjQHBVRDNjIOaSw4Pwrwvali8UKleDd5Y5Z3a7lzSHAvcEvrsBXm1m245iVfe8agd3l1l0yRzQq6WI/ZBqmW+ZeF60lpmepzmr0Lo5bjeAtQgsFb+a+yHfFD91kYvm4tQTjQzasCulLJoFlua5kJB86LVufyJU/i/3wR/QYGoZiSVicvGyy+wJhQcMu2IasISqLRr19L4+fM7CyeWQE6IfFL3nJ5mKRdG2HNp6bTOMbVn8tG8zcjyoTAiccQIQihDbFEH0FbVWGWo+49vsm0oiXTZ6p/+Esc2IQLmiudgX2l+SgT+kxT3tAo9f7pAXWSol7pu5Cp1yQ8CX9UCzH/hbw0yC9GjgbHb1wfxjWC1QMLrru1D1bvkuHYJyD+hGx6tpo6uCuizhVJq0dm0bVi7iOfbuqT9yVkvdirmzacVn2NI4xNr0pnDFdFnDaU2iYU9fabtUbuvoJPOvvP53M02EW0zXEhb8tU+GVxrGUfS3YGfJaaMpIOMneE28eAjJHrFWgqU2My5K+/zmTV+9Ch8JjwazU0h2f50yqs601YKnQ1+Pb4ZHu2bZIWAanMeByCazhpR0Kc5aJTWagSVOHgtrp/TDN8SMUTWAHp965RbpYXYjSSj2+fsdQN8uTHp3uBCpZ/kntiJoiov4Py16s8U9gy1CxmJODnJK4gYiLYH4kT76B5ZhHu+FWNJRRJdQRqfxsGhq+k+sIhlZWz576iQfszD0DjOXfpUfCUE338f3rDsuI4AC1ThiWHP+d3xazx/V3pic39QA7mIu5CQo+ASWlXlA99oF9R8kSzPtpfk49emlBS06quIOFRBNjAJ2EYM
 mG6U4gMq
 vnlkVMdKEwP+I/SucO6fDxq9TMkrTC2yRUGsGI+kh+ajynS+h24jR9E/+BfXwVGwRor8CXCHFGLIPbR4QUIsA5iM3AfN4EImUPtbZ51t99qT/DR8k9OLx2r1d6JdemKKDiH2ER+slXEPKSPFx8Qos2N6QzY3gTgx3MyHVc0Ei0nyjZyKL1jwHSCeaDoEIU7CcNVTt2TtranF2h5Tae2FlCd/p9L1cOsOkfwzgbNoPu9KAPajHKepRicCuk6W1QpcF3YhWwOqp9cix4gjGL0qnfJL1WX0kLKYUaaHR1l/S69+bu7+BwSU0y/VcNLc0Q/9tkRsB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 22:19:28 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index 8f5c5dd01cd0..c8dd30b41238 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -579,53 +565,18 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
> [ ... skip 18 lines ... ]
> -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
> -	if (offset < 0) {
> -		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
> -
> -		return -ENOENT;
> +	if (flbs_pa) {

I like 

	if (!flbs_pa)
		return;

more

>
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 8d9201c25412..3b760fefa7b9 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -497,75 +494,34 @@ int luo_session_retrieve(const char *name, struct file **filep)
> [ ... skip 58 lines ... ]
> +	if (sessions_pa) {
> +		header_ser = phys_to_virt(sessions_pa);
> +		luo_session_global.incoming.header_ser = header_ser;
> +		luo_session_global.incoming.ser = (void *)(header_ser + 1);
> +		luo_session_global.incoming.active = true;
>  	}

Ditto

-- 
Sincerely yours,
Mike.


