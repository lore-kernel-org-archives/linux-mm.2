Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9387BF34C54
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB6B6B0089; Mon, 13 Apr 2026 10:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3146B008A; Mon, 13 Apr 2026 10:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF606B0093; Mon, 13 Apr 2026 10:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA58B6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:02:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E8F256EDA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:02:21 +0000 (UTC)
X-FDA: 84653697282.11.6A908A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD15640020
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:02:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEan9QiV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776088939; a=rsa-sha256;
	cv=none;
	b=PwrqPM0OjFKyQMJo3ESIHo3I6MgdKYutQvMoVZAErSid7lLcQAHWG7OIxxJjjKt6lmv5GL
	7dcjGY5zgpw3ALFWMepVXHfbGAXdJTIT8BFdm/DqNup35VCi4IT+Tn+XxD8mzFgM9bEV9o
	9ehHxLm/lpXCyYxTc+tt5ipAAWsfuB8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEan9QiV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776088939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8T6Dw9NftUnSxGcHO5ibrBAJE+CebJPNtYC8nRk5pk=;
	b=pqcXMDri3tqay+B3dGS4jLkN6T+1Z2nJ8iK8GlDdRy8T3DRFsBiqmlRKOHxyZI8w4YzHIN
	9gimDg2rKT+R01NrIPIVMDZ+XBGS/gGcRZwXSFb4vHUPoIyw4gwlCpc1ZIGiI3hTH+dfus
	HI/92+nSW0TLlQuwy/ese8Zq4nRWoko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20AC161334;
	Mon, 13 Apr 2026 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E55C2BCAF;
	Mon, 13 Apr 2026 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776088938;
	bh=J8T6Dw9NftUnSxGcHO5ibrBAJE+CebJPNtYC8nRk5pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AEan9QiVkF11/pica1V//uavUJAxHURk/fNrhf3UJDdRX9JPHIySKLThL6kSQhGZ3
	 trvibNDdlVNJIksx0OS+AKn1EjpwXRdjWcoi4b6yN36RlD4pQ7bGMFzHDBgpavKd+D
	 1hamjYOUtE6h52r+6PvngIsmIWpf59C+AmQb8TpJn1xV3n2To5sTtK/OiEeRNX8oGr
	 GMRryoclRICNbN7OuW1Ioav8jzY6/GjnKXN3Fjg6r2wD8SNPpnXVEn+f4OVXnxx8sB
	 HvHi9yKQnO0LOSowMStisrHJcv5OHF4Enok3jCl2dXUgdLdR45CVLDuFDMIAJnx70d
	 n6ZDuCnEUS23A==
Date: Mon, 13 Apr 2026 15:02:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Message-ID: <adz3XI5vimbxDghN@lucifer>
References: <20260413105713.92625-1-ljs@kernel.org>
 <adzg2DWDWDR3DFJh@shinmob>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adzg2DWDWDR3DFJh@shinmob>
X-Stat-Signature: jgoef7usg5skc1zejy5yiasrqjwexjde
X-Rspamd-Queue-Id: AD15640020
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776088939-803680
X-HE-Meta: U2FsdGVkX1/teHpKt6II3Zgenkg4NHD5QovT4PH6CtYKXfh3LglxUwdCdaPt0d+8kAAhPQIzE9v99WUpGQDimcBVDUePZa8GmnUSjqg4WkTxqQgb0pwXZAbaDqaHdSaYEZiC7MP2EnP0v8PJd7xvKfvXQLsoWYbjBSvEIlxYeD/QokguxeQiO2RlWWqqycQiZblbdz6u/NgQIqxE85KX4/3cjOWH7utX2a9V5UUB3PT4XwmxhTtyN5Gk2B1MU1POD3nCTMegjOg502YOTSLFS+ksXiM0FaTaKo59BU5cExeBQbcYpNXU/3gOCz0RTL7/64c2MAdWOAm8jnUS5APDUPxTMfTlh7N1VKJv91fFTR0hXIBEJc0YDLIhQOMJV/PDR4labJgmA5c+NZp2Q+XjvSNn8+dTLOmAoi1yZT+g3TMkfj4rJMJLSRyhH2FWrxWdm2pE8CYslQAbFJGzyZ1KiijRdo24ybS+MBXsVPBcWmUgIe/k9w2yCqKo4HEDYytVygzMcKAzFGz90PkxJHYz15UrvqK1D3AnKjLWXpcPO2J2SdBLk/ocoZpPNstFCY0lfXZfNRzeRl8R7sw6o19KLwWp7l5TAN4kUbJQ3Qel1zBEXL83NCvkuYGPghR8Qhn0xmcuj+Tx1VYjQgAP63Vjn89JS1j9Y4J7lqx34elbLHTS3yu+FitzCJSRBX855SnqXnwWiklCRc94RdOpUheY17Ii4V5uXRfhmIa/ucZ9pEy7rW7tepzonWJ9psu+tY0Ig89ksY8wcg1XZdV4CHapYMy3tekImFQRCPp2WmVWoMi9l2wylXqT5/6oxS54bM6yVIiaI0oBcX5ttX+Ea++EJmudLF6yVKNzs4xW+NuNaAjXOcNIkQbrp3dtRtsl+5j4XZCct9rxHuTgszwvIsF2NhCu6fjHgM5LetkjK1wluT0gZm/FaPhqVV2t1QZfydx2aNiTSVZztBo/2+c8VuF
 oVpTNyFY
 r0GAIX1Upv2iF3KRPp/IsVAo43jYq8bJq0VzrdXnzhSbaQk3DrwZdxg9jt3CJwoQ1oQZ6IT/q0VDnUwETYZTsT+BnWYKsSjaRb8GKPhCe4/HhSTa2LB8Z+54woZSCRkeL6piWFILNnaWvPcIZ0bpss2svuJDh2AA8ofed+V0CV1DM6EV16RzA/od0sKNSPEItaq5xPkYYp3ja4G714TimyJ/Ekfi8MWVUglqnPCT2uH85DTxWjUIDRjwmeiPNqCV4j3CYxDdbPJUjOuUPCU8cbK3j4leES7hYj0BnsKEWbwJiagE4pTznx4h8qKYMuhejPjHQADXuB8tYljHeKd6X4sXYwaGenY9cPnKgmJuQDwOEUslwtF7sDBOmxkYZo4XaUbfEu9Q7m/ZAeDQVnYOlC6ZMTWnsCRJg5Jbt9Dqz1dTw5yM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:28:46PM +0000, Shinichiro Kawasaki wrote:
> On Apr 13, 2026 / 11:57, Lorenzo Stoakes wrote:
> > Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
> > __vma_check_mmap_hook() in order to assert that a driver doesn't
> > incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
> > latter of which would not ultimately get invoked.
> >
> > However, this did not correctly account for stacked drivers (or drivers
> > that otherwise use the compatibility layer) which might recursively call
> > an mmap_prepare hook via the compatibility layer.
> >
> > Thus the nested mmap_prepare() invocation might result in a VMA which has
> > vm_ops->mapped set with an overlaying mmap() hook, causing the
> > __vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
> > operation.
> >
> > This patch resolves this by simply removing the check, as we can't be
> > certain that an mmap() hook doesn't at some point invoke the compatibility
> > layer, and it's not worth trying to track it.
> >
> > Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
> > Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Closes: https://lore.kernel.org/all/adx2ws5z0NMIe5Yj@shinmob/
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Lorenzo, thank you for the swift fix. I applied this patch on top of the
> next-20260410 kernel, and confirmed the failure disappeared. Good.
>
> Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Thanks! :)

Cheers, Lorenzo

