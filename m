Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C5560A6F4A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VGEtV3iY
Received: by kanga.kvack.org (Postfix)
	id 7DBD66B00EF; Wed, 11 Nov 2026 03:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7648F6B05C8; Wed, 11 Nov 2026 03:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653216B05C9; Wed, 11 Nov 2026 03:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 401F86B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:06:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC596120225
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:06:36 +0000 (UTC)
X-FDA: 85422106392.06.7315293
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id E80CE120008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:06:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VGEtV3iY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlimTFKZ+lNbv/kTaPDoKbpQOPhwFKn5jhXH0jFlnbs=;
	b=l/wPG2BJGPJjbfVjohc7g+eD3TRMnhnDSNDcuuhKz5LbfBPo7S1Vew5TjiSqemrM0vxmq3
	SMj8kfdCW7W7dHAHO5ns3m/JoASZBkDg1pnzfBhZmkNozT3pvO14lfPbl5gdY+k3/e9naZ
	5qgHhYgYbl5HusMmx8cCp9J6Oq7Ojqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384395;
	b=ab+stJyE1tlmrRghfTtLA/7i1S9r+PRvYDUxSpUESZJYWy4lC+j7Wv6LknjZHvQeSA/8CT
	B6/3t5EoQx4fAeekAmC5pusn3Gqw/sjYaXZRVGNTbe2HZtqcZlW5OdAmr//Zah8xGShtGf
	HJHpt/yn4Yel+EmHLwt4qPaPytnkzbw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VGEtV3iY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ede7cb02daso304055ad.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794384394; x=1794989194; darn=kvack.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WlimTFKZ+lNbv/kTaPDoKbpQOPhwFKn5jhXH0jFlnbs=;
        b=VGEtV3iYD5jHTyyrgXRxYKQZJ43hrOyNWnjW/DfSGEzfY8kky5KrwwjkuIwdioeGOT
         xY8xvwtyVr0xsNgDE7hgpPDJk4qdWJibugKDyxRCD/f6a76ZRu/+lCZzQbsInio45YCr
         RuCjZKCp20YIOYo2FwcOatgmxnD5oMvMRUMVTLwBvxZo6SFbXrIc3tcJturrxfQb6h5t
         Vf2hxMKG0TrfNRxkK44GVIo7WzbL7HWGwHtyxsnZMNEeoC8uOlhX/gCWOskcPRw2VJQJ
         5g7e5GgU7rwVW51+TJjyuuGynCGmzVLVmYMDlVxsF+HOYHWcZdbcmG/Hnh/mgam4KDZC
         CRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794384394; x=1794989194;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlimTFKZ+lNbv/kTaPDoKbpQOPhwFKn5jhXH0jFlnbs=;
        b=chkRhoF0VAVh34QPfrDgUB4KCTLhpip8z00zGBBqdZjz6IBnmH8EE4e+9HP1ss9Xd0
         ZFo4d/5JIxMiYLSaYwzjoHwcEBiiD5qG+n8m82Kx88eFpnQ/Kzk7V0oIoEzfI6HVL53q
         RUyF9EiMOeZ55Emuh6pY2NQcTnMVvLjwTE6BJOMFqb6a7rSEaPzG8Vv1wvyGURzffd+A
         eIH25bW0YBWSFIOJ/t39TPp34wq7ljCSt6J7TRe2XkF4KD1ZXgh7dLeIT4agHh/k/4K/
         uSMq6PJ4FBqM2FgtKOh/yVEFg0HRwL1qjoVVkDGEIHdrJQ29LTov6cT4uih46DE7CjVD
         WA/A==
X-Forwarded-Encrypted: i=1; AL+hErGze8tczDK/pOXVsEmzg7UZpS4hzLp0vmAr9XA0TpQihHXuqyE2RRYowipND1boXLgiwIfcPCepKg==@kvack.org
X-Gm-Message-State: APuU4Z+Ci29xzBBbrxU7xCJrmOEtxwSgauVQ4W7icXepG6o3uNgASaIc
	D3a+nDXcCp1M9XKE+MYaP311O42ai61gwicmg/LDBLgEU34QaKsxPXLa
X-Gm-Gg: AYBFou1/37u6td9cOsy3LvdFdK3Qk6t+/8tvgzJXi9Cq+jsoJhkIzoRXdd2zR+8SmPv
	TRVsLc98N5jeXf02hEMPrlZSAXzkp3gpHUohRkjA/v18ZoglzdHwm0pT3EQOLkfAsKjXSDZEIxa
	prx0pFAci21lVMJSAXgZddf+jXiqOd0XxF0yKjY0eL8YZuSOWSMlrPrBcUk/Oqeq0XgAULbZuuU
	w0Wmq/2BSyEi3nSxy0hWKojDbWZxMNv5WzufjTFn2wdHJobeFNFSkMamhtTcMu5uIHbBbmyhqPh
	7JV2SXK2V+8iTAq786ezVoEYWfeDiPW6ApD7+ZIw+qR7X6qUOkLRMSRP5uvosiHl0Vu+SX3fHLT
	i7KXoxvN7mhvKF9BRJCWLFgnllRiUr0rqwbVzlcyfVKWm1vgdafSW+S2VJxQPW/GJsx4VkOaNm3
	13++lwmMXcHYmwcl11LzbAEpdtPw6zpo6IuHr14h+yprBCFSVUyDOrr6A+iQO91meq15m/PBF+x
	bNxpufqE/z67dwyduF9H6xE4h4Ai69Yc+MEO9RsrZ3OPTBDO1HhpyfljSVIU2yoG16vnAnuKE9b
	AiHHAkpoEkMkbiD8FaFh08TaG/8/SpRhPw7t4S8M7+2hAPvstn4J7S8JtqvVAA==
X-Received: by 2002:a17:903:468f:b0:2ea:238c:4cfd with SMTP id d9443c01a7336-2edd408d124mr18545445ad.25.1794384393591;
        Wed, 11 Nov 2026 00:06:33 -0800 (PST)
Received: from HFGF46V04Q.bytedance.net ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6de7df0sm17417515ad.63.2026.11.11.00.06.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 00:06:32 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
Date: Wed, 11 Nov 2026 16:06:21 +0800
Message-ID: <20261111080621.63932-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org> <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ocetxa5qgmqyqddqojmtyf747co9f7a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E80CE120008
X-HE-Tag: 1794384394-833835
X-HE-Meta: U2FsdGVkX1+wQ2icXso+Am9JD+UG+mWNK+HfNZJlwRqfmyk+1dv+P6wL5AdtTu28WO92SVUkg+3dcSZ/jDdabCs7Ip/RIgi+D3+GPZm73aDHS4zrHRylAAAnSw+5wLOKFdFHCYhNL+59z5U+xBZI2lnPwVicwuNOMFqwOm0BBGkpAOxSeuf/Pth+fiZvtU7YQ00EoqEsc1sdG7ALuyClFgziF+ZnfeNHhOnDc6+/mj4IVfzO0uFCP512lZ2jCBwgoLwhd8D1R5Nt08CyCO34metstSbMNcVFc/i5S/mGUZZBI3bzNt1qqNxDYmXOxZWJfqVtI8yCJhhsk8lAqYGKYK34iRDcB4Q6nb62TeijVkq7HZDAmsunYqQDwvkYPmy3Cf6XlVlIQGHbVKks+/kgbMIbC2X1dTJcxrvm4M0L309NjhrDiGt9F1IdNu3XsUqQ4xYvSWle8XJ5PiHUzROnrsY1cX+tj3B13nv1/bjwSgEvBeWq4HTIJcigjhZmmbgTklpx/ZQPPEUk3W6ekfMCy6Gw/xuYxuxnmmDGR2KikCEwIuqLB4HrYkG+7a6btNqverETMFeYhwTRXXWvxfylD+8y2vaAFH+UrRc4MSPhv7MT9MemAF10m8E9uJsBbrTyb3LO8a6n8nRMUiLqsAoRyIMsu4S3vbx85hhqU6pAxr6E5Zub1wL/pH9pMRmzvGbk8FgSk2QnbZla3e8bRecEX2wc+3Q21Tg+6f2OYgwiOlWKaAYPjaSq/R9zBXDEb1Z0fSK0qDyAY5y8JJeSV6EUEAql7v4a8GtfQIuEVNSTkRlwwHVC4Dn5ezAsrU4eG91dzK8nB1h1r9WjWSs4uLUNxCvbMoJqzuN2smpA3HygX6XdKqX6TKuMlL+sxwux+oPN+2tUsfFaCsDOpmnTbawa+1KjYTQNmUpYUB+mtCs5+AoyZrfgyna1EFCXdn0ETBzG85ONh3a03z1RlPLOUHK
 06cPNpWB
 5IwLC9NXd7GmzejailRDoFojnC2o56QwogpXBkMpuYZHwx7XZc5fAFnSi/enTK1ragac8aA334JP1p3Tp/ZLbZHeWRBYGS2gI8ROFlvD8KcNbu46HC0EcUd2JZZ7eIDlJi8/j6udEI3KDuKCupOpnci0dF5SrV+aoaSzmlga8TKBNUN8vVR9qogWz3U8mr4bvQJqf2GxPJ/TeDjE+a8Y+TD/WhmLAHARHclTxAmO96T7d4jJHgDXokNzT+BJ1D8iYemze9jKRvO6vOmFiEGw9D30C62LQ9taD18D0BlXD6f4t3efA1yMFwZWe/r8Ms/YRXBvVGU6GwOZtuVMfi87NheKuuibCz7y8akwoCftGjCUXwQSQOVA9Gk2XQa2TB3GjEbeogQNc0jd1pBdf3HMelsDzKxQJQ58lI+hUMD9o1NppM0fpXU/zZWj7KLxN7ka9ywdCSTNTxZEFF6iVMp4xyQKBxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 07:31:53PM +0100, David Hildenbrand wrote:
> Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.

Congratulations, Kairui and Barry! Thank you both for all the work
you've put into MGLRU and for everything I've learned from you. I'm
grateful to have you both as friends and mentors.

I look forward to following your lead and contributing alongside you.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Best,
Lian

