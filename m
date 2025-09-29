Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B328ECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC328E0005; Mon, 29 Sep 2025 04:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E321E8E0002; Mon, 29 Sep 2025 04:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20CE8E0005; Mon, 29 Sep 2025 04:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A725B8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:13:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E9921DE9AC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:13:18 +0000 (UTC)
X-FDA: 83941572876.11.7606E4C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE99C4000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:13:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ckIabRZ6;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759133596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV1jDfAQTNW1DgfAjSsYquVIcq60BdP8TY9CjXJtlj0=;
	b=AmbWk5xwHhIgAwAH2k5aLExPtLRiK2aYqXzkIfdtDxh5oaeKEIOcR4CsHm+wRK3PdCuhB9
	v2o5voYQiSuXcTgMfAcdEYjOA9Rsmw0NgK2Q2WQ9TaVKUDGDD2g5gwNr+X93ZR13HOC6JJ
	Y0i9hEscXP1kBrVa8wQe+grdqv3YsR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759133596; a=rsa-sha256;
	cv=none;
	b=Wx7UM4HTf3riuKcEkNuoz3mBcl4w2bM5fhsdqjszQlRevzEffjDE6o7qvfQKzUHssEhCq7
	VY/ecgiGVImD9hdHnPXB/hMEfe729Gr+qt7ZclFLg9KUewzLw5uGz95pSn16jf4E78Tr90
	7gPn1rUgiU/y73OCXjhA67yjA9NhidE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ckIabRZ6;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759133595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OV1jDfAQTNW1DgfAjSsYquVIcq60BdP8TY9CjXJtlj0=;
	b=ckIabRZ6hEmpT4tZpAyCZUt0IUxIYtqSgz9wDAKFvDQZ2HNewaxwT3qH9zdzLckJ10K4MR
	8lG4DC8DfX//xOgVfDgqCyBfeGFjcLYOAqv6kA9x/Dw1ua0bLnk5sg9VedlbtSf7Tpm//N
	pEO5M8k2yJl16AlHKQzNWSrF6siqaBw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-fz4Qcx1SPmy5OHJ4ofdbpw-1; Mon, 29 Sep 2025 04:13:13 -0400
X-MC-Unique: fz4Qcx1SPmy5OHJ4ofdbpw-1
X-Mimecast-MFC-AGG-ID: fz4Qcx1SPmy5OHJ4ofdbpw_1759133593
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e46486972so6393275e9.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759133593; x=1759738393;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OV1jDfAQTNW1DgfAjSsYquVIcq60BdP8TY9CjXJtlj0=;
        b=YRgoTXiMOoiY5w2tMhA6Q2tXXeXhp1zy4EORwza5pWei02HA/UXHzx5GQBAILPBOYF
         Ue9YkDgqCHCQRAV7VCFfa2TdRIEVDapiEUHzi2TxCIl3cDUgqASjmzcnlpiB4l0IlBcL
         3ek6ltmhtfPOOZ/5jD2sv2CR6zAmpxPygDpd+FUBN0erzkHucDqRUoWc8IecMxHoaNp2
         oNvrZ/SZTn0rmVoYkCpfhpgi6Rjn00ZY0sAe2mSeDNlSqr+FsOCexjajk2xsJH2/0SVI
         LxOUz1XRvtW/7knj0QLxUAI3V4f+geVghq41wUVGBVk+0+uOes5rT+JsSHxaGMp0RK7i
         QE3A==
X-Gm-Message-State: AOJu0YyXfASlEwqiJin0vJNIqPdYP8eo4m+uGeIrkY8lJ154haW4fY6X
	CajN5QvMknE10sMRKmdd57WhEjC4fjSk4npQM94DDZ2vYFPXogU3tTWO3j++LWL4JRV0xamHZx7
	gdAnMHH7ka6AVoJAaj18fZd1JP+pkmqfx1HIXqkQzTwuZkNHFEos5
X-Gm-Gg: ASbGnct7mYXZc5+7UPTpJEgsPLO5wLwDBjJZg3fIymB3OtuFpTFd+qXcoYQRjvss2vI
	QJ6KioN6rR8UNaOGR7TqSp/qbeDu3JimiwUr8Lbwrl7RL7MSA8/fLwgh+gj0JhJyETftUmgP5Ul
	0MHvjWmee/ZTQT8tMbdg9aatFS2zhXO+cKcVGIwc3cP+lw2iexkHgKksuWfmWKenCCcf58UXQNe
	6rVwOFZPktx8zdnHzQMl0sZ3P0Z27iujvqMrNbbm9NdRjJvP00VrokhLk+WfIQrLhMseACMCxlR
	VmyTyBcBv4x1EFlKf4frUdxqZOB8tlI6eWPnD+qJKs4WrDKhSCeGdyN7eqasrUx2Cfn8tk9cueI
	rfBw/MGyl5lXTUNjP8RQ6QRl2zr6aKM297HXmtphoxlNZ1lCTTThm7LbqCbNOdxXKtw==
X-Received: by 2002:a05:600c:1f16:b0:45f:2cf9:c229 with SMTP id 5b1f17b1804b1-46e3292ea63mr139851715e9.0.1759133592604;
        Mon, 29 Sep 2025 01:13:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmgseeN+CYr/sfFdlhQ2fgVKl4BiBMdjUw8ZmpFd/IzI1sJToPWUl9ogj0Bqbj8VxY76EdXw==
X-Received: by 2002:a05:600c:1f16:b0:45f:2cf9:c229 with SMTP id 5b1f17b1804b1-46e3292ea63mr139851255e9.0.1759133592158;
        Mon, 29 Sep 2025 01:13:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e4ab0bf62sm64113115e9.9.2025.09.29.01.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:13:11 -0700 (PDT)
Message-ID: <2cd53ec5-326a-40a0-a415-c1549b7f7ac8@redhat.com>
Date: Mon, 29 Sep 2025 10:13:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot
 is NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250927004539.19308-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1u4tyis02de-HeMf-Wvg-cKQPQks-PA1OsG6EtFXwKE_1759133593
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hor4hre8xu3tni379h7ez1uisxy597zt
X-Rspam-User: 
X-Rspamd-Queue-Id: DE99C4000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759133595-230936
X-HE-Meta: U2FsdGVkX18978wgdhnVon7b6qdx+o+hsgChgSTByDCpNgXx/mGpuBVCTqgWp9ATs5EpW4AAuFSMAR7Dne92hUqVjSkvFh3EtWzqAooRjo2QIzrDKh282boF0/x87ul7g22Lbx0OnfF4K7142E9hEAc54cNX+SAQ7O2iQYMceQwtGiQhWAk3rfRkMWy9DbDV8MuP6rG9kU4Oiv4DlFja6Cf4MLsk42Juj3aTewvrQkdZ+RIjBYV/N5XPv3nsAfz0mh3kijw8xMh0lqz7+hB7S7W8i8F9HvV7XizV310hSeCgEPXgNZvCa/OkZp7p+YncWE8MOJ2sjE7V8MrsStp39wYDR4IM9+lwHnGPcWG37Lc+f7sWmd0620Mn5ECC9EXziF/JTdujcmnOqrzzyXoeA6NOfxEfQlfu7bglVxOz+4aDM6hwuBshGUZ9sFPUXEF+o9qJ+Qs8YfaOAuylwuoMDo84yZGWJhHvuefhHKA0UE8ymxNwZy1rSz3Iu1Is3Skcf/WhNR+gAseAwoh1baEn9agxeZLKk988eEDFrZmiCUZsTQFN/JvoUgYoc9cHQIaE110EvmUthgZZEpADPuFCCkU+ULGvb/Zvst+QsTbDbIKaFJ1RwJ32bzKmrOFAAivE1+uPB6zIf5J/zl57taQTZ59dI/ia2F4YMf7HrKg+xqj1XihThmGiJ2T8kisEHSUhdNzPr9lbbA2+R4Qaf9mji3FtH7rbbssX+KzUqQSrmVHtiufAfgCO/qSfZxG6IEB8dxKQ+LvxSNnj61ziN3zWIEoKWDgHdf3bXTk4/jtoGs7/yEEfgvNeyQ5XW14DkF+21UcGGuZfsUCSRHSWp8Pj/zmFJJGYX49vN9TI4esrNPRhm3ozKx1bbisdtR2InOPG/gNlB703jzbQgGAvSZyjX4616e522t6DXyolyr/pSKQGgM3+qWOSxIG6gDEZhoYm02eDjblLgeFzc8MnZBr
 GjXxwtKA
 mztgQj46hzaWVDA0vlmJ0QHfsNJt1C75AzPZr5tfGmqwFKhWYJYBHb02VOWvPkKkbNkQ85VdG7JQJpaljRByeAsuU0GFs9YXJsSNlH6A2NNk+3nfqyITC+xLSm2l8Udl9/1NPAHLl0Vq670zpExzBfrVta2uQRY6y2xzVqoJahp88SPoLc7jd2vAtTEzkrWdDfVjFY3fwF7R+yzlk2mKTjbGNOGNWDT/hMEkVkA75t2UvonlCRql6K1GSxqci4vHo1oIDEZZfI3ZoDPpiwEb8x2oUDDmSzUmp13KJrTS4CDAcsY1TAxXFzsE83O2crkeMinKI301/TPRwQ5J/wFoEeGrAs6bqgBXTdVAYZcyrU5cUMjbw6d7sNqfmqO+lJ1juncfd+PX1Kv6aeBso7cTQNOvgl1+vYwW7sJwFD36x4vRNGPWqYs/Vi4QosoII1Hvun9ZqToEfju18xhnXEzlrXg7/LA3rTLQBaE6IN/9XB/Tatv0CTp7uDKc7d3IbL1yOh6vtBUxjS2tfymGmNep6j0NPSakHtsC6RhEpMFvDUXQDJge0MmWAnYYO/ugVe83pscEbY+3Cbn1uOKLxDuXizESnBf6VrWli7osakI2nVm256yLaAhUeJouu/BT0y2uVxrlU8qjAeDWs4tkvMlm01Dko0BldyRnklUnzyHlQA+22rAnZBFkuWiC9otRvqZydFJiO1h7SBDlxzRQLuLOXWzar2sUcfuoyEJhhGb+NZ3vXmac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.09.25 02:45, Wei Yang wrote:
> When using mm_slot in ksm, there is code like:
> 
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, only call mm_slot_entry()
> when we have a valid slot.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> 
> ---
> v3:
>    * adjust subject and changelog based on David's comment
>    * use invert style for coding suggested by Kiryl
>    * drop RB and Ack-by
> v2:
>    * fix uninitialized mm_slot
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


