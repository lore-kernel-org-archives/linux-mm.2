Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB2A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 04:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tGLPXVpU
Received: by kanga.kvack.org (Postfix)
	id 6A4F36B05EC; Mon, 23 Nov 2026 23:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D896B05ED; Mon, 23 Nov 2026 23:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BE36B05EE; Mon, 23 Nov 2026 23:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 073556B05EC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:56:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C24CBA882A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:47:40 +0000 (UTC)
X-FDA: 85468779480.12.948B6AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00D941C0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:47:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tGLPXVpU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795495659;
	b=rsiJJrqNcJAE/q53Qp170cML/R29paM0LBjWeY9x36iooDa2V7JPlDFQ+SlRzFP/aM+x/l
	ye8h09p2Q+msWWWiwEetHRs9be4IsxAsV2hxmKzFw2RIM+gUd1EsOAG+jbwYocey1qzlvR
	ITV9ICVZHprk1GgYUEtUsQFlAcY7IpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795495659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dBdLwXuvBtAqYO/mIODJrfHtm/S0fTflYlFI1FK4y8=;
	b=AYV66ufyX0xAH/RLobLaYbPnocPuTIr0OtKYoOXGZeO3Cy4NoC8h4NcVMwrLcFDNvr1OYA
	T9fqGiInDn55UjZCWHwg0sWh45zEaaT5o4jYiuTNVLBar7RRix7HzWxGBWlc0qilmGivji
	j7B8MQf1lgTCv4Qa02AQGIXM9X96nOs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tGLPXVpU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46415414B8;
	Tue, 24 Nov 2026 04:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988EF1F000C4;
	Tue, 24 Nov 2026 04:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795495656;
	bh=+dBdLwXuvBtAqYO/mIODJrfHtm/S0fTflYlFI1FK4y8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tGLPXVpUl4u42q9fk/8lONyEyXIDbABSX1gcBXlFmU1cRnnppM5YdDZBxeKnN5BAw
	 6ZIxpKyiKvlGJs8svY9SWtSGmv14lz8mGfSl6q9rcxXSUL2uYxU7dRw5Z146ywci5v
	 QASZSaFY70uEp3rlKcy9JWjIZnlMsV2wQOJDeBAo=
Date: Mon, 23 Nov 2026 20:47:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org
Subject: Re: + mm-gup-add-file_is_memfd_compatible-helper.patch added to
 mm-new branch
Message-Id: <20261123204736.666767fd39a681fd3d528d65@linux-foundation.org>
In-Reply-To: <20261124103431.427705-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
	<20261124013855.98B111F000C4@smtp.kernel.org>
	<20261124103431.427705-1-xujiahao@cmss.chinamobile.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00D941C0004
X-Stat-Signature: 3bbnd8amtfz4shbg88cskj4jpzctod1t
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795495658-739343
X-HE-Meta: U2FsdGVkX18BRCHmifSzuj/D1FONGW2eRg2vISsRkATJ4dxsRuG64MIMJC/LYMbJ1TehvfarcP1tOxz+07HVTssru5yiQwHeeaq5bGYR4IC65umpaAOOTq5++W59mENpii+TOQP7eMMB9QTKfljQVFTcE0cWfz1gfpL0iY1cxEIpHJedjH75+UKfm+FLstvXDESChx1FRBIOXcK8MUPw/vAw5E9DTJRcco9Jgs6LHkCguFlgdiXqV5ETt4HPDqpkxXYNs11ffmahNbKb6z3EL+3EATGIOmDaACTh6+nnRo6ZtAnZHyRnIRwj6s2SjoSzNJjzKq879Y59GeG8IbDhpLehFSriDBrx0BpNFeTGSKiaFpW70m6N9ign0vYECMtY6WCRv1XNa6rtMSwc3hD7CfjPn9HqU/M911EdmaxfjHYMAIEIE6W3jAesAc55HfQ4WTFLrkxPc5/iMIfjc0f3wsMxnxAcJi9U6UUsxM782NioHURh3jxQ8D2icTw3ciE6sCrqbw3jPjPf7sDRnRuJIIa9lhryk1SQpyo7wIrakhpLT2lgERAY7ltgs+1WswQDy42KJkpRS1untH0kqYSmWcoTrgxbk65h7VnB1ZhY+P4OVr9WKDgg+YqOn53XLvg1ZO2ImZjynGUvD0AZxLeJBfrb27TgJiYPfEtqsULBG9C6k/7W4+jDpg5/keOeXxScFNJPwe43wghWiezsQmXK1w4k5zNXRbRrSgRghXJfpreDhgBu8gRt4eZA8BAjd4lmtZCKC5o7cZnrxBzjEAvVTF2SvABm38g07xex0EaW1MxztQLfT8ZxEFYQrLgdN6x1dI/3/b7UqKownsC3FaN42fMZ6wAKy/SC6g1WCuR4gl0SCx2SnUpoFxATy5LVPP4tCQBbp9/Ar4aZ/dvt0le5s/vtlaR3YaCkP7bJizYupVnyoBK993M3BsGnvxZ+VwgkxgKP3z/G8pPW5xZSYNd
 vSTBIT3j
 aaSgV50AXUYH0Uw91Rw2Fiitn73D2PxgXb75Dz3jxr1fIgk7ML6QRlr5eage3PlbO8TZThfKT12jyk4mlrPD7K9NjmRxHFa4mNENqUsabi3p9uANrAmE1GHQ4YErRPWa6qdXw/82swPFceD8pZFA0htz3E/Rdy8G4lUQJukx42JlJcbOXA5bQVMNFw5f2l52DrHwhs8T8RS1d+Q5szSpz4aQolGqjYnS0YIwYobvAsZhv4bi9uO9tP/maWma6A6rXctTXVfn6giMZnxKh8UvSzUKLKwKuUwyINq6oD7HsiFo3zapcmy+3CIofxBlFU4QBiyIQ6dyMIxyds55sVqzUvSCe6300zB4nhaTYWLynObeolLmzPjF7wXU0joZMhZSrxkIam4HgCCblOr50IMXOsVpYgL3h09ZvL2WN/4+K0yzdhQJli/UkJLzUYr7mecbzKbIvtraWCxMIMaB227g/J11pIo6Jt93tKe08AdFK543PIcKPaS6gnKdK6oUj5JHnOiax6pzO01oeuVw9f9rFqSCOJQr+Dd07jiO/7EBQ1IWfGzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 10:34:31 +0800 Jiahao Xu <xujiahao@cmss.chinamobile.com> wrote:

> Hi Andrew,
> 
> Both patches of this series are already queued in Jason's iommufd tree:
> 
>   94494921b628 mm/gup: add file_is_memfd_compatible() helper
>   5b370585dc72 iommufd: only hold references to files memfd_pin_folios() can pin
> 
> in git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git for-next,
> committed 2026-11-20, with David's Acked-by and Samiullah's Reviewed-by.  The
> code added by the two patches in mm-new is identical to what I posted.
> 
> I am only flagging it so the series does not end up applied twice - please keep
> or drop it in mm-new as you and Jason prefer.  If it is dropped there the fix
> still reaches mainline through the iommufd tree, since Jason took both patches
> to keep his tree building (patch 2 needs the helper from patch 1).

yep, thanks.

Better 2 than 0 ;)

