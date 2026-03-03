Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B67DEC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7B36B01F1; Tue,  3 Mar 2026 08:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67A56B01F3; Tue,  3 Mar 2026 08:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A196B01F4; Tue,  3 Mar 2026 08:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88BFF6B01F1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:40:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F4DA89612
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:40:59 +0000 (UTC)
X-FDA: 84504862638.29.384DC0C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F649140010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:40:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSjZBWHD;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772545257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQDPa2adNHI5FdN0PDtiRE89lLLNLqqz/+7EJZi5CDw=;
	b=gDKiD7+vwQ7gmYvsJ/rqEqMWWdahSPfqtaueBmPDHkQMZuspoL0jMRHiE8h5RzhJyhp0yi
	KSP0ZkBrOVvzjZ/PyS3pczdBSnYNvceOioeVZwCPJFK4PcvUOk5j6N1/+hupL0boIZCoOG
	J0JkF8mJQLI1jZ/JlTizKLFeKlgO/EQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSjZBWHD;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772545257; a=rsa-sha256;
	cv=none;
	b=WOW1ZmI3CPjcdgqA7f2BVqDxV5GuIQm3zOozA/wNxBp+oVZeNruCaCxeeFCogkjDIVekvX
	YoaMHkiR0YtZlWpN19N5/JDD/uLSmTrNuF7NWbKvIdTckL6bFQK0VNLLE+fWxRbNH6KkWP
	ZG5wWXRTjH7FLKlY5ddNIkqFaGpSQ6M=
Date: Tue, 3 Mar 2026 05:40:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772545255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wQDPa2adNHI5FdN0PDtiRE89lLLNLqqz/+7EJZi5CDw=;
	b=QSjZBWHD3rHz8qq+v1KU4lulaZAbUk84xfHCfDC1j0Bupjbz4HCDx+DuWgeC8nUgdDcwiE
	rvaWECPx1Nbjh25LgOr9Xpk1x6yKxRd2iwnl9jz4AtJjJGWpfOSbZOl9Ue1GrJ4emiObya
	yH7+UfFjiXbMbZ6C2x8cnb7GkVXafIo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Maninder Singh <maninder1.s@samsung.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Message-ID: <aabkuk4szmaoNCGT@linux.dev>
References: <CGME20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd@epcas5p1.samsung.com>
 <20260303102600.105255-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303102600.105255-1-maninder1.s@samsung.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7F649140010
X-Stat-Signature: e54qj9pdk99mg68wkbbkppq35g6k5ara
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772545257-930937
X-HE-Meta: U2FsdGVkX1/8OBvGjFQvaXRU2zo+WWiO6uVAyLzN9qXkFOjTFlnQnmF82OJ9B2GewHIxfM+XbMOp7m5XbMWh26ns9aTMQcvY3Ah66qAeX41egfwjjcRUoepAENV+TEqxbJRQcvsA/KqJZuk6+7+S/KLcmKOmPZ3zhmBECFaoac4mZkCJU7wLkpk+ltEBJxAoaepW4jiSupFuK9wXwhbN+JTR+Sl/4c6Qtp6ErdBJMHAp9WvNDqVfut5lvagk4gO3hKYFerirpd0ZEiu2a/SxRxLxmfJmjz8d96FiZtwr36ctR1ryxyOP5qQymdzdtq7D70/zH0PcRPze8w3sk9ev/LcP3jomI5qrl3gqFC4o2TQoHuCnnfz4iCKQeFcDgF+dQj/qGpxHqK2PP/NLHP91BMy27Z6xNPLIEyBNgh34Ck1FTvYSiKlXoz82MHSNaRIqtfSBCKfMxuscbx2n+sWeglAc2UtDWF5tGsIbtd9wtbm/8IAKhWBDaso0XbEcTB1jezQRrK29hizikyA6RxDXzkmed5UrZlGX6XCIgfAK4uSEuUM4NzAAE5ETBDJDx/LDDJZ7LwGWJWI5xi8pNwlcx1duF2STMNzilezQOjqG+ruS4sjEVQ37HsNyjJf5XmAwL6cPzgrBlHbCPbH3lwPhbVGanjBretNvl/pKnL6ALotOjMoooOO66x4JgeTaUsBUKNeUjgLwXFNMk9KOyAunkqx2polX1ilgpzyOldMtzcX8bp7eaGer2LfvBO7D8Tof1e5fIjZusYonjuuYDAZrtfHrk+X8sCxGiLykqMlONTS/MwZCcwfoJFU/ZxYE+DUsrm3qqTHe58eKaDNdUJO6YVYlPBQGipxZnoLyy//dntdixyEhqx9E0moKFWPwLfCv/EK+4a8yO7Ay9iMEyCyRqYHWobe9yYUSsgxIfT1ytjgmDsChy2TTALijhICREqH3q6C2Vo49M/ZZoPpQj1z
 ATfPqcMJ
 RnuwyTeR+NxkNu4v7ylUnldFOCv3yrt/FnzKuLIJ9k27+ndTVvw/JilYbh3Ga2uqnN+ppU8T1TVevgYhOgV2rcq70CoiJnWoWRwbXEt72ISQ2W7UrbThaYIuXI+U1dbSEkGxCAF1BSWT8TYeVRm4ge8UCRztfhHRM7g7VHtnyXNV8vT2TTqNV4zDmt2rmkctRbxFO6nca0aw4xzrq28geosHKfW2ZuE74FuVIMhlHhIbV/EuwPPikYu/GfKhPMHSu8vl/iaOfZJiP8jf9CTaEt71lsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 03:56:00PM +0530, Maninder Singh wrote:
> guard(rcu)() simplifies code readability and there is
> no need of extra goto labels.
> 
> Thus replacing rcu_read_lock/unlock with guard(rcu)().
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>

Thanks for the patch.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

