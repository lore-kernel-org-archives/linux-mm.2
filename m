Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2CA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DwgnBSBk
Received: by kanga.kvack.org (Postfix)
	id 341CA6B05B8; Tue, 17 Nov 2026 21:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2E96B05B9; Tue, 17 Nov 2026 21:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209256B05BA; Tue, 17 Nov 2026 21:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3B8A6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:20:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74D111405DB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:20:03 +0000 (UTC)
X-FDA: 85446634686.16.2DE26CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D4BD20008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:20:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwgnBSBk;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968401;
	b=pjKIJQYlrXcawxCL9gBBj8Z44TfBXljJUu5d1Od1i4J+sm0jdio67dbIAHNFPhzfAZ0Q+J
	JAHirGw2U7cLt+0cDSJK5n0i8Tv3Fb0EufK9/Wp6Dw9VMq4EvaLbSyEKp606YOa+qpE1zE
	DUTETCEGHX07UXhekUv7cJaQk6AAF68=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwgnBSBk;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QH7WQFtjw+b1ZB9MFgRt6yEqYhXg0aU89YQL9+GV2K4=;
	b=PUct/lOh7dZ22k/5KgGDVkfncY20xCP+8zOF68jsJF15/wFJBbjf43HTYLAX/BqFFgindm
	P/BM+AEYzI028OAyKOd9xL0aFZ4U1kP5BAMKzTD/Zh6U1EAIhbU0fM6U3JMBdV9jT/e/ls
	l1T11V53DiJDCcbkU7uofaZ3ZMX3R8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794968400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QH7WQFtjw+b1ZB9MFgRt6yEqYhXg0aU89YQL9+GV2K4=;
	b=DwgnBSBkL6sGMwsBFYwxfMy93bo4eBP9OZqhjxDZEL15g6fuexDE8oLfFK4IcKlWWT1C2g
	gFnfaMawjUdGsN0LQMupfmdhirF2Jtk+v9iR7n+dKPRhbWIr8dSY3tn01ZW2hdqBHc+O81
	xoM9i29ViPEIPVB7qI5Ye/1OnNK+xU4=
X-MC-Rep: binary re single
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-SfeJPvwVMFGv-LSoMI_qtA-1; Tue, 17 Nov 2026 21:19:57 -0500
X-MC-Unique: SfeJPvwVMFGv-LSoMI_qtA-1
X-Mimecast-MFC-AGG-ID: SfeJPvwVMFGv-LSoMI_qtA_1794968396
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5363b06bcb2so9132781cf.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:19:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794968396; x=1795573196;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QH7WQFtjw+b1ZB9MFgRt6yEqYhXg0aU89YQL9+GV2K4=;
        b=HAUfcKB/hG/C61lNnL9iT4TJ4aX0DGzJ8TLJZdCcYD5FzIV+ueAoLRqJQ/5F9ZIR76
         T4WG0wRjJuevBQ7JvExgRaqoNf9VlnSMHOoxyHkrjxh2d2K762nTlE7S1jcrzU06OzxD
         Oed79WVy39110BfnaGIyXCX+jRbIo56ftMja2WWU9zwiWFlqQIPGRjIhVRkVymu6mn0s
         nmZOJo2GaewBhYkjnGJhOKJXswrjSli9n3KLxvLSQUODIGISGmdXvtA/1kTBDbhXlR6I
         Plcd9r7yGv8Y4P/zVVSUaLE7Zlsa+7AlL8w0JDDiIKQPtABZLifcjKdoFHj5858eDFdB
         klIQ==
X-Gm-Message-State: APuU4Z/degS6tsPbWUP2YXPHEYBhRuD5zy2fMAFzzCLj5+DVxiVHxEZL
	n/2BzwjszKa4aw74m4b/aQWZ1X9wWsxWoncPBlxv5ccB9gE/nYqZ8zuXW1Wwdl1fjgjnTRYjxg3
	NLET5hHDI1XseZYackhVZ30yWYEwDDJXAME91wOIJNGu+mv4hOEdL
X-Gm-Gg: AYBFou3HwLw+g+Lwc3RQBXO0DmBiCE1hXN7kVhghH7idqAOr1+7ajrVHL25xwX26fPG
	OcL6JI45fHborWln0AikQKF2cLQWHPdl8wYlgF4CrXIeQa73BhmWwE8bwA8DlerHSL+PhVI0wdg
	RlJClzjL4oD75DmH4PNHrBMSysnX1X1ZQ7yEogfbwvevBIIu5Crrmi+mAkz0VaP5i+XD/QxZQy8
	D3xVXt+UfjVSswshfdS8McoF6h/JV5VhFhYpgDLGipRNCUgqc5CjYNEwcHKNphfZ2HkYY0zaon0
	2eMoiNf5SIeINntAV0XrE5zdkvkNJJpkw82+ov4Wdjho30DzeTPQn6/e9UjAAitbKSpE+yJBmfW
	FukrMXvlLdwzLeOuYUWrkkh6QB2dQ1IC5JFhjqxwWW2B9GtPpwLBl
X-Received: by 2002:a05:622a:13c9:b0:55d:3219:352f with SMTP id d75a77b69052e-55d5a34dcb4mr21966001cf.9.1794968396451;
        Tue, 17 Nov 2026 18:19:56 -0800 (PST)
X-Received: by 2002:a05:622a:13c9:b0:55d:3219:352f with SMTP id d75a77b69052e-55d5a34dcb4mr21965521cf.9.1794968395922;
        Tue, 17 Nov 2026 18:19:55 -0800 (PST)
Received: from [192.168.2.110] ([174.93.165.160])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d58fea489sm11141401cf.6.2026.11.17.18.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 18:19:55 -0800 (PST)
Message-ID: <23c9ac27-cd26-4995-b301-f2efe13ccf18@redhat.com>
Date: Tue, 17 Nov 2026 21:19:44 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bDM2dKWur6H2CDge5Vm3fZPhNnkpOOBCVJTkwNX7dSQ_1794968396
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D4BD20008
X-Stat-Signature: jh1pnh1sw7dhtp419o55mrt3t1nbwrg5
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968400-283411
X-HE-Meta: U2FsdGVkX19/VoWDkTljsvfCdB9Ky0mr4yEw5f+gIJ2z0kvuBj7zuP/aDZf/tcnFtrLtmj8Qfj3F6AJTZJsEBN7QNLRhggVkqpLQqKkVltz41Mb0QGNiitVsNwJDOhR+vqUIgxK0gZ3vZEKI+CQNQW1Mkta/4cqD4TUQLiMv5cZ0iJy3nyUduDooG4kkppp6xhkGUw4e4lWPMGl/EgnkcxNDpmVuDHkkMtp9ue2A1IqhO78o0/x7OaL3fzJ/st2YuIHjqr+n36EvsQqODgRsOpIfLskahOXM6pWJZGUVkcQEhJjpkDo4EYug3++QtQKA1WmeKxqpKBA1gXqjs8D9Y5mzJgYBlHL/xDCHnprYyTKT/S7Rw9JD44605WuSG65NLdqW7tN3HnuaX1SlJh79gM49OTj6UVGvg6yfrjAdKye27ZxEsNghY5tmfRpbhZSeK24H1S2IM9iKthV3ThZ7zwS9l9ur/cy5MjSJUDqlagsWLreXPO29qdGpf7nHkhNZsaMTzrwlz2s8wZe1dp3Cwxfb6J7M4Nk45f3sFwHq0GEGxwnJrS5KH5HgpL4sWSr9l17No/3J15EXSBgNbkAs7wJiPPCDvONAQMdntOvXvehYJ4g1ZYMuVXmieMUV2Xdhg81WFYawE2WV56nuwe0E8Y01uH+FsgkBdFfPMBxfPbGvBliuyyg0ApkAYjfNoDqzJ006ZGq4J5vCXrjBKlor4Qh7wzZkNGSym7I2OwaSaTbtwHWkZo6tB+wOPRr+o0TQcwftrbHlJEFY2qonvmq70PRLMOk8QsZVpHvCqEOq4ndzlbtsiT/prxjIwKPbPbFChsARBNClZ0Jnhwpxcc2HAQV7grYQm0x0UI03c83OL/I5R0ien3l0G48TYWkkcqC/jRr0GZUErnkWrvdAkPaDEbTHDV9QrIEQx91ik202YJQE+cwDikADwACY+DiDL7Smt4at75hGHRo0o5s8kc7
 9A6HPnS0
 BWJ/fQETMBOs1JETHTV+uYpmF1bsPtLli3EhMra3wskxWzKb2O7XaLN/OIL5Jxqa9wJAljO2gEVIxcxbtviDLurTsOhzaDR7uwFCI4WgoRk5Zy0s9E2lDmVJP82aLZqhcUOSp31DH2LwQ96nVL4WKpqvRIM+Nbkf8/pLL+h+IuHR6Co9bZuBqeyqfzf7ZbwUQOVBlgyz3oEoXkLFG48MTbip9tV06bgJyfoJ004pyv4vMoycxbV6fO3GKh2oH9rHR88LRzDdkehn7bbxaoIIRdKWHyZjA9JlB8+vmMaNxm0bDWgX9FcZowX6am1LJtLdtpFqr3zr+jViwaKuBPfHBsMQapixBnvpFJvyY/8hhWcGgTftXXLz5vhycd4XJiGoJTJlO5Ed+qssMdfsurBKUps4iiHb6lt/zTDN/5pvvtGb+OqY/X4c5gxYgek1WVseE9C+6O13Bs5eOHtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 11:26 AM, Shivank Garg wrote:
> It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
> for page extensions") but has never had a caller.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>

> ---
> I found this with the kunused scripts [1], which I wrote with LLM's
> help. The v1 cover letter [2] has more details on the scripts and
> how LLM was used.
> 
> Changes in v2:
> - Split out of v1 [1], as David suggested, and based on
>    page_alloc/for-next. No changes to the patch itself.
> 
> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
> ---
>   include/linux/page_ext.h | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 79c53ec45dfa..52a8b70c525a 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -167,17 +167,6 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
>   	return iter->page_ext;
>   }
>   
> -/**
> - * page_ext_iter_get() - Get current page extension
> - * @iter: page extension iterator.
> - *
> - * Return: NULL if no page_ext exists for this iterator.
> - */
> -static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *iter)
> -{
> -	return iter->page_ext;
> -}
> -
>   /**
>    * for_each_page_ext(): iterate through page_ext objects.
>    * @__page: the page we're interested in
> 
> ---
> base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
> change-id: 20261109-unused-sym-page-ext-3fb8316ac777
> 
> Best regards,


