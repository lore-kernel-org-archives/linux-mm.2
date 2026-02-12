Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3AEEEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443FD6B0088; Thu, 12 Feb 2026 16:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AE86B0089; Thu, 12 Feb 2026 16:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CAB6B008A; Thu, 12 Feb 2026 16:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21B176B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:22:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE7F91C269
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:22:14 +0000 (UTC)
X-FDA: 84437077788.09.8B10AA4
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id F347240008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:22:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PB1roJn8;
	spf=pass (imf01.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1no2tHnWUokc2knFQltcsvUs2YRSdVUtSLFMCjUwtQ=;
	b=KVGlE2CdZszEZKRFenqZV/9io2Bw9vtI2zaLf3ugzLAJOzutP0hqqNvoEPIs0D+SkPhwQx
	MZIrbEI8ebTDfEkGAFnbt2uUxrVkmzwfddwX9EihZZGV9H6+pJM/ep8ImG+rnOn0L3vTXg
	yVhEoWzpMWhp2fXfDQS1vqDBNPZkBzA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PB1roJn8;
	spf=pass (imf01.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931333; a=rsa-sha256;
	cv=none;
	b=3ibQlmydLV3bm1HVDfXt6CEHKmx/fL8bGn7PWuSPTzD6JpODuLxbPNrApTUH5a/hqXT57n
	irRWzpLEu114YeIFL42hBt8RfYBIdLz/c8ua8SaGnHJN5d//mpfkNm1VPA1uPfPG4r2pqA
	8hqogWQ5rQ55RGRkH4kd34R3tFvzXPc=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1271195d2a7so600655c88.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931332; x=1771536132; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R1no2tHnWUokc2knFQltcsvUs2YRSdVUtSLFMCjUwtQ=;
        b=PB1roJn81rGm7rxhWV/x9/6Cr1cBksNfgVp5n9V9G+MZ7Xom+LjTITtwo/tltNnzRB
         qyyZsDJLQBHVn3bN3oIpEouIDY43kBoN6MgzBTwnlKFonBC749RrFop147drDW8vAUO/
         xLRzrFfGXBI3k0qz3ZX0p/m4UgiY9mi5lpABXDd9LLuYWd9XGFgOVE/j9dNVr5QXdWoM
         6MItY91nGr9Ie1C1d351vE+8YrZSsKa750WJdmQ4ZtUedp5j3EzBz/nT1UC66OI5vRwO
         Ol3j08EqICfjQdh3TuAPe4+qsJacBxuSbNrtpwmjEVkyF3J/ltrp0zp/IxKh6ZV05R+/
         VaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931332; x=1771536132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1no2tHnWUokc2knFQltcsvUs2YRSdVUtSLFMCjUwtQ=;
        b=jpNC4ddrseV6hqUa1j2N27UZhsvhixf7DalE5jN4xCrqp56hF+nWUOspyVul4PYWJa
         vmGnfOIyhfFT3Au/H8g4EOJbGTqIbnl2MbaFhTm2EhnqtlZiJsebJx/30nkdisD2ljg+
         0hosb6QYRGUhA47zw8mBoEMayigl4Qyg/JxfxsuTyWhIQuBCuJ9ZK8Oqm85TqmPr65x4
         qe4r9OCx/E38Z16yim6K/exmvDt/KuOlyz2Wk6YKQEmnYYSfJXBgMvGwTWEMwM0g+7N+
         wOYQmPEHVZz9h7lxtqklnAkTYKYTbIPxepAz7i3JFqMxm7VdTAshOPxzoLPI7LKMY/cI
         pBGw==
X-Gm-Message-State: AOJu0YwT+9T2RqIMYKXQpMMVpXAFOztM7RzihClv21BOqcMPBzNInlIs
	DwxSAUp6tPCj6tPiAXe2jQj/RqUzbk70RRuim7XXxSad9T1Oebr+awuK
X-Gm-Gg: AZuq6aL8kV9O6iY8/nw1+c5X91uwsdLDSFl7AuxbksTOiJP4BUm64bUsvMxjJaUHR1+
	julkRCJcRI9BAbQD1kXv6DWrK8HYHxFIUUgjUKi1ZnP0nYsuarZmf85izmil+ceXGTVA4/MYj+J
	vSYIazLNlB194HpZHmcXzJxJW9J0PbxRsgR4pCIxFAaJ4DdcCWD4xOrHhH9xn1hst3gLBcjEhAw
	sG7ptZGCkO0WTPbL+4+1m08ddikfziHdGw/A9WGu2E3PEcY7CZF6tNzyMiMJZ0xxV/rNupPmmH6
	6wpr8TX3zWhUzyLSqNFKigb2HmPuPilg3cT5evcurZQnUPlURHPKlQOcqVTKdicWoAEdcgSjgNY
	t+wxruP6P0wly++fkhq7r7h38GKuieFqN2CV357LVy7of6TY+rL7FgiPz2MoywtAFWAkERVUnzT
	9UKADjee6lCgEst9tsagQBcwkImD0LlJb7
X-Received: by 2002:a05:7022:4395:b0:11d:f440:b758 with SMTP id a92af1059eb24-12739829f69mr179121c88.25.1770931331418;
        Thu, 12 Feb 2026 13:22:11 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a6fe357sm5577294c88.16.2026.02.12.13.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:22:11 -0800 (PST)
Message-ID: <3bf72620-88ac-4c56-b3ec-0fcfa53c14c8@gmail.com>
Date: Thu, 12 Feb 2026 13:22:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] improve per-node allocation and reclaim visibility
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 vbabka@suse.cz, weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <aY1dusLPzP2AHP6f@casper.infradead.org>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <aY1dusLPzP2AHP6f@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F347240008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8b4ij9684tqxwghnhm3rqqka8i3rrpy4
X-HE-Tag: 1770931332-479465
X-HE-Meta: U2FsdGVkX19Yg0ahH9ppRM6Ukbr27apK0/tfnHWEEMQi0y/k+/wLTvD6eRO0usgq++q5DFDpvGmmkU3ZNg2OFxZtBuC2pbyxuTvRRyCubHe5+svF9+5N1hbjyfR2CaC7WY8BlPovBgwY06NXU+/HSIjL+dZ5eJ5YyxUWp4zYs/ZxPhiS1wzVxA+udyOprKEOQIV5tL9DdF3esUzktcMzK5h/d4vUAGS09QhCRcpODI5x8XJYzbplbUr956Hj6bPygwC2AF4XhPG5mgJCwAHux8XY5JIO1e5BGP2mQZVLYHmeptMYBk0fhBZ/+OkvISXIsb7wJ0Q2qk8ri0uo0Sh/8NvyciobxpfpXG6Yz49oltCdbKfBQzxId1SCxQFx6otq2b6QswuCDPKhsmEBUtdCrQ+pBxxb+eBCLfRnXh3m1Q763j0jhhaEYLseWqN44MuGvx+Sa6irK4Efc+ivlJyaDHyMFlXbgmcuqi9bp41Mu9CYX7BPJo2Huq6BiHlb5Z45Wbq3/4edzAikFjjb6DfrfCj5Hr3dsmjKMcg1A0Zuv0ydTUeu1o+TwYL6NnzhDb8oVRuCXFe2nHyzKEqy7jyiKGkKpE1Yq6UuDmMCj2dNyD6aAXAzkAIIIMuDu9WSe9yFtcC1kkPwheZK2ectAUKkBHaev+h+nymgz21kM5OeBtlwBtWD3w1DXg5xzt33yp83NyjqjGL2qFnC0uubcLOm/GfxLyRUn+EhHqtfCQkAfGnat/TvupyOvNQjzP5/ooihPpQGo2dOsQ+2789Pd4BV8nPAThrJkl8quwl2QGAFb5i22OB7zQPReSt4Bfk2TrkoagbBNFuJZnhFesgOFhwuGKnhkwge14WKmdmGha2Q4/mNMUA+fnW3myOypdcaKXVStL6ziWkt6QPMZim42HDV1TBlK2PCkD7+TDsegfXqbjDVieQc71SDx2OtarD1tCPus8LQE/TPQNH5b5TDdQj
 hR0hkUV7
 wMtoVsKVKeVxYhA5x4tWKBg4eMbv5Q3dUOlpaudDLq5jNfwTXgHVDKvoda3W7MHd6/MFqd/J1SVjr8W5ehqZFcDqsupqHEtz7ZS8m1ML9yA2UMFZDC/+QFcNpTxN53I4WduzELuQg3c+OUTWMWyKKz6dbLexuF2Kspy0O+7GX5PMJ7XGp2goi1oHVfYbI1fWWd7iz2PDUEBkNNAUquruyccKbv0i9o1OGRltvjevMmSbezlhRckX/2qHrB/pAOTIY9M9K+oerTHlELw6i09tGNs9wTPya/P26+MztuGpt8vaPmemT/Mdt6QnTHJORY6QPKzX2lRXG0nWZetq7soSO2VkEcXprwlVNG2z/BkLKMiQ1oGfz2GyhO+qo85D0aaihWjo6yPFN2cdQ6qMIgqBZL70Ldpw0u+0/GSpcIL/+Fgb9FdFcTHD/PRDuycATeDEFB9PoUH6WhMWGmdpwfjzgmxAeE5GTZbqGE7nks+dKw6ZUcBK7iuqfjxyVreKfu9wn4iFsXOtMnvX8TcyedUPEO/e6N5ejLYOMPrj9XUfjptAqhpJq8cGFOJcSCimPghaVH82D5MsHJzUY29WB0fZQzXGgEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 8:57 PM, Matthew Wilcox wrote:
> On Wed, Feb 11, 2026 at 08:51:07PM -0800, JP Kobryn wrote:
>> We sometimes find ourselves in situations where reclaim kicks in, yet there
> 
> who is we?  you haven't indicated any affiliation in your tags.

Meta. Is there a preferred way of indicating this?

