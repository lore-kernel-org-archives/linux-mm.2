Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C21C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1285F6B00AB; Thu, 30 Jul 2026 05:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF786B00AC; Thu, 30 Jul 2026 05:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30A86B00AD; Thu, 30 Jul 2026 05:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBF716B00AB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:07:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5539E1A095C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:52 +0000 (UTC)
X-FDA: 85044865584.21.3AA2970
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 979CEC0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IBSzQR5v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHwhbqYZcyFMLFasS7DHToFvnOjYKNx0LAh55A/C47Q=;
	b=z5wA7mOoogl9XDSRBHBFbshIf8KJvU237tvPQBt9zF9s/10dQsHMAIyXLdfCo0Q2+NGZGp
	NdGqkfYDTrAkKBtK0f92jF1zblcBdkc3aClaC0ZMkWn3In0ccure6XaPBWzsibWGh0TKKN
	6C0qJ3j1Cm9onyPNaMN5DwVYJDmt9Fc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IBSzQR5v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402470;
	b=gVtV0nyCTTj9VruY7WH/vBwPw8sCKm4OyAVzbWykm/uVIsz4l9QHoFaIMtdwASgKEb9Kup
	4rWtCne0+ad65aOA1udbILB0qTpBEFAl69sWfAt9cwCfVkjF5IIn/Ln3tf7+WcJ7js2o/B
	qdoDH0XDr+GJkZg39Iv+M6I/WU2czHY=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b021916bd3so1811787e87.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402469; x=1786007269; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jHwhbqYZcyFMLFasS7DHToFvnOjYKNx0LAh55A/C47Q=;
        b=IBSzQR5vzb44L1r17etIWeWh9M+SGN/4ic/urc+pg4ddfpSO62Ly9ovkfdyUi8m7d2
         tK3C1coQs/bbICETSLZa3HH6lHSWe+D71Dgn/BCIbNqpwBI7F8N3LWQ349VRJ1mRlh2/
         hSJQgu4o9B8cHJpKb3CgggHP1ywsMVu3rhIV0JyLgXfXqu3UEBX2w0qeWS+HcvVwHanU
         OdD1nUD3toBJiDe9Sav0FhT1D2cafMlaYX9jtVNnH6Y2DzmH0WCgX4G2or/IWlP2oXPw
         gzRulP9wrgfizld9PDl/L4d+PO+dk9yt4hOBk3lbZhiMrAJ9Wh5wRS63KcvPGCRbdNXz
         k2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402469; x=1786007269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jHwhbqYZcyFMLFasS7DHToFvnOjYKNx0LAh55A/C47Q=;
        b=ITGSNCDGvwk/eyHZEB5YrhWnIJ6GiLIIj5YkZIpAt+CVpXeWH71G8vc8gjcUcdR3sX
         J3oNVzm7utueLRgcVWOcq1eUd1SMTVYCH/RLaZcIF3yP97J1+D1/KH9Ic9q5jbWFJGOA
         Dn94iWan4PoEDtGT4b4tEGiEh5tsD8KxhMgTzikQafiFkLY245zFq3Q5Dye85zGbA3po
         I5RNnCvu1Hi0aaQ2AwVO0+wbYQ9e7yuG1NRFaGCPQNrSlPHXPK2Jxzhe7bUJOIv0azA+
         TqltZOhC12Czzro0Oh4fqBdUH+xxYV9z91JYAB0U1DzlrpgBlQZKm5pIUJKvlPwa7k+c
         SCEQ==
X-Gm-Message-State: AOJu0YwpEUZqmxnJL6sduYvVE5mN8S8GcxolQddpXu1/f3u+frpjgB6+
	leaFo8jdhm8DKCAeFP2kG8RNMWKKm585/6TeMgX4lpLBmaFF1Kh+8bWq
X-Gm-Gg: AR+sD10AdDMlKUZSjTQ3KQHs3QAhbsStGV5YKiScUJsAXSLc5t0QCLtbrpsKPf+2ucT
	Mlk3a9tZT2oLHhrzg2Jqd5I/DeEivuWsl7X9tS/I69wmbfNzdirmq9T0QPHUAK4bkjThan6vezS
	EtOsz19MoucsI2UW22/qRI2mWYEvv6G1bLaqbsxtU8YSjPp/7oc/O6B/yftfjZPqurUhPfDAdVh
	5vXCQBahS08KJ6BwnJyKW8KqclmK3vrFq+f1X6xp0XRosQTbjZ28d3TqPBre/+gvxfSn/VX3avr
	ckOdcsn6T9lSon3X66LnEO5seiTCdv1DBKV+5vh2eZBXfLUFn0oW6BWNmqH2wfDZFT0eZ5MIgUN
	CvnRDVDIOK2lqWJr4HXFT1xxAF28asMP1IL+SE8Rq1BAGThG5XnnfIFUO0Xcfrq64y3js/qfIvF
	V+VDu7B1aE3lwIoz3MZ7C9DBiK4+2roLxnMLtKLMqXcfAXwIYUAUjpfGjfWCGHBC9gw7+231rP/
	VVdZ6G2zLAFWj0wRieI5EZINdHo2M/omJ48DdDz8UnsNuHUteieTIZytrepspsEeERH
X-Received: by 2002:a05:6512:108d:b0:5aa:8822:c946 with SMTP id 2adb3069b0e04-5b2db37ec16mr338558e87.48.1785402468876;
        Thu, 30 Jul 2026 02:07:48 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2db942de5sm216643e87.10.2026.07.30.02.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:07:48 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	urezki@gmail.com,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Thu, 30 Jul 2026 12:07:27 +0300
Message-ID: <20260730090727.65911-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ampGVI1MLmnLksnN@casper.infradead.org>
References: <20260729175708.7074-1-iprintercanon@gmail.com> <ampGVI1MLmnLksnN@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 979CEC0003
X-Rspam-User: 
X-Stat-Signature: 74rjuriscyxn9fx34c5tgxyigxp77oux
X-HE-Tag: 1785402470-913311
X-HE-Meta: U2FsdGVkX1+LzORFo43AWX7o3/YahLVA13yWJlGF/ECnylmRuZ72J/6WWHLb1slxFRKk6J5u2XRzg5dGNeiiL82Ko2DqYFoXt8Ydsv0y6Q+P+TxAfPGrrEWYA9EHj8izDJbeHN/NPx8iBFL0y8uXJ36XLxiM80N4fqkHSieHvRucA70V4QhnNbnFIDnxsM/wXPgru4/R5H9vk3etve4kxb9MiQLRoIZFnCV3nwTbUv2AvLoiFgx8nnqTF/r0/DNkXc+gCzP5fkgN7iRNnxZynd4IMvuLZKaclqBTtlF/VwF2EelEYa3eFLiocl4qReMJLtcPHKKcMvrD2AwKhjoIK4dZalTAg+rHkq97F9fml+iEAmsVHsx+3rTF4lOZfvaxZfnDNoz4RvWMtYwPuUhPF7J1CeUMClsRl2X3z4+TvxKBkDsBbAr13lJctXvKweI2Q6cl42KRmKUUZeFd+zLfksoUMYvXx63h35uFmB2XqEI3Nw9PphaKFRNVeR0O/bbmRhUUKK+208tgp5RH54vFfdtrmzCjmUXScTEewcF3uxRxGXzk7/Mq98eQeAaPwxJUjCpoWEyJlroNxBOCnA7jXGlW6dgnyN2lUSDuT0gJYoZ4Ebitf7ZewohIMgRzsVBlO5gmFBm6UDoVa4Rr2vPFzyy/lE5Hq6Bst9QYr5xQ3gREUOwpKsGoiHL02DpI8Xj3pBPiyJPfn9hczf1WGORESUCvjgnpG/EHl4OHP+t3kj9CWnuD5tInbIxZDdCFiRNYo6sUqKvO4RG7jpy3MzYTEEnEVjJ/uw9KnCznCGRVY1IywLwbsv6SUmXQlLE1FuHRCO5ngQXnDisVkI9N2kzBRVU7FUbslubF6PXR9TTQWgOmu0QsxmFME+292SDnXoe6FB2VzE/0AxVUrfZd4uto0guaiNi7ZphJ11jFu6WJPOGjSrvxN/qVwBn+caqvAy3en3cTZ7pyoW2qTwAHnzb
 4z+ynxgr
 ebISc6/Zdq6nXFRq9kIXrl17/rHCHn8fj2vahcF9a4D1lLn3vKDlnsF++Af4OkzoLCTlgGLRhTiJTYshPypTT5yWVumznQjubPegzS8uMNviI9FDAXS7VHR/6+oVLzUClqjAjE8cxNyzWZzynEq6D6VsrQOGM01Pd0vlrx8gKpB7v2LrHVSaBMe0wkfwKN0qM+//G+Q2zbOUUhXbqCIBi2ZeyxZ8/q4xO74fIDw1QxyFmg/vBa8tJZn64jthfGiLChxBxuC/xoz8Z+imTTAPwwFqfpra/uKk2xTNhflkV5pQqWvpl7o8+zlwXAJmJueOW96Nagfc3kEX9DuQ6kTe29RBK0fXzsIYEkU2kcT0JOghnKC6CiTKtdNT4lL3ITajubIuXGHjL6UxAROX+dXiCDgMBb29n883f+cTHecjpw0uXK4h7pir+YwALGo15I1ft0uBkkSrGR9jzt2qzroQEtKTFjd0tPeNhx7hWRUh8PEIARKI6LxlC0BXe+2nmd32Aqc6m8Z/x0diIUsEPn+M95QL5cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 07:28:36PM +0100, Matthew Wilcox wrote:
> I'm not saying we shouldn't fix this, but it's all theoretical for now,
> right?

The 2^32 page part is, yes, and my opening sentence pointed at the wrong
thing.

What went wrong twice wasn't a page count, it was a byte count. nr_pages
is unsigned int, so nr_pages << PAGE_SHIFT is 32-bit arithmetic and wraps
at 4GiB of bytes, which is 2^20 pages. In vread_iter() that made
/proc/kcore hand back zeros for a 4GiB area as a successful read, and any
machine with more than 4GiB of memory can allocate one. So the reachable
part is 4GiB and the 16TiB framing was me leading with the wrong number.

To answer the other half of it, and Andrew's question too: no report
behind any of this, I found it reading the code. v2 says so in as many
words.

Artem

