Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F335606A33E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ce6xXlX4
Received: by kanga.kvack.org (Postfix)
	id A78BC6B05B1; Sun, 22 Nov 2026 09:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28B26B05B3; Sun, 22 Nov 2026 09:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920896B05B1; Sun, 22 Nov 2026 09:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7186B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:54:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81C101A06BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:54:25 +0000 (UTC)
X-FDA: 85463050890.05.77952A0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id B0DD8A0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:54:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ce6xXlX4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795359263;
	b=rJu9WjnigGvOoGJRgjwxdTcqoF8lwQztd0yYW3WkzuSt8AYrwJL3mEsKK3KlKm/i2As674
	6pxZry3y7R/TytTTIi0HTicIQ4OxYpmdKvRyMlQS6bplEQqsQYZ8ZJSE2rIxrdhSX28+h3
	qE3WwhKs+SzALMQiNpUNUDX8NqqSHWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795359263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLuKTBBJtTtRTcmaK0xkcTceOMHbrjEKndUknDgiKJ0=;
	b=FD9s+s/HXLXBS7gbE9NklasoHRHMVRVwb9ulGlDiw8iLl3jEPBbKDkQ28Hc8n/TubL/3ze
	7w+HMbqyz/8uvgjMLD/18AimcITPfOWGHL6okEKYfblG4zqSuD9szNtzsmyGV+irBWe9WV
	D7bRrTJHRjXdMk5PWivxqvJUrTuNn58=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ce6xXlX4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c50cc7540b7so330928466b.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795359262; x=1795964062; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BLuKTBBJtTtRTcmaK0xkcTceOMHbrjEKndUknDgiKJ0=;
        b=Ce6xXlX4m9NXGBMxVLgIXm7ezEzdAYYvKsp1NrTcpiLXFRbdHvRaaiTy1LncT/n+HG
         emU1ZY3hiyMzyHhtP8suh4XIBsuRaspKCrFmfTcZ5sFwUatWWBAUB3l2woMqfDicyZpz
         eiAU+3Kvq6qSTg8iuCpeS/Sqe4V2wS7V+G2ksH0WJ0d9YsK/glQaiZJMFuwIaajsNGvp
         bR/gNp42m6fh8XQgL2rvBH1cAIZnDitB7Mz6TVjwyPbroRGWlR1pFdRY5F+vfmwr6KOC
         9QTrcemLvH2S/8JK0oQFPtMhkDMNwY7yRXFMHSYnWXzZI/haBA8gy5nTbcqCeZmGfV+1
         exPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795359262; x=1795964062;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLuKTBBJtTtRTcmaK0xkcTceOMHbrjEKndUknDgiKJ0=;
        b=WdZx8LoMKHv3tJ3XJIRdksg4tiQLKcIcdXWmxrhXKxJY/yk/pFB10pkGSGM+TJysXV
         o2nOemF7BuZZxYN+4y2YHjtwNVbvwk0BBmCi8VRDxOxCK/14IpslFRJe0JzaVORUTE+W
         zEvrCG4a5maD7fH9+fLjDsO4spTPYCQsEukPsaB9ezdYOABVILyHNDx0SjupQ+ALgJiY
         bpxKJF22hmQh100u76UTThcVvkQOQ5PRzSh2IVUPIxTqdZsr8VZUljrvnIyh1g3Dsl8P
         M3xsJD43zqBhGYXWhpWjPMXfpy2gicmIOrGPkOqJGGFy/p3Kytbdnw1rMtkQF+Fhw6hh
         NqEg==
X-Forwarded-Encrypted: i=1; AL+hErF0iK2rXJinbT7ypCiqO181VO98TOdSFdG8v52/+srz3wasYvkYMUQKdm1I1VQq/DDA+ZCjwfHvGw==@kvack.org
X-Gm-Message-State: APuU4Z8e5TWq+ZEr79WFr6ZBKY6POSmLFR5B0fr21tyfUhHgIVrXa+yz
	ZUAvaBr2H+RYmpfd0K2nPKCBBEB0Kl7w6cShSyN/PS0wQ/IAB+t7IpA5
X-Gm-Gg: AZFdTZeg/T45mONA2i00dz0xcl+MmdAOUHIpPefDBmPhZeln63FS1G+tv8mdsdNqjr6
	7xhWVcoV3c+zG9OjQmihgJlXM3ljzxoxu5BTrRGnKihCI9eB0IuVaEkaB3HutCAF0uF1hDBMZIs
	05xZmvqBcUPLXoHRfng/LUFMb3ErR6lJ+h49gPmvr1G+XRHCGT5sVQ8X0RZlCPSz0nxNElz27xZ
	rHjL+UsMFUsJuH4yn23wAFJ5kFL3KE4XFiRKcZrBq+zpkhl9fljBGCRU9CrWDuROvAD4Fq1//+/
	i2b4cWT7z/UMviot1ODSLVlLd5W/uswcqPkD+vPKZvrWHKGQz055JYPvmY3Ybc7T1czKzCLDCia
	nFlL/lPsuCAtbaAnznnUpko5QNaplxjmAXWWsk4b8Q0FDiICtjQuy+kiyDeA21NjHELE6GYYw5J
	rpiomDtF2EJEleByrFDdJAT6jHANJXAYChk03m35zn50dFtmUBLuhwmR6mC+lqrpUyNL0KvuRDx
	9Cg8SxqtUlav/tKrG6nR1sMXngnBDr/INwVqNM3klyxRNEnR4zPUZNWEh14fwtsA4zIWQ==
X-Received: by 2002:a17:906:5006:b0:c50:5e10:71ae with SMTP id a640c23a62f3a-c513a5e2124mr612735266b.17.1795359262076;
        Sun, 22 Nov 2026 06:54:22 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afec08asm319529566b.73.2026.11.22.06.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 06:54:21 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 22 Nov 2026 15:54:19 +0100
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2 2/2] mm/vmalloc: reject NULL pages in
 remap_vmalloc_range_partial
Message-ID: <awMCG7g-oWkqeog1@milan>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
 <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0DD8A0002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 3c6rb417efbzjmggidjo9fzmewobochx
X-HE-Tag: 1795359263-689806
X-HE-Meta: U2FsdGVkX1/wbNGfDgLKLcMFKRiRS58lxnC+hawdxSo/HZ9B7NOy0JkyJv0ky9oCFwK+Eyqwmk25+zMbVxAMeB/LI/B87ks6a0CfQHqm3cWxmK+EYGxSEXEYIwn9AbIj30DA7V0U5ZOh0uNK1wDVTJgSAupGsmcRI2QafiNYipteP1Xk2Y304qAzx0agd1ByQ8pAloR41N8IYyeUFHNyV/f/3s5oK9wo5c53iRGaC7YTwGwn4jkGdjC1NJqNLzEUWoo8Gh3B5aevoD/uf+eZfjJ5gPYJdlX39PA2lJ1h3X/x5KyX/14UNynPEGzHTErXY8ZbGsOiyb5lcYkpgLglYnFGT5ss7cJY0qem1rOWfH3CQi5tl8jQikhqRNmbbbvPqY8FW0h0KQRFsR4uuli4j+1riUEQAGFf1V8EheMygYYYW08zknk4ZC0mBRu67yue4TdUx61rImkRsPLl4QJ3FBFgoZ3b/uB0OSVB7F638xaSXksYUbiFdABm+B6O6ScjkcgGLz9XOYAINR5TYrBaGDfN+Fk2fRp43ncmoaCe11lZfrfMK3xzwhtXwJ3Yq24gY9+6lzTOvSj39TzjcA+uv/KBnkSaPhOfFM53A9yCJB2fGyloDR/q+bIgkCcFUdpIik6WwZFYK0aTkr1UuubUJYZ3aaAi/c0Vm6rx8hsBWKc7fO6Jlohx8FRMvdkxqAFxcU96IQRaG2juDf2nz06+i9YnlgnnEYbIl3kvEhg9x8Ta3u9OzF+alR9FWNBOgF2KaaCnGmpmBHzN1IWkFdUR58z9bpHnORxP/vdT2sy/xHxhNwKJ4ImVMnIRkX2dlqInTyu4LWz+oMY2XEf+dTiih10reX7sj7YlA1ebBDneYXjpLHy6PyjqU4pldBETpO5Y0x1v7gAj19oJfC8CRd3b2p6nPuZXMgNi0KIfeJfLC2S8hn+87DsWUacNPHl3aKVWF0Yv/507CujvCHkJbfQ
 fL42SyGC
 JPAvk9iwbAk8N069vh139+tAXJP917o6QNEziV6myEwA3tiL+rbWf7Lyzy0Z64KyD4Cv7JbxpeYm0Sf7k6P6P4CSnIaQ0yr7BiVcsebTxvI1rwxzGV7M4h1rkZ5ZwxhNkKGn9gD+YiJA2nrIxPYl6YmAY7A2AbDtKqLEl1J0479BdUIHMPEc4LSrpudB4TeCIJ+hSXQByVD4xlqYAHxY4GBQIczo5PtgQAqexfn9ukATuPhAFoyCziAnZHYhY+CTdu0Z6sDUXduzchNkYyI9QHv7fY9CMw0FFtHzr90lEDph5FihSMo6EfJIZKuhERSmPXKGevywYHgcoWtckVirhoaM0eG5L3FUEm3OKYxlFg1xW52Z8lOW6yg3pO5Th2/McxgDxn1CPr16zUuEZueNx3z90zbhQe7VDVF08Y17arYL8c6a38An9vJ0GAJs30wVM2Br0kqHmREITqeMmeFyO6dQXiF96Tsm4u7yBWP4i0bompE/gVu76neTi/MZZRqZgchEr/33Ea+15dX4rD81f4C/o/q4C2Fn6xdT8ESb7JAQ7m2oRkYemYI1+8dKiRwnvy0cqWg5+8HuPLNbxOysLtDCvcTlpzV29ZkiSxvW5BrZhEy8OWtLh+u+HGEUrhdElhywT6XrhUKTX7OvJNsnOIU7DupTEauwzRDulHMkWMja7ljF516zQnPmwx+2xiXCaSQUXkwHWf9ba3wrWZ2ngcFuQLU8QU+OEyfMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:19:08PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
> vm_insert_page() unchecked, oopsing via page_folio() on a NULL page.
> The NULL case cannot happen today because VM_USERMAP areas keep every
> page mapped, but nothing enforces that invariant. Warn once and fail
> the mapping with -EINVAL instead of oopsing if it is ever broken.
> 
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a888eca016a8..dabef40ea88b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4906,6 +4906,9 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  		struct page *page = vmalloc_to_page(kaddr);
>  		int ret;
>  
> +		if (WARN_ON_ONCE(!page))
> +			return -EINVAL;
> +
>  		ret = vm_insert_page(vma, uaddr, page);
>  		if (ret)
>  			return ret;
> 
> -- 
> 2.43.0
> 
LGTM

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

