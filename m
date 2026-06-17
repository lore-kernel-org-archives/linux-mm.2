Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDD3CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 19:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0666B0005; Wed, 17 Jun 2026 15:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0719D6B0088; Wed, 17 Jun 2026 15:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC746B008C; Wed, 17 Jun 2026 15:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C77786B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:00:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DCED1664DE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:00:49 +0000 (UTC)
X-FDA: 84890321418.02.88329EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73EC2160023
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NlGZSzs/";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781722847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztkkIPmg9U+YA/yLFAokmrecB+uGWFUWKvG1CC+VtcQ=;
	b=cqkXVnirTidunfplSf+josducWOwMwW0BrhVsEH5BJbmi/M6c9pA4X8o5gpVmqtYd5CqcD
	mF4nbTPLGqiK4+HQuQGHU/6NjtO2V7BImpTpRr+gpsDt5Pf3niblzkDZ5YV5FD7varkfQd
	jSJMH3oU8WXpeW1txql51guRZakRyNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781722847;
	b=Lt1lNbZL717gmm4Jeg+j7GtliiWUc4L8bu6iPjpzkY05tg0qRqHke2oMW6mpePELpAOWdQ
	dzaiPZyiyUZ/Z3gEfacwpxSb1sJU9WBEdQn5QB3GNnUGM8RxFELJKTsZvA8Q0uAnHeT113
	D31rig0Qp8nyV1vt2mA7BYil5lQ/4Vc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NlGZSzs/";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF3A16001D;
	Wed, 17 Jun 2026 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A901F000E9;
	Wed, 17 Jun 2026 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781722846;
	bh=ztkkIPmg9U+YA/yLFAokmrecB+uGWFUWKvG1CC+VtcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NlGZSzs/gjXRpoS8cRAEp1qvHOvKXm57Xwd+WjSh1mksdHHhasQJmBYSpkHquvZxI
	 iBczxb6BlR85sfINTRuz3WqEo4Xrfx+zTFBO+lsV2+aHxvDsb9X1NDWVZ/O6Ha2QX4
	 YF7JdeVoO4fOK9uGEO+rtzsGc3kIg78Tqk2xZmTvFJu9xySYA6BHC8D42OdHeYQbYC
	 wBoZM4NECr8iTylm62lwf/QUY793pls70cfJPaVLdci14RLQy4alTmOhWkxSCkU2Ck
	 AvLFWWnwkkwz3uJTET1QKF0Mo/wlkZAyOMeMqub+oNkn98sPzhYO75M3dv8ZJkNfMo
	 q1nIqyLI2sYDw==
Date: Wed, 17 Jun 2026 22:00:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, tarunsahu@google.com,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/1] liveupdate: Add internal APIs for file preservation
Message-ID: <ajLu1-CnJfgD5Ch2@kernel.org>
References: <20260613012521.835490-1-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613012521.835490-1-skhawaja@google.com>
X-Rspamd-Queue-Id: 73EC2160023
X-Rspam-User: 
X-Stat-Signature: n41h38y67k4apjf6u58cttu87oo6wze9
X-Rspamd-Server: rspam08
X-HE-Tag: 1781722847-541719
X-HE-Meta: U2FsdGVkX197j+X1bi9ux0gb87ew+a0u6DTwuMaNJRthoWQW5iP2sx285+pcfr9X/P9dDQAtH5FPHoke+QSf6fMXy0QoioKHKNULFjGoCRM0nxQwLkz4JPhuTafmTHIYcnzA0MHGIAofKoq8JNki7tPyVSd+xuwWWJLxqdW03Ms7WCC3/3n1jQBm0BaebBYfO2nxPftTDXij4RFcVDWPq/Cat8riNRBMfkKlBn+q+JEPzdSEoa0y2L2Az0knrg9lSnMXL/11zhDpuF3HjcQdNOQURfA88eqHmo6TRrgQw4kdG7QG/3Z+0TftWidrNibLWaXxYcN4CQrx2d4rWYpH0y1X8sFB8B7L9DLq+6y8HTo3FVOHC4hUFygzutMimJ/wd7ziDT2JjQfiViYwZ8SqbpTKZC3Ig7/606q0ovI7Q16QkTFE+KtLCTdxyGUbZb61a8rnjkNGxZo578LhhZsNnE4IysbgE01WggsEBWyFuGqOINGR2kSMoZdWOOIFbLbGxcQn0ToupTduxxLiUWouhTo4y7r6m0CEQkruMbmMZRddgiJLqXrQ21+epRBR4HLh1mkpesOtu8HxZovaDDsz0uEpV2qmjtMdjiIr4vIp8b9l2UGuATTm19KIAQC6wQOpD0yTVDhLUe0jqhB5cXlkX3RnZ+gkcRMhaxrxElTu3EqBe0Z18YK7QOIJCZWsHOsrzIb18fIDzR2dm0c440cDpd+yeZd04OwyqOyIf5Slu4v1/MHe8YSLtaoDkNCtx08X/tUf/J4wVu2+V8O6tv2fiPs4xdj/+TkjcuDeLxoH1QGp++uRvB7OBvBVIbT/VEuKtx+TJW2T1yhg+qWggHbM3vX1A/BrCNfxTiph70sIP/BeH5/W5qeKs/hpB39YdB/vEcS3mSkEeo28tUClP1+4fpX2q3EvTBnwhfCgc+l25jc6KJBVDvS7Bb3CR9CztUguiiSiEP9QfwbcArDVR7O
 b0j4ei2d
 zrNhIV/wCN3pL2eLcDtGrUWskUzFnG2kbxZYzDuHVA9nBq5aWIUEU6k6hkbVoamMplEQ/39EPCKZWDxbBPkDqQ3nZaRunEsvv7C97ebCIZz42ywG+lIDm68XYdrmeEsyCxv4HLuNv6aCZ59kcujTac34W1HzdkLpfO2tgWjxZfdZFvgwrs7c2brT24jEeGCtfnD6vyZ292R8pkyHO18RW+snYGAmNTMpPQgUHebf5QG5QDSXF6i2E1SRSrmFETGaVy1P9s1TMruHy+iO2iDJFNlssuL0Y0Sa8IrIHQQuu9vkESGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

On Sat, Jun 13, 2026 at 01:25:19AM +0000, Samiullah Khawaja wrote:
> Live update orchestrator file handlers depend on the preservation of
> other files. To make sure that the dependency is preserved, the file
> handlers needs to fetch the preservation token of the preserved
> dependency. Similarly during restore, a file handler wants to fetch the
> restored file of the dependency.

This will have to wait until -rc1 is out.
I'm thinking about taking it to a branch in the liveupdate tree and keeping
there until a patchset that uses it, be it iommu or kvm matures.
 
> There are two known usecases of this,
> 
> - VFIO-Cdev preservation requires the preservation of iommufd. This is
>   required by the IOMMU preservation series:
>   https://lore.kernel.org/all/20260427175633.1978233-1-skhawaja@google.com/
> - guest_memfd preservation requires the preservation of kvmfd. This is
>   required by the guest_memfd preservation series:
>   https://lore.kernel.org/all/20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com/

-- 
Sincerely yours,
Mike.

