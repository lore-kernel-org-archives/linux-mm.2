Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343B6E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9595D6B00DE; Sun, 21 Dec 2025 07:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931826B00DF; Sun, 21 Dec 2025 07:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CBD6B00E0; Sun, 21 Dec 2025 07:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAEC6B00DE
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:38:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F82116084E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:38:35 +0000 (UTC)
X-FDA: 84243431790.11.B62C28D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 254C01A0015
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:38:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YQcb2oCH;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320713;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKd1omiKDIcMLE2GVnEeEbOL7CbBL2uJXl9dtv3whtc=;
	b=POwzgtA8Q6ydAywyPZ+D0nRVukawuEJjyg6eY1zQCgfuK3R3GBarzpkwuNI84e+jY86OZ/
	P4gsgshGDTCK15rQ45I9igLhGAsrViLhhb8uFUBwhcX97tvdvcXnG6cRT12tgtNJoGwXEn
	NkihyR1QIAXChS2IvNZnQaOO53G9qeE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YQcb2oCH;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320713; a=rsa-sha256;
	cv=none;
	b=xQZT5ZUDM9eL7TLR743DT9eNbKk0bRkt7wF4fVKimn0K8FGFjiWHswu+iJfWIOJwUaIduc
	mrAf8/nm3a4s2qSWvhUgixCEumiNcL6v8O6ocwMZVDVXKwc+cX4ANDKP1t/VLuQKXpTRBX
	egeRG43qgc50EYJR4Vo4NVxnorCqMf0=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b802d5e9f06so380022366b.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766320711; x=1766925511; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vKd1omiKDIcMLE2GVnEeEbOL7CbBL2uJXl9dtv3whtc=;
        b=YQcb2oCHcICT+zKsUq5Fu//Cq6GcGoTZVck4dJq7McfLuRSA8tbFlxtJxHDhrSZtgU
         7OQNaWxr7rK33rehGlRK5yg8RA/ajIdbu3pa5q4jkiYUqre9q7LYQtSD36X5c3SH+Uxc
         c6W8ra/p2PR8yG2omET2Ca1D8E8LX+5FXpGKN6EstWpYOYP/ClNYQu7s8nIWc8zOpqmS
         QfCUvjIdt0YAHC5ZNEnotIuim16UItr8uknMVjXA7XUHrj96BALnGsqtwg/uJ1TSphtd
         rNKzr/CiwmsiR5xnn3T501m5Bj3LiLbzgrd2iUGeqKlkk3omk+rJfZNzKvgNhlbeyfyU
         Eifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766320711; x=1766925511;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKd1omiKDIcMLE2GVnEeEbOL7CbBL2uJXl9dtv3whtc=;
        b=AXbIthaA3uObo4XwYv53fKJMbgLbM4BsiJDIlQSWi3N0I2c0mK7AThe1RXpcS4UZpf
         d8VDkggc/xQwOHlrzzQQXIcGj77+ZgqV5vI6oqWstBp1WJs7I8aW0wDSZW3lEz9VQ+wI
         zhrIl/pytqIViBrexeZqXp5mplGMTdjd25CQasoKif9yWeh22aZzjlBsPYRbifNHOt/Q
         QydKKgmBo2bi0POkaukhpw3ciNFckb+WTwycp1Z92S30nLRo5NsPOxKsJ9nrZj+7cTCz
         4LR38k4UR7noviQc0xMld6xNW6FRmGhSzhIFBc0TYB3BAfZe5C04vYkKQ0nSrB/9K7rQ
         OzsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOYLWWSNH9olvVPJds5UWNmd6LN4DPeKn44ll9WgMlM7n6HBLrDjaArbGXd3v6fQke1YaZ07wULA==@kvack.org
X-Gm-Message-State: AOJu0Yw4NaRWLioWjuu9kUal7DDt70/89HgRo3wIlVslSX9W+XGo1By0
	02qHDgXSUXfxgKPijuxEQOdymDaYP7G36+6er6ER4w0x7CcLQO9PUkqZ
X-Gm-Gg: AY/fxX4Pk1ESlDzOIpn2G2WoHM9rxLMod+64LQfGRCUsQbZUthCjZjSxeK+Ogo/Njfg
	EwT86zk0/zfQLEYLwWiX9li6jI5bNBTGfp3w3DhsgaWD+2hC9Liz8uqI4deNFX9UaJELYDN++OE
	0U7lgAn92JFM3nva5+A7PNQOsD9RnDgyJmdkqQKZJBsWDwVogH6XAaoTwVPl3k6ksLvKa9ncQ8J
	vOI5527BNuRIaOnLszde1j5K8sS5aEEq6PX9j9FeyBys1HTATtG4Ug80sgIJMyLiivvMsx+BflH
	LLCb+6KJMyRUFFYNDbHECu0k9XL52APZefYMiV4LvvbC93IpVjZ0XGCTrgyYIoMCY1DPOb1ThNd
	xCh0o8EZHbJwv2zY1xrjwqWGiHZ6UME6UujYvG8a3O7zChQsDnKT3kHgi/Wb7Ny1UjaIrLZUnJU
	DQxKVR2DILQQ==
X-Google-Smtp-Source: AGHT+IEPkBYxKxvMO8vTyzymRyaWpcIIPKSU5dbBhuwDl9GbH/oMHllfQOWCXa+XEUq44H92noLtRA==
X-Received: by 2002:a17:907:3da8:b0:b7a:1be1:983 with SMTP id a640c23a62f3a-b80372699eemr943322866b.63.1766320711106;
        Sun, 21 Dec 2025 04:38:31 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ad8577sm762477466b.24.2025.12.21.04.38.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Dec 2025 04:38:30 -0800 (PST)
Date: Sun, 21 Dec 2025 12:38:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <20251221123830.zr2szhudd6pdq7h5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
 <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Stat-Signature: 9tma471bq9811w94iyb5onukbi6zjres
X-Rspam-User: 
X-Rspamd-Queue-Id: 254C01A0015
X-HE-Tag: 1766320712-97105
X-HE-Meta: U2FsdGVkX1+nNQSrCtOBezNPPYODTEWOVzhOQATH6vwxn8RRALZmlkUx0X2sNGvesci3lyDisRDqwsISVUfgatRCxvuiuCTltFqtsSgO4RU1tiR37dL3HZ1VpshHdBU5m+NKv0drj7WB0QGmHM2gWvw1cTxYZqWADsxLSRyCVtQYte17d4Vx5WnLzdH1aO7MkONXq3pL7d1CcF/yzCMNYE240Flw71wBeJ3BhjtrgHXnM2vtN8bSalP0pLq6bz/pfstkcezEuBrpgz2NibgfX6Y0S+HXc2OxyBB+uH5T+3ygebG6f+RF2MaNoJW+Sq0zLJmXInc5xyx99rdFNxTkQcsZxlHd/RBj19bN5cbIA+LLp3jSxc1/D8g6zyorNFVg9qAgeStBQanByLAEeL5lhZoYBOuA1N2ct8SoasJh35Cc0DrzG8wS6DlPL9ODmJI9+2QyiTeoxid0akl7l0VVa9Wm8Hlw2Z8+/bEDxKZZjM4Jh0aEA4HepZU+3CnBJeADAulI0NHKaZNhBNn69XDleJE3EG7wBoSQgoUUnzSTvwJrfMXkT3W8nz36gA4WMkeJNHY+W3Hf2pdl4rR4zbzsmAyDxl2+0MLnmK80qf8pUDQ8TzkmuGAxesUL/7c4ljZg1jgOqgxolTRkPOLLNB+X9QQ9w4s02XzSih2Vyq7d5mEGUlas9G74J7iwLNjF1xMKvPd6nbdJk59B6vvrFbEFPutFZ5fP3Hnw/nED+XhftXs77ditr1q5ItfjnsjQHCf5bP1z0a+0/qrtfA/y8un0MJPxce8vnu/UzMqInZYnELJKEAp4pkCRMsGFuUOrxIL/99RIYW11mZpTlrWfzGFoThpDoXCRAdV+X6TlD0W2Dv2HbBWBamtjEKcZlDuvyPvaS/eKow7RWcphk99RLz3Dmrx4RjWewDjhHQ6/aNDWGbnHstlYPv5nodqm/R4KI/jJN03B2/AXBQ/lTPy1gcK
 IwrJ6pkN
 j4aqNF74CI+jCECYuBVKnPvtEpzbxar/ufZ1xA91dl0+2vGnKOWtHzSPOwN3N2s81opnM7X2CiIUplrRkMikplSdeuiXhmTm1cxSnSEN7BpWj656uYZ3fyQz9EF0+nL8BlHxJZrTALHnmPe5Rd3QS2Sg50diq1OhlFxWKPnFtDjB97Wf2sFBwC24knylPlw7uZTqQGrTOdsMVXMXKI23HT/g8oqnx1c7mP3IYF/EaB4x9aSOVov/1ovkSzHFp2f2S3atysz+bwA+oN2xnfy80rxVWw6A6yeNd+uS4lRKYwJxPc+1WjF3mxKKv68c1hOmlGukWmdAt1JLgiqet7NCYZb9nXaiCtq9kJaL8f5q92UPstDoMZD+Xb8rj3zwVKDZ9jAKUxxJ1S6GYYh/yac6w22/hsxLjkOukOQl7IdE4YeaHREV7Zn6ZYilMXznrpVOIQ2HBUxSRZ2wWtryMWQYiLeQluss/zM13DVnEVQxngzKc4jCmaeQ4BwAxKzN0DFnNVnrpAeKTQQyAlSqf6loZ1vW5B40+jvbFhGx/XSTtsdOQ9s42ckPqkEB97FsVSLFC1+N1AgaXjFLcu6aAG48WpIpIKaxROp1JfBZzwtPGF5X3LPnbum6/4AzUCEgXR8dL1QpBXP4bE/MGnBjLlkfegwlhD6nNM4k6fl4we9ny8m94400s1yFfn+qrynCcV3jbMI/yBxtVuMmuTJQaQq5c+MI5nSso2yD/g4aQtrKZPvW1JNTIXoBUU246AcWX8ucYtsd5B6GNvVkjwn9/z5sNKW5wqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 12:25:44PM +0800, Vernon Yang wrote:
>On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
>> On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
>> >On 12/19/25 06:29, Vernon Yang wrote:
>> >> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
>> >> > On 12/15/25 10:04, Vernon Yang wrote:
>> >> > > For example, create three task: hot1 -> cold -> hot2. After all three
>> >> > > task are created, each allocate memory 128MB. the hot1/hot2 task
>> >> > > continuously access 128 MB memory, while the cold task only accesses
>> >> > > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>> >> > > still prioritizes scanning the cold task and only scans the hot2 task
>> >> > > after completing the scan of the cold task.
>> >> > >
>> >> > > So if the user has explicitly informed us via MADV_COLD/FREE that this
>> >> > > memory is cold or will be freed, it is appropriate for khugepaged to
>> >> > > scan it only at the latest possible moment, thereby avoiding unnecessary
>> >> > > scan and collapse operations to reducing CPU wastage.
>> >> > >
>> >> > > Here are the performance test results:
>> >> > > (Throughput bigger is better, other smaller is better)
>> >> > >
>> >> > > Testing on x86_64 machine:
>> >> > >
>> >> > > | task hot2           | without patch | with patch    |  delta  |
>> >> > > |---------------------|---------------|---------------|---------|
>> >> > > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
>> >> > > | cycles per access   |  4.91         |  2.07         | -57.84% |
>> >> > > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
>> >> > > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
>> >> > >
>> >> > > Testing on qemu-system-x86_64 -enable-kvm:
>> >> > >
>> >> > > | task hot2           | without patch | with patch    |  delta  |
>> >> > > |---------------------|---------------|---------------|---------|
>> >> > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>> >> > > | cycles per access   |  7.23         |  2.12         | -70.68% |
>> >> > > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
>> >> > > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>> >> >
>> >> > Again, I also don't like that because you make assumptions on a full process
>> >> > based on some part of it's address space.
>> >> >
>> >> > E.g., if a library issues a MADV_COLD on some part of the memory the library
>> >> > manages, why should the remaining part of the process suffer as well?
>> >>
>> >> Yes, you make a good point, thanks!
>> >>
>> >> > This seems to be an heuristic focused on some specific workloads, no?
>> >>
>> >> Right.
>> >>
>> >> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
>> >> not be collapsed, so that khugepaged can simply skip this VMA during
>> >> scanning? This way, it won't affect the remaining part of the task's
>> >> memory regions.
>> >
>> >I thought we would skip these regions already properly in khugeapged, or
>> >maybe I misunderstood your question.
>> >
>>
>> I think we should, but seems we didn't do this for anonymous memory during
>> khugepaged.
>>
>> We check the vma with thp_vma_allowable_order() during scan.
>>
>>   * For anonymous memory during khugepaged, if we always enable 2M collapse,
>>     we will scan this vma. Even VM_NOHUGEPAGE is set.
>>
>>   * For other cases, it looks good since __thp_vma_allowable_order() will skip
>>     this vma with vma_thp_disabled().
>
>Hi David, Wei,
>
>The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
>memory during scan, as below:
>
>khugepaged_scan_mm_slot()
>    thp_vma_allowable_order()
>        thp_vma_allowable_orders()

Oops, you are right. It only bypass __thp_vma_allowable_order() if orders is
0.

>            __thp_vma_allowable_orders()
>                vma_thp_disabled() {
>                     if (vm_flags & VM_NOHUGEPAGE)
>                         return true;
>                }
>
>REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
>so the khugepaged will continue scan this vma.
>
>I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
>been successful. I will send it in the next version.
>
>--
>Thanks,
>Vernon

-- 
Wei Yang
Help you, Help me

