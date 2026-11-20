Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646A6606A689
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5813D6B05B1; Fri, 20 Nov 2026 17:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532346B05B2; Fri, 20 Nov 2026 17:11:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448346B05B3; Fri, 20 Nov 2026 17:11:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED3D6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:11:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9CAD1201D2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:11:49 +0000 (UTC)
X-FDA: 85456895538.24.CB3E5AC
Received: from duck.ash.relay.mailchannels.net (duck.ash.relay.mailchannels.net [23.83.222.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50853100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:11:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of brad@sim.vu designates 23.83.222.52 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795212707;
	b=Gu791Sz0v9xO/ap/tZJE2UQY74yp9Lrm/FNHDlnQ9l6E7HaOIjBW25kXgCdsiUQcWLXaG7
	d4VWL/32NgFAYHx13uu2k+dWFUzhAI3Fd2xVut+SWPVrz8RR7xJKAKxEByRqc5Z0eSWYlz
	dIU+7YGxuFj4vjUTSn70vgttdaTloFQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795212707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rKVf6ttBdg2358vkOqv7ac/lYV/aaVb7s4OgevPw/8=;
	b=mqMxd8nvqVJa2En3NKn0t8sDLlDVBwbsRSnwiiR4995xtkrZKhM0svwNRXNbqeEbOhhvmb
	wlAh+QRMC1omYNV6iRfXFPym2FHQHQrHk29CLA/tJmGN5TYakD132W4j6UQ8lpj//pEUs4
	D4G08JdQqGabLNcijc8ZHxfPfAxfJio=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of brad@sim.vu designates 23.83.222.52 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 71BD6402F7F;
	Fri, 20 Nov 2026 22:11:45 +0000 (UTC)
Received: from cpanel-010-lon.hostingww.com (100-97-189-66.trex-nlb.outbound.svc.cluster.local [100.97.189.66])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 59BCB402669;
	Fri, 20 Nov 2026 22:11:44 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|brad@sim.vu
X-MailChannels-Auth-Id: instrampxe0y3a
X-Share-Shoe: 4113ff934c443ded_1795212705249_2034403327
X-MC-Loop-Signature: 1795212705249:526485650
X-MC-Ingress-Time: 1795212705249
Received: from cpanel-010-lon.hostingww.com (cpanel-010-lon.hostingww.com
 [18.130.191.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.189.66 (trex/8.0.2);
	Fri, 20 Nov 2026 22:11:45 +0000
Received: from 162-195-230-196.lightspeed.wchtks.sbcglobal.net ([162.195.230.196]:47196 helo=epyc.attlocal.net)
	by cpanel-010-lon.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <brad@sim.vu>)
	id 1xUWpZ-0000000GDGC-35ex;
	Fri, 20 Nov 2026 22:11:41 +0000
From: Brad Hawthorne <brad@sim.vu>
To: thehajime@gmail.com
Cc: Brad Hawthorne <brad@sim.vu>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] mm: nommu: fix do_mremap() to correctly update internal states
Date: Fri, 20 Nov 2026 16:10:00 -0600
Message-ID: <20261120221021.789792-1-brad@sim.vu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <m21pc0qquc.wl-thehajime@gmail.com>
References: <m21pc0qquc.wl-thehajime@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: brad@sim.vu
X-Stat-Signature: 799ct36cuopook5xho7hcx1pkbbc8k9x
X-Rspamd-Queue-Id: 50853100003
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795212706-665266
X-HE-Meta: U2FsdGVkX19fmdJrBFLc8jdY1KPB1b68PmLAXsQjuz6gfRc48hmlx0WZzK/4tVZIt84r7m2mkglkNoW7EHEWZ5FDGv/i1MnJT/l5UOjNSXIiG13rdys6QeolFyfwnOskD/NynkVyu/dqoBXs3yTmrBvnME7UanFn9sWyD5HgXlDRzFHHo7JqWDrW9Jl09RJi0bs38di13IKlVNs2xGdXgDt1rdBhWgskNoS3WbRSqSqKJQL/NFYwrWaowPNkAi0GVD8mAjI2HPCBfnxV4wyQ0W5RvVj09PfP4UE8qFuoT1p44159AjPluHa81lraJcO8gOrp1UypGP85FBD3ZT7+wVzSNqPCRAolB/JvH3wzqcMvyVLKCRg+imbWiC/8RBr2X84Rqxm0vIUvGt9e8Z0kIDSbihC/LyfmJhi3cMLixx4Nz0qBEpqhe5jGQ4Br5h0waxyWkIcJQDN4mG8XU61hElIDKctzU+TeCZMWaWeH33xELHvjAAwRBmYQJ25knMztYsLD3teQpS3kuyWmQN5OFruKZ0hyQekeTfFL/WyRAqbjBO0ua7CLhQBO3BraLNHUzniR7GvnOfiZcR4iepSY1EFG6I8VoXSEQp1RbsJ+u4AXBIzoRjImqcn5jbzlpu596ZNl7EW8lxfp9TOz2OPMWBIjegfrB3uFeViwiSWlg+h4iCnpNceJh70NVJq9PAZplF05YUBdSZ3wAnwhq2M5ckphAfwHgVl0XBDGI3supoY7iwiE7o+4BOdl/V384GFPOjUPIqw1eedo9NdA0+X2ZEIHJ78VYaVpEfj3drjTkLcEw6RUyw2H0WePCwgolCPTnjh/xftNWJwtGPV7QJystveurk/0Q4jOgXi8Li2f2Su0SoGFfdje759w4gqXofBOXvhpFZR5gZN3BWZY2JLDywHO0503U/cckY+DDi66+BTS5lhwnU0Whuf0f20y/sr7kmlq+vugtKxDbaoeZkr
 RhBT8Zg6
 IFwM8SBKePu+PGSzhx/7emFWzYRqtbpyr24dVqUZwPxoVPnHs3rmCq2U9AcvRwbquVOUGgJkFOE0sA2YFRHh2u3oSEikUkAZp/cKuSduuGx5+Ff2RufrtUkWv+1q5LWeY1tWOsj639LQunglKQXHaPrHoH+knvblLZD+pPFaMtYIJ4s8OBrpY97ThaN8MfDar258EQykyL/x+RAc6eXlypg1KFl8Rcc2Vg+p7loJD4/w5fiOANAarJQHItiKg9rJmtf5khtFJMU+EMmSnKz0a3ipFwpsyp7TGwzyQ925OI6lo7pgprlS7m9UhdQ/jU9gWOipoxX1cleAXS/vRd0yBt3xII/vp7d8t56g99yNNzmmG74o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hajime,

I hit the do_mremap() stale range on an Adafruit Fruit Jam board
(RP2350, Cortex-M33) running 7.3.1; the code is unchanged in 7.3.4
and in 7.3.5, the current stable release. I reproduced its
consequence under QEMU mps2-an385 on today's mm-unstable: an
unprivileged mmap() of 8 pages, mremap() to 4, munmap() and exit
gives SLUB "Object already free" from exit_mmap(). On the board the
next exec then faults the kernel; with the patch applied to the same
kernel it runs on (11 of 11 runs).

Following Lorenzo's request for a minimal fix-only patch, I have one
that only keeps the maple tree in step: it clears the given-up range on
a shrink and stores the VMA over its new extent on a grow, with
Fixes: 524e00b36e8c and Cc: stable. It leaves the i_mmap tree, the
region's pages and the rest of your series alone.

I don't want to step on your rework. Would you rather carry it in your
series, or shall I send it as a separate patch with you on Cc? Either
is fine by me, and I'm glad to test whatever you post on the board.

Thanks,
Brad

