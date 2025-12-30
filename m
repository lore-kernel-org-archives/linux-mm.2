Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DA0E9413E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 09:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280F96B0005; Tue, 30 Dec 2025 04:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E4E6B0089; Tue, 30 Dec 2025 04:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B026B008A; Tue, 30 Dec 2025 04:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1A366B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:55:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9833A5FC18
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:55:27 +0000 (UTC)
X-FDA: 84275679894.18.06F8D9E
Received: from outbound.st.icloud.com (p-east2-cluster3-host3-snip4-4.eps.apple.com [57.103.77.155])
	by imf25.hostedemail.com (Postfix) with ESMTP id 947A2A0004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:55:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=ArpKY1wu;
	spf=pass (imf25.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.77.155 as permitted sender) smtp.mailfrom=bshephar@bne-home.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767088525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmDYq0sZYNfRXKy7F8dDdYiishtx63bWrkF4Fhf00DU=;
	b=grbkdlKNRBkxIG3NXRaYdyi8XHnq1RHCwdIBiRzn66Kq6tk+64W0FZWv5xtkVCugX4M+8p
	7c1gPCdhBkQATlL4Fm2rXyUz0QA7PQhqWXL/lyY6yCIpufrs5S1s/8XqZ95Bl64aCq/Tti
	xCB7m5UcXuXTasUA9iJhVK1KthHIaas=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=ArpKY1wu;
	spf=pass (imf25.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.77.155 as permitted sender) smtp.mailfrom=bshephar@bne-home.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767088525; a=rsa-sha256;
	cv=none;
	b=pOrq8bQDkcagufRtD5gz4dFAM6j/bDIwG6NB0cdlwQL6DjgCPTgTE2ksJX6ujKME0IjVlX
	6noYHc8VfWcQ668byqGfUrjz3jqeBbhiV6T9ydIEPwhZcS3wnZ7Ly2mC+ENo4mN/6wx0ER
	IWXdQ1h8/f2IeCVJ2/Tfs6VIQdgKW4g=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id A129D180055A;
	Tue, 30 Dec 2025 09:55:20 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bne-home.net; s=sig1; bh=jmDYq0sZYNfRXKy7F8dDdYiishtx63bWrkF4Fhf00DU=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=ArpKY1wumRPypHpgTLEa0HKDKnByOEgxXG3bYfOEDNSpEJUsm2v/VPKDWfMHWjP3E/dawYhWE6vFwWkPwppg1AOb7V9QxMFs0Do8upBqFen1n/nMKBGRx5fwLXFeJsnZZw4PFhz9YvrnWXcGJ9LkQwYfcoWI/nBzX5FgRuf8nzP4YuuS6Gr48TF3vqNP8YUYo2XWKUr6sfpBnPMbIKXCX8eEq56hOnBOjNRR+EcrvDHkUFDgwI00JUaoj6UdRuAUo6dAkQ0R2yORRL9Q6x9lEwdjtu7c44DXVFaTTH/QiJg48laP0FkQUeiixrHboyOJW133yZrdevlByB4o/mgyBg==
mail-alias-created-date: 1746336505199
Received: from fedora-g16.bne-home.net (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 3532A1800543;
	Tue, 30 Dec 2025 09:55:14 +0000 (UTC)
Date: Tue, 30 Dec 2025 19:55:09 +1000
From: Brendan Shephard <bshephar@bne-home.net>
To: aliceryhl@google.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, ojeda@kernel.org, boqun.feng@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, tmgross@umich.edu, dakr@kernel.org
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: Test page_align usize::MAX boundary edges
Message-ID: <aVOhfWmyJBxD4SUa@fedora-g16.bne-home.net>
References: <20251230094841.76830-1-bshephar@bne-home.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230094841.76830-1-bshephar@bne-home.net>
X-Proofpoint-ORIG-GUID: eDq-KvX5c89fLpQ15zl4qfk3YuBty3Qi
X-Authority-Info: v=2.4 cv=OZuVzxTY c=1 sm=1 tr=0 ts=6953a18a cx=c_apl:c_pps
 a=YrL12D//S6tul8v/L+6tKg==:117 a=YrL12D//S6tul8v/L+6tKg==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=JppZAXPjAAAA:8 a=v0bcC3016m_wzupuhzUA:9
 a=CjuIK1q_8ugA:10 a=mTXuAFqUwmiQvsSFmwXH:22
X-Proofpoint-GUID: eDq-KvX5c89fLpQ15zl4qfk3YuBty3Qi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA4OSBTYWx0ZWRfX5PILfIQ/g32F
 JWSRAWTyPOXs0NZtxB/go/D0LAxZqCLnGkMsFOeaJkTbBzpbXeuNdccsgpiVlzNino5EzfuXsd/
 UbyLVKqdtLeKbOTQAQF/AvXuqwwQGgg8DLQbX1aFKosBa2t96U2rWorMPvA+gy8RbX575en/E9v
 hzBmcN0UgnSlSLTq+DlvtO5MXbPBKKx4prFozEkOA/EsV3PjGy1J08YvWjA4rA0rr2FDEr8y6qb
 6NkeW17Cq8wueRyY/JDJ53jgpvfafOd4Lj6lMvlwLcixhtJJJAea29bIXqwNcT7PyFLVsEMm04k
 Ed8LhP7yi7mgu4xORFF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1030
 suspectscore=0 phishscore=0 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2510240001 definitions=main-2512300089
X-JNJ: AAAAAAABYN/C2DwERd3qtqUnOxp39Bc6oM1b3Y6SSCL/RzFDy3YqA8swtbyNXxSSFR9dsT30sy8sYRm/clpCUMylsCVQ8Z2oV28mdBXYIDhBCiJZF8fCzeIQxm8Lv0IbwHFJahlwL4LmUZP5IKtLQUXw3aOcgCGoH389Mnvgylvt0gntGyuZlZxhgbRzRIt3uGf6YJsKL+0LUXPPiG0MyKjANVarOsM7+Q/deOa0Xa5TBFaoAKNN6OioYnp/+i7esyQGFnLQOF7L5k6WndA6lKrdmK8sNem0I+Wvg3zX9M/vsK9fuAXIKtsm3YBLLooAi/iT0mo+2ECLMchqaGnTTvMpmLhmY0wvuA+Oj4g2Yu02tcdBnJepqUMKKDNmNZVeOc/6M/AL8fYwBZqIWCUtGOog6/snC2+gMY3zx8sNuInFvA6SbEQvkTIqBV1wfzrvup6/Z9wFWQK4Hi+uUYoW+e/kI9L2aAH1IkKZgVktcUZKmUM5g2YNWp9qSbSTODHfwopJ0IdTwW6vLYTsF9HFn+Z6z+VCPA1Ldwy9X20iF2YP2tIhig3B3jIiFbeySmKByI7gSMb5GRHKV+f26ofk7lclVI44C9rlqtkmOQ1jKDUDYeaVFGJuMZYdYduWdl4YTeAjIkuYI0Hb+fsOG88TbUejyjJ6wjO1DcvzQJ41vjEaKFLexbe1lDEolaR362jVwfFqf5d7x4WYdAxijrhj43ghZwhovASa2o8d9HjljvMONGmNQnxte+RG5bTL2SEtTXtAuvwj/8QvVcwYwdNVQnUWjQvWE5Kg07asgsHW60DhZA==
X-Rspamd-Server: rspam02
X-Stat-Signature: xy5j63ksi68runtx1azt8xze8n6kazrf
X-Rspam-User: 
X-Rspamd-Queue-Id: 947A2A0004
X-HE-Tag: 1767088525-913288
X-HE-Meta: U2FsdGVkX18Mp2DljIG1wGGnNUoD0HS3l2W06PBcuwMrYaZySbDIVmoJZkUCe8YE7f+cdvVyZI8bY9ZOZJMsNpM/8Davg8t1KUhNka+8Rkza0dvzbgU83SipYMkXFynBwAorPo3pA9PCWZyw0/JBLs6y4H1mrVMKIIrFv1ce0yGz/qKxma5ZU805uJg72wIlfONXfjjrSiiFkJdro3G0J1xd/2NIpAUufYljPAIKL19X8IfOQc34LdP1LVFppMjDboT9wuJPgAg0qf4VcaLVg0h3owht9RDwYRSWJSU0KM/SVHU37rqd+r/5nkY+XKUVgBZWwatqdBKqmYwi4+9YcMqwUbIKAve2z6n/9KXmiFXk2O8SCUVUmOb4YuwtfW93O8KKAGm33WWE9SMzYpXqQhH1AbRqPBn4/MVbdneDc5eEpZcmjOGufSRv7OwaPGkMpaPjW+2+BW3gcNCio4XbcU4qyh4OT1yRv877deS8u8xsYq0jE7LEKf67L3wsb/wLh3fIEh7b+mlLZWcR6JWnZ0xbrmTinkDUa3xxMzeiD/kRd4gVLtYzdrMWi0z9hzakmJFIEMnbL0yqBr0+NM4xCXHWuoYzSgSyTprTekQ7X+Sm8ik7fsWwfnX49KPPvuSHZ/P80DH9y7OdCe9g9D/6KLlcLn73sCF75ynviskzGdl5JQoob4clLEGpUM+udc6iwkyIGqp8ZjT2NfcasGj56qMOmp0wqj1rzQqAapCpxNv94uMfEcdXu9enVGfCJBhpLd6bSCUa1kBYEMIYEnx9De/Lz/YhS2y/ktA7tY6FzQw7gPjLlQ1TCzFol/474ztrdDoLL+uHOM65wh9fQ+39dnvDkN6tnCdq0D4JdDNNW291cn54mNaT6N0+BPZcV1KGxBYg/YBkZjVZPjlMNDWdE9LLh4purlM1QZMtyxf0sOi5X0PI0elbdru+YKqifKdDNZxMkccLaoN71LO6Zt1
 vjq35pJi
 bvhry/pup4xeAmgbEsRNaSZvpk590hAwp9e0UYMPE4tm799LXXeLO6mB/ZJIGkq1zb/NS3dJzQBwq8NqT+tdWTcsmEE7+USh0ps/UGZvc69yex9jZRtWR8CNepZgQL/B1Fg3YFYR5WllMW5bACN/aMLB4+lgfgdY2+sw3x3M+EBWKn3nQisOyhpRDKhkVHsmMjIK6U8T8nflaNIMsBgMV5PSAWnWKplpo5rWVZNVrTgPlJcNmlFV4UWMrVa8Pf2b1wNA1osG0DzoRKy8Si4wupVGKFKCOQ8Keul122NEA1yu0e7ylshME6T1RktCNtieaY0FreYOwGmjcoa+3cx10c2Hc949QRtKZqXD6+ejm/8hpSMHoGo+1uTiRp+UY0I6k47U2mzEEhGW+PS4MB2ZTyfZse2zSLr3SNWrtc3Rg5wi4O3dMbYedgzQFW+54R9p2t5J6nYn0yICl2YWxp3g/a9srjVrMiO3XddAiCCCZJ7n7YYmQlwqtv22+R6UfSHIJWL30tEZRwe3bAbHlw03YvfbU0OA1D/48dzc7Y83bUN9HPao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 07:48:41PM +1000, bshephar@bne-home.net wrote:
> From: Brendan Shephard <bshephar@bne-home.net>
> 
> Update `page_align` doc tests to test `usize::MAX` boundaries
> rather than arbitrary middle of `PAGE_SIZE`.
> 
> This patch is a follow-up of:
> "[PATCH v8] rust: Return Option from page_align and ensure no usize overflow"
> 
> Signed-off-by: Brendan Shephard <bshephar@bne-home.net>
> ---
>  rust/kernel/page.rs | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index adecb200c654..d602d4231f56 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -45,9 +45,10 @@
>  /// assert_eq!(page_align(0x1), Some(PAGE_SIZE));
>  /// assert_eq!(page_align(PAGE_SIZE + 1), Some(2 * PAGE_SIZE));
>  ///
> -/// // Requested address causes overflow (returns `None`).
> -/// let overflow_addr = usize::MAX - (PAGE_SIZE / 2);
> -/// assert_eq!(page_align(overflow_addr), None);
> +/// // Testing boundary conditions at the end of the address space.
> +/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 1), Some(usize::MAX - PAGE_SIZE + 1));
> +/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 2), None);
> +/// assert_eq!(page_align(usize::MAX), None);
>  /// ```
>  #[inline(always)]
>  pub const fn page_align(addr: usize) -> Option<usize> {
> 
> base-commit: 7acc70476f14661149774ab88d3fe23d83ba4249
> -- 
> 2.52.0
> 
@miguel, Thanks for the pointers in:
https://lore.kernel.org/all/CANiq72kcMLXz=xyZeKC0=j_e0BzJEY3wGpBTTxfJsc6EZhCnXA@mail.gmail.com/
https://lore.kernel.org/rust-for-linux/CANiq72mLPvB_6Ow3bW5-V4-km=RyA59chQ1g1x9qUt2P-zZweg@mail.gmail.com/

Let me know if this addresses the points you were raising in those.
Maybe you just wanted usize::MAX and then one over? The first test
case might be unnecessary. The last two do a fine job of illustrating the
point I think.

