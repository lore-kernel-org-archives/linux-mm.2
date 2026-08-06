Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8BBC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8056B007B; Thu,  6 Aug 2026 05:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F2C6B0088; Thu,  6 Aug 2026 05:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795826B008A; Thu,  6 Aug 2026 05:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 554E96B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:16:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF32EC066D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:16:48 +0000 (UTC)
X-FDA: 85070289696.25.902C754
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CFAB40006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:16:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0eTsOOn;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786007807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ljN0NF+47Fie+d6Hz8NSwHbzN7PRWldFClsRQcVmg8=;
	b=Uucyo8QlXTL2NI73bgynA660GGDVrGrnVIwO9qnHvdB4FEJWNyiQKorgaxeHh2wf0prXb/
	bcT92j4Y12Y8Wk8wgnXNo3CbpMAcjHrx1Z470oYEXoXfCfs3SS4cDz1lxcYILUqK91RCS9
	Zt4kxHLNiOMxWueNKmNx+oNrylUFttE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786007807;
	b=iRXs9HBUNvP55OhXRl8WE3pc74EMe81tCU2FE83BrQzAc+PDeHDzN2qSawtbiVNL5Ho+Sv
	oAplDdgqonFN02r+Ho9yp+MqJJjLluo7PjULJJbMecaa9u4Pt0rFnfozEJlV2vxdl5eqbp
	aE5W4BLZ0hlaxWNC5FwJEoiAEYxseKY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0eTsOOn;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8686B60AA6;
	Thu,  6 Aug 2026 09:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE711F00A3A;
	Thu,  6 Aug 2026 09:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007806;
	bh=8ljN0NF+47Fie+d6Hz8NSwHbzN7PRWldFClsRQcVmg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b0eTsOOnUG54PDJlrPizCnlR2BrEFsn+yACTwsw2O+7cUFtUKBcNzFoUQqO22D56M
	 ANHYnYRqnDOauc0VyIGj/b7kIbiLX/hzUZp6laGQVCPEVbwqiXUFRqpmR9VhDO0X6o
	 6nurFoRGjtJqNe6pmGyo18Ibhqjbv9Vzt7ND4Tm/l/yU11fvMMHVjos8un0sSUqLmF
	 +3idbXWKPphCIOGvmfckrtHvL8MDaHga7xVuuw4VtO7hJRAvS8nlnzZlbra1dlw3gk
	 +vZ8vVD6nqqJN2zqdjstK4vQyODoVHNUY2emYZCKrn3JVtA/f7vzi/eXHtpkK1V+hp
	 gu/rRS6BErZYQ==
Date: Thu, 6 Aug 2026 10:16:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xialonglong@kylinos.cn
Subject: Re: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
Message-ID: <anRQlo5GQKValPFy@lucifer>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <20260805162937.1795310-1-xialonglong2025@163.com>
 <anNl1SSA3fidOrTy@lucifer>
 <e3700884-ee6c-4671-977e-2694535b8443@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3700884-ee6c-4671-977e-2694535b8443@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CFAB40006
X-Rspam-User: 
X-Stat-Signature: indojook6uazce6eb6s39qta974c8iki
X-HE-Tag: 1786007807-877997
X-HE-Meta: U2FsdGVkX1+BoHR+Moa/vovQ08uvfiOR7YZP/AF/JykQzMLjS6Imb0aJ2NSjo1SKG4sFcKfmQnpaHedjkSV+CotAnCaap2u7choTTdj0d+c5FquL8XZdDjpNjZYYYEP+jCnep7JKO1B/r2zee2Vt+a9H3c23WMYViN/DnM2gi7hR7iSTNqETUcz66YVA5jcqsXATCWVdvZ2tpSFNmyZU0tGI9+L5lFNoF2HptLlf4ibz2KdJPEhm8Xv9walRhlF2iGvj3hxXuyWUzYy+EDS+hY+++ygQ0KDUNRdlDafSz2LasQ5TL9BY5JlWfuX5CCFt3ApzODF4Xiq7xMnWUU69YP7nCdWqI/kS9BGzB3HeO5U7wof1kQlOKWd7jT4Q8IQGdNqf6GzYtNC1vXptD/6sn5O2sI7fepWumeqdAs3wBhIcD9rYwrxhkw5KXA3WlMg/PDcKlFqJhHb/uU61sXdc0Y6k+OWI8qsVSMVkjfKl9Sevf1g7J2cVvBr3DhGWz9nOdK5eeuh5BobveLiKlHRl/sHN1L2MTix8SjqLoh8aMHSM6c+H5Md7YC/Jhvf6V1XcIbx6+QgSq4AVFkQjtpD+KPGAkIfST4yxrN8TDYGAd839vP5wxoHSX9jUWTfYfHl7mfcYRPAMn5N26MscPP0pHp0vV4BBk2n7P9W96w2eUbwMvJva5YhBAEtB+AqK/Jbupk+CmYIpRLUvf3e8QwyYQS5lObupvuPh3uVedZyZaxlFyKAyAVowhxrrtws3rbPB2Bj+I+d9UeGeGrQQiejwNtB3qrYy6I1eNHpKPlH6XdoRV9YfrwVIVG/DEP9mkO6GG/EW0Q/wR4qSWMjjRGR5qC85PRTmuhdU5qYE7hfxRfGUpMO+mkl/FtOR7SW+rcBXK1Ue4FZHsigUcOoaqvF7rdfceygjGDjY9VFQsjxHAptVDWO82PQ6k33wTR9w8aNVg1jwxQ9RMIXqTYsv1jf
 Lw63uM3W
 SfKSqrt+Obxc2v8dnvlnpL7Zpc1ZpIY8mg2FsfpA1/jOLlp80DDb0tV7j/3z5Mco0EGypySsAJ2urLg+xEhykgHK3r9Ji/J405VrcvTVtKrD4zKOuU9WW7czfg1+ch8dxAmr89RE6/FAd/yv0EcEhQ1+SztMbMddK9g2cd9mmwwHTd1eCh0parodfbTXxommmwnWzxM55+kX71WemPPCZ+U5nII3R3aEgrA38pH/Yj5w3YWpNDKlMt2IMbxAfoI/FIllxZohHKLDCyjxQ3U8ehG8TXErkd2wRJsHgG5OV7WoK4Sc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:48:35PM +0800, Longlong Xia wrote:
> Hi Lorenzo,
>
> Sorry, you are right. I messed up the process here -- I should not have
> resent it so quickly, or sent v2 as a reply to v1.
>
> I did use AI tooling while working on this, but the patch is my
> responsibility. I did just follow the anonymous-page handling here, without
> thinking it carefully enough.

Please include the Assisted-by tag in future revisions if it formed a
substantial part of the patch, as per
https://docs.kernel.org/process/coding-assistants.html thanks!

(Be handy to stick a # < what you used the LLM for > comment after it too :)

>
> Thanks,
> Longlong

--
Cheers, Lorenzo

