Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4575D606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=VVvQn0d0
Received: by kanga.kvack.org (Postfix)
	id 57F456B0990; Thu, 22 Oct 2026 12:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F706B0997; Thu, 22 Oct 2026 12:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CCC6B0998; Thu, 22 Oct 2026 12:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26EE26B0990
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:43:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A73EC1401AB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:43:54 +0000 (UTC)
X-FDA: 85350833988.03.D7F052B
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id A67F214000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:43:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VVvQn0d0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792687432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETjJA992+3Nw94AfVhCDwB14jB6KIUui/slQ6pLMm7s=;
	b=EwNzUu0P5DdHv25lZlaH11uleUe2SVd1DuLgMKOOtQal9Y1Xy/D/vV3wiYAzp6Uk6TBeIk
	TNt+STEc9YP2mGBWNatrxJyY2vNHf4wTC/5j13dy9Kh3fFNe7Ndlp5oU00Pc8OoC9dbNh+
	yyutKTcucdqpm9VopVvGn/4ZPQZ9dXE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VVvQn0d0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792687432;
	b=HVflN1CHGk1y0ZPacLNHoJh7X8eBoCamMqWK40PeAEYDUir6ks1gHFobs6Sp0OxMk4l5jy
	5jyjz7NZzQbIzUQxa419zpuNH8VtIMQ1ZecaEXPKtiL5k3SJ5sTkClPZJdDjTUJj+MZP2P
	6zcOBK2skN8RBnUROkfwTwx9ppOOthY=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-677bc4704cbso106142d50.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792687431; x=1793292231; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ETjJA992+3Nw94AfVhCDwB14jB6KIUui/slQ6pLMm7s=;
        b=VVvQn0d0cQ5qaVyYtyRE5NQSpiY8ILTbT14ocqtkwUt3Vd/aXIa5Xzu21I4Yp/rS6e
         JucSmkjrqRmXnnDMH2w/7ja8ZzmVFpsDyD6qwBuJCL68/j6xcZOtu1CQ6o12GVhIp4Gi
         35quDr6FWNNiIi2ZhFGImP7odUtu7FQcB07htCx0hDG7TQMPsQvOcX7SB3SO2MGtWQ9T
         lIp3KfaZqGToWVC7EwjPGQ63uRDVIFA5Vjf3sr6vN0LmF9Vx+kcekxZvOpWiDK+uXkgy
         BN3jE3/VoGBdNk4dGQFvxPgn+qZrT1p1S07tgHHYmfBn+MPWMihMLDTBBP7z9c7uwcRu
         rhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687431; x=1793292231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ETjJA992+3Nw94AfVhCDwB14jB6KIUui/slQ6pLMm7s=;
        b=uWbEmP/zonfXcJMulBg1s+x88/9OD6JnZdPnb62bSHLS/LB3JIzxOFBv4M7ynenvdf
         bQp4SplLVtLYJAYLXZJBjYE/+FtT0kFi4/tIYDShukvuNqJEPYeBpMPjsIBcmtVYLnPv
         QUYvpLFXPxPmVK+6ba5G6NDK6PvazhaR8zWcTUb+xx7mK8kxQ4vTlyyft+z6YBMoCOoq
         QDhMWwz076fnoQjRB4qZkPkbfKn5deK5rmE7XQ7hPq2YaR6GwTQ8Yvl/Y3wXJgfHYFl2
         yVhgYm5llF3715yuiy/VLyrquDU0iLlFG1QIRCcjFXJ4rL5TtZGC2PlrlAjffsSkU1qF
         h6Ow==
X-Gm-Message-State: AFq9FYIIAif09fLowRQtpSUr165PE+wk2NarfOP/ATiS8roGBNb8QjlC
	Vsb8JxALuMNhd+H4VEWLXAH2xFXTjPWI28uu90ymVgzcIW1mJ9pKgMqtgrj4MMMhpd0=
X-Gm-Gg: AYBFou38LxN9KUfcRyZ7bIl0SC4D8NNyX3tji6akJpXBOZeWb5PqRi0b6uLe8cCF9dI
	Ec4tYhSOvc6vYdbmKPBxxPI51GHrixvaVSMJEwEOnV9K5fA72Y7Rdx/BUA0q3VRbGcr+uEZOKFc
	B9YQ1hExr+UC5Uu1c4nIw2LiWm87Zz6i8eelaelngpupSlei9FgpdByxPRz65lDJ33lzO+q26/h
	UicVdeZlLJ0TO52SXi5PZCm/dcoNHKN/hL/xdxOKlJ3zr+735sUiTkwzqmA9c+tqxs3SZk8IuKn
	g7TK9BFuRvfQWH5t4PN9myjpHUrWEKCLA8vFvtwSVWojSkvuVSxxiprnkcm8rcMm2FWpFEZl8xX
	0f/82ENMcyGun9xFYI9017M+e4qK6sW4ECob1m4DNCdLEPtO7SpfHtUdOaD7wDNqRIFXcZ3wsnW
	m4Kl/D2ZcACiSHtBpdVnz036pQE13+HMPA+H7uhsmAWGy4DhWS+DE3fKvBWtu5sA4s+QOY1UM4x
	XFclY9nwsq77PwBK7ga2VIm5FzhIJzoBbsR0pqFg+QpLvHVAysX0c1Q
X-Received: by 2002:a53:dd09:0:b0:672:99e0:ebdf with SMTP id 956f58d0204a3-67a0e57f0ebmr1751623d50.119.1792687431653;
        Thu, 22 Oct 2026 09:43:51 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e496732sm2881390d50.5.2026.10.22.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:43:51 -0700 (PDT)
Date: Thu, 22 Oct 2026 12:43:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: remove unneeded forward declaration of
 __free_pages_ok()
Message-ID: <ato9Rvu6H3Ze60ht@cmpxchg.org>
References: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A67F214000A
X-Stat-Signature: c4grfn5awedfidzuzr7z69bu6539787z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792687432-342453
X-HE-Meta: U2FsdGVkX18WbYMiICrBuDwnKGoUVWEMY8UX0LVul+I8B/6hyZohwLbPsvUw8UhLUCssYE/OxryyBZZCjtFlcSIwh+htJo9BZ2/eJ3/TL3vmvFoAK+5Q9WF/Ihs4PJpkLICHVPaFJqIMaB2CPdMLvnhiVc7ajGcnEDsstJIhgZr0yrGy2PbhpcOOJ9gQcyAqKdLQpKVlViPwuUiVJiPZEcXfiVX6tRjzVBfpzHGrcWIfT9piCJvz0+iLT1NxqxFqiNDPi2ToENKggfIoGchTyNFJCxy6VJlOtxLZMFzA0SOXYDlDuqWwv4SJTu5YHA9vXa4j82b9vBj5eIzCkhTm/jjGVKeue/x6stiHMbQq5g0sbDSWy3vzFAKyE7npIhyaRxU5K7z42BuzpaIfK6qpK7BPI372VoglupAe6VFUCMvNmfXlnyNj96Os6QtgoHNIQuNMlD09/TawgcBt4wd6Uk7NqZjanUt1/fokwVSe5kmY15X0oqMeYhOWM8SDHajqdd5UTSX3oqP1k6bM+iGysPVN0iqrkvAu7np//b9Mlu1A7z7A0Osq23Vx2HR7yO6omHXmA+2S2Lcj3csed+fZ6osepF4zN+gb7txjH9/3Bl6lTvRS25zl6Tp5jX+Q8D6G4eL57eBaBabkmPbhFBl4HEx+VObGU38n1VkRzxSkqLr08ogMBWUC2dp1ksIpXZnNo74RJOSCBJah4KjeMPnAsf2iXqA3+zhEHwUywK0SVkVx0R5zx7OqhTMdfLrYYjykeXfZgeL9Mh0BXlbe/x5SyZ0I5HzfN0sWD26eK4NOB6N4OW35gigJGjTBQIttNg0fSuKMBfCERNu/Y3u9fAvk0rMqqAo/C9ddZUnRzXCEl/IqhRN3+FGmUo+ph3OOGnsLt0pnvBgHcdvcBhB2NNo8M6KwtBenJFhH+ShTH6B8FDVUMGHMyN3/j6CNl5c/w0tQSQ9o86rZ9lqM2ksoHLp
 VipQaxt/
 VKPWf34dTC+0HT7JztcYYz7T8GK8xGA2z7F/5LHdN2Xc5F/NGHFD1H9pJpXXY2UVvrKWeGgTo8SIEyTrTo1lC/9TJotQcmuaefgNuhRSEplsITZKF9BoFEXszF+29Ba8iKnpKYuvt60bP6iItwgH0PMd2YSHKhMqFyGSotaT25X1RJaduIK1AHk20kgp5HfSiVp9IRRw61jdRLCf45zgBkeapI71ZJOKW2vz4M54THvCuptaenHGqKX9s+2JUnWliEIJ0qIb1/1gCTFLQjOS7dD3RN8JFv9FZWlVcHto8GZ8+ONVg2HkvDqjU7Qh8eUZQtaxZg5W4qMefACnMVmyJuvuqqCr5ZT260vTDtwJaLe++ZzJLcCX8UPgr+MHhTQtM2uozNO++lZhKpK56i0MO29GC9NhXPMHFq0foywkMHhyovUX3tvofBVWZfqHEd60g380dCYuOmxrdDuu7E1slwxjOjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 08:45:04PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> All remaining callers of __free_pages_ok() appear after its definition, so
> the forward declaration near the top of mm/page_alloc.c is no longer
> needed.  Remove it.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

