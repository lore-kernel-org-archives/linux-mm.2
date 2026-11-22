Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75343606A695
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zF9OvarD
Received: by kanga.kvack.org (Postfix)
	id 8A41E6B05B9; Sun, 22 Nov 2026 12:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C746B05BA; Sun, 22 Nov 2026 12:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C176B05BB; Sun, 22 Nov 2026 12:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41AD06B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:17:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C52294071C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:17:00 +0000 (UTC)
X-FDA: 85463410200.28.E047999
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA373A0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:16:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zF9OvarD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367819;
	b=3dB1bPomYCotPaVP0aaWT2laO0HAo9rAaEaWXHHZsTSW92W7hT+HT9lcrzgb2x4hsMBLNU
	O2MnHxMzjuZ/9kbKOZUtThwaoeYj8/tg6Zn9zW3wjGH39SBm6klYXGB6wzk6olRkTkumn5
	fgqAqbyfqgQRlZE6OImQZ3vpV5N+EaI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZBVsygS6D/XCIyZiy9rHnS3W7U40v2cBdi6mraqHsc=;
	b=uRpgIls7OfK59pT7a464uECMKRW7bhBzVcksGoqI+ti5WflModS9r7nwvBFczrACjpKUfq
	CDA1XsHfAzZUlMevpftWYNfCO2H6kNSY+FhgTwX8kEF42zyU8590xmHrFkK25rSF733EOI
	tMUNA1pINMhe0GSyd/k1dyv//5KrSuk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zF9OvarD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so18905145e9.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795367817; x=1795972617; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uZBVsygS6D/XCIyZiy9rHnS3W7U40v2cBdi6mraqHsc=;
        b=zF9OvarD0KjOBdxRKwaQxMn4+24Ve2UkdKgpiukaMGUbQ1TqXBi09yPYRxhE+KE2ha
         L3+TXb4Zf6ftcEIWaqMmQ0ge3qbv2PmfG8pvEnRnLJTig+viX2wTrqcOK5ibPaD2HI1x
         SfuMDsZhSB+iziaW79cFJrAwlQf6pRxoD4hKTP3XRS2asLlLBhxEolo8aWotOf2jxLTs
         NAHyQCPm6zDyu2wwFOzScYoEG7P1/bjR2ecVC6rG491EblXjtiSWs0jMd+Yldfytw8bZ
         2N7gXl6dWB+wfeAwSccQTg58TEmQOBqO3roSLmkq2kvc5MxnPk4234oQVKxwLTY+6Qh+
         +kiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795367817; x=1795972617;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uZBVsygS6D/XCIyZiy9rHnS3W7U40v2cBdi6mraqHsc=;
        b=k2Y6yCDqiIS4ZWLZ+EEDHpqM5GEhhsEVvtqnD/0yMoX7GpsnfUkWGF0a0SNM9uvk9X
         k6nP0wNU28ZdN2F7o8Mmrubhy705JPPheAXHD/q1Nt8wduF/AD4fovRoWlsbg3EewExQ
         /I+uytAVzDx2xHcfzsiLg7sRH7XWxVe5InuxCpMXImKUoFFCYA6br7YR+fPxQBE7q4nF
         STyJ7s8vCntsJbyYZ7C+rI3xniHdjdO+6Rs1yIoemgYr0XdT8S+n8k6r6MoLT0rPPIUW
         n43L+q8xtKSVsgsvAxNv/exgg/jqGdgKU52TeU7R4vRMhmHiVCen2EtNCRWbrVruMe7u
         pN+Q==
X-Gm-Message-State: APuU4Z+Iceh4kH2w8L++cHAqYkgDkGxdpau4jI6KVFCjPYzSQzoWibR+
	++UIXNzEpHS8gS4/UfxGkHbAaAj5JCkzGQdjM6b2zMkS5AVkATjG4i2t
X-Gm-Gg: AZFdTZckxFxnH3j2Bt2uNdrYtzFa6WiHFEf77w0SSgBqPBeVrhxT3XiiHCrJhmitEOL
	4hEuFGR30SxeEF+MJEq61i8nmxEWrSGZtbHUseceJ8ALomURug4JjljPU9vGnVZQmCtID30YIS5
	rCGAA0DTuuxP1Xxg712oRDOVaAP6DnIHbuDwq1jo/Y4hVlanmleeBx1P1q1crz4H4eWLGL8azVl
	oKGRGAKMMhIn1Uyfxiqkps2O99cliF8Cg2SE8syjux+IbwNJShEKJ8MCPGukqwpHWdjzTdGutSv
	nBfyFVHYQYW8vdYYuqICPiOI/8NIwMfN4CY86Yf+lNZoeIgOm+aiRzxLF3TB2Bb2IValKDp/+xX
	SUW62n7duRbPcP37ZaLYL2yWE2B8AgAgUDPDanqJKyZ7cehMzTelWCuxNKAo2au78kEOO7v1APJ
	EtZElyqRuip3LIUDXvRQGB2o2dDqgnnYy8MB6xDjhpKZL+GZhcxSEQUTk5g9AW3bFN9GwfZaiTh
	4AI+UqzgcTxBAt6Zme/lnwv4LAP+YJyBGKKp+/2qZ59M7ZJvrEEqbRYYLiAwGRPt5s1UGhAtbBM
	pdmrI35OrOcPZUtuZboFaGEZ
X-Received: by 2002:a05:600c:674b:b0:4bb:6947:3e1d with SMTP id 5b1f17b1804b1-4bb8892c0fcmr182147755e9.20.1795367817148;
        Sun, 22 Nov 2026 09:16:57 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf630esm18145971f8f.16.2026.11.22.09.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 09:16:56 -0800 (PST)
Message-ID: <2da64337-5135-46ec-b7ef-0e1654f76238@gmail.com>
Date: Sun, 22 Nov 2026 18:16:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uxpa6wnn4bejm18zrxj15eks86wkgupw
X-Rspam-User:
X-Rspamd-Queue-Id: DA373A0002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795367818-870769
X-HE-Meta: U2FsdGVkX1+0jNoVmPCv/QYOgpga+bnUVFrh0vHe6DZu7w6TFOlItiPNGHnpvWOl3cVyRByFWMMHeDghIPh2TotxagUKfe/gAzYAFBgwVYp1/1vGRsvd5NuzxFvlHTOfQONv6NomWK1GYSwJ8SzTO3KGIP4MsPhDw3pmjDR8ISjmHQ4oijtjY9dgCOJOwgVUgCzrqYnuT24h1x7NxkiHObfulzBcX9DEfZxTrxfnDfk8MNH/Z27UKVh1YzbXWcm/6rGxa913LtDQnEzdgS3MTkiUD52GI3drBZ9q3g3HIs2b8ZGAfXxjRENb8NkCC582UsYOSdCbjtZMVmppRmFqiIY6GTrtLP5aP5Sn4XHBjLXx+MHFQPSdDLAsi84MPCmE/sRzMjcSA/x5ZidRYwWGih6UvF9Va1nQnkzjTEtQsOmBEhXjNIrSLYctYHF6mR8wJb91NaC1Ry49mjetRH3zi51SbRLiMdnOV27adMEFzPdzBMIUglgS1Vb58JJcvu0Jc2K3Q++e3gdtqOThfgqccqmc40afK8vLIQ8JynrRRbs6ncvWWb/1cPyvSkQ6AfXcM1yTrWoFCjN1FRYBEF5xPG83n7WRp8rYY7hP38GiTYVPBXbGR1yFVjjva9h3pKjMStyYnC35BtV27sZNcCsOsOFegs5hJckoLaAB7pboCVFmqCpbVPtqhrLIGGWmJDt2V8hqs0dNI72pJ0rKMZv6KWsnoesyYUUR8a5+R/5zg5bPbEOMEBdmpycClQLci7R3dKRm5nqEAQMYedFeHLwF2rVC+PH+IYoR5hyZnQYSaSpVBLyl8PQ/jRnrn33OadpCKu3JYtOCx9qfHIydTbBMB6eHtN+IIDOGsrtxSV0Lm5vHc6wdyp/uIL21MGTyRZNRHPw0K70a5kJmkrXBAQTkppXJfTD0XlKO53X8x4wueWyrR/Cwnds0JnX4y9Ir8HEOgCTIGzQR6eOZIpTIeSN
 C0GVb8pF
 SMbDK3iAjtjXBtM0CqKeQOIGtl8XSUTkNSrQ39lonI89G+/kknrqMPp/il85XHWVnk83Hdd1Ec6Xv2nttdUuiGrt1/rp/eimQd0RA2J45vv8OFDOo9vcSk/+71OkidmYARwJmpr1bNwBJvga6kqXLZryAMQL9bz9BTufFdXrC0qAZ0q+FJDkNu2xaVGJZg79WPEcf8agA39+BxgXZhVVWkSuhSHrD5nIUsovwReuDOlEpW2LACHoXK963GSLbmdcvwQlqBLquqXkP7AIK0bgtlm29eqqYT5zXqskVka6ajIguYP9DMxSFB8rw4m+G42R1J63MgA299mbVV8opJndc5y3q9E9s+GBSRPPClLm2wFdGGJoZl7Wk2Om83bQHiRN0M6nRX9fGgrcKVEpe5LPWvxfimFGLQF389ll03n9/ji9qkQPVK5n+rPoiTZ1fCg6xf7kW6tf04xCPbgGq6xS9C80zJ1LTsiF7A46yifH794R/b7Sbz5r3dCxg8rxP8sin8oYR5vBHR6s11s+4qsZ01PH7rT4jFgAMwuXE6GHvax2ZjY6IDyBedikWTjsV8R6zdHL2LVIKQGVejkTVPOXpudpxkFW+BDgHgZt9iR3govYYGRVqfz9NjrD2a48e4YZiL9jtuMCekGhPWqqRon5S/BAVqIYsvsEtXroQ4RGmZvEZmeaW4zzFgPAtc8M17e/lpOCDg9D+8bR9QnU2vAtkSoYmtyqnx352yl47bORzXMzds1M4nAjGA8ee+p7THIMB+MmZTKxJctPBf3DeUJlDEO3nutVXwMaC/xJUMkdu3GzWkZUBj6VSLe9flphOUQczroCW3fbsAdtn+ng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 1:42 PM, David Hildenbrand (Arm) wrote:
> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
> locked folios without holding a reference on the folio's inode.
> 
> Splitting a file folio might allocate memory for the xarray and call
> filemap_release_folio(). If either ends up in direct reclaim with
> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> wait in truncate_inode_pages_final() for the folio that we hold locked:
> 
>     try_split_folio()
>       folio_lock(A)
>       split_folio_to_list(A)
>         xas_split_alloc()
>           try_to_free_pages()
>             super_cache_scan()
>               prune_dcache_sb()
>                 iput_final()
>                   evict()
>                     truncate_inode_pages_final()
>                       folio_lock(A)
> 
> This requires that nothing else holds a reference on the inode, and can
> be triggered most easily with FUSE, which evicts inodes on the last
> reference.
> 
> Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
> cgroup v1, memcg reclaim waits for file folios under writeback if
> __GFP_FS is set. That can deadlock if writeback waits for a folio lock
> that we hold, for example with ext4.
> 
> Let's fix it by splitting folios in a NOFS scope, so callers don't have
> to care. A NOFS scope also covers allocations that filesystems make with
> their own gfp flags, for example in filemap_release_folio().
> 
> On NFS, splitting folios with pending writes or ongoing writes to
> fscache might now fail slightly more often, until these writes have
> completed. On netfs, only folios that are being written to fscache are
> affected. All fairly irrelevant.
> 
> This has medium urgency.
> 
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
> Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

