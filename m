Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57574FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5982C6B0005; Tue,  5 May 2026 06:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521916B008A; Tue,  5 May 2026 06:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9C06B008C; Tue,  5 May 2026 06:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 302856B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:31:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89C5F1C0E72
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:38 +0000 (UTC)
X-FDA: 84732999876.05.72E0971
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1602B4000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777977096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blQS1iqzURWmhiiO5W3lXAnfU+2MWh4lwNEPM5x5frQ=;
	b=C/C8vbutxrWkWNtk/RtRAwkuJxqVBJrgqCsN1QWxUcrSkzFr55SUooIZIxoC/BmWfRSfG3
	RUr9+9NonkOxBafT9AGGGV3MFAXWO7fBuTEP+qhVRq1hdC+1v+KStyjaCP7R+fkxM/wAnK
	fGvL2ZY+l4rbQN6DNqetqcAUXDdGFnU=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777977096; a=rsa-sha256;
	cv=pass;
	b=1B3xrgzMSyk4j+CA3MFczC3CgvwrHY3xe6mDXPQv+Ju825BaFhX5lIsJ+v38Dkp2VPkwLo
	T/am0rkiKzaJqAJNDh3ZsTFdQqK3fJKm900Du6wjfoR7vdzvQxSjFzJO/bKQ9/tOuIpbuc
	0uCJ0R057BvOVlwI8kkXtLw4xpXllww=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 856388C301
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:35 +0000 (UTC)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 529AA40478
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:35 +0000 (UTC)
X-FDA: 84732999750.11.30C1044
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 577E014000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:33 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777977093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blQS1iqzURWmhiiO5W3lXAnfU+2MWh4lwNEPM5x5frQ=;
	b=RPTC06j2CN7GqW/IgArgtBXGI3rzGQoSQo8Nu0F4mQkq24PwdEu4vLdbZV2jhqUwK58ctF
	QIkS3sHD+7bQggPtp9qeud0pnsuzbb/8JAei8tVU4CP1H1unIV2PZEejjzujkXxTzoGjIC
	4BW00wbvfXxl4y7JQaOIxBMSTyDfBJQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777977093; a=rsa-sha256;
	cv=pass;
	b=zkKhngtxSTPsj2FkQ1qZA54ESs53mhjNBE5EQL2V9nACvaD7E8VgoWf2xVGrwga2GcKsZF
	HbuJqJTEbyeuDh9Bvx6+VYRpj4Thbtw6ct0ovfCfGT3LRuLXdBcoWYOICRx+yUEbTNB6zt
	tDXsuwyq16XT1lcvQPLoAn7b9WsnqAM=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB00FA0456
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:32 +0000 (UTC)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E9D81C0E68
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:32 +0000 (UTC)
X-FDA: 84732999624.18.5F49FFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04BEEC000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:31:30 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777977091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blQS1iqzURWmhiiO5W3lXAnfU+2MWh4lwNEPM5x5frQ=;
	b=PVOoJWEpy+Qhc4tfbDAzDoUw3oIaxmq1xy8bINZcymzDi/T8vVTjB9ofXdpRvgRJKxqF/n
	SUbsMaEW9WC6qkgQBop3CtjgvUVt+/jQsOK4beELp7otL7mncDFgyrbrpzInfejijaXWdH
	CGba53zJ3+9HaPROPYkr/wXWNSPKZ0s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tG1KSajG;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777977091; a=rsa-sha256;
	cv=none;
	b=pJfuGwWcgWyrOZLGuPuij70V8CFNtovhFJVhLUKu2mx+SmafnTjDQhdGV5RMYymgVngRY+
	rleeQz2ZtT1jbzy96swT+JqefkPfYi5CINk7ZG37ZMzATmRTxfBDL2l8q16wLaUYWa8hVx
	oGDMrgoGPoFcSZ1P/nByMNNwi60MwA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C13660125;
	Tue,  5 May 2026 10:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A04C2BCB4;
	Tue,  5 May 2026 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777977090;
	bh=6mQeMAklyZvmMXcq40qNy3C5krqUWvUCfCqbcMJnxRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tG1KSajG01OkjGtG++XsDL+rekKw3rHS2oC9URVkbuiquwBc/8luxj0K4TXrRmaDW
	 cNpIWi2rYfJrmdI5llAhI2u2Red5C7GiYwatKayO0wzQEGeJoyK4Q93yCtkiL8z3BM
	 gHCggL+oEjzBerjndwBQArwm9GlV+efBSAmOFxn1Vg+y1ygLgjFHk8GmYvd9DG9xCG
	 AqNqfZZTG5ArJZIsihLzrZZ+YSX+7UedBXmIVW/W9iVQfGMEsMyd8FcRZNM3mlUckD
	 f3Q10L7/deBeJSNQVa9hYxrNJ+6T0TsIO0/ITLctEcMCOxnHDUxmFJAEJ6+A9L0JCd
	 61ugf2YY0YKQg==
Date: Tue, 5 May 2026 11:31:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mseal: use min/max in mseal_apply
Message-ID: <afnG21LZfHtaCG-D@lucifer>
References: <20260503115915.18680-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503115915.18680-3-thorsten.blum@linux.dev>
X-HE-Meta: U2FsdGVkX18F4GBVIr+GQcnMu2q+YFRbxNZL1+OOhG9BbzZ7ro/rty4oh9y6OZp0hoFLrcJ0+L/m4Wu3NNJeKp6Wf1CJMEuBGRFozGluLiow1IalVlWbOQu2q0mAP93vNBckO/bWeLmovT8pDvHPwaNlwEsPfF3LmvN0Jp3Xlx1E7tw4uNcFobuOiwsONveDlYMNZmm+OgxkYS+/ZJw4egAE8ngL7gjl0qv9WMnESfsxFIIK78gFxc/5OLH7Vqbcw95V6zQYbfeDARE4+vSSdY/PRuLHttLfDHxepSCatq/JqMfb/w2hQTakFthP23SzgEz7lUZtyFqecbhfs7/a9L0UIitFryvwO7//woPWlBb48tKKjxo9ldGlhmEbPrmCos45+HybImSNhcnMvtyaY29gVHeueEQqKzoeGdJJuSJ9hbOUDaAevxcuuon4xb1IQx4xtDo/igdSy1MoJPWmTiG/qrMjLdbweQoCKCaW/qxqo4TYMpcnv+Nh5ckQWIfuYcKo1Sx5e29eFPK/Vo0ROxDXHH1Ls+BuCx0yiz8bJn9n7X7xZhA/sk5msMjp1/OTiB0u7tgh5fz9UP3G6xUF4N7Cj8kcYDhhOUCE+El4f3YFKaI+lF1J+MEMGHg59c5JArIckdnQPmt8lakvyjgumAldfFaga44ANYcwre/KYQ8XRzZDYwpC6KGT5vu5JyJmiTqhpLzqD7kXKcNBqlrXG83Un2PqfLtZBX0bcgGzmsOhfQJudA44M7rvo7VHC8faH8H0ZGSWGY0cOiBohC5PncPtvCyYhqppvRUsgGJ1Xd1+LK93DLRpGKR1w7VT0FxURpyzggQgHYqWZAYxFH1HJ+9tWn2K7IKxQ9ce61f3ypjLRn5UmYoszUTJoiZUsCgekar1Bz3vDkB1AYjdMef/BlmpynIzq6XJjt8VvMoIUJNFvpY6YVuJU+Lk/uSq7DlQTM/Jwwgyt5RuFeljl5i
 w3pGaI2l
 haV2A+cIGCimNDMQPZqageLs5N2HSRZNFItNslnmJ4xMW49Pa7cQZogitx/IIczs/hMaCwulrfkXEIEZFIoOF1yW+P5KQdZ2TCDNym80kLMKjFOBIEAjFlvGERuOopskdxH0pnEIlR+FNTwHwT+zObidUxCPZS6D9qho3DuJ+KeYQAxgUFpj6kpqNOAKkiD9tM2/Fviw9kTA74e2WPRgLhn62WUBd9SlezRRxIjYQDHij8MlIbTCh0iCKToC1uy/hlJV6Z0inHCzkMontZWxrspPC/JOp93bufEo/O/w/Quvio7oMigNnzgvv4xNnFBa5YwjLSOK5HuV+biCkpoRjawOCCD5Kv5cXXNSH8nle62h1aWozHkHtycdA26CgMyJnShid
X-HE-Tag-Orig: 1777977090-706438
X-HE-Meta: U2FsdGVkX1+s2DIFN/RLFkc8j9CXOzHA280f5pYAUy1hS6dxMhf8k62+j6NrBZ2VRDFWDQZPrScYpC5bTNsMH4WVJ2cNcUZ3kYueSdoWMgoGo1qQqZzzFSQcU4OKGS5CBh67Lo1/gLkHaLFdppk9fvfLLNdn13dRNjf1kM1f9W99LexpwvzDCz0BjA6qwGx75PafhaJ31zumSkP2lRVWFLDK30QF7YSwndBlV+jnLTs4tfBWFrGkPeQ9pQJPoBKAb2WHUo3gcSN3RE67WGFjo9+SqfSN90xG8k5BWzz0Z+5mQaYRQCNApfrE5BBkkVgZZoHeByMldskuWszp+RKyO2VBli0CSNnS9DDC7AnlHTjbYcdcmDCi4SS+ltfktp87HVy5oeXaTBq39CpJkhOYyyV9JdJoPVwW+kb3j2/OgjRF6TPdgFobOjpUuFaL4chdgJzLihcsShsgcwKVVl9q6nVCzQOZfvkm818qd5msOIcmkyKkL2jf8YnZUBBST0thB6aFiq/5mZYA4lgqi3YpC1wGln92bYr1HaBMAbtPwBw8x9zaQoTeLwv6zfWKgyhCnC8VGMqFSZ4YFhdgQKwGsbtz7mLeelgMuNIPjPnFubc81sH5hIVG1TFHujocMjXNm/Osn0kLzC0wpgR4Gyf2DZFW9gsnzpfRiCTTmB8Fhrp1r8fGX7SU7577ui65jydd4dN0QSItAsV0kjIhIC1qkGzLlvTamFZcE1uY16Rk/GbyHNo8kT1fqfz2cdfWC15tKAdhX89JRfYUMjXclfkW6YGKgtnkFYRR67Eqx9W/kpfekOC3QDx+Qo0B1cTSILd4fj05iTQLAIF84LaAnsFsJ7LZ65YYJ3Kx2W0gcrDbR+RDQPRVDDSSlbSt4ucehXj8TnogB+zzx6pNXip7971fARZT3IsNqPbpnBdJ22zHbtRoHuTYvSqk89Ggsid/EcOCPv0CzdK52J81Hj0r611
 c9KpY4lP
 SoTSFWwlVrvjvrjr31xfFdeoV9WmhBp8QRbxvl+LNNaq9bX8zLS4NyZB+Xn6Gx40wd/zY2OqLZqhGKXCaIqgpQkQ4KdaRuKdRjxP/h3/Kcev3nWe9mkFodssT/QnWx5Q+Uemp9Ak/9bVBDHtpnNpx9AwHs2BUFCkZI/W0UOOXHldbUqa1oXgU3n2AUikCnM/Q+sVmjxGF9hjFM0HIoTEVqGA1W7ncVlZRSr4VABwPRJahQE5EqRsczBqV3jfmH0lLJiHvwYJtkq1U+8oSIaXR1fqKNHxsTaa4Ji/Ai6nDxdLFUq77TYspLmaopUb77+0Yz5OeCxd7A9lRV4k=
X-Rspam-User: 
X-Stat-Signature: d9wedy983ea7g4zzc66459cr1rzbxp5m
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1602B4000D
X-HE-Tag-Orig: 1777977093-942040
X-HE-Tag: 1777977095-713468
X-HE-Meta: U2FsdGVkX1/YO2ko8QbP8sRutMhzs+qYdCGZ9ARQi7sLLOBtrClmgO1XTOQmxh0JfXI8liH/DRqUHPvLAiLZ9TGVPSm5Q4Y6vhBBmHGs32mKGy3kLFd4Qj5BIGUNSKwzWI/QeMe88aqyuljPyNSvz6qmda4gCqljkZ2zccfHIbsjD5WjJ29X/a+fZKDdPidCRjB2oQvwLnSagK7/r7K2Hs0/h4ufdXTPjZj7X7IWtr32ibat6jbmsybQ8ChBpZaGu1O2qtUs+F+j7LrNQEUcqdhhZ8DuwBCI00WfQdWiYytR/JwrOHRs5IJaRr+mfugS0VStNprLfi3W59dkgiB2jAauUps8xAmuTTuQjQ7E9hml1NSQgJqy1qwzACoaLMuu8xUp6r1yNY28kja6IjnFxih4sZmdy6AKuDM7EEx5QXw/xFHyJgQncv4CHXKJdg6cbkUjPNVzW+JZeeTeOwQklGllZlrc9bahxhj3Xi8gJfK01Xd6rDXVybuqX10Xut6VcZ5NikIbg7dD0q0cHDYPhMmH/jOLRqS6aO/JToPTVc/VGBiJ0DLCNGQoUVX7KsojCsBm4pD77VMyTCqZ17AfoFcL1r45QOjs4LRn+5qWFKUdQ7JCikCkioMBFYiTkihTRuCMflRCZTU7qSVlyj7+N7bm53KJQz+O6IFCfZvWUkjrvaE6F8q9kVYk9/8QXk1Co/VcYoIxRKDwmsWpOyjzSo2bNAFjh/wqeDVdjKtgT6ME3fWyNc1g1rLl93tMyo6vqKR8d3TiW6kamKsRzfcjFCpiXPxWrLRadiMLWaCR3E5WKIuD7Cq7LJ0dhArfXPWXILh2deHc+cACLYIp29UXEm4KVRIkA8uyMCHOyR/1tYshOqCYIn4ZMO1isOipedBQinpRpB3fKOyMZSdusnb2kdbFPsMmqdaP54OS0tblovzweQn1vjswxO83OC1iq7SJiHB0ccMab5TGZRQ9/Kr
 l2kBNeKm
 PGThtFDqA/glq8HgNH0FcJ5poI3q7E+nm0CmCC/Ck2pqGTzKWOUgj9SG5+PJ6TS0PNIhK8LVDE/X+rV253N5nbWVYPXjeDlRHONcZPynjLcCUsmebJLVe8gCBMrjtF8/2I5WfvKcr4MYfwPxlj9h4eKgpPawR280CIhy2kkRJBYnqgNvGrRi28JYcGrXbKUNZn+pWOEMju4X+dFJ1WLP24EsQPx6v4UgHw/TuIyDltN9BQhQ28rea10TRExjP5TtrcwweiCnszsM7gzMdWLSxiUcWV/soiphfo/MNdKFnPYRO7id8hFFZyTEFpGcqK6JVz6NCKbT0Ly98mdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 01:59:16PM +0200, Thorsten Blum wrote:
> Use the type-checked min()/max() macros instead of MIN()/MAX(), which
> are supposed to be used "for obvious constants only".
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Oops my bad :)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/mseal.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index e2093ae3d25c..9781647483d1 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/mempolicy.h>
> +#include <linux/minmax.h>
>  #include <linux/mman.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> @@ -65,8 +66,8 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
>
>  	for_each_vma_range(vmi, vma, end) {
> -		const unsigned long curr_start = MAX(vma->vm_start, start);
> -		const unsigned long curr_end = MIN(vma->vm_end, end);
> +		const unsigned long curr_start = max(vma->vm_start, start);
> +		const unsigned long curr_end = min(vma->vm_end, end);
>
>  		if (!vma_test(vma, VMA_SEALED_BIT)) {
>  			vma_flags_t vma_flags = vma->flags;



