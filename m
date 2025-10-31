Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C1ACCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D78A8E006B; Thu, 30 Oct 2025 22:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787958E006A; Thu, 30 Oct 2025 22:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C558E006B; Thu, 30 Oct 2025 22:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58CD98E006A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:41:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 000601A0357
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:41:39 +0000 (UTC)
X-FDA: 84056858718.05.75C78E3
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEE9A140007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:41:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AY58cN9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761878498; a=rsa-sha256;
	cv=none;
	b=UmP1lZRk0iH61ZvO/S+RtRctOMBx3CBnb6ZXDgfuGLeK9URWjvW4hBMYhCPZ37G39gXIK1
	5YCzf3rKRIS4fYH2vekSrK+i5GsJYEaFvX65Ei0g/JlHe0YeOfEAbE9yh/+pE70WfMIEYm
	O2UMYLYGpxReY0vLzJp03HTr/3Eg2FU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AY58cN9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761878498;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8K4f+qBwafVznhIbPVk3RvAHNaTQKFSCyEiTyB6/Js=;
	b=LjCN9WV3oEz4RJl9/yHtJWuEtpAJ9pKivQRiD/YuvUovNYETHCGIYgQsX5hPVnUXxgaSkj
	/fatR/AlrskiBdvoUYfrb8qKrUlX0gnN5RKxaAgSZf35P4a1v21C/xvLMqPLEVzC7GDjjB
	0WTLFHCly8r/El84nTFHbxYZDt9v680=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3c2db014easo384068366b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761878496; x=1762483296; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8K4f+qBwafVznhIbPVk3RvAHNaTQKFSCyEiTyB6/Js=;
        b=AY58cN9og6owIPf13qZzuRaybEeH90HvD69viDMQRWR7hlRZ7HWxhMX/zYhg0vYFF+
         t6V8+dsNwWGIeDgaEEVnXOuz/wxhjjXkoKJtqr3Vrb9kJvKgBXPdr7u5qchhbIFlAWQr
         OnYsaWP9q45Q8EWW2PHu5yoawxqJYzbfgUDDRAnLhoSnNF217d4eJx2zXlbLMJIq4jQ/
         bENDTQKj5LJA/t0igGQnP8PJzMXSRljvTP3sjZ0/Ke0kwY6MI4VrotlzIjubeyEChf/F
         WP4FvbbVxNh7aFLEJ82HcC6wgZSvvzoE/BIoIQSJbVthNxV2T8aRbgqnGk2xlJ7sSOwU
         eXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761878496; x=1762483296;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D8K4f+qBwafVznhIbPVk3RvAHNaTQKFSCyEiTyB6/Js=;
        b=iMWlolyFBanyC1t4UxA78VMnDwcM9MaOZhjZjkwGPyaerw1ITqIqZfY3IKIi+hq3Fy
         wGOnWfLWHO7HVqAeEZp/fmk3YMUkpS19TVStpSMoyfZL6oMoRchtj4xqoz8TK1yXhoH4
         D2gx4oGn+XY65Xg0g4dbam6ZqOq9Hxmx4uoytkwqXuJ7NW3A0e77d37vKuBXYv14SxEp
         pj3medjbgJe1hJW9ugaULW73EaSiz1afLtzJmXkH+I5HhFSOQZZzzr9mgfHIkj89JV0n
         Zo+onyvReg+JoeZFG1j5OcK6oh3nOUtIfdewi3aKXnV3SgnngZoX1HIFeGYfTLKR4l42
         ay4w==
X-Forwarded-Encrypted: i=1; AJvYcCVlUDMsN1vO9ICO3753tJ0QND3Pi+HLEG8sMsQS1JORRFBCOsVmQ2SVnxYDllpYhMrZG2z0V8gBow==@kvack.org
X-Gm-Message-State: AOJu0YxT4FnB+FChmeWtbxjAusSfuEDmko3zjQAJmVrtrHg0UVnknZfL
	7dCg+Rh7ycSd4KnnmoPhSr72SweR7PtGwJbWO6iE9xTRzS9tIfC61T1G
X-Gm-Gg: ASbGnctXmsJ+eiOAGz2uHkLQ8DL4amKF+LeP36ZhPFP9+FdVO6uNFaYoFeuZgkd6/ZY
	WjnDQOyC+9NrK9ShkZqnqE8fcJRkHR0XzsR3tYYK0SXgE0q465+9MozAM4VEtb0dmJ09cnBoXzO
	43/h1OnIWXdITahBZg4TGrfH2l/tsnBXCznc3HEBgqfaXvdr3XDBxufUo1a/Ikog/corqcFfcMn
	BercwpBIGBKe9SMscLPYToOZpeiVtNH6eSniX3HUOu5sSEwC2Ssezq7lIj4Kc2cA7tdxWNfkej4
	SGBWJF4iVLjGazvDZLLUeCoKf5gFI6MzgGlkKDK6ZAdYmVlMNzD32c+SueSCh8OE9ApMTgZjfuA
	Rkrf+D4jrhjLhENHWMqzlDCQutgTSC1Rtm/iNJprK+XE34h+eZnjWoHOprm2IM5grVReWAQvO0q
	keqbrtft2jhw==
X-Google-Smtp-Source: AGHT+IG1AXC7Sm6OYw7C1ZASw22VMDmIY0Y536r5bQC6IFq1Acx29vK0ChgCjRiB9igtB/mts8AWKg==
X-Received: by 2002:a17:907:d90:b0:b47:70bf:645 with SMTP id a640c23a62f3a-b7070844419mr177169766b.58.1761878496225;
        Thu, 30 Oct 2025 19:41:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70779ac3casm49556966b.24.2025.10.30.19.41.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 19:41:35 -0700 (PDT)
Date: Fri, 31 Oct 2025 02:41:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/3] mm/memory-failure: improve large block size folio
 handling.
Message-ID: <20251031024135.r37lpni2vw32wkiy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030014020.475659-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: s3jri5dekjscton8dcoy5155q8m85e4e
X-Rspamd-Queue-Id: EEE9A140007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761878497-727780
X-HE-Meta: U2FsdGVkX1/iXf4ENAkjyNT5V8flR5yinSMd3hEEiPK9u3eb2EF5j1BgqgPVrgB6QuwpWCmZarBs9bZbHtNdJl1UlvotYsRNMNE8+q2quzvSbex5DsZ4B2/MAORRjjx/GlsLOV57TEe1RjDYp+CJdM3KU1571kBK1H34VkHKAxdLVvRD9QDmNR0yGceJfOfL6PuVqN3+EHrECGmGM2YxgQ4ujlayer60cRx1WFYrppq5FgHrzStevy/pp9A3rUILqQIqYJIA3frdazTRgNsQ7gCv85e5dKo2ibCotYeSUKSBdrTj5lxQiDYzxdLKA1DxWMiBFhWfoVJW2jPjK+Wy/CwJcimqlITk/RFRJD4BwwpJmcZee+UmvlEeyAkYpaqZFiOcQ9xWKk/0zUYOmmML6hl+NfdxgI4MrUBvbOiCmCIJ8Sj9cim0nVL6M/GL6aiy89AIIC3t3sb3lh3bicI9/Ewl+bvFPlFNf6YTFgdWSj7sQeUTDuQRRFpnlRY8y1KWYCHiAQLA+pwFqG666TOz4le5Kox1ttO6TlwALFcQAwDCRAaQaDI73cCp4t7su5q/1OoWg45zv5N4oG7s8YuMbrI8EtrLEESfOjzRlBL6CuGCSxHw49c42C+SLUS32qJgZl6lCOK7z9qeigRHAAgFse/zSa8/dDEWvvBRAb3x2a7jVFanVSzM8M3cGc3NPH8yUkdLJXo5DsemG6ldsMGjFAeC9djApNvGngxTrRNyfRe1EplKksnftywwvlD8c+/ieAJ9Q1qnINVyHPZCO/IY0Ydwq0rUguVWLjveEB3N3tZUjHXddHOQQK1PcURsk1pCwfEw72kR06iBU3RIvPsyObI8uKt4YysCyzqyXWBFyJSmsvAMpENiyuKFq/KMkuwuCZb6jMHbNcTbCOW1ici7pJrPM7/tFR1LrvOzKQetHk0o+HWF76KzB1Cb8pj7AsdVuNz1LZ/h0UT/kkMw0o/
 FzGB0kiS
 W4rnlGy3qt/sVDr2HmI+s+mk8Lo55XQ9MUQH88JJM4TgwQuCdtpdtMSdk2VB60wptHQfEgKdlnun4u3rG7zanE3BXMPznN01DmlJG2NtGaq7o5KRWXvd+eLFgg9R+awfzzWH68yQ4dWdO/yFu46/ppwqSyLuwxSGSTOKR9q6AzysiwQx2gtobZlUfRyh8VJSsTCk3i/mS8RpJo2oX4C4JxymXT8heRrhBrrakXSU76snzII7LJm6GWdGIsRT3y9t8i773E5b1QHysdhLdv5ptq+eInrbmSeFwVFgGqWlOGCSDy6iVXAbNIN5cnyHPD9ZCPBSFiN3Oju2Sg+RhAqpOZ9FsvNbmfWNpWZgkVx0kdzfotLI2EbcVugZHaKLKSUctxiJaBNwX3ykIA7ygPSetX5iFVP4l7iMt2iPKZ72nDMV4BWI+kAVyppaO44Q0ZY/bjljWV07pPFI/N10YeHfrNu16ozWXDwTbkyJIuRjxZR3AddG9anEUchA06xv2LsxXy8rbG/NRg4ZpozhIaYb6zI1gGe56uNdv0zem9kLWuPaUR21hoN/ctXyB1Bh0T0doh6aDqe2izw/Q+JTH3COZrtMe9ucfd4yVsLtqFRqv3X/Uy1/drw/RfMGI6cO3sDqS7+BBTQB3YkkA1kNiXOJPRFDUrpGE6KCT9PxVgRRSE97gFEPaVY2VCoYBs5gBqJpITJgKCWYPfo2ZcgBuFm6EeBTu3f2gfKkZ3TzPZidM9acF4nKQamUJSNYaDrHL4D3ekKnycLm5YmPcubWZYeHCRMKPs0tapKKlBFflkXKzlslqL9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:40:19PM -0400, Zi Yan wrote:
>Large block size (LBS) folios cannot be split to order-0 folios but
>min_order_for_folio(). Current split fails directly, but that is not
>optimal. Split the folio to min_order_for_folio(), so that, after split,
>only the folio containing the poisoned page becomes unusable instead.
>
>For soft offline, do not split the large folio if its min_order_for_folio()
>is not 0. Since the folio is still accessible from userspace and premature
>split might lead to potential performance loss.
>
>Suggested-by: Jane Chu <jane.chu@oracle.com>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks reasonable.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

