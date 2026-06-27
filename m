Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6595CC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333E86B0005; Fri, 26 Jun 2026 20:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B996B0088; Fri, 26 Jun 2026 20:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224006B008A; Fri, 26 Jun 2026 20:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA0C06B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:52:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74B981A061B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:52:54 +0000 (UTC)
X-FDA: 84923867868.02.40A2E19
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 811F320002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:52:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gp+t/72X";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782521572;
	b=8LdBecXrw2CDJWxGUUkq5gl6Q8irWVzmrnGxsMuH4KStWWENSy1yKWxrDo9huDH+DHyQod
	5WElSUJ2NNYLIioxf7L633ZH5RuTs8wzMULoFnbGnVg2jOWfPhmtN8/4DbQBstdiYzLaXc
	QkuC5mRb4PcepXEEuWeTrqAXLGSSd3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782521572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVYfSXCDWmf5gbYok3uJRaEhWbuILu/Vcmy1zPHwtMI=;
	b=THRRWK4ks6oxMNsZj5Cyib879xDk1RPcWpgKPFeiTI6uud4EJeuw+TI7jYsJK22oR9ofvT
	In3dsYXVKagORV6o6Zl6QGxEI7Q/AkuEfgAE8WW3q1jGOIkbbtuektEnUGSMMFdBT/FYes
	9POJt5LdMm0bNMaqglytEzToqvOU0aQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gp+t/72X";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9159da9bba5so151365885a.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1782521572; x=1783126372; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVYfSXCDWmf5gbYok3uJRaEhWbuILu/Vcmy1zPHwtMI=;
        b=gp+t/72XhUkvMAddrAF0xmYvLAb+VxOsuIZiys2RfOCZ8xTnqquOGcOrhbSWe1wIlU
         Xp0CZ9T+gFuXld653qKBk3SzHmYE+81wWOSPDjonPoll9BhoJqwLpJMet81WQ2GVTSdF
         8ZEFKzFsR9JBJo6lsZVcno3YfFaEAuTuzy2KKpS0n27hCWlUmvI/ZUwxMCZWSmMyzhqm
         dYvs3ddqGws01i6l5SgMBzrsPFyzJVxKBH/JbVlc4BE+MYyFY84BlLQF7fl6q+ok9SiV
         6KB+VDYf5g51BL8OPNELhXNxX3YuCORODRsn9AOnOZUDGnaiuDBkukGvn+RwMw/slsr7
         6clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782521572; x=1783126372;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVYfSXCDWmf5gbYok3uJRaEhWbuILu/Vcmy1zPHwtMI=;
        b=gBSLLFUYZ09RpP17KqxgTmN6o+qUiM1EAFBuPdLrAsZ1moioSgOcBekFu6R1dmZqGm
         9nDz6ztCrHsol99tQtRmcNT/SLQL99SLjJrNRZ4pScC5GvGWPwH1fYhYVsvrXLE87+7d
         cZ9tg/G0kQlh/XjnZ+W1B4QsjZxZGB10xRw9N2ty87n0HN1J+kv5vq861PucsoqwBnMI
         PtU5ZEYCFFyfBXcB58SsJsLK0s6droDMyENRRSFVg/n4uxumF9EQ9k9rr8CYzxjLqh8Z
         YfiY4/6ME8c/vX4+BbEIv0juGnq44diMXw+LW0znpb4OUmfuYJ6YpdpZVA7fWPC/UsCN
         jtQQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QR9X+PGpVK4lyJD79mElXQofMtjcErsCa+fRmfskuGKufTA1pIinrWRZRDFJh+y7pVJIECnFLUA==@kvack.org
X-Gm-Message-State: AOJu0YxkAUakTzkvtQje6UgPNGmNE86ReEmwGHPxmpCAdIpILhe1wHHr
	dY8GAKMLNPDhxnZ477R1cGqjx2AYxyCRGJNdQ64EI2KIARW3T817Au9kIswAjeaenSo=
X-Gm-Gg: AfdE7cnl4q/SOUttph2lGLQxtUa4pkF4QYqNsKXfQtw41vumFXdEdb2GHQQVuY7O8HM
	N2VS6EicFyihCcowcChoMoLVxZuRhd87qkhwfTdES0ehpuOwQaR/VocftazO9BP5NX/obcFA6kA
	mfTFkWxLssJqL86xhnfOKJRUPd/N4P6tKITJq0PeMBpF6g3OgQL+HlAMpHADzh6iWToxInQfZz4
	Ds3C/YylXW6iCmzfHjo3cvtm9bsergezonqzTvS8MQobCVQVNjhou2AR6W3S91jeUFAkhVO7Kjt
	vcFB4nYpjn3gZ00dBmVQZcuVZhPjvXMci2pCR5CmANk75XPNWyesgb+s7/BpCOUtyrNqoyozvPY
	2afo9KBgfYaMY+ou8DSRqthRi6F4Kdm9hHiAkyezHp3nam20XDPQXDRlfgl/1R91l3aBh2vJqU5
	Scz169VqzyO1H4R1Jag4QW6HJQ8qjGU90Ea7vCv8bKXG9qu+4lnQ==
X-Received: by 2002:a05:620a:4413:b0:92c:ba97:9b28 with SMTP id af79cd13be357-92cba97b01emr51609185a.58.1782521571509;
        Fri, 26 Jun 2026 17:52:51 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926000c0c0csm1304879985a.25.2026.06.26.17.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 17:52:51 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 1/3] mm/memfd_luo: validate serialized_data before
 conversion
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260623105201.3724592-2-tarunsahu@google.com>
References: <20260623105201.3724592-1-tarunsahu@google.com>
 <20260623105201.3724592-2-tarunsahu@google.com>
Date: Sat, 27 Jun 2026 00:52:45 +0000
Message-Id: <178252156515.136430.8828544568760798209.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=667;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=lA9Ld76U/OZePGMYSwBGOUPWdUw3wx0ta7LzTU2JjXg=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqPx7i6XBsRVosljnAEJPuGa4GIhpxEyJNpsUUu
 eODBiTs6H+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaj8e4gAKCRC7dyhM23N6
 3rHkEAClYVvZXcLcIYww1NmCuxoqyIcTwNmfZ7YRrSmcCbayxGiOmHeO2cDUEtek6MYaqMnQ4PQ
 VtPpfm9ZfIjx/wCaTN1vYCj7t2rDndKrJIZcP/poz6iMjONujZ0WYh8G1eSISQVKrn0TdJ90C9u
 u0B1As4Pi5iSfK2xlEnhTIMF9sioKdG68998nIXlscpwSGTDQeclcaxvRxbGs2XFT0cZ/oIy4eI
 r7rYOzykpsiqyXUFm9nQK7zfvjtA/0nOygHz54mOeGOWS2d40yIX0alocNsTX+3IUlMUri4KSRX
 YrZJamlftCGCx/EamG/7viE4FhBimMnvbBmPlxtvDkGt0rq0JviVVvFEFDP7qUpU5YGkHT/LGE9
 eK4FSbRJwImWRfC2IGguZ9qpSSWXK9HpVlXrWsvObgKlu13kMNfxNSMteuDNSvNPBsIJs23mQMt
 jGxvmnB3pAzm0e0St1G0g/c/tJEjXAe6XcuAUWDZZlOEI5sO0IfuKuAwGqQ9TE3l5wze/6GJw16
 KDgi7sZDsgp0cf8/Xc0b6DJKd+wXWNojjHxdcfI5hBkFB7FObDNvG4Ixmh2kPvQa2pIMI0AF6Oz
 U1QlPkkbr1T1OqgDQG/SwqT7v5a247kIJ9ohMOPY8l1z3osTH8HYJOaupsWihIwHt1Gvve3bf/e
 x21CziXQacgN+cg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 811F320002
X-Rspam-User: 
X-Stat-Signature: 68wcinzcd5nyq6cm17yktzef97y8ceqj
X-HE-Tag: 1782521572-658722
X-HE-Meta: U2FsdGVkX1/mzSb22phJzTl5zs+xxb3ILHGyJXKzPoPIR/NPw9EP03InDyXNQb9YN8AMYZFvrVMZV9O2Fo6DZIF4TrOeeKeZ5p15JPM5537CwkLLfaxcv1/3oIg0In4gCbmjt+HA+XsEJqBqrgj9FQ2ehWQMsU0Q73n/qiZ/LsaO/qwvNZLZxRI+fkL5H2+wWBNTgA/GyLZLtoff0Y6s15VNy3v6pz4c8K80tHNoQPJz+k5C8ESgtTMq7cExiarDEk5kkXVaRTdzkRBDhkvBE5ir0G7z/2ZqwjWuQ9HuKthCl/PJckHTL6py8a7P0u+qAvoo84NCU+H1usuoJ/M7jbBW5du87YOv1HdQiqn1/lCNjq+Z6IB7ytgHgIb+fPZqwC+BuKwrxD6gCLWYUjnTF8AS2GylSGx0v7/56x40a1V5y4szG4ll1bzEC8qKuoGcMsx8IIgNjbuJjm8ssho52XaQj0I8BWEHinVbUkEVD1BgCyjhdD9Ai9vuMSGoPiKPAjlNpSEdIR06Cgdzd4fYRhAiVEzK7V40d569P6YnL9uFrUIJ/at1PQzPerzZhmo/C1mcIO3UiMigdt7ZSX4aiaTUUlPZB3tmhLEdCjlG4T2VI0ZaskJn9dvdWbfuzkLwGg9fnKJu/Jh+IT6nda5N6VwRw3gC4+JfrH277PRXWGA3JIM8yxT/efHj4AEagFu0A9r+OwvPanZtfLDUSlsEYBz4s3c64SeNpayhEGR8MN1iD8npH5Q3jW3pmry398ipya6q+9PnxmUybrswJMZrm7rWuwIE5Sr89xDBTfOBQofdwxzujLOJ+L3eNczElYv/AnPNt21ACW56B9Ct6TTNs//4Ep2vRbJMmFnqvYsuO2oYqBOUXhJnwmnMD8mywXb6ZbWHhb7TdO8ctriqfVcUKdtuJVvKZytWN98k+Ik42wCDVRPg9PySqTAXtUpJFvbTae0wBnBTVtumGl3J4j6
 kv7msV04
 SYBbH403ILnVsE9O9iF2ZAIc8wARe1eBt47MrSlZiVzZ8rXOORyyvr3eU4Kxs4UxflM8IMp5i0/FMr8DHr5UMLA71WBQYHBigA+2r48sH6D7gWq+dgxjoa3PJWg0MD/apnE65i+kbn1Qv0u6TjAoaH1AwZ4Kdbq39E9UeS+rwOmDTltMmP0DVxfxdkFSbm6SgpGwVPPC3v+kO6tz1SAC9GWzPJOo33hnkGmaxHZe5YpC0RKZ2xKpgOJl5nz2oJA+Yqr8qEkaNqVBAh8bSMZ1B8jikVAh9d12W04jHCNn+cPFSk7iCPDnvyyixKOBKKFVyF5QyOTCgefeuaj1TER1lc+x5VdxT2rSaGmj0Nxt65u6ao3FvyCNzVdpRFMlrWXrkP4HvLFodJFPvx/mbbS+uXxmtBai94kfDsVZd+uXAaw4mXIm/YOoGHG+eEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 10:51:59 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> on args->serialized_data before checking if the physical address is valid.
> Since physical address 0 does not map to virtual NULL (due to direct
> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> catching a missing serialized_data, leading to unsafe dereferences later.
> 
> Validate that args->serialized_data is non-zero before calling
> phys_to_virt().
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

