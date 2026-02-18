Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FDBE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CA76B0088; Wed, 18 Feb 2026 08:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E07B6B0089; Wed, 18 Feb 2026 08:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1E56B008A; Wed, 18 Feb 2026 08:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F226B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:29:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04F621A0189
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:29:53 +0000 (UTC)
X-FDA: 84457660308.13.C113300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2B4AC1C000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:29:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0wqFhLS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771421392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiB2zf8aJQBfuQVE7LAIKIuWY4snk5S1YZrTwu9tDTA=;
	b=uLUXX8HbaDmP0Wa9GqjFAhz9el2Fi+vPLbrrvJ08IMlyOfuD3dk422i1UuRWOCVxI+z4rh
	t81urbr7jk4T4PD7w11B7ibTSMvyIu33ZIb5Yf1n6TUUi5EI0y60deXqduNIoQg0J0esux
	x2ldi5P6Gl48K4P8W6NhFD2zX0L9eNM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0wqFhLS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771421392; a=rsa-sha256;
	cv=none;
	b=V4WQhM+o0zgi3I5hjfvzLZliqMRFdc/S0KrLbgAkWnNw1+LvhNp/J57brPwKm73RkKnxbA
	lKi64WYWyH6aGqaYoRhlimfQfSp3vkScY7SRGGkypRRYSrxGb9zy63WE2fK0qv4x8msnRW
	5bVK3yA6/u6pVkso/buxyCOlr0akh6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23B0942BA8;
	Wed, 18 Feb 2026 13:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91126C19421;
	Wed, 18 Feb 2026 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771421391;
	bh=sKKUJ4hpt7H3ThiktsCgA+vUzyYvf+FASOjdc2KrzCE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c0wqFhLSzumL/OqPVbXtDtiizPalO/h0r5DGPjU7oar+NwxCyFoB85yznz0RpcjbV
	 oOVPNlCz8+BYqDNziaw7p+V/YPTFeBTHdq7QmA0xvLJhQmy391sXlptl/YwqBg1yFy
	 ygBkaBxZCYX4+wckU7C7SGe2N+4/4NSVzyY8ogVzeCJBZ7c9NaTjlhhhvzdpo+oO32
	 nqTTdSy4BBbNZXaf6fE22dGE4qb6NkQoshHQ7GqKmP0U9elaVKCEjLr9E6IcedI9Rs
	 DsEmNQG74Gg1n1Uu19FekKfzihoMfHu92RORquyyl8bif1R5AojphHltIwTTQwq8QY
	 r4y21ZPFq0CUQ==
Message-ID: <e5c037ac-ae57-408c-8b89-cef4e5951b5e@kernel.org>
Date: Wed, 18 Feb 2026 14:29:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Luke Yang <luyang@redhat.com>, dev.jain@arm.com
Cc: jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 willy@infradead.org, surenb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B4AC1C000F
X-Stat-Signature: a1izxeow8mcrxdcdzugni69dd9xu7jpc
X-HE-Tag: 1771421391-731558
X-HE-Meta: U2FsdGVkX1+SKNQBnNjDtQ9Ytkclch7B3NQvNzhW3FogxWW3Ykdz5rEw9jmRg3ixiV4vNp6dA28vR6Sp8MYSUv36+YP715DFAxbPdXEIvE3uXC1EUf8mr+zWTd95BetsX+CQEC7VYZIwV7fxv7o8+B9Ad1y5WDP2IPtol7cNbPozDL3PDOxf3ahac3ZqrHkv5POlt4SiYKcq1M0vsyBFm2hkCIHgpue55L7Oo0hbhhJvFo1I+MdoI8sTxkXWCFCpEu6T12ykEbkwUQrZJl3caL4ucrhVOWNx5qR5AeJam1P57Rexnj9If2tEG2t094D6TD80k50rut6m1REourocROKGji0rggsyAxGxTbj6JCMvud+3zXXA/GjARIApX6Q3pG3998ozEQ8j4SVEoWw5FnwkHRNJMjJk6n2fKDDjbnEU+lrTsdzf4KtwxW0w5iYurcivRdu6LBsKW7Q6Es89IR5zeMUO8OvP/ZctCsyJGoEkdeyRQThpbE7t4lUbz87bmGiivdMwSup2eevUEAYMAde7wj6UbGx3VRQwPoLfjpY5MlYXbr0tnmxxJfeW3lTslEoQ7dR6YjALbfDp+0zaaPpewyzCeeVnlrfthBfH0Gv7aiPFlBko7MEgcW38cCmEW8Z5YYv6voKTCaxaneBsn+S2/QJfUrlaWxTSrffpIcE7EQb621pbRzfsAfOXT1S/rjYJ0pjjjEkXf0Mejo+hUZHq0eeFqj2nU7xP7e1xsPq6reOVS43PZWlqfnhWKiuLQeH0xZ/nGblNEUNrrgbNLutybvYMSfEwMPSFs0nLyeJZ/1dbjebpSycA6HVwQbygZKV6VRvgvRTaDIDrIi8+Two26LrpbywJhNtoF+qPIVAfjxNI1buhYZ4YitIWesfklpRP2RK/f2BDvQHNViPpJIOiMpgy22JrGQ3lIDqKvVrP9m/HpekpJDmhLljyfrtGc9gsuCNoxFuPuNBfvw2
 qRv0xaVU
 OoIlIFedQ3bamNmgQksiHToNYAopL/jeYqW/1TPioR6rXoNQFD0a2bJpQzszK9z8o+c9KM9ADul3bVNvgozCV0rzB+kLk+vLEh7s7p7UR79jfaj2Fd9s6ysDv9ooznw2PxWH7zB6DPzMhFusDgqkWpDiFoD38CoFzByOZfbSLcM42Mn3Hc+YG0CLEk1dKMcBMMwmjN/9dCMP32k8CLEq9wVDtb7Lt9R5WMmYHfoWlOuXxlZaELyXQVQcMtX6Ahh1o+h3h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> int main(int argc, char **argv)
> {
>     int i, j, ret;
>     long long k;
> 
>     if (argc < 4) {
>         printf("USAGE: %s region_size_kib region_count iterations\n", argv[0]);
>         printf("Creates multiple regions and times mprotect() calls\n");
>         return 1;
>     }
> 
>     long region_size = atol(argv[1]) * 1024L;
>     int region_count = atoi(argv[2]);
>     int iterations = atoi(argv[3]);
> 
>     int pagesize = sysconf(_SC_PAGESIZE);
> 
>     vchar_t **regions = malloc(region_count * sizeof(vchar_t*));
>     if (!regions) {
>         perror("malloc");
>         return 1;
>     }
> 
>     for (i = 0; i < region_count; i++) {
>         regions[i] = (vchar_t *) mmap(NULL, region_size,
>                       PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0L);
> 

I assume that the regression might be more pronounced with MAP_SHARED, 
because there we really didn't ever required the page/folio during 
mprotect() IIRC.

-- 
Cheers,

David

