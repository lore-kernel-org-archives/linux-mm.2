Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85A4C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68DE6B008A; Sat,  1 Aug 2026 08:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B190B6B0092; Sat,  1 Aug 2026 08:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30EE6B0093; Sat,  1 Aug 2026 08:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 800EB6B008A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:51:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19F13C0288
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:51:36 +0000 (UTC)
X-FDA: 85052686992.16.F854F47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BB82C0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:51:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIgqcCL0;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785588694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnwFawdRZh+GCy4YU8vannLc+3WGfD1ePfzk8ZSjrGg=;
	b=TNzHnGrAiFSyY7XkatYsh0WZvzmuAxRt26c9ZS2R4DLqJIhpRS/D+GkZlIqwgy2F19Jxwj
	Tn6qwgjrtg7ggzOkgh9kaE+VfWXvt7Jnb5+4zZxZ8EPm2th4APcqOx7dpjPwBcVQEu/tOh
	YGOYnlq+AS+OFdQpSmzgHP87xikiGfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIgqcCL0;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785588694;
	b=vil9+W2eH1kPbff+/E5IFGKM1kXNm2Mx4jLuFWbmvhocqSFqdT4O3eLFnLdFHG7xCljx4J
	ERDC9EzrTwdPyk8zdJHRHu7KDzkskMZEDUkSInkl7GbZLsvB2OHwjn8WYnuR/u6bMC4oKL
	M0UIYnITzwb3+xRdlsfwpxIwS/vRujw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DD5942AB8;
	Sat,  1 Aug 2026 12:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9381F00AC4;
	Sat,  1 Aug 2026 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785588693;
	bh=YnwFawdRZh+GCy4YU8vannLc+3WGfD1ePfzk8ZSjrGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OIgqcCL0PvJPjSEB89T2YhZ7wsGRXICq3P0Yase6pgJudXZuld1aUJBLqjid/r4YH
	 4CJcg3vzVK79nDg7W9Q6oUdlb06+SGD8y4TZtrh1+lQ05BerwiUK0Ur/LpOo/72lg5
	 P8CLDunox8lkMrSQVUc67mFrDYSRSDon1mWoEBYn2/w/iT0rgyPAaBfw4X9KUDu3Bx
	 6+pk9oev8+HwNVKudmq6FgZR4BLSGtJNazOOQphfnjIyxSa/NouQDs78APo+mAi7Kq
	 hrlp6K/Lxko1zti9cPFtSPXCGbvJOu90WGC8abxeLeT2jAbHizvi/rqmSkfuGk5RF2
	 YJN5/4WHtgvWA==
Date: Sat, 1 Aug 2026 21:51:30 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
Message-ID: <am3ruh9vviTIa5cK@thinkpad>
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
X-Rspamd-Queue-Id: 7BB82C0003
X-Rspam-User: 
X-Stat-Signature: o7sfeh3bme17spziofz9nmqfnixs5b98
X-Rspamd-Server: rspam04
X-HE-Tag: 1785588694-26304
X-HE-Meta: U2FsdGVkX1+YtfLyASy+8Oftlzf/PAICBElGFjZ8lHz/wE8J1sKfQcuvFBf/71rFM38qH116NTB/2hZCdhIHp6Zh2dbc2JSFt+5HpOROV1ra10jQ7YxPxiyk09XMrZslxeISuue97Ep4P9TLMIjFkGMBm9alqMOOwZKI4T+VdjdOO7PYRF1ldABQOATttlOjCO0OJNqTwt+tQZG1chdo1o1Akg5KfvIhdfOLMqm/NcMi74F+I3K9W6+A55qSnu+kty38zUUaLs8XOog5TIfaOw1pWAilFRUlWwmMdTO9wyhhoVcZaGqbGOId+SzrbSde5Fc5np1WKBAFkY2z1PNTyrPEpxJOyCCt4S3kpNYZ5aBNbs7FqjhwEMlX8ABW1weNrgT9+kNIPz5edkfKJ065qU3T1jD/gBN3qvLEeOvWM7ZFCNaRFk1RzvRvzbhH7Iql5e6KB+1+UfK3XCISvIClBOYQEj5MLEslfPzJSs+AqYxjS/JaQYt2E95WcWCfQxyVzKa9BpJWhDi57B0LN0JL1Dgw59SXSQno+6uAJ1xjAJMY+5nMdgtMbLfJ5FajZYcMGTUga9LVukZNUo8h0Yla/akYivz0qXmGSacOCPOHCbCrVDsorMUj49dZ0gg87xzf3yRpzylKrbfsxBtrnRGpbamci7QYaQ/v0hnVSJYcG9H2m8aDDYqQcs9YGjvp5wjSh/lChL9sXe6aoU58Dgx5PdH3Mu4nIocGS0f3KBGwLNGjFAgXKmh++v3VfAK0uUQF3sqHKx9Ge+mBtvsEviiGgn+Db4yRjXrGyXxgZujGW4WAXLgKsHtEPC+ei09N4YLEEl4XXv9pBdcwZON7DF8aKIRDrjGER3vhLtWGid/CjOveba7lFF8+VHZtNuAME+1UHqgl2ZdMiRjKTzF+Gu2DSVy48zzvkBMKhx58OD+rfCcKo4SPp3RFkgrUR3G9TXCYe56FnaMObuLdFE/vuzx
 2I0F27mw
 f0SqdRVc6965K9yLiaTaFRhiLOmPb388qTikbwlkyIDWc3Nb8rY2h6anBkqnUTE5Lg3T/Q0MynKGk3dVxk+pAo5f0diTUHguqLJJ4Bs8T1PkUYcYoZB214EMZeh2tANQxCtJOzJ4xEOqYxpY3Y3Ha0UnNQlyOcIuM3dCB8n+SpIZ7Tg3UhYw3jhlBroi3JlhISXHzWFxFVOon9FGztzGSqo5tlD8izL97rLe37C37GHdq6YYnQVkVXVpOaQ9pPPsrt70s4NhUBPFfpTI4yoWzzetZxJwML8TSqIRQuvAowbKU9AEib84Ej9/zd8adVAqj7jZm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:32:46PM +0200, Vlastimil Babka (SUSE) wrote:
> No module code calls these functions directly. Seems it was always the
> case. Remove the exports.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

