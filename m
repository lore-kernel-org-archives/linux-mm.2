Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8256360A260A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=adR3sfo/
Received: by kanga.kvack.org (Postfix)
	id 9E12E6B05CD; Tue, 10 Nov 2026 07:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B85C6B05CF; Tue, 10 Nov 2026 07:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD936B05D2; Tue, 10 Nov 2026 07:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 668406B05CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:00:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0D171C41F7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:00:23 +0000 (UTC)
X-FDA: 85419066726.22.A357741
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1181F80005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:00:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="adR3sfo/";
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5X3zb3VH4w0Ie2RKn7QlDBjKtcvMvn58SYuQeOEmpyc=;
	b=JR3SvCUHZRx2dd4/iAxFHYchF8CEkwpkDGrFXLzBX2yDKXGoItQE0+g8onp5LtWEaZKCBj
	BVVY0omE883HcTBxddmfrSrUNNStOjOwxKUjfrvOZIZ2/l4BD0AKkkSHsgNsHiV0fkI0Ar
	sU1A8WiPSExkm8dfSrjTv6Ngwclsh94=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="adR3sfo/";
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312022;
	b=tkmpUu5iOYGmce4nD1vkz2HVvanSrn1mr3e/UzmAek9d7rRFjf5J3+82VAiGqZeALY6lKD
	sUSTmJzB7esU2+bomRq5kIikPageZz5de531Ym+vBA9cm122+3papIBDM8uy/ZLQ4AXQsN
	yW2GnWzxpym5lCQ/j88wiG5sEeGFwAo=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so20451085e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794312020; x=1794916820; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5X3zb3VH4w0Ie2RKn7QlDBjKtcvMvn58SYuQeOEmpyc=;
        b=adR3sfo/hT9jKGCepxqltiz5FVb8uXgAjn79JOCkKSo/1H5efdADuItk8W5JUyznO6
         uoUKE/MHARydOhm5B3J6fahgWy/lKJQJTz85F9B7lYiFtkbVAUQt1lFlGKUrHUCx+YoK
         2JWZ6dEP4xRdvEog2NBPiTGXc25RS0+kVr345e6+H5vIO8rUoxK9vsWyPcKdwnVhYBcX
         a5uL7AXeIzgilsmfKWhVJQl5+QGnGn9yCIC8EvJZpMVHcDVU+7X6vdRCCy6KBoQsGXuj
         QeUyOQWiPF/GkCDojRcdMnTQXgOs7OQR1OvhQo+EWY4B7WkuwmIyoTCOFpIw6DGzVf10
         iBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794312020; x=1794916820;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5X3zb3VH4w0Ie2RKn7QlDBjKtcvMvn58SYuQeOEmpyc=;
        b=lug/FFo4fE5kOu/FgScYaWl6LBVuHdJGYRf/fN3uQ8QX/9F3LMlge+Z5X6gcxwXmtu
         eo05X1Ag/5WVqInBdS2AhlITM8MA2Z15vMe/c8bbeSK5vGsOcjXfVNkoh+9Sul+8AB2C
         SX5XYPdfTONx1XnBlwuVYeaI+3RiXmXfFqcNJR0f+15S152VcDsha2jAbxf/+7lx3ktf
         eNkxlnMiZx6M/4aooLjQQcOqkTukZQMBXIUwA6mq5HoPpJkhER0gRe+jE3+35zpBK3HW
         9Pukyvx2AX8huHwCqHmsRcC2i6BtqqdiazAM0UVyqkBLSot+poA//X+MfmtGeQQthTQD
         KVPw==
X-Gm-Message-State: APuU4Z8IGUG6UTE45wnxgxLjPgnkeKzw2x4Z36V8r7HJm3D9aqGZ4Hqg
	mpTkWP/lOmW/EFZnAAyGTpdIEi0gYZ7WMfv3phIgJEy8sAKOCQsOHoTS
X-Gm-Gg: AYBFou2DDdggegAr2EONIuRK8vtYdylXB9ohj7Kx793wo78eQ4LPmIFYPYidOHBPd32
	z8VO/7bxcOgnSbXP7MdNAXUM5jfQEc3W7SsBCx29DCqRJEk+WgjgW06NQl15xJwE5RZkg2fpkQu
	QkvNaA45PVBZWZy1WbEHtU2gl9wLKcSvPtKlqWedZKy23zpAfP/vkNe7A1v8yvpAj0LsNB6xFYH
	1CXdxuw1J9OclJdDhIf0KLGGmMpRKWVljA3FuNfYjR4c8scx37aHSesTLh68KLD8PMNCFL9cXgt
	nVhXXQIP5rjpRH1arr4RXhDLGR0gl0E4/Lg36AjDI4ruUlt/rLEoQE4dbAj3gv5Aagmq8blzfjJ
	6xZzrTB2ODPhexSDAQLpzESFJzRE7rEvygKs6gYBS5wWwna/uf6rco38fBuLpEVurCbJ39Ve5Eo
	v+N1xGEOWBYkfy8xnzyEi/Nykj6gFzMRv+KlDWqxA8ykImimpUZXrODZSGRiCt/29Y276kjt3XW
	NUA8ken/hwpU/Ik18xZll1SYT1g/Z7uX9a5AYLm/mS388UmrNYtWK50kl0qJeHIOUqsDmUGYZeo
	zhHuJNfIAi4g7ULd8HZvwqYL
X-Received: by 2002:a05:600c:3e07:b0:4a1:e69d:90e8 with SMTP id 5b1f17b1804b1-4ba0234a8f3mr43245435e9.22.1794312020086;
        Tue, 10 Nov 2026 04:00:20 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fea9eesm97526925e9.11.2026.11.10.04.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 04:00:19 -0800 (PST)
Message-ID: <d4bb71af-cd1f-4d42-b724-916064f4cf0f@gmail.com>
Date: Tue, 10 Nov 2026 13:00:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
 <c8dd3102-38f8-4972-ad2d-97545fd8c8d4@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <c8dd3102-38f8-4972-ad2d-97545fd8c8d4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a3peu51hensgefa3uds4dtiygaa9r99q
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1181F80005
X-HE-Tag: 1794312021-709868
X-HE-Meta: U2FsdGVkX18Vlp+sjv2eyIhO5fVUrKTc+SoUhZ4g3uTW/9/dD3uH64r+MJ/Fmc3+PNTwsS4p3GjYPEcx9Zk6HGajD/wZEjYop2ej/d19RiNxMsl4bwDrZ93HSyuG97GAZk7DQt7zVAwMkvht9XrnBe9hGrjjh7DuVov/d1TC9QyVyWOVpILlMynou3KJxOAit82Gmw5wOhhhH/goK/HgsJ/6kVrfqyBYuIHr94y63T4B2QfrURFS0ZPgcF3r9/ditBJ/8FF0l4OzZqKsUMtBLuxmsmaKMRYf/i09WNt7JS2muZBfnYcz/4eK9UwmBQm8YHoTM/eYK3DoOHNBZPBFmzHeu48f+l2x/Mm1nyqE0rm5kIpa9+s9wVEkqmsfbUakdECm34t1ZuP7AwMA1v5ZJSgfRRpv7o6PwE+ZhOOi1vQvqFF/ZWwbossZDkCEgnhggjMN2qvufh7Xuir8iro9B4Ja1KBRQIJ4WoBrZDnI0AsxKNWCwGWp7YnCiSIBPQzXi/YuPvbt9/nyXJmxuc4OlaZSt7OWYd1abefA2g92OD6bPs+ZUMbwAhJGiTWWE1Bbim09W6kZ+pxL4hw/zoRLVZYMcnz8DUuqm4OJq/R548bpoUzdH9iFuePs60xZBsbHIi2RDYs2O9abbiJ+GPhB0pa4eiZNpiKUQtsh7PbBkSvtbMTxZRdlT7XQhuR8ESDzo2xeDaHs+IerQelF5F7Ob96J9zgm5KpfTEwtf3lOYyUlvB4xNHQ3uZQ8IAncAhRxwxtKTZq62K9WYJ+zYB5BbqKwnvCDEr8rjHAku8J7YBBLtvkGVi1C2v+8Ha14SpNb0OeGb0Moe0IFl9piQVDtZmlnLMjkAO001kCh29yO6NJSfjhk+5B/lRs9He3u8Tu4OZGH/irsYd0BRDoUDVWGaeS+u3WhTc5BjbyXmqQ7QXQT3/ACxY9EG0wVX+3vMFRv3YoRKVDLatLwN+wV4vU
 8jXjwS4I
 F/OVjwgEoj3zS6uNl+mtqemJRViY2WwbFY4RJBmXE1IliAdMeQfreNeOWaFfxINSWXqMUHVXzGGMUn7rKEqjLVJHqEtFqhkT4WWMH5QCN65dXcMPjVle7HqAUZbnbwILTw88PqDxvcs7V/cpS20FhNT6A5JeQP7SPGuG1ixiRPjQ/nzyL0zwqZfFcIdaw3ip8xUENWkRqhuHIzlLMm8vus4C4ntomLbk64xDiutvWnSohXEhdkoNkRUe/6pNqZ1UHrAWh/UybaXHdHJAI8cSPP0OTdwum1y/4Iz+3cx4HPBhRFTr7UG+JrF5WMdEXRcqCLWpBWVvpxwbLzSS8dcx6/Ck+5g4OdSkVkUJWK/gZLlOQeOJSbGDNuaxIhT0ZGE/ZiP3Ttaz3aLmYqn+xqUHei1Z5EBl/kW57WA6sf+uyo6pbkLc6A3nenywKzxZ1lbVLtE/MjsUTXW2lyk3OZZAqXqfHOgnra0CQ/VS6ymaN4EzZyeVkJqDltgL6BzdKkAbcdfOG2SDRj10B4hBQ8N23VDINWK2QrSg7p9iwmAaNvyC+dO1aVbZ9xzwP2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 11:38 AM, David Hildenbrand (Arm) wrote:
> On 11/7/26 23:23, David Hildenbrand (Arm) wrote:
>> Similar to mapping pagecache folios into page tables, let's reject
>> additional references when splicing folios into a pipe if the refcount
>> is at its limit, similar to how we handle it during GUP.
>>
>> This will prevent more cases of possible folio refcount overflows with
>> large pagecache folios.
>>
>> Let's keep it simple and check in the two callers of
>> splice_folio_into_pipe(). Return -EOVERFLOW if the limit prevents any
>> progress, so do_splice_read() can fall back to copy_splice_read() when
>> read_iter is available. This keeps sendfile() and other splice users
>> working when ordinary reads would still succeed.
>>
>> Also fall back to copying in FUSE when taking another reference through
>> fuse_ref_folio() would exceed the limit.
>>
>> Also check in try_get_page() to cover pipe-buffer duplication by tee()
>> and partial pipe-to-pipe splicing.
>>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  fs/fuse/dev.c      |  5 +++--
>>  fs/splice.c        |  8 +++++++-
>>  include/linux/mm.h |  9 ++++++---
>>  mm/filemap.c       | 11 ++++++++---
>>  mm/shmem.c         |  4 ++++
>>  5 files changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 3641abb90d6bb..4f6b7b42bfd3e 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>>  		if (cs->write && cs->pipebufs && folio) {
>>  			/*
>>  			 * Can't control lifetime of pipe buffers, so always
>> -			 * copy user pages.
>> +			 * copy user pages. Also copy folios at their refcount limit.
>>  			 */
>> -			if (cs->req->args->user_pages) {
>> +			if (cs->req->args->user_pages ||
>> +			    unlikely(folio_ref_count_over_limit(folio))) {
> 
> Linus points out off-list (thanks!), that fuse_ref_folio() should have
> really used try_get_page() right from the start.
> 
> And that we should just not fallback to a copy, in particular,
> if the refcount is invalid (<= 0).

now that is said out loud, makes sense.

> So the following is what I have for now. Once we remove the limit
> handling again, that code won't change, which is good.
> 
> I went back and forth with folio_get_checked() naming, but decided to
> not mix in the "try" as that just reminds of our speculative refcount
> handling. (folio_try_get_checked / folio_try_get_referenced)

agreed with that.

[snip]

> -			if (pipe_is_full(pipe))
> +			if (pipe_is_full(pipe) || *ppos < folio_next_pos(folio))
>  				goto out;

nice!

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

