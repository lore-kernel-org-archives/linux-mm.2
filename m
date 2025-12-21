Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0583E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 20:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044226B0005; Sun, 21 Dec 2025 15:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34716B0089; Sun, 21 Dec 2025 15:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40016B008A; Sun, 21 Dec 2025 15:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0EFA6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:23:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71B9A8BA55
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:23:32 +0000 (UTC)
X-FDA: 84244603464.13.4E188EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C34484000A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:23:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wn/3iHGK";
	spf=pass (imf11.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766348610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4osTBFq4Gt0hw66CGVoVJKRG+p6FOpxRLfdhZSqIwF8=;
	b=pnxeSYDGVQ8benq1OF7/B6GubArJxIaKh0W6etWwKaLygMjwb7JkHrAK9H3H20RrN6hFRO
	/wRVKRgzYeelgWbPGAkA3sQqDUG3XecbNBgF+02N8EEcTMeRmSZNwpFgX+K3KBQdpt0abd
	ObWWzX/tqq8m0+zHOiJ7MYjHtUWGneY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wn/3iHGK";
	spf=pass (imf11.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766348610; a=rsa-sha256;
	cv=none;
	b=C1uD5S9b7rmEJW6YiPoIZsQ86cRQ1y3BFThyT8+MD2pdjrrAqjig7kOBpJCA4w1kMRPCiE
	dONDPVxxMDtxfIZNx7ePGr/+pDsXK1t6diSbrJJbwJnBJ5G/vUXtURjG7USLDBYmFtU11D
	gSqQLdgQkfdqDzF1CAH9y+BcMTlgHok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766348609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4osTBFq4Gt0hw66CGVoVJKRG+p6FOpxRLfdhZSqIwF8=;
	b=Wn/3iHGKHn/eQWSMxHoLplPzG96aYmTyEDoDBTeZxm+lb4kMga2CJD5dWhySG8Zaeoccg1
	OD7mhYBWnyMSom2gCW2DlCOg5luDz0zdBHPgXSQjJ0uWvoQo7vzG4Ew7MOwik8RUGd67qe
	GlmibbdpnhiSw6ARAZVQ3cpGjIdD/q8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-BS25hOz4NraHu0T7QS57OQ-1; Sun, 21 Dec 2025 15:23:27 -0500
X-MC-Unique: BS25hOz4NraHu0T7QS57OQ-1
X-Mimecast-MFC-AGG-ID: BS25hOz4NraHu0T7QS57OQ_1766348607
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b2e19c8558so777066585a.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766348607; x=1766953407;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4osTBFq4Gt0hw66CGVoVJKRG+p6FOpxRLfdhZSqIwF8=;
        b=h3GGM8i2qN18t0xLYmBSEw8PkZHCOcl4VBMZIuo7rW/TwBQF1A3rLmkbKYbopPcAgY
         B47TA7/37r5ikrGdkix1jr4ox4qpixCP3MtgISCCId/DG57hqTzuJWBoZXtf3mfHccC1
         sLLeDvW1buw8Ki1P7BN4nMIcLzsLVM6l1jWW3HV8LuoZnkd0qLCvFY5EdjhIprc+q+Qi
         cqPSdswszXppNz1qQ9VFGkbUj6BMzXgfNy7epwpoecwqQvx+aHygKz0Dvyv9fQ9XTdua
         trPvxc4+WwYeAB6ONNWcva4msBAXBnmT1d46fctwUTwBkxOC4hWMhbKJQSsR+w36inkG
         HU8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEBlzdI3FZSxkY5VtfrzpSnWtSALZdsDmm0kbXlCDfCJHHLNotRWPbY3RZn8A7l7OmoLnopXYErg==@kvack.org
X-Gm-Message-State: AOJu0YxaiGkvEJP7Etx6ozm2U1Y42bmKe22F+WqG+6iFTUSKOppCYoj3
	IeuwHv1dHd7UPFRgF+wonfZPxdn+cxYNDq/P9hEQUZX7176EfBjRSK0Tq/KSLbnRObe95N1nDlp
	6NYX1QYvwieDtVaKqVni66sVCmrrYPH/bmot9varMCCKgGOcUVs0n
X-Gm-Gg: AY/fxX6422mm5j3vofhUG61w8GERUX2R/8vmf+j/9feflzvN3xZRKtupkJ3jeMr6w+2
	ELS3DN1sTaOgfdhEKPSy4aSbQSpPUNTujREO7SWNIuNYcshVM/cB+gMAxtj1Fy/JEClhoIJgXAz
	Lco+jmVDS44l6At86h/apbQ0B3bD9VD5izvanHPR53xPCgA15bw2LRAW6lUAMiU/K9wCW2m1vSy
	NPFnc2J4Ct9UPA3WXiEBU5AVKVKiLia+CjFf91zobx7F+e6Y+9Zi7T/XzOu9B1dNPmIn04MdjOj
	RA3o6p9LX2vGm33+2qLTmyiOTPMXRENN/DGFBPOBGfWy1Q+rFwHYfI8mh0dKlDCI167VadF0GFx
	/R8KPegAD5Kcvs6mb+KRgzEEyHnLMkqToX2mS24XqoEz8giExHK6XnWkK
X-Received: by 2002:a05:620a:2945:b0:8a6:ee41:1b48 with SMTP id af79cd13be357-8c08fc0ebb3mr1494135985a.26.1766348607255;
        Sun, 21 Dec 2025 12:23:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHH1hKRiYLU7cK0Wkvqmr52oHSn2x4SgTCG2kximSipAI6VB4lbhPeQOdZR7L7ni/aX63l7iQ==
X-Received: by 2002:a05:620a:2945:b0:8a6:ee41:1b48 with SMTP id af79cd13be357-8c08fc0ebb3mr1494133585a.26.1766348606764;
        Sun, 21 Dec 2025 12:23:26 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d96bec1d3sm66333926d6.17.2025.12.21.12.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Dec 2025 12:23:25 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <39c9af10-d66f-4bcc-93a6-9e2d33827938@redhat.com>
Date: Sun, 21 Dec 2025 15:23:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>,
 Shuah Khan <shuah@kernel.org>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-2-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-2-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iW96uu25h-Oz6LEeT0JIOEqWsJqla0bNfSj2MjLKJMY_1766348607
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: f1cqw7rxcytye1na3a1qw9y8hrnoxgph
X-Rspam-User: 
X-Rspamd-Queue-Id: C34484000A
X-HE-Tag: 1766348609-298523
X-HE-Meta: U2FsdGVkX1+KU/GTFEiD+rOntlD1/KlFfICW12p6IDpGLfYjhlAHWegnXXlYSUh2xH9B0M8Q0oktYyyBpXjiB7mOCm9K8n2MVFvdb5aParuRwmW4SQ/9ZdVsCDsI418vVRfs5Hsm7w1ireAqBfaHz/D08qcqqqQC6D7lW9gaKCJnuentnJ/7PvF9+BV30fI18opAd2ubXATFYdOOltdHLzB261h3KgCxzBpzKLEQvwS+1XxMW2f4AiROt/z8+JmM5t20WS5SYJMx8nvOf22MKx+KQQQ1y4bz5a9BWi+lZLRKSf80oQ8PNBdmOX2eIF71HeLdgdZYnjWZQBUKUbdr2zA54ndgNYMCGm1+rqbHI5armT7/LH44AQhRWas+ZUbSLJ5yN7YO4Edn/2ZxHIde0U1VFN9Kg5bFajljP85B/vMsEaqQVCiy1lVuoUgU5HB725jhKei3747Mtsf4HzGlNV68TXUgaBY1JcrjAGuWNdOZ0a0jisePy4g4pUQ+Jqi+SxyjycWl/gTG9koMQG1p7vaGhTWcjWHvkMjhaH4J4TF6tpn+cmPEoonlAStkcaYgrASlH9LwA6n+gMWH21rvWjpHMTw/kX8W9NajBTYFjCInKo2JR7ybazrLsLtOgG0yizGrz5CX9q1+XSfkSRb8cSZdXiduTQFjTZoFs08n+4+UhomKpBoBjah56dMCSBp0kATJv3Mlshb1KjWHgT8EwJ20hRZuY2ddXFJOb34H+wrVXe33oO/Ciy+NViZoywWicfHHWB8Q+bSDj19U84bwbMaqFA5mBvtbOI3KY0XOv/OZpPV2GYLPYK5DLDr/NhhHIuse5ABrf7spPjxNZUKFE8hYE0lD6hRGAAYrvpyAUBcgeFfi+O4KlFPFXKtpgVA3z+r1bbWyMykGCYB7EBZ0VsvNgfqNm1s+9muFvConnRzCmLWu+dHtHSl7B0pqQMj7h7LkkaD/4lCdJSP/8bn
 QJ+NhK2R
 CAIn/FCJWfNFp6fWAdV8tvwvrkAfSg11BY1FGLVeKLvRMgJs0mVVtw34w2R4EeSyroU9FoD0Cq/OgZ8urSHxosfZ8OtyHKiNDj5be28HRNLZXX0IckxWR7IyIo6OvqjDx3DFzPJ9+IyAfOGNwxs9dnunOtBkSNE8ezZNmj/GcaL991LDIHHdW1ad9X+gcY15byhTnkWGRfDdikFH4yRgWdyNxb5AjHcthOlaZ2ZONMpJ2EgCAL3i3Cz1ZluyLWtABUSO1HzxlrrF1RyZ5EFTIR8pFc48biz7vZSEVnWLmrfj/A/Eskm/RTZziSJ3mOHzVJzjKQfvIZeQyg9QUmCO/+d/K+hs/z0iAWAKqggdcgTOy5cGHRUIakeDXA084KbNSN+dEFfu0f5KLPhRFqeCf2J1eO/Ue99/zyuLKly9ORfBSLHdnWmeS/gPvOTHfuu1SWHFCKXluBvi/ars9ez2P1m6My7w6EVTj+u6VUl7gqwdTjK3Euc/LxEYSItYScqu6tddJCDXUNt8iyTRdhHHGc0TRNc9n1UVQJRPkDvDZKGHJQeUJpBrnzAonlvcpgKsGNwpWXy8HrbUzaGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 7:26 AM, Li Wang wrote:
> write_to_hugetlbfs currently parses the -s size argument with atoi()
> into an int. This silently accepts malformed input, cannot report overflow,
> and can truncate large sizes.
>
> --- Error log ---
>   # uname -r
>   6.12.0-xxx.el10.aarch64+64k
>
>   # ls /sys/kernel/mm/hugepages/hugepages-*
>   hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
>
>   #./charge_reserved_hugetlb.sh -cgroup-v2
>   # -----------------------------------------
>   ...
>   # nr hugepages = 10
>   # writing cgroup limit: 5368709120
>   # writing reseravation limit: 5368709120
>   ...
>   # Writing to this path: /mnt/huge/test
>   # Writing this size: -1610612736        <--------
>
> Switch the size variable to size_t and parse -s with sscanf("%zu", ...).
> Also print the size using %zu.
>
> This avoids incorrect behavior with large -s values and makes the utility
> more robust.
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   tools/testing/selftests/mm/write_to_hugetlbfs.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> index 34c91f7e6128..ecb5f7619960 100644
> --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> @@ -68,7 +68,7 @@ int main(int argc, char **argv)
>   	int key = 0;
>   	int *ptr = NULL;
>   	int c = 0;
> -	int size = 0;
> +	size_t size = 0;
>   	char path[256] = "";
>   	enum method method = MAX_METHOD;
>   	int want_sleep = 0, private = 0;
> @@ -86,7 +86,10 @@ int main(int argc, char **argv)
>   	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
>   		switch (c) {
>   		case 's':
> -			size = atoi(optarg);
> +			if (sscanf(optarg, "%zu", &size) != 1) {
> +				perror("Invalid -s.");
> +				exit_usage();
> +			}
>   			break;
>   		case 'p':
>   			strncpy(path, optarg, sizeof(path) - 1);
> @@ -131,7 +134,7 @@ int main(int argc, char **argv)
>   	}
>   
>   	if (size != 0) {
> -		printf("Writing this size: %d\n", size);
> +		printf("Writing this size: %zu\n", size);
>   	} else {
>   		errno = EINVAL;
>   		perror("size not found");

LGTM

Acked-by: Waiman Long <longman@redhat.com>


