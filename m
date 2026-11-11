Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA44E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=f5sIju8U
Received: by kanga.kvack.org (Postfix)
	id BAE1E6B05C5; Tue, 10 Nov 2026 23:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B856A6B05C6; Tue, 10 Nov 2026 23:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A751B6B05C7; Tue, 10 Nov 2026 23:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6826B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:38:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BD59A77B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:28 +0000 (UTC)
X-FDA: 85421581896.19.39B4583
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CACC140006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=f5sIju8U;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371906;
	b=FYhqv+pwT63z827qynrwZuZBG+9QHy+HWfSpFMrjDaEQIc50fFuMk80100kXIE3YgNSj7o
	M1Q/P3uz7Ua/6CXjqGult+w0IZ0+Hl7Zcyo6d/s/YJenbjLS0jk9c9Jrxu30SQ6z4/+Fcm
	/jxaoQvS+WMpfF4P66tn4y73i6n99jo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=f5sIju8U;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8B2GW6e71lZiX0sY3qwe01sHxxOkJy6TrHPHzX7My3w=;
	b=bTSWchKOnwCIOSpT4rJFQSR4PuuBDYZ/EwHG6Nf+qnijaRY9Amg0Yt7Br+IJMfzLu+fZxX
	ghH8J6doJmx/lOOmP59A8qZ3/W0XPO/jwNO/rEC5jjMlhs3rkGDHkGHEx7f2U5Cp0D7qLl
	bUyrahi62d6P3B1hOENt2FFC3IpODvY=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e9995ce866so19675595ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794371905; x=1794976705; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8B2GW6e71lZiX0sY3qwe01sHxxOkJy6TrHPHzX7My3w=;
        b=f5sIju8UR3ZqGo9hyuaP5SyATmBny3xsBOPcjbd1axJ2hkOYElrDC6zw9TLOsCFA0p
         qj0AwQ73kjtUL/E5CcilEuXorYSnuaQ3nraLGPjs97CrB+/9qaxDoFkOWeFk0FXRbrZo
         harI07fboVchj7uZLZCDJTgLYsvuXkyeduZgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371905; x=1794976705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8B2GW6e71lZiX0sY3qwe01sHxxOkJy6TrHPHzX7My3w=;
        b=gCpaeLTnLcwQk5GJUEdwCzpM0PZs8OE56WJcIKuse2i/2Bff3eqimF5LsgLWcgzbx6
         UrdIt1rRCv2g7N8NCUm9HxL4cEgUSoA/scRX9T4L8G8SqQjvjl/8gBgbQbvGnGplh8yu
         CzBJvu4sje1vS1gU3UsVNZ9FKA+mOXAXlyaT6A82fOAThp7qah1Yr+C/MAR/37nbeMCd
         7OMc5LeOwaZSCcGk/0gCKedzmJYx1qyafG6mNDwQuuTlPaCLO9Gu7naETu3EY8xi+GkA
         yHBkqpYNNoiJMq6Iie+/PsV+v26kOAw1bgjERnjMLMXyY76bhpuQ5tlBkJ3glNfJtJ04
         cOFA==
X-Forwarded-Encrypted: i=1; AL+hErH0BVFYW3cJ7moKvqBBJh8DZfK22hUZcc+Meu2e/S+/Ts+q/jbK6x6FxvETE4SF4GeIEU0wGQkXBA==@kvack.org
X-Gm-Message-State: APuU4Z8wcx1oUUhgYQC99Oyk8/t7Y7JQsJ3l5PAPFeooO4bDAjDiLTQ9
	5XjialySVqOS7qqY9MFLpifLILLiShxOV+Hn+hzhpLnyvBkeR9h/l9YGmZSL9Rx313pqzBZBpg+
	Bsh4=
X-Gm-Gg: AYBFou0uFW7m0gDB3Mv2ETLbuVWv5BiP2KH00lnTmprOYPWkKRSl0Ai+pEZIQD3EzqY
	SBlon09UQGIw7ZkC8sJkIjhx+C3W3orrmd6hfkiXSqiMGOxtw34yGTyQ5AqpVTQDM2YjDEe3eNT
	Ay8jFST3VdP8CB9i/nHu9AKBm1LeHtnI21KF16fZqSXDuTQ/bLpylZv7BlwrE2D3Pg+RuQDr2W8
	cgVBkzO3LuZztXH3CGPFuYHYNBTO8/JxDWWfoAIWayu9jx+898U+f6SSo5mgXjaBnef1AK6nh2a
	CWUFx4pLsDLthBAHDCaH74RAl8qFPONQWYrCmqV7uJX5ziyI93dpEQeXojtWlOKghmhcEYVXF/C
	SUxYLg4h8PHLT2XcoykDwN0uwLhQUPjbP03XSw7PTkNNq9TiAytbOPeTdyS58VSXMnTZ7pQZuhA
	egGtwhkJehyghljDaZvBLepyBbQR9SfOKyr0dNeOcFZu+1okVcKBl6jsPz8b8YXRmCpn9W5FstT
	GE4mtR8a8VlNb0mTrTNLIuN/4EhzeA2Qpe/rnBmorSY7kJR4w6B1Xd+7G+hvsL5p4bCYgCvo68V
	tvFXXaUSUagzPIaJToZUVgeJs218bDpVaiAO9u5t6Hk5qI8lfUyaVtX74t+Dga6EJVzaYw==
X-Received: by 2002:a17:903:2284:b0:2e9:77c0:c7ab with SMTP id d9443c01a7336-2edd77742d5mr16954965ad.29.1794371905055;
        Tue, 10 Nov 2026 20:38:25 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4a329sm15962365ad.23.2026.11.10.20.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:38:24 -0800 (PST)
Date: Wed, 11 Nov 2026 13:38:20 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avPxIH-JtqVvTzBF@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
 <CAKEwX=PNpMr5x4gTo_OK5D5EgKPDvZx2e2=95-4_SV8zq37VnQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PNpMr5x4gTo_OK5D5EgKPDvZx2e2=95-4_SV8zq37VnQ@mail.gmail.com>
X-Stat-Signature: nugfrwpfhogw5cf3umrwtd7mfnbhs885
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CACC140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794371906-152055
X-HE-Meta: U2FsdGVkX18eYX7aLi6VuPtqs0lKgBageprtAJJ087mwpc/N6ts3/ii9gGF1ESPcV1PjjbZ6/NHJOf5aIlvIKU35+EG32wrsWECHnxEA7uZh14o1RflBEK8gYnEO1xkjkcDbxoGNs2R6D7pNcf9+Hdtns60aIvVf6pg8KiQJYySf5CMk+5gZLQDjcixalRCO7cHf6oFJJPv4nE6JzO8D4EJAUVHV46jVYeOEvm1CYpHgAKp716i1XPbTIY+K64E2n0rtLxWqLzFvpM3WMLv+UZWC+uEVe/sxUKItal70W4ChDwcTv6qMsOjZ8OwPd7v5jSlQL5Zg92+mYzLL4IlBUp+wVxQO06UDIBbk8ZEVQ35chXaRtoI/EjxHfba3pj0Pne8JSsNzXaWqC+R+rM26lZXwKRK+vSy02Z0o5dgHcansKT3EP+pcuLQ23hvMtFqh5/jmIGLiSKos4vYgLDfw9gxghg+4vf+vMxGMafz0xC0g1GCq70zNoXpyfGy8i6rbbYKKW1CpgD7yhDnQrBevIi6VgVtJVfLr4Jb3getNrqeCK5IPlDsEWo9h0WpMzv67bHppqXeonXpYpUVZokYHcBgb34E0axc2yEbdzZrbweEQPtCDsj6zFRoeR2bYHwv+XkYySkaUn+EbxHkNhfYRfT7FdyFwbdl/RXndUTgsVnn54isxwS7cNJpuZWbv50+XPnY/MkbdcjFUG6I4l/wP2CNXaqCmWJQE37Lwkf0Lcxm7K0uItuuMvOE8QH1pRNDfo2/+GCADaFQQMZJuT8iw3X5ydnNZDNb3V+BIMMiD3kaO6P81F/bBGi2+sTMpEfoycbiDlL7bILeOyzbYH/Odo+Bm5HNQAC2il/zZyeI/v6kZB2awg2K0hMs42WarlnDX2M7PZP9hioA9UQ8wZ26dh419ZRGdaG0ZAh+wmZ5fXMOJcUUrtB5ckM/cpwNKcHM4hiMIEA/ZIuRLjaS2xOT
 4swZf+b5
 qpxNgLrA3gaU2+4yDwNwLLNld21OeVapJnikhV7LE5z3GePagkaruUwRYIItnqZyB41wOv4IKJyqqLJvOJazlF3l5icmZ6d44Xefm4i+x5OL5SVOoIuZupKWI6z4o8ezTxTVygdjNqA6ne+M4VUNY9us0jron4E3kx+aWppJ1PwEBmOOhOOFX5JtM9EsVIPKpQBPKlYrA/UQlNXGbmRWVDHZ7n3FQuyeey6DWGXCNzjZICdARE1m2DLkmxQY+tEGkBUJ/mdMh0IhpppDPw733x44IkGn/hlunDhD/T9WWwUZyk6MR/CNyxJA2ljwpiBaVVxs8LdI8bBYpQYmYaiu93XFiBmmWzb8N4CDkvdc2hxTaiLnsIZ7t9Uhihi0e1ut/Mvku/rL2eLXRHO1Frabadd4uKKjNVKmedtqkjyM+wbx0ZgDw4fr376EFHB8kOeHY5VDYAGddlpS3AbtUdKrvAlHc3nT6lk1c1P5sUIS21H7JYVJyw6gA3GW54MMVOVXvQs7nazzX8mBGgi9sSNXfY4kwvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 08:03), Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > The statistics interface now uses the debugfs API stubs directly, so
> > CONFIG_ZSMALLOC_STAT no longer controls any zsmalloc code.
> >
> > Remove the Kconfig entry. Replace the remaining CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> I wonder if we can just squash all 3 patches lol

I agree.  Let's have just one patch.

