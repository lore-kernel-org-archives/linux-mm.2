Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2E3106FD6F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6046B0005; Thu, 12 Mar 2026 23:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081906B0088; Thu, 12 Mar 2026 23:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4026B0089; Thu, 12 Mar 2026 23:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D738C6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:51:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87E318C342
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:51:37 +0000 (UTC)
X-FDA: 84539665434.04.86DD17B
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E75B100005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:51:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wpzu1cUY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773373895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnnptNUhMltrKlyMjaLxe5WMhNgNFEdG8YnarRRsgts=;
	b=8C+45MFC9E1xjC2kqF2lG/gGtXTp1vaxGO/QGGYn2oVhNofFHEwHRZtr3myhvsebd68z7+
	fICAQrkRaPbNLXXlM1xMSPS9LMyfGAwy46uxRMFmWQjHZH3/OwJSyXU2940yptUcKVfsLu
	hgCVoU7Rbn7tk0Hf/UVbVo0zLQWhBLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773373895; a=rsa-sha256;
	cv=none;
	b=iewhALwOIMRuVUYMUcV5o9R279h8EeUiLTHDxZOsMEB4f2QaV8QYmYktmWk+uQlo4KkrZp
	uzLal5ReTVt44Y8Uncl81JglnR+t1YrIYeg2f1NWmCazClcvruQg9FmJVuZZCFsCr6c7mi
	gzL8BQKoCXAIgo4rtGLcsukqdbBFkIc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wpzu1cUY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-829928e512aso950445b3a.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773373894; x=1773978694; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cnnptNUhMltrKlyMjaLxe5WMhNgNFEdG8YnarRRsgts=;
        b=Wpzu1cUY3vVhj05WQiUNceI0vRYgAcaOimHqZmrdzQBTDIRgTzA9BN933/8oVuwOn7
         WkD/Lnnd/Y01/AVZ9osTbDC1pq+SVH917QXx+R+4YhP3YvP6GXiRiIHLsO3L2InnDcBU
         P0u9Iidmt0xWfDfpklghchvfdF6wYvgebpC+Ylx6WYQ6S81eZCmb6xnbV/KRVRzbq2uF
         cUq50K2oFQY8jAt8QenDqui3ClDrFuBS/AEqikJuRolUp8+t3SV2yK9NsMKGggYYSPRK
         1hvSsmeVz7aXeX/+tkfeibo7IDxse49qGipg6IobgTdEcoUkuXyOYxZcP9CTxUio4R50
         UWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773373894; x=1773978694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cnnptNUhMltrKlyMjaLxe5WMhNgNFEdG8YnarRRsgts=;
        b=SExRmpi8RrvtppfWFsXJweCZLNTiBPNXiiluafisybfB+cKP3N2JJ6bQ0kePuxKlEp
         tbNKpIRswBBP2HEWjLoYYY2lMj2FboDfW3pXok9YXHbf4GW37VRnNupvZp+6pT3Tw79e
         jHxR90VHi4uziFL+hthbCbt3ky+EjvNUc0hKqMb5JKftE7qQe93l+pmOAJJaMtw+2cpV
         e1ceTto350o2SQK4w0TyrKeaEJjcbaaBp7S0qgidG9HdZc2bWF1fRMdPTRxcxVUsX1t0
         C/1Atb33I5Lau0cuzEYgs9Y5B9HA0azLpDUSRTHJzW0/gQkiq9vce1xUozZPaxENDYZd
         fljg==
X-Forwarded-Encrypted: i=1; AJvYcCVvj6IZCiSuVv8259AjbXDSgZqUrzWrwnvEchCW7QejN48uyT7JfGYKPtiQCrS6ZNSpMUREGX18hA==@kvack.org
X-Gm-Message-State: AOJu0YzU1vQh+5EDseXojks4dxezsqLwo7DALLg6xrr3yA1tETMOxs8p
	w8Bm0Fd2MI6VCC5K8shJ4flzG9TjbxWhkrFpEyueJtC6kteDDh6zJUSK
X-Gm-Gg: ATEYQzw5dTCNPp+Nd7FCifDdrm0oDOOMzbf9imLEbcfciKqbORldf3U8wQiVjLQhwIH
	YQYeHpQEjpGi95Ke26k48sprYYW29Hs3KS99cVSw68LV7mNnnluKjF/hobaPyLRiqn0MvA52lig
	phN6rhcnUCBbXmzKzPlhM+F4dk2/ZXAW+DuCaClKlSsypbFJx71aYE3DYkiujwAeud0dJxJtPzk
	9FwEAXd+ldE+w6ysWTK4pQM7GJqg8bvpjoMyEB4V9h5CGkg/kWiRPg+LMtHYVp7N+OG67IZ4WYH
	VhNJGEAi0ZB09/7K26IBlIq2IAnZx7sL9Ml6cwfdO97oQadjT8wgz/MV6uGMk0gv1Umi6OCIiJ8
	B/tlnTy5c/GnuwYlLkUG7Gw9dNxJ2mbLpGiQt81SBbYSki6OsdRUx0vSdTha9JOHTcTSg8cn/l4
	PqoT5nz6nVgVWh5Sjsafr4TVeI2ywxW9friBBB7Xd0ijq4SPPHJkvuDwz99OrUjB6d5YaIBL4uo
	jI=
X-Received: by 2002:a05:6a00:7617:b0:81f:4ce8:d64b with SMTP id d2e1a72fcca58-82a198ad696mr1148602b3a.44.1773373894195;
        Thu, 12 Mar 2026 20:51:34 -0700 (PDT)
Received: from [192.168.123.240] (n058152022092.netvigator.com. [58.152.22.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07343719sm4525615b3a.38.2026.03.12.20.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:51:33 -0700 (PDT)
Message-ID: <aed07229-9432-474b-8498-5e23893e72fc@gmail.com>
Date: Fri, 13 Mar 2026 11:51:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org, david@kernel.org, dan.j.williams@intel.com,
 ying.huang@linux.alibaba.com, linux-mm@kvack.org, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 linux-cxl@vger.kernel.org, dave.jiang@intel.com
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
 <abLl84pc7tavuieW@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Yee Li <seven.yi.lee@gmail.com>
In-Reply-To: <abLl84pc7tavuieW@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E75B100005
X-Stat-Signature: xnhiap95qipwka1hhnret3fotf57gtr9
X-Rspam-User: 
X-HE-Tag: 1773373895-339998
X-HE-Meta: U2FsdGVkX19GHUBI85xr2z2rNDKwA4zO0TCuBxy19ftXT6tAaIYzFNtznCII59VFzoMOnEg2OzYsWOb4gwdmsBf2Tl+BfvYVcLCQSFHj/45CUvV2dTr80l69uzTQo7L1UwZa8vnBLWpMjhT/4ccqqeHLKHThgYp+TdvE4PXJ5n9xz3VG1wezpYgUQ7UUc81FhGb1yFq0Op7LAp+C5I/t/l6CdY+rua+4bL/S9Jd5xJoCV9a0fx2tdt0ovaOtHar8RLOpFaYslwoMHE0YVFLEbe7Z33U8Qq/fXmyAYfU9IPP5QtufwytDGzpa9RqZ/lwCGItxu+P74CNoh/AjCgTk0HdFZprKtPQ9FIo8v57oN4eGO6qpwIIa/A+y/xv1QYvet1U0+2lYF44TY/URTIvyrUV8HZO8eux7NevnXRcQfbPT3pfrJDgT12291FhM8MHJUC9BgBvmwCePfUdVA6JV3e8hJ6kpv643w+WyRf7winYgbZ2xAtmaJ8n7a245oBUsUvQCok7FY1wPCwTSYtHlAaQSTaiV7karkupqSOS3rVLmhbKTJkcNXDXVis4+/ej7Zb3XYtrQMW0H4nb7L5zyAFjigq24QDb1mulux1PVstW0/wXtK/sj2xBI0PiE5GDpx7GA/m1v1Dmwca84PzE+09LW8nhxbUdlPajYM8gA06NJnaKCpYYsqmngBoQ9LD2wSVuOeykWlFGGXtvGg7l1AYElMCHbsXoydy6KxthLZsO0gg8RJ36m0cr1auHE8zA4n/MsAA3EhXrZV8kUSrS/6CfVKKXcGE9ftiTZVw9BHdKwgPT6EjJCQY3YzZlWylRN7bkQLCi1mrC21OoeZAnrSK5JEvQTdfSRIb89VkPY3ghvS3wYPREvSPH2UT0jAabliTpKUExltMqzASGQ+Bzhkj8SK7Ih/s5gpa1aAoCPA4vQv8oWvK7mefGqM5qCETW2eAOCvijBfRnh7Y9is/D
 YlMIhOny
 8WuGCC20sVRlMsagRgvYMK9n2Ec/RRe0Yeo5KWxPqlVXJnU59nhSiuv/ztZtl2Q/xXtFyx9TkCS8AUU+Qt8U7KSjzoglE2xhjKeoZ2Hj6Ae/7+FO5UArHuoebthnPjl4daNaRjHxh5gUUTiHoGSz4acpVadlJPO/mn9R1yMLurHGavA9vSXWDqO6yg84CqDvxeiv1jAcfIIad7rVqjiVw6ABf1Eq+ECgmRYZMr04SUh3VTMjnmYluhhcEetkbDLtbkXdRmLUOUzSzskXMtBFYYBHuO/VbYH+HQz+WUVE9CBhihHYpRbWOhMx5MzD0RbOlUeWBsKWSU0DiT2qmafKXNKtnGYlRkbDo0DR8fmmAu/k76gOnEHvzACjqsz78aOEk8UYYibgufDXSe5gQhohbCKJ5eZPmMt0snOoyFFaTgv6DZpneqDl1vyWvWDirUDDg9wYGdL6OEUDK9bL3mqswz++cCLyTZOlMT4qr9dX7L85Rj9lKNLLui5Xkb8rf3tMx8YLjIlc8HLUJwFPkHdUMciA5ydU/6oWas7xhEX3uWLmErTs9LHYZz53zCDUX9cIMlJ6LFNejmVv4cZ+c53E39tV8VbMLIoeFuMRKnoXSxhVi2I0oYFShXiLGb720lvPLbnsD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,

> If userland is setting the raw bandwidth stat, why can't they do a tiny
> bit of math to figure out the preferred weighting and just write the
> weights?

We're not setting the raw bandwidth stat directly, but overriding
the top-level bandwidth to observe the final effect.

> Should be posted as [RFC] then, I don't think we want this upstream.

Thanks for the suggestion.

