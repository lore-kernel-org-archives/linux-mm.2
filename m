Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD5CFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 03:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A87A6B0088; Sun,  3 May 2026 23:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3590F6B008A; Sun,  3 May 2026 23:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2476C6B008C; Sun,  3 May 2026 23:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 111A36B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:53:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F9EBA0937
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:53:31 +0000 (UTC)
X-FDA: 84728367822.12.B793FE5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 376D8120003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:53:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DggAExdJ;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777866809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
	b=uhMluoPtvmFj12iexc8//hVS0qzrBaQGDA8RZlhPgI4fzonAO4E8VI+L0ckQW5MnjJnPUh
	XPIZyFU2FH4fV3RZlqAPAP4mSpbVAQ01vztwKj4JdK2dlocRwEwcvyh04DkbXkq9bgLDUM
	8YT4l6beWRZnX9F4elHVUGu8eiWWKUo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DggAExdJ;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777866809; a=rsa-sha256;
	cv=none;
	b=Y9hTe4VlCRyxhAFxuvJOUGMdLBgHQlwGfKHh7KGVxVlrJNES1YofmqmZGDEo+udYaXTO0U
	m3r1mVIXUuoBrXq+Vx6PvEBApZQRQmEtOyxWl9sAaA690hPuZCiChsZ2iNLXNA2vbUPZL1
	dniuV1dIVkGuLyJnNwXjKmnTLIiHEGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777866808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
	b=DggAExdJ9t/QzWWM4gwTcQqK9557AFouNO/DfqYftcycfZ4Dp6gVThzaghN1hK+YAVPRD0
	unu/NQAO80gPQi9wTUBhzaH9nuhL5Tx/dQ5jMk/EqfR2n47uZEvyagTJPo+vCxzO8tmX+J
	pAo1YZBQ714pb1pXxTg5S+H6Ah5fJek=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-BU2D3sUJNeyaE5RNNLmrJg-1; Sun, 03 May 2026 23:53:27 -0400
X-MC-Unique: BU2D3sUJNeyaE5RNNLmrJg-1
X-Mimecast-MFC-AGG-ID: BU2D3sUJNeyaE5RNNLmrJg_1777866807
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6583252c117so5922540d50.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 20:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777866807; x=1778471607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
        b=iMaJL459yDtS3iwXmry12rk+NeCrLeszLJ82KnItBZRmQzYXe43FJOxy1Ht+cJB+7v
         8w4cM6TnGgsS8yP2KI/7lmCwwHotgYsc9Xw0u7r/49NH36pvUiojLSWEvv2VhHe/jYMS
         yOacLX+SiP5awSLKvOGYVR2MVWrVoFNW9BcNS+A7B1dnsYjoHD+y0gUiqCAcJ7cxpu+I
         8D7cuA1XHG/yTQ4Pb1o+Q5/s3P0J1h3EN5SpuS0x1r1I+/wp8UsbIV1mdPO9GQnbBzLR
         G8v2SaLJfIoWB/1SAFB3YKQuzMv5O2xnKIQFMR7DuMeB4kLiHd5JvPEGTp5tMkK1/4n3
         tB2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/TdfaTiE6MGkLd0B/BU4LxEUX29wj+ozGAkwRE5ClaX0dGKNq4CxWg8sHCXTjynY+qlXf/0ZzuKQ==@kvack.org
X-Gm-Message-State: AOJu0YzQqG/GZNk2q9TZihi0VH4rX8Gp0vOdBqPicWE3qc04LBcvXExN
	+l6vUW8CQTAss4amcwuXmePMKNnNcag60fiOrLADHGgWBoFXHBeP2p22Lz/gLrnM6tK6nSe1HJ2
	dLFbvp4oC7WbfFwlEAi67Co0latE3JRDGK7k6RMcZaLs/ydf0sZhv
X-Gm-Gg: AeBDievOcDQzCJoaO4ZkkeOwj0U9ClWu6zkeWZK6iCuhrJ/rM+bqKFiUah14SLabeha
	ESV3S8ONQWOoRT2BtlcUNB3XZZD8atV91EEDdylxspC7RoGsevLlQvU/zqRr8/H300Msg/KQ+Yf
	MUd8hRRpoWoP3hVnQ4VEk+bz3xiGbcHgTWwy9LaDTqUNuxWmnGQfqa3IIDS+VQAQELXCP9dNEVj
	UoC9qOrnTHMc3LpElC1NMC7sn2quLDOsBniG9AUhAovuYzPTHLbduZmANppFymCXFJtKGJhsZK+
	rH1lMZcYXzOJL3zrigsY0jaASXdKYpMdBJBXcJSRi1F0xDV13U4zSzBI1eRW51XZllzTgOswPLt
	wBbApIRtVRRAsPuQyq0YAARwctaLsCLY+U+lK7glXbqZvS27w0sH4TnrkyaJEnZi33m4=
X-Received: by 2002:a05:690e:13cb:b0:651:be50:af09 with SMTP id 956f58d0204a3-65c3d96ca98mr7541963d50.3.1777866806610;
        Sun, 03 May 2026 20:53:26 -0700 (PDT)
X-Received: by 2002:a05:690e:13cb:b0:651:be50:af09 with SMTP id 956f58d0204a3-65c3d96ca98mr7541955d50.3.1777866806149;
        Sun, 03 May 2026 20:53:26 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c2e8b2e55sm4980740d50.20.2026.05.03.20.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:53:25 -0700 (PDT)
Message-ID: <b3b5cfc6-e61f-4904-ad2a-dc1f53f04838@redhat.com>
Date: Sun, 3 May 2026 21:53:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-3-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-3-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HcPj7DcVLX9YhdTcVKl4o37mVtn0P2xH5LmFJMhQoVs_1777866807
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d6ha8djhfexa3daq8jkoki1fw6jj6gww
X-Rspamd-Queue-Id: 376D8120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777866809-782313
X-HE-Meta: U2FsdGVkX1+eaFHXmUGKs8D4RAycYiBhNV6nmgb4lbtBVcDSaH6OMy77LHRdlInjGNX33cNc/FbyojeaamFsHsk3NySH6ZIDyyrK2+cD6ZUR8UENfVuPAjQl8Js8FfgMYws2xHUxql3IYBhgwWDWrytKn8PPwjo5vJcOO7+2Bv4HuKXOJ88Cq4HKfeVai5BVjNi2bCGhVbUtFZtEb5/tyOX3qGawKbBHyZLtNKQJnbIJTyfYhjOggCGXwsEc+dtO26R9NqW9zipYiTM7JxwMNR0t0NCQpl+yE2rxbi7lcBTLhwiJYDb55MPT3uDVf9iCCTc3yP+sjQvFT9o/wwBiVinyPE/poMzdUEk5Rp4/S96SRCFWJ7SJ6cntAp9fKdK+fzb4pSD3Zx2ak0VQKOHnQsOqusNi1MnvUQFBgNHBxk9kTbam5/RHfYBl8XFJpZ/cNkuPh9xX8h9V/AVHlSbIbx9c2H4b3iuUzdi+S/d3m0U5i+dtAh3JHkYGzqXlBmnDAodUZxSwcrZoIBjnVYzS3eCPRgucNT7jFrm77h5ASSC846tKnSRL5t4xn7YS9JHHgb51eefIyF8unVNQ9RJauTSIVrgElNGVeQ+uTEg6l9ZmzXuFTZofXW+Cw2WyqZsb0sNPqM/Zv2i7rbRNQn81amrNQz7PLQR5rNPfadrAmDmYL5XafTkqJaS+cTmcG6uaDP7EF9kITOTToDL3+TnkpEmYeNyVIaE8FT/8QTyVFvsY/w5ITErZNjGpe7HwjHwdpyp1QryNL4mKtUj+85ndhVc1nSgP4nlhA9JB53+TuFF8Y041hsDZlTS+gCw161guowcf5QxmhDFnJV07borLYEGt2mYM7V3Q6HcFVCU878j3N7AjNhTh3diJkrcxGzO2uf0//nyBD9x40fBIveX6qb5FMCCuic3aJgbWCPixyEAjEVFNBdCjh/edcUGFYsKoRsgMSvwMqhAsBBCejZk
 +ztvIEyq
 voraFH5+01oMhe/+ok+48gWsk8K2IzU3Owu80mONbmqwYvze6YNgA0tVdrM24Lfv43l4NLQKtEGJFeJwc2M1CJSQllI7/80vCUYi4m03W4EwO5kRjDDsNzpvCFgHNC/uMS4YCh6WrGhHPmPj4BXVO6sn7xdweTjas2t4QxpgkNq+lpOveZICyDn8C483egdOhppkIDEVxZZ/p5DgSew4PxVu/pFJt1kdpH2ulfiVCdMVUDKVfhTRZGcvwN8hB0KW7SXTgGOf23/cJSMH6V5hShMVzuiaUH8mpBARW8T/d+LmuHXEV/n4chkcLCnlp5NhcKcemWNmaG+rvbpyqoMnrMQVENs2hsSsyDhWv4xbqZmGCwHShsJirk/Z4Ipc96+cwIameqY3PIC1h5oVtJpVdzQ79VOSTAzlH0c0u6AWDjyQ9D7PaR4ACO/gtleZu/j7cYxOAt1qs1GbN/UaNSas1/Z6+WuEfW5L/AKNX6D3Q9EkBFW4WoVuKDAHeUsL85Z7TzM6R6pMlx0AyjGmD3rWKsiAgVtqkuDbtgwKK5BBXUfgkIRqFSNVy+xngMqNffauNOmdb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:29 AM, Zi Yan wrote:
> This check ensures the correctness of read-only PMD folio collapse
> after it is enabled for all FSes supporting PMD pagecache folios and
> replaces READ_ONLY_THP_FOR_FS.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio at that point means this read-only
> folio can get writes between try_to_unmap() and try_to_unmap_flush() via
> cached TLB entries and khugepaged does not support writable pagecache folio
> collapse yet.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM

Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>   mm/khugepaged.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6808f2b48d864..71209a72195ab 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   				}
>   			} else if (folio_test_dirty(folio)) {
>   				/*
> -				 * khugepaged only works on read-only fd,
> -				 * so this page is dirty because it hasn't
> +				 * This page is dirty because it hasn't
>   				 * been flushed since first write. There
>   				 * won't be new dirty pages.
>   				 *
> @@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		if (!is_shmem && (folio_test_dirty(folio) ||
>   				  folio_test_writeback(folio))) {
>   			/*
> -			 * khugepaged only works on read-only fd, so this
> -			 * folio is dirty because it hasn't been flushed
> +			 * khugepaged only works on clean file-backed folios,
> +			 * so this folio is dirty because it hasn't been flushed
>   			 * since first write.
>   			 */
>   			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> @@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   			goto out_unlock;
>   		}
>   
> +		/*
> +		 * At this point, the folio is locked and unmapped. If the PTE
> +		 * was dirty, try_to_unmap() has transferred the dirty bit to
> +		 * the folio and we must not collapse it into a clean
> +		 * file-backed folio.
> +		 *
> +		 * If the folio is clean here, no one can write it until we
> +		 * drop the folio lock. A write through a stale TLB entry came
> +		 * from a clean PTE and must fault because the PTE has been
> +		 * cleared; the fault path has to take the folio lock before
> +		 * installing a writable mapping. Buffered write paths also
> +		 * have to take the folio lock before modifying file contents
> +		 * without a mapping, typically via write_begin_get_folio().
> +		 */
> +		if (!is_shmem && folio_test_dirty(folio)) {
> +			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			xas_unlock_irq(&xas);
> +			folio_putback_lru(folio);
> +			goto out_unlock;
> +		}
> +
>   		/*
>   		 * Accumulate the folios that are being collapsed.
>   		 */


