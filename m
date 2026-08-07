Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA4BC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4560D6B007B; Fri,  7 Aug 2026 12:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406D66B0088; Fri,  7 Aug 2026 12:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5666B008C; Fri,  7 Aug 2026 12:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F225E6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:49:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8111A40112
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:49:55 +0000 (UTC)
X-FDA: 85075060350.02.0975F20
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A0D9100007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:49:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CL7e2+w0;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786121393;
	b=fA7G2GCeZRo6LaSPgG5mH8GvEnnmfTzZ5B9kw9d1txCk7CSnCP675YUMYXA4OehzJtUgbO
	uAI9C2t5Db3ljzD7XM52gaSLL32W+fnLwb/9PN+j88rsiRLBGyJfyA6ZmvgvV21XgzpLIX
	8e88aMNKF8mo2wx7eFBgKWql5VNOBes=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CL7e2+w0;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786121393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SornuVu2NmXRbU5LVfa6yVFqz1q6nG6dUrxGm5KidRc=;
	b=eIqLy4GD8YQic/G+f++BeeDGUNvRnUnvh6yYMxWLstsKJbOiwFb2EsfVK+0GGZefzHHMZd
	cmB3pVNHOTfFo1+Bq/pl79c+/vZEx11et65ENJMgD69ESHD3n5KNz/yMkECwh4KDR4WLUk
	6e++5hfsZC7YUCEHfsnQ/AT4sPUvVXA=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51a868b6962so36398501cf.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786121392; x=1786726192; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SornuVu2NmXRbU5LVfa6yVFqz1q6nG6dUrxGm5KidRc=;
        b=CL7e2+w0OP6CFx/r1SetaLhm1u2czYThw+tK9tiCQ4IJvg30b16w92xfBVwIQjk6FI
         DK9KiBIWl28Jj+aNVIhvLFZp/q4ZxYVoyuDe8jyEIi7OUjXV0wgbsPfO0IKG6pUitNrC
         nbmYJbqaqWrsKIIQEmHoEVAoI9yL47AuPuYZz8oORX9lWZD7PU3wjOlCIwqp1zrbQI+b
         IQJKss0womaqxQ6h64VoDyqMIODPf8M3EKz22fBGfo0JHW7zEWgpRTpcw7h2bOqso199
         C+h9ts4dqH4KbNtwL2oqhNv4/0H3wL2yxDzgzyzRoXMT0D0xuagr59QzwpjDI03Ke+pL
         9sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121392; x=1786726192;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SornuVu2NmXRbU5LVfa6yVFqz1q6nG6dUrxGm5KidRc=;
        b=Y1hmWehv+R9AXH37tw0DrBdAh99zGXkYRyppA6NmrZeB3mBdY7Jv7oEK1sYddJVsiJ
         ofiftzQN0GhmSnPjh5PA6RxqibseFtKX85zHpfKm8Abl6uoof/CL82Omxrt8dV4xJSLE
         rvWzkhhihqKQLVXCowHe+OHv44KNzoFCIZ+75yi2kHMNWBqzxiUr3XjHnT5nF8g0fdsh
         +Pvc8tpmyqzP+hgj3QF/8mli174rII2Hw5+3dgs7IFpCke1zDzQdKzxanyUQBcM6blR5
         8eI1GssMCzEgZ4us3dyajSKPK8v06BnAIEmr5bCbHux8bQWROfYGACQrdEKYGXgFb7Mj
         EAlg==
X-Forwarded-Encrypted: i=1; AHgh+Rq6Ln+ZDxpvMgwJ8Cgzr9sh3vggMQ5SbZ0ez2pMOWRhyRD75fPQLsmr0WXY1W6PL0Pl+x9XrdBX2A==@kvack.org
X-Gm-Message-State: AOJu0YwuKV1UK4w995Cd3PZHW6qnwCjG/Go8g9GZ4rG5EexqhIqRya1o
	f+uuVFR/0VcHm85vquvE3KBahKOZ3MB4wdyCMCQv9XFbOogXIKSoSS3U11858QCUPjs=
X-Gm-Gg: AR+sD126VmvFkX+BJd1Fm9CKIETcVLQidl5sbHUThzcoGBcD1iSRYLowqHkcHsOvYZ5
	Tqm10awGBnlIDAx5/tz7NDFjtq2Sq5HSK7U7Vs8laUzuC6DzG8B7q54NTKyIh3LOYE5bEJDIhZb
	fNHWYVlnV//C25C+GVeK6t5yrUeicLugVLsz3Usn/EhL+E/QMjbfe8dEQUv5q0BKyToFLle3XIx
	BY13PTzj1P2jyWr4R1nUBG46ax2i3BBgUEU1PXBEWiIHHoU3dAs35varzgKKaHDlUQMsiiAmBzA
	Vzgahb6nFgiqaO+LoONiZw/UJHR2koSHSdEbunhAr+Jd+LXigRjmfzr2g6Z2QJYG4v9S0TtDiII
	gs881y4fwYSB2eTXnusaZ6IgRZIgG9z04KlFZp0E0Vwf1Q0V/rC8r/Mm6pa6g9t7kbARUJrYTdM
	A1OOJTzisr2WoYR9JWUmMOsj4D7xFfyvxJEQ1uT29xQvkD3WuPIseSsdmtEfY=
X-Received: by 2002:a05:622a:578e:b0:51c:61a:50fa with SMTP id d75a77b69052e-52d20a7ac27mr28210301cf.39.1786121392310;
        Fri, 07 Aug 2026 09:49:52 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a918dd24sm12748156d6.8.2026.08.07.09.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:49:50 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:49:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/page_io: convert write completion handlers to
 folios
Message-ID: <anYMrST8NQ2ZT9gX@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A0D9100007
X-Stat-Signature: ada44bkfobwt3rzfxxo31eoym7nh14e1
X-Rspam-User: 
X-HE-Tag: 1786121393-176167
X-HE-Meta: U2FsdGVkX1+d4IINDg4yjcLTZDzptI2BEozr3akgEDF2vJauT0auQ50AFqiLfXcZehQv2Pm3ie3Tug1h16RHsgnWSASnQKD/ZZHXevg/cQOadZidHKzvQxOW/ypWW91eAVLFDX15oJ02mNSQEAzWh9HcVtX5SA82ERbirk1DuCfKNn3yzdm17TlGW89zG1Axu21HGE6UaGig1EWzzS9l3kTPr353Av6BUAUIMHTgZlW/3qaq+u5W0XPxW+cNw8drGN8c1Xq9BqYpQzMI2uMiMP5JDnpvOV3ytTJGKvFdhBt04aAnJhPIo3XWKwohUJ+dxGy9xcLz/4SEpyPnYnXmOOt/dkgIMHdh9ZGF9pRNhd2/AW2KRCGa48J9pCTzyh+NOFpP1EsU6VnFqLo8KAa5xLrib34aYpphofNubGMMvVMWQ3toOfVEoRELgF7kc+LENYRSU4JkigZsgG5ADvy+kCoxIRO/RRlx+3kOKvjgl05o4SKZ8PZRDdSidFCAN+9fr7E9xuvi3lYCrZTRfdLf0jkjXI+LdsgoDMv1lF9mS+y2d5L6EPsnnKmTcXMTPGMFwbknRiZOGpTX7M2UEQ/mBRYIMyteQ1PuiewgvJveelcMSUenZXeGrF2UIKVm2a1ea3uQLVUDEftKCOeDU/Gn/Zl1G2tH0CZFKAa7J/CNHrvlx5E/4Xkq1uPq1NCOTswsCP9q7hvadqUASCDKz1SXx7n4nn8wPnwi7qZaSBS+7o8+2OjWH9JJMYJyndgv1oNx/JK4DOw8jLVsMynZcr1hTCyijPJr9gb6nOInE+y6ZdcRCkmOENJKzizVEjJa9ALlrBKKIKl0dWvT98gZrNZ2WG7alUK0jqe3kpUpcnlwvhomcqaQU5XWYNz4nZZ88Kmv+Xl8KkWi7XB+C60D+mfsCF0O4n7ZfPoCX7JJ4xdiHxP9HlmlYolVhgusA5LL/WsxAgTZugcC+kXkOXZZV0U
 TWsYDj4+
 5ZW6dW2nrD3WIXpqp5o6e1fE0/FWD+vs8pvtHGRQBqnKcAckVemIIP97Rz0MYyEGIf7VLTlUucnrl0ULQpZzayq4mVKdxM0igVApAz0a7hFuxJzYLvVWD+RVmbx9xjpVwxroyW30b01MpbrOQlw3ABcchuH6p1CgsyFPI8hYMrcYik3VZ+0scmNgyZlXiMAA8rmbRnOqObLmdl8Qtxucu0jWWwTTVfMM+AmaEWb75LG9fsmCZZ+A1UnG9mPff2iXlTOA94/v6RK3VtGRzDKOf1n4r46QPS+vJx7gusruHAtbc0lp/7kEUg3e1aJkx0FSpvokPX2BTycb5hkU/F+UJdM1YHOtxyW7JrUHaj7oxUKAlfqqCfGENHMtTuqhiFd++X8hO8Dop25+800XYzxfWek2qqsF6XNtOEIi1Z8S3Ujw0ksbpbSwikUrsJoceoHpUcLLg0Fg6Zwt8uZDLlfd8ph/j081DsNLSdcmu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:33PM -0400, Tal Zussman wrote:
> Convert swap_write_end() and swap_fs_write_complete() to operate on
> folios directly instead of going through the folio-compat page APIs.
> This removes calls to end_page_writeback() and set_page_dirty(), and the
> last caller of ClearPageReclaim(), saving two calls to compound_head()
> per folio on the write error path.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Also the last end_page_writeback() user in mm/ :) Nice.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

