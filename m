Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F57C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A9B6B0092; Sun, 13 Sep 2026 22:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403746B0093; Sun, 13 Sep 2026 22:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356B46B0095; Sun, 13 Sep 2026 22:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1262F6B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:39:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64510C0EDF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:39:12 +0000 (UTC)
X-FDA: 85210810944.08.45194D0
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3DB29C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:39:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789353550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VoQF7u87fdxE0UavgnagGXUZDuzr9mLcAzX3yBiMY0=;
	b=rIqmQAlujFYIAk5qougiAAngikKxoW9RGtldrgBAYdFc6oUUCiECcNkKoJsBebs0NfUGrG
	Z8FPMMiuNdoZz0VN5gDXmEm8AUtJB5zvpVGC+Yo7n5u0QVs5Vp/OqFBBDwOVNSwXuymzr5
	7OZSqX8/fUpBeIvncDiM7NQCdJ6B0UI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789353550;
	b=3BQpgAArthZ/2tg3HftflK7MUjD4IVRDAcyCe23/HmkKa1JuaSmNfAbk0VQy9rkn8sXhol
	KxGOgD0jkUXhb4HbZV20o6+XHJmbr4AoQDZNdJsmJMRLGdXSKz53wEhCgwR9wmP5qr7dhP
	DzQ4uYGKZYWBxmPvsS6CZQthS+5VLAs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hjq911jHXz5B13b;
	Mon, 14 Sep 2026 10:39:01 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 68E2cu3o020377;
	Mon, 14 Sep 2026 10:38:56 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 14 Sep 2026 10:38:57 +0800 (CST)
X-Zmail-TransId: 2afa6aa75e413e0-9f4f4
X-Mailer: Zmail v1.0
Message-ID: <20260914103857462iSBgwGihbRU3F3tXr8zwW@zte.com.cn>
In-Reply-To: <20260914020944.664339-1-xialonglong2025@163.com>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn,20260914020944.664339-1-xialonglong2025@163.com
Date: Mon, 14 Sep 2026 10:38:57 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xialonglong2025@163.com>
Cc: <xialonglong2025@163.com>, <david@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <vbabka@kernel.org>, <baohua@kernel.org>, <ljs@kernel.org>,
        <ziy@nvidia.com>, <xialonglong@kylinos.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCA0LzRdIG1tL2tzbTogYWRkIGZpbmRfbWVyZ2VhYmxlX3ZtYV9sb2NrZWQoKSB0byB1c2UgcGVyLVZNQSBsb2NraW5n?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68E2cu3o020377
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 14 Sep 2026 10:39:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA75E45.000/4hjq911jHXz5B13b
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DB29C0002
X-Stat-Signature: xop1eo1skzh14fuus89dod7iugiq9jpi
X-Rspam-User: 
X-HE-Tag: 1789353549-980254
X-HE-Meta: U2FsdGVkX18EGdDW3j2KUajEim7jZi2soOCyENgcrYRXJ8GKS1r8KeFD3GwpeDKareglCvLX7iAupJUH3UHr1GbFad30ViLXiOeT9I6ZopEG4eZWfgnLX5DK6Gxg/BhSerhKXCw0vXtJpmwiqgtPIPVSoptottClDq6rATRzVUK971DC9W9EvGhJSE3Ijkr96sobTOacPeFRNBlCS4wcvifmhIJIq0GsYxyBAuEZEP+x0c8Po5qiI/ja5BRJjFC5iRtCj+aW7atuJIuPDJttGiy7/PcEmAsb84rx7S/c63jOzdHlI8NxrDz8sJEugiXQgRvn7CMyRB47qvZcGOjk1K/wyWYaPjQu9NKAGgEi06vO8bF7o0ucwlXqtzDgVwciJ/vbP8Af25XlwuUTNBMpl1kSV3azOYhXS1cZ66hFKnbcpFmaiyfUMJYnuzo4q39js6ryVzhF4+NCpRGVZwv8STo/ORAX3/iyyYoI1kAi1kut6s64DnST6ogEeVemOT7CnkQjENsUCcYG4Uq2sVGhtDtYf7z1vvjHrTwxDXAlQXnc2gttECpRqg438uXbNUyImwlTBh+nfF67NXtqaL8x068F/UnsLDOFA+WbLlffPEcsaVYmZWBmCNB3L8aTLUTWd+rjVm3ynf3PfIxVbVxkTUYe4tWiw4Uwzk+qeCTr1ZiZi/8vNzSXbm2RBYzHvAUfT4hSKbhJnE5t4mpe6LCsZTgbwiJiWMoGc2IZnAaWwyw8U9UcRFmiRS2NV8gqN1bM3fhvYtAwt5g7ttvsTCR2BvBRmrCGaioYnwq8Wa4tqwKuc2ISOzv7rDu0+aoI5r4q+D+OTLHWJzPATnAkoVnbQZu+55Gkhnk//DleXCTMJp/bp57iBBFjRtOo4p/WYz+cPD5L2NSC9Q7dDQZRQ38buiQkueAr6vAaAtkRbnDK6ElJZCQ1/zBKpwNUcVWMkNqM7H5LuLFz9n0pH1VTWGk
 we5xj+8p
 aLfaLxp3SLHyXKdX2v0mkmY/TT9oT3D1N/koj8hDqlJ4Kbkhz44mN1xsDQ/YeQuLRV2Y7AOCC9KmC6Je0KncDkZ4F2UF68F+fPjkLwgD7h8DBi5S6UyJZiBwb3mmyQ663A5/DOXOJGf9mIlWFmR6Vgnfm2msGdyD1qWeUVwwK+0RN3L8smJor8gh2yq+LsTpuvfQLMXY1HKigbTtX8DD/h0SLEdSl7pKIg8dODHh0MiAaK3Bj++sl7VvE4VHicHTWOiqV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thanks for working on this.
> 
> Patch 4 addresses the mmap_lock contention problem in
> get_mergeable_page() that I reported in [1]. In that thread, David
> suggested switching to per-VMA locking [2].
> 
> Could you please consider adding the following tags to the commit
> message of patch 4/4 in the next revision?
> 
> Reported-by: Longlong Xia <xialonglong@kylinos.cn>
> Suggested-by: David Hildenbrand <david@kernel.org>
> 
> It would also be helpful to reference the original discussion in the
> commit message.

Of course. But the series is still under review at the moment, so let's
hold off and see what other maintainers have to say.

