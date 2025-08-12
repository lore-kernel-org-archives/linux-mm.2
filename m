Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C96CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 20:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6918E0194; Tue, 12 Aug 2025 16:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9969A8E0151; Tue, 12 Aug 2025 16:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85ED08E0194; Tue, 12 Aug 2025 16:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74B5E8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:58:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28250B616E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:58:22 +0000 (UTC)
X-FDA: 83769318444.19.FCAB014
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE86DC000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:58:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMszRP1C;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755032299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLgG1VOToCvTU0vQ2PDerMB8RO+pRBAvNmdyO/d/EYc=;
	b=tR+z+kH0ZVImUGUpoYZ0OHOcDlwUTMOjWkzd0p4RhtalI1KzLk6XXEPZ8SaMMbj4oo5pdE
	nJq0nxUzJt58MQkRwunbg2evQDluVawHEJzK3M5VkOXWaZlU+vg00v9aHhDMlBOAD/TpQm
	RNeF2o0ZcSo3fHkMaBkchQ0VZ3/nUJg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMszRP1C;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755032299; a=rsa-sha256;
	cv=none;
	b=o5mxNKIsctTgb6MmBREMLIuMG6Q5BHUnUqf3oueBE/Uw6L3Hm4Je9XRJdNyPoIVfynbTgm
	9VzHe8ftUo4/GBSYRkQxw2H+u82BcxpoTV4ag5+CK2KYUn78PoT1BsH2/+x3hzgjZHBnYk
	dzqMDD5AZgsjPobV2Zba6Ev7S0aGQMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755032299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uLgG1VOToCvTU0vQ2PDerMB8RO+pRBAvNmdyO/d/EYc=;
	b=hMszRP1CYoKJASTLiR3gLsBI0mXMa3xqX2o6NAjAKEDnf2rGrOe+DDr02VGGS3Uya1jTwP
	jb85oVzGpOQlSXlFiA4FiNt4UXH9AOW/qtCcm+d8g0OoIq1t+1SkhXYm1TGbw5XJRf2OCS
	O+68iBd+5cG22OmODISMH6MZGmEWuMI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-Eyq7AZngPfm4ix9fWytocg-1; Tue, 12 Aug 2025 16:58:17 -0400
X-MC-Unique: Eyq7AZngPfm4ix9fWytocg-1
X-Mimecast-MFC-AGG-ID: Eyq7AZngPfm4ix9fWytocg_1755032297
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b782c29be3so3103513f8f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755032296; x=1755637096;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLgG1VOToCvTU0vQ2PDerMB8RO+pRBAvNmdyO/d/EYc=;
        b=I+rz4fkzEgwuFFWk5u4iGbszSljajlzzL6WUaQJl6d0H6yI4L1Wbj2RjQ531BHyt5b
         4JthGf9sPPNARUpvLKyvOdM19qEeTMA8eNoHStPlQOxtwbgikAU46fJOIdV2WVXfDSx+
         /hW6i7895b2SfkpU78zyfTU6TYolCpffYIUdH+euX62HtpY6nA9rHDriorXc9P0O8aZ9
         QldJeV0UcxLEU/G3fLxO/OzM472QG/4sT3enP5ckLNsAIEyec7/6GTCEf4Ra71uunvcc
         lmwdw8n6czZsfHwDlk1A7MyNwnbesbwULS2pT/6MU+F1jStm9cAjdscll1dHfQuhaIgy
         9OWA==
X-Forwarded-Encrypted: i=1; AJvYcCW24iYgVEAoVkxblx+Mesljm4AwZ1MqKUyd4Ihz634J5NYe8Hu9vYzV29BhlR9h3uRGxvBMvs+/rQ==@kvack.org
X-Gm-Message-State: AOJu0Yxjjw4vRy/4lPjUbZKxsFELTJ7yJsxs232taUXqVr///+5KX/b+
	OWWfHEz8EcjoQRW5B2TSLlT9YkDJhVaeyxj7hOZNZomnbZo7HDAHh9ot00cQEwWzAuQ3TIxcxrc
	XEIt1E5nln2iVTKo68PlIZnPTGY8AHOzNcEToTP5s4Zn9Fun79+1a
X-Gm-Gg: ASbGncvnLN+GGmmTSxRhcYzSktjx7Zydenmp0Yl/yIi/F0iq6Nx32tEdLIfJ9h58flA
	SEg634+BbFPmN+I1TUEsHoqXzCciLyiGFB31UpK4h6cLt5J7BawLCEkeePsEIR57N/ZXzt33N7s
	wk7tj/dpZyDliEmHpRzyrqnEi9oX8/wI0akCFlYGNGAfw9RWYe3Uwatbm6Xl3SXgS3WPXCZzbIr
	vpU/Cv1XC7tn7k3MCvlSUaj68GziLGUxFrCFdyFreiWsmX54bvxIQKIPU6xBsMLu2dusOvR23lh
	eIPHHdOW+cshxLLH4CmkYJe/ZWx3QvzfWpWkQYeXvxqW2UZHvesLW8TH4qIniVNQAkHz8hSKPHH
	ZHAXqKT1+HeOsDjEtp45RzrWKARpj5aRQzVN2Tnrl+a4d4UwGgLDqzDvu9tkRl70dm2E=
X-Received: by 2002:a05:6000:2405:b0:3b8:ffd1:80d2 with SMTP id ffacd0b85a97d-3b917e465abmr240568f8f.24.1755032296525;
        Tue, 12 Aug 2025 13:58:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFus9+PSGOYma3qAIBPvbqxlVjhulo3axCz2Rux1VimjwnzUeqE708H1Yik5XMuzNAGjgNRLQ==
X-Received: by 2002:a05:6000:2405:b0:3b8:ffd1:80d2 with SMTP id ffacd0b85a97d-3b917e465abmr240547f8f.24.1755032296092;
        Tue, 12 Aug 2025 13:58:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0? (p200300d82f30cb00c4258b4bd9adeee0.dip0.t-ipconnect.de. [2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf93dsm45534645f8f.27.2025.08.12.13.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 13:58:15 -0700 (PDT)
Message-ID: <26a947b7-eb42-480e-9b17-3fb819ba896f@redhat.com>
Date: Tue, 12 Aug 2025 22:58:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
To: Qianfeng Rong <rongqianfeng@vivo.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250812135225.274316-1-rongqianfeng@vivo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bv-gV8YLxSVMP7zDqjE1VQQrZgU3_DD_kKikmMyojdE_1755032297
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ot7r5y8i4qaekh53a4zw47aewcf1my6h
X-Rspam-User: 
X-Rspamd-Queue-Id: CE86DC000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755032299-570704
X-HE-Meta: U2FsdGVkX194f8xFaShhI9iJjF0rKwtTzO8XeO6NCHeFSkREJD1XMxRw633scvbHkXGjED66xaGSKQIKqvQGg0p52Ciwej3tJpZIzCOxkbLlKxxIutk1Pf7aQKjn4lLvdKPKJLDSQg0MN6bI/zCUqeGgarFR9G0+ZEQCbsyeHqvlChjpIEzHkMxPJLIgzSkoJKBrLsf1qbK/sOq82Z3Fs8W+A5c7DOiAo5sBcqYUPs1sprA5Yj6zS5gK4RT1oXEooTTDb36uWYbtsUhPXagesvtQCh7gIPnEZ/AL5DwiLtyqg0aM7aRSRbtkvHfbOsgRFJhSwZgp+dDG6X135pnEhsgLAkCQuuL7eMfO1Fau5sbM9j4N7hcboo36nJOHUCe1sqNV06aWRy8TA2Iw+F0vxq9nZqNttAQudblbK0US39zL3Myi4CjxBsuw96QwBkS6TIALPxibJT7Z930TWqAHRlfHZr1zvAYmDNN9xI7OoiCOdSSC0y2j38x1rzLqHriLqN66LRepuTEsXyFXgrk25NfnYt7Ws5BRVzn29RM9RJntbOhLCsw+8MRjR4CefO+PGxOJXCtgsOfxfq0dbede1uMAFcfmBqxipeSr2tuRirjWVNQ5zRGLmnZm7msjbQuMx6rT+M4X5keOwMrdZ0GfMO78QueIeE8hk6bUx+885UrrYol5zn+Lc4VYTO6U0khdprrTLBG4YuECu4UNcabkSmhxr9F0FcJT2b4ac9gNbEPsKzZ7CMxun+EL4KSmSLCG9jqPetSzAC2i2aVijTj8IYrDM3rZUIaLM1bRK5ekZo7k84vCfAC9WARRUax4VbCJRyGokKYLfEjqBh+ux4UaaZkND4UZgaMkjDDrvzmv5SwGeTdgXBHR5woDkcfGg0cw/irA9HvUqRNSnm+WeUsWxRGnnx6YQSy49UoLrIFO/9Ga1JWGQ57WcIorG9gDfnVfEteJNVrkoxK6B3XlFUA
 qvgI9ZLK
 CXrMo5wsX001PSNughX64V4QvbcRjY4eAHqbuS9ZXN44gLel7oxhCLH2Gqn4NmUhPjO6gMWAWzyU9vDlvVwl8UhYBsraN1J5+PzADBJNTr3oufEosWOOZFJtazxbyrYWOhYuhdbjAcf1quAJCJ5IO1YMlUSYjhdfhUsyPEznFm57sKhOj0CCn0oiexjpwYddLY617dEzQcWqtUO5QnZpAJ9xxrG7gAA0mU4dzMS5ODgCTOp4n0qQNj24JBkFvT4dPYgN/T9EBb9nCKr8Msl+nSQK24xcECtqEcQYZQ6MTXN9qTYjOsU5xRQ8sCLHvuQ9ueb9pGJwKWM78ZYoUcq45tcY9mKjVZI6m+suz5LO2i1UddIMhhxiGeoewwF+7Xft4b6YQH6F3LtvT6eZ+057JlU3WeI4SuJZjXgWzomLnKjPV57nxw45cZr/iSxRH5EW3R6aC6UeTZBYmwVExxEm6zbrHKtP0XKrhvJVOTksYrS7NQaWiBQUNkmq7knxyXn+s5tY7QNA3BrlytaI7g1rwlSzK0KkDMprxWDYHZYVShrStz24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 15:52, Qianfeng Rong wrote:
> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> redundant flags across subsystems.
> 
> No functional changes.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


