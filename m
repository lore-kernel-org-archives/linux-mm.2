Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8573FC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884F96B08FA; Mon, 17 Aug 2026 00:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8363F6B08FB; Mon, 17 Aug 2026 00:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725116B08FC; Mon, 17 Aug 2026 00:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC646B08FA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:04:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1C5E1C18A0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:04:22 +0000 (UTC)
X-FDA: 85109419164.05.A8700B9
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id E03831C0004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:04:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nOuOiz/P";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786939460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpaBdhV9+PNf80Kaf2EiNyWs6xJHlX/MHZ3CCmpwo/c=;
	b=BB8bL+iY2fynsJENVYSwhLwlgkPcv7gMcFpqWnierhKXGJ0U1uibImkrHoroapQNXC6O2J
	/jJiRkg4ZIXodeqmoGGx6F/aVonsQfMQrypEfMq2aC40BSm2wy5izR79x7tjbNCqcLpk4H
	sFhEehp3PisHW9YV1/Ue7uHKVUFilws=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nOuOiz/P";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786939460;
	b=7aHuKq+j+FpvwiNBZrMIpfl5pct8B5+uT2G/8chcddP3R0jn8om/3dxg2uhJL6s9n3E3z7
	sOEy8ZyHYaoRI33I2mVVvobuCEsx1gWoJ/hx0pDa8llIEEFkN6ueZrZxa1V39pH40GJRFR
	86wLhC3kOmVdsU4vN4OARJudDMfCWy8=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-930c0f9c1b1so154522385a.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:04:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786939460; cv=none;
        d=google.com; s=arc-20260327;
        b=rGQjUsjh+pjVSQYSncIevUNhKQpyFqyEGyvum9E/UA8T9uJsAM/isff8a2PvRRlG/1
         7seyN+EiaH6X7HmYt7kdy5ZwFSJS0CaDtXuTOdSh9qMXNbuonLIxwj6wztja9KJwxM9t
         kQXB48CJMh1RUIQdLpzl0ZfLmMZSajAr+ey94QxZ55EyNv8ukXIUYJeYXK9Po+lKNJHl
         Z6ZT+ikTqA6PtQtbCrtPOf7qhuk/aADndvpktPTTRlhK1m+6ZQK2m5jk61NNdEWFnFYD
         pdVx7vtg/o1PyQPfQK3XMFPShSL9foCo2MYd9PJikN8umOuiEMWD97vqVEtv8DE55OcL
         sghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JpaBdhV9+PNf80Kaf2EiNyWs6xJHlX/MHZ3CCmpwo/c=;
        fh=cqBZ/fOqZm/F5CjARHpjHnqu4YBqtbnEfiAm64zoPhU=;
        b=e8jLzPLr8dw+2HHor9EFCZKmry+zO6ye+9aLwc42cFGo65f01FGJYAx6KvjbWwAH7/
         Hc5R0qa+DBQrI1Zoaqkg7QK0iCJANf6UcoJvZ2gdSy7Dr8/jPkMBDha+lhwTsJsU+CIn
         RHhoa2YBUqB5B7HtVW21wWRaBCDFnR+vS4vucYKwXoagkq5VsdT2E9JnsSLNM/ikvESo
         u52b4NOtQM7PvR2rdiHIfqaY3WQEC05I92jRCMtSDLIsf/ShEE9UWBstlD6Oy48I9eZ3
         5LyvtrWSe3TiMGUmLFKsgKJZq2IwpGHZK0oU39IdsUrpYv9NemymvqWQ6AivYMEdkZ9+
         cE9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786939460; x=1787544260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JpaBdhV9+PNf80Kaf2EiNyWs6xJHlX/MHZ3CCmpwo/c=;
        b=nOuOiz/PrcaoStTb24l4KZdzZqgj1YXVj90HFdpJ6yk9jK96nfD9Ew2Yu0Xq04NHIc
         8dhJKgiUi/v7KzihDD5heoMh9l4XJzKttamJxfRxPy8cYMpzbQSbAS3590cFXvwkTi04
         wjDE7dfIYm4evLeVNkiqof6UZeiJ0ICg/9xrDdfTTF4KeuILfpUj+xxeMkSwukoHoCAZ
         Wv3obW+R3tDG8RhykxlgTvLanM80eHEih3dbw4CzrwyMe/RgEMduX/0SUD6JtYmNsM8n
         FImYXCi7p3zQkzB0QsUYhiqh2gpFTiw7CfqGt8FcUzmLUY63IR96/oOkSSXLWBoJFDrR
         CYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786939460; x=1787544260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JpaBdhV9+PNf80Kaf2EiNyWs6xJHlX/MHZ3CCmpwo/c=;
        b=G0dcTCLtlbEuh2Qe2hrvmi6fzZ96Z9dHJLs91qk4oh1d5dnypoX42jI/lCHAlI+Yra
         CB51nE5Bed4hqumCOn7VQfJFo8x19w/XPXi8hx07FToee1T1SWvx+S8F16pyc5ejFVys
         Aj7d4oMr2QanIcuK1OHfpR3fjiL961uRRbm6p+chh189MUSj9so5nNjpf5L0oRGmrCAN
         RioT/OdtCyBgHYE9+so1kU/E+bxdEvLqHrduqGQrf87HZjA1t0q6FGcIW8dEXyIIK7ry
         zz8tLpwT9KBNLgpPEE+oBFwKktbR04HQs5jkQNtjSVfm/k2qO2+Mu+lneABQ5pQV8XXp
         0rXg==
X-Forwarded-Encrypted: i=1; AHgh+Ro48BKZ5UuESi+btk0hszORSoTOtnc+8embgn6nlEm0/HCi5NzUy9quf+hMQduqy5dA+nrKcr6fQg==@kvack.org
X-Gm-Message-State: AOJu0YysIBkYlUU9/8OmIydMaccnw33AOKRuOst9g2HxFi5I3iT7uQOh
	kdC8Mf+5prt2L7FGZI7+90NPim9q+Ei5S7OfzTMA3Z7ZWvVzurHsE5q0+InTfCXEMpqQ+dDME4E
	J0rYHn5odeC7kpfiWV6zFU91bikkwzWs=
X-Gm-Gg: AR+sD13wsnC4bNn1TadKvSZQw9CDXOWLYN84pMkG4df2nl6spWU70MuP5gc+4nKWsG3
	7cn0va5SY1aa3miI4PjRKRXJUvSf81zAAzZuum3ao3CnGOCnKVEMdrI7l3oRRV3mRBxI177AcRz
	ljIRy34MF8tdJjJ9nJLqX8hC8DksjnE9Bcd0NCGBP78XnXNFk4YOO5B57Pd8LzBCiTGJayTvMiM
	4O5wAg8XHpjJb45GFvhfuD7fa52dpTJfGUaUqYzvH2qn6YfhpKvi4+g7vwkupN5nchHQYrzrOsc
	u+91qqRiCyAR9ZshebrOAdHlUdDh8lXHQLt2w/J4I4NIAmws/j0Dcq5j9PgiDYI4pEusOkzBC9z
	ovqgGQjEJmDsPwX3ZmrSoKkC1krhliLLsoAEmNjA402Y+MyuopSyIrDc=
X-Received: by 2002:a05:620a:2419:20b0:92e:745c:6c5a with SMTP id
 af79cd13be357-936d2291b6amr1805780085a.14.1786939459766; Sun, 16 Aug 2026
 21:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <OS7PR01MB13914A5991BF648E81288038E96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
In-Reply-To: <OS7PR01MB13914A5991BF648E81288038E96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Aug 2026 12:04:07 +0800
X-Gm-Features: AcwNN1XU7P1vy72XHVxP-WdBL3Lg8KALYV2gArIvczc24iV2rsjM7em30v_1o2I
Message-ID: <CAGsJ_4wZkwOVJnsatMXWLnLA56rT5tOgrp9HczaFDHNA6N971g@mail.gmail.com>
Subject: Re: [PATCH v3] mm/rmap: synchronize lock and unlock target in anon_vma_clone
To: Eric Kim <seohyun.kim@outlook.kr>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E03831C0004
X-Stat-Signature: 7ubc7b9azy1wuet8ucj68y8abp5i5w9c
X-Rspam-User: 
X-HE-Tag: 1786939460-471272
X-HE-Meta: U2FsdGVkX1/TmzZwE2pcxmew5D0ZZoQYYRnuZ3oAYBR1hhDzxOc5Ozsq3FCk4OmbAsadu95+LyKKzBbuUbghKaO08vX87oGFeC0aAX2RL+XpTnO3Vh2UY/YY1J+mJ1jC4Px7s6zTweYYfSZkj/Ke77YEvcOCVnRBdTIxGh9BoLA8yw17eZNW74ol9aT4Hw7rZKn5bJLhG3evx5JbGqaiPjRL6Y6cxuyggL8/xzGC18qCzVM156MOSVwjYDRbdHTyb3yLCZwers4SV3Q8BmZ1jTGWpEzuCo2YWuyX1tLM+tgHqXF1VhXsLqQVnxwvgAGgoaA5N2v1TG54GJtSRP6oOXqsr4WzJbNff0iEXbxc/3aubR/wXUmxm0Qm5YNu3mL4iNm4mBwFOwcibg4iF1gQDyANhbPQJ1yUhr2q/MmrWsPEZBdnvkA8x1wZPZgM28hncbXbeGhzeApDiWC52CWk72wANIdG6i3FpsvcdtpBUB78lkT2im9YFU6NGBivJlDPhfU+yPfj2u+WMVWvi+2Hs8NXC8cGEzRuUItuxtyMJjTr4bGxg8bpRtcw5bp5Fcxk2xX06H+euAH+w+oxbriwIY4o+ZM/DB24SVXWRgPbO3qLoSh4p6odkgKe8IqLJRxSgZ5NFbSmeLVEYyXiY0jZed28/fpqfeaYaRZraVD4KNG+o3HrA1yIaXFMkhFcrsJq1srGpSVz72ytXwkFIcaL4it2wDOReiHuftbO58IDoe6k9W48/x5aRsPf2iK0zWp0FUp8zQkh+NJ/M6dtc96pn+4eOd25W7rGTPEDK47oBIodl5j9HZRmc2oWPEMq3W99fvaXmZ5Dhegpx5qvlajtQQ47XAGfvLhi32dFROR96WPkIKsMSOjnOAupdnBtf84zkjLzBQWaTaisWPYCiFznykvBvbLb+yX3R78feZ6ETSEL/1svk5eNqc8OS8+7U1rgC2DgOobsvA10xTSQ5gN
 /JmcMO1A
 7D5HNyV4Pdo4J6lO00k2d+ps+KqC5skYU8tEq+B4PxNHCLr/aowxXTa9CGdpZB9JTEhpAXWECmEknpppkYXbIcNcSN23ga9KN062nBBXxgW5+TVf71yDaIBtfTAK98h7nDsNNIQp0VQbH9m7ZOrvlZpqlRppweRjEZtzwALHhKEn0lg84Rx9xw/U4dERuRFOtFTSoOYRLRLRrasiV6HJjyj/pL6tx2XpyBXwNlokqi1aUl1jvnwS+VOZSKcHlH9f0d93kF5zu+1muEk25FZSpT6XMN5JNt5eYc8CFB3CC746LAY9zGAegSA3ryk/dlfX712e3rU8FuN9hYjDtiMg0MGBMlOxo9k++Ey6vBCgdT6PlqsxP9oDP39bjGfHWftKbde9sRMRphhi+ulR3GcS5mfMVybEAddDMgSsw1bmRo6c8TR54dWUUPS744abkoQ6D3+oSv0vw+w7TZZ7o4ngqOH0ubEHWEHcyJJA+RSx0rP+b0mhjoUGwlFYUHgXc+MA/evYmFfuRxm42wkEbdyNcJtqNcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:58=E2=80=AFAM Eric Kim <seohyun.kim@outlook.kr> =
wrote:
>
> Currently, in anon_vma_clone(), active_anon_vma is assigned from
> src->anon_vma and is used when unlocking anon_vma after linking
> new AVCs. However, the corresponding lock operation uses
> src->anon_vma directly.
>
> Use active_anon_vma consistently to make the lock/unlock pair explicit.

Thanks! Could we add something along these lines?

Although they are actually the same thing, use active_anon_vma
consistently to make the lock/unlock pair explicit.

>
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> ---

With that,

Reviewed-by: Barry Song <baohua@kernel.org>

