Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07CEEC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5506B0092; Thu, 23 Jul 2026 07:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065A06B0093; Thu, 23 Jul 2026 07:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0CA6B0095; Thu, 23 Jul 2026 07:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C184A6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:30:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4440D14045F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:30:41 +0000 (UTC)
X-FDA: 85019823882.27.32D8307
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3F4F180010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:30:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoUae43X;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC7L0HZBSSBFm17jYwEmeIieyNJcmoqfrgZhjSok9hg=;
	b=Yxb8mVWZM2R22Br4UWByUf0K8yAi/HAdVQWxeyMNRai8zH/mb8Q+fWQ+rDVL3anojdoGZX
	GYOLzctjD3W/ir5DCrhsZFU2PYnx39Y2GNEPETGAWnFFD01cKziPIOEl8qocG4jz+vdGvo
	45wi+koGeG2QjUAkSOpeYNeVIISvUz0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoUae43X;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806239;
	b=UQ14108AUbZlCRpZtMP0LJ2gOgafvECAffNbUquC9sAhxGwacWj5spmZYB3j5lJCMdAYvu
	dyq1XTqrD474urpWrXLzVtKmtGP1akxdJeqTPY9TyAvHUFgExscyhIK8MlvNv26LZFEY4a
	EcXu209tX8fyUS1BiETJAu9guivSICA=
Date: Thu, 23 Jul 2026 19:30:26 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZC7L0HZBSSBFm17jYwEmeIieyNJcmoqfrgZhjSok9hg=;
	b=GoUae43Xjonc4DcNTjzHA93JSBkg6hHt+SWUCUVrHOIKOQJm+eYyqzu26Z7Wd9C408DAuO
	7gwZOlFmYC2nYqR7H1enXuVZ/jEFOlHUet+5Ftg77v/C1ZbDuVbg0HLL7fGx4TwE937uM1
	JsdwSMgj86xisBjw4x8dsyZOk0xJ6mU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
Message-ID: <amH7RRa2lG51viwo@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F3F4F180010
X-Stat-Signature: wixduf8d5s9mrmny533bnqu16b5j1yuq
X-HE-Tag: 1784806238-635646
X-HE-Meta: U2FsdGVkX189EuuS3BLkQJTvwN4kFW8K7wQXxEim38HQBzY5CLLjqcTqiDDHbwZ2v7oClCuTINRdyTn2ZUBykfyjYgtQQrsEWa3PyRZpYXWLTqDe6dXXBo1eRrTYmtb3oqjp9JvTJblBF4HOpjyXPsaZxnN8PwhBuoL1tcclHKvMV9nz/KNgUxwLQAFArwVkOys6uJwhoyCjdwfaB9PgbGhSWn1nqKpY0zBLhdo36HVKX6vyTQYP6BU/SvQsfjFj8O+FGeh7Icl7OSoVcMuUCazNFcsn/le3FfPLoXuuRO8qkMFqsOqgmJlJxsQGHrFafvnBslNLEOMi5DOazY5XNrpOVJ60RUmPD6OUYwyYmznE8AB5Id4YhBN788iGRa9nVuGlsssOz6r10VTVynucPj3sGf8WswV49IUST7dqq2qCA/GSAX26Zk9iBRqfwB25xy3B2nwQSrvQD+KzTDUj15Qa74FI76/gChFvEJ0y7qrBDWw0O2hyBqofkCECn8yejmcjhTZlE2TDUQeaqoSt3bO3eWikBAS1ptxVXMRtHD0msqlqodwzbDdnHH2ytQAukR1f9u+pYQ9ip3v+pV0wVJuOhfvLfQvCBxClXATjVbSirEuCTanqHflbGsLunCGG4NNpY9YwlYbxDOS5X989KzmHw/D69USfd0m0vx+30EbxTe7UttyQpMUG4GBCnXQdWFN/suGGiaQkRCAWU6w4JkLjN6UsM7USQ9h1L3xoLDt7eBC/LsLcCofztTy/I3+nHOk6hFOUGMX8ZTSxc6g5lggggmE66LKFBuOCTqaPSvwnMQ1ZlKri0vDvrmmfN53kep7e1DGUDOduCaxamxdInoM2Kkp88ptikz2e/UOthdCmVBG/GeayyAtifjz9SA71v60llKKxw38vsGc42JrPn3Kh6S+dYY8AG/Oa4Utqh/e1B8ho0l65HtG5vRc4x2Ndll/m+1lYbsj9HaUF+3M
 neNXNznv
 92FKslTIBMsZ1vmhpuyKaA6kfdHVs4krvarEV5IcNR59VT9xbccq4vxSznj9rC6K29ZC0b1rUAQUMQJ4W9eqLpMHzKSQUX2tY+DWqheOAVvushNY5Pg3do/ggEM7hsZze0BuGg4LoiD6xMl5qH8KDNfW+nSvaaknBVx0WWY2pTjiFpCSE/2EqvzvnAhoV4VOqkUx/Pm9ELhnIZFDj28+SidDc92K7vB1TWWVHdbwm/JGQt5YoZCPenC3HNDLGz0bIuRUe5qcrK5SiSZJFlD60EBtVeEMeKZBRNc/le3bjE0NayJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:19PM +0200, Vlastimil Babka (SUSE) wrote:
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

