Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0794EC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC676B0088; Fri,  8 Aug 2025 05:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4346B008A; Fri,  8 Aug 2025 05:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA4A6B0095; Fri,  8 Aug 2025 05:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDDE6B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:58:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EC8BBF1CD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:58:40 +0000 (UTC)
X-FDA: 83753140800.20.0BAA685
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACCC4180007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:58:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDmWQgn9;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754647117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6EIjzr4doiTkMErgQyRymzeoV6Bv5w070CrSlCm7F4=;
	b=NA0lKPSOyoGq7oVFh+JB+GzHPtv4pReRsMp/nYlKixXcPoCe73fYNZ0P6BA5PLm6bSqr9t
	fGIuxsz21M5qhU3o2lBFYmsrv/edwEcI+Pqd5P5u9y4oO6dUxSVEM/0kvOl0WVMICMsh/d
	psiy4YrqJDV+TJJwmMnZfpWCpdGzf18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754647117; a=rsa-sha256;
	cv=none;
	b=I9NzpS6W/4Fi0Vo/Abcvn4J3tGbq6q5YGK8IbpYpwoC0neEVmYGtfjuNopxojkmQUSVGjE
	ftFsTYQuhKZ9ZSiLkKymt5elsAA+Jo8FGQAD/Nwyhj08kVCqwGm3j45sKWh7zFxWcFkIzx
	pQOlimlX0WdMJsABiwPlprP32oYGSBI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDmWQgn9;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754647117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A6EIjzr4doiTkMErgQyRymzeoV6Bv5w070CrSlCm7F4=;
	b=TDmWQgn9ZUnIkcidnRM9jZtS3bDSnD7h22H43/iyux0ZclaGJShNUdp95JJNPPJcaHu3r3
	W/gSZmXhwsTws1C2++4FOhUksAH/zeY4qNRENOZdhxdnyU6E65CJrO9HjDdkXKtc01cHrs
	S33d+n016iJviUHcD3F9DWYXUstSd6A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-A0y7ujoBNWSjBXGJYWayjQ-1; Fri, 08 Aug 2025 05:58:35 -0400
X-MC-Unique: A0y7ujoBNWSjBXGJYWayjQ-1
X-Mimecast-MFC-AGG-ID: A0y7ujoBNWSjBXGJYWayjQ_1754647114
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b785aee904so792588f8f.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 02:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754647114; x=1755251914;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A6EIjzr4doiTkMErgQyRymzeoV6Bv5w070CrSlCm7F4=;
        b=Df8iZ6vTS7KcuJ+3FD7q5hmpwQmi+2KkmWkjUPmVzVXVgz6R/+tTUNls63BmNzzMIE
         GKiakMmpBusoZ0XuOZxkzLFPfa1XRvVAz6yGE6t8B87FwL7kU6D4T22/YgEFMdIu+XIL
         fau8eEs+1vYvwarL221pHuJMgEJbXl9GvtqMIqhw7nkY8WEpIaMfsFtq3ifP0BskJ+Lh
         nwr0GdrnPvvsXmPjBJcB7EShynkiteIOoyvKhgac0uwB7qAFJHMaKuHDEzIpVO9Fv74J
         9A9oS8P+lZ83N9IvfS2GHBTZEgRiSb8fiFoR0pJYlZgzuVfu9jLRS3g20yI6irmKfoMr
         nPzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCF8LO1ZeSF56xUmI7CNDlIiCdVuTDOxGfB/SQ2JOmAX9/m9mAX5g3EZzvQAMss1FPIyqhIjAG6g==@kvack.org
X-Gm-Message-State: AOJu0YwfKaQjtjtBxN0GvcxxjwpMp5u7IVcCCNoX6ePJaBHy+wiw0lz4
	6ix4C0GqJ/fL9opSPCATqeVIClt1f2Ex4Ka7oGFW94uv3xVKEwlj9WUnfyVrSEV72sI2DW2Xwnt
	tayjWLCYsvOygs64INupHGLFpqSQvqdZjB/4uyRs0uHDSET7DPioM
X-Gm-Gg: ASbGncsfV80atp41Lkz1Ez+8BFToTkUaCCXgC2t7wtIoJ6yaczmHACy8U5R+B5N4s6I
	IVSFSSxdKLsudZ7eWmebFB/5vaS1w6msRycXYIsJizVRNiXMEtMg/HMmzG8Of4L51T+lggLXsZd
	fujrY7DScXRgtsDB5SeetTDLkhXtXcKJoljpy/1mWm4qLnCyApBLdXMzyVwsClMujF+LUF50Kp0
	7vbOM6dRuLbLOcGLhukgihuI1zsGYvdS9ToiPwl/O0d4V92wIFkj0V1OKWFsiQvuKPdA6GGRfDF
	VVVQonEtC7j1PKO3jyyMdL71f2SFWbHQtaw0dRXoIjI5J7WKCsy/agvjXmTlYOb/jFs1hG1TtLk
	bDrMYzv5F76lNBCIaExFdVeEp8QOigQEQG86GhNn5mRcYRFEDrgbjt7DAu7rAOjj+
X-Received: by 2002:a05:6000:2481:b0:3b7:94c3:2786 with SMTP id ffacd0b85a97d-3b900b4d3e9mr1836094f8f.34.1754647114342;
        Fri, 08 Aug 2025 02:58:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVDxTecPK31JPsEvI9Dj75n/o5Afl+u6OQsbq2vBX9FCRah7FVa6oNlXxQHp8K04vDbcolMA==
X-Received: by 2002:a05:6000:2481:b0:3b7:94c3:2786 with SMTP id ffacd0b85a97d-3b900b4d3e9mr1836074f8f.34.1754647113881;
        Fri, 08 Aug 2025 02:58:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c4beasm28963366f8f.30.2025.08.08.02.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 02:58:33 -0700 (PDT)
Message-ID: <985a0cf8-b6d5-452f-9afc-4c04a86bae64@redhat.com>
Date: Fri, 8 Aug 2025 11:58:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
To: Qingshuang Fu <fffsqian@163.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20250808095416.208289-1-fffsqian@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250808095416.208289-1-fffsqian@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X0U-o5sWQS-tKu6kaNgiuSeJGSfqvzLLCmCZmsQbkR0_1754647114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ACCC4180007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5u7dykwfstgmc13pfo4e8xjkxf8c1cxh
X-HE-Tag: 1754647117-358778
X-HE-Meta: U2FsdGVkX1+7Abi+oR7WUBV3UQLUEfDtMnO/c17uT4bzBSzzHJgTMnNoSfY4FzszMB+NBSr15ojpvZUrFKyjfYoULME+ifjWzlgoobSY6NSxjgqaAm9owGmZudxC6huGbyb1RuKfVMEpIOMajqo8nOWlhxw6Uhlp76ENrvVQb9rWA93/DXjTHS7Y+/8p7zvXXMSHNs5sGnwgu+6Me4HOSBiB55eegxMDOihtIzshXRj79NTPkR8r5mmnAAd+v3vZKbXw4Ij8brfHMzHdc3f9v1EV2uc8pv2VUFk02yCqzsgRtOF3Ai2rwmK8VnxuG6A3n/MslOpF1im84CjbWcV/Dz078KOFKPg63FzlX+JboWS+Hn4Le4lyQ2AvJxXLQCpIHBVyYozMwXTq+z2SohjNucjcIUHs/WtvvYoifF7OgaLCPESmp6hvhsbH4Xabx5YLf3Rrd2QYGqopaEbsfKWxaFdFo3sXetyuMr6PtubtVFUyO0kbz+E/GDzdLqwO+84y0W3d9bumdANKSpz7T28Lc9tUaUAPlHY8K00ZPV6YfMpj0SvPaXqTTn5+HJQ/AvOwXnx1kdnx77jfHTZNuoBo0N7rP0qPQccx5WC6Xz9g9A+L4YkL2/M3NaDXmV2ufVemnSeaYe40k13D4pcz5fyHSaC3mq5wEf+mkypu+zJfLTuCtZYVV/gLZVViLbnyo8lOtL3XUyppaXieJeNmmlxCqAY9VyBd75Wb9Pj7L6xHIB8tO35RGLjk/AZLlvUEufVQljoujxA0njQzfFVK/W2VlJArz6b5MOyq6+tNZeX9pKhCEHrQbwxtj2NCUfqBvLAYRhL3xGIjiZ9Ky3JzRtW4y0LH+es0LHO9lXm27XITX6zEzEDmbHQ0CYaCkigWmju9/zaDmOKSzqTCkzt0nGz5tYlwJRB9TTPJXA8hRVPQgsSk8NJZ07FHIeuLFnBWt0HZP1BxfPieDpW43JJj7xt
 WEufsqMz
 Jbl4DXCZvc/Co3YSIjUVlYnpZYJ6Bp/cvAajGIUcbPv2vN1A05nABOlL8l0uCAfTtI9abVS6IssHbQE7r8hlIeXuGI/ajQ5n+M0rtkm7UvI6seefButLsiZCfq92IrYrdgorgg0UjxVzu+8lhtxthivrwncYC7rvOaxQgLqqkGbueO/nIszRUb4JAuwtwHQdyQx/0O4VeGk4KimZS36iR/C5dTznU5fhpj00XAZRy+ZR20REFbgcrVCnJnS93C6P21JgFRDOZq9J1C1PCk3zjVDLlSP8l1+Qc+gVIdZUiBHyZXWedl9OP5rIE1yoNqzKY9vafzis3H3qTp3CtWasS5v75f8mYMcI0NfDPFZCsWtYhP5LRQNKIeFqAAk0Itekg7b0O7j5fMPSkGFuoAZhd/bQWlBxr8+yGHlnyr+znHVjmvfQok70QTk0ovc3SXhonD3mQ6G7hHh5tUN1iFmMofDyiGCbgVeFz+jzgqWElCrGdiQZnUBhZFck+VhVP1DnqpZLzXqHZt8bbOZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 11:54, Qingshuang Fu wrote:
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 
> Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
> is int,but MAX_CR_TIERS is an unsigned type, directly using
> the min function for comparison will result in an error:
> 
> from mm/vmscan.c:15:
> mm/vmscan.c: In function ‘read_ctrl_pos’:
> ./include/linux/build_bug.h:78:41: error: static assertion failed:
> "min(tier, 4U - 1) signedness error, fix types or
> consider umin() before min_t()"
> 
> Fixes: 37a260870f2c ("mm/mglru: rework type selection")
> Suggested-by: David Hildenbrand <david@redhat.com>

You keep ignoring my feedback and I can only reproduce this with W=2 
where there are like a bunch of other issues, this here doesn't move the 
needle.

So I'm afraid I cannot spend any more time on reviewing this patch.

NAK

-- 
Cheers,

David / dhildenb


