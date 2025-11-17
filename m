Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF802CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 01:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12C18E0036; Sun, 16 Nov 2025 20:22:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9F78E0002; Sun, 16 Nov 2025 20:22:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00DF8E0036; Sun, 16 Nov 2025 20:22:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB5B58E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 20:22:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33FB5160B5E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 01:22:45 +0000 (UTC)
X-FDA: 84118349490.17.78CA9BE
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 35CB11C0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 01:22:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y76yD+/t";
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763342563;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmzjFYEYGPStUpUVGou996BcsTb+MCnq/kukfCjwXl8=;
	b=JplP+TmcgwLhV6lhrzE3yiTJRwkCIDsgTRI4xnrCT2xNij1+8yczYGDTOu/u3WHxOhdi4m
	HA5A3i1Gn2YUEzuwEUkBZZ264WFSObdg39/U524RSjVwo4J1Yy0vub/G5stgg+mmdaj0MV
	/mZ7D/QVz7i9ym9OvtliuxNcIyM5vY0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y76yD+/t";
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763342563; a=rsa-sha256;
	cv=none;
	b=KzBFzwvO4Bbhxk96588GgBi3IVWD5ULKLQKJiuUN/XgSvEEiQRpEfmw3qk/hlbmyL/NDtf
	TBUB6OKv02Ufz4g9UI0S2lgZesJsjDnlB4H7vD4elj8v/1GLwsOWCtltAG+oJ7epS5M54Y
	5Y6QayszjNqTfEEdoy36zXJtrxpnXC8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso2100422a12.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 17:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763342561; x=1763947361; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmzjFYEYGPStUpUVGou996BcsTb+MCnq/kukfCjwXl8=;
        b=Y76yD+/tj1EYBLykkqgY703KkpeitesQp9BGd/fnopXuRHK7WxTkCO7LkGAo8GpZrp
         svEzfJhRcPtTSjhGH8mrPvhx3BzVAV/PgBUtBB7WdCAAFoM7ifl4UHOiKYI06AIRksoY
         VW/kaJ5P1TJSQqtCOVcgcB76B2uyy3xso/YrMJL66BipyMwrj1XttsKyMfr/9Nmd8oT2
         7JdUORlJ9hqsSgETBwC5UVFKRbxhuN8ev6XP099UVNbasqEEXkm5PbM0d6Ufp23r4gGb
         5aMfWbsxER3CwymxN+2uEaNVb6G5XbpKziNbU9FMkENgOZdA+7P4lRZW0Pg9tsgfKosf
         47Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763342561; x=1763947361;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmzjFYEYGPStUpUVGou996BcsTb+MCnq/kukfCjwXl8=;
        b=XhgmmiUFjX5ojvPQfxTyVi8pUnt2NS50l9AF7UqPflr/Nne/9sqaRPFzBaWWGPAeSZ
         SDKV7ofvGopK1fJ8UZmJ2Kcuvn+onOZvny8iGcP9oaTsPeFSvbMX3GiNQvasjGSRrU3A
         fM0x4pvTwYHU7snKcjmK9Az/kygs1DYoSMMnCjllfVfWPk7r/blFz+NhUKYpVpxo698A
         RCfQaRI5XlB+/m6zHFp8B7XE8XdgPXzPmgTLHMqupAImEuF+eYE8/17bB2CQHDSeGPzT
         lBuyg/Pa1+QmqLetOAb7+XO4hqNGVSCN9GMPKkZjZ86YUZhGR9bLVndpsEShDbQmNNyW
         IPqw==
X-Forwarded-Encrypted: i=1; AJvYcCU/9rhio/jPd2vzmpD767jsLSv4x7iYouAdq19WsqahjDJetTtbmCYLz94h0fY1frOlXt1dpqXQBg==@kvack.org
X-Gm-Message-State: AOJu0YzoraEO2fKDUl/mlrejZFigTjP0pQyKn8mywzRRa54hP4Ijcq5o
	T6i+zkgYOUdmkUaPlgAZLJGC7riIFagLn/wGx/NZM2xRjtEJ6QzEvmXp
X-Gm-Gg: ASbGncv3g9QSkxYSmU56KROK986fmnCq4an6dvkOWB9MuoOKxW3NeGDZNFBTCxj4vLt
	ierK7ck0B81N1BHuX5nEfv652PflFpleFuk+mvHYN6j6M5ThUR5G8Q3R9sL06jfkUlCfVBJcTXe
	RK/8BJStd88iaMqA9Lrg5sHxq+ADkbX+e7GkUGhIYdB3Vppkzt7bkmJMCWBE3VkavHJyZvaywz5
	F3WTcSc82naJUJ317ERUrL4gA9H8F/ByswcPtqAQlzYl9X01tx6fUtsV/X+u0qwP6lzl7EiJEp2
	J8OHSXUATVaWlq307lta8iYDQN0LSRNBcUAzwTpbqAP21A21Fst8cpoPInusZxkKODqSiTIcSml
	oGahn0WYdN9Qzew/E9KUC+l5yRSNWuld2fmV14VgbfIrMOw9BR6j4HJu8R+qiWwrbq5KPRGJxn3
	62Z386u8+yfjkL44OtAqnIZNnK7du8tL9FFi8=
X-Google-Smtp-Source: AGHT+IF6k8TutrenxcR2jQSHm8r4u0d8FrHQsdtyrrfecFL+Hg4B4JBYHsdb8qWPloDBxYoQWahRKg==
X-Received: by 2002:a05:6402:430a:b0:640:9997:a229 with SMTP id 4fb4d7f45d1cf-6434f80f7f6mr11415045a12.3.1763342561334;
        Sun, 16 Nov 2025 17:22:41 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4b28b0sm8921015a12.30.2025.11.16.17.22.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 16 Nov 2025 17:22:39 -0800 (PST)
Date: Mon, 17 Nov 2025 01:22:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251117012239.lqm33uu4vl4y5zqc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106034155.21398-3-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35CB11C0006
X-Stat-Signature: g6dugpbid9m8seqihs6qbaya8fmrdcfp
X-Rspam-User: 
X-HE-Tag: 1763342562-684450
X-HE-Meta: U2FsdGVkX1+y4DZDveWE6DaDJ5eZlmPrX5jCzA4fVwax/LLzstjbNt7eS8Hwu+CbNyoqoMoTQjOMUO+G3GBvfURQh4aTouw6m3gqhfcwtEyQRRXncTDb2DOzI5+Fy08Lu51FFTARmLZqHFkkCQ9J0orWKyCP29Mm1LlJbWhbUs7diFZHwSUSCpUZ5dtdLd+38o+7FlRPg92dLaL2diEHKCCEgL/2yQZu7QKJbPmKNwL8A8Bq5lRGv9+TA4GzCsMAfZeDabIqTCR1k9oKm+HIYwmyAtsdLVEMpY/TyHJXMn4F516BRBk6i5spIP9uXMO6sxXmyadypkyk7zqqawAolLN/aoNpnPruUWaGBWkxKcjz8kTsKeiaFxTcWV/MCWbVC97tKfNCQv8yia2s/oVfgJKr/urMAIEabEVF4hlZln6TDx2CVIfCrr5KV2iZfBAJUClVP56c3PSeP08bVMKnxq6ztDhBXTwZ9nSRTElkrou6k7pUrExh2ZM1Zj8bajW3rrcASpheez1lLa481qVfAgCOvn+silQdy0yduVLpaJC/fanALtnwne2/2XbPjgeRQLDCj3UlfrwdGdLYwerbZFgEJUiyvJy7DpoW1kyJR2sO3CaNaEMEfeklprGik2ls+XcqmBjxcf03lkC5pgqxkU+wsUm79G/pG2U5eiq0SPoU2hepYxuyRYIjv429DOVYCY6LRWVa92pesY9ZUb67QzPOy9hm+WRjlyoCFOrf0FypNeZIb4Mokz9qaNNeXe09bq6KcfFMhmzE2IEkXGMIN/+CB4IvQBjHHVk/9GRk+6HcEPspWfSvAyMA4WWg5IbBCryIkS/fJgGIidmV0g7SVJ4rcxPCri/sFoPaC1PVNfpvghpCv/pqdbQ8a9NkrYVGbON+SGuGY7UR0Nq215IxfZRYcypGksJng2F4h7WZuwwbqXMHNvPiyxGzRy9fSHfv8XIsB0kBukW3kyccRU8
 ix/8xeiM
 eA6oLCbU3MJWy+AXKJfUEzOVPPX2qEtyQSNTLgAeiZITYQz1qMQB25DbdRaF5/Dq7O+skBQPoeyyeIEKQPkVgL+QEiHraL7gTgydm9iH6/ZNWQLoEgpmg16yj76JwpCTGjmfROt2hM2W2ZgR7YOThdFfhLmu/35Jlgpf2Ib3sIFVNiRulVUpOVdq5R01+UsU6xcAwUXq/ONeCVN0HRUBkQt/VNB5o7MJS+3bOySmauwXV0zmkay5STwBGpVvEscw//jySGDQw77qhF+laErD6aEFo0NHwkwnCYirsc9I2oIn33NPB2ChDuRlBPCOX5md8SLj4IooaTtz/MOt62b+1h2oc3/ILysGZ/c2OPASihc1ZeH6BjrvaRG5BF316FpbsBBgshyqlLsrhI3HUna23cWY9GO0/D1HR5t3jRV49ynoveYmunZiAt1ciNeBcKJRj52HSPfd+Gqxu/+KBLPdVw15p7xhPvP9Wv7rznFdeIcwGayvDVoL2Gi3QTtka/gYIR8RnkXn5TREePsY1OhQFEa/llEoPhCf89dyFENWPtHSM3g4EuwKGBgLJZlbzCnAog6J9Yk8U0Kku0J395Y9ai+TO2JSCKCqs4qwrff7FGXtaxQcddpnTPpMro0zoy1SFOQ6V6fOBOOyQZhBm0TvCeZMRYnI1OCSxByq72q3vN5d8MShTuGE9C/Jk7NJJxH6Uzzx6Rh/M9+Cecnk2ecLNhSXpeUi6qSOzJ/SGplXpkmPvEM9E1VnxJlCvLvH24dp3tEsU5kwAAlF+hhQU9RgF3L9OaOhyyqkUSnKx+v0kWqc2ZxwaV/z5hReSK+BO9K2O3Lwt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 03:41:55AM +0000, Wei Yang wrote:
>The functions uniform_split_supported() and
>non_uniform_split_supported() share significantly similar logic.
>
>The only functional difference is that uniform_split_supported()
>includes an additional check on the requested @new_order.
>
>The reason for this check comes from the following two aspects:
>
>  * some file system or swap cache just supports order-0 folio
>  * the behavioral difference between uniform/non-uniform split
>
>The behavioral difference between uniform split and non-uniform:
>
>  * uniform split splits folio directly to @new_order
>  * non-uniform split creates after-split folios with orders from
>    folio_order(folio) - 1 to new_order.
>
>This means for non-uniform split or !new_order split we should check the
>file system and swap cache respectively.
>
>This commit unifies the logic and merge the two functions into a single
>combined helper, removing redundant code and simplifying the split
>support checking mechanism.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>
[...]
>-/* See comments in non_uniform_split_supported() */
>-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>-		bool warns)
>-{
>-	if (folio_test_anon(folio)) {
>-		VM_WARN_ONCE(warns && new_order == 1,
>-				"Cannot split to order-1 folio");
>-		if (new_order == 1)
>-			return false;
>-	} else  if (new_order) {
>+	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> 		    !mapping_large_folio_support(folio->mapping)) {

After re-scan the code, I found we may have a NULL pointer dereference here.

We bail out if folio->mapping == NULL in __folio_split(), which means it is
possible to be NULL. But we access mapping->flags here.

Looks there is no bug report yet, so I am not sure it worth a separate fix to
original code.

>+			/*
>+			 * We can always split a folio down to a single page
>+			 * (new_order == 0) uniformly.
>+			 *
>+			 * For any other scenario
>+			 *   a) uniform split targeting a large folio
>+			 *      (new_order > 0)
>+			 *   b) any non-uniform split
>+			 * we must confirm that the file system supports large
>+			 * folios.
>+			 *
>+			 * Note that we might still have THPs in such
>+			 * mappings, which is created from khugepaged when
>+			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>+			 * case, the mapping does not actually support large
>+			 * folios properly.
>+			 */
> 			VM_WARN_ONCE(warns,
> 				"Cannot split file folio to non-0 order");
> 			return false;
> 		}
> 	}
> 
>-	if (new_order && folio_test_swapcache(folio)) {
>+	/*
>+	 * swapcache folio could only be split to order 0
>+	 *
>+	 * non-uniform split creates after-split folios with orders from
>+	 * folio_order(folio) - 1 to new_order, making it not suitable for any
>+	 * swapcache folio split. Only uniform split to order-0 can be used
>+	 * here.
>+	 */
>+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
> 		VM_WARN_ONCE(warns,
> 			"Cannot split swapcache folio to non-0 order");
> 		return false;
>@@ -3794,11 +3787,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	if (new_order >= old_order)
> 		return -EINVAL;
> 
>-	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
>-		return -EINVAL;
>-
>-	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
>-	    !non_uniform_split_supported(folio, new_order, true))
>+	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
> 		return -EINVAL;
> 
> 	is_hzp = is_huge_zero_folio(folio);
>-- 
>2.34.1

-- 
Wei Yang
Help you, Help me

