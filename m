Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9F8606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 03:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=olvwK4ji
Received: by kanga.kvack.org (Postfix)
	id CD3126B08DB; Tue, 24 Nov 2026 22:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85106B08DD; Tue, 24 Nov 2026 22:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B731E6B08DE; Tue, 24 Nov 2026 22:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2686B08DB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:13:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F05AC120D01
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:13:40 +0000 (UTC)
X-FDA: 85472171400.02.BB3D652
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F789180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:13:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=olvwK4ji;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795576419;
	b=yyohAMHTFR+aJ1PTnaQy38GUuGK9dYB40Je/mtzm6PeL8dXE4uG5Mx06Ows5lrysY5159h
	9CkK8CzNMpK+OD2FAtErpiMSKJxbzDV4cxsFjZNrawCZKWghA2/nwJcKkBP7y1FTgXwGim
	AxPyTfvqY9YORu92ZA6YPIqEiD7Kzm8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795576419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCFbqC4C5B+TcudKUswIJlj5VybrEnHtIhkQZVCLE4o=;
	b=kZafVJPPIt9ZxnZbxhN4rAVvC88FddDXRg2susEUq6VkqvTr+riWbr5X+GnhWbPMJRgdqp
	0n2qFyg3zHE17IHnw7ge0XZ3lNsiUuE1+W3zKXfLf7CI4zJmCXYihFqP9TCPy0jrelzULA
	YQ6YEa8Vhtm5hGnuUTma30QEd2xnxSA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=olvwK4ji;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3b497279c25so1316905a91.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:13:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795576418; cv=none;
        d=google.com; s=arc-20260327;
        b=PebZnMk4iKsnNbJ1WDhdCDsNLxFr+2bVwMx2G3z9fP9YO9+tR3ACr21YNyahe8Ze4F
         zEavRWm4iwg15PpZM9MyzZtbhCkWupYc76WV+AKN42VwU6Qkn3O9KTXefPMxYSnH9NlM
         hBYhuHTKOykUHV3j9mVYRD+NyZDAyAFSSZ48cjBpMb59m5BauAD1u6wuDueXVc9m/nCY
         hm4GfBevCS4dlQ30ErcGc3kFkWo8qYgr5SawdqgAQ5qZ5kx8q++J3Zwj1tpSH7QatnJQ
         5/s8kMxbB1TMniGz6YAZ3mvhdoraTy0jRveesERUJelv2LK9iSlUOwf2oy8sJp64YCvp
         Wz5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tCFbqC4C5B+TcudKUswIJlj5VybrEnHtIhkQZVCLE4o=;
        fh=rkontbQWKzvgoKWGcCO7eIf/OfeFMSz/88W1rnITSvU=;
        b=UF+Ec/0B/jTrfM+lbOojMG+x6s6MReQYj5jEPzonjSiIXKidgdmV2KcF71ToJKJocV
         zmDlGoeiMvXakLeW+4X/SKz7DBFhnSvmuHmcxlgruW5KZiEwNxdMGwr3tIG9UiqaTtTA
         F/gB61YxO9IDlqXPFjg37Xy4P/WVIMd5rB9My65zhchD766dPDPVuqpBMhf+VWyjt34x
         IIOlGkxMHiS6BQzp3xHxleE2Y7QjUQLrgbsi5Yv/gLEodxhD5ZCCZk0WuUPEtoxxkLD3
         wKvZyGQkMpkzPtWEgNCrhTO0GitLnGIJjYhMnKkzh7uVtJqfKfAGT5vaA+ocYus2ihyy
         l//w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795576418; x=1796181218; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tCFbqC4C5B+TcudKUswIJlj5VybrEnHtIhkQZVCLE4o=;
        b=olvwK4jiITPJ3/VTPK2T057GjFVu3X2z9OsZ0dm5oDwoCWNoKLDJhS1sVnJqohwa9m
         ++JlYReOIR3Fim4VZVWQpNSTTVDzdb/a2d0deEvasXFk7/Ufuw7IVUkqyZkrGdHn1hd8
         bYNalDHP5FJpXFxBca22ELnr+G4LLVY9bCkqcf/htsjGGVRF2gdcW7FAfG0VghTNBZY/
         OL9pEeis+59khZIKQ/m3xMjrcOmTOpv8s1OOKWOpoXGFyJUrv8jfS29yZX/XHO20vZ0f
         l/+eGxViz7o7BpO++HU9yYYoq5cLFNeViD1w8fKNBufarc7Cx43DwNzhiDg+JRff8r3F
         abDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795576418; x=1796181218;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tCFbqC4C5B+TcudKUswIJlj5VybrEnHtIhkQZVCLE4o=;
        b=IJeUCW85x4cbqPsCWN9Yeawv7NRilopR68vw9LpgoueZ0s/9mdJ328E7KpAifZBsjh
         dINauLvlKNfp4TYTIITrOjo84xapvKEKAud+8B+eguS0jHHtjU/CRBX6cZBZHJVI5mgX
         CMi81kU0+FmzBtpGe1AQn9StDR/10/Rj/b+92ANTZjkANjHQDc8ku5FVNJgQBr3K8sLO
         GHy6LT+9Pu+CsQiK8tGnitjH0imPFsmUTdQamTo2C8cZtiqXNrdCYChlzFntqVvnJIOu
         emwKm1i1IvT/FD77FHsr76SFm7n2IoD6AisETZaBd+euqER9LEr/XMkp1FIuYoE8PD3V
         l2Uw==
X-Forwarded-Encrypted: i=1; AL+hErHsHo+kpwPudl3hnLuV0XNS1H6pkOD5mgR4MOCTIGrn5CucnHWWH5SBxl3+Cw+0/AMXBgSBijD20g==@kvack.org
X-Gm-Message-State: APuU4Z+Bu2EeyHsYP5/Rp43C81i7mqO6vP6S5PqdUNWNhyqzCU3g4kl4
	TszA/F6nw9VEQ49ZaFDiZFTzWQBtdpNcpBY1+iWaJ2rDgqVFbherq/GqlbR3BDJzcw1ZjV/2yGK
	fULSa4uHvfM1uEBKCNrdz8xLIfDruZa8=
X-Gm-Gg: AZFdTZc8RvIgv+gS1WzkPU2BI2ymYqxi9qktVWndyW4SHn7QYODdcTomns6OEkBwrHg
	vK/UHeE0dSIISCtpoKhkroIGLlKB4olaWHc3oDXdpNWHDMFrkzVK9z6HUZevK5g/jGuc7zTbfTp
	m/UuFhiXNRGU4IU2oUJUpH8HGjA60lUsPgW3JvDJqNFYjaxF7hucgYQ9bdojsz27vpS8adUqVky
	8dpTQkMMyeBMGXrmPyxEBxlk/u8PKCG6fkEOwcAVtao0B3yB0rXdn/pOCQtXzaXzJVAwdKexUu8
	+O5t69a9JDBNH2rflmxO7fb+bQAZRQIXKBSUDwPLh7CgKoQ8reBBe+jGdEYOnLTeRcKeTpXMeUl
	TCbMsIMjAMr66+PWdRTJh4UEVzXVNO2Nfpaifdg==
X-Received: by 2002:a17:90b:17cd:b0:3ab:4f1:4f76 with SMTP id
 98e67ed59e1d1-3b41c900b24mr15919769a91.24.1795576417688; Tue, 24 Nov 2026
 19:13:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
 <lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m> <CAKEwX=Py7W0vOwxKdWMCZu3d=BbF2OkgDt6Tu_AHhEJZ06w0ew@mail.gmail.com>
In-Reply-To: <CAKEwX=Py7W0vOwxKdWMCZu3d=BbF2OkgDt6Tu_AHhEJZ06w0ew@mail.gmail.com>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Wed, 25 Nov 2026 11:13:24 +0800
X-Gm-Features: Aa3M54pnXMEK0Eck5BBUuqtUrkvY1nVqb3SO0OotTOKtwJph7tvN7_xbLx5Lf10
Message-ID: <CAEnQdOrzP9wKwmyuySRch=a4B5F3Akgsvk9TNUj1Vycq-4JZEg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix cachestat NULL pgdat dereference on DAX mappings
To: Nhat Pham <nphamcs@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ipj8wzsh7rnuoypbywbm3c9d84adwirk
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F789180005
X-HE-Tag: 1795576418-738118
X-HE-Meta: U2FsdGVkX1/H+mVt1woclmc9oiNf4yRndWvNQeRHzXGeQsb6bfepnaSn+rhCYRwz1RZLAFvacNTnbWqQSqGiuYvKm3pM6dH3z8aciqo6D0aes+vlxwVtc1FuLZPxY/c3d0k/Ki0vumR6ogHJjB5e4zNcHl9oVjKX/zUEaKAsoTXt7kvjqm/8jXt6M8lOmXvMnlAAs4TBCVMpKMn3Hdz4U3FkpkcV4B7ZJQ5kkr8FTSbU/P3zNS5yENLuP4ehaLU9dxKz3fvXv/pMai1b7X+tASOM1v7alz7FYS4TRboYS18ojb3jDglWZ5m4ByUDsSHeIow2rTYzEwD8qYbJxSEpHDUkuF9u68QwCgvxnPO1B3ZyO5xaREUFPGhUNFvrSe7vC2UbezrrNE6SkA5b4BteQ6XdKt3qnhzD62hneA90/+P0c8ZbTtbJBtXgklr2EeR8bjxh7cUukZFymPODuF9x2vtTDgR4LwZatQoPJJKcBdkaC9cuGY503aozWJHBr00WBAy03TLZ+nln7XWR/0FL9nby2xb7lgZeSen7nTSnFJ1X7sK9rSY/tE1yAS72NkHD+bO1K2JkxN/FIF6syDPLiMfc8/WxsoQmywlUj92R++N0ldRQGVw23j/eBVA5AsfTDsMSV3/mo0SywEEGZhGVUfzgaYMa60EqdksfC7ddJH3QPyD02Em98+fifb1ntkZ0b0VAtaukjOQCByQwiW2JMoSUsP32HXjEkoFyPAeiRdvCdEhUF99ZDPGICPIkLK29rrIGHLj+SBM4cXf6gO5BKjIOQX6Ei4ZZHXKf5NBEbRIu0hNKAlVitVpoLLasJ+eHjKRv5dtaElWK5GuFiIpAnfPOXVDJKfvOfHJQJSSxyYoUMhJ4lMY6PABKhr+WcstgfAFpj0qWpXCPo1JM8t4POREDu+Jw/XYrSEWr0+MM05g9/U+8s/s/1QFYZp8BbMUuNy/u2+VP6k0uNkNX0+d
 RLQD3PmD
 v2dZAWpRj+Wco/255Kl6JjNMcvcfKjSqAj1IdugAbAvpxcnS1dW4f0BXUxRnCSV9VbUTETQzLtuyUgglZXN7x/FLxgytOCINFuFjXm0JkhiboBj5UTt3r/nKN/I2HQ5q1xeFJNMsawK3/FCu3y/P0VbjDvXplm+GiPVn3RrUa/tKyYmmJ8UyFWs+suZZRn9JtdtAjzIp42gQgmMvg/KGLhuzSSb75oZkjMi48A1TFZku+Ez1Kp97mATgsVFsIrbItzSYFGIbIU9c8EVeKnV2t31qYYp1MfX+2CphpdnNKgPJ+87vcnYF36719Mr9f6hHNiuloelomCO865jsNIUv0NKv16oIcDw1OQp4ipzCUgRzBSGB4hM6/XqtV2Q0GFSi4sSPugEjIXVx8muwTPA1wheTJZpEDpB7te00C4qMk7UjbOI69xj7EU+ISqQ0I4gtinCYnNAfvW7BJ2kByNJ4LrqmgKgpwPAdmeubTS/oSaOxbLxQUofi3WMlPBok8yuxcwVnUhbbyPb9oMdIdZ+2koxXMsr42zbGmbQIkuUSXpgq1gHsk2BxsWRItIVnhFhBX1aD8JNlUgi4VQsMeDt31Jw35WXuaJDgs/E6eUKP/B8q5gNrMIUph5dY8b0AOVjJ9ACHbongQv3UlH50VJp/fVdGqa8TE2T2bAAFf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +1. This sounds good to me.
>
> Henry, would you mind sending v2 along this line?
>
> (and maybe add some documentation).

 Sure, v2 sent: cachestat() now skips the xarray walk for DAX mappings
 and reports all zeros, and the behaviour is documented in the syscall's
 kernel-doc.

 Link: https://lore.kernel.org/linux-mm/20261125030432.274396-1-bsdhenrymartin@gmail.com/

 Thanks,
 Henry

