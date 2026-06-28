Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B482C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71D76B0005; Sun, 28 Jun 2026 12:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23226B0088; Sun, 28 Jun 2026 12:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B276B008A; Sun, 28 Jun 2026 12:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF816B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:09:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 931FF1203E1
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:09:23 +0000 (UTC)
X-FDA: 84929806206.04.A95782A
Received: from outbound.st.icloud.com (p-east2-cluster5-host3-snip4-8.eps.apple.com [57.103.79.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id B82331C0009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:09:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=weU5cmRn;
	spf=pass (imf20.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.51 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782662961;
	b=DNnwZhv3QT2+DKGQX0yXLg4oLRsGwVWCEMa9Uaaw6VRif5chlUxFk2SNRdD/4JDVF9k3wg
	HGYoZ3jUUs5OzKZ+2Wx7IJ55weB11lUO/ZoS6/Cnmdee3+HwS9KvK8LSULz9FfGjd2MD0H
	rMaAr/qZMFcDShF9CVrlIsFlOdk+5iQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782662961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsPtSOajqeeyfCW7HxrnAuQ711GqnUaN3sgpgm0Q6LE=;
	b=ZVnT+lTupeLUqhW/h9JQQXqvcQ+pBF88DgAKvvjTnSsS1hDYAox15dUlj5SNGRelfdSxWp
	nK7PgmAi0WN9D/pjJni8f9D/enck2LJwlA/pCm2u20YBwunYkb1gcq7OqHluyFlFSc3g2n
	Ws1/RbZr7/RaP8+IIVOAq+sUO1e0700=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=weU5cmRn;
	spf=pass (imf20.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.51 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-2 (Postfix) with ESMTPS id B69AF18011D5;
	Sun, 28 Jun 2026 16:09:18 +0000 (UTC)
X-ICL-RepId: 019f0efe-0e54-7854-84c8-409d30ca50b7
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsLQwZcBlBcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAVaEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKV1NAD0AACQ5ZH0hYQAJAAw4AQRQaUQgPRlNFX0BSCwUIBkkKS3MEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1782662961; x=1785254961; bh=HsPtSOajqeeyfCW7HxrnAuQ711GqnUaN3sgpgm0Q6LE=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=weU5cmRnFr3gsPtbRquzi/wHP7x93Z84PuBtbEmlgzi3ShkkSe/Xrq/tsM8eBsKYuFCJ4tIbum1Ql/lP6A5ZFpcw6+B0+bDeKpgP9EwiDF8yich9dkbf2koyXSVld/QpLZ6ngLt/4UcEwFMetjOEKJabZpudcKJBnfZIswn6eOOCSgOq0Ud27AU8AUsTYUIlV+SAGcXsk7v+e/4NTW5VR9esBMXXZwCGK8QqwKauqiIsDuQg+dIB8nslf6nEO4IeBS2nEMhMWuR4cXrAxcgJ8A0aOo06SNsbwRC1Jfy37cx0jZGfJcyoZeBnYhqEijKOjfOjaXIhKLpqhmB3y2deIw==
Received: from [192.168.255.10] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-2 (Postfix) with ESMTPSA id CA98618000BC;
	Sun, 28 Jun 2026 16:09:11 +0000 (UTC)
Message-ID: <a0683d92-8a81-4e21-bbe8-a5f8af2c4933@icloud.com>
Date: Mon, 29 Jun 2026 00:09:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 bruzzhang@tencent.com, hannes@cmpxchg.org, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zippermonkey@icloud.com
References: <8a8240ad-049f-4bf8-af65-d5bab2c19024@kernel.org>
Subject: Re: [PATCH v4 1/5] mm/vmscan: introduce folio_activate_locked()
 helper
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <8a8240ad-049f-4bf8-af65-d5bab2c19024@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zhWZNeanj4DqCr_EBq7T1rv6sTbp8owZ
X-Proofpoint-ORIG-GUID: zhWZNeanj4DqCr_EBq7T1rv6sTbp8owZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDE0NCBTYWx0ZWRfX0TJe5CGKuVqV
 q4LzJdR1ClNAOUt0Y1ifzFUiQoLN3GQCtEItlxR/oYMSSSDqrhpQ1J0spAxAN1Gbm2VWfOFOaUo
 BTao+0xzytQmgOEszBVyHDxy4b5AVMhEiZxb3pO2bP+14xyB7jlTsjJ6PE14Pqy78+XJJEcrFrE
 cLnZjQrNi6Dd3kRtKEjw5LRZFhTorB16Ns0WiG2PIpXyOLWb6qK9efHG+vIpe2Wu6Fc+rOOkH7P
 fwB+oD7WAsierLfE+KlPX6BphRWcH6efkRkNF/UiecW6wHgL+Slk5bX0nRyNW5wipyQJgnZupSe
 8/kE1cEdOr1tv59SDRB
X-Rspam-User: 
X-Stat-Signature: f9ncgf4oesraseh7uz8818k5c64sb9w1
X-Rspamd-Queue-Id: B82331C0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782662961-787089
X-HE-Meta: U2FsdGVkX1/XCAc7y+295Dkt3BrUBpX9ET2tolfrPNoql6VtgGErAjPcVv5WEE1xe6tZlykEfpLvPU8sO4zosIMuP4bkOwir/gy+XMIbaGm+IN6DMa9AiWfYhP19+nS1rzjZwYKSnVidEcMIzZ57w9Uf0fkedC6j7hOO0uFDyKtTAv1lzs1Hy4pcTuiVX4tWo6PBibd/cLGzhsfSaKW4CbkUTG2U/FGfkVtusU/tSyWBrPPN1hTR4rSjxoQN57M+/ZA0XLHt+mUsdjmtNBxQVbDeY6zXYAsT5NfC3LSr0/QsaN41AS8dcwmD/BQbt/7x6F8TRDu+/deuEAsoOE8XDsdECV3269kRCt4jBN6QNw43w05/+LfNr8hvj6ZX0ZFLrl6NJK/F5fdYGfXb9CyAWDceqHuRSEHeWovLxAJab88sye384iY0mkrm4f3ZrpcnvS+oxBIRcPb9QGd5bnutxfFDwFEUjafpHPTyvcudOgQxoK0aGnXrGDTmNoIzQbyVft8n0KSp87V7z5P2V4Z/wQEZanyeGYo4fKgddpngt5g56pX9nL3Ln/uYorKY9U0OFImmpAJydsH36gXTBVKgDrJ6s5tlT4Z9ifjlvx5seTU8XJbYl4Udf0UcN4rK8nG3v+zVdit57ObkE5jRTrkzCp7rPgdJ7ZRLTAL+kRsepk63toHNQWLEtuN6PlgGeeBGsh1MBq5Sog6Twcav5y5V6AQ/1es0pW1oAVDaBHJSIaFJKAbfxTT3rwvV5pqH0BRIaJ1W4JhlFKqtLDBiRIb679cxOFDfi1PJx/5ZWcbNLx7oPJGVPDFtf4f92fhMSW/kZ+KXsKpK/vx/OSM6KXyb844iMK3IGb7KkPHBI6I2LPV4fQR7pmOu6WWQmKCyRavehTNQon2/gcKuSnObcO1vJHGn6UIS7HDUS3Bw7+ZD9Lh0qop3eWQDQFys6GSMlDy6wT/IEckj8nAlP3DVCNP
 5VuQg81R
 +5KNb31lTXUz2ssipdt5gYOXCLDlb85VAe3rqsLx/gb5yoQdjZZwtH+nUGHDMZC6FzQo2DULp1K86UKeCbPtVxH0yPY7CKtZZsHzpOYrfBSCP6qUCYxur19BnuvawOBtkIa2WEKJ2kxndrsZKZxy6cBMIgBBVLweDx+5ekFoqhvPpdfmLusBm9gY1OKrQEKOyGY0c+7530kp+YuPZ4E15bfVSqUD8CJO3ojvSlcmbbuDWzGQ/p1WH2Qu+gEV/RT4x9oo0fmdY7jGuV6pkTiZfHtOkp/stjvZ8YWcNCbHfolHOBZk5a5yRMnj4oxQlKOCCwx64FQSx0O0eoNyo3J/1VGuxzCbaZpOcH7sYMIpWlZ2Vp3rxgDjcqu+51FEaQmZhxEQVxgleJFwF4bnBtNd8S/suMNOfRvdJl5vOtsAzus8E1G3DjjKzwT/06fzGn5wOCO5vYdGI0KbDFBs8yQmDukq7v5hL2KNnPtNif/GV373+BjwJj0DbBTNDelAnTPfnJ1GxxdypJdDaQKHWblLU5TqAVH3TWgEbo8XnFztY3lq0deMwLRnxPIbJqR8MOcifJQxh0SZHZUjscHudP2CkIb6Rec4Tz25mO/mo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:59:55PM +0200, David Hildenbrand wrote:
 > Passing nr_pages to this helper is rather questionable. Just use
 > folio_nr_pages(folio) here and make the function less weird.
 >
 > Do we want to add a
 >     VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 >
 > While at it, do we want to turn this to a VM_WARN_ON_ONCE_FOLIO?
 > (and can we move that to the beginning of the function?)

Yep, all makes sense.  Will drop nr_pages, add the locked check at the
top, and switch the BUG_ON to WARN_ON_ONCE — panicking over a bogus
active flag is overkill.


