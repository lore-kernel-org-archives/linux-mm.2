Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE2EF013FA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD49C6B03A5; Mon, 16 Mar 2026 17:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B823E6B03A6; Mon, 16 Mar 2026 17:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84556B03A7; Mon, 16 Mar 2026 17:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9783B6B03A5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:33:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ED1FB9F1E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:33:43 +0000 (UTC)
X-FDA: 84553228326.06.0EFDDDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C279F140006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:33:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRe8VUAy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773696821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAs9Y2nhMoTEeHn+Me5KKXbtIk5eY1ciU1vfQEHijSA=;
	b=ooXDi6GV3XbfmEbjWBzX9IoSQN1zu6XPDEAN1Jwivv94p3Et5jvL+4BhqPU/M1cPTZU2kP
	AkcHO/El9ZJZ47FkhkR1ucD1zPHBtfNsXg5sTjhaQk1Fkhk2vmSMoSbsYmJIRAkAreIxKX
	xkrG8IHO7qgHB7m7Bh4pUz7pnCBokUs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRe8VUAy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773696821; a=rsa-sha256;
	cv=none;
	b=M5uuotiT+JWAkFSk/ifr/CdmCSStzpvIMADbZ9pq8ymk86wxn6m0f4tqQFJi9adySLvWqH
	ubIoLpIbRqwxjcrJ5/ab/mRbT3XMbCjaklelI+7vRemLvknMwu83h7tetCze9Rl4NAIjwZ
	pAItyXtaSLhWc02x3EyLuShwxhDPkAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C523444153;
	Mon, 16 Mar 2026 21:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FF4C19421;
	Mon, 16 Mar 2026 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773696820;
	bh=aAs9Y2nhMoTEeHn+Me5KKXbtIk5eY1ciU1vfQEHijSA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sRe8VUAyVhrDv8sNPidGxpnUGH+ijJfryV3cY+T8RR0YN75wGsUIeuA5cDVWB2P1W
	 fXM2NZqdVYXe6GIleClpjBOva0kX4XYNPHQepDCVFvNlR6L2SJFh/k8fpXlwa02pUZ
	 BEg4AnTDqsMpcc/BPSJEmytOZPdvHoZNjhVphY/E=
Date: Mon, 16 Mar 2026 14:33:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts
 <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 00/16] mm: expand mmap_prepare functionality and
 usage
Message-Id: <20260316143338.c440e11f8b8de5ffc8c839b8@linux-foundation.org>
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C279F140006
X-Stat-Signature: 6qpeimhkyhd94chfnmffii6fmz3xfxii
X-Rspam-User: 
X-HE-Tag: 1773696821-841725
X-HE-Meta: U2FsdGVkX1+CzQfcCyeiRJBgBtZ8NX3oTz1BhABQxHxS/R7ZCws66Qqn4POaGRXGphEwnbTNw8xFdPW2cIFU/2jJ6pbOuYZaEbl0Jo50Ff4580fpgL2/fq3KSZpB3Kr+W4ugOMXJ7P++u/sQC5nU2OpitffgrNljqfGNg/35Hw+VJgpPFEh2Y/xxJOeI09klYoPGRm4z/701mnUbn2Nx4FwA/9YgRZo5SHLH4UzpswjOBKysgYyCmBOfzLZgPZ2iTf5mbIZoSEfvOi59VSU5t7xH0n6f2mm6sg3+4sjOsEbBrL/Sh5ytG27igfFyKCrtktp4v5h1cOao48UGCzXAWFZwO5NkJciHEwm6GnJ5FM8iumXLNVd4avYwN6A4Uz3tCVir8mA8bthkrddzujSMSjM3Y+d0xzckXjM0WlgDcVCR44KFz75Z5q4GEBxeNul3hc4Ywue/2lcnAt5iU33tpoymu0iPiVYgHvDOvlBA1qlv6XdOKM0SAKOZhEL710A4GKrXX8oIeuoFzQc2rPhPMH38uoM1GfbGR+1h+kPNTjNlGe8bbuRTerO8G53uOdbk7g3dL7BG7Z+LoCYqjQqgCIMYxuhdrElRyBXbFwNPt/bnPKi2DByHuU0IpMdVbHpb+ZSWIGu82CCNT2uBLjD/tqNkdCDFK6puCSOef3uSyzFOju/71/LPbjwW78zZEUPPBsgYJBLqAbCqoEzDIXd0CEORy8I/QHiu4I6zDw1sTunUtwF1sURWxSYOVMCXv3PdFfoRYye0odqD/9eTWxwrzdnfTK+dtgq+M0tl9CX3J2MC6grh6ETzq7aQ1vkXPXewO5jXxHhfCrXfF4zdYo2eGdewEH3IKIKjhWn4XmGxZltMADTjt++lrT8ovQ7vJr26yRkds0lbvM3dxO3L4FL9XQRJqOuP5Ic8hlApXDq46ZBO5tdJ9X08rLkGfug7g2j1yyDRaSnl662UJoNfRDA
 VllXcaOd
 F6MlyJAApIEX5L+psf5e8rsR8gXIvTxZfR2ofbxCVU9v3yvvK/muzTB59D4qzpnhLubakI/zWZCiXE5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 21:11:56 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series expands the mmap_prepare functionality, which is intended to
> replace the deprecated f_op->mmap hook which has been the source of bugs
> and security issues for some time.

Easy merge, thanks, all added to mm.git's mm-new branch.



