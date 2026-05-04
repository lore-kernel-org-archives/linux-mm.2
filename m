Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3766FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 03:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A2F6B0088; Sun,  3 May 2026 23:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAB16B008A; Sun,  3 May 2026 23:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8C06B008C; Sun,  3 May 2026 23:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEBC6B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:57:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8D2D160990
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:57:08 +0000 (UTC)
X-FDA: 84728376936.22.ADB0C89
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E6C240006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:57:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Od78uZhS;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777867026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
	b=U3NS6cG2+0zQBp4BqcO91R2pNWlemd0ZyU465kS9xys7BNQemH/mzaoaTRXAsyUGXZriPd
	wjE14GYPIhnBwY0+bNQOgH/Rm0Sh92X4rtZwKw8utG3+T30sZxbrZnQ2jVP3HQXJ3rDPcT
	Cprp9gt0oyMkOlSMmzFwWIb7lr4SorI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Od78uZhS;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777867026; a=rsa-sha256;
	cv=none;
	b=NCAmKGaJFsanxxwr//43w4FOd7EqY6ZAoMgQiUkZzRUZmPwDfpB6atmD4YMykGiZoVBYUa
	//DeAJalFMhU1ka+JoflEPIVi7ZD6Nxhy+Ar44icbPwsB7Ss6mHYjQeuvAu/vGbyuIyLoU
	PRIEgu4PZNJDNC2LS0JtCFDB4xh9ah0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
	b=Od78uZhSf9HWqG+Tsiok0qPQJgaLhjM79xfau76fux8mecFE/KXpTli5RBsQm2J3K4GU4S
	QZjWfA/xnQbF8K3K1/+Orhq879RJc1z7UELZ4i0r4JmDS+CW0ou/6qTKdqk2Z4aB7QAJ45
	/kRD95RvoB3xflC0rzlcgdft07Vk3aM=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-RC_XrpXHPe6X0aMwO5p3gA-1; Sun, 03 May 2026 23:57:02 -0400
X-MC-Unique: RC_XrpXHPe6X0aMwO5p3gA-1
X-Mimecast-MFC-AGG-ID: RC_XrpXHPe6X0aMwO5p3gA_1777867022
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7bd6fc10a42so39230347b3.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 20:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867022; x=1778471822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
        b=moAkswpReVM95MO1y1vgxw/Lwg0m8nGN5hc1AofCSEGr39TsH0fEpNwpWHURoiS5vQ
         qQX7gs3Ww0lXw0TmFfSY9afQ3kqWz6PA9+2fIlIDbYHv1n2HdI5vaGh9IedMrMSo+soi
         9sQjpKEa9R+BXXPlvYX8qo2WvgsgbJQKdnhYI890Ezuzi7BfhO0BkxONFDoKJuXVCHzR
         BvxSehpsqJmD01MHfZ/3mYligrasuIIXXzvp5H9ulmR8Qyw50MoHAjizBsDQwajimf+4
         4kaokoQ1748bFDJUobpiMK2to4DW95nqutjaI6wVvyK9iN/tZ8m5+V/I+uiGB9iPgnPE
         cLhw==
X-Forwarded-Encrypted: i=1; AFNElJ9iVvyBSs5wrK055oKi/rGW4f4KUoO73jznAUU1S35u+r+OQhp5QGamVII+FT00pch4YRAcERCfqQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4VmqJ6Kak1PMqQgNII/upXJm4pT4uxpWxxLADx62AeFjGlwVO
	dt4fXWSPwBxQQAbX5BjFgk2ALrlDXAQXJCHuTjPX+310x5YGiJEzOyBxXXdmbRvblvZucLVJcGA
	4a/I3h/+5ghoKGq4i63fxFEkSnc4SYPfTdj5i4AcKU+8P8CvGH0vu
X-Gm-Gg: AeBDieveAxLyDyzB5Dyhd4uWCsWBTEXgQhS2gbr6SchU4m/WAhQ4LZCv4OqvIwf+6ev
	8Qd2KpvjWI9nUzvcc5zPyBxtJguar007W8d6uwiBYwrdKPwzBqNxXPm+ih4o8RvyZisF+DcCVKo
	En4ckUP2hcbvfpIHEega29khACsw9RADRZ7OBOcPxTjJR92VIc9AY8u3jeT9gQc7Kucr7ZWlf/t
	5YpqVeTRErelgm0S+miOd9RdeHIxsZoUmi1TmHvpVNOTV1a6kSydxMyyt33h1yKUa7DEuZjAOlZ
	2rYjuFa2+XATkfp6BHVz0bflWiK3AKeJy0K/9t+DM0WIaE/ONfKahtuvVhaXi33FwseEnsUWhLS
	N13ZhfrqpwYSWys3lqSVqLW39vSfb9WdgolZgVIRZUEghqr/8aLH/hT/YQrw4hxaM6Tc=
X-Received: by 2002:a05:690c:e094:b0:7b8:c19c:ee9a with SMTP id 00721157ae682-7bd770db6a4mr85526827b3.32.1777867021837;
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
X-Received: by 2002:a05:690c:e094:b0:7b8:c19c:ee9a with SMTP id 00721157ae682-7bd770db6a4mr85526497b3.32.1777867021452;
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6683aa8asm44078807b3.26.2026.05.03.20.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
Message-ID: <fae1d9c9-1d8c-416c-bb53-90ef11edbba9@redhat.com>
Date: Sun, 3 May 2026 21:57:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
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
 <20260429152924.727124-4-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-4-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B43NR2FsvtgTKfxMzzMhFoN4QsLuOmPZgXu3XIEaW1M_1777867022
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wcdoyo374rs4wmfh7j11imxjsd14k7iz
X-Rspamd-Queue-Id: 4E6C240006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777867026-526765
X-HE-Meta: U2FsdGVkX18LzGtG2s9YJEx8k8NTy7ARJtzyg88cPgaDdFM1NAhaAY6E9dCyQTIAqIls2Fm8108t5kTJrTWWJ69Vdqz316Mexx6zKX7e9mCwNgvevYU8AdUBExS92tBhNpv+U6MBG6+jUA25Qw+I06x4YkV9htGIwQOw61SuterkrylBVlv/Nh22I1FKhcQqAvQrE7BjrtBEEQYxehFX/LYvOqV9DiyqFkP+63T1bn9V46HZEZBho2YVqvGh2R52mvqFkbfZckqEP4iis2T5u5y7md4sRRK2ABnmyUzBOOoNIfaU9CepCe56ZTkamciUOnRQPi5YBGBpGdo3tVTpzk4mfHvGsf8ho6fzS6i5XMnAlupK+0ZuE15scpsl5hHHlmPdy6jpI91qnA2WDN5Jz/c/EEz8CrIJM8862C9memo4gMplMpuOUIDaBNkSmHdyWA3u4fxKKW0+Qh52uJaCBISR3eSJ5If4cVQQhF/qAWA2be5Sdlit0et/YssGZeXWNtSFcB1Qb/ff4dVBQAaG9Wigdzybf1X8wH7wwpVnSXkIkngSzM9UWTTE1nK92n2D9SU7Sek58zl42WELQrqjWEu42Lnrva6APgz5azvleZGdhHRYcJPe2HI6NlhGRmt+jITHRm2D3TD6TvokKiQC0Q5ASs6mR/RaHdJkzU+ducCnCRB9ObPQM5bwd21mBvoGqR+hTVXoiCpkzzCWgE6EpCDPzIFUFSQEerE04l0/F+mRogC2REUUi2yDMLw0hrYxhZnSnAJlnwcLUD+SlMpvzwimjRY6X2MqtesRwUxUSXUXz88VkBpX2j7QBknc/8ei88xFKc2pIja/aGXEtv2JfI13u6s9Ijq0FWeJK6pTSsw4pz7JADXOOMnuwfl4teSZZrPVoqZQfdOWDgn78+gkMWUESxMubFhYPzQasgXL7PbfesdxBrJ7fG5YFmr80gnDpyqggDsVhiomuOBBVs7
 TmiEFQ+3
 YxU3I4qnnzL4dOHsaCcy6VCmZEGKyoHLCvCSgY+DRO4Sul2tgbVe/DJq8laHTNtJGuz/FbnEmbsB73cUk1Fw+Jo61vJRyPODGMFZqxbiFFU95rN07Uv5czJ47aTEwmvePBe1qIkot87c2ZlhOqbv72g7AtSEOIx/MUz3UD9ZEd9fctAR/3ig1gzQPFNuiq6ULsO0yWED+grUx8p/hDo8SwN1aoNqXvuKYZ+O+OcRdlkK+nhvCGbu2uz7Daya66VZvv4FprnYiv+TyRs18y85j/1PofTN9EWk4kiCJgNxQ8xuADDrpDVg50sdBXXifAaKXIlYzVDZDltpUY12iHV6ii6sSSG8y4rObXifLY0K4w7nKfAN+EYBQdXL0kRHeCzyY3Us6IU69PH2P2/y6aukCH9GgwVlia2w9jrfUYYfiE+jOhnopkDuw5Ikmsi85BOLEyeboUE+PHu5qFzOpDPi33PGC9xHNyoUsQXlJBuCo5v/wZ2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:29 AM, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD folio is supported. Keep the inode open-for-write
> check, since even if collapse_file() now makes sure all to-be-collapsed
> folios are clean and the created PMD file THP can be handled by FSes
> properly, the filemap_flush() could perform undesirable write back.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2f3fcb4dd1ef8..3b324f03e9283 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   {
>   	struct inode *inode;
>   
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>   	if (!vma->vm_file)
>   		return false;
>   
> @@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   	if (IS_ANON_FILE(inode))
>   		return false;
>   
> +	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))

Other than my question in the previous patch about >= PMD_ORDER vs == 
PMD_ORDER.

LGTM

Reviewed-by: Nico Pache <npache@redhat.com>

> +		return false;
> +
>   	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>   }
>   


