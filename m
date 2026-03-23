Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA70F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C766B0088; Mon, 23 Mar 2026 18:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23CA6B0089; Mon, 23 Mar 2026 18:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60B56B008A; Mon, 23 Mar 2026 18:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B694D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:48:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86CECC3CEA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:48:37 +0000 (UTC)
X-FDA: 84578818674.24.7CA825D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5793140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:48:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PVZItuVD;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774306115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uKaMP+Ibx7p92a6i99bFFlc1nmqSfoNeCuhItTZxro=;
	b=Fgr1DwuOraBn2u2+Y6/9n38yBaADqRP0ohRRKnwlp4SIEqXPpu4/yMtFgAh9f1odZLkxsu
	twhf0PxFfNt+moTBP6yJasjpAH4B7wVYza/ZjBDxdWA7f4CStOa39/NIY6vjcQN3CAVgiu
	W/b6hljnAM47AUTLYJeN7QVLSalhRDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774306115; a=rsa-sha256;
	cv=none;
	b=OUHFmF4DgQl48nDpU2x42liGES4c1GvrCkiToz4ePoeUgOkuzU+FSWEE2X5lkkiXbL1JcF
	lkid/PS/YV5auP+xhxhXrEuPomGuo4kkVLSPs53X7oRqDNWucAo3JMWMKFZq+Eb81ToUJO
	B26mqFaPw7HRYZ0XX8ZKdRIRRul8vyc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PVZItuVD;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 796A94096B;
	Mon, 23 Mar 2026 22:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED89DC4CEF7;
	Mon, 23 Mar 2026 22:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774306114;
	bh=t7d8D7fNG06lhc+Rx8EzDPOazfquULF9R9S4mbUiDBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PVZItuVDgopVn2J4A2d1E3TrZyGCWXaGaJDCDogcMsKr0eCXZfOrAE2ZF8qmRxrM3
	 Jtl97GMhydx5AhborPlM56e4eHikwzgdDn4iLgD4PvGbiZC2/JvrgHbhRywUrJQgM5
	 BdRbxKw8wfBOE19jR9MwSmTVI4qGgcvqSDYcE244=
Date: Mon, 23 Mar 2026 15:48:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Pavel Machek <pavel@kernel.org>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 0/2] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by pinning swap device
Message-Id: <20260323154833.045b732a5865b11b5b4e539e@linux-foundation.org>
In-Reply-To: <20260323160822.1409904-1-youngjun.park@lge.com>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C5793140003
X-Stat-Signature: ooh6ggm4hjqj4qc7qo5bwk1wuk7yezoy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774306115-832213
X-HE-Meta: U2FsdGVkX19U6o6NzK1Z6WbTEemUbnxe+K2gaLpFohL5Ah3GV6IKCBJvsTqdrgeBB9q00pdgFEPiLPG3uqgYhop1hKhykpPO9ieaG6g3/x6BdO+N0Qg6mjwGsLTzWvCAIyWZJTDlPWUcoqBmHl2P1jyDDfy5UWi7P1vE4LqKR7ZQkqeZd9dTqluf4wTdoQGmj1/VoVW9yDWGc/2gDPwFtAmWeVjRAlMeT7xFjok1Rbm9+UTtQxGg/9cTbSmzHfD8TAxsHM2KoB31WC3A3ce4A0H7Sq67ig7+Dlv3cgKtMWhf6d2tIxoW6hD7JFASbyDx170DHNtmVPpU/9pZEFKdNkfgCkvKw7pMi6wfD9I8nSZfgAekrbTUsBqYV0k7HHpsLUjnWvNRtayWAowdfuy329qBYrmptWxKa9KQ/ne2p96/RkfjUMnN5NUvP14MNhZpel9AtsvLMgXpQ2rHP2esTT4kndE2Gn6/JLQn01R1Plq2i4js799wXnkjs3SPLErR05lbxheoRJMVNZxvet2SO3G+3GCShNrD6nH6eH56caqonjsSEto5R0AzH8+dX42n9iCta7Hy4uJCKN0yyU3JHoGYhPJ9QhXG+PQrv5Y3pPkP2RkV3md7JDA9+BTR7i/JCGmkTenCUthJkSJv1LTNxpCyrHTjnPL0qw6O6gKoPzj3JU5cajftMR1IMDUw6WoFlJTJtHq4X/i6grJP++VEEdOo+4biEodDYexfSxzl3r10/VLp1yypNy/D62pKgImSxvH5wgEUEAssoJ6/N81yFPo8ZpFZjjKEtMUsFjZgSOnbQBSoZTyDFnov9DZxkT9S8SgizjKXGlpUkMiLi8v69WCiRS7Mq4WJkT9TKDIIQjqDuL1YvG+4KJ/1y81bJU5uP6GWb27g0BwOxqKYO/q/cyjll6htnR51cEV5jt1qbabw7hvJkFwpH8S2BpUQ3U/X243BZah+Yq/RG++HD3v
 qWggVaxv
 l4brbV+5SslpOaaQpqEhRO/pP5n53OG004IUTffKQA7tr754yaa8OoWlWkfV+mrSkFTHtSFCQpUxCjgnAk93O/Wg3JEFC/n4Owi+CAyTEIc7lHe0BEmS+M8o0liJJtSwPQTT286OfuNBzu73kJe6jj6/EZXOiccIR3c4ZtAK71Ux4jFR54AqlDY+m32u4JKf3lab+aP2pJqQRqoVdYyWUALIJ3YQjAljvKI9eF15z/Upgn4oW1yy+w3jlgounnzt8nH+O7XJ29ATQmyRNNHaL5PNivg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 01:08:20 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Rebased onto mm-new per Andrew's suggestion [1]. The si->flags race
> flagged by AI review in v7 (between SWP_HIBERNATION and cont_lock in
> add_swap_count_continuation) and the proposed fixes discussed there
> (atomic ops for si->flags, or serializing with swap_lock) are all moot
> on mm-new since Kairui's series removed that code path entirely.
> kernel/power/ changes are small, so Andrew proposed carrying everything
> through mm-new.
> 
> Rafael, could you ack the PM-side changes?

Please.

We'll hit a conflict in linux-next and Mark will tell us and we can
flag that to Linus when merging into mainline, usual stuff.

Or we can park this until the next cycle, depends on how serious the
bug is.  How serious is the bug?

