Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFA0CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EAB8E0003; Thu, 23 Oct 2025 06:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E668E0002; Thu, 23 Oct 2025 06:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48388E0003; Thu, 23 Oct 2025 06:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7D018E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:13:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7515CC0AB3
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:13:40 +0000 (UTC)
X-FDA: 84028967400.18.58D8142
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id E5A0840006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:13:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYSQFszF;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761214418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHktMWgkA59NOlbjgywzEkURdk61yMcemvhRwsjXSDE=;
	b=0wt7Edxl2kOvkPR7FEtWIiFiDB9VMQB4XWg4d7/JWjzzDZSPeH6KqwdJqM3IDrxJ0cPnax
	uPyXqSU5iJDfuLF8B90VMfmJIFLwp6rP7M7KPpcLr1GAWaEILomzllNkhX4ZFxXdDe5j5I
	cMqMdylocqIpF5FKmk1i//v5cjQnkIo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYSQFszF;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761214418; a=rsa-sha256;
	cv=none;
	b=zlD7m/lJYUHwgcRW0W8AFytCO9aQclCtXDmYNLgp/uSnw1KxoXwKk4SuPkZIE8NQt88LKJ
	w3gjbk3cMtezd9MPlXBM6meY7/MLtnESqIX/Gt6GMwoMKKZMYspYlglDnWQzcJBJBzXHkP
	6X4Km745Yt3+ycKTrrsm++ae8VI9oBs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761214417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aHktMWgkA59NOlbjgywzEkURdk61yMcemvhRwsjXSDE=;
	b=HYSQFszFu6Q3zIuIVRHpda5Y/sXYzR2ECCm3Z8d1eQD1ptX5OP9WOxc4bXq7ntlSyNY5qx
	4QYK65BDTL7oul6wtv7vNkZm3NF+nhqN0IYB9KyN1BieoBikCVn6c6kJbkS5a81B3VIWfg
	ntY+z3Riwomq57RIkPylU5i3ZRlpwrc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-a65lVKkgPuiunKiU-9G8BQ-1; Thu, 23 Oct 2025 06:13:35 -0400
X-MC-Unique: a65lVKkgPuiunKiU-9G8BQ-1
X-Mimecast-MFC-AGG-ID: a65lVKkgPuiunKiU-9G8BQ_1761214415
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso288006f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761214414; x=1761819214;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHktMWgkA59NOlbjgywzEkURdk61yMcemvhRwsjXSDE=;
        b=mMCn6/NAkJCbeppA/uLGk6NPrSOnb9Re2ZTcBxKr6aq9KelkrFTVa6lBfDB3ri48Tj
         4qQm+8WJ6pZhO/L2r9uL8wnWP4r4/rkm8M0I0z9mm4LXitqdyKXogI9VTctYyrJc9xtM
         TPzppEmYnfcMvcmhexeL4vCu+tsH7MSpls5FZsyfwxMzqhZxArMCk2KGiCdWQQhMi0nS
         wq538bsh5OZei6ENQmKwaGJY0jmo8VdqcsUQK/+3pLbVTINGsvENqS4VfPA0N1AoY7wF
         6YIpaQ1vRPfelFUJcifDIgnbXZCKleWawJRIuy7Oo+cawFVo4iRzWY6TL1la5p5dTouS
         CShA==
X-Forwarded-Encrypted: i=1; AJvYcCUE2VKMss8xJdo65IPb5HD8oFmRBcBRH6RtYX5lWIJCsS1l+1fmhGqsgWLUWmXAcqAsersw7hhCQg==@kvack.org
X-Gm-Message-State: AOJu0YyhwayKrcr+7mPmbkIF9S60gXE4XFc0415ctbTm+Y3WbyOkFFMM
	vzPkgK5v4U8JqmUcN/jadmjRMq0im49Gc5dCmF0zNx+EaGD4RFlNYq2ipaC74lVvb3UFe/eD3x6
	v3cErEsqw2MSV+6/TGap7FtXPXFoN72kDjJVTvD6p6+8fLEOdjXiC
X-Gm-Gg: ASbGncvvmiDbM/Iri/zQrzhLK38+znstBlWgU/CjJ0ulUqOmczh89wYwOBQoMucYyRF
	GvOfeXyKEPTuSndrzgZ6IEK8bJc/AiWnZLOK3L+yXiCtXxPywz/jUmY0vP9QRr58cDinNeljTBn
	zvLoLqolpzOcwclg7ETCyT/Hp2MgRKTIErQr88oxNDBwyoAEb/hhC3K2l7V/JSHXQnMQLJq7oP2
	Qm9Yld8ukhrGCYtv1qp1b6WXkRXJq2IDKYN0YAqTS6/B4BN4yimTu2WWV8dJYh3gakzaxJkaCuN
	/ACDvfPEUy0z4bCQR+Frvz/w9FGsSQddFhw2zUeNxE43SMsFZuIlqYFJS17YFL45Bgx0p/W8o0D
	VwNUijpmEHrfTBKd2JZjMtzxL0wsh4yAZo+9XODASe4Ih3jD+9Jkz+mVS1pptksmexfA7msLWFv
	5UghJMlIRTUwvRtcYkue22Oxc26cM=
X-Received: by 2002:a05:6000:400d:b0:3ee:1461:1659 with SMTP id ffacd0b85a97d-42704d98980mr15581859f8f.31.1761214414547;
        Thu, 23 Oct 2025 03:13:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdOK/ndovI7ZRSucl6tmxIKATOgZ2nsBavhyiYYvBwP2HJKnKsVN3z8PcSUoWmo7SG+ASR4w==
X-Received: by 2002:a05:6000:400d:b0:3ee:1461:1659 with SMTP id ffacd0b85a97d-42704d98980mr15581828f8f.31.1761214414042;
        Thu, 23 Oct 2025 03:13:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897f57cesm3220279f8f.17.2025.10.23.03.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 03:13:33 -0700 (PDT)
Message-ID: <e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com>
Date: Thu, 23 Oct 2025 12:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 craftfever <craftfever@airmail.cc>
References: <20251023035841.41406-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023035841.41406-1-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K15y3x-YgWLwPRBE7K4WBWBpTyvblCg1AwkD7_tLvfU_1761214415
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5A0840006
X-Stat-Signature: eoqzobyt6jk98gw3fs6q9o6gpbaioduf
X-Rspam-User: 
X-HE-Tag: 1761214417-419340
X-HE-Meta: U2FsdGVkX1/gFUVes0mBGgCHgFXOeQqgBDBIqTRaYfPooLZCpISqm6NxHRRiWdftA13tp0Hlb0tAtv+yK0HM0W3FQxWSFFYP/2mL+ORj0C/nnNbMJUZJhqrnwBVZ++WpMJtIFM2lDUWVruKODH0BCQDwlHdoi9kxCcAVty0E3HWh1XhaOS9dIvoYaatJm3H1FnnMbutOeq6TCgyJHUKQZ+Ttt4Gg3aDH2gUCzHnr5RGbZNBg5/7lzXj+THfwzbLb8YAD2A0IWiYKj2M+CIZbImUIbzyvZUXuFRfpv8IAuZpPcpwlHnBU4rPjKO7V78WReHreq7Oy0oNVzWuka8/RWwvWXRfDKF1hAQ1YOInQAVHeuSHlliogJ+EG0YV6UNWO/r3Vw20D5vFCUV15RJNkppw/9OED3w1+Z+A7NoY81vX8UFTy8n29zsEYQDz4eggDKqPXFwfNUx+rGn5yjOAWX1X8B2NZ5YXDnfMm4hPPs0UsBfZdk+2hI0dnELq0NMJX0nmg47LlgEmKhQBRCu8v9LJmeAlyZy3QPckFwvzzUz9MKwPLEESMAavT/ChwS9ZqEGMjnNFlzH1+PMYJAonrV3pCoKTixTdTomNISoYuliOCxSj+s+TC2/JOKVhvytCfKlywi8VdM0qO9mAjHsmZQroayapstHCx0oTX/2oJyk2ZSdaZBEmltNLUZ8n2/monXi/yWxuPpeGtAMMH3zplOodAUkdENuMjoqBEiXl4JVn5JOpzpbpFHH6dCGXLEVcU7tF0cfHelxL9VXrclJ1rwKlZRygYebONHslqBGJli5qmNLNvTsIKruqAxwhvKp4yivdJ/2cMqtnqM+m7Vt6+1p1xXe8+zwnQB7kkIROEKzztN2Rpk8/O3IZI/zVhnNhFrUC0ngtDDfBeS9jwog9ghMGhhvGt+8yhRM9nT0yIJi8TmkQWhXPTWsLs7Mx4S7DOkJEIfofnMK/Q+/y5r8K
 PzUnopAD
 Nvbv7FxLQKXkmsM3kXGNpD3hjn6ecFX1dRCBCNlOxj8WVhgevPtVf1KakLt54ru8cCvUG0Prkc9RtwQQofHCcBixMH8gBzdNKI/mHmV9w9Ys9VdpMHhsN9kKbXl27EtnqgmC0GTNegPme/BIqq58XTtXGo8W8gV3HPDG+oJiKNhZQPbAfNjLXHLkNhHKU53APNJ+L2/Dg/LALaXeFfqq8m7FYgRNavybgwzOZoVRXw9n8QDDcA0Lb7zCPveXDCZkCpqzaqmW+WVr8N9RDO7EXMuk1+rmI+3qxb2dJvsr0V7QZsFow99I6ETjawdbbwGFJEVC73QQNFvTX1ikj91qwe8eXriGW+FxTe7+yeG9lX2A3Sqwt+VN6kIH5JITt9dU18WW8jvwi85mx3apkR4io0DM6FtSXd5M2fmEWpk1O0UCr9MOnZpVGFgVwVsuvIm9k9EjvYJ3oQfUWmaBoFMgJYWOPvV1JEwvKE0JkGV7RckqdxgwnjTBhP9f5gy7NIsbr3RFr8FgTK1X3r0ijVlcGh1hm7GzqV5UvB9fInJLYiClUWe6aQO2Td+31vdBe332sGF0aQ4TXFB0YYvHg2kkqz7+D/YheJMEk9ydk6EY/aUcCK/0+3EGfGrCGS4ucSTHeGr6w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 05:58, Pedro Demarchi Gomes wrote:
> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions, causing
> ksmd to use large amount of cpu without deduplicating much pages.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> Consider the following test program which creates a 32 TiB mapping in
> the virtual address space but only populates a single page:
> 
> #include <unistd.h>
> #include <stdio.h>
> #include <sys/mman.h>
> 
> /* 32 TiB */
> const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;
> 
> int main() {
>          char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
>                            MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);
> 
>          if (area == MAP_FAILED) {
>                  perror("mmap() failed\n");
>                  return -1;
>          }
> 
>          /* Populate a single page such that we get an anon_vma. */
>          *area = 0;
> 
>          /* Enable KSM. */
>          madvise(area, size, MADV_MERGEABLE);
>          pause();
>          return 0;
> }
> 
> $ ./ksm-sparse  &
> $ echo 1 > /sys/kernel/mm/ksm/run
> 
> Without this patch ksmd uses 100% of the cpu for a long time (more then
> 1 hour in my test machine) scanning all the 32 TiB virtual address space
> that contain only one mapped page. This makes ksmd essentially deadlocked
> not able to deduplicate anything of value.
> With this patch ksmd walks only the one mapped page and skips the rest of
> the 32 TiB virtual address space, making the scan fast using little cpu.
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 
> ---
> v5:
>    - Improve patch description
> 
> v4: https://lore.kernel.org/linux-mm/20251022153059.22763-1-pedrodemargomes@gmail.com/
>    - Make minimal changes to replace folio_walk by walk_page_range_vma
> 
> v3: https://lore.kernel.org/all/20251016012236.4189-1-pedrodemargomes@gmail.com/
>    - Treat THPs in ksm_pmd_entry
>    - Update ksm_scan.address outside walk_page_range
>    - Change goto to while loop
> 
> v2: https://lore.kernel.org/all/20251014151126.87589-1-pedrodemargomes@gmail.com/
>    - Use pmd_entry to walk page range
>    - Use cond_resched inside pmd_entry()
>    - walk_page_range returns page+folio
> 
> v1: https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail.com/
> 
> Reported-by: craftfever <craftfever@airmail.cc>
> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

I think we really want to

	Cc: stable@vger.kernel.org

Andrew can do that when applying.

Acked-by: David Hildenbrand <david@redhat.com>


As a note, we have similar code that should probably be doing a range 
walk instead: unmerge_ksm_pages()->break_ksm().

It can be triggered on a range through unmerge_ksm_pages(), which gets 
called from:

* ksm_madvise() through madvise(MADV_UNMERGEABLE).  There are not a lot 
of users of that function.

* __ksm_del_vma() through ksm_del_vmas(). Effectively called when 
disabling KSM for a process either through the sysctl or from s390x gmap 
code when enabling storage keys for a VM.

In both cases, it's not ksmd that's blocked, it's just that the 
operation (trigger by the app) takes longer.

So both are not as critical as this thing here, but likely we should 
take care of it at some point.

Interestingly, I converted that from a walk_page_range_vma() to 
folio_walk_start() after converting it from follow_page() to 
walk_page_range_vma().

But we never did a range walk, we just walked individual addresses, 
because that's what break_ksm() does.

We could effectively revert e317a8d8b4f600fc7ec9725e26417030ee594f52 and 
adjust it to perform an actual range walk by passing a range to break_ksm().

-- 
Cheers

David / dhildenb


