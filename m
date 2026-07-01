Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EF5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B156B00A6; Wed,  1 Jul 2026 02:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB766B00A8; Wed,  1 Jul 2026 02:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA8A6B00A9; Wed,  1 Jul 2026 02:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 800076B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:58:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03CDAA0252
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:58:17 +0000 (UTC)
X-FDA: 84939303876.11.B18E728
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id E15DA20005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:58:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OKcGAXgP;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=hare@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889096;
	b=h0Ak+913SV6EKbh0pjV0PBwAf9/I3JkrLhJ0n+xVrrUsw+LphWHZ5FrpQpWevOw9WKy3HN
	z9H+3wNebvnGXahdiiaAfwCTiiRDKGmsLGgyh9XsbI0Z7W8Atu6TEbEBYedv4Q8P6IlYkz
	aDm50tqmkmO/91hjzyOF/dLalwHVpAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uM40CkIKzZOswsbi2LSbdjru0/A7oQAC4WYJATBuHvw=;
	b=WNKLd61voUo25vNg0OYTosuq0SxSSnP+jTXS+lstMqUd5p34Zw+w+H2/OsJAqeExPOikAy
	m06nWw8VI69xZQmJ9zFFXRZ8hD6Kz33P94hMUSNAoYWj7rpsRb5gQ037OwlAC9NOKAQieX
	vvMeCPF+LO6SQuslMmaFM+Fyac0lwjk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OKcGAXgP;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=hare@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-472055b0efaso146584f8f.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889094; x=1783493894; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uM40CkIKzZOswsbi2LSbdjru0/A7oQAC4WYJATBuHvw=;
        b=OKcGAXgP1tmD2QPisLdpSjrs5eAY0k+n7B87gsfOKTpwohuHqWebej83zfpctkSR+K
         YzujTteMHA+1tYtxRyowurXzy7dnbdyhbb8PyKXla5UgslZ3VFmxZXH9vJuDpLqmmcSU
         F2T8TcqOk5jzp6cWufZZKuzePOZWOi6tqaW25IK4MaSg9vQ9qDucMcV0aKvJ1sMGNGtU
         aAucDZBHiS5vC9NqqfT+hY31FghQ03TCevIFH1pSIylS4CcJ+U/mr69qGMBpB3Losk3E
         t7ye45ZOuLz7a97Y/ZZAENY6DIPXkEZ39c9Wsr/n3GLr57/r6zEpdu6EffocdbhnNY/L
         d4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889094; x=1783493894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uM40CkIKzZOswsbi2LSbdjru0/A7oQAC4WYJATBuHvw=;
        b=qEBhfmI256jXxjPa9OqDKEIV8Z8165IV2GULVufjlC8O8BheEkePa0Dj0+1r1fFkEq
         8zWdo7Zdh6a5sdugpajqQUgI0FkNp1ipuay29+n0PLU0t9iz2kRloIjf7UPvfe4rnOSC
         x0v/t8yLp76oZ3C9TiB2IVR1zbLEGLkVJewEhntE5Ql181aRCGFWpXPftD5Fj2jg7XNf
         G29u+O4C+79YpMAWW3XusQC86SZjuiDcl6khLJmlYdvnyJ0a8cf6sIgg1ELaTHvbaaX9
         Jv+SXKmipu2lKfOXhFcyeZozPEwixmhUtOC8CP3loyheX4g9Md3J7fiPdsl3DPVH7ONn
         YNVg==
X-Forwarded-Encrypted: i=1; AHgh+Rpx9Hs+Bait+LXus85SLghzLNspUPh2YHHhF8KKI+yNJ1qk1wOBY/qqV40PMmZVF+2bl2KW/nQLMw==@kvack.org
X-Gm-Message-State: AOJu0Yw2vlHdnSQqexd+f6wnKC5Nb5jE1z4mEyVpRFef4tcog39pqiKn
	ndbXMeSbdje/FWj2ilx612/DKgVccmGfkU4XeOyOBIXyiBdh9EqMXvQldG+8SFy5rNo=
X-Gm-Gg: AfdE7cmniroMUkqSJT88lEfnNqsvOOhpgDMfqbkjtbPiywfaxS3GHmzz8urpVq+mR1h
	rZH2OF8JKlvKL+lf42wkn1obvuqQMZrUXle+GlfCKP4ZHo0kZIQTM4wmLKmlk5QlZMcdTO1yVIS
	LqeL5fKe961PkHnzke0xYynE8uaGpcMdCkqKlug5VZR6SajJTlkOrGU1WuBnXrOfgmmnd++2KWH
	3dkB4zOvywOnH4ZxNUI01vU+GlTpqcacMe8jgAv8owa+hZdfyFJUr2PqkGnIG4cXDCrx38eJt63
	8IORz5WzX3Gdi5JyDJptLtX374bfOTP5AdYedKUBDHX8L+VgKAG6SP2qOdrB5X/Fye61/XHC7kE
	8ORPU+gm/8OYNt2Y0aI7dtIAiAVZF5nzWhOMfnt0p3IRQeyWh8SZzO989fbpxpeOQ/G7ryEXEnw
	tH5uJmBwkaXNZGY3Tp++o3BTM0NapeQfS5V3ywcibsipWkh28C4ixmC5Mw9Q==
X-Received: by 2002:a05:6000:230f:b0:46e:98a7:232b with SMTP id ffacd0b85a97d-477573bbc16mr566600f8f.10.1782889094328;
        Tue, 30 Jun 2026 23:58:14 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf1asm15708450f8f.18.2026.06.30.23.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 23:58:13 -0700 (PDT)
Message-ID: <1f9329e4-dbe2-4d46-8387-b3c7fc8faab0@suse.com>
Date: Wed, 1 Jul 2026 08:58:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E15DA20005
X-Stat-Signature: gz6dez17oqegewq5urir9icqzoqgsd4w
X-HE-Tag: 1782889095-334738
X-HE-Meta: U2FsdGVkX180EqYRWVA0fJ5dfo4wlVLd4NP6tGE5VsYjUgdhSaxs2nzz0+q3hLQOH/aGllXcrxj+5SY5fbX1FxD5BJ07l0pT9+Qnk25mbN6cMetUiZaxmRm7N6NAXb/4eFKSq9gFMkzLYKevu7t3TTHN6A+eZTSnSix3FmUKGS30+9dBF3fXiEuFsq1bE6L2DWf6uNUgSD4d8brDej0AWIAWot7NG2FgDLx+2kicRsUcwBFvugV1AWOYDEgfpSDX4oQOqOIiKwH/YCNEYp2YfH9FJ0r5ewaL3RZ0+CXVdDkDyqxfV3I3ThKcq3/wC0ug83/cXti9L4jp+7JLWqP8Z1qZ/oqPuqDUDtcEHKKe42b8GbronYO1D2+0ynkOYqLLbADAKzifjRVg2dXASZdqSm3Wb2wceyoBMteT6o4znVCqP2qRdWWw0Tl28+aEfrB9YffXCgbWQSRl9wCYhEiZhrhXCaJ9sa9ZmbRpEkietK9C9TYKiK+gUUMRvBGLnNvw0fmJaeB3b64FCrVVfO4hj1viRM1piYtyD68CUa0NwoEgFKlZVGsO5apmcnUUFsHib/+r02OwL3HeEpySXcOMv6GrpabICbSF6/8RUs0TU5sA83PES4HTRJ8D5RsV4aQ4A9aKRMe0urUYG9q7De3PWcXGNc2ueDa9pAoHQz9dPcxqqTpmLKSaskNPVFsOc2LVDjIBaKzvuX7eFOqWMxOt8djtP2rGfyqlMDKHLxkxJjzNA8L4mL2Dgf8NJfw9XPsX9fMp1t44Yndw7XlWi4fVDYDZO9ElJyp9jw/ERwpl+S8jYApTaQE821COVO8JCm54P0cmSGKh5vXjG06THigHk+HeoW3Gzeng+ifqchHDTjreDOj2NFFWzJiqlsjLmtLztsuEaaeSgS6CxTFZ9aXqb/69qhXz6P3BNnmg4EyJf7Vw4p73YZ71qMCXG3EzTjCLI28GFdwpmQYqGy9BO5Q
 vMc5tzD3
 5Ca9YmGjI6brBA+ImxhbTI1VTJSNI7sv20gHF0V/TuVImsJBMoFVgodSEYaVzh0lyI+qM2G1LHOWdkpgLc0SMwr7D27nGfOh/UlBBP549ymkbq6AQknfKJhp4/Gi8CWdlTywPHrh+VVI6hccUyoydYP6chUuV62PBMhj+KqEY1Si6YJ7bu8YXGVqL89qxS7b0bkMhUspfPHl7FEJjioxsTYsHqRtP29PJcR6szSSgk+IAe9FXViBNPCQzKug0T9vFWLPVP81tGRl4RUkg0J+QqmgWWR0/rXDfyljLdD+55pNQ1DeoKLGYY+rtGXYI7zIPiBb0AFdBSmTdWle7+kcYOySJQUkEQX4wF4a1Qej6MiHtm4uqnCnh6zXWupqBcY6EGEZik60qyUKy7wjynQg+KQOJMSXcSnuvbkz8SULCqimcIHrL3KgZmx55kHlMMB6lU1R/ZqejA5cUMlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> fd_do_prot_unmap() uses __get_free_page() to allocate a temporary buffer
> that is used to invalidate protection info for the unmapped region by
> filling with 0xff pattern.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/target/target_core_file.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 62ced9f5102f..ab9824a4852f 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -516,7 +516,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
>   	void *buf;
>   	int rc;
>   
> -	buf = (void *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   	if (!buf) {
>   		pr_err("Unable to allocate FILEIO prot buf\n");
>   		return -ENOMEM;
> @@ -524,7 +524,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
>   
>   	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
>   
> -	free_page((unsigned long)buf);
> +	kfree(buf);
>   
>   	return rc;
>   }
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

